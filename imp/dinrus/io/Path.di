﻿module io.Path;

private import  sys.Common;
public  import  time.Time : Время, ИнтервалВремени;
private import  io.model : ФайлКонст, ИнфОФайле;
public  import  exception : ВВИскл, ИсклНелегальногоАргумента;


package struct ФС
{
        struct Штампы
        {
                Время    создан,        /// время создан
                        использовался,       /// последний время использовался
                        изменён;       /// последний время изменён
        }

        struct Листинг
        {
                ткст папка;
                бул   всеФайлы;
                
                цел opApply (цел delegate(ref ИнфОФайле) дг);
        }

        static проц исключение (ткст имяф);
        static проц исключение (ткст префикс, ткст ошибка);
        static ткст псеп_в_конце (ткст путь, сим c = '/');
        static ткст очищенный (ткст путь, сим c = '/');
        static ткст объедини (ткст[] пути...);
        static ткст ткт0 (ткст ист, ткст приёмн);
		
        version (Win32)
        {

                private static шим[] вТкст16 (шим[] врем, ткст путь);
                private static ткст вТкст (ткст врем, шим[] путь);
              //  private static бул инфОФайле (ткст имя, ref WIN32_FILE_ATTRIBUTE_DATA инфо);
              //  private static DWORD дайИнф (ткст имя, ref WIN32_FILE_ATTRIBUTE_DATA инфо);
                private static DWORD дайФлаги (ткст имя);
                static бул есть_ли (ткст имя);
                static бдол размерФайла (ткст имя);
                static бул записываем_ли (ткст имя);
                static бул папка_ли (ткст имя);
                static бул файл_ли (ткст имя);
                static Штампы штампыВремени (ткст имя);
                static проц штампыВремени (ткст имя, Время использовался, Время изменён);
                static проц копируй (ткст ист, ткст приёмн);
                static бул удали (ткст имя);
                static проц переименуй (ткст ист, ткст приёмн);
                static проц создайФайл (ткст имя);
                static проц создайПапку (ткст имя);
                static цел список (ткст папка, цел delegate(ref ИнфОФайле) дг, бул все=нет);
                private static проц создайФайл (ткст имя, проц delegate(HANDLE) дг);
        }
        version (Posix)
        {
                private static бцел дайИнф (ткст имя, ref stat_t статс);
                static бул есть_ли (ткст имя);
                static бдол размерФайла (ткст имя);
                static бул записываем_ли (ткст имя);
                static бул папка_ли (ткст имя);
                static бул файл_ли (ткст имя);
                static Штампы штампыВремени (ткст имя);
                static проц штампыВремени (ткст имя, Время использовался, Время изменён);
                static проц копируй (ткст источник, ткст приёмник);
                static бул удали (ткст имя);
                static проц переименуй (ткст ист, ткст приёмн);
                static проц создайФайл (ткст имя);
                static проц создайПапку (ткст имя);
                static цел список (ткст папка, цел delegate(ref ИнфОФайле) дг, бул все=нет);
        }
}

struct ПутеПарсер
{       
        package ткст  fp;                     // фпуть with trailing
        package цел     end_,                   // before any trailing 0
                        ext_,                   // after rightmost '.'
                        name_,                  // файл/Пап имя
                        folder_,                // путь before имя
                        suffix_;                // включая leftmost '.'

        ПутеПарсер разбор (ткст путь);
        ПутеПарсер dup ();
        ткст вТкст ();
        ткст корень ();
        ткст папка ();
        ткст предок ();
        ткст вынь ();
        ткст имя ();
        ткст расш ();
        ткст суффикс ();
        ткст путь ();
        ткст файл ();
        бул абс_ли ();
        бул пуст_ли ();
        бул ветвь_ли ();
        цел opEquals (ткст s);
        package ПутеПарсер разбор (ткст путь, т_мера конец);
}


бул есть_ли (ткст имя);
Время изменён (ткст имя);
Время использовался (ткст имя);
Время создан (ткст имя);
бдол размерФайла (ткст имя);
бул записываем_ли (ткст имя);
бул папка_ли (ткст имя);
бул файл_ли (ткст имя);
ФС.Штампы штампыВремени (ткст имя);
проц штампыВремени (ткст имя, Время использовался, Время изменён);
бул удали (ткст имя);
ткст[] удали (ткст[] пути);
проц создайФайл (ткст имя);
проц создайПапку (ткст имя);
проц создайПуть (ткст путь);
проц переименуй (ткст ист, ткст приёмн);
проц копируй (ткст ист, ткст приёмн);
ФС.Листинг ветви (ткст путь, бул все=нет);
ткст[] коллируй (ткст путь, ткст образец, бул рекурсия=нет);
ткст объедини (ткст[] пути...);
ткст стандарт (ткст путь);
ткст исконный (ткст путь);
ткст предок (ткст путь);
ткст вынь (ткст путь);
ткст разбей (ткст путь, out ткст голова, out ткст хвост);
ткст замени (ткст путь, сим из_, сим в_);
ПутеПарсер разбор (ткст путь);
бул совпадение (ткст имяф, ткст образец);
ткст нормализуй (ткст путь, ткст буф = пусто);