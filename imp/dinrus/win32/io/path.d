/**
 * Performs operations on strings that contain file or папка _path information.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.io.path;

import win32.base.core,
  win32.base.string,
  win32.base.native;
static import stdrus;

version(Windows)
{

    /** String used to separate папка names in a путь. Under
	*  Windows this is a backslash, under Linux a slash. */
    const char[1] сеп = "\\";
    /** Alternate version of сеп[] used in Windows (a slash). Under
	*  Linux this is пустой. */
    const char[1] альтсеп = "/";
    /** Path делитель string. A semi colon under Windows, a colon
	*  under Linux. */
    const char[1] сеппути = ";";
    /** String used to separate lines, \r\n under Windows and \n
	* under Linux. */
    const char[2] сепстрок = "\r\n"; /// String used to separate lines.
    const char[1] текпап = ".";	 /// String representing the текущ папка.
    const char[2] родпап = ".."; /// String representing the родитель папка.
}
version(Posix)
{
    /** String used to separate папка names in a путь. Under
	*  Windows this is a backslash, under Linux a slash. */
    const char[1] сеп = "/";
    /** Alternate version of сеп[] used in Windows (a slash). Under
	*  Linux this is пустой. */
    const char[0] альтсеп;
    /** Path делитель string. A semi colon under Windows, a colon
	*  under Linux. */
    const char[1] сеппути = ":";
    /** String used to separate lines, \r\n under Windows and \n
	* under Linux. */
    const char[1] сепстрок = "\n";
    const char[1] текпап = ".";	 /// String representing the текущ папка.
    const char[2] родпап = ".."; /// String representing the родитель папка.
}

/// The maximum character length of a путь.
const цел МаксПуть = 260;

/// Returns the текущ working папка for the текущ process.
ткст текПапка() {
  шим[МаксПуть + 1] буфер;
  бцел len = GetCurrentDirectory(буфер.length, буфер.ptr);
  return буфер[0 .. len].вУтф8();
}

/// Returns the путь of the system папка.
ткст сисПапка() {
  шим[МаксПуть + 1] буфер;
  бцел len = GetSystemDirectory(буфер.ptr, буфер.length);
  return буфер[0 .. len].вУтф8();
}

/// Returns the путь of the system's temporary folder.
ткст времПуть() {
  шим[МаксПуть] буфер;
  бцел len = GetTempPath(МаксПуть, буфер.ptr);
  return дайПолнПуть(буфер[0 .. len].вУтф8());
}

/// Creates a uniquely named temporary file on disk and returns the путь of that file.
ткст времИмяФ() {
  шим[МаксПуть] буфер;
  GetTempPath(МаксПуть, буфер.ptr);
  GetTempFileName(буфер.ptr, "tmp", 0, буфер.ptr);
  return вУтф8(буфер.ptr);
}

/*package*/ цел дайДлинуКорня(ткст путь) {
  цел i, len = путь.length;
  if (len >= 1 && (путь[0] == win32.io.path.сеп[0] || путь[0] == win32.io.path.альтсеп[0])) {
    i = 1;
    if (len >= 2 && (путь[1] == win32.io.path.сеп[0] || путь[1] == win32.io.path.альтсеп[0])) {
      i = 2;
      цел n = 2;
      while (i < len && ((путь[i] != win32.io.path.сеп[0] && путь[i] != win32.io.path.альтсеп[0]) || --n > 0)) {
        i++;
      }
    }
  }
  else if (len >= 2 && путь[1] == ':') {
    i = 2;
    if (len >= 3 && (путь[2] == win32.io.path.сеп[0] || путь[2] == win32.io.path.альтсеп[0])) {
      i++;
    }
  }
  return i;
}

ткст дайКореньПути(ткст путь) {
  if (путь == null)
    return null;
  return путь[0 .. дайДлинуКорня(путь)];
}

/// Indicates whether the specified _path ткст содержит absolute or relative _path information.
бул путьСКорнем_ли(ткст путь) {
  if ((путь.length > 1 && (путь[0] == win32.io.path.сеп[0] || путь[0] == win32.io.path.альтсеп[0])) || (путь.length >= 2 && путь[1] == ':'))
    return true;
  return false;
}

/// Combines two путь strings.
ткст комбинируй(ткст path1, ткст path2) {
  if (path2.length == 0)
    return path1;
  if (path1.length == 0)
    return path2;
  if (путьСКорнем_ли(path2))
    return path2;
  сим last = path1[$ - 1];
  if (last != win32.io.path.сеп[0] && last != win32.io.path.альтсеп[0] && last != ':')
    return path1 ~ win32.io.path.сеп[0] ~ path2;
  return path1 ~ path2;
}

ткст дайИмяПапки(ткст путь) {
  цел root = дайДлинуКорня(путь);
  цел i = путь.length;
  if (i > root) {
    i = путь.length;
    if (i == root)
      return null;
    while (i > root && путь[--i] != win32.io.path.сеп[0] && путь[i] != win32.io.path.альтсеп[0]) {
    }
    return путь[0 .. i];
  }
  // Required by DMD 2.031
  assert(false);
}

