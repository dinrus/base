﻿import st.stackcontext, st.stackthread, dinrus;


проц Тест()
{
    скажифнс("Тестируется создание/удаление контекста");
    цел s0 = 0;
    static цел s1 = 0;
    
    КонтекстСтэка a = new КонтекстСтэка(
    delegate void()
    {
        s0++;
    });
    
    static проц fb() { s1++; }
    
    КонтекстСтэка b = new КонтекстСтэка(&fb);
    
    КонтекстСтэка c = new КонтекстСтэка(
        delegate void() { assert(false); });
    
    assert(a);
    assert(b);
    assert(c);
    
    assert(s0 == 0);
    assert(s1 == 0);
    assert(a.дайСостояние == ПСостояниеКонтекста.Готов);
    assert(b.дайСостояние == ПСостояниеКонтекста.Готов);
    assert(c.дайСостояние == ПСостояниеКонтекста.Готов);
    
    delete c;
    
    assert(s0 == 0);
    assert(s1 == 0);
    assert(a.дайСостояние == ПСостояниеКонтекста.Готов);
    assert(b.дайСостояние == ПСостояниеКонтекста.Готов);
    
    скажифнс("выполняется a");
    a.пуск();
    скажифнс("a выполнен");
    
    assert(a);
    
    assert(s0 == 1);
    assert(s1 == 0);
    assert(a.дайСостояние == ПСостояниеКонтекста.Завершён);
    assert(b.дайСостояние == ПСостояниеКонтекста.Готов);    
    
    assert(b.дайСостояние == ПСостояниеКонтекста.Готов);
    
    скажифнс("Запускается b");
    b.пуск();
    скажифнс("b выполнен");
    
    assert(s0 == 1);
    assert(s1 == 1);
    assert(b.дайСостояние == ПСостояниеКонтекста.Завершён);
    
    delete a;
    delete b;
    
    скажифнс("Создание контекста пройдено");
}
    
проц Тест1()
{
    скажифнс("Тестируется переключение контекста");
    цел s0 = 0;
    цел s1 = 0;
    цел s2 = 0;
    
    КонтекстСтэка a = new КонтекстСтэка(
    delegate void()
    {
        while(true)
        {
            debug скажифнс(" ---A---");
            s0++;
            КонтекстСтэка.жни();
        }
    });
    
    
    КонтекстСтэка b = new КонтекстСтэка(
    delegate void()
    {
        while(true)
        {
            debug скажифнс(" ---B---");
            s1++;
            КонтекстСтэка.жни();
        }
    });
    
    
    КонтекстСтэка c = new КонтекстСтэка(
    delegate void()
    {
        while(true)
        {
            debug скажифнс(" ---C---");
            s2++;
            КонтекстСтэка.жни();
        }
    });
    
    assert(a);
    assert(b);
    assert(c);
    assert(s0 == 0);
    assert(s1 == 0);
    assert(s2 == 0);
    
    a.пуск();
    b.пуск();
    
    assert(a);
    assert(b);
    assert(c);
    assert(s0 == 1);
    assert(s1 == 1);
    assert(s2 == 0);
    
    for(цел i=0; i<20; i++)
    {
        c.пуск();
        a.пуск();
    }
    
    assert(a);
    assert(b);
    assert(c);
    assert(s0 == 21);
    assert(s1 == 1);
    assert(s2 == 20);
    
    delete a;
    delete b;
    delete c;
    
    скажифнс("Переключение контекста пройдено");
}
    
проц Тест2()
{
    скажифнс("Тестируются гнездовые контексты");
    КонтекстСтэка a, b, c;
    
    цел t0 = 0;
    цел t1 = 0;
    цел t2 = 0;
    
    a = new КонтекстСтэка(
    delegate void()
    {
        
        t0++;
        b.пуск();
        
    });
    
    b = new КонтекстСтэка(
    delegate void()
    {
        assert(t0 == 1);
        assert(t1 == 0);
        assert(t2 == 0);
        
        t1++;
        c.пуск();
        
    });
    
    c = new КонтекстСтэка(
    delegate void()
    {
        assert(t0 == 1);
        assert(t1 == 1);
        assert(t2 == 0);
        
        t2++;
    });
    
    assert(a);
    assert(b);
    assert(c);
    assert(t0 == 0);
    assert(t1 == 0);
    assert(t2 == 0);
    
    a.пуск();
    
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);
    
    assert(a);
    assert(b);
    assert(c);
    
    delete a;
    delete b;
    delete c;
    
    скажифнс("Гнездовые контексты пройдены");
}

