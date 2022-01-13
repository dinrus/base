module sys.com.activex;
/***************************************************************
 * $HeadURL: http://svn.dsource.org/projects/core32/trunk/activex/activex.d $
 * $Revision: 39 $
 * $Дата: 2009-05-23 02:44:15 +0400 (Сб, 23 май 2009) $
 * $Author: l8night $
 */
import stdrus, tpl.args;
import sys.WinIfaces, sys.uuid, sys.WinStructs, sys.WinFuncs, sys.WinConsts;
alias stdrus.фм фм;

//debug = AXO;

extern(C) цел wcslen(шим*);

template CPtr(T) {
	version (D_Version2) {
		// миксин используется, чтобы не вызывать синтактических ошибок при D1
		mixin("alias const(T)* CPtr;");
	} else {
		alias T* CPtr;
	}
}
//////////КОНСТАНТЫ

alias CPtr!(ГУИД) REFGUID, REFIID, REFCLSID, REFFMTID;
alias ВАРИАНТ АРГВАРИАНТА;


alias цел ДиспИД;//DISPID, MEMBERID
alias бцел ТипГСсылки;//HREFTYPE
	
enum SYSKIND {
	SYS_WIN16,
	SYS_WIN32,
	SYS_MAC
}

/////////////////////////////////////ФУНКЦИИ
extern(Windows)
{
	HRESULT CoCreateInstance(REFCLSID, LPUNKNOWN, DWORD, REFIID, PVOID*);
}
/////////////////////////СТРУКТУРЫ
/*
union BINDPTR {
	ФУНКЦДЕСКР* lpfuncdesc;
	LPVARDESC lpvardesc;
	ITypeComp lptcomp;
}
alias BINDPTR* LPBINDPTR;

struct TLIBATTR {
	ГУИД гуид;
	ЛКИД лкид;
	SYSKIND syskind;
	WORD номСтаршВерс;
	WORD номМладшВерс;
	WORD wLibFlags;
}
alias TLIBATTR* LPTLIBATTR;

struct VARDESC {
	ИДЧЛЕНА идЧлена;
	шим* схема;
	union {
		ULONG oInst;
		ВАРИАНТ* укЗначВар;
	}
	ЭЛЕМДЕСКР elemdescVar;
	бкрат wVarFlags;
	ПВидПерем видПерем;
}
alias VARDESC* LPVARDESC;

struct PARAMDESCEX {
	бцел cBytes;
	АРГВАРИАНТА varDefaultValue;
}
alias PARAMDESCEX* LPPARAMDESCEX;
*/
/////////////////////////////////////////////////
alias IUnknown LPUNKNOWN;

export class ИсклАктивОбъ: Исключение
{
export this(ткст сооб){super(сооб);}
}

export class АктивОбъ
{
 private
{
     static ЛКИД дефЛКИД;
	 ИИнфОТипе [ФУНКЦДЕСКР *] всеФункДески;
     ИИнфОТипе инфОТипе;
     ИДиспетчер укДиспетчер;
     ОпредЧлена[] всеЧлены;
     ткст [ ДиспИД ] методы;
     ткст [ ДиспИД ] получатели;
     SHORT [ ДиспИД ] возвраты;
     ткст [ ДиспИД ] установщики;
     ткст [ ДиспИД ] установщикиПоСсыл;
}

    static this()
    {
        дефЛКИД = ДайДефЛКИДПользователя();
        ИнициализуйКо(пусто);
    }

    static ~this()
    {
        ДеинициализуйКо();
    }

  public struct ОпредЧлена
    {
        ткст имя;
        ДиспИД диспид;
        ПВидВызова инвРод;
        ФУНКЦДЕСКР* функДескУк;
    }

  export  this(ткст имяПриложения)
    {
        КЛСИД клсид = КЛСИДИзПрогИД_(имяПриложения);
        HRESULT hr = CoCreateInstance( cast(REFCLSID) &клсид, cast(LPUNKNOWN) пусто, cast(DWORD) ПКлассКонтекста.СерверКонтекстаКласса, cast(REFIID) &IID_IDispatch,cast(PVOID*) &укДиспетчер);
        загрузиСостав();
    }

  export  ~this()
    {
        foreach (ФУНКЦДЕСКР* функДескУк, ИИнфОТипе иот; всеФункДески)
            иот.ReleaseFuncDesc(cast(ФУНКЦДЕСКР *)функДескУк);
    }

