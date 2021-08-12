﻿// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.base;

private import os.win.gui.x.dlib, std.c;

private import os.win.gui.x.winapi, os.win.gui.drawing, os.win.gui.event;


alias HWND HWindow;


///
interface IWindow // docmain
{
	///
	HWindow handle(); // getter
}

alias IWindow IWin32Window; // deprecated


///
class DflException: Exception // docmain
{
	///
	this(Dstring msg)
	{
		super(msg);
	}
}


///
class StringObject: DObject
{
	///
	Dstring value;
	
	
	///
	this(Dstring str)
	{
		this.value = str;
	}
	
	
	override Dstring toString()
	{
		return value;
	}
	
	
	override Dequ opEquals(Object o)
	{
		return value == getObjectString(o); // ?
	}
	
	
	Dequ opEquals(StringObject s)
	{
		return value == s.value;
	}
	
	
	override int opCmp(Object o)
	{
		return stringICmp(value, getObjectString(o)); // ?
	}
	
	
	int opCmp(StringObject s)
	{
		return stringICmp(value, s.value);
	}
}


///
enum Keys: uint // docmain
{
	NONE =     0, /// No keys specified.
	
	///
	SHIFT =    0x10000, /// Modifier keys.
	CONTROL =  0x20000, /// ditto
	ALT =      0x40000, /// ditto
	
	A = 'A', /// Letters.
	B = 'B', /// ditto
	C = 'C', /// ditto
	D = 'D', /// ditto
	E = 'E', /// ditto
	F = 'F', /// ditto
	G = 'G', /// ditto
	H = 'H', /// ditto
	I = 'I', /// ditto
	J = 'J', /// ditto
	K = 'K', /// ditto
	L = 'L', /// ditto
	M = 'M', /// ditto
	N = 'N', /// ditto
	O = 'O', /// ditto
	P = 'P', /// ditto
	Q = 'Q', /// ditto
	R = 'R', /// ditto
	S = 'S', /// ditto
	T = 'T', /// ditto
	U = 'U', /// ditto
	V = 'V', /// ditto
	W = 'W', /// ditto
	X = 'X', /// ditto
	Y = 'Y', /// ditto
	Z = 'Z', /// ditto
	
	D0 = '0', /// Digits.
	D1 = '1', /// ditto
	D2 = '2', /// ditto
	D3 = '3', /// ditto
	D4 = '4', /// ditto
	D5 = '5', /// ditto
	D6 = '6', /// ditto
	D7 = '7', /// ditto
	D8 = '8', /// ditto
	D9 = '9', /// ditto
	
	F1 = 112, /// F - function keys.
	F2 = 113, /// ditto
	F3 = 114, /// ditto
	F4 = 115, /// ditto
	F5 = 116, /// ditto
	F6 = 117, /// ditto
	F7 = 118, /// ditto
	F8 = 119, /// ditto
	F9 = 120, /// ditto
	F10 = 121, /// ditto
	F11 = 122, /// ditto
	F12 = 123, /// ditto
	F13 = 124, /// ditto
	F14 = 125, /// ditto
	F15 = 126, /// ditto
	F16 = 127, /// ditto
	F17 = 128, /// ditto
	F18 = 129, /// ditto
	F19 = 130, /// ditto
	F20 = 131, /// ditto
	F21 = 132, /// ditto
	F22 = 133, /// ditto
	F23 = 134, /// ditto
	F24 = 135, /// ditto
	
	NUM_PAD0 = 96, /// Numbers on keypad.
	NUM_PAD1 = 97, /// ditto
	NUM_PAD2 = 98, /// ditto
	NUM_PAD3 = 99, /// ditto
	NUM_PAD4 = 100, /// ditto
	NUM_PAD5 = 101, /// ditto
	NUM_PAD6 = 102, /// ditto
	NUM_PAD7 = 103, /// ditto
	NUM_PAD8 = 104, /// ditto
	NUM_PAD9 = 105, /// ditto
	
