package mw;

import haxe.io.Bytes;
import haxe.io.Input;
import haxe.io.Output;

class Record {
  public static function create(type:String):Record {
    var ret = new Record();
    ret.type = type;
    ret.length = 0;
    ret.pad = 0;
    ret.flags = 0;
    ret.data = null;
    return ret;
  }

  public var type:String;
  public var length:Int;
  public var pad:Int;
  public var flags:Int;
  public var data:Bytes;

  public function new() {}

  public function clone():Record {
    var ret = new Record();
    ret.type = type;
    ret.length = length;
    ret.pad = pad;
    ret.flags = flags;
    ret.data = data.sub(0, data.length);
    return ret;
  }

  public function readFields():Iterator<{name:String, inp:Input}> {
    var inp = new haxe.io.BytesInput(data);
    var done = false;
    var nextName = try inp.readString(4) catch (e:Dynamic) { done = true; null; };
    return {
      hasNext: () -> !done,
      next: () -> {
        var length = inp.readInt32();
        var ret:{name:String, inp:Input} = {
          name: nextName,
          inp: new haxe.io.BytesInput(inp.read(length)),
        };
        nextName = try inp.readString(4) catch (e:Dynamic) { done = true; null; };
        ret;
      }
    };
  }

  public function modifyData(f:(field:(name:String, ff:Output->Void)->Void)->Void):Void {
    var out = new haxe.io.BytesOutput();
    f(function(name:String, ff:Output->Void):Void {
      out.writeString(name);
      var fout = new haxe.io.BytesOutput();
      ff(fout);
      var data = fout.getBytes();
      out.writeInt32(data.length);
      out.write(data);
    });
    data = out.getBytes();
    length = data.length;
  }
}
