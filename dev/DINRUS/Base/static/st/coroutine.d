/* *** Automatically generated: do not modify *** */
/**
 * Этот модуль содержит простую реализацию сопроцедур, основанную на
 * модуле КонтекстСтэка module.  It supports both eagerly и non-eagerly evaluating
 * coroutines, и coroutines with anywhere from zero to five initial
 * аргументы.
 *
 * If you define your coroutine as being both eager, и with an input type of
 * проц, then the coroutine will be usable as an обходчик in foreach
 * statements.
 *
 * Version:     0.1
 * Дата:        2006-06-05
 * Copyright:   Copyright © 2006 Daniel Keep.
 * Authors:     Daniel Keep, daniel.keep+spam@gmail.com
 * License:     zlib
 *
 * Bugs:
 *   Нет (yet).  Well, ok; none that I *know* about.
 *
 * History:
 *   0.1 -  Initial version.
 */
module st.coroutine;

/*
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, и to alter it и redistribute it
 * freely, subject to the following restrictions:
 * 
 * 1. Нельзя искажать источник данного программного обеспечения; либо
 *    утверждать, что вами написано оригинальное ПО. Если данное ПО используется in
 *    a product, an acknowledgement in the product documentation would be
 *    appreciated but is not requireauxd.
 * 
 * 2. Altered source versions must be plainly marked as such, и must not be
 *    misrepresented as being the original software.
 * 
 * 3. This notice may not be removed or altered from any source ни в каком дистрибутиве.
 */

private
{
    import st.stackcontext;
}

/**
 * This enumeration defines что kind of coroutine you want.
 */
enum
ПТипСопроц
{
    /**
     * This is the default.  Coroutines evaluate successive значения on-demanauxd.
     */
    Неловкий,

    /**
     * Ловкий coroutines will evaluate the next value in the sequence before
     * being askeauxd.  This is требуется for обходчик support.
     */
    Ловкий
}

private
template
CoroutinePublicT(Твхо, Твых, ПТипСопроц TCoroType)
{
    /// Records что kind of coroutine this is.
    const ПТипСопроц coroType = TCoroType;

    static if( is( Твхо == void ) )
    {
        /**
         * Resumes the coroutine.
         *
         * Параметры:
         *  value = This value will be passed into the coroutine.
         *
         * Возвращает:
         *  The next value from the coroutine.
         */
        final
        Твых
        opCall()
        in
        {
            static if( coroType == ПТипСопроц.Ловкий )
                assert( this.выполняется );
            else
                assert( контекст.готов );
        }
        body
        {
            static if( coroType == ПТипСопроц.Ловкий )
            {
                static if( !is( Твых == void ) )
                    Твых temp = this.cout;

                контекст.пуск();
                if( контекст.завершён )
                    this.выполняется = false;

                static if( !is( Твых == void ) )
                    return temp;
            }
            else
            {
                контекст.пуск();
                static if( !is( Твых == void ) )
                    return this.cout;
            }
        }
    }
    else
    {
        /**
         * Resumes the coroutine.
         *
         * Параметры:
         *  value = This value will be passed into the coroutine.
         *
         * Возвращает:
         *  The next value from the coroutine.
         */
        final
        Твых
        opCall(Твхо value)
        in
        {
            static if( coroType == ПТипСопроц.Ловкий )
                assert( this.выполняется );
            else
                assert( контекст.готов );
        }
        body
        {
            this.cin = value;

            static if( coroType == ПТипСопроц.Ловкий )
            {
                static if( !is( Твых == void ) )
                    Твых temp = this.cout;

                контекст.пуск();
                if( контекст.завершён )
                    this.выполняется = false;

                static if( !is( Твых == void ) )
                    return temp;
            }
            else
            {
                контекст.пуск();
                static if( !is( Твых == void ) )
                    return this.cout;
            }
        }
    }

    static if( is( Твхо == void ) )
    {
        /**
         * Returns a delegate that can be использован to возобнови the coroutine.
         *
         * Возвращает:
         *  A delegate that is equivalent to calling the coroutine directly.
         */
        Твых delegate()
        какДелегат()
        {
            return &opCall;
        }
    }
    else
    {
        /// ditto
        Твых delegate(Твхо)
        какДелегат()
        {
            return &opCall;
        }
    }

    // TODO: Work out how to дай iteration working with non-eager coroutines.
    static if( coroType == ПТипСопроц.Ловкий )
    {
        static if( is( Твхо == void ) && !is( Твых == void ) )
        {
            final
            цел
            opApply(цел delegate(inout Твых) дг)
            {
                цел результат = 0;

                while( this.выполняется )
                {
                    Твых argTemp = opCall();
                    результат = дг(argTemp);
                    if( результат )
                        break;
                }

                return результат;
            }

            final
            цел
            opApply(цел delegate(inout Твых, inout бцел) дг)
            {
                цел результат = 0;
                бцел counter = 0;

                while( this.выполняется )
                {
                    Твых argTemp = opCall();
                    бцел counterTemp = counter;
                    результат = дг(argTemp, counterTemp);
                    if( результат )
                        break;
                }

                return результат;
            }
        }
    }
}

