module wx.ToolTip;
public import wx.common;
public import wx.Window;

//---------------------------------------------------------------------

extern(D) class ПодсказкаИнструмента : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    public this(ткст подсказка);
    static проц активен(бул значение);
    static проц заминка(цел значение);
    public ткст подсказка();
    public проц подсказка(ткст значение);
    public Окно окно();
    public проц окно(Окно ок);
}

