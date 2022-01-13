﻿/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Mопр 2005: Initial release
                        Apr 2007: reshaped                        

        author:         John Chapman, Kris

******************************************************************************/

module time.chrono.Japanese;

private import time.chrono.GregorianBased;


/**
 * $(ANCHOR _Японский)
 * Представляет японский Календарь.
 */
export class Японский : ГрегорианВОснове 
{
  /**
   * $(I Свойство.) Переписано. Получает определитель, ассоциированный с текущ Календарь.
   * Возвращает: Целое число, представляющее определитель текущего Календаря.
   */
  export override бцел ид() {
    return ЯПОНСКИЙ;
  }

}
