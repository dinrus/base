module  wx.aui.FrameManager;

public import wx.wx;
public import wx.MiniFrame;
public import wx.Image;
public import wx.Event;
public import wx.EvtHandler;

public import wx.aui.DockArt;

enum ПДокМенеджераРамки
{
    Нет = 0,
    Верхний = 1,
    Правый = 2,
    Нижний = 3,
    Левый = 4,
    Центральный = 5,
};

enum ПОпцияМенеджераРамки
{
    wxAUI_MGR_ALLOW_FLOATING        = 1 << 0,
    wxAUI_MGR_ALLOW_ACTIVE_PANE     = 1 << 1,
    wxAUI_MGR_TRANSPARENT_DRAG      = 1 << 2,
    wxAUI_MGR_TRANSPARENT_HINT      = 1 << 3,
    wxAUI_MGR_TRANSPARENT_HINT_FADE = 1 << 4,

    wxAUI_MGR_Дефолт = wxAUI_MGR_ALLOW_FLOATING |
                             wxAUI_MGR_TRANSPARENT_HINT |
                             wxAUI_MGR_TRANSPARENT_HINT_FADE
};

enum ПНастройкаПаноДокАрта
{
    wxAUI_ART_SASH_SIZE = 0,
    wxAUI_ART_CAPTION_SIZE = 1,
    wxAUI_ART_GRIPPER_SIZE = 2,
    wxAUI_ART_PANE_BORDER_SIZE = 3,
    wxAUI_ART_PANE_BUTTON_SIZE = 4,
    wxAUI_ART_BACKGROUND_COLOUR = 5,
    wxAUI_ART_SASH_COLOUR = 6,
    wxAUI_ART_ACTIVE_CAPTION_COLOUR = 7,
    wxAUI_ART_ACTIVE_CAPTION_GRADIENT_COLOUR = 8,
    wxAUI_ART_INACTIVE_CAPTION_COLOUR = 9,
    wxAUI_ART_INACTIVE_CAPTION_GRADIENT_COLOUR = 10,
    wxAUI_ART_ACTIVE_CAPTION_TEXT_COLOUR = 11,
    wxAUI_ART_INACTIVE_CAPTION_TEXT_COLOUR = 12,
    wxAUI_ART_BORDER_COLOUR = 13,
    wxAUI_ART_GRIPPER_COLOUR = 14,
    wxAUI_ART_CAPTION_FONT = 15,
    wxAUI_ART_GRADIENT_TYPE = 16
};

enum ПГрадиентыПаноДокАрта
{
    Нет = 0,
    Вертикальный = 1,
    Горизонтальный = 2
};

enum ПСостояниеКнопкиПано
{
    Норма = 0,
    Ховер = 1,
    Нажата = 2
};

enum ПУровеньВставкиПано
{
    Пано = 0,
    Ряд = 1,
    Док = 2
};

//-----------------------------------------------------------------------------

