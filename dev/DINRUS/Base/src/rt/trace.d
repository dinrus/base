
/* Динамический профилировщик трассировки.
 * Для использования с компилятором Digital Mars DMD.
 * Copyright (C) 1995-2006 by Digital Mars
 * All Rights Reserved
 * Written by Walter Bright
 * www.digitalmars.com
 */

/*
 *  Modified by Sean Kelly <sean@f4.ca> для использования с Tango.
 */

module rt.trace;

private
{
    import std.string;
    import cidrus;
}

extern(C) ткст0 unmangle_ident(ткст0);    // из библиотеки рантайма DMC++

alias дол т_таймер;

/////////////////////////////////////
//

struct СимПара
{
    СимПара* следщ;
    Символ* симв;        // вызываемая функция
    бцел счёт;         // число вызовов символа
}

/////////////////////////////////////
// Символ имени каждой функции.

struct Символ
{
        Символ* Сл, Сп;         // левый, правый отпрыск
        СимПара* Sfanin;        // список вызываемых функций
        СимПара* Sfanout;       // список вызванных функций
        т_таймер общвремя;      // общее время
        т_таймер функцвремя;       // время за исключением вызовов подфункций
        ббайт Сфлаги;
        ткст Сидент;          // имя символа
}

const ббайт СФпосещённые = 1;      // посещённые

static Символ* корень;            // корень таблицы символов

//////////////////////////////////
// Строит линкованный список.

struct Стэк
{
    Стэк* предш;
    Символ* симв;
    т_таймер стартвремя;          // время вхождения в функцию
    т_таймер изб;                // избыток всего учитываемого кода
    т_таймер подвремя;            // время, использованное всеми подфункциями
}

static Стэк* стэк_фрисписок;
static Стэк* след_верхстэка;                // верх стэка
static цел след_инициирован;                // !=0 если инициализовано
static т_таймер след_изб;

static Символ** укНаСимволы;
static бцел члосимв;           // число символов

static ткст след_имялогфайла = "trace.log";
static ФАЙЛ* фукНаЛог;

static ткст след_имядеффайла = "trace.def";
static ФАЙЛ* фукНаДеф;

///////////////////////////////////////
export extern(C):

////////////////////////////////////////
// Установить имя файла для вывода.
// Имя файла "" означает запись результатов в стдвыв.
// Возвращает:
//      0       успех
//      !=0     провал

цел trace_setlogfilename(ткст имя)
{
    след_имялогфайла = имя;
    return 0;
}

////////////////////////////////////////
// Установить имя файла для вывода.
// Имя файла "" означает запись результатов в стдвыв.
// Возвращает:
//      0       успех
//      !=0     провал

цел trace_setdeffilename(ткст имя)
{
    след_имядеффайла = имя;
    return 0;
}

////////////////////////////////////////
// Вывести оптималный порядок компоновки функций.

static проц trace_order(Символ *s)
{
    while (s)
    {
        trace_place(s,0);
        if (s.Сл)
            trace_order(s.Сл);
        s = s.Сп;
    }
}

//////////////////////////////////////////////
//

static Стэк* stack_malloc()
{   Стэк *s;

    if (стэк_фрисписок)
    {   s = стэк_фрисписок;
        стэк_фрисписок = s.предш;
    }
    else
        s = cast(Стэк *)trace_malloc(Стэк.sizeof);
    return s;
}

//////////////////////////////////////////////
//

static проц stack_free(Стэк *s)
{
    s.предш = стэк_фрисписок;
    стэк_фрисписок = s;
}

//////////////////////////////////////
// Процедура сравнения Qsort() для массива указателей на СимПары.

static цел sympair_cmp(in ук e1, in ук e2)
{   СимПара** psp1;
    СимПара** psp2;

    psp1 = cast(СимПара**)e1;
    psp2 = cast(СимПара**)e2;

    return (*psp2).счёт - (*psp1).счёт;
}

