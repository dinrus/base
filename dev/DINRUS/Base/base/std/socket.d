﻿module std.socket;
import tpl.stream, exception;

abstract class Адрес
{
	protected адрессок* имя();
	protected цел длинаИм();
	ПСемействоАдресов семействоАдресов();	/// Family of this address.
	ткст вТкст();		/// Human readable ткст representing this address.
}

export extern (D) 
 class Протокол
{

export:

	ППротокол тип;
	ткст имя;
	ткст[] алиасы;

	проц заполни(win.протзап* прото)
	{
	тип = cast(ППротокол)прото.прот;
		имя = std.string.toString(прото.имя).dup;

		int i;
		for(i = 0;; i++)
		{
			if(!прото.алиасы[i])
				break;
		}

		if(i)
		{
			алиасы = new ткст[i];
			for(i = 0; i != алиасы.length; i++)
			{
			    алиасы[i] =
				std.string.toString(прото.алиасы[i]).dup;
			}
		}
		else
		{
			алиасы = null;
		}

	}
	бул дайПротоколПоИмени(ткст имя)
	{

	win.протзап* прото;
		прото = cast(протзап*) дайпротпоимени(имя);
		if(!прото)
			return нет;
		заполни(прото);
		return да;
	}

	бул дайПротоколПоТипу(ППротокол тип)
	{
	протзап* прото;
		прото =cast(протзап*) дайпротпономеру(тип);
		if(!прото)
			return нет;
		заполни(прото);
		return да;
	}
}

export extern (D)
  class Служба
{
export:

	ткст имя;
	ткст[] алиасы;
	бкрат порт;
	ткст имяПротокола;

	проц заполни(служзап* служба)
	{
		имя = std.string.toString(служба.имя).dup;
		порт = с8хбк(cast(бкрат)служба.порт);
		имяПротокола = std.string.toString(служба.прот).dup;

		int i;
		for(i = 0;; i++)
		{
			if(!служба.алиасы[i])
				break;
		}

		if(i)
		{
			алиасы = new ткст[i];
			for(i = 0; i != алиасы.length; i++)
			{
                            алиасы[i] =
                                std.string.toString(служба.алиасы[i]).dup;
			}
		}
		else
		{
			алиасы = null;
		}
	}
	бул дайСлужбуПоИмени(ткст имя, ткст имяПротокола)
	{
	служзап* serv;
		serv =cast(служзап*) дайслужбупоимени(имя, имяПротокола);
		if(!serv)
			return нет;
		заполни(serv);
		return да;
	}

	бул дайСлужбуПоИмени(ткст имя)
	{
	служзап* serv;
		serv =cast(служзап*) дайслужбупоимени(имя , null);
		if(!serv)
			return нет;
		заполни(serv);
		return да;
	}

	бул дайСлужбуПоПорту(бкрат порт, ткст имяПротокола)
	{
	служзап* serv;
		serv =cast(служзап*) дайслужбупопорту(порт, имяПротокола);
		if(!serv)
			return нет;
		заполни(serv);
		return да;
	}
	бул дайСлужбуПоПорту(бкрат порт)
	{
	служзап* serv;
		serv =cast(служзап*) дайслужбупопорту(порт, null);
		if(!serv)
			return нет;
		заполни(serv);
		return да;
	}
}

export extern (D)
  class ИнтернетХост
{
export:

	ткст имя;
	ткст[] алиасы;
	бцел[] списокАдр;

	проц реальнаяХостзап(хостзап* хз)
	{
	if(хз.типадр != cast(int)ПСемействоАдресов.ИНЕТ || хз.длина != 4)
			throw new ХостИскл("Несовпадение семейства адресов", _lasterr());
	}

	проц заполни(хостзап* хз)
	{
	int i;
		char* p;

		имя = std.string.toString(хз.имя).dup;

		for(i = 0;; i++)
		{
			p = хз.алиасы[i];
			if(!p)
				break;
		}

		if(i)
		{
			алиасы = new ткст[i];
			for(i = 0; i != алиасы.length; i++)
			{
                            алиасы[i] =
                                std.string.toString(хз.алиасы[i]).dup;
			}
		}
		else
		{
			алиасы = null;
		}

		for(i = 0;; i++)
		{
			p = хз.списадр[i];
			if(!p)
				break;
		}

		if(i)
		{
			списокАдр = new бцел[i];
			for(i = 0; i != списокАдр.length; i++)
			{
				списокАдр[i] = с8хбц(*(cast(бцел*)хз.списадр[i]));
			}
		}
		else
		{
			списокАдр = null;
		}
	}

