/// Общие структуры, не принадлежащие ни к одному отдельному классу
module wx.common;

import wx.wxPlatform;

version(Win32)
{
	/// Win platform
	version = __МСВ__;
}

typedef ук ЦелУкз;

version(Unicode)
alias шим wxChar;
else //version(ANSI)
    alias ббайт wxChar;

struct Точка
{
    //  export:
    цел Х,У;

    /** struct constructor */
    static Точка opCall(цел x,цел y)
    {
        Точка тчк;
        тчк.Х = x;
        тчк.У = y;
        return тчк;
    }
}

struct Размер
{
    // export:
    цел ширь,высь;

    /** struct constructor */
    static Размер opCall(цел w,цел h)
    {
        Размер рм;
        рм.ширь = w;
        рм.высь = h;
        return рм;
    }
}

struct Прямоугольник
{
    //export:
    цел Х,У,ширь,высь;
    цел  лево()
    {
        return Х;
    }
    проц лево(цел значение)
    {
        Х = значение;
    }
    цел  верх()
    {
        return У;
    }
    проц верх(цел значение)
    {
        У = значение;
    }

    цел  право()
    {
        return Х + ширь - 1;
    }
    проц право(цел значение)
    {
        ширь = значение - Х + 1;
    }
    цел  низ()
    {
        return У + высь - 1;
    }
    проц низ(цел значение)
    {
        высь = значение - У + 1;
    }

    /** struct constructor */
    static Прямоугольник opCall(цел x,цел y,цел w,цел h)
    {
        Прямоугольник прям;
        прям.Х = x;
        прям.У = y;
        прям.ширь = w;
        прям.высь = h;
        return прям;
    }
}
alias Прямоугольник Прям;

interface ИВымещаемый
{
    проц вымести();
}

interface ИКлонируемый
{
    Объект клонируй();
}

//////////////////////
extern(D):

 ткст примемЗаУникума(ткст т);
 ткст дайТрансляцию(ткст стр);
 ткст _(ткст стр);
//---------------------------------------------------------------------

class ВизОбъект : ИВымещаемый
{

    public ЦелУкз вхобъ(ЦелУкз объ = ЦелУкз.init);
    public this(ЦелУкз вхобъ);
    private this(ЦелУкз вхобъ,бул памСобств);
    public static ЦелУкз безопУк(ВизОбъект объ);
    private static ткст дайИмяТипа(ЦелУкз вхобъ);
    public ткст дайИмяТипа();
    private static проц добавьОбъект(ВизОбъект объ);
	alias static ВизОбъект function(ЦелУкз вхобъ) новфункц;
	public static ВизОбъект найдиОбъект(ЦелУкз укз, новфункц Нов);
    public static ВизОбъект найдиОбъект(ЦелУкз укз);
    public static бул удалиОбъект(ЦелУкз укз);
	static extern(C) проц VirtualDispose(ЦелУкз укз);
    //private проц виртВымести();
    //protected проц dtor();
    public  проц вымести();
    ~this() ;
    protected бул вымещен();
}

//---------------------------------------------------------------------

/// ВизТкст -класс, представляющий строку символов.
class ВизТкст : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    //package this(ЦелУкз вхобъ, бул памСобств);
    public this();
    public this(ткст стр);
    public this(wxChar* wxstr, т_мера wxlen);
    ~this();
    public т_мера длина();
    public wxChar* данные();
    public wxChar opIndex(т_мера i);
    public проц opIndexAssign(wxChar c, т_мера i);
    public ткст opCast();
    public ббайт[] вАнзи();
    public wchar_t[] вУайд();
    public override ткст вТкст();
}

    class ИсклНуллУказателя : Исключение
{
    this(ткст сооб);
}

class ИсклНуллССылки : Исключение
{
    this(ткст сооб);
}

class ИсклАргумента : Исключение
{
    this(ткст сооб);
}

class ИсклНевернОперации : Исключение
{
    this(ткст сооб);
}

class ИсклНуллАргумента : Исключение
{
    this(ткст сооб);
}
