module wx.PaletteChangedEvent;
public import wx.common;
public import wx.Event;
public import wx.Window;

//-----------------------------------------------------------------------------

extern(D) class СобытиеИзмененаПалитра : Событие
{
    public this(ЦелУкз вхобъ);
    public this(цел идок=0);
    public Окно изменённоеОкно();
    public проц изменённоеОкно(Окно значение);
    //private static Событие Нов(ЦелУкз объ);
    ////static this();
}
