module sync;

alias Мютекс Стопор;

extern (D) class Условие
{

    this( Мютекс m );
    ~this();
    проц жди();
    бул жди( дол период );  
    проц уведоми();
    проц уведомиВсе(); 
}


extern (D) class Барьер
{
    this( бцел предел );
	проц жди();
}

 extern (D) class Семафор
{
    this( бцел счёт = 0 );
    ~this();
    проц жди();
    бул жди( дол период );
    проц уведоми();
    бул пробуйЖдать();

}

 extern (D) class Мютекс : Объект.Монитор
{

    this();
    this( Object o );
    ~this();
    проц блокируй();
    проц разблокируй();
    void lock();
	 void unlock();  
    бул пытайсяБлокировать();
}

 extern(D) class ЧЗМютекс
{
    enum Политика
    {
        ПОЧЁТ_ЧИТАТЕЛЮ, /// Читатели получают предпочтение. от этого могут пострадать писатели.
        ПОЧЁТ_ПИСАТЕЛЮ  /// Писатели получают предпочтение. от этого могут пострадать читатели.
    }


    this( Политика политика = Политика.ПОЧЁТ_ПИСАТЕЛЮ );

    Политика политика();
    Читатель читатель();
    Писатель писатель();
	
	class Читатель : Объект.Монитор
		{
			this();
			проц блокируй();
			проц разблокируй();
		 void lock();
		 void unlock();
			бул пытайсяБлокировать();
		}

	class Писатель :  Объект.Монитор
		{
			 this();
			проц блокируй();
			проц разблокируй();
		void lock();
		 void unlock();
			бул пытайсяБлокировать();
		
		}
}

extern (D) class ИсключениеСинх : Исключение
{
    this( string msg );
}

//////////////////////////////////////////////////////////////////
//////ШАБЛОНЫ АТОМНЫХ ОПЕРАЦИЙ

//////////////////////////////////////////////////////////////////
private
 {

    template целыйТип_ли( T )
    {
        const бул целыйТип_ли = целыйЗначныйТип_ли!(T) ||
                                   целыйБеззначныйТип_ли!(T);
    }

    template указательИлиКласс_ли(T)
    {
        const указательИлиКласс_ли = is(T == class);
    }

    template указательИлиКласс_ли(T : T*)
    {
            const указательИлиКласс_ли = да;
    }
  
    template целыйЗначныйТип_ли( T )
    {
        const бул целыйЗначныйТип_ли = is( T == байт )  ||
                                         is( T == крат ) ||
цел                                         is( T == дол )/+||
                                         is( T == cent  )+/;
    }

    template целыйБеззначныйТип_ли( T )
    {
        const бул целыйБеззначныйТип_ли = is( T == ббайт )  ||
                                           is( T == бкрат ) ||
                                           is( T == бцел )   ||
                                           is( T == бдол )/+||
                                           is( T == ucent  )+/;
    }
    
     template УкНаКласс(T){
        static if (is(T==class)){
            alias ук УкНаКласс;
        } else {
            alias T УкНаКласс;
        }
    }
}


template атомныеЗначенияПравильноРазмещены( T )
{
    бул атомныеЗначенияПравильноРазмещены( т_мера адр )
    {
        return адр % УкНаКласс!(T).sizeof == 0;
    }
}

version(D_InlineAsm_X86){
    проц барьерПамяти(бул ll, бул ls, бул sl, бул ss, бул устройство=нет)(){
        static if (устройство) {
            if (ls || sl || ll || ss){
                // cpid should sequence even more than mfence
                volatile asm {
                    push EBX;
                    mov EAX, 0; // model, stepping
                    cpuid;
                    pop EBX;
                }
            }
        } else static if (ls || sl || (ll && ss)){ // use a sequencing operation like cpuid or simply cmpxch instead?
            volatile asm {
                mfence;
            }
            // this is supposedly faster and correct, but let's play it safe and use the specific instruction
            // push rax
            // xchg rax
            // pop rax
        } else static if (ll){
            volatile asm {
                lfence;
            }
        } else static if( ss ){
            volatile asm {
                sfence;
            }
        }
    }
} else version(D_InlineAsm_X86_64){
    проц барьерПамяти(бул ll, бул ls, бул sl, бул ss, бул устройство=нет)(){
        static if (устройство) {
            if (ls || sl || ll || ss){
                // cpid should sequence even more than mfence
                volatile asm {
                    push RBX;
                    mov RAX, 0; // model, stepping
                    cpuid;
                    pop RBX;
                }
            }
        } else static if (ls || sl || (ll && ss)){ // use a sequencing operation like cpuid or simply cmpxch instead?
            volatile asm {
                mfence;
            }
            // this is supposedly faster and correct, but let's play it safe and use the specific instruction
            // push rax
            // xchg rax
            // pop rax
        } else static if (ll){
            volatile asm {
                lfence;
            }
        } else static if( ss ){
            volatile asm {
                sfence;
            }
        }
    }
} else {
    pragma(msg,"ВНИМАНИЕ: на этой архитектуре нет атомных операций");
    pragma(msg,"ВНИМАНИЕ: это *медленно*, возможно, вам хотелось бы это изменить!");
    цел dummy;
    // acquires a блокируй... probably you will want to skip this
    synchronized проц барьерПамяти(бул ll, бул ls, бул sl, бул ss, бул устройство=нет)(){
        dummy =1;
    }
    enum{LockVersion = да}
}

