﻿/**
 * Модуль atomic нацелен на обеспечение некоторыми базовыми операциями
 * в поддержку многопоточного l-free программирования.
 * Определены некоторые общие операции, каждая из которых может быть
 * выполнена с использованием заданного барьера памяти, либо менее
 * гранулярного барьера, если hardware не поддерживает требуемую версию.
 * Эта модель базируется на разработке Александра Терехова, о чём сказано в
 * <a href=http://groups.google.com/groups?threadm=3E4820EE.6F408B25%40web.de>
 * этом потоке</a>.  Другая полезная сноска по управлению памятью на современных
 * архитектурах - <a href=http://www.linuxjournal.com/article/8211>статья Пола Маккенни(Paul McKenney)</a>.
 *
 * Copyright: Copyright (C) 2005-2006 Sean Kelly.  Все права защищены.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Sean Kelly
 */
module core.TangoAtomic;


//pragma(msg, "core.TangoAtomic is deprecated. Please use core.sync.Atomic instead.");

//deprecated:

////////////////////////////////////////////////////////////////////////////////
// Synchronization Options
////////////////////////////////////////////////////////////////////////////////


/**
 * Memory synchronization flag.  If the supplied опция is not available on the
 * current platform then a stronger метод will be used instead.
 */
enum псинх
{
    необр,    /// not sequenced
    hlb,    /// hoist-загрузи barrier
    hsb,    /// hoist-сохрани barrier
    slb,    /// сток-загрузи barrier
    ssb,    /// сток-сохрани barrier
    acq,    /// hoist-загрузи + hoist-сохрани barrier
    относитн,    /// сток-загрузи + сток-сохрани barrier
    пследвтн,    /// fully sequenced (acq + относитн)
}


////////////////////////////////////////////////////////////////////////////////
// Internal Тип Checking
////////////////////////////////////////////////////////////////////////////////


private
{
    version( TangoDoc ) {} else
    {
        import tpl.traits;


        template реальноАтомныйТип_ли( T )
        {
            const бул реальноАтомныйТип_ли = T.sizeof == байт.sizeof  ||
                                           T.sizeof == крат.sizeof ||
                                           T.sizeof == цел.sizeof   ||
                                           T.sizeof == дол.sizeof;
        }


        template реальноЧисловойТип_ли( T )
        {
            const бул реальноЧисловойТип_ли = типЦелЧис_ли!( T ) ||
                                            типУк_ли!( T );
        }


        template isHoistOp( псинх мс )
        {
            const бул isHoistOp = мс == псинх.hlb ||
                                   мс == псинх.hsb ||
                                   мс == псинх.acq ||
                                   мс == псинх.пследвтн;
        }


        template isSinkOp( псинх мс )
        {
            const бул isSinkOp = мс == псинх.slb ||
                                  мс == псинх.ssb ||
                                  мс == псинх.относитн ||
                                  мс == псинх.пследвтн;
        }
    }
}


