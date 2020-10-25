package mw.rec;

class LeveledCreature extends Parsable {
  var name:ZString;
  var data:UInt32;
  var nnam:UInt8;
  var indx:Optional<UInt32>;
  var creatures:Group<{
    cnam:ZString,
    intv:UInt16,
  }>;
}
