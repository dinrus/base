﻿/**
 * Part of the D programming language runtime library.
 */

/*
 *  Copyright (C) 2004-2008 by Digital Mars, www.digitalmars.com
 *  Written by Walter Bright
 *
 *  This software is provided 'as-is', without any express or implied
 *  warranty. In no event will the authors be held liable for any damages
 *  arising from the use of this software.
 *
 *  Permission is granted to anyone to use this software for any purpose,
 *  including commercial applications, and to alter it and redistribute it
 *  freely, subject to the following restrictions:
 *
 *  o  The origin of this software must not be misrepresented; you must not
 *     claim that you wrote the original software. If you use this software
 *     in a product, an acknowledgment in the product documentation would be
 *     appreciated but is not required.
 *  o  Altered source versions must be plainly marked as such, and must not
 *     be misrepresented as being the original software.
 *  o  This notice may not be removed or altered from any source
 *     distribution.
 */


// Storage allocation

module std.gc;

//debug = PRINTF;

public import std.c;
public import rt.gc.gcx;
public import std.exception;
public import gcstats;
public import std.thread;

version=GCCLASS;

version (GCCLASS)
    alias GC gc_t;
else
    alias GC* gc_t;

gc_t _gc;


private int _termCleanupLevel=1;

export extern (D){
 void addRoot(void *p)		      { _gc.addRoot(p); }
 void removeRoot(void *p)	      { _gc.removeRoot(p); }
 void addRange(void *pbot, void *ptop) { _gc.addRange(pbot, ptop); }
 void removeRange(void *pbot)	      { _gc.removeRange(pbot); }
 void fullCollect()		      { _gc.fullCollect(); }
 void fullCollectNoStack()	      { _gc.fullCollectNoStack(); }
 void genCollect()		      { _gc.genCollect(); }
 void minimize()			      { _gc.minimize(); }
 void disable()			      { _gc.disable(); }
 void enable()			      { _gc.enable(); }
 void getStats(out GCStats stats)      { _gc.getStats(stats); }
 void hasPointers(void* p)	      { _gc.hasPointers(p); }
 void hasNoPointers(void* p)	      { _gc.hasNoPointers(p); }
 void setV1_0()			      { _gc.setV1_0(); }
 }
///////////////////////////////////////////////////////////////////
export extern (C) void gc_check(void *p){_gc.check(p);}
export extern (C) void gc_minimize() { _gc.minimize(); }
export extern (C) void gc_addRoot( void* p ){ _gc.addRoot(p); }
export extern (C) void gc_addRange( void* p, size_t sz ){ _gc.addRange(p, sz); }
export extern (C) void gc_removeRoot( void* p ){ _gc.removeRoot(p); }
export extern (C) void gc_removeRange( void* p ){ _gc.removeRange(p); }

alias extern(D) void delegate() ddel;
alias extern(D) void delegate(int, int) dint;
	
export extern (C) void gc_monitor(ddel begin, dint end ){_gc.monitor(begin, end);}
/////////////////////////////////////////////////////////////////////////
 export extern (C)  gc_t newGC()
{
    version (all)
    {	void* p;
	ClassInfo ci = GC.classinfo;

	p = std.c.malloc(ci.init.length);
	(cast(byte*)p)[0 .. ci.init.length] = ci.init[];
	//printf("Returning from newGC all\n");
	return cast(GC)p;
    }
    else
    {
	//printf("Returning from newGC else\n");
	return cast(gc_t)std.c.calloc(1, GC.sizeof);
    }
}

export extern (C) void deleteGC(gc_t gc)
{
    gc.Dtor();
    std.c.free(cast(void*)gc);
}

export extern (C) void gc_printStats(gc_t gc)
{
    GCStats stats;

    //gc.getStats(stats);
    printf("poolsize = x%x, usedsize = x%x, freelistsize = x%x, freeblocks = %d, pageblocks = %d\n",
	stats.poolsize, stats.usedsize, stats.freelistsize, stats.freeblocks, stats.pageblocks);
}

