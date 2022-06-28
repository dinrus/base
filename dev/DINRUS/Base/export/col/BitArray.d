﻿/**
 * Этот модуль содержит реализацию упакованного Массива бит в стиле
 * встроенных в Ди динамических массивов.
 */
module col.BitArray;


private import std.intrinsic;


/**
 * Эта структура представляет Массив из булевых значений, каждое из которых занимает
 * при сохранении один бит памяти. Таким образом Массив из 32-х бит занимает такое же
 * пространство, как одно целое значение. Типичные операции с массивами--такие как
 * индексирование и сортировка -- поддерживаются, также как и побитовые операции,
 * такие как and, or, xor и complement.
 */
export struct МассивБит
{
    т_мера  длин;
    бцел*   ptr;


    /**
     * Инициализует МассивБит из "биты.length"" бит, где каждое значение бита
     * совпадает с соответствующим булевым значением в "биты".
     *
     * Параметры:
     *  биты = Значение при инициализации.
     *
     * Возвращает:
     *  МассивБит с таким же числом и последовательностью элементов, как у "биты".
     */
    static МассивБит opCall( бул[] биты );

    /**
     * Получить число битов в этом Массиве.
     *
     * Возвращает:
     *  Число битов в данном Массиве.
     */
    т_мера длина();


    /**
     * Изменяет размер данного Массива на новдлин бит. 
     * Если новдлин больше, чем текущая
     * длина, то новые биты будут инициализованы в ноль.
     *
     * Параметры:
     *  новдлин = Число  битов, которое должен содержать данный Массив.
     */
    проц длина( т_мера новдлин );


    /**
     * Выводит длину бцел Массива, достаточную для содержания всех сохранённых битов.
     *
     * Возвращает:
     *  Размер бцел Массива, который должен быть для сохранения this Массива.
     */
    т_мера цразм();

    /**
     * Дублирует this Массив, подобно свойству dup у встроенных массивов.
     *
     * Возвращает:
     *  Дубликат этого Массива.
     */
    МассивБит dup();


    debug( UnitTest )
    {
        unittest
        {
            МассивБит a;
            МассивБит b;

            a.длина = 3;
            a[0] = 1;
            a[1] = 0;
            a[2] = 1;
            b = a.dup;
            assert( b.длина == 3 );
            for( цел i = 0; i < 3; ++i )
            {
                assert( b[i] == (((i ^ 1) & 1) ? да : нет) );
            }
        }
    }


    /**
     * Переустанавливает длину данного массива на биты.длина, затем инициализует его
     *
     * Меняет размер данного Массива на биты.длина и инициализует каждое битовое
     * значение в соответствии с булевым значением в биты.
     *
     * Параметры:
     *  биты = Инициализационное значение.
     */
    проц opAssign( бул[] биты );

    /**
     * Копирует биты из Массива 1 и преобразует в данный Массив. Это не shallow
     * (теневая) копия.
     *
     * Параметры:
     *  правткт = МассивБит с как минимум таким же числом бит как в этом битовом
     *  Массиве.
     *
     * Возвращает:
     *  Копию this Массива.
     *
     *  --------------------
     *  МассивБит ba = [0,1,0,1,0];
     *  МассивБит ba2;
     *  ba2.длина = ba.длина;
     *  ba2[] = ba; // выполняет копирование
     *  ba[0] = да;
     *  assert(ba2[0] == нет);
     */
    МассивБит opSliceAssign(МассивБит правткт);


