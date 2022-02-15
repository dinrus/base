﻿module io.vfs.FileFolder;

private import io.device.File;
private import Путь = io.Path;
private import exception;
public import io.vfs.model;
private import io.model;
private import time.Time : Время;

/*******************************************************************************

        Представляет физическую папку в файловой системе. Используется для
        адресации к определённым путям (поддеревьям) внутри файловой системы.

*******************************************************************************/

class ФайлПапка : ПапкаВфс
{
        private ткст          путь;
        private СтатсВфс        статс;

        /***********************************************************************

                Создаёт папку с файлами с заданным путём. 

                Опция 'создай' создаст путь, если она установлена в да, 
                или будет ссылаться на существующий путь иначе.

        ***********************************************************************/

        this (ткст путь, бул создай=нет)
        {
                this.путь = открой (Путь.стандарт(путь.dup), создай);
        }

        /***********************************************************************

                Создаёт ФайлПапка как член Группы.

        ***********************************************************************/

        private this (ткст путь, ткст имя)
        {
                this.путь = Путь.объедини (путь, имя);
        }

        /***********************************************************************

                Явно создаёт() или открывает() указанную папку.

        ***********************************************************************/

        private this (ФайлПапка родитель, ткст имя, бул создай=нет)
        {
                assert (родитель);
                this.путь = открой (Путь.объедини(родитель.путь, имя), создай);
        }

        /***********************************************************************

                Возвращает краткое имя.

        ***********************************************************************/

        final ткст имя ()
        {
                return Путь.разбор(путь).имя;
        }

        /***********************************************************************

                Возвращает длинное имя.

        ***********************************************************************/

        final ткст вТкст ()
        {
                return путь;
        }

        /***********************************************************************

                Папка, жобавляемая или удаляемая из иерархии. Используется 
                для проверки валидности (или иного) и вывода исключений 
                при необходимости.

                Здесь проводится текст на наличии накладки,
				 и, если таковая найдена, проблема решается.

        ***********************************************************************/

        final проц проверь (ПапкаВфс папка, бул mounting)
        {       
                if (mounting && cast(ФайлПапка) папка)
                   {
                   auto ист = Путь.ФС.псеп_в_конце (this.вТкст);
                   auto приёмн = Путь.ФС.псеп_в_конце (папка.вТкст);

                   auto длин = ист.length;
                   if (длин > приёмн.length)
                       длин = приёмн.length;

                   if (ист[0..длин] == приёмн[0..длин])
                       ошибка ("папки '"~приёмн~"' и '"~ист~"' накладываются");
                   }
        }

        /***********************************************************************

                Возвращает содержимое представление файла. 

        ***********************************************************************/

        final ФайлВфс файл (ткст имя)
        {
                return new ХостФайла (Путь.объедини (путь, имя));
        }

        /***********************************************************************

                Возвращает содержимое представление папки. 

        ***********************************************************************/

        final ЗаписьПапкиВфс папка (ткст путь)
        {
                return new ХостПапки (this, путь);
        }

        /***********************************************************************

                Удаляет поддерево папки. Используйте осторожно!

        ***********************************************************************/

        final ПапкаВфс очисть ()
        {
                Путь.удали (Путь.коллируй(путь, "*", да));
                return this;
        }

        /***********************************************************************

                Записываема ли эта папка?

        ***********************************************************************/

        final бул записываемый ()
        {
                return Путь.записываем_ли (путь);
        }

        /***********************************************************************

                Возвращает информацию о содержимом этой папки.

        ***********************************************************************/

        final ПапкиВфс сам ()
        {
                return new ГруппаПапок (this, нет);
        }

        /***********************************************************************

                Возвращает поддерево папок, совпадающее с заданным именем.

        ***********************************************************************/

        final ПапкиВфс дерево ()
        {
                return new ГруппаПапок (this, да);
        }

        /***********************************************************************

                Итерирует по набору непосредственной ветви папки. Это
                используется для отражения иерархии.

        ***********************************************************************/

        final цел opApply (цел delegate(ref ПапкаВфс) дг)
        {
                цел результат;

                foreach (папка; папки(да))  
                        {
                        ПапкаВфс x = папка;  
                        if ((результат = дг(x)) != 0)
                             break;
                        }
                return результат;
        }

