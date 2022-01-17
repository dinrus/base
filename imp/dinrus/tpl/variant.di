/**
 * Модуль variant содержит вариант или полиморфный тип.
 */
module tpl.variant;

private import tpl.traits;
private import tpl.tuple;

private extern(C) Объект _d_toObject(ук);

/*
 * Контроль компилирования с поддержкой вариадических аргументов.
 */

version( DigitalMars )
{
    version( X86 )
    {
        version( Windows )
        {
            version=РазрешитьВарарг;
        }
        else version( Posix )
        {
            version=РазрешитьВарарг;
        }
    }
}
else version( LDC )
{
    version( X86 )
    {
        version( linux )
        {
            version=РазрешитьВарарг;
        }
    }
    else version( X86_64 )
    {
        version( linux )
        {
            version=РазрешитьВарарг;
        }
    }
}
else version( DDoc )
{
    version=РазрешитьВарарг;
}

version( РазрешитьВарарг ) {} else
{
    pragma(msg, "Примечание: Функционал Вариант vararg не поддерживается для этой "
           "комбинации компилятора/платформы.");
    pragma(msg, "Чтобы переписать и активировать поддержку vararg в любом случае, компилируйте "
           "с версией РазрешитьВарарг.");
}

private
{
    /*
     * Используется для хранения действительного значение в Варианте.
     */
    struct ХранилищеВариантов
    {
        union
        {
            /*
             * Содержит размещённое на куче хранилище для значений которые слишком большие
             * и не могут непосредственно преобразовываться в Вариант.
             */
            проц[] куча;

            /*
             * Используется для прямого хранения массивов. Заметьте, что это НЕ действительный
             * Массив; использование проц[] вызывает изменение длины, отчего свойство
             * ptr() меняется.
             *
             * ПРЕДУРЕЖДЕНИЕ: эта структура ДОЛЖНА соответствовать ABI для массивов для данной
             * платформы.  AFAIK, все компиляторы реализуют массивы таким образом.
             * В этом можно убедиться с помощью юнит-теста.
             */
            struct Массив
            {
                т_мера length;
                ук  ptr;
            }
            Массив массив;

            // Используется для упрощения работы с объектами.
            Объект об;

            // Используется для обращения к хранилищу как к Массиву.
            ббайт[Массив.sizeof] данные;
        }

        /*
         * Используется для безопасной установки структуры Массив.
         */
        проц установиМассив(ук  ptr, т_мера length)
        {
            массив.length = 0;
            массив.ptr = ptr;
            массив.length = length;
        }
    }

    // Определяет, указан ли тип Объект (класс).
    template объект_ли(T)
    {
        static if( is( T : Объект ) )
            const объект_ли = да;
        else
            const объект_ли = нет;
    }

    // Определяет, указан ли тип интерфес.
    template интерфейс_ли(T)
    {
        static if( is( T == interface ) )
            const интерфейс_ли = да;
        else
            const интерфейс_ли = нет;
    }

    // Список всех базовых типов.
    alias Кортеж!(бул, сим, шим, дим,
    байт, крат, цел, дол, //cent,
    ббайт, бкрат, бцел, бдол, //ucent,
    плав, дво, реал,
    вплав, вдво, вреал,
    кплав, кдво, креал) ОсновныеТипы;

    // См. основнойТип_ли
    template основнойТип_лиРеализ(T, U)
    {
        const основнойТип_лиРеализ = is( T == U );
    }

    // См. основнойТип_ли
    template основнойТип_лиРеализ(T, U, Us...)
    {
        static if( is( T == U ) )
            const основнойТип_лиРеализ = да;
        else
            const основнойТип_лиРеализ = основнойТип_лиРеализ!(T, Us);
    }

    // Определяет, является ли заданный тип одним из базовых типов.
    template основнойТип_ли(T)
    {
        const основнойТип_ли = основнойТип_лиРеализ!(T, ОсновныеТипы);
    }

    /*
     * Used в_ determine if we can cast a значение of the given ИнфОТипе в_ the
     * specified тип implicitly.  This should be somewhat faster than the
     * version in RuntimeTraits since we can basically eliminate half of the
     * tests.
     */
    бул неявноВТипПривестиМожно_ли(типЦелиШ)(ИнфОТипе типист)
    {
        /*
         * Before we do anything else, we need в_ "unwrap" typedefs в_
         * получи at the реал тип.  While we do that, сделай sure we don't
         * accопрentally jump over the destination тип.
         */
        while( cast(TypeInfo_Typedef) типист !is пусто )
        {
            if( типист is typeid(типЦелиШ) )
                return да;
            типист = типист.следщ;
        }

        /*
         * First, we'll generate tests for the basic типы.  The список of
         * things which can be cast TO basic типы is finite and easily
         * computed.
         */
        foreach( T ; ОсновныеТипы )
        {
            // If the current тип is the мишень...
            static if( is( типЦелиШ == T ) )
            {
                // ... then for все of the другой basic типы ...
                foreach( U ; ОсновныеТипы )
                {
                    static if
                    (
                        // ... if that тип is smaller than ...
                        U.sizeof < T.sizeof

                                   // ... or the same размер and signed-ness ...
                                   || ( U.sizeof == T.sizeof &&
                                        ((типСим_ли!(T) || типБЦел_ли!(T))
                                         ^ !(типСим_ли!(U) || типБЦел_ли!(U)))
                                      )
                                 )
                    {
                        // ... тест.
                        if( типист is typeid(U) )
                            return да;
                    }
                }
                // Nothing matched; no implicit casting.
                return нет;
            }
        }

        /*
         * Account for static массивы being implicitly convertible в_ dynamic
         * массивы.
         */
        static if( is( T[] : типЦелиШ ) )
        {
            if( typeid(T[]) is типист )
                return да;

            if( auto ti_sa = cast(TypeInfo_StaticArray) типист )
                return ti_sa.следщ is typeid(T);

            return нет;
        }

        /*
         * Any pointer can be cast в_ проц*.
         */
        static if( is( типЦелиШ == ук  ) )
            return (cast(TypeInfo_Pointer) типист) !is пусто;

        /*
         * Any Массив can be cast в_ проц[], however remember that it есть в_
         * be manually adjusted в_ preserve the correct length.
         */
        static if( is( типЦелиШ == void[] ) )
            return ((cast(TypeInfo_Array) типист) !is пусто)
            || ((cast(TypeInfo_StaticArray) типист) !is пусто);

        return нет;
    }

    /*
     * Выступает псевдонимом типа, используемого для возврата значения типа T из
     * функции. Как правило, это доработка, связанная с невозможностью возврата
     * статических массивов.
     */
    template возвратШ(T)
    {
        static if( типСтатМас_ли!(T) )
            alias typeof(T.dup) возвратШ;
        else
            alias T возвратШ;
    }

    /*
     * Here are some tests that выполни рантайм versions of the компилируй-время
     * traits functions.
     */

    бул иофБазовый_ли(ИнфОТипе ti)
    {
        foreach( T ; ОсновныеТипы )
        if( ti is typeid(T) )
            return да;
        return нет;
    }

    private import RuntimeTraits = runtimetraits;

    alias RuntimeTraits.статМасс_ли иофСтатМасс_ли;
    alias RuntimeTraits.класс_ли иофОбъект_ли;
    alias RuntimeTraits.интерфейс_ли иофИнтерфейс_ли;
}

