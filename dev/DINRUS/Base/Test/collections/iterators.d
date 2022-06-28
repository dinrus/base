/*
 * Примеры использования обходчиков
 * из библиотеки col базового пакета Динруса.
 */

import col.Iterators;
import col.ArrayList;
import io.Stdout;

проц печатай(V)(Обходчик!(V) s, ткст сооб)
{
    Стдвыв(сооб ~ " [");
    foreach(i; s)
        Стдвыв(" ")(i);
    Стдвыв(" ]").нс;
}

проц печатай(K, V)(Ключник!(K, V) s, ткст сооб)
{
    Стдвыв(сооб ~ " [");
    foreach(k, v; s)
        Стдвыв(" ")(k)("=>")(v);
    Стдвыв(" ]").нс;
}

проц main()
{
    auto x = new МассивСписок!(цел);
    for(цел i = 0; i < 10; i++)
        x.добавь(i + 1);

    печатай!(бцел, цел)(x, "исходный список");

    //
    // use a filter iterator to filter only elements you want.
    //
    // Prints only even elements
    //
    печатай!(цел)(new ФильтрОбходчик!(цел)(x, function бул(ref цел i) {return i % 2 == 0;}), "только чётные элементы");

    //
    // use a transform iterator to change elements as they are iterated.
    //
    // Changes all elements to floating point, multiplied by 1.5
    //
    печатай!(плав)(new ТрансформОбходчик!(плав, цел)(x, function проц(ref цел i, ref плав результат) {результат = i * 1.5;}), "умножено на 1.5");

    //
    // use a chain iterator to chain multiple iterators together
    //
    // печатай x three times
    печатай!(цел)(new ОбходчикЦепи!(цел)(x, x, x), "печатает элементы 3 раза");

    //
    // this function can convert any iterator to an array.  You can also do
    // this by adding the iterator to an ArrayList, and then calling asArray,
    // but this version does not create an extra class on the heap, and is
    // more optimized.
    //
    auto a = вМассив!(цел)(x);
    Стдвыв("преобразован в массив: ")(a).нс;

    //
    // one can use the keyed transform iterator to transform keyed iterators
    // to normal iterators
    //
    печатай!(дол)(new ТрансформКлючник!(цел, дол, бцел, цел)(x, function проц(ref бцел idx, ref цел v, ref цел ignored, ref дол результат)
        { результат = 0x1_0000_0000L * idx + v;}), "индексы и значения комбинированы");

    //
    // chained keyed iterator
    //
    печатай!(бцел, цел)(new КлючникЦепи!(бцел, цел)(x, x, x),  "печатает элементы 3 раза (с ключами)");

    //
    // keyed filter iterators
    //
    печатай!(бцел, цел)(new ФильтрКлючник!(бцел, цел)(x, function бул(ref бцел idx, ref цел v){return idx % 2 == 0;}),  "печатает значения под чётными индексами");

    //
    // add all elements to an AA
    //
    Стдвыв("преобразован в АМ: ")(вАссоцМасс!(бцел, цел)(x)).нс;
}
