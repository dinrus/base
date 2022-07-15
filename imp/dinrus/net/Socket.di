﻿module net.Socket;

private import  time.Time;

version(Win32)
{
        import sys.WinConsts: ПСемействоАдресов;
}

version (Win32)
{
		public import sys.WinConsts: МАСКА_ВВПАРАМ, ВВК_ВХО,ВВФСБВВ, 
        ДЛИНА_ВСАОПИСАНИЯ, ДЛИНА_ВСАСИС_СТАТУСА, НЕВЕРНСОК, СОКОШИБ,
         ПОпцияСокета, ППротокол, ПЭкстрЗакрытиеСокета, ПФлагиСокета, ПТипСок;
		
        private const цел WSAEWOULDBLOCK =  10035;
        private const цел WSAEINTR =        10004;

public import sys.WinStructs: ВИНСОКДАН, набор_уд, значврем, хостзап, адрессок,
 заминка, адрес_ин;

public import sys.WinFuncs: закройсок, ВСАСтарт, ВСАЧистка, сокет, 
адр_инет, ввктлсок, свяжисок, подключи, слушай, закройсок, экстрзак, 
дайимяпира, дайимясок,  шли, шли_на, пусти, прими, прими_от, выбери,
 дайопцсок, установиопцсок, дайимяхоста, инетс8а, дайхостпоимени, 
  дайхостпоадресу, ВСАДайПоследнююОшибку, х8сбк, х8сбц, с8хбк, с8хбц;

alias экстрзак глуши;
alias закройсок закрой;               

}

extern(D):

static цел последнОшиб ();



class Сокет
{
        т_сокет        сок;
        ПТипСок      тип;
        ПСемействоАдресов   семейство;
        ППротокол    протокол;

        version(Win32)
                private бул _блокируется = да;

        this(ПСемействоАдресов семейство, ПТипСок тип, ППротокол протокол, бул создай=да);
        т_сокет фукз ();
        проц переоткрой (т_сокет сок = сок.init);
        бул жив_ли();
        override ткст вТкст();
        бул блокируется();
        проц блокируется(бул бда);
        ПСемействоАдресов семействоАдресов();
        Сокет вяжи(Адрес адр);
        Сокет подключись(Адрес куда);
        Сокет слушай(цел backlog);
        Сокет прими ();
        Сокет прими (Сокет мишень);
        Сокет глуши(ПЭкстрЗакрытиеСокета как);
        Сокет установиПериодЗаминки (цел период);
        Сокет установиПовторнИспАдреса (бул включен);
        Сокет установиБезЗаминки (бул включен);
        проц включиВГруппу (АдресИПв4 адрес, бул onOff); 
        проц открепи ();
        Адрес новОбъектСемейства ();
        static ткст имяХоста ();
        static бцел адресХоста ();
        Адрес удалённыйАдрес ();
        Адрес локальныйАдрес ();

        /// Отправка or принять ошибка код.
        const цел ОШИБКА = СОКОШИБ;

        цел шли(проц[] буф, ПФлагиСокета флаги=ПФлагиСокета.Неук);
        цел отправь_на(проц[] буф, ПФлагиСокета флаги, Адрес куда);
        цел отправь_на(проц[] буф, Адрес куда);
        цел отправь_на(проц[] буф, ПФлагиСокета флаги=ПФлагиСокета.Неук);
        цел принять(проц[] буф, ПФлагиСокета флаги=ПФлагиСокета.Неук);
        цел принять_от(проц[] буф, ПФлагиСокета флаги, Адрес из_);
        цел принять_от(проц[] буф, Адрес из_);
        цел принять_от(проц[] буф, ПФлагиСокета флаги = ПФлагиСокета.Неук);
        цел дайОпцию (ППротокол уровень, ПОпцияСокета опция, проц[] результат);
        Сокет установиОпцию (ППротокол уровень, ПОпцияСокета опция, проц[] значение);
        protected static проц исключение (ткст сооб);
        protected static проц плохойАрг (ткст сооб);

        static цел выбери (НаборСокетов проверьЧит, НаборСокетов проверьЗап, НаборСокетов проверьОш, значврем* tv);
        static цел выбери (НаборСокетов проверьЧит, НаборСокетов проверьЗап, НаборСокетов проверьОш, ИнтервалВремени время);
        static цел выбери (НаборСокетов проверьЧит, НаборСокетов проверьЗап, НаборСокетов проверьОш);
        static значврем вЗначВрем (ИнтервалВремени время);
}



/*******************************************************************************


*******************************************************************************/

abstract class Адрес
{
        protected адрессок* имя();
        protected цел длинаИмени();
        ПСемействоАдресов семействоАдресов();
        ткст вТкст();
        static проц исключение (ткст сооб);

}


/*******************************************************************************


*******************************************************************************/

class НеизвестныйАдрес: Адрес
{
        protected:
        адрессок sa;

        адрессок* имя();
        цел длинаИмени();

        public:
        ПСемействоАдресов семействоАдресов();
        ткст вТкст();
}


/*******************************************************************************


*******************************************************************************/

class НетХост
{
        ткст имя;
        ткст[] алиасы;
        бцел[] АдрСписок;

        protected проц проверьХостзап(хостзап* he);
        проц наполни(хостзап* he);
        бул дайХостПоИмени(ткст имя);
        бул дайХостПоАдресу(бцел адр);
        бул дайХостПоАдресу(ткст адр);
}

/*******************************************************************************


*******************************************************************************/

class АдресИПв4 : Адрес
{
        protected:
        сим[8] _port;

        struct сокадр_ин
        {
                бкрат семействоИС = cast(бкрат) ПСемействоАдресов.ИНЕТ;
                бкрат портИС;
                бцел адрИС; //in_Addr
                сим[8] зероИС = 0;
        }

        сокадр_ин син;
        адрессок* имя();
        цел длинаИмени();

        public:

        this();

        const бцел АДР_ЛЮБОЙ = 0;
        const бцел АДР_НЕУК = cast(бцел)-1;
        const бкрат ПОРТ_ЛЮБОЙ = 0;

        ПСемействоАдресов семействоАдресов();
        бкрат порт();
        бцел адр();
        this(ткст адр, цел порт = ПОРТ_ЛЮБОЙ);
        this(бцел адр, бкрат порт);
        this(бкрат порт);
        synchronized ткст вТкстАдреса();
        ткст вТкстПорта();
        ткст вТкст();
        static бцел разбор(ткст адр);
}


/*******************************************************************************


*******************************************************************************/

//набор of СОКЕТs for Сокет.выбери()
class НаборСокетов
{
        private бцел  члоБайт; //Win32: excludes бцел.размер "счёт"
        private байт* буф;

        version(Win32)
        {
                бцел счёт();
                проц счёт(цел setter);
                т_сокет* первый();
        }
        version (Posix)
        {
                import core.BitManip;

                бцел nfdbits;
                т_сокет _maxfd = 0;

                бцел fdelt(т_сокет s);
                бцел fdmask(т_сокет s);
                бцел* первый();
                public т_сокет максуд();
        }


        public:

        this (бцел max);
        this (НаборСокетов o) ;
        this();

        НаборСокетов dup() ;
         проц сбрось();
        проц добавь(т_сокет s);
        проц добавь(Сокет s);
        проц удали(т_сокет s);
        проц удали(Сокет s);
        цел набор_ли(т_сокет s);
        цел набор_ли(Сокет s);
        бцел макс();
        набор_уд* вНабор_УД();
}