static if (!is(typeof(LockVersion))) {
    enum{LockVersion= нет}
}

// use stricter fences
enum{строгиеЗаборы = нет}

/// utility function for a пиши barrier (disallow store and store reorderig)
проц барьерЗаписи();
/// utility function for a read barrier (disallow load and load reorderig)
проц барьерЧтения();
/// utility function for a full barrier (disallow reorderig)
проц полныйБарьер();


 version(D_InlineAsm_X86) {
    T атомнаяПерестановка( T )( inout T знач, T новЗнач )
    in {
        // NOTE: 32 bit x86 systems support 8 byte CAS, which only requires
        //       4 byte alignment, so use т_мера as the align type here.
        static if( T.sizeof > т_мера.sizeof )
            assert( атомныеЗначенияПравильноРазмещены!(т_мера)( cast(т_мера) &знач ) );
        else
            assert( атомныеЗначенияПравильноРазмещены!(T)( cast(т_мера) &знач ) );
    } body {
        T*значПоз=&знач;
        static if( T.sizeof == byte.sizeof ) {
            volatile asm {
                mov AL, новЗнач;
                mov ECX, значПоз;
                lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                xchg [ECX], AL;
            }
        }
        else static if( T.sizeof == short.sizeof ) {
            volatile asm {
                mov AX, новЗнач;
                mov ECX, значПоз;
                lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                xchg [ECX], AX;
            }
        }
        else static if( T.sizeof == цел.sizeof ) {
            volatile asm {
                mov EAX, новЗнач;
                mov ECX, значПоз;
                lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                xchg [ECX], EAX;
            }
        }
        else static if( T.sizeof == дол.sizeof ) {
            // 8 Byte swap on 32-Bit Processor, use CAS?
            static assert( нет, "Указан неверный шаблонный тип, 8 байт в 32-битном режиме: "~T.stringof );
        }
        else
        {
            static assert( нет, "Указан неверный шаблонный тип: "~T.stringof );
        }
    }
} else version (D_InlineAsm_X86_64){
    T атомнаяПерестановка( T )( inout T знач, T новЗнач )
    in {
        assert( атомныеЗначенияПравильноРазмещены!(T)( cast(т_мера) &знач ) );
    } body {
        T*значПоз=&знач;
        static if( T.sizeof == byte.sizeof ) {
            volatile asm {
                mov AL, новЗнач;
                mov RCX, значПоз;
                lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                xchg [RCX], AL;
            }
        }
        else static if( T.sizeof == short.sizeof ) {
            volatile asm {
                mov AX, новЗнач;
                mov RCX, значПоз;
                lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                xchg [RCX], AX;
            }
        }
        else static if( T.sizeof == цел.sizeof ) {
            volatile asm {
                mov EAX, новЗнач;
                mov RCX, значПоз;
                lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                xchg [RCX], EAX;
            }
        }
        else static if( T.sizeof == дол.sizeof ) {
            volatile asm {
                mov RAX, новЗнач;
                mov RCX, значПоз;
                lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                xchg [RCX], RAX;
            }
        }
        else
        {
            static assert( нет, "Указан неверный шаблонный тип: "~T.stringof );
        }
    }
} else {
    T атомнаяПерестановка( T )( inout T знач, T новЗнач )
    in {
        assert( атомныеЗначенияПравильноРазмещены!(T)( cast(т_мера) &знач ) );
    } body {
        T oldVal;
        synchronized(typeid(T)){
            oldVal=знач;
            знач=новЗнач;
        }
        return oldVal;
    }
}