 export   void загрузиСостав()
    {
        HRESULT hr = укДиспетчер.GetTypeInfo(cast(бцел) 0, дефЛКИД, &инфОТипе);
        загрузиСостав(инфОТипе);
    }

  export  void загрузиСостав(ИИнфОТипе укИнфОТипе)
    {
        ТИПАТР* укАтрТипа;
        HRESULT hr = укИнфОТипе.GetTypeAttr(&укАтрТипа);

        for(бцел i;i<укАтрТипа.имплТипы;++i)
        {
            ТипГСсылки укТипСсыл;
            hr = укИнфОТипе.GetRefTypeOfImplType(i, &укТипСсыл);
            ИИнфОТипе  ppTInfo;
            hr = укИнфОТипе.GetRefTypeInfo(укТипСсыл, &ppTInfo);
            загрузиСостав(ppTInfo);
        }

        for(бцел i;i<укАтрТипа.функи;++i)
        {
            ОпредЧлена чл;
            hr = укИнфОТипе.GetFuncDesc(i, &чл.функДескУк);
            ФУНКЦДЕСКР * функДескУк=чл.функДескУк;

            всеФункДески[функДескУк] = укИнфОТипе;

            шим * имяМетода;
            hr = укИнфОТипе.GetDocumentation(функДескУк.идЧлена, &имяМетода, пусто, пусто, пусто);

            шим [] врем;
            бцел l=wcslen(имяМетода);
            врем.length=l;
            for (бцел j;j<l;++j)
                врем[j]=имяМетода[j];
            ткст theName_i=вЮ8(врем);
            ткст этоИмя = theName_i.dup;

            чл.имя = этоИмя;
            чл.инвРод = функДескУк.типвыз;

            ДиспИД диспид/* = функДескУк.идЧлена*/;
            //*
			 // цел GetIDsOfNames(ref ГУИД riid, шим** rgszNames, бцел cNames, бцел лкид, цел* rgDispId);
            hr = укДиспетчер.GetIDsOfNames( &ГУИД.пустой, &имяМетода, cast(бцел)1, дефЛКИД, &диспид);
            чл.диспид=диспид;
            /**/
            всеЧлены ~= чл;
            СисОсвободиТкст (имяМетода);

            switch (чл.инвРод)
            {
                case ПВидВызова.Функ:
					методы[диспид] = этоИмя;
                    break;
                case ПВидВызова.СвойствоПолучить:
                    получатели[диспид] = этоИмя;
                    возвраты[диспид] = cast(SHORT) функДескУк.парамРгэлемдеск[0].дескт.вт;
                    break;
                case ПВидВызова.СвойствоЗаписать:
                    установщики[диспид] = этоИмя;
                    break;
                case ПВидВызова.ВызовСвойствПоместСсыл:
                    установщикиПоСсыл[диспид] = этоИмя;
                    break;
                default:
            }
        }

        укИнфОТипе.ReleaseTypeAttr(укАтрТипа);
    }

	export void покажиСостав()
	{
		скажинс("Методы:");		
		foreach(ткст ключ; методы)
			скажинс(фм("\t%s", ключ));

		скажинс("Получатели:");
		foreach(ДиспИД значение, ткст ключ; получатели)
			скажинс(фм("\t%s", ключ));

		скажинс("Установщики:");
		foreach(ДиспИД значение, ткст ключ; установщики)
			скажинс(фм("\t%s", ключ));

		скажинс("Установщики по ссылке:");
		foreach(ДиспИД значение, ткст ключ; установщикиПоСсыл)
			скажинс(фм("\t%s", ключ));

/+		
    private SHORT [ ДиспИД ] возвраты;
+/
		
	}
	
 private   АРГВАРИАНТА [] делайМассив(TypeInfo[] арги, ук укз)
    {
        АРГВАРИАНТА [] массив;
        массив.length = арги.length;

        for (бцел i;i < арги.length;++i)
        {
            if (арги[i] == typeid(АРГВАРИАНТА))
                массив [i] = va_arg!(АРГВАРИАНТА)(укз);
            else
                throw new ИсклАктивОбъ( "Ожидались аргументы типа Варарг" );
        }

        return массив;
    }

