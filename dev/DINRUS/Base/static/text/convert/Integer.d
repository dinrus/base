﻿/*******************************************************************************
        Набор функций для преобразования между текстовым и целым 
        значениями. 

        Applying the D "import alias" mechanism в_ this module is highly
        recommended, in order в_ предел namespace pollution:
        ---
        import Целое = text.convert.Integer;

        auto i = Целое.разбор ("32767");
        ---
        
*******************************************************************************/

module text.convert.Integer;

private import exception;

/******************************************************************************

        Parse an целое значение из_ the предоставленный 'цифры' ткст. 

        The ткст is inspected for a знак и an optional корень 
        префикс. A корень may be предоставленный as an аргумент instead, 
        whereupon it must сверь the префикс (where present). When
        корень is установи в_ zero, conversion will default в_ десяток.

        Throws: ИсклНелегальногоАргумента where the ввод текст is not parsable
        in its entirety.

        See_also: the low уровень functions разбор() и преобразуй()

******************************************************************************/

цел вЦел(T, U=бцел) (T[] цифры, U корень=0)
{return вЦел!(T)(цифры, корень);}

цел вЦел(T) (T[] цифры, бцел корень=0)
{
        auto x = вДол (цифры, корень);
        if (x > цел.max)
            throw new ИсклНелегальногоАргумента ("Целое.вЦел :: целое перебор");
        return cast(цел) x;
}

/******************************************************************************

        Parse an целое значение из_ the предоставленный 'цифры' ткст.

        The ткст is inspected for a знак и an optional корень
        префикс. A корень may be предоставленный as an аргумент instead,
        whereupon it must сверь the префикс (where present). When
        корень is установи в_ zero, conversion will default в_ десяток.

        Throws: ИсклНелегальногоАргумента where the ввод текст is not parsable
        in its entirety.

        See_also: the low уровень functions разбор() и преобразуй()

******************************************************************************/

дол вДол(T, U=бцел) (T[] цифры, U корень=0)
{return вДол!(T)(цифры, корень);}

дол вДол(T) (T[] цифры, бцел корень=0)
{
        бцел длин;

        auto x = разбор (цифры, корень, &длин);
        if (длин < цифры.length)
            throw new ИсклНелегальногоАргумента ("Целое.вДол :: непригодный литерал");
        return x;
}

/******************************************************************************

        Wrapper в_ сделай life simpler. Возвращает текст version
        of the предоставленный значение.

        See форматируй() for details

******************************************************************************/

extern(D) ткст вТкст (дол i, ткст фмт = пусто);
               
/******************************************************************************

        Wrapper в_ сделай life simpler. Возвращает текст version
        of the предоставленный значение.

        See форматируй() for details

******************************************************************************/

extern(D) шим[] вТкст16 (дол i, шим[] фмт = пусто);
               
/******************************************************************************

        Wrapper в_ сделай life simpler. Возвращает текст version
        of the предоставленный значение.

        See форматируй() for details

******************************************************************************/

extern(D) дим[] вТкст32 (дол i, дим[] фмт = пусто);
               
/*******************************************************************************

        Supports форматируй specifications via an Массив, where форматируй follows
        the notation given below:
        ---
        тип ширина префикс
        ---

        Тип is one of [d, g, u, b, x, o] or uppercase equivalent, и
        dictates the conversion корень or другой semantics.

        Wопрth is optional и indicates a minimum ширина for zero-паддинг,
        while the optional префикс is one of ['#', ' ', '+'] и indicates
        что variety of префикс should be placed in the вывод. e.g.
        ---
        "d"     => целое
        "u"     => unsigned
        "o"     => octal
        "b"     => binary
        "x"     => hexadecimal
        "X"     => hexadecimal uppercase

        "d+"    => целое псеп_в_начале with "+"
        "b#"    => binary псеп_в_начале with "0b"
        "x#"    => hexadecimal псеп_в_начале with "0x"
        "X#"    => hexadecimal псеп_в_начале with "0X"

        "d8"    => десяток псеп_в_конце в_ 8 places as требуется
        "b8"    => binary псеп_в_конце в_ 8 places as требуется
        "b8#"   => binary псеп_в_конце в_ 8 places и псеп_в_начале with "0b"
        ---

        Note that the specified ширина is исключительно of the префикс, though
        the ширина паддинг will be shrunk as necessary in order в_ ensure
        a requested префикс can be inserted преобр_в the предоставленный вывод.

*******************************************************************************/

T[] форматируй(T, U=дол) (T[] приёмн, U i, T[] фмт = пусто)
{return форматируй!(T)(приёмн, cast(дол) i, фмт);}

T[] форматируй(T) (T[] приёмн, дол i, T[] фмт = пусто)
{
        сим    pre,
                тип;
        цел     ширина;

        раскодируй (фмт, тип, pre, ширина);
        return форматёр (приёмн, i, тип, pre, ширина);
} 

