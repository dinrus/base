﻿/*******************************************************************************

        Альтернатива ФПуть. Используйте, когда не требуется редактировать
        фичи путей. Например, если всё, что необходимо сделать, - 
        проверить, имеется ли какой-то путь, то использование этого модуля 
        будет более приемлемо, чем использование ФПуть:
        ---
        if (есть_ли ("какой_то/файл/путь")) 
            ...
        ---

        These functions may be less efficient than ФПуть because they 
        generally прикрепи a пусто в_ the имяф for each underlying O/S
        вызов. Use Путь when you need pedestrian access в_ the файл-system, 
        and are not manИПulating the путь components. Use ФПуть where
        путь-editing or mutation is desired.

        We encourage the use of "named import" with this module, such as
        ---
        import Путь = io.Path;

        if (Путь.есть_ли ("some/файл/путь")) 
            ...
        ---

        Also резопрing here is a lightweight путь-парсер, which splits a 
        фпуть преобр_в constituent components. ФПуть is based upon the
        same ПутеПарсер:
        ---
        auto p = Путь.разбор ("some/файл/путь");
        auto путь = p.путь;
        auto имя = p.имя;
        auto суффикс = p.суффикс;
        ...
        ---

        Путь normalization and образец-совпадают is also hosted here via
        the нормализуй() and образец() functions. See the doc towards the
        конец of this module.

        Compile with -version=Win32SansUnicode в_ enable Win95 & Win32s 
        файл support.

*******************************************************************************/

module io.Path;

public  import  time.Time : Время, ИнтервалВремени;
private import  io.model : ФайлКонст, ИнфОФайле;



/*******************************************************************************

        Оборачивает специфичные вызовы O/S в Динрус API. 

*******************************************************************************/

extern(D) package struct ФС
{
        /***********************************************************************

                Информация о штампе времени. 

        ***********************************************************************/

        struct Штампы
        {
                Время    создан,        /// время создания
                        использовался,       /// последнее время использования
                        изменён;       /// последнее время изменения
        }

        /***********************************************************************

                Некоторые продстройки для импорта листинга папки

        ***********************************************************************/

        struct Листинг
        {
                ткст папка;
                бул   всеФайлы;
                
                цел opApply (цел delegate(ref ИнфОФайле) дг);
        }

        /***********************************************************************

                Выводит исключение, используя последнюю известную ошибку

        ***********************************************************************/

        static проц исключение (ткст имяф);

        /***********************************************************************

                Вывести ВВИскл 

        ***********************************************************************/

        static проц исключение (ткст префикс, ткст ошибка);

        /***********************************************************************

                Возвратить отлаженный путь, чтобы у непустых экземпляров всегда
                в завершении стоял разделитель.

                Примечание: размещает память, где путь ещё не имеет терминации

        ***********************************************************************/

        static ткст псеп_в_конце (ткст путь, сим c = '/');

        /***********************************************************************

                Возвратить отлаженный путь, чтобы у непустых экземпляров всегда
                в завершении стоял разделитель.

        ***********************************************************************/

        static ткст очищенный (ткст путь, сим c = '/');

        /***********************************************************************

                Объединить вместе набор определений пути. Между каждым из сегментов
                вставляется разделитель пути.

                Примечание: размещает память

        ***********************************************************************/

        static ткст объедини (ткст[] пути...);

        /***********************************************************************

                Добавить завершающее пусто к ткст

                Примечание: размещает память, если приёмн слишком мал

        ***********************************************************************/

        static ткст ткт0 (ткст ист, ткст приёмн);


                /***************************************************************

                        Возвращает, существует ли файл или путь.

                ***************************************************************/

                static бул есть_ли (ткст имя);

                /***************************************************************

                        Возвращает длину файла(в байтах).

                ***************************************************************/

                static бдол размерФайла (ткст имя);

                /***************************************************************

                        Этот файл записываемый ли?

                ***************************************************************/

                static бул записываем_ли (ткст имя);

                /***************************************************************

                        Является ли этот файл на самом деле папка/дир?

                ***************************************************************/

                static бул папка_ли (ткст имя);

                /***************************************************************

                        Этот файл нормальный ли?

                ***************************************************************/

                static бул файл_ли (ткст имя);

                /***************************************************************

                        Возвращает инфу о штампе времени.
                        Штампы времени возвращаются в формате, диктуемом 
                        файловой системой. Например, NTFS сохраняет UTC время, 
                        а штампы времени FAT  основаны на локальном времени.

                ***************************************************************/

                static Штампы штампыВремени (ткст имя);

                /***************************************************************

                        Установить для указанного файла штамп времени,
                        как он использовался, когда был изменён.

                ***************************************************************/

                static проц штампыВремени (ткст имя, Время использовался, Время изменён);

                /***************************************************************

                        Перенести содержимое другого файла в этот. 
                        При несработке выводит ВВИскл.

                ***************************************************************/

                static проц копируй (ткст ист, ткст приёмн);

                /***************************************************************

                        Удалить файл/папку из файловой системы.
                        Возвращает да при успехе, нет в противном случае.

                ***************************************************************/

                static бул удали (ткст имя);

                /***************************************************************

                       Изменить имя или положение файла/папки.

                ***************************************************************/

                static проц переименуй (ткст ист, ткст приёмн);

                /***************************************************************

                        Создать новый файл.

                ***************************************************************/

                static проц создайФайл (ткст имя);

                /***************************************************************

                        Создать новую папку.

                ***************************************************************/

                static проц создайПапку (ткст имя);

                /***************************************************************

                        Даёт список набора файлов из заданной папки.
                        Каждый путь и имяф передаётся в предоставленный
                        делегат, с префиксом пути и тем, является ли
                        эта Запись папкой.

                        Примечание: размещает небольшой буфер памяти.

                ***************************************************************/

                static цел список (ткст папка, цел delegate(ref ИнфОФайле) дг, бул все=нет);



}