	ADD = 107, ///
	APPS = 93, /// Application.
	ATTN = 246, ///
	BACK = 8, /// Backspace.
	CANCEL = 3, ///
	CAPITAL = 20, ///
	CAPS_LOCK = 20, /// ditto
	CLEAR = 12, ///
	CONTROL_KEY = 17, ///
	CRSEL = 247, ///
	DECIMAL = 110, ///
	DEL = 46, ///
	DELETE = DEL, ///
	PERIOD = 190, ///
	DOT = PERIOD, /// ditto
	DIVIDE = 111, ///
	DOWN = 40, /// Down arrow.
	END = 35, ///
	ENTER = 13, ///
	ERASE_EOF = 249, ///
	ESCAPE = 27, ///
	EXECUTE = 43, ///
	EXSEL = 248, ///
	FINAL_MODE = 4, /// IME final mode.
	HANGUL_MODE = 21, /// IME Hangul mode.
	HANGUEL_MODE = 21, /// ditto
	HANJA_MODE = 25, /// IME Hanja mode.
	HELP = 47, ///
	HOME = 36, ///
	IME_ACCEPT = 30, ///
	IME_CONVERT = 28, ///
	IME_MODE_CHANGE = 31, ///
	IME_NONCONVERT = 29, ///
	INSERT = 45, ///
	JUNJA_MODE = 23, ///
	KANA_MODE = 21, ///
	KANJI_MODE = 25, ///
	LEFT_CONTROL = 162, /// Left Ctrl.
	LEFT = 37, /// Left arrow.
	LINE_FEED = 10, ///
	LEFT_MENU = 164, /// Left Alt.
	LEFT_SHIFT = 160, ///
	LEFT_WIN = 91, /// Left Windows logo.
	MENU = 18, /// Alt.
	MULTIPLY = 106, ///
	NEXT = 34, /// Page down.
	NO_NAME = 252, // Reserved for future use.
	NUM_LOCK = 144, ///
	OEM8 = 223, // OEM specific.
	OEM_CLEAR = 254,
	PA1 = 253,
	PAGE_DOWN = 34, ///
	PAGE_UP = 33, ///
	PAUSE = 19, ///
	PLAY = 250, ///
	PRINT = 42, ///
	PRINT_SCREEN = 44, ///
	PROCESS_KEY = 229, ///
	RIGHT_CONTROL = 163, /// Right Ctrl.
	RETURN = 13, ///
	RIGHT = 39, /// Right arrow.
	RIGHT_MENU = 165, /// Right Alt.
	RIGHT_SHIFT = 161, ///
	RIGHT_WIN = 92, /// Right Windows logo.
	SCROLL = 145, /// Scroll lock.
	SELECT = 41, ///
	SEPARATOR = 108, ///
	SHIFT_KEY = 16, ///
	SNAPSHOT = 44, /// Print screen.
	SPACE = 32, ///
	SPACEBAR = SPACE, // Extra.
	SUBTRACT = 109, ///
	TAB = 9, ///
	UP = 38, /// Up arrow.
	ZOOM = 251, ///
	
	// Windows 2000+
	BROWSER_BACK = 166, ///
	BROWSER_FAVORITES = 171, /// ditto
	BROWSER_FORWARD = 167, /// ditto
	BROWSER_HOME = 172, /// ditto
	BROWSER_REFRESH = 168, /// ditto
	BROWSER_SEARCH = 170, /// ditto
	BROWSER_STOP = 169, /// ditto
	LAUNCH_APPLICATION1 = 182, ///
	LAUNCH_APPLICATION2 = 183, /// ditto
	LAUNCH_MAIL = 180, /// ditto
	MEDIA_NEXT_TRACK = 176, ///
	MEDIA_PLAY_PAUSE = 179, /// ditto
	MEDIA_PREVIOUS_TRACK = 177, /// ditto
	MEDIA_STOP = 178, /// ditto
	OEM_BACKSLASH = 226, // OEM angle bracket or backslash.
	OEM_CLOSE_BRACKETS = 221,
	OEM_COMMA = 188,
	OEM_MINUS = 189,
	OEM_OPEN_BRACKETS = 219,
	OEM_PERIOD = 190,
	OEM_PIPE = 220,
	OEM_PLUS = 187,
	OEM_QUESTION = 191,
	OEM_QUOTES = 222,
	OEM_SEMICOLON = 186,
	OEM_TILDE = 192,
	SELECT_MEDIA = 181, ///
	VOLUME_DOWN = 174, ///
	VOLUME_MUTE = 173, /// ditto
	VOLUME_UP = 175, /// ditto
	
