module wx.Display;
public import wx.common;
public import wx.VideoMode;
public import wx.Window;

extern(D) class Дисплей : ВизОбъект
{
    public const цел НЕ_НАЙДЕН = -1;
    public this(ЦелУкз вхобъ);
    //private this(ЦелУкз вхобъ, бул памСобств);
    public this(цел индекс);
    ~this();
    static цел счёт();
    public static Дисплей[] дайДисплеи();
    public ВидеоРежим[] дайРежимы();
    public ВидеоРежим[] дайРежимы(ВидеоРежим режим);
    public static цел дайИзТочки(Точка тчк);
    public цел дайИзОкна(Окно окно);
    public Прямоугольник геометрия();
    public ткст имя();
    public бул первичен();
    public ВидеоРежим текущРежим();
    public бул смениРежим(ВидеоРежим режим);
    public проц сбросьРежим();
}
