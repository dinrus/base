/**
 * Provides methods for sending данные to and receiving данные from a resource indentified by a URI.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.net.client;

import win32.base.core,
  win32.base.string,
  win32.base.text,
  win32.base.native,
  win32.io.path,
  win32.io.fs,
  win32.com.core,
  win32.net.core,
  stdrus, tpl.stream;
 import cidrus, sys.WinConsts;

 alias win32.base.string.разбей разбей;

extern (Windows) проц CloseInternetHandle(Укз hwnd);

version(D_Version2) {
  debug import stdrus : пишинс, скажифнс;
}
else {
  debug import stdrus : скажифнс;
}

interface IBinding : IUnknown {
  mixin(ууид("79eac9c0-baf9-11ce-8c82-00aa004ba90b"));

  цел Abort();
  цел Suspend();
  цел Resume();
  цел SetPriority(цел nPriority);
  цел GetPriority(out цел pnPriority);
  цел GetBindResult(out GUID pclsidProtocol, out бцел pdwResult, out шим* pszResult, бцел* pdwReserved);
}

enum : бцел {
  BINDSTATUS_FINDINGRESOURCE = 1,
  BINDSTATUS_CONNECTING,
  BINDSTATUS_REDIRECTING,
  BINDSTATUS_BEGINDOWNLOADDATA,
  BINDSTATUS_DOWNLOADINGDATA,
  BINDSTATUS_ENDDOWNLOADDATA,
  BINDSTATUS_BEGINDOWNLOADCOMPONENTS,
  BINDSTATUS_INSTALLINGCOMPONENTS,
  BINDSTATUS_ENDDOWNLOADCOMPONENTS,
  BINDSTATUS_USINGCACHEDCOPY,
  BINDSTATUS_SENDINGREQUEST,
  BINDSTATUS_CLASSIDAVAILABLE,
  BINDSTATUS_MIMETYPEAVAILABLE,
  BINDSTATUS_CACHEFILENAMEAVAILABLE,
  BINDSTATUS_BEGINSYNCOPERATION,
  BINDSTATUS_ENDSYNCOPERATION,
  BINDSTATUS_BEGINUPLOADDATA,
  BINDSTATUS_UPLOADINGDATA,
  BINDSTATUS_ENDUPLOADDATA,
  BINDSTATUS_PROTOCOLCLASSID,
  BINDSTATUS_ENCODING,
  BINDSTATUS_VERIFIEDMIMETYPEAVAILABLE,
  BINDSTATUS_CLASSINSTALLLOCATION,
  BINDSTATUS_DECODING,
  BINDSTATUS_LOADINGMIMEHANDLER,
  BINDSTATUS_CONTENTDISPOSITIONATTACH,
  BINDSTATUS_FILTERREPORTMIMETYPE,
  BINDSTATUS_CLSIDCANINSTANTIATE,
  BINDSTATUS_IUNKNOWNAVAILABLE,
  BINDSTATUS_DIRECTBIND,
  BINDSTATUS_RAWMIMETYPE,
  BINDSTATUS_PROXYDETECTING,
  BINDSTATUS_ACCEPTRANGES,
  BINDSTATUS_COOKIE_SENT,
  BINDSTATUS_COOKIE_SUPPRESSED,
  BINDSTATUS_COOKIE_STATE_UNKNOWN,
  BINDSTATUS_COOKIE_STATE_ACCEPT,
}

enum : бцел {
  BINDVERB_GET    = 0x0,
  BINDVERB_POST   = 0x1,
  BINDVERB_PUT    = 0x2,
  BINDVERB_CUSTOM = 0x3
}

enum : бцел {
  BINDF_ASYNCHRONOUS           = 0x1,
  BINDF_ASYNCSTORAGE           = 0x2,
  BINDF_NOPROGRESSIVERENDERING = 0x4,
  BINDF_OFFLINEOPERATION       = 0x8,
  BINDF_GETNEWESTVERSION       = 0x10,
  BINDF_NEEDFILE               = 0x40,
  BINDF_NOWRITECACHE           = 0x20,
  BINDF_PULLDATA               = 0x80
}

struct BINDINFO {
  бцел cbSize = BINDINFO.sizeof;
  шим* szExtraInfo;
  STGMEDIUM stgmedData;
  бцел grfBindInfoF;
  бцел dwBindVerb;
  шим* szCustomVerb;
  бцел cbstgmedData;
  бцел dwOptions;
  бцел dwOptionsFlags;
  бцел dwCodePage;
  SECURITY_ATTRIBUTES securityAttributes;
  GUID iid;
  IUnknown pUnk;
  бцел dwReserved;
}

extern(Windows)
interface IBindStatusCallback : IUnknown {
  mixin(ууид("79eac9c1-baf9-11ce-8c82-00aa004ba90b"));

  цел OnStartBinding(бцел dwReserved, IBinding pib);
  цел GetPriority(out цел pnPriority);
  цел OnLowResource(бцел reserved);
  цел OnProgress(бцел ulProgress, бцел ulProgressMax, бцел ulStatusCode, in шим* szStatusText);
  цел OnStopBinding(цел hresult, in шим* szError);
  цел GetBindInfo(out бцел grfBINDF, BINDINFO* pbindinfo);
  цел OnDataAvailable(бцел grfBSCF, бцел dwSize, FORMATETC* pformatetc, STGMEDIUM* pstgmed);
  цел OnObjectAvailable(ref GUID riid, IUnknown punk);
}

interface IHttpNegotiate : IUnknown {
  mixin(ууид("79eac9d2-baf9-11ce-8c82-00aa004ba90b"));

  цел BeginningTransaction(in шим* szURL, in шим* szHeaders, бцел dwReserved, шим** pszAdditionalHeaders);
  цел OnResponse(бцел dwResponseCode, in шим* szResponseHeaders, in шим* szRequestHeaders, шим** pszAdditionalRequestHeaders);
}

extern(Windows)
alias ДллИмпорт!("urlmon.dll", "URLOpenStream",
  цел function(IUnknown caller, in шим* szURL, бцел, IBindStatusCallback lpfnCallback)) URLOpenStream;

enum : бцел {        
  URL_MK_LEGACY          = 0,
  URL_MK_UNIFORM         = 1,
  URL_MK_NO_CANONICALIZE = 2
}

extern(Windows)
alias ДллИмпорт!("urlmon.dll", "CreateURLMonikerEx",
  цел function(IMoniker pMkCtx, in шим* szURL, IMoniker* ppmk, бцел dwFlags)) CreateURLMonikerEx;

extern(Windows)
alias ДллИмпорт!("urlmon.dll", "CreateAsyncBindCtx",
  цел function(бцел reserved, IBindStatusCallback pBSCb, IEnumFORMATETC pEFetc, IBindCtx* ppBC)) CreateAsyncBindCtx;

extern(Windows)
alias ДллИмпорт!("urlmon.dll", "RegisterBindStatusCallback",
  цел function(IBindCtx pbc, IBindStatusCallback pbsc, IBindStatusCallback* ppbscPrevious, бцел dwReserved)) RegisterBindStatusCallback;

enum : бцел {
  INTERNET_OPEN_TYPE_PRECONFIG                   = 0,
  INTERNET_OPEN_TYPE_DIRECT                      = 1,
  INTERNET_OPEN_TYPE_PROXY                       = 3,
  INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY = 4
}

extern(Windows)
alias ДллИмпорт!("wininet.dll", "InternetOpenW",
  Укз function(in шим* lpszAgent, бцел dwAccessType, in шим* lpszProxy, in шим* lpszProxyBypass, бцел dwFlags)) InternetOpen;

extern(Windows)
alias ДллИмпорт!("wininet.dll", "InternetCloseHandle",
  цел function(Укз hInternet)) InternetCloseHandle;

// dwInternetStatus
enum : бцел {
  INTERNET_STATUS_RESOLVING_NAME        = 10,
  INTERNET_STATUS_NAME_RESOLVED         = 11,
  INTERNET_STATUS_CONNECTING_TO_SERVER  = 20,
  INTERNET_STATUS_CONNECTED_TO_SERVER   = 21,
  INTERNET_STATUS_SENDING_REQUEST       = 30,
  INTERNET_STATUS_REQUEST_SENT          = 31,
  INTERNET_STATUS_RECEIVING_RESPONSE    = 40,
  INTERNET_STATUS_RESPONSE_RECEIVED     = 41,
  INTERNET_STATUS_CTL_RESPONSE_RECEIVED = 42,
  INTERNET_STATUS_PREFETCH              = 43,
  INTERNET_STATUS_CLOSING_CONNECTION    = 50,
  INTERNET_STATUS_CONNECTION_CLOSED     = 51,
  INTERNET_STATUS_HANDLE_CREATED        = 60,
  INTERNET_STATUS_HANDLE_CLOSING        = 70,
  INTERNET_STATUS_DETECTING_PROXY       = 80,
  INTERNET_STATUS_REQUEST_COMPLETE      = 100,
  INTERNET_STATUS_REDIRECT              = 110,
  INTERNET_STATUS_INTERMEDIATE_RESPONSE = 120,
  INTERNET_STATUS_USER_INPUT_REQUIRED   = 140,
  INTERNET_STATUS_STATE_CHANGE          = 200,
  INTERNET_STATUS_COOKIE_SENT           = 320,
  INTERNET_STATUS_COOKIE_RECEIVED       = 321,
  INTERNET_STATUS_PRIVACY_IMPACTED      = 324,
  INTERNET_STATUS_P3P_HEADER            = 325,
  INTERNET_STATUS_P3P_POLICYREF         = 326,
  INTERNET_STATUS_COOKIE_HISTORY        = 327
}

extern(Windows)
alias проц function(Укз hInternet, бцел dwContext, бцел dwInternetStatus, ук lpvStatusInformation, бцел dwStatusInformationLength) INTERNET_STATUS_CALLBACK;

extern(Windows)
alias ДллИмпорт!("wininet.dll", "InternetSetStatusCallbackW", 
  INTERNET_STATUS_CALLBACK function(Укз hInternet, INTERNET_STATUS_CALLBACK lpfnStatusCallback)) InternetSetStatusCallback;

struct INTERNET_ASYNC_RESULT {
  бцел dwResult;
  бцел dwError;
}

enum : бцел {
  INTERNET_SERVICE_FTP    = 1,
  INTERNET_SERVICE_GOPHER = 2,
  INTERNET_SERVICE_HTTP   = 3
}

enum : бцел {
  INTERNET_FLAG_ASYNC           = 0x10000000,
  INTERNET_FLAG_RELOAD          = 0x80000000,
  INTERNET_FLAG_PASSIVE         = 0x08000000,
  INTERNET_FLAG_NO_CACHE_WRITE  = 0x04000000,
  INTERNET_FLAG_DONT_CACHE      = INTERNET_FLAG_NO_CACHE_WRITE,
  INTERNET_FLAG_MAKE_PERSISTENT = 0x02000000,
  INTERNET_FLAG_FROM_CACHE      = 0x01000000,
  INTERNET_FLAG_OFFLINE         = INTERNET_FLAG_FROM_CACHE
}

extern(Windows)
alias ДллИмпорт!("wininet.dll", "InternetConnectW",
  Укз function(Укз hInternet, in шим* lpszServerName, бкрат nServerPort, in шим* lpszUserName, in шим* lpszPassword, бцел dwService, бцел dwFlags, бцел dwContext)) InternetConnect;

extern(Windows)
alias ДллИмпорт!("wininet.dll", "InternetOpenUrlW",
  Укз function(Укз hInternet, in шим* lpszUrl, in шим* lpszHeaders, бцел dwHeadersLength, бцел dwFlags, бцел dwContext)) InternetOpenUrl;

const шим* HTTP_VERSION = "HTTP/1.0";

extern(Windows)
alias ДллИмпорт!("wininet.dll", "HttpOpenRequestW",
  Укз function(Укз hConnect, in шим* lpszVerb, in шим* lpszObjectName, in шим* lpszVersion, in шим* lpszReferrer, in шим** lplpszAcceptTypes, бцел dwFlags, бцел dwContext)) HttpOpenRequest;

extern(Windows)
alias ДллИмпорт!("wininet.dll", "HttpSendRequestW",
  цел function(Укз hRequest, in шим* lpszHeaders, бцел dwHeadersLength, in ук lpOptional, бцел dwOptionalLength)) HttpSendRequest;

struct INTERNET_BUFFERSW {
  бцел dwStructSize = INTERNET_BUFFERSW.sizeof;
  INTERNET_BUFFERSW* Next;
  version(D_Version2) {
    mixin("
    const(шим)* lpcszHeader;
    ");
  }
  else {
    шим* lpcszHeader;
  }
  бцел dwHeadersLength;
  бцел dwHeadersTotal;
  ук lpvBuffer;
  бцел dwBufferLength;
  бцел dwBufferTotal;
  бцел dwOffsetLow;
  бцел dwOffsetHigh;
}
alias INTERNET_BUFFERSW INTERNET_BUFFERS;

enum : бцел {
  HSR_ASYNC = 0x00000001
}

extern(Windows)
alias ДллИмпорт!("wininet.dll", "HttpSendRequestExW",
  цел function(Укз hRequest, INTERNET_BUFFERSW* lpBuffersIn, INTERNET_BUFFERSW* lpBuffersOut, бцел dwFlags, бцел dwContext)) HttpSendRequestEx;

extern(Windows)
alias ДллИмпорт!("wininet.dll", "HttpEndRequestW",
  цел function(Укз hRequest, INTERNET_BUFFERSW* lpBuffersOut, бцел dwFlags, бцел dwContext)) HttpEndRequest;

enum : бцел {
  HTTP_QUERY_MIME_VERSION                = 0,
  HTTP_QUERY_CONTENT_TYPE                = 1,
  HTTP_QUERY_CONTENT_TRANSFER_ENCODING   = 2,
  HTTP_QUERY_CONTENT_ID                  = 3,
  HTTP_QUERY_CONTENT_DESCRIPTION         = 4,
  HTTP_QUERY_CONTENT_LENGTH              = 5,
  HTTP_QUERY_CONTENT_LANGUAGE            = 6,
  HTTP_QUERY_ALLOW                       = 7,
  HTTP_QUERY_PUBLIC                      = 8,
  HTTP_QUERY_DATE                        = 9,
  HTTP_QUERY_EXPIRES                     = 10,
  HTTP_QUERY_LAST_MODIFIED               = 11,
  HTTP_QUERY_MESSAGE_ID                  = 12,
  HTTP_QUERY_URI                         = 13,
  HTTP_QUERY_DERIVED_FROM                = 14,
  HTTP_QUERY_COST                        = 15,
  HTTP_QUERY_LINK                        = 16,
  HTTP_QUERY_PRAGMA                      = 17,
  HTTP_QUERY_VERSION                     = 18,
  HTTP_QUERY_STATUS_CODE                 = 19,
  HTTP_QUERY_STATUS_TEXT                 = 20,
  HTTP_QUERY_RAW_HEADERS                 = 21,
  HTTP_QUERY_RAW_HEADERS_CRLF            = 22,
  HTTP_QUERY_CONNECTION                  = 23,
  HTTP_QUERY_ACCEPT                      = 24,
  HTTP_QUERY_ACCEPT_CHARSET              = 25,
  HTTP_QUERY_ACCEPT_ENCODING             = 26,
  HTTP_QUERY_ACCEPT_LANGUAGE             = 27,
  HTTP_QUERY_AUTHORIZATION               = 28,
  HTTP_QUERY_CONTENT_ENCODING            = 29,
  HTTP_QUERY_FORWARDED                   = 30,
  HTTP_QUERY_FROM                        = 31,
  HTTP_QUERY_IF_MODIFIED_SINCE           = 32,
  HTTP_QUERY_LOCATION                    = 33,
  HTTP_QUERY_ORIG_URI                    = 34,
  HTTP_QUERY_REFERER                     = 35,
  HTTP_QUERY_RETRY_AFTER                 = 36,
  HTTP_QUERY_SERVER                      = 37,
  HTTP_QUERY_TITLE                       = 38,
  HTTP_QUERY_USER_AGENT                  = 39,
  HTTP_QUERY_WWW_AUTHENTICATE            = 40,
  HTTP_QUERY_PROXY_AUTHENTICATE          = 41,
  HTTP_QUERY_ACCEPT_RANGES               = 42,
  HTTP_QUERY_SET_COOKIE                  = 43,
  HTTP_QUERY_COOKIE                      = 44,
  HTTP_QUERY_REQUEST_METHOD              = 45,
  HTTP_QUERY_REFRESH                     = 46,
  HTTP_QUERY_CONTENT_DISPOSITION         = 47,
  HTTP_QUERY_AGE                         = 48,
  HTTP_QUERY_CACHE_CONTROL               = 49,
  HTTP_QUERY_CONTENT_BASE                = 50,
  HTTP_QUERY_CONTENT_LOCATION            = 51,
  HTTP_QUERY_CONTENT_MD5                 = 52,
  HTTP_QUERY_CONTENT_RANGE               = 53,
  HTTP_QUERY_ETAG                        = 54,
  HTTP_QUERY_HOST                        = 55,
  HTTP_QUERY_IF_MATCH                    = 56,
  HTTP_QUERY_IF_NONE_MATCH               = 57,
  HTTP_QUERY_IF_RANGE                    = 58,
  HTTP_QUERY_IF_UNMODIFIED_SINCE         = 59,
  HTTP_QUERY_MAX_FORWARDS                = 60,
  HTTP_QUERY_PROXY_AUTHORIZATION         = 61,
  HTTP_QUERY_RANGE                       = 62,
  HTTP_QUERY_TRANSFER_ENCODING           = 63,
  HTTP_QUERY_UPGRADE                     = 64,
  HTTP_QUERY_VARY                        = 65,
  HTTP_QUERY_VIA                         = 66,
  HTTP_QUERY_WARNING                     = 67,
  HTTP_QUERY_EXPECT                      = 68,
  HTTP_QUERY_PROXY_CONNECTION            = 69,
  HTTP_QUERY_UNLESS_MODIFIED_SINCE       = 70,
  HTTP_QUERY_ECHO_REQUEST                = 71,
  HTTP_QUERY_ECHO_REPLY                  = 72,
  HTTP_QUERY_ECHO_HEADERS                = 73,
  HTTP_QUERY_ECHO_HEADERS_CRLF           = 74,
  HTTP_QUERY_PROXY_SUPPORT               = 75,
  HTTP_QUERY_AUTHENTICATION_INFO         = 76,
  HTTP_QUERY_PASSPORT_URLS               = 77,
  HTTP_QUERY_PASSPORT_CONFIG             = 78
}

enum : бцел {
  HTTP_QUERY_FLAG_COALESCE        = 0x10000000,
  HTTP_QUERY_FLAG_NUMBER          = 0x20000000,
  HTTP_QUERY_FLAG_SYSTEMTIME      = 0x40000000,
  HTTP_QUERY_FLAG_REQUEST_HEADERS = 0x80000000
}

enum : бцел {
  HTTP_STATUS_CONTINUE           = 100,
  HTTP_STATUS_SWITCH_PROTOCOLS   = 101,
  HTTP_STATUS_OK                 = 200,
  HTTP_STATUS_CREATED            = 201,
  HTTP_STATUS_ACCEPTED           = 202,
  HTTP_STATUS_PARTIAL            = 203,
  HTTP_STATUS_NO_CONTENT         = 204,
  HTTP_STATUS_RESET_CONTENT      = 205,
  HTTP_STATUS_PARTIAL_CONTENT    = 206,
  HTTP_STATUS_AMBIGUOUS          = 300,
  HTTP_STATUS_MOVED              = 301,
  HTTP_STATUS_REDIRECT           = 302,
  HTTP_STATUS_REDIRECT_METHOD    = 303,
  HTTP_STATUS_NOT_MODIFIED       = 304,
  HTTP_STATUS_USE_PROXY          = 305,
  HTTP_STATUS_REDIRECT_KEEP_VERB = 307,
  HTTP_STATUS_BAD_REQUEST        = 400,
  HTTP_STATUS_DENIED             = 401,
  HTTP_STATUS_PAYMENT_REQ        = 402,
  HTTP_STATUS_FORBIDDEN          = 403,
  HTTP_STATUS_NOT_FOUND          = 404,
  HTTP_STATUS_BAD_METHOD         = 405,
  HTTP_STATUS_NONE_ACCEPTABLE    = 406,
  HTTP_STATUS_PROXY_AUTH_REQ     = 407,
  HTTP_STATUS_REQUEST_TIMEOUT    = 408,
  HTTP_STATUS_CONFLICT           = 409,
  HTTP_STATUS_GONE               = 410,
  HTTP_STATUS_LENGTH_REQUIRED    = 411,
  HTTP_STATUS_PRECOND_FAILED     = 412,
  HTTP_STATUS_REQUEST_TOO_LARGE  = 413,
  HTTP_STATUS_URI_TOO_LONG       = 414,
  HTTP_STATUS_UNSUPPORTED_MEDIA  = 415,
  HTTP_STATUS_RETRY_WITH         = 449,
  HTTP_STATUS_SERVER_ERROR       = 500,
  HTTP_STATUS_NOT_SUPPORTED      = 501,
  HTTP_STATUS_BAD_GATEWAY        = 502,
  HTTP_STATUS_SERVICE_UNAVAIL    = 503,
  HTTP_STATUS_GATEWAY_TIMEOUT    = 504,
  HTTP_STATUS_VERSION_NOT_SUP    = 505
}

extern(Windows)
alias ДллИмпорт!("wininet.dll", "HttpQueryInfoW",
  цел function(Укз hRequest, бцел dwInfoLevel, ук lpBuffer, бцел* lpdwBufferLength, бцел* lpdwIndex)) HttpQueryInfo;

enum : бцел {
  FTP_TRANSFER_TYPE_UNKNOWN = 0x00000000,
  FTP_TRANSFER_TYPE_ASCII   = 0x00000001,
  FTP_TRANSFER_TYPE_BINARY  = 0x00000002
}

enum : бкрат {
  INTERNET_DEFAULT_FTP_PORT = 21
}

extern(Windows)
alias ДллИмпорт!("wininet.dll", "FtpPutFileW",
  цел function(Укз hConnect, in шим* lpszLocalFile, in шим* lpszNewRemoteFile, бцел dwFlags, бцел dwContext)) FtpPutFile;

extern(Windows)
alias ДллИмпорт!("wininet.dll", "FtpOpenFileW",
  Укз function(Укз hConnect, in шим* lpszFileName, бцел dwAccess, бцел dwFlags, бцел dwContext)) FtpOpenFile;

extern(Windows)
alias ДллИмпорт!("wininet.dll", "InternetQueryDataAvailable",
  цел function(Укз hFile, бцел* lpdwNumberOfBytesAvailable, бцел dwFlags, бцел dwContext)) InternetQueryDataAvailable;

extern(Windows)
alias ДллИмпорт!("wininet.dll", "InternetReadFile",
  цел function(Укз hFile, ук lpBuffer, бцел dwNumberOfBytesToRead, бцел* lpdwNumberOfBytesRead)) InternetReadFile;

extern(Windows)
alias ДллИмпорт!("wininet.dll", "InternetWriteFile",
  цел function(Укз hFile, in ук lpBuffer, бцел dwNumberOfBytesToWrite, бцел* lpdwNumberOfBytesWritten)) InternetWriteFile;

enum : бцел {
  IRF_ASYNC       = 0x00000001,
  IRF_SYNC        = 0x00000004,
  IRF_USE_CONTEXT = 0x00000008,
  IRF_NO_WAIT     = 0x00000008
}

extern(Windows)
alias ДллИмпорт!("wininet.dll", "InternetReadFileExW",
  цел function(Укз hFile, INTERNET_BUFFERSW* lpBuffersOut, бцел dwFlags, бцел dwContext)) InternetReadFileEx;

/// <code class="d_code">проц delegate(цел percent, дол bytesReceived, дол bytesToReceive, ref бул abort)</code><br>
alias проц delegate(цел percent, дол bytesReceived, дол bytesToReceive, out бул abort) DownloadProgressCallback;

/// <code class="d_code">проц delegate(ббайт[] рез)</code><br>
alias проц delegate(ббайт[] рез) DownloadDataCompletedCallback;

/// <code class="d_code">проц delegate(ткст рез)</code><br>
alias проц delegate(ткст рез) DownloadStringCompletedCallback;

/// <code class="d_code">проц delegate()</code><br>
alias проц delegate() DownloadCompletedCallback;

private abstract class BindStatusCallback : Реализует!(IBindStatusCallback) {
  цел OnStartBinding(бцел dwReserved, IBinding pib) { return S_OK; }
  цел GetPriority(out цел pnPriority) { return E_NOTIMPL; }
  цел OnLowResource(бцел reserved) { return E_NOTIMPL; }
  цел OnProgress(бцел ulProgress, бцел ulProgressMax, бцел ulStatusCode, in шим* szStatusText) { return E_NOTIMPL; }
  цел OnStopBinding(цел hresult, in шим* szError) { return S_OK; }
  цел GetBindInfo(out бцел grfBINDF, BINDINFO* pbindinfo) { return E_NOTIMPL; }
  цел OnDataAvailable(бцел grfBSCF, бцел dwSize, FORMATETC* pformatetc, STGMEDIUM* pstgmed) { return E_NOTIMPL; }
  цел OnObjectAvailable(ref GUID riid, IUnknown punk) { return E_NOTIMPL; }
}

enum {
  S_ASYNCHRONOUS = 0x000401E8
}

private class DownloadBitsCallback : BindStatusCallback {

  extern(D):

  ббайт[] буфер;
  бцел bytesReceived;
  Поток outputStream;
  бул async;
  бул cancelled;

  DownloadDataCompletedCallback downloadCompleted;
  DownloadProgressCallback downloadProgress;

  this(Поток outputStream, DownloadDataCompletedCallback downloadCompleted, DownloadProgressCallback downloadProgress, бул async) {
    this.outputStream = outputStream;
    this.downloadCompleted = downloadCompleted;
    this.downloadProgress = downloadProgress;
    this.async = async;
  }

  ~this() {
    outputStream = null;
    downloadCompleted = null;
    downloadProgress = null;
  }

  extern(Windows):

  override цел OnProgress(бцел ulProgress, бцел ulProgressMax, бцел ulStatusCode, in шим* szStatusText) {
    if (downloadProgress !is null 
      /*&& (ulStatusCode >= BINDSTATUS_BEGINDOWNLOADDATA 
        && ulStatusCode <= BINDSTATUS_ENDDOWNLOADDATA)*/) {
      бул abort = false;
      цел percent = ulProgressMax == 0 ? 0 : cast(цел)((ulProgress * 100) / ulProgressMax);
      downloadProgress(percent, cast(дол)ulProgress, cast(дол)ulProgressMax, abort);

      cancelled = abort;
      if (abort)
        return E_ABORT;
    }
    return S_OK;
  }

  override цел OnStopBinding(цел hresult, in шим* szError) {
    if (outputStream !is null)
      outputStream.закрой();

    // The operation is now completed, so cleanup.
    Release();

    if (НЕУДАЧНО(hresult))
      throw new ИсклСети(вУтф8(szError));

    if (downloadCompleted !is null)
      downloadCompleted(буфер);

    return S_OK;
  }

  override цел GetBindInfo(out бцел grfBINDF, BINDINFO* pbindinfo) {
    grfBINDF = BINDF_GETNEWESTVERSION | BINDF_NOWRITECACHE;
    if (async)
      grfBINDF |= (BINDF_ASYNCHRONOUS | BINDF_ASYNCSTORAGE);
    return S_OK;
  }

  override цел OnDataAvailable(бцел grfBSCF, бцел dwSize, FORMATETC* pformatetc, STGMEDIUM* pstgmed) {
    if (cancelled)
      return E_ABORT;

    if (pformatetc !is null 
      && pformatetc.tymed == TYMED_ISTREAM 
      && pstgmed != null 
      && pstgmed.pstm !is null) {

      бцел bytesToRead = dwSize - bytesReceived;
      if (bytesToRead > 0) {
        бцел смещение = bytesReceived;
        бцел totalBytes = bytesReceived + bytesToRead;

        if (буфер.length < totalBytes)
          буфер.length = totalBytes;

        бцел bytesRead;
        pstgmed.pstm.Read(буфер.ptr + смещение, bytesToRead, bytesRead);

        if (outputStream !is null)
          outputStream.пишиРовно(буфер.ptr + смещение, bytesRead);

        bytesReceived += bytesRead;
      }
    }
    return S_OK;
  }

}

