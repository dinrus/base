/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.base.native;

import win32.base.core,
	tpl.traits,
	tpl.typetuple;
import stdrus : вЮ8, вЮ16н, фм, вБкрат;
import stringz: вТкст0;
//import win32.winuser;

extern(Windows):

const бцел _WIN32_WINNT = 0x601;
const бцел _WIN32_WINDOWS = бцел.max;
const бцел _WIN32_IE = 0x700;

const бцел WINVER = _WIN32_WINDOWS < _WIN32_WINNT ? _WIN32_WINDOWS : _WIN32_WINNT;

const бцел MAX_PATH = 260;

//alias цел BOOL;
/+
enum : BOOL {
  FALSE,
  TRUE
}
+/
enum : бцел {
  ERROR_SUCCESS                 = 0,
  ERROR_INVALID_FUNCTION        = 1,
  ERROR_FILE_NOT_FOUND          = 2,
  ERROR_PATH_NOT_FOUND          = 3,
  ERROR_TOO_MANY_OPEN_FILES     = 4,
  ERROR_ACCESS_DENIED           = 5,
  ERROR_INVALID_HANDLE          = 6,
  ERROR_NO_MORE_FILES           = 18,
  ERROR_BAD_LENGTH              = 24,
  ERROR_INSUFFICIENT_BUFFER     = 122,
  ERROR_ALREADY_EXISTS          = 183,
  ERROR_MORE_DATA               = 234,
  ERROR_NO_MORE_ITEMS           = 259,
  ERROR_IO_PENDING              = 997,
  ERROR_CANCELLED               = 1223,
  ERROR_BAD_IMPERSONATION_LEVEL = 1346,
  ERROR_CLASS_ALREADY_EXISTS    = 1410,
  NTE_BAD_DATA                  = 0x80090005,
  NTE_BAD_SIGNATURE             = 0x80090006
}

enum : бцел {
  FACILITY_NULL             = 0,
  FACILITY_RPC              = 1,
  FACILITY_DISPATCH         = 2,
  FACILITY_STORAGE          = 3,
  FACILITY_ITF              = 4,
  FACILITY_WIN32            = 7,
  FACILITY_WINDOWS          = 8,
  FACILITY_SSPI             = 9,
  FACILITY_SECURITY         = 9,
  FACILITY_CONTROL          = 10,
  FACILITY_CERT             = 11,
  FACILITY_INTERNET         = 12,
  FACILITY_MEDIASERVER      = 13,
  FACILITY_MSMQ             = 14,
  FACILITY_SETUPAPI         = 15,
  FACILITY_SCARD            = 16,
  FACILITY_COMPLUS          = 17,
  FACILITY_AAF              = 18,
  FACILITY_URT              = 19,
  FACILITY_ACS              = 20,
  FACILITY_DPLAY            = 21,
  FACILITY_UMI              = 22,
  FACILITY_SXS              = 23,
  FACILITY_WINDOWS_CE       = 24,
  FACILITY_HTTP             = 25,
  FACILITY_BACKGROUNDCOPY   = 32,
  FACILITY_CONFIGURATION    = 33,
  FACILITY_STATE_MANAGEMENT = 34,
  FACILITY_METADIRECTORY    = 35,
  FACILITY_WINDOWSUPDATE    = 36,
  FACILITY_DIRECTORYSERVICE = 37
}

enum {
  SEVERITY_SUCCESS = 0,
  SEVERITY_ERROR = 1
}

template MAKE_SCODE(бцел sev, бцел fac, бцел code) {
  const MAKE_SCODE = ((sev << 31) | (fac << 16) | code);
}

version(D_Version2) {
  const Укз INVALID_HANDLE_VALUE = cast(Укз)-1;
}
else {
  extern(D) // Previous definition different
  const Укз INVALID_HANDLE_VALUE = cast(Укз)-1;
}

ббайт HIBYTE(бкрат w) {
  return cast(ббайт)((w >> 8) & 0xFF);
}

ббайт LOBYTE(бкрат w) {
  return cast(ббайт)(w & 0xFF);
}

крат signedHIWORD(цел n) {
  return cast(крат)((n >> 16) & 0xFFFF);
}

крат signedLOWORD(цел n) {
  return cast(крат)(n & 0xFFFF);
}

цел MAKELPARAM(цел a, цел b) {
  return (a & 0xFFFF) | (b << 16);
}

бкрат MAKEWORD(ббайт a, ббайт b) {
  return (a & 0xFF) | (b << 8);
}

