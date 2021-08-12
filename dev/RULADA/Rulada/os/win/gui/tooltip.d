﻿// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.tooltip;


private import os.win.gui.x.dlib, std.c;

private import os.win.gui.control, os.win.gui.base, os.win.gui.application, os.win.gui.x.winapi,
	os.win.gui.x.utf;


///
class ToolTip // docmain
{
	package this(DWORD style)
	{
		_initCommonControls(ICC_TREEVIEW_CLASSES); // Includes tooltip.
		
		hwtt = CreateWindowExA(WS_EX_TOPMOST | WS_EX_TOOLWINDOW, _TOOLTIPS_CLASSA.ptr,
			"", style, 0, 0, 50, 50, null, null, null, null);
		if(!hwtt)
			throw new DflException("Unable to create tooltip");
	}
	
	
	this()
	{
		this(cast(DWORD)WS_POPUP);
	}
	
	
	~this()
	{
		removeAll(); // Fixes ref count.
		DestroyWindow(hwtt);
	}
	
	
	///
	final HWND handle() // getter
	{
		return hwtt;
	}
	
	
	///
	final void active(bool byes) // setter
	{
		SendMessageA(hwtt, TTM_ACTIVATE, byes, 0); // ?
		_active = byes;
	}
	
	/// ditto
	final bool active() // getter
	{
		return _active;
	}
	
	
	///
	// Sets autoPopDelay, initialDelay and reshowDelay.
	final void automaticDelay(DWORD ms) // setter
	{
		SendMessageA(hwtt, TTM_SETDELAYTIME, TTDT_AUTOMATIC, ms);
	}
	
	/+
	/// ditto
	final DWORD automaticDelay() // getter
	{
	}
	+/
	
	
	///
	final void autoPopDelay(DWORD ms) // setter
	{
		SendMessageA(hwtt, TTM_SETDELAYTIME, TTDT_AUTOPOP, ms);
	}
	
	/+
	/// ditto
	final DWORD autoPopDelay() // getter
	{
	}
	+/
	
	
	///
	final void initialDelay(DWORD ms) // setter
	{
		SendMessageA(hwtt, TTM_SETDELAYTIME, TTDT_INITIAL, ms);
	}
	
	/+
	/// ditto
	final DWORD initialDelay() // getter
	{
	}
	+/
	
	
	///
	final void reshowDelay(DWORD ms) // setter
	{
		SendMessageA(hwtt, TTM_SETDELAYTIME, TTDT_RESHOW, ms);
	}
	
	/+
	/// ditto
	final DWORD reshowDelay() // getter
	{
	}
	+/
	
	
	///
	final void showAlways(bool byes) // setter
	{
		LONG wl;
		wl = GetWindowLongA(hwtt, GWL_STYLE);
		if(byes)
		{
			if(wl & TTS_ALWAYSTIP)
				return;
			wl |= TTS_ALWAYSTIP;
		}
		else
		{
			if(!(wl & TTS_ALWAYSTIP))
				return;
			wl &= ~TTS_ALWAYSTIP;
		}
		SetWindowLongA(hwtt, GWL_STYLE, wl);
	}
	
