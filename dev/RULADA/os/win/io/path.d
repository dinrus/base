﻿/**
 * Performs operations on strings that contain file or directory _path information.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module os.win.io.path;

import os.win.base.core,
  os.win.base.string,
  os.win.base.native;
static import std.path;

/// The maximum character length of a path.
const int MaxPath = 260;

/// Returns the current working directory for the current process.
string currentDirectory() {
  wchar[MaxPath + 1] buffer;
  uint len = GetCurrentDirectory(buffer.length, buffer.ptr);
  return buffer[0 .. len].toUtf8();
}

/// Returns the path of the system directory.
string systemDirectory() {
  wchar[MaxPath + 1] buffer;
  uint len = GetSystemDirectory(buffer.ptr, buffer.length);
  return buffer[0 .. len].toUtf8();
}

/// Returns the path of the system's temporary folder.
string tempPath() {
  wchar[MaxPath] buffer;
  uint len = GetTempPath(MaxPath, buffer.ptr);
  return getFullPath(buffer[0 .. len].toUtf8());
}

/// Creates a uniquely named temporary file on disk and returns the path of that file.
string tempFileName() {
  wchar[MaxPath] buffer;
  GetTempPath(MaxPath, buffer.ptr);
  GetTempFileName(buffer.ptr, "tmp", 0, buffer.ptr);
  return toUtf8(buffer.ptr);
}

/*package*/ int getRootLength(string path) {
  int i, len = path.length;
  if (len >= 1 && (path[0] == std.path.sep[0] || path[0] == std.path.altsep[0])) {
    i = 1;
    if (len >= 2 && (path[1] == std.path.sep[0] || path[1] == std.path.altsep[0])) {
      i = 2;
      int n = 2;
      while (i < len && ((path[i] != std.path.sep[0] && path[i] != std.path.altsep[0]) || --n > 0)) {
        i++;
      }
    }
  }
  else if (len >= 2 && path[1] == ':') {
    i = 2;
    if (len >= 3 && (path[2] == std.path.sep[0] || path[2] == std.path.altsep[0])) {
      i++;
    }
  }
  return i;
}

string getPathRoot(string path) {
  if (path == null)
    return null;
  return path[0 .. getRootLength(path)];
}

/// Indicates whether the specified _path string contains absolute or relative _path information.
bool isPathRooted(string path) {
  if ((path.length > 1 && (path[0] == std.path.sep[0] || path[0] == std.path.altsep[0])) || (path.length >= 2 && path[1] == ':'))
    return true;
  return false;
}

/// Combines two path strings.
string combine(string path1, string path2) {
  if (path2.length == 0)
    return path1;
  if (path1.length == 0)
    return path2;
  if (isPathRooted(path2))
    return path2;
  char last = path1[$ - 1];
  if (last != std.path.sep[0] && last != std.path.altsep[0] && last != ':')
    return path1 ~ std.path.sep[0] ~ path2;
  return path1 ~ path2;
}

string getDirectoryName(string path) {
  int root = getRootLength(path);
  int i = path.length;
  if (i > root) {
    i = path.length;
    if (i == root)
      return null;
    while (i > root && path[--i] != std.path.sep[0] && path[i] != std.path.altsep[0]) {
    }
    return path[0 .. i];
  }
  // Required by DMD 2.031
  assert(false);
}

/// Returns the file name and extension of the specified _path string.
string getFileName(string path) {
  for (int i = path.length; --i >= 0;) {
    char ch = path[i];
    if (ch == std.path.sep[0] || ch == std.path.altsep[0] || ch == ':')
      return path[i + 1 .. $];
  }
  return path;
}

/// Returns the absolute _path for the specified _path string.
string getFullPath(string path) {
  auto p = path.toUtf16z();

  auto buffer = new wchar[MaxPath + 1];
  auto bufferLength = GetFullPathName(p, MaxPath + 1, buffer.ptr, null);

  if (bufferLength > MaxPath) {
    buffer = new wchar[bufferLength];
    bufferLength = GetFullPathName(p, bufferLength, buffer.ptr, null);
  }

  bool expandShortPath;
  for (auto i = 0; i < bufferLength && !expandShortPath; i++) {
    if (buffer[i] == '~')
      expandShortPath = true;
  }
  if (expandShortPath) {
    // Expand short path names such as C:\Progra~1\Micros~2
    auto tempBuffer = new wchar[MaxPath + 1];
    bufferLength = GetLongPathName(buffer.ptr, tempBuffer.ptr, MaxPath);

    if (bufferLength > 0)
      return tempBuffer[0 .. bufferLength].toUtf8();
  }

  return buffer[0 .. bufferLength].toUtf8();
}

