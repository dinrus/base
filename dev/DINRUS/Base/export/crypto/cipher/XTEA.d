module crypto.cipher.XTEA;

private import crypto.cipher.Cipher;

/** Implementation of the ХТЕА cipher designed by
    David Wheeler и Roger Needham. */
class ХТЕА : ШифрБлок
{
    final override проц сбрось();    
    final override ткст имя();    
    final override бцел размерБлока();    
    final проц иниц(бул зашифруй, СимметричныйКлюч парамыКлюча);    
    final override бцел обнови(проц[] ввод_, проц[] вывод_);
}