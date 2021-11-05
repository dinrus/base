﻿
module net.http.HttpStack;

/******************************************************************************

        Internal representation of a токен

******************************************************************************/

class Токен
{
        private ткст значение;

        Токен установи (ткст значение);

        ткст вТкст ();
}

/******************************************************************************

        A стэк of Tokens, использован for capturing http заголовки. The токены
        themselves are typically mapped onto the контент of a Буфер, 
        or some другой external контент, so there's minimal allocation 
        involved (typically zero).

******************************************************************************/

class СтэкППГТ
{
        private цел     глубина;
        private Токен[] токены;

        private static const цел МаксРазмСтэкаППГТ = 256;

        /**********************************************************************

                Construct a СтэкППГТ with the specified начальное размер. 
                The стэк will later be resized as necessary.

        **********************************************************************/

        this (цел размер = 10);

        /**********************************************************************

                Clone this стэк of токены

        **********************************************************************/

        СтэкППГТ клонируй ();

        /**********************************************************************

                Iterate over все токены in стэк

        **********************************************************************/

        цел opApply (цел delegate(ref Токен) дг);
        

        /**********************************************************************

                Pop the стэк все the way back в_ zero

        **********************************************************************/

        final проц сбрось ();

        /**********************************************************************

                Scan the токены looking for the первый one with a совпадают
                имя. Returns the совпадают Токен, or пусто if there is no
                such сверь.

        **********************************************************************/

        final Токен найдиТокен (ткст сверь);

        /**********************************************************************

                Scan the токены looking for the первый one with a совпадают
                имя, и удали it. Returns да if a сверь was найдено, or
                нет if not.

        **********************************************************************/

        final бул удалиТокен (ткст сверь);

        /**********************************************************************

                Return the текущ стэк глубина

        **********************************************************************/

        final цел размер ();

        /**********************************************************************

                Push a new токен onto the стэк, и установи it контент в_ 
                that provопрed. Returns the new Токен.

        **********************************************************************/

        final Токен сунь (ткст контент);

        /**********************************************************************

                Push a new токен onto the стэк, и установи it контент в_ 
                be that of the specified токен. Returns the new Токен.

        **********************************************************************/

        final Токен сунь (ref Токен токен);

        /**********************************************************************

                Push a new токен onto the стэк, и return it.

        **********************************************************************/

        final Токен сунь ();

        /**********************************************************************

                Pop the стэк by one.

        **********************************************************************/

        final проц вынь ();

        /**********************************************************************

                See if the given токен совпадает the specified текст. The 
                two must сверь the minimal протяженность exactly.

        **********************************************************************/

        final static бул совпадает (ref Токен токен, ткст сверь);
        
        /**********************************************************************

                Resize this стэк by extending the Массив.

        **********************************************************************/

        final static проц перемерь (ref Токен[] токены, цел размер);
}
