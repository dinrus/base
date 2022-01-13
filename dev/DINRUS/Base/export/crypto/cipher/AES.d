module crypto.cipher.AES;

import crypto.cipher.Cipher;

/**
 * Реализация шифра US АЭС (Rijndael 128),
 * разработанная Vincent Rijmen и Joan Daemen.
 * 
 * Соответствует: FIPS-197
 * Ссылки: http://csrc.nist.gov/publications/fИПs/fips197/fips-197.pdf
 */
extern(D) class АЭС : ШифрБлок
{
    final override ткст имя();
    final override бцел размерБлока();
    final проц иниц(бул зашифруй, СимметричныйКлюч парамыКлюча);    
    final override бцел обнови(проц[] ввод_, проц[] вывод_);    
    final override проц сбрось(); 
}
