package mw.rec;

class Clothing {
  public static function read(record:Record):Clothing {
    var ret = new Clothing();
    for (field in record.readFields()) switch (field.name) {
      case "NAME": ret.name = field.inp.readZString();
      case "MODL": ret.modl = field.inp.readZString();
      case "FNAM": ret.fnam = field.inp.readZString();
      case "CTDT": ret.ctdt = {
          type: field.inp.readInt32(),
          weight: field.inp.readFloat(),
          value: field.inp.readUInt16(),
          enchantmentPoints: field.inp.readUInt16(),
        };
      case "SCRI": ret.scri = field.inp.readZString();
      case "ITEX": ret.itex = field.inp.readZString();
      case "INDX": ret.indx.push(field.inp.readByte());
      case "BNAM": ret.bnam.push(field.inp.readZString());
      case "CNAM": ret.cnam.push(field.inp.readZString());
      case "ENAM": ret.enam = field.inp.readZString();
    }
    return ret;
  }

  public var name:String;
  public var modl:String;
  public var fnam:Null<String>;
  public var ctdt:{
    type:Int,
    weight:Float,
    value:Int,
    enchantmentPoints:Int,
  };
  public var scri:Null<String>;
  public var itex:Null<String>;
  public var indx:Array<Int> = [];
  public var bnam:Array<String> = [];
  public var cnam:Array<String> = [];
  public var enam:Null<String>;

  public function new() {}

  public function write(record:Record):Void {
    record.modifyData(field -> {
      field("NAME", out -> out.writeZString(name));
      field("MODL", out -> out.writeZString(modl));
      if (fnam != null) field("FNAM", out -> out.writeZString(fnam));
      field("CTDT", out -> {
        out.writeInt32(ctdt.type);
        out.writeFloat(ctdt.weight);
        out.writeUInt16(ctdt.value);
        out.writeUInt16(ctdt.enchantmentPoints);
      });
      if (scri != null) field("SCRI", out -> out.writeZString(scri));
      if (itex != null) field("ITEX", out -> out.writeZString(itex));
      if (indx.length != bnam.length || indx.length != cnam.length) throw "invalid length";
      for (i in 0...indx.length) {
        field("INDX", out -> out.writeByte(indx[i]));
        field("BNAM", out -> out.writeZString(bnam[i]));
        field("CNAM", out -> out.writeZString(cnam[i]));
      }
      if (enam != null) field("ENAM", out -> out.writeZString(enam));
    });
  }
}
