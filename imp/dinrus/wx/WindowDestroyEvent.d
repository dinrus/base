module wx.WindowDestroyEvent;
public import wx.common;
public import wx.CommandEvent;
public import wx.Window;
//-----------------------------------------------------------------------------

extern(D) class СобытиеРазрушьОкно : СобытиеКоманды
{
    public this(ЦелУкз вхобъ);
    public this(Окно ок = пусто);
    public Окно активен();
    //private static Событие Нов(ЦелУкз объ);
    //static this();
}
