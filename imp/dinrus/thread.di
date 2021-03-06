﻿module thread;
pragma(lib,"dinrus.lib");

extern (Windows) бцел нить_точкаВхода( ук арг );
extern (Windows)	ук ДайДескрТекущейНити();

extern (D)	class Нить
	{	

		this( проц function() fn, т_мера разм = 0 );	
		this( проц delegate() дг, т_мера разм = 0 );
		~this();		 
		final проц старт()	;
		final Объект присоедини( бул rethrow = да );
		final ткст имя();
		final проц имя( ткст знач );
		final бул демон_ли();
		final проц демон_ли( бул знач );
		final бул пущена_ли();
		
		static const цел МИНПРИОР;
		static const цел МАКСПРИОР;

		final цел приоритет();
		final проц приоритет( цел знач );
		static проц спи( double period );
		static проц жни();
		static Нить дайЭту();
		static Нить[] дайВсе();
		static цел opApply( цел delegate( ref  Нить ) дг );
		
		static const бцел МАКСЛОК = 64;

		static бцел создайЛок();
		static проц удалиЛок( бцел key );
		static ук дайЛок( бцел key );
		static ук устЛок( бцел key, ук знач );
		
		static this()
		{
				МИНПРИОР = -15;
				МАКСПРИОР =  15;
		
		}
	private:
		final проц пуск();
		
			//
		// Тип процедуры, передаваемой при конструкции нити.
		//
		enum Вызов
		{
			НЕТ,
			ФН,
			ДГ
		}
		
		//
		// Стандартные типы
		//
		
			alias бцел КлючНЛХ;
			alias бцел АдрНити;

		//
		// Локальное хранилище
		//
		static бул[МАКСЛОК]  см_локал;
		static КлючНЛХ           см_эта;

		ук[МАКСЛОК]        м_локал;


		//
		// Стандартные данные нити
		//
		version( Win32 )
		{
			ук          м_дескр;
		}
		public АдрНити          м_адр;
		Вызов                м_вызов;
		ткст              м_имя;
		union
		{
			проц function() м_фн;
			проц delegate() м_дг;
		}
		т_мера              м_рр;
		version( Posix )
		{
			бул            м_пущена;
		}
		бул                м_демон;
		public Объект              м_необработ;
		
		static проц установиЭту( Нить t );
		final проц суньКонтекст( Контекст* c );
		final проц выньКонтекст();
	public final Контекст* топКонтекст();

		public static struct Контекст
		{
			ук           нстэк,
							встэк;
			Контекст*        внутри;
			Контекст*        следщ,
							предщ;
		}


		Контекст             м_глав;
		Контекст*            м_тек;
		бул                м_блок;

		version( Win32 )
		{
			бцел[8]         м_рег; // edi,esi,ebp,esp,ebx,edx,ecx,eax
		}
		
		static Объект slock();
		
		static Контекст*     см_кнач;
		static т_мера       см_кдлин;

		static Нить       см_ннач;
		static т_мера       см_ндлин;

		//
		// Используется для упорядочивания нитей в глобальном списке.
		//
		Нить              предщ;
		Нить              следщ;
		
		static проц добавь( Контекст* c );
		static проц удали( Контекст* c );
		static проц добавь( Нить t );
		static проц удали( Нить t );

}
	
	
	class НитьЛок( T )
	{
		this( T def = T.init )
		{
			м_деф = def;
			м_ключ = Нить.создайЛок();
		}

		~this()
		{
			Нить.удалиЛок( м_ключ );
		}

		T знач()
		{
			Обёртка* wrap = cast(Обёртка*) Нить.дайЛок( м_ключ );

			return wrap ? wrap.знач : м_деф;
		}

		T знач( T newval )
		{
			Обёртка* wrap = cast(Обёртка*) Нить.дайЛок( м_ключ );

			if( wrap is null )
			{
				wrap = new Обёртка;
				Нить.устЛок( м_ключ, wrap );
			}
			wrap.знач = newval;
			return newval;
		}

	private:

		struct Обёртка
		{
			T   знач;
		}

		T       м_деф;
		бцел    м_ключ;
	}

extern (D)	class ГруппаНитей
	{
		
		final Нить создай( проц function() фн );
		final Нить создай( проц delegate() дг );
		final проц добавь( Нить t );
		final проц удали( Нить t );
		final цел opApply( цел delegate( ref  Нить ) дг );
		final проц объединиВсе( бул rethrow = да );
	}
		
extern (D) class Фибра
	{
		static class Планировщик
		{
			alias ук Дескр;

			enum Тип {Чтение =1, Запись=2, Приём=3, Подключение=4, Трансфер=5}

			проц пауза (бцел ms);
			проц готов (Фибра fiber);
			проц открой (Дескр fd, ткст имя);
			проц закрой (Дескр fd, ткст имя);
			проц ожидай (Дескр fd, Тип t, бцел timeout);			
			проц ответви (ткст имя, проц delegate() дг, т_мера stack=8192);   
		}

		final static Планировщик планировщик ();
		
		this(т_мера разм);
		this( проц function() fn, т_мера разм = РАЗМЕР_СТРАНИЦЫ);
		this( проц delegate() дг, т_мера разм = РАЗМЕР_СТРАНИЦЫ, Планировщик s = пусто );
		~this();
		final Object вызови( бул rethrow = да );
		final проц сбрось();
		final проц сбрось( проц function() фн );
		final проц сбрось( проц delegate() дг );
		final проц сотри();
		final проц глуши ();
		static проц жни();
		static проц жниИБросай( Объект объ );
		static Фибра дайЭту();
		final проц пуск();
		
		enum Состояние
		{
			ЗАДЕРЖ,   ///
			ВЫП,   ///
			ТЕРМ    ///
		}
		
				struct Событие                       
		{  
			бцел             инд;           // поддержка удаления таймера
			Фибра            следщ;          // линкованный список просроченных фибр
			ук            данные;          // данные для обмена
			бдол            время;         // требуемая продолжительность таймаута
			Планировщик.Дескр хэндл;        // хэндл запроса на ввод-вывод
			Планировщик        планировщик;     // ассоциированный планировщик (м. б. null)
		}

		final Состояние состояние();
		
		т_мера размерСтэка();	

		
				enum Вызов
		{
			НЕТ,
			ФН,
			ДГ
		}


		//
		// Standard fiber данные
		//
		Вызов                м_вызов;
		union
		{
			проц function() м_фн;
			проц delegate() м_дг;
		}
		бул                м_пущена;
		Объект              м_необработ;
		Состояние               м_состояние;
		ткст              м_имя;
	public:
		Событие               событие;
		
		final проц разместиСтэк( т_мера разм );
		final проц освободиСтэк();
		final проц инициализуйСтэк();
		
		public Нить.Контекст* м_кткст;
		public т_мера          м_разм;
		ук           м_пам;
		
		static проц установиЭту( Фибра f );
		final проц подключись();
		final проц отключись();
		
}

extern (C)
{
проц фибра_точкаВхода();
проц фибра_переклКонтекст( ук* старук, ук новук );
		
проц нить_жни();		
проц нить_спи(дво период);

проц нить_иниц();
проц нить_прикрепиЭту();
проц нить_открепиЭту();
проц нить_объединиВсе();
бул нить_нужнаБлокировка();
проц нить_заморозьВсе();
проц нить_разморозьВсе();
проц нить_сканируйВсе( фнСканВсеНити скан, ук текВерхСтека = null );

}