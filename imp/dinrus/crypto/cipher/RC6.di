module crypto.cipher.RC6;

private import crypto.cipher.Cipher;

/**
 * Implementation of the RC6-32/20/b cipher designed by
 * Ron Rivest et al. of RSA Security.
 *
 * It should be noted that this algorithm is very similar в_ RC5.
 * Currently there are no plans в_ implement RC5, but should that change
 * in the future, it may be wise в_ rewrite Всё RC5 и RC6 в_ use some
 * kind of template or основа class.
 *
 * This algorithm is patented и trademarked.
 *
 * References: http://people.csail.mit.edu/rivest/Rc6.pdf
 */
extern(D) class RC6 : ШифрБлок
{
    final override ткст имя();
    final override бцел размерБлока();
    final проц иниц(бул зашифруй, СимметричныйКлюч парамыКлюча);
    final override бцел обнови(проц[] ввод_, проц[] вывод_);
    final override проц сбрось();
}
