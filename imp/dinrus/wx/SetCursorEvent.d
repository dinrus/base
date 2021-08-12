
module wx.SetCursorEvent;
public import wx.common, wx.Event, wx.Cursor;

//-----------------------------------------------------------------------------

extern(D) class СобытиеУстановкиКурсора : Событие
{
    public this(ЦелУкз вхобъ);
    public this(цел x=0,цел y=0);
    public цел Х();
    public цел У();
    public Курсор курсор();
    public проц курсор(Курсор значение);
    public бул естьКурсор();
    //private static Событие Нов(ЦелУкз объ);
    //static this();
}
