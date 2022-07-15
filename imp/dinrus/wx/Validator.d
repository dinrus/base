module wx.Validator;
public import wx.common;
public import wx.EvtHandler;

//--------------------------------------
extern(D) Оценщик дефОценщик();

//--------------------------------------
extern(D) class Оценщик : ОбработчикСоб
{
    static Оценщик ДефОценщик;
	
    static this()
    {
        ДефОценщик = дефОценщик();
    } 
    public this();
    public this(ЦелУкз вхобъ);
    
}
