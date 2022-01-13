﻿/*******************************************************************************

    This module is использован в_ раскодируй и кодируй base64 ткст массивы. 

    Пример:
    ---
    ткст blah = "Hello there, my имя is Jeff.";
    scope encodebuf = new сим[вычислиРазмерКодир(cast(ббайт[])blah)];
    ткст кодирован = кодируй(cast(ббайт[])blah, encodebuf);

    scope decodebuf = new ббайт[кодирован.length];
    if (cast(ткст)раскодируй(кодирован, decodebuf) == "Hello there, my имя is Jeff.")
        Стдвыв("yay").нс;
    ---

*******************************************************************************/

module crypto.Base64;

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
    т_мера счётТриплетов = length / 3;
    бцел триплетФракция = length % 3;
    return (счётТриплетов + (триплетФракция ? 1 : 0)) * 4; // for every 3 байты we need 4 байты в_ кодируй, with any дво needing an добавьitional 4 байты with паддинг
}


/*******************************************************************************

    encodes данные преобр_в буф и returns the число of байты кодирован.
    this will not терминируй и пад any "leftover" байты, и will instead
    only кодируй up в_ the highest число of байты divisible by three.

    returns the число of байты лево в_ кодируй

    Параметры:
    данные = что is в_ be кодирован
    буф = буфер large enough в_ hold кодирован данные
    байтЗакодировано = ref that returns как much of the буфер was filled

*******************************************************************************/

export цел кодируйЧанк(ббайт[] данные, ткст буф, ref цел байтЗакодировано)
{
    т_мера счётТриплетов = данные.length / 3;
    цел rtn = 0;
    сим *rtnPtr = буф.ptr;
    ббайт *dataPtr = данные.ptr;

    if (данные.length > 0)
    {
        rtn = счётТриплетов * 3;
        байтЗакодировано = счётТриплетов * 4;
        for (т_мера i; i < счётТриплетов; i++)
        {
            *rtnPtr++ = _encodeTable[((dataPtr[0] & 0xFC) >> 2)];
            *rtnPtr++ = _encodeTable[(((dataPtr[0] & 0x03) << 4) | ((dataPtr[1] & 0xF0) >> 4))];
            *rtnPtr++ = _encodeTable[(((dataPtr[1] & 0x0F) << 2) | ((dataPtr[2] & 0xC0) >> 6))];
            *rtnPtr++ = _encodeTable[(dataPtr[2] & 0x3F)];
            dataPtr += 3;
        }
    }

    return rtn;
}

/*******************************************************************************

    encodes данные и returns as an ASCII base64 ткст.

    Параметры:
    данные = что is в_ be кодирован
    буф = буфер large enough в_ hold кодирован данные

    Пример:
    ---
    сим[512] encodebuf;
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?", encodebuf);
    Стдвыв(myEncodedString).нс; // SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==
    ---


*******************************************************************************/

export ткст кодируй(ббайт[] данные, ткст буф)
in
{
    assert(данные);
    assert(буф.length >= вычислиРазмерКодир(данные));
}
body
{
    ткст rtn = пусто;

    if (данные.length > 0)
    {
        цел байтЗакодировано = 0;
        цел члоБайтов = кодируйЧанк(данные, буф, байтЗакодировано);
        сим *rtnPtr = буф.ptr + байтЗакодировано;
        ббайт *dataPtr = данные.ptr + члоБайтов;
        цел триплетФракция = данные.length - (dataPtr - данные.ptr);

        switch (триплетФракция)
        {
            case 2:
                *rtnPtr++ = _encodeTable[((dataPtr[0] & 0xFC) >> 2)];
                *rtnPtr++ = _encodeTable[(((dataPtr[0] & 0x03) << 4) | ((dataPtr[1] & 0xF0) >> 4))];
                *rtnPtr++ = _encodeTable[((dataPtr[1] & 0x0F) << 2)];
                *rtnPtr++ = '=';
                break;
            case 1:
                *rtnPtr++ = _encodeTable[((dataPtr[0] & 0xFC) >> 2)];
                *rtnPtr++ = _encodeTable[((dataPtr[0] & 0x03) << 4)];
                *rtnPtr++ = '=';
                *rtnPtr++ = '=';
                break;
            default:
                break;
        }
        rtn = буф[0..(rtnPtr - буф.ptr)];
    }

    return rtn;
}

