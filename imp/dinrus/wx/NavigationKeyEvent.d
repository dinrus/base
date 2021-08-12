module wx.NavigationKeyEvent;
public import wx.common;
public import wx.Event;
public import wx.Window;
//-------------------------------------------
extern(D) class СобытиеКлавишиНавигации : Событие
{
    public this(ЦелУкз вхобъ);
    public this();
    public бул направление();
    public проц направление(бул значение);
    public бул изменениеОкна();
    public проц изменениеОкна(бул значение);
    public Окно текущФокус();
    public проц текущФокус(Окно значение);
    public проц флаги(цел значение);
    //private static Событие Нов(ЦелУкз объ);
    ////static this();
}
//-------------------------------------------