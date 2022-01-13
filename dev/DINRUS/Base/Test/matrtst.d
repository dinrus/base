﻿import math.linalg.Matrix, math.linalg.Vector,stdrus, math.linalg.color,
  col.ArrayList, col.ArrayMultiset, col.HashMap, col.HashMultiset, sys.WinConsts;


pragma(lib, "dinrus.lib");

    alias дво т_чло;
    alias Матрица!(т_чло, 3,2) Матр32;
    alias Матрица!(т_чло, 2,3) Матр23;
    alias Матрица!(т_чло, 3,3) Матр33;
    alias Матрица!(т_чло, 2,2) Матр22;
    alias Вектор!(т_чло,3) Вектр3;
    alias Вектор!(т_чло,2) Вектр2;

    void проверь_матр(ref Матр33 A, т_чло[9] v) {
        assert(A.m00 == v[0]);
        assert(A.m01 == v[1]);
        assert(A.m02 == v[2]);
        assert(A.m10 == v[3]);
        assert(A.m11 == v[4]);
        assert(A.m12 == v[5]);
        assert(A.m20 == v[6]);
        assert(A.m21 == v[7]);
        assert(A.m22 == v[8]);
    }
    void проверь_матрп(ref Матр33 A, т_чло[9] v) {
        assert(абс(A.m00 - v[0]) < 1e-4);
        assert(абс(A.m01 - v[1]) < 1e-4);
        assert(абс(A.m02 - v[2]) < 1e-4);
        assert(абс(A.m10 - v[3]) < 1e-4);
        assert(абс(A.m11 - v[4]) < 1e-4);
        assert(абс(A.m12 - v[5]) < 1e-4);
        assert(абс(A.m20 - v[6]) < 1e-4);
        assert(абс(A.m21 - v[7]) < 1e-4);
        assert(абс(A.m22 - v[8]) < 1e-4);
    }
    void проверь_матр(ref Матр22 A, т_чло[4] v) {
        assert(A.m00 == v[0]);
        assert(A.m01 == v[1]);
        assert(A.m10 == v[2]);
        assert(A.m11 == v[3]);
    }
    void проверь_матр(ref Матр23 A, т_чло[6] v) {
        assert(A.m00 == v[0]);
        assert(A.m01 == v[1]);
        assert(A.m02 == v[2]);
        assert(A.m10 == v[3]);
        assert(A.m11 == v[4]);
        assert(A.m12 == v[5]);
    }
    void проверь_матр(ref Матр32 A, т_чло[6] v) {
        assert(A.m00 == v[0]);
        assert(A.m01 == v[1]);
        assert(A.m10 == v[2]);
        assert(A.m11 == v[3]);
        assert(A.m20 == v[4]);
        assert(A.m21 == v[5]);
    }
    void проверь_вектр(ref Вектр2 x, т_чло[2] v) {
        assert(x[0] == v[0]);
        assert(x[1] == v[1]);
    }
    void проверь_вектр(ref Вектр3 x, т_чло[3] v) {
        assert(x[0] == v[0]);
        assert(x[1] == v[1]);
        assert(x[2] == v[2]);
    }


