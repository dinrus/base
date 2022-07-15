module wx.ImageList;
public import wx.common;
public import wx.Bitmap;
public import wx.DC;

// Flag values for установи/дайСписокРисунков
enum
{
    wxIMAGE_LIST_NORMAL, // Normal icons
    wxIMAGE_LIST_SMALL,  // Small icons
    wxIMAGE_LIST_STATE   // состояние icons: unimplemented (see WIN32 documentation)
}

//---------------------------------------------------------------------


extern(D) class СписокРисунков : ВизОбъект
{
    public const цел ОТРИСОВКА_НОРМАЛЬНО	= 0x0001;
    public const цел ОТРИСОВКА_ПРОЗРАЧНО	= 0x0002;
    public const цел ОТРИСОВКА_ВЫДЕЛЕННО	= 0x0004;
    public const цел ОТРИСОВКА_ФОКУСИРОВАННО	= 0x0008;

    public this(цел ширь, цел высь, бул маска = да, цел исхСчёт=1);
    public this(ЦелУкз вхобъ);
    public this();
    //public static ВизОбъект Нов(ЦелУкз укз);
    public цел добавь(Битмап битмап);
    public цел добавь(Битмап битмап, Битмап маска);
    public цел добавь(Пиктограмма пиктограмма);
    public цел добавь(Битмап бмп, Цвет цветМаски);
    public бул создай(цел ширь, цел высь);
    public бул создай(цел ширь, цел высь, бул маска);
    public бул создай(цел ширь, цел высь, бул маска, цел исхСчёт);
    public цел члоРисунков();
    public бул рисуй(цел индекс, КонтекстУстройства ку, цел x, цел y);
    public бул рисуй(цел индекс, КонтекстУстройства ку, цел x, цел y, цел флаги);
    public бул рисуй(цел индекс, КонтекстУстройства ку, цел x, цел y, цел флаги, бул плотныйФон);
    public бул замени(цел индекс, Битмап битмап);
    public бул удали(цел индекс);
    public бул удалиВсе();
    public бул дайРазмер(цел индекс, inout цел ширь, inout цел высь);
}
