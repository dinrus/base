module amigos.dk.listbox;

import amigos.dk.widget;
import amigos.dk.options;

import std.string;
import std.conv;

class Listbox: public Widget
{
  this(Widget master);
  
  void insert(int index,string[] elements);
  
  void del(int from,int to);

  int size() ;

  string get(int index);
  
  int curselection();
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