/**
 * Это исключение выводится при попытке получить значение Варианта
 * с использованием несовместимого типа.
 */
class ИсклНесовпаденияВариантногоТипа : Исключение
{
    this(ИнфОТипе ожидалось, ИнфОТипе получено)
    {
        super("не удаётся преобразовать "~ожидалось.вТкст
              ~" значение в "~получено.вТкст);
    }
}

/**
 *  Это исключение выводится при попытке использовать пустой Вариант
 * с вариадическими аргументами.
 */
class ИсклПустойВариантСВарАрг : Исключение
{
    this()
    {
        super("нельзя использовать Варианты, содержащие проц с вараргами");
    }
}

/**
 * Тип Вариант используется для динамического сохранения значений различных типов
 * во время выполнения ( = в рантайм).
 *
 * Можно создавать Вариант, либо используя псевдоконструктор, либо прямым
 * присваиванием.
 *
 * -----
 *  Вариант знач = Вариант(42);
 *  знач = "abc";
 * -----
 */
struct Вариант
{
    /**
     * Этот псевдоконструктор используется для помещения значения в новый Вариант.
     *
     * Параметры:
     *  значение = Значение, которое требуется поместить в этот Вариант.
     *
     * Возвращает:
     *  Новый Вариант.
     *
     * Пример:
     * -----
     *  auto знач = Вариант(42);
     * -----
     */
    static Вариант opCall(T)(T значение)
    {
        Вариант _этот;

        static if( типСтатМас_ли!(T) )
            _этот = значение.dup;

        else
            _этот = значение;

        return _этот;
    }

    /**
     * Этот псевдоконструктор создаёт новый Вариант, используя заданный
     * ИнфОТипе и необр указатель на значение.
     *
     * Параметры:
     *  тип = Тип значения.
     *  ptr  = Указатель на значение.
     *
     * Возвращает:
     *  Новый Вариант.
     *
     * Пример:
     * -----
     *  цел жизнь = 42;
     *  auto знач = Вариант(typeid(typeof(жизнь)), &жизнь);
     * -----
     */
    static Вариант opCall()(ИнфОТипе тип, ук  укз)
    {
        Вариант _этот;
        Вариант.изУк(тип, укз, _этот);
        return _этот;
    }

    /**
     * Этот оператор позволяет присваивать произвольные значения напрямую в уже
     * существующий Вариант.
     *
     * Параметры:
     *  значение = Значение, помещаемое в этот Вариант.
     *
     * Возвращает:
     *  Новое значение, присвоенное варианту.
     *
     * Пример:
     * -----
     *  Вариант знач;
     *  знач = 42;
     * -----
     */
    Вариант opAssign(T)(T значение)
    {
        static if( типСтатМас_ли!(T) )
        {
            return (*this = значение.dup);
        }
        else
        {
            тип = typeid(T);

            static if( типДинМас_ли!(T) )
            {
                this.значение.установиМассив(значение.ptr, значение.length);
            }
            else static if( интерфейс_ли!(T) )
            {
                this.значение.об = cast(Объект) значение;
            }
            else
            {
                /*
                 * If the значение is small enough в_ fit in the хранилище
                 * available, do so.  If it isn't, then сделай a куча копируй.
                 *
                 * Obviously, this pretty clearly breaks значение semantics for
                 * large values, but without a postblit operator, there's not
                 * much we can do.  :(
                 */
                static if( T.sizeof <= this.значение.данные.length )
                {
                    this.значение.данные[0..T.sizeof] =
                    (cast(ббайт*)&значение)[0..T.sizeof];
                }
                else
                {
                    auto буфер = (cast(ббайт*)&значение)[0..T.sizeof].dup;
                    this.значение.куча = cast(проц[])буфер;
                }
            }
            return *this;
        }
    }