    /**
     * Картирует МассивБит на мишень, причём члобит равно числу битов в
     * этом Массиве. Данные не копируются. Это инверсия opCast.
     *
     * Параметры:
     *  мишень  = Кортируемый Массив.
     *  члобит = Число битов, картируемых в мишень.
     */
    проц иниц( проц[] мишень, т_мера члобит );


    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0,1,0,1];
            МассивБит b;
            проц[] буф;

            буф = cast(проц[])a;
            b.иниц( буф, a.длина );

            assert( b[0] == 1 );
            assert( b[1] == 0 );
            assert( b[2] == 1 );
            assert( b[3] == 0 );
            assert( b[4] == 1 );

            a[0] = 0;
            assert( b[0] == 0 );

            assert( a == b );

            // тест opSliceAssign
            МассивБит c;
            c.длина = a.длина;
            c[] = a;
            assert( c == a );
            a[0] = 1;
            assert( c != a );
        }
    }


    /**
     * На месте разворачивает содержимое этого массива, 
     * подобно свойству reverse у встроенных массивов.
     *
     * Возвращает:
     *  Неглубокую копию this Массива.
     */
    МассивБит реверс();


    debug( UnitTest )
    {
        unittest
        {
            static бул[5] данные = [1,0,1,1,0];
            МассивБит b = данные;
            b.реверс;

            for( т_мера i = 0; i < данные.длина; ++i )
            {
                assert( b[i] == данные[4 - i] );
            }
        }
    }


    /**
     * На месте сортирует этот массив, без нулевой записи перед единицей.
     * Эквивалентно свойству sort у встроенных массивов.
     *
     * Возвращает:
     *  Неглубокую копию этого массива.
     */
    МассивБит сортируй();


    debug( UnitTest )
    {
        unittest
        {
            static бцел x = 0b1100011000;
            static МассивБит ba = { 10, &x };

            ba.сортируй;
            for( т_мера i = 0; i < 6; ++i )
                assert( ba[i] == нет );
            for( т_мера i = 6; i < 10; ++i )
                assert( ba[i] == да );
        }
    }


    /**
     * Оперирует над всеми битами этого массива.
     *
     * Параметры:
     *  дг = Код, применяемый как делегат.
     */
    цел opApply( цел delegate(ref бул) дг );


    /** описано ранее */
    цел opApply( цел delegate(ref т_мера, ref бул) дг );


    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0,1];

            цел i;
            foreach( b; a )
            {
                switch( i )
                {
                case 0:
                    assert( b == да );
                    break;
                case 1:
                    assert( b == нет );
                    break;
                case 2:
                    assert( b == да );
                    break;
                default:
                    assert( нет );
                }
                i++;
            }

            foreach( j, b; a )
            {
                switch( j )
                {
                case 0:
                    assert( b == да );
                    break;
                case 1:
                    assert( b == нет );
                    break;
                case 2:
                    assert( b == да );
                    break;
                default:
                    assert( нет );
                }
            }
        }
    }


    /**
     * Сравнивает этот массив с другим на равенство. Двубитные массивы равны,
     * если у них одинаковый размер и содержатся одинаковые серии битов.
     *
     * Параметры:
     *  правткт = Массив, с которым проводится сравнение.
     *
     * Возвращает:
     *  нуль, если не равны, либо не нуль в ином случае.
     */
    цел opEquals( МассивБит правткт );

    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0,1,0,1];
            МассивБит b = [1,0,1];
            МассивБит c = [1,0,1,0,1,0,1];
            МассивБит d = [1,0,1,1,1];
            МассивБит e = [1,0,1,0,1];

            assert(a != b);
            assert(a != c);
            assert(a != d);
            assert(a == e);
        }
    }


    /**
     * Выполняет лексикографическое сравнение этого массива с заданным
     * массивом.
     *
     * Параметры:
     *  правткт = Массив, с которым проводится сравнение.
     *
     * Возвращает:
     *  Значение, меньшее нуля, если этот массив сортируется перед предоставленным массивом,
     *  ноль, если массивы эквивалентны, и значение, большее нуля, если
     *  этот массив сортируется после предоставленного массива.
     */
    цел opCmp( МассивБит правткт );

    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0,1,0,1];
            МассивБит b = [1,0,1];
            МассивБит c = [1,0,1,0,1,0,1];
            МассивБит d = [1,0,1,1,1];
            МассивБит e = [1,0,1,0,1];
            МассивБит f = [1,0,1,0];

            assert( a >  b );
            assert( a >= b );
            assert( a <  c );
            assert( a <= c );
            assert( a <  d );
            assert( a <= d );
            assert( a == e );
            assert( a <= e );
            assert( a >= e );
            assert( f >  b );
        }
    }


    /**
     * Прелбразует этот массив в массив проц.
     *
     * Возвращает:
     *  Этот массив, представленный как массив проц.
     */
    проц[] opCast();


    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0,1,0,1];
            проц[] знач = cast(проц[])a;

            assert( знач.длина == a.цразм * бцел.sizeof );
        }
    }


    /**
     * Поддержка операций индексирования, напродобии как у встроенных массивов.
     *
     * Параметры:
     *  поз = Нужная позиция индекса.
     *
     * In:
     *  поз должна быть меньше, чем длина этого массива.
     *
     * Возвращает:
     *  Значение бита в поз.
     */
    бул opIndex( т_мера поз );


    /**
     * Генерирует копию этого массива с унарной операцией complement
     * applied.
     *
     * Возвращает:
     *  Новый массив, который является complement'ом этого массива.
     */
    МассивБит opCom();


    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0,1,0,1];
            МассивБит b = ~a;

            assert(b[0] == 0);
            assert(b[1] == 1);
            assert(b[2] == 0);
            assert(b[3] == 1);
            assert(b[4] == 0);
        }
    }


    /**
     * Генерирует новый Массив, являющийся результатом побитной операции И (and)
     * между этим Массивом и прилагаемым Массивом.
     *
     * Параметры:
     *  правткт = Массив, над которым выполняется операция побитного И.
     *
     * In:
     *  правткт.длина должна равняться длине этого массива.
     *
     * Возвращает:
     *  Новый Массив, являющийся результатом побитного И этого Массива и
     *  прилагаемого Массива.
     */
    МассивБит opAnd( МассивБит правткт );


    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0,1,0,1];
            МассивБит b = [1,0,1,1,0];

            МассивБит c = a & b;

            assert(c[0] == 1);
            assert(c[1] == 0);
            assert(c[2] == 1);
            assert(c[3] == 0);
            assert(c[4] == 0);
        }
    }


    /**
     * Генерирует новый Массив, являющийся результатом операции побитного Или (or)
     * между этим Массивом и прилагаемым Массивом.
     *
     * Параметры:
     *  правткт = Массив, над которым выполняется операция побитного Или.
     *
     * In:
     *  правткт.длина должна равняться длине этого массива.
     *
     * Возвращает:
     *  Новый Массив, являющийся результатом побитного Или этого Массива и
     *  прилагаемого Массива.
     */
    МассивБит opOr( МассивБит правткт );


    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0,1,0,1];
            МассивБит b = [1,0,1,1,0];

            МассивБит c = a | b;

            assert(c[0] == 1);
            assert(c[1] == 0);
            assert(c[2] == 1);
            assert(c[3] == 1);
            assert(c[4] == 1);
        }
    }


    /**
     * Генерирует новый Массив, являющийся результатом операции побитного ИИли (xor)
     * между этим Массивом и прилагаемым Массивом.
     *
     * Параметры:
     *  правткт = Массив, над которым выполняется операция побитного ИИли.
     *
     * In:
     *  правткт.длина должна равняться длине этого массива.
     *
     * Возвращает:
     *  Новый Массив, являющийся результатом побитного ИИли этого Массива и
     *  прилагаемого Массива.
     */
    МассивБит opXor( МассивБит правткт );


    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0,1,0,1];
            МассивБит b = [1,0,1,1,0];

            МассивБит c = a ^ b;

            assert(c[0] == 0);
            assert(c[1] == 0);
            assert(c[2] == 0);
            assert(c[3] == 1);
            assert(c[4] == 1);
        }
    }


    /**
     * Генерирует новый Массив, являющийся результатом "этот Массив минус
     * прилагаемый Массив".  $(I a - b) для МассивБитов означает то же, что
     * $(I a &amp; ~b).
     *
     * Параметры:
     *  правткт = Массив, над которым выполняется операция вычитания.
     *
     * In:
     *  правткт.длина должна равняться длине этого массива.
     *
     * Возвращает:
     *  Новый Массив, являющийся результатом это Массив минус прилагаемый Массив.
     */
    МассивБит opSub( МассивБит правткт );


    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0,1,0,1];
            МассивБит b = [1,0,1,1,0];

            МассивБит c = a - b;

            assert( c[0] == 0 );
            assert( c[1] == 0 );
            assert( c[2] == 0 );
            assert( c[3] == 0 );
            assert( c[4] == 1 );
        }
    }


    /**
     * Генерирует новый Массив, являющийся результатом "этот Массив контатенированный
     * с прилагаемым Массивом".
     *
     * Параметры:
     *  правткт = Массив, над которым выполняется операция конкатенации.
     *
     * Возвращает:
     *  Новый Массив, являющийся результатом "этот Массив конкатенированный с
     *  прилагаемый Массив".
     */
    МассивБит opCat( бул правткт );


    /** описано ранее */
    МассивБит opCat_r( бул lhs )
    {
        МассивБит результат;

        результат.длина = длин + 1;
        результат[0] = lhs;
        for( т_мера i = 0; i < длин; ++i )
            результат[1 + i] = (*this)[i];
        return результат;
    }


    /** описано ранее */
    МассивБит opCat( МассивБит правткт );


    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0];
            МассивБит b = [0,1,0];
            МассивБит c;

            c = (a ~ b);
            assert( c.длина == 5 );
            assert( c[0] == 1 );
            assert( c[1] == 0 );
            assert( c[2] == 0 );
            assert( c[3] == 1 );
            assert( c[4] == 0 );

            c = (a ~ да);
            assert( c.длина == 3 );
            assert( c[0] == 1 );
            assert( c[1] == 0 );
            assert( c[2] == 1 );

            c = (нет ~ a);
            assert( c.длина == 3 );
            assert( c[0] == 0 );
            assert( c[1] == 1 );
            assert( c[2] == 0 );
        }
    }


    /**
     * Поддержка иперации индексирования, подобна поведения встроенных массивов.
     *
     * Параметры:
     *  b   = Устанавливаемое новое значение бита.
     *  поз = Требуемая позиция индекса.
     *
     * In:
     *  поз должно быть меньше длины этого массива.
     *
     * Возвращает:
     *  Новое значение бита в поз.
     */
    бул opIndexAssign( бул b, т_мера поз );


    /**
     * Обновляет содержимое этого Массива результатом побитной операции И
     * между этим Массивом и прилагаемым Массивом.
     *
     * Параметры:
     *  правткт = Массив, над которым выполняется операция побитного И.
     *
     * In:
     *  правткт.длина должна равняться длине этого массива.
     *
     * Возвращает:
     *  Неглубокая копия этого массива.
     */
    МассивБит opAndAssign( МассивБит правткт );


    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0,1,0,1];
            МассивБит b = [1,0,1,1,0];

            a &= b;
            assert( a[0] == 1 );
            assert( a[1] == 0 );
            assert( a[2] == 1 );
            assert( a[3] == 0 );
            assert( a[4] == 0 );
        }
    }


    /**
     * Обновляет содержимое этого Массива результатом побитной операции Или
     *
     * Параметры:
     *  правткт = Массив, над которым выполняется операция побитного Или.
     *
     * In:
     *  правткт.длина должна равняться длине этого массива.
     *
     * Возвращает:
     *  Неглубокая копия этого массива.
     */
    МассивБит opOrAssign( МассивБит правткт );

    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0,1,0,1];
            МассивБит b = [1,0,1,1,0];

            a |= b;
            assert( a[0] == 1 );
            assert( a[1] == 0 );
            assert( a[2] == 1 );
            assert( a[3] == 1 );
            assert( a[4] == 1 );
        }
    }


    /**
     * Обновляет содержимое этого Массива результатом побитной операции ИИли
     * между этим Массивом и прилагаемым Массивом.
     *
     * Параметры:
     *  правткт = Массив, над которым выполняется операция побитного ИИли.
     *
     * In:
     *  правткт.длина должна равняться длине этого массива.
     *
     * Возвращает:
     *  Неглубокая копия этого массива.
     */
    МассивБит opXorAssign( МассивБит правткт );


    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0,1,0,1];
            МассивБит b = [1,0,1,1,0];

            a ^= b;
            assert( a[0] == 0 );
            assert( a[1] == 0 );
            assert( a[2] == 0 );
            assert( a[3] == 1 );
            assert( a[4] == 1 );
        }
    }


    /**
     * Обновляет содержимое этого массива результатом этот Массив минус
     * прилагаемый Массив.  $(I a - b) для МассивБитов означает то же, что
     * $(I a &amp; ~b).
     *
     * Параметры:
     *  правткт = Массив, над которым выполняется операция вычитания.
     *
     * In:
     *  правткт.длина должна равняться длине этого массива.
     *
     * Возвращает:
     *  Неглубокая копия этого массива.
     */
    МассивБит opSubAssign( МассивБит правткт );


    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0,1,0,1];
            МассивБит b = [1,0,1,1,0];

            a -= b;
            assert( a[0] == 0 );
            assert( a[1] == 0 );
            assert( a[2] == 0 );
            assert( a[3] == 0 );
            assert( a[4] == 1 );
        }
    }


    /**
     * Обновляет содержимое этого массива результатами конкатенации
     * его с другим массивом.
     *
     * Параметры:
     *  правткт = Массив, с которым выполняется операция конкатенации.
     *
     * Возвращает:
     *  Неглубокую копию этого массива.
     */
    МассивБит opCatAssign( бул b );


    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0,1,0,1];
            МассивБит b;

            b = (a ~= да);
            assert( a[0] == 1 );
            assert( a[1] == 0 );
            assert( a[2] == 1 );
            assert( a[3] == 0 );
            assert( a[4] == 1 );
            assert( a[5] == 1 );

            assert( b == a );
        }
    }


    /** описано ранее */
    МассивБит opCatAssign( МассивБит правткт );


    debug( UnitTest )
    {
        unittest
        {
            МассивБит a = [1,0];
            МассивБит b = [0,1,0];
            МассивБит c;

            c = (a ~= b);
            assert( a.длина == 5 );
            assert( a[0] == 1 );
            assert( a[1] == 0 );
            assert( a[2] == 0 );
            assert( a[3] == 1 );
            assert( a[4] == 0 );

            assert( c == a );
        }
    }
}
