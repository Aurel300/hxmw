package mw;

import haxe.io.Output;

class OutputTools {
  public static function writeZString(out:Output, s:String):Void {
    out.writeString(s);
    out.writeByte(0);
  }
}
