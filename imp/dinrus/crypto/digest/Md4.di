﻿/*******************************************************************************
        This module реализует the MD4 Message Дайджест Algorithm as described
        by RFC 1320 The MD4 Message-Дайджест Algorithm. R. Rivest. April 1992.

*******************************************************************************/
module crypto.digest.Md4;

public  import crypto.digest.Digest;
private import crypto.digest.MerkleDamgard;

/*******************************************************************************

*******************************************************************************/

extern(D) class Мд4 : МерклеДамгард
{
    /***********************************************************************

            Конструирует Мд4

    ***********************************************************************/

    this();

    /***********************************************************************

            The MD 4 дайджест размер is 16 байты

    ***********************************************************************/

    бцел размерДайджеста();

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
            each вызов в_ трансформируй(). For MD4 the размерБлока is 64.

    ***********************************************************************/

    protected override бцел размерБлока();

    /***********************************************************************

            Length паддинг размер

            Возвращает:
            the length паддинг размер

            Примечания:
            Specifies the размер (in байты) of the паддинг which uses the
            length of the данные which имеется been ciphered, this паддинг is
            carried out by the падДлин метод. For MD4 the добавьРазмер is 8.

    ***********************************************************************/

    protected override бцел добавьРазмер();

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
            "a",
            "abc",
            "сообщение дайджест",
            "abcdefghijklmnopqrstuvwxyz",
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
            "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
        ];

        static ткст[] результаты =
        [
            "31d6cfe0d16ae931b73c59d7e0c089c0",
            "bde52cb31de33e46245e05fbdbd6fb24",
            "a448017aaf21d8525fc10ae87aa6729d",
            "d9130a8164549fe818874806e1c7014b",
            "d79e1c308aa5bbcdeea8ed63df412da9",
            "043f8582f241db351ce627e153e7f0e4",
            "e33b4ddc9c38f2199c3e7b164fcc0536"
        ];

        Мд4 h = new Мд4();

        foreach (цел i, ткст s; strings)
        {
            h.обнови(s);
            ткст d = h.гексДайджест;
            assert(d == результаты[i],":("~s~")("~d~")!=("~результаты[i]~")");
        }
    }
}