private ббайт[] downloadBits(ткст адрес, 
                             Поток outputStream, 
                             DownloadDataCompletedCallback downloadCompleted, 
                             DownloadProgressCallback downloadProgress,
                             бул async) {

  auto обрвыз = new DownloadBitsCallback(outputStream, downloadCompleted, downloadProgress, async);

  IMoniker urlMoniker;
  цел hr = CreateURLMonikerEx(null, адрес.вУтф16н(), &urlMoniker, URL_MK_UNIFORM);
  if (НЕУДАЧНО(hr))
    throw new КОМИскл(hr);
  scope(exit) tryRelease(urlMoniker);

  IBindCtx context;
  hr = async
    ? CreateAsyncBindCtx(0, обрвыз, null, &context)
    : CreateBindCtx(0, context);
  if (НЕУДАЧНО(hr))
    throw new КОМИскл(hr);
  scope(exit) tryRelease(context);

  if (!async)
    RegisterBindStatusCallback(context, обрвыз, null, 0);

  IStream поток;
  hr = urlMoniker.BindToStorage(context, null, uuidof!(IStream), retval(поток));
  if (НЕУДАЧНО(hr) && (async && hr != S_ASYNCHRONOUS))
    throw new КОМИскл(hr);
  scope(exit) tryRelease(поток);

  return async ? null : обрвыз.буфер;
}

