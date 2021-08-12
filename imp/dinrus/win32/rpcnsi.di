/***********************************************************************\
*                                rpcnsi.d                               *
*                                                                       *
*                       Windows API header module                       *
*                     RPC Name Service (RpcNs APIs)                     *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module win32.rpcnsi;
pragma(lib, "rpcns4.lib");

private import win32.basetyps, win32.rpcdcep, win32.rpcnsi, win32.rpcdce,
  win32.w32api;
private import win32.windef;  // for HANDLE

alias HANDLE RPC_NS_HANDLE;

const RPC_C_NS_SYNTAX_DEFAULT=0;
const RPC_C_NS_SYNTAX_DCE=3;
const RPC_C_PROFILE_DEFAULT_ELT=0;
const RPC_C_PROFILE_ALL_ELT=1;
const RPC_C_PROFILE_MATCH_BY_IF=2;
const RPC_C_PROFILE_MATCH_BY_MBR=3;
const RPC_C_PROFILE_MATCH_BY_BOTH=4;
const RPC_C_NS_DEFAULT_EXP_AGE=-1;

extern (Windows) {
	RPC_STATUS RpcNsBindingExportA(бцел, ббайт*, RPC_IF_HANDLE,
	  RPC_BINDING_VECTOR*, UUID_VECTOR*);
	RPC_STATUS RpcNsBindingUnexportA(бцел, ббайт*, RPC_IF_HANDLE,
	  UUID_VECTOR*);
	RPC_STATUS RpcNsBindingLookupBeginA(бцел, ббайт*, RPC_IF_HANDLE, UUID*,
	  бцел, RPC_NS_HANDLE*);
	RPC_STATUS RpcNsBindingLookupNext(RPC_NS_HANDLE, RPC_BINDING_VECTOR**);
	RPC_STATUS RpcNsBindingLookupDone(RPC_NS_HANDLE*);
	RPC_STATUS RpcNsGroupDeleteA(бцел, ббайт*);
	RPC_STATUS RpcNsGroupMbrAddA(бцел, ббайт*, бцел, ббайт*);
	RPC_STATUS RpcNsGroupMbrRemoveA(бцел, ббайт*, бцел, ббайт*);
	RPC_STATUS RpcNsGroupMbrInqBeginA(бцел, ббайт*, бцел, RPC_NS_HANDLE*);
	RPC_STATUS RpcNsGroupMbrInqNextA(RPC_NS_HANDLE, ббайт**);
	RPC_STATUS RpcNsGroupMbrInqDone(RPC_NS_HANDLE*);
	RPC_STATUS RpcNsProfileDeleteA(бцел, ббайт*);
	RPC_STATUS RpcNsProfileEltAddA(бцел, ббайт*, RPC_IF_ID*, бцел, ббайт*,
	  бцел, ббайт*);
	RPC_STATUS RpcNsProfileEltRemoveA(бцел, ббайт*, RPC_IF_ID*, бцел, ббайт*);
	RPC_STATUS RpcNsProfileEltInqBeginA(бцел, ббайт*, бцел, RPC_IF_ID*, бцел,
	  бцел, ббайт*, RPC_NS_HANDLE*);
	RPC_STATUS RpcNsProfileEltInqNextA(RPC_NS_HANDLE, RPC_IF_ID*, ббайт**,
	  бцел*, ббайт**);
	RPC_STATUS RpcNsProfileEltInqDone(RPC_NS_HANDLE*);
	RPC_STATUS RpcNsEntryObjectInqNext(in RPC_NS_HANDLE, out UUID*);
	RPC_STATUS RpcNsEntryObjectInqDone(inout RPC_NS_HANDLE*);
	RPC_STATUS RpcNsEntryExpandNameA(бцел, ббайт*, ббайт**);
	RPC_STATUS RpcNsMgmtBindingUnexportA(бцел, ббайт*, RPC_IF_ID*, бцел,
	  UUID_VECTOR*);
	RPC_STATUS RpcNsMgmtEntryCreateA(бцел, ббайт*);
	RPC_STATUS RpcNsMgmtEntryDeleteA(бцел, ббайт*);
	RPC_STATUS RpcNsMgmtEntryInqIfIdsA(бцел, ббайт*, RPC_IF_ID_VECTOR**);
	RPC_STATUS RpcNsMgmtHandleSetExpAge(RPC_NS_HANDLE, бцел);
	RPC_STATUS RpcNsMgmtInqExpAge(бцел*);
	RPC_STATUS RpcNsMgmtSetExpAge(бцел);
	RPC_STATUS RpcNsBindingImportNext(RPC_NS_HANDLE, RPC_BINDING_HANDLE*);
	RPC_STATUS RpcNsBindingImportDone(RPC_NS_HANDLE*);
	RPC_STATUS RpcNsBindingSelect(RPC_BINDING_VECTOR*, RPC_BINDING_HANDLE*);
}

// For the cases where Win95, 98, ME have no _W versions, and we must alias to
// _A even for version(Unicode).

version (Unicode) {
	static if (_WIN32_WINNT_ONLY) {
		const бул _WIN32_USE_UNICODE = true;
	} else {
		const бул _WIN32_USE_UNICODE = false;
	}
} else {
	const бул _WIN32_USE_UNICODE = false;
}

static if (!_WIN32_USE_UNICODE) {
	RPC_STATUS RpcNsEntryObjectInqBeginA(бцел, ббайт*, RPC_NS_HANDLE*);
	RPC_STATUS RpcNsBindingImportBeginA(бцел, ббайт*, RPC_IF_HANDLE, UUID*,
	  RPC_NS_HANDLE*);
}

static if (_WIN32_WINNT_ONLY) {
	RPC_STATUS RpcNsBindingExportW(бцел, бкрат*, RPC_IF_HANDLE,
	  RPC_BINDING_VECTOR*, UUID_VECTOR*);
	RPC_STATUS RpcNsBindingUnexportW(бцел, бкрат*, RPC_IF_HANDLE,
	  UUID_VECTOR*);
	RPC_STATUS RpcNsBindingLookupBeginW(бцел, бкрат*, RPC_IF_HANDLE, UUID*,
	  бцел, RPC_NS_HANDLE*);
	RPC_STATUS RpcNsGroupDeleteW(бцел, бкрат*);
	RPC_STATUS RpcNsGroupMbrAddW(бцел, бкрат*, бцел, бкрат*);
	RPC_STATUS RpcNsGroupMbrRemoveW(бцел, бкрат*, бцел, бкрат*);
	RPC_STATUS RpcNsGroupMbrInqBeginW(бцел, бкрат*, бцел, RPC_NS_HANDLE*);
	RPC_STATUS RpcNsGroupMbrInqNextW(RPC_NS_HANDLE, бкрат**);
	RPC_STATUS RpcNsProfileDeleteW(бцел, бкрат*);
	RPC_STATUS RpcNsProfileEltAddW(бцел, бкрат*, RPC_IF_ID*, бцел, бкрат*,
	  бцел, бкрат*);
	RPC_STATUS RpcNsProfileEltRemoveW(бцел, бкрат*, RPC_IF_ID*, бцел,
	  бкрат*);
	RPC_STATUS RpcNsProfileEltInqBeginW(бцел, бкрат*, бцел, RPC_IF_ID*,
	  бцел, бцел, бкрат*, RPC_NS_HANDLE*);
	RPC_STATUS RpcNsProfileEltInqNextW(RPC_NS_HANDLE, RPC_IF_ID*, бкрат**,
	  бцел*, бкрат**);
	RPC_STATUS RpcNsEntryObjectInqBeginW(бцел, бкрат*, RPC_NS_HANDLE*);
	RPC_STATUS RpcNsEntryExpandNameW(бцел, бкрат*, бкрат**);
	RPC_STATUS RpcNsMgmtBindingUnexportW(бцел, бкрат*, RPC_IF_ID*, бцел,
	  UUID_VECTOR*);
	RPC_STATUS RpcNsMgmtEntryCreateW(бцел, бкрат*);
	RPC_STATUS RpcNsMgmtEntryDeleteW(бцел, бкрат*);
	RPC_STATUS RpcNsMgmtEntryInqIfIdsW(бцел, бкрат , RPC_IF_ID_VECTOR**);
	RPC_STATUS RpcNsBindingImportBeginW(бцел, бкрат*, RPC_IF_HANDLE, UUID*,
	  RPC_NS_HANDLE*);
} // _WIN32_WINNT_ONLY

static if (_WIN32_USE_UNICODE) {
	alias RpcNsBindingLookupBeginW RpcNsBindingLookupBegin;
	alias RpcNsBindingImportBeginW RpcNsBindingImportBegin;
	alias RpcNsBindingExportW RpcNsBindingExport;
	alias RpcNsBindingUnexportW RpcNsBindingUnexport;
	alias RpcNsGroupDeleteW RpcNsGroupDelete;
	alias RpcNsGroupMbrAddW RpcNsGroupMbrAdd;
	alias RpcNsGroupMbrRemoveW RpcNsGroupMbrRemove;
	alias RpcNsGroupMbrInqBeginW RpcNsGroupMbrInqBegin;
	alias RpcNsGroupMbrInqNextW RpcNsGroupMbrInqNext;
	alias RpcNsEntryExpandNameW RpcNsEntryExpandName;
	alias RpcNsEntryObjectInqBeginW RpcNsEntryObjectInqBegin;
	alias RpcNsMgmtBindingUnexportW RpcNsMgmtBindingUnexport;
	alias RpcNsMgmtEntryCreateW RpcNsMgmtEntryCreate;
	alias RpcNsMgmtEntryDeleteW RpcNsMgmtEntryDelete;
	alias RpcNsMgmtEntryInqIfIdsW RpcNsMgmtEntryInqIfIds;
	alias RpcNsProfileDeleteW RpcNsProfileDelete;
	alias RpcNsProfileEltAddW RpcNsProfileEltAdd;
	alias RpcNsProfileEltRemoveW RpcNsProfileEltRemove;
	alias RpcNsProfileEltInqBeginW RpcNsProfileEltInqBegin;
	alias RpcNsProfileEltInqNextW RpcNsProfileEltInqNext;
} else {
	alias RpcNsBindingLookupBeginA RpcNsBindingLookupBegin;
	alias RpcNsBindingImportBeginA RpcNsBindingImportBegin;
	alias RpcNsBindingExportA RpcNsBindingExport;
	alias RpcNsBindingUnexportA RpcNsBindingUnexport;
	alias RpcNsGroupDeleteA RpcNsGroupDelete;
	alias RpcNsGroupMbrAddA RpcNsGroupMbrAdd;
	alias RpcNsGroupMbrRemoveA RpcNsGroupMbrRemove;
	alias RpcNsGroupMbrInqBeginA RpcNsGroupMbrInqBegin;
	alias RpcNsGroupMbrInqNextA RpcNsGroupMbrInqNext;
	alias RpcNsEntryExpandNameA RpcNsEntryExpandName;
	alias RpcNsEntryObjectInqBeginA RpcNsEntryObjectInqBegin;
	alias RpcNsMgmtBindingUnexportA RpcNsMgmtBindingUnexport;
	alias RpcNsMgmtEntryCreateA RpcNsMgmtEntryCreate;
	alias RpcNsMgmtEntryDeleteA RpcNsMgmtEntryDelete;
	alias RpcNsMgmtEntryInqIfIdsA RpcNsMgmtEntryInqIfIds;
	alias RpcNsProfileDeleteA RpcNsProfileDelete;
	alias RpcNsProfileEltAddA RpcNsProfileEltAdd;
	alias RpcNsProfileEltRemoveA RpcNsProfileEltRemove;
	alias RpcNsProfileEltInqBeginA RpcNsProfileEltInqBegin;
	alias RpcNsProfileEltInqNextA RpcNsProfileEltInqNext;
}
