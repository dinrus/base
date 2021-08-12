module wx.Palette;
public import wx.common;
public import wx.GDIObject;

extern(D) class Палитра : ОбъектИГУ
{
    public static Палитра НуллПалитра;

    public this();
    public this(ЦелУкз вхобъ);
    public this(цел ч, inout ббайт к, inout ббайт з, inout ббайт с);
    public бул создай(цел ч, inout ббайт к, inout ббайт з, inout ббайт с);
    //public static ВизОбъект Нов(ЦелУкз укз);
    public бул Ок();
    public цел дайПиксель(ббайт красный, ббайт зелёный, ббайт синий);
    public бул дайКЗС(цел пиксель, out ббайт красный, out ббайт зелёный, out ббайт синий);
}

