﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
      
        version:        Initial release: May 2004
        
        author:         Kris

*******************************************************************************/

module util.log.model.ILogger;

/*******************************************************************************

*******************************************************************************/

interface ИЛоггер
{
        enum Уровень {След=0, Инфо, Предупрежд, Ошибка, Фатал, Нет};

        /***********************************************************************
        
                Is this logger enabed for the specified Уровень?

        ***********************************************************************/

        бул включен (Уровень уровень = Уровень.Фатал);

        /***********************************************************************

                Доб a след сообщение

        ***********************************************************************/

        проц след (ткст фмт, ...);

        /***********************************************************************

                Доб an инфо сообщение

        ***********************************************************************/

        проц инфо (ткст фмт, ...);
        
        /***********************************************************************

                Доб a warning сообщение

        ***********************************************************************/

        проц предупреди (ткст фмт, ...);

        /***********************************************************************

                Доб an ошибка сообщение

        ***********************************************************************/

        проц ошибка (ткст фмт, ...);

        /***********************************************************************

                Доб a фатал сообщение

        ***********************************************************************/

        проц фатал (ткст фмт, ...);

        /***********************************************************************

                Return the имя of this ИЛоггер (sans the appended dot).
       
        ***********************************************************************/

        ткст имя ();

        /***********************************************************************
        
                Return the Уровень this logger is установи в_

        ***********************************************************************/

        Уровень уровень ();

        /***********************************************************************
        
                Набор the текущ уровень for this logger (и only this logger).

        ***********************************************************************/

        ИЛоггер уровень (Уровень l);

        /***********************************************************************
        
                Is this logger аддитивный? That is, should we walk ancestors
                looking for ещё appenders?

        ***********************************************************************/

        бул аддитивный ();

        /***********************************************************************
        
                Набор the аддитивный статус of this logger. See isаддитивный().

        ***********************************************************************/

        ИЛоггер аддитивный (бул включен);

        /***********************************************************************
        
                Отправка a сообщение в_ this logger via its добавщик список.

        ***********************************************************************/

        ИЛоггер добавь (Уровень уровень, lazy ткст эксп);
}
