module stdrusex;

const ЮНИКОД = да;

export extern(C) ткст[] дайАргиКС();
private
{
	import stdrus;	
}

private
{
    ткст иницТекПап;
}

//module util.series;
/////////////////////
export extern(D) struct Серии
{
    private
    {
       static бдол знач = бдол.init;
      static бдол прир  = 1;
    }
export:
 
  бдол тек(бдол зн)
    {
    if(зн != бдол.init) return знач = зн;
     return знач;
   }
   
    бдол тек()
    {
     return знач;
   }

    бдол следщ()
    {
       return знач += прир;         
    }

    бдол предш()
    {
        return знач -= прир;
    }

    бдол прирост(бдол зн)
    {

		if(зн < 1) stdrus.инфо("Инициализатор прироста не может быть меньше 1");
		 return  прир = зн;	
		
    }
	
	бдол прирост()
    {
		 return  прир;			
    }

}


///конец module util.series;

//module util.linetoken;
////////////////////////
/* Как использовать ===============================
Вставьте следующее в свой код ...

  private import stdrusex;

Затем для вызова используйте ...

   ткст токены;
   ткст вхоСтрока;
   ткст разгрСим;
   ткст комментСтрока;

   токены = разбериСтроку(вхоСтрока, разгрСим, комментСтрока);
** Принимаются все аргументы типа 'ткст' или 'дим[]'.

Эта процедура сканирует входную строку и возвращает набор строк, по
одной на каждый токен, найденный во входной строке.

Эти токены разграничены единым символом из разгрСим. Однако,
если разгрСим - пустая строка, то токены разграничиваются любой группой
из одного или более пробельных символов. По умолчанию, разгрСим равен ",".

Если комментСтрока не пустая, то все части входной строки от
начала комментария до самого конца игнорируются. По умолчанию,
комментСтрока равна "//".

Если какой-то токен начинается с кавычек (единичных, двойных или обратных),то
будет получено обратно два токена. Первый - это кавычка как единичная символьная строка,
а второй - все символы до, но не включая, следующей кавычки того же типа.
Завершающая кавыхка сбрасывается.

Если токен начинается со скобки (круглые, квадратные или фигурные), то
будет получено обратно два токена. Первый - это открывающая скобка
как единичная символьная строка, а второй - все символы до, но не включая,
которые совпадают с конечной скобкой, учитывая гнездовые скобки (того же
типа).

Все пробельные символы между токенами игнорируются и не возвращаются.

Если этот токенайзер находит символ обратного слэша (\), то следующий символ
всегда рассматривается как часть какого-то токена. Это можно использовать для того,
чтобы заставить символ разграничителя или пробелы включить в какой-то токен.

Примеры:
   разбериСтроку(" abc, def , ghi, ")
 --> {"abc", "def", "ghi", ""}

   разбериСтроку("character    or spaces to be \t inserted", "")
 --> {"character", "or", "spaces", "to", "be", "inserted"}

   разбериСтроку(" abc; def , ghi; ", ";")
 --> {"abc", "def , ghi", "" }

   разбериСтроку(" abc, [def , ghi]           ")
 --> {"abc", "[", "def , ghi"}

   разбериСтроку(" abc, [def , ghi] // comment")
 --> {"abc", "[", "def , ghi"}

   разбериСтроку(" abc, [def , [ghi, jkl] ]  ")
 --> {"abc", "[", "def , [ghi, jkl] "}

   разбериСтроку(" abc, def , ghi ; comment", ",", ";")
 --> {"abc", "def", "ghi"}

   разбериСтроку(` abc, "def , ghi" , jkl `)
 --> {"abc", `"`, "def , ghi", "jkl"}
*/
export extern(D) ткст[] разбериСтроку(ткст исток,
                                      ткст разгр = ",",
                                      ткст коммент = "//",
                                      ткст искейп = "\\")
{
    дим[][] времф;
    ткст[] рез;

    времф = разбериСтроку( stdrus.вЮ32(исток),
                                       stdrus.вЮ32(разгр),
                                       stdrus.вЮ32(коммент),
                                       stdrus.вЮ32(искейп) );
    foreach( юткст строка; времф )
    {
        рез ~= stdrus.вЮ8( строка );
    }

    return рез;
}

export extern(D) юткст[] разбериСтроку(юткст исток,
                                        юткст разгр = ",",
                                        юткст коммент = "//",
                                        юткст искейп = "\\")
{
    юткст[] рез;
    дим открСкоб;
    дим закрСкоб;
    цел гнездУровень;
    цел вхоСема;
    юткст делим;
    цел местоУборки;
    цел поз;
    бул литРежим;

    static юткст vOpenBracket  = "\"'([{`";
    static юткст vCloseBracket = "\"')]}`";

    if (разгр.length > 0)
        // Используются только односимвольные разграничители.
		//Лишние символы игнорируются.
        делим ~= разгр[0];
    else
        делим = "";   // Обозначает 'любую группу пробельных символов'

    вхоСема = -1;
    местоУборки = -1;
    foreach(цел i, дим c; исток)
    {
        if (гнездУровень == 0)
        {
            // Проверка на строку комментария.
            if (коммент.length > 0)
            {
                if (c == коммент[0])
                {
                    if ((исток.length - i) > коммент.length)
                    {
                        if (исток[i .. i + коммент.length] == коммент)
                            break;
                    }
                }
            }
        }

        if(вхоСема == -1)
        {
            // Not in a токен yet.
            if (stdrus.межбукв_ли(c))
                continue;  // Пропустить лишние пробелы

            // Non-space so a токен is about to start.
            вхоСема = рез.length;
            рез.length = вхоСема + 1;
            местоУборки = -1;
        }

        if (литРежим)
        {
            // In literal character mode, so just accept the сим
            // without examining it.
            рез[вхоСема] ~= c;
            литРежим = false;
            местоУборки = -1;
            continue;
        }

        if (искейп.length > 0 && (c == искейп[0]))
        {
            // Slip into literal character mode
            литРежим = true;
            continue;
        }

        if (гнездУровень == 0)
        {
            // Only проверь for разграничители if not in 'bracket'-mode.
            if (делим.length == 0)
            {
                if (stdrus.межбукв_ли(c))
                {
                    местоУборки = -1;
                    вхоСема = -1;
                    // Go fetch next character.
                    continue;
                }
            }
            else if (c == делим[0])
            {
                // Found a токен delimiter, so I end the текущ токен.
                if (местоУборки != -1)
                {
                    // But первый I убери off trailing spaces.
                    рез[вхоСема].length = местоУборки-1;
                    местоУборки = -1;
                }
                вхоСема = рез.length;
                рез.length = вхоСема + 1;
                // Go fetch next character.
                continue;
            }
        }

        if (рез[вхоСема].length == 0)
        {
            // Not started a токен yet.
            юткст lChar;

            lChar.length = 1;
            lChar[0] = c;
            поз = stdrus.найди(stdrus.вЮ8(vOpenBracket), stdrus.вЮ8(lChar));
            if (поз != -1)
            {
                // An 'открой' bracket was found, so make this its
                // own токен, start another new one, и go into
                // 'bracket'-mode.
                рез[вхоСема] ~= c;

                вхоСема = рез.length;
                рез.length = вхоСема + 1;

                открСкоб = c;
                закрСкоб = vCloseBracket[поз];
                гнездУровень = 1;
                // Go fetch next character.
                continue;
            }
        }

        if (гнездУровень > 0)
        {
            if (c == закрСкоб)
            {
                гнездУровень--;
                if (гнездУровень == 0)
                {
                    // Okay, I've found the end of the bracketed chars.
                    // Note that this doesn't necessarily mean the end of
                    // a токен was also found. And I can start проверьing
                    // again for trailing spaces.
                    местоУборки = -1;

                    // Go fetch next character
                    continue;
                }
            }
            else if (c == открСкоб)
            {
                // Note that the сим is added to the токен too.
                гнездУровень++;
            }
        }

        // Finally, I дай to add this сим to the токен.
        рез[вхоСема] ~= c;

        if (гнездУровень == 0)
            // Only проверь for trailing spaces if not in 'bracket'-mode
            if (stdrus.межбукв_ли(c))
            {
                // It was a space, so it is potentially a trailing space,
                // thus I метка its spot (if it's the первый in a установи of spaces.)
                if (местоУборки == -1)
                    местоУборки = рез[вхоСема].length;
            }
            else
                местоУборки = -1;

    }

    if (рез.length == 0)
        рез ~= "";

    if (местоУборки != -1)
    {
        // Trim off trailing spaces on последний токен.
        рез[$-1].length = местоУборки-1;
    }

    return рез;
}
////конец module util.linetoken;

