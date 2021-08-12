/***********************************************************************\
*                                 dde.d                                 *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                           by Stewart Gordon                           *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module win32.dde;
//pragma(lib, "user32.lib");
pragma(lib, "dinrus.lib");

private import win32.windef;

enum : бцел {
	WM_DDE_FIRST     = 0x03E0,
	WM_DDE_INITIATE  = WM_DDE_FIRST,
	WM_DDE_TERMINATE,
	WM_DDE_ADVISE,
	WM_DDE_UNADVISE,
	WM_DDE_ACK,
	WM_DDE_DATA,
	WM_DDE_REQUEST,
	WM_DDE_POKE,
	WM_DDE_EXECUTE,
	WM_DDE_LAST      = WM_DDE_EXECUTE
}

struct DDEACK {
	ббайт bAppReturnCode;
	ббайт _bf;

	ббайт reserved() { return cast(ббайт) (_bf & 0x3F); }
	бул  fBusy()    { return cast(бул)  (_bf & 0x40); }
	бул  fAck()     { return cast(бул)  (_bf & 0x80); }

	ббайт reserved(ббайт r) {
		_bf = cast(ббайт) ((_bf & ~0x3F) | (r & 0x3F));
		return cast(ббайт)(r & 0x3F);
	}

	бул fBusy(бул f) { _bf = cast(ббайт) ((_bf & ~0x40) | (f << 6)); return f; }
	бул fAck(бул f)  { _bf = cast(ббайт) ((_bf & ~0x80) | (f << 7)); return f; }
}

struct DDEADVISE {
	бкрат _bf;
	крат  cfFormat;

	бкрат reserved()  { return cast(бкрат) (_bf & 0x3FFF); }
	бул   fDeferUpd() { return cast(бул)   (_bf & 0x4000); }
	бул   fAckReq()   { return cast(бул)   (_bf & 0x8000); }

	бкрат reserved(бкрат r) {
		_bf = cast(бкрат) ((_bf & ~0x3FFF) | (r & 0x3FFF));
		return cast(бкрат)(r & 0x3FFF);
	}

	бул   fDeferUpd(бул f) { _bf = cast(бкрат) ((_bf & ~0x4000) | (f << 14)); return f; }
	бул   fAckReq(бул f)   { _bf = cast(бкрат) ((_bf & ~0x8000) | (f << 15)); return f; }
}

struct DDEDATA {
	бкрат _bf;
	крат  cfFormat;
	byte   _Value;

	бкрат unused()    { return cast(бкрат) (_bf & 0x0FFF); }
	бул   fResponse() { return cast(бул)   (_bf & 0x1000); }
	бул   fRelease()  { return cast(бул)   (_bf & 0x2000); }
	бул   reserved()  { return cast(бул)   (_bf & 0x4000); }
	бул   fAckReq()   { return cast(бул)   (_bf & 0x8000); }

	byte*  Value() { return &_Value; }

	бкрат unused(бкрат r) {
		_bf = cast(бкрат) ((_bf & ~0x0FFF) | (r & 0x0FFF));
		return cast(бкрат)(r & 0x0FFF);
	}

	бул   fResponse(бул f) { _bf = cast(бкрат) ((_bf & ~0x1000) | (f << 12)); return f; }
	бул   fRelease(бул f)  { _bf = cast(бкрат) ((_bf & ~0x2000) | (f << 13)); return f; }
	бул   reserved(бул f)  { _bf = cast(бкрат) ((_bf & ~0x4000) | (f << 14)); return f; }
	бул   fAckReq(бул f)   { _bf = cast(бкрат) ((_bf & ~0x8000) | (f << 15)); return f; }
}

struct DDEPOKE {
	бкрат _bf;
	крат  cfFormat;
	byte   _Value;

	бкрат unused()    { return cast(бкрат) (_bf & 0x1FFF); }
	бул   fRelease()  { return cast(бул)   (_bf & 0x2000); }
	ббайт  fReserved() { return cast(ббайт)  ((_bf & 0xC000) >>> 14); }

	byte*  Value() { return &_Value; }

	бкрат unused(бкрат u) {
		_bf = cast(бкрат) ((_bf & ~0x1FFF) | (u & 0x1FFF));
		return cast(бкрат)(u & 0x1FFF);
	}

	бул   fRelease(бул f)   { _bf = cast(бкрат) ((_bf & ~0x2000) | (f << 13)); return f; }
	ббайт  fReserved(ббайт r) { _bf = cast(бкрат) ((_bf & ~0xC000) | (r << 14)); return r; }
}

deprecated struct DDELN {
	бкрат _bf;
	крат  cfFormat;

	бкрат unused()    { return cast(бкрат) (_bf & 0x1FFF); }
	бул   fRelease()  { return cast(бул)   (_bf & 0x2000); }
	бул   fDeferUpd() { return cast(бул)   (_bf & 0x4000); }
	бул   fAckReq()   { return cast(бул)   (_bf & 0x8000); }

	бкрат unused(бкрат u) {
		_bf = cast(бкрат)((_bf & ~0x1FFF) | (u & 0x1FFF));
		return cast(бкрат)(u & 0x1FFF);
	}

	бул   fRelease(бул f)  { _bf = cast(бкрат) ((_bf & ~0x2000) | (f << 13)); return f; }
	бул   fDeferUpd(бул f) { _bf = cast(бкрат) ((_bf & ~0x4000) | (f << 14)); return f; }
	бул   fAckReq(бул f)   { _bf = cast(бкрат) ((_bf & ~0x8000) | (f << 15)); return f; }
}

deprecated struct DDEUP {
	бкрат _bf;
	крат  cfFormat;
	byte   _rgb;

	бкрат unused()    { return cast(бкрат) (_bf & 0x0FFF); }
	бул   fAck()      { return cast(бул)   (_bf & 0x1000); }
	бул   fRelease()  { return cast(бул)   (_bf & 0x2000); }
	бул   fReserved() { return cast(бул)   (_bf & 0x4000); }
	бул   fAckReq()   { return cast(бул)   (_bf & 0x8000); }

	byte*  rgb() { return &_rgb; }

	бкрат unused(бкрат r) {
		_bf = cast(бкрат) ((_bf & ~0x0FFF) | (r & 0x0FFF));
		return cast(бкрат)(r & 0x0FFF);
	}

	бул   fAck(бул f)      { _bf = cast(бкрат) ((_bf & ~0x1000) | (f << 12)); return f; }
	бул   fRelease(бул f)  { _bf = cast(бкрат) ((_bf & ~0x2000) | (f << 13)); return f; }
	бул   fReserved(бул f) { _bf = cast(бкрат) ((_bf & ~0x4000) | (f << 14)); return f; }
	бул   fAckReq(бул f)   { _bf = cast(бкрат) ((_bf & ~0x8000) | (f << 15)); return f; }
}

extern (Windows) {
	BOOL DdeSetQualityOfService(HWND, SECURITY_QUALITY_OF_SERVICE*,
	  PSECURITY_QUALITY_OF_SERVICE);
	BOOL ImpersonateDdeClientWindow(HWND, HWND);
	LPARAM PackDDElParam(UINT, UINT_PTR, UINT_PTR);
	BOOL UnpackDDElParam(UINT, LPARAM, PUINT_PTR, PUINT_PTR);
	BOOL FreeDDElParam(UINT, LPARAM);
	LPARAM ReuseDDElParam(LPARAM, UINT, UINT, UINT_PTR, UINT_PTR);
}

debug (WindowsUnitTest) {
	unittest {
		DDEACK ddeack;

		with (ddeack) {
			reserved = 10;
			assert (_bf == 0x0A);
			fBusy = true;
			assert (_bf == 0x4A);
			fAck = true;
			assert (_bf == 0xCA);

			assert (reserved == 10);
			assert (fBusy == true);
			assert (fAck == true);

			reserved = 43;
			assert (_bf == 0xEB);
			fBusy = false;
			assert (_bf == 0xAB);
			fAck = false;
			assert (_bf == 0x2B);

			assert (reserved == 43);
			assert (fBusy == false);
			assert (fAck == false);
		}

		DDEPOKE ddepoke;

		with (ddepoke) {
			unused = 3456;
			assert (_bf == 0x0D80);
			fRelease = true;
			assert (_bf == 0x2D80);
			fReserved = 2;
			assert (_bf == 0xAD80);

			assert (unused == 3456);
			assert (fRelease == true);
			assert (fReserved == 2);

			unused = 2109;
			assert (_bf == 0xa83d);
			fRelease = false;
			assert (_bf == 0x883d);
			fReserved = 1;
			assert (_bf == 0x483d);

			assert (unused == 2109);
			assert (fRelease == false);
			assert (fReserved == 1);
		}
	}
}