    /**
     * Это член можно использовать для определения того, хранится ли в варианте значение
     * указанного тип.  Заметьте, что это точное сравнение: косвенных
     * кастингов (переносов типа) оно не допускает.
     *
     * Возвращает:
     *  да, если этот Вариант содержит значение типа T, нет иначе.
     *
     * Пример:
     * -----
     *  auto знач = Вариант(cast(цел) 42);
     *  assert(   знач.является!(цел) );
     *  assert( ! знач.является!(крат) ); // note no implicit conversion
     * -----
     */
    бул является(T)()
    {
        return cast(бул)(typeid(T) is тип);
    }

    /**
     * Это член можно использовать для определения того, хранится ли в варианте значение
     * указанного тип. Это сравнение пытается принять правила косвенного преобразования
     * типов.
     *
     * Возвращает:
     *  да, если этот Вариант содержит значение типа T, или если этот Вариант
     *  содержит значение, которое может быть косвенно преобразовано в тип T; нет
     *  иначе.
     *
     * Пример:
     * -----
     *  auto знач = Вариант(cast(цел) 42);
     *  assert( знач.является!(цел) );
     *  assert( знач.является!(крат) ); // note implicit conversion
     * -----
     */
    бул косвенноЯвляется(T)()
    {
        static if( is( T == class ) || is( T == interface ) )
        {
            // Check for classes and interfaces first.
            if( cast(ИнфОТипе_Класс) тип || cast(ТипИнтерфейс) тип )
                return (cast(T) значение.об) !is пусто;

            else
                // We're trying в_ cast TO an объект, but we don't have
                // an объект stored.
                return нет;
        }
        else
        {
            // Test for basic типы (oh, and dynamic->static массивы and
            // pointers.)
            return ( cast(бул)(typeid(T) is тип)
                     || неявноВТипПривестиМожно_ли!(T)(тип) );
        }
    }

    /**
     * Определяет, есть ли у Варианта присвоенное значение. Это
     * упрощённое сокращение вызова члена "является" с типом проц.
     *
     * Возвращает:
     *  да, если этот Вариант не содержит значение, нет иначе.
     */
    бул пуст_ли()
    {
        return является!(проц);
    }

    /**
     * Этот член стирает Вариант, возвращая его в пустом состоянии.
     */
    проц сотри()
    {
        _тип = typeid(проц);
        значение = значение.init;
    }

    version( DDoc )
    {
        /**
         * Это первичный механизм для извлечения значения этого Варианта.
         * При указанном типе цели S, он будет пытаться извлечь значение
         * Варианта с преобразованиев в данный тип.  Если значение, содержимое в Варианте,
         * не может быть косвенно преобразовано в заданный тип S, тогда будет выведено
         * исключение.
         *
         * Можно выяснить, потерпит ли крушение данная операция, вызвав член
         * "косвенноЯвляется" с типом S.
         *
         * Заметьте, что при попытке получения статически размеренного массива будет возвращён
         * динаический массив; это языковое ограничение.
         *
         * Возвращает:
         *  Значение, сохранённое в этом Варианте.
         */
        T получи(T)()
        {
            // Реальная реализация находится ниже.
        }
    }
    else
    {
        возвратШ!(S) получи(S)()
        {
            alias возвратШ!(S) T;

            // If we're not dealing with the exact same тип as is being
            // stored, we краш NOW if the тип in question isn't an объект (we
            // can let the рантайм do the тест) and if it isn't something we
            // know we can implicitly cast в_.
            if( тип !is typeid(T)
                    // Let D do рантайм check itself
                    && !объект_ли!(T)
                    && !интерфейс_ли!(T)

                    // Разрешить implicit upcasts
                    && !неявноВТипПривестиМожно_ли!(T)(тип)
              )
                throw new ИсклНесовпаденияВариантногоТипа(тип,typeid(T));

            // Дескр basic типы, since they account for most of the implicit
            // casts.
            static if( основнойТип_ли!(T) )
            {
                if( тип is typeid(T) )
                {
                    // We got lucky; the типы match exactly.  If the тип is
                    // small, grab it out of хранилище; иначе, копируй it это
                    // the куча.
                    static if( T.sizeof <= значение.sizeof )
                                   return *cast(T*)(&значение);

                    else
                        return *cast(T*)(значение.куча.ptr);
                }
                else
                {
                    // This handles implicit coercion.  What it does is finds
                    // the basic тип U which is actually being stored.  It
                    // then unpacks the значение of тип U stored in the Вариант
                    // and casts it в_ тип T.
                    //
                    // It is assumed that this is valid в_ выполни since we
                    // should have already eliminated не_годится coercions.
                    foreach( U ; ОсновныеТипы )
                    {
                        if( тип is typeid(U) )
                        {
                            static if( U.sizeof <= значение.sizeof )
                                           return cast(T) *cast(U*)(&значение);

                            else
                                return cast(T) *cast(U*)(значение.куча.ptr);
                        }
                    }
                    throw new ИсклНесовпаденияВариантногоТипа(тип,typeid(T));
                }
            }
            else static if( типДинМас_ли!(T) )
            {
                return (cast(typeof(T.ptr)) значение.Массив.ptr)
                [0..значение.Массив.length];
            }
            else static if( объект_ли!(T) || интерфейс_ли!(T) )
            {
                return cast(T)this.значение.об;
            }
            else
            {
                static if( T.sizeof <= this.значение.данные.length )
                {
                    T результат;
                    (cast(ббайт*)&результат)[0..T.sizeof] =
                    this.значение.данные[0..T.sizeof];
                    return результат;
                }
                else
                {
                    T результат;
                    (cast(ббайт*)&результат)[0..T.sizeof] =
                    (cast(ббайт[])this.значение.куча)[0..T.sizeof];
                    return результат;
                }
            }
        }
    }

