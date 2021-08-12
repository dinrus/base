module wx.UpdateUIEvent;
public import wx.common;
public import wx.CommandEvent;
public import wx.Window;

//-----------------------------------------------------------------------------

extern(D) class СобытиеОбновлениеГИ : СобытиеКоманды
{
    public this(ЦелУкз вхобъ);
    public this(цел идКоманды = 0);
    public проц активен(бул значение);
    public проц отметь(бул значение);
    public static бул можноОбновить(Окно окно);
    public бул отмечен();
    public бул дайАктивирован();
    public бул устОтмечен();
    public бул устАктивирован();
    public бул устТекст();
    public ткст текст();
    public проц текст(ткст значение);
    static ПРежимОбновленияГИ режим();
    static проц режим(ПРежимОбновленияГИ значение);
    static цел интервалОбновления();
    static проц интервалОбновления(цел значение);
    public static проц сбросьВремяОбновления();
    //private static Событие Нов(ЦелУкз объ);
    //static this();
}
