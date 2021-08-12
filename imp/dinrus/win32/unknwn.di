/***********************************************************************\
*                                unknwn.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module win32.unknwn;

import win32.objfwd, win32.windef, win32.wtypes;
private import win32.basetyps;

extern (Windows) {
	проц* MIDL_user_allocate(size_t);
	проц MIDL_user_free(проц*);
}


extern (Windows) {

	interface IUnknown {
		HRESULT QueryInterface(IID* riid, проц** pvObject);
		ULONG AddRef();
		ULONG Release();
	}

	alias IUnknown LPUNKNOWN;

	interface IClassFactory : IUnknown {
		HRESULT CreateInstance(IUnknown UnkOuter, IID* riid, проц** pvObject);
		HRESULT LockServer(BOOL fLock);
	}
	alias IClassFactory LPCLASSFACTORY;

	/+
	// These do not seem to be necessary (or desirable) for D.
	HRESULT IUnknown_QueryInterface_Proxy(IUnknown*,REFIID,проц**);
	ULONG IUnknown_AddRef_Proxy(IUnknown*);
	ULONG IUnknown_Release_Proxy(IUnknown*);
	HRESULT IClassFactory_RemoteCreateInstance_Proxy(IClassFactory*,REFIID,IUnknown**);
	HRESULT IClassFactory_RemoteLockServer_Proxy(IClassFactory*,BOOL);
	HRESULT IClassFactory_CreateInstance_Proxy(IClassFactory*,IUnknown*,REFIID,проц**);
	HRESULT IClassFactory_CreateInstance_Stub(IClassFactory*,REFIID,IUnknown**);
	HRESULT IClassFactory_LockServer_Proxy(IClassFactory*,BOOL);
	HRESULT IClassFactory_LockServer_Stub(IClassFactory*,BOOL);

	проц IUnknown_QueryInterface_Stub(LPRPCSTUBBUFFER,LPRPCCHANNELBUFFER,PRPC_MESSAGE,PDWORD);
	проц IUnknown_AddRef_Stub(LPRPCSTUBBUFFER,LPRPCCHANNELBUFFER,PRPC_MESSAGE,PDWORD);
	проц IUnknown_Release_Stub(LPRPCSTUBBUFFER,LPRPCCHANNELBUFFER,PRPC_MESSAGE,PDWORD);
	проц IClassFactory_RemoteCreateInstance_Stub(LPRPCSTUBBUFFER,LPRPCCHANNELBUFFER,PRPC_MESSAGE,PDWORD);
	проц IClassFactory_RemoteLockServer_Stub(LPRPCSTUBBUFFER,LPRPCCHANNELBUFFER,PRPC_MESSAGE,PDWORD);
	+/
}
