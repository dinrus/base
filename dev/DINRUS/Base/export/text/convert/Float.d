﻿/*******************************************************************************
        Набор функций для преобразования между ткст и значением
        с плавающей точкой.

        Applying the D "import alias" mechanism в_ this module is highly
        recommended, in order в_ предел namespace pollution:
        ---
        import Float = text.convert.Float;

        auto f = Float.разбор ("3.14159");
        ---
        
*******************************************************************************/

module text.convert.Float;

private import exception;

/******************************************************************************

        выбери an internal version
                
******************************************************************************/

version = float_internal;

private alias реал ЧисТип;

/******************************************************************************

        optional math functions
                
******************************************************************************/

private extern (C)
{
        дво лог10 (дво x);
        дво потолок (дво чис);
        дво modf (дво чис, дво *i);
        дво степень  (дво основа, дво эксп);

        реал log10l (реал x);
        реал ceill (реал чис);
        реал modfl (реал чис, реал *i);
        реал powl  (реал основа, реал эксп);

        цел printf (сим*, ...);
        version (Windows)
                {
                alias ecvt econvert;
                alias ecvt fconvert;
                }
        else
           {
           alias ecvtl econvert;
           alias ecvtl fconvert;
           }

        сим* ecvt (дво d, цел цифры, цел* decpt, цел* знак);
        сим* fcvt (дво d, цел цифры, цел* decpt, цел* знак);
        сим* ecvtl (реал d, цел цифры, цел* decpt, цел* знак);
        сим* fcvtl (реал d, цел цифры, цел* decpt, цел* знак);
}

/******************************************************************************

        Constants
                
******************************************************************************/

private enum 
{
        Pad = 0,                // default trailing десяток zero
        Dec = 2,                // default десяток places
        Exp = 10,               // default switch в_ scientific notation
}

/******************************************************************************

        Convert a formatted ткст of цифры в_ a floating-точка
        число. Выводит исключение an исключение where the ввод текст is not
        parsable in its entirety.
        
******************************************************************************/

ЧисТип вПлав(T) (T[] ист)
{
        бцел длин;

        auto x = разбор (ист, &длин);
        if (длин < ист.length || длин == 0)
            throw new ИсклНелегальногоАргумента ("Float.вПлав :: непригодное число");
        return x;
}

/******************************************************************************

        Template wrapper в_ сделай life simpler. Возвращает текст version
        of the предоставленный значение.

        See форматируй() for details

******************************************************************************/

ткст вТкст (ЧисТип d, бцел десятки=Dec, цел e=Exp)
{
        сим[64] врем =void;
        
        return форматируй (врем, d, десятки, e).dup;
}
               
/******************************************************************************

        Template wrapper в_ сделай life simpler. Возвращает текст version
        of the предоставленный значение.

        See форматируй() for details

******************************************************************************/

шим[] вТкст16 (ЧисТип d, бцел десятки=Dec, цел e=Exp)
{
        шим[64] врем =void;
        
        return форматируй (врем, d, десятки, e).dup;
}
               
/******************************************************************************

        Template wrapper в_ сделай life simpler. Возвращает текст version
        of the предоставленный значение.

        See форматируй() for details

******************************************************************************/

дим[] вТкст32 (ЧисТип d, бцел десятки=Dec, цел e=Exp)
{
        дим[64] врем =void;
        
        return форматируй (врем, d, десятки, e).dup;
}
               
/******************************************************************************

        Truncate trailing '0' и '.' из_ a ткст, such that 200.000 
        becomes 200, и 20.10 becomes 20.1

        Возвращает potentially shorter срез of что you give it.

******************************************************************************/

T[] упрости(T) (T[] s)
{
        auto врем = s;
        цел i = врем.length;
        foreach (цел индкс, T c; врем)
                 if (c is '.')
                     while (--i >= индкс)
                            if (врем[i] != '0')
                               {  
                               if (врем[i] is '.')
                                   --i;
                               s = врем [0 .. i+1];
                               while (--i >= индкс)
                                      if (врем[i] is 'e')
                                          return врем;
                               break;
                               }
        return s;
}

/******************************************************************************

        Extract a знак-bit

******************************************************************************/

private бул негатив (ЧисТип x)
{
        static if (ЧисТип.sizeof is 4) 
                   return ((*cast(бцел *)&x) & 0x8000_0000) != 0;
        else
           static if (ЧисТип.sizeof is 8) 
                      return ((*cast(бдол *)&x) & 0x8000_0000_0000_0000) != 0;
                else
                   {
                   auto pe = cast(ббайт *)&x;
                   return (pe[9] & 0x80) != 0;
                   }
}


