package mw.rec;

class Sound extends Parsable {
  var name:ZString;
  var fnam:ZString;
  var data:{
    volume:UInt8,
    minRange:UInt8,
    maxRange:UInt8,
  };
}
