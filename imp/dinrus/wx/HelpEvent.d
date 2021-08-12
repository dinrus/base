module wx.HelpEvent;
public import wx.common;
public import wx.CommandEvent;
public import wx.Window;

//-----------------------------------------------------------------------------

extern(D) class СобытиеСправки : СобытиеКоманды
{
    public this(ЦелУкз вхобъ);
    public this(ТипСобытия тип = Тип.СОБ_НУЛЛ, цел идок = 0, Точка поз = Окно.ДЕФПОЗ);
    public Точка позиция();
    public проц позиция(Точка значение);
    public ткст ссылка();
    public проц ссылка(ткст значение);
    public ткст цель();
    public проц цель(ткст значение);
    //private static Событие Нов(ЦелУкз объ);
    // //static this();
}
