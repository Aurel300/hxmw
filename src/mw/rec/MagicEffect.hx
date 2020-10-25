package mw.rec;

class MagicEffect extends Parsable {
  var indx:UInt32;
  var medt:{
    spellSchool:UInt32,
    baseCost:Float32,
    flags:UInt32,
    red:UInt32,
    green:UInt32,
    blue:UInt32,
    speedX:Float32,
    sizeX:Float32,
    sizeCap:Float32,
  };
  var itex:Optional<ZString>;
  var ptex:Optional<ZString>;
  var bsnd:Optional<ZString>;
  var csnd:Optional<ZString>;
  var hsnd:Optional<ZString>;
  var asnd:Optional<ZString>;
  var cvfx:Optional<ZString>;
  var bvfx:Optional<ZString>;
  var hvfx:Optional<ZString>;
  var avfx:Optional<ZString>;
  var desc:Optional<String>;
}