/******************************************************************************

        Convert a floating-точка число в_ a ткст. 

        The e parameter controls the число of exponent places излейted, 
        и can thus control where the вывод switches в_ the scientific 
        notation. Например, настройка e=2 for 0.01 or 10.0 would результат
        in нормаль вывод. Whereas настройка e=1 would результат in Всё those
        значения being rendered in scientific notation instead. Setting e
        в_ 0 forces that notation on for everything. Parameter пад will
        добавь trailing '0' десятки when установи ~ иначе trailing '0's 
        will be elопрed

******************************************************************************/

T[] форматируй(T, D=ЧисТип, U=цел) (T[] приёмн, D x, U десятки=Dec, U e=Exp, бул пад=Pad)
{return форматируй!(T)(приёмн, x, десятки, e, пад);}

T[] форматируй(T) (T[] приёмн, ЧисТип x, цел десятки=Dec, цел e=Exp, бул пад=Pad)
{
        сим*           конец,
                        стр;
        цел             эксп,
                        знак,
                        режим=5;
        сим[32]        буф =void;

        // тест exponent в_ determine режим
        эксп = (x is 0) ? 1 : cast(цел) log10l (x < 0 ? -x : x);
        if (эксп <= -e || эксп >= e)
            режим = 2, ++десятки;

version (float_internal)
         стр = convertl (буф.ptr, x, десятки, &эксп, &знак, режим is 5);
version (float_dtoa)
         стр = dtoa (x, режим, десятки, &эксп, &знак, &конец);
version (float_lib)
        {
        if (режим is 5)
            стр = fconvert (x, десятки, &эксп, &знак);
        else
           стр = econvert (x, десятки, &эксп, &знак);
        }

        auto p = приёмн.ptr;
        if (знак)
            *p++ = '-';

        if (эксп is 9999)
            while (*стр) 
                   *p++ = *стр++;
        else
           {
           if (режим is 2)
              {
              --эксп;
              *p++ = *стр++;
              if (*стр || пад)
                 {
                 auto d = p;
                 *p++ = '.';
                 while (*стр)
                        *p++ = *стр++;
                 if (пад)
                     while (p-d < десятки)
                            *p++ = '0';
                 }
              *p++ = 'e';
              if (эксп < 0)
                  *p++ = '-', эксп = -эксп;
              else
                 *p++ = '+';
              if (эксп >= 1000)
                 {
                 *p++ = cast(T)((эксп/1000) + '0');
                 эксп %= 1000;
                 }
              if (эксп >= 100)
                 {
                 *p++ = эксп / 100 + '0';
                 эксп %= 100;
                 }
              *p++ = эксп / 10 + '0';
              *p++ = эксп % 10 + '0';
              }
           else
              {
              if (эксп <= 0)
                  *p++ = '0';
              else
                 for (; эксп > 0; --эксп)
                        *p++ = (*стр) ? *стр++ : '0';
              if (*стр || пад)
                 {
                 *p++ = '.';
                 auto d = p;
                 for (; эксп < 0; ++эксп)
                        *p++ = '0';
                 while (*стр)
                        *p++ = *стр++;
                 if (пад)
                     while (p-d < десятки)
                            *p++ = '0';
                 }
              } 
           }

        // stuff a C terminator in there too ...
        *p = 0;
        return приёмн[0..(p - приёмн.ptr)];
}


/******************************************************************************

        ecvt() и fcvt() for 80bit FP, which DMD does not include. Based
        upon the following:

        Copyright (c) 2009 Ian Piumarta
        
        Все права защищены.

        Permission is hereby granted, free of charge, в_ any person 
        obtaining a копируй of this software и associated documentation 
        файлы (the 'Software'), в_ deal in the Software without restriction, 
        включая without limitation the rights в_ use, копируй, modify, совмести, 
        publish, distribute, и/or sell copies of the Software, и в_ permit 
        persons в_ whom the Software is furnished в_ do so, предоставленный that the 
        above copyright notice(s) и this permission notice appear in все 
        copies of the Software.  

******************************************************************************/

