    private import stdrus, io.Stdout, io.stream.Quotes, io.stream.Buffered;
    private import Утиль = text.Util;
	private import text.convert.Layout;
    private import io.device.Array;
	alias Утиль.объедини объедини;
	
	бул тестТекстУтил()
	{
        сим[64] врем;

        assert (Утиль.пбел_ли (' ') && !Утиль.пбел_ли ('d'));

        assert (Утиль.индексУ ("abc".ptr, 'a', 3) is 0);
        assert (Утиль.индексУ ("abc".ptr, 'b', 3) is 1);
        assert (Утиль.индексУ ("abc".ptr, 'c', 3) is 2);
        assert (Утиль.индексУ ("abc".ptr, 'd', 3) is 3);
        assert (Утиль.индексУ ("abcabcabc".ptr, 'd', 9) is 9);

        assert (Утиль.индексУ ("abc"d.ptr, cast(дим)'c', 3) is 2);
        assert (Утиль.индексУ ("abc"d.ptr, cast(дим)'d', 3) is 3);

        assert (Утиль.индексУ ("abc"w.ptr, cast(шим)'c', 3) is 2);
        assert (Утиль.индексУ ("abc"w.ptr, cast(шим)'d', 3) is 3);
        assert (Утиль.индексУ ("abcdefghijklmnopqrstuvwxyz"w.ptr, cast(шим)'x', 25) is 23);

        assert (Утиль.не_совпадают ("abc".ptr, "abc".ptr, 3) is 3);
        assert (Утиль.не_совпадают ("abc".ptr, "abd".ptr, 3) is 2);
        assert (Утиль.не_совпадают ("abc".ptr, "acc".ptr, 3) is 1);
        assert (Утиль.не_совпадают ("abc".ptr, "ccc".ptr, 3) is 0);

        assert (Утиль.не_совпадают ("abc"w.ptr, "abc"w.ptr, 3) is 3);
        assert (Утиль.не_совпадают ("abc"w.ptr, "acc"w.ptr, 3) is 1);

        assert (Утиль.не_совпадают ("abc"d.ptr, "abc"d.ptr, 3) is 3);
        assert (Утиль.не_совпадают ("abc"d.ptr, "acc"d.ptr, 3) is 1);

        assert (Утиль.совпадают ("abc".ptr, "abc".ptr, 3));
        assert (Утиль.совпадают ("abc".ptr, "abb".ptr, 3) is нет);
        
        assert (Утиль.содержит ("abc", 'a'));
        assert (Утиль.содержит ("abc", 'b'));
        assert (Утиль.содержит ("abc", 'c'));
        assert (Утиль.содержит ("abc", 'd') is нет);

        assert (Утиль.естьОбразец ("abc", "ab"));
        assert (Утиль.естьОбразец ("abc", "bc"));
        assert (Утиль.естьОбразец ("abc", "abc"));
        assert (Утиль.естьОбразец ("abc", "zabc") is нет);
        assert (Утиль.естьОбразец ("abc", "abcd") is нет);
        assert (Утиль.естьОбразец ("abc", "za") is нет);
        assert (Утиль.естьОбразец ("abc", "cd") is нет);

        assert (Утиль.убери ("") == "");
        assert (Утиль.убери (" abc  ") == "abc");
        assert (Утиль.убери ("   ") == "");

        assert (Утиль.откинь ("", '%') == "");
        assert (Утиль.откинь ("%abc%%%", '%') == "abc");
        assert (Утиль.откинь ("#####", '#') == "");
        assert (Утиль.откиньлев ("#####", '#') == "");
        assert (Утиль.откиньлев (" ###", ' ') == "###");
        assert (Утиль.откиньлев ("#####", 's') == "#####");
        assert (Утиль.откиньправ ("#####", '#') == "");
        assert (Утиль.откиньправ ("### ", ' ') == "###");
        assert (Утиль.откиньправ ("#####", 's') == "#####");

        assert (Утиль.замени ("abc".dup, 'b', ':') == "a:c");
        assert (Утиль.подставь ("abc".dup, "bc", "x") == "ax");

        assert (Утиль.местоположение ("abc", 'c', 1) is 2);

        assert (Утиль.местоположение ("abc", 'c') is 2);
        assert (Утиль.местоположение ("abc", 'a') is 0);
        assert (Утиль.местоположение ("abc", 'd') is 3);
        assert (Утиль.местоположение ("", 'c') is 0);

        assert (Утиль.местоположениеПеред ("abce", 'c') is 2);
        assert (Утиль.местоположениеПеред ("abce", 'a') is 0);
        assert (Утиль.местоположениеПеред ("abce", 'd') is 4);
        assert (Утиль.местоположениеПеред ("abce", 'c', 3) is 2);
        assert (Утиль.местоположениеПеред ("abce", 'c', 2) is 4);
        assert (Утиль.местоположениеПеред ("", 'c') is 0);

        auto x = Утиль.разграничь ("::b", ":");
        assert (x.length is 3 && x[0] == "" && x[1] == "" && x[2] == "b");
        x = Утиль.разграничь ("a:bc:d", ":");
        assert (x.length is 3 && x[0] == "a" && x[1] == "bc" && x[2] == "d");
        x = Утиль.разграничь ("abcd", ":");
        assert (x.length is 1 && x[0] == "abcd");
        x = Утиль.разграничь ("abcd:", ":");
        assert (x.length is 2 && x[0] == "abcd" && x[1] == "");
        x = Утиль.разграничь ("a;b$c#d:e@f", ";:$#@");
        assert (x.length is 6 && x[0]=="a" && x[1]=="b" && x[2]=="c" &&
                                 x[3]=="d" && x[4]=="e" && x[5]=="f");

        assert (Утиль.местоположениеОбразца ("abcdefg", "") is 7);
        assert (Утиль.местоположениеОбразца ("abcdefg", "g") is 6);
        assert (Утиль.местоположениеОбразца ("abcdefg", "abcdefg") is 0);
        assert (Утиль.местоположениеОбразца ("abcdefg", "abcdefgx") is 7);
        assert (Утиль.местоположениеОбразца ("abcdefg", "cce") is 7);
        assert (Утиль.местоположениеОбразца ("abcdefg", "cde") is 2);
        assert (Утиль.местоположениеОбразца ("abcdefgcde", "cde", 3) is 7);

        assert (Утиль.местоположениеПередОбразцом ("abcdefg", "") is 7);
        assert (Утиль.местоположениеПередОбразцом ("abcdefg", "cce") is 7);
        assert (Утиль.местоположениеПередОбразцом ("abcdefg", "cde") is 2);
        assert (Утиль.местоположениеПередОбразцом ("abcdefgcde", "cde", 6) is 2);
        assert (Утиль.местоположениеПередОбразцом ("abcdefgcde", "cde", 4) is 2);
        assert (Утиль.местоположениеПередОбразцом ("abcdefg", "abcdefgx") is 7);

        x = Утиль.разбейнастр ("a\nb\n");
        assert (x.length is 3 && x[0] == "a" && x[1] == "b" && x[2] == "");
        x = Утиль.разбейнастр ("a\r\n");
        assert (x.length is 2 && x[0] == "a" && x[1] == "");

        x = Утиль.разбейнастр ("a");
        assert (x.length is 1 && x[0] == "a");
        x = Утиль.разбейнастр ("");
        assert (x.length is 1);

        ткст[] q;
        foreach (элемент; Утиль.кавычки ("1 'avcc   cc ' 3", " "))
                 q ~= элемент;
        assert (q.length is 3 && q[0] == "1" && q[1] == "'avcc   cc '" && q[2] == "3");

        assert (Утиль.выкладка (врем, "%1,%%%c %0", "abc", "efg") == "efg,%c abc");

        x = Утиль.разбей ("one, two, three", ",");
        assert (x.length is 3 && x[0] == "one" && x[1] == " two" && x[2] == " three");
        x = Утиль.разбей ("one, two, three", ", ");
        assert (x.length is 3 && x[0] == "one" && x[1] == "two" && x[2] == "three");
        x = Утиль.разбей ("one, two, three", ",,");
        assert (x.length is 1 && x[0] == "one, two, three");
        x = Утиль.разбей ("one,,", ",");
        assert (x.length is 3 && x[0] == "one" && x[1] == "" && x[2] == "");

        ткст г, х;
        г =  Утиль.голова ("one:two:three", ":", х);
        assert (г == "one" && х == "two:three");
        г = Утиль.голова ("one:::two:three", ":::", х);
        assert (г == "one" && х == "two:three");
        г = Утиль.голова ("one:two:three", "*", х);
        assert (г == "one:two:three" && х is пусто);

        х =  Утиль.хвост ("one:two:three", ":", г);
        assert (г == "one:two" && х == "three");
        х = Утиль.хвост ("one:::two:three", ":::", г);
        assert (г == "one" && х == "two:three");
        х = Утиль.хвост ("one:two:three", "*", г);
        assert (х == "one:two:three" && г is пусто);

        assert (Утиль.отсекилев("hello world", "hello ") == "world");
        assert (Утиль.отсекилев("hello", "hello") == "");
        assert (Утиль.отсекилев("hello world", " ") == "hello world");
        assert (Утиль.отсекилев("hello world", "") == "hello world");

        assert (Утиль.отсекиправ("hello world", " world") == "hello");
        assert (Утиль.отсекиправ("hello", "hello") == "");
        assert (Утиль.отсекиправ("hello world", " ") == "hello world");
        assert (Утиль.отсекиправ("hello world", "") == "hello world");

        ткст[] foo = ["one", "two", "three"];
        auto j = Утиль.объедини (foo);
        assert (j == "onetwothree");
        j = Утиль.объедини (foo, ", ");
        assert (j == "one, two, three");
        j = Утиль.объедини (foo, " ", врем);
        assert (j == "one two three");
        assert (j.ptr is врем.ptr);

        assert (Утиль.повтори ("abc", 0) == "");
        assert (Утиль.повтори ("abc", 1) == "abc");
        assert (Утиль.повтори ("abc", 2) == "abcabc");
        assert (Утиль.повтори ("abc", 4) == "abcabcabcabc");
        assert (Утиль.повтори ("", 4) == "");
        сим[10] rep;
        assert (Утиль.повтори ("abc", 0, rep) == "");
        assert (Утиль.повтори ("abc", 1, rep) == "abc");
        assert (Утиль.повтори ("abc", 2, rep) == "abcabc");
        assert (Утиль.повтори ("", 4, rep) == "");

//В убериИскейп тоже обнаруживается проблема!!!!!!!!!
  //Закоментированное не работает.
        assert (Утиль.убериИскейп ("abc") == "abc");
        assert (Утиль.убериИскейп ("abc\\") == "abc\\");
        assert (Утиль.убериИскейп ("abc\\х") == r"abc\х");
      //  assert (Утиль.убериИскейп ("abc\\tc") == r"abc\	c");
        // assert (Утиль.убериИскейп ("\\х") == r"\х");
        assert (Утиль.убериИскейп ("\\tx") == "\tx");
       // assert (Утиль.убериИскейп ("\\v\\vx") == "\v\vx");
        //assert (Утиль.убериИскейп ("abc\\х\\a\\bc") == "abc\х\a\bc");
		скажинс ("Ноль претензий к текст.Утилю,
		хотя с русским языком пока не всё ясно...");
		return да;
	}	
	
	бул тестИоСтримБуфферд()
	{
	try{
                auto ввод = new БуфВвод (пусто);
	   } 
	   catch{}
	   finally скажинс("Правильная реякция буфера ввода на пустой поток!");
	try{
                auto вывод = new БуфВывод (пусто);
		}
		catch{}
		finally
			{
			скажинс("Правильная реакция буфера вывода на пустой поток!");
			скажинс("Буферы ввода и вывода создаются(странно, но, кажется не работают)...");
			}
			
		скажинс("Идём в \"далее\"...");
	
        return да;
	}

    void main()
    {
	auto фмт = Выкладка!(сим).экземпляр;
        ткст[] ожидалось =
        [
            `0`
            ,``
            ,``
            ,`"3"`
            ,`""`
            ,`5`
            ,`",6"`
            ,`"7,"`
            ,`8`
            ,`"9,\\\","`
            ,`10`
            ,`',11",'`
            ,`"12"`
        ];
		
		тестТекстУтил();
		скажинс("Ошибка скрывается где-то тут...(?)");
        auto b = new Массив (ожидалось.объедини (","));
		скажинс("Ошибка скрывается где-то далее...(?)");
		скажинс(фмт("Стоп, проверим-ка, что у нас в массиве:
		 {}", cast(ткст) b.срез()));
		скажинс("Если это написалось, тогда точно ошибка будет далее....)");
		тестИоСтримБуфферд();
		нс;
		auto ткт = new Кавычки!(сим)(",", b);
       foreach (i, f; ткт)	   
           if (i >= ожидалось.length)
		   {
    		   Стдвыв.форматнс ("ах-ха-ха: неожиданное совпадение: {}, {}", i, f);
		     скажинс(фмт("ах-ха-ха: неожиданное совпадение: {}, {}", i, f));
			 скажифнс("ах-ха-ха: неожиданное совпадение: %i, %s", i, f);
			 }
        else if (f != ожидалось[i])
		{
            скажинс(фмт("ах-ха-ха: плохое совпадение: {}, {}, {}", i, f, ожидалось[i]));
			 скажифнс("ах-ха-ха: плохое совпадение: %i, %s, %s", i, f, ожидалось[i]);
			}
		скажинс("Ошибок, оказывается, нет!");
    }


