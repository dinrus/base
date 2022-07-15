
module wx.StaticBoxSizer;
public import wx.common;
public import wx.BoxSizer;
public import wx.StaticBox;

//---------------------------------------------------------------------

extern(D) class ПеремерщикСтатическогоБокса : ПеремерщикБокса
{
    public this(ЦелУкз вхобъ);
    public this(СтатическийБокс бокс, цел ориент);
    public this(цел ориент, Окно родитель, ткст ярлык);
    public СтатическийБокс статБокс();
}
