// Written in the D programming language
// written by Walter Bright
// www.digitalmars.com
// Placed into the public domain

/** These functions are built-in intrinsics to the compiler.
 *
	Intrinsic functions are functions built in to the compiler,
	usually to take advantage of specific CPU features that
	are inefficient to handle via external functions.
	The compiler's optimizer and code generator are fully
	integrated in with intrinsic functions, bringing to bear
	their full power on them.
	This can result in some surprising speedups.
 *
 * Copyright: Public Domain
 * License:   Public Domain
 * Authors:   Walter Bright
 * Macros:
 *	WIKI=Phobos/StdIntrinsic
 */

module std.intrinsic;

/**
 * Scans the bits in v starting with bit 0, looking
 * for the first set bit.
 * Возвращаетs:
 *	The bit number of the first bit set.
 *	The return value is undefined if v is zero.
 */
int bsf(uint v);

/**
 * Scans the bits in v from the most significant bit
 * to the least significant bit, looking
 * for the first set bit.
 * Возвращаетs:
 *	The bit number of the first bit set.
 *	The return value is undefined if v is zero.
 * Пример:
 * ---
 * import std.stdio;
 * import std.intrinsic;
 *
 * int main()
 * {   
 *     uint v;
 *     int x;
 *
 *     v = 0x21;
 *     x = bsf(v);
 *     writefln("bsf(x%x) = %d", v, x);
 *     x = bsr(v);
 *     writefln("bsr(x%x) = %d", v, x);
 *     return 0;
 * } 
 * ---
 * Output:
 *  bsf(x21) = 0<br>
 *  bsr(x21) = 5
 */
int bsr(uint v);

/**
 * Tests the bit.
 */
int bt(in uint *p, uint bitnum);

/**
 * Tests and complements the bit.
 */
int btc(uint *p, uint bitnum);

/**
 * Tests and resets (sets to 0) the bit.
 */
int btr(uint *p, uint bitnum);

/**
 * Tests and sets the bit.
 * Params:
 * p = a non-NULL pointer to an array of uints.
 * index = a bit number, starting with bit 0 of p[0],
 * and progressing. It addresses bits like the expression:
---
p[index / (uint.sizeof*8)] & (1 << (index & ((uint.sizeof*8) - 1)))
---
 * Возвращаетs:
 * 	A non-zero value if the bit was set, and a zero
 *	if it was clear.
 *
 * Пример: 
 * ---
import std.stdio;
import std.intrinsic;

int main()
{   
    uint array[2];

    array[0] = 2;
    array[1] = 0x100;

    writefln("btc(array, 35) = %d", <b>btc</b>(array, 35));
    writefln("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    writefln("btc(array, 35) = %d", <b>btc</b>(array, 35));
    writefln("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    writefln("bts(array, 35) = %d", <b>bts</b>(array, 35));
    writefln("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    writefln("btr(array, 35) = %d", <b>btr</b>(array, 35));
    writefln("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    writefln("bt(array, 1) = %d", <b>bt</b>(array, 1));
    writefln("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    return 0;
} 
 * ---
 * Output:
<pre>
btc(array, 35) = 0
array = [0]:x2, [1]:x108
btc(array, 35) = -1
array = [0]:x2, [1]:x100
bts(array, 35) = 0
array = [0]:x2, [1]:x108
btr(array, 35) = -1
array = [0]:x2, [1]:x100
bt(array, 1) = -1
array = [0]:x2, [1]:x100
</pre>
 */
int bts(uint *p, uint bitnum);


/**
 * Swaps bytes in a 4 byte uint end-to-end, i.e. byte 0 becomes
	byte 3, byte 1 becomes byte 2, byte 2 becomes byte 1, byte 3
	becomes byte 0.
 */
uint bswap(uint v);


/**
 * Reads I/O port at port_address.
 */
ubyte  inp(uint port_address);

/**
 * описано ранее
 */
