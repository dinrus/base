﻿module util.series;

struct Серии
{
    private
    {
        бдол знач;
        бдол прирост;
    }

    бдол следщ()
    {
        бдол lCV;

        lCV = знач;
        знач += (прирост + 1);
        return lCV;
    }

    проц следщ(бдол иниц)
    {
        знач = иниц;
    }

    бдол тек()
    {
        return знач;
    }

    бдол предш()
    {
        return знач - (прирост+1);
    }

    проц прирасти(бдол иниц = 1)
    {
        прирост = иниц-1;
    }

}


unittest
{
    Серии a;
    assert( a.следщ == 0);
    assert( a.следщ == 1);
    assert( a.следщ == 2);
    assert( a.тек == 3);
    a.прирасти = 2;
    assert( a.следщ == 3);
    assert( a.следщ == 5);
    assert( a.предш == 5);
    a.следщ = 100;
    assert( a.тек == 100);
    assert( a.следщ == 100);
    assert( a.следщ == 102);
}

