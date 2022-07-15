module wx.ShowEvent;
public import wx.common, wx.Event;

//-----------------------------------------------------------------------------

extern(D) class СобытиеПоказа : Событие
{
    public this(ЦелУкз вхобъ);
    public this(цел идок = 0, бул показ = нет);
    public бул показ();
    public проц показ(бул значение);
    //private static Событие Нов(ЦелУкз объ);
    //static this();
}
