module wx.Printer;
public import wx.common;
public import wx.Window;
public import wx.PrintData;

public enum ПОшибкаПринтера
{
    Нет = 0,
    Отменено,
    Ошибка
}

//-----------------------------------------------------------------------------
extern(D) class Принтер : ВизОбъект
{
    //private this(ЦелУкз вхобъ);
    public this();
    public this(ДанныеДиалогаПечати данные);
    public Окно создайОкноАборта(Окно родитель, Отпечатка отпечатка);
    public проц сообщиОбОшибке(Окно родитель, Отпечатка отпечатка, ткст сообщение);
    public ДанныеДиалогаПечати данныеДиалогаПечати();
    public бул аборт();
    public ПОшибкаПринтера последнОш();
    public бул настройка(Окно родитель);
    public бул печать(Окно родитель, Отпечатка отпечатка, бул промпт);
    public КонтекстУстройства диалогПечати(Окно родитель);
}
//-----------------------------------------------------------------------------
extern(D)  abstract class Отпечатка : ВизОбъект
{
    //private this(ЦелУкз вхобъ);
    public this(ткст титул);
    static extern(C) бул staticOnBeginDocument(Отпечатка объ, цел начСтраница, цел конСтраница);
    public  бул приНачалеДокумента(цел начСтраница, цел конСтраница);
    static extern(C) проц staticOnEndDocument(Отпечатка объ);
    public  проц приЗавершенииДокумента();
    static extern(C) проц staticOnBeginPrinting(Отпечатка объ);
    public  проц приНачалеПечатания();
    static extern(C) проц staticOnEndPrinting(Отпечатка объ);
    public  проц приЗавершенииПечатания();
    static extern(C) проц staticOnPreparePrinting(Отпечатка объ);
    public  проц приПодготовкеКПечатанию();
    static extern(C) бул staticHasPage(Отпечатка объ, цел страница);
    public  бул естьСтраница(цел страница);
    static extern(C) бул staticOnPrintPage(Отпечатка объ,цел страница);
    public abstract бул приПечатиСтраницы(цел страница);
    static extern(C) проц staticGetPageInfo(Отпечатка объ, inout цел минСтраница, inout цел максСтраница, inout цел страницаОтКоторой, inout цел страницаДоКоторой);
    public  проц дайИнфОСтранице(inout цел минСтраница, inout цел максСтраница, inout цел страницаОтКоторой, inout цел страницаДоКоторой);
    public ткст титул();
    public КонтекстУстройства ку();
    public проц ку(КонтекстУстройства значение);
    public проц устПикселиРазмераСтраницы(цел w, цел h);
    public проц дайПикселиРазмераСтраницы(out цел w, out цел h);
    public проц устРазмСтраницыКП(цел w, цел h);
    public проц дайРазмСтраницыКП(out цел w, out цел h);
    public проц устПНДЭкрана(цел x, цел y);
    public проц дайПНДЭкрана(out цел x, out цел y);
    public проц устПНДПринтера(цел x, цел y);
    public проц дайПНДПринтера(out цел x, out цел y);
    public бул предпросмотр_ли();
    public проц предпросмотр_ли(бул значение);
}