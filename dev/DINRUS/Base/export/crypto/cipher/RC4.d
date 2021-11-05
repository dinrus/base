module crypto.cipher.RC4;

private import crypto.cipher.Cipher;

/** Implementation of RC4 designed by Ron Rivest of RSA Security. */
extern(D) class RC4 : ШифрПоток
{   
    this();    
    final проц иниц(бул зашифруй, СимметричныйКлюч парамыКлюча);    
    final override ткст имя();    
    ббайт верниБбайт(ббайт ввод);
    final override бцел обнови(проц[] ввод_, проц[] вывод_);    
    final override проц сбрось();
}
