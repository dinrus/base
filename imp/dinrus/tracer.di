﻿module tracer;
import base, thread, win, stdrus, cidrus;
import cidrus : cMalloc = празмести, cRealloc = перемести, cFree = освободи;
import cidrus : устбуф, фук, откройфл, закройфл, сместисьфл, скажифл, читайфл, ППозКурсора;


    version = ТрайМэтчКоллАдресиз;
    version = ТрайТуБиСмарт;
    //version = UseCustomFiberForDemangling;
    version = ДеманглФункшнНеймз;

	alias бул function( ук процесс, бдол адрОвы, ук буф, т_мера разм, т_мера *члоСчитБайтов) ФункЧтенПамПроцесса64;
	alias ук function( ук процесс, бдол адрОвы ) ФункДоступаКТабСимФций64;
	alias бдол function( ук процесс, бдол адр ) ФункПолучОвыМодуля64;
    alias бдол function( ук процесс, ук нить, АДРЕС64 адр ) ФункТрансляцииАдреса64;

	alias т_мера function(КонтекстСледа* контекст, КонтекстСледа* выхКонтекста, т_мера *буфСледа, т_мера длинаБуф, цел *флаги) ФункАдрБэктрейс;
	alias бул function(ref Исключение.ИнфОКадре кИнфо,КонтекстСледа* контекст, ткст буф) ФункИнфОКадреВСимв;
	
	
enum {
    IMAGE_FILE_DEBUG_DIRECTORY = 6
}
 
enum {
    sstModule           = 0x120,
    sstSrcModule        = 0x127,
    sstGlobalPub        = 0x12a,
}
 
struct OMFSignature {
    сим    Сигнатура[4];
    цел фпоз;
}
 
struct OMFDirHeader {
    бкрат  cbDirHeader;
    бкрат  cbDirEntry;
    бцел    cDir;
    цел     lfoNextDir;
    бцел    флаги;
}
 
struct OMFDirEntry {
    бкрат  ПодСекция;
    бкрат  iMod;
    цел     lfo;
    бцел    cb;
}
  
struct OMFSegDesc {
    бкрат  Seg;
    бкрат  pad;
    бцел    Off;
    бцел    cbSeg;
}
 
struct OMFModule {
    бкрат  ovlNumber;
    бкрат  iLib;
    бкрат  cSeg;
    сим            Style[2];
}
 
struct OMFModuleFull {
    бкрат  ovlNumber;
    бкрат  iLib;
    бкрат  cSeg;
    сим            Style[2];
    OMFSegDesc      *ИнфОСег;
    сим            *Имя;
}
    
struct OMFSymHash {
    бкрат  symhash;
    бкрат  addrhash;
    бцел    cbSymbol;
    бцел    cbHSym;
    бцел    cbHAddr;
}
 
struct DATASYM16 {
        бкрат reclen;  // Record length
        бкрат rectyp;  // S_LDATA or S_GDATA
        цел off;        // смещение of symbol
        бкрат seg;     // segment of symbol
        бкрат typind;  // Type индекс
        байт имя[1];   // Length-prefixed имя
}
typedef DATASYM16 PUBSYM16;
 


enum {
    IMAGE_SIZEOF_SHORT_NAME = 8,
}

struct IMAGE_DEBUG_DIRECTORY {
    бцел   Характеристики;
    бцел   ШтампВремени;
    бкрат MajorVersion;
    бкрат MinorVersion;
    бцел   Type;
    бцел   SizeOfData;
    бцел   AddressOfRawData;
    бцел   УкНаНеобрДанные;
}
 
struct OMFSourceLine {
    бкрат  Seg;
    бкрат  cLnOff;
    бцел    смещение[1];
    бкрат  lineNbr[1];
}
 
struct OMFSourceFile {
    бкрат  cSeg;
    бкрат  reserved;
    бцел    baseSrcLn[1];
    бкрат  cFName;
    сим    Имя;
}
 
struct OMFSourceModule {
    бкрат  cFile;
    бкрат  cSeg;
    бцел    baseSrcFile[1];
}

