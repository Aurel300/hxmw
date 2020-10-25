package mw.rec;

class Ingredient extends Parsable {
  var name:ZString;
  var modl:ZString;
  var fnam:Optional<ZString>;
  var irdt:{
    weight:Float32,
    value:UInt32,
    effectIndex:Repeat<Int32, 4>,
    skillID:Repeat<Int32, 4>,
    attributeID:Repeat<Int32, 4>,
  };
  var scri:Optional<ZString>;
  var itex:Optional<ZString>;
}