////////////////////////////////////////////////////////////////////////////////
// DDoc Documentation for Атомный Functions
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    ////////////////////////////////////////////////////////////////////////////
    // Атомный Load
    ////////////////////////////////////////////////////////////////////////////


    /**
     * Supported псинх values:
     *  псинх.необр
     *  псинх.hlb
     *  псинх.acq
     *  псинх.пследвтн
     */
    template атомнаяЗагрузка( псинх мс, T )
    {
        /**
         * Refreshes the contents of 'знач' из_ main память.  This operation is
         * Всё lock-free and atomic.
         *
         * Параметры:
         *  знач = The значение в_ загрузи.  This значение must be properly aligned.
         *
         * Возвращает:
         *  The загружен значение.
         */
        T атомнаяЗагрузка( ref T знач )
        {
            return знач;
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Store
    ////////////////////////////////////////////////////////////////////////////


    /**
     * Supported псинх values:
     *  псинх.необр
     *  псинх.ssb
     *  псинх.acq
     *  псинх.относитн
     *  псинх.пследвтн
     */
    template атомноеСохранение( псинх мс, T )
    {
        /**
         * Stores 'новзнач' в_ the память referenced by 'знач'.  This operation
         * is Всё lock-free and atomic.
         *
         * Параметры:
         *  знач     = The destination переменная.
         *  новзнач  = The значение в_ сохрани.
         */
        проц атомноеСохранение( ref T знач, T новзнач )
        {

        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный StoreIf
    ////////////////////////////////////////////////////////////////////////////


    /**
     * Supported псинх values:
     *  псинх.необр
     *  псинх.ssb
     *  псинх.acq
     *  псинх.относитн
     *  псинх.пследвтн
     */
    template атомноеСохранениеЕсли( псинх мс, T )
    {
        /**
         * Stores 'новзнач' в_ the память referenced by 'знач' if знач is equal в_
         * 'равноС'.  This operation is Всё lock-free and atomic.
         *
         * Параметры:
         *  знач     = The destination переменная.
         *  новзнач  = The значение в_ сохрани.
         *  равноС = The сравнение значение.
         *
         * Возвращает:
         *  да, если the сохрани occurred, нет if not.
         */
        бул атомноеСохранениеЕсли( ref T знач, T новзнач, T равноС )
        {
            return нет;
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Increment
    ////////////////////////////////////////////////////////////////////////////


    /**
     * Supported псинх values:
     *  псинх.необр
     *  псинх.ssb
     *  псинх.acq
     *  псинх.относитн
     *  псинх.пследвтн
     */
    template атомныйИнкремент( псинх мс, T )
    {
        /**
         * This operation is only legal for built-in значение and pointer типы,
         * and is equivalent в_ an atomic "знач = знач + 1" operation.  This
         * function есть_ли в_ facilitate use of the optimized инкремент
         * instructions предоставленный by some architecures.  If no such instruction
         * есть_ли on the мишень platform then the behavior will выполни the
         * operation using ещё traditional means.  This operation is Всё
         * lock-free and atomic.
         *
         * Параметры:
         *  знач = The значение в_ инкремент.
         *
         * Возвращает:
         *  The результат of an атомнаяЗагрузка of знач immediately following the
         *  инкремент operation.  This значение is not required в_ be equal в_ the
         *  newly stored значение.  Thus, competing writes are allowed в_ occur
         *  between the инкремент and successive загрузи operation.
         */
        T атомныйИнкремент( ref T знач )
        {
            return знач;
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Decrement
    ////////////////////////////////////////////////////////////////////////////


    /**
     * Supported псинх values:
     *  псинх.необр
     *  псинх.ssb
     *  псинх.acq
     *  псинх.относитн
     *  псинх.пследвтн
     */
    template атомныйДекремент( псинх мс, T )
    {
        /**
         * This operation is only legal for built-in значение and pointer типы,
         * and is equivalent в_ an atomic "знач = знач - 1" operation.  This
         * function есть_ли в_ facilitate use of the optimized декремент
         * instructions предоставленный by some architecures.  If no such instruction
         * есть_ли on the мишень platform then the behavior will выполни the
         * operation using ещё traditional means.  This operation is Всё
         * lock-free and atomic.
         *
         * Параметры:
         *  знач = The значение в_ декремент.
         *
         * Возвращает:
         *  The результат of an атомнаяЗагрузка of знач immediately following the
         *  инкремент operation.  This значение is not required в_ be equal в_ the
         *  newly stored значение.  Thus, competing writes are allowed в_ occur
         *  between the инкремент and successive загрузи operation.
         */
        T атомныйДекремент( ref T знач )
        {
            return знач;
        }
    }
}


////////////////////////////////////////////////////////////////////////////////
// LDC Atomics Implementation
////////////////////////////////////////////////////////////////////////////////


else version( LDC )
{
    import ldc.intrinsics;


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Load
    ////////////////////////////////////////////////////////////////////////////


    template атомнаяЗагрузка( псинх мс = псинх.пследвтн, T )
    {
        T атомнаяЗагрузка(ref T знач)
        {
            llvm_memory_barrier(
                мс == псинх.hlb || мс == псинх.acq || мс == псинх.пследвтн,
                мс == псинх.hsb || мс == псинх.acq || мс == псинх.пследвтн,
                мс == псинх.slb || мс == псинх.относитн || мс == псинх.пследвтн,
                мс == псинх.ssb || мс == псинх.относитн || мс == псинх.пследвтн,
                нет);
            static if (типУк_ли!(T))
            {
                return cast(T)llvm_atomic_load_добавь!(т_мера)(cast(т_мера*)&знач, 0);
            }
            else static if (is(T == бул))
            {
                return llvm_atomic_load_добавь!(ббайт)(cast(ббайт*)&знач, cast(ббайт)0) ? 1 : 0;
            }
            else
            {
                return llvm_atomic_load_добавь!(T)(&знач, cast(T)0);
            }
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Store
    ////////////////////////////////////////////////////////////////////////////


    template атомноеСохранение( псинх мс = псинх.пследвтн, T )
    {
        проц атомноеСохранение( ref T знач, T новзнач )
        {
            llvm_memory_barrier(
                мс == псинх.hlb || мс == псинх.acq || мс == псинх.пследвтн,
                мс == псинх.hsb || мс == псинх.acq || мс == псинх.пследвтн,
                мс == псинх.slb || мс == псинх.относитн || мс == псинх.пследвтн,
                мс == псинх.ssb || мс == псинх.относитн || мс == псинх.пследвтн,
                нет);
            static if (типУк_ли!(T))
            {
                llvm_atomic_своп!(т_мера)(cast(т_мера*)&знач, cast(т_мера)новзнач);
            }
            else static if (is(T == бул))
            {
                llvm_atomic_своп!(ббайт)(cast(ббайт*)&знач, новзнач?1:0);
            }
            else
            {
                llvm_atomic_своп!(T)(&знач, новзнач);
            }
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Store If
    ////////////////////////////////////////////////////////////////////////////


    template атомноеСохранениеЕсли( псинх мс = псинх.пследвтн, T )
    {
        бул атомноеСохранениеЕсли( ref T знач, T новзнач, T равноС )
        {
            llvm_memory_barrier(
                мс == псинх.hlb || мс == псинх.acq || мс == псинх.пследвтн,
                мс == псинх.hsb || мс == псинх.acq || мс == псинх.пследвтн,
                мс == псинх.slb || мс == псинх.относитн || мс == псинх.пследвтн,
                мс == псинх.ssb || мс == псинх.относитн || мс == псинх.пследвтн,
                нет);
            T oldval =void;
            static if (типУк_ли!(T))
            {
                oldval = cast(T)llvm_atomic_cmp_своп!(т_мера)(cast(т_мера*)&знач, cast(т_мера)равноС, cast(т_мера)новзнач);
            }
            else static if (is(T == бул))
            {
                oldval = llvm_atomic_cmp_своп!(ббайт)(cast(ббайт*)&знач, равноС?1:0, новзнач?1:0)?0:1;
            }
            else
            {
                oldval = llvm_atomic_cmp_своп!(T)(&знач, равноС, новзнач);
            }
            return oldval == равноС;
        }
    }
    
    
    ////////////////////////////////////////////////////////////////////////////
    // Атомный Increment
    ////////////////////////////////////////////////////////////////////////////


    template атомныйИнкремент( псинх мс = псинх.пследвтн, T )
    {
        //
        // NOTE: This operation is only valid for целое or pointer типы
        //
        static assert( реальноЧисловойТип_ли!(T) );


        T атомныйИнкремент( ref T знач )
        {
            static if (типУк_ли!(T))
            {
                llvm_atomic_load_добавь!(т_мера)(cast(т_мера*)&знач, 1);
            }
            else
            {
                llvm_atomic_load_добавь!(T)(&знач, cast(T)1);
            }
            return знач;
        }
    }
    
    
    ////////////////////////////////////////////////////////////////////////////
    // Атомный Decrement
    ////////////////////////////////////////////////////////////////////////////


    template атомныйДекремент( псинх мс = псинх.пследвтн, T )
    {
        //
        // NOTE: This operation is only valid for целое or pointer типы
        //
        static assert( реальноЧисловойТип_ли!(T) );


        T атомныйДекремент( ref T знач )
        {
            static if (типУк_ли!(T))
            {
                llvm_atomic_load_sub!(т_мера)(cast(т_мера*)&знач, 1);
            }
            else
            {
                llvm_atomic_load_sub!(T)(&знач, cast(T)1);
            }
            return знач;
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
// x86 Атомный Function Implementation
////////////////////////////////////////////////////////////////////////////////


else version( D_InlineAsm_X86 )
{
    version( X86 )
    {
        version( BuildInfo )
        {
            pragma( msg, "core.TangoAtomic: using IA-32 inline asm" );
        }

        version(darwin){
            extern(C) бул OSAtomicCompareAndSwap64(дол oldValue, дол newValue, дол *theValue);
            extern(C) бул OSAtomicCompareAndSwap64Barrier(дол oldValue, дол newValue, дол *theValue);
        }
        version = Has64BitCAS;
        version = Has32BitOps;
    }
    version( X86_64 )
    {
        version( BuildInfo )
        {
            pragma( msg, "core.TangoAtomic: using AMD64 inline asm" );
        }

        version = Has64BitOps;
    }

    private
    {
        ////////////////////////////////////////////////////////////////////////
        // x86 Значение Requirements
        ////////////////////////////////////////////////////////////////////////


        // NOTE: Strictly speaking, the x86 supports atomic operations on
        //       unaligned values.  However, this is far slower than the
        //       common case, so such behavior should be prohibited.
        template атомноеЗначениеРазложеноПравильно( T )
        {
            бул атомноеЗначениеРазложеноПравильно( т_мера адр )
            {
                return адр % T.sizeof == 0;
            }
        }


        ////////////////////////////////////////////////////////////////////////
        // x86 Synchronization Requirements
        ////////////////////////////////////////////////////////////////////////


        // NOTE: While x86 loads have acquire semantics for stores, it appears
        //       that independent loads may be reordered by some processors
        //       (notably the AMD64).  This implies that the hoist-загрузи barrier
        //       op requires an ordering instruction, which also extends this
        //       requirement в_ acquire ops (though hoist-сохрани should not need
        //       one if support is добавьed for this later).  However, since no
        //       modern architectures will reorder dependent loads в_ occur
        //       перед the загрузи they depend on (except the Alpha), необр loads
        //       are actually a possible means of ordering specific sequences
        //       of loads in some instances.  The original atomic<>
        //       implementation provопрes a 'ddhlb' ordering определитель for
        //       данные-dependent loads в_ укз this situation, but as there
        //       are no plans в_ support the Alpha there is no резон в_ добавь
        //       that опция here.
        //
        //       For reference, the old behavior (acquire semantics for loads)
        //       required a память barrier if: мс == псинх.пследвтн || isSinkOp!(мс)
        template требуетсяБарьерЗагрузки( псинх мс )
        {
            const бул требуетсяБарьерЗагрузки = мс != псинх.необр;
        }


        // NOTE: x86 stores implicitly have release semantics so a membar is only
        //       necessary on acquires.
        template требуетсяБарьерСохранения( псинх мс )
        {
            const бул требуетсяБарьерСохранения = мс == псинх.пследвтн || isHoistOp!(мс);
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Load
    ////////////////////////////////////////////////////////////////////////////


    template атомнаяЗагрузка( псинх мс = псинх.пследвтн, T )
    {
        T атомнаяЗагрузка( ref T знач )
        in
        {
            assert( атомноеЗначениеРазложеноПравильно!(T)( cast(т_мера) &знач ) );
        }
        body
        {
            static if( T.sizeof == байт.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 1 Byte Load
                ////////////////////////////////////////////////////////////////


                static if( требуетсяБарьерЗагрузки!(мс) )
                {
                    volatile asm
                    {
                        mov DL, 42;
                        mov AL, 42;
                        mov ECX, знач;
                        lock;
                        cmpxchg [ECX], DL;
                    }
                }
                else
                {
                    volatile
                    {
                        return знач;
                    }
                }
            }
            else static if( T.sizeof == крат.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 2 Byte Load
                ////////////////////////////////////////////////////////////////

                static if( требуетсяБарьерЗагрузки!(мс) )
                {
                    volatile asm
                    {
                        mov DX, 42;
                        mov AX, 42;
                        mov ECX, знач;
                        lock;
                        cmpxchg [ECX], DX;
                    }
                }
                else
                {
                    volatile
                    {
                        return знач;
                    }
                }
            }
            else static if( T.sizeof == цел.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 4 Byte Load
                ////////////////////////////////////////////////////////////////


                static if( требуетсяБарьерЗагрузки!(мс) )
                {
                    volatile asm
                    {
                        mov EDX, 42;
                        mov EAX, 42;
                        mov ECX, знач;
                        lock;
                        cmpxchg [ECX], EDX;
                    }
                }
                else
                {
                    volatile
                    {
                        return знач;
                    }
                }
            }
            else static if( T.sizeof == дол.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 8 Byte Load
                ////////////////////////////////////////////////////////////////


                version( Has64BitOps )
                {
                    ////////////////////////////////////////////////////////////
                    // 8 Byte Load on 64-Bit Processor
                    ////////////////////////////////////////////////////////////


                    static if( требуетсяБарьерЗагрузки!(мс) )
                    {
                        volatile asm
                        {
                            mov RAX, знач;
                            lock;
                            mov RAX, [RAX];
                        }
                    }
                    else
                    {
                        volatile
                        {
                            return знач;
                        }
                    }
                }
                else
                {
                    ////////////////////////////////////////////////////////////
                    // 8 Byte Load on 32-Bit Processor
                    ////////////////////////////////////////////////////////////


                    pragma( msg, "Эта операция доступна только на 64-битных платформах." );
                    static assert( нет );
                }
            }
            else
            {
                ////////////////////////////////////////////////////////////////
                // Not a 1, 2, 4, либо 8 Byte Тип
                ////////////////////////////////////////////////////////////////


                pragma( msg, "Задан неверный тип шаблона." );
                static assert( нет );
            }
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Store
    ////////////////////////////////////////////////////////////////////////////


    template атомноеСохранение( псинх мс = псинх.пследвтн, T )
    {
        проц атомноеСохранение( ref T знач, T новзнач )
        in
        {
            assert( атомноеЗначениеРазложеноПравильно!(T)( cast(т_мера) &знач ) );
        }
        body
        {
            static if( T.sizeof == байт.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 1 Byte Store
                ////////////////////////////////////////////////////////////////


                static if( требуетсяБарьерСохранения!(мс) )
                {
                    volatile asm
                    {
                        mov EAX, знач;
                        mov DL, новзнач;
                        lock;
                        xchg [EAX], DL;
                    }
                }
                else
                {
                    volatile asm
                    {
                        mov EAX, знач;
                        mov DL, новзнач;
                        mov [EAX], DL;
                    }
                }
            }
            else static if( T.sizeof == крат.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 2 Byte Store
                ////////////////////////////////////////////////////////////////


                static if( требуетсяБарьерСохранения!(мс) )
                {
                    volatile asm
                    {
                        mov EAX, знач;
                        mov DX, новзнач;
                        lock;
                        xchg [EAX], DX;
                    }
                }
                else
                {
                    volatile asm
                    {
                        mov EAX, знач;
                        mov DX, новзнач;
                        mov [EAX], DX;
                    }
                }
            }
            else static if( T.sizeof == цел.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 4 Byte Store
                ////////////////////////////////////////////////////////////////


                static if( требуетсяБарьерСохранения!(мс) )
                {
                    volatile asm
                    {
                        mov EAX, знач;
                        mov EDX, новзнач;
                        lock;
                        xchg [EAX], EDX;
                    }
                }
                else
                {
                    volatile asm
                    {
                        mov EAX, знач;
                        mov EDX, новзнач;
                        mov [EAX], EDX;
                    }
                }
            }
            else static if( T.sizeof == дол.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 8 Byte Store
                ////////////////////////////////////////////////////////////////


                version( Has64BitOps )
                {
                    ////////////////////////////////////////////////////////////
                    // 8 Byte Store on 64-Bit Processor
                    ////////////////////////////////////////////////////////////


                    static if( требуетсяБарьерСохранения!(мс) )
                    {
                        volatile asm
                        {
                            mov RAX, знач;
                            mov RDX, новзнач;
                            lock;
                            xchg [RAX], RDX;
                        }
                    }
                    else
                    {
                        volatile asm
                        {
                            mov RAX, знач;
                            mov RDX, новзнач;
                            mov [RAX], RDX;
                        }
                    }
                }
                else
                {
                    ////////////////////////////////////////////////////////////
                    // 8 Byte Store on 32-Bit Processor
                    ////////////////////////////////////////////////////////////


                    pragma( msg, "Эта операция доступна только на 64-битных платформах." );
                    static assert( нет );
                }
            }
            else
            {
                ////////////////////////////////////////////////////////////////
                // Not a 1, 2, 4, либо 8 Byte Тип
                ////////////////////////////////////////////////////////////////


                pragma( msg, "Неверно задан тип шаблона." );
                static assert( нет );
            }
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Store If
    ////////////////////////////////////////////////////////////////////////////


    template атомноеСохранениеЕсли( псинх мс = псинх.пследвтн, T )
    {
        бул атомноеСохранениеЕсли( ref T знач, T новзнач, T равноС )
        in
        {
            // NOTE: 32 bit x86 systems support 8 байт CAS, which only requires
            //       4 байт alignment, so use т_мера as the align тип here.
            static if( T.sizeof > т_мера.sizeof )
                assert( атомноеЗначениеРазложеноПравильно!(т_мера)( cast(т_мера) &знач ) );
            else
                assert( атомноеЗначениеРазложеноПравильно!(T)( cast(т_мера) &знач ) );
        }
        body
        {
            static if( T.sizeof == байт.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 1 Byte StoreIf
                ////////////////////////////////////////////////////////////////


                volatile asm
                {
                    mov DL, новзнач;
                    mov AL, равноС;
                    mov ECX, знач;
                    lock; // lock always needed в_ сделай this op atomic
                    cmpxchg [ECX], DL;
                    setz AL;
                }
            }
            else static if( T.sizeof == крат.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 2 Byte StoreIf
                ////////////////////////////////////////////////////////////////


                volatile asm
                {
                    mov DX, новзнач;
                    mov AX, равноС;
                    mov ECX, знач;
                    lock; // lock always needed в_ сделай this op atomic
                    cmpxchg [ECX], DX;
                    setz AL;
                }
            }
            else static if( T.sizeof == цел.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 4 Byte StoreIf
                ////////////////////////////////////////////////////////////////


                volatile asm
                {
                    mov EDX, новзнач;
                    mov EAX, равноС;
                    mov ECX, знач;
                    lock; // lock always needed в_ сделай this op atomic
                    cmpxchg [ECX], EDX;
                    setz AL;
                }
            }
            else static if( T.sizeof == дол.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 8 Byte StoreIf
                ////////////////////////////////////////////////////////////////


                version( Has64BitOps )
                {
                    ////////////////////////////////////////////////////////////
                    // 8 Byte StoreIf on 64-Bit Processor
                    ////////////////////////////////////////////////////////////


                    volatile asm
                    {
                        mov RDX, новзнач;
                        mov RAX, равноС;
                        mov RCX, знач;
                        lock; // lock always needed в_ сделай this op atomic
                        cmpxchg [RCX], RDX;
                        setz AL;
                    }
                }
                else version( Has64BitCAS )
                {
                    ////////////////////////////////////////////////////////////
                    // 8 Byte StoreIf on 32-Bit Processor
                    ////////////////////////////////////////////////////////////
                    version(darwin){
                        static if(мс==псинх.необр){
                            return OSAtomicCompareAndSwap64(cast(дол)равноС, cast(дол)новзнач,  cast(дол*)&знач);
                        } else {
                            return OSAtomicCompareAndSwap64Barrier(cast(дол)равноС, cast(дол)новзнач,  cast(дол*)&знач);
                        }
                    } else {
                        volatile asm
                        {
                            push EDI;
                            push EBX;
                            lea EDI, новзнач;
                            mov EBX, [EDI];
                            mov ECX, 4[EDI];
                            lea EDI, равноС;
                            mov EAX, [EDI];
                            mov EDX, 4[EDI];
                            mov EDI, знач;
                            lock; // lock always needed в_ сделай this op atomic
                            cmpxch8b [EDI];
                            setz AL;
                            pop EBX;
                            pop EDI;
                        }
                    }
                }
            }
            else
            {
                ////////////////////////////////////////////////////////////////
                // Not a 1, 2, 4, либо 8 Byte Тип
                ////////////////////////////////////////////////////////////////


                pragma( msg, "Неверно задан тип шаблона." );
                static assert( нет );
            }
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Increment
    ////////////////////////////////////////////////////////////////////////////


    template атомныйИнкремент( псинх мс = псинх.пследвтн, T )
    {
        //
        // NOTE: This operation is only valid for целое or pointer типы
        //
        static assert( реальноЧисловойТип_ли!(T) );


        T атомныйИнкремент( ref T знач )
        in
        {
            assert( атомноеЗначениеРазложеноПравильно!(T)( cast(т_мера) &знач ) );
        }
        body
        {
            static if( T.sizeof == байт.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 1 Byte Increment
                ////////////////////////////////////////////////////////////////


                volatile asm
                {
                    mov EAX, знач;
                    lock; // lock always needed в_ сделай this op atomic
                    inc [EAX];
                    mov AL, [EAX];
                }
            }
            else static if( T.sizeof == крат.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 2 Byte Increment
                ////////////////////////////////////////////////////////////////


                volatile asm
                {
                    mov EAX, знач;
                    lock; // lock always needed в_ сделай this op atomic
                    inc крат ptr [EAX];
                    mov AX, [EAX];
                }
            }
            else static if( T.sizeof == цел.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 4 Byte Increment
                ////////////////////////////////////////////////////////////////


                volatile asm
                {
                    mov EAX, знач;
                    lock; // lock always needed в_ сделай this op atomic
                    inc int ptr [EAX];
                    mov EAX, [EAX];
                }
            }
            else static if( T.sizeof == дол.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 8 Byte Increment
                ////////////////////////////////////////////////////////////////


                version( Has64BitOps )
                {
                    ////////////////////////////////////////////////////////////
                    // 8 Byte Increment on 64-Bit Processor
                    ////////////////////////////////////////////////////////////


                    volatile asm
                    {
                        mov RAX, знач;
                        lock; // lock always needed в_ сделай this op atomic
                        inc qword ptr [RAX];
                        mov RAX, [RAX];
                    }
                }
                else
                {
                    ////////////////////////////////////////////////////////////
                    // 8 Byte Increment on 32-Bit Processor
                    ////////////////////////////////////////////////////////////


                    pragma( msg, "Эта операция доступна только на 64-битных платформах." );
                    static assert( нет );
                }
            }
            else
            {
                ////////////////////////////////////////////////////////////////
                // Not a 1, 2, 4, либо 8 Byte Тип
                ////////////////////////////////////////////////////////////////


                pragma( msg, "Задан неверный тип шаблона." );
                static assert( нет );
            }
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Decrement
    ////////////////////////////////////////////////////////////////////////////


    template атомныйДекремент( псинх мс = псинх.пследвтн, T )
    {
        //
        // NOTE: This operation is only valid for целое or pointer типы
        //
        static assert( реальноЧисловойТип_ли!(T) );


        T атомныйДекремент( ref T знач )
        in
        {
            assert( атомноеЗначениеРазложеноПравильно!(T)( cast(т_мера) &знач ) );
        }
        body
        {
            static if( T.sizeof == байт.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 1 Byte Decrement
                ////////////////////////////////////////////////////////////////


                volatile asm
                {
                    mov EAX, знач;
                    lock; // lock always needed в_ сделай this op atomic
                    dec [EAX];
                    mov AL, [EAX];
                }
            }
            else static if( T.sizeof == крат.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 2 Byte Decrement
                ////////////////////////////////////////////////////////////////


                volatile asm
                {
                    mov EAX, знач;
                    lock; // lock always needed в_ сделай this op atomic
                    dec крат ptr [EAX];
                    mov AX, [EAX];
                }
            }
            else static if( T.sizeof == цел.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 4 Byte Decrement
                ////////////////////////////////////////////////////////////////


                volatile asm
                {
                    mov EAX, знач;
                    lock; // lock always needed в_ сделай this op atomic
                    dec int ptr [EAX];
                    mov EAX, [EAX];
                }
            }
            else static if( T.sizeof == дол.sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // 8 Byte Decrement
                ////////////////////////////////////////////////////////////////


                version( Has64BitOps )
                {
                    ////////////////////////////////////////////////////////////
                    // 8 Byte Decrement on 64-Bit Processor
                    ////////////////////////////////////////////////////////////


                    volatile asm
                    {
                        mov RAX, знач;
                        lock; // lock always needed в_ сделай this op atomic
                        dec qword ptr [RAX];
                        mov RAX, [RAX];
                    }
                }
                else
                {
                    ////////////////////////////////////////////////////////////
                    // 8 Byte Decrement on 32-Bit Processor
                    ////////////////////////////////////////////////////////////


                    pragma( msg, "Эта операция доступна только на 64-битных платформах." );
                    static assert( нет );
                }
            }
            else
            {
                ////////////////////////////////////////////////////////////////
                // Not a 1, 2, 4, либо 8 Byte Тип
                ////////////////////////////////////////////////////////////////


                pragma( msg, "Неверный template тип specified." );
                static assert( нет );
            }
        }
    }
}
else
{
    version( BuildInfo )
    {
        pragma( msg, "core.TangoAtomic: using synchronized ops" );
    }

    private
    {
        ////////////////////////////////////////////////////////////////////////
        // Default Значение Requirements
        ////////////////////////////////////////////////////////////////////////


        template атомноеЗначениеРазложеноПравильно( T )
        {
            бул атомноеЗначениеРазложеноПравильно( т_мера адр )
            {
                return адр % T.sizeof == 0;
            }
        }


        ////////////////////////////////////////////////////////////////////////
        // Default Synchronization Requirements
        ////////////////////////////////////////////////////////////////////////


        template требуетсяБарьерЗагрузки( псинх мс )
        {
            const бул требуетсяБарьерЗагрузки = мс != псинх.необр;
        }


        template требуетсяБарьерСохранения( псинх мс )
        {
            const бул требуетсяБарьерСохранения = мс != псинх.необр;
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Load
    ////////////////////////////////////////////////////////////////////////////


    template атомнаяЗагрузка( псинх мс = псинх.пследвтн, T )
    {
        T атомнаяЗагрузка( ref T знач )
        in
        {
            assert( атомноеЗначениеРазложеноПравильно!(T)( cast(т_мера) &знач ) );
        }
        body
        {
            static if( T.sizeof <= (проц*).sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // <= (проц*).sizeof Byte Load
                ////////////////////////////////////////////////////////////////


                static if( требуетсяБарьерЗагрузки!(мс) )
                {
                    synchronized
                    {
                        return знач;
                    }
                }
                else
                {
                    volatile
                    {
                        return знач;
                    }
                }
            }
            else
            {
                ////////////////////////////////////////////////////////////////
                // > (проц*).sizeof Byte Тип
                ////////////////////////////////////////////////////////////////


                pragma( msg, "Неверный template тип specified." );
                static assert( нет );
            }
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Store
    ////////////////////////////////////////////////////////////////////////////


    template атомноеСохранение( псинх мс = псинх.пследвтн, T )
    {
        проц атомноеСохранение( ref T знач, T новзнач )
        in
        {
            assert( атомноеЗначениеРазложеноПравильно!(T)( cast(т_мера) &знач ) );
        }
        body
        {
            static if( T.sizeof <= (проц*).sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // <= (проц*).sizeof Byte Store
                ////////////////////////////////////////////////////////////////


                static if( требуетсяБарьерСохранения!(мс) )
                {
                    synchronized
                    {
                        знач = новзнач;
                    }
                }
                else
                {
                    volatile
                    {
                        знач = новзнач;
                    }
                }
            }
            else
            {
                ////////////////////////////////////////////////////////////////
                // > (проц*).sizeof Byte Тип
                ////////////////////////////////////////////////////////////////


                pragma( msg, "Неверный template тип specified." );
                static assert( нет );
            }
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Store If
    ////////////////////////////////////////////////////////////////////////////


    template атомноеСохранениеЕсли( псинх мс = псинх.пследвтн, T )
    {
        бул атомноеСохранениеЕсли( ref T знач, T новзнач, T равноС )
        in
        {
            assert( атомноеЗначениеРазложеноПравильно!(T)( cast(т_мера) &знач ) );
        }
        body
        {
            static if( T.sizeof <= (проц*).sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // <= (проц*).sizeof Byte StoreIf
                ////////////////////////////////////////////////////////////////


                synchronized
                {
                    if( знач == равноС )
                    {
                        знач = новзнач;
                        return да;
                    }
                    return нет;
                }
            }
            else
            {
                ////////////////////////////////////////////////////////////////
                // > (проц*).sizeof Byte Тип
                ////////////////////////////////////////////////////////////////


                pragma( msg, "Неверный template тип specified." );
                static assert( нет );
            }
        }
    }


    /////////////////////////////////////////////////////////////////////////////
    // Атомный Increment
    ////////////////////////////////////////////////////////////////////////////


    template атомныйИнкремент( псинх мс = псинх.пследвтн, T )
    {
        //
        // NOTE: This operation is only valid for целое or pointer типы
        //
        static assert( реальноЧисловойТип_ли!(T) );


        T атомныйИнкремент( ref T знач )
        in
        {
            assert( атомноеЗначениеРазложеноПравильно!(T)( cast(т_мера) &знач ) );
        }
        body
        {
            static if( T.sizeof <= (проц*).sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // <= (проц*).sizeof Byte Increment
                ////////////////////////////////////////////////////////////////


                synchronized
                {
                    return ++знач;
                }
            }
            else
            {
                ////////////////////////////////////////////////////////////////
                // > (проц*).sizeof Byte Тип
                ////////////////////////////////////////////////////////////////


                pragma( msg, "Неверный template тип specified." );
                static assert( нет );
            }
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Decrement
    ////////////////////////////////////////////////////////////////////////////


    template атомныйДекремент( псинх мс = псинх.пследвтн, T )
    {
        //
        // NOTE: This operation is only valid for целое or pointer типы
        //
        static assert( реальноЧисловойТип_ли!(T) );


        T атомныйДекремент( ref T знач )
        in
        {
            assert( атомноеЗначениеРазложеноПравильно!(T)( cast(т_мера) &знач ) );
        }
        body
        {
            static if( T.sizeof <= (проц*).sizeof )
            {
                ////////////////////////////////////////////////////////////////
                // <= (проц*).sizeof Byte Decrement
                ////////////////////////////////////////////////////////////////


                synchronized
                {
                    return --знач;
                }
            }
            else
            {
                ////////////////////////////////////////////////////////////////
                // > (проц*).sizeof Byte Тип
                ////////////////////////////////////////////////////////////////


                pragma( msg, "Неверный template type specified." );
                static assert( нет );
            }
        }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Атомный
////////////////////////////////////////////////////////////////////////////////


/**
 * This struct represents a значение which will be субъект в_ competing access.
 * все accesses в_ this значение will be synchronized with main память, and
 * various память barriers may be employed for instruction ordering.  Any
 * primitive тип of размер equal в_ or smaller than the память bus размер is
 * allowed, so 32-bit machines may use values with размер <= цел.sizeof and
 * 64-bit machines may use values with размер <= дол.sizeof.  The one исключение
 * в_ this правило is that architectures that support DCAS will allow дво-wide
 * сохраниЕсли operations.  The 32-bit x86 architecture, for example, supports
 * 64-bit сохраниЕсли operations.
 */
struct Атомный( T )
{
    ////////////////////////////////////////////////////////////////////////////
    // Атомный Load
    ////////////////////////////////////////////////////////////////////////////


    template загрузи( псинх мс = псинх.пследвтн )
    {
        static assert( мс == псинх.необр || мс == псинх.hlb ||
                       мс == псинх.acq || мс == псинх.пследвтн,
                       "мс must be one of: псинх.необр, псинх.hlb, псинх.acq, псинх.пследвтн" );

        /**
         * Refreshes the contents of this значение из_ main память.  This
         * operation is Всё lock-free and atomic.
         *
         * Возвращает:
         *  The загружен значение.
         */
        T загрузи()
        {
            return атомнаяЗагрузка!(мс,T)( m_val );
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный Store
    ////////////////////////////////////////////////////////////////////////////


    template сохрани( псинх мс = псинх.пследвтн )
    {
        static assert( мс == псинх.необр || мс == псинх.ssb ||
                       мс == псинх.acq || мс == псинх.относитн ||
                       мс == псинх.пследвтн,
                       "мс must be one of: псинх.необр, псинх.ssb, псинх.acq, псинх.относитн, псинх.пследвтн" );

        /**
         * Stores 'новзнач' в_ the память referenced by this значение.  This
         * operation is Всё lock-free and atomic.
         *
         * Параметры:
         *  новзнач  = The значение в_ сохрани.
         */
        проц сохрани( T новзнач )
        {
            атомноеСохранение!(мс,T)( m_val, новзнач );
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Атомный StoreIf
    ////////////////////////////////////////////////////////////////////////////


    template сохраниЕсли( псинх мс = псинх.пследвтн )
    {
        static assert( мс == псинх.необр || мс == псинх.ssb ||
                       мс == псинх.acq || мс == псинх.относитн ||
                       мс == псинх.пследвтн,
                       "мс must be one of: псинх.необр, псинх.ssb, псинх.acq, псинх.относитн, псинх.пследвтн" );

        /**
         * Stores 'новзнач' в_ the память referenced by this значение if знач is
         * equal в_ 'равноС'.  This operation is Всё lock-free and atomic.
         *
         * Параметры:
         *  новзнач  = The значение в_ сохрани.
         *  равноС = The сравнение значение.
         *
         * Возвращает:
         *  да, если the сохрани occurred, нет if not.
         */
        бул сохраниЕсли( T новзнач, T равноС )
        {
            return атомноеСохранениеЕсли!(мс,T)( m_val, новзнач, равноС );
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Numeric Functions
    ////////////////////////////////////////////////////////////////////////////

	version( TangoDoc )
	{
		/**
		 * The following добавьitional functions are available for целое типы.
		 */
		////////////////////////////////////////////////////////////////////////
		// Атомный Increment
		////////////////////////////////////////////////////////////////////////


		template инкремент( псинх мс = псинх.пследвтн )
		{
			/**
			 * This operation is only legal for built-in значение and pointer
			 * типы, and is equivalent в_ an atomic "знач = знач + 1" operation.
			 * This function есть_ли в_ facilitate use of the optimized
			 * инкремент instructions предоставленный by some architecures.  If no
			 * such instruction есть_ли on the мишень platform then the
			 * behavior will выполни the operation using ещё traditional
			 * means.  This operation is Всё lock-free and atomic.
			 *
			 * Возвращает:
			 *  The результат of an атомнаяЗагрузка of знач immediately following the
			 *  инкремент operation.  This значение is not required в_ be equal в_
			 *  the newly stored значение.  Thus, competing writes are allowed в_
			 *  occur between the инкремент and successive загрузи operation.
			 */
			T инкремент()
			{
				return m_val;
			}
		}


		////////////////////////////////////////////////////////////////////////
		// Атомный Decrement
		////////////////////////////////////////////////////////////////////////


		template декремент( псинх мс = псинх.пследвтн )
		{
			/**
			 * This operation is only legal for built-in значение and pointer
			 * типы, and is equivalent в_ an atomic "знач = знач - 1" operation.
			 * This function есть_ли в_ facilitate use of the optimized
			 * декремент instructions предоставленный by some architecures.  If no
			 * such instruction есть_ли on the мишень platform then the behavior
			 * will выполни the operation using ещё traditional means.  This
			 * operation is Всё lock-free and atomic.
			 *
			 * Возвращает:
			 *  The результат of an атомнаяЗагрузка of знач immediately following the
			 *  инкремент operation.  This значение is not required в_ be equal в_
			 *  the newly stored значение.  Thus, competing writes are allowed в_
			 *  occur between the инкремент and successive загрузи operation.
			 */
			T декремент()
			{
				return m_val;
			}
		}
	}
	else
	{
		static if( реальноЧисловойТип_ли!(T) )
		{
			////////////////////////////////////////////////////////////////////////
			// Атомный Increment
			////////////////////////////////////////////////////////////////////////


			template инкремент( псинх мс = псинх.пследвтн )
			{
				static assert( мс == псинх.необр || мс == псинх.ssb ||
							   мс == псинх.acq || мс == псинх.относитн ||
							   мс == псинх.пследвтн,
							   "мс must be one of: псинх.необр, псинх.ssb, псинх.acq, псинх.относитн, псинх.пследвтн" );
				T инкремент()
				{
					return атомныйИнкремент!(мс,T)( m_val );
				}
			}


			////////////////////////////////////////////////////////////////////////
			// Атомный Decrement
			////////////////////////////////////////////////////////////////////////


			template декремент( псинх мс = псинх.пследвтн )
			{
				static assert( мс == псинх.необр || мс == псинх.ssb ||
							   мс == псинх.acq || мс == псинх.относитн ||
							   мс == псинх.пследвтн,
							   "мс must be one of: псинх.необр, псинх.ssb, псинх.acq, псинх.относитн, псинх.пследвтн" );
				T декремент()
				{
					return атомныйДекремент!(мс,T)( m_val );
				}
			}
		}
	}

private:
    T   m_val;
}


////////////////////////////////////////////////////////////////////////////////
// Support Code for Unit Tests
////////////////////////////////////////////////////////////////////////////////


private
{
    version( TangoDoc ) {} else
    {
        template тестЗагр( псинх мс, T )
        {
            проц тестЗагр( T знач = T.init + 1)
            {
                T          основа;
                Атомный!(T) atom;

                assert( atom.загрузи!(мс)() == основа );
                основа        = знач;
                atom.m_val  = знач;
                assert( atom.загрузи!(мс)() == основа );
            }
        }


        template тестСохр( псинх мс, T )
        {
            проц тестСохр( T знач = T.init + 1)
            {
                T          основа;
                Атомный!(T) atom;

                assert( atom.m_val == основа );
                основа = знач;
                atom.сохрани!(мс)( основа );
                assert( atom.m_val == основа );
            }
        }


        template тестСохрЕсли( псинх мс, T )
        {
            проц тестСохрЕсли( T знач = T.init + 1)
            {
                T          основа;
                Атомный!(T) atom;

                assert( atom.m_val == основа );
                основа = знач;
                atom.сохраниЕсли!(мс)( основа, знач );
                assert( atom.m_val != основа );
                atom.сохраниЕсли!(мс)( основа, T.init );
                assert( atom.m_val == основа );
            }
        }


        template тестИнкремент( псинх мс, T )
        {
            проц тестИнкремент( T знач = T.init + 1)
            {
                T          основа = знач;
                T          инкр = знач;
                Атомный!(T) atom;

                atom.m_val = знач;
                assert( atom.m_val == основа && инкр == основа );
                основа = cast(T)( основа + 1 );
                инкр = atom.инкремент!(мс)();
                assert( atom.m_val == основа && инкр == основа );
            }
        }


        template тестДекремент( псинх мс, T )
        {
            проц тестДекремент( T знач = T.init + 1)
            {
                T          основа = знач;
                T          декр = знач;
                Атомный!(T) atom;

                atom.m_val = знач;
                assert( atom.m_val == основа && декр == основа );
                основа = cast(T)( основа - 1 );
                декр = atom.декремент!(мс)();
                assert( atom.m_val == основа && декр == основа );
            }
        }


        template тестТип( T )
        {
            проц тестТип( T знач = T.init + 1)
            {
                тестЗагр!(псинх.необр, T)( знач );
                тестЗагр!(псинх.hlb, T)( знач );
                тестЗагр!(псинх.acq, T)( знач );
                тестЗагр!(псинх.пследвтн, T)( знач );

                тестСохр!(псинх.необр, T)( знач );
                тестСохр!(псинх.ssb, T)( знач );
                тестСохр!(псинх.acq, T)( знач );
                тестСохр!(псинх.относитн, T)( знач );
                тестСохр!(псинх.пследвтн, T)( знач );

                тестСохрЕсли!(псинх.необр, T)( знач );
                тестСохрЕсли!(псинх.ssb, T)( знач );
                тестСохрЕсли!(псинх.acq, T)( знач );
                тестСохрЕсли!(псинх.относитн, T)( знач );
                тестСохрЕсли!(псинх.пследвтн, T)( знач );

                static if( реальноЧисловойТип_ли!(T) )
                {
                    тестИнкремент!(псинх.необр, T)( знач );
                    тестИнкремент!(псинх.ssb, T)( знач );
                    тестИнкремент!(псинх.acq, T)( знач );
                    тестИнкремент!(псинх.относитн, T)( знач );
                    тестИнкремент!(псинх.пследвтн, T)( знач );

                    тестДекремент!(псинх.необр, T)( знач );
                    тестДекремент!(псинх.ssb, T)( знач );
                    тестДекремент!(псинх.acq, T)( знач );
                    тестДекремент!(псинх.относитн, T)( знач );
                    тестДекремент!(псинх.пследвтн, T)( знач );
                }
            }
        }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Unit Tests
////////////////////////////////////////////////////////////////////////////////


debug( UnitTest )
{
    unittest
    {
        тестТип!(бул)();

        тестТип!(байт)();
        тестТип!(ббайт)();

        тестТип!(крат)();
        тестТип!(бкрат)();

        тестТип!(цел)();
        тестТип!(бцел)();

        version( Has64BitOps )
        {
            тестТип!(дол)();
            тестТип!(бдол)();
        }
        else version( Has64BitCAS )
        {
            тестСохрЕсли!(псинх.необр, дол)();
            тестСохрЕсли!(псинх.ssb, дол)();
            тестСохрЕсли!(псинх.acq, дол)();
            тестСохрЕсли!(псинх.относитн, дол)();
            тестСохрЕсли!(псинх.пследвтн, дол)();

            тестСохрЕсли!(псинх.необр, бдол)();
            тестСохрЕсли!(псинх.ssb, бдол)();
            тестСохрЕсли!(псинх.acq, бдол)();
            тестСохрЕсли!(псинх.относитн, бдол)();
            тестСохрЕсли!(псинх.пследвтн, бдол)();
        }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Unit Tests
////////////////////////////////////////////////////////////////////////////////


debug(Atom)
{
        проц main()
        {
                Атомный!(цел) i;

                i.сохрани (1);
                i.инкремент;
                i.декремент;
                auto x = i.загрузи;
                i.сохрани (2);

                x = атомнаяЗагрузка (x);
        }
}

