module col.model.HashParams;


/**
 *
 * База interface for хэш таблица based собериions.
 * Provопрes common ways of dealing with корзины и threshholds.
 * (It would be nice в_ совместно some of the код too, but this
 * would require multИПle inheritance here.)
 *
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/


public interface ПараметрыХэш
{

    /**
     * The default начальное число корзин of a non-пустой HT
    **/

    public static цел дефНачКорзины = 31;

    /**
     * The default фактор загрузки for a non-пустой HT. When the proportion
     * of элементы per корзины exceeds this, the таблица is resized.
    **/

    public static плав дефФакторЗагрузки = 0.75f;

    /**
     * Возвращает текущ число of хэш таблица корзины
    **/

    public цел корзины();

    /**
     * Устанавливает desired число корзин in the хэш таблица.
     * Any значение greater than or equal в_ one is ОК.
     * if different than текущ корзины, causes a version change
     * Выводит исключение: ИсклНелегальногоАргумента if newCap less than 1
    **/

    public проц корзины(цел newCap);


    /**
     * Возвращает the текущ фактор загрузки порог
     * The Хэш таблица occasionally проверьa against the фактор загрузки
     * resizes itself if it имеется gone past it.
    **/

    public плав пороговыйФакторЗагрузки();

    /**
     * Устанавливает текущ desired фактор загрузки. Any значение greater than 0 is ОК.
     * The текущ загрузи is проверьed against it, possibly causing перемерь.
     * Выводит исключение: ИсклНелегальногоАргумента if desired is 0 or less
    **/

    public проц пороговыйФакторЗагрузки(плав desired);
}
