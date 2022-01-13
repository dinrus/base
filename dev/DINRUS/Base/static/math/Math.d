﻿/**
 * Элементарные Математические Функции
 */
module math.Math;

public import stdrus: абс, конъюнк, кос, син, тан, акос, асин, атан, атан2, гкос, гсин, гтан, гакос, гасин, гатан, округливдол, округливближдол, квкор, эксп, экспм1, эксп2, экспи, прэксп, илогб, лдэксп, лог, лог10, лог1п, лог2, логб, модф, скалбн, кубкор, гипот, фцош, лгамма, тгамма, потолок, пол, ближцел, окрвцел, окрвдол, округли, докругли, упрости, остаток, конечен_ли, нч, следщБольш, следщМеньш, следщза, пдельта, пбольш_из, пменьш_из, степень, правны, квадрат, дво, знак, цикл8градус,цикл8радиан, цикл8градиент, градус8цикл, градус8радиан, градус8градиент, радиан8градус, радиан8цикл, радиан8градиент, градиент8градус, градиент8цикл, градиент8радиан, сариф, сумма, меньш_из, больш_из, акот, асек, акосек, кот, сек, косек, гкот, гсек, гкосек, гакот, гасек, гакосек, ткст8реал, копируйзнак, фабс, идентичен_ли, битзнака, субнорм_ли, беск_ли;

private import math.IEEE;

private {
template минмакстип(T...){
    static if(T.length == 1) alias T[0] минмакстип;
    else static if(T.length > 2)
        alias минмакстип!(минмакстип!(T[0..2]), T[2..$]) минмакстип;
    else alias typeof (T[1] > T[0] ? T[1] : T[0]) минмакстип;
}
}

/** Возвращает наименьший из предложенных аргументов.
 *
 * Примечание: Если аргументы являются числами с плавающей точкой, и хотя бы один является НЧ,
 * результат будет неопределённым.
 */
минмакстип!(T) мин(T...)(T арг){
    static if(арг.length == 1) return арг[0];
    else static if(арг.length == 2) return арг[1] < арг[0] ? арг[1] : арг[0];
    static if(арг.length > 2) return мин(арг[1] < арг[0] ? арг[1] : арг[0], арг[2..$]);
}

/** Возвращает наибольший из предложенных аргументов.
 *
 * Примечание: Если аргументы являются числами с плавающей точкой, и хотя бы один является НЧ,
 * результат будет неопределённым.
 */
минмакстип!(T) макс(T...)(T арг){
    static if(арг.length == 1) return арг[0];
    else static if(арг.length == 2) return арг[1] > арг[0] ? арг[1] : арг[0];
    static if(арг.length > 2) return макс(арг[1] > арг[0] ? арг[1] : арг[0], арг[2..$]);
}

/***********************************
 * Оценивает полиномиал A(x) = $(SUB a, 0) + $(SUB a, 1)x + $(SUB a, 2)$(POWER x,2)
 *                          + $(SUB a,3)$(POWER x,3); ...
 *
 * Используется правило Хорнера A(x) = $(SUB a, 0) + x($(SUB a, 1) + x($(SUB a, 2)
 *                         + x($(SUB a, 3) + ...)))
 * Параметры:
 *      A =     Массив коэффициентов $(SUB a, 0), $(SUB a, 1), и т.д.
 */
T поли(T)(T x, T[] A)
in
{
    assert(A.length > 0);
}
body
{
  version (Naked_D_InlineAsm_X86) {
      const бул Use_D_InlineAsm_X86 = да;
  } else const бул Use_D_InlineAsm_X86 = нет;

  // BUG (Inherited из_ Phobos): This код assumes a кадр pointer in EBP.
  // This is not in the spec.
  static if (Use_D_InlineAsm_X86 && is(T==реал) && T.sizeof == 10) {
    asm // assembler by W. Bright
    {
        // EDX = (A.length - 1) * реал.sizeof
        mov     ECX,A[EBP]          ; // ECX = A.length
        dec     ECX                 ;
        lea     EDX,[ECX][ECX*8]    ;
        add     EDX,ECX             ;
        add     EDX,A+4[EBP]        ;
        fld     real ptr [EDX]      ; // ST0 = coeff[ECX]
        jecxz   return_ST           ;
        fld     x[EBP]              ; // ST0 = x
        fxch    ST(1)               ; // ST1 = x, ST0 = r
        align   4                   ;
    L2:  fmul    ST,ST(1)           ; // r *= x
        fld     real ptr -10[EDX]   ;
        sub     EDX,10              ; // deg--
        faddp   ST(1),ST            ;
        dec     ECX                 ;
        jne     L2                  ;
        fxch    ST(1)               ; // ST1 = r, ST0 = x
        fstp    ST(0)               ; // dump x
        align   4                   ;
    return_ST:                      ;
        ;
    }
  } else static if ( Use_D_InlineAsm_X86 && is(T==реал) && T.sizeof==12){
    asm // assembler by W. Bright
    {
        // EDX = (A.length - 1) * реал.sizeof
        mov     ECX,A[EBP]          ; // ECX = A.length
        dec     ECX                 ;
        lea     EDX,[ECX*8]         ;
        lea     EDX,[EDX][ECX*4]    ;
        add     EDX,A+4[EBP]        ;
        fld     real ptr [EDX]      ; // ST0 = coeff[ECX]
        jecxz   return_ST           ;
        fld     x                   ; // ST0 = x
        fxch    ST(1)               ; // ST1 = x, ST0 = r
        align   4                   ;
    L2: fmul    ST,ST(1)            ; // r *= x
        fld     real ptr -12[EDX]   ;
        sub     EDX,12              ; // deg--
        faddp   ST(1),ST            ;
        dec     ECX                 ;
        jne     L2                  ;
        fxch    ST(1)               ; // ST1 = r, ST0 = x
        fstp    ST(0)               ; // dump x
        align   4                   ;
    return_ST:                      ;
        ;
        }
  } else {
        т_дельтаук i = A.length - 1;
        реал r = A[i];
        while (--i >= 0)
        {
            r *= x;
            r += A[i];
        }
        return r;
  }
}