проц Тест3()
{
	скажифнс("Тестируются базовые исключения");


	цел t0 = 0;
	цел t1 = 0;
	цел t2 = 0;

	assert(t0 == 0);
	assert(t1 == 0);
	assert(t2 == 0);

	try
	{

		try
		{
			throw new Исключение("Проверка");
			t2++;
		}
		catch(Исключение fx)
		{
			t1++;
			throw fx;
		}
	
		t2++;
	}
	catch(Исключение ex)
	{
		t0++;
		ex.print;
	}

	assert(t0 == 1);
	assert(t1 == 1);
	assert(t2 == 0);

	скажифнс("Базовые исключения поддерживаются");
}


version(Win32)
проц Тест4()
{
    скажифнс("Проверка исключений");
    КонтекстСтэка a, b, c;
    
    цел t0 = 0;
    цел t1 = 0;
    цел t2 = 0;
    
    скажифнс("t0 = %s\nt1 = %s\nt2 = %s", t0, t1, t2);
    
    a = new КонтекстСтэка(
    delegate void()
    {
        t0++;
        throw new Исключение("Исключение A");
        t0++;
    });
    
    b = new КонтекстСтэка(
    delegate void()
    {
        t1++;
        c.пуск();
        t1++;
    });
    
    c = new КонтекстСтэка(
    delegate void()
    {
        t2++;
        throw new Исключение("Исключение C");
        t2++;
    });
    
    assert(a);
    assert(b);
    assert(c);
    assert(t0 == 0);
    assert(t1 == 0);
    assert(t2 == 0);
    
    try
    {
        a.пуск();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print;
    }
    
    assert(a);
    assert(a.дайСостояние == ПСостояниеКонтекста.Завершён);
    assert(b);
    assert(c);
    assert(t0 == 1);
    assert(t1 == 0);
    assert(t2 == 0);
    
    try
    {
        b.пуск();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print;
    }
    
    скажифнс("blah2");
    
    assert(a);
    assert(b);
    assert(b.дайСостояние == ПСостояниеКонтекста.Завершён);
    assert(c);
    assert(c.дайСостояние == ПСостояниеКонтекста.Завершён);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);

	delete a;
	delete b;
	delete c;
    

	КонтекстСтэка t;
	цел q0 = 0;
	цел q1 = 0;

	t = new КонтекстСтэка(
	delegate void()
	{
		try
		{
			q0++;
			throw new Исключение("Исключение T");
			q0++;
		}
		catch(Исключение ex)
		{
			q1++;
			скажифнс("!!!!!!!!ПОЛУЧЕНО ИСКЛЮЧЕНИЕ!!!!!!!!");
			ex.print;
		}
	});


	assert(t);
	assert(q0 == 0);
	assert(q1 == 0);
	t.пуск();
	assert(t);
	assert(t.завершён);
	assert(q0 == 1);
	assert(q1 == 1);

	delete t;
   
    КонтекстСтэка d, e;
    цел s0 = 0;
    цел s1 = 0;
    
    d = new КонтекстСтэка(
    delegate void()
    {
        try
        {
            s0++;
            e.пуск();
            КонтекстСтэка.жни();
            s0++;
            e.пуск();
            s0++;
        }
        catch(Исключение ex)
        {
            ex.print;
        }
    });
    
    e = new КонтекстСтэка(
    delegate void()
    {
        s1++;
        КонтекстСтэка.жни();
        throw new Исключение("Исключение Е");
        s1++;
    });
    
    assert(d);
    assert(e);
    assert(s0 == 0);
    assert(s1 == 0);
    
    d.пуск();
    
    assert(d);
    assert(e);
    assert(s0 == 1);
    assert(s1 == 1);
    
    d.пуск();
    
    assert(d);
    assert(e);
    assert(s0 == 2);
    assert(s1 == 1);
    
    assert(d.завершён);
    assert(e.завершён);
    
    delete d;
    delete e;
    
    скажифнс("Исключения пройдены");
}