проц грузи(Биб биб)
{
    вяжи(_D6thread10Фибра8пускMFZv)("_D6thread10Фибра8пускMFZv", биб);
}	
проц грузи2(Биб биб)
{
	вяжи(ДайФимяМодуляДопА)("_ДайФимяМодуляДопА", биб);
	вяжи(ИницСим)("_ИницСим", биб);
	вяжи(ПроходСтека64)("_ПроходСтека64", биб);
	вяжи(ПроцДоступаКТабФций64)("_ПроцДоступаКТабФций64", биб);
	вяжи(ПроцПолучОвыМодуля64)("_ПроцПолучОвыМодуля64", биб);
	вяжи(СимПоАдр)("_СимПоАдр", биб);
	вяжи(СимПоИмени)("_СимПоИмени", биб);
	вяжи(УстОпцСим)("_УстОпцСим", биб);
	вяжи(вБцел)("_вБцел", биб);
	вяжи(деманглируй)("_деманглируй", биб);
	вяжи(деманглируй2)("_деманглируй2", биб);
	вяжи(загрузиСимМодуль64)("_загрузиСимМодуль64", биб);
	вяжи(иницОтладСимв)("_иницОтладСимв", биб);
	вяжи(подробность)("_подробность", биб);
	вяжи(разожмиСимвол)("_разожмиСимвол", биб);
	вяжи(разожмиСимволОМФ)("_разожмиСимволОМФ", биб);
    вяжи(хэшированМД5_ли)("_хэшированМД5_ли", биб);
}
ЖанБибгр Рантайм;
ЖанБибгр Инструменты;
static this() {
    Рантайм.заряжай("Dinrus.Base.dll", &грузи );
	Инструменты.заряжай("Dinrus.Tools.dll", &грузи2);
	Рантайм.загружай();
	Инструменты.загружай();
}

extern (C)
{
pragma(lib, "dinrus.lib");
проц _Dmain(); 
проц function() _D6thread10Фибра8пускMFZv;

//Динамический импорт из Dinrus.Tools.dll
бул function(ткст имя) хэшированМД5_ли;
ткст function(ткст з, ткст* буф) разожмиСимволОМФ;
ткст function(ткст функц, ткст* буф) разожмиСимвол;
бцел function(ткст т) вБцел;
ткст function(ткст т) деманглируй;
ткст function(ткст ввод, ткст вывод) деманглируй2;
проц function(бцел уровень) подробность;
проц function() иницОтладСимв;
бул function(ук процесс, т_мера адр, т_мера *смещ, ИНФ_О_СИМВОЛЕ *симв) СимПоАдр;
бул function(ук процесс, ткст0 имя, ИНФ_О_СИМВОЛЕ *симв) СимПоИмени;
бцел function(ук процесс, ук модуль, сим* фимя, бцел разм) ДайФимяМодуляДопА;
бул function(ПФОбрМашина маш, ук процесс, ук нить, КАДР_СТЕКА64 *кс, ук записьКтекста, ФункЧтенПамПроцесса64 процЧтенПамяти, ФункДоступаКТабСимФций64 процДоступаКТабФций, ФункПолучОвыМодуля64 процПолучОвыМодуля, ФункТрансляцииАдреса64 транслАдрес ) ПроходСтека64;
ук function( ук процесс, бдол адрОвы )ПроцДоступаКТабФций64;
бдол function( ук процесс, бдол адр ) ПроцПолучОвыМодуля64;
бцел function(бцел опц) УстОпцСим;
бул function(ук процесс, сим* путьПоискаПольз, бул ворватьсяВПроцесс) ИницСим;
бдол function(ук процесс, фук файл, сим* имяОбр, сим* имяМод, бдол оваДлл, т_мера размДлл) загрузиСимМодуль64;

/+
//Статический импорт из Dinrus.Tools.dll

бул хэшированМД5_ли(ткст имя);
ткст разожмиСимволОМФ(ткст з, ткст* буф);
ткст разожмиСимвол(ткст функц, ткст* буф);
бцел вБцел(ткст т);
ткст деманглируй(ткст т);
ткст деманглируй2(ткст ввод, ткст вывод);
проц подробность(бцел уровень);
//dbghelp.dll
проц иницОтладСимв();
бул СимПоАдр(ук процесс, т_мера адр, т_мера *смещ, ИНФ_О_СИМВОЛЕ *симв);
бул СимПоИмени(ук процесс, ткст0 имя, ИНФ_О_СИМВОЛЕ *симв);
бцел ДайФимяМодуляДопА(ук процесс, ук модуль, сим* фимя, бцел разм);
бул ПроходСтека64(ПФОбрМашина маш, ук процесс, ук нить, КАДР_СТЕКА64 *кс, ук записьКтекста, ФункЧтенПамПроцесса64 процЧтенПамяти, ФункДоступаКТабСимФций64 процДоступаКТабФций, ФункПолучОвыМодуля64 процПолучОвыМодуля, ФункТрансляцииАдреса64 транслАдрес );
ук ПроцДоступаКТабФций64( ук процесс, бдол адрОвы );
бдол ПроцПолучОвыМодуля64( ук процесс, бдол адр );
бцел УстОпцСим(бцел опц);
бул ИницСим(ук процесс, сим* путьПоискаПольз, бул ворватьсяВПроцесс);
бдол загрузиСимМодуль64(ук процесс, фук файл, сим* имяОбр, сим* имяМод, бдол оваДлл, т_мера размДлл);
+/

//Статический импорт
проц ртУстФциюАдрБэктрейс(ФункАдрБэктрейс f);
проц ртУстФциюИнфОКадреВСимв(ФункИнфОКадреВСимв f);
т_мера ртБэктрейсАдреса(КонтекстСледа* контекст, КонтекстСледа *выхКонтекста,т_мера* буфСледа, т_мера длинаБуф, цел *флаги);
бул ртСимволизируйИнфОКадре(ref Исключение.ИнфОКадре кИнфо,КонтекстСледа* контекст, ткст буф);

т_мера длинткст0 (сим* ткт);
ткст изТкст0 (сим* ткт);

проц _initLGPLHostExecutableDebugInfo(ткст имяПрог);

ОтладИнфОбАдр дайОтладИнфОбАдр(т_мера a, т_дельтаук* дифф = пусто);

ОтладИнфОМодуле ModuleDebugInfo_new();    
проц ModuleDebugInfo_addDebugInfo(ОтладИнфОМодуле minfo, т_мера адр, ткст0 файл, ткст0 функ, бкрат строка);    
ткст0 ModuleDebugInfo_bufString(ОтладИнфОМодуле minfo, ткст ткт) ;    
проц GlobalDebugInfo_addDebugInfo(ОтладИнфОМодуле minfo);
проц GlobalDebugInfo_removeDebugInfo(ОтладИнфОМодуле minfo) ;

}

