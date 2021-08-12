﻿module io.vfs.VirtualFolder;

private import io.model;
private import io.vfs.model;

class ВиртуальнаяПапка : ХостВфс
{
        private ткст                  name_;
        private ФайлВфс[ткст]         файлы;
        private ПапкаВфс[ткст]       грузы;
        private ЗаписьПапкиВфс[ткст]  папки;
        private ВиртуальнаяПапка           предок;

        this (ткст имя);
        final ткст имя();
        final ткст вТкст();
        ХостВфс прикрепи (ПапкаВфс папка, ткст имя = пусто);
        ХостВфс прикрепи (ПапкиВфс группа);
        ХостВфс открепи (ПапкаВфс папка);
        final ХостВфс карта (ФайлВфс файл, ткст имя);
        final ХостВфс карта (ЗаписьПапкиВфс папка, ткст имя);
        final цел opApply (цел delegate(ref ПапкаВфс) дг);
        final ЗаписьПапкиВфс папка (ткст путь);
        ФайлВфс файл (ткст путь);
        final ПапкаВфс очисть ();
        final бул записываемый ();
        final ПапкиВфс сам ();
        final ПапкиВфс дерево ();
        final проц проверь (ПапкаВфс папка, бул mounting);
        ПапкаВфс закрой (бул подай = да);
        package final ткст ошибка (ткст сооб);
        private final проц оцени (ткст имя);
}

private class ВиртуальныеПапки : ПапкиВфс
{
        private ПапкиВфс[] члены;           // папки in группа

        private this ();
        private this (ВиртуальнаяПапка корень, бул рекурсия);
        final цел opApply (цел delegate(ref ПапкаВфс) дг);
        final бцел файлы ();
        final бдол байты ();
        final бцел папки ();
        final бцел записи ();
        final ПапкиВфс поднабор (ткст образец);
        final ФайлыВфс каталог (ткст образец);
        final ФайлыВфс каталог (ФильтрВфс фильтр = пусто);
}

private class ВиртуальныеФайлы : ФайлыВфс
{
        private ФайлыВфс[] члены;

        private this (ВиртуальныеПапки хост, ФильтрВфс фильтр);
        final цел opApply (цел delegate(ref ФайлВфс) дг);
        final бцел файлы ();
        final бдол байты ();
}