	/// Bit mask to extract key code from key value.
	KEY_CODE = 0xFFFF,
	
	/// Bit mask to extract modifiers from key value.
	MODIFIERS = 0xFFFF0000,
}


///
enum MouseButtons: uint // docmain
{
	/// No mouse buttons specified.
	NONE =      0,
	
	LEFT =      0x100000, ///
	RIGHT =     0x200000, /// ditto
	MIDDLE =    0x400000, /// ditto
	
	// Windows 2000+
	//XBUTTON1 =  0x800000,
	//XBUTTON2 =  0x1000000,
}


///
enum CheckState: ubyte
{
	UNCHECKED = BST_UNCHECKED, ///
	CHECKED = BST_CHECKED, /// ditto
	INDETERMINATE = BST_INDETERMINATE, /// ditto
}


///
struct Message // docmain
{
	union
	{
		struct
		{
			HWND hWnd; ///
			UINT msg; /// ditto
			WPARAM wParam; /// ditto
			LPARAM lParam; /// ditto
		}
		
		package MSG _winMsg; // .time and .pt are not always valid.
	}
	LRESULT result; ///
	
	
	/// Construct a Message struct.
	static Message opCall(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
	{
		Message m;
		m.hWnd = hWnd;
		m.msg = msg;
		m.wParam = wParam;
		m.lParam = lParam;
		m.result = 0;
		return m;
	}
}


///
interface IMessageFilter // docmain
{
	///
	// Return false to allow the message to be dispatched.
	// Filter functions cannot modify messages.
	bool preFilterMessage(inout Message m);
}


abstract class WaitHandle
{
	const int WAIT_TIMEOUT = os.win.gui.x.winapi.WAIT_TIMEOUT; // DMD 1.028: needs fqn, otherwise conflicts with std.thread
	const HANDLE INVALID_HANDLE = .INVALID_HANDLE_VALUE;
	
	
	this()
	{
		h = INVALID_HANDLE;
	}
	
	
	// Used internally.
	this(HANDLE h, bool owned = true)
	{
		this.h = h;
		this.owned = owned;
	}
	
	
	HANDLE handle() // getter
	{
		return h;
	}
	
	
	void handle(HANDLE h) // setter
	{
		this.h = h;
	}
	
	
	void close()
	{
		CloseHandle(h);
		h = INVALID_HANDLE;
	}
	
	
	~this()
	{
		if(owned)
			close();
	}
	
	
	private static DWORD _wait(WaitHandle[] handles, BOOL waitall, DWORD msTimeout)
	{
		// Some implementations fail with > 64 handles, but that will return WAIT_FAILED;
		// all implementations fail with >= 128 handles due to WAIT_ABANDONED_0 being 128.
		if(handles.length >= 128)
			goto fail;
		
		DWORD result;
		HANDLE* hs;
		//hs = new HANDLE[handles.length];
		hs = cast(HANDLE*)alloca(HANDLE.sizeof * handles.length);
		
		foreach(size_t i, WaitHandle wh; handles)
		{
			hs[i] = wh.handle;
		}
		
		result = WaitForMultipleObjects(handles.length, hs, waitall, msTimeout);
		if(WAIT_FAILED == result)
		{
			fail:
			throw new DflException("Wait failure");
		}
		return result;
	}
	
	
	static void waitAll(WaitHandle[] handles)
	{
		return waitAll(handles, INFINITE);
	}
	
	
	static void waitAll(WaitHandle[] handles, DWORD msTimeout)
	{
		_wait(handles, true, msTimeout);
	}
	
	
	static int waitAny(WaitHandle[] handles)
	{
		return waitAny(handles, INFINITE);
	}
	
	
	static int waitAny(WaitHandle[] handles, DWORD msTimeout)
	{
		DWORD result;
		result = _wait(handles, false, msTimeout);
		return cast(int)result; // Same return info.
	}
	
	
	void waitOne()
	{
		return waitOne(INFINITE);
	}
	
	
	void waitOne(DWORD msTimeout)
	{
		DWORD result;
		result = WaitForSingleObject(handle, msTimeout);
		if(WAIT_FAILED == result)
			throw new DflException("Wait failure");
	}
	
	
	private:
	HANDLE h;
	bool owned = true;
}


interface IAsyncResult
{
	WaitHandle asyncWaitHandle(); // getter
	
