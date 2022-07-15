module wx.NcPaintEvent;
public import wx.common;
public import wx.Event;
//-------------------------------------------
extern(D) class СобытиеРисованияНК : Событие
{
    public this(ЦелУкз вхобъ);
    public this(цел ид=0);
    //private static Событие Нов(ЦелУкз объ);
    ////static this();
}
//-------------------------------------------