//---------------------
// шаблон внутреннего преобразования
private T aCasT(T,V)(ref   T знач, T новЗнач, T оцениваетсяВ){
    union UVConv{V v; T t;}
    union UVPtrConv{V *v; T *t;}
    UVConv vNew,vOld,vAtt;
    UVPtrConv valPtr;
    vNew.t=новЗнач;
    vOld.t=оцениваетсяВ;
    valPtr.t=&знач;
    vAtt.v=atomicCAS(*valPtr.v,vNew.v,vOld.v);
    return vAtt.t;
}
/// внутренняя редукция 
private T aCas(T)(ref   T знач, T новЗнач, T оцениваетсяВ){
    static if (T.sizeof==1){
        return aCasT!(T,ббайт)(знач,новЗнач,оцениваетсяВ);
    } else static if (T.sizeof==2){
        return aCasT!(T,ushort)(знач,новЗнач,оцениваетсяВ);
    } else static if (T.sizeof==4){
        return aCasT!(T,бцел)(знач,новЗнач,оцениваетсяВ);
    } else static if (T.sizeof==8){ // unclear if it is always supported...
        return aCasT!(T,ulong)(знач,новЗнач,оцениваетсяВ);
    } else {
        static assert(0,"неверный тип "~T.stringof);
    }
}

version(D_InlineAsm_X86) {
    version(darwin){
        extern(C) ббайт OSAtomicCompareAndSwap64(дол oldValue, дол newValue,
                 дол *theValue); // assumes that in C sizeof(_Bool)==1 (as given in osx IA-32 ABI)
    }
    T atomicCAS( T )( ref   T знач, T новЗнач, T оцениваетсяВ )
    in {
        // NOTE: 32 bit x86 systems support 8 byte CAS, which only requires
        //       4 byte alignment, so use т_мера as the align type here.
        static if( УкНаКласс!(T).sizeof > т_мера.sizeof )
            assert( атомныеЗначенияПравильноРазмещены!(т_мера)( cast(т_мера) &знач ) );
        else
            assert( атомныеЗначенияПравильноРазмещены!(УкНаКласс!(T))( cast(т_мера) &знач ) );
    } body {
        T*значПоз=&знач;
        static if( T.sizeof == byte.sizeof ) {
            volatile asm {
                mov DL, новЗнач;
                mov AL, оцениваетсяВ;
                mov ECX, значПоз;
                lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                cmpxchg [ECX], DL;
            }
        }
        else static if( T.sizeof == short.sizeof ) {
            volatile asm {
                mov DX, новЗнач;
                mov AX, оцениваетсяВ;
                mov ECX, значПоз;
                lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                cmpxchg [ECX], DX;
            }
        }
        else static if( УкНаКласс!(T).sizeof == цел.sizeof ) {
            volatile asm {
                mov EDX, новЗнач;
                mov EAX, оцениваетсяВ;
                mov ECX, значПоз;
                lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                cmpxchg [ECX], EDX;
            }
        }
        else static if( T.sizeof == дол.sizeof ) {
            // 8 Byte StoreIf on 32-Bit Processor
            version(darwin){
                union UVConv{дол v; T t;}
                union UVPtrConv{дол *v; T *t;}
                UVConv vEqual,vNew;
                UVPtrConv valPtr;
                vEqual.t=оцениваетсяВ;
                vNew.t=новЗнач;
                valPtr.t=&знач;
                while(1){
                    if(OSAtomicCompareAndSwap64(vEqual.v, vNew.v, valPtr.v)!=0)
                    {
                        return оцениваетсяВ;
                    } else {
                        volatile {
                            T рез=знач;
                            if (рез!is оцениваетсяВ) return рез;
                        }
                    }
                }
            } else {
                T рез;
                volatile asm
                {
                    push EDI;
                    push EBX;
                    lea EDI, новЗнач;
                    mov EBX, [EDI];
                    mov ECX, 4[EDI];
                    lea EDI, оцениваетсяВ;
                    mov EAX, [EDI];
                    mov EDX, 4[EDI];
                    mov EDI, знач;
                    lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                    cmpxch8b [EDI];
                    lea EDI, рез;
                    mov [EDI], EAX;
                    mov 4[EDI], EDX;
                    pop EBX;
                    pop EDI;
                }
                return рез;
            }
        }
        else
        {
            static assert( нет, "Указан неверный шаблонный тип: "~T.stringof );
        }
    }
} else version (D_InlineAsm_X86_64){
    T atomicCAS( T )( ref   T знач, T новЗнач, T оцениваетсяВ )
    in {
        assert( атомныеЗначенияПравильноРазмещены!(T)( cast(т_мера) &знач ) );
    } body {
        T*значПоз=&знач;
        static if( T.sizeof == byte.sizeof ) {
            volatile asm {
                mov DL, новЗнач;
                mov AL, оцениваетсяВ;
                mov RCX, значПоз;
                lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                cmpxchg [RCX], DL;
            }
        }
        else static if( T.sizeof == short.sizeof ) {
            volatile asm {
                mov DX, новЗнач;
                mov AX, оцениваетсяВ;
                mov RCX, значПоз;
                lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                cmpxchg [RCX], DX;
            }
        }
        else static if( УкНаКласс!(T).sizeof == цел.sizeof ) {
            volatile asm {
                mov EDX, новЗнач;
                mov EAX, оцениваетсяВ;
                mov RCX, значПоз;
                lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                cmpxchg [RCX], EDX;
            }
        }
        else static if( УкНаКласс!(T).sizeof == дол.sizeof ) {
            volatile asm {
                mov RDX, новЗнач;
                mov RAX, оцениваетсяВ;
                mov RCX, значПоз;
                lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                cmpxchg [RCX], RDX;
            }
        }
        else
        {
            static assert( нет, "Задан неправильный шаблонный тип: "~T.stringof );
        }
    }
} else {
    T atomicCAS( T )( ref   T знач, T новЗнач, T оцениваетсяВ )
    in {
        assert( атомныеЗначенияПравильноРазмещены!(T)( cast(т_мера) &знач ) );
    } body {
        T oldval;
        synchronized(typeid(T)){
            oldval=знач;
            if(oldval==оцениваетсяВ) {
                знач=новЗнач;
            }
        }
        return oldval;
    }
}

