/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.net.core;

import win32.base.core,
  win32.base.string,
  win32.base.text,
  win32.base.environment,
  win32.base.native,
  win32.loc.conv,
  winapi, sys.WinConsts,
  stdrus, sys.WinStructs,
  cidrus: memcpy;
debug import stdrus : скажифнс;

//pragma(lib, "ws2_32.lib");

alias win32.base.string.замени замени;

/**
 * The exception that is thrown when an ошибка occurs while accessing a network.
 */
class ИсклСети : Exception {

  this() {
    super(дайОшСооб(win32.base.native.GetLastError()));
  }

  this(ткст сообщение) {
    super(сообщение);
  }

  private static ткст дайОшСооб(бцел кодОш) {
    static Укз moduleHandle;

    if (moduleHandle == Укз.init)
      moduleHandle = LoadLibrary("wininet.dll");

    // Try to дай the ошибка сообщение from Wininet.dll.
    шим[256] буфер;
    бцел рез = FormatMessage(win32.base.native.FORMAT_MESSAGE_FROM_HMODULE, moduleHandle, кодОш, 0, буфер.ptr, буфер.length + 1, null);
    if (рез != 0)
      return .вЮ8(буфер[0 .. рез]);

    // Otherwise, дай the ошибка сообщение from Windows.
    рез = FormatMessage(win32.base.native.FORMAT_MESSAGE_FROM_SYSTEM, null, кодОш, 0, буфер.ptr, буфер.length + 1, null);
    if (рез != 0)
      return .вЮ8(буфер[0 .. рез]);

    return фм("Неопределённая ошибка (0x%08X)", кодОш);
  }

}

/// Defines the parts of a URI.
enum UriPartial {
  Scheme,    /// The scheme segment of the URI.
  Authority, /// The scheme and authority segemnts of the URI.
  Path,      /// The scheme, authority and путь segments of the URI.
  Query      /// The scheme, authority, путь and query segments of the URI.
}

/// Specifies the parts of a URI.
enum UriComponents {
  Scheme          = 0x1,                                                        /// The scheme данные.
  UserInfo        = 0x2,                                                        /// The userInfo данные.
  Host            = 0x4,                                                        /// The хост данные.
  Port            = 0x8,                                                        /// The порт данные.
  Path            = 0x10,                                                       /// The localPath данные.
  Query           = 0x20,                                                       /// The query данные.
  Fragment        = 0x40,                                                       /// The fragment данные.
  StrongPort      = 0x80,                                                       /// The порт данные. If no порт данные is in the Uri and a default порт has been assigned to the scheme, the default порт is returned.
  AbsoluteUri     = Scheme | UserInfo | Host | Port | Path | Query | Fragment,  /// The scheme, userInfo, хост, порт, localPath, query and fragment данные.
  HostAndPort     = Host | StrongPort,                                          /// The хост and порт данные. If no порт данные is in the Uri and a default порт has been assigned to the scheme, the default порт is returned.
  StrongAuthority = UserInfo | Host | StrongPort,                               /// The userInfo, хост and порт данные. If no порт данные is in the Uri and a default порт has been assigned to the scheme, the default порт is returned.
  SchemeAndServer = Scheme | Host | Port,                                       /// The scheme, хост and порт данные.
  PathAndQuery    = Path | Query,                                               /// The localPath and query данные.
  KeepDelimiter   = 0x40000000                                                  /// Specifies that the delimiter should be included.
}

/**
 * Represents a uniform resource identifier (URI).
 */
class Uri {

  private struct UriScheme {
    ткст schemeName;
    цел defaultPort;
  }

  const ткст uriSchemeHttp = "http";      /// Specifies that the URI is accessed through HTTP.
  const ткст uriSchemeHttps = "https";    /// Specifies that the URI is accessed through HTTPS.
  const ткст uriSchemeFtp = "ftp";        /// Specifies that the URI is accessed through FTP.
  const ткст uriSchemeFile = "file";      /// Specifies that the URI is a pointer to a file.
  const ткст uriSchemeNews = "news";      /// Specifies that the URI is a news groups and is accessed through NNTP.
  const ткст uriSchemeMailTo = "mailto";  /// Specifies that the URI is an e-mail адрес and is accessed through SMTP.
  const ткст schemeDelimiter = "://";

  private const UriScheme httpScheme = { uriSchemeHttp, 80 };
  private const UriScheme httpsScheme = { uriSchemeHttps, 443 };
  private const UriScheme ftpScheme = { uriSchemeFtp, 21 };
  private const UriScheme fileScheme = { uriSchemeFile, -1 };
  private const UriScheme newsScheme = { uriSchemeNews, -1 };
  private const UriScheme mailtoScheme = { uriSchemeMailTo, 25 };

  private ткст ткст_;
  private ткст кэш_;
  private ткст схема_;
  private ткст путь_;
  private ткст запрос_;
  private ткст фрагмент_;
  private ткст иоп_;
  private ткст хост_;
  private цел порт_ = -1;

  /**
   * Initializes a new экземпляр with the specified URI.
   * Params: s = A URI.
   */
  this(ткст s) {
    ткст_ = s;

    parseUri(s);
  }

  /**
   * Compares two Uri instances for equality.
   */
  final бул равен(Объект объ) {
    if (объ is null)
      return false;

    if (this is объ)
      return true;

    if (auto другой = cast(Uri)объ) {
      if (ткст_ == другой.ткст_)
        return true;
      if (stdrus.сравнлюб(ткст_, другой.ткст_) == 0)
        return true;
      if (stdrus.сравни(ткст_, другой.ткст_) == 0)
        return true;
    }

    return false;
  }

  /// ditto
  override typeof(super.opEquals(Объект)) opEquals(Объект объ) {
    return cast(typeof(super.opEquals(Объект)))равен(объ);
  }

  /**
   * Gets a ткст representation of the URI.
   */
  override ткст вТкст() {
    if (!isAbsolute)
      return ткст_;
    return absoluteUri;
  }

  override бцел вХэш() {
    ткст hashString = getComponents(UriComponents.SchemeAndServer | UriComponents.PathAndQuery);
    return typeid(ткст).дайХэш(&hashString);
  }

  /**
   * Determines the difference between two Uri instances.
   */
  final Uri makeRelative(Uri uri) {

    ткст getDifference(ткст path1, ткст path2) {
      цел i;
      цел slash = -1;

      for (i = 0; i < path1.length && i < path2.length; i++) {
        if (path1[i] != path2[i])
          break;
        else if (path1[i] == '/')
          slash = i;
      }

      if (i == 0)
        return path2;

      if (i == path1.length 
        && i == path2.length)
        return null;

      ткст relativePath;
      for (; i < path1.length; i++) {
        if (path1[i] == '/')
          relativePath ~= "../";
      }

      return relativePath ~ path2[slash + 1 .. $];
    }

    if (scheme == uri.scheme && хост == uri.хост && порт == uri.порт)
      return new Uri(getDifference(absolutePath, uri.absolutePath) ~ uri.getComponents(UriComponents.Fragment | UriComponents.Query));
    return uri;
  }

