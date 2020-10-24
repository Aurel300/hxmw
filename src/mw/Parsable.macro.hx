package mw;

import haxe.macro.Context;
import haxe.macro.Expr;

typedef Handled = {
  read:Expr,
  // clone:Expr,
  // write:Expr,
  mappedType:ComplexType,
};

class Parsable {
  public static function build():Array<Field> {
    var fields = Context.getBuildFields();
    var cls = Context.getLocalClass().get();
    var selfTp = {name: cls.name, pack: cls.pack};
    var selfCt = TPath(selfTp);

    function handleField(
      t:ComplexType,
      pos:Position
    ):Handled {
      var read:Expr;
      //var write:Expr;
      //var clone:Expr = macro $target = $source;
      //var opt = false;
      var mappedType:ComplexType;
      switch (t) {
        case TPath({name: "ZString", pack: []}):
          read = macro inp.readZString();
          mappedType = (macro : String);
        case TPath({name: "String", pack: []}):
          read = macro inp.readString(field.length);
          // write = macro out.writeString($target);
          mappedType = (macro : String);
        case TPath({name: "Int32" | "UInt32", pack: []}):
          read = macro inp.readInt32();
          // write = macro out.writeInt32($target);
          mappedType = (macro : Int);
        case TPath({name: "Int16" | "UInt16", pack: []}):
          // TODO: signedness
          read = macro inp.readUInt16();
          //write = macro out.writeUInt16($target);
          mappedType = (macro : Int);
        case TPath({name: "Int8" | "UInt8", pack: []}):
          // TODO: signedness
          read = macro inp.readByte();
          //write = macro out.writeByte($target);
          mappedType = (macro : Int);
        case TPath({name: "Float32", pack: []}):
          read = macro inp.readFloat();
          //write = macro out.writeFloat($target);
          mappedType = (macro : Float);
        case TPath({name: "Optional", pack: [], params: [TPType(sub)]}):
          var subHandled = handleField(sub, pos);
          read = subHandled.read;
          //opt = true;
          mappedType = TPath({name: "Null", pack: [], params: [TPType(subHandled.mappedType)]});
          /*
        case TPath({name: "Group", pack: [], params: [TPType(TAnonymous(sub))]}):
          var subFields = [];
          var preReads = [];
          var subCt = TAnonymous([ for (f in sub) switch (f.kind) {
            case FVar(t, _):
              var ident = '_group${tmpCounter++}';
              preReads.push(macro var $ident = []);
              var mappedType = handleField(macro $i{ident}, source, f.name, t, subFields, f.pos);
              {
                pos: f.pos,
                name: f.name,
                meta: [{name: ":optional", pos: f.pos}],
                kind: FVar(mappedType, null),
                access: [APublic],
              };
            case _: Context.fatalError("invalid field", f.pos);
          } ]);
          preRead = macro @:mergeBlock $b{preReads};
          read = macro {
            var _group:$subCt = {};
            // TODO: use pre-read
            $b{[ for (sub in subFields) sub.read.e ]};
            // TODO: post-read
            if ($target == null) $target = [];
            $target.push(_group);
          };
          clone = macro {};
          write = macro {};
          TPath({name: "Array", pack: [], params: [TPType(subCt)]});
          */
        case TAnonymous(sub):
          var subHandled = [ for (f in sub) switch (f.kind) {
            case FVar(t, _): handleField(t, f.pos);
            case _: Context.fatalError("invalid field", f.pos);
          } ];
          read = {expr: EObjectDecl([ for (i in 0...sub.length) {
            field: sub[i].name,
            expr: subHandled[i].read,
          } ]), pos: pos};
          //clone = macro {
          //  $target = {};
          //  $b{[ for (sub in subFields) sub.clone ]};
          //};
          //write = macro $b{[ for (sub in subFields) sub.write ]};
          mappedType = TAnonymous([ for (i in 0...sub.length) {
            name: sub[i].name,
            kind: FVar(subHandled[i].mappedType, null),
            pos: pos,
          } ]);
        case _: Context.fatalError("invalid type", pos);
      }
      return {
        read: read,
        mappedType: mappedType,
      };
    }

    var readerPre:Array<Expr> = [];
    var readerPost:Array<Expr> = [];
    var readerCases:Array<Case> = [];
    var tmpCounter = 0;
    fields = [ for (f in fields) switch (f.kind) {
      case FVar(t, _) if (f.access.contains(APublic) && !f.access.contains(AStatic)):
        {
          pos: f.pos,
          name: f.name,
          kind: FVar(switch (t) {
            case TPath({name: "Group", pack: [], params: [TPType(TAnonymous(sub))]}):
              var idents = [];
              var t = TPath({name: "Array", pack: [], params: [TPType(TAnonymous([ for (f in sub) switch (f.kind) {
                case FVar(t, _):
                  var handled = handleField(t, f.pos);
                  var ident = '_group${tmpCounter++}';
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
              t;
            case _:
              var handled = handleField(t, f.pos);
              readerCases.push({
                values: [macro $v{f.name.toUpperCase()}],
                expr: macro $p{["ret", f.name]} = $e{handled.read},
              });
              handled.mappedType;
          }, macro null),
          access: [APublic],
        };
      case _: f;
    } ];

    var readerSwitch = {expr: ESwitch(macro field.name, readerCases, null), pos: cls.pos};

    fields = fields.concat((macro class Parsable {
      public static function read(record:mw.Record):$selfCt {
        var ret = new $selfTp();
        @:mergeBlock $b{readerPre};
        for (field in record.readFields()) {
          var inp = field.inp;
          $readerSwitch;
        }
        @:mergeBlock $b{readerPost};
        return ret;
      }
      public function new() {}
      /*public function clone():$selfCt {
        var ret = new $selfTp();
        $b{[ for (field in recFields) field.clone ]};
        return ret;
      }*/
    }).fields);

    Sys.println(new haxe.macro.Printer().printField(fields[fields.length - 2]));

    return fields;
  }
}
