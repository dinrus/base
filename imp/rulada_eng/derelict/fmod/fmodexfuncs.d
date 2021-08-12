/*

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*/
module derelict.fmod.fmodexfuncs;

private
{
    import derelict.util.compat;
    import derelict.fmod.fmodextypes;
}

extern(C)
{
    FMOD_RESULT function(void*, int, FMOD_MEMORY_ALLOCCALLBACK, FMOD_MEMORY_REALLOCALLBACK, FMOD_MEMORY_FREECALLBACK, FMOD_MEMORY_TYPE) FMOD_Memory_Initialize;
    FMOD_RESULT function(int*, int*, FMOD_BOOL) FMOD_Memory_GetStats;
    FMOD_RESULT function(FMOD_DEBUGLEVEL) FMOD_Debug_SetLevel;
    FMOD_RESULT function(FMOD_DEBUGLEVEL*) FMOD_Debug_GetLevel;
    FMOD_RESULT function(int) FMOD_File_SetDiskBusy;
    FMOD_RESULT function(int*) FMOD_File_GetDiskBusy;

    FMOD_RESULT function(FMOD_SYSTEM**) FMOD_System_Create;
    FMOD_RESULT function(FMOD_SYSTEM**) FMOD_System_Release;

    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_OUTPUTTYPE) FMOD_System_SetOutput;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_OUTPUTTYPE*) FMOD_System_GetOutput;
    FMOD_RESULT function(FMOD_SYSTEM*, int*) FMOD_System_GetNumDrivers;
    FMOD_RESULT function(FMOD_SYSTEM*, int, char*, int, FMOD_GUID*) FMOD_System_GetDriverInfo;
    FMOD_RESULT function(FMOD_SYSTEM*, int, short*, int, FMOD_GUID*) FMOD_System_GetDriverInfoW;
    FMOD_RESULT function(FMOD_SYSTEM*, int, FMOD_CAPS*, int*, int*, FMOD_SPEAKERMODE*) FMOD_System_GetDriverCaps;
    FMOD_RESULT function(FMOD_SYSTEM*, int) FMOD_System_SetDriver;
    FMOD_RESULT function(FMOD_SYSTEM*, int*) FMOD_System_GetDriver;
    FMOD_RESULT function(FMOD_SYSTEM*, int, int, int, int) FMOD_System_SetHardwareChannels;
    FMOD_RESULT function(FMOD_SYSTEM*, int) FMOD_System_SetSoftwareChannels;
    FMOD_RESULT function(FMOD_SYSTEM*, int*) FMOD_System_GetSoftwareChannels;
    FMOD_RESULT function(FMOD_SYSTEM*, int, FMOD_SOUND_FORMAT, int, int, FMOD_DSP_RESAMPLER) FMOD_System_SetSoftwareFormat;
    FMOD_RESULT function(FMOD_SYSTEM*, int*, FMOD_SOUND_FORMAT*, int*, int*, FMOD_DSP_RESAMPLER*, int*) FMOD_System_GetSoftwareFormat;
    FMOD_RESULT function(FMOD_SYSTEM*, uint, int) FMOD_System_SetDSPBufferSize;
    FMOD_RESULT function(FMOD_SYSTEM*, uint*, int*) FMOD_System_GetDSPBufferSize;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_FILE_OPENCALLBACK, FMOD_FILE_CLOSECALLBACK, FMOD_FILE_READCALLBACK, FMOD_FILE_SEEKCALLBACK, int) FMOD_System_SetFileSystem;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_FILE_OPENCALLBACK, FMOD_FILE_CLOSECALLBACK, FMOD_FILE_READCALLBACK, FMOD_FILE_SEEKCALLBACK) FMOD_System_AttachFileSystem;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_ADVANCEDSETTINGS*) FMOD_System_SetAdvancedSettings;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_ADVANCEDSETTINGS*) FMOD_System_GetAdvancedSettings;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_SPEAKERMODE) FMOD_System_SetSpeakerMode;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_SPEAKERMODE*) FMOD_System_GetSpeakerMode;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_SYSTEM_CALLBACK) FMOD_System_SetCallback;

    FMOD_RESULT function(FMOD_SYSTEM*, CCPTR) FMOD_System_SetPluginPath;
    FMOD_RESULT function(FMOD_SYSTEM*, CCPTR, uint*, uint) FMOD_System_LoadPlugin;
    FMOD_RESULT function(FMOD_SYSTEM*, uint) FMOD_System_UnloadPlugin;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_PLUGINTYPE, int*) FMOD_System_GetNumPlugins;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_PLUGINTYPE, int, uint*) FMOD_System_GetPluginHandle;
    FMOD_RESULT function(FMOD_SYSTEM*, uint, FMOD_PLUGINTYPE*, char*, int, uint*) FMOD_System_GetPluginInfo;
    FMOD_RESULT function(FMOD_SYSTEM*, uint) FMOD_System_SetOutputByPlugin;
    FMOD_RESULT function(FMOD_SYSTEM*, uint*) FMOD_System_GetOutputByPlugin;
    FMOD_RESULT function(FMOD_SYSTEM*, uint, FMOD_DSP*) FMOD_System_CreateDSPByPlugin;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_CODEC_DESCRIPTION*, uint) FMOD_System_CreateCodec;

    FMOD_RESULT function(FMOD_SYSTEM*, int, FMOD_INITFLAGS, void*) FMOD_System_Init;
    FMOD_RESULT function(FMOD_SYSTEM*) FMOD_System_Close;

    FMOD_RESULT function(FMOD_SYSTEM*) FMOD_System_Update;

    FMOD_RESULT function(FMOD_SYSTEM*, float, float, float) FMOD_System_Set3DSettings;
    FMOD_RESULT function(FMOD_SYSTEM*, float*, float*, float*) FMOD_System_Get3DSettings;
    FMOD_RESULT function(FMOD_SYSTEM*, int) FMOD_System_Set3DNumListeners;
    FMOD_RESULT function(FMOD_SYSTEM*, int*) FMOD_System_Get3DNumListeners;
    FMOD_RESULT function(FMOD_SYSTEM*, int, in FMOD_VECTOR*, in FMOD_VECTOR*, in FMOD_VECTOR*, in FMOD_VECTOR*) FMOD_System_Set3DListenerAttributes;
    FMOD_RESULT function(FMOD_SYSTEM*, int, FMOD_VECTOR*, FMOD_VECTOR*, FMOD_VECTOR*, FMOD_VECTOR*) FMOD_System_Get3DListenerAttributes;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_3D_ROLLOFFCALLBACK) FMOD_System_Set3DRolloffCallback;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_SPEAKER, float, float, FMOD_BOOL) FMOD_System_Set3DSpeakerPosition;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_SPEAKER, float*, float*, FMOD_BOOL*) FMOD_System_Get3DSpeakerPosition;

    FMOD_RESULT function(FMOD_SYSTEM*, uint, FMOD_TIMEUNIT) FMOD_System_SetStreamBufferSize;
    FMOD_RESULT function(FMOD_SYSTEM*, uint*, FMOD_TIMEUNIT*) FMOD_System_GetStreamBufferSize;

    FMOD_RESULT function(FMOD_SYSTEM*, uint*) FMOD_System_GetVersion;
    FMOD_RESULT function(FMOD_SYSTEM*, void**) FMOD_System_GetOutputHandle;
    FMOD_RESULT function(FMOD_SYSTEM*, int*) FMOD_System_GetChannelsPlaying;
    FMOD_RESULT function(FMOD_SYSTEM*, int*, int*, int*) FMOD_System_GetHardwareChannels;
    FMOD_RESULT function(FMOD_SYSTEM*, float*, float*, float*, float*, float*) FMOD_System_GetCPUUsage;
    FMOD_RESULT function(FMOD_SYSTEM*, int*, int*, int*) FMOD_System_GetSoundRAM;
    FMOD_RESULT function(FMOD_SYSTEM*, int*) FMOD_System_GetNumCDROMDrives;
    FMOD_RESULT function(FMOD_SYSTEM*, int, char*, int, char*, int, char*, int) FMOD_System_GetCDROMDriveName;
    FMOD_RESULT function(FMOD_SYSTEM*, float*, int, int, FMOD_DSP_FFT_WINDOW) FMOD_System_GetSpectrum;
    FMOD_RESULT function(FMOD_SYSTEM*, float*, int, int) FMOD_System_GetWaveData;

    FMOD_RESULT function(FMOD_SYSTEM*, CCPTR, FMOD_MODE, FMOD_CREATESOUNDEXINFO*, FMOD_SOUND**) FMOD_System_CreateSound;
    FMOD_RESULT function(FMOD_SYSTEM*, CCPTR, FMOD_MODE, FMOD_CREATESOUNDEXINFO*, FMOD_SOUND**) FMOD_System_CreateStream;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_DSP_DESCRIPTION*, FMOD_DSP**) FMOD_System_CreateDSP;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_DSP_TYPE, FMOD_DSP**) FMOD_System_CreateDSPByType;
    FMOD_RESULT function(FMOD_SYSTEM*, CCPTR, FMOD_CHANNELGROUP**) FMOD_System_CreateChannelGroup;
    FMOD_RESULT function(FMOD_SYSTEM*, CCPTR, FMOD_SOUNDGROUP**) FMOD_System_CreateSoundGroup;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_REVERB**) FMOD_System_CreateReverb;

    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_CHANNELINDEX, FMOD_SOUND*, FMOD_BOOL, FMOD_CHANNEL**) FMOD_System_PlaySound;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_CHANNELINDEX, FMOD_DSP*, FMOD_BOOL, FMOD_CHANNEL**) FMOD_System_PlayDSP;
    FMOD_RESULT function(FMOD_SYSTEM*, int, FMOD_CHANNEL**) FMOD_System_GetChannel;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_CHANNELGROUP**) FMOD_System_GetMasterChannelGroup;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_SOUNDGROUP**) FMOD_System_GetMasterSoundGroup;

    FMOD_RESULT function(FMOD_SYSTEM*, in FMOD_REVERB_PROPERTIES*) FMOD_System_SetReverbProperties;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_REVERB_PROPERTIES*) FMOD_System_GetReverbProperties;
    FMOD_RESULT function(FMOD_SYSTEM*, in FMOD_REVERB_PROPERTIES*) FMOD_System_SetReverbAmbientProperties;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_REVERB_PROPERTIES*) FMOD_System_GetReverbAmbientProperties;

    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_DSP*) FMOD_System_GetDSPHead;
    FMOD_RESULT function(FMOD_SYSTEM*, FMOD_DSP*, FMOD_DSPCONNECTION**) FMOD_System_AddDSP;
    FMOD_RESULT function(FMOD_SYSTEM*) FMOD_System_LockDSP;
    FMOD_RESULT function(FMOD_SYSTEM*) FMOD_System_UnlockDSP;
    FMOD_RESULT function(FMOD_SYSTEM*, uint*, uint*) FMOD_System_GetDSPClock;

    FMOD_RESULT function(FMOD_SYSTEM*, int*) FMOD_System_GetRecordNumDrivers;
    FMOD_RESULT function(FMOD_SYSTEM*, int, char*, int, FMOD_GUID*) FMOD_System_GetRecordDriverInfo;
    FMOD_RESULT function(FMOD_SYSTEM*, int, short*, int, FMOD_GUID*) FMOD_System_GetRecordDriverInfoW;
    FMOD_RESULT function(FMOD_SYSTEM*, int, FMOD_CAPS*, int*, int*) FMOD_System_GetRecordDriverCaps;
    FMOD_RESULT function(FMOD_SYSTEM*, int, uint*) FMOD_System_GetRecordPosition;

    FMOD_RESULT function(FMOD_SYSTEM*, int, FMOD_SOUND*, FMOD_BOOL) FMOD_System_RecordStart;
    FMOD_RESULT function(FMOD_SYSTEM*, int) FMOD_System_RecordStop;
    FMOD_RESULT function(FMOD_SYSTEM*, int, FMOD_BOOL*) FMOD_System_IsRecording;

    FMOD_RESULT function(FMOD_SYSTEM*, int, int, FMOD_GEOMETRY**) FMOD_System_CreateGeometry;
    FMOD_RESULT function(FMOD_SYSTEM*, float) FMOD_System_SetGeometrySettings;
    FMOD_RESULT function(FMOD_SYSTEM*, float*) FMOD_System_GetGeometrySettings;
    FMOD_RESULT function(FMOD_SYSTEM*, in void*, int, FMOD_GEOMETRY**) FMOD_System_LoadGeometry;
    FMOD_RESULT function(FMOD_SYSTEM*, in FMOD_VECTOR*, in FMOD_VECTOR*, float*, float*) FMOD_System_GetGeometryOcclusion;

    FMOD_RESULT function(FMOD_SYSTEM*, CCPTR) FMOD_System_SetNetworkProxy;
    FMOD_RESULT function(FMOD_SYSTEM*, char*, int) FMOD_System_GetNetworkProxy;
    FMOD_RESULT function(FMOD_SYSTEM*, int) FMOD_System_SetNetworkTimeout;
    FMOD_RESULT function(FMOD_SYSTEM*, int*) FMOD_System_GetNetworkTimeout;

    FMOD_RESULT function(FMOD_SYSTEM*, void*) FMOD_System_SetUserData;
    FMOD_RESULT function(FMOD_SYSTEM*, void**) FMOD_System_GetUserData;

    FMOD_RESULT function(FMOD_SYSTEM*, uint, uint, uint*, FMOD_MEMORY_USAGE_DETAILS*) FMOD_System_GetMemoryInfo;

    FMOD_RESULT function(FMOD_SOUND*) FMOD_Sound_Release;
    FMOD_RESULT function(FMOD_SOUND*, FMOD_SYSTEM*) FMOD_Sound_GetSystemObject;

    FMOD_RESULT function(FMOD_SOUND*, uint, uint, void**, void**, uint*, uint*) FMOD_Sound_Lock;
    FMOD_RESULT function(FMOD_SOUND*, void*, void*, uint, uint) FMOD_Sound_Unlock;
    FMOD_RESULT function(FMOD_SOUND*, float, float, float, int) FMOD_Sound_SetDefaults;
    FMOD_RESULT function(FMOD_SOUND*, float*, float*, float*, int*) FMOD_Sound_GetDefaults;
    FMOD_RESULT function(FMOD_SOUND*, float, float, float) FMOD_Sound_SetVariations;
    FMOD_RESULT function(FMOD_SOUND*, float*, float*, float*) FMOD_Sound_GetVariations;
    FMOD_RESULT function(FMOD_SOUND*, float, float) FMOD_Sound_Set3DMinMaxDistance;
    FMOD_RESULT function(FMOD_SOUND*, float*, float*) FMOD_Sound_Get3DMinMaxDistance;
    FMOD_RESULT function(FMOD_SOUND*, float, float, float) FMOD_Sound_Set3DConeSettings;
    FMOD_RESULT function(FMOD_SOUND*, float*, float*, float*) FMOD_Sound_Get3DConeSettings;
    FMOD_RESULT function(FMOD_SOUND*, FMOD_VECTOR*, int) FMOD_Sound_Set3DCustomRolloff;
    FMOD_RESULT function(FMOD_SOUND*, FMOD_VECTOR**, int*) FMOD_Sound_Get3DCustomRolloff;
    FMOD_RESULT function(FMOD_SOUND*, int, FMOD_SOUND*) FMOD_Sound_SetSubSound;
    FMOD_RESULT function(FMOD_SOUND*, int, FMOD_SOUND**) FMOD_Sound_GetSubSound;
    FMOD_RESULT function(FMOD_SOUND*, int*, int) FMOD_Sound_SetSubSoundSentence;
    FMOD_RESULT function(FMOD_SOUND*, char*, int) FMOD_Sound_GetName;
    FMOD_RESULT function(FMOD_SOUND*, uint*, FMOD_TIMEUNIT) FMOD_Sound_GetLength;
    FMOD_RESULT function(FMOD_SOUND*, FMOD_SOUND_TYPE*, FMOD_SOUND_FORMAT*, int*, int*) FMOD_Sound_GetFormat;
    FMOD_RESULT function(FMOD_SOUND*, int*) FMOD_Sound_GetNumSubSounds;
    FMOD_RESULT function(FMOD_SOUND*, int*, int*) FMOD_Sound_GetNumTags;
    FMOD_RESULT function(FMOD_SOUND*, CCPTR, int, FMOD_TAG*) FMOD_Sound_GetTag;
    FMOD_RESULT function(FMOD_SOUND*, FMOD_OPENSTATE*, uint*, FMOD_BOOL*) FMOD_Sound_GetOpenState;
    FMOD_RESULT function(FMOD_SOUND*, void*, uint, uint) FMOD_Sound_ReadData;
    FMOD_RESULT function(FMOD_SOUND*, uint) FMOD_Sound_SeekData;

    FMOD_RESULT function(FMOD_SOUND*, FMOD_SOUNDGROUP*) FMOD_Sound_SetSoundGroup;
    FMOD_RESULT function(FMOD_SOUND*, FMOD_SOUNDGROUP**) FMOD_Sound_GetSoundGroup;

    FMOD_RESULT function(FMOD_SOUND*, int*) FMOD_Sound_GetNumSyncPoints;
    FMOD_RESULT function(FMOD_SOUND*, int, FMOD_SYNCPOINT**) FMOD_Sound_GetSyncPoint;
    FMOD_RESULT function(FMOD_SOUND*, FMOD_SYNCPOINT*, char*, int, uint*, FMOD_TIMEUNIT) FMOD_Sound_GetSyncPointInfo;
    FMOD_RESULT function(FMOD_SOUND*, uint, FMOD_TIMEUNIT, CCPTR, FMOD_SYNCPOINT*) FMOD_Sound_AddSyncPoint;
    FMOD_RESULT function(FMOD_SOUND*, FMOD_SYNCPOINT*) FMOD_Sound_DeleteSyncPoint;

    FMOD_RESULT function(FMOD_SOUND*, FMOD_MODE) FMOD_Sound_SetMode;
    FMOD_RESULT function(FMOD_SOUND*, FMOD_MODE*) FMOD_Sound_GetMode;
    FMOD_RESULT function(FMOD_SOUND*, int) FMOD_Sound_SetLoopCount;
    FMOD_RESULT function(FMOD_SOUND*, int*) FMOD_Sound_GetLoopCount;
    FMOD_RESULT function(FMOD_SOUND*, uint, FMOD_TIMEUNIT, uint, FMOD_TIMEUNIT) FMOD_Sound_SetLoopPoints;
    FMOD_RESULT function(FMOD_SOUND*, uint*, FMOD_TIMEUNIT, uint*, FMOD_TIMEUNIT) FMOD_Sound_GetLoopPoints;

    FMOD_RESULT function(FMOD_SOUND*, void*) FMOD_Sound_SetUserData;
    FMOD_RESULT function(FMOD_SOUND*, void**) FMOD_Sound_GetUserData;

    FMOD_RESULT function(FMOD_SOUND*, uint, uint, uint*, FMOD_MEMORY_USAGE_DETAILS*) FMOD_Sound_GetMemoryInfo;

    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_SYSTEM**) FMOD_Channel_GetSystemObject;
    FMOD_RESULT function(FMOD_CHANNEL*) FMOD_Channel_Stop;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_BOOL) FMOD_Channel_SetPaused;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_BOOL*) FMOD_Channel_GetPaused;
    FMOD_RESULT function(FMOD_CHANNEL*, float) FMOD_Channel_SetVolume;
    FMOD_RESULT function(FMOD_CHANNEL*, float*) FMOD_Channel_GetVolume;
    FMOD_RESULT function(FMOD_CHANNEL*, float) FMOD_Channel_SetFrequency;
    FMOD_RESULT function(FMOD_CHANNEL*, float*) FMOD_Channel_GetFrequency;
    FMOD_RESULT function(FMOD_CHANNEL*, float) FMOD_Channel_SetPan;
    FMOD_RESULT function(FMOD_CHANNEL*, float*) FMOD_Channel_GetPan;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_DELAYTYPE, uint, uint) FMOD_Channel_SetDelay;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_DELAYTYPE, uint*, uint*) FMOD_Channel_GetDelay;
    FMOD_RESULT function(FMOD_CHANNEL*, float, float, float, float, float, float, float, float) FMOD_Channel_SetSpeakerMix;
    FMOD_RESULT function(FMOD_CHANNEL*, float*, float*, float*, float*, float*, float*, float*, float*) FMOD_Channel_GetSpeakerMix;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_SPEAKER, float*, int) FMOD_Channel_SetSpeakerLevels;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_SPEAKER, float*, int) FMOD_Channel_GetSpeakerLevels;
    FMOD_RESULT function(FMOD_CHANNEL*, float*, int) FMOD_Channel_SetInputChannelMix;
    FMOD_RESULT function(FMOD_CHANNEL*, float*, int) FMOD_Channel_GetInputChannelMix;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_BOOL) FMOD_Channel_SetMute;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_BOOL*) FMOD_Channel_GetMute;
    FMOD_RESULT function(FMOD_CHANNEL*, int) FMOD_Channel_SetPriority;
    FMOD_RESULT function(FMOD_CHANNEL*, int*) FMOD_Channel_GetPriority;
    FMOD_RESULT function(FMOD_CHANNEL*, uint, FMOD_TIMEUNIT) FMOD_Channel_SetPosition;
    FMOD_RESULT function(FMOD_CHANNEL*, uint*, FMOD_TIMEUNIT) FMOD_Channel_GetPosition;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_REVERB_CHANNELPROPERTIES*) FMOD_Channel_SetReverbProperties;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_REVERB_CHANNELPROPERTIES*) FMOD_Channel_GetReverbProperties;
    FMOD_RESULT function(FMOD_CHANNEL*, float) FMOD_Channel_SetLowPassGain;
    FMOD_RESULT function(FMOD_CHANNEL*, float*) FMOD_Channel_GetLowPassGain;

    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_CHANNELGROUP*) FMOD_Channel_SetChannelGroup;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_CHANNELGROUP**) FMOD_Channel_GetChannelGroup;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_CHANNEL_CALLBACK) FMOD_Channel_SetCallback;

    FMOD_RESULT function(FMOD_CHANNEL*, in FMOD_VECTOR*, in FMOD_VECTOR*) FMOD_Channel_Set3DAttributes;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_VECTOR*, FMOD_VECTOR*) FMOD_Channel_Get3DAttributes;
    FMOD_RESULT function(FMOD_CHANNEL*, float, float) FMOD_Channel_Set3DMinMaxDistance;
    FMOD_RESULT function(FMOD_CHANNEL*, float*, float*) FMOD_Channel_Get3DMinMaxDistance;
    FMOD_RESULT function(FMOD_CHANNEL*, float, float, float) FMOD_Channel_Set3DConeSettings;
    FMOD_RESULT function(FMOD_CHANNEL*, float*, float*, float*) FMOD_Channel_Get3DConeSettings;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_VECTOR*) FMOD_Channel_Set3DConeOrientation;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_VECTOR*) FMOD_Channel_Get3DConeOrientation;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_VECTOR*, int) FMOD_Channel_Set3DCustomRolloff;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_VECTOR*, int*) FMOD_Channel_Get3DCustomRolloff;
    FMOD_RESULT function(FMOD_CHANNEL*, float, float) FMOD_Channel_Set3DOcclusion;
    FMOD_RESULT function(FMOD_CHANNEL*, float*, float*) FMOD_Channel_Get3DOcclusion;
    FMOD_RESULT function(FMOD_CHANNEL*, float) FMOD_Channel_Set3DSpread;
    FMOD_RESULT function(FMOD_CHANNEL*, float*) FMOD_Channel_Get3DSpread;
    FMOD_RESULT function(FMOD_CHANNEL*, float) FMOD_Channel_Set3DPanLevel;
    FMOD_RESULT function(FMOD_CHANNEL*, float*) FMOD_Channel_Get3DPanLevel;
    FMOD_RESULT function(FMOD_CHANNEL*, float) FMOD_Channel_Set3DDopplerLevel;
    FMOD_RESULT function(FMOD_CHANNEL*, float*) FMOD_Channel_Get3DDopplerLevel;

    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_DSP**) FMOD_Channel_GetDSPHead;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_DSP*, FMOD_DSPCONNECTION**) FMOD_Channel_AddDSP;

    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_BOOL*) FMOD_Channel_IsPlaying;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_BOOL*) FMOD_Channel_IsVirtual;
    FMOD_RESULT function(FMOD_CHANNEL*, float*) FMOD_Channel_GetAudibility;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_SOUND**) FMOD_Channel_GetCurrentSound;
    FMOD_RESULT function(FMOD_CHANNEL*, float*, int, int, FMOD_DSP_FFT_WINDOW) FMOD_Channel_GetSpectrum;
    FMOD_RESULT function(FMOD_CHANNEL*, float*, int, int) FMOD_Channel_GetWaveData;
    FMOD_RESULT function(FMOD_CHANNEL*, int*) FMOD_Channel_GetIndex;

    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_MODE) FMOD_Channel_SetMode;
    FMOD_RESULT function(FMOD_CHANNEL*, FMOD_MODE*) FMOD_Channel_GetMode;
    FMOD_RESULT function(FMOD_CHANNEL*, int) FMOD_Channel_SetLoopCount;
    FMOD_RESULT function(FMOD_CHANNEL*, int*) FMOD_Channel_GetLoopCount;
    FMOD_RESULT function(FMOD_CHANNEL*, uint, FMOD_TIMEUNIT, uint, FMOD_TIMEUNIT) FMOD_Channel_SetLoopPoints;
    FMOD_RESULT function(FMOD_CHANNEL*, uint*, FMOD_TIMEUNIT, uint*, FMOD_TIMEUNIT) FMOD_Channel_GetLoopPoints;

    FMOD_RESULT function(FMOD_CHANNEL*, void*) FMOD_Channel_SetUserData;
    FMOD_RESULT function(FMOD_CHANNEL*, void**) FMOD_Channel_GetUserData;
    FMOD_RESULT function(FMOD_CHANNEL*, uint, uint, uint*, FMOD_MEMORY_USAGE_DETAILS*) FMOD_Channel_GetMemoryInfo;

    FMOD_RESULT function(FMOD_CHANNELGROUP*) FMOD_ChannelGroup_Release;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, FMOD_SYSTEM*) FMOD_ChannelGroup_GetSystemObject;

    FMOD_RESULT function(FMOD_CHANNELGROUP*, float) FMOD_ChannelGroup_SetVolume;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, float*) FMOD_ChannelGroup_GetVolume;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, float) FMOD_ChannelGroup_SetPitch;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, float*) FMOD_ChannelGroup_GetPitch;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, float, float) FMOD_ChannelGroup_Set3DOcclusion;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, float*, float*) FMOD_ChannelGroup_Get3DOcclusion;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, FMOD_BOOL) FMOD_ChannelGroup_SetPaused;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, FMOD_BOOL*) FMOD_ChannelGroup_GetPaused;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, FMOD_BOOL) FMOD_ChannelGroup_SetMute;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, FMOD_BOOL*) FMOD_ChannelGroup_GetMute;

    FMOD_RESULT function(FMOD_CHANNELGROUP*) FMOD_ChannelGroup_Stop;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, float) FMOD_ChannelGroup_OverrideVolume;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, float) FMOD_ChannelGroup_OverrideFrequency;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, float) FMOD_ChannelGroup_OverridePan;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, in FMOD_REVERB_PROPERTIES*) FMOD_ChannelGroup_OverrideReverbProperties;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, in FMOD_VECTOR*, in FMOD_VECTOR*) FMOD_ChannelGroup_Override3DAttributes;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, float, float, float, float, float, float, float, float) FMOD_ChannelGroup_OverrideSpeakerMix;

    FMOD_RESULT function(FMOD_CHANNELGROUP*, FMOD_CHANNELGROUP*) FMOD_ChannelGroup_AddGroup;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, int*) FMOD_ChannelGroup_GetNumGroups;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, int, FMOD_CHANNELGROUP**) FMOD_ChannelGroup_GetGroup;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, FMOD_CHANNELGROUP**) FMOD_ChannelGroup_GetParentGroup;

    FMOD_RESULT function(FMOD_CHANNELGROUP*, FMOD_DSP**) FMOD_ChannelGroup_GetDSPHead;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, FMOD_DSP*, FMOD_DSPCONNECTION**) FMOD_ChannelGroup_AddDSP;

    FMOD_RESULT function(FMOD_CHANNELGROUP*, char*, int) FMOD_ChannelGroup_GetName;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, int*) FMOD_ChannelGroup_GetNumChannels;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, int, FMOD_CHANNEL**) FMOD_ChannelGroup_GetChannel;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, float*, int, int, FMOD_DSP_FFT_WINDOW) FMOD_ChannelGroup_GetSpectrum;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, float*, int, int) FMOD_ChannelGroup_GetWaveData;

    FMOD_RESULT function(FMOD_CHANNELGROUP*, void*) FMOD_ChannelGroup_SetUserData;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, void**) FMOD_ChannelGroup_GetUserData;
    FMOD_RESULT function(FMOD_CHANNELGROUP*, uint, uint, uint*, FMOD_MEMORY_USAGE_DETAILS) FMOD_ChannelGroup_GetMemoryInfo;

    FMOD_RESULT function(FMOD_SOUNDGROUP*) FMOD_SoundGroup_Release;
    FMOD_RESULT function(FMOD_SOUNDGROUP*, FMOD_SYSTEM**) FMOD_SoundGroup_GetSystemObject;

    FMOD_RESULT function(FMOD_SOUNDGROUP*, int) FMOD_SoundGroup_SetMaxAudible;
    FMOD_RESULT function(FMOD_SOUNDGROUP*, int*) FMOD_SoundGroup_GetMaxAudible;
    FMOD_RESULT function(FMOD_SOUNDGROUP*, FMOD_SOUNDGROUP_BEHAVIOR) FMOD_SoundGroup_SetMaxAudibleBehavior;
    FMOD_RESULT function(FMOD_SOUNDGROUP*, FMOD_SOUNDGROUP_BEHAVIOR*) FMOD_SoundGroup_GetMaxAudibleBehavior;
    FMOD_RESULT function(FMOD_SOUNDGROUP*, float) FMOD_SoundGroup_SetMuteFadeSpeed;
    FMOD_RESULT function(FMOD_SOUNDGROUP*, float*) FMOD_SoundGroup_GetMuteFadeSpeed;
    FMOD_RESULT function(FMOD_SOUNDGROUP*, float) FMOD_SoundGroup_SetVolume;
    FMOD_RESULT function(FMOD_SOUNDGROUP*, float*) FMOD_SoundGroup_GetVolume;
    FMOD_RESULT function(FMOD_SOUNDGROUP*) FMOD_SoundGroup_Stop;

    FMOD_RESULT function(FMOD_SOUNDGROUP*, char*, int) FMOD_SoundGroup_GetName;
    FMOD_RESULT function(FMOD_SOUNDGROUP*, int*) FMOD_SoundGroup_GetNumSounds;
    FMOD_RESULT function(FMOD_SOUNDGROUP*, int, FMOD_SOUND**) FMOD_SoundGroup_GetSound;
    FMOD_RESULT function(FMOD_SOUNDGROUP*, int*) FMOD_SoundGroup_GetNumPlaying;

    FMOD_RESULT function(FMOD_SOUNDGROUP*, void*) FMOD_SoundGroup_GetUserData;
    FMOD_RESULT function(FMOD_SOUNDGROUP*, void**) FMOD_SoundGroup_SetUserData;
    FMOD_RESULT function(FMOD_SOUNDGROUP*, uint, uint, uint*, FMOD_MEMORY_USAGE_DETAILS*) FMOD_SoundGroup_GetMemoryInfo;

    FMOD_RESULT function(FMOD_DSP*) FMOD_DSP_Release;
    FMOD_RESULT function(FMOD_DSP*, FMOD_SYSTEM**) FMOD_DSP_GetSystemObject;

    FMOD_RESULT function(FMOD_DSP*, FMOD_DSP*, FMOD_DSPCONNECTION) FMOD_DSP_AddInput;
    FMOD_RESULT function(FMOD_DSP*, FMOD_DSP*) FMOD_DSP_DisconnectFrom;
    FMOD_RESULT function(FMOD_DSP*, FMOD_BOOL, FMOD_BOOL) FMOD_DSP_DisconnectAll;
    FMOD_RESULT function(FMOD_DSP*) FMOD_DSP_Remove;
    FMOD_RESULT function(FMOD_DSP*, int*) FMOD_DSP_GetNumInputs;
    FMOD_RESULT function(FMOD_DSP*, int*) FMOD_DSP_GetNumOutputs;
    FMOD_RESULT function(FMOD_DSP*, int, FMOD_DSP**, FMOD_DSPCONNECTION**) FMOD_DSP_GetInput;
    FMOD_RESULT function(FMOD_DSP*, int, FMOD_DSP**, FMOD_DSPCONNECTION**) FMOD_DSP_GetOutput;

    FMOD_RESULT function(FMOD_DSP*, FMOD_BOOL) FMOD_DSP_SetActive;
    FMOD_RESULT function(FMOD_DSP*, FMOD_BOOL*) FMOD_DSP_GetActive;
    FMOD_RESULT function(FMOD_DSP*, FMOD_BOOL) FMOD_DSP_SetBypass;
    FMOD_RESULT function(FMOD_DSP*, FMOD_BOOL*) FMOD_DSP_GetBypass;
    FMOD_RESULT function(FMOD_DSP*, FMOD_SPEAKER, FMOD_BOOL) FMOD_DSP_SetSpeakerActive;
    FMOD_RESULT function(FMOD_DSP*, FMOD_SPEAKER, FMOD_BOOL*) FMOD_DSP_GetSpeakerActive;
    FMOD_RESULT function(FMOD_DSP*) FMOD_DSP_Reset;

    FMOD_RESULT function(FMOD_DSP*, int, float) FMOD_DSP_SetParameter;
    FMOD_RESULT function(FMOD_DSP*, int, float*, char*, int) FMOD_DSP_GetParameter;
    FMOD_RESULT function(FMOD_DSP*, int*) FMOD_DSP_GetNumParameters;
    FMOD_RESULT function(FMOD_DSP*, int, char*, char*, char*, int, float*, float*) FMOD_DSP_GetParameterInfo;
    FMOD_RESULT function(FMOD_DSP*, void*, FMOD_BOOL) FMOD_DSP_ShowConfigDialog;

    FMOD_RESULT function(FMOD_DSP*, char*, uint*, int*, int*, int*) FMOD_DSP_GetInfo;
    FMOD_RESULT function(FMOD_DSP*, FMOD_DSP_TYPE*) FMOD_DSP_GetType;
    FMOD_RESULT function(FMOD_DSP*, float, float, float, int) FMOD_DSP_SetDefaults;
    FMOD_RESULT function(FMOD_DSP*, float*, float*, float*, int*) FMOD_DSP_GetDefaults;

    FMOD_RESULT function(FMOD_DSP*, void*) FMOD_DSP_SetUserData;
    FMOD_RESULT function(FMOD_DSP*, void**) FMOD_DSP_GetUserData;
    FMOD_RESULT function(FMOD_DSP*, uint, uint, uint*, FMOD_MEMORY_USAGE_DETAILS*) FMOD_DSP_GetMemoryInfo;

    FMOD_RESULT function(FMOD_DSPCONNECTION*, FMOD_DSP**) FMOD_DSPConnection_GetInput;
    FMOD_RESULT function(FMOD_DSPCONNECTION*, FMOD_DSP**) FMOD_DSPConnection_GetOutput;
    FMOD_RESULT function(FMOD_DSPCONNECTION*, float) FMOD_DSPConnection_SetMix;
    FMOD_RESULT function(FMOD_DSPCONNECTION*, float*) FMOD_DSPConnection_GetMix;
    FMOD_RESULT function(FMOD_DSPCONNECTION*, FMOD_SPEAKER, float*, int) FMOD_DSPConnection_SetLevels;
    FMOD_RESULT function(FMOD_DSPCONNECTION*, float*, int) FMOD_DSPConnection_GetLevels;

    FMOD_RESULT function(FMOD_DSPCONNECTION*, void*) FMOD_DSPConnection_SetUserData;
    FMOD_RESULT function(FMOD_DSPCONNECTION*, void**) FMOD_DSPConnection_GetUserData;
    FMOD_RESULT function(FMOD_DSPCONNECTION*, uint, uint, uint*, FMOD_MEMORY_USAGE_DETAILS*) FMOD_DSPConnection_GetMemoryInfo;

    FMOD_RESULT function(FMOD_GEOMETRY*) FMOD_Geometry_Release;

    FMOD_RESULT function(FMOD_GEOMETRY*, float, float, FMOD_BOOL, int, in FMOD_VECTOR*, int*) FMOD_Geometry_AddPolygon;
    FMOD_RESULT function(FMOD_GEOMETRY*, int*) FMOD_Geometry_GetNumPolygons;
    FMOD_RESULT function(FMOD_GEOMETRY*, int*, int*) FMOD_Geometry_GetMaxPolygons;
    FMOD_RESULT function(FMOD_GEOMETRY*, int, int*) FMOD_Geometry_GetPolygonNumVertices;
    FMOD_RESULT function(FMOD_GEOMETRY*, int, int, in FMOD_VECTOR*) FMOD_Geometry_SetPolygonVertex;
    FMOD_RESULT function(FMOD_GEOMETRY*, int, int, FMOD_VECTOR*) FMOD_Geometry_GetPolygonVertex;
    FMOD_RESULT function(FMOD_GEOMETRY*, int, float, float, FMOD_BOOL) FMOD_Geometry_SetPolygonAttributes;
    FMOD_RESULT function(FMOD_GEOMETRY*, int, float*, float*, FMOD_BOOL*) FMOD_Geometry_GetPolygonAttributes;

    FMOD_RESULT function(FMOD_GEOMETRY*, FMOD_BOOL) FMOD_Geometry_SetActive;
    FMOD_RESULT function(FMOD_GEOMETRY*, FMOD_BOOL*) FMOD_Geometry_GetActive;
    FMOD_RESULT function(FMOD_GEOMETRY*, in FMOD_VECTOR*, in FMOD_VECTOR*) FMOD_Geometry_SetRotation;
    FMOD_RESULT function(FMOD_GEOMETRY*, FMOD_VECTOR*, FMOD_VECTOR*) FMOD_Geometry_GetRotation;
    FMOD_RESULT function(FMOD_GEOMETRY*, in FMOD_VECTOR*) FMOD_Geometry_SetPosition;
    FMOD_RESULT function(FMOD_GEOMETRY*, FMOD_VECTOR*) FMOD_Geometry_GetPosition;
    FMOD_RESULT function(FMOD_GEOMETRY*, in FMOD_VECTOR*) FMOD_Geometry_SetScale;
    FMOD_RESULT function(FMOD_GEOMETRY*, FMOD_VECTOR*) FMOD_Geometry_GetScale;
    FMOD_RESULT function(FMOD_GEOMETRY*, void*, int*) FMOD_Geometry_Save;

    FMOD_RESULT function(FMOD_GEOMETRY*, void*) FMOD_Geometry_SetUserData;
    FMOD_RESULT function(FMOD_GEOMETRY*, void**) FMOD_Geometry_GetUserData;
    FMOD_RESULT function(FMOD_GEOMETRY*, uint, uint, uint*, FMOD_MEMORY_USAGE_DETAILS*) FMOD_Geometry_GetMemoryInfo;

    FMOD_RESULT function(FMOD_REVERB*) FMOD_Reverb_Release;
    FMOD_RESULT function(FMOD_REVERB*, in FMOD_VECTOR*, float, float) FMOD_Reverb_Set3DAttributes;
    FMOD_RESULT function(FMOD_REVERB*, FMOD_VECTOR*, float*, float*) FMOD_Reverb_Get3DAttributes;
    FMOD_RESULT function(FMOD_REVERB*, in FMOD_REVERB_PROPERTIES*) FMOD_Reverb_SetProperties;
    FMOD_RESULT function(FMOD_REVERB*, FMOD_REVERB_PROPERTIES*) FMOD_Reverb_GetProperties;
    FMOD_RESULT function(FMOD_REVERB*, FMOD_BOOL) FMOD_Reverb_SetActive;
    FMOD_RESULT function(FMOD_REVERB*, FMOD_BOOL*) FMOD_Reverb_GetActive;

    FMOD_RESULT function(FMOD_REVERB*, void*) FMOD_Reverb_SetUserData;
    FMOD_RESULT function(FMOD_REVERB*, void**) FMOD_Reverb_GetUserData;
    FMOD_RESULT function(FMOD_REVERB*, uint, uint, uint*, FMOD_MEMORY_USAGE_DETAILS*) FMOD_Reverb_GetMemoryInfo;
}