проц матр() {

скажинс("Начало теста шаблона Матрица");

    Матр32 матр32 = [9,8,7,6,5,4];
    проверь_матр(матр32, [9,8,
                      7,6,
                      5,4]);
    Матр23 матр23 = {[9,8, 7,6, 5,4]};//столб major
    проверь_матр(матр23, [9,7,5,
                      8,6,4]);
    матр32.m10 = 3;
    проверь_матр(матр32, [9,8,
                      3,6,
                      5,4]);
    матр23.m10 = 1;
    проверь_матр(матр23, [9,7,5,
                      1,6,4]);

    //writefln("матр23 =\n%s", матр23);

    Матрица!(дво, 9,9) матр99;
    Матрица!(дво, 10,10) матрxx;

    матр32 = Матр32(1,2,
                  3,4,
                  5,6);
    проверь_матр(матр32, [1,2,
                      3,4,
                      5,6]);

    матр23 = Матр23([1,2,3,
                   4,5,6]);
    проверь_матр(матр23, [1,2,3,
                      4,5,6]);

    матр32 = Матр32.столб_майор([1,2,3,4,5,6]);
    проверь_матр(матр32, [1,4, 2,5, 3,6]);

    матр23 = Матр23.столб_майор([1,2, 3,4, 5,6]);
    проверь_матр(матр23, [1,3,5,
                      2,4,6]);

    auto матр33 = умножь_мат(матр32,матр23);
    проверь_матр(матр33, [9,19,29, 
                      12,26,40,
                      15,33,51]);

    // opMul
    auto матр22 = матр23 * матр32;
    assert(is(typeof(матр22)==Матр22));
    проверь_матр(матр22, [22,49, 28,64]);
    
    // opMulAssign
    матр22 = Матр22([1.,2,
                   5, 3]);
    матр32 *= матр22;
    проверь_матр(матр22, [1,2, 5,3]);
    проверь_матр(матр32, [21,14, 27,19, 33,24]);

    // opMul (скаляр)
    матр22 = 2 * матр22;
    проверь_матр(матр22, [2,4, 10,6]);

    // opDiv (скаляр)
    проверь_матр(матр22/2, [1,2, 5,3]);

    // opMulAssign (скаляр)
    матр22 *= 0.5;
    проверь_матр(матр22, [1,2, 5,3]);

    // opDivAssign (скаляр)
    матр22 /= 0.5;
    проверь_матр(матр22, [2,4, 10,6]);

    матр22 = Матр22([1,2, 5,3]);
    // opAdd
    проверь_матр(матр22+матр22, [2,4, 10,6]);
    проверь_матр(матр22, [1,2, 5,3]);
    проверь_матр(матр23 + матр23, [2,6,10,  4,8,12]);
    проверь_матр(матр23, [1,3,5,  2,4,6]);

    // opSub
    проверь_матр(матр22-Матр22(2,4,3,9), [-1,-2, 2,-6]);

    // Transpose / транспонированный
    матр22 = Матр22([1,2, 5,3]);
    проверь_матр(матр22.транспонированный, [1,5, 2,3]);
    проверь_матр(матр22,            [1,2, 5,3]);
    матр22.транспонируй();
    проверь_матр(матр22,            [1,5, 2,3]);
              
    матр23 = Матр23(1,2,3, 4,5,6);
    проверь_матр(матр23.транспонированный, [1,4, 2,5, 3,6]);
    проверь_матр(матр23,            [1,2,3, 4,5,6]);
    //матр23.транспонируй();  // compile time error
    
    матр32 = Матр32(1,2, 3,4, 5,6);
    проверь_матр(матр32.транспонированный, [1,3,5, 2,4,6]);
    проверь_матр(матр32,            [1,2, 3,4, 5,6]);
    //матр32.транспонируй(); // compile-time error

    матр33 = Матр33(1,2,3, 4,5,6, 7,8,9);
    проверь_матр(матр33.транспонированный, [1,4,7, 2,5,8, 3,6,9]);
    проверь_матр(матр33,            [1,2,3, 4,5,6, 7,8,9]);
    матр33.транспонируй();
    проверь_матр(матр33,            [1,4,7, 2,5,8, 3,6,9]);

    матр33.добавь_элт(2,1, 5.0);
    проверь_матр(матр33,            [1,4,7, 2,5,8, 3,11,9]);

    Матр33 матр33inv = матр33.инверсия();
    проверь_матрп(матр33inv*3, [-4.3, 4.1,-0.3,
                            0.6, -1.2, 0.6,
                            0.7,  0.1,-0.3]);
    проверь_матрп(матр33*матр33inv, [1.,0,0,  0,1,0, 0,0,1]);
    проверь_матрп(матр33inv*матр33, [1.,0,0,  0,1,0, 0,0,1]);

    проверь_матр(Матр33.подобие, [1.,0,0,  0,1,0, 0,0,1]);
    проверь_матр(Матр33.ноль, [0,0,0,  0,0,0, 0,0,0]);
    
    Вектр3 x = {[1,-3,7]};
    Вектр2 Ax;
    матр23 = Матр23(1,2,3, 4,5,6);
    умножь_верни_мат_век(матр23, x, Ax);
    проверь_вектр(Ax, [16,31]);

    умножь_верни_век_мат(Ax, матр23, x);
    проверь_вектр(x, [140,187,234]);

    x = Век3д([-1, 2, -3]);
    Век3д y = {[3,2,1]};
    верни_внешн_продукт(x, y, матр33);
    проверь_матр(матр33, [-3, -2, -1,       
                      +6,  4,  2,
                      -9, -6, -3]);
					  

    
}

проц тест1()
{
скажинс("Начало теста шаблона Цвет4");
    Цвет4 a;
    a.установи(0.1, 0.3, 0.9, 0.6);
    Цвет3 с = a.кзс;
    бцел au = a.вБцел(ПорядокБайтов.КЗСА);
    assert( равны( Цвет3(au, ПорядокБайтов.КЗСА), с ) );
   // assert(0);
}

