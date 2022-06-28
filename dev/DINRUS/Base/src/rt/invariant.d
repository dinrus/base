//Модуль не указывается)))
//Предположительно натыкается на Объект из Длл, с нулевой ссылкой,
//когда сборщик мусора создаёт аллокацию в памяти для класса.
//import tpl.traits, sys.WinFuncs, runtime, stdrus: инфо, фм, ДАТА, ВРЕМЯ, выход;

extern(C){
ук  смСоздайСлабУк( Объект r );
бул смУдалиСлабУк( ук  wp );
Объект смДайСлабУк( ук  wp );
}

export extern (D)
 void _d_invariant(Object вхобъ)
{  

 ClassInfo c;
 Объект объ;
 
	if(вхобъ is null)
	{

		объ = смДайСлабУк(смСоздайСлабУк(вхобъ));
	
		if(объ is null)
		{
	       return;
		   /+
				инфо(фм(

				"
				*********************************
				Приложение будет закрыто, так как _d_invariant получил
				нулевую	ссылку на неизвестный объект. (Возможно, это 
				процедура   из DLL.) Сборка мусора и остановка рантайма
				будут проведены	в необходимом	порядке.
				Приносим  извинения, но в запущенном  вами приложении,
				либо   в рантайме Динрус,
				есть какие-то несоответствия, либо ошибки.					
				*************************************
				%s  %s
				", ДАТА, ВРЕМЯ )); смСобери(); ртСтоп();
				+/
		}	
		
	} else объ = вхобъ;
		
	c = объ.classinfo;
	
    do
    {
        if (c.classInvariant !is null)
        {
            void delegate() inv;
            inv.ptr = cast(void*) объ;
            inv.funcptr =  cast(void function()) c.classInvariant;
            inv();
        }
        c = c.base;
    } while (c);
	


}

///////////////////////////////////////////////////////////////
/* В последней версии Д2 так>>>>

void _d_invariant(Object o)
{   ClassInfo c;

    //printf("__d_invariant(%p)\n", o);

    // BUG: needs to be filename/line of caller, not library routine
    assert(o !is null); // just do null check, not invariant check

    c = typeid(o);
    do
    {
        if (c.classInvariant)
        {
            (*c.classInvariant)(o);
        }
        c = c.base;
    } while (c);
}
*/