	/// ditto
	final bool showAlways() // getter
	{
		return (GetWindowLongA(hwtt, GWL_STYLE) & TTS_ALWAYSTIP) != 0;
	}
	
	
	///
	// Remove all tooltip text associated with this instance.
	final void removeAll()
	{
		TOOLINFOA tool;
		tool.cbSize = TOOLINFOA.sizeof;
		while(SendMessageA(hwtt, TTM_constTOOLSA, 0, cast(LPARAM)&tool))
		{
			SendMessageA(hwtt, TTM_DELTOOLA, 0, cast(LPARAM)&tool);
			Application.refCountDec(cast(void*)this);
		}
	}
	
	
	///
	// WARNING: possible buffer overflow.
	final Dstring getToolTip(Control ctrl)
	{
		Dstring result;
		TOOLINFOA tool;
		tool.cbSize = TOOLINFOA.sizeof;
		tool.uFlags = TTF_IDISHWND;
		tool.hwnd = ctrl.handle;
		tool.uId = cast(UINT)ctrl.handle;
		
		if(os.win.gui.x.utf.useUnicode)
		{
			tool.lpszText = cast(typeof(tool.lpszText))std.c.malloc((MAX_TIP_TEXT_LENGTH + 1) * wchar.sizeof);
			if(!tool.lpszText)
				throw new OomException;
			scope(exit)
				std.c.free(tool.lpszText);
			tool.lpszText[0 .. 2] = 0;
			SendMessageA(hwtt, TTM_GETTEXTW, 0, cast(LPARAM)&tool);
			if(!(cast(wchar*)tool.lpszText)[0])
				result = null;
			else
				result = fromUnicodez(cast(wchar*)tool.lpszText);
		}
		else
		{
			tool.lpszText = cast(typeof(tool.lpszText))std.c.malloc(MAX_TIP_TEXT_LENGTH + 1);
			if(!tool.lpszText)
				throw new OomException;
			scope(exit)
				std.c.free(tool.lpszText);
			tool.lpszText[0] = 0;
			SendMessageA(hwtt, TTM_GETTEXTA, 0, cast(LPARAM)&tool);
			if(!tool.lpszText[0])
				result = null;
			else
				result = fromAnsiz(tool.lpszText); // Assumes fromAnsiz() copies.
		}
		return result;
	}
	
	/// ditto
	final void setToolTip(Control ctrl, Dstring text)
	in
	{
		try
		{
			ctrl.createControl();
		}
		catch(Object o)
		{
			assert(0); // If -ctrl- is a child, make sure the parent is set before setting tool tip text.
			//throw o;
		}
	}
	body
	{
		TOOLINFOA tool;
		tool.cbSize = TOOLINFOA.sizeof;
		tool.uFlags = TTF_IDISHWND;
		tool.hwnd = ctrl.handle;
		tool.uId = cast(UINT)ctrl.handle;
		
		if(!text.length)
		{
			if(SendMessageA(hwtt, TTM_GETTOOLINFOA, 0, cast(LPARAM)&tool))
			{
				// Remove.
				
				SendMessageA(hwtt, TTM_DELTOOLA, 0, cast(LPARAM)&tool);
				
				Application.refCountDec(cast(void*)this);
			}
			return;
		}
		
		// Hack to help prevent getToolTip() overflow.
		if(text.length > MAX_TIP_TEXT_LENGTH)
			text = text[0 .. MAX_TIP_TEXT_LENGTH];
		
		if(SendMessageA(hwtt, TTM_GETTOOLINFOA, 0, cast(LPARAM)&tool))
		{
			// Update.
			
			if(os.win.gui.x.utf.useUnicode)
			{
				tool.lpszText = cast(typeof(tool.lpszText))toUnicodez(text);
				SendMessageA(hwtt, TTM_UPDATETIPTEXTW, 0, cast(LPARAM)&tool);
			}
			else
			{
				tool.lpszText = cast(typeof(tool.lpszText))unsafeAnsiz(text);
				SendMessageA(hwtt, TTM_UPDATETIPTEXTA, 0, cast(LPARAM)&tool);
			}
		}
		else
		{
			// Add.
			
			/+
			// TOOLINFOA.rect is ignored if TTF_IDISHWND.
			tool.rect.left = 0;
			tool.rect.top = 0;
			tool.rect.right = ctrl.clientSize.width;
			tool.rect.bottom = ctrl.clientSize.height;
			+/
			tool.uFlags |= TTF_SUBCLASS; // Not a good idea ?
			LRESULT lr;
			if(os.win.gui.x.utf.useUnicode)
			{
				tool.lpszText = cast(typeof(tool.lpszText))toUnicodez(text);
				lr = SendMessageA(hwtt, TTM_ADDTOOLW, 0, cast(LPARAM)&tool);
			}
			else
			{
				tool.lpszText = cast(typeof(tool.lpszText))unsafeAnsiz(text);
				lr = SendMessageA(hwtt, TTM_ADDTOOLA, 0, cast(LPARAM)&tool);
			}
			
			if(lr)
				Application.refCountInc(cast(void*)this);
		}
	}
	
	
	private:
	const Dstring _TOOLTIPS_CLASSA = "tooltips_class32";
	const size_t MAX_TIP_TEXT_LENGTH = 2045;
	
	HWND hwtt; // Tooltip control handle.
	bool _active = true;
}

