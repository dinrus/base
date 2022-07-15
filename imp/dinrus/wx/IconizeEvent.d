module wx.IconizeEvent;
public import wx.common;
public import wx.Event;



extern(D) class СобытиеИконирования : Событие
{
    public this(ЦелУкз вхобъ);
    public this(цел идок = 0, бул иконирован = да);
    public бул иконирован();
    //private static Событие Нов(ЦелУкз объ);
    //static this();
}
