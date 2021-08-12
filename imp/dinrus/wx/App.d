module wx.App;
public import wx.common;
public import wx.EvtHandler;
public import wx.Window;
public import wx.GdiCommon;
public import wx.Clipboard;
public import wx.FontMisc;

    extern (C) static бул staticInitialize(Приложение o,inout цел argc,ткст0* argv);
    extern (C) static бул staticOnInit(Приложение o);
    extern (C) static цел  staticOnRun(Приложение o);
    extern (C) static цел  staticOnExit(Приложение o);

extern(D)  abstract class Приложение : ОбработчикСоб
{
    //private static Приложение app;
    //private Объект м_схваченноеИскл = пусто;

    public проц ловиИскл(Объект e);
    protected this();
    public бул иниц(inout цел argc,ткст0* argv);
    public  бул поИниц();
    public  цел поПуску();
    public  цел поВыходу();
    public static Приложение дайПриложение();
    public проц пуск();
    public проц пуск(char[][] арги);
    public ткст имяВендора();
    public проц имяВендора(ткст имя);
    public ткст имяПриложения();
    public проц имяПриложения(ткст имя);
    public Окно топОкно();
    public проц топОкно(Окно окно);
    public static бул безопЖни();
    public static бул безопЖни(Окно ок);
    public static бул безопЖни(Окно ок, бул толькоПриНеобх);
    public бул жни();
    public бул жни(бул толькоПриНеобх);
    public static проц побудка();
    public проц выйдиИзГлавнЦикла();

}