  /**
   * Gets the specified _components.
   * Params: компоненты = Specifies which parts of the URI to return.
   */
  final ткст getComponents(UriComponents компоненты) {
    if (!isAbsolute)
      throw new ИсклНеправильнОперации("Эта операция не поддерживается для релятивного URI.");

    if (компоненты == UriComponents.Scheme)
      return схема_;

    if (компоненты == UriComponents.Host)
      return хост_;

    if (компоненты == UriComponents.Port || компоненты == UriComponents.StrongPort) {
      if (!isDefaultPort || (компоненты == UriComponents.StrongPort && getDefaultPort(схема_) != -1))
        return win32.loc.conv.вТкст(порт_);
    }

    if ((компоненты & UriComponents.StrongPort) != 0)
      компоненты |= UriComponents.Port;

    UriComponents parts = компоненты & ~UriComponents.KeepDelimiter;

    ткст рез;

    // Scheme
    if ((parts & UriComponents.Scheme) != 0) {
      рез ~= схема_;
      if (parts != UriComponents.Scheme) {
        рез ~= ':';
        if (хост_ != null && порт_ != -1)
          рез ~= "//";
      }
    }

    // UserInfo
    if ((parts & UriComponents.UserInfo) != 0 && иоп_ != null) {
      рез ~= иоп_;
      if (компоненты != UriComponents.UserInfo)
        рез ~= '@';
    }

    // Host
    if ((parts & UriComponents.Host) != 0 && хост_ != null) {
      рез ~= хост_;
    }

    // Port
    if ((parts & UriComponents.Port) != 0) {
      if (!isDefaultPort || (parts & UriComponents.StrongPort) != 0) {
        рез ~= ':';
        рез ~= win32.loc.conv.вТкст(порт_);
      }
    }

    // Path
    if ((parts & UriComponents.Path) != 0) {
      рез ~= путь_;
      if (компоненты == UriComponents.Path) {
        if (рез[0] == '/')
          return рез[1 .. $];
        else
          return рез;
      }
    }

    // Query
    if ((parts & UriComponents.Query) != 0) {
      рез ~= запрос_;
      if (компоненты == UriComponents.Query) {
        if (рез[0] == '?')
          return рез[1 .. $];
        else
          return рез;
      }
    }

    // Fragment
    if ((parts & UriComponents.Fragment) != 0) {
      рез ~= фрагмент_;
      if (компоненты == UriComponents.Fragment) {
        if (рез[0] == '#')
          return рез[1 .. $];
        else
          return рез;
      }
    }

    return рез;
  }

  /**
   * Gets the specified portion of a URI.
   * Params: часть = Specifies the end of the URI portion to return.
   */
  ткст getLeftPart(UriPartial часть) {
    switch (часть) {
      case UriPartial.Scheme:
        return getComponents(UriComponents.KeepDelimiter | UriComponents.Scheme);
      case UriPartial.Authority:
        return getComponents(UriComponents.SchemeAndServer | UriComponents.UserInfo);
      case UriPartial.Path:
        return getComponents(UriComponents.Path | UriComponents.SchemeAndServer | UriComponents.UserInfo);
      case UriPartial.Query:
        return getComponents(UriComponents.PathAndQuery | UriComponents.SchemeAndServer | UriComponents.UserInfo);
      default:
        return null;
    }
  }

  /**
   * Indicates whether the экземпляр is absolute.
   */
  final бул isAbsolute() {
    return схема_ != null;
  }

  /**
   * Indicates whether the экземпляр is a file URI.
   */
  final бул файл_ли() {
    return схема_ == fileScheme.schemeName;
  }

  /**
   * Gets the absolute URI.
   */
  final ткст absoluteUri() {
    if (кэш_ == null)
      кэш_ = getComponents(UriComponents.AbsoluteUri);
    return кэш_;
  }

  /**
   * Gets the _scheme имя for this URI.
   */
  final ткст scheme() {
    return схема_;
  }

  /**
   * Gets the Domain Name Система (DNS) хост имя or IP адрес and the порт число for a server.
   */
  final ткст authority() {
    //return isDefaultPort ? хост_ : хост_ ~ ":" ~ .вТкст(порт_);
    return getComponents(UriComponents.Host | UriComponents.Port);
  }

  /**
   * Gets the absolute путь and query information separated by a question mark (?).
   */
  final ткст pathAndQuery() {
    //return путь_ ~ запрос_;
    return getComponents(UriComponents.PathAndQuery);
  }

  /**
   * Gets any _query information included in this URI.
   */
  final ткст query() {
    //return запрос_;
    return getComponents(UriComponents.Query | UriComponents.KeepDelimiter);
  }

  /**
   * Gets the URI _fragment.
   */
  final ткст fragment() {
    //return фрагмент_;
    return getComponents(UriComponents.Fragment | UriComponents.KeepDelimiter);
  }

  /**
   * Gets the user имя, password, or другой user-specific information associated with this URI.
   */
  final ткст userInfo() {
    //return иоп_;
    return getComponents(UriComponents.UserInfo);
  }

  /**
   * Gets the _host component.
   */
  final ткст хост() {
    //return хост_;
    return getComponents(UriComponents.Host);
  }

  /**
   * Indicates whether the порт значение of the URI is the default for this scheme.
   */
  бул isDefaultPort() {
    return (getDefaultPort(схема_) == порт_);
  }

  /**
   * Gets the _port число of this URI.
   */
  final цел порт() {
    return порт_;
  }

  /**
   * Gets the _original URI ткст that was passed to the constructor.
   */
  final ткст original() {
    return ткст_;
  }

  /**
   * Gets the local operating-system путь of a file имя.
   */
  final ткст localPath() {
    //return путь_;
    return getComponents(UriComponents.Path | UriComponents.KeepDelimiter);
  }

  final ткст absolutePath() {
    return getComponents(UriComponents.Path | UriComponents.KeepDelimiter);
  }

  /**
   * Gets an array containing the путь _segments that make up this URI.
   */
  final ткст[] segments() {
    ткст[] segments;

    ткст путь = getComponents(UriComponents.Path | UriComponents.KeepDelimiter);

    if (путь.length != 0) {
      цел текущ;
      while (текущ < путь.length) {
        цел следщ = путь.индексУ('/', текущ);
        if (следщ == -1)
          следщ = путь.length - 1;

        segments ~= путь[текущ .. следщ + 1];

        текущ = следщ + 1;
      }
    }

    return segments;
  }

