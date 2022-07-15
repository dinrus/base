module wx.ContextMenuEvent;
public import wx.common;

public import wx.CommandEvent;
public import wx.Window;

//-----------------------------------------------------------------------------

extern(D) class СобытиеКонтекстногоМеню : СобытиеКоманды
{
    public this(ЦелУкз вхобъ);
    public this(ТипСобытия тип = Тип.СОБ_НУЛЛ, цел идок = 0,Точка тчк = Окно.ДЕФПОЗ);
    public Точка позиция();
    public проц позиция(Точка значение);
    //private static Событие Нов(ЦелУкз объ);
    ////static this();
}
