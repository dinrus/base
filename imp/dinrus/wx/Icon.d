module wx.Icon;
public import wx.common;
public import wx.Bitmap;

extern(D) class Пиктограмма : Битмап
{
    public static Пиктограмма НуллИконка;
    public this(ткст имя);
    public this(ткст имя, ПТипБитмап тип);
    public this();
    public this(ЦелУкз вхобъ);
    public проц копируйИзБитмапа(Битмап битмап);
}
