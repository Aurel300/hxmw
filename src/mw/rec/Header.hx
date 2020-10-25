package mw.rec;

class Header extends Parsable {
  var hedr:{
    version:Float32,
    flags:UInt32,
    company:StringPad<32>,
    description:StringPad<256>,
    recordCount:UInt32,
  };
  var masters:Group<{
    mast:ZString,
    data:UInt64,
  }>;
}
