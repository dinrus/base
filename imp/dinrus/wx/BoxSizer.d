module wx.BoxSizer;
public import wx.common;
public import wx.Sizer;

//---------------------------------------------------------------------
    extern(C) static проц staticRecalcSizes(ПеремерщикБокса объ);
    extern(C)  static проц staticCalcMin(ПеремерщикБокса объ,out Размер размер);
	
extern(D) class ПеремерщикБокса : Перемерщик
{
    public this(ЦелУкз вхобъ);
    public this(цел ориент);
    public override проц пересчётРазмеров();
    public override Размер вычислиМин();
    public цел ориентация();
    public проц ориентация(цел значение);
}
