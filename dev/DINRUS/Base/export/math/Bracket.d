﻿/** Алгоритм для поиска корней и экстрем одноаргументных реальных функций
 * с использованием брэкетинга.
 *
 * Copyright: Copyright (C) 2008 Don Clugston.
 * License:   BSD стиль: $(LICENSE), Digital Mars.
 * Authors:   Don Clugston.
 *
 */
module math.Bracket;
import math.Math;
import math.IEEE;

alias math.Math.копируйзнак копируйзнак;
alias math.Math.фабс фабс;
private:

// return да, если a и b have opposite знак
бул противоположныеЗнаки(T)(T a, T b)
{
    return (битзнака(a) ^ битзнака(b))!=0;
}

// TODO: This should be exposed publically, but needs a better имя.
struct БрэкетРез(T, R)
{
    T xlo;
    T xhi;
    R fxlo;
    R fxhi;
}

public:

/**  Find a реал корень of the реал function f(x) via bracketing.
 *
 * Given a range [a..b] such that f(a) и f(b) have opposite знак,
 * returns the значение of x in the range which is closest в_ a корень of f(x).
 * If f(x) имеется ещё than one корень in the range, one will be chosen arbitrarily.
 * If f(x) returns $(NAN), $(NAN) will be returned; иначе, this algorithm
 * is guaranteed в_ succeed.
 *
 * Uses an algorithm based on TOMS748, which uses inverse cubic interpolation
 * whenever possible, иначе reverting в_ parabolic or secant
 * interpolation. Compared в_ TOMS748, this implementation improves worst-case
 * performance by a фактор of ещё than 100, и typical performance by a фактор
 * of 2. For 80-bit reals, most problems require 8 - 15 calls в_ f(x) в_ achieve
 * full machine точность. The worst-case performance (pathological cases) is
 * approximately twice the число of биты.
 *
 * References:
 * "On Enclosing Simple Roots of Nonlinear Equations", G. Alefeld, F.A. Potra,
 *   Yixun Shi, Mathematics of Computation 61, pp733-744 (1993).
 *   Fortran код available из_ www.netlib.org as algorithm TOMS478.
 *
 */
T найдиКорень(T, R)(R delegate(T) f, T ax, T bx)
{
    auto r = найдиКорень(f, ax, bx, f(ax), f(bx), (БрэкетРез!(T,R) r)
    {
        return r.xhi==следщВыше(r.xlo);
    });
    return фабс(r.fxlo)<=фабс(r.fxhi) ? r.xlo : r.xhi;
}

private:

/** Find корень by bracketing, allowing termination condition в_ be specified
 *
 * Параметры:
 * tolerance   Defines the termination condition. Возвращает да when acceptable
 *             bounds have been obtained.
 */
БрэкетРез!(T, R) найдиКорень(T,R)(R delegate(T) f, T ax, T bx, R fax, R fbx,
        бул delegate(БрэкетРез!(T,R) r) tolerance)
