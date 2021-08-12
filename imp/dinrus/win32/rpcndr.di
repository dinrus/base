/***********************************************************************\
*                               rpcndr.d                                *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module win32.rpcndr;
pragma(lib, "rpcrt4.lib");

/* Translation notes:
 RPC_CLIENT_ALLOC*, RPC_CLIENT_FREE* were replaced with PRPC_CLIENT_ALLOC, PRPC_CLIENT_FREE
*/

// TODO: Bitfields in MIDL_STUB_MESSAGE.
//       Macros need to be converted.
const __RPCNDR_H_VERSION__= 450;

import win32.rpcnsip;
private import win32.rpc, win32.rpcdce, win32.unknwn, win32.windef;
private import win32.objidl; // for IRpcChannelBuffer, IRpcStubBuffer
private import win32.basetyps;

extern (Windows):

const бцел NDR_CHAR_REP_MASK      = 0xF,
	NDR_INT_REP_MASK              = 0xF0,
	NDR_FLOAT_REP_MASK            = 0xFF00,
	NDR_LITTLE_ENDIAN             = 0x10,
	NDR_BIG_ENDIAN                = 0,
	NDR_IEEE_FLOAT                = 0,
	NDR_VAX_FLOAT                 = 0x100,
	NDR_ASCII_CHAR                = 0,
	NDR_EBCDIC_CHAR               = 1,
	NDR_LOCAL_DATA_REPRESENTATION = 0x10,
	NDR_LOCAL_ENDIAN              = NDR_LITTLE_ENDIAN;

alias MIDL_user_allocate midl_user_allocate;
alias MIDL_user_free midl_user_free;

alias дол hyper;
alias бдол MIDL_uhyper;
alias сим small;

const cbNDRContext=20;
//MACRO #define NDRSContextValue(hContext) (&(hContext)->userContext)
//MACRO #define byte_from_ndr(исток, цель) { *(цель) = *(*(сим**)&(исток)->Buffer)++; }

//MACRO #define byte_array_from_ndr(Source, LowerIndex, UpperIndex, Target) { NDRcopy ((((сим *)(Target))+(LowerIndex)), (Source)->Buffer, (unsigned цел)((UpperIndex)-(LowerIndex))); *(unsigned дол *)&(Source)->Buffer += ((UpperIndex)-(LowerIndex)); }

//MACRO #define boolean_from_ndr(исток, цель) { *(цель) = *(*(сим**)&(исток)->Buffer)++; }

//MACRO #define boolean_array_from_ndr(Source, LowerIndex, UpperIndex, Target) { NDRcopy ((((сим *)(Target))+(LowerIndex)), (Source)->Buffer, (unsigned цел)((UpperIndex)-(LowerIndex))); *(unsigned дол *)&(Source)->Buffer += ((UpperIndex)-(LowerIndex)); }

//MACRO #define small_from_ndr(исток, цель) { *(цель) = *(*(сим**)&(исток)->Buffer)++; }

//MACRO #define small_from_ndr_temp(исток, цель, format) { *(цель) = *(*(сим**)(исток))++; }

//MACRO #define small_array_from_ndr(Source, LowerIndex, UpperIndex, Target) { NDRcopy ((((сим *)(Target))+(LowerIndex)), (Source)->Buffer, (unsigned цел)((UpperIndex)-(LowerIndex))); *(unsigned дол *)&(Source)->Buffer += ((UpperIndex)-(LowerIndex)); }

//MACRO #define MIDL_ascii_strlen(ткст) strlen(ткст)

//MACRO #define MIDL_ascii_strcpy(цель,исток) strcpy(цель,исток)

//MACRO #define MIDL_memset(s,c,n) memset(s,c,n)

