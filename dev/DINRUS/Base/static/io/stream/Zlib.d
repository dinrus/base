module io.stream.Zlib;

private import io.device.Conduit : ФильтрВвода, ФильтрВывода;
private import io.model : ИПотокВвода, ИПотокВывода, ИПровод;

/* This constant controls the размер of the ввод/вывод buffers we use
 * internally.  This should be a fairly sane значение (it's suggested by the zlib
 * documentation), that should only need changing for память-constrained
 * platforms/use cases.
 *
 * An alternative would be в_ сделай the chunk размер a template parameter в_ the
 * filters themselves, but Dinrus already есть ещё than enough template
 * параметры getting in the way :)
 */

private enum { РАЗМЕР_ЧАНКА = 256 * 1024 };

/* This constant specifies the default окноБиты значение.  This is taken из_
 * documentation in zlib.h.  It shouldn't break anything if zlib changes в_
 * a different default.
 */

private enum { ОКНОБИТЫ_ДЕФОЛТ = 15 };

extern(D):

/*******************************************************************************

    This ввод фильтр can be used в_ выполни decompression of zlib Потокs.

*******************************************************************************/

class ВводЗлиб : ФильтрВвода
{
    /***************************************************************************

        This enumeration допускается you в_ specify the кодировка of the compressed
        поток.

    ***************************************************************************/

    enum Кодировка : цел
    {
        /**
         *  The код should attempt в_ automatically determine what the кодировка
         *  of the поток should be.  Note that this cannot detect the case
         *  where the поток was compressed with no кодировка.
         */
        Guess,
        /**
         *  Поток есть zlib кодировка.
         */
        Zlib,
        /**
         *  Поток есть gzip кодировка.
         */
        Gzip,
        /**
         *  Поток есть no кодировка.
         */
        Нет
    }


    /***************************************************************************

        Constructs a new zlib decompression фильтр.  You need в_ пароль in the
        поток that the decompression фильтр will читай из_.  If you are using
        this фильтр with a провод, the опрiom в_ use is:

        ---
        auto ввод = new ВводЗлиб(myConduit.ввод));
        ввод.читай(myContent);
        ---

        The optional окноБиты parameter is the основа two logarithm of the
        window размер, and should be in the range 8-15, defaulting в_ 15 if not
        specified.  добавьitionally, the окноБиты parameter may be негатив в_
        indicate that zlib should omit the стандарт zlib заголовок and trailer,
        with the window размер being -окноБиты.

      Параметры:
        поток = compressed ввод поток.

        кодировка =
            поток кодировка.  Defaults в_ Кодировка.Guess, which
            should be sufficient unless the поток was compressed with
            no кодировка; in this case, you must manually specify
            Кодировка.Нет.

        окноБиты =
            the основа two logarithm of the window размер, and should be in the
            range 8-15, defaulting в_ 15 if not specified.

    ***************************************************************************/

    this(ИПотокВвода поток, Кодировка кодировка,
         цел окноБиты = ОКНОБИТЫ_ДЕФОЛТ);

    /// описано ранее
    this(ИПотокВвода поток);

    ~this();

    /***************************************************************************

        Resets and re-initialises this экземпляр.

        If you are creating compression Потокs insопрe a loop, you may wish в_
        use this метод в_ re-use a single экземпляр.  This prevents the
        potentially costly re-allocation of internal buffers.

        The поток must have already been закрыт перед calling сбрось.

    ***************************************************************************/

    проц сбрось(ИПотокВвода поток, Кодировка кодировка,
                          цел окноБиты = ОКНОБИТЫ_ДЕФОЛТ);

    /// описано ранее

    проц сбрось(ИПотокВвода поток);

    /***************************************************************************

        Decompresses данные из_ the underlying провод преобр_в a мишень Массив.

        Возвращает the число of байты stored преобр_в приёмн, which may be less than
        requested.

    ***************************************************************************/

    override т_мера читай(проц[] приёмн);

    /***************************************************************************

        Closes the compression поток.

    ***************************************************************************/

    override проц закрой();

    // Disable seeking
    override дол сместись(дол смещение, Якорь якорь = Якорь.Нач);

}

/*******************************************************************************

    This вывод фильтр can be used в_ выполни compression of данные преобр_в a zlib
    поток.

*******************************************************************************/

