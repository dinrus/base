module amigos.dk.scale;

import amigos.dk.widget;
import amigos.dk.options;
import std.conv;
import std.string;

class Scale: public Widget
{
  this(Widget master,string text);
  
  int get();

  void set(int value) ;
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
