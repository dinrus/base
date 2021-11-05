﻿/*******************************************************************************
        Набор функций для преобразования между ткст и значением
        с плавающей точкой.

        В этом модуле строго рекомендовано применение механизма D "import alias"
        в целях предотвращения загрязнения пространства имён:
        ---
        import Плав = text.convert.Float;

        auto f = Плав.разбор ("3.14159");
        ---
        
*******************************************************************************/

module text.convert.Float;

private import exception;

/******************************************************************************

        Выбор внутренней версии
                
******************************************************************************/

version = float_internal;

private alias реал ЧисТип;

/******************************************************************************

        Дополнительные математические функции
                
******************************************************************************/

import cidrus;

/******************************************************************************

        Константы
                
******************************************************************************/

private enum 
{
        Pad = 0,                // дефолный заключительный десятичный ноль
        Dec = 2,                // дефолтные десятичные размещения
        Exp = 10,               // дефолтное переключение на научную нотацию
}

/******************************************************************************

        Преобразует форматированный текст из цифр в число с плавающей
        запятой. Выводит исключение, если вводимый текст полностью не
        подаётся разбору.
        
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

        Шаблонный обмотчик, упрощающий программирование. Возвращает текстовую
        версию предоставленного значения.

        Смотрите форматируй().
		
******************************************************************************/

export ткст вТкст (ЧисТип d, бцел десятки=Dec, цел e=Exp)
{
        сим[64] врем =void;
        
        return форматируй (врем, d, десятки, e).dup;
}
               
/******************************************************************************

        Шаблонный обмотчик, упрощающий программирование. Возвращает текстовую
        версию предоставленного значения.

        Смотрите форматируй().

******************************************************************************/

export шим[] вТкст16 (ЧисТип d, бцел десятки=Dec, цел e=Exp)
{
        шим[64] врем =void;
        
        return форматируй (врем, d, десятки, e).dup;
}
               
/******************************************************************************

        Шаблонный обмотчик, упрощающий программирование. Возвращает текстовую
        версию предоставленного значения.

        Смотрите форматируй().

******************************************************************************/

export дим[] вТкст32 (ЧисТип d, бцел десятки=Dec, цел e=Exp)
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

        Извлекает бит знака.

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

        Преобразует число с плавающей точкой в ткст. 

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
        эксп = (x is 0) ? 1 : cast(цел) лог10д (x < 0 ? -x : x);
        if (эксп <= -e || эксп >= e)
            режим = 2, ++десятки;

version (float_internal)
         стр = convertl (буф.ptr, x, десятки, &эксп, &знак, режим is 5);
		 /+
version (float_dtoa)
         стр = dtoa (x, режим, десятки, &эксп, &знак, &конец);
version (float_lib)
        {
        if (режим is 5)
            стр = fconvert (x, десятки, &эксп, &знак);
        else
           стр = econvert (x, десятки, &эксп, &знак);
        }
+/
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
export сим *convertl (сим* буф, реал значение, цел члоЦифр, цел *decpt, цел *знак, цел пфлаг)
{
        if ((*знак = негатив(значение)) != 0)
             значение = -значение;

        *decpt = 9999;
        if (значение !<>= значение)
            return "nan\0";

        if (значение is значение.infinity)
            return "inf\0";

        цел exp10 = (значение is 0) ? !пфлаг : cast(цел) вокруглид(лог10д(значение));
        if (exp10 < -4931) 
            exp10 = -4931;	
        значение *= степд (10.0, -exp10);
        if (значение) 
           {
           while (значение <  0.1) { значение *= 10;  --exp10; }
           while (значение >= 1.0) { значение /= 10;  ++exp10; }
           }
        assert(значение is 0 || (0.1 <= значение && значение < 1.0));
        //auto zero = пад ? цел.max : 1;
        auto zero = 1;
        if (пфлаг) 
           {
           // if (! пад)
                 zero = exp10;
           if (члоЦифр + exp10 < 0) 
              {
              *decpt= -члоЦифр;
              return "\0";
              }
           члоЦифр += exp10;
           }
        *decpt = exp10;
        int ptr = 1;

        if (члоЦифр > реал.dig) 
            члоЦифр = реал.dig;
        //printf ("< флаг %d, цифры %d, exp10 %d, decpt %d\n", пфлаг, члоЦифр, exp10, *decpt);
        while (ptr <= члоЦифр) 
              {
              реал i =void;
              значение = модфд (значение * 10, &i);
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
           буф [члоЦифр + 1] = '\0';
           return буф + 1;
           }
        if (пфлаг) 
           {
           ++члоЦифр;
           ++*decpt;
           }
        буф[0]= '1';
        буф[члоЦифр]= '\0';
        return буф;
}
}
/+

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
+/
version (float_internal)
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
               значение /= степ10 (-эксп);
           else
              значение *= степ10 (эксп);
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

	export ЧисТип степ10 (бцел эксп)
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
				throw new ИсклНелегальногоАргумента ("Float.степ10 :: экспонента слишком огромна");

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
