﻿/**
 * Нить Local Storage для DigitalMars D.
 * Модуль дает простой обмотчик для системно-специфичных средств (thread local storage)
 * локального сохранения в потоке.
 *
 * Authors: Mikola Lysenko, (mclysenk@mtu.edu)
 * License: Public Domain (100% free)
 * Дата: 9-11-2006
 * Version: 0.3
 *
 * History:
 *  v0.3 - Fixed some clean up bugs и added fallback код for other platforms.
 *
 *  v0.2 - Merged with stackthreads.
 *
 *  v0.1 - Initial release.
 *
 * Bugs:
 *  On non-windows & non-posix systems, the implementation uses a synchronized
 *  блок which may negatively impact performance.
 *
 *  Локальное хранилище потока на Windows имеет неверную сборку мусора. Это же
 *  на Posix и в других средах не имеет проблем.
 *
 * Пример:
 * <код><pre>
 * //Создать счетчик, исходно установленный на 5
 * auto tls_counter = new НитеЛок!(цел)(5);
 * 
 * //Создать поток
 * Нить t = new Нить(
 * {
 *   //Просто уменьшать счётчик до достижения 0.
 *   while(tls_counter.знач > 0)
 *   {
 *       скажифнс("Countdown ... %d", tls_counter.знач);
 *       tls_counter.знач = tls_counter.знач - 1;
 *   }
 *   скажифнс("Blast off!");
 *   return 0;
 * });
 *
 * //
 * // Смешать со счетчиком
 * //
 * assert(tls_counter.знач == 5);
 * tls_counter.знач = 20;
 * //
 * // Вызвать данную нить
 * //
 * t.start();
 * t.wait();
 * //
 * // В ходе работы будет выведено:
 * //
 * //  Countdown ... 5
 * //  Countdown ... 4
 * //  Countdown ... 3
 * //  Countdown ... 2
 * //  Countdown ... 1
 * //  Blast off!
 * //
 * // По выполнение нитью работы счётчик остается нетронутым
 * //
 * assert(tls_counter.знач == 20);
 * </pre></код>
 */
module st.tls;

private import stdrus, thread;

/**
 * Исключение НитеЛокИскл генерируется в случае,
 * если во время выполнения (в рантайм) не удается
 * правильно обработать локальное поточное действие.
 */
class НитеЛокИскл : Исключение
{
    this(ткст сооб) { super(сооб); }
}

version(linux)
    version = TLS_UsePthreads;
version(darwin)
    version = TLS_UsePthreads;
version(Win32)
    version = TLS_UseWinAPI;