        /***********************************************************************

                Закрыть и/или синхронизовать изменения сделанные над этой папкой.
                Каждый драйвер должен этим воспользоваться соответствующе, возможно,
                комбинируя несколько файлов вместе, либо копируя в удалённое 
                местоположение.

        ***********************************************************************/

        ПапкаВфс закрой (бул подай = да)
        {
                return this;
        }

        /***********************************************************************
        
                Подмести папки во владении.

        ***********************************************************************/

        private ФайлПапка[] папки (бул собери)
        {
                ФайлПапка[] папки;

                статс = статс.init;
                foreach (инфо; Путь.ветви (путь))
                         if (инфо.папка)
                            {
                            if (собери)
                                папки ~= new ФайлПапка (инфо.путь, инфо.имя);
                            ++статс.папки;
                            }
                         else
                            {
                            статс.байты += инфо.байты; 
                           ++статс.файлы;
                            }

                return папки;         
        }

        /***********************************************************************

                Подмести файлы во владении.
				
        ***********************************************************************/

        private ткст[] файлы (ref СтатсВфс статс, ФильтрВфс фильтр = пусто)
        {
                ткст[] файлы;

                foreach (инфо; Путь.ветви (путь))
                         if (инфо.папка is нет)
                             if (фильтр is пусто || фильтр(&инфо))
                                {
                                файлы ~= Путь.объедини (инфо.путь, инфо.имя);
                                статс.байты += инфо.байты; 
                                ++статс.файлы;
                                }

                return файлы;         
        }

        /***********************************************************************

                Вывести исключение.

        ***********************************************************************/

        private ткст ошибка (ткст сооб)
        {
                throw new ВфсИскл (сооб);
        }

        /***********************************************************************

                Создать или открыть указанный путь, и обнаружить ошибки пути.

        ***********************************************************************/

        private ткст открой (ткст путь, бул создай)
        {
                if (Путь.есть_ли (путь))
                   {
                   if (! Путь.папка_ли (путь))
                       ошибка ("ФайлПапка.открой :: путь существует, но не в папке: "~путь);
                   }
                else
                   if (создай)
                       Путь.создайПуть (путь);
                   else
                      ошибка ("ФайлПапка.открой :: путь не существует: "~путь);
                return путь;
        }
}


/*******************************************************************************

        Представляет группу файлов (need this declared here в_ avoопр
        a bunch of bizarre compiler warnings)

*******************************************************************************/

class ГруппаФайлов : ФайлыВфс
{
        private ткст[]        группа;          // набор отфильтрованных имён файлов
        private ткст[]        хосты;          // набор содержащихся папок
        private СтатсВфс        статс;          // статистика содежимых файлов

        /***********************************************************************

        ***********************************************************************/

        this (ГруппаПапок хост, ФильтрВфс фильтр)
        {
                foreach (папка; хост.члены)
                        {
                        auto файлы = папка.файлы (статс, фильтр);
                        if (файлы.length)
                           {
                           группа ~= файлы;
                           //хосты ~= папка.вТкст;
                           }
                        }
        }

        /***********************************************************************

                Iterate over the набор of contained ФайлВфс экземпляры

        ***********************************************************************/

        final цел opApply (цел delegate(ref ФайлВфс) дг)
        {
                цел  результат;
                auto хост = new ХостФайла;

                foreach (файл; группа)    
                        {    
                        ФайлВфс x = хост;
                        хост.путь.разбор (файл);
                        if ((результат = дг(x)) != 0)
                             break;
                        } 
                return результат;
        }

        /***********************************************************************

                Возвращает total число of записи 

        ***********************************************************************/

        final бцел файлы ()
        {
                return группа.length;
        }

        /***********************************************************************

                Возвращает total размер of все файлы 

        ***********************************************************************/

        final бдол байты ()
        {
                return статс.байты;
        }
}


/*******************************************************************************

        A набор of папки representing a выделение. This is where файл 
        выделение is made, и образец-matched папка subsets can be
        выкиньed. You need one of these в_ expose statistics (such as
        файл or папка счёт) of a selected папка группа 

*******************************************************************************/

private class ГруппаПапок : ПапкиВфс
{
        private ФайлПапка[] члены;           // папки in группа

        /***********************************************************************

                Создаёт поднабор группа

        ***********************************************************************/

        private this () {}

