module wx.GridSizer;
public import wx.common;
public import wx.Sizer;

//---------------------------------------------------------------------

extern(D) class ПеремерщикСетки : Перемерщик
{
    public this(ЦелУкз вхобъ);
    public this(цел ряды, цел клнки, цел вертГэп, цел горизГэп);
    public this(цел клнки, цел вертГэп = 0, цел горизГэп = 0);
    public override проц пересчётРазмеров();
    public override Размер вычислиМин();
    public проц колонки(цел значение);
    public цел колонки();
    public проц ряды(цел значение);
    public цел ряды();
    public проц вертГэп(цел значение);
    public цел вертГэп();
    public проц горизГэп(цел значение);
    public цел горизГэп();
}