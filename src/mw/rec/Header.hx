package mw.rec;

class Header {
  public static function read(record:Record):Header {
    var ret = new Header();
    for (field in record.readFields()) switch (field.name) {
      case "HEDR": ret.hedr = {
          version: field.inp.readFloat(),
          flags: field.inp.readInt32(),
          company: field.inp.read(32),
          description: field.inp.read(256),
          recordCount: field.inp.readInt32(),
        };
      case "MAST": ret.mast.push(field.inp.readZString());
      case "DATA": ret.data.push([field.inp.readInt32(), field.inp.readInt32()]);
    }
    return ret;
  }

  public var hedr:{
    version:Float,
    flags:Int,
    company:Bytes,
    description:Bytes,
    recordCount:Int,
  };
  public var mast:Array<String> = [];
  public var data:Array<Array<Int>> = [];

  public function new() {}

  public function write(record:Record):Void {
    record.modifyData(field -> {
      field("HEDR", out -> {
        out.writeFloat(hedr.version);
        out.writeInt32(hedr.flags);
        out.write(hedr.company);
        out.write(hedr.description);
        out.writeInt32(hedr.recordCount);
      });
      if (mast.length != data.length) throw "invalid length";
      for (i in 0...mast.length) {
        field("MAST", out -> out.writeZString(mast[i]));
        field("DATA", out -> {
          out.writeInt32(data[i][0]);
          out.writeInt32(data[i][1]);
        });
      }
    });
  }
}
