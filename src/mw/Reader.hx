package mw;

import haxe.io.Bytes;
import haxe.io.Input;

class Reader {
  public static function read(inp:Input):Plugin {
    inp.bigEndian = false;
    return [ while (true) try readRecord(inp) catch (e:Dynamic) break ];
  }

  static function readRecord(inp:Input):Record {
    var ret = new Record();
    ret.type = inp.readString(4);
    ret.length = inp.readInt32();
    ret.pad = inp.readInt32();
    ret.flags = inp.readInt32();
    ret.data = inp.read(ret.length);
    return ret;
  }

  public static function parsePlugin(plugin:Plugin):ParsedPlugin {
    return [ for (record in plugin) {
      record: record,
      kind: (switch (record.type) {
        case "CLOT": Clothing(mw.rec.Clothing.read(record));
        case "TES3": Header(mw.rec.Header.read(record));
        case "LEVI": LeveledItem(mw.rec.LeveledItem.read(record));
        case "SPEL": Spell(mw.rec.Spell.read(record));
        case _: Unknown;
      }),
    } ];
  }
}
