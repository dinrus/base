﻿
module io.device.FileMap;

private import sys.common;

private import io.device.File,
               io.device.Array;


version (Posix)
         private import rt.core.stdc.posix.sys.mman;


/*******************************************************************************

*******************************************************************************/


export class ФайлМэп : io.device.Array.Массив
{
        private КартированныйФайл файл;

        /***********************************************************************

                Конструирует ФайлМэп по заданному пути. 

                Нужно использовать перемерь() для установки доступного 
                рабочего пространства.

        ***********************************************************************/
export:

        this (ткст путь, Файл.Стиль стиль = Файл.ЧитЗапОткр)
        {
                файл = new КартированныйФайл (путь, стиль);
                super (файл.карта);
        }

        /***********************************************************************

                Изменить размер файла и вернуть перекартированный контент. После
               этого вызова использовать карта() не требуется.

        ***********************************************************************/

        final ббайт[] перемерь (дол размер)
        {
                auto возвр = файл.перемерь (размер);
                super.присвой (возвр);
                return возвр;
        }

        /***********************************************************************

                Освободить внешние ресурсы.

        ***********************************************************************/

        override проц закрой ()
        {
                super.закрой;
                if (файл)
                    файл.закрой;
                файл = пусто;
        }
}


/*******************************************************************************

*******************************************************************************/

export class КартированныйФайл
{
        private Файл хост;
		
export:

        /***********************************************************************

	        Конструирует ФайлМэп по заданному пути. 

	        Нужно использовать перемерь() для установки доступного 
	        рабочего пространства.

        ***********************************************************************/

        this (ткст путь, Файл.Стиль стиль = Файл.ЧитЗапОткр)
        {
                хост = new Файл (путь, стиль);
        }

        /***********************************************************************

        ***********************************************************************/

        final дол длина ()
        {
                return хост.длина;
        }

        /***********************************************************************

        ***********************************************************************/

        final ткст путь ()
        {
                return хост.вТкст;
        }

        /***********************************************************************

                Изменяет размер файла и возвращает повторно картированный контент. После
                этого вызова использовать карта() не требуется.

        ***********************************************************************/

        final ббайт[] перемерь (дол размер)
        {
                хост.упрости (размер);
                return карта;
        }

        /***********************************************************************

        ***********************************************************************/

        version (Win32)
        {
                private ук    основа;            // Указатель на массив
                private ук  рпФайл;          // картированный файл

                /***************************************************************

                        Вернуть срез, представляющий файл-контент, как 
                        размещённый в карте памяти Массив.

                ***************************************************************/

                final ббайт[] карта ()
                {
                        бцел флаги;

                        // избежать повторных ссылок
                        if (основа)
                            сбрось;

                        // can only do 32bit маппинг on 32bit platform
                        auto размер = cast(т_мера) хост.длина;
                        auto доступ = хост.стиль.доступ;

                        флаги = ПСтраница.ТолькоЧтен;
                        if (доступ & хост.Доступ.Зап)
                            флаги = ПСтраница.ЧтенЗап;
 
                        auto укз = хост.фукз;
                        рпФайл = СоздайМаппингФайла(укз, пусто, cast(ППамять) флаги, 0, 0, пусто);
                        if (рпФайл is пусто)
                            хост.ошибка;

                        флаги = ФАЙЛ_КАРТА_ЧТЕНИЕ;
                        if (доступ & хост.Доступ.Зап)
                            флаги |= ФАЙЛ_КАРТА_ЗАПИСЬ;

                        основа = ВидФайлаВКарту(рпФайл, cast(ППамять)флаги, 0, 0, 0);
                        if (основа is пусто)
                            хост.ошибка;
  
                        return (cast(ббайт*) основа) [0 .. размер];
                }

                /***************************************************************

                        Освободить этот маппинг без слива.

                ***************************************************************/

                final проц закрой ()
                {
                        сбрось;
                        if (хост)
                            хост.закрой;
                        хост = пусто;
                }

                /***************************************************************

                ***************************************************************/

                private проц сбрось ()
                {
                        if (основа)
                            ВидФайлаИзКарты (основа);

                        if (рпФайл)
                            ЗакройДескр(рпФайл);       

                        рпФайл = пусто;
                        основа = пусто;
                }

                /***************************************************************

                        Слить грязный контент из драйва. Бывает провал
                        с ошибкой 33, если файл-контент девственен.
                        Открытию файла для ReadWriteExists
                        следует слей(), который это вызывает.

                ***************************************************************/

                КартированныйФайл слей ()
                {
                        // слить все грязные страницы
                        if (! СлейВидФайла (основа, 0))
                              хост.ошибка;
                        return this;
                }
        }

        /***********************************************************************
                
        ***********************************************************************/

        version (Posix)
        {               
                // Linux код: not yet tested on другой POSIX systems.
                private ук    основа;           // Массив pointer
                private т_мера  размер;           // length of файл

                /***************************************************************

                        return a срез representing файл контент as a 
                        память-mapped Массив. Use this в_ remap контент
                        each время the файл размер is изменён

                ***************************************************************/

                final ббайт[] карта ()
                {
                        // be wary of redundant references
                        if (основа)
                            сбрось;

                        // can only do 32bit маппинг on 32bit platform
                        размер = cast (т_мера) хост.length;

                        // Make sure the маппинг атрибуты are consistant with
                        // the Файл атрибуты.
                        цел флаги = MAP_SHARED;
                        цел protection = PROT_READ;
                        auto доступ = хост.стиль.доступ;
                        if (доступ & хост.Доступ.Зап)
                            protection |= PROT_WRITE;
                                
                        основа = mmap (пусто, размер, protection, флаги, хост.фукз, 0);
                        if (основа is MAP_FAILED)
                           {
                           основа = пусто;
                           хост.ошибка;
                           }
                                
                        return (cast(ббайт*) основа) [0 .. размер];
                }    

                /***************************************************************

                        Release this mapped буфер without flushing

                ***************************************************************/

                final проц закрой ()
                {
                        сбрось;
                        if (хост)
                            хост.закрой;
                        хост = пусто;
                }

                /***************************************************************

                ***************************************************************/

                private проц сбрось ()
                {
                        // NOTE: When a process заканчивается, все mmaps belonging в_ that process
                        //       are automatically unmapped by system (Linux).
                        //       On the другой hand, this is NOT the case when the related 
                        //       файл descrИПtor is закрыт.  This function unmaps explicitly.
                        if (основа)
                            if (munmap (основа, размер))
                                хост.ошибка;

                        основа = пусто;    
                }

                /***************************************************************

                        Flush dirty контент out в_ the drive. 

                ***************************************************************/

                final КартированныйФайл слей () 
                {
                        // MS_ASYNC: delayed слей; equivalent в_ "добавь-в_-queue"
                        // MS_SYNC: function flushes файл immediately; no return until слей complete
                        // MS_INVALIDATE: invalidate все mappings of the same файл (/*shared*/)

                        if (псинх (основа, размер, MS_SYNC | MS_INVALIDATE))
                            хост.ошибка;
                        return this;
                }
        }
}


/*******************************************************************************

*******************************************************************************/

debug (FileMap)
{
        import io.Path;

        проц main()
        {
                auto файл = new КартированныйФайл ("foo.map");
                auto куча = файл.перемерь (1_000_000);

                auto file1 = new КартированныйФайл ("foo1.map");
                auto heap1 = file1.перемерь (1_000_000);

                файл.закрой;
                удали ("foo.map");

                file1.закрой;
                удали ("foo1.map");
        }
}