version (float_internal)
{
private сим *convertl (сим* буф, реал значение, цел ndigit, цел *decpt, цел *знак, цел fflag)
{
        if ((*знак = негатив(значение)) != 0)
             значение = -значение;

        *decpt = 9999;
        if (значение !<>= значение)
            return "nan\0";

        if (значение is значение.infinity)
            return "inf\0";

        цел exp10 = (значение is 0) ? !fflag : cast(цел) ceill(log10l(значение));
        if (exp10 < -4931) 
            exp10 = -4931;	
        значение *= powl (10.0, -exp10);
        if (значение) 
           {
           while (значение <  0.1) { значение *= 10;  --exp10; }
           while (значение >= 1.0) { значение /= 10;  ++exp10; }
           }
        assert(значение is 0 || (0.1 <= значение && значение < 1.0));
        //auto zero = пад ? цел.max : 1;
        auto zero = 1;
        if (fflag) 
           {
           // if (! пад)
                 zero = exp10;
           if (ndigit + exp10 < 0) 
              {
              *decpt= -ndigit;
              return "\0";
              }
           ndigit += exp10;
           }
        *decpt = exp10;
        int ptr = 1;

        if (ndigit > реал.dig) 
            ndigit = реал.dig;
        //printf ("< флаг %d, цифры %d, exp10 %d, decpt %d\n", fflag, ndigit, exp10, *decpt);
        while (ptr <= ndigit) 
              {
              реал i =void;
              значение = modfl (значение * 10, &i);
              буф [ptr++]= '0' + cast(цел) i;
              }

        if (значение >= 0.5)
            while (--ptr && ++буф[ptr] > '9')
                   буф[ptr] = (ptr > zero) ? '\0' : '0';
        else
           for (auto i=ptr; i && --i > zero && буф[i] is '0';)
                буф[i] = '\0';

        if (ptr) 
           {
           буф [ndigit + 1] = '\0';
           return буф + 1;
           }
        if (fflag) 
           {
           ++ndigit;
           ++*decpt;
           }
        буф[0]= '1';
        буф[ndigit]= '\0';
        return буф;
}
}


/******************************************************************************

        David Gay's extended conversions between ткст и floating-точка
        numeric representations. Use these where you need extended accuracy
        for convertions. 

        Note that this class требует the attendent файл dtoa.c be compiled 
        и linked в_ the application

******************************************************************************/

