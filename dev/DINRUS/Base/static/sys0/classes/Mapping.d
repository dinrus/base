﻿module sys.classes.Mapping;

struct АТРИБУТЫ_БЕЗОПАСНОСТИ //SECURITY_ATTRIBUTES
	{
	бцел длина;
	ук дескрБезоп;
	Бул наследДескр;//BOOL: 1 или 0.
	}
alias АТРИБУТЫ_БЕЗОПАСНОСТИ БЕЗАТРЫ;

enum ППамять
{
//Секции
    ЗапросСекц       = 0x0001,
    ЗаписьСекцКарт   = 0x0002,
    ЧтениеСекцКарт    = 0x0004,
    ВыполнитьСекцКарт = 0x0008,
    УвеличитьРазмСекц = 0x0010,
	Копия = ЗапросСекц,
	Запись = ЗаписьСекцКарт,
	Чтение = ЧтениеСекцКарт,
	ВыполнитьСекцКартЯвно = 0x0020,
    ВсеДоступыКСекции = cast(int)(ППраваДоступа.ТребуютсяСП|0x0001| 0x0002 | 0x0004 | 0x0008 | 0x0010),
//Страницы
    СтрНедост          = 0x01,
    СтрТолькоЧтен          = 0x02,
    СтрЗапЧтен         = 0x04,
    СтрЗапКоп         = 0x08,
    СтрВып           = 0x10,
    СтрЧтенВып      = 0x20,
    СтрЗапЧтенВып = 0x40,
    СтрЗапКопВып = 0x80,
	СтрЗапКомб = 0x400,
    СтрОхрана            = 0x100,
    СтрБезКэша          = 0x200,
	
//Секции
    СекФайл           = 0x800000,
    СекОбраз         = 0x1000000,
	СекЗащищёнОбраз =  0x2000000 ,
    СекРезерв       = 0x4000000,
    СекОтправить        = 0x8000000,
    СекБезКэша      = 0x10000000,
	СекЗапКомб = 0x40000000,     
	СекБольшиеСтр =  0x80000000,     
	СбросФлОбзЗап = 0x01, //WRITE_WATCH_FLAG_RESET
//ПАМ_
    Отправить           = 0x1000,	//mem_commit
    Резервировать          = 0x2000,//mem_reserve
	Записать = Отправить|Резервировать,
    Взять         = 0x4000,//mem_decommit
    Освободить          = 0x8000,//mem_release
    Удалить            = 0x10000, //mem_free
    Частная         = 0x20000,
    Картированная          = 0x40000,
    Сброс           = 0x80000,
    СверхуВниз       = 0x100000,
	БольшиеСтр = 0x20000000,
	Физическая = 0X400000,
	ЗапОбзор  =    0x200000,     
    Вращать =        0x800000,    
    Стр4Мб =    0x8000000,
	Образ        = СекОбраз,

//Глоб
    ГлобФиксир =	(0),
    ГлобПеремещ = 	(2),
    Гук =	(64),
    ГДескр =	(66),
	ГлобДДЕСовмест =	(8192),
	ГлобДискард =	(256),
	ГлобНижняя =	(4096),
	ГлобНесжим =	(16),
	ГлобНедискард =	(32),
	ГлобНеБанк =	(4096),
	ГлобУведоми	= (16384),
	ГлобСовмест =	(8192),
	ГлобНульИниц =	(64),
	ГлобДискардир =	(16384),
	ГлобНевернДескр =	(32768),
	ГлобСчётБлокировок =	(255),
//Лок
	Лук	= (64),
	ЛДескр	= (66),
	ЛДескрНеНуль	= (2),
	ЛукНеНуль	= (0),
	ЛокЛДескрНеНуль	= (2),
	ЛокЛукНеНуль	= (0),
	ЛокФиксир	= (0),
	ЛокПеремещ	= (2),
	ЛокНесжим	= (16),
	ЛокНедискард	= (32),
	ЛокНульИниц	= (64),
	ЛокИзмени	= (128),
	ЛокСчётБлокировок	= (255),
	ЛокДискард	= (3840),
	ЛокДискардир	= (16384),
	ЛокНевернДескр	= (32768),

//Вирт

//Куча
	КучГенИскл =	0x00000004,
	КучНеСериализ =	0x00000001,
	КучОбнулиПам	= 0x00000008,
	КучПереместТолькоНаМесте	= 0x00000010,
	КучВклВып = 0x00040000,
}


extern(C)
{
	ук СоздайМаппингФайлаА(ук ф, БЕЗАТРЫ *ба, ППамять защ, бцел максРазмН, бцел максРазмВ, ткст имя);
	ук СоздайМаппингФайла(ук ф, БЕЗАТРЫ *ба,ППамять защ, бцел максРазмН, бцел максРазмВ, шткст имя);
	ук ОткройМаппингФайлаА(ППамять желДоступ, бул наследовать, ткст имяМаппинга);
	ук ОткройМаппингФайла(ППамять желДоступ, бул наследовать, шткст имяМаппинга);
	ук ВидФайлаВКарту(ук объектФМап, ППамять желатДоступ, бцел фСмещВ, бцел фСмещН, бцел члоБайтовДляМап);
	ук ВидФайлаВКартуДоп(ук объектФМап, ППамять желатДоступ, бцел фСмещВ, бцел фСмещН, бцел члоБайтовДляМап, ук адрОвы);
	бул СлейВидФайла(ук адрОвы, бцел члоСливБайт);
	бул ВидФайлаИзКарты(ук адрОвы);	
}