extern(D) class ИнфОПано : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    public this();
    public this(ИнфОПано c);
    public бул Ок();
    public бул фиксирован();
    public бул размИзменяем();
    public бул виден();
    public бул плавающ();
    public бул докирован();
    public бул тулбар_ли();
    public бул докируемВверху();
    public бул докируемВнизу();
    public бул докируемСлева();
    public бул докируемСправа();
    public бул можетПлавать();
    public бул можетПеремещаться();
    public бул естьКапшн();
    public бул естьГриппер();
    public бул естьБордюр();
    public бул естьКнопкаЗакрыть();
    public бул естьКнопкаМаксимируй();
    public бул естьКнопкаМинимируй();
    public бул естьКнопкаПришпилить();
    public ИнфОПано окно(Окно w);
    public ИнфОПано имя(ткст ч);
    public ИнфОПано капшн(ткст c);
    public ИнфОПано лево();
    public ИнфОПано право();
    public ИнфОПано верх();
    public ИнфОПано низ();
    public ИнфОПано центруй();
    public ИнфОПано центр();
    public ИнфОПано направление(цел направление);
    public ИнфОПано слой(цел слой);
    public ИнфОПано ряд(цел ряд);
    public ИнфОПано позиция(цел поз);
    public ИнфОПано лучшийРазм(ref Размер размер);
    public ИнфОПано минРазм(ref Размер размер);
    public ИнфОПано максРазм(ref Размер размер);
    public ИнфОПано лучшийРаз(цел x, цел y);
    public ИнфОПано минРазм(цел x, цел y);
    public ИнфОПано максРазм(цел x, цел y);
    public ИнфОПано плавающПоложение(ref Точка поз);
    public ИнфОПано плавающПоложение(цел x, цел y);
    public ИнфОПано плавающРазм(ref Размер размер);
    public ИнфОПано плавающРазм(цел x, цел y);
    public ИнфОПано фиксированый();
    public ИнфОПано изменяемыйРазм(бул перемеряем = да);
    public ИнфОПано докируй();
    public ИнфОПано плавай();
    public ИнфОПано спрячь();
    public ИнфОПано показ(бул показ = да);
    public ИнфОПано капшнВиден(бул видим = да);
    public ИнфОПано бордюрПано(бул видим = да);
    public ИнфОПано гриппер(бул видим = да);
    public ИнфОПано кнопкаЗакрыть(бул видим = да);
    public ИнфОПано кнопкаМаксимируй(бул видим = да);
    public ИнфОПано кнопкаМинимируй(бул видим = да);
    public ИнфОПано КнопкаПришпиль(бул видим = да);
    public ИнфОПано разрушьПриЗакрытии(бул с = да);
    public ИнфОПано докимуемыйВверху(бул с = да);
    public ИнфОПано ДокируемыйВнизу(бул с = да);
    public ИнфОПано докируемыйСлева(бул с = да);
    public ИнфОПано докируемыйСправа(бул с = да);
    public ИнфОПано плавающий(бул с = да);
    public ИнфОПано перемещаемый(бул с = да);
    public ИнфОПано докируемый(бул с = да);
    public ИнфОПано дефПано();
    public ИнфОПано центрПано();
    public ИнфОПано центрируйПано();
    public ИнфОПано паноТулбара();
    public ИнфОПано устФлаг(бцел флаг, бул состоянОпц);
    public бул естьФлаг(бцел флаг);
    public ткст имя();
    public ткст заголовок();
    public Окно окно();
    public Окно рамка();
    public бцел состояние();
    public цел докНаправление();
    public цел докСлой();
    public цел докРяд();
    public цел докПоз();
    public Размер лучшРазм();
    public Размер минРазм();
    public Размер максРазм();
    public Точка плавПоз();
    public Размер плавРазм();
    public цел докПропорция();
    public Прямоугольник прям();

    public enum ПСостояниеПано
    {
        optionFloating        = 1 << 0,
        optionHidden          = 1 << 1,
        optionLeftDockable    = 1 << 2,
        optionRightDockable   = 1 << 3,
        optionTopDockable     = 1 << 4,
        optionBottomDockable  = 1 << 5,
        optionFloatable       = 1 << 6,
        optionMovable         = 1 << 7,
        optionResizable       = 1 << 8,
        optionPaneBorder      = 1 << 9,
        optionCaption         = 1 << 10,
        optionGripper         = 1 << 11,
        optionDestroyOnClose  = 1 << 12,
        optionToolbar         = 1 << 13,
        optionActive          = 1 << 14,

        buttonClose           = 1 << 24,
        buttonMaximize        = 1 << 25,
        buttonMinimize        = 1 << 26,
        buttonPin             = 1 << 27,
        buttonCustom1         = 1 << 28,
        buttonCustom2         = 1 << 29,
        buttonCustom3         = 1 << 30,
        actionPane            = 1 << 31  // used internally
    }
}


extern(D) class МенеджерРамки : ОбработчикСоб
{
    public this(ЦелУкз вхобъ);
    public this(Рамка рамка = пусто, бцел флаги = ПОпцияМенеджераРамки.wxAUI_MGR_Дефолт);
    public проц деиниц();
    public проц устФлаги(бцел флаги);
    public бцел дайФлаги();
    public проц устРамку(Рамка рамка);
    public Рамка дайРамку();
    public проц устАртПровайдер(ДокАрт артПров);
    public ДокАрт дайАртПровайдер();
    public ИнфОПано дайПано(Окно окно);
    public ИнфОПано дайПано(ткст имя);
    public цел дайЧлоПано();
    public ИнфОПано дайПано(цел индекс);
    public бул добавьПано(Окно окно, ИнфОПано инфОПано);
    public бул добавьПано(Окно окно,
                                       цел направление = ПНаправление.Влево,
                                       ткст заголовок = "");
    public бул вставьПано(Окно окно,
                                       ИнфОПано инфОПано,
                                       цел уровеньВставки = ПУровеньВставкиПано.Пано);
    public бул отторочьПано(Окно окно);
    public ткст сохраниПерспективу();
    public бул загрузиПерспективу(ткст перспектива,
            бул обновить = да);
    public проц обнови();

// wx событие machinery


// right now the only событие that works is СОБ_АУИ_КНОПКАПАНО. A full
// spectrum of events will be implemented in the next incremental version

    public static ТипСобытия СОБ_АУИ_КНОПКАПАНО;

    //static this();

    public проц EVT_AUI_PANEBUTTON(ДатчикСобытий дтчк);
}
//----------------------------------------------------
// событие declarations/classes
extern(D) class СобытиеМенеджераРамки : Событие
{
    public this(ЦелУкз вхобъ);
    public Событие клонируй();
    public проц устПано(ИнфОПано p);
    public проц устКнопку(цел с);
    public ИнфОПано дайПано();
    public цел дайКнопку();
}