private проц раскодируй(T) (T[] фмт, ref сим тип, out сим pre, out цел ширина)
{
        if (фмт.length is 0)
            тип = 'd';
        else
           {
           тип = фмт[0];
           if (фмт.length > 1)
              {
              auto p = &фмт[1];
              for (цел j=1; j < фмт.length; ++j, ++p)
                   if (*p >= '0' && *p <= '9')
                       ширина = ширина * 10 + (*p - '0');
                   else
                      pre = *p;
              }
           }
} 


T[] форматёр(T, U=дол, X=сим, Y=сим) (T[] приёмн, U i, X тип, Y pre, цел ширина)
{return форматёр!(T)(приёмн, cast(дол) i, тип, pre, ширина);}


private struct ИнфоОФорматировщике(T)
{
		бцел    корень;
		T[]     префикс;
		T[]     numbers;
}

T[] форматёр(T) (T[] приёмн, дол i, сим тип, сим pre, цел ширина)
{
        const T[] lower = "0123456789abcdef";
        const T[] upper = "0123456789ABCDEF";
        
        alias ИнфоОФорматировщике!(T) Инфо;

        const   Инфо[] форматы = 
                [
                {10, пусто, lower}, 
                {10, "-",  lower}, 
                {10, " ",  lower}, 
                {10, "+",  lower}, 
                { 2, "0b", lower}, 
                { 8, "0o", lower}, 
                {16, "0x", lower}, 
                {16, "0X", upper},
                ];

        ббайт индекс;
        цел   длин = приёмн.length;

        if (длин)
           {
           switch (тип)
                  {
                  case 'd':
                  case 'D':
                  case 'g':
                  case 'G':
                       if (i < 0)
                          {
                          индекс = 1;
                          i = -i;
                          }
                       else
                          if (pre is ' ')
                              индекс = 2;
                          else
                             if (pre is '+')
                                 индекс = 3;
                  case 'u':
                  case 'U':
                       pre = '#';
                       break;

                  case 'b':
                  case 'B':
                       индекс = 4;
                       break;

                  case 'o':
                  case 'O':
                       индекс = 5;
                       break;

                  case 'x':
                       индекс = 6;
                       break;

                  case 'X':
                       индекс = 7;
                       break;

                  default:
                        return cast(T[])"{неизвестный формат '"~cast(T)тип~"'}";
                  }

           auto инфо = &форматы[индекс];
           auto numbers = инфо.numbers;
           auto корень = инфо.корень;

           // преобразуй число в_ текст
           auto p = приёмн.ptr + длин;
           if (бцел.max >= cast(бдол) i)
              {
              auto знач = cast (бцел) i;
              do {
                 *--p = numbers [знач % корень];
                 } while ((знач /= корень) && --длин);
              }
           else
              {
              auto знач = cast (бдол) i;
              do {
                 *--p = numbers [cast(бцел) (знач % корень)];
                 } while ((знач /= корень) && --длин);
              }
        
           auto префикс = (pre is '#') ? инфо.префикс : пусто;
           if (длин > префикс.length)
              {
              длин -= префикс.length + 1;

              // префикс число with zeros? 
              if (ширина)
                 {
                 ширина = приёмн.length - ширина - префикс.length;
                 while (длин > ширина && длин > 0)
                       {
                       *--p = '0';
                       --длин;
                       }
                 }
              // пиши optional префикс ткст ...
              приёмн [длин .. длин + префикс.length] = префикс;

              // return срез of предоставленный вывод буфер
              return приёмн [длин .. $];                               
              }
           }
        
        return "{слишком малая ширина вывода}";
} 


/******************************************************************************

        Parse an целое значение из_ the предоставленный 'цифры' ткст. 

        The ткст is inspected for a знак и an optional корень 
        префикс. A корень may be предоставленный as an аргумент instead, 
        whereupon it must сверь the префикс (where present). When
        корень is установи в_ zero, conversion will default в_ десяток.

        A non-пусто 'взято' will return the число of characters использован
        в_ construct the returned значение.

        Throws: Неук. The 'взято' param should be проверьed for действителен ввод.

******************************************************************************/

дол разбор(T, U=бцел) (T[] цифры, U корень=0, бцел* взято=пусто)
{return разбор!(T)(цифры, корень, взято);}

дол разбор(T) (T[] цифры, бцел корень=0, бцел* взято=пусто)
{
        бул знак;

        auto eaten = убери (цифры, знак, корень);
        auto значение = преобразуй (цифры[eaten..$], корень, взято);

        // проверь *взято > 0 в_ сделай sure we don't разбор "-" as 0.
        if (взято && *взято > 0)
            *взято += eaten;

        return cast(дол) (знак ? -значение : значение);
}

/******************************************************************************

        Convert the предоставленный 'цифры' преобр_в an целое значение,
        without проверьing for a знак or корень. The корень дефолты
        в_ десяток (10).

        Возвращает the значение и updates 'взято' with the число of
        characters consumed.

        Throws: Неук. The 'взято' param should be проверьed for действителен ввод.

******************************************************************************/

бдол преобразуй(T, U=бцел) (T[] цифры, U корень=10, бцел* взято=пусто)
{return преобразуй!(T)(цифры, корень, взято);}

