﻿module io.selector.AbstractSelector;

public import io.model, time.Time;
public import io.selector.SelectorException;

private import io.selector.model;
private import sys.common;
private import cidrus;
private import exception;


/**
 * Базовый класс для всех селекторов.
 *
 * Селектор - это мультиплексор для событий ввода-вывода, ассоциированный с Проводом.
 * Все селекоры должны реадизовывать этот интерфейс.
 *
 * Селектор нужно инициализировать вызовом метода открой(), чтобы сообщить
 * начальное количество проводов, на которые он будет указывать, и максимальное
 * количество событий, которое будет возвращено при каждом вызове выбери().
 * В любом случае эти значени - только рекомендации;они могут даже не использоваться
 * в определённых реализациях ИСелектор, поэтому трудно предсказать результат
 * вызова метода выбери() (то есть может быть больше или меньше событий,
 * нежели вами указано в аргументе 'максСобытий'. Количество проводов, с которыми
 * может иметь дело селектор, при необходимости будет динамически увеличено.
 *
 * Для добавления или изменения регистрации проводов в селекторе, используется
 * метод регистрируй(). Для удаления регистрации проводов из селектора,- метод
 * отмениРег().
 *
 * Для ожидания событий от проводов нужно вызвать любой из методов выбери().
 * Селектор не может быть изменён из другой нити (потока), пока он блокирован
 * вызовами этих методов.
 *
 * Когда селектор больше не используется требуется вызвать метод закрой(), чтобы
 * селектор смог освободить ресурсы, размещённые им в памяти при вызове открой().
 *
 * См_Также: ИСелектор
 *
 * Примеры:
 * ---
 * import io.selector.model;
 * import net.device.Socket;
 * import io.Stdout;
 *
 * АбстрактныйСелектор селектор;
 * СокетПровод провод1;
 * СокетПровод провод2;
 * МойКласс объект1;
 * МойКласс объект2;
 * бцел счётСобытий;
 *
 * // Инициализируем селектор, предполагая его работу с двумя проводами
 * // и приём им двух событий на каждый вызов метода выбери().
 * селектор.открой(2, 2);
 *
 * селектор.регистрируй(провод, Событие.Чит, объект1);
 * селектор.регистрируй(провод, Событие.Зап, объект2);
 *
 * счётСобытий = селектор.выбери();
 *
 * if (счётСобытий > 0)
 * {
 *     сим[16] буфер;
 *     цел счёт;
 *
 *     foreach (КлючВыбора ключ, селектор.наборВыд())
 *     {
 *         if (ключ.читаем_ли())
 *         {
 *             счёт = (cast(СокетПровод) ключ.провод).читай(буфер);
 *             if (счёт != ИПровод.Кф)
 *             {
 *                 Стдвыв.форматируй("Принято '{0}' из пира\n", буфер[0..счёт]);
 *                 селектор.регистрируй(ключ.провод, Событие.Зап, ключ.атачмент);
 *             }
 *             else
 *             {
 *                 селектор.отмениРег(ключ.провод);
 *                 ключ.провод.закрой();
 *             }
 *         }
 *
 *         if (ключ.записываем_ли())
 *         {
 *             счёт = (cast(СокетПровод) ключ.провод).пиши("СООБЩЕНИЕ");
 *             if (счёт != ИПровод.Кф)
 *             {
 *                 Стдвыв("'СООБЩЕНИЕ' отправлено в пир\n");
 *                 селектор.регистрируй(ключ.провод, Событие.Чит, ключ.атачмент);
 *             }
 *             else
 *             {
 *                 селектор.отмениРег(ключ.провод);
 *                 ключ.провод.закрой();
 *             }
 *         }
 *
 *         if (ключ.ошибка_ли() || ключ.зависание_ли() || ключ.невернУк_ли())
 *         {
 *             селектор.отмениРег(ключ.провод);
 *             ключ.провод.закрой();
 *         }
 *     }
 * }
 *
 * селектор.закрой();
 * ---
 */