//////////////////////////////////////
// Поместить символ s, затем поместить любые fan ins или fan outs со
// счетами, более чем счёт.

static проц trace_place(Символ *s, бцел счёт)
{   СимПара* сп;
    СимПара** ова;

    if (!(s.Сфлаги & СФпосещённые))
    {   т_мера чло;
        бцел u;

        //printf("\t%.*s\t%u\n", s.Сидент, счёт);
        fprintf(фукНаДеф,"\t%.*s\n", s.Сидент);
        s.Сфлаги |= СФпосещённые;

        // Вычислить число элементов в массиве
        чло = 0;
        for (сп = s.Sfanin; сп; сп = сп.следщ)
            чло++;
        for (сп = s.Sfanout; сп; сп = сп.следщ)
            чло++;
        if (!чло)
            return;

        // Разместить и заполнить массив
        ова = cast(СимПара**)trace_malloc(СимПара.sizeof * чло);
        u = 0;
        for (сп = s.Sfanin; сп; сп = сп.следщ)
            ова[u++] = сп;
        for (сп = s.Sfanout; сп; сп = сп.следщ)
            ова[u++] = сп;

        // Сортировать массив
        qsort(ова, чло, (СимПара *).sizeof, &sympair_cmp);

        //for (u = 0; u < чло; u++)
            //printf("\t\t%.*s\t%u\n", ова[u].симв.Сидент, ова[u].счёт);

        // Поместить символы
        for (u = 0; u < чло; u++)
        {
            if (ова[u].счёт >= счёт)
            {   бцел u2;
                бцел c2;

                u2 = (u + 1 < чло) ? u + 1 : u;
                c2 = ова[u2].счёт;
                if (c2 < счёт)
                    c2 = счёт;
                trace_place(ова[u].симв,c2);
            }
            else
                break;
        }

        // Очистить
        trace_free(ова);
    }
}

/////////////////////////////////////
// Инициализация и терминация.

static this()
{
   // trace_init();
}

static ~this()
{
  //  trace_term();
}

///////////////////////////////////
// Выводит отчёт о результатах.
// Также вычисляет члосимв.

static проц trace_report(Символ* s)
{   СимПара* сп;
    бцел счёт;

    //printf("trace_report()\n");
    while (s)
    {   члосимв++;
        if (s.Сл)
            trace_report(s.Сл);
        fprintf(фукНаЛог,"------------------\n");
        счёт = 0;
        for (сп = s.Sfanin; сп; сп = сп.следщ)
        {
            fprintf(фукНаЛог,"\t%5d\t%.*s\n", сп.счёт, сп.симв.Сидент);
            счёт += сп.счёт;
        }
        fprintf(фукНаЛог,"%.*s\t%u\t%lld\t%lld\n",s.Сидент,счёт,s.общвремя,s.функцвремя);
        for (сп = s.Sfanout; сп; сп = сп.следщ)
        {
            fprintf(фукНаЛог,"\t%5d\t%.*s\n",сп.счёт,сп.симв.Сидент);
        }
        s = s.Сп;
    }
}

////////////////////////////////////
// Разместить и заполнить массив символов.

static проц trace_array(Символ *s)
{   static бцел u;

    if (!укНаСимволы)
    {   u = 0;
        укНаСимволы = cast(Символ **)trace_malloc((Символ *).sizeof * члосимв);
    }
    while (s)
    {
        укНаСимволы[u++] = s;
        trace_array(s.Сл);
        s = s.Сп;
    }
}


//////////////////////////////////////
// Процедура сравнения Qsort() для массива указателей на Символы.

static цел symbol_cmp(in ук e1, in ук e2)
{   Символ** ps1;
    Символ** ps2;
    т_таймер рознь;

    ps1 = cast(Символ **)e1;
    ps2 = cast(Символ **)e2;

    рознь = (*ps2).функцвремя - (*ps1).функцвремя;
    return (рознь == 0) ? 0 : ((рознь > 0) ? 1 : -1);
}


