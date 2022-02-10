module osutil;

// ------- CTFE -------

/// преобразование целого в текст при компиляции
char [] ctfe_i2a(int i){
    char[] digit="0123456789";
    char[] res="";
    if (i==0){
        return "0";
    }
    bool neg=false;
    if (i<0){
        neg=true;
        i=-i;
    }
    while (i>0) {
        res=digit[i%10]~res;
        i/=10;
    }
    if (neg)
        return '-'~res;
    else
        return res;
}
/// описано ранее
char [] ctfe_i2a(long i){
    char[] digit="0123456789";
    char[] res="";
    if (i==0){
        return "0";
    }
    bool neg=false;
    if (i<0){
        neg=true;
        i=-i;
    }
    while (i>0) {
        res=digit[cast(size_t)(i%10)]~res;
        i/=10;
    }
    if (neg)
        return '-'~res;
    else
        return res;
}
/// описано ранее
char [] ctfe_i2a(uint i){
    char[] digit="0123456789";
    char[] res="";
    if (i==0){
        return "0";
    }
    bool neg=false;
    while (i>0) {
        res=digit[i%10]~res;
        i/=10;
    }
    return res;
}
/// описано ранее
char [] ctfe_i2a(ulong i){
    char[] digit="0123456789";
    char[] res="";
    if (i==0){
        return "0";
    }
    bool neg=false;
    while (i>0) {
        res=digit[cast(size_t)(i%10)]~res;
        i/=10;
    }
    return res;
}
///////////////////////////////////////////////////////
version (Win32)
{
    private import sys.WinFuncs, thread;

    alias цел т_нук;

    т_нук эта_нить()
    {
        return cast(т_нук) cast(ук) Нить.дайЭту();//ДескрТекущейНити();//stdrus.Нить.дайУкНаТекНить();
    }

 }

 private import cidrus;

static if(is(typeof(VirtualAlloc)))
    version = GC_Use_Alloc_Win32;
else static if (is(typeof(mmap)))
    version = GC_Use_Alloc_MMap;
else static if (is(typeof(valloc)))
    version = GC_Use_Alloc_Valloc;
else static if (is(typeof(cidrus.malloc)))
    version = GC_Use_Alloc_Malloc;
else static assert(false, "Нет доступных методов аллокации.");