    private ДиспИД найдиЧлен(ткст член, ПВидВызова тв)
    {
        ПВидВызова врем = cast(ПВидВызова)0xffff;
		
        foreach(inout ОпредЧлена чл; всеЧлены)
            if (чл.имя == член)
                if (чл.инвРод == тв)
                    return чл.диспид;
                else
                    врем=чл.инвРод;

        if (врем == 0xffff)
            throw new ИсклАктивОбъ(фм("отсутствует член '%s'",член));
        else
		    throw new ИсклАктивОбъ(фм("член '%s' найден с ПТипВызова %s",член,врем));
    }

  export  ВАРИАНТ дай(ткст член)
    {
        ПВидВызова тв = ПВидВызова.СвойствоПолучить;
        ДиспИД диспид = найдиЧлен(член,тв);

        if (!(диспид in получатели))
            throw new ИсклАктивОбъ("можно получить только свойства");

        ДИСППАРАМЫ парам;
        ВАРИАНТ результат;
        HRESULT hr = укДиспетчер.Invoke(диспид, &ГУИД.пустой, дефЛКИД, тв, &парам, &результат, пусто, пусто);
        return результат;
    }

  export  void установи(ткст член,АРГВАРИАНТА арг)
    {
        ПВидВызова тв=ПВидВызова.СвойствоЗаписать;
        ДиспИД диспид = найдиЧлен(член,тв);
		
        if (!(диспид in установщики))
            throw new ИсклАктивОбъ("можно только установить свойства");

        АРГВАРИАНТА [] моиАрги = (&арг)[0..1];

        ДИСППАРАМЫ парам;
        парам.арги=моиАрги.length;
        парам.ргварг=моиАрги.ptr;

        ДиспИД диспидСИменем = ДИСПИД_ПОМЕСТИТЬ_СВОЙСТВО;
        парам.именованыеАрги = 1;
        парам.ргдиспидИменованыеАрги = &диспидСИменем;

        HRESULT hr = укДиспетчер.Invoke(диспид, &ГУИД.пустой, дефЛКИД,
                                       тв, &парам, пусто, пусто, пусто);
    }

  export  void установиПоСсыл(ткст член,АРГВАРИАНТА арг)
    {
	   ПВидВызова тв=ПВидВызова.ВызовСвойствПоместСсыл;
       ДиспИД диспид = найдиЧлен(член,тв);
		

        if (!(диспид in установщикиПоСсыл))
            throw new ИсклАктивОбъ("можно только установить свойства");

        АРГВАРИАНТА [] моиАрги = (&арг)[0..1];

        ДИСППАРАМЫ парам;
        парам.арги=моиАрги.length;
        парам.ргварг=моиАрги.ptr;

        ДиспИД диспидСИменем = ДИСПИД_ПОМЕСТИТЬ_СВОЙСТВО;
        парам.именованыеАрги = 1;
        парам.ргдиспидИменованыеАрги = &диспидСИменем;

        ВАРИАНТ* результат;
        HRESULT hr = укДиспетчер.Invoke(диспид, &ГУИД.пустой, дефЛКИД,
                                       тв, &парам, результат, пусто, пусто);
    }

  export  ВАРИАНТ вызови(ткст член,...)
    {
	    TypeInfo[] иот =_arguments;
	    ук аргук = _argptr;
	    debug(AXO) скажинс("Вход в функцию АктивОбъ.вызови");	
        ПВидВызова тв = ПВидВызова.Функ;
        ДиспИД диспид = найдиЧлен(член,тв);
		debug(AXO) скажинс("Член "~член~" найден");
        if (!(диспид in методы))
            throw new ИсклАктивОбъ("можно только вызывать методы");

        АРГВАРИАНТА[] моиАрги = делайМассив(иот,аргук);
		debug(AXO)скажинс("Создан массив аргументов");
		
        ДИСППАРАМЫ парам;
        парам.арги = моиАрги.length;
        парам.ргварг=моиАрги.ptr;

		debug(AXO) скажинс(фм("Вызывается %s...", член));
		
        ВАРИАНТ результат;
        HRESULT hr = укДиспетчер.Invoke(диспид, &ГУИД.пустой, дефЛКИД,
                                       тв, &парам, &результат, пусто, пусто);
        return результат;
    }
}