/*******************************************************************************

    encodes данные и returns as an ASCII base64 ткст.

    Параметры:
    данные = что is в_ be кодирован

    Пример:
    ---
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?");
    Стдвыв(myEncodedString).нс; // SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==
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

    decodes an ASCCI base64 ткст и returns it as ббайт[] данные. Pre-allocates
    the размер of the Массив.

    This decoder will ignore non-base64 characters. So:
    SGVsbG8sIGhvd
    yBhcmUgeW91IH
    RvZGF5Pw==

    Is действителен.

    Параметры:
    данные = что is в_ be decoded

    Пример:
    ---
    ткст myDecodedString = cast(ткст)раскодируй("SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==");
    Стдвыв(myDecodedString).нс; // Hello, как are you today?
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

    decodes an ASCCI base64 ткст и returns it as ббайт[] данные.

    This decoder will ignore non-base64 characters. So:
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
    ткст myDecodedString = cast(ткст)раскодируй("SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==", decodebuf);
    Стдвыв(myDecodedString).нс; // Hello, как are you today?
    ---

*******************************************************************************/
       
export ббайт[] раскодируй(ткст данные, ббайт[] буф)
in
{
    assert(данные);
}
body
{
    ббайт[] rtn;

    if (данные.length > 0)
    {
        ббайт[4] base64Quad;
        ббайт *quadPtr = base64Quad.ptr;
        ббайт *endPtr = base64Quad.ptr + 4;
        ббайт *rtnPt = буф.ptr;
        т_мера encodedLength = 0;

        ббайт padCount = 0;
        ббайт endCount = 0;
        ббайт paddedPos = 0;
        foreach_reverse(сим piece; данные)
        {
            paddedPos++;
            ббайт текущ = _decodeTable[piece];
            if (текущ || piece == 'A')
            {
                endCount++;
                if (текущ == BASE64_PAD)
                    padCount++;
            }
            if (endCount == 4)
                break;
        }

        if (padCount > 2)
            throw new Исключение("Ненадлежаще завершённый base64 ткст. Пад-символ Base64 (=) обнаружен в неуместном расположении.");
        if (padCount == 0)
            paddedPos = 0;

        ткст nonPдобавьed = данные[0..(length - paddedPos)];
        foreach(piece; nonPдобавьed)
        {
            ббайт следщ = _decodeTable[piece];
            if (следщ || piece == 'A')
                *quadPtr++ = следщ;
            if (quadPtr is endPtr)
            {
                rtnPt[0] = cast(ббайт) ((base64Quad[0] << 2) | (base64Quad[1] >> 4));
                rtnPt[1] = cast(ббайт) ((base64Quad[1] << 4) | (base64Quad[2] >> 2));
                rtnPt[2] = cast(ббайт) ((base64Quad[2] << 6) | base64Quad[3]);
                encodedLength += 3;
                quadPtr = base64Quad.ptr;
                rtnPt += 3;
            }
        }

        // this will try и раскодируй whatever is лево, even if it isn't terminated properly (ie: missing последний one or two =)
        if (paddedPos)
        {
            ткст псеп_в_конце = данные[(length - paddedPos) .. length];
            foreach(сим piece; псеп_в_конце)
            {
                ббайт следщ = _decodeTable[piece];
                if (следщ || piece == 'A')
                    *quadPtr++ = следщ;
                if (quadPtr is endPtr)
                {
                    *rtnPt++ = cast(ббайт) (((base64Quad[0] << 2) | (base64Quad[1]) >> 4));
                    if (base64Quad[2] != BASE64_PAD)
                    {
                        *rtnPt++ = cast(ббайт) (((base64Quad[1] << 4) | (base64Quad[2] >> 2)));
                        encodedLength += 2;
                        break;
                    }
                    else
                    {
                        encodedLength++;
                        break;
                    }
                }
            }
        }

        rtn = буф[0..encodedLength];
    }

    return rtn;
}

