/**
 * Этот модуль совместно используемой библиотеки предоставляет базовый слой
 * вокруг нативных функций, используемых для загрузки символов из
 * библиотек совместного использования (БСИ, DLL).
 *
 */

module sys.SharedLib;

private
{
import stringz:  изТкст0;

 version (Posix) { 
	import rt.core.stdc.posix.dlfcn; 
 } 
 version (Windows)
 {
    import exception, sys.WinConsts, sys.WinIfaces, sys.WinStructs, sys.WinFuncs;
	   import stringz, stdrus: вЮ8;
 }else  { 
	static assert (нет, "Для данной платформы не поддерживается");
 }
version (SharedLibVerbose) import util.log.Trace;
}

version (Posix)
{
    version (freebsd) { } else
    {
        pragma (lib, "dl");
    }
}


/**
    Длл - это интерфейс к системно специфичным совместно используемым библиотекам, таким
    как ".dll", ".so" или ".dylib" файлы. Он предоставляет простой интерфейс для получения
    адресов символов (таких как указатели на функции) из этих библиотек.

    Пример:
    ----

    проц main() {
        if (auto lib = Длл.загрузи(`c:\windows\system32\opengl32.dll`)) {
            След.форматнс("Библиотека успешно загружена");

            ук  ptr = lib.дайСимвол("glClear");
            if (ptr) {
                След.форматнс("Символ glClear найден. Адрес = 0x{:x}", ptr);
            } else {
                След.форматнс("Символ glClear не найден");
            }

            lib.выгрузи();
        } else {
            След.форматнс("Не удалось загрузить библиотеку");
        }

        assert (0 == Длл.члоЗагруженыхБибл);
    }

    ----

    Эта реализация использует подсчёт ссылок,поэтому библиотека не загружается
    повторно, если была загружена ранее и не выгружена пользователем.
    Выгрузка Длл уменьшает подсчёт ссылок. Когда он достигает 0,
    совместно используемая библиотека, ассоциированная с классом Длл, выгружается,
    а экземпляр Длл удаляется. Ручная выгрузка не требуется, с этим справляется
    метод выгрузи().

    Примечание:
    Длл - потоко-безопасный класс.
  */

export final class Длл
{



    /// Соответствует RTLD_NOW, RTLD_LAZY, RTLD_GLOBAL и RTLD_LOCAL
    enum ПРежимЗагрузки
    {
        Сейчас = 0b1,
        Отложенный = 0b10,
        Глобальный = 0b100,
        Локальный = 0b1000
    }


    /**
        Loads an OS-specific совместно используемый library.

        Note:
        Please use this function instead of the constructor, which is private.

        Параметры:
            путь = The путь в_ a совместно используемый library в_ be загружен
            режим = Library loading режим. See ПРежимЗагрузки

        Возвращает:
            A Длл экземпляр being a укз в_ the library, or throws
            ИсклДлл if it could not be загружен
      */
   export  static Длл загрузи(ткст путь, ПРежимЗагрузки режим = ПРежимЗагрузки.Сейчас | ПРежимЗагрузки.Глобальный)
    {
        return loadImpl(путь, режим, да);
    }



    /**
        Loads an OS-specific совместно используемый library.

        Note:
        Please use this function instead of the constructor, which is private.

        Параметры:
            путь = The путь в_ a совместно используемый library в_ be загружен
            режим = Library loading режим. See ПРежимЗагрузки

        Возвращает:
            A Длл экземпляр being a укз в_ the library, or пусто if it
            could not be загружен
      */
    export static Длл загрузиБезИскл(ткст путь, ПРежимЗагрузки режим = ПРежимЗагрузки.Сейчас | ПРежимЗагрузки.Глобальный)
    {
        return loadImpl(путь, режим, нет);
    }


