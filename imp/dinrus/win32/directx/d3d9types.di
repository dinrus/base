/*==========================================================================;
 *
 *  Copyright (C) Microsoft Corporation.  All Rights Reserved.
 *
 *  Файл:       d3d9types.h
 *  Content:    Direct3D capabilities include file
 *
 ***************************************************************************/

module win32.directx.d3d9types;

private import win32.windows;

// Alignment compatibility
align(4):

// D3DCOLOR is equivalent to D3DFMT_A8R8G8B8
alias бцел D3DCOLOR;

// maps unsigned 8 bits/channel to D3DCOLOR
D3DCOLOR D3DCOLOR_ARGB(ббайт a,ббайт r,ббайт g,ббайт b) { return cast(D3DCOLOR)((a<<24)|(r<<16)|(g<<8)|b); }
D3DCOLOR D3DCOLOR_RGBA(ббайт r,ббайт g,ббайт b,ббайт a) { return D3DCOLOR_ARGB(a,r,g,b); }
D3DCOLOR D3DCOLOR_XRGB(ббайт r,ббайт g,ббайт b) { return D3DCOLOR_ARGB(0xff,r,g,b); }

D3DCOLOR D3DCOLOR_XYUV(ббайт y, ббайт u, ббайт v) { return D3DCOLOR_ARGB(0xff,y,u,v); }
D3DCOLOR D3DCOLOR_AYUV( ббайт a, ббайт y, ббайт u, ббайт v) { return D3DCOLOR_ARGB(a,y,u,v); }

// maps floating point channels (0.f to 1.f охват) to D3DCOLOR
D3DCOLOR D3DCOLOR_COLORVALUE(плав r, плав g, плав b, плав a) { return D3DCOLOR_RGBA(cast(ббайт)(r*255.0f),cast(ббайт)(g*255.0f),cast(ббайт)(b*255.0f),cast(ббайт)(a*255.0f)); }

struct D3DVECTOR {
    плав x;
    плав y;
    плав z;
}

struct D3DCOLORVALUE {
    плав r;
    плав g;
    плав b;
    плав a;
}

struct D3DRECT {
    LONG x1;
    LONG y1;
    LONG x2;
    LONG y2;
}

struct D3DMATRIX {
    union {
        struct {
            плав        _11, _12, _13, _14;
            плав        _21, _22, _23, _24;
            плав        _31, _32, _33, _34;
            плав        _41, _42, _43, _44;
        }
        плав[4][4] m;
    }
}

struct D3DVIEWPORT9 {
    бцел        X;
    бцел        Y;            /* Viewport Top лево */
    бцел        Width;
    бцел        Height;       /* Viewport Dimensions */
    плав       MinZ;         /* Min/max of clip Volume */
    плав       MaxZ;
}

/*
 * Values for clip fields.
 */

// Max number of user clipping planes, supported in D3D.
const D3DMAXUSERCLIPPLANES = 32;

// These bits could be ORed together to use with D3DRS_CLIPPLANEENABLE
//
const D3DCLIPPLANE0 = (1<<0);
const D3DCLIPPLANE1 = (1<<1);
const D3DCLIPPLANE2 = (1<<2);
const D3DCLIPPLANE3 = (1<<3);
const D3DCLIPPLANE4 = (1<<4);
const D3DCLIPPLANE5 = (1<<5);

// The following bits are used in the ClipUnion and ClipIntersection
// members of the D3DCLIPSTATUS9
//

const D3DCS_LEFT = 0x00000001L;
const D3DCS_RIGHT = 0x00000002L;
const D3DCS_TOP = 0x00000004L;
const D3DCS_BOTTOM = 0x00000008L;
const D3DCS_FRONT = 0x00000010L;
const D3DCS_BACK = 0x00000020L;
const D3DCS_PLANE0 = 0x00000040L;
const D3DCS_PLANE1 = 0x00000080L;
const D3DCS_PLANE2 = 0x00000100L;
const D3DCS_PLANE3 = 0x00000200L;
const D3DCS_PLANE4 = 0x00000400L;
const D3DCS_PLANE5 = 0x00000800L;

const D3DCS_ALL = D3DCS_LEFT   |
                  D3DCS_RIGHT  |
                  D3DCS_TOP    |
                  D3DCS_BOTTOM |
                  D3DCS_FRONT  |
                  D3DCS_BACK   |
                  D3DCS_PLANE0 |
                  D3DCS_PLANE1 |
                  D3DCS_PLANE2 |
                  D3DCS_PLANE3 |
                  D3DCS_PLANE4 |
                  D3DCS_PLANE5;

struct D3DCLIPSTATUS9 {
    бцел ClipUnion;
    бцел ClipIntersection;
}

struct D3DMATERIAL9 {
    D3DCOLORVALUE   Diffuse;        /* Diffuse color RGBA */
    D3DCOLORVALUE   Ambient;        /* Ambient color RGB */
    D3DCOLORVALUE   Specular;       /* Specular 'shininess' */
    D3DCOLORVALUE   Emissive;       /* Emissive color RGB */
    плав           Power;          /* Sharpness if specular highlight */
}

enum : бцел {
    D3DLIGHT_POINT          = 1,
    D3DLIGHT_SPOT           = 2,
    D3DLIGHT_DIRECTIONAL    = 3
}
alias бцел D3DLIGHTTYPE;

struct D3DLIGHT9 {
    D3DLIGHTTYPE    Type;            /* Type of light исток */
    D3DCOLORVALUE   Diffuse;         /* Diffuse color of light */
    D3DCOLORVALUE   Specular;        /* Specular color of light */
    D3DCOLORVALUE   Ambient;         /* Ambient color of light */
    D3DVECTOR       Position;         /* Position in world space */
    D3DVECTOR       Direction;        /* Direction in world space */
    плав           Range;            /* Cutoff охват */
    плав           Falloff;          /* Falloff */
    плав           Attenuation0;     /* Constant attenuation */
    плав           Attenuation1;     /* Linear attenuation */
    плав           Attenuation2;     /* Quadratic attenuation */
    плав           Theta;            /* Inner angle of spotlight cone */
    плав           Phi;              /* Outer angle of spotlight cone */
}

/*
 * Options for clearing
 */
const D3DCLEAR_TARGET = 0x00000001L;  /* Clear цель surface */
const D3DCLEAR_ZBUFFER = 0x00000002L;  /* Clear цель z буфер */
const D3DCLEAR_STENCIL = 0x00000004L;  /* Clear stencil planes */

/*
 * The following defines the rendering states
 */
alias бцел D3DSHADEMODE;
enum : D3DSHADEMODE {
    D3DSHADE_FLAT               = 1,
    D3DSHADE_GOURAUD            = 2,
    D3DSHADE_PHONG              = 3
} 

alias бцел D3DFILLMODE;
enum : D3DFILLMODE {
    D3DFILL_POINT               = 1,
    D3DFILL_WIREFRAME           = 2,
    D3DFILL_SOLID               = 3
}

alias бцел D3DBLEND;
enum : D3DBLEND {
    D3DBLEND_ZERO               = 1,
    D3DBLEND_ONE                = 2,
    D3DBLEND_SRCCOLOR           = 3,
    D3DBLEND_INVSRCCOLOR        = 4,
    D3DBLEND_SRCALPHA           = 5,
    D3DBLEND_INVSRCALPHA        = 6,
    D3DBLEND_DESTALPHA          = 7,
    D3DBLEND_INVDESTALPHA       = 8,
    D3DBLEND_DESTCOLOR          = 9,
    D3DBLEND_INVDESTCOLOR       = 10,
    D3DBLEND_SRCALPHASAT        = 11,
    D3DBLEND_BOTHSRCALPHA       = 12,
    D3DBLEND_BOTHINVSRCALPHA    = 13,
    D3DBLEND_BLENDFACTOR        = 14, /* Only supported if D3DPBLENDCAPS_BLENDFACTOR is on */
    D3DBLEND_INVBLENDFACTOR     = 15, /* Only supported if D3DPBLENDCAPS_BLENDFACTOR is on */
    D3DBLEND_SRCCOLOR2          = 16,
    D3DBLEND_INVSRCCOLOR2       = 17
}

alias бцел D3DBLENDOP;
enum : D3DBLENDOP {
    D3DBLENDOP_ADD              = 1,
    D3DBLENDOP_SUBTRACT         = 2,
    D3DBLENDOP_REVSUBTRACT      = 3,
    D3DBLENDOP_MIN              = 4,
    D3DBLENDOP_MAX              = 5
}

alias бцел D3DTEXTUREADDRESS;
enum : D3DTEXTUREADDRESS {
    D3DTADDRESS_WRAP            = 1,
    D3DTADDRESS_MIRROR          = 2,
    D3DTADDRESS_CLAMP           = 3,
    D3DTADDRESS_BORDER          = 4,
    D3DTADDRESS_MIRRORONCE      = 5
}

alias бцел D3DCULL;
enum : D3DCULL {
    D3DCULL_NONE                = 1,
    D3DCULL_CW                  = 2,
    D3DCULL_CCW                 = 3
}

alias бцел D3DCMPFUNC;
enum : D3DCMPFUNC {
    D3DCMP_NEVER                = 1,
    D3DCMP_LESS                 = 2,
    D3DCMP_EQUAL                = 3,
    D3DCMP_LESSEQUAL            = 4,
    D3DCMP_GREATER              = 5,
    D3DCMP_NOTEQUAL             = 6,
    D3DCMP_GREATEREQUAL         = 7,
    D3DCMP_ALWAYS               = 8
}

alias бцел D3DSTENCILOP;
enum : D3DSTENCILOP {
    D3DSTENCILOP_KEEP           = 1,
    D3DSTENCILOP_ZERO           = 2,
    D3DSTENCILOP_REPLACE        = 3,
    D3DSTENCILOP_INCRSAT        = 4,
    D3DSTENCILOP_DECRSAT        = 5,
    D3DSTENCILOP_INVERT         = 6,
    D3DSTENCILOP_INCR           = 7,
    D3DSTENCILOP_DECR           = 8
}

alias бцел D3DFOGMODE;
enum : D3DFOGMODE {
    D3DFOG_NONE                 = 0,
    D3DFOG_EXP                  = 1,
    D3DFOG_EXP2                 = 2,
    D3DFOG_LINEAR               = 3
}

alias бцел D3DZBUFFERTYPE;
enum : D3DZBUFFERTYPE {
    D3DZB_FALSE                 = 0,
    D3DZB_TRUE                  = 1, // Z buffering
    D3DZB_USEW                  = 2 // W buffering
}

alias бцел D3DPRIMITIVETYPE;
// Primitives supported by draw-primitive API
enum : D3DPRIMITIVETYPE {
    D3DPT_POINTLIST             = 1,
    D3DPT_LINELIST              = 2,
    D3DPT_LINESTRIP             = 3,
    D3DPT_TRIANGLELIST          = 4,
    D3DPT_TRIANGLESTRIP         = 5,
    D3DPT_TRIANGLEFAN           = 6
}


D3DTRANSFORMSTATETYPE D3DTS_WORLDMATRIX(бцел индекс) { return cast(D3DTRANSFORMSTATETYPE)(индекс + 256); }
template T_D3DTS_WORLDMATRIX(бцел индекс) {
    const D3DTRANSFORMSTATETYPE T_D3DTS_WORLDMATRIX = индекс + 256;
}
alias бцел D3DTRANSFORMSTATETYPE;
enum : D3DTRANSFORMSTATETYPE {
    D3DTS_VIEW          = 2,
    D3DTS_PROJECTION    = 3,
    D3DTS_TEXTURE0      = 16,
    D3DTS_TEXTURE1      = 17,
    D3DTS_TEXTURE2      = 18,
    D3DTS_TEXTURE3      = 19,
    D3DTS_TEXTURE4      = 20,
    D3DTS_TEXTURE5      = 21,
    D3DTS_TEXTURE6      = 22,
    D3DTS_TEXTURE7      = 23,
    D3DTS_WORLD         = T_D3DTS_WORLDMATRIX!(0),
    D3DTS_WORLD1        = T_D3DTS_WORLDMATRIX!(1),
    D3DTS_WORLD2        = T_D3DTS_WORLDMATRIX!(2),
    D3DTS_WORLD3        = T_D3DTS_WORLDMATRIX!(3)
}

