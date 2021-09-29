/** 
 * Предоставляет рантаймные трэты, представляющие большую часть функционала Traits и
 * is-Выражениеs, а также некоторый функционал, доступный только в рантайм, использующий 
 * рантаймную информацио о типах. 
 * 
 * Authors: Chris Wright (dhasenan) <dhasenan@gmail.com>
 * License: DinrusTango.lib license, apache 2.0
 * Copyright (c) 2009, CHRISTOPHER WRIGHT
 */
module runtimetraits;

extern(D):

/// If the given тип represents a typedef, return the actual тип.
ИнфОТипе реальныйТип (ИнфОТипе тип);

/// If the given тип represents a class, return its ИнфОКлассе; else return пусто;
ИнфОКлассе какКласс (ИнфОТипе тип);

/** Возвращает да iff one тип is an ancestor of the другой, or if the типы are the same.
 * If either is пусто, returns нет. */
бул производный_ли (ИнфОКлассе производный, ИнфОКлассе основа);

/** Возвращает да iff реализатор реализует the interface described
 * by ифейс. This is an expensive operation (linear in the число of
 * interfaces and основа classes).
 */
бул реализует (ИнфОКлассе реализатор, ИнфОКлассе ифейс);

/** Возвращает да iff an экземпляр of class тест is implicitly castable в_ мишень. 
 * This is an expensive operation (производный_ли + реализует). */
бул непосредственно_ли (ИнфОКлассе тест, ИнфОКлассе мишень);

/** Возвращает да iff an экземпляр of тип тест is implicitly castable в_ мишень. 
 * If the типы describe classes or interfaces, this is an expensive operation. */
бул непосредственно_ли (ИнфОТипе тест, ИнфОТипе мишень);

///
ИнфОКлассе[] классыОсновы (ИнфОКлассе тип);

/** Возвращает список of все interfaces that this тип реализует, directly
 * or indirectly. This включает основа interfaces of типы the class реализует,
 * and interfaces that основа classes implement, and основа interfaces of interfaces
 * that основа classes implement. This is an expensive operation. */
ИнфОКлассе[] интерфейсыОсновы (ИнфОКлассе тип);

/** Возвращает все the interfaces that this тип directly реализует, включая
 * inherited interfaces. This is an expensive operation.
 * 
 * Examples:
 * ---
 * interface I1 {}
 * interface I2 : I1 {}
 * class A : I2 {}
 * 
 * auto interfaces = графИнтерфейсов (A.classinfo);
 * // interfaces = [I1.classinfo, I2.classinfo]
 * --- 
 * 
 * ---
 * interface I1 {}
 * interface I2 {}
 * class A : I1 {}
 * class B : A, I2 {}
 * 
 * auto interfaces = графИнтерфейсов (B.classinfo);
 * // interfaces = [I2.classinfo]
 * ---
 */
ИнфОКлассе[] графИнтерфейсов (ИнфОКлассе тип);

/** Iterate through все interfaces that тип реализует, directly or indirectly, включая основа interfaces. */
struct примениИнтерфейсы
{
    ///
    static примениИнтерфейсы opCall (ИнфОКлассе тип);

    ///
    цел opApply (цел delegate (ref ИнфОКлассе) дг);

    ИнфОКлассе тип;
}

///
ИнфОКлассе[] типыОсновы (ИнфОКлассе тип);

///
ИнфОМодуле модульИз (ИнфОКлассе тип);

/// Возвращает список of interfaces that this class directly реализует.
ИнфОКлассе[] прямыеИнтерфейсы (ИнфОКлассе тип);

/** Возвращает список of все типы that are производный из_ the given тип. This does not 
 * счёт interfaces; that is, if тип is an interface, you will only получи производный 
 * interfaces back. It is an expensive operations. */
ИнфОКлассе[] производныеТипы (ИнфОКлассе тип);

///
бул динМасс_ли (ИнфОТипе тип);

///
бул статМасс_ли (ИнфОТипе тип);

/** Возвращает да iff the given тип is a dynamic or static Массив (нет for associative
 * массивы and non-массивы). */
бул массив_ли (ИнфОТипе тип);

///
бул ассоцМасс_ли (ИнфОТипе тип);

///
бул символ_ли (ИнфОТипе тип);

///
бул ткст_ли (ИнфОТипе тип);

///
бул беззначЦел_ли (ИнфОТипе тип);

///
бул значЦел_ли (ИнфОТипе тип);

///
бул цел_ли (ИнфОТипе тип);

///
бул бул_ли (ИнфОТипе тип);

///
бул плав_ли (ИнфОТипе тип);

///
бул примитив_ли (ИнфОТипе тип);

/// Возвращает да iff the given тип represents an interface.
бул интерфейс_ли (ИнфОТипе тип);

///
бул указатель_ли (ИнфОТипе тип);

/// Возвращает да iff the тип represents a class (нет for interfaces).
бул класс_ли (ИнфОТипе тип);

///
бул структ_ли (ИнфОТипе тип);

