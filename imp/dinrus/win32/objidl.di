/***********************************************************************\
*                                objidl.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
// TODO (Don):
// # why is "alias IPSFactoryBuffer* LPPSFACTORYBUFFER;" in this file,
// rather than in objfwd ?
// # do we need the proxies that are defined in this file?
module win32.objidl;

import win32.unknwn;
import win32.objfwd;
private import win32.windef;
private import win32.basetyps;
private import win32.oleidl;
private import win32.wtypes;
private import win32.winbase; // for FILETIME
private import win32.rpcdce;

struct  STATSTG {
	LPOLESTR pwcsName;
	DWORD тип;
	ULARGE_INTEGER cbSize;
	FILETIME mtime;
	FILETIME ctime;
	FILETIME atime;
	DWORD grfMode;
	DWORD grfLocksSupported;
	CLSID clsid;
	DWORD grfStateBits;
	DWORD reserved;
}

enum STGTY {
	STGTY_STORAGE = 1,
	STGTY_STREAM,
	STGTY_LOCKBYTES,
	STGTY_PROPERTY
}

enum STREAM_SEEK {
	STREAM_SEEK_SET,
	STREAM_SEEK_CUR,
	STREAM_SEEK_END
}

struct INTERFACEINFO {
	LPUNKNOWN pUnk;
	IID iid;
	WORD wMethod;
}
alias INTERFACEINFO* LPINTERFACEINFO;

enum CALLTYPE {
	CALLTYPE_TOPLEVEL = 1,
	CALLTYPE_NESTED,
	CALLTYPE_ASYNC,
	CALLTYPE_TOPLEVEL_CALLPENDING,
	CALLTYPE_ASYNC_CALLPENDING
}

enum PENDINGTYPE {
	PENDINGTYPE_TOPLEVEL = 1,
	PENDINGTYPE_NESTED
}

enum PENDINGMSG {
	PENDINGMSG_CANCELCALL = 0,
	PENDINGMSG_WAITNOPROCESS,
	PENDINGMSG_WAITDEFPROCESS
}

alias OLECHAR** SNB;

enum DATADIR {
	DATADIR_GET = 1,
	DATADIR_SET
}
alias WORD CLIPFORMAT;
alias CLIPFORMAT* LPCLIPFORMAT;

struct DVTARGETDEVICE {
	DWORD tdSize;
	WORD tdDriverNameOffset;
	WORD tdDeviceNameOffset;
	WORD tdPortNameOffset;
	WORD tdExtDevmodeOffset;
	BYTE tdData[1];
}

struct FORMATETC {
	CLIPFORMAT cfFormat;
	DVTARGETDEVICE* ptd;
	DWORD dwAspect;
	LONG lindex;
	DWORD tymed;
}
alias FORMATETC* LPFORMATETC;

struct RemSTGMEDIUM {
	DWORD tymed;
	DWORD dwHandleType;
	ULONG pData;
	бцел pUnkForRelease;
	бцел cbData;
	BYTE данные[1];
}

struct HLITEM {
	ULONG uHLID;
	LPWSTR pwzFriendlyName;
}

struct STATDATA {
	FORMATETC formatetc;
	DWORD grfAdvf;
	IAdviseSink* pAdvSink;
	DWORD dwConnection;
}

struct STATPROPSETSTG {
	FMTID fmtid;
	CLSID clsid;
	DWORD grfFlags;
	FILETIME mtime;
	FILETIME ctime;
	FILETIME atime;
}

enum EXTCONN {
	EXTCONN_STRONG   = 1,
	EXTCONN_WEAK     = 2,
	EXTCONN_CALLABLE = 4
}

struct MULTI_QI {
	IID*      pIID;
	IUnknown  pItf;
	HRESULT   hr;
}

struct AUTH_IDENTITY {
	USHORT* User;
	ULONG UserLength;
	USHORT* Domain;
	ULONG DomainLength;
	USHORT* Password;
	ULONG PasswordLength;
	ULONG Flags;
}

struct COAUTHINFO {
	DWORD dwAuthnSvc;
	DWORD dwAuthzSvc;
	LPWSTR pwszServerPrincName;
	DWORD dwAuthnLevel;
	DWORD dwImpersonationLevel;
	AUTH_IDENTITY* pAuthIdentityData;
	DWORD dwCapabilities;
}

struct  COSERVERINFO {
	DWORD dwReserved1;
	LPWSTR pwszName;
	COAUTHINFO* pAuthInfo;
	DWORD dwReserved2;
}

struct BIND_OPTS {
	DWORD cbStruct;
	DWORD grfFlags;
	DWORD grfMode;
	DWORD dwTickCountDeadline;
}
alias BIND_OPTS* LPBIND_OPTS;

struct BIND_OPTS2 {
	DWORD cbStruct;
	DWORD grfFlags;
	DWORD grfMode;
	DWORD dwTickCountDeadline;
	DWORD dwTrackFlags;
	DWORD dwClassContext;
	LCID локаль;
	COSERVERINFO* pServerInfo;
}
alias BIND_OPTS2* LPBIND_OPTS2;

enum BIND_FLAGS {
	BIND_MAYBOTHERUSER = 1,
	BIND_JUSTTESTEXISTENCE
}

struct STGMEDIUM {
	DWORD tymed;
	union {
		HBITMAP hBitmap;
		PVOID hMetaFilePict;
		HENHMETAFILE hEnhMetaFile;
		HGLOBAL hGlobal;
		LPWSTR lpszFileName;
		LPSTREAM pstm;
		LPSTORAGE pstg;
	}
	LPUNKNOWN pUnkForRelease;
}
alias STGMEDIUM* LPSTGMEDIUM;

enum LOCKTYPE {
	LOCK_WRITE     = 1,
	LOCK_EXCLUSIVE = 2,
	LOCK_ONLYONCE  = 4
}

alias бцел RPCOLEDATAREP;

struct  RPCOLEMESSAGE {
	PVOID reserved1;
	RPCOLEDATAREP dataRepresentation;
	PVOID Buffer;
	ULONG cbBuffer;
	ULONG iMethod;
	PVOID reserved2[5];
	ULONG rpcFlags;
}
alias RPCOLEMESSAGE* PRPCOLEMESSAGE;

enum MKSYS {
	MKSYS_NONE,
	MKSYS_GENERICCOMPOSITE,
	MKSYS_FILEMONIKER,
	MKSYS_ANTIMONIKER,
	MKSYS_ITEMMONIKER,
	MKSYS_POINTERMONIKER
}

enum MKREDUCE {
	MKRREDUCE_ALL,
	MKRREDUCE_ONE         = 196608,
	MKRREDUCE_TOUSER      = 131072,
	MKRREDUCE_THROUGHUSER = 65536
}

struct RemSNB {
	бцел ulCntStr;
	бцел ulCntChar;
	OLECHAR rgString[1];
}

enum ADVF {
	ADVF_NODATA            = 1,
	ADVF_PRIMEFIRST        = 2,
	ADVF_ONLYONCE          = 4,
	ADVFCACHE_NOHANDLER    = 8,
	ADVFCACHE_FORCEBUILTIN = 16,
	ADVFCACHE_ONSAVE       = 32,
	ADVF_DATAONSTOP        = 64
}

enum TYMED {
	TYMED_HGLOBAL  = 1,
	TYMED_FILE     = 2,
	TYMED_ISTREAM  = 4,
	TYMED_ISTORAGE = 8,
	TYMED_GDI      = 16,
	TYMED_MFPICT   = 32,
	TYMED_ENHMF    = 64,
	TYMED_NULL     = 0
}

enum SERVERCALL {
	SERVERCALL_ISHANDLED,
	SERVERCALL_REJECTED,
	SERVERCALL_RETRYLATER
}

struct CAUB {
	ULONG cElems;
	ббайт* pElems;
}

struct CAI {
	ULONG cElems;
	крат* pElems;
}

struct CAUI {
	ULONG cElems;
	USHORT* pElems;
}

struct CAL {
	ULONG cElems;
	цел* pElems;
}

struct CAUL {
	ULONG cElems;
	ULONG* pElems;
}

struct CAFLT {
	ULONG cElems;
	плав* pElems;
}

struct CADBL {
	ULONG cElems;
	дво* pElems;
}

struct CACY {
	ULONG cElems;
	CY* pElems;
}

struct CADATE {
	ULONG cElems;
	DATE* pElems;
}

struct CABSTR {
	ULONG cElems;
	BSTR*  pElems;
}

struct CABSTRBLOB {
	ULONG cElems;
	BSTRBLOB* pElems;
}

struct CABOOL {
	ULONG cElems;
	VARIANT_BOOL* pElems;
}

struct CASCODE {
	ULONG cElems;
	SCODE* pElems;
}

struct CAH {
	ULONG cElems;
	LARGE_INTEGER* pElems;
}

struct CAUH {
	ULONG cElems;
	ULARGE_INTEGER* pElems;
}

struct CALPSTR {
	ULONG cElems;
	LPSTR* pElems;
}

struct CALPWSTR {
	ULONG cElems;
	LPWSTR* pElems;
}

struct CAFILETIME {
	ULONG cElems;
	FILETIME* pElems;
}

struct CACLIPDATA {
	ULONG cElems;
	CLIPDATA* pElems;
}

struct CACLSID {
	ULONG cElems;
	CLSID* pElems;
}
alias PROPVARIANT* LPPROPVARIANT;

struct CAPROPVARIANT {
	ULONG cElems;
	LPPROPVARIANT pElems;
}

struct PROPVARIANT {
	VARTYPE vt;
	WORD wReserved1;
	WORD wReserved2;
	WORD wReserved3;
	union {
		CHAR cVal;
		UCHAR bVal;
		крат iVal;
		USHORT uiVal;
		VARIANT_BOOL boolVal;
		цел lVal;
		ULONG ulVal;
		плав fltVal;
		SCODE scode;
		LARGE_INTEGER hVal;
		ULARGE_INTEGER uhVal;
		дво dblVal;
		CY cyVal;
		DATE date;
		FILETIME filetime;
		CLSID* puuid;
		BLOB blob;
		CLIPDATA* pclipdata;
		LPSTREAM pStream;
		LPSTORAGE pStorage;
		BSTR bstrVal;
		BSTRBLOB bstrblobVal;
		LPSTR pszVal;
		LPWSTR pwszVal;
		CAUB caub;
		CAI cai;
		CAUI caui;
		CABOOL cabool;
		CAL cal;
		CAUL caul;
		CAFLT caflt;
		CASCODE cascode;
		CAH cah;
		CAUH cauh;
		CADBL cadbl;
		CACY cacy;
		CADATE cadate;
		CAFILETIME cafiletime;
		CACLSID cauuid;
		CACLIPDATA caclipdata;
		CABSTR cabstr;
		CABSTRBLOB cabstrblob;
		CALPSTR calpstr;
		CALPWSTR calpwstr;
		CAPROPVARIANT capropvar;
	}
}

struct PROPSPEC {
	ULONG ulKind;
	union {
		PROPID propid;
		LPOLESTR lpwstr;
	}
}

struct  STATPROPSTG {
	LPOLESTR lpwstrName;
	PROPID propid;
	VARTYPE vt;
}

enum PROPSETFLAG {
	PROPSETFLAG_DEFAULT,
	PROPSETFLAG_NONSIMPLE,
	PROPSETFLAG_ANSI,
	PROPSETFLAG_UNBUFFERED = 4
}

struct STORAGELAYOUT {
	DWORD LayoutType;
	OLECHAR* pwcsElementName;
	LARGE_INTEGER cOffset;
	LARGE_INTEGER cBytes;
}

struct SOLE_AUTHENTICATION_SERVICE {
	DWORD dwAuthnSvc;
	DWORD dwAuthzSvc;
	OLECHAR* pPrincipalName;
	HRESULT hr;
}

const OLECHAR* COLE_DEFAULT_PRINCIPAL = cast ( OLECHAR* )(-1);

enum EOLE_AUTHENTICATION_CAPABILITIES {
	EOAC_NONE              = 0,
	EOAC_MUTUAL_AUTH       = 0x1,
	EOAC_SECURE_REFS       = 0x2,
	EOAC_ACCESS_CONTROL    = 0x4,
	EOAC_APPID             = 0x8,
	EOAC_DYNAMIC           = 0x10,
	EOAC_STATIC_CLOAKING   = 0x20,
	EOAC_DYNAMIC_CLOAKING  = 0x40,
	EOAC_ANY_AUTHORITY     = 0x80,
	EOAC_MAKE_FULLSIC      = 0x100,
	EOAC_REQUIRE_FULLSIC   = 0x200,
	EOAC_AUTO_IMPERSONATE  = 0x400,
	EOAC_DEFAULT           = 0x800,
	EOAC_DISABLE_AAA       = 0x1000,
	EOAC_NO_CUSTOM_MARSHAL = 0x2000
}

struct SOLE_AUTHENTICATION_INFO {
	DWORD dwAuthnSvc;
	DWORD dwAuthzSvc;
	проц* pAuthInfo;
}

const проц* COLE_DEFAULT_AUTHINFO = cast( проц* )(-1 );

struct SOLE_AUTHENTICATION_LIST {
	DWORD cAuthInfo;
	SOLE_AUTHENTICATION_INFO* aAuthInfo;
}

interface IEnumFORMATETC : public IUnknown {
	  HRESULT Next(ULONG, FORMATETC*, ULONG*);
	  HRESULT Skip(ULONG);
	  HRESULT Reset();
	  HRESULT Clone(IEnumFORMATETC**);
}

interface IEnumHLITEM : public IUnknown {
	  HRESULT Next(ULONG, HLITEM*, ULONG*);
	  HRESULT Skip(ULONG);
	  HRESULT Reset();
	  HRESULT Clone(IEnumHLITEM**);
}

interface IEnumSTATDATA : public IUnknown {
	  HRESULT Next(ULONG, STATDATA*, ULONG*);
	  HRESULT Skip(ULONG);
	  HRESULT Reset();
	  HRESULT Clone(IEnumSTATDATA**);
}

interface IEnumSTATPROPSETSTG : public IUnknown {
	  HRESULT Next(ULONG, STATPROPSETSTG*, ULONG*);
	  HRESULT Skip(ULONG);
	  HRESULT Reset();
	  HRESULT Clone(IEnumSTATPROPSETSTG**);
}

interface IEnumSTATPROPSTG : public IUnknown {
	  HRESULT Next(ULONG, STATPROPSTG*, ULONG*);
	  HRESULT Skip(ULONG);
	  HRESULT Reset();
	  HRESULT Clone(IEnumSTATPROPSTG**);
}

interface IEnumSTATSTG : public IUnknown {
	  HRESULT Next(ULONG, STATSTG*, ULONG*);
	  HRESULT Skip(ULONG);
	  HRESULT Reset();
	  HRESULT Clone(IEnumSTATSTG**);
}

interface IEnumString : public IUnknown {
	  HRESULT Next(ULONG, LPOLESTR*, ULONG*);
	  HRESULT Skip(ULONG);
	  HRESULT Reset();
	  HRESULT Clone(IEnumString**);
}

interface IEnumMoniker : public IUnknown {
	  HRESULT Next(ULONG, IMoniker*, ULONG*);
	  HRESULT Skip(ULONG);
	  HRESULT Reset();
	  HRESULT Clone(IEnumMoniker**);
}


interface IEnumUnknown : public IUnknown {
	  HRESULT Next(ULONG, IUnknown*, ULONG*);
	  HRESULT Skip(ULONG);
	  HRESULT Reset();
	  HRESULT Clone(IEnumUnknown**);
}

interface ISequentialStream : public IUnknown {
	HRESULT Read(проц*, ULONG, ULONG*);
	HRESULT Write(проц* , ULONG, ULONG*);
}

interface IStream : public ISequentialStream {
	HRESULT Seek(LARGE_INTEGER, DWORD, ULARGE_INTEGER*);
	HRESULT SetSize(ULARGE_INTEGER);
	HRESULT CopyTo(IStream, ULARGE_INTEGER, ULARGE_INTEGER*, ULARGE_INTEGER*);
	HRESULT Commit(DWORD);
	HRESULT Revert();
	HRESULT LockRegion(ULARGE_INTEGER, ULARGE_INTEGER, DWORD);
	HRESULT UnlockRegion(ULARGE_INTEGER, ULARGE_INTEGER, DWORD);
	HRESULT Stat(STATSTG*, DWORD);
	HRESULT Clone(LPSTREAM*);
}

interface IMarshal : public IUnknown {
	HRESULT GetUnmarshalClass(REFIID, PVOID, DWORD, PVOID, DWORD, CLSID*);
	HRESULT GetMarshalSizeMax(REFIID, PVOID, DWORD, PVOID, PDWORD, ULONG*);
	HRESULT MarshalInterface(IStream, REFIID, PVOID, DWORD, PVOID, DWORD);
	HRESULT UnmarshalInterface(IStream, REFIID, проц**);
	HRESULT ReleaseMarshalData(IStream);
	HRESULT DisconnectObject(DWORD);
}

interface IStdMarshalInfo : public IUnknown {
	HRESULT GetClassForHandler(DWORD, PVOID, CLSID*);
}

interface IMalloc : public IUnknown {
	проц* Alloc(ULONG);
	проц* Realloc(проц*, ULONG);
	проц Free(проц*);
	ULONG GetSize(проц*);
	цел DidAlloc(проц*);
	проц HeapMinimize();
}

interface IMallocSpy : public IUnknown {
	ULONG PreAlloc(ULONG);
	проц* PostAlloc(проц*);
	проц* PreFree(проц*, BOOL);
	проц PostFree(BOOL);
	ULONG PreRealloc(проц*, ULONG, проц**, BOOL);
	проц* PostRealloc(проц*, BOOL);
	проц* PreGetSize(проц*, BOOL);
	ULONG PostGetSize(ULONG, BOOL);
	проц* PreDidAlloc(проц*, BOOL);
	цел PostDidAlloc(проц*, BOOL, цел);
	проц PreHeapMinimize();
	проц PostHeapMinimize();
}

interface IMessageFilter : public IUnknown {
	DWORD HandleInComingCall(DWORD, HTASK, DWORD, LPINTERFACEINFO);
	DWORD RetryRejectedCall(HTASK, DWORD, DWORD);
	DWORD MessagePending(HTASK, DWORD, DWORD);
}


interface IPersist : public IUnknown {
	HRESULT GetClassID(CLSID*);
}

interface IPersistStream : public IPersist {
	HRESULT IsDirty();
	HRESULT Load(IStream*);
	HRESULT Save(IStream*, BOOL);
	HRESULT GetSizeMax(PULARGE_INTEGER);
}

interface IRunningObjectTable : public IUnknown {
	HRESULT Register(DWORD, LPUNKNOWN, LPMONIKER, PDWORD);
	HRESULT Revoke(DWORD);
	HRESULT IsRunning(LPMONIKER);
	HRESULT GetObject(LPMONIKER, LPUNKNOWN*);
	HRESULT NoteChangeTime(DWORD, LPFILETIME);
	HRESULT GetTimeOfLastChange(LPMONIKER, LPFILETIME);
	HRESULT EnumRunning(IEnumMoniker**);
}

interface IBindCtx : public IUnknown {
	HRESULT RegisterObjectBound(LPUNKNOWN);
	HRESULT RevokeObjectBound(LPUNKNOWN);
	HRESULT ReleaseBoundObjects();
	HRESULT SetBindOptions(LPBIND_OPTS);
	HRESULT GetBindOptions(LPBIND_OPTS);
	HRESULT GetRunningObjectTable(IRunningObjectTable**);
	HRESULT RegisterObjectParam(LPOLESTR, IUnknown*);
	HRESULT GetObjectParam(LPOLESTR, IUnknown**);
	HRESULT EnumObjectParam(IEnumString**);
	HRESULT RevokeObjectParam(LPOLESTR);
}

interface IMoniker: public IPersistStream {
	HRESULT BindToObject(IBindCtx*, IMoniker*, REFIID, PVOID*);
	HRESULT BindToStorage(IBindCtx*, IMoniker*, REFIID, PVOID*);
	HRESULT Reduce(IBindCtx*, DWORD, IMoniker**, IMoniker**);
	HRESULT ComposeWith(IMoniker*, BOOL, IMoniker**);
	HRESULT Enum(BOOL, IEnumMoniker**);
	HRESULT IsEqual(IMoniker*);
	HRESULT Hash(PDWORD);
	HRESULT IsRunning(IBindCtx*, IMoniker*, IMoniker*);
	HRESULT GetTimeOfLastChange(IBindCtx*, IMoniker*, LPFILETIME);
	HRESULT Inverse(IMoniker**);
	HRESULT CommonPrefixWith(IMoniker*, IMoniker**);
	HRESULT RelativePathTo(IMoniker*, IMoniker**);
	HRESULT GetDisplayName(IBindCtx*, IMoniker*, LPOLESTR*);
	HRESULT ParseDisplayName(IBindCtx*, IMoniker*, LPOLESTR, ULONG*, IMoniker**);
	HRESULT IsSystemMoniker(PDWORD);
}

interface IPersistStorage : public IPersist
{
	HRESULT IsDirty();
	HRESULT InitNew(LPSTORAGE);
	HRESULT Load(LPSTORAGE);
	HRESULT Save(LPSTORAGE, BOOL);
	HRESULT SaveCompleted(LPSTORAGE);
	HRESULT HandsOffStorage();
}

interface IPersistFile : public IPersist
{
	HRESULT IsDirty();
	HRESULT Load(LPCOLESTR, DWORD);
	HRESULT Save(LPCOLESTR, BOOL);
	HRESULT SaveCompleted(LPCOLESTR);
	HRESULT GetCurFile(LPOLESTR*);
}

interface IAdviseSink : public IUnknown {
	HRESULT QueryInterface(REFIID, PVOID*);
	ULONG AddRef();
	ULONG Release();
	проц OnDataChange(FORMATETC*, STGMEDIUM*);
	проц OnViewChange(DWORD, LONG);
	проц OnRename(IMoniker*);
	проц OnSave();
	проц OnClose();
}

interface IAdviseSink2 : public IAdviseSink
{
	проц OnLinkSrcChange(IMoniker*);
}

interface IDataObject : public IUnknown {
	HRESULT GetData(FORMATETC*, STGMEDIUM*);
	HRESULT GetDataHere(FORMATETC*, STGMEDIUM*);
	HRESULT QueryGetData(FORMATETC*);
	HRESULT GetCanonicalFormatEtc(FORMATETC*, FORMATETC*);
	HRESULT SetData(FORMATETC*, STGMEDIUM*, BOOL);
	HRESULT EnumFormatEtc(DWORD, IEnumFORMATETC**);
	HRESULT DAdvise(FORMATETC*, DWORD, IAdviseSink*, PDWORD);
	HRESULT DUnadvise(DWORD);
	HRESULT EnumDAdvise(IEnumSTATDATA**);
}

interface IDataAdviseHolder : public IUnknown {
	HRESULT Advise(IDataObject*, FORMATETC*, DWORD, IAdviseSink*, PDWORD);
	HRESULT Unadvise(DWORD);
	HRESULT EnumAdvise(IEnumSTATDATA**);
	HRESULT SendOnDataChange(IDataObject*, DWORD, DWORD);
}

interface IStorage : public IUnknown {
	HRESULT CreateStream(LPCWSTR, DWORD, DWORD, DWORD, IStream*);
	HRESULT OpenStream(LPCWSTR, PVOID, DWORD, DWORD, IStream*);
	HRESULT CreateStorage(LPCWSTR, DWORD, DWORD, DWORD, IStorage*);
	HRESULT OpenStorage(LPCWSTR, IStorage, DWORD, SNB, DWORD, IStorage*);
	HRESULT CopyTo(DWORD, IID* , SNB, IStorage);
	HRESULT MoveElementTo(LPCWSTR, IStorage, LPCWSTR, DWORD);
	HRESULT Commit(DWORD);
	HRESULT Revert();
	HRESULT EnumElements(DWORD, PVOID, DWORD, IEnumSTATSTG*);
	HRESULT DestroyElement(LPCWSTR);
	HRESULT RenameElement(LPCWSTR, LPCWSTR);
	HRESULT SetElementTimes(LPCWSTR, FILETIME* , FILETIME* , FILETIME* );
	HRESULT SetClass(REFCLSID);
	HRESULT SetStateBits(DWORD, DWORD);
	HRESULT Stat(STATSTG*, DWORD);
}

// FIXME: GetClassID from IPersist not there - what to do about it?
interface IRootStorage : public IPersist {
	HRESULT QueryInterface(REFIID, PVOID*);
	ULONG AddRef();
	ULONG Release();
	HRESULT SwitchToFile(LPOLESTR);
}

interface IRpcChannelBuffer : public IUnknown {
	HRESULT GetBuffer(RPCOLEMESSAGE*, REFIID);
	HRESULT SendReceive(RPCOLEMESSAGE*, PULONG);
	HRESULT FreeBuffer(RPCOLEMESSAGE*);
	HRESULT GetDestCtx(PDWORD, PVOID*);
	HRESULT IsConnected();
}

interface IRpcProxyBuffer : public IUnknown {
	HRESULT Connect(IRpcChannelBuffer*);
	проц Disconnect();
}

interface IRpcStubBuffer : public IUnknown {
	HRESULT Connect(LPUNKNOWN);
	проц Disconnect();
	HRESULT Invoke(RPCOLEMESSAGE*, LPRPCSTUBBUFFER);
	LPRPCSTUBBUFFER IsIIDSupported(REFIID);
	ULONG CountRefs();
	HRESULT DebugServerQueryInterface(PVOID*);
	HRESULT DebugServerRelease(PVOID);
}

interface IPSFactoryBuffer : public IUnknown {
	HRESULT CreateProxy(LPUNKNOWN, REFIID, LPRPCPROXYBUFFER*, PVOID*);
	HRESULT CreateStub(REFIID, LPUNKNOWN, LPRPCSTUBBUFFER*);
}
alias IPSFactoryBuffer* LPPSFACTORYBUFFER;

interface ILockBytes : public IUnknown {
	HRESULT ReadAt(ULARGE_INTEGER, PVOID, ULONG, ULONG*);
	HRESULT WriteAt(ULARGE_INTEGER, PCVOID, ULONG, ULONG*);
	HRESULT Flush();
	HRESULT SetSize(ULARGE_INTEGER);
	HRESULT LockRegion(ULARGE_INTEGER, ULARGE_INTEGER, DWORD);
	HRESULT UnlockRegion(ULARGE_INTEGER, ULARGE_INTEGER, DWORD);
	HRESULT Stat(STATSTG*, DWORD);
}

interface IExternalConnection : public IUnknown {
	HRESULT AddConnection(DWORD, DWORD);
	HRESULT ReleaseConnection(DWORD, DWORD, BOOL);
}

interface IRunnableObject : public IUnknown {
	HRESULT GetRunningClass(LPCLSID);
	HRESULT Run(LPBC);
	BOOL IsRunning();
	HRESULT LockRunning(BOOL, BOOL);
	HRESULT SetContainedObject(BOOL);
}

interface IROTData : public IUnknown {
	HRESULT GetComparisonData(PVOID, ULONG, PULONG);
}

interface IChannelHook : public IUnknown {
	проц ClientGetSize(REFGUID, REFIID, PULONG);
	проц ClientFillBuffer(REFGUID, REFIID, PULONG, PVOID);
	проц ClientNotify(REFGUID, REFIID, ULONG, PVOID, DWORD, HRESULT);
	проц ServerNotify(REFGUID, REFIID, ULONG, PVOID, DWORD);
	проц ServerGetSize(REFGUID, REFIID, HRESULT, PULONG);
	проц ServerFillBuffer(REFGUID, REFIID, PULONG, PVOID, HRESULT);
}

interface IPropertyStorage : public IUnknown {
	HRESULT ReadMultiple(ULONG, PROPSPEC* , PROPVARIANT*);
	HRESULT WriteMultiple(ULONG, PROPSPEC* , PROPVARIANT*, PROPID);
	HRESULT DeleteMultiple(ULONG, PROPSPEC* );
	HRESULT ReadPropertyNames(ULONG, PROPID* , LPWSTR*);
	HRESULT WritePropertyNames(ULONG, PROPID* , LPWSTR* );
	HRESULT DeletePropertyNames(ULONG, PROPID* );
	HRESULT SetClass(REFCLSID);
	HRESULT Commit(DWORD);
	HRESULT Revert();
	HRESULT Enum(IEnumSTATPROPSTG**);
	HRESULT Stat(STATPROPSTG*);
	HRESULT SetTimes(FILETIME* , FILETIME* , FILETIME* );
}

interface IPropertySetStorage : public IUnknown {
	HRESULT Create(REFFMTID, CLSID*, DWORD, DWORD, LPPROPERTYSTORAGE*);
	HRESULT Open(REFFMTID, DWORD, LPPROPERTYSTORAGE*);
	HRESULT Delete(REFFMTID);
	HRESULT Enum(IEnumSTATPROPSETSTG**);
}

interface IClientSecurity : public IUnknown {
	HRESULT QueryBlanket(PVOID, PDWORD, PDWORD, OLECHAR**, PDWORD, PDWORD, RPC_AUTH_IDENTITY_HANDLE**, PDWORD*);
	HRESULT SetBlanket(PVOID, DWORD, DWORD, LPWSTR, DWORD, DWORD, RPC_AUTH_IDENTITY_HANDLE*, DWORD);
	HRESULT CopyProxy(LPUNKNOWN, LPUNKNOWN*);
}

interface IServerSecurity : public IUnknown {
	HRESULT QueryBlanket(PDWORD, PDWORD, OLECHAR**, PDWORD, PDWORD, RPC_AUTHZ_HANDLE*, PDWORD*);
	HRESULT ImpersonateClient();
	HRESULT RevertToSelf();
	HRESULT IsImpersonating();
}

interface IClassActivator : public IUnknown {
	HRESULT GetClassObject(REFCLSID, DWORD, LCID, REFIID, PVOID*);
}

interface IFillLockBytes : public IUnknown {
	HRESULT FillAppend(проц* , ULONG, PULONG);
	HRESULT FillAt(ULARGE_INTEGER, проц* , ULONG, PULONG);
	HRESULT SetFillSize(ULARGE_INTEGER);
	HRESULT Terminate(BOOL);
}

interface IProgressNotify : public IUnknown {
	HRESULT OnProgress(DWORD, DWORD, BOOL, BOOL);
}

interface ILayoutStorage : public IUnknown {
	HRESULT LayoutScript(STORAGELAYOUT*, DWORD, DWORD);
	HRESULT BeginMonitor();
	HRESULT EndMonitor();
	HRESULT ReLayoutDocfile(OLECHAR*);
}

interface IGlobalInterfaceTable : public IUnknown {
	HRESULT RegisterInterfaceInGlobal(IUnknown*, REFIID, DWORD*);
	HRESULT RevokeInterfaceFromGlobal(DWORD);
	HRESULT GetInterfaceFromGlobal(DWORD, REFIID, проц**);
}

/+
// These are probably unnecessary for D.
extern (Windows) {
HRESULT IMarshal_GetUnmarshalClass_Proxy(IMarshal*, REFIID, проц*, DWORD, проц*, DWORD, CLSID*);
проц IMarshal_GetUnmarshalClass_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMarshal_GetMarshalSizeMax_Proxy(IMarshal*, REFIID, проц*, DWORD, проц*, DWORD, DWORD*);
проц IMarshal_GetMarshalSizeMax_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMarshal_MarshalInterface_Proxy(IMarshal*, IStream*, REFIID, проц*, DWORD, проц*, DWORD);
проц IMarshal_MarshalInterface_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMarshal_UnmarshalInterface_Proxy(IMarshal*, IStream*, REFIID, проц**);
проц IMarshal_UnmarshalInterface_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMarshal_ReleaseMarshalData_Proxy(IMarshal*, IStream*);
проц IMarshal_ReleaseMarshalData_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMarshal_DisconnectObject_Proxy(IMarshal*, DWORD);
проц IMarshal_DisconnectObject_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц* IMalloc_Alloc_Proxy(IMalloc*, ULONG);
проц IMalloc_Alloc_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц* IMalloc_Realloc_Proxy(IMalloc*, проц*, ULONG);
проц IMalloc_Realloc_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц IMalloc_Free_Proxy(IMalloc*, проц*);
проц IMalloc_Free_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
ULONG IMalloc_GetSize_Proxy(IMalloc*, проц*);
проц IMalloc_GetSize_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
цел IMalloc_DidAlloc_Proxy(IMalloc*, проц*);
проц IMalloc_DidAlloc_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц IMalloc_HeapMinimize_Proxy(IMalloc*);
проц IMalloc_HeapMinimize_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
ULONG IMallocSpy_PreAlloc_Proxy(IMallocSpy*, ULONG cbRequest);
проц IMallocSpy_PreAlloc_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц* IMallocSpy_PostAlloc_Proxy(IMallocSpy*, проц*);
проц IMallocSpy_PostAlloc_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц* IMallocSpy_PreFree_Proxy(IMallocSpy*, проц*, BOOL);
проц IMallocSpy_PreFree_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц IMallocSpy_PostFree_Proxy(IMallocSpy*, BOOL);
проц IMallocSpy_PostFree_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
ULONG IMallocSpy_PreRealloc_Proxy(IMallocSpy*, проц*, ULONG, проц**, BOOL);
проц IMallocSpy_PreRealloc_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц* IMallocSpy_PostRealloc_Proxy(IMallocSpy*, проц*, BOOL);
проц IMallocSpy_PostRealloc_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц* IMallocSpy_PreGetSize_Proxy(IMallocSpy*, проц*, BOOL);
проц IMallocSpy_PreGetSize_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
ULONG IMallocSpy_PostGetSize_Proxy(IMallocSpy*, ULONG, BOOL);
проц IMallocSpy_PostGetSize_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц* IMallocSpy_PreDidAlloc_Proxy(IMallocSpy*, проц*, BOOL);
проц IMallocSpy_PreDidAlloc_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
цел IMallocSpy_PostDidAlloc_Proxy(IMallocSpy*, проц*, BOOL, цел);
проц IMallocSpy_PostDidAlloc_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц IMallocSpy_PreHeapMinimize_Proxy(IMallocSpy* );
проц IMallocSpy_PreHeapMinimize_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц IMallocSpy_PostHeapMinimize_Proxy(IMallocSpy*);
проц IMallocSpy_PostHeapMinimize_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStdMarshalInfo_GetClassForHandler_Proxy(IStdMarshalInfo*, DWORD, проц*, CLSID*);
проц IStdMarshalInfo_GetClassForHandler_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
DWORD IExternalConnection_AddConnection_Proxy(IExternalConnection*, DWORD, DWORD);
проц IExternalConnection_AddConnection_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
DWORD IExternalConnection_ReleaseConnection_Proxy(IExternalConnection*, DWORD, DWORD, BOOL);
проц IExternalConnection_ReleaseConnection_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumUnknown_RemoteNext_Proxy(IEnumUnknown*, ULONG, IUnknown**, ULONG*);
проц IEnumUnknown_RemoteNext_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumUnknown_Skip_Proxy(IEnumUnknown*, ULONG);
проц IEnumUnknown_Skip_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumUnknown_Reset_Proxy(IEnumUnknown* );
проц IEnumUnknown_Reset_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumUnknown_Clone_Proxy(IEnumUnknown*, IEnumUnknown**);
проц IEnumUnknown_Clone_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IBindCtx_RegisterObjectBound_Proxy(IBindCtx*, IUnknown*punk);
проц IBindCtx_RegisterObjectBound_Stub(IRpcStubBuffer*, IRpcChannelBuffer*_pRpcChannelBuffer, PRPC_MESSAGE, PDWORD);
HRESULT IBindCtx_RevokeObjectBound_Proxy(IBindCtx*, IUnknown*punk);
проц IBindCtx_RevokeObjectBound_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IBindCtx_ReleaseBoundObjects_Proxy(IBindCtx*);
проц IBindCtx_ReleaseBoundObjects_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IBindCtx_SetBindOptions_Proxy(IBindCtx*, BIND_OPTS*);
проц IBindCtx_SetBindOptions_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IBindCtx_GetBindOptions_Proxy(IBindCtx*, BIND_OPTS*pbindopts);
проц IBindCtx_GetBindOptions_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IBindCtx_GetRunningObjectTable_Proxy(IBindCtx*, IRunningObjectTable**);
проц IBindCtx_GetRunningObjectTable_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IBindCtx_RegisterObjectParam_Proxy(IBindCtx*, LPCSTR, IUnknown*);
проц IBindCtx_RegisterObjectParam_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IBindCtx_GetObjectParam_Proxy(IBindCtx*, LPCSTR, IUnknown**);
проц IBindCtx_GetObjectParam_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IBindCtx_EnumObjectParam_Proxy(IBindCtx*, IEnumString**);
проц IBindCtx_EnumObjectParam_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IBindCtx_RevokeObjectParam_Proxy(IBindCtx*, LPCSTR);
проц IBindCtx_RevokeObjectParam_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumMoniker_RemoteNext_Proxy(IEnumMoniker*, ULONG, IMoniker**, ULONG*);
проц IEnumMoniker_RemoteNext_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumMoniker_Skip_Proxy(IEnumMoniker*, ULONG);
проц IEnumMoniker_Skip_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumMoniker_Reset_Proxy(IEnumMoniker*);
проц IEnumMoniker_Reset_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumMoniker_Clone_Proxy(IEnumMoniker*, IEnumMoniker**);
проц IEnumMoniker_Clone_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRunnableObject_GetRunningClass_Proxy(IRunnableObject*, LPCLSID);
проц IRunnableObject_GetRunningClass_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRunnableObject_Run_Proxy(IRunnableObject*, LPBINDCTX);
проц IRunnableObject_Run_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
BOOL IRunnableObject_IsRunning_Proxy(IRunnableObject*);
проц IRunnableObject_IsRunning_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRunnableObject_LockRunning_Proxy(IRunnableObject*, BOOL, BOOL);
проц IRunnableObject_LockRunning_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRunnableObject_SetContainedObject_Proxy(IRunnableObject*, BOOL);
проц IRunnableObject_SetContainedObject_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRunningObjectTable_Register_Proxy(IRunningObjectTable*, DWORD, IUnknown*, IMoniker*, DWORD*);
проц IRunningObjectTable_Register_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRunningObjectTable_Revoke_Proxy(IRunningObjectTable*, DWORD);
проц IRunningObjectTable_Revoke_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRunningObjectTable_IsRunning_Proxy(IRunningObjectTable*, IMoniker*);
проц IRunningObjectTable_IsRunning_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRunningObjectTable_GetObject_Proxy(IRunningObjectTable*, IMoniker*, IUnknown**);
проц IRunningObjectTable_GetObject_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRunningObjectTable_NoteChangeTime_Proxy(IRunningObjectTable*, DWORD, FILETIME*);
проц IRunningObjectTable_NoteChangeTime_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRunningObjectTable_GetTimeOfLastChange_Proxy(IRunningObjectTable*, IMoniker*, FILETIME*);
проц IRunningObjectTable_GetTimeOfLastChange_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRunningObjectTable_EnumRunning_Proxy(IRunningObjectTable*, IEnumMoniker**);
проц IRunningObjectTable_EnumRunning_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersist_GetClassID_Proxy(IPersist*, CLSID*);
проц IPersist_GetClassID_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersistStream_IsDirty_Proxy(IPersistStream*);
проц IPersistStream_IsDirty_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersistStream_Load_Proxy(IPersistStream*, IStream*);
проц IPersistStream_Load_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersistStream_Save_Proxy(IPersistStream*, IStream*, BOOL);
проц IPersistStream_Save_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersistStream_GetSizeMax_Proxy(IPersistStream*, ULARGE_INTEGER*);
проц IPersistStream_GetSizeMax_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMoniker_RemoteBindToObject_Proxy(IMoniker*, IBindCtx*, IMoniker*, REFIID, IUnknown**);
проц IMoniker_RemoteBindToObject_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMoniker_RemoteBindToStorage_Proxy(IMoniker*, IBindCtx*, IMoniker*, REFIID, IUnknown**);
проц IMoniker_RemoteBindToStorage_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMoniker_Reduce_Proxy(IMoniker*, IBindCtx*, DWORD, IMoniker**, IMoniker**);
проц IMoniker_Reduce_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMoniker_ComposeWith_Proxy(IMoniker*, IMoniker*, BOOL, IMoniker**);
проц IMoniker_ComposeWith_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMoniker_Enum_Proxy(IMoniker*, BOOL, IEnumMoniker**);
проц IMoniker_Enum_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMoniker_IsEqual_Proxy(IMoniker*, IMoniker*);
проц IMoniker_IsEqual_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMoniker_Hash_Proxy(IMoniker*, DWORD*);
проц IMoniker_Hash_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMoniker_IsRunning_Proxy(IMoniker*, IBindCtx*, IMoniker*, IMoniker*);
проц IMoniker_IsRunning_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMoniker_GetTimeOfLastChange_Proxy(IMoniker*, IBindCtx*, IMoniker*, FILETIME*);
проц IMoniker_GetTimeOfLastChange_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMoniker_Inverse_Proxy(IMoniker*, IMoniker**);
проц IMoniker_Inverse_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMoniker_CommonPrefixWith_Proxy(IMoniker*, IMoniker*, IMoniker**);
проц IMoniker_CommonPrefixWith_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMoniker_RelativePathTo_Proxy(IMoniker*, IMoniker*, IMoniker**);
проц IMoniker_RelativePathTo_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMoniker_GetDisplayName_Proxy(IMoniker*, IBindCtx*, IMoniker*, LPCSTR*);
проц IMoniker_GetDisplayName_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMoniker_ParseDisplayName_Proxy(IMoniker*, IBindCtx*, IMoniker*, LPCSTR, ULONG*, IMoniker**);
проц IMoniker_ParseDisplayName_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IMoniker_IsSystemMoniker_Proxy(IMoniker*, DWORD*);
проц IMoniker_IsSystemMoniker_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IROTData_GetComparisonData_Proxy(IROTData*, BYTE*, ULONG cbMax, ULONG*);
проц IROTData_GetComparisonData_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumString_RemoteNext_Proxy(IEnumString*, ULONG, LPCSTR*rgelt, ULONG*);
проц IEnumString_RemoteNext_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumString_Skip_Proxy(IEnumString*, ULONG);
проц IEnumString_Skip_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumString_Reset_Proxy(IEnumString*);
проц IEnumString_Reset_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumString_Clone_Proxy(IEnumString*, IEnumString**);
проц IEnumString_Clone_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStream_RemoteRead_Proxy(IStream*, BYTE*, ULONG, ULONG*);
проц IStream_RemoteRead_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStream_RemoteWrite_Proxy(IStream*, BYTE*pv, ULONG, ULONG*);
проц IStream_RemoteWrite_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStream_RemoteSeek_Proxy(IStream*, LARGE_INTEGER, DWORD, ULARGE_INTEGER*);
проц IStream_RemoteSeek_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStream_SetSize_Proxy(IStream*, ULARGE_INTEGER);
проц IStream_SetSize_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStream_RemoteCopyTo_Proxy(IStream*, IStream*, ULARGE_INTEGER, ULARGE_INTEGER*, ULARGE_INTEGER*);
проц IStream_RemoteCopyTo_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStream_Commit_Proxy(IStream*, DWORD);
проц IStream_Commit_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStream_Revert_Proxy(IStream*);
проц IStream_Revert_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStream_LockRegion_Proxy(IStream*, ULARGE_INTEGER, ULARGE_INTEGER, DWORD);
проц IStream_LockRegion_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStream_UnlockRegion_Proxy(IStream*, ULARGE_INTEGER, ULARGE_INTEGER, DWORD);
проц IStream_UnlockRegion_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStream_Stat_Proxy(IStream*, STATSTG*, DWORD);
проц IStream_Stat_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStream_Clone_Proxy(IStream*, IStream**);
проц IStream_Clone_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumSTATSTG_RemoteNext_Proxy(IEnumSTATSTG*, ULONG, STATSTG*, ULONG*);
проц IEnumSTATSTG_RemoteNext_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumSTATSTG_Skip_Proxy(IEnumSTATSTG*, ULONG celt);
проц IEnumSTATSTG_Skip_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumSTATSTG_Reset_Proxy(IEnumSTATSTG*);
проц IEnumSTATSTG_Reset_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumSTATSTG_Clone_Proxy(IEnumSTATSTG*, IEnumSTATSTG**);
проц IEnumSTATSTG_Clone_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStorage_CreateStream_Proxy(IStorage*, OLECHAR*, DWORD, DWORD, DWORD, IStream**);
проц IStorage_CreateStream_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStorage_RemoteOpenStream_Proxy(IStorage*, OLECHAR*, бцел, BYTE*, DWORD, DWORD, IStream**);
проц IStorage_RemoteOpenStream_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStorage_CreateStorage_Proxy(IStorage*, OLECHAR*, DWORD, DWORD, DWORD, IStorage**);
проц IStorage_CreateStorage_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStorage_OpenStorage_Proxy(IStorage*, OLECHAR*, IStorage*, DWORD, SNB, DWORD, IStorage**);
проц IStorage_OpenStorage_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStorage_CopyTo_Proxy(IStorage*, DWORD, IID*, SNB, IStorage*);
проц IStorage_CopyTo_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStorage_MoveElementTo_Proxy(IStorage*, OLECHAR*, IStorage*, OLECHAR*, DWORD);
проц IStorage_MoveElementTo_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStorage_Commit_Proxy(IStorage*, DWORD);
проц IStorage_Commit_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStorage_Revert_Proxy(IStorage*);
проц IStorage_Revert_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStorage_RemoteEnumElements_Proxy(IStorage*, DWORD, бцел, BYTE*, DWORD, IEnumSTATSTG**);
проц IStorage_RemoteEnumElements_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStorage_DestroyElement_Proxy(IStorage*, OLECHAR*);
проц IStorage_DestroyElement_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStorage_RenameElement_Proxy(IStorage*, OLECHAR*, OLECHAR*);
проц IStorage_RenameElement_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStorage_SetElementTimes_Proxy(IStorage*, OLECHAR*, FILETIME*, FILETIME*, FILETIME*);
проц IStorage_SetElementTimes_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStorage_SetClass_Proxy(IStorage*, REFCLSID);
проц IStorage_SetClass_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStorage_SetStateBits_Proxy(IStorage*, DWORD, DWORD);
проц IStorage_SetStateBits_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IStorage_Stat_Proxy(IStorage*, STATSTG*, DWORD);
проц IStorage_Stat_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersistFile_IsDirty_Proxy(IPersistFile*);
проц IPersistFile_IsDirty_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersistFile_Load_Proxy(IPersistFile*, LPCOLESTR, DWORD);
проц IPersistFile_Load_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersistFile_Save_Proxy(IPersistFile*, LPCOLESTR pszFileName, BOOL);
проц IPersistFile_Save_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersistFile_SaveCompleted_Proxy(IPersistFile*, LPCOLESTR);
проц IPersistFile_SaveCompleted_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersistFile_GetCurFile_Proxy(IPersistFile*, LPCSTR*);
проц IPersistFile_GetCurFile_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersistStorage_IsDirty_Proxy(IPersistStorage*);
проц IPersistStorage_IsDirty_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersistStorage_InitNew_Proxy(IPersistStorage*, IStorage*);
проц IPersistStorage_InitNew_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersistStorage_Load_Proxy(IPersistStorage*, IStorage*);
проц IPersistStorage_Load_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersistStorage_Save_Proxy(IPersistStorage*, IStorage*, BOOL);
проц IPersistStorage_Save_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersistStorage_SaveCompleted_Proxy(IPersistStorage*, IStorage*);
проц IPersistStorage_SaveCompleted_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPersistStorage_HandsOffStorage_Proxy(IPersistStorage*);
проц IPersistStorage_HandsOffStorage_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT ILockBytes_RemoteReadAt_Proxy(ILockBytes*, ULARGE_INTEGER, BYTE*, ULONG, ULONG*);
проц ILockBytes_RemoteReadAt_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT ILockBytes_RemoteWriteAt_Proxy(ILockBytes*, ULARGE_INTEGER, BYTE*pv, ULONG, ULONG*);
проц ILockBytes_RemoteWriteAt_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT ILockBytes_Flush_Proxy(ILockBytes*);
проц ILockBytes_Flush_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT ILockBytes_SetSize_Proxy(ILockBytes*, ULARGE_INTEGER);
проц ILockBytes_SetSize_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT ILockBytes_LockRegion_Proxy(ILockBytes*, ULARGE_INTEGER, ULARGE_INTEGER, DWORD);
проц ILockBytes_LockRegion_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT ILockBytes_UnlockRegion_Proxy(ILockBytes*, ULARGE_INTEGER, ULARGE_INTEGER, DWORD);
проц ILockBytes_UnlockRegion_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT ILockBytes_Stat_Proxy(ILockBytes*, STATSTG*, DWORD);
проц ILockBytes_Stat_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumFORMATETC_RemoteNext_Proxy(IEnumFORMATETC*, ULONG, FORMATETC*, ULONG*);
проц IEnumFORMATETC_RemoteNext_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumFORMATETC_Skip_Proxy(IEnumFORMATETC*, ULONG);
проц IEnumFORMATETC_Skip_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumFORMATETC_Reset_Proxy(IEnumFORMATETC*);
проц IEnumFORMATETC_Reset_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumFORMATETC_Clone_Proxy(IEnumFORMATETC*, IEnumFORMATETC**);
проц IEnumFORMATETC_Clone_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumFORMATETC_Next_Proxy(IEnumFORMATETC*, ULONG, FORMATETC*, ULONG*);
HRESULT IEnumFORMATETC_Next_Stub(IEnumFORMATETC*, ULONG, FORMATETC*, ULONG*);
HRESULT IEnumSTATDATA_RemoteNext_Proxy(IEnumSTATDATA*, ULONG, STATDATA*, ULONG*);
проц IEnumSTATDATA_RemoteNext_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumSTATDATA_Skip_Proxy(IEnumSTATDATA*, ULONG);
проц IEnumSTATDATA_Skip_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumSTATDATA_Reset_Proxy(IEnumSTATDATA*);
проц IEnumSTATDATA_Reset_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumSTATDATA_Clone_Proxy(IEnumSTATDATA*, IEnumSTATDATA**);
проц IEnumSTATDATA_Clone_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IEnumSTATDATA_Next_Proxy(IEnumSTATDATA*, ULONG, STATDATA*, ULONG*);
HRESULT IEnumSTATDATA_Next_Stub(IEnumSTATDATA*, ULONG, STATDATA*, ULONG*);
HRESULT IRootStorage_SwitchToFile_Proxy(IRootStorage*, LPCSTR);
проц IRootStorage_SwitchToFile_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц IAdviseSink_RemoteOnDataChange_Proxy(IAdviseSink*, FORMATETC*, RemSTGMEDIUM*);
проц IAdviseSink_RemoteOnDataChange_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц IAdviseSink_RemoteOnViewChange_Proxy(IAdviseSink*, DWORD, LONG);
проц IAdviseSink_RemoteOnViewChange_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц IAdviseSink_RemoteOnRename_Proxy(IAdviseSink*, IMoniker*);
проц IAdviseSink_RemoteOnRename_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц IAdviseSink_RemoteOnSave_Proxy(IAdviseSink*);
проц IAdviseSink_RemoteOnSave_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IAdviseSink_RemoteOnClose_Proxy(IAdviseSink*);
проц IAdviseSink_RemoteOnClose_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц IAdviseSink_OnDataChange_Proxy(IAdviseSink*, FORMATETC*, STGMEDIUM*);
проц IAdviseSink_OnDataChange_Stub(IAdviseSink*, FORMATETC*, RemSTGMEDIUM*);
проц IAdviseSink_OnViewChange_Proxy(IAdviseSink*, DWORD, LONG);
проц IAdviseSink_OnViewChange_Stub(IAdviseSink*, DWORD, LONG);
проц IAdviseSink_OnRename_Proxy(IAdviseSink*, IMoniker*);
проц IAdviseSink_OnRename_Stub(IAdviseSink*, IMoniker*);
проц IAdviseSink_OnSave_Proxy(IAdviseSink*);
проц IAdviseSink_OnSave_Stub(IAdviseSink*);
проц IAdviseSink_OnClose_Proxy(IAdviseSink*);
HRESULT IAdviseSink_OnClose_Stub(IAdviseSink*);
проц IAdviseSink2_RemoteOnLinkSrcChange_Proxy(IAdviseSink2*, IMoniker*);
проц IAdviseSink2_RemoteOnLinkSrcChange_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц IAdviseSink2_OnLinkSrcChange_Proxy(IAdviseSink2*, IMoniker*);
проц IAdviseSink2_OnLinkSrcChange_Stub(IAdviseSink2*, IMoniker*);
HRESULT IDataObject_RemoteGetData_Proxy(IDataObject*, FORMATETC*, RemSTGMEDIUM**);
проц IDataObject_RemoteGetData_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IDataObject_RemoteGetDataHere_Proxy(IDataObject*, FORMATETC*, RemSTGMEDIUM**);
проц IDataObject_RemoteGetDataHere_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IDataObject_QueryGetData_Proxy(IDataObject*, FORMATETC*);
проц IDataObject_QueryGetData_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IDataObject_GetCanonicalFormatEtc_Proxy(IDataObject*, FORMATETC*, FORMATETC*);
проц IDataObject_GetCanonicalFormatEtc_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IDataObject_RemoteSetData_Proxy(IDataObject*, FORMATETC*, RemSTGMEDIUM*, BOOL);
проц IDataObject_RemoteSetData_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IDataObject_EnumFormatEtc_Proxy(IDataObject*, DWORD, IEnumFORMATETC**);
проц IDataObject_EnumFormatEtc_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IDataObject_DAdvise_Proxy(IDataObject*, FORMATETC*, DWORD, IAdviseSink*, DWORD*);
проц IDataObject_DAdvise_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IDataObject_DUnadvise_Proxy(IDataObject*, DWORD);
проц IDataObject_DUnadvise_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IDataObject_EnumDAdvise_Proxy(IDataObject*, IEnumSTATDATA**);
проц IDataObject_EnumDAdvise_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IDataObject_GetData_Proxy(IDataObject*, FORMATETC*, STGMEDIUM*);
HRESULT IDataObject_GetData_Stub(IDataObject*, FORMATETC*, RemSTGMEDIUM**);
HRESULT IDataObject_GetDataHere_Proxy(IDataObject*, FORMATETC*, STGMEDIUM*);
HRESULT IDataObject_GetDataHere_Stub(IDataObject*, FORMATETC*, RemSTGMEDIUM**);
HRESULT IDataObject_SetData_Proxy(IDataObject*, FORMATETC*, STGMEDIUM*, BOOL);
HRESULT IDataObject_SetData_Stub(IDataObject*, FORMATETC*, RemSTGMEDIUM*, BOOL);
HRESULT IDataAdviseHolder_Advise_Proxy(IDataAdviseHolder*, IDataObject*, FORMATETC*, DWORD, IAdviseSink*, DWORD*);
проц IDataAdviseHolder_Advise_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IDataAdviseHolder_Unadvise_Proxy(IDataAdviseHolder*, DWORD);
проц IDataAdviseHolder_Unadvise_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IDataAdviseHolder_EnumAdvise_Proxy(IDataAdviseHolder*, IEnumSTATDATA**);
проц IDataAdviseHolder_EnumAdvise_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IDataAdviseHolder_SendOnDataChange_Proxy(IDataAdviseHolder*, IDataObject*, DWORD, DWORD);
проц IDataAdviseHolder_SendOnDataChange_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
DWORD IMessageFilter_HandleInComingCall_Proxy(IMessageFilter*, DWORD, HTASK, DWORD, LPINTERFACEINFO);
проц IMessageFilter_HandleInComingCall_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
DWORD IMessageFilter_RetryRejectedCall_Proxy(IMessageFilter*, HTASK, DWORD, DWORD);
проц IMessageFilter_RetryRejectedCall_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
DWORD IMessageFilter_MessagePending_Proxy(IMessageFilter*, HTASK, DWORD, DWORD);
проц IMessageFilter_MessagePending_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRpcChannelBuffer_GetBuffer_Proxy(IRpcChannelBuffer*, RPCOLEMESSAGE*, REFIID);
проц IRpcChannelBuffer_GetBuffer_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRpcChannelBuffer_SendReceive_Proxy(IRpcChannelBuffer*, RPCOLEMESSAGE*, ULONG*);
проц IRpcChannelBuffer_SendReceive_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRpcChannelBuffer_FreeBuffer_Proxy(IRpcChannelBuffer*, RPCOLEMESSAGE*);
проц IRpcChannelBuffer_FreeBuffer_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRpcChannelBuffer_GetDestCtx_Proxy(IRpcChannelBuffer*, DWORD*, проц**);
проц IRpcChannelBuffer_GetDestCtx_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRpcChannelBuffer_IsConnected_Proxy(IRpcChannelBuffer*);
проц IRpcChannelBuffer_IsConnected_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRpcProxyBuffer_Connect_Proxy(IRpcProxyBuffer*, IRpcChannelBuffer*pRpcChannelBuffer);
проц IRpcProxyBuffer_Connect_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц IRpcProxyBuffer_Disconnect_Proxy(IRpcProxyBuffer*);
проц IRpcProxyBuffer_Disconnect_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRpcStubBuffer_Connect_Proxy(IRpcStubBuffer*, IUnknown*);
проц IRpcStubBuffer_Connect_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц IRpcStubBuffer_Disconnect_Proxy(IRpcStubBuffer*);
проц IRpcStubBuffer_Disconnect_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRpcStubBuffer_Invoke_Proxy(IRpcStubBuffer*, RPCOLEMESSAGE*, IRpcChannelBuffer*);
проц IRpcStubBuffer_Invoke_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
IRpcStubBuffer*IRpcStubBuffer_IsIIDSupported_Proxy(IRpcStubBuffer*, REFIID);
проц IRpcStubBuffer_IsIIDSupported_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
ULONG IRpcStubBuffer_CountRefs_Proxy(IRpcStubBuffer*);
проц IRpcStubBuffer_CountRefs_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IRpcStubBuffer_DebugServerQueryInterface_Proxy(IRpcStubBuffer*, проц**);
проц IRpcStubBuffer_DebugServerQueryInterface_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц IRpcStubBuffer_DebugServerRelease_Proxy(IRpcStubBuffer*, проц*);
проц IRpcStubBuffer_DebugServerRelease_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPSFactoryBuffer_CreateProxy_Proxy(IPSFactoryBuffer*, IUnknown*, REFIID, IRpcProxyBuffer**, проц**);
проц IPSFactoryBuffer_CreateProxy_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
HRESULT IPSFactoryBuffer_CreateStub_Proxy(IPSFactoryBuffer*, REFIID, IUnknown*, IRpcStubBuffer**);
проц IPSFactoryBuffer_CreateStub_Stub(IRpcStubBuffer*, IRpcChannelBuffer*, PRPC_MESSAGE, PDWORD);
проц SNB_to_xmit(SNB*, RemSNB**);
проц SNB_from_xmit(RemSNB*, SNB*);
проц SNB_free_inst(SNB*);
проц SNB_free_xmit(RemSNB*);
HRESULT IEnumUnknown_Next_Proxy(IEnumUnknown*, ULONG, IUnknown**, ULONG*);
HRESULT IEnumUnknown_Next_Stub(IEnumUnknown*, ULONG, IUnknown**, ULONG*);
HRESULT IEnumMoniker_Next_Proxy(IEnumMoniker*, ULONG, IMoniker**, ULONG*);
HRESULT IEnumMoniker_Next_Stub(IEnumMoniker*, ULONG, IMoniker**, ULONG*);
HRESULT IMoniker_BindToObject_Proxy(IMoniker*, IBindCtx*, IMoniker*, REFIID, проц**);
HRESULT IMoniker_BindToObject_Stub(IMoniker*, IBindCtx*, IMoniker*, REFIID, IUnknown**);
HRESULT IMoniker_BindToStorage_Proxy(IMoniker*, IBindCtx*, IMoniker*, REFIID, проц**);
HRESULT IMoniker_BindToStorage_Stub(IMoniker*, IBindCtx*, IMoniker*, REFIID, IUnknown**);
HRESULT IEnumString_Next_Proxy(IEnumString*, ULONG, LPCSTR*, ULONG*);
HRESULT IEnumString_Next_Stub(IEnumString*, ULONG, LPCSTR*, ULONG*);
HRESULT IStream_Read_Proxy(IStream*, проц*, ULONG, ULONG*);
HRESULT IStream_Read_Stub(IStream*, BYTE*, ULONG, ULONG*);
HRESULT IStream_Write_Proxy(IStream*, проц*, ULONG, ULONG*);
HRESULT IStream_Write_Stub(IStream*, BYTE*, ULONG, ULONG*);
HRESULT IStream_Seek_Proxy(IStream*, LARGE_INTEGER, DWORD, ULARGE_INTEGER*);
HRESULT IStream_Seek_Stub(IStream*, LARGE_INTEGER, DWORD, ULARGE_INTEGER*);
HRESULT IStream_CopyTo_Proxy(IStream*, IStream*, ULARGE_INTEGER, ULARGE_INTEGER*, ULARGE_INTEGER*);
HRESULT IStream_CopyTo_Stub(IStream*, IStream*, ULARGE_INTEGER, ULARGE_INTEGER*, ULARGE_INTEGER*);
HRESULT IEnumSTATSTG_Next_Proxy(IEnumSTATSTG*, ULONG, STATSTG*, ULONG*);
HRESULT IEnumSTATSTG_Next_Stub(IEnumSTATSTG*, ULONG, STATSTG*, ULONG*);
HRESULT IStorage_OpenStream_Proxy(IStorage*, OLECHAR*, проц*, DWORD, DWORD, IStream**);
HRESULT IStorage_OpenStream_Stub(IStorage*, OLECHAR*, бцел, BYTE*, DWORD, DWORD, IStream** );
HRESULT IStorage_EnumElements_Proxy(IStorage*, DWORD, проц*, DWORD, IEnumSTATSTG**);
HRESULT IStorage_EnumElements_Stub(IStorage*, DWORD, бцел, BYTE*, DWORD, IEnumSTATSTG**);
HRESULT ILockBytes_ReadAt_Proxy(ILockBytes*, ULARGE_INTEGER, проц*, ULONG, ULONG*);
HRESULT ILockBytes_ReadAt_Stub(ILockBytes*, ULARGE_INTEGER, BYTE*, ULONG, ULONG*);
HRESULT ILockBytes_WriteAt_Proxy(ILockBytes*, ULARGE_INTEGER, проц*, ULONG, ULONG*);
HRESULT ILockBytes_WriteAt_Stub(ILockBytes*, ULARGE_INTEGER, BYTE*, ULONG, ULONG*);
}
+/
