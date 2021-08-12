/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.io.core;

import win32.base.core,
  win32.base.string,
  win32.base.text,
  win32.base.native,
  cidrus,
  stdrus, tpl.stream, tpl.args;
debug import stdrus : скажифнс;

enum ПАтрыФайла {
  ТолькоЧтение            = 0x00000001,
  Скрыт              = 0x00000002,
  Система              = 0x00000004,
  Папка           = 0x00000010,
  Архив             = 0x00000020,
  Устройство              = 0x00000040,
  Normal              = 0x00000080,
  Temporary           = 0x00000100,
  SparseFile          = 0x00000200,
  ReparsePoint        = 0x00000400,
  Compressed          = 0x00000800,
  Offline             = 0x00001000,
  NotContentIndexed   = 0x00002000,
  Encrypted           = 0x00004000,
  Virtual             = 0x00010000
}

/*package*/ проц ошибкаВВ(бцел кодОш, ткст путь) {

  ткст дайОшСооб(бцел кодОш) {
    шим[256] буфер;
    бцел рез = FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, null, кодОш, 0, буфер.ptr, буфер.length + 1, null);
    if (рез != 0)
      return .вУтф8(буфер[0 .. рез].ptr);
    return фм("Неопределяемая ошибка (0x%08X)", кодОш);
  }

  switch (кодОш) {
    case ERROR_FILE_NOT_FOUND:
      throw new ФайлНеНайденИскл(дайОшСооб(кодОш), путь);
     // break;

    default:
      throw new ИсклВводаВывода(дайОшСооб(кодОш));
      //break;
  }
}

class ИсклВводаВывода : Exception {

  private static const E_IO = "Произошла ошибка ввода-вывода.";

  this() {
    super(E_IO);
  }

  this(ткст сообщение) {
    super(сообщение);
  }

}

class ФайлНеНайденИскл : Exception {

  private static const E_FILENOTFOUND = "Не удаётся найти указанный файл.";

  private ткст fileName_;

  this() {
    super(E_FILENOTFOUND);
  }

  this(ткст сообщение) {
    super(сообщение);
  }

  this(ткст сообщение, ткст имяф) {
    super(сообщение);
    fileName_ = имяф;
  }

  final ткст имяф() {
    return fileName_;
  }

}

/**
 * Represents a reader that can читай a sequential series of characters.
 */
abstract class Читака {

  protected this() {
  }

  ~this() {
    закрой();
  }

  /**
   * Closes the Читака and releases any resources associated with the Читака.
   */
  проц закрой() {
  }

  /**
   * Reads the следщ character from the ввод поток and advances the character позиция by one character.
   * Возвращает: The следщ character from the ввод поток, or сим.init if no more characters are available.
   */
  сим читай() {
    return сим.init;
  }

  /**
   * Читака a maximum of счёт characters from the ввод поток and writes the данные to буфер, beginning at индекс.
   * Параметры:
   *   буфер = A character array with the значения between индекс and (индекс + счёт - 1) replaces by the characters _read from the ввод поток.
   *   индекс = The place in буфер at which to begin writing.
   *   счёт = The maximum число of character to _read.
   * Возвращает: The число of characters that have been _read.
   */
  цел читай(сим[] буфер, цел индекс, цел счёт) {
    цел n = 0;
    do {
      сим ch = читай();
      if (ch == сим.init)
        break;
      буфер[индекс + n++] = ch;
    } while (n < счёт);
    return n;
  }

  /**
   * Reads all characters from the текущ позиция to the end of the Читака and returns them as a ткст.
   * Возвращает: A ткст containing all characters.
   */
  ткст читайДоКон() {
    ткст s;
    сим[] буфер = new сим[4096];
    цел len;
    while ((len = читай(буфер, 0, буфер.length)) != 0) {
      s ~= буфер[0 .. len];
    }
    return s;
  }

}

/**
 * Represents a writer that can пиши a sequential series of characters.
 */
abstract class Писака {

  protected сим[] newLine_ = [ '\r', '\n' ];

  protected this() {
  }

  ~this() {
    закрой();
  }

  /**
   * Closes the текущ writer and releases any resources associated with the writer.
   */
  проц закрой() {
  }

