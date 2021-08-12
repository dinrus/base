module wx.ListCtrl;
public import wx.common;
public import wx.Control;
public import wx.ClientData;
public import wx.ImageList;

extern(D) class ЭлтСписка : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    public this();
    //public static ВизОбъект Нов(ЦелУкз укз);
    public проц очисть();
    public проц очистьАтрибуты();
    public цел расположи();
    public проц расположи(цел значение);
    public Цвет цветФона();
    public проц цветФона(Цвет значение);
    public цел колонка();
    public проц колонка(цел значение);
    public ДанныеКлиента данные();
    public проц данные(ДанныеКлиента значение);
    public Шрифт шрифт();
    public проц шрифт(Шрифт значение);
    public цел ид();
    public проц ид(цел значение);
    public цел рисунок();
    public проц рисунок(цел значение);
    public цел маска();
    public проц маска(цел значение);
    public цел состояние();
    public проц состояние(цел значение);
    public проц маскаСостояния(цел значение);
    public ткст текст();
    public проц текст(ткст значение);
    public Цвет цветТекста();
    public проц цветТекста(Цвет значение);
    public цел ширь();
    public проц ширь(цел значение);
    public АтрЭлтаСписка атрибуты();
    public бул естьАтрибуты();
}

//-----------------------------------------------------------------------------

extern(D) class АтрЭлтаСписка : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    //private this(ЦелУкз вхобъ, бул памСобств);
    public this();
    public this(Цвет цвТекст, Цвет цвФон, Шрифт шрифт);
    //public static ВизОбъект Нов(ЦелУкз укз);
    //private override проц dtor();
    public Цвет цветТекста();
    public проц цветТекста(Цвет значение);
    public Цвет цветФона();
    public проц цветФона(Цвет значение);
    public Шрифт шрифт();
    public проц шрифт(Шрифт значение);
    public бул естьЦветТекста();
    public бул естьЦветФона();
    public бул естьШрифт();
}

//---------------------------------------------------------------------

extern (C)
{
    alias цел function(цел элт1, цел элт2, цел сортДан) списокКтрлСравни; //wxListCtrlCompare
}

