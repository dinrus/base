module io.device.ThreadPipe;

private import io.device.Conduit;

class ПайпНить : Провод
{
    /**
     * Создаёт новый ПайпНить с заданным размером буфера.
     *
     * Парамы:
     * размерБуфера = Размер выделяемой под буфер памяти.
     */
    this(т_мера размерБуфера=(1024*16));

    /**
     * Реализует IConduit.размерБуфера.
     *
     * Возвращает соответствующего размера буфер, который следует
     * использовать для буферирования ПайпНити. 
     * Заметьте, что это просто передаваемый размер буфера, и
     * поскольку все данные ПайпНить находятся в памяти,
     * буферирование не имеет никакого смысла.
     */
    т_мера размерБуфера();

    /**
     * Реализует IConduit.вТкст
     *
     * Возвращает "&lt;thread conduit&gt;"
     */
    ткст вТкст();

    /**
     * Возвращает да, если ещё есть данные для чтения,
     * и конец записи не закрыт.
     */
    override бул жив_ли();

    /**
     * Return the число of байты остаток to be читай in the circular buffer.
     */
    т_мера остаток();

    /**
     * Return the число of байты that can be written to the circular buffer.
     */
    т_мера записываемо();

    /**
     * Close the пиши end of the conduit.  Writing to the conduit после it is
     * закрыт will return Кф.
     *
     * The читай end is not закрыт until the buffer is empty.
     */
    проц стоп();

    /**
     * This does nothing because we have no clue whether the members have been
     * собериed, и открепи is run in the destructor.  To стоп communications,
     * use стоп().
     *
     * TODO: move стоп() functionality to открепи when it becomes possible to
     * have fully-owned members
     */
    проц открепи();

    /**
     * Реализует ИПотокВвода.читай.
     *
     * Чит from the conduit преобр_в a target массив.  The предоставленный приёмник will be
     * populated with контент from the Поток.
     *
     * Возвращает the число of байты читай, which may be less than requested in
     * приёмник. Кф is returned whenever an end-of-flow condition arises.
     */
    т_мера читай(проц[] приёмник);

    /**
     * Реализует ИПотокВвода.очисть().
     *
     * Clear any buffered контент.
     */
    ПайпНить очисть();

    /**
     * Реализует OutputПоток.пиши.
     *
     * Зап to Поток from a исток массив. The предоставленный src контент will be
     * written to the Поток.
     *
     * Возвращает the число of байты written from src, which may be less than
     * the quantity предоставленный. Кф is returned when an end-of-flow condition
     * arises.
     */
    т_мера пиши(проц[] src);
}