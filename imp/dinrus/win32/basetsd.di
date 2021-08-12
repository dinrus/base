/***********************************************************************\
*                               basetsd.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*             Translated from MinGW API for MS-Windows 3.12             *
*                           by Stewart Gordon                           *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module win32.basetsd;

template CPtr(T) {
	version (D_Version2) {
		// must use mixin so that it doesn't cause a syntax error under D1
		mixin("alias const(T)* CPtr;");
	} else {
		alias T* CPtr;
	}
}

//alias CPtr!(TCHAR) LPCTSTR;
//alias CPtr!(сим)  LPCCH, PCSTR, LPCSTR;
//alias CPtr!(шим) LPCWCH, PCWCH, LPCWSTR, PCWSTR;
version (Win64) {
} else {

	бцел HandleToUlong(HANDLE h)      { return cast(бцел) h; }
	цел HandleToLong(HANDLE h)        { return cast(цел) h; }
	HANDLE LongToHandle(LONG_PTR h)   { return cast(HANDLE) h; }
	бцел PtrToUlong(CPtr!(проц) p)    { return cast(бцел) p; }
	бцел PtrToUint(CPtr!(проц) p)     { return cast(бцел) p; }
	цел PtrToInt(CPtr!(проц) p)       { return cast(цел) p; }
	бкрат PtrToUshort(CPtr!(проц) p) { return cast(бкрат) p; }
	крат PtrToShort(CPtr!(проц) p)   { return cast(крат) p; }
	проц* IntToPtr(цел i)             { return cast(проц*) i; }
	проц* UIntToPtr(бцел ui)          { return cast(проц*) ui; }
	alias IntToPtr LongToPtr;
	alias UIntToPtr ULongToPtr;
}

alias UIntToPtr UintToPtr, UlongToPtr;

enum : UINT_PTR {
	MAXUINT_PTR = UINT_PTR.max
}

enum : INT_PTR {
	MAXINT_PTR = INT_PTR.max,
	MININT_PTR = INT_PTR.min
}

enum : ULONG_PTR {
	MAXULONG_PTR = ULONG_PTR.max
}

enum : LONG_PTR {
	MAXLONG_PTR = LONG_PTR.max,
	MINLONG_PTR = LONG_PTR.min
}

enum : UHALF_PTR {
	MAXUHALF_PTR = UHALF_PTR.max
}

enum : HALF_PTR {
	MAXHALF_PTR = HALF_PTR.max,
	MINHALF_PTR = HALF_PTR.min
}