        /***********************************************************************

                Создаёт папка группа включая the предоставленный папка и
                (optionally) все ветвь папки

        ***********************************************************************/

        private this (ФайлПапка корень, бул рекурсия)
        {
                члены = корень ~ скан (корень, рекурсия);   
        }

        /***********************************************************************

                Iterate over the набор of contained ПапкаВфс экземпляры

        ***********************************************************************/

        final цел opApply (цел delegate(ref ПапкаВфс) дг)
        {
                цел  результат;

                foreach (папка; члены)  
                        {
                        ПапкаВфс x = папка;  
                        if ((результат = дг(x)) != 0)
                             break;
                        }
                return результат;
        }

        /***********************************************************************

                Возвращает число of файлы in this группа

        ***********************************************************************/

        final бцел файлы ()
        {
                бцел файлы;
                foreach (папка; члены)
                         файлы += папка.статс.файлы;
                return файлы;
        }

        /***********************************************************************

                Возвращает total размер of все файлы in this группа

        ***********************************************************************/

        final бдол байты ()
        {
                бдол байты;

                foreach (папка; члены)
                         байты += папка.статс.байты;
                return байты;
        }

        /***********************************************************************

                Возвращает число of папки in this группа

        ***********************************************************************/

        final бцел папки ()
        {
                if (члены.length is 1)
                    return члены[0].статс.папки;
                return члены.length;
        }

        /***********************************************************************

                Возвращает total число of записи in this группа

        ***********************************************************************/

        final бцел записи ()
        {
                return файлы + папки;
        }

        /***********************************************************************

                Возвращает поднабор of папки совпадают the given образец

        ***********************************************************************/

        final ПапкиВфс поднабор (ткст образец)
        {  
                Путь.ПутеПарсер парсер;
                auto набор = new ГруппаПапок;

                foreach (папка; члены)    
                         if (Путь.совпадение (парсер.разбор(папка.путь).имя, образец))
                             набор.члены ~= папка; 
                return набор;
        }

        /***********************************************************************

                Возвращает набор of файлы совпадают the given образец

        ***********************************************************************/

        final ГруппаФайлов каталог (ткст образец)
        {
                бул foo (ИнфОВфс инфо)
                {
                        return Путь.совпадение (инфо.имя, образец);
                }

                return каталог (&foo);
        }

        /***********************************************************************

                Возвращает набор of файлы conforming в_ the given фильтр

        ***********************************************************************/

        final ГруппаФайлов каталог (ФильтрВфс фильтр = пусто)
        {       
                return new ГруппаФайлов (this, фильтр);
        }

        /***********************************************************************

                Internal routine в_ traverse the папка дерево

        ***********************************************************************/

        private final ФайлПапка[] скан (ФайлПапка корень, бул рекурсия) 
        {
                auto папки = корень.папки (рекурсия);
                if (рекурсия)
                    foreach (ветвь; папки)
                             папки ~= скан (ветвь, рекурсия);
                return папки;
        }
}


/*******************************************************************************

        A хост for папки, currently использован в_ harbor создай() и открой() 
        methods only

*******************************************************************************/

private class ХостПапки : ЗаписьПапкиВфс
{       
        private ткст          путь;
        private ФайлПапка      родитель;

        /***********************************************************************

        ***********************************************************************/

        private this (ФайлПапка родитель, ткст путь)
        {
                this.путь = путь;
                this.родитель = родитель;
        }

        /***********************************************************************

        ***********************************************************************/

        final ПапкаВфс создай ()
        {
                return new ФайлПапка (родитель, путь, да);
        }

        /***********************************************************************

        ***********************************************************************/

        final ПапкаВфс открой ()
        {
                return new ФайлПапка (родитель, путь, нет);
        }

        /***********************************************************************

                Test в_ see if a папка есть_ли

        ***********************************************************************/

        бул есть_ли ()
        {
                try {
                    открой();
                    return да;
                    } catch (ВВИскл x) {}
                return нет;
        }
}


/*******************************************************************************

        Represents things you can do with a файл 

*******************************************************************************/

private class ХостФайла : ФайлВфс
{
        private Путь.ПутеПарсер путь;

        /***********************************************************************

        ***********************************************************************/

        this (ткст путь = пусто)
        {
                this.путь.разбор (путь);
        }

        /***********************************************************************

                Возвращает крат имя

        ***********************************************************************/