бдол преобразуй(T) (T[] цифры, бцел корень=10, бцел* взято=пусто)
{
        бцел  eaten;
        бдол значение;

        foreach (c; цифры)
                {
                if (c >= '0' && c <= '9')
                   {}
                else
                   if (c >= 'a' && c <= 'z')
                       c -= 39;
                   else
                      if (c >= 'A' && c <= 'Z')
                          c -= 7;
                      else
                         break;

                if ((c -= '0') < корень)
                   {
                   значение = значение * корень + c;
                   ++eaten;
                   }
                else
                   break;
                }

        if (взято)
            *взято = eaten;

        return значение;
}


/******************************************************************************

        StrИП leading пробел, выкинь an optional +/- знак,
        и an optional корень префикс. If the корень значение совпадает
        an optional префикс, or the корень is zero, the префикс will
        be consumed и назначено. Where the корень is non zero и
        does not сверь an явный префикс, the latter will remain 
        unconsumed. Otherwise, корень will default в_ 10.

        Возвращает the число of characters consumed.

******************************************************************************/

бцел убери(T, U=бцел) (T[] цифры, ref бул знак, ref U корень)
{return убери!(T)(цифры, знак, корень);}

бцел убери(T) (T[] цифры, ref бул знак, ref бцел корень)
{
        T       c;
        T*      p = цифры.ptr;
        цел     длин = цифры.length;

        if (длин)
           {
           // откинь off пробел и знак characters
           for (c = *p; длин; c = *++p, --длин)
                if (c is ' ' || c is '\t')
                   {}
                else
                   if (c is '-')
                       знак = да;
                   else
                      if (c is '+')
                          знак = нет;
                   else
                      break;

           // откинь off a корень определитель also?
           auto r = корень;
           if (c is '0' && длин > 1)
               switch (*++p)
                      {
                      case 'x':
                      case 'X':
                           ++p;
                           r = 16;
                           break;
 
                      case 'b':
                      case 'B':
                           ++p;
                           r = 2;
                           break;
 
                      case 'o':
                      case 'O':
                           ++p;
                           r = 8;
                           break;
 
                      default: 
                            --p;
                           break;
                      } 

           // default the корень в_ 10
           if (r is 0)
               корень = 10;
           else
              // явный корень must сверь (optional) префикс
              if (корень != r)
                  if (корень)
                      p -= 2;
                  else
                     корень = r;
           }

        // return число of characters eaten
        return (p - цифры.ptr);
}


/******************************************************************************

        быстро & dirty текст-в_-unsigned цел converter. Use only when you
        know что the контент is, or use разбор() or преобразуй() instead.

        Return the разобрано бцел
        
******************************************************************************/

бцел atoi(T) (T[] s, цел корень = 10)
{
        бцел значение;

        foreach (c; s)
                 if (c >= '0' && c <= '9')
                     значение = значение * корень + (c - '0');
                 else
                    break;
        return значение;
}


/******************************************************************************

        быстро & dirty unsigned в_ текст converter, where the предоставленный вывод
        must be large enough в_ house the результат (10 цифры in the largest
        case). For mainПоток use, consider utilizing форматируй() instead.

        Возвращает populated срез of the предоставленный вывод
        
******************************************************************************/

T[] itoa(T, U=бцел) (T[] вывод, U значение, цел корень = 10)
{return itoa!(T)(вывод, значение, корень);}

T[] itoa(T) (T[] вывод, бцел значение, цел корень = 10)
{
        T* p = вывод.ptr + вывод.length;

        do {
           *--p = cast(T)(значение % корень + '0');
           } while (значение /= корень);
        return вывод[p-вывод.ptr .. $];
}


/******************************************************************************

        Consume a число из_ the ввод without converting it. Аргумент
        'fp' enables floating-точка consumption. Supports hex ввод for
        numbers which are псеп_в_начале appropriately

        Since version 0.99.9

******************************************************************************/

T[] используй(T) (T[] ист, бул fp=нет)
{
        T       c;
        бул    знак;
        бцел    корень;

        // удали leading пространство, и знак
        auto e = ист.ptr + ист.length;
        auto p = ист.ptr + убери (ист, знак, корень);
        auto b = p;

        // bail out if the ткст is пустой
        if (ист.length is 0 || p > &ист[$-1])
            return пусто;

        // читай leading цифры
        for (c=*p; p < e && ((c >= '0' && c <= '9') || 
            (корень is 16 && ((c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F'))));)
             c = *++p;

        if (fp)
           {
           // gobble up a точка
           if (c is '.' && p < e)
               c = *++p;

           // читай fractional цифры
           while (c >= '0' && c <= '9' && p < e)
                  c = *++p;

           // dопр we используй anything?
           if (p > b)
              {
              // используй exponent?
              if ((c is 'e' || c is 'Е') && p < e )
                 {
                 c = *++p;
                 if (c is '+' || c is '-')
                     c = *++p;
                 while (c >= '0' && c <= '9' && p < e)
                        c = *++p;
                 }
              }
           }
        return ист [0 .. p-ист.ptr];
}