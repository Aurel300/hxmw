package mw;

typedef ParsedPlugin = Array<ParsedRecord>;

typedef ParsedRecord = {
  ?record:Record,
  kind:ParsedRecordKind,
};

enum ParsedRecordKind {
  Activator(_:mw.rec.Activator);
  AlchemyApparatus(_:mw.rec.AlchemyApparatus);
  Armour(_:mw.rec.Armour);
  Birthsign(_:mw.rec.Birthsign);
  BodyParts(_:mw.rec.BodyParts);
  Book(_:mw.rec.Book);
  CharacterClass(_:mw.rec.CharacterClass);
  Clothing(_:mw.rec.Clothing);
  Container(_:mw.rec.Container);
  Door(_:mw.rec.Door);
  Enchantment(_:mw.rec.Enchantment);
  Faction(_:mw.rec.Faction);
  GameSetting(_:mw.rec.GameSetting);
  Global(_:mw.rec.Global);
  Header(_:mw.rec.Header);
  Ingredient(_:mw.rec.Ingredient);
  Land(_:mw.rec.Land);
  LandTexture(_:mw.rec.LandTexture);
  LeveledCreature(_:mw.rec.LeveledCreature);
  LeveledItem(_:mw.rec.LeveledItem);
  Light(_:mw.rec.Light);
  LockpickingItems(_:mw.rec.LockpickingItems);
  MagicEffect(_:mw.rec.MagicEffect);
  MiscItem(_:mw.rec.MiscItem);
  Potion(_:mw.rec.Potion);
  ProbeItems(_:mw.rec.ProbeItems);
  // Race(_:mw.rec.Race);
  Region(_:mw.rec.Region);
  RepairItems(_:mw.rec.RepairItems);
  Sound(_:mw.rec.Sound);
  SoundGenerator(_:mw.rec.SoundGenerator);
  Spell(_:mw.rec.Spell);
  StartScript(_:mw.rec.StartScript);
  Static(_:mw.rec.Static);
  Unknown;
}
