module wx.ChildFocusEvent;
public import wx.common;

public import wx.CommandEvent;
public import wx.Window;

//-----------------------------------------------------------------------------

extern(D) class СобытиеФокусОтпрыска : СобытиеКоманды
{
    public this(ЦелУкз вхобъ);
    public this(Окно ок);
    public Окно окно();
    public static Событие Нов(ЦелУкз объ);
    // //static this();
}
