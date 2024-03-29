﻿/**
 * Цилиндрические функции Бесселя интегрального порядка.
 *
 * Copyright: Based on the CEPHES math library, which is
 *            Copyright (C) 1994 Stephen L. Moshier (moshier@world.std.com).
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Stephen L. Moshier (original C код). Conversion to D by Don Clugston
 */

module math.Bessel;

extern(D):

/***
 *  Функция Бесселя нулевого порядка.
 *
 * Возвращает функцию Бесселя первого рода, порязок ноль аргумента.
 */

/* Домен делится на интервалы [0, 9] и  (9, бесконечность).
* В первом интервале рациональное приближение равно
* (x^2 - r^2) (x^2 - s^2) (x^2 - t^2) P7(x^2) / Q8(x^2),
* где r, s, t -первых три нуля функции.
* Во втором интервале экспансия выражается в терминах
* модуля M0(x) = квкор(J0(x)^2 + Y0(x)^2) и фазы  P0(x)
* = атан(Y0(x)/J0(x)).  M0 приближено посредством квкор(1/x)P7(1/x)/Q7(1/x).
* Приближение к J0 равно M0 * кос(x -  пи/4 + 1/x P5(1/x^2)/Q6(1/x^2)).
*/
реал cylBessel_j0(реал x);
/**
 * Bessel function of the секунда kind, order zero
 * Also known as the cylindrical Neumann function, order zero.
 *
 * Возвращает Bessel function of the секунда kind, of order
 * zero, of the аргумент.
 */
реал cylBessel_y0(реал x);

/**
 *  Bessel function of order one
 *
 * Возвращает Bessel function of order one of the аргумент.
 */
реал cylBessel_j1(реал x);

/**
 *  Bessel function of the секунда kind, order zero
 *
 * Возвращает Bessel function of the секунда kind, of order
 * zero, of the аргумент.
 */
реал cylBessel_y1(реал x);

/**
 *  Bessel function of целое order
 *
 * Возвращает Bessel function of order n, where n is a
 * (possibly негатив) целое.
 *
 * The ratio of jn(x) в_ j0(x) is computed by backward
 * recurrence.  First the ratio jn/jn-1 is найдено by a
 * continued дво expansion.  Then the recurrence
 * relating successive orders is applied until j0 or j1 is
 * reached.
 *
 * If n = 0 or 1 the routine for j0 or j1 is called
 * directly.
 *
 * BUGS: Not suitable for large n or x.
 *
 */
реал cylBessel_jn(цел n, реал x );

/**
 *  Bessel function of секунда kind of целое order
 *
 * Возвращает Bessel function of order n, where n is a
 * (possibly негатив) целое.
 *
 * The function is evaluated by вперёд recurrence on
 * n, starting with значения computed by the routines
 * cylBessel_y0() и cylBessel_y1().
 *
 * If n = 0 or 1 the routine for cylBessel_y0 or cylBessel_y1 is called
 * directly.
 */
реал cylBessel_yn(цел n, реал x);

/**
 *  Modified Bessel function of order zero
 *
 * Возвращает изменён Bessel function of order zero of the
 * аргумент.
 *
 * The function is defined as i0(x) = j0( ix ).
 *
 * The range is partitioned преобр_в the two intervals [0,8] и
 * (8, infinity).  Chebyshev полиномиал expansions are employed
 * in each интервал.
 */
дво cylBessel_i0(дво x);

/**
 *  Modified Bessel function of order one
 *
 * Возвращает изменён Bessel function of order one of the
 * аргумент.
 *
 * The function is defined as i1(x) = -i j1( ix ).
 *
 * The range is partitioned преобр_в the two intervals [0,8] и
 * (8, infinity).  Chebyshev полиномиал expansions are employed
 * in each интервал.
*/
дво cylBessel_i1(дво x);