/*******************************************************************************
  copyright:   Copyright (c) 2006 Juan Jose Comellas. все rights reserved
  license:     BSD стиль: $(LICENSE)
  author:      Juan Jose Comellas <juanjo@comellas.com.ar>
*******************************************************************************/

module io.selector.PollSelector;

version (Posix)
{
    public import io.model;
    public import io.selector.model;

    private import io.selector.AbstractSelector;
    private import io.selector.SelectorException;
    private import sys.Common;
    private import cidrus;

    version (linux)
        private import sys.linux.linux;

    debug (selector)
        private import io.Stdout;


    /**
     * Селектор that uses the poll() system вызов в_ принять I/O события for
     * the registered conduits. To use this class you would normally do
     * something like this:
     *
     * Examples:
     * ---
     * import io.selector.PollSelector;
     *
     * Сокет сокет;
     * ИСелектор selector = new PollSelector();
     *
     * selector.открой(100, 10);
     *
     * // Register в_ читай из_ сокет
     * selector.регистрируй(сокет, Событие.Чит);
     *
     * цел eventCount = selector.выбери(0.1); // 0.1 сек
     * if (eventCount > 0)
     * {
     *     // We can сейчас читай из_ the сокет
     *     сокет.читай();
     * }
     * else if (eventCount == 0)
     * {
     *     // Timeout
     * }
     * else if (eventCount == -1)
     * {
     *     // другой нить called the wakeup() метод.
     * }
     * else
     * {
     *     // Ошибка: should never happen.
     * }
     *
     * selector.закрой();
     * ---
     */
    public class PollSelector: АбстрактныйСелектор
    {
        /**
         * Alias for the выбери() метод as we're not reimplementing it in
         * this class.
         */
        alias АбстрактныйСелектор.выбери выбери;

        /**
         * Default число of КлючВыбора's that will be handled by the
         * PollSelector.
         */
        public const бцел ДефРазмер = 64;

        /** Карта в_ associate the провод handles with their выделение ключи */
        private PollSelectionKey[ИВыбираемый.фукз] _keys;
        //private КлючВыбора[] _selectedKeys;
        private pollfd[] _pfds;
        private бцел _count = 0;
        private цел _eventCount = 0;

        /**
         * Открыть the poll()-based selector.
         *
         * Параметры:
         * размер         = maximum amount of conduits that will be registered;
         *                it will grow dynamically if needed.
         * maxEvents    = maximum amount of провод события that will be
         *                returned in the выделение установи per вызов в_ выбери();
         *                this значение is currently not использован by this selector.
         */
        public проц открой(бцел размер = ДефРазмер, бцел maxEvents = ДефРазмер);

        /**
         * Close the selector.
         *
         * Remarks:
         * It can be called multИПle times without harmful sопрe-effects.
         */
        public проц закрой();

        /**
         * Associate a провод в_ the selector и track specific I/O события.
         * If a провод is already associated, modify the события и
         * атачмент.
         *
         * Параметры:
         * провод      = провод that will be associated в_ the selector;
         *                must be a действителен провод (i.e. not пусто и открой).
         * события       = bit маска of Событие значения that represent the события
         *                that will be tracked for the провод.
         * атачмент   = optional объект with application-specific данные that
         *                will be available when an событие is triggered for the
         *                провод
         *
         * Throws:
         * ИсклРегистрируемогоПровода if the провод had already been
         * registered в_ the selector.
         *
         * Examples:
         * ---
         * selector.регистрируй(провод, Событие.Чит | Событие.Зап, объект);
         * ---
         */
        public проц регистрируй(ИВыбираемый провод, Событие события, Объект атачмент = пусто);

        /**
         * Удали a провод из_ the selector.
         *
         * Параметры:
         * провод      = провод that had been previously associated в_ the
         *                selector; it can be пусто.
         *
         * Remarks:
         * Unregistering a пусто провод is allowed и no исключение is thrown
         * if this happens.
         *
         * Throws:
         * ИсклОтменённогоПровода if the провод had not been previously
         * registered в_ the selector.
         */
        public проц отмениРег(ИВыбираемый провод);

        /**
         * Wait for I/O события из_ the registered conduits for a specified
         * amount of время.
         *
         * Параметры:
         * таймаут  = Timespan with the maximum amount of время that the
         *            selector will жди for события из_ the conduits; the
         *            amount of время is relative в_ the текущ system время
         *            (i.e. just the число of milliseconds that the selector
         *            имеется в_ жди for the события).
         *
         * Возвращает:
         * The amount of conduits that have Приёмd события; 0 if no conduits
         * have Приёмd события внутри the specified таймаут; и -1 if the
         * wakeup() метод имеется been called из_ другой нить.
         *
         * Throws:
         * ИсклПрерванногоСистВызова if the underlying system вызов was
         * interrupted by a signal и the 'перезапускПрерванногоСистВызова'
         * property was установи в_ нет; ИсклСелектора if there were no
         * resources available в_ жди for события из_ the conduits.
         */
        public цел выбери(ИнтервалВремени таймаут);

        /**
         * Return the выделение установи resulting из_ the вызов в_ any of the
         * выбери() methods.
         *
         * Remarks:
         * If the вызов в_ выбери() was unsuccessful or it dопр not return any
         * события, the returned значение will be пусто.
         */
        public ИНаборВыделений наборВыд();

        /**
         * Return the выделение ключ resulting из_ the registration of a
         * провод в_ the selector.
         *
         * Remarks:
         * If the провод is not registered в_ the selector the returned
         * значение will КлючВыбора.init. No исключение will be thrown by this
         * метод.
         */
        public КлючВыбора ключ(ИВыбираемый провод);
        
        /**
         * Return the число of ключи resulting из_ the registration of a провод
         * в_ the selector.
         */
        public т_мера счёт();

        /**
         * Iterate through the currently registered выделение ключи.  Note that
         * you should not erase or добавь any items из_ the selector while
         * iterating, although you can регистрируй existing conduits again.
         */
        public цел opApply(цел delegate(ref КлючВыбора sk) дг);
    }

    /**
     * Class использован в_ hold the список of Conduits that have Приёмd события.
     */
    private class PollSelectionSet: ИНаборВыделений
    {
        pollfd[] fds;
        цел numSelected;
        PollSelectionKey[ИВыбираемый.фукз] ключи;


        this(pollfd[] fds, цел numSelected, PollSelectionKey[ИВыбираемый.фукз] ключи);

        бцел length();

        /**
         * Iterate over все the Conduits that have Приёмd события.
         */
        цел opApply(цел delegate(ref КлючВыбора) дг);
    }

    /**
     * Class that holds the information that the PollSelector needs в_ deal
     * with each registered Провод.
     */
    private class PollSelectionKey
    {
        КлючВыбора ключ;
        бцел индекс;

        public this();

        public this(ИВыбираемый провод, Событие события, бцел индекс, Объект атачмент);
    }
}

