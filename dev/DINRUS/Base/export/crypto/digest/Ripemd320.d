﻿/*******************************************************************************
        This module реализует the Райпмд160 algorithm by Hans Dobbertin,
        Antoon Bosselaers и Bart Preneel.

        See http://homes.esat.kuleuven.be/~bosselae/rИПemd160.html for ещё
        information.

        The implementation is based on:
        RИПEMD-160 software записано by Antoon Bosselaers,
 		available at http://www.esat.kuleuven.ac.be/~cosicart/ps/AB-9601/

*******************************************************************************/
module crypto.digest.Ripemd320;

private import crypto.digest.MerkleDamgard;
public  import crypto.digest.Digest;

/*******************************************************************************

*******************************************************************************/

extern(D) final class Ripemd320 : МерклеДамгард
{
        /***********************************************************************

    	Construct a Ripemd320

     ***********************************************************************/

    this() ;

    /***********************************************************************

    	The размер of a Ripemd320 дайджест is 40 байты

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
    		final дайджест, либо a дайджест of the состояние between calls в_ обнови()

     ***********************************************************************/

    override проц создайДайджест(ббайт[] буф);


    /***********************************************************************

     	блок размер

    	Возвращает:
    	the блок размер

    	Примечания:
    	Specifies the размер (in байты) of the блок of данные в_ пароль в_
    	each вызов в_ трансформируй(). For Ripemd320 the размерБлока is 64.

     ***********************************************************************/

    protected override бцел размерБлока();

    /***********************************************************************

    	Length паддинг размер

    	Возвращает:
    	the length паддинг размер

    	Примечания:
    	Specifies the размер (in байты) of the паддинг which uses the
    	length of the данные which имеется been ciphered, this паддинг is
    	carried out by the падДлин метод. For Ripemd320 the добавьРазмер is 8.

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