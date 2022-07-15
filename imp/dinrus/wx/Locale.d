module wx.Locale;
public import wx.common;
public import wx.Font;

public enum ПЯзык
{
    Дефолт,
    UNKNOWN,

    ABKHAZIAN,
    AFAR,
    AFRIKAANS,
    ALBANIAN,
    AMHARIC,
    ARABIC,
    ARABIC_ALGERIA,
    ARABIC_BAHRAIN,
    ARABIC_EGYPT,
    ARABIC_IRAQ,
    ARABIC_JORDAN,
    ARABIC_KUWAIT,
    ARABIC_LEBANON,
    ARABIC_LIBYA,
    ARABIC_MOROCCO,
    ARABIC_OMAN,
    ARABIC_QATAR,
    ARABIC_SAUDI_ARABIA,
    ARABIC_SUDAN,
    ARABIC_SYRIA,
    ARABIC_TUNISIA,
    ARABIC_UAE,
    ARABIC_YEMEN,
    ARMENIAN,
    ASSAMESE,
    AYMARA,
    AZERI,
    AZERI_CYRILLIC,
    AZERI_LATIN,
    BASHKIR,
    BASQUE,
    BELARUSIAN,
    BENGALI,
    BHUTANI,
    BIHARI,
    BISLAMA,
    BRETON,
    BULGARIAN,
    BURMESE,
    CAMBODIAN,
    CATALAN,
    CHINESE,
    CHINESE_SIMPLIFIED,
    CHINESE_TRADITIONAL,
    CHINESE_HONGKONG,
    CHINESE_MACAU,
    CHINESE_SINGAPORE,
    CHINESE_TAIWAN,
    CORSICAN,
    CROATIAN,
    CZECH,
    DANISH,
    DUTCH,
    DUTCH_BELGIAN,
    ENGLISH,
    ENGLISH_UK,
    ENGLISH_US,
    ENGLISH_AUSTRALIA,
    ENGLISH_BELIZE,
    ENGLISH_BOTSWANA,
    ENGLISH_CANADA,
    ENGLISH_CARIBBEAN,
    ENGLISH_DENMARK,
    ENGLISH_EIRE,
    ENGLISH_JAMAICA,
    ENGLISH_NEW_ZEALAND,
    ENGLISH_PHILIPPINES,
    ENGLISH_SOUTH_AFRICA,
    ENGLISH_TRINIDAD,
    ENGLISH_ZIMBABWE,
    ESPERANTO,
    ESTONIAN,
    FAEROESE,
    FARSI,
    FIJI,
    FINNISH,
    FRENCH,
    FRENCH_BELGIAN,
    FRENCH_CANADIAN,
    FRENCH_LUXEMBOURG,
    FRENCH_MONACO,
    FRENCH_SWISS,
    FRISIAN,
    GALICIAN,
    GEORGIAN,
    GERMAN,
    GERMAN_AUSTRIAN,
    GERMAN_BELGIUM,
    GERMAN_LIECHTENSTEIN,
    GERMAN_LUXEMBOURG,
    GERMAN_SWISS,
    GREEK,
    GREENLANDIC,
    GUARANI,
    GUJARATI,
    HAUSA,
    HEBREW,
    HINDI,
    HUNGARIAN,
    ICELANDIC,
    INDONESIAN,
    INTERLINGUA,
    INTERLINGUE,
    INUKTITUT,
    INUPIAK,
    IRISH,
    ITALIAN,
    ITALIAN_SWISS,
    JAPANESE,
    JAVANESE,
    KANNADA,
    KASHMIRI,
    KASHMIRI_INDIA,
    KAZAKH,
    KERNEWEK,
    KINYARWANDA,
    KIRGHIZ,
    KIRUNDI,
    KONKANI,
    KOREAN,
    KURDISH,
    LAOTHIAN,
    LATIN,
    LATVIAN,
    LINGALA,
    LITHUANIAN,
    MACEDONIAN,
    MALAGASY,
    MALAY,
    MALAYALAM,
    MALAY_BRUNEI_DARUSSALAM,
    MALAY_MALAYSIA,
    MALTESE,
    MANIPURI,
    MAORI,
    MARATHI,
    MOLDAVIAN,
    MONGOLIAN,
    NAURU,
    NEPALI,
    NEPALI_INDIA,
    NORWEGIAN_BOKMAL,
    NORWEGIAN_NYNORSK,
    OCCITAN,
    ORIYA,
    OROMO,
    PASHTO,
    POLISH,
    PORTUGUESE,
    PORTUGUESE_BRAZILIAN,
    PUNJABI,
    QUECHUA,
    RHAETO_ROMANCE,
    ROMANIAN,
    RUSSIAN,
    RUSSIAN_UKRAINE,
    SAMOAN,
    SANGHO,
    SANSKRIT,
    SCOTS_GAELIC,
    SERBIAN,
    SERBIAN_CYRILLIC,
    SERBIAN_LATIN,
    SERBO_CROATIAN,
    SESOTHO,
    SETSWANA,
    SHONA,
    SINDHI,
    SINHALESE,
    SISWATI,
    SLOVAK,
    SLOVENIAN,
    SOMALI,
    SPANISH,
    SPANISH_ARGENTINA,
    SPANISH_BOLIVIA,
    SPANISH_CHILE,
    SPANISH_COLOMBIA,
    SPANISH_COSTA_RICA,
    SPANISH_DOMINICAN_REPUBLIC,
    SPANISH_ECUADOR,
    SPANISH_EL_SALVADOR,
    SPANISH_GUATEMALA,
    SPANISH_HONDURAS,
    SPANISH_MEXICAN,
    SPANISH_MODERN,
    SPANISH_NICARAGUA,
    SPANISH_PANAMA,
    SPANISH_PARAGUAY,
    SPANISH_PERU,
    SPANISH_PUERTO_RICO,
    SPANISH_URUGUAY,
    SPANISH_US,
    SPANISH_VENEZUELA,
    SUNDANESE,
    SWAHILI,
    SWEDISH,
    SWEDISH_FINLAND,
    TAGALOG,
    TAJIK,
    TAMIL,
    TATAR,
    TELUGU,
    THAI,
    TIBETAN,
    TIGRINYA,
    TONGA,
    TSONGA,
    TURKISH,
    TURKMEN,
    TWI,
    UIGHUR,
    UKRAINIAN,
    URDU,
    URDU_INDIA,
    URDU_PAKISTAN,
    UZBEK,
    UZBEK_CYRILLIC,
    UZBEK_LATIN,
    VIETNAMESE,
    VOLAPUK,
    WELSH,
    WOLOF,
    XHOSA,
    YIDDISH,
    YORUBA,
    ZHUANG,
    ZULU,

