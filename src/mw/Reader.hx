package mw;

import haxe.io.Bytes;
import haxe.io.Input;
import mw.rec.*;

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
        case "ACTI": Activator(Activator.read(record));
        case "ALCH": Potion(Potion.read(record));
        case "APPA": AlchemyApparatus(AlchemyApparatus.read(record));
        case "ARMO": Armour(Armour.read(record));
        case "BODY": BodyParts(BodyParts.read(record));
        case "BOOK": Book(Book.read(record));
        case "BSGN": Birthsign(Birthsign.read(record));
        // case "CELL":
        case "CLAS": CharacterClass(CharacterClass.read(record));
        case "CLOT": Clothing(Clothing.read(record));
        case "CONT": Container(Container.read(record));
        // case "CREA":
        // case "DIAL":
        case "DOOR": Door(Door.read(record));
        case "ENCH": Enchantment(Enchantment.read(record));
        case "FACT": Faction(Faction.read(record));
        case "GLOB": Global(Global.read(record));
        case "GMST": GameSetting(GameSetting.read(record));
        // case "INFO":
        case "INGR": Ingredient(Ingredient.read(record));
        case "LAND": Land(Land.read(record));
        case "LEVC": LeveledCreature(LeveledCreature.read(record));
        case "LEVI": LeveledItem(LeveledItem.read(record));
        case "LIGH": Light(Light.read(record));
        case "LOCK": LockpickingItems(LockpickingItems.read(record));
        case "LTEX": LandTexture(LandTexture.read(record));
        case "MGEF": MagicEffect(MagicEffect.read(record));
        case "MISC": MiscItem(MiscItem.read(record));
        // case "NPC_":
        // case "PGRD":
        case "PROB": ProbeItems(ProbeItems.read(record));
        // case "RACE": Race(Race.read(record));
        case "REGN": Region(Region.read(record));
        case "REPA": RepairItems(RepairItems.read(record));
        // case "SCPT":
        // case "SKIL":
        case "SNDG": SoundGenerator(SoundGenerator.read(record));
        case "SOUN": Sound(Sound.read(record));
        case "SPEL": Spell(Spell.read(record));
        case "SSCR": StartScript(StartScript.read(record));
        case "STAT": Static(Static.read(record));
        case "TES3": Header(Header.read(record));
        // case "WEAP":
        case _: Unknown;
      }),
    } ];
  }
}