проц тест2()
{
скажинс("Начало теста шаблона Цвет3");
    Цвет3 c = Цвет3( 0.2, 0.5, 1.0 );
    assert( равны(c.вХСЛ.вЦвет3(), c) );
}

    проц масСпис()
    {
	скажи("Тест МассиваСписка");
        auto al = new МассивСписок!(бцел);
        al.добавь([0U, 1, 2, 3, 4, 5]);
        assert(al.длина == 6);
        al.добавь(al[0..3]);
        assert(al.длина == 9);
		скажинс("=== ПРОЙДЕН ===");
    }
	
	проц  масМн()
    {
		скажи("Тест МассиваМультинабора");
        auto ms = new МассивМультинабор!(бцел);
        ms.добавь([0U, 1, 2, 3, 4, 5]);
        assert(ms.длина == 6);
        ms.удали(1);
        assert(ms.длина == 5);
        //assert(ms._голова.следщ.значение == [0U, 5, 2, 3, 4]);
        foreach(ref очистить_ли, v; &ms.очистить)
            очистить_ли = (v % 2 == 1);
        assert(ms.длина == 3);
        //assert(ms._голова.следщ.значение == [0U, 4, 2]);
				скажинс("=== ПРОЙДЕН ===");
    }

	    проц хэшМп()
    {
	скажи("Тест ХэшКарты");
        ХэшКарта!(бцел, бцел) hm = new ХэшКарта!(бцел, бцел);
        Карта!(бцел, бцел) m = hm;
        for(цел i = 0; i < 10; i++)
            hm[i * i + 1] = i;
        assert(hm.длина == 10);
        foreach(ref чистить_ли, k, v; &hm.чисть_ключ)
        {
            чистить_ли = (v % 2 == 1);
        }
        assert(hm.длина == 5);
        assert(hm.содержит(6));
        assert(hm.имеетКлюч(6 * 6 + 1));
		скажинс("=== ПРОЙДЕН ===");
    }
	
	  проц хмн() 
    {
		скажи("Тест ХэшМультинабор");
        auto hms = new ХэшМультинабор!(бцел);
        Мультинабор!(бцел) ms = hms;
        hms.добавь([0U, 1, 2, 3, 4, 5, 5]);
        assert(hms.длина == 7);
        assert(ms.счёт(5U) == 2);
        foreach(ref чистить_ли, i; &ms.очистить)
        {
            чистить_ли = (i % 2 == 1);
        }
        assert(ms.счёт(5U) == 0);
        assert(ms.длина == 3);
				скажинс("=== ПРОЙДЕН ===");
    }
	
	
import col.HashSet;
	
	   проц хн()
    {
	скажи("Тест ХэшНабора");
        auto hs = new ХэшНабор!(бцел);
        Набор!(бцел) s = hs;
        s.добавь([0U, 1, 2, 3, 4, 5, 5]);
        assert(s.длина == 6);
        foreach(ref чистить_ли, i; &s.очистить)
            чистить_ли = (i % 2 == 1);
        assert(s.длина == 3);
        assert(s.содержит(4));
		скажинс("=== ПРОЙДЕН ===");
    }
	
import col.LinkList;

	    проц сс()
    {
	
		скажи("Тест СвязкиСписка");
        auto ll = new СвязкаСписок!(бцел);
        Список!(бцел) l = ll;
        l.добавь([0U, 1, 2, 3, 4, 5]);
        assert(l.длина == 6);
        assert(l.содержит(5));
        foreach(ref чистить_ли, i; &l.очистить)
            чистить_ли = (i % 2 == 1);
        assert(l.длина == 3);
        assert(!l.содержит(5));
				скажинс("=== ПРОЙДЕН ===");
    }

import col.TreeMap;

	    проц дк()
    {
	
	скажи("Тест ДеревоКарты");
        auto tm = new ДеревоКарта!(бцел, бцел);
        Карта!(бцел, бцел) m = tm;
        for(цел i = 0; i < 10; i++)
            m[i * i + 1] = i;
        assert(m.длина == 10);
        foreach(ref чистить_ли, k, v; &m.чисть_ключ)
        {
            чистить_ли = (v % 2 == 1);
        }
        assert(m.длина == 5);
        assert(m.содержит(6));
        assert(m.имеетКлюч(6 * 6 + 1));
		скажинс("=== ПРОЙДЕН ===");
    }
	
import col.TreeMultiset;
	   проц дмс()
    {
		скажи("Тест ДеревоМультинабора");
        auto tms = new ДеревоМультинабор!(бцел);
        Мультинабор!(бцел) ms = tms;
        ms.добавь([0U, 1, 2, 3, 4, 5, 5]);
        assert(ms.длина == 7);
        assert(ms.счёт(5U) == 2);
        foreach(ref чистить_ли, i; &ms.очистить)
            чистить_ли = (i % 2 == 1);
        assert(ms.счёт(5U) == 0);
        assert(ms.длина == 3);
		скажинс("=== ПРОЙДЕН ===");
    }
	
import col.TreeSet;
	    проц дн()
    {
			скажи("Тест ДеревоНабора");
        auto ts = new ДеревоНабор!(бцел);
        Набор!(бцел) s = ts;
        s.добавь([0U, 1, 2, 3, 4, 5, 5]);
        assert(s.length == 6);
        foreach(ref чистить_ли, i; &s.очистить)
            чистить_ли = (i % 2 == 1);
        assert(s.length == 3);
        assert(s.содержит(4));
		скажинс("=== ПРОЙДЕН ===");
    }
	
проц main()
{
матр();
тест1();
тест2();
	скажинс("Тесты удачно пройдены");
	нс;
	скажинс("Тесты пакета col: ");
	нс;
	масСпис();
	масМн();
	хэшМп();
	хмн();
	хн();
	сс();
	дк();
	дмс();
	дн();
	нс;
	пз;
	//выход(0);
}