  /**
   * Clears all buffers for the текущ writer causing buffered данные to be written to the underlying device.
   */
  проц слей() {
  }

  /**
   * Writes the text representation of the specified значение or значения to the поток.
   */
  проц пиши(...) {
  }

  /**
   * Writes the text representation of the specified значение or значения, followed by a line terminator, to the поток.
   */
  проц пишинс(...) {
    пиши(_arguments, _argptr);
    пиши(новСтрока);
  }

  /**
   * Gets or sets the line terminator used by the текущ writer.
   */
  проц новСтрока(ткст значение) {
    if (значение == null)
      значение = "\r\n";
    version(D_Version2) {
      newLine_ = cast(сим[])значение.idup;
    }
    else {
      newLine_ = значение.dup;
    }
  }

  /// ditto
  ткст новСтрока() {
    version(D_Version2) {
      return newLine_.idup;
    }
    else {
      return newLine_.dup;
    }
  }

  /**
   * Gets the _encoding in which the вывод is written.
   */
  abstract Кодировка кодировка();

}

private проц resolveArgList(ref TypeInfo[] арги, ref va_list argptr, out ткст format) {
  if (арги.length == 2 && арги[0] == typeid(TypeInfo[]) && арги[1] == typeid(va_list)) {
    арги = va_arg!(TypeInfo[])(argptr);
    argptr = *cast(va_list*)argptr;

    if (арги.length > 1 && арги[0] == typeid(ткст)) {
      format = va_arg!(ткст)(argptr);
      арги = арги[1 .. $];
    }

    if (арги.length == 2 && арги[0] == typeid(TypeInfo[]) && арги[1] == typeid(va_list)) {
      resolveArgList(арги, argptr, format);
    }
  }
  else if (арги.length > 1 && арги[0] == typeid(ткст)) {
    format = va_arg!(ткст)(argptr);
    арги = арги[1 .. $];
  }
}

/**
 * Реализует a Писака for writing information to a ткст.
 */
class ПисакаТекста : Писака {

  private ткст sb_;
  private Кодировка кодировка_;

  this() {
  }

  override проц пиши(...) {
    auto арги = _arguments;
    auto argptr = _argptr;
    ткст fmt = null;
    resolveArgList(арги, argptr, fmt);

    if (fmt == null && арги.length == 1 && арги[0] == typeid(ткст)) {
      sb_ ~= va_arg!(ткст)(argptr);
    }
    else if (арги.length > 0) {
      пиши(format((fmt == null) ? "{0}" : fmt, арги, argptr));
    }
  }

  /**
   * Returns a ткст containing the characters written to so far.
   */
  override ткст вТкст() {
    return sb_;
  }

  override Кодировка кодировка() {
    if (кодировка_ is null)
      кодировка_ = new КодировкаУтф8;
    return кодировка_;
  }

}

/**
 * Реализует a Писака for writing characters to a поток in a particular кодировка.
 */
class ПисакаПотока : Писака {

  private Поток stream_;
  private Кодировка кодировка_;
  private бул closable_ = true;

  /**
   * Initializes a new экземпляр for the specified _stream, используя the specified _encoding.
   * Параметры:
   *   поток = The _stream to пиши to.
   *   кодировка = The character _encoding to use.
   */
  this(Поток поток, Кодировка кодировка = Кодировка.УТФ8) {
    stream_ = поток;
    кодировка_ = кодировка;
  }

  /*package*/ this(Поток поток, Кодировка кодировка, бул closable) {
    this(поток, кодировка);
    closable_ = closable;
  }

  override проц закрой() {
    if (closable_ && stream_ !is null) {
      try {
        stream_.закрой();
      }
      finally {
        stream_ = null;
      }
    }
  }

  override проц пиши(...) {
    auto арги = _arguments;
    auto argptr = _argptr;
    ткст fmt = null;
    resolveArgList(арги, argptr, fmt);

    if (fmt == null && арги.length == 1 && арги[0] == typeid(ткст)) {
      ббайт[] байты = кодировка_.кодируй(va_arg!(ткст)(argptr));
      stream_.пиши(байты);
    }
    else if (арги.length > 0) {
      пиши(format((fmt == null) ? "{0}" : fmt, арги, argptr));
    }
  }