//module util.fdt;
export extern(D)
{
    /**
         Определяет способности этого типа данных
    **/
    version(Windows)
    {
        class ФайлДатаВремя
        {
            private
            {
                ФВРЕМЯ мДВ;
                бул мУст;
            }
			export:

            /**
               * Конструктор
               *
               * Определяет 'not recorded' датавремя.
               * Примеры:
               *  --------------------
               *   ФайлДатаВремя a = new ФайлДатаВремя();  // Неинициализированное датавремя.
               *  --------------------
            **/
            this()
            {
                мУст = нет;
                мДВ.датаВремяСтарш = 0;
                мДВ.датаВремяМладш = 0;
            }

            /**
               * Конструктор
               *
               * Получает файловые датавремя.
               *
               * Параметры:
               *    имяФ = Путь и имя файла, датавремя которого
               *                нужно получить.
               * Примеры:
               *  --------------------
               *   auto a = new ФайлДатаВремя("c:\\temp\\afile.txt");
               *  --------------------
            **/
            this(ткст имяФ)
            {
                ДайФВремя( имяФ );
            }

            /**
               * Constructor
               *
               * Gets the файл's date time.
               *
               * Params:
               *    имяФ = The путь и имя of the файл whose date-time
               *                you want to дай.
               * Примеры:
               *  --------------------
               *   auto a = new ФайлДатаВремя("c:\\temp\\afile.txt");
               *  --------------------
            **/
            this(шткст имяФ)
            {
                ДайФВремя( stdrus.вЮ8(имяФ));
            }

            /**
               * Constructor
               *
               * Gets the файл's date time.
               *
               * Params:
               *    имяФ = The путь и имя of the файл whose date-time
               *                you want to дай.
               * Примеры:
               *  --------------------
               *   auto a = new ФайлДатаВремя("c:\\temp\\afile.txt");
               *  --------------------
            **/
            this(юткст имяФ)
            {
                ДайФВремя( stdrus.вЮ8(имяФ) );
            }

            /**
               * Equality Оператор
               *
               * This is accurate to the секунда. That is, all times inside
               * the same секунда are considered equal. Milliseconds are
               * not considered.
               *
               * Params:
               *  другой = The ФайлДатаВремя to сравни this one to.
               *
               *
               * Примеры:
               *  --------------------
               *   ФайлДатаВремя a = SomeFunc();
               *   if (a == ФайлДатаВремя("/usr2/bin/sample")) { . . . }
               *  --------------------
            **/
            цел opEquals(ФайлДатаВремя другой)
            {
                return сравни(другой) == 0;
            }

            /**
               * Comparision Оператор
               *
               * This is accurate to the секунда. That is, all times inside
               * the same секунда are considered equal. Milliseconds are
               * not considered.
               *
               * Params:
               *  другой = The ФайлДатаВремя to сравни this one to.
               *
               *
               * Примеры:
               *  --------------------
               *   ФайлДатаВремя a = SomeFunc();
               *   if (a < ФайлДатаВремя("/usr2/bin/sample")) { . . . }
               *  --------------------
            **/
            цел opCmp(ФайлДатаВремя другой)
            {
                return сравни(другой);
            }

            /**
               * Comparision Оператор
               *
               * This is accurate to the секунда. That is, all times inside
               * the same секунда are considered equal. Milliseconds are
               * not considered.
               *
               * Params:
               *  другой = The ФайлДатаВремя to сравни this one to.
               *  точно = Flag to indicate whether or not to сравни
               *           milliseconds as well. The default is to ignore
               *           milliseconds.
               *
               * Возвращаетs: An integer that shows the degree of accuracy и
               *          the direction of the comparision.
               *
               * A negative value indicates that the текущ date-time is
               * less than the parameter's value. A positive return means
               * that the текущ date-time is greater than the parameter.
               * Zero means that they are equal in value.
               *
               * The absolute value of the returned integer indicates
               * the level of accuracy.
               * -----------------
               * 1 .. One of the date-time значения is not recorded.
               * 2 .. They are not in the same year.
               * 3 .. They are not in the same month.
               * 4 .. They are not in the same day.
               * 5 .. They are not in the same час.
               * 6 .. They are not in the same минута.
               * 7 .. They are not in the same секунда.
               * 8 .. They are not in the same миллисекунда.
               * -----------------
               *
               *
               * Примеры:
               *  --------------------
               *   ФайлДатаВремя a = SomeFunc();
               *   if (a.сравни(ФайлДатаВремя("/usr2/bin/sample"), true)) > 0)
               *   { . . . }
               *  --------------------
            **/
            цел сравни(ФайлДатаВремя другой, бул точно = false)
            {
                СИСТВРЕМЯ аВремя;
                СИСТВРЕМЯ бВремя;
                цел рез;

                if (мУст == нет)
                    if (другой.мУст == нет)
                        рез = 0;
                    else
                        рез = -1;

                else if (другой.мУст == нет)
                    рез = 1;

                else
                {
                    ФВремяВСистВремя(&мДВ, &аВремя);
                    ФВремяВСистВремя(&другой.мДВ, &бВремя);

                    if (аВремя.год > бВремя.год)
                        рез = 2;
                    else if (аВремя.год < бВремя.год)
                        рез = -2;
                    else if (аВремя.месяц > бВремя.месяц)
                        рез = 3;
                    else if (аВремя.месяц < бВремя.месяц)
                        рез = -3;
                    else if (аВремя.день > бВремя.день)
                        рез = 4;
                    else if (аВремя.день < бВремя.день)
                        рез = -4;
                    else if (аВремя.час > бВремя.час)
                        рез = 5;
                    else if (аВремя.час < бВремя.час)
                        рез = -5;
                    else if (аВремя.минута > бВремя.минута)
                        рез = 6;
                    else if (аВремя.минута < бВремя.минута)
                        рез = -6;
                    else if (аВремя.секунда > бВремя.секунда)
                        рез = 7;
                    else if (аВремя.секунда < бВремя.секунда)
                        рез = -7;

                    else if (точно)
                    {
                        if (аВремя.миллисекунды > бВремя.миллисекунды)
                            рез = 8;
                        else if (аВремя.миллисекунды < бВремя.миллисекунды)
                            рез = -8;
                        else
                            рез = 0;
                    }
                }
                return рез;
            }

            /**
               * Созд a displayable stdrus.фм of the date-time.
               *
               * The display stdrus.фм is yyyy/mm/dd HH:MM:SS.TTTT
               *
               * Params:
               *  точно = Display milliseconds or not. Default is to
               *           ignore milliseconds.
               *
               * Примеры:
               *  --------------------
               *   ФайлДатаВремя a = SomeFunc();
               *   скажифнс("Time was %s", a);
               *  --------------------
            **/
            ткст вТкст(бул точно = false)
            {
                ИНФОЧП часПояс;
                СИСТВРЕМЯ систВремя;
                СИСТВРЕМЯ локВремя;
                ФВРЕМЯ локДВ;

                if ( мУст == нет )
                    return "не записано";

                // Convert the файл's time into the user's local timezone.
                version (ЮНИКОД)
                {
                    ФВремяВСистВремя(&мДВ, &систВремя);
                    ДайИнфОЧП(&часПояс);
                    СистВремяВМестнВремяЧП(&часПояс, &систВремя, &локВремя);
                }
                else
                {
                    ФВремяВМестнФВремя(&мДВ, &локДВ);
                    ФВремяВСистВремя(&локДВ, &локВремя);
                }

                // Возвращает standardized string form of the date-time.
                //    CCYY/MM/DD hh:mm:ss
                if (точно)
                    return stdrus.фм("%04d/%02d/%02d %02d:%02d:%02d.%04d"
                                ,локВремя.год, локВремя.месяц,  локВремя.день,
                                локВремя.час, локВремя.минута, локВремя.секунда
                                ,локВремя.миллисекунды
                               );
                else
                    return stdrus.фм("%04d/%02d/%02d %02d:%02d:%02d"
                                ,локВремя.год, локВремя.месяц,  локВремя.день,
                                локВремя.час, локВремя.минута, локВремя.секунда
                               );
            }

            private проц ДайФВремя (ткст имяФ)
            {

                ПДАН lFileInfoW;
                ПДАН_А  lFileInfoA;
                ФВРЕМЯ lWriteTime;
                ткст lASCII_FileName;

                HANDLE lFH;


static if (ЮНИКОД)
                {
					lFH = НайдиПервыйФайл (замениСим(имяФ, '/', '\\'), &lFileInfoW);
										
                    if(lFH != НЕВЕРНХЭНДЛ)
                    {
                        lWriteTime = lFileInfoW.времяПоследнейЗаписи;
                    }
                }
                else
                {
                    lASCII_FileName = stdrus.вЮ8(замениСим(имяФ, '/', '\\'));

					lFH = НайдиПервыйФайлА (lASCII_FileName.ptr, &lFileInfoA);
                    if(lFH != НЕВЕРНХЭНДЛ)
                    {
                        lWriteTime = lFileInfoA.времяПоследнейЗаписи;
                    }

                }

                if(lFH != НЕВЕРНХЭНДЛ)
                {
                    мУст = да;
                    мДВ = lWriteTime;
                    НайдиЗакрой(lFH);
                }
                else
                {
                    мДВ.датаВремяСтарш = 0;
                    мДВ.датаВремяМладш = 0;
                    мУст = нет;
                }
            }

        } // End of class definition.



    }

    version(Posix)
    {
        class ФайлДатаВремя
        {
            private
            {
                ulong мДВ;
                бул мУст;
            }

            this()
            {
                мУст = нет;
                мДВ = 0;
            }

            this(ткст имяФ)
            {
                ДайФВремя( имяФ );
            }

            this(шткст имяФ)
            {
                ДайФВремя( stdrus.вЮ8(имяФ) );
            }

            this(юткст имяФ)
            {
                ДайФВремя( stdrus.вЮ8(имяФ) );
            }

            цел opCmp(ФайлДатаВремя другой)
            {
                if (мУст == нет)
                    return -1;

                if (другой.мУст == нет)
                    return 1;

                if (мДВ > другой.мДВ)
                    return 1;
                if (мДВ < другой.мДВ)
                    return -1;
                return 0;
            }

            ткст вТкст()
            {
                if ( мУст == нет )
                    return "не записано";
                else
                    return stdrus.фм("%d", мДВ);
            }

            private проц ДайФВремя(ткст имяФ)
            {

                цел файлук;
                struct_stat lFileInfo;
                сим *фимя;

                фимя = вТкст0(имяФ);
                файлук = открой(фимя, O_RDONLY);
                if (файлук != -1)
                {
                    if(fstat(файлук, &lFileInfo) == 0 )
                    {
                        мДВ  = lFileInfo.st_mtime;
                        мУст = да;
                    }
                    else
                    {
                        мДВ  = 0;
                        мУст = нет;
                    }

                    закрой(файлук);
                }
                else
                {
                    мДВ  = 0;
                    мУст = нет;
                }

            }
        } // End of class definition.
    }
}
////конец module util.fdt;
/////////////////////////////////////////////

//module ;

    extern (C)
    {
        сим*   getenv  (сим *);
        цел     putenv  (сим *);
    }

//debug = str;

///topic Strings
///proc замениСим(inout stringtype текст, дим откуда, дим куда)
///desc Replace all occurances a character with another.
//This examines each character in /i текст и where it совпадает /i откуда
// it is replaced with /i куда. /n
///b Note that /i текст can be a /ткст, /шим[], /юткст or /ббайт[] datatypes. /n
///b Note that if /i текст is a ббайт[] тип, the /i откуда и /i куда must
//be either /b ббайт or /b сим datatypes.
//
//Пример:
///код
//  ткст test;
//  test = "abc,de,frgh,ijk,kmn";
//  замениСим( test, ',', ':');
//  assert(test == "abc:de:frgh:ijk:kmn");
///endcode

