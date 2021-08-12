// D import file generated from 'wfuncs.d'
module derelict.sfml.wfuncs;
private 
{
    import derelict.util.compat;
    import derelict.sfml.config;
    import derelict.sfml.wtypes;
}
extern (C) 
{
    mixin(gsharedString!() ~ "\x0a    // Context.h\x0a    sfContext* function() sfContext_Create;\x0a    void function(sfContext*) sfContext_Destroy;\x0a    void function(sfContext*, sfBool) sfContext_SetActive;\x0a\x0a    // Input.h\x0a    sfBool function(sfInput*, sfKeyCode) sfInput_IsKeyDown;\x0a    sfBool function(sfInput*, sfMouseButton) sfInput_IsMouseButtonDown;\x0a    sfBool function(sfInput*, uint, uint) sfInput_IsJoystickButtonDown;\x0a    int function(sfInput*) sfInput_GetMouseX;\x0a    int function(sfInput*) sfInput_GetMouseY;\x0a    float function(sfInput*, uint, sfJoyAxis) sfInput_GetJoystickAxis;\x0a\x0a    // VideoMode.h\x0a    sfVideoMode function() sfVideoMode_GetDesktopMode;\x0a    sfVideoMode function(size_t) sfVideoMode_GetMode;\x0a    size_t function() sfVideoMode_GetModesCount;\x0a    sfBool function(sfVideoMode) sfVideoMode_IsValid;\x0a\x0a    // Window.h\x0a    sfWindow* function(sfVideoMode, CCPTR, uint, sfWindowSettings) sfWindow_Create;\x0a    sfWindow* function(sfWindowHandle, sfWindowSettings) sfWindow_CreateFromHandle;\x0a    void function(sfWindow*) sfWindow_Destroy;\x0a    void function(sfWindow*) sfWindow_Close;\x0a    sfBool function(sfWindow*) sfWindow_IsOpened;\x0a    uint function(sfWindow*) sfWindow_GetWidth;\x0a    uint function(sfWindow*) sfWindow_GetHeight;\x0a    sfWindowSettings function(sfWindow*) sfWindow_GetSettings;\x0a    sfBool function(sfWindow*, sfEvent*) sfWindow_GetEvent;\x0a    void function(sfWindow*, sfBool) sfWindow_UseVerticalSync;\x0a    void function(sfWindow*, sfBool) sfWindow_ShowMouseCursor;\x0a    void function(sfWindow*, uint, uint) sfWindow_SetCursorPosition;\x0a    void function(sfWindow*, int, int) sfWindow_SetPosition;\x0a    void function(sfWindow*, uint, uint) sfWindow_SetSize;\x0a    void function(sfWindow*, sfBool) sfWindow_Show;\x0a    void function(sfWindow*, sfBool) sfWindow_EnableKeyRepeat;\x0a    void function(sfWindow*, uint, uint, sfUint8*) sfWindow_SetIcon;\x0a    sfBool function(sfWindow*, sfBool) sfWindow_SetActive;\x0a    void function(sfWindow*) sfWindow_Display;\x0a    sfInput* function(sfWindow*) sfWindow_GetInput;\x0a    void function(sfWindow*, uint) sfWindow_SetFramerateLimit;\x0a    float function(sfWindow*) sfWindow_GetFrameTime;\x0a    void function(sfWindow*, float) sfWindow_SetJoystickThreshold;\x0a    ");
}