//MACRO #define _midl_ma1( p, cast ) *(*( cast **)&p)++
//MACRO #define _midl_ma2( p, cast ) *(*( cast **)&p)++
//MACRO #define _midl_ma4( p, cast ) *(*( cast **)&p)++
//MACRO #define _midl_ma8( p, cast ) *(*( cast **)&p)++
//MACRO #define _midl_unma1( p, cast ) *(( cast *)p)++
//MACRO #define _midl_unma2( p, cast ) *(( cast *)p)++
//MACRO #define _midl_unma3( p, cast ) *(( cast *)p)++
//MACRO #define _midl_unma4( p, cast ) *(( cast *)p)++
//MACRO #define _midl_fa2( p ) (p = (RPC_BUFPTR )((unsigned дол)(p+1) & 0xfffffffe))
//MACRO #define _midl_fa4( p ) (p = (RPC_BUFPTR )((unsigned дол)(p+3) & 0xfffffffc))
//MACRO #define _midl_fa8( p ) (p = (RPC_BUFPTR )((unsigned дол)(p+7) & 0xfffffff8))
//MACRO #define _midl_addp( p, n ) (p += n)
//MACRO #define _midl_marsh_lhs( p, cast ) *(*( cast **)&p)++
//MACRO #define _midl_marsh_up( mp, p ) *(*(unsigned дол **)&mp)++ = (unsigned дол)p
//MACRO #define _midl_advmp( mp ) *(*(unsigned дол **)&mp)++
//MACRO #define _midl_unmarsh_up( p ) (*(*(unsigned дол **)&p)++)

//MACRO #define NdrMarshConfStringHdr( p, s, l ) (_midl_ma4( p, unsigned дол) = s, _midl_ma4( p, unsigned дол) = 0, _midl_ma4( p, unsigned дол) = l)

//MACRO #define NdrUnMarshConfStringHdr(p, s, l) ((s=_midl_unma4(p,unsigned дол), (_midl_addp(p,4)), (l=_midl_unma4(p,unsigned дол))

//MACRO #define NdrMarshCCtxtHdl(pc,p) (NDRCContextMarshall( (NDR_CCONTEXT)pc, p ),p+20)
//MACRO #define NdrUnMarshCCtxtHdl(pc,p,h,drep) (NDRCContextUnmarshall((NDR_CONTEXT)pc,h,p,drep), p+20)
//MACRO #define NdrUnMarshSCtxtHdl(pc, p,drep) (pc = NdrSContextUnMarshall(p,drep ))
//MACRO #define NdrMarshSCtxtHdl(pc,p,rd) (NdrSContextMarshall((NDR_SCONTEXT)pc,p, (NDR_RUNDOWN)rd)

//MACRO #define NdrFieldOffset(s,f) (дол)(& (((s *)0)->f))
//MACRO #define NdrFieldPad(s,f,p,t) (NdrFieldOffset(s,f) - NdrFieldOffset(s,p) - sizeof(t))
//MACRO #define NdrFcShort(s) (unsigned сим)(s & 0xff), (unsigned сим)(s >> 8)
//MACRO #define NdrFcLong(s) (unsigned сим)(s & 0xff), (unsigned сим)((s & 0x0000ff00) >> 8), (unsigned сим)((s & 0x00ff0000) >> 16), (unsigned сим)(s >> 24)

alias проц * NDR_CCONTEXT;
struct tagNDR_SCONTEXT {
	проц *pad[2];
	проц *userContext;
}
alias tagNDR_SCONTEXT * NDR_SCONTEXT;

struct SCONTEXT_QUEUE {
	бцел NumberOfObjects;
	NDR_SCONTEXT *ArrayOfObjects;
}
alias SCONTEXT_QUEUE * PSCONTEXT_QUEUE;

struct _MIDL_STUB_MESSAGE;
struct _MIDL_STUB_DESC;
struct _FULL_PTR_XLAT_TABLES;

alias ббайт *RPC_BUFPTR;
alias бцел RPC_LENGTH;

alias  ббайт *PFORMAT_STRING;

struct ARRAY_INFO {
	цел Dimension;
	бцел *BufferConformanceMark;
	бцел *BufferVarianceMark;
	бцел *MaxCountArray;
	бцел *OffsetArray;
	бцел *ActualCountArray;
}
alias ARRAY_INFO * PARRAY_INFO;