/*******************************************************************************

        Parse a файл путь

        Файл пути containing non-ansi characters should be UTF-8 кодирован.
        Supporting Unicode in this manner was deemed в_ be ещё suitable
        than provопрing a шим version of ПутеПарсер, and is Всё consistent
        & compatible with the approach taken with the Уир class.

        Note that образцы of adjacent '.' разделители are treated specially
        in that they will be assigned в_ the имя where there is no distinct
        суффикс. In добавьition, a '.' at the старт of a имя signifies it does 
        not belong в_ the суффикс i.e. ".файл" is a имя rather than a суффикс.
        Образцы of intermediate '.' characters will иначе be assigned
        в_ the суффикс, such that "файл....суффикс" включает the dots within
        the суффикс itself. See метод расш() for a суффикс without dots.

        Note also that normalization of путь-разделители does *not* occur by 
        default. This means that usage of '\' characters should be explicitly
        преобразованый передhand преобр_в '/' instead (an исключение is thrown in those
        cases where '\' is present). On-the-fly conversion is avoопрed because
        (a) the предоставленный путь is consопрered immutable*and (b) we avoопр taking
        a копируй of the original путь. Module ФПуть есть_ли at a higher уровень, 
        without such contraints.

*******************************************************************************/

extern(D) struct ПутеПарсер
{       
        /***********************************************************************

                Parse the путь spec

        ***********************************************************************/

        ПутеПарсер разбор (ткст путь);

        /***********************************************************************

                Duplicate this путь

                Note: allocates память for the путь контент

        ***********************************************************************/

        ПутеПарсер dup ();

        /***********************************************************************

                Return the complete текст of this фпуть

        ***********************************************************************/

        ткст вТкст ();

        /***********************************************************************

                Return the корень of this путь. Roots are constructs such as
                "c:"

        ***********************************************************************/

        ткст корень ();

        /***********************************************************************

                Return the файл путь. Paths may старт and конец with a "/".
                The корень путь is "/" and an unspecified путь is returned as
                an пустой ткст. Directory пути may be разбей such that the
                дир имя is placed преобр_в the 'имя' member; дир
                пути are treated no differently than файл пути

        ***********************************************************************/

        ткст папка ();

        /***********************************************************************

                Возвращает путь representing the родитель of this one. This
                will typically return the current путь component, though
                with a special case where the имя component is пустой. In 
                such cases, the путь is scanned for a prior segment:
                ---
                нормаль:  /x/y/z => /x/y
                special: /x/y/  => /x
                нормаль:  /x     => /
                нормаль:  /      => [пустой]
                ---

                Note that this returns a путь suitable for splitting преобр_в
                путь and имя components (there's no trailing разделитель).

        ***********************************************************************/

        ткст родитель ();

        /***********************************************************************

                Pop the правейший element off this путь, strИПping off a
                trailing '/' as appropriate:
                ---
                /x/y/z => /x/y
                /x/y/  => /x/y  (note trailing '/' in the original)
                /x/y   => /x
                /x     => /
                /      => [пустой]
                ---

                Note that this returns a путь suitable for splitting преобр_в
                путь and имя components (there's no trailing разделитель).

        ***********************************************************************/

        ткст вынь ();

        /***********************************************************************

                Return the имя of this файл, либо дир.

        ***********************************************************************/

        ткст имя ();

        /***********************************************************************

                Ext is the хвост of the имяф, rightward of the правейший
                '.' разделитель e.g. путь "foo.bar" есть расш "bar". Note that
                образцы of adjacent разделители are treated specially - for
                example, ".." will wind up with no расш at все

        ***********************************************************************/

        ткст расш ();

        /***********************************************************************

                Suffix is like расш, but включает the разделитель e.g. путь
                "foo.bar" есть суффикс ".bar"

        ***********************************************************************/

        ткст суффикс ();

        /***********************************************************************

                return the корень + папка combination

        ***********************************************************************/

        ткст путь ();

        /***********************************************************************

                return the имя + суффикс combination

        ***********************************************************************/

        ткст файл ();

        /***********************************************************************

                Возвращает да, если this путь is *not* relative в_ the
                current working дир

        ***********************************************************************/

        бул абс_ли ();

        /***********************************************************************

                Возвращает да, если this ФПуть is пустой

        ***********************************************************************/

        бул пуст_ли ();

        /***********************************************************************

                Возвращает да, если this путь есть a родитель. Note that a
                родитель is defined by the presence of a путь-разделитель in
                the путь. This means 'foo' within "/foo" is consопрered a
                ветвь of the корень

        ***********************************************************************/

        бул ветвь_ли ();

        /***********************************************************************

                Does this путь equate в_ the given текст? We ignore trailing
                путь-разделители when testing equivalence

        ***********************************************************************/

        цел opEquals (ткст s);

        /***********************************************************************

                Parse the путь spec with explicit конец точка. A '\' is 
                consопрered illegal in the путь and should be normalized
                out перед this is invoked (the контент managed here is
                consопрered immutable, and thus cannot be изменён by this
                function)

        ***********************************************************************/

       // package ПутеПарсер разбор (ткст путь, т_мера конец);
}

