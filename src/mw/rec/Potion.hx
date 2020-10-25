package mw.rec;

class Potion extends Parsable {
  var name:ZString;
  var modl:Optional<ZString>;
  var text:Optional<ZString>;
  var scri:Optional<ZString>;
  var fnam:Optional<ZString>;
  var aldt:{
    weight:Float32,
    value:UInt32,
    flags:UInt32,
  };
  var enchantments:Group<{
    enam:{
      effectIndex:UInt16,
      skillAffected:Int8,
      attributeAffected:Int8,
      range:UInt32,
      area:UInt32,
      duration:UInt32,
      magnitudeMin:UInt32,
      magnitudeMax:UInt32,
    },
  }>;
}
