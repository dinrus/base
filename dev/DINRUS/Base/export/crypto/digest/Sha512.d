﻿/*******************************************************************************
        This module реализует the SHA-512 Algorithm described by Secure
        Хэш Standard, FИПS PUB 180-2

*******************************************************************************/

module crypto.digest.Sha512;

private import crypto.digest.MerkleDamgard;
public  import crypto.digest.Digest;

/*******************************************************************************

*******************************************************************************/

final class Sha512 : MerkleDamgard
{

        /***********************************************************************

                Construct a Sha512 хэш algorithm контекст

        ***********************************************************************/

        this();

        /***********************************************************************

        ***********************************************************************/

        protected override проц создайДайджест(ббайт[] буф);

        /***********************************************************************

                The дайджест размер of Sha-512 is 64 байты

        ***********************************************************************/

        override бцел размерДайджеста() ;

        /***********************************************************************

                Initialize the cipher

                Примечания:
                Возвращает the cipher состояние в_ it's начальное значение

        ***********************************************************************/

        protected override проц сбрось();

        /***********************************************************************

                Шифр блок размер

                Возвращает:
                the блок размер

                Примечания:
                Specifies the размер (in байты) of the блок of данные в_ пароль в_
                each вызов в_ трансформируй(). For SHA512 the размерБлока is 128.

        ***********************************************************************/

        protected override бцел размерБлока() ;

        /***********************************************************************

                Length паддинг размер

                Возвращает:
                the length паддинг размер

                Примечания:
                Specifies the размер (in байты) of the паддинг which uses the
                length of the данные which имеется been ciphered, this паддинг is
                carried out by the падДлин метод. For SHA512 the добавьРазмер is 16.

        ***********************************************************************/

        protected override бцел добавьРазмер() ;

        /***********************************************************************

                Pads the cipher данные

                Параметры:
                данные = a срез of the cipher буфер в_ заполни with паддинг

                Примечания:
                Fills the passed буфер срез with the appropriate паддинг for
                the final вызов в_ трансформируй(). This паддинг will заполни the cipher
                буфер up в_ размерБлока()-добавьРазмер().

        ***********************************************************************/

        protected override проц падСооб(ббайт[] данные);

        /***********************************************************************

                Performs the length паддинг

                Параметры:
                данные   = the срез of the cipher буфер в_ заполни with паддинг
                length = the length of the данные which имеется been ciphered

                Примечания:
                Fills the passed буфер срез with добавьРазмер() байты of паддинг
                based on the length in байты of the ввод данные which имеется been
                ciphered.

        ***********************************************************************/

        protected override проц падДлин(ббайт[] данные, бдол length);

        /***********************************************************************

                Performs the cipher on a блок of данные

                Параметры:
                данные = the блок of данные в_ cipher

                Примечания:
                The actual cipher algorithm is carried out by this метод on
                the passed блок of данные. This метод is called for every
                размерБлока() байты of ввод данные и once ещё with the остаток
                данные псеп_в_конце в_ размерБлока().

        ***********************************************************************/

        protected override проц трансформируй(ббайт[] ввод);

}

debug(UnitTest)
{
        unittest
        {
        static ткст[] strings =
        [
                "",
                "abc",
                "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
        ];

        static ткст[] результатs =
        [
                "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e",
                "ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f",
                "8e959b75dae313da8cf4f72814fc143f8f7779c6eb9f7fa17299aeadb6889018501d289e4900f7e4331b99dec4b5433ac7d329eeb6dd26545e96e55b874be909"
        ];

        Sha512 h = new Sha512;

        foreach (цел i, ткст s; strings)
                {
                h.обнови(cast(ббайт[])s);
                ткст d = h.гексДайджест();
                assert(d == результатs[i],"DigestTransform:("~s~")("~d~")!=("~результатs[i]~")");
                }
        }
}