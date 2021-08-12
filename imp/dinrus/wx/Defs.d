
module wx.Defs;

version(wx25) version = wx26;
version(wx27) version = wx28;

public enum ПТипБитмап
{
    INVALID               = 0,
    BMP,
    BMP_RESOURCE,
    RESOURCE              = BMP_RESOURCE,
    ICO,
    ICO_RESOURCE,
    CUR,
    CUR_RESOURCE,
    XBM,
    XBM_DATA,
    XPM,
    XPM_DATA,
    TIF,
    TIF_RESOURCE,
    GIF,
    GIF_RESOURCE,
    PNG,
    PNG_RESOURCE,
    JPEG,
    JPEG_RESOURCE,
    PNM,
    PNM_RESOURCE,
    PCX,
    PCX_RESOURCE,
    PICT,
    PICT_RESOURCE,
    ICON,
    ICON_RESOURCE,
    ANI,
    IFF,
    MACCURSOR,
    MACCURSOR_RESOURCE,
    ЛЮБОЙ                   = 50
}

version(wx28) // -------------------------------------------- wxWidgets 2.8
{
    /*  Standard меню IDs */
    public enum ПИДыМеню
    {
        НИЗШИЙ = 4999,

        OPEN,
        CLOSE,
        NEW,
        SAVE,
        SAVEAS,
        REVERT,
        EXIT,
        UNDO,
        REDO,
        HELP,
        PRINT,
        PRINT_SETUP,
        PAGE_SETUP, /* NEW */
        PREVIEW,
        ABOUT,
        HELP_CONTENTS,
        HELP_INDEX, /* NEW */
        HELP_SEARCH, /* NEW */
        HELP_COMMANDS,
        HELP_PROCEDURES,
        HELP_CONTEXT,
        CLOSE_ALL,
        PREFERENCES,

        EDIT = 5030, /* NEW */
        CUT, /* NEW */
        COPY,
        PASTE,
        CLEAR,
        FIND,
        DUPLICATE,
        SELECTALL,
        DELETE,
        REPLACE,
        REPLACE_ALL,
        PROPERTIES,

        VIEW_DETAILS,
        VIEW_LARGEICONS,
        VIEW_SMALLICONS,
        VIEW_LIST,
        VIEW_SORTDATE,
        VIEW_SORTNAME,
        VIEW_SORTSIZE,
        VIEW_SORTTYPE,

        FILE = 5050,	/* NEW */
        FILE1,	/* NEW */
        FILE2,
        FILE3,
        FILE4,
        FILE5,
        FILE6,
        FILE7,
        FILE8,
        FILE9,

        /*  Standard button and меню IDs */
        ОК = 5100,
        ОТМЕНА,
        APPLY,
        ДА,
        НЕТ,
        STATIC,
        FORWARD,
        BACKWARD,
        Дефолт,
        MORE,
        SETUP,
        RESET,
        CONTEXT_HELP,
        YESTOALL,
        NOTOALL,
        ABORT,
        RETRY,
        IGNORE,
        ADD,
        REMOVE,

        UP,
        DOWN,
        HOME,
        REFRESH,
        STOP,
        INDEX,

        Полужирный,
        Курсивный,
        JUSTIFY_CENTER,
        JUSTIFY_FILL,
        JUSTIFY_RIGHT,
        JUSTIFY_LEFT,
        UNDERLINE,
        INDENT,
        UNINDENT,
        ZOOM_100,
        ZOOM_FIT,
        ZOOM_IN,
        ZOOM_OUT,
        UNDELETE,
        REVERT_TO_SAVED,

        /*  System меню IDs (used by wxUniv): */
        SYSTEM_MENU = 5200,
        CLOSE_FRAME,
        MOVE_FRAME,
        RESIZE_FRAME,
        MAXIMIZE_FRAME,
        ICONIZE_FRAME,
        RESTORE_FRAME,

        /*  IDs used by generic файл dialog (13 consecutive starting от this значение) */
        FILEDLGG = 5900,

        ВЫСШИЙ = 5999
    }
}
else // version (wx26) // ----------------------------------- wxWidgets 2.6
{
    /*  Standard меню IDs */
    public enum ПИДыМеню
    {
        НИЗШИЙ = 4999,

        OPEN,
        CLOSE,
        NEW,
        SAVE,
        SAVEAS,
        REVERT,
        EXIT,
        UNDO,
        REDO,
        HELP,
        PRINT,
        PRINT_SETUP,
//      PAGE_SETUP,	/* added in wxWidgets 2.7.1 */
        PREVIEW,
        ABOUT,
        HELP_CONTENTS,
        HELP_COMMANDS,
        HELP_PROCEDURES,
        HELP_CONTEXT,
        CLOSE_ALL,
        PREFERENCES,

        CUT = 5030,
        COPY,
        PASTE,
        CLEAR,
        FIND,
        DUPLICATE,
        SELECTALL,
        DELETE,
        REPLACE,
        REPLACE_ALL,
        PROPERTIES,

        VIEW_DETAILS,
        VIEW_LARGEICONS,
        VIEW_SMALLICONS,
        VIEW_LIST,
        VIEW_SORTDATE,
        VIEW_SORTNAME,
        VIEW_SORTSIZE,
        VIEW_SORTTYPE,

        FILE1 = 5050,
        FILE2,
        FILE3,
        FILE4,
        FILE5,
        FILE6,
        FILE7,
        FILE8,
        FILE9,

        /*  Standard button and меню IDs */
        ОК = 5100,
        ОТМЕНА,
        APPLY,
        ДА,
        НЕТ,
        STATIC,
        FORWARD,
        BACKWARD,
        Дефолт,
        MORE,
        SETUP,
        RESET,
        CONTEXT_HELP,
        YESTOALL,
        NOTOALL,
        ABORT,
        RETRY,
        IGNORE,
        ADD,
        REMOVE,

        UP,
        DOWN,
        HOME,
        REFRESH,
        STOP,
        INDEX,

        Полужирный,
        Курсивный,
        JUSTIFY_CENTER,
        JUSTIFY_FILL,
        JUSTIFY_RIGHT,
        JUSTIFY_LEFT,
        UNDERLINE,
        INDENT,
        UNINDENT,
        ZOOM_100,
        ZOOM_FIT,
        ZOOM_IN,
        ZOOM_OUT,
        UNDELETE,
        REVERT_TO_SAVED,

        /*  System меню IDs (used by wxUniv): */
        SYSTEM_MENU = 5200,
        CLOSE_FRAME,
        MOVE_FRAME,
        RESIZE_FRAME,
        MAXIMIZE_FRAME,
        ICONIZE_FRAME,
        RESTORE_FRAME,

        /*  IDs used by generic файл dialog (13 consecutive starting от this значение) */
        FILEDLGG = 5900,

        ВЫСШИЙ = 5999
    }
} // -------------------------------------------------------- wxWidgets ABI

