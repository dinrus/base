module wx.aui.DockArt;
public import  wx.aui.FrameManager;
public import wx.wx;

//-----------------------------------------------------------------------------

/// dock art provider код - a dock provider provides all drawing
/// functionality до the wxAui dock manager.  This allows the dock
/// manager до have plugable look-and-feels
extern(D) class ДокАрт : ВизОбъект
{
    ЦелУкз proxy;

    public this(ЦелУкз вхобъ);
//    override  проц dtor();
    extern (C)  static цел staticGetMetric(ДокАрт объ, цел ид);
    extern (C)  static проц staticSetMetric(ДокАрт объ, цел ид, цел новЗнач);
    extern (C)  static проц staticSetFont(ДокАрт объ, цел ид, ЦелУкз шрифт);
    extern (C)  static ЦелУкз staticGetFont(ДокАрт объ, цел ид);
    extern (C)  static ЦелУкз staticGetColour(ДокАрт объ, цел ид);
    extern (C)  static проц staticSetColour(ДокАрт объ, цел ид, ЦелУкз цвет);
    extern (C)  static ЦелУкз staticGetColor(ДокАрт объ, цел ид);
    extern (C)  static проц staticSetColor(ДокАрт объ, цел ид, ЦелУкз цв);
    extern (C)  static проц staticDrawSash(ДокАрт объ, ЦелУкз ку, цел ориентация, inout Прямоугольник прям);
    extern (C)  static проц staticDrawBackground(ДокАрт объ, ЦелУкз ку, цел ориентация, inout Прямоугольник прям);
    extern (C)  static проц staticDrawCaption(ДокАрт объ, ЦелУкз ку, ткст текст, inout Прямоугольник прям, ЦелУкз пано);
    extern (C)  static проц staticDrawGripper(ДокАрт объ, ЦелУкз ку, inout Прямоугольник прям, ЦелУкз пано);
    extern (C)  static проц staticDrawBorder(ДокАрт объ, ЦелУкз ку, inout Прямоугольник прям, ЦелУкз пано);
    extern (C)  static проц staticDrawPaneButton(ДокАрт объ, ЦелУкз ку, цел button, цел состКнопки, inout Прямоугольник прям, ЦелУкз пано);
    public цел дайМетрику(цел ид);
    public проц устМетрику(цел ид, цел новЗнач);
    public проц устШрифт(цел ид, Шрифт шрифт);
    public Шрифт дайШрифт(цел ид);
    public Цвет дайЦвет(цел ид);
    public проц устЦвет(цел ид, Цвет цвет);
    public проц рисуйСаш(КонтекстУстройства ку, цел ориентация, Прямоугольник прям);
    public проц рисуйФон(КонтекстУстройства ку, цел ориентация, Прямоугольник прям);
    public проц рисуйКапшн(КонтекстУстройства ку, ткст текст, Прямоугольник прям, ИнфОПано пано);
    public проц рисуйГриппер(КонтекстУстройства ку, Прямоугольник прям, ИнфОПано пано);
    public проц рисуйБордюр(КонтекстУстройства ку, Прямоугольник прям, ИнфОПано пано);
    public проц рисуйКнопкуПано(КонтекстУстройства ку, цел button, цел состКнопки, Прямоугольник прям, ИнфОПано пано);
}

/// this is the default art provider for МенеджерРамки.  Dock art
/// can be customized by creating a class derived от this one.
extern(D) class ДефДокАрт : ДокАрт
{
    public this();
    ~this();
}