/**
 * Downloads the resource with the specified URI as a ббайт array.
 * Параметры: адрес = The URI from which to download данные.
 * Возвращает: A ббайт array containing the downloaded resource.
 * Примеры:
 * ---
 * import win32.net.core, stdrus;
 *
 * проц main() {
 *   auto remoteUri = new Uri("http://www.bbc.co.uk");
 *
 *   auto данные = downloadData(remoteUri);
 *   скажифнс(данные);
 * }
 * ---
 */
ббайт[] downloadData(Uri адрес, DownloadProgressCallback downloadProgress = null) {
  if (адрес is null)
    throw new ИсклНулевогоАргумента("адрес");

  return downloadData(адрес.вТкст(), downloadProgress);
}

/**
 * ditto
 */
ббайт[] downloadData(ткст адрес, DownloadProgressCallback downloadProgress = null) {
  /*auto обрвыз = new URLOpenStreamCallback;
  scope(exit) обрвыз.Release();

  if (downloadProgress !is null)
    обрвыз.downloadProgress = downloadProgress;

  URLOpenStream(null, адрес.вУтф16н(), 0, обрвыз);
  return обрвыз.буфер;*/
  return downloadBits(адрес, null, null, downloadProgress, false);
}

/**
 */
проц downloadDataAsync(Uri адрес, DownloadDataCompletedCallback downloadCompleted = null, DownloadProgressCallback downloadProgress = null) {
  if (адрес is null)
    throw new ИсклНулевогоАргумента("адрес");

  downloadDataAsync(адрес.вТкст(), downloadCompleted, downloadProgress);
}

