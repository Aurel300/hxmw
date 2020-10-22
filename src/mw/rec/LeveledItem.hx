package mw.rec;

class LeveledItem {
  public static function read(record:Record):LeveledItem {
    var ret = new LeveledItem();
    for (field in record.readFields()) switch (field.name) {
      case "NAME": ret.name = field.inp.readZString();
      case "DATA": ret.data = field.inp.readInt32();
      case "NNAM": ret.nnam = field.inp.readByte();
      case "INDX": ret.indx = field.inp.readInt32();
      case "INAM": ret.inam.push(field.inp.readZString());
      case "INTV": ret.intv.push(field.inp.readUInt16());
    }
    return ret;
  }

  public var name:String;
  public var data:Int;
  public var nnam:Int;
  public var indx:Null<Int>;
  public var inam:Array<String> = [];
  public var intv:Array<Int> = [];

  public function new() {}

  public function write(record:Record):Void {
    record.modifyData(field -> {
      field("NAME", out -> out.writeZString(name));
      field("DATA", out -> out.writeInt32(data));
      field("NNAM", out -> out.writeByte(nnam));
      if (indx != null) field("INDX", out -> out.writeInt32(indx));
      if (inam.length != intv.length) throw "invalid length";
      for (i in 0...inam.length) {
        field("INAM", out -> out.writeZString(inam[i]));
        field("INTV", out -> out.writeUInt16(intv[i]));
      }
    });
  }
}
