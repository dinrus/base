/*
 * Copyright (C) 2008 by Steven Schveighoffer
 * all rights reserved.
 *
 * Примеры of how special iterators can be used.
 *
 * Currently only implemented for Tango.
 */

import col.Iterators;
import col.ArrayList;
import io.Stdout;

void print(V)(Обходчик!(V) s, char[] message)
{
    Стдвыв(message ~ " [");
    foreach(i; s)
        Стдвыв(" ")(i);
    Стдвыв(" ]").нс;
}

void print(K, V)(Ключник!(K, V) s, char[] message)
{
    Стдвыв(message ~ " [");
    foreach(k, v; s)
        Стдвыв(" ")(k)("=>")(v);
    Стдвыв(" ]").нс;
}

void main()
{
    auto x = new МассивСписок!(int);
    for(int i = 0; i < 10; i++)
        x.добавь(i + 1);

    print!(uint, int)(x, "исходный список");

    //
    // use a filter iterator to filter only elements you want.
    //
    // Prints only even elements
    //
    print!(int)(new ФильтрОбходчик!(int)(x, function bool(ref int i) {return i % 2 == 0;}), "только чётные элементы");

    //
    // use a transform iterator to change elements as they are iterated.
    //
    // Changes all elements to floating point, multiplied by 1.5
    //
    print!(float)(new ТрансформОбходчик!(float, int)(x, function void(ref int i, ref float result) {result = i * 1.5;}), "умножено на 1.5");

    //
    // use a chain iterator to chain multiple iterators together
    //
    // print x three times
    print!(int)(new ОбходчикЦепи!(int)(x, x, x), "печатает элементы 3 раза");

    //
    // this function can convert any iterator to an array.  You can also do
    // this by adding the iterator to an ArrayList, and then calling asArray,
    // but this version does not create an extra class on the heap, and is
    // more optimized.
    //
    auto a = вМассив!(int)(x);
    Стдвыв("преобразован в массив: ")(a).нс;

    //
    // one can use the keyed transform iterator to transform keyed iterators
    // to normal iterators
    //
    print!(long)(new ТрансформКлючник!(int, long, uint, int)(x, function void(ref uint idx, ref int v, ref int ignored, ref long result)
        { result = 0x1_0000_0000L * idx + v;}), "индексы и значения комбинированы");

    //
    // chained keyed iterator
    //
    print!(uint, int)(new КлючникЦепи!(uint, int)(x, x, x),  "печатает элементы 3 раза (с ключами)");

    //
    // keyed filter iterators
    //
    print!(uint, int)(new ФильтрКлючник!(uint, int)(x, function bool(ref uint idx, ref int v){return idx % 2 == 0;}),  "печатает значения под чётными индексами");

    //
    // add all elements to an AA
    //
    Стдвыв("преобразован в АМ: ")(вАссоцМасс!(uint, int)(x)).нс;
}
