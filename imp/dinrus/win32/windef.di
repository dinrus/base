/***********************************************************************\
*                                windef.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                           by Stewart Gordon                           *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module win32.windef;

public import win32.winnt;
private import win32.w32api;

const size_t MAX_PATH = 260;

бкрат MAKEWORD(ббайт a, ббайт b) {
	return cast(бкрат) ((b << 8) | a);
}

бцел MAKELONG(бкрат a, бкрат b) {
	return cast(бцел) ((b << 16) | a);
}

бкрат LOWORD(бцел l) {
	return cast(бкрат) l;
}

бкрат HIWORD(бцел l) {
	return cast(бкрат) (l >>> 16);
}

ббайт LOBYTE(бкрат w) {
	return cast(ббайт) w;
}

ббайт HIBYTE(бкрат w) {
	return cast(ббайт) (w >>> 8);
}

template max(T) {
	T max(T a, T b) {
		return a > b ? a : b;
	}
}

template min(T) {
	T min(T a, T b) {
		return a < b ? a : b;
	}
}

/*
const проц* NULL = null;
alias ббайт   BYTE;
alias ббайт*  PBYTE, LPBYTE;
alias бкрат  USHORT, WORD, ATOM;
alias бкрат* PUSHORT, PWORD, LPWORD;
alias бцел    ULONG, DWORD, UINT, COLORREF;
alias бцел*   PULONG, PDWORD, LPDWORD, PUINT, LPUINT;
alias цел     WINBOOL, BOOL, INT, LONG, HFILE, HRESULT;
alias цел*    PWINBOOL, LPWINBOOL, PBOOL, LPBOOL, PINT, LPINT, LPLONG;
alias плав   FLOAT;
alias плав*  PFLOAT;
alias проц*   PCVOID, LPCVOID;

alias UINT_PTR WPARAM;
alias LONG_PTR LPARAM, LRESULT;

alias HANDLE HGLOBAL, HLOCAL, GLOBALHANDLE, LOCALHANDLE, HGDIOBJ, HACCEL,
  HBITMAP, HBRUSH, HCOLORSPACE, HDC, HGLRC, HDESK, HENHMETAFILE, HFONT,
  HICON, HINSTANCE, HKEY, HMENU, HMETAFILE, HMODULE, HMONITOR, HPALETTE, HPEN,
  HRGN, HRSRC, HSTR, HTASK, HWND, HWINSTA, HKL, HCURSOR;
alias HANDLE* PHKEY;*/

static if (WINVER >= 0x500) {
	alias HANDLE HTERMINAL, HWINEVENTHOOK;
}

struct RECT {
	LONG лево;
	LONG верх;
	LONG право;
	LONG низ;
}
alias RECT RECTL;
alias RECT* PRECT, LPRECT, LPCRECT, PRECTL, LPRECTL, LPCRECTL;

struct POINT {
	LONG x;
	LONG y;
}
alias POINT POINTL;
alias POINT* PPOINT, LPPOINT, PPOINTL, LPPOINTL;

struct SIZE {
	LONG cx;
	LONG cy;
}
alias SIZE SIZEL;
alias SIZE* PSIZE, LPSIZE, PSIZEL, LPSIZEL;

struct POINTS {
	SHORT x;
	SHORT y;
}
alias POINTS* PPOINTS, LPPOINTS;