/// ditto
проц downloadDataAsync(ткст адрес, DownloadDataCompletedCallback downloadCompleted = null, DownloadProgressCallback downloadProgress = null) {
  downloadBits(адрес, null, (ббайт[] байты) {
    if (downloadCompleted !is null)
      downloadCompleted(байты.dup);
  }, downloadProgress, true);
}

/**
 * Downloads the resource with the specified URI as a ткст.
 * Параметры: адрес = The URI from which to download.
 * Возвращает: A ткст containing the downloaded resource.
 */
ткст downloadString(Uri адрес, DownloadProgressCallback downloadProgress = null) {
  if (адрес is null)
    throw new ИсклНулевогоАргумента("адрес");

  return downloadString(адрес.вТкст(), downloadProgress);
}

/**
 * ditto
 */
ткст downloadString(ткст адрес, DownloadProgressCallback downloadProgress = null) {
  auto данные = downloadData(адрес, downloadProgress);
  return cast(ткст)Кодировка.ДЕФОЛТ.раскодируй(данные);
}

/**
 */
проц downloadStringAsync(Uri адрес, DownloadStringCompletedCallback downloadCompleted = null, DownloadProgressCallback downloadProgress = null) {
  if (адрес is null)
    throw new ИсклНулевогоАргумента("адрес");

  downloadStringAsync(адрес.вТкст(), downloadCompleted, downloadProgress);
}

