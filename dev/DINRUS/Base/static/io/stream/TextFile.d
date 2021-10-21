﻿/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: Nov 2007

        author:         Kris

*******************************************************************************/

module io.stream.TextFile;

public  import io.device.File;

private import io.stream.Text;

/*******************************************************************************

        Создаёт файл со строчно-ориентированным вводом. Ввод буферируемый.

*******************************************************************************/

class ТекстФайлВвод : ТекстВвод
{
        /***********************************************************************

                Создаёт FileStream.              

        ***********************************************************************/

        this (ткст путь, Файл.Стиль стиль = Файл.ЧитСущ)
        {
                this (new Файл (путь, стиль));
        }

        /***********************************************************************

                Оборачивает экземпляр FileConduit. 

        ***********************************************************************/

        this (Файл файл)
        {
                super (файл);
        }
}


/*******************************************************************************
       
        Создаёт файл с форматированным текстовым выводом. Вывод буферируемый.

*******************************************************************************/

class ТекстФайлВывод : ТекстВывод
{
        /***********************************************************************

                Создаёт FileStream.             

        ***********************************************************************/

        this (ткст путь, Файл.Стиль стиль = Файл.ЗапСозд)
        {
                this (new Файл (путь, стиль));
        }

        /***********************************************************************

                Оборачивает экземпляр Файл.

        ***********************************************************************/

        this (Файл файл)
        {
                super (файл);
        }
 }


/*******************************************************************************

*******************************************************************************/

debug (TextFile)
{
        import io.Console;

        проц main()
        {
                auto t = new ТекстФайлВвод ("TextFile.d");
                foreach (строка; t)
                         Квывод(строка).нс;                  
        }
}