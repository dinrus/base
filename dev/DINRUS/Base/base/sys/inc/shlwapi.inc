; --------------------------------------------------------------------------------------------------
;                           shlwapi.inc Copyright The MASM32 SDK 1998-2010
; --------------------------------------------------------------------------------------------------

IFNDEF SHLWAPI_INC
SHLWAPI_INC equ <1>

AssocCreate PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AssocGetPerceivedType PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
AssocIsDangerous PROTO STDCALL :DWORD

AssocQueryKeyA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  AssocQueryKey equ <AssocQueryKeyA>
ENDIF

AssocQueryKeyW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  AssocQueryKey equ <AssocQueryKeyW>
ENDIF

AssocQueryStringA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  AssocQueryString equ <AssocQueryStringA>
ENDIF

AssocQueryStringByKeyA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  AssocQueryStringByKey equ <AssocQueryStringByKeyA>
ENDIF

AssocQueryStringByKeyW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  AssocQueryStringByKey equ <AssocQueryStringByKeyW>
ENDIF

AssocQueryStringW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  AssocQueryString equ <AssocQueryStringW>
ENDIF

ChrCmpIA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  ChrCmpI equ <ChrCmpIA>
ENDIF

ChrCmpIW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  ChrCmpI equ <ChrCmpIW>
ENDIF

ColorAdjustLuma PROTO STDCALL :DWORD,:DWORD,:DWORD
ColorHLSToRGB PROTO STDCALL :DWORD,:DWORD,:DWORD
ColorRGBToHLS PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD

GetAcceptLanguagesA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  GetAcceptLanguages equ <GetAcceptLanguagesA>
ENDIF

GetAcceptLanguagesW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  GetAcceptLanguages equ <GetAcceptLanguagesW>
ENDIF

GetMenuPosFromID PROTO STDCALL :DWORD,:DWORD
HashData PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD

IntlStrEqWorkerA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  IntlStrEqWorker equ <IntlStrEqWorkerA>
ENDIF

IntlStrEqWorkerW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  IntlStrEqWorker equ <IntlStrEqWorkerW>
ENDIF

IsCharSpaceA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  IsCharSpace equ <IsCharSpaceA>
ENDIF

IsCharSpaceW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  IsCharSpace equ <IsCharSpaceW>
ENDIF

PathAddBackslashA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathAddBackslash equ <PathAddBackslashA>
ENDIF

PathAddBackslashW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathAddBackslash equ <PathAddBackslashW>
ENDIF

PathAddExtensionA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  PathAddExtension equ <PathAddExtensionA>
ENDIF

PathAddExtensionW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  PathAddExtension equ <PathAddExtensionW>
ENDIF

PathAppendA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  PathAppend equ <PathAppendA>
ENDIF

PathAppendW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  PathAppend equ <PathAppendW>
ENDIF

PathBuildRootA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  PathBuildRoot equ <PathBuildRootA>
ENDIF

PathBuildRootW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  PathBuildRoot equ <PathBuildRootW>
ENDIF

PathCanonicalizeA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  PathCanonicalize equ <PathCanonicalizeA>
ENDIF

PathCanonicalizeW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  PathCanonicalize equ <PathCanonicalizeW>
ENDIF

PathCombineA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  PathCombine equ <PathCombineA>
ENDIF

PathCombineW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  PathCombine equ <PathCombineW>
ENDIF

PathCommonPrefixA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  PathCommonPrefix equ <PathCommonPrefixA>
ENDIF

PathCommonPrefixW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  PathCommonPrefix equ <PathCommonPrefixW>
ENDIF

PathCompactPathA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  PathCompactPath equ <PathCompactPathA>
ENDIF

PathCompactPathExA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  PathCompactPathEx equ <PathCompactPathExA>
ENDIF

PathCompactPathExW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  PathCompactPathEx equ <PathCompactPathExW>
ENDIF

PathCompactPathW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  PathCompactPath equ <PathCompactPathW>
ENDIF

PathCreateFromUrlA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  PathCreateFromUrl equ <PathCreateFromUrlA>
ENDIF

PathCreateFromUrlW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  PathCreateFromUrl equ <PathCreateFromUrlW>
ENDIF

PathFileExistsA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathFileExists equ <PathFileExistsA>
ENDIF

PathFileExistsW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathFileExists equ <PathFileExistsW>
ENDIF

