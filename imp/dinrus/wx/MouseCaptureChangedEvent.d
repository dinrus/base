module wx.MouseCaptureChangedEvent;

public import wx.common;
public import wx.Event;
public import wx.Window;
//-------------------------------------------
extern(D) class СобытиеИзмененияЗахватаМышью : Событие
{
    public this(ЦелУкз вхобъ);
    public this(цел идок = 0, Окно полученЗахват = пусто);
    public Окно захваченноеОкно();
    //private static Событие Нов(ЦелУкз объ);
    // //static this();
}
//-------------------------------------------
