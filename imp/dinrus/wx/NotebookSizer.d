module wx.NotebookSizer;
public import wx.common;
public import wx.Sizer;
public import wx.Notebook;

//---------------------------------------------------------------------
extern(D) class ПеремерщикНоутбука : Перемерщик
{
    public this(ЦелУкз вхобъ);
    public this(Ноутбук nb);
    public override проц пересчётРазмеров();
    public override Размер вычислиМин();
    public Ноутбук ноутбук();
}
//-------------------------------------------