PathFindExtensionA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathFindExtension equ <PathFindExtensionA>
ENDIF

PathFindExtensionW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathFindExtension equ <PathFindExtensionW>
ENDIF

PathFindFileNameA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathFindFileName equ <PathFindFileNameA>
ENDIF

PathFindFileNameW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathFindFileName equ <PathFindFileNameW>
ENDIF

PathFindNextComponentA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathFindNextComponent equ <PathFindNextComponentA>
ENDIF

PathFindNextComponentW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathFindNextComponent equ <PathFindNextComponentW>
ENDIF

PathFindOnPathA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  PathFindOnPath equ <PathFindOnPathA>
ENDIF

PathFindOnPathW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  PathFindOnPath equ <PathFindOnPathW>
ENDIF

PathFindSuffixArrayA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  PathFindSuffixArray equ <PathFindSuffixArrayA>
ENDIF

PathFindSuffixArrayW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  PathFindSuffixArray equ <PathFindSuffixArrayW>
ENDIF

PathGetArgsA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathGetArgs equ <PathGetArgsA>
ENDIF

PathGetArgsW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathGetArgs equ <PathGetArgsW>
ENDIF

PathGetCharTypeA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathGetCharType equ <PathGetCharTypeA>
ENDIF

PathGetCharTypeW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathGetCharType equ <PathGetCharTypeW>
ENDIF

PathGetDriveNumberA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathGetDriveNumber equ <PathGetDriveNumberA>
ENDIF

PathGetDriveNumberW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathGetDriveNumber equ <PathGetDriveNumberW>
ENDIF

PathIsContentTypeA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  PathIsContentType equ <PathIsContentTypeA>
ENDIF

PathIsContentTypeW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  PathIsContentType equ <PathIsContentTypeW>
ENDIF

PathIsDirectoryA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathIsDirectory equ <PathIsDirectoryA>
ENDIF

PathIsDirectoryEmptyA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathIsDirectoryEmpty equ <PathIsDirectoryEmptyA>
ENDIF

PathIsDirectoryEmptyW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathIsDirectoryEmpty equ <PathIsDirectoryEmptyW>
ENDIF

PathIsDirectoryW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathIsDirectory equ <PathIsDirectoryW>
ENDIF

PathIsFileSpecA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathIsFileSpec equ <PathIsFileSpecA>
ENDIF

PathIsFileSpecW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathIsFileSpec equ <PathIsFileSpecW>
ENDIF

PathIsLFNFileSpecA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathIsLFNFileSpec equ <PathIsLFNFileSpecA>
ENDIF

PathIsLFNFileSpecW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathIsLFNFileSpec equ <PathIsLFNFileSpecW>
ENDIF

PathIsNetworkPathA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathIsNetworkPath equ <PathIsNetworkPathA>
ENDIF

PathIsNetworkPathW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathIsNetworkPath equ <PathIsNetworkPathW>
ENDIF

PathIsPrefixA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  PathIsPrefix equ <PathIsPrefixA>
ENDIF

PathIsPrefixW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  PathIsPrefix equ <PathIsPrefixW>
ENDIF

PathIsRelativeA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathIsRelative equ <PathIsRelativeA>
ENDIF

PathIsRelativeW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathIsRelative equ <PathIsRelativeW>
ENDIF

PathIsRootA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathIsRoot equ <PathIsRootA>
ENDIF

PathIsRootW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathIsRoot equ <PathIsRootW>
ENDIF

PathIsSameRootA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  PathIsSameRoot equ <PathIsSameRootA>
ENDIF

PathIsSameRootW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  PathIsSameRoot equ <PathIsSameRootW>
ENDIF

PathIsSystemFolderA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  PathIsSystemFolder equ <PathIsSystemFolderA>
ENDIF

PathIsSystemFolderW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  PathIsSystemFolder equ <PathIsSystemFolderW>
ENDIF

PathIsUNCA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathIsUNC equ <PathIsUNCA>
ENDIF

PathIsUNCServerA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathIsUNCServer equ <PathIsUNCServerA>
ENDIF

PathIsUNCServerShareA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathIsUNCServerShare equ <PathIsUNCServerShareA>
ENDIF

PathIsUNCServerShareW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathIsUNCServerShare equ <PathIsUNCServerShareW>
ENDIF

PathIsUNCServerW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathIsUNCServer equ <PathIsUNCServerW>
ENDIF

