﻿/**
 *   D symbol имя demangling
 *
 *   Attempts в_ demangle D symbols generated by the DMD frontend.
 *   (Which is not always technically possible)
 *
 *  A sample program demangling the names passed as аргументы
 * {{{
 *   module demangle;
 *   import util.Demangler;
 *   import io.Stdout;
 *
 *   проц usage(){
 *       Стдвыв("demangle [--help] [--уровень 0-9] mangledName1 [mangledName2...]").нс;
 *   }
 *
 *   цел main(ткст[]арги){
 *       бцел старт=1;
 *       if (арги.length>1) {
 *           if (арги[старт]=="--help"){
 *               usage();
 *               ++старт;
 *           }
 *           if (арги[старт]=="--уровень"){
 *               ++старт;
 *               if (арги.length==старт || арги[старт].length!=1 || арги[старт][0]<'0' ||
 *                   арги[старт][0]>'9') {
 *                   Стдвыв("не_годится уровень '")((арги.length==старт)?"*missing*":арги[старт])
 *                       ("' (must be 0-9)").нс;
 *                   usage();
 *                   return 2;
 *               }
 *               demangler.verbosity=арги[старт+1][0]-'0';
 *               ++старт;
 *           }
 *       } else {
 *           usage();
 *           return 0;
 *       }
 *       foreach (n;арги[старт..$]){
 *           Стдвыв(demangler.demangle(n)).нс;
 *       }
 *       return 0;
 *   }
 * }}}
 *  Copyright: Copyright (C) 2007-2008 Zygfryd (aka Hxal), Fawzi. все rights reserved.
 *  License:   DinrusTango.lib license, apache 2.0
 *  Authors:   Zygfryd (aka Hxal), Fawzi
 *
 */

module util.Demangler;

import tpl.traits: ctfe_i2a;
import cidrus: memmove,memcpy;

debug(traceDemangler) import io.Stdout;



version(DigitalMars) version(Windows)
{
    бул isMD5Hashed(ткст имя)
    {
        if (имя.length < 34 || (имя.length >= 2 && имя[0..2] != "_D"))
        {
            return нет;
        }

        foreach (c; имя[$-32..$])
        {
            if ((c < '0' || c > '9') && (c < 'A' || c > 'F'))
            {
                return нет;
            }
        }

        return да;
    }


    ткст decompressOMFSymbol(ткст garbled, ткст* буф)
    {
        цел ungarbledLength = 0;
        бул compressed = нет;

        for (цел ci = 0; ci < garbled.length; ++ci)
        {
            сим c = garbled[ci];
            if (0 == (c & 0x80))
            {
                ++ungarbledLength;
            }
            else
            {
                compressed = да;
                цел matchLen = void;

                if (c & 0x40)
                {
                    matchLen = (c & 0b111) + 1;
                }
                else
                {
                    if (ci+2 >= garbled.length)
                    {
                        return garbled;
                    }
                    else
                    {
                        matchLen = cast(цел)(c & 0x38) << 4;
                        matchLen += garbled[ci+1] & ~0x80;
                        ci += 2;
                    }
                }

                ungarbledLength += matchLen;
            }
        }

        if (!compressed || ungarbledLength > (*буф).length)
        {
            return garbled;
        }
        else
        {
            ткст ungarbled = (*буф)[$-ungarbledLength..$];
            *буф = (*буф)[0..$-ungarbledLength];
            цел ui = 0;

            for (цел ci = 0; ci < garbled.length; ++ci)
            {
                сим c = garbled[ci];
                if (0 == (c & 0x80))
                {
                    ungarbled[ui++] = c;
                }
                else
                {
                    цел matchOff = void;
                    цел matchLen = void;

                    if (c & 0x40)
                    {
                        matchOff = ((c >> 3) & 0b111) + 1;
                        matchLen = (c & 0b111) + 1;
                    }
                    else
                    {
                        matchOff = cast(цел)(c & 0b111) << 7;
                        matchLen = cast(цел)(c & 0x38) << 4;
                        matchLen += garbled[ci+1] & ~0x80;
                        matchOff += garbled[ci+2] & ~0x80;
                        ci += 2;
                    }

                    цел matchStart = ui - matchOff;
                    if (matchStart + matchLen > ui)
                    {
                        // краш
                        return garbled;
                    }

                    ткст match = ungarbled[matchStart .. matchStart + matchLen];
                    ungarbled[ui .. ui+matchLen] = match;
                    ui += matchLen;
                }
            }

            return ungarbled;
        }
    }
}


