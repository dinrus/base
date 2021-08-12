module wx.SizeEvent;
public import wx.common;
public import wx.Event;

//-----------------------------------------------------------------------------

extern(D) class СобытиеРазмера : Событие
{
    public this(ЦелУкз вхобъ);
    public this();
    public this(wx.common.Размер рм,цел идок = 0);
    public this(Прямоугольник прям,цел идок = 0);
    public Размер размер();
    public Прямоугольник прям();
    public проц прям(Прямоугольник прям);
    //private static Событие Нов(ЦелУкз объ);
    //static this();
}
