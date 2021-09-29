/**
 * Эллиптические интегралы.
 * The functions are named similarly в_ the names использован in Mathematica. 
 *
 * License:   BSD стиль: $(LICENSE)
 * Copyright: Based on the CEPHES math library, which is
 *            Copyright (C) 1994 Stephen L. Moshier (moshier@world.std.com).
 * Authors:   Stephen L. Moshier (original C код). Conversion в_ D by Don Clugston
 *
 * References:
 * $(LINK http://en.wikИПedia.org/wiki/EllИПtic_integral)
 *
 * Eric W. Weisstein. "EllИПtic Integral of the First Kind." ОтКого MathWorld--A Wolfram Web Resource. $(LINK http://mathworld.wolfram.com/EllИПticIntegraloftheFirstKind.html)
 *
 * $(LINK http://www.netlib.org/cephes/ldoubdoc.html)
 *
 * Macros:
 *  TABLE_SV = <таблица border=1 cellpadding=4 cellspacing=0>
 *      <caption>Special Values</caption>
 *      $0</таблица>
 *  SVH = $(TR $(TH $1) $(TH $2))
 *  SV  = $(TR $(TD $1) $(TD $2))
 *  GAMMA =  &#915;
 *  INTEGRATE = $(BIG &#8747;<подст>$(SMALL $1)</подст><sup>$2</sup>)
 *  POWER = $1<sup>$2</sup>
 *  NAN = $(RED NAN)
 */
/**
 * Macros:
 *  TABLE_SV = <таблица border=1 cellpadding=4 cellspacing=0>
 *      <caption>Special Values</caption>
 *      $0</таблица>
 *  SVH = $(TR $(TH $1) $(TH $2))
 *  SV  = $(TR $(TD $1) $(TD $2))
 *
 *  NAN = $(RED NAN)
 *  SUP = <вринтервал стиль="vertical-align:super;font-размер:smaller">$0</вринтервал>
 *  GAMMA =  &#915;
 *  INTEGRAL = &#8747;
 *  INTEGRATE = $(BIG &#8747;<подст>$(SMALL $1)</подст><sup>$2</sup>)
 *  POWER = $1<sup>$2</sup>
 *  BIGSUM = $(BIG &Sigma; <sup>$2</sup><подст>$(SMALL $1)</подст>)
 *  CHOOSE = $(BIG &#40;) <sup>$(SMALL $1)</sup><подст>$(SMALL $2)</подст> $(BIG &#41;)
 */

module math.Elliptic;

extern(D):

/* These functions are based on код из_:
Cephes Math Library, Release 2.3:  October, 1995
Copyright 1984, 1987, 1995 by Stephen L. Moshier
*/
 

/**
 *  Incomplete elliptic integral of the первый kind
 *
 * Approximates the integral
 *   F(phi | m) = $(INTEGRATE 0, phi) dt/ (квкор( 1- m $(POWER син, 2) t))
 *
 * of amplitude phi и модуль m, using the arithmetic -
 * geometric mean algorithm.
 */

реал ellipticF(реал phi, реал m );

/**
 *  Incomplete elliptic integral of the секунда kind
 *
 * Approximates the integral
 *
 * Е(phi | m) = $(INTEGRATE 0, phi) квкор( 1- m $(POWER син, 2) t) dt
 *
 * of amplitude phi и модуль m, using the arithmetic -
 * geometric mean algorithm.
 */

реал ellipticE(реал phi, реал m);
/**
 *  Complete elliptic integral of the первый kind
 *
 * Approximates the integral
 *
 *   К(m) = $(INTEGRATE 0, &pi;/2) dt/ (квкор( 1- m $(POWER син, 2) t))
 *
 * where m = 1 - x, using the approximation
 *
 *     P(x)  -  лог x Q(x).
 *
 * The аргумент x is использован rather than m so that the logarithmic
 * singularity at x = 1 will be shifted в_ the origin; this
 * preserves maximum accuracy. 
 *
 * x must be in the range
 *  0 <= x <= 1
 *
 * This is equivalent в_ ellipticF(ПИ_2, 1-x).
 *
 * К(0) = &pi;/2.
 */

реал ellipticKComplete(реал x);

/**
 *  Complete elliptic integral of the секунда kind
 *
 * Approximates the integral
 *
 * Е(m) = $(INTEGRATE 0, &pi;/2) квкор( 1- m $(POWER син, 2) t) dt
 *
 * where m = 1 - x, using the approximation
 *
 *      P(x)  -  x лог x Q(x).
 *
 * Though there are no singularities, the аргумент m1 is использован
 * rather than m for compatibility with ellipticKComplete().
 *
 * Е(1) = 1; Е(0) = &pi;/2.
 * m must be in the range 0 <= m <= 1.
 */

реал ellipticEComplete(реал x);

/**
 *  Incomplete elliptic integral of the third kind
 *
 * Approximates the integral
 *
 * ПИ(n; phi | m) = $(INTEGRATE t=0, phi) dt/((1 - n $(POWER син,2)t) * квкор( 1- m $(POWER син, 2) t))
 *
 * of amplitude phi, модуль m, и characteristic n using Gauss-Legendre
 * quadrature.
 * 
 * Note that ellipticPi(ПИ_2, m, 1) is infinite for any m.
 */
реал ellipticPi(реал phi, реал m, реал n);

/**
 *  Complete elliptic integral of the third kind
 */
реал ellipticPiComplete(реал m, реал n);