  private проц parseUri(ткст s) {
    цел i = s.индексУ(':');
    if (i < 0)
      return;

    if (i == 1) {
      // Windows absolute путь
      схема_ = fileScheme.schemeName;
      порт_ = fileScheme.defaultPort;
      путь_ = s.замени("\\", "/");
    }
    else {
      схема_ = s[0 .. i].вПроп();
      s = s[i + 1 .. $];

      i = s.индексУ('#');
      if (i != -1) {
        фрагмент_ = s[i .. $];
        s = s[0 .. i];
      }

      i = s.индексУ('?');
      if (i != -1) {
        запрос_ = s[i .. $];
        s = s[0 .. i];
      }

      бул unixPath = (схема_ == fileScheme.schemeName && s.начинаетсяС("///"));

      if (s[0 .. 2] == "//") {
        if (s.начинаетсяС("////"))
          unixPath = false;
        s = s[2 .. $];
      }

      i = s.индексУ('/');
      if (i == -1) {
        путь_ = "/";
      }
      else {
        путь_ = s[i .. $];
        s = s[0 .. i];
      }

      i = s.индексУ('@');
      if (i != -1) {
        иоп_ = s[0 .. i];
        s = s.удали(0, i + 1);
      }

      порт_ = -1;
      i = s.последнИндексУ(':');
      if (i != -1 && i != s.length - 1) {
        ткст sport = s.удали(0, i + 1);
        if (sport.length > 1 && sport[$ - 1] != ']') {
          порт_ = cast(цел)разбор!(бкрат)(sport);
          s = s[0 .. i];
        }
      }
      if (порт_ == -1)
        порт_ = getDefaultPort(схема_);

      хост_ = s;

      if (unixPath) {
        путь_ = '/' ~ s;
        хост_ = null;
      }
    }
  }

  private цел getDefaultPort(ткст scheme) {
    scheme = scheme.вПроп();

    if (scheme == httpScheme.schemeName)
      return httpScheme.defaultPort;
    else if (scheme == httpsScheme.schemeName)
      return httpsScheme.defaultPort;
    else if (scheme == ftpScheme.schemeName)
      return ftpScheme.defaultPort;
    else if (scheme == fileScheme.schemeName)
      return fileScheme.defaultPort;
    else if (scheme == newsScheme.schemeName)
      return newsScheme.defaultPort;
    else if (scheme == mailtoScheme.schemeName)
      return mailtoScheme.defaultPort;

    return -1;
  }

}

/**
 */
interface ICredentials {

  ///
  NetworkCredential getCredential(Uri uri, ткст authType);

}

/**
 */
interface ICredentialsByHost {

  ///
  NetworkCredential getCredential(ткст хост, цел порт, ткст authType);

}

private class CredentialKey {

  Uri uriPrefix;
  цел uriPrefixLength = -1;
  ткст authType;

  this(Uri uriPrefix, ткст authType) {
    this.uriPrefix = uriPrefix;
    this.uriPrefixLength = uriPrefix.вТкст().length;
    this.authType = authType;
  }

  бул match(Uri uri, ткст authType) {
    if (uri is null)
      return false;
    if (stdrus.сравнлюб(authType, this.authType) != 0)
      return false;
    if (uriPrefix.scheme != uri.scheme || uriPrefix.хост != uri.хост || uriPrefix.порт != uri.порт)
      return false;
    return stdrus.сравнлюб(uriPrefix.absolutePath, uri.absolutePath) == 0;
  }

  override typeof(super.opEquals(Объект)) opEquals(Объект объ) {
    if (auto другой = cast(CredentialKey)объ)
      return (stdrus.сравнлюб(authType, другой.authType) == 0 && uriPrefix.равен(другой.uriPrefix));
    return false;
  }

  бцел вХэш() {
    return typeid(ткст).дайХэш(&authType) + uriPrefixLength + uriPrefix.вХэш();
  }

}

private class CredentialHostKey {

  ткст хост;
  цел порт;
  ткст authType;

  this(ткст хост, цел порт, ткст authType) {
    this.хост = хост;
    this.порт = порт;
    this.authType = authType;
  }

  бул match(ткст хост, цел порт, ткст authType) {
    if (stdrus.сравнлюб(authType, this.authType) != 0)
      return false;
    if (stdrus.сравнлюб(хост, this.хост) != 0)
      return false;
    if (порт != this.порт)
      return false;
    return true;
  }

  override typeof(super.opEquals(Объект)) opEquals(Объект объ) {
    if (auto другой = cast(CredentialHostKey)объ)
      return (stdrus.сравнлюб(хост, другой.хост) == 0 && stdrus.сравнлюб(authType, другой.authType) == 0 && порт == другой.порт);
    return false;
  }

  бцел вХэш() {
    return (typeid(ткст).дайХэш(&хост) + typeid(ткст).дайХэш(&authType) + порт);
  }

}

/**
 */
class CredentialCache : ICredentials, ICredentialsByHost {

  private NetworkCredential[CredentialKey] кэш_;
  private NetworkCredential[CredentialHostKey] hostCache_;

  ///
  final NetworkCredential getCredential(Uri uriPrefix, ткст authType) {
    foreach (ключ, значение; кэш_) {
      if (ключ.match(uriPrefix, authType))
        return значение;
    }
    return null;
  }

  ///
  final NetworkCredential getCredential(ткст хост, цел порт, ткст authType) {
    foreach (ключ, значение; hostCache_) {
      if (ключ.match(хост, порт, authType))
        return значение;
    }
    return null;
  }

  ///
  final проц добавь(Uri uriPrefix, ткст authType, NetworkCredential credential) {
    auto ключ = new CredentialKey(uriPrefix, authType);
    кэш_[ключ] = credential;
  }

  ///
  final проц добавь(ткст хост, цел порт, ткст authType, NetworkCredential credential) {
    auto ключ = new CredentialHostKey(хост, порт, authType);
    hostCache_[ключ] = credential;
  }

  ///
  final проц удали(Uri uriPrefix, ткст authType) {
    auto ключ = new CredentialKey(uriPrefix, authType);
    кэш_.remove(ключ);
  }

  ///
  final проц удали(ткст хост, цел порт, ткст authType) {
    auto ключ = new CredentialHostKey(хост, порт, authType);
    hostCache_.remove(ключ);
  }

}
/**
 */
class NetworkCredential : ICredentials, ICredentialsByHost {

  //private ббайт[] userName_;
  //private ббайт[] password_;
  private ткст userName_;
  private ткст password_;

  ///
  this() {
  }

  ///
  this(ткст userName, ткст password) {
    //userName_ = encrypt(userName);
    //password_ = encrypt(password);
    userName_ = userName;
    password_ = password;
  }

  ///
  NetworkCredential getCredential(Uri uri, ткст authType) {
    return this;
  }

  ///
  NetworkCredential getCredential(ткст хост, цел порт, ткст authType) {
    return this;
  }

  ///
  final проц userName(ткст значение) {
    //userName_ = encrypt(значение);
    userName_ = значение;
  }
  /// ditto
  final ткст userName() {
    //return decrypt(userName_);
    return userName_;
  }

  ///
  final проц password(ткст значение) {
    //password_ = encrypt(значение);
    password_ = значение;
  }
  /// ditto
  final ткст password() {
    //return decrypt(password_);
    return password_;
  }

}

// Интернет Protocol

extern(Windows):