RPC_BINDING_HANDLE  NDRCContextBinding(NDR_CCONTEXT);
проц  NDRCContextMarshall(NDR_CCONTEXT,проц*);
проц  NDRCContextUnmarshall(NDR_CCONTEXT*,RPC_BINDING_HANDLE,проц*,бцел);
проц  NDRSContextMarshall(NDR_SCONTEXT,проц*,NDR_RUNDOWN);
NDR_SCONTEXT  NDRSContextUnmarshall(проц*pBuff,бцел);
проц  RpcSsDestroyClientContext(проц**);
проц  NDRcopy(проц*,проц*,бцел);
бцел  MIDL_wchar_strlen(шим *);
проц  MIDL_wchar_strcpy(проц*,шим *);
проц  char_from_ndr(PRPC_MESSAGE,ббайт*);
проц  char_array_from_ndr(PRPC_MESSAGE,бцел,бцел,ббайт*);
проц  short_from_ndr(PRPC_MESSAGE,бкрат*);
проц  short_array_from_ndr(PRPC_MESSAGE,бцел,бцел,бкрат*);
проц  short_from_ndr_temp(ббайт**,бкрат*,бцел);
проц  int_from_ndr(PRPC_MESSAGE,бцел*);
проц  int_array_from_ndr(PRPC_MESSAGE,бцел,бцел,бцел*);
проц  int_from_ndr_temp(ббайт**,бцел*,бцел);
проц  enum_from_ndr(PRPC_MESSAGE,бцел*);
проц  float_from_ndr(PRPC_MESSAGE,проц*);
проц  float_array_from_ndr(PRPC_MESSAGE,бцел,бцел,проц*);
проц  double_from_ndr(PRPC_MESSAGE,проц*);
проц  double_array_from_ndr(PRPC_MESSAGE,бцел,бцел,проц*);
проц  hyper_from_ndr(PRPC_MESSAGE,hyper*);
проц  hyper_array_from_ndr(PRPC_MESSAGE,бцел,бцел,hyper*);
проц  hyper_from_ndr_temp(ббайт**,hyper*,бцел);
проц  data_from_ndr(PRPC_MESSAGE,проц*,сим*,ббайт);
проц  data_into_ndr(проц*,PRPC_MESSAGE,сим*,ббайт);
проц  tree_into_ndr(проц*,PRPC_MESSAGE,сим*,ббайт);
проц  data_size_ndr(проц*,PRPC_MESSAGE,сим*,ббайт);
проц  tree_size_ndr(проц*,PRPC_MESSAGE,сим*,ббайт);
проц  tree_peek_ndr(PRPC_MESSAGE,ббайт**,сим*,ббайт);
проц * midl_allocate(цел);

align(4):
struct MIDL_STUB_MESSAGE {
	PRPC_MESSAGE RpcMsg;
	ббайт *Buffer;
	ббайт *BufferStart;
	ббайт *BufferEnd;
	ббайт *BufferMark;
	бцел BufferLength;
	бцел MemorySize;
	ббайт *Memory;
	цел IsClient;
	цел ReuseBuffer;
	ббайт *AllocAllNodesMemory;
	ббайт *AllocAllNodesMemoryEnd;
	цел IgnoreEmbeddedPointers;
	ббайт *PointerBufferMark;
	ббайт fBufferValid;
	ббайт Unused;
	бцел MaxCount;
	бцел Offset;
	бцел ActualCount;
	проц* function (бцел) pfnAllocate;
	проц function (проц*) pfnFree;
	ббайт * StackTop;
	ббайт * pPresentedType;
	ббайт * pTransmitType;
	handle_t SavedHandle;
	_MIDL_STUB_DESC *StubDesc;
	_FULL_PTR_XLAT_TABLES *FullPtrXlatTables;
	бцел FullPtrRefId;
	цел fCheckBounds;
	// FIXME:
	byte bit_fields_for_D; // FIXME: Bitfields
//	цел fInDontFree :1;
//	цел fDontCallFreeInst :1;
//	цел fInOnlyParam :1;
//	цел fHasReturn :1;
	бцел dwDestContext;
	проц* pvDestContext;
	NDR_SCONTEXT * SavedContextHandles;
	цел ParamNumber;
	IRpcChannelBuffer * pRpcChannelBuffer;
	PARRAY_INFO pArrayInfo;
	бцел * SizePtrCountArray;
	бцел * SizePtrOffsetArray;
	бцел * SizePtrLengthArray;
	проц* pArgQueue;
	бцел dwStubPhase;
	бцел w2kReserved[5];
}
alias MIDL_STUB_MESSAGE * PMIDL_STUB_MESSAGE;

