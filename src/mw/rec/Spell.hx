package mw.rec;

class Spell extends Parsable {
  var name:ZString;
  var fnam:Optional<ZString>;
  var spdt:{
    type:UInt32,
    spellCost:UInt32,
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
    }
  }>;
}
