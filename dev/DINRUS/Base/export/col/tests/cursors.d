/*
 * Copyright (C) 2008 by Steven Schveighoffer
 * all rights reserved.
 *
 * Примеры of how cursors can be used.
 *
 * Currently only implemented for Tango.
 */
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
    auto list = new СвязкаСписок!(int);
    list.добавь([1,5,6,8,9,2,3,11,2,3,5,7]);
    print(list, "список заполнен");

    //
    // cursors can be used to keep references to specific elements in a linked
    // list.
    //
    auto c = list.найди(9);
    Стдвыв.форматнс("c указывает на {}", c.значение);

    auto c2 = list.найди(6);
    Стдвыв.форматнс("c2 указывает на {}", c2.значение);

    //
    // now, I can remove c2 without affecting c.  Note that for linked list,
    // this is O(1) removal.  Note that removal gives me the next valid
    // iterator.
    //
    c2 = list.удали(c2);
    print(list, "после удаления 6");
    Стдвыв.форматнс("c теперь указывает на {}", c.значение);
    Стдвыв.форматнс("c2 теперь указывает на {}", c2.значение);

    //
    // cursors have different behaviors for different collection and
    // implementation types.  Each collection documentation discusses what is
    // and is not allowed, and the run time of each cursor-based function.
    //
}