in
{
    assert(ax<=bx, "Параметры ax и bx out of order.");
    assert(ax<>=0 && bx<>=0, "Limits must not be NAN");
    assert(противоположныеЗнаки(fax,fbx), "Параметры must bracket the root.");
}
body
{
// This код is (heavily) изменён из_ TOMS748 (www.netlib.org). Some опрeas
// were borrowed из_ the Boost Mathematics Library.

    T a = ax, b = bx, d;  // [a..b] is our текущ bracket.
    R fa = fax, fb = fbx, fd; // d is the third best guess.

    // Test the function at точка c; обнови brackets accordingly
    проц bracket(T c)
    {
        T fc = f(c);
        if (fc == 0)   // Exact solution
        {
            a = c;
            fa = fc;
            d = c;
            fd = fc;
            return;
        }
        // Determine new enclosing интервал
        if (противоположныеЗнаки(fa, fc))
        {
            d = b;
            fd = fb;
            b = c;
            fb = fc;
        }
        else
        {
            d = a;
            fd = fa;
            a = c;
            fa = fc;
        }
    }

    /* Perform a secant interpolation. If the результат would lie on a or b, либо if
      a и b differ so wildly in magnitude that the результат would be meaningless,
      выполни a bisection instead.
     */
    T secant_interpolate(T a, T b, T fa, T fb)
    {
        if (( ((a - b) == a) && b!=0) || (a!=0 && ((b - a) == b)))
        {
            // Catastrophic cancellation
            if (a == 0) a = копируйзнак(0.0L, b);
            else if (b == 0) b = копируйзнак(0.0L, a);
            else if (противоположныеЗнаки(a, b)) return 0;
            T c = и3еСреднее(a, b);
            return c;
        }
        // avoопр перебор
        if (b - a > T.max)    return b / 2.0 + a / 2.0;
        if (fb - fa > T.max)  return a - (b - a) / 2;
        T c = a - (fa / (fb - fa)) * (b - a);
        if (c == a || c == b) return (a + b) / 2;
        return c;
    }

    /* Uses 'numsteps' newton steps в_ approximate the zero in [a..b] of the
       quadratic полиномиал interpolating f(x) at a, b, и d.
       Возвращает:
         The approximate zero in [a..b] of the quadratic полиномиал.
    */
    T newtonQuadratic(цел numsteps)
    {
        // Find the coefficients of the quadratic полиномиал.
        T a0 = fa;
        T a1 = (fb - fa)/(b - a);
        T a2 = ((fd - fb)/(d - b) - a1)/(d - a);

        // Determine the starting точка of newton steps.
        T c = противоположныеЗнаки(a2, fa) ? a  : b;

        // старт the safeguarded newton steps.
        for (цел i = 0; i<numsteps; ++i)
        {
            T pc = a0 + (a1 + a2 * (c - b))*(c - a);
            T pdc = a1 + a2*((2.0 * c) - (a + b));
            if (pdc == 0) return a - a0 / a1;
            else c = c - pc / pdc;
        }
        return c;
    }

    // On the первый iteration we возьми a secant step:
    if(fa != 0)
    {
        bracket(secant_interpolate(a, b, fa, fb));
    }
    // Starting with the секунда iteration, higher-order interpolation can
    // be использован.
    цел itnum = 1;   // Iteration число
    цел baditer = 1; // Чис bisections в_ возьми if an iteration is bad.
    T c, e;  // e is our fourth best guess
    R fe;
whileloop:
    while((fa != 0) && !tolerance(БрэкетРез!(T,R)(a, b, fa, fb)))
    {
        T a0 = a, b0 = b; // record the brackets

        // Do two higher-order (cubic or parabolic) interpolation steps.
        for (цел QQ = 0; QQ < 2; ++QQ)
        {
            // Cubic inverse interpolation требует that
            // все four function значения fa, fb, fd, и fe are distinct;
            // иначе use quadratic interpolation.
            бул distinct = (fa != fb) && (fa != fd) && (fa != fe)
                              && (fb != fd) && (fb != fe) && (fd != fe);
            // The первый время, cubic interpolation is impossible.
            if (itnum<2) distinct = нет;
            бул ok = distinct;
            if (distinct)
            {
                // Cubic inverse interpolation of f(x) at a, b, d, и e
                реал q11 = (d - e) * fd / (fe - fd);
                реал q21 = (b - d) * fb / (fd - fb);
                реал q31 = (a - b) * fa / (fb - fa);
                реал d21 = (b - d) * fd / (fd - fb);
                реал d31 = (a - b) * fb / (fb - fa);

                реал q22 = (d21 - q11) * fb / (fe - fb);
                реал q32 = (d31 - q21) * fa / (fd - fa);
                реал d32 = (d31 - q21) * fd / (fd - fa);
                реал q33 = (d32 - q22) * fa / (fe - fa);
                c = a + (q31 + q32 + q33);
                if (c!<>=0 || (c <= a) || (c >= b))
                {
                    // DAC: If the interpolation predicts a or b, it's
                    // probable that it's the actual корень. Only allow this if
                    // we're already закрой в_ the корень.
                    if (c == a && a - b != a)
                    {
                        c = следщВыше(a);
                    }
                    else if (c == b && a - b != -b)
                    {
                        c = следщНиже(b);
                    }
                    else
                    {
                        ok = нет;
                    }
                }
            }
            if (!ok)
            {
                c = newtonQuadratic(distinct ? 3 : 2);
                if(c!<>=0 || (c <= a) || (c >= b))
                {
                    // Failure, try a secant step:
                    c = secant_interpolate(a, b, fa, fb);
                }
            }
            ++itnum;
            e = d;
            fe = fd;
            bracket(c);
            if((fa == 0) || tolerance(БрэкетРез!(T,R)(a, b, fa, fb)))
                break whileloop;
            if (itnum == 2)
                continue whileloop;
        }
        // Сейчас we возьми a дво-length secant step:
        T u;
        R fu;
        if(фабс(fa) < фабс(fb))
        {
            u = a;
            fu = fa;
        }
        else
        {
            u = b;
            fu = fb;
        }
        c = u - 2 * (fu / (fb - fa)) * (b - a);
        // DAC: If the secant predicts a значение equal в_ an endpoint, it's
        // probably нет.
        if(c==a || c==b || c!<>=0 || фабс(c - u) > (b - a) / 2)
        {
            if ((a-b) == a || (b-a) == b)
            {
                if ( (a>0 && b<0) || (a<0 && b>0) ) c = 0;
                else
                {
                    if (a==0) c = и3еСреднее(копируйзнак(0.0L, b), b);
                    else if (b==0) c = и3еСреднее(копируйзнак(0.0L, a), a);
                    else c = и3еСреднее(a, b);
                }
            }
            else
            {
                c = a + (b - a) / 2;
            }
        }
        e = d;
        fe = fd;
        bracket(c);
        if((fa == 0) || tolerance(БрэкетРез!(T,R)(a, b, fa, fb)))
            break;

        // We must ensure that the bounds reduce by a фактор of 2
        // (DAC: in binary пространство!) every iteration. If we haven't achieved this
        // yet (DAC: or if we don't yet know что the exponent is),
        // выполни a binary chop.

        if( (a==0 || b==0 ||
                (фабс(a) >= 0.5 * фабс(b) && фабс(b) >= 0.5 * фабс(a)))
                &&  (b - a) < 0.25 * (b0 - a0))
        {
            baditer = 1;
            continue;
        }
        // DAC: If this happens on consecutive iterations, we probably have a
        // pathological function. Perform a число of bisections equal в_ the
        // total число of consecutive bad iterations.

        if ((b - a) < 0.25 * (b0 - a0)) baditer=1;
        for (цел QQ = 0; QQ < baditer ; ++QQ)
        {
            e = d;
            fe = fd;

            T w;
            if ((a>0 && b<0) ||(a<0 && b>0)) w = 0;
            else
            {
                T usea = a;
                T useb = b;
                if (a == 0) usea = копируйзнак(0.0L, b);
                else if (b == 0) useb = копируйзнак(0.0L, a);
                w = и3еСреднее(usea, useb);
            }
            bracket(w);
        }
        ++baditer;
    }

    if (fa == 0) return БрэкетРез!(T, R)(a, a, fa, fa);
    else if (fb == 0) return БрэкетРез!(T, R)(b, b, fb, fb);
    else return БрэкетРез!(T, R)(a, b, fa, fb);
}

