module wx.FontDialog;
public import wx.common;
public import wx.Dialog;
public import wx.Font;
public import wx.GdiCommon; 
//---------------------------------------------------------------------

extern(D) class ДанныеШрифта : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    public this();
    public бул символыРазрешены();
    public проц символыРазрешены(бул значение);
    public бул эффектыВключены();
    public проц эффектыВключены(бул значение);
    public бул показатьСправку();
    public проц показатьСправку(бул значение);
    public Цвет цвет();
    public проц цвет(Цвет значение);
    public Шрифт начальныйШрифт();
    public проц начальныйШрифт(Шрифт значение);
    public Шрифт выбранныйШрифт();
    public проц выбранныйШрифт(Шрифт значение);
    public проц устДиапазон(цел мин, цел макс);
    ////public static ВизОбъект Нов(ЦелУкз укз);
}

//---------------------------------------------------------------------

extern(D) class ДиалогШрифта : Диалог
{
    public this(ЦелУкз вхобъ);
    public this();
    public this(Окно родитель);
    public this(Окно родитель, ДанныеШрифта данные);
    public бул создай(Окно родитель, ДанныеШрифта данные);
    public ДанныеШрифта данныеШрифта();
    public override цел покажиМодально();
}


extern(D) Шрифт дайШрифтОтПользователя(Окно родитель,Шрифт иницШрифт=пусто);