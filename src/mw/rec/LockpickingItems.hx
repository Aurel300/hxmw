package mw.rec;

class LockpickingItems extends Parsable {
  var name:ZString;
  var modl:ZString;
  var fnam:Optional<ZString>;
  var lkdt:{
    weight:Float32,
    value:UInt32,
    quality:Float32,
    uses:UInt32,
  };
  var scri:Optional<ZString>;
  var itex:Optional<ZString>;
}