/// Returns the file имя and extension of the specified _path ткст.
ткст дайИмяФ(ткст путь) {
  for (цел i = путь.length; --i >= 0;) {
    сим ch = путь[i];
    if (ch == win32.io.path.сеп[0] || ch == win32.io.path.альтсеп[0] || ch == ':')
      return путь[i + 1 .. $];
  }
  return путь;
}

/// Returns the absolute _path for the specified _path ткст.
ткст дайПолнПуть(ткст путь) {
  auto p = путь.вУтф16н();

  auto буфер = new шим[МаксПуть + 1];
  auto bufferLength = GetFullPathName(p, МаксПуть + 1, буфер.ptr, null);

  if (bufferLength > МаксПуть) {
    буфер = new шим[bufferLength];
    bufferLength = GetFullPathName(p, bufferLength, буфер.ptr, null);
  }

  бул expandShortPath;
  for (auto i = 0; i < bufferLength && !expandShortPath; i++) {
    if (буфер[i] == '~')
      expandShortPath = true;
  }
  if (expandShortPath) {
    // Expand крат путь names such as C:\Progra~1\Micros~2
    auto tempBuffer = new шим[МаксПуть + 1];
    bufferLength = GetLongPathName(буфер.ptr, tempBuffer.ptr, МаксПуть);

    if (bufferLength > 0)
      return tempBuffer[0 .. bufferLength].вУтф8();
  }

  return буфер[0 .. bufferLength].вУтф8();
}

/// Specifies constants used to retrieve папка paths to system special folders.
enum ПОсобаяПапка {
  РабСтол = 0x0000,                 /// The logical _Desktop rather than the physical file system положение.
  Интернет = 0x0001,                /// 
  Программы = 0x0002,                /// The папка that содержит the user's program groups.
  Контролы = 0x0003,                /// The УпрЭлт Panel folder.
  Принтеры = 0x0004,                ///
  Личное = 0x0005,                /// The папка that serves as a common repository for documents.
  Избранное = 0x0006,               /// The папка that serves as a common repository for the user's favorite items.
  Стартап = 0x0007,                 /// The папка that corresponds to the user's _Startup program group.
  Недавнее = 0x0008,                  /// The папка that содержит the user's most recently used documents.
  Отправить = 0x0009,                  /// The папка that содержит the Send To menu items.
  Корзина = 0x000a,              /// The Recycle Bin folder.
  МенюПуск = 0x000b,               /// The папка that содержит the Start menu items.
  Документы = Личное,             /// The папка that serves as a common repository for documents.
  Музыка = 0x000d,                   /// The "_Music" folder.
  Видео = 0x000e,                   /// The "_Video" folder.
  ПапкаРабстола = 0x0010,        /// The папка used to physically store file objects on the desktop.
  Компьютер = 0x0011,                /// The "_Computer" folder.
  Сеть = 0x0012,                 /// The "_Network" folder.
  Шрифты = 0x0014,                   /// The папка that serves as a common repository for fonts.
  Шаблоны = 0x0015,               /// The папка that serves as a common repository for document templates.
  CommonStartMenu = 0x0016,         /// 
  CommonPrograms = 0x0017,          /// The папка for компоненты that are shared across applications.
  CommonStartup = 0x0018,           /// 
  CommonDesktopDirectory = 0x0019,  /// 
  ApplicationData = 0x001a,         /// The папка that serves as a common repository for application-specific данные for the текущ roaming user.
  LocalApplicationData = 0x001c,    /// The папка that serves as a common repository for application-specific данные that is used by the текущ, non-roaming user.
  InternetCache = 0x0020,           /// The папка that serves as a common repository for temporary Интернет files.
  Cookies = 0x0021,                 /// The папка that serves as a common repository for Интернет cookies.
  History = 0x0022,                 /// The папка that serves as a common repository for Интернет history items.
  CommonApplicationData = 0x0023,   /// The папка that serves as a common repository for application-specific данные that is used by all users.
  Windows = 0x0024,                 /// The _Windows папка.
  Система = 0x0025,                  /// The _System папка.
  ProgramFiles = 0x0026,            /// The program files папка.
  Pictures = 0x0027,                /// The "_Pictures" folder.
  CommonProgramFiles = 0x002b,      /// The папка for компоненты that are shared across applications.
  CommonTemplates = 0x002d,         ///
  CommonDocuments = 0x002e,         /// 
  Connections = 0x0031,             ///
  CommonPictures = 0x0036,          ///
  Resources = 0x0038,               ///
  LocalizedResources = 0x0039,      /// 
  CDBurning = 0x003b                ///
}

/**
 * Gets the путь to the specified system special _folder.
 * Параметры: folder = A константа that identifies a system special _folder.
 * Возвращает: The путь to the specified system special _folder, if that _folder существует on your computer; otherwise, an пустой ткст.
 */
ткст дайПутьКПапке(ПОсобаяПапка folder) {
  шим[МаксПуть] буфер;
  // SHGetFolderPath fails if folder is a virtual folder, eg ПОсобаяПапка.Сеть.
  if (SHGetFolderPath(Укз.init, cast(цел)folder, Укз.init, SHGFP_TYPE_CURRENT, буфер.ptr) == 0)
    return .вУтф8(буфер.ptr);
  return null;
}