///////////////////////////////////
// Отчёт о таймингах функций

static проц trace_times(Символ* корень)
{   бцел u;
    т_таймер freq;

    // Sort array
    qsort(укНаСимволы, члосимв, (Символ *).sizeof, &symbol_cmp);

    // Print array
    QueryPerformanceFrequency(&freq);
    fprintf(фукНаЛог,"\n======== Частота таймера %lld тиков/сек, время в микросекундах ========\n\n",freq);
    fprintf(фукНаЛог,"  Num          Tree        Func        Per\n");
    fprintf(фукНаЛог,"  Calls        Time        Time        Call\n\n");
    for (u = 0; u < члосимв; u++)
    {   Символ* s = укНаСимволы[u];
        т_таймер tl,tr;
        т_таймер fl,fr;
        т_таймер pl,pr;
        т_таймер percall;
        СимПара* сп;
        бцел вызовы;
        ткст id;

        version (Win32)
        {
            ткст0 p = (s.Сидент ~ '\0').ptr;
            p = unmangle_ident(p);
            if (p)
                id = p[0 .. strlen(p)];
        }
        if (!id)
            id = s.Сидент;
        вызовы = 0;
        for (сп = s.Sfanin; сп; сп = сп.следщ)
            вызовы += сп.счёт;
        if (вызовы == 0)
            вызовы = 1;

version (all)
{
        tl = (s.общвремя * 1000000) / freq;
        fl = (s.функцвремя  * 1000000) / freq;
        percall = s.функцвремя / вызовы;
        pl = (s.функцвремя * 1000000) / вызовы / freq;

        fprintf(фукНаЛог,"%7d%12lld%12lld%12lld     %.*s\n",
            вызовы,tl,fl,pl,id);
}
else
{
        tl = s.общвремя / freq;
        tr = ((s.общвремя - tl * freq) * 10000000) / freq;

        fl = s.функцвремя  / freq;
        fr = ((s.функцвремя  - fl * freq) * 10000000) / freq;

        percall = s.функцвремя / вызовы;
        pl = percall  / freq;
        pr = ((percall  - pl * freq) * 10000000) / freq;

        fprintf(фукНаЛог,"%7d\t%3lld.%07lld\t%3lld.%07lld\t%3lld.%07lld\t%.*s\n",
            вызовы,tl,tr,fl,fr,pl,pr,id);
}
        if (id !is s.Сидент)
            cidrus.free(id.ptr);
    }
}


///////////////////////////////////
// Инициализует.

static проц trace_init()
{
    if (!след_инициирован)
    {
        след_инициирован = 1;

        {   // Проверить, можем ли определить избыток.
            бцел u;
            т_таймер стартвремя;
            т_таймер конвремя;
            Стэк *st;

            st = след_верхстэка;
            след_верхстэка = null;
            QueryPerformanceCounter(&стартвремя);
            for (u = 0; u < 100; u++)
            {
                asm
                {
                    call _trace_pro_n   ;
                    db   0              ;
                    call _trace_epi_n   ;
                }
            }
            QueryPerformanceCounter(&конвремя);
            след_изб = (конвремя - стартвремя) / u;
            //printf("след_изб = %lld\n",след_изб);
            if (след_изб > 0)
                след_изб--;            // round down
            след_верхстэка = st;
        }
    }
}

/////////////////////////////////
// Терминирует.

