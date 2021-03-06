; --------------------------------------------------------------------------------------------------
;                          strmbasd.inc Copyright The MASM32 SDK 1998-2010
; --------------------------------------------------------------------------------------------------

IFNDEF STRMBASD_INC
STRMBASD_INC equ <1>

AdjustWindowRectEx PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
AllocConsole PROTO STDCALL
BitBlt PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CloseHandle PROTO STDCALL :DWORD
CoCreateInstance PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CoFreeUnusedLibraries PROTO STDCALL
CoInitialize PROTO STDCALL :DWORD
CoTaskMemAlloc PROTO STDCALL :DWORD
CoTaskMemFree PROTO STDCALL :DWORD
CoUninitialize PROTO STDCALL
CreateCompatibleBitmap PROTO STDCALL :DWORD,:DWORD,:DWORD
CreateCompatibleDC PROTO STDCALL :DWORD

CreateDCA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  CreateDC equ <CreateDCA>
ENDIF

CreateDIBSection PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD

CreateDialogParamW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  CreateDialogParam equ <CreateDialogParamW>
ENDIF

CreateEventW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  CreateEvent equ <CreateEventW>
ENDIF

CreateFileMappingW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  CreateFileMapping equ <CreateFileMappingW>
ENDIF

CreateFileW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  CreateFile equ <CreateFileW>
ENDIF

CreatePalette PROTO STDCALL :DWORD

CreateSemaphoreW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  CreateSemaphore equ <CreateSemaphoreW>
ENDIF

CreateThread PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD

CreateWindowExW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  CreateWindowEx equ <CreateWindowExW>
ENDIF

DebugBreak PROTO STDCALL

DefWindowProcW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  DefWindowProc equ <DefWindowProcW>
ENDIF

DeleteCriticalSection PROTO STDCALL :DWORD
DeleteDC PROTO STDCALL :DWORD
DeleteObject PROTO STDCALL :DWORD
DestroyWindow PROTO STDCALL :DWORD
DisableThreadLibraryCalls PROTO STDCALL :DWORD

DispatchMessageW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  DispatchMessage equ <DispatchMessageW>
ENDIF

DuplicateHandle PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
EnterCriticalSection PROTO STDCALL :DWORD

FatalAppExitW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  FatalAppExit equ <FatalAppExitW>
ENDIF

FreeLibrary PROTO STDCALL :DWORD
GdiFlush PROTO STDCALL

GetClassInfoW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  GetClassInfo equ <GetClassInfoW>
ENDIF

GetClientRect PROTO STDCALL :DWORD,:DWORD
GetCurrentProcess PROTO STDCALL
GetCurrentProcessId PROTO STDCALL
GetCurrentThread PROTO STDCALL
GetCurrentThreadId PROTO STDCALL
GetDC PROTO STDCALL :DWORD
GetDIBits PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetDesktopWindow PROTO STDCALL
GetDeviceCaps PROTO STDCALL :DWORD,:DWORD
GetLastError PROTO STDCALL

GetModuleFileNameA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  GetModuleFileName equ <GetModuleFileNameA>
ENDIF

GetModuleFileNameW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  GetModuleFileName equ <GetModuleFileNameW>
ENDIF

GetModuleHandleW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  GetModuleHandle equ <GetModuleHandleW>
ENDIF

GetObjectW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  GetObject equ <GetObjectW>
ENDIF

GetParent PROTO STDCALL :DWORD
GetProcAddress PROTO STDCALL :DWORD,:DWORD

GetProfileIntW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  GetProfileInt equ <GetProfileIntW>
ENDIF

GetQueueStatus PROTO STDCALL :DWORD
GetStdHandle PROTO STDCALL :DWORD
GetStockObject PROTO STDCALL :DWORD
GetSystemInfo PROTO STDCALL :DWORD
GetSystemMetrics PROTO STDCALL :DWORD
GetSystemPaletteEntries PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD

GetTextExtentPoint32W PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  GetTextExtentPoint32 equ <GetTextExtentPoint32W>
ENDIF

GetThreadPriority PROTO STDCALL :DWORD
GetTickCount PROTO STDCALL

GetVersionExW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  GetVersionEx equ <GetVersionExW>
ENDIF

GetWindowLongW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  GetWindowLong equ <GetWindowLongW>
ENDIF

GetWindowPlacement PROTO STDCALL :DWORD,:DWORD
GetWindowRect PROTO STDCALL :DWORD,:DWORD

GetWindowTextW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  GetWindowText equ <GetWindowTextW>
ENDIF

GetWindowThreadProcessId PROTO STDCALL :DWORD,:DWORD
InSendMessage PROTO STDCALL
InitializeCriticalSection PROTO STDCALL :DWORD
InterlockedDecrement PROTO STDCALL :DWORD
InterlockedExchange PROTO STDCALL :DWORD,:DWORD
InterlockedIncrement PROTO STDCALL :DWORD
InvalidateRect PROTO STDCALL :DWORD,:DWORD,:DWORD
IsBadReadPtr PROTO STDCALL :DWORD,:DWORD
IsBadWritePtr PROTO STDCALL :DWORD,:DWORD
IsIconic PROTO STDCALL :DWORD
IsRectEmpty PROTO STDCALL :DWORD
IsWindow PROTO STDCALL :DWORD
IsWindowVisible PROTO STDCALL :DWORD
IsZoomed PROTO STDCALL :DWORD
LeaveCriticalSection PROTO STDCALL :DWORD

LoadCursorW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  LoadCursor equ <LoadCursorW>
ENDIF

LoadLibraryW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  LoadLibrary equ <LoadLibraryW>
ENDIF

