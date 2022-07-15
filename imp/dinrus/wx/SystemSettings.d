module wx.SystemSettings;
public import wx.common;
public import wx.Colour;
public import wx.Font;

public enum ПСисШрифт
{
    ФиксированныйОЕМ = 10,
    ФиксированныйАНЗИ,
    АНЗИвар,
    Системный,
    ДефУстройства,
    ДефПалитра,
    ФиксСистемный,
    ДефГИП
}

public enum ПСисЦвет
{
    Скроллбар,
    Фон,
    РабочийСтол = Фон,
    АктивКапшн,
    НеактивКапшн,
    Меню,
    Окно,
    РамкаОкна,
    ТекстМеню,
    ТекстОкна,
    ТекстКапшн,
    АктивБордюр,
    НеактивБордюр,
    РабПрострПрил,
    Подсветка,
    ТекстСПодсветкой,
    ЛицоКнопки,
    Лицо3Д = ЛицоКнопки,
    ТеньКнопки,
    Тень3Д = ТеньКнопки,
    СерыйТекст,
    ТекстКнопки,
    ТекстНеактивКапшн,
    ПодсветкаКнопки,
    COLOUR_BTNHILIGHT = ПодсветкаКнопки,
    COLOUR_3DHIGHLIGHT = ПодсветкаКнопки,
    COLOUR_3DHILIGHT = ПодсветкаКнопки,
    COLOUR_3DDKSHADOW,
    COLOUR_3DLIGHT,
    COLOUR_INFOTEXT,
    COLOUR_INFOBK,
    COLOUR_LISTBOX,
    COLOUR_HOTLIGHT,
    COLOUR_GRADIENTACTIVECAPTION,
    COLOUR_GRADIENTINACTIVECAPTION,
    COLOUR_MENUHILIGHT,
    COLOUR_MENUBAR,

    Макс
}

public enum ПСисМетрика
{
    MOUSE_BUTTONS = 1,
    BORDER_X,
    BORDER_Y,
    CURSOR_X,
    CURSOR_Y,
    DCLICK_X,
    DCLICK_Y,
    DRAG_X,
    DRAG_Y,
    EDGE_X,
    EDGE_Y,
    HSCROLL_ARROW_X,
    HSCROLL_ARROW_Y,
    HTHUMB_X,
    ICON_X,
    ICON_Y,
    ICONSPACING_X,
    ICONSPACING_Y,
    WINDOWMIN_X,
    WINDOWMIN_Y,
    wX,
    wY,
    FRAMESIZE_X,
    FRAMESIZE_Y,
    SMALLICON_X,
    SMALLICON_Y,
    HSCROLL_Y,
    VSCROLL_X,
    VSCROLL_ARROW_X,
    VSCROLL_ARROW_Y,
    VTHUMB_Y,
    CAPTION_Y,
    MENU_Y,
    NETWORK_PRESENT,
    PENWINDOWS_PRESENT,
    SHOW_SOUNDS,
    SWAP_BUTTONS
}

public enum ПСисФича
{
    РисованииДекорацийРамки = 1,
    ИконизацияРамки
}

public enum ПтипСисЭкрана
{
    Нет = 0,  //   not yet defined

    Тайни,      //   <
    ПДА,       //   >= 320x240
    Смолл,     //   >= 640x480
    Десктоп    //   >= 800x600
}

//-----------------------------------------------------------------------------

extern(D) class СистемныеНастройки
{
    public static Цвет дайЦвет(ПСисЦвет индекс);
    public static Шрифт дайШрифт(ПСисШрифт индекс);
    public static цел дайМетрику(ПСисМетрика индекс);
    public static бул естьФича(ПСисФича индекс);
    static ПтипСисЭкрана типЭкрана();
    static проц типЭкрана(ПтипСисЭкрана значение);
}
