﻿module time.StopWatch;

/*******************************************************************************

        Таймер для измерения небольших интервалов, например, продолжительности 
        подпроцедуры или иного резонно невеликого периода.
        ---
        Секундомер прошло;

        прошло.старт;

        // do something
        // ...

        дво i = прошло.стоп;
        ---

        The measured интервал is in units of сек, using floating-
        точка в_ represent fractions. This approach is ещё flexible 
        than целое arithmetic since it migrates trivially в_ ещё
        capable таймер hardware (there no implicit granularity в_ the
        measurable intervals, except the limits of fp представление)

        Секундомер is accurate в_ the протяженность of что the underlying OS
        supports. On linux systems, this accuracy is typically 1 us at 
        best. Win32 is generally ещё precise. 

        There is some minor overhead in using Секундомер, so возьми that преобр_в 
        account

*******************************************************************************/

extern(D) struct Секундомер
{

        /***********************************************************************
                
                Пуск таймера

        ***********************************************************************/
        
        проц старт();

        /***********************************************************************
                
                Стоп таймера и возврат истёкшего со времени старт()

        ***********************************************************************/
        
       дво стоп();

        /***********************************************************************
                
                Return прошло время since the последний старт() as микросекунды

        ***********************************************************************/
        
       бдол микросек();


}