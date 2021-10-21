﻿module stdrusex;

private
{
	import stdrus;					
}

alias дайСред дайГлоб;
alias устСред устГлоб;
alias разверниПеремСреды раскройГлоб;
alias создайТекстФайл запиши_в;
alias дайТекст читай_из;
alias дайТекстПострочно читайвсестр_из;

extern(D) struct Серии
{
     бдол тек(бдол зн);
	 бдол тек();
	 бдол прирост(бдол зн);
	 бдол прирост();
     бдол следщ();
     бдол предш();   
}

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


version(DCHAR) extern(D) юткст[] разбериСтроку(юткст исток,
                                        юткст разгр = ",",
                                        юткст коммент = "//",
                                        юткст искейп = "\\");
else version(0) extern(D) ткст[] разбериСтроку(ткст исток,
                                      ткст разгр = ",",
                                      ткст коммент = "//",
                                      ткст искейп = "\\");
extern(D) class ФайлДатаВремя
        {
            this();
            this(ткст имяФ);
            version(WCHAR) this(шткст имяФ);
            version(DCHAR) this(юткст имяФ);
            цел opEquals(ФайлДатаВремя другой);
            цел opCmp(ФайлДатаВремя другой);
            цел сравни(ФайлДатаВремя другой, бул точно = false);
            ткст вТкст(бул точно = нет);
}

	extern(D) ббайт[] замениСим(in ббайт[] текст, ббайт откуда, ббайт куда);
	extern(D) ббайт[] замениСим(in ббайт[] текст, сим откуда, сим куда);	
	
	version(DCHAR) extern(D) юткст замениСим(in юткст текст, дим откуда, дим куда);	
	version(WCHAR) extern(D) шткст замениСим(in шткст текст, дим откуда, дим куда);
	else version(0) extern(D) ткст замениСим(in ткст текст, дим откуда, дим куда);
		
	extern(D) ббайт[] вТкстН(ббайт[] данные);
	extern(D) ткст вТкстН(ткст данные);
	
	version(WCHAR) extern(D)  ббайт[] вТкстА(шткст данные);
	version(DCHAR) extern(D)  ббайт[] вТкстА(юткст данные);
	else version(0) extern(D)  ббайт[] вТкстА(ткст данные);

	version(DCHAR) extern(D) бул подобен_ли(юткст текст, юткст образец);
	else version(0)extern(D)  бул подобен_ли(ткст текст, ткст образец );

	
	version(WCHAR) extern(D) бул начинается_с(шткст строка, шткст подстрока);
	version(DCHAR) extern(D) бул начинается_с(юткст строка, юткст подстрока);
	else version(0) extern(D) бул начинается_с(ткст строка, ткст подстрока);	 
	
	version(WCHAR) extern(D) бул оканчивается_на(шткст строка, шткст подстрока);
	version(DCHAR) extern(D) бул оканчивается_на(юткст строка, юткст подстрока);
	else version(0) extern(D) бул оканчивается_на(ткст строка, ткст подстрока);	 
	
	version(WCHAR) extern(D) шткст в_кавычках(шткст строка, шим триггер = ' ', шткст префикс = `"`, шткст суффикс = `"`);
	version(DCHAR) extern(D) юткст в_кавычках(юткст строка, дим триггер = ' ', юткст префикс = `"`, юткст суффикс = `"`);
	else version(0) extern(D) ткст в_кавычках(ткст строка, сим триггер = ' ', ткст префикс = `"`, ткст суффикс = `"`);
	 
	extern(D) юткст раскрой(юткст оригин, юткст списТок,
					юткст сравниЭлем = "{", юткст сзади = "}");
	extern(D) ткст вАски(ткст утф8);
	extern(D) бул ЮК_пбел_ли(дим симв);
	extern(D) ткст найдипбел(ткст текст);
	extern(D) юткст найдипбелрек(юткст текст);
	
	version(DCHAR) extern(D) юткст уберил(юткст s);
	else version(0) extern(D) ткст уберил(ткст s) ;
	
	version(DCHAR) extern(D) юткст уберип(юткст s);
	else version(0) extern(D) ткст уберип(ткст s);
	
	version(DCHAR) extern(D) юткст убери(юткст s);
	version(WCHAR) extern(D) шткст убери(шткст s);
	else version(0) extern(D) ткст убери(ткст s);


