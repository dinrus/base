﻿module sys.WinProcess;
import cidrus, stdrus, tpl.stream;

export class ППоток : Поток 
{

export:
    /** First init step: this, then start the process based on its result */
   проц init1()
    {
        читаем = true;
        записываем = true;
        сканируем = false;
        
            БЕЗАТРЫ ба;
            ба.длина = БЕЗАТРЫ.sizeof;
            ба.наследДескр = 1;
            СоздайПайп(&ipr, &ipw, &ба, 0);
            СоздайПайп(&opr, &opw, &ба, 0);
        
    }
    
    /** Use cidrus.система */
    this(ткст команда)
    {
        init1();
        
            ИНФОСТАРТА инфоСтарта;
            инфоСтарта.размер = ИНФОСТАРТА.sizeof;
            инфоСтарта.стдвво = ipr;
            инфоСтарта.стдвыв = opw;
            инфоСтарта.стдош = opw;
            инфоСтарта.флаги = 256;
            
            ИНФОПРОЦ инфоПроц;
            
            СоздайПроцесс(null, stdrus.вЮ16(команда), null, null,
                           1, cast(ПФлагСоздПроц) 0, null, null, &инфоСтарта, &инфоПроц);
            ЗакройДескр(ipr);
            ЗакройДескр(opw);
            ЗакройДескр(инфоПроц.нить);
            phnd = инфоПроц.процесс;
        
        
        init2();
    }
    

    /** The second init part */
    проц init2()
    {
        открыт = true;
    }
    
    override т_мера читайБлок(ук буфер, т_мера размер)
    {
            бцел rd;
            if (!ЧитайФайл(opr, буфер, размер, &rd, null)) {
                читайдоКФ = true;
                return 0;
            } else {
                читайдоКФ = false;
            }
            return rd;
        
    }
    
    override т_мера пишиБлок(ук буфер, т_мера размер)
    {
            бцел wt;
            if (!ПишиФайл(opr, буфер, размер, &wt, null)) {
                читайдоКФ = true;
                return 0;
            } else {
                читайдоКФ = false;
            }
            return wt;
        
    }
    
    override бдол сместись(дол offset, ППозКурсора whence)
    {
        throw new Исключение("Смещение в ППотоках невозможно");
    }
    
    /** Close the process, return the result */
    проц закрой()
    {
        if (открыт) {
            открыт = false;
			бцел *eval;
			ДайКодВыходаПроцесса(phnd, eval);
              ЗакройДескр(phnd);
             ЗакройДескр(ipw);
               ЗакройДескр(opr);
			 this.eval = cast(бцел) eval;
            
        }
    }
    
        /** Get the exit value */
        бцел значВыхода()
        {
            return eval;
        }
    
    
    private:
    
        /** The process handle */
        ук phnd;
        
        /** The exit value */
        бцел eval;
    
        /** The input pipe */
        ук ipr, ipw;
        
        /** The output pipe */
        ук opr, opw;
    
}

/** Exception to be thrown when a command called dies */
export class ИсклУгасшегоПроцесса : Исключение {
export:
    this(ткст smsg)
    {
        super(smsg);
    }
}

export extern(C):
/** cidrus.система + guarantee success */
проц сисИлиАборт(ткст кмнд)
{
    цел рез;
    слейфл(cidrus.стдвых); слейфл(cidrus.стдош);
    рез = cidrus.система(кмнд);
    if (рез)  // CyberShadow 2007.02.22: Display a message before exiting
    {
        цел p = кмнд.найди(' ');
        if(p!=-1) кмнд=кмнд[0..p];
        скажифнс("Команда " ~ кмнд ~ " завершилась с кодом выхода ", рез, ", программа прерывается.");
        throw new ИсклУгасшегоПроцесса("Команда не удалась, последует выход.");
    }
}

/** cidrus.система + output */
цел скажиИСис(ткст кмнд)
{
    скажифнс("+ %s", кмнд);
    слейфл(cidrus.стдвых); слейфл(cidrus.стдош);
    return cidrus.система(кмнд);
}

/** сисИлиАборт + output */
проц скажиСисАборт(ткст кмнд)
{
    скажифнс("+ %s", кмнд);
    сисИлиАборт(кмнд);
}

/** cidrus.система + use a response file */
цел сисРеспонс(ткст кмнд, ткст рфлаг, ткст рфайл, бул удалитьРФайл)
{
    цел ret;
    ткст[] элемс = разбей(кмнд, " ");
    
    /* the output is элемс past 1 joined with \n */
    ткст resp = объедини(элемс[1..$], "\n");
    пишиФайл(рфайл, resp);
    
    слейфл(cidrus.стдвых); слейфл(cidrus.стдош);
    ret = cidrus.система(элемс[0] ~ " " ~ рфлаг ~ рфайл);
    
    if (удалитьРФайл) удалиФайл(рфайл);
    
    return ret;
}

/** systemResponse + guarantee success */
проц сисРИлиАборт(ткст кмнд, ткст рфлаг, ткст рфайл, бул удалитьРФайл)
{
    цел рез;
    рез = сисРеспонс(кмнд, рфлаг, рфайл, удалитьРФайл);
    if (рез)  // CyberShadow 2007.02.22: Display a message before exiting
    {
        цел p = кмнд.найди(' ');
        if(p!=-1) кмнд=кмнд[0..p];
        скажифнс("Команда " ~ кмнд ~ " завершилась с кодом ", рез, ", прерывание программы.");
        throw new ИсклУгасшегоПроцесса("Неудачная команда, аборт.");
    }
}

/** systemResponse + output */
цел скажиИСисР(ткст кмнд, ткст рфлаг, ткст рфайл, бул удалитьРФайл)
{
    скажифнс("+ %s", кмнд);
    return сисРеспонс(кмнд, рфлаг, рфайл, удалитьРФайл);
}

/** systemROrDie + output */
проц скажиСисРАборт(ткст кмнд, ткст рфлаг, ткст рфайл, бул удалитьРФайл)
{
    скажифнс("+ %s", кмнд);
    сисРИлиАборт(кмнд, рфлаг, рфайл, удалитьРФайл);
}