version(wx28) // -------------------------------------------- wxWidgets 2.8
{
    //[флаги]
    public enum ПКодКл
    {
        BACK    =    8,
        TAB     =    9,
        RETURN  =    13,
        ESCAPE  =    27,
        SPACE   =    32,
        DELETE  =    127,

        START   = 300,
        LBUTTON,
        RBUTTON,
        ОТМЕНА,
        MBUTTON,
        CLEAR,
        SHIFT,
        ALT,
        CONTROL,
        MENU,
        PAUSE,
        CAPITAL,
        END,
        HOME,
        LEFT,
        UP,
        RIGHT,
        DOWN,
        SELECT,
        PRINT,
        EXECUTE,
        SNAPSHOT,
        INSERT,
        HELP,
        NUMPAD0,
        NUMPAD1,
        NUMPAD2,
        NUMPAD3,
        NUMPAD4,
        NUMPAD5,
        NUMPAD6,
        NUMPAD7,
        NUMPAD8,
        NUMPAD9,
        MULTIPLY,
        ADD,
        СЕПАРАТОР,
        SUBTRACT,
        DECIMAL,
        DIVIDE,
        F1,
        F2,
        F3,
        F4,
        F5,
        F6,
        F7,
        F8,
        F9,
        F10,
        F11,
        F12,
        F13,
        F14,
        F15,
        F16,
        F17,
        F18,
        F19,
        F20,
        F21,
        F22,
        F23,
        F24,
        NUMLOCK,
        SCROLL,
        PAGEUP,
        PAGEDOWN,

        PRIOR = PAGEUP,   //WX 2.6 compatibility
        NEXT  = PAGEDOWN, //WX 2.6 compatibility

        NUMPAD_SPACE,
        NUMPAD_TAB,
        NUMPAD_ENTER,
        NUMPAD_F1,
        NUMPAD_F2,
        NUMPAD_F3,
        NUMPAD_F4,
        NUMPAD_HOME,
        NUMPAD_LEFT,
        NUMPAD_UP,
        NUMPAD_RIGHT,
        NUMPAD_DOWN,
        NUMPAD_PAGEUP,
        NUMPAD_PAGEDOWN,

        NUMPAD_PRIOR = NUMPAD_PAGEUP,   //WX 2.6 compatibility
        NUMPAD_NEXT  = NUMPAD_PAGEDOWN, //WX 2.6 compatibility

        NUMPAD_END,
        NUMPAD_BEGIN,
        NUMPAD_INSERT,
        NUMPAD_DELETE,
        NUMPAD_EQUAL,
        NUMPAD_MULTIPLY,
        NUMPAD_ADD,
        NUMPAD_SEPARATOR,
        NUMPAD_SUBTRACT,
        NUMPAD_DECIMAL,
        NUMPAD_DIVIDE
    }
}
else // version (wx26) // ----------------------------------- wxWidgets 2.6
{
    //[флаги]
    public enum ПКодКл
    {
        BACK    = 8,
        TAB     = 9,
        RETURN  = 13,
        ESCAPE  = 27,
        SPACE   = 32,
        DELETE  = 127,

        START   = 300,
        LBUTTON,
        RBUTTON,
        ОТМЕНА,
        MBUTTON,
        CLEAR,
        SHIFT,
        ALT,
        CONTROL,
        MENU,
        PAUSE,
        CAPITAL,
        PRIOR,  // Page up
        NEXT,   // Page down
        END,
        HOME,
        LEFT,
        UP,
        RIGHT,
        DOWN,
        SELECT,
        PRINT,
        EXECUTE,
        SNAPSHOT,
        INSERT,
        HELP,
        NUMPAD0,
        NUMPAD1,
        NUMPAD2,
        NUMPAD3,
        NUMPAD4,
        NUMPAD5,
        NUMPAD6,
        NUMPAD7,
        NUMPAD8,
        NUMPAD9,
        MULTIPLY,
        ADD,
        СЕПАРАТОР,
        SUBTRACT,
        DECIMAL,
        DIVIDE,
        F1,
        F2,
        F3,
        F4,
        F5,
        F6,
        F7,
        F8,
        F9,
        F10,
        F11,
        F12,
        F13,
        F14,
        F15,
        F16,
        F17,
        F18,
        F19,
        F20,
        F21,
        F22,
        F23,
        F24,
        NUMLOCK,
        SCROLL,
        PAGEUP,
        PAGEDOWN,

        NUMPAD_SPACE,
        NUMPAD_TAB,
        NUMPAD_ENTER,
        NUMPAD_F1,
        NUMPAD_F2,
        NUMPAD_F3,
        NUMPAD_F4,
        NUMPAD_HOME,
        NUMPAD_LEFT,
        NUMPAD_UP,
        NUMPAD_RIGHT,
        NUMPAD_DOWN,
        NUMPAD_PRIOR,
        NUMPAD_PAGEUP,
        NUMPAD_NEXT,
        NUMPAD_PAGEDOWN,
        NUMPAD_END,
        NUMPAD_BEGIN,
        NUMPAD_INSERT,
        NUMPAD_DELETE,
        NUMPAD_EQUAL,
        NUMPAD_MULTIPLY,
        NUMPAD_ADD,
        NUMPAD_SEPARATOR,
        NUMPAD_SUBTRACT,
        NUMPAD_DECIMAL,
        NUMPAD_DIVIDE
    }
} // -------------------------------------------------------- wxWidgets ABI

