﻿module test2;
import dinrus, win, cidrus, runtime;
import com;


class БраузерИЭ
{
АктивОбъ акс;
     this() {
       акс = объАктив("InternetExplorer.Application");
     }

     проц видимый(Вар значение) {
       акс.установи("Visible", значение);
     }

     Вар видимый() {
       return акс.дай("Visible");
     }

     проц перейди(Вар урл) {
       акс.вызови("Navigate", урл);
     }
	 
	 проц состав(){акс.покажиСостав();}

 }
 
 БраузерИЭ объБраузерИЭ(){return new БраузерИЭ;}
 
проц тестКом() {
 /+  // Create an instance of the Excel application object and установи the Visible property to true.
   scope excel = new Обдис("Excel.Application");
   excel.установи("Visible", true);

   // Get the Workbooks property, then вызови the Add method.
   scope workbooks = excel.дай("Workbooks");
   scope workbook = workbooks.вызови("Add");

   // Get the Worksheet at index 1, then установи the Cells at column 5, row 3 to a string.
   scope worksheet = excel.дай("Worksheets", 1);
   worksheet.установи("Cells", 5, 3, "Письмецо от папочки!");
   +/
   scope ie = объБраузерИЭ;
   ie.видимый = вар(да);
   ie.перейди(вар("dinrus.gixx.ru"));
   ie.состав();
   нс; нс; нс;
   скажинс("
   ************************************************************************
   Если у Вас открылся браузер Intertnet Explorer с попыткой обратиться к
   Dinrus.Gixx.ru, значит, АктивОбъ проверку прошёл.
   ************************************************************************
   ");
   нс; нс; нс;
    return;
   
 }
 
  
проц тестКОМ() {
IShellDispatch оболочка = Shell.создайКо!(IShellDispatch);
  высвободиПосле (оболочка, {

    // Get a reference to the Desktop folder.
    Folder папка;
    оболочка.NameSpace(вВар(ShellSpecialFolderConstants.ssfDESKTOP), папка);
    if (папка !is пусто) {
      высвободиПосле (папка, {

        // Get the collection of FolderItem objects.
        FolderItems элты;
        папка.Items(элты);
        if (элты !is пусто) {
          высвободиПосле (элты, {

            // Iterate through all the FolderItem objects.
            цел счёт;
            элты.get_Count(счёт);
            for (цел и = 0; и < счёт; и++) {
              FolderItem элемент;
              элты.Item(вВар(и), элемент);
              if (элемент !is пусто) {
                высвободиПосле (элемент, {

                  // Get the name of the элемент.
                  wchar* bstrName;
                  элемент.get_Name(bstrName);

                  // Convert the BSTR to a UTF-8 string. bstr.toString frees the BSTR.
                  char[] name = бткстВТкст(bstrName);
                  // Display the результат.
                  скажинс(name);
                });
              }
            }
          });
        }
      });
    }
  });
}

проц тестГуид() 
{
    скажинс(фм("ГУИДом ИПоток является %s", tpl.com.ууид_у!(sys.WinIfaces.ИПоток).stringof));
	auto x = tpl.com.ууид_у!(sys.WinIfaces.ИПоток).вТкст;
	скажинс(фм("ГУИДом ИПоток является %s", x));
	x = tpl.com.ууид_у!(sys.WinIfaces.ИДиспетчер).вТкст;
	скажинс(фм("ГУИДом ИДиспетчер является %s", x));
	 return;
  }


проц тестРПФайл() {
	const т_мера K = 1024;
	т_мера win = 64*K; // assume the page size is 64K
	
	РПФайл mf = new РПФайл("testing.txt", РПФайл.Режим.ЧтенЗапНов, 100*K, пусто, win);
	ббайт[] стр = cast(ббайт[])"1234567890";
	ббайт[] данные = cast(ббайт[])mf[0 .. 10];
	данные[] = стр[];
	assert( mf[0 .. 10] == стр );
	данные = cast(ббайт[])mf[50 .. 60];
	данные[] = стр[];
	assert( mf[50 .. 60] == стр );
	ббайт[] data2 = cast(ббайт[])mf[20*K .. 60*K];
	assert( data2.length == 40*K );
	assert( data2[length-1] == 0 );
	mf[100*K-1] = cast(ббайт)'b';
	data2 = cast(ббайт[])mf[21*K .. 100*K];
	assert( data2.length == 79*K );
	assert( data2[length-1] == 'b' );
	delete mf;
	скажинс("РПФайл мурлычет...");
	удалиФайл("testing.txt");	

	// Create anonymous mapping
	auto test = new РПФайл(null, РПФайл.Режим.ЧтенЗапНов, 1024*1024, пусто);
	пз;
	 return;
}

  проц тестСФайл() {
  нс;
  скажинс("Проверка СФайл");
    фук f = откройфл(".\\stream.txt","w, ccs=UTF-8");
	скажинс("странно...1");
    assert(f !is пусто);
	скажинс("странно2");
    СФайл файл = new СФайл(f,ПФРежим.Вывод);
	скажинс("странно3");
    цел и = 666;    
    assert(файл.записываемый());
	скажинс("странно4");
    файл.пишиСтр("Testing stream.d:");
    файл.пишиТкст("Hello, world!");	
    файл.пиши(и);    
	скажинс("странно ... записано");
	пауза;
	скажинс(фм("%s", файл.позиция()));
      assert(файл.позиция() == 19 + 13 + 4);   
	 скажинс("странно1");
    файл.закрой();
	скажинс("странно2");
    // no operations are allowed when file is closed
    assert(!файл.читаемый() && !файл.записываемый() && !файл.сканируемый());
	скажинс("странно3");
    f = откройфл(".\\stream.txt","r, ccs=UTF-8");
	скажинс("странно4");
    файл = new СФайл(f,ПФРежим.Ввод, да);
    // should be ok to read
    assert(файл.читаемый);
	скажинс("странно5");
    auto строка = файл.читайСтр();
	скажинс("странно6");
    auto exp = "Testing stream.d:";
    assert(строка[0] == 'T');
	скажинс("странно7");
    assert(строка.length == exp.length);
	скажинс("странно8");
    assert(!сравни(строка, "Testing stream.d:"));
    скажинс("странно9");
    файл.сместись(7, ППозКурсора.Тек);    
      assert(файл.позиция() == 19 + 7);
    скажинс("странно10");
    assert(!сравни(файл.читайТкст(6), "world!"));
    и = 0; файл.читай(и);
    assert(и == 666);
    assert(файл.позиция() == 19 + 13 + 4);    
    // we must be at the end of файл
    файл.закрой();
	скажинс("странно");
	  f = откройфл(".\\stream.txt","w+, ccs=UTF-8");
    файл = new СФайл(f,ПФРежим.Ввод|ПФРежим.Вывод, да);
    файл.пишиСтр("Тестируем stream.d:");
    файл.пишиСтр("Ещё строка");
    файл.пишиСтр("");
    файл.пишиСтр("А перед этой была пустая");
    файл.позиция = 0;
    ткст[] строки;
    foreach(char[] строка; файл) {
      строки ~= строка.dup;
    }
	скажинс(фм("Длина массива строк = %s", строки.length));
    assert( строки.length == 5 );
	скажинс("странно");
    assert( строки[0] == "Тестируем stream.d:");
	скажинс("странно");
    assert( строки[1] == "Ещё строка");
	скажинс("странно");
    assert( строки[2] == "");
	скажинс("странно");
    assert( строки[3] == "А перед этой была пустая");
	скажинс("странно...");
    файл.позиция = 0;
	скажинс("странно");
    строки = new ткст[5];
	скажинс(фм("цикл"));
    foreach(бдол n, ткст строка; файл) {
      строки[cast(т_мера)(n-1)] = строка.dup;
    }
	скажинс(фм("после цикла"));
    assert( строки[0] == "Тестируем stream.d:");
    assert( строки[1] == "Ещё строка");
    assert( строки[2] == "");
    assert( строки[3] == "А перед этой была пустая");
	скажинс("Закрываем файл...");
    файл.закрой();
	скажинс("проверьте правильность записи в файле stream.txt...");
	пз;
    файл.удали(".\\stream.txt");
	нс;
	if(!естьФайл(".\\stream.txt"))скажинс("Файл действительно удалён");
	скажинс("странно однако!!!!!!!!!!
	Класс СФайл также вполне рабочий. Вива!)))");
	 return;
 }
 
 