проц trace_term()
{
    //printf("trace_term()\n");
    if (след_инициирован == 1)
    {   Стэк *n;

        след_инициирован = 2;

        // Free остаток of the stack
        while (след_верхстэка)
        {
            n = след_верхстэка.предш;
            stack_free(след_верхстэка);
            след_верхстэка = n;
        }

        while (стэк_фрисписок)
        {
            n = стэк_фрисписок.предш;
            stack_free(стэк_фрисписок);
            стэк_фрисписок = n;
        }

        // Merge in data from any existing file
        trace_merge();

        // Report results
        фукНаЛог = fopen(след_имялогфайла.ptr, "w");
        //фукНаЛог = rt.core.stdc.stdio.stdout;
        if (фукНаЛог)
        {   члосимв = 0;
            trace_report(корень);
            trace_array(корень);
            trace_times(корень);
            fclose(фукНаЛог);
        }

        // Output function link order
        фукНаДеф = fopen(след_имядеффайла.ptr,"w");
        if (фукНаДеф)
        {   fprintf(фукНаДеф,"\nФУНКЦИИ\n");
            trace_order(корень);
            fclose(фукНаДеф);
        }

        trace_free(укНаСимволы);
        укНаСимволы = null;
    }
}

/////////////////////////////////
// Our storage allocator.

static проц *trace_malloc(т_мера nbytes)
{   проц *p;

    p = malloc(nbytes);
    if (!p)
        exit(1);
    return p;
}

static проц trace_free(проц *p)
{
    cidrus.free(p);
}

//////////////////////////////////////////////
//

static Символ* trace_addsym(ткст id)
{
    Символ** parent;
    Символ* rover;
    Символ* s;
    цел cmp;
    char c;

    //printf("trace_addsym('%s',%d)\n",p,len);
    parent = &корень;
    rover = *parent;
    while (rover !is null)               // while we haven't run out of tree
    {
        cmp = std.string.cmp (id, rover.Сидент);
        if (cmp == 0)
        {
            return rover;
        }
        parent = (cmp < 0) ?            /* if we go down left side      */
            &(rover.Сл) :               /* then get left child          */
            &(rover.Сп);                /* else get right child         */
        rover = *parent;                /* get child                    */
    }
    /* not in table, so insert into table       */
    s = cast(Символ *)trace_malloc(Символ.sizeof);
    memset(s,0,Символ.sizeof);
    s.Сидент = id;
    *parent = s;                        // link new symbol into tree
    return s;
}

/***********************************
 * Add symbol s with счёт to СимПара list.
 */

static проц trace_sympair_add(СимПара** psp, Символ* s, бцел счёт)
{   СимПара* сп;

    for (; 1; psp = &сп.следщ)
    {
        сп = *psp;
        if (!сп)
        {
            сп = cast(СимПара *)trace_malloc(СимПара.sizeof);
            сп.симв = s;
            сп.счёт = 0;
            сп.следщ = null;
            *psp = сп;
            break;
        }
        else if (сп.симв == s)
        {
            break;
        }
    }
    сп.счёт += счёт;
}

//////////////////////////////////////////////
//

static проц trace_pro(ткст id)
{
    Стэк* n;
    Символ* s;
    т_таймер стартвремя;
    т_таймер t;

    QueryPerformanceCounter(&стартвремя);
    if (id.length == 0)
        return;
    if (!след_инициирован)
        trace_init();                   // initialize package
    n = stack_malloc();
    n.предш = след_верхстэка;
    след_верхстэка = n;
    s = trace_addsym(id);
    след_верхстэка.симв = s;
    if (след_верхстэка.предш)
    {
        Символ* предш;
        цел i;

        // Accumulate Sfanout and Sfanin
        предш = след_верхстэка.предш.симв;
        trace_sympair_add(&предш.Sfanout,s,1);
        trace_sympair_add(&s.Sfanin,предш,1);
    }
    QueryPerformanceCounter(&t);
    след_верхстэка.стартвремя = стартвремя;
    след_верхстэка.изб = след_изб + t - стартвремя;
    след_верхстэка.подвремя = 0;
    //printf("след_верхстэка.изб=%lld, след_изб=%lld + t=%lld - стартвремя=%lld\n",
    //  след_верхстэка.изб,след_изб,t,стартвремя);
}

/////////////////////////////////////////
//