//----------------------------------------------------------
export extern(D)  ббайт[] замениСим(in ббайт[] текст, ббайт откуда, ббайт куда)
//----------------------------------------------------------
out (рез){
    ббайт[] времА;
    ббайт[] времБ;

    assert( ! (рез is пусто) );

    времА = текст;
    времБ = рез;
    assert(времА.length == времБ.length);
    if ( откуда != куда)
    {
        foreach (бцел i, ббайт c; времА)
        {
            if (c == откуда)
            {
                assert(куда == времБ[i]);
            }
            else
            {
                assert(времА[i] == времБ[i]);
            }
        }
    }
    else
        assert(времА == времБ);
}
body {

    if (откуда == куда)
        return текст;

    foreach( бцел i, inout ббайт тестСим; текст)
    {
        if(тестСим == откуда) {
            ббайт[] врем = текст.dup;
            foreach( inout ббайт следщСим; врем[i .. length]){
                if(следщСим == откуда) {
                    следщСим = куда;
                }
            }

            return врем;
        }
        else {
            if (i == текст.length-1)
            {
                return текст;
            }
            else
                continue;
        }

    }
    return текст;
}

//----------------------------------------------------------
export extern(D)  ббайт[] замениСим(in ббайт[] текст, сим откуда, сим куда)
//----------------------------------------------------------
{
    return замениСим( текст, cast(ббайт)откуда, cast(ббайт)куда);
}


//----------------------------------------------------------
export extern(D) юткст замениСим(in юткст текст, дим откуда, дим куда)
//----------------------------------------------------------
out (рез){
    юткст времА;
    юткст времБ;

    assert( ! (рез is пусто) );

    времА = текст;
    времБ = рез;
    assert(времА.length == времБ.length);
    if ( откуда != куда)
    {
        foreach (бцел i, дим c; времА)
        {
            if (c == откуда)
            {
                assert(куда == времБ[i]);
            }
            else
            {
                assert(времА[i] == времБ[i]);
            }
        }
    }
    else
        assert(времА == времБ);
}
body {
    if (откуда == куда)
        return текст;

    else {
    foreach( бцел i, inout дим тестСим; текст){
        if(тестСим == откуда) {
            юткст врем = текст.dup;
            foreach( inout дим следщСим; врем[i .. length]){
                if(следщСим == откуда) {
                    следщСим = куда;
                }
            }

            return врем;
        }


    }
    // If I дай here, no changes were done.
    return текст;
}
}


//----------------------------------------------------------
export extern(D) ткст замениСим(in ткст текст, дим откуда, дим куда)
//----------------------------------------------------------
body {

    return stdrus.вЮ8( замениСим( stdrus.вЮ32(текст), откуда, куда) );

}

//----------------------------------------------------------
export extern(D) шткст замениСим(in шткст текст, дим откуда, дим куда)
//----------------------------------------------------------
body {

    return stdrus.вЮ16( замениСим( stdrus.вЮ32(текст), откуда, куда) );

}

//----------------------------------------------------------
export extern(D) ббайт[] вТкстН(ббайт[] данные)
//----------------------------------------------------------
{
    ббайт[] врем;

    врем = данные.dup;
    врем ~= '\0';
    return врем;
}

//----------------------------------------------------------
export extern(D) ткст вТкстН(ткст данные)
//----------------------------------------------------------
{
    ткст врем;

    врем = данные.dup;
    врем ~= '\0';
    return врем;
}

//----------------------------------------------------------
export extern(D) ббайт[] вТкстА(ткст данные)
//----------------------------------------------------------
{
    ббайт[] врем;

    врем.length = данные.length;
    foreach( цел i, сим текСим; данные)
    {
        врем[i] = cast(ббайт)текСим;
    }

    return врем;
}
//----------------------------------------------------------
export extern(D) ббайт[] вТкстА(шткст данные)
//----------------------------------------------------------
{
    ббайт[] врем;
    ткст lInter;

    lInter = stdrus.вЮ8( данные );
    врем.length = lInter.length;
    foreach( цел i, сим текСим; lInter)
    {
        врем[i] = cast(ббайт)текСим;
    }

    return врем;
}
//----------------------------------------------------------
export extern(D) ббайт[] вТкстА(юткст данные)
//----------------------------------------------------------
{
    ббайт[] врем;
    ткст lInter;

    lInter = stdrus.вЮ8( данные );
    врем.length = lInter.length;
    foreach( цел i, сим текСим; lInter)
    {
        врем[i] = cast(ббайт)текСим;
    }

    return врем;
}


//----------------------------------------------------------
//----------------------------------------------------------
//----------------------------------------------------------
unittest{
    debug(str) скажифнс("%s", "str.UT01: b = замениСим ( ткст a, lit, lit) ");
    ткст testA;
    ткст testB;
    ткст testC;

    testA = "abcdbefbq";
    testB = "a cd ef q";
    testC = замениСим(testA, 'b', ' ');
    assert( testC == testB);
    assert( testA != testB);
}

unittest{
    debug(str)  скажифнс("%s", "str.UT02: a = замениСим ( ткст a, lit, lit) ");
    ткст testA;
    ткст testB;
    ткст testC;

    testA = "abcdbefbq";
    testB = "a cd ef q";
    testA = замениСим(testA, 'b', ' ');
    assert( testA == testB);
}

unittest{
    debug(str)  скажифнс("%s", "str.UT03: замениСим ( ткст, 'b', 'b') ");
    ткст testA;
    ткст testB;
    ткст testC;

    testA = "abcdbefbq";
    testB = "abcdbefbq";
    testC = замениСим(testA, 'b', 'b');
    assert( testC == testB);
    assert( testA == testB);
}

unittest{
    debug(str)  скажифнс("%s", "str.UT04: замениСим ( шим[], lit, lit) ");
    шткст testA;
    шткст testB;
    шткст testC;

    testA = "abcdbefbq";
    testB = "a cd ef q";
    testC = замениСим(testA, 'b', ' ');
    assert( testC == testB);
    assert( testA != testB);
}

unittest{
    debug(str)  скажифнс("%s", "str.UT05: замениСим ( дим[], lit, lit) ");
    юткст testA;
    юткст testB;
    юткст testC;

    testA = "abcdbefbq";
    testB = "a cd ef q";
    testC = замениСим(testA, 'b', ' ');
    assert( testC == testB);
    assert( testA != testB);
}

unittest{
    debug(str)  скажифнс("%s", "str.UT06: замениСим ( ткст, шим, шим) ");
    ткст testA;
    ткст testB;
    ткст testC;
    шим f,t;

    testA = "abcdbefbq";
    testB = "a cd ef q";
    f = 'b';
    t = ' ';
    testC = замениСим(testA, f, t);
    assert( testC == testB);
    assert( testA != testB);

}

unittest{
    debug(str)  скажифнс("%s", "str.UT07: замениСим ( дим[], дим, дим) ");
    юткст testA;
    юткст testB;
    юткст testC;
    дим f,t;

    testA = "abcdbefbq";
    testB = "axcdxefxq";
    f = 'b';
    t = 'x';
    testC = замениСим(testA, f, t);
    assert( testC == testB);
    assert( testA != testB);
}

unittest{
    debug(str)  скажифнс("%s", "str.UT08: замениСим ( ббайт[], ббайт, ббайт) ");
    ббайт[] testA;
    ббайт[] testB;
    ббайт[] testC;
    ббайт f,t;

    testA = вТкстА(cast(ткст)"abcdbefbq");
    testB = вТкстА(cast(ткст)"a cd ef q");
    f = 'b';
    t = ' ';
    testC = замениСим(testA, f, t);
    assert( testC == testB);
    assert( testA != testB);
}

unittest{
    debug(str)  скажифнс("%s", "str.UT09: замениСим ( ббайт[], сим, сим) ");
    ббайт[] testA;
    ббайт[] testB;
    ббайт[] testC;
    сим f,t;

    testA = вТкстА(cast(ткст)"abcdbefbq");
    testB = вТкстА(cast(ткст)"a cd ef q");
    f = 'b';
    t = ' ';
    testC = замениСим(testA, f, t);
    assert( testC == testB);
    assert( testA != testB);
}

    // ---- вТкстА() -----
unittest{
    debug(str)  скажифнс("%s", "str.UT10: вТкстА( ткст) ");
    ббайт[] testA;
    ткст testB;
    ббайт[] testC;
    цел c;

    testB = "abcdef";
    testA = вТкстА(testB);
    c = 0;
    assert(testA.length == testB.length);
    foreach (бцел i, ббайт x; testA)
    {
        if (x == testB[i])
            c++;
    }
    assert( c == testA.length);
}

unittest{
    debug(str)  скажифнс("%s", "str.UT11: вТкстА( шим[]) ");
    ббайт[] testA;
    шткст testB;
    ббайт[] testC;
    цел c;

    testB = "abcdef";
    testA = вТкстА(testB);
    c = 0;
    assert(testA.length == testB.length);
    foreach (бцел i, ббайт x; testA)
    {
        if (x == testB[i])
            c++;
    }
    assert( c == testA.length);
}

unittest{
    debug(str)  скажифнс("%s", "str.UT12: вТкстА( дим[]) ");
    ббайт[] testA;
    юткст testB;
    ббайт[] testC;
    цел c;

    testB = "abcdef";
    testA = вТкстА(testB);
    c = 0;
    assert(testA.length == testB.length);
    foreach (бцел i, ббайт x; testA)
    {
        if (x == testB[i])
            c++;
    }
    assert( c == testA.length);
}

