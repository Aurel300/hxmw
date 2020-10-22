package mw;

class Constants {
  public static final HDR_AUTH_LENGTH = 32;
  public static final HDR_DESC_LENGTH = 256;
}

/**
  The flags field of the AIDT subrecord is for SERVICES offered by this actor
 */
enum abstract AIDT(Int) from Int to Int {
  var Weapon = 0x00001;
  var Armor = 0x00002;
  var Clothing = 0x00004;
  var Books = 0x00008;
  var Ingredient = 0x00010;
  var Picks = 0x00020;
  var Probes = 0x00040;
  var Lights = 0x00080;
  var Apparatus = 0x00100;
  var Repair = 0x00200;
  var Misc = 0x00400;
  var Spells = 0x00800;
  var MagicItems = 0x01000;
  var Potions = 0x02000;
  var Training = 0x04000;
  var Spellmaking = 0x08000;
  var Enchanting = 0x10000;
  var RepairItem = 0x20000;
}