    /**
     * Следующие перегруженные операторы определены ради удобства.
     * Важно понимать, что они не позволяют использовать Вариант
     * как в левой, так и в правой части выражения. На одной стороне
     * оператора должен находится конкретный тип; тогда
     * Вариант в курсе, какой код нужно сгененрировать.
     */
    typeof(T+T) opAdd(T)(T правткт)
    {
        return получи!(T) + правткт;
    }
    typeof(T+T) opAdd_r(T)(T lhs)
    {
        return lhs + получи!(T);    /// описано ранее
    }
    typeof(T-T) opSub(T)(T правткт)
    {
        return получи!(T) - правткт;    /// описано ранее
    }
    typeof(T-T) opSub_r(T)(T lhs)
    {
        return lhs - получи!(T);    /// описано ранее
    }
    typeof(T*T) opMul(T)(T правткт)
    {
        return получи!(T) * правткт;    /// описано ранее
    }
    typeof(T*T) opMul_r(T)(T lhs)
    {
        return lhs * получи!(T);    /// описано ранее
    }
    typeof(T/T) opDiv(T)(T правткт)
    {
        return получи!(T) / правткт;    /// описано ранее
    }
    typeof(T/T) opDiv_r(T)(T lhs)
    {
        return lhs / получи!(T);    /// описано ранее
    }
    typeof(T%T) opMod(T)(T правткт)
    {
        return получи!(T) % правткт;    /// описано ранее
    }
    typeof(T%T) opMod_r(T)(T lhs)
    {
        return lhs % получи!(T);    /// описано ранее
    }
    typeof(T&T) opAnd(T)(T правткт)
    {
        return получи!(T) & правткт;    /// описано ранее
    }
    typeof(T&T) opAnd_r(T)(T lhs)
    {
        return lhs & получи!(T);    /// описано ранее
    }
    typeof(T|T) opOr(T)(T правткт)
    {
        return получи!(T) | правткт;    /// описано ранее
    }
    typeof(T|T) opOr_r(T)(T lhs)
    {
        return lhs | получи!(T);    /// описано ранее
    }
    typeof(T^T) opXor(T)(T правткт)
    {
        return получи!(T) ^ правткт;    /// описано ранее
    }
    typeof(T^T) opXor_r(T)(T lhs)
    {
        return lhs ^ получи!(T);    /// описано ранее
    }
    typeof(T<<T) opShl(T)(T правткт)
    {
        return получи!(T) << правткт;    /// описано ранее
    }
    typeof(T<<T) opShl_r(T)(T lhs)
    {
        return lhs << получи!(T);    /// описано ранее
    }
    typeof(T>>T) opShr(T)(T правткт)
    {
        return получи!(T) >> правткт;    /// описано ранее
    }
    typeof(T>>T) opShr_r(T)(T lhs)
    {
        return lhs >> получи!(T);    /// описано ранее
    }
    typeof(T>>>T) opUShr(T)(T правткт)
    {
        return получи!(T) >>> правткт;    /// описано ранее
    }
    typeof(T>>>T) opUShr_r(T)(T lhs)
    {
        return lhs >>> получи!(T);    /// описано ранее
    }
    typeof(T~T) opCat(T)(T правткт)
    {
        return получи!(T) ~ правткт;    /// описано ранее
    }
    typeof(T~T) opCat_r(T)(T lhs)
    {
        return lhs ~ получи!(T);    /// описано ранее
    }

    Вариант opAddAssign(T)(T значение)
    {
        return (*this = получи!(T) + значение);    /// описано ранее
    }
    Вариант opSubAssign(T)(T значение)
    {
        return (*this = получи!(T) - значение);    /// описано ранее
    }
    Вариант opMulAssign(T)(T значение)
    {
        return (*this = получи!(T) * значение);    /// описано ранее
    }
    Вариант opDivAssign(T)(T значение)
    {
        return (*this = получи!(T) / значение);    /// описано ранее
    }
    Вариант opModAssign(T)(T значение)
    {
        return (*this = получи!(T) % значение);    /// описано ранее
    }
    Вариант opAndAssign(T)(T значение)
    {
        return (*this = получи!(T) & значение);    /// описано ранее
    }
    Вариант opOrAssign(T)(T значение)
    {
        return (*this = получи!(T) | значение);    /// описано ранее
    }
    Вариант opXorAssign(T)(T значение)
    {
        return (*this = получи!(T) ^ значение);    /// описано ранее
    }
    Вариант opShlAssign(T)(T значение)
    {
        return (*this = получи!(T) << значение);    /// описано ранее
    }
    Вариант opShrAssign(T)(T значение)
    {
        return (*this = получи!(T) >> значение);    /// описано ранее
    }
    Вариант opUShrAssign(T)(T значение)
    {
        return (*this = получи!(T) >>> значение);    /// описано ранее
    }
    Вариант opCatAssign(T)(T значение)
    {
        return (*this = получи!(T) ~ значение);    /// описано ранее
    }

    /**
     * Следующие операторы можно использовать с вариантами с любой стороны.
     * Заметьте, что эти операторы не соблюдают стандартных правил
     * косвенных преобразований.
     */
    цел opEquals(T)(T правткт)
    {
        static if( is( T == Вариант ) )
            return опВариантРавен(правткт);

        else
            return получи!(T) == правткт;
    }