/*
    подобен_ли does a simple pattern совпадают process. The pattern
    string can contain special токены ...
       '*'   Represents zero or more characters in the text.
       '?'   Represents exactly one character in the text.
       '\'   Is the escape pattern. The next text character
             must exactly сверь the character following the
             escape character. This is использован to сверь the
             токены if they appear in the text.


*/
export extern(D) бул подобен_ли(юткст текст, юткст образец)
body {
    const дим kZeroOrMore = '*';
    const дим kExactlyOne = '?';
    const дим kEscape     = '\\';
    бцел  lTX = 0;
    бцел  lPX = 0;
    бцел  lPMark;
    бцел  lTMark;

    lPMark = образец.length;
    lTMark = 0;

    // If we haven't got any pattern or text лево then we can finish.
    while(lPX < образец.length && lTX < текст.length)
    {
        if (образец[lPX] == kZeroOrMore)
        {
            // Skip over any adjacent '*'
            while( lPX < образец.length &&
                   образец[lPX] == kZeroOrMore)
            {
                lPMark = lPX;
                lPX++;
            }

            // Look for next сверь in text for текущ pattern сим
            if ( lPX >= образец.length)
            {
                // Skip rest of text if there is no pattern лево. This
                // can occur when the pattern оканчивается_на with a '*'.
                lTX = текст.length;
            }
            else while( lPX < образец.length && lTX < текст.length)
            {
                // Skip over any escape lead-in сим.
                if (образец[lPX] == kEscape && lPX < образец.length - 1)
                    lPX++;

                if (образец[lPX] == текст[lTX] ||
                    образец[lPX] == kExactlyOne)
                {
                    // We found the start of a potentially совпадают sequence.
                    // so increment over the совпадают сим in preparation
                    // for a new subsequence scan.
                    lPX++;
                    lTX++;
                    // Mark the place in the text in case we have to do
                    // a rescan later.
                    lTMark = lTX;

                    // Stop doing this subsequence scan.
                    break;
                }
                else
                {
                    // No сверь found yet, so look at the next text сим.
                    lTX++;
                }
            }
        }
        else if (образец[lPX] == kExactlyOne)
        {
            // Don't bother comparing the text сим, just assume it совпадает.
            lTX++;
            lPX++;
        }
        else
        {
            if (образец[lPX] == kEscape)
            {
                // Skip over the escape lead-in сим.
                lPX++;
            }

            if (текст[lTX] == образец[lPX])
            {
                // Text сим совпадает pattern сим so slide both to next сим.
                lTX++;
                lPX++;
            }
            else
            {
                // Non-сверь, so установи index to последний проверь point значения,
                // и try a new subsequence scan.
                lPX = lPMark;
                lTX = lTMark;
            }
        }
    }

    if (lTX >= текст.length)
    {
        // Skip over any final '*' in pattern.
        while( lPX < образец.length && образец[lPX] == kZeroOrMore)
        {
            lPX++;
        }
    }

    // If I have no text и no pattern лево then the text matched the pattern.
    if (lTX >= текст.length  && lPX >= образец.length)
        return да;
    // otherwise it doesn't.
    return нет;
}

export extern(D) бул подобен_ли(ткст текст, ткст образец )
{
    return подобен_ли( stdrus.вЮ32(текст), stdrus.вЮ32(образец));
}

//-------------------------------------------------------
export extern(D) бул начинается_с(ткст строка, ткст подстрока)
//-------------------------------------------------------
{
    return начинается_с( stdrus.вЮ32(строка), stdrus.вЮ32(подстрока));
}

//-------------------------------------------------------
export extern(D) бул начинается_с(шткст строка, шткст подстрока)
//-------------------------------------------------------
{
    return начинается_с( stdrus.вЮ32(строка), stdrus.вЮ32(подстрока));
}

//-------------------------------------------------------
export extern(D) бул начинается_с(юткст строка, юткст подстрока)
//-------------------------------------------------------
{
    if (строка.length < подстрока.length)
        return нет;
    if (подстрока.length == 0)
        return нет;

    if (строка[0..подстрока.length] == подстрока)
        return да;
    return нет;
}

//-------------------------------------------------------
export extern(D) бул оканчивается_на(ткст строка, ткст подстрока)
//-------------------------------------------------------
{
    return оканчивается_на( stdrus.вЮ32(строка), stdrus.вЮ32(подстрока));
}

//-------------------------------------------------------
export extern(D) бул оканчивается_на(шткст строка, шткст подстрока)
//-------------------------------------------------------
{
    return оканчивается_на( stdrus.вЮ32(строка), stdrus.вЮ32(подстрока));
}

//-------------------------------------------------------
export extern(D) бул оканчивается_на(юткст строка, юткст подстрока)
//-------------------------------------------------------
{
    бцел lРазмер;

    if (строка.length < подстрока.length)
        return нет;
    if (подстрока.length == 0)
        return нет;

    lРазмер = строка.length-подстрока.length;
    if (строка[lРазмер .. $] != подстрока)
        return нет;

    return да;
}


//-------------------------------------------------------
export extern(D) ткст в_кавычках(ткст строка, сим pTrigger = ' ', ткст pPrefix = `"`, ткст pSuffix = `"`)
//-------------------------------------------------------
{
    if ( (строка.length > 0) &&
         (stdrus.найди(строка, pTrigger) != -1) &&
		 (начинается_с(строка, pPrefix) == нет) &&
		 (оканчивается_на(строка, pSuffix) == нет)
       )
        return pPrefix ~ строка ~ pSuffix;

    return строка;
}

//-------------------------------------------------------
export extern(D) шткст в_кавычках(шткст строка, шим pTrigger = ' ', шткст pPrefix = `"`, шткст pSuffix = `"`)
//-------------------------------------------------------
{
    шткст lTrigger;
    lTrigger.length = 1;
    lTrigger[0] = pTrigger;
    if ( (строка.length > 0) &&
         (найди(строка, lTrigger,0 ) != -1) &&
		 (начинается_с(строка, pPrefix) == нет) &&
		 (оканчивается_на(строка, pSuffix) == нет)
       )
        return pPrefix ~ строка ~ pSuffix;

    return строка;
}

//-------------------------------------------------------
export extern(D) юткст в_кавычках(юткст строка, дим pTrigger = ' ', юткст pPrefix = `"`, юткст pSuffix = `"`)
//-------------------------------------------------------
{
    юткст lTrigger;
    lTrigger.length = 1;
    lTrigger[0] = pTrigger;
    if ( (строка.length > 0) &&
         (найди(строка, lTrigger,0) != -1) &&
		 (начинается_с(строка, pPrefix) == нет) &&
		 (оканчивается_на(строка, pSuffix) == нет)
       )
        return pPrefix ~ строка ~ pSuffix;

    return строка;
}

