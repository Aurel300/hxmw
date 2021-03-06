package mw.rec;

class Clothing extends Parsable {
  var name:ZString;
  var modl:ZString;
  var fnam:Optional<ZString>;
  var ctdt:{
    type:UInt32,
    weight:Float32,
    value:UInt16,
    enchantmentPoints:UInt16,
  };
  var scri:Optional<ZString>;
  var itex:Optional<ZString>;
  var parts:Group<{
    indx:UInt8,
    bnam:Optional<String>,
    cnam:Optional<String>,
  }>;
  var enam:Optional<ZString>;
}
