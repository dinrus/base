module wx.CommandEvent;
public import wx.common;
public import wx.Event;

public import wx.ClientData;


//-----------------------------------------------------------------------------

extern(D) class СобытиеКоманды : Событие
{

    public this(ЦелУкз вхобъ);
    public this(ТипСобытия типКоманды = Событие.Тип.СОБ_НУЛЛ, цел идок = 0);
    public цел выбор();
    public ткст вТкст();
    public проц вТкст(ткст значение);
    public бул отмечен();
    public бул выделение_ли();
    public цел вЦел();
    public проц вЦел(цел значение);
    public ДанныеКлиента объКлиента();
    public проц ОбъектКлиент(ДанныеКлиента значение);
    public цел экстраДол();
    public проц экстраДол(цел значение);
    //private static Событие Нов(ЦелУкз объ);
    ////static this();
}