    /// описано ранее
    цел opCmp(T)(T правткт)
    {
        static if( is( T == Вариант ) )
            return опСравниВариант(правткт);
        else
        {
            auto lhs = получи!(T);
            return (lhs < правткт) ? -1 : (lhs == правткт) ? 0 : 1;
        }
    }

    /// описано ранее
    т_хэш toHash()
    {
        return тип.getHash(this.ptr);
    }
	
	alias toHash вХэш;

    /**
     * Возвращает ткст представление этого типа, сохранённое в этом
     * Варианте.
     *
     * Возвращает:
     *  Ткст представление этого типа, сохранённое в этом Варианте.
     */
    ткст вТкст()
    {
        return тип.вТкст;
    }
	alias вТкст toString;

    /**
     * Используется для получения ИнфОТипе для текущего сохранённого
     * значения.
     */
    ИнфОТипе тип()
    {
        return _тип;
    }

    /**
     * Используется для получения указателя на значение, сохранённое в
     * этом варианте.
     */
    ук  ptr()
    {
        if( тип.tsize <= значение.sizeof )
            return &значение;

        else
            return значение.куча.ptr;
    }
	
	alias ptr укз;

    version( РазрешитьВарарг )
    {
        /**
         * Преобразует список аргументов вариадической функции в Массив Вариантов.
         */
        static Вариант[] изВарарг(ИнфОТипе[] типы, спис_ва арги)
        {
            auto vs = new Вариант[](типы.length);

            foreach( i, ref знач ; vs )
            арги = Вариант.изУк(типы[i], арги, знач);

            return vs;
        }

        /// описано ранее
        static Вариант[] изВарарг(...)
        {
            return Вариант.изВарарг(_arguments, _argptr);
        }

        /**
         * Преобразует Массив Вариантов в список аргументов вариадической функции.
         *
         * Размещает память для сохранения аргументов; эту память можно
         * удалить, если имеется такое намерение и она более не понадобится.
         */
        static проц вВарарг(Вариант[] vars, out ИнфОТипе[] типы, out спис_ва арги)
        {
            // First up, compute the total amount of пространство we'll need.  While
            // we're at it, work out if any of the values we're storing have
            // pointers.  If they do, we'll need в_ tell the СМ.
            т_мера размер = 0;
            бул noptr = да;
            foreach( ref знач ; vars )
            {
                auto ti = знач.тип;
                размер += (ti.tsize + т_мера.sizeof-1) & ~(т_мера.sizeof-1);
                noptr = noptr && (ti.флаги & 2);
            }

            // Create the хранилище, and tell the СМ whether it needs в_ be scanned
            // or not.
            auto хранилище = new ббайт[размер];
            смУстАтр(cast(ук)хранилище.ptr, cast(ПАтрБлока)(
                                 (смДайАтр(хранилище.ptr) & ~ПАтрБлока.НеСканировать)
                                 | (noptr ? ПАтрБлока.НеСканировать : 0)));

            // Dump the variants преобр_в the хранилище.
            арги = хранилище.ptr;
            auto arg_temp = арги;

            типы = new ИнфОТипе[vars.length];

            foreach( i, ref знач ; vars )
            {
                типы[i] = знач.тип;
                arg_temp = знач.вУк(arg_temp);
            }
        }
    } // version( РазрешитьВарарг )

private:
    ИнфОТипе _тип = typeid(проц);
    ХранилищеВариантов значение;

    ИнфОТипе тип(ИнфОТипе знач)
    {
        return (_тип = знач);
    }

    /*
     * Creates a Вариант using a given ИнфОТипе and a проц*.  Возвращает the
     * given pointer adjusted for the следщ vararg.
     */
    static ук  изУк(ИнфОТипе тип, ук  укз, out Вариант r)
    {
        /*
         * This function basically duplicates the functionality of
         * opAssign, except that we can't generate код based on the
         * тип of the данные we're storing.
         */

        if( тип is typeid(проц) )
            throw new ИсклПустойВариантСВарАрг;

        r.тип = тип;

        if( иофСтатМасс_ли(тип) )
        {
            /*
             * Static массивы are passed by-значение; for example, if тип is
             * typeid(цел[4]), then укз is a pointer в_ 16 байты of память
             * (four 32-bit целыйs).
             *
             * It's possible that the память being pointed в_ is on the
             * stack, so we need в_ копируй it перед storing it.  тип.tsize
             * tells us exactly как many байты we need в_ копируй.
             *
             * Sadly, we can't directly construct the dynamic Массив version
             * of тип.  We'll сохрани the static Массив тип and cope with it
             * in косвенноЯвляется(S) and получи(S).
             */
            r.значение.куча = укз[0 .. тип.tsize].dup;
        }
        else
        {
            if( иофОбъект_ли(тип)
                    || иофИнтерфейс_ли(тип) )
            {
                /*
                 * We have в_ вызов преобр_в the core рантайм в_ turn this pointer
                 * преобр_в an actual Объект reference.
                 */
                r.значение.об = _d_toObject(*cast(проц**)укз);
            }
            else
            {
                if( тип.tsize <= this.значение.данные.length )
                {
                    // Copy преобр_в хранилище
                    r.значение.данные[0 .. тип.tsize] =
                        (cast(ббайт*)укз)[0 .. тип.tsize];
                }
                else
                {
                    // Store in куча
                    auto буфер = (cast(ббайт*)укз)[0 .. тип.tsize].dup;
                    r.значение.куча = cast(проц[])буфер;
                }
            }
        }

        // Compute the "advanced" pointer.
        return укз + ( (тип.tsize + т_мера.sizeof-1) & ~(т_мера.sizeof-1) );
    }