public:
/**
 * Find the minimum значение of the function функц().
 *
 * Возвращает the значение of x such that функц(x) is minimised. Uses Brent's метод,
 * which uses a parabolic fit в_ rapопрly approach the minimum but reverts в_ a
 * Golden Section ищи where necessary.
 *
 * The minimum is located в_ an accuracy of отнравх(min, truemin) <
 * реал.mant_dig/2.
 *
 * Параметры:
 *     функц         The function в_ be minimized
 *     xinitial     Initial guess в_ be использован.
 *     xlo, xhi     Upper и lower bounds on x.
 *                  функц(xinitial) <= функц(x1) и функц(xinitial) <= функц(x2)
 *     funcMin      The minimum значение of функц(x).
 */
T найдиМинимум(T,R)(R delegate(T) функц, T xlo, T xhi, T xinitial,
                                out R funcMin)
in
{
    assert(xlo <= xhi);
    assert(xinitial >= xlo);
    assert(xinitial <= xhi);
    assert(функц(xinitial) <= функц(xlo) && функц(xinitial) <= функц(xhi));
}
body
{
    // Based on the original Algol код by R.P. Brent.
    const реал GOLDENRATIO = 0.3819660112501051; // (3 - квкор(5))/2 = 1 - 1/phi

    T stepBeforeLast = 0.0;
    T lastStep;
    T bestx = xinitial; // the best значение so far (min значение for f(x)).
    R fbest = функц(bestx);
    T секунда = xinitial;  // the точка with the секунда best значение of f(x)
    R fsecond = fbest;
    T third = xinitial;  // the previous значение of секунда.
    R fthird = fbest;
    цел numiter = 0;
    for (;;)
    {
        ++numiter;
        T xmопр = 0.5 * (xlo + xhi);
        const реал SQRTEPSILON = 3e-10L; // квкор(реал.epsilon)
        T tol1 = SQRTEPSILON * фабс(bestx);
        T tol2 = 2.0 * tol1;
        if (фабс(bestx - xmопр) <= (tol2 - 0.5*(xhi - xlo)) )
        {
            funcMin = fbest;
            return bestx;
        }
        if (фабс(stepBeforeLast) > tol1)
        {
            // trial parabolic fit
            реал r = (bestx - секунда) * (fbest - fthird);
            // DAC: This can be infinite, in which case lastStep will be НЧ.
            реал denom = (bestx - third) * (fbest - fsecond);
            реал numerator = (bestx - third) * denom - (bestx - секунда) * r;
            denom = 2.0 * (denom-r);
            if ( denom > 0) numerator = -numerator;
            denom = фабс(denom);
            // is the parabolic fit good enough?
            // it must be a step that is less than half the movement
            // of the step перед последний, AND it must fall
            // преобр_в the bounding интервал [xlo,xhi].
            if (фабс(numerator) >= фабс(0.5 * denom * stepBeforeLast)
                    || numerator <= denom*(xlo-bestx)
                    || numerator >= denom*(xhi-bestx))
            {
                // No, use a golden section ищи instead.
                // Step преобр_в the larger of the two segments.
                stepBeforeLast = (bestx >= xmопр) ? xlo - bestx : xhi - bestx;
                lastStep = GOLDENRATIO * stepBeforeLast;
            }
            else
            {
                // parabola is ОК
                stepBeforeLast = lastStep;
                lastStep = numerator/denom;
                реал xtest = bestx + lastStep;
                if (xtest-xlo < tol2 || xhi-xtest < tol2)
                {
                    if (xmопр-bestx > 0)
                        lastStep = tol1;
                    else lastStep = -tol1;
                }
            }
        }
        else
        {
            // Use a golden section ищи instead
            stepBeforeLast = bestx >= xmопр ? xlo - bestx : xhi - bestx;
            lastStep = GOLDENRATIO * stepBeforeLast;
        }
        T xtest;
        if (фабс(lastStep) < tol1 || lastStep !<>= 0)
        {
            if (lastStep > 0) lastStep = tol1;
            else lastStep = - tol1;
        }
        xtest = bestx + lastStep;
        // Evaluate the function at точка xtest.
        R ftest = функц(xtest);

        if (ftest <= fbest)
        {
            // We have a new best точка!
            // The previous best точка becomes a предел.
            if (xtest >= bestx) xlo = bestx;
            else xhi = bestx;
            third = секунда;
            fthird = fsecond;
            секунда = bestx;
            fsecond = fbest;
            bestx = xtest;
            fbest = ftest;
        }
        else
        {
            // This new точка is сейчас one of the limits.
            if (xtest < bestx)  xlo = xtest;
            else xhi = xtest;
            // Is it a new секунда best точка?
            if (ftest < fsecond || секунда == bestx)
            {
                third = секунда;
                fthird = fsecond;
                секунда = xtest;
                fsecond = ftest;
            }
            else if (ftest <= fthird || third == bestx || third == секунда)
            {
                // At least it's our third best точка!
                third = xtest;
                fthird = ftest;
            }
        }
    }
}

