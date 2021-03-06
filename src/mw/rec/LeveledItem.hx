package mw.rec;

class LeveledItem extends Parsable {
  var name:ZString;
  var data:UInt32;
  var nnam:UInt8;
  var indx:Optional<UInt32>;
  var items:Group<{
    inam:ZString,
    intv:UInt16,
  }>;
}
