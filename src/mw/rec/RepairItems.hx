package mw.rec;

class RepairItems extends Parsable {
  var name:ZString;
  var modl:ZString;
  var fnam:Optional<ZString>;
  var ridt:{
    weight:Float32,
    value:UInt32,
    uses:UInt32,
    quality:Float32,
  };
  var itex:Optional<ZString>;
  var scri:Optional<ZString>;
}
