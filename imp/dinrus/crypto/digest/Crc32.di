module crypto.digest.Crc32;

public import crypto.digest.Digest;


/** This class реализует the CRC-32 проверьsum algorithm.
    The дайджест returned is a little-эндиан 4 байт ткст. */
final class Crc32 : Дайджест
{
        private бцел[256] таблица;
        private бцел результат = 0xffffffff;

        /**
         * Созд a cloned CRC32
         */
        this (Crc32 crc32);

        /**
         * Prepare Crc32 в_ проверьsum the данные with a given polynomial.
         *
         * Параметры:
         *      polynomial = The magic CRC число в_ основа calculations on.  The
         *      default compatible with ZIP, PNG, ethernet и другие. Note: This
         *      default значение имеется poor ошибка correcting свойства.
         */
        this (бцел polynomial = 0xEDB88320U);

        /** */
        override Crc32 обнови (проц[] ввод);

        /** The Crc32 размерДайджеста is 4 */
        override бцел размерДайджеста ();

        /** */
        override ббайт[] двоичныйДайджест(ббайт[] буф = пусто);

        /** Возвращает the Crc32 дайджест as a бцел */
        бцел crc32Digest();
}

debug(UnitTest)
{
        unittest 
        {
        scope c = new Crc32();
        static ббайт[] данные = [1,2,3,4,5,6,7,8,9,10];
        c.обнови(данные);
        assert(c.двоичныйДайджест() == cast(ббайт[]) x"7b572025");
        c.обнови(данные);
        assert(c.crc32Digest == 0x2520577b);
        c.обнови(данные);
        assert(c.гексДайджест() == "7b572025");
        }
}
