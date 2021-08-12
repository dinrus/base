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
module rt.core.pos.sys.sys.time;

private import rt.core.pos.sys.config;
public import rt.core.pos.sys.sys.types;  // for time_t, suseconds_t
public import rt.core.pos.sys.sys.select; // for fd_set, FD_CLR() FD_ISSET() FD_SET() FD_ZERO() FD_SETSIZE, select()

extern  (C):

//
// XOpen (XSI)
//
/*
struct timeval
{
    time_t      tv_sec;
    suseconds_t tv_usec;
}

struct itimerval
{
    timeval it_interval;
    timeval it_value;
}

ITIMER_REAL
ITIMER_VIRTUAL
ITIMER_PROF

int getitimer(int, itimerval*);
int gettimeofday(timeval*, void*);
int select(int, fd_set*, fd_set*, fd_set*, timeval*); (defined in rt.core.pos.sys.sys.signal)
int setitimer(int, in itimerval*, itimerval*);
int utimes(in char*, ref  timeval[2]); // LEGACY
*/

version( linux )
{
    struct timeval
    {
        time_t      tv_sec;
        suseconds_t tv_usec;
    }

    struct itimerval
    {
        timeval it_interval;
        timeval it_value;
    }

    const ITIMER_REAL    = 0;
    const ITIMER_VIRTUAL = 1;
    const ITIMER_PROF    = 2;

    int getitimer(int, itimerval*);
    int gettimeofday(timeval*, void*);
    int setitimer(int, in itimerval*, itimerval*);
    int utimes(in char*, ref  timeval[2]); // LEGACY
}
else version( OSX )
{
    struct timeval
    {
        time_t      tv_sec;
        suseconds_t tv_usec;
    }

    struct itimerval
    {
        timeval it_interval;
        timeval it_value;
    }

    // non-standard
    struct timezone_t
    {
        int tz_minuteswest;
        int tz_dsttime;
    }

    int getitimer(int, itimerval*);
    int gettimeofday(timeval*, timezone_t*); // timezone_t* is normally void*
    int setitimer(int, in itimerval*, itimerval*);
    int utimes(in char*, ref  timeval[2]);
}
else version( FreeBSD )
{
    struct timeval
    {
        time_t      tv_sec;
        suseconds_t tv_usec;
    }

    struct itimerval
    {
        timeval it_interval;
        timeval it_value;
    }

    // non-standard
    struct timezone_t
    {
        int tz_minuteswest;
        int tz_dsttime;
    }

    int getitimer(int, itimerval*);
    int gettimeofday(timeval*, timezone_t*); // timezone_t* is normally void*
    int setitimer(int, in itimerval*, itimerval*);
    int utimes(in char*, ref  timeval[2]);
}