package {
T рационалПоли(T)(T x, T [] числитель, T [] знаменатель)
{
    return поли(x, числитель)/поли(x, знаменатель);
}
}

extern(D):
/** Возвращает наименьшее число из x и y, отдавая предпочтение скорее числам, чем НЧ.
 *
 * Если все x и y являются числами, возвращается наименьшее.
 * Если все параметры являются НЧ, возвращается любое.
 * Если один параметр есть НЧ, а другой есть число, возвращается число
 * (это поведение определено в IEEE 754R, и  используется для
 * определения диапазона функции).
 */
реал минЧло(реал x, реал y) ;

/** Возвращает наибольшее число из x и y, отдавая предпочтение скорее числам, чем НЧ.
 *
 * Если все x и y являются числами, возвращается наибольшее.
 * Если все параметры являются НЧ, возвращается любое.
 * Если один параметр есть НЧ, а другой есть число, возвращается число
 * (это поведение определено в IEEE 754-2008, и  используется для
 * определения диапазона функции).
 */
реал максЧло(реал x, реал y) ;

/** Возвращает наименьшее из x и y, предпочитая НЧ числам.
 *
 * Если все x и y являются числами, возвращается наименьшее.
 * Если все параметры являются НЧ, возвращается любое.
 * Если один параметр есть НЧ, а другой есть число, возвращается  НЧ.
 */
реал минНч(реал x, реал y) ;

/** Возвращает наибольшее из x и y, предпочитая НЧ числам.
 *
 * Если все x и y являются числами, возвращается наибольшее.
 * Если все параметры являются НЧ, возвращается любое.
  * Если один параметр есть НЧ, а другой есть число, возвращается  НЧ.
 */
реал максНч(реал x, реал y) ;

/*****************************************
 * Синус, косинус и арктангенс нескольких из &pi;
 *
 * Для больших значений x сохраняется точность.
 */
реал косПи(реал x);

/** описано ранее */
реал синПи(реал x);

/** описано ранее */
реал атанПи(реал x);

/***********************************
 * Коммплексный инверсный синус
 *
 * асин(z) = -i лог( квкор(1-$(POWER z, 2)) + iz)
 * где и лог, и квкор комплексные.
 */
креал асин(креал z);

/***********************************
 * Комплексный инверсный косинус
 *
 * акос(z) = $(ПИ)/2 - асин(z)
 */
креал акос(креал z);


/***********************************
 *  Гиперболический синус, комплексное и мнимое
 *
 *  гсин(z) = кос(z.im)*гсин(z.re) + син(z.im)*гкос(z.re)i
 */
креал гсин(креал z);

/** описано ранее */
вреал гсин(вреал y);

/***********************************
 *  Гиперболический косинус, комплексное и мнимое
 *
 *  гкос(z) = кос(z.im)*гкос(z.re) + син(z.im)*гсин(z.re)i
 */
креал гкос(креал z);

/** описано ранее */
реал гкос(вреал y);


/** описано ранее */
креал гатан(вреал y);

/** описано ранее */
креал гатан(креал z);

/+
креал квкор(креал z);
+/

/***********************************
 * Экспоненциал, комплексное и мнимое
 *
 * Для комплексных чисел экспоненциальная функция определяется как:
 *
 *  эксп(z) = эксп(z.re)кос(z.im) + эксп(z.re)син(z.im)i.
 *
 *  Для мнимого аргумента:
 *  эксп(&тэта;i)  = кос(&тэта;) + син(&тэта;)i.
 *
 */
креал эксп(вреал y);

/** описано ранее */
креал эксп(креал z);

/***********************************
 * Натуральный логарифм, комплексное
 *
 * Возвращает комплексный логарифм к основанию e (2.718...) 
 * комплексного аргумента x.
 *
 * Если z = x + iy, то
 *       лог(z) = лог(абс(z)) + i arctan(y/x).
 *
 * Диапазон арктангенса от -ПИ до +ПИ.
 * Имеются отрезки ветвей по всем отрицательным реальным и отрицательным
 * мнимым осям. Для мнимых аргументов используется одна из следующих
 * форм, в зависимости от того, какая ветвь требуется.
 * ------------
 *    лог( 0.0 + yi) = лог(-y) + PI_2i  // y<=-0.0
 *    лог(-0.0 + yi) = лог(-y) - PI_2i  // y<=-0.0
 * ------------
 */
креал лог(креал z);

