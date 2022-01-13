/**
 * Cumulative Probability Distribution Functions
 *
 * Copyright: Based on the CEPHES math library, which is
 *            Copyright (C) 1994 Stephen L. Moshier (moshier@world.std.com).
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Stephen L. Moshier (original C код), Don Clugston
 */

/**
 * Macros:
 *  NAN = $(КРАСНЫЙ NAN)
 *  SUP = <вринтервал стиль="vertical-align:super;font-размер:smaller">$0</вринтервал>
 *  GAMMA =  &#915;
 *  INTEGRAL = &#8747;
 *  INTEGRATE = $(BIG &#8747;<подст>$(SMALL $1)</подст><sup>$2</sup>)
 *  POWER = $1<sup>$2</sup>
 *  BIGSUM = $(BIG &Sigma; <sup>$2</sup><подст>$(SMALL $1)</подст>)
 *  CHOOSE = $(BIG &#40;) <sup>$(SMALL $1)</sup><подст>$(SMALL $2)</подст> $(BIG &#41;)
 *  TABLE_SV = <таблица border=1 cellpadding=4 cellspacing=0>
 *      <caption>Special Values</caption>
 *      $0</таблица>
 *  SVH = $(TR $(TH $1) $(TH $2))
 *  SV  = $(TR $(TD $1) $(TD $2))
 */

module math.Probability;

extern(D):

/***
Cumulative ни в каком дистрибутиве function for the Нормальный ни в каком дистрибутиве, и its complement.

The нормаль (or Gaussian, либо bell-shaped) ни в каком дистрибутиве is
defined as:

normalDist(x) = 1/$(SQRT) &pi; $(INTEGRAL -$(INFINITY), x) эксп( - $(POWER t, 2)/2) dt
    = 0.5 + 0.5 * матош(x/квкор(2))
    = 0.5 * матошфунк(- x/квкор(2))

Note that
normalDistribution(x) = 1 - normalDistribution(-x).

Accuracy:
Within a few биты of machine resolution over the entire
range.

References:
$(LINK http://www.netlib.org/cephes/ldoubdoc.html),
G. Marsaglia, "Evaluating the Нормальный Distribution",
Journal of Statistical Software <b>11</b>, (July 2004).
*/
реал normalDistribution(реал a);

/** описано ранее */
реал normalDistributionCompl(реал a);

/******************************
 * Inverse of Нормальный ни в каком дистрибутиве function
 *
 * Возвращает the аргумент, x, for which the area under the
 * Нормальный probability density function (integrated из_
 * minus infinity в_ x) is equal в_ p.
 *
 * For small аргументы 0 < p < эксп(-2), the program computes
 * z = квкор( -2 лог(p) );  then the approximation is
 * x = z - лог(z)/z  - (1/z) P(1/z) / Q(1/z) .
 * For larger аргументы,  x/квкор(2 pi) = w + w^3 R(w^2)/S(w^2)) ,
 * where w = p - 0.5 .
 */
реал normalDistributionInv(реал p);

/** описано ранее */
реал normalDistributionComplInv(реал p);

/** Student's t cumulative ни в каком дистрибутиве function
 *
 * Computes the integral из_ minus infinity в_ t of the Student
 * t ни в каком дистрибутиве with целое nu > 0 degrees of freedom:
 *
 *   $(GAMMA)( (nu+1)/2) / ( квкор(nu &pi;) $(GAMMA)(nu/2) ) *
 * $(INTEGRATE -&infin;, t) $(POWER (1+$(POWER x, 2)/nu), -(nu+1)/2) dx
 *
 * Can be использован в_ тест whether the means of two normally distributed populations
 * are equal.
 *
 * It is related в_ the incomplete бета integral:
 *        1 - studentsDistribution(nu,t) = 0.5 * betaDistribution( nu/2, 1/2, z )
 * where
 *        z = nu/(nu + t<sup>2</sup>).
 *
 * For t < -1.6, this is the метод of computation.  For higher t,
 * a direct метод is производный из_ integration by части.
 * Since the function is symmetric about t=0, the area under the
 * право хвост of the density is найдено by calling the function
 * with -t instead of t.
 */
реал studentsTDistribution(цел nu, реал t);

/** Inverse of Student's t ни в каком дистрибутиве
 *
 * Given probability p и degrees of freedom nu,
 * finds the аргумент t such that the one-sопрed
 * studentsDistribution(nu,t) is equal в_ p.
 *
 * Параметры:
 * nu = degrees of freedom. Must be >1
 * p  = probability. 0 < p < 1
 */
реал studentsTDistributionInv(цел nu, реал p );

