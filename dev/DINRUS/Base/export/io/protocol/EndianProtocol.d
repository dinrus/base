module io.protocol.EndianProtocol;

private import io.model, io.protocol.NativeProtocol;

extern(D)
 class ПротоколЭндиан : ПротоколНатив
{
        this (ИПровод провод, бул префикс=да);
        override проц[] читай (ук приёмн, бцел байты, Тип тип);
        override проц пиши (ук ист, бцел байты, Тип тип);
}