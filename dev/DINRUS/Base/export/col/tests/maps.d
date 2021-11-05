/*
 * Copyright (C) 2008 by Steven Schveighoffer
 * all rights reserved.
 *
 * Примеры of how sets can be used.
 *
 * Currently only implemented for Tango.
 */
import col.КартаДерево;
import col.HashMap;
import col.ArrayList;
import io.Stdout;

void printK(Ключник!(int, int) s, char[] message)
{
    Стдвыв(message ~ " [");
    foreach(k, v; s)
        Стдвыв(" ")(k)("=>")(v);
    Стдвыв(" ]").нс;
}

void print(Обходчик!(int) s, char[] message)
{
    Стдвыв(message ~ " [");
    foreach(v; s)
        Стдвыв(" ")(v);
    Стдвыв(" ]").нс;
}

void main()
{
    auto treeMap = new ДеревоКарта!(int, int);
    auto hashMap = new ХэшКарта!(int, int);

    for(int i = 0; i < 10; i++)
        treeMap.установи(i * i + 1, i);
    printK(treeMap, "заплнено в деревоКарту");
    
    //
    // add all the key/value pairs from treeMap to hashMap
    //
    hashMap.установи(treeMap);
    printK(hashMap, "заполнено в хэшКарту");

    //
    // you can iterate the keys
    //
    print(hashMap.ключи, "ключи хэшКарты");

    //
    // you can compare maps
    //
    if(hashMap == treeMap)
        Стдвыв("равно!").нс;
    else
        Стдвыв("не равно!").нс;

    //
    // you can do intersect/remove operations
    //
    // removes all but the 5, 50, and 26 elements.  Note that 89 is not a key
    // in the set
    //
    hashMap.накладка(new МассивСписок!(int)([5, 50, 26, 89]));
    printK(hashMap, "хэшКарта с накладкой");

    //
    // this removes the 5, 50, and 26 elements from treeMap
    //
    print(hashMap.ключи, "ключи хэшКарты после накладки");
    treeMap.удали(hashMap.ключи);
    printK(treeMap, "удалены из деревоКарты");

    //
    // You can dup a map, and then add some keys/values to it
    //
    treeMap = treeMap.dup.установи(hashMap).установи(75, 80).установи(23, 20).установи(26, 50);
    printK(treeMap, "дублированные, рекомбинированные деревоКарта и ХэшКарты");
}