static if (is(typeof(VirtualAlloc))) // version (GC_Use_Alloc_Win32)
{
    /**
     * Картировать память.
     */
    ук ос_памВкарту(т_мера члобайт)
    {
        return VirtualAlloc(null, члобайт, ППамять.Резервировать, ППамять.СтрЗапЧтен);
    }


    /**
     * Подать память.
     * Возвращает:
     *      0       успех
     *      !=0     провал
     */
    цел ос_памКоммит(ук ова, т_мера смещ, т_мера члобайт)
    {   ук p;

        p = VirtualAlloc(ова + смещ, члобайт, ППамять.Отправить, ППамять.СтрЗапЧтен);
    return cast(цел)(p is null);
    }


    /**
     * Вынуть память.
     * Возвращает:
     *      0       успех
     *      !=0     провал
     */
    цел ос_памДекоммит(ук ова, т_мера смещ, т_мера члобайт)
    {
    return cast(цел)(VirtualFree(ова + смещ, члобайт, ППамять.Взять) == 0);
    }


    /**
     * Вынуть из карты память, размещённую ос_памВкарту().
     * Память должна уже быть вынута.
     * Возвращает:
     *      0       успех
     *      !=0     провал
     */
    цел ос_памИЗкарты(ук ова, т_мера члобайт)
    {
	
        return cast(цел)(VirtualFree(ова, 0, ППамять.Освободить) == 0);
    }
}
else static if (is(typeof(mmap)))  // else version (GC_Use_Alloc_MMap)
{
    ук ос_памВкарту(т_мера члобайт)
    {   ук p;

        p = mmap(null, члобайт, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
        return (p == MAP_FAILED) ? null : p;
    }


    цел ос_памКоммит(ук ова, т_мера смещ, т_мера члобайт)
    {
        return 0;
    }


    цел ос_памДекоммит(ук ова, т_мера смещ, т_мера члобайт)
    {
        return 0;
    }


    цел ос_памИЗкарты(ук ова, т_мера члобайт)
    {
        return munmap(ова, члобайт);
    }
}
else static if (is(typeof(valloc))) // else version (GC_Use_Alloc_Valloc)
{
    ук ос_памВкарту(т_мера члобайт)
    {
        return valloc(члобайт);
    }


    цел ос_памКоммит(ук ова, т_мера смещ, т_мера члобайт)
    {
        return 0;
    }


    цел ос_памДекоммит(ук ова, т_мера смещ, т_мера члобайт)
    {
        return 0;
    }


    цел ос_памИЗкарты(ук ова, т_мера члобайт)
    {
        cidrus.free(ова);
        return 0;
    }
}
else static if (is(typeof(malloc))) // else version (GC_Use_Alloc_Malloc)
{
    // NOTE: This assumes cidrus.malloc granularity is at least (ук).sizeof.  If
    //       (req_size + РАЗМЕР_СТРАНИЦЫ) is allocated, and the pointer is rounded up
    //       to РАЗМЕР_СТРАНИЦЫ alignment, there will be space for a ук at the end
    //       после РАЗМЕР_СТРАНИЦЫ bytes used by the GC.


    
    ук ос_памВкарту(т_мера члобайт)
    {   byte *p, q;
        p = cast(byte *) cidrus.malloc(члобайт + РАЗМЕР_СТРАНИЦЫ);
        q = p + ((РАЗМЕР_СТРАНИЦЫ - ((cast(т_мера) p & МАСКА_СТРАНИЦЫ))) & МАСКА_СТРАНИЦЫ);
        * cast(ук*)(q + члобайт) = p;
        return q;
    }


    цел ос_памКоммит(ук ова, т_мера смещ, т_мера члобайт)
    {
        return 0;
    }


    цел ос_памДекоммит(ук ова, т_мера смещ, т_мера члобайт)
    {
        return 0;
    }


    цел ос_памИЗкарты(ук ова, т_мера члобайт)
    {
        cidrus.free( *cast(ук*)( cast(byte*) ова + члобайт ) );
        return 0;
    }
}
else
{
    static assert(false, "Нет доступных методов аллокации.");
}



проц ос_запроссегментастатдан(ук *ова, бцел *члобайт)
{	
     ипЦ _xi_a, _end;
	 
    *ова = cast(ук )&_xi_a;
    *члобайт = cast(бцел)(cast(char *)&_end - cast(char *)&_xi_a);
}

export:

extern  (C) ук rt_stackBottom()
{
           asm
        {
            naked;
            mov EAX,FS:4;
            ret;
        }
 }
 
extern  (C) ук rt_stackTop()
{
    
        asm
        {
            naked;
            mov EAX, ESP;
            ret;
        }
 }
 

extern  (C) проц rt_scanStaticData( сканФн scan )
{    
	ипЦ _xi_a, _end;

       scan( &_xi_a, &_end ); 
}

/**
Функция, дающая указатель на низ стэка.
*/	
extern (C)	ук ртНизСтэка()
		{
			   asm
			{
				naked;
				mov EAX,FS:4;
				ret;
			}
		}

/**
Функция, выводящая указатель на верх стэка.
*/		
export extern (C)	ук ртВерхСтэка()
		{
		
			asm
			{
				naked;
				mov EAX, ESP;
				ret;
			}
		}



/**
Функция, по-видимому, находит по указателю
на функцию есть ли такой указатель и в записи
статических данных программы.
*/	
extern (C)	проц ртСканируйСтатДан( сканФн scan )
{    
	ипЦ _xi_a, _end;

       scan( &_xi_a, &_end ); 
}