export extern (C)  GCStats gc_stats()
{
    GCStats stats = void;
    _gc.getStats( stats );
    return stats;
}
// for gcosxc.c
export extern (C)  void _d_gc_addrange(void *pbot, void *ptop)
{
    _gc.addRange(pbot, ptop);
}

//for gcosxc.c
export extern (C)  void _d_gc_removerange(void *pbot)
{
    _gc.removeRange(pbot);
}

export void[] malloc(size_t nbytes)
{
    void* p = gc_malloc(nbytes);
    return cast(void[]) p[0 .. nbytes];	
}

export void[] realloc(void* p, size_t nbytes)
{
    void* q = _gc.realloc(p, nbytes);
    return cast(void[]) q[0 .. nbytes];
}

export size_t extend(void* p, size_t minbytes, size_t maxbytes)
{
    return _gc.extend(p, minbytes, maxbytes);
}

export size_t capacity(void* p)
{
    return _gc.capacity(p);
}

export extern (C) size_t gc_capacity(void* p)
{
    return _gc.capacity(p);
}

export extern (C) void setTypeInfo(TypeInfo ti, void* p)
{
    if (ti.flags() & 1)
	hasNoPointers(p);
    else
	hasPointers(p);
}

export extern (C) void* getGCHandle()
{
    return cast(void*)_gc;
}

export extern (C) void setGCHandle(void* p)
{
    void* oldp = getGCHandle();
    gc_t g = cast(gc_t)p;
    if (g.gcversion != rt.gc.gcx.GCVERSION)
	throw new Error("incompatible gc versions");

    // Add our static data to the new gc
    GC.scanStaticData(g);

    _gc = g;
//    return oldp;
}

export extern (C) void endGCHandle()
{
    GC.unscanStaticData(_gc);
}




export extern (C) 	void _d_monitorrelease(Object h);

	version(OSX)
	{
	export extern (C) 	void _d_osx_image_init();
	}

export extern (C) void thread_init();

export extern (C) void gc_init()
{
    version (GCCLASS)
    {   void* p;
        ClassInfo ci = GC.classinfo;

        p = rt.core.stdc.stdlib.malloc(ci.init.length);
        (cast(byte*)p)[0 .. ci.init.length] = ci.init[];
        _gc = cast(GC)p;
    }
    else
    {
        _gc = cast(GC*) rt.core.stdc.stdlib.calloc(1, GC.sizeof);
    }
    _gc.initialize();
    version (DigitalMars) version(OSX) {
        _d_osx_image_init();
    }
    // NOTE: The GC must initialize the thread library
    //       before its first collection.
	GC.scanStaticData(_gc);
    std.thread.DThread.thread_init();
	thread_init();
}

export extern (C) void gc_term()
{
    if (_termCleanupLevel<1) {
        // no cleanup
    } else if (_termCleanupLevel==2){
        // a more complete cleanup
        // NOTE: There may be daemons threads still running when this routine is
        //       called.  If so, cleaning memory out from under then is a good
        //       way to make them crash horribly.
        //       Often this probably doesn't matter much since the app is
        //       supposed to be shutting down anyway, but for example tests might
        //       crash (and be considerd failed even if the test was ok).
        //       thus this is not the default and should be enabled by 
        //       I'm disabling cleanup for now until I can think about it some
        //       more.
        //
        _gc.fullCollectNoStack(); // not really a 'collect all' -- still scans
                                  // static data area, roots, and ranges.
        _gc.Dtor();
    } else {
        // default (safe) clenup
        _gc.fullCollect(); 
    }
}

export extern (C)   Object _d_newclass(ClassInfo ci);

export extern (C)	void _d_delinterface(void** p);

export extern (C)  void _d_delclass(Object *p);

/******************************************
 * Allocate a new array of length elements.
 * ti is the type of the resulting array, or pointer to element.
 */

export extern (C) ulong _d_newarrayT(TypeInfo ti, size_t length);

export extern (C) ulong _d_newarrayiT(TypeInfo ti, size_t length);

export extern (C) ulong _d_newarraymT(TypeInfo ti, int ndims, ...);

export extern (C) ulong _d_newarraymiT(TypeInfo ti, int ndims, ...);