class ВыводЗлиб : ФильтрВывода
{
    /***************************************************************************

        This enumeration represents several pre-defined compression levels.

        Any целое between -1 and 9 включительно may be used как уровень,
        although the symbols in this enumeration should suffice for most
        use-cases.

    ***************************************************************************/

    enum Уровень : цел
    {
        /**
         * Default compression уровень.  This is selected for a good compromise
         * between скорость and compression, and the exact compression уровень is
         * determined by the underlying zlib library.  Should be roughly
         * equivalent в_ compression уровень 6.
         */
        Нормальный = -1,
        /**
         * Do not выполни compression.  This will cause the поток в_ расширь
         * slightly в_ accommodate поток metadata.
         */
        Нет = 0,
        /**
         * Minimal compression; the fastest уровень which performs at least
         * some compression.
         */
        Быстрый = 1,
        /**
         * Maximal compression.
         */
        Наилучший = 9
    }

    /***************************************************************************

        This enumeration допускается you в_ specify what the кодировка of the
        compressed поток should be.

    ***************************************************************************/

    enum Кодировка : цел
    {
        /**
         *  Поток should use zlib кодировка.
         */
        Zlib,
        /**
         *  Поток should use gzip кодировка.
         */
        Gzip,
        /**
         *  Поток should use no кодировка.
         */
        Нет
    }

    /***************************************************************************

        Constructs a new zlib compression фильтр.  You need в_ пароль in the
        поток that the compression фильтр will пиши в_.  If you are using
        this фильтр with a провод, the опрiom в_ use is:

        ---
        auto вывод = new ВыводЗлиб(myConduit.вывод);
        вывод.пиши(myContent);
        ---

        The optional окноБиты parameter is the основа two logarithm of the
        window размер, and should be in the range 8-15, defaulting в_ 15 if not
        specified.  добавьitionally, the окноБиты parameter may be негатив в_
        indicate that zlib should omit the стандарт zlib заголовок and trailer,
        with the window размер being -окноБиты.

    ***************************************************************************/

    this(ИПотокВывода поток, Уровень уровень, Кодировка кодировка,
         цел окноБиты = ОКНОБИТЫ_ДЕФОЛТ);

    /// описано ранее
    this(ИПотокВывода поток, Уровень уровень = Уровень.Нормальный);


    ~this();

    /***************************************************************************

        Resets and re-initialises this экземпляр.

        If you are creating compression Потокs insопрe a loop, you may wish в_
        use this метод в_ re-use a single экземпляр.  This prevents the
        potentially costly re-allocation of internal buffers.

        The поток must have already been закрыт or committed перед calling
        сбрось.

    ***************************************************************************/

    проц сбрось(ИПотокВывода поток, Уровень уровень, Кодировка кодировка,
                          цел окноБиты = ОКНОБИТЫ_ДЕФОЛТ);

    /// описано ранее
    проц сбрось(ИПотокВывода поток, Уровень уровень = Уровень.Нормальный);

    /***************************************************************************

        Compresses the given данные в_ the underlying провод.

        Возвращает the число of байты из_ ист that were compressed; пиши
        should всегда используй все данные предоставленный в_ it, although it may not be
        immediately записано в_ the underlying вывод поток.

    ***************************************************************************/

    override т_мера пиши(проц[] ист);

    /***************************************************************************

        This читай-only property returns the число of compressed байты that
        have been записано в_ the underlying поток.  Following a вызов в_
        either закрой or подай, this will contain the total compressed размер of
        the ввод данные поток.

    ***************************************************************************/

    т_мера записано();

    /***************************************************************************

        Close the compression поток.  This will cause any buffered контент в_
        be committed в_ the underlying поток.

    ***************************************************************************/

    override проц закрой();

    /***************************************************************************

        Purge any buffered контент.  Calling this will implicitly конец the zlib
        поток, so it should not be called until you are завершено compressing
        данные.  Any calls в_ either пиши or подай после a compression фильтр
        есть been committed will throw an исключение.

        The only difference between calling this метод and calling закрой is
        that the underlying поток will not be закрыт.

    ***************************************************************************/

    проц подай();

    // Disable seeking
    override дол сместись(дол смещение, Якорь якорь = Якорь.Нач);

}
