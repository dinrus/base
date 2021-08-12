module wx.TaskBarIcon;
public import wx.common;
public import wx.EvtHandler;
public import wx.Icon;
public import wx.Menu;

enum ПтипИконкиТаскБара
{
    Дефолт
}

extern(D) class ИконкаТаскБара : ОбработчикСоб
{
    public static ТипСобытия СОБ_ТАСКБАР_ДВИЖЕНИЕ;
    public static ТипСобытия СОБ_ТАСКБАР_ЛЕВАЯ_ВНИЗУ;
    public static ТипСобытия СОБ_ТАСКБАР_ЛЕВАЯ_ВВЕРХУ;
    public static ТипСобытия СОБ_ТАСКБАР_ПРАВАЯ_ВНИЗУ;
    public static ТипСобытия СОБ_ТАСКБАР_ПРАВАЯ_ВВЕРХУ;
    public static ТипСобытия СОБ_ТАСКБАР_ЛЕВАЯ_ДНАЖАТА;
    public static ТипСобытия СОБ_ТАСКБАР_ПРАВАЯ_ДНАЖАТА;

    //static this();
    public this();
    public this(ПтипИконкиТаскБара типИконки);
    public this(ЦелУкз вхобъ);
    //private this(ЦелУкз вхобъ, бул памСобств);
    ~this();
    static extern(C) ЦелУкз staticCreatePopupMenu(ИконкаТаскБара объ);
    protected  Меню создайВсплывающееМеню();
    public бул иконкаУстановлена();
    public бул Ок();
    public бул всплывающееМеню(Меню меню);
    public бул удалиИконку();
    public бул устИконку(Пиктограмма пиктограмма, ткст тултип = "");
    public проц Move_Add(ДатчикСобытий значение);
    public проц Move_Remove(ДатчикСобытий значение);
    public проц LeftDown_Add(ДатчикСобытий значение);
    public проц LeftDown_Remove(ДатчикСобытий значение);
    public проц LeftUp_Add(ДатчикСобытий значение);
    public проц LeftUp_Remove(ДатчикСобытий значение);
    public проц RightDown_Add(ДатчикСобытий значение);
    public проц RightDown_Remove(ДатчикСобытий значение);
    public проц RightUp_Add(ДатчикСобытий значение);
    public проц RightUp_Remove(ДатчикСобытий значение);
    public проц LeftDClick_Add(ДатчикСобытий значение);
    public проц LeftDClick_Remove(ДатчикСобытий значение);
    public проц RightDClick_Add(ДатчикСобытий значение);
    public проц RightDClick_Remove(ДатчикСобытий значение);
}

extern(D) class СобытиеИконкиТаскБара : Событие
{
    public this(ЦелУкз вхобъ);
    public this(ТипСобытия тип, ИконкаТаскБара тбИконка);
    public Событие клонируй();
    //private static Событие Нов(ЦелУкз объ);
}
