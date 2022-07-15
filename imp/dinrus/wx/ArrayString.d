module wx.ArrayString;
public import wx.common;

extern(D) class ТкстМассива : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    public this(ЦелУкз вхобъ, бул памСобств);
    public this();
    public ткст[] вМассив();
    public ткст элт(цел чис);
    public проц добавь(ткст доб);
    public цел счёт();
    ~this();
}