бул atomicCASB(T)( ref   T знач, T новЗнач, T оцениваетсяВ ){
    return (оцениваетсяВ is atomicCAS(знач,новЗнач,оцениваетсяВ));
}


T атомнаяЗагрузка(T)(ref   T знач)
in {
    assert( атомныеЗначенияПравильноРазмещены!(T)( cast(т_мера) &знач ) );
    static assert(УкНаКласс!(T).sizeof<=т_мера.sizeof,"неверный размер для "~T.stringof);
} body {
    volatile T рез=знач;
    return рез;
}


проц атомноеСохранение(T)(ref   T знач, T newVal)
in {
        assert( атомныеЗначенияПравильноРазмещены!(T)( cast(т_мера) &знач ), "неверная раскладка" );
        static assert(УкНаКласс!(T).sizeof<=т_мера.sizeof,"наверный размер для "~T.stringof);
} body {
    volatile знач=newVal;
}


version (D_InlineAsm_X86){
    T атомнаяПрибавка(T,U=T)(ref   T знач, U инкЗ_){
        T инкЗ=cast(T)инкЗ_;
        static if (целыйТип_ли!(T)||указательИлиКласс_ли!(T)){
            T* значПоз=&знач;
            T рез;
            static if (T.sizeof==1){
                volatile asm {
                    mov DL, инкЗ;
                    mov ECX, значПоз;
                    lock;
                    xadd byte ptr [ECX],DL;
                    mov byte ptr рез[EBP],DL;
                }
            } else static if (T.sizeof==2){
                volatile asm {
                    mov DX, инкЗ;
                    mov ECX, значПоз;
                    lock;
                    xadd short ptr [ECX],DX;
                    mov short ptr рез[EBP],DX;
                }
            } else static if (T.sizeof==4){
                volatile asm
                {
                    mov EDX, инкЗ;
                    mov ECX, значПоз;
                    lock;
                    xadd int ptr [ECX],EDX;
                    mov int ptr рез[EBP],EDX;
                }
            } else static if (T.sizeof==8){
                return атомнаяОп(знач,delegate (T x){ return x+инкЗ; });
            } else {
                static assert(0,"Неподдерживаемый размер типа");
            }
            return рез;
        } else {
            return атомнаяОп(знач,delegate T(T a){ return a+инкЗ; });
        }
    }
} else version (D_InlineAsm_X86_64){
    T атомнаяПрибавка(T,U=T)(ref   T знач, U инкЗ_){
        T инкЗ=cast(T)инкЗ_;
        static if (целыйТип_ли!(T)||указательИлиКласс_ли!(T)){
            T* значПоз=&знач;
            T рез;
            static if (T.sizeof==1){
                volatile asm {
                    mov DL, инкЗ;
                    mov RCX, значПоз;
                    lock;
                    xadd byte ptr [RCX],DL;
                    mov byte ptr рез[EBP],DL;
                }
            } else static if (T.sizeof==2){
                volatile asm {
                    mov DX, инкЗ;
                    mov RCX, значПоз;
                    lock;
                    xadd short ptr [RCX],DX;
                    mov short ptr рез[EBP],DX;
                }
            } else static if (T.sizeof==4){
                volatile asm
                {
                    mov EDX, инкЗ;
                    mov RCX, значПоз;
                    lock;
                    xadd int ptr [RCX],EDX;
                    mov int ptr рез[EBP],EDX;
                }
            } else static if (T.sizeof==8){
                volatile asm
                {
                    mov RAX, знач;
                    mov RDX, инкЗ;
                    lock; // блокировка нужна всегда, чтобы эта операция стала атомной
                    xadd qword ptr [RAX],RDX;
                    mov рез[EBP],RDX;
                }
            } else {
                static assert(0,"Неподдерживаемый размер для типа:"~T.stringof);
            }
            return рез;
        } else {
            return атомнаяОп(знач,delegate T(T a){ return a+инкЗ; });
        }
    }
} else {
    static if (LockVersion){
        T атомнаяПрибавка(T,U=T)(ref   T знач, U инкЗ_){
            T инкЗ = cast(T)инкЗ_;
            static assert( целыйТип_ли!(T)||указательИлиКласс_ли!(T),"неверный тип: "~T.stringof );
            synchronized(typeid(T)){
                T старЗ=знач;
                знач+=инкЗ;
                return старЗ;
            }
        }
    } else {
        T атомнаяПрибавка(T,U=T)(ref   T знач, U инкЗ_){
            T инкЗ = cast(T)инкЗ_;
            static assert( целыйТип_ли!(T)||указательИлиКласс_ли!(T),"неверный тип: "~T.stringof );
            synchronized(typeid(T)){
                T старЗ, новЗ, следщЗнач;
                volatile следщЗнач=знач;
                do{
                    старЗ=следщЗнач;
                    новЗ=старЗ+инкЗ;
                    auto следщЗнач=atomicCAS!(T)(знач,новЗ,старЗ);
                } while(следщЗнач!=старЗ)
                return старЗ;
            }
        }
    }
}