alias бцел D3DRENDERSTATETYPE;
enum : D3DRENDERSTATETYPE {
    D3DRS_ZENABLE                   = 7,    /* D3DZBUFFERTYPE (or TRUE/FALSE for legacy) */
    D3DRS_FILLMODE                  = 8,    /* D3DFILLMODE */
    D3DRS_SHADEMODE                 = 9,    /* D3DSHADEMODE */
    D3DRS_ZWRITEENABLE              = 14,   /* TRUE to enable z writes */
    D3DRS_ALPHATESTENABLE           = 15,   /* TRUE to enable alpha tests */
    D3DRS_LASTPIXEL                 = 16,   /* TRUE for last-pixel on lines */
    D3DRS_SRCBLEND                  = 19,   /* D3DBLEND */
    D3DRS_DESTBLEND                 = 20,   /* D3DBLEND */
    D3DRS_CULLMODE                  = 22,   /* D3DCULL */
    D3DRS_ZFUNC                     = 23,   /* D3DCMPFUNC */
    D3DRS_ALPHAREF                  = 24,   /* D3DFIXED */
    D3DRS_ALPHAFUNC                 = 25,   /* D3DCMPFUNC */
    D3DRS_DITHERENABLE              = 26,   /* TRUE to enable dithering */
    D3DRS_ALPHABLENDENABLE          = 27,   /* TRUE to enable alpha blending */
    D3DRS_FOGENABLE                 = 28,   /* TRUE to enable fog blending */
    D3DRS_SPECULARENABLE            = 29,   /* TRUE to enable specular */
    D3DRS_FOGCOLOR                  = 34,   /* D3DCOLOR */
    D3DRS_FOGTABLEMODE              = 35,   /* D3DFOGMODE */
    D3DRS_FOGSTART                  = 36,   /* Fog start (for both vertex and pixel fog) */
    D3DRS_FOGEND                    = 37,   /* Fog end      */
    D3DRS_FOGDENSITY                = 38,   /* Fog density  */
    D3DRS_RANGEFOGENABLE            = 48,   /* Enables охват-based fog */
    D3DRS_STENCILENABLE             = 52,   /* BOOL enable/disable stenciling */
    D3DRS_STENCILFAIL               = 53,   /* D3DSTENCILOP to do if stencil test fails */
    D3DRS_STENCILZFAIL              = 54,   /* D3DSTENCILOP to do if stencil test passes and Z test fails */
    D3DRS_STENCILPASS               = 55,   /* D3DSTENCILOP to do if both stencil and Z tests pass */
    D3DRS_STENCILFUNC               = 56,   /* D3DCMPFUNC fn.  Stencil Test passes if ((ref & mask) stencilfn (stencil & mask)) is true */
    D3DRS_STENCILREF                = 57,   /* Reference значение used in stencil test */
    D3DRS_STENCILMASK               = 58,   /* Mask значение used in stencil test */
    D3DRS_STENCILWRITEMASK          = 59,   /* Write mask applied to значения written to stencil буфер */
    D3DRS_TEXTUREFACTOR             = 60,   /* D3DCOLOR used for multi-texture blend */
    D3DRS_WRAP0                     = 128,  /* wrap for 1st texture coord. set */
    D3DRS_WRAP1                     = 129,  /* wrap for 2nd texture coord. set */
    D3DRS_WRAP2                     = 130,  /* wrap for 3rd texture coord. set */
    D3DRS_WRAP3                     = 131,  /* wrap for 4th texture coord. set */
    D3DRS_WRAP4                     = 132,  /* wrap for 5th texture coord. set */
    D3DRS_WRAP5                     = 133,  /* wrap for 6th texture coord. set */
    D3DRS_WRAP6                     = 134,  /* wrap for 7th texture coord. set */
    D3DRS_WRAP7                     = 135,  /* wrap for 8th texture coord. set */
    D3DRS_CLIPPING                  = 136,
    D3DRS_LIGHTING                  = 137,
    D3DRS_AMBIENT                   = 139,
    D3DRS_FOGVERTEXMODE             = 140,
    D3DRS_COLORVERTEX               = 141,
    D3DRS_LOCALVIEWER               = 142,
    D3DRS_NORMALIZENORMALS          = 143,
    D3DRS_DIFFUSEMATERIALSOURCE     = 145,
    D3DRS_SPECULARMATERIALSOURCE    = 146,
    D3DRS_AMBIENTMATERIALSOURCE     = 147,
    D3DRS_EMISSIVEMATERIALSOURCE    = 148,
    D3DRS_VERTEXBLEND               = 151,
    D3DRS_CLIPPLANEENABLE           = 152,
    D3DRS_POINTSIZE                 = 154,   /* плав point размер */
    D3DRS_POINTSIZE_MIN             = 155,   /* плав point размер min threshold */
    D3DRS_POINTSPRITEENABLE         = 156,   /* BOOL point texture coord control */
    D3DRS_POINTSCALEENABLE          = 157,   /* BOOL point размер scale enable */
    D3DRS_POINTSCALE_A              = 158,   /* плав point attenuation A значение */
    D3DRS_POINTSCALE_B              = 159,   /* плав point attenuation B значение */
    D3DRS_POINTSCALE_C              = 160,   /* плав point attenuation C значение */
    D3DRS_MULTISAMPLEANTIALIAS      = 161,  // BOOL - set to do FSAA with multisample буфер
    D3DRS_MULTISAMPLEMASK           = 162,  // DWORD - per-sample enable/disable
    D3DRS_PATCHEDGESTYLE            = 163,  // Sets whether patch edges will use плав style tessellation
    D3DRS_DEBUGMONITORTOKEN         = 165,  // DEBUG ONLY - token to debug monitor
    D3DRS_POINTSIZE_MAX             = 166,   /* плав point размер max threshold */
    D3DRS_INDEXEDVERTEXBLENDENABLE  = 167,
    D3DRS_COLORWRITEENABLE          = 168,  // per-channel пиши enable
    D3DRS_TWEENFACTOR               = 170,   // плав tween factor
    D3DRS_BLENDOP                   = 171,   // D3DBLENDOP setting
    D3DRS_POSITIONDEGREE            = 172,   // NPatch позиция interpolation degree. D3DDEGREE_LINEAR or D3DDEGREE_CUBIC (default)
    D3DRS_NORMALDEGREE              = 173,   // NPatch normal interpolation degree. D3DDEGREE_LINEAR (default) or D3DDEGREE_QUADRATIC
    D3DRS_SCISSORTESTENABLE         = 174,
    D3DRS_SLOPESCALEDEPTHBIAS       = 175,
    D3DRS_ANTIALIASEDLINEENABLE     = 176,
    D3DRS_MINTESSELLATIONLEVEL      = 178,
    D3DRS_MAXTESSELLATIONLEVEL      = 179,
    D3DRS_ADAPTIVETESS_X            = 180,
    D3DRS_ADAPTIVETESS_Y            = 181,
    D3DRS_ADAPTIVETESS_Z            = 182,
    D3DRS_ADAPTIVETESS_W            = 183,
    D3DRS_ENABLEADAPTIVETESSELLATION = 184,
    D3DRS_TWOSIDEDSTENCILMODE       = 185,   /* BOOL enable/disable 2 sided stenciling */
    D3DRS_CCW_STENCILFAIL           = 186,   /* D3DSTENCILOP to do if ccw stencil test fails */
    D3DRS_CCW_STENCILZFAIL          = 187,   /* D3DSTENCILOP to do if ccw stencil test passes and Z test fails */
    D3DRS_CCW_STENCILPASS           = 188,   /* D3DSTENCILOP to do if both ccw stencil and Z tests pass */
    D3DRS_CCW_STENCILFUNC           = 189,   /* D3DCMPFUNC fn.  ccw Stencil Test passes if ((ref & mask) stencilfn (stencil & mask)) is true */
    D3DRS_COLORWRITEENABLE1         = 190,   /* Additional ColorWriteEnables for the devices that support D3DPMISCCAPS_INDEPENDENTWRITEMASKS */
    D3DRS_COLORWRITEENABLE2         = 191,   /* Additional ColorWriteEnables for the devices that support D3DPMISCCAPS_INDEPENDENTWRITEMASKS */
    D3DRS_COLORWRITEENABLE3         = 192,   /* Additional ColorWriteEnables for the devices that support D3DPMISCCAPS_INDEPENDENTWRITEMASKS */
    D3DRS_BLENDFACTOR               = 193,   /* D3DCOLOR used for a constant blend factor during alpha blending for devices that support D3DPBLENDCAPS_BLENDFACTOR */
    D3DRS_SRGBWRITEENABLE           = 194,   /* Enable rendertarget writes to be DE-linearized to SRGB (for форматы that expose D3DUSAGE_QUERY_SRGBWRITE) */
    D3DRS_DEPTHBIAS                 = 195,
    D3DRS_WRAP8                     = 198,   /* Additional wrap states for vs_3_0+ attributes with D3DDECLUSAGE_TEXCOORD */
    D3DRS_WRAP9                     = 199,
    D3DRS_WRAP10                    = 200,
    D3DRS_WRAP11                    = 201,
    D3DRS_WRAP12                    = 202,
    D3DRS_WRAP13                    = 203,
    D3DRS_WRAP14                    = 204,
    D3DRS_WRAP15                    = 205,
    D3DRS_SEPARATEALPHABLENDENABLE  = 206,  /* TRUE to enable a separate blending function for the alpha channel */
    D3DRS_SRCBLENDALPHA             = 207,  /* SRC blend factor for the alpha channel when D3DRS_SEPARATEDESTALPHAENABLE is TRUE */
    D3DRS_DESTBLENDALPHA            = 208,  /* DST blend factor for the alpha channel when D3DRS_SEPARATEDESTALPHAENABLE is TRUE */
    D3DRS_BLENDOPALPHA              = 209   /* Blending operation for the alpha channel when D3DRS_SEPARATEDESTALPHAENABLE is TRUE */
}


// Maximum number of simultaneous render targets D3D supports
const D3D_MAX_SIMULTANEOUS_RENDERTARGETS = 4;

// Values for material исток
alias бцел D3DMATERIALCOLORSOURCE;
enum : D3DMATERIALCOLORSOURCE {
    D3DMCS_MATERIAL         = 0,            // Color from material is used
    D3DMCS_COLOR1           = 1,            // Diffuse vertex color is used
    D3DMCS_COLOR2           = 2             // Specular vertex color is used
}


// Bias to apply to the texture coordinate set to apply a wrap to.
const D3DRENDERSTATE_WRAPBIAS = 128UL;

/* Flags to construct the WRAP render states */
const D3DWRAP_U = 0x00000001L;
const D3DWRAP_V = 0x00000002L;
const D3DWRAP_W = 0x00000004L;

/* Flags to construct the WRAP render states for 1D thru 4D texture coordinates */
const D3DWRAPCOORD_0 = 0x00000001L;    // same as D3DWRAP_U
const D3DWRAPCOORD_1 = 0x00000002L;    // same as D3DWRAP_V
const D3DWRAPCOORD_2 = 0x00000004L;    // same as D3DWRAP_W
const D3DWRAPCOORD_3 = 0x00000008L;

