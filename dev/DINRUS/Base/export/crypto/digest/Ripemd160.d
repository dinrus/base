﻿/*******************************************************************************
        This module реализует the Ripemd160 algorithm by Hans Dobbertin,
        Antoon Bosselaers и Bart Preneel.

        See http://homes.esat.kuleuven.be/~bosselae/rИПemd160.html for ещё
        information.

        The implementation is based on:
        RИПEMD-160 software записано by Antoon Bosselaers,
 		available at http://www.esat.kuleuven.ac.be/~cosicart/ps/AB-9601/

*******************************************************************************/
module crypto.digest.Ripemd160;

private import crypto.digest.MerkleDamgard;
public  import crypto.digest.Digest;

/*******************************************************************************

*******************************************************************************/

final class Ripemd160 : MerkleDamgard
{

    /***********************************************************************

    	Construct a Ripemd160

     ***********************************************************************/

    this();

    /***********************************************************************

    	The размер of a Ripemd160 дайджест is 20 байты

     ***********************************************************************/

    override бцел размерДайджеста();


    /***********************************************************************

    	Initialize the cipher

    	Примечания:
    		Возвращает the cipher состояние в_ it's начальное значение

     ***********************************************************************/

    override проц сбрось();

    /***********************************************************************

    	Obtain the дайджест

    	Возвращает:
    		the дайджест

    	Примечания:
    		Возвращает дайджест of the текущ cipher состояние, this may be the
    		final дайджест, or a дайджест of the состояние between calls в_ обнови()

     ***********************************************************************/

    override проц создайДайджест(ббайт[] буф);


    /***********************************************************************

     	блок размер

    	Возвращает:
    	the блок размер

    	Примечания:
    	Specifies the размер (in байты) of the блок of данные в_ пароль в_
    	each вызов в_ трансформируй(). For Ripemd160 the размерБлока is 64.

     ***********************************************************************/

    protected override бцел размерБлока();

    /***********************************************************************

    	Length паддинг размер

    	Возвращает:
    	the length паддинг размер

    	Примечания:
    	Specifies the размер (in байты) of the паддинг which uses the
    	length of the данные which имеется been ciphered, this паддинг is
    	carried out by the падДлин метод. For Ripemd160 the добавьРазмер is 8.

     ***********************************************************************/

    protected бцел добавьРазмер();

    /***********************************************************************

    	Pads the cipher данные

    	Параметры:
    	данные = a срез of the cipher буфер в_ заполни with паддинг

    	Примечания:
    	Fills the passed буфер срез with the appropriate паддинг for
    	the final вызов в_ трансформируй(). This паддинг will заполни the cipher
    	буфер up в_ размерБлока()-добавьРазмер().

     ***********************************************************************/

    protected override проц падСооб(ббайт[] at);

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

    protected override проц падДлин(ббайт[] at, бдол length);
	
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

        static ткст[] результатs =
        [
            "9c1185a5c5e9fc54612808977ee8f548b2258d31",
            "0bdc9d2d256b3ee9daae347be6f4dc835a467ffe",
            "8eb208f7e05d987a9b044a8e98c6b087f15a0bfc",
            "5d0689ef49d2fae572b881b123a85ffa21595f36",
            "f71c27109c692c1b56bbdceb5b9d2865b3708dbc",
            "12a053384a9c0c88e405a06c27dcf49ada62eb2b",
            "b0e20b6e3116640286ed3a87a5713079b21f5189",
            "9b752e45573d4b39f4dbd3323cab82bf63326bfb"
        ];

        Ripemd160 h = new Ripemd160();

        foreach (цел i, ткст s; strings)
        {
            h.обнови(cast(ббайт[]) s);
            ткст d = h.гексДайджест;

            assert(d == результатs[i],":("~s~")("~d~")!=("~результатs[i]~")");
        }


        ткст s = new сим[1000000];
        for (auto i = 0; i < s.length; i++) s[i] = 'a';
        ткст результат = "52783243c1697bdbe16d37f97f68f08325dc1528";
        h.обнови(cast(ббайт[]) s);
        ткст d = h.гексДайджест;

        assert(d == результат,":(1 million times \"a\")("~d~")!=("~результат~")");
    }

}
