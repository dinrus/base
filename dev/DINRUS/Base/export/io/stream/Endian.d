﻿/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: Nov 2007

        author:         Kris

        Потокs for свопping эндиан-order. The поток is treated as a установи
        of same-sized elements. Note that partial elements are not mutated

*******************************************************************************/

module io.stream.Endian;

private import stdrus :ПерестановкаБайт;
private import io.device.Conduit;
private import io.stream.Buffered;
private import io.model;

/*******************************************************************************

        Тип T is the element тип

*******************************************************************************/

class ЭндианВвод(T) : ФильтрВвода, ФильтрВвода.Переключатель
{       
        static if ((T.sizeof != 2) && (T.sizeof != 4) && (T.sizeof != 8)) 
                    pragma (msg, "ЭндианВвод :: нужен тип длиной 2, 4 или 8 байтов");

        /***********************************************************************

        ***********************************************************************/

        this (ИПотокВвода поток)
        {
                super (Бввод.создай (поток));
        }
        
        /***********************************************************************

                Чтен из_ провод преобр_в a мишень Массив. The предоставленный приёмн 
                will be populated with контент из_ the провод. 

                Возвращает the число of байты читай, which may be less than
                requested in приёмн (or IOПоток.Кф for конец-of-flow). Note
                that a trailing partial element will be placed преобр_в приёмн,
                but the returned length will effectively ignore it

        ***********************************************************************/

        final override т_мера читай (проц[] приёмн)
        {
                auto длин = исток.читай (приёмн[0 .. приёмн.length & ~(T.sizeof-1)]);
                if (длин != Кф)
                   {
                   // the final читай may be misaligned ...
                   длин &= ~(T.sizeof - 1);

                   static if (T.sizeof == 2)
                              ПерестановкаБайт.своп16 (приёмн.ptr, длин);

                   static if (T.sizeof == 4)
                              ПерестановкаБайт.своп32 (приёмн.ptr, длин);

                   static if (T.sizeof == 8)
                              ПерестановкаБайт.своп64 (приёмн.ptr, длин);
                   }
                return длин;
        }
}



/*******************************************************************************
        
        Тип T is the element тип

*******************************************************************************/

class ЭндианВывод (T) : ФильтрВывода, ФильтрВывода.Переключатель
{       
        static if ((T.sizeof != 2) && (T.sizeof != 4) && (T.sizeof != 8)) 
                    pragma (msg, "ЭндианВывод :: нужен тип длиной 2, 4 или 8 байтов");

        private БуферВывода вывод;


        БуферВывода дайВывод()
		{
            return this.вывод;
		}

        /***********************************************************************

        ***********************************************************************/

        this (ИПотокВывода поток)
        {
                super (вывод = Бвыв.создай (поток));
        }

        /***********************************************************************
        
                Write в_ вывод поток из_ a исток Массив. The предоставленный 
                ист контент will be consumed and лево intact.

                Возвращает the число of байты записано из_ ист, which may
                be less than the quantity предоставленный. Note that any partial 
                elements will not be consumed

        ***********************************************************************/

        final override т_мера пиши (проц[] ист)
        {
                т_мера писатель (проц[] приёмн)
                {
                        auto длин = приёмн.length;
                        if (длин > ист.length)
                            длин = ист.length;

                        длин &= ~(T.sizeof - 1);
                        приёмн [0..длин] = ист [0..длин];

                        static if (T.sizeof == 2)
                                   ПерестановкаБайт.своп16 (приёмн.ptr, длин);

                        static if (T.sizeof == 4)
                                   ПерестановкаБайт.своп32 (приёмн.ptr, длин);

                        static if (T.sizeof == 8)
                                   ПерестановкаБайт.своп64 (приёмн.ptr, длин);

                        return длин;
                }

                return вывод.писатель (&писатель);
        }
}


/*******************************************************************************
        
*******************************************************************************/
        
debug (UnitTest)
{
        import io.device.Array;
        
        unittest
        {
                auto inp = new ЭндианВвод!(дим)(new Массив("hello world"d));
                auto oot = new ЭндианВывод!(дим)(new Массив(64));
                oot.копируй (inp);
                assert (oot.вывод.срез == "hello world"d);
        }
}
