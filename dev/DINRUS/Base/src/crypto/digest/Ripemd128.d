﻿/*******************************************************************************

        This module реализует the Райпмд128 algorithm by Hans Dobbertin, 
        Antoon Bosselaers и Bart Preneel.

        See http://homes.esat.kuleuven.be/~bosselae/rИПemd160.html for ещё
        information.
        
        The implementation is based on:        
        RИПEMD-160 software записано by Antoon Bosselaers, 
 		available at http://www.esat.kuleuven.ac.be/~cosicart/ps/AB-9601/

*******************************************************************************/

module crypto.digest.Ripemd128;

private import crypto.digest.MerkleDamgard;

public  import crypto.digest.Digest;

/*******************************************************************************

*******************************************************************************/

export class Райпмд128 : МерклеДамгард
{
        private бцел[4]        контекст;
        private const бцел     padChar = 0x80;

        /***********************************************************************

        ***********************************************************************/

        private static const бцел[4] начальное =
        [
  				0x67452301,
  				0xefcdab89,
  				0x98badcfe,
  				0x10325476
        ];
        
        /***********************************************************************

        	Construct a Райпмд128

         ***********************************************************************/

        export this() { }

        /***********************************************************************

        	The размер of a Райпмд128 дайджест is 16 байты
        
         ***********************************************************************/

       export  override бцел размерДайджеста() {return 16;}


        /***********************************************************************

        	Initialize the cipher

        	Примечания:
        		Возвращает the cipher состояние в_ it's начальное значение

         ***********************************************************************/

      export  override проц сбрось()
        {
        	super.сбрось();
        	контекст[] = начальное[];
        }

        /***********************************************************************

        	Obtain the дайджест

        	Возвращает:
        		the дайджест

        	Примечания:
        		Возвращает дайджест of the текущ cipher состояние, this may be the
        		final дайджест, либо a дайджест of the состояние between calls в_ обнови()

         ***********************************************************************/

       export  override проц создайДайджест(ббайт[] буф)
        {
            version (БигЭндиан)
            	ПерестановкаБайт.своп32 (контекст.ptr, контекст.length * бцел.sizeof);

        	буф[] = cast(ббайт[]) контекст;
        }


        /***********************************************************************

         	блок размер

        	Возвращает:
        	the блок размер

        	Примечания:
        	Specifies the размер (in байты) of the блок of данные в_ пароль в_
        	each вызов в_ трансформируй(). For Райпмд128 the размерБлока is 64.

         ***********************************************************************/

        export  override бцел размерБлока() { return 64; }

        /***********************************************************************

        	Length паддинг размер

        	Возвращает:
        	the length паддинг размер

        	Примечания:
        	Specifies the размер (in байты) of the паддинг which uses the
        	length of the данные which имеется been ciphered, this паддинг is
        	carried out by the падДлин метод. For Райпмд128 the добавьРазмер is 8.

         ***********************************************************************/

        export  бцел добавьРазмер()   { return 8;  }

        /***********************************************************************

        	Pads the cipher данные

        	Параметры:
        	данные = a срез of the cipher буфер в_ заполни with паддинг

        	Примечания:
        	Fills the passed буфер срез with the appropriate паддинг for
        	the final вызов в_ трансформируй(). This паддинг will заполни the cipher
        	буфер up в_ размерБлока()-добавьРазмер().

         ***********************************************************************/

        export  override проц падСооб(ббайт[] at)
        {
        	at[0] = padChar;
        	at[1..at.length] = 0;
        }

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

        export  override проц падДлин(ббайт[] at, бдол length)
        {
        	length <<= 3;
        	littleEndian64((cast(ббайт*)&length)[0..8],cast(бдол[]) at); 
        }

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

