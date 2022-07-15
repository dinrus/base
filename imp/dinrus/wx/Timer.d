module wx.Timer;
public import wx.common;
public import wx.EvtHandler;

//---------------------------------------------------------------------------
// Constants for Таймер.Play
//---------------------------------------------------------------------------

/// generate notifications periodically until the timer is stopped (default)
const бул ТАЙМЕР_ПРОДОЛЖИТЕЛЬНЫЙ = нет;

/// only send the notification once and then stop the timer
const бул ТАЙМЕР_ОДНОРАЗОВЫЙ = да;

//-----------------------------------------------------------------------------

extern(D) class Таймер : ОбработчикСоб
{

    public this();
    public this(ОбработчикСоб владелец, цел ид=-1);
    public this(ЦелУкз вхобъ);
    //private this(ЦелУкз вхобъ, бул памСобств);
    ~this();
    static extern(C) проц staticNotify(Таймер объ);
    protected  проц уведоми();
    public цел интервал();
    public бул однократен();
    public бул пущен();
    public проц устВладельца(ОбработчикСоб владелец, цел ид=-1);
    public бул старт(цел миллисек=-1, бул oneShot=нет);
    public проц стоп();
}
