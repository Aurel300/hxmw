package mw.rec;

class ProbeItems extends Parsable {
  var name:ZString;
  var modl:ZString;
  var fnam:Optional<ZString>;
  var pbdt:{
    weight:Float32,
    value:UInt32,
    quality:Float32,
    uses:UInt32,
  };
  var itex:Optional<ZString>;
  var scri:Optional<ZString>;
}