/* Flags to construct D3DRS_COLORWRITEENABLE */
const D3DCOLORWRITEENABLE_RED = (1L<<0);
const D3DCOLORWRITEENABLE_GREEN = (1L<<1);
const D3DCOLORWRITEENABLE_BLUE = (1L<<2);
const D3DCOLORWRITEENABLE_ALPHA = (1L<<3);

/*
 * State enumerants for per-stage processing of fixed function pixel processing
 * Two of these affect fixed function vertex processing as well: TEXTURETRANSFORMFLAGS and TEXCOORDINDEX.
 */
alias бцел D3DTEXTURESTAGESTATETYPE;
enum : D3DTEXTURESTAGESTATETYPE {
    D3DTSS_COLOROP        =  1, /* D3DTEXTUREOP - per-stage blending controls for color channels */
    D3DTSS_COLORARG1      =  2, /* D3DTA_* (texture arg) */
    D3DTSS_COLORARG2      =  3, /* D3DTA_* (texture arg) */
    D3DTSS_ALPHAOP        =  4, /* D3DTEXTUREOP - per-stage blending controls for alpha channel */
    D3DTSS_ALPHAARG1      =  5, /* D3DTA_* (texture arg) */
    D3DTSS_ALPHAARG2      =  6, /* D3DTA_* (texture arg) */
    D3DTSS_BUMPENVMAT00   =  7, /* плав (bump mapping matrix) */
    D3DTSS_BUMPENVMAT01   =  8, /* плав (bump mapping matrix) */
    D3DTSS_BUMPENVMAT10   =  9, /* плав (bump mapping matrix) */
    D3DTSS_BUMPENVMAT11   = 10, /* плав (bump mapping matrix) */
    D3DTSS_TEXCOORDINDEX  = 11, /* identifies which set of texture coordinates индекс this texture */
    D3DTSS_BUMPENVLSCALE  = 22, /* плав scale for bump map luminance */
    D3DTSS_BUMPENVLOFFSET = 23, /* плав смещение for bump map luminance */
    D3DTSS_TEXTURETRANSFORMFLAGS = 24, /* D3DTEXTURETRANSFORMFLAGS controls texture transform */
    D3DTSS_COLORARG0      = 26, /* D3DTA_* third arg for triadic ops */
    D3DTSS_ALPHAARG0      = 27, /* D3DTA_* third arg for triadic ops */
    D3DTSS_RESULTARG      = 28, /* D3DTA_* arg for рез (CURRENT or TEMP) */
    D3DTSS_CONSTANT       = 32  /* Per-stage constant D3DTA_CONSTANT */
}


/*
 * State enumerants for per-sampler texture processing.
 */
alias бцел D3DSAMPLERSTATETYPE;
enum : D3DSAMPLERSTATETYPE {
    D3DSAMP_ADDRESSU       = 1,  /* D3DTEXTUREADDRESS for U coordinate */
    D3DSAMP_ADDRESSV       = 2,  /* D3DTEXTUREADDRESS for V coordinate */
    D3DSAMP_ADDRESSW       = 3,  /* D3DTEXTUREADDRESS for W coordinate */
    D3DSAMP_BORDERCOLOR    = 4,  /* D3DCOLOR */
    D3DSAMP_MAGFILTER      = 5,  /* D3DTEXTUREFILTER filter to use for magnification */
    D3DSAMP_MINFILTER      = 6,  /* D3DTEXTUREFILTER filter to use for minification */
    D3DSAMP_MIPFILTER      = 7,  /* D3DTEXTUREFILTER filter to use between mipmaps during minification */
    D3DSAMP_MIPMAPLODBIAS  = 8,  /* плав Mipmap LOD bias */
    D3DSAMP_MAXMIPLEVEL    = 9,  /* DWORD 0..(n-1) LOD индекс of largest map to use (0 == largest) */
    D3DSAMP_MAXANISOTROPY  = 10, /* DWORD maximum anisotropy */
    D3DSAMP_SRGBTEXTURE    = 11, /* Default = 0 (which means Gamma 1.0,
                                   no correction required.) else correct for
                                   Gamma = 2.2 */
    D3DSAMP_ELEMENTINDEX   = 12, /* When multi-element texture is assigned to sampler, this
                                    indicates which element индекс to use.  Default = 0.  */
    D3DSAMP_DMAPOFFSET     = 13  /* Offset in vertices in the pre-sampled displacement map.
                                    Only valid for D3DDMAPSAMPLER sampler  */
}


/* Special sampler which is used in the tesselator */
const D3DDMAPSAMPLER = 256;

// Samplers used in vertex shaders
const D3DVERTEXTEXTURESAMPLER0 = (D3DDMAPSAMPLER+1);
const D3DVERTEXTEXTURESAMPLER1 = (D3DDMAPSAMPLER+2);
const D3DVERTEXTEXTURESAMPLER2 = (D3DDMAPSAMPLER+3);
const D3DVERTEXTEXTURESAMPLER3 = (D3DDMAPSAMPLER+4);

// Values, used with D3DTSS_TEXCOORDINDEX, to specify that the vertex данные(позиция
// and normal in the camera space) should be taken as texture coordinates
// Low 16 bits are used to specify texture coordinate индекс, to take the WRAP mode from
//
const D3DTSS_TCI_PASSTHRU = 0x00000000;
const D3DTSS_TCI_CAMERASPACENORMAL = 0x00010000;
const D3DTSS_TCI_CAMERASPACEPOSITION = 0x00020000;
const D3DTSS_TCI_CAMERASPACEREFLECTIONVECTOR = 0x00030000;
const D3DTSS_TCI_SPHEREMAP = 0x00040000;

/*
 * Enumerations for COLOROP and ALPHAOP texture blending operations set in
 * texture processing stage controls in D3DTSS.
 */
alias бцел D3DTEXTUREOP;
enum : D3DTEXTUREOP {
    // Control
    D3DTOP_DISABLE              = 1,      // disables stage
    D3DTOP_SELECTARG1           = 2,      // the default
    D3DTOP_SELECTARG2           = 3,

    // Modulate
    D3DTOP_MODULATE             = 4,      // multiply арги together
    D3DTOP_MODULATE2X           = 5,      // multiply and  1 bit
    D3DTOP_MODULATE4X           = 6,      // multiply and  2 bits

    // Add
    D3DTOP_ADD                  =  7,   // добавь arguments together
    D3DTOP_ADDSIGNED            =  8,   // добавь with -0.5 bias
    D3DTOP_ADDSIGNED2X          =  9,   // as above but лево  1 bit
    D3DTOP_SUBTRACT             = 10,   // Arg1 - Arg2, with no saturation
    D3DTOP_ADDSMOOTH            = 11,   // добавь 2 арги, subtract product
                                        // Arg1 + Arg2 - Arg1*Arg2
                                        // = Arg1 + (1-Arg1)*Arg2

    // Linear alpha blend: Arg1*(Alpha) + Arg2*(1-Alpha)
    D3DTOP_BLENDDIFFUSEALPHA    = 12, // iterated alpha
    D3DTOP_BLENDTEXTUREALPHA    = 13, // texture alpha
    D3DTOP_BLENDFACTORALPHA     = 14, // alpha from D3DRS_TEXTUREFACTOR

    // Linear alpha blend with pre-multiplied arg1 ввод: Arg1 + Arg2*(1-Alpha)
    D3DTOP_BLENDTEXTUREALPHAPM  = 15, // texture alpha
    D3DTOP_BLENDCURRENTALPHA    = 16, // by alpha of current color

    // Specular mapping
    D3DTOP_PREMODULATE            = 17,     // modulate with next texture before use
    D3DTOP_MODULATEALPHA_ADDCOLOR = 18,     // Arg1.RGB + Arg1.A*Arg2.RGB
                                            // COLOROP only
    D3DTOP_MODULATECOLOR_ADDALPHA = 19,     // Arg1.RGB*Arg2.RGB + Arg1.A
                                            // COLOROP only
    D3DTOP_MODULATEINVALPHA_ADDCOLOR = 20,  // (1-Arg1.A)*Arg2.RGB + Arg1.RGB
                                            // COLOROP only
    D3DTOP_MODULATEINVCOLOR_ADDALPHA = 21,  // (1-Arg1.RGB)*Arg2.RGB + Arg1.A
                                            // COLOROP only

    // Bump mapping
    D3DTOP_BUMPENVMAP           = 22, // per pixel env map perturbation
    D3DTOP_BUMPENVMAPLUMINANCE  = 23, // with luminance channel

    // This can do either diffuse or specular bump mapping with correct ввод.
    // Performs the function (Arg1.R*Arg2.R + Arg1.G*Arg2.G + Arg1.B*Arg2.B)
    // where each component has been scaled and смещение to make it signed.
    // The рез is replicated into all four (including alpha) channels.
    // This is a valid COLOROP only.
    D3DTOP_DOTPRODUCT3          = 24,

    // Triadic ops
    D3DTOP_MULTIPLYADD          = 25, // Arg0 + Arg1*Arg2
    D3DTOP_LERP                 = 26  // (Arg0)*Arg1 + (1-Arg0)*Arg2
}


/*
 * Values for COLORARG0,1,2, ALPHAARG0,1,2, and RESULTARG texture blending
 * operations set in texture processing stage controls in D3DRENDERSTATE.
 */
const D3DTA_SELECTMASK = 0x0000000f;  // mask for arg selector
const D3DTA_DIFFUSE = 0x00000000;  // select diffuse color (читай only)
const D3DTA_CURRENT = 0x00000001;  // select stage destination register (читай/пиши)
const D3DTA_TEXTURE = 0x00000002;  // select texture color (читай only)
const D3DTA_TFACTOR = 0x00000003;  // select D3DRS_TEXTUREFACTOR (читай only)
const D3DTA_SPECULAR = 0x00000004;  // select specular color (читай only)
const D3DTA_TEMP = 0x00000005;  // select temporary register color (читай/пиши)
const D3DTA_CONSTANT = 0x00000006;  // select texture stage constant
const D3DTA_COMPLEMENT = 0x00000010;  // take 1.0 - x (читай modifier)
const D3DTA_ALPHAREPLICATE = 0x00000020;  // replicate alpha to color компоненты (читай modifier)

//
// Values for D3DSAMP_***FILTER texture stage states
//
alias бцел D3DTEXTUREFILTERTYPE;
enum : D3DTEXTUREFILTERTYPE {
    D3DTEXF_NONE            = 0,    // filtering disabled (valid for mip filter only)
    D3DTEXF_POINT           = 1,    // nearest
    D3DTEXF_LINEAR          = 2,    // linear interpolation
    D3DTEXF_ANISOTROPIC     = 3,    // anisotropic
    D3DTEXF_PYRAMIDALQUAD   = 6,    // 4-sample tent
    D3DTEXF_GAUSSIANQUAD    = 7,    // 4-sample gaussian
    D3DTEXF_CONVOLUTIONMONO = 8    // Convolution filter for monochrome textures
}


/* Bits for Flags in ProcessVertices call */

const D3DPV_DONOTCOPYDATA = (1 << 0);

//-------------------------------------------------------------------

// Flexible vertex format bits
//
const D3DFVF_RESERVED0 = 0x001;
const D3DFVF_POSITION_MASK = 0x400E;
const D3DFVF_XYZ = 0x002;
const D3DFVF_XYZRHW = 0x004;
const D3DFVF_XYZB1 = 0x006;
const D3DFVF_XYZB2 = 0x008;
const D3DFVF_XYZB3 = 0x00a;
const D3DFVF_XYZB4 = 0x00c;
const D3DFVF_XYZB5 = 0x00e;
const D3DFVF_XYZW = 0x4002;