	// Usually just returns false.
	bool completedSynchronously(); // getter
	
	// When true, it is safe to release its resources.
	bool isCompleted(); // getter
}


/+
class AsyncResult: IAsyncResult
{
}
+/


///
interface IButtonControl // docmain
{
	///
	DialogResult dialogResult(); // getter
	/// ditto
	void dialogResult(DialogResult); // setter
	
	///
	void notifyDefault(bool); // True if default button.
	
	///
	void performClick(); // Raise click event.
}


///
enum DialogResult: ubyte // docmain
{
	NONE, ///
	
	ABORT = IDABORT, ///
	CANCEL = IDCANCEL, ///
	IGNORE = IDIGNORE, ///
	NO = IDNO, ///
	OK = IDOK, ///
	RETRY = IDRETRY, ///
	YES = IDYES, ///
	
	// Extra.
	CLOSE = IDCLOSE,
	HELP = IDHELP,
}


interface IDialogResult
{
	// ///
	DialogResult dialogResult(); // getter
	// /// ditto
	void dialogResult(DialogResult); // setter
}


///
enum SortOrder: ubyte
{
	NONE, ///
	
	ASCENDING, ///
	DESCENDING, /// ditto
}


///
enum View: ubyte
{
	LARGE_ICON, ///
	SMALL_ICON, ///
	LIST, ///
	DETAILS, ///
}


///
enum ItemBoundsPortion: ubyte
{
	ENTIRE, ///
	ICON, ///
	ITEM_ONLY, /// Excludes other stuff like check boxes.
	LABEL, /// Item's text.
}


///
enum ItemActivation: ubyte
{
	STANDARD, ///
	ONE_CLICK, ///
	TWO_CLICK, ///
}


///
enum ColumnHeaderStyle: ubyte
{
	CLICKABLE, ///
	NONCLICKABLE, ///
	NONE, /// No column header.
}


///
enum BorderStyle: ubyte
{
	NONE, ///
	
	FIXED_3D, ///
	FIXED_SINGLE, /// ditto
}


///
enum FlatStyle: ubyte
{
	STANDARD, ///
	FLAT, /// ditto
	POPUP, /// ditto
	SYSTEM, /// ditto
}


///
enum Appearance: ubyte
{
	NORMAL, ///
	BUTTON, ///
}


///
enum ContentAlignment: ubyte
{
	TOP_LEFT, ///
	BOTTOM_CENTER, ///
	BOTTOM_LEFT, ///
	BOTTOM_RIGHT, ///
	MIDDLE_CENTER, ///
	MIDDLE_LEFT, ///
	MIDDLE_RIGHT, ///
	TOP_CENTER, ///
	TOP_RIGHT, ///
}


///
enum CharacterCasing: ubyte
{
	NORMAL, ///
	LOWER, ///
	UPPER, ///
}


///
// Not flags.
enum ScrollBars: ubyte
{
	NONE, ///
	