enum {
  WSAEINVAL           = 10022,
  WSAEPROTONOSUPPORT  = 10043,
  WSAEOPNOTSUPP       = 10045,
  WSAEAFNOSUPPORT     = 10047
}

struct WSAPROTOCOL_INFOW {
}

цел WSAStringToAddressW(in шим* AddressString, цел ПСемействоАдресов, WSAPROTOCOL_INFOW* lpProtocolInfo, sockaddr* lpAddress, ref цел lpAddressLength);
alias WSAStringToAddressW WSAStringToAddress;

цел WSAAddressToStringW(sockaddr* lpAddress, бцел dwAddressLength, WSAPROTOCOL_INFOW* lpProtocolInfo, шим* lpszAddressString, ref бцел lpdwAddressStringLength);
alias WSAAddressToStringW WSAAddressToString;

alias ДллИмпорт!("ws2_32.dll", "getaddrinfo",
  цел function(in сим* nodename, in сим* servname, addrinfo* hints, addrinfo** res)) getaddrinfo;

alias ДллИмпорт!("ws2_32.dll", "freeaddrinfo",
  проц function(addrinfo* ai)) freeaddrinfo;

enum {
  NI_NAMEREQD = 0x04
}

alias ДллИмпорт!("ws2_32.dll", "getnameinfo",
  цел function(in sockaddr* sa, winapi.socklen_t saLen, сим* хост, бцел hostLen, сим* serv, бцел servLen, цел флаги)) getnameinfo;

alias ДллИмпорт!("icmp.dll", "IcmpCreateFile",
  Укз function()) IcmpCreateFileWin2k;

alias ДллИмпорт!("iphlpapi.dll", "IcmpCreateFile",
  Укз function()) IcmpCreateFile;

alias ДллИмпорт!("iphlpapi.dll", "Icmp6CreateFile",
  Укз function()) Icmp6CreateFile;

alias ДллИмпорт!("icmp.dll", "IcmpCloseHandle",
  BOOL function(Укз IcmpHandle)) IcmpCloseHandleWin2k;

alias ДллИмпорт!("iphlpapi.dll", "IcmpCloseHandle",
  BOOL function(Укз IcmpHandle)) IcmpCloseHandle;

struct IP_OPTION_INFORMATION {
  ббайт ttl;
  ббайт tos;
  ббайт флаги;
  ббайт optionsSize;
  ббайт* optionsData;
}

struct ICMP_ECHO_REPLY {
  бцел адрес;
  бцел status;
  бцел roundTripTime;
  бкрат dataSize;
  бкрат reserved;
  ук данные;
  IP_OPTION_INFORMATION опции;
}

struct IPV6_ADDRESS_EX {
  align(1):
  бкрат sin6_port;
  бцел sin6_flowinfo;
  //бкрат[8] sin6_addr;
  ббайт[16] sin6_addr;
  бцел sin6_scope_id;
}

struct ICMPV6_ECHO_REPLY {
  IPV6_ADDRESS_EX адрес;
  бцел status;
  бцел roundTripTime;
}

enum : бцел {
  IP_SUCCESS                 = 0,
  IP_BUF_TOO_SMALL           = 11001 + 1,
  IP_DEST_NET_UNREACHABLE,
  IP_DEST_HOST_UNREACHABLE,
  IP_DEST_PROT_UNREACHABLE,
  IP_DEST_PORT_UNREACHABLE,
  IP_NO_RESOURCES,
  IP_BAD_OPTION,
  IP_HW_ERROR,
  IP_PACKET_TOO_BIG,
  IP_REQ_TIMED_OUT,
  IP_BAD_REQ,
  IP_BAD_ROUTE,
  IP_TTL_EXPIRED_TRANSIT,
  IP_TTL_EXPIRED_REASSEM,
  IP_PARAM_PROBLEM,
  IP_SOURCE_QUENCH,
  IP_OPTION_TOO_BIG,
  IP_BAD_DESTINATION
}

alias ДллИмпорт!("icmp.dll", "IcmpSendEcho2",
  бцел function(Укз IcmpHandle, Укз Событие, ук ApcRoutine, ук ApcContext, бцел DestinationAddress, ук RequestData, бкрат RequestSize, ук RequestOptions, ук ReplyBuffer, бцел ReplySize, бцел Timeout))
  IcmpSendEcho2Win2k;

alias ДллИмпорт!("iphlpapi.dll", "IcmpSendEcho2",
  бцел function(Укз IcmpHandle, Укз Событие, ук ApcRoutine, ук ApcContext, бцел DestinationAddress, ук RequestData, бкрат RequestSize, ук RequestOptions, ук ReplyBuffer, бцел ReplySize, бцел Timeout))
  IcmpSendEcho2;

alias ДллИмпорт!("iphlpapi.dll", "Icmp6SendEcho2",
  бцел function(Укз IcmpHandle, Укз Событие, ук ApcRoutine, ук ApcContext, ук SourceAddress, ук DestinationAddress, ук RequestData, бкрат RequestSize, ук RequestOptions, ук ReplyBuffer, бцел ReplySize, бцел Timeout))
  Icmp6SendEcho2;

extern(D):

private бул isWin2k() {
  static Опционал!(бул) isWin2k_;
  if (!isWin2k_.hasValue)
    isWin2k_ = (версияОс.major == 5 && версияОс.minor == 0);
  return isWin2k_.значение;
}

private бул supportsIPv6() {
  static Опционал!(бул) supportsIPv6_;
  if (!supportsIPv6_.hasValue) {
    бцел s = socket(AF_INET6, SOCK_DGRAM, IPPROTO_IP);
    if (win32.base.native.GetLastError() != WSAEAFNOSUPPORT)
      supportsIPv6_ = true;
    closesocket(s);
  }
  return supportsIPv6_.значение;
}

private SocketException socketException(бцел кодОш = win32.base.native.GetLastError()) {
  return new SocketException(дайОшСооб(кодОш), кодОш);
}

// Replacements for Phobos's InternetHost and InternetAddress classes.
// ИПХост and ИПАдрес are IPv6-aware.

/**
 * Provides a container class for Интернет хост адрес information.
 */
class ИПХост {

  /// A список of IP addresses associated with the хост.
  ИПАдрес[] списокАдресов;

  /// A список of алиасы associated with the хост.
  ткст[] алиасы;

  /// The DNS имя of the хост.
  ткст имяХоста;

  /// Resolves an IP адрес to an ИПХост экземпляр.
  static ИПХост дай(ИПАдрес адрес) {
    return дайПоАдресу(адрес, /*includeIPv6*/ true);
  }

  /// Resolves a хост имя or IP адрес to an ИПХост экземпляр.
  static ИПХост дай(ткст hostNameOrAddress) {
    ИПАдрес адр;
    if (ИПАдрес.пробуйРазбор(hostNameOrAddress, адр)
      && (адр.семействоАдресов == ПСемействоАдресов.ИНЕТ || адр.семействоАдресов.ИНЕТ6))
      return дайПоАдресу(адр, true);
    return дайПоИмени(hostNameOrAddress, /*includeIPv6*/ true);
  }

