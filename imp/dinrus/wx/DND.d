module wx.DND;
public import wx.common;
public import wx.DataObject;
public import wx.Window;

public enum ПТяг
{
    ТолькоКопировать    = 0,
    ПеремещениеВозможно   = 1,
    ДефПеремещение = 3
}

//---------------------------------------------------------------------

public enum ПРезультатТяга
{
    Ошибка,
    Никакой,
    Копирование,
    Перемещение,
    Линк,
    Отмена
}

//---------------------------------------------------------------------


extern(D) class ИстокБроса : ВизОбъект
{
    protected ОбъектДанных m_dataObject = пусто;

    public this(ЦелУкз вхобъ);
    //private this(ЦелУкз вхобъ, бул памСобств);
    public this(Окно ок = пусто);
    public this(ОбъектДанных объДанных, Окно ок = пусто);
    ~this();
    // static extern(C) цел staticDoDoDragDrop(ИстокБроса объ,цел флаги);
    public  ПРезультатТяга делайТягБрос(цел флаги);
    public ОбъектДанных объДанных();
    public проц объДанных(ОбъектДанных значение);
}

//---------------------------------------------------------------------

extern(D)  abstract class МишеньСброса : ВизОбъект
{
    protected ОбъектДанных m_dataObject = пусто;
    public this(ОбъектДанных объДанных = пусто);
    public this(ЦелУкз вхобъ);
    //private this(ЦелУкз вхобъ, бул памСобств);
    ~this();
    // static extern(C) цел staticDoOnDragOver(МишеньСброса объ, цел x, цел y, цел def);
    public  ПРезультатТяга приТягНадЦелью(цел x, цел y, ПРезультатТяга def);
    static extern(C) бул staticOnDrop(МишеньСброса объ, цел x, цел y);
    public  бул приБросе(цел x, цел y);
    // static extern(C) цел staticDoOnData(МишеньСброса объ, цел x, цел y, цел def);
    public abstract ПРезультатТяга приДанных(цел x, цел y, ПРезультатТяга def);
    // static extern(C) бул staticGetData(МишеньСброса объ);
    public  бул дайДанные();
    //  static extern(C) цел staticDoOnEnter(МишеньСброса объ, цел x, цел y, цел def);
    public  ПРезультатТяга приВходе(цел x, цел y, ПРезультатТяга def);
    //  static extern(C) проц staticOnLeave(МишеньСброса объ);
    public  проц приВыходе();
    public ОбъектДанных объДанных();
    public проц объДанных(ОбъектДанных значение);

}

//---------------------------------------------------------------------

extern(D)  abstract class ЦельБросаТекста : МишеньСброса
{
    public this();
    public abstract бул приБросеТекста(цел x, цел y, ткст текст);
    public override ПРезультатТяга приДанных(цел x, цел y, ПРезультатТяга def);
    public override бул приБросе(цел x, цел y);
    public override бул дайДанные();
}

//---------------------------------------------------------------------

extern(D)  abstract class ЦельБросаФайла : МишеньСброса
{
    public this();
    public abstract бул приЗабросеФайлов(цел x, цел y, ткст[] именаФ);
    public override ПРезультатТяга приДанных(цел x, цел y, ПРезультатТяга def);
    public override бул приБросе(цел x, цел y);
    public override бул дайДанные();
}