extern(D) class СписокКтрл : Контрол
{
    public const цел wxLC_VRULES           = 0x0001;
    public const цел wxLC_HRULES           = 0x0002;

    public const цел wxLC_ICON             = 0x0004;
    public const цел wxLC_SMALL_ICON       = 0x0008;
    public const цел wxLC_LIST             = 0x0010;
    public const цел wxLC_REPORT           = 0x0020;

    public const цел wxLC_ALIGN_TOP        = 0x0040;
    public const цел wxLC_ALIGN_LEFT       = 0x0080;
    public const цел wxLC_AUTO_ARRANGE     = 0x0100;
    public const цел wxLC_VIRTUAL          = 0x0200;
    public const цел wxLC_EDIT_LABELS      = 0x0400;
    public const цел wxLC_NO_HEADER        = 0x0800;
    public const цел wxLC_NO_SORT_HEADER   = 0x1000;
    public const цел wxLC_SINGLE_SEL       = 0x2000;
    public const цел wxLC_SORT_ASCENDING   = 0x4000;
    public const цел wxLC_SORT_DESCENDING  = 0x8000;

    public const цел wxLC_MASK_TYPE        = (wxLC_ICON | wxLC_SMALL_ICON | wxLC_LIST | wxLC_REPORT);
    public const цел wxLC_MASK_ALIGN       = (wxLC_ALIGN_TOP | wxLC_ALIGN_LEFT);
    public const цел wxLC_MASK_SORT        = (wxLC_SORT_ASCENDING | wxLC_SORT_DESCENDING);

    public const цел wxLIST_FORMAT_LEFT     = 0;
    public const цел wxLIST_FORMAT_RIGHT    = 1;
    public const цел wxLIST_FORMAT_CENTRE   = 2;
    public const цел wxLIST_FORMAT_CENTER   = wxLIST_FORMAT_CENTRE;

    public const цел wxLIST_MASK_STATE         = 0x0001;
    public const цел wxLIST_MASK_TEXT          = 0x0002;
    public const цел wxLIST_MASK_IMAGE         = 0x0004;
    public const цел wxLIST_MASK_DATA          = 0x0008;
    public const цел wxLIST_SET_ITEM           = 0x0010;
    public const цел wxLIST_MASK_WIDTH         = 0x0020;
    public const цел wxLIST_MASK_FORMAT        = 0x0040;

    public const цел wxLIST_NEXT_ABOVE     = 1;
    public const цел wxLIST_NEXT_ALL       = 2;
    public const цел wxLIST_NEXT_BELOW     = 3;
    public const цел wxLIST_NEXT_LEFT      = 4;
    public const цел wxLIST_NEXT_RIGHT     = 5;

    public const цел wxLIST_STATE_DONTCARE     = 0x0000;
    public const цел wxLIST_STATE_DROPHILITED  = 0x0001;
    public const цел wxLIST_STATE_FOCUSED      = 0x0002;
    public const цел wxLIST_STATE_SELECTED     = 0x0004;
    public const цел wxLIST_STATE_CUT          = 0x0008;

    public const цел wxLIST_HITTEST_ABOVE          = 0x0001;
    public const цел wxLIST_HITTEST_BELOW          = 0x0002;
    public const цел wxLIST_HITTEST_NOWHERE        = 0x0004;
    public const цел wxLIST_HITTEST_ONITEMICON     = 0x0020;
    public const цел wxLIST_HITTEST_ONITEMLABEL    = 0x0080;
    public const цел wxLIST_HITTEST_ONITEMRIGHT    = 0x0100;
    public const цел wxLIST_HITTEST_ONITEMSTATEICON= 0x0200;
    public const цел wxLIST_HITTEST_TOLEFT         = 0x0400;
    public const цел wxLIST_HITTEST_TORIGHT        = 0x0800;

    public const цел wxLIST_AUTOSIZE			= -1;
    public const цел wxLIST_AUTOSIZE_USEHEADER	= -2;

    public this(ЦелУкз вхобъ);
    public this();
    public this(Окно родитель, цел ид /*= ЛЮБОЙ*/, Точка поз = ДЕФПОЗ, Размер размер = ДЕФРАЗМ, цел стиль = wxLC_ICON, Оценщик оценщик = пусто, ткст имя = "СписокКтрл");
    //public static ВизОбъект Нов(ЦелУкз укз);
    public this(Окно родитель, Точка поз = ДЕФПОЗ, Размер размер = ДЕФРАЗМ, цел стиль = wxLC_ICON, Оценщик оценщик = пусто, ткст имя = "СписокКтрл");
    public бул создай(Окно родитель, цел ид, Точка поз, Размер размер, цел стиль, Оценщик оценщик, ткст имя);
    static extern(C) ЦелУкз staticOnGetItemAttr(СписокКтрл объ, цел элт);
    protected  АтрЭлтаСписка приПолученииАтраЭлта(цел элт);
    static extern(C) цел staticOnGetItemImage(СписокКтрл объ, цел элт);
    protected  цел приПолученииРисункаЭлта(цел элт);

    static extern(C) цел staticOnGetItemColumnImage(СписокКтрл объ, цел элт, цел колонка);
    protected  цел приПолученииРисункаКолонкиЭлта(цел элт, цел колонка);
	
    static extern(C) ткст staticOnGetItemText(СписокКтрл объ, цел элт, цел колонка);
    protected  ткст приПолученииТекстаЭлта(цел элт, цел колонка);
	
    public бул дайКолонку(цел кол, out ЭлтСписка элт);
    public бул устКолонку(цел кол, ЭлтСписка элт);
    public цел дайШиринуКолонки(цел кол);
    public бул устШиринуКолонки(цел кол, цел ширь);
    public цел счётПостранично();
    public бул дайЭлт(inout ЭлтСписка инфо);
    public бул устЭлт(ЭлтСписка инфо);
    public цел устЭлт(цел индекс, цел кол, ткст ярлык);
    public цел устЭлт(цел индекс, цел кол, ткст ярлык, цел идРисунка);
    public проц устТекстЭлта(цел индекс, ткст ярлык);
    public ткст дайТекстЭлта(цел элт);
    public цел дайСостояниеЭлта(цел элт, цел маскаСостояния);
    public бул устСостояниеЭлта(цел элт, цел состояние, цел маскаСостояния);
    public бул устРисунокЭлта(цел элт, цел рисунок, цел выделенРис);
    public ДанныеКлиента дайДанныеЭлта(цел элт);
    public бул устДанныеЭлта(цел элт, ДанныеКлиента данные);
    public бул устДанныеЭлта(цел элт, цел данные);
    public бул дайПрямЭлта(цел элт, out Прямоугольник прям, цел код);
    public бул дайПозициюЭлта(цел элт, out Точка поз);
    public бул устПозЭлта(цел элт, Точка поз);
    public цел счётЭлтов();
    public проц счётЭлтов(цел значение);
    public цел счётКолонок();
    public проц устЦветТекстаЭлта(цел элт, Цвет кол);
    public Цвет дайЦветТекстаЭлта(цел элт);
    public проц устЦветФонаТекстаЭлта(цел элт, Цвет кол);
    public Цвет дайЦветФонаЭлта(цел элт);
    public цел члоВыбранныхЭлтов();
    public Цвет цветТекста();
    public проц цветТекста(Цвет значение);
    public цел верхнийЭлт();
    public проц устЕдинСтиль(цел стиль, бул добавить);
    public проц флагСтиляОкна(цел значение);
    public цел дайСледщЭлт(цел элт, цел geometry, цел состояние);
    public СписокРисунков дайСписокРисунков(цел который);
    public проц устСписокРисунков(СписокРисунков списокРисунков, цел который);
    public проц присвойСписокРисунков(СписокРисунков списокРисунков, цел который);
    public бул аранжируй(цел флаг);
    public проц очистьВсё();
    public бул удалиЭлт(цел элт);
    public бул удалиВсеЭлты();
    public бул удалиВсеКолонки();
    public бул удалиКолонку(цел кол);
    public проц редактируйНадпись(цел элт);
    public бул убедисьЧтоВиден(цел элт);
    public цел найдиЭлт(цел старт, ткст стр, бул частично);
    public цел найдиЭлт(цел старт, ДанныеКлиента данные);
    public цел найдиЭлт(цел старт, Точка тчк, цел направление);
    public цел тестНажатия(Точка точка, цел флаги);
    public цел вставьЭлт(ЭлтСписка инфо);
    public цел вставьЭлт(цел индекс, ткст ярлык);
    public цел вставьЭлт(цел индекс, цел индексРис);
    public цел вставьЭлт(цел индекс, ткст ярлык, цел индексРис);
    public цел вставьКолонку(цел кол, ЭлтСписка инфо);
    public цел вставьКолонку(цел кол, ткст заг);
    public цел вставьКолонку(цел кол, ткст заг, цел format, цел ширь);
    public бул промотайСписок(цел dx, цел dy);
    public Прямоугольник покажиПрям();
    public проц освежиЭлт(цел элт);
    public проц освежиЭлты(цел элтFrom, цел элтTo);
    public бул сортируйЭлты(списокКтрлСравни fn, цел данные);
    public проц BeginDrag_Add(ДатчикСобытий значение);
    public проц BeginDrag_Remove(ДатчикСобытий значение);
    public проц BeginRightDrag_Add(ДатчикСобытий значение);
    public проц BeginRightDrag_Remove(ДатчикСобытий значение);
    public проц BeginLabelEdit_Add(ДатчикСобытий значение);
    public проц BeginLabelEdit_Remove(ДатчикСобытий значение);
    public проц EndLabelEdit_Add(ДатчикСобытий значение);
    public проц EndLabelEdit_Remove(ДатчикСобытий значение);
    public проц ItemDelete_Add(ДатчикСобытий значение);
    public проц ItemDelete_Remove(ДатчикСобытий значение);
    public проц ItemDeleteAll_Add(ДатчикСобытий значение);
    public проц ItemDeleteAll_Remove(ДатчикСобытий значение);
    public проц GetInfo_Add(ДатчикСобытий значение);
    public проц GetInfo_Remove(ДатчикСобытий значение);
    public проц SetInfo_Add(ДатчикСобытий значение);
    public проц SetInfo_Remove(ДатчикСобытий значение);
    public проц ItemSelect_Add(ДатчикСобытий значение);
    public проц ItemSelect_Remove(ДатчикСобытий значение);
    public проц ItemDeselect_Add(ДатчикСобытий значение);
    public проц ItemDeselect_Remove(ДатчикСобытий значение);
    public проц ItemActivate_Add(ДатчикСобытий значение);
    public проц ItemActivate_Remove(ДатчикСобытий значение);
    public проц ItemFocus_Add(ДатчикСобытий значение);
    public проц ItemFocus_Remove(ДатчикСобытий значение);
    public проц ItemMiddleClick_Add(ДатчикСобытий значение);
    public проц ItemMiddleClick_Remove(ДатчикСобытий значение);
    public проц ItemRightClick_Add(ДатчикСобытий значение);
    public проц ItemRightClick_Remove(ДатчикСобытий значение);
    public override проц KeyDown_Add(ДатчикСобытий значение);
    public override проц KeyDown_Remove(ДатчикСобытий значение);
    public проц Insert_Add(ДатчикСобытий значение);
    public проц Insert_Remove(ДатчикСобытий значение);
    public проц ColumnClick_Add(ДатчикСобытий значение);
    public проц ColumnClick_Remove(ДатчикСобытий значение);
    public проц ColumnRightClick_Add(ДатчикСобытий значение);
    public проц ColumnRightClick_Remove(ДатчикСобытий значение);
    public проц ColumnBeginDrag_Add(ДатчикСобытий значение);
    public проц ColumnBeginDrag_Remove(ДатчикСобытий значение);
    public проц ColumnDragging_Add(ДатчикСобытий значение);
    public проц ColumnDragging_Remove(ДатчикСобытий значение);
    public проц ColumnEndDrag_Add(ДатчикСобытий значение);
    public проц ColumnEndDrag_Remove(ДатчикСобытий значение);
    public проц CacheHint_Add(ДатчикСобытий значение);
    public проц CacheHint_Remove(ДатчикСобытий значение);
}