extern (Windows) {
	alias проц* function (проц*) GENERIC_BINDING_ROUTINE;
	alias проц function (проц*,ббайт*) GENERIC_UNBIND_ROUTINE;
	alias бцел function (бцел *,бцел,проц *) USER_MARSHAL_SIZING_ROUTINE;
	alias ббайт * function (бцел *,ббайт *,проц *) USER_MARSHAL_MARSHALLING_ROUTINE;
	alias ббайт * function (бцел *,ббайт *,проц *) USER_MARSHAL_UNMARSHALLING_ROUTINE;
	alias проц function (бцел *,проц *) USER_MARSHAL_FREEING_ROUTINE;
	alias проц function () NDR_NOTIFY_ROUTINE;
}

align:
struct GENERIC_BINDING_ROUTINE_PAIR {
	GENERIC_BINDING_ROUTINE pfnBind;
	GENERIC_UNBIND_ROUTINE pfnUnbind;
}
alias GENERIC_BINDING_ROUTINE_PAIR * PGENERIC_BINDING_ROUTINE_PAIR;

struct GENERIC_BINDING_INFO {
	проц *pObj;
	бцел Размер;
	GENERIC_BINDING_ROUTINE pfnBind;
	GENERIC_UNBIND_ROUTINE pfnUnbind;
}
alias GENERIC_BINDING_INFO * PGENERIC_BINDING_INFO;


struct XMIT_ROUTINE_QUINTUPLE {
	XMIT_HELPER_ROUTINE pfnTranslateToXmit;
	XMIT_HELPER_ROUTINE pfnTranslateFromXmit;
	XMIT_HELPER_ROUTINE pfnFreeXmit;
	XMIT_HELPER_ROUTINE pfnFreeInst;
}
alias XMIT_ROUTINE_QUINTUPLE * PXMIT_ROUTINE_QUINTUPLE;

struct MALLOC_FREE_STRUCT {
	проц* function (бцел) pfnAllocate;
	проц function (проц*) pfnFree;
}

struct COMM_FAULT_OFFSETS {
	крат CommOffset;
	крат FaultOffset;
}

struct USER_MARSHAL_ROUTINE_QUADRUPLE {
	USER_MARSHAL_SIZING_ROUTINE pfnBufferSize;
	USER_MARSHAL_MARSHALLING_ROUTINE pfnMarshall;
	USER_MARSHAL_UNMARSHALLING_ROUTINE pfnUnmarshall;
	USER_MARSHAL_FREEING_ROUTINE pfnFree;
}

enum IDL_CS_CONVERT {
	IDL_CS_NO_CONVERT,
	IDL_CS_IN_PLACE_CONVERT,
	IDL_CS_NEW_BUFFER_CONVERT
}

struct NDR_CS_SIZE_CONVERT_ROUTINES {
	CS_TYPE_NET_SIZE_ROUTINE pfnNetSize;
	CS_TYPE_TO_NETCS_ROUTINE pfnToNetCs;
	CS_TYPE_LOCAL_SIZE_ROUTINE pfnLocalSize;
	CS_TYPE_FROM_NETCS_ROUTINE pfnFromNetCs;
}

struct NDR_CS_ROUTINES {
	NDR_CS_SIZE_CONVERT_ROUTINES *pSizeConvertRoutines;
	CS_TAG_GETTING_ROUTINE *pTagGettingRoutines;
}

