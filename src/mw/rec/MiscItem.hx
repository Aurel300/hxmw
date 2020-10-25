package mw.rec;

class MiscItem extends Parsable {
  var name:ZString;
  var modl:ZString;
  var fnam:Optional<ZString>;
  var mcdt:{
    weight:Float32,
    value:UInt32,
    unknown:UInt32,
  };
  var scri:Optional<ZString>;
  var itex:Optional<ZString>;
}
