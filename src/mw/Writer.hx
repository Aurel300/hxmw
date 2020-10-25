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
      var packed = record.record != null ? record.record.clone() : null;
      inline function id(id:String):Void {
        if (packed == null) packed = Record.create(id);
      }
      switch (record.kind) {
        case Activator(data): id("ACTI"); data.write(packed);
        case Potion(data): id("ALCH"); data.write(packed);
        case AlchemyApparatus(data): id("APPA"); data.write(packed);
        case Armour(data): id("ARMO"); data.write(packed);
        case BodyParts(data): id("BODY"); data.write(packed);
        case Book(data): id("BOOK"); data.write(packed);
        case Birthsign(data): id("BSGN"); data.write(packed);
        // case "CELL":
        case CharacterClass(data): id("CLAS"); data.write(packed);
        case Clothing(data): id("CLOT"); data.write(packed);
        case Container(data): id("CONT"); data.write(packed);
        // case "CREA":
        // case "DIAL":
        case Door(data): id("DOOR"); data.write(packed);
        case Enchantment(data): id("ENCH"); data.write(packed);
        case Faction(data): id("FACT"); data.write(packed);
        case Global(data): id("GLOB"); data.write(packed);
        case GameSetting(data): id("GMST"); data.write(packed);
        // case "INFO":
        case Ingredient(data): id("INGR"); data.write(packed);
        case Land(data): id("LAND"); data.write(packed);
        case LeveledCreature(data): id("LEVC"); data.write(packed);
        case LeveledItem(data): id("LEVI"); data.write(packed);
        case Light(data): id("LIGH"); data.write(packed);
        case LockpickingItems(data): id("LOCK"); data.write(packed);
        case LandTexture(data): id("LTEX"); data.write(packed);
        case MagicEffect(data): id("MGEF"); data.write(packed);
        case MiscItem(data): id("MISC"); data.write(packed);
        // case "NPC_":
        // case "PGRD":
        case ProbeItems(data): id("PROB"); data.write(packed);
        // case Race(data): id("RACE"); data.write(packed);
        case Region(data): id("REGN"); data.write(packed);
        case RepairItems(data): id("REPA"); data.write(packed);
        // case "SCPT":
        // case "SKIL":
        case SoundGenerator(data): id("SNDG"); data.write(packed);
        case Sound(data): id("SOUN"); data.write(packed);
        case Spell(data): id("SPEL"); data.write(packed);
        case StartScript(data): id("SSCR"); data.write(packed);
        case Static(data): id("STAT"); data.write(packed);
        // case "WEAP":

        case Header(data):
          id("TES3");
          data.hedr.recordCount = plugin.length - 1;
          data.write(packed);
        case Unknown:
          if (packed == null) throw "Unknown record with no data";
      }
      packed;
    } ];
  }
}