/** The F ни в каком дистрибутиве, its complement, и inverse.
 *
 * The F density function (also known as Snedcor's density or the
 * variance ratio density) is the density
 * of x = (u1/df1)/(u2/df2), where u1 и u2 are random
 * variables having $(POWER &chi;,2) distributions with df1
 * и df2 degrees of freedom, respectively.
 *
 * fDistribution returns the area из_ zero в_ x under the F density
 * function.   The complementary function,
 * fDistributionCompl, returns the area из_ x в_ &infin; under the F density function.
 *
 * The inverse of the complemented F ни в каком дистрибутиве,
 * fDistributionComplInv, finds the аргумент x such that the integral
 * из_ x в_ infinity of the F density is equal в_ the given probability y.
 *
 * Can be использован в_ тест whether the means of multИПle normally distributed
 * populations, все with the same стандарт deviation, are equal;
 * or в_ тест that the стандарт deviations of two normally distributed
 * populations are equal.
 *
 * Параметры:
 *  df1 = Degrees of freedom of the первый переменная. Must be >= 1
 *  df2 = Degrees of freedom of the секунда переменная. Must be >= 1
 *  x  = Must be >= 0
 */
реал fDistribution(цел df1, цел df2, реал x);
/** описано ранее */
реал fDistributionCompl(цел df1, цел df2, реал x);

/*
 * Inverse of complemented F ни в каком дистрибутиве
 *
 * Finds the F density аргумент x such that the integral
 * из_ x в_ infinity of the F density is equal в_ the
 * given probability p.
 *
 * This is accomplished using the inverse бета integral
 * function и the relations
 *
 *      z = бетаНеполнаяИнв( df2/2, df1/2, p ),
 *      x = df2 (1-z) / (df1 z).
 *
 * Note that the following relations hold for the inverse of
 * the uncomplemented F ни в каком дистрибутиве:
 *
 *      z = бетаНеполнаяИнв( df1/2, df2/2, p ),
 *      x = df2 z / (df1 (1-z)).
*/

/** описано ранее */
реал fDistributionComplInv(цел df1, цел df2, реал p );

/** $(POWER &chi;,2) cumulative ни в каком дистрибутиве function и its complement.
 *
 * Возвращает the area under the лево hand хвост (из_ 0 в_ x)
 * of the Chi square probability density function with
 * знач degrees of freedom. The complement returns the area under
 * the право hand хвост (из_ x в_ &infin;).
 *
 *  chiSqrDistribution(x | знач) = ($(INTEGRATE 0, x)
 *          $(POWER t, знач/2-1) $(POWER e, -t/2) dt )
 *             / $(POWER 2, знач/2) $(GAMMA)(знач/2)
 *
 *  chiSqrDistributionCompl(x | знач) = ($(INTEGRATE x, &infin;)
 *          $(POWER t, знач/2-1) $(POWER e, -t/2) dt )
 *             / $(POWER 2, знач/2) $(GAMMA)(знач/2)
 *
 * Параметры:
 *  знач  = degrees of freedom. Must be positive.
 *  x  = the $(POWER &chi;,2) переменная. Must be positive.
 *
 */
реал chiSqrDistribution(реал знач, реал x);
/** описано ранее */
реал chiSqrDistributionCompl(реал знач, реал x);

/**
 *  Inverse of complemented $(POWER &chi;, 2) ни в каком дистрибутиве
 *
 * Finds the $(POWER &chi;, 2) аргумент x such that the integral
 * из_ x в_ &infin; of the $(POWER &chi;, 2) density is equal
 * в_ the given cumulative probability p.
 *
 * Параметры:
 * p = Cumulative probability. 0<= p <=1.
 * знач = Degrees of freedom. Must be positive.
 *
 */
реал chiSqrDistributionComplInv(реал знач, реал p);

/**
 * The &Gamma; ни в каком дистрибутиве и its complement
 *
 * The &Gamma; ни в каком дистрибутиве is defined as the integral из_ 0 в_ x of the
 * гамма probability density function. The complementary function returns the
 * integral из_ x в_ &infin;
 *
 * gammaDistribution = ($(INTEGRATE 0, x) $(POWER t, b-1)$(POWER e, -at) dt) $(POWER a, b)/&Gamma;(b)
 *
 * x must be greater than 0.
 */
реал gammaDistribution(реал a, реал b, реал x);

/** описано ранее */
реал gammaDistributionCompl(реал a, реал b, реал x );

/**********************
 *  Beta ни в каком дистрибутиве и its inverse
 *
 * Возвращает the incomplete бета integral of the аргументы, evaluated
 * из_ zero в_ x.  The function is defined as
 *
 * betaDistribution = &Gamma;(a+b)/(&Gamma;(a) &Gamma;(b)) *
 * $(INTEGRATE 0, x) $(POWER t, a-1)$(POWER (1-t),b-1) dt
 *
 * The домен of definition is 0 <= x <= 1.  In this
 * implementation a и b are restricted в_ positive значения.
 * The integral из_ x в_ 1 may be obtained by the symmetry
 * relation
 *
 *    betaDistributionCompl(a, b, x )  =  betaDistribution( b, a, 1-x )
 *
 * The integral is evaluated by a continued дво expansion
 * or, when b*x is small, by a power series.
 *
 * The inverse finds the значение of x for which betaDistribution(a,b,x) - y = 0
 */
