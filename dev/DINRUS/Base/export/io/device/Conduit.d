﻿module io.device.Conduit;

private import thread;
public  import io.model;

extern(D) :

class Провод : ИПровод
{
        this();
        ~this ();	
		проц устПланировщик(Фибра.Планировщик п);
		Фибра.Планировщик дайПланировщик();		
         override ткст вТкст (); 
         т_мера размерБуфера ();
         override т_мера читай (проц[] приёмн);
         override т_мера пиши (проц [] ист);
         проц открепи ();
        final проц таймаут (бцел миллисек);
        final бцел таймаут ();
        бул жив_ли ();
        final ИПровод провод ();       
        ИПотокВВ слей () ;
        проц закрой ();
        final проц ошибка (ткст сооб);        
        final ИПотокВвода ввод ();
        final ИПотокВывода вывод ();
        final Провод помести (проц[] ист);
        final Провод получи (проц[] приёмн);
        final Провод отмотай ();
        ИПотокВывода копируй (ИПотокВвода ист, т_мера макс = -1);
        дол сместись (дол смещение, Якорь якорь = Якорь.Нач);
		
		ткст текст(T=сим) (т_мера макс = -1)
		{
        return cast(T[]) загрузи (макс);
		}
		
 		static проц[] загрузи (ИПотокВвода ист, т_мера макс=-1);
        проц[] загрузи (т_мера макс = -1);        
        static проц помести (проц[] ист, ИПотокВывода вывод);
        static проц получи (проц[] приёмн, ИПотокВвода ввод);
        static т_мера перемести (ИПотокВвода ист, ИПотокВывода приёмн, т_мера макс=-1);
}

class ФильтрВвода :ИПотокВвода // Провод
{
        this (ИПотокВвода источник);
        ИПровод провод ();
        т_мера читай (проц[] приёмн);
        проц[] загрузи (т_мера макс = -1);
        ИПотокВВ слей ();
        дол сместись (дол смещение, Якорь якорь = Якорь.Нач);
        ИПотокВвода ввод();
        проц ввод(ИПотокВвода поток);		alias ввод исток;		
        проц закрой ();
}

class ФильтрВывода : ИПотокВывода //Провод
{
       this (ИПотокВывода сток);
        ИПровод провод ();
        т_мера пиши (проц[] ист);
        ИПотокВывода копируй (ИПотокВвода ист, т_мера макс = -1);
        ИПотокВВ слей ();
        дол сместись (дол смещение, Якорь якорь = Якорь.Нач);
        ИПотокВывода вывод();
		проц вывод(ИПотокВывода поток);	alias вывод сток;
        проц закрой ();
}