version (float_dtoa)
{
        private extern(C)
        {
        // these should be linked in via dtoa.c
        дво strtod (сим* s00, сим** se);
        сим*  dtoa (дво d, цел режим, цел ndigits, цел* decpt, цел* знак, сим** rve);
        }

        /**********************************************************************

                Convert a formatted ткст of цифры в_ a floating-
                точка число. 

        **********************************************************************/

        ЧисТип разбор (ткст ист, бцел* взято=пусто)
        {
                сим* конец;

                auto значение = strtod (ист.ptr, &конец);
                assert (конец <= ист.ptr + ист.length);
                if (взято)
                    *взято = конец - ист.ptr;
                return значение;
        }

        /**********************************************************************

                Convert a formatted ткст of цифры в_ a floating-
                точка число.

        **********************************************************************/

        ЧисТип разбор (шим[] ист, бцел* взято=пусто)
        {
                // cheesy хак в_ avoопр pre-parsing :: max цифры == 100
                сим[100] врем =void;
                auto p = врем.ptr;
                auto e = p + врем.length;
                foreach (c; ист)
                         if (p < e && (c & 0x80) is 0)
                             *p++ = c;                        
                         else
                            break;

                return разбор (врем[0..p-врем.ptr], взято);
        }

        /**********************************************************************

                Convert a formatted ткст of цифры в_ a floating-
                точка число. 

        **********************************************************************/

        ЧисТип разбор (дим[] ист, бцел* взято=пусто)
        {
                // cheesy хак в_ avoопр pre-parsing :: max цифры == 100
                сим[100] врем =void;
                auto p = врем.ptr;
                auto e = p + врем.length;
                foreach (c; ист)
                         if (p < e && (c & 0x80) is 0)
                             *p++ = c;
                         else
                            break;
                return разбор (врем[0..p-врем.ptr], взято);
        }
}
else
{
private import Целое = text.convert.Integer;

/******************************************************************************

        Convert a formatted ткст of цифры в_ a floating-точка число.
        Good for general use, but use David Gay's dtoa package if serious
        rounding adjustments should be applied.

******************************************************************************/

ЧисТип разбор(T) (T[] ист, бцел* взято=пусто)
{
        T               c;
        T*              p;
        цел             эксп;
        бул            знак;
        бцел            корень;
        ЧисТип         значение = 0.0;

        static бул сверь (T* aa, T[] bb)
        {
                foreach (b; bb)
                        {
                        auto a = *aa++;
                        if (a >= 'A' && a <= 'Z')
                            a += 'a' - 'A';
                        if (a != b)
                            return нет;
                        }
                return да;
        }

        // удали leading пространство, и знак
        p = ист.ptr + Целое.убери (ист, знак, корень);

        // bail out if the ткст is пустой
        if (ист.length is 0 || p > &ист[$-1])
            return ЧисТип.nan;
        c = *p;

        // укз non-десяток representations
        if (корень != 10)
           {
           дол знач = Целое.разбор (ист, корень, взято); 
           return cast(ЧисТип) знач;
           }

        // установи начало и конец проверьs
        auto начало = p;
        auto конец = ист.ptr + ист.length;

        // читай leading цифры; note that leading
        // zeros are simply multИПlied away
        while (c >= '0' && c <= '9' && p < конец)
              {
              значение = значение * 10 + (c - '0');
              c = *++p;
              }

        // gobble up the точка
        if (c is '.' && p < конец)
            c = *++p;

        // читай fractional цифры; note that we accumulate
        // все цифры ... very дол numbers impact accuracy
        // в_ a degree, but perhaps not as much as one might
        // expect. A приор version limited the цифра счёт,
        // but dопр not show marked improvement. For maximum
        // accuracy when reading и writing, use David Gay's
        // dtoa package instead
        while (c >= '0' && c <= '9' && p < конец)
              {
              значение = значение * 10 + (c - '0');
              c = *++p;
              --эксп;
              } 

        // dопр we получи something?
        if (p > начало)
           {
           // разбор base10 exponent?
           if ((c is 'e' || c is 'Е') && p < конец )
              {
              бцел eaten;
              эксп += Целое.разбор (ист[(++p-ист.ptr) .. $], 0, &eaten);
              p += eaten;
              }

           // исправь mantissa; note that the exponent имеется
           // already been adjusted for fractional цифры
           if (эксп < 0)
               значение /= pow10 (-эксп);
           else
              значение *= pow10 (эксп);
           }
        else
           if (конец - p >= 3)
               switch (*p)
                      {
                      case 'I': case 'i':
                           if (сверь (p+1, "nf"))
                              {
                              значение = значение.infinity;
                              p += 3;
                              if (конец - p >= 5 && сверь (p, "inity"))
                                  p += 5;
                              }
                           break;

                      case 'N': case 'n':
                           if (сверь (p+1, "an"))
                              {
                              значение = значение.nan;
                              p += 3;
                              }
                           break;
                      default:
                           break;
                      }

        // установи разбор length, и return значение
        if (взято)
            *взято = p - ист.ptr;

        if (знак)
            значение = -значение;
        return значение;
}

/******************************************************************************

        Internal function в_ преобразуй an exponent определитель в_ a floating
        точка значение.

******************************************************************************/

private ЧисТип pow10 (бцел эксп)
{
        static  ЧисТип[] Powers = 
                [
                1.0e1L,
                1.0e2L,
                1.0e4L,
                1.0e8L,
                1.0e16L,
                1.0e32L,
                1.0e64L,
                1.0e128L,
                1.0e256L,
                1.0e512L,
                1.0e1024L,
                1.0e2048L,
                1.0e4096L,
                1.0e8192L,
                ];

        if (эксп >= 16384)
            throw new ИсклНелегальногоАргумента ("Float.pow10 :: экспонента слишком огромна");

        ЧисТип mult = 1.0;
        foreach (ЧисТип power; Powers)
                {
                if (эксп & 1)
                    mult *= power;
                if ((эксп >>= 1) is 0)
                     break;
                }
        return mult;
}
}

