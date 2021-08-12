﻿module io.vfs.model;

private import time.Time : Время;
private import io.model;

alias ИнфОФайле ИнфОФильтреВфс;
alias ИнфОФильтреВфс* ИнфОВфс;

// return нет в_ exclude something
alias бул delegate(ИнфОВфс) ФильтрВфс;

struct СтатсВфс
{
        бдол   байты;                  // байт счёт of файлы
        бцел    файлы,                  // число of файлы
                папки;                // число of папки
}

interface ХостВфс : ПапкаВфс
{

        ХостВфс прикрепи (ПапкаВфс папка, ткст имя=пусто);
        ХостВфс прикрепи (ПапкиВфс группа);
        ХостВфс открепи (ПапкаВфс папка);
        ХостВфс карта (ФайлВфс мишень, ткст имя);
        ХостВфс карта (ЗаписьПапкиВфс мишень, ткст имя);
}

interface ПапкаВфс
{

        ткст имя ();
        ткст вТкст ();
        ФайлВфс файл (ткст путь);
        ЗаписьПапкиВфс папка (ткст путь);
        ПапкиВфс сам ();
        ПапкиВфс дерево ();
        цел opApply (цел delegate(ref ПапкаВфс) дг);
        ПапкаВфс очисть ();
        бул записываемый ();
        ПапкаВфс закрой (бул подай = да);
        проц проверь (ПапкаВфс папка, бул mounting);

}

interface ПапкиВфс
{

        цел opApply (цел delegate(ref ПапкаВфс) дг);
        бцел файлы ();
        бцел папки ();
        бцел записи ();
        бдол байты ();
        ПапкиВфс поднабор (ткст образец);
        ФайлыВфс каталог (ткст образец);
        ФайлыВфс каталог (ФильтрВфс фильтр = пусто);
}

interface ФайлыВфс
{

        цел opApply (цел delegate(ref ФайлВфс) дг);
        бцел файлы ();
        бдол байты ();
}

interface ФайлВфс 
{

        ткст имя ();
        ткст вТкст ();
        бул есть_ли ();
        бдол размер ();
        ФайлВфс копируй (ФайлВфс источник);
        ФайлВфс перемести (ФайлВфс источник);
        ФайлВфс создай ();
        ФайлВфс создай (ИПотокВвода поток);
        ФайлВфс удали ();
        ИПотокВвода ввод ();
        ИПотокВывода вывод ();
        ФайлВфс dup ();
        Время изменён ();
}

interface ЗаписьПапкиВфс 
{

        ПапкаВфс открой ();
        ПапкаВфс создай ();
        бул есть_ли ();
}


interface СинхВфс
{

        ПапкаВфс синх ();
}

