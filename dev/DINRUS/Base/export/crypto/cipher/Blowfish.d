module crypto.cipher.Blowfish;

private import crypto.cipher.Cipher;

/** Реализация шифра Камбала (Blowfish), разработанная Bruce Schneier. */
extern(D) class Камбала : ШифрБлок
{
    final override ткст имя();
    final override бцел размерБлока();
    final проц иниц(бул зашифруй, СимметричныйКлюч парамыКлюча);
    final override бцел обнови(проц[] ввод_, проц[] вывод_);
    final override проц сбрось();

}