  /**
   * Gets the underlying поток.
   */
  Поток потокОснова() {
    return stream_;
  }

  override Кодировка кодировка() {
    return кодировка_;
  }

}

private class ПотокКонсоль : Поток {

  private Укз handle_;

  /*package*/ this(Укз указатель) {
    handle_ = указатель;
  }

  override проц закрой() {
  }

  override проц слей() {
  }

  override бдол сместись(дол смещение, ППозКурсора origin) {
    return 0;
  }

  protected override бцел читайБлок(ук буфер, бцел размер) {
    бцел bytesRead = 0;
    ReadFile(handle_, буфер, размер, bytesRead, null);
    return bytesRead;
  }

  protected override бцел пишиБлок(in ук буфер, бцел размер) {
    бцел bytesWritten = 0;
    WriteFile(handle_, буфер, размер, bytesWritten, null);
    return bytesWritten;
  }

}

/// Specifies constants that define background and foreground цвета for the console.
enum ПЦветКонсоли {
  Black,        /// The цвет black.
  DarkBlue,     /// The цвет dark blue.
  DarkGreen,    /// The цвет dark green.
  DarkCyan,     /// The цвет dark cyan.
  DarkRed,      /// The цвет dark red.
  DarkMagenta,  /// The цвет dark magenta.
  DarkYellow,   /// The цвет dark yellow.
  Gray,         /// The цвет gray.
  DarkGray,     /// The цвет dark gray.
  Blue,         /// The цвет blue.
  Green,        /// The цвет green.
  Cyan,         /// The цвет cyan.
  Red,          /// The цвет red.
  Magenta,      /// The цвет magenta.
  Yellow,       /// The цвет yellow.
  White         /// The цвет white.
}

/**
 * Represents the standard вывод and ошибка streams for console applications.
 */
struct Консоль {

  private static Писака out_;
  private static Писака err_;

  private static бул defaultColorsRead_;
  private static ббайт defaultColors_;

  private static Укз outputHandle_;

  static ~this() {
    out_ = null;
    err_ = null;
  }

  /**
   * Writes the text representation of the specified значение or значения to the standard вывод поток.
   */
  static проц пиши(...) {
    Консоль.вывод.пиши(_arguments, _argptr);
  }

  /**
   * Writes the text representation of the specified значение or значения, followed by the текущ line terminator, to the standard вывод поток.
   */
  static проц пишинс(...) {
    Консоль.вывод.пишинс(_arguments, _argptr);
  }

  /**
   * Gets the standard _output поток.
   */
  static Писака вывод() {
    synchronized {
      if (out_ is null) {
        Поток s = new ПотокКонсоль(GetStdHandle(STD_OUTPUT_HANDLE));
        out_ = new ПисакаПотока(s, Кодировка.дай(GetConsoleOutputCP()), false);
      }
      return out_;
    }
  }

  /**
   * Sets the вывод property to the specified Писака object.
   * Параметры: newOutput = The new standard вывод.
   */
  static проц устВывод(Писака newOutput) {
    synchronized {
      out_ = newOutput;
    }
  }

  /**
   * Gets or sets the кодировка the console uses to пиши вывод.
   * Параметры: значение = The кодировка used to пиши console вывод.
   */
  static проц кодировкаВывода(Кодировка значение) {
    if (значение is null)
      throw new ИсклНулевогоАргумента("значение");

    synchronized {
      out_ = null;
      SetConsoleOutputCP(cast(бцел)значение.кодСтр);
    }
  }
  /// ditto
  static Кодировка кодировкаВывода() {
    return Кодировка.дай(GetConsoleOutputCP());
  }

  /**
   * Gets the standard _error вывод поток.
   */
  static Писака ошибка() {
    synchronized {
      if (err_ is null) {
        Поток s = new ПотокКонсоль(GetStdHandle(STD_ERROR_HANDLE));
        err_ = new ПисакаПотока(s, Кодировка.дай(GetConsoleOutputCP()), false);
      }
      return err_;
    }
  }

  /**
   * Sets the ошибка property to the specified Писака object.
   * Параметры: newError = The new standard ошибка вывод.
   */
  static проц устОшибку(Писака newError) {
    synchronized {
      err_ = newError;
    }
  }

