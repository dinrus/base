module sys.common;

public  import sys.WinConsts, sys.WinIfaces, sys.WinStructs, sys.WinFuncs;

version (WinIO)
        {
        
		//public  import io.Console;
		
        
		public static
		{
		ук КОНСВВОД;
		ук КОНСВЫВОД;
		ук КОНСОШ;
		бцел ИДПРОЦЕССА;
		ук   УКНАПРОЦЕСС;
		ук   УКНАНИТЬ;
		}	

		static ук _вызывающийПроцесс;
		const бцел ДУБЛИРУЙ_ПРАВА_ДОСТУПА = 0x00000002;

		//======================================================================
		//УТИЛИТНЫЕ ФУНКЦИИ

		export extern (C) проц укВызывающегоПроцесса(ук процесс){_вызывающийПроцесс = процесс;}

		export extern (C) бцел идБазовогоПроцесса(){return GetCurrentProcessId();}

		export extern(C) ук адаптВыхУкз(ук укз)
		{
						  ук    hndl;

			if(_вызывающийПроцесс)  ДублируйДескр( УКНАПРОЦЕСС, укз, _вызывающийПроцесс, &hndl, ППраваДоступа.ГенерноеЧтение| ППраваДоступа.ГенернаяЗапись, да, ДУБЛИРУЙ_ПРАВА_ДОСТУПА );
				  else return укз;
						return hndl;
		}

		export extern(C) ук адаптВхоУкз(ук укз)
		{
						  ук   hndl;

			if(_вызывающийПроцесс)  ДублируйДескр( _вызывающийПроцесс, укз, УКНАПРОЦЕСС, &hndl, ППраваДоступа.ГенерноеЧтение| ППраваДоступа.ГенернаяЗапись, да, ДУБЛИРУЙ_ПРАВА_ДОСТУПА );
				  else return укз;
						return hndl;
		}

		export extern (C) проц максПриоритетПроцессу()
		 {
				SetPriorityClass(УКНАПРОЦЕСС, 0x00000080);
				SetThreadPriority(УКНАНИТЬ,15);
		}
//================================================
		


		static this()
		{
		ИДПРОЦЕССА =  GetCurrentProcessId();
		УКНАПРОЦЕСС = cast(ук) OpenProcess(0x000F0000|0x00100000|0x0FFF,false,ИДПРОЦЕССА);
		УКНАНИТЬ  = GetCurrentThread();
					КОНСВВОД = ДайСтдДескр(ПСтд.Ввод);
					//КОНСВЫВОД = ДайСтдДескр(cast(ПСтд) 0xfffffff5);
					КОНСВЫВОД = ДайСтдДескр(ПСтд.Вывод);
					КОНСОШ = ДайСтдДескр(ПСтд.Ошибка);
		}		
		
}
/+
version (linux)
        {
        public import sys.linux.linux;
        alias sys.linux.linux posix;
        }

version (darwin)
        {
        public import sys.darwin.darwin;
        alias sys.darwin.darwin posix;
        }
version (freebsd)
        {
        public import sys.freebsd.freebsd;
        alias sys.freebsd.freebsd posix;
        }
version (solaris)
        {
        public import sys.solaris.solaris;
        alias sys.solaris.solaris posix;
        }
        +/  