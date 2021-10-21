﻿/*******************************************************************************
        This module реализует the MD5 Message Дайджест Algorithm as described
        by RFC 1321 The MD5 Message-Дайджест Algorithm. R. Rivest. April 1992.

*******************************************************************************/
module crypto.digest.Md5;

public  import crypto.digest.Md4;
private import crypto.digest.MerkleDamgard;

/*******************************************************************************

*******************************************************************************/

final class Md5 : Md4
{
        /***********************************************************************

                Конструирует Md5

        ***********************************************************************/

        this() ;


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

        /***********************************************************************

        ***********************************************************************/

        private static бцел g(бцел x, бцел y, бцел z);

        /***********************************************************************

        ***********************************************************************/

        private static бцел i(бцел x, бцел y, бцел z);

        /***********************************************************************

        ***********************************************************************/

        private static проц ff(ref бцел a, бцел b, бцел c, бцел d, бцел x, бцел s, бцел ac);

        /***********************************************************************

        ***********************************************************************/

        private static проц gg(ref бцел a, бцел b, бцел c, бцел d, бцел x, бцел s, бцел ac);

        /***********************************************************************

        ***********************************************************************/

        private static проц hh(ref бцел a, бцел b, бцел c, бцел d, бцел x, бцел s, бцел ac);

        /***********************************************************************

        ***********************************************************************/

        private static проц ii(ref бцел a, бцел b, бцел c, бцел d, бцел x, бцел s, бцел ac);
}


/*******************************************************************************

*******************************************************************************/

debug(UnitTest)
{
        unittest
        {
        static ткст[] strings =
        [
                "",
                "a",
                "abc",
                "сообщение дайджест",
                "abcdefghijklmnopqrstuvwxyz",
                "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
                "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
        ];

        static ткст[] результатs =
        [
                "d41d8cd98f00b204e9800998ecf8427e",
                "0cc175b9c0f1b6a831c399e269772661",
                "900150983cd24fb0d6963f7d28e17f72",
                "f96b697d7cb7938d525a2f31aaf161d0",
                "c3fcd3d76192e4007dfb496cca67e13b",
                "d174ab98d277d9f5a5611c2c9f419d9f",
                "57edf4a22be3c955ac49da2e2107b67a"
        ];

        Md5 h = new Md5();

        foreach (цел i, ткст s; strings)
                {
                h.обнови(cast(ббайт[]) s);
                ткст d = h.гексДайджест;

                assert(d == результатs[i],":("~s~")("~d~")!=("~результатs[i]~")");
                }
        }
}