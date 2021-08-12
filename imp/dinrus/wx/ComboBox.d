module wx.ComboBox;
public import wx.common;
public import wx.Control;
public import wx.ClientData;

//---------------------------------------------------------------------

extern(D) class КомбоБокс : Контрол
{
    public const цел КБ_ПРОСТОЙ           = 0x0004;
    public const цел КБ_СОРТИРУЮЩИЙ             = 0x0008;
    public const цел КБ_ТОЛЬКОЧТЕНИЕ         = 0x0010;
    public const цел КБ_ЗАБРОС         = 0x0020;

    public const ткст СтрИмениКомбоБокса = "comboBox";

    public this(ЦелУкз вхобъ);
    public this();
    public this(Окно родитель, цел ид, ткст значение="", Точка поз = ДЕФПОЗ, Размер размер = ДЕФРАЗМ, ткст[] выборы = пусто, цел стиль = 0, Оценщик знач = пусто, ткст имя = СтрИмениКомбоБокса);
    ////public static ВизОбъект Нов(ЦелУкз вхобъ);
    public this(Окно родитель);
    public this(Окно родитель, ткст значение="", Точка поз = ДЕФПОЗ, Размер размер = ДЕФРАЗМ, ткст[] выборы = пусто, цел стиль = 0, Оценщик знач = пусто, ткст имя = СтрИмениКомбоБокса);
    public бул создай(Окно родитель, цел ид, ткст значение,
                               Точка поз, Размер размер,
                               ткст[] выборы, цел стиль, Оценщик оценщик,
                               ткст имя);
    public цел выделение();
    public проц выделение(цел значение);
    public ткст выделениеТекста();
    public проц выделениеТекста(ткст значение);
    public цел счёт();
    public ткст дайТкст(цел ч);
    public ДанныеКлиента дайДанныеКлиента(цел ч);
    public проц устДанныеКлиента(цел ч, ДанныеКлиента данные);
    public цел найдиТкст(ткст стр);
    public проц удали(цел ч);
    public проц очисть();
    public проц добавь(ткст элт);
    public проц добавь(ткст элт, ДанныеКлиента данные);
    public проц копируй();
    public проц вырежи();
    public проц вставь();
    public цел точкаВставки();
    public проц точкаВставки(цел значение);
    public проц устКонецТочкиВставки();
    public цел дайПоследнПоз();
    public проц замени(цел от, цел до, ткст значение);
    public проц устВыделение(цел от, цел до);
    public проц устВыделение(цел ч);
    public проц рисуйНевидимо(бул значение);
    public проц удали(цел от, цел до);
    public ткст значение();
    public проц значение(ткст значение);
    public проц выдели(цел ч);
    public проц добавьВыбран(ДатчикСобытий значение);
    public проц удалиВыбран(ДатчикСобытий значение);
}

