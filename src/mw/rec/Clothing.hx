package mw.rec;

class Clothing extends Parsable {
  public var name:ZString;
  public var modl:ZString;
  public var fnam:Optional<ZString>;
  public var ctdt:{
    type:Int32,
    weight:Float32,
    value:UInt16,
    enchantmentPoints:UInt16,
  };
  public var scri:Optional<ZString>;
  public var itex:Optional<ZString>;
  public var parts:Group<{
    indx:UInt8,
    bnam:Optional<String>,
    cnam:Optional<String>,
  }>;
  public var enam:Optional<ZString>;

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
      for (part in parts) {
        field("INDX", out -> out.writeByte(part.indx));
        if (part.bnam != null) field("BNAM", out -> out.writeZString(part.bnam));
        if (part.cnam != null) field("CNAM", out -> out.writeZString(part.cnam));
      }
      if (enam != null) field("ENAM", out -> out.writeZString(enam));
    });
  }
}
