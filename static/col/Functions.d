/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.Functions;

/**
 * Define a хэш function type.
 */
template ХэшФунк(З)
{
    alias бцел function(ref З знач) ХэшФунк;
}

/**
 * Define an update function type.  The update function is responsible for
 * performing the operation denoted by:
 *
 * origv = newv
 *
 * This can be different for Maps for example, where З may contain the ключ as
 * well as the значение.
 */
template ФункцОбновления(З)
{
    alias проц function(ref З origv, ref З newv) ФункцОбновления;
}

/**
 * Define a comparison function type
 *
 * This can be different for Maps in the same way the update function is
 * different.
 */
template ФункцСравнения(З)
{
    alias цел function(ref З v1, ref З v2) ФункцСравнения;
}

/**
 * Define the default сравни
 */
цел ДефСравнить(З)(ref З v1, ref З v2)
{
    return typeid(З).сравни(&v1, &v2);
}

/**
 * Define the default хэш function
 */
бцел ДефХэш(З)(ref З знач)
{
    return typeid(З).дайХэш(&знач);
}
