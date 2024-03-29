﻿/*
 *  Copyright (C) 2004-2007 by Digital Mars, www.digitalmars.com
 *  Written by Walter Bright
 *
 *  This software is provided 'as-is', without any express or implied
 *  warranty. In no event will the authors be held liable for any damages
 *  arising from the use of this software.
 *
 *  Permission is granted to anyone to use this software for any purpose,
 *  including commercial applications, and to alter it and redistribute it
 *  freely, in both source and binary form, subject to the following
 *  restrictions:
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

/*
 *  Modified by Sean Kelly <sean@f4.ca> для использования с Tango.
 */
//module rt.switch_;

/******************************************************
 * Support for switch statements switching on strings.
 * Input:
 *      table[]         sorted array of strings generated by compiler
 *      ca              string to look up in table
 * Output:
 *      результат          index of match in table[]
 *                      -1 if not in table
 */

export extern (C):

int _d_switch_string(char[][] table, char[] ca)
in
{
    //printf("in _d_switch_string()\n");
    assert(table.length >= 0);
    assert(ca.length >= 0);

    // Make sure table[] is sorted correctly
    int j;

    for (j = 1; j < table.length; j++)
    {
        int len1 = table[j - 1].length;
        int len2 = table[j].length;

        assert(len1 <= len2);
        if (len1 == len2)
        {
            int ci;

            ci = memcmp(table[j - 1].ptr, table[j].ptr, len1);
            assert(ci < 0); // ci==0 means a duplicate
        }
    }
}
out (результат)
{
    int i;
    int cj;

    //printf("out _d_switch_string()\n");
    if (результат == -1)
    {
        // Not found
        for (i = 0; i < table.length; i++)
        {
            if (table[i].length == ca.length)
            {   cj = memcmp(table[i].ptr, ca.ptr, ca.length);
                assert(cj != 0);
            }
        }
    }
    else
    {
        assert(0 <= результат && результат < table.length);
        for (i = 0; 1; i++)
        {
            assert(i < table.length);
            if (table[i].length == ca.length)
            {
                cj = memcmp(table[i].ptr, ca.ptr, ca.length);
                if (cj == 0)
                {
                    assert(i == результат);
                    break;
                }
            }
        }
    }
}
body
{
    //printf("body _d_switch_string(%.*s)\n", ca);
    int low;
    int high;
    int mid;
    int c;
    char[] pca;

    low = 0;
    high = table.length;

    version (none)
    {
        // Print table
        printf("ca[] = '%s'\n", cast(char *)ca);
        for (mid = 0; mid < high; mid++)
        {
            pca = table[mid];
            printf("table[%d] = %d, '%.*s'\n", mid, pca.length, pca);
        }
    }
    if (high &&
        ca.length >= table[0].length &&
        ca.length <= table[high - 1].length)
    {
        // Looking for 0 length string, which would only be at the beginning
        if (ca.length == 0)
            return 0;

        char c1 = ca[0];

        // Do binary search
        while (low < high)
        {
            mid = (low + high) >> 1;
            pca = table[mid];
            c = ca.length - pca.length;
            if (c == 0)
            {
                c = cast(ubyte)c1 - cast(ubyte)pca[0];
                if (c == 0)
                {
                    c = memcmp(ca.ptr, pca.ptr, ca.length);
                    if (c == 0)
                    {   //printf("found %d\n", mid);
                        return mid;
                    }
                }
            }
            if (c < 0)
            {
                high = mid;
            }
            else
            {
                low = mid + 1;
            }
        }
    }

    //printf("not found\n");
    return -1; // not found
}

unittest
{
    switch (cast(char []) "c")
    {
         case "coo":
         default:
             break;
    }
}

/**********************************
 * Same thing, but for wide chars.
 */

