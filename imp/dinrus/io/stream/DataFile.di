﻿
module io.stream.DataFile;

private import io.device.File;

private import io.stream.Data;

/*******************************************************************************

        Составляет поисковозможный файл с буферируемым бинарным вводом.
         Метод "сместись" приводит к очистке буфера.

*******************************************************************************/

extern(D):

 class ВводФайлаДанных : ВводДанных
{
   // private Файл провод;

    /***********************************************************************

            Составляет ФайлПоток.

    ***********************************************************************/

    this (ткст путь, Файл.Стиль стиль = Файл.ЧитСущ);

    /***********************************************************************

            Оборачивает экземпляр Файл.

    ***********************************************************************/

    this (Файл файл);

    /***********************************************************************

           Возвращает низлежащий провод.

    ***********************************************************************/

    final Файл файл ();
}


/*******************************************************************************

        Composes a seekable файл with buffered binary вывод. A сместись causes
        the вывод буфер в_ be flushed first

*******************************************************************************/

class ВыводФайлаДанных : ВыводДанных
{
   // private Файл провод;

    /***********************************************************************

            Compose a FileStream

    ***********************************************************************/

    this (ткст путь, Файл.Стиль стиль = Файл.ЗапСозд);

    /***********************************************************************

            Wrap a FileConduit экземпляр

    ***********************************************************************/

    this (Файл файл);

    /***********************************************************************

            Return the underlying провод

    ***********************************************************************/

    final Файл файл ();
}

debug (DataFile)
{
    import io.Stdout;
	import io.stream.DataFile;

    проц main()
    {
        auto myFile = new ВыводФайлаДанных("Hello.txt");
        myFile.пиши("some текст");
        myFile.слей;
        Стдвыв.форматнс ("{}:{}", myFile.файл.позиция, myFile.сместись(myFile.Якорь.Тек));
    }
}