struct MIDL_STUB_DESC {
	проц* RpcInterfaceInformation;
	проц* function(бцел) pfnAllocate;
	проц function (проц*) pfnFree;
	union _IMPLICIT_HANDLE_INFO {
		handle_t *pAutoHandle;
		handle_t *pPrimitiveHandle;
		PGENERIC_BINDING_INFO pGenericBindingInfo;
	}
	_IMPLICIT_HANDLE_INFO IMPLICIT_HANDLE_INFO;	
	NDR_RUNDOWN *apfnNdrRundownRoutines;
	GENERIC_BINDING_ROUTINE_PAIR *aGenericBindingRoutinePairs;
	EXPR_EVAL *apfnExprEval;
	XMIT_ROUTINE_QUINTUPLE *aXmitQuintuple;
	ббайт *pFormatTypes;
	цел fCheckBounds;
	бцел Version;
	MALLOC_FREE_STRUCT *pMallocFreeStruct;
	цел MIDLVersion;
	COMM_FAULT_OFFSETS *CommFaultOffsets;
	USER_MARSHAL_ROUTINE_QUADRUPLE *aUserMarshalQuadruple;
	NDR_NOTIFY_ROUTINE *NotifyRoutineTable;
	ULONG_PTR mFlags;
	NDR_CS_ROUTINES *CsRoutineTables;
	проц *Reserved4;
	ULONG_PTR Reserved5;
}
alias  MIDL_STUB_DESC * PMIDL_STUB_DESC;

alias проц * PMIDL_XMIT_TYPE;

struct MIDL_FORMAT_STRING {
	крат Pad;
	ббайт Format[1];
}

struct MIDL_SERVER_INFO {
	PMIDL_STUB_DESC pStubDesc;
	SERVER_ROUTINE *DispatchTable;
	PFORMAT_STRING ProcString;
	бкрат *FmtStringOffset;
	STUB_THUNK *ThunkTable;
}
alias MIDL_SERVER_INFO * PMIDL_SERVER_INFO;

struct MIDL_STUBLESS_PROXY_INFO {
	PMIDL_STUB_DESC pStubDesc;
	PFORMAT_STRING ProcFormatString;
	бкрат *FormatStringOffset;
}
alias MIDL_STUBLESS_PROXY_INFO *PMIDL_STUBLESS_PROXY_INFO;

union CLIENT_CALL_RETURN {
	проц *Pointer;
	цел Simple;
}

enum XLAT_SIDE {
	XLAT_SERVER = 1,
	XLAT_CLIENT
}
struct FULL_PTR_TO_REFID_ELEMENT {
	FULL_PTR_TO_REFID_ELEMENT * Next;
	проц* Pointer;
	бцел RefId;
	ббайт State;
}
alias FULL_PTR_TO_REFID_ELEMENT * PFULL_PTR_TO_REFID_ELEMENT;

struct FULL_PTR_XLAT_TABLES {
	struct RefIdToPointer {
		проц **XlatTable;
		ббайт *StateTable;
		бцел NumberOfEntries;
	}
	struct PointerToRefId {
		PFULL_PTR_TO_REFID_ELEMENT *XlatTable;
		бцел NumberOfBuckets;
		бцел HashMask;
	}
	бцел NextRefId;
	XLAT_SIDE XlatSide;
}
alias FULL_PTR_XLAT_TABLES * PFULL_PTR_XLAT_TABLES;


enum STUB_PHASE {
	STUB_UNMARSHAL,
	STUB_CALL_SERVER,
	STUB_MARSHAL,
	STUB_CALL_SERVER_NO_HRESULT
}

enum PROXY_PHASE {
	PROXY_CALCSIZE,
	PROXY_GETBUFFER,
	PROXY_MARSHAL,
	PROXY_SENDRECEIVE,
	PROXY_UNMARSHAL
}

typedef проц * RPC_SS_THREAD_HANDLE;