/// Specifies constants used to retrieve directory paths to system special folders.
enum SpecialFolder {
  Desktop = 0x0000,                 /// The logical _Desktop rather than the physical file system location.
  Internet = 0x0001,                /// 
  Programs = 0x0002,                /// The directory that contains the user's program groups.
  Controls = 0x0003,                /// The Control Panel folder.
  Printers = 0x0004,                ///
  Personal = 0x0005,                /// The directory that serves as a common repository for documents.
  Favorites = 0x0006,               /// The directory that serves as a common repository for the user's favorite items.
  Startup = 0x0007,                 /// The directory that corresponds to the user's _Startup program group.
  Recent = 0x0008,                  /// The directory that contains the user's most recently used documents.
  SendTo = 0x0009,                  /// The directory that contains the Send To menu items.
  RecycleBin = 0x000a,              /// The Recycle Bin folder.
  StartMenu = 0x000b,               /// The directory that contains the Start menu items.
  Documents = Personal,             /// The directory that serves as a common repository for documents.
  Music = 0x000d,                   /// The "_Music" folder.
  Video = 0x000e,                   /// The "_Video" folder.
  DesktopDirectory = 0x0010,        /// The directory used to physically store file objects on the desktop.
  Computer = 0x0011,                /// The "_Computer" folder.
  Network = 0x0012,                 /// The "_Network" folder.
  Fonts = 0x0014,                   /// The directory that serves as a common repository for fonts.
  Templates = 0x0015,               /// The directory that serves as a common repository for document templates.
  CommonStartMenu = 0x0016,         /// 
  CommonPrograms = 0x0017,          /// The directory for components that are shared across applications.
  CommonStartup = 0x0018,           /// 
  CommonDesktopDirectory = 0x0019,  /// 
  ApplicationData = 0x001a,         /// The directory that serves as a common repository for application-specific data for the current roaming user.
  LocalApplicationData = 0x001c,    /// The directory that serves as a common repository for application-specific data that is used by the current, non-roaming user.
  InternetCache = 0x0020,           /// The directory that serves as a common repository for temporary Internet files.
  Cookies = 0x0021,                 /// The directory that serves as a common repository for Internet cookies.
  History = 0x0022,                 /// The directory that serves as a common repository for Internet history items.
  CommonApplicationData = 0x0023,   /// The directory that serves as a common repository for application-specific data that is used by all users.
  Windows = 0x0024,                 /// The _Windows directory.
  System = 0x0025,                  /// The _System directory.
  ProgramFiles = 0x0026,            /// The program files directory.
  Pictures = 0x0027,                /// The "_Pictures" folder.
  CommonProgramFiles = 0x002b,      /// The directory for components that are shared across applications.
  CommonTemplates = 0x002d,         ///
  CommonDocuments = 0x002e,         /// 
  Connections = 0x0031,             ///
  CommonPictures = 0x0036,          ///
  Resources = 0x0038,               ///
  LocalizedResources = 0x0039,      /// 
  CDBurning = 0x003b                ///
}

/**
 * Gets the path to the specified system special _folder.
 * Параметры: folder = A constant that identifies a system special _folder.
 * Возвращает: The path to the specified system special _folder, if that _folder exists on your computer; otherwise, an empty string.
 */
string getFolderPath(SpecialFolder folder) {
  wchar[MaxPath] buffer;
  // SHGetFolderPath fails if folder is a virtual folder, eg SpecialFolder.Network.
  if (SHGetFolderPath(Handle.init, cast(int)folder, Handle.init, SHGFP_TYPE_CURRENT, buffer.ptr) == 0)
    return .toUtf8(buffer.ptr);
  return null;
}