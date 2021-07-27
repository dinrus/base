/*
 * Copyright (C) 2008 by Steven Schveighoffer
 * all rights reserved.
 *
 * Examples of how sets can be used.
 *
 * Currently only implemented for Tango.
 */
import col.HashSet;
import col.TreeSet;
import col.ArrayList;
import io.Stdout;

void print(Обходчик!(int) s, char[] message)
{
    Стдвыв(message ~ " [");
    foreach(i; s)
        Стдвыв(" ")(i);
    Стдвыв(" ]").нс;
}

void main()
{
    auto treeSet = new ДеревоНабор!(int);
    auto hashSet = new ХэшНабор!(int);
    for(int i = 0; i < 10; i++)
        treeSet.добавь(i*10);
    print(treeSet, "filled in treeset");

    //
    // add all the elements from treeSet to hashSet
    //
    hashSet.добавь(treeSet);
    print(hashSet, "filled in hashset");

    //
    // you can compare sets
    //
    if(hashSet == treeSet)
        Стдвыв("равно!").нс;
    else
        Стдвыв("не равно!").нс;

    //
    // you can do set operations
    //
    // This removes all but the 0, 30, and 50 elements
    hashSet.накладка(new МассивСписок!(int)([0, 30, 50, 900, 33]));
    print(hashSet, "intersected hashset");

    // this removes the 0, 30, and 50 elements from treeSet
    treeSet.удали(hashSet);
    print(treeSet, "removed from treeset");

    //
    // You can dup a set, and then add data to it.
    // Note that 7, 8, and 9 are already in the set, so they will only be
    // there once.
    //
    // combine two sets and an array
    treeSet = treeSet.dup.добавь(hashSet).добавь([70, 80, 90, 100, 110]);
    print(treeSet, "dup'd, recombined treeset and hashset");
}