extern(D)
{ 
бул адрВСимвДетали(т_мера адр, ук процесс, проц delegate(ткст функц, ткст файл, цел строка, т_дельтаук смещАдреса) дг) ;
ткст имяФции_по_Адр(ук адр, ткст буф);
ткст имяФции_по_Адр(ук адр);
}

бул инфОКадреВСимволыВин(ref Исключение.ИнфОКадре кИнфо, КонтекстСледа *контекст, ткст буф){
        ук процесс;
        if (контекст!is пусто){
            процесс=контекст.процесс;
        } else {
            процесс=ДайТекущийПроцесс();
        }
        return адрВСимвДетали(кИнфо.адрес, процесс, (ткст функц, ткст файл, цел строка, т_дельтаук смещАдреса) {
            if (функц.length > буф.length) {
                буф[] = функц[0..буф.length];
                кИнфо.функц = буф;
            } else {
                буф[0..функц.length] = функц;
                кИнфо.функц = буф[0..функц.length];
            }
            кИнфо.файл = файл;
            кИнфо.строка = строка;
            кИнфо.симвСмещ = смещАдреса;
        });
    }
	

цел[сим[]] внутрфции;
static this(){

    ртУстФциюАдрБэктрейс(&бэктрейсАдресаВин);
    ртУстФциюИнфОКадреВСимв(&инфОКадреВСимволыВин);
	
    //внутрфции["D5tango4core10stacktrace10StackTrace20defaultAddrBacktraceFPS5tango4core10stacktrace10StackTrace12КонтекстТрассировкиPS5tango4core10stacktrace10StackTrace12КонтекстТрассировкиPkkPiZk"]=1;
  //  внутрфции["_D5tango4core10stacktrace10StackTrace20defaultAddrBacktraceFPS5tango4core10stacktrace10StackTrace12КонтекстТрассировкиPS5tango4core10stacktrace10StackTrace12КонтекстТрассировкиPmmPiZm"]=1;
    внутрфции["ртБэктрейсАдреса"]=1;
   // внутрфции["D5tango4core10stacktrace10StackTrace14BasicTraceInfo5traceMFPS5tango4core10stacktrace10StackTrace12КонтекстТрассировкиiZv"]=1;
   // внутрфции["D5tango4core10stacktrace10StackTrace11basicTracerFPvZC9Исключение9TraceInfo"]=1;
    внутрфции["ртСоздайКонтекстСледа"]=1;
   // внутрфции["D2rt6dmain24mainUiPPaZi7runMainMFZv"]=1;
   // внутрфции["D2rt6dmain24mainUiPPaZi6runAllMFZv"]=1;
    //внутрфции["D2rt6dmain24mainUiPPaZi7tryExecMFDFZvZv"]=1;
   // внутрфции["_D5tango4core10stacktrace10StackTrace20defaultAddrBacktraceFPS5tango4core10stacktrace10StackTrace12КонтекстТрассировкиPS5tango4core10stacktrace10StackTrace12КонтекстТрассировкиPkkPiZk"]=1;
   // внутрфции["ртБэктрейсАдреса"]=1;
   // внутрфции["_D5tango4core10stacktrace10StackTrace14BasicTraceInfo5traceMFPS5tango4core10stacktrace10StackTrace12КонтекстТрассировкиiZv"]=1;
   // внутрфции["_D5tango4core10stacktrace10StackTrace11basicTracerFPvZC9Исключение9TraceInfo"]=1;
   // внутрфции["ртСоздайКонтекстСледа"]=1;
   // внутрфции["_D2rt6dmain24mainUiPPaZi7runMainMFZv"]=1;
   // внутрфции["_D2rt6dmain24mainUiPPaZi6runAllMFZv"]=1;
   // внутрфции["_D2rt6dmain24mainUiPPaZi7tryExecMFDFZvZv"]=1;
}