	HORIZONTAL, ///
	VERTICAL, /// ditto
	BOTH, /// ditto
}


///
enum HorizontalAlignment: ubyte
{
	LEFT, ///
	RIGHT, /// ditto
	CENTER, /// ditto
}


///
enum DrawMode: ubyte
{
	NORMAL, ///
	OWNER_DRAW_FIXED, ///
	OWNER_DRAW_VARIABLE, /// ditto
}


///
enum DrawItemState: uint
{
	NONE = 0, ///
	SELECTED = 1, /// ditto
	DISABLED = 2, /// ditto
	CHECKED = 8, /// ditto
	FOCUS = 0x10, /// ditto
	DEFAULT = 0x20, /// ditto
	HOT_LIGHT = 0x40, /// ditto
	NO_ACCELERATOR = 0x80, /// ditto
	INACTIVE = 0x100, /// ditto
	NO_FOCUS_RECT = 0x200, /// ditto
	COMBO_BOX_EDIT = 0x1000, /// ditto
}


///
enum RightToLeft: ubyte
{
	INHERIT = 2, ///
	YES = 1, /// ditto
	NO = 0, /// ditto
}


///
enum ColorDepth: ubyte
{
	DEPTH_4BIT = 0x04, ///
	DEPTH_8BIT = 0x08, /// ditto
	DEPTH_16BIT = 0x10, /// ditto
	DEPTH_24BIT = 0x18, /// ditto
	DEPTH_32BIT = 0x20, /// ditto
}


///
class PaintEventArgs: EventArgs
{
	///
	this(Graphics graphics, Rect clipRect)
	{
		g = graphics;
		cr = clipRect;
	}
	
	
	///
	final Graphics graphics() // getter
	{
		return g;
	}
	
	
	///
	final Rect clipRectangle() // getter
	{
		return cr;
	}
	
	
	private:
	Graphics g;
	Rect cr;
}


///
class CancelEventArgs: EventArgs
{
	///
	// Initialize cancel to false.
	this()
	{
		cncl = false;
	}
	
	/// ditto
	this(bool cancel)
	{
		cncl = cancel;
	}
	
	
	///
	final void cancel(bool byes) // setter
	{
		cncl = byes;
	}
	
	/// ditto
	final bool cancel() // getter
	{
		return cncl;
	}
	
	
	private:
	bool cncl;
}


///
class KeyEventArgs: EventArgs
{
	///
	this(Keys keys)
	{
		ks = keys;
	}
	
	
	///
	final bool alt() // getter
	{
		return (ks & Keys.ALT) != 0;
	}
	
	
	///
	final bool control() // getter
	{
		return (ks & Keys.CONTROL) != 0;
	}
	
	
	///
	final void handled(bool byes) // setter
	{
		hand = byes;
	}
	
	///
	final bool handled() // getter
	{
		return hand;
	}
	
	
	///
	final Keys keyCode() // getter
	{
		return ks & Keys.KEY_CODE;
	}
	
	
	///
	final Keys keyData() // getter
	{
		return ks;
	}
	
	
	///
	// -keyData- as an int.
	final int keyValue() // getter
	{
		return cast(int)ks;
	}
	
	
	///
	final Keys modifiers() // getter
	{
		return ks & Keys.MODIFIERS;
	}
	
	
	///
	final bool shift() // getter
	{
		return (ks & Keys.SHIFT) != 0;
	}
	
	
	private:
	Keys ks;
	bool hand = false;
}


///
class KeyPressEventArgs: KeyEventArgs
{
	///
	this(dchar ch)
	{
		this(ch, (ch >= 'A' && ch <= 'Z') ? Keys.SHIFT : Keys.NONE);
	}
	
	/// ditto
	this(dchar ch, Keys modifiers)
	in
	{
		assert((modifiers & Keys.MODIFIERS) == modifiers, "параметр 'модификаторы' может содержать только модификаторы");
	}
	body
	{
		_keych = ch;
		
		int vk;
		if(os.win.gui.x.utf.useUnicode)
			vk = 0xFF & VkKeyScanW(ch);
		else
			vk = 0xFF & VkKeyScanA(cast(char)ch);
		
		super(cast(Keys)(vk | modifiers));
	}
	
	
	///
	final dchar keyChar() // getter
	{
		return _keych;
	}
	
	
	private:
	dchar _keych;
}


///
class MouseEventArgs: EventArgs
{
	///
	// -delta- is mouse wheel rotations.
	this(MouseButtons button, int clicks, int x, int y, int delta)
	{
		btn = button;
		clks = clicks;
		_x = x;
		_y = y;
		dlt = delta;
	}
	
	
	///
	final MouseButtons button() // getter
	{
		return btn;
	}
	
	
	///
	final int clicks() // getter
	{
		return clks;
	}
	
	
	///
	final int delta() // getter
	{
		return dlt;
	}
	
	
	///
	final int x() // getter
	{
		return _x;
	}
	
	
	///
	final int y() // getter
	{
		return _y;
	}
	
	
	private:
	MouseButtons btn;
	int clks;
	int _x, _y;
	int dlt;
}


/+
///
class LabelEditEventArgs: EventArgs
{
	///
	this(int index)
	{
		
	}
	
