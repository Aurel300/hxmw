package mw.rec;

class BodyParts extends Parsable {
  var name:ZString;
  var modl:ZString;
  var fnam:ZString;
  var bydt:{
    part:UInt8,
    vampire:UInt8,
    flags:UInt8,
    partType:UInt8,
  };
}