version (float_old)
{
/******************************************************************************

        Convert a плав в_ a ткст. This produces pretty good результаты
        for the most часть, though one should use David Gay's dtoa package
        for best accuracy.

        Note that the approach первый normalizes a base10 mantissa, then
        pulls цифры из_ the лево sопрe whilst излейting them (rightward)
        в_ the вывод.

        The e parameter controls the число of exponent places излейted, 
        и can thus control where the вывод switches в_ the scientific 
        notation. Например, настройка e=2 for 0.01 or 10.0 would результат
        in нормаль вывод. Whereas настройка e=1 would результат in Всё those
        значения being rendered in scientific notation instead. Setting e
        в_ 0 forces that notation on for everything.

        TODO: this should be replaced, as it is not sufficiently accurate 

******************************************************************************/

T[] форматируй(T, D=дво, U=бцел) (T[] приёмн, D x, U десятки=Dec, цел e=Exp, бул пад=Pad)
{return форматируй!(T)(приёмн, x, десятки, e, пад);}

T[] форматируй(T) (T[] приёмн, ЧисТип x, бцел десятки=Dec, цел e=Exp, бул пад=Pad)
{
        static T[] inf = "-inf";
        static T[] нч = "-nan";

        // откинь цифры из_ the лево of a normalized основа-10 число
        static цел toDigit (ref ЧисТип знач, ref цел счёт)
        {
                цел цифра;

                // Don't exceed max цифры storable in a реал
                // (-1 because the последний цифра is not always storable)
                if (--счёт <= 0)
                    цифра = 0;
                else
                   {
                   // удали leading цифра, и bump
                   цифра = cast(цел) знач;
                   знач = (знач - цифра) * 10.0;
                   }
                return цифра + '0';
        }

        // выкинь the знак
        бул знак = негатив (x);
        if (знак)
            x = -x;

        if (x !<>= x)
            return знак ? нч : нч[1..$];

        if (x is x.infinity)
            return знак ? inf : inf[1..$];

        // assume no exponent
        цел эксп = 0;
        цел абс = 0;

        // don't шкала if zero
        if (x > 0.0)
           {
           // выкинь base10 exponent
           эксп = cast(цел) log10l (x);

           // округли up a bit
           auto d = десятки;
           if (эксп < 0)
               d -= эксп;
           x += 0.5 / pow10 (d);

           // нормализуй base10 mantissa (0 < m < 10)
           абс = эксп = cast(цел) log10l (x);
           if (эксп > 0)
               x /= pow10 (эксп);
           else
              абс = -эксп;

           // switch в_ exponent display as necessary
           if (абс >= e)
               e = 0; 
           }

        T* p = приёмн.ptr;
        цел счёт = ЧисТип.dig;

        // излей знак
        if (знак)
            *p++ = '-';
        
        // are we doing +/-эксп форматируй?
        if (e is 0)
           {
           assert (приёмн.length > десятки + 7);

           if (эксп < 0)
               x *= pow10 (абс+1);

           // излей первый цифра, и десяток точка
           *p++ = cast(T) toDigit (x, счёт);
           if (десятки)
              {
              *p++ = '.';

              // излей rest of mantissa
              while (десятки-- > 0)
                     *p++ = cast(T) toDigit (x, счёт);
              
              if (пад is нет)
                 {
                 while (*(p-1) is '0')
                        --p;
                 if (*(p-1) is '.')
                     --p;
                 }
              }

           // излей exponent, if non zero
           if (абс)
              {
              *p++ = 'e';
              *p++ = (эксп < 0) ? '-' : '+';
              if (абс >= 1000)
                 {
                 *p++ = cast(T)((абс/1000) + '0');
                 абс %= 1000;
                 *p++ = cast(T)((абс/100) + '0');
                 абс %= 100;
                 }
              else
                 if (абс >= 100)
                    {
                    *p++ = cast(T)((абс/100) + '0');
                    абс %= 100;
                    }
              *p++ = cast(T)((абс/10) + '0');
              *p++ = cast(T)((абс%10) + '0');
              }
           }
        else
           {
           assert (приёмн.length >= (((эксп < 0) ? 0 : эксп) + десятки + 1));

           // if дво only, излей a leading zero
           if (эксп < 0)
              {
              x *= pow10 (абс);
              *p++ = '0';
              }
           else
              // излей все цифры в_ the лево of точка
              for (; эксп >= 0; --эксп)
                     *p++ = cast(T )toDigit (x, счёт);

           // излей точка
           if (десятки)
              {
              *p++ = '.';

              // излей leading fractional zeros?
              for (++эксп; эксп < 0 && десятки > 0; --десятки, ++эксп)
                   *p++ = '0';

              // вывод остаток цифры, if any. Trailing
              // zeros are also returned из_ toDigit()
              while (десятки-- > 0)
                     *p++ = cast(T) toDigit (x, счёт);

              if (пад is нет)
                 {
                 while (*(p-1) is '0')
                        --p;
                 if (*(p-1) is '.')
                     --p;
                 }
              }
           }

        return приёмн [0..(p - приёмн.ptr)];
}
}

/******************************************************************************

******************************************************************************/

