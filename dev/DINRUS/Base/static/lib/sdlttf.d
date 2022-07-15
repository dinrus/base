module lib.sdlttf;

private
{
 import stdrus, lib.sdl;
pragma(lib,"DinrusX86.lib");
}

private проц грузи(Биб биб)
{
    вяжи(TTF_Linked_Version)("TTF_Linked_Version", биб);
    вяжи(TTF_ByteSwappedUNICODE)("TTF_ByteSwappedUNICODE", биб);
    вяжи(TTF_Init)("TTF_Init", биб);
    вяжи(TTF_OpenFont)("TTF_OpenFont", биб);
    вяжи(TTF_OpenFontIndex)("TTF_OpenFontIndex", биб);
    вяжи(TTF_OpenFontRW)("TTF_OpenFontRW", биб);
    вяжи(TTF_OpenFontIndexRW)("TTF_OpenFontIndexRW", биб);
    вяжи(TTF_GetFontStyle)("TTF_GetFontStyle", биб);
    вяжи(TTF_SetFontStyle)("TTF_SetFontStyle", биб);
    вяжи(TTF_FontHeight)("TTF_FontHeight", биб);
    вяжи(TTF_FontAscent)("TTF_FontAscent", биб);
    вяжи(TTF_FontDescent)("TTF_FontDescent", биб);
    вяжи(TTF_FontLineSkip)("TTF_FontLineSkip", биб);
    вяжи(TTF_FontFaces)("TTF_FontFaces", биб);
    вяжи(TTF_FontFaceIsFixedWidth)("TTF_FontFaceIsFixedWidth", биб);
    вяжи(TTF_FontFaceFamilyName)("TTF_FontFaceFamilyName", биб);
    вяжи(TTF_FontFaceStyleName)("TTF_FontFaceStyleName", биб);
    вяжи(TTF_GlyphMetrics)("TTF_GlyphMetrics", биб);
    вяжи(TTF_SizeText)("TTF_SizeText", биб);
    вяжи(TTF_SizeUTF8)("TTF_SizeUTF8", биб);
    вяжи(TTF_SizeUNICODE)("TTF_SizeUNICODE", биб);
    вяжи(TTF_RenderTрасш_Solid)("TTF_RenderTрасш_Solid", биб);
    вяжи(TTF_RenderUTF8_Solid)("TTF_RenderUTF8_Solid", биб);
    вяжи(TTF_RenderUNICODE_Solid)("TTF_RenderUNICODE_Solid", биб);
    вяжи(TTF_RenderGlyph_Solid)("TTF_RenderGlyph_Solid", биб);
    вяжи(TTF_RenderTрасш_Shaded)("TTF_RenderTрасш_Shaded", биб);
    вяжи(TTF_RenderUTF8_Shaded)("TTF_RenderUTF8_Shaded", биб);
    вяжи(TTF_RenderUNICODE_Shaded)("TTF_RenderUNICODE_Shaded", биб);
    вяжи(TTF_RenderGlyph_Shaded)("TTF_RenderGlyph_Shaded", биб);
    вяжи(TTF_RenderTрасш_Blended)("TTF_RenderTрасш_Blended", биб);
    вяжи(TTF_RenderUTF8_Blended)("TTF_RenderUTF8_Blended", биб);
    вяжи(TTF_RenderUNICODE_Blended)("TTF_RenderUNICODE_Blended", биб);
    вяжи(TTF_RenderGlyph_Blended)("TTF_RenderGlyph_Blended", биб);
    вяжи(TTF_CloseFont)("TTF_CloseFont", биб);
    вяжи(TTF_Quit)("TTF_Quit", биб);
    вяжи(TTF_WasInit)("TTF_WasInit", биб);
}


ЖанБибгр СДЛттф;
static this() {
    СДЛттф.заряжай("SDL_ttf.dll", &грузи);
	СДЛттф.загружай();
}

enum : Uint8
{
    SDL_TTF_MAJOR_VERSION = 2,
    SDL_TTF_MINOR_VERSION = 0,
    SDL_TTF_PATCHLEVEL    = 9,
}
alias SDL_TTF_MAJOR_VERSION TTF_MAJOR_VERSION;
alias SDL_TTF_MINOR_VERSION TTF_MINOR_VERSION;
alias SDL_TTF_PATCHLEVEL TTF_PATCHLEVEL;

