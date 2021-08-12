/**
 * D header file for POSIX.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
 * Authors:   Sean Kelly
 * Standards: The Open Group Base Specifications Issue 6, IEEE Std 1003.1, 2004 Edition
 *
 *          Copyright Sean Kelly 2005 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module rt.core.pos.sys.dlfcn;

private import rt.core.pos.sys.config;

extern  (C):

//
// XOpen (XSI)
//
/*
RTLD_LAZY
RTLD_NOW
RTLD_GLOBAL
RTLD_LOCAL

int   dlclose(void*);
char* dlerror();
void* dlopen(in char*, int);
void* dlsym(void*, in char*);
*/

version( linux )
{
    const RTLD_LAZY      = 0x00001;
    const RTLD_NOW       = 0x00002;
    const RTLD_GLOBAL    = 0x00100;
    const RTLD_LOCAL     = 0x00000;

    int   dlclose(void*);
    char* dlerror();
    void* dlopen(in char*, int);
    void* dlsym(void*, in char*);
}
else version( OSX )
{
    const RTLD_LAZY      = 0x00001;
    const RTLD_NOW       = 0x00002;
    const RTLD_GLOBAL    = 0x00100;
    const RTLD_LOCAL     = 0x00000;

    int   dlclose(void*);
    char* dlerror();
    void* dlopen(in char*, int);
    void* dlsym(void*, in char*);
}
else version( FreeBSD )
{
    const RTLD_LAZY      = 1;
    const RTLD_NOW       = 2;
    const RTLD_GLOBAL    = 0x100;
    const RTLD_LOCAL     = 0;

    int   dlclose(void*);
    char* dlerror();
    void* dlopen(in char*, int);
    void* dlsym(void*, in char*);
}
