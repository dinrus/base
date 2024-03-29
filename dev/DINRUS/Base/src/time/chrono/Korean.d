﻿/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Mопр 2005: Initial release
                        Apr 2007: reshaped

        author:         John Chapman, Kris

******************************************************************************/

module time.chrono.Korean;

private import time.chrono.GregorianBased;


/**
 * $(ANCHOR _Корейский)
 * Представляет корейский Календарь.
 */
export class Корейский : ГрегорианВОснове
{
    /**
     * $(I Свойство.) Переписано. Предоставляет определитель, ассоциированный с текущ Календарь.
     * Возвращает: Целое, представляющее определитель текущ Календаря.
     */
    export override бцел ид()
    {
        return КОРЕЙСКИЙ;
    }

}


