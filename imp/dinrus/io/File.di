﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Mar 2005: Initial release
        version:        Feb 2007: No longer a proxy subclass
                        
        author:         Kris

*******************************************************************************/

module io.File;

private import exception, Провод = io.device.File;

//pragma (msg, "warning - io.File functionality has migrated to static functions within io.device.File");

/*******************************************************************************

        A wrapper atop of FileConduit в_ expose a simpler API. This one
        returns the entire файл контент as a проц[], and sets the контент
        в_ reflect a given проц[].

        Метод читай() returns the current контент of the файл, whilst пиши()
        sets the файл контент, and файл length, в_ the предоставленный Массив. Метод
        добавь() добавьs контент в_ the хвост of the файл.

        Methods в_ inspect the файл system, check the статус of a файл or
        дир and другой facilities are made available via the associated
        путь (exposed via the путь() метод)
        
*******************************************************************************/


class Файл
{
        private ткст path_;

        /***********************************************************************

                Вызов-site shortcut в_ создай a Файл экземпляр. This 
                enables the same syntax as struct usage, so may expose
                a migration путь

        ***********************************************************************/


        this (ткст путь)
        {
                path_ = путь;
        }

        /***********************************************************************

                Вызов-site shortcut в_ создай a Файл экземпляр. This 
                enables the same syntax as struct usage, so may expose
                a migration путь

        ***********************************************************************/

        static Файл opCall (ткст путь)
        {
                return new Файл (путь);
        }

        /***********************************************************************

                Return the контент of the файл.

        ***********************************************************************/

        final проц[] читай ()
        {
                scope провод = new Провод.Файл (path_);  
                scope (exit)
                       провод.закрой;

                // размести enough пространство for the entire файл
                auto контент = new ббайт [cast(т_мера) провод.длина];

                //читай the контент
                if (провод.читай (контент) != контент.length)
                    throw new ВВИскл ("неожиданный кф");

                return контент;
        }

        /***********************************************************************

                Набор the файл контент and length в_ reflect the given Массив.

        ***********************************************************************/

        final Файл пиши (проц[] контент)
        {
                return пиши (контент, Провод.Файл.ЧитЗапСозд);  
        }

        /***********************************************************************

                Append контент в_ the файл.

        ***********************************************************************/

        final Файл добавь (проц[] контент)
        {
                return пиши (контент, Провод.Файл.ЧитДоб);  
        }

        /***********************************************************************

                Набор the файл контент and length в_ reflect the given Массив.

        ***********************************************************************/

        private Файл пиши (проц[] контент, Провод.Файл.Стиль стиль)
        {      
                scope провод = new Провод.Файл (path_, стиль);  
                scope (exit)
                       провод.закрой;

                провод.пиши (контент);
                return this;
        }
}

/*******************************************************************************

*******************************************************************************/

debug (Файл)
{
        import io.Stdout;

        проц main()
        {
                auto x = new Файл ("");

                auto контент = cast(ткст) Файл("Файл.d").читай;
                Стдвыв (контент).нс;
        }
}