const D3DFVF_NORMAL = 0x010;
const D3DFVF_PSIZE = 0x020;
const D3DFVF_DIFFUSE = 0x040;
const D3DFVF_SPECULAR = 0x080;

const D3DFVF_TEXCOUNT_MASK = 0xf00;
const D3DFVF_TEXCOUNT_ШИФТ = 8;
const D3DFVF_TEX0 = 0x000;
const D3DFVF_TEX1 = 0x100;
const D3DFVF_TEX2 = 0x200;
const D3DFVF_TEX3 = 0x300;
const D3DFVF_TEX4 = 0x400;
const D3DFVF_TEX5 = 0x500;
const D3DFVF_TEX6 = 0x600;
const D3DFVF_TEX7 = 0x700;
const D3DFVF_TEX8 = 0x800;

const D3DFVF_LASTBETA_UBYTE4 = 0x1000;
const D3DFVF_LASTBETA_D3DCOLOR = 0x8000;

const D3DFVF_RESERVED2 = 0x6000;  // 2 reserved bits

//---------------------------------------------------------------------
// Vertex Shaders
//

// Vertex shader declaration

// Vertex element semantics
//
alias бцел D3DDECLUSAGE;
enum : D3DDECLUSAGE {
    D3DDECLUSAGE_POSITION = 0,
    D3DDECLUSAGE_BLENDWEIGHT,   // 1
    D3DDECLUSAGE_BLENDINDICES,  // 2
    D3DDECLUSAGE_NORMAL,        // 3
    D3DDECLUSAGE_PSIZE,         // 4
    D3DDECLUSAGE_TEXCOORD,      // 5
    D3DDECLUSAGE_TANGENT,       // 6
    D3DDECLUSAGE_BINORMAL,      // 7
    D3DDECLUSAGE_TESSFACTOR,    // 8
    D3DDECLUSAGE_POSITIONT,     // 9
    D3DDECLUSAGE_COLOR,         // 10
    D3DDECLUSAGE_FOG,           // 11
    D3DDECLUSAGE_DEPTH,         // 12
    D3DDECLUSAGE_SAMPLE         // 13
}


const MAXD3DDECLUSAGE = D3DDECLUSAGE_SAMPLE;
const MAXD3DDECLUSAGEINDEX = 15;
const MAXD3DDECLLENGTH = 64; // does not include "end" marker vertex element

alias бцел D3DDECLMETHOD;
enum : D3DDECLMETHOD {
    D3DDECLMETHOD_DEFAULT = 0,
    D3DDECLMETHOD_PARTIALU,
    D3DDECLMETHOD_PARTIALV,
    D3DDECLMETHOD_CROSSUV,    // Normal
    D3DDECLMETHOD_UV,
    D3DDECLMETHOD_LOOKUP,               // Lookup a displacement map
    D3DDECLMETHOD_LOOKUPPRESAMPLED      // Lookup a pre-sampled displacement map
}


const MAXD3DDECLMETHOD = D3DDECLMETHOD_LOOKUPPRESAMPLED;

// Declarations for _Type fields
//
alias бцел D3DDECLTYPE;
enum : D3DDECLTYPE {
    D3DDECLTYPE_FLOAT1    =  0,  // 1D плав expanded to (значение, 0., 0., 1.)
    D3DDECLTYPE_FLOAT2    =  1,  // 2D плав expanded to (значение, значение, 0., 1.)
    D3DDECLTYPE_FLOAT3    =  2,  // 3D плав expanded to (значение, значение, значение, 1.)
    D3DDECLTYPE_FLOAT4    =  3,  // 4D плав
    D3DDECLTYPE_D3DCOLOR  =  4,  // 4D packed unsigned bytes mapped to 0. to 1. охват
                                 // Input is in D3DCOLOR format (ARGB) expanded to (R, G, B, A)
    D3DDECLTYPE_UBYTE4    =  5,  // 4D unsigned byte
    D3DDECLTYPE_SHORT2    =  6,  // 2D signed крат expanded to (значение, значение, 0., 1.)
    D3DDECLTYPE_SHORT4    =  7,  // 4D signed крат

// The following types are valid only with vertex shaders >= 2.0


    D3DDECLTYPE_UBYTE4N   =  8,  // Each of 4 bytes is normalized by dividing to 255.0
    D3DDECLTYPE_SHORT2N   =  9,  // 2D signed крат normalized (v[0]/32767.0,v[1]/32767.0,0,1)
    D3DDECLTYPE_SHORT4N   = 10,  // 4D signed крат normalized (v[0]/32767.0,v[1]/32767.0,v[2]/32767.0,v[3]/32767.0)
    D3DDECLTYPE_USHORT2N  = 11,  // 2D unsigned крат normalized (v[0]/65535.0,v[1]/65535.0,0,1)
    D3DDECLTYPE_USHORT4N  = 12,  // 4D unsigned крат normalized (v[0]/65535.0,v[1]/65535.0,v[2]/65535.0,v[3]/65535.0)
    D3DDECLTYPE_UDEC3     = 13,  // 3D unsigned 10 10 10 format expanded to (значение, значение, значение, 1)
    D3DDECLTYPE_DEC3N     = 14,  // 3D signed 10 10 10 format normalized and expanded to (v[0]/511.0, v[1]/511.0, v[2]/511.0, 1)
    D3DDECLTYPE_FLOAT16_2 = 15,  // Two 16-bit floating point значения, expanded to (значение, значение, 0, 1)
    D3DDECLTYPE_FLOAT16_4 = 16,  // Four 16-bit floating point значения
    D3DDECLTYPE_UNUSED    = 17   // When the тип поле in a decl is unused.
}


const MAXD3DDECLTYPE = D3DDECLTYPE_UNUSED;

struct D3DVERTEXELEMENT9
{
    бкрат    Поток;     // Поток индекс
    бкрат    Offset;     // Offset in the stream in bytes
    ббайт    Type;       // Data тип
    ббайт    Method;     // Processing method
    ббайт    Usage;      // Semantics
    ббайт    UsageIndex; // Semantic индекс
}
alias D3DVERTEXELEMENT9 *LPD3DVERTEXELEMENT9;

// This is used to иниц the last vertex element in a vertex declaration
// array
//
template D3DDECL_END() {
    static const D3DVERTEXELEMENT9 D3DDECL_END = { 0xFF,0,D3DDECLTYPE_UNUSED,0,0,0 };
}

// Maximum supported number of texture coordinate sets
const D3DDP_MAXTEXCOORD = 8;

//---------------------------------------------------------------------
// Values for IDirect3DDevice9::SetStreamSourceFreq's Setting parameter
//---------------------------------------------------------------------
const D3DSTREAMSOURCE_INDEXEDDATA = (1<<30);
const D3DSTREAMSOURCE_INSTANCEDATA = (2<<30);



//---------------------------------------------------------------------
//
// The internal format of Pixel Shader (PS) & Vertex Shader (VS)
// Instruction Tokens is defined in the Direct3D Device Driver Kit
//
//---------------------------------------------------------------------

//
// Instruction Token Bit Definitions
//
const D3DSI_OPCODE_MASK = 0x0000FFFF;

const D3DSI_INSTLENGTH_MASK = 0x0F000000;
const D3DSI_INSTLENGTH_ШИФТ = 24;

enum : D3DSHADER_INSTRUCTION_OPCODE_TYPE {
    D3DSIO_NOP          = 0,
    D3DSIO_MOV          ,
    D3DSIO_ADD          ,
    D3DSIO_SUB          ,
    D3DSIO_MAD          ,
    D3DSIO_MUL          ,
    D3DSIO_RCP          ,
    D3DSIO_RSQ          ,
    D3DSIO_DP3          ,
    D3DSIO_DP4          ,
    D3DSIO_MIN          ,
    D3DSIO_MAX          ,
    D3DSIO_SLT          ,
    D3DSIO_SGE          ,
    D3DSIO_EXP          ,
    D3DSIO_LOG          ,
    D3DSIO_LIT          ,
    D3DSIO_DST          ,
    D3DSIO_LRP          ,
    D3DSIO_FRC          ,
    D3DSIO_M4x4         ,
    D3DSIO_M4x3         ,
    D3DSIO_M3x4         ,
    D3DSIO_M3x3         ,
    D3DSIO_M3x2         ,
    D3DSIO_CALL         ,
    D3DSIO_CALLNZ       ,
    D3DSIO_LOOP         ,
    D3DSIO_RET          ,
    D3DSIO_ENDLOOP      ,
    D3DSIO_LABEL        ,
    D3DSIO_DCL          ,
    D3DSIO_POW          ,
    D3DSIO_CRS          ,
    D3DSIO_SGN          ,
    D3DSIO_ABS          ,
    D3DSIO_NRM          ,
    D3DSIO_SINCOS       ,
    D3DSIO_REP          ,
    D3DSIO_ENDREP       ,
    D3DSIO_IF           ,
    D3DSIO_IFC          ,
    D3DSIO_ELSE         ,
    D3DSIO_ENDIF        ,
    D3DSIO_BREAK        ,
    D3DSIO_BREAKC       ,
    D3DSIO_MOVA         ,
    D3DSIO_DEFB         ,
    D3DSIO_DEFI         ,

    D3DSIO_TEXCOORD     = 64,
    D3DSIO_TEXKILL      ,
    D3DSIO_TEX          ,
    D3DSIO_TEXBEM       ,
    D3DSIO_TEXBEML      ,
    D3DSIO_TEXREG2AR    ,
    D3DSIO_TEXREG2GB    ,
    D3DSIO_TEXM3x2PAD   ,
    D3DSIO_TEXM3x2TEX   ,
    D3DSIO_TEXM3x3PAD   ,
    D3DSIO_TEXM3x3TEX   ,
    D3DSIO_RESERVED0    ,
    D3DSIO_TEXM3x3SPEC  ,
    D3DSIO_TEXM3x3VSPEC ,
    D3DSIO_EXPP         ,
    D3DSIO_LOGP         ,
    D3DSIO_CND          ,
    D3DSIO_DEF          ,
    D3DSIO_TEXREG2RGB   ,
    D3DSIO_TEXDP3TEX    ,
    D3DSIO_TEXM3x2DEPTH ,
    D3DSIO_TEXDP3       ,
    D3DSIO_TEXM3x3      ,
    D3DSIO_TEXDEPTH     ,
    D3DSIO_CMP          ,
    D3DSIO_BEM          ,
    D3DSIO_DP2ADD       ,
    D3DSIO_DSX          ,
    D3DSIO_DSY          ,
    D3DSIO_TEXLDD       ,
    D3DSIO_SETP         ,
    D3DSIO_TEXLDL       ,
    D3DSIO_BREAKP       ,

    D3DSIO_PHASE        = 0xFFFD,
    D3DSIO_COMMENT      = 0xFFFE,
    D3DSIO_END          = 0xFFFF
}
alias бцел D3DSHADER_INSTRUCTION_OPCODE_TYPE;

//---------------------------------------------------------------------
// Use these constants with D3DSIO_SINCOS macro as SRC2, SRC3
//
const плав[4] D3DSINCOSCONST1 = [-1.5500992e-006f, -2.1701389e-005f,  0.0026041667f, 0.00026041668f];
const плав[4] D3DSINCOSCONST2 = [-0.020833334f, -0.12500000f, 1.0f, 0.50000000f];

//---------------------------------------------------------------------
// Co-Issue Instruction Modifier - if set then this instruction is to be
// issued in parallel with the previous instruction(s) for which this bit
// is not set.
//
const D3DSI_COISSUE = 0x40000000;

//---------------------------------------------------------------------
// Opcode specific controls

const D3DSP_OPCODESPECIFICCONTROL_MASK = 0x00ff0000;
const D3DSP_OPCODESPECIFICCONTROL_ШИФТ = 16;