version (Test)
{
    import scrapple.util.Test;
    import io.device.File;
    import time.StopWatch;
    import io.Stdout;

    unittest    
    {
        Test.Status encodeЧанкtest(ref ткст[] messages)
        {
            ткст стр = "Hello, как are you today?";
            ткст кодирован = new сим[вычислиРазмерКодир(cast(ббайт[])стр)];
            цел байтЗакодировано = 0;
            цел numBytesLeft = кодируйЧанк(cast(ббайт[])стр, кодирован, байтЗакодировано);
            ткст результат = кодирован[0..байтЗакодировано] ~ кодируй(cast(ббайт[])стр[numBytesLeft..$], кодирован[байтЗакодировано..$]);
            if (результат == "SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==")
                return Test.Status.Success;
            return Test.Status.Failure;
        }
        Test.Status encodeTest(ref ткст[] messages)
        {
            ткст кодирован = new сим[вычислиРазмерКодир(cast(ббайт[])"Hello, как are you today?")];
            ткст результат = кодируй(cast(ббайт[])"Hello, как are you today?", кодирован);
            if (результат == "SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==")
            {
                ткст результат2 = кодируй(cast(ббайт[])"Hello, как are you today?");
                if (результат == "SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==")
                    return Test.Status.Success;
            }

            return Test.Status.Failure;
        }

        Test.Status decodeTest(ref ткст[] messages)
        {
            ббайт[1024] decoded;
            ббайт[] результат = раскодируй("SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==", decoded);
            if (результат == cast(ббайт[])"Hello, как are you today?")
            {
                результат = раскодируй("SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==");
                if (результат == cast(ббайт[])"Hello, как are you today?")
                    return Test.Status.Success;
            }
            return Test.Status.Failure;
        }
        
        Test.Status speedTest(ref ткст[] messages)
        {
            Стдвыв("Reading...").нс;
            ткст данные = cast(ткст)Файл.получи ("blah.b64");
            ббайт[] результат = new ббайт[данные.length];
            auto t1 = new Секундомер();
            Стдвыв("Decoding..").нс;
            t1.старт();
            бцел runs = 100000000;
            for (бцел i = 0; i < runs; i++)
                раскодируй(данные, результат);
            дво blah = t1.stop();
            Стдвыв.форматнс("Decoded {} MB in {} сек at {} MB/s", cast(дво)(cast(дво)(данные.length * runs) / 1024 / 1024), blah, (cast(дво)(данные.length * runs)) / 1024 / 1024 / blah );
            return Test.Status.Success;
        }

        Test.Status speedTest2(ref ткст[] messages)
        {
            Стдвыв("Reading...").нс;
//            ббайт[] данные = cast(ббайт[])FileData("blah.txt").читай;
            ббайт[] данные = cast(ббайт[])"I am a small ткст, Wee...";
            ткст результат = new сим[вычислиРазмерКодир(данные)];
            auto t1 = new Секундомер();
            бцел runs = 100000000;
            Стдвыв("Кодировка..").нс;
            t1.старт();
            for (бцел i = 0; i < runs; i++)
                кодируй(данные, результат);
            дво blah = t1.stop();
            Стдвыв.форматнс("Encoded {} MB in {} сек at {} MB/s", cast(дво)(cast(дво)(данные.length * runs) / 1024 / 1024), blah, (cast(дво)(данные.length * runs)) / 1024 / 1024 / blah );
            return Test.Status.Success;
        }

        auto t = new Test("crypto.Base64");
        t["Encode"] = &encodeTest;
        t["Encode Поток"] = &encodeЧанкtest;
        t["Decode"] = &decodeTest;
//        t["Speed"] = &speedTest;
//        t["Speed2"] = &speedTest2;
        t.run();
    }
}



private:

/*
    Static неменяемый tables использован for быстро lookups в_ 
    кодируй и раскодируй данные.
*/
static const ббайт BASE64_PAD = 64;
static const ткст _encodeTable = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

static const ббайт[] _decodeTable = [
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,62,0,0,0,63,52,53,54,55,56,57,58,
    59,60,61,0,0,0,BASE64_PAD,0,0,0,0,1,2,3,
    4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,
    19,20,21,22,23,24,25,0,0,0,0,0,0,26,27,
    28,29,30,31,32,33,34,35,36,37,38,39,40,
    41,42,43,44,45,46,47,48,49,50,51,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0
];

