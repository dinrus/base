module wx.Wizard;
public import wx.common;
public import wx.Dialog;
public import wx.Panel;
public import wx.WizardPage;

//---------------------------------------------------------------------

extern(D) class Мастер : Диалог
{
    public this(ЦелУкз вхобъ);
    public this(Окно родитель, цел ид = ЛЮБОЙ, ткст титул = "", Битмап битмап = Битмап.НуллБитмап, Точка поз = ДЕФПОЗ, цел стиль = ДЕФ_СТИЛЬ_ДИАЛОГА);
    public бул выполниМастер(СтраницаМастера первоеОкно);
    public проц размерСтраницы(Размер значение);
}