// ps_2_0 texld controls
const D3DSI_TEXLD_PROJECT = (0x01 << D3DSP_OPCODESPECIFICCONTROL_ШИФТ);
const D3DSI_TEXLD_BIAS = (0x02 << D3DSP_OPCODESPECIFICCONTROL_ШИФТ);

// Сравнение for dynamic conditional instruction opcodes (i.e. if, breakc)
enum : D3DSHADER_COMPARISON {
                         // < = >
    D3DSPC_RESERVED0= 0, // 0 0 0
    D3DSPC_GT       = 1, // 0 0 1
    D3DSPC_EQ       = 2, // 0 1 0
    D3DSPC_GE       = 3, // 0 1 1
    D3DSPC_LT       = 4, // 1 0 0
    D3DSPC_NE       = 5, // 1 0 1
    D3DSPC_LE       = 6, // 1 1 0
    D3DSPC_RESERVED1= 7  // 1 1 1
}
alias бцел D3DSHADER_COMPARISON;

// Сравнение is part of instruction opcode token:
const D3DSHADER_COMPARISON_ШИФТ = D3DSP_OPCODESPECIFICCONTROL_ШИФТ;
const D3DSHADER_COMPARISON_MASK = (0x7<<D3DSHADER_COMPARISON_ШИФТ);

//---------------------------------------------------------------------
// Predication флаги on instruction token
const D3DSHADER_INSTRUCTION_PREDICATED = (0x1 << 28);

//---------------------------------------------------------------------
// DCL Info Token Controls

// For dcl info tokens requiring a semantic (usage + индекс)
const D3DSP_DCL_USAGE_ШИФТ = 0;
const D3DSP_DCL_USAGE_MASK = 0x0000000f;

const D3DSP_DCL_USAGEINDEX_ШИФТ = 16;
const D3DSP_DCL_USAGEINDEX_MASK = 0x000f0000;

// DCL pixel shader sampler info token.
const D3DSP_TEXTURETYPE_ШИФТ = 27;
const D3DSP_TEXTURETYPE_MASK = 0x78000000;

enum : D3DSAMPLER_TEXTURE_TYPE {
    D3DSTT_UNKNOWN = 0<<D3DSP_TEXTURETYPE_ШИФТ, // uninitialized значение
    D3DSTT_2D      = 2<<D3DSP_TEXTURETYPE_ШИФТ, // dcl_2d s# (for declaring a 2-D texture)
    D3DSTT_CUBE    = 3<<D3DSP_TEXTURETYPE_ШИФТ, // dcl_cube s# (for declaring a cube texture)
    D3DSTT_VOLUME  = 4<<D3DSP_TEXTURETYPE_ШИФТ  // dcl_volume s# (for declaring a volume texture)
}
alias бцел D3DSAMPLER_TEXTURE_TYPE;

//---------------------------------------------------------------------
// Parameter Token Bit Definitions
//
const D3DSP_REGNUM_MASK = 0x000007FF;

// destination parameter пиши mask
const D3DSP_WRITEMASK_0 = 0x00010000;  // Component 0 (X;Red)
const D3DSP_WRITEMASK_1 = 0x00020000;  // Component 1 (Y;Green)
const D3DSP_WRITEMASK_2 = 0x00040000;  // Component 2 (Z;Blue)
const D3DSP_WRITEMASK_3 = 0x00080000;  // Component 3 (W;Alpha)
const D3DSP_WRITEMASK_ALL = 0x000F0000;  // All Components

// destination parameter modifiers
const D3DSP_DSTMOD_ШИФТ = 20;
const D3DSP_DSTMOD_MASK = 0x00F00000;

// Bit masks for destination parameter modifiers
const D3DSPDM_NONE = (0<<D3DSP_DSTMOD_ШИФТ); // nop
const D3DSPDM_SATURATE = (1<<D3DSP_DSTMOD_ШИФТ); // clamp to 0. to 1. охват
const D3DSPDM_PARTIALPRECISION = (2<<D3DSP_DSTMOD_ШИФТ); // Partial precision hint
const D3DSPDM_MSAMPCENTROID = (4<<D3DSP_DSTMOD_ШИФТ); // Relevant to multisampling only:
                                                                //      When the pixel center is not covered, sample
                                                                //      attribute or compute gradients/LOD
                                                                //      using multisample "centroid" положение.
                                                                //      "Centroid" is some положение within the covered
                                                                //      region of the pixel.

// destination parameter 
const D3DSP_DSTШИФТ_ШИФТ = 24;
const D3DSP_DSTШИФТ_MASK = 0x0F000000;

// destination/исток parameter register тип
const D3DSP_REGTYPE_ШИФТ = 28;
const D3DSP_REGTYPE_ШИФТ2 = 8;
const D3DSP_REGTYPE_MASK = 0x70000000;
const D3DSP_REGTYPE_MASK2 = 0x00001800;

enum : D3DSHADER_PARAM_REGISTER_TYPE {
    D3DSPR_TEMP           =  0, // Temporary Register Файл
    D3DSPR_INPUT          =  1, // Input Register Файл
    D3DSPR_CONST          =  2, // Constant Register Файл
    D3DSPR_ADDR           =  3, // Адрес Register (VS)
    D3DSPR_TEXTURE        =  3, // Texture Register Файл (PS)
    D3DSPR_RASTOUT        =  4, // Rasterizer Register Файл
    D3DSPR_ATTROUT        =  5, // Attribute Output Register Файл
    D3DSPR_TEXCRDOUT      =  6, // Texture Coordinate Output Register Файл
    D3DSPR_OUTPUT         =  6, // Output register file for VS3.0+
    D3DSPR_CONSTINT       =  7, // Constant Integer Vector Register Файл
    D3DSPR_COLOROUT       =  8, // Color Output Register Файл
    D3DSPR_DEPTHOUT       =  9, // Depth Output Register Файл
    D3DSPR_SAMPLER        = 10, // Sampler State Register Файл
    D3DSPR_CONST2         = 11, // Constant Register Файл  2048 - 4095
    D3DSPR_CONST3         = 12, // Constant Register Файл  4096 - 6143
    D3DSPR_CONST4         = 13, // Constant Register Файл  6144 - 8191
    D3DSPR_CONSTBOOL      = 14, // Constant Boolean register file
    D3DSPR_LOOP           = 15, // Loop counter register file
    D3DSPR_TEMPFLOAT16    = 16, // 16-bit плав времн register file
    D3DSPR_MISCTYPE       = 17, // Miscellaneous (single) registers.
    D3DSPR_LABEL          = 18, // Label
    D3DSPR_PREDICATE      = 19  // Предикат register
}
alias бцел D3DSHADER_PARAM_REGISTER_TYPE;

// The miscellaneous register file (D3DSPR_MISCTYPES)
// содержит register types for which there is only ever one
// register (i.e. the register # is not needed).
// Rather than use up additional register types for such
// registers, they are defined
// as particular offsets into the misc. register file:
enum : D3DSHADER_MISCTYPE_OFFSETS {
    D3DSMO_POSITION   = 0, // Input позиция x,y,z,rhw (PS)
    D3DSMO_FACE   = 1, // Floating point primitive area (PS)
}
alias бцел D3DSHADER_MISCTYPE_OFFSETS;

// Register offsets in the Rasterizer Register Файл
//
enum : D3DVS_RASTOUT_OFFSETS {
    D3DSRO_POSITION = 0,
    D3DSRO_FOG,
    D3DSRO_POINT_SIZE
}
alias бцел D3DVS_RASTOUT_OFFSETS;

// Source operand addressing modes

const D3DVS_ADDRESSMODE_ШИФТ = 13;
const D3DVS_ADDRESSMODE_MASK = (1 << D3DVS_ADDRESSMODE_ШИФТ);

enum : D3DVS_ADDRESSMODE_TYPE {
    D3DVS_ADDRMODE_ABSOLUTE  = (0 << D3DVS_ADDRESSMODE_ШИФТ),
    D3DVS_ADDRMODE_RELATIVE  = (1 << D3DVS_ADDRESSMODE_ШИФТ)
}
alias бцел D3DVS_ADDRESSMODE_TYPE;

const D3DSHADER_ADDRESSMODE_ШИФТ = 13;
const D3DSHADER_ADDRESSMODE_MASK = (1 << D3DSHADER_ADDRESSMODE_ШИФТ);

enum : D3DSHADER_ADDRESSMODE_TYPE {
    D3DSHADER_ADDRMODE_ABSOLUTE  = (0 << D3DSHADER_ADDRESSMODE_ШИФТ),
    D3DSHADER_ADDRMODE_RELATIVE  = (1 << D3DSHADER_ADDRESSMODE_ШИФТ)
}
alias бцел D3DSHADER_ADDRESSMODE_TYPE;

// Source operand swizzle definitions
//
const D3DVS_SWIZZLE_ШИФТ = 16;
const D3DVS_SWIZZLE_MASK = 0x00FF0000;

// The following bits define where to take component X from:

const D3DVS_X_X = (0<<D3DVS_SWIZZLE_ШИФТ);
const D3DVS_X_Y = (1<<D3DVS_SWIZZLE_ШИФТ);
const D3DVS_X_Z = (2<<D3DVS_SWIZZLE_ШИФТ);
const D3DVS_X_W = (3<<D3DVS_SWIZZLE_ШИФТ);

// The following bits define where to take component Y from:

const D3DVS_Y_X = (0<<(D3DVS_SWIZZLE_ШИФТ+2));
const D3DVS_Y_Y = (1<<(D3DVS_SWIZZLE_ШИФТ+2));
const D3DVS_Y_Z = (2<<(D3DVS_SWIZZLE_ШИФТ+2));
const D3DVS_Y_W = (3<<(D3DVS_SWIZZLE_ШИФТ+2));

// The following bits define where to take component Z from:

const D3DVS_Z_X = (0<<(D3DVS_SWIZZLE_ШИФТ+4));
const D3DVS_Z_Y = (1<<(D3DVS_SWIZZLE_ШИФТ+4));
const D3DVS_Z_Z = (2<<(D3DVS_SWIZZLE_ШИФТ+4));
const D3DVS_Z_W = (3<<(D3DVS_SWIZZLE_ШИФТ+4));

// The following bits define where to take component W from:

const D3DVS_W_X = (0<<(D3DVS_SWIZZLE_ШИФТ+6));
const D3DVS_W_Y = (1<<(D3DVS_SWIZZLE_ШИФТ+6));
const D3DVS_W_Z = (2<<(D3DVS_SWIZZLE_ШИФТ+6));
const D3DVS_W_W = (3<<(D3DVS_SWIZZLE_ШИФТ+6));

// Value when there is no swizzle (X is taken from X, Y is taken from Y,
// Z is taken from Z, W is taken from W
//
const D3DVS_NOSWIZZLE = (D3DVS_X_X|D3DVS_Y_Y|D3DVS_Z_Z|D3DVS_W_W);

// исток parameter swizzle
const D3DSP_SWIZZLE_ШИФТ = 16;
const D3DSP_SWIZZLE_MASK = 0x00FF0000;

const D3DSP_NOSWIZZLE = ( (0 << (D3DSP_SWIZZLE_ШИФТ + 0)) |
      (1 << (D3DSP_SWIZZLE_ШИФТ + 2)) |
      (2 << (D3DSP_SWIZZLE_ШИФТ + 4)) |
      (3 << (D3DSP_SWIZZLE_ШИФТ + 6)) );

// pixel-shader swizzle ops
const D3DSP_REPLICATERED =
    ( (0 << (D3DSP_SWIZZLE_ШИФТ + 0)) |
      (0 << (D3DSP_SWIZZLE_ШИФТ + 2)) |
      (0 << (D3DSP_SWIZZLE_ШИФТ + 4)) |
      (0 << (D3DSP_SWIZZLE_ШИФТ + 6)) );