  static ИПХост дайПоАдресу(ИПАдрес адрес) {
    return дайПоАдресу(адрес, /*includeIPv6*/ false);
  }

  static ИПХост дайПоАдресу(ткст адрес) {
    return дайПоАдресу(ИПАдрес.разбор(адрес), /*includeIPv6*/ false);
  }

  static ИПХост дайПоИмени(ткст имяХоста) {
    return дайПоИмени(имяХоста, /*includeIPv6*/ false);
  }

  private static ИПХост дайПоАдресу(ИПАдрес адрес, бул includeIPv6) {
    if (includeIPv6 && supportsIPv6) {
      addrinfo* info;
      addrinfo hints = addrinfo(AI_CANONNAME, AF_UNSPEC);

      ббайт[sockaddr_in6.sizeof] адр;
      адр[0 .. 2] = [cast(ббайт)адрес.семейство_, cast(ббайт)(адрес.семейство_ >> 8)];

      цел смещение = 8;
      foreach (n; адрес.numbers_)
        адр[смещение++ .. смещение++ + 1] = [cast(ббайт)(n >> 8), cast(ббайт)n];

      if (адрес.scopeId_ > 0)
        адр[24 .. $] = [cast(ббайт)адрес.scopeId_, cast(ббайт)(адрес.scopeId_ >> 8), cast(ббайт)(адрес.scopeId_ >> 16), cast(ббайт)(адрес.scopeId_ >> 24)];
      ббайт[] addrBytes = адрес.getAddress();
      адр[8 .. 8 + addrBytes.length] = addrBytes;

      сим[1025] имяХоста;
      if (getnameinfo(cast(sockaddr*)адр.ptr, адр.length, имяХоста.ptr, имяХоста.length, null, 0, NI_NAMEREQD) != 0)
        throw socketException();

      if (getaddrinfo(имяХоста.ptr, null, &hints, &info) != 0)
        throw socketException();
      scope(exit) freeaddrinfo(info);

      return fromAddrInfo(info);
    }

    if (адрес.семействоАдресов == ПСемействоАдресов.ИНЕТ6)
      throw socketException(WSAEPROTONOSUPPORT);

    бцел a = адрес.address_;
    version(BigEndian) {
      a = htol(a);
    }
    auto he = gethostbyaddr(&a, бцел.sizeof, PF_INET);
    if (he == null)
      throw socketException();

    return fromHostEntry(he);
  }

  private static ИПХост дайПоИмени(ткст имяХоста, бул includeIPv6) {
    if (includeIPv6 && supportsIPv6) {
      addrinfo* info;
      addrinfo hints = addrinfo(AI_CANONNAME, AF_UNSPEC);

      if (getaddrinfo(имяХоста.вУтф8н(), null, &hints, &info) != 0)
        throw socketException();
      scope(exit) freeaddrinfo(info);

      return fromAddrInfo(info);
    }

    auto he = gethostbyname(имяХоста.вУтф8н());
    if (he == null) 
      throw socketException();

    return fromHostEntry(he);
  }

  private static ИПХост fromHostEntry(hostent* запись) {
    auto хост = new ИПХост;

    if (запись.h_name != null)
      хост.имяХоста = вУтф8(запись.h_name);

    for (цел i = 0;; i++) {
      if (запись.h_aliases[i] == null)
        break;
      хост.алиасы ~= вУтф8(запись.h_aliases[i]);
    }

    for (цел i = 0;; i++) {
      if (запись.h_addr_list[i] == null)
        break;
      бцел адрес = *cast(бцел*)запись.h_addr_list[i];
      version(BigEndian) {
        адрес = htol(адрес);
      }
      хост.списокАдресов ~= new ИПАдрес(адрес);
    }

    return хост;
  }

  private static ИПХост fromAddrInfo(addrinfo* info) {
    auto хост = new ИПХост;

    while (info != null) {
      if (хост.имяХоста == null && info.ai_canonname != null)
        хост.имяХоста = вУтф8(info.ai_canonname);

      if (info.ai_family == AF_INET || info.ai_family == AF_INET6) {
        if (info.ai_family == AF_INET6) {
          auto адр = cast(sockaddr_in6*)info.ai_addr;
          хост.списокАдресов ~= new ИПАдрес((cast(ббайт*)адр)[8 .. info.ai_addrlen], адр.sin6_scope_id);
        }
        else {
          auto адр = cast(sockaddr_in*)info.ai_addr;
          хост.списокАдресов ~= new ИПАдрес(адр.sin_addr.s_addr);
        }
      }

      info = info.ai_next;
    }

    return хост;
  }

}

class SocketAddress {

  const бцел ipv4AddressSize = sockaddr_in.sizeof;
  const бцел ipv6AddressSize = sockaddr_in6.sizeof;

  private ббайт[] buffer_;
  private бцел размер_;

  this(ПСемействоАдресов семейство, бцел размер = 32) {
    размер_ = размер;
    buffer_.length = размер;
    version(BigEndian) {
      buffer_[0 .. 2] = [cast(ббайт)(семейство >> 8), cast(ббайт)семейство];
    }
    else {
      buffer_[0 .. 2] = [cast(ббайт)семейство, cast(ббайт)(семейство >> 8)];
    }
  }

  проц opIndexAssign(ббайт значение, цел индекс) {
    buffer_[индекс] = значение;
  }
  ббайт opIndex(цел индекс) {
    return buffer_[индекс];
  }

  бцел размер() {
    return размер_;
  }

  ПСемействоАдресов семействоАдресов() {
    version(BigEndian) {
      return cast(ПСемействоАдресов)((buffer_[0] << 8) | buffer_[1]);
    }
    else {
      return cast(ПСемействоАдресов)(buffer_[0] | (buffer_[1] << 8));
    }
  }

}

/**
 * Provides an Интернет Protocol (IP) адрес.
 */
class ИПАдрес {

  static ИПАдрес none;          ///
  static ИПАдрес any;           ///
  static ИПАдрес loopback;      ///
  static ИПАдрес broadcast;     ///
  static ИПАдрес ipv6None;      ///
  static ИПАдрес ipv6Any;       ///
  static ИПАдрес ipv6Loopback;  ///

