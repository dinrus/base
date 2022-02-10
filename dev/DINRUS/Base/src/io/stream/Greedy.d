﻿/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: June 2007

        author:         Kris

*******************************************************************************/

module io.stream.Greedy;

private import io.device.Conduit;


/*******************************************************************************

        A провод фильтр that ensures its ввод is читай in full. There's
        also an optional читайРовно() for ещё explicit requests         

*******************************************************************************/
export:

class ГридиВвод : ФильтрВвода
{
export:
        /***********************************************************************

                Распространить конструктор на суперкласс.

        ***********************************************************************/

        this (ИПотокВвода поток)
        {
                super (поток);
        }

        /***********************************************************************

                Fill the предоставленный Массив. Возвращает the число of байты
                actually читай, which will be less that приёмн.length when
                Кф есть been reached, and then Кф thereafter

        ***********************************************************************/

        final override т_мера читай (проц[] приёмн)
        {
                т_мера длин = 0;

                while (длин < приёмн.length)
                      {
                      auto i = исток.читай (приёмн [длин .. $]);
                      if (i is Кф)
                          return (длин ? длин : i);
                      длин += i;
                      } 
                return длин;
        }

        /***********************************************************************
        
                Читает из потока в целевой массив. The предоставленный приёмн
                will be fully populated with контент из_ the ввод. 

                This differs из_ читай in that it will throw an исключение
                where an Кф condition is reached перед ввод есть completed

        ***********************************************************************/

        final ГридиВвод читайРовно (проц[] приёмн)
        {
                while (приёмн.length)
                      {
                      auto i = читай (приёмн);
                      if (i is Кф)
                          провод.ошибка ("неожиданный Кф во время чтения: "~провод.вТкст);
                      приёмн = приёмн [i .. $];
                      }
                return this;
        }          
}



/*******************************************************************************

        A провод фильтр that ensures its вывод is записано in full. There's
        also an optional пишиРовно() for ещё explicit requests   

*******************************************************************************/

class ГридиВывод : ФильтрВывода
{
export:
        /***********************************************************************

                Распространить конструктор на суперкласс.

        ***********************************************************************/

        this (ИПотокВывода поток)
        {
                super (поток);
        }

        /***********************************************************************

                Consume everything we were given. Возвращает the число of
                байты записано which will be less than ист.length only
                when an Кф condition is reached, and Кф из_ that точка 
                forward

        ***********************************************************************/

        final override т_мера пиши (проц[] ист)
        {
                т_мера длин = 0;

                while (длин < ист.length)
                      {
                      auto i = сток.пиши (ист [длин .. $]);
                      if (i is Кф)
                          return (длин ? длин : i);
                      длин += i;
                      } 
                return длин;
        }
                             
        /***********************************************************************
        
                Записывает в поток из исходного массива. The предоставленный ист контент 
                will be записано in full в_ the вывод.

                This differs из_ пиши in that it will throw an исключение
                where an Кф condition is reached перед вывод есть completed

        ***********************************************************************/

        final ГридиВывод пишиРовно (проц[] ист)
        {
                while (ист.length)
                      {
                      auto i = пиши (ист);
                      if (i is Кф)
                          провод.ошибка ("неожиданный Кф во время записи: "~провод.вТкст);
                      ист = ист [i .. $];
                      }
                return this;
        }       
}


/*******************************************************************************

*******************************************************************************/

debug (Greedy)
{
        проц main()
        {       
                auto s = new ГридиВвод (пусто);
        }
}