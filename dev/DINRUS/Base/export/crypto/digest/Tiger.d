﻿/*******************************************************************************

       This module реализует the Тигр algorithm by Ross Anderson и Eli
        Biham.

*******************************************************************************/
module crypto.digest.Tiger;

private import crypto.digest.MerkleDamgard;
public  import crypto.digest.Digest;

/*******************************************************************************

*******************************************************************************/

extern(D) final class Тигр : МерклеДамгард
{

        /***********************************************************************

                Конструирует Тигр

        ***********************************************************************/

        this();

        /***********************************************************************

                The размер of a tiger дайджест is 24 байты
                
        ***********************************************************************/

        override бцел размерДайджеста() ;
        

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

                Get the число of проходки being performed

                Возвращает:
                the число of проходки

                Примечания:
                The Тигр algorithm may выполни an arbitrary число of проходки
                the minimum recommended число is 3 и this число should be
                quite безопасно however the "ultra-cautious" may wish в_ increase
                this число.

        ***********************************************************************/

        бцел проходки();

        /***********************************************************************

                Набор the число of проходки в_ be performed

                Параметры:
                n = the число of проходки в_ выполни

                Примечания:
                The Тигр algorithm may выполни an arbitrary число of проходки
                the minimum recommended число is 3 и this число should be
                quite безопасно however the "ultra-cautious" may wish в_ increase
                this число.

        ***********************************************************************/

        проц проходки(бцел n);

        /***********************************************************************

                 блок размер

                Возвращает:
                the блок размер

                Примечания:
                Specifies the размер (in байты) of the блок of данные в_ пароль в_
                each вызов в_ трансформируй(). For Тигр the размерБлока is 64.

        ***********************************************************************/

        protected override бцел размерБлока();

        /***********************************************************************

                Length паддинг размер

                Возвращает:
                the length паддинг размер

                Примечания:
                Specifies the размер (in байты) of the паддинг which uses the
                length of the данные which имеется been ciphered, this паддинг is
                carried out by the падДлин метод. For Тигр the добавьРазмер is 8.

        ***********************************************************************/

        protected бцел добавьРазмер()   ;

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