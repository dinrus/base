; --------------------------------------------------------------------------------------------------
;                           uniime.inc Copyright The MASM32 SDK 1998-2010
; --------------------------------------------------------------------------------------------------

IFNDEF UNIIME_INC
UNIIME_INC equ <1>

UniAttachMiniIME PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniCandWndProc PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniCompWndProc PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniContextMenuWndProc PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniDetachMiniIME PROTO STDCALL :DWORD,:DWORD
UniImeConfigure PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniImeConversionList PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniImeDestroy PROTO STDCALL :DWORD,:DWORD,:DWORD
UniImeEnumRegisterWord PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniImeEscape PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniImeGetRegisterWordStyle PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
UniImeInquire PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniImeProcessKey PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniImeRegisterWord PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniImeSelect PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
UniImeSetActiveContext PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
UniImeSetCompositionString PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniImeToAsciiEx PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniImeUnregisterWord PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniNotifyIME PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniOffCaretWndProc PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD

UniSearchPhrasePredictionA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFNDEF __UNICODE__
  UniSearchPhrasePrediction equ <UniSearchPhrasePredictionA>
ENDIF

UniSearchPhrasePredictionW PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IFDEF __UNICODE__
  UniSearchPhrasePrediction equ <UniSearchPhrasePredictionW>
ENDIF

UniStatusWndProc PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UniUIWndProc PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD

ELSE
  echo -----------------------------------------
  echo WARNING duplicate include file uniime.inc
  echo -----------------------------------------
ENDIF