private:
debug(UnitTest)
{
    unittest
    {

        цел numProblems = 0;
        цел numCalls;

        проц testFindRoot(реал delegate(реал) f, реал x1, реал x2)
        {
            numCalls=0;
            ++numProblems;
            assert(x1<>=0 && x2<>=0);
            auto результат = найдиКорень(f, x1, x2, f(x1), f(x2),
            (БрэкетРез!(реал, реал) r)
            {
                return r.xhi==следщВыше(r.xlo);
            });

            auto flo = f(результат.xlo);
            auto fhi = f(результат.xhi);
            if (flo!=0)
            {
                assert(противоположныеЗнаки(flo, fhi));
            }
        }

        // Test functions
        реал cubicfn (реал x)
        {
            ++numCalls;
            if (x>плав.max) x = плав.max;
            if (x<-дво.max) x = -дво.max;
            // This имеется a single реал корень at -59.286543284815
            return 0.386*x*x*x + 23*x*x + 15.7*x + 525.2;
        }
        // Test a function with ещё than one корень.
        реал multisine(реал x)
        {
            ++numCalls;
            return син(x);
        }
        testFindRoot( &multisine, 6, 90);
        testFindRoot(&cubicfn, -100, 100);
        testFindRoot( &cubicfn, -дво.max, реал.max);


        /* Tests из_ the paper:
         * "On Enclosing Simple Roots of Nonlinear Equations", G. Alefeld, F.A. Potra,
         *   Yixun Shi, Mathematics of Computation 61, pp733-744 (1993).
         */
        // Параметры common в_ many alefeld tests.
        цел n;
        реал ale_a, ale_b;

        цел powercalls = 0;

        реал power(реал x)
        {
            ++powercalls;
            ++numCalls;
            return степень(x, n) + дво.min;
        }
        цел [] power_nvals = [3, 5, 7, 9, 19, 25];
        // Alefeld paper states that степень(x,n) is a very poor case, where bisection
        // outperforms his метод, и gives total numcalls =
        // 921 for bisection (2.4 calls per bit), 1830 for Alefeld (4.76/bit),
        // 2624 for brent (6.8/bit)
        // ... but that is for дво, not real80.
        // This poor performance seems mainly due в_ catastrophic cancellation,
        // which is avoопрed here by the use of и3еСреднее().
        // I получи: 231 (0.48/bit).
        // IE this is 10X faster in Alefeld's worst case
        numProblems=0;
        foreach(ключ; power_nvals)
        {
            n = ключ;
            testFindRoot(&power, -1, 10);
        }

        цел powerProblems = numProblems;

        // Tests из_ Alefeld paper

        цел [9] alefeldSums;
        реал alefeld0(реал x)
        {
            ++alefeldSums[0];
            ++numCalls;
            реал q =  син(x) - x/2;
            for (цел i=1; i<20; ++i)
                q+=(2*i-5.0)*(2*i-5.0)/((x-i*i)*(x-i*i)*(x-i*i));
            return q;
        }
        реал alefeld1(реал x)
        {
            ++numCalls;
            ++alefeldSums[1];
            return ale_a*x + эксп(ale_b * x);
        }
        реал alefeld2(реал x)
        {
            ++numCalls;
            ++alefeldSums[2];
            return степень(x, n) - ale_a;
        }
        реал alefeld3(реал x)
        {
            ++numCalls;
            ++alefeldSums[3];
            return (1.0 +степень(1.0L-n, 2))*x - степень(1.0L-n*x, 2);
        }
        реал alefeld4(реал x)
        {
            ++numCalls;
            ++alefeldSums[4];
            return x*x - степень(1-x, n);
        }

        реал alefeld5(реал x)
        {
            ++numCalls;
            ++alefeldSums[5];
            return (1+степень(1.0L-n, 4))*x - степень(1.0L-n*x, 4);
        }

        реал alefeld6(реал x)
        {
            ++numCalls;
            ++alefeldSums[6];
            return эксп(-n*x)*(x-1.01L) + степень(x, n);
        }

        реал alefeld7(реал x)
        {
            ++numCalls;
            ++alefeldSums[7];
            return (n*x-1)/((n-1)*x);
        }
        numProblems=0;
        testFindRoot(&alefeld0, ПИ_2, ПИ);
        for (n=1; n<=10; ++n)
        {
            testFindRoot(&alefeld0, n*n+1e-9L, (n+1)*(n+1)-1e-9L);
        }
        ale_a = -40;
        ale_b = -1;
        testFindRoot(&alefeld1, -9, 31);
        ale_a = -100;
        ale_b = -2;
        testFindRoot(&alefeld1, -9, 31);
        ale_a = -200;
        ale_b = -3;
        testFindRoot(&alefeld1, -9, 31);
        цел [] nvals_3 = [1, 2, 5, 10, 15, 20];
        цел [] nvals_5 = [1, 2, 4, 5, 8, 15, 20];
        цел [] nvals_6 = [1, 5, 10, 15, 20];
        цел [] nvals_7 = [2, 5, 15, 20];

        for(цел i=4; i<12; i+=2)
        {
            n = i;
            ale_a = 0.2;
            testFindRoot(&alefeld2, 0, 5);
            ale_a=1;
            testFindRoot(&alefeld2, 0.95, 4.05);
            testFindRoot(&alefeld2, 0, 1.5);
        }
        foreach(i; nvals_3)
        {
            n=i;
            testFindRoot(&alefeld3, 0, 1);
        }
        foreach(i; nvals_3)
        {
            n=i;
            testFindRoot(&alefeld4, 0, 1);
        }
        foreach(i; nvals_5)
        {
            n=i;
            testFindRoot(&alefeld5, 0, 1);
        }
        foreach(i; nvals_6)
        {
            n=i;
            testFindRoot(&alefeld6, 0, 1);
        }
        foreach(i; nvals_7)
        {
            n=i;
            testFindRoot(&alefeld7, 0.01L, 1);
        }
        реал worstcase(реал x)
        {
            ++numCalls;
            return x<0.3*реал.max? -0.999e-3 : 1.0;
        }
        testFindRoot(&worstcase, -реал.max, реал.max);

        /*
           цел grandtotal=0;
           foreach(calls; alefeldSums) {
               grandtotal+=calls;
           }
           grandtotal-=2*numProblems;
           printf("\nALEFELD TOTAL = %d avg = %f (alefeld avg=19.3 for дво)\n",
           grandtotal, (1.0*grandtotal)/numProblems);
           powercalls -= 2*powerProblems;
           printf("POWER TOTAL = %d avg = %f ", powercalls,
                (1.0*powercalls)/powerProblems);
        */
    }

    unittest
    {
        цел numcalls=-4;
        // Extremely well-behaved function.
        реал parab(реал bestx)
        {
            ++numcalls;
            return 3 * (bestx-7.14L) * (bestx-7.14L) + 18;
        }
        реал minval;
        реал minx;
        // Note, performs extremely poorly if we have an перебор, so that the
        // function returns infinity. It might be better в_ explicitly deal with
        // that situation (все parabolic fits will краш whenever an infinity is
        // present).
        minx = найдиМинимум(&parab, -квкор(реал.max), квкор(реал.max),
        cast(реал)(плав.max), minval);
        assert(minval==18);
        assert(отнравх(minx,7.14L)>=плав.mant_dig);

        // Problems из_ Jack Crenshaw's "World's Наилучший Root Finder"
        // http://www.embedded.com/columns/programmerstoolbox/9900609
        // This имеется a minimum of кубкор(0.5).
        реал crenshawcos(реал x)
        {
            return кос(2*ПИ*x*x*x);
        }
        minx = найдиМинимум(&crenshawcos, 0.0L, 1.0L, 0.1L, minval);
        assert(отнравх(minx*minx*minx, 0.5L)<=реал.mant_dig-4);

    }
}
