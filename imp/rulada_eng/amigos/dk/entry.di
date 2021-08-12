module amigos.dk.entry;

import amigos.dk.widget;
import amigos.dk.options;
import std.string;
extern(C):
class Entry: public Widget
{
  this(Widget master,string text="");

  /// Возращает введенный текст.
  string text();

  void clean();

  void text(string txt);
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