struct Array
{
    size_t length;
    byte *data;
};

// Perhaps we should get a a size argument like _d_new(), so we
// can zero out the array?

export extern (C) void _d_delarray(Array *p);


export extern (C) void _d_delmemory(void* *p);


export void new_finalizer(void *p, bool dummy)
{
    //printf("new_finalizer(p = %p)\n", p);
    _d_callfinalizer(p);
}

export extern (C) void _d_callinterfacefinalizer(void *p)
{
    //printf("_d_callinterfacefinalizer(p = %p)\n", p);
    if (p)
    {
	Interface *pi = **cast(Interface ***)p;
	Object o = cast(Object)(p - pi.offset);
	_d_callfinalizer(cast(void*)o);
    }
}

export extern (C) void _d_callfinalizer(void *p);


/+ ------------------------------------------------ +/


/******************************
 * Resize dynamic arrays with 0 initializers.
 */

export extern (C)  byte[] _d_arraysetlengthT(TypeInfo ti, size_t newlength, Array *p);

/**
 * Resize arrays for non-zero initializers.
 *	p		pointer to array lvalue to be updated
 *	newlength	new .length property of array
 *	sizeelem	size of each element of array
 *	initsize	size of initializer
 *	...		initializer
 */
export extern (C) byte[] _d_arraysetlengthiT(TypeInfo ti, size_t newlength, Array *p);

/****************************************
 * Append y[] to array x[].
 * size is size of each array element.
 */

export extern (C) long _d_arrayappendT(TypeInfo ti, Array *px, byte[] y);


export extern (C)  size_t gc_newCapacity(size_t newlength, size_t size)
{
    version(none)
    {
	size_t newcap = newlength * size;
    }
    else
    {
	/*
	 * Better version by Dave Fladebo:
	 * This uses an inverse logorithmic algorithm to pre-allocate a bit more
	 * space for larger arrays.
	 * - Arrays smaller than 4096 bytes are left as-is, so for the most
	 * common cases, memory allocation is 1 to 1. The small overhead added
	 * doesn't effect small array perf. (it's virtually the same as
	 * current).
	 * - Larger arrays have some space pre-allocated.
	 * - As the arrays grow, the relative pre-allocated space shrinks.
	 * - The logorithmic algorithm allocates relatively more space for
	 * mid-size arrays, making it very fast for medium arrays (for
	 * mid-to-large arrays, this turns out to be quite a bit faster than the
	 * equivalent realloc() code in C, on Linux at least. Small arrays are
	 * just as fast as GCC).
	 * - Perhaps most importantly, overall memory usage and stress on the GC
	 * is decreased significantly for demanding environments.
	 */
	size_t newcap = newlength * size;
	size_t newext = 0;

	if (newcap > 4096)
	{
	    //double mult2 = 1.0 + (size / log10(pow(newcap * 2.0,2.0)));

	    // Redo above line using only integer math

	    static int log2plus1(size_t c)
	    {   int i;

		if (c == 0)
		    i = -1;
		else
		    for (i = 1; c >>= 1; i++)
			{   }
		return i;
	    }

	    /* The following setting for mult sets how much bigger
	     * the new size will be over what is actually needed.
	     * 100 means the same size, more means proportionally more.
	     * More means faster but more memory consumption.
	     */
	    //long mult = 100 + (1000L * size) / (6 * log2plus1(newcap));
	    long mult = 100 + (1000L * size) / log2plus1(newcap);

	    // testing shows 1.02 for large arrays is about the point of diminishing return
	    if (mult < 102)
		mult = 102;
	    newext = cast(size_t)((newcap * mult) / 100);
	    newext -= newext % size;
	    //printf("mult: %2.2f, mult2: %2.2f, alloc: %2.2f\n",mult/100.0,mult2,newext / cast(double)size);
	}
	newcap = newext > newcap ? newext : newcap;
	//printf("newcap = %d, newlength = %d, size = %d\n", newcap, newlength, size);
    }
    return newcap;
}

export extern (C) byte[] _d_arrayappendcT(TypeInfo ti, inout byte[] x, ...);

/**
 * Append dchar to char[]
 */
