module amigos.dk.button;

import amigos.dk.widget;
import amigos.dk.callback;
import amigos.dk.options;

alias Button Кнопка;
class Button:public Widget
{
alias flash вспышка;

  this(Widget master,string text,Callback callback);

  void flash() ;
  void tkButtonEnter();
  void tkButtonLeave();
  void tkButtonDown() ;
  void tkButtonUp()  ;
  void tkButtonInvoke()   ;
}


version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