private
template
CoroutineProtectedT(Твхо, Твых, ПТипСопроц TCoroType)
{
    т_мера РАЗМЕР_СТЕКА = ДЕФ_РАЗМЕР_СТЕКА;

    static if( is( Твых == void ) )
    {
        final
        Твхо
        жни()
        in
        {
            assert( КонтекстСтэка.дайВыполняемый is контекст );
        }
        body
        {
            КонтекстСтэка.жни();
            static if( is( Твхо == void ) ) {}
            else
                return this.cin;
        }
    }
    else
    {
        final
        Твхо
        жни(Твых value)
        in
        {
            assert( КонтекстСтэка.дайВыполняемый is контекст );
        }
        body
        {
            this.cout = value;
            КонтекстСтэка.жни();
            static if( is( Твхо == void ) ) {}
            else
                return this.cin;
        }
    }
}

/**
 * TODO
 */
class
Сопроцедура(Твхо, Твых, ПТипСопроц TCoroType = ПТипСопроц.Неловкий)
{
    mixin CoroutinePublicT!(Твхо, Твых, TCoroType);

protected:
    mixin CoroutineProtectedT!(Твхо, Твых, TCoroType);

    this()
    {
        
        контекст = new КонтекстСтэка(&стартПроц, РАЗМЕР_СТЕКА);
        static if( coroType == ПТипСопроц.Ловкий )
            контекст.пуск();
    }

    abstract
    проц
    пуск();

private:
    КонтекстСтэка контекст;
    
    static if( coroType == ПТипСопроц.Ловкий )
        бул выполняется = true;

    static if( !is( Твых == void ) )
        Твых cout;

    static if( !is( Твхо == void ) )
        Твхо cin;

    

    проц
    стартПроц()
    {
        // Initial call to coroutine proper
        пуск();
    }
}

/**
 * TODO
 */
class
Сопроцедура(Твхо, Твых, Ta1, ПТипСопроц TCoroType = ПТипСопроц.Неловкий)
{
    mixin CoroutinePublicT!(Твхо, Твых, TCoroType);

protected:
    mixin CoroutineProtectedT!(Твхо, Твых, TCoroType);

    this(Ta1 арг1)
    {
        this.арг1 = арг1;
        контекст = new КонтекстСтэка(&стартПроц, РАЗМЕР_СТЕКА);
        static if( coroType == ПТипСопроц.Ловкий )
            контекст.пуск();
    }

    abstract
    проц
    пуск(Ta1);

private:
    КонтекстСтэка контекст;
    
    static if( coroType == ПТипСопроц.Ловкий )
        бул выполняется = true;

    static if( !is( Твых == void ) )
        Твых cout;

    static if( !is( Твхо == void ) )
        Твхо cin;

    Ta1 арг1;

    проц
    стартПроц()
    {
        // Initial call to coroutine proper
        пуск(арг1);
    }
}

