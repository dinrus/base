/******************************************************************************
 *
 * copyright:   Copyright &копируй; 2007 Daniel Keep.  Все права защищены.
 * license:     BSD стиль: $(LICENSE)
 * version:     Dec 2007: Initial release
 *              May 2009: Inherit Файл
 * authors:     Daniel Keep
 * credits:     Thanks в_ John Reimer for helping тест this module under
 *              Linux.
 *
 ******************************************************************************/

module io.device.TempFile;

import Путь = io.Path;
import math.random.Kiss : Kiss;
import io.device.Device : Устройство;
import io.device.File;
import exception, stringz : вТкст0;

/******************************************************************************
 ******************************************************************************/

version( Win32 )
{
    import sys.common;

    enum : DWORD { FILE_FLAG_OPEN_REPARSE_POINT = 0x00200000 }

          alias sys.WinStructs.ИНФОВЕРСИИОС  ИнфОВерсииОС;

        ткст дайВрмПуть()
        {
            auto длин = sys.WinFuncs.ДайВремПуть(0, пусто);
            if( длин == 0 )
                throw new Исключение("не удалось получить временный путь");

            auto результат = new шим[длин+1];
            длин = ДайВремПуть(длин+1, результат.ptr);
            if( длин == 0 )
                throw new Исключение("не удалось получить временный путь");

            auto пап = new сим [длин * 3];
           
            auto i = sys.WinFuncs.ШирСимВМультиБайт (ПКодСтр.УТФ8, cast(ПШирСим) 0, результат.ptr, длин, 
                                          cast(PCHAR) пап.ptr, пап.length, пусто, 0);
            return Путь.стандарт (пап[0..i]);
        }
    
    // Determines if reparse points (aka: symlinks) are supported.  Support
    // was introduced in Windows Vista.
    бул reparseSupported()
    {
        ИнфОВерсииОС инфоверииОС =void;
        инфоверииОС.размИнфОВерсииОс = инфоверииОС.sizeof;

        проц e(){throw new Исключение("не удалось определить версию Windows");};

            if( !sys.WinFuncs.ДайВерсиюДоп(&инфоверииОС) ) e();
        

        return (инфоверииОС.версияМажор >= 6);
    }
}

else version( Posix )
{
    import rt.core.stdc.posix.pwd : getpwnam;
    import rt.core.stdc.posix.unistd : доступ, getuопр, lseek, отвяжи, W_OK;
    import rt.core.stdc.posix.sys.types : off_t;
    import rt.core.stdc.posix.sys.stat : stat, stat_t;
    import sys.consts.fcntl : O_NOFOLLOW;
    import rt.core.stdc.posix.stdlib : getenv;
    import cidrus : strlen;
}

export class ВремФайл : Файл
{

    enum ОпцУдаления : ббайт
    {
        /**
         * The temporary файл should be destroyed along with the хозяин объект.
         */
        ВКорзину,
        /**
         * The temporary файл should persist after the объект есть been
         * destroyed.
         */
        Навсегда
    }

    /**************************************************************************
     * 
     * This structure is used в_ determine как the temporary файлы should be
     * opened and used.
     *
     **************************************************************************/
    align(1) struct СтильВремфл
    {
        //Visibility visibility;      ///
        ОпцУдаления удаление;        ///
        //Sensitivity sensitivity;    ///
        //Общ совместно;                ///
        //Кэш кэш;                ///
        ббайт попытки = 10;          ///
    }

    /**
     * СтильВремфл for creating a transient temporary файл that only the текущ
     * пользователь can доступ.
     */
    static const СтильВремфл ВКорзину = {ОпцУдаления.ВКорзину};
    /**
     * СтильВремфл for creating a permanent temporary файл that only the текущ
     * пользователь can доступ.
     */
    static const СтильВремфл Навсегда = {ОпцУдаления.Навсегда};

    // Путь в_ the temporary файл
    private ткст _path;

    // СтильВремфл we've opened with
    private СтильВремфл _style;


    ///
    export this(СтильВремфл стиль = СтильВремфл.init)
    {
        открой (стиль);
    }

    ///
    export this(ткст префикс, СтильВремфл стиль = СтильВремфл.init)
    {
        открой (префикс, стиль);
    }

    /**************************************************************************
     *
     * Указывает the стиль that this ВремФайл was создан with.
     *
     **************************************************************************/
    export СтильВремфл стильВремфл()
    {
        return _style;
    }

    /*
     * Creates a new temporary файл with the given стиль.
     */
    private проц открой (СтильВремфл стиль)
    {
        открой (времфлПуть, стиль);
    }

    private проц открой (ткст префикс, СтильВремфл стиль)
    {
        for( ббайт i=стиль.попытки; i--; )
        {
            if( окройВремфл(Путь.объедини(префикс, randomName), стиль) )
                return;
        }

        throw new ВВИскл("не удалось создать временный файл");
    }

