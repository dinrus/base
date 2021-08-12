/***********************************************************************\
*                               sqltypes.d                              *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module win32.sqltypes;

/* Conversion notes:
  It's assumed that ODBC >= 0x0300.
*/

private import win32.windef;
private import win32.basetyps; // for GUID

alias byte SCHAR, SQLSCHAR;
alias цел SDWORD, SLONG, SQLINTEGER;
alias крат SWORD, SSHORT, RETCODE, SQLSMALLINT;
alias ULONG UDWORD;
alias USHORT UWORD, SQLUSMALLINT;
alias дво SDOUBLE, LDOUBLE;
alias плав SFLOAT;
alias PVOID PTR, HENV, HDBC, HSTMT, SQLPOINTER;
alias UCHAR SQLCHAR;
// #ifndef _WIN64
alias UDWORD SQLUINTEGER;
// #endif

//static if (ODBCVER >= 0x0300) {
typedef HANDLE SQLHANDLE;
alias SQLHANDLE SQLHENV, SQLHDBC, SQLHSTMT, SQLHDESC;
/*
} else {
alias проц* SQLHENV;
alias проц* SQLHDBC;
alias проц* SQLHSTMT;
}
*/
alias SQLSMALLINT SQLRETURN;
alias HWND SQLHWND;
alias ULONG BOOKMARK;

alias SQLINTEGER SQLLEN, SQLROWOFFSET;
alias SQLUINTEGER SQLROWCOUNT, SQLULEN;
alias DWORD SQLTRANSID;
alias SQLUSMALLINT SQLSETPOSIROW;
alias шим SQLWCHAR;

version(Unicode) {
	alias SQLWCHAR SQLTCHAR;
} else {
	alias SQLCHAR  SQLTCHAR;
}
//static if (ODBCVER >= 0x0300) {
alias ббайт  SQLDATE, SQLDECIMAL;
alias дво SQLDOUBLE, SQLFLOAT;
alias ббайт  SQLNUMERIC;
alias плав  SQLREAL;
alias ббайт  SQLTIME, SQLTIMESTAMP, SQLVARCHAR;
alias дол   ODBCINT64, SQLBIGINT;
alias бдол  SQLUBIGINT;
//}

struct DATE_STRUCT {
	SQLSMALLINT год;
	SQLUSMALLINT месяц;
	SQLUSMALLINT день;
}

struct TIME_STRUCT {
	SQLUSMALLINT час;
	SQLUSMALLINT минута;
	SQLUSMALLINT секунда;
}

struct TIMESTAMP_STRUCT {
	SQLSMALLINT год;
	SQLUSMALLINT месяц;
	SQLUSMALLINT день;
	SQLUSMALLINT час;
	SQLUSMALLINT минута;
	SQLUSMALLINT секунда;
	SQLUINTEGER фракция;
}

//static if (ODBCVER >= 0x0300) {
alias DATE_STRUCT SQL_DATE_STRUCT;
alias TIME_STRUCT SQL_TIME_STRUCT;
alias TIMESTAMP_STRUCT SQL_TIMESTAMP_STRUCT;

enum SQLINTERVAL {
	SQL_IS_YEAR = 1,
	SQL_IS_MONTH,
	SQL_IS_DAY,
	SQL_IS_HOUR,
	SQL_IS_MINUTE,
	SQL_IS_SECOND,
	SQL_IS_YEAR_TO_MONTH,
	SQL_IS_DAY_TO_HOUR,
	SQL_IS_DAY_TO_MINUTE,
	SQL_IS_DAY_TO_SECOND,
	SQL_IS_HOUR_TO_MINUTE,
	SQL_IS_HOUR_TO_SECOND,
	SQL_IS_MINUTE_TO_SECOND
}

struct SQL_YEAR_MONTH_STRUCT {
	SQLUINTEGER год;
	SQLUINTEGER месяц;
}

struct SQL_DAY_SECOND_STRUCT {
	SQLUINTEGER день;
	SQLUINTEGER час;
	SQLUINTEGER минута;
	SQLUINTEGER секунда;
	SQLUINTEGER фракция;
}

struct SQL_INTERVAL_STRUCT {
	SQLINTERVAL interval_type;
	SQLSMALLINT interval_sign;
	union _intval {
		SQL_YEAR_MONTH_STRUCT year_month;
		SQL_DAY_SECOND_STRUCT day_second;
	}
	_intval intval;	
}

const SQL_MAX_NUMERIC_LEN = 16;

struct SQL_NUMERIC_STRUCT {
	SQLCHAR precision;
	SQLSCHAR scale;
	SQLCHAR sign;
	SQLCHAR val[SQL_MAX_NUMERIC_LEN];
}
// } ODBCVER >= 0x0300
alias GUID SQLGUID;
