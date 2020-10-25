package mw.rec;

class Land extends Parsable {
  var intv:{
    x:Int32,
    y:Int32,
  };
  var data:UInt32;
  var vnml:Optional<Repeat<{
    x:Int8,
    y:Int8,
    z:Int8,
  }, 4225 /* 65 * 65 */>>;
  var vhgt:Optional<{
    heightOffset:Float32,
    heightData:Repeat<Int8, 4225>,
    junk:Repeat<UInt8, 3>,
  }>;
  var wnam:Optional<Repeat<UInt8, 81>>;
  var vclr:Repeat<Int8, 12675 /* 65 * 65 * 3 */>;
  var vtex:Repeat<UInt16, 256>;
}
