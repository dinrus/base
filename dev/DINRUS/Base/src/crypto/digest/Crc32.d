﻿module crypto.digest.Crc32;

public import crypto.digest.Digest;


  /** Этот класс реализует алгоритм контрольной суммы CRC-32.
    * Дайджест возвращает 4-байтный ткст литл-эндиан.
	*/
export final class Цпи32 : Дайджест
{
        private бцел[256] таблица;
        private бцел результат = 0xffffffff;

        /**
         * Создаёт клонированный CRC32.
         */
      export this (Цпи32 crc32)
        {
                this.таблица[] = crc32.таблица[];
                this.результат = crc32.результат;
        }

        /**
         * Подготавливает контрольную сумму Цпи32 для данные с заданным полиномиалом.
         *
         * Параметры:
         *      полиномиал = магическое число CRC, на котором основываются расчёты.
         *      По умолчанию совместимо с ZIP, PNG, ethernet и другими. Примечание:
         *      Это дефолтное значение имеет плохое свойство корректировки ошибки.
         */
       export this (бцел полиномиал = 0xEDB88320U)
        {
                for (цел i = 0; i < 256; i++)
                {
                        бцел значение = i;
                        for (цел j = 8; j > 0; j--)
                        {
                                version (Gim)
                                {
                                if (значение & 1) 
                                   {
                                   значение >>>= 1;
                                   значение ^= полиномиал;
                                   }
                                else
                                   значение >>>= 1;
                                }
                                else
                                {
                                if (значение & 1) {
                                        значение &= 0xFFFFFFFE;
                                        значение /= 2;
                                        значение &= 0x7FFFFFFF;
                                        значение ^= полиномиал;
                                }
                                else
                                {
                                        значение &= 0xFFFFFFFE;
                                        значение /= 2;
                                        значение &= 0x7FFFFFFF;
                                }
                                }
                        }
                        таблица[i] = значение;
                }
        }

        /** */
      export   override Цпи32 обнови (проц[] ввод)
        {
                бцел r = результат; // DMD optimization
                foreach (ббайт значение; cast(ббайт[]) ввод)
                {
                        auto i = cast(ббайт) r;// & 0xff;
                        i ^= значение;
                        version (Gim)
                        {
                        r >>>= 8;
                        }
                        else
                        {
                        r &= 0xFFFFFF00;
                        r /= 0x100;
                        r &= 16777215;
                        }
                        r ^= таблица[i];
                }
                результат = r;
                return this;
        }

        /** 
		* размерДайджеста Цпи32  равен 4 
		*/
       export  override бцел размерДайджеста ()
        {
                return 4;
        }

        /** */
      export   override ббайт[] двоичныйДайджест(ббайт[] буф = пусто) {
                if (буф.length < 4)
                        буф.length = 4;
                бцел знач = ~результат;
                буф[3] = cast(ббайт) (знач >> 24);
                буф[2] = cast(ббайт) (знач >> 16);
                буф[1] = cast(ббайт) (знач >> 8);
                буф[0] = cast(ббайт) (знач);
                результат = 0xffffffff;
                return буф;
        }

        /** Возвращает дайджест Цпи32  как бцел */
      export   бцел дайджестЦпи32() {
                бцел возвр = ~результат;
                результат = 0xffffffff;
                return возвр;
        }
}

debug(UnitTest)
{
        unittest 
        {
        scope c = new Цпи32();
        static ббайт[] данные = [1,2,3,4,5,6,7,8,9,10];
        c.обнови(данные);
        assert(c.двоичныйДайджест() == cast(ббайт[]) x"7b572025");
        c.обнови(данные);
        assert(c.дайджестЦпи32 == 0x2520577b);
        c.обнови(данные);
        assert(c.гексДайджест() == "7b572025");
        }
}