	бул дайХостПоИмени(ткст имя)
	{
	хостзап* he;
                synchronized(this.classinfo) he = cast(хостзап*)дайхостпоимени(имя);
		if(!he)
			return нет;
		 реальнаяХостзап(he);
		заполни(he);
		return да;
	}
	бул дайХостПоАдр(бцел адр)
	{
	бцел x = х8сбц(адр);
		хостзап* he;
                synchronized(this.classinfo) he = cast(хостзап*) дайхостпоадресу(&x, 4, cast(int)ПСемействоАдресов.ИНЕТ);
		if(!he)
			return нет;
		реальнаяХостзап(he);
		заполни(he);
		return да;
	}
	бул дайХостПоАдр(ткст адр)
	{
	бцел x = адр_инет(адр);
		хостзап* he;
                synchronized(this.classinfo) he = cast(хостзап*) дайхостпоадресу(&x, 4, cast(int)ПСемействоАдресов.ИНЕТ);
		if(!he)
			return нет;
		реальнаяХостзап(he);
		заполни(he);
		return да;
	}
}


export extern (D) 
 class НеизвестныйАдрес: Адрес
{
export:
	адрессок ас;


	override адрессок* имя()
	{
		return &ас;
	}


	override цел длинаИм()
	{
		return ас.sizeof;
	}


	override ПСемействоАдресов семействоАдресов()
	{
		return cast(ПСемействоАдресов) ас.семейство;
	}


	override ткст вТкст()
	{
		return std.string.toString("Неизвестно");
	}
}

export extern (D) 
 class ИнтернетАдрес: Адрес
{
	export:
	адрессок_ин иас;


	override адрессок* имя()
	{
		return cast(адрессок*)&иас;
	}


	override цел длинаИм()
	{
		return иас.sizeof;
	}


	this()
	{
	}

	const бцел АДР_ЛЮБОЙ = ПИнАдр.Любой;	/// Любое адресное число IPv4.
	const бцел АДР_НЕУК = ПИнАдр.Неук;	/// Любое неверное адресное число IPv4.
	const бкрат ПОРТ_ЛЮБОЙ = 0;	/// Любое число порта IPv4.

	override ПСемействоАдресов семействоАдресов()
	{
	return cast(ПСемействоАдресов) ПСемействоАдресов.ИНЕТ;
	}

	бкрат порт()
	{return с8хбк(cast(uint16_t) иас.порт);}

	бцел адр()
	{return с8хбц(cast(бцел) иас.адр.с_адр);}

	this(ткст адр, бкрат порт)
	{
		бцел uiaddr = разбор(адр);
		if(АДР_НЕУК == uiaddr)
		{
		    ИнтернетХост ih = new ИнтернетХост;
			if(!ih.дайХостПоИмени(адр))
				               throw new СокетИскл(
                                 "Неразборчивый хост '" ~ адр ~ "'");
			uiaddr = ih.списокАдр[0];
		}
		иас.адр.с_адр = х8сбц(cast(бцел) uiaddr);
		иас.порт = х8сбк(cast(uint16_t) порт);
	}

	this(бцел адр, бкрат порт)
	{
		иас.адр.с_адр = х8сбц(адр);
		иас.порт = х8сбк(порт);
	}

	this(бкрат порт)
	{
		иас.адр.с_адр = 0; //любой, "0.0.0.0"
		иас.порт = х8сбк(порт);
	}

	ткст вАдрТкст()
	{
		return инетс8а(cast(адрес_ин) иас.адр).dup;
	}

	ткст вПортТкст()
	{
		return std.string.toString(порт());
	}

	override ткст вТкст()
	{return вАдрТкст()~":"~вПортТкст();}

	static бцел разбор(ткст адр)
	{
		return с8хбц(адр_инет(адр));
	}
}


