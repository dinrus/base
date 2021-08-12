/***********************************************************************\
*                               exdisp.d                                *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module win32.exdisp;

import win32.docobj, win32.oaidl, win32.ocidl;
private import win32.basetyps, win32.windef, win32.wtypes;


enum BrowserNavConstants {
	navOpenInNewWindow = 0x01,
	navNoHistory       = 0x02,
	navNoReadFromCache = 0x04,
	navNoWriteTocache  = 0x08,
	navAllowAutosearch = 0x10,
	navBrowserBar      = 0x20,
	navHyperLink       = 0x40
}

interface IWebBrowser : public IDispatch {
	HRESULT GoBack();
	HRESULT GoForward();
	HRESULT GoHome();
	HRESULT GoSearch();
	HRESULT Navigate(BSTR, VARIANT*, VARIANT*, VARIANT*, VARIANT*);
	HRESULT Refresh();
	HRESULT Refresh2(VARIANT*);
	HRESULT Stop();
	HRESULT get_Application(IDispatch* ppDisp);
	HRESULT get_Parent(IDispatch* ppDisp);
	HRESULT get_Container(IDispatch* ppDisp);
	HRESULT get_Document(IDispatch* ppDisp);
	HRESULT get_TopLevelContainer(VARIANT_BOOL*);
	HRESULT get_Type(BSTR*);
	HRESULT get_Left(LONG*);
	HRESULT put_Left(LONG);
	HRESULT get_Top(LONG*);
	HRESULT put_Top(LONG);
	HRESULT get_Width(LONG*);
	HRESULT put_Width(LONG);
	HRESULT get_Height(LONG*);
	HRESULT put_Height(LONG);
	HRESULT get_LocationName(BSTR*);
	HRESULT get_LocationURL(BSTR*);
	HRESULT get_Busy(VARIANT_BOOL*);
}

interface IWebBrowserApp : public IWebBrowser {
	HRESULT Quit();
	HRESULT ClientToWindow(цел*, цел*);
	HRESULT PutProperty(BSTR, VARIANT);
	HRESULT GetProperty(BSTR, VARIANT*);
	HRESULT get_Name(BSTR*);
	HRESULT get_HWND(LONG*);
	HRESULT get_FullName(BSTR*);
	HRESULT get_Path(BSTR*);
	HRESULT get_Visible(VARIANT_BOOL*);
	HRESULT put_Visible(VARIANT_BOOL);
	HRESULT get_StatusBar(VARIANT_BOOL*);
	HRESULT put_StatusBar(VARIANT_BOOL);
	HRESULT get_StatusText(BSTR*);
	HRESULT put_StatusText(BSTR);
	HRESULT get_ToolBar(цел*);
	HRESULT put_ToolBar(цел);
	HRESULT get_MenuBar(VARIANT_BOOL*);
	HRESULT put_MenuBar(VARIANT_BOOL);
	HRESULT get_FullScreen(VARIANT_BOOL*);
	HRESULT put_FullScreen(VARIANT_BOOL);
}

interface IWebBrowser2 : public IWebBrowserApp {
	HRESULT Navigate2(VARIANT*, VARIANT*, VARIANT*, VARIANT*, VARIANT*);
	HRESULT QueryStatusWB(OLECMDID, OLECMDF*);
	HRESULT ExecWB(OLECMDID, OLECMDEXECOPT, VARIANT*, VARIANT*);
	HRESULT ShowBrowserBar(VARIANT*, VARIANT*, VARIANT*);
	HRESULT get_ReadyState(READYSTATE*);
	HRESULT get_Offline(VARIANT_BOOL*);
	HRESULT put_Offline(VARIANT_BOOL);
	HRESULT get_Silent(VARIANT_BOOL*);
	HRESULT put_Silent(VARIANT_BOOL);
	HRESULT get_RegistaerAsBrowser(VARIANT_BOOL*);
	HRESULT put_RegisterAsBrowser(VARIANT_BOOL);
	HRESULT get_RegistaerAsDropTarget(VARIANT_BOOL*);
	HRESULT put_RegisterAsDropTarget(VARIANT_BOOL);
	HRESULT get_TheaterMode(VARIANT_BOOL*);
	HRESULT put_TheaterMode(VARIANT_BOOL);
	HRESULT get_AddressBar(VARIANT_BOOL*);
	HRESULT put_AddressBar(VARIANT_BOOL);
	HRESULT get_Resizable(VARIANT_BOOL*);
	HRESULT put_Resizable(VARIANT_BOOL);
}

interface DWebBrowserEvents2 : public IDispatch {
	проц StatusTextChange(BSTR);
	проц ProgressChange(LONG, LONG);
	проц CommandStateChange(LONG, VARIANT_BOOL);
	проц DownloadBegin();
	проц DownloadComplete();
	проц TitleChange(BSTR);
	проц PropertyChange(BSTR);
	проц BeforeNavigate2(IDispatch pDisp, VARIANT*, VARIANT*, VARIANT*, VARIANT*, VARIANT*, VARIANT_BOOL*);
	проц NewWindow2(IDispatch* ppDisp, VARIANT_BOOL*);
	проц NavigateComplete(IDispatch pDisp, VARIANT*);
	проц DocumentComplete(IDispatch pDisp, VARIANT*);
	проц OnQuit();
	проц OnVisible(VARIANT_BOOL);
	проц OnToolBar(VARIANT_BOOL);
	проц OnMenuBar(VARIANT_BOOL);
	проц OnStatusBar(VARIANT_BOOL);
	проц OnFullScreen(VARIANT_BOOL);
	проц OnTheaterMode(VARIANT_BOOL);
	проц WindowSetResizable(VARIANT_BOOL);
	проц WindowSetLeft(LONG);
	проц WindowSetTop(LONG);
	проц WindowSetWidth(LONG);
	проц WindowSetHeight(LONG);
	проц WindowClosing(VARIANT_BOOL, VARIANT_BOOL*);
	проц ClientToHostWindow(LONG*, LONG*);
	проц SetSecureLockIcon(LONG);
	проц FileDownload(VARIANT_BOOL*);
}