    version( РазрешитьВарарг )
    {
        /*
         * Takes the current Вариант, and dumps its contents преобр_в память pointed
         * at by a проц*, suitable for vararg calls.
         *
         * It also returns the supplied pointer adjusted by the размер of the данные
         * записано в_ память.
         */
        ук  вУк(ук  укз)
        {
            if( тип is typeid(проц) )
                throw new ИсклПустойВариантСВарАрг;

            if( иофСтатМасс_ли(тип) )
            {
                // Just dump straight
                укз[0 .. тип.tsize] = this.значение.куча[0 .. тип.tsize];
            }
            else
            {
                if( иофИнтерфейс_ли(тип) )
                {
                    /*
                     * This is tricky.  What we actually have stored in
                     * значение.об is an Объект, not an interface.  What we
                     * need в_ do is manually "cast" значение.об в_ the correct
                     * interface.
                     *
                     * We have the original interface's ИнфОТипе.  This gives us
                     * the interface's ИнфОКлассе.  We can also obtain the объект's
                     * ИнфОКлассе which содержит a список of Interfaces.
                     *
                     * So what we need в_ do is loop over the interfaces об
                     * реализует until we найди the one we're interested in.  Then
                     * we just читай out the interface's смещение and исправь об
                     * accordingly.
                     */
                    auto type_i = cast(ТипИнтерфейс) тип;
                    бул найдено = нет;
                    foreach( i ; this.значение.об.classinfo.interfaces )
                    {
                        if( i.classinfo is type_i.инфо )
                        {
                            // Найдено it
                            ук  i_ptr = (cast(проц*) this.значение.об) + i.смещение;
                            *cast(проц**)укз = i_ptr;
                            найдено = да;
                            break;
                        }
                    }
                    assert(найдено,"Не удалось преобразовать Объект в интерфейс; "
                           "что-то пошло не так.");
                }
                else
                {
                    if( тип.tsize <= this.значение.данные.length )
                    {
                        // Значение stored in хранилище
                        укз[0 .. тип.tsize] = this.значение.данные[0 .. тип.tsize];
                    }
                    else
                    {
                        // Значение stored on куча
                        укз[0 .. тип.tsize] = this.значение.куча[0 .. тип.tsize];
                    }
                }
            }

            // Compute the "advanced" pointer.
            return укз + ( (тип.tsize + т_мера.sizeof-1) & ~(т_мера.sizeof-1) );
        }
    } // version( РазрешитьВарарг )

    /**
     * Performs a тип-dependant сравнение.  Note that this obviously doesn't
     * take преобр_в account things like implicit conversions.
     */
    цел опВариантРавен(Вариант правткт)
    {
        if( тип != правткт.тип ) return нет;
        return cast(бул) тип.равны(this.ptr, правткт.ptr);
    }

    /**
     * Same as опВариантРавен except it does opCmp.
     */
    цел опСравниВариант(Вариант правткт)
    {
        if( тип != правткт.тип )
            throw new ИсклНесовпаденияВариантногоТипа(тип, правткт.тип);
        return тип.compare(this.ptr, правткт.ptr);
    }
}

