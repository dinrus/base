﻿/***********************************************************************\
*                                 dlgs.d                                *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                           by Stewart Gordon                           *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module os.win32.dlgs;

private import os.win32.windef;

enum : ushort {
	FILEOPENORD      = 1536,
	MULTIFILEOPENORD = 1537,
	PRINTDLGORD      = 1538,
	PRNSETUPDLGORD   = 1539,
	FINDDLGORD       = 1540,
	REPLACEDLGORD    = 1541,
	FONTDLGORD       = 1542,
	FORMATDLGORD31   = 1543,
	FORMATDLGORD30   = 1544,
	PAGESETUPDLGORD  = 1546
}

enum : int {
	ctlFirst = 0x400,
	ctlLast  = 0x4ff,
	chx1     = 0x410,
	chx2     = 0x411,
	chx3     = 0x412,
	chx4     = 0x413,
	chx5     = 0x414,
	chx6     = 0x415,
	chx7     = 0x416,
	chx8     = 0x417,
	chx9     = 0x418,
	chx10    = 0x419,
	chx11    = 0x41a,
	chx12    = 0x41b,
	chx13    = 0x41c,
	chx14    = 0x41d,
	chx15    = 0x41e,
	chx16    = 0x41f,
	cmb1     = 0x470,
	cmb2     = 0x471,
	cmb3     = 0x472,
	cmb4     = 0x473,
	cmb5     = 0x474,
	cmb6     = 0x475,
	cmb7     = 0x476,
	cmb8     = 0x477,
	cmb9     = 0x478,
	cmb10    = 0x479,
	cmb11    = 0x47a,
	cmb12    = 0x47b,
	cmb13    = 0x47c,
	cmb14    = 0x47d,
	cmb15    = 0x47e,
	cmb16    = 0x47f,
	edt1     = 0x480,
	edt2     = 0x481,
	edt3     = 0x482,
	edt4     = 0x483,
	edt5     = 0x484,
	edt6     = 0x485,
	edt7     = 0x486,
	edt8     = 0x487,
	edt9     = 0x488,
	edt10    = 0x489,
	edt11    = 0x48a,
	edt12    = 0x48b,
	edt13    = 0x48c,
	edt14    = 0x48d,
	edt15    = 0x48e,
	edt16    = 0x48f,
	frm1     = 0x434,
	frm2     = 0x435,
	frm3     = 0x436,
	frm4     = 0x437,
	grp1     = 0x430,
	grp2     = 0x431,
	grp3     = 0x432,
	grp4     = 0x433,
	ico1     = 0x43c,
	ico2     = 0x43d,
	ico3     = 0x43e,
	ico4     = 0x43f,
	lst1     = 0x460,
	lst2     = 0x461,
	lst3     = 0x462,
	lst4     = 0x463,
	lst5     = 0x464,
	lst6     = 0x465,
	lst7     = 0x466,
	lst8     = 0x467,
	lst9     = 0x468,
	lst10    = 0x469,
	lst11    = 0x46a,
	lst12    = 0x46b,
	lst13    = 0x46c,
	lst14    = 0x46d,
	lst15    = 0x46e,
	lst16    = 0x46f,
	psh1     = 0x400,
	psh2     = 0x401,
	psh3     = 0x402,
	psh4     = 0x403,
	psh5     = 0x404,
	psh6     = 0x405,
	psh7     = 0x406,
	psh8     = 0x407,
	psh9     = 0x408,
	psh10    = 0x409,
	psh11    = 0x40a,
	psh12    = 0x40b,
	psh13    = 0x40c,
	psh14    = 0x40d,
	psh15    = 0x40e,
	pshHelp  = 0x40e,
	psh16    = 0x40f,
	rad1     = 0x420,
	rad2     = 0x421,
	rad3     = 0x422,
	rad4     = 0x423,
	rad5     = 0x424,
	rad6     = 0x425,
	rad7     = 0x426,
	rad8     = 0x427,
	rad9     = 0x428,
	rad10    = 0x429,
	rad11    = 0x42a,
	rad12    = 0x42b,
	rad13    = 0x42c,
	rad14    = 0x42d,
	rad15    = 0x42e,
	rad16    = 0x42f,
	rct1     = 0x438,
	rct2     = 0x439,
	rct3     = 0x43a,
	rct4     = 0x43b,
	scr1     = 0x490,
	scr2     = 0x491,
	scr3     = 0x492,
	scr4     = 0x493,
	scr5     = 0x494,
	scr6     = 0x495,
	scr7     = 0x496,
	scr8     = 0x497,
	stc1     = 0x440,
	stc2     = 0x441,
	stc3     = 0x442,
	stc4     = 0x443,
	stc5     = 0x444,
	stc6     = 0x445,
	stc7     = 0x446,
	stc8     = 0x447,
	stc9     = 0x448,
	stc10    = 0x449,
	stc11    = 0x44a,
	stc12    = 0x44b,
	stc13    = 0x44c,
	stc14    = 0x44d,
	stc15    = 0x44e,
	stc16    = 0x44f,
	stc17    = 0x450,
	stc18    = 0x451,
	stc19    = 0x452,
	stc20    = 0x453,
	stc21    = 0x454,
	stc22    = 0x455,
	stc23    = 0x456,
	stc24    = 0x457,
	stc25    = 0x458,
	stc26    = 0x459,
	stc27    = 0x45a,
	stc28    = 0x45b,
	stc29    = 0x45c,
	stc30    = 0x45d,
	stc31    = 0x45e,
	stc32    = 0x45f
}

struct CRGB {
	ubyte bRed;
	ubyte bGreen;
	ubyte bBlue;
	ubyte bExtra;
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-win32");
        } else version (DigitalMars) {
            pragma(link, "auxC");
        } else {
            pragma(link, "DO-win32");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-win32");
        } else version (DigitalMars) {
            pragma(link, "auxC");
        } else {
            pragma(link, "DO-win32");
        }
    }
}
