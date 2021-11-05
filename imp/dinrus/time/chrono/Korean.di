﻿module time.chrono.Korean;

private import time.chrono.GregorianBased;


/**
 * $(ANCHOR _Корейский)
 * Представляет корейский Календарь.
 */
extern(D) class Корейский : ГрегорианВОснове
{
    /**
     * $(I Property.) Переписано. Предоставляет определитель, ассоциированный с текущ Календарь.
     * Возвращает: Целое, представляющее определитель текущ Календаря.
     */
    override бцел ид();

}


