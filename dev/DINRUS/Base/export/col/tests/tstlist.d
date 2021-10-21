﻿import sys.Common, col.List, stdrus;

void main()
{
        скажинс("----Тестируем списки----");

        бул проверь_равно(Список!(цел) спис_0, ткст знач)
        {
            ткст o;
            foreach(i; спис_0)
            {
                o ~= фм(i);
            }
            return знач==o;
        }


        Список!(цел) м_спис;
        assert(м_спис.пуст());

        м_спис.надставь(1);
        assert(! м_спис.пуст());
        м_спис.надставь(2);
        м_спис.надставь(3);
        м_спис.надставь(4);
        м_спис.надставь(5);

        assert(! м_спис.пуст());

        ткст o;
        foreach(i; м_спис)
        {
            o ~= фм(i);
        }
        assert(o == "12345");
        o = пусто;
        foreach_reverse(i; м_спис)
        {
            o ~= фм(i);
        }
        assert(o == "54321");

        // Обходчик tests //

        {
            o=пусто;
            auto it=м_спис.начало(),конец=м_спис.конец();
            for(; it != конец; ++it)
            {
                o ~= фм(it.знач);
            }
            assert(o == "12345");
        }
        {
            o = пусто;
            auto it=м_спис.начало_рев(),конец=м_спис.конец_рев();
            for(; it != конец; ++it)
            {
                o ~= фм(it.знач);
            }
            assert(o == "54321");
        }

        // opIn_r tests //

        for (цел i=1; i<=5; i++)
        {
            assert(i in м_спис);
        }
        assert(!(99 in м_спис));
        assert(!(0 in м_спис));

        assert(м_спис.последний == 5);
        assert(м_спис.первый == 1);

        // Find test //
        {
            auto it = м_спис.найди(99);
            assert(it==м_спис.конец());
            for (цел i=1; i<=5; i++)
            {
                it = м_спис.найди(i);
                assert(it!=м_спис.конец());
                assert(it.знач == i);
                assert(*it.укз == i);
            }
        }
        // вставь tests //
        {
            auto it = м_спис.найди(3);
            м_спис.вставь(it, 9);
            assert( проверь_равно(м_спис, "129345") );
            м_спис.вставь(м_спис.начало(), 8);
            assert( проверь_равно(м_спис, "8129345") );
            м_спис.вставь(м_спис.конец(), 7);
            assert( проверь_равно(м_спис, "81293457") );
        }

        // удали tests //
        {
            auto it = м_спис.найди(3);
            м_спис.удали(it);
            assert( проверь_равно(м_спис, "8129457") );
            м_спис.удали(м_спис.начало);
            assert( проверь_равно(м_спис, "129457") );
            auto последний = м_спис.конец;
            последний--;
            м_спис.удали(последний);
            assert( проверь_равно(м_спис, "12945") );

            м_спис.удали(м_спис.начало);
            assert( проверь_равно(м_спис, "2945") );
            м_спис.удали(м_спис.начало);
            assert( проверь_равно(м_спис, "945") );
            м_спис.удали(м_спис.начало);
            assert( проверь_равно(м_спис, "45") );
            м_спис.удали(м_спис.начало);
            assert( проверь_равно(м_спис, "5") );
            м_спис.удали(м_спис.начало);
            assert( проверь_равно(м_спис, "") );

            assert(м_спис.найди(1) == м_спис.конец());

            // Try inserting into a previously non-пуст список
            assert(м_спис.пуст());
            м_спис.надставь(9);
            assert(!м_спис.пуст());
            assert( проверь_равно(м_спис, "9") );
            assert( м_спис.найди(9).знач == 9 );

            *м_спис.найди(9).укз = 8;
            assert( м_спис.найди(8).знач == 8 );
            assert(м_спис.длина == 1);
        }

        скажинс("----Тест списков заверщён ----");
    }