export extern (D)
  class НаборСокетов
{
private	бцел наибсок;
private	набор_уд набор;

private	бцел счёт()
{return  набор.счёт_уд;}

	export:

	this(бцел макс)
	{
		наибсок = макс;
		переуст();
	}

	this()
	{
		this(РАЗМНАБ_УД);
	}

	проц переуст()
	{
		УД_ОБНУЛИ(cast(набор_уд*) &набор);
	}

	проц прибавь(т_сокет с)
	in
	{
		assert(счёт < наибсок);
	}
	body
	{
		УД_УСТАНОВИ(с, cast(набор_уд*) &набор);
	}

	проц прибавь(Сокет с)
	{
		прибавь(с.сок);
	}

	проц удали(т_сокет с)
	{
		УД_УДАЛИ(с, cast(набор_уд*) &набор);

	}

	проц удали(Сокет с)
	{
		удали(с.сок);
	}

	цел вНаборе(т_сокет с)
	{
		return УД_УСТАНОВЛЕН(с, cast(набор_уд*) &набор);
	}

	цел вНаборе(Сокет с)
	{
		return вНаборе(с.сок);
	}

	бцел макс()
	{
		return наибсок;
	}

	набор_уд* вНабор_уд()
	{
		return cast(набор_уд*) &набор;
	}

	цел выберич()
	{
			return счёт;
	}

}


private цел _lasterr()
	{
		return ВСАДайПоследнююОшибку();
	}

export extern (D)
  class Сокет
{
private
{
т_сокет сок;
ПСемействоАдресов _семейство;
бул _блокируемый = нет;
}

export:

this(ПСемействоАдресов са, ПТипСок тип, ППротокол протокол)
	{
		сок = cast(т_сокет)сокет(са, тип, протокол);
		if(сок == т_сокет.init)
			throw new СокетИскл("Не удаётся создать сокет", _lasterr());
		_семейство = са;
	}

this(ПСемействоАдресов са, ПТипСок тип)
	{
		this(са, тип, cast(ППротокол)0); // Pseudo protocol number.
	}

this(ПСемействоАдресов са, ПТипСок тип, ткст имяПротокола)
	{
		протзап* прото;
		прото = дайпротпоимени(имяПротокола);
		if(!прото)
			throw new СокетИскл("Не удаётся найти протокол", _lasterr());
		this(са, тип, cast(ППротокол) прото.прот);
	}

	~this()
	{
		закрой();
	}

protected this(){}

т_сокет Ук()
	{
		return сок;
	}

бул блокируемый()
	{
		return _блокируемый;
	}

проц блокируемый(бул б)
	{
			бцел num = !б;
			if(-1 == ввктлсок(сок, ВВФСБВВ, &num))
				goto err;
			_блокируемый = б;
		return; // Success.

		err:
		throw new СокетИскл("Не удаётся установить сокет блокируемым", _lasterr());
	}

ПСемействоАдресов семействоАдресов() // getter
	{
		return _семейство;
	}

бул жив_ли() // getter
	{
		цел тип, размтипа = тип.sizeof;
		return !дайопцсок(cast(СОКЕТ) сок, ППротокол.СОКЕТ, ПОпцияСокета.Тип, cast(char*)&тип, &размтипа);
	}

проц свяжи(Адрес адр)
	{
		if(-1 == свяжисок(cast(СОКЕТ) сок, cast(адрессок*) адр.имя(), адр.длинаИм()))
			throw new СокетИскл("Не удаётся связать сокет", _lasterr());
	}

проц подключись(Адрес к)
	{
		if(-1 == подключи(cast(СОКЕТ) сок, cast(адрессок*) к.имя(), к.длинаИм()))
		{
			цел err;
			err = _lasterr();

			if(!блокируемый)
			{
				if(ПВинСокОш.Блокировано == err)
						return;

			}
			throw new СокетИскл("Не удаётся подключить сокет", err);
		}
	}

проц слушай(цел backlog)
	{
		if(-1 == win.слушай(cast(СОКЕТ) сок, backlog))
			throw new СокетИскл("Не удаётся прослушивание сокета", _lasterr());
	}

Сокет принимающий()
	{
		return new Сокет;
	}

Сокет прими()
	{
		т_сокет newsock;
		//newsock = cast(socket_t).accept(sock, null, null); // DMD 0.101 ошибка: found '(' when expecting ';' following 'statement
		alias win.пусти topaccept;
		newsock = cast(т_сокет)topaccept(cast(СОКЕТ) сок, null, null);
		if(т_сокет.init == newsock)
			throw new СокетИскл("Не удаётся принят подключение через сокет", _lasterr());

		Сокет newSocket;
		try
		{
			newSocket = принимающий();
			assert(newSocket.сок == т_сокет.init);

			newSocket.сок = newsock;
			version(Win32)
				newSocket._блокируемый = _блокируемый; //inherits blocking mode
			newSocket._семейство = _семейство; //same семейство
		}
		catch(Объект o)
		{
			_close(newsock);
			throw o;
		}

		return newSocket;
	}