public enum ПНаправление
{
    Влево    = 0x0010,
    Вправо   = 0x0020,
    Вверх      = 0x0040,
    Вниз    = 0x0080,
    Верх     = Вверх,
    Низ  = Вниз,
    Север   = Вверх,
    Юг   = Вниз,
    Запад    = Влево,
    Восток    = Вправо,
    Все     = (Вверх | Вниз | Вправо | Влево),
}

//[флаги]
public enum ПСтильЗаливки
{
    Дефолт = 70,
    Декоративный,
    Роман,
    Скрипт,
    Швейцарский,
    Модерн,
    Телетайп,

    Переменный = 80,
    Фиксированный,

    Нормальный = 90,
    Лёгкий,
    Полужирный,
    Курсивный,
    Слант,

    Плотная = 100,
    wxDOT,
    wxint_DASH,
    wxSHORT_DASH,
    wxDOT_DASH,
    wxUSER_DASH,
    wxTRANSPARENT,
    wxSTIPPLE_MASK_OPAQUE,
    wxSTIPPLE_MASK,

    wxSTIPPLE = 110,
    wxBDIAGONAL_HATCH,
    wxCROSSDIAG_HATCH,
    wxFDIAGONAL_HATCH,
    wxCROSS_HATCH,
    wxHORIZONTAL_HATCH,
    wxVERTICAL_HATCH,

    wxJOIN_BEVEL = 120,
    wxJOIN_MITER,
    wxJOIN_ROUND,

    wxCAP_ROUND = 130,
    wxCAP_PROJECTING,
    wxCAP_BUTT,

    // Polygon fill стиль
    wxODDEVEN_RULE = 1,
    wxWINDING_RULE
}

