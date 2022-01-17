module io.protocol.NativeProtocol;

private import  io.Buffer;

private import  io.protocol.model;

extern(D):
 class ПротоколНатив : ИПротокол
{

        this (ИПровод провод, бул префикс=да);

        ИБуфер буфер ();

        проц[] читай (ук приёмн, бцел байты, Тип тип);

        проц пиши (ук ист, бцел байты, Тип тип);

        проц[] читайМассив (ук приёмн, бцел байты, Тип тип, Разместитель размести);

        проц пишиМассив (ук ист, бцел байты, Тип тип);
}



/*******************************************************************************

*******************************************************************************/

debug (UnitTest)
{
        import io.Buffer;
        import io.protocol.Writer;
        import io.protocol.Reader;
        import io.protocol.NativeProtocol;
        
        unittest
        {
                auto протокол = new ПротоколНатив (new Буфер(32));
                auto ввод  = new Читатель (протокол);
                auto вывод = new Писатель (протокол);

                ткст foo;
                вывод ("testing testing 123"c);
                ввод (foo);
                assert (foo == "testing testing 123");
        }
}

   