  /**
   * Clears the console буфер and corresponding console window of display information.
   */
  static проц сотри() {
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    if (дайИнфоБуф(csbi)) {
      COORD coord;
      бцел written;
      if (FillConsoleOutputCharacter(укзВывода, ' ', csbi.dwSize.X * csbi.dwSize.Y, coord, written)) {
        if (FillConsoleOutputAttribute(укзВывода, csbi.wAttributes, csbi.dwSize.X * csbi.dwSize.Y, coord, written))
          SetConsoleCursorPosition(укзВывода, coord);
      }
    }
  }

  /**
   * Plays the sound of a _beep of a specified _frequency and _duration through the console speaker.
   * Параметры:
   *   частота = The _frequency of the _beep, ranging from 37 to 32767 hertz.
   *   продолжительность = The _duration of the _beep measured in миллисекунды.
   */
  static проц бип(цел частота = 800, цел продолжительность = 200) {
    .Beep(cast(бцел)частота, cast(бцел)продолжительность);
  }

  /**
   * Gets or sets the _title to display in the console _title bar.
   * Параметры: значение = The text to be displayed in the _title bar of the console.
   */
  static проц титул(ткст значение) {
    SetConsoleTitle(значение.вУтф16н());
  }
  /// ditto
  static ткст титул() {
    шим[24500] буфер;
    бцел len = GetConsoleTitle(буфер.ptr, буфер.length);
    return .вУтф8(буфер.ptr, 0, len);
  }

  /**
   * Gets or sets the background цвет of the console.
   * Параметры: значение = The цвет that appears behind each character.
   */
  static проц цветФона(ПЦветКонсоли значение) {
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    if (дайИнфоБуф(csbi)) {
      бкрат attribute = cast(бкрат)(csbi.wAttributes & ~BACKGROUND_MASK);
      attribute |= cast(бкрат)значение << 4;
      SetConsoleTextAttribute(укзВывода, attribute);
    }
  }
  /// ditto
  static ПЦветКонсоли цветФона() {
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    if (!дайИнфоБуф(csbi))
      return ПЦветКонсоли.Black;
    return cast(ПЦветКонсоли)((csbi.wAttributes & BACKGROUND_MASK) >> 4);
  }

  /**
   * Gets or sets the foreground цвет of the console.
   * Параметры: значение = The цвет of each character that is displayed.
   */
  static проц цветПП(ПЦветКонсоли значение) {
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    if (дайИнфоБуф(csbi)) {
      бкрат attribute = cast(бкрат)(csbi.wAttributes & ~FOREGROUND_MASK);
      attribute |= cast(бкрат)значение;
      SetConsoleTextAttribute(укзВывода, attribute);
    }
  }
  /// ditto
  static ПЦветКонсоли цветПП() {
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    if (!дайИнфоБуф(csbi))
      return ПЦветКонсоли.Gray;
    return cast(ПЦветКонсоли)(csbi.wAttributes & FOREGROUND_MASK);
  }

  /**
   * Sets the foreground and background console цвета to their defaults.
   */
  static проц сбросьЦвет() {
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    if (дайИнфоБуф(csbi))
      SetConsoleTextAttribute(укзВывода, defaultColors_);
  }

  /**
   * Sets the позиция of the cursor.
   * Параметры:
   *   лево = The column позиция.
   *   верх = The row позиция.
   */
  static проц устПозКурсора(цел лево, цел верх) {
    SetConsoleCursorPosition(укзВывода, COORD(cast(крат)лево, cast(крат)верх));
  }

  /**
   * Gets or sets the column позиция of the cursor.
   */
  static проц курсорЛево(цел значение) {
    устПозКурсора(значение, курсорВерх);
  }
  /// ditto
  static цел курсорЛево() {
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    дайИнфоБуф(csbi);
    return csbi.dwCursorPosition.X;
  }

  /**
   * Gets or sets the row позиция of the cursor.
   */
  static проц курсорВерх(цел значение) {
    устПозКурсора(курсорЛево, значение);
  }
  /// ditto
  static цел курсорВерх() {
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    дайИнфоБуф(csbi);
    return csbi.dwCursorPosition.Y;
  }