enum
{
    UNICODE_BOM_NATIVE = 0xFEFF,
    UNICODE_BOM_SWAPPED = 0xFFFE,
    TTF_STYLE_NORMAL = 0x00,
    TTF_STYLE_BOLD = 0x01,
    TTF_STYLE_ITALIC = 0x02,
    TTF_STYLE_UNDERLINE = 0x04,
}

alias сдлУстановиОш TTF_SetError;
alias сдлДайОш TTF_GetError;

struct _TTF_Font {}
typedef _TTF_Font TTF_Font;

void SDL_TTF_VERSION(ВерсияСДЛ* X)
{
    X.майор = SDL_TTF_MAJOR_VERSION;
    X.минор = SDL_TTF_MINOR_VERSION;
    X.патч = SDL_TTF_PATCHLEVEL;
}

void TTF_VERSION(ВерсияСДЛ* X) { SDL_TTF_VERSION(X); }

extern (C)
{
    ВерсияСДЛ* function() TTF_Linked_Version;
    void function(int) TTF_ByteSwappedUNICODE;
    int function() TTF_Init;
    TTF_Font * function (char*, int) TTF_OpenFont;
    TTF_Font * function (char*, int, long ) TTF_OpenFontIndex;
    TTF_Font * function (ЧЗоперации*, int, int) TTF_OpenFontRW;
    TTF_Font * function (ЧЗоперации*, int, int, long) TTF_OpenFontIndexRW;
    int function (TTF_Font*) TTF_GetFontStyle;
    void function (TTF_Font*, int style) TTF_SetFontStyle;
    int function(TTF_Font*) TTF_FontHeight;
    int function(TTF_Font*) TTF_FontAscent;
    int function(TTF_Font*) TTF_FontDescent;
    int function(TTF_Font*) TTF_FontLineSkip;
    int function(TTF_Font*) TTF_FontFaces;
    int function(TTF_Font*) TTF_FontFaceIsFixedWidth;
    char* function(TTF_Font*) TTF_FontFaceFamilyName;
    char* function(TTF_Font*) TTF_FontFaceStyleName;
    int function (TTF_Font*, Uint16, int*, int*, int*, int*, int*) TTF_GlyphMetrics;
    int function (TTF_Font*, char*, int*, int*) TTF_SizeText;
    int function (TTF_Font*, char*, int*, int*) TTF_SizeUTF8;
    int function (TTF_Font*, Uint16*, int*, int*) TTF_SizeUNICODE;
    ПоверхностьСДЛ* function (TTF_Font*, char*, ЦветСДЛ) TTF_RenderTрасш_Solid;
    ПоверхностьСДЛ* function (TTF_Font*, char*, ЦветСДЛ) TTF_RenderUTF8_Solid;
    ПоверхностьСДЛ* function (TTF_Font*, Uint16*, ЦветСДЛ) TTF_RenderUNICODE_Solid;
    ПоверхностьСДЛ* function (TTF_Font*, Uint16, ЦветСДЛ) TTF_RenderGlyph_Solid;
    ПоверхностьСДЛ* function (TTF_Font*, char*, ЦветСДЛ, ЦветСДЛ) TTF_RenderTрасш_Shaded;
    ПоверхностьСДЛ* function (TTF_Font*, char*, ЦветСДЛ, ЦветСДЛ) TTF_RenderUTF8_Shaded;
    ПоверхностьСДЛ* function (TTF_Font*, Uint16*, ЦветСДЛ, ЦветСДЛ) TTF_RenderUNICODE_Shaded;
    ПоверхностьСДЛ* function (TTF_Font*, Uint16, ЦветСДЛ, ЦветСДЛ) TTF_RenderGlyph_Shaded;
    ПоверхностьСДЛ* function (TTF_Font*, char*, ЦветСДЛ) TTF_RenderTрасш_Blended;
    ПоверхностьСДЛ* function (TTF_Font*, char*, ЦветСДЛ) TTF_RenderUTF8_Blended;
    ПоверхностьСДЛ* function (TTF_Font*, Uint16*, ЦветСДЛ) TTF_RenderUNICODE_Blended;
    ПоверхностьСДЛ* function (TTF_Font*, Uint16, ЦветСДЛ) TTF_RenderGlyph_Blended;
    void function (TTF_Font*) TTF_CloseFont;
    void function () TTF_Quit;
    int function () TTF_WasInit;
}

alias TTF_RenderTрасш_Shaded TTF_RenderText;
alias TTF_RenderUTF8_Shaded TTF_RenderUTF8;
alias TTF_RenderUNICODE_Shaded TTF_RenderUNICODE;