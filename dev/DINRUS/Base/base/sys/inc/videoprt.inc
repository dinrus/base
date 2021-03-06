; --------------------------------------------------------------------------------------------------
;                          videoprt.inc Copyright The MASM32 SDK 1998-2010
; --------------------------------------------------------------------------------------------------

IFNDEF VIDEOPRT_INC
VIDEOPRT_INC equ <1>

KeBugCheckEx PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
KeTickCount PROTO C :VARARG
VideoPortAcquireDeviceLock PROTO STDCALL :DWORD
VideoPortAcquireSpinLock PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortAcquireSpinLockAtDpcLevel PROTO STDCALL :DWORD,:DWORD
VideoPortAllocateBuffer PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortAllocateCommonBuffer PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortAllocateContiguousMemory PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortAllocatePool PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortAssociateEventsWithDmaHandle PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortCheckForDeviceExistance PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortCheckForDeviceExistence PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortClearEvent PROTO STDCALL :DWORD,:DWORD
VideoPortCompareMemory PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortCompleteDma PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortCreateEvent PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortCreateSecondaryDisplay PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortCreateSpinLock PROTO STDCALL :DWORD,:DWORD
VideoPortDDCMonitorHelper PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortDbgReportComplete PROTO STDCALL :DWORD
VideoPortDbgReportCreate PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortDbgReportSecondaryData PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortDebugPrint PROTO C :VARARG
VideoPortDeleteEvent PROTO STDCALL :DWORD,:DWORD
VideoPortDeleteSpinLock PROTO STDCALL :DWORD,:DWORD
VideoPortDisableInterrupt PROTO STDCALL :DWORD
VideoPortDoDma PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortEnableInterrupt PROTO STDCALL :DWORD
VideoPortEnumerateChildren PROTO STDCALL :DWORD,:DWORD
VideoPortFlushRegistry PROTO STDCALL :DWORD
VideoPortFreeCommonBuffer PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortFreeDeviceBase PROTO STDCALL :DWORD,:DWORD
VideoPortFreePool PROTO STDCALL :DWORD,:DWORD
VideoPortGetAccessRanges PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortGetAgpServices PROTO STDCALL :DWORD,:DWORD
VideoPortGetAssociatedDeviceExtension PROTO STDCALL :DWORD
VideoPortGetAssociatedDeviceID PROTO STDCALL :DWORD
VideoPortGetBusData PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortGetBytesUsed PROTO STDCALL :DWORD,:DWORD
VideoPortGetCommonBuffer PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortGetCurrentIrql PROTO STDCALL
VideoPortGetDeviceBase PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortGetDeviceData PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortGetDmaAdapter PROTO STDCALL :DWORD,:DWORD
VideoPortGetDmaContext PROTO STDCALL :DWORD,:DWORD
VideoPortGetMdl PROTO STDCALL :DWORD,:DWORD
VideoPortGetRegistryParameters PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortGetRomImage PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortGetVersion PROTO STDCALL :DWORD,:DWORD
VideoPortGetVgaStatus PROTO STDCALL :DWORD,:DWORD
VideoPortInitialize PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortInt10 PROTO STDCALL :DWORD,:DWORD
VideoPortLockBuffer PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortLockPages PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortLogError PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortMapBankedMemory PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortMapDmaMemory PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortMapMemory PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortMoveMemory PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortPutDmaAdapter PROTO STDCALL :DWORD,:DWORD
VideoPortQueryPerformanceCounter PROTO STDCALL :DWORD,:DWORD
VideoPortQueryServices PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortQuerySystemTime PROTO STDCALL :DWORD
VideoPortQueueDpc PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortReadPortBufferUchar PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortReadPortBufferUlong PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortReadPortBufferUshort PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortReadPortUchar PROTO STDCALL :DWORD
VideoPortReadPortUlong PROTO STDCALL :DWORD
VideoPortReadPortUshort PROTO STDCALL :DWORD
VideoPortReadRegisterBufferUchar PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortReadRegisterBufferUlong PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortReadRegisterBufferUshort PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortReadRegisterUchar PROTO STDCALL :DWORD
VideoPortReadRegisterUlong PROTO STDCALL :DWORD
VideoPortReadRegisterUshort PROTO STDCALL :DWORD
VideoPortReadStateEvent PROTO STDCALL :DWORD,:DWORD
VideoPortRegisterBugcheckCallback PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortReleaseBuffer PROTO STDCALL :DWORD,:DWORD
VideoPortReleaseCommonBuffer PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortReleaseDeviceLock PROTO STDCALL :DWORD
VideoPortReleaseSpinLock PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortReleaseSpinLockFromDpcLevel PROTO STDCALL :DWORD,:DWORD
VideoPortScanRom PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortSetBusData PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortSetBytesUsed PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortSetDmaContext PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortSetEvent PROTO STDCALL :DWORD,:DWORD
VideoPortSetRegistryParameters PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortSetTrappedEmulatorPorts PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortSignalDmaComplete PROTO STDCALL :DWORD,:DWORD
VideoPortStallExecution PROTO STDCALL :DWORD
VideoPortStartDma PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VideoPortStartTimer PROTO STDCALL :DWORD
VideoPortStopTimer PROTO STDCALL :DWORD
VideoPortSynchronizeExecution PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortUnlockBuffer PROTO STDCALL :DWORD,:DWORD
VideoPortUnlockPages PROTO STDCALL :DWORD,:DWORD
VideoPortUnmapDmaMemory PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
VideoPortUnmapMemory PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortVerifyAccessRanges PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortWaitForSingleObject PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortWritePortBufferUchar PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortWritePortBufferUlong PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortWritePortBufferUshort PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortWritePortUchar PROTO STDCALL :DWORD,:DWORD
VideoPortWritePortUlong PROTO STDCALL :DWORD,:DWORD
VideoPortWritePortUshort PROTO STDCALL :DWORD,:DWORD
VideoPortWriteRegisterBufferUchar PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortWriteRegisterBufferUlong PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortWriteRegisterBufferUshort PROTO STDCALL :DWORD,:DWORD,:DWORD
VideoPortWriteRegisterUchar PROTO STDCALL :DWORD,:DWORD
VideoPortWriteRegisterUlong PROTO STDCALL :DWORD,:DWORD
VideoPortWriteRegisterUshort PROTO STDCALL :DWORD,:DWORD
VideoPortZeroDeviceMemory PROTO STDCALL :DWORD,:DWORD
VideoPortZeroMemory PROTO STDCALL :DWORD,:DWORD
VpNotifyEaData PROTO STDCALL :DWORD,:DWORD

ELSE
  echo -------------------------------------------
  echo WARNING duplicate include file videoprt.inc
  echo -------------------------------------------
ENDIF
