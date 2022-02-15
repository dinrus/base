﻿/**
 *   D symbol имя demangling
 *
 *   Attempts в_ demangle D symbols generated by the DMD frontend.
 *   (Which is not всегда technically possible)
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
    бул isMD5Hashed(ткст имя);
    ткст decompressOMFSymbol(ткст garbled, ткст* буф);
}


/// decompresses a symbol and returns the full symbol, and possibly a reduced буфер пространство
/// (does something only on windows with DMD)
ткст decompressSymbol(ткст func,ткст*буф);

бцел toUint(ткст s);

/**
 *   Flexible demangler
 *   Attempts в_ demangle D symbols generated by the DMD frontend.
 *   (Which is not всегда technically possible)
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
    public проц verbosity (бцел уровень);

    /** creates a demangler */
    this ();

    /** creates a demangler with the given verbosity уровень */
    this (бцел уровеньПодробности);

    /** demangles the given ткст */
    public ткст demangle (ткст ввод);

    /** demangles the given ткст using вывод в_ hold the результат */
    public ткст demangle (ткст ввод, ткст вывод);

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
            static BufState opCall(DemangleInstance* dem);
            // resets ввод and вывод buffers and returns нет
            бул сбрось();
            // resets only the буфер вывода and returns нет
            бул resetOutput();
            ткст sliceFrom();
        }

        BufState checkpoint();

        static DemangleInstance opCall(Demangler prefs,ткст ввод,ткст вывод);

       ткст срез();

        private ткст используй (бцел amt);

        бул mangledName ();

        бул typedqualifiedName ();

        бул qualifiedName (бул aliasHack = нет);

        бул symbolName ( бул aliasHack = нет);

        бул lName ();

        /* this хак is ugly and guaranteed в_ break, but the symbols
           generated for template alias параметры are broken:
           the compiler generates a symbol of the form S(число){(число)(имя)}
           with no пространство between the numbers; what we do is try в_ match
           different combinations of division between the concatenated numbers */

        бул lNameAliasHack ();

        бул число (ref бцел значение);

        бул numberNoParse ();

        бул имя (бцел счёт);

        бул тип ();

        бул typeFunction ();

        бул аргументы ();
        }

        бул аргумент ();

        бул typeNamed ();

        бул templateInstanceName ();

        бул templateArgs ();
		
        бул templateArg ();

        бул значение ();

        бул hexFloat ();

        static бул isHexDigit (сим c);

        бул hexNumber (ref бдол значение);
    }
}


private struct Буфер
{
    ткст данные;
    т_мера     length;

    проц добавь (ткст s);

    проц добавь (сим c);

    проц добавь (Буфер b);

    ткст срез ();
}

/// the default demangler
static Demangler demangler;

static this()
{
    demangler=new Demangler(1);
}