const D3DSP_REPLICATEGREEN =
    ( (1 << (D3DSP_SWIZZLE_ШИФТ + 0)) |
      (1 << (D3DSP_SWIZZLE_ШИФТ + 2)) |
      (1 << (D3DSP_SWIZZLE_ШИФТ + 4)) |
      (1 << (D3DSP_SWIZZLE_ШИФТ + 6)) );

const D3DSP_REPLICATEBLUE =
    ( (2 << (D3DSP_SWIZZLE_ШИФТ + 0)) |
      (2 << (D3DSP_SWIZZLE_ШИФТ + 2)) |
      (2 << (D3DSP_SWIZZLE_ШИФТ + 4)) |
      (2 << (D3DSP_SWIZZLE_ШИФТ + 6)) );

const D3DSP_REPLICATEALPHA =
    ( (3 << (D3DSP_SWIZZLE_ШИФТ + 0)) |
      (3 << (D3DSP_SWIZZLE_ШИФТ + 2)) |
      (3 << (D3DSP_SWIZZLE_ШИФТ + 4)) |
      (3 << (D3DSP_SWIZZLE_ШИФТ + 6)) );

// исток parameter modifiers
const D3DSP_SRCMOD_ШИФТ = 24;
const D3DSP_SRCMOD_MASK = 0x0F000000;

enum : D3DSHADER_PARAM_SRCMOD_TYPE {
    D3DSPSM_NONE    = 0<<D3DSP_SRCMOD_ШИФТ, // nop
    D3DSPSM_NEG     = 1<<D3DSP_SRCMOD_ШИФТ, // negate
    D3DSPSM_BIAS    = 2<<D3DSP_SRCMOD_ШИФТ, // bias
    D3DSPSM_BIASNEG = 3<<D3DSP_SRCMOD_ШИФТ, // bias and negate
    D3DSPSM_SIGN    = 4<<D3DSP_SRCMOD_ШИФТ, // sign
    D3DSPSM_SIGNNEG = 5<<D3DSP_SRCMOD_ШИФТ, // sign and negate
    D3DSPSM_COMP    = 6<<D3DSP_SRCMOD_ШИФТ, // complement
    D3DSPSM_X2      = 7<<D3DSP_SRCMOD_ШИФТ, // *2
    D3DSPSM_X2NEG   = 8<<D3DSP_SRCMOD_ШИФТ, // *2 and negate
    D3DSPSM_DZ      = 9<<D3DSP_SRCMOD_ШИФТ, // divide through by z component
    D3DSPSM_DW      = 10<<D3DSP_SRCMOD_ШИФТ, // divide through by w component
    D3DSPSM_ABS     = 11<<D3DSP_SRCMOD_ШИФТ, // абс()
    D3DSPSM_ABSNEG  = 12<<D3DSP_SRCMOD_ШИФТ, // -абс()
    D3DSPSM_NOT     = 13<<D3DSP_SRCMOD_ШИФТ  // for predicate register: "!p0"
}
alias бцел D3DSHADER_PARAM_SRCMOD_TYPE;

// pixel shader version token
бцел D3DPS_VERSION(ббайт _Major, ббайт _Minor) { return (0xFFFF0000|(_Major<<8)|_Minor); }

// vertex shader version token
бцел D3DVS_VERSION(ббайт _Major, ббайт _Minor) { return (0xFFFE0000|(_Major<<8)|_Minor); }

// extract major/minor from version cap
ббайт D3DSHADER_VERSION_MAJOR(бцел _Version) { return cast(ббайт)((_Version>>8)&0xFF); }
ббайт D3DSHADER_VERSION_MINOR(бцел _Version) { return cast(ббайт)((_Version>>0)&0xFF); }

// destination/исток parameter register тип
const D3DSI_COMMENTSIZE_ШИФТ = 16;
const D3DSI_COMMENTSIZE_MASK = 0x7FFF0000;
бцел D3DSHADER_COMMENT(бкрат _DWordSize) { return (((_DWordSize<<D3DSI_COMMENTSIZE_ШИФТ)&D3DSI_COMMENTSIZE_MASK)|D3DSIO_COMMENT); }

// pixel/vertex shader end token
const D3DPS_END = 0x0000FFFF;
const D3DVS_END = 0x0000FFFF;


//---------------------------------------------------------------------

// High order surfaces
//
enum : D3DBASISTYPE {
   D3DBASIS_BEZIER      = 0,
   D3DBASIS_BSPLINE     = 1,
   D3DBASIS_CATMULL_ROM = 2  /* In D3D8 this used to be D3DBASIS_INTERPOLATE */
}
alias бцел D3DBASISTYPE;

enum : D3DDEGREETYPE {
   D3DDEGREE_LINEAR      = 1,
   D3DDEGREE_QUADRATIC   = 2,
   D3DDEGREE_CUBIC       = 3,
   D3DDEGREE_QUINTIC     = 5
}
alias бцел D3DDEGREETYPE;

enum : D3DPATCHEDGESTYLE {
   D3DPATCHEDGE_DISCRETE    = 0,
   D3DPATCHEDGE_CONTINUOUS  = 1
}
alias бцел D3DPATCHEDGESTYLE;

enum : D3DSTATEBLOCKTYPE {
    D3DSBT_ALL           = 1, // capture all state
    D3DSBT_PIXELSTATE    = 2, // capture pixel state
    D3DSBT_VERTEXSTATE   = 3  // capture vertex state
}
alias бцел D3DSTATEBLOCKTYPE;

// The D3DVERTEXBLENDFLAGS тип is used with D3DRS_VERTEXBLEND state.
//
enum : D3DVERTEXBLENDFLAGS {
    D3DVBF_DISABLE  = 0,     // Disable vertex blending
    D3DVBF_1WEIGHTS = 1,     // 2 matrix blending
    D3DVBF_2WEIGHTS = 2,     // 3 matrix blending
    D3DVBF_3WEIGHTS = 3,     // 4 matrix blending
    D3DVBF_TWEENING = 255,   // blending using D3DRS_TWEENFACTOR
    D3DVBF_0WEIGHTS = 256    // one matrix is used with weight 1.0
}
alias бцел D3DVERTEXBLENDFLAGS;

enum : D3DTEXTURETRANSFORMFLAGS {
    D3DTTFF_DISABLE         = 0,    // texture coordinates are passed directly
    D3DTTFF_COUNT1          = 1,    // rasterizer should expect 1-D texture coords
    D3DTTFF_COUNT2          = 2,    // rasterizer should expect 2-D texture coords
    D3DTTFF_COUNT3          = 3,    // rasterizer should expect 3-D texture coords
    D3DTTFF_COUNT4          = 4,    // rasterizer should expect 4-D texture coords
    D3DTTFF_PROJECTED       = 256   // texcoords to be divided by COUNTth element
}
alias бцел D3DTEXTURETRANSFORMFLAGS;

// Macros to set texture coordinate format bits in the FVF id

const D3DFVF_TEXTUREFORMAT2 = 0;         // Two floating point значения
const D3DFVF_TEXTUREFORMAT1 = 3;         // One floating point значение
const D3DFVF_TEXTUREFORMAT3 = 1;         // Three floating point значения
const D3DFVF_TEXTUREFORMAT4 = 2;         // Four floating point значения

бцел D3DFVF_TEXCOORDSIZE3(бцел CoordIndex) { return (D3DFVF_TEXTUREFORMAT3 << (CoordIndex*2 + 16)); }
бцел D3DFVF_TEXCOORDSIZE2(бцел CoordIndex) { return (D3DFVF_TEXTUREFORMAT2); }
бцел D3DFVF_TEXCOORDSIZE4(бцел CoordIndex) { return (D3DFVF_TEXTUREFORMAT4 << (CoordIndex*2 + 16)); }
бцел D3DFVF_TEXCOORDSIZE1(бцел CoordIndex) { return (D3DFVF_TEXTUREFORMAT1 << (CoordIndex*2 + 16)); }


//---------------------------------------------------------------------

/* Direct3D9 Device types */
enum : D3DDEVTYPE {
    D3DDEVTYPE_HAL         = 1,
    D3DDEVTYPE_REF         = 2,
    D3DDEVTYPE_SW          = 3,

    D3DDEVTYPE_NULLREF     = 4
}
alias бцел D3DDEVTYPE;

/* Multi-Sample буфер types */
enum : D3DMULTISAMPLE_TYPE {
    D3DMULTISAMPLE_NONE            =  0,
    D3DMULTISAMPLE_NONMASKABLE     =  1,
    D3DMULTISAMPLE_2_SAMPLES       =  2,
    D3DMULTISAMPLE_3_SAMPLES       =  3,
    D3DMULTISAMPLE_4_SAMPLES       =  4,
    D3DMULTISAMPLE_5_SAMPLES       =  5,
    D3DMULTISAMPLE_6_SAMPLES       =  6,
    D3DMULTISAMPLE_7_SAMPLES       =  7,
    D3DMULTISAMPLE_8_SAMPLES       =  8,
    D3DMULTISAMPLE_9_SAMPLES       =  9,
    D3DMULTISAMPLE_10_SAMPLES      = 10,
    D3DMULTISAMPLE_11_SAMPLES      = 11,
    D3DMULTISAMPLE_12_SAMPLES      = 12,
    D3DMULTISAMPLE_13_SAMPLES      = 13,
    D3DMULTISAMPLE_14_SAMPLES      = 14,
    D3DMULTISAMPLE_15_SAMPLES      = 15,
    D3DMULTISAMPLE_16_SAMPLES      = 16
}
alias бцел D3DMULTISAMPLE_TYPE;

/* Formats
 * Most of these names have the following convention:
 *      A = Alpha
 *      R = Red
 *      G = Green
 *      B = Blue
 *      X = Unused Bits
 *      P = Palette
 *      L = Luminance
 *      U = dU coordinate for BumpMap
 *      V = dV coordinate for BumpMap
 *      S = Stencil
 *      D = Depth (e.g. Z or W буфер)
 *      C = Computed from другой channels (typically on certain читай operations)
 *
 *      Further, the order of the pieces are from MSB first; hence
 *      D3DFMT_A8L8 indicates that the high byte of this two byte
 *      format is alpha.
 *
 *      D3DFMT_D16_LOCKABLE indicates:
 *           - An integer 16-bit значение.
 *           - An app-lockable surface.
 *
 *      D3DFMT_D32F_LOCKABLE indicates:
 *           - An IEEE 754 floating-point значение.
 *           - An app-lockable surface.
 *
 *      All Depth/Stencil форматы except D3DFMT_D16_LOCKABLE and D3DFMT_D32F_LOCKABLE indicate:
 *          - no particular bit ordering per pixel, and
 *          - are not app lockable, and
 *          - the driver is allowed to consume more than the indicated
 *            number of bits per Depth channel (but not Stencil channel).
 */
бцел MAKEFOURCC(ббайт ch0, ббайт ch1, ббайт ch2, ббайт ch3) {
    return cast(бцел)ch0 | cast(бцел)(ch1 << 8) | cast(бцел)(ch2 << 16) | cast(бцел)(ch3 << 24 );
}
template T_MAKEFOURCC(ббайт ch0, ббайт ch1, ббайт ch2, ббайт ch3) {
    const T_MAKEFOURCC = cast(бцел)ch0 | cast(бцел)(ch1 << 8) | cast(бцел)(ch2 << 16) | cast(бцел)(ch3 << 24 );
}

enum : D3DFORMAT {
    D3DFMT_UNKNOWN              =  0,

