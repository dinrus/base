module amigos.dk.spinbox;

import amigos.dk.options;
import amigos.dk.widget;

class Spinbox: public Widget
{
  this(Widget master);
  
  string get();
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