АРГВАРИАНТА вар(...)
{
    АРГВАРИАНТА вариант;

    if (_arguments.length < 1)
        return ВАРИАНТ.init;

    if(_arguments.length == 1)
    {
        /* Ткст */

        if (_arguments[0] == typeid(шим[]))
        {
            debug(AXO) скажинс("шим[]\t");
            вариант.вт = ПТипВарианта.БинТекст;
            вариант.бстрЗнач = cast(шим*) (va_arg!(ткст)(_argptr) ~ "\0");
        }

        else if (_arguments[0] == typeid(ткст))
        {
            debug(AXO) скажинс("ткст\t");
            вариант.вт = ПТипВарианта.БинТекст;
            шим[] buf = вЮ16(va_arg!(ткст)(_argptr) ~ "\0");
            вариант.бстрЗнач = СисРазместиТкст( cast(шим*)(buf.ptr) );
        }

        /* Беззначные Целые */

        else if (_arguments[0] == typeid(бул))
        {
            debug(AXO) скажинс("бул\t");
            вариант.вт = ПТипВарианта.Бул;            
            if(va_arg!(бул)(_argptr) == true)
                вариант.булЗнач = 1;
            else
                вариант.булЗнач = 0;                
        }
        else if (_arguments[0] == typeid(ббайт))
        {
            debug(AXO) скажинс("ббайт\t");
            вариант.вт = ПТипВарианта.Бц1; /* Не уверен. */
            вариант.ббайтЗнач = va_arg!(ббайт)(_argptr);
        }
        else if (_arguments[0] == typeid(бкрат))
        {
            debug(AXO) скажинс("бкрат\t");
            вариант.вт = ПТипВарианта.Бц2; /* Не уверен. */
            вариант.бкратЗнач = va_arg!(бкрат)(_argptr);
        }
        else if (_arguments[0] == typeid(бцел))
        {
            debug(AXO) скажинс("бцел\t");
            вариант.вт = ПТипВарианта.Бц4; /* Не уверен. */
            вариант.бцелЗнач = va_arg!(бцел)(_argptr);
        }
        else if (_arguments[0] == typeid(бдол)) /* 8 биты */
        {
            debug(AXO) скажинс("бдол\t");
            вариант.вт = ПТипВарианта.Бц4; /* 4 биты -- дол won't fit! */
            вариант.бдолЗнач = va_arg!(бдол)(_argptr);
        }


        /* Целые Со Знаком */

        else if (_arguments[0] == typeid(байт))
        {
            debug(AXO) скажинс("байт\t");
            вариант.вт = ПТипВарианта.Ц1; /* Не уверен. */
            вариант. байтЗнач = va_arg!(байт)(_argptr);
        }
        else if (_arguments[0] == typeid(крат))
        {
            debug(AXO) скажинс("крат\t");
            вариант.вт = ПТипВарианта.Ц2; 
            вариант.кратЗнач = va_arg!(крат)(_argptr);
        }
        else if (_arguments[0] == typeid(цел))
        {
            debug(AXO) скажинс("цел\t");
            вариант.вт = ПТипВарианта.Ц4; 
            вариант.целЗнач = va_arg!(цел)(_argptr);
        }
        else if (_arguments[0] == typeid(дол)) /* 8 биты */
        {
            debug(AXO) скажинс("дол\t");
            вариант.вт = ПТипВарианта.Ц4; /* 4 биты -- дол might not fit! */
            вариант.долЗнач = cast(цел) va_arg!(дол)(_argptr);
        }

        /* Плавающая Точка */

        else if (_arguments[0] == typeid(плав))
        {
            debug(AXO) скажинс("плав\t");
            вариант.вт = ПТипВарианта.Р4; 
            вариант.плавЗнач = va_arg!(плав)(_argptr);
        }
        else if (_arguments[0] == typeid(дво))
        {
            debug(AXO) скажинс("дво\t");
            вариант.вт = ПТипВарианта.Р8; 
            вариант.двоЗнач = va_arg!(дво)(_argptr);
        }

        /* Объекты */

		else if (_arguments[0] == typeid(Object)) 
			/* need to be an AXO to work right now */
		{
            debug(AXO) скажинс("object\t");
			вариант.вт = ПТипВарианта.ПоСсылке; //ПТипВарианта.СохранённыйОбъект; /* I doubt this is right. */
			вариант.байреф = cast(ук)( va_arg!(Object)(_argptr) );
				/* need to дай some kind of pointer from the AXO object */
		}		

        else
            throw new ИсклАктивОбъ("вар не представляет, что с этим делать.");

    }
    else 
        throw new ИсклАктивОбъ("[нереализованно] вар ещё не способен к использованию нескольких аргументов");

    return вариант;
}

export extern(D) АктивОбъ объАктив(ткст арг){return new АктивОбъ(арг);}