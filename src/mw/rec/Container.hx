package mw.rec;

class Container extends Parsable {
  var name:ZString;
  var modl:ZString;
  var fnam:Optional<ZString>;
  var cndt:Float32;
  var flag:UInt32;
  var npco:{
    objectCount:UInt32,
    objectName:StringPad<32>,
  };
  var scri:Optional<ZString>;
}
