module wx.Thread;
public import wx.common;

// ----------------------------------------------------------------------------
// constants
// ----------------------------------------------------------------------------

enum ПОшибкаМютекса
{
    wxMUTEX_NO_ERROR = 0,   // operation completed successfully
    wxMUTEX_INVALID,        // mutex hasn't been initialized
    wxMUTEX_DEAD_LOCK,      // mutex is already locked by the calling thread
    wxMUTEX_BUSY,           // mutex is already locked by anдругой thread
    wxMUTEX_UNLOCKED,       // attempt до unlock a mutex который is not locked
    wxMUTEX_MISC_ERROR      // any другой error
}

enum ПОшибкаУсловия
{
    wxCOND_NO_ERROR = 0,
    wxCOND_INVALID,
    wxCOND_TIMEOUT,         // WaitTimeout() есть timed out
    wxCOND_MISC_ERROR
}

enum ПОшибкаСемафора
{
    wxSEMA_NO_ERROR = 0,
    wxSEMA_INVALID,         // semaphore hasn't been initialized successfully
    wxSEMA_BUSY,            // returned by TryWait() if Wait() would block
    wxSEMA_TIMEOUT,         // returned by WaitTimeout()
    wxSEMA_OVERFLOW,        // Post() would increase counter past the макс
    wxSEMA_MISC_ERROR
}

enum ПОшибкаНити
{
    wxTHREAD_NO_ERROR = 0,      // No error
    wxTHREAD_NO_RESOURCE,       // No resource left до create a new thread
    wxTHREAD_RUNNING,           // The thread is already running
    wxTHREAD_NOT_RUNNING,       // The thread isn't running
    wxTHREAD_KILLED,            // Нить we waited for had до be killed
    wxTHREAD_MISC_ERROR         // Some другой error
}

enum ПВидНити
{
    wxTHREAD_DETACHED,
    wxTHREAD_JOINABLE
}

// defines the interval of priority
enum
{
    WXTHREAD_MIN_PRIORITY      = 0u,
    WXTHREAD_Дефолт_PRIORITY  = 50u,
    WXTHREAD_MAX_PRIORITY      = 100u
}

// There are 2 types of mutexes: normal mutexes and recursive ones. The attempt
// до lock a normal mutex by a thread который already owns it results in
// undefined behaviour (it always works under Windows, it will almost always
// рез in a deadlock under Unix). Locking a recursive mutex in such
// situation always succeeds and it must be unlocked as many times as it есть
// been locked.
//
// However recursive mutexes have several important drawbacks: first, in the
// POSIX implementation, they're less efficient. секунда, and more importantly,
// they CAN NOT BE USED WITH CONDITION VARIABLES under Unix! Using them with
// Условие will work under Windows and some Unices (notably Linux) кноп will
// deadlock under другой Unix versions (e.з. Solaris). As it might be difficult
// до ensure that a recursive mutex is not used with Условие, it is a good
// idea до avoid using recursive mutexes at all. Also, the last problem with
// them is that some (older) Unix versions don't support this at all -- который
// results in a configure warning when building and a deadlock when using them.
enum ПтипМютекса
{
    // normal mutex: try до always use this one
    Дефолт,

    // recursive mutex: don't use these ones with Условие
    Рекурсивный
}

//-----------------------------------------------------------------------------

//! A mutex object is a synchronization object whose состояние is set до signaled
//! when it is not owned by any thread, and nonsignaled when it is owned. Its
//! имя comes от its usefulness in coordinating mutually-exclusive access до
//! a shared resource. Only one thread at a time can own a mutex object.
extern(D) class Мютекс : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    public бул Ок();
    ~this();
}

extern(D) class БлокировщикМютекса : ВизОбъект
{
    public this(ЦелУкз вхобъ);
}

//-----------------------------------------------------------------------------

//! Critical section: this is the same as mutex кноп is only видим до the
//! threads of the same process. For the platforms который don't have native
//! support for critical sections, they're implemented entirely in terms of
//! mutexes.
extern(D) class КритическаяСекция : ВизОбъект
{
    public this(ЦелУкз вхобъ);
    public проц войди();
    public проц покинь();
    ~this();
}

extern(D) class БлокировщикКритическойСекции : ВизОбъект
{
    public this(ЦелУкз вхобъ);
}

//-----------------------------------------------------------------------------

//! Условие models a POSIX условие variable который allows one (or more)
//! thread(т) до wait until some условие is fulfilled
extern(D) class Условие : ВизОбъект
{
    public this(ЦелУкз вхобъ);
}

//-----------------------------------------------------------------------------

//! Семафор: a counter limiting the число of threads concurrently accessing
//!              a shared resource
extern(D) class Семафор : ВизОбъект
{
    public this(ЦелУкз вхобъ);
}

//-----------------------------------------------------------------------------

//! Нить: class encapsulating a thread of execution
extern(D) class Нить : ВизОбъект
{
    public this(ЦелУкз вхобъ);
}

extern(D) class ВспомогательнаяНить : ВизОбъект
{
    public this(ЦелУкз вхобъ);
}

//! ПомощникНити: this class implements the threading logic до run a
//! заднийПлан task in anдругой object (such as a окно).  It is a mix-in: just
//! derive от it до implement a threading заднийПлан task in your class.
extern(D) class ПомощникНити : ВизОбъект
{
    public this(ЦелУкз вхобъ);
}

