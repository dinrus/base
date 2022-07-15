module wx.PaintEvent;
public import wx.common;
public import wx.Event;

extern(D) class СобытиеРисования : Событие
{
    public this(ЦелУкз вхобъ);
    public this(цел ид = 0);
}
