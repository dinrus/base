﻿/*******************************************************************************

        This module реализует the SHA-1 Algorithm described by Secure Хэш
        Standard, FИПS PUB 180-1, и RFC 3174 US Secure Хэш Algorithm 1
        (SHA1). D. Eastlake 3rd, P. Jones. September 2001.

*******************************************************************************/

module crypto.digest.Sha1;

private import crypto.digest.Sha01;
public  import crypto.digest.Digest;

/*******************************************************************************

*******************************************************************************/

final class Sha1 : Sha01
{
        /***********************************************************************

                Construct a Sha1 хэш algorithm контекст

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

        final protected override проц трансформируй(ббайт[] ввод);
        /***********************************************************************

        ***********************************************************************/
        
        final static проц расширь (бцел[] W, бцел s);
        
}


/*******************************************************************************

*******************************************************************************/

debug(UnitTest)
{
        unittest 
        {
        static ткст[] strings = 
        [
                "abc",
                "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
                "a",
                "0123456701234567012345670123456701234567012345670123456701234567"
        ];

        static ткст[] результатs = 
        [
                "a9993e364706816aba3e25717850c26c9cd0d89d",
                "84983e441c3bd26ebaae4aa1f95129e5e54670f1",
                "34aa973cd4c4daa4f61eeb2bdbad27316534016f",
                "dea356a2cddd90c7a7ecedc5ebb563934f460452"
        ];

        static цел[] повтори = 
        [
                1,
                1,
                1000000,
                10
        ];

        Sha1 h = new Sha1();
        
        foreach (цел i, ткст s; strings) 
                {
                for(цел r = 0; r < повтори[i]; r++)
                        h.обнови(s);
                
                ткст d = h.гексДайджест();
                assert(d == результатs[i],":("~s~")("~d~")!=("~результатs[i]~")");
                }
        }
}