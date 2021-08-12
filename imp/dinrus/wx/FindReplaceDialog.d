module wx.FindReplaceDialog;
public import wx.common;
public import wx.Dialog;
public import wx.CommandEvent;

//-----------------------------------------------------------------------------

extern(D) class ДиалогНайдиЗамени : Диалог
{
    public const цел wxFR_DOWN       = 1;
    public const цел wxFR_WHOLEWORD  = 2;
    public const цел wxFR_MATCHCASE  = 4;

    public const цел wxFR_REPLACEDIALOG = 1;
    public const цел wxFR_NOUPDOWN      = 2;
    public const цел wxFR_NOMATCHCASE   = 4;
    public const цел wxFR_NOWHOLEWORD   = 8;

    public this(ЦелУкз вхобъ);
    public this();
    public this(Окно родитель, ДанныеНайдиЗамени данные, ткст титул, цел стиль = 0);
    public бул создай(Окно родитель, ДанныеНайдиЗамени данные, ткст титул, цел стиль = 0);
    public ДанныеНайдиЗамени данные();
    public проц данные(ДанныеНайдиЗамени значение);
    public проц Find_Add(ДатчикСобытий значение);
    public проц Find_Remove(ДатчикСобытий значение);
    public проц FindNext_Add(ДатчикСобытий значение);
    public проц FindNext_Remove(ДатчикСобытий значение);
    public проц FindReplace_Add(ДатчикСобытий значение);
    public проц FindReplace_Remove(ДатчикСобытий значение);
    public проц FindReplaceAll_Add(ДатчикСобытий значение);
    public проц FindReplaceAll_Remove(ДатчикСобытий значение);
    public проц FindClose_Add(ДатчикСобытий значение);
    public проц FindClose_Remove(ДатчикСобытий значение);
}

//-----------------------------------------------------------------------------

extern(D) class СобытиеДиалогаПоиска : СобытиеКоманды
{
    ////static this();

    public this(ЦелУкз вхобъ);
    public this(цел типКоманды, цел ид);
    // public static Событие Нов(ЦелУкз укз);
    public цел флаги();
    public проц флаги(цел значение);
    public ткст найдиТкст();
    public проц найдиТкст(ткст значение);
    public ткст замениТекст();
    public проц замениТекст(ткст значение);
    public ДиалогНайдиЗамени диалог();
}

//-----------------------------------------------------------------------------

extern(D) class ДанныеНайдиЗамени : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    public this();
    public this(цел флаги);
    public ткст найдиТкст();
    public проц найдиТкст(ткст значение);
    public ткст замениТекст();
    public проц замениТекст(ткст значение);
    public цел флаги();
    public проц флаги(цел значение);
    //public static ВизОбъект Нов(ЦелУкз укз);
}

