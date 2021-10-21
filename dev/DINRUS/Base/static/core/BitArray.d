﻿/**
 * Этот модуль содержит реализацию упакованного Массива бит в стиле
 * встроенных в Ди динамических массивов.
 *
 * Copyright: Copyright (C) 2005-2006 Digital Mars, www.digitalmars.com.
 *            Все права защищены.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Walter Bright, Sean Kelly
 */
module core.BitArray;


private import core.BitManip;


/**
 * Эта структура представляет Массив из булевых значений, каждое из которых занимает
 * при сохранении один бит памяти. Таким образом Массив из 32-х бит занимает такое же
 * пространство, как одно целое значение. Типичные операции с массивами--такие как
 * индексирование и сортировка -- поддерживаются, также как и побитовые операции,
 * такие как and, or, xor и complement.
 */
struct МассивБит
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
    static МассивБит opCall( бул[] биты )
    {
        МассивБит врем;

        врем.длина = биты.length;
        foreach( поз, знач; биты )
        врем[поз] = знач;
        return врем;
    }

    /**
     * Получить число битов в этом Массиве.
     *
     * Возвращает:
     *  Число битов в данном Массиве.
     */
    т_мера длина()
    {
        return длин;
    }


    /**
     * Изменяет размер данного Массива на новдлин бит. 
     * Если новдлин больше, чем текущая
     * длина, то новые биты будут инициализованы в ноль.
     *
     * Параметры:
     *  новдлин = Число  битов, которое должен содержать данный Массив.
     */
    проц длина( т_мера новдлин )
    {
        if( новдлин != длин )
        {
            auto старразм = цразм();
            auto новразм = (новдлин + 31) / 32;

            if( новразм != старразм )
            {
                // Create a fake Массив so we can use D's realloc machinery
                бцел[] буф = ptr[0 .. старразм];

                буф.length = новразм; // realloc
                ptr = буф.ptr;
                if( новразм & 31 )
                {
                    // Набор any пад биты в_ 0
                    ptr[новразм - 1] &= ~(~0 << (новразм & 31));
                }
            }
            длин = новдлин;
        }
    }


    /**
     * Gets the длина of a бцел Массив large enough в_ hold все stored биты.
     *
     * Возвращает:
     *  The размер a бцел Массив would have в_ be в_ сохрани this Массив.
     */
    т_мера цразм()
    {
        return (длин + 31) / 32;
    }


    /**
     * Duplicates this Массив, much like the dup property for built-in массивы.
     *
     * Возвращает:
     *  A duplicate of this Массив.
     */
    МассивБит dup()
    {
        МассивБит ba;

        бцел[] буф = ptr[0 .. цразм].dup;
        ba.длин = длин;
        ba.ptr = буф.ptr;
        return ba;
    }


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
    проц opAssign( бул[] биты )
    {
        длина = биты.length;
        foreach( i, b; биты )
        {
            (*this)[i] = b;
        }
    }

    /**
     * Копирует биты из Массива 1 и преобразует в данный Массив. Это не shallow
     * (теневая) копия.
     *
     * Параметры:
     *  rhs = МассивБит с как минимум таким же числом бит как в этом битовом
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
    МассивБит opSliceAssign(МассивБит rhs)
    in
    {
        assert(rhs.длин == длин);
    }
    body
    {
        т_мера mDim=длин/32;
        ptr[0..mDim] = rhs.ptr[0..mDim];
        цел rest=cast(цел)(длин & cast(т_мера)31u);
        if (rest)
        {
            бцел маска=(~0u)<<rest;
            ptr[mDim]=(rhs.ptr[mDim] & (~маска))|(ptr[mDim] & маска);
        }
        return *this;
    }


    /**
     * Map МассивБит onto мишень, with члобит being the число of биты in the
     * Массив. Does not копируй the данные.  This is the inverse of opCast.
     *
     * Параметры:
     *  мишень  = The Массив в_ карта.
     *  члобит = The число of биты в_ карта in мишень.
     */
    проц иниц( проц[] мишень, т_мера члобит )
    in
    {
        assert( члобит <= мишень.length * 8 );
        assert( (мишень.length & 3) == 0 );
    }
    body
    {
        ptr = cast(бцел*)мишень.ptr;
        длин = члобит;
    }


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
     * Reverses the contents of this Массив in place, much like the реверс
     * property for built-in массивы.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит реверс()
    out( результат )
    {
        assert( результат == *this );
    }
    body
    {
        if( длин >= 2 )
        {
            бул t;
            т_мера lo, hi;

            lo = 0;
            hi = длин - 1;
            for( ; lo < hi; ++lo, --hi )
            {
                t = (*this)[lo];
                (*this)[lo] = (*this)[hi];
                (*this)[hi] = t;
            }
        }
        return *this;
    }


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
     * Sorts this Массив in place, with zero записи sorting before one.  This
     * is equivalent в_ the сортируй property for built-in массивы.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит сортируй()
    out( результат )
    {
        assert( результат == *this );
    }
    body
    {
        if( длин >= 2 )
        {
            т_мера lo, hi;

            lo = 0;
            hi = длин - 1;
            while( да )
            {
                while( да )
                {
                    if( lo >= hi )
                        goto Ldone;
                    if( (*this)[lo] == да )
                        break;
                    ++lo;
                }

                while( да )
                {
                    if( lo >= hi )
                        goto Ldone;
                    if( (*this)[hi] == нет )
                        break;
                    --hi;
                }

                (*this)[lo] = нет;
                (*this)[hi] = да;

                ++lo;
                --hi;
            }
Ldone:
            ;
        }
        return *this;
    }


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
     * Operates on все биты in this Массив.
     *
     * Параметры:
     *  дг = The supplied код as a delegate.
     */
    цел opApply( цел delegate(ref бул) дг )
    {
        цел результат;

        for( т_мера i = 0; i < длин; ++i )
        {
            бул b = opIndex( i );
            результат = дг( b );
            opIndexAssign( b, i );
            if( результат )
                break;
        }
        return результат;
    }


    /** описано ранее */
    цел opApply( цел delegate(ref т_мера, ref бул) дг )
    {
        цел результат;

        for( т_мера i = 0; i < длин; ++i )
        {
            бул b = opIndex( i );
            результат = дг( i, b );
            opIndexAssign( b, i );
            if( результат )
                break;
        }
        return результат;
    }


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
     * Compares this Массив в_ другой for equality.  Two bit массивы are equal
     * if they are the same размер and contain the same series of биты.
     *
     * Параметры:
     *  rhs = The Массив в_ compare against.
     *
     * Возвращает:
     *  zero if not equal and non-zero иначе.
     */
    цел opEquals( МассивБит rhs )
    {
        if( this.длина != rhs.длина )
            return 0; // not equal
        бцел* p1 = this.ptr;
        бцел* p2 = rhs.ptr;
        т_мера n = this.длина / 32;
        т_мера i;
        for( i = 0; i < n; ++i )
        {
            if( p1[i] != p2[i] )
                return 0; // not equal
        }
        цел rest = cast(цел)(this.длина & cast(т_мера)31u);
        бцел маска = ~((~0u)<<rest);
        return (rest == 0) || (p1[i] & маска) == (p2[i] & маска);
    }

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
     * Performs a lexicographical сравнение of this Массив в_ the supplied
     * Массив.
     *
     * Параметры:
     *  rhs = The Массив в_ compare against.
     *
     * Возвращает:
     *  A значение less than zero if this Массив sorts before the supplied Массив,
     *  zero if the массивы are equavalent, and a значение greater than zero if
     *  this Массив sorts после the supplied Массив.
     */
    цел opCmp( МассивБит rhs )
    {
        auto длин = this.длина;
        if( rhs.длина < длин )
            длин = rhs.длина;
        бцел* p1 = this.ptr;
        бцел* p2 = rhs.ptr;
        т_мера n = длин / 32;
        т_мера i;
        for( i = 0; i < n; ++i )
        {
            if( p1[i] != p2[i] )
            {
                return ((p1[i] < p2[i])?-1:1);
            }
        }
        цел rest=cast(цел)(длин & cast(т_мера) 31u);
        if (rest>0)
        {
            бцел маска=~((~0u)<<rest);
            бцел v1=p1[i] & маска;
            бцел v2=p2[i] & маска;
            if (v1 != v2) return ((v1<v2)?-1:1);
        }
        return ((this.длина<rhs.длина)?-1:((this.длина==rhs.длина)?0:1));
    }

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
     * Convert this Массив в_ a проц Массив.
     *
     * Возвращает:
     *  This Массив represented as a проц Массив.
     */
    проц[] opCast()
    {
        return cast(проц[])ptr[0 .. цразм];
    }


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
     * Support for индекс operations, much like the behavior of built-in массивы.
     *
     * Параметры:
     *  поз = The desired индекс позиция.
     *
     * In:
     *  поз must be less than the длина of this Массив.
     *
     * Возвращает:
     *  The значение of the bit at поз.
     */
    бул opIndex( т_мера поз )
    in
    {
        assert( поз < длин );
    }
    body
    {
        return cast(бул)bt( ptr, поз );
    }


    /**
     * Generates a копируй of this Массив with the unary complement operation
     * applied.
     *
     * Возвращает:
     *  A new Массив which is the complement of this Массив.
     */
    МассивБит opCom()
    {
        auto цразм = this.цразм();

        МассивБит результат;

        результат.длина = длин;
        for( т_мера i = 0; i < цразм; ++i )
            результат.ptr[i] = ~this.ptr[i];
        if( длин & 31 )
            результат.ptr[цразм - 1] &= ~(~0 << (длин & 31));
        return результат;
    }


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
     * Generates a new Массив which is the результат of a bitwise and operation
     * between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ выполни the bitwise and operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A new Массив which is the результат of a bitwise and with this Массив and
     *  the supplied Массив.
     */
    МассивБит opAnd( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        МассивБит результат;

        результат.длина = длин;
        for( т_мера i = 0; i < цразм; ++i )
            результат.ptr[i] = this.ptr[i] & rhs.ptr[i];
        return результат;
    }


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
     * Generates a new Массив which is the результат of a bitwise or operation
     * between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ выполни the bitwise or operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A new Массив which is the результат of a bitwise or with this Массив and
     *  the supplied Массив.
     */
    МассивБит opOr( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        МассивБит результат;

        результат.длина = длин;
        for( т_мера i = 0; i < цразм; ++i )
            результат.ptr[i] = this.ptr[i] | rhs.ptr[i];
        return результат;
    }


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
     * Generates a new Массив which is the результат of a bitwise xor operation
     * between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ выполни the bitwise xor operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A new Массив which is the результат of a bitwise xor with this Массив and
     *  the supplied Массив.
     */
    МассивБит opXor( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        МассивБит результат;

        результат.длина = длин;
        for( т_мера i = 0; i < цразм; ++i )
            результат.ptr[i] = this.ptr[i] ^ rhs.ptr[i];
        return результат;
    }


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
     * Generates a new Массив which is the результат of this Массив minus the
     * supplied Массив.  $(I a - b) for BitArrays means the same thing as
     * $(I a &amp; ~b).
     *
     * Параметры:
     *  rhs = The Массив with which в_ выполни the subtraction operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A new Массив which is the результат of this Массив minus the supplied Массив.
     */
    МассивБит opSub( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        МассивБит результат;

        результат.длина = длин;
        for( т_мера i = 0; i < цразм; ++i )
            результат.ptr[i] = this.ptr[i] & ~rhs.ptr[i];
        return результат;
    }


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
     * Generates a new Массив which is the результат of this Массив concatenated
     * with the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ выполни the concatenation operation.
     *
     * Возвращает:
     *  A new Массив which is the результат of this Массив concatenated with the
     *  supplied Массив.
     */
    МассивБит opCat( бул rhs )
    {
        МассивБит результат;

        результат = this.dup;
        результат.длина = длин + 1;
        результат[длин] = rhs;
        return результат;
    }


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
    МассивБит opCat( МассивБит rhs )
    {
        МассивБит результат;

        результат = this.dup();
        результат ~= rhs;
        return результат;
    }


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
     * Support for индекс operations, much like the behavior of built-in массивы.
     *
     * Параметры:
     *  b   = The new bit значение в_ установи.
     *  поз = The desired индекс позиция.
     *
     * In:
     *  поз must be less than the длина of this Массив.
     *
     * Возвращает:
     *  The new значение of the bit at поз.
     */
    бул opIndexAssign( бул b, т_мера поз )
    in
    {
        assert( поз < длин );
    }
    body
    {
        if( b )
            bts( ptr, поз );
        else
            btr( ptr, поз );
        return b;
    }


    /**
     * Updates the contents of this Массив with the результат of a bitwise and
     * operation between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ выполни the bitwise and operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит opAndAssign( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        for( т_мера i = 0; i < цразм; ++i )
            ptr[i] &= rhs.ptr[i];
        return *this;
    }


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
     * Updates the contents of this Массив with the результат of a bitwise or
     * operation between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ выполни the bitwise or operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит opOrAssign( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        for( т_мера i = 0; i < цразм; ++i )
            ptr[i] |= rhs.ptr[i];
        return *this;
    }


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
     * Updates the contents of this Массив with the результат of a bitwise xor
     * operation between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ выполни the bitwise xor operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит opXorAssign( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        for( т_мера i = 0; i < цразм; ++i )
            ptr[i] ^= rhs.ptr[i];
        return *this;
    }


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
     * Updates the contents of this Массив with the результат of this Массив minus
     * the supplied Массив.  $(I a - b) for BitArrays means the same thing as
     * $(I a &amp; ~b).
     *
     * Параметры:
     *  rhs = The Массив with which в_ выполни the subtraction operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит opSubAssign( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        for( т_мера i = 0; i < цразм; ++i )
            ptr[i] &= ~rhs.ptr[i];
        return *this;
    }


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
     * Updates the contents of this Массив with the результат of this Массив
     * concatenated with the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ выполни the concatenation operation.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит opCatAssign( бул b )
    {
        длина = длин + 1;
        (*this)[длин - 1] = b;
        return *this;
    }


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
    МассивБит opCatAssign( МассивБит rhs )
    {
        auto istart = длин;
        длина = длин + rhs.длина;
        for( auto i = istart; i < длин; ++i )
            (*this)[i] = rhs[i - istart];
        return *this;
    }


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
