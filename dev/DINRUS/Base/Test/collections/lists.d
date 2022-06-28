/*
 * Copyright (C) 2008 by Steven Schveighoffer
 * all rights reserved.
 *
 * Примеры of how lists can be used.
 *
 * Currently only implemented for Tango.
 */
import col.ArrayList;
import col.LinkList;
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
    auto arrayList = new МассивСписок!(int);
    auto linkList = new СвязкаСписок!(int);

    for(int i = 0; i < 10; i++)
        arrayList.добавь(i*5);
    print(arrayList, "filled in arraylist");


    //
    // add all the elements from arraylist to linklist
    //
    linkList.добавь(arrayList);
    print(linkList, "filled in linkList");

    //
    // you can compare lists
    //
    if(arrayList == linkList)
        Стдвыв("equal!").нс;
    else
        Стдвыв("not equal!").нс;

    //
    // you can concatenate lists together
    //
    arrayList ~= linkList;
    print(arrayList, "appended linkList to arrayList");
    linkList = linkList ~ arrayList;
    print(linkList, "concatenated linkList and arrayList");

    //
    // you can purge elements from a list
    //
    // removes all odd elements in the list.
    foreach(ref doPurge, i; &linkList.очистить)
        doPurge = (i % 2 == 1);
    print(linkList, "removed all odds from linkList");

    //
    // you can slice ArrayLists
    //
    Список!(int) slice = arrayList[5..10];
    print(slice, "slice of arrayList");

    //
    // removing an element from a slice removes it from the parent
    //
    // removes all even elements from arrayList
    foreach(ref doPurge, i; &slice.очистить)
        doPurge = (i % 2 == 0);
    print(slice, "removed evens from slice");
    print(arrayList, "arrayList после removal from slice");
}