debug( UnitTest )
{
    /*
     * Language tests.
     */

    unittest
    {
        {
            цел[2] a;
            проц[] b = a;
            цел[]  c = cast(цел[]) b;
            assert( b.length == 2*цел.sizeof );
            assert( c.length == a.length );
        }

        {
            struct A { т_мера l; ук  p; }
            ткст b = "123";
            A a = *cast(A*)(&b);

            assert( a.l == b.length );
            assert( a.p == b.ptr );
        }
    }

    /*
     * Basic tests.
     */

    unittest
    {
        Вариант знач;
        assert( знач.является!(проц), знач.тип.вТкст );
        assert( знач.пуст_ли, знач.тип.вТкст );

        // Test basic целое хранилище and implicit casting support
        знач = 42;
        assert( знач.является!(цел), знач.тип.вТкст );
        assert( знач.косвенноЯвляется!(дол), знач.тип.вТкст );
        assert( знач.косвенноЯвляется!(бдол), знач.тип.вТкст );
        assert( !знач.косвенноЯвляется!(бцел), знач.тип.вТкст );
        assert( знач.получи!(цел) == 42 );
        assert( знач.получи!(дол) == 42L );
        assert( знач.получи!(бдол) == 42uL );

        // Test clearing
        знач.сотри;
        assert( знач.является!(проц), знач.тип.вТкст );
        assert( знач.пуст_ли, знач.тип.вТкст );

        // Test strings
        знач = "Hello, World!"c;
        assert( знач.является!(ткст), знач.тип.вТкст );
        assert( !знач.косвенноЯвляется!(шим[]), знач.тип.вТкст );
        assert( знач.получи!(ткст) == "Hello, World!" );

        // Test Массив хранилище
        знач = [1,2,3,4,5];
        assert( знач.является!(цел[]), знач.тип.вТкст );
        assert( знач.получи!(цел[]) == [1,2,3,4,5] );

        // Make sure массивы are correctly stored so that .ptr works.
        {
            цел[] a = [1,2,3,4,5];
            знач = a;
            auto b = *cast(цел[]*)(знач.ptr);

            assert( a.ptr == b.ptr );
            assert( a.length == b.length );
        }

        // Test pointer хранилище
        знач = &знач;
        assert( знач.является!(Вариант*), знач.тип.вТкст );
        assert( !знач.косвенноЯвляется!(цел*), знач.тип.вТкст );
        assert( знач.косвенноЯвляется!(проц*), знач.тип.вТкст );
        assert( знач.получи!(Вариант*) == &знач );

        // Test объект хранилище
        {
            scope o = new Объект;
            знач = o;
            assert( знач.является!(Объект), знач.тип.вТкст );
            assert( знач.получи!(Объект) is o );
        }

        // Test interface support
        {
            interface A {}
interface B :
            A {}
            class C : B {}
            class D : C {}

            A a = new D;
            Вариант v2 = a;
            B b = v2.получи!(B);
            C c = v2.получи!(C);
            D d = v2.получи!(D);
        }

        // Test class/interface implicit casting
        {
            class G {}
            interface H {}
            class I : G {}
            class J : H {}
            struct К {}

            scope a = new G;
            scope c = new I;
            scope d = new J;
            К e;

            Вариант v2 = a;
            assert( v2.косвенноЯвляется!(Объект), v2.тип.вТкст );
            assert( v2.косвенноЯвляется!(G), v2.тип.вТкст );
            assert(!v2.косвенноЯвляется!(I), v2.тип.вТкст );

            v2 = c;
            assert( v2.косвенноЯвляется!(Объект), v2.тип.вТкст );
            assert( v2.косвенноЯвляется!(G), v2.тип.вТкст );
            assert( v2.косвенноЯвляется!(I), v2.тип.вТкст );

            v2 = d;
            assert( v2.косвенноЯвляется!(Объект), v2.тип.вТкст );
            assert(!v2.косвенноЯвляется!(G), v2.тип.вТкст );
            assert( v2.косвенноЯвляется!(H), v2.тип.вТкст );
            assert( v2.косвенноЯвляется!(J), v2.тип.вТкст );

            v2 = e;
            assert(!v2.косвенноЯвляется!(Объект), v2.тип.вТкст );
        }

        // Test doubles and implicit casting
        знач = 3.1413;
        assert( знач.является!(дво), знач.тип.вТкст );
        assert( знач.косвенноЯвляется!(реал), знач.тип.вТкст );
        assert( !знач.косвенноЯвляется!(плав), знач.тип.вТкст );
        assert( знач.получи!(дво) == 3.1413 );

        // Test хранилище transitivity
        auto u = Вариант(знач);
        assert( u.является!(дво), u.тип.вТкст );
        assert( u.получи!(дво) == 3.1413 );

        // Test operators
        знач = 38;
        assert( знач + 4 == 42 );
        assert( 4 + знач == 42 );
        assert( знач - 4 == 34 );
        assert( 4 - знач == -34 );
        assert( знач * 2 == 76 );
        assert( 2 * знач == 76 );
        assert( знач / 2 == 19 );
        assert( 2 / знач == 0 );
        assert( знач % 2 == 0 );
        assert( 2 % знач == 2 );
        assert( (знач & 6) == 6 );
        assert( (6 & знач) == 6 );
        assert( (знач | 9) == 47 );
        assert( (9 | знач) == 47 );
        assert( (знач ^ 5) == 35 );
        assert( (5 ^ знач) == 35 );
        assert( знач << 1 == 76 );
        assert( 1 << Вариант(2) == 4 );
        assert( знач >> 1 == 19 );
        assert( 4 >> Вариант(2) == 1 );

        assert( Вариант("abc") ~ "def" == "abcdef" );
        assert( "abc" ~ Вариант("def") == "abcdef" );

        // Test op= operators
        знач = 38;
        знач += 4;
        assert( знач == 42 );
        знач = 38;
        знач -= 4;
        assert( знач == 34 );
        знач = 38;
        знач *= 2;
        assert( знач == 76 );
        знач = 38;
        знач /= 2;
        assert( знач == 19 );
        знач = 38;
        знач %= 2;
        assert( знач == 0 );
        знач = 38;
        знач &= 6;
        assert( знач == 6 );
        знач = 38;
        знач |= 9;
        assert( знач == 47 );
        знач = 38;
        знач ^= 5;
        assert( знач == 35 );
        знач = 38;
        знач <<= 1;
        assert( знач == 76 );
        знач = 38;
        знач >>= 1;
        assert( знач == 19 );

        знач = "abc";
        знач ~= "def";
        assert( знач == "abcdef" );

        // Test сравнение
        assert( Вариант(0) < Вариант(42) );
        assert( Вариант(42) > Вариант(0) );
        assert( Вариант(21) == Вариант(21) );
        assert( Вариант(0) != Вариант(42) );
        assert( Вариант("bar") == Вариант("bar") );
        assert( Вариант("foo") != Вариант("bar") );

        // Test variants as AA ключи
        {
            auto v1 = Вариант(42);
            auto v2 = Вариант("foo");
            auto v3 = Вариант(1+2.0i);

            цел[Вариант] hash;
            hash[v1] = 0;
            hash[v2] = 1;
            hash[v3] = 2;

            assert( hash[v1] == 0 );
            assert( hash[v2] == 1 );
            assert( hash[v3] == 2 );
        }

        // Test AA хранилище
        {
            цел[ткст] hash;
            hash["a"] = 1;
            hash["b"] = 2;
            hash["c"] = 3;
            Вариант vhash = hash;

            assert( vhash.получи!(цел[ткст])["a"] == 1 );
            assert( vhash.получи!(цел[ткст])["b"] == 2 );
            assert( vhash.получи!(цел[ткст])["c"] == 3 );
        }
    }

    /*
     * Vararg tests.
     */

    version( РазрешитьВарарг )
    {
        private import tpl.args;

        unittest
        {
            class A
            {
                ткст сооб()
                {
                    return "A";
                }
            }
            class B : A
            {
                override ткст сооб()
                {
                    return "B";
                }
            }
            interface C
            {
                ткст имя();
            }
            class D : B, C
            {
                override ткст сооб()
                {
                    return "D";
                }
                override ткст имя()
                {
                    return "phil";
                }
            }

            struct S { цел a, b, c, d; }

            Вариант[] scoop(...)
            {
                return Вариант.изВарарг(_arguments, _argptr);
            }

            auto va_0 = cast(сим)  '?';
            auto va_1 = cast(крат) 42;
            auto va_2 = cast(цел)   1701;
            auto va_3 = cast(дол)  9001;
            auto va_4 = cast(плав) 3.14;
            auto va_5 = cast(дво)2.14;
            auto va_6 = cast(реал)  0.1;
            auto va_7 = "abcd"[];
            S    va_8 = { 1, 2, 3, 4 };
            A    va_9 = new A;
            B    va_a = new B;
            C    va_b = new D;
            D    va_c = new D;

            auto vs = scoop(va_0, va_1, va_2, va_3,
                            va_4, va_5, va_6, va_7,
                            va_8, va_9, va_a, va_b, va_c);

            assert( vs[0x0].получи!(typeof(va_0)) == va_0 );
            assert( vs[0x1].получи!(typeof(va_1)) == va_1 );
            assert( vs[0x2].получи!(typeof(va_2)) == va_2 );
            assert( vs[0x3].получи!(typeof(va_3)) == va_3 );
            assert( vs[0x4].получи!(typeof(va_4)) == va_4 );
            assert( vs[0x5].получи!(typeof(va_5)) == va_5 );
            assert( vs[0x6].получи!(typeof(va_6)) == va_6 );
            assert( vs[0x7].получи!(typeof(va_7)) == va_7 );
            assert( vs[0x8].получи!(typeof(va_8)) == va_8 );
            assert( vs[0x9].получи!(typeof(va_9)) is va_9 );
            assert( vs[0xa].получи!(typeof(va_a)) is va_a );
            assert( vs[0xb].получи!(typeof(va_b)) is va_b );
            assert( vs[0xc].получи!(typeof(va_c)) is va_c );

            assert( vs[0x9].получи!(typeof(va_9)).сооб == "A" );
            assert( vs[0xa].получи!(typeof(va_a)).сооб == "B" );
            assert( vs[0xc].получи!(typeof(va_c)).сооб == "D" );

            assert( vs[0xb].получи!(typeof(va_b)).имя == "phil" );
            assert( vs[0xc].получи!(typeof(va_c)).имя == "phil" );

            {
                ИнфОТипе[] типы;
                ук  арги;

                Вариант.вВарарг(vs, типы, арги);

                assert( типы[0x0] is typeid(typeof(va_0)) );
                assert( типы[0x1] is typeid(typeof(va_1)) );
                assert( типы[0x2] is typeid(typeof(va_2)) );
                assert( типы[0x3] is typeid(typeof(va_3)) );
                assert( типы[0x4] is typeid(typeof(va_4)) );
                assert( типы[0x5] is typeid(typeof(va_5)) );
                assert( типы[0x6] is typeid(typeof(va_6)) );
                assert( типы[0x7] is typeid(typeof(va_7)) );
                assert( типы[0x8] is typeid(typeof(va_8)) );
                assert( типы[0x9] is typeid(typeof(va_9)) );
                assert( типы[0xa] is typeid(typeof(va_a)) );
                assert( типы[0xb] is typeid(typeof(va_b)) );
                assert( типы[0xc] is typeid(typeof(va_c)) );

                auto ptr = арги;

                auto vb_0 = ва_арг!(typeof(va_0))(ptr);
                auto vb_1 = ва_арг!(typeof(va_1))(ptr);
                auto vb_2 = ва_арг!(typeof(va_2))(ptr);
                auto vb_3 = ва_арг!(typeof(va_3))(ptr);
                auto vb_4 = ва_арг!(typeof(va_4))(ptr);
                auto vb_5 = ва_арг!(typeof(va_5))(ptr);
                auto vb_6 = ва_арг!(typeof(va_6))(ptr);
                auto vb_7 = ва_арг!(typeof(va_7))(ptr);
                auto vb_8 = ва_арг!(typeof(va_8))(ptr);
                auto vb_9 = ва_арг!(typeof(va_9))(ptr);
                auto vb_a = ва_арг!(typeof(va_a))(ptr);
                auto vb_b = ва_арг!(typeof(va_b))(ptr);
                auto vb_c = ва_арг!(typeof(va_c))(ptr);

                assert( vb_0 == va_0 );
                assert( vb_1 == va_1 );
                assert( vb_2 == va_2 );
                assert( vb_3 == va_3 );
                assert( vb_4 == va_4 );
                assert( vb_5 == va_5 );
                assert( vb_6 == va_6 );
                assert( vb_7 == va_7 );
                assert( vb_8 == va_8 );
                assert( vb_9 is va_9 );
                assert( vb_a is va_a );
                assert( vb_b is va_b );
                assert( vb_c is va_c );

                assert( vb_9.сооб == "A" );
                assert( vb_a.сооб == "B" );
                assert( vb_c.сооб == "D" );

                assert( vb_b.имя == "phil" );
                assert( vb_c.имя == "phil" );
            }
        }
    }
}
