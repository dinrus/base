module lib.sdlimage;

private
{
import stdrus, lib.sdl;
pragma(lib,"DinrusX86.lib");
}

private проц грузи(Биб биб)
{
    вяжи(IMG_Linked_Version)("IMG_Linked_Version", биб);
    вяжи(IMG_LoadTyped_RW)("IMG_LoadTyped_RW", биб);
    вяжи(IMG_Load)("IMG_Load", биб);
    вяжи(IMG_Load_RW)("IMG_Load_RW", биб);
    вяжи(IMG_InvertAlpha)("IMG_InvertAlpha", биб);
    вяжи(IMG_isBMP)("IMG_isBMP", биб);
    вяжи(IMG_isGIF)("IMG_isGIF", биб);
    вяжи(IMG_isJPG)("IMG_isJPG", биб);
    вяжи(IMG_isLBM)("IMG_isLBM", биб);
    вяжи(IMG_isPCX)("IMG_isPCX", биб);
    вяжи(IMG_isPNG)("IMG_isPNG", биб);
    вяжи(IMG_isPNM)("IMG_isPNM", биб);
    вяжи(IMG_isTIF)("IMG_isTIF", биб);
    вяжи(IMG_isXCF)("IMG_isXCF", биб);
    вяжи(IMG_isXPM)("IMG_isXPM", биб);
    вяжи(IMG_isXV)("IMG_isXV", биб);
    вяжи(IMG_LoadBMP_RW)("IMG_LoadBMP_RW", биб);
    вяжи(IMG_LoadGIF_RW)("IMG_LoadGIF_RW", биб);
    вяжи(IMG_LoadJPG_RW)("IMG_LoadJPG_RW", биб);
    вяжи(IMG_LoadLBM_RW)("IMG_LoadLBM_RW", биб);
    вяжи(IMG_LoadPCX_RW)("IMG_LoadPCX_RW", биб);
    вяжи(IMG_LoadPNG_RW)("IMG_LoadPNG_RW", биб);
    вяжи(IMG_LoadPNM_RW)("IMG_LoadPNM_RW", биб);
    вяжи(IMG_LoadTGA_RW)("IMG_LoadTGA_RW", биб);
    вяжи(IMG_LoadTIF_RW)("IMG_LoadTIF_RW", биб);
    вяжи(IMG_LoadXCF_RW)("IMG_LoadXCF_RW", биб);
    вяжи(IMG_LoadXPM_RW)("IMG_LoadXPM_RW", биб);
    вяжи(IMG_LoadXV_RW)("IMG_LoadXV_RW", биб);
    вяжи(IMG_ReadXPMFromArray)("IMG_ReadXPMFromArray", биб);
}


ЖанБибгр СДЛИмидж;
static this() {
    СДЛИмидж.заряжай("SDL_image.dll", &грузи);
	СДЛИмидж.загружай();
}

alias сдлУстановиОш IMG_SetError;
alias сдлДайОш IMG_GetError;

enum : Uint8
{
    SDL_IMAGE_MAJOR_VERSION     = 1,
    SDL_IMAGE_MINOR_VERSION     = 2,
    SDL_IMAGE_PATCHLEVEL        = 7,
}

void SDL_IMAGE_VERSION(ВерсияСДЛ* X)
{
    X.майор     = SDL_IMAGE_MAJOR_VERSION;
    X.минор     = SDL_IMAGE_MINOR_VERSION;
    X.патч     = SDL_IMAGE_PATCHLEVEL;
}

extern(C)
{
    ВерсияСДЛ* function() IMG_Linked_Version;
    ПоверхностьСДЛ* function(ЧЗоперации*, int, char*) IMG_LoadTyped_RW;
    ПоверхностьСДЛ* function(char*) IMG_Load;
    ПоверхностьСДЛ* function(ЧЗоперации*, int) IMG_Load_RW;
    int function(int) IMG_InvertAlpha;
    int function(ЧЗоперации*) IMG_isBMP;
    int function(ЧЗоперации*) IMG_isGIF;
    int function(ЧЗоперации*) IMG_isJPG;
    int function(ЧЗоперации*) IMG_isLBM;
    int function(ЧЗоперации*) IMG_isPCX;
    int function(ЧЗоперации*) IMG_isPNG;
    int function(ЧЗоперации*) IMG_isPNM;
    int function(ЧЗоперации*) IMG_isTIF;
    int function(ЧЗоперации*) IMG_isXCF;
    int function(ЧЗоперации*) IMG_isXPM;
    int function(ЧЗоперации*) IMG_isXV;
    ПоверхностьСДЛ* function(ЧЗоперации*) IMG_LoadBMP_RW;
    ПоверхностьСДЛ* function(ЧЗоперации*) IMG_LoadGIF_RW;
    ПоверхностьСДЛ* function(ЧЗоперации*) IMG_LoadJPG_RW;
    ПоверхностьСДЛ* function(ЧЗоперации*) IMG_LoadLBM_RW;
    ПоверхностьСДЛ* function(ЧЗоперации*) IMG_LoadPCX_RW;
    ПоверхностьСДЛ* function(ЧЗоперации*) IMG_LoadPNG_RW;
    ПоверхностьСДЛ* function(ЧЗоперации*) IMG_LoadPNM_RW;
    ПоверхностьСДЛ* function(ЧЗоперации*) IMG_LoadTGA_RW;
    ПоверхностьСДЛ* function(ЧЗоперации*) IMG_LoadTIF_RW;
    ПоверхностьСДЛ* function(ЧЗоперации*) IMG_LoadXCF_RW;
    ПоверхностьСДЛ* function(ЧЗоперации*) IMG_LoadXPM_RW;
    ПоверхностьСДЛ* function(ЧЗоперации*) IMG_LoadXV_RW;
    ПоверхностьСДЛ* function(char**) IMG_ReadXPMFromArray;
}