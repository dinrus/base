﻿/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Mопр 2005: Initial release
                        Apr 2007: reshaped                        

        author:         John Chapman, Kris

******************************************************************************/

module time.chrono.Taiwan;

private import time.chrono.GregorianBased;

/**
 * $(ANCHOR _Taiwan)
 * Представляет Taiwan Календарь.
 */
export class Тайваньский : ГрегорианВОснове 
{
  /**
   * $(I Property.) Переписано. Retrieves the определитель associated with the текущ Календарь.
   * Возвращает: Целое, представляющее определитель of the текущ Календарь.
   */
  export override бцел опр() {
    return ТАЙВАНЬСКИЙ;
  }

}