проц тестФайл()
{

	скажинс("\nТестирование класса Файл\n");
    Файл файл = new Файл;
	скажинс("файл .... уже инициирован");
    цел и = 666;
	скажинс("нач...");	
    файл.создай(".\\stream.txt", ПФРежим.Ввод);    
	скажинс("файл .\\stream.txt создан");
	assert(файл.записываемый);
	скажинс("попытка записи файла ...");
	 файл.пишиСтр("Testing stream.d:");
	скажинс("записана строка");
	файл.пишиТкст("Hello, world!");
	скажинс("записан текст Hello, world!");
	
    файл.пиши(и);
   
      assert(файл.позиция() == 19 + 13 + 4); скажинс("позиция верна ");
    
    // we must be at the end of файл
    assert(файл.кф()); скажинс("да, мы в конце файла");
    файл.закрой();
    // no operations are allowed when файл is закройd
    assert(!файл.читаемый && !файл.записываемый && !файл.сканируемый); скажинс("файл читаем, записываем и сканируем ");
    файл.открой(".\\stream.txt");
    // should be ok to читай
   // if(файл.проверьЧитаемость())скажинс("Файл читаемый!");
    assert(файл.доступно == файл.размер); скажинс("файл доступен по всему размеру");
    ткст строка = файл.читайСтр();	
    ткст exp = "Testing stream.d:";
    assert(строка[0] == 'T');
    assert(строка.length == exp.length);
    assert(!сравни(строка, "Testing stream.d:"));
    // jump over "Hello, "
    файл.сместись(7, ППозКурсора.Тек);	
    version (Win32)
      assert(файл.позиция() == 19 + 7);
    version (Posix)
      assert(файл.позиция() == 18 + 7);
    assert(!сравни(файл.читайТкст(6), "world!"));	
    и = 0; файл.читай(и);
    assert(и == 666);
    // ткст#1 + ткст#2 + цел should give exacly that
    version (Win32)
      assert(файл.позиция() == 19 + 13 + 4);
    version (Posix)
      assert(файл.позиция() == 18 + 13 + 4);
    // we must be at the end of файл
    assert(файл.кф());
    файл.закрой();	
    файл.открой(".\\stream.txt",ПФРежим.ВыводНов | ПФРежим.Ввод);
	файл.пишиСтр("Тестируем stream.d:");
    файл.пишиСтр("Ещё строка");
    файл.пишиСтр("");
    файл.пишиСтр("А перед этой была пустая");
    файл.позиция(0);
    ткст[] строки;	
    foreach(ткст строка; файл) {
	 цел инд = 0;
    	  скажинс("в буфер 'строки' из файла считана строка ..."~строка.dup);
		  строки ~= строка.dup;		  
    }
	скажинс("проверка точности считанной в буфер информации 
	Массив'строки' на данный момент  содержит:\n<<<<<<<<");
	  foreach(стр; строки)
	{
	  скажи(стр.dup);
	  нс;
    }
	скажинс(">>>>>>>>\n");
	//кст[] стрр = new ткст[4];
	assert( строки.length == 4, фм("Длина строк не 4, а %d", строки.length));
	скажинс("длина строк действительно 4");
    assert( строки[0] == "Тестируем stream.d:", 
			": \nошибка при тестировании строки,\nвместо Тестируем stream.d: в ней находится текст "~строки[0]);
    assert( строки[1] == "Ещё строка");
    assert( строки[2] == "");
    assert( строки[3] == "А перед этой была пустая");
	скажинс("Текст всех строк совпадает с записанным в файл -
	Класс Файл вполне рабочий//!!!
	Проверьте правильность записи в файле d:\\stream.txt
	пока программа находится на паузе (файл будет удалён)...");
	пз;
	файл.удали(".\\stream.txt");
	нс;
	if(!естьФайл(".\\stream.txt"))скажинс("Файл действительно удалён");
	пз;
	 return;
}

  проц тестБуфФайл() {

	скажинс("\nПроверка работоспособности класса БуфФайл\n");
    БуфФайл буффл = объБуфФайл();
	скажинс("Экземпляр класса БуфФайл успешно инициализован");
    цел и = 666;
    буффл.создай(".\\mstream.txt");
    скажинс("Файл создан");
    assert(буффл.записываемый);
    буффл.пишиСтр("Testing stream.d:");
    буффл.пишиТкст("Hello, world!");
    буффл.пиши(и);
    // ткст#1 + ткст#2 + цел should give exacly that
    version (Win32)
	      assert(буффл.позиция() == 19 + 13 + 4);
	        // we must be at the end of буффл
    assert(буффл.кф());
    дол прежднРазм = cast(дол)буффл.размер();
    буффл.закрой();
	   // когда буффл закрыт, недопустимы никакие операции
	   assert(!буффл.читаемый && !буффл.записываемый && !буффл.сканируемый);
	//пауза;
	  буффл.открой(".\\mstream.txt");
	   // should be ok to читай
    assert(буффл.читаемый);
		  // тестируем берис/отдайс и размер()
    сим c1 = буффл.берис();
	//скажинс(фм(c1));
    буффл.отдайс(c1);
	//assert( буффл.размер() == прежднРазм );
	//assert(!сравни(буффл.читайСтр(), "Testing stream.d:"));
    // jump over "Hello, "
    буффл.сместись(7, ППозКурсора.Тек);  
	//скажинс(фм(буффл.позиция()));
	скажинс(буффл.вТкст());
      assert(буффл.позиция() == 8);
		скажинс(буффл.читайТкст(6));
    assert(сравни(буффл.читайТкст(6), "stream"));
    и = 0; буффл.читай(и);
    assert(и != 666);
    // ткст#1 + ткст#2 + цел should give exacly that 
		скажинс(фм(буффл.позиция()));
      assert(буффл.позиция() == 24 );   
    // we must be at the end of буффл    
    буффл.закрой();
	//НайдиЗакрой(&буффл);
	скажинс("проверьте правильность записи в файле .\\mstream.txt...");
	
    буффл.удали(".\\mstream.txt");
	 return;
	
	
  }
  
    проц тестПотокЭндианец()
	{
    ПотокПамяти m;
	скажинс("Файл создан");
    m = new ПотокПамяти ();
	скажинс("Файл создан");
    ПотокЭндианец em = new ПотокЭндианец(m,Эндиан.Биг);
	скажинс("Файл создан");
    бцел x = 0x11223344;
    em.пиши(x);	
    assert( m.данные[0] == 0x11 );
    assert( m.данные[1] == 0x22 );
    assert( m.данные[2] == 0x33 );
    assert( m.данные[3] == 0x44 );
    em.позиция(0);
    бкрат x2 = 0x5566;
    em.пиши(x2);
    assert( m.данные[0] == 0x55 );
   assert( m.данные[1] == 0x66 );
    em.позиция(0);
    static ббайт[12] x3 = [1,2,3,4,5,6,7,8,9,10,11,12];
    em.фиксируйПБ(x3.ptr,12);
    if (_эндиан == Эндиан.Литл) {
      assert( x3[0] == 12 ); 
      assert( x3[1] == 11 );
      assert( x3[2] == 10 );
      assert( x3[4] == 8 );
      assert( x3[5] == 7 );
      assert( x3[6] == 6 );
      assert( x3[8] == 4 );
      assert( x3[9] == 3 );
      assert( x3[10] == 2 );
      assert( x3[11] == 1 );
	  скажинс("ЛЕ подтвержден\n");
    }
	em.выведиЭндиан();
    em.устЭндиан(Эндиан.Литл);
	em.выведиЭндиан();
    em.пиши(x);
	assert( m.данные[0] == 0x44 );
    assert( m.данные[1] == 0x33 );
    assert( m.данные[2] == 0x22 );
   assert( m.данные[3] == 0x11 );
    em.позиция(0);
    em.пиши(x2);
	assert( m.данные[0] == 0x66 );
    assert( m.данные[1] == 0x55 );
    em.позиция(0);
    em.фиксируйПБ(x3.ptr,12);
    if (_эндиан == Эндиан.Биг) {
      assert( x3[0] == 12 );
      assert( x3[1] == 11 );
      assert( x3[2] == 10 );
      assert( x3[4] == 8 );
      assert( x3[5] == 7 );
      assert( x3[6] == 6 );
      assert( x3[8] == 4 );
      assert( x3[9] == 3 );
      assert( x3[10] == 2 );
      assert( x3[11] == 1 );
    }
    em.пишиМПБ(МПБ.Ю8);
	
    assert( m.позиция() == 3 );
   assert( m.данные[0] == 0xEF );
    assert( m.данные[1] == 0xBB );
    assert( m.данные[2] == 0xBF );
	em.позиция(3);
	em.выведиЭндиан();
    em.пишиТкст ("Hello, world");
    em.позиция(0);
    assert( m.позиция() == 0 );
    assert( em.читайМПБ == МПБ.Ю8 );
    assert( m.позиция() == 3 );
	assert( m.данные[3] == 'H' );
    assert( em.берис() == 'H' );
    em.позиция(0);
    em.пишиМПБ(МПБ.Ю16БЕ);
    assert( m.данные[0] == 0xFE );
    assert( m.данные[1] == 0xFF );
    em.позиция(0);
    em.пишиМПБ(МПБ.Ю16ЛЕ);
    assert( m.данные[0] == 0xFF );
    assert( m.данные[1] == 0xFE );
    em.позиция(0);
    em.пишиТкст ("Hello, world");
    em.позиция(0);
	
    //assert( em.читайМПБ == -1 );	
    assert( em.берис() == 'H' );
	assert( em.берис() == 'e' );
    assert( em.берис() == 'l' );
    assert( em.берис() == 'l' );
   em.позиция(0);	
    return;
	
  }

/* Test the ТПотокМассив */
проц тестТПотокМассив() {
  сим[100] буф;
  ТПотокМассив!(ткст) m;

  m = new ТПотокМассив!(ткст) (буф);
  //assert (m.открыт_ли);
  m.пишиТкст ("Hello, world");
  assert (m.позиция () == 12);
  assert (m.доступно == 88);
  assert (m.измпозУст (0) == 0);
  assert (m.доступно == 100);
  assert (m.измпозТек (4) == 4);
  assert (m.доступно == 96);
  assert (m.измпозКон (-8) == 92);
  assert (m.доступно == 8);
  assert (m.размер () == 100);
  assert (m.измпозУст (4) == 4);
  assert (m.читайТкст (4) == "o, w");
  m.пишиТкст ("ie");
  assert (буф[0..12] == "Hello, wield");
  assert (m.позиция == 10);
  assert (m.доступно == 90);
  assert (m.размер () == 100);
  скажинс("ТПотокМассив дышит однако...");
   return;
  
}


  проц тестПотокПамяти() {
    ПотокПамяти m;

	 скажинс("Проверка ПотокаПамяти\n");
    m = new ПотокПамяти ();
	 скажинс("Поток инициирован\n");
	// m.открытый(да);
    //assert (m.открытый);
    m.пишиТкст ("Hello, world");
    assert (m.позиция () == 12);
    assert (m.измпозУст (0) == 0);
    assert (m.доступно == 12);
    assert (m.измпозТек (4) == 4);
    assert (m.доступно == 8);
    assert (m.измпозКон (-8) == 4);
    assert (m.доступно == 8);
    assert (m.размер () == 12);
    assert (m.читайТкст (4) == "o, w");
    m.пишиТкст ("ie");
    assert (cast(ткст) m.данные () == "Hello, wield");
    m.измпозКон (0);
    m.пишиТкст ("Foo");
    assert (m.позиция () == 15);
    assert (m.доступно == 0);
    m.пишиТкст ("Foo foo foo foo foo foo foo");
    assert (m.позиция () == 42);
    m.позиция(0);
    assert (m.доступно == 42);
    m.пишиф("%d %d %s",100,345,"hello");
    auto стр = m.вТкст;
    assert (стр[0..13] == "100 345 hello", стр[0 .. 13]);
    assert (m.доступно == 29);
    assert (m.позиция == 13);
    
    ПотокПамяти m2;
    m.позиция(3);
    m2 = new ПотокПамяти ();
    m2.пишиТкст("before");
    m2.копируй_из(m,10);
    стр = m2.вТкст;
    assert (стр[0..16] == "before 345 hello");
    m2.позиция(3);
    m2.копируй_из(m);
    auto str2 = m.вТкст;
    стр = m2.вТкст;
    assert (стр == ("bef" ~ str2));
	скажинс("И ПотокПамяти живой...");
	 return;
	
  }

///
  проц тестРПФайлПоток() {
  
  скажинс("\n Тестируем класс РПФайлПоток");
  РПФайл mf = new РПФайл(".\\testing.txt",РПФайл.Режим.ЧтенЗапНов,100,пусто);
  РПФайлПоток m;
  m = new РПФайлПоток (mf);
  m.пишиТкст ("Hello, world");
  assert (m.позиция() == 12);
  assert (m.измпозУст(0) == 0);
  assert (m.измпозТек(4) == 4);
  assert (m.измпозКон(-8) == 92);
  assert (m.размер() == 100);
  assert (m.измпозУст(4) == 4);
  try{
  assert (m.читайТкст(4) == "o, w", фм("\nКонтролёр прочёл не \"o, w\",\n а другое, \"%s\"", m.читайТкст(4)));
  }
  catch(ПроверОшиб пош){пош.сбрось;}
  m.пишиТкст ("ie");
  ббайт[] dd = m.данные();
    try{
  assert (cast(ткст) dd[0 .. 12] == "Hello, wield", фм("\nвместо ожидаемого \"Hello, wield\", \n обнаруживается %s", cast(ткст) dd[0 .. 12]));
    }
  catch(ПроверОшиб пош2){пош2.сбрось;}
  m.позиция(12);
  m.пишиТкст ("Foo");
  assert (m.позиция () == 15);
  m.пишиТкст ("Foo foo foo foo foo foo foo");
  assert (m.позиция () == 42);
  mf.слей();
  m.закрой();
  //delete mf;
  скажинс("РПФайлПоток был создан и закрыт");
  пз();
  m.удали(".\\testing.txt");
  
  return;
  }
  

 проц тестПотокСрез() {
    ПотокПамяти памп;
    ПотокСрез п;

	скажинс("\nВходим в ПотокСрез для его проверки");
    памп = new ПотокПамяти (cast(ткст)"Hello, world");
	скажинс("Создаём ПотокПамяти");
    п = new ПотокСрез (памп, 4, 8);
	скажинс("Создаём ПотокСрез");
    assert (п.размер () == 4);
    assert (памп.позиция () == 0);
	//скажинс(фм("%s", п.позиция ()));
    assert (п.позиция () == 0);
    assert (памп.доступно == 12);
    assert (п.доступно == 4);

    assert (п.пишиБлок (cast(сим *) "Vroom", 5) == 4);
    assert (памп.позиция () == 0);
    assert (п.позиция () == 4);
    assert (памп.доступно == 12);
    assert (п.доступно == 0);
    assert (п.измпозКон (-2) == 2);
    assert (п.доступно == 2);
    assert (п.измпозКон (2) == 4);
    assert (п.доступно == 0);
    assert (памп.позиция () == 0);
    assert (памп.доступно == 12);

    памп.измпозКон(0);
    памп.пишиТкст("\nBlaho");
    assert (памп.позиция == 18);
    assert (памп.доступно == 0);
    assert (п.позиция == 4);
    assert (п.доступно == 0);
	//delete п;
	//скажинс(памп.вТкст());

    п = new ПотокСрез (памп, 4);
	assert (п.размер () == 14);
	скажинс(п.вТкст());
    assert (п.вТкст () == "Vrooorld\nBlaho");////
    п.измпозКон (0);
    assert (п.доступно == 0);

    п.пишиТкст (", etcetera.");
    assert (п.позиция () == 25);
    assert (п.измпозУст (0) == 0);
    assert (п.размер () == 25);
    assert (памп.позиция () == 18);
    assert (памп.размер () == 29);
    assert (памп.вТкст() == "HellVrooorld\nBlaho, etcetera.");
	скажинс("ПотокСрез что-то мычит...
	Это, кажется, "~памп.вТкст()~"
	Следовательно, класс ПотокСрез также жизнеспособен\nВива!)))))))))");
	 return;
  }

  import sys.memory;
