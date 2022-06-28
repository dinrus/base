﻿module crypto.cipher.Cipher;

extern(D):

/** Базовый класс симметричного шифра */

abstract class Шифр
{
    interface Параметры {}

    static const бул ШИФРОВАТЬ = да,
                        РАСШИФРОВАТЬ = нет;

    protected бул _инициализован,
              _зашифровать;

    /**
     * Обрабатывает блок простых текстовых данных из массива ввода
     * и помещает его в массив вывода.
     *
     * Параметры:
     *     ввод_  = массив с вводными данными.
     *     вывод_  = массив для выводимых данных.
     *
     * Возвращает: Количество обработанных зашифрованных данных.
     */
    abstract бцел обнови(проц[] ввод_, проц[] вывод_);

    /** Возвращает: Имя алгоритма данного шифра. */
    abstract ткст имя();

    /** Сбрасывает шифр в состояние сразу после последней инициализации. */
    abstract проц сбрось();

    /**
     * Выводит исключение неверного аргумента.
     *
     * Параметры:
     *     сооб = сообщение, связанное с исключением
     */
    static проц не_годится (ткст сооб);

    /** Возвращает: инициализован ли шифр. */
    final бул инициализован();
}



/** Интерфейс стандартного блочного шифра. */
abstract class ШифрБлок : Шифр
{
    /** Возвращает: Размер блока в байтах, с которым будет оперировать данный шифр. */
    abstract бцел размерБлока();
}


/** Интерфейс старндартного поточного шифра. */
abstract class ШифрПоток : Шифр
{
    /**
     * Обрабатывает один байт ввода.
     *
     * Параметры:
     *     ввод = Байт для XOR с ключПоток.
     *
     * Возвращает: Один байт ввода, XORed с ключПоток.
     */
    abstract ббайт верниБбайт(ббайт ввод);
}


/** Базовый класс паддинга для реализации блочно-паддинговых схем. */
abstract class ПаддингБлокаШифра
{
    /** Возвращает: Имя реализованной паддинговой схемы. */
    abstract ткст имя();

    /**
    * Генерирует паддинг на определённую длину.
    *
    * Параметры:
    *     длин = Длина генерируемого паддинга
    *
    * Возвращает: Байты паддинга, которые будут добавлены.
    */
    abstract ббайт[] пад(бцел длин);

    /**
    * Возвращает число пад байтов в блоке.
    *
    * Параметры:
    *     ввод_ = Паддированный блок, у которого подсчитываются пад байты.
    *
    * Возвращает: Число пад байтов в блоке.
    *
    */
    abstract бцел отпад(проц[] ввод_);
}



/** Объект, представляющий и оборачивающий симметричный ключ в байты. */
class СимметричныйКлюч : Шифр.Параметры
{
    /**
     * Параметры:
     *     ключ = Сохраняемый ключ.
     */
    this(проц[] ключ=пусто);

    /** Возвращает: Ключ, хранящийся в этом объекте. */
    ббайт[] ключ();

    /**
     * Устанавливает ключ, хранящийся в этом объекте.
     *
     * Параметры:
     *     новКлюч = Новый сохраняемый ключ.
     * Возвращает: Новый ключ.
     */
    ббайт[] ключ(проц[] новКлюч);
}

/** Wrap cipher параметры и IV. */
class ПараметрыIV : Шифр.Параметры
{
    /**
     * Параметры:
     *     парамы = Параметры в_ wrap.
     *     iv     = IV в_ be held.
     */
    this (Шифр.Параметры парамы=пусто, проц[] iv=пусто);

    /** Возвращает: The IV. */
    ббайт[] iv();

    /**
     * Устанавливает IV held by this объект.
     *
     * Параметры:
     *     newIV = The new IV для этого parameter объект.
     * Возвращает: The new IV.
     */
    ббайт[] iv(проц[] newIV);

    /** Возвращает: The параметры для этого объект. */
    Шифр.Параметры параметры();

    /**
     * Устанавливает параметры held by this объект.
     *
     * Параметры:
     *     newParams = The new параметры в_ be held.
     * Возвращает: The new параметры.
     */
    Шифр.Параметры параметры(Шифр.Параметры newParams);
}


struct Побитно
{
    static бцел вращайВлево(бцел x, бцел y);
    static бцел вращайВправо(бцел x, бцел y);
    static бдол вращайВлево(бдол x, бцел y);
    static бдол вращайВправо(бдол x, бцел y);
}


/** Converts between integral типы и unsigned байт массивы */
struct БайтКонвертер
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

    static ткст кодируйГекс(проц[] ввод_);
    static ткст кодируйБаза32(проц[] ввод_, бул doPad=да);
    static ббайт[] раскодируйГекс(ткст ввод);
    static ббайт[] раскодируйБаза32(ткст ввод);
}
