/**
 * Предоставляет информацию о текущей среде _environment.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.base.environment;

import win32.base.core,
  win32.base.string,
  win32.base.native;

version(D_Version2) {
  import core.memory;
}
else {
  static import stdrus;
}

/**
 * Получает командную строку.
 */
ткст дайКомСтроку() {
  return .вУтф8(GetCommandLine());
}

/**
 * Получает массив, содержащий аргументы командной строки.
 */
ткст[] дайАргиКомСтроки() {
  цел argc;
  шим** argv = CommandLineToArgv(GetCommandLine(), argc);
  if (argc == 0) return null;

  ткст* a = cast(ткст*)gc_malloc(argc * ткст.sizeof);
  for (цел i = 0; i < argc; i++) {
    a[i] = .вУтф8(argv[i]);
  }

  LocalFree(cast(Укз)argv);
  return a[0 .. argc];
}

/**
 * Получает или устанавливает название локального компьютера в NetBIOS.
 */
проц дайИмяМашины(ткст значение) {
  SetComputerName(значение.вУтф16н());
}
/// ditto
ткст дайИмяМашины() {
  шим[256] буфер;
  бцел размер = буфер.length;

  if (!GetComputerName(буфер.ptr, размер))
    throw new ИсклНеправильнОперации;

  return .вУтф8(буфер.ptr, 0, размер);
}

/**
 * Получает имя пользователя, который залогинился в Windows на данный момент.
 */
ткст дайИмяПользователя() {
  шим[256] буфер;
  бцел размер = буфер.length;

  GetUserName(буфер.ptr, размер);

  return .вУтф8(буфер.ptr, 0, размер);
}

/**
 * Получает число миллисекунд, прошедших с начала работы системы.
 */
цел дайМсекСНачРаботы() {
  return GetTickCount();
}

/**
 * Replaces the имя of each environment variable embedded in the specified ткст with the ткст equivalent of the значение of the variable.
 * Параметры: имя = A ткст containing the names of zero or more environment variables. Среда variables are quoted with the percent знак.
 * Возвращает: A ткст with each environment variable replaced by its значение.
 * Примеры:
 * ---
 * скажифнс(раскройПеременныеСреды("My system drive is %SystemDrive% and my system root is %SystemRoot%"));
 * ---
 */
ткст раскройПеременныеСреды(ткст имя) {
  ткст[] parts = имя.разбей('%');

  цел c = 100;
  шим[] буфер = new шим[c];
  for (цел i = 1; i < parts.length - 1; i++) {
    if (parts[i].length > 0) {
      ткст времн = "%" ~ parts[i] ~ "%";
      бцел n = ExpandEnvironmentStrings(времн.вУтф16н(), буфер.ptr, c);
      while (n > c) {
        c = n;
        буфер.length = c;
        n = ExpandEnvironmentStrings(времн.вУтф16н(), буфер.ptr, c);
      }
    }
  }

  бцел n = ExpandEnvironmentStrings(имя.вУтф16н(), буфер.ptr, c);
  while (n > c) {
    c = n;
    буфер.length = c;
    n = ExpandEnvironmentStrings(имя.вУтф16н(), буфер.ptr, c);
  }

  return .вУтф8(буфер.ptr);
}

/**
 * Represents a version число.
 */
final class Версия {

  private цел major_;
  private цел minor_;
  private цел build_;
  private цел revision_;

  /**
   * Initializes a new экземпляр.
   */
  this(цел major, цел minor, цел build = -1, цел revision = -1) {
    major_ = major;
    minor_ = minor;
    build_ = build;
    revision_ = revision;
  }

  /**
   * Gets the значение of the _major component.
   */
  цел major() {
    return major_;
  }

  /**
   * Gets the значение of the _minor component.
   */
  цел minor() {
    return minor_;
  }

  /**
   * Gets the значение of the _build component.
   */
  цел build() {
    return build_;
  }

  /**
   * Gets the значение of the _revision component.
   */
  цел revision() {
    return revision_;
  }

  override цел opCmp(Объект другой) {
    if (другой is null)
      return 1;

    auto v = cast(Версия)другой;
    if (v is null)
      throw new ИсклАргумента("Аргумент должен быть типа Версия.");

    if (major_ != v.major_) {
      if (major_ > v.major_)
        return 1;
      return -1;
    }
    if (minor_ != v.minor_) {
      if (minor_ > v.minor_)
        return 1;
      return -1;
    }
    if (build_ != v.build_) {
      if (build_ > v.build_)
        return 1;
      return -1;
    }
    if (revision_ != v.revision_) {
      if (revision_ > v.revision_)
        return 1;
      return -1;
    }
    return 0;
  }

  override typeof(super.opEquals(Объект)) opEquals(Объект другой) {
    auto v = cast(Версия)другой;
    if (v is null)
      return false;

    return (major_ == v.major_
      && minor_ == v.minor_
      && build_ == v.build_
      && revision_ == v.revision_);
  }

  бцел вХэш() {
    бцел hash = (major_ & 0x0000000F) << 28;
    hash |= (minor_ & 0x000000FF) << 20;
    hash |= (build_ & 0x000000FF) << 12;
    hash |= revision_ & 0x00000FFF;
    return hash;
  }

  override ткст вТкст() {
    ткст s = stdrus.фм("%d.%d", major_, minor_);
    if (build_ != -1) {
      s ~= stdrus.фм(".%d", build_);
      if (revision_ != -1)
        s ~= stdrus.фм(".%d", revision_);
    }
    return s;
  }

}

/+const PlatformId {
  Win32s,
  Win32Windows,
  Win32NT
}

PlatformId osPlatform() {
  static Опционал!(PlatformId) osPlatform_;

  if (!osPlatform_.hasValue) {
    OSVERSIONINFOEX osvi;
    if (GetVersionEx(osvi) == 0)
      throw new ИсклНеправильнОперации("GetVersion failed.");

    osPlatform_ = cast(PlatformId)osvi.dwPlatformId;
  }

  return osPlatform_.значение;
}+/

/**
 * Gets a Версия object describing the major, minor, build and revision numbers of the operating system.
 */
Версия версияОс() {
  static Версия osVersion_;

  if (osVersion_ is null) {
    OSVERSIONINFOEX osvi;
    if (GetVersionEx(osvi) == 0)
      throw new ИсклНеправильнОперации("GetVersion failed.");

    osVersion_ = new Версия(
      osvi.dwMajorVersion, 
      osvi.dwMinorVersion, 
      osvi.dwBuildNumber, 
      (osvi.wServicePackMajor << 16) | osvi.wServicePackMinor
    );
  }

  return osVersion_;
}