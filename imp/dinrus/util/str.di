﻿// Miscellaneous routines and symbols used when working with character strings

module util.str;

private{
    static import util.linetoken;
    static import util.booltype;   // definition of Да and Нет
    alias util.booltype.Да Да;
    alias util.booltype.Нет Нет;
    alias util.booltype.Бул Бул;

    //import stdrus;
}

public{

//----------------------------------------------------------
ббайт[] замениСим(in ббайт[] текст, ббайт откуда, ббайт куда);
//----------------------------------------------------------
ббайт[] замениСим(in ббайт[] текст, char откуда, char куда);
//----------------------------------------------------------
юткст замениСим(in юткст текст, дим откуда, дим куда);
//----------------------------------------------------------
ткст замениСим(in ткст текст, дим откуда, дим куда);
//----------------------------------------------------------
шткст замениСим(in шткст текст, дим откуда, дим куда);
//----------------------------------------------------------
ббайт[] вТкстН(ббайт[] данные);
//----------------------------------------------------------
ткст вТкстН(ткст данные);
//----------------------------------------------------------
ббайт[] вТкстА(ткст данные);
ббайт[] вТкстА(шткст данные);
ббайт[] вТкстА(юткст данные);

Бул подобен_ли(юткст текст, юткст образец);
Бул подобен_ли(ткст текст, ткст образец );

}


//-------------------------------------------------------
Бул начинается_с(ткст ткт, ткст подткт);
//-------------------------------------------------------
Бул начинается_с(шткст ткт, шткст подткт);
//-------------------------------------------------------
Бул начинается_с(юткст ткт, юткст подткт);
//-------------------------------------------------------
Бул оканчивается_на(ткст ткт, ткст подткт);
//-------------------------------------------------------
Бул оканчивается_на(шткст ткт, шткст подткт);
//-------------------------------------------------------
Бул оканчивается_на(юткст ткт, юткст подткт);
//-------------------------------------------------------
ткст в_кавычках(ткст ткт, сим триггер = ' ', ткст префикс = `"`, ткст суффикс = `"`);
//-------------------------------------------------------
шткст в_кавычках(шткст ткт, шим триггер = ' ', шткст префикс = `"`, шткст суффикс = `"`);
//-------------------------------------------------------
юткст в_кавычках(юткст ткт, дим триггер = ' ', юткст префикс = `"`, юткст суффикс = `"`);


ткст раскрой(ткст pOriginal, ткст pTokenList,
                ткст pLeading = "{", ткст pTrailing = "}");

юткст раскрой(юткст pOriginal, юткст pTokenList,
                юткст pLeading = "{", юткст pTrailing = "}");
				
ткст вАСКИ(ткст pUTF8);

бул ЮК_пбел_ли(дим pChar);
ткст найдипбел(ткст текст);

юткст найдипбелрек(юткст текст);
юткст уберил(юткст s);
ткст уберил(ткст s) ;
юткст уберип(юткст s) ;
ткст уберип(ткст s) ;
юткст убери(юткст s);
шткст убери(шткст s) ;
ткст убери(ткст s) ;


template Шнайди(T)
{
    цел найди(T[] текст, T[] pSubText, цел откуда = 0)
    {
        цел lTexti;
        цел lSubi;
        цел lPos;
        цел lTextEnd;

        if (откуда < 0)
            откуда = 0;

        // locate first match.
        lSubi = 0;
        lTexti = откуда;
        // No point in looking past this position.
        lTextEnd = текст.length - pSubText.length + 1;
        while(lSubi < pSubText.length)
        {
            while(lTexti < lTextEnd && pSubText[lSubi] != текст[lTexti])
            {
                lTexti++;
            }
            if (lTexti >= текст.length)
                return -1;

            lPos = lTexti;  // Mark possible start of substring match.

            lTexti++;
            lSubi++;
            // Locate all matches
            while(lTexti < текст.length && lSubi < pSubText.length &&
                        pSubText[lSubi] == текст[lTexti])
            {
                lTexti++;
                lSubi++;
            }
            if (lSubi == pSubText.length)
                return lPos;
            lSubi = 0;
            lTexti = lPos + 1;
        }
        return -1;
    }
}
alias Шнайди!(дим).найди найди;
alias Шнайди!(шим).найди найди;


ткст транслируйЭск(ткст текст);


// Function to replace tokens in the form %<SYM>%  with environment data.
// Note that '%%' is replaced by a single '%'.
// -------------------------------------------
ткст разверниПеремСреды(ткст pLine);//-------------------------------------------------------
ткст дайСред(ткст pSymbol);
//-------------------------------------------------------
проц устСред(ткст pSymbol, ткст pValue, бул pOverwrite = true);


template Шдн(T)
{
//-------------------------------------------------------
бул ДаНет(T[] текст, бул дефолт)
//-------------------------------------------------------
{
    бул рез = дефолт;
    foreach(цел i, дим c; текст)
    {
        if (c == '=' || c == ':')
        {
            текст = уберил(текст[i+1 .. $]);
            break;
        }
    }
    if (текст.length > 0)
    {
        if (текст[0] == 'Y' || текст[0] == 'y')
            рез = true;
        else if (текст[0] == 'N' || текст[0] == 'n')
            рез = false;
    }

    return рез;
}
//-------------------------------------------------------
проц ДаНет(T[] текст, out бул рез, бул дефолт)
//-------------------------------------------------------
{
    рез = ДаНет(текст, дефолт);
}

//-------------------------------------------------------
проц ДаНет(T[] текст, out T[] рез, бул дефолт)
//-------------------------------------------------------
{
    рез = (ДаНет(текст, дефолт) ? cast(T[])"Y" : cast(T[])"N").dup;
}

//-------------------------------------------------------
проц ДаНет(T[] текст, out T рез, бул дефолт)
//-------------------------------------------------------
{
    рез = (ДаНет(текст, дефолт) ? 'Y' : 'N');
}
//-------------------------------------------------------
проц ДаНет(T[] текст, out Бул рез, Бул дефолт)
//-------------------------------------------------------
{
    рез = (ДаНет(текст, (дефолт==Да?true:false)) ? Да : Нет);
}
}
alias Шдн!(дим).ДаНет ДаНет;
alias Шдн!(char).ДаНет ДаНет;
