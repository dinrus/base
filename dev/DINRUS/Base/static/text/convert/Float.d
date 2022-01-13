/*******************************************************************************
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

import cidrus: лог10д;

/******************************************************************************

        выбери an internal version
                
******************************************************************************/


private alias реал ЧисТип;

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

extern(D) ткст вТкст (ЧисТип d, бцел десятки=Dec, цел e=Exp);
               
/******************************************************************************

        Template wrapper в_ сделай life simpler. Возвращает текст version
        of the предоставленный значение.

        See форматируй() for details

******************************************************************************/

extern(D) шим[] вТкст16 (ЧисТип d, бцел десятки=Dec, цел e=Exp);
               
/******************************************************************************

        Template wrapper в_ сделай life simpler. Возвращает текст version
        of the предоставленный значение.

        See форматируй() for details

******************************************************************************/

extern(D) дим[] вТкст32 (ЧисТип d, бцел десятки=Dec, цел e=Exp);
               
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
        эксп = (x is 0) ? 1 : cast(цел) лог10д (x < 0 ? -x : x);
        if (эксп <= -e || эксп >= e)
            режим = 2, ++десятки;
         стр = convertl (буф.ptr, x, десятки, &эксп, &знак, режим is 5);

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

extern(D) сим *convertl (сим* буф, реал значение, цел ndigit, цел *decpt, цел *знак, цел fflag);



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

extern(D) ЧисТип степ10 (бцел эксп);