extern(D):
/*******************************************************************************

        Does this путь currently exist?

*******************************************************************************/

 бул есть_ли (ткст имя);

/*******************************************************************************

        Возвращает the время of the последний modification. Accurate
        в_ whatever the F/S supports, and in a форматируй dictated
        by the файл-system. For example NTFS keeps UTC время, 
        while FAT timestamps are based on the local время. 

*******************************************************************************/

 Время изменён (ткст имя);

/*******************************************************************************

        Возвращает the время of the последний access. Accurate в_
        whatever the F/S supports, and in a форматируй dictated
        by the файл-system. For example NTFS keeps UTC время, 
        while FAT timestamps are based on the local время.

*******************************************************************************/

 Время использовался (ткст имя);

/*******************************************************************************

        Возвращает the время of файл creation. Accurate в_
        whatever the F/S supports, and in a форматируй dictated
        by the файл-system. For example NTFS keeps UTC время,  
        while FAT timestamps are based on the local время.

*******************************************************************************/

 Время создан (ткст имя);

/*******************************************************************************

        Return the файл length (in байты)

*******************************************************************************/

 бдол размерФайла (ткст имя);

/*******************************************************************************

        Is this файл записываемый?

*******************************************************************************/

 бул записываем_ли (ткст имя);

/*******************************************************************************

        Is this файл actually a папка/дир?

*******************************************************************************/

 бул папка_ли (ткст имя);

/*******************************************************************************

        Is this файл actually a нормаль файл?
        Not a дир or (on unix) a устройство файл or link.

*******************************************************************************/

 бул файл_ли (ткст имя);

