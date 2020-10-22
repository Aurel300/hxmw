package mw.rec;

class Spell {
  public static function read(record:Record):Spell {
    var ret = new Spell();
    for (field in record.readFields()) switch (field.name) {
      case "NAME": ret.name = field.inp.readZString();
      case "FNAM": ret.fnam = field.inp.readZString();
      case "SPDT": ret.spdt = {
          type: field.inp.readInt32(),
          spellCost: field.inp.readInt32(),
          flags: field.inp.readInt32(),
        };
      case "ENAM": ret.enam.push({
          effectIndex: field.inp.readUInt16(),
          skillAffected: field.inp.readInt8(),
          attributeAffected: field.inp.readInt8(),
          range: field.inp.readInt32(),
          area: field.inp.readInt32(),
          duration: field.inp.readInt32(),
          magnitudeMin: field.inp.readInt32(),
          magnitudeMax: field.inp.readInt32(),
        });
    }
    return ret;
  }

  public var name:String;
  public var fnam:Null<String>;
  public var spdt:{
    type:Int,
    spellCost:Int,
    flags:Int,
  };
  public var enam:Array<{
    effectIndex:Int,
    skillAffected:Int,
    attributeAffected:Int,
    range:Int,
    area:Int,
    duration:Int,
    magnitudeMin:Int,
    magnitudeMax:Int,
  }> = [];

  public function new() {}

  public function write(record:Record):Void {
    record.modifyData(field -> {
      field("NAME", out -> out.writeZString(name));
      if (fnam != null) field("FNAM", out -> out.writeZString(fnam));
      field("SPDT", out -> {
        out.writeInt32(spdt.type);
        out.writeInt32(spdt.spellCost);
        out.writeInt32(spdt.flags);
      });
      for (e in enam) {
        field("ENAM", out -> {
          out.writeUInt16(e.effectIndex);
          out.writeInt8(e.skillAffected);
          out.writeInt8(e.attributeAffected);
          out.writeInt32(e.range);
          out.writeInt32(e.area);
          out.writeInt32(e.duration);
          out.writeInt32(e.magnitudeMin);
          out.writeInt32(e.magnitudeMax);
        });
      }
    });
  }
}
