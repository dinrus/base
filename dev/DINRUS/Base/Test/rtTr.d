﻿import core.RuntimeTraits;
import stdrus: фм, скажинс, пауза;

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
        цел foo (цел и)
        {
            return и;
        }
    }

    struct S1
    {
    }

    цел t1() {
        // Struct-related stuff.
        auto тип = cast(ИнфОТипе) typeid(S1);
        if(структ_ли (тип)) скажинс("структура"); else скажинс("не структура");
        if (типЗначение_ли (тип))скажинс("значение"); else скажинс("не значение");
        if (пользовательскТип_ли (тип))скажинс("пользовательский"); else скажинс("непользовательский");
        if (!класс_ли (тип))скажинс("класс"); else скажинс("не класс");
        if (!указатель_ли (тип))скажинс("указатель"); else скажинс("не указатель");
        if (пусто is типВозврат (тип))скажинс("возврата нет (пусто)"); else скажинс("возврат есть");
        if (!примитив_ли (тип))скажинс("примитив"); else скажинс("неверно");
        if (типЗначение (тип) is пусто)скажинс("тип значения не фиксирован"); else скажинс("тип значения фиксирован");
		return 0;
    }

    цел t2()  {
        auto тип = A.classinfo;
        if (типыОсновы (тип) == [Объект.classinfo])скажинс("объект"); else скажинс("не объект");
        if (классыОсновы (тип) == [Объект.classinfo])скажинс("класс"); else скажинс("не класс");
        if (интерфейсыОсновы (тип).length == 0)скажинс("без интерфейсов"); else скажинс("с интерфейсами");
        тип = C.classinfo;
        if (классыОсновы (тип) == [B.classinfo, A.classinfo, Объект.classinfo])скажинс("есть классы-основы"); else скажинс("не наследует");
        if (интерфейсыОсновы (тип) == [I2.classinfo, I3.classinfo, I1.classinfo])скажинс("есть интерфесы-основы"); else скажинс("нет интерфейсов-основ");
        if (типыОсновы (тип) == [B.classinfo, A.classinfo, Объект.classinfo, I2.classinfo, I3.classinfo,
                I1.classinfo])скажинс("типы-основы указаны верно"); else скажинс("неверно");
			return 0;
    }

    цел t3()  {
        if (указатель_ли (typeid(S1*)))скажинс("указатель"); else скажинс("не указатель");
        if (массив_ли (typeid(S1[])))скажинс("массив"); else скажинс("не массив");
        if (типЗначение (typeid(S1*)) is typeid(S1))скажинс("тип значения верно"); else скажинс("тип значения неверно");
        auto d = new D;
        if (типВозврат (typeid(typeof(&d.foo))) is typeid(цел))скажинс("тип возврата верно"); else скажинс("тип возврата неверно");
        if (плав_ли (typeid(реал)))скажинс("да, реал плав"); else скажинс("нет, реал не плав");
        if (плав_ли (typeid(дво)))скажинс("да, дво плав"); else скажинс("нет, дво не плав");
        if (плав_ли (typeid(плав)))скажинс("да, плав плав"); else скажинс("нет, плав не плав");
        if (!плав_ли (typeid(креал)))скажинс("да, креал не плав"); else скажинс("нет, креал плав");
        if (!плав_ли (typeid(кдво)))скажинс("да, кдво не плав"); else скажинс("нет, кдво плав");
        if (!цел_ли (typeid(плав)))скажинс("да, плав не целый"); else скажинс("нет, плав целый");
        if (!цел_ли (typeid(креал)))скажинс("верно, креал не целый"); else скажинс("неверно, креал целый");
        if (цел_ли (typeid(бдол)))скажинс("верно, бдол целый"); else скажинс("неверно, бдол не целый");
        if (цел_ли (typeid(ббайт)))скажинс("верно, ббайт целый"); else скажинс("неверно, ббайт не целый");
        if (символ_ли (typeid(сим)))скажинс("верно, сим символ"); else скажинс("неверно, сим не символ");
        if (символ_ли (typeid(шим)))скажинс("верно, шим символ"); else скажинс("неверно, шим не символ");
        if (символ_ли (typeid(дим)))скажинс("верно, дим символ"); else скажинс("неверно, дим не символ");
        if (!символ_ли (typeid(ббайт)))скажинс("верно, ббайт не символ"); else скажинс("неверно, ббайт символ");
        if (массив_ли (typeid(typeof("hello"))))скажинс("верно, hello массив"); else скажинс("неверно, hello не массив");
        if (символ_ли (typeid(typeof("hello"[0]))))скажинс("верно, \"hello\"[0] символ\"hello\"[0] символ"); else скажинс("неверно, \"hello\"[0] не символ");
        if (типЗначение (typeid(typeof("hello"))) is typeid(typeof('h')))скажинс("верно"); else скажинс("неверно");
       // if (ткст_ли (typeid(typeof("hello"))), typeof("hello").stringof)скажинс("верно"); else скажинс("неверно");
        auto staticString = typeid(typeof("hello"d));
        auto dynamicString = typeid(typeof("hello"d[0 .. $]));
        if (ткст_ли (staticString))скажинс("верно"); else скажинс("неверно");
        if (статМасс_ли (staticString))скажинс("верно"); else скажинс("неверно");
        if (динМасс_ли (dynamicString), dynamicString.вТкст () ~ dynamicString.classinfo.name)скажинс("верно"); else скажинс("неверно");
        if (ткст_ли (dynamicString))скажинс("верно"); else скажинс("неверно");

        auto тип = typeid(цел[сим[]]);
        if (типЗначение (тип) is typeid(цел), типЗначение (тип).вТкст ())скажинс("верно"); else скажинс("неверно");
        if (типКлюч (тип) is typeid(сим[]), типКлюч (тип).вТкст ())скажинс("верно"); else скажинс("неверно");
        проц delegate (цел) дг = (цел и)
        {
        };
        if (типВозврат (typeid(typeof(дг))) is typeid(проц))скажинс("верно"); else скажинс("неверно");
        if (типВозврат (typeid(цел delegate (цел))) is typeid(цел))скажинс("верно"); else скажинс("неверно");

        if (!динМасс_ли (typeid(цел[4])))скажинс("верно"); else скажинс("неверно");
        if (статМасс_ли (typeid(цел[4])))скажинс("верно"); else скажинс("неверно");
		return 0;
    }

    цел t4()  {
        typedef цел myint;
        //if (typeid(myint) !is пусто, "null typeid(myint)")скажинс("верно"); else скажинс("неверно");
        if (цел_ли (typeid(myint)))скажинс("верно"); else скажинс("неверно");
		return 0;
    }

цел main()
{
 скажинс("\nПЕРВЫЙ ТЕСТ"); t1();эхо("OK\n\n"); 
 скажинс("\nВТОРОЙ ТЕСТ"); t2();эхо("OK\n\n");
 скажинс("\nТРЕТИЙ ТЕСТ"); t3();эхо("OK\n\n");
 скажинс("\nЧЕТВЁРТЫЙ ТЕСТ"); t4(); эхо("OK\n\n");
 пауза;
 return 0;
}
