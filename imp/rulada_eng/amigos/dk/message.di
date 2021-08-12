module amigos.dk.message;

import amigos.dk.widget;
import amigos.dk.options;

class Message: public Widget
{
  this(Widget master,string text);
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
