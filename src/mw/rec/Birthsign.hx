package mw.rec;

class Birthsign extends Parsable {
  var name:ZString;
  var fnam:Optional<ZString>;
  var npcs:Group<{
    npcs:StringPad<32>
  }>;
  var tnam:Optional<ZString>;
  var desc:Optional<ZString>;
}
