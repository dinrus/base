﻿/*******************************************************************************

        This module реализует the SHA-256 Algorithm described by Secure
        Хэш Standard, FИПS PUB 180-2

*******************************************************************************/

module crypto.digest.Sha256;

public  import crypto.digest.Digest;
private import crypto.digest.MerkleDamgard;

/*******************************************************************************

*******************************************************************************/

extern(D) final class Sha256 : МерклеДамгард
{

        /***********************************************************************

                Конструирует Sha256

        ***********************************************************************/

        this() ;

        /***********************************************************************

                Initialize the cipher

                Примечания:
                Возвращает the cipher состояние в_ it's начальное значение

        ***********************************************************************/

        protected override проц сбрось();

        /***********************************************************************

                Obtain the дайджест

                Примечания:
                Возвращает дайджест of the текущ cipher состояние, this may be the
                final дайджест, либо a дайджест of the состояние between calls в_ обнови()

        ***********************************************************************/

        protected override проц создайДайджест (ббайт[] буф);

        /***********************************************************************

                The дайджест размер of Sha-256 is 32 байты

        ***********************************************************************/

        бцел размерДайджеста() ;

        /***********************************************************************

                Шифр блок размер

                Возвращает:
                the блок размер

                Примечания:
                Specifies the размер (in байты) of the блок of данные в_ пароль в_
                each вызов в_ трансформируй(). For SHA256 the размерБлока is 64.

        ***********************************************************************/

        protected override бцел размерБлока() ;

        /***********************************************************************

                Length паддинг размер

                Возвращает:
                the length паддинг размер

                Примечания:
                Specifies the размер (in байты) of the паддинг which uses the
                length of the данные which имеется been ciphered, this паддинг is
                carried out by the падДлин метод. For SHA256 the добавьРазмер is 8.

        ***********************************************************************/

        protected override бцел добавьРазмер()   ;

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