    private static Длл loadImpl(ткст путь, ПРежимЗагрузки режим, бул выводИсключений)
    {
        Длл рез;

        synchronized (стопор)
        {
            auto lib = путь in загруженныеБибл;
            if (lib)
            {
                version (SharedLibVerbose) След.форматнс("Длл найдено in the hashmap");
                рез = *lib;
            }
            else
            {
                version (SharedLibVerbose) След.форматнс("Creating a new экземпляр of Длл");
                рез = new Длл(путь);
                загруженныеБибл[путь] = рез;
            }

            ++рез.refCnt;
        }

        бул delRes = нет;
        Исключение exc;

        synchronized (рез)
        {
            if (!рез.загружен)
            {
                version (SharedLibVerbose) След.форматнс("Loading the Длл");
                try
                {
                    рез.load_(режим, выводИсключений);
                }
                catch (Исключение e)
                {
                    exc = e;
                }
            }

            if (рез.загружен)
            {
                version (SharedLibVerbose) След.форматнс("Длл successfully загружен, returning");
                return рез;
            }
            else
            {
                synchronized (стопор)
                {
                    if (путь in загруженныеБибл)
                    {
                        version (SharedLibVerbose) След.форматнс("Removing the Длл из_ the hashmap");
                        загруженныеБибл.remove(путь);
                    }
                }
            }

            // сделай sure that only one нить will delete the объект
            if (0 == --рез.refCnt)
            {
                delRes = да;
            }
        }

        if (delRes)
        {
            version (SharedLibVerbose) След.форматнс("Deleting the Длл");
            delete рез;
        }

        if (exc !is пусто)
        {
            throw exc;
        }

        version (SharedLibVerbose) След.форматнс("Длл not загружен, returning пусто");
        return пусто;
    }


    /**
        Unloads the OS-specific совместно используемый library associated with this Длл экземпляр.

        Note:
        It's не_годится в_ use the объект after выгрузи() есть been called, as выгрузи()
        will delete it if it's not referenced any ещё.

        Throws ИсклДлл on failure. In this case, the Длл объект is not deleted.
      */
    export проц выгрузи()
    {
        return unloadImpl(да);
    }


    /**
        Unloads the OS-specific совместно используемый library associated with this Длл экземпляр.

        Note:
        It's не_годится в_ use the объект after выгрузи() есть been called, as выгрузи()
        will delete it if it's not referenced any ещё.
      */
    export проц выгрузиБезИскл()
    {
        return unloadImpl(нет);
    }


    private проц unloadImpl(бул выводИсключений)
    {
        бул deleteThis = нет;

        synchronized (this)
        {
            assert (загружен);
            assert (refCnt > 0);

            synchronized (стопор)
            {
                if (--refCnt <= 0)
                {
                    version (SharedLibVerbose) След.форматнс("Unloading the Длл");
                    try
                    {
                        unload_(выводИсключений);
                    }
                    catch (Исключение e)
                    {
                        ++refCnt;
                        throw e;
                    }

                    assert ((путь in загруженныеБибл) !is пусто);
                    загруженныеБибл.remove(путь);

                    deleteThis = да;
                }
            }
        }
        if (deleteThis)
        {
            version (SharedLibVerbose) След.форматнс("Deleting the Длл");
            delete this;
        }
    }


    /**
        Returns the путь в_ the OS-specific совместно используемый library associated with this объект.
      */
    export ткст путь()
    {
        return this.путь_;
    }


    /**
        Obtains the адрес of a symbol within the совместно используемый library

        Параметры:
            имя = The имя of the symbol; must be a пусто-terminated C ткст

        Возвращает:
            A pointer в_ the symbol or throws ИсклДлл if it's
            not present in the library.
      */
    export ук  дайСимвол(сим* имя)
    {
        return getSymbolImpl(имя, да);
    }


    /**
        Obtains the адрес of a symbol within the совместно используемый library

        Параметры:
            имя = The имя of the symbol; must be a пусто-terminated C ткст

        Возвращает:
            A pointer в_ the symbol or пусто if it's not present in the library.
      */
    export ук  дайСимволБезИскл(сим* имя)
    {
        return getSymbolImpl(имя, нет);
    }


    private ук  getSymbolImpl(сим* имя, бул выводИсключений)
    {
        assert (загружен);
        return дайСимвол_(имя, выводИсключений);
    }



    /**
        Returns the total число of libraries currently загружен by Длл
      */
    export static бцел члоЗагруженыхБибл()
    {
        return загруженныеБибл.keys.length;
    }