/// ditto
проц downloadStringAsync(ткст адрес, DownloadStringCompletedCallback downloadCompleted = null, DownloadProgressCallback downloadProgress = null) {
  downloadBits(адрес, null, (ббайт[] байты) {
    if (downloadCompleted !is null)
      downloadCompleted(cast(ткст)Кодировка.ДЕФОЛТ.раскодируй(байты));
  }, downloadProgress, true);
}

/**
 * Downloads the resource with the specified URI to a local file.
 * Параметры:
 *   адрес = The URI from which to download данные.
 *   имяф = The имя of a local file that is to получи the данные.
 * Примеры:
 * ---
 * import win32.net.core, win32.io.path, stdrus;
 *
 * проц main() {
 *   ткст remoteUri = "http://www.bbc.co.uk/bbchd/images/headings/";
 *   ткст имяф = "logo.gif";
 *
 *   downloadFile(remoteUri + имяф, имяф);
 *
 *   скажифнс("Файл is saved in " ~ текПапка);
 * }
 * ---
 */
проц downloadFile(Uri адрес, ткст имяф, DownloadProgressCallback downloadProgress = null) {
  if (адрес is null)
    throw new ИсклНулевогоАргумента("адрес");

  downloadFile(адрес.вТкст(), имяф, downloadProgress);
}

