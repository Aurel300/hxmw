package mw;

import haxe.io.Input;

class InputTools {
  public static function readZString(inp:Input):String {
    return inp.readUntil(0);
  }
}
