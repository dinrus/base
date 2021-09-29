﻿module time.Clock;

public  import  time.Time;
private import  dinrus;

extern(D):

 struct Часы
{
        static final бцел[] ДниВМесяцВЦелом = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];
       
	    static проц устДеньГода(ref ДатаВремя дв);

        version (Win32)
        {
                /***************************************************************

                        Возвращает текущее время как UTC с начала эпохи

                ***************************************************************/

                static Время сейчас ();

                /***************************************************************

                        Набор полей Дата представляет текущее время. 

                ***************************************************************/

                 static ДатаВремя вДату ();


                /***************************************************************

                        Набор полей представляет собой время UTC. Заметьте, что 
                        преобразование ограничено хостинговой ОС, и не сможет
                        и правильно работать со значением Времени  для текущего домена.
                        На Win32 самой наименьшей датой является 1601 год. На Линукс
                        это 1970. Все системы также имеют ограничение на самые большие даты.
                        Дата в лучшем случае ограничивается точностью миллисекунды.

                ***************************************************************/

                static ДатаВремя вДату (Время время);

                /***************************************************************

                        Преобразует поля Дата во Время

                        Набор полей представляет собой время UTC. Заметьте, что 
                        преобразование ограничено хостинговой ОС, и не сможет
                        и правильно работать со значением Времени  для текущего домена.
                        На Win32 самой наименьшей датой является 1601 год. На Линукс
                        это 1970. Все системы также имеют ограничение на самые большие даты.
                        Дата в лучшем случае ограничивается точностью миллисекунды.

                ***************************************************************/

                static Время изДаты (ref ДатаВремя дв);

                /***************************************************************

                        Преобразует FILETIME во Время

                ***************************************************************/

                 static Время преобразуй (ФВРЕМЯ время);

                /***************************************************************

                        Преобразует Время в FILETIME

                ***************************************************************/

                 static ФВРЕМЯ преобразуй (Время дв);
        }

        version (Posix)
        {
                /***************************************************************

                        Возвращает текущее время как UTC с начала эпохи

                ***************************************************************/

                 static Время сейчас ();

                /***************************************************************

                        Набор Дата fields в_ represent the текущ время. 

                ***************************************************************/

                static ДатаВремя вДату ();

                /***************************************************************

                        Набор полей представляет собой время UTC. Заметьте, что 
                        преобразование ограничено хостинговой ОС, и не сможет
                        и правильно работать со значением Времени  для текущего домена.
                        На Win32 самой наименьшей датой является 1601 год. На Линукс
                        это 1970. Все системы также имеют ограничение на самые большие даты.
                        Дата в лучшем случае ограничивается точностью миллисекунды.

                **************************************************************/

                static ДатаВремя вДату (Время время);

                /***************************************************************

                        Преобразует Дата во Время

                        Набор полей представляет собой время UTC. Заметьте, что 
                        преобразование ограничено хостинговой ОС, и не сможет
                        и правильно работать со значением Времени  для текущего домена.
                        На Win32 самой наименьшей датой является 1601 год. На Линукс
                        это 1970. Все системы также имеют ограничение на самые большие даты.
                        Дата в лучшем случае ограничивается точностью миллисекунды.

                ***************************************************************/

                static Время изДаты (ref ДатаВремя дв);

                /***************************************************************

                        Преобразует значврем во Время

                ***************************************************************/

                 static Время преобразуй (ref значврем tv);

                /***************************************************************

                        Преобразует Время в значврем

                ***************************************************************/

                 static значврем преобразуй (Время время);
        }
}