	/// Disables sends and/or receives.
	проц экстрзак(ПЭкстрЗакрытиеСокета how)
	{
		win.экстрзак(cast(СОКЕТ) сок,  how);
	}


	private static проц _close(т_сокет сок)
	{
		закройсок(cast(СОКЕТ) сок);
	}

	проц закрой()
	{
		_close(сок);
		сок = т_сокет.init;
	}


	private Адрес новОбъектСемейства()
	{
		Адрес результат;
		switch(_семейство)
		{
			case cast(ПСемействоАдресов) ПСемействоАдресов.ИНЕТ:
				результат = new ИнтернетАдрес;
				break;

			default:
				результат = new НеизвестныйАдрес;
		}
		return результат;
	}


static ткст имяХоста() // getter
	{
		char[256] результат; // Host names are limited to 255 chaрс.
		if(-1 == дайимяхоста(результат, результат.length))
			throw new СокетИскл("Не удаётся получить имя хоста", _lasterr());
		return std.string.toString(cast(char*)результат).dup;
	}

Адрес удалённыйАдрес()
	{
		Адрес адр = новОбъектСемейства();
		цел длинаИм = адр.длинаИм();
		if(-1 == дайимяпира(cast(СОКЕТ)сок, cast(адрессок*) адр.имя(), &длинаИм))
			throw new СокетИскл("Не удаётся получить адрес удалённого сокета", _lasterr());
		assert(адр.семействоАдресов() == _семейство);
		return адр;
	}

Адрес локальныйАдрес()
	{
		Адрес адр = новОбъектСемейства();
		цел длинаИм = адр.длинаИм();
		if(-1 == дайимясок(cast(СОКЕТ) сок, cast(адрессок*) адр.имя(), &длинаИм))
			throw new СокетИскл("Не удаётся получить адрес локального сокета", _lasterr());
		assert(адр.семействоАдресов() == _семейство);
		return адр;
	}

	const цел ОШИБКА = -1;

	цел шли(проц[] буф, ПФлагиСокета флаги)
	{
                флаги |= ПФлагиСокета.БезСигнала;
		цел sent = win.шли(сок, буф.ptr, буф.length, флаги);
		return sent;
	}

	цел шли(проц[] буф)
	{
		return шли(буф, ПФлагиСокета.БезСигнала);
	}

	цел шли_на(проц[] буф, ПФлагиСокета флаги, Адрес to)
	{
                флаги |= ПФлагиСокета.БезСигнала;
		цел sent = win.шли_на(cast(СОКЕТ) сок, буф.ptr, буф.length, флаги,cast(адрессок*) to.имя(), to.длинаИм());
		return sent;
	}

	цел шли_на(проц[] буф, Адрес to)
	{
		return шли_на(буф, ПФлагиСокета.Неук, to);
	}

	цел шли_на(проц[] буф, ПФлагиСокета флаги)
	{
                флаги |= ПФлагиСокета.БезСигнала;
		цел sent = win.шли_на(cast(СОКЕТ) сок, буф.ptr, буф.length, флаги, null, нет);
		return sent;
	}

	цел шли_на(проц[] буф)
	{
		return шли_на(буф, ПФлагиСокета.Неук);
	}

