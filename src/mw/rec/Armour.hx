package mw.rec;

class Armour extends Parsable {
  var name:ZString;
  var modl:ZString;
  var fnam:Optional<ZString>;
  var scri:Optional<ZString>;
  var aodt:{
    type:UInt32,
    weight:Float32,
    value:UInt32,
    health:UInt32,
    enchantmentPoints:UInt32,
    armourRating:UInt32,
  };
  var itex:Optional<ZString>;
  var parts:Group<{
    indx:UInt8,
    bnam:Optional<String>,
    cnam:Optional<String>,
  }>;
  var enam:Optional<ZString>;
}
