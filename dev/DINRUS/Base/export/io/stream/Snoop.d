﻿module io.stream.Snoop;

private import  io.Console,
                io.device.Conduit;

private import  text.convert.Format;

private alias проц delegate(ткст) Снуп;


/*******************************************************************************

        Поток в_ expose вызов behaviour. By default, activity след is
        sent в_ Кош

*******************************************************************************/

extern(D) class СнупВвод : ИПотокВвода
{
       // private ИПотокВвода     хост;
       // private Снуп           snoop;

        /***********************************************************************

                Прикрепить к предоставленному потоку.

        ***********************************************************************/

        this (ИПотокВвода хост, Снуп snoop = пусто);

        /***********************************************************************

                Вернуть вышележащий хост этого фильтра.
                        
        ***********************************************************************/

        ИПотокВвода ввод ();

        /***********************************************************************

                Вернуть хостинговый провод.

        ***********************************************************************/

        final ИПровод провод ();

        /***********************************************************************

                Чтен из_ провод преобр_в a мишень Массив. The предоставленный приёмн 
                will be populated with контент из_ the провод. 

                Возвращает the число of байты читай, which may be less than
                requested in приёмн

        ***********************************************************************/

        final т_мера читай (проц[] приёмн);

        /***********************************************************************

                Load the биты из_ a поток, and return them все in an
                Массив. The приёмн Массив can be предоставленный как опция, which
                will be expanded as necessary в_ используй the ввод.

                Возвращает an Массив representing the контент, and throws
                ВВИскл on ошибка
                              
        ***********************************************************************/

        проц[] загрузи (т_мера max=-1);

        /***********************************************************************

                Очищает любой буферированный контент.

        ***********************************************************************/

        final ИПотокВвода слей ();

        /***********************************************************************

                Закрывает ввод.

        ***********************************************************************/

        final проц закрой ();

        /***********************************************************************
        
                Seek on this поток. Target conduits that don't support
                seeking will throw an ВВИскл

        ***********************************************************************/

        final дол сместись (дол смещение, Якорь якорь = Якорь.Нач);

        /***********************************************************************

                Internal след handler

        ***********************************************************************/

        private проц снупер (ткст x);

        /***********************************************************************

                Internal след handler

        ***********************************************************************/

        private проц след (ткст формат, ...);
}


/*******************************************************************************

        Поток в_ expose вызов behaviour. By default, activity след is
        sent в_ Кош

*******************************************************************************/

class СнупВывод : ИПотокВывода
{
       // private ИПотокВывода    хост;
      //  private Снуп           snoop;

        /***********************************************************************

                Attach в_ the предоставленный поток

        ***********************************************************************/

        this (ИПотокВывода хост, Снуп snoop = пусто);

        /***********************************************************************
        
                Возвращает upПоток хост of this фильтр
                        
        ***********************************************************************/

        ИПотокВывода вывод ();

        /***********************************************************************

                Write в_ провод из_ a исток Массив. The предоставленный ист
                контент will be записано в_ the провод.

                Возвращает the число of байты записано из_ ист, which may
                be less than the quantity предоставленный

        ***********************************************************************/

        final т_мера пиши (проц[] ист);

        /***********************************************************************

                Возвращает hosting провод

        ***********************************************************************/

        final ИПровод провод ();

        /***********************************************************************

                Emit/purge buffered контент

        ***********************************************************************/

        final ИПотокВывода слей ();

        /***********************************************************************

                Close the вывод

        ***********************************************************************/

        final проц закрой ();

        /***********************************************************************

                Transfer the контент of другой провод в_ this one. Возвращает
                a reference в_ this class, либо throws ВВИскл on failure.

        ***********************************************************************/

        final ИПотокВывода копируй (ИПотокВвода ист, т_мера max=-1);

        /***********************************************************************
        
                Seek on this поток. Target conduits that don't support
                seeking will throw an ВВИскл

        ***********************************************************************/

        final дол сместись (дол смещение, Якорь якорь = Якорь.Нач);

      //  /***********************************************************************

       //         Internal след handler

    //    ***********************************************************************/

      //  private проц снупер (ткст x);

    //    /***********************************************************************

     //           Internal след handler

     //   ***********************************************************************/

       // private проц след (ткст форматируй, ...);
}



debug (Снуп)
{
        проц main()
        {
                auto s = new СнупВвод (пусто);
                auto o = new СнупВывод (пусто);
        }
}
