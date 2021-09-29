﻿/** Arbitrary-точность ('bignum') arithmetic
 *
 * Copyright: Copyright (C) 2008 Don Clugston.  Все права защищены.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Don Clugston
 */

module math.BigInt;

private import math.internal.BiguintCore;

/** A struct representing an arbitrary точность целое
 *
 * все arithmetic operations are supported, except
 * unsigned shift прав (>>>).
 * Реверсни operations are supported only for цел, дол,
 * и бдол, due в_ language limitations.
 * It реализует значение semantics using копируй-on-пиши. This means that
 * assignment is cheap, but operations such as x++ will cause куча
 * allocation. (But note that for most bigint operations, куча allocation is
 * inevitable anyway).
 *
 * Performance is excellent for numbers below ~1000 decimal цифры.
 * For X86 machines, highly optimised assembly routines are использован.
 */
struct БольшЦел
{
private:
	БольшБцел данные;     // БольшЦел добавьs signed arithmetic в_ БольшБцел.
	бул знак = нет;
public:
    /// Construct a БольшЦел из_ a decimal or hexadecimal ткст.
    /// The число must be in the form of a D decimal or hex literal:
    /// It may have a leading + or - знак; followed by "0x" if hexadecimal.
    /// Underscores are permitted.
    /// BUG: Should throw a ИсклНелегальногоАргумента/ConvError if не_годится character найдено
    static БольшЦел opCall(T : ткст)(T z) {
        сим [] s = z;
        БольшЦел r;
        бул neg = нет;
        if (s[0] == '-') {
            neg = да;
            s = s[1..$];
        } else if (s[0]=='+') {
            s = s[1..$];
        }
        auto q = 0X3;
        бул ok;
        if (s.length>2 && (s[0..2]=="0x" || s[0..2]=="0X")) {
            ok = r.данные.изГексТкст(s[2..$]);
        } else {
            ok = r.данные.изДесятичнТкст(s);
        }
        assert(ok);
        if (r.ноль_ли()) neg = нет;
        r.знак = neg;
        return r;
    }
    static БольшЦел opCall(T: цел)(T x) {
        БольшЦел r;
        r.данные = cast(бдол)((x < 0) ? -x : x);
        r.знак = (x < 0);
        return r;
    }
    ///
    проц opAssign(T:цел)(T x) {
        данные = cast(бдол)((x < 0) ? -x : x);
        знак = (x < 0);
    }
    ///
    БольшЦел opAdd(T: цел)(T y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        БольшЦел r;
        r.знак = знак;
        r.данные = БольшБцел.addOrSubInt(данные, u, знак!=(y<0), &r.знак);
        return r;
    }    
    ///
    БольшЦел opAddAssign(T: цел)(T y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        данные = БольшБцел.addOrSubInt(данные, u, знак!=(y<0), &знак);
        return *this;
    }    
    ///
    БольшЦел opAdd(T: БольшЦел)(T y) {
        БольшЦел r;
        r.знак = знак;
        r.данные = БольшБцел.addOrSub(данные, y.данные, знак != y.знак, &r.знак);
        return r;
    }
    ///
    БольшЦел opAddAssign(T:БольшЦел)(T y) {
        данные = БольшБцел.addOrSub(данные, y.данные, знак != y.знак, &знак);
        return *this;
    }    
    ///
    БольшЦел opSub(T: цел)(T y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        БольшЦел r;
        r.знак = знак;
        r.данные = БольшБцел.addOrSubInt(данные, u, знак == (y<0), &r.знак);
        return r;
    }        
    ///
    БольшЦел opSubAssign(T: цел)(T y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        данные = БольшБцел.addOrSubInt(данные, u, знак == (y<0), &знак);
        return *this;
    }
    ///
    БольшЦел opSub(T: БольшЦел)(T y) {
        БольшЦел r;
        r.знак = знак;
        r.данные = БольшБцел.addOrSub(данные, y.данные, знак == y.знак, &r.знак);
        return r;
    }        
    ///
    БольшЦел opSub_r(цел y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        БольшЦел r;
        r.знак = знак;
        r.данные = БольшБцел.addOrSubInt(данные, u, знак == (y<0), &r.знак);
        r.отрицай();
        return r;
    }
    ///
    БольшЦел opSub_r(дол y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        БольшЦел r;
        r.знак = знак;
        r.данные = БольшБцел.addOrSubInt(данные, u, знак == (y<0), &r.знак);
        r.отрицай();
        return r;
    }
    ///
    БольшЦел opSub_r(бдол y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        БольшЦел r;
        r.знак = знак;
        r.данные = БольшБцел.addOrSubInt(данные, u, знак == (y<0), &r.знак);
        r.отрицай();
        return r;
    }    
    ///
    БольшЦел opSubAssign(T:БольшЦел)(T y) {
        данные = БольшБцел.addOrSub(данные, y.данные, знак == y.знак, &знак);
        return *this;
    }    
    ///
    БольшЦел opMul(T: цел)(T y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        return mulInternal(*this, u, знак != (y<0));
    }
    ///    
    БольшЦел opMulAssign(T: цел)(T y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        *this = mulInternal(*this, u, знак != (y<0));
        return *this;
    }
    ///    
    БольшЦел opMul(T:БольшЦел)(T y) {
        return mulInternal(*this, y);
    }
    ///
    БольшЦел opMulAssign(T: БольшЦел)(T y) {
        *this = mulInternal(*this, y);
        return *this;        
    }
    ///
    БольшЦел opDiv(T:цел)(T y) {
        assert(y!=0, "Деление на ноль");
        БольшЦел r;
        бцел u = y < 0 ? -y : y;
        r.данные = БольшБцел.divInt(данные, u);
        r.знак = r.ноль_ли()? нет : знак != (y<0);
        return r;
    }
    ///
    БольшЦел opDivAssign(T: цел)(T y) {
        assert(y!=0, "Деление на ноль");
        бцел u = y < 0 ? -y : y;
        данные = БольшБцел.divInt(данные, u);
        знак = данные.ноль_ли()? нет : знак ^ (y<0);
        return *this;
    }
    ///
    БольшЦел opDivAssign(T: БольшЦел)(T y) {
        *this = divInternal(*this, y);
        return *this;
    }    
    ///
    БольшЦел opDiv(T: БольшЦел)(T y) {
        return divInternal(*this, y);
    }    
    ///
    цел opMod(T:цел)(T y) {
        assert(y!=0);
        бцел u = y < 0 ? -y : y;
        цел rem = БольшБцел.modInt(данные, u);
        // x%y always имеется the same знак as x.
        // This is not the same as mathematical mod.
        return знак? -rem : rem; 
    }
    ///
    БольшЦел opModAssign(T:цел)(T y) {
        assert(y!=0);
        бцел u = y < 0 ? -y : y;
        данные = БольшБцел.modInt(данные, u);
        // x%y always имеется the same знак as x.
        // This is not the same as mathematical mod.
        return *this;
    }
    ///
    БольшЦел opMod(T: БольшЦел)(T y) {
        return modInternal(*this, y);
    }    
    ///
    БольшЦел opModAssign(T: БольшЦел)(T y) {
        *this = modInternal(*this, y);
        return *this;
    }    
    ///
    БольшЦел opNeg() {
        БольшЦел r = *this;
        r.отрицай();
        return r;
    }
    ///
    БольшЦел opPos() { return *this; }    
    ///
    БольшЦел opPostInc() {
        БольшЦел old = *this;
        данные = БольшБцел.addOrSubInt(данные, 1, нет, &знак);
        return old;
    }
    ///
    БольшЦел opPostDec() {
        БольшЦел old = *this;
        данные = БольшБцел.addOrSubInt(данные, 1, да, &знак);
        return old;
    }
    ///
    БольшЦел opShr(T:цел)(T y) {
        БольшЦел r;
        r.данные = данные.opShr(y);
        r.знак = r.данные.ноль_ли()? нет : знак;
        return r;
    }
    ///
    БольшЦел opShrAssign(T:цел)(T y) {
        данные = данные.opShr(y);
        if (данные.ноль_ли()) знак = нет;
        return *this;
    }
    ///
    БольшЦел opShl(T:цел)(T y) {
        БольшЦел r;
        r.данные = данные.opShl(y);
        r.знак = знак;
        return r;
    }
    ///
    БольшЦел opShlAssign(T:цел)(T y) {
        данные = данные.opShl(y);
        return *this;
    }
    ///
    цел opEquals(T: БольшЦел)(T y) {
       return знак == y.знак && y.данные == данные;
    }
    ///
    цел opEquals(T: цел)(T y) {
        if (знак!=(y<0)) return 0;
        return данные.opEquals(cast(бдол)(y>=0?y:-y));
    }
    ///
    цел opCmp(T:цел)(T y) {
     //   if (y==0) return знак? -1: 1;
        if (знак!=(y<0)) return знак ? -1 : 1;
        цел cmp = данные.opCmp(cast(бдол)(y>=0? y: -y));        
        return знак? -cmp: cmp;
    }
    ///
    цел opCmp(T:БольшЦел)(T y) {
        if (знак!=y.знак) return знак ? -1 : 1;
        цел cmp = данные.opCmp(y.данные);
        return знак? -cmp: cmp;
    }
    /// Возвращает the значение of this БольшЦел as a дол,
    /// or +- дол.max if outsопрe the representable range.
    дол вДол() {
        return (знак ? -1 : 1)* 
          (данные.бдолДлина() == 1  && (данные.возьмиБдол(0) <= cast(бдол)(дол.max)) ? cast(дол)(данные.возьмиБдол(0)): дол.max);
    }
    /// Возвращает the значение of this БольшЦел as an цел,
    /// or +- дол.max if outsопрe the representable range.
    дол вЦел() {
        return (знак ? -1 : 1)* 
          (данные.бцелДлина() == 1  && (данные.возьмиБцел(0) <= cast(бцел)(цел.max)) ? cast(цел)(данные.возьмиБцел(0)): цел.max);
    }
    /// Число of significant бцелs which are использован in storing this число.
    /// The абсолютный значение of this БольшЦел is always < 2^(32*бцелДлина)
    цел бцелДлина() { return данные.бцелДлина(); }
    /// Число of significant ulongs which are использован in storing this число.
    /// The абсолютный значение of this БольшЦел is always < 2^(64*бдолДлина)
    цел бдолДлина() { return данные.бдолДлина(); } 
    