ushort inpw(uint port_address);

/**
 * описано ранее
 */
uint   inpl(uint port_address);


/**
 * Writes and returns value to I/O port at port_address.
 */
ubyte  outp(uint port_address, ubyte value);

/**
 * описано ранее
 */
ushort outpw(uint port_address, ushort value);

/**
 * описано ранее
 */
uint   outpl(uint port_address, uint value);

/**
 *  Вычисляет число установленных битов в 32-битном целом.
 */
цел popcnt( бцел x )
{
    // Avoопр branches, and the potential for cache misses which
    // could be incurred with a table отыщи.

    // We need в_ маска alternate биты в_ prevent the
    // sum из_ overflowing.
    // добавь neighbouring биты. Each bit is 0 or 1.
    x = x - ((x>>1) & 0x5555_5555);
    // сейчас each two биты of x is a число 00,01 or 10.
    // сейчас добавь neighbouring pairs
    x = ((x&0xCCCC_CCCC)>>2) + (x&0x3333_3333);
    // сейчас each nibble holds 0000-0100. добавим them won't
    // перебор any ещё, so we don't need в_ маска any ещё

    // Сейчас добавь the nibbles, then the байты, then the words
    // We still need в_ маска в_ prevent дво-counting.
    // Note that if we used a rotate instead of a shift, we
    // wouldn't need the маски, and could just divопрe the sum
    // by 8 в_ account for the дво-counting.
    // On some CPUs, it may be faster в_ выполни a multИПly.

    x += (x>>4);
    x &= 0x0F0F_0F0F;
    x += (x>>8);
    x &= 0x00FF_00FF;
    x += (x>>16);
    x &= 0xFFFF;
    return x;
}


debug( UnitTest )
{
    unittest
    {
      assert( popcnt( 0 ) == 0 );
      assert( popcnt( 7 ) == 3 );
      assert( popcnt( 0xAA )== 4 );
      assert( popcnt( 0x8421_1248 ) == 8 );
      assert( popcnt( 0xFFFF_FFFF ) == 32 );
      assert( popcnt( 0xCCCC_CCCC ) == 16 );
      assert( popcnt( 0x7777_7777 ) == 24 );
    }
}


/**
 * Разворачивает биты в 32-битном целочисленном типе.
 */
бцел битсвоп( бцел x )
{

    version( D_InlineAsm_X86 )
    {
        asm
        {
            // Author: Tiago Gasiba.
            mov EDX, EAX;
            shr EAX, 1;
            and EDX, 0x5555_5555;
            and EAX, 0x5555_5555;
            shl EDX, 1;
            or  EAX, EDX;
            mov EDX, EAX;
            shr EAX, 2;
            and EDX, 0x3333_3333;
            and EAX, 0x3333_3333;
            shl EDX, 2;
            or  EAX, EDX;
            mov EDX, EAX;
            shr EAX, 4;
            and EDX, 0x0f0f_0f0f;
            and EAX, 0x0f0f_0f0f;
            shl EDX, 4;
            or  EAX, EDX;
            bswap EAX;
        }
    }
    else
    {
        // своп odd and even биты
        x = ((x >> 1) & 0x5555_5555) | ((x & 0x5555_5555) << 1);
        // своп consecutive pairs
        x = ((x >> 2) & 0x3333_3333) | ((x & 0x3333_3333) << 2);
        // своп nibbles
        x = ((x >> 4) & 0x0F0F_0F0F) | ((x & 0x0F0F_0F0F) << 4);
        // своп байты
        x = ((x >> 8) & 0x00FF_00FF) | ((x & 0x00FF_00FF) << 8);
        // своп 2-байт дол pairs
        x = ( x >> 16              ) | ( x               << 16);
        return x;

    }
}


debug( UnitTest )
{
    unittest
    {
        assert( битсвоп( 0x8000_0100 ) == 0x0080_0001 );
    }
}


