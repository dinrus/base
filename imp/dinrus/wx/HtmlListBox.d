module wx.HtmlListBox;
public import wx.common;
public import wx.VLBox;


extern(D)  abstract class БоксСпискаГЯР : БоксВСписка
{
    public this(ЦелУкз вхобъ);
    public this();
    public this(Окно родитель, цел ид /*= ЛЮБОЙ*/, Точка поз = ДЕФПОЗ, Размер размер = ДЕФРАЗМ, цел стиль = 0, ткст имя=СтрИмениБоксаВСписка);
    public this(Окно родитель, Точка поз = ДЕФПОЗ, Размер размер = ДЕФРАЗМ, цел стиль = 0, ткст имя=СтрИмениБоксаВСписка);
    public override бул создай(Окно родитель, цел ид, inout Точка поз, inout Размер размер, цел стиль, ткст имя);
    static extern(C) проц staticRefreshAll(БоксСпискаГЯР объ);
    public override проц освежиВсе();
    static extern(C) проц staticУстItemCount(БоксСпискаГЯР объ,цел счёт);
    public  проц устСчётЭлтов(цел счёт);
    static extern(C) ткст staticOnGetItem(БоксСпискаГЯР объ,цел ч);
    protected abstract ткст приПолученииЭлта(цел ч);
    static extern(C)  ткст staticOnGetItemMarkup(БоксСпискаГЯР объ,цел ч);
    protected  ткст приПолученииМаркапаЭлта(цел ч);
    static extern(C)  ЦелУкз staticDoGetSelectedTextColour(БоксСпискаГЯР объ,ЦелУкз цветПП);
    protected  Цвет дайЦветВыделенногоТекста(Цвет цветПП);
    static extern(C)  ЦелУкз staticDoGetSelectedTextBgColour(БоксСпискаГЯР объ, ЦелУкз цветЗП);
    protected  Цвет дайЦветФонаВыделенногоТекста(Цвет цветЗП);
    static extern(C)  проц staticDoOnDrawItem(БоксСпискаГЯР объ, ЦелУкз ку, inout Прямоугольник прям, цел ч);
    protected override проц приОтрисовкеЭлта(КонтекстУстройства ку, Прямоугольник прям, цел ч);
    static extern(C)  цел staticOnMeasureItem(БоксСпискаГЯР объ, цел ч);
    protected override цел приОбмереЭлта(цел ч);
    protected проц приПеремере(СобытиеРазмера соб);
    protected проц иниц();
    protected проц кэшируйЭлт(цел ч);
    protected override проц приОтрисовкеРазделителя(КонтекстУстройства ку, Прямоугольник прям, цел ч);
    static extern(C)  проц staticDoOnDrawSeparator(БоксСпискаГЯР объ,ЦелУкз ку, inout Прямоугольник прям, цел ч);
    protected override проц приОтрисовкеФона(КонтекстУстройства ку, Прямоугольник прям, цел ч);
    static extern(C)  проц staticDoOnDrawBackground(БоксСпискаГЯР объ,ЦелУкз ку, inout Прямоугольник прям, цел ч);
    protected override цел приПолученииВысотыСтроки(цел строка);
    static extern(C)  цел staticOnGetLineHeight(БоксСпискаГЯР объ, цел строка);

}