extern(D) class БазоваяИнфОСледе: Исключение.ИнфОСледе{

    т_мера[] адрыСледа;
    т_мера[128] буфСледа;
    ППрецАдра прецАдра;
    КонтекстСледа контекст;

    this();
    this(т_мера[] адрыСледа,ППрецАдра прецАдра);
    проц трассируй(КонтекстСледа *вхКонтекст = пусто, цел пропускКадров=0);
 
 цел opApply( цел delegate( ref Исключение.ИнфОКадре кИнфо ) телоЦикла);
	проц writeOut(проц delegate(char[])sink);   
    проц выпиши(проц delegate(сим[]) sink);
}

т_мера бэктрейсАдресаВин(КонтекстСледа *винКткст, КонтекстСледа *выхКонтекста, т_мера *буфСледа, т_мера длинаБуфСледа, цел *флаги)
 {
        КОНТЕКСТ     контекст;
        КОНТЕКСТ    *укзНаКткст = &контекст;
        
        ук процесс = void;
        ук нить = void;
        
        if (винКткст !is пусто) {
            контекст = винКткст.контекст;
            процесс = винКткст.процесс;
            нить = винКткст.нить;
        } else {
            бцел eipReg, espReg, ebpReg;
            asm {
                call GIMMEH_EIP;
                GIMMEH_EIP:
                    pop EAX;
                    mov eipReg, EAX;
                mov espReg, ESP;
                mov ebpReg, EBP;
            }

            процесс = ДайТекущийПроцесс();
            нить = ДайТекущуюНить();
            
            контекст.ФлагиКонтекста = ПКонтекст.i386 | ПКонтекст.Упр;
            ДайКонтекстНити(нить, &контекст);
            контекст.Eip = eipReg;
            контекст.Esp = espReg;
            контекст.Ebp = ebpReg;
        }
        if (выхКонтекста !is пусто){
            выхКонтекста.контекст = контекст;
            выхКонтекста.процесс = процесс;
            выхКонтекста.нить = нить;
        }
        
        debug (НА_ПАНЕЛЬ) эхо("Eip: %x, Esp: %x, Ebp: %x"\n, укзНаКткст.Eip, укзНаКткст.Esp, укзНаКткст.Ebp);

            if (ПлохойЧтенУк_ли(cast(ук)укзНаКткст.Ebp, 4)) {
                укзНаКткст.Ebp = укзНаКткст.Esp;
            }
        
        т_мера длинСледа = 0;
        пройдиСтэк(укзНаКткст, процесс, нить, delegate проц(т_мера[]тр)
		{
            if (тр.length > длинаБуфСледа)
			{
                длинСледа = длинаБуфСледа;
            } else 
			{
                длинСледа = тр.length;
            }

            буфСледа[0..длинСледа] = тр[0..длинСледа];
        });
            *флаги=3;
			
        return длинСледа;
    }


