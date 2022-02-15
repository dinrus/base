module sttls;
import st.tls, stdrus, sys.common;

extern(Windows) бцел ФункцНити(ук данные) 
{ 
   
 
// Initialize the НЛХ index для этого thread. 
 
   данные = cast(ук) РазместиЛок(ППамять.Лук, 256); 
   if (! УстановиЗначениеНлх(индНлх, данные)) 
      ошибка("ошибка функции УстановиЗначениеНлх"); 
 
   скажифнс("ФункцНити%d:нить %d: данные=%x\n", номерНити, ДайИдТекущейНити(), данные); 
   номерНити++;
   
 
   ОбщаяФункцияНлх(); 
 
// Release the dynamic memory перед the thread returns. 
 
   данные = ДайЗначениеНлх(индНлх); 
   if (данные != cast(ук) 0) 
      ОсвободиЛок(cast(лук) данные); 
 
   return 0; 
} 

void main()
{

 auto нить = cast(Нить*) СоздайНить(cast(БЕЗАТРЫ*) пусто, // default security attributes 
         0,                           // use default stack size 
         &ФункцНити, // thread function 
         пусто,                    // no thread function argument 
         cast(ПФлагСоздПроц) 0,                       // use default creation flags 
         &ИДНити);              // returns thread identifier 
 
   // Check the return value for success. 
      if (нить[и] == пусто) 
         ошибка("ошибка функции СоздайНить"); 
    //Attempt to test out the нлх
    auto нлх = new НитеЛок!(цел);

    //Make sure default значения work
    assert(нлх.знач == 0);

    //Init нлх to something
    нлх.знач = 333;

    //Созд some threads to mess with the нлх
    Нить a = new Нить(
    {
        нлх.знач = 10;
        нить.жди(1);
        assert(нлх.знач == 10);

        нлх.знач = 1010;
        нить.жди(1);
        assert(нлх.знач == 1010);

        return 0;
    });

    Нить b = new Нить(
    {
        нлх.знач = 20;
        нить.жди(1);
        assert(нлх.знач == 20);

        нлх.знач = 2020;
        нить.жди(1);
        assert(нлх.знач == 2020);

        return 0;
    });

    a.старт;
    b.старт;

    //Wait until they have have finished
    a.жди;
    b.жди;

    //Make sure the value was preserved
    assert(нлх.знач == 333);

    //Try out structs
    struct TestStruct
    {
        цел x = 10;
        real r = 20.0;
        byte b = 3;
    }

    auto tls2 = new НитеЛок!(TestStruct);

    assert(tls2.знач.x == 10);
    assert(tls2.знач.r == 20.0);
    assert(tls2.знач.b == 3);

    Нить x = new Нить(
    {
        assert(tls2.знач.x == 10);

        TestStruct nv;
        nv.x = 20;
        tls2.знач = nv;

        assert(tls2.знач.x == 20);

        return 0;
    });

    x.старт();
    x.жди();

    assert(tls2.знач.x == 10);

    //Try out объекты
    static class TestClass
    {
        цел x = 10;
    }

    auto tls3 = new НитеЛок!(TestClass)(new TestClass);

    assert(tls3.знач.x == 10);

    Нить y = new Нить(
    {
        tls3.знач.x ++;

        tls3.знач = new TestClass;
        tls3.знач.x = 2020;

        assert(tls3.знач.x == 2020);

        return 0;
    });

    y.старт;
    y.жди;

    assert(tls3.знач.x == 11);
}
