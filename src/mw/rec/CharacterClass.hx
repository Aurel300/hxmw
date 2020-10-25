package mw.rec;

class CharacterClass extends Parsable {
  var name:ZString;
  var fnam:ZString;
  var cldt:{
    primaryAttributes:Repeat<UInt32, 2>,
    specialisation:UInt32,
    skills:Repeat<UInt32, 10>,
    flags:UInt32,
    autocalcFlags:UInt32,
  };
  var desc:Optional<ZString>;
}