///
бул функция_ли (ИнфОТипе тип);

/** Возвращает да iff the given тип is a reference тип. */
бул типСсылка_ли (ИнфОТипе тип);

/** Возвращает да iff the given тип represents a пользовательский тип. 
 * This does not include functions, delegates, aliases, or typedefs. */
бул пользовательскТип_ли (ИнфОТипе тип);

/** Возвращает да for все значение типы, нет for все reference типы.
 * For functions and delegates, returns нет (is this the way it should be?). */
бул типЗначение_ли (ИнфОТипе тип);

/** The ключ тип of the given тип. For an Массив, т_мера; for an associative
 * Массив T[U], U. */
ИнфОТипе типКлюч (ИнфОТипе тип);

/** The значение тип of the given тип -- given T[] or T[n], T; given T[U],
 * T; given T*, T; anything else, пусто. */
ИнфОТипе типЗначение (ИнфОТипе тип);

/** If the given тип represents a delegate or function, the return тип
 * of that function. Otherwise, пусто. */
ИнфОТипе типВозврат (ИнфОТипе тип);

debug (UnitTest)
{

    interface I1
    {
    }

    interface I2
    {
    }

    interface I3
    {
    }

    interface I4
    {
    }

    class A
    {
    }

    class B : A, I1
    {
    }

    class C : B, I2, I3
    {
    }

    class D : A, I1
    {
        цел foo (цел i)
        {
            return i;
        }
    }

    struct S1
    {
    }

    unittest {
        // Struct-related stuff.
        auto тип = typeid(S1);
        assert (структ_ли (тип));
        assert (типЗначение_ли (тип));
        assert (пользовательскТип_ли (тип));
        assert (!класс_ли (тип));
        assert (!указатель_ли (тип));
        assert (пусто is типВозврат (тип));
        assert (!примитив_ли (тип));
        assert (типЗначение (тип) is пусто);
    }

    unittest {
        auto тип = A.classinfo;
        assert (типыОсновы (тип) == [Объект.classinfo]);
        assert (классыОсновы (тип) == [Объект.classinfo]);
        assert (интерфейсыОсновы (тип).length == 0);
        тип = C.classinfo;
        assert (классыОсновы (тип) == [B.classinfo, A.classinfo, Объект.classinfo]);
        assert (интерфейсыОсновы (тип) == [I2.classinfo, I3.classinfo, I1.classinfo]);
        assert (типыОсновы (тип) == [B.classinfo, A.classinfo, Объект.classinfo, I2.classinfo, I3.classinfo,
                I1.classinfo]);
    }

    unittest {
        assert (указатель_ли (typeid(S1*)));
        assert (массив_ли (typeid(S1[])));
        assert (типЗначение (typeid(S1*)) is typeid(S1));
        auto d = new D;
        assert (типВозврат (typeid(typeof(&d.foo))) is typeid(цел));
        assert (плав_ли (typeid(реал)));
        assert (плав_ли (typeid(дво)));
        assert (плав_ли (typeid(плав)));
        assert (!плав_ли (typeid(креал)));
        assert (!плав_ли (typeid(кдво)));
        assert (!цел_ли (typeid(плав)));
        assert (!цел_ли (typeid(креал)));
        assert (цел_ли (typeid(бдол)));
        assert (цел_ли (typeid(ббайт)));
        assert (символ_ли (typeid(сим)));
        assert (символ_ли (typeid(шим)));
        assert (символ_ли (typeid(дим)));
        assert (!символ_ли (typeid(ббайт)));
        assert (массив_ли (typeid(typeof("hello"))));
        assert (символ_ли (typeid(typeof("hello"[0]))));
        assert (типЗначение (typeid(typeof("hello"))) is typeid(typeof('h')));
        assert (ткст_ли (typeid(typeof("hello"))), typeof("hello").stringof);
        auto staticString = typeid(typeof("hello"d));
        auto dynamicString = typeid(typeof("hello"d[0 .. $]));
        assert (ткст_ли (staticString));
        assert (статМасс_ли (staticString));
        assert (динМасс_ли (dynamicString), dynamicString.вТкст () ~ dynamicString.classinfo.имя);
        assert (ткст_ли (dynamicString));

        auto тип = typeid(цел[ткст]);
        assert (типЗначение (тип) is typeid(цел), типЗначение (тип).вТкст ());
        assert (типКлюч (тип) is typeid(ткст), типКлюч (тип).вТкст ());
        проц delegate (цел) дг = (цел i)
        {
        };
        assert (типВозврат (typeid(typeof(дг))) is typeid(проц));
        assert (типВозврат (typeid(цел delegate (цел))) is typeid(цел));

        assert (!динМасс_ли (typeid(цел[4])));
        assert (статМасс_ли (typeid(цел[4])));
    }

    unittest {
        typedef цел myint;
        assert (typeid(myint) !is пусто, "пусто typeid(myint)");
        assert (цел_ли (typeid(myint)));
    }

}