  static this() {
    none = new ИПАдрес(0xFFFFFFFF);
    any = new ИПАдрес(0x00000000);
    loopback = new ИПАдрес(0x0100007F);
    broadcast = new ИПАдрес(0xFFFFFFFF);
    ipv6None = new ИПАдрес([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
    ipv6Any = new ИПАдрес([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
    ipv6Loopback = new ИПАдрес([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]);
  }

  static ~this() {
    none = null;
    any = null;
    loopback = null;
    broadcast = null;
    ipv6None = null;
    ipv6Any = null;
    ipv6Loopback = null;
  }

  private бцел address_;
  private ПСемействоАдресов семейство_ = ПСемействоАдресов.ИНЕТ;
  private бкрат[8] numbers_;
  private бцел scopeId_;

  private ткст ткст_;

  /// Initializes a new экземпляр.
  this(бцел адрес) {
    address_ = адрес;
  }

  /// ditto
  this(ббайт[] адрес) {
    if (адрес.length == 4) {
      семейство_ = ПСемействоАдресов.ИНЕТ;
      address_ = ((адрес[3] << 24 | адрес[2] << 16 | адрес[1] << 8 | адрес[0]) & 0xffffffff);
    }
    else {
      семейство_ = ПСемействоАдресов.ИНЕТ6;
      for (цел i = 0; i < 8; i++) {
        numbers_[i] = cast(бкрат)(адрес[i * 2] * 256 + адрес[i * 2 + 1]);
      }
    }
  }

  /// ditto
  this(ббайт[] адрес, бцел scopeId) {
    семейство_ = ПСемействоАдресов.ИНЕТ6;
    for (цел i = 0; i < 8; i++) {
      numbers_[i] = cast(бкрат)(адрес[i * 2] * 256 + адрес[i * 2 + 1]);
    }
    scopeId_ = scopeId;
  }

  private this(бкрат[] адрес, бцел scopeId) {
    семейство_ = ПСемействоАдресов.ИНЕТ6;
    numbers_[0 .. 8] = адрес;
    scopeId_ = scopeId;
  }

  /// Returns the ИПАдрес as an array of байты.
  final ббайт[] getAddress() {
    ббайт[] байты;
    if (семейство_ == ПСемействоАдресов.ИНЕТ6) {
      байты.length = 16;
      цел смещение;
      for (цел i = 0; i < 8; i++) {
        байты[смещение++ .. смещение++ + 1] = [
          cast(ббайт)((numbers_[i] >> 8) & 0xff),
          cast(ббайт)(numbers_[i] & 0xff)
        ];
      }
    }
    else {
      байты = [
        cast(ббайт)address_,
        cast(ббайт)(address_ >> 8),
        cast(ббайт)(address_ >> 16),
        cast(ббайт)(address_ >> 24)
      ];
    }
    return байты.dup;
  }

  /// Converts an ИПАдрес to its standard notation.
  final ткст вТкст() {
    if (ткст_ == null) {
      // inet_ntoa only works on IPv4 addresses.
      // Try to use WSAAddressToString on platforms that support IPv6 (WinXP+).
      if (семейство_ == ПСемействоАдресов.ИНЕТ6) {
        if (supportsIPv6) {
          бцел stringLength = 256;
          шим[] ткст = new шим[stringLength];

          ббайт[sockaddr_in6.sizeof] адр;
          адр[0 .. 2] = [cast(ббайт)семейство_, cast(ббайт)(семейство_ >> 8)];

          цел смещение = 8;
          foreach (n; numbers_)
            адр[смещение++ .. смещение++ + 1] = [cast(ббайт)(n >> 8), cast(ббайт)n];
          if (scopeId_ > 0)
            адр[24 .. $] = [cast(ббайт)scopeId_, cast(ббайт)(scopeId_ >> 8), cast(ббайт)(scopeId_ >> 16), cast(ббайт)(scopeId_ >> 24)];

          if (WSAAddressToString(cast(sockaddr*)адр.ptr, адр.length, null, ткст.ptr, stringLength) != 0)
            throw socketException();

          ткст_ = вУтф8(ткст.ptr);
        }
        else {
          // Should only be needed for Win2k without the IPv6 добавь-on.
          ткст s;

          s ~= фм("%04x:", numbers_[0]);
          s ~= фм("%04x:", numbers_[1]);
          s ~= фм("%04x:", numbers_[2]);
          s ~= фм("%04x:", numbers_[3]);
          s ~= фм("%04x:", numbers_[4]);
          s ~= фм("%04x:", numbers_[5]);
          s ~= фм("%s.", (numbers_[6] >> 8) & 0xff);
          s ~= фм("%s.", numbers_[6] & 0xff);
          s ~= фм("%s.", (numbers_[7] >> 8) & 0xff);
          s ~= фм("%s", numbers_[7] & 0xff);
          if (scopeId_ != 0)
            s ~= фм("%%%s", scopeId_);

          ткст_ = s;
        }
      }
      else {
        ткст_ = вУтф8(inet_ntoa(*cast(in_addr*)&address_));
      }
    }
    return ткст_;
  }

  /// Converts an IP адрес ткст to an ИПАдрес экземпляр.
  static ИПАдрес разбор(ткст ipString) {
    return разбор(ipString, false);
  }

  private static ИПАдрес разбор(ткст ipString, бул пробуйРазбор) {
    if (ipString.индексУ(':') != -1) {
      if (supportsIPv6) {
        sockaddr_in6 адр;
        цел addrLength = адр.sizeof;

        if (WSAStringToAddress(ipString.вУтф16н(), AF_INET6, null, cast(sockaddr*)&адр, addrLength) == 0)
          return new ИПАдрес((cast(ббайт*)&адр)[8 .. addrLength], адр.sin6_scope_id);

        if (пробуйРазбор)
          return null;
        throw socketException();
      }
      else {
        // Should we bother to разбор the ткст manually? Since the OS doesn't support IPv6, it seems not worth the effort.
        if (пробуйРазбор)
          return null;
        throw socketException(WSAEINVAL);
      }
    }
    else {
      бцел адрес = inet_addr(ipString.вУтф8н());
      if (адрес == ~0) {
        if (пробуйРазбор)
          return null;
        throw new ИсклФормата;
      }
      return new ИПАдрес(адрес);
    }
  }

  /// Determines whether a ткст is a valid IP _address.
  static бул пробуйРазбор(ткст ipString, out ИПАдрес адрес) {
    return ((адрес = разбор(ipString, true)) !is null);
  }

  бул равен(Объект объ) {
    if (auto другой = cast(ИПАдрес)объ) {
      if (другой.семейство_ != семейство_)
        return false;
      if (семейство_ == ПСемействоАдресов.ИНЕТ6) {
        for (цел i = 0; i < numbers_.length; i++) {
          if (другой.numbers_[i] != numbers_[i])
            return false;
        }
        if (другой.scopeId_ != scopeId_)
          return false;
        return true;
      }
      return другой.address_ == address_;
    }
    return false;
  }

  override typeof(super.opEquals(Объект)) opEquals(Объект объ) {
    return this.равен(объ);
  }

  /// Convers a число from _host байт order to network байт order.
  static крат hostToNetworkOrder(крат хост) {
    version(BigEndian) {
      return хост;
    }
    else {
      return ((cast(цел)хост & 0xff) << 8) | ((хост >> 8) & 0xff);
    }
  }

  /// ditto
  static цел hostToNetworkOrder(цел хост) {
    version(BigEndian) {
      return хост;
    }
    else {
      return (cast(цел)hostToNetworkOrder(cast(крат)(хост & 0xffff)) << 16)
        | (cast(цел)hostToNetworkOrder(cast(крат)(хост >> 16)) & 0xffff);
    }
  }

  /// Converts a число from _network байт order to хост байт order.
  static крат networkToHostOrder(крат network) {
    return hostToNetworkOrder(network);
  }

  /// ditto
  static цел networkToHostOrder(цел network) {
    return hostToNetworkOrder(network);
  }

  final бцел адрес() {
    return address_;
  }

  /// Gets the адрес семейство.
  final ПСемействоАдресов семействоАдресов() {
    return семейство_;
  }

  /// Gets or sets the IPv6 scope identifier.
  final проц scopeId(бцел значение) {
    if (семейство_ == ПСемействоАдресов.ИНЕТ)
      throw socketException(WSAEOPNOTSUPP);

    if (scopeId_ != значение)
      scopeId_ = значение;
  }
  /// ditto
  final бцел scopeId() {
    if (семейство_ == ПСемействоАдресов.ИНЕТ)
      throw socketException(WSAEOPNOTSUPP);

    return scopeId_;
  }

  /// Indicates whether the specified IP _address is the loopback _address.
  final static бул isLoopback(ИПАдрес адрес) {
    if (адрес.семейство_ == ПСемействоАдресов.ИНЕТ6)
      return адрес.равен(ipv6Loopback);
    return (адрес.address_ & 0x0000007F) == (loopback.address_ & 0x0000007F);
  }

  /// Indicates whether the адрес is an IPv6 multicase global адрес.
  final бул isIPv6Multicast() {
    return (семейство_ == ПСемействоАдресов.ИНЕТ6 && (numbers_[0] & 0xFF00) == 0xFF00);
  }

  /// Indicates whether the адрес is an IPv6 link local адрес.
  final бул isIPv6LinkLocal() {
    return (семейство_ == ПСемействоАдресов.ИНЕТ6 && (numbers_[0] & 0xFFC0) == 0xFE80);
  }

  /// Indicates whether the адрес is an IPv6 site local адрес.
  final бул isIPv6SiteLocal() {
    return (семейство_ == ПСемействоАдресов.ИНЕТ6 && (numbers_[0] & 0xFFC0) == 0xFEC0);
  }

}

class IPEndPoint {

  const бкрат minPort = 0x00000000;
  const бкрат maxPort = 0x0000FFFF;
  const бкрат anyPort = minPort;

  static IPEndPoint any;
  static IPEndPoint ipv6Any;

  static this() {
    any = new IPEndPoint(ИПАдрес.any, 0);
    ipv6Any = new IPEndPoint(ИПАдрес.ipv6Any, 0);
  }

  static ~this() {
    any = null;
    ipv6Any = null;
  }

  private ИПАдрес address_;
  private бкрат порт_;

  this(ИПАдрес адрес, бкрат порт) {
    if (адрес is null)
      throw new ИсклНулевогоАргумента("адрес");

    address_ = адрес;
    порт_ = порт;
  }

  this(бцел адрес, бкрат порт) {
    address_ = new ИПАдрес(адрес);
    порт_ = порт;
  }

  SocketAddress serialize() {
    if (address_.семействоАдресов == ПСемействоАдресов.ИНЕТ6) {
      auto saddr = new SocketAddress(ПСемействоАдресов.ИНЕТ6, sockaddr_in6.sizeof);

      бкрат порт = this.порт;
      saddr.buffer_[2 .. 4] = [cast(ббайт)(порт >> 8), cast(ббайт)порт];

      бцел scopeId = address_.scopeId;
      saddr.buffer_[24 .. $] = [cast(ббайт)scopeId, cast(ббайт)(scopeId >> 8), cast(ббайт)(scopeId >> 16), cast(ббайт)(scopeId >> 24)];

      ббайт[] addrBytes = address_.getAddress();
      saddr.buffer_[8 .. 8 + addrBytes.length] = addrBytes;

      return saddr;
    }
    else {
      auto saddr = new SocketAddress(address_.семействоАдресов, sockaddr.sizeof);

      бкрат порт = this.порт;
      saddr.buffer_[2 .. 4] = [cast(ббайт)(порт >> 8), cast(ббайт)порт];

      бцел a = address_.address_;
      saddr.buffer_[4 .. 8] = [cast(ббайт)a, cast(ббайт)(a >> 8), cast(ббайт)(a >> 16), cast(ббайт)(a >> 24)];

      return saddr;
    }
  }

  override ткст вТкст() {
    return адрес.вТкст() ~ ":" ~ win32.loc.conv.вТкст(порт);
  }

  final проц адрес(ИПАдрес значение) {
    address_ = значение;
  }
  final ИПАдрес адрес() {
    return address_;
  }

  final ПСемействоАдресов семействоАдресов() {
    return address_.семействоАдресов;
  }

  final проц порт(бкрат значение) {
    порт_ = значение;
  }
  final бкрат порт() {
    return порт_;
  }

}

class PingException : Exception {

  this(ткст сообщение) {
    super(сообщение);
  }

}

/// Reports the status of sending an ICMP echo сообщение to a computer.
enum IPStatus {
  Unknown                         = -1,                       ///
  Success                         = IP_SUCCESS,               ///
  DestinationNetworkUnreachable   = IP_DEST_NET_UNREACHABLE,  ///
  DestinationHostUnreachable      = IP_DEST_HOST_UNREACHABLE, ///
  DestinationProtocolUnreachable  = IP_DEST_PROT_UNREACHABLE, ///
  DestinationPortUnreachable      = IP_DEST_PORT_UNREACHABLE, ///
  NoResources                     = IP_NO_RESOURCES,          ///
  BadOption                       = IP_BAD_OPTION,            ///
  HardwareError                   = IP_HW_ERROR,              ///
  PacketTooBig                    = IP_PACKET_TOO_BIG,        ///
  TimedOut                        = IP_REQ_TIMED_OUT,         ///
  BadRoute                        = IP_BAD_ROUTE,             ///
  TtlExpired                      = IP_TTL_EXPIRED_TRANSIT,   ///
  TtlReassemblyTimeExceeded       = IP_TTL_EXPIRED_REASSEM,   ///
  ParameterProblem                = IP_PARAM_PROBLEM,         ///
  SourceQuench                    = IP_SOURCE_QUENCH,         ///
  BadDestination                  = IP_BAD_DESTINATION        ///
}

/// Provides information about the status and данные resulting from a Ping.шли operation.
class PingReply {

  private IPStatus status_;
  private ббайт[] buffer_;
  private ИПАдрес address_;
  private бцел roundTripTime_;

  private this(IPStatus status) {
    status_ = status;
  }

  private this(ICMP_ECHO_REPLY* reply) {
    address_ = new ИПАдрес(reply.адрес);
    status_ = cast(IPStatus)reply.status;
    if (status_ == IPStatus.Success) {
      roundTripTime_ = reply.roundTripTime;
      buffer_.length = reply.dataSize;
      memcpy(buffer_.ptr, reply.данные, buffer_.length);
    }
  }

  private this(ICMPV6_ECHO_REPLY* reply, ук данные, бцел dataSize) {
    address_ = new ИПАдрес(reply.адрес.sin6_addr, reply.адрес.sin6_scope_id);
    status_ = cast(IPStatus)reply.status;
    if (status_ == IPStatus.Success) {
      roundTripTime_ = reply.roundTripTime;
      buffer_.length = dataSize;
      memcpy(buffer_.ptr, данные + 36, dataSize);
    }
  }

  final IPStatus status() {
    return status_;
  }

  final ИПАдрес адрес() {
    return address_;
  }

  final бцел roundTripTime() {
    return roundTripTime_;
  }

  final ббайт[] буфер() {
    return buffer_;
  }

}

/**
 * Determines whether a remote computer is accessible over the network.
 * Examples:
 * ---
 * проц pingServer(ткст server) {
 *   scope ping = new Ping;
 *   auto reply = ping.шли(server);
 *   if (reply.status == IPStatus.Success) {
 *     скажифнс("Адрес: %s", reply.адрес);
 *     скажифнс("Roundtrip время: %s", reply.roundTripTime);
 *   }
 * }
 * ---
 */
class Ping : ИВымещаемый {

  private const бцел DEFAULT_TIMEOUT = 5000;
  private const бцел DEFAULT_BUFFER_SIZE = 32;

  private Укз pingHandleV4_;
  private Укз pingHandleV6_;
  private бул ipv6_;
  private ук requestBuffer_;
  private ук replyBuffer_;

  private ббайт[] defaultBuffer_;

  ~this() {
    dispose();
  }

  проц dispose() {
    if (pingHandleV4_ != Укз.init) {
      if (isWin2k)
        IcmpCloseHandleWin2k(pingHandleV4_);
      else
        IcmpCloseHandle(pingHandleV4_);
      pingHandleV4_ = Укз.init;
    }
    if (pingHandleV6_ != Укз.init) {
      IcmpCloseHandle(pingHandleV6_);
      pingHandleV6_ = Укз.init;
    }

    if (replyBuffer_ != null) {
      win32.base.native.LocalFree(replyBuffer_);
      replyBuffer_ = null;
    }
  }

  /// Attempts to _send an ICMP echo сообщение to a remote computer and получи an ICMP echo reply сообщение.
  PingReply шли(ткст hostNameOrAddress, бцел таймаут = DEFAULT_TIMEOUT) {
    ИПАдрес адрес = ИПХост.дай(hostNameOrAddress).списокАдресов[0];
    return шли(адрес, таймаут);
  }

  /// ditto
  PingReply шли(ткст hostNameOrAddress, бцел таймаут, ббайт[] буфер) {
    ИПАдрес адрес = ИПХост.дай(hostNameOrAddress).списокАдресов[0];
    return шли(адрес, таймаут, буфер);
  }

  /// ditto
  PingReply шли(ИПАдрес адрес, бцел таймаут = DEFAULT_TIMEOUT) {
    return шли(адрес, таймаут, defaultBuffer);
  }

  /// ditto
  PingReply шли(ИПАдрес адрес, бцел таймаут, ббайт[] буфер) {
    if (адрес is null)
      throw new ИсклНулевогоАргумента("адрес");

    ipv6_ = (адрес.семействоАдресов == ПСемействоАдресов.ИНЕТ6);

    if (!ipv6_ && pingHandleV4_ == Укз.init) {
      if (isWin2k)
        pingHandleV4_ = IcmpCreateFileWin2k();
      else
        pingHandleV4_ = IcmpCreateFile();
    }
    else if (ipv6_ && pingHandleV6_ == Укз.init) {
      pingHandleV6_ = Icmp6CreateFile();
    }

    IP_OPTION_INFORMATION optionInfo;
    optionInfo.ttl = 128;

    requestBuffer_ = cast(ук)win32.base.native.LocalAlloc(LMEM_FIXED, буфер.length);
    memcpy(requestBuffer_, буфер.ptr, буфер.length);
    scope(exit) win32.base.native.LocalFree(requestBuffer_);

    бцел replyBufferSize = ICMPV6_ECHO_REPLY.sizeof + буфер.length + 8;
    if (replyBuffer_ == null)
      replyBuffer_ = cast(ук)win32.base.native.LocalAlloc(LMEM_FIXED, replyBufferSize);

    бцел ошибка;
    if (!ipv6_) {
      if (isWin2k)
        ошибка = IcmpSendEcho2Win2k(pingHandleV4_, Укз.init, null, null, адрес.address_, requestBuffer_, cast(бкрат)буфер.length, &optionInfo, replyBuffer_, replyBufferSize, таймаут);
      else
        ошибка = IcmpSendEcho2(pingHandleV4_, Укз.init, null, null, адрес.address_, requestBuffer_, cast(бкрат)буфер.length, &optionInfo, replyBuffer_, replyBufferSize, таймаут);
    }
    else {
      ббайт[sockaddr_in6.sizeof] sourceAddr;
      ббайт[sockaddr_in6.sizeof] remoteAddr;
      remoteAddr[0 .. 2] = [
        cast(ббайт)адрес.семейство_,
        cast(ббайт)(адрес.семейство_ >> 8)
      ];

      цел смещение = 8;
      foreach (n; адрес.numbers_) {
        remoteAddr[смещение++ .. смещение++ + 1] = [
          cast(ббайт)(n >> 8),
          cast(ббайт)n
        ];
      }
      if (адрес.scopeId_ > 0) {
        remoteAddr[24 .. $] = [
          cast(ббайт)адрес.scopeId_,
          cast(ббайт)(адрес.scopeId_ >> 8),
          cast(ббайт)(адрес.scopeId_ >> 16),
          cast(ббайт)(адрес.scopeId_ >> 24)
        ];
      }
      ббайт[] addrBytes = адрес.getAddress();
      remoteAddr[8 .. 8 + addrBytes.length] = addrBytes;
      ошибка = Icmp6SendEcho2(pingHandleV6_, Укз.init, null, null, sourceAddr.ptr, remoteAddr.ptr, requestBuffer_, cast(бкрат)буфер.length, &optionInfo, replyBuffer_, replyBufferSize, таймаут);
    }

    if (ошибка == 0) {
      ошибка = win32.base.native.GetLastError();
      if (ошибка != 0)
        return new PingReply(cast(IPStatus)ошибка);
    }

    if (ipv6_)
      return new PingReply(cast(ICMPV6_ECHO_REPLY*)replyBuffer_, replyBuffer_, буфер.length);
    return new PingReply(cast(ICMP_ECHO_REPLY*)replyBuffer_);
  }

  private ббайт[] defaultBuffer() {
    if (defaultBuffer_ == null) {
      defaultBuffer_.length = DEFAULT_BUFFER_SIZE;
      foreach (i, ref b; defaultBuffer_)
        b = cast(ббайт)('a' + i % 23);
    }
    return defaultBuffer_;
  }

}

/// Pings the specified server.
бул ping(ткст hostNameOrAddress, бцел таймаут = Ping.DEFAULT_TIMEOUT) {
  scope sender = new Ping;
  return (sender.шли(hostNameOrAddress, таймаут).status == IPStatus.Success);
}