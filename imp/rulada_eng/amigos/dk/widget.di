module amigos.dk.widget;

import amigos.dk.options;
import amigos.dk.event;
import amigos.dk.callback;
import amigos.dk.utils;
import amigos.dk.tcl;

import std.io;
import std.c;
import std.string;


public const string HORIZONTAL="horizontal";
public const string VERTICAL="vertical";

extern(C):
/*
   Основной класс для всех виджетов, включая Tk.
 */
class Widget
{
  this(Widget master,string wname,Options opt);

  this(Widget master,string wname,Options opt,Callback c);

  this();

  string name();

  void exit();
  
  Tcl_Interp* interp();

  void pack();

  string pack(string a1,string a2,string args...);

  string pure_eval(string cmd);

  string eval(string cmd) ;

  string cget(string key);

  string configure(string key,string value);

  void cfg(Options o);
  
  void clean();

  void bind(string event,Callback cb);
protected:
  Tcl_Interp *m_interp;
  string      m_name="";
  static int  m_cur_widget=0;
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