	цел получи(проц[] буф, ПФлагиСокета флаги)
	{
		if(!буф.length) //return 0 and don't think the connection closed
			return 0;
		цел read = win.прими(cast(СОКЕТ) сок, буф.ptr, буф.length, флаги);
		// if(!read) //connection closed
		return read;
	}

	цел получи(проц[] буф)
	{
		return получи(буф, ПФлагиСокета.Неук);
	}

	цел получи_от(проц[] буф, ПФлагиСокета флаги, out Адрес от)
	{
		if(!буф.length) //return 0 and don't think the connection closed
			return 0;
		от = новОбъектСемейства();
		цел длинаИм = от.длинаИм();
		цел read = win.прими_от(cast(СОКЕТ) сок, буф.ptr, буф.length, флаги, cast(адрессок*) от.имя(), &длинаИм);
		assert(от.семействоАдресов() == _семейство);
		// if(!read) //connection closed
		return read;
	}

	цел получи_от(проц[] буф, out Адрес от)
	{
		return получи_от(буф, ПФлагиСокета.Неук, от);
	}

	цел получи_от(проц[] буф, ПФлагиСокета флаги)
	{
		if(!буф.length) //return 0 and don't think the connection closed
			return 0;
		цел read = прими_от(cast(СОКЕТ) сок, буф.ptr, буф.length, флаги, null, null);
		// if(!read) //connection closed
		return read;
	}

цел получи_от(проц[] буф)
	{
		return получи_от(буф, ПФлагиСокета.Неук);
	}

цел дайОпцию(ППротокол уровень, ПОпцияСокета опция, проц[] результат)
	{
		цел len = результат.length;
		if(-1 == дайопцсок(cast(СОКЕТ) сок, уровень, опция, результат.ptr, &len))
			throw new СокетИскл("Не удаётся получить опцию сокета", _lasterr());
		return len;
	}

цел дайОпцию(ППротокол уровень, ПОпцияСокета опция, out цел результат)
	{
		return дайОпцию(уровень, опция, (&результат)[0 .. 1]);
	}

цел дайОпцию(ППротокол уровень, ПОпцияСокета опция, out заминка результат)
	{
		return дайОпцию(уровень, опция, (&результат)[0 .. 1]);
	}

проц установиОпцию(ППротокол уровень, ПОпцияСокета опция, проц[] значение)
	{
		if(-1 == установиопцсок(сок, уровень, опция, значение.ptr, значение.length))
			throw new СокетИскл("Не удаётся  установить опцию сокета", _lasterr());
	}

проц установиОпцию(ППротокол уровень, ПОпцияСокета опция, цел значение)
	{
		установиОпцию(уровень, опция, (&значение)[0 .. 1]);
	}

проц установиОпцию(ППротокол уровень, ПОпцияСокета опция, заминка значение)
	{
	установиОпцию(уровень, опция, (&значение)[0 .. 1]);
	}

static цел выбери(НаборСокетов checkRead, НаборСокетов checkWrite, НаборСокетов checkError, win.значврем* tv)
	in
	{
		//make sure none of the НаборСокетов'т are the same object
		if(checkRead)
		{
			assert(checkRead !is checkWrite);
			assert(checkRead !is checkError);
		}
		if(checkWrite)
		{
			assert(checkWrite !is checkError);
		}
	}
	body
	{
		набор_уд* fr, fw, fe;
		цел n = 0;

		version(Win32)
		{
			// Windows has a problem with empty набор_уд`т that aren't null.
			fr = (checkRead && checkRead.счёт()) ? checkRead.вНабор_уд() : null;
			fw = (checkWrite && checkWrite.счёт()) ? checkWrite.вНабор_уд() : null;
			fe = (checkError && checkError.счёт()) ? checkError.вНабор_уд() : null;
		}
		else
		{
			if(checkRead)
			{
				fr = checkRead.вНабор_уд();
				n = checkRead.выберич();
			}
			else
			{
				fr = null;
			}

			if(checkWrite)
			{
				fw = checkWrite.вНабор_уд();
				цел _n;
				_n = checkWrite.выберич();
				if(_n > n)
					n = _n;
			}
			else
			{
				fw = null;
			}

			if(checkError)
			{
				fe = checkError.вНабор_уд();
				цел _n;
				_n = checkError.выберич();
				if(_n > n)
					n = _n;
			}
			else
			{
				fe = null;
			}
		}

		цел результат = win.выбери(n, cast(набор_уд*) fr, cast(набор_уд*) fw, cast(набор_уд*) fe, cast(win.значврем*)tv);

		version(Win32)
		{
			if(-1 == результат && ВСАДайПоследнююОшибку() == ПВинСокОш.Прервано)
				return -1;
		}
		else version(Posix)
		{
			if(-1 == результат && дайНомош() == EINTR)
				return -1;
		}
		else
		{
			static assert(0);
		}

		if(-1 == результат)
			throw new СокетИскл("Ошибка выбора сокета", _lasterr());

		return результат;
	}

static цел выбери(НаборСокетов checkRead, НаборСокетов checkWrite, НаборСокетов checkError, цел микросекунды)
	{
	    win.значврем tv;
	    tv.секунды = микросекунды / 1_000_000;
	    tv.микросекунды = микросекунды % 1_000_000;
	    return выбери(checkRead, checkWrite, checkError, &tv);
	}

static цел выбери(НаборСокетов checkRead, НаборСокетов checkWrite, НаборСокетов checkError)
	{
		return выбери(checkRead, checkWrite, checkError, null);
	}

}