/**
 * ditto
 */
проц downloadFile(ткст адрес, ткст имяф, DownloadProgressCallback downloadProgress = null) {
  auto данные = downloadData(адрес, downloadProgress);
  stdrus.пишиФайл(имяф, данные);
}

/**
 */
проц downloadFileAsync(Uri адрес, ткст имяф, DownloadCompletedCallback downloadCompleted = null, DownloadProgressCallback downloadProgress = null) {
  if (адрес is null)
    throw new ИсклНулевогоАргумента("адрес");

  downloadFileAsync(адрес.вТкст(), имяф, downloadCompleted, downloadProgress);
}

/// ditto
проц downloadFileAsync(ткст адрес, ткст имяф, DownloadCompletedCallback downloadCompleted = null, DownloadProgressCallback downloadProgress = null) {
  downloadBits(адрес, new Файл(имяф, ПФРежим.ВыводНов), (ббайт[] байты) {
    if (downloadCompleted !is null)
      downloadCompleted();
  }, downloadProgress, true);
}

private проц parseUserInfo(ткст userInfo, out ткст userName, out ткст password) {
  if (userInfo != null) {
    ткст[] userNameAndPassword = userInfo.разбей(':');
    if (userNameAndPassword.length > 0) {
      userName = userNameAndPassword[0];
      if (userNameAndPassword.length > 1)
        password = userNameAndPassword[1];
    }
  }
}

/// <code class="d_code">проц delegate(цел percent, дол bytesSent, дол bytesToSend)</code><br>
alias проц delegate(цел percent, дол bytesSent, дол bytesToSend) UploadProgressCallback;

/// <code class="d_code">проц delegate(ббайт[] рез)</code><br>
alias проц delegate(ббайт[] рез) UploadDataCompletedCallback;

/// <code class="d_code">проц delegate(ткст рез)</code><br>
alias проц delegate(ткст рез) UploadStringCompletedCallback;

/// <code class="d_code">проц delegate()</code><br>
alias проц delegate() UploadCompletedCallback;

private struct ProgressData {

  дол bytesSent;
  дол bytesToSend;
  UploadProgressCallback uploadProgress;

}

private struct UploadBitsState {

  Uri uri;
  ббайт[] буфер;
  UploadDataCompletedCallback uploadCompleted;
  бул async;
  ткст метод;

  Укз session;
  Укз connection;
  Укз file;

  цел stage;
  ProgressData* progress;

}