	/// ditto
	this(int index, Dstring labelText)
	{
		this.idx = index;
		this.ltxt = labelText;
	}
	
	
	///
	final void cancelEdit(bool byes) // setter
	{
		cancl = byes;
	}
	
	/// ditto
	final bool cancelEdit() // getter
	{
		return cancl;
	}
	
	
	///
	// The text of the label's edit.
	final Dstring label() // getter
	{
		return ltxt;
	}
	
	
	///
	// Gets the item's index.
	final int item() // getter
	{
		return idx;
	}
	
	
	private:
	int idx;
	Dstring ltxt;
	bool cancl = false;
}
+/


///
class ColumnClickEventArgs: EventArgs
{
	///
	this(int col)
	{
		this.col = col;
	}
	
	
	///
	final int column() // getter
	{
		return col;
	}
	
	
	private:
	int col;
}


///
class DrawItemEventArgs: EventArgs
{
	///
	this(Graphics g, Font f, Rect r, int i, DrawItemState dis)
	{
		this(g, f, r, i , dis, Color.empty, Color.empty);
	}
	
	/// ditto
	this(Graphics g, Font f, Rect r, int i, DrawItemState dis, Color fc, Color bc)
	{
		gpx = g;
		fnt = f;
		rect = r;
		idx = i;
		distate = dis;
		fcolor = fc;
		bcolor = bc;
	}
	
	
	///
	final Color backColor() // getter
	{
		return bcolor;
	}
	
	
	///
	final Rect bounds() // getter
	{
		return rect;
	}
	
	
	///
	final Font font() // getter
	{
		return fnt;
	}
	
	
	///
	final Color foreColor() // getter
	{
		return fcolor;
	}
	
	
	///
	final Graphics graphics() // getter
	{
		return gpx;
	}
	
	
	///
	final int index() // getter
	{
		return idx;
	}
	
	
	///
	final DrawItemState state() // getter
	{
		return distate;
	}
	
	
	///
	void drawBackground()
	{
		/+
		HBRUSH hbr;
		RECT _rect;
		
		hbr = bcolor.createBrush();
		try
		{
			rect.getRect(&_rect);
			FillRect(gpx.handle, &_rect, hbr);
		}
		finally
		{
			DeleteObject(hbr);
		}
		+/
		
		gpx.fillRectangle(bcolor, rect);
	}
	
	
	///
	void drawFocusRectangle()
	{
		if(distate & DrawItemState.FOCUS)
		{
			RECT _rect;
			rect.getRect(&_rect);
			DrawFocusRect(gpx.handle, &_rect);
		}
	}
	
	
	private:
	Graphics gpx;
	Font fnt; // Suggestion; the parent's font.
	Rect rect;
	int idx;
	DrawItemState distate;
	Color fcolor, bcolor; // Suggestion; depends on item state.
}


///
class MeasureItemEventArgs: EventArgs
{
	///
	this(Graphics g, int index, int itemHeight)
	{
		gpx = g;
		idx = index;
		iheight = itemHeight;
	}
	
	/// ditto
	this(Graphics g, int index)
	{
		this(g, index, 0);
	}
	
	
	///
	final Graphics graphics() // getter
	{
		return gpx;
	}
	
	
	///
	final int index() // getter
	{
		return idx;
	}
	
	
	///
	final void itemHeight(int height) // setter
	{
		iheight = height;
	}
	