T атомнаяОп(T)(ref   T знач, T delegate(T) f){
    T старЗ, новЗ, следщЗ;
    цел i=0;
    следщЗ = знач;
    do {
        старЗ = следщЗ;
        новЗ = f(старЗ);
        следщЗ = aCas!(T)(знач,новЗ,старЗ);
        if (следщЗ is старЗ || новЗ is старЗ) return старЗ;
    } while(++i<200)
    while (да){
        нить_жни();
        volatile старЗ = знач;
        новЗ=f(старЗ);
        следщЗ = aCas!(T)(знач,новЗ,старЗ);
        if (следщЗ is старЗ || новЗ is старЗ) return старЗ;
    }
}


T флагДай(T)(ref   T флаг){
    T рез;
    volatile рез=флаг;
    барьерПамяти!(да, нет, строгиеЗаборы, нет)();
    return рез;
}

T флагУст(T)(ref   T флаг,T newVal){
    барьерПамяти!(нет, строгиеЗаборы, нет, да)();
    return атомнаяПерестановка(флаг,newVal);
}

T флагОп(T)(ref   T флаг,T delegate(T) op){
    барьерПамяти!(нет, строгиеЗаборы, нет, да)();
    return атомнаяОп(флаг,op);
}

T флагДоб(T)(ref   T флаг,T инкЗ=cast(T)1){
    static if (!LockVersion)
        барьерПамяти!(нет, строгиеЗаборы, нет, да)();
    return атомнаяПрибавка(флаг,инкЗ);
}

T следщЗнач(T)(ref   T знач){
    return атомнаяПрибавка(знач,cast(T)1);
}

