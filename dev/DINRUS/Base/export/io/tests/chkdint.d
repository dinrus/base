module test.checkedint;

import core.checkedint;

void main()
{
    bool overflow;
    assert(adds(2, 3, overflow) == 5);
    assert(!overflow);
    assert(adds(1, int.max - 1, overflow) == int.max);
    assert(!overflow);
    assert(adds(int.min + 1, -1, overflow) == int.min);
    assert(!overflow);
    assert(adds(int.max, 1, overflow) == int.min);
    assert(overflow);
    overflow = false;
    assert(adds(int.min, -1, overflow) == int.max);
    assert(overflow);
    assert(adds(0, 0, overflow) == 0);
    assert(overflow);                   // sticky

    assert(adds(2L, 3L, overflow) == 5);
    assert(!overflow);
    assert(adds(1L, long.max - 1, overflow) == long.max);
    assert(!overflow);
    assert(adds(cast(long)(long.min + 1), cast(long) -1, overflow) == long.min);
    assert(!overflow);
    assert(adds(cast(long)long.max, cast(long)1, overflow) == long.min);
    assert(overflow);
    overflow = false;
    assert(adds(cast(long) long.min, cast(long) -1, overflow) == long.max);
    assert(overflow);
    assert(adds(0L, 0L, overflow) == 0);
    assert(overflow);                   // sticky

    assert(addu(2, 3, overflow) == 5);
    assert(!overflow);
    assert(addu(1, uint.max - 1, overflow) == uint.max);
    assert(!overflow);
    assert(addu(uint.min, -1, overflow) == uint.max);
    assert(!overflow);
    assert(addu(uint.max, 1, overflow) == uint.min);
    assert(overflow);
    overflow = false;
    assert(addu(uint.min + 1, -1, overflow) == uint.min);
    assert(overflow);
    assert(addu(0, 0, overflow) == 0);
    assert(overflow);                   // sticky
/+
    assert(addu(2L, 3L, overflow) == 5);
    assert(!overflow);
    assert(addu(1, ulong.max - 1, overflow) == ulong.max);
    assert(!overflow);
    assert(addu(ulong.min, -1L, overflow) == ulong.max);
    assert(!overflow);
    assert(addu(ulong.max, 1, overflow) == ulong.min);
    assert(overflow);
    overflow = false;
    assert(addu(ulong.min + 1, -1L, overflow) == ulong.min);
    assert(overflow);
    assert(addu(0L, 0L, overflow) == 0);
    assert(overflow);                   // sticky
+/
    assert(subs(2, -3, overflow) == 5);
    assert(!overflow);
    assert(subs(1, -int.max + 1, overflow) == int.max);
    assert(!overflow);
    assert(subs(int.min + 1, 1, overflow) == int.min);
    assert(!overflow);
    assert(subs(int.max, -1, overflow) == int.min);
    assert(overflow);
    overflow = false;
    assert(subs(int.min, 1, overflow) == int.max);
    assert(overflow);
    assert(subs(0, 0, overflow) == 0);
    assert(overflow);                   // sticky

    assert(subs(2L, -3L, overflow) == 5);
    assert(!overflow);
    assert(subs(1L, -long.max + 1, overflow) == long.max);
    assert(!overflow);
    assert(subs(long.min + 1, 1, overflow) == long.min);
    assert(!overflow);
    assert(subs(-1L, long.min, overflow) == long.max);
    assert(!overflow);
    assert(subs(long.max, -1, overflow) == long.min);
    assert(overflow);
    overflow = false;
    assert(subs(long.min, 1, overflow) == long.max);
    assert(overflow);
    assert(subs(0L, 0L, overflow) == 0);
    assert(overflow);                   // sticky

    assert(subu(3, 2, overflow) == 1);
    assert(!overflow);
    assert(subu(uint.max, 1, overflow) == uint.max - 1);
    assert(!overflow);
    assert(subu(1, 1, overflow) == uint.min);
    assert(!overflow);
    assert(subu(0, 1, overflow) == uint.max);
    assert(overflow);
    overflow = false;
    assert(subu(uint.max - 1, uint.max, overflow) == uint.max);
    assert(overflow);
    assert(subu(0, 0, overflow) == 0);
    assert(overflow);                   // sticky

    assert(subu(3UL, 2UL, overflow) == 1);
    assert(!overflow);
    assert(subu(ulong.max, 1, overflow) == ulong.max - 1);
    assert(!overflow);
    assert(subu(1UL, 1UL, overflow) == ulong.min);
    assert(!overflow);
    assert(subu(0UL, 1UL, overflow) == ulong.max);
    assert(overflow);
    overflow = false;
    assert(subu(ulong.max - 1, ulong.max, overflow) == ulong.max);
    assert(overflow);
    assert(subu(0UL, 0UL, overflow) == 0);
    assert(overflow);                   // sticky

    assert(negs(0, overflow) == -0);
    assert(!overflow);
    assert(negs(1234, overflow) == -1234);
    assert(!overflow);
    assert(negs(-5678, overflow) == 5678);
    assert(!overflow);
    assert(negs(int.min, overflow) == -int.min);
    assert(overflow);
    assert(negs(0, overflow) == -0);
    assert(overflow);                   // sticky

    assert(negs(0L, overflow) == -0);
    assert(!overflow);
    assert(negs(1234L, overflow) == -1234);
    assert(!overflow);
    assert(negs(-5678L, overflow) == 5678);
    assert(!overflow);
    assert(negs(long.min, overflow) == -long.min);
    assert(overflow);
    assert(negs(0L, overflow) == -0);
    assert(overflow);                   // sticky

    assert(muls(2, 3, overflow) == 6);
    assert(!overflow);
    assert(muls(-200, 300, overflow) == -60_000);
    assert(!overflow);
    assert(muls(1, int.max, overflow) == int.max);
    assert(!overflow);
    assert(muls(int.min, 1, overflow) == int.min);
    assert(!overflow);
    assert(muls(int.max, 2, overflow) == (int.max * 2));
    assert(overflow);
    overflow = false;
    assert(muls(int.min, -1, overflow) == int.min);
    assert(overflow);
    assert(muls(0, 0, overflow) == 0);
    assert(overflow);                   // sticky

    assert(muls(2L, 3L, overflow) == 6);
    assert(!overflow);
    assert(muls(-200L, 300L, overflow) == -60_000);
    assert(!overflow);
    assert(muls(1, long.max, overflow) == long.max);
    assert(!overflow);
    assert(muls(long.min, 1L, overflow) == long.min);
    assert(!overflow);
    assert(muls(long.max, 2L, overflow) == (long.max * 2));
    assert(overflow);
    overflow = false;
    assert(muls(-1L, long.min, overflow) == long.min);
    assert(overflow);
    overflow = false;
    assert(muls(long.min, -1L, overflow) == long.min);
    assert(overflow);
    assert(muls(0L, 0L, overflow) == 0);
    assert(overflow);                   // sticky

    void test(uint x, uint y, uint r, bool overflow) 
    {
        bool o;
        assert(mulu(x, y, o) == r);
        assert(o == overflow);
    }
	
    test(2, 3, 6, false);
    test(1, uint.max, uint.max, false);
    test(0, 1, 0, false);
    test(0, uint.max, 0, false);
    test(uint.max, 2, 2 * uint.max, true);
    test(1 << 16, 1U << 16, 0, true);

    bool overflow = true;
    assert(mulu(0, 0, overflow) == 0);
    assert(overflow);                   // sticky

    void test(T, U)(T x, U y, ulong r, bool overflow) 
    {
        bool o;
        assert(mulu(x, y, o) == r);
        assert(o == overflow);
    }
	
    // One operand is zero
    test(0, 3, 0, false);
    test(0UL, 3, 0, false);
    test(0UL, 3UL, 0, false);
    test(3, 0, 0, false);
    test(3UL, 0, 0, false);
    test(3UL, 0UL, 0, false);
    // Small numbers
    test(2, 3, 6, false);
    test(2UL, 3, 6, false);
    test(2UL, 3UL, 6, false);
    // At the 32/64 border
    test(1, cast(ulong)(uint.max), uint.max, false);
    test(1UL, cast(ulong)(uint.max), uint.max, false);
    test(cast(ulong)(uint.max), 1, uint.max, false);
    test(cast(ulong)(uint.max), 1UL, uint.max, false);
    test(1, 1 + cast(ulong)(uint.max), 1 + cast(ulong)(uint.max), false);
    test(1UL, 1 + cast(ulong)(uint.max), 1 + cast(ulong)(uint.max), false);
    test(1 + cast(ulong)(uint.max), 1, 1 + cast(ulong)(uint.max), false);
    test(1 + cast(ulong)(uint.max), 1UL, 1 + cast(ulong)(uint.max), false);
    // At the limit
    test(1, ulong.max, ulong.max, false);
    test(1UL, ulong.max, ulong.max, false);
    test(ulong.max, 1, ulong.max, false);
    test(ulong.max, 1UL, ulong.max, false);
    // Miscellaneous
    test(0, 1, 0, false);
    test(0, ulong.max, 0, false);
    test(ulong.max, 2, 2 * ulong.max, true);
    test(1UL << 32, 1UL << 32, 0, true);
    // Must be sticky
    bool overflow = true;
    assert(mulu(0UL, 0UL, overflow) == 0);
    assert(overflow);                   // sticky
}