PathIsUNCW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathIsUNC equ <PathIsUNCW>
ENDIF

PathIsURLA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathIsURL equ <PathIsURLA>
ENDIF

PathIsURLW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathIsURL equ <PathIsURLW>
ENDIF

PathMakePrettyA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathMakePretty equ <PathMakePrettyA>
ENDIF

PathMakePrettyW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathMakePretty equ <PathMakePrettyW>
ENDIF

PathMakeSystemFolderA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathMakeSystemFolder equ <PathMakeSystemFolderA>
ENDIF

PathMakeSystemFolderW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathMakeSystemFolder equ <PathMakeSystemFolderW>
ENDIF

PathMatchSpecA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  PathMatchSpec equ <PathMatchSpecA>
ENDIF

PathMatchSpecW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  PathMatchSpec equ <PathMatchSpecW>
ENDIF

PathParseIconLocationA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathParseIconLocation equ <PathParseIconLocationA>
ENDIF

PathParseIconLocationW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathParseIconLocation equ <PathParseIconLocationW>
ENDIF

PathQuoteSpacesA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathQuoteSpaces equ <PathQuoteSpacesA>
ENDIF

PathQuoteSpacesW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathQuoteSpaces equ <PathQuoteSpacesW>
ENDIF

PathRelativePathToA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  PathRelativePathTo equ <PathRelativePathToA>
ENDIF

PathRelativePathToW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  PathRelativePathTo equ <PathRelativePathToW>
ENDIF

PathRemoveArgsA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathRemoveArgs equ <PathRemoveArgsA>
ENDIF

PathRemoveArgsW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathRemoveArgs equ <PathRemoveArgsW>
ENDIF

PathRemoveBackslashA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathRemoveBackslash equ <PathRemoveBackslashA>
ENDIF

PathRemoveBackslashW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathRemoveBackslash equ <PathRemoveBackslashW>
ENDIF

PathRemoveBlanksA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathRemoveBlanks equ <PathRemoveBlanksA>
ENDIF

PathRemoveBlanksW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathRemoveBlanks equ <PathRemoveBlanksW>
ENDIF

PathRemoveExtensionA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathRemoveExtension equ <PathRemoveExtensionA>
ENDIF

PathRemoveExtensionW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathRemoveExtension equ <PathRemoveExtensionW>
ENDIF

PathRemoveFileSpecA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathRemoveFileSpec equ <PathRemoveFileSpecA>
ENDIF

PathRemoveFileSpecW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathRemoveFileSpec equ <PathRemoveFileSpecW>
ENDIF

PathRenameExtensionA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  PathRenameExtension equ <PathRenameExtensionA>
ENDIF

PathRenameExtensionW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  PathRenameExtension equ <PathRenameExtensionW>
ENDIF

PathSearchAndQualifyA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  PathSearchAndQualify equ <PathSearchAndQualifyA>
ENDIF

PathSearchAndQualifyW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  PathSearchAndQualify equ <PathSearchAndQualifyW>
ENDIF

PathSetDlgItemPathA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  PathSetDlgItemPath equ <PathSetDlgItemPathA>
ENDIF

PathSetDlgItemPathW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  PathSetDlgItemPath equ <PathSetDlgItemPathW>
ENDIF

PathSkipRootA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathSkipRoot equ <PathSkipRootA>
ENDIF

PathSkipRootW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathSkipRoot equ <PathSkipRootW>
ENDIF

PathStripPathA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathStripPath equ <PathStripPathA>
ENDIF

PathStripPathW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathStripPath equ <PathStripPathW>
ENDIF

PathStripToRootA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathStripToRoot equ <PathStripToRootA>
ENDIF

PathStripToRootW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathStripToRoot equ <PathStripToRootW>
ENDIF

PathUnExpandEnvStringsA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  PathUnExpandEnvStrings equ <PathUnExpandEnvStringsA>
ENDIF

PathUnExpandEnvStringsW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  PathUnExpandEnvStrings equ <PathUnExpandEnvStringsW>
ENDIF

PathUndecorateA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathUndecorate equ <PathUndecorateA>
ENDIF

PathUndecorateW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathUndecorate equ <PathUndecorateW>
ENDIF

PathUnmakeSystemFolderA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathUnmakeSystemFolder equ <PathUnmakeSystemFolderA>
ENDIF

