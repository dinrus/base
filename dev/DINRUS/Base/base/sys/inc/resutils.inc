; --------------------------------------------------------------------------------------------------
;                          resutils.inc Copyright The MASM32 SDK 1998-2010
; --------------------------------------------------------------------------------------------------

IFNDEF RESUTILS_INC
RESUTILS_INC equ <1>

ClusWorkerCheckTerminate PROTO STDCALL :DWORD
ClusWorkerCreate PROTO STDCALL :DWORD,:DWORD,:DWORD
ClusWorkerStart PROTO STDCALL :DWORD
ClusWorkerTerminate PROTO STDCALL :DWORD
ResUtilAddUnknownProperties PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilCreateDirectoryTree PROTO STDCALL :DWORD
ResUtilDupParameterBlock PROTO STDCALL :DWORD,:DWORD,:DWORD
ResUtilDupString PROTO STDCALL :DWORD
ResUtilEnumPrivateProperties PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilEnumProperties PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilEnumResources PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilEnumResourcesEx PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilExpandEnvironmentStrings PROTO STDCALL :DWORD
ResUtilFindBinaryProperty PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilFindDependentDiskResourceDriveLetter PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilFindDwordProperty PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilFindExpandSzProperty PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilFindExpandedSzProperty PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilFindLongProperty PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilFindMultiSzProperty PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilFindSzProperty PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilFreeEnvironment PROTO STDCALL :DWORD
ResUtilFreeParameterBlock PROTO STDCALL :DWORD,:DWORD,:DWORD
ResUtilGetAllProperties PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetBinaryProperty PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetBinaryValue PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetCoreClusterResources PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetDwordProperty PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetDwordValue PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetEnvironmentWithNetName PROTO STDCALL :DWORD
ResUtilGetMultiSzProperty PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetPrivateProperties PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetProperties PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetPropertiesToParameterBlock PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetProperty PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetPropertyFormats PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetPropertySize PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetResourceDependency PROTO STDCALL :DWORD,:DWORD
ResUtilGetResourceDependencyByClass PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetResourceDependencyByName PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetResourceDependentIPAddressProps PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetResourceName PROTO STDCALL :DWORD,:DWORD,:DWORD
ResUtilGetResourceNameDependency PROTO STDCALL :DWORD,:DWORD
ResUtilGetSzProperty PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilGetSzValue PROTO STDCALL :DWORD,:DWORD
ResUtilIsPathValid PROTO STDCALL :DWORD
ResUtilIsResourceClassEqual PROTO STDCALL :DWORD,:DWORD
ResUtilPropertyListFromParameterBlock PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilResourceTypesEqual PROTO STDCALL :DWORD,:DWORD
ResUtilResourcesEqual PROTO STDCALL :DWORD,:DWORD
ResUtilSetBinaryValue PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilSetDwordValue PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilSetExpandSzValue PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilSetMultiSzValue PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilSetPrivatePropertyList PROTO STDCALL :DWORD,:DWORD,:DWORD
ResUtilSetPropertyParameterBlock PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilSetPropertyParameterBlockEx PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilSetPropertyTable PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilSetPropertyTableEx PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilSetResourceServiceEnvironment PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilSetResourceServiceStartParameters PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilSetSzValue PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilSetUnknownProperties PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ResUtilStartResourceService PROTO STDCALL :DWORD,:DWORD
ResUtilStopResourceService PROTO STDCALL :DWORD
ResUtilStopService PROTO STDCALL :DWORD
ResUtilTerminateServiceProcessFromResDll PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilVerifyPrivatePropertyList PROTO STDCALL :DWORD,:DWORD
ResUtilVerifyPropertyTable PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ResUtilVerifyResourceService PROTO STDCALL :DWORD
ResUtilVerifyService PROTO STDCALL :DWORD

ELSE
  echo -------------------------------------------
  echo WARNING duplicate include file resutils.inc
  echo -------------------------------------------
ENDIF
