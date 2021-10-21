  import stdrus, cidrus;
  
  //БуфПоток
  //ФильтрПоток
  //БуфФайл
  
  проц main() {

	тестБуфФайл();	
	
  }
  
  проц тестБуфФайл()
  {
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