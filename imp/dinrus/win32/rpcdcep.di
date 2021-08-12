/***********************************************************************\
*                               rpcdcep.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module win32.rpcdcep;

private import win32.basetyps;
private import win32.w32api;
private import win32.windef;

alias HANDLE I_RPC_HANDLE;
alias дол RPC_STATUS;

const RPC_NCA_FLAGS_DEFAULT=0;
const RPC_NCA_FLAGS_IDEMPOTENT=1;
const RPC_NCA_FLAGS_BROADCAST=2;
const RPC_NCA_FLAGS_MAYBE=4;
const RPCFLG_ASYNCHRONOUS=0x40000000;
const RPCFLG_INPUT_SYNCHRONOUS=0x20000000;
const RPC_FLAGS_VALID_BIT=0x8000;

const TRANSPORT_TYPE_CN=1;
const TRANSPORT_TYPE_DG=2;
const TRANSPORT_TYPE_LPC=4;
const TRANSPORT_TYPE_WMSG=8;

struct RPC_VERSION {
	бкрат MajorVersion;
	бкрат MinorVersion;
}
struct RPC_SYNTAX_IDENTIFIER {
	GUID        SyntaxGUID;
	RPC_VERSION SyntaxVersion;
}
alias RPC_SYNTAX_IDENTIFIER* PRPC_SYNTAX_IDENTIFIER;

struct RPC_MESSAGE {
	HANDLE Handle;
	бцел  DataRepresentation;
	проц* Buffer;
	бцел  BufferLength;
	бцел  ProcNum;
	PRPC_SYNTAX_IDENTIFIER TransferSyntax;
	проц* RpcInterfaceInformation;
	проц* ReservedForRuntime;
	проц* ManagerEpv;
	проц* ImportContext;
	бцел  RpcFlags;
}
alias RPC_MESSAGE* PRPC_MESSAGE;

extern (Windows) {
alias проц function (PRPC_MESSAGE Message) RPC_DISPATCH_FUNCTION;
}

struct RPC_DISPATCH_TABLE {
	бцел DispatchTableCount;
	RPC_DISPATCH_FUNCTION* DispatchTable;
	цел  Reserved;
}
alias RPC_DISPATCH_TABLE* PRPC_DISPATCH_TABLE;

struct RPC_PROTSEQ_ENDPOINT {
	ббайт* RpcProtocolSequence;
	ббайт* Endpoint;
}
alias RPC_PROTSEQ_ENDPOINT* PRPC_PROTSEQ_ENDPOINT;

struct RPC_SERVER_INTERFACE {
	бцел                  Length;
	RPC_SYNTAX_IDENTIFIER InterfaceId;
	RPC_SYNTAX_IDENTIFIER TransferSyntax;
	PRPC_DISPATCH_TABLE   DispatchTable;
	бцел                  RpcProtseqEndpointCount;
	PRPC_PROTSEQ_ENDPOINT RpcProtseqEndpoint;
	проц*                 DefaultManagerEpv;
	проц*                 InterpreterInfo;
}
alias RPC_SERVER_INTERFACE* PRPC_SERVER_INTERFACE;

struct RPC_CLIENT_INTERFACE {
	бцел                  Length;
	RPC_SYNTAX_IDENTIFIER InterfaceId;
	RPC_SYNTAX_IDENTIFIER TransferSyntax;
	PRPC_DISPATCH_TABLE   DispatchTable;
	бцел                  RpcProtseqEndpointCount;
	PRPC_PROTSEQ_ENDPOINT RpcProtseqEndpoint;
	бцел                  Reserved;
	проц*                 InterpreterInfo;
}
alias RPC_CLIENT_INTERFACE* PRPC_CLIENT_INTERFACE;

typedef проц* I_RPC_MUTEX;

struct RPC_TRANSFER_SYNTAX {
	GUID   Uuid;
	бкрат VersMajor;
	бкрат VersMinor;
}
alias RPC_STATUS function(проц*, проц*, проц*) RPC_BLOCKING_FN;

extern (Windows) {
	alias проц function(проц*) PRPC_RUNDOWN;
	
	цел    I_RpcGetBuffer(RPC_MESSAGE*);
	цел    I_RpcSendReceive(RPC_MESSAGE*);
	цел    I_RpcSend(RPC_MESSAGE*);
	цел    I_RpcFreeBuffer(RPC_MESSAGE*);
	проц   I_RpcRequestMutex(I_RPC_MUTEX*);
	проц   I_RpcClearMutex(I_RPC_MUTEX);
	проц   I_RpcDeleteMutex(I_RPC_MUTEX);
	проц*  I_RpcAllocate(бцел);
	проц   I_RpcFree(проц*);
	проц   I_RpcPauseExecution(бцел);
	цел    I_RpcMonitorAssociation(HANDLE, PRPC_RUNDOWN, проц*);
	цел    I_RpcStopMonitorAssociation(HANDLE);
	HANDLE I_RpcGetCurrentCallHandle();
	цел    I_RpcGetAssociationContext(проц**);
	цел    I_RpcSetAssociationContext(проц*);

	static if (_WIN32_WINNT_ONLY) {
		цел I_RpcNsBindingSetEntryName(HANDLE, бцел, шим*);
		цел I_RpcBindingInqDynamicEndpoint(HANDLE, шим**);
	} else {
		цел I_RpcNsBindingSetEntryName(HANDLE, бцел, сим*);
		цел I_RpcBindingInqDynamicEndpoint(HANDLE, сим**);
	}

	цел   I_RpcBindingInqTransportType(HANDLE, бцел*);
	цел   I_RpcIfInqTransferSyntaxes(HANDLE, RPC_TRANSFER_SYNTAX*, бцел,
	        бцел*);
	цел   I_UuidCreate(GUID*);
	цел   I_RpcBindingCopy(HANDLE, HANDLE*);
	цел   I_RpcBindingIsClientLocal(HANDLE, бцел*);
	проц  I_RpcSsDontSerializeContext();
	цел   I_RpcServerRegisterForwardFunction(цел function (GUID*,
	        RPC_VERSION*, GUID*, ббайт*, проц**));
	цел   I_RpcConnectionInqSockBuffSize(бцел*, бцел*);
	цел   I_RpcConnectionSetSockBuffSize(бцел, бцел);
	цел   I_RpcBindingSetAsync(HANDLE, RPC_BLOCKING_FN);
	цел   I_RpcAsyncSendReceive(RPC_MESSAGE*, проц*);
	цел   I_RpcGetThreadWindowHandle(проц**);
	цел   I_RpcServerThreadPauseListening();
	цел   I_RpcServerThreadContinueListening();
	цел   I_RpcServerUnregisterEndpointA(ббайт*, ббайт*);
	цел   I_RpcServerUnregisterEndpointW(бкрат*, бкрат*);
}

version(Unicode) {
	alias I_RpcServerUnregisterEndpointW I_RpcServerUnregisterEndpoint;
} else {
	alias I_RpcServerUnregisterEndpointA I_RpcServerUnregisterEndpoint;
}
