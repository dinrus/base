﻿module col.DefaultAllocator;
        private import cidrus;
		
/+ ИНТЕРФЕЙС:

  struct БлокРазместитель(З, бцел элтовНаБлок)
    {
        const бул нужноСвоб = да;
        struct элемент
        {
            элемент *следщ;
        }
        struct блок
        {
            блок *следщ;
            блок *предш;
            элемент *списокОсвобождения;
            бцел члоОсвоб;
            З[элтовНаБлок] элты;
            З *разместиИзОсвоб();
            бул вымести(З *з);
        }

        блок *используется;
        блок *свеж;
        бцел следщСвеж;

        З* размести();
        проц освободи(З* з);
        проц освободиВсе();
    }

struct ПростойРазместитель(З)
{
    const бул нужноСвоб = нет;

    З* размести();
}

template ДефолтныйРазместитель(З);
+/
//==========================================================


    /**
     * Размещает блок элементов за раз, затем использует его для возврата
     * элементов. Это делает более эффективным размещение индивидуальных элементов,
     * так как СМ не используется для размещения каждого элемента, а лишь для
     * каждого блока элементов.
     *
     * Единственное требование: размер З >= размер указателя.
     * Поскольку данные, которые содержит З, используются как указатель
     * при освобождении элемента.
     *
     * Если освобождается весь блок элементов, этот блок затем возвращается
     * сборщику мусора СМ.
     */
    struct БлокРазместитель(З, бцел элтовНаБлок)
    {
        /**
         * Требуется освобождение для рециклирования узлов для другого размещения.
         */
        const бул нужноСвоб = да;
        static if(З.sizeof < (ук).sizeof)
        {
            static assert(нет, "Ошибка, Разместитель для " ~ З.stringof ~ " не инстанциирован");
        }

        /**
         * Эта форма используется для линковки рециклируемых элементов вместе.
         */
        struct элемент
        {
            элемент *следщ;
        }

        /**
         * Блок элементов.
         */
        struct блок
        {
            /**
             * Следующий блок в цепи.
             */
            блок *следщ;

            /**
             * Предыдущий блок в цепи.  Требуется для O(1) удаления
             * из цепи.
             */
            блок *предш;

            /**
             * Линкованный список освобождаемых элементов в блоке. Этот список
             * меняется при каждом удалении элемента в блоке.
             */
            элемент *списокОсвобождения;

            /**
             * Число освобождаемых элементов в списокОсвобождения.  Используется для определения,
             * можно ли вернуть обратно СМ этот блок.
             */
            бцел члоОсвоб;

            /**
             * Элементы в блоке.
             */
            З[элтовНаБлок] элты;

            /**
             * Разместить З* из списка освобождения.
             */
            З *разместиИзОсвоб()
            {
                элемент *x = списокОсвобождения;
                списокОсвобождения = x.следщ;
                //
                // очистить указатель, очищает элемент, как если бы обх
                // был заново размещён
                //
                x.следщ = пусто;
                члоОсвоб--;
                return cast(З*)x;
            }

            /**
             * Вымещает З*, направляет обх к списку освобождения.
             *
             * Возвращает да,если этот блок больше не имеет используемых элементов.
             */
            бул вымести(З *з)
            {
                //
                // очистить элемент, чтобы СМ не интерпретировал его
                // как указывающего на что-то ещё.
                //
                memset(з, 0, (З).sizeof);
                элемент *x = cast(элемент *)з;
                x.следщ = списокОсвобождения;
                списокОсвобождения = x;
                return (++члоОсвоб == элтовНаБлок);
            }
        }

        /**
         * Цепь из используемых чанков, элементы которых были аллоцированы
         * хотя бы раз.
         */
        блок *используется;

        /**
         * Свежий блок. Используется только, если в цепи "исаользуется"
         * нет доступных элементов.
         */
        блок *свеж;

        /**
         * Следующий элемент в блоке свеж. Так как нас не волнует список
         * вымещения в блоке свеж, нужно отслеживать следующий элемент
         * из свеж, который будет нами использован.
         */
        бцел следщСвеж;

        /**
         * Размещает З*.
         */
        З* размести()
        {
            if(используется !is пусто && используется.члоОсвоб > 0)
            {
                //
                // размести one элемент of the используется list
                //
                З* рез = используется.разместиИзОсвоб();
                if(используется.члоОсвоб == 0)
                    //
                    // move используется to the конец of the list
                    //
                    используется = используется.следщ;
                return рез;
            }

            //
            // no используется elements are available, размести out of the свеж
            // elements
            //
            if(свеж is пусто)
            {
                свеж = new блок;
                следщСвеж = 0;
            }

            З* рез = &свеж.элты[следщСвеж];
            if(++следщСвеж == элтовНаБлок)
            {
                if(используется is пусто)
                {
                    используется = свеж;
                    свеж.следщ = свеж;
                    свеж.предш = свеж;
                }
                else
                {
                    //
                    // вставить свеж в цепь используется
                    //
                    свеж.предш = используется.предш;
                    свеж.следщ = используется;
                    свеж.предш.следщ = свеж;
                    свеж.следщ.предш = свеж;
                    if(свеж.члоОсвоб != 0)
                    {
                        //
                        // можно рециклировать элементы из свеж
                        //
                        используется = свеж;
                    }
                }
                свеж = пусто;
            }
            return рез;
        }

        /**
         * Освобождает З*.
         */
        проц освободи(З* з)
        {
            //
            // нужно выяснить, какой блок з у нас
            //
            блок *тек = cast(блок *)смАдрес(з);

            if(тек !is свеж && тек.члоОсвоб == 0)
            {
                //
                // переместить тек во фронт списка используется, обх должен освободить узлы
                //для использования.
                //
                if(тек !is используется)
                {
                    if(используется.члоОсвоб != 0)
                    {
                        //
                        // первый, открепить тек его текущего положения
                        //
                        тек.предш.следщ = тек.следщ;
                        тек.следщ.предш = тек.предш;

                        //
                        // теперь, вставить тек перед используется.
                        //
                        тек.предш = используется.предш;
                        тек.следщ = используется;
                        используется.предш = тек;
                        тек.предш.следщ = тек;
                    }
                    используется = тек;
                }
            }

            if(тек.вымести(з))
            {
                //
                // у тек больше нет используемых элементов, обх можно удалить.
                //
                if(тек.следщ is тек)
                {
                    //
                    // только один элемент, не освобождает обх.
                    //
                }
                else
                {
                    //
                    // удалить тек из списка
                    //
                    if(используется is тек)
                    {
                        //
                        // обновить указатель используется
                        //
                        используется = используется.следщ;
                    }
                    тек.следщ.предш = тек.предш;
                    тек.предш.следщ = тек.следщ;
                    delete тек;
                }
            }
        }

        /**
         * Вымещает все чанки, используемые этим Разместителем.
         */
        проц освободиВсе()
        {
            используется = пусто;

            //
            // keep свеж around
            //
            if(свеж !is пусто)
            {
                следщСвеж = 0;
                свеж.списокОсвобождения = пусто;
            }
        }
    }


/**
 * Простой Разместитель, который для размещения каждого элемента использует new.
 */
struct ПростойРазместитель(З)
{
    /**
     * new не требует освободи
     */
    const бул нужноСвоб = нет;

    /**
     * равнозначно new З;
     */
    З* размести()
    {
        return new З;
    }
}

/**
 * Дефолтный Разместитель выбирает правильный Разместитель, в зависимости от размера З.
 */
template ДефолтныйРазместитель(З)
{
    //
    // if there will be more than one З per page, use the блок Разместитель,
    // otherwise, use the simple Разместитель.  Note we can only support
    // БлокРазместитель on Tango.
    //
    version(Динрус)
    {
        static if((З).sizeof + ((ук).sizeof * 3) + бцел.sizeof >= 4095 / 2)
        {
            alias ПростойРазместитель!(З) ДефолтныйРазместитель;
        }
        else
        {
            alias БлокРазместитель!(З, (4095 - ((ук ).sizeof * 3) - бцел.sizeof) / (З).sizeof) ДефолтныйРазместитель;
        }
    }
    else
    {
        alias ПростойРазместитель!(З) ДефолтныйРазместитель;
    }
}
