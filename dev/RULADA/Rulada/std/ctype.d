﻿/*
 * Placed into the Public Domain.
 * Digital Mars, www.digitalmars.com
 * Written by Walter Bright
 */

/**
 * Simple ASCII character classification functions.
 * For Unicode classification, see $(LINK2 std_uni.html, std.uni).
 * References:
 *	$(LINK2 http://www.digitalmars.com/d/ascii-table.html, ASCII Table),
 *	$(LINK2 http://en.wikipedia.org/wiki/Ascii, Wikipedia)
 * Macros:
 *	WIKI=Phobos/StdCtype
 */

module std.ctype;

/**
 * Returns !=0 if c is a letter in the range (0..9, a..z, A..Z).
 */
int isalnum(dchar c)  { return (c <= 0x7F) ? _ctype[c] & (_ALP|_DIG) : 0; }
цел числобукв_ли(дим б){return isalnum(б);}
/**
 * Returns !=0 if c is an ascii upper or lower case letter.
 */
int isalpha(dchar c)  { return (c <= 0x7F) ? _ctype[c] & (_ALP)      : 0; }
цел буква_ли(дим б){return  isalpha(б);}
/**
 * Returns !=0 if c is a control character.
 */
int iscntrl(dchar c)  { return (c <= 0x7F) ? _ctype[c] & (_CTL)      : 0; }
цел управ_ли(дим б){return iscntrl(б);}
/**
 * Returns !=0 if c is a digit.
 */
int isdigit(dchar c)  { return (c <= 0x7F) ? _ctype[c] & (_DIG)      : 0; }
цел цифра_ли(дим б){return isdigit(б);}
/**
 * Returns !=0 if c is lower case ascii letter.
 */
int islower(dchar c)  { return (c <= 0x7F) ? _ctype[c] & (_LC)       : 0; }
цел проп_ли(дим б){return islower(б);}
/**
 * Returns !=0 if c is a punctuation character.
 */
int ispunct(dchar c)  { return (c <= 0x7F) ? _ctype[c] & (_PNC)      : 0; }
цел пунктзнак_ли(дим б){return  ispunct(б);}
/**
 * Returns !=0 if c is a space, tab, vertical tab, form feed,
 * carriage return, or linefeed.
 */
int isspace(dchar c)  { return (c <= 0x7F) ? _ctype[c] & (_SPC)      : 0; }
цел межбукв_ли(дим б){return isspace(б);}
/**
 * Returns !=0 if c is an upper case ascii character.
 */
int isupper(dchar c)  { return (c <= 0x7F) ? _ctype[c] & (_UC)       : 0; }
цел заг_ли(дим б){return isupper(б);}
/**
 * Returns !=0 if c is a hex digit (0..9, a..f, A..F).
 */
int isxdigit(dchar c) { return (c <= 0x7F) ? _ctype[c] & (_HEX)      : 0; }
цел цифраикс_ли(дим б){return isxdigit(б);}
/**
 * Returns !=0 if c is a printing character except for the space character.
 */
int isgraph(dchar c)  { return (c <= 0x7F) ? _ctype[c] & (_ALP|_DIG|_PNC) : 0; }
цел граф_ли(дим б){return  isgraph(б);}
/**
 * Returns !=0 if c is a printing character including the space character.
 */
int isprint(dchar c)  { return (c <= 0x7F) ? _ctype[c] & (_ALP|_DIG|_PNC|_BLK) : 0; }
цел печат_ли(дим б) {return  isprint(б);}
/**
 * Returns !=0 if c is in the ascii character set, i.e. in the range 0..0x7F.
 */
int isascii(dchar c)  { return c <= 0x7F; }
цел аски_ли(дим б){return  isascii(б);}

/**
 * If c is an upper case ascii character,
 * return the lower case equivalent, otherwise return c.
 */
dchar tolower(dchar c)
    out (result)
    {
	assert(!isupper(result));
    }
    body
    {
	return isupper(c) ? c + (cast(dchar)'a' - 'A') : c;
    }

дим впроп(дим б){return  tolower(б);}

/**
 * If c is a lower case ascii character,
 * return the upper case equivalent, otherwise return c.
 */
dchar toupper(dchar c)
    out (result)
    {
	assert(!islower(result));
    }
    body
    {
	return islower(c) ? c - (cast(dchar)'a' - 'A') : c;
    }
дим взаг(дим б){return toupper(б);}

private:

enum
{
    _SPC =	8,
    _CTL =	0x20,
    _BLK =	0x40,
    _HEX =	0x80,
    _UC  =	1,
    _LC  =	2,
    _PNC =	0x10,
    _DIG =	4,
    _ALP =	_UC|_LC,
}

ubyte _ctype[128] =
[
	_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,
	_CTL,_CTL|_SPC,_CTL|_SPC,_CTL|_SPC,_CTL|_SPC,_CTL|_SPC,_CTL,_CTL,
	_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,
	_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,
	_SPC|_BLK,_PNC,_PNC,_PNC,_PNC,_PNC,_PNC,_PNC,
	_PNC,_PNC,_PNC,_PNC,_PNC,_PNC,_PNC,_PNC,
	_DIG|_HEX,_DIG|_HEX,_DIG|_HEX,_DIG|_HEX,_DIG|_HEX,
	_DIG|_HEX,_DIG|_HEX,_DIG|_HEX,_DIG|_HEX,_DIG|_HEX,
	_PNC,_PNC,_PNC,_PNC,_PNC,_PNC,
	_PNC,_UC|_HEX,_UC|_HEX,_UC|_HEX,_UC|_HEX,_UC|_HEX,_UC|_HEX,_UC,
	_UC,_UC,_UC,_UC,_UC,_UC,_UC,_UC,
	_UC,_UC,_UC,_UC,_UC,_UC,_UC,_UC,
	_UC,_UC,_UC,_PNC,_PNC,_PNC,_PNC,_PNC,
	_PNC,_LC|_HEX,_LC|_HEX,_LC|_HEX,_LC|_HEX,_LC|_HEX,_LC|_HEX,_LC,
	_LC,_LC,_LC,_LC,_LC,_LC,_LC,_LC,
	_LC,_LC,_LC,_LC,_LC,_LC,_LC,_LC,
	_LC,_LC,_LC,_PNC,_PNC,_PNC,_PNC,_CTL
];

//Дополнено для русского алфавита
int isruslower(dchar c)  { return (c <= 'я' &&  c >='а' || c == 'ё'); }
int isrusupper(dchar c)  { return (c <=  'Я' && c >= 'А' || c == 'Ё') ; }
цел руспроп_ли(дим c)  { return (c <= 'я' &&  c >='а' || c == 'ё'); }
цел русзаг_ли(дим c)  { return (c <=  'Я' && c >= 'А' || c == 'Ё') ; }

unittest
{
    assert(isspace(' '));
    assert(!isspace('z'));
    assert(toupper('a') == 'A');
    assert(tolower('Q') == 'q');
    assert(!isxdigit('G'));assert(isruslower('ф'));
    assert(!isruslower('z'));
	assert (isrusupper('П'));
	assert (isrusupper('Ё'));
	assert(!isrusupper('п'));
	printf("!!!!!!!!!!");
}
