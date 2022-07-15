module wx.Brush;
public import wx.common;
public import wx.Bitmap;

//---------------------------------------------------------------------

extern(D) class Кисть : ОбъектИГУ
{
    public static Кисть СИНЯЯ;
    public static Кисть ЗЕЛЁНАЯ;
    public static Кисть БЕЛАЯ;
    public static Кисть ЧЁРНАЯ;
    public static Кисть СЕРАЯ;
    public static Кисть МЕДИУМ_СЕРАЯ;
    public static Кисть СВЕТЛО_СЕРАЯ;
    public static Кисть ПРОЗРАЧНАЯ;
    public static Кисть ЦЫАН;
    public static Кисть КРАСНАЯ;
    public static Кисть НуллКисть;
// Эти константы инциализует проц иницСтокОбъекты() из wx.GdiCommon,
	 //вызываемая в функции Приложение.иниц() в wx.App модуле.
	 //Работает ли она здесь? Пока не проверено.	
	 //Здесь реализован альтернативный метод инициализации:
	 //ЭКСПЕРИМЕНТАЛЬНАЯ ИНИЦИАЛИЗАЦИЯ!!!
/+
    static this()
    {
        СИНЯЯ = синяя();
        ЗЕЛЁНАЯ = зелёная();
        БЕЛАЯ = белая();
        ЧЁРНАЯ = чёрная();
        СЕРАЯ = серая();
        МЕДИУМ_СЕРАЯ = среднеСерая();
        СВЕТЛО_СЕРАЯ = светлоСерая();
        ПРОЗРАЧНАЯ = прозрачная();
        ЦЫАН = цыан();
        КРАСНАЯ = красная();
    }

     public this();

    public static Кисть синяя();
    public static Кисть зелёная();
    public static Кисть белая();
    public static Кисть чёрная();
    public static Кисть серая();
    public static Кисть среднеСерая();
    public static Кисть светлоСерая();
    public static Кисть прозрачная();
    public static Кисть цыан();
    public static Кисть красная();
	+/
    public this(ЦелУкз вхобъ);
    public this(Цвет цвет);
    public this(Цвет цвет, ПСтильЗаливки стиль);
    public this(Битмап стиплБмп);
    public this(ткст имя);
    public this(ткст имя, ПСтильЗаливки стиль);
    public бул Ок();
    public ПСтильЗаливки стиль();
    public проц стиль(ПСтильЗаливки значение);
    public Битмап пунктир();
    public проц пунктир(Битмап значение);
    public Цвет цвет();
    public проц цвет(Цвет значение);
}
