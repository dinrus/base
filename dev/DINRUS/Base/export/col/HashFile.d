﻿module col.HashFile;

private import io.device.FileMap:КартированныйФайл;

/******************************************************************************

        ХэшФайл реализует простой механизм сохранения и восстановления
        большого количества данных в течение хостингового процесса.
        Он служит в качестве локального кэша для удалённого источника данных,
        или в качестве spillover area для больших кэш-экземпляров в памяти.

        Note that any и все stored данные is rendered не_годится the moment
        a ХэшФайл объект is garbage-собериed.

        The implementation follows a fixed-ёмкость record схема, where
        контент can be rewritten in-place until saопр ёмкость is reached.
        At such время, the altered контент is moved в_ a larger ёмкость
        record at конец-of-файл, и a hole remains at the приор location.
        These holes are not собериed, since the lifespan of a ХэшФайл
        is limited в_ that of the хост process.

        все индекс ключи must be unique. Writing в_ the ХэшФайл with an
        existing ключ will overwrite any previous контент. What follows
        is a contrived example:

        ---
        alias ХэшФайл!(ткст, ткст) Bucket;

        auto бакет = new Bucket ("бакет.bin", ХэшФайл.ПоловинаК);

        // вставь some данные, и retrieve it again
        auto текст = "this is a тест";
        бакет.помести ("a ключ", текст);
        auto b = cast(ткст) бакет.получи ("a ключ");

        assert (b == текст);
        бакет.закрой;
        ---

******************************************************************************/

class ХэшФайл(К, З)
{
    /**********************************************************************

            Define the ёмкость (блок-размер) of each record

    **********************************************************************/

    struct РазмерБлока
    {
        цел ёмкость;
    }

    // backing storage
    private КартированныйФайл              файл;

    // память-mapped контент
    private ббайт[]                 куча;

    // basic ёмкость for each record
    private РазмерБлока               блок;

    // pointers в_ файл records
    private Запись[К]               карта;

    // текущ файл размер
    private бдол                   размерФайла;

    // текущ файл usage
    private бдол                   ватерлиния;

    // supported блок размеры
    public static const РазмерБлока   ВосемьК  = {128-1},
                                                 ЧетвертьК = {256-1},
                                                 ПоловинаК    = {512-1},
                                                 ОдинК     = {1024*1-1},
                                                 ДваК     = {1024*2-1},
                                                 ЧетыреК    = {1024*4-1},
                                                 ВосемьК   = {1024*8-1},
                                                 ШестнадцатьК = {1024*16-1},
                                                 ТридцатьДваК = {1024*32-1},
                                                 ШестдесятьЧетыреК = {1024*64-1};


    /**********************************************************************

            Construct a ХэшФайл with the предоставленный путь, record-размер,
            и inital record счёт. The latter causes records в_ be
            pre-allocated, saving a certain amount of growth activity.
            Selecting a record размер that roughly совпадает the serialized
            контент will предел 'thrashing'.

    **********************************************************************/

    this (ткст путь, РазмерБлока блок, бцел начальныеЗаписи = 100)
    {
        this.блок = блок;

        // открой a storage файл
        файл = new КартированныйФайл (путь);

        // установи начальное файл размер (cannot be zero)
        размерФайла = начальныеЗаписи * (блок.ёмкость + 1);

        // карта the файл контент
        куча = файл.перемерь (размерФайла);
    }

    /**********************************************************************

            Return where the ХэшФайл is located

    **********************************************************************/

    final ткст путь ()
    {
        return файл.путь;
    }

    /**********************************************************************

            Возвращает currently populated размер of this ХэшФайл

    **********************************************************************/

    final бдол length ()
    {
        return ватерлиния;
    }
	
	alias length длина;

    /**********************************************************************

            Возвращает serialized данные for the предоставленный ключ. Возвращает
            пусто if the ключ was не найден.

            Be sure в_ synchronize доступ by multИПle threads

    **********************************************************************/

    final З получи (К ключ, бул очисть = нет)
    {
        auto p = ключ in карта;

        if (p)
            return p.читай (this, очисть);
        return З.init;
    }