/// decompresses a symbol and returns the full symbol, and possibly a reduced буфер пространство
/// (does something only on windows with DMD)
ткст decompressSymbol(ткст func,ткст*буф)
{
    version(DigitalMars) version(Windows)
    {
        if (isMD5Hashed(func))
        {
            func = func[0..$-32];
        }
        func = decompressOMFSymbol(func, буф);
    }
    return func;
}

бцел toUint(ткст s)
{
    бцел рез=0;
    for (цел i=0; i<s.length; ++i)
    {
        if (s[i]>='0'&& s[i]<='9')
        {
            рез*=10;
            рез+=s[i]-'0';
        }
        else
        {
            assert(нет);
        }
    }
    return рез;
}

/**
 *   Flexible demangler
 *   Attempts в_ demangle D symbols generated by the DMD frontend.
 *   (Which is not always technically possible)
 */
public class Demangler
{
    /** How deeply в_ рекурсия printing template параметры,
      * for depths greater than this, an ellИПsis is used */
    бцел templateExpansionDepth = 1;

    /** SkИП default члены of templates (sole члены named после
      * the template) */
    бул foldDefaults = нет;

    /** Print типы of functions being часть of the main symbol */
    бул expandFunctionTypes = нет;

    /** For composite типы, выведи the kind (class|struct|etc.) of the тип */
    бул printTypeKind = нет;

    /** sets the verbosity уровень of the demangler (template expansion уровень,...) */
    public проц verbosity (бцел уровень)
    {
        switch (уровень)
        {
        case 0:
            templateExpansionDepth = 0;
            expandFunctionTypes = нет;
            printTypeKind = нет;
            break;

        case 1:
            templateExpansionDepth = 1;
            expandFunctionTypes = нет;
            printTypeKind = нет;
            break;

        case 2:
            templateExpansionDepth = 1;
            expandFunctionTypes = нет;
            printTypeKind = да;
            break;

        case 3:
            templateExpansionDepth = 1;
            expandFunctionTypes = да;
            printTypeKind = да;
            break;

        default:
            templateExpansionDepth = уровень - 2;
            expandFunctionTypes = да;
            printTypeKind = да;
        }
    }

    /** creates a demangler */
    this ()
    {
        verbosity (1);
    }

    /** creates a demangler with the given verbosity уровень */
    this (бцел уровеньПодробности)
    {
        verbosity (уровеньПодробности);
    }

    /** demangles the given ткст */
    public ткст demangle (ткст ввод)
    {
        сим[4096] буф= void;
        auto рез=DemangleInstance(this,ввод,буф);
        if (рез.mangledName() && рез.ввод.length==0)
        {
            return рез.срез.dup;
        }
        else
        {
            if (рез.срез.length) рез.вывод.добавь(" ");
            if (рез.тип() && рез.ввод.length==0)
            {
                return рез.срез.dup;
            }
            else
            {
                return ввод;
            }
        }
    }

    /** demangles the given ткст using вывод в_ hold the результат */
    public ткст demangle (ткст ввод, ткст вывод)
    {
        auto рез=DemangleInstance(this,ввод,вывод);
        if (рез.mangledName () && рез.ввод.length==0)
        {
            return рез.срез;
        }
        else
        {
            if (рез.срез.length) рез.вывод.добавь(" ");
            if (рез.тип() && рез.ввод.length==0)
            {
                return рез.срез;
            }
            else
            {
                return ввод;
            }
        }
    }

    /// this represents a single demangling request, and is the place where the реал work is готово
    /// some ещё cleanup would probably be in order (maybe удали Буфер)
    struct DemangleInstance
    {
        debug(traceDemangler) private ткст[] _trace;
        private ткст ввод;
        private бцел _templateDepth;
        Буфер вывод;
        Demangler prefs;

        struct BufState
        {
            DemangleInstance* dem;
            ткст ввод;
            т_мера длин;
            static BufState opCall(DemangleInstance* dem)
            {
                BufState рез;
                рез.dem=dem;
                рез.длин=dem.вывод.length;
                рез.ввод=dem.ввод;
                return рез;
            }
            // resets ввод and вывод buffers and returns нет
            бул сбрось()
            {
                dem.вывод.length=длин;
                dem.ввод=ввод;
                return нет;
            }
            // resets only the вывод буфер and returns нет
            бул resetOutput()
            {
                dem.вывод.length=длин;
                return нет;
            }
            ткст sliceFrom()
            {
                return dem.вывод.данные[длин..dem.вывод.length];
            }
        }

