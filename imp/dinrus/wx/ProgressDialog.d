module wx.ProgressDialog;
public import wx.common;
public import wx.Dialog;

//-----------------------------------------------------------------------------
extern(D) class ДиалогПрогресса : Диалог
{
    public const цел МОЖЕТ_АБОРТИРОВАТЬСЯ      = 0x0001;
    public const цел ПРИЛ_МОДАЛЬНОЕ      = 0x0002;
    public const цел АВТОСКРЫТИЕ      = 0x0004;
    public const цел ПРОШЛО_ВРЕМЕНИ   = 0x0008;
    public const цел ПРИБЛИЗИТ_ВРЕМЯ = 0x0010;
    public const цел ОСТАВШЕЕСЯ_ВРЕМЯ = 0x0040;

    public this(ЦелУкз вхобъ);
    public this(ткст титул, ткст сообщение, цел maximum = 100, Окно родитель = пусто, цел стиль = ПРИЛ_МОДАЛЬНОЕ | АВТОСКРЫТИЕ);
    public бул обнови(цел значение);
    public бул обнови(цел значение, ткст новсооб);
    public проц возобнови();
    public override бул показ(бул показ = да);
    ~this();
}

