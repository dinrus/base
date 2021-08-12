/***********************************************************************\
*                                rpcdce.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module win32.rpcdce;
pragma(lib, "Rpcrt4.lib");

// TODO: I think MinGW got this wrong. RPC_UNICODE_SUPPORTED should be
// replaced aliases for version(Unicode)

public import win32.rpcdcep;
private import win32.basetyps, win32.w32api, win32.windef;

// FIXME: clean up Windows version support

alias UUID uuid_t;
alias UUID_VECTOR uuid_vector_t;
alias проц RPC_MGR_EPV;

// for RpcMgmtSetComTimeout()
enum : бцел {
	RPC_C_BINDING_MIN_TIMEOUT      = 0,
	RPC_C_BINDING_DEFAULT_TIMEOUT  = 5,
	RPC_C_BINDING_MAX_TIMEOUT      = 9,
	RPC_C_BINDING_INFINITE_TIMEOUT = 10
}

const RPC_C_CANCEL_INFINITE_TIMEOUT= -1;
const RPC_C_LISTEN_MAX_CALLS_DEFAULT=1234;
const RPC_C_PROTSEQ_MAX_REQS_DEFAULT=10;
const RPC_C_BIND_TO_ALL_NICS=1;
const RPC_C_USE_INTERNET_PORT=1;
const RPC_C_USE_INTRANET_PORT=2;

// for RPC_STATS_VECTOR, used by RpcMgmyInqStats
enum : бцел {
	RPC_C_STATS_CALLS_IN  = 0,
	RPC_C_STATS_CALLS_OUT,
	RPC_C_STATS_PKTS_IN,
	RPC_C_STATS_PKTS_OUT
}

const RPC_IF_AUTOLISTEN=0x0001;
const RPC_IF_OLE=2;
const RPC_C_MGMT_INQ_IF_IDS=0;
const RPC_C_MGMT_INQ_PRINC_NAME=1;
const RPC_C_MGMT_INQ_STATS=2;
const RPC_C_MGMT_IS_SERVER_LISTEN=3;
const RPC_C_MGMT_STOP_SERVER_LISTEN=4;

// Inquiry Type for RpcMgmtEpEltInqBegin()
enum : бцел {
	RPC_C_EP_ALL_ELTS = 0,
	RPC_C_EP_MATCH_BY_IF,
	RPC_C_EP_MATCH_BY_OBJ,
	RPC_C_EP_MATCH_BY_BOTH
}

// for RpcMgmtEpEltInqNext()
enum : бцел {
	RPC_C_VERS_ALL = 1,
	RPC_C_VERS_COMPATIBLE,
	RPC_C_VERS_EXACT,
	RPC_C_VERS_MAJOR_ONLY,
	RPC_C_VERS_UPTO
}

const DCE_C_ERROR_STRING_LEN=256;
const RPC_C_PARM_MAX_PACKET_LENGTH=1;
const RPC_C_PARM_BUFFER_LENGTH=2;
const RPC_C_AUTHN_LEVEL_DEFAULT=0;
const RPC_C_AUTHN_LEVEL_NONE=1;
const RPC_C_AUTHN_LEVEL_CONNECT=2;
const RPC_C_AUTHN_LEVEL_CALL=3;
const RPC_C_AUTHN_LEVEL_PKT=4;
const RPC_C_AUTHN_LEVEL_PKT_INTEGRITY=5;
const RPC_C_AUTHN_LEVEL_PKT_PRIVACY=6;
const RPC_C_IMP_LEVEL_ANONYMOUS=1;
const RPC_C_IMP_LEVEL_IDENTIFY=2;
const RPC_C_IMP_LEVEL_IMPERSONATE=3;
const RPC_C_IMP_LEVEL_DELEGATE=4;
const RPC_C_QOS_IDENTITY_STATIC=0;
const RPC_C_QOS_IDENTITY_DYNAMIC=1;
const RPC_C_QOS_CAPABILITIES_DEFAULT=0;
const RPC_C_QOS_CAPABILITIES_MUTUAL_AUTH=1;

// These enums were buggy in MinGW !
const RPC_C_PROTECT_LEVEL_DEFAULT = RPC_C_AUTHN_LEVEL_DEFAULT;
const RPC_C_PROTECT_LEVEL_NONE = RPC_C_AUTHN_LEVEL_NONE;
const RPC_C_PROTECT_LEVEL_CONNECT = RPC_C_AUTHN_LEVEL_CONNECT;
const RPC_C_PROTECT_LEVEL_CALL = RPC_C_AUTHN_LEVEL_CALL;
const RPC_C_PROTECT_LEVEL_PKT = RPC_C_AUTHN_LEVEL_PKT;
const RPC_C_PROTECT_LEVEL_PKT_INTEGRITY = RPC_C_AUTHN_LEVEL_PKT_INTEGRITY;
const RPC_C_PROTECT_LEVEL_PKT_PRIVACY = RPC_C_AUTHN_LEVEL_PKT_PRIVACY;

const RPC_C_AUTHN_NONE=0;
const RPC_C_AUTHN_DCE_PRIVATE=1;
const RPC_C_AUTHN_DCE_PUBLIC=2;
const RPC_C_AUTHN_DEC_PUBLIC=4;
const RPC_C_AUTHN_WINNT=10;
const RPC_C_AUTHN_DEFAULT=0xFFFFFFFF;
//const RPC_C_SECURITY_QOS_VERSION=L; // FIXME(MinGW): This is nonsense!
const SEC_WINNT_AUTH_IDENTITY_ANSI=0x1;
const SEC_WINNT_AUTH_IDENTITY_UNICODE=0x2;
const RPC_C_AUTHZ_NONE=0;
const RPC_C_AUTHZ_NAME=1;
const RPC_C_AUTHZ_DCE=2;
const RPC_C_AUTHZ_DEFAULT=0xFFFFFFFF;

alias I_RPC_HANDLE RPC_BINDING_HANDLE;
alias RPC_BINDING_HANDLE handle_t;

struct RPC_BINDING_VECTOR {
	бцел Count;
	RPC_BINDING_HANDLE BindingH[1];
}

alias RPC_BINDING_HANDLE rpc_binding_handle_t;
alias RPC_BINDING_VECTOR rpc_binding_vector_t;


struct UUID_VECTOR {
	бцел Count;
	UUID* Uuid[1];
}

alias проц* RPC_IF_HANDLE;

struct RPC_IF_ID {
	UUID Uuid;
	бкрат VersMajor;
	бкрат VersMinor;
}

struct RPC_POLICY {
	бцел Length;
	бцел EndpointFlags;
	бцел NICFlags;
}
alias RPC_POLICY* PRPC_POLICY;

extern (Windows) {
	alias проц function(UUID*, UUID*, RPC_STATUS*) RPC_OBJECT_INQ_FN;
	alias RPC_STATUS function(RPC_IF_HANDLE, проц*) RPC_IF_CALLBACK_FN;
}

struct RPC_STATS_VECTOR {
	бцел    Count;
	бцел[1] Stats;
}

struct RPC_IF_ID_VECTOR {
	бцел          Count;
	RPC_IF_ID*[1] IfId;
}
alias HANDLE RPC_AUTH_IDENTITY_HANDLE, RPC_AUTHZ_HANDLE;

struct RPC_SECURITY_QOS {
	бцел Version;
	бцел Capabilities;
	бцел IdentityTracking;
	бцел ImpersonationType;
}
alias RPC_SECURITY_QOS* PRPC_SECURITY_QOS;

struct SEC_WINNT_AUTH_IDENTITY_W {
	бкрат* User;
	бцел UserLength;
	бкрат* Domain;
	бцел DomainLength;
	бкрат* Password;
	бцел PasswordLength;
	бцел Flags;
}
alias SEC_WINNT_AUTH_IDENTITY_W* PSEC_WINNT_AUTH_IDENTITY_W;

struct SEC_WINNT_AUTH_IDENTITY_A {
	ббайт* User;
	бцел UserLength;
	ббайт* Domain;
	бцел DomainLength;
	ббайт* Password;
	бцел PasswordLength;
	бцел Flags;
}
alias SEC_WINNT_AUTH_IDENTITY_A* PSEC_WINNT_AUTH_IDENTITY_A;

struct RPC_CLIENT_INFORMATION1 {
	ббайт* UserName;
	ббайт* ComputerName;
	бкрат Privilege;
	бцел AuthFlags;
}
alias RPC_CLIENT_INFORMATION1* PRPC_CLIENT_INFORMATION1;
alias I_RPC_HANDLE* RPC_EP_INQ_HANDLE;
extern (Windows) {
	alias цел function(RPC_BINDING_HANDLE, бцел, RPC_STATUS*) RPC_MGMT_AUTHORIZATION_FN;
}

static if(_WIN32_WINNT_ONLY) {

	struct RPC_PROTSEQ_VECTORA {
		бцел Count;
		ббайт*[1] Protseq;
	}

	struct RPC_PROTSEQ_VECTORW {
		бцел Count;
		бкрат*[1] Protseq;
	}

	extern (Windows) {
		RPC_STATUS RpcBindingFromStringBindingA(сим*, RPC_BINDING_HANDLE*);
		RPC_STATUS RpcBindingFromStringBindingW(шим*, RPC_BINDING_HANDLE*);
		RPC_STATUS RpcBindingToStringBindingA(RPC_BINDING_HANDLE, сим**);
		RPC_STATUS RpcBindingToStringBindingW(RPC_BINDING_HANDLE, шим**);
		RPC_STATUS RpcStringBindingComposeA(сим*, сим*, сим*, сим*, сим*, сим**);
		RPC_STATUS RpcStringBindingComposeW(шим*, шим*, шим*, шим*, шим*, шим**);
		RPC_STATUS RpcStringBindingParseA(сим*, сим**, сим**, сим**, сим**, сим**);
		RPC_STATUS RpcStringBindingParseW(шим*, шим**, шим**, шим**, шим**, шим**);
		RPC_STATUS RpcStringFreeA(сим**);
		RPC_STATUS RpcStringFreeW(шим**);
		RPC_STATUS RpcNetworkIsProtseqValidA(сим*);
		RPC_STATUS RpcNetworkIsProtseqValidW(шим*);
		RPC_STATUS RpcNetworkInqProtseqsA(RPC_PROTSEQ_VECTORA**);
		RPC_STATUS RpcNetworkInqProtseqsW(RPC_PROTSEQ_VECTORW**);
		RPC_STATUS RpcProtseqVectorFreeA(RPC_PROTSEQ_VECTORA**);
		RPC_STATUS RpcProtseqVectorFreeW(RPC_PROTSEQ_VECTORW**);
		RPC_STATUS RpcServerUseProtseqA(сим*, бцел, проц*);
		RPC_STATUS RpcServerUseProtseqW(шим*, бцел, проц*);
		RPC_STATUS RpcServerUseProtseqExA(сим*, бцел MaxCalls, проц*, PRPC_POLICY);
		RPC_STATUS RpcServerUseProtseqExW(шим*, бцел, проц*, PRPC_POLICY);
		RPC_STATUS RpcServerUseProtseqEpA(сим*, бцел, сим*, проц*);
		RPC_STATUS RpcServerUseProtseqEpExA(сим*, бцел, сим*, проц*, PRPC_POLICY);
		RPC_STATUS RpcServerUseProtseqEpW(шим*, бцел, шим*, проц*);
		RPC_STATUS RpcServerUseProtseqEpExW(шим*, бцел, шим*, проц*, PRPC_POLICY);
		RPC_STATUS RpcServerUseProtseqIfA(сим*, бцел, RPC_IF_HANDLE, проц*);
		RPC_STATUS RpcServerUseProtseqIfExA(сим*, бцел, RPC_IF_HANDLE, проц*, PRPC_POLICY);
		RPC_STATUS RpcServerUseProtseqIfW(шим*, бцел, RPC_IF_HANDLE, проц*);
		RPC_STATUS RpcServerUseProtseqIfExW(шим*, бцел, RPC_IF_HANDLE, проц*, PRPC_POLICY);
		RPC_STATUS RpcMgmtInqServerPrincNameA(RPC_BINDING_HANDLE, бцел, сим**);
		RPC_STATUS RpcMgmtInqServerPrincNameW(RPC_BINDING_HANDLE, бцел, шим**);
		RPC_STATUS RpcServerInqDefaultPrincNameA(бцел, сим**);
		RPC_STATUS RpcServerInqDefaultPrincNameW(бцел, шим**);
		RPC_STATUS RpcNsBindingInqEntryNameA(RPC_BINDING_HANDLE, бцел, сим**);
		RPC_STATUS RpcNsBindingInqEntryNameW(RPC_BINDING_HANDLE, бцел, шим**);
		RPC_STATUS RpcBindingInqAuthClientA(RPC_BINDING_HANDLE, RPC_AUTHZ_HANDLE*, сим**, бцел*, бцел*, бцел*);
		RPC_STATUS RpcBindingInqAuthClientW(RPC_BINDING_HANDLE, RPC_AUTHZ_HANDLE*, шим**, бцел*, бцел*, бцел*);
		RPC_STATUS RpcBindingInqAuthInfoA(RPC_BINDING_HANDLE, сим**, бцел*, бцел*, RPC_AUTH_IDENTITY_HANDLE*, бцел*);
		RPC_STATUS RpcBindingInqAuthInfoW(RPC_BINDING_HANDLE, шим**, бцел*, бцел*, RPC_AUTH_IDENTITY_HANDLE*, бцел*);
		RPC_STATUS RpcBindingSetAuthInfoA(RPC_BINDING_HANDLE, сим*, бцел, бцел, RPC_AUTH_IDENTITY_HANDLE, бцел);
		RPC_STATUS RpcBindingSetAuthInfoExA(RPC_BINDING_HANDLE, сим*, бцел, бцел, RPC_AUTH_IDENTITY_HANDLE, бцел, RPC_SECURITY_QOS*);
		RPC_STATUS RpcBindingSetAuthInfoW(RPC_BINDING_HANDLE, шим*, бцел, бцел, RPC_AUTH_IDENTITY_HANDLE, бцел);
		RPC_STATUS RpcBindingSetAuthInfoExW(RPC_BINDING_HANDLE, шим*, бцел, бцел, RPC_AUTH_IDENTITY_HANDLE, бцел, RPC_SECURITY_QOS*);
		RPC_STATUS RpcBindingInqAuthInfoExA(RPC_BINDING_HANDLE, сим**, бцел*, бцел*, RPC_AUTH_IDENTITY_HANDLE*, бцел*, бцел, RPC_SECURITY_QOS*);
		RPC_STATUS RpcBindingInqAuthInfoExW(RPC_BINDING_HANDLE, шим**, бцел*, бцел*, RPC_AUTH_IDENTITY_HANDLE*, бцел*, бцел, RPC_SECURITY_QOS*);
		alias проц function(проц*, шим*, бцел, проц**, RPC_STATUS*) RPC_AUTH_KEY_RETRIEVAL_FN;
		RPC_STATUS RpcServerRegisterAuthInfoA(сим*, бцел, RPC_AUTH_KEY_RETRIEVAL_FN, проц*);
		RPC_STATUS RpcServerRegisterAuthInfoW(шим*, бцел, RPC_AUTH_KEY_RETRIEVAL_FN, проц*);
		RPC_STATUS UuidToStringA(UUID*, сим**);
		RPC_STATUS UuidFromStringA(сим*, UUID*);
		RPC_STATUS UuidToStringW(UUID*, шим**);
		RPC_STATUS UuidFromStringW(шим*, UUID*);
		RPC_STATUS RpcEpRegisterNoReplaceA(RPC_IF_HANDLE, RPC_BINDING_VECTOR*, UUID_VECTOR*, сим*);
		RPC_STATUS RpcEpRegisterNoReplaceW(RPC_IF_HANDLE, RPC_BINDING_VECTOR*, UUID_VECTOR*, шим*);
		RPC_STATUS RpcEpRegisterA(RPC_IF_HANDLE, RPC_BINDING_VECTOR*, UUID_VECTOR*, сим*);
		RPC_STATUS RpcEpRegisterW(RPC_IF_HANDLE, RPC_BINDING_VECTOR*, UUID_VECTOR*, шим*);
		RPC_STATUS DceErrorInqTextA(RPC_STATUS, сим*);
		RPC_STATUS DceErrorInqTextW(RPC_STATUS, шим*);
		RPC_STATUS RpcMgmtEpEltInqNextA(RPC_EP_INQ_HANDLE, RPC_IF_ID*, RPC_BINDING_HANDLE*, UUID*, сим**);
		RPC_STATUS RpcMgmtEpEltInqNextW(RPC_EP_INQ_HANDLE, RPC_IF_ID*, RPC_BINDING_HANDLE*, UUID*, шим**);

		// MinGW erroneously had these in rpc.h
		RPC_STATUS RpcImpersonateClient(RPC_BINDING_HANDLE);
		RPC_STATUS RpcRevertToSelf();
	}

	version(Unicode) {
		alias RPC_PROTSEQ_VECTORW RPC_PROTSEQ_VECTOR;
		alias SEC_WINNT_AUTH_IDENTITY_W SEC_WINNT_AUTH_IDENTITY;
		alias PSEC_WINNT_AUTH_IDENTITY_W PSEC_WINNT_AUTH_IDENTITY;
		alias RpcMgmtEpEltInqNextW RpcMgmtEpEltInqNext;
		alias RpcBindingFromStringBindingW RpcBindingFromStringBinding;
		alias RpcBindingToStringBindingW RpcBindingToStringBinding;
		alias RpcStringBindingComposeW RpcStringBindingCompose;
		alias RpcStringBindingParseW RpcStringBindingParse;
		alias RpcStringFreeW RpcStringFree;
		alias RpcNetworkIsProtseqValidW RpcNetworkIsProtseqValid;
		alias RpcNetworkInqProtseqsW RpcNetworkInqProtseqs;
		alias RpcProtseqVectorFreeW RpcProtseqVectorFree;
		alias RpcServerUseProtseqW RpcServerUseProtseq;
		alias RpcServerUseProtseqExW RpcServerUseProtseqEx;
		alias RpcServerUseProtseqEpW RpcServerUseProtseqEp;
		alias RpcServerUseProtseqEpExW RpcServerUseProtseqEpEx;
		alias RpcServerUseProtseqIfW RpcServerUseProtseqIf;
		alias RpcServerUseProtseqIfExW RpcServerUseProtseqIfEx;
		alias RpcMgmtInqServerPrincNameW RpcMgmtInqServerPrincName;
		alias RpcServerInqDefaultPrincNameW RpcServerInqDefaultPrincName;
		alias RpcNsBindingInqEntryNameW RpcNsBindingInqEntryName;
		alias RpcBindingInqAuthClientW RpcBindingInqAuthClient;
		alias RpcBindingInqAuthInfoW RpcBindingInqAuthInfo;
		alias RpcBindingSetAuthInfoW RpcBindingSetAuthInfo;
		alias RpcServerRegisterAuthInfoW RpcServerRegisterAuthInfo;
		alias RpcBindingInqAuthInfoExW RpcBindingInqAuthInfoEx;
		alias RpcBindingSetAuthInfoExW RpcBindingSetAuthInfoEx;
		alias UuidFromStringW UuidFromString;
		alias UuidToStringW UuidToString;
		alias RpcEpRegisterNoReplaceW RpcEpRegisterNoReplace;
		alias RpcEpRegisterW RpcEpRegister;
		alias DceErrorInqTextW DceErrorInqText;
	} else { // Ansi
		alias RPC_PROTSEQ_VECTORA RPC_PROTSEQ_VECTOR;
		alias SEC_WINNT_AUTH_IDENTITY_A SEC_WINNT_AUTH_IDENTITY;
		alias PSEC_WINNT_AUTH_IDENTITY_A PSEC_WINNT_AUTH_IDENTITY;
		alias RpcMgmtEpEltInqNextA RpcMgmtEpEltInqNext;
		alias RpcBindingFromStringBindingA RpcBindingFromStringBinding;
		alias RpcBindingToStringBindingA RpcBindingToStringBinding;
		alias RpcStringBindingComposeA RpcStringBindingCompose;
		alias RpcStringBindingParseA RpcStringBindingParse;
		alias RpcStringFreeA RpcStringFree;
		alias RpcNetworkIsProtseqValidA RpcNetworkIsProtseqValid;
		alias RpcNetworkInqProtseqsA RpcNetworkInqProtseqs;
		alias RpcProtseqVectorFreeA RpcProtseqVectorFree;
		alias RpcServerUseProtseqA RpcServerUseProtseq;
		alias RpcServerUseProtseqExA RpcServerUseProtseqEx;
		alias RpcServerUseProtseqEpA RpcServerUseProtseqEp;
		alias RpcServerUseProtseqEpExA RpcServerUseProtseqEpEx;
		alias RpcServerUseProtseqIfA RpcServerUseProtseqIf;
		alias RpcServerUseProtseqIfExA RpcServerUseProtseqIfEx;
		alias RpcMgmtInqServerPrincNameA RpcMgmtInqServerPrincName;
		alias RpcServerInqDefaultPrincNameA RpcServerInqDefaultPrincName;
		alias RpcNsBindingInqEntryNameA RpcNsBindingInqEntryName;
		alias RpcBindingInqAuthClientA RpcBindingInqAuthClient;
		alias RpcBindingInqAuthInfoA RpcBindingInqAuthInfo;
		alias RpcBindingSetAuthInfoA RpcBindingSetAuthInfo;
		alias RpcServerRegisterAuthInfoA RpcServerRegisterAuthInfo;
		alias RpcBindingInqAuthInfoExA RpcBindingInqAuthInfoEx;
		alias RpcBindingSetAuthInfoExA RpcBindingSetAuthInfoEx;
		alias UuidFromStringA UuidFromString;
		alias UuidToStringA UuidToString;
		alias RpcEpRegisterNoReplaceA RpcEpRegisterNoReplace;
		alias RpcEpRegisterA RpcEpRegister;
		alias DceErrorInqTextA DceErrorInqText;
	} //#endif // UNICODE

} else { // _WIN32_WINNT_ONLY

	struct RPC_PROTSEQ_VECTOR {
		бцел Count;
		ббайт* Protseq[1];
	}
	// versions without Unicode.
	RPC_STATUS RpcBindingFromStringBinding(сим*, RPC_BINDING_HANDLE*);
	RPC_STATUS RpcBindingToStringBinding(RPC_BINDING_HANDLE, сим**);
	RPC_STATUS RpcStringBindingCompose(сим*, сим*, сим*, сим*, сим*, сим**);
	RPC_STATUS RpcStringBindingParse(сим*, сим**, сим**, сим**, сим**, сим**);
	RPC_STATUS RpcStringFree(сим**);
	RPC_STATUS RpcNetworkIsProtseqValid(сим*);
	RPC_STATUS RpcNetworkInqProtseqs(RPC_PROTSEQ_VECTOR**);
	RPC_STATUS RpcServerInqBindings(RPC_BINDING_VECTOR**);
	RPC_STATUS RpcServerUseProtseq(сим*, бцел, проц*);
	RPC_STATUS RpcServerUseProtseqEx(сим*, бцел, проц*, PRPC_POLICY);
	RPC_STATUS RpcServerUseProtseqEp(сим*, бцел, сим*, проц*);
	RPC_STATUS RpcServerUseProtseqEpEx(сим*, бцел, сим*, проц*, PRPC_POLICY);
	RPC_STATUS RpcServerUseProtseqIf(сим*, бцел, RPC_IF_HANDLE, проц*);
	RPC_STATUS RpcServerUseProtseqIfEx(сим*, бцел, RPC_IF_HANDLE, проц*, PRPC_POLICY);
	RPC_STATUS RpcMgmtInqServerPrincName(RPC_BINDING_HANDLE, бцел, сим**);
	RPC_STATUS RpcServerInqDefaultPrincName(бцел, сим**);
	RPC_STATUS RpcNsBindingInqEntryName(RPC_BINDING_HANDLE, бцел, сим**);
	RPC_STATUS RpcBindingInqAuthClient(RPC_BINDING_HANDLE, RPC_AUTHZ_HANDLE*, сим**, бцел*, бцел*, бцел*);
	RPC_STATUS RpcBindingInqAuthInfo(RPC_BINDING_HANDLE, сим**, бцел*, бцел*, RPC_AUTH_IDENTITY_HANDLE*, бцел*);
	RPC_STATUS RpcBindingSetAuthInfo(RPC_BINDING_HANDLE, сим*, бцел, бцел, RPC_AUTH_IDENTITY_HANDLE, бцел);
	alias проц function(проц*, сим*, бцел, проц**, RPC_STATUS*) RPC_AUTH_KEY_RETRIEVAL_FN;
	RPC_STATUS RpcServerRegisterAuthInfo(сим*, бцел, RPC_AUTH_KEY_RETRIEVAL_FN, проц*);
	RPC_STATUS UuidToString(UUID*, сим**);
	RPC_STATUS UuidFromString(сим*, UUID*);
	RPC_STATUS RpcEpRegisterNoReplace(RPC_IF_HANDLE, RPC_BINDING_VECTOR*, UUID_VECTOR*, сим*);
	RPC_STATUS RpcEpRegister(RPC_IF_HANDLE, RPC_BINDING_VECTOR*, UUID_VECTOR*, сим*);
	RPC_STATUS DceErrorInqText(RPC_STATUS, сим*);
	RPC_STATUS RpcMgmtEpEltInqNext(RPC_EP_INQ_HANDLE, RPC_IF_ID*, RPC_BINDING_HANDLE*, сим**);
}// _WIN32_WINNT_ONLY


RPC_STATUS RpcBindingCopy(RPC_BINDING_HANDLE, RPC_BINDING_HANDLE*);
RPC_STATUS RpcBindingFree(RPC_BINDING_HANDLE*);
RPC_STATUS RpcBindingInqObject(RPC_BINDING_HANDLE, UUID*);
RPC_STATUS RpcBindingReset(RPC_BINDING_HANDLE);
RPC_STATUS RpcBindingSetObject(RPC_BINDING_HANDLE, UUID*);
RPC_STATUS RpcMgmtInqDefaultProtectLevel(бцел, бцел*);
RPC_STATUS RpcBindingVectorFree(RPC_BINDING_VECTOR**);
RPC_STATUS RpcIfInqId(RPC_IF_HANDLE, RPC_IF_ID*);
RPC_STATUS RpcMgmtInqComTimeout(RPC_BINDING_HANDLE, бцел*);
RPC_STATUS RpcMgmtSetComTimeout(RPC_BINDING_HANDLE, бцел);
RPC_STATUS RpcMgmtSetCancelTimeout(цел Timeout);
RPC_STATUS RpcObjectInqType(UUID*, UUID*);
RPC_STATUS RpcObjectSetInqFn(RPC_OBJECT_INQ_FN*);
RPC_STATUS RpcObjectSetType(UUID*, UUID*);
RPC_STATUS RpcProtseqVectorFree(RPC_PROTSEQ_VECTOR**);
RPC_STATUS RpcServerInqIf(RPC_IF_HANDLE, UUID*, RPC_MGR_EPV**);
RPC_STATUS RpcServerListen(бцел, бцел, бцел);
RPC_STATUS RpcServerRegisterIf(RPC_IF_HANDLE, UUID*, RPC_MGR_EPV*);
RPC_STATUS RpcServerRegisterIfEx(RPC_IF_HANDLE, UUID*, RPC_MGR_EPV*, бцел, бцел, RPC_IF_CALLBACK_FN*);
RPC_STATUS RpcServerRegisterIf2(RPC_IF_HANDLE, UUID*, RPC_MGR_EPV*, бцел, бцел, бцел, RPC_IF_CALLBACK_FN*);
RPC_STATUS RpcServerUnregisterIf(RPC_IF_HANDLE, UUID*, бцел);
RPC_STATUS RpcServerUseAllProtseqs(бцел, проц*);
RPC_STATUS RpcServerUseAllProtseqsEx(бцел, проц*, PRPC_POLICY);
RPC_STATUS RpcServerUseAllProtseqsIf(бцел, RPC_IF_HANDLE, проц*);
RPC_STATUS RpcServerUseAllProtseqsIfEx(бцел, RPC_IF_HANDLE, проц*, PRPC_POLICY);
RPC_STATUS RpcMgmtStatsVectorFree(RPC_STATS_VECTOR**);
RPC_STATUS RpcMgmtInqStats(RPC_BINDING_HANDLE, RPC_STATS_VECTOR**);
RPC_STATUS RpcMgmtIsServerListening(RPC_BINDING_HANDLE);
RPC_STATUS RpcMgmtStopServerListening(RPC_BINDING_HANDLE);
RPC_STATUS RpcMgmtWaitServerListen();
RPC_STATUS RpcMgmtSetServerStackSize(бцел);
проц RpcSsDontSerializeContext();
RPC_STATUS RpcMgmtEnableIdleCleanup();
RPC_STATUS RpcMgmtInqIfIds(RPC_BINDING_HANDLE, RPC_IF_ID_VECTOR**);
RPC_STATUS RpcIfIdVectorFree(RPC_IF_ID_VECTOR**);
RPC_STATUS RpcEpResolveBinding(RPC_BINDING_HANDLE, RPC_IF_HANDLE);
RPC_STATUS RpcBindingServerFromClient(RPC_BINDING_HANDLE, RPC_BINDING_HANDLE*);

// never returns
проц RpcRaiseException(RPC_STATUS);
RPC_STATUS RpcTestCancel();
RPC_STATUS RpcCancelThread(проц*);
RPC_STATUS UuidCreate(UUID*);
цел UuidCompare(UUID*, UUID*, RPC_STATUS*);
RPC_STATUS UuidCreateNil(UUID*);
цел UuidEqual(UUID*, UUID*, RPC_STATUS*);
бкрат UuidHash(UUID*, RPC_STATUS*);
цел UuidIsNil(UUID*, RPC_STATUS*);
RPC_STATUS RpcEpUnregister(RPC_IF_HANDLE, RPC_BINDING_VECTOR*, UUID_VECTOR*);
RPC_STATUS RpcMgmtEpEltInqBegin(RPC_BINDING_HANDLE, бцел, RPC_IF_ID*, бцел, UUID*, RPC_EP_INQ_HANDLE*);
RPC_STATUS RpcMgmtEpEltInqDone(RPC_EP_INQ_HANDLE*);
RPC_STATUS RpcMgmtEpUnregister(RPC_BINDING_HANDLE, RPC_IF_ID*, RPC_BINDING_HANDLE, UUID*);
RPC_STATUS RpcMgmtSetAuthorizationFn(RPC_MGMT_AUTHORIZATION_FN);
RPC_STATUS RpcMgmtInqParameter(бцел, бцел*);
RPC_STATUS RpcMgmtSetParameter(бцел, бцел);
RPC_STATUS RpcMgmtBindingInqParameter(RPC_BINDING_HANDLE, бцел, бцел*);
RPC_STATUS RpcMgmtBindingSetParameter(RPC_BINDING_HANDLE, бцел, бцел);

static if (_WIN32_WINNT >= 0x0500) {
	RPC_STATUS UuidCreateSequential(UUID*);
}
