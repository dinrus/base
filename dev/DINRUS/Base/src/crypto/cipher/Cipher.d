module crypto.cipher.Cipher;

private import exception: ИсклНелегальногоАргумента;

//alias ткст ткст;

/** База symmetric cipher class */
export abstract class Шифр
{
    interface Параметры {}

    static const бул ШИФРОВАТЬ = да,
                        РАСШИФРОВАТЬ = нет;

    protected бул _инициализован,
              _зашифровать;

    /**
     * Процесс a блок of plaintext данные из_ the ввод Массив
     * и place it in the вывод Массив.
     *
     * Параметры:
     *     ввод_  = Массив containing ввод данные.
     *     вывод_  = Массив в_ hold the вывод данные.
     *
     * Возвращает: The amount of encrypted данные processed.
     */
    abstract бцел обнови(проц[] ввод_, проц[] вывод_);

    /** Возвращает: The имя of the algorithm of this cipher. */
    abstract ткст имя();

    /** Reset cipher в_ its состояние immediately subsequent the последний init. */
    abstract проц сбрось();

    /**
     * throw an InvalidАргумент исключение
     *
     * Параметры:
     *     сооб = сообщение в_ associate with the исключение
     */
    export static проц не_годится (ткст сооб)
    {
        throw new ИсклНелегальногоАргумента (сооб);
    }

    /** Возвращает: Whether or not the cipher имеется been инициализован. */
    export бул инициализован()
    {
        return _инициализован;
    }
}



/** Interface for a стандарт блок cipher. */
abstract class ШифрБлок : Шифр
{
    /** Возвращает: The блок размер in байты that this cipher will operate on. */
    abstract бцел размерБлока();
}


/** Interface for a стандарт поток cipher. */
abstract class ШифрПоток : Шифр
{
    /**
     * Процесс one байт of ввод.
     *
     * Параметры:
     *     ввод = Byte в_ XOR with ключПоток.
     *
     * Возвращает: One байт of ввод XORed with the ключПоток.
     */
    abstract ббайт верниБбайт(ббайт ввод);
}


/** База паддинг class for implementing блок паддинг schemes. */
abstract class ПаддингБлокаШифра
{
    /** Возвращает: The имя of the паддинг схема implemented. */
    abstract ткст имя();

    /**
    * Generate паддинг в_ a specific length.
    *
    * Параметры:
    *     длин = Length of паддинг в_ generate
    *
    * Возвращает: The паддинг байты в_ be добавьed.
    */
    abstract ббайт[] пад(бцел длин);

    /**
    * Возвращает the число of пад байты in the блок.
    *
    * Параметры:
    *     ввод_ = Pдобавьed блок of which в_ счёт the пад байты.
    *
    * Возвращает: The число of пад байты in the блок.
    *
    * Выводит исключение: dcrypt.crypto.ошибки.InvalКСЕРдобавимError if
    *         пад length cannot be discerned.
    */
    abstract бцел отпад(проц[] ввод_);
}



/** Объект representing и wrapping a symmetric ключ in байты. */
class СимметричныйКлюч : Шифр.Параметры
{
    private ббайт[] _ключ;

    /**
     * Параметры:
     *     ключ = Key в_ be held.
     */
   export this(проц[] ключ=пусто)
    {
        _ключ = cast(ббайт[]) ключ;
    }

    /** Play nice with D2's опрea of const. */
    version (D_Version2)
    {
       export this (ткст ключ)
        {
            this(cast(ббайт[])ключ);
        }
    }

    /** Возвращает: Key  held by this объект. */
  export  ббайт[] ключ()
    {
        return _ключ;
    }

    /**
     * Набор the ключ held by this объект.
     *
     * Параметры:
     *     новКлюч = Нов ключ в_ be held.
     * Возвращает: The new ключ.
     */
    export ббайт[] ключ(проц[] новКлюч)
    {
        return _ключ = cast(ббайт[]) новКлюч;
    }
}


/** Wrap cipher параметры и IV. */
class ПараметрыIV : Шифр.Параметры
{
    private ббайт[] _iv;
    private Шифр.Параметры _парамы;

    /**
     * Параметры:
     *     парамы = Параметры в_ wrap.
     *     iv     = IV в_ be held.
     */
   export this (Шифр.Параметры парамы=пусто, проц[] iv=пусто)
    {
        _парамы = парамы;
        _iv = cast(ббайт[]) iv;
    }

    /** Возвращает: The IV. */
   export ббайт[] iv()
    {
        return _iv;
    }

    /**
     * Набор the IV held by this объект.
     *
     * Параметры:
     *     newIV = The new IV for this parameter объект.
     * Возвращает: The new IV.
     */
   export ббайт[] iv(проц[] newIV)
    {
        return _iv = cast(ббайт[]) newIV;
    }