export abstract class АбстрактныйСелектор: ИСелектор
{
export:
    /**
     * Перезапустить прерванный системный вызов(-ы)
     * при блокировке внутри вызова выбери.
     */
    protected бул перезапуститьПрерванныйСистемныйВызов = да;

    /**
     * Указывает, будут ли перезапущены прерванные системные вызовы
     * при блокировке внутри вызова метода выбери.
     */
    public бул перезапускПрерванногоСистВызова()
    {
        return перезапуститьПрерванныйСистемныйВызов;
    }

    /**
     * Устанавливает, будут ли перезапущены прерванные системные вызовы
     * при блокировке внутри вызова метода выбери.
     */
    public проц перезапускПрерванногоСистВызова(бул значение)
    {
        перезапуститьПрерванныйСистемныйВызов = значение;
    }

    /**
     * Инициализирует селектор.
     *
     * Параметры:
     * размер         = значение, рекомендующее максимальное число 
     *                регестрируемых проводов.
     * максСобытий    = значение, рекомендующее максимальное число событий
     *                провода, возвращаемое в наборе селекции
     *                на каждый вызов метода выбери.
     */
    public abstract проц открой(бцел размер, бцел максСобытий);

    /**
     * Освободить ресурсы операционной системы, которые могли быть размещены в
     * впамяти при вызове метода открой().
     *
     * Примечания:
     * Требуется освобождение памяти только тех ресурсов, которые размещены там селектором.
     * Не все селекторы это делают. В их деструкторе обычно присутствует метод закрой().
     */
    public abstract проц закрой();

    /**
     * Ассоциировать провод с селектором и отслеживать события ввода-вывода.
     *
     * Параметры:
     * провод      = провод, ассоциируемый с селектором.
     * события       = бит-маска значения События, представляющая события,
     *                которые будут отслеживаться на этом проводе.
     * атачмент   = необязательный объект со специфицными для приложения данными,
     *                которые будут доступны при тригерировании события для этого провода.
     *
     * Примеры:
     * ---
     * АбстрактныйСелектор селектор;
     * СокетПровод провод;
     * МойКласс объект;
     *
     * селектор.регистрируй(провод, Событие.Чит | Событие.Зап, объект);
     * ---
     */
    public abstract проц регистрируй(ИВыбираемый провод, Событие события,
            Объект атачмент);

    /**
     * Удаляет провод из селектора.
     *
     * Параметры:
     * провод      = провод, ранее ассоциированный с селектором; может быть равен пусто.
     *
     * Примечания:
     * Отрегистрирование провода со значением пусто допустимо, и  исключение не выводится.
     */
    public abstract проц отмениРег(ИВыбираемый провод);

    /**
     * Ожидает события ввода-вывода на зарегистрированном проводе указанное
     * количество времени.
     *
     * Возвращает:
     * Число проводов с принятыми событиями;0, если ни один провод не принял
     * событий за заданный таймаут; и -1, если из другой нити был вызван
	 * метод неСпи().
     *
     * Примечания:
     * Этот метод аналогичен методу выбери(ИнтервалВремени.макс).
     */
    public цел выбери()
    {
        ИнтервалВремени инт;
        return выбери(инт.макс);
    }

    /**
     * Ожидает события ввода-вывода на зарегистрированном проводе указанное
     * количество времени.
     *
     * Примечание: Это представление таймаута не всегда точно, поэтому возможен
     * возврат из функции с таймаутом менее указанного периода.
     * Для большей точности используйте версию с ИнтервалВремени.
     *
     * Параметры:
     * таймаут  = Максимальное количество времени в сек, которое селектор
     *            будет ждать событий на проводах; количество времени
     *            относительно к текущему системному времени
     *            (т.е. число миллисекунд, которое селектор ждёт события).
     *
     * Возвращает:
     * Число проводов с принятыми событиями; 0, если ни один провод не принял
     * событий за заданный таймаут.
     */
    public цел выбери(дво таймаут)
    {
        return выбери(ИнтервалВремени.изИнтервала(таймаут));
    }

