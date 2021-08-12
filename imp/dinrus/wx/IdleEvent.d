module wx.IdleEvent;
public import wx.common;

public import wx.Event;
public import wx.Window;

public enum ПРежимБездействия
{
    ПроцессВсе,
    ПроцессУказанный
}

extern(D) class СобытиеБездействия : Событие
{
    public this(ЦелУкз вхобъ);
    public this();
    public проц запросиЕщё();
    public проц запросиЕщё(бул нужноЕщё);
    public бул ещёЗапрошено();
    static ПРежимБездействия режим();
    static проц режим(ПРежимБездействия значение);
    public static бул можноОтправить(Окно ок);
    //private static Событие Нов(ЦелУкз объ);
    // //static this();
}
