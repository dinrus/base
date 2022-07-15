module wx.VScroll;
public import wx.common;
public import wx.Panel;
public import wx.SizeEvent;

extern(D)  abstract class ОкноСВПрокруткой : Панель
{
    public this(ЦелУкз вхобъ);
    public this();
    public this(Окно родитель, цел ид /*= ЛЮБОЙ*/, Точка поз = ДЕФПОЗ, Размер размер = ДЕФРАЗМ, цел стиль=0, ткст имя = СтрИмениПанели);
    public this(Окно родитель, Точка поз = ДЕФПОЗ, Размер размер = ДЕФРАЗМ, цел стиль=0, ткст имя = СтрИмениПанели);
    public override бул создай(Окно родитель, цел ид, inout Точка поз, inout Размер размер, цел стиль, ткст имя);
    static extern(C) цел staticOnGetLineHeight(ОкноСВПрокруткой объ, цел ч);
    protected abstract цел приПолученииВысотыСтроки(цел ч);
    public проц счётСтрок(цел значение);
    public цел счётСтрок() ;
    public проц прокрутиДоСтроки(цел строка);
    public override бул прокрутиСтроки(цел строки);
    public override бул прокрутиСтраницы(цел страницы);
    public проц освежиСтроку(цел строка);
    public проц освежиСтроки(цел от, цел до);
    public цел тестНажатия(цел x, цел y);
    public цел тестНажатия(Точка тчк);
    public  проц освежиВсе();
    public цел дайПервВидимуюСтроку();
    public цел дайПоследнВидимуюСтроку();
    public бул виден(цел строка);
}
