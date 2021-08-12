module wx.Pen;
public import wx.common;
public import wx.Defs;
public import wx.GDIObject;
public import wx.Colour;


extern(D) class Перо : ОбъектИГУ
{
    public static Перо КРАСНОЕ;
    public static Перо ЦЫАН;
    public static Перо ЗЕЛЁНОЕ;
    public static Перо ЧЁРНОЕ;
    public static Перо БЕЛОЕ;
    public static Перо ПРОЗРАЧНОЕ;
    public static Перо ЧЕРНОЕ_ПУНКТИРНОЕ;
    public static Перо СЕРОЕ;
    public static Перо МЕДИУМ_СЕРОЕ;
    public static Перо СВЕТЛО_СЕРОЕ;
    public static Перо НуллПеро;

    public this(ЦелУкз вхобъ);
    public this(ткст имя);
    public this(ткст имя, цел ширь);
    public this(ткст имя, цел ширь, ПСтильЗаливки стиль);
    public this(Цвет цвет);
    public this(Цвет цвет, цел ширь);
    public this(Цвет кол, цел ширь, ПСтильЗаливки стиль);
    public Цвет цвет();
    public проц цвет(Цвет значение);
    public цел ширь();
    public проц ширь(цел значение);
    public цел шапка();
    public проц шапка(цел значение);
    public цел соединение();
    public проц соединение(цел значение);
    public цел стиль();
    public проц стиль(цел значение);
    public бул Ок();
    static ВизОбъект Нов(ЦелУкз укз);
}