проц Тест5()
{
    скажифнс("Проверяется перезапуск");
    цел t0 = 0;
    цел t1 = 0;
    цел t2 = 0;
    
    КонтекстСтэка a = new КонтекстСтэка(
    delegate void()
    {
        t0++;
        КонтекстСтэка.жни();
        t1++;
        КонтекстСтэка.жни();
        t2++;
    });
    
    assert(a);
    assert(t0 == 0);
    assert(t1 == 0);
    assert(t2 == 0);
    
    a.пуск();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 0);
    assert(t2 == 0);
    
    a.пуск();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 0);
    
    a.пуск();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.перезапуск();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.пуск();
    assert(a);
    assert(t0 == 2);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.перезапуск();
    a.пуск();
    assert(a);
    assert(t0 == 3);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.пуск();
    assert(a);
    assert(t0 == 3);
    assert(t1 == 2);
    assert(t2 == 1);
    
    a.перезапуск();
    a.пуск();
    assert(a);
    assert(t0 == 4);
    assert(t1 == 2);
    assert(t2 == 1);
    
    delete a;
    
    скажифнс("Перезапуск пройден");
}

version (Win32)
проц Тест6()
{
    скажифнс("Проверка стандартных исключений");
    цел t = 0;
    
    КонтекстСтэка a = new КонтекстСтэка(
    delegate void()
    {
       auto tmp =  0xbadc0de;        
        t++;
    });
    
    assert(a);
    assert(t == 0);
    
    try
    {
        a.пуск();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print();
    }
    
    assert(a);
    assert(a.завершён);
    //assert(t == 0);
    
    delete a;
    
    
    скажифнс("Стандартные исключения протестированы");
}

проц Тест7()
{
    скажифнс("Тест на стресс памяти");
    
    const бцел РАЗМ_СТРЕССА = 500;
    
    КонтекстСтэка конткст[];
    конткст.length = РАЗМ_СТРЕССА;
    
    цел cnt0 = 0;
    цел cnt1 = 0;
    
    проц threadFunc()
    {
        cnt0++;
        КонтекстСтэка.жни;
        cnt1++;
    }
    
    foreach(inout КонтекстСтэка c; конткст)
    {
        c = new КонтекстСтэка(&threadFunc, МИН_РАЗМЕР_СТЕКА);
    }
    
    assert(cnt0 == 0);
    assert(cnt1 == 0);
    
    foreach(inout КонтекстСтэка c; конткст)
    {
        c.пуск;
    }
    
    assert(cnt0 == РАЗМ_СТРЕССА);
    assert(cnt1 == 0);
    
    foreach(inout КонтекстСтэка c; конткст)
    {
        c.пуск;
    }
    
    assert(cnt0 == РАЗМ_СТРЕССА);
    assert(cnt1 == РАЗМ_СТРЕССА);
    
    foreach(inout КонтекстСтэка c; конткст)
    {
        delete c;
    }
    
    assert(cnt0 == РАЗМ_СТРЕССА);
    assert(cnt1 == РАЗМ_СТРЕССА);
    
    скажифнс("Тест на стресс памяти пройден");
}

проц Тест8()
{
    скажифнс("Проверка плавающей точки");
    
    float f0 = 1.0;
    float f1 = 0.0;
    
    double d0 = 2.0;
    double d1 = 0.0;
    
    real r0 = 3.0;
    real r1 = 0.0;
    
    assert(f0 == 1.0);
    assert(f1 == 0.0);
    assert(d0 == 2.0);
    assert(d1 == 0.0);
    assert(r0 == 3.0);
    assert(r1 == 0.0);
    
    КонтекстСтэка a, b, c;
    
    a = new КонтекстСтэка(
    delegate void()
    {
        while(true)
        {
            f0 ++;
            d0 ++;
            r0 ++;
            
            КонтекстСтэка.жни();
        }
    });
    
    b = new КонтекстСтэка(
    delegate void()
    {
        while(true)
        {
            f1 = d0 + r0;
            d1 = f0 + r0;
            r1 = f0 + d0;
            
            КонтекстСтэка.жни();
        }
    });
    
    c = new КонтекстСтэка(
    delegate void()
    {
        while(true)
        {
            f0 *= d1;
            d0 *= r1;
            r0 *= f1;
            
            КонтекстСтэка.жни();
        }
    });
    
    a.пуск();
    assert(f0 == 2.0);
    assert(f1 == 0.0);
    assert(d0 == 3.0);
    assert(d1 == 0.0);
    assert(r0 == 4.0);
    assert(r1 == 0.0);
    
    b.пуск();
    assert(f0 == 2.0);
    assert(f1 == 7.0);
    assert(d0 == 3.0);
    assert(d1 == 6.0);
    assert(r0 == 4.0);
    assert(r1 == 5.0);
    
    c.пуск();
    assert(f0 == 12.0);
    assert(f1 == 7.0);
    assert(d0 == 15.0);
    assert(d1 == 6.0);
    assert(r0 == 28.0);
    assert(r1 == 5.0);
    
    a.пуск();
    assert(f0 == 13.0);
    assert(f1 == 7.0);
    assert(d0 == 16.0);
    assert(d1 == 6.0);
    assert(r0 == 29.0);
    assert(r1 == 5.0);
    
    скажифнс("Проверка плавающей точки пройдена");
}


