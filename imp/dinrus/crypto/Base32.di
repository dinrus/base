/*******************************************************************************

    This module is использован в_ раскодируй и кодируй base32 ткст массивы.

    Example:
    ---
    ткст blah = "Hello there, my имя is Jeff.";

    scope encodebuf = new сим[вычислиРазмерКодир(cast(ббайт[])blah)];
    ткст кодирован = кодируй(cast(ббайт[])blah, encodebuf);

    scope decodebuf = new ббайт[кодирован.length];
    if (cast(ткст)раскодируй(кодирован, decodebuf) == "Hello there, my имя is Jeff.")
        Стдвыв("yay").нс;
    ---

    Since v1.0

*******************************************************************************/

module crypto.Base32;

extern(D):
/*******************************************************************************

    calculates и returns the размер needed в_ кодируй the length of the
    Массив passed.

    Параметры:
    данные = An Массив that will be кодирован

*******************************************************************************/
бцел вычислиРазмерКодир(ббайт[] данные);

/*******************************************************************************

    calculates и returns the размер needed в_ кодируй the length passed.

    Параметры:
    length = Число of байты в_ be кодирован

*******************************************************************************/
бцел вычислиРазмерКодир(бцел длина);

/*******************************************************************************

    encodes данные и returns as an ASCII base32 ткст.

    Параметры:
    данные = что is в_ be кодирован
    buff = буфер large enough в_ hold кодирован данные
    пад  = Whether в_ пад аски вывод with '='-симвы

    Example:
    ---
    сим[512] encodebuf;
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?", encodebuf);
    Стдвыв(myEncodedString).нс; // JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7
    ---


*******************************************************************************/
ткст кодируй(ббайт[] данные, ткст буф, бул пад = да);

/*******************************************************************************

    encodes данные и returns as an ASCII base32 ткст.

    Параметры:
    данные = что is в_ be кодирован
    пад = whether в_ пад вывод with '='-симвы

    Example:
    ---
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?");
    Стдвыв(myEncodedString).нс; // JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7
    ---


*******************************************************************************/
 ткст кодируй(ббайт[] данные, бул пад = да);

/*******************************************************************************

    decodes an ASCII base32 ткст и returns it as ббайт[] данные. Pre-allocates
    the размер of the Массив.

    This decoder will ignore non-base32 characters. So:
    SGVsbG8sIGhvd
    yBhcmUgeW91IH
    RvZGF5Pw==

    Is действителен.

    Параметры:
    данные = что is в_ be decoded

    Example:
    ---
    ткст myDecodedString = cast(ткст)раскодируй("JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7");
    Стдвыв(myDecodeString).нс; // Hello, как are you today?
    ---

*******************************************************************************/
ббайт[] раскодируй(ткст данные);

/*******************************************************************************

    decodes an ASCII base32 ткст и returns it as ббайт[] данные.

    This decoder will ignore non-base32 characters. So:
    SGVsbG8sIGhvd
    yBhcmUgeW91IH
    RvZGF5Pw==

    Is действителен.

    Параметры:
    данные = что is в_ be decoded
    buff = a big enough Массив в_ hold the decoded данные

    Example:
    ---
    ббайт[512] decodebuf;
    ткст myDecodedString = cast(ткст)раскодируй("JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7", decodebuf);
    Стдвыв(myDecodeString).нс; // Hello, как are you today?
    ---

*******************************************************************************/
ббайт[] раскодируй(ткст данные, ббайт[] буф);