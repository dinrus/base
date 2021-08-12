module wx.Colour;
public import wx.common;

//---------------------------------------------------------------------

extern(D) class Цвет : ВизОбъект
{
    
    public static Цвет ЧЁРНЫЙ;
    public static Цвет БЕЛЫЙ;
    public static Цвет КРАСНЫЙ;
    public static Цвет СИНИЙ;
    public static Цвет ЗЕЛЁНЫЙ;
    public static Цвет ЦЫАН;
    public static Цвет СВЕТЛО_СЕРЫЙ;
    public static Цвет НуллЦвет;
    
    public this(ЦелУкз вхобъ);
    public this(ЦелУкз вхобъ, бул памСобств);
    public this();
    public this(ткст имя);
    public this(ббайт красный, ббайт зелёный, ббайт синий);
    public override проц вымести();
    public ббайт красный();
    public ббайт зелёный();
    public ббайт синий();
    public бул Ок();
    public проц установи(ббайт красный, ббайт зелёный, ббайт синий);
    version(__ГТК__)
    {
         public static Цвет создайПоИмени(ткст имя);
    } // version(__ГТК__)

    public static ВизОбъект Нов(ЦелУкз укз);
}
