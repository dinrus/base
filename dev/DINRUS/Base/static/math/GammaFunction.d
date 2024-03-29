﻿/**
 * Реализует функции гамма и бета, их интегралы.
 *
 * License:   BSD стиль: $(LICENSE)
 * Copyright: Based on the CEPHES math library, which is
 *            Copyright (C) 1994 Stephen L. Moshier (moshier@world.std.com).
 * Authors:   Stephen L. Moshier (original C код). Conversion в_ D by Don Clugston
 *
 *
Macros:
 *  TABLE_SV = <таблица border=1 cellpadding=4 cellspacing=0>
 *      <caption>Special Values</caption>
 *      $0</таблица>
 *  SVH = $(TR $(TH $1) $(TH $2))
 *  SV  = $(TR $(TD $1) $(TD $2))
 *  GAMMA =  &#915;
 *  INTEGRATE = $(BIG &#8747;<подст>$(SMALL $1)</подст><sup>$2</sup>)
 *  POWER = $1<sup>$2</sup>
 *  NAN = $(КРАСНЫЙ NAN)
 */
module math.GammaFunction;

/// Максимальное значение x , для которого гамма(x) < реал.infinity.
const реал МАКСГАММА = 1755.5483429L;

extern(D):

/****************
 * The знак of $(GAMMA)(x).
 *
 * Возвращает -1 if $(GAMMA)(x) < 0,  +1 if $(GAMMA)(x) > 0,
 * $(NAN) if знак is indeterminate.
 */
реал знакГаммы(реал x);

/*****************************************************
 *  The Gamma function, $(GAMMA)(x)
 *
 *  $(GAMMA)(x) is a generalisation of the factorial function
 *  в_ реал и комплексное numbers.
 *  Like x!, $(GAMMA)(x+1) = x*$(GAMMA)(x).
 *
 *  Mathematically, if z.re > 0 then
 *   $(GAMMA)(z) = $(INTEGRATE 0, &infin;) $(POWER t, z-1)$(POWER e, -t) dt
 *
 *  $(TABLE_SV
 *    $(SVH  x,          $(GAMMA)(x) )
 *    $(SV  $(NAN),      $(NAN)      )
 *    $(SV  &plusmn;0.0, &plusmn;&infin;)
 *    $(SV целое > 0,  (x-1)!      )
 *    $(SV целое < 0,  $(NAN)      )
 *    $(SV +&infin;,     +&infin;    )
 *    $(SV -&infin;,     $(NAN)      )
 *  )
 */
реал гамма(реал x);

/*****************************************************
 * Natural logarithm of гамма function.
 *
 * Возвращает the основа e (2.718...) logarithm of the абсолютный
 * значение of the гамма function of the аргумент.
 *
 * For reals, логГаммы is equivalent в_ лог(фабс(гамма(x))).
 *
 *  $(TABLE_SV
 *    $(SVH  x,             логГаммы(x)   )
 *    $(SV  $(NAN),         $(NAN)      )
 *    $(SV целое <= 0,    +&infin;    )
 *    $(SV &plusmn;&infin;, +&infin;    )
 *  )
 */
реал логГаммы(реал x);

/** Beta function
 *
 * The бета function is defined as
 *
 * бета(x, y) = (&Gamma;(x) &Gamma;(y))/&Gamma;(x + y)
 */
реал бета(реал x, реал y);

/** Incomplete бета integral
 *
 * Возвращает incomplete бета integral of the аргументы, evaluated
 * из_ zero в_ x. The regularized incomplete бета function is defined as
 *
 * бетаНеполная(a, b, x) = &Gamma;(a+b)/(&Gamma;(a) &Gamma;(b)) *
 * $(INTEGRATE 0, x) $(POWER t, a-1)$(POWER (1-t),b-1) dt
 *
 * и is the same as the the cumulative ни в каком дистрибутиве function.
 *
 * The домен of definition is 0 <= x <= 1.  In this
 * implementation a и b are restricted в_ positive значения.
 * The integral из_ x в_ 1 may be obtained by the symmetry
 * relation
 *
 *    betaIncompleteCompl(a, b, x )  =  бетаНеполная( b, a, 1-x )
 *
 * The integral is evaluated by a continued дво expansion
 * or, when b*x is small, by a power series.
 */
реал бетаНеполная(реал aa, реал bb, реал xx );

/** Inverse of incomplete бета integral
 *
 * Given y, the function finds x such that
 *
 *  бетаНеполная(a, b, x) == y
 *
 *  Newton iterations or интервал halving is использован.
 */
реал бетаНеполнаяИнв(реал aa, реал bb, реал yy0 );

/***************************************
 *  Incomplete гамма integral и its complement
 *
 * These functions are defined by
 *
 *   гаммаНеполная = ( $(INTEGRATE 0, x) $(POWER e, -t) $(POWER t, a-1) dt )/ $(GAMMA)(a)
 *
 *  гаммаНеполнаяКомпл(a,x)   =   1 - гаммаНеполная(a,x)
 * = ($(INTEGRATE x, &infin;) $(POWER e, -t) $(POWER t, a-1) dt )/ $(GAMMA)(a)
 *
 * In this implementation Всё аргументы must be positive.
 * The integral is evaluated by either a power series or
 * continued дво expansion, depending on the relative
 * значения of a и x.
 */
реал гаммаНеполная(реал a, реал x );
/** описано ранее */
реал гаммаНеполнаяКомпл(реал a, реал x );

/** Inverse of complemented incomplete гамма integral
 *
 * Given a и y, the function finds x such that
 *
 *  гаммаНеполнаяКомпл( a, x ) = p.
 *
 * Starting with the approximate значение x = a $(POWER t, 3), where
 * t = 1 - d - normalDistributionInv(p) квкор(d),
 * и d = 1/9a,
 * the routine performs up в_ 10 Newton iterations в_ найди the
 * корень of incompleteGammaCompl(a,x) - p = 0.
 */
реал гаммаНеполнаяКомплИнв(реал a, реал p);

/** Digamma function
*
*   дигамма function is the logarithmic derivative of the гамма function.
*
*  дигамма(x) = d/dx логГаммы(x)
*
*/
реал дигамма(реал x);