version(x86) проц Тест9()
{
    скажифнс("Проверяются регистры");
    
    struct регистры
    {
        цел eax, ebx, ecx, edx;
        цел esi, edi;
        цел ebp, esp;

    }
    
    static регистры предш;
    static регистры следщ;
    static регистры г_предш;
    static регистры г_следщ;
    
    static СтэкНить рег_тест = new СтэкНить(
    delegate void() 
    {
        asm
        {
            naked;
            
            pushad;
            
            mov EBX, 1;
            mov ESI, 2;
            mov EDI, 3;
            
            mov [предш.ebx], EBX;
            mov [предш.esi], ESI;
            mov [предш.edi], EDI;
            mov [предш.ebp], EBP;
            mov [предш.esp], ESP;
            
            call СтэкНить.жни;
            
            mov [следщ.ebx], EBX;
            mov [следщ.esi], ESI;
            mov [следщ.edi], EDI;
            mov [следщ.ebp], EBP;
            mov [следщ.esp], ESP;
            
            popad;
        }
    });
    
    //Run the стэк контекст
    asm
    {
        naked;
        
        pushad;
        
        mov EBX, 10;
        mov ESI, 11;
        mov EDI, 12;
        
        mov [г_предш.ebx], EBX;
        mov [г_предш.esi], ESI;
        mov [г_предш.edi], EDI;
        mov [г_предш.ebp], EBP;
        mov [г_предш.esp], ESP;
        
        mov EAX, [рег_тест];
        call СтэкНить.пуск;
        
        mov [г_следщ.ebx], EBX;
        mov [г_следщ.esi], ESI;
        mov [г_следщ.edi], EDI;
        mov [г_следщ.ebp], EBP;
        mov [г_следщ.esp], ESP;
        
        popad;
    }
    
    
    //Make sure the регистры are byte for byte equal.
    assert(предш.ebx = 1);
    assert(предш.esi = 2);
    assert(предш.edi = 3);
    assert(предш == следщ);
    
    assert(г_предш.ebx = 10);
    assert(г_предш.esi = 11);
    assert(г_предш.edi = 12);
    assert(г_предш == г_следщ);
    
    скажифнс("Регистры пройдены!");
}


проц Тест10()
{
    скажифнс("Проверка бросьЖни");
    
    цел q0 = 0;
    
    КонтекстСтэка st0 = new КонтекстСтэка(
    delegate void()
    {
        q0++;
        КонтекстСтэка.бросьЖни(new Исключение("Проверяется бросьЖни"));
        q0++;
    });
    
    try
    {
        st0.пуск();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print();
    }
    
    assert(q0 == 1);
    assert(st0.готов);
    
    st0.пуск();
    assert(q0 == 2);
    assert(st0.завершён);
    
    скажифнс("бросьЖни пройден!");
}

проц Тест11()
{
    скажифнс("Проверяется безопасность нити");
    
    цел x = 0, y = 0;
    
    КонтекстСтэка sc0 = new КонтекстСтэка(
	delegate void()
    {
        while(true)
        {
            x++;
            КонтекстСтэка.жни;
        }
    });
    
    КонтекстСтэка sc1 = new КонтекстСтэка(
	delegate void()
    {
        while(true)
        {
            y++;
            КонтекстСтэка.жни;
        }
    });
    
    stdrus.Нить t0 = new stdrus.Нить(
    {
        for(цел i=0; i<10000; i++)
            sc0.пуск();
        
        return 0;
    });
    
    stdrus.Нить t1 = new stdrus.Нить(
    {
        for(цел i=0; i<10000; i++)
            sc1.пуск();
        
        return 0;
    });
    
    assert(sc0);
    assert(sc1);
    assert(t0);
    assert(t1);
    
    t0.старт;
    t1.старт;
    t0.жди;
    t1.жди;
    
    assert(x == 10000);
    assert(y == 10000);
    
    скажифнс("Безопасность нити пройдена!");
}

проц main()
{
Тест();
Тест1();
Тест2();
Тест3();
Тест4();
Тест5();
Тест6();
Тест7();
Тест8();
//Тест9();
Тест10();
//Тест11();
}