static проц trace_epi()
{   Стэк* n;
    т_таймер конвремя;
    т_таймер t;
    т_таймер изб;

    //printf("trace_epi()\n");
    if (след_верхстэка)
    {
        т_таймер стартвремя;
        т_таймер общвремя;

        QueryPerformanceCounter(&конвремя);
        стартвремя = след_верхстэка.стартвремя;
        общвремя = конвремя - стартвремя - след_верхстэка.изб;
        if (общвремя < 0)
        {   //printf("конвремя=%lld - стартвремя=%lld - след_верхстэка.изб=%lld < 0\n",
            //  конвремя,стартвремя,след_верхстэка.изб);
            общвремя = 0;              // round off error, just make it 0
        }

        // общвремя is time spent in this function + all time spent in
        // subfunctions - bookkeeping overhead.
        след_верхстэка.симв.общвремя += общвремя;

        //if (общвремя < след_верхстэка.подвремя)
        //printf("общвремя=%lld < след_верхстэка.подвремя=%lld\n",общвремя,след_верхстэка.подвремя);
        след_верхстэка.симв.функцвремя  += общвремя - след_верхстэка.подвремя;
        изб = след_верхстэка.изб;
        n = след_верхстэка.предш;
        stack_free(след_верхстэка);
        след_верхстэка = n;
        if (n)
        {   QueryPerformanceCounter(&t);
            n.изб += изб + t - конвремя;
            n.подвремя += общвремя;
            //printf("n.изб = %lld\n",n.изб);
        }
    }
}


////////////////////////// ФАЙЛ INTERFACE /////////////////////////

/////////////////////////////////////
// Read line from file fp.
// Возвращает:
//      trace_malloc'd line buffer
//      null if end of file

static ткст0 trace_readline(ФАЙЛ* fp)
{   цел c;
    цел dim;
    цел i;
    char *buf;

    //printf("trace_readline(%p)\n", fp);
    i = 0;
    dim = 0;
    buf = null;
    while (1)
    {
        if (i == dim)
        {   char *p;

            dim += 80;
            p = cast(char *)trace_malloc(dim);
            cidrus.memcpy(p,buf,i);
            trace_free(buf);
            buf = p;
        }
        c = fgetc(fp);
        switch (c)
        {
            case КФ:
                if (i == 0)
                {   trace_free(buf);
                    return null;
                }
            case '\n':
                goto L1;
            default:
                break;
        }
        buf[i] = cast(char)c;
        i++;
    }
L1:
    buf[i] = 0;
    //printf("line '%s'\n",buf);
    return buf;
}

//////////////////////////////////////
// Skip space

static char *skipspace(char *p)
{
    while (isspace(*p))
        p++;
    return p;
}

////////////////////////////////////////////////////////
// Merge in profiling data from existing file.

static проц trace_merge()
{   ФАЙЛ* fp;
    char *buf;
    char *p;
    бцел счёт;
    Символ *s;
    СимПара *sfanin;
    СимПара **psp;

    if (след_имялогфайла && (fp = fopen(след_имялогфайла.ptr,"r")) !is null)
    {
        buf = null;
        sfanin = null;
        psp = &sfanin;
        while (1)
        {
            trace_free(buf);
            buf = trace_readline(fp);
            if (!buf)
                break;
            switch (*buf)
            {
                case '=':               // ignore rest of file
                    trace_free(buf);
                    goto L1;
                case ' ':
                case '\t':              // fan in or fan out line
                    счёт = strtoul(buf,&p,10);
                    if (p == buf)       // if invalid conversion
                        continue;
                    p = skipspace(p);
                    if (!*p)
                        continue;
                    s = trace_addsym(p[0 .. strlen(p)]);
                    trace_sympair_add(psp,s,счёт);
                    break;
                default:
                    if (!isalpha(*buf))
                    {
                        if (!sfanin)
                            psp = &sfanin;
                        continue;       // regard unrecognized line as separator
                    }
                case '?':
                case '_':
                case '$':
                case '@':
                    p = buf;
                    while (isgraph(*p))
                        p++;
                    *p = 0;
                    //printf("trace_addsym('%s')\n",buf);
                    s = trace_addsym(buf[0 .. strlen(buf)]);
                    if (s.Sfanin)
                    {   СимПара *сп;

                        for (; sfanin; sfanin = сп)
                        {
                            trace_sympair_add(&s.Sfanin,sfanin.симв,sfanin.счёт);
                            сп = sfanin.следщ;
                            trace_free(sfanin);
                        }
                    }
                    else
                    {   s.Sfanin = sfanin;
                    }
                    sfanin = null;
                    psp = &s.Sfanout;

                    {   т_таймер t;

                        p++;
                        счёт = strtoul(p,&p,10);
                        t = cast(дол)strtoull(p,&p,10);
                        s.общвремя += t;
                        t = cast(дол)strtoull(p,&p,10);
                        s.функцвремя += t;
                    }
                    break;
            }
        }
    L1:
        fclose(fp);
    }
}

