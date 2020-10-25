package mw.rec;

class Region extends Parsable {
  var name:ZString;
  var fnam:ZString;
  var weat:{
    clear:UInt8,
    cloudy:UInt8,
    foggy:UInt8,
    overcast:UInt8,
    rain:UInt8,
    thunder:UInt8,
    ash:UInt8,
    blight:UInt8,
    snow:UInt8,
    blizzard:UInt8,
  };
  var bnam:Optional<ZString>;
  var cnam:Rgb;
  var soundChances:Group<{
    snam:{
      soundName:StringPad<32>,
      chance:UInt8,
    },
  }>;
}
