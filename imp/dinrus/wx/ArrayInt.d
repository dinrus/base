/// The wxArrayInt wrapper class
module wx.ArrayInt;
public import wx.common;

extern(D) class ЦелМассив : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    public this(ЦелУкз вхобъ, бул памСобств);
    public this();
    public цел[] вМассив();
    public проц добавь(цел доб);
    public цел элт(цел чис);
    public цел счёт();
    ~this();
}

