module wx.Bitmap;
public import wx.common;
public import wx.GDIObject;
public import wx.Colour;
public import wx.Palette;
public import wx.Image;
public import wx.Icon;

extern(D) class Битмап : ОбъектИГУ
{
     public static Битмап НуллБитмап; // Его инциализует проц иницСтокОбъекты() из wx.GdiCommon,
	 //вызываемая в функции Приложение.иниц() в wx.App модуле.
	 //Работает ли она здесь? Пока не проверено.

    public this();
    public this(Рисунок рисунок);
    public this(Рисунок рисунок, цел глубь);
    public this(ткст имя);
    public this(ткст имя, ПТипБитмап тип);
    public this(цел ширь, цел высь);
    public this(цел ширь, цел высь, цел глубь);
    public this(Битмап битмап);
    public this(ЦелУкз вхобъ);
    public Рисунок преобразуйВРисунок();
    public цел высь();
    public проц высь(цел значение);
    public бул загрузиФайл(ткст имя, ПТипБитмап тип);
    public бул сохраниФайл(ткст имя, ПТипБитмап тип);
    public бул сохраниФайл(ткст имя, ПТипБитмап тип, Палитра палитра);
    public цел ширь();
    public проц ширь(цел значение);
    public  бул Ок();
    public цел глубь();
    public проц глубь(цел значение);
    public Битмап дайПодБитмап(Прямоугольник прям);
    public Маска маска();
    public проц маска(Маска значение);
    public Палитра палитра();
    public Палитра цветоКарта();
    public бул копируйИзПиктограммы(Пиктограмма пиктограмма);
    public static ВизОбъект Нов(ЦелУкз укз);
}

//---------------------------------------------------------------------

extern(D) class Маска : ВизОбъект
{
    public this();
    public this(Битмап битмап, Цвет цвет);
    public this(Битмап битмап, цел индексПалитры);
    public this(Битмап битмап);
    public this(ЦелУкз вхобъ);
    public бул создай(Битмап битмап, Цвет цвет);
    public бул создай(Битмап битмап, цел индексПалитры);
    public бул создай(Битмап битмап);
}