private  {

    т_мера  длинФцииПускаФибры = 0;
}


проц пройдиСтэк(КОНТЕКСТ *ЗаписьКтекста, ук процесс, ук нить, проц delegate(т_мера[]) приёмникСледа) {
    const цел максПрострвоСтэка = 32;
    const цел максПрострвоКучи      = 256;
    static assert (максПрострвоКучи  > максПрострвоСтэка);
    
    т_мера[максПрострвоСтэка]   массивСледаСтэка = void;
    т_мера[]                            массивСледаКучи;
    т_мера[]                            следстека = массивСледаСтэка;
    бцел                                i = void;
    
    проц добавьАдрес(т_мера адр) {
        if (i < максПрострвоСтэка) {
            следстека[i++] = адр;
        } else {
            if (максПрострвоСтэка == i) {
                if (массивСледаКучи is пусто) {
                    массивСледаКучи.размести(максПрострвоКучи, нет);
                    массивСледаКучи[0..максПрострвоСтэка] = массивСледаСтэка;
                    следстека = массивСледаКучи;
                }
                следстека[i++] = адр;
            } else if (i < максПрострвоКучи) {
                следстека[i++] = адр;
            }
        }
    }


    version (StacktraceUseWinApiStackWalking) {
        КАДР_СТЕКА64 кадр;
        устбуф(&кадр, 0, кадр.sizeof);

        кадр.АдрСтэка.Смещение  = ЗаписьКтекста.Esp;
        кадр.АдрСчётчикаПрограммы.Смещение     = ЗаписьКтекста.Eip;
        кадр.АдрКадра.Смещение  = ЗаписьКтекста.Ebp;
        кадр.АдрСтэка.Режим    = кадр.АдрСчётчикаПрограммы.Режим = кадр.АдрКадра.Режим = ПРежимАдресации.Плоский;

        //for (цел sanity = 0; sanity < 256; ++sanity) {
        for (i = 0; i < максПрострвоКучи; ) {
            auto swres = ПроходСтека64(
                ПФОбрМашина.I386,
                процесс,
                нить,
                &кадр,
                ЗаписьКтекста,
                пусто,
               ПроцДоступаКТабФций64,
               ПроцПолучОвыМодуля64,
                пусто
            );
            
            if (!swres) {
                break;
            }
            
            debug (НА_ПАНЕЛЬ) эхо("pc:%x итог:%x frm:%x stk:%x parm:%x %x %x %x"\n,
                    кадр.АдрСчётчикаПрограммы.Смещение, кадр.АдрВозврата.Смещение, кадр.АдрКадра.Смещение, кадр.АдрСтэка.Смещение,
                    кадр.АргиФции[0], кадр.АргиФции[1], кадр.АргиФции[2], кадр.АргиФции[3]);

            добавьАдрес(кадр.АдрСчётчикаПрограммы.Смещение);
        }
    } else {
        struct Расклад {
            Расклад* ebp;
            т_мера  итог;
        }
        Расклад* p = cast(Расклад*)ЗаписьКтекста.Esp;
        
        
        бул мейнНайден = нет;     
        enum Фаза {
            TryEsp,
            TryEbp,
            GiveUp
        }
        
        Фаза фаза = ЗаписьКтекста.Esp == ЗаписьКтекста.Ebp ? Фаза.TryEbp : Фаза.TryEsp;
        следстека[0] = ЗаписьКтекста.Eip;
        
        version (ТрайТуБиСмарт) {
            thread.Нить нобъ = thread.Нить.дайЭту();
        }
        
        while (!мейнНайден && фаза < Фаза.GiveUp) {
            debug (НА_ПАНЕЛЬ) эхо("starting a new tracing phase"\n);
            
            version (ТрайТуБиСмарт) {
                auto текСтэк = нобъ.топКонтекст();
            }
            
            for (i = 1; p && !ПлохойЧтенУк_ли(p, Расклад.sizeof) && i < максПрострвоКучи && !ПлохойЧтенУк_ли(cast(ук)p.итог, 4);) {
                auto симв = p.итог;
                
                enum {
                    кодопБлижВызова = 0xe8,
                    кодопВызоваВРегистр = 0xff
                }

                бцел адрВызова = p.итог;
                if (т_мера.sizeof == 4 && !ПлохойЧтенУк_ли(cast(ук)(p.итог - 5), 8) && кодопБлижВызова == *cast(ubyte*)(p.итог - 5)) {
                    адрВызова += *cast(бцел*)(p.итог - 4);
                    debug (НА_ПАНЕЛЬ) эхо("итог:%x frm:%x call:%x"\n, симв, p, адрВызова);
                    version (ТрайМэтчКоллАдресиз) {
                        добавьАдрес(p.итог - 5);  // a near call is 5 bytes
                    }
                } else {
                    version (ТрайМэтчКоллАдресиз) {
                        if (!ПлохойЧтенУк_ли(cast(ук)p.итог - 2, 4) && кодопВызоваВРегистр == *cast(ubyte*)(p.итог - 2)) {
                            debug (НА_ПАНЕЛЬ) эхо("рез:%x frm:%x register-based call:[%x]"\n, симв, p, *cast(ubyte*)(p.итог - 1));
                            добавьАдрес(p.итог - 2);  // an смещение-less register-based call is 2 bytes for the call + register setup
                        } else if (!ПлохойЧтенУк_ли(cast(ук)p.итог - 3, 4) && кодопВызоваВРегистр == *cast(ubyte*)(p.итог - 3)) {
                            debug (НА_ПАНЕЛЬ) эхо("рез:%x frm:%x register-based call:[%x,%x]"\n, симв, p, *cast(ubyte*)(p.итог - 2), *cast(ubyte*)(p.итог - 1));
                            добавьАдрес(p.итог - 3);  // a register-based call is 3 bytes for the call + register setup
                        } else {
                            debug (НА_ПАНЕЛЬ) эхо("рез:%x frm:%x"\n, симв, p);
                            добавьАдрес(p.итог);
                        }
                    }
                }

                version (ТрайТуБиСмарт) {
                    бул вФибре = нет;
                    if  (
                            адрВызова == cast(бцел)&_Dmain
                            || да == (вФибре = (
                                адрВызова >= cast(бцел)&_D6thread10Фибра8пускMFZv
                                && адрВызова < cast(бцел)&_D6thread10Фибра8пускMFZv + длинФцииПускаФибры
                            ))
                        )
                    {
                        мейнНайден = да;
                        if (вФибре) {
                            debug (НА_ПАНЕЛЬ) эхо("Got or Нить.Fiber.run"\n);

                            version (ТрайМэтчКоллАдресиз) {
                                // handled above
                            } else {
                                добавьАдрес(p.итог);
                            }

                            текСтэк = текСтэк.внутри;
                            if (текСтэк) {
                                ук новп = текСтэк.нстэк;

                                if (!ПлохойЧтенУк_ли(новп + 28, 8)) {
                                    добавьАдрес(*cast(т_мера*)(новп + 32));
                                    p = *cast(Расклад**)(новп + 28);
                                    continue;
                                }
                            }
                        } else {
                            debug (НА_ПАНЕЛЬ) эхо("Got _Dmain"\n);
                        }
                    }
                }
                
                version (ТрайМэтчКоллАдресиз) {
                    // handled above
                } else {
                    добавьАдрес(p.итог);
                }
                
                p = p.ebp;
            }

            ++фаза;
            p = cast(Расклад*)ЗаписьКтекста.Ebp;
            debug (НА_ПАНЕЛЬ) эхо("end of phase"\n);
        }
        
        debug (НА_ПАНЕЛЬ) эхо("calling priyomnikSleda"\n);
    }

    приёмникСледа(следстека[0..i]);
    массивСледаКучи.освободи();
}