    USER_DEFINED
}

//-----------------------------------------------------------------------------

public enum ПЛокальКатегория
{
    Число,
    Дата,
    Деньги,
    Макс
}

//-----------------------------------------------------------------------------

public enum ПИнфОЛокале
{
    РазделитТысяч,
    ДесятичнТчк
}

//-----------------------------------------------------------------------------

public enum ПИницФлагиЛокали
{
    ЗагрузитьДефолт  = 0x0001,
    КонвКодировку = 0x0002
}

//-----------------------------------------------------------------------------

extern(D) class ИнфОЯзыке : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    //private this(ЦелУкз вхобъ, бул памСобств);
    public this();
    //public static ВизОбъект Нов(ЦелУкз укз);
    ~this();
    public цел язык();
    public проц язык(цел значение);
    public ткст канонИмя();
    public проц канонИмя(ткст значение);
    public ткст описание();
    public проц описание(ткст значение);
}

//-----------------------------------------------------------------------------


extern(D) class Локаль : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    //private this(ЦелУкз вхобъ, бул памСобств);
    public this();
    public this(цел язык);
    public this(цел язык, ПИницФлагиЛокали флаги);
    ~this();
    public бул иниц();
    public бул иниц(ПЯзык язык);
    public бул иниц(ПЯзык язык, ПИницФлагиЛокали флаги);
    public бул добавьКаталог(ткст стрДомен);
    public бул добавьКаталог(ткст стрДомен, ПЯзык языкидаСооб, ткст гарнитураидаСооб);
    public проц добавьПрефиксПутиПоискаКаталога(ткст префикс);
    public static проц добавьЯзык(ИнфОЯзыке инфо);
    public static ИнфОЯзыке найдиИнфОЯзыке(ткст локаль);
    public ткст канонИмя();
    public ПЯзык язык();
    public static ИнфОЯзыке дайИнфОЯзыке(ПЯзык яз);
    public static ткст дайИмяЯзыка(ПЯзык яз);
    public ткст дайЛокаль();
    public ткст имя();
    public ткст дайТкст(ткст стрОриг);
    public ткст дайТкст(ткст стрОриг, ткст стрДомен);
    public ткст дайЗначениеЗаголовка(ткст стрЗаг);
    public ткст дайЗначениеЗаголовка(ткст стрЗаг, ткст стрДомен);
    public ткст сисИмя();
    static ПКодировкаШрифта сисКодировка();
    static ткст имяСисКодировки();
    static ПЯзык сисЯзык();
    public бул загружен(ткст домен);
    public бул Ок();
}
