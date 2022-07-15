﻿/**
 * Этот модуль совместно используемой библиотеки предоставляет базовый слой
 * вокруг нативных функций, используемых для загрузки символов из
 * библиотек совместного использования (БСИ, DLL).
 *
 */

module sys.SharedLib;


/**
    Длл - это интерфейс к системоспецифичным БСИ, таким
    как ".dll", ".so" или ".dylib" файлы. Он предоставляет простой интерфейс для получения
    адресов символов (таких как указатели на функции) из этих библиотек.

    Пример:
    ----

    проц main() {
        if (auto биб = Длл.загрузи(`c:\windows\system32\opengl32.dll`)) {
            След.форматнс("Библиотека успешно загружена");

            ук  укз = биб.дайСимвол("glClear");
            if (укз) {
                След.форматнс("Символ glClear найден. Адрес = 0x{:x}", ptr);
            } else {
                След.форматнс("Символ glClear не найден");
            }

            биб.выгрузи();
        } else {
            След.форматнс("Не удалось загрузить библиотеку");
        }

        assert (0 == Длл.члоЗагруженыхБибл);
    }

    ----

    Эта реализация использует подсчёт ссылок,поэтому библиотека не загружается
    повторно, если была загружена ранее и не выгружена пользователем.
    Выгрузка Длл уменьшает подсчёт ссылок. Когда он достигает 0,
    БСИ, ассоциированная с классом Длл, выгружается,
    а экземпляр Длл удаляется. Ручная выгрузка не требуется, с этим справляется
    метод выгрузи().

    Примечание:
    Длл - потоко-безопасный класс.
  */

extern(D) final class Длл
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
        Загружает OS-специфичную БСИ.

        Заметка:
        Пожалуйста, используйте эту функцию вместо конструктора, который приватен.

        Параметры:
            путь = Путь к загружаемой БСИ
            режим = Режим загрузки библиотеки. См. ПРежимЗагрузки

        Возвращает:
            Экземпляр Длл, являющийся указателем на библиотеку, либо выводит
            ИсклДлл, если её не удаётся загрузить.
      */
     static Длл загрузи(ткст путь, ПРежимЗагрузки режим = ПРежимЗагрузки.Сейчас | ПРежимЗагрузки.Глобальный);



    /**
        Загружает OS-специфичную БСИ.

        Заметка:
        Пожалуйста, используйте эту функцию вместо конструктора, который приватен.

        Параметры:
            путь = Путь к загружаемой БСИ
            режим = Режим загрузки библиотеки. См. ПРежимЗагрузки

        Возвращает:
            Экземпляр Длл, являющийся указателем на библиотеку, либо выводит
            ИсклДлл, если её не удаётся загрузить.
      */
    static Длл загрузиБезИскл(ткст путь, ПРежимЗагрузки режим = ПРежимЗагрузки.Сейчас | ПРежимЗагрузки.Глобальный);

    /**
        Выгружает ОС-специфичную БСИ, ассоциированную с этим экземпляром.

        Заметка:
        Этот объект нельзя использовать после вызова выгрузи(), так как выгрузи()
        удалит его, если он нигде ещё не имееет на себя ссылок.

        Выводит ИсклДлл при неуспехе. В этом случае объект Длл не уничтожается.
      */
     проц выгрузи();


    /**
        Выгружает ОС-специфичную БСИ, ассоциированную с этим экземпляром.

        Заметка:
        Этот объект нельзя использовать после вызова выгрузи(), так как выгрузи()
        удалит его, если он нигде ещё не имееет на себя ссылок.
      */
     проц выгрузиБезИскл();

    /**
        Возвращает путь к ОС-специфичной БСИ, ассоциированной с этим объектом.
      */
     ткст путь();


    /**
        Получает адрес символа в БСИ

        Параметры:
            имя = Имя символа; должна быть ткст с нулевым окончанием

        Возвращает:
            Указатель на символ или выбрасывает ИсклДлл, если его
            нет в этой БСИ.
      */
     ук  дайСимвол(сим* имя);


    /**
        Получает адрес символа в БСИ

        Параметры:
            имя = Имя символа; должна быть ткст с нулевым окончанием

        Возвращает:
            Указатель на символ или пусто, если его
            нет в этой БСИ.
      */
     ук  дайСимволБезИскл(сим* имя);

    /**
        Возвращает общее число на данный момент зашруженных БСИ.
      */
     static бцел члоЗагруженыхБибл();



    static this();
}


extern(D) class ИсклДлл : Исключение
{


    this (ткст сооб);
}




debug (Длл)
{
    проц main()
    {
        auto биб = new Длл("foo");
    }
}