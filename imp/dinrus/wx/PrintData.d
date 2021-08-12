module wx.PrintData;
public import wx.common;

public enum ПРежимПечати
{
    Нет =    0,
    Предпросмотр = 1,   // Preview in external application
    Файл =    2,   // Print до файл
    Принтер = 3    // Send до printer
}

public enum ПКачествоПечати
{
    Высокое    = -1,
    Среднее  = -2,
    Низкое     = -3,
    Черновое   = -4
}

public enum ПРежимДуплекс
{
    Симплекс,
    Горизонтальный,
    Вертикальный
}

public enum ПРазмерБумаги
{
    Нет,               // Use specific dimensions
    LETTER,             // Letter, 8 1/2 by 11 inches
    LEGAL,              // Legal, 8 1/2 by 14 inches
    A4,                 // A4 Sheet, 210 by 297 millimeters
    CSHEET,             // C Sheet, 17 by 22 inches
    DSHEET,             // D Sheet, 22 by 34 inches
    ESHEET,             // E Sheet, 34 by 44 inches
    LETTERSMALL,        // Letter Small, 8 1/2 by 11 inches
    TABLOID,            // Tabloid, 11 by 17 inches
    LEDGER,             // Ledger, 17 by 11 inches
    STATEMENT,          // Statement, 5 1/2 by 8 1/2 inches
    EXECUTIVE,          // Executive, 7 1/4 by 10 1/2 inches
    A3,                 // A3 sheet, 297 by 420 millimeters
    A4SMALL,            // A4 small sheet, 210 by 297 millimeters
    A5,                 // A5 sheet, 148 by 210 millimeters
    B4,                 // B4 sheet, 250 by 354 millimeters
    B5,                 // B5 sheet, 182-by-257-millimeter paper
    FOLIO,              // Folio, 8-1/2-by-13-inch paper
    QUARTO,             // Quarto, 215-by-275-millimeter paper
    Дюйм10х14,              // 10-by-14-inch sheet
    Дюйм11х17,              // 11-by-17-inch sheet
    NOTE,               // Note, 8 1/2 by 11 inches
    ENV_9,              // #9 Envelope, 3 7/8 by 8 7/8 inches
    ENV_10,             // #10 Envelope, 4 1/8 by 9 1/2 inches
    ENV_11,             // #11 Envelope, 4 1/2 by 10 3/8 inches
    ENV_12,             // #12 Envelope, 4 3/4 by 11 inches
    ENV_14,             // #14 Envelope, 5 by 11 1/2 inches
    ENV_DL,             // DL Envelope, 110 by 220 millimeters
    ENV_C5,             // C5 Envelope, 162 by 229 millimeters
    ENV_C3,             // C3 Envelope, 324 by 458 millimeters
    ENV_C4,             // C4 Envelope, 229 by 324 millimeters
    ENV_C6,             // C6 Envelope, 114 by 162 millimeters
    ENV_C65,            // C65 Envelope, 114 by 229 millimeters
    ENV_B4,             // B4 Envelope, 250 by 353 millimeters
    ENV_B5,             // B5 Envelope, 176 by 250 millimeters
    ENV_B6,             // B6 Envelope, 176 by 125 millimeters
    ENV_ITALY,          // Italy Envelope, 110 by 230 millimeters
    ENV_MONARCH,        // Monarch Envelope, 3 7/8 by 7 1/2 inches
    ENV_PERSONAL,       // 6 3/4 Envelope, 3 5/8 by 6 1/2 inches
    FANFOLD_US,         // US Std Fanfold, 14 7/8 by 11 inches
    FANFOLD_STD_GERMAN, // German Std Fanfold, 8 1/2 by 12 inches
    FANFOLD_LGL_GERMAN, // German Legal Fanfold, 8 1/2 by 13 inches

    ISO_B4,             // B4 (ISO) 250 x 353 mm
    JAPANESE_POSTCARD,  // Japanese Postcard 100 x 148 mm
    Дюйм9х11,               // 9 x 11 in
    Дюйм10х11,              // 10 x 11 in
    Дюйм15х11,              // 15 x 11 in
    ENV_INVITE,         // Envelope Invite 220 x 220 mm
    LETTER_EXTRA,       // Letter Extra 9 \275 x 12 in
    LEGAL_EXTRA,        // Legal Extra 9 \275 x 15 in
    TABLOID_EXTRA,      // Tabloid Extra 11.69 x 18 in
    A4_EXTRA,           // A4 Extra 9.27 x 12.69 in
    LETTER_TRANSVERSE,  // Letter Transverse 8 \275 x 11 in
    A4_TRANSVERSE,      // A4 Transverse 210 x 297 mm
    LETTER_EXTRA_TRANSVERSE, // Letter Extra Transverse 9\275 x 12 in
    A_PLUS,             // SuperA/SuperA/A4 227 x 356 mm
    B_PLUS,             // SuperB/SuperB/A3 305 x 487 mm
    LETTER_PLUS,        // Letter Plus 8.5 x 12.69 in
    A4_PLUS,            // A4 Plus 210 x 330 mm
    A5_TRANSVERSE,      // A5 Transverse 148 x 210 mm
    B5_TRANSVERSE,      // B5 (JIS) Transverse 182 x 257 mm
    A3_EXTRA,           // A3 Extra 322 x 445 mm
    A5_EXTRA,           // A5 Extra 174 x 235 mm
    B5_EXTRA,           // B5 (ISO) Extra 201 x 276 mm
    A2,                 // A2 420 x 594 mm
    A3_TRANSVERSE,      // A3 Transverse 297 x 420 mm
    A3_EXTRA_TRANSVERSE // A3 Extra Transverse 322 x 445 mm
}