version(TLS_UsePthreads)
{
private import gc;

private extern(C)
{
    typedef бцел pthread_key_t;
    
    цел pthread_key_delete(pthread_key_t);
    цел pthread_key_create(pthread_key_t*, проц function(ук));
    цел pthread_setspecific(pthread_key_t, ук);
    укpthread_getspecific(pthread_key_t);
    
    const цел EAGAIN = 11;
    const цел ENOMEM = 12;
    const цел EINVAL = 22;
}

/**
 * Нить Local Storage (Локальное Хранилище Потока) - это механизм
 * для ассоциации переменных с определенными потоками.
 * This can be использован to ensure the principle of confinement, и is
 * useful for many sorts of algorithms.
 */
public class НитеЛок(T)
{
    /**
     * Allocates the thread local storage.
     *
     * Параметры:
     *  def = An optional default value for the thread local storage.
     *
     * Выводит исключение:
     *  A НитеЛокИскл if the system could not allocate the storage.
     */
    public this(T def = T.init)
    {
        this.def = def;
        
        switch(pthread_key_create(&ключ_нлх, &clean_up))
        {
            case 0: break; //Success
            
            case EAGAIN: throw new НитеЛокИскл
                ("Вне диапазона ключей для НЛХ");
            
            case ENOMEM: throw new НитеЛокИскл
                ("Вне диапазона памяти для НЛХ");
            
            default: throw new НитеЛокИскл
                ("Неизвестная ошибка при создании НЛХ");
        }
        
        debug (НитеЛок) скажифнс("НЛХ: Создано %s", вТкст);
    }
    
    /**
     * Deallocates the thread local storage.
     */
    public ~this()
    {
        debug (НитеЛок) скажифнс("НЛХ: Удаляется %s", вТкст);
        pthread_key_delete(ключ_нлх);
    }
    
    /**
     * Возвращает: The текущ value of the thread local storage.
     */
    public T знач()
    {
        debug (НитеЛок) скажифнс("НЛХ: Доступ к %s", вТкст);
        
        TWrapper * w = cast(TWrapper*)pthread_getspecific(ключ_нлх);
        
        if(w is пусто)
        {
            debug(НитеЛок) скажифнс("НЛХ: Не найдено");
            return def;
        }
        
        debug(НитеЛок) скажифнс("НЛХ: Обнаружено %s", w);
        
        return w.знач;
    }
    
    /**
     * Sets the thread local storage.  Can be использован with property syntax.
     *
     * Параметры:
     *  nv = The new value of the thread local storage.
     *
     * Возвращает:
     *  nv upon success
     *
     * Выводит исключение:
     *  НитеЛокИскл if the system could not установи the НитеЛокStorage.
     */
    public T знач(T nv)
    {
        debug (НитеЛок) скажифнс("НЛХ: Устанавливается %s", вТкст);
        
        ук w_old = pthread_getspecific(ключ_нлх);
        
        if(w_old !is пусто)
        {
            (cast(TWrapper*)w_old).знач = nv;
        }
        else
        {
            switch(pthread_setspecific(ключ_нлх, TWrapper(nv)))
            {
                case 0: break;
                    
                case ENOMEM: throw new НитеЛокИскл
                    ("Недостаток памяти для установки нового НЛХ");
                
                case EINVAL: throw new НитеЛокИскл
                    ("Неверное НЛХ");
                
                default: throw new НитеЛокИскл
                    ("Неизвестная ошибка при кстановке НЛХ");
            }
        }
        
        debug(НитеЛок) скажифнс("НЛХ: Установка %s", вТкст);
        return nv;
    }
    
    /**
     * Converts the thread local storage into a stringified representation.
     * Can be useful for debugging.
     * 
     * Возвращает:
     *  A string representing the thread local storage.
     */
    public ткст вТкст()
    {
        return фм("НитеЛок[%8x]", ключ_нлх);
    }

    
    // Clean up thread local resources
    private extern(C) static проц clean_up(ук объ)
    {
        if(объ is пусто)
            return;
        
        смУдалиКорень(объ);
        delete объ;
    }
    
    // The wrapper manages the thread local attributes`
    private struct TWrapper
    {
        T знач;
        
        static ук opCall(T nv)
        {
            TWrapper * res = new TWrapper;
            смДобавьКорень(cast(ук)res);
            res.знач = nv;
            return cast(ук)res;
        }
    }
    
    private pthread_key_t ключ_нлх;
    private T def;
}

} else version(TLS_UseWinAPI) {

private import gc;
    
private extern(Windows)
{
    бцел TlsAlloc();
    бул TlsFree(бцел);
    бул TlsSetValue(бцел, ук);
    ук TlsGetValue(бцел);
}

public class НитеЛок(T)
{
    public this(T def = T.init)
    {
        this.def = def;
        this.ключ_нлх = TlsAlloc();
    }
    
    public ~this()
    {
        TlsFree(ключ_нлх);
    }
    
    public T знач()
    {
        ук v = TlsGetValue(ключ_нлх);
        
        if(v is пусто)
            return def;
        
        return (cast(TWrapper*)v).знач;
    }
    
    public T знач(T nv)
    {
        TWrapper * w_old = cast(TWrapper*)TlsGetValue(ключ_нлх);
        
        if(w_old is пусто)
        {
            TlsSetValue(ключ_нлх, TWrapper(nv));
        }
        else
        {
            w_old.знач = nv;
        }
        
        return nv;
    }
    
    private бцел ключ_нлх;
    private T def;
        
    private struct TWrapper
    {
        T знач;
        
        static ук opCall(T nv)
        {
            TWrapper * res = new TWrapper;
            смДобавьКорень(cast(ук)res);
            res.знач = nv;
            return cast(ук)res;
        }
    }
}

} else {

//Use a terrible hack insteaauxd...
//Performance will be bad, but at least we can fake the result.
public class НитеЛок(T)
{
    public this(T def = T.init)
    {
        this.def = def;
    }
    
    public T знач()
    {
        synchronized(this)
        {
            Нить t = Нить.дайЭту;
            
            if(t in tls_map)
                return tls_map[t];
            return def;
        }
    }
    
    public T знач(T nv)
    {
        synchronized(this)
        {
            return tls_map[Нить.дайЭту] = nv;
        }
    }
    
    private T def;
    private T[Нить] tls_map;
}
    
}

unittest
{
    //Attempt to test out the tls
    auto tls = new НитеЛок!(цел);
    
    //Make sure default значения work
    assert(tls.знач == 0);
    
    //Init tls to something
    tls.знач = 333;
    
    //Созд some threads to mess with the tls
    Нить a = new Нить(
    {
        tls.знач = 10;
        Нить.жни;
        assert(tls.знач == 10);
        
        tls.знач = 1010;
        Нить.жни;
        assert(tls.знач == 1010);
        
        return 0;
    });
    
    Нить b = new Нить(
    {
        tls.знач = 20;
        Нить.жни;
        assert(tls.знач == 20);
        
        tls.знач = 2020;
        Нить.жни;
        assert(tls.знач == 2020);
        
        return 0;
    });
    
    a.start;
    b.start;
    
    //Wait until they have have finished
    a.wait;
    b.wait;
    
    //Make sure the value was preserved
    assert(tls.знач == 333);
    
    //Try out structs
    struct TestStruct
    {
        цел x = 10;
        real r = 20.0;
        byte b = 3;
    }
    
    auto tls2 = new НитеЛок!(TestStruct);
    
    assert(tls2.знач.x == 10);
    assert(tls2.знач.r == 20.0);
    assert(tls2.знач.b == 3);
    
    Нить x = new Нить(
    {
        assert(tls2.знач.x == 10);
        
        TestStruct nv;
        nv.x = 20;
        tls2.знач = nv;
        
        assert(tls2.знач.x == 20);
        
        return 0;
    });
    
    x.start();
    x.wait();
    
    assert(tls2.знач.x == 10);
    
    //Try out objects
    static class TestClass
    {
        цел x = 10;
    }
    
    auto tls3 = new НитеЛок!(TestClass)(new TestClass);
    
    assert(tls3.знач.x == 10);
    
    Нить y = new Нить(
    {
        tls3.знач.x ++;
        
        tls3.знач = new TestClass;
        tls3.знач.x = 2020;
        
        assert(tls3.знач.x == 2020);
        
        return 0;
    });
    
    y.start;
    y.wait;
    
    assert(tls3.знач.x == 11);
}