    /** Возвращает: The параметры for this объект. */
   export Шифр.Параметры параметры()
    {
        return _парамы;
    }

    /**
     * Набор the параметры held by this объект.
     *
     * Параметры:
     *     newParams = The new параметры в_ be held.
     * Возвращает: The new параметры.
     */
   export Шифр.Параметры параметры(Шифр.Параметры newParams)
    {
        return _парамы = newParams;
    }
}


export struct Побитно
{
   export static бцел вращайВлево(бцел x, бцел y)
    {
        return (x << y) | (x >> (32u-y));
    }

   export static бцел вращайВправо(бцел x, бцел y)
    {
        return (x >> y) | (x << (32u-y));
    }

    export static бдол вращайВлево(бдол x, бцел y)
    {
        return (x << y) | (x >> (64u-y));
    }

   export static бдол вращайВправо(бдол x, бцел y)
    {
        return (x >> y) | (x << (64u-y));
    }
}


/** Преобразует между интегральными типами и массивами беззначных байт */
export struct БайтКонвертер
{
    private static ткст гекситы = "0123456789abcdef";
    private static ткст цифрыБазы32 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";

    /** Conversions between little эндиан integrals и байты */
   struct ЛитлЭндиан
    {
        /**
         * Converts the supplied Массив в_ integral тип T
         *
         * Параметры:
         *     x_ = The supplied Массив of байты (, байты, симвы, whatever)
         *
         * Возвращает:
         *     A integral of тип T создан with the supplied байты placed
         *     в указанном байт order.
         */
        static T в_(T)(проц[] x_)
        {
            ббайт[] x = cast(ббайт[])x_;

            T результат = ((cast(T)x[0])       |
                                    ((cast(T)x[1]) << 8));

            static if (T.sizeof >= цел.sizeof)
            {
                результат |= ((cast(T)x[2]) << 16) |
                                      ((cast(T)x[3]) << 24);
            }

            static if (T.sizeof >= дол.sizeof)
            {
                результат |= ((cast(T)x[4]) << 32) |
                                      ((cast(T)x[5]) << 40) |
                                      ((cast(T)x[6]) << 48) |
                                      ((cast(T)x[7]) << 56);
            }

            return результат;
        }

        /**
         * Converts the supplied integral в_ an Массив of unsigned байты.
         *
         * Параметры:
         *     ввод = Integral в_ преобразуй в_ байты
         *
         * Возвращает:
         *     Integral ввод of тип T разбей преобр_в its respective байты
         *     with the байты placed в указанном байт order.
         */
        static ббайт[] из_(T)(T ввод)
        {
            ббайт[] вывод = new ббайт[T.sizeof];

            вывод[0] = cast(ббайт)(ввод);
            вывод[1] = cast(ббайт)(ввод >> 8);

            static if (T.sizeof >= цел.sizeof)
            {
                вывод[2] = cast(ббайт)(ввод >> 16);
                вывод[3] = cast(ббайт)(ввод >> 24);
            }

            static if (T.sizeof >= дол.sizeof)
            {
                вывод[4] = cast(ббайт)(ввод >> 32);
                вывод[5] = cast(ббайт)(ввод >> 40);
                вывод[6] = cast(ббайт)(ввод >> 48);
                вывод[7] = cast(ббайт)(ввод >> 56);
            }

            return вывод;
        }
    }

    /** Conversions between big эндиан integrals и байты */
    struct БигЭндиан
    {

        static T в_(T)(проц[] x_)
        {
            ббайт[] x = cast(ббайт[])x_;

            static if (is(T == бкрат) || is(T == крат))
            {
                return cast(T) (((x[0] & 0xff) << 8) |
                                (x[1] & 0xff));
            }
            else static if (is(T == бцел) || is(T == цел))
            {
                return cast(T) (((x[0] & 0xff) << 24) |
                                ((x[1] & 0xff) << 16) |
                                ((x[2] & 0xff) << 8)  |
                                (x[3] & 0xff));
            }
            else static if (is(T == бдол) || is(T == дол))
            {
                return cast(T) ((cast(T)(x[0] & 0xff) << 56) |
                                (cast(T)(x[1] & 0xff) << 48) |
                                (cast(T)(x[2] & 0xff) << 40) |
                                (cast(T)(x[3] & 0xff) << 32) |
                                ((x[4] & 0xff) << 24) |
                                ((x[5] & 0xff) << 16) |
                                ((x[6] & 0xff) << 8)  |
                                (x[7] & 0xff));
            }
        }