export extern (D) 
class ПутСокет: Сокет
{
export:

	this(ПСемействоАдресов семейство)
	{
		super(семейство, ПТипСок.Поток, ППротокол.ПУТ);
	}

	this()
	{
		this(ПСемействоАдресов.ИНЕТ);
	}

	this(Адрес подкл_к)
	{
		this(подкл_к.семействоАдресов());
		подключись(подкл_к);
	}
}

export extern (D)
 class ПпдСокет: Сокет
{
export:

	this(ПСемействоАдресов семейство)
	{
		super(семейство, ПТипСок.ДГрамма, ППротокол.ППД);
	}

	this()
	{
		this(ПСемействоАдресов.ИНЕТ);
	}
}

export extern (D) 
class СокетПоток: Поток
{
    private:
	Сокет сок;

    export:

	this(Сокет сок, ПРежимФайла режим)
	{
		if(режим & ПРежимФайла.Ввод)
			читаемый(да);
		if(режим & ПРежимФайла.Вывод)
			записываемый(да);

		this.сок = сок;
	}

	this(Сокет сок)
	{
		записываемый(да); читаемый(да);
		this.сок = сок;
	}

	Сокет сокет()
	{
		return сок;
	}

	override т_мера читайБлок(ук _буфер, т_мера размер)
	{
	  ббайт* буфер = cast(ббайт*)адаптВхоУкз(_буфер);
	  проверьЧитаемость();

	  if (размер == 0)
	    return размер;

	  auto len = сок.получи(буфер[0 .. размер]);
	  читатьдоКФ(cast(бул)(len == 0));
	  if (len == сок.ОШИБКА)
	    len = 0;
	  return len;
	}

		override т_мера пишиБлок(ук _буфер, т_мера размер)
	{
	  ббайт* буфер = cast(ббайт*)адаптВхоУкз(_буфер);
	  проверьЗаписываемость(this.toString());

	  if (размер == 0)
	    return размер;

	  auto len = сок.шли(буфер[0 .. размер]);
	  читатьдоКФ(cast(бул)(len == 0));
	  if (len == сок.ОШИБКА)
	    len = 0;
	  return len;
	}

	override бдол сместись(дол смещение, ППозКурсора куда)
	{
		throw new Исключение("Перемещение по сокету невозможно.");
		//return 0;
	}

	override ткст вТкст()
	{
		return сок.вТкст();
	}

	override проц закрой()
	{
		сок.закрой();
	}
}


static this()
	{

	ВИНСОКДАН вд;

		цел знач;
		знач = ВСАСтарт(0x2020, &вд);
		if(знач) // Request Winsock 2.2 for IPv6.
			throw new СокетИскл("Не удалось инициализовать библиотеку сокетов", знач);
	}


	        static ~this()
        {
                ВСАЧистка();
        }