// Logical operations
//[флаги]
public enum ПЛогика
{
    wxCLEAR,        wxROP_BLACK = wxCLEAR,             wxBLIT_BLACKNESS = wxCLEAR,        // 0
    wxXOR,          wxROP_XORPEN = wxXOR,              wxBLIT_SRCINVERT = wxXOR,          // src XOR dst
    wxINVERT,       wxROP_NOT = wxINVERT,              wxBLIT_DSTINVERT = wxINVERT,       // NOT dst
    wxOR_REVERSE,   wxROP_MERGEPENNOT = wxOR_REVERSE,  wxBLIT_00DD0228 = wxOR_REVERSE,    // src OR (NOT dst)
    wxAND_REVERSE,  wxROP_MASKPENNOT = wxAND_REVERSE,  wxBLIT_SRCERASE = wxAND_REVERSE,   // src AND (NOT dst)
    wxCOPY,         wxROP_COPYPEN = wxCOPY,            wxBLIT_SRCCOPY = wxCOPY,           // src
    wxAND,          wxROP_MASKPEN = wxAND,             wxBLIT_SRCAND = wxAND,             // src AND dst
    wxAND_INVERT,   wxROP_MASKNOTPEN = wxAND_INVERT,   wxBLIT_00220326 = wxAND_INVERT,    // (NOT src) AND dst
    wxNO_OP,        wxROP_NOP = wxNO_OP,               wxBLIT_00AA0029 = wxNO_OP,         // dst
    wxNOR,          wxROP_NOTMERGEPEN = wxNOR,         wxBLIT_NOTSRCERASE = wxNOR,        // (NOT src) AND (NOT dst)
    wxEQUIV,        wxROP_NOTXORPEN = wxEQUIV,         wxBLIT_00990066 = wxEQUIV,         // (NOT src) XOR dst
    wxSRC_INVERT,   wxROP_NOTCOPYPEN = wxSRC_INVERT,   wxBLIT_NOTSCRCOPY = wxSRC_INVERT,  // (NOT src)
    wxOR_INVERT,    wxROP_MERGENOTPEN = wxOR_INVERT,   wxBLIT_MERGEPAINT = wxOR_INVERT,   // (NOT src) OR dst
    wxNAND,         wxROP_NOTMASKPEN = wxNAND,         wxBLIT_007700E6 = wxNAND,          // (NOT src) OR (NOT dst)
    wxOR,           wxROP_MERGEPEN = wxOR,             wxBLIT_SRCPAINT = wxOR,            // src OR dst
    wxSET,          wxROP_WHITE = wxSET,               wxBLIT_WHITENESS = wxSET           // 1
}

public enum ПОриентация
{
    Вертикаль     = 0x0008,
    Горизонталь   = 0x0004,

    Оба     = (Вертикаль | Горизонталь),
}

public enum ПРастяг
{
    Нет     = 0x0000,
    Сжать          = 0x1000,
    Нарастить            = 0x2000,
    Растянуть          = Нарастить,
    ПоФорме          = 0x4000,
    ФиксированныйМинРазм   = 0x8000,
    Замостить            = 0xc000,

    // changed in wxWidgets 2.5.2, see discussion on wx-dev
    минРазм  = 0x0000,
}

public enum ПРаскладка
{
    Нет               = 0x0000,
    ЦентрГоризонталь = 0x0100,
    Слева              = Нет,
    Вверху               = Нет,
    Справа             = 0x0200,
    Внизу            = 0x0400,
    ЦентрВертикаль   = 0x0800,

    Центр            = (ЦентрГоризонталь | ЦентрВертикаль),

    Маска              = 0x0f00,

}

//[флаги]
public enum ПВидЭлта
{
    Сепаратор = -1,
    Нормальный,
    Чек,
    Радио,
    Макс
}

public enum ПСтильФлуда
{
    Поверхность = 1,
    wxFLOOD_BORDER = 2,
}

public enum ПКнопкаМыши
{
    Любая     = -1,
    Нет    = 0,
    Левая    = 1,
    Средняя  = 2,
    Правая   = 3
}

public enum ПРежимПоискаСправки
{
    ИскатьИндекс,
    ИскатьВсе
}

public enum ПРежимОбновленияГИ
{
    // Send UI обновить events до all windows
    ОбработатьВсе,

    // Send UI обновить events до windows that have
    // the wxWS_EX_PROCESS_UI_UPDATES флаг specified
    ОбработатьВыбранные
}

enum
{
    /** no ид matches this one when compared до it */
    НИКАКОЙ = -3,

    /**  ид for a separator строка in the меню (invalid for normal элт) */
    СЕПАРАТОР = -2,

    /** any ид: means that we don't care about the ид, whether when installing
      * an событие обработчик or when creating a new окно */
    ЛЮБОЙ = -1,

    /** all predefined ids are between НИЗШИЙ and ВЫСШИЙ */
    НИЗШИЙ = 4999,
    ВЫСШИЙ = 5999
}

