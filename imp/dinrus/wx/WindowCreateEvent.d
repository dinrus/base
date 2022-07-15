module wx.WindowCreateEvent;
public import wx.common;
public import wx.CommandEvent;
public import wx.Window;

//-----------------------------------------------------------------------------

extern(D) class СобытиеСоздатьОкно : СобытиеКоманды
{
    public this(ЦелУкз вхобъ);
    public this(Окно ок = пусто);
    public Окно активен();
    //private static Событие Нов(ЦелУкз объ);
    //static this();
}
