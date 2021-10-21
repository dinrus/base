import io.Stdout, io.Console, io.UnicodeFile, text.convert.UnicodeBom;
//import io.File;
import io.device.File, io.device.TempFile;


проц вф()
{
    Стдвыв(r"
Убедитесь что транзитивный файл более не существует, т.к объект ВремФайл
уничтожен, а перманентный файл остаётся. Также нужно проверить следующее:

 * файл должен принадлежать вам,
 * хозяин должен иметь разрешения на чтение и запись,
 * у файла не должно быть установлено никаких иных допусков.

Для систем POSIX:

 * временный файл должен принадлежать либо вам, либо root,
 * Если любой другой может кроме вам писать в него, должен быть установлен sticky bit,
 * Если эта папка записываема любым другим, кроме root или пользователя, и
   sticky bit *не* установлен, то создание временного файла не удастся.

  Возможно, вам захочется впоследствии удалить промежуточный файл. :)")
    .нс;

    Стдвыв.форматнс("Создаётся промежуточный файл:");
    {
        scope времФайл = new ВремФайл(/*ВремФайл.UserPermanent*/);

        Стдвыв.форматнс(" .. путь: {}", времФайл);

        времФайл.пиши("Временный промежуточный файл.");

        ткст буфер = new сим[1023];
        времФайл.сместись(0);
        буфер = буфер[0..времФайл.читай(буфер)];

        Стдвыв.форматнс(" .. содержимое: \"{}\"", буфер);

        Стдвыв(" .. нажми Enter, чтобы удалить объект ВремФайл.").нс;
        Кввод.копируйнс();
    }

    Стдвыв.нс;

    Стдвыв.форматнс("Создаётся постоянный файл:");
    {
        scope времФайл = new ВремФайл(ВремФайл.Навсегда);

        Стдвыв.форматнс(" .. путь: {}", времФайл);

        времФайл.пиши("Навсегда temp файл.");

        ткст буфер = new сим[1023];
        времФайл.сместись(0);
        буфер = буфер[0..времФайл.читай(буфер)];

        Стдвыв.форматнс(" .. содержимое: \"{}\"", буфер);

        Стдвыв(" .. нажми Enter, чтобы удалить ВремФайл объект.").слей;
        Кввод.копируйнс();
    }

    Стдвыв("\nГотово.").нс;
}

/+
проц ф()
        {
                auto x = new Файл ("");

                auto контент = cast(ткст) Файл("tstio.d").читай;
                Стдвыв (контент).нс;
        }
+/		
проц фЮ()
        {       
                auto файл = ФайлЮ!(сим)("uf.d", Кодировка.UTF_8);
                auto контент = файл.читай;
                Стдвыв (контент).нс;
        }
		
проц иФ()
        {
                сим[10] ff;

                auto файл = new Файл("ts.d");
                auto контент = cast(ткст) файл.загрузи (файл);
                assert (контент.length is файл.length);
                assert (файл.читай(ff) is файл.Кф);
                assert (файл.позиция is контент.length);
                файл.сместись (0);
                assert (файл.позиция is 0);
                assert (файл.читай(ff) is 10);
                assert (файл.позиция is 10);
                assert (файл.сместись(0, файл.Якорь.Тек) is 10);
                assert (файл.сместись(0, файл.Якорь.Тек) is 10);
        }
		
проц main(){ фЮ; вф;}