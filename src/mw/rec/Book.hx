package mw.rec;

class Book extends Parsable {
  var name:ZString;
  var modl:ZString;
  var fnam:Optional<ZString>;
  var bkdt:{
    weight:Float32,
    value:UInt32,
    flags:UInt32,
    skillID:Int32,
    enchantmentPoints:UInt32,
  };
  var scri:Optional<ZString>;
  var itex:Optional<ZString>;
  var text:Optional<String>;
  var enam:Optional<ZString>;
}
