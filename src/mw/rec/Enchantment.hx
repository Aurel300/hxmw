package mw.rec;

class Enchantment extends Parsable {
  var name:ZString;
  var endt:{
    type:UInt32,
    enchantmentCost:UInt32,
    charge:UInt32,
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