export extern (C)  char[] _d_arrayappendcd(inout char[] x, dchar c)
{
    const sizeelem = c.sizeof;            // array element size
    auto cap = _gc.capacity(x.ptr);
    auto length = x.length;

    // c could encode into from 1 to 4 characters
    int nchars;
    if (c <= 0x7F)
        nchars = 1;
    else if (c <= 0x7FF)
        nchars = 2;
    else if (c <= 0xFFFF)
        nchars = 3;
    else if (c <= 0x10FFFF)
        nchars = 4;
    else
	assert(0);	// invalid utf character - should we throw an exception instead?

    auto newlength = length + nchars;
    auto newsize = newlength * sizeelem;

    assert(cap == 0 || length * sizeelem <= cap);

    debug(PRINTF) printf("_d_arrayappendcd(sizeelem = %d, ptr = %p, length = %d, cap = %d)\n", sizeelem, x.ptr, x.length, cap);

    if (cap <= newsize)
    {   byte* newdata;

	if (cap >= 4096)
	{   // Try to extend in-place
	    auto u = _gc.extend(x.ptr, (newsize + 1) - cap, (newsize + 1) - cap);
	    if (u)
	    {
		goto L1;
	    }
	}
        debug(PRINTF) printf("_d_arrayappendcd(length = %d, newlength = %d, cap = %d)\n", length, newlength, cap);
        auto newcap = gc_newCapacity(newlength, sizeelem);
        assert(newcap >= newlength * sizeelem);
        newdata = cast(byte *)_gc.malloc(newcap + 1);
	_gc.hasNoPointers(newdata);
        memcpy(newdata, x.ptr, length * sizeelem);
        (cast(void**)(&x))[1] = newdata;
    }
  L1:
    *cast(size_t *)&x = newlength;
    char* ptr = &x.ptr[length];

    if (c <= 0x7F)
    {
        ptr[0] = cast(char) c;
    }
    else if (c <= 0x7FF)
    {
        ptr[0] = cast(char)(0xC0 | (c >> 6));
        ptr[1] = cast(char)(0x80 | (c & 0x3F));
    }
    else if (c <= 0xFFFF)
    {
        ptr[0] = cast(char)(0xE0 | (c >> 12));
        ptr[1] = cast(char)(0x80 | ((c >> 6) & 0x3F));
        ptr[2] = cast(char)(0x80 | (c & 0x3F));
    }
    else if (c <= 0x10FFFF)
    {
        ptr[0] = cast(char)(0xF0 | (c >> 18));
        ptr[1] = cast(char)(0x80 | ((c >> 12) & 0x3F));
        ptr[2] = cast(char)(0x80 | ((c >> 6) & 0x3F));
        ptr[3] = cast(char)(0x80 | (c & 0x3F));
    }
    else
	assert(0);

    assert((cast(size_t)x.ptr & 15) == 0);
    assert(_gc.capacity(x.ptr) > x.length * sizeelem);
    return x;
}


/**
 * Append dchar to wchar[]
 */
export extern (C)  wchar[] _d_arrayappendwd(inout wchar[] x, dchar c)
{
    const sizeelem = c.sizeof;            // array element size
    auto cap = _gc.capacity(x.ptr);
    auto length = x.length;

    // c could encode into from 1 to 2 w characters
    int nchars;
    if (c <= 0xFFFF)
        nchars = 1;
    else
        nchars = 2;

    auto newlength = length + nchars;
    auto newsize = newlength * sizeelem;

    assert(cap == 0 || length * sizeelem <= cap);

    debug(PRINTF) printf("_d_arrayappendwd(sizeelem = %d, ptr = %p, length = %d, cap = %d)\n", sizeelem, x.ptr, x.length, cap);

    if (cap <= newsize)
    {   byte* newdata;

	if (cap >= 4096)
	{   // Try to extend in-place
	    auto u = _gc.extend(x.ptr, (newsize + 1) - cap, (newsize + 1) - cap);
	    if (u)
	    {
		goto L1;
	    }
	}

        debug(PRINTF) printf("_d_arrayappendwd(length = %d, newlength = %d, cap = %d)\n", length, newlength, cap);
        auto newcap = gc_newCapacity(newlength, sizeelem);
        assert(newcap >= newlength * sizeelem);
        newdata = cast(byte *)_gc.malloc(newcap + 1);
	_gc.hasNoPointers(newdata);
        memcpy(newdata, x.ptr, length * sizeelem);
        (cast(void**)(&x))[1] = newdata;
    }
  L1:
    *cast(size_t *)&x = newlength;
    wchar* ptr = &x.ptr[length];

    if (c <= 0xFFFF)
    {
        ptr[0] = cast(wchar) c;
    }
    else
    {
	ptr[0] = cast(wchar) ((((c - 0x10000) >> 10) & 0x3FF) + 0xD800);
	ptr[1] = cast(wchar) (((c - 0x10000) & 0x3FF) + 0xDC00);
    }

    assert((cast(size_t)x.ptr & 15) == 0);
    assert(_gc.capacity(x.ptr) > x.length * sizeelem);
    return x;
}