extern (Windows) {
alias проц function (проц*) NDR_RUNDOWN;
alias проц function (_MIDL_STUB_MESSAGE*) EXPR_EVAL;
alias проц function(PMIDL_STUB_MESSAGE) XMIT_HELPER_ROUTINE;
alias проц function (RPC_BINDING_HANDLE,бцел,бцел,IDL_CS_CONVERT*,бцел*,error_status_t*) CS_TYPE_NET_SIZE_ROUTINE;
alias проц function (RPC_BINDING_HANDLE,бцел,бцел,IDL_CS_CONVERT*,бцел*,error_status_t*) CS_TYPE_LOCAL_SIZE_ROUTINE;
alias проц function (RPC_BINDING_HANDLE,бцел,проц*,бцел,byte*,бцел*,error_status_t*) CS_TYPE_TO_NETCS_ROUTINE;
alias проц function (RPC_BINDING_HANDLE,бцел,byte*,бцел,бцел,проц*,бцел*,error_status_t*) CS_TYPE_FROM_NETCS_ROUTINE;
alias проц function (RPC_BINDING_HANDLE,цел,бцел*,бцел*,бцел*,error_status_t*) CS_TAG_GETTING_ROUTINE;

//alias проц* RPC_CLIENT_ALLOC(бцел);
//alias проц RPC_CLIENT_FREE(проц*);
alias проц* function(бцел) PRPC_CLIENT_ALLOC;
alias проц function(проц*) PRPC_CLIENT_FREE;

	alias проц function (PMIDL_STUB_MESSAGE) STUB_THUNK;
	alias цел function() SERVER_ROUTINE;
}

