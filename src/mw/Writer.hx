package mw;

import haxe.io.Bytes;
import haxe.io.Output;

class Writer {
  public static function write(out:Output, plugin:Plugin):Void {
    out.bigEndian = false;
    for (record in plugin) {
      writeRecord(out, record);
    }
  }

  static function writeRecord(out:Output, record:Record):Void {
    out.writeString(record.type);
    out.writeInt32(record.length);
    out.writeInt32(record.pad);
    out.writeInt32(record.flags);
    out.write(record.data);
  }

  public static function packPlugin(plugin:ParsedPlugin):Plugin {
    return [ for (record in plugin) {
      var packed = record.record.clone();
      switch (record.kind) {
        case Clothing(data): data.write(packed);
        case Header(data):
          data.hedr.recordCount = plugin.length - 1;
          data.write(packed);
        case LeveledItem(data): data.write(packed);
        case Spell(data): data.write(packed);
        case Unknown:
      }
      packed;
    } ];
  }
}
