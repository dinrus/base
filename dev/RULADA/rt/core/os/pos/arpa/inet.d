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
module rt.core.pos.sys.arpa.inet;

private import rt.core.pos.sys.config;
public import rt.core.stdc.inttypes; // for uint32_t, uint16_t
public import rt.core.pos.sys.sys.socket; // for socklen_t

extern  (C):

//
// Required
//
/*
in_port_t // from rt.core.pos.sys.netinet.in_
in_addr_t // from rt.core.pos.sys.netinet.in_

struct in_addr  // from rt.core.pos.sys.netinet.in_
INET_ADDRSTRLEN // from rt.core.pos.sys.netinet.in_

uint32_t // from rt.core.stdc.inttypes
uint16_t // from rt.core.stdc.inttypes

uint32_t htonl(uint32_t);
uint16_t htons(uint16_t);
uint32_t ntohl(uint32_t);
uint16_t ntohs(uint16_t);

in_addr_t inet_addr(in char*);
char*     inet_ntoa(in_addr);
// per spec: const char* inet_ntop(int, const void*, char*, socklen_t);
char*     inet_ntop(int, in void*, char*, socklen_t);
int       inet_pton(int, in char*, void*);
*/

version( linux )
{
    alias uint16_t in_port_t;
    alias uint32_t in_addr_t;

    struct in_addr
    {
        in_addr_t s_addr;
    }

    const INET_ADDRSTRLEN = 16;

    uint32_t htonl(uint32_t);
    uint16_t htons(uint16_t);
    uint32_t ntohl(uint32_t);
    uint16_t ntohs(uint16_t);

    in_addr_t inet_addr(in char*);
    char*     inet_ntoa(in_addr);
    char*     inet_ntop(int, in void*, char*, socklen_t);
    int       inet_pton(int, in char*, void*);
}
else version( OSX )
{
    alias uint16_t in_port_t; // TODO: verify
    alias uint32_t in_addr_t; // TODO: verify

    struct in_addr
    {
        in_addr_t s_addr;
    }

    const INET_ADDRSTRLEN = 16;

    uint32_t htonl(uint32_t);
    uint16_t htons(uint16_t);
    uint32_t ntohl(uint32_t);
    uint16_t ntohs(uint16_t);

    in_addr_t inet_addr(in char*);
    char*     inet_ntoa(in_addr);
    char*     inet_ntop(int, in void*, char*, socklen_t);
    int       inet_pton(int, in char*, void*);
}
else version( FreeBSD )
{
    alias uint16_t in_port_t;
    alias uint32_t in_addr_t;

    struct in_addr
    {
        in_addr_t s_addr;
    }

    static int INET_ADDRSTRLEN = 16;

    uint32_t htonl(uint32_t);
    uint16_t htons(uint16_t);
    uint32_t ntohl(uint32_t);
    uint16_t ntohs(uint16_t);

    in_addr_t       inet_addr(in char*);
    char*           inet_ntoa(in_addr);
    char*    inet_ntop(int, in void*, char*, socklen_t);
    int             inet_pton(int, in char*, void*);
}

//
// IPV6 (IP6)
//
/*
INET6_ADDRSTRLEN // from rt.core.pos.sys.netinet.in_
*/

version( linux )
{
    const INET6_ADDRSTRLEN = 46;
}
else version( OSX )
{
    const INET6_ADDRSTRLEN = 46;
}
else version( FreeBSD )
{
    const INET6_ADDRSTRLEN = 46;
}
