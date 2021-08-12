module wx.DisplayChangedEvent;

public import wx.common;
public import wx.Event;

//-----------------------------------------------------------------------------

extern(D) class СобытиеСменыДисплея : Событие
{
    public this(ЦелУкз вхобъ);
    public this();
    //private static Событие Нов(ЦелУкз объ);
    //static this();
}
