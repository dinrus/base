﻿module io.device.Device;

private import  thread;
public  import  io.device.Conduit;

extern(D)
  class Устройство : Провод, ИВыбираемый
{
        public alias Провод.ошибка ошибка;
            
        final проц ошибка ();
        override ткст вТкст ();
        override т_мера размерБуфера ();

        version (Win32)
        {  /*
                struct ВВ
                {
                        АСИНХРОН      асинх; // должен быть первым атрибутом!!
                        Дескр          указатель;
                        бул            след;
                        ук           задача;
                }

                protected ВВ вв;
				*/
                protected проц переоткрой (Дескр указатель);
                final Дескр фукз ();
                override проц вымести ();
                override проц открепи ();
                override т_мера читай (проц[] приёмн);
                override т_мера пиши (проц[] ист);
                final т_мера жди (Фибра.Планировщик.Тип тип, бцел байты, бцел таймаут);
		}
				

}
