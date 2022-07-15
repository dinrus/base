module wx.Log;
public import wx.common;
public import wx.TextCtrl;

extern(D) class Лог : ВизОбъект
{
    enum ПУровеньОшЛога : цел
    {
        Лог,
        ФатОш,
        Ош,
        Предупр,
        Инфо,
        Подробн,
        Статус,
        СисОш
    }

    public this(ЦелУкз вхобъ);
    public this();
    static бул активирован();
    public static проц слейАктивный();
    public static проц устАктивнуюЦель(ТекстКтрл pLogger);
    public static проц добавьМаскуТрассы(ткст tmask);
    public static проц логСообщения(...);
    public static проц логФатальнойОшибки(...);
    public static проц логОшибки(...);
    public static проц логПредупреждения(...);
    public static проц логИнфо(...);
    public static проц логДетально(...);
    public static проц логСтатус(...);
    public static проц логСисОшибки(...);
}
//-------------------------------------------