    D3DFMT_R8G8B8               = 20,
    D3DFMT_A8R8G8B8             = 21,
    D3DFMT_X8R8G8B8             = 22,
    D3DFMT_R5G6B5               = 23,
    D3DFMT_X1R5G5B5             = 24,
    D3DFMT_A1R5G5B5             = 25,
    D3DFMT_A4R4G4B4             = 26,
    D3DFMT_R3G3B2               = 27,
    D3DFMT_A8                   = 28,
    D3DFMT_A8R3G3B2             = 29,
    D3DFMT_X4R4G4B4             = 30,
    D3DFMT_A2B10G10R10          = 31,
    D3DFMT_A8B8G8R8             = 32,
    D3DFMT_X8B8G8R8             = 33,
    D3DFMT_G16R16               = 34,
    D3DFMT_A2R10G10B10          = 35,
    D3DFMT_A16B16G16R16         = 36,

    D3DFMT_A8P8                 = 40,
    D3DFMT_P8                   = 41,

    D3DFMT_L8                   = 50,
    D3DFMT_A8L8                 = 51,
    D3DFMT_A4L4                 = 52,

    D3DFMT_V8U8                 = 60,
    D3DFMT_L6V5U5               = 61,
    D3DFMT_X8L8V8U8             = 62,
    D3DFMT_Q8W8V8U8             = 63,
    D3DFMT_V16U16               = 64,
    D3DFMT_A2W10V10U10          = 67,

    D3DFMT_UYVY                 = T_MAKEFOURCC!('U', 'Y', 'V', 'Y'),
    D3DFMT_R8G8_B8G8            = T_MAKEFOURCC!('R', 'G', 'B', 'G'),
    D3DFMT_YUY2                 = T_MAKEFOURCC!('Y', 'U', 'Y', '2'),
    D3DFMT_G8R8_G8B8            = T_MAKEFOURCC!('G', 'R', 'G', 'B'),
    D3DFMT_DXT1                 = T_MAKEFOURCC!('D', 'X', 'T', '1'),
    D3DFMT_DXT2                 = T_MAKEFOURCC!('D', 'X', 'T', '2'),
    D3DFMT_DXT3                 = T_MAKEFOURCC!('D', 'X', 'T', '3'),
    D3DFMT_DXT4                 = T_MAKEFOURCC!('D', 'X', 'T', '4'),
    D3DFMT_DXT5                 = T_MAKEFOURCC!('D', 'X', 'T', '5'),

    D3DFMT_D16_LOCKABLE         = 70,
    D3DFMT_D32                  = 71,
    D3DFMT_D15S1                = 73,
    D3DFMT_D24S8                = 75,
    D3DFMT_D24X8                = 77,
    D3DFMT_D24X4S4              = 79,
    D3DFMT_D16                  = 80,

    D3DFMT_D32F_LOCKABLE        = 82,
    D3DFMT_D24FS8               = 83,

    /* Z-Stencil форматы valid for CPU access */
    D3DFMT_D32_LOCKABLE         = 84,
    D3DFMT_S8_LOCKABLE          = 85,

    D3DFMT_L16                  = 81,

    D3DFMT_VERTEXDATA           =100,
    D3DFMT_INDEX16              =101,
    D3DFMT_INDEX32              =102,

    D3DFMT_Q16W16V16U16         =110,

    D3DFMT_MULTI2_ARGB8         = T_MAKEFOURCC!('M','E','T','1'),

    // Floating point surface форматы

    // s10e5 форматы (16-bits per channel)
    D3DFMT_R16F                 = 111,
    D3DFMT_G16R16F              = 112,
    D3DFMT_A16B16G16R16F        = 113,

    // IEEE s23e8 форматы (32-bits per channel)
    D3DFMT_R32F                 = 114,
    D3DFMT_G32R32F              = 115,
    D3DFMT_A32B32G32R32F        = 116,

    D3DFMT_CxV8U8               = 117,

    // Monochrome 1 bit per pixel format
    D3DFMT_A1                   = 118,


    // Binary format indicating that the данные has no inherent тип
    D3DFMT_BINARYBUFFER         = 199
}
alias бцел D3DFORMAT;

/* Display Modes */
struct D3DDISPLAYMODE {
    бцел            Width;
    бцел            Height;
    бцел            RefreshRate;
    D3DFORMAT       Format;
}

/* Creation Parameters */
struct D3DDEVICE_CREATION_PARAMETERS
{
    UINT            AdapterOrdinal;
    D3DDEVTYPE      DeviceType;
    HWND            hFocusWindow;
    DWORD           BehaviorFlags;
}


/* SwapEffects */
enum : D3DSWAPEFFECT {
    D3DSWAPEFFECT_DISCARD           = 1,
    D3DSWAPEFFECT_FLIP              = 2,
    D3DSWAPEFFECT_COPY              = 3
}
alias бцел D3DSWAPEFFECT;

/* Pool types */
enum : D3DPOOL {
    D3DPOOL_DEFAULT                 = 0,
    D3DPOOL_MANAGED                 = 1,
    D3DPOOL_SYSTEMMEM               = 2,
    D3DPOOL_SCRATCH                 = 3
}
alias бцел D3DPOOL;


/* RefreshRate pre-defines */
const D3DPRESENT_RATE_DEFAULT = 0x00000000;


/* Resize Optional Parameters */
struct D3DPRESENT_PARAMETERS
{
    UINT                BackBufferWidth;
    UINT                BackBufferHeight;
    D3DFORMAT           BackBufferFormat;
    UINT                BackBufferCount;

    D3DMULTISAMPLE_TYPE MultiSampleType;
    DWORD               MultiSampleQuality;

    D3DSWAPEFFECT       SwapEffect;
    HWND                hDeviceWindow;
    BOOL                Windowed;
    BOOL                EnableAutoDepthStencil;
    D3DFORMAT           AutoDepthStencilFormat;
    DWORD               Flags;

    /* FullScreen_RefreshRateInHz must be zero for Windowed mode */
    UINT                FullScreen_RefreshRateInHz;
    UINT                PresentationInterval;
}

// Values for D3DPRESENT_PARAMETERS.Flags

const D3DPRESENTFLAG_LOCKABLE_BACKBUFFER = 0x00000001;
const D3DPRESENTFLAG_DISCARD_DEPTHSTENCIL = 0x00000002;
const D3DPRESENTFLAG_DEVICECLIP = 0x00000004;
const D3DPRESENTFLAG_VIDEO = 0x00000010;

const D3DPRESENTFLAG_NOAUTOROTATE = 0x00000020;
const D3DPRESENTFLAG_UNPRUNEDMODE = 0x00000040;

/* Gamma Ramp: Same as DX7 */

struct D3DGAMMARAMP
{
    бкрат[256] red;
    бкрат[256] green;
    бкрат[256] blue;
}

/* Back буфер types */
enum : D3DBACKBUFFER_TYPE {
    D3DBACKBUFFER_TYPE_MONO         = 0,
    D3DBACKBUFFER_TYPE_LEFT         = 1,
    D3DBACKBUFFER_TYPE_RIGHT        = 2
}
alias бцел D3DBACKBUFFER_TYPE;

/* Types */
enum : D3DRESOURCETYPE {
    D3DRTYPE_SURFACE                =  1,
    D3DRTYPE_VOLUME                 =  2,
    D3DRTYPE_TEXTURE                =  3,
    D3DRTYPE_VOLUMETEXTURE          =  4,
    D3DRTYPE_CUBETEXTURE            =  5,
    D3DRTYPE_VERTEXBUFFER           =  6,
    D3DRTYPE_INDEXBUFFER            =  7            //if this changes, change _D3DDEVINFO_RESOURCEMANAGER definition
}
alias бцел D3DRESOURCETYPE;

/* Usages */
const D3DUSAGE_RENDERTARGET = 0x00000001L;
const D3DUSAGE_DEPTHSTENCIL = 0x00000002L;
const D3DUSAGE_DYNAMIC = 0x00000200L;
const D3DUSAGE_NONSECURE = 0x00800000L;

// When passed to CheckDeviceFormat, D3DUSAGE_AUTOGENMIPMAP may return
// D3DOK_NOAUTOGEN if the device doesn't support autogeneration for that format.
// D3DOK_NOAUTOGEN is a success code, not a failure code... the SUCCEEDED and FAILED macros
// will return true and false respectively for this code.
const D3DUSAGE_AUTOGENMIPMAP = 0x00000400L;
const D3DUSAGE_DMAP = 0x00004000L;

// The following usages are valid only for querying CheckDeviceFormat
const D3DUSAGE_QUERY_LEGACYBUMPMAP = 0x00008000L;
const D3DUSAGE_QUERY_SRGBREAD = 0x00010000L;
const D3DUSAGE_QUERY_FILTER = 0x00020000L;
const D3DUSAGE_QUERY_SRGBWRITE = 0x00040000L;
const D3DUSAGE_QUERY_POSTPIXELSHADER_BLENDING = 0x00080000L;
const D3DUSAGE_QUERY_VERTEXTEXTURE = 0x00100000L;
const D3DUSAGE_QUERY_WRAPANDMIP = 0x00200000L;

/* Usages for Vertex/Index buffers */
const D3DUSAGE_WRITEONLY = 0x00000008L;
const D3DUSAGE_SOFTWAREPROCESSING = 0x00000010L;
const D3DUSAGE_DONOTCLIP = 0x00000020L;
const D3DUSAGE_POINTS = 0x00000040L;
const D3DUSAGE_RTPATCHES = 0x00000080L;
const D3DUSAGE_NPATCHES = 0x00000100L;
const D3DUSAGE_TEXTAPI = 0x10000000L;

/* CubeMap Face identifiers */
enum : D3DCUBEMAP_FACES {
    D3DCUBEMAP_FACE_POSITIVE_X     = 0,
    D3DCUBEMAP_FACE_NEGATIVE_X     = 1,
    D3DCUBEMAP_FACE_POSITIVE_Y     = 2,
    D3DCUBEMAP_FACE_NEGATIVE_Y     = 3,
    D3DCUBEMAP_FACE_POSITIVE_Z     = 4,
    D3DCUBEMAP_FACE_NEGATIVE_Z     = 5
}
alias бцел D3DCUBEMAP_FACES;

/* Lock флаги */
const D3DLOCK_READONLY = 0x00000010L;
const D3DLOCK_DISCARD = 0x00002000L;
const D3DLOCK_NOOVERWRITE = 0x00001000L;
const D3DLOCK_NOSYSLOCK = 0x00000800L;
const D3DLOCK_DONOTWAIT = 0x00004000L;                  
const D3DLOCK_NO_DIRTY_UPDATE = 0x00008000L;

/* Vertex Buffer Description */
struct D3DVERTEXBUFFER_DESC {
    D3DFORMAT           Format;
    D3DRESOURCETYPE     Type;
    DWORD               Usage;
    D3DPOOL             Pool;
    UINT                Размер;
    DWORD               FVF;
}

/* Index Buffer Description */
struct D3DINDEXBUFFER_DESC {
    D3DFORMAT           Format;
    D3DRESOURCETYPE     Type;
    DWORD               Usage;
    D3DPOOL             Pool;
    UINT                Размер;
}


/* Surface Description */
struct D3DSURFACE_DESC {
    D3DFORMAT           Format;
    D3DRESOURCETYPE     Type;
    DWORD               Usage;
    D3DPOOL             Pool;

    D3DMULTISAMPLE_TYPE MultiSampleType;
    DWORD               MultiSampleQuality;
    UINT                Width;
    UINT                Height;
}

struct D3DVOLUME_DESC {
    D3DFORMAT           Format;
    D3DRESOURCETYPE     Type;
    DWORD               Usage;
    D3DPOOL             Pool;

    UINT                Width;
    UINT                Height;
    UINT                Depth;
}

/* Structure for LockRect */
struct D3DLOCKED_RECT {
    INT                 Pitch;
    проц*               pBits;
}

