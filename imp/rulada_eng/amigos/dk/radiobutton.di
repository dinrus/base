module amigos.dk.radiobutton;

import amigos.dk.widget;
import amigos.dk.options;

import std.string;


class Radiobutton:public Widget
{
  this(Widget master,string text,int value);

  void flash();
  void deselect();
  void select();
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