PathUnmakeSystemFolderW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathUnmakeSystemFolder equ <PathUnmakeSystemFolderW>
ENDIF

PathUnquoteSpacesA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  PathUnquoteSpaces equ <PathUnquoteSpacesA>
ENDIF

PathUnquoteSpacesW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  PathUnquoteSpaces equ <PathUnquoteSpacesW>
ENDIF

SHAllocShared PROTO STDCALL :DWORD,:DWORD,:DWORD
SHAutoComplete PROTO STDCALL :DWORD,:DWORD

SHCopyKeyA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHCopyKey equ <SHCopyKeyA>
ENDIF

SHCopyKeyW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHCopyKey equ <SHCopyKeyW>
ENDIF

SHCreateShellPalette PROTO STDCALL :DWORD

SHCreateStreamOnFileA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHCreateStreamOnFile equ <SHCreateStreamOnFileA>
ENDIF

SHCreateStreamOnFileEx PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD

SHCreateStreamOnFileW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHCreateStreamOnFile equ <SHCreateStreamOnFileW>
ENDIF

SHCreateStreamWrapper PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
SHCreateThread PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
SHCreateThreadRef PROTO STDCALL :DWORD,:DWORD

SHDeleteEmptyKeyA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  SHDeleteEmptyKey equ <SHDeleteEmptyKeyA>
ENDIF

SHDeleteEmptyKeyW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  SHDeleteEmptyKey equ <SHDeleteEmptyKeyW>
ENDIF

SHDeleteKeyA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  SHDeleteKey equ <SHDeleteKeyA>
ENDIF

SHDeleteKeyW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  SHDeleteKey equ <SHDeleteKeyW>
ENDIF

SHDeleteOrphanKeyA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  SHDeleteOrphanKey equ <SHDeleteOrphanKeyA>
ENDIF

SHDeleteOrphanKeyW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  SHDeleteOrphanKey equ <SHDeleteOrphanKeyW>
ENDIF

SHDeleteValueA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHDeleteValue equ <SHDeleteValueA>
ENDIF

SHDeleteValueW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHDeleteValue equ <SHDeleteValueW>
ENDIF

SHEnumKeyExA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHEnumKeyEx equ <SHEnumKeyExA>
ENDIF

SHEnumKeyExW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHEnumKeyEx equ <SHEnumKeyExW>
ENDIF

SHEnumValueA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHEnumValue equ <SHEnumValueA>
ENDIF

SHEnumValueW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHEnumValue equ <SHEnumValueW>
ENDIF

SHFreeShared PROTO STDCALL :DWORD,:DWORD
SHGetInverseCMAP PROTO STDCALL :DWORD,:DWORD
SHGetThreadRef PROTO STDCALL :DWORD

SHGetValueA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHGetValue equ <SHGetValueA>
ENDIF

SHGetValueW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHGetValue equ <SHGetValueW>
ENDIF

SHGetViewStatePropertyBag PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHIsLowMemoryMachine PROTO STDCALL :DWORD
SHLoadIndirectString PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
SHLockShared PROTO STDCALL :DWORD,:DWORD

SHOpenRegStream2A PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHOpenRegStream2 equ <SHOpenRegStream2A>
ENDIF

SHOpenRegStream2W PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHOpenRegStream2 equ <SHOpenRegStream2W>
ENDIF

SHOpenRegStreamA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHOpenRegStream equ <SHOpenRegStreamA>
ENDIF

SHOpenRegStreamW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHOpenRegStream equ <SHOpenRegStreamW>
ENDIF

SHQueryInfoKeyA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHQueryInfoKey equ <SHQueryInfoKeyA>
ENDIF

SHQueryInfoKeyW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHQueryInfoKey equ <SHQueryInfoKeyW>
ENDIF

SHQueryValueExA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHQueryValueEx equ <SHQueryValueExA>
ENDIF

SHQueryValueExW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHQueryValueEx equ <SHQueryValueExW>
ENDIF

SHRegCloseUSKey PROTO STDCALL :DWORD

SHRegCreateUSKeyA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHRegCreateUSKey equ <SHRegCreateUSKeyA>
ENDIF

SHRegCreateUSKeyW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHRegCreateUSKey equ <SHRegCreateUSKeyW>
ENDIF

SHRegDeleteEmptyUSKeyA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHRegDeleteEmptyUSKey equ <SHRegDeleteEmptyUSKeyA>
ENDIF

