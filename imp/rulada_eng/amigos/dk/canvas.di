module amigos.dk.canvas;

import amigos.dk.widget;
import amigos.dk.options;
import amigos.dk.utils;
import std.io;
import std.conv;
import std.string;

const string default_fill_color = "black";

class Tag:public Widget
{
  this(Canvas parent,string tag);
 protected:
  Canvas m_canvas;
}

class Canvas:public Widget
{
  this(Widget master,int width=100,int height=100);

  void clear();

  string line(int[] coords...);

  string line(string fill,int[] coords...);

  string oval(string fill,int x0,int y0,int x1,int y1,string args="");
  
  string oval(int x0,int y0,int x1,int y1,string args="");
  
  string text(string color,string txt,int x,int y);

  string text(string txt,int x,int y);

  string rectangle(string color,int[] coords);

  string rectangle(int[] coords);


  Tag addtag(string tag,string command,string args);

  string cdelete(string tag);

  string cdelete(Tag tag);
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
