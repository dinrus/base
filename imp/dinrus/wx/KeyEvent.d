module wx.KeyEvent;
public import wx.common;
public import wx.Event;

//-----------------------------------------------------------------------------

extern(D) class СобытиеКлавиатуры : Событие
{
    public this(ЦелУкз вхобъ);
    public this(ТипСобытия тип = Событие.Тип.СОБ_НУЛЛ);
    public бул ктрлВнизу();
    public бул метаВнизу();
    public бул шифтВнизу();
    public бул альтВнизу();
    public цел кодКл();
    public цел сыройКодКл();
    public цел флагиСыройКл();
    public бул естьМодификаторы();
    public Точка позиция();
    public цел Х();
    public цел У();
    public бул кмдВнизу();
    //private static Событие Нов(ЦелУкз объ);
    ////static this();
}