private ббайт[] uploadBits(Uri адрес, ткст метод, in ббайт[] данные, UploadDataCompletedCallback uploadCompleted, UploadProgressCallback uploadProgress, бул async) {

  extern(Windows)
  static проц statusCallback(Укз указатель, бцел context, бцел status, ук statusInformation, бцел statusInformationLength) {
    auto state = cast(UploadBitsState*)context;

    switch (status) {
      case INTERNET_STATUS_HANDLE_CREATED:
        if (state.async) {
          auto рез = cast(INTERNET_ASYNC_RESULT*)statusInformation;

          if (state.stage == 0) {
            state.connection = cast(Укз)рез.dwResult;
            state.stage = 1;
          }
          else if (state.stage == 1) {
            state.file = cast(Укз)рез.dwResult;
          }
        }
        break;
      case INTERNET_STATUS_REQUEST_SENT:
        if (auto progress = state.progress) {
          дол bytesSent = cast(дол)*cast(цел*)statusInformation;

          progress.bytesSent += bytesSent;
          if (progress.bytesSent > progress.bytesToSend)
            progress.bytesSent = 0;

          if (progress.uploadProgress !is null) {
            цел percent = (progress.bytesToSend == 0) ? 0 : cast(цел)((progress.bytesSent / progress.bytesToSend) * 100);
            progress.uploadProgress(percent, progress.bytesSent, progress.bytesToSend);
          }
        }
        break;
      case INTERNET_STATUS_REQUEST_COMPLETE:
        if (state.async) {
          if (state.stage == 1) {
            if (state.uri.scheme == Uri.uriSchemeFtp)
              FtpOpenFile(state.connection, state.uri.localPath().вУтф16н(), GENERIC_WRITE, FTP_TRANSFER_TYPE_BINARY | INTERNET_FLAG_RELOAD, cast(бцел)state);
            else
              HttpOpenRequest(state.connection, state.метод.вУтф16н(), state.uri.pathAndQuery().вУтф16н(), null, null, null, INTERNET_FLAG_RELOAD, cast(бцел)state);
            state.stage = 2;
          }
          else if (state.stage == 2) {
            if (state.uri.scheme == Uri.uriSchemeFtp) {
              бцел bytesWritten;
              InternetWriteFile(state.file, state.буфер.ptr, state.буфер.length, &bytesWritten);
            }
            else {
              HttpSendRequest(state.file, null, 0, state.буфер.ptr, state.буфер.length);
            }
            state.stage = 3;
          }
          else if (state.stage == 3) {
            InternetCloseHandle(state.file);
            InternetCloseHandle(state.connection);

            InternetSetStatusCallback(state.session, null);
            InternetCloseHandle(state.session);
            state.stage = 4;
          }
        }
        break;
      case INTERNET_STATUS_RESPONSE_RECEIVED:
        //бцел bytesReceived = *cast(бцел*)statusInformation;
        break;
      case INTERNET_STATUS_HANDLE_CLOSING:
        break;
      case INTERNET_STATUS_CONNECTION_CLOSED:
         if (state.uploadCompleted !is null)
          state.uploadCompleted(null);

        state = null;
        break;

      default:
    }
  }

  бул schemeIsFtp = (адрес.scheme == Uri.uriSchemeFtp);

  if (метод == null) {
    if (schemeIsFtp)
      метод = "STOR";
    else
      метод = "POST";
  }

  ббайт[] response;

  auto state = new UploadBitsState;

  state.uri = адрес;
  state.буфер = cast(ббайт[])данные;
  state.uploadCompleted = uploadCompleted;
  state.async = async;
  state.метод = метод;

  state.progress = new ProgressData;
  state.progress.bytesToSend = данные.length;
  state.progress.uploadProgress = uploadProgress;

  Укз session = state.session = InternetOpen(null, INTERNET_OPEN_TYPE_PRECONFIG, null, null, async ? INTERNET_FLAG_ASYNC : 0);
  if (!async) scope(exit) CloseInternetHandle(session);

  if (session == Укз.init)
    throw new ИсклСети;

  InternetSetStatusCallback(session, &statusCallback);

  ткст userName;
  ткст password;
  parseUserInfo(адрес.userInfo, userName, password);

  Укз connection = InternetConnect(session,
                                      адрес.хост().вУтф16н(), 
                                      cast(бкрат)адрес.порт, 
                                      userName.вУтф16н(), 
                                      password.вУтф16н(), 
                                      schemeIsFtp ? INTERNET_SERVICE_FTP : INTERNET_SERVICE_HTTP, 
                                      INTERNET_FLAG_PASSIVE | INTERNET_FLAG_DONT_CACHE,
                                      cast(бцел)state);
  if (!async) scope(exit) CloseInternetHandle(connection);

  if ((async && connection == Укз.init && GetLastError() != ERROR_IO_PENDING) || (!async && connection == Укз.init))
    throw new ИсклСети;

  if (!async) {
    if (schemeIsFtp) {
      Укз file = FtpOpenFile(connection, адрес.localPath().вУтф16н(), GENERIC_WRITE, FTP_TRANSFER_TYPE_BINARY | INTERNET_FLAG_RELOAD, cast(бцел)state);
      scope(exit) InternetCloseHandle(file);

      if (file == Укз.init)
        throw new ИсклСети;

      бцел bytesWritten;
      if (!InternetWriteFile(file, данные.ptr, данные.length, &bytesWritten)) {
        //throw new ИсклСети;
      }
    }
    else {
      Укз request = HttpOpenRequest(connection, метод.вУтф16н(), адрес.pathAndQuery().вУтф16н(), null, null, null, INTERNET_FLAG_RELOAD, cast(бцел)state);
      scope(exit) InternetCloseHandle(request);

      if (request == Укз.init)
        throw new ИсклСети;

      if (!HttpSendRequest(request, null, 0, данные.ptr, данные.length)) {
      }

      бцел statusCode;
      бцел len = бцел.sizeof;
      HttpQueryInfo(request, HTTP_QUERY_STATUS_CODE | HTTP_QUERY_FLAG_NUMBER, &statusCode, &len, null);

      if (statusCode > HTTP_STATUS_OK) {
        len = 0;
        HttpQueryInfo(request, HTTP_QUERY_STATUS_TEXT, null, &len, null);

        auto буфер = cast(шим*)malloc(len * шим.sizeof);
        scope(exit) free(буфер);

        HttpQueryInfo(request, HTTP_QUERY_STATUS_TEXT, буфер, &len, null);
        ткст statusText = вУтф8(буфер[0 .. len]);

        throw new ИсклСети(фм("Удалённый сервер вернул ошибку: (%s) %s", statusCode, statusText));
      }

      ббайт[1024] буфер;
      бцел totalBytesRead, bytesRead;

      while ((InternetReadFile(request, буфер.ptr, буфер.length, &bytesRead) == TRUE) && (bytesRead > 0)) {
        response.length = response.length + bytesRead;
        response[totalBytesRead .. totalBytesRead + bytesRead] = буфер[0 .. bytesRead];
        totalBytesRead += bytesRead;
      }
    }
  }

  return async ? null : response;
}