/*******************************************************************************

        Return timestamp information

        Timestamps are returns in a форматируй dictated by the 
        файл-system. For example NTFS keeps UTC время, 
        while FAT timestamps are based on the local время

*******************************************************************************/

 ФС.Штампы штампыВремени (ткст имя);

/*******************************************************************************

        Набор the использовался and изменён timestamps указанного файл

        Since 0.99.9

*******************************************************************************/

 проц штампыВремени (ткст имя, Время использовался, Время изменён);

/*******************************************************************************

        Удали the файл/дир из_ the файл-system. Возвращает да, если
        successful, нет иначе

*******************************************************************************/

 бул удали (ткст имя);

/*******************************************************************************

        Удали the файлы and папки listed in the предоставленный пути. Where
        папки are listed, they should be preceded by their contained
        файлы in order в_ be successfully removed. Возвращает установи of пути
        that неудачно в_ be removed (where .length is zero upon success).

        The коллируй() function can be used в_ предоставляет the ввод пути:
        ---
        удали (коллируй (".", "*.d", да));
        ---

        Use with great caution

        Note: may размести память

        Since: 0.99.9

*******************************************************************************/

 ткст[] удали (ткст[] пути);

/*******************************************************************************

        Create a new файл

*******************************************************************************/

 проц создайФайл (ткст имя);

/*******************************************************************************

        Create a new дир

*******************************************************************************/

 проц создайПапку (ткст имя);

/*******************************************************************************

        Create an entire путь consisting of this папка along with
        все родитель папки. The путь should not contain '.' or '..'
        segments, which can be removed via the нормализуй() function.

        Note that each segment is создан as a папка, включая the
        trailing segment.

        Выводит исключение: ВВИскл upon system ошибки

        Выводит исключение: ИсклНелегальногоАргумента if a segment есть_ли but as a 
        файл instead of a папка

*******************************************************************************/

 проц создайПуть (ткст путь);

/*******************************************************************************

       change the имя or location of a файл/дир

*******************************************************************************/

 проц переименуй (ткст ист, ткст приёмн);

/*******************************************************************************

        Transfer the контент of one файл в_ другой. Выводит исключение 
        an ВВИскл upon failure.

*******************************************************************************/

 проц копируй (ткст ист, ткст приёмн);

/*******************************************************************************

        Provопрes foreach support via a fruct, as in
        ---
        foreach (инфо; ветви("myfolder"))
                 ...
        ---

        Each путь and имяф is passed в_ the foreach
        delegate, along with the путь префикс and whether
        the Запись is a папка or not. The инфо construct
        exposes the following атрибуты:
        ---
        ткст  путь
        ткст  имя
        бдол   байты
        бул    папка
        ---

        Аргумент 'все' controls whether скрытый and system 
        файлы are included - these are ignored by default

*******************************************************************************/

 ФС.Листинг ветви (ткст путь, бул все=нет);

/*******************************************************************************

        коллируй все файлы and папки из_ the given путь whose имя matches
        the given образец. Folders will be traversed where рекурсия is включен, 
        and a установи of совпадают names is returned as filepaths (включая those 
        папки which match the образец)

        Note: allocates память for returned пути

        Since: 0.99.9

*******************************************************************************/

 ткст[] коллируй (ткст путь, ткст образец, бул рекурсия=нет);

/*******************************************************************************

        Join a установи of путь specs together. A путь разделитель is
        potentially inserted between each of the segments.

        Note: may размести память

*******************************************************************************/

 ткст объедини (ткст[] пути...);

/*******************************************************************************

        Convert путь разделители в_ a стандарт форматируй, using '/' as
        the путь разделитель. This is compatible with Уир and все of 
        the contemporary O/S which Dinrus supports. Known exceptions
        include the Windows команда-строка процессор, which consопрers
        '/' characters в_ be switches instead. Use the исконный()
        метод в_ support that.

        Note: mutates the предоставленный путь.

*******************************************************************************/

 ткст стандарт (ткст путь);

/*******************************************************************************

        Convert в_ исконный O/S путь разделители where that is required,
        such as when dealing with the Windows команда-строка. 
        
        Note: mutates the предоставленный путь. Use this образец в_ obtain a 
        копируй instead: исконный(путь.dup);

*******************************************************************************/

 ткст исконный (ткст путь);