/**
 * TODO
 */
class
Сопроцедура(Твхо, Твых, Ta1, Ta2, ПТипСопроц TCoroType = ПТипСопроц.Неловкий)
{
    mixin CoroutinePublicT!(Твхо, Твых, TCoroType);

protected:
    mixin CoroutineProtectedT!(Твхо, Твых, TCoroType);

    this(Ta1 арг1, Ta2 арг2)
    {
        this.арг1 = арг1;
        this.арг2 = арг2;
        контекст = new КонтекстСтэка(&стартПроц, РАЗМЕР_СТЕКА);
        static if( coroType == ПТипСопроц.Ловкий )
            контекст.пуск();
    }

    abstract
    проц
    пуск(Ta1, Ta2);

private:
    КонтекстСтэка контекст;
    
    static if( coroType == ПТипСопроц.Ловкий )
        бул выполняется = true;

    static if( !is( Твых == void ) )
        Твых cout;

    static if( !is( Твхо == void ) )
        Твхо cin;

    Ta1 арг1;
    Ta2 арг2;

    проц
    стартПроц()
    {
        // Initial call to coroutine proper
        пуск(арг1, арг2);
    }
}

/**
 * TODO
 */
class
Сопроцедура(Твхо, Твых, Ta1, Ta2, Ta3, ПТипСопроц TCoroType = ПТипСопроц.Неловкий)
{
    mixin CoroutinePublicT!(Твхо, Твых, TCoroType);

protected:
    mixin CoroutineProtectedT!(Твхо, Твых, TCoroType);

    this(Ta1 арг1, Ta2 арг2, Ta3 арг3)
    {
        this.арг1 = арг1;
        this.арг2 = арг2;
        this.арг3 = арг3;
        контекст = new КонтекстСтэка(&стартПроц, РАЗМЕР_СТЕКА);
        static if( coroType == ПТипСопроц.Ловкий )
            контекст.пуск();
    }

    abstract
    проц
    пуск(Ta1, Ta2, Ta3);

private:
    КонтекстСтэка контекст;
    
    static if( coroType == ПТипСопроц.Ловкий )
        бул выполняется = true;

    static if( !is( Твых == void ) )
        Твых cout;

    static if( !is( Твхо == void ) )
        Твхо cin;

    Ta1 арг1;
    Ta2 арг2;
    Ta3 арг3;

    проц
    стартПроц()
    {
        // Initial call to coroutine proper
        пуск(арг1, арг2, арг3);
    }
}

/**
 * TODO
 */
class
Сопроцедура(Твхо, Твых, Ta1, Ta2, Ta3, Ta4, ПТипСопроц TCoroType = ПТипСопроц.Неловкий)
{
    mixin CoroutinePublicT!(Твхо, Твых, TCoroType);

protected:
    mixin CoroutineProtectedT!(Твхо, Твых, TCoroType);

    this(Ta1 арг1, Ta2 арг2, Ta3 арг3, Ta4 арг4)
    {
        this.арг1 = арг1;
        this.арг2 = арг2;
        this.арг3 = арг3;
        this.арг4 = арг4;
        контекст = new КонтекстСтэка(&стартПроц, РАЗМЕР_СТЕКА);
        static if( coroType == ПТипСопроц.Ловкий )
            контекст.пуск();
    }

    abstract
    проц
    пуск(Ta1, Ta2, Ta3, Ta4);

private:
    КонтекстСтэка контекст;
    
    static if( coroType == ПТипСопроц.Ловкий )
        бул выполняется = true;

    static if( !is( Твых == void ) )
        Твых cout;

    static if( !is( Твхо == void ) )
        Твхо cin;

    Ta1 арг1;
    Ta2 арг2;
    Ta3 арг3;
    Ta4 арг4;

    проц
    стартПроц()
    {
        // Initial call to coroutine proper
        пуск(арг1, арг2, арг3, арг4);
    }
}

