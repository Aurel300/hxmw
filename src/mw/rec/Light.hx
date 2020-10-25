package mw.rec;

class Light extends Parsable {
  var name:ZString;
  var modl:ZString;
  var fnam:Optional<ZString>;
  var itex:Optional<ZString>;
  var lhdt:{
    weight:Float32,
    value:UInt32,
    time:Int32,
    radius:UInt32,
    colour:Rgb,
    flags:UInt32,
  };
  var snam:Optional<ZString>;
  var scri:Optional<ZString>;
}