//---------------------------------------------------------------------

extern(D) class СобытиеСписка : Событие
{
    public this(ЦелУкз вхобъ);
    public this(цел типКоманды, цел ид);
    static Событие Нов(ЦелУкз укз);
    public ткст ярлык();
    public цел кодКл();
    public цел индекс();
    public ЭлтСписка элемент();
    public цел колонка();
    public Точка точка();
    public ткст текст();
    public цел рисунок();
    public цел данные();
    public цел маска();
    public цел кэшируйИз();
    public цел кэшируйВ();
    public бул редактированиеОтменено();
    public проц редактированиеОтменено(бул значение);
    public проц запрет();
    public проц позволить();
    public бул позволено();
    //static this();
}

//-----------------------------------------------------------------------------

extern(D) class ОбзорСписка : СписокКтрл
{
    public this(ЦелУкз вхобъ);
    public this();
    public this(Окно родитель);
    public this(Окно родитель, цел ид);
    public this(Окно родитель, цел ид, Точка поз);
    public this(Окно родитель, цел ид, Точка поз, Размер размер);
    public this(Окно родитель, цел ид, Точка поз, Размер размер, цел стиль);
    public this(Окно родитель, цел ид, Точка поз, Размер размер, цел стиль, Оценщик оценщик);
    public this(Окно родитель, цел ид, Точка поз, Размер размер, цел стиль, Оценщик оценщик, ткст имя);
    public this(Окно родитель, Точка поз);
    public this(Окно родитель, Точка поз, Размер размер);
    public this(Окно родитель, Точка поз, Размер размер, цел стиль);
    public this(Окно родитель, Точка поз, Размер размер, цел стиль, Оценщик оценщик);
    public this(Окно родитель, Точка поз, Размер размер, цел стиль, Оценщик оценщик, ткст имя);
    public override бул создай(Окно родитель, цел ид, Точка поз, Размер размер, цел стиль, Оценщик оценщик, ткст имя);
    public проц выдели(цел ч);
    public проц выдели(цел ч, бул on);
    public проц фокусируй(цел индекс);
    public цел элтВФокусе();
    public цел дайСледщВыдный(цел элт);
    public цел первВыделенный();
    public бул выделен(цел индекс);
    public проц устРисунокКолонки(цел кол, цел рисунок);
    public проц сотриРисунокКолонки(цел кол);
}