        static ббайт[] из_(T)(T ввод)
        {
            ббайт[] вывод = new ббайт[T.sizeof];

            static if (T.sizeof == дол.sizeof)
            {
                вывод[0] = cast(ббайт)(ввод >> 56);
                вывод[1] = cast(ббайт)(ввод >> 48);
                вывод[2] = cast(ббайт)(ввод >> 40);
                вывод[3] = cast(ббайт)(ввод >> 32);
                вывод[4] = cast(ббайт)(ввод >> 24);
                вывод[5] = cast(ббайт)(ввод >> 16);
                вывод[6] = cast(ббайт)(ввод >> 8);
                вывод[7] = cast(ббайт)(ввод);
            }
            else static if (T.sizeof == цел.sizeof)
            {
                вывод[0] = cast(ббайт)(ввод >> 24);
                вывод[1] = cast(ббайт)(ввод >> 16);
                вывод[2] = cast(ббайт)(ввод >> 8);
                вывод[3] = cast(ббайт)(ввод);
            }
            else static if (T.sizeof == крат.sizeof)
            {
                вывод[0] = cast(ббайт)(ввод >> 8);
                вывод[1] = cast(ббайт)(ввод);
            }

            return вывод;
        }
    }

   export static ткст кодируйГекс(проц[] ввод_)
    {
        ббайт[] ввод = cast(ббайт[])ввод_;
        ткст вывод = new сим[ввод.length<<1];

        цел i = 0;
        foreach (ббайт j; ввод)
        {
            вывод[i++] = гекситы[j>>4];
            вывод[i++] = гекситы[j&0xf];
        }

        return cast(ткст)вывод;
    }

   export static ткст кодируйБаза32(проц[] ввод_, бул doPad=да)
    {
        if (!ввод_)
            return "";
        ббайт[] ввод = cast(ббайт[])ввод_;
        ткст вывод;
        auto inputbits = ввод.length*8;
        auto inputquantas = inputbits / 40;
        if (inputbits % 40)
            вывод = new сим[(inputquantas+1) * 8];
        else
            вывод = new сим[inputquantas * 8];

        цел i = 0;
        бкрат остаток;
        ббайт остдлина;
        foreach (ббайт j; ввод)
        {
            остаток = (остаток<<8) | j;
            остдлина += 8;
            while (остдлина > 5)
            {
                вывод[i++] = цифрыБазы32[(остаток>>(остдлина-5))&0b11111];
                остдлина -= 5;
            }
        }
        if (остдлина)
            вывод[i++] = цифрыБазы32[(остаток<<(5-остдлина))&0b11111];
        while (doPad && (i < вывод.length))
        {
            вывод[i++] = '=';
        }

        return вывод[0..i];
    }

   export static ббайт[] раскодируйГекс(ткст ввод)
    {
        ткст inputAsLower = ткстВНижний(ввод);
        ббайт[] вывод = new ббайт[ввод.length>>1];

        static ббайт[сим] hexitIndex;
        for (цел i = 0; i < гекситы.length; i++)
            hexitIndex[гекситы[i]] = cast(ббайт) i;

        for (цел i = 0, j = 0; i < вывод.length; i++)
        {
            вывод[i] = cast(ббайт) (hexitIndex[inputAsLower[j++]] << 4);
            вывод[i] |= hexitIndex[inputAsLower[j++]];
        }

        return вывод;
    }

  export  static ббайт[] раскодируйБаза32(ткст ввод)
    {
        static ббайт[сим] b32Index;
        for (цел i = 0; i < цифрыБазы32.length; i++)
            b32Index[цифрыБазы32[i]] = cast(ббайт) i;

        auto outlen = (ввод.length*5)/8;
        ббайт[] вывод = new ббайт[outlen];

        бкрат остаток;
        ббайт остдлина;
        т_мера oIndex;
        foreach (c; ткстВВерхний(ввод))
        {
            if (c == '=')
                continue;
            остаток = (остаток<<5) | b32Index[c];
            остдлина += 5;
            while (остдлина >= 8)
            {
                вывод[oIndex++] = cast(ббайт) (остаток >> (остдлина-8));
                остдлина -= 8;
            }
        }

        return вывод[0..oIndex];
    }

    private static ткст ткстВНижний(ткст ввод)
    {
        ткст вывод = new сим[ввод.length];

        foreach (цел i, сим c; ввод)
        вывод[i] = cast(сим) ((c >= 'A' && c <= 'Z') ? c+32 : c);

        return cast(ткст)вывод;
    }

    private static ткст ткстВВерхний(ткст ввод)
    {
        ткст вывод = new сим[ввод.length];

        foreach (цел i, сим c; ввод)
        вывод[i] = cast(сим) ((c >= 'a' && c <= 'z') ? c-32 : c);

        return cast(ткст)вывод;
    }
}