/* Structures for LockBox */
struct D3DBOX {
    UINT                Left;
    UINT                Top;
    UINT                Right;
    UINT                Bottom;
    UINT                Front;
    UINT                Back;
}

struct D3DLOCKED_BOX
{
    INT                 RowPitch;
    INT                 SlicePitch;
    проц*               pBits;
}

/* Structures for LockRange */
struct D3DRANGE
{
    UINT                Offset;
    UINT                Размер;
}

/* Structures for high order primitives */
struct D3DRECTPATCH_INFO
{
    UINT                StartVertexOffsetWidth;
    UINT                StartVertexOffsetHeight;
    UINT                Width;
    UINT                Height;
    UINT                Stride;
    D3DBASISTYPE        Basis;
    D3DDEGREETYPE       Degree;
}

struct D3DTRIPATCH_INFO
{
    UINT                StartVertexOffset;
    UINT                NumVertices;
    D3DBASISTYPE        Basis;
    D3DDEGREETYPE       Degree;
}

/* Adapter Identifier */

const MAX_DEVICE_IDENTIFIER_STRING = 512;
struct D3DADAPTER_IDENTIFIER9
{
    сим[MAX_DEVICE_IDENTIFIER_STRING] Driver;
    сим[MAX_DEVICE_IDENTIFIER_STRING] Description;
    сим[32] DeviceName;         /* Device имя for GDI (ex. \\.\DISPLAY1) */

    LARGE_INTEGER   DriverVersion;          /* Defined for 32 bit компоненты */

    DWORD           VendorId;
    DWORD           DeviceId;
    DWORD           SubSysId;
    DWORD           Revision;

    GUID            DeviceIdentifier;

    DWORD           WHQLLevel;
}


/* Raster Status structure returned by GetRasterStatus */
struct D3DRASTER_STATUS
{
    BOOL InVBlank;
    UINT ScanLine;
}



/* Debug monitor tokens (DEBUG only)

   Note that if D3DRS_DEBUGMONITORTOKEN is set, the call is treated as
   passing a token to the debug monitor.  For example, if, after passing
   D3DDMT_ENABLE/DISABLE to D3DRS_DEBUGMONITORTOKEN другой token значения
   are passed in, the enabled/disabled state of the debug
   monitor will still persist.

   The debug monitor defaults to enabled.

   Calling GetRenderState on D3DRS_DEBUGMONITORTOKEN is not of any use.
*/
enum : D3DDEBUGMONITORTOKENS {
    D3DDMT_ENABLE            = 0,    // enable debug monitor
    D3DDMT_DISABLE           = 1     // disable debug monitor
}
alias бцел D3DDEBUGMONITORTOKENS;

// Async feedback

enum : D3DQUERYTYPE {
    D3DQUERYTYPE_VCACHE                 = 4, /* D3DISSUE_END */
    D3DQUERYTYPE_RESOURCEMANAGER        = 5, /* D3DISSUE_END */
    D3DQUERYTYPE_VERTEXSTATS            = 6, /* D3DISSUE_END */
    D3DQUERYTYPE_EVENT                  = 8, /* D3DISSUE_END */
    D3DQUERYTYPE_OCCLUSION              = 9, /* D3DISSUE_BEGIN, D3DISSUE_END */
    D3DQUERYTYPE_TIMESTAMP              = 10, /* D3DISSUE_END */
    D3DQUERYTYPE_TIMESTAMPDISJOINT      = 11, /* D3DISSUE_BEGIN, D3DISSUE_END */
    D3DQUERYTYPE_TIMESTAMPFREQ          = 12, /* D3DISSUE_END */
    D3DQUERYTYPE_PIPELINETIMINGS        = 13, /* D3DISSUE_BEGIN, D3DISSUE_END */
    D3DQUERYTYPE_INTERFACETIMINGS       = 14, /* D3DISSUE_BEGIN, D3DISSUE_END */
    D3DQUERYTYPE_VERTEXTIMINGS          = 15, /* D3DISSUE_BEGIN, D3DISSUE_END */
    D3DQUERYTYPE_PIXELTIMINGS           = 16, /* D3DISSUE_BEGIN, D3DISSUE_END */
    D3DQUERYTYPE_BANDWIDTHTIMINGS       = 17, /* D3DISSUE_BEGIN, D3DISSUE_END */
    D3DQUERYTYPE_CACHEUTILIZATION       = 18, /* D3DISSUE_BEGIN, D3DISSUE_END */
}
alias бцел D3DQUERYTYPE;

// Flags поле for Issue
const D3DISSUE_END = (1 << 0); // Tells the runtime to issue the end of a query, changing it's state to "non-signaled".
const D3DISSUE_BEGIN = (1 << 1); // Tells the runtime to issue the beginng of a query.


// Flags поле for GetData
const D3DGETDATA_FLUSH = (1 << 0); // Tells the runtime to слей if the query is outstanding.


struct D3DRESOURCESTATS
{
// Data collected since last Present()
    BOOL    bThrashing;             /* indicates if thrashing */
    DWORD   ApproxBytesDownloaded;  /* Approximate number of bytes downloaded by resource manager */
    DWORD   NumEvicts;              /* number of objects evicted */
    DWORD   NumVidCreates;          /* number of objects created in video memory */
    DWORD   LastPri;                /* priority of last object evicted */
    DWORD   NumUsed;                /* number of objects set to the device */
    DWORD   NumUsedInVidMem;        /* number of objects set to the device, which are already in video memory */
// Persistent данные
    DWORD   WorkingSet;             /* number of objects in video memory */
    DWORD   WorkingSetBytes;        /* number of bytes in video memory */
    DWORD   TotalManaged;           /* total number of managed objects */
    DWORD   TotalBytes;             /* total number of bytes of managed objects */
}

const D3DRTYPECOUNT = D3DRTYPE_INDEXBUFFER+1;

struct D3DDEVINFO_RESOURCEMANAGER
{
//#ifndef WOW64_ENUM_WORKAROUND
//    D3DRESOURCESTATS    stats[D3DRTYPECOUNT];
    D3DRESOURCESTATS    stats[8];
}
alias D3DDEVINFO_RESOURCEMANAGER* LPD3DDEVINFO_RESOURCEMANAGER;

struct D3DDEVINFO_D3DVERTEXSTATS
{
    DWORD   NumRenderedTriangles;       /* total number of triangles that are not clipped in this frame */
    DWORD   NumExtraClippingTriangles;  /* Number of new triangles generated by clipping */
}
alias D3DDEVINFO_D3DVERTEXSTATS *LPD3DDEVINFO_D3DVERTEXSTATS;


struct D3DDEVINFO_VCACHE {
    DWORD   Pattern;                    /* bit pattern, return значение must be FOUR_CC('C', 'A', 'C', 'H') */
    DWORD   OptMethod;                  /* optimization method 0 means longest strips, 1 means vertex cache based */
    DWORD   CacheSize;                  /* cache размер to optimize for  (only required if тип is 1) */
    DWORD   MagicNumber;                /* used to determine when to restart strips (only required if тип is 1)*/
}
alias D3DDEVINFO_VCACHE *LPD3DDEVINFO_VCACHE;

struct D3DDEVINFO_D3D9PIPELINETIMINGS
{
    FLOAT VertexProcessingTimePercent;
    FLOAT PixelProcessingTimePercent;
    FLOAT OtherGPUProcessingTimePercent;
    FLOAT GPUIdleTimePercent;
}

struct D3DDEVINFO_D3D9INTERFACETIMINGS
{
    FLOAT WaitingForGPUToUseApplicationResourceTimePercent;
    FLOAT WaitingForGPUToAcceptMoreCommandsTimePercent;
    FLOAT WaitingForGPUToStayWithinLatencyTimePercent;
    FLOAT WaitingForGPUExclusiveResourceTimePercent;
    FLOAT WaitingForGPUOtherTimePercent;
}

struct D3DDEVINFO_D3D9STAGETIMINGS
{
    FLOAT MemoryProcessingPercent;
    FLOAT ComputationProcessingPercent;
}

struct D3DDEVINFO_D3D9BANDWIDTHTIMINGS
{
    FLOAT MaxBandwidthUtilized;
    FLOAT FrontEndUploadMemoryUtilizedPercent;
    FLOAT VertexRateUtilizedPercent;
    FLOAT TriangleSetupRateUtilizedPercent;
    FLOAT FillRateUtilizedPercent;
}

struct D3DDEVINFO_D3D9CACHEUTILIZATION
{
    FLOAT TextureCacheHitRate; // Percentage of cache hits
    FLOAT PostTransformVertexCacheHitRate;
}

enum : D3DCOMPOSERECTSOP {
    D3DCOMPOSERECTS_COPY     = 1,
    D3DCOMPOSERECTS_OR       = 2,
    D3DCOMPOSERECTS_AND      = 3,
    D3DCOMPOSERECTS_NEG      = 4
}
alias бцел D3DCOMPOSERECTSOP;

struct D3DCOMPOSERECTDESC
{
    USHORT  X, Y;           // Top-лево coordinates of a прям in the исток surface
    USHORT  Width, Height;  // Dimensions of the прям
}

struct D3DCOMPOSERECTDESTINATION
{
    USHORT SrcRectIndex;    // Index of D3DCOMPOSERECTDESC
    USHORT Reserved;        // For alignment
    SHORT  X, Y;            // Top-лево coordinates of the прям in the destination surface
}

const D3DCOMPOSERECTS_MAXNUMRECTS = 0xFFFF;
const D3DCONVOLUTIONMONO_MAXWIDTH = 7;
const D3DCONVOLUTIONMONO_MAXHEIGHT = D3DCONVOLUTIONMONO_MAXWIDTH;
const D3DFMT_A1_SURFACE_MAXWIDTH = 8192;
const D3DFMT_A1_SURFACE_MAXHEIGHT = 2048;


struct D3DPRESENTSTATS {
    UINT PresentCount;
    UINT PresentRefreshCount;
    UINT SyncRefreshCount;
    LARGE_INTEGER SyncQPCTime;
    LARGE_INTEGER SyncGPUTime;
}

enum : D3DSCANLINEORDERING
{
    D3DSCANLINEORDERING_UNKNOWN                    = 0, 
    D3DSCANLINEORDERING_PROGRESSIVE                = 1,
    D3DSCANLINEORDERING_INTERLACED                 = 2
}
alias бцел D3DSCANLINEORDERING;


struct D3DDISPLAYMODEEX
{
    UINT                    Размер;
    UINT                    Width;
    UINT                    Height;
    UINT                    RefreshRate;
    D3DFORMAT               Format;
    D3DSCANLINEORDERING     ScanLineOrdering;
}

struct D3DDISPLAYMODEFILTER
{
    UINT                    Размер;
    D3DFORMAT               Format;
    D3DSCANLINEORDERING     ScanLineOrdering;
}


enum : D3DDISPLAYROTATION
{
    D3DDISPLAYROTATION_IDENTITY = 1, // No rotation.           
    D3DDISPLAYROTATION_90       = 2, // Rotated 90 degrees.
    D3DDISPLAYROTATION_180      = 3, // Rotated 180 degrees.
    D3DDISPLAYROTATION_270      = 4  // Rotated 270 degrees.
}
alias бцел D3DDISPLAYROTATION;

/* For use in ID3DResource9::SetPriority calls */
const D3D9_RESOURCE_PRIORITY_MINIMUM = 0x28000000;
const D3D9_RESOURCE_PRIORITY_LOW = 0x50000000;
const D3D9_RESOURCE_PRIORITY_NORMAL = 0x78000000;
const D3D9_RESOURCE_PRIORITY_HIGH = 0xa0000000;
const D3D9_RESOURCE_PRIORITY_MAXIMUM = 0xc8000000;