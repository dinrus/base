module wx.FocusEvent;
public import wx.common;

public import wx.Window;
public import wx.Event;

//-----------------------------------------------------------------------------

extern(D) class СобытиеФокуса : Событие
{
    public this(ЦелУкз вхобъ);
    public this(ТипСобытия тип = Событие.Тип.СОБ_НУЛЛ, цел идок = 0);
    public Окно окно();
    public проц окно(Окно значение);
    //private static Событие Нов(ЦелУкз объ);
    // //static this();
}
