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
module rt.core.pos.sys.config;

public import rt.core.stdc.config;

extern  (C):

version( linux )
{
    const bool  __USE_LARGEFILE64    = true;
    const bool  __USE_FILE_OFFSET64  = __USE_LARGEFILE64;
    const bool  __REDIRECT           = false;
}