version(D_Version2) {
  mixin("
  const(шим)* MAKEINTRESOURCEW(цел i) {
    return cast(шим*)cast(бцел)cast(бкрат)i;
  }
  ");
}
else {
  шим* MAKEINTRESOURCEW(цел i) {
    return cast(шим*)cast(бцел)cast(бкрат)i;
  }
}
alias MAKEINTRESOURCEW MAKEINTRESOURCE;

const шим* RT_CURSOR       = MAKEINTRESOURCE(1);
const шим* RT_BITMAP       = MAKEINTRESOURCE(2);
const шим* RT_ICON         = MAKEINTRESOURCE(3);
const шим* RT_MENU         = MAKEINTRESOURCE(4);
const шим* RT_DIALOG       = MAKEINTRESOURCE(5);
//const шим* RT_STRING       = MAKEINTRESOURCE(6);
const шим* RT_FONTDIR      = MAKEINTRESOURCE(7);
const шим* RT_FONT         = MAKEINTRESOURCE(8);
const шим* RT_ACCELERATOR  = MAKEINTRESOURCE(9);
const шим* RT_RCDATA       = MAKEINTRESOURCE(10);
const шим* RT_MESSAGETABLE = MAKEINTRESOURCE(11);
const шим* RT_VERSION      = MAKEINTRESOURCE(16);
const шим* RT_DLGINCLUDE   = MAKEINTRESOURCE(17);
const шим* RT_PLUGPLAY     = MAKEINTRESOURCE(19);
const шим* RT_VXD          = MAKEINTRESOURCE(20);
const шим* RT_ANICURSOR    = MAKEINTRESOURCE(21);
const шим* RT_ANIICON      = MAKEINTRESOURCE(22);
const шим* RT_HTML         = MAKEINTRESOURCE(23);
const шим* RT_MANIFEST     = MAKEINTRESOURCE(24);

struct FILETIME {
  бцел dwLowDateTime;
  бцел dwHighDateTime;
}

struct SYSTEMTIME {
  бкрат wYear;
  бкрат wMonth;
  бкрат wDayOfWeek;
  бкрат wDay;
  бкрат wHour;
  бкрат wMinute;
  бкрат wSecond;
  бкрат wMilliseconds;
}

проц GetSystemTimeAsFileTime(out FILETIME lpSystemTimeAsFileTime);

цел FileTimeToLocalFileTime(ref  FILETIME lpFileTime, out FILETIME lpLocalFileTime);

цел LocalFileTimeToFileTime(ref  FILETIME lpLocalFileTime, out FILETIME lpFileTime);

цел SystemTimeToFileTime(ref  SYSTEMTIME lpSystemTime, out FILETIME lpFileTime);

цел FileTimeToSystemTime(ref  FILETIME lpFileTime, out SYSTEMTIME lpSystemTime);

enum : бцел {
  FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x00000100,
  FORMAT_MESSAGE_ARGUMENT_ARRAY  = 0x00002000,
  FORMAT_MESSAGE_FROM_HMODULE    = 0x00000800,
  FORMAT_MESSAGE_FROM_STRING     = 0x00000400,
  FORMAT_MESSAGE_FROM_SYSTEM     = 0x00001000,
  FORMAT_MESSAGE_IGNORE_INSERTS  = 0x00000200
}

цел FormatMessageW(бцел dwFlags, in ук lpSource, бцел dwMessageId, бцел dwLanguageId, шим* lpBuffer, бцел nSize, ук* Arguments);
alias FormatMessageW FormatMessage;

enum : бцел {
  LMEM_FIXED          = 0x0000,
  LMEM_MOVEABLE       = 0x0002,
  LMEM_NOCOMPACT      = 0x0010,
  LMEM_NODISCARD      = 0x0020,
  LMEM_ZEROINIT       = 0x0040,
  LMEM_MODIFY         = 0x0080,
  LMEM_DISCARDABLE    = 0x0F00,
  LMEM_VALID_FLAGS    = 0x0F72,
  LMEM_INVALID_HANDLE = 0x8000
}

Укз LocalAlloc(бцел uFlags, т_мера cb);

Укз LocalFree(Укз hMem);
ук LocalFree(ук hMem);

enum : бцел {
  GMEM_FIXED          = 0x0000,
  GMEM_MOVEABLE       = 0x0002,
  GMEM_NOCOMPACT      = 0x0010,
  GMEM_NODISCARD      = 0x0020,
  GMEM_ZEROINIT       = 0x0040,
  GMEM_MODIFY         = 0x0080,
  GMEM_DISCARDABLE    = 0x0100,
  GMEM_NOT_BANKED     = 0x1000,
  GMEM_SHARE          = 0x2000,
  GMEM_DDESHARE       = 0x2000,
  GMEM_NOTIFY         = 0x4000,
  GMEM_LOWER          = GMEM_NOT_BANKED,
  GMEM_VALID_FLAGS    = 0x7F72,
  GMEM_INVALID_HANDLE = 0x8000
}

Укз GlobalAlloc(бцел uFlags, т_мера dwBytes);

Укз GlobalReAlloc(Укз hMem, т_мера dwBytes, бцел uFlags);

т_мера GlobalSize(Укз hMem);

ук GlobalLock(Укз hMem);

цел GlobalUnlock(Укз hMem);

Укз GlobalFree(Укз hMem);
ук GlobalFree(ук hMem);

enum : бцел {
  HEAP_NO_SERIALIZE               = 0x00000001,
  HEAP_GROWABLE                   = 0x00000002,
  HEAP_GENERATE_EXCEPTIONS        = 0x00000004,
  HEAP_ZERO_MEMORY                = 0x00000008,
  HEAP_REALLOC_IN_PLACE_ONLY      = 0x00000010,
  HEAP_TAIL_CHECKING_ENABLED      = 0x00000020,
  HEAP_FREE_CHECKING_ENABLED      = 0x00000040,
  HEAP_DISABLE_COALESCE_ON_FREE   = 0x00000080,
  HEAP_CREATE_ALIGN_16            = 0x00010000,
  HEAP_CREATE_ENABLE_TRACING      = 0x00020000,
  HEAP_CREATE_ENABLE_EXECUTE      = 0x00040000,
  HEAP_MAXIMUM_TAG                = 0x0FFF,
  HEAP_PSEUDO_TAG_FLAG            = 0x8000,
  HEAP_TAG_SHIFT                  = 18
}

Укз HeapCreate(бцел flOptions, т_мера dwInitialSize, т_мера dwMaximumSize);

цел HeapDestroy(Укз hHeap);

Укз GetProcessHeap();

ук HeapAlloc(Укз hHeap, бцел dwFlags, т_мера dwBytes);

цел HeapFree(Укз hHeap, бцел dwFlags, ук lpMem);

бцел GetLastError();

проц SetLastError(бцел);

Укз LoadLibraryW(in шим* lpLibFileName);
alias LoadLibraryW LoadLibrary;

цел FreeLibrary(Укз hModule);

enum : бцел {
  DONT_RESOLVE_DLL_REFERENCES = 0x00000001,
  LOAD_LIBRARY_AS_DATAFILE = 0x00000002,
  LOAD_WITH_ALTERED_SEARCH_PATH = 0x00000008,
  LOAD_IGNORE_CODE_AUTHZ_LEVEL = 0x00000010,
  LOAD_LIBRARY_AS_IMAGE_RESOURCE = 0x00000020,
  LOAD_LIBRARY_AS_DATAFILE_EXCLUSIVE = 0x00000040
}

Укз LoadLibraryExW(in шим* lpLibFileName, Укз hFile, бцел dwFlags);
alias LoadLibraryExW LoadLibraryEx;

ук GetProcAddress(Укз hModule, in сим* lpProcName);

бцел GetVersion();

struct OSVERSIONINFOW {
  бцел dwOSVersionInfoSize = OSVERSIONINFOW.sizeof;
  бцел dwMajorVersion;
  бцел dwMinorVersion;
  бцел dwBuildNumber;
  бцел dwPlatformId;
  шим[128] szCSDVersion;
}
alias OSVERSIONINFOW OSVERSIONINFO;

struct OSVERSIONINFOEXW {
  бцел dwOSVersionInfoSize = OSVERSIONINFOEXW.sizeof;
  бцел dwMajorVersion;
  бцел dwMinorVersion;
  бцел dwBuildNumber;
  бцел dwPlatformId;
  шим[128] szCSDVersion;
  бкрат wServicePackMajor;
  бкрат wServicePackMinor;
  бкрат wSuiteMask;
  ббайт wProductType;
  ббайт wReserved;
}
alias OSVERSIONINFOEXW OSVERSIONINFOEX;

цел GetVersionExW(ref  OSVERSIONINFOW lpVersionInformation);
цел GetVersionExW(ref  OSVERSIONINFOEXW lpVersionInformation);
alias GetVersionExW GetVersionEx;

бцел GetFileVersionInfoSizeW(in шим* lpstrFilename, бцел* lpdwHandle);
alias GetFileVersionInfoSizeW GetFileVersionInfoSize;

цел GetFileVersionInfoW(in шим* lpstrFilename, бцел dwHandle, бцел dwLen, ук lpData);
alias GetFileVersionInfoW GetFileVersionInfo;

цел VerQueryValueW(in ук pBlock, in шим* lpSubBlock, ук* lplpBuffer, out бцел puLen);
alias VerQueryValueW VerQueryValue;

struct VS_FIXEDFILEINFO {
  бцел dwSignature;
  бцел dwStrucVersion;
  бцел dwFileVersionMS;
  бцел dwFileVersionLS;
  бцел dwProductVersionMS;
  бцел dwProductVersionLS;
  бцел dwFileFlagsMask;
  бцел dwFileFlags;
  бцел dwFileOS;
  бцел dwFileType;
  бцел dwFileSubtype;
  бцел dwFileDateMS;
  бцел dwFileDateLS;
}

struct SECURITY_ATTRIBUTES {
  бцел nLength;
  ук lpSecurityDescriptor;
  цел bInheritHandle;
}

struct OVERLAPPED {
  бцел Internal;
  бцел InternalHigh;
  union {
    struct {
      бцел Offset;
      бцел OffsetHigh;
    }
    ук Pointer;
  }
  Укз hEvent;
}

enum : бцел {
  FILE_LIST_DIRECTORY = 0x0001
}

enum {
  GENERIC_READ = 0x80000000,
  GENERIC_WRITE = 0x40000000,
  GENERIC_EXECUTE = 0x20000000,
  GENERIC_ALL = 0x10000000
}

enum : бцел {
  FILE_SHARE_READ = 0x00000001,
  FILE_SHARE_WRITE = 0x00000002,
  FILE_SHARE_DELETE = 0x00000004
}

enum : бцел {
  FILE_FLAG_WRITE_THROUGH       = 0x80000000,
  FILE_FLAG_OVERLAPPED          = 0x40000000,
  FILE_FLAG_NO_BUFFERING        = 0x20000000,
  FILE_FLAG_RANDOM_ACCESS       = 0x10000000,
  FILE_FLAG_SEQUENTIAL_SCAN     = 0x08000000,
  FILE_FLAG_DELETE_ON_CLOSE     = 0x04000000,
  FILE_FLAG_BACKUP_SEMANTICS    = 0x02000000,
  FILE_FLAG_POSIX_SEMANTICS     = 0x01000000,
  FILE_FLAG_OPEN_REPARSE_POINT  = 0x00200000,
  FILE_FLAG_OPEN_NO_RECALL      = 0x00100000,
  FILE_FLAG_FIRST_PIPE_INSTANCE = 0x00080000
}

enum : бцел {
  CREATE_NEW = 1,
  CREATE_ALWAYS = 2,
  OPEN_EXISTING = 3,
  OPEN_ALWAYS = 4,
  TRUNCATE_EXISTING = 5
}

Укз CreateFileW(in шим* lpFileName, бцел dwDesiredAccess, бцел dwShareMode, SECURITY_ATTRIBUTES* lpSecurityAttributes, бцел dwCreationDisposition, бцел dwFlagsAndAttributes, Укз hTemplateFile);
alias CreateFileW CreateFile;

цел WriteFile(Укз hFile, in ук lpBuffer, бцел nNumberOfBytesToWrite, out бцел lpNumberOfBytesWritten, OVERLAPPED* lpOverlapped);

цел ReadFile(Укз hFile, in ук lpBuffer, бцел nNumberOfBytesToRead, out бцел lpNumberOfBytesRead, OVERLAPPED* lpOverlapped);

enum : бцел {
  FILE_BEGIN,
  FILE_CURRENT,
  FILE_END
}

бцел SetFilePointer(Укз hFile, цел lDistanceToMove, ref  бцел lpDistanceToMoveHigh, бцел dwMoveMethod);

цел SetFilePointerEx(Укз hFile, дол lDistanceToMove, out дол lpNewFilePointer, бцел dwMoveMethod);

цел GetFileSizeEx(Укз hFile, out дол lpFileSize);

цел CloseHandle(Укз hObject);

Укз GetModuleHandleW(in шим* lpModuleName);
alias GetModuleHandleW GetModuleHandle;

бцел GetModuleFileNameW(Укз hModule, шим* lpFilename, бцел nSize);
alias GetModuleFileNameW GetModuleFileName;

Укз LoadResource(Укз hModule, Укз hResInfo);

бцел SizeofResource(Укз hModule, Укз hResInfo);

ук LockResource(Укз hResData);

Укз FindResourceW(Укз hModule, in шим* lpName, in шим* lpType);
alias FindResourceW FindResource;

Укз FindResourceExW(Укз hModule, in шим* lpName, in шим* lpType, бкрат wLanguage);
alias FindResourceExW FindResourceEx;

alias цел function(Укз hModule, in шим* lpType, цел lParam) ENUMRESTYPEPROCW;
alias ENUMRESTYPEPROCW ENUMRESTYPEPROC;

цел EnumResourceTypesW(Укз hModule, ENUMRESTYPEPROCW lpEnumFunc, цел lParam);
alias EnumResourceTypesW EnumResourceTypes;

alias цел function(Укз hModule, in шим* lpType, шим* lpName, цел lParam) ENUMRESNAMEPROCW;
alias ENUMRESNAMEPROCW ENUMRESNAMEPROC;

цел EnumResourceNamesW(Укз hModule, in шим* lpType, ENUMRESNAMEPROCW lpEnumFunc, цел lParam);
alias EnumResourceNamesW EnumResourceNames;

const бцел TLS_OUT_OF_INDEXES = 0xFFFFFFFF;

бцел TlsAlloc();

цел TlsFree(бцел dwTlsIndex);

ук TlsGetValue(бцел dwTlsIndex);

цел TlsSetValue(бцел dwTlsIndex, ук lpTlsValue);

проц Sleep(бцел dwMilliseconds);

бцел SleepEx(бцел dwMilliseconds, цел bAlertable);

цел CancelIo(Укз hFile);

Укз GetCurrentProcess();

бцел GetCurrentProcessId();

Укз GetCurrentThread();

бцел GetCurrentThreadId();

Укз CreateIoCompletionPort(Укз FileHandle, Укз ExistingCompletionPort, бцел CompletionKey, бцел NumberOfConcurrentThreads);

цел GetQueuedCompletionStatus(Укз CompletionPort, out бцел lpNumberOfBytes, out бцел lpCompletionKey, out OVERLAPPED* lpOverlapped, бцел dwMilliseconds);

const бцел INFINITE = 0xFFFFFFFF;

enum : бцел {
  WAIT_OBJECT_0 = 0,
  WAIT_ABANDONED = 0x80,
  WAIT_ABANDONED_0 = 0x80,
  WAIT_TIMEOUT = 258
}

бцел WaitForSingleObject(Укз hHandle, бцел dwMilliseconds);

бцел WaitForSingleObjectEx(Укз hHandle, бцел dwMilliseconds, BOOL bAlertable);

бцел WaitForMultipleObjects(бцел nCount, in Укз* lpHandles, BOOL bWaitAll, бцел dwMilliseconds);

бцел WaitForMultipleObjectsEx(бцел nCount, in Укз* lpHandles, BOOL bWaitAll, бцел dwMilliseconds, BOOL bAlertable);

бцел SignalObjectAndWait(Укз hObjectToSignal, Укз hObjectToWaitOn, бцел dwMilliseconds, BOOL bAlertable);

enum : бцел {
  QS_KEY             = 0x0001,
  QS_MOUSEMOVE       = 0x0002,
  QS_MOUSEBUTTON     = 0x0004,
  QS_POSTMESSAGE     = 0x0008,
  QS_TIMER           = 0x0010,
  QS_PAINT           = 0x0020,
  QS_SENDMESSAGE     = 0x0040,
  QS_HOTKEY          = 0x0080,
  QS_ALLPOSTMESSAGE  = 0x0100,
  QS_MOUSE           = QS_MOUSEMOVE | QS_MOUSEBUTTON,
  QS_INPUT           = QS_MOUSE | QS_KEY,
  QS_ALLEVENTS       = QS_INPUT | QS_POSTMESSAGE | QS_TIMER | QS_PAINT | QS_HOTKEY,
  QS_ALLINPUT        = QS_INPUT | QS_POSTMESSAGE | QS_TIMER | QS_PAINT | QS_HOTKEY | QS_SENDMESSAGE
}

бцел MsgWaitForMultipleObjects(бцел nCount, in Укз* pHandles, BOOL fWaitAll, бцел dwMilliseconds, бцел dwWakeMask);

enum : бцел {
  MWMO_WAITALL        = 0x0001,
  MWMO_ALERTABLE      = 0x0002,
  MWMO_INPUTAVAILABLE = 0x0004
}

//бцел MsgWaitForMultipleObjectsEx(бцел nCount, in Укз* pHandles, BOOL fWaitAll, бцел dwMilliseconds, бцел dwWakeMask, бцел dwFlags);

Укз CreateEventW(SECURITY_ATTRIBUTES* lpEventAttributes, цел bManualReset, цел bInitialState, in шим* lpName);
alias CreateEventW CreateEvent;

цел SetEvent(Укз hEvent);

цел ResetEvent(Укз hEvent);

Укз CreateMutexW(SECURITY_ATTRIBUTES* lpMutexAttributes, цел bInitialOwner, in шим* lpName);
alias CreateMutexW CreateMutex;

enum : бцел {
  MUTEX_MODIFY_STATE = 0x0001
}

Укз OpenMutexW(бцел dwDesiredAccess, цел bInheritHandle, in шим* lpName);
alias OpenMutexW OpenMutex;

цел ReleaseMutex(Укз hMutex);

Укз CreateSemaphoreW(SECURITY_ATTRIBUTES* lpSemaphoreAttributes, цел lInitialCount, цел lMaximumCount, in шим* lpName);
alias CreateSemaphoreW CreateSemaphore;

цел ReleaseSemaphore(Укз hSemaphore, цел lReleaseCount, out цел lpPreviousCount);

alias проц function(ук lpParameter, цел TimerOrWaitFired) WAITORTIMERCALLBACK;

цел CreateTimerQueueTimer(out Укз phNewTimer, Укз TimerQueue, WAITORTIMERCALLBACK Callback, ук Параметр, бцел DueTime, бцел Period, бцел Flags);

цел DeleteTimerQueueTimer(Укз TimerQueue, Укз Timer, Укз CompletionEvent);

цел ChangeTimerQueueTimer(Укз TimerQueue, Укз Timer, бцел DueTime, бцел Period);

struct POINT {
  цел x;
  цел y;
}

struct SIZE {
  цел cx;
  цел cy;
}

struct RECT {
  цел лево;
  цел верх;
  цел право;
  цел низ;
}

template MAKELCID(бкрат lgid, бкрат srtid) {
  const MAKELCID = (srtid << 16) | lgid;
}

template MAKELANGID(бкрат p, бкрат s) {
  const MAKELANGID = (s << 10)  | p;
}

extern бкрат SUBLANGID(бкрат lgid);

enum : бцел {
  LCID_INSTALLED       = 0x00000001,
  LCID_SUPPORTED       = 0x00000002,
  LCID_ALTERNATE_SORTS = 0x00000004
}

enum : бкрат {
  SUBLANG_NEUTRAL     = 0x00,
  SUBLANG_DEFAULT     = 0x01,
  SUBLANG_SYS_DEFAULT = 0x02,
}

enum : бкрат {
  LANG_NEUTRAL             = 0x00,
  LANG_INVARIANT           = 0x7f,
  LANG_SYSTEM_DEFAULT      = MAKELANGID!(LANG_NEUTRAL, SUBLANG_SYS_DEFAULT),
  LANG_USER_DEFAULT        = MAKELANGID!(LANG_NEUTRAL, SUBLANG_DEFAULT),

  LANG_AFRIKAANS           = 0x36,
  LANG_ALBANIAN            = 0x1c,
  LANG_ALSATIAN            = 0x84,
  LANG_AMHARIC             = 0x5e,
  LANG_ARABIC              = 0x01,
  LANG_ARMENIAN            = 0x2b,
  LANG_ASSAMESE            = 0x4d,
  LANG_AZERI               = 0x2c,
  LANG_BASHKIR             = 0x6d,
  LANG_BASQUE              = 0x2d,
  LANG_BELARUSIAN          = 0x23,
  LANG_BENGALI             = 0x45,
  LANG_BRETON              = 0x7e,
  LANG_BOSNIAN             = 0x1a,
  LANG_BOSNIAN_NEUTRAL     = 0x781a,
  LANG_BULGARIAN           = 0x02,
  LANG_CATALAN             = 0x03,
  LANG_CHINESE             = 0x04,
  LANG_CHINESE_SIMPLIFIED  = 0x04,
  LANG_CHINESE_TRADITIONAL = 0x7c04,
  LANG_CORSICAN            = 0x83,
  LANG_CROATIAN            = 0x1a,
  LANG_CZECH               = 0x05,
  LANG_DANISH              = 0x06,
  LANG_DARI                = 0x8c,
  LANG_DIVEHI              = 0x65,
  LANG_DUTCH               = 0x13,
  LANG_ENGLISH             = 0x09,
  LANG_ESTONIAN            = 0x25,
  LANG_FAEROESE            = 0x38,
  LANG_FARSI               = 0x29,
  LANG_FILIPINO            = 0x64,
  LANG_FINNISH             = 0x0b,
  LANG_FRENCH              = 0x0c,
  LANG_FRISIAN             = 0x62,
  LANG_GALICIAN            = 0x56,
  LANG_GEORGIAN            = 0x37,
  LANG_GERMAN              = 0x07,
  LANG_GREEK               = 0x08,
  LANG_GREENLANDIC         = 0x6f,
  LANG_GUJARATI            = 0x47,
  LANG_HAUSA               = 0x68,
  LANG_HEBREW              = 0x0d,
  LANG_HINDI               = 0x39,
  LANG_HUNGARIAN           = 0x0e,
  LANG_ICELANDIC           = 0x0f,
  LANG_IGBO                = 0x70,
  LANG_INDONESIAN          = 0x21,
  LANG_INUKTITUT           = 0x5d,
  LANG_IRISH               = 0x3c,
  LANG_ITALIAN             = 0x10,
  LANG_JAPANESE            = 0x11,
  LANG_KANNADA             = 0x4b,
  LANG_KASHMIRI            = 0x60,
  LANG_KAZAK               = 0x3f,
  LANG_KHMER               = 0x53,
  LANG_KICHE               = 0x86,
  LANG_KINYARWANDA         = 0x87,
  LANG_KONKANI             = 0x57,
  LANG_KOREAN              = 0x12,
  LANG_KYRGYZ              = 0x40,
  LANG_LAO                 = 0x54,
  LANG_LATVIAN             = 0x26,
  LANG_LITHUANIAN          = 0x27,
  LANG_LOWER_SORBIAN       = 0x2e,
  LANG_LUXEMBOURGISH       = 0x6e,
  LANG_MACEDONIAN          = 0x2f,
  LANG_MALAY               = 0x3e,
  LANG_MALAYALAM           = 0x4c,
  LANG_MALTESE             = 0x3a,
  LANG_MANIPURI            = 0x58,
  LANG_MAORI               = 0x81,
  LANG_MAPUDUNGUN          = 0x7a,
  LANG_MARATHI             = 0x4e,
  LANG_MOHAWK              = 0x7c,
  LANG_MONGOLIAN           = 0x50,
  LANG_NEPALI              = 0x61,
  LANG_NORWEGIAN           = 0x14,
  LANG_OCCITAN             = 0x82,
  LANG_ORIYA               = 0x48,
  LANG_PASHTO              = 0x63,
  LANG_PERSIAN             = 0x29,
  LANG_POLISH              = 0x15,
  LANG_PORTUGUESE          = 0x16,
  LANG_PUNJABI             = 0x46,
  LANG_QUECHUA             = 0x6b,
  LANG_ROMANIAN            = 0x18,
  LANG_ROMANSH             = 0x17,
  LANG_RUSSIAN             = 0x19,
  LANG_SAMI                = 0x3b,
  LANG_SANSKRIT            = 0x4f,
  LANG_SERBIAN             = 0x1a,
  LANG_SERBIAN_NEUTRAL     = 0x7c1a,
  LANG_SINDHI              = 0x59,
  LANG_SINHALESE           = 0x5b,
  LANG_SLOVAK              = 0x1b,
  LANG_SLOVENIAN           = 0x24,
  LANG_SOTHO               = 0x6c,
  LANG_SPANISH             = 0x0a,
  LANG_SWAHILI             = 0x41,
  LANG_SWEDISH             = 0x1d,
  LANG_SYRIAC              = 0x5a,
  LANG_TAJIK               = 0x28,
  LANG_TAMAZIGHT           = 0x5f,
  LANG_TAMIL               = 0x49,
  LANG_TATAR               = 0x44,
  LANG_TELUGU              = 0x4a,
  LANG_THAI                = 0x1e,
  LANG_TIBETAN             = 0x51,
  LANG_TIGRIGNA            = 0x73,
  LANG_TSWANA              = 0x32,
  LANG_TURKISH             = 0x1f,
  LANG_TURKMEN             = 0x42,
  LANG_UIGHUR              = 0x80,
  LANG_UKRAINIAN           = 0x22,
  LANG_UPPER_SORBIAN       = 0x2e,
  LANG_URDU                = 0x20,
  LANG_UZBEK               = 0x43,
  LANG_VIETNAMESE          = 0x2a,
  LANG_WELSH               = 0x52,
  LANG_WOLOF               = 0x88,
  LANG_XHOSA               = 0x34,
  LANG_YAKUT               = 0x85,
  LANG_YI                  = 0x78,
  LANG_YORUBA              = 0x6a,
  LANG_ZULU                = 0x35
}

enum : бкрат {
  SORT_DEFAULT = 0x0
}

enum : бцел {
  LOCALE_USER_DEFAULT   = MAKELCID!(LANG_USER_DEFAULT, SORT_DEFAULT),
  LOCALE_SYSTEM_DEFAULT = MAKELCID!(LANG_SYSTEM_DEFAULT, SORT_DEFAULT),
  LOCALE_NEUTRAL        = MAKELCID!(MAKELANGID!(LANG_NEUTRAL, SUBLANG_NEUTRAL), SORT_DEFAULT),
  LOCALE_INVARIANT      = MAKELCID!(MAKELANGID!(LANG_INVARIANT, SUBLANG_NEUTRAL), SORT_DEFAULT)
}

enum : бцел {
  LOCALE_NOUSEROVERRIDE        = 0x80000000,
  LOCALE_USE_CP_ACP            = 0x40000000,
  LOCALE_RETURN_NUMBER         = 0x20000000,
  LOCALE_ILANGUAGE             = 0x00000001,
  LOCALE_SLANGUAGE             = 0x00000002,
  LOCALE_SENGLANGUAGE          = 0x00001001,
  LOCALE_SABBREVLANGNAME       = 0x00000003,
  LOCALE_SNATIVELANGNAME       = 0x00000004,
  LOCALE_ICOUNTRY              = 0x00000005,
  LOCALE_SCOUNTRY              = 0x00000006,
  LOCALE_SENGCOUNTRY           = 0x00001002,
  LOCALE_SABBREVCTRYNAME       = 0x00000007,
  LOCALE_SNATIVECTRYNAME       = 0x00000008,
  LOCALE_IGEOID                = 0x0000005B,
  LOCALE_IDEFAULTLANGUAGE      = 0x00000009,
  LOCALE_IDEFAULTCOUNTRY       = 0x0000000A,
  LOCALE_IDEFAULTCODEPAGE      = 0x0000000B,
  LOCALE_IDEFAULTANSICODEPAGE  = 0x00001004,
  LOCALE_IDEFAULTMACCODEPAGE   = 0x00001011,
  LOCALE_SLIST                 = 0x0000000C,
  LOCALE_IMEASURE              = 0x0000000D,
  LOCALE_SDECIMAL              = 0x0000000E,
  LOCALE_STHOUSAND             = 0x0000000F,
  LOCALE_SGROUPING             = 0x00000010,
  LOCALE_IDIGITS               = 0x00000011,
  LOCALE_ILZERO                = 0x00000012,
  LOCALE_INEGNUMBER            = 0x00001010,
  LOCALE_SNATIVEDIGITS         = 0x00000013,
  LOCALE_SCURRENCY             = 0x00000014,
  LOCALE_SINTLSYMBOL           = 0x00000015,
  LOCALE_SMONDECIMALSEP        = 0x00000016,
  LOCALE_SMONTHOUSANDSEP       = 0x00000017,
  LOCALE_SMONGROUPING          = 0x00000018,
  LOCALE_ICURRDIGITS           = 0x00000019,
  LOCALE_IINTLCURRDIGITS       = 0x0000001A,
  LOCALE_ICURRENCY             = 0x0000001B,
  LOCALE_INEGCURR              = 0x0000001C,
  LOCALE_SDATE                 = 0x0000001D,
  LOCALE_STIME                 = 0x0000001E,
  LOCALE_SSHORTDATE            = 0x0000001F,
  LOCALE_SLONGDATE             = 0x00000020,
  LOCALE_STIMEFORMAT           = 0x00001003,
  LOCALE_IDATE                 = 0x00000021,
  LOCALE_ILDATE                = 0x00000022,
  LOCALE_ITIME                 = 0x00000023,
  LOCALE_ITIMEMARKPOSN         = 0x00001005,
  LOCALE_ICENTURY              = 0x00000024,
  LOCALE_ITLZERO               = 0x00000025,
  LOCALE_IDAYLZERO             = 0x00000026,
  LOCALE_IMONLZERO             = 0x00000027,
  LOCALE_S1159                 = 0x00000028,
  LOCALE_S2359                 = 0x00000029,
  LOCALE_ICALENDARTYPE         = 0x00001009,
  LOCALE_IOPTIONALCALENDAR     = 0x0000100B,
  LOCALE_IFIRSTDAYOFWEEK       = 0x0000100C,
  LOCALE_IFIRSTWEEKOFYEAR      = 0x0000100D,
  LOCALE_SDAYNAME1             = 0x0000002A,
  LOCALE_SDAYNAME2             = 0x0000002B,
  LOCALE_SDAYNAME3             = 0x0000002C,
  LOCALE_SDAYNAME4             = 0x0000002D,
  LOCALE_SDAYNAME5             = 0x0000002E,
  LOCALE_SDAYNAME6             = 0x0000002F,
  LOCALE_SDAYNAME7             = 0x00000030,
  LOCALE_SABBREVDAYNAME1       = 0x00000031,
  LOCALE_SABBREVDAYNAME2       = 0x00000032,
  LOCALE_SABBREVDAYNAME3       = 0x00000033,
  LOCALE_SABBREVDAYNAME4       = 0x00000034,
  LOCALE_SABBREVDAYNAME5       = 0x00000035,
  LOCALE_SABBREVDAYNAME6       = 0x00000036,
  LOCALE_SABBREVDAYNAME7       = 0x00000037,
  LOCALE_SMONTHNAME1           = 0x00000038,
  LOCALE_SMONTHNAME2           = 0x00000039,
  LOCALE_SMONTHNAME3           = 0x0000003A,
  LOCALE_SMONTHNAME4           = 0x0000003B,
  LOCALE_SMONTHNAME5           = 0x0000003C,
  LOCALE_SMONTHNAME6           = 0x0000003D,
  LOCALE_SMONTHNAME7           = 0x0000003E,
  LOCALE_SMONTHNAME8           = 0x0000003F,
  LOCALE_SMONTHNAME9           = 0x00000040,
  LOCALE_SMONTHNAME10          = 0x00000041,
  LOCALE_SMONTHNAME11          = 0x00000042,
  LOCALE_SMONTHNAME12          = 0x00000043,
  LOCALE_SMONTHNAME13          = 0x0000100E,
  LOCALE_SABBREVMONTHNAME1     = 0x00000044,
  LOCALE_SABBREVMONTHNAME2     = 0x00000045,
  LOCALE_SABBREVMONTHNAME3     = 0x00000046,
  LOCALE_SABBREVMONTHNAME4     = 0x00000047,
  LOCALE_SABBREVMONTHNAME5     = 0x00000048,
  LOCALE_SABBREVMONTHNAME6     = 0x00000049,
  LOCALE_SABBREVMONTHNAME7     = 0x0000004A,
  LOCALE_SABBREVMONTHNAME8     = 0x0000004B,
  LOCALE_SABBREVMONTHNAME9     = 0x0000004C,
  LOCALE_SABBREVMONTHNAME10    = 0x0000004D,
  LOCALE_SABBREVMONTHNAME11    = 0x0000004E,
  LOCALE_SABBREVMONTHNAME12    = 0x0000004F,
  LOCALE_SABBREVMONTHNAME13    = 0x0000100F,
  LOCALE_SPOSITIVESIGN         = 0x00000050,
  LOCALE_SNEGATIVESIGN         = 0x00000051,
  LOCALE_IPOSSIGNPOSN          = 0x00000052,
  LOCALE_INEGSIGNPOSN          = 0x00000053,
  LOCALE_IPOSSYMPRECEDES       = 0x00000054,
  LOCALE_IPOSSEPBYSPACE        = 0x00000055,
  LOCALE_INEGSYMPRECEDES       = 0x00000056,
  LOCALE_INEGSEPBYSPACE        = 0x00000057,
  LOCALE_FONTSIGNATURE         = 0x00000058,
  LOCALE_SISO639LANGNAME       = 0x00000059,
  LOCALE_SISO3166CTRYNAME      = 0x0000005A,
  LOCALE_IDEFAULTEBCDICCODEPAGE= 0x00001012,
  LOCALE_IPAPERSIZE            = 0x0000100A,
  LOCALE_SENGCURRNAME          = 0x00001007,
  LOCALE_SNATIVECURRNAME       = 0x00001008,
  LOCALE_SYEARMONTH            = 0x00001006,
  LOCALE_SSORTNAME             = 0x00001013,
  LOCALE_IDIGITSUBSTITUTION    = 0x00001014,
  LOCALE_SNAME                 = 0x0000005c,
  LOCALE_SDURATION             = 0x0000005d,
  LOCALE_SKEYBOARDSTOINSTALL   = 0x0000005e,
  LOCALE_SSHORTESTDAYNAME1     = 0x00000060,
  LOCALE_SSHORTESTDAYNAME2     = 0x00000061,
  LOCALE_SSHORTESTDAYNAME3     = 0x00000062,
  LOCALE_SSHORTESTDAYNAME4     = 0x00000063,
  LOCALE_SSHORTESTDAYNAME5     = 0x00000064,
  LOCALE_SSHORTESTDAYNAME6     = 0x00000065,
  LOCALE_SSHORTESTDAYNAME7     = 0x00000066,
  LOCALE_SISO639LANGNAME2      = 0x00000067,
  LOCALE_SISO3166CTRYNAME2     = 0x00000068,
  LOCALE_SNAN                  = 0x00000069,
  LOCALE_SPOSINFINITY          = 0x0000006a,
  LOCALE_SNEGINFINITY          = 0x0000006b,
  LOCALE_SSCRIPTS              = 0x0000006c,
  LOCALE_SPARENT               = 0x0000006d,
  LOCALE_SCONSOLEFALLBACKNAME  = 0x0000006e,
  LOCALE_SLANGDISPLAYNAME      = 0x0000006f
}

цел GetLocaleInfoW(бцел Locale, бцел LCType, шим* lpLCData, цел cchData);
alias GetLocaleInfoW GetLocaleInfo;

alias цел function(шим*) LOCALE_ENUMPROCW;
alias LOCALE_ENUMPROCW LOCALE_ENUMPROC;

цел EnumSystemLocalesW(LOCALE_ENUMPROCW lpLocaleEnumProc, бцел dwFlags);
alias EnumSystemLocalesW EnumSystemLocales;

enum : бцел {
  CAL_NOUSEROVERRIDE     = LOCALE_NOUSEROVERRIDE,
  CAL_ICALINTVALUE       = 0x00000001,
  CAL_SCALNAME           = 0x00000002,
  CAL_IYEAROFFSETRANGE   = 0x00000003,
  CAL_SERASTRING         = 0x00000004,
  CAL_SSHORTDATE         = 0x00000005,
  CAL_SLONGDATE          = 0x00000006,
  CAL_SDAYNAME1          = 0x00000007,
  CAL_SDAYNAME2          = 0x00000008,
  CAL_SDAYNAME3          = 0x00000009,
  CAL_SDAYNAME4          = 0x0000000a,
  CAL_SDAYNAME5          = 0x0000000b,
  CAL_SDAYNAME6          = 0x0000000c,
  CAL_SDAYNAME7          = 0x0000000d,
  CAL_SABBREVDAYNAME1    = 0x0000000e,
  CAL_SABBREVDAYNAME2    = 0x0000000f,
  CAL_SABBREVDAYNAME3    = 0x00000010,
  CAL_SABBREVDAYNAME4    = 0x00000011,
  CAL_SABBREVDAYNAME5    = 0x00000012,
  CAL_SABBREVDAYNAME6    = 0x00000013,
  CAL_SABBREVDAYNAME7    = 0x00000014,
  CAL_SMONTHNAME1        = 0x00000015,
  CAL_SMONTHNAME2        = 0x00000016,
  CAL_SMONTHNAME3        = 0x00000017,
  CAL_SMONTHNAME4        = 0x00000018,
  CAL_SMONTHNAME5        = 0x00000019,
  CAL_SMONTHNAME6        = 0x0000001a,
  CAL_SMONTHNAME7        = 0x0000001b,
  CAL_SMONTHNAME8        = 0x0000001c,
  CAL_SMONTHNAME9        = 0x0000001d,
  CAL_SMONTHNAME10       = 0x0000001e,
  CAL_SMONTHNAME11       = 0x0000001f,
  CAL_SMONTHNAME12       = 0x00000020,
  CAL_SMONTHNAME13       = 0x00000021,
  CAL_SABBREVMONTHNAME1  = 0x00000022,
  CAL_SABBREVMONTHNAME2  = 0x00000023,
  CAL_SABBREVMONTHNAME3  = 0x00000024,
  CAL_SABBREVMONTHNAME4  = 0x00000025,
  CAL_SABBREVMONTHNAME5  = 0x00000026,
  CAL_SABBREVMONTHNAME6  = 0x00000027,
  CAL_SABBREVMONTHNAME7  = 0x00000028,
  CAL_SABBREVMONTHNAME8  = 0x00000029,
  CAL_SABBREVMONTHNAME9  = 0x0000002a,
  CAL_SABBREVMONTHNAME10 = 0x0000002b,
  CAL_SABBREVMONTHNAME11 = 0x0000002c,
  CAL_SABBREVMONTHNAME12 = 0x0000002d,
  CAL_SABBREVMONTHNAME13 = 0x0000002e,
  CAL_SYEARMONTH         = 0x0000002f,
  CAL_ITWODIGITYEARMAX   = 0x00000030,
  CAL_SSHORTESTDAYNAME1  = 0x00000031,
  CAL_SSHORTESTDAYNAME2  = 0x00000032,
  CAL_SSHORTESTDAYNAME3  = 0x00000033,
  CAL_SSHORTESTDAYNAME4  = 0x00000034,
  CAL_SSHORTESTDAYNAME5  = 0x00000035,
  CAL_SSHORTESTDAYNAME6  = 0x00000036,
  CAL_SSHORTESTDAYNAME7  = 0x00000037,
  ENUM_ALL_CALENDARS     = 0xffffffff
}

enum : бцел {
  CAL_GREGORIAN              = 1,
  CAL_GREGORIAN_US           = 2,
  CAL_JAPAN                  = 3,
  CAL_TAIWAN                 = 4,
  CAL_KOREA                  = 5,
  CAL_HIJRI                  = 6,
  CAL_THAI                   = 7,
  CAL_HEBREW                 = 8,
  CAL_GREGORIAN_ME_FRENCH    = 9,
  CAL_GREGORIAN_ARABIC       = 10,
  CAL_GREGORIAN_XLIT_ENGLISH = 11,
  CAL_GREGORIAN_XLIT_FRENCH  = 12,
  CAL_UMALQURA               = 23 // Vista+
}

цел GetCalendarInfoW(бцел Locale, бцел Календарь, бцел CalType, шим* lpCalData, цел cchData, бцел* lpValue);
alias GetCalendarInfoW GetCalendarInfo;

цел SetCalendarInfoW(бцел Locale, бцел Календарь, бцел CalType, шим* lpCalData);
alias SetCalendarInfoW SetCalendarInfo;

enum : бцел {
  DATE_SHORTDATE        = 0x00000001,
  DATE_LONGDATE         = 0x00000002,
  DATE_USE_ALT_CALENDAR = 0x00000004
}

цел GetDateFormatW(бцел Locale, бцел dwFlags, SYSTEMTIME* lpDate, in шим* lpFormat, шим* lpDateStr, цел cchDate);
alias GetDateFormatW GetDateFormat;

enum : бцел {
  GEO_NATION            = 0x0001,
  GEO_LATITUDE          = 0x0002,
  GEO_LONGITUDE         = 0x0003,
  GEO_ISO2              = 0x0004,
  GEO_ISO3              = 0x0005,
  GEO_RFC1766           = 0x0006,
  GEO_LCID              = 0x0007,
  GEO_FRIENDLYNAME      = 0x0008,
  GEO_OFFICIALNAME      = 0x0009,
  GEO_TIMEZONES         = 0x000A,
  GEO_OFFICIALLANGUAGES = 0x000B
}

alias цел function(шим* lpCalendarInfoString) CALINFO_ENUMPROCW;
alias цел function(шим* lpCalendarInfoString, бцел Календарь) CALINFO_ENUMPROCEXW;

цел EnumCalendarInfoW(CALINFO_ENUMPROCW lpCalInfoEnumProc, бцел Locale, бцел Календарь, бцел CalType);
alias EnumCalendarInfoW EnumCalendarInfo;

цел EnumCalendarInfoExW(CALINFO_ENUMPROCEXW lpCalInfoEnumProcEx, бцел Locale, бцел Календарь, бцел CalType);
alias EnumCalendarInfoExW EnumCalendarInfoEx;

alias цел function(шим* lpDateFormatString, бцел CalendarId) DATEFMT_ENUMPROCEXW;

цел EnumDateFormatsExW(DATEFMT_ENUMPROCEXW lpDateFmtEnumProcEx, бцел Locale, бцел dwFlags);
alias EnumDateFormatsExW EnumDateFormatsEx;

alias цел function(шим* lpTimeFormatString) TIMEFMT_ENUMPROCW;

цел EnumTimeFormatsW(TIMEFMT_ENUMPROCW lpTimeFmtEnumProc, бцел Locale, бцел dwFlags);
alias EnumTimeFormatsW EnumTimeFormats;

enum : бцел {
  TIME_ZONE_ID_INVALID = cast(бцел)0xffffffff
}

struct TIME_ZONE_INFORMATION {
  цел Bias;
  шим[32] StandardName;
  SYSTEMTIME StandardDate;
  цел StandardBias;
  шим[32] DaylightName;
  SYSTEMTIME DaylightDate;
  цел DaylightBias;
}

бцел GetTimeZoneInformation(out TIME_ZONE_INFORMATION lpTimeZoneInformation);

бцел GetThreadLocale();

цел SetThreadLocale(бцел Locale);

бцел GetUserDefaultLCID();

бкрат GetUserDefaultLangID();

бкрат GetSystemDefaultLangID();

enum : бцел {
  NORM_IGNORECASE          = 0x00000001,
  NORM_IGNORENONSPACE      = 0x00000002,
  NORM_IGNORESYMBOLS       = 0x00000004,
  NORM_IGNOREKANATYPE      = 0x00010000,
  NORM_IGNOREWIDTH         = 0x00020000,
  NORM_LINGUISTIC_CASING   = 0x08000000
}

enum {
  CP_ACP                   = 0,
  CP_OEMCP                 = 1,
  CP_MACCP                 = 2,
  CP_THREAD_ACP            = 3,
  CP_SYMBOL                = 42,
  CP_UTF7                  = 65000,
  CP_UTF8                  = 65001
}

struct CPINFO {
  бцел MaxCharSize;
  ббайт[2] DefaultChar;
  ббайт[12] LeadByte;
}

цел GetCPInfo(бцел CodePage, out CPINFO lpCPInfo);

бцел GetACP();

цел CompareStringW(бцел Locale, бцел dwCmpFlags, in шим* lpString1, цел cchCount1, in шим* lpString2, цел cchCount2);
alias CompareStringW CompareString;

enum : бцел {
  LCMAP_LOWERCASE           = 0x00000100,
  LCMAP_UPPERCASE           = 0x00000200,
  LCMAP_SORTKEY             = 0x00000400,
  LCMAP_BYTEREV             = 0x00000800,
  LCMAP_HIRAGANA            = 0x00100000,
  LCMAP_KATAKANA            = 0x00200000,
  LCMAP_HALFWIDTH           = 0x00400000,
  LCMAP_FULLWIDTH           = 0x00800000,
  LCMAP_LINGUISTIC_CASING   = 0x01000000,
  LCMAP_SIMPLIFIED_CHINESE  = 0x02000000,
  LCMAP_TRADITIONAL_CHINESE = 0x04000000
}

цел LCMapStringW(бцел Locale, бцел dwMapFlags, in шим* lpSrcStr, цел cchSrc, шим* lpDestStr, цел cchDest);
alias LCMapStringW LCMapString;

цел MultiByteToWideChar(бцел CodePage, бцел dwFlags, in сим* lpMultiByteStr, цел cbMultiByte, шим* lpWideCharStr, цел cchWideChar);

enum : бцел {
  WC_DISCARDNS = 0x00000010,
  WC_SEPCHARS = 0x00000020,
  WC_DEFAULTCHAR = 0x00000040,
  WC_COMPOSITECHECK = 0x00000200
}

цел WideCharToMultiByte(бцел CodePage, бцел dwFlags, in шим* lpWideCharStr, цел cchWideChar, сим* lpMultiByteStr, цел cbMultiByte, сим* lpDefaultChar, цел* lpUseDefaultChar);

цел InterlockedIncrement(ref  цел Addend);

цел InterlockedDecrement(ref  цел Addend);

struct ACL {
  ббайт AclRevision;
  ббайт Sbsz1;
  бкрат AclSize;
  бкрат AceCount;
  бкрат Sbsz2;
}

struct SECURITY_DESCRIPTOR {
  ббайт Revision;
  ббайт Sbz1;
  бкрат УпрЭлт;
  ук Owner;
  ук Group;
  ACL* Sacl;
  ACL* Dacl;
}

struct COAUTHIDENTITY {
  шим* User;
  бцел UserLength;
  шим* Domain;
  бцел DomainLength;
  шим* Password;
  бцел PasswordLength;
  бцел Flags;
}

struct COAUTHINFO {
  бцел dwAuthnSvc;
  бцел dwAuthzSvc;
  шим* pwszServerPrincName;
  бцел dwAuthnLevel;
  бцел dwImpersonationLevel;
  COAUTHIDENTITY* pAuthIdentityData;
  бцел dwCapabilities;
}

enum : бцел {
  FILE_ATTRIBUTE_READONLY            = 0x00000001,
  FILE_ATTRIBUTE_HIDDEN              = 0x00000002,
  FILE_ATTRIBUTE_SYSTEM              = 0x00000004,
  FILE_ATTRIBUTE_DIRECTORY           = 0x00000010,
  FILE_ATTRIBUTE_ARCHIVE             = 0x00000020,
  FILE_ATTRIBUTE_DEVICE              = 0x00000040,
  FILE_ATTRIBUTE_NORMAL              = 0x00000080,
  FILE_ATTRIBUTE_TEMPORARY           = 0x00000100,
  FILE_ATTRIBUTE_SPARSE_FILE         = 0x00000200,
  FILE_ATTRIBUTE_REPARSE_POINT       = 0x00000400,
  FILE_ATTRIBUTE_COMPRESSED          = 0x00000800,
  FILE_ATTRIBUTE_OFFLINE             = 0x00001000,
  FILE_ATTRIBUTE_NOT_CONTENT_INDEXED = 0x00002000,
  FILE_ATTRIBUTE_ENCRYPTED           = 0x00004000,
  FILE_ATTRIBUTE_VIRTUAL             = 0x00010000
}

цел FindClose(Укз hFindFile);

struct WIN32_FIND_DATAW {
  бцел dwFileAttributes;
  FILETIME ftCreationTime;
  FILETIME ftLastAccessTime;
  FILETIME ftLastWriteTime;
  бцел nFileSizeHigh;
  бцел nFileSizeLow;
  бцел dwReserved0;
  бцел dwReserved1;
  шим[MAX_PATH] cFileName;
  шим[14] cAlternateFileName;
}
alias WIN32_FIND_DATAW WIN32_FIND_DATA;

Укз FindFirstFileW(in шим* lpFileName, out WIN32_FIND_DATA lpFileFileData);
alias FindFirstFileW FindFirstFile;

цел FindNextFileW(Укз hFindFile, out WIN32_FIND_DATA lpFindFileData);
alias FindNextFileW FindNextFile;

struct WIN32_FILE_ATTRIBUTE_DATA {
  бцел dwFileAttributes;
  FILETIME ftCreationTime;
  FILETIME ftLastAccessTime;
  FILETIME ftLastWriteTime;
  бцел nFileSizeHigh;
  бцел nFileSizeLow;
}

enum : бцел {
  STD_INPUT_HANDLE = -10,
  STD_OUTPUT_HANDLE = -11,
  STD_ERROR_HANDLE = -12
}

Укз GetStdHandle(бцел nStdHandle);

struct COORD {
  крат X;
  крат Y;
}

struct SMALL_RECT {
  крат Left;
  крат Top;
  крат Right;
  крат Bottom;
}

struct CONSOLE_SCREEN_BUFFER_INFO {
  COORD dwSize;
  COORD dwCursorPosition;
  бкрат wAttributes;
  SMALL_RECT srWindow;
  COORD dwMaximumWindowSize;
}

enum : бкрат {
  FOREGROUND_BLUE      = 0x0001,
  FOREGROUND_GREEN     = 0x0002,
  FOREGROUND_RED       = 0x0004,
  FOREGROUND_INTENSITY = 0x0008,
  FOREGROUND_MASK      = 0x000F,
  BACKGROUND_BLUE      = 0x0010,
  BACKGROUND_GREEN     = 0x0020,
  BACKGROUND_RED       = 0x0040,
  BACKGROUND_INTENSITY = 0x0080,
  BACKGROUND_MASK      = 0x00F0
}

цел GetConsoleScreenBufferInfo(Укз hConsoleOutput, out CONSOLE_SCREEN_BUFFER_INFO lpConsoleScreenBufferInfo);

цел SetConsoleWindowInfo(Укз hConsoleOutput, цел bAbsolute, ref  SMALL_RECT lpConsoleWindow);

цел SetConsoleScreenBufferSize(Укз hConsoleOutput, COORD dwSize);

цел SetConsoleTextAttribute(Укз hConsoleOutput, бкрат wAttributes);

цел FillConsoleOutputCharacterW(Укз hConsoleOutput, шим cCharacter, бцел nLength, COORD dwWriteCoord, out бцел lpNumberOfCharsWritten);
alias FillConsoleOutputCharacterW FillConsoleOutputCharacter;

цел FillConsoleOutputAttribute(Укз hConsoleOutput, бкрат wAttribute, цел nLength, COORD dwWriteCoord, out бцел lpNumberOfAttrsWritten);

цел SetConsoleCursorPosition(Укз hConsoleOutput, COORD dwCursorPosition);

бцел GetConsoleTitleW(шим* lpConsoleTitle, бцел nSize);
alias GetConsoleTitleW GetConsoleTitle;

цел SetConsoleTitleW(in шим* lpConsoleTitle);
alias SetConsoleTitleW SetConsoleTitle;

бцел GetConsoleOutputCP();

цел SetConsoleOutputCP(бцел wCodePageID);

// wFunc
enum : бцел {
  FO_MOVE                   = 0x0001,
  FO_COPY                   = 0x0002,
  FO_DELETE                 = 0x0003,
  FO_RENAME                 = 0x0004
}

// fFlags
enum : бцел {
  FOF_MULTIDESTFILES        = 0x0001,
  FOF_CONFIRMMOUSE          = 0x0002,
  FOF_SILENT                = 0x0004,
  FOF_RENAMEONCOLLISION     = 0x0008,
  FOF_NOCONFIRMATION        = 0x0010,
  FOF_WANTMAPPINGHANDLE     = 0x0020,
  FOF_ALLOWUNDO             = 0x0040,
  FOF_FILESONLY             = 0x0080,
  FOF_SIMPLEPROGRESS        = 0x0100,
  FOF_NOCONFIRMMKDIR        = 0x0200,
  FOF_NOERRORUI             = 0x0400,
  FOF_NOCOPYSECURITYATTRIBS = 0x0800,
  FOF_NORECURSION           = 0x1000,
  FOF_NO_CONNECTED_ELEMENTS = 0x2000,
  FOF_WANTNUKEWARNING       = 0x4000,
  FOF_NORECURSEREPARSE      = 0x8000
}

struct SHFILEOPSTRUCTW {
  Укз hwnd;
  бцел wFunc;
  version(D_Version2) {
    mixin("
    const(шим)* pFrom;
    const(шим)* pTo;
    ");
  }
  else {
    шим* pFrom;
    шим* pTo;
  }
  бцел fFlags;
  BOOL fAnyOperationsAborted;
  ук hNameMappings;
  шим* lpszProgressTitle;
}
alias SHFILEOPSTRUCTW SHFILEOPSTRUCT;

цел SHFileOperationW(ref  SHFILEOPSTRUCTW lpFileOp);
alias SHFileOperationW SHFileOperation;

цел SetFileAttributesW(in шим* lpFileName, бцел dwFileAttributes);
alias SetFileAttributesW SetFileAttributes;

цел GetFileAttributesExW(in шим* lpFileName, цел fInfoLevelId, ref  WIN32_FILE_ATTRIBUTE_DATA lpFileInformation);
alias GetFileAttributesExW GetFileAttributesEx;

enum : бцел {
  REPLACEFILE_WRITE_THROUGH       = 0x00000001,
  REPLACEFILE_IGNORE_MERGE_ERRORS = 0x00000002,
  REPLACEFILE_IGNORE_ACL_ERRORS   = 0x00000004
}

цел ReplaceFileW(in шим* lpReplacedFileName, in шим* lpReplacementFileName, in шим* lpBackupFileName, бцел dwReplaceFlags, ук lpExclude, ук lpReserved);
alias ReplaceFileW ReplaceFile;

бцел GetCurrentDirectoryW(бцел nBufferLength, шим* lpBuffer);
alias GetCurrentDirectoryW GetCurrentDirectory;

бцел GetSystemDirectoryW(шим* lpBuffer, бцел nSize);
alias GetSystemDirectoryW GetSystemDirectory;

цел CreateDirectoryW(in шим* lpPathName, SECURITY_ATTRIBUTES* lpSecurityAttributes);
alias CreateDirectoryW CreateDirectory;

цел GetDiskFreeSpaceExW(in шим* lpDirectoryName, ref  бдол lpFreeBytesAvailable, ref  бдол lpTotalNumberOfBytes, ref  бдол lpTotalNumberOfFreeBytes);
alias GetDiskFreeSpaceExW GetDiskFreeSpaceEx;

цел GetVolumeInformationW(in шим* lpRootPathName, шим* lpVolumeNameBuffer, бцел nVolumeNameSize, out бцел lpVolumeSerialNumber, out бцел lpMaximumComponentLength, out бцел lpFileSystemFlags, шим* lpFileSystemNameBuffer, бцел nFileSystemNameSize);
alias GetVolumeInformationW GetVolumeInformation;

цел SetVolumeLabelW(in шим* lpRootPathName, in шим* lpVolumeName);
alias SetVolumeLabelW SetVolumeLabel;

бцел GetLogicalDrives();

alias проц function(бцел dwErrorCode, бцел dwNumberOfBytesTransferred, OVERLAPPED* lpOverlapped) LPOVERLAPPED_COMPLETION_ROUTINE;

enum : бцел {
  FILE_NOTIFY_CHANGE_FILE_NAME   = 0x00000001,
  FILE_NOTIFY_CHANGE_DIR_NAME    = 0x00000002,
  FILE_NOTIFY_CHANGE_ATTRIBUTES  = 0x00000004,
  FILE_NOTIFY_CHANGE_SIZE        = 0x00000008,
  FILE_NOTIFY_CHANGE_LAST_WRITE  = 0x00000010,
  FILE_NOTIFY_CHANGE_LAST_ACCESS = 0x00000020,
  FILE_NOTIFY_CHANGE_CREATION    = 0x00000040,
  FILE_NOTIFY_CHANGE_SECURITY    = 0x00000100
}

enum : бцел {
  FILE_ACTION_ADDED            = 0x00000001,
  FILE_ACTION_REMOVED          = 0x00000002,
  FILE_ACTION_MODIFIED         = 0x00000003,
  FILE_ACTION_RENAMED_OLD_NAME = 0x00000004,
  FILE_ACTION_RENAMED_NEW_NAME = 0x00000005
}

struct FILE_NOTIFY_INFORMATION {
  бцел NextEntryOffset;
  бцел Действие;
  бцел FileNameLength;
  шим[1] FileName;
}

цел ReadDirectoryChangesW(Укз hDirectory, ук lpBuffer, бцел nBufferLength, цел bWatchSubtree, бцел dwNotifyFiler, бцел* lpdwBytesReturned, OVERLAPPED* lpOverlapped, LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine);

цел GetOverlappedResult(Укз hFile, OVERLAPPED* lpOverlapped, ref  бцел lpNumberOfBytesTransferred, цел bWait);

цел DeleteFileW(in шим* lpFileName);
alias DeleteFileW DeleteFile;

цел RemoveDirectoryW(in шим* lpPathName);
alias RemoveDirectoryW RemoveDirectory;

цел MoveFileW(in шим* lpExistingFileName, in шим* lpNewFileName);
alias MoveFileW MoveFile;

цел CopyFileW(in шим* lpExistingFileName, in шим* lpNewFileName, цел bFailIfExists);
alias CopyFileW CopyFile;

цел EncryptFileW(in шим* lpFileName);
alias EncryptFileW EncryptFile;

цел DecryptFileW(in шим* lpFileName, бцел dwReserved);
alias DecryptFileW DecryptFile;

бцел GetTempPathW(бцел nBufferLength, шим* lpBuffer);
alias GetTempPathW GetTempPath;

бцел GetTempFileNameW(in шим* lpPathName, in шим* lpPrefixString, бцел uUnique, шим* lpTempFileName);
alias GetTempFileNameW GetTempFileName;

бцел GetFullPathNameW(in шим* lpFileName, бцел nBufferLength, шим* lpBuffer, шим** lpFilePart);
alias GetFullPathNameW GetFullPathName;

бцел GetLongPathNameW(in шим* lpszShortPath, шим* lpszLongPath, бцел cchBuffer);
alias GetLongPathNameW GetLongPathName;

цел GetComputerNameW(in шим* lpBuffer, ref  бцел nSize);
alias GetComputerNameW GetComputerName;

цел SetComputerNameW(in шим* lpComputerName);
alias SetComputerNameW SetComputerName;

цел GetUserNameW(in шим* lpBuffer, ref  бцел nSize);
alias GetUserNameW GetUserName;

шим* GetCommandLineW();
alias GetCommandLineW GetCommandLine;

шим** CommandLineToArgvW(in шим* lpCmdLine, out цел pNumArgs);
alias CommandLineToArgvW CommandLineToArgv;

version(D_Version2) {
  enum : Укз {
    HKEY_CLASSES_ROOT     = cast(Укз)0x80000000,
    HKEY_CURRENT_USER     = cast(Укз)0x80000001,
    HKEY_LOCAL_MACHINE    = cast(Укз)0x80000002,
    HKEY_USERS            = cast(Укз)0x80000003,
    HKEY_PERFORMANCE_DATA = cast(Укз)0x80000004,
    HKEY_CURRENT_CONFIG   = cast(Укз)0x80000005,
    HKEY_DYN_DATA         = cast(Укз)0x80000006
  }
}
else {
  extern Укз HKEY_CLASSES_ROOT;
  extern Укз HKEY_CURRENT_USER;
  extern Укз HKEY_LOCAL_MACHINE;
  extern Укз HKEY_USERS;
  extern Укз HKEY_PERFORMANCE_DATA;
  extern Укз HKEY_CURRENT_CONFIG;
  extern Укз HKEY_DYN_DATA;
}

enum : бцел {
  DELETE                          = 0x00010000,
  READ_CONTROL                    = 0x00020000,
  WRITE_DAC                       = 0x00040000,
  WRITE_OWNER                     = 0x00080000,
  SYNCHRONIZE                     = 0x00100000,
  STANDARD_RIGHTS_REQUIRED        = 0x000F0000,
  STANDARD_RIGHTS_READ            = READ_CONTROL,
  STANDARD_RIGHTS_WRITE           = READ_CONTROL,
  STANDARD_RIGHTS_EXECUTE         = READ_CONTROL,
  STANDARD_RIGHTS_ALL             = 0x001F0000,
  SPECIFIC_RIGHTS_ALL             = 0x0000FFFF
}

enum : бцел {
  KEY_QUERY_VALUE        = 0x0001,
  KEY_SET_VALUE          = 0x0002,
  KEY_CREATE_SUB_KEY     = 0x0004,
  KEY_ENUMERATE_SUB_KEYS = 0x0008,
  KEY_NOTIFY             = 0x0010,
  KEY_CREATE_LINK        = 0x0020,

  KEY_READ               = (STANDARD_RIGHTS_READ | KEY_QUERY_VALUE | KEY_ENUMERATE_SUB_KEYS | KEY_NOTIFY) & ~SYNCHRONIZE,
  KEY_WRITE              = (STANDARD_RIGHTS_WRITE | KEY_SET_VALUE | KEY_CREATE_SUB_KEY) & ~SYNCHRONIZE,
  KEY_EXECUTE            = KEY_READ & ~SYNCHRONIZE,
  KEY_ALL_ACCESS         = (STANDARD_RIGHTS_ALL | KEY_QUERY_VALUE | KEY_SET_VALUE | KEY_CREATE_SUB_KEY | KEY_ENUMERATE_SUB_KEYS | KEY_NOTIFY | KEY_CREATE_LINK) & ~SYNCHRONIZE,
}

enum : бцел {
  REG_NONE                        = 0,
  REG_SZ                          = 1,
  REG_EXPAND_SZ                   = 2,
  REG_BINARY                      = 3,
  REG_DWORD                       = 4,
  REG_DWORD_LITTLE_ENDIAN         = 4,
  REG_DWORD_BIG_ENDIAN            = 5,
  REG_LINK                        = 6,
  REG_MULTI_SZ                    = 7,
  REG_RESOURCE_LIST               = 8,
  REG_FULL_RESOURCE_DESCRIPTOR    = 9,
  REG_RESOURCE_REQUIREMENTS_LIST  = 10,
  REG_QWORD                       = 11,
  REG_QWORD_LITTLE_ENDIAN         = 11
}

enum : бцел {
  REG_OPTION_NON_VOLATILE   = 0x00000000,
  REG_OPTION_VOLATILE       = 0x00000001,
  REG_OPTION_CREATE_LINK    = 0x00000002,
  REG_OPTION_BACKUP_RESTORE = 0x00000004,
  REG_OPTION_OPEN_LINK      = 0x00000008
}

цел RegOpenKeyExW(Укз hKey, in шим* lpSubKey, бцел ulOptions, бцел samDesired, out Укз phkResult);
alias RegOpenKeyExW RegOpenKeyEx;

цел RegCreateKeyExW(Укз hKey, in шим* lpSubKey, бцел Reserved, шим* lpClass, бцел dwOptions, бцел samDesired, SECURITY_ATTRIBUTES* lpSecurityAttributes, out Укз phkResult, out бцел lpdwDisposition);
alias RegCreateKeyExW RegCreateKeyEx;

цел RegQueryValueExW(Укз hKey, in шим* lpValueName, бцел* lpReserved, бцел* lpdwType, ббайт* lpData, бцел* lpcbData);
alias RegQueryValueExW RegQueryValueEx;

цел RegQueryInfoKeyW(Укз hKey, шим* lpClass, бцел* lpcchClass, бцел* lpReserved, бцел* lpcSubKeys, бцел* lpcbMaxSubKeyLen, бцел* lpcbMaxClassLen, бцел* lpcValues, бцел* lpcbMaxValueNameLen, бцел* lpcbMaxValueLen, бцел* lpcbSecurityDescriptor, FILETIME* lpftLastWriteTime);
alias RegQueryInfoKeyW RegQueryInfoKey;

цел RegEnumValueW(Укз hKey, бцел dwIndex, шим* lpValueName, ref  бцел lpcchValueName, бцел* lpReserved, бцел* lpType, ббайт* lpData, бцел* lpcbData);
alias RegEnumValueW RegEnumValue;

цел RegEnumKeyExW(Укз hKey, бцел dwIndex, шим* lpName, ref  бцел lpcchName, бцел* lpReserved, шим* lpClass, бцел* lpcchClass, FILETIME* lpftLastWriteTime);
alias RegEnumKeyExW RegEnumKeyEx;

цел RegSetValueExW(Укз hKey, in шим* lpValueName, бцел Reserved, бцел dwType, in ббайт* lpData, бцел cbData);
alias RegSetValueExW RegSetValueEx;

цел RegDeleteKeyW(Укз hKey, in шим* lpSubKey);
alias RegDeleteKeyW RegDeleteKey;

цел RegDeleteValueW(Укз hKey, in шим* lpValueName);
alias RegDeleteValueW RegDeleteValue;

цел RegFlushKey(Укз hKey);

цел RegCloseKey(Укз hKey);

бцел ExpandEnvironmentStringsW(in шим* lpSrc, шим* lpDst, бцел nSize);
alias ExpandEnvironmentStringsW ExpandEnvironmentStrings;

цел Beep(бцел dwFreq, бцел dwDuration);

бцел GetTickCount();

цел MulDiv(цел nNumber, цел nNumerator, цел nDenominator);

enum : бцел {
  PROCESS_TERMINATE   = 0x0001,
  PROCESS_ALL_ACCESS  = STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE | 0xFFF
}

Укз OpenProcess(бцел dwDesiredAccess, BOOL bInheritHandle, бцел dwProcessId);

BOOL TerminateProcess(Укз hProcess, бцел nExitCode);

enum : бцел {
  DUPLICATE_CLOSE_SOURCE = 0x01,
  DUPLICATE_SAME_ACCESS  = 0x02
}

BOOL DuplicateHandle(Укз hSourceProcessHandle, Укз hSourceHandle, Укз hTargetProcessHandle, out Укз lpTargetHandle, бцел dwDesiredAccess, BOOL bInheritHandle, бцел dwOptions);

struct STARTUPINFOW {
  бцел cb = STARTUPINFOW.sizeof;
  шим* lpReserved;
  шим* lpDesktop;
  шим* lpTitle;
  бцел dwX;
  бцел dwY;
  бцел dwXSize;
  бцел dwYSize;
  бцел dwXCountChars;
  бцел dwYCountChars;
  бцел dwFillAttribute;
  бцел dwFlags;
  бкрат wShowWindow;
  бкрат cbReserved2;
  ббайт* lpReserved2;
  Укз hStdInput;
  Укз hStdOutput;
  Укз hStdError;
}
alias STARTUPINFOW STARTUPINFO;

struct PROCESS_INFORMATION {
  Укз hProcess;
  Укз hThread;
  бцел dwProcessId;
  бцел dwThreadId;
}

BOOL CreateProcessW(in шим* lpApplicationName, in шим* lpCommandLine, SECURITY_ATTRIBUTES* lpProcessAttributes, SECURITY_ATTRIBUTES* lpThreadAttributes, BOOL bInheritHandle, бцел dwCreationFlags, ук lpEnvironment, in шим* lpCurrentDirectory, ref  STARTUPINFOW lpStartupInfo, ref  PROCESS_INFORMATION lpProcessInformation);
alias CreateProcessW CreateProcess;

enum : бцел {
  SC_MANAGER_CONNECT            = 0x0001,
  SC_MANAGER_CREATE_SERVICE     = 0x0002,
  SC_MANAGER_ENUMERATE_SERVICE  = 0x0004,
  SC_MANAGER_LOCK               = 0x0008,
  SC_MANAGER_QUERY_LOCK_STATUS  = 0x0010,
  SC_MANAGER_MODIFY_BOOT_CONFIG = 0x0020
}

Укз OpenSCManagerW(in шим* lpMachineName, in шим* lpDatabaseName, бцел dwDesiredAccess);
alias OpenSCManagerW OpenSCManager;

enum : бцел {
  SERVICE_QUERY_CONFIG          = 0x0001,
  SERVICE_CHANGE_CONFIG         = 0x0002,
  SERVICE_QUERY_STATUS          = 0x0004,
  SERVICE_ENUMERATE_DEPENDENTS  = 0x0008,
  SERVICE_START                 = 0x0010,
  SERVICE_STOP                  = 0x0020,
  SERVICE_PAUSE_CONTINUE        = 0x0040,
  SERVICE_INTERROGATE           = 0x0080,
  SERVICE_USER_DEFINED_CONTROL  = 0x0100
}

Укз OpenServiceW(Укз hSCManager, in шим* lpServiceName, бцел dwDesiredAccess);
alias OpenServiceW OpenService;

BOOL CloseServiceHandle(Укз hSCObject);

BOOL StartServiceW(Укз hService, бцел dwNumServiceArgs, in шим** lpServiceArgVectors);
alias StartServiceW StartService;

enum : бцел {
  SERVICE_STOPPED          = 0x00000001,
  SERVICE_START_PENDING    = 0x00000002,
  SERVICE_STOP_PENDING     = 0x00000003,
  SERVICE_RUNNING          = 0x00000004,
  SERVICE_CONTINUE_PENDING = 0x00000005,
  SERVICE_PAUSE_PENDING    = 0x00000006,
  SERVICE_PAUSED           = 0x00000007
}

struct SERVICE_STATUS {
  бцел dwServiceType;
  бцел dwCurrentState;
  бцел dwControlsAccepted;
  бцел dwWin32ExitCode;
  бцел dwServiceSpecificExitCode;
  бцел dwCheckPoint;
  бцел dwWaitHint;
}

enum : бцел {
  SERVICE_CONTROL_STOP                  = 0x00000001,
  SERVICE_CONTROL_PAUSE                 = 0x00000002,
  SERVICE_CONTROL_CONTINUE              = 0x00000003,
  SERVICE_CONTROL_INTERROGATE           = 0x00000004,
  SERVICE_CONTROL_SHUTDOWN              = 0x00000005,
  SERVICE_CONTROL_PARAMCHANGE           = 0x00000006,
  SERVICE_CONTROL_NETBINDADD            = 0x00000007,
  SERVICE_CONTROL_NETBINDREMOVE         = 0x00000008,
  SERVICE_CONTROL_NETBINDENABLE         = 0x00000009,
  SERVICE_CONTROL_NETBINDDISABLE        = 0x0000000A,
  SERVICE_CONTROL_DEVICEEVENT           = 0x0000000B,
  SERVICE_CONTROL_HARDWAREPROFILECHANGE = 0x0000000C,
  SERVICE_CONTROL_POWEREVENT            = 0x0000000D,
  SERVICE_CONTROL_SESSIONCHANGE         = 0x0000000E,
  SERVICE_CONTROL_PRESHUTDOWN           = 0x0000000F
}

BOOL ControlService(Укз hService, бцел dwControl, ref  SERVICE_STATUS lpServiceStatus);

BOOL QueryServiceStatus(Укз hService, out SERVICE_STATUS lpServiceStatus);

enum : бцел {
  LOGON_WITH_PROFILE         = 0x00000001,
  LOGON_NETCREDENTIALS_ONLY  = 0x00000002,
  LOGON_ZERO_PASSWORD_BUFFER = 0x80000000
}

enum {
  CSIDL_DESKTOP                 = 0x0000,
  CSIDL_INTERNET                = 0x0001,
  CSIDL_PROGRAMS                = 0x0002,
  CSIDL_CONTROLS                = 0x0003,
  CSIDL_PRINTERS                = 0x0004,
  CSIDL_PERSONAL                = 0x0005,
  CSIDL_FAVORITES               = 0x0006,
  CSIDL_STARTUP                 = 0x0007,
  CSIDL_RECENT                  = 0x0008,
  CSIDL_SENDTO                  = 0x0009,
  CSIDL_BITBUCKET               = 0x000a,
  CSIDL_STARTMENU               = 0x000b,
  CSIDL_MYDOCUMENTS             = CSIDL_PERSONAL,
  CSIDL_MYMUSIC                 = 0x000d,
  CSIDL_MYVIDEO                 = 0x000e,
  CSIDL_DESKTOPDIRECTORY        = 0x0010,
  CSIDL_DRIVES                  = 0x0011,
  CSIDL_NETWORK                 = 0x0012,
  CSIDL_NETHOOD                 = 0x0013,
  CSIDL_FONTS                   = 0x0014,
  CSIDL_TEMPLATES               = 0x0015,
  CSIDL_COMMON_STARTMENU        = 0x0016,
  CSIDL_COMMON_PROGRAMS         = 0X0017,
  CSIDL_COMMON_STARTUP          = 0x0018,
  CSIDL_COMMON_DESKTOPDIRECTORY = 0x0019,
  CSIDL_APPDATA                 = 0x001a,
  CSIDL_PRINTHOOD               = 0x001b,
  CSIDL_LOCAL_APPDATA           = 0x001c,
  CSIDL_ALTSTARTUP              = 0x001d,
  CSIDL_COMMON_ALTSTARTUP       = 0x001e,
  CSIDL_COMMON_FAVORITES        = 0x001f,
  CSIDL_INTERNET_CACHE          = 0x0020,
  CSIDL_COOKIES                 = 0x0021,
  CSIDL_HISTORY                 = 0x0022,
  CSIDL_COMMON_APPDATA          = 0x0023,
  CSIDL_WINDOWS                 = 0x0024,
  CSIDL_SYSTEM                  = 0x0025,
  CSIDL_PROGRAM_FILES           = 0x0026,
  CSIDL_MYPICTURES              = 0x0027,
  CSIDL_PROFILE                 = 0x0028,
  CSIDL_SYSTEMX86               = 0x0029,
  CSIDL_PROGRAM_FILESX86        = 0x002a,
  CSIDL_PROGRAM_FILES_COMMON    = 0x002b,
  CSIDL_PROGRAM_FILES_COMMONX86 = 0x002c,
  CSIDL_COMMON_TEMPLATES        = 0x002d,
  CSIDL_COMMON_DOCUMENTS        = 0x002e,
  CSIDL_COMMON_ADMINTOOLS       = 0x002f,
  CSIDL_ADMINTOOLS              = 0x0030,
  CSIDL_CONNECTIONS             = 0x0031,
  CSIDL_COMMON_MUSIC            = 0x0035,
  CSIDL_COMMON_PICTURES         = 0x0036,
  CSIDL_COMMON_VIDEO            = 0x0037,
  CSIDL_RESOURCES               = 0x0038,
  CSIDL_RESOURCES_LOCALIZED     = 0x0039,
  CSIDL_COMMON_OEM_LINKS        = 0x003a,
  CSIDL_CDBURN_AREA             = 0x003b,
  CSIDL_COMPUTERSNEARME         = 0x003d,
  CSIDL_FLAG_CREATE             = 0x8000,
  CSIDL_FLAG_DONT_VERIFY        = 0x4000,
  CSIDL_FLAG_DONT_UNEXPAND      = 0x2000,
  CSIDL_FLAG_NO_ALIAS           = 0x1000,
  CSIDL_FLAG_PER_USER_INIT      = 0x0800,
  CSIDL_FLAG_MASK               = 0xFF00
}

enum : бцел {
  SHGFP_TYPE_CURRENT = 0,
  SHGFP_TYPE_DEFAULT = 1
}

цел SHGetFolderPathW(Укз hwnd, цел csidl, Укз hToken, бцел dwFlags, шим* pszPath);
alias SHGetFolderPathW SHGetFolderPath;

enum {
  SHCNE_RENAMEITEM       = 0x00000001,
  SHCNE_CREATE           = 0x00000002,
  SHCNE_DELETE           = 0x00000004,
  SHCNE_MKDIR            = 0x00000008,
  SHCNE_RMDIR            = 0x00000010,
  SHCNE_MEDIAINSERTED    = 0x00000020,
  SHCNE_MEDIAREMOVED     = 0x00000040,
  SHCNE_DRIVEREMOVED     = 0x00000080,
  SHCNE_DRIVEADD         = 0x00000100,
  SHCNE_NETSHARE         = 0x00000200,
  SHCNE_NETUNSHARE       = 0x00000400,
  SHCNE_ATTRIBUTES       = 0x00000800,
  SHCNE_UPDATEDIR        = 0x00001000,
  SHCNE_UPDATEITEM       = 0x00002000,
  SHCNE_SERVERDISCONNECT = 0x00004000,
  SHCNE_UPDATEIMAGE      = 0x00008000,
  SHCNE_DRIVEADDGUI      = 0x00010000,
  SHCNE_RENAMEFOLDER     = 0x00020000,
  SHCNE_FREESPACE        = 0x00040000,
  SHCNE_EXTENDED_EVENT   = 0x04000000,
  SHCNE_ASSOCCHANGED     = 0x08000000,
  SHCNE_DISKEVENTS       = 0x0002381F,
  SHCNE_GLOBALEVENTS     = 0x0C0581E0,
  SHCNE_ALLEVENTS        = 0x7FFFFFFF,
  SHCNE_INTERRUPT        = 0x80000000,
}

enum : бцел {
  SHCNF_IDLIST          = 0x0000,
  SHCNF_PATHA           = 0x0001,
  SHCNF_PRINTERA        = 0x0002,
  SHCNF_DWORD           = 0x0003,
  SHCNF_PATHW           = 0x0005,
  SHCNF_PRINTERW        = 0x0006,
  SHCNF_TYPE            = 0x00FF,
  SHCNF_FLUSH           = 0x1000,
  SHCNF_FLUSHNOWAIT     = 0x2000,
  SHCNF_NOTIFYRECURSIVE = 0x10000
}

проц SHChangeNotify(цел wEventId, бцел uFlags, in ук dwItem1, in ук dwItem2);

enum : бцел {
  SEE_MASK_CLASSNAME         = 0x00000001,
  SEE_MASK_CLASSKEY          = 0x00000003,
  SEE_MASK_IDLIST            = 0x00000004,
  SEE_MASK_INVOKEIDLIST      = 0x0000000c,
  SEE_MASK_ICON              = 0x00000010,
  SEE_MASK_HOTKEY            = 0x00000020,
  SEE_MASK_NOCLOSEPROCESS    = 0x00000040,
  SEE_MASK_CONNECTNETDRV     = 0x00000080,
  SEE_MASK_NOASYNC           = 0x00000100,
  SEE_MASK_FLAG_DDEWAIT      = SEE_MASK_NOASYNC,
  SEE_MASK_DOENVSUBST        = 0x00000200,
  SEE_MASK_FLAG_NO_UI        = 0x00000400,
  SEE_MASK_UNICODE           = 0x00004000,
  SEE_MASK_NO_CONSOLE        = 0x00008000,
  SEE_MASK_ASYNCOK           = 0x00100000,
  SEE_MASK_HMONITOR          = 0x00200000,
  SEE_MASK_NOZONECHECKS      = 0x00800000,
  SEE_MASK_NOQUERYCLASSSTORE = 0x01000000,
  SEE_MASK_WAITFORINPUTIDLE  = 0x02000000,
  SEE_MASK_FLAG_LOG_USAGE    = 0x04000000
}

struct SHELLEXECUTEINFOW {
  бцел cbSize = SHELLEXECUTEINFOW.sizeof;
  бцел fMask;
  Укз hwnd;
  version(D_Version2) {
    mixin("
    const(шим)* lpVerb;
    const(шим)* lpFile;
    const(шим)* lpParameters;
    const(шим)* lpDirectory;
    ");
  }
  else {
    шим* lpVerb;
    шим* lpFile;
    шим* lpParameters;
    шим* lpDirectory;
  }
  цел nShow;
  Укз hInstApp;
  ук lpIDList;
  version(D_Version2) {
    mixin("
    const(шим)* lpClass;
    ");
  }
  else {
    шим* lpClass;
  }
  Укз hkeyClass;
  бцел dwHotKey;
  union {
    Укз hIcon;
    Укз hMonitor;
  }
  Укз hProcess;
}
alias SHELLEXECUTEINFOW SHELLEXECUTEINFO;

BOOL ShellExecuteExW(ref  SHELLEXECUTEINFOW lpExecInfo);
alias ShellExecuteExW ShellExecuteEx;

enum {
  STATUS_BUFFER_TOO_SMALL = 0xC0000023
}

бцел LsaNtStatusToWinError(цел status);

// Security

struct LUID {
  бцел LowPart;
  цел HighPart;
}

const LUID SYSTEM_LUID          = { 0x3e7, 0x0 };
const LUID ANONYMOUS_LOGON_LUID = { 0x3e6, 0x0 };
const LUID LOCALSERVICE_LUID    = { 0x3e5, 0x0 };
const LUID NETWORKSERVICE_LUID  = { 0x3e4, 0x0 };
const LUID IUSER_LUID           = { 0x3e4, 0x0 };

цел AllocateLocallyUniqueId(out LUID Luid);

struct QUOTA_LIMITS {
  бцел PagedPoolLimit;
  бцел NonPagedPoolLimit;
  бцел MinimumWorkingSetSize;
  бцел MaximumWorkingSetSize;
  бцел PagefileLimit;
  дол TimeLimit;
}

enum : бцел {
  SECURITY_NULL_SID_AUTHORITY         = 0,
  SECURITY_WORLD_SID_AUTHORITY        = 1,
  SECURITY_LOCAL_SID_AUTHORITY        = 2,
  SECURITY_CREATOR_SID_AUTHORITY      = 3,
  SECURITY_NON_UNIQUE_AUTHORITY       = 4,
  SECURITY_NT_AUTHORITY               = 5,
  SECURITY_RESOURCE_MANAGER_AUTHORITY = 9
}

enum {
  SECURITY_DIALUP_RID                           = 0x00000001,
  SECURITY_NETWORK_RID                          = 0x00000002,
  SECURITY_BATCH_RID                            = 0x00000003,
  SECURITY_INTERACTIVE_RID                      = 0x00000004,
  SECURITY_LOGON_IDS_RID                        = 0x00000005,
  SECURITY_LOGON_IDS_RID_COUNT                  = 3,
  SECURITY_SERVICE_RID                          = 0x00000006,
  SECURITY_ANONYMOUS_LOGON_RID                  = 0x00000007,
  SECURITY_PROXY_RID                            = 0x00000008,
  SECURITY_ENTERPRISE_CONTROLLERS_RID           = 0x00000009,
  SECURITY_SERVER_LOGON_RID                     = SECURITY_ENTERPRISE_CONTROLLERS_RID,
  SECURITY_PRINCIPAL_SELF_RID                   = 0x0000000A,
  SECURITY_AUTHENTICATED_USER_RID               = 0x0000000B,
  SECURITY_RESTRICTED_CODE_RID                  = 0x0000000C,
  SECURITY_TERMINAL_SERVER_RID                  = 0x0000000D,
  SECURITY_REMOTE_LOGON_RID                     = 0x0000000E,
  SECURITY_THIS_ORGANIZATION_RID                = 0x0000000F,
  SECURITY_IUSER_RID                            = 0x00000011,
  SECURITY_LOCAL_SYSTEM_RID                     = 0x00000012,
  SECURITY_LOCAL_SERVICE_RID                    = 0x00000013,
  SECURITY_NETWORK_SERVICE_RID                  = 0x00000014,
  SECURITY_NT_NON_UNIQUE                        = 0x00000015,
  SECURITY_NT_NON_UNIQUE_SUB_AUTH_COUNT         = 3,
  SECURITY_ENTERPRISE_READONLY_CONTROLLERS_RID  = 0x00000016,
  SECURITY_BUILTIN_DOMAIN_RID                   = 0x00000020,
  SECURITY_WRITE_RESTRICTED_CODE_RID            = 0x00000021,
  SECURITY_PACKAGE_BASE_RID                     = 0x00000040,
  SECURITY_PACKAGE_RID_COUNT                    = 2,
  SECURITY_PACKAGE_NTLM_RID                     = 0x0000000A,
  SECURITY_PACKAGE_SCHANNEL_RID                 = 0x0000000E,
  SECURITY_PACKAGE_DIGEST_RID                   = 0x00000015,
  DOMAIN_USER_RID_ADMIN                         = 0x000001F4,
  DOMAIN_USER_RID_GUEST                         = 0x000001F5,
  DOMAIN_USER_RID_KRBTGT                        = 0x000001F6
}

struct SID_IDENTIFIER_AUTHORITY {
  ббайт[6] Value;
}

struct SID {
  ббайт Revision;
  ббайт SubAuthorityCount;
  SID_IDENTIFIER_AUTHORITY IdentifierAuthority;
  бцел[1] SubAuthority;
}

struct SID_AND_ATTRIBUTES {
  SID* Sid;
  бцел Attributes;
}

struct TOKEN_USER {
  SID_AND_ATTRIBUTES User;
}

struct TOKEN_SOURCE {
  сим[8] SourceName;
  LUID SourceIdentifier;
}

enum SECURITY_IMPERSONATION_LEVEL : бцел {
  SecurityAnonymous,
  SecurityIdentification,
  SecurityImpersonation,
  SecurityDelegation
}

enum TOKEN_TYPE : бцел {
  TokenPrimary = 1,
  TokenImpersonation
}

struct TOKEN_STATISTICS {
  LUID TokenId;
  LUID AuthenticationId;
  дол ExpirationTime;
  TOKEN_TYPE TokenType;
  SECURITY_IMPERSONATION_LEVEL ImpersonationLevel;
  бцел DynamicCharged;
  бцел DynamicAvailable;
  бцел GroupCount;
  бцел PriviledgeCount;
  LUID ModifiedId;
}

enum : бцел {
  TOKEN_ASSIGN_PRIMARY    = 0x0001,
  TOKEN_DUPLICATE         = 0x0002,
  TOKEN_IMPERSONATE       = 0x0004,
  TOKEN_QUERY             = 0x0008,
  TOKEN_QUERY_SOURCE      = 0x0010,
  TOKEN_ADJUST_PRIVILEGES = 0x0020,
  TOKEN_ADJUST_GROUPS     = 0x0040,
  TOKEN_ADJUST_DEFAULT    = 0x0080,
  TOKEN_ADJUST_SESSIONID  = 0x0100,
  TOKEN_ALL_ACCESS        = STANDARD_RIGHTS_REQUIRED | TOKEN_ASSIGN_PRIMARY | TOKEN_DUPLICATE | TOKEN_IMPERSONATE | 
    TOKEN_QUERY | TOKEN_QUERY_SOURCE | TOKEN_ADJUST_PRIVILEGES | TOKEN_ADJUST_GROUPS | TOKEN_ADJUST_DEFAULT | TOKEN_ADJUST_SESSIONID,
  TOKEN_READ              = STANDARD_RIGHTS_READ | TOKEN_QUERY,
  TOKEN_WRITE             = STANDARD_RIGHTS_WRITE | TOKEN_ADJUST_PRIVILEGES | TOKEN_ADJUST_GROUPS | TOKEN_ADJUST_DEFAULT,
  TOKEN_EXECUTE           = STANDARD_RIGHTS_EXECUTE
}

цел OpenProcessToken(Укз ProcessHandle, бцел DesiredAccess, out Укз TokenHandle);

цел OpenThreadToken(Укз ThreadHandle, бцел DesiredAccess, цел OpenAsSelf, out Укз TokenHandle);

цел DuplicateTokenEx(Укз hExistingToken, бцел dwDesiredAccess, SECURITY_ATTRIBUTES* lpTokenAttributes, SECURITY_IMPERSONATION_LEVEL ImpersonationLevel, TOKEN_TYPE TokenType, out Укз phNewToken);

цел CheckTokenMembership(Укз TokenHandle, SID* SidToCheck, out BOOL IsMember);

enum TOKEN_INFORMATION_CLASS : бцел {
  TokenUser = 1,
  TokenGroups,
  TokenPrivileges,
  TokenOwner,
  TokenPrimaryGroup,
  TokenDefaultDacl,
  TokenSource,
  TokenType,
  TokenImpersonationLevel,
  TokenStatistics,
  TokenRestrictedSids,
  TokenSessionId,
  TokenGroupsAndPrivileges,
  TokenSessionRreference,
  TokenSandBoxInert,
  TokenAuditPolicy,
  TokenOrigin,
  TokenElevationType,
  TokenLinkedToken,
  TokenElevation,
  TokenHasRestrictions,
  TokenAccessInformation,
  TokenVirtualizationAllowed,
  TokenVirtualizationEnabled,
  TokenIntegrityLevel,
  TokenUIAccess,
  TokenMandatoryPolicy,
  TokenLogonSid,
  MaxTokenInfoClass
}

цел GetTokenInformation(Укз TokenHandle, TOKEN_INFORMATION_CLASS TokenInformationClass, ук TokenInformation, бцел TokenInformationLength, ref  бцел ReturnLength);

цел ConvertStringSidToSidW(in шим* StringSid, out SID* Sid);
alias ConvertStringSidToSidW ConvertStringSidToSid;

enum : бцел {
  SidTypeUser = 1,
  SidTypeGroup,
  SidTypeDomain,
  SidTypeAlias,
  SidTypeWellKnownGroup,
  SidTypeDeletedAccount,
  SidTypeInvalid,
  SidTypeUnknown,
  SidTypeComputer,
  SidTypeLabel
}

цел LookupAccountSidW(in шим* lpSystemName, SID* Sid, шим* Name, ref  бцел cchName, шим* referencedDomainName, ref  бцел cchReferencedDomainName, out бцел peUse);
alias LookupAccountSidW LookupAccountSid;

цел IsValidSid(SID* pSid);

// CryptoAPI

struct DATA_BLOB {
  бцел cbData;
  ббайт* pbData;
}
alias DATA_BLOB CERT_BLOB;

struct CRYPT_BIT_BLOB {
  бцел cbData;
  ббайт* pbData;
  бцел cUnusedBits;
}

struct CRYPT_ALGORITHM_IDENTIFIER {
  сим* pszObjId;
  CERT_BLOB Parameters;
}

struct CERT_PUBLIC_KEY_INFO {
  CRYPT_ALGORITHM_IDENTIFIER Algorithm;
  CRYPT_BIT_BLOB PublicKey;
}

struct CERT_EXTENSION {
  сим* pszObjId;
  цел fCritical;
  CERT_BLOB Value;
}

struct CERT_INFO {
  бцел dwVersion;
  CERT_BLOB SerialNumber;
  CRYPT_ALGORITHM_IDENTIFIER SignatureAlgorithm;
  CERT_BLOB Issuer;
  FILETIME NotBefore;
  FILETIME NotAfter;
  CERT_BLOB Subject;
  CERT_PUBLIC_KEY_INFO SubjectPublicKeyInfo;
  CRYPT_BIT_BLOB IssuerUniqueId;
  CRYPT_BIT_BLOB SubjectUniqueId;
  бцел cExtension;
  CERT_EXTENSION* rgExtension;
}

struct CERT_CONTEXT {
  бцел dwCertEncodingType;
  ббайт* pbCertEncoded;
  бцел cbCertEncoded;
  CERT_INFO* pCertInfo;
  Укз hCertStore;
}

const сим* CERT_STORE_PROV_MEMORY = cast(сим*)2;
const сим* CERT_STORE_PROV_FILE = cast(сим*)3;
const сим* CERT_STORE_PROV_PKCS7 = cast(сим*)5;
const сим* CERT_STORE_PROV_SERIALIZED = cast(сим*)6;
const сим* CERT_STORE_PROV_FILENAME_A = cast(сим*)7;
const сим* CERT_STORE_PROV_FILENAME_W = cast(сим*)8;
alias CERT_STORE_PROV_FILENAME_W CERT_STORE_PROV_FILENAME;
const сим* CERT_STORE_PROV_SYSTEM_A = cast(сим*)9;
const сим* CERT_STORE_PROV_SYSTEM_W = cast(сим*)10;
alias CERT_STORE_PROV_SYSTEM_W CERT_STORE_PROV_SYSTEM;

enum : бцел {
  CRYPT_ASN_ENCODING  = 0x00000001,
  CRYPT_NDR_ENCODING  = 0x00000002,
  X509_ASN_ENCODING   = 0x00000001,
  X509_NDR_ENCODING   = 0x00000002,
  PKCS_7_ASN_ENCODING = 0x00010000,
  PKCS_7_NDR_ENCODING = 0x00020000
}

enum : бцел {
  CERT_STORE_NO_CRYPT_RELEASE_FLAG            = 0x00000001,
  CERT_STORE_SET_LOCALIZED_NAME_FLAG          = 0x00000002,
  CERT_STORE_DEFER_CLOSE_UNTIL_LAST_FREE_FLAG = 0x00000004,
  CERT_STORE_DELETE_FLAG                      = 0x00000010,
  CERT_STORE_UNSAFE_PHYSICAL_FLAG             = 0x00000020,
  CERT_STORE_SHARE_STORE_FLAG                 = 0x00000040,
  CERT_STORE_SHARE_CONTEXT_FLAG               = 0x00000080,
  CERT_STORE_MANIFOLD_FLAG                    = 0x00000100,
  CERT_STORE_ENUM_ARCHIVED_FLAG               = 0x00000200,
  CERT_STORE_UPDATE_KEYID_FLAG                = 0x00000400,
  CERT_STORE_BACKUP_RESTORE_FLAG              = 0x00000800,
  CERT_STORE_READONLY_FLAG                    = 0x00008000,
  CERT_STORE_OPEN_EXISTING_FLAG               = 0x00004000,
  CERT_STORE_CREATE_NEW_FLAG                  = 0x00002000,
  CERT_STORE_MAXIMUM_ALLOWED_FLAG             = 0x00001000
}

enum : бцел {
  CERT_SYSTEM_STORE_LOCATION_MASK    = 0x00FF0000,
  CERT_SYSTEM_STORE_LOCATION_SHIFT   = 16,
  CERT_SYSTEM_STORE_CURRENT_USER_ID  = 1,
  CERT_SYSTEM_STORE_LOCAL_MACHINE_ID = 2,
  CERT_SYSTEM_STORE_CURRENT_USER     = CERT_SYSTEM_STORE_CURRENT_USER_ID << CERT_SYSTEM_STORE_LOCATION_SHIFT,
  CERT_SYSTEM_STORE_LOCAL_MACHINE    = CERT_SYSTEM_STORE_LOCAL_MACHINE_ID << CERT_SYSTEM_STORE_LOCATION_SHIFT
}

Укз CertOpenStore(in сим* lpszStoreProvider, бцел dwMsgAndCertEncodingType, Укз hCryptProv, бцел dwFlags, in ук pvPara);

цел CertCloseStore(Укз hCertStore, бцел dwFlags);

Укз CertDuplicateStore(Укз hCertStore);

enum : бцел {
  CERT_STORE_ADD_NEW                                 = 1,
  CERT_STORE_ADD_USE_EXISTING                        = 2,
  CERT_STORE_ADD_REPLACE_EXISTING                    = 3,
  CERT_STORE_ADD_ALWAYS                              = 4,
  CERT_STORE_ADD_REPLACE_EXISTING_INHERIT_PROPERTIES = 5,
  CERT_STORE_ADD_NEWER                               = 6,
  CERT_STORE_ADD_NEWER_INHERIT_PROPERTIES            = 7
}

цел CertAddCertificateContextToStore(Укз hCertStore, CERT_CONTEXT* pCertContext, бцел dwAddDisposition, CERT_CONTEXT** ppStoreContext);

цел CertAddCertificateLinkToStore(Укз hCertStore, CERT_CONTEXT* pCertContext, бцел dwAddDisposition, CERT_CONTEXT** ppStoreContext);

enum : бцел {
  CERT_STORE_CERTIFICATE_CONTEXT = 1,
  CERT_STORE_CRL_CONTEXT         = 2,
  CERT_STORE_CTL_CONTEXT         = 3,
  CERT_STORE_CERTIFICATE_CONTEXT_FLAG = 1 << CERT_STORE_CERTIFICATE_CONTEXT,
  CERT_STORE_CRL_CONTEXT_FLAG = 1 << CERT_STORE_CRL_CONTEXT,
  CERT_STORE_CTL_CONTEXT_FLAG = 1 << CERT_STORE_CTL_CONTEXT
}

цел CertAddSerializedElementToStore(Укз hCertStore, in ббайт* pbElement, бцел cbElement, бцел dwAddDisposition, бцел dwFlags, бцел dwContextTypeFlags, бцел* pdwContextType, ук* ppvContext);

CERT_CONTEXT* CertGetSubjectCertificateFromStore(Укз hCertStore, бцел dwCertEncodingType, CERT_INFO* pCertId);

цел CertSerializeCertificateStoreElement(CERT_CONTEXT* pCertContext, бцел dwFlags, ббайт* pbElement, ref  бцел pcbElement);

enum : бцел {
  CERT_STORE_SAVE_AS_STORE  = 1,
  CERT_STORE_SAVE_AS_PKCS7  = 2,
  CERT_STORE_SAVE_AS_PKCS12 = 3
}

enum : бцел {
  CERT_STORE_SAVE_TO_FILE       = 1,
  CERT_STORE_SAVE_TO_MEMORY     = 2,
  CERT_STORE_SAVE_TO_FILENAME_A = 3,
  CERT_STORE_SAVE_TO_FILENAME_W = 4
}

цел CertSaveStore(Укз hCertStore, бцел dwMsgAndCertEncodingType, бцел dwSaveAs, бцел dwSaveTo, in ук pvSaveToPara, бцел dwFlags);

enum : бцел {
  REPORT_NO_PRIVATE_KEY                 = 0x0001,
  REPORT_NOT_ABLE_TO_EXPORT_PRIVATE_KEY = 0x0002,
  EXPORT_PRIVATE_KEYS                   = 0x0004,
  PKCS12_INCLUDE_EXTENDED_PROPERTIES    = 0x0010
}

цел PFXExportCertStore(Укз hStore, CERT_BLOB* pPFX, in шим* szPassword, бцел dwFlags);

Укз PFXImportCertStore(CERT_BLOB* pPFX, in шим* szPassword, бцел dwFlags);

CERT_CONTEXT* CertEnumCertificatesInStore(Укз hCertStore, CERT_CONTEXT* pPrevCertContext);

enum : бцел {
  CERT_COMPARE_MASK                   = 0xFFFF,
  CERT_COMPARE_SHIFT                  = 16,
  CERT_COMPARE_ANY                    = 0,
  CERT_COMPARE_SHA1_HASH              = 1,
  CERT_COMPARE_NAME                   = 2,
  CERT_COMPARE_ATTR                   = 3,
  CERT_COMPARE_MD5_HASH               = 4,
  CERT_COMPARE_PROPERTY               = 5,
  CERT_COMPARE_PUBLIC_KEY             = 6,
  CERT_COMPARE_HASH                   = CERT_COMPARE_SHA1_HASH,
  CERT_COMPARE_NAME_STR_A             = 7,
  CERT_COMPARE_NAME_STR_W             = 8,
  CERT_COMPARE_KEY_SPEC               = 9,
  CERT_COMPARE_ENHKEY_USAGE           = 10,
  CERT_COMPARE_CTL_USAGE              = CERT_COMPARE_ENHKEY_USAGE,
  CERT_COMPARE_SUBJECT_CERT           = 11,
  CERT_COMPARE_ISSUER_OF              = 12,
  CERT_COMPARE_EXISTING               = 13,
  CERT_COMPARE_SIGNATURE_HASH         = 14,
  CERT_COMPARE_KEY_IDENTIFIER         = 15,
  CERT_COMPARE_CERT_ID                = 16,
  CERT_COMPARE_CROSS_CERT_DIST_POINTS = 17,
  CERT_COMPARE_PUBKEY_MD5_HASH        = 18,
  CERT_COMPARE_SUBJECT_INFO_ACCESS    = 19
}

enum : бцел {
  CERT_FIND_ANY       = CERT_COMPARE_ANY << CERT_COMPARE_SHIFT,
  CERT_FIND_EXISTING  = CERT_COMPARE_EXISTING << CERT_COMPARE_SHIFT
}

CERT_CONTEXT* CertFindCertificateInStore(Укз hCertStore, бцел dwCertEncodingType, бцел dwFindFlags, бцел dwFindType, in ук pvFindPara, CERT_CONTEXT* pPrevCertContext);

CERT_CONTEXT* CertDuplicateCertificateContext(CERT_CONTEXT* pCertContext);

цел CertFreeCertificateContext(CERT_CONTEXT* pCertContext);

цел CertDeleteCertificateFromStore(CERT_CONTEXT* pCertContext);

CERT_CONTEXT* CertCreateCertificateContext(бцел dwCertEncodingType, in ббайт* pbCertEncoded, бцел cbCertEncoded);

enum : бцел {
  CERT_NAME_EMAIL_TYPE            = 1,
  CERT_NAME_RDN_TYPE              = 2,
  CERT_NAME_ATTR_TYPE             = 3,
  CERT_NAME_SIMPLE_DISPLAY_TYPE   = 4,
  CERT_NAME_FRIENDLY_DISPLAY_TYPE = 5,
  CERT_NAME_DNS_TYPE              = 6,
  CERT_NAME_URL_TYPE              = 7,
  CERT_NAME_UPN_TYPE              = 8
}

enum : бцел {
  CERT_NAME_ISSUER_FLAG           = 0x1,
  CERT_NAME_DISABLE_IE4_UTF8_FLAG = 0x00010000
}

бцел CertGetNameStringW(CERT_CONTEXT* pCertContext, бцел dwType, бцел dwFlags, ук pvTypePara, шим* pszNameString, бцел cchNameString);
alias CertGetNameStringW CertGetNameString;

enum : бцел {
  CERT_SIMPLE_NAME_STR = 1,
  CERT_OID_NAME_STR    = 2,
  CERT_X500_NAME_STR   = 3,
  CERT_XML_NAME_STR    = 4
}

enum : бцел {
  CERT_NAME_STR_SEMICOLON_FLAG            = 0x40000000,
  CERT_NAME_STR_NO_PLUS_FLAG              = 0x20000000,
  CERT_NAME_STR_NO_QUOTING_FLAG           = 0x10000000,
  CERT_NAME_STR_CRLF_FLAG                 = 0x08000000,
  CERT_NAME_STR_COMMA_FLAG                = 0x04000000,
  CERT_NAME_STR_REVERSE_FLAG              = 0x02000000,
  CERT_NAME_STR_FORWARD_FLAG              = 0x01000000,
  CERT_NAME_STR_DISABLE_IE4_UTF8_FLAG     = 0x00010000,
  CERT_NAME_STR_ENABLE_T61_UNICODE_FLAG   = 0x00020000,
  CERT_NAME_STR_ENABLE_UTF8_UNICODE_FLAG  = 0x00040000,
  CERT_NAME_STR_FORCE_UTF8_DIR_STR_FLAG   = 0x00080000,
  CERT_NAME_STR_DISABLE_UTF8_DIR_STR_FLAG = 0x00100000
}

бцел CertNameToStrW(бцел dwCertEncodingType, CERT_BLOB* pName, бцел dwStrType, шим* psz, бцел csz);
alias CertNameToStrW CertNameToStr;

бцел CertStrToNameW(бцел dwCertEncodingType, in шим* pszX500, бцел dwStrType, ук pvReserved, ббайт* pbEncoded, ref  бцел pcbEncoded, шим** ppszError);
alias CertStrToNameW CertStrToName;

enum : бцел {
  CERT_KEY_PROV_HANDLE_PROP_ID = 1,
  CERT_KEY_PROV_INFO_PROP_ID = 2,
  CERT_SHA1_HASH_PROP_ID = 3,
  CERT_HASH_PROP_ID = CERT_SHA1_HASH_PROP_ID,
  CERT_FRIENDLY_NAME_PROP_ID = 11
}

цел CertGetCertificateContextProperty(CERT_CONTEXT* pCertContext, бцел dwPropId, ук pvData, ref  бцел pcbData);

цел CertSetCertificateContextProperty(CERT_CONTEXT* pCertContext, бцел dwPropId, бцел dwFlags, in ук pvData);

const шим* MS_DEF_PROV = "Microsoft Base Cryptographic Provider v1.0";
const шим* MS_ENHANCED_PROV = "Microsoft Enhanced Cryptographic Provider v1.0";
const шим* MS_STRONG_PROV = "Microsoft Strong Cryptographic Provider";
const шим* MS_DEF_RSA_SIG_PROV = "Microsoft RSA Signature Cryptographic Provider";
const шим* MS_DEF_RSA_SCHANNEL_PROV = "Microsoft RSA SChannel Cryptographic Provider";
const шим* MS_DEF_DSS_PROV = "Microsoft Base DSS Cryptographic Provider";
const шим* MS_DEF_DSS_DH_PROV = "Microsoft Base DSS and Diffie-Hellman Cryptographic Provider";
const шим* MS_ENH_DSS_DH_PROV = "Microsoft Enhanced DSS and Diffie-Hellman Cryptographic Provider";
const шим* MS_DEF_DH_SCHANNEL_PROV = "Microsoft DH SChannel Cryptographic Provider";
const шим* MS_SCARD_PROV = "Microsoft Base Smart Card Crypto Provider";
const шим* MS_ENH_RSA_AES_PROV = "Microsoft Enhanced RSA and AES Cryptographic Provider";
const шим* MS_ENH_RSA_AES_PROV_XP = "Microsoft Enhanced RSA and AES Cryptographic Provider (Prototype)";

enum : бцел {
  PROV_RSA_FULL      = 1,
  PROV_RSA_SIG       = 2,
  PROV_DSS           = 3,
  PROV_FORTEZZA      = 4,
  PROV_MS_EXCHANGE   = 5,
  PROV_SSL           = 6,
  PROV_RSA_SCHANNEL  = 12,
  PROV_DSS_DH        = 13,
  PROV_EC_ECDSA_SIG  = 14,
  PROV_EC_ECNRA_SIG  = 15,
  PROV_EC_ECDSA_FULL = 16,
  PROV_EC_ECNRA_FULL = 17,
  PROV_DH_SCHANNEL   = 18,
  PROV_SPYRUS_LYNKS  = 20,
  PROV_RNG           = 21,
  PROV_INTEL_SEC     = 22,
  PROV_REPLACE_OWF   = 23,
  PROV_RSA_AES       = 24
}

enum : бцел {
  CRYPT_VERIFYCONTEXT    = 0xF0000000,
  CRYPT_NEWKEYSET        = 0x00000008,
  CRYPT_DELETEKEYSET     = 0x00000010,
  CRYPT_MACHINE_KEYSET   = 0x00000020,
  CRYPT_SILENT           = 0x00000040
}

цел CryptAcquireContextW(out Укз phProv, in шим* szContainer, in шим* szProvider, бцел dwProvType, бцел dwFlags);
alias CryptAcquireContextW CryptAcquireContext;

цел CryptReleaseContext(Укз hProv, бцел dwFlags);

enum : бцел {
  PP_ENUMALGS            = 1,
  PP_ENUMCONTAINERS      = 2,
  PP_IMPTYPE             = 3,
  PP_NAME                = 4,
  PP_VERSION             = 5,
  PP_CONTAINER           = 6,
  PP_CHANGE_PASSWORD     = 7,
  PP_KEYSET_SEC_DESCR    = 8,
  PP_CERTCHAIN           = 9,
  PP_KEY_TYPE_SUBTYPE    = 10,
  PP_PROVTYPE            = 16,
  PP_KEYSTORAGE          = 17,
  PP_APPLI_CERT          = 18,
  PP_SYM_KEYSIZE         = 19,
  PP_SESSION_KEYSIZE     = 20,
  PP_UI_PROMPT           = 21,
  PP_ENUMALGS_EX         = 22,
  PP_ENUMMANDROOTS       = 25,
  PP_ENUMELECTROOTS      = 26,
  PP_KEYSET_TYPE         = 27,
  PP_ADMIN_PIN           = 31,
  PP_KEYEXCHANGE_PIN     = 32,
  PP_SIGNATURE_PIN       = 33,
  PP_SIG_KEYSIZE_INC     = 34,
  PP_KEYX_KEYSIZE_INC    = 35,
  PP_UNIQUE_CONTAINER    = 36,
  PP_SGC_INFO            = 37,
  PP_USE_HARDWARE_RNG    = 38,
  PP_KEYSPEC             = 39,
  PP_ENUMEX_SIGNING_PROT = 40,
  PP_CRYPT_COUNT_KEY_USE = 41,
  PP_USER_CERTSTORE      = 42,
  PP_SMARTCARD_READER    = 43,
  PP_SMARTCARD_GUID      = 45,
  PP_ROOT_CERTSTORE      = 46
}

struct PROV_ENUMALGS  {
  бцел aiAlgid;
  бцел dwBitLen;
  бцел dwNameLen;
  сим[20] szName;
}

enum : бцел {
  CRYPT_FIRST    = 1,
  CRYPT_NEXT     = 2,
  CRYPT_SGC_ENUM = 4
}

цел CryptGetProvParam(Укз hProv, бцел dwParam, ббайт* pbData, ref  бцел pdwDataLen, бцел dwFlags);

enum : бцел {
  ALG_CLASS_ANY          = 0,
  ALG_CLASS_SIGNATURE    = 1 << 13,
  ALG_CLASS_MSG_ENCRYPT  = 2 << 13,
  ALG_CLASS_DATA_ENCRYPT = 3 << 13,
  ALG_CLASS_HASH         = 4 << 13,
  ALG_CLASS_KEY_EXCHANGE = 5 << 13,
  ALG_CLASS_ALL          = 7 << 13
}

enum : бцел {
  ALG_TYPE_ANY           = 0,
  ALG_TYPE_DSS           = 1 << 9,
  ALG_TYPE_RSA           = 2 << 9,
  ALG_TYPE_BLOCK         = 3 << 9,
  ALG_TYPE_STREAM        = 4 << 9,
  ALG_TYPE_DH            = 5 << 9,
  ALG_TYPE_SECURECHANNEL = 6 << 9
}

enum : бцел {
  ALG_SID_RSA_ANY                = 0,
  ALG_SID_RSA_PKCS               = 1,
  ALG_SID_RSA_MSATWORK           = 2,
  ALG_SID_RSA_ENTRUST            = 3,
  ALG_SID_RSA_PGP                = 4,

  ALG_SID_DSS_ANY                = 0,

  ALG_SID_DSS_PKCS               = 1,
  ALG_SID_DSS_DMS                = 2,

  ALG_SID_MD2                    = 1,
  ALG_SID_MD4                    = 2,
  ALG_SID_MD5                    = 3,
  ALG_SID_SHA                    = 4,
  ALG_SID_SHA1                   = 4,
  ALG_SID_MAC                    = 5,
  ALG_SID_RIPEMD                 = 6,
  ALG_SID_RIPEMD160              = 7,
  ALG_SID_SSL3SHAMD5             = 8,
  ALG_SID_HMAC                   = 9,
  ALG_SID_TLS1PRF                = 10,
  ALG_SID_HASH_REPLACE_OWF       = 11,
  ALG_SID_SHA_256                = 12,
  ALG_SID_SHA_384                = 13,
  ALG_SID_SHA_512                = 14,

  ALG_SID_DES                    = 1,
  ALG_SID_3DES                   = 3,
  ALG_SID_DESX                   = 4,
  ALG_SID_IDEA                   = 5,
  ALG_SID_CAST                   = 6,
  ALG_SID_SAFERSK64              = 7,
  ALG_SID_SAFERSK128             = 8,
  ALG_SID_3DES_112               = 9,
  ALG_SID_CYLINK_MEK             = 12,
  ALG_SID_RC5                    = 13,
  ALG_SID_AES_128                = 14,
  ALG_SID_AES_192                = 15,
  ALG_SID_AES_256                = 16,
  ALG_SID_AES                    = 17,

  ALG_SID_SKIPJACK               = 10,
  ALG_SID_TEK                    = 11,

  ALG_SID_RC2                    = 2,

  ALG_SID_RC4                    = 1,
  ALG_SID_SEAL                   = 2,

  ALG_SID_DH_SANDF               = 1,
  ALG_SID_DH_EPHEM               = 2,
  ALG_SID_AGREED_KEY_ANY         = 3,
  ALG_SID_KEA                    = 4,

  ALG_SID_SSL3_MASTER            = 1,
  ALG_SID_SCHANNEL_MASTER_HASH   = 2,
  ALG_SID_SCHANNEL_MAC_KEY       = 3,
  ALG_SID_PCT1_MASTER            = 4,
  ALG_SID_SSL2_MASTER            = 5,
  ALG_SID_TLS1_MASTER            = 6,
  ALG_SID_SCHANNEL_ENC_KEY       = 7
}

enum : бцел {
  CALG_MD2                    = ALG_CLASS_HASH | ALG_TYPE_ANY | ALG_SID_MD2,
  CALG_MD4                    = ALG_CLASS_HASH | ALG_TYPE_ANY | ALG_SID_MD4,
  CALG_MD5                    = ALG_CLASS_HASH | ALG_TYPE_ANY | ALG_SID_MD5,
  CALG_SHA                    = ALG_CLASS_HASH | ALG_TYPE_ANY | ALG_SID_SHA,
  CALG_SHA1                   = ALG_CLASS_HASH | ALG_TYPE_ANY | ALG_SID_SHA1,
  CALG_MAC                    = ALG_CLASS_HASH | ALG_TYPE_ANY | ALG_SID_MAC,
  CALG_RSA_SIGN               = ALG_CLASS_SIGNATURE | ALG_TYPE_RSA | ALG_SID_RSA_ANY,
  CALG_DSS_SIGN               = ALG_CLASS_SIGNATURE | ALG_TYPE_DSS | ALG_SID_DSS_ANY,
  CALG_RSA_KEYX               = ALG_CLASS_KEY_EXCHANGE | ALG_TYPE_RSA | ALG_SID_RSA_ANY,
  CALG_DES                    = ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_BLOCK | ALG_SID_DES,
  CALG_3DES_112               = ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_BLOCK | ALG_SID_3DES_112,
  CALG_3DES                   = ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_BLOCK | ALG_SID_3DES,
  CALG_DESX                   = ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_BLOCK | ALG_SID_DESX,
  CALG_RC2                    = ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_BLOCK | ALG_SID_RC2,
  CALG_RC4                    = ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_STREAM | ALG_SID_RC4,
  CALG_SEAL                   = ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_STREAM | ALG_SID_SEAL,
  CALG_DH_SF                  = ALG_CLASS_KEY_EXCHANGE | ALG_TYPE_DH | ALG_SID_DH_SANDF,
  CALG_DH_EPHEM               = ALG_CLASS_KEY_EXCHANGE | ALG_TYPE_DH | ALG_SID_DH_EPHEM,
  CALG_AGREEDKEY_ANY          = ALG_CLASS_KEY_EXCHANGE | ALG_TYPE_DH | ALG_SID_AGREED_KEY_ANY,
  CALG_KEA_KEYX               = ALG_CLASS_KEY_EXCHANGE | ALG_TYPE_DH | ALG_SID_KEA,
  CALG_HUGHES_MD5             = ALG_CLASS_KEY_EXCHANGE | ALG_TYPE_ANY | ALG_SID_MD5,
  CALG_SKIPJACK               = ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_BLOCK | ALG_SID_SKIPJACK,
  CALG_TEK                    = ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_BLOCK | ALG_SID_TEK,
  CALG_CYLINK_MEK             = ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_BLOCK | ALG_SID_CYLINK_MEK,
  CALG_SSL3_SHAMD5            = ALG_CLASS_HASH | ALG_TYPE_ANY | ALG_SID_SSL3SHAMD5,
  CALG_SSL3_MASTER            = ALG_CLASS_MSG_ENCRYPT | ALG_TYPE_SECURECHANNEL | ALG_SID_SSL3_MASTER,
  CALG_SCHANNEL_MASTER_HASH   = ALG_CLASS_MSG_ENCRYPT | ALG_TYPE_SECURECHANNEL | ALG_SID_SCHANNEL_MASTER_HASH,
  CALG_SCHANNEL_MAC_KEY       = ALG_CLASS_MSG_ENCRYPT | ALG_TYPE_SECURECHANNEL | ALG_SID_SCHANNEL_MAC_KEY,
  CALG_SCHANNEL_ENC_KEY       = ALG_CLASS_MSG_ENCRYPT | ALG_TYPE_SECURECHANNEL | ALG_SID_SCHANNEL_ENC_KEY,
  CALG_PCT1_MASTER            = ALG_CLASS_MSG_ENCRYPT | ALG_TYPE_SECURECHANNEL | ALG_SID_PCT1_MASTER,
  CALG_SSL2_MASTER            = ALG_CLASS_MSG_ENCRYPT | ALG_TYPE_SECURECHANNEL | ALG_SID_SSL2_MASTER,
  CALG_TLS1_MASTER            = ALG_CLASS_MSG_ENCRYPT | ALG_TYPE_SECURECHANNEL | ALG_SID_TLS1_MASTER,
  CALG_RC5                    = ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_BLOCK | ALG_SID_RC5,
  CALG_HMAC                   = ALG_CLASS_HASH | ALG_TYPE_ANY | ALG_SID_HMAC,
  CALG_TLS1PRF                = ALG_CLASS_HASH | ALG_TYPE_ANY | ALG_SID_TLS1PRF,
  CALG_AES_128                = ALG_CLASS_DATA_ENCRYPT| ALG_TYPE_BLOCK| ALG_SID_AES_128,
  CALG_AES_192                = ALG_CLASS_DATA_ENCRYPT| ALG_TYPE_BLOCK| ALG_SID_AES_192,
  CALG_AES_256                = ALG_CLASS_DATA_ENCRYPT| ALG_TYPE_BLOCK| ALG_SID_AES_256,
  CALG_AES                    = ALG_CLASS_DATA_ENCRYPT| ALG_TYPE_BLOCK| ALG_SID_AES,
  CALG_SHA_256                = ALG_CLASS_HASH | ALG_TYPE_ANY | ALG_SID_SHA_256,
  CALG_SHA_384                = ALG_CLASS_HASH | ALG_TYPE_ANY | ALG_SID_SHA_384,
  CALG_SHA_512                = ALG_CLASS_HASH | ALG_TYPE_ANY | ALG_SID_SHA_512
}

цел CryptCreateHash(Укз hProv, бцел Algid, Укз hKey, бцел dwFlags, out Укз phHash);

цел CryptHashData(Укз hHash, in ббайт* pbData, бцел dwDataLen, бцел dwFlags);

цел CryptSignHashW(Укз hHash, бцел dwKeySpec, in шим* sDescription, бцел dwFlags, ббайт* pbSignature, ref  бцел pdwSignLen);
alias CryptSignHashW CryptSignHash;

enum : бцел {
  HP_ALGID         = 0x0001,
  HP_HASHVAL       = 0x0002,
  HP_HASHSIZE      = 0x0004,
  HP_HMAC_INFO     = 0x0005,
  HP_TLS1PRF_LABEL = 0x0006,
  HP_TLS1PRF_SEED  = 0x0007
}

цел CryptGetHashParam(Укз hHash, бцел dwParam, ббайт* pbData, ref  бцел pswDataLen, бцел dwFlags);

цел CryptDestroyHash(Укз hHash);

цел CryptVerifySignatureW(Укз hHash, ббайт* pbSignature, бцел dwSigLen, Укз hPubKey, in шим* sDescription, бцел dwFlags);
alias CryptVerifySignatureW CryptVerifySignature;

enum : бцел {
  KP_IV                  = 1,
  KP_SALT                = 2,
  KP_PADDING             = 3,
  KP_MODE                = 4,
  KP_MODE_BITS           = 5,
  KP_PERMISSIONS         = 6,
  KP_ALGID               = 7,
  KP_BLOCKLEN            = 8,
  KP_KEYLEN              = 9,
  KP_SALT_EX             = 10,
  KP_P                   = 11,
  KP_G                   = 12,
  KP_Q                   = 13,
  KP_X                   = 14,
  KP_Y                   = 15,
  KP_RA                  = 16,
  KP_RB                  = 17,
  KP_INFO                = 18,
  KP_EFFECTIVE_KEYLEN    = 19,
  KP_SCHANNEL_ALG        = 20,
  KP_CLIENT_RANDOM       = 21,
  KP_SERVER_RANDOM       = 22,
  KP_RP                  = 23,
  KP_PRECOMP_MD5         = 24,
  KP_PRECOMP_SHA         = 25,
  KP_CERTIFICATE         = 26,
  KP_CLEAR_KEY           = 27,
  KP_PUB_EX_LEN          = 28,
  KP_PUB_EX_VAL          = 29,
  KP_KEYVAL              = 30,
  KP_ADMIN_PIN           = 31,
  KP_KEYEXCHANGE_PIN     = 32,
  KP_SIGNATURE_PIN       = 33,
  KP_PREHASH             = 34
}

цел CryptSetKeyParam(Укз hKey, бцел dwParam, in ббайт* pbData, бцел dwFlags);

цел CryptGetKeyParam(Укз hKey, бцел dwParam, ббайт* pbData, ref  бцел pdwDataLen, бцел dwFlags);

enum : бцел {
  CRYPT_EXPORTABLE                = 0x00000001,
  CRYPT_USER_PROTECTED            = 0x00000002,
  CRYPT_CREATE_SALT               = 0x00000004,
  CRYPT_UPDATE_KEY                = 0x00000008,
  CRYPT_NO_SALT                   = 0x00000010,
  CRYPT_PREGEN                    = 0x00000040,
  CRYPT_RECIPIENT                 = 0x00000010,
  CRYPT_INITIATOR                 = 0x00000040,
  CRYPT_ONLINE                    = 0x00000080,
  CRYPT_SF                        = 0x00000100,
  CRYPT_CREATE_IV                 = 0x00000200,
  CRYPT_KEK                       = 0x00000400,
  CRYPT_DATA_KEY                  = 0x00000800,
  CRYPT_VOLATILE                  = 0x00001000,
  CRYPT_SGCKEY                    = 0x00002000,
  CRYPT_ARCHIVABLE                = 0x00004000,
  CRYPT_FORCE_KEY_PROTECTION_HIGH = 0x00008000,
  CRYPT_SERVER                    = 0x00000400
}

enum : бцел {
  CRYPT_Y_ONLY           = 0x00000001,
  CRYPT_SSL2_FALLBACK    = 0x00000002,
  CRYPT_DESTROYKEY       = 0x00000004,
  CRYPT_OAEP             = 0x00000040
}

цел CryptDeriveKey(Укз hProv, бцел Algid, Укз hBaseData, бцел dwFlags, out Укз phKey);

// bType
enum : ббайт {
  SIMPLEBLOB           = 0x1,
  PUBLICKEYBLOB        = 0x6,
  PRIVATEKEYBLOB       = 0x7,
  PLAINTEXTKEYBLOB     = 0x8,
  OPAQUEKEYBLOB        = 0x9,
  PUBLICKEYBLOBEX      = 0xA,
  SYMMETRICWRAPKEYBLOB = 0xB
}

enum : ббайт {
  CUR_BLOB_VERSION = 2
}

struct BLOBHEADER {
  ббайт bType;
  ббайт bVersion;
  бкрат reserved;
  бцел aiKeyAlg;
}

struct RSAPUBKEY {
  бцел magic;
  бцел bitlen;
  бцел pubexp;
}

struct DSSPUBKEY {
  бцел magic;
  бцел bitlen;
}

цел CryptImportKey(Укз hProv, ббайт* pbData, бцел dwDataLen, Укз hPubKey, бцел dwFlags, out Укз phKey);

цел CryptExportKey(Укз hprov, Укз hExpKey, бцел dwBlobType, бцел dwFlags, ббайт* pbData, ref  бцел pdwDataLen);

enum : бцел {
  AT_KEYEXCHANGE         = 1,
  AT_SIGNATURE           = 2
}

цел CryptGetUserKey(Укз hProv, бцел dwKeySpec, out Укз phUserKey);

цел CryptGenKey(Укз hProv, бцел Algid, бцел dwFlags, out Укз phKey);

цел CryptDestroyKey(Укз hKey);

цел CryptGenRandom(Укз hProv, бцел dwLen, ббайт* lpBuffer);

цел CryptEncrypt(Укз hKey, Укз hHash, цел Final, бцел dwFlags, ббайт* pbData, ref  бцел pdwDataLen, бцел dwBufLen);

цел CryptDecrypt(Укз hKey, Укз hHash, цел Final, бцел dwFlags, ббайт* pbData, ref  бцел pdwDataLen);

enum : бцел {
  CRYPT_OID_INFO_OID_KEY       = 1,
  CRYPT_OID_INFO_NAME_KEY      = 2,
  CRYPT_OID_INFO_ALGID_KEY     = 3,
  CRYPT_OID_INFO_SIGN_KEY      = 4,
  CRYPT_OID_INFO_CNG_ALGID_KEY = 5,
  CRYPT_OID_INFO_CNG_SIGN_KEY  = 6
}

enum : бцел {
  CRYPT_OID_INFO_PUBKEY_SIGN_KEY_FLAG    = 0x80000000,
  CRYPT_OID_INFO_PUBKEY_ENCRYPT_KEY_FLAG = 0x40000000
}

enum : бцел {
  CRYPT_HASH_ALG_OID_GROUP_ID     = 1,
  CRYPT_ENCRYPT_ALG_OID_GROUP_ID  = 2,
  CRYPT_PUBKEY_ALG_OID_GROUP_ID   = 3,
  CRYPT_SIGN_ALG_OID_GROUP_ID     = 4,
  CRYPT_RDN_ATTR_OID_GROUP_ID     = 5,
  CRYPT_EXT_OR_ATTR_OID_GROUP_ID  = 6,
  CRYPT_ENHKEY_USAGE_OID_GROUP_ID = 7,
  CRYPT_POLICY_OID_GROUP_ID       = 8,
  CRYPT_TEMPLATE_OID_GROUP_ID     = 9
}

struct CRYPT_OID_INFO {
  бцел cbSize = CRYPT_OID_INFO.sizeof;
  сим* pszOID;
  шим* pwszName;
  бцел dwGroupId;
  union {
    бцел dwValue;
    бцел Algid;
    бцел dwLength;
  }
  DATA_BLOB ExtraInfo;
}

CRYPT_OID_INFO* CryptFindOIDInfo(бцел dwKeyType, in ук pvKey, бцел dwGroupId);

enum : бцел {
  CRYPT_FORMAT_STR_MULTI_LINE = 0x0001,
  CRYPT_FORMAT_STR_NO_HEX     = 0x0010
}

const сим* X509_NAME             = cast(сим*)7;
const сим* RSA_CSP_PUBLICKEYBLOB = cast(сим*)19;
const сим* X509_MULTI_BYTE_UINT  = cast(сим*)38;
const сим* X509_DSS_PUBLICKEY    = X509_MULTI_BYTE_UINT;

цел CryptFormatObject(бцел dwCertEncodingType, бцел dwFormatType, бцел dwFormatStrType, ук pFormatStruct, in сим* lpszStructType, ббайт* pbEncoded, бцел cbEncoded, шим* pbFormat, бцел* pcbFormat);

цел CryptDecodeObject(бцел dwCertEncodingType, in сим* lpszStructType, in ббайт* pbEncoded, бцел cbEncoded, бцел dwFlags, ук pvStructInfo, ref  бцел pcbStructInfo);

struct CRYPTPROTECT_PROMPTSTRUCT {
  бцел cbSize = CRYPTPROTECT_PROMPTSTRUCT.sizeof;
  бцел dwPromptFlags;
  Укз hwndApp;
  шим* szPrompt;
}

enum : бцел {
  CRYPTPROTECT_UI_FORBIDDEN = 0x1,
  CRYPTPROTECT_LOCAL_MACHINE = 0x4
}

цел CryptProtectData(DATA_BLOB* pDataIn, in шим* szDataDescr, DATA_BLOB* pOptionalEntropy, ук pvReserved, CRYPTPROTECT_PROMPTSTRUCT* pPromptStruct, бцел dwFlags, DATA_BLOB* pDataOut);

цел CryptUnprotectData(DATA_BLOB* pDataIn, шим** ppszDataDescr, DATA_BLOB* pOptionalEntropy, ук pvReserved, CRYPTPROTECT_PROMPTSTRUCT* pPromptStruct, бцел dwFlags, DATA_BLOB* pDataOut);

// dwObjectType
enum : бцел {
  CERT_QUERY_OBJECT_FILE = 0x00000001,
  CERT_QUERY_OBJECT_BLOB = 0x00000002
}

// dwContentType
enum : бцел {
  CERT_QUERY_CONTENT_CERT               = 1,
  CERT_QUERY_CONTENT_SERIALIZED_STORE   = 4,
  CERT_QUERY_CONTENT_SERIALIZED_CERT    = 5,
  CERT_QUERY_CONTENT_PKCS7_SIGNED       = 8,
  CERT_QUERY_CONTENT_PKCS7_UNSIGNED     = 9,
  CERT_QUERY_CONTENT_PKCS7_SIGNED_EMBED = 10,
  CERT_QUERY_CONTENT_PFX                = 12
}

// dwExpectedConentTypeFlags
enum : бцел {
  CERT_QUERY_CONTENT_FLAG_CERT = 1 << CERT_QUERY_CONTENT_CERT,
  CERT_QUERY_CONTENT_FLAG_SERIALIZED_STORE = 1 << CERT_QUERY_CONTENT_SERIALIZED_STORE,
  CERT_QUERY_CONTENT_FLAG_SERIALIZED_CERT = 1 << CERT_QUERY_CONTENT_SERIALIZED_CERT,
  CERT_QUERY_CONTENT_FLAG_PKCS7_SIGNED = 1 << CERT_QUERY_CONTENT_PKCS7_SIGNED,
  CERT_QUERY_CONTENT_FLAG_PKCS7_UNSIGNED = 1 << CERT_QUERY_CONTENT_PKCS7_UNSIGNED,
  CERT_QUERY_CONTENT_FLAG_PKCS7_SIGNED_EMBED = 1 << CERT_QUERY_CONTENT_PKCS7_SIGNED_EMBED,
  CERT_QUERY_CONTENT_FLAG_PFX = 1 << CERT_QUERY_CONTENT_PFX,
  CERT_QUERY_CONTENT_FLAG_ALL = CERT_QUERY_CONTENT_FLAG_CERT | 
    CERT_QUERY_CONTENT_FLAG_SERIALIZED_STORE | 
    CERT_QUERY_CONTENT_FLAG_SERIALIZED_CERT | 
    CERT_QUERY_CONTENT_FLAG_PKCS7_SIGNED | 
    CERT_QUERY_CONTENT_FLAG_PKCS7_UNSIGNED | 
    CERT_QUERY_CONTENT_FLAG_PKCS7_SIGNED_EMBED |
    CERT_QUERY_CONTENT_FLAG_PFX
}

// dwFormatType
enum : бцел {
  CERT_QUERY_FORMAT_BINARY                = 1,
  CERT_QUERY_FORMAT_BASE64_ENCODED        = 2,
  CERT_QUERY_FORMAT_ASN_ASCII_HEX_ENCODED = 3
}

// dwExpectedFormatTypeFlags
enum : бцел {
  CERT_QUERY_FORMAT_FLAG_BINARY = 1 << CERT_QUERY_FORMAT_BINARY,
  CERT_QUERY_FORMAT_FLAG_BASE64_ENCODED = 1 << CERT_QUERY_FORMAT_BASE64_ENCODED,
  CERT_QUERY_FORMAT_FLAG_ASN_ASCII_HEX_ENCODED = 1 << CERT_QUERY_FORMAT_ASN_ASCII_HEX_ENCODED,
  CERT_QUERY_FORMAT_FLAG_ALL = CERT_QUERY_FORMAT_FLAG_BINARY |
    CERT_QUERY_FORMAT_FLAG_BASE64_ENCODED |
    CERT_QUERY_FORMAT_FLAG_ASN_ASCII_HEX_ENCODED
}

цел CryptQueryObject(бцел dwObjectType, in ук pvObject, бцел dwExpectedContentTypeFlags, бцел dwExpectedFormatTypeFlags, бцел dwFlags, бцел* pdwMsgAndCertEncodingType, бцел* pdwContentType, бцел* pdwFormatType, Укз* phCertStore, Укз* phMsg, ук* ppvContext);

extern(D):

static ткст дайОшСооб(бцел кодОш) {
  шим[256] буфер;
  бцел рез = FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS, null, кодОш, 0, буфер.ptr, буфер.length + 1, null);
  if (рез != 0) {
    ткст s = .вЮ8(буфер[0 .. рез]);

    while (рез > 0) {
      сим c = s[рез - 1];
      if (c > ' ' && c != '.')
        break;
      рез--;
    }
    return s[0 .. рез];
  }
  return фм("Неуказан ошибка (0x%08X)", кодОш);
}

class Win32Exception : Exception {

  private бцел errorCode_;

  this(бцел кодОш = GetLastError()) {
    this(кодОш, дайОшСооб(кодОш));
  }

  this(бцел кодОш, ткст сообщение) {
    super(сообщение);
    errorCode_ = кодОш;
  }

  бцел кодОш() {
    return errorCode_;
  }

}

// Runtime DLL support.

class ДллНеНайденаИскл : Exception {

  this(ткст сообщение = "Dll не найдена.") {
    super(сообщение);
  }

}

class ТочкаВходаНеНайденаИскл : Exception {

  this(ткст сообщение = "Точка входа в процедуру не найдена.") {
    super(сообщение);
  }

}

public enum CharSet {
  None,
  Ansi,
  Unicode,
  Авто
}

private ук addressOfFunction(ткст dllName, ткст entryPoint, CharSet charSet) {
  static Укз[ткст] moduleStore;

  Укз moduleHandle;
  if (auto значение = dllName in moduleStore)
    moduleHandle = *значение;
  else
    moduleStore[dllName] = moduleHandle = LoadLibrary(dllName.вЮ16н());

  if (moduleHandle == Укз.init)
    throw new ДллНеНайденаИскл("Невозможно загрузить DLL '" ~ dllName ~ "'.");

  ук func = null;

  // '#' denotes an ordinal запись.
  if (entryPoint[0] == '#') {
    version(D_Version2) {
      func = GetProcAddress(moduleHandle, cast(сим*)stdrus.to!(бкрат)(entryPoint[1 .. $]));
    }
    else {
      func = GetProcAddress(moduleHandle, cast(сим*) вБкрат(entryPoint[1 .. $]));
    }
  }    
  else {
    func = GetProcAddress(moduleHandle, entryPoint.вТкст0());
  }

  if (func == null) {
    CharSet linkType = charSet;
    if (charSet == CharSet.Авто)
      linkType = ((GetVersion() & 0x80000000) == 0) ? CharSet.Unicode : CharSet.Ansi;

    version(D_Version2) {
      ткст entryPointName = entryPoint.idup ~ ((linkType == CharSet.Ansi) ? 'A' : 'W');
    }
    else {
      ткст entryPointName = entryPoint.dup ~ ((linkType == CharSet.Ansi) ? 'A' : 'W');
    }

    func = GetProcAddress(moduleHandle, entryPointName.вТкст0());

    if (func == null)
      throw new ТочкаВходаНеНайденаИскл("Не удайтся найти точку входа '" ~ entryPoint ~ "' в DLL '" ~ dllName ~ "'.");
  }

  return func;
}

struct ДллИмпорт(ткст dllName, ткст entryPoint, ТФункция, CharSet charSet = CharSet.Авто) {

  static ВозврТип!(ТФункция) opCall(КортежТипаПараметр!(ТФункция) арги) {
    return (cast(ТФункция)addressOfFunction(dllName, entryPoint, charSet))(арги);
  }

}

extern(Windows):

alias ДллИмпорт!("kernel32.dll", "LCIDToLocaleName",
  цел function(бцел Locale, шим* lpName, цел cchName, бцел dwFlags)) LCIDToLocaleName;

alias ДллИмпорт!("nlsmap.dll", "DownlevelLCIDToLocaleName",
  цел function(бцел Locale, шим* lpName, цел cchName, бцел dwFlags)) DownlevelLCIDToLocaleName;

alias ДллИмпорт!("nlsdl.dll", "DownlevelGetParentLocaleName", 
  бцел function(бцел Locale, шим* lpName, цел cchName)) DownlevelGetParentLocaleName;

// XP
alias ДллИмпорт!("kernel32.dll", "GetGeoInfo", 
  цел function(бцел Location, бцел GeoType, шим* lpGeoData, цел cchData, бкрат LangId)) GetGeoInfo;

enum : бцел {
  FIND_STARTSWITH = 0x00100000,
  FIND_ENDSWITH   = 0x00200000,
  FIND_FROMSTART  = 0x00400000,
  FIND_FROMEND    = 0x00800000
}

// Vista
alias ДллИмпорт!("kernel32.dll", "FindNLSString",
  цел function(бцел Locale, бцел dwFindNLSStringFlags, in шим* lpStringSource, цел cchSource, in шим* lpStringValue, цел cchValue, цел* pcchFound)) FindNLSString;

alias ДллИмпорт!("kernel32.dll", "GetThreadIOPendingFlag",
  цел function(Укз hThread, цел* lpIOIsPending)) GetThreadIOPendingFlag;

enum SYSTEM_INFORMATION_CLASS : бцел {
  SystemProcessInformation = 5
}

struct SYSTEM_PROCESS_INFORMATION {
  цел nextEntryOffset;
  бцел numberOfThreads;
  дол spareLi1;
  дол spareLi2;
  дол spareLi3;
  дол createTime;
  дол userTime;
  дол kernelTime;
  бкрат nameLength;
  бкрат maximumNameLength;
  шим* nameBuffer;
  цел basePriority;
  бцел uniqueProcessId;
}

enum {
  STATUS_INFO_LENGTH_MISMATCH = 0xC0000004
}

alias ДллИмпорт!("ntdll.dll", "NtQuerySystemInformation",
  цел function(SYSTEM_INFORMATION_CLASS systemInformationClass, ук systemInformation, бцел systemInformationLength, бцел* returnLength)) NtQuerySystemInformation;

enum PROCESS_INFORMATION_CLASS : бцел {
  ProcessBasicInformation = 0
}

struct PROCESS_BASIC_INFORMATION {
  ук reserved1;
  ук pebBaseAddress;
  ук[2] reserved2;
  бцел uniqueProcessId;
  ук reserved3;
}

alias ДллИмпорт!("ntdll.dll", "NtQueryInformationProcess",
  цел function(Укз processHandle, PROCESS_INFORMATION_CLASS processInformationClass, ук processInformation, бцел processInformationLength, бцел* returnLength)) NtQueryInformationProcess;

alias ДллИмпорт!("advapi32.dll", "CreateProcessWithLogonW",
  BOOL function(in шим* lpUserName, in шим* lpDomain, in шим* lpPassword, бцел dwLogonFlags, in шим* lpApplicationName, in шим* lpCommandLine, бцел dwCreationFlags, ук lpEnvironment, in шим* lpCurrentDirectory, STARTUPINFOW* lpStartupInfo, PROCESS_INFORMATION* lpProcessInformation)) CreateProcessWithLogonW;