SHRegDeleteEmptyUSKeyW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHRegDeleteEmptyUSKey equ <SHRegDeleteEmptyUSKeyW>
ENDIF

SHRegDeleteUSValueA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHRegDeleteUSValue equ <SHRegDeleteUSValueA>
ENDIF

SHRegDeleteUSValueW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHRegDeleteUSValue equ <SHRegDeleteUSValueW>
ENDIF

SHRegDuplicateHKey PROTO STDCALL :DWORD

SHRegEnumUSKeyA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHRegEnumUSKey equ <SHRegEnumUSKeyA>
ENDIF

SHRegEnumUSKeyW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHRegEnumUSKey equ <SHRegEnumUSKeyW>
ENDIF

SHRegEnumUSValueA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHRegEnumUSValue equ <SHRegEnumUSValueA>
ENDIF

SHRegEnumUSValueW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHRegEnumUSValue equ <SHRegEnumUSValueW>
ENDIF

SHRegGetBoolUSValueA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHRegGetBoolUSValue equ <SHRegGetBoolUSValueA>
ENDIF

SHRegGetBoolUSValueW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHRegGetBoolUSValue equ <SHRegGetBoolUSValueW>
ENDIF

SHRegGetPathA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHRegGetPath equ <SHRegGetPathA>
ENDIF

SHRegGetPathW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHRegGetPath equ <SHRegGetPathW>
ENDIF

SHRegGetUSValueA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHRegGetUSValue equ <SHRegGetUSValueA>
ENDIF

SHRegGetUSValueW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHRegGetUSValue equ <SHRegGetUSValueW>
ENDIF

SHRegGetValueA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHRegGetValue equ <SHRegGetValueA>
ENDIF

SHRegGetValueW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHRegGetValue equ <SHRegGetValueW>
ENDIF

SHRegOpenUSKeyA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHRegOpenUSKey equ <SHRegOpenUSKeyA>
ENDIF

SHRegOpenUSKeyW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHRegOpenUSKey equ <SHRegOpenUSKeyW>
ENDIF

SHRegQueryInfoUSKeyA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHRegQueryInfoUSKey equ <SHRegQueryInfoUSKeyA>
ENDIF

SHRegQueryInfoUSKeyW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHRegQueryInfoUSKey equ <SHRegQueryInfoUSKeyW>
ENDIF

SHRegQueryUSValueA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHRegQueryUSValue equ <SHRegQueryUSValueA>
ENDIF

SHRegQueryUSValueW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHRegQueryUSValue equ <SHRegQueryUSValueW>
ENDIF

SHRegSetPathA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHRegSetPath equ <SHRegSetPathA>
ENDIF

SHRegSetPathW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHRegSetPath equ <SHRegSetPathW>
ENDIF

SHRegSetUSValueA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHRegSetUSValue equ <SHRegSetUSValueA>
ENDIF

SHRegSetUSValueW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHRegSetUSValue equ <SHRegSetUSValueW>
ENDIF

SHRegWriteUSValueA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHRegWriteUSValue equ <SHRegWriteUSValueA>
ENDIF

SHRegWriteUSValueW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHRegWriteUSValue equ <SHRegWriteUSValueW>
ENDIF

SHRegisterValidateTemplate PROTO STDCALL :DWORD,:DWORD
SHReleaseThreadRef PROTO STDCALL
SHSetThreadRef PROTO STDCALL :DWORD

SHSetValueA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  SHSetValue equ <SHSetValueA>
ENDIF

SHSetValueW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  SHSetValue equ <SHSetValueW>
ENDIF

SHSkipJunction PROTO STDCALL :DWORD,:DWORD

SHStrDupA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  SHStrDup equ <SHStrDupA>
ENDIF

SHStrDupW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  SHStrDup equ <SHStrDupW>
ENDIF

SHUnlockShared PROTO STDCALL :DWORD

StrCSpnA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  StrCSpn equ <StrCSpnA>
ENDIF

StrCSpnIA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  StrCSpnI equ <StrCSpnIA>
ENDIF

StrCSpnIW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrCSpnI equ <StrCSpnIW>
ENDIF

StrCSpnW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrCSpn equ <StrCSpnW>
ENDIF

StrCatBuffA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrCatBuff equ <StrCatBuffA>
ENDIF