  /**
   * Gets or sets the лево позиция of the console window area relative to the screen буфер.
   * Параметры: значение = The лево console window позиция measured in columns.
   */
  static проц окноЛево(цел значение) {
    устПозОкна(значение, окноВерх);
  }
  /// ditto
  static цел окноЛево() {
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    дайИнфоБуф(csbi);
    return csbi.srWindow.Left;
  }

  /**
   * Gets or sets the верх позиция of the console window area relative to the screen буфер.
   * Параметры: значение = The верх console window позиция measured in rows.
   */
  static проц окноВерх(цел значение) {
    устПозОкна(окноЛево, значение);
  }
  /// ditto
  static цел окноВерх() {
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    дайИнфоБуф(csbi);
    return csbi.srWindow.Top;
  }

  /**
   * Sets the позиция of the console window relative to the screen буфер.
   * Параметры:
   *   лево = The column позиция of the upper-лево corner.
   *   верх = The row позиция of the upper-лево corner.
   */
  static проц устПозОкна(цел лево, цел верх) {
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    дайИнфоБуф(csbi);

    SMALL_RECT прям = csbi.srWindow;
    прям.Bottom -= прям.Top - верх;
    прям.Right -= прям.Left - лево;
    прям.Left = cast(крат)лево;
    прям.Top = cast(крат)верх;

    SetConsoleWindowInfo(укзВывода, 1, прям);
  }

  /**
   * Sets the размер of the console window.
   * Параметры:
   *   ширина = The _width of the console window measured in columns.
   *   высота = The _height of the console window measured in rows.
   */
  static проц устРазмОкна(цел ширина, цел высота) {
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    дайИнфоБуф(csbi);

    бул resizeBuffer;

    COORD размер = COORD(csbi.dwSize.X, csbi.dwSize.Y);
    if (csbi.dwSize.X < csbi.srWindow.Left + ширина) {
      размер.X = cast(крат)(csbi.srWindow.Left + ширина);
      resizeBuffer = true;
    }
    if (csbi.dwSize.Y < csbi.srWindow.Top + высота) {
      размер.Y = cast(крат)(csbi.srWindow.Top + высота);
      resizeBuffer = true;
    }
    if (resizeBuffer)
      SetConsoleScreenBufferSize(укзВывода, размер);

    SMALL_RECT прям = csbi.srWindow;
    прям.Bottom = cast(крат)(прям.Top + высота - 1);
    прям.Right = cast(крат)(прям.Left + ширина - 1);
    if (!SetConsoleWindowInfo(укзВывода, 1, прям)) {
      if (resizeBuffer)
        SetConsoleScreenBufferSize(укзВывода, csbi.dwSize);
    }
  }

  /**
   * Gets or sets the ширина of the console window.
   * Параметры: значение = The ширина of the console window measured in columns.
   */
  static проц ширинаОкна(цел значение) {
    устРазмОкна(значение, высотаОкна);
  }
  /// ditto
  static цел ширинаОкна() {
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    дайИнфоБуф(csbi);
    return csbi.srWindow.Right - csbi.srWindow.Left + 1;
  }

  /**
   * Gets or sets the высота of the console window.
   * Параметры: значение = The высота of the console window measured in rows.
   */
  static проц высотаОкна(цел значение) {
    устРазмОкна(ширинаОкна, значение);
  }
  /// ditto
  static цел высотаОкна() {
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    дайИнфоБуф(csbi);
    return csbi.srWindow.Bottom - csbi.srWindow.Top + 1;
  }

  private static бул дайИнфоБуф(out CONSOLE_SCREEN_BUFFER_INFO csbi) {
    Укз h = укзВывода;
    if (h == INVALID_HANDLE_VALUE)
      return false;

    if (GetConsoleScreenBufferInfo(h, csbi)) {
      if (!defaultColorsRead_) {
        defaultColors_ = cast(ббайт)(csbi.wAttributes & (FOREGROUND_MASK | BACKGROUND_MASK));
        defaultColorsRead_ = true;
      }
      return true;
    }

    return false;
  }

  private static Укз укзВывода() {
    if (outputHandle_ == Укз.init)
      outputHandle_ = GetStdHandle(STD_OUTPUT_HANDLE);
    return outputHandle_;
  }

}