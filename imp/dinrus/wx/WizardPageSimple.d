module wx.WizardPageSimple;
public import wx.WizardPage;
public import wx.Wizard;

//---------------------------------------------------------------------

extern(D) class ПростаяСтраницаМастера : СтраницаМастера
{
    public this(Мастер родитель, СтраницаМастера prev = пусто, СтраницаМастера next = пусто, Битмап битмап = Битмап.НуллБитмап, ткст resource = пусто);
    public this(ЦелУкз вхобъ);
    public static проц Chain(ПростаяСтраницаМастера first, ПростаяСтраницаМастера секунда);
}

