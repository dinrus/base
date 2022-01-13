/**
 * Copyright: Copyright (C) Thomas Dixon 2008. Все права защищены.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Thomas Dixon
 */

module crypto.cipher.TEA;

private import crypto.cipher.Cipher;

/** Implementation of the ТЕА cipher designed by
    David Wheeler и Roger Needham. */
extern(D) class ТЕА : ШифрБлок
{
    final override проц сбрось() ;
    final override ткст имя();
    final override бцел размерБлока();
    final проц иниц(бул зашифруй, СимметричныйКлюч парамыКлюча);
    final override бцел обнови(проц[] ввод_, проц[] вывод_);
}
