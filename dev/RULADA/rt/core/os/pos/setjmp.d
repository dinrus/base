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
module rt.core.pos.sys.setjmp;

private import rt.core.pos.sys.config;
private import rt.core.pos.sys.signal; // for sigset_t

extern  (C):

//
// Required
//
/*
jmp_buf

int  setjmp(ref  jmp_buf);
void longjmp(ref  jmp_buf, int);
*/

version( linux )
{
    version( X86_64 )
    {
        //const JB_BX      = 0;
        //const JB_BP      = 1;
        //const JB_12      = 2;
        //const JB_13      = 3;
        //const JB_14      = 4;
        //const JB_15      = 5;
        //const JB_SP      = 6;
        //const JB_PC      = 7;
        //const JB_SIZE    = 64;

        alias long[8] __jmp_buf;
    }
    else version( X86 )
    {
        //const JB_BX      = 0;
        //const JB_SI      = 1;
        //const JB_DI      = 2;
        //const JB_BP      = 3;
        //const JB_SP      = 4;
        //const JB_PC      = 5;
        //const JB_SIZE    = 24;

        alias int[6] __jmp_buf;
    }
    else version ( SPARC )
    {
        alias int[3] __jmp_buf;
    }

    struct __jmp_buf_tag
    {
        __jmp_buf   __jmpbuf;
        int         __mask_was_saved;
        sigset_t    __saved_mask;
    }

    alias __jmp_buf_tag[1] jmp_buf;

    alias _setjmp setjmp; // see XOpen block
    void longjmp(ref  jmp_buf, int);
}
else version( FreeBSD )
{
    // <machine/setjmp.h>
    version( X86 )
    {
        const _JBLEN = 11;
        struct _jmp_buf { int[_JBLEN + 1] _jb; }
    }
    else version( X86_64)
    {
        const _JBLEN = 12;
        struct _jmp_buf { c_long[_JBLEN] _jb; }
    }
    else version( SPARC )
    {
        const _JBLEN = 5;
        struct _jmp_buf { c_long[_JBLEN + 1] _jb; }
    }
    else
        static assert(0);
    alias _jmp_buf[1] jmp_buf;

    int  setjmp(ref  jmp_buf);
    void longjmp(ref  jmp_buf, int);
}

//
// C Extension (CX)
//
/*
sigjmp_buf

int  sigsetjmp(sigjmp_buf, int);
void siglongjmp(sigjmp_buf, int);
*/

version( linux )
{
    alias jmp_buf sigjmp_buf;

    int __sigsetjmp(sigjmp_buf, int);
    alias __sigsetjmp sigsetjmp;
    void siglongjmp(sigjmp_buf, int);
}
else version( FreeBSD )
{
    // <machine/setjmp.h>
    version( X86 )
    {
        struct _sigjmp_buf { int[_JBLEN + 1] _ssjb; }
    }
    else version( X86_64)
    {
        struct _sigjmp_buf { c_long[_JBLEN] _sjb; }
    }
    else version( SPARC )
    {
        const _JBLEN         = 5;
        const _JB_FP         = 0;
        const _JB_PC         = 1;
        const _JB_SP         = 2;
        const _JB_SIGMASK    = 3;
        const _JB_SIGFLAG    = 5;
        struct _sigjmp_buf { c_long[_JBLEN + 1] _sjb; }
    }
    else
        static assert(0);
    alias _sigjmp_buf[1] sigjmp_buf;

    int  sigsetjmp(ref  sigjmp_buf);
    void siglongjmp(ref  sigjmp_buf, int);
}

//
// XOpen (XSI)
//
/*
int  _setjmp(jmp_buf);
void _longjmp(jmp_buf, int);
*/

version( linux )
{
    int  _setjmp(ref  jmp_buf);
    void _longjmp(ref  jmp_buf, int);
}
else version( FreeBSD )
{
    int  _setjmp(ref  jmp_buf);
    void _longjmp(ref  jmp_buf, int);
}