	/// ditto
	final int itemHeight() // getter
	{
		return iheight;
	}
	
	
	///
	final void itemWidth(int width) // setter
	{
		iwidth = width;
	}
	
	/// ditto
	final int itemWidth() // getter
	{
		return iwidth;
	}
	
	
	private:
	Graphics gpx;
	int idx, iheight, iwidth = 0;
}


///
class Cursor // docmain
{
	private static Cursor _cur;
	
	
	// Used internally.
	this(HCURSOR hcur, bool owned = true)
	{
		this.hcur = hcur;
		this.owned = owned;
	}
	
	
	~this()
	{
		if(owned)
			dispose();
	}
	
	
	///
	void dispose()
	{
		assert(owned);
		DestroyCursor(hcur);
		hcur = HCURSOR.init;
	}
	
	
	///
	static void current(Cursor cur) // setter
	{
		// Keep a reference so that it doesn't get garbage collected until set again.
		_cur = cur;
		
		SetCursor(cur ? cur.hcur : HCURSOR.init);
	}
	
	/// ditto
	static Cursor current() // getter
	{
		HCURSOR hcur = GetCursor();
		return hcur ? new Cursor(hcur, false) : null;
	}
	
	
	///
	static void clip(Rect r) // setter
	{
		RECT rect;
		r.getRect(&rect);
		ClipCursor(&rect);
	}
	
	/// ditto
	static Rect clip() // getter
	{
		RECT rect;
		GetClipCursor(&rect);
		return Rect(&rect);
	}
	
	
	///
	final HCURSOR handle() // getter
	{
		return hcur;
	}
	
	
	/+
	// TODO:
	final Size size() // getter
	{
		Size result;
		ICONINFO iinfo;
		
		if(GetIconInfo(hcur, &iinfo))
		{
			
		}
		
		return result;
	}
	+/
	
	
	///
	// Uses the actual size.
	final void draw(Graphics g, Point pt)
	{
		DrawIconEx(g.handle, pt.x, pt.y, hcur, 0, 0, 0, HBRUSH.init, DI_NORMAL);
	}
	
	/+
	/// ditto
	// Should not stretch if bigger, but should crop if smaller.
	final void draw(Graphics g, Rect r)
	{
	}
	+/
	
	
	///
	final void drawStretched(Graphics g, Rect r)
	{
		// DrawIconEx operates differently if the width or height is zero
		// so bail out if zero and pretend the zero size cursor was drawn.
		int width = r.width;
		if(!width)
			return;
		int height = r.height;
		if(!height)
			return;
		
		DrawIconEx(g.handle, r.x, r.y, hcur, width, height, 0, HBRUSH.init, DI_NORMAL);
	}
	
	
	override Dequ opEquals(Object o)
	{
		Cursor cur = cast(Cursor)o;
		if(!cur)
			return 0; // Not equal.
		return opEquals(cur);
	}
	
	
	Dequ opEquals(Cursor cur)
	{
		return hcur == cur.hcur;
	}
	
	
	/// Show/hide the current mouse cursor; reference counted.
	// show/hide are ref counted.
	static void hide()
	{
		ShowCursor(false);
	}
	
	/// ditto
	// show/hide are ref counted.
	static void show()
	{
		ShowCursor(true);
	}
	
	
	/// The position of the current mouse cursor.
	static void position(Point pt) // setter
	{
		SetCursorPos(pt.x, pt.y);
	}
	
	/// ditto
	static Point position() // getter
	{
		Point pt;
		GetCursorPos(&pt.point);
		return pt;
	}
	
	
	private:
	HCURSOR hcur;
	bool owned = true;
}


///
class Cursors // docmain
{
	private this() {}
	
	
	static:
	
	///
	Cursor appStarting() // getter
	{ return new Cursor(LoadCursorA(HINSTANCE.init, IDC_APPSTARTING), false); }
	
	///
	Cursor arrow() // getter
	{ return new Cursor(LoadCursorA(HINSTANCE.init, IDC_ARROW), false); }
	