StrCatBuffW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrCatBuff equ <StrCatBuffW>
ENDIF

StrCatChainW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrCatChain equ <StrCatChainW>
ENDIF

StrCatW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrCat equ <StrCatW>
ENDIF

StrChrA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  StrChr equ <StrChrA>
ENDIF

StrChrIA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  StrChrI equ <StrChrIA>
ENDIF

StrChrIW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrChrI equ <StrChrIW>
ENDIF

StrChrNIW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrChrNI equ <StrChrNIW>
ENDIF

StrChrNW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrChrN equ <StrChrNW>
ENDIF

StrChrW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrChr equ <StrChrW>
ENDIF

StrCmpCA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  StrCmpC equ <StrCmpCA>
ENDIF

StrCmpCW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrCmpC equ <StrCmpCW>
ENDIF

StrCmpICA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  StrCmpIC equ <StrCmpICA>
ENDIF

StrCmpICW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrCmpIC equ <StrCmpICW>
ENDIF

StrCmpIW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrCmpI equ <StrCmpIW>
ENDIF

StrCmpLogicalW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrCmpLogical equ <StrCmpLogicalW>
ENDIF

StrCmpNA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrCmpN equ <StrCmpNA>
ENDIF

StrCmpNIA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrCmpNI equ <StrCmpNIA>
ENDIF

StrCmpNIW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrCmpNI equ <StrCmpNIW>
ENDIF

StrCmpNW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrCmpN equ <StrCmpNW>
ENDIF

StrCmpW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrCmp equ <StrCmpW>
ENDIF

StrCpyNW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrCpyN equ <StrCpyNW>
ENDIF

StrCpyW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrCpy equ <StrCpyW>
ENDIF

StrDupA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  StrDup equ <StrDupA>
ENDIF

StrDupW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  StrDup equ <StrDupW>
ENDIF

StrFormatByteSize64A PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrFormatByteSize64 equ <StrFormatByteSize64A>
ENDIF

StrFormatByteSizeA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrFormatByteSize equ <StrFormatByteSizeA>
ENDIF

StrFormatByteSizeW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrFormatByteSize equ <StrFormatByteSizeW>
ENDIF

StrFormatKBSizeA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrFormatKBSize equ <StrFormatKBSizeA>
ENDIF

StrFormatKBSizeW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrFormatKBSize equ <StrFormatKBSizeW>
ENDIF

StrFromTimeIntervalA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrFromTimeInterval equ <StrFromTimeIntervalA>
ENDIF

StrFromTimeIntervalW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrFromTimeInterval equ <StrFromTimeIntervalW>
ENDIF

StrIsIntlEqualA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrIsIntlEqual equ <StrIsIntlEqualA>
ENDIF

StrIsIntlEqualW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrIsIntlEqual equ <StrIsIntlEqualW>
ENDIF

StrNCatA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrNCat equ <StrNCatA>
ENDIF

StrNCatW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrNCat equ <StrNCatW>
ENDIF

StrPBrkA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  StrPBrk equ <StrPBrkA>
ENDIF

StrPBrkW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrPBrk equ <StrPBrkW>
ENDIF

StrRChrA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrRChr equ <StrRChrA>
ENDIF

StrRChrIA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrRChrI equ <StrRChrIA>
ENDIF

StrRChrIW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrRChrI equ <StrRChrIW>
ENDIF

StrRChrW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrRChr equ <StrRChrW>
ENDIF

StrRStrIA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrRStrI equ <StrRStrIA>
ENDIF

StrRStrIW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrRStrI equ <StrRStrIW>
ENDIF

StrRetToBSTR PROTO STDCALL :DWORD,:DWORD,:DWORD

StrRetToBufA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrRetToBuf equ <StrRetToBufA>
ENDIF

StrRetToBufW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrRetToBuf equ <StrRetToBufW>
ENDIF

StrRetToStrA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrRetToStr equ <StrRetToStrA>
ENDIF

StrRetToStrW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrRetToStr equ <StrRetToStrW>
ENDIF

StrSpnA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  StrSpn equ <StrSpnA>
ENDIF

StrSpnW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrSpn equ <StrSpnW>
ENDIF

StrStrA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  StrStr equ <StrStrA>
ENDIF

StrStrIA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  StrStrI equ <StrStrIA>
ENDIF

StrStrIW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrStrI equ <StrStrIW>
ENDIF