export extern (C) byte[] _d_arraycatT(TypeInfo ti, byte[] x, byte[] y);


export extern (C) byte[] _d_arraycatnT(TypeInfo ti, uint n, ...);


export extern (C) void* _d_arrayliteralT(TypeInfo ti, size_t length, ...);


/**********************************
 * Support for array.dup property.
 */

struct Array2
{
    size_t length;
    void* ptr;
}

export extern (C) long _adDupT(TypeInfo ti, Array2 a);


export extern (C) uint gc_getAttr( void* p )
{
    return _gc.getAttr(p);
}

export extern (C) uint gc_setAttr( void* p, uint a )
{
    return _gc.setAttr(p, a);
}

export extern (C) uint gc_clrAttr( void* p, uint a )
{
    return _gc.clrAttr(p, a);
}

export extern (C) void* gc_malloc( size_t sz, uint ba = 0 )
{
   /* void* p = cast(void*)std.c.malloc( sz );

    if( sz && p is null )
        std.exception.onOutOfMemoryError();*/
    return _gc.malloc(sz, ba);//p;
}

export extern (C) void* gc_calloc( size_t sz, uint ba = 0 )
{
    /*void* p = calloc( 1, sz );

    if( sz && p is null )
        std.exception.onOutOfMemoryError();*/
    return _gc.calloc(sz, ba);//p;
}

export extern (C) void* gc_realloc( void* p, size_t sz, uint ba = 0 )
{
   /* p = cast(void*)realloc( p, sz );

    if( sz && p is null )
        std.exception.onOutOfMemoryError();*/
    return _gc.realloc(p, sz, ba);//up;
}

export extern (C) size_t gc_extend( void* p, size_t mx, size_t sz )
{
    return _gc.extend(p, mx, sz);
}

export extern (C) size_t gc_reserve( size_t sz )
{
    return _gc.reserve(sz);
}

export extern (C) void gc_free( void* p )
{
    _gc.free( p );
}

export extern (C) void* gc_addrOf( void* p )
{
    return _gc.addrOf(p);
}

export extern (C) size_t gc_sizeOf( void* p )
{
    return _gc.sizeOf(p);
}

export extern (C) void* gc_weakpointerCreate( Object r )
{
    return _gc.weakpointerCreate(r);//cast(void*)r;
}

export extern (C) void gc_weakpointerDestroy( void* wp )
{
_gc.weakpointerDestroy(wp);
}

export extern (C) Object gc_weakpointerGet( void* wp )
{
    return _gc.weakpointerGet(wp);//cast(Object)wp;
}

export extern (C) BlkInfo gc_query( void* p )
{
return _gc.query(p);
}

export extern (C) void rt_finalize(void* p, bool det = true);

export extern (C) void gc_enable()
{
_gc.enable();
}

export extern (C) void gc_disable()
{
_gc.disable();
}

export extern (C) void gc_collect()
{
_gc.fullCollect();
}

export extern (C) void setFinalizer(void *p, GC_FINALIZER pFn)
{
_gc.setFinalizer(p, pFn);
}

/**
 *
 */