////////////////////////// COMPILER INTERFACE /////////////////////

/////////////////////////////////////////////
// Function called by trace code in function prolog.

проц _trace_pro_n()
{
    /* Length of string is either:
     *  db      length
     *  ascii   string
     * or:
     *  db      0x0FF
     *  db      0
     *  dw      length
     *  ascii   string
     */

    version (OSX) { // 16 byte align stack
        asm {
            naked               ;
            pushad              ;
            mov ECX,8*4[ESP]        ;
            xor EAX,EAX         ;
            mov AL,[ECX]        ;
            cmp AL,0xFF         ;
            jne L1          ;
            cmp byte ptr 1[ECX],0   ;
            jne L1          ;
            mov AX,2[ECX]       ;
            add 8*4[ESP],3      ;
            add ECX,3           ;
               L1:  inc EAX         ;
            inc ECX         ;
            add 8*4[ESP],EAX        ;
            dec EAX         ;
            sub ESP,4           ;
            push    ECX         ;
            push    EAX         ;
            call    trace_pro       ;
            add ESP,12          ;
            popad               ;
            ret             ;
        }
    } else {
        asm {
            naked                           ;
            pushad                          ;
            mov     ECX,8*4[ESP]            ;
            xor     EAX,EAX                 ;
            mov     AL,[ECX]                ;
            cmp     AL,0xFF                 ;
            jne     L1                      ;
            cmp     byte ptr 1[ECX],0       ;
            jne     L1                      ;
            mov     AX,2[ECX]               ;
            add     8*4[ESP],3              ;
            add     ECX,3                   ;
        L1: inc     EAX                     ;
            inc     ECX                     ;
            add     8*4[ESP],EAX            ;
            dec     EAX                     ;
            push    ECX                     ;
            push    EAX                     ;
            call    trace_pro               ;
            add     ESP,8                   ;
            popad                           ;
            ret                             ;
        }
    }
}

/////////////////////////////////////////////
// Function called by trace code in function epilog.


проц _trace_epi_n()
{
    version (OSX) { // 16 byte align stack
        asm{
            naked   ;
            pushad  ;
            sub ESP,12  ;
        }
        trace_epi();
        asm {
            add ESP,12  ;
            popad   ;
            ret ;
        }
    }
    else {
        asm {
            naked   ;
            pushad  ;
        }
        trace_epi();
        asm
        {
            popad   ;
            ret     ;
        }
    }
}


version (Win32)
{
    extern (Windows)
    {
        export цел QueryPerformanceCounter(т_таймер *);
        export цел QueryPerformanceFrequency(т_таймер *);
    }
}
else version (X86)
{
    extern (D)
    {
        проц QueryPerformanceCounter(т_таймер* ctr)
        {
            asm
            {   naked                   ;
                mov       ECX,EAX       ;
                rdtsc                   ;
                mov   [ECX],EAX         ;
                mov   4[ECX],EDX        ;
                ret                     ;
            }
        }

        проц QueryPerformanceFrequency(т_таймер* freq)
        {
            *freq = 3579545;
        }
    }
}
else
{
    static assert(0);
}