проц размести(T, целТ)(ref T массив, целТ члоЭлтов, бул init = да) 
in {
    assert (массив is пусто);
    assert (члоЭлтов >= 0);
}
out {
    assert (члоЭлтов == массив.length);
}
body {
    alias typeof(T[0]) ItemT;
    массив = (cast(ItemT*)cMalloc(ItemT.sizeof * члоЭлтов))[0 .. члоЭлтов];
    
    static if (is(typeof(ItemT.init))) {
        if (init) {
            массив[] = ItemT.init;
        }
    }
}


T клонируй(T)(T массив) {
    T рез;
    рез.размести(массив.length, нет);
    рез[] = массив[];
    return рез;
}

проц перемести(T, целТ)(ref T массив, целТ члоЭлтов, бул init = да)
in {
    assert (члоЭлтов >= 0);
}
out {
    assert (члоЭлтов == массив.length);
}
body {
    alias typeof(T[0]) ItemT;
    целТ старДлин = массив.length;
    массив = (cast(ItemT*)cRealloc(массив.ptr, ItemT.sizeof * члоЭлтов))[0 .. члоЭлтов];
    
    static if (is(typeof(ItemT.init))) {
        if (init && члоЭлтов > старДлин) {
            массив[старДлин .. члоЭлтов] = ItemT.init;
        }
    }
}

