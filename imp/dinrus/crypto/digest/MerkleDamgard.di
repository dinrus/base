﻿/*******************************************************************************
        This module реализует a генерный Merkle-Damgard хэш function

*******************************************************************************/
module crypto.digest.MerkleDamgard;

public  import stdrus;
public  import crypto.digest.Digest;

/*******************************************************************************

        Extending МерклеДамгард в_ создай a custom хэш function требует
        the implementation of a число of abstract methods. These include:
        ---
        public бцел размерДайджеста();
        protected проц сбрось();
        protected проц создайДайджест(ббайт[] буф);
        protected бцел размерБлока();
        protected бцел добавьРазмер();
        protected проц падСооб(ббайт[] данные);
        protected проц трансформируй(ббайт[] данные);
        ---

        In добавьition there есть_ли two further abstract methods; these methods
        have пустой default implementations since in some cases they are not
        требуется$(CLN)
        ---
        protected abstract проц падДлин(ббайт[] данные, бдол length);
        protected abstract проц расширь();
        ---

        The метод падДлин() is требуется в_ implement the SHA series of
        Хэш functions и also the Тигр algorithm. Метод расширь() is
        требуется only в_ implement the MD2 дайджест.

        The basic sequence of internal события is as follows:
        $(UL
        $(LI трансформируй(), 0 or ещё times)
        $(LI падСооб())
        $(LI падДлин())
        $(LI трансформируй())
        $(LI расширь())
        $(LI создайДайджест())
        $(LI сбрось())
        )

*******************************************************************************/

extern(D) package class МерклеДамгард : Дайджест
{
    private бцел    байты;
    private ббайт[] буфер;

    /***********************************************************************

            Constructs the дайджест

            Параметры:
            буф = a буфер with enough пространство в_ hold the дайджест

            Примечания:
            Constructs the дайджест.

    ***********************************************************************/

    protected abstract проц создайДайджест(ббайт[] буф);

    /***********************************************************************

            Дайджест блок размер

            Возвращает:
            the блок размер

            Примечания:
            Specifies the размер (in байты) of the блок of данные в_ пароль в_
            each вызов в_ трансформируй().

    ***********************************************************************/

    protected abstract бцел размерБлока();

    /***********************************************************************

            Length паддинг размер

            Возвращает:
            the length паддинг размер

            Примечания:
            Specifies the размер (in байты) of the паддинг which
            uses the length of the данные which имеется been fed в_ the
            algorithm, this паддинг is carried out by the
            падДлин метод.

    ***********************************************************************/

    protected abstract бцел добавьРазмер();

    /***********************************************************************

            Pads the дайджест данные

            Параметры:
            данные = a срез of the дайджест буфер в_ заполни with паддинг

            Примечания:
            Fills the passed буфер срез with the appropriate
            паддинг for the final вызов в_ трансформируй(). This
            паддинг will заполни the сообщение данные буфер up в_
            размерБлока()-добавьРазмер().

    ***********************************************************************/

    protected abstract проц падСооб(ббайт[] данные);

    /***********************************************************************

            Performs the length паддинг

            Параметры:
            данные   = the срез of the дайджест буфер в_ заполни with паддинг
            length = the length of the данные which имеется been processed

            Примечания:
            Fills the passed буфер срез with добавьРазмер() байты of паддинг
            based on the length in байты of the ввод данные which имеется been
            processed.

    ***********************************************************************/

    protected проц падДлин(ббайт[] данные, бдол length) {}

    /***********************************************************************

            Performs the дайджест on a блок of данные

            Параметры:
            данные = the блок of данные в_ дайджест

            Примечания:
            The actual дайджест algorithm is carried out by this метод on
            the passed блок of данные. This метод is called for every
            размерБлока() байты of ввод данные и once ещё with the остаток
            данные псеп_в_конце в_ размерБлока().

    ***********************************************************************/

    protected abstract проц трансформируй(ббайт[] данные);

    /***********************************************************************

            Final processing of дайджест.

            Примечания:
            This метод is called после the final трансформируй just приор в_
            the creation of the final дайджест. The MD2 algorithm требует
            an добавьitional step at this stage. Future digests may or may not
            require this метод.

    ***********************************************************************/

    protected проц расширь();

    /***********************************************************************

            Construct a дайджест

            Примечания:
            Constructs the internal буфер for use by the дайджест, the буфер
            размер (in байты) is defined by the abstract метод размерБлока().

    ***********************************************************************/

    this();

    /***********************************************************************

            Initialize the дайджест

            Примечания:
            Возвращает the дайджест состояние в_ its начальное значение

    ***********************************************************************/

    protected проц сбрось();

    /***********************************************************************

            Дайджест добавьitional данные

            Параметры:
            ввод = the данные в_ дайджест

            Примечания:
            Continues the дайджест operation on the добавьitional данные.

    ***********************************************************************/

    МерклеДамгард обнови (проц[] ввод);

    /***********************************************************************

            Complete the дайджест

            Возвращает:
            the completed дайджест

            Примечания:
            Concludes the algorithm producing the final дайджест.

    ***********************************************************************/

    ббайт[] двоичныйДайджест (ббайт[] буф = пусто);

    /***********************************************************************

            Converts 8 bit в_ 32 bit Литл Endian

            Параметры:
            ввод  = the исток Массив
            вывод = the приёмник Массив

            Примечания:
            Converts an Массив of ббайт[] преобр_в бцел[] in Литл Endian байт order.

    ***********************************************************************/

    static protected final проц littleEndian32(ббайт[] ввод, бцел[] вывод);

    /***********************************************************************

            Converts 8 bit в_ 32 bit Биг Endian

            Параметры:
            ввод  = the исток Массив
            вывод = the приёмник Массив

            Примечания:
            Converts an Массив of ббайт[] преобр_в бцел[] in Биг Endian байт order.

    ***********************************************************************/

    static protected final проц bigEndian32(ббайт[] ввод, бцел[] вывод);

    /***********************************************************************

            Converts 8 bit в_ 64 bit Литл Endian

            Параметры:
            ввод  = the исток Массив
            вывод = the приёмник Массив

            Примечания:
            Converts an Массив of ббайт[] преобр_в бдол[] in Литл Endian байт order.

    ***********************************************************************/

    static protected final проц littleEndian64(ббайт[] ввод, бдол[] вывод);

    /***********************************************************************

            Converts 8 bit в_ 64 bit Биг Endian

            Параметры: ввод  = the исток Массив
            вывод = the приёмник Массив

            Примечания:
            Converts an Массив of ббайт[] преобр_в бдол[] in Биг Endian байт order.

    ***********************************************************************/

    static protected final проц bigEndian64(ббайт[] ввод, бдол[] вывод);

    /***********************************************************************

            Rotate лево by n

            Параметры:
            x = the значение в_ rotate
            n = the amount в_ rotate by

            Примечания:
            Rotates a 32 bit значение by the specified amount.

    ***********************************************************************/

    static protected final бцел вращайВлево(бцел x, бцел n);
}


