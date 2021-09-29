﻿module tpl.args;

    /**
     * Базовый тип списка вариадических аргументов (ва).
     */
  //Уже определён в модуле base >>>>  alias ук  спис_ва, va_list;

    /**
     * Эта функция инициализует предоставленный указатель на аргумент
     * для последующего использования в ва_арг и кон_ва.
     *
     * Параметры:
     *  ap      = Инициализуемый указатель на аргумент.
     *  paramn  = Определитель самого правого параметра в списке
     *            параметров функции.
     */
	template ва_старт( T )
	{
		проц ва_старт( out спис_ва ap, inout T члопарам )
		{
			ap = cast(спис_ва) ( cast(ук) &члопарам + ( ( T.sizeof + цел.sizeof - 1 ) & ~( цел.sizeof - 1 ) ) );
		}
	}
	
    /**
     * Эта функция возвращает следующий аргумент в последовательности, на которую
     * ссылается предоставленный указатель на аргумент. Этот указатель будет настроен
     * для указания на следующий аргумент последовательности.
     *
     * Параметры:
     *  ap  = Указатель на аргумент.
     *
     * Возвращает:
     *  Следщ аргумент в последовательности.  результат будет неопределённым, если ap
     *  не указывает на валидныйаргумент.
     */
	template ва_арг( T )
	{
		T ва_арг( inout спис_ва ap )
		{
			T арг = *cast(T*) ap;
			ap = cast(спис_ва) ( cast(ук) ap + ( ( T.sizeof + цел.sizeof - 1 ) & ~( цел.sizeof - 1 ) ) );
			return арг;
		}
	}
	
    /**
     * Эта фунция удаляет всяческие ресурсы, размещённые в память старт_ва.
     * На данный момент она не делает никаких действий и существует только ради
     * синтактический совместимости для функций с 
     * вариадическими аргументами в языке Си.
     *
     * Параметры:
     *  ap  = Указатель на аргумент.
     */
	проц ва_стоп( спис_ва ap )
	{

	}
	
    /**
     * Функция копирует указатель на аргумент ист в приёмн.
     *
     * Параметры:
     *  ист = Указатель на исток.
     *  приёмн = Указатель на приёмник.
     */
	проц ва_копируй( out спис_ва куда, спис_ва откуда )
	{
		куда = откуда;
	}

alias ва_старт va_start;
alias ва_арг va_arg;
alias ва_стоп va_end;
alias ва_копируй va_copy;

extern (C) template ва_арг_ди(T)
{
    T va_arg(inout va_list _argptr)
    {
	T арг = *cast(T*)_argptr;
	_argptr = _argptr + ((T.sizeof + int.sizeof - 1) & ~(int.sizeof - 1));
	return арг;
    }
}