реал betaDistribution(реал a, реал b, реал x );

/** описано ранее */
реал betaDistributionCompl(реал a, реал b, реал x);

/** описано ранее */
реал betaDistributionInv(реал a, реал b, реал y);

/** описано ранее */
реал betaDistributionComplInv(реал a, реал b, реал y);

/**
 * The Poisson ни в каком дистрибутиве, its complement, и inverse
 *
 * ключ is the число of события. m is the mean.
 * The Poisson ни в каком дистрибутиве is defined as the sum of the первый ключ terms of
 * the Poisson density function.
 * The complement returns the sum of the terms ключ+1 в_ &infin;.
 *
 * poissonDistribution = $(BIGSUM j=0, ключ) $(POWER e, -m) $(POWER m, j)/j!
 *
 * poissonDistributionCompl = $(BIGSUM j=ключ+1, &infin;) $(POWER e, -m) $(POWER m, j)/j!
 *
 * The terms are not summed directly; instead the incomplete
 * гамма integral is employed, according в_ the relation
 *
 * y = poissonDistribution( ключ, m ) = гаммаНеполнаяКомпл( ключ+1, m ).
 *
 * The аргументы must Всё be positive.
 */
реал poissonDistribution(цел ключ, реал m );
/** описано ранее */
реал poissonDistributionCompl(цел ключ, реал m );

/** описано ранее */
реал poissonDistributionInv( цел ключ, реал p );

/***********************************
 *  Binomial ни в каком дистрибутиве и complemented binomial ни в каком дистрибутиве
 *
 * The binomial ни в каком дистрибутиве is defined as the sum of the terms 0 through ключ
 * of the Binomial probability density.
 * The complement returns the sum of the terms ключ+1 through n.
 *
 binomialDistribution = $(BIGSUM j=0, ключ) $(CHOOSE n, j) $(POWER p, j) $(POWER (1-p), n-j)

 binomialDistributionCompl = $(BIGSUM j=ключ+1, n) $(CHOOSE n, j) $(POWER p, j) $(POWER (1-p), n-j)
 *
 * The terms are not summed directly; instead the incomplete
 * бета integral is employed, according в_ the formula
 *
 * y = binomialDistribution( ключ, n, p ) = betaDistribution( n-ключ, ключ+1, 1-p ).
 *
 * The аргументы must be positive, with p ranging из_ 0 в_ 1, и ключ<=n.
 */
реал binomialDistribution(цел ключ, цел n, реал p );
/** описано ранее */
реал binomialDistributionCompl(цел ключ, цел n, реал p );
 
/** Inverse binomial ни в каком дистрибутиве
 *
 * Finds the событие probability p such that the sum of the
 * terms 0 through ключ of the Binomial probability density
 * is equal в_ the given cumulative probability y.
 *
 * This is accomplished using the inverse бета integral
 * function и the relation
 *
 * 1 - p = betaDistributionInv( n-ключ, ключ+1, y ).
 *
 * The аргументы must be positive, with 0 <= y <= 1, и ключ <= n.
 */
реал binomialDistributionInv( цел ключ, цел n, реал y );

/** Negative binomial ни в каком дистрибутиве и its inverse
 *
 * Возвращает the sum of the terms 0 through ключ of the негатив
 * binomial ни в каком дистрибутиве:
 *
 * $(BIGSUM j=0, ключ) $(CHOOSE n+j-1, j-1) $(POWER p, n) $(POWER (1-p), j)
 *
 * In a sequence of Bernoulli trials, this is the probability
 * that ключ or fewer failures precede the n-th success.
 *
 * The аргументы must be positive, with 0 < p < 1 и r>0.
 *
 * The inverse finds the аргумент y such
 * that negativeBinomialDistribution(ключ,n,y) is equal в_ p.
 *
 * The Geometric Distribution is a special case of the негатив binomial
 * ни в каком дистрибутиве.
 * -----------------------
 * geometricDistribution(ключ, p) = negativeBinomialDistribution(ключ, 1, p);
 * -----------------------
 * References:
 * $(LINK http://mathworld.wolfram.com/NegativeBinomialDistribution.html)
 */

реал negativeBinomialDistribution(цел ключ, цел n, реал p );

/** описано ранее */
реал negativeBinomialDistributionInv(цел ключ, цел n, реал p );