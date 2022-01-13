/**
 * Copyright: Copyright (C) Thomas Dixon 2009. Все права защищены.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Thomas Dixon
 */

module crypto.cipher.Salsa20;

private import crypto.cipher.Cipher;

/** Implementation of Сальса20 designed by Daniel J. Bernstein. */
extern(D) class Сальса20 : ШифрПоток
{    
    this();    
    проц иниц(бул зашифруй, Параметры парамы);    
    ткст имя();    
    ббайт верниБбайт(ббайт ввод);    
    бцел обнови(проц[] ввод_, проц[] вывод_);    
    проц сбрось();
}