unittest
{ // подобен_ли
     debug(str)  скажифнс("str.подобен_ли.UT00");
     assert( подобен_ли( "foobar"c, "foo?*"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT01");
     assert( подобен_ли( "foobar"c, "foo*"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT02");
     assert( подобен_ли( "foobar"c, "*bar"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT03");
     assert( подобен_ли( ""c, "foo*"c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT04");
     assert( подобен_ли( ""c, "*bar"c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT05");
     assert( подобен_ли( ""c, "?"c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT06");
     assert( подобен_ли( ""c, "*"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT06a");
     assert( подобен_ли( ""c, "x"c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT06b");
     assert( подобен_ли( "x"c, ""c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT07");
     assert( подобен_ли( "f"c, "?"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT08");
     assert( подобен_ли( "f"c, "*"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT09");
     assert( подобен_ли( "foo"c, "?oo"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT10");
     assert( подобен_ли( "foobar"c, "?oo"c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT11");
     assert( подобен_ли( "foobar"c, "?oo*"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT12");
     assert( подобен_ли( "foobar"c, "*oo*b*"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT13");
     assert( подобен_ли( "foobar"c, "*oo*ar"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT14");
     assert( подобен_ли( "terrainformatica.com"c, "*.com"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT15");
     assert( подобен_ли( "12abcdef"c, "*abc?e*"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT16");
     assert( подобен_ли( "12abcdef"c, "**abc?e**"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT17");
     assert( подобен_ли( "12abcdef"c, "*"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT18");
     assert( подобен_ли( "12abcdef"c, "?*"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT19");
     assert( подобен_ли( "12abcdef"c, "*?"c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT20");
     assert( подобен_ли( "12abcdef"c, "?*?"c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT21");
     assert( подобен_ли( "12abcdef"c, "*?*"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT22");
     assert( подобен_ли( "12"c, "??"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT23");
     assert( подобен_ли( "123"c, "??"c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT24");
     assert( подобен_ли( "12"c, "??3"c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT25");
     assert( подобен_ли( "12"c, "???"c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT25a");
     assert( подобен_ли( "123"c, "?2?"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT25b");
     assert( подобен_ли( "abc123def"c, "*?2?*"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT25c");
     assert( подобен_ли( "2"c, "2?*"c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT26");
     assert( подобен_ли( ""c, ""c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT27");
     assert( подобен_ли( "abc"c, "abc"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT28");
     assert( подобен_ли( "abc"c, ""c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT29");
     assert( подобен_ли( "abc*d"c, "abc\\*d"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT30");
     assert( подобен_ли( "abc?d"c, "abc\\?d"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT31");
     assert( подобен_ли( "abc\\d"c, "abc\\\\d"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT31a");
     assert( подобен_ли( "abc*d"c, "abc\\*d"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT31b");
     assert( подобен_ли( "abc\\d"c, "abc\\*d"c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT31c");
     assert( подобен_ли( "abc\\d"c, "abc\\*d"c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT31d");
     assert( подобен_ли( "abc\\d"c, "*\\*d"c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT31e");
     assert( подобен_ли( "abc\\d"c, "*\\\\d"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT32");
     assert( подобен_ли( "foobar"c, "foo???"c) == да);
     debug(str)  скажифнс("str.подобен_ли.UT33");
     assert(  подобен_ли( "foobar"c, "foo????"c) == нет);
     debug(str)  скажифнс("str.подобен_ли.UT34");
     assert(  подобен_ли( "c:\\dindx_a\\index_000.html"c, "*index_???.html"c) == да);
}


unittest
{  // начинается_с
     debug(str)  скажифнс("str.начинается_с.UT01");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"o") == нет);
     debug(str)  скажифнс("str.начинается_с.UT02");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"f") == да);
     debug(str)  скажифнс("str.начинается_с.UT03");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"fo") == да);
     debug(str)  скажифнс("str.начинается_с.UT04");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"foo") == да);
     debug(str)  скажифнс("str.начинается_с.UT05");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"foob") == да);
     debug(str)  скажифнс("str.начинается_с.UT06");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"fooba") == да);
     debug(str)  скажифнс("str.начинается_с.UT07");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"foobar") == да);
     debug(str)  скажифнс("str.начинается_с.UT08");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"foobarx") == нет);
     debug(str)  скажифнс("str.начинается_с.UT09");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"oo") == нет);
     debug(str)  скажифнс("str.начинается_с.UT10");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"") == нет);
     debug(str)  скажифнс("str.начинается_с.UT11");
     assert( начинается_с( cast(ткст)"", cast(ткст)"") == нет);
}

unittest
{  // оканчивается_на
     debug(str)  скажифнс("str.оканчивается_на.UT01");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"a") == нет);
     debug(str)  скажифнс("str.оканчивается_на.UT02");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"r") == да);
     debug(str)  скажифнс("str.оканчивается_на.UT03");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"ar") == да);
     debug(str)  скажифнс("str.оканчивается_на.UT04");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"bar") == да);
     debug(str)  скажифнс("str.оканчивается_на.UT05");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"obar") == да);
     debug(str)  скажифнс("str.оканчивается_на.UT06");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"oobar") == да);
     debug(str)  скажифнс("str.оканчивается_на.UT07");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"foobar") == да);
     debug(str)  скажифнс("str.оканчивается_на.UT08");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"foobarx") == нет);
     debug(str)  скажифнс("str.оканчивается_на.UT09");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"oo") == нет);
     debug(str)  скажифнс("str.оканчивается_на.UT10");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"") == нет);
     debug(str)  скажифнс("str.оканчивается_на.UT11");
     assert( оканчивается_на( cast(ткст)"", cast(ткст)"") == нет);
}

export extern(D) ткст раскрой(ткст pOriginal, ткст pTokenList,
                ткст pLeading = "{", ткст pTrailing = "}")
{
    return stdrus.вЮ8( раскрой (
                    stdrus.вЮ32(pOriginal),
                    stdrus.вЮ32(pTokenList),
                    stdrus.вЮ32(pLeading),
                    stdrus.вЮ32(pTrailing)
                    ) ) ;

}

export extern(D) юткст раскрой(юткст pOriginal, юткст pTokenList,
                юткст pLeading = "{", юткст pTrailing = "}")
{
    юткст lResult;
    дим[][] lTokens;
    цел lPos;
    struct KV
    {
        юткст Key;
        юткст Value;
    }

    KV[] lKeyValues;

    lResult = pOriginal.dup;

    // Split up токен list into separate токен pairs.
    lTokens = разбериСтроку(pTokenList, ","d, "", "");
    foreach(дим [] lKV; lTokens)
    {
        дим[][] lKeyValue;
        if (lKV.length > 0)
        {
            lKeyValue = разбериСтроку(lKV, "="d, "", "");
            lKeyValues.length = lKeyValues.length + 1;
            lKeyValues[$-1].Key = lKeyValue[0];
            lKeyValues[$-1].Value = lKeyValue[1];
        }
    }

    // First to the simple replacements.
    foreach(KV lKV; lKeyValues)
    {
        юткст lToken;

        lToken = pLeading ~ lKV.Key ~ pTrailing;
        while( (lPos = найди(lResult, lToken,0 )) != -1 )
        {
            lResult = lResult[0..lPos] ~
                      lKV.Value ~
                      lResult[lPos + lToken.length .. $];
        }
    }

    // Now проверь for conditional replacements
    foreach(KV lKV; lKeyValues)
    {
        юткст lToken;
        юткст lOptValue;

        // First проверь for missing conditionals...
        lToken = pLeading ~ "?" ~ lKV.Key ~ ":";
        while ( (lPos = найди(lResult, lToken,0)) != -1)
        {
            цел lEndPos;
            lEndPos = найди(lResult, pTrailing, lPos+lToken.length);
            if (lEndPos != -1)
            {
                lOptValue = lResult[lPos+lToken.length..lEndPos].dup;
                if (lKV.Value.length == 0)
                {
                    lResult = lResult[0..lPos] ~
                              lOptValue ~
                              lResult[lEndPos+pTrailing.length .. $];
                }
                else
                {
                    lResult = lResult[0..lPos] ~
                              lKV.Value ~
                              lResult[lEndPos+pTrailing.length .. $];
                }
            }

        }

        // Next проверь for present conditionals...
        lToken = pLeading ~ "?" ~ lKV.Key ~ "=";
        while ( (lPos = найди(lResult, lToken, 0)) != -1)
        {
            цел lEndPos;
            lEndPos = найди(lResult, pTrailing, lPos+lToken.length);
            if (lEndPos != -1)
            {
                lOptValue = lResult[lPos+lToken.length..lEndPos].dup;
                if (lKV.Value.length != 0)
                {
                    lResult = lResult[0..lPos] ~
                              lOptValue ~
                              lResult[lEndPos+pTrailing.length .. $];
                }
                else
                {
                    lResult = lResult[0..lPos] ~
                              lResult[lEndPos+pTrailing.length .. $];
                }
            }

        }
    }

    // Now remove all неиспользовано токены.
    while( (lPos = найди(lResult, pLeading,0 )) != -1)
    {
        цел lPos1;
        цел lPos2;
        цел lPos3;

        lPos2 = найди(lResult, pTrailing, lPos + 1 );
        if (lPos2 == -1)
            break;

        if (lResult[lPos+1] == '?')
        {
            lPos3 = найди(lResult, ":"d, lPos + 1 );
            if (lPos3 != -1 && lPos3 < lPos2)
            {
                // Replace entire токен with default value from внутри токен.
                lResult = lResult[0 .. lPos] ~
                    lResult[lPos3+1 .. lPos2] ~
                    lResult[lPos2 + pTrailing.length .. $];
            }
            else
            {
                // Remove entire токен from результат.
                lResult = lResult[0 .. lPos] ~
                    lResult[lPos2 + pTrailing.length .. $];
            }
        }
        else
            // Remove entire токен from результат.
            lResult = lResult[0 .. lPos] ~
                lResult[lPos2 + pTrailing.length .. $];
    }

    return lResult;
}
unittest
{  // раскрой
     assert( раскрой( "foo{что}"c, "что=bar"c) == "foobar");
     assert( раскрой( "foo{что}"c, "when=bar"c) == "foo");
     assert( раскрой( "foo{что}"d, "что="d) == "foo");
     assert( раскрой( "foo что"c, "что=bar"c) == "foo что");
     assert( раскрой( "foo^что$"c, "что=bar"c, "^"c, "$"c) == "foobar");
     assert( раскрой( "foo$(что)"c, "что=bar"c, "$("c, ")"c) == "foobar");
     assert( раскрой( "foo{?что:who}bar"c, "что="c) == "foowhobar");
     assert( раскрой( "foo{?что:who}bar"c, ""c) == "foowhobar");
     assert( раскрой( "foo{?что:who}bar"c, "who=why"c) == "foowhobar");
     assert( раскрой( "foo{?что:who}bar"c, "что=when"c) == "foowhenbar");
     assert( раскрой( "foo{?что=who}bar"c, "что="c) == "foobar");
     assert( раскрой( "foo{?что=who}bar"c, ""c) == "foobar");
     assert( раскрой( "foo{?что=who}bar"c, "who=why"c) == "foobar");
     assert( раскрой( "foo{?что=,}bar"c, "что=when"c) == "foo,bar");
}

export extern(D) ткст вАски(ткст pUTF8)
{
    бул lChanged;
    ткст lResult;
    // Convert non-ASCII chars based on the Microsoft DOS Western Europe charset
    static ткст lTranslateTable =
        "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F"
        "\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F"
        " !\"#$%&'()*+,-./0123456789:;<=>?"
        "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_"
        "`abcdefghijklmnopqrstuvwxyz{|}~ "
        "CueaaaaceeeiiiAAEaAooouuyOUo$Oxf"
        "aiounNa0?R!24!<>-----AAAC----c$-"
        "------aA-------$dDEEEiIII----|I-"
        "OBOOoOmdDUUUyY-'-+=3PS/,0:.132- ";
    lResult = pUTF8;
    for (цел i = 0; i < lResult.length; i++)
    {
        if (lResult[i] > 127)
        {
            if (lChanged == false)
            {
                lResult = pUTF8.dup;
                lChanged = true;
            }
            lResult[i] = lTranslateTable[lResult[i]];
        }
    }
    return lResult;
}

/**************************************
 * Split s[] into an массив of строки,
 * using CR, LF, либо CR-LF as the delimiter.
 * The delimiter is not included in the line.
 */


private static юткст Unicode_WhiteSpace =
    "\u0009\u000A\u000B\u000C\u000D"  // TAB, NL, , NP, CR
    // "\u0020"  // SPACE
    "\u0085" // <control-0085>
    // "\u00A0" // NO-BREAK SPACE
    "\u1680" // OGHAM SPACE MARK
    "\u180E" // MONGOLIAN VOWEL SEPARATOR
    "\u2000\u2001\u2002\u2003\u2004"
    "\u2005\u2006\u2007\u2008"
    "\u2009\u200A" // EN QUAD..HAIR SPACE
    "\u2028" // LINE SEPARATOR
    "\u2029" // PARAGRAPH SEPARATOR
    // "\u202F" // NARROW NO-BREAK SPACE
    "\u205F" // MEDIUM MATHEMATICAL SPACE
    "\u3000" // IDEOGRAPHIC SPACE
    "\ufffd" // Stop
    ;

export extern(D) бул ЮК_пбел_ли(дим pChar)
{
    цел i;
    if (pChar == '\u0020') // Common case первый.
        return true;

    while( pChar > Unicode_WhiteSpace[i])
        i++;
    return (pChar == Unicode_WhiteSpace[i] ? true : false);
}

// Returns a slice up to the первый whitespace (if any)
export extern(D) ткст найдипбел(ткст текст)
{
    foreach(цел lPos, дим c; текст)
    {
        if (ЮК_пбел_ли(c))
            return текст[0..lPos];
    }
    return текст;
}
unittest
{
    assert(найдипбел("abc def") == "abc");
    assert(найдипбел("\u3056\u2123 def") == "\u3056\u2123");
    assert(найдипбел("\u3056\u2123\u2028def") == "\u3056\u2123");
}

// Returns a slice from the последний whitespace (if any) to the end
export extern(D) юткст найдипбелрек(юткст текст)
{
    цел lPos = текст.length-1;
    while (lPos >= 0 && !ЮК_пбел_ли(текст[lPos]))
        lPos--;

    return текст[lPos+1..$];
}

/*****************************************
 * Strips leading or trailing whitespace, либо both.
 */

export extern(D) юткст уберил(юткст s)
{
    цел i;

    foreach (цел p, дим c; s)
    {
	    if (!ЮК_пбел_ли(c))
	    {
    	    i = p;
	        break;
        }
    }
    return s[i .. s.length];
}
export extern(D) ткст уберил(ткст s) /// описано ранее
{
    return stdrus.вЮ8(уберил(stdrus.вЮ32(s)));
}


export extern(D) юткст уберип(юткст s) /// описано ранее
{
    цел i;

    for (i = s.length-1; i >= 0; i--)
    {
	if (!ЮК_пбел_ли(s[i]))
	    break;
    }
    return s[0 .. i+1];
}

export extern(D) ткст уберип(ткст s) /// описано ранее
{
    return stdrus.вЮ8(уберип(stdrus.вЮ32(s)));
}

export extern(D) юткст убери(юткст s) /// описано ранее
{
    return уберип(уберил(s));
}

export extern(D) шткст убери(шткст s) /// описано ранее
{
    return stdrus.вЮ16(уберип(уберил(stdrus.вЮ32(s))));
}

export extern(D) ткст убери(ткст s) /// описано ранее
{
    return stdrus.вЮ8(уберип(уберил(stdrus.вЮ32(s))));
}

unittest
{
    юткст s;

    s = убери("  foo\t "d);
    assert(s == "foo"d);
    s = уберип("  foo\t "d);
    assert(s == "  foo"d);
    s = уберил("  foo\t "d);
    assert(s == "foo\t "d);
}

template Шнайди(T)
{
    цел найди(T[] текст, T[] pSubText, цел откуда = 0)
    {
        цел lTexti;
        цел lSubi;
        цел lPos;
        цел lTextEnd;

        if (откуда < 0)
            откуда = 0;

        // locate первый сверь.
        lSubi = 0;
        lTexti = откуда;
        // No point in looking past this позиция.
        lTextEnd = текст.length - pSubText.length + 1;
        while(lSubi < pSubText.length)
        {
            while(lTexti < lTextEnd && pSubText[lSubi] != текст[lTexti])
            {
                lTexti++;
            }
            if (lTexti >= текст.length)
                return -1;

            lPos = lTexti;  // Mark possible start of substring сверь.

            lTexti++;
            lSubi++;
            // Locate all совпадает
            while(lTexti < текст.length && lSubi < pSubText.length &&
                        pSubText[lSubi] == текст[lTexti])
            {
                lTexti++;
                lSubi++;
            }
            if (lSubi == pSubText.length)
                return lPos;
            lSubi = 0;
            lTexti = lPos + 1;
        }
        return -1;
    }
}
alias Шнайди!(дим).найди найди;
alias Шнайди!(шим).найди найди;

unittest
{
    юткст цель = "abcdefgcdemn"d;
    assert( найди(цель, "mno") == -1);
    assert( найди(цель, "mn") == 10);
    assert( найди(цель, "cde") == 2);
    assert( найди(цель, "cde"d, 3) == 7);
    assert( найди(цель, "cde"d, 8) == -1);
    assert( найди(цель, "cdg") == -1);
    assert( найди(цель, "f") == 5);
    assert( найди(цель, "q") == -1);
    assert( найди(цель, "a"d, 200) == -1);
    assert( найди(цель, "") == -1);
    assert( найди("", цель, 0) == -1);
    assert( найди(""d, "") == -1);
    assert( найди(цель, "d"d, -4) == 3);
}

export extern(D) ткст транслируйЭск(ткст текст)
{
    ткст lResult;
    цел lInPos;
    цел lOutPos;

    if (stdrus.найди(текст, '\\') == -1)
        return текст;

    lResult.length = текст.length;
    lInPos = 0;
    lOutPos = 0;

    while(lInPos < текст.length)
    {
        if (текст[lInPos] == '\\' && lInPos+1 != текст.length)
        {
            switch (текст[lInPos+1])
            {
                case 'n':
                    lInPos += 2;
                    lResult[lOutPos] = '\n';
                    break;
                case 't':
                    lInPos += 2;
                    lResult[lOutPos] = '\t';
                    break;
                case 'r':
                    lInPos += 2;
                    lResult[lOutPos] = '\r';
                    break;
                case '\\':
                    lInPos += 2;
                    lResult[lOutPos] = '\\';
                    break;
                default:
                    lResult[lOutPos] = текст[lInPos];
                    lInPos++;
            }
        }
        else
        {
            lResult[lOutPos] = текст[lInPos];
            lInPos++;
        }

        lOutPos++;
    }

    return lResult[0..lOutPos];
}

unittest
{
    assert( транслируйЭск("abc") == "abc");
    assert( транслируйЭск("\\n") == "\n");
    assert( транслируйЭск("\\t") == "\t");
    assert( транслируйЭск("\\r") == "\r");
    assert( транслируйЭск("\\\\") == "\\");
    assert( транслируйЭск("\\q") == "\\q");
}

// Function to replace токены in the form %<SYM>%  with environment data.
// Note that '%%' is replaced by a single '%'.
// -------------------------------------------
export extern(D) ткст разверниПеремСреды(ткст pLine)
// -------------------------------------------
{
    ткст lLine;
    ткст lSymName;
    цел lPos;
    цел lEnd;

    lPos = stdrus.найди(pLine, '%');
    if (lPos == -1)
        return pLine;

    lLine = pLine[0.. lPos].dup;
    for( ; lPos < pLine.length; lPos++ )
    {
        if (pLine[lPos] == '%')
        {
            if (lPos+1 != pLine.length && pLine[lPos+1] == '%')
            {
                lLine ~= '%';
                lPos++;
                continue;
            }

            for(lEnd = lPos+1; (lEnd < pLine.length) && (pLine[lEnd] != '%'); lEnd++ )
            {
            }
            if (lEnd < pLine.length)
            {
                lSymName = pLine[lPos+1..lEnd];

                if (lSymName.length > 0)
                {
                    lLine ~= дайСред(stdrus.вЮ8(lSymName));
                }
                lPos = lEnd;
            }
            else
            {
                lLine ~= pLine[lPos];
            }
        }
        else
        {
            lLine ~= pLine[lPos];
        }
    }
    return lLine;
}
unittest {
    устСред("EEVA", __FILE__ );
    устСред("EEVB", __DATE__ );
    устСред("EEVC", __TIME__ );
    assert( разверниПеремСреды("Файл '%EEVA%' скомпилирован на %EEVB% в %EEVC%") ==
      "Файл '" ~ __FILE__ ~"' скомпилирован на " ~
      __DATE__ ~ " в " ~ __TIME__);
}

//-------------------------------------------------------
export extern(D) ткст дайСред(ткст символ)
//-------------------------------------------------------
{
    return stdrus.вТкст(getenv(stdrus.вТкст0(символ)));
}

//-------------------------------------------------------
export extern(D) проц устСред(ткст символ, ткст знач, бул переписать = true)
//-------------------------------------------------------
{
    if (переписать || дайСред(символ).length == 0)
        putenv(stdrus.вТкст0(символ ~ "=" ~ знач));
}

unittest {
    устСред("SetEnvUnitTest", __FILE__ ~ __TIMESTAMP__);
    assert( дайСред("SetEnvUnitTest") == __FILE__ ~ __TIMESTAMP__);
}

template Шдн(T)
{
	//-------------------------------------------------------
	бул ДаНет(T[] текст, бул дефолт)
	//-------------------------------------------------------
	{
		бул lResult = дефолт;
		foreach(цел i, дим c; текст)
		{
			if (c == '=' || c == ':')
			{
				текст = уберил(текст[i+1 .. $]);
				break;
			}
		}
		if (текст.length > 0)
		{
			if (текст[0] == 'Y' || текст[0] == 'y')
				lResult = true;
			else if (текст[0] == 'N' || текст[0] == 'n')
				lResult = false;
		}

		return lResult;
	}
	//-------------------------------------------------------
	проц ДаНет(T[] текст, out бул рез, бул дефолт)
	//-------------------------------------------------------
	{
		рез = ДаНет(текст, дефолт);
	}

	//-------------------------------------------------------
	проц ДаНет(T[] текст, out T[] рез, бул дефолт)
	//-------------------------------------------------------
	{
		рез = (ДаНет(текст, дефолт) ? cast(T[])"Y" : cast(T[])"N").dup;
	}

	//-------------------------------------------------------
	проц ДаНет(T[] текст, out T рез, бул дефолт)
	//-------------------------------------------------------
	{
		рез = (ДаНет(текст, дефолт) ? 'Y' : 'N');
	}
	//-------------------------------------------------------
	проц ДаНет(T[] текст, out бул рез, бул дефолт)
	//-------------------------------------------------------
	{
		рез = (ДаНет(текст, (дефолт==да?true:false)) ? да : нет);
	}
}
alias Шдн!(дим).ДаНет ДаНет;
alias Шдн!(сим).ДаНет ДаНет;

/////////////////////конец module 

//module util.fileex
/////////////////////

    alias Exception Ошибка;

    ткст[] vGrepOpts;

    class ФайлДопИскл : Ошибка
    {
        this(ткст pMsg)
        {
            super (__FILE__ ~ ":" ~ pMsg);
        }
    }



public
{
    version(BuildVerbose) бул подробно;
    бул тестЗапуск;
    ткст расширениеЭкзэ;
    ткст идПути;
}
// Module constructor
// ----------------------------------------------
static this()
// ----------------------------------------------
{
    version(Windows)
    {
        расширениеЭкзэ = "exe";
        идПути = "PATH";
    }
    version(Posix)
    {
        расширениеЭкзэ = "";
        идПути = "PATH";
    }
    version(BuildVerbose) подробно = нет;
    тестЗапуск = нет;
}

enum ОпцПолучения
{
    Есть = 'e',   // Must exist otherwise Get fails.
    Всегда = 'a'    // Get always returns something, even if it's just
                   //   empty строки for a missing файл.
};

//import std.file;
export extern(D):

// Зачитать весь файл в текстовое представление.
ткст дайТекст(ткст имяф, ОпцПолучения опц = ОпцПолучения.Всегда)
{
    if (stdrus.естьФайл( имяф))
    {
	    //auto ф = new io.File.Файл(имяф);
       // ткст текстф = cast(ткст) ф.читай;
	    ткст текстф = cast(ткст)читайФайл(имяф);
		
        if ( (текстф.length == 0) ||
                (текстф[$-1] != '\n'))
				{
            текстф ~= РАЗДСТР;
			}
			
			return текстф;
    }
    else if (опц == ОпцПолучения.Есть)
    {
        throw new ФайлДопИскл( stdrus.фм("Файл '%s' не найден.", имяф));
    }
    

}

// Чит a entire файл in to a установи of строки (strings).
ткст[] дайТекстПострочно(ткст имяф, ОпцПолучения опц = ОпцПолучения.Всегда)
{
    auto текст = дайТекст(имяф, опц);
    auto строки = stdrus.разбейнастр( текст );
    return строки;
}

enum ОпцСоздания
{
    Новый = 'n',      // Must create a new файл, thus it cannot already exist.
    Создать = 'c',   // Can either create or replace; it doesn't matter.
    Заменить = 'r'   // Must replace an existing файл.
};

проц создайТекстФайл(ткст имяф, ткст[] строки, ОпцСоздания опц = ОпцСоздания.Создать)
{
    static ткст буф = ткст.init;
    static бул есть_ли_ф;

    есть_ли_ф = (stdrus.естьФайл( имяф) ? true : false);
    if (опц == ОпцСоздания.Заменить && !есть_ли_ф)
        throw new ФайлДопИскл( stdrus.фм("Файл '%s' не существует.", имяф));

    if (опц == ОпцСоздания.Новый && есть_ли_ф)
        throw new ФайлДопИскл( stdrus.фм("Файл '%s' уже есть.", имяф));

    if (stdrus.естьФайл(имяф))
        stdrus.удалиФайл(имяф);

    foreach(ткст текст; строки)
    {
        // Strip off any trailing line-end chars.
        for(цел i = текст.length-1; i >= 0; i--)
        {
            if (stdrus.найди(РАЗДСТР, текст[i]) == -1)
            {
                if (i != текст.length-1)
                    текст.length = i+1;
                break;
            }
        }

        // Доб the opsys' line-end convention.
        буф ~= текст ~ РАЗДСТР;
    }
    stdrus.пишиФайл(имяф, буф);
}

проц создайТекстФайл(ткст имяф, ткст строки, ОпцСоздания опц = ОпцСоздания.Создать)
{
    // Split into строки, disregarding line-end conventions.
    auto встроки = stdrus.разбейнастр(строки);
    // Зап out the text using the opsys' line-end convention.
    создайТекстФайл(имяф, встроки, опц);
}

дол grep(ткст данные, ткст образец)
{
    return stdrus.найди(данные, образец, vGrepOpts[$-1]);
}

бдол[] найдиВФайле(ткст имяф, ткст текст, ткст опции = "", бцел макс=1)
{
    бул регЧувствительно;
    бул lRegExp;
    бул lWordOnly;
    бул lCounting;
    ткст буф;
    цел поз;
    цел стартПоз;
    бдол[] lResult;
    цел function(ткст a, ткст b) lFind;
    ткст lGrepOpt;


    регЧувствительно = true;
    lRegExp = false;
    lGrepOpt = "m";
    lWordOnly = false;
    lCounting = true;
    foreach (сим c; опции)
    {
        switch (c)
        {
        case 'i', 'I':
            регЧувствительно = false;
            break;

        case 'r', 'R':
            lRegExp = true;
            break;

        case 'w', 'W':
            lWordOnly = true;
            break;

        case 'a', 'A':
            lCounting = false;
            break;

        case 'd', 'D':
            регЧувствительно = true;
            lRegExp = false;
            lWordOnly = false;
            lCounting = true;
            break;

        default:
            // Ignore unrecognized опции.
            break;
        }
    }

    if (lRegExp)
    {
        lFind = cast(цел function(ткст a, ткст b)) &grep;
        if (регЧувствительно)
            lGrepOpt ~= 'i';

        vGrepOpts ~= lGrepOpt;
        lWordOnly = false;
    }
    else
    {
        if (регЧувствительно)
            lFind = cast(цел function(ткст a, ткст b)) &stdrus.найди;
        else
            lFind = cast(цел function(ткст a, ткст b)) &stdrus.найдлюб;
    }

    // Pull the entire text into RAM.
    буф = cast(ткст)stdrus.читайФайл(имяф);

    // Locate next instance и process it.
    while ( стартПоз = поз, (поз = lFind(буф[стартПоз..$], текст)) != -1)
    {
        поз += стартПоз;
        if (lWordOnly)
        {
            // A 'word' is an instance not surrounded by alphanumerics.
            if (поз > 0)
            {
                if (stdrus.числобукв_ли(буф[поз-1]) )
                {
                    // Instance preceeded by a alphanumic so I
                    // move one place to the право и try to find
                    // another instance.
                    поз++;
                    continue;
                }
            }
            if (поз + текст.length < буф.length)
            {
                if (stdrus.числобукв_ли(буф[поз + текст.length - 1]) )
                {
                    // Instance followed by a alphanumic so I
                    // move one place to the право и try to find
                    // another instance.
                    поз++;
                    continue;
                }
            }
        }

        // Add this instance's позиция to the results list.
        lResult ~= поз;

        // If I'm counting the number of hits, see if I've got the
        // requested number yet. If so, stop searching.
        if (lCounting)
        {
            макс--;
            if (макс == 0)
                break;
        }

        // Skip over текущ instance.
        поз += текст.length;

        // If there is not enough characters лево, then stop searching.
        if ((буф.length - поз) < текст.length)
            break;

    }
    if (vGrepOpts.length > 0)
        vGrepOpts.length = vGrepOpts.length - 1;

    return lResult;
}

//-------------------------------------------------------
цел ВыполниКоманду(ткст pExeName, ткст команда)
//-------------------------------------------------------
{

    if (расширениеЭкзэ.length > 0)
    {
        if (stdrus.дайРасш(pExeName).length == 0)
            pExeName ~= "." ~ расширениеЭкзэ;
    }

    if (относительныйПуть_ли(pExeName) == да)
    {
        ткст lExePath;
        lExePath = найдиФайлВСпискеПутей(идПути, pExeName);
        if (.оканчивается_на(lExePath, РАЗДПАП) == нет)
            lExePath ~= РАЗДПАП;

        pExeName = каноническийПуть(lExePath ~ pExeName, да);
    }

    if (stdrus.естьФайлВКэш(pExeName) == false)
    {
        throw new ФайлИскл(stdrus.фм("Не удалось найти приложение '%s' для последующего запуска", pExeName));
    }
    return ВыполниКоманду(pExeName ~ " " ~ команда);
}

//-------------------------------------------------------
цел ВыполниКоманду(ткст команда)
//-------------------------------------------------------
{
    цел lRC;
    цел lTrueRC;

    if (тестЗапуск == да)
    {
        скажифнс("Команда: '%s'",команда);
        return 0;
    }
    else
    {


        version(BuildVerbose)
        {
            if(подробно == да)
                скажинс(stdrus.фм("Выполняется '%s'",команда));
        }

        lRC = cidrus.system(stdrus.вТкст0(команда));
        version(Posix) lTrueRC = ((lRC & 0xFF00) >> 8);
        version(Windows) lTrueRC = lRC;

        version(BuildVerbose)
        {
            if(подробно == да)
            {
                if (lTrueRC == 0)
                {
                    скажинс("Успешно");
                }
                else
                {
                    скажинс(stdrus.фм("Неудачно. Возвратный код: %04x",lRC));
                }
            }
        }
        return lTrueRC;
    }
}
///////конец module util.fileex

//module util.pathex
//////////////////////

export extern(D):

// ----------------------------------------------
ткст дайТекПап()
// ----------------------------------------------
{
    ткст текпап;

    текпап = stdrus.дайтекпап();
    // Ensure that it оканчивается_на in a путь separator.
    if (.оканчивается_на(текпап, РАЗДПАП) == нет)
        текпап ~= РАЗДПАП;

    return текпап;
}

// ----------------------------------------------
ткст дайТекПап(сим драйв)
// ----------------------------------------------
{
    ткст исхПап;
    ткст текпап;
    ткст м_драйв;

    исхПап = stdrus.дайтекпап();
    м_драйв.length = 2;
    м_драйв[0] = драйв;
    м_драйв[1] = ':';
    stdrus.сменипап(м_драйв);
    текпап = stdrus.дайтекпап();
    stdrus.сменипап(исхПап[0..2]);

    // Ensure that it оканчивается_на in a путь separator.
    if (.оканчивается_на(текпап, РАЗДПАП) == нет)
        текпап ~= РАЗДПАП;

    return текпап;
}

// ----------------------------------------------
ткст устДайТекИницПап(ткст путь = ткст.init)
// ----------------------------------------------
{
   if(путь != ткст.init) {
   иницТекПап = путь;
   return иницТекПап;
   }
	else {
	путь = дайТекПап();
	иницТекПап = путь;
	return иницТекПап;
	}
    
}

// ----------------------------------------------
бул относительныйПуть_ли(ткст путь)
// ----------------------------------------------
{
    version(Windows)
    {
        // Strip off an drive prefix первый.
        if (путь.length > 1 && путь[1] == ':')
            путь = путь[2..$];
    }

    return начинается_с(путь, РАЗДПАП);
}

// ----------------------------------------------
бул абсолютныйПуть_ли(ткст путь)
// ----------------------------------------------
{
    version(Windows)
    {
        // Strip off an drive prefix первый.
        if (путь.length > 1 && путь[1] == ':')
            путь = путь[2..$];
    }

    return .начинается_с(путь, РАЗДПАП);
}

// ----------------------------------------------
ткст каноническийПуть(ткст путь, бул pDirInput = да)
// ----------------------------------------------
{
    // Does not (yet) handle UNC paths or unix links.
    ткст lPath;
    цел lPosA = -1;
    цел lPosB = -1;
    цел lPosC = -1;
    ткст lLevel;
    ткст текпап;
    ткст драйв;

    lPath = путь.dup;

    // Strip off any enclosing quotes.
    if (lPath.length > 2 && lPath[0] == '"' && lPath[$-1] == '"')
    {
        lPath = lPath[1..$-1];
    }

    // Replace any leading tilde with 'HOME' directory.
    if (lPath.length > 0 && lPath[0] == '~')
    {
        version(Windows) lPath = .дайСред("HOMEDRIVE") ~  .дайСред("HOMEPATH") ~ РАЗДПАП ~ lPath[1..$];
        version(Posix) lPath = .дайСред("HOME") ~ РАЗДПАП ~ lPath[1..$];
    }

    version(Windows)
    {
        if ( (lPath.length > 1) && (lPath[1] == ':' ) )
        {
            драйв = lPath[0..2].dup;
            lPath = lPath[2..$];
        }

        if ( (lPath.length == 0) || (lPath[0] != РАЗДПАП[0]) )
        {
            if (драйв.length == 0)
                lPath = дайТекПап ~ lPath;
            else
                lPath = дайТекПап(драйв[0]) ~ lPath;

            if ( (lPath.length > 1) && (lPath[1] == ':' ) )
            {
                if (драйв.length == 0)
                    драйв = lPath[0..2].dup;
                lPath = lPath[2..$];
            }
        }

    }
    version(Posix)
    {
        if ( (lPath.length == 0) || (lPath[0] != РАЗДПАП[0]) )
        {
            lPath = дайТекПап() ~ lPath;
        }
    }

    if (pDirInput && (lPath[$-РАЗДПАП.length .. $] != РАЗДПАП) )
    {
        lPath ~= РАЗДПАП;
    }

    lLevel = РАЗДПАП ~ "." ~ РАЗДПАП;
    lPosA = stdrus.найди(lPath, lLevel);
    while( lPosA != -1 )
    {
        lPath = lPath[0..lPosA] ~
                lPath[lPosA + lLevel.length - РАЗДПАП.length .. length];

        lPosA = stdrus.найди(lPath, lLevel);
    }

    lLevel = РАЗДПАП ~ ".." ~ РАЗДПАП;
    lPosA = stdrus.найди(lPath, lLevel);
    while( lPosA != -1 )
    {
        // Locate preceding directory separator.
        lPosB = lPosA-1;
        while((lPosB > 0) && (lPath[lPosB] != РАЗДПАП[0]))
            lPosB--;
        if (lPosB < 0)
            lPosB = 0;

        lPath = lPath[0..lPosB] ~
                lPath[lPosA + lLevel.length - РАЗДПАП.length .. length];

        lPosA = stdrus.найди(lPath, lLevel);
    }

    return драйв ~ lPath;
}

// ----------------------------------------------
ткст замениРасш(ткст фимя, ткст новРасш)
// ----------------------------------------------
{
    ткст новфимя;

    новфимя = stdrus.добРасш(фимя, новРасш);

    /* Needs this to work around the 'feature' in addExt in which
       replacing an extention with an empty string leaves a dot
       после the файл имя.
    */
    if (новРасш.length == 0)
    {
        if (новфимя.length > 0)
        {
            if (новфимя[length-1] == '.')
            {
                новфимя.length = новфимя.length - 1;
            }
        }
    }

    return новфимя;
}

// ----------------------------------------------
бул сделайПуть(ткст новПуть)
// ----------------------------------------------
{
    /*
        This creates the путь, including all intervening
        родитель directories, specified by the parameter.

        Note that the путь is only that portion of the
        parameter up to the последний directory separator. This
        means that you can provide a файл имя in the parameter
        и it will still create the путь for that файл.

        This returns нет if the путь was not created. That
        could occur if the путь already exists or if you do not
        permissions to create the путь on the device, либо if
        device is read-only or doesn't exist.

        This returns true if the путь was created.
    */
    бул рез;  // false means it did not create a new путь.
    ткст lNewPath;
    ткст lParentPath;

    // выкинь out the directory part of the parameter.
    for (цел i = новПуть.length-1; i >= 0; i--)
    {
        if (новПуть[i] == РАЗДПАП[0])
        {
            lNewPath = новПуть[0 .. i].dup;
            break;
        }
    }
    version(Windows)
    {
        if ((lNewPath.length > 0) && (lNewPath[length-1] == ':'))
            lNewPath.length = 0;
    }

    if (lNewPath.length == 0)
        return false;
    else
    {
        // выкинь out the родитель directory
        for (цел i = lNewPath.length-1; i >= 0; i--)
        {
            if (lNewPath[i] == РАЗДПАП[0])
            {
                lParentPath = lNewPath[0 .. i].dup;
                break;
            }
        }

        // make sure the родитель exists.
        version(Windows)
        {
            if ((lParentPath.length > 0) && (lParentPath[length-1] == ':'))
                lParentPath.length = 0;
        }
        if (lParentPath.length != 0)
        {
            сделайПуть(lParentPath ~ РАЗДПАП);
        }


        // create this directory
        try
        {
            stdrus.сделайпап(lNewPath);
            рез = true;
        }
        catch (ФайлИскл Е)
        {
            // Assume the exception is that the directory already exists.
            рез = false;
        }
        return рез;
    }
}

ткст сократиФИмя(ткст имя, ткст[] списПрефиксов = пусто)
{
    // If the файл путь supplied can be expressed relative to
    // the текущ directory, (without resorting to '..'), it
    // is returned in its shortened form.

    ткст[] м_списПрефиксов;
    ткст кратИмя;
    ткст времФ;
    ткст исхИмя;
    ткст полнИмя;

    м_списПрефиксов ~= устДайТекИницПап();
    if (списПрефиксов.length != 0)
    {
        м_списПрефиксов.length = м_списПрефиксов.length + списПрефиксов.length;
        м_списПрефиксов[1..$] = списПрефиксов[];
    }
    полнИмя = каноническийПуть(имя, false);
LBL_CheckDirs:
    foreach (ткст текпап; м_списПрефиксов)
    {
        исхИмя = полнИмя.dup;
        if (исхИмя.length > текпап.length)
        {
            version(Windows)
            {
                if( stdrus.впроп(исхИмя[0.. текпап.length]) ==
                        stdrus.впроп(текпап) )
                {
                    кратИмя = исхИмя[текпап.length .. $];
                    break LBL_CheckDirs;
                }

            }
            else
            {
                if (исхИмя[0.. текпап.length] == текпап )
                {
                    кратИмя = исхИмя[текпап.length .. $];
                    break LBL_CheckDirs;
                }
            }
        }
    }

    if (кратИмя.length == 0)
        кратИмя = имя.dup;

    version(Windows)
    // Remove any double путь seps.
    {
        {
            бцел lPos;
            while ( (lPos = stdrus.найди(кратИмя, `\\`)) != -1)
            {
                кратИмя = кратИмя[0..lPos] ~ кратИмя[lPos+1 .. $];
            }
        }
    }
    return кратИмя;
}

ткст определиФайл(ткст фимя, ткст списПутей)
{
    return определиФайл(фимя,
                                    stdrus.разбей(списПутей, РАЗДПСТР));
}

ткст определиФайл(ткст фимя, ткст[] списПутей)
{
    ткст полнИмя;

    foreach(ткст lPath; списПутей)
    {
        if (lPath.length == 0)
            lPath = stdrus.дайтекпап().dup;

        if (lPath[$-РАЗДПАП.length .. $] != РАЗДПАП)
            lPath ~= РАЗДПАП;

        полнИмя = lPath ~ фимя;
        if (stdrus.естьФайлВКэш(полнИмя) )
            return полнИмя;
    }

    return фимя;
}

/**
    Return everything up to but not including the final '.'
*/
ткст дайОсновуИмени(ткст фимяПути)
{
    ткст базИмя;

    базИмя = фимяПути; //.dup;
    for(цел i = базИмя.length-1; i >= 0; i--)
    {
        if (базИмя[i] == '.')
        {
            базИмя.length = i;
            break;
        }
    }
    return базИмя;
}

/**
    Return everything from the beginning of the файл имя
    up to but not including the final '.'
*/
ткст дайОсновуИмениФайла(ткст фимяПути)
{
    ткст базИмя;

    базИмя = фимяПути; //.dup;
    for(цел i = базИмя.length-1; i >= 0; i--)
    {
        if (базИмя[i] == '.')
        {
            базИмя.length = i;
            break;
        }
    }

    for(цел i = базИмя.length-1; i >= 0; i--)
    {
        version(Windows)
        {
            if (базИмя[i] == '\\')
            {
                базИмя = базИмя[i+1 .. $];
                break;
            }
            if (базИмя[i] == ':')
            {
                базИмя = базИмя[i+1 .. $];
                break;
            }
        }
        version(Posix)
        {
            if (базИмя[i] == '/')
            {
                базИмя = базИмя[i+1 .. $];
                break;
            }
        }
    }
    return базИмя;
}

// Function to locate where an файл is installed from the supplied
// environment symbol, which is a list of paths.
// This returns the путь to the файл if the файл exists otherwise пусто.
// -------------------------------------------
ткст найдиФайлВСпискеПутей(ткст pSymName, ткст фимя)
// -------------------------------------------
{
    ткст[] пути;
    ткст   путьККомпилятору;
    ткст   необработЗнач;

    // Assume that an environment symbol имя was supplied,
    // but if that fails, assume its a list of paths.
    необработЗнач = .дайСред(pSymName);
    if (необработЗнач.length == 0)
        необработЗнач = pSymName;

    // Rearrange путь list into an массив of paths.
    пути = stdrus.разбей(.вАски(необработЗнач), РАЗДПСТР);

    путьККомпилятору.length = 0;
    foreach(ткст lPath; пути)
    {
        if (lPath.length > 0)
        {
            // Ensure that the путь оканчивается_на with a действителен separator.
            if (lPath[length-1] != РАЗДПАП[0] )
                lPath ~= РАЗДПАП;
            // If the файл is in the текущ путь we can stop looking.
            if(stdrus.естьФайлВКэш(lPath ~ фимя))
            {
                // Return the путь we actually found it in.
                путьККомпилятору = lPath;
                break;
            }
        }
    }

    return путьККомпилятору;
}