проц освободи(T)(ref T массив)
out {
    assert (0 == массив.length);
}
body {
    cFree(массив.ptr);
    массив = пусто;
}

проц приставь(T, I)(ref T массив, I элем, бцел* реалДлина = пусто) {
    бцел длн = реалДлина is пусто ? массив.length : *реалДлина;
    бцел ёмкость = массив.length;
    alias typeof(T[0]) ItemT;
    
    if (длн >= ёмкость) {
        if (реалДлина is пусто) {       // just add one element to the массив
            цел члоЭлтов = длн+1;
            массив = (cast(ItemT*)cRealloc(массив.ptr, ItemT.sizeof * члоЭлтов))[0 .. члоЭлтов];
        } else {                                // be smarter and allocate in power-of-two increments
            const бцел начЁмкость = 4;
            цел члоЭлтов = ёмкость == 0 ? начЁмкость : ёмкость * 2; 
            массив = (cast(ItemT*)cRealloc(массив.ptr, ItemT.sizeof * члоЭлтов))[0 .. члоЭлтов];
            ++*реалДлина;
        }
    } else if (реалДлина !is пусто) ++*реалДлина;
    
    массив[длн] = элем;
}


extern(D) class ОтладИнфОМодуле
 {

    ОтладИнфОбАдр[] отладИнфо;
    бцел                        длинаОтладИнфо;
    т_мера[ткст0]           максАдрФайла;
    ткст0[]                 ткстБуфер;
    бцел                        длинаТкстБуфера;
    
    проц добавьОтладИнфо(т_мера адр, ткст0 файл, ткст0 функц, бкрат строка) ;
    ткст0 буфТкст(ткст ткт);    
    проц освободиМассивы();
    
    ОтладИнфОМодуле предш;
    ОтладИнфОМодуле следщ;
}

extern(D) class ГлобОтладИнфо
 {

    ОтладИнфОМодуле голова;
    ОтладИнфОМодуле хвост;    
    
    synchronized цел opApply(цел delegate(ref ОтладИнфОМодуле) дг);    
    synchronized проц добавьОтладИнфо(ОтладИнфОМодуле инфо) ;    
    synchronized проц удалиОтладИнфо(ОтладИнфОМодуле инфо) ;
}

private ГлобОтладИнфо глобОтладИнфо;
static this() {
    глобОтладИнфо = new ГлобОтладИнфо;
}
   
 extern(D) class ОтладИнфо 
 {
    ОтладИнфОМодуле инфо;
        
    this(ткст фимя);
     
        цел ПарсируйФайлКВ(ткст фимя) ;            
        бул ПарсируйЗаголовкиФайла(фук отладфайл) ;            
        ПТипЗагКодВью ДайТипЗага(фук отладфайл);
        бул ЧитайЗагФайлаДОС(фук отладфайл, ЗАГОБРДОС *загдос);
        бул ЧитайЗагФайлаПЕ(фук отладфайл, НТОБРЗАГИ *загнт) ;          
        бул ПарсируйЗаголовкиСекций(фук отладфайл);
        бул ЧитайЗагиСекции(фук отладфайл, ref ЗАГСЕКЦОБР[] загисекц);          
        бул ПарсируйПапкуОтладки(фук отладфайл);
        бцел ДайСмещПоОВА(бцел rva);
        бул ЧитайПапкуОтладки(фук отладфайл, ref IMAGE_DEBUG_DIRECTORY debugdirs[]);          
        бул ПарсируйЗаголовкиКодВью(фук отладфайл) ;
        бул ЧитайЗагКодВью(фук отладфайл, out OMFSignature sig, out OMFDirHeader dirhdr);         
        бул ЧитайПапкуКодВью(фук отладфайл, ref OMFDirEntry[] записи);          
        бул ПарсируйВсеМодули (фук отладфайл);            
        бул ЧитайДанныеМодуля(фук отладфайл, OMFDirEntry[] записи, out OMFModuleFull[] модули) ;
        бул ПарсируйСоотнесённыеСекции(цел индекс, фук отладфайл) ;            
        бул ПарсируйИнфОМодулеИст (цел индекс, фук отладфайл) ;        
        проц ИзвлекиИнфОМодулеИст (байт* грданные, крат *члофлов, крат *члосег, out бцел[] позинфофл);         
        проц ИзвлекиИнфОФайлеМодуляИст(байт* грданные,out бцел[] смещение);
        проц ИзвлекиИнфОСтрокеМодуляИст(байт* грданные, цел tablecount) ;           
        бул ЧитайЧанк(фук отладфайл, проц *dest, цел length, цел фсмещ) ;

}

