import stdrus, stdrusex, cidrus;

проц main(){
    Серии a;
    assert( a.следщ == 1);
    assert( a.следщ == 2);
    assert( a.следщ == 3);
    assert( a.тек == 3);
    a.прирост(2);
    assert( a.следщ == 5);
    assert( a.следщ == 7);
    assert( a.предш == 5);
    a.прирост( 100);
    assert( a.тек == 107);
    assert( a.следщ == 207);
    assert( a.следщ == 307);
	скажинс("Серии проверены");
скажинс("Путь к программе: "~дайТекПап());
выход(0);
}

