package mw;

import haxe.macro.Context;
import haxe.macro.Expr;

typedef Handled = {
  read:Expr,
  clone:Expr,
  write:Expr->Expr,
  mappedType:ComplexType,
  opt:Bool,
};

class Parsable {
  public static function build():Array<Field> {
    var fields = Context.getBuildFields();
    var cls = Context.getLocalClass().get();
    var selfTp = {name: cls.name, pack: cls.pack};
    var selfCt = TPath(selfTp);

    function simplifySource(e:Expr):Expr {
      return (switch (e.expr) {
        case EBlock([
          {expr: EVars([{name: "_source", expr: source}])},
          {expr: EConst(CIdent("_source"))},
        ]): source;
        case _: e;
      });
    }

    function handleField(
      t:ComplexType,
      pos:Position
    ):Handled {
      var read:Expr;
      var clone:Expr = macro _source;
      var write:Expr->Expr;
      var opt = false;
      var mappedType:ComplexType;
      switch (t) {
        case TPath({name: "ZString", pack: []}):
          read = macro inp.readZString();
          write = e -> macro out.writeZString($e);
          mappedType = (macro : String);
        case TPath({name: "String", pack: []}):
          read = macro inp.readString(field.length);
          write = e -> macro out.writeString($e);
          mappedType = (macro : String);
        case TPath({name: "StringPad", pack: [], params: [TPExpr({expr: EConst(CInt(Std.parseInt(_) => width))})]}):
          read = macro new haxe.io.BytesInput(inp.read($v{width})).readZString();
          write = e -> macro {
            var _bytes = haxe.io.Bytes.alloc($v{width});
            var _str = haxe.io.Bytes.ofString($e);
            _bytes.blit(0, _str, 0, _str.length);
            out.write(_bytes);
          };
          mappedType = (macro : String);
        case TPath({name: "Int64" | "UInt64", pack: []}):
          read = macro {
            var low = inp.readInt32();
            var high = inp.readInt32();
            haxe.Int64.make(high, low);
          };
          write = e -> macro {
            out.writeInt32($e.low);
            out.writeInt32($e.high);
          };
          mappedType = (macro : haxe.Int64);
        case TPath({name: "Int32" | "UInt32", pack: []}):
          read = macro inp.readInt32();
          write = e -> macro out.writeInt32($e);
          mappedType = (macro : Int);
        case TPath({name: "Int16" | "UInt16", pack: []}):
          // TODO: signedness
          read = macro inp.readUInt16();
          write = e -> macro out.writeUInt16($e);
          mappedType = (macro : Int);
        case TPath({name: "Int8" | "UInt8" | "Char", pack: []}):
          // TODO: signedness
          read = macro inp.readByte();
          write = e -> macro out.writeByte($e);
          mappedType = (macro : Int);
        case TPath({name: "Float32", pack: []}):
          read = macro inp.readFloat();
          write = e -> macro out.writeFloat($e);
          mappedType = (macro : Float);
        case TPath({name: "Rgb", pack: []}):
          read = macro {
            var _rgb = inp.readInt32();
            {red: _rgb & 0xFF, green: (_rgb >> 8) & 0xFF, blue: (_rgb >> 16) & 0xFF};
          };
          write = e -> macro out.writeInt32(($e.red & 0xFF) | (($e.green & 0xFF) << 8) | (($e.blue & 0xFF) << 16));
          mappedType = (macro : {red:Int, green:Int, blue:Int});
        case TPath({name: "Optional", pack: [], params: [TPType(sub)]}):
          var subHandled = handleField(sub, pos);
          read = subHandled.read;
          write = subHandled.write;
          opt = true;
          mappedType = TPath({name: "Null", pack: [], params: [TPType(subHandled.mappedType)]});
        case TPath({name: "Repeat", pack: [], params: [TPType(sub), TPExpr({expr: EConst(CInt(Std.parseInt(_) => count))})]}):
          var subHandled = handleField(sub, pos);
          read = macro throw "unimplemented";
          write = e -> macro throw "unimplemented";
          mappedType = TPath({name: "Array", pack: [], params: [TPType(subHandled.mappedType)]});
        case TAnonymous(sub):
          var subHandled = [ for (f in sub) switch (f.kind) {
            case FVar(t, _): handleField(t, f.pos);
            case _: Context.fatalError("invalid field", f.pos);
          } ];
          read = {expr: EObjectDecl([ for (i in 0...sub.length) {
            field: sub[i].name,
            expr: subHandled[i].read,
          } ]), pos: pos};
          clone = {expr: EObjectDecl([ for (i in 0...sub.length) {
            field: sub[i].name,
            expr: simplifySource(macro {
              var _source = $p{["_source", sub[i].name]};
              $e{subHandled[i].clone};
            }),
          } ]), pos: pos};
          write = e -> macro $b{[ for (i in 0...sub.length) {
            var field = sub[i].name;
            subHandled[i].write(macro $e.$field);
          } ]};
          mappedType = TAnonymous([ for (i in 0...sub.length) {
            name: sub[i].name,
            kind: FVar(subHandled[i].mappedType, null),
            pos: pos,
          } ]);
        case _: Context.fatalError("invalid type", pos);
      }
      return {
        read: read,
        clone: clone,
        write: write,
        mappedType: mappedType,
        opt: opt,
      };
    }

    var readerPre:Array<Expr> = [];
    var readerPost:Array<Expr> = [];
    var readerCases:Array<Case> = [];
    var cloner:Array<Expr> = [];
    var writer:Array<Expr> = [];
    var tmpCounter = 0;
    fields = [ for (f in fields) switch (f.kind) {
      case FVar(t, _) if (f.access.length == 0):
        {
          pos: f.pos,
          name: f.name,
          kind: FVar(switch (t) {
            case TPath({name: "Group", pack: [], params: [TPType(TAnonymous(sub))]}):
              var idents = [];
              var subHandled = [];
              var t = TPath({name: "Array", pack: [], params: [TPType(TAnonymous([ for (f in sub) switch (f.kind) {
                case FVar(t, _):
                  var ident = '_group${tmpCounter++}';
                  var handled = handleField(t, f.pos);
                  readerPre.push(macro var $ident = []);
                  readerCases.push({
                    values: [macro $v{f.name.toUpperCase()}],
                    expr: macro $i{ident}.push($e{handled.read}),
                  });
                  /*if (idents.length > 0) {
                    readerPost.push(macro {
                      if ($i{idents[0]}.length != $i{ident}.length) {
                        throw "length mismatch (" + $v{sub[0].name} + ": " + $i{idents[0]}.length + ", " + $v{f.name} + ": " + $i{ident}.length + ")";
                      }
                    });
                  }*/
                  idents.push(ident);
                  subHandled.push(handled);
                  {
                    pos: f.pos,
                    name: f.name,
                    kind: FVar(handled.mappedType, null),
                    access: [APublic],
                  };
                case _: Context.fatalError("invalid field", f.pos);
              } ]))]});
              readerPost.push(macro $p{["ret", f.name]} = [ for (i in 0...$i{idents[0]}.length) $e{{
                expr: EObjectDecl([ for (i in 0...sub.length) {
                  field: sub[i].name,
                  expr: macro $i{idents[i]}[i],
                } ]),
                pos: f.pos,
              }} ]);
              cloner.push(macro $p{["ret", f.name]} = $p{["_source", f.name]}.map(_source -> $e{{
                expr: EObjectDecl([ for (i in 0...sub.length) {
                  field: sub[i].name,
                  expr: simplifySource(macro {
                    var _source = $p{["_source", sub[i].name]};
                    $e{subHandled[i].clone};
                  }),
                } ]),
                pos: f.pos,
              }}));
              writer.push(macro for (_source in $p{["this", f.name]}) $b{[ for (i in 0...sub.length) {
                if (subHandled[i].opt) {
                  macro if ($p{["_source", sub[i].name]} != null)
                    field($v{sub[i].name.toUpperCase()}, out -> $e{subHandled[i].write(macro $p{["_source", sub[i].name]})});
                } else {
                  macro
                    field($v{sub[i].name.toUpperCase()}, out -> $e{subHandled[i].write(macro $p{["_source", sub[i].name]})});
                }
              } ]});
              t;
            case _:
              var handled = handleField(t, f.pos);
              readerCases.push({
                values: [macro $v{f.name.toUpperCase()}],
                expr: macro $p{["ret", f.name]} = $e{handled.read},
              });
              cloner.push(macro $p{["ret", f.name]} = $e{simplifySource(macro {
                var _source = $p{["_source", f.name]};
                $e{handled.clone};
              })});
              if (handled.opt) {
                writer.push(macro if ($p{["this", f.name]} != null)
                  field($v{f.name.toUpperCase()}, out -> $e{handled.write(macro $p{["this", f.name]})}));
              } else {
                writer.push(macro
                  field($v{f.name.toUpperCase()}, out -> $e{handled.write(macro $p{["this", f.name]})}));
              }
              handled.mappedType;
          }, macro null),
          access: [APublic],
        };
      case _: f;
    } ];

    fields = fields.concat((macro class Parsable {
      public static function read(record:mw.Record):$selfCt {
        var ret = new $selfTp();
        @:mergeBlock $b{readerPre};
        for (field in record.readFields()) {
          var inp = field.inp;
          $e{{expr: ESwitch(macro field.name, readerCases, macro throw "unknown field"), pos: cls.pos}};
        }
        @:mergeBlock $b{readerPost};
        return ret;
      }
      public function new() {}
      public function clone():$selfCt {
        var ret = new $selfTp();
        var _source = this;
        $b{cloner};
        return ret;
      }
      public function write(record:Record):Void {
        record.modifyData(field -> $b{writer});
      }
    }).fields);

    //Sys.println(new haxe.macro.Printer().printField(fields[fields.length - 1]));

    return fields;
  }
}