        export  override проц трансформируй(ббайт[] ввод)
        {
        	бцел al, bl, cl, dl;
        	бцел ar, br, вк, dr;
            бцел[16] x;
            
            littleEndian32(ввод,x);

            al = ar = контекст[0];
            bl = br = контекст[1];
            cl = вк = контекст[2];
            dl = dr = контекст[3];

            // Round 1 и parallel округли 1
            al = вращайВлево(al + (bl ^ cl ^ dl) + x[0], 11);
            ar = вращайВлево(ar + ((br & dr) | (вк & ~(dr))) + x[5] + 0x50a28be6, 8);
            dl = вращайВлево(dl + (al ^ bl ^ cl) + x[1], 14);
            dr = вращайВлево(dr + ((ar & вк) | (br & ~(вк))) + x[14] + 0x50a28be6, 9);
            cl = вращайВлево(cl + (dl ^ al ^ bl) + x[2], 15);
            вк = вращайВлево(вк + ((dr & br) | (ar & ~(br))) + x[7] + 0x50a28be6, 9);
            bl = вращайВлево(bl + (cl ^ dl ^ al) + x[3], 12);
            br = вращайВлево(br + ((вк & ar) | (dr & ~(ar))) + x[0] + 0x50a28be6, 11);
            al = вращайВлево(al + (bl ^ cl ^ dl) + x[4], 5);
            ar = вращайВлево(ar + ((br & dr) | (вк & ~(dr))) + x[9] + 0x50a28be6, 13);
            dl = вращайВлево(dl + (al ^ bl ^ cl) + x[5], 8);
            dr = вращайВлево(dr + ((ar & вк) | (br & ~(вк))) + x[2] + 0x50a28be6, 15);
            cl = вращайВлево(cl + (dl ^ al ^ bl) + x[6], 7);
            вк = вращайВлево(вк + ((dr & br) | (ar & ~(br))) + x[11] + 0x50a28be6, 15);
            bl = вращайВлево(bl + (cl ^ dl ^ al) + x[7], 9);
            br = вращайВлево(br + ((вк & ar) | (dr & ~(ar))) + x[4] + 0x50a28be6, 5);
            al = вращайВлево(al + (bl ^ cl ^ dl) + x[8], 11);
            ar = вращайВлево(ar + ((br & dr) | (вк & ~(dr))) + x[13] + 0x50a28be6, 7);
            dl = вращайВлево(dl + (al ^ bl ^ cl) + x[9], 13);
            dr = вращайВлево(dr + ((ar & вк) | (br & ~(вк))) + x[6] + 0x50a28be6, 7);
            cl = вращайВлево(cl + (dl ^ al ^ bl) + x[10], 14);
            вк = вращайВлево(вк + ((dr & br) | (ar & ~(br))) + x[15] + 0x50a28be6, 8);
            bl = вращайВлево(bl + (cl ^ dl ^ al) + x[11], 15);
            br = вращайВлево(br + ((вк & ar) | (dr & ~(ar))) + x[8] + 0x50a28be6, 11);
            al = вращайВлево(al + (bl ^ cl ^ dl) + x[12], 6);
            ar = вращайВлево(ar + ((br & dr) | (вк & ~(dr))) + x[1] + 0x50a28be6, 14);
            dl = вращайВлево(dl + (al ^ bl ^ cl) + x[13], 7);
            dr = вращайВлево(dr + ((ar & вк) | (br & ~(вк))) + x[10] + 0x50a28be6, 14);
            cl = вращайВлево(cl + (dl ^ al ^ bl) + x[14], 9);
            вк = вращайВлево(вк + ((dr & br) | (ar & ~(br))) + x[3] + 0x50a28be6, 12);
            bl = вращайВлево(bl + (cl ^ dl ^ al) + x[15], 8);
            br = вращайВлево(br + ((вк & ar) | (dr & ~(ar))) + x[12] + 0x50a28be6, 6);
            
            // Round 2 и parallel округли 2
            al = вращайВлево(al + (((cl ^ dl) & bl) ^ dl) + x[7] + 0x5a827999, 7);
            ar = вращайВлево(ar + ((br | ~(вк)) ^ dr) + x[6] + 0x5c4dd124, 9);
            dl = вращайВлево(dl + (((bl ^ cl) & al) ^ cl) + x[4] + 0x5a827999, 6);
            dr = вращайВлево(dr + ((ar | ~(br)) ^ вк) + x[11] + 0x5c4dd124, 13);
            cl = вращайВлево(cl + (((al ^ bl) & dl) ^ bl) + x[13] + 0x5a827999, 8);
            вк = вращайВлево(вк + ((dr | ~(ar)) ^ br) + x[3] + 0x5c4dd124, 15);
            bl = вращайВлево(bl + (((dl ^ al) & cl) ^ al) + x[1] + 0x5a827999, 13);
            br = вращайВлево(br + ((вк | ~(dr)) ^ ar) + x[7] + 0x5c4dd124, 7);
            al = вращайВлево(al + (((cl ^ dl) & bl) ^ dl) + x[10] + 0x5a827999, 11);
            ar = вращайВлево(ar + ((br | ~(вк)) ^ dr) + x[0] + 0x5c4dd124, 12);
            dl = вращайВлево(dl + (((bl ^ cl) & al) ^ cl) + x[6] + 0x5a827999, 9);
            dr = вращайВлево(dr + ((ar | ~(br)) ^ вк) + x[13] + 0x5c4dd124, 8);
            cl = вращайВлево(cl + (((al ^ bl) & dl) ^ bl) + x[15] + 0x5a827999, 7);
            вк = вращайВлево(вк + ((dr | ~(ar)) ^ br) + x[5] + 0x5c4dd124, 9);
            bl = вращайВлево(bl + (((dl ^ al) & cl) ^ al) + x[3] + 0x5a827999, 15);
            br = вращайВлево(br + ((вк | ~(dr)) ^ ar) + x[10] + 0x5c4dd124, 11);
            al = вращайВлево(al + (((cl ^ dl) & bl) ^ dl) + x[12] + 0x5a827999, 7);
            ar = вращайВлево(ar + ((br | ~(вк)) ^ dr) + x[14] + 0x5c4dd124, 7);
            dl = вращайВлево(dl + (((bl ^ cl) & al) ^ cl) + x[0] + 0x5a827999, 12);
            dr = вращайВлево(dr + ((ar | ~(br)) ^ вк) + x[15] + 0x5c4dd124, 7);
            cl = вращайВлево(cl + (((al ^ bl) & dl) ^ bl) + x[9] + 0x5a827999, 15);
            вк = вращайВлево(вк + ((dr | ~(ar)) ^ br) + x[8] + 0x5c4dd124, 12);
            bl = вращайВлево(bl + (((dl ^ al) & cl) ^ al) + x[5] + 0x5a827999, 9);
            br = вращайВлево(br + ((вк | ~(dr)) ^ ar) + x[12] + 0x5c4dd124, 7);
            al = вращайВлево(al + (((cl ^ dl) & bl) ^ dl) + x[2] + 0x5a827999, 11);
            ar = вращайВлево(ar + ((br | ~(вк)) ^ dr) + x[4] + 0x5c4dd124, 6);
            dl = вращайВлево(dl + (((bl ^ cl) & al) ^ cl) + x[14] + 0x5a827999, 7);
            dr = вращайВлево(dr + ((ar | ~(br)) ^ вк) + x[9] + 0x5c4dd124, 15);
            cl = вращайВлево(cl + (((al ^ bl) & dl) ^ bl) + x[11] + 0x5a827999, 13);
            вк = вращайВлево(вк + ((dr | ~(ar)) ^ br) + x[1] + 0x5c4dd124, 13);
            bl = вращайВлево(bl + (((dl ^ al) & cl) ^ al) + x[8] + 0x5a827999, 12);
            br = вращайВлево(br + ((вк | ~(dr)) ^ ar) + x[2] + 0x5c4dd124, 11);
            
            // Round 3 и parallel округли 3
            al = вращайВлево(al + ((bl | ~(cl)) ^ dl) + x[3] + 0x6ed9eba1, 11);
            ar = вращайВлево(ar + (((вк ^ dr) & br) ^ dr) + x[15] + 0x6d703ef3, 9);
            dl = вращайВлево(dl + ((al | ~(bl)) ^ cl) + x[10] + 0x6ed9eba1, 13);
            dr = вращайВлево(dr + (((br ^ вк) & ar) ^ вк) + x[5] + 0x6d703ef3, 7);
            cl = вращайВлево(cl + ((dl | ~(al)) ^ bl) + x[14] + 0x6ed9eba1, 6);
            вк = вращайВлево(вк + (((ar ^ br) & dr) ^ br) + x[1] + 0x6d703ef3, 15);
            bl = вращайВлево(bl + ((cl | ~(dl)) ^ al) + x[4] + 0x6ed9eba1, 7);
            br = вращайВлево(br + (((dr ^ ar) & вк) ^ ar) + x[3] + 0x6d703ef3, 11);
            al = вращайВлево(al + ((bl | ~(cl)) ^ dl) + x[9] + 0x6ed9eba1, 14);
            ar = вращайВлево(ar + (((вк ^ dr) & br) ^ dr) + x[7] + 0x6d703ef3, 8);
            dl = вращайВлево(dl + ((al | ~(bl)) ^ cl) + x[15] + 0x6ed9eba1, 9);
            dr = вращайВлево(dr + (((br ^ вк) & ar) ^ вк) + x[14] + 0x6d703ef3, 6);
            cl = вращайВлево(cl + ((dl | ~(al)) ^ bl) + x[8] + 0x6ed9eba1, 13);
            вк = вращайВлево(вк + (((ar ^ br) & dr) ^ br) + x[6] + 0x6d703ef3, 6);
            bl = вращайВлево(bl + ((cl | ~(dl)) ^ al) + x[1] + 0x6ed9eba1, 15);
            br = вращайВлево(br + (((dr ^ ar) & вк) ^ ar) + x[9] + 0x6d703ef3, 14);
            al = вращайВлево(al + ((bl | ~(cl)) ^ dl) + x[2] + 0x6ed9eba1, 14);
            ar = вращайВлево(ar + (((вк ^ dr) & br) ^ dr) + x[11] + 0x6d703ef3, 12);
            dl = вращайВлево(dl + ((al | ~(bl)) ^ cl) + x[7] + 0x6ed9eba1, 8);
            dr = вращайВлево(dr + (((br ^ вк) & ar) ^ вк) + x[8] + 0x6d703ef3, 13);
            cl = вращайВлево(cl + ((dl | ~(al)) ^ bl) + x[0] + 0x6ed9eba1, 13);
            вк = вращайВлево(вк + (((ar ^ br) & dr) ^ br) + x[12] + 0x6d703ef3, 5);
            bl = вращайВлево(bl + ((cl | ~(dl)) ^ al) + x[6] + 0x6ed9eba1, 6);
            br = вращайВлево(br + (((dr ^ ar) & вк) ^ ar) + x[2] + 0x6d703ef3, 14);
            al = вращайВлево(al + ((bl | ~(cl)) ^ dl) + x[13] + 0x6ed9eba1, 5);
            ar = вращайВлево(ar + (((вк ^ dr) & br) ^ dr) + x[10] + 0x6d703ef3, 13);
            dl = вращайВлево(dl + ((al | ~(bl)) ^ cl) + x[11] + 0x6ed9eba1, 12);
            dr = вращайВлево(dr + (((br ^ вк) & ar) ^ вк) + x[0] + 0x6d703ef3, 13);
            cl = вращайВлево(cl + ((dl | ~(al)) ^ bl) + x[5] + 0x6ed9eba1, 7);
            вк = вращайВлево(вк + (((ar ^ br) & dr) ^ br) + x[4] + 0x6d703ef3, 7);
            bl = вращайВлево(bl + ((cl | ~(dl)) ^ al) + x[12] + 0x6ed9eba1, 5);
            br = вращайВлево(br + (((dr ^ ar) & вк) ^ ar) + x[13] + 0x6d703ef3, 5);
            
            // Round 4 и parallel округли 4
            al = вращайВлево(al + ((bl & dl) | (cl & ~(dl))) + x[1] + 0x8f1bbcdc, 11);
            ar = вращайВлево(ar + (br ^ вк ^ dr) + x[8], 15);
            dl = вращайВлево(dl + ((al & cl) | (bl & ~(cl))) + x[9] + 0x8f1bbcdc, 12);
            dr = вращайВлево(dr + (ar ^ br ^ вк) + x[6], 5);
            cl = вращайВлево(cl + ((dl & bl) | (al & ~(bl))) + x[11] + 0x8f1bbcdc, 14);
            вк = вращайВлево(вк + (dr ^ ar ^ br) + x[4], 8);
            bl = вращайВлево(bl + ((cl & al) | (dl & ~(al))) + x[10] + 0x8f1bbcdc, 15);
            br = вращайВлево(br + (вк ^ dr ^ ar) + x[1], 11);
            al = вращайВлево(al + ((bl & dl) | (cl & ~(dl))) + x[0] + 0x8f1bbcdc, 14);
            ar = вращайВлево(ar + (br ^ вк ^ dr) + x[3], 14);
            dl = вращайВлево(dl + ((al & cl) | (bl & ~(cl))) + x[8] + 0x8f1bbcdc, 15);
            dr = вращайВлево(dr + (ar ^ br ^ вк) + x[11], 14);
            cl = вращайВлево(cl + ((dl & bl) | (al & ~(bl))) + x[12] + 0x8f1bbcdc, 9);
            вк = вращайВлево(вк + (dr ^ ar ^ br) + x[15], 6);
            bl = вращайВлево(bl + ((cl & al) | (dl & ~(al))) + x[4] + 0x8f1bbcdc, 8);
            br = вращайВлево(br + (вк ^ dr ^ ar) + x[0], 14);
            al = вращайВлево(al + ((bl & dl) | (cl & ~(dl))) + x[13] + 0x8f1bbcdc, 9);
            ar = вращайВлево(ar + (br ^ вк ^ dr) + x[5], 6);
            dl = вращайВлево(dl + ((al & cl) | (bl & ~(cl))) + x[3] + 0x8f1bbcdc, 14);
            dr = вращайВлево(dr + (ar ^ br ^ вк) + x[12], 9);
            cl = вращайВлево(cl + ((dl & bl) | (al & ~(bl))) + x[7] + 0x8f1bbcdc, 5);
            вк = вращайВлево(вк + (dr ^ ar ^ br) + x[2], 12);
            bl = вращайВлево(bl + ((cl & al) | (dl & ~(al))) + x[15] + 0x8f1bbcdc, 6);
            br = вращайВлево(br + (вк ^ dr ^ ar) + x[13], 9);
            al = вращайВлево(al + ((bl & dl) | (cl & ~(dl))) + x[14] + 0x8f1bbcdc, 8);
            ar = вращайВлево(ar + (br ^ вк ^ dr) + x[9], 12);
            dl = вращайВлево(dl + ((al & cl) | (bl & ~(cl))) + x[5] + 0x8f1bbcdc, 6);
            dr = вращайВлево(dr + (ar ^ br ^ вк) + x[7], 5);
            cl = вращайВлево(cl + ((dl & bl) | (al & ~(bl))) + x[6] + 0x8f1bbcdc, 5);
            вк = вращайВлево(вк + (dr ^ ar ^ br) + x[10], 15);
            bl = вращайВлево(bl + ((cl & al) | (dl & ~(al))) + x[2] + 0x8f1bbcdc, 12);
            br = вращайВлево(br + (вк ^ dr ^ ar) + x[14], 8);
            
            бцел t = контекст[1] + cl + dr;
            контекст[1] = контекст[2] + dl + ar;
            контекст[2] = контекст[3] + al + br;
            контекст[3] = контекст[0] + bl + вк;
            контекст[0] = t;

            x[] = 0;
        }

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
            "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
            "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
    ];

    static ткст[] результаты =
    [
            "cdf26213a150dc3ecb610f18f6b38b46",
            "86be7afa339d0fc7cfc785e72f578d33",
            "c14a12199c66e4ba84636b0f69144c77",
            "9e327b3d6e523062afc1132d7df9d1b8",
            "fd2aa607f71dc8f510714922b371834e",
            "a1aa0689d0fafa2ddc22e88b49133a06",
            "d1e959eb179c911faea4624c60c5c702",
            "3f45ef194732c2dbb2c4a2c769795fa3"
    ];

    Райпмд128 h = new Райпмд128();

    foreach (цел i, ткст s; strings)
            {
            h.обнови(cast(ббайт[]) s);
            ткст d = h.гексДайджест;

            assert(d == результаты[i],":("~s~")("~d~")!=("~результаты[i]~")");
            }

    ткст s = new сим[1000000];
    for (auto i = 0; i < s.length; i++) s[i] = 'a';
    ткст результат = "4a7f5723f954eba1216c9d8f6320431f";
    h.обнови(cast(ббайт[]) s);
    ткст d = h.гексДайджест;

    assert(d == результат,":(1 million times \"a\")("~d~")!=("~результат~")");
    }
	
}