int _d_switch_ustring(wchar[][] table, wchar[] ca)
in
{
    //printf("in _d_switch_ustring()\n");
    assert(table.length >= 0);
    assert(ca.length >= 0);

    // Make sure table[] is sorted correctly
    int j;

    for (j = 1; j < table.length; j++)
    {
        int len1 = table[j - 1].length;
        int len2 = table[j].length;

        assert(len1 <= len2);
        if (len1 == len2)
        {
            int c;

            c = memcmp(table[j - 1].ptr, table[j].ptr, len1 * wchar.sizeof);
            assert(c < 0);  // c==0 means a duplicate
        }
    }
}
out (результат)
{
    int i;
    int c;

    //printf("out _d_switch_string()\n");
    if (результат == -1)
    {
        // Not found
        for (i = 0; i < table.length; i++)
        {
            if (table[i].length == ca.length)
            {   c = memcmp(table[i].ptr, ca.ptr, ca.length * wchar.sizeof);
                assert(c != 0);
            }
        }
    }
    else
    {
        assert(0 <= результат && результат < table.length);
        for (i = 0; 1; i++)
        {
            assert(i < table.length);
            if (table[i].length == ca.length)
            {
                c = memcmp(table[i].ptr, ca.ptr, ca.length * wchar.sizeof);
                if (c == 0)
                {
                    assert(i == результат);
                    break;
                }
            }
        }
    }
}
body
{
    //printf("body _d_switch_ustring()\n");
    int low;
    int high;
    int mid;
    int c;
    wchar[] pca;

    low = 0;
    high = table.length;

/*
    // Print table
    wprintf("ca[] = '%.*s'\n", ca);
    for (mid = 0; mid < high; mid++)
    {
        pca = table[mid];
        wprintf("table[%d] = %d, '%.*s'\n", mid, pca.length, pca);
    }
*/

    // Do binary search
    while (low < high)
    {
        mid = (low + high) >> 1;
        pca = table[mid];
        c = ca.length - pca.length;
        if (c == 0)
        {
            c = memcmp(ca.ptr, pca.ptr, ca.length * wchar.sizeof);
            if (c == 0)
            {   //printf("found %d\n", mid);
                return mid;
            }
        }
        if (c < 0)
        {
            high = mid;
        }
        else
        {
            low = mid + 1;
        }
    }
    //printf("not found\n");
    return -1;              // not found
}


unittest
{
    switch (cast(wchar []) "c")
    {
         case "coo":
         default:
             break;
    }
}


/**********************************
 * Same thing, but for wide chars.
 */

int _d_switch_dstring(dchar[][] table, dchar[] ca)
in
{
    //printf("in _d_switch_dstring()\n");
    assert(table.length >= 0);
    assert(ca.length >= 0);

    // Make sure table[] is sorted correctly
    int j;

    for (j = 1; j < table.length; j++)
    {
        int len1 = table[j - 1].length;
        int len2 = table[j].length;

        assert(len1 <= len2);
        if (len1 == len2)
        {
            int c;

            c = memcmp(table[j - 1].ptr, table[j].ptr, len1 * dchar.sizeof);
            assert(c < 0);  // c==0 means a duplicate
        }
    }
}
out (результат)
{
    int i;
    int c;

    //printf("out _d_switch_string()\n");
    if (результат == -1)
    {
        // Not found
        for (i = 0; i < table.length; i++)
        {
            if (table[i].length == ca.length)
            {   c = memcmp(table[i].ptr, ca.ptr, ca.length * dchar.sizeof);
                assert(c != 0);
            }
        }
    }
    else
    {
        assert(0 <= результат && результат < table.length);
        for (i = 0; 1; i++)
        {
            assert(i < table.length);
            if (table[i].length == ca.length)
            {
                c = memcmp(table[i].ptr, ca.ptr, ca.length * dchar.sizeof);
                if (c == 0)
                {
                    assert(i == результат);
                    break;
                }
            }
        }
    }
}
body
{
    //printf("body _d_switch_ustring()\n");
    int low;
    int high;
    int mid;
    int c;
    dchar[] pca;

    low = 0;
    high = table.length;

/*
    // Print table
    wprintf("ca[] = '%.*s'\n", ca);
    for (mid = 0; mid < high; mid++)
    {
        pca = table[mid];
        wprintf("table[%d] = %d, '%.*s'\n", mid, pca.length, pca);
    }
*/

    // Do binary search
    while (low < high)
    {
        mid = (low + high) >> 1;
        pca = table[mid];
        c = ca.length - pca.length;
        if (c == 0)
        {
            c = memcmp(ca.ptr, pca.ptr, ca.length * dchar.sizeof);
            if (c == 0)
            {   //printf("found %d\n", mid);
                return mid;
            }
        }
        if (c < 0)
        {
            high = mid;
        }
        else
        {
            low = mid + 1;
        }
    }
    //printf("not found\n");
    return -1; // not found
}


unittest
{
    switch (cast(dchar []) "c")
    {
         case "coo":
         default:
             break;
    }
}
