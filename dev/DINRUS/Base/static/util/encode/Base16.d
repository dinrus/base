﻿/*******************************************************************************

        copyright:      Copyright (c) 2010 Ulrik Mikaelsson. Все права защищены

        license:        BSD стиль: $(LICENSE)

        author:         Ulrik Mikaelsson

        standards:      rfc3548, rfc4648

*******************************************************************************/

/*******************************************************************************

    Этот модуль используется для раскодировки и кодировки гекс-массивов типа ткст.

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

module crypto.Base16;

/*******************************************************************************

    Вычисляет и возвращает размер, необходимый для кодирования переданного
    Массива.

    Параметры:
    данные = Массив, который будет кодирован

*******************************************************************************/


export бцел вычислиРазмерКодир(ббайт[] данные)
{
    return вычислиРазмерКодир(данные.length);
}

/*******************************************************************************

    Вычисляет и возвращает размер, необходимый для кодирования переданной длины.

    Параметры:
    длина = Число кодируемых байтов.

*******************************************************************************/

export бцел вычислиРазмерКодир(бцел длина)
{
    return длина*2;
}


/*******************************************************************************

    encodes данные и returns as an ASCII hex ткст.

    Параметры:
    данные = что is в_ be кодирован
    buff = буфер large enough в_ hold кодирован данные

    Example:
    ---
    сим[512] encodebuf;
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?", encodebuf);
    Стдвыв(myEncodedString).нс; // 48656C6C6F2C20686F772061726520796F7520746F6461793F
    ---


*******************************************************************************/

export ткст кодируй(ббайт[] данные, ткст buff)
in
{
    assert(данные);
    assert(buff.length >= вычислиРазмерКодир(данные));
}
body
{
    т_мера i;
    foreach (ббайт j; данные) {
        buff[i++] = _encodeTable[j >> 4];
        buff[i++] = _encodeTable[j & 0b0000_1111];
    }

    return buff[0..i];
}

/*******************************************************************************

    encodes данные и returns as an ASCII hex ткст.

    Параметры:
    данные = что is в_ be кодирован

    Example:
    ---
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?");
    Стдвыв(myEncodedString).нс; // 48656C6C6F2C20686F772061726520796F7520746F6461793F
    ---


*******************************************************************************/


export ткст кодируй(ббайт[] данные)
in
{
    assert(данные);
}
body
{
    auto rtn = new сим[вычислиРазмерКодир(данные)];
    return кодируй(данные, rtn);
}

/*******************************************************************************

    decodes an ASCII hex ткст и returns it as ббайт[] данные. Pre-allocates
    the размер of the Массив.

    This decoder will ignore non-hex characters. So:
    SGVsbG8sIGhvd
    yBhcmUgeW91IH
    RvZGF5Pw==

    Is действителен.

    Параметры:
    данные = что is в_ be decoded

    Example:
    ---
    ткст myDecodedString = cast(ткст)раскодируй("48656C6C6F2C20686F772061726520796F7520746F6461793F");
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
    auto rtn = new ббайт[данные.length+1/2];
    return раскодируй(данные, rtn);
}

/*******************************************************************************

    decodes an ASCII hex ткст и returns it as ббайт[] данные.

    This decoder will ignore non-hex characters. So:
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
    ткст myDecodedString = cast(ткст)раскодируй("48656C6C6F2C20686F772061726520796F7520746F6461793F", decodebuf);
    Стдвыв(myDecodeString).нс; // Hello, как are you today?
    ---

*******************************************************************************/

export ббайт[] раскодируй(ткст данные, ббайт[] buff)
in
{
    assert(данные);
}
body
{
    бул even=да;
    т_мера i;
    foreach (c; данные) {
        auto знач = _decodeTable[c];
        if (знач & 0b1000_0000)
            continue;
        if (even) {
            buff[i] = знач << 4; // Store знач in high for биты
        } else {
            buff[i] |= знач;     // OR-in low 4 биты,
            i += 1;             // и перемести on в_ следщ
        }
        even = !even; // Switch режим for следщ iteration
    }
    assert(even, "На вводе - нечетное количество гекс-символов.");
    return buff[0..i];
}

debug (UnitTest)
{
    unittest
    {
        static ткст[] testНеобр = [
            "",
            "A",
            "AB",
            "BAC",
            "BACD",
            "Hello, как are you today?",
            "AbCdEfGhIjKlMnOpQrStUvXyZ",
        ];
        static ткст[] testEnc = [
            "",
            "41",
            "4142",
            "424143",
            "42414344",
            "48656C6C6F2C20686F772061726520796F7520746F6461793F",
            "4162436445664768496A4B6C4D6E4F7051725374557658795A",
        ];

        for (т_мера i; i < testНеобр.length; i++) {
            auto результатChars = кодируй(cast(ббайт[])testНеобр[i]);
            assert(результатChars == testEnc[i],
                    testНеобр[i]~": ("~результатChars~") != ("~testEnc[i]~")");

            auto результатBytes = раскодируй(testEnc[i]);
            assert(результатBytes == cast(ббайт[])testНеобр[i],
                    testEnc[i]~": ("~cast(ткст)результатBytes~") != ("~testНеобр[i]~")");
        }
    }
}



private:

/*
    Static неменяемыйtables использован for быстро lookups в_
    кодируй и раскодируй данные.
*/
static const ббайт hex_PAD = '=';
static const ткст _encodeTable = "0123456789ABCDEF";

static const ббайт[] _decodeTable = [
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0x00,0x01,0x02,0x03, 0x04,0x05,0x06,0x07, 0x08,0x09,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0x0A,0x0B,0x0C, 0x0D,0x0E,0x0F,0x1F, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0x0A,0x0B,0x0C, 0x0D,0x0E,0x0F,0x1F, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
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