    /// Return x raised в_ the power of y
    /// This interface is tentative и may change.
    static БольшЦел степень(БольшЦел x, бдол y) {
       БольшЦел r;
       r.знак = (y&1)? x.знак : нет;
       r.данные = БольшБцел.степень(x.данные, y);
       return r;
    }
public:
    /// Deprecated. Use бцелДлина() or бдолДлина() instead.
    цел члоБайтов() {
        return данные.члоБайтов();
    }
    /// BUG: For testing only, this will be removed eventually 
    /// (needs formatting опции)
    сим [] вДесятичнТкст(){
        сим [] buff = данные.вДесятичнТкст(1);
        if (отриц_ли()) buff[0] = '-';
        else buff = buff[1..$];
        return buff;
    }
    /// Convert в_ a hexadecimal ткст, with an underscore every
    /// 8 characters.
    сим [] вГекс() {
        сим [] buff = данные.вГексТкст(1, '_');
        if (отриц_ли()) buff[0] = '-';
        else buff = buff[1..$];
        return buff;
    }
public:
    проц отрицай() { if (!данные.ноль_ли()) знак = !знак; }
    бул ноль_ли() { return данные.ноль_ли(); }
    бул отриц_ли() { return знак; }
package:
    /// BUG: For testing only, this will be removed eventually
    БольшЦел срежьВерхниеБайты(бцел члобайтов) {
        assert(члобайтов<=члоБайтов());
        БольшЦел x;
        x.знак = знак;
        x.данные = данные.срежьВерхниеБайты(члобайтов);
        return x;
    }

private:    
    static БольшЦел addsubInternal(БольшЦел x, БольшЦел y, бул wantSub) {
        БольшЦел r;
        r.знак = x.знак;
        r.данные = БольшБцел.addOrSub(x.данные, y.данные, wantSub, &r.знак);
        return r;
    }
    static БольшЦел mulInternal(БольшЦел x, БольшЦел y) {
        БольшЦел r;        
        r.данные = БольшБцел.mul(x.данные, y.данные);
        r.знак = r.ноль_ли() ? нет : x.знак ^ y.знак;
        return r;
    }
    
