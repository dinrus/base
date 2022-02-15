﻿module col.model.SortedValues;

private import  col.model.View,
                col.model.Comparator;


/**
 *
 *
 * ElementSorted is a mixin interface for Collections that
 * are всегда in sorted order with respect в_ a Сравнитель
 * held by the Коллекция.
 * <P>
 * ElementSorted Collections guarantee that enumerations
 * appear in sorted order;  that is if a и b are two Elements
 * obtained in succession из_ элементы().nextElement(), that
 * <PRE>
 * сравнитель(a, b) <= 0.
 * </PRE>
 *
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public interface СортированныеЗначения(T) : Обзор!(T)
{

        /**
         * Report the Сравнитель использован for ordering
        **/

        public Сравнитель!(T) сравнитель();
}

