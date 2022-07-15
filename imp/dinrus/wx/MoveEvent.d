module wx.MoveEvent;
public import wx.common;
public import wx.Event;

//-------------------------------------------
extern(D) class СобытиеДвижения : Событие
{
    public this(ЦелУкз вхобъ);
    public this();
    public Точка позиция();
    //private static Событие Нов(ЦелУкз объ);
    ////static this();
}
//-------------------------------------------