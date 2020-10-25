package mw.rec;

class AlchemyApparatus extends Parsable {
  var name:ZString;
  var modl:ZString;
  var fnam:ZString;
  var scri:Optional<ZString>;
  var aadt:{
    type:UInt32,
    quality:Float32,
    weight:Float32,
    value:UInt32,
  };
  var itex:Optional<ZString>;
}