    /**********************************************************************

            Удали the предоставленный ключ из_ this ХэшФайл. Leaves a
            hole in the backing файл

            Be sure в_ synchronize доступ by multИПle threads

    **********************************************************************/

    final проц удали (К ключ)
    {
        карта.удали (ключ);
    }

    /**********************************************************************

            Зап a serialized блок of данные, и associate it with
            the предоставленный ключ. все ключи must be unique, и it is the
            responsibility of the programmer в_ ensure this. Reusing
            an existing ключ will overwrite previous данные.

            Note that данные is allowed в_ grow внутри the occupied
            бакет until it becomes larger than the allocated пространство.
            When this happens, the данные is moved в_ a larger бакет
            at the файл хвост.

            Be sure в_ synchronize доступ by multИПle threads

    **********************************************************************/

    final проц помести (К ключ, З данные, К function(К) retain = пусто)
    {
        auto r = ключ in карта;

        if (r)
            r.пиши (this, данные, блок);
        else
        {
            Запись rr;
            rr.пиши (this, данные, блок);
            if (retain)
                ключ = retain (ключ);
            карта [ключ] = rr;
        }
    }

    /**********************************************************************

            Close this ХэшФайл -- все контент is lost.

    **********************************************************************/

    final проц закрой ()
    {
        if (файл)
        {
            файл.закрой;
            файл = пусто;
            карта = пусто;
        }
    }

    /**********************************************************************

            Each Запись takes up a число of 'pages' внутри the файл.
            The размер of these pages is determined by the РазмерБлока
            предоставленный during ХэшФайл construction. добавьitional пространство
            at the конец of each блок is potentially wasted, but enables
            контент в_ grow in размер without creating a myriad of holes.

    **********************************************************************/

    private struct Запись
    {
        private бдол           смещение;
        private цел             использован,
                ёмкость = -1;

        /**************************************************************

                This should be protected из_ нить-contention at
                a higher уровень.

        **************************************************************/

        З читай (ХэшФайл бакет, бул очисть)
        {
            if (использован)
            {
                auto возвр = cast(З) бакет.куча [смещение .. смещение + использован];
                if (очисть)
                    использован = 0;
                return возвр;
            }
            return З.init;
        }

        /**************************************************************

                This should be protected из_ нить-contention at
                a higher уровень.

        **************************************************************/

        проц пиши (ХэшФайл бакет, З данные, РазмерБлока блок)
        {
            this.использован = данные.length;

            // создай new slot if we exceed ёмкость
            if (this.использован > this.ёмкость)
                создайБакет (бакет, this.использован, блок);

            бакет.куча [смещение .. смещение+использован] = cast(ббайт[]) данные;
        }

        /**************************************************************

        **************************************************************/

        проц создайБакет (ХэшФайл бакет, цел байты, РазмерБлока блок)
        {
            this.смещение = бакет.ватерлиния;
            this.ёмкость = (байты + блок.ёмкость) & ~блок.ёмкость;

            бакет.ватерлиния += this.ёмкость;
            if (бакет.ватерлиния > бакет.размерФайла)
            {
                auto мишень = бакет.ватерлиния * 2;
                debug(ХэшФайл)
                эхо ("growing file from %lld, %lld, в_ %lld\n",
                        бакет.размерФайла, бакет.ватерлиния, мишень);

                // расширь the physical файл размер и remap the куча
                бакет.куча = бакет.файл.перемерь (бакет.размерФайла = мишень);
            }
        }
    }
}


/******************************************************************************

******************************************************************************/

debug (ХэшФайл)
{
    extern(C) цел printf (сим*, ...);

    import io.Path;
    import io.Stdout;
    import text.convert.Integer;

    проц main()
    {
        alias ХэшФайл!(ткст, ткст) Bucket;

        auto файл = new Bucket ("foo.map", Bucket.ЧетвертьК, 1);

        сим[16] врем;
        for (цел i=1; i < 1024; ++i)
            файл.помести (форматируй(врем, i).dup, "blah");

        auto s = файл.получи ("1", да);
        if (s.length)
            Стдвыв.форматнс ("результат '{}'", s);
        s = файл.получи ("1");
        if (s.length)
            Стдвыв.форматнс ("результат '{}'", s);
        файл.закрой;
        удали ("foo.карта");
    }
}