    /**
     * Ожидает события ввода-вывода на зарегистрированном проводе указанное
     * количество времени.
     *
     * Параметры:
     * таймаут  = ИнтервалВремени с максимальным количеством времени, которое
     *            сэтот електор будет ожидать событий из проводов; количество
     *            времени относительно текущего системного времени
     *            (т.е. число миллисекунд, которое селектор ждёт события).
     *
     * Возвращает:
     * Число проводов с принятыми событиями; 0, если ни один провод не принял
     * событий за заданный таймаут; и -1, если метод неСпи() был вызван
	 * из другой нити (потока).
     */
    public abstract цел выбери(ИнтервалВремени таймаут);

    /**
     * Возвращает результирующий набор селекций из вызова любого метода выбери().
     *
     * Примечания:
     * Если вызов выбери() прошёл неудачно или не вернул ни одного события,
     * возвращённое значение будет пусто.
     */
    public abstract ИНаборВыделений наборВыд();

    /**
     * Возвращает ключ результирующей селекции из регистрации провода
     * в селекторе.
     *
     * Примечания:
     * Если провод не зарегистрирован в селекторе, возвращённое
     * значение будет пусто. Никаких исключений не выводится.
     */
    public abstract КлючВыбора ключ(ИВыбираемый провод);

    /**
     * Возвращает результирующее число ключей из регистрации провода в селекторе.
     */
    public abstract т_мера счёт();

    /**
     * Представляет продолжительность времени в виде Си-структуры значврем.
    */
    public значврем* вЗначВрем(значврем* tv, ИнтервалВремени интервал)
    in
    {
        assert(tv !is пусто);
    }
    body
    {
        tv.сек = cast(typeof(tv.сек)) интервал.сек;
        tv.микросек = cast(typeof(tv.микросек)) (интервал.микросек % 1_000_000);
        return tv;
    }

    /**
     * Проверяет глобальную переменную 'errno' из стандартной библиотеки Си,
     * при выводе исключения, с описанием ошибки.
     *
     * Параметры:
     * файл     = имя исходного файла, где выполнена проверка; обычно
     *            нужно использовать константу __FILE__ для этого параметра.
     * строка     = номер строки исходного файла, где был вызван этот метод;
     *            обычно нужно использовать константу __LINE__ для этого параметра.
     *
     * Выводит:
     * ИсклРегистрируемогоПровода, когда провод не следовало регистрировать, но
     * это случилось (EEXIST); ИсклОтменённогоПровода, когда нужно было регистрировать провод,
     * но этого не случилось (ENOENT);
     * ИсклПрерванногоСистВызова, когда был прерван системный вызов
     * (EINTR); ВнеПамИскл, если не удалось размешение в памяти (ENOMEM);
     * ИсклСелектора, для любых иных случаев, когда errno не равно 0.
     */
    проц проверьНомОш(ткст файл, т_мера строка)
    {
        цел кодОшибки = дайНомош;
        switch (кодОшибки)
        {
        case ОШНЕВФАЙЛ:
            throw new ИсклСелектора("Неверный дескриптор файла", файл, строка);        
        case ОШФЕСТЬ:
            throw new ИсклРегистрируемогоПровода(файл, строка);        
        case ОШПРЕРВ:
            throw new ИсклПрерванногоСистВызова(файл, строка);        
        case ОШИНВАЛАРГ:
            throw new ИсклСелектора("К системе произошло обращение с неверным параметром", файл, строка);   
        case ОШПЕРЕПФТ:
            throw new ИсклСелектора("Достигнуто максимальное количество открытых файлов", файл, строка);     
        case ОШНЕСУЩ:
            throw new ИсклОтменённогоПровода(файл, строка);        
        case ОШНЕТПАМ:
            throw new io.selector.SelectorException.ВнеПамИскл(файл, строка);        
        case ОШНЕДОП:
            throw new ИсклСелектора("Этот провод нельзя использовать с данным Селектором", файл, строка);   
        default:
            throw new ИсклСелектора("Неизвестная ошибка Селектора: " ~ СисОш.найди(кодОшибки), файл, строка);
            
        }
    }
}