        BufState checkpoint()
        {
            return BufState(this);
        }

        static DemangleInstance opCall(Demangler prefs,ткст ввод,ткст вывод)
        {
            ввод = decompressSymbol(ввод, &вывод);

            DemangleInstance рез;
            рез.prefs=prefs;
            рез.ввод=ввод;
            рез._templateDepth=0;
            рез.вывод.данные=вывод;
            debug(traceDemangler) рез._trace=пусто;
            return рез;
        }

        debug (traceDemangler)
        {
            private проц след (ткст where)
            {
                if (_trace.length > 500)
                    throw new Исключение ("Infinite recursion");

                цел длин=_trace.length;
                ткст пробелы = "            ";
                пробелы=пробелы[0 .. ((длин<пробелы.length)?длин:пробелы.length)];
                if (ввод.length < 50)
                    Стдвыв.форматнс ("{}{} : {{{}}", пробелы, where, ввод);
                else
                    Стдвыв.форматнс ("{}{} : {{{}}", пробелы, where, ввод[0..50]);
                _trace ~= where;
            }

            private проц report (T...) (ткст фмт, T арги)
            {
                цел длин=_trace.length;
                ткст пробелы = "            ";
                пробелы=пробелы[0 .. ((длин<пробелы.length)?длин:пробелы.length)];
                Стдвыв (пробелы);
                Стдвыв.форматнс (фмт, арги);
            }

            private проц след (бул результат)
            {
                //auto врем = _trace[$-1];
                _trace = _trace[0..$-1];
                цел длин=_trace.length;
                ткст пробелы = "            ";
                пробелы=пробелы[0 .. ((длин<пробелы.length)?длин:пробелы.length)];
                Стдвыв(пробелы);
                if (!результат)
                    Стдвыв.форматнс ("краш");
                else
                    Стдвыв.форматнс ("success");
            }
        }

        ткст срез()
        {
            return вывод.срез;
        }

        private ткст используй (бцел amt)
        {
            ткст врем = ввод[0 .. amt];
            ввод = ввод[amt .. $];
            return врем;
        }

        бул mangledName ()
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("mangledName");

            if (ввод.length<2)
                return нет;
            if (ввод[0]=='D')
            {
                используй(1);
            }
            else if (ввод[0..2] == "_D")
            {
                используй(2);
            }
            else {
                return нет;
            }

            if (! typedqualifiedName ())
                return нет;

            if (ввод.length > 0)
            {
                auto pos1=checkpoint();
                вывод.добавь("<");
                if (! тип ())
                    pos1.сбрось(); // return нет??
                else if (prefs.printTypeKind)
                {
                    вывод.добавь(">");
                }
                else
                {
                    pos1.resetOutput();
                }
            }

            //Стдвыв.форматнс ("mangledName={}", namebuf.срез);

            return да;
        }

        бул typedqualifiedName ()
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("typedqualifiedName");

            auto posCar=checkpoint();
            if (! symbolName ())
                return нет;
            ткст car=posCar.sliceFrom();

            // undocumented
            auto поз=checkpoint();
            вывод.добавь ("{");
            if (typeFunction ())
            {
                if (!prefs. expandFunctionTypes)
                {
                    поз.resetOutput();
                }
                else
                {
                    вывод.добавь ("}");
                }
            }
            else {
                поз.сбрось();
            }

            поз=checkpoint();
            вывод.добавь (".");
            if (typedqualifiedName ())
            {
                if (prefs.foldDefaults && car.length<поз.sliceFrom().length &&
                car==поз.sliceFrom()[1..car.length+1])
                {
                    memmove(&вывод.данные[posCar.длин],&вывод.данные[поз.длин+1],вывод.length-поз.длин);
                    вывод.length+=posCar.длин-поз.длин-1;
                }
            }
            else {
                поз.сбрось();
            }