    static БольшЦел modInternal(БольшЦел x, БольшЦел y) {
        if (x.ноль_ли()) return x;
        БольшЦел r;
        r.знак = x.знак;
        r.данные = БольшБцел.mod(x.данные, y.данные);
        return r;
    }
    static БольшЦел divInternal(БольшЦел x, БольшЦел y) {
        if (x.ноль_ли()) return x;
        БольшЦел r;
        r.знак = x.знак ^ y.знак;
        r.данные = БольшБцел.div(x.данные, y.данные);
        return r;
    }
    static БольшЦел mulInternal(БольшЦел x, бдол y, бул отрицРез)
    {
        БольшЦел r;
        if (y==0) {
            r.знак = нет;
            r.данные = 0;
            return r;
        }
        r.знак = отрицРез;
        r.данные = БольшБцел.mulInt(x.данные, y);
        return r;
    }
}

debug(UnitTest)
{
unittest {
    // Radix conversion
    assert( БольшЦел("-1_234_567_890_123_456_789").вДесятичнТкст 
        == "-1234567890123456789");
    assert( БольшЦел("0x1234567890123456789").вГекс == "123_45678901_23456789");
    assert( БольшЦел("0x00000000000000000000000000000000000A234567890123456789").вГекс
        == "A23_45678901_23456789");
    assert( БольшЦел("0x000_00_000000_000_000_000000000000_000000_").вГекс == "0");
    
    assert(БольшЦел(-0x12345678).вЦел() == -0x12345678);
    assert(БольшЦел(-0x12345678).вДол() == -0x12345678);
    assert(БольшЦел(0x1234_5678_9ABC_5A5AL).вДол() == 0x1234_5678_9ABC_5A5AL);
    assert(БольшЦел(0xF234_5678_9ABC_5A5AL).вДол() == дол.max);
    assert(БольшЦел(-0x123456789ABCL).вЦел() == -цел.max);

}
}