/*******************************************************************************

        Возвращает путь representing the родитель of this one, with a special 
        case concerning a trailing '/':
        ---
        нормаль:  /x/y/z => /x/y
        нормаль:  /x/y/  => /x/y
        special: /x/y/  => /x
        нормаль:  /x     => /
        нормаль:  /      => пустой
        ---

        The результат can be разбей via разбор()

*******************************************************************************/

 ткст родитель (ткст путь);

/*******************************************************************************

        Возвращает путь representing the родитель of this one:
        ---
        нормаль:  /x/y/z => /x/y
        нормаль:  /x/y/  => /x/y
        нормаль:  /x     => /
        нормаль:  /      => пустой
        ---

        The результат can be разбей via разбор()

*******************************************************************************/

 ткст вынь (ткст путь);

/*******************************************************************************

        Break a путь преобр_в "голова" and "хвост" components. For example: 
        ---
        "/a/b/c" -> "/a","b/c" 
        "a/b/c" -> "a","b/c" 
        ---

*******************************************************************************/

 ткст разбей (ткст путь, out ткст голова, out ткст хвост);

/*******************************************************************************

        Замени все путь 'из_' instances with 'в_', in place (overwrites
        the предоставленный путь)

*******************************************************************************/

 ткст замени (ткст путь, сим из_, сим в_);

/*******************************************************************************

        Parse a путь преобр_в its constituent components. 
        
        Note that the предоставленный путь is sliced, not duplicated

*******************************************************************************/

 ПутеПарсер разбор (ткст путь);


/******************************************************************************

        Matches a образец against a имяф.

        Some characters of образец have special a meaning (they are
        <i>meta-characters</i>) and <b>can't</b> be escaped. These are:
        <p><table>
        <tr><td><b>*</b></td>
        <td>Matches 0 or ещё instances of any character.</td></tr>
        <tr><td><b>?</b></td>
        <td>Matches exactly one instances of any character.</td></tr>
        <tr><td><b>[</b><i>симвы</i><b>]</b></td>
        <td>Matches one экземпляр of any character that appears
        between the brackets.</td></tr>
        <tr><td><b>[!</b><i>симвы</i><b>]</b></td>
        <td>Matches one экземпляр of any character that does not appear
        between the brackets после the exclamation метка.</td></tr>
        </table><p>
        Internally indivопрual character comparisons are готово calling
        charMatch(), so its rules apply here too. Note that путь
        разделители and dots don't stop a meta-character из_ совпадают
        further portions of the имяф.

        Возвращает: да, если образец matches имяф, нет иначе.

        Выводит исключение: Nothing.
        -----
        version (Win32)
                {
                совпадение("foo.bar", "*") // => да
                совпадение(r"foo/foo\bar", "f*b*r") // => да
                совпадение("foo.bar", "f?bar") // => нет
                совпадение("Goo.bar", "[fg]???bar") // => да
                совпадение(r"d:\foo\bar", "d*foo?bar") // => да
                }
        version (Posix)
                {
                совпадение("Go*.bar", "[fg]???bar") // => нет
                совпадение("/foo*home/bar", "?foo*bar") // => да
                совпадение("fСПДar", "foo?bar") // => да
                }
        -----
    
******************************************************************************/

 бул совпадение (ткст имяф, ткст образец);

/*******************************************************************************

        Normalizes a путь component
        ---
        . segments are removed
        <segment>/.. are removed
        ---

        MultИПle consecutive forward slashes are replaced with a single 
        forward slash. On Windows, \ will be преобразованый в_ / prior в_ any
        normalization.

        Note that any число of .. segments at the front is ignored,
        unless it is an абсолютный путь, in which case they are removed.

        The ввод путь is copied преобр_в either the предоставленный буфер, либо a куча
        allocated Массив if no буфер was предоставленный. Normalization modifies
        this копируй перед returning the relevant срез.
        -----
        нормализуй("/home/foo/./bar/../../john/doe"); // => "/home/john/doe"
        -----

        Note: allocates память

*******************************************************************************/

 ткст нормализуй (ткст путь, ткст буф = пусто);