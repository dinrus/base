module wx.wxPlatform;
public import wx.common;

/// Win platform
public const бул __МСВ__;
//static if(__МСВ__) version = __МСВ__;

/// GTK platform
public const бул __ГТК__;
//static if(__ГТК__) version = __ГТК__;

/// Mac platform
public const бул __МАК__;
//static if(__МАК__) version = __МАК__;

/// X11 platform
public const бул __Х11__;
//static if(__Х11__) version = __Х11__;

/// Universal widgets
public const бул __УНИВЕРСАЛ__;
//static if(__УНИВЕРСАЛ__) version = __УНИВЕРСАЛ__;

public const бул АНЗИ;
public const бул ЮНИКОД;

public const бул ОТЛАДКА;
public const бул ЮНИКС;

/// wxUSE_DISPLAY
public const бул ДИСПЛЕЙ;
/// wxUSE_POSTSCRIPT
public const бул ПОСТСКРИПТ;
/// wxUSE_GLCANVAS
public const бул ГЛКАНВАС;
/// wxUSE_SOUND
public const бул ЗВУК;

/// Unknown Platform
public const бул ОС_НЕИЗВЕСТНА;

/// Windows
public const бул ОС_ВИНДОВС;
/// Windows 95/98/ME
public const бул ОС_ВИНДОВС_9Х;
/// Windows NT/2K/XP
public const бул ОС_ВИНДОВС_НТ;

/// Apple Mac OS
public const бул ОС_МАК;
/// Apple Mac OS 8/9/Х with Mac paths
public const бул ОС_МАК_ОС;
/// Apple Mac OS Х with Unix paths
public const бул ОС_ДАРВИН;

/// Unix
public const бул ОС_ЮНИКС;
/// Linux
public const бул ОС_ЛИНУКС;
/// FreeBSD
public const бул ОС_ФРИБСД;

/// дай OS version
extern(D) цел дайВерсиюОС(inout цел майор, inout цел минор);

/// дай OS description as a user-readable ткст
extern(D) ткст дайОписаниеОС();

enum ППлатформа : бцел
{
    МСВ,
    ГТК,
    МАК,
    Х11,
    УНИВЕРСАЛ
}
enum ПОС : бцел
{
    НЕИЗВЕСТНО,
    ВИДОВС,
    ВИНДОВС_9Х,
    ВИНДОВС_НТ,
    МАК,
    МК_ОС,
    ДАРВИН,
    ЮНИКС,
    ЛИНУКС,
    ФРИБСД
}

extern(D) ПОС дайОс();
extern(D) ППлатформа дайПлатформу();
extern(D) бул версияОтладочная();
extern(D) бул версияЮникс();
extern(D) бул версияЮникод();
extern(D) бул версияДисплей();
extern(D) бул версияПостскрипт();
extern(D) бул версияГЛКанвас();
extern(D) бул версияЗвук();


// ------------------------------------------------------

static this()
{
    ППлатформа платф = дайПлатформу();
    switch(платф)
    {
    case ППлатформа.МСВ:
        __МСВ__ = да;
        break;
    case ППлатформа.ГТК:
        __ГТК__ = да;
        break;
    case ППлатформа.МАК:
        __МАК__ = да;
        break;
    case ППлатформа.Х11:
        __Х11__ = да;
        break;
    case ППлатформа.УНИВЕРСАЛ:
        __УНИВЕРСАЛ__ = да;
        break;
    default:

    }

    version(__МСВ__)
    assert(__МСВ__);
    version(__ГТК__)
    assert(__ГТК__);
    version(__МАК__)
    assert(__МАК__);
    version(__Х11__)
    assert(__Х11__);

    ЮНИКОД = версияЮникод();
    АНЗИ = !ЮНИКОД;

    ОТЛАДКА = версияОтладочная();
    ЮНИКС = версияЮникс();

    version(Unicode)
    assert(ЮНИКОД);
    else
        version(АНЗИ)
        assert(АНЗИ);

    ДИСПЛЕЙ = версияДисплей();
    ПОСТСКРИПТ = версияПостскрипт();
    ГЛКАНВАС = версияГЛКанвас();
    ЗВУК = версияЗвук();

    ПОС ос = дайОс();
    switch(ос)
    {
    case ПОС.ВИДОВС:
        ОС_ВИНДОВС = да;
        break;
    case ПОС.ВИНДОВС_9Х:
        ОС_ВИНДОВС_9Х = да;
        break;
    case ПОС.ВИНДОВС_НТ:
        ОС_ВИНДОВС_НТ = да;
        break;
    case ПОС.МАК:
        ОС_МАК = да;
        break;
    case ПОС.МК_ОС:
        ОС_МАК_ОС = да;
        break;
    case ПОС.ДАРВИН:
        ОС_ДАРВИН = да;
        break;
    case ПОС.ЮНИКС:
        ОС_ЮНИКС = да;
        break;
    case ПОС.ЛИНУКС:
        ОС_ЛИНУКС = да;
        break;
    case ПОС.ФРИБСД:
        ОС_ФРИБСД = да;
        break;
    default:
        ОС_НЕИЗВЕСТНА = да;
    }
}