        final ткст имя()
        {
                return путь.файл;
        }

        /***********************************************************************

                Возвращает дол имя

        ***********************************************************************/

        final ткст вТкст ()
        {
                return путь.вТкст;
        }

        /***********************************************************************

                Does this файл есть_ли?

        ***********************************************************************/

        final бул есть_ли()
        {
                return Путь.есть_ли (путь.вТкст);
        }

        /***********************************************************************

                Возвращает файл размер

        ***********************************************************************/

        final бдол размер()
        {
                return Путь.размерФайла(путь.вТкст);
        }

        /***********************************************************************

                Создаёт new файл экземпляр

        ***********************************************************************/

        final ФайлВфс создай ()
        {
                Путь.создайФайл(путь.вТкст);
                return this;
        }

        /***********************************************************************

                Создаёт new файл экземпляр и наполни with поток

        ***********************************************************************/

        final ФайлВфс создай (ИПотокВвода ввод)
        {
                создай.вывод.копируй(ввод).закрой;
                return this;
        }

        /***********************************************************************

                Созд и копируй the given исток

        ***********************************************************************/

        ФайлВфс копируй (ФайлВфс исток)
        {
                auto ввод = исток.ввод;
                scope (exit) ввод.закрой;
                return создай (ввод);
        }

        /***********************************************************************

                Созд и копируй the given исток, и удали the исток

        ***********************************************************************/

        final ФайлВфс перемести (ФайлВфс исток)
        {
                копируй (исток);
                исток.удали;
                return this;
        }

        /***********************************************************************

                Возвращает ввод поток. Don't forget в_ закрой it

        ***********************************************************************/

        final ИПотокВвода ввод ()
        {
                return new Файл (путь.вТкст);
        }

        /***********************************************************************

                Возвращает вывод поток. Don't forget в_ закрой it

        ***********************************************************************/

        final ИПотокВывода вывод ()
        {
                return new Файл (путь.вТкст, Файл.ЗапСущ);
        }

        /***********************************************************************

                Удали this файл

        ***********************************************************************/

        final ФайлВфс удали ()
        {
                Путь.удали (путь.вТкст);
                return this;
        }

        /***********************************************************************

                Duplicate this Запись

        ***********************************************************************/

        final ФайлВфс dup()
        {
                auto возвр = new ХостФайла;
                возвр.путь = путь.dup;
                return возвр;
        }
        
        /***********************************************************************

                Modified время of the файл

        ***********************************************************************/

        final Время изменён ()
        {
                return Путь.штампыВремени(путь.вТкст).изменён;
        }
}


debug (ФайлПапка)
{

/*******************************************************************************

*******************************************************************************/

import io.Stdout;
import io.device.Array;

проц main()
{
        auto корень = new ФайлПапка ("d:/d/import/temp", да);
        корень.папка("тест").создай;
        корень.файл("тест.txt").создай(new Массив("hello"));
        Стдвыв.форматнс ("тест.txt.length = {}", корень.файл("тест.txt").размер);

        корень = new ФайлПапка ("c:/");
        auto набор = корень.сам;

        Стдвыв.форматнс ("сам.файлы = {}", набор.файлы);
        Стдвыв.форматнс ("сам.байты = {}", набор.байты);
        Стдвыв.форматнс ("сам.папки = {}", набор.папки);
        Стдвыв.форматнс ("сам.записи = {}", набор.записи);
/+
        набор = корень.дерево;
        Стдвыв.форматнс ("дерево.файлы = {}", набор.файлы);
        Стдвыв.форматнс ("дерево.байты = {}", набор.байты);
        Стдвыв.форматнс ("дерево.папки = {}", набор.папки);
        Стдвыв.форматнс ("дерево.записи = {}", набор.записи);

        //foreach (папка; набор)
        //Стдвыв.форматнс ("дерево.папка '{}' имеется {} файлы", папка.имя, папка.сам.файлы);

        auto склей = набор.каталог ("s*");
        Стдвыв.форматнс ("склей.файлы = {}", склей.файлы);
        Стдвыв.форматнс ("склей.байты = {}", склей.байты);
+/
        //foreach (файл; склей)
        //         Стдвыв.форматнс ("склей.имя '{}' '{}'", файл.имя, файл.вТкст);
}
}