            return да;
        }

        бул qualifiedName (бул aliasHack = нет)
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след (aliasHack ? "qualifiedNameAH" : "qualifiedName");

            auto поз=checkpoint();
            if (! symbolName (aliasHack))
                return нет;
            ткст car=поз.sliceFrom();

            auto pos1=checkpoint();
            вывод.добавь (".");
            if (typedqualifiedName ())
            {
                ткст cdr=pos1.sliceFrom()[1..$];
                if (prefs.foldDefaults && cdr.length>=car.length && cdr[0..car.length]==car)
                {
                    memmove(&вывод.данные[поз.длин],&вывод.данные[pos1.длин+1],вывод.length-pos1.длин);
                    вывод.length+=поз.длин-pos1.длин-1;
                }
            }
            else {
                pos1.сбрось();
            }

            return да;
        }

        бул symbolName ( бул aliasHack = нет)
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след (aliasHack ? "symbolNameAH" : "symbolName");

            //      if (templateInstanceName (вывод))
            //          return да;

            if (aliasHack)
            {
                if (lNameAliasHack ())
                    return да;
            }
            else
            {
                if (lName ())
                    return да;
            }

            return нет;
        }

        бул lName ()
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("lName");
            auto поз=checkpoint;
            бцел симвы;
            if (! число (симвы))
                return нет;

            ткст original = ввод;
            version(все)
            {
                if (ввод.length < симвы)
                {
                    // this may happen when the symbol gets hashed by MD5
                    ввод = пусто;
                    return да;        // try в_ continue
                }
            }

            ввод = ввод[0 .. симвы];
            бцел длин = ввод.length;
            if (templateInstanceName())
            {
                ввод = original[длин - ввод.length .. $];
                return да;
            }
            ввод = original;

            if(!имя (симвы))
            {
                return поз.сбрось();
            }
            return да;
        }

        /* this хак is ugly and guaranteed в_ break, but the symbols
           generated for template alias параметры are broken:
           the compiler generates a symbol of the form S(число){(число)(имя)}
           with no пространство between the numbers; what we do is try в_ match
           different combinations of division between the concatenated numbers */

        бул lNameAliasHack ()
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("lNameAH");

            //      бцел симвы;
            //      if (! число (симвы))
            //          return нет;

            бцел симвы;
            auto поз=checkpoint();
            if (! numberNoParse ())
                return нет;
            сим[10] numberBuf;
            ткст ткт = поз.sliceFrom();
            if (ткт.length>numberBuf.length)
            {
                return поз.сбрось();
            }
            numberBuf[0..ткт.length]=ткт;
            ткт=numberBuf[0..ткт.length];
            поз.resetOutput();

            цел i = 0;

            бул готово = нет;

            ткст original = ввод;
            ткст working = ввод;

            while (готово == нет)
            {
                if (i > 0)
                {
                    ввод = working = original[0 .. toUint(ткт[0..i])];
                }
                else
                    ввод = working = original;

                симвы = toUint(ткт[i..$]);

                if (симвы < ввод.length && симвы > 0)
                {
                    // cut the ткст из_ the право sопрe в_ the число
                    // ткст original = ввод;
                    // ввод = ввод[0 .. симвы];
                    // бцел длин = ввод.length;
                    debug(traceDemangler) report ("trying {}/{}", симвы, ввод.length);
                    готово = templateInstanceName ();
                    //ввод = original[длин - ввод.length .. $];

                    if (!готово)
                    {
                        ввод = working;
                        debug(traceDemangler) report ("trying {}/{}", симвы, ввод.length);
                        готово = имя (симвы);
                    }

                    if (готово)
                    {
                        ввод = original[working.length - ввод.length .. $];
                        return да;
                    }
                    else
                        ввод = original;
                }

                i += 1;
                if (i == ткт.length)
                    return нет;
            }

            return да;
        }

        бул число (ref бцел значение)
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("число");

            if (ввод.length == 0)
                return нет;

            значение = 0;
            if (ввод[0] >= '0' && ввод[0] <= '9')
            {
                while (ввод.length > 0 && ввод[0] >= '0' && ввод[0] <= '9')
                {
                    значение = значение * 10 + cast(бцел) (ввод[0] - '0');
                    используй (1);
                }
                return да;
            }
            else
                return нет;
        }

        бул numberNoParse ()
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("numberNP");

            if (ввод.length == 0)
                return нет;

            if (ввод[0] >= '0' && ввод[0] <= '9')
            {
                while (ввод.length > 0 && ввод[0] >= '0' && ввод[0] <= '9')
                {
                    вывод.добавь (ввод[0]);
                    используй (1);
                }
                return да;
            }
            else
                return нет;
        }

        бул имя (бцел счёт)
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("имя");

            //if (ввод.length >= 3 && ввод[0 .. 3] == "__T")
            //  return нет; // workaround

            if (счёт > ввод.length)
                return нет;

            ткст имя = используй (счёт);
            вывод.добавь (имя);
            debug(traceDemangler) report (">>> имя={}", имя);

            return счёт > 0;
        }

        бул тип ()
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("тип");
            if (! ввод.length) return нет;
            auto поз=checkpoint();
            switch (ввод[0])
            {
            case 'x':
                используй (1);
                вывод.добавь ("const ");
                if (!тип ()) return поз.сбрось();
                return да;

            case 'y':
                используй (1);
                вывод.добавь ("invariant ");
                if (!тип ()) return поз.сбрось();
                return да;

            case 'A':
                используй (1);
                if (тип ())
                {
                    вывод.добавь ("[]");
                    return да;
                }
                return поз.сбрось();

            case 'G':
                используй (1);
                бцел размер;
                if (! число (размер))
                    return нет;
                if (тип ())
                {
                    вывод.добавь ("[" ~ ctfe_i2a(размер) ~ "]");
                    return да;
                }
                return поз.сбрось();

            case 'H':
                используй (1);
                auto pos2=checkpoint();
                if (! тип ())
                    return нет;
                ткст keytype=pos2.sliceFrom();
                вывод.добавь ("[");
                auto pos3=checkpoint();
                if (тип ())
                {
                    ткст subtype=pos3.sliceFrom();
                    вывод.добавь ("]");
                    if (subtype.length<=keytype.length)
                    {
                        auto pos4=checkpoint();
                        вывод.добавь (keytype);
                        memmove(&вывод.данные[pos2.длин],&вывод.данные[pos3.длин],subtype.length);
                        вывод.данные[pos2.длин+keytype.length]='[';
                        memcpy(&вывод.данные[pos2.длин],&вывод.данные[pos4.длин],keytype.length);
                        pos4.сбрось();
                    }
                    return да;
                }
                return поз.сбрось();

            case 'P':
                используй (1);
                if (тип ())
                {
                    вывод.добавь ("*");
                    return да;
                }
                return нет;
            case 'F':
            case 'U':
            case 'W':
            case 'З':
            case 'R':
            case 'D':
            case 'M':
                return typeFunction ();
            case 'I':
            case 'C':
            case 'S':
            case 'E':
            case 'T':
                return typeNamed ();
            case 'n':
                используй (1);
                вывод.добавь ("Неук");
                return да;
            case 'v':
                используй (1);
                вывод.добавь ("проц");
                return да;
            case 'g':
                используй (1);
                вывод.добавь ("байт");
                return да;
            case 'h':
                используй (1);
                вывод.добавь ("ббайт");
                return да;
            case 's':
                используй (1);
                вывод.добавь ("крат");
                return да;
            case 't':
                используй (1);
                вывод.добавь ("бкрат");
                return да;
            case 'i':
                используй (1);
                вывод.добавь ("цел");
                return да;
            case 'k':
                используй (1);
                вывод.добавь ("бцел");
                return да;
            case 'l':
                используй (1);
                вывод.добавь ("дол");
                return да;
            case 'm':
                используй (1);
                вывод.добавь ("бдол");
                return да;
            case 'f':
                используй (1);
                вывод.добавь ("плав");
                return да;
            case 'd':
                используй (1);
                вывод.добавь ("дво");
                return да;
            case 'e':
                используй (1);
                вывод.добавь ("реал");
                return да;
            case 'q':
                используй(1);
                вывод.добавь ("кплав");
                return да;
            case 'r':
                используй(1);
                вывод.добавь ("кдво");
                return да;
            case 'c':
                используй(1);
                вывод.добавь ("креал");
                return да;
            case 'o':
                используй(1);
                вывод.добавь ("вплав");
                return да;
            case 'p':
                используй(1);
                вывод.добавь ("вдво");
                return да;
            case 'j':
                используй(1);
                вывод.добавь ("вреал");
                return да;
            case 'b':
                используй (1);
                вывод.добавь ("бул");
                return да;
            case 'a':
                используй (1);
                вывод.добавь ("сим");
                return да;
            case 'u':
                используй (1);
                вывод.добавь ("шим");
                return да;
            case 'w':
                используй (1);
                вывод.добавь ("дим");
                return да;
            case 'B':
                используй (1);
                бцел счёт;
                if (! число (счёт))
                    return поз.сбрось();
                вывод.добавь ('(');
                if (! аргументы ())
                    return поз.сбрось();
                вывод.добавь (')');
                return да;

            default:
                return поз.сбрось();
            }

            //return да;
        }

        бул typeFunction ()
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("typeFunction");

            auto поз=checkpoint();
            бул isMethod = нет;
            бул isDelegate = нет;

            if (ввод.length == 0)
                return нет;

            if (ввод[0] == 'M')
            {
                используй (1);
                isMethod = да;
            }
            if (ввод[0] == 'D')
            {
                используй (1);
                isDelegate = да;
                assert (! isMethod);
            }

            switch (ввод[0])
            {
            case 'F':
                используй (1);
                break;

            case 'U':
                используй (1);
                вывод.добавь ("extern(C) ");
                break;

            case 'W':
                используй (1);
                вывод.добавь ("extern(Windows) ");
                break;

            case 'З':
                используй (1);
                вывод.добавь ("extern(Pascal) ");
                break;

            case 'R':
                используй (1);
                вывод.добавь ("extern(C++) ");
                break;

            default:
                return поз.сбрось();
            }

            auto pos2=checkpoint();
            if (isMethod)
                вывод.добавь (" метод (");
            else if (isDelegate)
                вывод.добавь (" delegate (");
            else
                вывод.добавь (" function (");

            аргументы ();
            version (все)
            {
                if (0 == ввод.length)
                {
                    // probably MD5 symbol hashing. try в_ continue
                    return да;
                }
            }
            switch (ввод[0])
            {
            case 'X':
            case 'Y':
            case 'Z':
                используй (1);
                break;
            default:
                return поз.сбрось();
            }
            вывод.добавь (")");

            auto pos3=checkpoint();
            if (! тип ())
                return поз.сбрось();
            ткст retT=pos3.sliceFrom();
            auto pos4=checkpoint();
            вывод.добавь(retT);
            memmove(&вывод.данные[pos2.длин+retT.length],&вывод.данные[pos2.длин],pos3.длин-pos2.длин+1);
            memcpy(&вывод.данные[pos2.длин],&вывод.данные[pos4.длин],retT.length);
            pos4.сбрось();
            return да;
        }

        бул аргументы ()
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("аргументы");

            if (! аргумент ())
                return нет;

            auto поз=checkpoint();
            вывод.добавь (", ");
            if (!аргументы ())
            {
                поз.сбрось;
            }

            return да;
        }

        бул аргумент ()
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("аргумент");

            if (ввод.length == 0)
                return нет;
            auto поз=checkpoint();
            switch (ввод[0])
            {
            case 'К':
                используй (1);
                вывод.добавь ("ref ");
                break;

            case 'J':
                используй (1);
                вывод.добавь ("out ");
                break;

            case 'L':
                используй (1);
                вывод.добавь ("lazy ");
                break;

            default:
            }

            if (! тип ())
                return поз.сбрось();

            return да;
        }

        бул typeNamed ()
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("typeNamed");
            auto поз=checkpoint();
            ткст kind;
            switch (ввод[0])
            {
            case 'I':
                используй (1);
                kind = "interface";
                break;

            case 'S':
                используй (1);
                kind = "struct";
                break;

            case 'C':
                используй (1);
                kind = "class";
                break;

            case 'E':
                используй (1);
                kind = "enum";
                break;

            case 'T':
                используй (1);
                kind = "typedef";
                break;

            default:
                return нет;
            }

            //вывод.добавь (kind);
            //вывод.добавь ("=");

            if (! qualifiedName ())
                return поз.сбрось();

            if (prefs. printTypeKind)
            {
                вывод.добавь ("<");
                вывод.добавь (kind);
                вывод.добавь (">");
            }

            return да;
        }

        бул templateInstanceName ()
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("templateInstanceName");
            auto поз=checkpoint();
            if (ввод.length < 4 || ввод[0..3] != "__T")
                return нет;

            используй (3);

            if (! lName ())
                return checkpoint.сбрось();

            вывод.добавь ("!(");

            _templateDepth++;
            if (_templateDepth <= prefs.templateExpansionDepth)
            {
                templateArgs ();
            }
            else {
                auto pos2=checkpoint();
                templateArgs ();
                pos2.resetOutput();
                вывод.добавь ("...");
            }
            _templateDepth--;

            if (ввод.length > 0 && ввод[0] != 'Z')
                return поз.сбрось();

            вывод.добавь (")");

            используй (1);
            return да;
        }

        бул templateArgs ()
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("templateArgs");

            if (! templateArg ())
                return нет;
            auto pos1=checkpoint();
            вывод.добавь (", ");
            if (! templateArgs ())
            {
                pos1.сбрось();
            }

            return да;
        }

        бул templateArg ()
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("templateArg");

            if (ввод.length == 0)
                return нет;
            auto поз=checkpoint();
            switch (ввод[0])
            {
            case 'T':
                используй (1);
                if (! тип ())
                    return поз.сбрось();
                return да;

            case 'З':
                используй (1);
                auto pos2=checkpoint();
                if (! тип ())
                    return поз.сбрось();
                pos2.resetOutput();
                if (! значение ())
                    return поз.сбрось();
                return да;

            case 'S':
                используй (1);
                if (! qualifiedName (да))
                    return поз.сбрось();
                return да;

            default:
                return поз.сбрось();
            }

            //return поз.сбрось;
        }

        бул значение ()
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("значение");

            if (ввод.length == 0)
                return нет;

            auto поз=checkpoint();

            switch (ввод[0])
            {
            case 'n':
                используй (1);
                return да;

            case 'N':
                используй (1);
                вывод.добавь ('-');
                if (! numberNoParse ())
                    return поз.сбрось();
                return да;

            case 'e':
                используй (1);
                if (! hexFloat ())
                    return поз.сбрось();
                return да;

            case 'c': //TODO

            case 'A':
                используй (1);
                бцел счёт;
                if (! число (счёт))
                    return поз.сбрось();
                if (счёт>0)
                {
                    вывод.добавь ("[");
                    for (бцел i = 0; i < счёт-1; i++)
                    {
                        if (! значение ())
                            return поз.сбрось();
                        вывод.добавь (", ");
                    }
                    if (! значение ())
                        return поз.сбрось();
                }
                вывод.добавь ("]");
                return да;

            default:
                if (! numberNoParse ())
                    return поз.сбрось();
                return да;
            }

            //return поз.сбрось();
        }

        бул hexFloat ()
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("hexFloat");

            auto поз=checkpoint();
            if (ввод[0 .. 3] == "NAN")
            {
                используй (3);
                вывод.добавь ("nan");
                return да;
            }
            else if (ввод[0 .. 3] == "INF")
            {
                используй (3);
                вывод.добавь ("+inf");
                return да;
            }
            else if (ввод[0 .. 3] == "NINF")
            {
                используй (3);
                вывод.добавь ("-inf");
                return да;
            }

            бул негатив = нет;
            if (ввод[0] == 'N')
            {
                используй (1);
                негатив = да;
            }

            бдол num;
            if (! hexNumber (num))
                return нет;

            if (ввод[0] != 'P')
                return нет;
            используй (1);

            бул negative_exponent = нет;
            if (ввод[0] == 'N')
            {
                используй (1);
                negative_exponent = да;
            }

            бцел exponent;
            if (! число (exponent))
                return поз.сбрось();

            return да;
        }

        static бул isHexDigit (сим c)
        {
            return (c > '0' && c <'9') || (c > 'a' && c < 'f') || (c > 'A' && c < 'F');
        }

        бул hexNumber (ref бдол значение)
        out (результат)
        {
            debug(traceDemangler) след (результат);
        }
        body
        {
            debug(traceDemangler) след ("hexFloat");

            if (isHexDigit (ввод[0]))
            {
                while (isHexDigit (ввод[0]))
                {
                    //вывод.добавь (ввод[0]);
                    используй (1);
                }
                return да;
            }
            else
                return нет;
        }
    }
}


private struct Буфер
{
    ткст данные;
    т_мера     length;

    проц добавь (ткст s)
    {
        assert(this.length+s.length<=данные.length);
        т_мера длин=this.length+s.length;
        if (длин>данные.length) длин=данные.length;
        данные[this.length .. длин] = s[0..длин-this.length];
        this.length = длин;
    }

    проц добавь (сим c)
    {
        assert(this.length<данные.length);
        данные[this.length .. this.length + 1] = c;
        this.length += 1;
    }

    проц добавь (Буфер b)
    {
        добавь (b.срез);
    }

    ткст срез ()
    {
        return данные[0 .. this.length];
    }
}

/// the default demangler
static Demangler demangler;

static this()
{
    demangler=new Demangler(1);
}