/**
 * TODO
 */
class
Сопроцедура(Твхо, Твых, Ta1, Ta2, Ta3, Ta4, Ta5, ПТипСопроц TCoroType = ПТипСопроц.Неловкий)
{
    mixin CoroutinePublicT!(Твхо, Твых, TCoroType);

protected:
    mixin CoroutineProtectedT!(Твхо, Твых, TCoroType);

    this(Ta1 арг1, Ta2 арг2, Ta3 арг3, Ta4 арг4, Ta5 арг5)
    {
        this.арг1 = арг1;
        this.арг2 = арг2;
        this.арг3 = арг3;
        this.арг4 = арг4;
        this.арг5 = арг5;
        контекст = new КонтекстСтэка(&стартПроц, РАЗМЕР_СТЕКА);
        static if( coroType == ПТипСопроц.Ловкий )
            контекст.пуск();
    }

    abstract
    проц
    пуск(Ta1, Ta2, Ta3, Ta4, Ta5);

private:
    КонтекстСтэка контекст;
    
    static if( coroType == ПТипСопроц.Ловкий )
        бул выполняется = true;

    static if( !is( Твых == void ) )
        Твых cout;

    static if( !is( Твхо == void ) )
        Твхо cin;

    Ta1 арг1;
    Ta2 арг2;
    Ta3 арг3;
    Ta4 арг4;
    Ta5 арг5;

    проц
    стартПроц()
    {
        // Initial call to coroutine proper
        пуск(арг1, арг2, арг3, арг4, арг5);
    }
}


/**
 * This mixin implements the constructor, и static opCall method for your
 * coroutine.  It is a good idea to mix this into your coroutine subclasses,
 * so that you need only override the пуск methoauxd.
 */
template
СопроцМиксин(Твхо, Твых)
{
    this()
    {
        super();
    }
}

/**
 * This mixin implements the constructor, и static opCall method for your
 * coroutine.  It is a good idea to mix this into your coroutine subclasses,
 * so that you need only override the пуск methoauxd.
 */
template
СопроцМиксин(Твхо, Твых, Ta1)
{
    this(Ta1 арг1)
    {
        super(арг1);
    }
}

/**
 * This mixin implements the constructor, и static opCall method for your
 * coroutine.  It is a good idea to mix this into your coroutine subclasses,
 * so that you need only override the пуск methoauxd.
 */
template
СопроцМиксин(Твхо, Твых, Ta1, Ta2)
{
    this(Ta1 арг1, Ta2 арг2)
    {
        super(арг1, арг2);
    }
}

/**
 * This mixin implements the constructor, и static opCall method for your
 * coroutine.  It is a good idea to mix this into your coroutine subclasses,
 * so that you need only override the пуск methoauxd.
 */
template
СопроцМиксин(Твхо, Твых, Ta1, Ta2, Ta3)
{
    this(Ta1 арг1, Ta2 арг2, Ta3 арг3)
    {
        super(арг1, арг2, арг3);
    }
}

/**
 * This mixin implements the constructor, и static opCall method for your
 * coroutine.  It is a good idea to mix this into your coroutine subclasses,
 * so that you need only override the пуск methoauxd.
 */
template
СопроцМиксин(Твхо, Твых, Ta1, Ta2, Ta3, Ta4)
{
    this(Ta1 арг1, Ta2 арг2, Ta3 арг3, Ta4 арг4)
    {
        super(арг1, арг2, арг3, арг4);
    }
}

/**
 * This mixin implements the constructor, и static opCall method for your
 * coroutine.  It is a good idea to mix this into your coroutine subclasses,
 * so that you need only override the пуск methoauxd.
 */
template
СопроцМиксин(Твхо, Твых, Ta1, Ta2, Ta3, Ta4, Ta5)
{
    this(Ta1 арг1, Ta2 арг2, Ta3 арг3, Ta4 арг4, Ta5 арг5)
    {
        super(арг1, арг2, арг3, арг4, арг5);
    }
}