static this() {
	иницОтладСимв();
    for (длинФцииПускаФибры = 0; длинФцииПускаФибры < 0x100; ++длинФцииПускаФибры) {
        ubyte* ptr = cast(ubyte*)&_D6thread10Фибра8пускMFZv + длинФцииПускаФибры;
        enum {
            ОпКодВозвр = 0xc3
        }
        if (ПлохойЧтенУк_ли(ptr, 1) || ОпКодВозвр == *ptr) {
            break;
        }
    }
    
    debug (НА_ПАНЕЛЬ) эхо ("found Thread.Fiber.run at %p with length %x",
            &_D6thread10Фибра8пускMFZv, длинФцииПускаФибры);

    сим длинаБуфИм[512] = 0;
    цел длинаИмМод = ДайФимяМодуляДопА(ДайТекущийПроцесс(), пусто, длинаБуфИм.ptr, длинаБуфИм.length-1);
    ткст имяМод = длинаБуфИм[0..длинаИмМод];
    УстОпцСим(cast(бцел) ПОпцСимвола.ИзменённыеЗагрузки/+ | SYMOPT_UNDNAME+/);
    ИницСим(ДайТекущийПроцесс(), пусто, нет);
    DWORD64 base;
    if (0 == (base = загрузиСимМодуль64(ДайТекущийПроцесс(), фук.init, имяМод.ptr, пусто, 0, 0))) {
        if (СисОш.последнКод != 0) {
            throw new Исключение("Не удаётся загрузить SymLoadModule64: " ~ СисОш.последнСооб);
        }
    }
    
    ИНФ_О_СИМВОЛЕ симв;
    симв.РазмерСтруктуры = ИНФ_О_СИМВОЛЕ.sizeof; 

    extern(C) проц function(сим[]) initTrace;
    if (СимПоИмени(ДайТекущийПроцесс(), "__initLGPLHostExecutableDebugInfo", &симв)) {
        initTrace = cast(typeof(initTrace))симв.Адрес;
        assert (initTrace !is пусто); 
        initTrace(имяМод);
    } else {
        throw new Исключение ("Не удаётся инициализировать модуль трассировки Динрус");
    }
	
	auto рекурсивныеТрассировкиСтека = new thread.НитьЛок!(цел)(0);	
}

/// загружает символы для данного кадра
bool дефСимволизаторИнфОКадре(ref Исключение.ИнфОКадре кИнфо,КонтекстСледа *контекст, ткст буф){
        return инфОКадреВСимволыВин(кИнфо, контекст, буф);

}

/// функция, генерирующая трассировку
Исключение.ИнфОСледе базовыйТрассировщик( ук укз = пусто ){
    БазоваяИнфОСледе рез;
    try{
        version(CatchRecursiveTracing){
            рекурсивныеТрассировкиСтека.знач=рекурсивныеТрассировкиСтека.знач+1;
            scope(exit) рекурсивныеТрассировкиСтека.знач=рекурсивныеТрассировкиСтека.знач-1;
            // printf("tracer %d\n",рекурсивныеТрассировкиСтека.val);
            if (рекурсивныеТрассировкиСтека.знач>10) {
                _скажи("достигнут максимальный рекурсивный трейсинг (tracer asserting...?)\n");
                аборт();
                return null;
            }
        }
        рез = new БазоваяИнфОСледе();
        рез.трассируй(cast(КонтекстСледа*)укз);
    } catch (Исключение e){
        _скажи("трассировщик обнаружил исключение:\n");
        _скажи(e.msg);
        e.выпиши((char[]s){ _скажи(s); });
        _скажи("\n");
    } catch (Object o){
        _скажи("трассировщик обнаружил объектное исключение:\n");
        _скажи(o.toString());
        _скажи("\n");
    }
    return рез;
}


static this(){ртСоздайОбработчикСледа(&базовыйТрассировщик);}