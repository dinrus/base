module amigos.dk.callback;

import amigos.dk.utils;
import amigos.dk.event;
import amigos.dk.widget;
import amigos.dk.tcl;
import std.io;
import std.c;
import std.string;

alias void delegate(Widget,Event) Callback;

struct Command{Widget   w; Callback c;}

alias  Command[int]  CallbackMap;
static CallbackMap   callbacks;
static int           callbackId=0;
const  string        callbackPrefix="dkinter::call";

extern (C)
int callbackHandler(ClientData cd,Tcl_Interp *interp,
		    int objc, Tcl_Obj ** objv);

extern (C):
void callbackDeleter(ClientData cd);

int addCallback(Widget wid,Callback clb);

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
