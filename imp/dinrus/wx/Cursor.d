module wx.Cursor;
public import wx.common;
public import wx.Bitmap;

public enum ПСтокКурсор
{
    Нет,
    Стрелка,
    ПраваяСтрелка,
    ГлазБыка,
    CHAR,
    Крест,
    Рука,
    IBEAM,
    LEFT_BUTTON,
    MAGNIFIER,
    MIDDLE_BUTTON,
    NO_ENTRY,
    PAINT_BRUSH,
    PENCIL,
    POINT_LEFT,
    POINT_RIGHT,
    QUESTION_ARROW,
    RIGHT_BUTTON,
    SIZENESW,
    SIZENS,
    SIZENWSE,
    SIZEWE,
    SIZING,
    SPRAYCAN,
    WAIT,
    WATCH,
    BLANK,
    ARROWWAIT,
    Макс
}

//---------------------------------------------------------------------

extern(D) class Курсор : Битмап
{
    /+
    public static Курсор СТАНДАРТНЫЙ;
    public static Курсор ПЕСОЧНЫЕ_ЧАСЫ;
    public static Курсор КРЕСТ;
    public static Курсор НуллКурсор;
    +/
    public this(ЦелУкз вхобъ);
    public this(ПСтокКурсор ид);
    public this(Рисунок рисунок);
    public this(Курсор курсор);
    public override бул Ок();
    public static проц устКурсор(Курсор курсор);
}