    private
    {
        version (Windows)
        {
            HMODULE укз;

            проц load_(ПРежимЗагрузки режим, бул выводИсключений)
            {
                version (Win32SansUnicode)
                укз = ЗагрузиБиблиотекуА((this.путь_ ~ \0).ptr);
                else
                {
                    шим[1024] врем =void;
                    auto i = МультиБайтВШирСим (ПКодСтр.УТФ8, cast(ПШирСим)0,
                    путь.ptr, путь.length,
                    врем.ptr, врем.length-1);
                    if (i > 0)
                    {
                        врем[i] = 0;
                        укз = ЗагрузиБиблиотеку (вЮ8(врем));
                    }
                }
                if (укз is пусто && выводИсключений)
                {
                    throw new ИсклДлл("Не удаётся загрузить динамическую библиотеку '" ~ this.путь_ ~ "' : " ~ СисОш.последнСооб);
                }
            }

            ук  дайСимвол_(сим* имя, бул выводИсключений)
            {
                // MSDN: "MultИПle threads do not overwrite each другой's последний-ошибка код."
                auto рез = ДайАдресПроц(укз, изТкст0(имя));
                if (рез is пусто && выводИсключений)
                {
                    throw new ИсклДлл("Не удалось загрузить символ '" ~ изТкст0(имя) ~ "' из динамической библиотеки '" ~ this.путь_ ~ "' : " ~ СисОш.последнСооб);
                }
                else
                {
                    return рез;
                }
            }

            проц unload_(бул выводИсключений)
            {
                if (0 == ОсвободиБиблиотеку(укз) && выводИсключений)
                {
                    throw new ИсклДлл("Не удалось выгрузить динамическую библиотеку '" ~ this.путь_ ~ "' : " ~ СисОш.последнСооб);
                }
            }
        }
        else version (Posix)
        {
            ук  укз;

            проц load_(ПРежимЗагрузки режим, бул выводИсключений)
            {
                цел mode_;
                if (режим & ПРежимЗагрузки.Сейчас) mode_ |= RTLD_NOW;
                if (режим & ПРежимЗагрузки.Отложенный) mode_ |= RTLD_LAZY;
                if (режим & ПРежимЗагрузки.Глобальный) mode_ |= RTLD_GLOBAL;
                if (режим & ПРежимЗагрузки.Локальный) mode_ |= RTLD_LOCAL;

                укз = dlopen((this.путь_ ~ \0).ptr, mode_);
                if (укз is пусто && выводИсключений)
                {
                    throw new ИсклДлл("Не удалось загрузить динамическую библиотеку: " ~ изТкст0(dlerror()));
                }
            }

            ук  дайСимвол_(сим* имя, бул выводИсключений)
            {
                if (выводИсключений)
                {
                    synchronized (typeof(this).classinfo)   // dlerror need not be reentrant
                    {
                        auto err = dlerror();               // сотри previous ошибка condition
                        auto рез = dlsym(укз, имя);     // результат of пусто does NOT indicate ошибка

                        err = dlerror();                    // check for ошибка condition
                        if (err !is пусто)
                        {
                            throw new ИсклДлл("Не удалось загрузить символ: " ~ изТкст0(err));
                        }
                        else
                        {
                            return рез;
                        }
                    }
                }
                else
                {
                    return dlsym(укз, имя);
                }
            }

            проц unload_(бул выводИсключений)
            {
                if (0 != dlclose(укз) && выводИсключений)
                {
                    throw new ИсклДлл("Не удалось выгрузить динамическую библиотеку: " ~ изТкст0(dlerror()));
                }
            }
        }
        else {
            static assert (нет, "Эта платформа не поддерживается");
        }


        ткст путь_;
        цел refCnt = 0;


        бул загружен()
        {
            return укз !is пусто;
        }


        this(ткст путь)
        {
            this.путь_ = путь.dup;
        }
    }


    private static
    {
        Длл[ткст] загруженныеБибл;
        Объект стопор;
    }


    export static this()
    {
        стопор = new Объект;
    }
}


export class ИсклДлл : Исключение
{


    export this (ткст сооб)
    {
        super(сооб);
    }
}




debug (Длл)
{
    проц main()
    {
        auto lib = new Длл("foo");
    }
}