//-----------------------------------------------------------------------------

extern(D) class ДанныеДиалогаНастройкиСтраницы : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    public this();
    public  this(ДанныеДиалогаНастройкиСтраницы данныеДиалога);
    public  this(ДанныеПечати данныеПечати);
    //public static ВизОбъект Нов(ЦелУкз укз);
    public Размер размерБумаги();
    public проц размерБумаги(Размер значение);
    public ПРазмерБумаги идБумаги();
    public проц идБумаги(ПРазмерБумаги значение);
    public Точка минМаржинВерхЛево();
    public проц минМаржинВерхЛево(Точка значение);
    public Точка минМаржинНизПраво();
    public проц минМаржинНизПраво(Точка значение);
    public Точка маржинВерхЛево();
    public проц маржинВерхЛево(Точка значение);
    public Точка маржинНизПраво();
    public проц маржинНизПраво(Точка значение);
    public бул дефМинМаржины();
    public проц дефМинМаржины(бул значение);
    public бул вклОриентацию();
    public проц вклОриентацию(бул значение);
    public бул вклБумагу();
    public проц вклБумагу(бул значение);
    public бул вклПринтер();
    public проц вклПринтер(бул значение);
    public бул дефИнфо();
    public проц дефИнфо(бул значение);
    public бул вклСправку();
    public проц вклСправку(бул значение);
    public бул Ок();
    public бул вклМаржины();
    public проц вклМаржины(бул значение);
    public проц вычислиидИзРазмераБумаги();
    public проц вычислиРазмерБумагиИзид();
    public ДанныеПечати данныеПечати();
    public проц данныеПечати(ДанныеПечати значение);
}
//----------------------------------------------------

extern(D) class ДанныеДиалогаПечати : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    public this();
    public this(ДанныеДиалогаПечати данныеДиалога);
    public this(ДанныеПечати данныеПечати);
    //public static ВизОбъект Нов(ЦелУкз укз);
    public цел соСтраницы();
    public проц соСтраницы(цел значение);
    public цел вСтраницу();
    public проц вСтраницу(цел значение);
    public цел минСтраница();
    public проц минСтраница(цел значение);
    public цел максСтраница();
    public проц максСтраница(цел значение);
    public цел безКопий();
    public проц безКопий(цел значение);
    public бул всеСтраницы();
    public проц всеСтраницы(бул значение);
    public бул выделение();
    public проц выделение(бул значение);
    public бул коллируй();
    public проц коллируй(бул значение);
    public бул печатьВФайл();
    public проц печатьВФайл(бул значение);
    public бул диалогНастройки();
    public проц диалогНастройки(бул значение);
    public проц вклПечатьВФайл(бул значение);
    public бул вклПечатьВФайл();
    public проц вклВыделение(бул значение);
    public бул вклВыделение();
    public проц вклНомераСтраниц(бул значение);
    public бул вклНомераСтраниц();
    public проц вклСправку(бул значение);
    public бул вклСправку();
    public бул Ок();
    public ДанныеПечати данныеПечати();
    public проц данныеПечати(ДанныеПечати значение);
}
//-----------------------------------------------------------------------------

extern(D) class ДанныеПечати : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    public this();
    public this(ДанныеПечати данныеПечати);
    //public static ВизОбъект Нов(ЦелУкз укз);
    public цел безКопий();
    public проц безКопий(цел значение);
    public бул коллируй();
    public проц коллируй(бул значение);
    public цел ориентация();
    public проц ориентация(цел значение);
    public бул Ок();
    public ткст имяПринтера();
    public проц имяПринтера(ткст значение);
    public бул цвет();
    public проц цвет(бул значение);
    public ПРежимДуплекс дуплекс();
    public проц дуплекс(ПРежимДуплекс значение);
    public ПРазмерБумаги идБумаги();
    public проц идБумаги(ПРазмерБумаги значение);
    public Размер размерБумаги();
    public проц размерБумаги(Размер значение);
    public ПКачествоПечати качество();
    public проц качество(ПКачествоПечати значение);
    public ткст командаПринтера();
    public проц командаПринтера(ткст значение);
    public ткст опцииПринтера();
    public проц опцииПринтера(ткст значение);
    public ткст командаПредпросмотра();
    public проц командаПредпросмотра(ткст значение);
    public ткст имяФайла();
    public проц имяФайла(ткст значение);
    public ткст путьМетрикиШрифта();
    public проц путьМетрикиШрифта(ткст значение);
    public дво масштабХПринтера();
    public проц масштабХПринтера(дво значение);
    public дво масштабУПринтера();
    public проц масштабУПринтера(дво значение);
    public цел транслХПринтера();
    public проц транслХПринтера(цел значение);
    public цел транслУПринтера();
    public проц транслУПринтера(цел значение);
    public ПРежимПечати режимПечати();
    public проц режимПечати(ПРежимПечати значение);
    public проц устМасштабированиеПринтера(дво x, дво y);
    public проц устТрансляциюПринтера(цел x, цел y);
}

