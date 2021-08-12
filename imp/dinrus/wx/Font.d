module wx.Font;
public import wx.common;
public import wx.GDIObject;

// Шрифт encodings - taken от wx/fontenc.h
// Author: Vadim Zeitlin, (C) Vadim Zeitlin
public enum ПКодировкаШрифта
{
    Система = -1,     // system default
    Дефолт,         // current default кодировка

    // ISO8859 standard defines a число of single-byte charsets
    ISO8859_1,           // West European (Latin1)
    ISO8859_2,           // Central and East European (Latin2)
    ISO8859_3,           // Esperanto (Latin3)
    ISO8859_4,           // Baltic (old) (Latin4)
    ISO8859_5,           // Cyrillic
    ISO8859_6,           // Arabic
    ISO8859_7,           // Greek
    ISO8859_8,           // Hebrew
    ISO8859_9,           // Turkish (Latin5)
    ISO8859_10,          // Variation of Latin4 (Latin6)
    ISO8859_11,          // Thai
    ISO8859_12,          // doesn't exist currently, кноп put it
    // here anyhow до make all ISO8859
    // consecutive numbers
    ISO8859_13,          // Baltic (Latin7)
    ISO8859_14,          // Latin8
    ISO8859_15,          // Latin9 (a.k.a. Latin0, includes euro)
    ISO8859_MAX,

    // Cyrillic гарнитура soup (see http://czyborra.com/charsets/cyrillic.html)
    KOI8,                // we don't support any of KOI8 variants
    ALTERNATIVE,         // same as MS-DOS CP866
    BULGARIAN,           // used under Linux in Bulgaria
    // what would we do without Microsoft? They have their own encodings
    // for DOS
    CP437,               // original MS-DOS codepage
    CP850,               // CP437 merged with Latin1
    CP852,               // CP437 merged with Latin2
    CP855,               // anдругой cyrillic кодировка
    CP866,               // and anдругой one
    // and for Windows
    CP874,               // WinThai
    CP932,               // Japanese (шифт-JIS)
    CP936,               // Chinese simplified (GB)
    CP949,               // Korean (Hangul гарнитура)
    CP950,               // Chinese (traditional - Big5)
    CP1250,              // WinLatin2
    CP1251,              // WinCyrillic
    CP1252,              // WinLatin1
    CP1253,              // WinGreek (8859-7)
    CP1254,              // WinTurkish
    CP1255,              // WinHebrew
    CP1256,              // WinArabic
    CP1257,              // WinBaltic (same as Latin 7)
    CP12_MAX,

    UTF7,                // UTF-7 Unicode кодировка
    UTF8,                // UTF-8 Unicode кодировка

    // Far Eastern encodings
    // Chinese
    GB2312 = CP936,       // Simplified Chinese
    BIG5 = CP950,         // Traditional Chinese

    // Japanese (see http://zsigri.tripod.com/fontboard/cjk/jis.html)
    Shift_JIS = CP932,    // Shift JIS
    EUC_JP,                              // Extended Unix Codepage for Japanese

    ЮНИКОД,         // Unicode - currently used only by
    // wxEncodingConverter class

    Макс
}

public enum ПСемействоШрифтов
{
    // текст шрифт families
    Дефолт    = 70,
    Декоративный,
    Роман,
    Скрипт,
    Швейцарский,
    Модерн,
    Телетайп,
    Макс,

    // Proportional or Fixed ширь fonts (not yet used)
    Переменный   = 80,
    Фиксированный,

    Нормальный     = 90,
    Лёгкий,
    Полужирный,
    // Also Нормальный for normal (non-italic текст)
    Курсивный,
    Слант
}

public enum ПВесШрифта
{
    Нормальный = 90,
    Лёгкий,
    Полужирный,
    Макс
}

public enum ПСтильШрифта
{
    Нормальный = 90,
    Курсивный = 93,
    Слант  = 94,
    Макс
}

public enum ПФлагШрифта
{
    Дефолт          = 0,

    Курсивный           = 1 << 0,
    Слант            = 1 << 1,

    Лёгкий            = 1 << 2,
    Полужирный             = 1 << 3,

    Сглаженный      = 1 << 4,
    Несглаженный  = 1 << 5,

    Подчёркнутый       = 1 << 6,
    Перечёркнутый    = 1 << 7,

    Маска = Курсивный             |
                 Слант              |
                 Лёгкий              |
                 Полужирный               |
                 Сглаженный        |
                 Несглаженный    |
                 Подчёркнутый         |
                 Перечёркнутый
}

//---------------------------------------------------------------------

extern(D) class Шрифт : ОбъектИГУ, ИКлонируемый
{
    // in wxWidgets 2.8 fonts are dynamic, and crash if accessed too early
    public static Шрифт Нормальный();
    public static Шрифт Маленький();
    public static Шрифт Курсивный();
    public static Шрифт Швейцарский();
    public static Шрифт НуллШрифт;

    public this(ЦелУкз вхобъ);
    public this(ЦелУкз вхобъ, бул памСобств);
    public this();
    public this(цел размТочки, ПСемействоШрифтов семейство, ПСтильШрифта стиль, ПВесШрифта вес, бул подчеркни = нет, ткст фас = "", ПКодировкаШрифта кодировка = ПКодировкаШрифта.Дефолт);
    ~this();
    public цел размТочки();
    public проц размТочки(цел значение);
    public ПСемействоШрифтов семейство();
    public проц семейство(ПСемействоШрифтов значение);
    public ПСтильШрифта стиль();
    public проц стиль(ПСтильШрифта значение);
    public ПКодировкаШрифта кодировка();
    public проц кодировка(ПКодировкаШрифта значение);
    public ПВесШрифта вес();
    public проц вес(ПВесШрифта значение);
    public бул подчёркнут();
    public проц подчёркнут(бул значение);
    public ткст имяФас();
    public проц имяФас(ткст значение);
    public ткст ткстСемейства();
    public ткст ткстСтиля();
    public ткст ткстВеса();
    public бул ширинаФиксирована_ли();
    public бул Ок();
    public ЦелУкз инфОНативномШрифте();
    public ткст инфОНативномШрифтеОписПользователя();
    public ткст инфОНативномШрифтеОпис();
    public static Шрифт Нов(ткст стрОписаниеНативнШрифта);
    public Объект клонируй();
    public this(Шрифт другой);
    //public static ВизОбъект Нов(ЦелУкз укз);
}