/**
 * Uploads a _data буфер to a resource identified by a URI.
 * Параметры:
 *   адрес = The URI of the resource to получи the _data.
 *   данные = The _data буфер to шли to the resource.
 * Возвращает: A ббайт array containing the body of the response from the resource.
 */
ббайт[] uploadData(Uri адрес, in ббайт[] данные, UploadProgressCallback uploadProgress = null) {
  if (адрес is null)
    throw new ИсклНулевогоАргумента("адрес");

  return uploadBits(адрес, null, данные, null, uploadProgress, false);
}

/**
 * ditto
 */
ббайт[] uploadData(ткст адрес, in ббайт[] данные, UploadProgressCallback uploadProgress = null) {
  return uploadData(new Uri(адрес), данные, uploadProgress);
}

проц uploadDataAsync(Uri адрес, in ббайт[] данные, UploadDataCompletedCallback uploadCompleted = null, UploadProgressCallback uploadProgress = null) {
  if (адрес is null)
    throw new ИсклНулевогоАргумента("адрес");

  uploadBits(адрес, null, данные, (ббайт[] рез) {
    if (uploadCompleted !is null)
      uploadCompleted(рез.dup);
  }, uploadProgress, true);
}

проц uploadDataAsync(ткст адрес, in ббайт[] данные, UploadDataCompletedCallback uploadCompleted = null, UploadProgressCallback uploadProgress = null) {
  uploadDataAsync(new Uri(адрес), данные, uploadCompleted, uploadProgress);
}

/**
 * Uploads the specified ткст to the specified resource.
 * Параметры:
 *   адрес = The URI of the resource to получи the ткст.
 *   данные = The ткст to be uploaded.
 * Возвращает: A ткст containing the body of the response from the resource.
 */
ткст uploadString(Uri адрес, ткст данные, UploadProgressCallback uploadProgress = null) {
  if (адрес is null)
    throw new ИсклНулевогоАргумента("адрес");

  auto рез = uploadBits(адрес, null, Кодировка.ДЕФОЛТ.кодируй(cast(сим[])данные), null, uploadProgress, false);
  return cast(ткст)Кодировка.ДЕФОЛТ.раскодируй(рез);
}

/**
 * ditto
 */
ткст uploadString(ткст адрес, ткст данные, UploadProgressCallback uploadProgress = null) {
  return uploadString(new Uri(адрес), данные, uploadProgress);
}

/**
 */
проц uploadStringAsync(Uri адрес, ткст данные, UploadStringCompletedCallback uploadCompleted = null, UploadProgressCallback uploadProgress = null) {
  if (адрес is null)
    throw new ИсклНулевогоАргумента("адрес");

  return uploadBits(адрес, null, Кодировка.ДЕФОЛТ.кодируй(cast(сим[])данные), (ббайт[] рез) {
    if (uploadCompleted !is null)
      uploadCompleted(cast(ткст)Кодировка.ДЕФОЛТ.раскодируй(рез));
  }, uploadProgress, true);
}

/// ditto
проц uploadStringAsync(ткст адрес, ткст данные, UploadStringCompletedCallback uploadCompleted = null, UploadProgressCallback uploadProgress = null) {
  uploadStringAsync(new Uri(адрес), данные, uploadCompleted, uploadProgress);
}

/**
 * Uploads the specified local file to a resource with the specified URI.
 * Параметры:
 *   адрес = The URI of the resource to получи the file. For example, ftp://localhost/samplefile.txt.
 *   имяф = The file to шли to the resource. For example, "samplefile.txt".
 * Возвращает: A ббайт array containing the body of the response from the resource.
 * Примеры:
 * ---
 * import win32.net.core, stdrus;
 * 
 * проц main() {
 *   writef("Enter the URI to upload to: ");
 *   ткст uriString = readln();
 *
 *   writef("\nEnter the путь of the file to upload: ");
 *   ткст имяф = readln();
 *
 *   // Strip trailing '\n' on ввод.
 *   uriString = uriString[0 .. $-1];
 *   имяф = имяф[0 .. $-1];
 *
 *   скажифнс("\nUploading %s to %s", имяф, uriString);
 *
 *   // Upload the file to the URI.
 *   uploadFile(uriString, имяф);
 * }
 * ---
 */
ббайт[] uploadFile(Uri адрес, ткст имяф, UploadProgressCallback uploadProgress = null) {
  if (адрес is null)
    throw new ИсклНулевогоАргумента("адрес");

  return uploadBits(адрес, null, cast(ббайт[])stdrus.читайФайл(имяф), null, uploadProgress, false);
}

/**
 * ditto
 */
ббайт[] uploadFile(ткст адрес, ткст имяф, UploadProgressCallback uploadProgress = null) {
  return uploadFile(new Uri(адрес), имяф, uploadProgress);
}

/**
 */
проц uploadFileAsync(Uri адрес, ткст имяф, UploadCompletedCallback uploadCompleted = null, UploadProgressCallback uploadProgress = null) {
  if (адрес is null)
    throw new ИсклНулевогоАргумента("адрес");

  uploadBits(адрес, null, cast(ббайт[])stdrus.читайФайл(имяф), (ббайт[] рез) {
    if (uploadCompleted !is null)
      uploadCompleted();
  }, uploadProgress, true);
}

проц uploadFileAsync(ткст адрес, ткст имяф, UploadCompletedCallback uploadCompleted = null, UploadProgressCallback uploadProgress = null) {
  uploadFileAsync(new Uri(адрес), имяф, uploadCompleted, uploadProgress);
}