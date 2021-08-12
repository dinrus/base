module gtkD.gthread.RWLock;

public  import gtkD.gtkc.gthreadtypes;

private import gtkD.gtkc.gthread;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * Threads act almost like processes, but unlike processes all threads of
 * one process share the same memory. This is good, as it provides easy
 * communication between the involved threads via this shared memory, and
 * it is bad, because strange things (so called "Heisenbugs") might
 * happen if the program is not carefully designed. In particular, due to
 * the concurrent nature of threads, no assumptions on the order of
 * execution of code running in different threads can be made, unless
 * order is explicitly forced by the programmer through synchronization
 * primitives.
 * The aim of the thread related functions in GLib is to provide a
 * portable means for writing multi-threaded software. There are
 * primitives for mutexes to protect the access to portions of memory
 * (GMutex, GStaticMutex, G_LOCK_DEFINE, GStaticRecMutex and
 * GStaticRWLock). There are primitives for condition variables to allow
 * synchronization of threads (GCond). There are primitives
 * for thread-private data - data that every thread has a private instance of
 * (GPrivate, GStaticPrivate). Last but definitely not least there are
 * primitives to portably create and manage threads (GThread).
 * You must call g_thread_init() before executing any other GLib
 * functions (except g_mem_set_vtable()) in a GLib program if
 * g_thread_init() will be called at all. This is a requirement even if
 * no threads are in fact ever created by the process. It is enough that
 * g_thread_init() is called. If other GLib functions have been called
 * before that, the behaviour of the program is undefined. An exception
 * is g_mem_set_vtable() which may be called before g_thread_init().
 * Failing this requirement can lead to hangs or crashes, apparently more
 * easily on Windows than on Linux, for example.
 * Please note that if you call functions in some GLib-using library, in
 * particular those above the GTK+ stack, that library might well call
 * g_thread_init() itself, or call some other library that calls
 * g_thread_init(). Thus, if you use some GLib-based library that is
 * above the GTK+ stack, it is safest to call g_thread_init() in your
 * application's main() before calling any GLib functions or functions in
 * GLib-using libraries.
 * After calling g_thread_init(), GLib is completely
 * thread safe (all global data is automatically locked), but individual
 * data structure instances are not automatically locked for performance
 * reasons. So, for example you must coordinate accesses to the same
 * GHashTable from multiple threads. The two notable exceptions from
 * this rule are GMainLoop and GAsyncQueue,
 * which are threadsafe and needs no further
 * application-level locking to be accessed from multiple threads.
 * To help debugging problems in multithreaded applications, GLib supports
 * error-checking mutexes that will give you helpful error messages on
 * common problems. To use error-checking mutexes, define the symbol
 * G_ERRORCHECK_MUTEXES when compiling the application.
 */
public class RWLock
{
	
	/** the main Gtk struct */
	protected GStaticRWLock* gStaticRWLock;
	
	
	public GStaticRWLock* getRWLockStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GStaticRWLock* gStaticRWLock);
	
	/**
	 * Creates a new initialized RWLock.
	 */
	public this ();
	
	/**
	 */
	
	/**
	 * A GStaticRWLock must be initialized with this function before it can
	 * be used. Alternatively you can initialize it with
	 * G_STATIC_RW_LOCK_INIT.
	 */
	public void init();
	
	/**
	 * Locks lock for reading. There may be unlimited concurrent locks for
	 * reading of a GStaticRWLock at the same time. If lock is already
	 * locked for writing by another thread or if another thread is already
	 * waiting to lock lock for writing, this function will block until
	 * lock is unlocked by the other writing thread and no other writing
	 * threads want to lock lock. This lock has to be unlocked by
	 * g_static_rw_lock_reader_unlock().
	 * GStaticRWLock is not recursive. It might seem to be possible to
	 * recursively lock for reading, but that can result in a deadlock, due
	 * to writer preference.
	 */
	public void readerLock();
	
	/**
	 * Tries to lock lock for reading. If lock is already locked for
	 * writing by another thread or if another thread is already waiting to
	 * lock lock for writing, immediately returns FALSE. Otherwise locks
	 * lock for reading and returns TRUE. This lock has to be unlocked by
	 * g_static_rw_lock_reader_unlock().
	 * Params:
	 * lock = a GStaticRWLock to lock for reading.
	 * Returns:%TRUE, if lock could be locked for reading.
	 */
	public int readerTrylock();

	/**
	 * Unlocks lock. If a thread waits to lock lock for writing and all
	 * locks for reading have been unlocked, the waiting thread is woken up
	 * and can lock lock for writing.
	 * Params:
	 * lock = a GStaticRWLock to unlock after reading.
	 */
	public void readerUnlock();
	
	/**
	 * Locks lock for writing. If lock is already locked for writing or
	 * reading by other threads, this function will block until lock is
	 * completely unlocked and then lock lock for writing. While this
	 * functions waits to lock lock, no other thread can lock lock for
	 * reading. When lock is locked for writing, no other thread can lock
	 * lock (neither for reading nor writing). This lock has to be unlocked
	 * by g_static_rw_lock_writer_unlock().
	 */
	public void writerLock();
	
	/**
	 * Tries to lock lock for writing. If lock is already locked (for
	 * either reading or writing) by another thread, it immediately returns
	 * FALSE. Otherwise it locks lock for writing and returns TRUE. This
	 * lock has to be unlocked by g_static_rw_lock_writer_unlock().
	 * Params:
	 * lock = a GStaticRWLock to lock for writing.
	 * Returns:%TRUE, if lock could be locked for writing.
	 */
	public int writerTrylock();
	
	/**
	 * Unlocks lock. If a thread is waiting to lock lock for writing and
	 * all locks for reading have been unlocked, the waiting thread is woken
	 * up and can lock lock for writing. If no thread is waiting to lock
	 * lock for writing, and some thread or threads are waiting to lock lock
	 * for reading, the waiting threads are woken up and can lock lock for
	 * reading.
	 * Params:
	 * lock = a GStaticRWLock to unlock after writing.
	 */
	public void writerUnlock();
	
	/**
	 * Releases all resources allocated to lock.
	 * You don't have to call this functions for a GStaticRWLock with an
	 * unbounded lifetime, i.e. objects declared 'static', but if you have a
	 * GStaticRWLock as a member of a structure, and the structure is freed,
	 * you should also free the GStaticRWLock.
	 */
	public void free();
}
