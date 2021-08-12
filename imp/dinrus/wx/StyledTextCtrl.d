module wx.StyledTextCtrl;
//version = WXD_STYLEDTEXTCTRL;

//! \cond VERSION
version(WXD_STYLEDTEXTCTRL)
{
//! \endcond
    //-----------------------------------------------------------------------------

    extern(D) class СтильныйТекстКтрл : Контрол
    {
        // СтильныйТекстКтрл Events

        public static ТипСобытия СОБ_СТК_ИЗМЕНЕНИЕ;
        public static ТипСобытия СОБ_СТК_НУЖНЫЙСТИЛЬ;
        public static ТипСобытия СОБ_СТК_ДОБАВЛЕНСИМ;
        public static ТипСобытия СОБ_СТК_ДОСТИГНУТАТОЧКАСОХРАНЕНИЯ;
        public static ТипСобытия СОБ_СТК_ПОКИНУТАТОЧКАСОХРАНЕНИЯ;
        public static ТипСобытия wxEVT_STC_ROMODIFYATTEMPT;
        public static ТипСобытия СОБ_СТК_КЛАВИША;
        public static ТипСобытия СОБ_СТК_ДНАЖАТИЕ;
        public static ТипСобытия СОБ_СТК_ОБНОВИТЬИП;
        public static ТипСобытия СОБ_СТК_МОДИФИЦИРОВАН;
        public static ТипСобытия СОБ_СТК_ЗАПИСЬМАКРОСА;
        public static ТипСобытия СОБ_СТК_НАЖАТМАРЖИН;
        public static ТипСобытия СОБ_СТК_НУЖЕНПОКАЗ;
        //public static ТипСобытия wxEVT_STC_POSCHANGED;
        public static ТипСобытия СОБ_СТК_ОТРИСОВАН;
        public static ТипСобытия СОБ_СТК_ВЫДЕЛЕНИЕПОЛЬЗОВАТЕЛЕМСПИСКА;
        public static ТипСобытия СОБ_СТК_БРОШЕНУИР;
        public static ТипСобытия wxEVT_STC_DWELLSTART;
        public static ТипСобытия wxEVT_STC_DWELLEND;
        public static ТипСобытия СОБ_СТК_НАЧАЛО_ТЯГА;
        public static ТипСобытия СОБ_СТК_КОНЕЦ_ТЯГА;
        public static ТипСобытия СОБ_СТК_БРОСЬ_ДРОП;
        public static ТипСобытия СОБ_СТК_ЗУМ;
        public static ТипСобытия wxEVT_STC_HOTSPOT_CLICK;
        public static ТипСобытия wxEVT_STC_HOTSPOT_DCLICK;
        public static ТипСобытия wxEVT_STC_CALLTIP_CLICK;

        //-----------------------------------------------------------------------------

        public const цел wxSTC_INVALID_POSITION = -1;

        // Define старт of Scintilla messages до be greater than all edit (EM_*) messages
        // as many EM_ messages can be used although that use is deprecated.
        public const цел wxSTC_START = 2000;
        public const цел wxSTC_OPTIONAL_START = 3000;
        public const цел wxSTC_LEXER_START = 4000;
        public const цел wxSTC_WS_INVISIBLE = 0;
        public const цел wxSTC_WS_VISIBLEALWAYS = 1;
        public const цел wxSTC_WS_VISIBLEAFTERINDENT = 2;
        public const цел wxSTC_EOL_CRLF = 0;
        public const цел wxSTC_EOL_CR = 1;
        public const цел wxSTC_EOL_LF = 2;

        // The SC_CP_UTF8 значение can be used до enter Unicode режим.
        // This is the same значение as CP_UTF8 in Windows
        public const цел wxSTC_CP_UTF8 = 65001;

        // The SC_CP_DBCS значение can be used до indicate a DBCS режим for GTK+.
        public const цел wxSTC_CP_DBCS = 1;
        public const цел wxSTC_MARKER_MAX = 31;
        public const цел wxSTC_MARK_CIRCLE = 0;
        public const цел wxSTC_MARK_ROUNDRECT = 1;
        public const цел wxSTC_MARK_ARROW = 2;
        public const цел wxSTC_MARK_SMALLRECT = 3;
        public const цел wxSTC_MARK_SHORTARROW = 4;
        public const цел wxSTC_MARK_EMPTY = 5;
        public const цел wxSTC_MARK_ARROWDOWN = 6;
        public const цел wxSTC_MARK_MINUS = 7;
        public const цел wxSTC_MARK_PLUS = 8;

        // Shapes used for outlining колонка.
        public const цел wxSTC_MARK_VLINE = 9;
        public const цел wxSTC_MARK_LCORNER = 10;
        public const цел wxSTC_MARK_TCORNER = 11;
        public const цел wxSTC_MARK_BOXPLUS = 12;
        public const цел wxSTC_MARK_BOXPLUSCONNECTED = 13;
        public const цел wxSTC_MARK_BOXMINUS = 14;
        public const цел wxSTC_MARK_BOXMINUSCONNECTED = 15;
        public const цел wxSTC_MARK_LCORNERCURVE = 16;
        public const цел wxSTC_MARK_TCORNERCURVE = 17;
        public const цел wxSTC_MARK_CIRCLEPLUS = 18;
        public const цел wxSTC_MARK_CIRCLEPLUSCONNECTED = 19;
        public const цел wxSTC_MARK_CIRCLEMINUS = 20;
        public const цел wxSTC_MARK_CIRCLEMINUSCONNECTED = 21;

        // Invisible mark that only sets the строка заднийПлан цв.
        public const цел wxSTC_MARK_BACKGROUND = 22;
        public const цел wxSTC_MARK_DOTDOTDOT = 23;
        public const цел wxSTC_MARK_ARROWS = 24;
        public const цел wxSTC_MARK_PIXMAP = 25;
        public const цел wxSTC_MARK_CHARACTER = 10000;

        // Markers used for outlining колонка.
        public const цел wxSTC_MARKNUM_FOLDEREND = 25;
        public const цел wxSTC_MARKNUM_FOLDEROPENMID = 26;
        public const цел wxSTC_MARKNUM_FOLDERMIDTAIL = 27;
        public const цел wxSTC_MARKNUM_FOLDERTAIL = 28;
        public const цел wxSTC_MARKNUM_FOLDERSUB = 29;
        public const цел wxSTC_MARKNUM_FOLDER = 30;
        public const цел wxSTC_MARKNUM_FOLDEROPEN = 31;
        public const цел wxSTC_MASK_FOLDERS = -1;
        public const цел wxSTC_MARGIN_SYMBOL = 0;
        public const цел wxSTC_MARGIN_NUMBER = 1;

        // Styles in диапазон 32..37 are predefined for parts of the UI and are not used as normal styles.
        // Styles 38 and 39 are for future use.
        public const цел wxSTC_STYLE_Дефолт = 32;
        public const цел wxSTC_STYLE_LINENUMBER = 33;
        public const цел wxSTC_STYLE_BRACELIGHT = 34;
        public const цел wxSTC_STYLE_BRACEBAD = 35;
        public const цел wxSTC_STYLE_CONTROLCHAR = 36;
        public const цел wxSTC_STYLE_INDENTGUIDE = 37;
        public const цел wxSTC_STYLE_LASTPREDEFINED = 39;
        public const цел wxSTC_STYLE_MAX = 127;

        // Character set identifiers are used in StyleSetCharacterSet.
        // The values are the same as the Windows *_CHARSET values.
        public const цел wxSTC_CHARSET_ANSI = 0;
        public const цел wxSTC_CHARSET_Дефолт = 1;
        public const цел wxSTC_CHARSET_BALTIC = 186;
        public const цел wxSTC_CHARSET_CHINESEBIG5 = 136;
        public const цел wxSTC_CHARSET_EASTEUROPE = 238;
        public const цел wxSTC_CHARSET_GB2312 = 134;
        public const цел wxSTC_CHARSET_GREEK = 161;
        public const цел wxSTC_CHARSET_HANGUL = 129;
        public const цел wxSTC_CHARSET_MAC = 77;
        public const цел wxSTC_CHARSET_OEM = 255;
        public const цел wxSTC_CHARSET_RUSSIAN = 204;
        public const цел wxSTC_CHARSET_SHIFTJIS = 128;
        public const цел wxSTC_CHARSET_SYMBOL = 2;
        public const цел wxSTC_CHARSET_TURKISH = 162;
        public const цел wxSTC_CHARSET_JOHAB = 130;
        public const цел wxSTC_CHARSET_HEBREW = 177;
        public const цел wxSTC_CHARSET_ARABIC = 178;
        public const цел wxSTC_CHARSET_VIETNAMESE = 163;
        public const цел wxSTC_CHARSET_THAI = 222;
        public const цел wxSTC_CASE_MIXED = 0;
        public const цел wxSTC_CASE_UPPER = 1;
        public const цел wxSTC_CASE_LOWER = 2;
        public const цел wxSTC_INDIC_MAX = 7;
        public const цел wxSTC_INDIC_PLAIN = 0;
        public const цел wxSTC_INDIC_SQUIGGLE = 1;
        public const цел wxSTC_INDIC_TT = 2;
        public const цел wxSTC_INDIC_DIAGONAL = 3;
        public const цел wxSTC_INDIC_STRIKE = 4;
        public const цел wxSTC_INDIC0_MASK = 0x20;
        public const цел wxSTC_INDIC1_MASK = 0x40;
        public const цел wxSTC_INDIC2_MASK = 0x80;
        public const цел wxSTC_INDICS_MASK = 0xE0;

        // режимЦветнойПечати - use same colours as screen.
        public const цел wxSTC_PRINT_NORMAL = 0;

        // режимЦветнойПечати - invert the light значение of each стиль for printing.
        public const цел wxSTC_PRINT_INVERTLIGHT = 1;

        // режимЦветнойПечати - сила black текст on white заднийПлан for printing.
        public const цел wxSTC_PRINT_BLACKONWHITE = 2;

        // режимЦветнойПечати - текст stays coloured, кноп all заднийПлан is forced до be white for printing.
        public const цел wxSTC_PRINT_COLOURONWHITE = 3;

        // режимЦветнойПечати - only the default-заднийПлан is forced до be white for printing.
        public const цел wxSTC_PRINT_COLOURONWHITEДефолтBG = 4;
        public const цел wxSTC_FIND_WHOLEWORD = 2;
        public const цел wxSTC_FIND_MATCHCASE = 4;
        public const цел wxSTC_FIND_WORDSTART = 0x00100000;
        public const цел wxSTC_FIND_REGEXP = 0x00200000;
        public const цел wxSTC_FIND_POSIX = 0x00400000;
        public const цел wxSTC_FOLDLEVELBASE = 0x400;
        public const цел wxSTC_FOLDLEVELWHITEFLAG = 0x1000;
        public const цел wxSTC_FOLDLEVELHEADERFLAG = 0x2000;
        public const цел wxSTC_FOLDLEVELBOXHEADERFLAG = 0x4000;
        public const цел wxSTC_FOLDLEVELBOXFOOTERFLAG = 0x8000;
        public const цел wxSTC_FOLDLEVELCONTRACTED = 0x10000;
        public const цел wxSTC_FOLDLEVELUNINDENT = 0x20000;
        public const цел wxSTC_FOLDLEVELNUMBERMASK = 0x0FFF;
        public const цел wxSTC_FOLDFLAG_LINEBEFORE_EXPANDED = 0x0002;
        public const цел wxSTC_FOLDFLAG_LINEBEFORE_CONTRACTED = 0x0004;
        public const цел wxSTC_FOLDFLAG_LINEAFTER_EXPANDED = 0x0008;
        public const цел wxSTC_FOLDFLAG_LINEAFTER_CONTRACTED = 0x0010;
        public const цел wxSTC_FOLDFLAG_LEVELNUMBERS = 0x0040;
        public const цел wxSTC_FOLDFLAG_BOX = 0x0001;
        public const цел wxSTC_TIME_FOREVER = 10000000;
        public const цел wxSTC_WRAP_Нет = 0;
        public const цел wxSTC_WRAP_WORD = 1;
        public const цел wxSTC_CACHE_Нет = 0;
        public const цел wxSTC_CACHE_CARET = 1;
        public const цел wxSTC_CACHE_PAGE = 2;
        public const цел wxSTC_CACHE_DOCUMENT = 3;
        public const цел wxSTC_EDGE_Нет = 0;
        public const цел wxSTC_EDGE_LINE = 1;
        public const цел wxSTC_EDGE_BACKGROUND = 2;
        public const цел wxSTC_CURSORNORMAL = -1;
        public const цел wxSTC_CURSORWAIT = 4;

        // Constants for use with SetVisiblePolicy, similar до SetCaretPolicy.
        public const цел wxSTC_VISIBLE_SLOP = 0x01;
        public const цел wxSTC_VISIBLE_STRICT = 0x04;

        // Каретка policy, used by SetXCaretPolicy and SetYCaretPolicy.
        // If CARET_SLOP is set, we can define a slop значение: caretSlop.
        // This значение defines an unwanted zone (UZ) where the каретка is... unwanted.
        // This zone is defined as a число of pixels near the vertical margins,
        // and as a число of строки near the horizontal margins.
        // By keeping the каретка away от the edges, it is seen within its context,
        // so it is likely that the identifier that the каретка is on can be completely seen,
        // and that the current строка is seen with some of the строки following it который are
        // often dependent on that строка.
        public const цел wxSTC_CARET_SLOP = 0x01;

        // If CARET_STRICT is set, the policy is enforced... strictly.
        // The каретка is centred on the display if slop is not set,
        // and cannot go in the UZ if slop is set.
        public const цел wxSTC_CARET_STRICT = 0x04;

        // If CARET_JUMPS is set, the display is moved more energetically
        // so the каретка can move in the same направление longer перед the policy is applied again.
        public const цел wxSTC_CARET_JUMPS = 0x10;

        // If CARET_EVEN is not set, instead of having symmetrical UZs,
        // the left and bottom UZs are extended up до right and top UZs respectively.
        // This way, we favour the displaying of useful information: the begining of строки,
        // where most код reside, and the строки after the каретка, eg. the body of a function.
        public const цел wxSTC_CARET_EVEN = 0x08;

        // Notifications
        // тип of modification and the action который caused the modification.
        // These are defined as a bit маска до make it easy до specify который notifications are wanted.
        // One bit is set от each of SC_MOD_* and SC_PERFORMED_*.
        public const цел wxSTC_MOD_INSERTTEXT = 0x1;
        public const цел wxSTC_MOD_DELETETEXT = 0x2;
        public const цел wxSTC_MOD_CHANGESTYLE = 0x4;
        public const цел wxSTC_MOD_CHANGEFOLD = 0x8;
        public const цел wxSTC_PERFORMED_USER = 0x10;
        public const цел wxSTC_PERFORMED_UNDO = 0x20;
        public const цел wxSTC_PERFORMED_REDO = 0x40;
        public const цел wxSTC_LASTSTEPINUNDOREDO = 0x100;
        public const цел wxSTC_MOD_CHANGEMARKER = 0x200;
        public const цел wxSTC_MOD_BEFOREINSERT = 0x400;
        public const цел wxSTC_MOD_BEFOREDELETE = 0x800;
        public const цел wxSTC_MODEVENTMASKALL = 0xF77;

        // Symbolic ключ codes and modifier флаги.
        // ASCII and другой printable characters below 256.
        // Extended keys above 300.
        public const цел wxSTC_KEY_DOWN = 300;
        public const цел wxSTC_KEY_UP = 301;
        public const цел wxSTC_KEY_LEFT = 302;
        public const цел wxSTC_KEY_RIGHT = 303;
        public const цел wxSTC_KEY_HOME = 304;
        public const цел wxSTC_KEY_END = 305;
        public const цел wxSTC_KEY_PRIOR = 306;
        public const цел wxSTC_KEY_NEXT = 307;
        public const цел wxSTC_KEY_DELETE = 308;
        public const цел wxSTC_KEY_INSERT = 309;
        public const цел wxSTC_KEY_ESCAPE = 7;
        public const цел wxSTC_KEY_BACK = 8;
        public const цел wxSTC_KEY_TAB = 9;
        public const цел wxSTC_KEY_RETURN = 13;
        public const цел wxSTC_KEY_ADD = 310;
        public const цел wxSTC_KEY_SUBTRACT = 311;
        public const цел wxSTC_KEY_DIVIDE = 312;
        public const цел wxSTC_SCMOD_SHIFT = 1;
        public const цел wxSTC_SCMOD_CTRL = 2;
        public const цел wxSTC_SCMOD_ALT = 4;

        // For Sciлексер.h
        public const цел wxSTC_LEX_CONTAINER = 0;
        public const цел wxSTC_LEX_NULL = 1;
        public const цел wxSTC_LEX_PYTHON = 2;
        public const цел wxSTC_LEX_CPP = 3;
        public const цел wxSTC_LEX_HTML = 4;
        public const цел wxSTC_LEX_XML = 5;
        public const цел wxSTC_LEX_PERL = 6;
        public const цел wxSTC_LEX_SQL = 7;
        public const цел wxSTC_LEX_VB = 8;
        public const цел wxSTC_LEX_PROPERTIES = 9;
        public const цел wxSTC_LEX_ERRORLIST = 10;
        public const цел wxSTC_LEX_MAKEFILE = 11;
        public const цел wxSTC_LEX_BATCH = 12;
        public const цел wxSTC_LEX_XCODE = 13;
        public const цел wxSTC_LEX_LATEX = 14;
        public const цел wxSTC_LEX_LUA = 15;
        public const цел wxSTC_LEX_DIFF = 16;
        public const цел wxSTC_LEX_CONF = 17;
        public const цел wxSTC_LEX_PASCAL = 18;
        public const цел wxSTC_LEX_AVE = 19;
        public const цел wxSTC_LEX_ADA = 20;
        public const цел wxSTC_LEX_LISP = 21;
        public const цел wxSTC_LEX_RUBY = 22;
        public const цел wxSTC_LEX_EIFFEL = 23;
        public const цел wxSTC_LEX_EIFFELKW = 24;
        public const цел wxSTC_LEX_TCL = 25;
        public const цел wxSTC_LEX_NNCRONTAB = 26;
        public const цел wxSTC_LEX_BULLANT = 27;
        public const цел wxSTC_LEX_VBSCRIPT = 28;
        public const цел wxSTC_LEX_ASP = 29;
        public const цел wxSTC_LEX_PHP = 30;
        public const цел wxSTC_LEX_BAAN = 31;
        public const цел wxSTC_LEX_MATLAB = 32;
        public const цел wxSTC_LEX_SCRIPTOL = 33;
        public const цел wxSTC_LEX_ASM = 34;
        public const цел wxSTC_LEX_CPPNOCASE = 35;
        public const цел wxSTC_LEX_FORTRAN = 36;
        public const цел wxSTC_LEX_F77 = 37;
        public const цел wxSTC_LEX_CSS = 38;
        public const цел wxSTC_LEX_POV = 39;

        // When a lexer specifies its язык as SCLEX_AUTOMATIC it receives a
        // значение assigned in sequence от SCLEX_AUTOMATIC+1.
        public const цел wxSTC_LEX_AUTOMATIC = 1000;

        // Lexical states for SCLEX_PYTHON
        public const цел wxSTC_P_Дефолт = 0;
        public const цел wxSTC_P_COMMENTLINE = 1;
        public const цел wxSTC_P_NUMBER = 2;
        public const цел wxSTC_P_STRING = 3;
        public const цел wxSTC_P_CHARACTER = 4;
        public const цел wxSTC_P_WORD = 5;
        public const цел wxSTC_P_TRIPLE = 6;
        public const цел wxSTC_P_TRIPLEDOUBLE = 7;
        public const цел wxSTC_P_CLASSNAME = 8;
        public const цел wxSTC_P_DEFNAME = 9;
        public const цел wxSTC_P_OPERATOR = 10;
        public const цел wxSTC_P_IDENTIFIER = 11;
        public const цел wxSTC_P_COMMENTBLOCK = 12;
        public const цел wxSTC_P_STRINGEOL = 13;

        // Lexical states for SCLEX_CPP
        public const цел wxSTC_C_Дефолт = 0;
        public const цел wxSTC_C_COMMENT = 1;
        public const цел wxSTC_C_COMMENTLINE = 2;
        public const цел wxSTC_C_COMMENTDOC = 3;
        public const цел wxSTC_C_NUMBER = 4;
        public const цел wxSTC_C_WORD = 5;
        public const цел wxSTC_C_STRING = 6;
        public const цел wxSTC_C_CHARACTER = 7;
        public const цел wxSTC_C_UUID = 8;
        public const цел wxSTC_C_PREPROCESSOR = 9;
        public const цел wxSTC_C_OPERATOR = 10;
        public const цел wxSTC_C_IDENTIFIER = 11;
        public const цел wxSTC_C_STRINGEOL = 12;
        public const цел wxSTC_C_VERBATIM = 13;
        public const цел wxSTC_C_REGEX = 14;
        public const цел wxSTC_C_COMMENTLINEDOC = 15;
        public const цел wxSTC_C_WORD2 = 16;
        public const цел wxSTC_C_COMMENTDOCKEYWORD = 17;
        public const цел wxSTC_C_COMMENTDOCKEYWORDERROR = 18;

        // Lexical states for SCLEX_HTML, SCLEX_XML
        public const цел wxSTC_H_Дефолт = 0;
        public const цел wxSTC_H_TAG = 1;
        public const цел wxSTC_H_TAGUNKNOWN = 2;
        public const цел wxSTC_H_ATTRIBUTE = 3;
        public const цел wxSTC_H_ATTRIBUTEUNKNOWN = 4;
        public const цел wxSTC_H_NUMBER = 5;
        public const цел wxSTC_H_DOUBLESTRING = 6;
        public const цел wxSTC_H_SINGLESTRING = 7;
        public const цел wxSTC_H_OTHER = 8;
        public const цел wxSTC_H_COMMENT = 9;
        public const цел wxSTC_H_ENTITY = 10;

        // XML and ASP
        public const цел wxSTC_H_TAGEND = 11;
        public const цел wxSTC_H_XMLSTART = 12;
        public const цел wxSTC_H_XMLEND = 13;
        public const цел wxSTC_H_SCRIPT = 14;
        public const цел wxSTC_H_ASP = 15;
        public const цел wxSTC_H_ASPAT = 16;
        public const цел wxSTC_H_CDATA = 17;
        public const цел wxSTC_H_QUESTION = 18;

        // More HTML
        public const цел wxSTC_H_VALUE = 19;

        // Х-Code
        public const цел wxSTC_H_XCCOMMENT = 20;

        // SGML
        public const цел wxSTC_H_SGML_Дефолт = 21;
        public const цел wxSTC_H_SGML_COMMAND = 22;
        public const цел wxSTC_H_SGML_1ST_PARAM = 23;
        public const цел wxSTC_H_SGML_DOUBLESTRING = 24;
        public const цел wxSTC_H_SGML_SIMPLESTRING = 25;
        public const цел wxSTC_H_SGML_ERROR = 26;
        public const цел wxSTC_H_SGML_SPECIAL = 27;
        public const цел wxSTC_H_SGML_ENTITY = 28;
        public const цел wxSTC_H_SGML_COMMENT = 29;
        public const цел wxSTC_H_SGML_1ST_PARAM_COMMENT = 30;
        public const цел wxSTC_H_SGML_BLOCK_Дефолт = 31;

        // Embedded Javascript
        public const цел wxSTC_HJ_START = 40;
        public const цел wxSTC_HJ_Дефолт = 41;
        public const цел wxSTC_HJ_COMMENT = 42;
        public const цел wxSTC_HJ_COMMENTLINE = 43;
        public const цел wxSTC_HJ_COMMENTDOC = 44;
        public const цел wxSTC_HJ_NUMBER = 45;
        public const цел wxSTC_HJ_WORD = 46;
        public const цел wxSTC_HJ_KEYWORD = 47;
        public const цел wxSTC_HJ_DOUBLESTRING = 48;
        public const цел wxSTC_HJ_SINGLESTRING = 49;
        public const цел wxSTC_HJ_SYMBOLS = 50;
        public const цел wxSTC_HJ_STRINGEOL = 51;
        public const цел wxSTC_HJ_REGEX = 52;

        // ASP Javascript
        public const цел wxSTC_HJA_START = 55;
        public const цел wxSTC_HJA_Дефолт = 56;
        public const цел wxSTC_HJA_COMMENT = 57;
        public const цел wxSTC_HJA_COMMENTLINE = 58;
        public const цел wxSTC_HJA_COMMENTDOC = 59;
        public const цел wxSTC_HJA_NUMBER = 60;
        public const цел wxSTC_HJA_WORD = 61;
        public const цел wxSTC_HJA_KEYWORD = 62;
        public const цел wxSTC_HJA_DOUBLESTRING = 63;
        public const цел wxSTC_HJA_SINGLESTRING = 64;
        public const цел wxSTC_HJA_SYMBOLS = 65;
        public const цел wxSTC_HJA_STRINGEOL = 66;
        public const цел wxSTC_HJA_REGEX = 67;

        // Embedded VBScript
        public const цел wxSTC_HB_START = 70;
        public const цел wxSTC_HB_Дефолт = 71;
        public const цел wxSTC_HB_COMMENTLINE = 72;
        public const цел wxSTC_HB_NUMBER = 73;
        public const цел wxSTC_HB_WORD = 74;
        public const цел wxSTC_HB_STRING = 75;
        public const цел wxSTC_HB_IDENTIFIER = 76;
        public const цел wxSTC_HB_STRINGEOL = 77;

        // ASP VBScript
        public const цел wxSTC_HBA_START = 80;
        public const цел wxSTC_HBA_Дефолт = 81;
        public const цел wxSTC_HBA_COMMENTLINE = 82;
        public const цел wxSTC_HBA_NUMBER = 83;
        public const цел wxSTC_HBA_WORD = 84;
        public const цел wxSTC_HBA_STRING = 85;
        public const цел wxSTC_HBA_IDENTIFIER = 86;
        public const цел wxSTC_HBA_STRINGEOL = 87;

        // Embedded Python
        public const цел wxSTC_HP_START = 90;
        public const цел wxSTC_HP_Дефолт = 91;
        public const цел wxSTC_HP_COMMENTLINE = 92;
        public const цел wxSTC_HP_NUMBER = 93;
        public const цел wxSTC_HP_STRING = 94;
        public const цел wxSTC_HP_CHARACTER = 95;
        public const цел wxSTC_HP_WORD = 96;
        public const цел wxSTC_HP_TRIPLE = 97;
        public const цел wxSTC_HP_TRIPLEDOUBLE = 98;
        public const цел wxSTC_HP_CLASSNAME = 99;
        public const цел wxSTC_HP_DEFNAME = 100;
        public const цел wxSTC_HP_OPERATOR = 101;
        public const цел wxSTC_HP_IDENTIFIER = 102;

        // ASP Python
        public const цел wxSTC_HPA_START = 105;
        public const цел wxSTC_HPA_Дефолт = 106;
        public const цел wxSTC_HPA_COMMENTLINE = 107;
        public const цел wxSTC_HPA_NUMBER = 108;
        public const цел wxSTC_HPA_STRING = 109;
        public const цел wxSTC_HPA_CHARACTER = 110;
        public const цел wxSTC_HPA_WORD = 111;
        public const цел wxSTC_HPA_TRIPLE = 112;
        public const цел wxSTC_HPA_TRIPLEDOUBLE = 113;
        public const цел wxSTC_HPA_CLASSNAME = 114;
        public const цел wxSTC_HPA_DEFNAME = 115;
        public const цел wxSTC_HPA_OPERATOR = 116;
        public const цел wxSTC_HPA_IDENTIFIER = 117;

        // PHP
        public const цел wxSTC_HPHP_Дефолт = 118;
        public const цел wxSTC_HPHP_HSTRING = 119;
        public const цел wxSTC_HPHP_SIMPLESTRING = 120;
        public const цел wxSTC_HPHP_WORD = 121;
        public const цел wxSTC_HPHP_NUMBER = 122;
        public const цел wxSTC_HPHP_VARIABLE = 123;
        public const цел wxSTC_HPHP_COMMENT = 124;
        public const цел wxSTC_HPHP_COMMENTLINE = 125;
        public const цел wxSTC_HPHP_HSTRING_VARIABLE = 126;
        public const цел wxSTC_HPHP_OPERATOR = 127;

        // Lexical states for SCLEX_PERL
        public const цел wxSTC_PL_Дефолт = 0;
        public const цел wxSTC_PL_ERROR = 1;
        public const цел wxSTC_PL_COMMENTLINE = 2;
        public const цел wxSTC_PL_POD = 3;
        public const цел wxSTC_PL_NUMBER = 4;
        public const цел wxSTC_PL_WORD = 5;
        public const цел wxSTC_PL_STRING = 6;
        public const цел wxSTC_PL_CHARACTER = 7;
        public const цел wxSTC_PL_PUNCTUATION = 8;
        public const цел wxSTC_PL_PREPROCESSOR = 9;
        public const цел wxSTC_PL_OPERATOR = 10;
        public const цел wxSTC_PL_IDENTIFIER = 11;
        public const цел wxSTC_PL_SCALAR = 12;
        public const цел wxSTC_PL_ARRAY = 13;
        public const цел wxSTC_PL_HASH = 14;
        public const цел wxSTC_PL_SYMBOLTABLE = 15;
        public const цел wxSTC_PL_REGEX = 17;
        public const цел wxSTC_PL_REGSUBST = 18;
        public const цел wxSTC_PL_LONGQUOTE = 19;
        public const цел wxSTC_PL_BACKTICKS = 20;
        public const цел wxSTC_PL_DATASECTION = 21;
        public const цел wxSTC_PL_HERE_DELIM = 22;
        public const цел wxSTC_PL_HERE_Q = 23;
        public const цел wxSTC_PL_HERE_QQ = 24;
        public const цел wxSTC_PL_HERE_QX = 25;
        public const цел wxSTC_PL_STRING_Q = 26;
        public const цел wxSTC_PL_STRING_QQ = 27;
        public const цел wxSTC_PL_STRING_QX = 28;
        public const цел wxSTC_PL_STRING_QR = 29;
        public const цел wxSTC_PL_STRING_QW = 30;

        // Lexical states for SCLEX_VB, SCLEX_VBSCRIPT
        public const цел wxSTC_B_Дефолт = 0;
        public const цел wxSTC_B_COMMENT = 1;
        public const цел wxSTC_B_NUMBER = 2;
        public const цел wxSTC_B_KEYWORD = 3;
        public const цел wxSTC_B_STRING = 4;
        public const цел wxSTC_B_PREPROCESSOR = 5;
        public const цел wxSTC_B_OPERATOR = 6;
        public const цел wxSTC_B_IDENTIFIER = 7;
        public const цел wxSTC_B_DATE = 8;

        // Lexical states for SCLEX_PROPERTIES
        public const цел wxSTC_PROPS_Дефолт = 0;
        public const цел wxSTC_PROPS_COMMENT = 1;
        public const цел wxSTC_PROPS_SECTION = 2;
        public const цел wxSTC_PROPS_ASSIGNMENT = 3;
        public const цел wxSTC_PROPS_DEFVAL = 4;

        // Lexical states for SCLEX_LATEX
        public const цел wxSTC_L_Дефолт = 0;
        public const цел wxSTC_L_COMMAND = 1;
        public const цел wxSTC_L_TAG = 2;
        public const цел wxSTC_L_MATH = 3;
        public const цел wxSTC_L_COMMENT = 4;

        // Lexical states for SCLEX_LUA
        public const цел wxSTC_LUA_Дефолт = 0;
        public const цел wxSTC_LUA_COMMENT = 1;
        public const цел wxSTC_LUA_COMMENTLINE = 2;
        public const цел wxSTC_LUA_COMMENTDOC = 3;
        public const цел wxSTC_LUA_NUMBER = 4;
        public const цел wxSTC_LUA_WORD = 5;
        public const цел wxSTC_LUA_STRING = 6;
        public const цел wxSTC_LUA_CHARACTER = 7;
        public const цел wxSTC_LUA_LITERALSTRING = 8;
        public const цел wxSTC_LUA_PREPROCESSOR = 9;
        public const цел wxSTC_LUA_OPERATOR = 10;
        public const цел wxSTC_LUA_IDENTIFIER = 11;
        public const цел wxSTC_LUA_STRINGEOL = 12;
        public const цел wxSTC_LUA_WORD2 = 13;
        public const цел wxSTC_LUA_WORD3 = 14;
        public const цел wxSTC_LUA_WORD4 = 15;
        public const цел wxSTC_LUA_WORD5 = 16;
        public const цел wxSTC_LUA_WORD6 = 17;

        // Lexical states for SCLEX_ERRORLIST
        public const цел wxSTC_ERR_Дефолт = 0;
        public const цел wxSTC_ERR_PYTHON = 1;
        public const цел wxSTC_ERR_GCC = 2;
        public const цел wxSTC_ERR_MS = 3;
        public const цел wxSTC_ERR_CMD = 4;
        public const цел wxSTC_ERR_BORLAND = 5;
        public const цел wxSTC_ERR_PERL = 6;
        public const цел wxSTC_ERR_NET = 7;
        public const цел wxSTC_ERR_LUA = 8;
        public const цел wxSTC_ERR_CTAG = 9;
        public const цел wxSTC_ERR_DIFF_CHANGED = 10;
        public const цел wxSTC_ERR_DIFF_ADDITION = 11;
        public const цел wxSTC_ERR_DIFF_DELETION = 12;
        public const цел wxSTC_ERR_DIFF_MESSAGE = 13;
        public const цел wxSTC_ERR_PHP = 14;
        public const цел wxSTC_ERR_ELF = 15;
        public const цел wxSTC_ERR_IFC = 16;

        // Lexical states for SCLEX_BATCH
        public const цел wxSTC_BAT_Дефолт = 0;
        public const цел wxSTC_BAT_COMMENT = 1;
        public const цел wxSTC_BAT_WORD = 2;
        public const цел wxSTC_BAT_LABEL = 3;
        public const цел wxSTC_BAT_HIDE = 4;
        public const цел wxSTC_BAT_COMMAND = 5;
        public const цел wxSTC_BAT_IDENTIFIER = 6;
        public const цел wxSTC_BAT_OPERATOR = 7;

        // Lexical states for SCLEX_MAKEFILE
        public const цел wxSTC_MAKE_Дефолт = 0;
        public const цел wxSTC_MAKE_COMMENT = 1;
        public const цел wxSTC_MAKE_PREPROCESSOR = 2;
        public const цел wxSTC_MAKE_IDENTIFIER = 3;
        public const цел wxSTC_MAKE_OPERATOR = 4;
        public const цел wxSTC_MAKE_TARGET = 5;
        public const цел wxSTC_MAKE_IDEOL = 9;

        // Lexical states for SCLEX_DIFF
        public const цел wxSTC_DIFF_Дефолт = 0;
        public const цел wxSTC_DIFF_COMMENT = 1;
        public const цел wxSTC_DIFF_COMMAND = 2;
        public const цел wxSTC_DIFF_HEADER = 3;
        public const цел wxSTC_DIFF_POSITION = 4;
        public const цел wxSTC_DIFF_DELETED = 5;
        public const цел wxSTC_DIFF_ADDED = 6;

        // Lexical states for SCLEX_CONF (Apache Configuration Files лексер)
        public const цел wxSTC_CONF_Дефолт = 0;
        public const цел wxSTC_CONF_COMMENT = 1;
        public const цел wxSTC_CONF_NUMBER = 2;
        public const цел wxSTC_CONF_IDENTIFIER = 3;
        public const цел wxSTC_CONF_EXTENSION = 4;
        public const цел wxSTC_CONF_PARAMETER = 5;
        public const цел wxSTC_CONF_STRING = 6;
        public const цел wxSTC_CONF_OPERATOR = 7;
        public const цел wxSTC_CONF_IP = 8;
        public const цел wxSTC_CONF_DIRECTIVE = 9;

        // Lexical states for SCLEX_AVE, Avenue
        public const цел wxSTC_AVE_Дефолт = 0;
        public const цел wxSTC_AVE_COMMENT = 1;
        public const цел wxSTC_AVE_NUMBER = 2;
        public const цел wxSTC_AVE_WORD = 3;
        public const цел wxSTC_AVE_STRING = 6;
        public const цел wxSTC_AVE_ENUM = 7;
        public const цел wxSTC_AVE_STRINGEOL = 8;
        public const цел wxSTC_AVE_IDENTIFIER = 9;
        public const цел wxSTC_AVE_OPERATOR = 10;
        public const цел wxSTC_AVE_WORD1 = 11;
        public const цел wxSTC_AVE_WORD2 = 12;
        public const цел wxSTC_AVE_WORD3 = 13;
        public const цел wxSTC_AVE_WORD4 = 14;
        public const цел wxSTC_AVE_WORD5 = 15;
        public const цел wxSTC_AVE_WORD6 = 16;

        // Lexical states for SCLEX_ADA
        public const цел wxSTC_ADA_Дефолт = 0;
        public const цел wxSTC_ADA_WORD = 1;
        public const цел wxSTC_ADA_IDENTIFIER = 2;
        public const цел wxSTC_ADA_NUMBER = 3;
        public const цел wxSTC_ADA_DELIMITER = 4;
        public const цел wxSTC_ADA_CHARACTER = 5;
        public const цел wxSTC_ADA_CHARACTEREOL = 6;
        public const цел wxSTC_ADA_STRING = 7;
        public const цел wxSTC_ADA_STRINGEOL = 8;
        public const цел wxSTC_ADA_LABEL = 9;
        public const цел wxSTC_ADA_COMMENTLINE = 10;
        public const цел wxSTC_ADA_ILLEGAL = 11;

        // Lexical states for SCLEX_BAAN
        public const цел wxSTC_BAAN_Дефолт = 0;
        public const цел wxSTC_BAAN_COMMENT = 1;
        public const цел wxSTC_BAAN_COMMENTDOC = 2;
        public const цел wxSTC_BAAN_NUMBER = 3;
        public const цел wxSTC_BAAN_WORD = 4;
        public const цел wxSTC_BAAN_STRING = 5;
        public const цел wxSTC_BAAN_PREPROCESSOR = 6;
        public const цел wxSTC_BAAN_OPERATOR = 7;
        public const цел wxSTC_BAAN_IDENTIFIER = 8;
        public const цел wxSTC_BAAN_STRINGEOL = 9;
        public const цел wxSTC_BAAN_WORD2 = 10;

        // Lexical states for SCLEX_LISP
        public const цел wxSTC_LISP_Дефолт = 0;
        public const цел wxSTC_LISP_COMMENT = 1;
        public const цел wxSTC_LISP_NUMBER = 2;
        public const цел wxSTC_LISP_KEYWORD = 3;
        public const цел wxSTC_LISP_STRING = 6;
        public const цел wxSTC_LISP_STRINGEOL = 8;
        public const цел wxSTC_LISP_IDENTIFIER = 9;
        public const цел wxSTC_LISP_OPERATOR = 10;

        // Lexical states for SCLEX_EIFFEL and SCLEX_EIFFELKW
        public const цел wxSTC_EIFFEL_Дефолт = 0;
        public const цел wxSTC_EIFFEL_COMMENTLINE = 1;
        public const цел wxSTC_EIFFEL_NUMBER = 2;
        public const цел wxSTC_EIFFEL_WORD = 3;
        public const цел wxSTC_EIFFEL_STRING = 4;
        public const цел wxSTC_EIFFEL_CHARACTER = 5;
        public const цел wxSTC_EIFFEL_OPERATOR = 6;
        public const цел wxSTC_EIFFEL_IDENTIFIER = 7;
        public const цел wxSTC_EIFFEL_STRINGEOL = 8;

        // Lexical states for SCLEX_NNCRONTAB (nnCron crontab лексер)
        public const цел wxSTC_NNCRONTAB_Дефолт = 0;
        public const цел wxSTC_NNCRONTAB_COMMENT = 1;
        public const цел wxSTC_NNCRONTAB_TASK = 2;
        public const цел wxSTC_NNCRONTAB_SECTION = 3;
        public const цел wxSTC_NNCRONTAB_KEYWORD = 4;
        public const цел wxSTC_NNCRONTAB_MODIFIER = 5;
        public const цел wxSTC_NNCRONTAB_ASTERISK = 6;
        public const цел wxSTC_NNCRONTAB_NUMBER = 7;
        public const цел wxSTC_NNCRONTAB_STRING = 8;
        public const цел wxSTC_NNCRONTAB_ENVIRONMENT = 9;
        public const цел wxSTC_NNCRONTAB_IDENTIFIER = 10;

        // Lexical states for SCLEX_MATLAB
        public const цел wxSTC_MATLAB_Дефолт = 0;
        public const цел wxSTC_MATLAB_COMMENT = 1;
        public const цел wxSTC_MATLAB_COMMAND = 2;
        public const цел wxSTC_MATLAB_NUMBER = 3;
        public const цел wxSTC_MATLAB_KEYWORD = 4;
        public const цел wxSTC_MATLAB_STRING = 5;
        public const цел wxSTC_MATLAB_OPERATOR = 6;
        public const цел wxSTC_MATLAB_IDENTIFIER = 7;

        // Lexical states for SCLEX_SCRIPTOL
        public const цел wxSTC_SCRIPTOL_Дефолт = 0;
        public const цел wxSTC_SCRIPTOL_COMMENT = 1;
        public const цел wxSTC_SCRIPTOL_COMMENTLINE = 2;
        public const цел wxSTC_SCRIPTOL_COMMENTDOC = 3;
        public const цел wxSTC_SCRIPTOL_NUMBER = 4;
        public const цел wxSTC_SCRIPTOL_WORD = 5;
        public const цел wxSTC_SCRIPTOL_STRING = 6;
        public const цел wxSTC_SCRIPTOL_CHARACTER = 7;
        public const цел wxSTC_SCRIPTOL_UUID = 8;
        public const цел wxSTC_SCRIPTOL_PREPROCESSOR = 9;
        public const цел wxSTC_SCRIPTOL_OPERATOR = 10;
        public const цел wxSTC_SCRIPTOL_IDENTIFIER = 11;
        public const цел wxSTC_SCRIPTOL_STRINGEOL = 12;
        public const цел wxSTC_SCRIPTOL_VERBATIM = 13;
        public const цел wxSTC_SCRIPTOL_REGEX = 14;
        public const цел wxSTC_SCRIPTOL_COMMENTLINEDOC = 15;
        public const цел wxSTC_SCRIPTOL_WORD2 = 16;
        public const цел wxSTC_SCRIPTOL_COMMENTDOCKEYWORD = 17;
        public const цел wxSTC_SCRIPTOL_COMMENTDOCKEYWORDERROR = 18;
        public const цел wxSTC_SCRIPTOL_COMMENTBASIC = 19;

        // Lexical states for SCLEX_ASM
        public const цел wxSTC_ASM_Дефолт = 0;
        public const цел wxSTC_ASM_COMMENT = 1;
        public const цел wxSTC_ASM_NUMBER = 2;
        public const цел wxSTC_ASM_STRING = 3;
        public const цел wxSTC_ASM_OPERATOR = 4;
        public const цел wxSTC_ASM_IDENTIFIER = 5;
        public const цел wxSTC_ASM_CPUINSTRUCTION = 6;
        public const цел wxSTC_ASM_MATHINSTRUCTION = 7;
        public const цел wxSTC_ASM_REGISTER = 8;
        public const цел wxSTC_ASM_DIRECTIVE = 9;
        public const цел wxSTC_ASM_DIRECTIVEOPERAND = 10;

        // Lexical states for SCLEX_FORTRAN
        public const цел wxSTC_F_Дефолт = 0;
        public const цел wxSTC_F_COMMENT = 1;
        public const цел wxSTC_F_NUMBER = 2;
        public const цел wxSTC_F_STRING1 = 3;
        public const цел wxSTC_F_STRING2 = 4;
        public const цел wxSTC_F_STRINGEOL = 5;
        public const цел wxSTC_F_OPERATOR = 6;
        public const цел wxSTC_F_IDENTIFIER = 7;
        public const цел wxSTC_F_WORD = 8;
        public const цел wxSTC_F_WORD2 = 9;
        public const цел wxSTC_F_WORD3 = 10;
        public const цел wxSTC_F_PREPROCESSOR = 11;
        public const цел wxSTC_F_OPERATOR2 = 12;
        public const цел wxSTC_F_LABEL = 13;
        public const цел wxSTC_F_CONTINUATION = 14;

        // Lexical states for SCLEX_CSS
        public const цел wxSTC_CSS_Дефолт = 0;
        public const цел wxSTC_CSS_TAG = 1;
        public const цел wxSTC_CSS_CLASS = 2;
        public const цел wxSTC_CSS_PSEUDOCLASS = 3;
        public const цел wxSTC_CSS_UNKNOWN_PSEUDOCLASS = 4;
        public const цел wxSTC_CSS_OPERATOR = 5;
        public const цел wxSTC_CSS_IDENTIFIER = 6;
        public const цел wxSTC_CSS_UNKNOWN_IDENTIFIER = 7;
        public const цел wxSTC_CSS_VALUE = 8;
        public const цел wxSTC_CSS_COMMENT = 9;
        public const цел wxSTC_CSS_ID = 10;
        public const цел wxSTC_CSS_IMPORTANT = 11;
        public const цел wxSTC_CSS_DIRECTIVE = 12;
        public const цел wxSTC_CSS_DOUBLESTRING = 13;
        public const цел wxSTC_CSS_SINGLESTRING = 14;

        // Lexical states for SCLEX_POV
        public const цел wxSTC_POV_Дефолт = 0;
        public const цел wxSTC_POV_COMMENT = 1;
        public const цел wxSTC_POV_COMMENTLINE = 2;
        public const цел wxSTC_POV_COMMENTDOC = 3;
        public const цел wxSTC_POV_NUMBER = 4;
        public const цел wxSTC_POV_WORD = 5;
        public const цел wxSTC_POV_STRING = 6;
        public const цел wxSTC_POV_OPERATOR = 7;
        public const цел wxSTC_POV_IDENTIFIER = 8;
        public const цел wxSTC_POV_BRACE = 9;
        public const цел wxSTC_POV_WORD2 = 10;


        //-----------------------------------------
        // Commands that can be bound до keystrokes

        // Redoes the next action on the undo history.
        public const цел wxSTC_CMD_REDO = 2011;

        // выдели all the текст in the document.
        public const цел wxSTC_CMD_SELECTALL = 2013;

        // отмениСделанное one action in the undo history.
        public const цел wxSTC_CMD_UNDO = 2176;

        // вырежи the selection до the буфОб.
        public const цел wxSTC_CMD_CUT = 2177;

        // копируй the selection до the буфОб.
        public const цел wxSTC_CMD_COPY = 2178;

        // вставь the contents of the буфОб into the document replacing the selection.
        public const цел wxSTC_CMD_PASTE = 2179;

        // очисть the selection.
        public const цел wxSTC_CMD_CLEAR = 2180;

        // сдвинь каретка down one строка.
        public const цел wxSTC_CMD_LINEDOWN = 2300;

        // сдвинь каретка down one строка extending selection до new каретка позиция.
        public const цел wxSTC_CMD_LINEDOWNEXTEND = 2301;

        // сдвинь каретка up one строка.
        public const цел wxSTC_CMD_LINEUP = 2302;

        // сдвинь каретка up one строка extending selection до new каретка позиция.
        public const цел wxSTC_CMD_LINEUPEXTEND = 2303;

        // сдвинь каретка left one character.
        public const цел wxSTC_CMD_CHARLEFT = 2304;

        // сдвинь каретка left one character extending selection до new каретка позиция.
        public const цел wxSTC_CMD_CHARLEFTEXTEND = 2305;

        // сдвинь каретка right one character.
        public const цел wxSTC_CMD_CHARRIGHT = 2306;

        // сдвинь каретка right one character extending selection до new каретка позиция.
        public const цел wxSTC_CMD_CHARRIGHTEXTEND = 2307;

        // сдвинь каретка left one слово.
        public const цел wxSTC_CMD_WORDLEFT = 2308;

        // сдвинь каретка left one слово extending selection до new каретка позиция.
        public const цел wxSTC_CMD_WORDLEFTEXTEND = 2309;

        // сдвинь каретка right one слово.
        public const цел wxSTC_CMD_WORDRIGHT = 2310;

        // сдвинь каретка right one слово extending selection до new каретка позиция.
        public const цел wxSTC_CMD_WORDRIGHTEXTEND = 2311;

        // сдвинь каретка до first позиция on строка.
        public const цел wxSTC_CMD_HOME = 2312;

        // сдвинь каретка до first позиция on строка extending selection до new каретка позиция.
        public const цел wxSTC_CMD_HOMEEXTEND = 2313;

        // сдвинь каретка до last позиция on строка.
        public const цел wxSTC_CMD_LINEEND = 2314;

        // сдвинь каретка до last позиция on строка extending selection до new каретка позиция.
        public const цел wxSTC_CMD_LINEENDEXTEND = 2315;

        // сдвинь каретка до first позиция in document.
        public const цел wxSTC_CMD_DOCUMENTSTART = 2316;

        // сдвинь каретка до first позиция in document extending selection до new каретка позиция.
        public const цел wxSTC_CMD_DOCUMENTSTARTEXTEND = 2317;

        // сдвинь каретка до last позиция in document.
        public const цел wxSTC_CMD_DOCUMENTEND = 2318;

        // сдвинь каретка до last позиция in document extending selection до new каретка позиция.
        public const цел wxSTC_CMD_DOCUMENTENDEXTEND = 2319;

        // сдвинь каретка one страница up.
        public const цел wxSTC_CMD_PAGEUP = 2320;

        // сдвинь каретка one страница up extending selection до new каретка позиция.
        public const цел wxSTC_CMD_PAGEUPEXTEND = 2321;

        // сдвинь каретка one страница down.
        public const цел wxSTC_CMD_PAGEDOWN = 2322;

        // сдвинь каретка one страница down extending selection до new каретка позиция.
        public const цел wxSTC_CMD_PAGEDOWNEXTEND = 2323;

        // Switch от insert до overtype режим or the reverse.
        public const цел wxSTC_CMD_EDITTOGGLEOVERTYPE = 2324;

        // Cancel any режимы such as call подсказка or auto-completion list display.
        public const цел wxSTC_CMD_CANCEL = 2325;

        // удали the selection or if no selection, the character перед the каретка.
        public const цел wxSTC_CMD_DELETEBACK = 2326;

        // If selection is empty or all on one строка replace the selection with a tab character.
        // If more than one строка selected, indent the строки.
        public const цел wxSTC_CMD_TAB = 2327;

        // Dedent the selected строки.
        public const цел wxSTC_CMD_BACKTAB = 2328;

        // вставь a new строка, may use a CRLF, CR or LF depending on EOL режим.
        public const цел wxSTC_CMD_NEWLINE = 2329;

        // вставь a Form Feed character.
        public const цел wxSTC_CMD_FORMFEED = 2330;

        // сдвинь каретка до перед first видим character on строка.
        // If already there move до first character on строка.
        public const цел wxSTC_CMD_VCHOME = 2331;

        // Like VCHome кноп extending selection до new каретка позиция.
        public const цел wxSTC_CMD_VCHOMEEXTEND = 2332;

        // Magnify the displayed текст by increasing the размы by 1 Точка.
        public const цел wxSTC_CMD_ZOOMIN = 2333;

        // Make the displayed текст smaller by decreasing the размы by 1 Точка.
        public const цел wxSTC_CMD_ZOOMOUT = 2334;

        // удали the слово до the left of the каретка.
        public const цел wxSTC_CMD_DELWORDLEFT = 2335;

        // удали the слово до the right of the каретка.
        public const цел wxSTC_CMD_DELWORDRIGHT = 2336;

        // вырежи the строка containing the каретка.
        public const цел wxSTC_CMD_LINECUT = 2337;

        // удали the строка containing the каретка.
        public const цел wxSTC_CMD_LINEDELETE = 2338;

        // Switch the current строка with the предш.
        public const цел wxSTC_CMD_LINETRANSPOSE = 2339;

        // Duplicate the current строка.
        public const цел wxSTC_CMD_LINEDUPLICATE = 2404;

        // Transform the selection до lower case.
        public const цел wxSTC_CMD_LOWERCASE = 2340;

        // Transform the selection до upper case.
        public const цел wxSTC_CMD_UPPERCASE = 2341;

        // Scroll the document down, keeping the каретка видим.
        public const цел wxSTC_CMD_LINESCROLLDOWN = 2342;

        // Scroll the document up, keeping the каретка видим.
        public const цел wxSTC_CMD_LINESCROLLUP = 2343;

        // удали the selection or if no selection, the character перед the каретка.
        // Will not delete the character перед at the старт of a строка.
        public const цел wxSTC_CMD_DELETEBACKNOTLINE = 2344;

        // сдвинь каретка до first позиция on display строка.
        public const цел wxSTC_CMD_HOMEDISPLAY = 2345;

        // сдвинь каретка до first позиция on display строка extending selection до
        // new каретка позиция.
        public const цел wxSTC_CMD_HOMEDISPLAYEXTEND = 2346;

        // сдвинь каретка до last позиция on display строка.
        public const цел wxSTC_CMD_LINEENDDISPLAY = 2347;

        // сдвинь каретка до last позиция on display строка extending selection до new
        // каретка позиция.
        public const цел wxSTC_CMD_LINEENDDISPLAYEXTEND = 2348;

        // These are like their namesakes Home(Extend)?, LineEnd(Extend)?, VCHome(Extend)?
        // except they behave differently when слово-wrap is enabled:
        // They go first до the старт / конец of the display строка, like (Home|LineEnd)дисплей
        // The difference is that, the курсор is already at the Точка, it goes on до the старт
        // or конец of the document строка, as appropriate for (Home|LineEnd|VCHome)Extend.
        public const цел wxSTC_CMD_HOMEWRAP = 2349;
        public const цел wxSTC_CMD_HOMEWRAPEXTEND = 2450;
        public const цел wxSTC_CMD_LINEENDWRAP = 2451;
        public const цел wxSTC_CMD_LINEENDWRAPEXTEND = 2452;
        public const цел wxSTC_CMD_VCHOMEWRAP = 2453;
        public const цел wxSTC_CMD_VCHOMEWRAPEXTEND = 2454;

        // сдвинь до the предш change in capitalisation.
        public const цел wxSTC_CMD_WORDPARTLEFT = 2390;

        // сдвинь до the предш change in capitalisation extending selection
        // до new каретка позиция.
        public const цел wxSTC_CMD_WORDPARTLEFTEXTEND = 2391;

        // сдвинь до the change next in capitalisation.
        public const цел wxSTC_CMD_WORDPARTRIGHT = 2392;

        // сдвинь до the next change in capitalisation extending selection
        // до new каретка позиция.
        public const цел wxSTC_CMD_WORDPARTRIGHTEXTEND = 2393;

        // удали зад от the current позиция до the старт of the строка.
        public const цел wxSTC_CMD_DELLINELEFT = 2395;

        // удали forwards от the current позиция до the конец of the строка.
        public const цел wxSTC_CMD_DELLINERIGHT = 2396;

        // сдвинь каретка between paragraphs (delimited by empty строки)
        public const цел wxSTC_CMD_PARADOWN = 2413;
        public const цел wxSTC_CMD_PARADOWNEXTEND = 2414;
        public const цел wxSTC_CMD_PARAUP = 2415;
        public const цел wxSTC_CMD_PARAUPEXTEND = 2416;

        //-----------------------------------------------------------------------------
        //static this();
        //-----------------------------------------------------------------------------
        public const ткст стрИмениСТК = "stcwindow";

        public this(ЦелУкз вхобъ);
        public  this(Окно родитель, цел ид /*= ЛЮБОЙ*/, Точка поз = ДЕФПОЗ, Размер размер = ДЕФРАЗМ, цел стиль =0, ткст имя = стрИмениСТК);
        //public static ВизОбъект Нов(ЦелУкз вхобъ);
        public  this(Окно родитель, Точка поз = ДЕФПОЗ, Размер размер = ДЕФРАЗМ, цел стиль =0, ткст имя = стрИмениСТК);
        public проц добавьТекст(ткст текст);
        public проц вставьТекст(цел поз, ткст текст);
        public проц очистьВсё();
        public проц очистьСтильДокумента();
        public цел длина();
        public цел дайСимВПоз(цел поз);
        public цел текущПоз();
        public проц текущПоз(цел значение);
        public цел якорь();
        public проц якорь(цел значение);
        public цел дайСтильВПоз(цел поз);
        public проц верниСделанное();
        public бул UndoCollection();
        public проц UndoCollection(бул значение);
        public проц выделиВсе();
        public проц устТочкуСохр();
        public бул можноВернутьСделанное();
        public цел MarkerLineFromHandle(цел handle);
        public проц MarkerDeleteHandle(цел handle);
        public цел ViewWhiteSpace();
        public проц ViewWhiteSpace(цел значение);
        public цел позИзТочки(Точка тчк);
        public цел PositionFromPointClose(цел x, цел y);
        public проц идиКСтроке(цел строка);
        public проц идиВПоз(цел поз);
        public ткст текущСтрока();
        public ткст дайТекущСтроку(out цел позВСтроке);
        public цел EndStyled();
        public проц ConvertEOLs(цел eolMode);
        public цел EOLMode();
        public проц EOLMode(цел значение);
        public проц начниСтилизацию(цел поз, цел маска);
        public проц устСтилизацию(цел length, цел стиль);
        public бул буфРис();
        public проц буфРис(бул значение);
        public цел ширинаТаб();
        public проц ширинаТаб(цел значение);
        public цел кодПейдж();
        public проц кодПейдж(цел значение);
        public проц определиМаркер(цел номерМаркера, цел символМаркера, Цвет переднийПлан, Цвет заднийПлан);
        public проц устППМаркера(цел номерМаркера, Цвет перед);
        public проц устЗПМаркера(цел номерМаркера, Цвет зад);
        public цел добавьМаркер(цел строка, цел номерМаркера);
        public проц удалиМаркер(цел строка, цел номерМаркера);
        public проц удалиВсеМаркеры(цел номерМаркера);
        public цел дайМаркер(цел строка);
        public цел следщМаркер(цел началоСтроки, цел маскаМаркера);
        public цел предшМаркер(цел началоСтроки, цел маскаМаркера);
        public проц MarkerDefineBitmap(цел номерМаркера, Битмап бмп);
        public проц SetMarginType(цел маржин, цел marginType);
        public цел GetMarginType(цел маржин);
        public проц SetMarginWidth(цел маржин, цел pixelWidth);
        public цел GetMarginWidth(цел маржин);
        public проц SetMarginMask(цел маржин, цел маска);
        public цел GetMarginMask(цел маржин);
        public проц SetMarginSensitive(цел маржин, бул sensitive);
        public бул GetMarginSensitive(цел маржин);
        public проц StyleClearAll();
        public проц StyleSetForeground(цел стиль, Цвет перед);
        public проц StyleSetBackground(цел стиль, Цвет зад);
        public проц StyleSetBold(цел стиль, бул полужирный);
        public проц StyleSetItalic(цел стиль, бул italic);
        public проц StyleSetSize(цел стиль, цел sizePoints);
        public проц StyleSetFaceName(цел стиль, ткст fontName);
        public проц StyleSetEOLFilled(цел стиль, бул filled);
        public проц StyleResetDefault();
        public проц StyleSetUnderline(цел стиль, бул подчеркни);
        public проц StyleSetCase(цел стиль, цел caseForce);
        public проц StyleSetCharacterSet(цел стиль, цел characterSet);
        public проц StyleSetHotSpot(цел стиль, бул hotspot);
        public проц StyleSetVisible(цел стиль, бул видим);
        public проц StyleSetChangeable(цел стиль, бул changeable);
        public проц SetSelForeground(бул useSetting, Цвет перед);
        public проц SetSelBackground(бул useSetting, Цвет зад);
        public Цвет CaretForeground();
        public проц CaretForeground(Цвет значение);
        public проц CmdKeyAssign(цел ключ, цел modifiers, цел кмд);
        public проц CmdKeyClear(цел ключ, цел modifiers);
        public проц CmdKeyClearAll();
        public проц SetStyleBytes(ббайт[] styleBytes);
        public цел периодКаретки();
        public проц периодКаретки(цел значение);
        public проц SetWordChars(ткст characters);
        public проц BeginUndoAction();
        public проц EndUndoAction();
        public проц IndicatorSetStyle(цел indic, цел стиль);
        public цел IndicatorGetStyle(цел indic);
        public проц IndicatorSetForeground(цел indic, Цвет перед);
        public Цвет IndicatorGetForeground(цел indic);
        public проц SetWhitespaceForeground(бул useSetting, Цвет перед);
        public проц SetWhitespaceBackground(бул useSetting, Цвет зад);
        public цел битыСтиля();
        public проц битыСтиля(цел значение);
        public проц SetLineState(цел строка, цел состояние);
        public цел GetLineState(цел строка);
        public цел MaxLineState();
        public бул CaretLineVisible();
        public проц CaretLineVisible(бул значение);
        public Цвет CaretLineBack();
        public проц CaretLineBack(Цвет значение);
        public проц AutoCompShow(цел lenEntered, ткст списЭлтов);
        public проц AutoCompCancel();
        public бул AutoCompActive();
        public цел AutoCompPosStart();
        public проц AutoCompComplete();
        public проц AutoCompStops(ткст значение);
        public char AutoCompSeparator();
        public проц AutoCompSeparator(char значение);
        public проц AutoCompSelect(ткст текст);
        public бул AutoCompCancelAtStart();
        public проц AutoCompCancelAtStart(бул значение);
        public проц AutoCompFillUps(ткст значение);
        public бул AutoCompChooseSingle();
        public проц AutoCompChooseSingle(бул значение);
        public бул AutoCompIgnoreCase();
        public проц AutoCompIgnoreCase(бул значение);
        public проц AutoCompAutoHide(бул значение);
        public бул AutoCompAutoHide();
        public проц AutoCompDropRestOfWord(бул значение);
        public бул AutoCompDropRestOfWord();
        public цел AutoCompTypeSeparator();
        public проц AutoCompTypeSeparator(цел значение);
        public проц UserListShow(цел типСписка, ткст списЭлтов);
        public проц регистрируйРисунок(цел тип, Битмап бмп);
        public проц удалиЗарегРисунки();
        public цел отступ();
        public проц отступ(цел значение);
        public бул использоватьТабы();
        public проц использоватьТабы(бул значение);
        public проц устОтступСтроки(цел строка, цел размОтступа);
        public цел дайОтступСтроки(цел строка);
        public цел дайПозОтступаСтр(цел строка);
        public цел дайКолонку(цел поз);
        public проц использоватьГоризПолосуПрокрутки(бул значение);
        public бул использоватьГоризПолосуПрокрутки();
        public проц IndentationGuides(бул значение);
        public бул IndentationGuides();
        public цел HighlightGuide();
        public проц HighlightGuide(цел значение);
        public цел дайПозКонцаСтр(цел строка);
        public бул толькоЧтение();
        public проц толькоЧтение(бул значение);
        public цел начниВыделение();
        public проц начниВыделение(цел значение);
        public цел завершиВыделение();
        public проц завершиВыделение(цел значение);
        public цел увеличьПечать();
        public проц увеличьПечать(цел значение);
        public цел режимЦветнойПечати();
        public проц режимЦветнойПечати(цел значение);
        public цел найдиТекст(цел минПоз, цел максПоз, ткст текст, цел флаги);
        public цел форматируйДиапазон(бул doDraw, цел стартПоз, цел конПоз, КонтекстSetройства draw, КонтекстSetройства цель, Прямоугольник renderRect, Прямоугольник pageRect);
        public цел первВидимаяСтрока();
        public ткст дайСтроку(цел строка);
        public цел члоСтрок();
        public цел левоМаржина();
        public проц левоМаржина(цел значение);
        public цел правоМаржина();
        public проц правоМаржина(цел значение);
        public бул модифицируй();
        public проц устВыделение(цел старт, цел конец);
        public ткст выделенныйТекст();
        public ткст дайДиапазонТекста(цел стартПоз, цел конПоз);
        public проц спрячьВыделение(бул значение);
        public цел строкаИзПозиции(цел поз);
        public цел позицияИзСтроки(цел строка);
        public проц прокруткаСтроки(цел колонки, цел строки);
        public проц кареткаВиднаОбязательно();
        public проц замениВыделение(ткст текст);
        public бул можноВставлять();
        public бул можноОтменитьСделанное();
        public проц опорожниБуферАнду();
        public проц отмениСделанное();
        public проц вырежи();
        public проц копируй();
        public проц вставь();
        public проц очисть();
        public проц текст(ткст значение);
        public ткст текст();
        public цел длинаТекста();
        public бул Overtype();
        public проц Overtype(бул значение);
        public цел ширинаКаретки();
        public проц ширинаКаретки(цел значение);
        public цел стартЦели();
        public проц стартЦели(цел значение);
        public цел конецЦели();
        public проц конецЦели(цел значение);
        public цел замениЦель(ткст текст);
        public цел замениРВЦели(ткст текст);
        public цел поискВЦели(ткст текст);
        public цел устФлагиПоиска();
        public проц устФлагиПоиска(цел значение);
        public проц CallTipShow(цел поз, ткст definition);
        public проц CallTipCancel();
        public бул CallTipActive();
        public цел CallTipPosAtStart();
        public проц CallTipSetHighlight(цел старт, цел конец);
        public проц CallTipBackground(Цвет значение);
        public проц CallTipForeground(Цвет значение);
        public проц CallTipForegroundHighlight(Цвет значение);
        public цел VisibleFromDocLine(цел строка);
        public цел DocLineFromVisible(цел lineDisplay);
        public проц SetFoldLevel(цел строка, цел level);
        public цел GetFoldLevel(цел строка);
        public цел дайПоследнОтпрыск(цел строка, цел level);
        public цел GetFoldParent(цел строка);
        public проц ShowLines(цел началоСтроки, цел lineEnd);
        public проц HideLines(цел началоСтроки, цел lineEnd);
        public бул GetLineVisible(цел строка);
        public проц SetFoldExpanded(цел строка, бул expanded);
        public бул GetFoldExpanded(цел строка);
        public проц ToggleFold(цел строка);
        public проц убедисьЧтоВиден(цел строка);
        public проц FoldФлаги(цел значение);
        public проц EnsureVisibleEnforcePolicy(цел строка);
        public бул табОтступы();
        public проц табОтступы(бул значение);
        public бул BackSpaceUnIndents();
        public проц BackSpaceUnIndents(бул значение);
        public проц MouseDwellTime(цел значение);
        public цел MouseDwellTime();
        public цел WordStartPosition(цел поз, бул onlyWordCharacters);
        public цел WordEndPosition(цел поз, бул onlyWordCharacters);
        public цел WrapMode();
        public проц WrapMode(цел значение);
        public проц LayoutCache(цел значение);
        public цел LayoutCache();
        public цел ScrollWidth();
        public проц ScrollWidth(цел значение);
        public цел TextWidth(цел стиль, ткст текст);
        public бул EndAtLastLine();
        public проц EndAtLastLine(бул значение);
        public цел TextHeight(цел строка);
        public бул UseVerticalScrollBar();
        public проц UseVerticalScrollBar(бул значение);
        public проц приставьТекст(цел length, ткст текст);
        public бул TwoPhaseDraw();
        public проц TwoPhaseDraw(бул значение);
        public проц TargetFromSelection();
        public проц LinesJoin();
        public проц LinesSplit(цел pixelWidth);
        public проц SetFoldMarginColour(бул useSetting, Цвет зад);
        public проц SetFoldMarginHiColour(бул useSetting, Цвет перед);
        public проц LineDuplicate();
        public проц HomeDisplay();
        public проц HomeDisplayExtend();
        public проц LineEndDisplay();
        public проц LineEndDisplayExtend();
        public проц MoveCaretInsideView();
        public цел длинаСтроки(цел строка);
        public проц BraceHighlight(цел pos1, цел pos2);
        public проц BraceBadLight(цел поз);
        public цел BraceMatch(цел поз);
        public бул ViewEOL();
        public проц ViewEOL(бул значение);
        public ВизОбъект DocPointer();
        public проц DocPointer(ВизОбъект значение);
        public цел ModEventMask();
        public проц ModEventMask(цел значение);
        public цел EdgeColumn();
        public проц EdgeColumn(цел значение);
        public цел EdgeMode();
        public проц EdgeMode(цел значение);
        public Цвет EdgeColour();
        public проц EdgeColour(Цвет значение);
        public проц SearchAnchor();
        public цел SearchNext(цел флаги, ткст текст);
        public цел SearchPrev(цел флаги, ткст текст);
        public цел LinesOnScreen();
        public проц UsePopUp(бул значение);
        public бул SelectionIsRectangle();
        public цел Zoom();
        public проц Zoom(цел значение);
        public проц CreateDocument();
        public проц AddRefDocument(ВизОбъект docPointer);
        public проц ReleaseDocument(ВизОбъект docPointer);
        public бул STCFocus();
        public проц STCFocus(бул значение);
        public цел Status();
        public проц Status(цел значение);
        public бул MouseDownCaptures();
        public проц MouseDownCaptures(бул значение);
        public проц STCCursor(цел значение);
        public цел STCCursor();
        public проц ControlCharSymbol(цел значение);
        public цел ControlCharSymbol();
        public проц WordPartLeft();
        public проц WordPartLeftExtend();
        public проц WordPartRight();
        public проц WordPartRightExtend();
        public проц SetVisiblePolicy(цел visiblePolicy, цел visibleSlop);
        public проц DelLineLeft();
        public проц DelLineRight();
        public проц XOffset(цел значение);
        public цел XOffset();
        public проц ChooseCaretX();
        public проц SetXCaretPolicy(цел caretPolicy, цел caretSlop);
        public проц SetYCaretPolicy(цел caretPolicy, цел caretSlop);
        public проц PrintWrapMode(цел значение);
        public цел PrintWrapMode();
        public проц SetHotspotActiveForeground(бул useSetting, Цвет перед);
        public проц SetHotspotActiveBackground(бул useSetting, Цвет зад);
        public проц SetHotspotActiveUnderline(бул подчеркни);
        public проц StartRecord();
        public проц StopRecord();
        public проц лексер(цел значение);
        public цел лексер();
        public проц окрась(цел старт, цел конец);
        public проц SetProperty(ткст ключ, ткст значение);
        public проц SetKeyWords(цел keywordSet, ткст keyWords);
        public проц лексерLanguage(ткст значение);
        public цел номТекСтроки();
        public проц StyleSetSpec(цел styleNum, ткст spec);
        public проц StyleSetFont(цел styleNum, Шрифт шрифт);
        public проц StyleSetFontAttr(цел styleNum, цел размер, ткст имяФас, бул полужирный, бул italic, бул подчеркни);
        public проц CmdKeyExecute(цел кмд);
        public проц SetMargins(цел left, цел right);
        public проц дайВыделение(out цел стартПоз, out цел конПоз);
        public Точка PointFromPosition(цел поз);
        public проц ScrollToLine(цел строка);
        public проц ScrollToColumn(цел колонка);
        public бул LastKeydownProcessed();
        public проц LastKeydownProcessed(бул значение);
        public бул сохраниФайл(ткст имяф);
        public бул загрузиФайл(ткст имяф);
        public проц Change_Add(ДатчикСобытий значение);
        public проц Change_Remove(ДатчикСобытий значение);
        public проц StyleNeeded_Add(ДатчикСобытий значение);
        public проц StyleNeeded_Remove(ДатчикСобытий значение);
        public проц CharAdded_Add(ДатчикСобытий значение);
        public проц CharAdded_Remove(ДатчикСобытий значение);
        public проц SavePointReached_Add(ДатчикСобытий значение);
        public проц SavePointReached_Remove(ДатчикСобытий значение);
        public проц SavePointLeft_Add(ДатчикСобытий значение);
        public проц SavePointLeft_Remove(ДатчикСобытий значение);
        public проц ROModifyAttempt_Add(ДатчикСобытий значение);
        public проц ROModifyAttempt_Remove(ДатчикСобытий значение);
        public проц Key_Add(ДатчикСобытий значение);
        public проц Key_Remove(ДатчикСобытий значение);
        public проц добавьДНажатие(ДатчикСобытий значение);
        public проц удалиДНажатие(ДатчикСобытий значение);
        public проц UpdateUI_Add(ДатчикСобытий значение);
        public проц UpdateUI_Remove(ДатчикСобытий значение);
        public проц Modified_Add(ДатчикСобытий значение);
        public проц Modified_Remove(ДатчикСобытий значение);
        public проц MacroRecord_Add(ДатчикСобытий значение);
        public проц MacroRecord_Remove(ДатчикСобытий значение);
        public проц MarginClick_Add(ДатчикСобытий значение);
        public проц MarginClick_Remove(ДатчикСобытий значение);
        public проц NeedShown_Add(ДатчикСобытий значение);
        public проц NeedShown_Remove(ДатчикСобытий значение);
        public проц Paint_Add(ДатчикСобытий значение);
        public проц Paint_Remove(ДатчикСобытий значение);
        public проц UserListSelection_Add(ДатчикСобытий значение);
        public проц UserListSelection_Remove(ДатчикСобытий значение);
        public проц URIDropped_Add(ДатчикСобытий значение);
        public проц URIDropped_Remove(ДатчикСобытий значение);
        public проц DwellStart_Add(ДатчикСобытий значение);
        public проц DwellStart_Remove(ДатчикСобытий значение);
        public проц DwellEnd_Add(ДатчикСобытий значение);
        public проц DwellEnd_Remove(ДатчикСобытий значение);
        public проц StartDrag_Add(ДатчикСобытий значение);
        public проц StartDrag_Remove(ДатчикСобытий значение);
        public проц DragOver_Add(ДатчикСобытий значение);
        public проц DragOver_Remove(ДатчикСобытий значение);
        public проц DoDrop_Add(ДатчикСобытий значение);
        public проц DoDrop_Remove(ДатчикСобытий значение);
        public проц Zoomed_Add(ДатчикСобытий значение);
        public проц Zoomed_Remove(ДатчикСобытий значение);
        public проц HotspotClick_Add(ДатчикСобытий значение);
        public проц HotspotClick_Remove(ДатчикСобытий значение);
        public проц HotspotDoubleClick_Add(ДатчикСобытий значение);
        public проц HotspotDoubleClick_Remove(ДатчикСобытий значение);
        public проц CalltipClick_Add(ДатчикСобытий значение);
        public проц CalltipClick_Remove(ДатчикСобытий значение);
    }

    //-----------------------------------------------------------------------------

    extern(D) class СобытиеСтильногоТекста : СобытиеКоманды
    {
        public this(ЦелУкз вхобъ);
        public  this(цел типКоманды, цел ид);
        public цел позиция();
        public проц позиция(цел значение);
        public цел клавиша();
        public проц клавиша(цел значение);
        public проц модификаторы(цел значение);
        public цел модификаторы();
        public проц типМодификации(цел значение);
        public цел типМодификации();
        public проц текст(ткст значение);
        public ткст текст();
        public проц длина(цел значение);
        public цел длина();
        public проц строкДобавлено(цел значение);
        public цел строкДобавлено();
        public проц строка(цел значение);
        public цел строка();
        public проц FoldLevelNow(цел значение);
        public цел FoldLevelNow();
        public проц FoldLevelPrev(цел значение);
        public цел FoldLevelPrev();
        public проц маржин(цел значение);
        public цел маржин();
        public проц сообщение(цел значение);
        public цел сообщение();
        public проц парамВ(цел значение);
        public цел парамВ();
        public проц парамЛ(цел значение);
        public цел парамЛ();
        public проц типСписка(цел значение);
        public цел типСписка();
        public проц Х(цел значение);
        public цел Х();
        public проц У(цел значение);
        public цел У();
        public проц тяниТекст(ткст значение);
        public ткст тяниТекст();
        public проц DragAllowMove(бул значение);
        public бул DragAllowMove();
        public бул шифт();
        public бул контрол();
        public бул альт();
        //private static Событие Нов(ЦелУкз объ);
    }

//! \cond VERSION
} // version(WXD_STYLEDTEXTCTRL)
//! \endcond