    version( Win32 )
    {
        private static const ДефДЛИНА = 6;
        private static const ДефПРЕФИКС = "~t";
        private static const ДефСУФФИКС = ".temp";

        private static const JUNK_CHARS = 
            "abcdefghijklmnopqrstuvwxyz0123456789";

       /**********************************************************************
         * 
         * Возвращает the путь в_ the дир where temporary файлы will be
         * создан.  The returned путь is safe в_ измени.
         *
         **********************************************************************/
        export static ткст времфлПуть()
        {
            return дайВрмПуть;
        }

        /*
         * Creates a new temporary файл at the given путь, with the specified
         * стиль.
         */
        private бул окройВремфл(ткст путь, СтильВремфл стиль)
        {
            // TODO: Check permissions directly and throw an исключение;
            // иначе, we could spin trying в_ сделай a файл when it's
            // actually not possible.

            Стиль filestyle = {Доступ.ЧитЗап, Откр.Нов, 
                               Общ.Нет, Кэш.Нет};

            DWORD атр;

            // Набор up флаги
            атр = reparseSupported ? FILE_FLAG_OPEN_REPARSE_POINT : 0;
            if( стиль.удаление == ОпцУдаления.ВКорзину )
                атр |= ПФайл.УдалитьПриЗакрытии;

            if (!super.открой (путь, filestyle, атр))
                return нет;

            _style = стиль;
            return да;
        }
    }
    else version( Posix )
    {
        private static const ДефДЛИНА = 6;
        private static const ДефПРЕФИКС = ".temp";

        // Use "~" в_ work around a bug in DMD where it elопрes пустой constants
        private static const ДефСУФФИКС = "~";

        private static const JUNK_CHARS = 
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            "abcdefghijklmnopqrstuvwxyz0123456789";

       /**********************************************************************
         * 
         * Возвращает the путь в_ the дир where temporary файлы will be
         * создан.  The returned путь is safe в_ измени.
         *
         **********************************************************************/
        public static ткст времфлПуть()
        {
            // Check for TMPDIR; failing that, use /врем
            сим* ptr = getenv ("TMPDIR");
            if (ptr is пусто)
                return "/врем/";
            else 
                return ptr[0 .. strlen (ptr)].dup;
        }

        /*
         * Creates a new temporary файл at the given путь, with the specified
         * стиль.
         */
        private бул окройВремфл(ткст путь, СтильВремфл стиль)
        {
            // Check suitability
            {
                auto parentz = вТкст0(Путь.разбор(путь).путь);

                // Make sure we have пиши доступ
                if( доступ(parentz, W_OK) == -1 )
                    ошибка("нет доступа к временной папке");

                // Get инфо on дир
                stat_t sb;
                if( stat(parentz, &sb) == -1 )
                    ошибка("статистика временной папки недоступна");

                // Get корень's UID
                auto pwe = getpwnam("корень");
                if( pwe is пусто ) ошибка("не удалось получить Уид корня");
                auto root_uопр = pwe.pw_uопр;
                
                // Make sure either we or корень are the хозяин
                if( !(sb.st_uопр == root_uопр || sb.st_uопр == getuопр) )
                    ошибка("временная папка не принадлежит ни root и ни пользователь");

                // Check в_ see if anyone другой than us can пиши в_ the Пап.
                if( (sb.st_mode & 022) != 0 && (sb.st_mode & 01000) == 0 )
                    ошибка("не установлен бит-наклейка (sticky bit) на папку для общей записи");
            }

            // Созд файл
            {
                Стиль filestyle = {Доступ.ЧитЗап, Откр.Нов, 
                                   Общ.Нет, Кэш.Нет};

                auto добфлаги = O_NOFOLLOW;

                if (!super.открой(путь, filestyle, добфлаги, 0600))
                    return нет;

                if( стиль.удаление == ОпцУдаления.ВКорзину )
                {
                    // BUG TODO: check в_ сделай sure the путь still points
                    // в_ the файл we opened.  Pity you can't отвяжи a файл
                    // descrИПtor...

                    // NOTE: This should be an исключение and not simply
                    // returning нет, since this is a violation of our
                    // guarantees.
                    if( отвяжи(вТкст0(путь)) == -1 )
                        ошибка("не удаётся удалить транзитивный файл");
                }

                _style = стиль;

                return да;
            }
        }
    }
    else
    {
        static assert(нет, "Не поддерживаемая платформа");
    }

    /*
     * Generates a new random файл имя, sans дир.
     */
    private ткст randomName(бцел length=ДефДЛИНА,
            ткст префикс=ДефПРЕФИКС,
            ткст суффикс=ДефСУФФИКС)
    {
        auto junk = new сим[length];
        scope(exit) delete junk;

        foreach( ref c ; junk )
            c = JUNK_CHARS[Kiss.экземпляр.вЦел($)];

        return префикс~junk~суффикс;
    }
    
    export override проц открепи()
    {
        static assert( !is(Sensitivity) );
        super.открепи();
    }
}