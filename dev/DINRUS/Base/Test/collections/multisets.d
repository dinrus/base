/*
 * Copyright (C) 2008 by Steven Schveighoffer
 * all rights reserved.
 *
 * Примеры of how sets can be used.
 *
 * Currently only implemented for Tango.
 */
import col.HashMultiset;
import col.TreeMultiset;
import col.ArrayMultiset;
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
    auto treeMS = new ДеревоМультинабор!(int);
    auto hashMS = new ХэшМультинабор!(int);
    //
    // multisets can have multiple instances of the same element
    //
    for(int i = 0; i < 10; i++)
        treeMS.добавь(i*10 % 30);
    print(treeMS, "заполнено в treeMS");

    //
    // add all the elements from treeMS to hashMS
    //
    hashMS.добавь(treeMS);
    print(hashMS, "заполнено в hashMS");

    //
    // create the array multiset with the given array
    //
    auto массМультиНаб = new МассивМультинабор!(int);
    массМультиНаб.добавь([0, 30, 50]);
    print(массМультиНаб, "заполнено в массМультиНаб");
    
    //
    // you cannot compare multisets, as there is no particular order or lookup
    // function, so the runtime could be O(n^2)
    //
    // you cannot do set operations, as the runtime could be O(n^2)
    //

    //
    // you can get the most convenient element in the multiset, and remove it
    // with a guaranteed < O(n) runtime.
    //
    Стдвыв("convenient element in массМультиНаб: ")(массМультиНаб.дай).нс;
    Стдвыв("removed convenient element in массМультиНаб: ")(массМультиНаб.изыми).нс;
    print(массМультиНаб, "массМультиНаб после take");

    //
    // You can dup a multiset, and then add data to it.
    //
    // combine three sets and an array
    treeMS = treeMS.dup.добавь(hashMS).добавь(массМультиНаб).добавь([70, 80, 90, 100, 110]);
    print(treeMS, "dup'd, recombined treeMS, массМультиНаб, and hashMS, added some elements");
}