проц  NdrSimpleTypeMarshall(PMIDL_STUB_MESSAGE,ббайт*,ббайт);
ббайт * NdrPointerMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING pFormat);
ббайт * NdrSimpleStructMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrConformantStructMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrConformantVaryingStructMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrHardStructMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrComplexStructMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrFixedArrayMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrConformantArrayMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrConformantVaryingArrayMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrVaryingArrayMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrComplexArrayMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrNonConformantStringMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrConformantStringMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrEncapsulatedUnionMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrNonEncapsulatedUnionMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrByteCountPointerMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrXmitOrRepAsMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт * NdrInterfacePointerMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrClientContextMarshall(PMIDL_STUB_MESSAGE,NDR_CCONTEXT,цел);
проц  NdrServerContextMarshall(PMIDL_STUB_MESSAGE,NDR_SCONTEXT,NDR_RUNDOWN);
проц  NdrSimpleTypeUnmarshall(PMIDL_STUB_MESSAGE,ббайт*,ббайт);
ббайт * NdrPointerUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrSimpleStructUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrConformantStructUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrConformantVaryingStructUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrHardStructUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrComplexStructUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrFixedArrayUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrConformantArrayUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrConformantVaryingArrayUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrVaryingArrayUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrComplexArrayUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrNonConformantStringUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrConformantStringUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrEncapsulatedUnionUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrNonEncapsulatedUnionUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrByteCountPointerUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrXmitOrRepAsUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
ббайт * NdrInterfacePointerUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
проц  NdrClientContextUnmarshall(PMIDL_STUB_MESSAGE,NDR_CCONTEXT*,RPC_BINDING_HANDLE);
NDR_SCONTEXT  NdrServerContextUnmarshall(PMIDL_STUB_MESSAGE);
проц  NdrPointerBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrSimpleStructBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrConformantStructBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrConformantVaryingStructBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrHardStructBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrComplexStructBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrFixedArrayBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrConformantArrayBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrConformantVaryingArrayBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrVaryingArrayBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrComplexArrayBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrConformantStringBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrNonConformantStringBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrEncapsulatedUnionBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrNonEncapsulatedUnionBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrByteCountPointerBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrXmitOrRepAsBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrInterfacePointerBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrContextHandleSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
бцел  NdrPointerMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrSimpleStructMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrConformantStructMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrConformantVaryingStructMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrHardStructMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrComplexStructMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrFixedArrayMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrConformantArrayMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrConformantVaryingArrayMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrVaryingArrayMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrComplexArrayMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrConformantStringMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrNonConformantStringMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrEncapsulatedUnionMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrNonEncapsulatedUnionMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrXmitOrRepAsMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
бцел  NdrInterfacePointerMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
проц  NdrPointerFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrSimpleStructFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrConformantStructFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrConformantVaryingStructFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrHardStructFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrComplexStructFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrFixedArrayFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrConformantArrayFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrConformantVaryingArrayFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrVaryingArrayFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrComplexArrayFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrEncapsulatedUnionFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrNonEncapsulatedUnionFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrByteCountPointerFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrXmitOrRepAsFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrInterfacePointerFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
проц  NdrConvert(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
проц  NdrClientInitializeNew(PRPC_MESSAGE,PMIDL_STUB_MESSAGE,PMIDL_STUB_DESC,бцел);
ббайт * NdrServerInitializeNew(PRPC_MESSAGE,PMIDL_STUB_MESSAGE,PMIDL_STUB_DESC);
проц  NdrClientInitialize(PRPC_MESSAGE,PMIDL_STUB_MESSAGE,PMIDL_STUB_DESC,бцел);
ббайт * NdrServerInitialize(PRPC_MESSAGE,PMIDL_STUB_MESSAGE,PMIDL_STUB_DESC);
ббайт * NdrServerInitializeUnmarshall(PMIDL_STUB_MESSAGE,PMIDL_STUB_DESC,PRPC_MESSAGE);
проц  NdrServerInitializeMarshall(PRPC_MESSAGE,PMIDL_STUB_MESSAGE);
ббайт * NdrGetBuffer(PMIDL_STUB_MESSAGE,бцел,RPC_BINDING_HANDLE);
ббайт * NdrNsGetBuffer(PMIDL_STUB_MESSAGE,бцел,RPC_BINDING_HANDLE);
ббайт * NdrSendReceive(PMIDL_STUB_MESSAGE,ббайт*);
ббайт * NdrNsSendReceive(PMIDL_STUB_MESSAGE,ббайт*,RPC_BINDING_HANDLE*);
проц  NdrFreeBuffer(PMIDL_STUB_MESSAGE);

CLIENT_CALL_RETURN  NdrClientCall(PMIDL_STUB_DESC,PFORMAT_STRING,...);

цел  NdrStubCall(IRpcStubBuffer*, IRpcChannelBuffer*,PRPC_MESSAGE,бцел*);
проц  NdrServerCall(PRPC_MESSAGE);
цел  NdrServerUnmarshall(IRpcChannelBuffer*, PRPC_MESSAGE,PMIDL_STUB_MESSAGE,PMIDL_STUB_DESC,PFORMAT_STRING,проц*);
проц  NdrServerMarshall(IRpcStubBuffer*, IRpcChannelBuffer*,PMIDL_STUB_MESSAGE,PFORMAT_STRING);
RPC_STATUS  NdrMapCommAndFaultStatus(PMIDL_STUB_MESSAGE,бцел*,бцел*,RPC_STATUS);
цел  NdrSH_UPDecision(PMIDL_STUB_MESSAGE,ббайт**,RPC_BUFPTR);
цел  NdrSH_TLUPDecision(PMIDL_STUB_MESSAGE,ббайт**);
цел  NdrSH_TLUPDecisionBuffer(PMIDL_STUB_MESSAGE,ббайт**);
цел  NdrSH_IfAlloc(PMIDL_STUB_MESSAGE,ббайт**,бцел);
цел  NdrSH_IfAllocRef(PMIDL_STUB_MESSAGE,ббайт**,бцел);
цел  NdrSH_IfAllocSet(PMIDL_STUB_MESSAGE,ббайт**,бцел);
RPC_BUFPTR  NdrSH_IfCopy(PMIDL_STUB_MESSAGE,ббайт**,бцел);
RPC_BUFPTR  NdrSH_IfAllocCopy(PMIDL_STUB_MESSAGE,ббайт**,бцел);
бцел  NdrSH_Copy(ббайт*,ббайт*,бцел);
проц  NdrSH_IfFree(PMIDL_STUB_MESSAGE,ббайт*);
RPC_BUFPTR  NdrSH_StringMarshall(PMIDL_STUB_MESSAGE,ббайт*,бцел,цел);
RPC_BUFPTR  NdrSH_StringUnMarshall(PMIDL_STUB_MESSAGE,ббайт**,цел);
проц* RpcSsAllocate(бцел);
проц  RpcSsDisableAllocate();
проц  RpcSsEnableAllocate();
проц  RpcSsFree(проц*);
RPC_SS_THREAD_HANDLE  RpcSsGetThreadHandle();
проц  RpcSsSetClientAllocFree(PRPC_CLIENT_ALLOC,PRPC_CLIENT_FREE);
проц  RpcSsSetThreadHandle(RPC_SS_THREAD_HANDLE);
проц  RpcSsSwapClientAllocFree(PRPC_CLIENT_ALLOC,PRPC_CLIENT_FREE,PRPC_CLIENT_ALLOC*,PRPC_CLIENT_FREE*);
проц* RpcSmAllocate(бцел,RPC_STATUS*);
RPC_STATUS  RpcSmClientFree(проц*);
RPC_STATUS  RpcSmDestroyClientContext(проц**);
RPC_STATUS  RpcSmDisableAllocate();
RPC_STATUS  RpcSmEnableAllocate();
RPC_STATUS  RpcSmFree(проц*);
RPC_SS_THREAD_HANDLE  RpcSmGetThreadHandle(RPC_STATUS*);
RPC_STATUS  RpcSmSetClientAllocFree(PRPC_CLIENT_ALLOC,PRPC_CLIENT_FREE);
RPC_STATUS  RpcSmSetThreadHandle(RPC_SS_THREAD_HANDLE);
RPC_STATUS  RpcSmSwapClientAllocFree(PRPC_CLIENT_ALLOC,PRPC_CLIENT_FREE,PRPC_CLIENT_ALLOC*,PRPC_CLIENT_FREE*);
проц  NdrRpcSsEnableAllocate(PMIDL_STUB_MESSAGE);
проц  NdrRpcSsDisableAllocate(PMIDL_STUB_MESSAGE);
проц  NdrRpcSmSetClientToOsf(PMIDL_STUB_MESSAGE);
проц* NdrRpcSmClientAllocate(бцел);
проц  NdrRpcSmClientFree(проц*);
проц* NdrRpcSsDefaultAllocate(бцел);
проц  NdrRpcSsDefaultFree(проц*);
PFULL_PTR_XLAT_TABLES  NdrFullPointerXlatInit(бцел,XLAT_SIDE);
проц  NdrFullPointerXlatFree(PFULL_PTR_XLAT_TABLES);
цел  NdrFullPointerQueryPointer(PFULL_PTR_XLAT_TABLES,проц*,ббайт,бцел*);
цел  NdrFullPointerQueryRefId(PFULL_PTR_XLAT_TABLES,бцел,ббайт,проц**);
проц  NdrFullPointerInsertRefId(PFULL_PTR_XLAT_TABLES,бцел,проц*);
цел  NdrFullPointerFree(PFULL_PTR_XLAT_TABLES,проц*);
проц* NdrAllocate(PMIDL_STUB_MESSAGE,бцел);
проц  NdrClearOutParameters(PMIDL_STUB_MESSAGE,PFORMAT_STRING,проц*);
проц* NdrOleAllocate(бцел);
проц  NdrOleFree(проц*);
ббайт* NdrUserMarshalMarshall(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
ббайт* NdrUserMarshalUnmarshall(PMIDL_STUB_MESSAGE,ббайт**,PFORMAT_STRING,ббайт);
проц  NdrUserMarshalBufferSize(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
бцел  NdrUserMarshalMemorySize(PMIDL_STUB_MESSAGE,PFORMAT_STRING);
проц  NdrUserMarshalFree(PMIDL_STUB_MESSAGE,ббайт*,PFORMAT_STRING);