LoadStringA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  LoadString equ <LoadStringA>
ENDIF

LoadStringW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  LoadString equ <LoadStringW>
ENDIF

MapWindowPoints PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD

MessageBoxW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  MessageBox equ <MessageBoxW>
ENDIF

MoveWindow PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MsgWaitForMultipleObjects PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MulDiv PROTO STDCALL :DWORD,:DWORD,:DWORD
MultiByteToWideChar PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD

OutputDebugStringW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  OutputDebugString equ <OutputDebugStringW>
ENDIF

PeekMessageW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  PeekMessage equ <PeekMessageW>
ENDIF

PostMessageW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  PostMessage equ <PostMessageW>
ENDIF

PostThreadMessageW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  PostThreadMessage equ <PostThreadMessageW>
ENDIF

RealizePalette PROTO STDCALL :DWORD
RegCloseKey PROTO STDCALL :DWORD

RegCreateKeyExW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  RegCreateKeyEx equ <RegCreateKeyExW>
ENDIF

RegCreateKeyW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  RegCreateKey equ <RegCreateKeyW>
ENDIF

RegDeleteKeyW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  RegDeleteKey equ <RegDeleteKeyW>
ENDIF

RegEnumKeyExW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  RegEnumKeyEx equ <RegEnumKeyExW>
ENDIF

RegOpenKeyExW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  RegOpenKeyEx equ <RegOpenKeyExW>
ENDIF

RegQueryValueExW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  RegQueryValueEx equ <RegQueryValueExW>
ENDIF

RegSetValueExW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  RegSetValueEx equ <RegSetValueExW>
ENDIF

RegSetValueW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  RegSetValue equ <RegSetValueW>
ENDIF

RegisterClassW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  RegisterClass equ <RegisterClassW>
ENDIF

RegisterWindowMessageW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  RegisterWindowMessage equ <RegisterWindowMessageW>
ENDIF

ReleaseDC PROTO STDCALL :DWORD,:DWORD
ReleaseSemaphore PROTO STDCALL :DWORD,:DWORD,:DWORD
ResetEvent PROTO STDCALL :DWORD
SelectObject PROTO STDCALL :DWORD,:DWORD
SelectPalette PROTO STDCALL :DWORD,:DWORD,:DWORD

SendMessageW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SendMessage equ <SendMessageW>
ENDIF

SetConsoleTitleW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  SetConsoleTitle equ <SetConsoleTitleW>
ENDIF

SetDIBColorTable PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
SetDIBitsToDevice PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetErrorMode PROTO STDCALL :DWORD
SetEvent PROTO STDCALL :DWORD
SetFilePointer PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
SetForegroundWindow PROTO STDCALL :DWORD
SetLastError PROTO STDCALL :DWORD
SetParent PROTO STDCALL :DWORD,:DWORD
SetRectEmpty PROTO STDCALL :DWORD
SetStretchBltMode PROTO STDCALL :DWORD,:DWORD
SetThreadPriority PROTO STDCALL :DWORD,:DWORD

SetWindowLongW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SetWindowLong equ <SetWindowLongW>
ENDIF

SetWindowPos PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD

SetWindowTextW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  SetWindowText equ <SetWindowTextW>
ENDIF

ShowWindow PROTO STDCALL :DWORD,:DWORD
Sleep PROTO STDCALL :DWORD
StretchBlt PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
StretchDIBits PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
StringFromGUID2 PROTO STDCALL :DWORD,:DWORD,:DWORD
SysAllocString PROTO STDCALL :DWORD
SysFreeString PROTO STDCALL :DWORD

SystemParametersInfoW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SystemParametersInfo equ <SystemParametersInfoW>
ENDIF

TextOutW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  TextOut equ <TextOutW>
ENDIF

VirtualAlloc PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VirtualFree PROTO STDCALL :DWORD,:DWORD,:DWORD
WaitForMultipleObjects PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
WaitForSingleObject PROTO STDCALL :DWORD,:DWORD
WideCharToMultiByte PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteFile PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
_vsnwprintf PROTO C :VARARG
_wtoi PROTO C :VARARG

lstrcatA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  lstrcat equ <lstrcatA>
ENDIF

lstrcatW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  lstrcat equ <lstrcatW>
ENDIF

lstrcmpW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  lstrcmp equ <lstrcmpW>
ENDIF

lstrcmpiA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  lstrcmpi equ <lstrcmpiA>
ENDIF

lstrcmpiW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  lstrcmpi equ <lstrcmpiW>
ENDIF

lstrcpyW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  lstrcpy equ <lstrcpyW>
ENDIF

lstrcpynW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  lstrcpyn equ <lstrcpynW>
ENDIF

lstrlenA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  lstrlen equ <lstrlenA>
ENDIF

lstrlenW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  lstrlen equ <lstrlenW>
ENDIF

swprintf PROTO C :VARARG
timeBeginPeriod PROTO STDCALL :DWORD
timeEndPeriod PROTO STDCALL :DWORD
timeGetDevCaps PROTO STDCALL :DWORD,:DWORD
timeGetTime PROTO STDCALL
timeKillEvent PROTO STDCALL :DWORD
timeSetEvent PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
vswprintf PROTO C :VARARG
wcsrchr PROTO C :VARARG

wsprintfW PROTO C :VARARG
IFDEF __UNICODE__
  wsprintf equ <wsprintfW>
ENDIF

wvsprintfA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  wvsprintf equ <wvsprintfA>
ENDIF

wvsprintfW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  wvsprintf equ <wvsprintfW>
ENDIF

ELSE
  echo -------------------------------------------
  echo WARNING duplicate include file strmbasd.inc
  echo -------------------------------------------
ENDIF