StrStrNIW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrStrNI equ <StrStrNIW>
ENDIF

StrStrNW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrStrN equ <StrStrNW>
ENDIF

StrStrW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrStr equ <StrStrW>
ENDIF

StrToInt64ExA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrToInt64Ex equ <StrToInt64ExA>
ENDIF

StrToInt64ExW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrToInt64Ex equ <StrToInt64ExW>
ENDIF

StrToIntA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  StrToInt equ <StrToIntA>
ENDIF

StrToIntExA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  StrToIntEx equ <StrToIntExA>
ENDIF

StrToIntExW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  StrToIntEx equ <StrToIntExW>
ENDIF

StrToIntW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  StrToInt equ <StrToIntW>
ENDIF

StrTrimA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  StrTrim equ <StrTrimA>
ENDIF

StrTrimW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  StrTrim equ <StrTrimW>
ENDIF

UrlApplySchemeA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  UrlApplyScheme equ <UrlApplySchemeA>
ENDIF

UrlApplySchemeW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  UrlApplyScheme equ <UrlApplySchemeW>
ENDIF

UrlCanonicalizeA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  UrlCanonicalize equ <UrlCanonicalizeA>
ENDIF

UrlCanonicalizeW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  UrlCanonicalize equ <UrlCanonicalizeW>
ENDIF

UrlCombineA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  UrlCombine equ <UrlCombineA>
ENDIF

UrlCombineW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  UrlCombine equ <UrlCombineW>
ENDIF

UrlCompareA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  UrlCompare equ <UrlCompareA>
ENDIF

UrlCompareW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  UrlCompare equ <UrlCompareW>
ENDIF

UrlCreateFromPathA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  UrlCreateFromPath equ <UrlCreateFromPathA>
ENDIF

UrlCreateFromPathW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  UrlCreateFromPath equ <UrlCreateFromPathW>
ENDIF

UrlEscapeA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  UrlEscape equ <UrlEscapeA>
ENDIF

UrlEscapeW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  UrlEscape equ <UrlEscapeW>
ENDIF

UrlGetLocationA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  UrlGetLocation equ <UrlGetLocationA>
ENDIF

UrlGetLocationW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  UrlGetLocation equ <UrlGetLocationW>
ENDIF

UrlGetPartA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  UrlGetPart equ <UrlGetPartA>
ENDIF

UrlGetPartW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  UrlGetPart equ <UrlGetPartW>
ENDIF

UrlHashA PROTO STDCALL :DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  UrlHash equ <UrlHashA>
ENDIF

UrlHashW PROTO STDCALL :DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  UrlHash equ <UrlHashW>
ENDIF

UrlIsA PROTO STDCALL :DWORD,:DWORD
IFNDEF __UNICODE__
  UrlIs equ <UrlIsA>
ENDIF

UrlIsNoHistoryA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  UrlIsNoHistory equ <UrlIsNoHistoryA>
ENDIF

UrlIsNoHistoryW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  UrlIsNoHistory equ <UrlIsNoHistoryW>
ENDIF

UrlIsOpaqueA PROTO STDCALL :DWORD
IFNDEF __UNICODE__
  UrlIsOpaque equ <UrlIsOpaqueA>
ENDIF

UrlIsOpaqueW PROTO STDCALL :DWORD
IFDEF __UNICODE__
  UrlIsOpaque equ <UrlIsOpaqueW>
ENDIF

UrlIsW PROTO STDCALL :DWORD,:DWORD
IFDEF __UNICODE__
  UrlIs equ <UrlIsW>
ENDIF

UrlUnescapeA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  UrlUnescape equ <UrlUnescapeA>
ENDIF

UrlUnescapeW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  UrlUnescape equ <UrlUnescapeW>
ENDIF

wnsprintfA PROTO C :VARARG
IFNDEF __UNICODE__
  wnsprintf equ <wnsprintfA>
ENDIF

wnsprintfW PROTO C :VARARG
IFDEF __UNICODE__
  wnsprintf equ <wnsprintfW>
ENDIF

wvnsprintfA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  wvnsprintf equ <wvnsprintfA>
ENDIF

wvnsprintfW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  wvnsprintf equ <wvnsprintfW>
ENDIF

ELSE
  echo ------------------------------------------
  echo WARNING duplicate include file shlwapi.inc
  echo ------------------------------------------
ENDIF
