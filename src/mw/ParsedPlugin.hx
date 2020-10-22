package mw;

typedef ParsedPlugin = Array<ParsedRecord>;

typedef ParsedRecord = {
  record:Record,
  kind:ParsedRecordKind,
};

enum ParsedRecordKind {
  Clothing(_:mw.rec.Clothing);
  Header(_:mw.rec.Header);
  LeveledItem(_:mw.rec.LeveledItem);
  Spell(_:mw.rec.Spell);
  Unknown;
}