template Шнайди(T)
{
    цел найди(T[] текст, T[] подтекст, цел откуда = 0)
    {
        цел текстИнд;
        цел подтекстИнд;
        цел поз;
        цел конТекста;

        if (откуда < 0)
            откуда = 0;

        // locate первый сверь.
        подтекстИнд = 0;
        текстИнд = откуда;
        // No point in looking past this позиция.
        конТекста = текст.length - подтекст.length + 1;
        while(подтекстИнд < подтекст.length)
        {
            while(текстИнд < конТекста && подтекст[подтекстИнд] != текст[текстИнд])
            {
                текстИнд++;
            }
            if (текстИнд >= текст.length)
                return -1;

            поз = текстИнд;  // Mark possible start of substring сверь.

            текстИнд++;
            подтекстИнд++;
            // Locate all совпадает
            while(текстИнд < текст.length && подтекстИнд < подтекст.length &&
                        подтекст[подтекстИнд] == текст[текстИнд])
            {
                текстИнд++;
                подтекстИнд++;
            }
            if (подтекстИнд == подтекст.length)
                return поз;
            подтекстИнд = 0;
            текстИнд = поз + 1;
        }
        return -1;
    }
}
alias Шнайди!(дим).найди найди;
alias Шнайди!(шим).найди найди;



extern(D){
ткст транслируйЭск(ткст текст);
ткст разверниПеремСреды(ткст строка);
ткст дайСред(ткст символ);
проц устСред(ткст символ, ткст знач, бул переписать = да);
}

template Шдн(T)
{

//-------------------------------------------------------
бул ДаНет(T[] текст, бул дефолт)
//-------------------------------------------------------
{
    бул рез = дефолт;
	ткст м_ткст = вЮ8(текст);
    foreach(цел i, сим c; м_ткст)
    {
        if (c == '=' || c == ':')
        {
            м_ткст = уберил(м_ткст[i+1 .. $]);
            break;
        }
    }
    if (м_ткст.length > 0)
    {
        if (м_ткст[0] == 'Y' || м_ткст[0] == 'y')
            рез = true;
        else if (м_ткст[0] == 'N' || м_ткст[0] == 'n')
            рез = false;
    }

    return рез;
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
    рез = (ДаНет(текст, (дефолт == да ? true:false)) ? да : нет);
}
}
alias Шдн!(дим).ДаНет ДаНет;
alias Шдн!(сим).ДаНет ДаНет;

/////////////////////конец module 

//module util.fileex
/////////////////////
/+
    alias Искл Ошибка;

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
+/
enum ОпцПолучения
{
    Есть = 'e',   // Must exist otherwise Get fails.
    Всегда = 'a'    // Get always returns something, even if it's just
                   //   empty строки for a missing файл.
};

enum ОпцСоздания
{
    Новый = 'n',      // Must create a new файл, thus it cannot already exist.
    Создать = 'c',   // Can either create or replace; it doesn't matter.
    Заменить = 'r'   // Must replace an existing файл.
};

extern(D):

// Зачитать весь файл в текстовое представление.
ткст дайТекст(ткст имяф, ОпцПолучения опц = ОпцПолучения.Всегда);

//Считать весь файл в набор строк (strings).
ткст[] дайТекстПострочно(ткст имяф, ОпцПолучения опц = ОпцПолучения.Всегда);

проц создайТекстФайл(ткст имяф, ткст[] строки, ОпцСоздания опц = ОпцСоздания.Создать);
проц создайТекстФайл(ткст имяф, ткст строки, ОпцСоздания опц = ОпцСоздания.Создать);
дол grep(ткст данные, ткст образец);
бдол[] найдиВФайле(ткст имяф, ткст текст, ткст опции = "", бцел макс=1);
цел ВыполниКоманду(ткст pExeName, ткст команда);
цел ВыполниКоманду(ткст команда);
ткст дайТекПап();
ткст дайТекПап(сим драйв);
ткст устДайТекИницПап(ткст путь = ткст.init);//Используется в ExeMain
бул абсолютныйПуть_ли(ткст путь);
ткст каноническийПуть(ткст путь, бул pDirInput = да);
ткст замениРасш(ткст фимя, ткст новРасш);
бул сделайПуть(ткст новПуть);
ткст сократиФИмя(ткст имя, ткст[] списПрефиксов = пусто);
ткст определиФайл(ткст фимя, ткст списПутей);
ткст определиФайл(ткст фимя, ткст[] списПутей);

/**
    Return everything up to but not including the final '.'
*/
ткст дайОсновуИмени(ткст фимяПути);

/**
    Return everything from the beginning of the файл имя
    up to but not including the final '.'
*/
ткст дайОсновуИмениФайла(ткст фимяПути);

// Function to locate where an файл is installed from the supplied
// environment symbol, which is a list of paths.
// This returns the путь to the файл if the файл exists otherwise пусто.
// -------------------------------------------
ткст найдиФайлВСпискеПутей(ткст pSymName, ткст фимя);