	///
	Cursor cross() // getter
	{ return new Cursor(LoadCursorA(HINSTANCE.init, IDC_CROSS), false); }
	
	///
	//Cursor default() // getter
	Cursor defaultCursor() // getter
	{ return arrow; }
	
	///
	Cursor hand() // getter
	{
		version(SUPPORTS_HAND_CURSOR) // Windows 98+
		{
			return new Cursor(LoadCursorA(HINSTANCE.init, IDC_HAND), false);
		}
		else
		{
			static HCURSOR hcurHand;
			
			if(!hcurHand)
			{
				hcurHand = LoadCursorA(HINSTANCE.init, IDC_HAND);
				if(!hcurHand) // Must be Windows 95, so load the cursor from winhlp32.exe.
				{
					UINT len;
					char[MAX_PATH] winhlppath = void;
					
					len = GetWindowsDirectoryA(winhlppath.ptr, winhlppath.length - 16);
					if(!len || len > winhlppath.length - 16)
					{
						load_failed:
						return arrow; // Just fall back to a normal arrow.
					}
					strcpy(winhlppath.ptr + len, "\\winhlp32.exe");
					
					HINSTANCE hinstWinhlp;
					hinstWinhlp = LoadLibraryExA(winhlppath.ptr, HANDLE.init, LOAD_LIBRARY_AS_DATAFILE);
					if(!hinstWinhlp)
						goto load_failed;
					
					HCURSOR hcur;
					hcur = LoadCursorA(hinstWinhlp, cast(char*)106);
					if(!hcur) // No such cursor resource.
					{
						FreeLibrary(hinstWinhlp);
						goto load_failed;
					}
					hcurHand = CopyCursor(hcur);
					if(!hcurHand)
					{
						FreeLibrary(hinstWinhlp);
						//throw new DflException("Unable to copy cursor resource");
						goto load_failed;
					}
					
					FreeLibrary(hinstWinhlp);
				}
			}
			
			assert(hcurHand);
			// Copy the cursor and own it here so that it's safe to dispose it.
			return new Cursor(CopyCursor(hcurHand));
		}
	}
	
	///
	Cursor help() // getter
	{
		HCURSOR hcur;
		hcur = LoadCursorA(HINSTANCE.init, IDC_HELP);
		if(!hcur) // IDC_HELP might not be supported on Windows 95, so fall back to a normal arrow.
			return arrow;
		return new Cursor(hcur);
	}
	
	///
	Cursor hSplit() // getter
	{
		// ...
		return sizeNS;
	}
	
	/// ditto
	Cursor vSplit() // getter
	{
		// ...
		return sizeWE;
	}
	
	
	///
	Cursor iBeam() // getter
	{ return new Cursor(LoadCursorA(HINSTANCE.init, IDC_IBEAM), false); }
	
	///
	Cursor no() // getter
	{ return new Cursor(LoadCursorA(HINSTANCE.init, IDC_NO), false); }
	
	
	///
	Cursor sizeAll() // getter
	{ return new Cursor(LoadCursorA(HINSTANCE.init, IDC_SIZEALL), false); }
	
	/// ditto
	Cursor sizeNESW() // getter
	{ return new Cursor(LoadCursorA(HINSTANCE.init, IDC_SIZENESW), false); }
	
	/// ditto
	Cursor sizeNS() // getter
	{ return new Cursor(LoadCursorA(HINSTANCE.init, IDC_SIZENS), false); }
	
	/// ditto
	Cursor sizeNWSE() // getter
	{ return new Cursor(LoadCursorA(HINSTANCE.init, IDC_SIZENWSE), false); }
	
	/// ditto
	Cursor sizeWE() // getter
	{ return new Cursor(LoadCursorA(HINSTANCE.init, IDC_SIZEWE), false); }
	
	
	/+
	///
	// Insertion point.
	Cursor upArrow() // getter
	{
		// ...
	}
	+/
	
	///
	Cursor waitCursor() // getter
	{ return new Cursor(LoadCursorA(HINSTANCE.init, IDC_WAIT), false); }
}