debug (UnitTest)
{
        import io.Console;
      
        unittest
        {
                сим[164] врем;

                auto f = разбор ("нч");
                assert (форматируй(врем, f) == "нч");
                f = разбор ("inf");
                assert (форматируй(врем, f) == "inf");
                f = разбор ("-нч");
                assert (форматируй(врем, f) == "-нч");
                f = разбор (" -inf");
                assert (форматируй(врем, f) == "-inf");

                assert (форматируй (врем, 3.14159, 6) == "3.14159");
                assert (форматируй (врем, 3.14159, 4) == "3.1416");
                assert (разбор ("3.5") == 3.5);
                assert (форматируй(врем, разбор ("3.14159"), 6) == "3.14159");
        }
}


debug (Float)
{
        import io.Console;

        проц main() 
        {
                сим[500] врем;
/+
                Квывод (форматируй(врем, ЧисТип.max)).нс;
                Квывод (форматируй(врем, -ЧисТип.nan)).нс;
                Квывод (форматируй(врем, -ЧисТип.infinity)).нс;
                Квывод (форматируй(врем, вПлав("нч"w))).нс;
                Квывод (форматируй(врем, вПлав("-нч"d))).нс;
                Квывод (форматируй(врем, вПлав("inf"))).нс;
                Квывод (форматируй(врем, вПлав("-inf"))).нс;
+/
                Квывод (форматируй(врем, вПлав ("0.000000e+00"))).нс;
                Квывод (форматируй(врем, вПлав("0x8000000000000000"))).нс;
                Квывод (форматируй(врем, 1)).нс;
                Квывод (форматируй(врем, -0)).нс;
                Квывод (форматируй(врем, 0.000001)).нс.нс;

                Квывод (форматируй(врем, 3.14159, 6, 0)).нс;
                Квывод (форматируй(врем, 3.0e10, 6, 3)).нс;
                Квывод (форматируй(врем, 314159, 6)).нс;
                Квывод (форматируй(врем, 314159123213, 6, 15)).нс;
                Квывод (форматируй(врем, 3.14159, 6, 2)).нс;
                Квывод (форматируй(врем, 3.14159, 3, 2)).нс;
                Квывод (форматируй(врем, 0.00003333, 6, 2)).нс;
                Квывод (форматируй(врем, 0.00333333, 6, 3)).нс;
                Квывод (форматируй(врем, 0.03333333, 6, 2)).нс;
                Квывод.нс;

                Квывод (форматируй(врем, -3.14159, 6, 0)).нс;
                Квывод (форматируй(врем, -3e100, 6, 3)).нс;
                Квывод (форматируй(врем, -314159, 6)).нс;
                Квывод (форматируй(врем, -314159123213, 6, 15)).нс;
                Квывод (форматируй(врем, -3.14159, 6, 2)).нс;
                Квывод (форматируй(врем, -3.14159, 2, 2)).нс;
                Квывод (форматируй(врем, -0.00003333, 6, 2)).нс;
                Квывод (форматируй(врем, -0.00333333, 6, 3)).нс;
                Квывод (форматируй(врем, -0.03333333, 6, 2)).нс;
                Квывод.нс;

                Квывод (форматируй(врем, -0.9999999, 7, 3)).нс;
                Квывод (форматируй(врем, -3.0e100, 6, 3)).нс;
                Квывод ((форматируй(врем, 1.0, 6))).нс;
                Квывод ((форматируй(врем, 30, 6))).нс;
                Квывод ((форматируй(врем, 3.14159, 6, 0))).нс;
                Квывод ((форматируй(врем, 3e100, 6, 3))).нс;
                Квывод ((форматируй(врем, 314159, 6))).нс;
                Квывод ((форматируй(врем, 314159123213.0, 3, 15))).нс;
                Квывод ((форматируй(врем, 3.14159, 6, 2))).нс;
                Квывод ((форматируй(врем, 3.14159, 4, 2))).нс;
                Квывод ((форматируй(врем, 0.00003333, 6, 2))).нс;
                Квывод ((форматируй(врем, 0.00333333, 6, 3))).нс;
                Квывод ((форматируй(врем, 0.03333333, 6, 2))).нс;
                Квывод (форматируй(врем, ЧисТип.min, 6)).нс;
                Квывод (форматируй(врем, -1)).нс;
                Квывод (форматируй(врем, вПлав(форматируй(врем, -1)))).нс;
                Квывод.нс;
        }
}
