package mw.rec;

class Faction extends Parsable {
  var name:ZString;
  var fnam:ZString;
  var rankNames:Group<{
    rnam:ZString,
  }>;
  var fadt:{
    attributes:Repeat<UInt32, 2>,
    rankData:Repeat<{
      attributeModifiers:Repeat<UInt32, 2>,
      primarySkillModifier:UInt32,
      favouredSkillModifier:UInt32,
      factionReactionModified:UInt32,
    }, 10>,
    skills:Repeat<Int32, 7>,
    flags:UInt32,
  };
  var reactionAdjustments:Group<{
    anam:String,
    intv:Int32,
  }>;
}
