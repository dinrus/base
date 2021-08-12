module wx.EraseEvent;
public import wx.common;

public import wx.Event;
public import wx.DC;

//-----------------------------------------------------------------------------

extern(D) class СобытиеСтирания : Событие
{
    public this(ЦелУкз вхобъ);
    public this(цел ид=0, КонтекстУстройства ку = пусто);
    public КонтекстУстройства дайКУ();
    //private static Событие Нов(ЦелУкз объ);
    ////static this();
}
