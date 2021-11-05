/*******************************************************************************

        copyright:      Copyright (c) 2010 Ulrik Mikaelsson. Все права защищены

        license:        BSD стиль: $(LICENSE)

        author:         Ulrik Mikaelsson

        standards:      rfc3548, rfc4648

*******************************************************************************/

/*******************************************************************************

    This module is использован в_ раскодируй и кодируй base32 ткст массивы.

    Пример:
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

/*******************************************************************************

    calculates и returns the размер needed в_ кодируй the length of the
    Массив passed.

    Параметры:
    данные = An Массив that will be кодирован

*******************************************************************************/


export бцел вычислиРазмерКодир(ббайт[] данные)
{
    return вычислиРазмерКодир(данные.length);
}

/*******************************************************************************

    calculates и returns the размер needed в_ кодируй the length passed.

    Параметры:
    length = Число of байты в_ be кодирован

*******************************************************************************/

export бцел вычислиРазмерКодир(бцел length)
{
    auto inputbits = length * 8;
    auto inputquantas = (inputbits + 39) / 40; // Round upwards
    return inputquantas * 8;
}


/*******************************************************************************

    encodes данные и returns as an ASCII base32 ткст.

    Параметры:
    данные = что is в_ be кодирован
    буф = буфер large enough в_ hold кодирован данные
    пад  = Whether в_ пад аски вывод with '='-симвы

    Пример:
    ---
    сим[512] encodebuf;
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?", encodebuf);
    Стдвыв(myEncodedString).нс; // JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7
    ---


*******************************************************************************/

export ткст кодируй(ббайт[] данные, ткст буф, бул пад=да)
in
{
    assert(данные);
    assert(буф.length >= вычислиРазмерКодир(данные));
}
body
{
    бцел i = 0;
    бкрат остаток; // Carries перебор биты в_ следщ сим
    байт остдлина;  // Tracks биты in остаток
    foreach (ббайт j; данные)
    {
        остаток = (остаток<<8) | j;
        остдлина += 8;
        do
        {
            остдлина -= 5;
            буф[i++] = _encodeTable[(остаток>>остдлина)&0b11111];
        }
        while (остдлина > 5)
        }
    if (остдлина)
        буф[i++] = _encodeTable[(остаток<<(5-остдлина))&0b11111];
    if (пад)
    {
        for (ббайт padCount=(-i%8); padCount > 0; padCount--)
            буф[i++] = base32_PAD;
    }

    return буф[0..i];
}

/*******************************************************************************

    encodes данные и returns as an ASCII base32 ткст.

    Параметры:
    данные = что is в_ be кодирован
    пад = whether в_ пад вывод with '='-симвы

    Пример:
    ---
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?");
    Стдвыв(myEncodedString).нс; // JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7
    ---


*******************************************************************************/


export ткст кодируй(ббайт[] данные, бул пад=да)
in
{
    assert(данные);
}
body
{
    auto rtn = new сим[вычислиРазмерКодир(данные)];
    return кодируй(данные, rtn, пад);
}

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

    Пример:
    ---
    ткст myDecodedString = cast(ткст)раскодируй("JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7");
    Стдвыв(myDecodeString).нс; // Hello, как are you today?
    ---

*******************************************************************************/

export ббайт[] раскодируй(ткст данные)
in
{
    assert(данные);
}
body
{
    auto rtn = new ббайт[данные.length];
    return раскодируй(данные, rtn);
}

/*******************************************************************************

    decodes an ASCII base32 ткст и returns it as ббайт[] данные.

    This decoder will ignore non-base32 characters. So:
    SGVsbG8sIGhvd
    yBhcmUgeW91IH
    RvZGF5Pw==

    Is действителен.

    Параметры:
    данные = что is в_ be decoded
    буф = a big enough Массив в_ hold the decoded данные

    Пример:
    ---
    ббайт[512] decodebuf;
    ткст myDecodedString = cast(ткст)раскодируй("JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7", decodebuf);
    Стдвыв(myDecodeString).нс; // Hello, как are you today?
    ---

*******************************************************************************/
export ббайт[] раскодируй(ткст данные, ббайт[] буф)
in
{
    assert(данные);
}
body
{
    бкрат остаток;
    байт остдлина;
    т_мера oIndex;
    foreach (c; данные)
    {
        auto dec = _decodeTable[c];
        if (dec & 0b1000_0000)
            continue;
        остаток = (остаток<<5) | dec;
        for (остдлина += 5; остдлина >= 8; остдлина -= 8)
            буф[oIndex++] = остаток >> (остдлина-8);
    }

    return буф[0..oIndex];
}

debug (UnitTest)
{
    unittest
    {
        static ткст[] testBytes = [
            "",
            "foo",
            "fСПД",
            "fСПДa",
            "fСПДar",
            "Hello, как are you today?",
        ];
        static ткст[] testChars = [
            "",
            "MZXW6===",
            "MZXW6YQ=",
            "MZXW6YTB",
            "MZXW6YTBOI======",
            "JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7",
        ];

        for (бцел i; i < testBytes.length; i++)
        {
            auto результатChars = кодируй(cast(ббайт[])testBytes[i]);
            assert(результатChars == testChars[i],
            testBytes[i]~": ("~результатChars~") != ("~testChars[i]~")");

            auto результатBytes = раскодируй(testChars[i]);
            assert(результатBytes == cast(ббайт[])testBytes[i],
            testChars[i]~": ("~cast(ткст)результатBytes~") != ("~testBytes[i]~")");
        }
    }
}



private:

/*
    Static неменяемый  tables использован for быстро lookups в_
    кодируй и раскодируй данные.
*/
static const ббайт base32_PAD = '=';
static const ткст _encodeTable = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";

static const ббайт[] _decodeTable = [
            0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
            0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
            0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
            0xFF,0xFF,0x1A,0x1B, 0x1C,0x1D,0x1E,0x1F, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
            0xFF,0x00,0x01,0x02, 0x03,0x04,0x05,0x06, 0x07,0x08,0x09,0x0A, 0x0B,0x0C,0x0D,0x0E,
            0x0F,0x10,0x11,0x12, 0x13,0x14,0x15,0x16, 0x17,0x18,0x19,0xFF, 0xFF,0xFF,0xFF,0xFF,
            0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
            0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
            0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
            0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
            0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
            0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
            0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
            0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
            0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
            0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
        ];
