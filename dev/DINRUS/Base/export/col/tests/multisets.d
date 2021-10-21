/*
 * Copyright (C) 2008 by Steven Schveighoffer
 * all rights reserved.
 *
 * Examples of how sets can be used.
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
    print(treeMS, "filled in treeMS");

    //
    // add all the elements from treeMS to hashMS
    //
    hashMS.добавь(treeMS);
    print(hashMS, "filled in hashMS");

    //
    // create the array multiset with the given array
    //
    auto arrayMS = new МассивМультинабор!(int);
    arrayMS.добавь([0, 30, 50]);
    print(arrayMS, "filled in arrayMS");
    
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
    Стдвыв("convenient element in arrayMS: ")(arrayMS.дай).нс;
    Стдвыв("removed convenient element in arrayMS: ")(arrayMS.изыми).нс;
    print(arrayMS, "arrayMS после take");

    //
    // You can dup a multiset, and then add data to it.
    //
    // combine three sets and an array
    treeMS = treeMS.dup.добавь(hashMS).добавь(arrayMS).добавь([70, 80, 90, 100, 110]);
    print(treeMS, "dup'd, recombined treeMS, arrayMS, and hashMS, added some elements");
}
