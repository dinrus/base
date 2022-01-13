/**
* Модуль функций WIN API для языка Динрус.
* Разработчик Виталий Кулич.
*/
module sys.WinFuncs;

import sys.WinStructs, sys.WinConsts;
import  std.string;
alias std.string.toString вТкст;
import stringz, std.utf;
import  std.intrinsic, exception;

version = Dinrus;

version = Динрус;
version = Dinrus;
version = Unicode;
version = ЛитлЭндиан;

////////Константы, отсутствующие в WinConsts
const _WIN32_WINNT_NT4                    = 0x0400;
const _WIN32_WINNT_WIN2K                  = 0x0500;
const _WIN32_WINNT_WINXP                  = 0x0501;
const _WIN32_WINNT_WS03                   = 0x0502;
const _WIN32_WINNT_WIN6                   = 0x0600;
const _WIN32_WINNT_VISTA                  = 0x0600;
const _WIN32_WINNT_WS08                   = 0x0600;
const _WIN32_WINNT_LONGHORN               = 0x0600;
const _WIN32_WINNT_WIN7                   = 0x0601;
const _WIN32_WINNT_WIN8                   = 0x0602;
const _WIN32_WINNT_WINBLUE                = 0x0603;
const _WIN32_WINNT_WIN10                  = 0x0A00;

const _WIN32_IE_IE20                      = 0x0200;
const _WIN32_IE_IE30                      = 0x0300;
const _WIN32_IE_IE302                     = 0x0302;
const _WIN32_IE_IE40                      = 0x0400;
const _WIN32_IE_IE401                     = 0x0401;
const _WIN32_IE_IE50                      = 0x0500;
const _WIN32_IE_IE501                     = 0x0501;
const _WIN32_IE_IE55                      = 0x0550;
const _WIN32_IE_IE60                      = 0x0600;
const _WIN32_IE_IE60SP1                   = 0x0601;
const _WIN32_IE_IE60SP2                   = 0x0603;
const _WIN32_IE_IE70                      = 0x0700;
const _WIN32_IE_IE80                      = 0x0800;
const _WIN32_IE_IE90                      = 0x0900;
const _WIN32_IE_IE100                     = 0x0A00;

const _WIN32_IE_NT4                    =  _WIN32_IE_IE20;
const _WIN32_IE_NT4SP1                 =  _WIN32_IE_IE20;
const _WIN32_IE_NT4SP2                 =  _WIN32_IE_IE20;
const _WIN32_IE_NT4SP3                 =  _WIN32_IE_IE302;
const _WIN32_IE_NT4SP4                 =  _WIN32_IE_IE401;
const _WIN32_IE_NT4SP5                 =  _WIN32_IE_IE401;
const _WIN32_IE_NT4SP6                 =  _WIN32_IE_IE50;
const _WIN32_IE_WIN98                  =  _WIN32_IE_IE401;
const _WIN32_IE_WIN98SE                =  _WIN32_IE_IE50;
const _WIN32_IE_WINME                  =  _WIN32_IE_IE55;
const _WIN32_IE_WIN2K                  =  _WIN32_IE_IE501;
const _WIN32_IE_WIN2KSP1               =  _WIN32_IE_IE501;
const _WIN32_IE_WIN2KSP2               =  _WIN32_IE_IE501;
const _WIN32_IE_WIN2KSP3               =  _WIN32_IE_IE501;
const _WIN32_IE_WIN2KSP4               =  _WIN32_IE_IE501;
const _WIN32_IE_XP                     =  _WIN32_IE_IE60;
const _WIN32_IE_XPSP1                  =  _WIN32_IE_IE60SP1;
const _WIN32_IE_XPSP2                  =  _WIN32_IE_IE60SP2;
const _WIN32_IE_WS03                   =  0x0602;
const _WIN32_IE_WS03SP1                =  _WIN32_IE_IE60SP2;
const _WIN32_IE_WIN6                   =  _WIN32_IE_IE70;
const _WIN32_IE_LONGHORN               =  _WIN32_IE_IE70;
const _WIN32_IE_WIN7                   =  _WIN32_IE_IE80;
const _WIN32_IE_WIN8                   =  _WIN32_IE_IE100;
const _WIN32_IE_WINBLUE                =  _WIN32_IE_IE100;


const NTDDI_WIN2K                         = 0x05000000;
const NTDDI_WIN2KSP1                      = 0x05000100;
const NTDDI_WIN2KSP2                      = 0x05000200;
const NTDDI_WIN2KSP3                      = 0x05000300;
const NTDDI_WIN2KSP4                      = 0x05000400;

const NTDDI_WINXP                         = 0x05010000;
const NTDDI_WINXPSP1                      = 0x05010100;
const NTDDI_WINXPSP2                      = 0x05010200;
const NTDDI_WINXPSP3                      = 0x05010300;
const NTDDI_WINXPSP4                      = 0x05010400;

const NTDDI_WS03                          = 0x05020000;
const NTDDI_WS03SP1                       = 0x05020100;
const NTDDI_WS03SP2                       = 0x05020200;
const NTDDI_WS03SP3                       = 0x05020300;
const NTDDI_WS03SP4                       = 0x05020400;

const NTDDI_WIN6                          = 0x06000000;
const NTDDI_WIN6SP1                       = 0x06000100;
const NTDDI_WIN6SP2                       = 0x06000200;
const NTDDI_WIN6SP3                       = 0x06000300;
const NTDDI_WIN6SP4                       = 0x06000400;

const NTDDI_VISTA                       = NTDDI_WIN6;
const NTDDI_VISTASP1                    = NTDDI_WIN6SP1;
const NTDDI_VISTASP2                    = NTDDI_WIN6SP2;
const NTDDI_VISTASP3                    = NTDDI_WIN6SP3;
const NTDDI_VISTASP4                    = NTDDI_WIN6SP4;

const NTDDI_LONGHORN                    = NTDDI_VISTA;

const NTDDI_WS08                        = NTDDI_WIN6SP1;
const NTDDI_WS08SP2                     = NTDDI_WIN6SP2;
const NTDDI_WS08SP3                     = NTDDI_WIN6SP3;
const NTDDI_WS08SP4                     = NTDDI_WIN6SP4;

const NTDDI_WIN7                          = 0x06010000;
const NTDDI_WIN8                          = 0x06020000;
const NTDDI_WINBLUE                       = 0x06030000;

const OSVERSION_MASK      = 0xFFFF0000;
const SPVERSION_MASK      = 0x0000FF00;
const SUBVERSION_MASK     = 0x000000FF;

const _WIN32_WINNT    = 0x0603;

const NTDDI_VERSION   = 0x06030000;


enum ПИнфОБезопасности //SECURITY_INFORMATION
{
	Владелец            = 0x00000001,//OWNER_SECURITY_INFORMATION
	Группа            = 0x00000002,//GROUP_SECURITY_INFORMATION
	ДСКД             = 0x00000004,//DACL_SECURITY_INFORMATION
	ССКД             = 0x00000008,//SACL_SECURITY_INFORMATION
	Ярлык            = 0x00000010,//LABEL_SECURITY_INFORMATION
	НепротекцССКД = 0x10000000,//UNPROTECTED_SACL_SECURITY_INFORMATION
	НепротекцДСКД = 0x20000000,//UNPROTECTED_DACL_SECURITY_INFORMATION
	ПротекцССКД   = 0x40000000,//PROTECTED_SACL_SECURITY_INFORMATION
	ПротекцДСКД   = 0x80000000//PROTECTED_DACL_SECURITY_INFORMATION
	}

/////////Структуры, отсутствующие в WinStructs


static if (_WIN32_WINNT >= 0x410) {
	alias BOOL function (HMONITOR, HDC, LPRECT, LPARAM) MONITORENUMPROC;
}
alias BOOL function(HMODULE, LPCSTR, LPCSTR, WORD, LONG_PTR) ENUMRESLANGPROCA;
alias BOOL function(HMODULE, LPCWSTR, LPCWSTR, WORD, LONG_PTR) ENUMRESLANGPROCW;
alias BOOL function(HMODULE, LPCSTR, ткст0, LONG_PTR) ENUMRESNAMEPROCA;
alias BOOL function(HMODULE, LPCWSTR, шткст0, LONG_PTR) ENUMRESNAMEPROCW;
alias BOOL function(HMODULE, ткст0, LONG_PTR) ENUMRESTYPEPROCA;
alias BOOL function(HMODULE, шткст0, LONG_PTR) ENUMRESTYPEPROCW;

version(Unicode)
{
	alias sys.WinStructs.ЛОГ_ШРИФТ ЛОГШРИФТ;
    alias ENUMRESLANGPROCW ENUMRESLANGPROC;
    alias ENUMRESNAMEPROCW ENUMRESNAMEPROC;
    alias ENUMRESTYPEPROCW ENUMRESTYPEPROC;
	alias ФМТЧИСЛА NUMBERFMT;
	alias ФМТВАЛЮТЫ CURRENCYFMT;
}else{
    alias ENUMRESLANGPROCA ENUMRESLANGPROC;
    alias ENUMRESNAMEPROCA ENUMRESNAMEPROC;
    alias ENUMRESTYPEPROCA ENUMRESTYPEPROC;
	alias ФМТЧИСЛА_А NUMBERFMT;
	alias ЛОГ_ШРИФТА ЛОГШРИФТ;
	alias ФМТВАЛЮТЫ_А CURRENCYFMT;
}
alias ЛОГШРИФТ* УкЛОГШРИФТ;
alias NUMBERFMT* УкФМТЧИСЛА;
alias CURRENCYFMT* УкФМТВАЛЮТЫ;
///////////////////////////////////////
/+
import base: ВинВерсия;		
	
	static this()
		{	
			ВинВерсия = ДайВерсию();			
		}

+/

private ткст замени (ткст путь, сим из_, сим в_)
{
        foreach (ref сим c; путь)
                 if (c is из_)
                     c = в_;
        return путь;
}

private ткст стандарт (ткст путь)
{
        return замени (путь, '\\', '/');
}
//////////////////////////////////////////////////////	
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//import sys.WinConsts, sys.WinStructs, stringz, std.utf;

enum MEMORY_RESOURCE_NOTIFICATION_TYPE {
		LowMemoryResourceNotification,
		HigуПамoryResourceNotification
	}
	

///ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
                private static шим[] вТкст16_ (шим[] врем, ткст путь)
                {
                        auto i = MultiByteToWideChar (ПКодСтр.УТФ8, 0,
                                                      cast(PCHAR)путь.ptr, путь.length,
                                                      врем.ptr, врем.length);
                        return врем [0..i];
                }

                
                private static ткст вТкст_ (ткст врем, шим[] путь)
                {
                        auto i = WideCharToMultiByte (ПКодСтр.УТФ8, 0, путь.ptr, путь.length,
                                                      cast(PCHAR)врем.ptr, врем.length, пусто, пусто);
                        return врем [0..i];
                }
////////////////////////////////////////////////////////
extern (Windows)
{

    alias цел function() FARPROC;
   

version (0)
{   // Properly prototyped versions
    alias бул function(УОК, бцел, WPARAM, LPARAM) DLGPROC;
    alias VOID function(УОК, бцел, бцел, бцел) TIMERPROC;
    alias бул function(HDC, LPARAM, цел) GRAYSTRINGPROC;
    alias бул function(УОК, LPARAM) WNDENUMPROC;
    alias LRESULT function(цел code, WPARAM wParam, LPARAM lParam) HOOKPROC;
    alias VOID function(УОК, бцел, бцел, LRESULT) SENDASYNCPROC;
    alias бул function(УОК, ткст0, ук) PROPENUMPROCA;
    alias бул function(УОК, шткст0, ук) PROPENUMPROCW;
    alias бул function(УОК, ткст0 , ук, бцел) PROPENUMPROCEXA;
    alias бул function(УОК, шткст0, ук, бцел) PROPENUMPROCEXW;
    alias цел function(ткст0  lpch, цел ichCurrent, цел cch, цел code)
       EDITWORDBREAKPROCA;
    alias цел function(шткст0 lpch, цел ichCurrent, цел cch, цел code)
       EDITWORDBREAKPROCW;
    alias бул function(HDC hdc, LPARAM lData, WPARAM wData, цел cx, цел cy)
       DRAWSTATEPROC;
}
else
{
    alias FARPROC DLGPROC;
    alias FARPROC TIMERPROC;
    alias FARPROC GRAYSTRINGPROC;
    alias FARPROC WNDENUMPROC;
    alias FARPROC HOOKPROC;
    alias FARPROC SENDASYNCPROC;
    alias FARPROC EDITWORDBREAKPROCA;
    alias FARPROC EDITWORDBREAKPROCW;
    alias FARPROC PROPENUMPROCA;
    alias FARPROC PROPENUMPROCW;
    alias FARPROC PROPENUMPROCEXA;
    alias FARPROC PROPENUMPROCEXW;
    alias FARPROC DRAWSTATEPROC;
}


	бул GetMailslotInfo(ук hMailslot, бцел* lpMaxMessageSize, бцел* lpNextSize, бцел* lpMessageCount, бцел* lpReadTimeout);
	бул SetMailslotInfo(ук hMailslot, бцел lReadTimeout);
	ук MapViewOfFile(ук hFileMappingObject, бцел dwDesiredAccess, бцел dwFileOffsetHigh, бцел dwFileOffsetLow, бцел dwNumberOfBytesToMap);
	ук MapViewOfFileEx(ук hFileMappingObject, бцел dwDesiredAccess, бцел dwFileOffsetHigh, бцел dwFileOffsetLow, бцел dwNumberOfBytesToMap, ук lpBaseAddress);
	бул FlushViewOfFile(ук lpBaseAddress, бцел dwNumberOfBytesToFlush);
	бул UnmapViewOfFile(ук lpBaseAddress);

	HGDIOBJ   GetStockObject(цел);
	бул ShowWindow(УОК окно, цел nCmdShow);


бцел   CoBuildVersion();
цел StringFromGUID2(GUID *rguid, шткст0 lpsz, цел cbMax);
/* init/uninit */
бцел   CoGetCurrentProcess();
//экз CoLoadLibrary(шткст0 lpszLibName, бул bAutoFree);
проц    CoFreeLibrary(экз hInst);
проц    CoFreeAllLibraries();
проц    CoFreeUnusedLibraries();
бул IsValidCodePage(бцел CodePage);
бцел GetACP();
//бул GetCPInfo(бцел CodePage, LPCPINFO lpCPInfo);
бул IsDBCSLeadByte(ббайт TestChar);
бул IsDBCSLeadByteEx(бцел CodePage, ббайт TestChar);
цел MultiByteToWideChar(бцел CodePage, бцел dwFlags, ткст0 lpMultiByteStr, цел cchMultiByte, шткст0 lpWideCharStr, цел cchWideChar);
цел WideCharToMultiByte(бцел CodePage, бцел dwFlags, шткст0 lpWideCharStr, цел cchWideChar, ткст0  lpMultiByteStr, цел cchMultiByte, ткст0 lpDefaultChar, бул* lpUsedDefaultChar);
бул PeekConsoleInputA(ук hConsoleInput, ЗАПИСЬ_ВВОДА* буф, бцел длина, бцел* lpNumberOfEventsRead);
бул PeekConsoleInputW(ук hConsoleInput, ЗАПИСЬ_ВВОДА* буф, бцел длина, бцел* lpNumberOfEventsRead);
бул ReadConsoleInputA(ук hConsoleInput, ЗАПИСЬ_ВВОДА* буф, бцел длина, бцел* lpNumberOfEventsRead);
бул ReadConsoleInputW(ук hConsoleInput, ЗАПИСЬ_ВВОДА* буф, бцел длина, бцел* lpNumberOfEventsRead);
бул WriteConsoleInputA(ук hConsoleInput, in ЗАПИСЬ_ВВОДА *буф, бцел длина, бцел* lpNumberOfEventsWritten);
бул WriteConsoleInputW(ук hConsoleInput, in ЗАПИСЬ_ВВОДА *буф, бцел длина, бцел* lpNumberOfEventsWritten);
бул ReadConsoleOutputA(ук консВывод, ИНФОСИМ* буф, КООРД буфРазм, КООРД буфКоорд, МПРЯМ* регЧтен);
бул ReadConsoleOutputW(ук консВывод, ИНФОСИМ* буф, КООРД буфРазм, КООРД буфКоорд, МПРЯМ* регЧтен);
бул WriteConsoleOutputA(ук консВывод, in ИНФОСИМ *буф, КООРД буфРазм, КООРД буфКоорд, МПРЯМ* регЗап);
бул WriteConsoleOutputW(ук консВывод, in ИНФОСИМ *буф, КООРД буфРазм, КООРД буфКоорд, МПРЯМ* регЗап);
бул ReadConsoleOutputCharacterA(ук консВывод, ткст0  симв, бцел длина, КООРД коордЧтен, бцел* члоСчитСим);
бул ReadConsoleOutputCharacterW(ук консВывод, шткст0 симв, бцел длина, КООРД коордЧтен, бцел* члоСчитСим);
бул ReadConsoleOutputAttributecast(ук  hConsoleOutput,  бкрат*  lpAttribute, бцел nLength, КООРД dwReadCoord, бцел* lpNumberOfAttrsRead);
бул WriteConsoleOutputCharacterAcast(ук hConsoleOutput, ткст0 lpCharacter, бцел nLength, КООРД dwWriteCoord, бцел* члоЗаписанАтров);
бул ReadConsoleOutputAttribute(ук консВывод, бкрат* атр, бцел длина, КООРД коордЧтен, бцел* члоСчитАтров);
бул WriteConsoleOutputCharacterA(ук консВывод, ткст0 симв, бцел длина, КООРД коордЗап, бцел* члоЗаписанАтров);
бул WriteConsoleOutputCharacterW(ук консВывод, шткст0 симв, бцел длина, КООРД коордЗап, бцел* члоЗаписанАтров);
бул WriteConsoleOutputAttribute(ук консВывод, in бкрат *атр, бцел длина, КООРД коордЗап, бцел* lpNumberOfAttrsWritten);
бул FillConsoleOutputCharacterA(ук консВывод, CHAR cCharacter, бцел  длина, КООРД  коордЗап, бцел* члоЗаписанАтров);
бул FillConsoleOutputCharacterW(ук консВывод, WCHAR cCharacter, бцел  длина, КООРД  коордЗап, бцел* члоЗаписанАтров);
бул FillConsoleOutputAttribute(ук консВывод, бкрат   wAttribute, бцел  длина, КООРД  коордЗап, бцел* lpNumberOfAttrsWritten);
бул GetConsoleMode(ук hConsoleHandle, бцел* lpMode);
бул GetNumberOfConsoleInputEvents(ук hConsoleInput, бцел* lpNumberOfEvents);
бул GetConsoleScreenBufferInfo(ук консВывод, ИНФОКОНСЭКРБУФ* lpConsoleScreenBufferInfo);
КООРД GetLargestConsoleWindowSize( ук консВывод);
бул GetConsoleCursorInfo(ук консВывод, ИНФОКОНСКУРСОР* lpConsoleCursorInfo);
бул GetNumberOfConsoleMouseButtons( бцел* lpNumberOfMouseButtons);
бул SetConsoleMode(ук hConsoleHandle, бцел dwMode);
бул SetConsoleActiveScreenBuffer(ук консВывод);
бул FlushConsoleInputBuffer(ук hConsoleInput);
бул SetConsoleScreenBufferSize(ук консВывод, КООРД dwSize);
бул WriteConsoleOutputAcast(ук  hConsoleOutput, in ИНФОСИМ* lpBuffer, КООРД  dwBufferSize, КООРД  dwBufferCoord, МПРЯМ*  lpWriteRegion);
бул WriteConsoleOutputWcast(ук hConsoleOutput, in ИНФОСИМ* lpBuffer, КООРД dwBufferSize, КООРД  dwBufferCoord, МПРЯМ* lpWriteRegion);
бул SetConsoleCursorPosition(ук консВывод, КООРД dwCursorPosition);
бул SetConsoleCursorInfo(ук консВывод, in ИНФОКОНСКУРСОР *lpConsoleCursorInfo);
бул ScrollConsoleScreenBufferA(ук консВывод, in МПРЯМ *lpScrollRectangle, in МПРЯМ *lpClipRectangle, КООРД dwDestinationOrigin, in ИНФОСИМ *lpFill);
бул ScrollConsoleScreenBufferW(ук консВывод, in МПРЯМ *lpScrollRectangle, in МПРЯМ *lpClipRectangle, КООРД dwDestinationOrigin, in ИНФОСИМ *lpFill);
бул SetConsoleWindowInfo(ук консВывод, бул bAbsolute, in МПРЯМ *lpConsoleWindow);
бул SetConsoleTextAttribute(ук консВывод, бкрат wAttributes);
alias бул function(бцел CtrlType) PHANDLER_ROUTINE;
бул SetConsoleCtrlHandler(PHANDLER_ROUTINE HandlerRoutine, бул Add);
бул GenerateConsoleCtrlEvent( бцел dwCtrlEvent, бцел dwProcessGroupId);
бул FreeConsole();
бцел GetConsoleTitleA(ткст0  консТитул, бцел разм);
бцел GetConsoleTitleW(шткст0 консТитул, бцел разм);
бул SetConsoleTitleA(ткст0 консТитул);
бул SetConsoleTitleW(шткст0 консТитул);
бул ReadConsoleA(ук hConsoleInput, ук буф, бцел nNumberOfCharsToRead, бцел* члоСчитСим, ук резерв);
бул ReadConsoleW(ук hConsoleInput, ук буф, бцел nNumberOfCharsToRead, бцел* члоСчитСим, ук резерв);
бул WriteConsoleA(ук консВывод, in  проц *буф, бцел nNumberOfCharsToWrite, бцел* члоЗаписанАтров, ук резерв);
бул WriteConsoleW(ук консВывод, in  проц *буф, бцел nNumberOfCharsToWrite, бцел* члоЗаписанАтров, ук резерв);
бцел GetConsoleCP();
бул SetConsoleCP( бцел wCodePageID);
бцел GetConsoleOutputCP();
бул SetConsoleOutputCP(бцел wCodePageID);
	
 цел GetSystemMetrics(цел nIndex);
 
 бул SetForegroundWindow(УОК окно);
 УОК WindowFromDC(HDC hDC);
 HDC GetDC(УОК окно);
 HDC GetDCEx(УОК окно, HRGN hrgnClip, бцел флаги);
 HDC GetWindowDC(УОК окно);
 цел ReleaseDC(УОК окно, HDC hDC);
 HDC BeginPaint(УОК окно, РИССТРУКТ* lpPaint);
 бул EndPaint(УОК окно, РИССТРУКТ* lpPaint);
 бул GetUpdateRect(УОК окно, ПРЯМ* lpRect, бул bErase);
 цел GetUpdateRgn(УОК окно, HRGN hRgn, бул bErase);
 цел SetWindowRgn(УОК окно, HRGN hRgn, бул bRedraw);
 цел GetWindowRgn(УОК окно, HRGN hRgn);
 цел ExcludeUpdateRgn(HDC hDC, УОК окно);
 бул InvalidateRect(УОК окно, ПРЯМ *lpRect, бул bErase);
 бул ValidateRect(УОК окно, ПРЯМ *lpRect);
 бул InvalidateRgn(УОК окно, HRGN hRgn, бул bErase);
 бул ValidateRgn(УОК окно, HRGN hRgn);
 бул RedrawWindow(УОК окно, ПРЯМ *lprcUpdate, HRGN hrgnUpdate, бцел флаги);
 
 цел SetScrollPos(УОК окно, цел nBar, цел nPos, бул bRedraw);
 цел GetScrollPos(УОК окно, цел nBar);
 бул SetScrollRange(УОК окно, цел nBar, цел nMinPos, цел nMaxPos, бул bRedraw);
 бул GetScrollRange(УОК окно, цел nBar, LPINT lpMinPos, LPINT lpMaxPos);
 бул ShowScrollBar(УОК окно, цел wBar, бул bShow);
 бул EnableScrollBar(УОК окно, бцел wSBflags, бцел wArrows);

/*
 * LockWindowUpdate API
 */

 бул LockWindowUpdate(УОК hWndLock);
 бул ScrollWindow(УОК окно, цел XAmount, цел YAmount, ПРЯМ* lpRect, ПРЯМ* lpClipRect);
 бул ScrollDC(HDC hDC, цел dx, цел dy, ПРЯМ* lprcScroll, ПРЯМ* lprcClip, HRGN hrgnUpdate, ПРЯМ* lprcUpdate);
 цел ScrollWindowEx(УОК окно, цел dx, цел dy, ПРЯМ* prcScroll, ПРЯМ* prcClip, HRGN hrgnUpdate, ПРЯМ* prcUpdate, бцел флаги);
 
	цел WSAStartup(бкрат wVersionRequested, ВИНСОКДАН* lpWSAData);
	цел WSACleanup();
	СОКЕТ socket(цел af, цел тип, цел protocol);
	цел ioctlsocket(СОКЕТ s, цел cmd, бцел* argp);
	цел bind(СОКЕТ s, адрессок* имя, цел длинаимени);
	цел connect(СОКЕТ s, адрессок* имя, цел длинаимени);
	цел listen(СОКЕТ s, цел backlog);
	СОКЕТ accept(СОКЕТ s, адрессок* адр, цел* addrlen);
	цел closesocket(СОКЕТ s);
	цел shutdown(СОКЕТ s, цел how);
	цел getpeername(СОКЕТ s, адрессок* имя, цел* длинаимени);
	цел getsockname(СОКЕТ s, адрессок* имя, цел* длинаимени);
	цел send(СОКЕТ s, ук буф, цел длин, цел флаги);
	цел sendto(СОКЕТ s, ук буф, цел длин, цел флаги, адрессок* to, цел tolen);
	цел recv(СОКЕТ s, ук буф, цел длин, цел флаги);
	цел recvfrom(СОКЕТ s, ук буф, цел длин, цел флаги, адрессок* from, цел* fromlen);
	цел getsockopt(СОКЕТ s, цел уровень, цел опцимя, ук опцзнач, цел* optlen);
	цел setsockopt(СОКЕТ s, цел уровень, цел опцимя, ук опцзнач, цел optlen);
	бцел inet_addr(ткст0 cp);
	цел select(цел nfds, набор_уд* readfds, набор_уд* writefds, набор_уд* errorfds, значврем* таймаут);
	ткст0 inet_ntoa(адрес_ин ina);
	хостзап* gethostbyname(ткст0 имя);
	хостзап* gethostbyaddr(ук адр, цел длин, цел тип);
	протзап* getprotobyname(ткст0 имя);
	протзап* getprotobynumber(цел номер);
	служзап* getservbyname(ткст0 имя, ткст0 прото);
	служзап* getservbyport(цел port, ткст0 прото);
	цел gethostname(ткст0 имя, цел длинаимени);
	цел getaddrinfo(ткст0 имяузла, ткст0 servname, адринфо* hцелs, адринфо** res);
	проц freeaddrinfo(адринфо* ai);
	цел getnameinfo(адрессок* sa, socklen_t salen, ткст0 host, бцел hostlen, ткст0 serv, бцел servlen, цел флаги);

бул GetWindowInfo(УОК, PWINDOWINFO);
бул EnumDisplayMonitors(HDC, ПРЯМ*, MONITORENUMPROC, LPARAM);
бул GetMonitorInfoA(HMONITOR, LPMONITORINFO);
бул GetBinaryTypeA(ткст0, убцел);
бцел GetShortPathNameA(ткст0, ткст0, бцел);
ткст0 GetEnvironmentStringsA();
бул FreeEnvironmentStringsA(ткст0);
цел lstrcmpA(ткст0, ткст0);
цел lstrcmpiA(ткст0, ткст0);
ткст0 lstrcpynA(ткст0, ткст0, цел);
ткст0 lstrcpyA(ткст0, ткст0);
ткст0 lstrcatA(ткст0, ткст0);
цел lstrlenA(ткст0);
ук OpenMutexA(бцел, бул, ткст0);
ук OpenEventA(бцел, бул, ткст0);
проц FatalAppExitA(бцел);
ткст0 GetCommandLineA();
шткст0 *CommandLineToArgvW(шткст0, цел*); 
бцел ExpandEnvironmentStringsA(ткст0, ткст0, бцел);
проц OutputDebugStringA(ткст0);
HRSRC FindResourceA(экз, ткст0, ткст0);
HRSRC FindResourceExA(экз, ткст0, ткст0, бкрат);
бул EnumResourceTypesA(экз, ENUMRESTYPEPROC, цел);
бул EnumResourceNamesA(экз, ткст0, ENUMRESNAMEPROC, цел);
бул EnumResourceLanguagesA(экз, ткст0, ткст0, ENUMRESLANGPROC, цел);
бул UpdateResourceA(ук, ткст0, ткст0, бкрат, ук, бцел);
бул EndUpdateResourceA(ук, бул);
АТОМ GlobalдобавьAtomA(ткст0);
АТОМ GlobalFindAtomA(ткст0);
бцел GlobalGetAtomNameA(АТОМ, ткст0, цел);
АТОМ добавьAtomA(ткст0);
АТОМ FindAtomA(ткст0);
бцел GetAtomNameA(АТОМ, ткст0, цел);
бцел GetProfileIntA(ткст0, ткст0, цел);
бцел GetProfileStringA(ткст0, ткст0, ткст0, ткст0, бцел);
бул WriteProfileStringA(ткст0, ткст0, ткст0);
бцел GetProfileSectionA(ткст0, ткст0, бцел);
бул WriteProfileSectionA(ткст0, ткст0);
бцел GetPrivateProfileIntA(ткст0, ткст0, цел, ткст0);
бцел GetPrivateProfileStringA(ткст0, ткст0, ткст0, ткст0, бцел, ткст0);
бул WritePrivateProfileStringA(ткст0, ткст0, ткст0, ткст0);
бцел GetPrivateProfileSectionA(ткст0, ткст0, бцел, ткст0);
бул WritePrivateProfileSectionA(ткст0, ткст0, ткст0);
бцел GetDriveTypeA(ткст0);
бцел GetSystemDirectoryA(ткст0, бцел);

бцел GetTempFileNameA(ткст0, ткст0, бцел, ткст0);
бцел GetWindowsDirectoryA(ткст0, бцел);
бул GetDiskFreeSpaceA(ткст0, убцел, убцел, убцел, убцел);
бцел GetFullPathNameA(ткст0, бцел, ткст0, ткст0*);
бцел QueryDosDeviceA(ткст0, ткст0, бцел);

бцел GetCompressedFileSizeA(ткст0, убцел);
бцел SearchPathA(ткст0, ткст0, ткст0, бцел, ткст0, ткст0);

бул GetNamedPipeHandleStateA(ук, убцел, убцел, убцел, убцел, ткст0, бцел);
бул WaitNamedPipeA(ткст0, бцел);
бул SetVolumeLabelA(ткст0, ткст0);

бул GetVolumeInformationA(ткст0, ткст0, бцел, убцел, убцел, убцел, ткст0, бцел);
бул ClearEventLogA(ук, ткст0);
бул BackupEventLogA(ук, ткст0);
ук OpenEventLogA(ткст0, ткст0);
ук RegisterEventSourceA(ткст0, ткст0);
ук OpenBackupEventLogA(ткст0, ткст0);
бул ReadEventLogA(ук, бцел, бцел, ук, бцел, убцел, убцел);
бул ReportEventA(ук, бкрат, бкрат, бцел, УкБИД, бкрат, бцел, ткст0*, ук);
бул AccessCheckAndAuditAlarmA(ткст0, ук, ткст0, ткст0, ДЕСКРБЕЗОП*, бцел, ГЕНМАП*, бул, убцел, бул*, бул*);
бул ObjectOpenAuditAlarmA(ткст0, ук, ткст0, ткст0, ДЕСКРБЕЗОП*, ук, бцел, бцел, НАБОР_ПРИВИЛЕГИЙ*, бул, бул, бул*);
бул ObjectPrivilegeAuditAlarmA(ткст0, ук, ук, бцел, НАБОР_ПРИВИЛЕГИЙ*, бул);
бул ObjectCloseAuditAlarmA(ткст0, ук, бул);
бул PrivilegedServiceAuditAlarmA(ткст0, ткст0, ук, НАБОР_ПРИВИЛЕГИЙ*, бул);
бул SetFileSecurityA(ткст0, ПИнфОБезопасности, ДЕСКРБЕЗОП*);
бул GetFileSecurityA(ткст0, ПИнфОБезопасности, ДЕСКРБЕЗОП*, бцел, убцел);
ук FindFirstChangeNotificationA(ткст0, бул, бцел);
//бул LookupAccountSidA(ткст0, УкБИД, ткст0, убцел, ткст0, убцел, PSID_NAME_USE);
//бул LookupAccountNameA(ткст0, ткст0, УкБИД, убцел, ткст0, убцел, PSID_NAME_USE);
бул LookupPrivilegeValueA(ткст0, ткст0, ЛУИД*);
бул LookupPrivilegeNameA(ткст0, ЛУИД*, ткст0, убцел);
бул LookupPrivilegeDisplayNameA(ткст0, ткст0, ткст0, убцел, убцел);
бул GetDefaultCommConfigA(ткст0, КОММКОНФИГ*, убцел);
бул SetDefaultCommConfigA(ткст0, КОММКОНФИГ*, бцел);
бул GetComputerNameA(ткст0, убцел);
бул SetComputerNameA(ткст0);
бул GetUserNameA(ткст0, убцел);
цел wvsprintfA(ткст0, ткст0, СПИС_ВА*);
HKL LoadKeyboardLayoutA(ткст0, бцел);
бул GetKeyboardLayoutNameA(ткст0);
//HDESK CreateDesktopA(ткст0, ткст0, LPDEVMODE, бцел, бцел, БЕЗАТРЫ*);
HDESK OpenDesktopA(ткст0, бцел, бул, бцел);
//бул EnumDesktopsA(HWINSTA, DESKTOPENUMPROC, LPARAM);
HWINSTA CreateWindowStationA(ткст0, бцел, бцел, БЕЗАТРЫ*);
HWINSTA OpenWindowStationA(ткст0, бул, бцел);
//бул EnumWindowStationsA(ENUMWINDOWSTATIONPROC, LPARAM);
бул GetUserObjectInformationA(ук, цел, ук, бцел, убцел);
бул SetUserObjectInformationA(ук, цел, ук, бцел);
бцел RegisterWindowMessageA(ткст0);
бул GetMessageA(СООБ*, УОК, бцел, бцел);
цел DispatchMessageA(СООБ*);
бул PeekMessageA(СООБ*, УОК, бцел, бцел, бцел);
LRESULT SendMessageA(УОК, бцел, WPARAM, LPARAM);
LRESULT SendMessageA(УОК, бцел, ук, LPARAM);
LRESULT SendMessageA(УОК, бцел, WPARAM, ук);
LRESULT SendMessageA(УОК, бцел, ук, ук);
LRESULT SendMessageTimeoutA(УОК, бцел, WPARAM, LPARAM, бцел, бцел, убцел);
бул SendNotifyMessageA(УОК, бцел, WPARAM, LPARAM);
бул SendMessageCallbackA(УОК, бцел, WPARAM, LPARAM, SENDASYNCPROC, бцел);
бул PostMessageA(УОК, бцел, WPARAM, LPARAM);
бул PostThreadMessageA(бцел, бцел, WPARAM, LPARAM);
LRESULT DefWindowProcA(УОК, бцел, WPARAM, LPARAM);
LRESULT CallWindowProcA(ОКОНПРОЦ, УОК, бцел, WPARAM, LPARAM);
АТОМ RegisterClassA(КЛАССОК_А*);
бул UnregisterClassA(ткст0, экз);
бул GetClassInfoA(экз, ткст0, КЛАССОК_А*);
АТОМ RegisterClassExA(КЛАССОКДОП_А*);
бул GetClassInfoExA(экз, ткст0, КЛАССОКДОП_А*);
УОК CreateWindowExA(бцел, ткст0, ткст0, бцел, цел, цел, цел, цел, УОК, HMENU, экз, ук);
УОК CreateDialogParamA(экз, ткст0, УОК, DLGPROC, LPARAM);
УОК CreateDialogIndirectParamA(экз, LPCDLGTEMPLATE, УОК, DLGPROC, LPARAM);
цел DialogBoxParamA(экз, ткст0, УОК, DLGPROC, LPARAM);
цел DialogBoxIndirectParamA(экз, LPCDLGTEMPLATE, УОК, DLGPROC, LPARAM);
бул SetDlgItemTextA(УОК, цел, ткст0);
бцел GetDlgItemTextA(УОК, цел, ткст0, цел);
цел SendDlgItemMessageA(УОК, цел, бцел, WPARAM, LPARAM);
LRESULT DefDlgProcA(УОК, бцел, WPARAM, LPARAM);
бул CallMsgFilterA(СООБ*, цел);
бцел RegisterClipboardFormatA(ткст0);
цел GetClipboardFormatNameA(бцел, ткст0, цел);
бул CharToOemA(ткст0, ткст0);
бул OemToCharA(ткст0, ткст0);
бул CharToOemBuffA(ткст0, ткст0, бцел);
бул OemToCharBuffA(ткст0, ткст0, бцел);
ткст0 CharUpperA(ткст0);
бцел CharUpperBuffA(ткст0, бцел);
ткст0 CharLowerA(ткст0);
бцел CharLowerBuffA(ткст0, бцел);
ткст0 CharNextA(ткст0);
ткст0 CharPrevA(ткст0, ткст0);
бул IsCharAlphaA(сим);
бул IsCharAlphaNumericA(сим);
бул IsCharUpperA(сим);
бул IsCharLowerA(сим);
цел GetKeyNameTextA(цел, ткст0, цел);
SHORT VkKeyScanA(сим);
SHORT VkKeyScanExA(сим, HKL);
бцел MapVirtualKeyA(бцел, бцел);
бцел MapVirtualKeyExA(бцел, бцел, HKL);
HACCEL LoadAcceleratorsA(экз, ткст0);
//HACCEL CreateAcceleratorTableA(LPACCEL, цел);
//цел CopyAcceleratorTableA(HACCEL, LPACCEL, цел);
цел TranslateAcceleratorA(УОК, HACCEL, СООБ*);
HMENU LoadMenuA(экз, ткст0);
//HMENU LoadMenuIndirectA(LPMENUTEMPLATE);
бул ChangeMenuA(HMENU, бцел, ткст0, бцел, бцел);
цел GetMenuStringA(HMENU, бцел, ткст0, цел, бцел);
бул InsertMenuA(HMENU, бцел, бцел, бцел, ткст0);
бул AppendMenuA(HMENU, бцел, бцел, ткст0);
бул ModifyMenuA(HMENU, бцел, бцел, бцел, ткст0);
//бул InsertMenuItemA(HMENU, бцел, бул, LPCMENUITEMINFO);
//бул GetMenuItemInfoA(HMENU, бцел, бул, LPMENUITEMINFO);
//бул SetMenuItemInfoA(HMENU, бцел, бул, LPCMENUITEMINFO);
цел DrawTextA(HDC, ткст0, цел, ПРЯМ*, бцел);
//цел DrawTextExA(HDC, ткст0, цел, ПРЯМ*, бцел, LPDRAWTEXTPARAMS);
бул GrayStringA(HDC, HBRUSH, GRAYSTRINGPROC, LPARAM, цел, цел, цел, цел, цел);
бул DrawStateA(HDC, HBRUSH, DRAWSTATEPROC, LPARAM, WPARAM, цел, цел, цел, цел, бцел);
цел TabbedTextOutA(HDC, цел, цел, ткст0, цел, цел, LPINT, цел);
бцел GetTabbedTextExtentA(HDC, ткст0, цел, цел, LPINT);
бул SetPropA(УОК, ткст0, ук);
ук GetPropA(УОК, ткст0);
ук RemovePropA(УОК, ткст0);
//цел EnumPropsExA(УОК, PROPENUMPROCEX, LPARAM);
//цел EnumPropsA(УОК, PROPENUMPROC);
бул SetWindowTextA(УОК, ткст0);
цел GetWindowTextA(УОК, ткст0, цел);
цел GetWindowTextLengthA(УОК);
//цел MessageBoxIndirectA(LPMSGBOXPARAMS);
цел GetWindowLongA(УОК, цел);
цел SetWindowLongA(УОК, цел, цел);
бцел GetClassLongA(УОК, цел);
бцел SetClassLongA(УОК, цел, цел);
УОК FindWindowA(ткст0, ткст0);
УОК FindWindowExA(УОК, УОК, ткст0, ткст0);
цел GetClassNameA(УОК, ткст0, цел);
//HHOOK SetWindowsHookExA(цел, HOOKPROC, экз, бцел);
УБитмап LoadBitmapA(экз, ткст0);
HCURSOR LoadCursorA(экз, ткст0);
HCURSOR LoadCursorFromFileA(ткст0);
УИконка LoadIconA(экз, ткст0);
ук LoadImageA(экз, ткст0, бцел, цел, цел, бцел);
цел LoadStringA(экз, бцел, ткст0, цел);
бул IsDialogMessageA(УОК, СООБ*);
цел DlgDirListA(УОК, ткст0, цел, цел, бцел);
бул DlgDirSelectExA(УОК, ткст0, цел, цел);
цел DlgDirListComboBoxA(УОК, ткст0, цел, цел, бцел);
бул DlgDirSelectComboBoxExA(УОК, ткст0, цел, цел);
LRESULT DefFrameProcA(УОК, УОК, бцел, WPARAM, LPARAM);
LRESULT DefMDIChildProcA(УОК, бцел, WPARAM, LPARAM);
УОК CreateMDIWindowA(ткст0, ткст0, бцел, цел, цел, цел, цел, УОК, экз, LPARAM);
бул WinHelpA(УОК, ткст0, бцел, бцел);
//цел ChangeDisplaySettingsA(LPDEVMODE, бцел);
//бул EnumDisplaySettingsA(ткст0, бцел, LPDEVMODE);
бул SystemParametersInfoA(бцел, бцел, ук, бцел);
цел добавьFontResourceA(ткст0);
HMETAFILE CopyMetaFileA(HMETAFILE, ткст0);
HFONT CreateFontIndirectA(ЛОГ_ШРИФТА*);
//HDC CreateICA(ткст0, ткст0, ткст0, LPDEVMODE);
HDC CreateMetaFileA(ткст0);
бул CreateScalableFontResourceA(бцел, ткст0, ткст0, ткст0);
//цел EnumFontFamiliesExA(HDC, ЛОГ_ШРИФТА*, FONTENUMEXPROC, LPARAM, бцел);
//цел EnumFontFamiliesA(HDC, ткст0, FONTENUMPROC, LPARAM);
//цел EnumFontsA(HDC, ткст0, ENUMFONTSPROC, LPARAM);
бул GetCharWidthA(HDC, бцел, бцел, LPINT);
бул GetCharWidth32A(HDC, бцел, бцел, LPINT);
бул GetCharWidthFloatA(HDC, бцел, бцел, PFLOAT);
//бул GetCharABCWidthsA(HDC, бцел, бцел, LPABC);
//бул GetCharABCWidthsFloatA(HDC, бцел, бцел, LPABCFLOAT);
//бцел GetGlyphOutlineA(HDC, бцел, бцел, LPGLYPHMETRICS, бцел, ук, PMAT2);
HMETAFILE GetMetaFileA(ткст0);
//бцел GetOutlineTextMetricsA(HDC, бцел, LPOUTLINETEXTMETRIC);
бул GetTextExtentPoцелA(HDC, ткст0, цел, РАЗМЕР*);
бул GetTextExtentPoцел32A(HDC, ткст0, цел, РАЗМЕР*);
бул GetTextExtentExPoцелA(HDC, ткст0, цел, цел, LPINT, LPINT, РАЗМЕР*);
//бцел GetCharacterPlacementA(HDC, ткст0, цел, цел, LPGCP_RESULTS, бцел);
//HDC ResetDCA(HDC, LPDEVMODE);
бул RemoveFontResourceA(ткст0);
HENHMETAFILE CopyEnhMetaFileA(HENHMETAFILE, ткст0);
HDC CreateEnhMetaFileA(HDC, ткст0, ПРЯМ*, ткст0);
HENHMETAFILE GetEnhMetaFileA(ткст0);
бцел GetEnhMetaFileDescriptionA(HENHMETAFILE, бцел, ткст0);
//бул GetTextMetricsA(HDC, LPTEXTMETRIC);
//цел StartDocA(HDC, PDOCINFO);
цел GetObjectA(HGDIOBJ, цел, ук);
бул TextOutA(HDC, цел, цел, ткст0, цел);
бул ExtTextOutA(HDC, цел, цел, бцел, ПРЯМ*, ткст0, бцел, LPINT);
//бул PolyTextOutA(HDC, PPOLYTEXT, цел);
цел GetTextFaceA(HDC, цел, ткст0);
//бцел GetKerningPairsA(HDC, бцел, LPKERNINGPAIR);
//HCOLORSPACE CreateColorSpaceA(LPLOGCOLORSPACE);
//бул GetLogColorSpaceA(HCOLORSPACE, LPLOGCOLORSPACE, бцел);
бул GetICMProfileA(HDC, бцел, ткст0);
бул SetICMProfileA(HDC, ткст0);
бул UpdateICMRegKeyA(бцел, бцел, ткст0, бцел);
//цел EnumICMProfilesA(HDC, ICMENUMPROC, LPARAM);
//цел PropertySheetA(LPCPROPSHEETHEADER);
УСписокКартинок ImageList_LoadImageA(экз, ткст0, цел, цел, ЦВПредст, бцел, бцел);
УОК CreateStatusWindowA(цел, ткст0, УОК, бцел);
проц DrawStatusTextA(HDC, ПРЯМ*, ткст0);
бул GetOpenFileNameA(ОТКРФАЙЛ_А*);
бул GetSaveFileNameA(ОТКРФАЙЛ_А*);
цел GetFileTitleA(ткст0, ткст0, бкрат);
//бул ChooseColorA(LPCHOOSECOLOR);
//УОК FindTextA(LPFINDREPLACE);
//УОК ReplaceTextA(LPFINDREPLACE);
//бул ChooseFontA(LPCHOOSEFONTA);
//бул PrцелDlgA(LPPRINTDLGA);
//бул PageSetupDlgA(LPPAGESETUPDLG);
проц GetStartupInfoA(ИНФОСТАРТА*);
//HDC CreateDCA(ткст0, ткст0, ткст0, PDEVMODE);
бцел VerInstallFileA(бцел, ткст0, ткст0, ткст0, ткст0, ткст0, ткст0, бцел*);
бцел GetFileVersionInfoSizeA(ткст0, убцел);
бул GetFileVersionInfoA(ткст0, бцел, бцел, ук);
бцел VerLanguageNameA(бцел, ткст0, бцел);
бул VerQueryValueA(ук, ткст0, ук, бцел*);
бцел VerFindFileA(бцел, ткст0, ткст0, ткст0, ткст0, бцел*, ткст0, бцел*);
цел RegConnectRegistryA(ткст0, HKEY, PHKEY);
цел RegCreateKeyA(HKEY, ткст0, PHKEY);
цел RegEnumKeyA(HKEY, бцел, ткст0, бцел);
цел RegLoadKeyA(HKEY, ткст0, ткст0);
//цел RegQueryMultipleValuesA(HKEY, PVALENT, бцел, ткст0, убцел);
цел RegQueryValueExA(HKEY, ткст0, убцел, убцел, уббайт, убцел);
цел RegReplaceKeyA(HKEY, ткст0, ткст0, ткст0);
цел RegRestoreKeyA(HKEY, ткст0, бцел);
цел RegSaveKeyA(HKEY, ткст0, БЕЗАТРЫ*);
цел RegSetValueA(HKEY, ткст0, бцел, ткст0, бцел);
цел RegUnLoadKeyA(HKEY, ткст0);
бул InitiateSystemShutdownA(ткст0, ткст0, бцел, бул, бул);
бул AbortSystemShutdownA(ткст0);
цел LCMapStringA(ЛКИД, бцел, ткст0, цел, ткст0, цел);
цел GetLocaleInfoA(ЛКИД, т_локаль, ткст0, цел);
бул SetLocaleInfoA(ЛКИД, т_локаль, ткст0);
цел GetTimeFormatA(ЛКИД, бцел, СИСТВРЕМЯ*, ткст0, ткст0, цел);
цел GetDateFormatA(ЛКИД, бцел, СИСТВРЕМЯ*, ткст0, ткст0, цел);
цел GetNumberFormatA(ЛКИД, бцел, ткст0, УкФМТЧИСЛА, ткст0, цел);
цел GetCurrencyFormatA(ЛКИД, бцел, ткст0, УкФМТВАЛЮТЫ, ткст0, цел);
//бул EnumCalendarInfoA(CALINFO_ENUMPROC, ЛКИД, CALID, CALTYPE);
//бул EnumTimeFormatsA(TIMEFMT_ENUMPROC, ЛКИД, бцел);
//бул EnumDateFormatsA(DATEFMT_ENUMPROC, ЛКИД, бцел);
бул GetStringTypeExA(ЛКИД, бцел, ткст0, цел, бкрат*);
бул GetStringTypeA(ЛКИД, бцел, ткст0, цел, бкрат*);
цел FoldStringA(бцел, ткст0, цел, ткст0, цел);
//бул EnumSystemLocalesA(LOCALE_ENUMPROC, бцел);
//бул EnumSystemCodePagesA(CODEPAGE_ENUMPROC, бцел);
бул FillConsoleOutputCharacterA(ук, сим, бцел, КООРД, убцел);
бцел WNetAddConnectionA(ткст0, ткст0, ткст0);
//бцел WNetAddConnection2A(LPNETRESOURCE, ткст0, ткст0, бцел);
//бцел WNetAddConnection3A(УОК, LPNETRESOURCE, ткст0, ткст0, бцел);
бцел WNetCancelConnectionA(ткст0, бул);
бцел WNetCancelConnection2A(ткст0, бцел, бул);
бцел WNetGetConnectionA(ткст0, ткст0, убцел);
//бцел WNetUseConnectionA(УОК, LPNETRESOURCE, ткст0, ткст0, бцел, ткст0, убцел, убцел);
бцел WNetSetConnectionA(ткст0, бцел, ук);
//бцел WNetConnectionDialog1A(LPCONNECTDLGSTRUCT);
//бцел WNetDisconnectDialog1A(LPDISCDLGSTRUCT);
//бцел WNetOpenEnumA(бцел, бцел, бцел, LPNETRESOURCE, ук);
бцел WNetEnumResourceA(ук, убцел, ук, убцел);
бцел WNetGetUniversalNameA(ткст0, бцел, ук, убцел);
бцел WNetGetUserA(ткст0, ткст0, убцел);
бцел WNetGetProviderNameA(бцел, ткст0, убцел);
//бцел WNetGetNetworkInformationA(ткст0, LPNETINFOSTRUCT);
бцел WNetGetLastErrorA(убцел, ткст0, бцел, ткст0, бцел);
//бцел MultinetGetConnectionPerformanceA(LPNETRESOURCE, LPNETCONNECTINFOSTRUCT);
бул ChangeServiceConfigA(SC_HANDLE, бцел, бцел, бцел, ткст0, ткст0, убцел, ткст0, ткст0, ткст0, ткст0);
SC_HANDLE CreateServiceA(SC_HANDLE, ткст0, ткст0, бцел, бцел, бцел, бцел, ткст0, ткст0, убцел, ткст0, ткст0, ткст0);
//бул EnumDependentServicesA(SC_HANDLE, бцел, LPENUM_SERVICE_STATUS, бцел, убцел, убцел);
//бул EnumServicesStatusA(SC_HANDLE, бцел, бцел, LPENUM_SERVICE_STATUS, бцел, убцел, убцел, убцел);
бул GetServiceKeyNameA(SC_HANDLE, ткст0, ткст0, убцел);
бул GetServiceDisplayNameA(SC_HANDLE, ткст0, ткст0, убцел);
SC_HANDLE OpenSCManagerA(ткст0, ткст0, бцел);
SC_HANDLE OpenServiceA(SC_HANDLE, ткст0, бцел);
//бул QueryServiceConfigA(SC_HANDLE, LPQUERY_SERVICE_CONFIG, бцел, убцел);
//бул QueryServiceLockStatusA(SC_HANDLE, LPQUERY_SERVICE_LOCK_STATUS, бцел, убцел);
//SERVICE_STATUS_HANDLE RegisterServiceCtrlHandlerA(ткст0, HANDLER_FUNCTION);
//бул StartServiceCtrlDispatcherA(LPSERVICE_TABLE_ENTRY);
бул StartServiceA(SC_HANDLE, бцел, ткст0);
//бцел DragQueryFileA(HDROP, бцел, PCHAR, бцел);
УИконка ExtractAssociatedIconA(экз, PCHAR, бкрат*);
УИконка ExtractIconA(экз, PCHAR, бцел);
экз FindExecutableA(PCHAR, PCHAR, PCHAR);
цел ShellAboutA(УОК, PCHAR, PCHAR, УИконка);
экз ShellExecuteA(УОК, PCHAR, PCHAR, PCHAR, PCHAR, цел);
//HSZ DdeCreateStringHandleA(бцел, PCHAR, цел);
//бцел DdeInitializeA(убцел, PFNCALLBACK, бцел, бцел);
//бцел DdeQueryStringA(бцел, HSZ, PCHAR, бцел, цел);
бул LogonUserA(ткст0, ткст0, ткст0, бцел, бцел, ук);
бул GetBinaryTypeW(шткст0, убцел);
бцел GetShortPathNameW(шткст0, шткст0, бцел);
шткст0 GetEnvironmentStringsW();
бул FreeEnvironmentStringsW(шткст0);
цел lstrcmpW(шткст0, шткст0);
цел lstrcmpiW(шткст0, шткст0);
шткст0 lstrcpynW(шткст0, шткст0, цел);
шткст0 lstrcpyW(шткст0, шткст0);
шткст0 lstrcatW(шткст0, шткст0);
цел lstrlenW(шткст0);
ук OpenMutexW(бцел, бул, шткст0);
ук OpenEventW(бцел, бул, шткст0);
ук OpenSemaphoreW(бцел, бул, шткст0);
бцел GetLogicalDriveStringsW(бцел, шткст0);
бцел GetModuleFileNameW(экз, шткст0, бцел);
экз GetModuleHandleW(шткст0);
проц FatalAppExitW(бцел);
бцел GetEnvironmentVariableW(шткст0, шткст0, бцел);
бул SetEnvironmentVariableW(шткст0, шткст0);
бцел GetEnvironmentVariableA(ткст0, ткст0 , бцел);
бул SetEnvironmentVariableA(ткст0, ткст0);
бцел ExpandEnvironmentStringsW(шткст0, шткст0, бцел);
проц OutputDebugStringW(шткст0);
HRSRC FindResourceW(экз, шткст0, шткст0);
HRSRC FindResourceExW(экз, шткст0, шткст0, бкрат);
бул EnumResourceTypesW(экз, ENUMRESTYPEPROC, цел);
бул EnumResourceNamesW(экз, шткст0, ENUMRESNAMEPROC, цел);
бул EnumResourceLanguagesW(экз, шткст0, шткст0, ENUMRESLANGPROC, цел);
бул UpdateResourceW(ук, шткст0, шткст0, бкрат, ук, бцел);
бул EndUpdateResourceW(ук, бул);
АТОМ GlobalдобавьAtomW(шткст0);
АТОМ GlobalFindAtomW(шткст0);
бцел GlobalGetAtomNameW(АТОМ, шткст0, цел);
АТОМ добавьAtomW(шткст0);
АТОМ FindAtomW(шткст0);
бцел GetAtomNameW(АТОМ, шткст0, цел);
бцел GetProfileIntW(шткст0, шткст0, цел);
бцел GetProfileStringW(шткст0, шткст0, шткст0, шткст0, бцел);
бул WriteProfileStringW(шткст0, шткст0, шткст0);
бцел GetProfileSectionW(шткст0, шткст0, бцел);
бул WriteProfileSectionW(шткст0, шткст0);
бцел GetPrivateProfileIntW(шткст0, шткст0, цел, шткст0);
бцел GetPrivateProfileStringW(шткст0, шткст0, шткст0, шткст0, бцел, шткст0);
бул WritePrivateProfileStringW(шткст0, шткст0, шткст0, шткст0);
бцел GetPrivateProfileSectionW(шткст0, шткст0, бцел, шткст0);
бул WritePrivateProfileSectionW(шткст0, шткст0, шткст0);
бцел GetDriveTypeW(шткст0);
бцел GetSystemDirectoryW(шткст0, бцел);

бцел GetTempFileNameW(шткст0, шткст0, бцел, шткст0);
бцел GetWindowsDirectoryW(шткст0, бцел);
бул GetDiskFreeSpaceW(шткст0, убцел, убцел, убцел, убцел);
бцел GetFullPathNameW(шткст0, бцел, шткст0, шткст0*);
бцел QueryDosDeviceW(шткст0, шткст0, бцел);

бцел GetCompressedFileSizeW(шткст0, убцел);
бцел SearchPathW(шткст0, шткст0, шткст0, бцел, шткст0, шткст0);

бул GetNamedPipeHandleStateW(ук, убцел, убцел, убцел, убцел, шткст0, бцел);
бул WaitNamedPipeW(шткст0, бцел);
бул SetVolumeLabelW(шткст0, шткст0);

бул GetVolumeInformationW(шткст0, шткст0, бцел, убцел, убцел, убцел, шткст0, бцел);
бул ClearEventLogW(ук, шткст0);
бул BackupEventLogW(ук, шткст0);
ук OpenEventLogW(шткст0, шткст0);
ук RegisterEventSourceW(шткст0, шткст0);
ук OpenBackupEventLogW(шткст0, шткст0);
бул ReadEventLogW(ук, бцел, бцел, ук, бцел, убцел, убцел);
бул ReportEventW(ук, бкрат, бкрат, бцел, УкБИД, бкрат, бцел, шткст0*, ук);
бул AccessCheckAndAuditAlarmW(шткст0, ук, шткст0, шткст0, ДЕСКРБЕЗОП*, бцел, ГЕНМАП*, бул, убцел, бул*, бул*);
бул ObjectOpenAuditAlarmW(шткст0, ук, шткст0, шткст0, ДЕСКРБЕЗОП*, ук, бцел, бцел, НАБОР_ПРИВИЛЕГИЙ*, бул, бул, бул*);
бул ObjectPrivilegeAuditAlarmW(шткст0, ук, ук, бцел, НАБОР_ПРИВИЛЕГИЙ*, бул);
бул ObjectCloseAuditAlarmW(шткст0, ук, бул);
бул PrivilegedServiceAuditAlarmW(шткст0, шткст0, ук, НАБОР_ПРИВИЛЕГИЙ*, бул);
бул SetFileSecurityW(шткст0, ПИнфОБезопасности, ДЕСКРБЕЗОП*);
бул GetFileSecurityW(шткст0, ПИнфОБезопасности, ДЕСКРБЕЗОП*, бцел, убцел);
ук FindFirstChangeNotificationW(шткст0, бул, бцел);
//бул LookupAccountSidW(шткст0, УкБИД, шткст0, убцел, шткст0, убцел, PSID_NAME_USE);
//бул LookupAccountNameW(шткст0, шткст0, УкБИД, убцел, шткст0, убцел, PSID_NAME_USE);
бул LookupPrivilegeValueW(шткст0, шткст0, ЛУИД*);
бул LookupPrivilegeNameW(шткст0, ЛУИД*, шткст0, убцел);
бул LookupPrivilegeDisplayNameW(шткст0, шткст0, шткст0, убцел, убцел);
бул BuildCommDCBAndTimeoutsW(шткст0, СКУ*, КОММТАЙМАУТЫ*);
бул GetDefaultCommConfigW(шткст0, КОММКОНФИГ*, убцел);
бул SetDefaultCommConfigW(шткст0, КОММКОНФИГ*, бцел);
бул GetComputerNameW(шткст0, убцел);
бул SetComputerNameW(шткст0);
бул GetUserNameW(шткст0, убцел);
цел wvsprintfW(шткст0, шткст0, СПИС_ВА*);
HKL LoadKeyboardLayoutW(шткст0, бцел);
бул GetKeyboardLayoutNameW(шткст0);
//HDESK CreateDesktopW(шткст0, шткст0, LPDEVMODE, бцел, бцел, БЕЗАТРЫ*);
HDESK OpenDesktopW(шткст0, бцел, бул, бцел);
//бул EnumDesktopsW(HWINSTA, DESKTOPENUMPROC, LPARAM);
HWINSTA CreateWindowStationW(шткст0, бцел, бцел, БЕЗАТРЫ*);
HWINSTA OpenWindowStationW(шткст0, бул, бцел);
//бул EnumWindowStationsW(ENUMWINDOWSTATIONPROC, LPARAM);
бул GetUserObjectInformationW(ук, цел, ук, бцел, убцел);
бул SetUserObjectInformationW(ук, цел, ук, бцел);
бцел RegisterWindowMessageW(шткст0);
бул GetMessageW(СООБ*, УОК, бцел, бцел);
цел DispatchMessageW(СООБ*);
бул PeekMessageW(СООБ*, УОК, бцел, бцел, бцел);
LRESULT SendMessageW(УОК, бцел, WPARAM, LPARAM);
LRESULT SendMessageW(УОК, бцел, WPARAM, ук);
LRESULT SendMessageW(УОК, бцел, ук, LPARAM);
LRESULT SendMessageW(УОК, бцел, ук, ук);
LRESULT SendMessageTimeoutW(УОК, бцел, WPARAM, LPARAM, бцел, бцел, убцел);
бул SendNotifyMessageW(УОК, бцел, WPARAM, LPARAM);
бул SendMessageCallbackW(УОК, бцел, WPARAM, LPARAM, SENDASYNCPROC, бцел);
бул PostMessageW(УОК, бцел, WPARAM, LPARAM);
бул PostThreadMessageW(бцел, бцел, WPARAM, LPARAM);
LRESULT DefWindowProcW(УОК, бцел, WPARAM, LPARAM);
LRESULT CallWindowProcW(ОКОНПРОЦ, УОК, бцел, WPARAM, LPARAM);
АТОМ RegisterClassW(КЛАССОК*);
бул UnregisterClassW(шткст0, экз);
бул GetClassInfoW(экз, шткст0, КЛАССОК*);
АТОМ RegisterClassExW(КЛАССОКДОП*);
бул GetClassInfoExW(экз, шткст0, КЛАССОКДОП*);
УОК CreateWindowExW(бцел, шткст0, шткст0, бцел, цел, цел, цел, цел, УОК, HMENU, экз, ук);
УОК CreateDialogParamW(экз, шткст0, УОК, DLGPROC, LPARAM);
//УОК CreateDialogIndirectParamW(экз, LPCDLGTEMPLATE, УОК, DLGPROC, LPARAM);
цел DialogBoxParamW(экз, шткст0, УОК, DLGPROC, LPARAM);
//цел DialogBoxIndirectParamW(экз, LPCDLGTEMPLATE, УОК, DLGPROC, LPARAM);
бул SetDlgItemTextW(УОК, цел, шткст0);
бцел GetDlgItemTextW(УОК, цел, шткст0, цел);
цел SendDlgItemMessageW(УОК, цел, бцел, WPARAM, LPARAM);
LRESULT DefDlgProcW(УОК, бцел, WPARAM, LPARAM);
бул CallMsgFilterW(СООБ*, цел);
бцел RegisterClipboardFormatW(шткст0);
цел GetClipboardFormatNameW(бцел, шткст0, цел);
бул CharToOemW(шткст0, ткст0);
бул OemToCharW(ткст0, шткст0);
бул CharToOemBuffW(шткст0, ткст0, бцел);
бул OemToCharBuffW(ткст0, шткст0, бцел);
шткст0 CharUpperW(шткст0);
бцел CharUpperBuffW(шткст0, бцел);
шткст0 CharLowerW(шткст0);
бцел CharLowerBuffW(шткст0, бцел);
шткст0 CharNextW(шткст0);
шткст0 CharPrevW(шткст0, шткст0);
бул IsCharAlphaW(WCHAR);
бул IsCharAlphaNumericW(WCHAR);
бул IsCharUpperW(WCHAR);
бул IsCharLowerW(WCHAR);
цел GetKeyNameTextW(цел, шткст0, цел);
SHORT VkKeyScanW(WCHAR);
SHORT VkKeyScanExW(WCHAR, HKL);
бцел MapVirtualKeyW(бцел, бцел);
бцел MapVirtualKeyExW(бцел, бцел, HKL);
HACCEL LoadAcceleratorsW(экз, шткст0);
//HACCEL CreateAcceleratorTableW(LPACCEL, цел);
//цел CopyAcceleratorTableW(HACCEL, LPACCEL, цел);
цел TranslateAcceleratorW(УОК, HACCEL, СООБ*);
HMENU LoadMenuW(экз, шткст0);
//HMENU LoadMenuIndirectW(LPMENUTEMPLATE);
бул ChangeMenuW(HMENU, бцел, шткст0, бцел, бцел);
цел GetMenuStringW(HMENU, бцел, шткст0, цел, бцел);
бул InsertMenuW(HMENU, бцел, бцел, бцел, шткст0);
бул AppendMenuW(HMENU, бцел, бцел, шткст0);
бул ModifyMenuW(HMENU, бцел, бцел, бцел, шткст0);
//бул InsertMenuItemW(HMENU, бцел, бул, LPCMENUITEMINFO);
//бул GetMenuItemInfoW(HMENU, бцел, бул, LPMENUITEMINFO);
//бул SetMenuItemInfoW(HMENU, бцел, бул, LPCMENUITEMINFO);
цел DrawTextW(HDC, шткст0, цел, ПРЯМ*, бцел);
//цел DrawTextExW(HDC, шткст0, цел, ПРЯМ*, бцел, LPDRAWTEXTPARAMS);
бул GrayStringW(HDC, HBRUSH, GRAYSTRINGPROC, LPARAM, цел, цел, цел, цел, цел);
бул DrawStateW(HDC, HBRUSH, DRAWSTATEPROC, LPARAM, WPARAM, цел, цел, цел, цел, бцел);
цел TabbedTextOutW(HDC, цел, цел, шткст0, цел, цел, LPINT, цел);
бцел GetTabbedTextExtentW(HDC, шткст0, цел, цел, LPINT);
бул SetPropW(УОК, шткст0, ук);
ук GetPropW(УОК, шткст0);
ук RemovePropW(УОК, шткст0);
//цел EnumPropsExW(УОК, PROPENUMPROCEX, LPARAM);
//цел EnumPropsW(УОК, PROPENUMPROC);
бул SetWindowTextW(УОК, шткст0);
цел GetWindowTextW(УОК, шткст0, цел);
цел GetWindowTextLengthW(УОК);
//цел MessageBoxIndirectW(LPMSGBOXPARAMS);
цел GetWindowLongW(УОК, цел);
цел SetWindowLongW(УОК, цел, цел);
бцел GetClassLongW(УОК, цел);
бцел SetClassLongW(УОК, цел, цел);
УОК FindWindowW(шткст0, шткст0);
УОК FindWindowExW(УОК, УОК, шткст0, шткст0);
цел GetClassNameW(УОК, шткст0, цел);
//HHOOK SetWindowsHookExW(цел, HOOKPROC, экз, бцел);
УБитмап LoadBitmapW(экз, шткст0);
HCURSOR LoadCursorW(экз, шткст0);
HCURSOR LoadCursorFromFileW(шткст0);
УИконка LoadIconW(экз, шткст0);
ук LoadImageW(экз, шткст0, бцел, цел, цел, бцел);
цел LoadStringW(экз, бцел, шткст0, цел);
бул IsDialogMessageW(УОК, СООБ*);
цел DlgDirListW(УОК, шткст0, цел, цел, бцел);
бул DlgDirSelectExW(УОК, шткст0, цел, цел);
цел DlgDirListComboBoxW(УОК, шткст0, цел, цел, бцел);
бул DlgDirSelectComboBoxExW(УОК, шткст0, цел, цел);
LRESULT DefFrameProcW(УОК, УОК, бцел, WPARAM, LPARAM);
LRESULT DefMDIChildProcW(УОК, бцел, WPARAM, LPARAM);
УОК CreateMDIWindowW(шткст0, шткст0, бцел, цел, цел, цел, цел, УОК, экз, LPARAM);
бул WinHelpW(УОК, шткст0, бцел, бцел);
//цел ChangeDisplaySettingsW(LPDEVMODE, бцел);
//бул EnumDisplaySettingsW(шткст0, бцел, LPDEVMODE);
бул SystemParametersInfoW(бцел, бцел, ук, бцел);
цел добавьFontResourceW(шткст0);
HMETAFILE CopyMetaFileW(HMETAFILE, шткст0);
HFONT CreateFontIndirectW(УкЛОГШРИФТ);
HFONT CreateFontW(цел, цел, цел, цел, цел, бцел, бцел, бцел, бцел, бцел, бцел, бцел, бцел, шткст0);
//HDC CreateICW(шткст0, шткст0, шткст0, LPDEVMODE);
HDC CreateMetaFileW(шткст0);
бул CreateScalableFontResourceW(бцел, шткст0, шткст0, шткст0);
//цел EnumFontFamiliesExW(HDC, LPLOGFONT, FONTENUMEXPROC, LPARAM, бцел);
//цел EnumFontFamiliesW(HDC, шткст0, FONTENUMPROC, LPARAM);
//цел EnumFontsW(HDC, шткст0, ENUMFONTSPROC, LPARAM);
бул GetCharWidthW(HDC, бцел, бцел, LPINT);
бул GetCharWidth32W(HDC, бцел, бцел, LPINT);
бул GetCharWidthFloatW(HDC, бцел, бцел, PFLOAT);
//бул GetCharABCWidthsW(HDC, бцел, бцел, LPABC);
//бул GetCharABCWidthsFloatW(HDC, бцел, бцел, LPABCFLOAT);
//бцел GetGlyphOutlineW(HDC, бцел, бцел, LPGLYPHMETRICS, бцел, ук, PMAT2);
HMETAFILE GetMetaFileW(шткст0);
//бцел GetOutlineTextMetricsW(HDC, бцел, LPOUTLINETEXTMETRIC);
бул GetTextExtentPoцелW(HDC, шткст0, цел, РАЗМЕР*);
бул GetTextExtentPoцел32W(HDC, шткст0, цел, РАЗМЕР*);
бул GetTextExtentExPoцелW(HDC, шткст0, цел, цел, LPINT, LPINT, РАЗМЕР*);
//бцел GetCharacterPlacementW(HDC, шткст0, цел, цел, LPGCP_RESULTS, бцел);
//HDC ResetDCW(HDC, LPDEVMODE);
бул RemoveFontResourceW(шткст0);
HENHMETAFILE CopyEnhMetaFileW(HENHMETAFILE, шткст0);
HDC CreateEnhMetaFileW(HDC, шткст0, ПРЯМ*, шткст0);
HENHMETAFILE GetEnhMetaFileW(шткст0);
бцел GetEnhMetaFileDescriptionW(HENHMETAFILE, бцел, шткст0);
//бул GetTextMetricsW(HDC, LPTEXTMETRIC);
//цел StartDocW(HDC, PDOCINFO);
цел GetObjectW(HGDIOBJ, цел, ук);
бул TextOutW(HDC, цел, цел, шткст0, цел);
бул ExtTextOutW(HDC, цел, цел, бцел, ПРЯМ*, шткст0, бцел, LPINT);
//бул PolyTextOutW(HDC, PPOLYTEXT, цел);
цел GetTextFaceW(HDC, цел, шткст0);
//бцел GetKerningPairsW(HDC, бцел, LPKERNINGPAIR);
//бул GetLogColorSpaceW(HCOLORSPACE, LPLOGCOLORSPACE, бцел);
//HCOLORSPACE CreateColorSpaceW(LPLOGCOLORSPACE);
бул GetICMProfileW(HDC, бцел, шткст0);
бул SetICMProfileW(HDC, шткст0);
бул UpdateICMRegKeyW(бцел, бцел, шткст0, бцел);
//цел EnumICMProfilesW(HDC, ICMENUMPROC, LPARAM);
//HPROPSHEETPAGE CreatePropertySheetPageW(LPCPROPSHEETPAGE);
//цел PropertySheetW(LPCPROPSHEETHEADER);
УСписокКартинок ImageList_LoadImageW(экз, шткст0, цел, цел, ЦВПредст, бцел, бцел);
УОК CreateStatusWindowW(цел, шткст0, УОК, бцел);
проц DrawStatusTextW(HDC, ПРЯМ*, шткст0);
бул GetOpenFileNameW(ОТКРФАЙЛ*);
бул GetSaveFileNameW(ОТКРФАЙЛ*);
цел GetFileTitleW(шткст0, шткст0, бкрат);
//бул ChooseColorW(LPCHOOSECOLOR);
//УОК ReplaceTextW(LPFINDREPLACE);
//бул ChooseFontW(LPCHOOSEFONTW);
//УОК FindTextW(LPFINDREPLACE);
//бул PrintDlgW(LPPRINTDLGW);
//бул PageSetupDlgW(LPPAGESETUPDLG);
проц GetStartupInfoW(ИНФОСТАРТА*);

//HDC CreateDCW(шткст0, шткст0, шткст0, PDEVMODE);
HFONT CreateFontA(цел, цел, цел, цел, цел, бцел, бцел, бцел, бцел, бцел, бцел, бцел, бцел, ткст0);
бцел VerInstallFileW(бцел, шткст0, шткст0, шткст0, шткст0, шткст0, шткст0, бцел*);
бцел GetFileVersionInfoSizeW(шткст0, убцел);
бул GetFileVersionInfoW(шткст0, бцел, бцел, ук);
бцел VerLanguageNameW(бцел, шткст0, бцел);
бул VerQueryValueW(ук, шткст0, ук, бцел*);
бцел VerFindFileW(бцел, шткст0, шткст0, шткст0, шткст0, бцел*, шткст0, бцел*);
цел RegSetValueExW(HKEY, шткст0, бцел, бцел, уббайт, бцел);
цел RegUnLoadKeyW(HKEY, шткст0);
бул InitiateSystemShutdownW(шткст0, шткст0, бцел, бул, бул);
бул AbortSystemShutdownW(шткст0);
цел RegRestoreKeyW(HKEY, шткст0, бцел);
цел RegSaveKeyW(HKEY, шткст0, БЕЗАТРЫ*);
цел RegSetValueW(HKEY, шткст0, бцел, шткст0, бцел);
цел RegQueryValueW(HKEY, шткст0, шткст0, PLONG);
//цел RegQueryMultipleValuesW(HKEY, PVALENT, бцел, шткст0, убцел);
цел RegQueryValueExW(HKEY, шткст0, убцел, убцел, уббайт, убцел);
цел RegReplaceKeyW(HKEY, шткст0, шткст0, шткст0);
цел RegConnectRegistryW(шткст0, HKEY, PHKEY);
цел RegCreateKeyW(HKEY, шткст0, PHKEY);
цел RegCreateKeyExW(HKEY, шткст0, бцел, шткст0, бцел, REGSAM, БЕЗАТРЫ*, PHKEY, убцел);
цел RegDeleteKeyW(HKEY, шткст0);
цел RegDeleteValueW(HKEY, шткст0);
цел RegEnumKeyW(HKEY, бцел, шткст0, бцел);
цел RegEnumKeyExW(HKEY, бцел, шткст0, убцел, убцел, шткст0, убцел, ФВРЕМЯ*);
цел RegEnumValueW(HKEY, бцел, шткст0, убцел, убцел, убцел, уббайт, убцел);
цел RegLoadKeyW(HKEY, шткст0, шткст0);
цел RegOpenKeyW(HKEY, шткст0, PHKEY);
цел RegOpenKeyExW(HKEY, шткст0, бцел, REGSAM, PHKEY);
цел RegQueryInfoKeyW(HKEY, шткст0, убцел, убцел, убцел, убцел, убцел, убцел, убцел, убцел, убцел, ФВРЕМЯ*);
цел LCMapStringW(ЛКИД, бцел, шткст0, цел, шткст0, цел);

цел GetTimeFormatW(ЛКИД, бцел, СИСТВРЕМЯ*, шткст0, шткст0, цел);
цел GetDateFormatW(ЛКИД, бцел, СИСТВРЕМЯ*, шткст0, шткст0, цел);
цел GetNumberFormatW(ЛКИД, бцел, шткст0, УкФМТЧИСЛА, шткст0, цел);
цел GetCurrencyFormatW(ЛКИД, бцел, шткст0, УкФМТВАЛЮТЫ, шткст0, цел);
//бул EnumCalendarInfoW(CALINFO_ENUMPROC, ЛКИД, CALID, CALTYPE);
//бул EnumTimeFormatsW(TIMEFMT_ENUMPROC, ЛКИД, бцел);
//бул EnumDateFormatsW(DATEFMT_ENUMPROC, ЛКИД, бцел);
бул GetStringTypeExW(ЛКИД, бцел, шткст0, цел, бкрат*);
бул GetStringTypeW(бцел, шткст0, цел, бкрат*);
цел FoldStringW(бцел, шткст0, цел, шткст0, цел);
//бул EnumSystemLocalesW(LOCALE_ENUMPROC, бцел);
//бул EnumSystemCodePagesW(CODEPAGE_ENUMPROC, бцел);
бцел WNetAddConnectionW(шткст0, шткст0, шткст0);
//бцел WNetAddConnection2W(LPNETRESOURCE, шткст0, шткст0, бцел);
//бцел WNetAddConnection3W(УОК, LPNETRESOURCE, шткст0, шткст0, бцел);
бцел WNetCancelConnectionW(шткст0, бул);
бцел WNetCancelConnection2W(шткст0, бцел, бул);
бцел WNetGetConnectionW(шткст0, шткст0, убцел);
//бцел WNetUseConnectionW(УОК, LPNETRESOURCE, шткст0, шткст0, бцел, шткст0, убцел, убцел);
бцел WNetSetConnectionW(шткст0, бцел, ук);
//бцел WNetConnectionDialog1W(LPCONNECTDLGSTRUCT);
//бцел WNetDisconnectDialog1W(LPDISCDLGSTRUCT);
//бцел WNetOpenEnumW(бцел, бцел, бцел, LPNETRESOURCE, ук);
бцел WNetEnumResourceW(ук, убцел, ук, убцел);
бцел WNetGetUniversalNameW(шткст0, бцел, ук, убцел);
бцел WNetGetUserW(шткст0, шткст0, убцел);
бцел WNetGetProviderNameW(бцел, шткст0, убцел);
//бцел WNetGetNetworkInformationW(шткст0, LPNETINFOSTRUCT);
бцел WNetGetLastErrorW(убцел, шткст0, бцел, шткст0, бцел);
//бцел MultinetGetConnectionPerformanceW(LPNETRESOURCE, LPNETCONNECTINFOSTRUCT);
бул ChangeServiceConfigW(SC_HANDLE, бцел, бцел, бцел, шткст0, шткст0, убцел, шткст0, шткст0, шткст0, шткст0);
SC_HANDLE CreateServiceW(SC_HANDLE, шткст0, шткст0, бцел, бцел, бцел, бцел, шткст0, шткст0, убцел, шткст0, шткст0, шткст0);
//бул EnumDependentServicesW(SC_HANDLE, бцел, LPENUM_SERVICE_STATUS, бцел, убцел, убцел);
//бул EnumServicesStatusW(SC_HANDLE, бцел, бцел, LPENUM_SERVICE_STATUS, бцел, убцел, убцел, убцел);
бул GetServiceKeyNameW(SC_HANDLE, шткст0, шткст0, убцел);
бул GetServiceDisplayNameW(SC_HANDLE, шткст0, шткст0, убцел);
SC_HANDLE OpenSCManagerW(шткст0, шткст0, бцел);
SC_HANDLE OpenServiceW(SC_HANDLE, шткст0, бцел);
//бул QueryServiceConfigW(SC_HANDLE, LPQUERY_SERVICE_CONFIG, бцел, убцел);
//бул QueryServiceLockStatusW(SC_HANDLE, LPQUERY_SERVICE_LOCK_STATUS, бцел, убцел);
//SERVICE_STATUS_HANDLE RegisterServiceCtrlHandlerW(шткст0, HANDLER_FUNCTION);
//бул StartServiceCtrlDispatcherW(LPSERVICE_TABLE_ENTRY);
бул StartServiceW(SC_HANDLE, бцел, шткст0);
//бцел DragQueryFileW(HDROP, бцел, шткст0, бцел);
УИконка ExtractAssociatedIconW(экз, шткст0, бкрат*);
УИконка ExtractIconW(экз, шткст0, бцел);
экз FindExecutableW(шткст0, шткст0, шткст0);
цел ShellAboutW(УОК, шткст0, шткст0, УИконка);
экз ShellExecuteW(УОК, шткст0, шткст0, шткст0, шткст0, цел);
//HSZ DdeCreateStringHandleW(бцел, шткст0, цел);
//бцел DdeInitializeW(убцел, PFNCALLBACK, бцел, бцел);
//бцел DdeQueryStringW(бцел, HSZ, шткст0, бцел, цел);
бул LogonUserW(шткст0, шткст0, шткст0, бцел, бцел, ук);
бул AccessCheck(ДЕСКРБЕЗОП*, ук, бцел, ГЕНМАП*, НАБОР_ПРИВИЛЕГИЙ*, убцел, убцел, бул*);
FARPROC GetProcадрес(экз, ткст0);
бцел GetVersion();
проц FatalExit(цел);
проц RaiseException(бцел, бцел, бцел);
//цел UnhandledExceptionFilter(EMPTYRECORD*);
ук GetCurrentThread();
бцел GetCurrentThreadId();
бцел SetThreadAffinityMask(ук, бцел);
проц ExitThread(бцел);
бул TerminateThread(ук, бцел);
//бул GetThreadSelectorEntry(ук, бцел, LPLDT_ENTRY);
бцел SetErrorMode(бцел);
бул ReadProcessMemory(ук, ук, ук, бцел, убцел);
бул WriteProcessMemory(ук, ук, ук, бцел, убцел);
//бул WaitForDebugEvent(LPDEBUG_EVENT, бцел);
бул SetEvent(ук);
бул ResetEvent(ук);
бул PulseEvent(ук);
бул ReleaseMutex(ук);
гук LoadResource(экз, HRSRC);
бцел SizeofResource(экз, HRSRC);
АТОМ GlobalDeleteAtom(АТОМ);
бул InitAtomTable(бцел);
бцел SetHandleCount(бцел);
бцел GetLogicalDrives();
бул LockFile(ук, бцел, бцел, бцел, бцел);
бул UnlockFile(ук, бцел, бцел, бцел, бцел);
бул LockFileEx(ук, бцел, бцел, бцел, бцел, АСИНХРОН*);
бул UnlockFileEx(ук, бцел, бцел, бцел, АСИНХРОН*);
//бул GetFileInformationByHandle(ук, LPBY_HANDLE_FILE_INFORMATION);
бцел GetFileType(ук);
бцел LoadModule(ткст0, ук);
бцел WinExec(ткст0, бцел);
бул SetupComm(ук, бцел, бцел);
бул EscapeCommFunction(ук, бцел);
бул GetCommConfig(ук, КОММКОНФИГ*, убцел);
//бул GetCommProperties(ук, LPCOMMPROP);
бул GetCommModemStatus(ук, бцел*);
бул GetCommTimeouts(ук, КОММТАЙМАУТЫ*);
бул PurgeComm(ук, бцел);
бул SetCommBreak(ук);
бул SetCommConfig(ук, КОММКОНФИГ*, бцел);
бул SetCommMask(ук, бцел);
бул SetCommTimeouts(ук, КОММТАЙМАУТЫ*);
бул TransmitCommChar(ук, сим);
бул WaitCommEvent(ук, убцел, АСИНХРОН*);
бцел SetTapePosition(ук, бцел, бцел, бцел, бцел, бул);
бцел GetTapePosition(ук, бцел, убцел, убцел, убцел);
бцел PrepareTape(ук, бцел, бул);
бцел EraseTape(ук, бцел, бул);
бцел WriteTapemark(ук, бцел, бцел, бул);
бцел GetTapeStatus(ук);
бцел GetTapeParameters(ук, бцел, убцел, ук);
бцел SetTapeParameters(ук, бцел, ук);
цел MulDiv(цел, цел, цел);
//проц GetSystemInfo(LPSYSTEM_INFO);
бцел GetTickCount();
бул SetNamedPipeHandleState(ук, убцел, убцел, убцел);
бул GetNamedPipeInfo(ук, убцел, убцел, убцел, убцел);
бул PeekNamedPipe(ук, ук, бцел, убцел, убцел, убцел);
бул TransactNamedPipe(ук, ук, бцел, ук, бцел, убцел, АСИНХРОН*);
//HFILE OpenFile(ткст0, LPOFSTRUCT, бцел);
HFILE _lopen(ткст0, цел);
HFILE _lcreat(ткст0, цел);
бцел _lread(HFILE, ук, бцел);
бцел _lwrite(HFILE, ткст0, бцел);
цел _hread(HFILE, ук, цел);
цел _hwrite(HFILE, ткст0, цел);
HFILE _lclose(HFILE);
цел _llseek(HFILE, цел, цел);
бул IsTextUnicode(ук, цел, LPINT);
бцел TlsAlloc();
ук TlsGetValue(бцел);
бул TlsSetValue(бцел, ук);
бул TlsFree(бцел);
бцел SleepEx(бцел, бул);
бцел WaitForSingleObjectEx(ук, бцел, бул);
бцел WaitForMultipleObjectsEx(бцел, ук*, бул, бцел, бул);
бул ReadFileEx(ук, ук, бцел, АСИНХРОН*, LPOVERLAPPED_COMPLETION_ROUTINE);
бул WriteFileEx(ук, ук, бцел, АСИНХРОН*, LPOVERLAPPED_COMPLETION_ROUTINE);

бул SetProcessShutdownParameters(бцел, бцел);
бул GetProcessShutdownParameters(убцел, убцел);
проц SetFileApisToOEM();
проц SetFileApisToANSI();
бул AreFileApisANSI();
бул CloseEventLog(ук);
бул DeregisterEventSource(ук);
бул NotifyChangeEventLog(ук, ук);
бул GetNumberOfEventLogRecords(ук, бцел*);
бул GetOldestEventLogRecord(ук, бцел*);
бул DuplicateToken(ук, ПУровеньИмперсонацииБезопасности, ук);
бул GetKernelObjectSecurity(ук, ПИнфОБезопасности, ДЕСКРБЕЗОП*, бцел, убцел);
бул ImpersonateNamedPipeClient(ук);
бул ImpersonateLoggedOnUser(ук);
бул ImpersonateSelf(ПУровеньИмперсонацииБезопасности);
бул RevertToSelf();
бул SetThreadToken(ук, ук);
бул OpenProcessToken(ук, бцел, ук);
бул OpenThreadToken(ук, бцел, бул, ук);
бул GetTokenInformation(ук, КЛАСС_ИНФОРМАЦИИ_ТОКЕНА, ук, бцел, бцел*);
бул SetTokenInformation(ук, КЛАСС_ИНФОРМАЦИИ_ТОКЕНА, ук, бцел);
бул AdjustTokenPrivileges(ук, бул, ПРИВИЛЕГИИ_ТОКЕНОВ*, бцел, ПРИВИЛЕГИИ_ТОКЕНОВ*, бцел*);
бул AdjustTokenGroups(ук, бул, ТОКЕНГРУП*, бцел, ТОКЕНГРУП*, бцел*);
бул PrivilegeCheck(ук, НАБОР_ПРИВИЛЕГИЙ*, бул*);
бул IsValidSid(УкБИД);
бул EqualSid(УкБИД, УкБИД);
бул EqualPrefixSid(УкБИД, УкБИД);
бцел GetSidLengthRequired(UCHAR);
//бул AllocateAndInitializeSid(PSID_IDENTIFIER_AUTHORITY, ббайт, бцел, бцел, бцел, бцел, бцел, бцел, бцел, бцел, УкБИД*);
ук FreeSid(УкБИД);
//бул InitializeSid(УкБИД, PSID_IDENTIFIER_AUTHORITY, ббайт);
//PSID_IDENTIFIER_AUTHORITY GetSidIdentifierAuthority(УкБИД);
бцел* GetSidSubAuthority(УкБИД, бцел);
PUCHAR GetSidSubAuthorityCount(УкБИД);
бцел GetLengthSid(УкБИД);
бул CopySid(бцел, УкБИД, УкБИД);
бул AreAllAccessesGranted(бцел, бцел);
бул AreAnyAccessesGranted(бцел, бцел);
проц MapGenericMask(бцел*);
бул IsValidAcl(PACL);
бул InitializeAcl(PACL, бцел, бцел);
//бул GetAclInformation(PACL, ук, бцел, ACL_INFORMATION_CLASS);
//бул SetAclInformation(PACL, ук, бцел, ACL_INFORMATION_CLASS);
бул AddAce(PACL, бцел, бцел, ук, бцел);
бул DeleteAce(PACL, бцел);
бул GetAce(PACL, бцел, ук*);
бул AddAccessAllowedAce(PACL, бцел, бцел, УкБИД);
бул AddAccessDeniedAce(PACL, бцел, бцел, УкБИД);
бул AddAuditAccessAce(PACL, бцел, бцел, УкБИД, бул, бул);
бул FindFirstFreeAce(PACL, ук*);
бул InitializeSecurityDescriptor(ДЕСКРБЕЗОП*, бцел);
бул IsValidSecurityDescriptor(ДЕСКРБЕЗОП*);
бцел GetSecurityDescriptorLength(ДЕСКРБЕЗОП*);
//бул GetSecurityDescriptorControl(ДЕСКРБЕЗОП*, PSECURITY_DESCRIPTOR_CONTROL, убцел);
бул SetSecurityDescriptorDacl(ДЕСКРБЕЗОП*, бул, PACL, бул);
бул GetSecurityDescriptorDacl(ДЕСКРБЕЗОП*, бул*, PACL*, бул*);
бул SetSecurityDescriptorSacl(ДЕСКРБЕЗОП*, бул, PACL, бул);
бул GetSecurityDescriptorSacl(ДЕСКРБЕЗОП*, бул*, PACL*, бул*);
бул SetSecurityDescriptorOwner(ДЕСКРБЕЗОП*, УкБИД, бул);
бул GetSecurityDescriptorOwner(ДЕСКРБЕЗОП*, УкБИД*, бул*);
бул SetSecurityDescriptorGroup(ДЕСКРБЕЗОП*, УкБИД, бул);
бул GetSecurityDescriptorGroup(ДЕСКРБЕЗОП*, УкБИД*, бул*);
бул CreatePrivateObjectSecurity(ДЕСКРБЕЗОП*, ДЕСКРБЕЗОП*, ДЕСКРБЕЗОП**, бул, ук, ГЕНМАП*);
бул SetPrivateObjectSecurity(ПИнфОБезопасности, ДЕСКРБЕЗОП*, ДЕСКРБЕЗОП**, ГЕНМАП*, ук);
бул GetPrivateObjectSecurity(ДЕСКРБЕЗОП*, ПИнфОБезопасности, ДЕСКРБЕЗОП*, бцел, бцел*);
бул DestroyPrivateObjectSecurity(ДЕСКРБЕЗОП*);
бул MakeSelfRelativeSD(ДЕСКРБЕЗОП*, ДЕСКРБЕЗОП*, убцел);
бул MakeAbsoluteSD(ДЕСКРБЕЗОП*, ДЕСКРБЕЗОП*, убцел, PACL, убцел, PACL, убцел, УкБИД, убцел, УкБИД, убцел);
бул SetKernelObjectSecurity(ук, ПИнфОБезопасности, ДЕСКРБЕЗОП*);
бул FindNextChangeNotification(ук);
бул FindCloseChangeNotification(ук);
бул VirtualLock(ук, бцел);
бул VirtualUnlock(ук, бцел);
бул SetPriorityClass(ук, бцел);
бцел GetPriorityClass(ук);
бул AllocateLocallyUniqueId(ЛУИД*);
бул QueryPerformanceCounter(БОЛЬШЕЦЕЛ*);
бул QueryPerformanceFrequency(БОЛЬШЕЦЕЛ*);
бул ActivateKeyboardLayout(HKL, бцел);
бул UnloadKeyboardLayout(HKL);
цел GetKeyboardLayoutList(цел, HKL*);
HKL GetKeyboardLayout(бцел);
HDESK OpenInputDesktop(бцел, бул, бцел);
//бул EnumDesktopWindows(HDESK, ENUMWINDOWSPROC, LPARAM);
бул SwitchDesktop(HDESK);
бул SetThreдобавьesktop(HDESK);
бул CloseDesktop(HDESK);
HDESK GetThreдобавьesktop(бцел);
бул CloseWindowStation(HWINSTA);
бул SetProcessWindowStation(HWINSTA);
HWINSTA GetProcessWindowStation();
//бул SetUserObjectSecurity(ук, PSECURITY_INFORMATION, ДЕСКРБЕЗОП*);
//бул GetUserObjectSecurity(ук, PSECURITY_INFORMATION, ДЕСКРБЕЗОП*, бцел, убцел);
бул TranslateMessage(СООБ*);
бул SetMessageQueue(цел);
бул RegisterHotKey(УОК, цел, бцел, бцел);
бул UnregisterHotKey(УОК, цел);
бул ExitWindowsEx(бцел, бцел);
бул SwapMouseButton(бул);
бцел GetMessagePos();
цел GetMessageTime();
цел GetMessageExtraInfo();
LPARAM SetMessageExtraInfo(LPARAM);
цел BroadcastSystemMessage(бцел, убцел, бцел, WPARAM, LPARAM);
бул AttachThreadInput(бцел, бцел, бул);
бул ReplyMessage(LRESULT);
бул WaitMessage();
бцел WaitForInputIdle(ук, бцел);
проц PostQuitMessage(цел);
бул InSendMessage();
бцел GetDoubleClickTime();
бул SetDoubleClickTime(бцел);
бул IsWindow(УОК);
бул IsMenu(HMENU);
бул IsChild(УОК, УОК);
бул DestroyWindow(УОК);
бул ShowWindowAsync(УОК, цел);
бул FlashWindow(УОК, бул);
бул ShowOwnedPopups(УОК, бул);
бул OpenIcon(УОК);
бул CloseWindow(УОК);
бул MoveWindow(УОК, цел, цел, цел, цел, бул);
бул SetWindowPos(УОК, УОК, цел, цел, цел, цел, бцел);
бул GetWindowPlacement(УОК, РАЗМЕЩЕНИЕ_ОКНА*);
бул SetWindowPlacement(УОК, РАЗМЕЩЕНИЕ_ОКНА*);
//HDWP BeginDeferWindowPos(цел);
//HDWP DeferWindowPos(HDWP, УОК, УОК, цел, цел, цел, цел, бцел);
//бул EndDeferWindowPos(HDWP);
бул IsWindowVisible(УОК);
бул IsIconic(УОК);
бул AnyPopup();
бул BringWindowToTop(УОК);
бул IsZoomed(УОК);
бул EndDialog(УОК, цел);
УОК GetDlgItem(УОК, цел);
бул SetDlgItemInt(УОК, цел, бцел, бул);
бцел GetDlgItemInt(УОК, цел, бул*, бул);
бул CheckDlgButton(УОК, цел, бцел);
бул CheckRadioButton(УОК, цел, цел, цел);
бцел IsDlgButtonChecked(УОК, цел);
УОК GetNextDlgGroupItem(УОК, УОК, бул);
УОК GetNextDlgTabItem(УОК, УОК, бул);
цел GetDlgCtrlID(УОК);
цел GetDialogBaseUnits();
бул OpenClipboard(УОК);
бул CloseClipboard();
УОК GetClipboardOwner();
УОК SetClipboardViewer(УОК);
УОК GetClipboardViewer();
бул ChangeClipboardChain(УОК, УОК);
ук SetClipboardData(бцел, ук);
ук GetClipboardData(бцел);
цел CountClipboardFormats();
бцел EnumClipboardFormats(бцел);
бул EmptyClipboard();
бул IsClipboardFormatAvailable(бцел);
цел GetPriorityClipboardFormat(бцел*, цел);
УОК GetOpenClipboardWindow();
ткст0 CharNextExA(бкрат, ткст0, бцел);
ткст0 CharPrevExA(бкрат, ткст0, ткст0, бцел);
УОК SetFocus(УОК);
УОК GetActiveWindow();
УОК GetFocus();
бцел GetKBCodePage();
SHORT GetKeyState(цел);
SHORT GetAsyncKeyState(цел);
бул GetKeyboardState(ббайт*);
бул SetKeyboardState(уббайт);
цел GetKeyboardType(цел);
цел ToAscii(бцел, бцел, ббайт*, бкрат*, бцел);
цел ToAsciiEx(бцел, бцел, ббайт*, бкрат*, бцел, HKL);
цел ToUnicode(бцел, бцел, ббайт*, шткст0, цел, бцел);
бцел OemKeyScan(бкрат);
проц keybd_event(ббайт, ббайт, бцел, ук);
проц mouse_event(бцел, бцел, бцел, бцел);
бул GetInputState();
бцел GetQueueStatus(бцел);
УОК GetCapture();
УОК SetCapture(УОК);
бул ReleaseCapture();
бцел MsgWaitForMultipleObjects(бцел, ук, бул, бцел, бцел);
бцел SetTimer(УОК, бцел, бцел, TIMERPROC);
бул KillTimer(УОК, бцел);
бул IsWindowUnicode(УОК);
бул EnableWindow(УОК, бул);
бул IsWindowEnabled(УОК);
бул DestroyAcceleratorTable(HACCEL);
HMENU GetMenu(УОК);
бул SetMenu(УОК, HMENU);
бул HiliteMenuItem(УОК, HMENU, бцел, бцел);
бцел GetMenuState(HMENU, бцел, бцел);
бул DrawMenuBar(УОК);
HMENU GetSystemMenu(УОК, бул);
HMENU CreateMenu();
HMENU CreatePopupMenu();
бул DestroyMenu(HMENU);
бцел CheckMenuItem(HMENU, бцел, бцел);
бул EnableMenuItem(HMENU, бцел, бцел);
HMENU GetSubMenu(HMENU, цел);
бцел GetMenuItemID(HMENU, цел);
цел GetMenuItemCount(HMENU);
бул RemoveMenu(HMENU, бцел, бцел);
бул DeleteMenu(HMENU, бцел, бцел);
бул SetMenuItemBitmaps(HMENU, бцел, бцел, УБитмап, УБитмап);
цел GetMenuCheckMarkDimensions();
бул TrackPopupMenu(HMENU, бцел, цел, цел, цел, УОК, ПРЯМ*);
бцел GetMenuDefaultItem(HMENU, бцел, бцел);
бул SetMenuDefaultItem(HMENU, бцел, бцел);
бул GetMenuItemRect(УОК, HMENU, бцел, ПРЯМ*);
цел MenuItemFromPoцел(УОК, HMENU, ТОЧКА);
бцел DragObject(УОК, УОК, бцел, бцел, HCURSOR);
бул DragDetect(УОК, ТОЧКА);
бул DrawIcon(HDC, цел, цел, УИконка);
бул UpdateWindow(УОК);
УОК SetActiveWindow(УОК);
УОК GetForegroundWindow();
бул PaintDesktop(HDC);
цел GetScrollPos(УОК, цел);
бул SetScrollRange(УОК, цел, цел, цел, бул);
бул GetScrollRange(УОК, цел, LPINT, LPINT);
 бул GetClientRect(УОК окно, ПРЯМ* lpRect);
 бул GetWindowRect(УОК окно, ПРЯМ* lpRect);
 бул AdjustWindowRect(ПРЯМ* lpRect, бцел dwStyle, бул bMenu);
 бул AdjustWindowRectEx(ПРЯМ* lpRect, бцел dwStyle, бул bMenu, бцел dwExStyle);

бул SetWindowContextHelpId(УОК, бцел);
бцел GetWindowContextHelpId(УОК);
бул SetMenuContextHelpId(HMENU, бцел);
бцел GetMenuContextHelpId(HMENU);
бул MessageBeep(бцел);
цел ShowCursor(бул);
бул SetCursorPos(цел, цел);
HCURSOR SetCursor(HCURSOR);
бул GetCursorPos(ТОЧКА*);
бул ClipCursor(ПРЯМ*);
бул GetClipCursor(ПРЯМ*);
HCURSOR GetCursor();
бул CreateCaret(УОК, УБитмап, цел, цел);
бцел GetCaretBlinkTime();
бул SetCaretBlinkTime(бцел);
бул DestroyCaret();
бул HideCaret(УОК);
бул ShowCaret(УОК);
бул SetCaretPos(цел, цел);
бул GetCaretPos(ТОЧКА*);
бул ClientToScreen(УОК, ТОЧКА*);
бул ScreenToClient(УОК, ТОЧКА*);
цел MapWindowPoцелs(УОК, УОК, ТОЧКА*, бцел);
УОК WindowFromPoцел(ТОЧКА);
УОК ChildWindowFromPoцел(УОК, ТОЧКА);
бцел GetSysColor(цел);
HBRUSH GetSysColorBrush(цел);
бул SetSysColors(цел, INT*, ЦВПредст*);
бул DrawFocusRect(HDC, ПРЯМ*);
цел FillRect(HDC, ПРЯМ*, HBRUSH);
цел FrameRect(HDC, ПРЯМ*, HBRUSH);
бул InvertRect(HDC, ПРЯМ*);
бул SetRect(ПРЯМ*, цел, цел, цел, цел);
бул SetRectEmpty(ПРЯМ*);
бул CopyRect(ПРЯМ*, ПРЯМ*);
бул InflateRect(ПРЯМ*, цел, цел);
бул IntersectRect(ПРЯМ*, ПРЯМ*, ПРЯМ*);
бул UnionRect(ПРЯМ*, ПРЯМ*, ПРЯМ*);
бул SubtractRect(ПРЯМ*, ПРЯМ*, ПРЯМ*);
бул OffsetRect(ПРЯМ*, цел, цел);
бул IsRectEmpty(ПРЯМ*);
бул EqualRect(ПРЯМ*, ПРЯМ*);
бул PtInRect(ПРЯМ*, ТОЧКА);
бкрат GetWindowWord(УОК, цел);
бкрат SetWindowWord(УОК, цел, бкрат);
бкрат GetClassWord(УОК, цел);
бкрат SetClassWord(УОК, цел, бкрат);
УОК GetDesktopWindow();
УОК GetParent(УОК);
УОК SetParent(УОК, УОК);
//бул EnumChildWindows(УОК, ENUMWINDOWSPROC, LPARAM);
//бул EnumWindows(ENUMWINDOWSPROC, LPARAM);
//бул EnumThreadWindows(бцел, ENUMWINDOWSPROC, LPARAM);
УОК GetTopWindow(УОК);
бцел GetWindowThreadProcessId(УОК, убцел);
УОК GetLastActivePopup(УОК);
УОК GetWindow(УОК, бцел);
бул UnhookWindowsHook(цел, HOOKPROC);
//бул UnhookWindowsHookEx(HHOOK);
//LRESULT CallNextHookEx(HHOOK, цел, WPARAM, LPARAM);
бул CheckMenuRadioItem(HMENU, бцел, бцел, бцел, бцел);
HCURSOR CreateCursor(экз, цел, цел, цел, цел, ук, ук);
бул DestroyCursor(HCURSOR);
бул SetSystemCursor(HCURSOR, бцел);
УИконка CreateIcon(экз, цел, цел, ббайт, ббайт, ббайт*, ббайт*);
бул DestroyIcon(УИконка);
цел LookupIconIdFromDirectory(ббайт*, бул);
цел LookupIconIdFromDirectoryEx(ббайт*, бул, цел, цел, бцел);
УИконка CreateIconFromResource(ббайт*, бцел, бул, бцел);
УИконка CreateIconFromResourceEx(ббайт*, бцел, бул, бцел, цел, цел, бцел);
УИконка CopyImage(ук, бцел, цел, цел, бцел);
//УИконка CreateIconIndirect(PICONINFO);
УИконка CopyIcon(УИконка);
//бул GetIconInfo(УИконка, PICONINFO);
бул MapDialogRect(УОК, ПРЯМ*);
//цел SetScrollInfo(УОК, цел, LPCSCROLLINFO, бул);
//бул GetScrollInfo(УОК, цел, LPSCROLLINFO);
бул TranslateMDISysAccel(УОК, СООБ*);
бцел ArrangeIconicWindows(УОК);
бкрат TileWindows(УОК, бцел, ПРЯМ*, бцел, УОК*);
бкрат CascadeWindows(УОК, бцел, ПРЯМ*, бцел, УОК*);

проц SetDebugErrorУровень(бцел);
бул DrawEdge(HDC, ПРЯМ*, бцел, бцел);
бул DrawFrameControl(HDC, ПРЯМ*, бцел, бцел);
бул DrawCaption(УОК, HDC, ПРЯМ*, бцел);
бул DrawAnimatedRects(УОК, цел, ПРЯМ*, ПРЯМ*);
//бул TrackPopupMenuEx(HMENU, бцел, цел, цел, УОК, LPTPMPARAMS);
УОК ChildWindowFromPoцелEx(УОК, ТОЧКА, бцел);
бул DrawIconEx(HDC, цел, цел, УИконка, цел, цел, бцел, HBRUSH, бцел);
бул AnimatePalette(HPALETTE, бцел, бцел, ПАЛИТЗАП*);
бул Arc(HDC, цел, цел, цел, цел, цел, цел, цел, цел);
бул BitBlt(HDC, цел, цел, цел, цел, HDC, цел, цел, бцел);
бул CancelDC(HDC);
бул Chord(HDC, цел, цел, цел, цел, цел, цел, цел, цел);
HMETAFILE CloseMetaFile(HDC);
цел CombineRgn(HRGN, HRGN, HRGN, цел);
УБитмап CreateBitmap(цел, цел, бцел, бцел, ук);
УБитмап CreateBitmapIndirect(БИТМАП*);
//HBRUSH CreateBrushIndirect(LOGBRUSH*);
УБитмап CreateCompatibleBitmap(HDC, цел, цел);
УБитмап CreateDiscardableBitmap(HDC, цел, цел);
HDC CreateCompatibleDC(HDC);
УБитмап CreateDIBitmap(HDC, ИНФОБИТМАПЗАГ*, бцел, ук, ИНФОБИТМАП*, бцел);
HBRUSH CreateDIBPatternBrush(гук, бцел);
HBRUSH CreateDIBPatternBrushPt(ук, бцел);
HRGN CreateEllipticRgn(цел, цел, цел, цел);
HRGN CreateEllipticRgnIndirect(ПРЯМ*);
HBRUSH CreateHatchBrush(цел, ЦВПредст);
HPALETTE CreatePalette(ПАЛИТЛОГ*);
HPEN CreatePen(цел, цел, ЦВПредст);
HPEN CreatePenIndirect(ЛОГ_ПЕРА*);
HRGN CreatePolyPolygonRgn(ТОЧКА*, цел*, цел, цел);
HBRUSH CreatePatternBrush(УБитмап);
HRGN CreateRectRgn(цел, цел, цел, цел);
HRGN CreateRectRgnIndirect(ПРЯМ*);
HRGN CreateRoundRectRgn(цел, цел, цел, цел, цел, цел);
HBRUSH CreateSolidBrush(ЦВПредст);
бул DeleteDC(HDC);
бул DeleteMetaFile(HMETAFILE);
бул DeleteObject(HGDIOBJ);
цел DrawEscape(HDC, цел, цел, ткст0);
бул Ellipse(HDC, цел, цел, цел, цел);
//цел EnumObjects(HDC, цел, ENUMOBJECTSPROC, LPARAM);
бул EqualRgn(HRGN, HRGN);
цел Escape(HDC, цел, цел, ткст0, ук);
цел ExtEscape(HDC, цел, цел, ткст0, цел, ткст0);
цел ExcludeClipRect(HDC, цел, цел, цел, цел);
//HRGN ExtCreateRegion(ХФОРМА*, бцел, RGNDATA*);
бул ExtFloodFill(HDC, цел, цел, ЦВПредст, бцел);
бул FillRgn(HDC, HRGN, HBRUSH);
бул FloodFill(HDC, цел, цел, ЦВПредст);
бул FrameRgn(HDC, HRGN, HBRUSH, цел, цел);
цел GetROP2(HDC);
бул GetAspectRatioFilterEx(HDC, РАЗМЕР*);
ЦВПредст GetBkColor(HDC);
цел GetBkMode(HDC);
цел GetBitmapBits(УБитмап, цел, ук);
бул GetBitmapDimensionEx(УБитмап, РАЗМЕР*);
бцел GetBoundsRect(HDC, ПРЯМ*, бцел);
бул GetBrushOrgEx(HDC, ТОЧКА*);
цел GetClipBox(HDC, ПРЯМ*);
цел GetClipRgn(HDC, HRGN);
цел GetMetaRgn(HDC, HRGN);
HGDIOBJ GetCurrentObject(HDC, бцел);
бул GetCurrentPositionEx(HDC, ТОЧКА*);
цел GetDeviceCaps(HDC, цел);
цел GetDIBits(HDC, УБитмап, бцел, бцел, ук, ИНФОБИТМАП*, бцел);
бцел GetFontData(HDC, бцел, бцел, ук, бцел);
цел GetGraphicsMode(HDC);
цел GetMapMode(HDC);
бцел GetMetaFileBitsEx(HMETAFILE, бцел, ук);
ЦВПредст GetNearestColor(HDC, ЦВПредст);
бцел GetNearestPaletteIndex(HPALETTE, ЦВПредст);
бцел GetObjectType(HGDIOBJ);
бцел GetPaletteEntries(HPALETTE, бцел, бцел, ПАЛИТЗАП*);
ЦВПредст GetPixel(HDC, цел, цел);
цел GetPixelFormat(HDC);
цел GetPolyFillMode(HDC);
//бул GetRasterizerCaps(LPRASTERIZER_STATUS, бцел);
//бцел GetRegionData(HRGN, бцел, LPRGNDATA);
цел GetRgnBox(HRGN, ПРЯМ*);
цел GetStretchBltMode(HDC);
бцел GetSystemPaletteEntries(HDC, бцел, бцел, ПАЛИТЗАП*);
бцел GetSystemPaletteUse(HDC);
цел GetTextCharacterExtra(HDC);
бцел GetTextAlign(HDC);
ЦВПредст GetTextColor(HDC);
цел GetTextCharset(HDC);
//цел GetTextCharsetInfo(HDC, LPFONTSIGNATURE, бцел);
//бул TranslateCharsetInfo(бцел*, LPCHARSETINFO, бцел);
бцел GetFontLanguageInfo(HDC);
бул GetViewportExtEx(HDC, РАЗМЕР*);
бул GetViewportOrgEx(HDC, ТОЧКА*);
бул GetWindowExtEx(HDC, РАЗМЕР*);
бул GetWindowOrgEx(HDC, ТОЧКА*);
цел IntersectClipRect(HDC, цел, цел, цел, цел);
бул InvertRgn(HDC, HRGN);
//бул LineDDA(цел, цел, цел, цел, LINEDDAPROC, LPARAM);
бул LineTo(HDC, цел, цел);
бул MaskBlt(HDC, цел, цел, цел, цел, HDC, цел, цел, УБитмап, цел, цел, бцел);
бул PlgBlt(HDC, ТОЧКА*, HDC, цел, цел, цел, цел, УБитмап, цел, цел);
цел OffsetClipRgn(HDC, цел, цел);
цел OffsetRgn(HRGN, цел, цел);
бул PatBlt(HDC, цел, цел, цел, цел, бцел);
бул Pie(HDC, цел, цел, цел, цел, цел, цел, цел, цел);
бул PlayMetaFile(HDC, HMETAFILE);
бул PaintRgn(HDC, HRGN);
бул PolyPolygon(HDC, ТОЧКА*, цел*, цел);
бул PtInRegion(HRGN, цел, цел);
бул PtVisible(HDC, цел, цел);
бул RectInRegion(HRGN, ПРЯМ*);
бул RectVisible(HDC, ПРЯМ*);
бул Rectangle(HDC, цел, цел, цел, цел);
бул RestoreDC(HDC, цел);
бцел RealizePalette(HDC);
бул RoundRect(HDC, цел, цел, цел, цел, цел, цел);
бул ResizePalette(HPALETTE, бцел);
цел SaveDC(HDC);
цел SelectClipRgn(HDC, HRGN);
цел ExtSelectClipRgn(HDC, HRGN, цел);
цел SetMetaRgn(HDC);
HGDIOBJ SelectObject(HDC, HGDIOBJ);
HPALETTE SelectPalette(HDC, HPALETTE, бул);
ЦВПредст SetBkColor(HDC, ЦВПредст);
цел SetBkMode(HDC, цел);
цел SetBitmapBits(УБитмап, бцел, ук);
бцел SetBoundsRect(HDC, ПРЯМ*, бцел);
цел SetDIBits(HDC, УБитмап, бцел, бцел, ук, ИНФОБИТМАП*, бцел);
цел SetDIBitsToDevice(HDC, цел, цел, бцел, бцел, цел, цел, бцел, бцел, ук, ИНФОБИТМАП*, бцел);
бцел SetMapperFlags(HDC, бцел);
цел SetGraphicsMode(HDC, цел);
цел SetMapMode(HDC, цел);
HMETAFILE SetMetaFileBitsEx(бцел, ббайт*);
бцел SetPaletteEntries(HPALETTE, бцел, бцел, ПАЛИТЗАП*);
ЦВПредст SetPixel(HDC, цел, цел, ЦВПредст);
бул SetPixelV(HDC, цел, цел, ЦВПредст);
цел SetPolyFillMode(HDC, цел);
бул StretchBlt(HDC, цел, цел, цел, цел, HDC, цел, цел, цел, цел, бцел);
бул SetRectRgn(HRGN, цел, цел, цел, цел);
цел StretchDIBits(HDC, цел, цел, цел, цел, цел, цел, цел, цел, ук, ИНФОБИТМАП*, бцел, бцел);
цел SetROP2(HDC, цел);
цел SetStretchBltMode(HDC, цел);
бцел SetSystemPaletteUse(HDC, бцел);
цел SetTextCharacterExtra(HDC, цел);
ЦВПредст SetTextColor(HDC, ЦВПредст);
бцел SetTextAlign(HDC, бцел);
бул SetTextJustification(HDC, цел, цел);
бул UpdateColors(HDC);
//бул PlayMetaFileRecord(HDC, LPHANDLETABLE, LPMETARECORD, бцел);
//бул EnumMetaFile(HDC, HMETAFILE, ENUMMETAFILEPROC, LPARAM);
HENHMETAFILE CloseEnhMetaFile(HDC);
бул DeleteEnhMetaFile(HENHMETAFILE);
//бул EnumEnhMetaFile(HDC, HENHMETAFILE, ENHMETAFILEPROC, ук, ПРЯМ*);
//бцел GetEnhMetaFileHeader(HENHMETAFILE, бцел, LPENHMETAHEADER);
бцел GetEnhMetaFilePaletteEntries(HENHMETAFILE, бцел, ПАЛИТЗАП*);
бцел GetWinMetaFileBits(HENHMETAFILE, бцел, уббайт, цел, HDC);
бул PlayEnhMetaFile(HDC, HENHMETAFILE, ПРЯМ*);
//бул PlayEnhMetaFileRecord(HDC, LPHANDLETABLE, ENHMETARECORD*, бцел);
HENHMETAFILE SetEnhMetaFileBits(бцел, ббайт*);
//HENHMETAFILE SetWinMetaFileBits(бцел, ббайт*, HDC, METAFILEPICT*);
бул GdiComment(HDC, бцел, ббайт*);
бул AngleArc(HDC, цел, цел, бцел, плав, плав);
бул PolyPolyline(HDC, ТОЧКА*, бцел*, бцел);
бул GetWorldTransform(HDC, ХФОРМА*);
бул SetWorldTransform(HDC, ХФОРМА*);
бул ModifyWorldTransform(HDC, ХФОРМА*, бцел);
бул CombineTransform(ХФОРМА*, ХФОРМА*, ХФОРМА*);
УБитмап CreateDIBSection(HDC, ИНФОБИТМАП*, бцел, ук*, ук, бцел);
бцел GetDIBColorTable(HDC, бцел, бцел, КВАДКЗС*);
бцел SetDIBColorTable(HDC, бцел, бцел, КВАДКЗС*);
//бул SetColorAdjustment(HDC, COLORADJUSTMENT*);
//бул GetColorAdjustment(HDC, LPCOLORADJUSTMENT);
HPALETTE CreateHalftonePalette(HDC);
цел EndDoc(HDC);
цел StartPage(HDC);
цел EndPage(HDC);
цел AbortDoc(HDC);
//цел SetAbortProc(HDC, TABORTPROC);
бул ArcTo(HDC, цел, цел, цел, цел, цел, цел, цел, цел);
бул BeginPath(HDC);
бул CloseFigure(HDC);
бул EndPath(HDC);
бул FillPath(HDC);
бул FlattenPath(HDC);
цел GetPath(HDC, ТОЧКА*, уббайт, цел);
HRGN PathToRegion(HDC);
бул PolyDraw(HDC, ТОЧКА*, ббайт*, цел);
бул SelectClipPath(HDC, цел);
цел SetArcDirection(HDC, цел);
бул SetMiterLimit(HDC, плав, PFLOAT);
бул StrokeAndFillPath(HDC);
бул StrokePath(HDC);
бул WidenPath(HDC);
//HPEN ExtCreatePen(бцел, бцел, LOGBRUSH*, бцел, бцел*);
бул GetMiterLimit(HDC, PFLOAT);
цел GetArcDirection(HDC);
бул MoveToEx(HDC, цел, цел, ТОЧКА*);
HRGN CreatePolygonRgn(ТОЧКА*, цел, цел);
бул DPtoLP(HDC, ТОЧКА*, цел);
бул LPtoDP(HDC, ТОЧКА*, цел);
бул Polygon(HDC, ТОЧКА*, цел);
бул Polyline(HDC, ТОЧКА*, цел);
бул PolyBezier(HDC, ТОЧКА*, бцел);
бул PolyBezierTo(HDC, ТОЧКА*, бцел);
бул PolylineTo(HDC, ТОЧКА*, бцел);
бул SetViewportExtEx(HDC, цел, цел, РАЗМЕР*);
бул SetViewportOrgEx(HDC, цел, цел, ТОЧКА*);
бул SetWindowExtEx(HDC, цел, цел, РАЗМЕР*);
бул SetWindowOrgEx(HDC, цел, цел, ТОЧКА*);
бул OffsetViewportOrgEx(HDC, цел, цел, ТОЧКА*);
бул OffsetWindowOrgEx(HDC, цел, цел, ТОЧКА*);
бул ScaleViewportExtEx(HDC, цел, цел, цел, цел, РАЗМЕР*);
бул ScaleWindowExtEx(HDC, цел, цел, цел, цел, РАЗМЕР*);
бул SetBitmapDimensionEx(УБитмап, цел, цел, РАЗМЕР*);
бул SetBrushOrgEx(HDC, цел, цел, ТОЧКА*);
бул GetDCOrgEx(HDC, ТОЧКА*);
бул FixBrushOrgEx(HDC, цел, цел, ТОЧКА*);
бул UnrealizeObject(HGDIOBJ);
бул GdiFlush();
бцел GdiSetBatchLimit(бцел);
бцел GdiGetBatchLimit();
цел SetICMMode(HDC, цел);
бул CheckColorsInGamut(HDC, ук, ук, бцел);
ук GetColorSpace(HDC);
бул SetColorSpace(HDC, HCOLORSPACE);
бул DeleteColorSpace(HCOLORSPACE);
бул GetDeviceGammaRamp(HDC, ук);
бул SetDeviceGammaRamp(HDC, ук);
бул ColorMatchToTarget(HDC, HDC, бцел);
//HPROPSHEETPAGE CreatePropertySheetPageA(LPCPROPSHEETPAGE);
//бул DestroyPropertySheetPage(HPROPSHEETPAGE);
проц InitCommonControls();
УСписокКартинок ImageList_Create(цел, цел, бцел, цел, цел);
бул ImageList_Destroy(УСписокКартинок);
цел ImageList_GetImageCount(УСписокКартинок);
цел ImageList_добавь(УСписокКартинок, УБитмап, УБитмап);
цел ImageList_ReplaceIcon(УСписокКартинок, цел, УИконка);
ЦВПредст ImageList_SetBkColor(УСписокКартинок, ЦВПредст);
ЦВПредст ImageList_GetBkColor(УСписокКартинок);
бул ImageList_SetOverlayImage(УСписокКартинок, цел, цел);
бул ImageList_Draw(УСписокКартинок, цел, HDC, цел, цел, бцел);
бул ImageList_Replace(УСписокКартинок, цел, УБитмап, УБитмап);
цел ImageList_AddMasked(УСписокКартинок, УБитмап, ЦВПредст);
бул ImageList_DrawEx(УСписокКартинок, цел, HDC, цел, цел, цел, цел, ЦВПредст, ЦВПредст, бцел);
бул ImageList_Remove(УСписокКартинок, цел);
УИконка ImageList_GetIcon(УСписокКартинок, цел, бцел);
бул ImageList_BeginDrag(УСписокКартинок, цел, цел, цел);
проц ImageList_EndDrag();
бул ImageList_DragEnter(УОК, цел, цел);
бул ImageList_DragLeave(УОК);
бул ImageList_DragMove(цел, цел);
бул ImageList_SetDragCursorImage(УСписокКартинок, цел, цел, цел);
бул ImageList_DragShowNolock(бул);
УСписокКартинок ImageList_GetDragImage(ТОЧКА*, ТОЧКА*);
бул ImageList_GetIconSize(УСписокКартинок, цел*, цел*);
бул ImageList_SetIconSize(УСписокКартинок, цел, цел);
//бул ImageList_GetImageInfo(УСписокКартинок, цел, IMAGEINFO*);
УСписокКартинок ImageList_Merge(УСписокКартинок, цел, УСписокКартинок, цел, цел, цел);
//УОК CreateToolbarEx(УОК, бцел, бцел, цел, экз, бцел, LPCTBBUTTON, цел, цел, цел, цел, цел, бцел);
//УБитмап CreateMappedBitmap(экз, цел, бцел, LPCOLORMAP, цел);
проц MenuHelp(бцел, WPARAM, LPARAM, HMENU, экз, УОК);
бул ShowHideMenuCtl(УОК, бцел, LPINT);
проц GetEffectiveClientRect(УОК, ПРЯМ*);
бул MakeDragList(УОК);
проц DrawInsert(УОК, УОК);
цел LBItemFromPt(УОК, ТОЧКА, бул);
УОК CreateUpDownControl(бцел, цел, цел, цел, цел, УОК, цел, экз, УОК, цел, цел, цел);
цел RegSetKeySecurity(HKEY, ПИнфОБезопасности, ДЕСКРБЕЗОП*);
цел RegGetKeySecurity(HKEY, ПИнфОБезопасности, ДЕСКРБЕЗОП*, убцел);
цел RegNotifyChangeKeyValue(HKEY, бул, бцел, ук, бул);
бул IsValidCodePage(бцел);
бцел GetOEMCP();
//бул GetCPInfo(бцел, LPCPINFO);
бул IsDBCSLeadByte(ббайт);
бул IsDBCSLeadByteEx(бцел, ббайт);
бул IsValidLocale(ЛКИД, бцел);
ЛКИД GetThreadLocale();
бул SetThreadLocale(ЛКИД);
LANGID GetSystemDefaultLangID();
LANGID GetUserDefaultLangID();
ЛКИД GetSystemDefaultLCID();
ЛКИД GetUserDefaultLCID();
бул GetNumberOfConsoleInputEvents(ук, бцел*);
КООРД GetLargestConsoleWindowSize(ук);
бул GetConsoleCursorInfo(ук, ИНФОКОНСКУРСОР*);
бул GetNumberOfConsoleMouseButtons(убцел);
бул SetConsoleCtrlHandler(PHANDLER_ROUTINE, бул);
бул GenerateConsoleCtrlEvent(бцел, бцел);
бул AllocConsole();
бцел WNetConnectionDialog(УОК, бцел);
бцел WNetDisconnectDialog(УОК, бцел);
бцел WNetCloseEnum(ук);
бул CloseServiceHandle(SC_HANDLE);
//бул ControlService(SC_HANDLE, бцел, LPSERVICE_STATUS);
бул DeleteService(SC_HANDLE);
SC_LOCK LockServiceDatabase(SC_HANDLE);
бул NotifyBootConfigStatus(бул);
бул QueryServiceObjectSecurity(SC_HANDLE, ПИнфОБезопасности, ДЕСКРБЕЗОП*, бцел, убцел);
//бул QueryServiceStatus(SC_HANDLE, LPSERVICE_STATUS);
бул SetServiceObjectSecurity(SC_HANDLE, ПИнфОБезопасности, ДЕСКРБЕЗОП*);
//бул SetServiceStatus(SERVICE_STATUS_HANDLE, LPSERVICE_STATUS);
бул UnlockServiceDatabase(SC_LOCK);
цел ChoosePixelFormat(HDC, ДЕСКРФОРМАТАПИКСЕЛЯ*);
цел DescribePixelFormat(HDC, цел, бцел, ДЕСКРФОРМАТАПИКСЕЛЯ*);
бул SetPixelFormat(HDC, цел, ДЕСКРФОРМАТАПИКСЕЛЯ*);
бул SwapBuffers(HDC);
//бул DragQueryPoцел(HDROP, ТОЧКА*);
//проц DragFinish(HDROP);
проц DragAcceptFiles(УОК, бул);
УИконка DuplicateIcon(экз, УИконка);
//бул DdeAbandonTransaction(бцел, HCONV, бцел);
//ббайт* DdeAccessData(HDDEDATA, бцел*);
//HDDEDATA DdeAddData(HDDEDATA, ббайт*, бцел, бцел);
//HDDEDATA DdeClientTransaction(ббайт*, бцел, HCONV, HSZ, бцел, бцел, бцел, бцел*);
//цел DdeCmpStringHandles(HSZ, HSZ);
//HCONV DdeConnect(бцел, HSZ, HSZ, CONVCONTEXT*);
//HCONVLIST DdeConnectList(бцел, HSZ, HSZ, HCONVLIST, PCONVCONTEXT);
//HDDEDATA DdeCreateDataHandle(бцел, уббайт, бцел, бцел, HSZ, бцел, бцел);
//бул DdeDisconnect(HCONV);
//бул DdeDisconnectList(HCONVLIST);
//бул DdeEnableCallback(бцел, HCONV, бцел);
//бул DdeFreeDataHandle(HDDEDATA);
//бул DdeFreeStringHandle(бцел, HSZ);
//бцел DdeGetData(HDDEDATA, ббайт*, бцел, бцел);
бцел DdeGetLastError(бцел);
//бул DdeImpersonateClient(HCONV);
//бул DdeKeepStringHandle(бцел, HSZ);
//HDDEDATA DdeNameService(бцел, HSZ, HSZ, бцел);
//бул DdePostAdvise(бцел, HSZ, HSZ);
//бцел DdeQueryConvInfo(HCONV, бцел, PCONVINFO);
//HCONV DdeQueryNextServer(HCONVLIST, HCONV);
//HCONV DdeReconnect(HCONV);
//бул DdeSetUserHandle(HCONV, бцел, бцел);
//бул DdeUnaccessData(HDDEDATA);
бул DdeUninitialize(бцел);
проц SHдобавьToRecentDocs(бцел);
//LPITEMIDLIST SHBrowseForFolder(LPBROWSEINFO);
проц SHChangeNotify(цел, бцел, ук);
//цел SHFileOperationA(LPSHFILEOPSTRUCTA);
//цел SHFileOperationW(LPSHFILEOPSTRUCTW);
проц SHFreeNameMappings(ук);
//бцел SHGetFileInfo(ткст0, бцел, SHFILEINFO*, бцел, бцел);
//бул SHGetPathFromIDList(LPCITEMIDLIST, ткст0 );
//HRESULT SHGetSpecialFolderLocation(УОК, цел, LPITEMIDLIST*);
//бул DdeSetQualityOfService(УОК, TSECURITYQUALITYOFSERVICE*, PSECURITYQUALITYOFSERVICE);
бул GetCommMask(ук, бцел*);

бцел GetKerningPairs(HDC, бцел, ук);
бул PostQueuedCompletionStatus (ук, бцел, бцел, АСИНХРОН*);

бул GetQueuedCompletionStatus(ук, бцел*, ULONG_PTR*, АСИНХРОН**, бцел);
бул GetQueuedCompletionStatusEx(ук, АСИНХЗАП*, бцел, бцел*, бцел, бул);
бул GetSystemPowerStatus(СТАТПИТОС*);
//бул wglDescribeLayerPlane(HDC, цел, цел, бцел, TLAYERPLANEDESCRIPTOR*);
цел wglGetLayerPaletteEntries(HDC, цел, цел, цел, ук);
цел wglSetLayerPaletteEntries(HDC, цел, цел, цел, ук);
//бцел WNetGetResourceParentA(PNETRESOURCEA, ук, бцел*);
ук OpenWaitableTimerA(бцел dwDesiredAccess, бул bInheritHandle, ткст0 lpTimerName);
ук OpenWaitableTimerW(бцел dwDesiredAccess, бул bInheritHandle, шткст0 lpTimerName);
//бул SetWaitableTimer(ук hTimer, БОЛЬШЕЦЕЛ* pDueTime, цел lPeriod, PTIMERAPCROUTINE pfnCompletionRoutine, ук lpArgToCompletionRoutine, бул fResume);
    бул FlushFileBuffers(ук файлУк);

/+
бул GlobalMemoryStatusEx(LPMEMORYSTATUSEX буф);
+/
бул IsBadCodePtr(  FARPROC lpfn);
бул IsBadReadPtr(ук, бцел);
бул IsBadWritePtr(ук, бцел);
бул IsBadHugeReadPtr(ук, бцел);
бул IsBadHugeWritePtr(ук, бцел);

цел  InterlockedIncrement(цел* lpAddend);
цел  InterlockedDecrement(цел* lpAddend);
цел  InterlockedExchange(цел* Target, цел Value);
цел  InterlockedExchangeAdd(цел* Addend, цел Value);
ук InterlockedCompareExchange(ук *Destination, ук Exchange, ук Comperand);

проц InitializeCriticalSection(КРИТСЕКЦ * lpCriticalSection);
проц EnterCriticalSection(КРИТСЕКЦ * lpCriticalSection);
бул TryEnterCriticalSection(КРИТСЕКЦ * lpCriticalSection);
проц LeaveCriticalSection(КРИТСЕКЦ * lpCriticalSection);


    int WSAGetLastError ();
    int WSAGetOverlappedResult (ук, АСИНХРОН*, бцел*, бул, бцел*);
    int WSAIoctl (ук s, бцел op, ук inBuf, бцел cbIn, ук outBuf, бцел cbOut, бцел* результат, АСИНХРОН*, ук);
    int WSARecv (ук, ВИНСОКБУФ*, бцел, бцел*, бцел*, АСИНХРОН*, ук);
    int WSASend (ук, ВИНСОКБУФ*, бцел, бцел*, бцел, АСИНХРОН*, ук);


////////////////////
цел GetLocaleInfoW(ЛКИД, т_локаль, шткст0, цел);
бул SetLocaleInfoW(ЛКИД, т_локаль, шткст0);
бул GetDiskFreeSpaceExA(ткст0, ББОЛЬШЕЦЕЛ*, ББОЛЬШЕЦЕЛ*, ББОЛЬШЕЦЕЛ*);
бул GetDiskFreeSpaceExW(шткст0, ББОЛЬШЕЦЕЛ*, ББОЛЬШЕЦЕЛ*, ББОЛЬШЕЦЕЛ*);
бцел GetLogicalDriveStringsA(бцел, ткст0);
бцел GetTempPathW(бцел, шткст0);
бцел GetTempPathA(бцел, ткст0);
бул SetCurrentDirectoryA(ткст0 имяПути);//
бул SetCurrentDirectoryW(шткст0 имяПути);//
бцел GetCurrentDirectoryA(бцел nBufferLength, ткст0  буф);//
бцел GetCurrentDirectoryW(бцел nBufferLength, шткст0 буф);//
бул RemoveDirectoryA(ткст0 имяПути);//
бул RemoveDirectoryW(шткст0 имяПути);//
бул   DeleteFileA(in ткст0 lpFileName);//
бул   DeleteFileW(шткст0 lpFileName);//
бул   FindClose(ук hFindFile);//
ук FindFirstFileA(in ткст0 lpFileName, ПОИСК_ДАННЫХ_А* lpFindFileData);//
ук FindFirstFileW(in шткст0 lpFileName, ПОИСК_ДАННЫХ* lpFindFileData);//
бул   FindNextFileA(ук hFindFile, ПОИСК_ДАННЫХ_А* lpFindFileData);//
бул   FindNextFileW(ук hFindFile, ПОИСК_ДАННЫХ* lpFindFileData);//
бул   GetExitCodeThread(ук hThread, бцел *lpExitCode);//
бцел  GetLastError();//
бцел  GetFileAttributesA(in ткст0 lpFileName);//
бцел  GetFileAttributesW(in wchar *lpFileName);//
бцел  GetFileSize(ук hFile, бцел *lpFileSizeHigh);//
бул   MoveFileA(in ткст0 from, in ткст0 to);//
бул   MoveFileW(шткст0 lpExistingFileName, шткст0 lpNewFileName);//
бул   ReadFile(ук hFile, проц *буф, бцел nNumberOfBytesToRead, бцел *lpNumberOfBytesRead, АСИНХРОН *lpOverlapped);//
бцел  SetFilePointer(ук hFile, цел lDistanceToMove, цел *lpDistanceToMoveHigh, бцел dwMoveMethod);//
бул   WriteFile(ук hFile, in проц *буф, бцел nNumberOfBytesToWrite, бцел *lpNumberOfBytesWritten, АСИНХРОН *lpOverlapped);//
бцел  GetModuleFileNameA(экз hModule, ткст0  lpFilename, бцел разм);//
экз GetModuleHandleA(ткст0 lpModuleName);//
ук GetStdHandle(бцел nStdHandle);//
бул   SetStdHandle(бцел nStdHandle, ук hHandle);//
экз LoadLibraryA(ткст0 lpLibFileName);//
экз LoadLibraryW(шткст0);//
экз LoadLibraryExA(ткст0, ук, бцел);//
экз LoadLibraryExW(шткст0, ук, бцел);//
FARPROC GetProcAddress(экз hModule, ткст0 lpProcName);//
бул FreeLibrary(экз hLibModule);//
проц FreeLibraryAndExitThread(экз hLibModule, бцел dwExitCode);//

цел MessageBoxA(УОК окно, ткст0 lpText, ткст0 lpCaption, бцел uType);//
цел MessageBoxExA(УОК окно, ткст0 lpText, ткст0 lpCaption, бцел uType, бкрат wLanguageId);//
цел MessageBoxW(УОК окно, шткст0 lpText, шткст0 lpCaption, бцел uType);//
цел MessageBoxExW(УОК окно, шткст0 lpText, шткст0 lpCaption, бцел uType, бкрат wLanguageId);//

цел RegDeleteKeyA(HKEY рКлюч, ткст0 рПодКлюч);//
цел RegDeleteValueA(HKEY рКлюч, ткст0 lpValueName);//
цел  RegEnumKeyExA(HKEY рКлюч, бцел dwIndex, ткст0  lpName, бцел* lpcbName, бцел* резерв, ткст0  lpClass, бцел* lpcbClass, ФВРЕМЯ* lpftLastWriteTime);//
цел RegEnumValueA(HKEY рКлюч, бцел dwIndex, ткст0  lpValueName, бцел* lpcbValueName, бцел* резерв,
    бцел* lpType, уббайт lpData, бцел* lpcbData);//
цел RegCloseKey(HKEY рКлюч);//
цел RegFlushKey(HKEY рКлюч);//
цел RegOpenKeyA(HKEY рКлюч, ткст0 рПодКлюч, PHKEY phkResult);//
цел RegOpenKeyExA(HKEY рКлюч, ткст0 рПодКлюч, бцел ulOptions, REGSAM samDesired, PHKEY phkResult);//
цел RegQueryInfoKeyA(HKEY рКлюч, ткст0  lpClass, бцел* lpcbClass,
    бцел* резерв, бцел* рПодКлючи, бцел* lpcbMaxSubKeyLen, бцел* lpcbMaxClassLen,
    бцел* lpcValues, бцел* lpcbMaxValueNameLen, бцел* lpcbMaxValueLen, бцел* lpcbSecurityDescriptor,
    ФВРЕМЯ* lpftLastWriteTime);//
цел RegQueryValueA(HKEY рКлюч, ткст0 рПодКлюч, ткст0  lpValue,  цел* lpcbValue);//
цел RegCreateKeyExA(HKEY рКлюч, ткст0 рПодКлюч, бцел Reserved, ткст0  lpClass,
   бцел dwOptions, REGSAM samDesired, БЕЗАТРЫ* lpSecurityAttributes,
    PHKEY phkResult, бцел* lpdwDisposition);//
цел RegSetValueExA(HKEY рКлюч, ткст0 lpValueName, бцел Reserved, бцел dwType, ббайт* lpData, бцел cbData);//

 бул  FreeResource(гук hResData);//
 ук LockResource(гук hResData);//
 гук GlobalHandle(ук);//
гук GlobalAlloc(бцел, бцел);//
гук GlobalReAlloc(гук, бцел, бцел);//
бцел GlobalSize(гук);//
бцел GlobalFlags(гук);//
ук GlobalLock(гук);//
 бул GlobalUnlock(гук уПам);//
 гук GlobalFree(гук уПам);//
 бцел GlobalCompact(бцел dwMinFree);//
 проц GlobalFix(гук уПам);//
 проц GlobalUnfix(гук уПам);//
 ук GlobalWire(гук уПам);//
 бул GlobalUnWire(гук уПам);//
 проц GlobalMemoryStatus(СТАТПАМ* буф);//
 лук LocalAlloc(бцел uFlags, бцел uBytes);//
 лук LocalReAlloc(лук уПам, бцел uBytes, бцел uFlags);//
 ук LocalLock(лук уПам);//
 лук LocalHandle(ук pMem);//
 бул LocalUnlock(лук уПам);//
 бцел LocalSize(лук уПам);//
 бцел LocalFlags(лук уПам);//
 лук LocalFree(лук уПам);//
 бцел LocalShrink(лук уПам, бцел cbNewSize);//
 бцел LocalCompact(бцел uMinFree);//
 бул FlushInstructionCache(ук hProcess, ук lpBaseAddress, бцел dwSize);//
 ук VirtualAlloc(ук lpAddress, бцел dwSize, бцел flAllocationType, бцел flProtect);//
 бул VirtualFree(ук lpAddress, бцел dwSize, бцел dwFreeType);//
 бул VirtualProtect(ук lpAddress, бцел dwSize, бцел flNewProtect, бцел* lpflOldProtect);//
 бцел VirtualQuery(ук lpAddress, БАЗИОП* буф, бцел dwLength);//
 ук VirtualAllocEx(ук hProcess, ук lpAddress, бцел dwSize, бцел flAllocationType, бцел flProtect);//
 бул VirtualFreeEx(ук hProcess, ук lpAddress, бцел dwSize, бцел dwFreeType);//
 бул VirtualProtectEx(ук hProcess, ук lpAddress, бцел dwSize, бцел flNewProtect, бцел* lpflOldProtect);//
 бцел VirtualQueryEx(ук hProcess, ук lpAddress, БАЗИОП* буф, бцел dwLength);//
 проц RtlFillMemory( ук Destination,  т_мера Length,  ббайт Fill);//
т_мера GetLargePageMinimum();//Не найдена!!!!
бцел GetWriteWatch(  бцел dwFlags,  ук lpBaseAddress,  т_мера dwRegionSize,  ук* lpAddresses,  бдол* lpdwCount,  бцел* lpdwGranularity);//
проц RtlCopyMemory(ук Destination, ук Source,  т_мера Length);//
бул IsBadStringPtrA(ткст0, бцел);//
бул IsBadStringPtrW(шткст0, бцел);//
проц RtlMoveMemory( ук Destination,  ук Source,  т_мера Length);//
бцел ResetWriteWatch(  ук lpBaseAddress,  т_мера dwRegionSize);
ук RtlSecureZeroMemory(  ук ptr,  т_мера cnt);//Не найдена!!!
проц RtlZeroMemory(  ук Destination,  т_мера Length);//

ук HeapCreate(бцел, бцел, бцел);//
бул HeapDestroy(ук);//
ук HeapAlloc(ук, бцел, бцел);//
ук HeapReAlloc(ук, бцел, ук, бцел);//
бул HeapFree(ук, бцел, ук);//
бцел HeapSize(ук, бцел, ук);//
бул HeapValidate(ук, бцел, ук);//
бцел HeapCompact(ук, бцел);//
бул HeapLock(ук);//
бул HeapUnlock(ук);//
бул HeapWalk(ук, ЗАППРОЦКУЧ*);//
бул HeapQueryInformation(  ук HeapHandle,  бцел HeapInformationClass,  ук HeapInformation,
  т_мера HeapInformationLength,  т_мера* ВозвращаетLength);//
бул HeapSetInformation(  ук HeapHandle,  бцел HeapInformationClass,  ук HeapInformation,  т_мера HeapInformationLength);//
ук GetProcessHeap();//
бцел GetProcessHeaps(бцел, ук*);//

проц GetSystemTime(СИСТВРЕМЯ* lpSystemTime);//
бул GetFileTime(ук hFile, ФВРЕМЯ *lpCreationTime, ФВРЕМЯ *lpLastAccessTime, ФВРЕМЯ *lpLastWriteTime);//
проц GetSystemTimeAsFileTime(ФВРЕМЯ* lpSystemTimeAsFileTime);//
бул SetSystemTime(СИСТВРЕМЯ* lpSystemTime);//
бул SetFileTime(ук hFile, in ФВРЕМЯ *lpCreationTime, in ФВРЕМЯ *lpLastAccessTime, in ФВРЕМЯ *lpLastWriteTime);//
проц GetLocalTime(СИСТВРЕМЯ* lpSystemTime);//
бул SetLocalTime(СИСТВРЕМЯ* lpSystemTime);//
бул SystemTimeToTzSpecificLocalTime(ИНФОЧП* lpTimeZoneInformation, СИСТВРЕМЯ* lpUniversalTime, СИСТВРЕМЯ* lpLocalTime);//
бцел GetTimeZoneInformation(ИНФОЧП* lpTimeZoneInformation);//
бул SetTimeZoneInformation(ИНФОЧП* lpTimeZoneInformation);//

бул SystemTimeToFileTime(in СИСТВРЕМЯ *lpSystemTime, ФВРЕМЯ* lpFileTime);//
бул FileTimeToLocalFileTime(in ФВРЕМЯ *lpFileTime, ФВРЕМЯ* lpLocalFileTime);//
бул LocalFileTimeToFileTime(in ФВРЕМЯ *lpLocalFileTime, ФВРЕМЯ* lpFileTime);//
бул FileTimeToSystemTime(in ФВРЕМЯ *lpFileTime, СИСТВРЕМЯ* lpSystemTime);//
бул FileTimeToDosDateTime(in ФВРЕМЯ *lpFileTime, бкрат* lpFatDate, бкрат* lpFatTime);//
бул DosDateTimeToFileTime(бкрат wFatDate, бкрат wFatTime, ФВРЕМЯ* lpFileTime);//
бул SetSystemTimeAdjustment(бцел dwTimeAdjustment, бул bTimeAdjustmentDisabled);//
бул GetSystemTimeAdjustment(бцел* lpTimeAdjustment, бцел* lpTimeIncrement, бул* lpTimeAdjustmentDisabled);//

бцел FormatMessageA(бцел dwFlags, ук lpSource, бцел dwMessageId, бцел dwLanguageId, ткст0  буф, бцел разм, ук *Arguments);//
бцел FormatMessageW(бцел dwFlags, ук lpSource, бцел dwMessageId, бцел dwLanguageId, шткст0 буф, бцел разм, ук *Arguments);//

бул GetProcessTimes(ук hProcess, ФВРЕМЯ* lpCreationTime, ФВРЕМЯ* lpExitTime, ФВРЕМЯ* lpKernelTime, ФВРЕМЯ* lpUserTime);//
бул DuplicateHandle (ук sourceProcess, ук sourceThread,
        ук targetProcessHandle, ук *targetHandle, бцел access,
        бул inheritHandle, бцел options);//
бул SetThreadPriority(ук hThread, цел nPriority);//
бул SetThreadPriorityBoost(ук hThread, бул bDisablePriorityBoost);//
бул GetThreadPriorityBoost(ук hThread, бул* pDisablePriorityBoost);//
бул GetThreadTimes(ук hThread, ФВРЕМЯ* lpCreationTime, ФВРЕМЯ* lpExitTime, ФВРЕМЯ* lpKernelTime, ФВРЕМЯ* lpUserTime);
цел GetThreadPriority(ук hThread);//
бул GetThreadContext(ук hThread, КОНТЕКСТ* lpContext);//
бул SetThreadContext(ук hThread, КОНТЕКСТ* lpContext);//
бцел SuspendThread(ук hThread);//
бцел ResumeThread(ук hThread);//
бцел WaitForSingleObject(ук hHandle, бцел dwMilliseconds);//
бцел WaitForMultipleObjects(бцел nCount, ук *lpHandles, бул bWaitAll, бцел dwMilliseconds);//
проц Sleep(бцел dwMilliseconds);//

бул QueryPerformanceCounter(дол* lpPerformanceCount);//
бул QueryPerformanceFrequency(дол* lpFrequency);//

шткст0   GetCommandLineW();//

проц ExitProcess(бцел);
бул GetExitCodeProcess(ук hProcess, бцел* lpExitCode);
бул CreateProcessAsUserA(ук, ткст0, ткст0 , БЕЗАТРЫ*, БЕЗАТРЫ*, бул, бцел, ук, ткст0, ИНФОСТАРТА*, ИНФОПРОЦ*);
бул CreateProcessAsUserW(ук, шткст0, шткст0, БЕЗАТРЫ*, БЕЗАТРЫ*, бул, бцел, ук, шткст0, ИНФОСТАРТА*, ИНФОПРОЦ*);


бул GetProcessAffinityMask(ук, бцел*, бцел*);
бул GetProcessWorkingSetSize(ук, бцел*, бцел*);
бул SetProcessWorkingSetSize(ук, бцел, бцел);
ук OpenProcess(бцел, бул, бцел);
ук GetCurrentProcess();//
бцел GetCurrentProcessId();//
бул TerminateProcess(ук, бцел);
ук OpenFileMappingA(бцел, бул, ткст0);
ук OpenFileMappingW(бцел, бул, шткст0);


шткст0 SysAllocString(in шткст0 psz);
цел SysReAllocString(шткст0, in шткст0 psz);
шткст0 SysAllocStringLen(in шткст0 psz, бцел длин);
цел SysReAllocStringLen(шткст0, in шткст0 psz, бцел длин);
проц SysFreeString(шткст0);
бцел SysStringLen(шткст0);
бцел SysStringByteLen(шткст0);
шткст0 SysAllocStringByteLen(in ubyte* psz, бцел длин);
цел CoCreateGuid(out ГУИД pGuid);
цел ProgIDFromCLSID(ref ГУИД clsid, out шткст0 lplpszProgID);
цел CLSIDFromProgID(in шткст0 lpszProgID, КЛСИД* lpclsid);
цел CLSIDFromProgIDEx(in шткст0 lpszProgID, КЛСИД* lpclsid);
цел CoCreateInstance(ref КЛСИД rclsid, sys.WinIfaces.Инкогнито* pUnkOuter, бцел dwClsContext, ref ИИД riid, ук* ppv);
цел CoGetClassObject(ref ГУИД rclsid, бцел dwClsContext, ук pvReserved, ref ГУИД riid, ук* ppv);
цел CoCreateInstanceEx(ref ГУИД rclsid, sys.WinIfaces.Инкогнито pUnkOuter, бцел dwClsContext, sys.WinStructs.КОСЕРВЕРИНФО* pServerInfo, бцел dwCount, sys.WinStructs.МУЛЬТИ_ОИ* pResults);
цел RegisterActiveObject(sys.WinIfaces.Инкогнито punk, ref ГУИД rclsid, бцел dwFlags, out бцел pdwRegister);
цел RevokeActiveObject(бцел dwRegister, ук pvReserved);
цел GetActiveObject(ref ГУИД rclsid, ук pvReserved, out sys.WinIfaces.Инкогнито ppunk);

цел SafeArrayAllocDescriptor(бцел cDims, out БЕЗОПМАС* ppsaOut);
цел SafeArrayAllocDescriptorEx(бкрат вт, бцел cDims, out БЕЗОПМАС* ppsaOut);
цел SafeArrayAllocData(БЕЗОПМАС* psa);
БЕЗОПМАС* SafeArrayCreate(бкрат вт, бцел cDims, sys.WinStructs.ГРАНБЕЗОПМАСА* rgsabound);
БЕЗОПМАС* SafeArrayCreateEx(бкрат вт, бцел cDims, sys.WinStructs.ГРАНБЕЗОПМАСА* rgsabound, ук pvExtra);
цел SafeArrayCopyData(БЕЗОПМАС* psaSource, БЕЗОПМАС* psaTarget);
цел SafeArrayDestroyDescriptor(БЕЗОПМАС* psa);
цел SafeArrayDestroyData(БЕЗОПМАС* psa);
цел SafeArrayDestroy(БЕЗОПМАС* psa);
цел SafeArrayRedim(БЕЗОПМАС* psa, sys.WinStructs.ГРАНБЕЗОПМАСА* psaboundNew);
бцел SafeArrayGetDim(БЕЗОПМАС* psa);
бцел SafeArrayGetElemsize(БЕЗОПМАС* psa);
цел SafeArrayGetUBound(БЕЗОПМАС* psa, бцел cDim, out цел plUbound);
цел SafeArrayGetLBound(БЕЗОПМАС* psa, бцел cDim, out цел plLbound);
цел SafeArrayLock(БЕЗОПМАС* psa);
цел SafeArrayUnlock(БЕЗОПМАС* psa);
цел SafeArrayAccessData(БЕЗОПМАС* psa, ук* ppvData);
цел SafeArrayUnaccessData(БЕЗОПМАС* psa);
цел SafeArrayGetElement(БЕЗОПМАС* psa, цел* rgIndices, ук pv);
цел SafeArrayPutElement(БЕЗОПМАС* psa, цел* rgIndices, ук pv);
цел SafeArrayCopy(БЕЗОПМАС* psa, out БЕЗОПМАС* ppsaOut);
цел SafeArrayPtrOfIndex(БЕЗОПМАС* psa, цел* rgIndices, ук* ppvData);
цел SafeArraySetRecordInfo(БЕЗОПМАС* psa, sys.WinIfaces.IRecordInfo prinfo);
цел SafeArrayGetRecordInfo(БЕЗОПМАС* psa, out sys.WinIfaces.IRecordInfo prinfo);
цел SafeArraySetIID(БЕЗОПМАС* psa, ref ГУИД guid);
цел SafeArrayGetIID(БЕЗОПМАС* psa, out ГУИД pguid);
цел SafeArrayGetVartype(БЕЗОПМАС* psa, out бкрат pvt);
БЕЗОПМАС* SafeArrayCreateVector(бкрат вт, цел lLbound, бцел cElements);
БЕЗОПМАС* SafeArrayCreateVectorEx(бкрат вт, цел lLbound, бцел cElements, ук pvExtra);

цел VarDecFromUI4(бцел ulIn, out ДЕСЯТОК pdecOut);
цел VarDecFromI4(цел lIn, out ДЕСЯТОК pdecOut);
цел VarDecFromUI8(ulong ui64In, out ДЕСЯТОК pdecOut);
цел VarDecFromI8(long i64In, out ДЕСЯТОК pdecOut);
цел VarDecFromR4(float dlbIn, out ДЕСЯТОК pdecOut);
цел VarDecFromR8(double dlbIn, out ДЕСЯТОК pdecOut);
цел VarDecFromStr(in шткст0 StrIn, бцел лкид, бцел dwFlags, out ДЕСЯТОК pdecOut);
цел VarBstrFromDec(ref ДЕСЯТОК pdecIn, бцел лкид, бцел dwFlags, out шткст0 pbstrOut);
цел VarUI4FromDec(ref ДЕСЯТОК pdecIn, out бцел pulOut);
цел VarI4FromDec(ref ДЕСЯТОК pdecIn, out цел plOut);
цел VarUI8FromDec(ref ДЕСЯТОК pdecIn, out ulong pui64Out);
цел VarI8FromDec(ref ДЕСЯТОК pdecIn, out long pi64Out);
цел VarR4FromDec(ref ДЕСЯТОК pdecIn, out float pfltOut);
цел VarR8FromDec(ref ДЕСЯТОК pdecIn, out double pdblOut);

цел VarDecAdd(ref ДЕСЯТОК pdecLeft, ref ДЕСЯТОК pdecRight, out ДЕСЯТОК pdecResult);
цел VarDecSub(ref ДЕСЯТОК pdecLeft, ref ДЕСЯТОК pdecRight, out ДЕСЯТОК pdecResult);
цел VarDecMul(ref ДЕСЯТОК pdecLeft, ref ДЕСЯТОК pdecRight, out ДЕСЯТОК pdecResult);
цел VarDecDiv(ref ДЕСЯТОК pdecLeft, ref ДЕСЯТОК pdecRight, out ДЕСЯТОК pdecResult);

цел VarDecRound(ref ДЕСЯТОК pdecIn, цел cDecimals, out ДЕСЯТОК pdecResult);
цел VarDecAbs(ref ДЕСЯТОК pdecIn, out ДЕСЯТОК pdecResult);
цел VarDecFix(ref ДЕСЯТОК pdecIn, out ДЕСЯТОК pdecResult);
цел VarDecInt(ref ДЕСЯТОК pdecIn, out ДЕСЯТОК pdecResult);
цел VarDecNeg(ref ДЕСЯТОК pdecIn, out ДЕСЯТОК pdecResult);
цел VarDecCmp(ref ДЕСЯТОК pdecLeft, out ДЕСЯТОК pdecRight);

цел VarBstrFromDec(ДЕСЯТОК* pdecIn, бцел лкид, бцел dwFlags, out шткст0 pbstrOut);
цел VarR8FromDec(ДЕСЯТОК* pdecIn, out double pdblOut);
цел VarDecNeg(ДЕСЯТОК* pdecIn, out ДЕСЯТОК pdecResult);

проц VariantInit(ref ВАРИАНТ pvarg);
цел VariantClear(ref ВАРИАНТ pvarg);
цел VariantCopy(ref ВАРИАНТ pvargDest, ref ВАРИАНТ pvargSrc);

цел VarAdd(ref ВАРИАНТ pvarLeft, ref ВАРИАНТ pvarRight, out ВАРИАНТ pvarResult);
цел VarAnd(ref ВАРИАНТ pvarLeft, ref ВАРИАНТ pvarRight, out ВАРИАНТ pvarResult);
цел VarCat(ref ВАРИАНТ pvarLeft, ref ВАРИАНТ pvarRight, out ВАРИАНТ pvarResult);
цел VarDiv(ref ВАРИАНТ pvarLeft, ref ВАРИАНТ pvarRight, out ВАРИАНТ pvarResult);
цел VarMod(ref ВАРИАНТ pvarLeft, ref ВАРИАНТ pvarRight, out ВАРИАНТ pvarResult);
цел VarMul(ref ВАРИАНТ pvarLeft, ref ВАРИАНТ pvarRight, out ВАРИАНТ pvarResult);
цел VarOr(ref ВАРИАНТ pvarLeft, ref ВАРИАНТ pvarRight, out ВАРИАНТ pvarResult);
цел VarSub(ref ВАРИАНТ pvarLeft, ref ВАРИАНТ pvarRight, out ВАРИАНТ pvarResult);
цел VarXor(ref ВАРИАНТ pvarLeft, ref ВАРИАНТ pvarRight, out ВАРИАНТ pvarResult);
цел VarCmp(ref ВАРИАНТ pvarLeft, ref ВАРИАНТ pvarRight, бцел лкид, бцел dwFlags);

цел VariantChangeType(ref ВАРИАНТ pvargDest, ref ВАРИАНТ pvarSrc, бкрат wFlags, бкрат вт);
цел VariantChangeTypeEx(ref ВАРИАНТ pvargDest, ref ВАРИАНТ pvarSrc, бцел лкид, бкрат wFlags, бкрат вт);

цел SetErrorInfo(бцел dwReserved, ИИнфОбОш perrinfo);
цел GetErrorInfo(бцел dwReserved, out ИИнфОбОш pperrinfo);
цел CreateErrorInfo(out ИИнфОбОш pperrinfo);

цел CoInitialize(ук);
проц CoUninitialize();
цел CoInitializeEx(ук, бцел dwCoInit);

ук CoTaskMemAlloc(т_мера cb);
ук CoTaskMemRealloc(ук pv, т_мера cb);
проц CoTaskMemFree(ук pv);
проц SetLastError(бцел);
проц SetLastErrorEx(бцел, бцел);
бул SetEndOfFile(ук);

бул GetCommState(ук, СКУ*);
бул SetCommState(ук, СКУ*);

бул GetVersionExW(ИНФОВЕРСИИОС*);
бул GetVersionExA(ИНФОВЕРСИИОС_А*);

бул MoveFileExW(шткст0, шткст0, бцел);
бул MoveFileExA(ткст0, ткст0, бцел);

//бул ХостИмяДнсВИмяКомпьютераА()

    /+

    BOOL DnsHostnameToComputerName(
        ткст0 Hostname,
        LPTSTR ComputerName,
        бцел* разм
    );
+/

бул GetVolumePathNameW(шткст0, шткст0, бцел);
бул GetVolumePathNameA(ткст0, ткст0, бцел);

//бул CreateProcessWithLogonW( шткст0 lpUsername, шткст0 lpDomain, шткст0 lpPassword, бцел dwLogonFlags,  шткст0 lpApplicationName,  шткст0 lpCommandLine,  бцел dwCreationFlags,  ук lpEnvironment,  шткст0 lpCurrentDirectory,  LPSTARTUPINFOW lpStartupInfo, ИНФОПРОЦ* lpProcessInfo);

/+
// TODO: MinGW Реализует these in assembly.  How to translate?
ук GetCurrentFiber();
ук GetFiberData();

+/

		alias цел function(ИСКЛУКАЗЫ*) ВЕКТОРНЫЙ_ОБРАБОТЧИК_ИСКЛЮЧЕНИЯ, PVECTORED_EXCEPTION_HANDLER;
		
		alias проц function( бцел кодОш, бцел члоПеремещБайт, АСИНХРОН *асинх) ПРОЦЕДУРА_АСИНХ_ВЫПОЛНЕНИЯ_ВВ, LPOVERLAPPED_COMPLETION_ROUTINE ;

		alias проц function(ук, бул) ПРОЦ_ОТВЕТА_ТАЙМЕРА, WAITORTIMERCALLBACK;
		
		alias проц function(ук) ПРОЦ_СТАРТА_ФИБРЫ, LPFIBER_START_ROUTINE;		

		alias бцел function(ук) ПРОЦ_СТАРТА_НИТИ, LPTHREAD_START_ROUTINE;
		
			alias бцел function(БОЛЬШЕЦЕЛ, БОЛЬШЕЦЕЛ, БОЛЬШЕЦЕЛ, БОЛЬШЕЦЕЛ, бцел, бцел, ук, ук, ук) ПРОЦ_ПРОГРЕССА, LPPROGRESS_ROUTINE;

		
	бул ActivateActCtx(ук, бцел**);
	бул GetOverlappedResult(ук, АСИНХРОН*, бцел*, бул);
	АТОМ AddAtomA(ткст0);
	АТОМ AddAtomW(шткст0);
	бцел AddLocalAlternateComputerNameA( ткст0,  бцел );
	бцел AddLocalAlternateComputerNameW( шткст0,  бцел );
	проц AddRefActCtx(ук);
	ук AddVectoredExceptionHandler( бцел, PVECTORED_EXCEPTION_HANDLER);
	бул AllocateUserPhysicalPages(ук, бдол*, бдол*);
	бул AssignProcessToJobObject(ук, ук);
	бул AttachConsole( бцел );
	бул BackupRead(ук, уббайт, бцел, бцел*, бул, бул, ук*);
	бул BackupSeek(ук, бцел, бцел, бцел*, бцел*, ук*);
	бул BackupWrite(ук, уббайт, бцел, бцел*, бул, бул, ук*);
	бул Beep(бцел, бцел);
	ук BeginUpdateResourceA(ткст0, бул);
	ук BeginUpdateResourceW(шткст0, бул);
	бул BindIoCompletionCallback( ук, LPOVERLAPPED_COMPLETION_ROUTINE, бцел);
	бул BuildCommDCBA(ткст0, LPDCB);
	бул BuildCommDCBW(шткст0, LPDCB);
	бул BuildCommDCBAndTimeoutsA(ткст0, LPDCB, LPCOMMTIMEOUTS);
	бул CallNamedPipeA(ткст0, ук, бцел, ук, бцел, бцел*, бцел);
	бул CallNamedPipeW(шткст0, ук, бцел, ук, бцел, бцел*, бцел);
	бул CancelDeviceWakeupRequest(ук);
	бул CancelIo(ук);
	бул CancelWaitableTimer(ук);
	бул ChangeTimerQueueTimer(ук,ук,бцел,бцел);
	бул CancelTimerQueueTimer(ук,ук);
	бул CheckNameLegalDOS8Dot3A(ткст0, ткст0 , бцел, бул*, бул*);
	бул CheckNameLegalDOS8Dot3W(шткст0, ткст0 , бцел, бул*, бул*);
	бул CheckRemoteDebuggerPresent(ук, бул*);
	бул ClearCommBreak(ук);
	бул ClearCommError(ук, бцел*, КОММСТАТ*);
	бул   CloseHandle(ук hObject);
	бул CommConfigDialogA(ткст0, УОК, КОММКОНФИГ*);
	бул CommConfigDialogW(шткст0, УОК, КОММКОНФИГ*);
	цел CompareFileTime(in ФВРЕМЯ*, in ФВРЕМЯ*);
	цел CompareStringA(ЛКИД, бцел, ткст0, цел, ткст0, цел);
	цел CompareStringW(ЛКИД, бцел, шткст0, цел, шткст0, цел);
	бул ConnectNamedPipe(ук, АСИНХРОН*);
	бул ContinueDebugEvent(бцел, бцел, бцел);
	ЛКИД ConvertDefaultLocale(ЛКИД);
	бул ConvertFiberToThread();
	ук ConvertThreadToFiber(ук);
	бул   CopyFileA(ткст0, ткст0, бул);
	бул   CopyFileW(шткст0, шткст0, бул);
	бул CopyFileExA(ткст0, ткст0, LPPROGRESS_ROUTINE, ук, бул*, бцел);
	бул CopyFileExW(шткст0, шткст0, LPPROGRESS_ROUTINE, ук, бул*, бцел);
	ук CreateActCtxA(PCACTCTXA);
	ук CreateActCtxW(PCACTCTXW);
	ук CreateConsoleScreenBuffer(бцел , бцел , in БЕЗАТРЫ*, бцел , ук );
	бул CreateDirectoryA(ткст0 , БЕЗАТРЫ* );
	бул CreateDirectoryW(шткст0 , БЕЗАТРЫ* );
	бул CreateDirectoryExA(ткст0 , ткст0 , БЕЗАТРЫ* );
	бул CreateDirectoryExW(шткст0 , шткст0 , БЕЗАТРЫ* );
	ук CreateEventA(БЕЗАТРЫ*, бул, бул, ткст0);
	ук CreateEventW(БЕЗАТРЫ*, бул, бул, шткст0);
	ук CreateFiber(SIZE_T, LPFIBER_START_ROUTINE, ук);
	ук CreateFiberEx(SIZE_T, SIZE_T, бцел, LPFIBER_START_ROUTINE, ук);
	ук CreateFileA(in ткст0 , бцел , бцел , БЕЗАТРЫ*, бцел , бцел , ук );
	ук CreateFileW(шткст0 , бцел , бцел ,БЕЗАТРЫ*, бцел , бцел , ук );
	ук CreateFileMappingA(ук , БЕЗАТРЫ* , бцел , бцел , бцел , ткст0 );
	ук CreateFileMappingW(ук , БЕЗАТРЫ* , бцел , бцел , бцел , шткст0 );
	бул CreateHardLinkA(ткст0, ткст0, БЕЗАТРЫ*);
	бул CreateHardLinkW(шткст0, шткст0, БЕЗАТРЫ*);
	ук CreateIoCompletionPort(ук, ук, ULONG_PTR, бцел);
	ук CreateJobObjectA(БЕЗАТРЫ*, ткст0);
	ук CreateJobObjectW(БЕЗАТРЫ*, шткст0);
	//CreateJobSet PROTO STDCALL :бцел,:бцел,:бцел
	ук CreateMailslotA(ткст0, бцел, бцел, БЕЗАТРЫ*);
	ук CreateMailslotW(шткст0, бцел, бцел, БЕЗАТРЫ*);
	ук CreateMemoryResourceNotification(MEMORY_RESOURCE_NOTIFICATION_TYPE);
	ук CreateMutexA(БЕЗАТРЫ*, бул, ткст0);
	ук CreateMutexW(БЕЗАТРЫ*, бул, шткст0);
	ук CreateNamedPipeA(ткст0, бцел, бцел, бцел, бцел, бцел, бцел, БЕЗАТРЫ*);
	ук CreateNamedPipeW(шткст0, бцел, бцел, бцел, бцел, бцел, бцел, БЕЗАТРЫ*);
	бул CreatePipe(PHANDLE, PHANDLE, БЕЗАТРЫ*, бцел);
	бул CreateProcessA(ткст0 , ткст0 , БЕЗАТРЫ*, БЕЗАТРЫ*, бул, бцел, ук, ткст0 , ИНФОСТАРТА*, ИНФОПРОЦ*);
	бул CreateProcessW(шткст0, шткст0, БЕЗАТРЫ*, БЕЗАТРЫ*, бул, бцел, ук, шткст0, ИНФОСТАРТА*, ИНФОПРОЦ*);
	//CreateProcessInternalWSecure PROTO STDCALL
	ук CreateRemoteThread(ук, БЕЗАТРЫ*, бцел, LPTHREAD_START_ROUTINE, ук, бцел, бцел*);
	ук CreateSemaphoreA(БЕЗАТРЫ* , цел , цел , ткст0  );
	ук CreateSemaphoreW(БЕЗАТРЫ*, цел, цел, шткст0);
	бцел CreateTapePartition(ук, бцел, бцел, бцел);
	ук CreateThread(БЕЗАТРЫ* ,  size_t ,  LPTHREAD_START_ROUTINE ,  ук ,  бцел ,  бцел* );
	ук CreateTimerQueue();
	бул CreateTimerQueueTimer(PHANDLE, ук, WAITORTIMERCALLBACK, ук, бцел, бцел, бцел);
	ук CreateToolhelp32Snapshot(бцел , бцел );
	ук CreateWaitableTimerA(БЕЗАТРЫ*, бул, ткст0);
	ук CreateWaitableTimerW(БЕЗАТРЫ*, бул, шткст0);
	бул DeactivateActCtx(бцел, ULONG_PTR);
	бул DebugActiveProcess(бцел);
	бул DebugActiveProcessStop(бцел);
	проц DebugBreak();
	бул DebugBreakProcess(ук);
	бул DebugSetProcessKillOnExit(бул);
	//DecodePointer PROTO STDCALL :бцел
	//DecodeSystemPointer PROTO STDCALL :бцел
	бул DefineDosDeviceA(бцел, ткст0, ткст0);
	бул DefineDosDeviceW(бцел, шткст0, шткст0);
	АТОМ DeleteAtom(АТОМ);
	проц DeleteCriticalSection(КРИТСЕКЦ*);
	проц DeleteFiber(ук);
	бул DeleteTimerQueue(ук);
	бул DeleteTimerQueueEx(ук, ук);
	бул DeleteTimerQueueTimer(ук, ук, ук);
	бул DeleteVolumeMountPointA(ткст0);
	бул DeleteVolumeMountPointW(шткст0);
	бул DeviceIoControl(ук, бцел, ук, бцел, ук, бцел, бцел*, АСИНХРОН*);
	бул DisableThreadLibraryCalls(экз);
	бул DisconnectNamedPipe(ук);
	бул DnsHostnameToComputerNameA(ткст0, ткст0 , бцел*);
	бул DnsHostnameToComputerNameW(шткст0, шткст0, бцел*);	
	бул SetFileAttributesA(ткст0, бцел);
	бул SetFilePointerEx(ук, БОЛЬШЕЦЕЛ, БОЛЬШЕЦЕЛ*, бцел);
	бул GetFileSizeEx(ук, БОЛЬШЕЦЕЛ*);
	бул SetFileAttributesW(шткст0, бцел);
	бул GetFileAttributesExW(шткст0, бцел, ФАЙЛ_АТР_ДАН_ВИН32*);
	бул GetFileAttributesExA(ткст0, бцел, ФАЙЛ_АТР_ДАН_ВИН32*);
	бул GetHandleInformation(ук, ПХэндлФ*);
	бул SetHandleInformation(ук, ПХэндлФ, бцел);
	бул   PlaySoundA(ткст0 pszSound, экз hmod, бцел fdwSound);
	бул   PlaySoundW(шткст0 pszSound, экз hmod, бцел fdwSound);

	цел     GetClipBox(HDC, ПРЯМ*);
	цел     GetClipRgn(HDC, HRGN);
	цел     GetMetaRgn(HDC, HRGN);
	HGDIOBJ   GetCurrentObject(HDC, бцел);
	бул    GetCurrentPositionEx(HDC, ТОЧКА*);
	цел     GetDeviceCaps(HDC, цел);
	
	LRESULT SendMessageA(УОК окно, бцел Msg, WPARAM wParam, LPARAM lParam);

	крат         GetFileTitleA(ткст0, ткст0 , бкрат);
	крат         GetFileTitleW(шткст0, шткст0, бкрат);
	
	HDC       CreateCompatibleDC(HDC);

	цел     GetObjectA(HGDIOBJ, цел, ук);
	цел     GetObjectW(HGDIOBJ, цел, ук);
	бул   DeleteDC(HDC);
	
	 УИконка LoadIconA(экз hInstance, ткст0 lpIconName);
	 УИконка LoadIconW(экз hInstance, шткст0 lpIconName);
	 HCURSOR LoadCursorA(экз hInstance, ткст0 lpCursorName);
	 HCURSOR LoadCursorW(экз hInstance, шткст0 lpCursorName);
	 
	  бул    MoveToEx(HDC, цел, цел, ТОЧКА*);
	 бул    TextOutA(HDC, цел, цел, ткст0, цел);
	 бул    TextOutW(HDC, цел, цел, шткст0, цел);
	 
	 проц PostQuitMessage(цел nExitCode);
	LRESULT DefWindowProcA(УОК окно, бцел Msg, WPARAM wParam, LPARAM lParam);
	
	 бул   RoundRect(HDC, цел, цел, цел, цел, цел, цел);
	 бул   ResizePalette(HPALETTE, бцел);
	 цел    SaveDC(HDC);
	 цел    SelectClipRgn(HDC, HRGN);
	 цел    ExtSelectClipRgn(HDC, HRGN, цел);
	 цел    SetMetaRgn(HDC);
	 HGDIOBJ   SelectObject(HDC, HGDIOBJ);
	 HPALETTE   SelectPalette(HDC, HPALETTE, бул);
	 ЦВПредст   SetBkColor(HDC, ЦВПредст);
	 цел     SetBkMode(HDC, цел);
	 цел    SetBitmapBits(УБитмап, бцел, проц *);
	 бцел    SetBoundsRect(HDC,   ПРЯМ *, бцел);
	 цел     SetDIBits(HDC, УБитмап, бцел, бцел, проц *, ИНФОБИТМАП *, бцел);
	 цел     SetDIBitsToDevice(HDC, цел, цел, бцел, бцел, цел,
			цел, бцел, бцел, проц *, ИНФОБИТМАП *, бцел);
	 бцел   SetMapperFlags(HDC, бцел);
	 цел     SetGraphicsMode(HDC hdc, цел iMode);
	 цел     SetMapMode(HDC, цел);
	 HMETAFILE     SetMetaFileBitsEx(бцел, ббайт *);
	 бцел    SetPaletteEntries(HPALETTE, бцел, бцел, ПАЛИТЗАП *);
	 ЦВПредст   SetPixel(HDC, цел, цел, ЦВПредст);
	 бул     SetPixelV(HDC, цел, цел, ЦВПредст);
	 бул    SetPixelFormat(HDC, цел, ДЕСКРФОРМАТАПИКСЕЛЯ *);
	 цел     SetPolyFillMode(HDC, цел);
	 бул    StretchBlt(HDC, цел, цел, цел, цел, HDC, цел, цел, цел, цел, бцел);
	 бул    SetRectRgn(HRGN, цел, цел, цел, цел);
	 цел     StretchDIBits(HDC, цел, цел, цел, цел, цел, цел, цел, цел,
			 проц *, ИНФОБИТМАП *, бцел, бцел);
	 цел     SetROP2(HDC, цел);
	 цел     SetStretchBltMode(HDC, цел);
	 бцел    SetSystemPaletteUse(HDC, бцел);
	 цел     SetTextCharacterExtra(HDC, цел);
	 ЦВПредст   SetTextColor(HDC, ЦВПредст);
	 бцел    SetTextAlign(HDC, бцел);
	 бул    SetTextJustification(HDC, цел, цел);
	 бул    UpdateColors(HDC);
	 
	ук OpenSemaphoreA(бцел dwDesiredAccess, бул bInheritHandle, ткст0 lpName);
    бул ReleaseSemaphore(ук hSemaphore, цел lReleaseCount, цел* lpPreviousCount);
}

export extern(C):
	/**
	*GetUserDefaultLCID
	*/
	ЛКИД ДайДефЛКИДПользователя(){return 
    GetUserDefaultLCID();}
	/**
	*GetEnvironmentStringsW
	*/
	шткст0 ДайСтрокуСреды(){return GetEnvironmentStringsW();}
	/**
	*FreeEnvironmentStringsW
	*/
	бул ОсвободиСтрокуСреды(шткст0 ткт){return FreeEnvironmentStringsW (ткт);}
	/**
	*GetEnvironmentVariableA
	*/
	бцел ДайПеременнуюСредыА(ткст0 перм, ткст0 знач, бцел разм)
	{
	return GetEnvironmentVariableA(перм, знач, разм);
	}
	/**
	*GetEnvironmentVariableW
	*/
	бцел ДайПеременнуюСреды(шткст0 перм, шткст0 знач, бцел разм)
	{
	return GetEnvironmentVariableW(перм, знач, разм);
	}
	/**
	*SetEnvironmentVariableA
	*/
	бул УстановиПеременнуюСредыА(ткст перм, ткст знач)
	{
	return SetEnvironmentVariableA(перм.ptr, знач.ptr);
	}
	/**
	*SetEnvironmentVariableW
	*/
	бул УстановиПеременнуюСреды(ткст перм, ткст знач)
	{
	return cast(бул) SetEnvironmentVariableW(toUTF16z(перм), toUTF16z(знач));
	}

	/**
	*MAKEINTRESOURCEW
	*/
	шткст0 ДЕЛИНТРЕСУРС(цел i) {
    return cast(шткст0)cast(бцел)cast(бкрат)i;
	}
	alias ДЕЛИНТРЕСУРС MAKEINTRESOURCEW, MAKEINTRESOURCE;
	/**
	*WSAGetOverlappedResult
	*/
    int ВСАДайАсинхрРезультат (ук сокет, АСИНХРОН* оверлап, бцел* трансфер, бул ждать, бцел* флаги)
	{
	return WSAGetOverlappedResult(сокет, оверлап, трансфер, ждать, флаги);
	}
		/**
	*WSAIoctl
	*/
    int ВСАВВКонтрл (ук s, бцел op, ук inBuf, бцел cbIn, ук outBuf, бцел cbOut, бцел* результат, АСИНХРОН* оверлап, ук фция)
		{
	return WSAIoctl(s,  op, inBuf, cbIn, outBuf, cbOut, результат, оверлап, фция);
	}
		/**
	*WSARecv
	*/
    int ВСАПрими (ук сок, ВИНСОКБУФ* буф, бцел см, бцел* ссм, бцел* ссмм, АСИНХРОН* ас, ук ф)
		{
	return WSARecv(сок, буф, см, ссм, ссмм, ас,  ф);
	}
		/**
	*WSASend
	*/
    int ВСАШли (ук сок, ВИНСОКБУФ* буф, бцел лл, бцел* олл, бцел оллл, АСИНХРОН* ас, ук ффф)
		{
	return WSASend(сок, буф, лл, олл,  оллл, ас, ффф);
	}	
	/**
	*GetDiskFreeSpaceExA
	*/
	бул ДайСвобДискПространствоДопА(ткст0 имяП, ББОЛЬШЕЦЕЛ* свобБайтыДоступнВызывающему, ББОЛЬШЕЦЕЛ* общЧлоБайт, ББОЛЬШЕЦЕЛ* общЧлоСвобБайт)
	{
	return GetDiskFreeSpaceExA(имяП,  свобБайтыДоступнВызывающему,  общЧлоБайт,  общЧлоСвобБайт);
	}
	/**
	*GetDiskFreeSpaceExW
	*/
	бул ДайСвобДискПространствоДоп(шткст0 имяП, ББОЛЬШЕЦЕЛ* свобБайтыДоступнВызывающему, ББОЛЬШЕЦЕЛ* общЧлоБайт, ББОЛЬШЕЦЕЛ* общЧлоСвобБайт)
	{
	return GetDiskFreeSpaceExW(имяП,  свобБайтыДоступнВызывающему,  общЧлоБайт,  общЧлоСвобБайт);
	}

	/**
	*GetLogicalDriveStringsA
	*/
	ткст ДайТкстЛогДисковА(){

            цел             длин;
            ткст          ткт;

            // acquire drive strings
            длин = GetLogicalDriveStringsA (0, пусто);
            if (длин)
            {
                ткт = new сим[длин];
                GetLogicalDriveStringsA (длин, cast(PCHAR)ткт.ptr);
			}
			return ткт;

}

	/**
	*GetVolumePathNameW
	*/
	бул ДайИмяПутиТома(inout шткст0 а, inout шткст0 б, бцел в)
	{
	return cast(бул) GetVolumePathNameW (а , б, в);

	}

	/**
	*GetVolumePathNameA
	*/
	бул ДайИмяПутиТомаА(inout ткст0 а, inout ткст0 б, бцел в)
	{
	return cast(бул) GetVolumePathNameA (а , б, в);
	}

	/**
	*GetOverlappedResult
	*/
	бул ДайАсинхронРезультат(ук укз, АСИНХРОН* ас, бцел* бц, бул бу)
	{
	return GetOverlappedResult(укз, ас, бц, бу);
	}

	/**
	* GetHandleInformation
	*/
	бул ДайИнфОДескр(ук укз, ПХэндлФ* фл)
		{
			if (!GetHandleInformation(укз, фл))
				return нет;
			return да;
	}
	/**
* SetHandleInformation
*/
	бул УстановиИнфОДескр(ук укз, ПХэндлФ маска, бцел флаги)
	{
		if (!SetHandleInformation(укз, маска, флаги))
	return нет;
	return да;
	}
	
/**
* SetFileAttributesW
*/
	бул УстановиАтрибутыФайла(ткст файл, бцел атры){
	assert(файл.length <= МАКС_ПУТЬ);
		if (!SetFileAttributesW(toUTF16z(файл), атры))
			return нет;
		return да;
	}
/**
* GetFileAttributesExW
*/
	бул ДайАтрибутыФайлаДоп(ткст файл, бцел атры, ФАЙЛ_АТР_ДАН_ВИН32* инфо)	{
	assert(файл.length <= МАКС_ПУТЬ);
     шим[МАКС_ПУТЬ] врем =void;
    if (! GetFileAttributesExW (вТкст16_(врем, файл).ptr, атры, инфо))
     return нет;
	      return да;

	}
	
/**
* GetFileAttributesExA
*/
	бул ДайАтрибутыФайлаДопА(ткст файл, бцел атры, ФАЙЛ_АТР_ДАН_ВИН32* инфо)	{
	return GetFileAttributesExA(cast(ткст0)файл, атры, инфо);
	}
/**
* GetFileSizeEx
*/
бул ДайРазмерФайлаДоп(ук укз, БОЛЬШЕЦЕЛ* бц){
return cast(бул) GetFileSizeEx (укз, cast(БОЛЬШЕЦЕЛ*) бц);
}

/**
* SetFilePointerEx
*/
бул УстановиФайлУкДоп(ук файл, sys.WinStructs.БОЛЬШЕЦЕЛ а, sys.WinStructs.БОЛЬШЕЦЕЛ *б, бцел ф){
return cast(бул) SetFilePointerEx(cast(ук) файл, cast(БОЛЬШЕЦЕЛ) а,
												cast(БОЛЬШЕЦЕЛ*) б, cast(бцел) ф);
}
/**
* ActivateActCtx
*/
бул АктивируйАктКткс(ук актКткст, бцел** куки)	{
return cast(бул) ActivateActCtx(cast(ук)актКткст, cast(бцел**)куки);
 }
/**
* AddAtomA
*/
бкрат ДобавьАтомА(ткст атом)	{
return cast(бкрат) AddAtomA(cast(ткст0) атом);
}
/**
* AddAtomW
*/
бкрат ДобавьАтом(ткст атом)	{return cast(бкрат) AddAtomW(cast(шткст0) атом);}
ПОшибка ДобавьЛокальноеАльтернативноеИмяКомпьютераА(ткст днсИмяХоста, бцел флаги = 0)
	{return cast(ПОшибка) AddLocalAlternateComputerNameA(cast(ткст0) днсИмяХоста, cast(бцел) флаги);}
ПОшибка ДобавьЛокальноеАльтернативноеИмяКомпьютера(ткст днсИмяХоста, бцел флаги = 0)
	{return cast(ПОшибка) AddLocalAlternateComputerNameW (cast(шткст0) днсИмяХоста, cast(бцел) флаги);}
проц ДобавьСсылАктКткс(ук актКткст)
	{AddRefActCtx(cast(ук) актКткст);}
ук ДобавьВекторныйОбработчикИсключения(бцел первОбр, ВЕКТОРНЫЙ_ОБРАБОТЧИК_ИСКЛЮЧЕНИЯ векОбрИскл)
	{return cast(ук) AddVectoredExceptionHandler(cast(бцел) первОбр, cast(PVECTORED_EXCEPTION_HANDLER) векОбрИскл);}
бул РазместиКонсоль()
	{return cast(бул) AllocConsole();}
бул РазместиФизическиеСтраницыПользователя(ук процесс, бцел *члоСтр, бцел *члоФреймовСтр)
	{return cast(бул) AllocateUserPhysicalPages(cast(ук) процесс, cast(бдол*) члоСтр, cast(бдол*) члоФреймовСтр);}
бул ФайлВВФцииИспользуютАНЗИ()
	{return cast(бул) AreFileApisANSI();}
бул ПрисвойПроцессДжобОбъекту(ук джоб, ук процесс)
	{return cast(бул) AssignProcessToJobObject(cast(ук) джоб, cast(ук) процесс);}
бул ПрикрепиКонсоль(бцел идПроц)
	{return cast(бул) AttachConsole( cast(бцел) идПроц);}
бул БэкапЧитай(ук файл, ббайт *буф, бцел члоБайтСчитать, бцел *члоСчитБайт, бул аборт, бул безопасноДляПроцесса, ук контекст )
	{ return cast(бул) BackupRead(cast(ук) файл, cast(уббайт) буф, cast(бцел) члоБайтСчитать, cast(бцел*) члоСчитБайт, cast(бул) аборт, cast(бул) безопасноДляПроцесса, cast(ук*) контекст);}
бул БэкапСместись(ук файл, бцел младшБайтСместиться, бцел старшБайтСместиться, бцел *младшСмещБайт, бцел *старшСмещБайт, ук контекст)
	{ return cast(бул) BackupSeek(cast(ук) файл,  cast(бцел) младшБайтСместиться, cast(бцел) старшБайтСместиться, cast(бцел*) младшСмещБайт, cast(бцел*) старшСмещБайт, cast(ук*) контекст);}
бул БэкапПиши(ук файл, ббайт *буф,  бцел члоБайтПисать, бцел *члоЗаписБайт, бул аборт, бул безопасноДляПроцесса, ук контекст )
	{ return cast(бул) BackupWrite(cast(ук) файл, cast(уббайт) буф, cast(бцел) члоБайтПисать, cast(бцел*) члоЗаписБайт, cast(бул) аборт, cast(бул) безопасноДляПроцесса, cast(ук*) контекст);}
бул Бип(бцел герц, бцел мсек)
	{return cast(бул) Beep(cast(бцел) герц, cast(бцел) мсек);}
ук НачниОбновлениеРесурсаА(ткст рес, бул б)
	{return cast(ук) BeginUpdateResourceA(cast(ткст0) рес, cast(бул) б);}
ук НачниОбновлениеРесурса(ткст рес, бул б)
	{return cast(ук) BeginUpdateResourceW(cast(шткст0) рес, cast(бул) б);}
бул ПривяжиОбрвызовВыполненияВВ(ук файл, ПРОЦЕДУРА_АСИНХ_ВЫПОЛНЕНИЯ_ВВ фн, бцел флаги = 0)	
	{return cast(бул) BindIoCompletionCallback(cast(ук) файл, cast(LPOVERLAPPED_COMPLETION_ROUTINE) фн, cast(бцел) флаги);}
бул СтройКоммСКУА(ткст описание, СКУ *ску)
	{return cast(бул) BuildCommDCBA(cast(ткст0) описание, cast(LPDCB) ску);}
бул СтройКоммСКУ(ткст описание, СКУ *ску)
	{return cast(бул) BuildCommDCBW(cast(шткст0) описание, cast(LPDCB) ску);}
бул СтройКоммСКУИТаймаутыА(ткст определение, СКУ *ску, КОММТАЙМАУТЫ *кт)	
	{return cast(бул) BuildCommDCBAndTimeoutsA(cast(ткст0) определение,  ску, кт);}
бул СтройКоммСКУИТаймауты(ткст определение, СКУ *ску, КОММТАЙМАУТЫ *кт)	
	{return cast(бул) BuildCommDCBAndTimeoutsW(cast(шткст0) определение,  ску, кт);}	
бул ВызовиИменованныйПайпА(ткст имяПайпа, ук вхБуф, бцел вхБуфРазм, ук выхБуф, бцел выхБуфРазм, бцел *байтЧитать, бцел таймаут  )
	{return cast(бул) CallNamedPipeA(cast(ткст0) имяПайпа, cast(ук) вхБуф, cast(бцел)вхБуфРазм, cast(ук) выхБуф, cast(бцел) выхБуфРазм, cast(бцел*) байтЧитать, cast(бцел) таймаут);}
бул ВызовиИменованныйПайп(ткст имяПайпа, ук вхБуф, бцел вхБуфРазм, ук выхБуф, бцел выхБуфРазм, бцел *байтЧитать, бцел таймаут  )
	{return cast(бул) CallNamedPipeW(cast(шткст0) имяПайпа, cast(ук) вхБуф, cast(бцел)вхБуфРазм, cast(ук) выхБуф, cast(бцел) выхБуфРазм, cast(бцел*) байтЧитать, cast(бцел) таймаут);}
бул  ОтмениЗапросПобудкиУстройства(ук устр)
	{return cast(бул) CancelDeviceWakeupRequest(cast(ук) устр);}
бул ОтмениВВ(ук файл)
	{return cast(бул) CancelIo (cast(ук) файл);}
бул ОтмениОжидающийТаймер(ук таймер)
	{return cast(бул) CancelWaitableTimer(cast(ук) таймер);}
бул ИзмениТаймерОчередиТаймеров(ук очередьТаймеров, ук таймер, бцел устВремя, бцел период )
	{return cast(бул) ChangeTimerQueueTimer(cast(ук) очередьТаймеров ,cast(ук) таймер, cast(бцел) устВремя ,cast(бцел) период );}
бул ОтмениТаймерОчередиТаймеров(ук очередьТаймеров, ук таймер)
	{return cast(бул) CancelTimerQueueTimer(cast(ук) очередьТаймеров ,cast(ук) таймер);}
бул ПроверьЛегальностьИмениФайлаДляДОС8_3А(in ткст имя, out ткст оемИмя,in бцел размОЕМИмени, out бул естьПробелы, out бул имяЛегально)	
	{return cast(бул) CheckNameLegalDOS8Dot3A(cast(ткст0) имя, cast(ткст0 )  оемИмя, cast(бцел)размОЕМИмени, cast(бул*) естьПробелы,cast(бул*) имяЛегально);}
бул ПроверьЛегальностьИмениФайлаДляДОС8_3(in ткст имя, out ткст оемИмя,in бцел размОЕМИмени, out бул естьПробелы, out бул имяЛегально)	
	{return cast(бул) CheckNameLegalDOS8Dot3W(cast(шткст0) имя, cast(ткст0 )  оемИмя, cast(бцел)размОЕМИмени, cast(бул*) естьПробелы,cast(бул*) имяЛегально);}
бул ПроверьПрисутствиеУдалённогоОтладчика(in ук процесс, inout бул естьОтл )
	{return cast(бул) CheckRemoteDebuggerPresent(cast(ук) процесс, cast(бул*) естьОтл );}
бул СотриКоммБрейк(ук файл)
	{return cast(бул) ClearCommBreak(cast(ук) файл);}
бул СотриОшибкуКомм(ук файл, ПОшКомм ошибка, КОММСТАТ *кс)	
	{return cast(бул) ClearCommError(cast(ук) файл, cast(бцел*) ошибка, cast(КОММСТАТ*) кс);}
бул ЗакройДескр(ук дОбъект)
	{
	return cast(бул) CloseHandle(cast(ук) дОбъект);
	}
бул ДиалогКонфигурацииКоммА(ткст имяУстр, ук окноРодитель, КОММКОНФИГ *кк)
	{return cast(бул)  CommConfigDialogA(cast(ткст0) имяУстр, cast(УОК) окноРодитель, cast(КОММКОНФИГ*) кк);}
бул ДиалогКонфигурацииКомм(ткст имяУстр, ук окноРодитель, КОММКОНФИГ *кк)
	{return cast(бул)  CommConfigDialogW(cast(шткст0) имяУстр, cast(УОК) окноРодитель, cast(КОММКОНФИГ*) кк);}
ПСравнВремФла СравниФВремя(in ФВРЕМЯ *фвр1, in ФВРЕМЯ *фвр2)
	{
	return cast(ПСравнВремФла) CompareFileTime(cast(ФВРЕМЯ*) фвр1, cast(ФВРЕМЯ*) фвр2);
	}
ПСравнСтр СравниСтрокиА(бцел локаль, ПФлагиНормСорт флаги, ткст0 стр1, цел члоСимВСтр1, ткст0 стр2, цел члоСимВСтр2)
	{return cast(ПСравнСтр) CompareStringA( локаль, cast(бцел) флаги, cast(ткст0) стр1, члоСимВСтр1, cast(ткст0) стр2, члоСимВСтр2);	}
ПСравнСтр СравниСтроки(ЛКИД локаль, ПФлагиНормСорт флаги, ткст стр1, цел члоСимВСтр1, ткст стр2, цел члоСимВСтр2)
	{return cast(ПСравнСтр) CompareStringW( локаль, cast(бцел) флаги, cast(шткст0) стр1, члоСимВСтр1, cast(шткст0) стр2, члоСимВСтр2);}
бул ПодключиИменованныйПайп(ук имПайп, АСИНХРОН *асинх)	
	{return cast(бул) ConnectNamedPipe(cast(ук) имПайп, cast(АСИНХРОН*) асинх);}
бул ПродолжайСобытиеОтладки(бцел идПроцесса, бцел идНити, ПСтатПродолжОтладки стат)	
	{return cast(бул) ContinueDebugEvent(cast(бцел) идПроцесса, cast(бцел) идНити, cast(бцел) стат);}
ЛКИД ПреобразуйДефолтнуюЛокаль(ЛКИД лок)
	{return  ConvertDefaultLocale( лок);}
бул ПреобразуйФибруВНить()	
	{return cast(бул) ConvertFiberToThread();}
ук ПреобразуйНитьВФибру( ук параметр )
	{return cast(ук) ConvertThreadToFiber(cast(ук) параметр);}
	
бул КопируйФайлА(ткст имяСущФайла, ткст новФимя, бул ошЕслиСуществует)
	{
	return cast(бул)   CopyFileA(cast(ткст0) имяСущФайла, cast(ткст0) новФимя, cast(бул) ошЕслиСуществует);
	}
	
бул КопируйФайл(ткст имяСущФайла, ткст новФимя, бул ошЕслиСуществует)
	{
	return cast(бул)   CopyFileW(toUTF16z(имяСущФайла), toUTF16z(новФимя), cast(бул) ошЕслиСуществует);
	}
бул КопируйФайлДопА(ткст0 сущФИмя, ткст0 новФИмя, ПРОЦ_ПРОГРЕССА пп, ук данные, бул *отменить, ПКопирФайл флаги)
		{return cast(бул) CopyFileExA(cast(ткст0) сущФИмя, cast(ткст0) новФИмя, cast(LPPROGRESS_ROUTINE) пп, cast(ук) данные, cast(бул*) отменить, cast(бцел) флаги);}
бул КопируйФайлДоп(ткст сущФИмя, ткст новФИмя, ПРОЦ_ПРОГРЕССА пп, ук данные, бул отменить, ПКопирФайл флаги)
		{return cast(бул) CopyFileExW(cast(шткст0) toUTF16z(сущФИмя), cast(шткст0) toUTF16z(новФИмя), cast(LPPROGRESS_ROUTINE) пп, cast(ук) данные, cast(бул*) отменить, cast(бцел) флаги);}
ук СоздайАктКтксА(АКТКТКСА *ак)
	{return cast(ук) CreateActCtxA(cast(PCACTCTXA) ак);}	
ук СоздайАктКткс(АКТКТКС *ак)
	{return cast(ук) CreateActCtxW(cast(PCACTCTXW) ак);}
ук СоздайБуферЭкранаКонсоли(ППраваДоступа желДост, ПСовмИспФайла совмРеж, in БЕЗАТРЫ *ба)	
	 {return cast(ук) CreateConsoleScreenBuffer(cast(бцел) желДост, cast(бцел) совмРеж, cast(БЕЗАТРЫ*) ба, cast(бцел) 1, null);}
	 
бул СоздайПапкуА(ткст путь, БЕЗАТРЫ *безАтры )
	{
	return cast(бул) CreateDirectoryA(cast(ткст0) путь, cast(БЕЗАТРЫ*) безАтры);
	}

бул СоздайПапку(ткст путь, БЕЗАТРЫ *безАтры )
	{
	return cast(бул) CreateDirectoryW(toUTF16z(путь), cast(БЕЗАТРЫ*) безАтры);
	}

бул СоздайПапкуДопА(ткст папкаШаблон, ткст новаяПапка, БЕЗАТРЫ *безАтры )
	{
	return cast(бул) CreateDirectoryExA(cast(ткст0) папкаШаблон, cast(ткст0) новаяПапка, cast(БЕЗАТРЫ*) безАтры);
	}

бул СоздайПапкуДоп(ткст папкаШаблон, ткст новаяПапка, БЕЗАТРЫ *безАтры )
	{
	return cast(бул) CreateDirectoryExW(toUTF16z(папкаШаблон), toUTF16z(новаяПапка),  cast(БЕЗАТРЫ*) безАтры);
	}

ук СоздайСобытиеА(БЕЗАТРЫ *ба, бул ручнойСброс, бул сигнализироватьНачСост, ткст0 имя)	
	{return cast(ук) CreateEventA(cast(БЕЗАТРЫ*) ба, cast(бул) ручнойСброс, cast(бул) сигнализироватьНачСост, cast(ткст0) имя);}
ук СоздайСобытие(БЕЗАТРЫ *ба, бул ручнойСброс, бул сигнализироватьНачСост, ткст имя)	
	{return cast(ук) CreateEventW(cast(БЕЗАТРЫ*) ба, cast(бул) ручнойСброс, cast(бул) сигнализироватьНачСост, cast(шткст0) toUTF16z(имя));}	
ук СоздатьФибру(т_мера размСтека ,ПРОЦ_СТАРТА_ФИБРЫ псф, ук параметр)
	{return cast(ук) CreateFiber(cast(SIZE_T) размСтека, cast(LPFIBER_START_ROUTINE) псф, cast(ук) параметр);}
ук СоздатьФибруДоп(т_мера размСтекаКоммит, т_мера размСтекаРезерв , бцел флаги, ПРОЦ_СТАРТА_ФИБРЫ псф, ук параметр)
	{return cast(ук) CreateFiberEx(cast(SIZE_T) размСтекаКоммит, cast(SIZE_T) размСтекаРезерв, cast(бцел) флаги, cast(LPFIBER_START_ROUTINE) псф, cast(ук) параметр);}
ук СоздайФайлА(in ткст фимя, ППраваДоступа доступ, ПСовмИспФайла режСовмест, 
		БЕЗАТРЫ *безАтры, ПРежСоздФайла диспозицияСозд, ПФайл флагиИАтры, ук файлШаблон)		
	{
	return cast(ук) CreateFileA(cast(char*) фимя, cast(бцел) доступ, cast(бцел) режСовмест, cast(БЕЗАТРЫ *) безАтры, cast(бцел)диспозицияСозд, cast(бцел) флагиИАтры, cast(ук) файлШаблон);
	}

ук СоздайФайл(in ткст фимя, ППраваДоступа доступ, ПСовмИспФайла режСовмест, 
		БЕЗАТРЫ *безАтры, ПРежСоздФайла диспозицияСозд, ПФайл флагиИАтры, ук файлШаблон)		
	{
	return cast(ук) CreateFileW(toUTF16z(фимя), cast(бцел) доступ, cast(бцел) режСовмест, cast(БЕЗАТРЫ *) безАтры, cast(бцел) диспозицияСозд, cast(бцел) флагиИАтры, cast(ук) файлШаблон);
	}

ук СоздайМаппингФайлаА(ук ф, БЕЗАТРЫ *ба, ППамять защ, бцел максРазмН, бцел максРазмВ, ткст имя)
	{
	return cast(ук) CreateFileMappingA( cast(ук) ф, cast(БЕЗАТРЫ*) ба, cast(бцел) защ, cast(бцел) максРазмН, cast(бцел) максРазмВ, cast(ткст0) имя);
	}
ук СоздайМаппингФайла(ук ф, БЕЗАТРЫ *ба,ППамять защ, бцел максРазмН, бцел максРазмВ, ткст имя)
	{
	return cast(ук) CreateFileMappingW(cast(ук) ф,cast(БЕЗАТРЫ*) ба,
	cast(бцел) защ, cast(бцел) максРазмН, cast(бцел) максРазмВ, toUTF16z(имя));
	}

бул СоздайЖёсткуюСвязкуА(ткст имяСвязываемогоФайла, ткст имяСвязующегоФайла)
		{return cast(бул)  CreateHardLinkA(cast(ткст0) имяСвязываемогоФайла, cast(ткст0) имяСвязующегоФайла, null);}
бул СоздайЖёсткуюСвязку(ткст имяСвязываемогоФайла, ткст имяСвязующегоФайла)
		{return cast(бул)  CreateHardLinkW(toUTF16z( имяСвязываемогоФайла), toUTF16z( имяСвязующегоФайла), null);}
ук 	СоздайПортАвтозаполненияВВ(ук файл, ук сущПортВып, бцел ключВып, бцел числоКонкурентныхНитей)
		{return cast(ук) CreateIoCompletionPort(cast(ук) файл, cast(ук) сущПортВып, ключВып, cast(бцел) числоКонкурентныхНитей);}
ук СоздайОбъектДжобА(БЕЗАТРЫ *ба, ткст имя )		
			{return cast(ук) CreateJobObjectA(cast(БЕЗАТРЫ*) ба, cast(ткст0) имя);}
ук СоздайОбъектДжоб(БЕЗАТРЫ *ба, ткст имя )		
			{return cast(ук) CreateJobObjectW(cast(БЕЗАТРЫ*) ба, toUTF16z(имя));}
ук СоздайСлотПочтыА(ткст имя, бцел максРазмСооб, бцел таймаутЧтен, БЕЗАТРЫ *ба)		
			{return cast(ук) CreateMailslotA(cast(ткст0) имя, cast(бцел) максРазмСооб, cast(бцел) таймаутЧтен, cast(БЕЗАТРЫ*) ба);}
ук СоздайСлотПочты(ткст имя, бцел максРазмСооб, бцел таймаутЧтен, БЕЗАТРЫ *ба)		
			{return cast(ук) CreateMailslotW(toUTF16z(имя), cast(бцел) максРазмСооб, cast(бцел) таймаутЧтен, cast(БЕЗАТРЫ*) ба);}
ук СоздайПометкуРесурсаПамяти(ТПРП метка)		
			{return cast(ук) CreateMemoryResourceNotification(cast(MEMORY_RESOURCE_NOTIFICATION_TYPE) метка);}
ук СоздайМютексА(БЕЗАТРЫ* ба, бул иницВладеть, ткст имя)			
			{return cast(ук) CreateMutexA(cast(БЕЗАТРЫ*) ба, cast(бул) иницВладеть, cast(ткст0) имя);}
ук СоздайМютекс(БЕЗАТРЫ* ба, бул иницВладеть, ткст имя)			
			{return cast(ук) CreateMutexW(cast(БЕЗАТРЫ*) ба, cast(бул) иницВладеть, toUTF16z(имя));}
ук СоздайИменованныйПайпА(ткст имя, ППайп режПайп, ППайп типПайп, бцел максЭкз, бцел размВыхБуф, бцел размВхБуф, бцел дефТаймаут, БЕЗАТРЫ *ба)		
	{return cast(ук) CreateNamedPipeA(cast(ткст0) имя, cast(бцел) режПайп, cast(бцел) типПайп, cast(бцел) максЭкз, cast(бцел) размВыхБуф, cast(бцел) размВхБуф, cast(бцел) дефТаймаут, cast(БЕЗАТРЫ*) ба);}	
ук СоздайИменованныйПайп(ткст имя, ППайп режПайп, ППайп типПайп, бцел максЭкз, бцел размВыхБуф, бцел размВхБуф, бцел дефТаймаут, БЕЗАТРЫ *ба)		
	{return cast(ук) CreateNamedPipeW(cast(шткст0) имя, cast(бцел) режПайп, cast(бцел) типПайп, cast(бцел) максЭкз, cast(бцел) размВыхБуф, cast(бцел) размВхБуф, cast(бцел) дефТаймаут, cast(БЕЗАТРЫ*) ба);}
бул СоздайПайп(ук *пайпЧтен, ук *пайпЗап, БЕЗАТРЫ *баПайпа, бцел размБайтБуф)
	{return cast(бул) CreatePipe(cast(PHANDLE) пайпЧтен, cast(PHANDLE) пайпЗап, cast(БЕЗАТРЫ*) баПайпа, cast(бцел) размБайтБуф);}
бул СоздайПроцессА(ткст назвПриложения, ткст комСтр, БЕЗАТРЫ* атрыПроц, БЕЗАТРЫ* атрыНити, бул наследоватьДескр, ПСозданиеПроцесса флаги , ук среда, ткст текПап, ИНФОСТАРТА* ис, ИНФОПРОЦ* пи)
	 {	 
	 return cast(бул) CreateProcessA(cast(ткст0 ) назвПриложения, cast(ткст0 ) комСтр, cast(БЕЗАТРЫ*)атрыПроц, cast(БЕЗАТРЫ*) атрыНити, cast(бул) наследоватьДескр, cast(бцел) флаги, cast(ук) среда, stringz.вТкст0(текПап),  ис, cast(ИНФОПРОЦ*) пи);
	 }

бул СоздайПроцесс(ткст назвПриложения, ткст комСтр, БЕЗАТРЫ* атрыПроц, БЕЗАТРЫ* атрыНити, бул наследоватьДескр, ПСозданиеПроцесса флаги , ук среда, ткст текПап, ИНФОСТАРТА* ис, ИНФОПРОЦ* пи)
	 {
	return cast(бул) CreateProcessW(cast(шткст0) toUTF16z(назвПриложения), cast(шткст0) toUTF16z(комСтр), cast(БЕЗАТРЫ*) атрыПроц, cast(БЕЗАТРЫ*) атрыНити, cast(бул) наследоватьДескр, cast(бцел) флаги, cast(ук) среда, cast(шткст0) toUTF16z(текПап),  ис, cast(ИНФОПРОЦ*) пи);
	}		
ук СоздайУдалённуюНить(ук процесс, БЕЗАТРЫ *баНити, т_мера размСтека, ПРОЦ_СТАРТА_НИТИ стартАдрНити, ук параметр, ПСозданиеПроцесса флагиСозд, убцел идНити )
	{return cast(ук) CreateRemoteThread(cast(ук) процесс, cast(БЕЗАТРЫ*) баНити, cast(бцел) размСтека, cast(LPTHREAD_START_ROUTINE) стартАдрНити, cast(ук) параметр, cast(бцел) флагиСозд, cast(бцел*) идНити);}
ук СоздайСемафорА(БЕЗАТРЫ *ба, цел начСчёт, цел максСчёт, ткст имя)
	{return cast(ук) CreateSemaphoreA(cast(БЕЗАТРЫ*) ба, cast(цел) начСчёт, cast(цел) максСчёт, cast(ткст0) имя);}
ук СоздайСемафор(БЕЗАТРЫ *ба, цел начСчёт, цел максСчёт, ткст имя)
	{return cast(ук) CreateSemaphoreW(cast(БЕЗАТРЫ*) ба, cast(цел) начСчёт, cast(цел) максСчёт, cast(шткст0) toUTF16z(имя));}
ПОшибка СоздайТейпОтдел(ук устр, ПТейп мсо, бцел чло, бцел размер)
	{return cast(ПОшибка) CreateTapePartition(cast(ук) устр, cast(бцел) мсо, cast(бцел) чло, cast(бцел) размер);}
	
ук СоздайНить(БЕЗАТРЫ* атрыНити, т_мера размСтэка, ПРОЦ_СТАРТА_НИТИ стартАдр, ук парам, ПСозданиеПроцесса флагиСозд, убцел идНити)
	 {
	 return cast(ук) CreateThread(cast(БЕЗАТРЫ*) атрыНити,  размСтэка,  cast(LPTHREAD_START_ROUTINE) стартАдр,  cast(ук) парам, cast(бцел) флагиСозд, cast(бцел*) идНити);
	 }
ук СоздайОчередьТаймеров(){return cast(ук) CreateTimerQueue();}
бул СоздайТаймерОчередиТаймеров(ук* новТаймер, ук очТайм, ПРОЦ_ОТВЕТА_ТАЙМЕРА проц, ук парам, бцел назнВремя, бцел период, ПТаймер флаги )
	{return cast(бул) CreateTimerQueueTimer(cast(PHANDLE) новТаймер, cast(ук) очТайм, cast(WAITORTIMERCALLBACK) проц, cast(ук) парам, cast(бцел) назнВремя, cast(бцел) период, cast(бцел) флаги);}
ук СоздайСнимокТулхэлп32(ПТулхэлп32 флаги, бцел идПроцесса32)	
	{return cast(ук) CreateToolhelp32Snapshot(cast(бцел) флаги, cast(бцел) идПроцесса32);}
ук СоздайОжидающийТаймерА(БЕЗАТРЫ *баТаймера, бул ручнСброс, ткст имя)	
	{return cast(ук) CreateWaitableTimerA(cast(БЕЗАТРЫ*) баТаймера, cast(бул) ручнСброс, cast(ткст0) имя);}
ук СоздайОжидающийТаймер(БЕЗАТРЫ *баТаймера, бул ручнСброс, ткст имя)	
	{return cast(ук) CreateWaitableTimerW(cast(БЕЗАТРЫ*) баТаймера, cast(бул) ручнСброс, cast(шткст0) toUTF16z(имя));}
бул ДеактивируйАктКткс(ПАктКткс флаги, бцел куки){return cast (бул) DeactivateActCtx(cast(бцел) флаги, cast(ULONG_PTR) куки);}
бул ОтладкаАктивногоПроцесса(бцел идПроцесса)
	{return cast(бул) DebugActiveProcess(cast(бцел) идПроцесса);}
бул ОстановитьОтладкуАктивногоПроцесса(бцел идПроцесса)
	{return cast(бул) DebugActiveProcessStop(cast(бцел) идПроцесса);}
проц ПрерватьОтладку(){DebugBreak();}
бул ПрерватьОтладкуПроцесса(ук процесс){return cast(бул) DebugBreakProcess(cast(ук) процесс); }
	//бул DebugSetProcessKillOnExit(бул);
бул ОпределиУстройствоДосА(ПДосУстройство флаги , ткст имяУстр, ткст целПуть )	
	{return cast(бул) DefineDosDeviceA(cast(бцел) флаги, cast(ткст0) имяУстр, cast(ткст0) целПуть);}
бул ОпределиУстройствоДос(ПДосУстройство флаги , ткст имяУстр, ткст целПуть )	
	{return cast(бул) DefineDosDeviceW(cast(бцел) флаги, cast(шткст0) имяУстр, cast(шткст0) целПуть);}
бкрат УдалитьАтом(бкрат а){return cast(бкрат) DeleteAtom(cast(АТОМ) а);}
проц УдалиКритическуюСекцию(КРИТСЕКЦ *критСекц)	{	DeleteCriticalSection(cast(КРИТСЕКЦ *) критСекц);	}
проц УдалиФибру(ук фиб){ DeleteFiber(cast(ук) фиб);}
бул УдалиФайлА(in ткст фимя)	{	return cast(бул) DeleteFileA(stringz.вТкст0(фимя));	}
бул УдалиФайл(in ткст фимя)
	{
	ткст ф = toUTF8(фимя);
	return cast(бул) DeleteFileW(toUTF16z(ф));
	}
бул УдалиОчередьТаймеров(ук от ){return cast(бул) DeleteTimerQueue(cast(ук) от);}
бул УдалиОчередьТаймеровДоп(ук от, ук событиеЗавершения){return cast(бул) DeleteTimerQueueEx(cast(ук) от, cast(ук) событиеЗавершения);}
бул УдалиТаймерОчередиТаймеров(ук от , ук т, ук собЗав ) {return cast(бул) DeleteTimerQueueTimer(cast(ук) от, cast(ук) т, cast(ук) собЗав);}
бул УдалиМонтажнуюТочкуТомаА(ткст монтТчк){return cast(бул) DeleteVolumeMountPointA(cast(ткст0) монтТчк);}
бул УдалиМонтажнуюТочкуТома(ткст монтТчк){return cast(бул) DeleteVolumeMountPointW(cast(шткст0) монтТчк);}
бул УправляйВВУстройства(ук устр, бцел кодУпрВВ /*см. win32.winioctl*/, ук вхБуф, т_мера размВхБуф, ук выхБуф, т_мера размВыхБуф, бцел *возвращеноБайт, АСИНХРОН *ас)
	{return cast(бул) DeviceIoControl(cast(ук) устр, cast(бцел) кодУпрВВ, cast(ук) вхБуф, cast(бцел) размВхБуф, cast(ук) выхБуф, cast(бцел) размВыхБуф, cast(бцел*) возвращеноБайт, cast(АСИНХРОН*) ас );}
бул ОтключиВызовыБиблиотекиИзНити(ук модуль){return cast(бул) DisableThreadLibraryCalls(cast(экз) модуль);}
бул ОтключиИменованныйПайп(ук пайп){return cast(бул) DisconnectNamedPipe(cast(ук) пайп);}
бул ХостИмяДнсВИмяКомпьютераА(ткст0 имяХоста, ткст0 имяКомпа, убцел разм)
	{return cast(бул) DnsHostnameToComputerNameA( cast(ткст0 ) имяХоста, cast(ткст0 ) имяКомпа, cast(бцел*) разм);}  
бул ХостИмяДнсВИмяКомпьютера(ткст  имяХоста, ткст имяКомпа, убцел разм)
	{return cast(бул) DnsHostnameToComputerNameW( cast(шткст0) имяХоста, cast(шткст0) имяКомпа, cast(бцел*) разм);}
  

/**
*GetLocaleInfoW
*/
цел ДайИнфОЛокале(ЛКИД лок, т_локаль л , шткст0 имя, цел ттт)
{
return GetLocaleInfoW(лок, л, имя, ттт);
}
/**
*SetLocaleInfoW
*/
бул УстановиИнфОЛокале(ЛКИД лок, т_локаль л, ткст ткт)
{
return SetLocaleInfoW(лок,  л, toUTF16z(ткт));
}

/**
*MoveFileExA
*/
бул ПереместиФайлДопА(ткст откуда, ткст куда, бцел флаг){
return MoveFileExA(cast(char*)откуда, cast(char*)куда, флаг);
}

/**
*MoveFileExW
*/
бул ПереместиФайлДоп(ткст откуда, ткст куда, бцел флаг){
return MoveFileExW(toUTF16z(откуда), toUTF16z(куда), флаг);
}

//..........................................................
/**
*GetVersionExA
*/
бул ДайВерсиюДопА(sys.WinStructs.ИНФОВЕРСИИОС_А* иовос){
return GetVersionExA(иовос);
}
/**
*GetVersionExW
*/
бул ДайВерсиюДоп(sys.WinStructs.ИНФОВЕРСИИОС* иовос){
return GetVersionExW(иовос);
}
/**
* GetCommState
*/
бул ДайСостояниеКомм(ук укз, СКУ* ску){
return cast(бул) GetCommState(укз, ску);
}
/**
* SetCommState
*/
бул УстановиСостояниеКомм(ук укз, СКУ* ску){
return cast(бул) SetCommState(укз, ску);
}

бкрат СТАРШСЛОВО(цел l) { return cast(бкрат)((l >> 16) & 0xFFFF); }
бкрат МЛАДШСЛОВО(цел l) { return cast(бкрат)l; }
ббайт СТАРШБАЙТ(бкрат w) {  return cast(ббайт)((w >> 8) & 0xFF);}
ббайт МЛАДШБАЙТ(бкрат w) {  return cast(ббайт)(w & 0xFF);}
бул НЕУД(цел статус) { return статус < 0; }
бул УД(цел статус) { return статус >= 0; }

цел СДЕЛАЙИДЪЯЗ(ПЯзык p, ППодъяз s) { return ((cast(бкрат)s) << 10) | cast(бкрат)p; }
alias СДЕЛАЙИДЪЯЗ MAKELANGID;
бкрат ПЕРВИЧНИДЪЯЗ(цел язид) { return cast(бкрат)(язид & 0x3ff); }
бкрат ИДПОДЪЯЗА(цел язид)     { return cast(бкрат)(язид >> 10); }
/+

бцел MAKELCID(бкрат lgid, бкрат srtid) { return (cast(бцел) srtid << 16) | cast(бцел) lgid; }
// ???
//бцел MAKESORTLCID(бкрат lgid, бкрат srtid, бкрат ver) { return (MAKELCID(lgid, srtid)) | ((cast(бцел)ver) << 20); }
бкрат LANGIDFROMLCID(ЛКИД лкид) { return cast(бкрат) лкид; }
бкрат SORTIDFROMLCID(ЛКИД лкид) { return cast(бкрат) ((лкид >>> 16) & 0x0F); }
бкрат SORTVERSIONFROMLCID(ЛКИД лкид) { return cast(бкрат) ((лкид >>> 20) & 0x0F); }
+/

version(БигЭндиан)
{
	крат х8сбк(крат x)
	{
		return x;
	}
	
	
	цел х8сбц(цел x)
	{
		return x;
	}
}
else version(ЛитлЭндиан)
{
	
	бкрат х8сбк(бкрат x)
	{
		return cast(бкрат)((x >> 8) | (x << 8));
	}


	бцел х8сбц(бцел x)
	{
		return bswap(x);
	}
}
else
{
	static assert(0);
}


бкрат с8хбк(бкрат x)
{
	return х8сбк(x);
}


бцел с8хбц(бцел x)
{
	return х8сбц(x);
}

// Removes.
проц УД_УДАЛИ(СОКЕТ уд, sys.WinStructs.набор_уд* набор)
{
	бцел c = набор.счёт_уд;
	СОКЕТ* старт = набор.массив_уд.ptr;
	СОКЕТ* stop = старт + c;
	
	for(; старт != stop; старт++)
	{
		if(*старт == уд)
			goto found;
	}
	return; //not found
	
	found:
	for(++старт; старт != stop; старт++)
	{
		*(старт - 1) = *старт;
	}
	
	набор.счёт_уд = c - 1;
}


// Tests.
цел УД_УСТАНОВЛЕН(СОКЕТ уд, sys.WinStructs.набор_уд* набор)
{
	СОКЕТ* старт = набор.массив_уд.ptr;
	СОКЕТ* stop = старт + набор.счёт_уд;
	
	for(; старт != stop; старт++)
	{
		if(*старт == уд)
			return да;
	}
	return нет;
}


// Adds.
проц УД_УСТАНОВИ(СОКЕТ уд, sys.WinStructs.набор_уд* набор)
{
	бцел c = набор.счёт_уд;
	набор.массив_уд.ptr[c] = уд;
	набор.счёт_уд = c + 1;
}


// Resets to zero.
проц УД_ОБНУЛИ(sys.WinStructs.набор_уд* набор)
{
	набор.счёт_уд = 0;
}
///////////////////////////////////////////////////////////
/**
*GetTempPathA
*/
бцел ДайВремПутьА(бцел ц, ткст0 ткт)
{
return GetTempPathA(ц , ткт);
}
/**
*GetTempPathW
*/
бцел ДайВремПуть(бцел ц, шткст0 ткт)
{
return GetTempPathW(ц, ткт);
}
/**
*
*/
бул УстановиКонецФайла(ук кон)
{
return SetEndOfFile(кон);
}
///////////////
проц УстановиПоследнОшибку(ПОшибка номош)
{
SetLastError(номош);
}

проц УстановиПоследнОшибкуДоп(бцел номош, бцел ош)
{
SetLastErrorEx(номош, ош);
}
///////////////
бул УстановиТекущуюПапкуА(ткст путь)
	{
	сим[МАКС_ПУТЬ+1] врем =void;
    врем[0..путь.length] = путь;
    врем[путь.length] = 0;
	return cast(бул) SetCurrentDirectoryA(врем.ptr);
	}

бул УстановиТекущуюПапку(ткст путь)
	{
	шим[МАКС_ПУТЬ+1] врем =void;
    assert (путь.length < врем.length);
    auto i = MultiByteToWideChar (ПКодСтр.УТФ8, 0,
                                              cast(PCHAR)путь.ptr, путь.length,
                                              врем.ptr, врем.length);
                врем[i] = 0;
	return cast(бул) SetCurrentDirectoryW(врем.ptr);
	}
////////////////////

ткст ДайТекущуюПапкуА()
	{
	ткст путь;

                цел длин = GetCurrentDirectoryA (0, пусто);
                auto пап = new сим [длин];
                GetCurrentDirectoryA (длин, пап.ptr);
                if (длин)
                {
                    пап[длин-1] = '/';
                    путь = стандарт (пап);
                }
                else
                    throw new ВВИскл  ("Не удалось получить текущую папку");
					
				return путь;
            
	}

ткст  ДайТекущуюПапку()
	{	
	ткст путь;

      
                шим[МАКС_ПУТЬ+2] врем =void;

                auto длин = GetCurrentDirectoryW (0, пусто);
                assert (длин < врем.length);
                auto пап = new сим [длин * 3];
                GetCurrentDirectoryW (длин, врем.ptr);
                auto i = WideCharToMultiByte (ПКодСтр.УТФ8, 0, врем.ptr, длин,
                                              cast(PCHAR)пап.ptr, пап.length, пусто, пусто);
                if (длин && i)
                {
                    путь = стандарт (пап[0..i]);
                    путь[$-1] = '/';
                }
                else
                    throw new ВВИскл ("Не удалось получить текущую папку");
            

            return путь;
	}

//////////////////

бул УдалиПапкуА(ткст путь)
	{
	return cast(бул) RemoveDirectoryA(cast(ткст0) путь);
	}

бул УдалиПапку(ткст путь)
	{
	return cast(бул) RemoveDirectoryW(toUTF16z(путь));
	}
////////////////

////////////////
бул НайдиЗакрой(ук найдиФайл)
	{
	return cast(бул)   FindClose(cast(ук) найдиФайл);
	}
//////////
ук НайдиПервыйФайлА(in ткст фимя, sys.WinStructs.ПОИСК_ДАННЫХ_А* данныеПоискаФайла)
	{
	return cast(ук) FindFirstFileA(cast(сим *) фимя,  данныеПоискаФайла);
	}

ук НайдиПервыйФайл(in ткст фимя, sys.WinStructs.ПДАН* данныеПоискаФайла)
	{
	return cast(ук) FindFirstFileW(toUTF16z(фимя),  данныеПоискаФайла);
	}
////////////
бул НайдиСледующийФайлА(ук найдиФайл, sys.WinStructs.ПОИСК_ДАННЫХ_А* данныеПоискаФайла)
	{
	return cast(бул)   FindNextFileA(cast(ук) найдиФайл,  данныеПоискаФайла);
	}

бул НайдиСледующийФайл(ук найдиФайл, sys.WinStructs.ПДАН* данныеПоискаФайла)
	{
	return cast(бул)   FindNextFileW(cast(ук) найдиФайл,  данныеПоискаФайла);
	}
////////////
бул ДайКодВыходаНити(ук нить, убцел кодВыхода)
	{
	return cast(бул)   GetExitCodeThread(cast(ук) нить, cast(бцел *) кодВыхода);
	}
///////////
бцел ДайПоследнююОшибку()
	{
	return cast(бцел)  GetLastError();
	}
////////////////
бцел ДайАтрибутыФайлаА(in ткст фимя)
	{
	return cast(бцел)  GetFileAttributesA(cast(сим*) фимя);
	}

бцел ДайАтрибутыФайла(in ткст фимя)
	{
	return cast(бцел)  GetFileAttributesW(toUTF16z(фимя));
	}
/////////////
бцел ДайРазмерФайла(ук файл, убцел размерФайлаВ)
	{
	return cast(бцел)  GetFileSize(cast(ук) файл, cast(бцел *) размерФайлаВ);
	}
////////////////
бул ПереместиФайлА(in ткст откуда, in ткст куда)
	{
	return cast(бул)   MoveFileA(cast(char*) откуда, cast(char *) куда);
	}

бул ПереместиФайл(in ткст откуда, in ткст куда)
	{
	return cast(бул)   MoveFileW(toUTF16z(откуда), toUTF16z(куда));
	}
///////////////
бул ЧитайФайл(ук файл, ук буфер, бцел члоБайтДляЧит, бцел* члоСчитБайт, sys.WinStructs.АСИНХРОН*асинх)
	{
	return cast(бул)   ReadFile( cast(HANDLE) файл, cast(LPVOID) буфер, члоБайтДляЧит, члоСчитБайт, асинх);
	}
////////////
бцел УстановиУказательФайла(ук файл, цел дистанцияПереноса, уцел дистанцияПереносаВ, бцел методПереноса)
	{
	return cast(бцел)  SetFilePointer(cast(ук) файл, cast(цел) дистанцияПереноса, cast(цел *) дистанцияПереносаВ, cast(бцел) методПереноса);
	}
////////////////
бул ПишиФайл(ук файл, in ук буфер, бцел члоБайтДляЗаписи, убцел члоЗаписанБайт, sys.WinStructs.АСИНХРОН *асинх)
	{
	return cast(бул)   WriteFile(cast(ук) файл, cast(ук ) буфер, cast(бцел) члоБайтДляЗаписи, cast(бцел *) члоЗаписанБайт, cast(АСИНХРОН *) асинх);
	}
///////////////////
бцел ДайИмяФайлаМодуляА(экз модуль, ткст *фимя, бцел размер)
	{
	return cast(бцел)  GetModuleFileNameA(cast(экз) модуль, cast(ткст0 ) фимя, cast(бцел) размер);
	}
	
бцел ДайИмяФайлаМодуля(экз модуль, ткст фимя, бцел размер)
	{
	return cast(бцел)  GetModuleFileNameW(cast(экз) модуль, toUTF16z(фимя), cast(бцел) размер);
	}
/////////////////

экз ДайДескрМодуляА(ткст имя)
{
 return cast(экз) GetModuleHandleA(cast(ткст0) имя);
 }
 
экз ДайДескрМодуля(ткст имя)
{ 
return cast(экз)GetModuleHandleW(toUTF16z(имя));
}
///////////////////////
ук ДайСтдДескр(ПСтд стдДескр)
	{
	return cast(ук) GetStdHandle(cast(бцел) стдДескр);
	}
//////////////////
бул УстановиСтдДескр(ПСтд стдДескр, ук дескр)
	{
	return cast(бул)   SetStdHandle(cast(бцел) стдДескр, cast(ук) дескр);
	}
	
////////////

ук ЗагрузиБиблиотекуА(ткст имяФайлаБибл)
	{
	return cast(ук) LoadLibraryA(cast(ткст0) имяФайлаБибл);
	}
	
ук ЗагрузиБиблиотеку(ткст фимя){ return cast(ук) LoadLibraryW(cast(шткст0) toUTF16z(фимя));}
//////////////////
ук ЗагрузиБиблиотекуДопА(ткст фимя, ук файл, ПЗагрФлаг флаги){ return cast(ук) LoadLibraryExA(cast(ткст0) фимя, cast(ук) файл, cast(бцел) флаги);}

ук ЗагрузиБиблиотекуДоп(ткст фимя, ук файл, ПЗагрФлаг флаги){ return cast(ук) LoadLibraryExW(cast(шткст0) toUTF16z(фимя), cast(ук)файл, cast(бцел) флаги);}
///////////////////
ук ДайАдресПроц(ук модуль, ткст имяПроц)
	{
	return cast(ук) GetProcAddress(cast(экз) модуль, cast(ткст0) имяПроц);
	}
////////////////////
бцел ДайВерсию()
	{
	return cast(бцел) GetVersion();
	}
///////////////////
бул ОсвободиБиблиотеку(ук библМодуль)
	{
	return cast(бул) FreeLibrary(cast(экз) библМодуль);
	}
///////////////////////
проц ОсвободиБиблиотекуИВыйдиИзНити(ук библМодуль, бцел кодВыхода)
	{
	FreeLibraryAndExitThread(cast(экз) библМодуль, cast(бцел) кодВыхода);
	}
///////////////////

цел ОкноСообА(ук окно, ткст текст, ткст заголовок, ПСооб тип)
	{
	return cast(цел)  MessageBoxA(cast(УОК) окно, cast(ткст0) текст, cast(ткст0) заголовок, cast(бцел) тип);
	}

цел ОкноСооб(ук окно, ткст текст, ткст заголовок, ПСооб тип)
	{
	return cast(цел)  MessageBoxW(cast(УОК) окно, toUTF16z(текст), cast(шткст0) toUTF16z(заголовок), cast(бцел) тип);
	}

цел ОкноСообДопА(ук окно, ткст текст, ткст заголовок, ПСооб тип, бкрат идЯзыка)
	{
	return cast(цел)  MessageBoxExA(cast(УОК) окно, cast(ткст0) текст, cast(ткст0) заголовок, cast(бцел) тип, cast(бкрат) идЯзыка);
	}

цел ОкноСообДоп(ук окно, ткст текст, ткст заголовок, ПСооб тип, бкрат идЯзыка)
	{
	return cast(цел)  MessageBoxExW(cast(УОК) окно, toUTF16z(текст), cast(шткст0) toUTF16z(заголовок), cast(бцел) тип, cast(бкрат) идЯзыка);
	}
	
цел УдалиКлючРегА(ПКлючРег ключ, ткст подключ)
	{
	return cast(цел) RegDeleteKeyA(cast(HKEY) ключ, cast(ткст0) подключ);
	}

цел УдалиЗначениеРегА(ПКлючРег ключ, ткст имяЗнач)
	{
	return cast(цел) RegDeleteValueA(cast(HKEY) ключ, cast(ткст0) имяЗнач);
	}

цел ПеречислиКлючиРегДопА(ПКлючРег ключ, бцел индекс, ткст имя, убцел пкбИмя, убцел резерв, ткст класс, убцел пкбКласс, sys.WinStructs.ФВРЕМЯ *времяПоследнейЗаписи)
	{
	return cast(цел)  RegEnumKeyExA(cast(HKEY) ключ, cast(бцел) индекс, cast(ткст0 ) имя, cast(бцел*) пкбИмя, cast(бцел*) резерв, cast(ткст0 ) класс, cast(бцел*) пкбКласс, cast(ФВРЕМЯ*) времяПоследнейЗаписи);
	}

цел ПеречислиЗначенияРегА(ПКлючРег ключ, бцел индекс, ткст имяЗнач, убцел пкбИмяЗнач, убцел резерв, убцел тип, уббайт данные, убцел пкбДанные)
	{
	return cast(цел) RegEnumValueA(cast(HKEY) ключ,cast(бцел) индекс, cast(ткст0 ) имяЗнач, cast(бцел*) пкбИмяЗнач, cast(бцел*) резерв, cast(бцел*) тип, cast(уббайт) данные, cast(бцел*) пкбДанные);
	}

цел ЗакройКлючРег(ПКлючРег ключ){return cast(цел) RegCloseKey(cast(HKEY) ключ);}

цел ПодсветиКлючРег(ПКлючРег ключ){return cast(цел) RegFlushKey(cast(HKEY) ключ);}

цел ОткройКлючРегА(ПКлючРег ключ, ткст подключ, ук *результат)
	{
	return cast(цел) RegOpenKeyA(cast(HKEY) ключ, cast(ткст0) подключ, cast(PHKEY) результат);
	}

цел ОткройКлючРегДопА(ПКлючРег ключ, ткст подключ, ПРеестр опции, бцел желательно, ук *результат)
	{
	return cast(цел) RegOpenKeyExA(cast(HKEY) ключ, cast(ткст0) подключ,cast(бцел) опции, cast(REGSAM) желательно, cast(PHKEY) результат);
	}

цел ЗапросиИнфОКлючеРегА(ПКлючРег ключ, ткст класс, убцел пкбКласс, убцел резерв, убцел подключи, убцел максДлинаПодключа, убцел пкбМаксДлинаКласса, убцел значения, убцел пкбМаксДлинаИмениЗначения, убцел пкбМаксДлинаЗначения, убцел пкбДескрБезоп, sys.WinStructs.ФВРЕМЯ *времяПоследнейЗаписи)
	{
	return cast(цел) RegQueryInfoKeyA(cast(HKEY) ключ, cast(ткст0 ) класс, cast(бцел*) пкбКласс, cast(бцел*) резерв, cast(бцел*) подключи, cast(бцел*) максДлинаПодключа, cast(бцел*) пкбМаксДлинаКласса,  cast(бцел*) значения, cast(бцел*) пкбМаксДлинаИмениЗначения, cast(бцел*) пкбМаксДлинаЗначения, cast(бцел*) пкбДескрБезоп, cast(ФВРЕМЯ*) времяПоследнейЗаписи);
	}

цел ЗапросиЗначениеРегА(ПКлючРег ключ, ткст подключ, ткст значение, уцел пкбЗначение)
	{
	return cast(цел) RegQueryValueA(cast(HKEY) ключ, cast(ткст0) подключ, cast(ткст0 ) значение, cast(цел*) пкбЗначение);	}

цел СоздайКлючРегДопА(ПКлючРег ключ, ткст подключ, бцел резерв, ткст класс, ПРеестр опции, бцел желательно, sys.WinStructs.БЕЗАТРЫ *безАтры, ук *результат, убцел расположение) 
	{
	return cast(цел) RegCreateKeyExA(cast(HKEY) ключ, cast(ткст0) подключ,cast(бцел) резерв, cast(ткст0 ) класс, cast(бцел) опции, cast(REGSAM) желательно, cast(БЕЗАТРЫ*) безАтры, cast(PHKEY) результат, cast(бцел*) расположение);
	}	

цел УстановиЗначениеРегДопА(ПКлючРег ключ, ткст имяЗначения, бцел резерв, ПРеестр тип, уббайт данные, бцел кбДанные)
	{
	return cast(цел) RegSetValueExA(cast(HKEY)ключ, cast(ткст0) имяЗначения,cast(бцел) резерв,cast(бцел) тип, cast(ббайт*) данные,cast(бцел) кбДанные);
	}
	

бул ОсвободиРесурс(гук данныеРес)
	{
	return cast(бул)  FreeResource(cast(гук) данныеРес);
	}

гук БлокируйРесурс(гук данныеРес)
	{
	return cast(гук) LockResource(cast(гук) данныеРес);
	}
	
гук РазместиГлоб(ППамять флаги , бцел байты)
{
	return cast(гук) GlobalAlloc(cast(бцел) флаги , cast(бцел) байты);
}

гук ПереместиГлоб(гук укз, т_мера байты, ППамять флаги)
{
	return cast(гук) GlobalReAlloc(cast(гук) укз, cast(бцел) байты, cast(бцел) флаги);
}

т_мера РазмерГлоб(гук укз){return cast(т_мера) GlobalSize(cast(гук) укз);}
бцел ФлагиГлоб(гук укз){return cast(бцел) GlobalFlags(cast(гук) укз );}
ук БлокируйГлоб(гук укз){return cast(ук) GlobalLock(cast(гук) укз);}

гук ХэндлГлоб(ук пам){return cast(гук) GlobalHandle(cast(ук) пам);}

бул  РазблокируйГлоб(гук пам)
	{
	return cast(бул) GlobalUnlock(cast(гук) пам);
	}

гук  ОсвободиГлоб(гук пам)
	{
	return cast(гук) GlobalFree(cast(гук) пам);
	}

бцел СожмиГлоб(бцел минОсвоб)
	{
	return cast(бцел) GlobalCompact(cast(бцел) минОсвоб);
	}

проц ФиксируйГлоб(гук пам)
	{
	return GlobalFix(cast(гук) пам);
	}

проц РасфиксируйГлоб(гук пам)
	{
	return GlobalUnfix(cast(гук) пам);
	}
	
ук ВяжиГлоб(гук пам)
	{
	return cast(ук) GlobalWire(cast(гук) пам);
	}

бул ОтвяжиГлоб(гук пам)
	{
	return cast(бул) GlobalUnWire(cast(гук) пам);
	}

проц СтатусГлобПамяти(sys.WinStructs.СТАТПАМ *буф)
	{
	GlobalMemoryStatus(cast(СТАТПАМ*) буф);
	}
	

/+	
проц СтатусГлобПамятиДоп(sys.WinStructs.СТАТПАМДОП *буф)
	{
	GlobalMemoryStatus(cast(LPMEMORYSTATUSEX) буф);
	}
+/

лук РазместиЛок(ППамять флаги, бцел байты)
	{
	return cast(лук) LocalAlloc(cast(бцел) флаги, cast(бцел) байты);
	}

лук ПереместиЛок(лук пам, бцел байты, ППамять флаги)
	{
	return cast(лук) LocalReAlloc(cast(лук) пам, cast(бцел) байты, cast(бцел) флаги);
	}

ук БлокируйЛок(лук пам)
	{
	return cast(ук) LocalLock(cast(лук) пам);
	}

лук ХэндлЛок(ук пам)
	{
	return cast(лук) LocalHandle(cast(ук) пам);
	}

бул РазблокируйЛок(лук пам)
	{
	return cast(бул) LocalUnlock(cast(лук) пам);
	}

т_мера РазмерЛок(лук пам)
	{
	return cast(т_мера) LocalSize(cast(лук) пам);
	}

бцел ФлагиЛок(лук пам)
	{
	return cast(бцел) LocalFlags(cast(лук) пам);
	}

лук ОсвободиЛок(лук пам)
	{
	return cast(лук) LocalFree(cast(лук) пам);
	}

бцел РасширьЛок(лук пам, бцел новРазм)
	{
	return cast(бцел) LocalShrink(cast(лук) пам,cast(бцел) новРазм);
	}

бцел СожмиЛок(бцел минОсв)
	{
	return cast(бцел) LocalCompact(cast(бцел) минОсв);
	}

бул СлейКэшИнструкций(ук процесс, ук адрБаз, бцел разм)
	{
	return cast(бул) FlushInstructionCache(cast(ук) процесс, cast(ук) адрБаз, cast(бцел) разм);
	}

ук РазместиВирт(ук адрес, бцел разм, ППамять типРазмещения, бцел защита)
	{
	return cast(ук) VirtualAlloc(cast(ук) адрес, cast(бцел) разм, cast(бцел) типРазмещения, cast(бцел) защита);
	}

бул ОсвободиВирт(ук адрес, бцел разм, ППамять типОсвобождения)
	{
	return cast(бул) VirtualFree(cast(ук) адрес, cast(бцел) разм, cast(бцел) типОсвобождения);
	}

бул ЗащитиВирт(ук адр, бцел разм, бцел новЗащ, убцел старЗащ)
	{
	return cast(бул) VirtualProtect(cast(ук) адр, cast(бцел) разм, cast(бцел) новЗащ,cast(бцел*) старЗащ);
	}

бцел ОпросиВирт(ук адр, sys.WinStructs.БАЗИОП *буф, бцел длина)
	{
	return cast(бцел) VirtualQuery(cast(ук) адр, cast(БАЗИОП*) буф, cast(бцел) длина);
	}

ук РазместиВиртДоп(ук процесс, ук адрес, бцел разм, ППамять типРазмещ, бцел защита)
	{
	return cast(ук) VirtualAllocEx(cast(ук) процесс, cast(ук) адрес, cast(бцел) разм, cast(бцел) типРазмещ, cast(бцел) защита);
	}

бул ОсвободиВиртДоп(ук процесс, ук адр, бцел разм, ППамять типОсвоб)
	{
	return cast(бул) VirtualFreeEx(cast(ук) процесс, cast(ук) адр, cast(бцел) разм, cast(бцел) типОсвоб);
	}

бул ЗащитиВиртДоп(ук процесс, ук адр, бцел разм, бцел новЗащ, убцел старЗащ)
	{
	return cast(бул) VirtualProtectEx(cast(ук) процесс, cast(ук) адр, cast(бцел) разм, cast(бцел) новЗащ, cast(бцел*) старЗащ);
	}

бцел ОпросиВиртДоп(ук процесс, ук адр, sys.WinStructs.БАЗИОП *буф, бцел длина)
	{
	return cast(бцел) VirtualQueryEx(процесс,  адр,  буф,  длина);
	}
	
//проц КопируйПамять(ук куда, ук откуда, т_мера длина)
//{ RtlCopyMemory(  cast(ук) куда,  cast(VOID*) откуда,  длина);}

проц ЗаполниПамять(ук куда, т_мера длина, ббайт зап){ RtlFillMemory( cast(ук) куда,  длина, cast(ббайт) зап);}

//т_мера ДайМинимумБСтраницы() {return cast(т_мера) GetLargePageMinimum();}

бцел ДайОбзорЗаписи(ППамять флаги, in ук базАдр, in т_мера размРег, ук* адры, inout бцел* счёт, out бцел* гранулярность){return cast(бцел) GetWriteWatch(  cast(бцел) флаги,  cast(ук) базАдр, размРег, cast(ук*) адры,  cast(бдол*) счёт,  cast(бцел*) гранулярность);}

бцел СбросьОбзорЗаписи(ук базАдр, т_мера размРег){ return cast(бцел) ResetWriteWatch( cast(ук) базАдр, размРег);}

бул ПлохойУкНаКод_ли(ук проц){return cast(бул) IsBadCodePtr(cast(FARPROC) проц);}

бул ПлохойЧтенУк_ли(ук первБайтБлока, бцел размБлока){return cast(бул) IsBadReadPtr(cast(ук) первБайтБлока, cast(бцел) размБлока);}

бул ПлохойЗапУк_ли(ук первБайтБлока, бцел размБлока){return cast(бул) IsBadWritePtr(cast(ук) первБайтБлока, cast(бцел) размБлока);}
//{return cast(бул) IsBadHugeReadPtr(ук, бцел);}
//{return cast(бул) IsBadHugeWritePtr(cast(ук), бцел);}

бул ПлохойСтрУк_ли(усим т, бцел разм){return cast(бул) IsBadStringPtrA(cast(ткст0) т , cast(бцел) разм);}

бул ПлохойШСтрУк_ли(шткст0 т, бцел разм){return cast(бул) IsBadStringPtrW(cast(шткст0)т, cast(бцел) разм);}

проц ПереместиПамять(ук куда, ук откуда, т_мера длина){ RtlMoveMemory(  куда,  откуда, длина);}

//ук ОбнулиПамятьБезоп(ук укз, т_мера разм){return cast(ук) RtlSecureZeroMemory( cast(ук) укз, разм);}

проц ОбнулиПамять(ук где, т_мера разм){RtlZeroMemory(  cast(ук) где, разм);}


ук ДайКучуПроцесса(){return cast(ук) GetProcessHeap();}
	
бцел ДайКучиПроцесса(бцел члоКуч, out ук *укз){return cast(бцел) GetProcessHeaps(cast(бцел) члоКуч, cast(ук*) укз);}
	
ук СоздайКучу(ППамять опц, т_мера начРазм, т_мера максРазм){return cast(ук) HeapCreate(cast(бцел) опц, cast(бцел) начРазм, cast(бцел) максРазм);}
бул УдалиКучу(ук укз){return cast(бул) HeapDestroy(cast(ук) укз);}
ук РазместиКучу(ук куча, ППамять флаги, т_мера байты){return cast(ук) HeapAlloc(cast(ук) куча, cast(бцел) флаги, cast(бцел) байты);}
ук ПереместиКучу(ук куча, ППамять флаги, ук блок, т_мера байты){return cast(ук) HeapReAlloc(cast(ук) куча, cast(бцел) флаги, cast(ук) блок, cast(бцел) байты);}
бул ОсвободиКучу(ук куча, ППамять флаги, ук блок){return cast(бул) HeapFree(cast(ук) куча, cast(бцел) флаги, cast(ук) блок);}
бцел РазмерКучи(ук укз, ППамять флаги, ук блок ){return cast(бцел) HeapSize(cast(ук) укз, cast(бцел) флаги, cast(ук) блок);}
бул ПроверьКучу(ук укз, ППамять флаги, ук блок ){return cast(бул) HeapValidate(cast(ук) укз, cast(бцел) флаги, cast(ук) блок);}
бцел СожмиКучу(ук укз, ППамять флаги){ return cast(бцел) HeapCompact(cast(ук) укз, cast(бцел) флаги);}
бул БлокируйКучу(ук укз){return cast(бул) HeapLock(cast(ук) укз);}
бул РазблокируйКучу(ук укз){return cast(бул) HeapUnlock(cast(ук) укз);}
бул ОбойдиКучу(ук укз, ЗАППРОЦКУЧ* зап) {return cast(бул) HeapWalk(cast(ук) укз,  зап);}

бул ЗапросиИнфОКуче (ук куча, бцел клинф, ук инф, т_мера длинаклинф, т_мера* длвозвр){ return cast(бул) HeapQueryInformation(cast(ук) куча,  клинф, cast(ук) инф, длинаклинф, длвозвр);}

бул УстановиИнфОКуче(ук куча, бцел клинф, ук кинф, т_мера длкинф){return cast(бул) HeapSetInformation( cast(ук) куча, клинф, cast(ук) кинф, длкинф);}

проц ДайСистВремя(sys.WinStructs.СИСТВРЕМЯ* систВрем)
	{
	GetSystemTime(cast(СИСТВРЕМЯ*) систВрем);
	}

бул ДайФВремя(ук файл, sys.WinStructs.ФВРЕМЯ *времяСоздания, sys.WinStructs.ФВРЕМЯ *времяПоследнегоДоступа, sys.WinStructs.ФВРЕМЯ *времяПоследнейЗаписи)
	{
	return cast(бул) GetFileTime(cast(ук) файл, cast(ФВРЕМЯ*) времяСоздания, cast(ФВРЕМЯ*) времяПоследнегоДоступа, cast(ФВРЕМЯ*) времяПоследнейЗаписи);
	}

проц ДайСистВремяКакФВремя(sys.WinStructs.ФВРЕМЯ* сисВремКакФВрем)
	{
	GetSystemTimeAsFileTime(cast(ФВРЕМЯ*)  сисВремКакФВрем);
	}

бул УстановиСистВремя(sys.WinStructs.СИСТВРЕМЯ* систВрем)
	{
	return cast(бул) SetSystemTime(cast(СИСТВРЕМЯ*) систВрем);
	}

бул УстановиФВремя(ук файл, in sys.WinStructs.ФВРЕМЯ *времяСоздания, in sys.WinStructs.ФВРЕМЯ *времяПоследнДоступа, in sys.WinStructs.ФВРЕМЯ *времяПоследнЗаписи)
	{
	return cast(бул) SetFileTime(cast(ук) файл, cast(ФВРЕМЯ*) времяСоздания, cast(ФВРЕМЯ*) времяПоследнДоступа, cast(ФВРЕМЯ*) времяПоследнЗаписи);
	}

проц ДайМестнВремя(sys.WinStructs.СИСТВРЕМЯ *систВремя)
	{
	GetLocalTime(cast(СИСТВРЕМЯ*) систВремя);
	}
	
бул УстановиМестнВремя(sys.WinStructs.СИСТВРЕМЯ *систВремя)
	{
	return cast(бул) SetLocalTime(cast(СИСТВРЕМЯ*) систВремя);
	}

бул СистВремяВМестнВремяЧП(ИНФОЧП *инфОЧасПоясе, sys.WinStructs.СИСТВРЕМЯ *мировВремя, sys.WinStructs.СИСТВРЕМЯ *местнВремя)
	{
	return cast(бул) SystemTimeToTzSpecificLocalTime(cast(ИНФОЧП*) инфОЧасПоясе, cast(СИСТВРЕМЯ*) мировВремя, cast(СИСТВРЕМЯ*) местнВремя);
	}

бцел ДайИнфОЧП(ИНФОЧП *инфОЧП)
	{
	return cast(бцел) GetTimeZoneInformation(cast(ИНФОЧП*) инфОЧП);
	}

бул УстановиИнфОЧП(ИНФОЧП *инфОЧП)
	{
	return cast(бул) SetTimeZoneInformation(cast(ИНФОЧП*) инфОЧП);
	}

бул СистВремяВФВремя(in sys.WinStructs.СИСТВРЕМЯ *систВрем, sys.WinStructs.ФВРЕМЯ *фВрем)
	{
	return cast(бул) SystemTimeToFileTime(cast(СИСТВРЕМЯ*) систВрем, cast(ФВРЕМЯ*) фВрем);
	}

бул ФВремяВМестнФВремя(in sys.WinStructs.ФВРЕМЯ *фВрем, sys.WinStructs.ФВРЕМЯ *местнФВрем)
	{
	return cast(бул) FileTimeToLocalFileTime(cast(ФВРЕМЯ*) фВрем, cast(ФВРЕМЯ*) местнФВрем);
	}

бул МестнФВремяВФВремя(in sys.WinStructs.ФВРЕМЯ *локФВрем, sys.WinStructs.ФВРЕМЯ *фВрем)
	{
	return cast(бул) LocalFileTimeToFileTime(cast(ФВРЕМЯ*) локФВрем, cast(ФВРЕМЯ*) фВрем);
	}

бул ФВремяВСистВремя(in sys.WinStructs.ФВРЕМЯ *фВрем, sys.WinStructs.СИСТВРЕМЯ *систВрем)
	{
	return cast(бул) FileTimeToSystemTime(cast(ФВРЕМЯ*) фВрем, cast(СИСТВРЕМЯ*) систВрем);
	}

бул ФВремяВДатВремяДОС(in sys.WinStructs.ФВРЕМЯ *фвр, убкрат фатДата, убкрат фатВремя)
	{
	return cast(бул) FileTimeToDosDateTime(cast(ФВРЕМЯ*) фвр, cast(бкрат*) фатДата, cast(бкрат*) фатВремя);
	}

бул ДатВремяДОСВФВремя(бкрат фатДата,  бкрат фатВремя, sys.WinStructs.ФВРЕМЯ *фвр)
	{
	return cast(бул) DosDateTimeToFileTime(cast(бкрат) фатДата, cast(бкрат) фатВремя, cast(ФВРЕМЯ*) фвр);
	}

бцел ДайСчётТиков()
	{
	return cast(бцел) GetTickCount();
	}

бул УстановиНастрСистВремени(бцел настройкаВрем, бул настВремОтключена)
	{
	return cast(бул) SetSystemTimeAdjustment(cast(бцел) настройкаВрем, cast(бул) настВремОтключена);
	}

бул ДайНастрСистВремени(убцел настрВрем, убцел инкВрем, бул* настрВремОтключена)
	{
	return cast(бул) GetSystemTimeAdjustment(cast(бцел*) настрВрем, cast(бцел*) инкВрем, cast(бул*) настрВремОтключена);
	}

бцел ФорматируйСообА(ПФорматСооб флаги, ук исток, бцел идСооб, бцел идЯз, ткст буф, бцел разм, ук* арги)
	{
    ткст0 буфер = stringz.вТкст0(буф);
    бцел r;

    r = FormatMessageA(cast(бцел) флаги, cast(ук) исток, cast(бцел) идСооб, 
        cast(бцел) идЯз, cast(ткст0 ) буфер, cast(бцел) разм, cast(ук*) арги);
   буф = вТкст(буфер);	
   return r;
	}

бцел ФорматируйСооб(ПФорматСооб флаги, ук исток, бцел идСооб, бцел идЯз, ткст буф, бцел разм, ук* арги)
	{
    шткст буфер = std.utf.toUTF16(буф);
    бцел r;
	r =  FormatMessageW(cast(бцел) флаги, cast(ук) исток, cast(бцел) идСооб,  cast(бцел) идЯз, cast(шткст0 ) буфер, cast(бцел) разм, cast(ук*) арги);
    буф = cast(ткст)(std.utf.toUTF8(буфер));    
    return r;
    }
	
ук ДайТекущуюНить()
	{
	return cast(ук) GetCurrentThread();
	}

бул ДайВременаПроцесса(ук процесс, sys.WinStructs.ФВРЕМЯ *времяСозд, sys.WinStructs.ФВРЕМЯ *времяВыхода, sys.WinStructs.ФВРЕМЯ *времяЯдра, sys.WinStructs.ФВРЕМЯ *времяПользователя)
	{
	return cast(бул) GetProcessTimes(cast(ук) процесс, cast(ФВРЕМЯ*) времяСозд, cast(ФВРЕМЯ*) времяВыхода, cast(ФВРЕМЯ*) времяЯдра, cast(ФВРЕМЯ*) времяПользователя);
	}

ук ДайТекущийПроцесс()
	{
	return  cast(ук) GetCurrentProcess();
	}

бцел ДайИдТекущегоПроцесса()
	{
	return cast(бцел) GetCurrentProcessId();
	}

бул ДублируйДескр(ук исходнПроц, ук исходнНить, ук хендлПроцЦели, ук *цхендл, ППраваДоступа доступ, бул наследоватьДескр, бцел опции)
	{
	return cast(бул) DuplicateHandle(cast(ук) исходнПроц, cast(ук) исходнНить,  cast(ук) хендлПроцЦели, cast(ук*) цхендл, cast(бцел) доступ, cast(бул) наследоватьДескр, cast(бцел) опции);
	}

бцел ДайЛокальНити() {return GetThreadLocale();} 
	
бцел ДайИдТекущейНити()
	{
	return cast(бцел) GetCurrentThreadId();
	}

бул УстановиПриоритетНити(ук нить, ППриоритетНити приоритет)
	{
	return cast(бул) SetThreadPriority(cast(ук) нить, cast(цел) приоритет);
	}

бул УстановиПовышениеПриоритетаНити(ук нить, бул отклПовышениеПриоритета)
	{
	return cast(бул) SetThreadPriorityBoost(cast(ук) нить,  отклПовышениеПриоритета);
	}

бул ДайПовышениеПриоритетаНити(ук нить, бул отклПовышениеПриоритета)
	{
	return cast(бул) GetThreadPriorityBoost(cast(ук) нить, cast(бул*) отклПовышениеПриоритета);
	}

бул ДайВременаНити(ук нить, sys.WinStructs.ФВРЕМЯ *времяСозд, sys.WinStructs.ФВРЕМЯ *времяВыхода, sys.WinStructs.ФВРЕМЯ *времяЯдра, sys.WinStructs.ФВРЕМЯ *времяПользователя)
	{
	return cast(бул) GetThreadTimes(cast(ук) нить, cast(ФВРЕМЯ*) времяСозд, cast(ФВРЕМЯ*) времяВыхода, cast(ФВРЕМЯ*) времяЯдра, cast(ФВРЕМЯ*) времяПользователя);
	}

цел ДайПриоритетНити(ук нить)
	{
	return cast(цел) GetThreadPriority(cast(ук) нить);
	}

бул ДайКонтекстНити(ук нить, sys.WinStructs.КОНТЕКСТ *контекст)
	{
	return cast(бул) GetThreadContext(cast(ук) нить, cast(КОНТЕКСТ*) контекст);
	}

бул УстановиКонтекстНити(ук нить, sys.WinStructs.КОНТЕКСТ *контекст)
	{
	return cast(бул) SetThreadContext(cast(ук) нить, cast(КОНТЕКСТ*) контекст);
	}

бцел ЗаморозьНить(ук нить)
	{
	return cast(бцел) SuspendThread(cast(ук) нить);
	}

бцел  РазморозьНить(ук нить)
	{
	return cast(бцел) ResumeThread(cast(ук) нить);
	}

бцел ЖдиОдинОбъект(ук хендл, бцел миллисекк)
	{
	return cast(бцел) WaitForSingleObject(cast(ук) хендл, cast(бцел) миллисекк);
	}

бцел ЖдиНесколькоОбъектов(бцел счёт, ук *хендлы, бул ждатьВсе, бцел миллисекк)
	{
	return cast(бцел) WaitForMultipleObjects(cast(бцел) счёт, cast(ук *) хендлы, cast(бул) ждатьВсе, cast(бцел) миллисекк);
	}

проц Спи(бцел миллисекк)
	{
	 Sleep(cast(бцел) миллисекк);
	}
 //////
цел БлокированныйИнкремент( цел * увеличиваемое)
	{
	return cast(цел)  InterlockedIncrement(cast(цел*) увеличиваемое);
	}

цел БлокированныйДекремент( цел * уменьшаемое)
	{
	return cast(цел)  InterlockedDecrement(cast(цел*) уменьшаемое);
	}

цел БлокированныйОбмен( цел * цель, цел значение)
	{
	return cast(цел)  InterlockedExchange(cast(цел*) цель, cast(цел) значение);
	}

цел БлокированныйОбменДобавка( цел * добавляемое, цел значение)
	{
	return cast(цел) InterlockedExchangeAdd(cast(цел*) добавляемое, cast(цел) значение);
	}

ук БлокированныйОбменСравнение(ук *цель, ук обмен, ук сравниваемое)
	{
	return cast(ук) InterlockedCompareExchange(cast(ук *) цель, cast(ук) обмен, cast(ук) сравниваемое);
	}

проц ИнициализуйКритическуюСекцию(sys.WinStructs.КРИТСЕКЦ *критСекц)
	{
	InitializeCriticalSection(cast(КРИТСЕКЦ *) критСекц);
	}

проц ВойдиВКритическуюСекцию(sys.WinStructs.КРИТСЕКЦ *критСекц)
	{
	EnterCriticalSection(cast(КРИТСЕКЦ *) критСекц);
	}

бул ПробуйВойтиВКритическуюСекцию(sys.WinStructs.КРИТСЕКЦ *критСекц)
	{
	return cast(бул) TryEnterCriticalSection(cast(КРИТСЕКЦ *) критСекц);
	}

проц ПокиньКритическуюСекцию(sys.WinStructs.КРИТСЕКЦ *критСекц)
	{
	LeaveCriticalSection(cast(КРИТСЕКЦ *) критСекц);
	}

бул ОпросиСчётчикПроизводительности(дол *счПроизв)
	{
	return cast(бул) QueryPerformanceCounter(cast(дол*) счПроизв);
	}

бул ОпросиЧастотуПроизводительности(дол *частота)
	{
	return cast(бул) QueryPerformanceFrequency(cast(дол*) частота);
	}

ук ОткройМаппингФайлаА(ППамять желДоступ, бул наследовать, ткст имяМаппинга){return cast(ук) OpenFileMappingA(cast(бцел) желДоступ, cast(бул) наследовать, cast(ткст0) имяМаппинга);}

ук ОткройМаппингФайла(ППамять желДоступ, бул наследовать, ткст имяМаппинга){return cast(ук) OpenFileMappingW(cast(бцел) желДоступ, cast(бул) наследовать, cast(шткст0) toUTF16z(имяМаппинга));}

ук ВидФайлаВКарту(ук объектФМап, ППамять желатДоступ, бцел фСмещВ, бцел фСмещН, бцел члоБайтовДляМап)
{
return cast(ук) MapViewOfFile(cast(ук) объектФМап, cast(бцел) желатДоступ, cast(бцел) фСмещВ,cast(бцел) фСмещН,cast(бцел) члоБайтовДляМап);
}

ук ВидФайлаВКартуДоп(ук объектФМап, ППамять желатДоступ, бцел фСмещВ, бцел фСмещН, бцел члоБайтовДляМап, ук адрОвы)
	{
	return cast(ук) MapViewOfFileEx(cast(ук) объектФМап, cast(бцел) желатДоступ, cast(бцел) фСмещВ,cast(бцел) фСмещН,cast(бцел) члоБайтовДляМап, cast(ук) адрОвы);
	}

бул СлейВидФайла(ук адрОвы, бцел члоСливБайт){return cast(бул) FlushViewOfFile(cast(ук) адрОвы,cast(бцел) члоСливБайт);}

бул ВидФайлаИзКарты(ук адрОвы){return cast(бул) UnmapViewOfFile(cast(ук) адрОвы);}
/*
 HGDIOBJ   GetStockObject(цел);
Бул ShowWindow(ук окно, цел nCmdShow);*/

бул СлейБуферыФайла(ук файлУк){return cast(бул) FlushFileBuffers(cast(ук) файлУк);}

бцел ДайТипФайла(ук файлУк){return cast(бцел)  GetFileType(cast(ук) файлУк);}
	
 бул ОбновиОкно(ук ок){return cast(бул) UpdateWindow(cast(УОК) ок);}
 
 ук УстановиАктивноеОкно(ук ок){return cast(ук) SetActiveWindow(cast(УОК) ок);}
 
 ук ДайФоновоеОкно(){return cast(ук) GetForegroundWindow();}
 
 бул РисуйРабСтол(ук ку){return cast(бул) PaintDesktop(cast(HDC) ку);}
 
 бул УстановиФоновоеОкно(ук ок){return cast(бул) SetForegroundWindow(cast(УОК) ок);}
 
 ук ОкноИзКУ(ук ку){return cast(ук) WindowFromDC(cast(HDC) ку);}
 
 ук ДайКУ(ук ок){return cast(ук) GetDC(cast(УОК) ок);}
 
 ук ДайКУДоп(ук ок, ук регКлип, ПФлагКУДоп флаги){return cast(ук) GetDCEx(cast(УОК) ок, cast(HRGN) регКлип,cast(бцел) флаги);}
 
 ук ДайКУОкна(ук ок){return cast(ук) GetWindowDC(cast(УОК) ок);}
 
 цел ОтпустиКУ(ук ок, ук ку){return cast(цел) ReleaseDC(cast(УОК) ок, cast(HDC) ку);}
 
 ук НачниРис(ук ок, РИССТРУКТ* рис){return cast(ук) BeginPaint(cast(УОК) ок, cast(РИССТРУКТ*) рис);}
 
 бул ЗавершиРис(ук ок, РИССТРУКТ * рис){return cast(бул) EndPaint(cast(УОК) ок, cast(РИССТРУКТ*) рис);} 
 
  бул ДайПрямОбнова(ук ок, ПРЯМ *пр, бул стереть){return cast(бул) GetUpdateRect(cast(УОК) ок,cast(ПРЯМ*) пр,  стереть);}
  
  цел ДайРгнОбнова(ук ок, ук ргн, бул стереть){return GetUpdateRgn(cast(УОК) ок, cast(HRGN) ргн,  стереть);}
  
  цел УстановиРгнОкна(ук ок, ук рг, бул перерисовать){return  SetWindowRgn(cast(УОК) ок, cast(HRGN) рг,  перерисовать);}
  
  цел ДайРгнОкна(ук ок, ук ргн){return GetWindowRgn(cast(УОК) ок, cast(HRGN) ргн);}
  
  цел ИсключиРгнОбнова(ук ку, ук ок){return ExcludeUpdateRgn(cast(HDC) ку, cast(УОК) ок);}
  
  бул ИнвалидируйПрям(ук ок, ПРЯМ *пр, бул стереть){return cast(бул) InvalidateRect(cast(УОК) ок, cast(ПРЯМ*) пр,  стереть);}
  
  бул ВалидируйПрям(ук ок, ПРЯМ *пр){return cast(бул) ValidateRect(cast(УОК) ок, cast(ПРЯМ*) пр);}
  
  бул ИнвалидируйРгн(ук ок, ук ргн, бул стереть){return cast(бул) InvalidateRgn(cast(УОК) ок, cast(HRGN) ргн,  стереть);}
  
  бул ВалидируйРгн(ук ок, ук ргн){return cast(бул) ValidateRgn(cast(УОК) ок, cast(HRGN) ргн);}
  
  бул ПерерисуйОкно(ук ок, ПРЯМ *обн, ук ргнОб, ПОкПерерис фОкПерерис){return cast(бул) RedrawWindow(cast(УОК) ок, cast(ПРЯМ*) обн, cast(HRGN) ргнОб, cast(бцел) фОкПерерис);}
  
	
	цел ВСАСтарт(крат требВерсия, ВИНСОКДАН* всадан)
		{
		return  WSAStartup(cast(бкрат) требВерсия, cast(ВИНСОКДАН*) всадан);
		}
		
	цел ВСАЧистка(){return  WSACleanup();}
	
	цел ВСАДайПоследнююОшибку(){return WSAGetLastError();}
	
	СОКЕТ сокет(ПСемействоАдресов са, ПТипСок тип, ППротокол протокол)
		{
		return cast(СОКЕТ) socket(cast(цел) са, cast(цел) тип, cast(цел) протокол);
		}
		
	цел ввктлсок(СОКЕТ с, цел кмд, бцел* аргук)
		{
		return  ioctlsocket(cast(СОКЕТ) с, кмд, аргук);
		}
		
	цел свяжисок(СОКЕТ с, sys.WinStructs.адрессок* имя, цел длинаим)
		{
		return  bind(cast(СОКЕТ) с, cast(адрессок*) имя, длинаим);
		}
		
	цел подключи(СОКЕТ с, sys.WinStructs.адрессок* имя, цел длинаим)
		{
		return  connect(cast(СОКЕТ) с, cast(адрессок*) имя, длинаим);
		}
		
	цел слушай(СОКЕТ с, цел бэклог)
		{
		return  listen(cast(СОКЕТ) с, бэклог);
		}
		
	СОКЕТ пусти(СОКЕТ с, sys.WinStructs.адрессок* адр,  цел * длинадр)
		{
		return cast(СОКЕТ) accept(cast(СОКЕТ) с, cast(адрессок*) адр, cast(цел*) длинадр);
		}
		
	цел закройсок(СОКЕТ с){return  closesocket(cast(СОКЕТ) с);}
	
	цел экстрзак(СОКЕТ с, ПЭкстрЗакрытиеСокета как){return  shutdown(cast(СОКЕТ) с, cast(цел) как);}
	
	
	цел дайимяпира(СОКЕТ с, sys.WinStructs.адрессок* имя,  цел * длинаим)
		{
		return  getpeername(cast(СОКЕТ) с, cast(адрессок*) имя, cast(цел*) длинаим);
		}
		
	цел дайимясок(СОКЕТ с, sys.WinStructs.адрессок* адр,  цел * длинаим)
		{
		return  getsockname(cast(СОКЕТ) с, cast(адрессок*) адр, cast(цел*) длинаим);
		}
		
	цел шли(СОКЕТ с, ук буф, цел длин, ПФлагиСокета флаги)
		{
		return  send(cast(СОКЕТ) с, буф, длин, cast(цел) флаги);
		}
		
	цел шли_на(СОКЕТ с, ук буф, цел длин, ПФлагиСокета флаги, sys.WinStructs.адрессок* кому, цел длинаприём)
		{
		return sendto(cast(СОКЕТ) с, буф, длин, cast(цел) флаги, cast(адрессок*) кому, длинаприём);
		}
		
	цел прими(СОКЕТ с, ук буф, цел длин, ПФлагиСокета флаги)
		{
		return recv(cast(СОКЕТ) с, буф, длин, cast(цел) флаги);
		}
		
	цел прими_от(СОКЕТ с, ук буф, цел длин, ПФлагиСокета флаги, sys.WinStructs.адрессок* от_кого,  цел * длинаистока)
		{
		return  recvfrom(cast(СОКЕТ) с, буф, длин, cast(цел) флаги, cast(адрессок*) от_кого, cast(цел*) длинаистока);
		}
		
	цел дайопцсок(СОКЕТ с, цел уровень, цел имяопц, ук значопц,  цел * длинаопц)
		{
		return  getsockopt(cast(СОКЕТ) с, уровень, имяопц, значопц, cast(цел*) длинаопц);
		}
		
	цел установиопцсок(СОКЕТ с, цел уровень, цел имяопц, ук значопц, цел длинаопц)
		{
		return setsockopt(cast(СОКЕТ) с, уровень, имяопц, значопц, длинаопц);
		}
		
	бцел адр_инет(ткст т){return  inet_addr(cast(char*) т);}
	
	цел выбери(цел нуд, sys.WinStructs.набор_уд* читнуд, sys.WinStructs.набор_уд* запнуд, sys.WinStructs.набор_уд* ошнуд, sys.WinStructs.значврем* таймаут)
		{
		return select(нуд, cast(набор_уд*) читнуд, cast(набор_уд*) запнуд, cast(набор_уд*) ошнуд, cast(значврем*) таймаут);
		}
		
	ткст инетс8а(sys.WinStructs.адрес_ин иа){return std.string.toString(inet_ntoa(cast(адрес_ин) иа));}
	
	sys.WinStructs.хостзап* дайхостпоимени(ткст имя){return cast(sys.WinStructs.хостзап*) gethostbyname(cast(char*) имя);}
	
	sys.WinStructs.хостзап* дайхостпоадресу(ук адр, цел длин, цел тип)
		{
		return cast(sys.WinStructs.хостзап*) gethostbyaddr(адр, длин, cast(цел) тип);
		}
		
	sys.WinStructs.протзап* дайпротпоимени(ткст имя){return cast(sys.WinStructs.протзап*) getprotobyname(cast(char*) имя);}
	
	sys.WinStructs.протзап* дайпротпономеру(цел номер){return cast(sys.WinStructs.протзап*) getprotobynumber(cast(цел) номер);}
	
	
	sys.WinStructs.служзап* дайслужбупоимени(ткст имя, ткст протокол)
		{
		return cast(sys.WinStructs.служзап*) getservbyname(cast(char*) имя, cast(char*) протокол);
		}
		
	sys.WinStructs.служзап* дайслужбупопорту(цел порт, ткст протокол)
		{
		return cast(sys.WinStructs.служзап*) getservbyport(порт, cast(char*) протокол);
		}
		
	цел дайимяхоста(ткст имя, цел длинаим){return  gethostname(cast(char*) имя, длинаим);}
	
	цел дайадринфо(ткст имяузла, ткст имяслуж, sys.WinStructs.адринфо* хинты, sys.WinStructs.адринфо** рез)
		{
		return  getaddrinfo(cast(char*) имяузла, cast(char*) имяслуж, cast(адринфо*) хинты, cast(адринфо**) рез);
		}
		
	проц высвободиадринфо(sys.WinStructs.адринфо* аи){freeaddrinfo(cast(адринфо*) аи);}
	
	цел дайинфобимени(sys.WinStructs.адрессок* ас, т_длинсок длинсок, ткст хост, бцел длинхост, ткст серв, бцел длинсерв, ПИмИнфо флаги)
		{
		return  getnameinfo(cast(адрессок*) ас, длинсок, cast(char*) хост, cast(бцел) длинхост, cast(char*) серв, cast(бцел) длинсерв, cast(цел) флаги);
		}
		
	шткст0 ДайКомСтроку(){return GetCommandLineW();}
 
	шткст0* КомСтрокаВАрги(шткст0 ш, уцел н){ return CommandLineToArgvW(ш, н);}
 
	цел ШирСимВМультиБайт(ПКодСтр кодСтр, ПШирСим флаги, шткст0 укШирСим, цел члоСимШир, сим* укНовСтрБуф, цел размНовСтрБуф, сим* симНекартДефАдр, бул адрФлага)
	{
	return WideCharToMultiByte(cast(бцел) кодСтр, cast(бцел) флаги, cast(шткст0) укШирСим, члоСимШир, cast(ткст0 ) укНовСтрБуф , размНовСтрБуф, cast(ткст0) симНекартДефАдр, cast(бул*) адрФлага);
	}
	
	цел МультиБайтВШирСим(ПКодСтр кодСтр, бцел флаги, ткст0 укМультиБайт, цел члоСим, шткст0 укНовСтрБуф, цел размНовСтрБуф)
	{
	return MultiByteToWideChar(cast(бцел) кодСтр, cast(бцел) флаги, укМультиБайт, члоСим, cast(шткст0) укНовСтрБуф , размНовСтрБуф);
	}

 
	бцел РазместиНлх(){ return cast(бцел) TlsAlloc();}
  
	ук ДайЗначениеНлх(бцел з){ return cast(ук) TlsGetValue(cast(бцел) з);}
  
	бул УстановиЗначениеНлх(бцел з, ук укз){ return cast(бул) TlsSetValue(з, укз);}
  
	бул ОсвободиНлх(бцел з){ return cast(бул) TlsFree(cast(бцел) з);}  
 
	проц ПокиньПроцесс(бцел кодВыхода){ExitProcess(кодВыхода);}
 
	бул ДайКодВыходаПроцесса( ук процесс, out бцел* код){return cast(бул) GetExitCodeProcess(cast(ук) процесс, cast(бцел*) код);} 
	
	бул СоздайПроцессПользователяА(ук токен, ткст назвПрил, ткст комСтр, БЕЗАТРЫ* атрыПроц, БЕЗАТРЫ* атрыНити, бул наследоватьДескрипторы, ПСозданиеПроцесса создПроцФлаги, ук блокСреды, ткст текПап, ИНФОСТАРТА* стартИнф, ИНФОПРОЦ* инфОПроц)
	{
	return cast(бул) CreateProcessAsUserA(cast(ук) токен, cast(ткст0) назвПрил, cast(ткст0 ) комСтр, cast(БЕЗАТРЫ*) атрыПроц, cast(БЕЗАТРЫ*) атрыНити, cast(бул) наследоватьДескрипторы, cast(бцел) создПроцФлаги, cast(ук) блокСреды, cast(ткст0) текПап,  стартИнф, cast(ИНФОПРОЦ*) инфОПроц);
	}
	
	бул СоздайПроцессПользователя(ук токен, ткст назвПрил, ткст комСтр, БЕЗАТРЫ* атрыПроц, БЕЗАТРЫ* атрыНити, бул наследоватьДескрипторы, ПСозданиеПроцесса создПроцФлаги, ук блокСреды, ткст текПап, ИНФОСТАРТА* стартИнф, ИНФОПРОЦ* инфОПроц)
	{
	return cast(бул) CreateProcessAsUserW(cast(ук) токен, cast(шткст0) toUTF16z(назвПрил), cast(шткст0) toUTF16z(комСтр), cast(БЕЗАТРЫ*) атрыПроц, cast(БЕЗАТРЫ*) атрыНити, cast(бул) наследоватьДескрипторы, cast(бцел) создПроцФлаги, cast(ук) блокСреды, cast(шткст0) toUTF16z(текПап),  стартИнф, cast(ИНФОПРОЦ*) инфОПроц);
	}
	
	бцел ВерсияПостройкиКо()	{	return cast(бцел) CoBuildVersion();	}
	
	цел ТкстИзГУИД2(ГУИД *удгуид, ткст уш, цел кбМакс)
	{
	return cast(цел) StringFromGUID2(cast(GUID*) удгуид, cast(шткст0) toUTF16z(уш), cast(цел) кбМакс);
	}

	цел ИнициализуйКо(ук резерв)	{	return cast(цел) CoInitialize(cast(ук) резерв);	}
	цел ИнициализуйКоДоп(ук резерв, ПИницКо флаг){return cast(цел) CoInitializeEx(резерв, cast(бцел) флаг);}
	
	проц ДеинициализуйКо()	{	CoUninitialize();	}
	бцел ДайТекущийПроцессКо()	{return cast(бцел)  CoGetCurrentProcess();	}

//import sys.win32..objbase;
	
	цел СоздайГуидКо(out ГУИД уГуид)
	{
	return cast(цел) CoCreateGuid( уГуид);
	}
	
	ткст ПрогИДИзКЛСИД(ГУИД клсид)
    {
        шим *прогИд_ш;
       ProgIDFromCLSID( клсид, прогИд_ш );
        return toUTF8(stringz.изТкст16н(прогИд_ш));		
	}
	
    КЛСИД КЛСИДИзПрогИД_(in ткст прогИд)
    {
        шим *прогИд_ш = toUTF16z(прогИд);
        КЛСИД клсид;
        if(УД(CLSIDFromProgID(прогИд_ш, &клсид)))
		return клсид;// ГУИД(клсид.Data1, клсид.Data2, клсид.Data3, клсид.Data4);
        throw new Exception("КЛСИДИзПрогИД - неудачно");
	}
	
	цел КЛСИДИзПрогИД (in шткст0 прогИд, КЛСИД* клсид)
	{
	return CLSIDFromProgID(прогИд, клсид);
	}
	
    КЛСИД КЛСИДИзПрогИДДоп(in ткст прогИд)
    {
        шим *прогИд_ш = toUTF16z(прогИд);
        КЛСИД клсид;
         if(УД(CLSIDFromProgIDEx(прогИд_ш, &клсид)))
		return клсид;//ГУИД(клсид.Data1, клсид.Data2, клсид.Data3, клсид.Data4);
		 throw new Exception("КЛСИДИзПрогИДДоп - неудачно");
	}
	//HRESULT CoCreateInstance(REFCLSID, LPUNKNOWN, DWORD, REFIID, PVOID*);
	цел СоздайЭкземплярКо(КЛСИД клсид, sys.WinIfaces.Инкогнито анонВнешн, бцел контекстКл, ИИД иид, ук* ув)
		{
		return cast(цел) CoCreateInstance(клсид, &анонВнешн,  контекстКл,  иид,  ув);
		}

	цел ДайОбъектКлассаКо(ГУИД рклсид, бцел контекстКл, ук резерв, ГУИД риид, ук* ув)
		{
		return cast(цел) CoGetClassObject( рклсид, контекстКл, резерв,  риид, ув);
		}

	цел СоздайЭкземплярКоДоп(ref ГУИД рклсид, sys.WinIfaces.Инкогнито анонВнешн, бцел контекстКл, sys.WinStructs.КОСЕРВЕРИНФО* сервИнф, бцел счёт, sys.WinStructs.МУЛЬТИ_ОИ* результы)
		{
		return cast(цел) CoCreateInstanceEx( рклсид, анонВнешн, контекстКл,  сервИнф, счёт,  результы);
		}	
		
	ук РазместиПамЗадачиКо(т_мера разм){return CoTaskMemAlloc(разм);}
    ук ПереместиПамЗадачиКо(ук вв, т_мера разм){return  CoTaskMemRealloc(вв, разм);}
    проц ОсвободиПамЗадачиКо(ук в){CoTaskMemFree(в);}

	цел РегистрируйАктивныйОбъект(sys.WinIfaces.Инкогнито инк, ref ГУИД клсид, бцел флаги, out бцел рег)
		{
		return  RegisterActiveObject(инк,  клсид, флаги, рег);
		}
		
	цел РевоцируйАктивныйОбъект(бцел рег, ук резерв){return  RevokeActiveObject(рег, резерв);}
	
	цел ДайАктивныйОбъект(ref ГУИД клсид, ук резерв, out sys.WinIfaces.Инкогнито инк)
		{
		return  GetActiveObject( клсид, резерв, инк);
		}
		
цел РазместиДескрипторБезопмаса(бцел члоИзм, out БЕЗОПМАС* укнаВыв)
	{
	return cast(цел) SafeArrayAllocDescriptor(члоИзм,  укнаВыв);
	}

цел РазместиДескрипторБезопмасаДоп(бкрат вт, бцел члоИзм, out БЕЗОПМАС* укнаВыв)
	{
	return cast(цел) SafeArrayAllocDescriptorEx( вт,  члоИзм, укнаВыв);
	}

цел РазместиДанныеБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayAllocData( бм);
	}

БЕЗОПМАС* СоздайБезопмас(бкрат вт, бцел члоИзм, sys.WinStructs.ГРАНБЕЗОПМАСА* бмГран)
	{
	return cast(БЕЗОПМАС*) SafeArrayCreate( вт, члоИзм,  бмГран);
	}
	
БЕЗОПМАС* СоздайБезопмасДоп(бкрат вт, бцел члоИзм, sys.WinStructs.ГРАНБЕЗОПМАСА* бмГран, ук вЭкстра)
	{
	return cast(БЕЗОПМАС*) SafeArrayCreateEx( вт,  члоИзм,  бмГран, вЭкстра);
	}
	
цел КопируйДанныеБезопмаса(БЕЗОПМАС* бмИсх, БЕЗОПМАС* бмПрий)
	{
	return cast(цел) SafeArrayCopyData( бмИсх,  бмПрий);
	}

цел УничтожьДескрипторБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayDestroyDescriptor( бм);
	}

цел УничтожьДанныеБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayDestroyData(бм);
	}

цел УничтожьБезопмас(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayDestroy( бм);
	}

цел ИзмениГраницуБезопмаса(БЕЗОПМАС* бм, sys.WinStructs.ГРАНБЕЗОПМАСА* бмНовГран)
	{
	return cast(цел) SafeArrayRedim( бм, бмНовГран);
	}

бцел ДайЧлоИзмеренийБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(бцел) SafeArrayGetDim( бм);
	}

бцел ДайРазмерЭлементовБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(бцел) SafeArrayGetElemsize( бм);
	}

цел ДайВПределБезопмаса(БЕЗОПМАС* бм, бцел члоИзм, out цел вПредел)
	{
	return cast(цел) SafeArrayGetUBound( бм, cast(бцел) члоИзм,  вПредел);
	}

цел ДайНПределБезопмаса(БЕЗОПМАС* бм, бцел члоИзм, out цел нПредел)
	{
	return cast(цел) SafeArrayGetLBound( бм, члоИзм, нПредел);
	}

цел БлокируйБезопмас(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayLock(бм);
	}

цел РазблокируйБезопмас(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayUnlock( бм);
	}

цел ДоступКДаннымБезопмаса(БЕЗОПМАС* бм, ук* данные)
	{
	return cast(цел) SafeArrayAccessData( бм, данные);
	}

цел ОтступОтДаныхБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayUnaccessData( бм);
	}

цел ДайЭлементБезопмаса(БЕЗОПМАС* бм,  цел * индексы, ук в)
	{
	return cast(цел) SafeArrayGetElement( бм,  cast(цел*) индексы,  в);
	}
	
цел ПоместиЭлементВБезопмас(БЕЗОПМАС* бм,  цел * индексы, ук в)
	{
	return cast(цел) SafeArrayPutElement( бм,  cast(цел*) индексы,  в);
	}

цел КопируйБезопмас(БЕЗОПМАС* бм, out БЕЗОПМАС* бмВыв)
	{
	return cast(цел) SafeArrayCopy( бм, бмВыв);
	}

цел УкНаИндексБезопмаса(БЕЗОПМАС* бм,  цел * индексы, ук* данные)
	{
	return cast(цел) SafeArrayPtrOfIndex( бм,  cast(цел*) индексы, данные);
	}

цел УстИнфОЗаписиБезопмаса(БЕЗОПМАС* бм, sys.WinIfaces.ИИнфОЗаписи инфоз)
	{
	return cast(цел) SafeArraySetRecordInfo( бм,  инфоз);
	}

цел ДайИнфОЗаписиБезопмаса(БЕЗОПМАС* бм, out sys.WinIfaces.ИИнфОЗаписи инфоз)
	{
	return cast(цел) SafeArrayGetRecordInfo( бм,  инфоз);
	}

цел УстановиИИДБезопмаса(БЕЗОПМАС* бм, ref ГУИД гуид)
	{
	return cast(цел) SafeArraySetIID( бм,  гуид);
	}

цел ДайИИДБезопмаса(БЕЗОПМАС* бм, out ГУИД гуид)
	{
	return cast(цел) SafeArrayGetIID( бм, гуид);
	}

цел ДайВартипБезопмаса(БЕЗОПМАС* бм, бкрат вт)
	{
	return cast(цел) SafeArrayGetVartype( бм,  вт);
	}

БЕЗОПМАС* СоздайВекторБезопмаса(бкрат вт, цел нПредел, бцел элементы)
	{
	return cast(БЕЗОПМАС*) SafeArrayCreateVector( вт,  нПредел, элементы);
	}

БЕЗОПМАС* СоздайВекторБезопмасаДоп(бкрат вт, цел нПредел, бцел элементы, ук экстра)
	{
	return cast(БЕЗОПМАС*) SafeArrayCreateVectorEx( вт, нПредел,  элементы,  экстра);
	}
///////////////////////////////

цел ДесВарИзБцел(бцел бцВхо, out ДЕСЯТОК десВых)
	{
	return cast(цел) VarDecFromUI4(бцВхо, десВых);
	}

цел ДесВарИзЦел(цел цВхо, out ДЕСЯТОК десВых)
	{
	return cast(цел) VarDecFromI4(цВхо, десВых);
	}

цел ДесВарИзБдол(бдол бдВхо, out ДЕСЯТОК десВых)
	{
		return cast(цел) VarDecFromUI8(бдВхо, десВых);
	}

цел ДесВарИзДол(дол дВхо, out ДЕСЯТОК десВых)
	{
		return cast(цел) VarDecFromI8(дВхо,  десВых);
	}
	

цел ДесВарИзПлав(плав вх, out ДЕСЯТОК дес)
	{	
		return VarDecFromR4(вх,  дес);
	}
		
цел ДесВарИзДво(дво вх, out ДЕСЯТОК дес)
	{
		return VarDecFromR8(вх,  дес);
	}

цел ДесВарИзТкстш0(in шим* ткс, бцел лкид, бцел флаги, out ДЕСЯТОК дес)
	{
	return VarDecFromStr(ткс, лкид, cast(бцел) флаги,  дес);
	}

цел БткстВарИзДес(ref ДЕСЯТОК *дес, бцел лкид, бцел флаги, out шим* стр)
	{
	return VarBstrFromDec( дес, лкид, cast(бцел) флаги, стр);
	}
	
цел БцелВарИзДес(ref ДЕСЯТОК дес, out бцел ц)
	{
	return VarUI4FromDec( дес, ц);
	}
	
цел ЦелВарИзДес(ref ДЕСЯТОК дес, out цел зн )
	{
	return VarI4FromDec( дес, зн);
	}
	
цел БдолВарИзДес(ref ДЕСЯТОК дес, out бдол зн)
	{
	return VarUI8FromDec( дес, зн);
	}
	
цел ДолВарИзДес(ref ДЕСЯТОК дес, out дол зн)
	{	
	return VarI8FromDec( дес, зн);
	}
	
цел ПлавВарИзДес(ref ДЕСЯТОК дес, out плав зн)
	{
	return VarR4FromDec( дес, зн);
	}
	
цел ДвоВарИзДес(ДЕСЯТОК *дес, out дво зн)
	{
	return VarR8FromDec( дес, зн);
	}

	цел ДесВарСложи(ref ДЕСЯТОК дес1, ref ДЕСЯТОК дес2, out ДЕСЯТОК рез)
		{
		return VarDecAdd( дес1,  дес2,  рез);
		}
		
	цел ДесВарОтними(ref ДЕСЯТОК дес1, ref ДЕСЯТОК дес2, out ДЕСЯТОК рез)
		{
		return VarDecSub( дес1,  дес2,  рез);
		}
		
	цел ДесВарУмножь(ref ДЕСЯТОК дес1, ref ДЕСЯТОК дес2, out ДЕСЯТОК рез)
		{
		return VarDecMul( дес1,  дес2,  рез);
		}
		
	цел ДесВарДели(ref ДЕСЯТОК дес1, ref ДЕСЯТОК дес2, out ДЕСЯТОК рез)
		{
		return VarDecDiv( дес1,  дес2,  рез);
		}
		
	цел ДесВарОкругли(ref ДЕСЯТОК дес1, цел дес, out ДЕСЯТОК рез)
	{
	return VarDecRound( дес1, дес,  рез);
	}
	
	цел ДесВарАбс(ref ДЕСЯТОК дес1,  out ДЕСЯТОК рез)
	{
	return VarDecAbs( дес1,  рез);
	}
	
	цел  ДесВарФиксируй(ref ДЕСЯТОК дес1,  out ДЕСЯТОК рез)
	{
	return VarDecFix( дес1,  рез);
	}
	
	цел ДесВарИнт(ref ДЕСЯТОК дес1,  out ДЕСЯТОК рез)
	{
	return VarDecInt( дес1,  рез);
	}

	цел  ДесВарОтриц(ДЕСЯТОК *дес1, out ДЕСЯТОК рез)
	{
	return VarDecNeg( дес1,  рез);
	}
	
	цел ДесВарСравни(ref ДЕСЯТОК дес1, out ДЕСЯТОК рез)
	{
	return VarDecCmp( дес1,  рез);
	}
/*
   
цел VarFormat(ref ВАРИАНТ pvarIn, in шим* pstrFormat, цел iFirstDay, цел iFirstWeek, бцел dwFlags, out шим* pbstrOut);

цел VarFormatFromTokens(ref ВАРИАНТ pvarIn, in шим* pstrFormat, byte* pbTokCur, бцел dwFlags, out шим* pbstrOut, бцел лкид);

цел VarFormatNumber(ref ВАРИАНТ pvarIn, цел iNumDig, цел ilncLead, цел iUseParens, цел iGroup, бцел dwFlags, out шим* pbstrOut);
*/
проц ИницВариант(ref ВАРИАНТ вар){VariantInit( вар);}

цел СотриВариант(ref ВАРИАНТ вар){return cast(цел) VariantClear( вар);}

цел КопируйВариант(ref ВАРИАНТ варгЦель, ref ВАРИАНТ варгИст)
	{
	return cast(цел) VariantCopy( варгЦель,  варгИст);
	}

цел СложиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
    {
	return cast(цел) VarAdd( варЛев,  варПрав,  варРез);
	}
	
цел ИВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarAnd( варЛев,  варПрав,  варРез);
	}
	
цел СоединиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarCat( варЛев,  варПрав,  варРез); 
	}
	
цел ДелиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarDiv( варЛев,  варПрав,  варРез);
	}
	
цел УмножьВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarMul( варЛев,  варПрав,  варРез);
	}
	
цел ИлиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarOr( варЛев,  варПрав,  варРез);
	}
	
цел ОтнимиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarSub( варЛев,  варПрав,  варРез);
	}
	
цел ИИлиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarXor( варЛев,  варПрав,  варРез);
	}
	
цел СравниВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, бцел лкид, бцел флаги)
	{
	return cast(цел) VarCmp( варЛев,  варПрав, cast(бцел) лкид, cast(бцел) флаги);
	}

цел МодВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarMod( варЛев,  варПрав,  варРез);
	}
	
шим* СисРазместиТкст(in шим* ш){return  SysAllocString(ш);}
цел СисПереместиТкст(шим* а, in шим* ш){return  SysReAllocString(а, ш);}
шим* СисРазместиТкстДлин(in шим* ш, бцел длин){return  SysAllocStringLen(ш, длин);}
цел СисПереместиТкстДлин(шим* а, in шим* ш, бцел длин){return  SysReAllocStringLen(а, ш, длин);}
проц СисОсвободиТкст(шим* т){ SysFreeString(т);}
бцел СисТкстДлин(шим* ш){return  SysStringLen(ш);}
бцел СисТкстБайтДлин(шим* т){return  SysStringByteLen(т);}
шим* СисРазместиТкстБайтДлин(in ббайт* ш, бцел длин){return  SysAllocStringByteLen(ш, длин);}

цел УстановиИнфОбОш(бцел резерв, ИИнфОбОш ошинф){return  SetErrorInfo(резерв, ошинф);}
цел ДайИнфОбОш(бцел резерв, ИИнфОбОш ошинф){return  GetErrorInfo(резерв,  ошинф);}
цел СоздайИнфОбОш(out ИИнфОбОш ошинф){return  CreateErrorInfo(ошинф);}


цел ИзмениТипВарианта(ref ВАРИАНТ приёмник, ref ВАРИАНТ источник, ПВар флаги, бкрат вт )
	{
	return  VariantChangeType( приёмник,  источник, cast(бкрат) флаги, вт);
	}
	
цел ИзмениТипВариантаДоп(ref ВАРИАНТ приёмник, ref ВАРИАНТ источник, бцел лкид, ПВар флаги, бкрат вт)
	{
	return  VariantChangeTypeEx( приёмник,  источник, лкид, cast(бкрат) флаги, вт);
	}
	
 ///////нет в импорте 

/*
бул СоздайПроцессПодЛогином(шткст0 имяПользователя, шткст0 домен, шткст0 пароль, бцел логинфлаги, шткст0 назвПрил, шткст0 комстр, ПСозданиеПроцесса флагиСозд, ук среда, шткст0 текПап, ИНФОСТАРТА* инфост, ПРОЦИНФО* процинфо)
	{
	return cast(бул)  CreateProcessWithLogonW( cast(шткст0) имяПользователя, cast(шткст0) домен, cast(шткст0) пароль, cast(бцел) логинфлаги,  cast(шткст0) назвПрил, cast(шткст0) комстр, cast(бцел) флагиСозд,  cast(ук) среда,  cast(шткст0) текПап, cast(LPSTARTUPINFOW) инфост, cast(ИНФОПРОЦ*) процинфо);
	}
*/

бул ДайМаскуСходстваПроцесса(ук процесс,out бцел* маскаПроц, out бцел* маскаСис ){return cast(бул) GetProcessAffinityMask(cast(ук) процесс, cast(бцел*) маскаПроц, cast(бцел*) маскаСис);}
/*
бул ДайРазмерРабочегоНабораПроцесса(){return cast(бул) GetProcessWorkingSetSize(cast(ук), cast(бцел*), cast(бцел*));}

бул УстановиРазмерРабочегоНабораПроцесса(){return cast(бул) SetProcessWorkingSetSize(cast(ук), cast(бцел), cast(бцел));}
*/
ук ОткройПроцесс(ППраваПроцесса желДоступ, бул наследоватьДескр, бцел идПроцесса){return cast(ук) OpenProcess(cast(бцел) желДоступ, cast(бул) наследоватьДескр, cast(бцел) идПроцесса);}

бул ПрервиПроцесс(ук процесс, бцел кодВыхода){return cast(бул) TerminateProcess(cast(ук) процесс, cast(бцел)кодВыхода);}


бул УстановиРежимКонсоли(ук конс, ПРежимКонсоли режим){return cast(бул) SetConsoleMode(cast(ук)  конс, cast(бцел) режим);}

бул ДайРежимКонсоли(ук конс, ПРежимКонсоли режим){return cast(бул) GetConsoleMode(cast(ук) конс, cast(бцел*)режим);}

бул ВозьмиВводВКонсольА(ук ввод, ЗАПВВОДА* буф, бцел длина, бцел* члоСчитанныхСобытий){return cast(бул) PeekConsoleInputA(cast(ук)  ввод, cast(ЗАПИСЬ_ВВОДА*)  буф, cast(бцел) длина, cast(бцел*) члоСчитанныхСобытий);}

бул ВозьмиВводВКонсоль(ук ввод, ЗАПВВОДА* буф, бцел длина, бцел* члоСчитанныхСобытий){return cast(бул) PeekConsoleInputW(cast(ук)  ввод, cast(ЗАПИСЬ_ВВОДА*)  буф, cast(бцел) длина, cast(бцел*) члоСчитанныхСобытий);}

бул ЧитайВводВКонсольА(ук ввод, ЗАПВВОДА* буф, бцел длина, бцел* члоСчитанныхСобытий){return cast(бул) ReadConsoleInputA(cast(ук)  ввод, cast(ЗАПИСЬ_ВВОДА*)  буф, cast(бцел) длина, cast(бцел*) члоСчитанныхСобытий);}

бул ЧитайВводВКонсоль(ук ввод, ЗАПВВОДА* буф, бцел длина, бцел* члоСчитанныхСобытий){return cast(бул) ReadConsoleInputW(cast(ук)  ввод, cast(ЗАПИСЬ_ВВОДА*)  буф, cast(бцел) длина, cast(бцел*) члоСчитанныхСобытий);}

бул ПишиВводВКонсольА(ук ввод, ЗАПВВОДА* буф, бцел длина, бцел* члоСчитанныхСобытий){return cast(бул) WriteConsoleInputA(cast(ук)  ввод, cast(ЗАПИСЬ_ВВОДА*)  буф, cast(бцел) длина, cast(бцел*) члоСчитанныхСобытий);}

бул ПишиВводВКонсоль(ук ввод, ЗАПВВОДА* буф, бцел длина, бцел* члоСчитанныхСобытий){return cast(бул) WriteConsoleInputW(cast(ук)  ввод, cast(ЗАПИСЬ_ВВОДА*)  буф, cast(бцел) длина, cast(бцел*) члоСчитанныхСобытий);}

бул ДайИнфОБуфЭкранаКонсоли(ук консВывод, ИНФОКОНСЭКРБУФ *консЭкрБуфИнфо) {return cast(бул) GetConsoleScreenBufferInfo(cast(ук)консВывод, cast(ИНФОКОНСЭКРБУФ*) консЭкрБуфИнфо);}

бул УстановиАтрибутыТекстаКонсоли(ук конс, ПТекстКонсоли атр ){return cast(бул) SetConsoleTextAttribute(cast(ук) конс, cast(бкрат) атр);}

бул УстановиПозициюКурсораКонсоли(ук конс, КООРД поз) {return cast(бул) SetConsoleCursorPosition(cast(ук) конс,   поз);}

бул ПрокрутиБуферЭкранаКонсолиА(ук конс, in МПРЯМ *прокрПрям, in МПРЯМ *обрПрям, КООРД начПриём, in ИНФОСИМ *зап)
 {
 return cast(бул) ScrollConsoleScreenBufferA(cast(ук)  конс, cast(МПРЯМ*) прокрПрям, cast(МПРЯМ*) обрПрям,   начПриём, cast(ИНФОСИМ*) зап);
 }

бул ПрокрутиБуферЭкранаКонсоли(ук конс, in МПРЯМ *прокрПрям, in МПРЯМ *обрПрям, КООРД начПриём, in ИНФОСИМ *зап)
 {
 return cast(бул) ScrollConsoleScreenBufferW(cast(ук)  конс, cast(МПРЯМ*) прокрПрям, cast(МПРЯМ*) обрПрям,   начПриём,  cast(ИНФОСИМ*) зап);
 }

 бул УстановиКСКонсоли(ПКодСтр кодСтр)
 {return cast(бул) SetConsoleCP( cast(бцел)  кодСтр);}
 ///////нет в импорте
ПКодСтр ДайКСКонсоли()
{return cast(ПКодСтр)  GetConsoleCP();}

ПКодСтр ДайКСВыводаКонсоли()
{return cast(ПКодСтр)  GetConsoleOutputCP();}

бул УстановиКСВыводаКонсоли(ПКодСтр кстр)
{return cast(бул) SetConsoleOutputCP(cast(бцел) кстр);}

бул ОсвободиКонсоль(){return cast(бул) FreeConsole();}

бул УстановиЗагКонсолиА(ткст загКонсоли)
{return cast(бул) SetConsoleTitleA(cast( ткст0)  загКонсоли);}

бул УстановиЗагКонсоли(ткст загКонсоли){return cast(бул) SetConsoleTitleW(toUTF16z(загКонсоли));}

бул УстановиАктивныйБуферКонсоли(ук консВывод){return cast(бул) SetConsoleActiveScreenBuffer(  консВывод);}

бул ОчистиБуферВводаКонсоли(ук консВвод) {return cast(бул) FlushConsoleInputBuffer( консВвод);}

бул УстановиРазмерБуфераЭкранаКонсоли(ук вывод, КООРД размер) {return cast(бул) SetConsoleScreenBufferSize( вывод,  размер);}

бул УстановиИнфОКурсореКонсоли(ук вывод, in ИНФОКОНСКУРСОР *инфо) 
{return cast(бул) SetConsoleCursorInfo(cast(ук)  вывод, cast(ИНФОКОНСКУРСОР *) инфо);}

бул УстановиИнфОбОкнеКонсоли(ук вывод, бул абс, in МПРЯМ *разм)
{return cast(бул) SetConsoleWindowInfo(cast(ук)  вывод, cast(бул) абс, cast(МПРЯМ *) разм);}
/////////////////////\\\\\\\\\\\\\\\\\\\\=
бул  ЧитайКонсольныйВыводА(ук консВывод, ИНФОСИМ* буф, КООРД буфРазм, КООРД буфКоорд, МПРЯМ* регЧтен)
{return cast(бул) ReadConsoleOutputA(cast(ук)  консВывод, cast(ИНФОСИМ*)  буф,   буфРазм,   буфКоорд, cast(МПРЯМ*)  регЧтен);}

бул  ЧитайКонсольныйВывод(ук консВывод, ИНФОСИМ* буф, КООРД буфРазм, КООРД буфКоорд, МПРЯМ* регЧтен)
{return cast(бул) ReadConsoleOutputW(cast(ук)  консВывод, cast(ИНФОСИМ*)  буф,   буфРазм,   буфКоорд, cast(МПРЯМ*)  регЧтен);}

бул ПишиНаВыводКонсолиА(ук консВывод, in ИНФОСИМ *буф, КООРД буфРазм, КООРД буфКоорд, МПРЯМ *регЗап)
{return cast(бул) WriteConsoleOutputA(cast(ук)  консВывод, cast(ИНФОСИМ*) буф,   буфРазм,   буфКоорд, cast(МПРЯМ*)  регЗап);}

бул ПишиНаВыводКонсоли(ук консВывод, in ИНФОСИМ *буф, КООРД буфРазм, КООРД буфКоорд, МПРЯМ *регЗап)
{return cast(бул) WriteConsoleOutputW(cast(ук)  консВывод, cast(ИНФОСИМ*) буф,   буфРазм,   буфКоорд, cast(МПРЯМ*)  регЗап);}

бул ЧитайСимИзВыводаКонсолиА(ук консВывод, сим *симв, бцел длина, КООРД коордЧтен, бцел *члоСчитСим)
{return cast(бул) ReadConsoleOutputCharacterA(cast(ук)  консВывод, cast(ткст0 )  симв, cast(бцел) длина,   коордЧтен, cast(бцел*) члоСчитСим);}

бул ЧитайСимИзВыводаКонсоли(ук консВывод, шим *симв, бцел длина, КООРД коордЧтен, бцел *члоСчитСим)
{return cast(бул) ReadConsoleOutputCharacterW(cast(ук)  консВывод,cast( шткст0)  симв, cast(бцел) длина,   коордЧтен, cast(бцел*) члоСчитСим);}

бул ЧитайАтрибутВыводаКонсоли(ук консВывод, бкрат *атр, бцел длина, КООРД коордЧтен, бцел *члоСчитАтров){return cast(бул) ReadConsoleOutputAttribute(cast(ук)  консВывод, cast( бкрат*)  атр, cast(бцел) длина,   коордЧтен, cast(бцел*) члоСчитАтров);}
/+
бул ПишиАтрибутВыводаКонсоли(ук консВывод, сим *симв, бцел длина, КООРД коордЗап, бцел *члоЗаписанАтров){return cast(бул) WriteConsoleOutputAttribute( консВывод,симв, длина,  коордЗап, члоЗаписанАтров);}

бул АтрибутЗаливкиВыводаКонсоли(ук конс, ПТекстКонсоли атр, бцел длин, КООРД коорд, бцел* члоЗапАтров){return cast(бул) FillConsoleOutputAttribute(cast(ук) конс, cast(бкрат) атр, cast(бцел) длин,  коорд, cast(бцел*) члоЗапАтров);}
+/
/*
{return cast(бул) WriteConsoleOutputCharacterW cast(ук)  консВывод, шткст0 симв, cast(бцел) длина,   коордЗап, cast(бцел*) члоЗаписанАтров);}

{return cast(бул) WriteConsoleOutputAttribute cast(ук)  консВывод, in бкрат *атр, cast(бцел) длина,   коордЗап, cast(бцел*) lpNumberOfAttrsWritten);}

{return cast(бул) FillConsoleOutputCharacterA cast(ук)  консВывод, CHAR cCharacter, cast(бцел)  длина,    коордЗап, cast(бцел*) члоЗаписанАтров);}

{return cast(бул) FillConsoleOutputCharacterW cast(ук)  консВывод, WCHAR cCharacter, cast(бцел)  длина,    коордЗап, cast(бцел*) члоЗаписанАтров);}
{return cast(бул) GetConsoleMode(cast(ук)  hConsoleHandle, cast(бцел*) lpMode);}
{return cast(бул) GetNumberOfConsoleInputEvents(cast(ук)  hConsoleInput, cast(бцел*) lpNumberOfEvents);}
{return cast(бул) GetConsoleScreenBufferInfocast(ук)  консВывод, cast( ИНФОКОНСЭКРБУФ*)  lpConsoleScreenBufferInfo);}
  GetLargestConsoleWindowSize( ук консВывод);}
{return cast(бул) GetConsoleCursorInfocast(ук)  консВывод, cast( ИНФОКОНСКУРСОР*)  lpConsoleCursorInfo);}
{return cast(бул) GetNumberOfConsoleMouseButtons( cast(бцел*) lpNumberOfMouseButtons);}


{return cast(бул) SetConsoleTextAttribute(cast(ук)  консВывод, бкрат wAttributes);}
alias {return cast(бул) function(cast(бцел) CtrlType) PHANDLER_ROUTINE;}
{return cast(бул) SetConsoleCtrlHandler(PHANDLER_ROUTINE HandlerRoutine, {return cast(бул) Add);}
{return cast(бул) GenerateConsoleCtrlEvent( cast(бцел) dwCtrlEvent, cast(бцел) dwProcessGroupId);}
cast(бцел) GetConsoleTitleA(cast(ткст0 )  консТитул, cast(бцел) разм);}
cast(бцел) GetConsoleTitleW(шткст0 консТитул, cast(бцел) разм);}
*/

/**
*ReadConsoleA
*/
бул ЧитайКонсольА(ук консввод, ук буф, бцел члоЧитаемСим, бцел* члоСчитСим, ук резерв)
{
return cast(бул) ReadConsoleA(  консввод,  буф, члоЧитаемСим, члоСчитСим, резерв);
}
/**
*ReadConsoleW
*/
бул ЧитайКонсоль(ук консввод, ук буф, бцел члоЧитаемСим, бцел* члоСчитСим, ук резерв)
{return cast(бул) ReadConsoleW( консввод, буф, члоЧитаемСим, члоСчитСим, резерв);}

/**
*WriteConsoleA
*/
бул ПишиКонсольА(ук консвыв, in  ук буф, бцел члоЗаписываемАтров, бцел* члоЗаписанАтров, ук резерв)
{return cast(бул) WriteConsoleA( консвыв, буф, члоЗаписываемАтров,  члоЗаписанАтров,  резерв);}
/**
*WriteConsoleW
*/
бул ПишиКонсоль(ук консвыв, in  ук буф, бцел члоЗаписываемАтров, бцел* члоЗаписанАтров, ук резерв)

{return cast(бул) WriteConsoleW(консвыв, буф, члоЗаписываемАтров,  члоЗаписанАтров,  резерв);}

 проц ДайИнфоСтарта(ИНФОСТАРТА* ис){GetStartupInfoW( ис);}
 
 
////////////////////////////////////////////////////////////////////////////////////// 
/+
 
extern (Windows)
{


   // alias бцел МАСКА_ДОСТУПА;
    alias МАСКА_ДОСТУПА *PACCESS_MASK;
    alias МАСКА_ДОСТУПА REGSAM;


/+
enum : бцел
{
    MAX_PATH = 260,
    экзANCE_ERROR = 32,
}

+/
enum : бцел
{
    MAILSLOT_NO_MESSAGE = cast(бцел)-1,
    MAILSLOT_WAIT_FOREVER = cast(бцел)-1,
}


/+
struct MEMORYSTATUSEX 
{
  бцел dwLength;
  бцел dwMemoryLoad; 
  DWORDLONG ullTotalPhys; 
  DWORDLONG ullAvailPhys; 
  DWORDLONG ullTotalPageFile;
  DWORDLONG ullAvailPageFile; 
  DWORDLONG ullTotalVirtual;  
  DWORDLONG ullAvailVirtual; 
  DWORDLONG ullAvailExtendedVirtual;
}
alias MEMORYSTATUSEX *LPMEMORYSTATUSEX;

+/


enum
{
    SORT_DEFAULT                   = 0x0,    // sorting default

    SORT_JAPANESE_XJIS             = 0x0,    // Japanese XJIS order
    SORT_JAPANESE_UNICODE          = 0x1,    // Japanese Unicode order

    SORT_CHINESE_BIG5              = 0x0,    // Chinese BIG5 order
    SORT_CHINESE_PRCP              = 0x0,    // PRC Chinese Phonetic order
    SORT_CHINESE_UNICODE           = 0x1,    // Chinese Unicode order
    SORT_CHINESE_PRC               = 0x2,    // PRC Chinese Stroke Count order

    SORT_KOREAN_KSC                = 0x0,    // Корейский KSC order
    SORT_KOREAN_UNICODE            = 0x1,    // Корейский Unicode order

    SORT_GERMAN_PHONE_BOOK         = 0x1,    // German Phone Book order
}

// end_r_winnt

//
//  A language ID is a 16 bit value which is the combination of a
//  primary language ID and a secondary language ID.  The bits are
//  allocated as follows:
//
//       +-----------------------+-------------------------+
//       |     Sublanguage ID    |   Primary Language ID   |
//       +-----------------------+-------------------------+
//        15                   10 9                       0   bit
//
//
//  Language ID creation/extraction macros:
//
//    MAKELANGID    - construct language id from a primary language id and
//                    a sublanguage id.
//    PRIMARYLANGID - extract primary language id from a language id.
//    SUBLANGID     - extract sublanguage id from a language id.
//

цел MAKELANGID(цел p, цел s) { return ((cast(бкрат)s) << 10) | cast(бкрат)p; }
бкрат PRIMARYLANGID(цел lgid) { return cast(бкрат)(lgid & 0x3ff); }
бкрат SUBLANGID(цел lgid)     { return cast(бкрат)(lgid >> 10); }



enum
{
    SIZE_OF_80387_REGISTERS =      80,
//
// The following флаги control the contents of the КОНТЕКСТ structure.
//
    CONTEXT_i386 =    0x00010000,    // this assumes that i386 and
    CONTEXT_i486 =    0x00010000,    // i486 have identical context records

    CONTEXT_CONTROL =         (CONTEXT_i386 | 0x00000001), // SS:SP, CS:IP, FLAGS, BP
    CONTEXT_INTEGER =         (CONTEXT_i386 | 0x00000002), // AX, BX, CX, DX, SI, DI
    CONTEXT_SEGMENTS =        (CONTEXT_i386 | 0x00000004), // DS, ES, FS, GS
    CONTEXT_FLOATING_ТОЧКА =  (CONTEXT_i386 | 0x00000008), // 387 state
    CONTEXT_DEBUG_REGISTERS = (CONTEXT_i386 | 0x00000010), // DB 0-3,6,7

    CONTEXT_FULL = (CONTEXT_CONTROL | CONTEXT_INTEGER | CONTEXT_SEGMENTS),
}

enum
{
    THREAD_BASE_PRIORITY_LOWRT =  15,  // value that gets a thread to LowRealtime-1
    THREAD_BASE_PRIORITY_MAX =    2,   // maximum thread base priority boost
    THREAD_BASE_PRIORITY_MIN =    -2,  // minimum thread base priority boost
    THREAD_BASE_PRIORITY_IDLE =   -15, // value that gets a thread to idle

    THREAD_PRIORITY_LOWEST =          THREAD_BASE_PRIORITY_MIN,
    THREAD_PRIORITY_BELOW_NORMAL =    (THREAD_PRIORITY_LOWEST+1),
    THREAD_PRIORITY_NORMAL =          0,
    THREAD_PRIORITY_HIGHEST =         THREAD_BASE_PRIORITY_MAX,
    THREAD_PRIORITY_ABOVE_NORMAL =    (THREAD_PRIORITY_HIGHEST-1),
    THREAD_PRIORITY_ERROR_RETURN =    цел.max,

    THREAD_PRIORITY_TIME_CRITICAL =   THREAD_BASE_PRIORITY_LOWRT,
    THREAD_PRIORITY_IDLE =            THREAD_BASE_PRIORITY_IDLE,
}


// Synchronization

enum
{
    WM_NOTIFY =                       0x004E,
    WM_INPUTLANGCHANGEREQUEST =       0x0050,
    WM_INPUTLANGCHANGE =              0x0051,
    WM_TCARD =                        0x0052,
    WM_HELP =                         0x0053,
    WM_USERCHANGED =                  0x0054,
    WM_NOTIFYFORMAT =                 0x0055,

    NFR_ANSI =                             1,
    NFR_UNICODE =                          2,
    NF_QUERY =                             3,
    NF_REQUERY =                           4,

    WM_CONTEXTMENU =                  0x007B,
    WM_STYLECHANGING =                0x007C,
    WM_STYLECHANGED =                 0x007D,
    WM_DISPLAYCHANGE =                0x007E,
    WM_GETICON =                      0x007F,
    WM_SETICON =                      0x0080,



    WM_NCCREATE =                     0x0081,
    WM_NCDESTROY =                    0x0082,
    WM_NCCALCSIZE =                   0x0083,
    WM_NCHITTEST =                    0x0084,
    WM_NCPAINT =                      0x0085,
    WM_NCACTIVATE =                   0x0086,
    WM_GETDLGCODE =                   0x0087,

    WM_NCMOUSEMOVE =                  0x00A0,
    WM_NCLBUTTONDOWN =                0x00A1,
    WM_NCLBUTTONUP =                  0x00A2,
    WM_NCLBUTTONDBLCLK =              0x00A3,
    WM_NCRBUTTONDOWN =                0x00A4,
    WM_NCRBUTTONUP =                  0x00A5,
    WM_NCRBUTTONDBLCLK =              0x00A6,
    WM_NCMBUTTONDOWN =                0x00A7,
    WM_NCMBUTTONUP =                  0x00A8,
    WM_NCMBUTTONDBLCLK =              0x00A9,

    WM_KEYFIRST =                     0x0100,
    WM_KEYDOWN =                      0x0100,
    WM_KEYUP =                        0x0101,
    WM_CHAR =                         0x0102,
    WM_DEADCHAR =                     0x0103,
    WM_SYSKEYDOWN =                   0x0104,
    WM_SYSKEYUP =                     0x0105,
    WM_SYSCHAR =                      0x0106,
    WM_SYSDEADCHAR =                  0x0107,
    WM_KEYLAST =                      0x0108,


    WM_IME_STARTCOMPOSITION =         0x010D,
    WM_IME_ENDCOMPOSITION =           0x010E,
    WM_IME_COMPOSITION =              0x010F,
    WM_IME_KEYLAST =                  0x010F,


    WM_INITDIALOG =                   0x0110,
    WM_COMMAND =                      0x0111,
    WM_SYSCOMMAND =                   0x0112,
    WM_TIMER =                        0x0113,
    WM_HSCROLL =                      0x0114,
    WM_VSCROLL =                      0x0115,
    WM_INITMENU =                     0x0116,
    WM_INITMENUPOPUP =                0x0117,
    WM_MENUSELECT =                   0x011F,
    WM_MENUCHAR =                     0x0120,
    WM_ENTERIDLE =                    0x0121,

    WM_CTLCOLORMSGBOX =               0x0132,
    WM_CTLCOLOREDIT =                 0x0133,
    WM_CTLCOLORLISTBOX =              0x0134,
    WM_CTLCOLORBTN =                  0x0135,
    WM_CTLCOLORDLG =                  0x0136,
    WM_CTLCOLORSCROLLBAR =            0x0137,
    WM_CTLCOLORSTATIC =               0x0138,



    WM_MOUSEFIRST =                   0x0200,
    WM_MOUSEMOVE =                    0x0200,
    WM_LBUTTONDOWN =                  0x0201,
    WM_LBUTTONUP =                    0x0202,
    WM_LBUTTONDBLCLK =                0x0203,
    WM_RBUTTONDOWN =                  0x0204,
    WM_RBUTTONUP =                    0x0205,
    WM_RBUTTONDBLCLK =                0x0206,
    WM_MBUTTONDOWN =                  0x0207,
    WM_MBUTTONUP =                    0x0208,
    WM_MBUTTONDBLCLK =                0x0209,



    WM_MOUSELAST =                    0x0209,








    WM_PARENTNOTIFY =                 0x0210,
    MENULOOP_WINDOW =                 0,
    MENULOOP_POPUP =                  1,
    WM_ENTERMENULOOP =                0x0211,
    WM_EXITMENULOOP =                 0x0212,


    WM_NEXTMENU =                     0x0213,
}

enum
{
/*
 * Dialog Box Command IDs
 */
    IDOK =                1,
    IDCANCEL =            2,
    IDABORT =             3,
    IDRETRY =             4,
    IDIGNORE =            5,
    IDYES =               6,
    IDNO =                7,

    IDCLOSE =         8,
    IDHELP =          9,


// end_r_winuser



/*
 * Control Manager Structures and Definitions
 */



// begin_r_winuser

/*
 * Edit Control Styles
 */
    ES_LEFT =             0x0000,
    ES_CENTER =           0x0001,
    ES_RIGHT =            0x0002,
    ES_MULTILINE =        0x0004,
    ES_UPPERCASE =        0x0008,
    ES_LOWERCASE =        0x0010,
    ES_PASSWORD =         0x0020,
    ES_AUTOVSCROLL =      0x0040,
    ES_AUTOHSCROLL =      0x0080,
    ES_NOHIDESEL =        0x0100,
    ES_OEMCONVERT =       0x0400,
    ES_READONLY =         0x0800,
    ES_WANTRETURN =       0x1000,

    ES_NUMBER =           0x2000,


// end_r_winuser



/*
 * Edit Control Notification Codes
 */
    EN_SETFOCUS =         0x0100,
    EN_KILLFOCUS =        0x0200,
    EN_CHANGE =           0x0300,
    EN_UPDATE =           0x0400,
    EN_ERRSPACE =         0x0500,
    EN_MAXTEXT =          0x0501,
    EN_HSCROLL =          0x0601,
    EN_VSCROLL =          0x0602,


/* Edit control EM_SETMARGIN parameters */
    EC_LEFTMARGIN =       0x0001,
    EC_RIGHTMARGIN =      0x0002,
    EC_USEFONTINFO =      0xffff,




// begin_r_winuser

/*
 * Edit Control Messages
 */
    EM_GETSEL =               0x00B0,
    EM_SETSEL =               0x00B1,
    EM_GETRECT =              0x00B2,
    EM_SETRECT =              0x00B3,
    EM_SETRECTNP =            0x00B4,
    EM_SCROLL =               0x00B5,
    EM_LINESCROLL =           0x00B6,
    EM_SCROLLCARET =          0x00B7,
    EM_GETMODIFY =            0x00B8,
    EM_SETMODIFY =            0x00B9,
    EM_GETLINECOUNT =         0x00BA,
    EM_LINEINDEX =            0x00BB,
    EM_SETHANDLE =            0x00BC,
    EM_GETHANDLE =            0x00BD,
    EM_GETTHUMB =             0x00BE,
    EM_LINELENGTH =           0x00C1,
    EM_REPLACESEL =           0x00C2,
    EM_GETLINE =              0x00C4,
    EM_LIMITTEXT =            0x00C5,
    EM_CANUNDO =              0x00C6,
    EM_UNDO =                 0x00C7,
    EM_FMTLINES =             0x00C8,
    EM_LINEFROMCHAR =         0x00C9,
    EM_SETTABSTOPS =          0x00CB,
    EM_SETPASSWORDCHAR =      0x00CC,
    EM_EMPTYUNDOBUFFER =      0x00CD,
    EM_GETFIRSTVISIBLELINE =  0x00CE,
    EM_SETREADONLY =          0x00CF,
    EM_SETWORDBREAKPROC =     0x00D0,
    EM_GETWORDBREAKPROC =     0x00D1,
    EM_GETPASSWORDCHAR =      0x00D2,

    EM_SETMARGINS =           0x00D3,
    EM_GETMARGINS =           0x00D4,
    EM_SETLIMITTEXT =         EM_LIMITTEXT, /* ;win40 Name change */
    EM_GETLIMITTEXT =         0x00D5,
    EM_POSFROMCHAR =          0x00D6,
    EM_CHARFROMPOS =          0x00D7,



// end_r_winuser


/*
 * EDITWORDBREAKPROC code values
 */
    WB_LEFT =            0,
    WB_RIGHT =           1,
    WB_ISDELIMITER =     2,

// begin_r_winuser

/*
 * Button Control Styles
 */
    BS_PUSHBUTTON =       0x00000000,
    BS_DEFPUSHBUTTON =    0x00000001,
    BS_CHECKBOX =         0x00000002,
    BS_AUTOCHECKBOX =     0x00000003,
    BS_RADIOBUTTON =      0x00000004,
    BS_3STATE =           0x00000005,
    BS_AUTO3STATE =       0x00000006,
    BS_GROUPBOX =         0x00000007,
    BS_USERBUTTON =       0x00000008,
    BS_AUTORADIOBUTTON =  0x00000009,
    BS_OWNERDRAW =        0x0000000B,
    BS_LEFTTEXT =         0x00000020,

    BS_TEXT =             0x00000000,
    BS_ICON =             0x00000040,
    BS_BITMAP =           0x00000080,
    BS_LEFT =             0x00000100,
    BS_RIGHT =            0x00000200,
    BS_CENTER =           0x00000300,
    BS_TOP =              0x00000400,
    BS_BOTTOM =           0x00000800,
    BS_VCENTER =          0x00000C00,
    BS_PUSHLIKE =         0x00001000,
    BS_MULTILINE =        0x00002000,
    BS_NOTIFY =           0x00004000,
    BS_FLAT =             0x00008000,
    BS_RIGHTBUTTON =      BS_LEFTTEXT,



/*
 * User Button Notification Codes
 */
    BN_CLICKED =          0,
    BN_PAINT =            1,
    BN_HILITE =           2,
    BN_UNHILITE =         3,
    BN_DISABLE =          4,
    BN_DOUBLECLICKED =    5,

    BN_PUSHED =           BN_HILITE,
    BN_UNPUSHED =         BN_UNHILITE,
    BN_DBLCLK =           BN_DOUBLECLICKED,
    BN_SETFOCUS =         6,
    BN_KILLFOCUS =        7,

/*
 * Button Control Messages
 */
    BM_GETCHECK =        0x00F0,
    BM_SETCHECK =        0x00F1,
    BM_GETSTATE =        0x00F2,
    BM_SETSTATE =        0x00F3,
    BM_SETSTYLE =        0x00F4,

    BM_CLICK =           0x00F5,
    BM_GETIMAGE =        0x00F6,
    BM_SETIMAGE =        0x00F7,

    BST_UNCHECKED =      0x0000,
    BST_CHECKED =        0x0001,
    BST_INDETERMINATE =  0x0002,
    BST_PUSHED =         0x0004,
    BST_FOCUS =          0x0008,


/*
 * Static Control Constants
 */
    SS_LEFT =             0x00000000,
    SS_CENTER =           0x00000001,
    SS_RIGHT =            0x00000002,
    SS_ICON =             0x00000003,
    SS_BLACKRECT =        0x00000004,
    SS_GRAYRECT =         0x00000005,
    SS_WHITERECT =        0x00000006,
    SS_BLACKFRAME =       0x00000007,
    SS_GRAYFRAME =        0x00000008,
    SS_WHITEFRAME =       0x00000009,
    SS_USERITEM =         0x0000000A,
    SS_SIMPLE =           0x0000000B,
    SS_LEFTNOWORDWRAP =   0x0000000C,

    SS_OWNERDRAW =        0x0000000D,
    SS_BITMAP =           0x0000000E,
    SS_ENHMETAFILE =      0x0000000F,
    SS_ETCHEDHORZ =       0x00000010,
    SS_ETCHEDVERT =       0x00000011,
    SS_ETCHEDFRAME =      0x00000012,
    SS_TYPEMASK =         0x0000001F,

    SS_NOPREFIX =         0x00000080, /* Don't do "&" character translation */

    SS_NOTIFY =           0x00000100,
    SS_CENTERIMAGE =      0x00000200,
    SS_RIGHTJUST =        0x00000400,
    SS_REALSIZEIMAGE =    0x00000800,
    SS_SUNKEN =           0x00001000,
    SS_ENDELLIPSIS =      0x00004000,
    SS_PATHELLIPSIS =     0x00008000,
    SS_WORDELLIPSIS =     0x0000C000,
    SS_ELLIPSISMASK =     0x0000C000,


// end_r_winuser


/*
 * Static Control Mesages
 */
    STM_SETICON =         0x0170,
    STM_GETICON =         0x0171,

    STM_SETIMAGE =        0x0172,
    STM_GETIMAGE =        0x0173,
    STN_CLICKED =         0,
    STN_DBLCLK =          1,
    STN_ENABLE =          2,
    STN_DISABLE =         3,

    STM_MSGMAX =          0x0174,
}


enum
{
/*
 * Window Messages
 */

    WM_NULL =                         0x0000,
    WM_CREATE =                       0x0001,
    WM_DESTROY =                      0x0002,
    WM_MOVE =                         0x0003,
    WM_SIZE =                         0x0005,

    WM_ACTIVATE =                     0x0006,
/*
 * WM_ACTIVATE state values
 */
    WA_INACTIVE =     0,
    WA_ACTIVE =       1,
    WA_CLICKACTIVE =  2,

    WM_SETFOCUS =                     0x0007,
    WM_KILLFOCUS =                    0x0008,
    WM_ENABLE =                       0x000A,
    WM_SETREDRAW =                    0x000B,
    WM_SETTEXT =                      0x000C,
    WM_GETTEXT =                      0x000D,
    WM_GETTEXTLENGTH =                0x000E,
    WM_PAINT =                        0x000F,
    WM_CLOSE =                        0x0010,
    WM_QUERYENDSESSION =              0x0011,
    WM_QUIT =                         0x0012,
    WM_QUERYOPEN =                    0x0013,
    WM_ERASEBKGND =                   0x0014,
    WM_SYSCOLORCHANGE =               0x0015,
    WM_ENDSESSION =                   0x0016,
    WM_SHOWWINDOW =                   0x0018,
    WM_WININICHANGE =                 0x001A,

    WM_SETTINGCHANGE =                WM_WININICHANGE,



    WM_DEVMODECHANGE =                0x001B,
    WM_ACTIVATEAPP =                  0x001C,
    WM_FONTCHANGE =                   0x001D,
    WM_TIMECHANGE =                   0x001E,
    WM_CANCELMODE =                   0x001F,
    WM_SETCURSOR =                    0x0020,
    WM_MOUSEACTIVATE =                0x0021,
    WM_CHILDACTIVATE =                0x0022,
    WM_QUEUESYNC =                    0x0023,

    WM_GETMINMAXINFO =                0x0024,
}


// флаги for RedrawWindow()
enum
{
    RDW_INVALIDATE =          0x0001,
    RDW_INTERNALPAINT =       0x0002,
    RDW_ERASE =               0x0004,
    RDW_VALIDATE =            0x0008,
    RDW_NOINTERNALPAINT =     0x0010,
    RDW_NOERASE =             0x0020,
    RDW_NOCHILDREN =          0x0040,
    RDW_ALLCHILDREN =         0x0080,
    RDW_UPDATENOW =           0x0100,
    RDW_ERASENOW =            0x0200,
    RDW_FRAME =               0x0400,
    RDW_NOFRAME =             0x0800,
}


enum
{
    OUT_DEFAULT_PRECIS =          0,
    OUT_STRING_PRECIS =           1,
    OUT_CHARACTER_PRECIS =        2,
    OUT_STROKE_PRECIS =           3,
    OUT_TT_PRECIS =               4,
    OUT_DEVICE_PRECIS =           5,
    OUT_RASTER_PRECIS =           6,
    OUT_TT_ONLY_PRECIS =          7,
    OUT_OUTLINE_PRECIS =          8,
    OUT_SCREEN_OUTLINE_PRECIS =   9,

    CLIP_DEFAULT_PRECIS =     0,
    CLIP_CHARACTER_PRECIS =   1,
    CLIP_STROKE_PRECIS =      2,
    CLIP_MASK =               0xf,
    CLIP_LH_ANGLES =          (1<<4),
    CLIP_TT_ALWAYS =          (2<<4),
    CLIP_EMBEDDED =           (8<<4),

    DEFAULT_QUALITY =         0,
    DRAFT_QUALITY =           1,
    PROOF_QUALITY =           2,

    NONANTIALIASED_QUALITY =  3,
    ANTIALIASED_QUALITY =     4,


    DEFAULT_PITCH =           0,
    FIXED_PITCH =             1,
    VARIABLE_PITCH =          2,

    MONO_FONT =               8,


    ANSI_CHARSET =            0,
    DEFAULT_CHARSET =         1,
    SYMBOL_CHARSET =          2,
    ШИФТJIS_CHARSET =        128,
    HANGEUL_CHARSET =         129,
    GB2312_CHARSET =          134,
    CHINESEBIG5_CHARSET =     136,
    OEM_CHARSET =             255,

    JOHAB_CHARSET =           130,
    HEBREW_CHARSET =          177,
    ARABIC_CHARSET =          178,
    GREEK_CHARSET =           161,
    TURKISH_CHARSET =         162,
    VIETNAMESE_CHARSET =      163,
    THAI_CHARSET =            222,
    EASTEUROPE_CHARSET =      238,
    RUSSIAN_CHARSET =         204,

    MAC_CHARSET =             77,
    BALTIC_CHARSET =          186,

    FS_LATIN1 =               0x00000001L,
    FS_LATIN2 =               0x00000002L,
    FS_CYRILLIC =             0x00000004L,
    FS_GREEK =                0x00000008L,
    FS_TURKISH =              0x00000010L,
    FS_HEBREW =               0x00000020L,
    FS_ARABIC =               0x00000040L,
    FS_BALTIC =               0x00000080L,
    FS_VIETNAMESE =           0x00000100L,
    FS_THAI =                 0x00010000L,
    FS_JISJAPAN =             0x00020000L,
    FS_CHINESESIMP =          0x00040000L,
    FS_WANSUNG =              0x00080000L,
    FS_CHINESETRAD =          0x00100000L,
    FS_JOHAB =                0x00200000L,
    FS_SYMBOL =               cast(цел)0x80000000L,


/* Font Families */
    FF_DONTCARE =         (0<<4), /* Don't care or don't know. */
    FF_ROMAN =            (1<<4), /* Variable stroke ширина, serifed. */
                                    /* Times Roman, Century Schoolbook, etc. */
    FF_SWISS =            (2<<4), /* Variable stroke ширина, sans-serifed. */
                                    /* Helvetica, Swiss, etc. */
    FF_MODERN =           (3<<4), /* Constant stroke ширина, serifed or sans-serifed. */
                                    /* Pica, Elite, Courier, etc. */
    FF_SCRIPT =           (4<<4), /* Cursive, etc. */
    FF_DECORATIVE =       (5<<4), /* Old English, etc. */

/* Font Weights */
    FW_DONTCARE =         0,
    FW_THIN =             100,
    FW_EXTRALIGHT =       200,
    FW_LIGHT =            300,
    FW_NORMAL =           400,
    FW_MEDIUM =           500,
    FW_SEMIBOLD =         600,
    FW_BOLD =             700,
    FW_EXTRABOLD =        800,
    FW_HEAVY =            900,

    FW_ULTRALIGHT =       FW_EXTRALIGHT,
    FW_REGULAR =          FW_NORMAL,
    FW_DEMIBOLD =         FW_SEMIBOLD,
    FW_ULTRABOLD =        FW_EXTRABOLD,
    FW_BLACK =            FW_HEAVY,

    PANOSE_COUNT =               10,
    PAN_FAMILYTYPE_INDEX =        0,
    PAN_SERIFSTYLE_INDEX =        1,
    PAN_WEIGHT_INDEX =            2,
    PAN_PROPORTION_INDEX =        3,
    PAN_CONTRAST_INDEX =          4,
    PAN_STROKEVARIATION_INDEX =   5,
    PAN_ARMSTYLE_INDEX =          6,
    PAN_LETTERFORM_INDEX =        7,
    PAN_MIDLINE_INDEX =           8,
    PAN_XHEIGHT_INDEX =           9,

    PAN_CULTURE_LATIN =           0,
}


/* Text Alignment Options */
enum
{
    TA_NOUPDATECP =                0,
    TA_UPDATECP =                  1,

    TA_LEFT =                      0,
    TA_RIGHT =                     2,
    TA_CENTER =                    6,

    TA_TOP =                       0,
    TA_BOTTOM =                    8,
    TA_BASELINE =                  24,

    TA_RTLREADING =                256,
    TA_MASK =       (TA_BASELINE+TA_CENTER+TA_UPDATECP+TA_RTLREADING),
}


/*
 * Window Styles
 */
enum : бцел
{
    WS_OVERLAPPED =       0x00000000,
    WS_POPUP =            0x80000000,
    WS_CHILD =            0x40000000,
    WS_MINIMIZE =         0x20000000,
    WS_VISIBLE =          0x10000000,
    WS_DISABLED =         0x08000000,
    WS_CLIPSIBLINGS =     0x04000000,
    WS_CLIPCHILDREN =     0x02000000,
    WS_MAXIMIZE =         0x01000000,
    WS_CAPTION =          0x00C00000,  /* WS_BORDER | WS_DLGFRAME  */
    WS_BORDER =           0x00800000,
    WS_DLGFRAME =         0x00400000,
    WS_VSCROLL =          0x00200000,
    WS_HSCROLL =          0x00100000,
    WS_SYSMENU =          0x00080000,
    WS_THICKFRAME =       0x00040000,
    WS_GROUP =            0x00020000,
    WS_TABSTOP =          0x00010000,

    WS_MINIMIZEBOX =      0x00020000,
    WS_MAXIMIZEBOX =      0x00010000,

    WS_TILED =            WS_OVERLAPPED,
    WS_ICONIC =           WS_MINIMIZE,
    WS_SIZEBOX =          WS_THICKFRAME,

/*
 * Common Window Styles
 */
    WS_OVERLAPPEDWINDOW = (WS_OVERLAPPED |            WS_CAPTION |  WS_SYSMENU |  WS_THICKFRAME |            WS_MINIMIZEBOX |                 WS_MAXIMIZEBOX),
    WS_TILEDWINDOW =      WS_OVERLAPPEDWINDOW,
    WS_POPUPWINDOW =      (WS_POPUP |  WS_BORDER |  WS_SYSMENU),
    WS_CHILDWINDOW =      (WS_CHILD),
}

/*
 * Класс styles
 */
enum
{
    CS_VREDRAW =          0x0001,
    CS_HREDRAW =          0x0002,
    CS_KEYCVTWINDOW =     0x0004,
    CS_DBLCLKS =          0x0008,
    CS_OWNDC =            0x0020,
    CS_CLASSDC =          0x0040,
    CS_PARENTDC =         0x0080,
    CS_NOKEYCVT =         0x0100,
    CS_NOCLOSE =          0x0200,
    CS_SAVEBITS =         0x0800,
    CS_BYTEALIGNCLIENT =  0x1000,
    CS_BYTEALIGNWINDOW =  0x2000,
    CS_GLOBALCLASS =      0x4000,


    CS_IME =              0x00010000,
}


const ткст0  IDI_APPLICATION =     cast(ткст0 )(32512);

const ткст0  IDC_ARROW =           cast(ткст0 )(32512);
const ткст0  IDC_CROSS =           cast(ткст0 )(32515);



/*
 * Color Types
 */

const CTLCOLOR_MSGBOX =         0;
const CTLCOLOR_EDIT =           1;
const CTLCOLOR_LISTBOX =        2;
const CTLCOLOR_BTN =            3;
const CTLCOLOR_DLG =            4;
const CTLCOLOR_SCROLLBAR =      5;
const CTLCOLOR_STATIC =         6;
const CTLCOLOR_MAX =            7;

const COLOR_SCROLLBAR =         0;
const COLOR_BACKGROUND =        1;
const COLOR_ACTIVECAPTION =     2;
const COLOR_INACTIVECAPTION =   3;
const COLOR_MENU =              4;
const COLOR_WINDOW =            5;
const COLOR_WINDOWFRAME =       6;
const COLOR_MENUTEXT =          7;
const COLOR_WINDOWTEXT =        8;
const COLOR_CAPTIONTEXT =       9;
const COLOR_ACTIVEBORDER =      10;
const COLOR_INACTIVEBORDER =    11;
const COLOR_APPWORKSPACE =      12;
const COLOR_HIGHLIGHT =         13;
const COLOR_HIGHLIGHTTEXT =     14;
const COLOR_BTNFACE =           15;
const COLOR_BTNSHADOW =         16;
const COLOR_GRAYTEXT =          17;
const COLOR_BTNTEXT =           18;
const COLOR_INACTIVECAPTIONTEXT = 19;
const COLOR_BTNHIGHLIGHT =      20;


const COLOR_3DDKSHADOW =        21;
const COLOR_3DLIGHT =           22;
const COLOR_INFOTEXT =          23;
const COLOR_INFOBK =            24;

const COLOR_DESKTOP =       COLOR_BACKGROUND;
const COLOR_3DFACE =            COLOR_BTNFACE;
const COLOR_3DSHADOW =          COLOR_BTNSHADOW;
const COLOR_3DHIGHLIGHT =       COLOR_BTNHIGHLIGHT;
const COLOR_3DHILIGHT =         COLOR_BTNHIGHLIGHT;
const COLOR_BTNHILIGHT =        COLOR_BTNHIGHLIGHT;


enum : цел
{
    CW_USEDEFAULT = cast(цел)0x80000000
}

/*
 * Special value for CreateWindow, et al.
 */
const УОК  УОК_DESKTOP = cast(УОК)0;

extern (Windows) АТОМ RegisterClassA(WNDCLASSA *lpWndClass);

extern (Windows) УОК CreateWindowExA(
    бцел dwExStyle,
    ткст0 lpClassName,
    ткст0 lpWindowName,
    бцел dwStyle,
    цел X,
    цел Y,
    цел nWidth,
    цел nHeight,
    УОК hWndParent ,
    HMENU hMenu,
    экз hInstance,
    ук lpParam);


УОК CreateWindowA(
    ткст0 lpClassName,
    ткст0 lpWindowName,
    бцел dwStyle,
    цел X,
    цел Y,
    цел nWidth,
    цел nHeight,
    УОК hWndParent ,
    HMENU hMenu,
    экз hInstance,
    ук lpParam)
{
    return CreateWindowExA(0, lpClassName, lpWindowName, dwStyle, X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam);
}


extern (Windows)
{
 бул GetMessageA(СООБ* lpMsg, УОК окно, бцел wMsgFilterMin, бцел wMsgFilterMax);
 бул TranslateMessage(СООБ *lpMsg);
 цел DispatchMessageA(СООБ *lpMsg);
 бул PeekMessageA(СООБ *lpMsg, УОК окно, бцел wMsgFilterMin, бцел wMsgFilterMax, бцел wRemoveMsg);
 УОК GetFocus();
}

extern (Windows) бцел ExpandEnvironmentStringsA(ткст0 lpSrc, ткст0  lpDst, бцел разм);

extern (Windows)
{

 /* Stock Logical Objects */
enum
{   WHITE_BRUSH =         0,
    LTGRAY_BRUSH =        1,
    GRAY_BRUSH =          2,
    DKGRAY_BRUSH =        3,
    BLACK_BRUSH =         4,
    NULL_BRUSH =          5,
    HOLLOW_BRUSH =        NULL_BRUSH,
    WHITE_PEN =           6,
    BLACK_PEN =           7,
    NULL_PEN =            8,
    OEM_FIXED_FONT =      10,
    ANSI_FIXED_FONT =     11,
    ANSI_VAR_FONT =       12,
    SYSTEM_FONT =         13,
    DEVICE_DEFAULT_FONT = 14,
    DEFAULT_PALETTE =     15,
    SYSTEM_FIXED_FONT =   16,
    DEFAULT_GUI_FONT =    17,
    STOCK_LAST =          17,
}

/*
 * ShowWindow() Commands
 */
enum
{   SW_HIDE =             0,
    SW_SHOWNORMAL =       1,
    SW_NORMAL =           1,
    SW_SHOWMINIMIZED =    2,
    SW_SHOWMAXIMIZED =    3,
    SW_MAXIMIZE =         3,
    SW_SHOWNOACTIVATE =   4,
    SW_SHOW =             5,
    SW_MINIMIZE =         6,
    SW_SHOWMINNOACTIVE =  7,
    SW_SHOWNA =           8,
    SW_RESTORE =          9,
    SW_SHOWDEFAULT =      10,
    SW_MAX =              10,
}


бул   GetTextMetricsA(HDC, МЕТРИКА_ТЕКСТА*);

/*
 * Scroll Bar Constants
 */
enum
{   SB_HORZ =             0,
    SB_VERT =             1,
    SB_CTL =              2,
    SB_BOTH =             3,
}

/*
 * Scroll Bar Commands
 */
enum
{   SB_LINEUP =           0,
    SB_LINELEFT =         0,
    SB_LINEDOWN =         1,
    SB_LINERIGHT =        1,
    SB_PAGEUP =           2,
    SB_PAGELEFT =         2,
    SB_PAGEDOWN =         3,
    SB_PAGERIGHT =        3,
    SB_THUMBPOSITION =    4,
    SB_THUMBTRACK =       5,
    SB_TOP =              6,
    SB_LEFT =             6,
    SB_BOTTOM =           7,
    SB_RIGHT =            7,
    SB_ENDSCROLL =        8,
}

/*
 * Virtual Keys, Standard Set
 */
enum
{   VK_LBUTTON =        0x01,
    VK_RBUTTON =        0x02,
    VK_CANCEL =         0x03,
    VK_MBUTTON =        0x04, /* NOT contiguous with L & RBUTTON */

    VK_BACK =           0x08,
    VK_TAB =            0x09,

    VK_CLEAR =          0x0C,
    VK_RETURN =         0x0D,

    VK_ШИФТ =          0x10,
    VK_CONTROL =        0x11,
    VK_MENU =           0x12,
    VK_PAUSE =          0x13,
    VK_CAPITAL =        0x14,


    VK_ESCAPE =         0x1B,

    VK_SPACE =          0x20,
    VK_PRIOR =          0x21,
    VK_NEXT =           0x22,
    VK_END =            0x23,
    VK_HOME =           0x24,
    VK_LEFT =           0x25,
    VK_UP =             0x26,
    VK_RIGHT =          0x27,
    VK_DOWN =           0x28,
    VK_SELECT =         0x29,
    VK_PRINT =          0x2A,
    VK_EXECUTE =        0x2B,
    VK_SNAPSHOT =       0x2C,
    VK_INSERT =         0x2D,
    VK_DELETE =         0x2E,
    VK_HELP =           0x2F,

/* VK_0 thru VK_9 are the same as ASCII '0' thru '9' (0x30 - 0x39) */
/* VK_A thru VK_Z are the same as ASCII 'A' thru 'Z' (0x41 - 0x5A) */

    VK_LWIN =           0x5B,
    VK_RWIN =           0x5C,
    VK_APPS =           0x5D,

    VK_NUMPAD0 =        0x60,
    VK_NUMPAD1 =        0x61,
    VK_NUMPAD2 =        0x62,
    VK_NUMPAD3 =        0x63,
    VK_NUMPAD4 =        0x64,
    VK_NUMPAD5 =        0x65,
    VK_NUMPAD6 =        0x66,
    VK_NUMPAD7 =        0x67,
    VK_NUMPAD8 =        0x68,
    VK_NUMPAD9 =        0x69,
    VK_MULTIPLY =       0x6A,
    VK_ADD =            0x6B,
    VK_SEPARATOR =      0x6C,
    VK_SUBTRACT =       0x6D,
    VK_DECIMAL =        0x6E,
    VK_DIVIDE =         0x6F,
    VK_F1 =             0x70,
    VK_F2 =             0x71,
    VK_F3 =             0x72,
    VK_F4 =             0x73,
    VK_F5 =             0x74,
    VK_F6 =             0x75,
    VK_F7 =             0x76,
    VK_F8 =             0x77,
    VK_F9 =             0x78,
    VK_F10 =            0x79,
    VK_F11 =            0x7A,
    VK_F12 =            0x7B,
    VK_F13 =            0x7C,
    VK_F14 =            0x7D,
    VK_F15 =            0x7E,
    VK_F16 =            0x7F,
    VK_F17 =            0x80,
    VK_F18 =            0x81,
    VK_F19 =            0x82,
    VK_F20 =            0x83,
    VK_F21 =            0x84,
    VK_F22 =            0x85,
    VK_F23 =            0x86,
    VK_F24 =            0x87,

    VK_NUMLOCK =        0x90,
    VK_SCROLL =         0x91,

/*
 * VK_L* & VK_R* - left and right Alt, Ctrl and Shift virtual keys.
 * Used only as parameters to GetAsyncKeyState() and GetKeyState().
 * No other API or message will distinguish left and right keys in this way.
 */
    VK_LШИФТ =         0xA0,
    VK_RШИФТ =         0xA1,
    VK_LCONTROL =       0xA2,
    VK_RCONTROL =       0xA3,
    VK_LMENU =          0xA4,
    VK_RMENU =          0xA5,


    VK_PROCESSKEY =     0xE5,


    VK_ATTN =           0xF6,
    VK_CRSEL =          0xF7,
    VK_EXSEL =          0xF8,
    VK_EREOF =          0xF9,
    VK_PLAY =           0xFA,
    VK_ZOOM =           0xFB,
    VK_NONAME =         0xFC,
    VK_PA1 =            0xFD,
    VK_OEM_CLEAR =      0xFE,
}

enum
{
    PM_NOREMOVE =         0x0000,
    PM_REMOVE =           0x0001,
    PM_NOYIELD =          0x0002,
}



extern (Windows) HMENU LoadMenuA(экз hInstance, ткст0 lpMenuName);
extern (Windows) HMENU LoadMenuW(экз hInstance, шткст0 lpMenuName);

extern (Windows) HMENU GetSubMenu(HMENU hMenu, цел nPos);

extern (Windows) УБитмап LoadBitmapA(экз hInstance, ткст0 lpBitmapName);
extern (Windows) УБитмап LoadBitmapW(экз hInstance, шткст0 lpBitmapName);

ткст0  MAKEINTRESOURCEA(цел i) { return cast(ткст0 )(cast(бцел)(cast(бкрат)(i))); }

HFONT     CreateFontIndirectA(LOGFONTA *);

extern (Windows) бул MessageBeep(бцел uType);
extern (Windows) цел ShowCursor(бул bShow);
extern (Windows) бул SetCursorPos(цел X, цел Y);
extern (Windows) HCURSOR SetCursor(HCURSOR hCursor);
extern (Windows) бул GetCursorPos(ТОЧКА* lpPoцел);
extern (Windows) бул ClipCursor( ПРЯМ *lpRect);
extern (Windows) бул GetClipCursor(ПРЯМ* lpRect);
extern (Windows) HCURSOR GetCursor();
extern (Windows) бул CreateCaret(УОК окно, УБитмап hBitmap , цел nWidth, цел nHeight);
extern (Windows) бцел GetCaretBlinkTime();
extern (Windows) бул SetCaretBlinkTime(бцел uMSeconds);
extern (Windows) бул DestroyCaret();
extern (Windows) бул HideCaret(УОК окно);
extern (Windows) бул ShowCaret(УОК окно);
extern (Windows) бул SetCaretPos(цел X, цел Y);
extern (Windows) бул GetCaretPos(ТОЧКА* lpPoцел);
extern (Windows) бул ClientToScreen(УОК окно, ТОЧКА* lpPoцел);
extern (Windows) бул ScreenToClient(УОК окно, ТОЧКА* lpPoцел);
extern (Windows) цел MapWindowPoцелs(УОК hWndFrom, УОК hWndTo, ТОЧКА* lpPoцелs, бцел cPoцелs);
extern (Windows) УОК WindowFromPoцел(ТОЧКА точка);
extern (Windows) УОК ChildWindowFromPoцел(УОК hWndParent, ТОЧКА точка);


extern (Windows) бул TrackPopupMenu(HMENU hMenu, бцел uFlags, цел x, цел y,
    цел nReserved, УОК окно, ПРЯМ *prcRect);


extern (Windows) цел DialogBoxParamA(экз hInstance, ткст0 lpTemplateName,
    УОК hWndParent, DLGPROC lpDialogFunc, LPARAM dwInitParam);
extern (Windows) цел DialogBoxIndirectParamA(экз hInstance,
    LPCDLGTEMPLATEA hDialogTemplate, УОК hWndParent, DLGPROC lpDialogFunc,
    LPARAM dwInitParam);

enum : бцел
{
    SRCCOPY =             cast(бцел)0x00CC0020, /* dest = source                   */
    SRCPAINT =            cast(бцел)0x00EE0086, /* dest = source OR dest           */
    SRCAND =              cast(бцел)0x008800C6, /* dest = source AND dest          */
    SRCINVERT =           cast(бцел)0x00660046, /* dest = source XOR dest          */
    SRCERASE =            cast(бцел)0x00440328, /* dest = source AND (NOT dest)   */
    NOTSRCCOPY =          cast(бцел)0x00330008, /* dest = (NOT source)             */
    NOTSRCERASE =         cast(бцел)0x001100A6, /* dest = (NOT src) AND (NOT dest) */
    MERGECOPY =           cast(бцел)0x00C000CA, /* dest = (source AND pattern)     */
    MERGEPAINT =          cast(бцел)0x00BB0226, /* dest = (NOT source) OR dest     */
    PATCOPY =             cast(бцел)0x00F00021, /* dest = pattern                  */
    PATPAINT =            cast(бцел)0x00FB0A09, /* dest = DPSnoo                   */
    PATINVERT =           cast(бцел)0x005A0049, /* dest = pattern XOR dest         */
    DSTINVERT =           cast(бцел)0x00550009, /* dest = (NOT dest)               */
    BLACKNESS =           cast(бцел)0x00000042, /* dest = ЧЁРНЫЙ                    */
    WHITENESS =           cast(бцел)0x00FF0062, /* dest = WHITE                    */
}

enum
{
    SND_SYNC =            0x0000, /* play synchronously (default) */
    SND_ASYNC =           0x0001, /* play asynchronously */
    SND_NODEFAULT =       0x0002, /* silence (!default) if sound not found */
    SND_MEMORY =          0x0004, /* pszSound poцелs to a memory file */
    SND_LOOP =            0x0008, /* loop the sound until next sndPlaySound */
    SND_NOSTOP =          0x0010, /* don't stop any currently playing sound */

    SND_NOWAIT =    0x00002000, /* don't wait if the driver is busy */
    SND_ALIAS =       0x00010000, /* имя is a registry alias */
    SND_ALIAS_ID =  0x00110000, /* alias is a predefined ID */
    SND_FILENAME =    0x00020000, /* имя is file имя */
    SND_RESOURCE =    0x00040004, /* имя is resource имя or atom */

    SND_PURGE =           0x0040, /* purge non-static events for task */
    SND_APPLICATION =     0x0080, /* look for application specific association */


    SND_ALIAS_START =   0,     /* alias base */
}

enum
{
    PS_SOLID =            0,
    PS_DASH =             1, /* -------  */
    PS_DOT =              2, /* .......  */
    PS_DASHDOT =          3, /* _._._._  */
    PS_DASHDOTDOT =       4, /* _.._.._  */
    PS_NULL =             5,
    PS_INSIDEFRAME =      6,
    PS_USERSTYLE =        7,
    PS_ALTERNATE =        8,
    PS_STYLE_MASK =       0x0000000F,

    PS_ENDCAP_ROUND =     0x00000000,
    PS_ENDCAP_SQUARE =    0x00000100,
    PS_ENDCAP_FLAT =      0x00000200,
    PS_ENDCAP_MASK =      0x00000F00,

    PS_JOIN_ROUND =       0x00000000,
    PS_JOIN_BEVEL =       0x00001000,
    PS_JOIN_MITER =       0x00002000,
    PS_JOIN_MASK =        0x0000F000,

    PS_COSMETIC =         0x00000000,
    PS_GEOMETRIC =        0x00010000,
    PS_TYPE_MASK =        0x000F0000,
}

HPALETTE   CreatePalette(ПАЛИТЛОГ *);
HPEN      CreatePen(цел, цел, ЦВПредст);
HPEN      CreatePenIndirect(ЛОГ_ПЕРА *);
HRGN      CreatePolyPolygonRgn(ТОЧКА *, цел *, цел, цел);
HBRUSH    CreatePatternBrush(УБитмап);
HRGN      CreateRectRgn(цел, цел, цел, цел);
HRGN      CreateRectRgnIndirect(ПРЯМ *);
HRGN      CreateRoundRectRgn(цел, цел, цел, цел, цел, цел);
бул      CreateScalableFontResourceA(бцел, ткст0, ткст0, ткст0);
бул      CreateScalableFontResourceW(бцел, шткст0, шткст0, шткст0);

ЦВПредст RGB(цел r, цел g, цел b)
{
    return cast(ЦВПредст)
    ((cast(ббайт)r|(cast(бкрат)(cast(ббайт)g)<<8))|((cast(бцел)cast(ббайт)b)<<16));
}

бул   LineTo(HDC, цел, цел);
бул   DeleteObject(HGDIOBJ);
extern (Windows) цел FillRect(HDC hDC,  ПРЯМ *lprc, HBRUSH hbr);


extern (Windows) бул EndDialog(УОК hDlg, цел nResult);
extern (Windows) УОК GetDlgItem(УОК hDlg, цел nIDDlgItem);

extern (Windows) бул SetDlgItemInt(УОК hDlg, цел nIDDlgItem, бцел uValue, бул bSigned);
extern (Windows) бцел GetDlgItemInt(УОК hDlg, цел nIDDlgItem, бул *lpTranslated,
    бул bSigned);

extern (Windows) бул SetDlgItemTextA(УОК hDlg, цел nIDDlgItem, ткст0 lpString);
extern (Windows) бул SetDlgItemTextW(УОК hDlg, цел nIDDlgItem, шткст0 lpString);

extern (Windows) бцел GetDlgItemTextA(УОК hDlg, цел nIDDlgItem, ткст0  lpString, цел nMaxCount);
extern (Windows) бцел GetDlgItemTextW(УОК hDlg, цел nIDDlgItem, шткст0 lpString, цел nMaxCount);

extern (Windows) бул CheckDlgButton(УОК hDlg, цел nIDButton, бцел uCheck);
extern (Windows) бул CheckRadioButton(УОК hDlg, цел nIDFirstButton, цел nIDLastButton,
    цел nIDCheckButton);

extern (Windows) бцел IsDlgButtonChecked(УОК hDlg, цел nIDButton);

extern (Windows) УОК SetFocus(УОК окно);

extern (Windows) цел wsprintfA(ткст0 , ткст0, ...);
extern (Windows) цел wsprintfW(шткст0, шткст0, ...);

enum : бцел
{
    INFINITE =              бцел.max,
    WAIT_OBJECT_0 =         0,
    WAIT_ABANDONED_0 =      0x80,
    WAIT_TIMEOUT =          0x102,
    WAIT_IO_COMPLETION =    0xc0,
    WAIT_ABANDONED =        0x80,
    WAIT_FAILED =           бцел.max,
}

enum
{
    RIGHT_ALT_PRESSED =     0x0001, // the right alt key is pressed.
    LEFT_ALT_PRESSED =      0x0002, // the left alt key is pressed.
    RIGHT_CTRL_PRESSED =    0x0004, // the right ctrl key is pressed.
    LEFT_CTRL_PRESSED =     0x0008, // the left ctrl key is pressed.
    ШИФТ_PRESSED =         0x0010, // the shift key is pressed.
    NUMLOCK_ON =            0x0020, // the numlock light is on.
    SCROLLLOCK_ON =         0x0040, // the scrolllock light is on.
    CAPSLOCK_ON =           0x0080, // the capslock light is on.
    ENHANCED_KEY =          0x0100, // the key is enhanced.
}

//
// ButtonState флаги
//
enum
{
    FROM_LEFT_1ST_BUTTON_PRESSED =    0x0001,
    RIGHTMOST_BUTTON_PRESSED =        0x0002,
    FROM_LEFT_2ND_BUTTON_PRESSED =    0x0004,
    FROM_LEFT_3RD_BUTTON_PRESSED =    0x0008,
    FROM_LEFT_4TH_BUTTON_PRESSED =    0x0010,
}

//
// EventFlags
//

enum
{
    MOUSE_MOVED =   0x0001,
    DOUBLE_CLICK =  0x0002,
}


//
//  EventType флаги:
//

enum
{
    KEY_EVENT =         0x0001, // Event contains key event record
    MOUSE_EVENT =       0x0002, // Event contains mouse event record
    WINDOW_BUFFER_SIZE_EVENT = 0x0004, // Event contains window change event record
    MENU_EVENT = 0x0008, // Event contains menu event record
    FOCUS_EVENT = 0x0010, // event contains focus change
}


//
// Attributes флаги:
//

enum
{
    FOREGROUND_BLUE =      0x0001, // text цвет contains blue.
    FOREGROUND_GREEN =     0x0002, // text цвет contains green.
    FOREGROUND_RED =       0x0004, // text цвет contains red.
    FOREGROUND_INTENSITY = 0x0008, // text цвет is целensified.
    BACKGROUND_BLUE =      0x0010, // background цвет contains blue.
    BACKGROUND_GREEN =     0x0020, // background цвет contains green.
    BACKGROUND_RED =       0x0040, // background цвет contains red.
    BACKGROUND_INTENSITY = 0x0080, // background цвет is целensified.
}


enum
{
    ENABLE_PROCESSED_INPUT = 0x0001,
    ENABLE_LINE_INPUT =      0x0002,
    ENABLE_ECHO_INPUT =      0x0004,
    ENABLE_WINDOW_INPUT =    0x0008,
    ENABLE_MOUSE_INPUT =     0x0010,
}

enum
{
    ENABLE_PROCESSED_OUTPUT =    0x0001,
    ENABLE_WRAP_AT_EOL_OUTPUT =  0x0002,
}


enum
{
    CONSOLE_TEXTMODE_BUFFER = 1,
}

enum
{
    SM_CXSCREEN =             0,
    SM_CYSCREEN =             1,
    SM_CXVSCROLL =            2,
    SM_CYHSCROLL =            3,
    SM_CYCAPTION =            4,
    SM_CXBORDER =             5,
    SM_CYBORDER =             6,
    SM_CXDLGFRAME =           7,
    SM_CYDLGFRAME =           8,
    SM_CYVTHUMB =             9,
    SM_CXHTHUMB =             10,
    SM_CXICON =               11,
    SM_CYICON =               12,
    SM_CXCURSOR =             13,
    SM_CYCURSOR =             14,
    SM_CYMENU =               15,
    SM_CXFULLSCREEN =         16,
    SM_CYFULLSCREEN =         17,
    SM_CYKANJIWINDOW =        18,
    SM_MOUSEPRESENT =         19,
    SM_CYVSCROLL =            20,
    SM_CXHSCROLL =            21,
    SM_DEBUG =                22,
    SM_SWAPBUTTON =           23,
    SM_RESERVED1 =            24,
    SM_RESERVED2 =            25,
    SM_RESERVED3 =            26,
    SM_RESERVED4 =            27,
    SM_CXMIN =                28,
    SM_CYMIN =                29,
    SM_CXSIZE =               30,
    SM_CYSIZE =               31,
    SM_CXFRAME =              32,
    SM_CYFRAME =              33,
    SM_CXMINTRACK =           34,
    SM_CYMINTRACK =           35,
    SM_CXDOUBLECLK =          36,
    SM_CYDOUBLECLK =          37,
    SM_CXICONSPACING =        38,
    SM_CYICONSPACING =        39,
    SM_MENUDROPALIGNMENT =    40,
    SM_PENWINDOWS =           41,
    SM_DBCSENABLED =          42,
    SM_CMOUSEBUTTONS =        43,


    SM_CXFIXEDFRAME =         SM_CXDLGFRAME,
    SM_CYFIXEDFRAME =         SM_CYDLGFRAME,
    SM_CXSIZEFRAME =          SM_CXFRAME,
    SM_CYSIZEFRAME =          SM_CYFRAME,

    SM_SECURE =               44,
    SM_CXEDGE =               45,
    SM_CYEDGE =               46,
    SM_CXMINSPACING =         47,
    SM_CYMINSPACING =         48,
    SM_CXSMICON =             49,
    SM_CYSMICON =             50,
    SM_CYSMCAPTION =          51,
    SM_CXSMSIZE =             52,
    SM_CYSMSIZE =             53,
    SM_CXMENUSIZE =           54,
    SM_CYMENUSIZE =           55,
    SM_ARRANGE =              56,
    SM_CXMINIMIZED =          57,
    SM_CYMINIMIZED =          58,
    SM_CXMAXTRACK =           59,
    SM_CYMAXTRACK =           60,
    SM_CXMAXIMIZED =          61,
    SM_CYMAXIMIZED =          62,
    SM_NETWORK =              63,
    SM_CLEANBOOT =            67,
    SM_CXDRAG =               68,
    SM_CYDRAG =               69,
    SM_SHOWSOUNDS =           70,
    SM_CXMENUCHECK =          71,
    SM_CYMENUCHECK =          72,
    SM_SLOWMACHINE =          73,
    SM_MIDEASTENABLED =       74,
    SM_CMETRICS =             75,
}


//********************************************************//
/***************************************os.wyndows ************************************************/
extern(Windows)
{


// Removes.
проц FD_CLR(СОКЕТ fd, набор_уд* набор)
{
	бцел c = набор.счёт_уд;
	СОКЕТ* start = набор.массив_уд.ptr;
	СОКЕТ* stop = start + c;
	
	for(; start != stop; start++)
	{
		if(*start == fd)
			goto found;
	}
	return; //not found
	
	found:
	for(++start; start != stop; start++)
	{
		*(start - 1) = *start;
	}
	
	набор.счёт_уд = c - 1;
}


// Tests.
цел FD_ISSET(СОКЕТ fd, набор_уд* набор)
{
	СОКЕТ* start = набор.массив_уд.ptr;
	СОКЕТ* stop = start + набор.счёт_уд;
	
	for(; start != stop; start++)
	{
		if(*start == fd)
			return true;
	}
	return false;
}


// Adds.
проц FD_SET(СОКЕТ fd, набор_уд* набор)
{
	бцел c = набор.счёт_уд;
	набор.массив_уд.ptr[c] = fd;
	набор.счёт_уд = c + 1;
}


// Resets to zero.
проц FD_ZERO(набор_уд* набор)
{
	набор.счёт_уд = 0;
}


/+
union адрес_ин6
{
	private union _u_t
	{
		ббайт[16] Byte;
		бкрат[8] Word;
	}
	_u_t u;
}


struct in_addr6
{
	ббайт[16] s6_addr;
}
+/


version(BigEndian)
{
	uint16_t htons(uint16_t x)
	{
		return x;
	}
	
	
	uint32_t htonl(uint32_t x)
	{
		return x;
	}
}
else version(LittleEndian)
{
	private import std.intrinsic;
	
	
	uint16_t htons(uint16_t x)
	{
		return cast(uint16_t)((x >> 8) | (x << 8));
	}


	uint32_t htonl(uint32_t x)
	{
		return bswap(x);
	}
}
else
{
	static assert(0);
}


uint16_t ntohs(uint16_t x)
{
	return htons(x);
}


uint32_t ntohl(uint32_t x)
{
	return htonl(x);
}


const адрес_ин6 IN6ADDR_ANY = { с6_адр8: [0] };
const адрес_ин6 IN6ADDR_LOOPBACK = { с6_адр8: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1] };
//alias IN6ADDR_ANY IN6ADDR_ANY_INIT;
//alias IN6ADDR_LOOPBACK IN6ADDR_LOOPBACK_INIT;
	
const бцел INET_ADDRSTRLEN = 16;
const бцел INET6_ADDRSTRLEN = 46;

}
/////////////////////////////



/************************************** os.io.Console.com *********************************************************/

alias WCHAR OLECHAR;
alias OLECHAR *LPOLESTR;
alias OLECHAR *LPCOLESTR;

enum
{
	rmm = 23,	// OLE 2 version номер info
	rup = 639,
}

enum : цел
{
	S_OK = 0,
	S_FALSE = 0x00000001,
	NOERROR = 0,
	E_NOTIMPL     = cast(цел)0x80004001,
	E_NOINTERFACE = cast(цел)0x80004002,
        E_POINTER     = cast(int)0x80004003,
	E_ABORT       = cast(цел)0x80004004,
	E_FAIL        = cast(цел)0x80004005,
	E_HANDLE      = cast(цел)0x80070006,
	CLASS_E_NOAGGREGATION = cast(цел)0x80040110,
	E_OUTOFMEMORY = cast(цел)0x8007000E,
	E_INVALIDARG  = cast(цел)0x80070057,
	E_UNEXPECTED  = cast(цел)0x8000FFFF,
}


enum
{
	CLSCTX_INPROC_SERVER	= 0x1,
	CLSCTX_INPROC_HANDLER	= 0x2,
	CLSCTX_LOCAL_SERVER	= 0x4,
	CLSCTX_INPROC_SERVER16	= 0x8,
	CLSCTX_REMOTE_SERVER	= 0x10,
	CLSCTX_INPROC_HANDLER16	= 0x20,
	CLSCTX_INPROC_SERVERX86	= 0x40,
	CLSCTX_INPROC_HANDLERX86 = 0x80,

	CLSCTX_INPROC = (CLSCTX_INPROC_SERVER|CLSCTX_INPROC_HANDLER),
	CLSCTX_ALL = (CLSCTX_INPROC_SERVER| CLSCTX_INPROC_HANDLER| CLSCTX_LOCAL_SERVER),
	CLSCTX_SERVER = (CLSCTX_INPROC_SERVER|CLSCTX_LOCAL_SERVER),
}

alias GUID IID;
alias GUID CLSID;


extern (System)
{


interface IUnknown
{
    HRESULT QueryInterface(IID* riid, ук* pvObject);
    бцел AddRef();
    бцел Release();
}

interface IClassFactory : IUnknown
{
    HRESULT CreateInstance(IUnknown UnkOuter, IID* riid, ук* pvObject);
    HRESULT LockServer(бул fLock);
}
/*
class ComObject : IUnknown
{
extern (System):
    HRESULT QueryInterface(IID* riid, ук* ppv)
    {
	if (*riid == IID_IUnknown)
	{
	    *ppv = cast(ук)cast(IUnknown)this;
	    AddRef();
	    return S_OK;
	}
	else
	{   *ppv = null;
	    return E_NOINTERFACE;
	}
    }

    бцел AddRef()
    {
	return InterlockedIncrement(&count);
    }

    бцел Release()
    {
	цел lRef = InterlockedDecrement(&count);
	if (lRef == 0)
	{
	    // free object

	    // If we delete this object, then the postinvariant called upon
	    // return from Release() will fail.
	    // Just let the GC reap it.
	    //delete this;

	    return 0;
	}
	return cast(бцел)lRef;
    }

    цел count = 0;		// object reference count
}
*/
}

/****************************************** os.io.Console.stat ************************************************/

extern (C):

// linux version is in linux

version (Windows)
{
const S_IFMT   = 0xF000;
const S_IFDIR  = 0x4000;
const S_IFCHR  = 0x2000;
const S_IFIFO  = 0x1000;
const S_IFREG  = 0x8000;
const S_IREAD  = 0x0100;
const S_IWRITE = 0x0080;
const S_IEXEC  = 0x0040;
const S_IFBLK  = 0x6000;
const S_IFNAM  = 0x5000;

цел S_ISREG(цел m)  { return (m & S_IFMT) == S_IFREG; }
цел S_ISBLK(цел m)  { return (m & S_IFMT) == S_IFBLK; }
цел S_ISNAM(цел m)  { return (m & S_IFMT) == S_IFNAM; }
цел S_ISDIR(цел m)  { return (m & S_IFMT) == S_IFDIR; }
цел S_ISCHR(цел m)  { return (m & S_IFMT) == S_IFCHR; }

struct struct_stat
{
    крат st_dev;
    бкрат st_ino;
    бкрат st_mode;
    крат st_nlink;
    бкрат st_uid;
    бкрат st_gid;
    крат st_rdev;
    крат dummy;
    цел st_size;
    цел st_atime;
    цел st_mtime;
    цел st_ctime;
}

цел  stat(char*, struct_stat*);
цел  fstat(цел, struct_stat*);
цел  _wstat(шткст0, struct_stat*);
}
+/