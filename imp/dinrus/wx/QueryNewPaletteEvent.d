module wx.QueryNewPaletteEvent;
public import wx.common;
public import wx.Event;

extern(D) class СобытиеЗапросаНовойПалитры : Событие
{
    public this(ЦелУкз вхобъ);
    public this(цел идок=0);
    public бул реализовано();
    public проц реализовано(бул значение);
    //private static Событие Нов(ЦелУкз объ);
    ////static this();
}