проц тестПам()
{
Куча куча;
куча.новая();
проверьЗаписывается(куча.укз);
скажинс("Куча записывается");
куча.блокируй();
куча.разблокируй();
бцел фп;
фп = *cast(бцел*)  куча.размести(300);
скажинс(фп.sizeof);
скажинс("Размещение работает");
/*
try
{
	try
	{
	int КОН = 234;
	проверьЗаписывается(cast(ук) КОН);
	}
	catch(Исключение и){и.выведи;}
}
catch(Исключение и){и.выведи;} //Кэтч не срабатывает...

*/

}

проц слабУк()
        {
                auto o = new Объект;
                auto r = new СлабУк(o);
                assert (r() is o);
                delete o;
                assert (r() is пусто);
                auto r1 = сделайСлабУк;
                assert (r1.получи);
				смСтат;
				r1.сотри();
                assert (r1() is пусто);
				скажинс("Тест слабУк удачен\n");
        }

  цел main(){
  
  скажинс("НАЧАЛО ПРОВЕРКИ БАЗОВЫХ КЛАССОВ И СТРУКТУР ЯЗЫКА ДИНРУС");
   нс; нс; нс;
   
  скажинс("Значение переменной среды DINRUS="~дайПеремСреды("DINRUS"));
   тестКом();
скажинс(о_ЦПУ);
 нс; нс; нс;
  тестГуид();
//ОкноСооб(пусто, stdrus.вЮ16(stdrus.вТкст(получиСовместнПам())), "Process2", ПСооб.Ок);
тестТПотокМассив(); //работает
тестРПФайл();//работает
тестПотокЭндианец();//av
тестРПФайлПоток();//av
тестПотокПамяти();//!!!!!!!!!!!!!Win32 Exception
скажинс("Тест работоспособности некоторых шаблонов \n");
    assert(ПарсируйБцел!("1234abc").значение == "1234");
    assert(ПарсируйБцел!("1234abc").остаток == "abc");
    assert(ПарсируйЦел!("-1234abc").значение == "-1234");
    assert(ПарсируйЦел!("-1234abc").остаток == "abc");
    ткст п = Форматируй!("hel%slo", "world", -138, 'c', да);
    assert(п == "helworldlo-138ctrue");
скажинс("Тест шаблонов удачен\n");
тестФайл();//av ошибка при записи  - переполнение стека (тормозные колодки менять надо!)
тестСФайл();//av

тестПам();
слабУк();

  тестПотокСрез();//!!!!!!!!!!!!
 // тестКом();
  
  скажинс("\nПРОВЕРКА БАЗОВЫХ КЛАССОВ И СТРУКТУР ЯЗЫКА ДИНРУС ЗАВЕРШЕНА\n");

  пауза;
 //Два мозоля((((
 //тестБуфФайл(); //Пока не поддаётся исправлению(((
  //тестКОМ();
 



//av
  //Спи(20000);
  //смСобери();
return 0;
}