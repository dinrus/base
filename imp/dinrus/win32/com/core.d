/**
 * Обеспечивает поддержку COM (Component Объект Model).
 *
 * See $(LINK2 http://msdn.microsoft.com/en-us/library/ms690233(VS.85).aspx, MSDN) for a glossary of terms.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.com.core;

public import win32.base.core: ИсклНеРеализовано, ИсклПриведенияКТипу, ИсклНулевойССылки, ИсклНесанкционированныйДоступ, ИсклАргумента, ИсклНулевогоАргумента, ИсклФормата, ИсклНеправильнОперации;

import win32.base.native: FACILITY_ITF, MAKE_SCODE,COAUTHINFO, SEVERITY_ERROR, SEVERITY_SUCCESS, FILETIME, Укз, FORMAT_MESSAGE_FROM_SYSTEM, FORMAT_MESSAGE_IGNORE_INSERTS, FormatMessage, SECURITY_DESCRIPTOR, POINT, RECT, GetThreadLocale, вЮ8, вЮ16н, FormatMessageW, InterlockedIncrement, InterlockedDecrement, HeapAlloc, GetProcessHeap, HeapFree,MAX_PATH, GetModuleFileName;

import base, stdrus, exception, cidrus, tpl.stream, tpl.traits, tpl.typetuple, tpl.args;

static this() {
  startup();
}

static ~this() {
  shutdown();
}

enum /* HRESULT */ {
  S_OK            = 0x0,
  S_FALSE         = 0x1,

  E_NOTIMPL       = 0x80004001,
  E_NOINTERFACE   = 0x80004002,
  E_POINTER       = 0x80004003,
  E_ABORT         = 0x80004004,
  E_FAIL          = 0x80004005,

  E_ACCESSDENIED  = 0x80070005,
  E_OUTOFMEMORY   = 0x8007000E,
  E_INVALIDARG    = 0x80070057,
  
  У_ОК				= S_OK,
  У_ЛОЖЬ			= S_FALSE,
  
  О_НЕРЕАЛИЗ		= E_NOTIMPL,
  О_НЕИНТЕРФЕЙС		= E_NOINTERFACE,
  О_УКАЗАТЕЛЬ		= E_POINTER,
  О_АБОРТ			= E_ABORT,
  О_НЕУДАЧА			= E_FAIL,
  О_НЕТДОСТУПА		= E_ACCESSDENIED,
  О_ВНЕПАМЯТИ		= E_OUTOFMEMORY,
  О_НЕВЕРНАРГ		= E_INVALIDARG,
}

/**
 * Определяет, прошла ли операция успешно.
 */
бул УДАЧНО(цел статус) { return статус >= 0; }

/**
 * Определяет, была ли операция неудачной.
 */
бул НЕУДАЧНО(цел статус) { return статус < 0; }

/**
 * The exception thrown when an unrecognized HRESULT is returned from a COM operation.
 */
class КОМИскл : Exception {

  цел errorCode_;

  /**
   * Initializes a new экземпляр with a specified ошибка code.
   * Параметры: кодОш = The ошибка code (HRESULT) значение associated with this exception.
   */
  this(цел кодОш) {
    super(дайОшСооб(кодОш));
    errorCode_ = кодОш;
  }

  /**
   * Initializes a new экземпляр with a specified сообщение and ошибка code.
   * Параметры:
   *   сообщение = The ошибка _message that explains this exception.
   *   кодОш = The ошибка code (HRESULT) значение associated with this exception.
   */
  this(ткст сообщение, цел кодОш) {
    super(сообщение);
    errorCode_ = кодОш;
  }

  /**
   * Gets the HRESULT of the ошибка.
   * Возвращает: The HRESULT of the ошибка.
   */
  цел кодОш() {
    return errorCode_;
  }

  private static ткст дайОшСооб(цел кодОш) {
    шим[256] буфер;
    бцел рез = FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS, null, кодОш, 0, буфер.ptr, буфер.length + 1, null);
    if (рез != 0) {
      ткст s = .вЮ8(буфер[0 .. рез]);

      // Remove trailing characters
      while (рез > 0) {
        сим c = s[рез - 1];
        if (c > ' ' && c != '.')
          break;
        рез--;
      }

      return фм("%s. (Исключение из HRESULT: 0x%08X)", s[0 .. рез], cast(бцел)кодОш);
    }

    return фм("Неизвестная ошибка (0x%08X)", cast(бцел)кодОш);
  }

}

/// Converts an HRESULT ошибка code to a corresponding Exception object.
Exception exceptionForHR(цел кодОш) {
  switch (кодОш) {
    case E_NOTIMPL:
      return new ИсклНеРеализовано;
    case E_NOINTERFACE:
      return new ИсклПриведенияКТипу;
    case E_POINTER:
      return new ИсклНулевойССылки;
    case E_ACCESSDENIED:
      return new ИсклНесанкционированныйДоступ;
    case E_OUTOFMEMORY:
      return new OutOfMemoryException;
	  case E_INVALIDARG:
      return new ИсклАргумента;
    default:
  }
  return new КОМИскл(кодОш);
}

/// Throwns an exception with a specific failure HRESULT значение.
проц throwExceptionForHR(цел кодОш)
in {
  assert(НЕУДАЧНО(кодОш));
}
body {
  if (НЕУДАЧНО(кодОш))
    throw exceptionForHR(кодОш);
}

/**
 * Представляет глобальный уникальный идентификатор.
 */
alias GUID ГУИД;
struct GUID {

  // Slightly different layout from the Windows SDK, but means we can use fewer brackets
  // when defining GUIDs.
  бцел a;
  бкрат b, c;
  ббайт d, e, f, g, h, i, j, k;

  /**
   * GUID, все значения которого являются нулями.
   */
  static GUID пустой = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };

  /**
   * Инициализует _новый экземпляр, используя заданные целые и байты.
   * Параметры:
   *   a = Первые 4 байта.
   *   b = Следующие 2 байта.
   *   c = Следующие 2 байта.
   *   d = Следующий байт.
   *   e = Следующий байт.
   *   f = Следующий байт.
   *   g = Следующий байт.
   *   h = Следующий байт.
   *   i = Следующий байт.
   *   j = Следующий байт.
   *   k = Следующий байт.
   * Возвращает: Результирующий GUID.
   */
  static GUID opCall(бцел a, бкрат b, бкрат c, ббайт d, ббайт e, ббайт f, ббайт g, ббайт h, ббайт i, ббайт j, ббайт k) {
    GUID сам;
    сам.a = a, сам.b = b, сам.c = c, сам.d = d, сам.e = e, сам.f = f, сам.g = g, сам.h = h, сам.i = i, сам.j = j, сам.k = k;
    return сам;
  }

  /**
   * Initializes _a new экземпляр используя the specified integers and байт array.
   * Параметры:
   *   a = Первые 4 байта.
   *   b = Следующие 2 байта.
   *   c = Следующие 2 байта.
   *   d = The remaining 8 байты.
   * Возвращает: The resulting GUID.
   * Выводит исключение: IllegalArgumentException if d is not 8 байты дол.
   */
  static GUID opCall(бцел a, бкрат b, бкрат c, ббайт[] d) {
    if (d.length != 8)
      throw new ИсклАргумента("Byte array for GUID must be 8 байты дол.");

    GUID сам;
    сам.a = a, сам.b = b, сам.c = c, сам.d = d[0], сам.e = d[1], сам.f = d[2], сам.g = d[3], сам.h = d[4], сам.i = d[5], сам.j = d[6], сам.k = d[7];
    return сам;
  }

  /**
   * Initializes a new экземпляр используя the значение represented by the specified ткст.
   * Параметры: s = A ткст containing a GUID in groups of 8, 4, 4, 4 and 12 цифры with hyphens between the groups. The GUID can optionally be enclosed in braces.
   * Возвращает: The resulting GUID.
   */
  static GUID opCall(ткст s) {
    
    бдол разбор(ткст s) {

      бул hexToInt(сим c, out бцел рез) {
        if (c >= '0' && c <= '9') рез = c - '0';
        else if (c >= 'A' && c <= 'F') рез = c - 'A' + 10;
        else if (c >= 'a' && c <= 'f') рез = c - 'a' + 10;
        else рез = -1;
        return (cast(цел)рез >= 0);
      }

      бдол рез;
      бцел значение, индекс;
      while (индекс < s.length && hexToInt(s[индекс], значение)) {
        рез = рез * 16 + значение;
        индекс++;
      }
      return рез;
    }

    s = s.убери();

    if (s[0] == '{') {
      s = s[1 .. $];
      if (s[$ - 1] == '}')
        s = s[0 .. $ - 1];
    }

    if (s[0] == '[') {
      s = s[1 .. $];
      if (s[$ - 1] == ']')
        s = s[0 .. $ - 1];
    }

    if (s.найди('-') == -1)
      throw new ИсклФормата("Unrecognised GUID format.");

    GUID сам;
    сам.a = cast(бцел)разбор(s[0 .. 8]);
    сам.b = cast(бкрат)разбор(s[9 .. 13]);
    сам.c = cast(бкрат)разбор(s[14 .. 18]);
    бцел m = cast(бцел)разбор(s[19 .. 23]);
    сам.d = cast(ббайт)(m >> 8);
    сам.e = cast(ббайт)m;
    бдол n = разбор(s[24 .. $]);
    m = cast(бцел)(n >> 32);
    сам.f = cast(ббайт)(m >> 8);
    сам.g = cast(ббайт)m;
    m = cast(бцел)n;
    сам.h = cast(ббайт)(m >> 24);
    сам.i = cast(ббайт)(m >> 16);
    сам.j = cast(ббайт)(m >> 8);
    сам.k = cast(ббайт)m;
    return сам;
  }

  /**
   * Initializes a new экземпляр of the GUID struct.
   */
  static GUID create() {
    GUID сам;

    цел hr = CoCreateGuid(сам);
    if (НЕУДАЧНО(hr))
      throw exceptionForHR(hr);

    return сам;
  }

  static ГУИД создай(){ return cast(ГУИД) create(); }
  /**
   * Returns a значение indicating whether two instances represent the same значение.
   * Параметры: другой = A GUID to сравни to this экземпляр.
   * Возвращает: true if другой is equal to this экземпляр; otherwise, false.
   */
  бул opEquals(GUID другой) {
    return a == другой.a
      && b == другой.b
      && c == другой.c
      && d == другой.d
      && e == другой.e
      && f == другой.f
      && g == другой.g
      && h == другой.h
      && i == другой.i
      && j == другой.j
      && k == другой.k;
  }

  /**
   * Compares this экземпляр to a specified GUID and returns an indication of their relative значения.
   * Параметры: другой = A GUID to сравни to this экземпляр.
   * Возвращает: A число indicating the relative значения of this экземпляр and другой.
   */
  цел opCmp(GUID другой) {
    if (a != другой.a)
      return (a < другой.a) ? -1 : 1;
    if (b != другой.b)
      return (b < другой.b) ? -1 : 1;
    if (c != другой.c)
      return (c < другой.c) ? -1 : 1;
    if (d != другой.d)
      return (d < другой.d) ? -1 : 1;
    if (e != другой.e)
      return (e < другой.e) ? -1 : 1;
    if (f != другой.f)
      return (f < другой.f) ? -1 : 1;
    if (g != другой.g)
      return (g < другой.g) ? -1 : 1;
    if (h != другой.h)
      return (h < другой.h) ? -1 : 1;
    if (i != другой.i)
      return (i < другой.i) ? -1 : 1;
    if (j != другой.j)
      return (j < другой.j) ? -1 : 1;
    if (k != другой.k)
      return (k < другой.k) ? -1 : 1;
    return 0;
  }

  /**
   * Returns a ткст representation of the значение of this экземпляр in registry format.
   * Возвращает: A ткст formatted in this pattern: {xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx} where the GUID is represented as a series of lowercase hexadecimal цифры in groups of 8, 4, 4, 4 and 12 and separated by hyphens.
   */
   
  ткст вТкст() {
    return вТкст("D");
  }

  /// ditto
  ткст вТкст(ткст format) {

    проц hexToString(ref сим[] s, ref бцел индекс, бцел a, бцел b) {

      сим hexToChar(бцел a) {
        a = a & 0x0F;
        return cast(сим)((a > 9) ? a - 10 + 0x61 : a + 0x30);
      }

      s[индекс++] = hexToChar(a >> 4);
      s[индекс++] = hexToChar(a);
      s[индекс++] = hexToChar(b >> 4);
      s[индекс++] = hexToChar(b);
    }

    if (format == null)
      format = "D";

    сим[] s;
    бцел индекс = 0;
    if (format == "D" || format == "d")
      s = new сим[36];
    else if (format == "P" || format == "p") {
      s = new сим[38];
      s[индекс++] = '{';
      s[$ - 1] = '}';
    }

    hexToString(s, индекс, a >> 24, a >> 16);
    hexToString(s, индекс, a >> 8, a);
    s[индекс++] = '-';
    hexToString(s, индекс, b >> 8, b);
    s[индекс++] = '-';
    hexToString(s, индекс, c >> 8, c);
    s[индекс++] = '-';
    hexToString(s, индекс, d, e);
    s[индекс++] = '-';
    hexToString(s, индекс, f, g);
    hexToString(s, индекс, h, i);
    hexToString(s, индекс, j, k);

    return cast(ткст)s;
  }

  /**
   * Выводит хеш-код для данного экземпляра.
   * Возвращает: The hash code for this экземпляр.
   */
  бцел вХэш() {
    return a ^ ((b >> 16) | c) ^ ((f << 24) | k);
  }

}



alias GUID Guid;
alias Guid Гуид;

/**
 * Выводит ProgID для данного идентификатора класса (CLSID).
 */
ткст progIdFromClsid(Guid clsid) {
  шим* str;
  ProgIDFromCLSID(clsid, str);
  return вЮ8(str[0 .. wcslen(str)]);
}

ткст прогИдИзКлсид(Гуид клсид){return cast(ткст) progIdFromClsid(cast(Guid) клсид);}

/**
 * Retrieves the class identifier (CLSID) for a given ProgID.
 */
Guid clsidFromProgId(ткст progId) {
  Guid clsid;
  CLSIDFromProgID(progId.вЮ16н(), clsid);
  return clsid;
}

Гуид клсидИзПрогИд(ткст прогИд){return cast(Гуид) clsidFromProgId(cast(ткст) прогИд);}

extern(Windows)
цел CoCreateGuid(out GUID pGuid);

цел СоздайГуидКо(out ГУИД уГуид){return cast(цел) CoCreateGuid(cast(GUID) уГуид);}

/**
 * Ассоциирует ГУИД с интерфейсом.
 * Параметры: g = Строка, представляющая ГУИД в нормальном реестровом формате с или без разграничителей { }.
 * Примеры:
 * ---
 * interface IXMLDOMDocument2 : IDispatch {
 *   mixin(ууид("2933bf95-7b36-11d2-b20e-00c04f983e60"));
 * }
 *
 * // Раскрывается в следующий код:
 * //
 * // interface IXMLDOMDocument2 : IDispatch {
 * //   static GUID IID = { 0x2933bf95, 0x7b36, 0x11d2, 0xb2, 0x0e, 0x00, 0xc0, 0x4f, 0x98, 0x3e, 0x60 };
 * // }
 * ---
 */
ткст ууид(ткст g) {
  if (g.length == 38) {
    assert(g[0] == '{' && g[$-1] == '}', "Неправильный формат для GUID.");
    return ууид(g[1..$-1]);
  }
  else if (g.length == 36) {
    assert(g[8] == '-' && g[13] == '-' && g[18] == '-' && g[23] == '-', "Incorrect format for GUID.");
    return "static const GUID IID = { 0x" ~ g[0..8] ~ ",0x" ~ g[9..13] ~ ",0x" ~ g[14..18] ~ ",0x" ~ g[19..21] ~ ",0x" ~ g[21..23] ~ ",0x" ~ g[24..26] ~ ",0x" ~ g[26..28] ~ ",0x" ~ g[28..30] ~ ",0x" ~ g[30..32] ~ ",0x" ~ g[32..34] ~ ",0x" ~ g[34..36] ~ " };";
  }
  else assert(false, "Неправильный формат для GUID.");
}

/**
 * Извлекает ГУИД, связанный с указанной переменной или типом.
 * Примеры:
 * ---
 * import win32.com.core, 
 *   stdrus;
 *
 * проц main() {
 *   скажифнс("ГУИДом IXMLDOMDocument2 является %s", uuidof!(IXMLDOMDocument2));
 * }
 *
 * // Производит:
 * // ГУИДом IXMLDOMDocument2 является {2933bf95-7b36-11d2-b20e-00c04f983e60}
 * ---
 */
 alias uuidof ууид_у;
 
template uuidof(alias T) {
  static if (is(typeof(T)))
    const GUID uuidof = uuidofT!(typeof(T));
  else
    const GUID uuidof = uuidofT!(T);
}

/* Conflicts with the definition above.
template uuidof(T) {
  const GUID uuidof = uuidofT!(T);
}*/
alias uuidofT ууид_у_Т;

template uuidofT(T : T) {
  static if (is(typeof(mixin("IID_" ~ T.stringof))))
    const GUID uuidofT = mixin("IID_" ~ T.stringof); // e.g., IID_IShellFolder
  else static if (is(typeof(mixin("CLSID_" ~ T.stringof))))
    const GUID uuidofT = mixin("CLSID_" ~ T.stringof); // e.g., CLSID_Shell
  else static if (is(typeof(T.IID)))
    const GUID uuidofT = T.IID;
  else
    static assert(false, "Никакого GUID не было ассоциировано с '" ~ T.stringof ~ "'.");
}

alias retval возврзнач;

ук* retval(T)(out T ppv)
in {
  assert(&ppv != null);
}
body {
  return cast(ук*)&ppv;
}
//Флаги, используемые БЕЗОПМАСом (features)
enum : бкрат {
  FADF_AUTO = 0x1,
  FADF_STATIC = 0x2,
  FADF_EMBEDDED = 0x4,
  FADF_FIXEDSIZE = 0x10,
  FADF_RECORD = 0x20,
  FADF_HAVEIID = 0x40,
  FADF_HAVEVARTYPE = 0x80,
  FADF_BSTR = 0x100,
  FADF_UNKNOWN = 0x200,
  FADF_DISPATCH = 0x400,
  FADF_VARIANT = 0x800,
  FADF_RESERVED = 0xF008
}

alias SAFEARRAYBOUND ГРАНБЕЗОПМАСА;
struct SAFEARRAYBOUND {

alias cElements члоЭлтов;
alias lLbound нижГраница;

  бцел cElements;
  цел lLbound;
}

/// Представляет массив элементов.
alias SAFEARRAY БЕЗОПМАС;
struct SAFEARRAY {

alias cDims члоИзм;
alias fFeatures фичи;
alias cbElements размЭлта;
alias cLocks счБлк;
alias pvData укНаДан;
alias rgsabound рбмгран;

  бкрат cDims;
  бкрат fFeatures;
  /*
  The fFeatures флаги describe атрибуты of an array that can affect how the array is released. The fFeatures поле describes what тип of данные is stored in the SAFEARRAY and how the array is allocated. This allows freeing the array without referencing its containing variant. The bits are accessed используя the following constants: see line 713
  */
  бцел cbElements;
  бцел cLocks;
  ук pvData;
  SAFEARRAYBOUND[1] rgsabound;
  /*
  The array rgsabound is stored with the лево-most dimension in rgsabound[0] and the право-most dimension in rgsabound[cDims - 1]. If an array was specified in a C-like syntax as a [2][5], it would have two elements in the rgsabound vector. Element 0 has an lLbound of 0 and a cElements of 2. Element 1 has an lLbound of 0 and a cElements of 5.
  */

  /**
   * Инициализует новый экземпляр, используя заданный массив _array.
   * Параметры: array = Элементы, которыми инициализуется данный экземпляр.
   * Возвращает: Указатель на новый экземпляр.
   */
  static SAFEARRAY* opCall(T)(T[] array) {
    auto bound = SAFEARRAYBOUND(array.length);
    auto sa = SafeArrayCreate(VariantType!(T), 1, &bound);

    static if (is(T : ткст)) alias шим* Тип;
    else                       alias T Тип;

    Тип* данные;
    SafeArrayAccessData(sa, retval(данные));
    for (auto i = 0; i < array.length; i++) {
      static if (is(T : ткст)) данные[i] = array[i].toBstr();
      else                       данные[i] = array[i];
    }
    SafeArrayUnaccessData(sa);

    return sa;
  }

  /**
   * Копирует элементы этого БЕЗОПМАСа в новый массив указанного типа.
   * Возвращает: Массив заданного типа с копиями элементов данного БЕЗОПМАСа.
   */
  
  T[] вМассив(T)() {
    цел upperBound, lowerBound;
    SafeArrayGetUBound(this, 1, upperBound);
    SafeArrayGetLBound(this, 1, lowerBound);
    цел счёт = upperBound - lowerBound + 1;

    if (счёт == 0) return null;

    T[] рез = new T[счёт];

    static if (is(T : ткст)) alias шим* Тип;
    else                       alias T Тип;

    Тип* данные;
    SafeArrayAccessData(this, retval(данные));
    for (auto i = lowerBound; i < upperBound + 1; i++) {
      static if (is(T : ткст)) рез[i] = изБткст(данные[i]);
      else                       рез[i] = данные[i];
    }
    SafeArrayUnaccessData(this);

    return рез;
  }

  /**
   * Уничтожает БЕЗОПМАС и все его данные.
   * Заметки: Если в массиве есть объекты, то для каждого из них вызывается Release.
   */  
  проц destroy() {
    version(D_Version2) {
      SafeArrayDestroy(&this);
    }
    else {
      SafeArrayDestroy(this);
    }
  }

  проц разрушь(){ destroy();}
  
  /**
   * Увеличивает на единицу счётчик массива _lock.
   */
  проц lock() {
    version(D_Version2) {
      SafeArrayLock(&this);
    }
    else {
      SafeArrayLock(this);
    }
  }

  проц блокируй(){lock();}
  
  /**
   * Уменьшает счётчик блокировок массива.
   */
  проц unlock() {
    version(D_Version2) {
      SafeArrayUnlock(&this);
    }
    else {
      SafeArrayUnlock(this);
    }
  }

  проц разблокируй(){unlock();}
  
  /**
   * Узнает или устанавливает число элементов в массиве.
   * Параметры: значение = Число элементов.
   */
  проц length(цел значение) {
    auto bound = SAFEARRAYBOUND(значение);
    version(D_Version2) {
      SafeArrayRedim(&this, &bound);
    }
    else {
      SafeArrayRedim(this, &bound);
    }
  }
  
 проц длина(цел знач){length(cast(цел) знач);}
 
  /// ditto
  цел length() {
    цел upperBound, lowerBound;
    version(D_Version2) {
      SafeArrayGetUBound(&this, 1, upperBound);
      SafeArrayGetLBound(&this, 1, lowerBound);
    }
    else {
      SafeArrayGetUBound(this, 1, upperBound);
      SafeArrayGetLBound(this, 1, lowerBound);
    }
    return upperBound - lowerBound + 1;
  }

  цел длина(){return cast(цел) length();}
  
}

extern(Windows):

цел SafeArrayAllocDescriptor(бцел cDims, out SAFEARRAY* ppsaOut);
цел SafeArrayAllocDescriptorEx(бкрат vt, бцел cDims, out SAFEARRAY* ppsaOut);
цел SafeArrayAllocData(SAFEARRAY* psa);
SAFEARRAY* SafeArrayCreate(бкрат vt, бцел cDims, SAFEARRAYBOUND* rgsabound);
SAFEARRAY* SafeArrayCreateEx(бкрат vt, бцел cDims, SAFEARRAYBOUND* rgsabound, ук pvExtra);
цел SafeArrayCopyData(SAFEARRAY* psaSource, SAFEARRAY* psaTarget);
цел SafeArrayDestroyDescriptor(SAFEARRAY* psa);
цел SafeArrayDestroyData(SAFEARRAY* psa);
цел SafeArrayDestroy(SAFEARRAY* psa);
цел SafeArrayRedim(SAFEARRAY* psa, SAFEARRAYBOUND* psaboundNew);
бцел SafeArrayGetDim(SAFEARRAY* psa);
бцел SafeArrayGetElemsize(SAFEARRAY* psa);
цел SafeArrayGetUBound(SAFEARRAY* psa, бцел cDim, out цел plUbound);
цел SafeArrayGetLBound(SAFEARRAY* psa, бцел cDim, out цел plLbound);
цел SafeArrayLock(SAFEARRAY* psa);
цел SafeArrayUnlock(SAFEARRAY* psa);
цел SafeArrayAccessData(SAFEARRAY* psa, ук* ppvData);
цел SafeArrayUnaccessData(SAFEARRAY* psa);
цел SafeArrayGetElement(SAFEARRAY* psa, цел* rgIndices, ук pv);
цел SafeArrayPutElement(SAFEARRAY* psa, цел* rgIndices, ук pv);
цел SafeArrayCopy(SAFEARRAY* psa, out SAFEARRAY* ppsaOut);
цел SafeArrayPtrOfIndex(SAFEARRAY* psa, цел* rgIndices, ук* ppvData);
цел SafeArraySetRecordInfo(SAFEARRAY* psa, IRecordInfo prinfo);
цел SafeArrayGetRecordInfo(SAFEARRAY* psa, out IRecordInfo prinfo);
цел SafeArraySetIID(SAFEARRAY* psa, ref GUID гуид);
цел SafeArrayGetIID(SAFEARRAY* psa, out GUID pguid);
цел SafeArrayGetVartype(SAFEARRAY* psa, out бкрат pvt);
SAFEARRAY* SafeArrayCreateVector(бкрат vt, цел lLbound, бцел cElements);
SAFEARRAY* SafeArrayCreateVectorEx(бкрат vt, цел lLbound, бцел cElements, ук pvExtra);
////////////////////////////////////////////////
extern(Windows)//Русская Версия
{
цел РазместиДескрипторБезопмаса(бцел члоИзм, out БЕЗОПМАС* укнаВыв)
	{
	return cast(цел) SafeArrayAllocDescriptor(cast(бцел) члоИзм, cast(SAFEARRAY*) укнаВыв);
	}

цел РазместиДескрипторБезопмасаДоп(бкрат вт, бцел члоИзм, out БЕЗОПМАС* укнаВыв)
	{
	return cast(цел) SafeArrayAllocDescriptorEx(cast(бкрат) вт, cast(бцел) члоИзм, cast(SAFEARRAY*) укнаВыв);
	}

цел РазместиДанныеБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayAllocData(cast(SAFEARRAY*) бм);
	}

БЕЗОПМАС* СоздайБезопмас(бкрат вт, бцел члоИзм, ГРАНБЕЗОПМАСА* бмГран)
	{
	return cast(БЕЗОПМАС*) SafeArrayCreate(cast(бкрат) вт, cast(бцел) члоИзм, cast(SAFEARRAYBOUND*) бмГран);
	}
	
БЕЗОПМАС* СоздайБезопмасДоп(бкрат вт, бцел члоИзм, ГРАНБЕЗОПМАСА* бмГран, ук вЭкстра)
	{
	return cast(БЕЗОПМАС*) SafeArrayCreateEx(cast(бкрат) вт, cast(бцел) члоИзм, cast(SAFEARRAYBOUND*) бмГран, cast(ук) вЭкстра);
	}
	
цел КопируйДанныеБезопмаса(БЕЗОПМАС* бмИсх, БЕЗОПМАС* бмПрий)
	{
	return cast(цел) SafeArrayCopyData(cast(SAFEARRAY*) бмИсх, cast(SAFEARRAY*) бмПрий);
	}

цел УничтожьДескрипторБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayDestroyDescriptor(cast(SAFEARRAY*) бм);
	}

цел УничтожьДанныеБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayDestroyData(cast(SAFEARRAY*) бм);
	}

цел УничтожьБезопмас(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayDestroy(cast(SAFEARRAY*) бм);
	}

цел ИзмениГраницуБезопмаса(БЕЗОПМАС* бм, ГРАНБЕЗОПМАСА* бмНовГран)
	{
	return cast(цел) SafeArrayRedim(cast(SAFEARRAY*) бм, cast(SAFEARRAYBOUND*) бмНовГран);
	}

бцел ДайЧлоИзмеренийБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(бцел) SafeArrayGetDim(cast(SAFEARRAY*) бм);
	}

бцел ДайРазмерЭлементовБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(бцел) SafeArrayGetElemsize(cast(SAFEARRAY*) бм);
	}

цел ДайВПределБезопмаса(БЕЗОПМАС* бм, бцел члоИзм, out цел вПредел)
	{
	return cast(цел) SafeArrayGetUBound(cast(SAFEARRAY*) бм, cast(бцел) члоИзм, cast(цел) вПредел);
	}

цел ДайНПределБезопмаса(БЕЗОПМАС* бм, бцел члоИзм, out цел нПредел)
	{
	return cast(цел) SafeArrayGetLBound(cast(SAFEARRAY*) бм, cast(бцел) члоИзм, cast(цел) нПредел);
	}

цел БлокируйБезопмас(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayLock(cast(SAFEARRAY*) бм);
	}

цел РазблокируйБезопмас(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayUnlock(cast(SAFEARRAY*) бм);
	}

цел ДоступКДаннымБезопмаса(БЕЗОПМАС* бм, ук* данные)
	{
	return cast(цел) SafeArrayAccessData(cast(SAFEARRAY*) бм, cast(ук*) данные);
	}

цел ОтступОтДаныхБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayUnaccessData(cast(SAFEARRAY*) бм);
	}

цел ДайЭлементБезопмаса(БЕЗОПМАС* бм, уцел индексы, ук в)
	{
	return cast(цел) SafeArrayGetElement(cast(SAFEARRAY*) бм, cast(цел*) индексы, cast(ук) в);
	}
	
цел ПоместиЭлементВБезопмас(БЕЗОПМАС* бм, уцел индексы, ук в)
	{
	return cast(цел) SafeArrayPutElement(cast(SAFEARRAY*) бм, cast(цел*) индексы, cast(ук) в);
	}

цел КопируйБезопмас(БЕЗОПМАС* бм, out БЕЗОПМАС* бмВыв)
	{
	return cast(цел) SafeArrayCopy(cast(SAFEARRAY*) бм, cast(SAFEARRAY*) бмВыв);
	}

цел УкНаИндексБезопмаса(БЕЗОПМАС* бм, уцел индексы, ук* данные)
	{
	return cast(цел) SafeArrayPtrOfIndex(cast(SAFEARRAY*) бм, cast(цел*) индексы, cast(ук*) данные);
	}

цел УстИнфОЗаписиБезопмаса(БЕЗОПМАС* бм, ИИнфОЗаписи инфоз)
	{
	return cast(цел) SafeArraySetRecordInfo(cast(SAFEARRAY*) бм, cast(IRecordInfo) инфоз);
	}

цел ДайИнфОЗаписиБезопмаса(БЕЗОПМАС* бм, out ИИнфОЗаписи инфоз)
	{
	return cast(цел) SafeArrayGetRecordInfo(cast(SAFEARRAY*) бм, cast(IRecordInfo) инфоз);
	}

цел УстановиИИДБезопмаса(БЕЗОПМАС* бм, ref ГУИД гуид)
	{
	return cast(цел) SafeArraySetIID(cast(SAFEARRAY*) бм, cast(GUID) гуид);
	}

цел ДайИИДБезопмаса(БЕЗОПМАС* бм, out ГУИД гуид)
	{
	return cast(цел) SafeArrayGetIID(cast(SAFEARRAY*) бм, cast(GUID) гуид);
	}

цел ДайВартипБезопмаса(БЕЗОПМАС* бм, бкрат вт)
	{
	return cast(цел) SafeArrayGetVartype(cast(SAFEARRAY*) бм, cast(бкрат) вт);
	}

БЕЗОПМАС* СоздайВекторБезопмаса(бкрат вт, цел нПредел, бцел элементы)
	{
	return cast(БЕЗОПМАС*) SafeArrayCreateVector(cast(бкрат) вт, cast(цел) нПредел, cast(бцел) элементы);
	}

БЕЗОПМАС* СоздайВекторБезопмасаДоп(бкрат вт, цел нПредел, бцел элементы, ук экстра)
	{
	return cast(БЕЗОПМАС*) SafeArrayCreateVectorEx(cast(бкрат) вт, cast(цел) нПредел, cast(бцел) элементы, cast(ук) экстра);
	}
}
////////////////////////////////////////////////////////////////////////

extern(D):

version(D_Version2) {
  ткст decimal_operator(ткст имя) {
    return "DECIMAL op" ~ имя ~ "(DECIMAL d) { \n"
      "  DECIMAL рез; \n"
      "  VarDec" ~ имя ~ "(this, d, рез); \n"
      "  return рез; \n"
      "} \n"
      "проц op" ~ имя ~ "Assign" ~ "(DECIMAL d) { \n"
      "  VarDec" ~ имя ~ "(this, d, this); \n"
      "}";
  }
}
else {
  ткст decimal_operator(ткст имя) {
    return "DECIMAL op" ~ имя ~ "(DECIMAL d) { \n"
      "  DECIMAL рез; \n"
      "  VarDec" ~ имя ~ "(*this, d, рез); \n"
      "  return рез; \n"
      "} \n"
      "проц op" ~ имя ~ "Assign" ~ "(DECIMAL d) { \n"
      "  VarDec" ~ имя ~ "(*this, d, *this); \n"
      "}";
  }
}

const ббайт DECIMAL_NEG = 0x80;

DECIMAL dec(ткст s)() {
  return DECIMAL.разбор(s);
}

ДЕСЯТИЧ дес(ткст т)(){return ДЕСЯТИЧ.разбор(т);}

/**
 * Представляет десятичное число в пределах от положительного 79,228,162,514,264,337,593,543,950,335 до отрицательного 79,228,162,514,264,337,593,543,950,335.
 */

alias DECIMAL ДЕСЯТИЧ;
struct DECIMAL {

alias wReserved резерв;
alias min мин;
alias max макс;
alias  minusOne минусОдин;
alias zero ноль;
alias one один;
alias floor кОтрБеск;
alias remainder остаток;
alias добавь сложи;
alias multiply умножь;
alias divide раздели;
alias отриц вОтриц;


  бкрат wReserved;
  ббайт шкала;
  ббайт знак;
  бцел Старш32;
  бцел Младш32;
  бцел Средн32;

  /// Represents the smallest possible значение.
  static DECIMAL min = { 0, 0, DECIMAL_NEG, бцел.max, бцел.max, бцел.max };
  /// Represents the largest possible значение.
  static DECIMAL max = { 0, 0, 0, бцел.max, бцел.max, бцел.max };
  /// Represents -1.
  static DECIMAL minusOne = { 0, 0, DECIMAL_NEG, 0, 1, 0 };
  /// Represents 0.
  static DECIMAL zero = { 0, 0, 0, 0, 0, 0 };
  /// Represents 1.
  static DECIMAL one = { 0, 0, 0, 0, 1, 0 };

  /// Инициализует новый экземпляр.
  static DECIMAL opCall(T)(T значение) {
    DECIMAL сам;

    static if (is(T == бцел))
      VarDecFromUI4(значение, сам);
    else static if (is(T == цел))
      VarDecFromI4(значение, сам);
    else static if (is(T == бдол))
      VarDecFromUI8(значение, сам);
    else static if (is(T == дол))
      VarDecFromI8(значение, сам);
    else static if (is(T == плав))
      VarDecFromR4(значение, сам);
    else static if (is(T == дво))
      VarDecFromR8(значение, сам);
    else static assert(false);

    return сам;
  }

  /// ditto
  static DECIMAL opCall(T = проц)(бцел lo, бцел mid, бцел hi, бул isNegative, ббайт шкала) {
    DECIMAL сам;
    сам.Старш32 = hi, сам.Средн32 = mid, сам.Младш32 = lo, сам.шкала = шкала, сам.знак = isNegative ? DECIMAL_NEG : 0;
    return сам;
  }

  /// Преобразует строковое представление числа в его ДЕСЯТИЧный эквивалент.
  static DECIMAL разбор(ткст s) {
    DECIMAL d;
    VarDecFromStr(s.вЮ16н(), GetThreadLocale(), 0, d);
    return d;
  }

  static DECIMAL абс(DECIMAL d) {
    DECIMAL рез;
    VarDecAbs(d, рез);
    return рез;
  }

  /// Округляет значение до ближайшего или специфичного числа.
  static DECIMAL округли(DECIMAL d, цел decimals = 0) {
    DECIMAL рез;
    VarDecRound(d, decimals, рез);
    return рез;
  }

  /// Округляет значение до ближайшего к отрицательной бесконечности целого.
  static DECIMAL floor(DECIMAL d) {
    DECIMAL рез;
    VarDecInt(d, рез);
    return рез;
  }

  /// Возвращает интегральные числа значения.
  static DECIMAL отсеки(DECIMAL d) {
    DECIMAL рез;
    VarDecFix(d, рез);
    return рез;
  }

  /// Вычисляет остаток после деления двух значений.
  static DECIMAL remainder(DECIMAL d1, DECIMAL d2) {
    if (абс(d1) < абс(d2))
      return d1;

    d1 -= d2;

    DECIMAL dr = отсеки(d1 / d2);
    DECIMAL mr = dr * d2;
    DECIMAL r = d1 - mr;

    if (d1.знак != r.знак && r != cast(DECIMAL)0)
      r += d2;

    return r;
  }

  /// Складывает два значения.
  static DECIMAL добавь(DECIMAL d1, DECIMAL d2) {
    DECIMAL рез;
    VarDecAdd(d1, d2, рез);
    return рез;
  }

  /// Отнимает одно значение от другого.
  static DECIMAL отними(DECIMAL d1, DECIMAL d2) {
    DECIMAL рез;
    VarDecSub(d1, d2, рез);
    return рез;
  }

  /// Перемножает два значения.
  static DECIMAL multiply(DECIMAL d1, DECIMAL d2) {
    DECIMAL рез;
    VarDecMul(d1, d2, рез);
    return рез;
  }

  /// Делит два значения.
  static DECIMAL divide(DECIMAL d1, DECIMAL d2) {
    DECIMAL рез;
    VarDecDiv(d1, d2, рез);
    return рез;
  }

  /// Возвращает результат умножения значения на -1.
  static DECIMAL отриц(DECIMAL d) {
    DECIMAL рез;
    VarDecNeg(d, рез);
    return рез;
  }

  бцел вХэш() {
    дво d;
    VarR8FromDec(this, d);
    if (d == 0)
      return 0;
    return (cast(цел*)&d)[0] ^ (cast(цел*)&d)[1];
  }

  /// Converts the numeric значение of this экземпляр to its equivalent ткст representation.
  ткст вТкст() {
    шим* str;
    if (VarBstrFromDec(this, GetThreadLocale(), 0, str) != S_OK)
      return null;
    return изБткст(str);
  }

  /// Compares two значения.
  static цел сравни(DECIMAL d1, DECIMAL d2) {
    return VarDecCmp(d1, d2) - 1;
  }

  /// Compares this экземпляр to a specified экземпляр.
  цел сравниС(DECIMAL значение) {
    version(D_Version2) {
      return сравни(this, значение);
    }
    else {
      return сравни(*this, значение);
    }
  }

  /// ditto
  цел opCmp(DECIMAL d) {
    version(D_Version2) {
      return сравни(this, d);
    }
    else {
      return сравни(*this, d);
    }
  }

  /// Returns a значение indicating whether two instances represent the same значение.
  static бул равен(DECIMAL d1, DECIMAL d2) {
    return сравни(d1, d2) == 0;
  }

  /// Returns a значение indicating whether this экземпляр and a specified экземпляр represent the same _value.
  бул равен(DECIMAL значение) {
    version(D_Version2) {
      return сравни(this, значение) == 0;
    }
    else {
      return сравни(*this, значение) == 0;
    }
  }

  /// ditto
  бул opEquals(DECIMAL d) {
    version(D_Version2) {
      return сравни(this, d) == 0;
    }
    else {
      return сравни(*this, d) == 0;
    }
  }

  mixin(decimal_operator("Add"));
  mixin(decimal_operator("Sub"));
  mixin(decimal_operator("Mul"));
  mixin(decimal_operator("Div"));

  DECIMAL opMod(DECIMAL d) {
    version(D_Version2) {
      return remainder(this, d);
    }
    else {
      return remainder(*this, d);
    }
  }

  DECIMAL opNeg() {
    DECIMAL рез;
    VarDecNeg(this, рез);
    return рез;
  }

  DECIMAL opPos() {
    version(D_Version2) {
      return this;
    }
    else {
      return *this;
    }
  }

  DECIMAL opPostInc() {
    version(D_Version2) {
      return this = this + DECIMAL(1);
    }
    else {
      return *this = *this + DECIMAL(1);
    }
  }

  DECIMAL opPostDec() {
    version(D_Version2) {
      return this = this - DECIMAL(1);
    }
    else {
      return *this = *this - DECIMAL(1);
    }
  }

}

alias DECIMAL Decimal;

extern(Windows):

цел VarDecFromUI4(бцел ulIn, out DECIMAL pdecOut);
цел VarDecFromI4(цел lIn, out DECIMAL pdecOut);
цел VarDecFromUI8(бдол ui64In, out DECIMAL pdecOut);
цел VarDecFromI8(дол i64In, out DECIMAL pdecOut);
цел VarDecFromR4(плав dlbIn, out DECIMAL pdecOut);
цел VarDecFromR8(дво dlbIn, out DECIMAL pdecOut);
цел VarDecFromStr(in шим* StrIn, бцел лкид, бцел dwFlags, out DECIMAL pdecOut);
цел VarBstrFromDec(ref DECIMAL pdecIn, бцел лкид, бцел dwFlags, out шим* pbstrOut);
цел VarUI4FromDec(ref DECIMAL pdecIn, out бцел pulOut);
цел VarI4FromDec(ref DECIMAL pdecIn, out цел plOut);
цел VarUI8FromDec(ref DECIMAL pdecIn, out бдол pui64Out);
цел VarI8FromDec(ref DECIMAL pdecIn, out дол pi64Out);
цел VarR4FromDec(ref DECIMAL pdecIn, out плав pfltOut);
цел VarR8FromDec(ref DECIMAL pdecIn, out дво pdblOut);

цел VarDecAdd(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);
цел VarDecSub(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);
цел VarDecMul(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);
цел VarDecDiv(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);

цел VarDecRound(ref DECIMAL pdecIn, цел cDecimals, out DECIMAL pdecResult);
цел VarDecAbs(ref DECIMAL pdecIn, out DECIMAL pdecResult);
цел VarDecFix(ref DECIMAL pdecIn, out DECIMAL pdecResult);
цел VarDecInt(ref DECIMAL pdecIn, out DECIMAL pdecResult);
цел VarDecNeg(ref DECIMAL pdecIn, out DECIMAL pdecResult);
цел VarDecCmp(ref DECIMAL pdecLeft, out DECIMAL pdecRight);
//////////////////////////////////////

цел ДесВарИзБЦ4(бцел бцВхо, out ДЕСЯТИЧ десВых)
	{
	return cast(цел) VarDecFromUI4(бцВхо, десВых);
	}

цел ДесВарИзЦ4(цел цВхо, out ДЕСЯТИЧ десВых)
	{
	return cast(цел) VarDecFromI4(цВхо, десВых);
	}

цел ДесВарИзБЦ8(бдол бдВхо, out ДЕСЯТИЧ десВых)
	{
	return cast(цел) VarDecFromUI8(бдВхо, десВых);
	}

цел ДесВарИзЦ8(дол дВхо, out ДЕСЯТИЧ десВых)
	{
	return cast(цел) VarDecFromI8(дВхо, десВых);
	}
	

/*


цел VarDecFromR4(плав dlbIn, out DECIMAL pdecOut);
цел VarDecFromR8(дво dlbIn, out DECIMAL pdecOut);
цел VarDecFromStr(in шим* StrIn, бцел лкид, бцел dwFlags, out DECIMAL pdecOut);
цел VarBstrFromDec(ref DECIMAL pdecIn, бцел лкид, бцел dwFlags, out шим* pbstrOut);
цел VarUI4FromDec(ref DECIMAL pdecIn, out бцел pulOut);
цел VarI4FromDec(ref DECIMAL pdecIn, out цел plOut);
цел VarUI8FromDec(ref DECIMAL pdecIn, out бдол pui64Out);
цел VarI8FromDec(ref DECIMAL pdecIn, out дол pi64Out);
цел VarR4FromDec(ref DECIMAL pdecIn, out плав pfltOut);
цел VarR8FromDec(ref DECIMAL pdecIn, out дво pdblOut);

цел VarDecAdd(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);
цел VarDecSub(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);
цел VarDecMul(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);
цел VarDecDiv(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);
цел VarDecRound(ref DECIMAL pdecIn, цел cDecimals, out DECIMAL pdecResult);
цел VarDecAbs(ref DECIMAL pdecIn, out DECIMAL pdecResult);
цел VarDecFix(ref DECIMAL pdecIn, out DECIMAL pdecResult);
цел VarDecInt(ref DECIMAL pdecIn, out DECIMAL pdecResult);
цел VarDecNeg(ref DECIMAL pdecIn, out DECIMAL pdecResult);
цел VarDecCmp(ref DECIMAL pdecLeft, out DECIMAL pdecRight);
*/
//////////////////////////////////////////////////////////////
version(D_Version2) {
}
else {
  цел VarBstrFromDec(DECIMAL* pdecIn, бцел лкид, бцел dwFlags, out шим* pbstrOut);
  цел VarR8FromDec(DECIMAL* pdecIn, out дво pdblOut);
  цел VarDecNeg(DECIMAL* pdecIn, out DECIMAL pdecResult);
  
  /*
  цел VarBstrFromDec(DECIMAL* pdecIn, бцел лкид, бцел dwFlags, out шим* pbstrOut);
  цел VarR8FromDec(DECIMAL* pdecIn, out дво pdblOut);
  цел VarDecNeg(DECIMAL* pdecIn, out DECIMAL pdecResult);
  */
}

цел VarFormat(ref VARIANT pvarIn, in шим* pstrFormat, цел iFirstDay, цел iFirstWeek, бцел dwFlags, out шим* pbstrOut);
цел VarFormatFromTokens(ref VARIANT pvarIn, in шим* pstrFormat, байт* pbTokCur, бцел dwFlags, out шим* pbstrOut, бцел лкид);
цел VarFormatNumber(ref VARIANT pvarIn, цел iNumDig, цел ilncLead, цел iUseParens, цел iGroup, бцел dwFlags, out шим* pbstrOut);

/*
цел VarFormat(ref VARIANT pvarIn, in шим* pstrFormat, цел iFirstDay, цел iFirstWeek, бцел dwFlags, out шим* pbstrOut);
цел VarFormatFromTokens(ref VARIANT pvarIn, in шим* pstrFormat, байт* pbTokCur, бцел dwFlags, out шим* pbstrOut, бцел лкид);
цел VarFormatNumber(ref VARIANT pvarIn, цел iNumDig, цел ilncLead, цел iUseParens, цел iGroup, бцел dwFlags, out шим* pbstrOut);
*/

extern(D):

enum /*VARconst*/ : бкрат {
  VT_EMPTY            = 0,
  VT_NULL             = 1,
  VT_I2               = 2,
  VT_I4               = 3,
  VT_R4               = 4,
  VT_R8               = 5,
  VT_CY               = 6,
  VT_DATE             = 7,
  VT_BSTR             = 8,
  VT_DISPATCH         = 9,
  VT_ERROR            = 10,
  VT_BOOL             = 11,
  VT_VARIANT          = 12,
  VT_UNKNOWN          = 13,
  VT_DECIMAL          = 14,
  VT_I1               = 16,
  VT_UI1              = 17,
  VT_UI2              = 18,
  VT_UI4              = 19,
  VT_I8               = 20,
  VT_UI8              = 21,
  VT_INT              = 22,
  VT_UINT             = 23,
  VT_VOID             = 24,
  VT_HRESULT          = 25,
  VT_PTR              = 26,
  VT_SAFEARRAY        = 27,
  VT_CARRAY           = 28,
  VT_USERDEFINED      = 29,
  VT_LPSTR            = 30,
  VT_LPWSTR           = 31,
  VT_RECORD           = 36,
  VT_INT_PTR          = 37,
  VT_UINT_PTR         = 38,
  VT_FILETIME         = 64,
  VT_BLOB             = 65,
  VT_STREAM           = 66,
  VT_STORAGE          = 67,
  VT_STREAMED_OBJECT  = 68,
  VT_STORED_OBJECT    = 69,
  VT_BLOB_OBJECT      = 70,
  VT_CF               = 71,
  VT_CLSID            = 72,
  VT_VERSIONED_STREAM = 73,
  VT_BSTR_BLOB        = 0x0fff,
  VT_VECTOR           = 0x1000,
  VT_ARRAY            = 0x2000,
  VT_BYREF            = 0x4000,
  VT_RESERVED         = 0x8000
}
alias бкрат VARTYPE;

enum : крат {
  VARIANT_TRUE = -1, /// Represents the boolean значение _true (-1).
  VARIANT_FALSE = 0  /// Represents the boolean значение _false (0).
}
typedef крат VARIANT_BOOL;

enum : VARIANT_BOOL {
  com_true = VARIANT_TRUE,
  com_false = VARIANT_FALSE
}
alias VARIANT_BOOL com_bool;

template isStaticArray(T : U[N], U, т_мера N) {
  const isStaticArray = true;
}

template isStaticArray(T) {
  const isStaticArray = false;
}

template isDynamicArray(T, U = проц) {
  const isDynamicArray = false;
}

template isDynamicArray(T : U[], U) {
  const isDynamicArray = !isStaticArray!(T);
}

template isArray(T) {
  const isArray = isStaticArray!(T) || isDynamicArray!(T);
}

template isPointer(T) {
  const isPointer = is(T : ук);
}

/**
 * Determines the equivalent COM тип of a built-in тип at compile-время.
 * Примеры:
 * ---
 * auto a = VariantType!(ткст);          // VT_BSTR
 * auto b = VariantType!(бул);            // VT_BOOL
 * auto c = VariantType!(typeof([1,2,3])); // VT_ARRAY | VT_I4
 * ---
 */
template VariantType(T) {
  static if (is(T == VARIANT_BOOL))
    const VariantType = VT_BOOL;
  else static if (is(T == бул))
    const VariantType = VT_BOOL;
  else static if (is(T == сим))
    const VariantType = VT_UI1;
  else static if (is(T == ббайт))
    const VariantType = VT_UI1;
  else static if (is(T == байт))
    const VariantType = VT_I1;
  else static if (is(T == бкрат))
    const VariantType = VT_UI2;
  else static if (is(T == крат))
    const VariantType = VT_I2;
  else static if (is(T == бцел))
    const VariantType = VT_UI4;
  else static if (is(T == цел))
    const VariantType = VT_I4;
  else static if (is(T == бдол))
    const VariantType = VT_UI8;
  else static if (is(T == дол))
    const VariantType = VT_I8;
  else static if (is(T == плав))
    const VariantType = VT_R4;
  else static if (is(T == дво))
    const VariantType = VT_R8;
  else static if (is(T == DECIMAL))
    const VariantType = VT_DECIMAL;
  else static if (is(T E == Enum))
    const VariantType = VariantType!(E);
  else static if (is(T : ткст) || is(T : wstring) || is(T : dstring))
    const VariantType = VT_BSTR;
  else static if (is(T == шим*))
    const VariantType = VT_BSTR;
  else static if (is(T == SAFEARRAY*))
    const VariantType = VT_ARRAY;
  else static if (is(T == VARIANT))
    const VariantType = VT_VARIANT;
  else static if (is(T : IDispatch))
    const VariantType = VT_DISPATCH;
  else static if (is(T : IUnknown))
    const VariantType = VT_UNKNOWN;
  else static if (isArray!(T))
    const VariantType = VariantType!(typeof(*T)) | VT_ARRAY;
  else static if (isPointer!(T)/* && !is(T == ук)*/)
    const VariantType = VariantType!(typeof(*T)) | VT_BYREF;
  else
    const VariantType = VT_VOID;
}

version(D_Version2) {
  ткст variant_operator(ткст имя) {
    return "VARIANT op" ~ имя ~ "(VARIANT that) { \n"
      "  VARIANT рез; \n"
      "  Var" ~ имя ~ "(this, that, рез); \n"
      "  return рез; \n"
      "} \n"
      "проц op" ~ имя ~ "Assign" ~ "(VARIANT that) { \n"
      "  if (!пуст_ли) сотри(); \n"
      "  Var" ~ имя ~ "(this, that, this); \n"
      "}";
  }
}
else {
  ткст variant_operator(ткст имя) {
    return "VARIANT op" ~ имя ~ "(VARIANT that) { \n"
      "  VARIANT рез; \n"
      "  Var" ~ имя ~ "(*this, that, рез); \n"
      "  return рез; \n"
      "} \n"
      "проц op" ~ имя ~ "Assign" ~ "(VARIANT that) { \n"
      "  if (!пуст_ли) сотри(); \n"
      "  Var" ~ имя ~ "(*this, that, *this); \n"
      "}";
  }
}

/**
 * A container for many different типы.
 * Примеры:
 * ---
 * VARIANT var = 10;     // Instance содержит VT_I4.
 * var = "Hello, World"; // Instance now содержит VT_BSTR.
 * var = 234.5;          // Instance now содержит VT_R8.
 * ---
 */

alias VARIANT ВАРИАНТ;
struct VARIANT {

  union {
    struct {
      /// Описывает тип данного экземпляра.
      бкрат vt;
      бкрат wReserved1;
      бкрат wReserved2;
      бкрат wReserved3;
      union {
        дол llVal;
        цел lVal;
        ббайт bVal;
        крат iVal;
        плав fltVal;
        дво dblVal;
        VARIANT_BOOL boolVal;
        цел scode;
        дол cyVal;
        дво date;
        шим* bstrVal;
        IUnknown punkVal;
        IDispatch pdispVal;
        SAFEARRAY* parray;
        ббайт* pbVal;
        крат* piVal;
        цел* plVal;
        дол* pllVal;
        плав* pfltVal;
        дво* pdblVal;
        VARIANT_BOOL* pboolVal;
        цел* pscode;
        дол* pcyVal;
        дво* pdate;
        шим** pbstrVal;
        IUnknown* ppunkVal;
        IDispatch* ppdispVal;
        SAFEARRAY** pparray;
        VARIANT* pvarVal;
        ук byref;
        байт cVal;
        бкрат uiVal;
        бцел ulVal;
        бдол ullVal;
        DECIMAL* pdecVal;
        байт* pcVal;
        крат* puiVal;
        бцел* pulVal;
        бдол* pullVal;
        struct {
          ук pvRecord;
          IRecordInfo pRecInfo;
        }
      }
    }
    DECIMAL decVal;
  }

  /// Represents the _missing значение.
  static VARIANT Missing = { vt: VT_ERROR, scode: DISP_E_PARAMNOTFOUND };

  /// Represents the _nothing значение.
  static VARIANT Nothing = { vt: VT_DISPATCH, pdispVal: null };

  /// Represents the _null значение.
  static VARIANT Null = { vt: VT_NULL };

  version(D_Version2) {
    /**
     * Инициализует новый экземпляр с помощью указанных _значения и _типа.
     * Параметры:
     *   значение = Значение одного из приемлемых типов.
     *   тип = бкрат, идентифицирующий тип значения.
     */
    mixin("
    this(T)(T значение, бкрат тип = VariantType!(T)) {
      иниц(this, значение, тип);
    }
    ");

    static VARIANT opCall(T)(T значение, бкрат тип = VariantType!(T)) {
      return VARIANT(значение, тип);
    }

    ~this() {
      if (isCOMAlive && !(isNull || пуст_ли)) {
        сотри();
      }
    }
  }
  else {
    /**
     * Initializes a new экземпляр используя the specified _value and _type.
     * Параметры:
     *   значение = A _value of one of the acceptable типы.
     *   тип = The бкрат identifying the _type of значение.
     * Возвращает: The resulting VARIANT.
     */
    static VARIANT opCall(T)(T значение, бкрат тип = VariantType!(T)) {
      VARIANT сам;
      иниц(сам, значение, тип);
      return сам;
    }
  }

  private static проц иниц(T)(ref VARIANT ret, T значение, бкрат тип = VariantType!(T)) {
    static if (is(T E == Enum)) {
      иниц(ret, cast(E)значение, тип);
    }
    else {
      ret = cast(typeof(ret)) значение;
      if (тип != ret.vt)
        VariantChangeTypeEx(ret, ret, GetThreadLocale(), VARIANT_ALPHABOOL, тип);
    }
  }

  /*проц opAssign(T)(T значение) {
    if (!пуст_ли)
      сотри();

    static if (is(T == дол)) llVal = значение;
    else static if (is(T == цел)) lVal = значение;
    else static if (is(T == ббайт)) bVal = значение;
    else static if (is(T == крат)) iVal = значение;
    else static if (is(T == плав)) fltVal = значение;
    else static if (is(T == дво)) dblVal = значение;
    else static if (is(T == VARIANT_BOOL)) boolVal = значение;
    else static if (is(T == бул)) boolVal = значение ? VARIANT_TRUE : VARIANT_FALSE;
    else static if (is(T : ткст) || is(T : wstring) || is(T : dstring)) bstrVal = toBstr(значение);
    else static if (is(T : IDispatch)) pdispVal = значение, значение.AddRef();
    else static if (is(T : IUnknown)) punkVal = значение, значение.AddRef();
    else static if (is(T == SAFEARRAY*)) parray = значение;
    else static if (isArray!(T)) parray = SAFEARRAY(значение);
    else static if (is(T == VARIANT*)) pvarVal = значение;
    else static if (is(T : Объект)) byref = cast(ук)значение;
    else static if (isPointer!(T)) byref = cast(ук)значение;
    else static if (is(T == байт)) cVal = значение;
    else static if (is(T == бкрат)) uiVal = значение;
    else static if (is(T == бцел)) ulVal = значение;
    else static if (is(T == бдол)) ullVal = значение;
    else static if (is(T == DECIMAL)) decVal = значение;
    else static if (is(T == VARIANT)) {}
    else static assert(false, "'" ~ T.stringof ~ "' is not one of the allowed типы.");

    vt = VariantType!(T);

    static if (is(T == SAFEARRAY*)) {
      бкрат тип;
      SafeArrayGetVartype(значение, тип);
      vt |= тип;
    }
    else static if (is(T == VARIANT)) {
      значение.копируйВ(*this);
    }
  }*/

  проц opAssign(дол значение) {
    if (!пуст_ли) сотри();
    llVal = значение;
    vt = VT_I8;
  }

  проц opAssign(цел значение) {
    if (!пуст_ли) сотри();
    lVal = значение;
    vt = VT_I4;
  }

  проц opAssign(ббайт значение) {
    if (!пуст_ли) сотри();
    bVal = значение;
    vt = VT_UI1;
  }

  проц opAssign(крат значение) {
    if (!пуст_ли) сотри();
    iVal = значение;
    vt = VT_I2;
  }

  проц opAssign(плав значение) {
    if (!пуст_ли) сотри();
    fltVal = значение;
    vt = VT_R4;
  }

  проц opAssign(дво значение) {
    if (!пуст_ли) сотри();
    dblVal = значение;
    vt = VT_R8;
  }

  проц opAssign(бул значение) {
    if (!пуст_ли) сотри();
    boolVal = значение ? VARIANT_TRUE : VARIANT_FALSE;
    vt = VT_BOOL;
  }

  проц opAssign(VARIANT_BOOL значение) {
    if (!пуст_ли) сотри();
    boolVal = значение;
    vt = VT_BOOL;
  }

  проц opAssign(ткст значение) {
    if (!пуст_ли) сотри();
    bstrVal = toBstr(значение);
    vt = VT_BSTR;
  }

  проц opAssign(IUnknown значение) {
    if (!пуст_ли) сотри();
    if (auto disp = com_cast!(IDispatch)(значение)) {
      pdispVal = disp;
      vt = VT_DISPATCH;
    }
    else {
      значение.AddRef();
      punkVal = значение;
      vt = VT_UNKNOWN;
    }
  }

  проц opAssign(SAFEARRAY* значение) {
    if (!пуст_ли) сотри();
    parray = значение;
    бкрат тип;
    SafeArrayGetVartype(значение, тип);
    vt = VT_ARRAY | тип;
  }

  проц opAssign(байт значение) {
    if (!пуст_ли) сотри();
    cVal = значение;
    vt = VT_I1;
  }

  проц opAssign(бкрат значение) {
    if (!пуст_ли) сотри();
    uiVal = значение;
    vt = VT_UI2;
  }

  проц opAssign(бцел значение) {
    if (!пуст_ли) сотри();
    ulVal = значение;
    vt = VT_UI4;
  }

  проц opAssign(бдол значение) {
    if (!пуст_ли) сотри();
    ullVal = значение;
    vt = VT_UI4;
  }

  проц opAssign(DECIMAL значение) {
    if (!пуст_ли) сотри();
    decVal = значение;
    vt = VT_DECIMAL;
  }

  version(D_Version2) {
    // Illegal in 1.0
    проц opAssign(VARIANT значение) {
      if (!пуст_ли) сотри();
      VariantCopy(this, значение);
    }

    /*проц opAssign(VARIANT* значение) {
      if (!пуст_ли) сотри();
      pvarVal = значение;
      vt = VT_BYREF | VT_VARIANT;
    }*/
  }

  проц opAssign(ббайт[] значение) {
    if (!пуст_ли) сотри();
    parray = SAFEARRAY(значение);
    vt = VT_ARRAY | VT_UI1;
  }

  /**
   * Clears the значение of this экземпляр and releases any associated memory.
   * See_Also: $(LINK2 http://msdn2.microsoft.com/en-us/library/ms221165.aspx, VariantClear).
   */
  проц сотри() {
    if (isCOMAlive && !(isNull || пуст_ли)) {
      version(D_Version2) {
        VariantClear(this);
      }
    else {
        VariantClear(*this);
      }
    }
  }

  /**
   * Copies this экземпляр into the destination значение.
   * Параметры: dest = The variant to копируй into.
   */
  проц копируйВ(out VARIANT dest) {
    version(D_Version2) {
      VariantCopy(dest, this);
    }
    else {
      VariantCopy(dest, *this);
    }
  }

  /**
   * Convers a variant from one тип to another.
   * Параметры: newType = The тип to изменение to.
   */
  VARIANT changeType(бкрат newType) {
    VARIANT dest;
    version(D_Version2) {
      VariantChangeTypeEx(dest, this, GetThreadLocale(), VARIANT_ALPHABOOL, newType);
    }
    else {
      VariantChangeTypeEx(dest, *this, GetThreadLocale(), VARIANT_ALPHABOOL, newType);
    }
    return dest;
  }

  /**
   * Converts the значение contained in this экземпляр to a ткст.
   * Возвращает: A ткст representation of the значение contained in this экземпляр.
   */
  ткст вТкст() {
    if (isNull || пуст_ли)
      return null;

    if (vt == VT_BSTR)
      return изБткст(bstrVal);

    цел hr;
    VARIANT времн;
    version(D_Version2) {
      hr = VariantChangeTypeEx(времн, this, GetThreadLocale(), VARIANT_ALPHABOOL, VT_BSTR);
    }
    else {
      hr = VariantChangeTypeEx(времн, *this, GetThreadLocale(), VARIANT_ALPHABOOL, VT_BSTR);
    }
    if (УДАЧНО(hr))
      return изБткст(времн.bstrVal);

    return null;
  }
  
  /**
   * Returns the _value contained in this экземпляр.
   */
  V значение(V)() {
    static if (is(V == дол)) return llVal;
    else static if (is(V == цел)) return lVal;
    else static if (is(V == ббайт)) return bVal;
    else static if (is(V == крат)) return iVal;
    else static if (is(V == плав)) return fltVal;
    else static if (is(V == дво)) return dblVal;
    else static if (is(V == бул)) return (boolVal == VARIANT_TRUE) ? true : false;
    else static if (is(V == VARIANT_BOOL)) return boolVal;
    else static if (is(V : ткст)) return изБткст(bstrVal);
    else static if (is(V == шим*)) return bstrVal;
    else static if (is(V : IDispatch)) return cast(V)pdispVal;
    else static if (is(V : IUnknown)) return cast(V)punkVal;
    else static if (is(V == SAFEARRAY*)) return parray;
    else static if (isArray!(V)) return parray.вМассив!(typeof(*V))();
    else static if (is(V == VARIANT*)) return pvarVal;
    else static if (is(V : Объект)) return cast(V)byref;
    else static if (isPointer!(V)) return cast(V)byref;
    else static if (is(V == байт)) return cVal;
    else static if (is(V == бкрат)) return uiVal;
    else static if (is(V == бцел)) return ulVal;
    else static if (is(V == бдол)) return ullVal;
    else static if (is(V == DECIMAL)) return decVal;
    else static assert(false, "'" ~ V.stringof ~ "' is not one of the allowed типы.");
  }

  /**
   * Determines whether this экземпляр is пустой.
   */
  бул пуст_ли() {
    return (vt == VT_EMPTY);
  }

  /**
   * Determines whether this экземпляр is _null.
   */
  бул isNull() {
    return (vt == VT_NULL);
  }

  /**
   * Determines whether this экземпляр is Nothing.
   */
  бул isNothing() {
    return (vt == VT_DISPATCH && pdispVal is null)
      || (vt == VT_UNKNOWN && punkVal is null);
  }

  цел opCmp(VARIANT that) {
    version(D_Version2) {
      return VarCmp(this, that, GetThreadLocale(), 0) - 1;
    }
    else {
      return VarCmp(*this, that, GetThreadLocale(), 0) - 1;
    }
  }

  бул opEquals(VARIANT that) {
    return opCmp(that) == 0;
  }

  mixin(variant_operator("Cat"));
  mixin(variant_operator("Add"));
  mixin(variant_operator("Sub"));
  mixin(variant_operator("Div"));
  mixin(variant_operator("Mul"));
  mixin(variant_operator("Mod"));
  mixin(variant_operator("And"));
  mixin(variant_operator("Or"));
  mixin(variant_operator("Xor"));

}

VARIANT toVariant(T)(T значение, бул autoFree = false) {
  if (!autoFree) {
    return VARIANT(значение);
  }
  else return (new class(значение) {
    VARIANT var;
    this(T значение) { var = VARIANT(значение); }
    ~this() { var.сотри(); }
  }).var;
}

extern(Windows):

проц VariantInit(ref VARIANT pvarg);
цел VariantClear(ref VARIANT pvarg);
цел VariantCopy(ref VARIANT pvargDest, ref VARIANT pvargSrc);

цел VarAdd(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
цел VarAnd(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
цел VarCat(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
цел VarDiv(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
цел VarMod(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
цел VarMul(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
цел VarOr(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
цел VarSub(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
цел VarXor(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
цел VarCmp(ref VARIANT pvarLeft, ref VARIANT pvarRight, бцел лкид, бцел dwFlags);
////////////////////////////////////////////////////
extern(Windows)
{
проц ИницВариант(ref ВАРИАНТ вар){VariantInit(cast(VARIANT) вар);}
цел СотриВариант(ref ВАРИАНТ вар){return cast(цел) VariantClear(cast(VARIANT) вар);}
цел КопируйВариант(ref ВАРИАНТ варгЦель, ref ВАРИАНТ варгИст)
	{
	return cast(цел) VariantCopy(cast(VARIANT) варгЦель, cast(VARIANT) варгИст);
	}

цел СложиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
    {
	return cast(цел) VarAdd(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
	
цел ИВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarAnd(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
	
цел СоединиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarCat(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез); 
	}
	
цел ДелиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarDiv(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
	
цел УмножьВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarMul(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
	
цел ИлиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarOr(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
	
цел ОтнимиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarSub(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
	
цел ИИлиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarXor(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
	
цел СравниВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, бцел лкид, бцел флаги)
	{
	return cast(цел) VarCmp(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(бцел) лкид, cast(бцел) флаги);
	}

цел МодВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarMod(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
}
////////////////////////////////////////////////////////////////////////////

enum : бкрат {
  VARIANT_NOVALUEPROP        = 0x1,
  VARIANT_ALPHABOOL          = 0x2,
  VARIANT_NOUSEROVERRIDE     = 0x4,
  VARIANT_CALENDAR_HIJRI     = 0x8,
  VARIANT_LOCALBOOL          = 0x10,
  VARIANT_CALENDAR_THAI      = 0x20,
  VARIANT_CALENDAR_GREGORIAN = 0x40,
  VARIANT_USE_NLS            = 0x80
}

цел VariantChangeType(ref VARIANT pvargDest, ref VARIANT pvarSrc, бкрат wFlags, бкрат vt);
цел VariantChangeTypeEx(ref VARIANT pvargDest, ref VARIANT pvarSrc, бцел лкид, бкрат wFlags, бкрат vt);
/////////////////////
/*
цел ИзмениТипВарианта(ref ВАРИАНТ 
цел ИзмениТипВариантаДоп(ref ВАРИАНТ 
цел VariantChangeType(ref VARIANT pvargDest, ref VARIANT pvarSrc, бкрат wFlags, бкрат vt);
цел VariantChangeTypeEx(ref VARIANT pvargDest, ref VARIANT pvarSrc, бцел лкид, бкрат wFlags, бкрат vt);
*/
/////////////////////////////////////////////

extern(Windows):

alias IUnknown Инкогнито;
interface IUnknown {
  mixin(ууид("00000000-0000-0000-c000-000000000046"));

  цел QueryInterface(ref GUID riid, ук* ppvObject);
  бцел AddRef();
  бцел Release();
}

enum : бцел {
  CLSCTX_INPROC_SERVER    = 0x1,
  CLSCTX_INPROC_HANDLER   = 0x2,
  CLSCTX_LOCAL_SERVER     = 0x4,
  CLSCTX_INPROC_SERVER16  = 0x8,
  CLSCTX_REMOTE_SERVER    = 0x10,
  CLSCTX_INPROC_HANDLER16 = 0x20,
  CLSCTX_INPROC           = CLSCTX_INPROC_SERVER | CLSCTX_INPROC_HANDLER,
  CLSCTX_SERVER           = CLSCTX_INPROC_SERVER | CLSCTX_LOCAL_SERVER | CLSCTX_REMOTE_SERVER,
  CLSCTX_ALL              = CLSCTX_INPROC_SERVER | CLSCTX_INPROC_HANDLER | CLSCTX_LOCAL_SERVER | CLSCTX_REMOTE_SERVER
}

цел CoCreateInstance(ref GUID rclsid, IUnknown pUnkOuter, бцел dwClsContext, ref GUID riid, ук* ppv);

цел CoGetClassObject(ref GUID rclsid, бцел dwClsContext, ук pvReserved, ref GUID riid, ук* ppv);
//////////////////////////////
цел СоздайЭкземплярКо(ref ГУИД рклсид, Инкогнито анонВнешн, бцел контекстКл, ref ГУИД риид, ук* ув)
{
return cast(цел) CoCreateInstance(cast(GUID) рклсид, cast(IUnknown) анонВнешн, cast(бцел) контекстКл, cast(GUID) риид, cast(ук*) ув);
}

цел ДайОбъектКлассаКо(ref ГУИД рклсид, бцел контекстКл, ук резерв, ref ГУИД риид, ук* ув)
{
return cast(цел) CoGetClassObject(cast(GUID) рклсид, cast(бцел) контекстКл, cast(ук) резерв, cast(GUID) риид, cast(ук*) ув);
}
////////////////////////////////
alias COSERVERINFO КОСЕРВЕРИНФО;
struct COSERVERINFO {
  бцел dwReserved1;
  version(D_Version2) {
    mixin("const(шим)* pwszName;");
  }
  else {
    шим* pwszName;
  }
  COAUTHINFO* pAutInfo;
  бцел dwReserved2;
}

цел CoCreateInstanceEx(ref GUID rclsid, IUnknown pUnkOuter, бцел dwClsContext, COSERVERINFO* pServerInfo, бцел dwCount, MULTI_QI* pResults);
///////////////
цел СоздайЭкземплярКоДоп(ref ГУИД рклсид, Инкогнито анонВнешн, бцел контекстКл, КОСЕРВЕРИНФО* сервИнф, бцел счёт, МУЛЬТИ_ОИ* результы)
{
return cast(цел) CoCreateInstanceEx(cast(GUID) рклсид, cast(IUnknown) анонВнешн, cast(бцел) контекстКл, cast(COSERVERINFO*) сервИнф, cast(бцел) счёт, cast(MULTI_QI*) результы);
}
///////////////////////

enum {
  CLASS_E_NOAGGREGATION     = 0x80040110,
  CLASS_E_CLASSNOTAVAILABLE = 0x80040111
}

enum {
  SELFREG_E_FIRST   = MAKE_SCODE!(SEVERITY_ERROR, FACILITY_ITF, 0x0200),
  SELFREG_E_LAST    = MAKE_SCODE!(SEVERITY_ERROR, FACILITY_ITF, 0x020F),
  SELFREG_S_FIRST   = MAKE_SCODE!(SEVERITY_SUCCESS, FACILITY_ITF, 0x0200),
  SELFREG_S_LAST    = MAKE_SCODE!(SEVERITY_SUCCESS, FACILITY_ITF, 0x020F),
  SELFREG_E_TYPELIB = SELFREG_E_FIRST,
  SELFREG_E_CLASS   = SELFREG_E_FIRST + 1
}

interface IClassFactory : IUnknown {
  mixin(ууид("00000001-0000-0000-c000-000000000046"));

  цел CreateInstance(IUnknown pUnkOuter, ref GUID riid, ук* ppvObject);
  цел LockServer(цел fLock);
}

interface IMalloc : IUnknown {
  mixin(ууид("00000002-0000-0000-c000-000000000046"));

  ук Alloc(т_мера cb);
  ук Realloc(ук pv, т_мера cb);
  проц Free(ук pv);
  т_мера GetSize(ук pv);
  цел DidAlloc(ук pv);
  проц HeapMinimize();
}

цел CoGetMalloc(бцел dwMemContext/* = 1*/, out IMalloc ppMalloc);

interface IMarshal : IUnknown {
  mixin(ууид("00000003-0000-0000-c000-000000000046"));

  цел GetUnmarshalClass(ref GUID riid, ук pv, бцел dwDestContext, ук pvDestContext, бцел mshlflags, out GUID pCid);
  цел GetMarshalSizeMax(ref GUID riid, ук pv, бцел dwDestContext, ук pvDestContext, бцел mshlflags, out бцел pSize);
  цел MarshalInterface(IStream pStm, ref GUID riid, ук pv, бцел dwDestContext, ук pvDestContext, бцел mshlflags);
  цел UnmarshalInterface(IStream pStm, ref GUID riid, ук* ppv);
  цел ReleaseMarshalData(IStream pStm);
  цел DisconnectObject(бцел dwReserved);
}

interface ISequentialStream : IUnknown {
  mixin(ууид("0c733a30-2a1c-11ce-ade5-00aa0044773d"));

  цел Read(ук pv, бцел cb, ref бцел pcbRead);
  цел Write(in ук pv, бцел cb, ref бцел pcbWritten);
}

enum : бцел {
  STGTY_STORAGE = 1,
  STGTY_STREAM = 2,
  STGTY_LOCKBYTES = 3,
  STGTY_PROPERTY = 4
}

enum : бцел {
  STREAM_SEEK_SET,
  STREAM_SEEK_CUR,
  STREAM_SEEK_END
}

enum : бцел {
  STATFLAG_DEFAULT,
  STATFLAG_NONAME,
  STATFLAG_NOOPEN
}

struct STATSTG {
  шим* pwcsName;
  бцел тип;
  бдол cbSize;
  FILETIME mtime;
  FILETIME ctime;
  FILETIME atime;
  бцел grfMode;
  бцел grfLocksSupported;
  GUID clsid;
  бцел grfStateBits;
  бцел reserved;
}

interface ILockBytes : IUnknown {
  mixin(ууид("0000000a-0000-0000-c000-000000000046"));

  цел ReadAt(бдол ulOffset, ук pv, бцел cb, ref бцел pcbRead);
  цел WriteAt(бдол ulOffset, in ук pv, бцел cb, ref бцел pcbWritten);
  цел Flush();
  цел SetSize(бдол cb);
  цел LockRegion(бдол libOffset, бдол cb, бцел dwLockType);
  цел UnlockRegion(бдол libOffset, бдол cb, бцел dwLockType);
  цел Stat(out STATSTG pstatstg, бцел grfStatFlag);
}

enum : бцел {
  STGM_DIRECT           = 0x00000000,
  STGM_TRANSACTED       = 0x00010000,
  STGM_SIMPLE           = 0x08000000,
  STGM_READ             = 0x00000000,
  STGM_WRITE            = 0x00000001,
  STGM_READWRITE        = 0x00000002,
  STGM_SHARE_DENY_NONE  = 0x00000040,
  STGM_SHARE_DENY_READ  = 0x00000030,
  STGM_SHARE_DENY_WRITE = 0x00000020,
  STGM_SHARE_EXCLUSIVE  = 0x00000010,
  STGM_CREATE           = 0x00001000
}

цел GetHGlobalFromILockBytes(ILockBytes plkbyt, out Укз phglobal);
цел CreateILockBytesOnHGlobal(Укз hGlobal, цел fDeleteOnRelease, out ILockBytes pplkbyt);
цел StgCreateDocfileOnILockBytes(ILockBytes plkbyt, бцел grfMode, бцел reserved, out IStorage ppstgOpen);

interface IStorage : IUnknown {
  mixin(ууид("0000000b-0000-0000-c000-000000000046"));

  цел CreateStream(шим* pwcsName, бцел grfMode, бцел reserved1, бцел reserved2, out IStream ppstm);
  цел OpenStream(шим* pwcsName, ук reserved1, бцел grfMode, бцел reserved2, out IStream ppstm);
  цел CreateStorage(шим* pwcsName, бцел grfMode, бцел reserved1, бцел reserved2, out IStorage ppstg);
  цел OpenStorage(шим* pwcsName, IStorage psrgPriority, бцел grfMode, шим** snbExclude, бцел reserved, out IStorage ppstg);
  цел CopyTo(бцел ciidExclude, GUID* rgiidExclude, шим** snbExclude, IStorage pstgDest);
  цел MoveElementTo(шим* pwcsName, IStorage pstgDest, шим* pwcsNewName, бцел grfFlags);
  цел Commit(бцел grfCommitFlags);
  цел Revert();
  цел constElements(бцел reserved1, ук reserved2, бцел reserved3, out IEnumSTATSTG ppEnum);
  цел DestroyElement(шим* pwcsName);
  цел RenameElement(шим* pwcsOldName, шим* pwcsNewName);
  цел SetElementTimes(шим* pwcsName, ref FILETIME pctime, ref FILETIME patime, ref FILETIME pmtime);
  цел SetClass(ref GUID clsid);
  цел SetStateBits(бцел grfStateBits, бцел grfMask);
  цел Stat(out STATSTG pstatstg, бцел grfStatFlag);
}

цел ReadClassStg(IStorage pStg, out GUID pclsid);
цел WriteClassStg(IStorage pStg, ref GUID rclsid);
цел ReadClassStm(IStream pStm, out GUID pclsid);
цел WriteClassStm(IStream pStm, ref GUID rclsid);

struct STGOPTIONS {
  бкрат usVersion;
  бкрат reserved;
  бцел ulSectorSize;
  шим* pwcsTemplateFile;
}

enum : бцел {
  STGFMT_STORAGE = 0,
  STGFMT_FILE = 3,
  STGFMT_ANY = 4,
  STGFMT_DOCFILE = 5
}

цел StgOpenStorage(in шим* pwcsName, IStorage pstgPriority, бцел grfMode, шим** snbExclude, бцел reserved, out IStorage ppstgOpen);
цел StgOpenStorageEx(in шим* pwcsName, бцел grfMode, бцел stgfmt, бцел grfAttrs, STGOPTIONS* pStgOptions, SECURITY_DESCRIPTOR* pSecurityDescriptor, ref GUID riid, ук* ppObjectOpen);

interface IStream : ISequentialStream {
  mixin(ууид("0000000c-0000-0000-c000-000000000046"));

  цел Seek(дол dlibMove, бцел dwOrigin, ref бдол plibNewPosition);
  цел SetSize(бдол libNewSize);
  цел CopyTo(IStream stm, бдол cb, ref бдол pcbRead, ref бдол pcbWritten);
  цел Commit(бцел hrfCommitFlags);
  цел Revert();
  цел LockRegion(бдол libOffset, бдол cb, бцел dwLockType);
  цел UnlockRegion(бдол libOffset, бдол cb, бцел dwLockType);
  цел Stat(out STATSTG pstatstg, бцел grfStatFlag);
  цел Clone(out IStream ppstm);
}

цел GetHGlobalFromStream(IStream pstm, out Укз phglobal);
цел CreateStreamOnHGlobal(Укз hGlobal, цел fDeleteOnRelease, out IStream ppstm);

interface IEnumSTATSTG : IUnknown {
  mixin(ууид("0000000d-0000-0000-c000-000000000046"));

  цел Next(бцел celt, STATSTG* rgelt, out бцел pceltFetched);
  цел Skip(бцел celt);
  цел Reset();
  цел Clone(out IEnumSTATSTG ppEnum);
}

enum : бцел {
  BIND_MAYBOTHERUSER = 1,
  BIND_JUSTTESTEXISTENCE = 2
}

struct BIND_OPTS {
  бцел cbStruct = BIND_OPTS.sizeof;
  бцел grfFlags;
  бцел grfMode;
  бцел dwTickCountDeadline;
}

struct BIND_OPTS2 {
  бцел cbStruct = BIND_OPTS2.sizeof;
  бцел grfFlags;
  бцел grfMode;
  бцел dwTickCountDeadline;
  бцел dwTrackFlags;
  бцел dwClassContext;
  бцел локаль;
  COSERVERINFO* pServerInfo;
}

interface IBindCtx : IUnknown {
  mixin(ууид("0000000e-0000-0000-c000-000000000046"));

  цел RegisterObjectBound(IUnknown punk);
  цел RevokeObjectBound(IUnknown punk);
  цел ReleaseBoundObjects();
  цел SetBindOptions(BIND_OPTS* pbindopts);
  цел GetBindOptions(BIND_OPTS* pbindopts);
  цел GetRunningObjectTable(out IRunningObjectTable pprot);
  цел RegisterObjectParam(шим* pszKey, IUnknown punk);
  цел GetObjectParam(шим* pszKey, out IUnknown ppunk);
  цел EnumObjectParam(out IEnumString ppEnum);
  цел RemoveObjectParam(шим* pszKey);
}

цел CreateBindCtx(бцел reserved, out IBindCtx ppbc);

interface IMoniker : IPersistStream {
  mixin(ууид("0000000f-0000-0000-c000-000000000046"));

  цел BindToObject(IBindCtx pbc, IMoniker pmkToLeft, ref GUID riidResult, ук* ppvResult);
  цел BindToStorage(IBindCtx pbc, IMoniker pmkToLeft, ref GUID riid, ук* ppv);
  цел Reduce(IBindCtx pbc, бцел dwReduceHowFar, ref IMoniker ppmkToLeft, out IMoniker ppmkReduced);
  цел ComposeWith(IMoniker pmkRight, бул fOnlyIfNotGeneric, out IMoniker ppmkComposite);
  цел Enum(бул fForward, out IEnumMoniker ppEnumMoniker);
  цел IsEqual(IMoniker pmkOtherMoniker);
  цел Hash(out бцел pdwHash);
  цел IsRunning(IBindCtx pbc, IMoniker pmkToLeft, IMoniker pmkNewlyRunning);
  цел GetTimeOfLastChange(IBindCtx pbc, IMoniker pmkToLeft, out FILETIME pFileTime);
  цел Inverse(out IMoniker ppmk);
  цел CommonPrefixWith(IMoniker pmkOther, out IMoniker ppmkPrefix);
  цел RelativePathTo(IMoniker pmkOther, out IMoniker ppmkRelPath);
  цел GetDisplayName(IBindCtx pbc, IMoniker pmkToLeft, out шим* ppszDisplayName);
  цел ParseDisplayName(IBindCtx pbc, IMoniker pmkToLeft, шим* pszDisplayName, out бцел pchEaten, out IMoniker ppmkOut);
  цел IsSystemMoniker(out бцел pswMkSys);
}

цел CreateFileMoniker(in шим* lpszPathName, out IMoniker ppmk);

interface IRunningObjectTable : IUnknown {
  mixin(ууид("00000010-0000-0000-c000-000000000046"));

  цел Register(бцел grfFlags, IUnknown punkObject, IMoniker pmkObjectName, out бцел pdwRegister);
  цел Revoke(бцел dwRegister);
  цел IsRunning(IMoniker pmkObjectName);
  цел GetObject(IMoniker pmkObjectName, out IUnknown ppunkObject);
  цел NoteChangeTime(бцел dwRegister, ref FILETIME pfiletime);
  цел GetTimeOfLastChange(IMoniker pmkObjectName, out FILETIME pfiletime);
  цел constRunning(out IEnumMoniker ppEnumMoniker);
}

alias MULTI_QI МУЛЬТИ_ОИ;
struct MULTI_QI {
  version(D_Version2) {
    mixin("const(GUID)* pIID;");
  }
  else {
    GUID* pIID;
  }
  IUnknown pItf;
  цел hr;
}

interface IMultiQI : IUnknown {
  mixin(ууид("00000020-0000-0000-c000-000000000046"));

  цел QueryMultipleInterfaces(бцел cMQIs, MULTI_QI* pMQIs);
}

alias IRecordInfo ИИнфОЗаписи;
interface IRecordInfo : IUnknown {
  mixin(ууид("0000002f-0000-0000-c000-000000000046"));

  цел RecordInit(ук pvNew);
  цел RecordClear(ук pvExisting);
  цел RecordCopy(ук pvExisting, ук pvNew);
  цел GetGuid(out GUID pguid);
  цел GetName(out шим* pbstrName);
  цел GetSize(out бцел pcbSize);
  цел GetTypeInfo(out ITypeInfo ppTypeInfo);
  цел GetField(ук pvData, шим* szFieldName, out VARIANT pvarField);
  цел GetFieldNoCopy(ук pvData, шим* szFieldName, out VARIANT pvarField, ук* ppvDataCArray);
  цел PutField(бцел wFlags, ук pvData, шим* szFieldName, ref VARIANT pvarField);
  цел PutFieldNoCopy(бцел wFlags, ук pvData, шим* szFieldName, ref VARIANT pvarField);
  цел GetFieldNames(out бцел pcNames, шим** rgBstrNames);
  бул IsMatchingType(IRecordInfo pRecordInfo);
  ук RecordCreate();
  цел RecordCreateCopy(ук pvSource, out ук ppvDest);
  цел RecordDestroy(ук pvRecord);
}

interface IEnumUnknown : IUnknown {
  mixin(ууид("00000100-0000-0000-c000-000000000046"));

  цел Next(бцел celt, IUnknown* rgelt, out бцел pceltFetched);
  цел Skip(бцел celt);
  цел Reset();
  цел Clone(out IEnumUnknown ppEnum);
}

interface IEnumString : IUnknown {
  mixin(ууид("00000101-0000-0000-c000-000000000046"));

  цел Next(бцел celt, шим** rgelt, бцел* pceltFetched);
  цел Skip(бцел celt);
  цел Reset();
  цел Clone(out IEnumString ppEnum);
}

interface IEnumMoniker : IUnknown {
  mixin(ууид("00000102-0000-0000-c000-000000000046"));

  цел Next(бцел celt, IMoniker* rgelt, out бцел pceltFetched);
  цел Skip(бцел celt);
  цел Reset();
  цел Clone(out IEnumMoniker ppEnum);
}

struct DVTARGETDEVICE {
  бцел tdSize;
  бкрат tdDriverNameOffset;
  бкрат tdDeviceNameOffset;
  бкрат tdPortNameOffset;
  бкрат tdExtDevmodeOffset;
  ббайт* tdData;
}

enum DVASPECT : бцел {
  DVASPECT_CONTENT = 1,
  DVASPECT_THUMBNAIL = 2,
  DVASPECT_ICON = 4,
  DVASPECT_DOCPRINT = 8
}

enum : бцел {
  TYMED_NULL = 0,
  TYMED_HGLOBAL = 1,
  TYMED_FILE = 2,
  TYMED_ISTREAM = 4,
  TYMED_ISTORAGE = 8,
  TYMED_GDI = 16,
  TYMED_MFPICT = 32,
  TYMED_ENHMF = 64
}

struct FORMATETC {
  бкрат cfFormat;
  DVTARGETDEVICE* ptd;
  бцел dwAspect;
  цел lindex;
  бцел tymed;
}

enum TYMED : бцел {
  TYMED_NULL = 0,
  TYMED_HGLOBAL = 1,
  TYMED_FILE = 2,
  TYMED_ISTREAM = 4,
  TYMED_ISTORAGE = 8,
  TYMED_GDI = 16,
  TYMED_MFPICT = 32,
  TYMED_ENHMF = 64
}

struct STGMEDIUM {
  бцел tymed;
  union {
    Укз hBitmap;
    Укз hMetaFilePict;
    Укз hEnhMetaFile;
    Укз hGlobal;
    шим* lpszFileName;
    IStream pstm;
    IStorage pstg;
  }
  IUnknown pUnkForRelease;
}

interface IEnumFORMATETC : IUnknown {
  mixin(ууид("00000103-0000-0000-c000-000000000046"));

  цел Next(бцел celt, FORMATETC* rgelt, ref бцел pceltFetched);
  цел Skip(бцел celt);
  цел Reset();
  цел Clone(out IEnumFORMATETC ppEnum);
}

struct OLEVERB {
  цел lVerb;
  шим* lpszVerbName;
  бцел fuFlags;
  бцел grfAttribs;
}

interface IEnumOLEVERB : IUnknown {
  mixin(ууид("00000104-0000-0000-c000-000000000046"));

  цел Next(бцел celt, OLEVERB* rgelt, out бцел pceltFetched);
  цел Skip(бцел celt);
  цел Reset();
  цел Clone(out IEnumOLEVERB ppEnum);
}

struct STATDATA {
  FORMATETC formatetc;
  бцел advf;
  IAdviseSink pAdvSink;
  бцел dwConnection;
}

interface IEnumSTATDATA : IUnknown {
  mixin(ууид("00000105-0000-0000-c000-000000000046"));

  цел Next(бцел celt, STATDATA* rgelt, out бцел pceltFetched);
  цел Skip(бцел celt);
  цел Reset();
  цел Clone(out IEnumSTATDATA ppEnum);
}

interface IPersist : IUnknown {
  mixin(ууид("0000010c-0000-0000-c000-000000000046"));

  цел GetClassID(out GUID pClassID);
}

interface IPersistStream : IPersist {
  mixin(ууид("00000109-0000-0000-c000-000000000046"));

  цел IsDirty();
  цел Load(IStream pStm);
  цел Save(IStream pStm, цел fClearDirty);
  цел GetSizeMax(out бдол pcbSize);
}

interface IPersistStreamInit : IPersist {
  mixin(ууид("7FD52380-4E07-101B-AE2D-08002B2EC713"));

  цел IsDirty();
  цел Load(IStream pStm);
  цел Save(IStream pStm, цел fClearDirty);
  цел GetSizeMax(out бдол pcbSize);
  цел InitNew();
}

enum {
  DV_E_FORMATETC = 0x80040064,
  DV_E_DVTARGETDEVICE = 0x80040065,
  DV_E_STGMEDIUM = 0x80040066,
  DV_E_STATDATA = 0x80040067,
  DV_E_LINDEX = 0x80040068,
  DV_E_TYMED = 0x80040069,
  DV_E_CLIPFORMAT = 0x8004006A,
  DV_E_DVASPECT = 0x8004006B
}

interface ИОбъектДанных : IUnknown {
  mixin(ууид("0000010e-0000-0000-c000-000000000046"));

  цел GetData(ref FORMATETC pformatetcIn, out STGMEDIUM pmedium);
  цел GetDataHere(ref FORMATETC pformatetc, ref STGMEDIUM pmedium);
  цел QueryGetData(ref FORMATETC pformatetc);
  цел GetCanonicalFormatEtc(ref FORMATETC pformatetcIn, out FORMATETC pformatetcOut);
  цел SetData(ref FORMATETC pformatetc, ref STGMEDIUM pmedium, цел fRelease);
  цел constFormatEtc(бцел dwDirection, out IEnumFORMATETC ppEnumFormatEtc);
  цел DAdvise(ref FORMATETC pformatetc, бцел advf, IAdviseSink pAdvSink, out бцел pdwConnection);
  цел DUnadvise(бцел dwConnection);
  цел constDAdvise(out IEnumSTATDATA ppEnumAdvise);
}

цел OleSetClipboard(ИОбъектДанных pDataObj);
цел OleGetClipboard(out ИОбъектДанных ppDataObj);
цел OleFlushClipboard();
цел OleIsCurrentClipboard(ИОбъектДанных pDataObj);

interface IAdviseSink : IUnknown {
  mixin(ууид("0000010f-0000-0000-c000-000000000046"));

  цел OnDataChange(ref FORMATETC pFormatetc, ref STGMEDIUM pStgmed);
  цел OnViewChange(бцел dwAspect, цел lindex);
  цел OnRename(IMoniker pmk);
  цел OnSave();
  цел OnClose();
}

enum {
  DRAGDROP_S_DROP = 0x00040100,
  DRAGDROP_S_CANCEL = 0x00040101,
  DRAGDROP_S_USEDEFAULTCURSORS = 0x00040102
}

interface IDropSource : IUnknown {
  mixin(ууид("00000121-0000-0000-c000-000000000046"));

  цел QueryContinueDrag(цел fEscapePressed, бцел grfKeyState);
  цел GiveFeedback(бцел dwEffect);
}

enum : бцел {
  DROPEFFECT_NONE = 0,
  DROPEFFECT_COPY = 1,
  DROPEFFECT_MOVE = 2,
  DROPEFFECT_LINK = 4,
  DROPEFFECT_SCROLL = 0x80000000
}

interface IDropTarget : IUnknown {
  mixin(ууид("00000122-0000-0000-c000-000000000046"));

  цел DragEnter(ИОбъектДанных pDataObj, бцел grfKeyState, POINT pt, ref бцел pdwEffect);
  цел DragOver(бцел grfKeyState, POINT pt, ref бцел pdwEffect);
  цел DragLeave();
  цел Drop(ИОбъектДанных pDataObj, бцел grfKeyState, POINT pt, ref бцел pdwEffect);
}

enum {
  DRAGDROP_E_NOTREGISTERED = 0x80040100,
  DRAGDROP_E_ALREADYREGISTERED = 0x80040101,
  DRAGDROP_E_INVALIDHWND = 0x80040102
}

цел RegisterDragDrop(Укз hwnd, IDropTarget pDropTarget);
цел RevokeDragDrop(Укз hwnd);
цел DoDragDrop(ИОбъектДанных pDataObject, IDropSource pDropSource, бцел dwOKEffects, out бцел pdwEffect);

struct DISPPARAMS {
  VARIANT* rgvarg;
  цел* rgdispidNamedArgs;
  бцел cArgs;
  бцел cNamedArgs;
}

struct EXCEPINFO {
  бкрат wCode;
  бкрат wReserved;
  шим* bstrSource;
  шим* bstrDescription;
  шим* bstrHelpFile;
  бцел dwHelpContext;
  ук pvReserved;
  цел function(EXCEPINFO*) pfnDeferredFillIn;
  цел scode;
}

enum : бкрат {
  DISPATCH_METHOD         = 0x1,
  DISPATCH_PROPERTYGET    = 0x2,
  DISPATCH_PROPERTYPUT    = 0x4,
  DISPATCH_PROPERTYPUTREF = 0x8
}

enum {
  DISPID_UNKNOWN     = -1,
  DISPID_VALUE       = 0,
  DISPID_PROPERTYPUT = -3,
  DISPID_NEWconst     = -4,
  DISPID_EVALUATE    = -5,
  DISPID_CONSTRUCTOR = -6,
  DISPID_DESTRUCTOR  = -7,
  DISPID_COLLECT     = -8
}

enum {
  DISP_E_UNKNOWNINTERFACE = 0x80020001,
  DISP_E_MEMBERNOTFOUND   = 0x80020003,
  DISP_E_PARAMNOTFOUND    = 0x80020004,
  DISP_E_TYPEMISMATCH     = 0x80020005,
  DISP_E_UNKNOWNNAME      = 0x80020006,
  DISP_E_NONAMEDARGS      = 0x80020007,
  DISP_E_BADVARTYPE       = 0x80020008,
  DISP_E_EXCEPTION        = 0x80020009,
  DISP_E_BADPARAMCOUNT    = 0x8002000E
}

interface IDispatch : IUnknown {
  mixin(ууид("00020400-0000-0000-c000-000000000046"));

  цел GetTypeInfoCount(out бцел pctinfo);
  цел GetTypeInfo(бцел iTInfo, бцел лкид, out ITypeInfo ppTInfo);
  цел GetIDsOfNames(ref GUID riid, шим** rgszNames, бцел cNames, бцел лкид, цел* rgDispId);
  цел Invoke(цел dispIdMember, ref GUID riid, бцел лкид, бкрат wFlags, DISPPARAMS* pDispParams, VARIANT* pVarResult, EXCEPINFO* pExcepInfo, бцел* puArgError);
}

enum TYPEKIND {
  TKIND_ENUM,
  TKIND_RECORD,
  TKIND_MODULE,
  TKIND_INTERFACE,
  TKIND_DISPATCH,
  TKIND_COCLASS,
  TKIND_ALIAS,
  TKIND_UNION
}

struct TYPEDESC {
  union {
    TYPEDESC* lptdesc;
    ARRAYDESC* lpadesc;
    бцел hreftype;
  }
  бкрат vt;
}

struct ARRAYDESC {
  TYPEDESC tdescElem;
  бкрат cDims;
  SAFEARRAYBOUND[1] rgbounds;
}

struct PARAMDESCEX {
  бцел cBytes;
  VARIANT varDefaultValue;
}

struct PARAMDESC {
  PARAMDESCEX* pparamdescex;
  бкрат wParamFlags;
}

enum : бкрат {
  PARAMFLAG_NONE = 0x0,
  PARAMFLAG_FIN = 0x1,
  PARAMFLAG_FOUT = 0x2,
  PARAMFLAG_FLCID = 0x4,
  PARAMFLAG_FRETVAL = 0x8,
  PARAMFLAG_FOPT = 0x10,
  PARAMFLAG_FHASDEFAULT = 0x20,
  PARAMFLAG_FHASCUSTDATA = 0x40
}

struct IDLDESC {
  бцел dwReserved;
  бкрат wIDLFlags;
}

struct ELEMDESC {
  TYPEDESC tdesc;
  union {
    IDLDESC idldesc;
    PARAMDESC paramdesc;
  }
}

struct TYPEATTR {
  GUID гуид;
  бцел лкид;
  бцел dwReserved;
  цел memidConstructor;
  цел memidDestructor;
  шим* lpstrSchema;
  бцел cbSizeInstance;
  TYPEKIND typekind;
  бкрат cFuncs;
  бкрат cVars;
  бкрат cImplTypes;
  бкрат cbSizeVft;
  бкрат cbAlignment;
  бкрат wTypeFlags;
  бкрат wMajorVerNum;
  бкрат wMinorVerNum;
  TYPEDESC tdescAlias;
  IDLDESC idldescType;
}

enum CALLCONV {
  CC_FASTCALL,
  CC_CDECL,
  CC_MSPASCAL,
  CC_PASCAL = CC_MSPASCAL,
  CC_MACPASCAL,
  CC_STDCALL,
  CC_FPFASTCALL,
  CC_SYSCALL,
  CC_MPWCDECL,
  CC_MPWPASCAL
}

enum FUNCKIND {
  FUNC_VIRTUAL,
  FUNC_PUREVIRTUAL,
  FUNC_NONVIRTUAL,
  FUNC_STATIC,
  FUNC_DISPATCH
}

enum INVOKEKIND {
  INVOKE_FUNC = 1,
  INVOKE_PROPERTYGET = 2,
  INVOKE_PROPERTYPUT = 4,
  INVOKE_PROPERTYPUTREF = 8
}

struct FUNCDESC {
  цел memid;
  цел* lprgscode;
  ELEMDESC* lprgelemdescParam;
  FUNCKIND funckind;
  INVOKEKIND invkind;
  CALLCONV callconv;
  крат cParams;
  крат cParamsOpt;
  крат oVft;
  крат cScodes;
  ELEMDESC elemdescFunc;
  бкрат wFuncFlags;
}

enum VARKIND {
  VAR_PERSISTANCE,
  VAR_STATIC,
  VAR_CONST,
  VAR_DISPATCH
}

enum : бкрат {
  IMPLTYPEFLAG_FDEFAULT = 0x1,
  IMPLTYPEFLAG_FSOURCE = 0x2,
  IMPLTYPEFLAG_FRESTRICTED = 0x4,
  IMPLTYPEFLAG_FDEFAULTVTABLE = 0x8
}

struct VARDESC {
  цел memid;
  шим* lpstrSchema;
  union {
    бцел oInst;
    VARIANT* lpvarValue;
  }
  ELEMDESC elemdescVar;
  бкрат wVarFlags;
  VARKIND varkind;
}

enum TYPEFLAGS : бкрат {
  TYPEFLAG_FAPPOBJECT = 0x1,
  TYPEFLAG_FCANCREATE = 0x2,
  TYPEFLAG_FLICENSED = 0x4,
  TYPEFLAG_FPREDECLID = 0x8,
  TYPEFLAG_FHIDDEN = 0x10,
  TYPEFLAG_FCONTROL = 0x20,
  TYPEFLAG_FDUAL = 0x40,
  TYPEFLAG_FNONEXTENSIBLE = 0x80,
  TYPEFLAG_FOLEAUTOMATION = 0x100,
  TYPEFLAG_FRESTRICTED = 0x200,
  TYPEFLAG_FAGGREGATABLE = 0x400,
  TYPEFLAG_FREPLACEABLE = 0x800,
  TYPEFLAG_FDISPATCHABLE = 0x1000,
  TYPEFLAG_FREVERSEBIND = 0x2000,
  TYPEFLAG_FPROXY = 0x4000
}

enum FUNCFLAGS : бкрат {
  FUNCFLAG_FRESTRICTED = 0x1,
  FUNCFLAG_FSOURCE = 0x2,
  FUNCFLAG_FBINDABLE = 0x4,
  FUNCFLAG_FREQUESTEDIT = 0x8,
  FUNCFLAG_FDISPLAYBIND = 0x10,
  FUNCFLAG_FDEFAULTBIND = 0x20,
  FUNCFLAG_FHIDDEN = 0x40,
  FUNCFLAG_FUSESGETLASTERROR = 0x80,
  FUNCFLAG_FDEFAULTCOLLELEM = 0x100,
  FUNCFLAG_FUIDEFAULT = 0x200,
  FUNCFLAG_FNONBROWSABLE = 0x400,
  FUNCFLAG_FREPLACEABLE = 0x800,
  FUNCFLAG_FIMMEDIATEBIND = 0x1000
}

enum VARFLAGS : бкрат {
  VARFLAG_FREADONLY = 0x1,
  VARFLAG_FSOURCE = 0x2,
  VARFLAG_FBINDABLE = 0x4,
  VARFLAG_FREQUESTEDIT = 0x8,
  VARFLAG_FDISPLAYBIND = 0x10,
  VARFLAG_FDEFAULTBIND = 0x20,
  VARFLAG_FHIDDEN = 0x40,
  VARFLAG_FRESTRICTED = 0x80,
  VARFLAG_FDEFAULTCOLLELEM = 0x100,
  VARFLAG_FUIDEFAULT = 0x200,
  VARFLAG_FNONBROWSABLE = 0x400,
  VARFLAG_FREPLACEABLE = 0x800,
  VARFLAG_FIMMEDIATEBIND = 0x1000
}

enum DESCKIND {
  DESCKIND_NONE,
  DESCKIND_FUNCDESC,
  DESCKIND_VARDESC,
  DESCKIND_TYPECOMP,
  DESCKIND_IMPLICITAPPOBJ
}

struct BINDPTR {
  FUNCDESC* lpfuncdesc;
  VARDESC* lpvardesc;
  ITypeComp lptcomp;
}

enum SYSKIND {
  SYS_WIN16,
  SYS_WIN32,
  SYS_MAC,
  SYS_WIN64
}

enum /* LIBFLAGS */ : бкрат {
  LIBFLAG_FRESTRICTED = 0x1,
  LIBFLAG_FCONTROL = 0x2,
  LIBFLAG_FHIDDEN = 0x4,
  LIBFLAG_FHASDISKIMAGE = 0x8
}

struct TLIBATTR {
  GUID гуид;
  бцел лкид;
  SYSKIND syskind;
  бкрат wMajorVerNum;
  бкрат wMinorVerNum;
  бкрат wLibFlags;
}

enum {
  TYPE_E_ELEMENTNOTFOUND      = 0x8002802B
}

interface ITypeInfo : IUnknown {
  mixin(ууид("00020401-0000-0000-c000-000000000046"));

  цел GetTypeAttr(out TYPEATTR* ppTypeAttr);
  цел GetTypeComp(out ITypeComp ppTComp);
  цел GetFuncDesc(бцел индекс, out FUNCDESC* ppFuncDesc);
  цел GetVarDesc(бцел индекс, out VARDESC* ppVarDesc);
  цел GetNames(цел memid, шим** rgBstrNames, бцел cMaxNames, out бцел pcNames);
  цел GetRefTypeOfImplType(бцел индекс, out бцел pRefType);
  цел GetImplTypeFlags(бцел индекс, out цел pImplTypeFlags);
  цел GetIDsOfNames(шим** rgszNames, бцел cNames, цел* pMemId);
  цел Invoke(ук pvInstance, цел memid, бкрат wFlags, DISPPARAMS* pDispParams, VARIANT* pVarResult, EXCEPINFO* pExcepInfo, бцел* puArgErr);
  цел GetDocumentation(цел memid, шим** pBstrName, шим** pBstrDocString, бцел* pdwHelpContext, шим** pBstrHelpFile);
  цел GetDllEntry(цел memid, INVOKEKIND invKind, шим** pBstrDllName, шим** pBstrName, бкрат* pwOrdinal);
  цел GetRefTypeInfo(бцел hRefType, out ITypeInfo ppTInfo);
  цел AddressOfMember(цел memid, INVOKEKIND invKind, ук* ppv);
  цел CreateInstance(IUnknown pUnkOuter, ref GUID riid, ук* ppvObj);
  цел GetMops(цел memid, шим** pBstrMops);
  цел GetContainingTypeLib(out ITypeLib ppTLib, out бцел pIndex);
  цел ReleaseTypeAttr(TYPEATTR* pTypeAttr);
  цел ReleaseFuncDesc(FUNCDESC* pFuncDesc);
  цел ReleaseVarDesc(VARDESC* pVarDesc);
}

interface ITypeLib : IUnknown {
  mixin(ууид("00020402-0000-0000-c000-000000000046"));

  бцел GetTypeInfoCount();
  цел GetTypeInfo(бцел индекс, out ITypeInfo ppTInfo);
  цел GetTypeInfoType(бцел индекс, out TYPEKIND pTKind);
  цел GetTypeInfoOfGuid(ref GUID гуид, out ITypeInfo ppTInfo);
  цел GetLibAttr(out TLIBATTR* ppTLibAttr);
  цел GetTypeComp(out ITypeComp ppTComp);
  цел GetDocumentation(цел индекс, шим** pBstrName, шим** pBstrDocString, бцел* pBstrHelpContext, шим** pBstrHelpFile);
  цел IsName(шим* szNameBuf, бцел lHashVal, out бул pfName);
  цел FindName(шим* szNameBuf, бцел lHashVal, ITypeInfo* ppTInfo, цел* rgMemId, ref бкрат pcFound);
  цел ReleaseTLibAttr(TLIBATTR* pTLibAttr);
}

цел LoadTypeLib(in шим* szFile, out ITypeLib pptlib);

enum REGKIND {
  REGKIND_DEFAULT,
  REGKIND_REGISTER,
  REGKIND_NONE
}

цел LoadTypeLibEx(in шим* szFile, REGKIND regkind, out ITypeLib pptlib);
цел LoadRegTypeLib(ref GUID rgiud, бкрат wVerMajor, бкрат wVerMinor, бцел лкид, out ITypeLib pptlib);
цел QueryPathOfRegTypeLib(ref GUID гуид, бкрат wVerMajor, бкрат wVerMinor, бцел лкид, out шим* lpbstrPathName);
цел RegisterTypeLib(ITypeLib ptlib, in шим* szFullPath, in шим* szHelpDir);
цел UnRegisterTypeLib(ref GUID libID, бкрат wVerMajor, бкрат wVerMinor, бцел лкид, SYSKIND syskind);
цел RegisterTypeLibForUser(ITypeLib ptlib, шим* szFullPath, шим* szHelpDir);
цел UnRegisterTypeLibForUser(ref GUID libID, бкрат wVerMajor, бкрат wVerMinor, бцел лкид, SYSKIND syskind);

interface ITypeComp : IUnknown {
  mixin(ууид("00020403-0000-0000-c000-000000000046"));

  цел Bind(шим* szName, бцел lHashVal, бкрат wFlags, out ITypeInfo ppTInfo, out DESCKIND pDescKind, out BINDPTR pBindPtr);
  цел BindType(шим* szName, бцел lHashVal, out ITypeInfo ppTInfo, out ITypeComp ppTComp);
}

interface IEnumVARIANT : IUnknown {
  mixin(ууид("00020404-0000-0000-c000-000000000046"));

  цел Next(бцел celt, VARIANT* rgelt, out бцел pceltFetched);
  цел Skip(бцел celt);
  цел Reset();
  цел Clone(out IEnumVARIANT ppEnum);
}

interface ICreateTypeInfo : IUnknown {
  mixin(ууид("00020405-0000-0000-c000-000000000046"));

  цел SetGuid(ref GUID гуид);
  цел SetTypeFlags(бцел uTypeFlags);
  цел SetDocString(шим* szStrDoc);
  цел SetHelpContext(бцел dwHelpContext);
  цел SetVersion(бкрат wMajorVerNum, бкрат wMinorVerNum);
  цел AddRefTypeInfo(ITypeInfo pTInfo, ref бцел phRefType);
  цел AddFuncDesc(бцел индекс, FUNCDESC* pFuncDesc);
  цел AddImplType(бцел индекс, бцел hRefType);
  цел SetTypeImplFlags(бцел индекс, цел implTypeFlags);
  цел SetAlignment(бкрат cbAlignment);
  цел SetSchema(шим* pStrSchema);
  цел AddVarDesc(бцел индекс, VARDESC* pVarDesc);
  цел SetFuncAndParamNames(бцел индекс, шим** rgszNames, бцел cNames);
  цел SetVarName(бцел индекс, шим* szName);
  цел SetTypeDescAlias(TYPEDESC* pTDescAlias);
  цел DefineFuncAsDllEntry(бцел индекс, шим* szDllName, шим* szProcName);
  цел SetFuncDocString(бцел индекс, шим* szDocString);
  цел SetVarDocString(бцел индекс, шим* szDocString);
  цел SetFuncHelpContext(бцел индекс, бцел dwHelpContext);
  цел SetVarHelpContext(бцел индекс, бцел dwHelpContext);
  цел SetMops(бцел индекс, шим* bstrMops);
  цел SetTypeIdldesc(IDLDESC* pIdlDesc);
  цел LayOut();
}

interface ICreateTypeLib : IUnknown {
  mixin(ууид("00020406-0000-0000-c000-000000000046"));

  цел CreateTypeInfo(шим* szName, TYPEKIND tkind, out ICreateTypeInfo ppCTInfo);
  цел SetName(шим* szName);
  цел SetVersion(бкрат wMajorVerNum, бкрат wMinorVerNum);
  цел SetGuid(ref GUID гуид);
  цел SetDocString(шим* szDoc);
  цел SetHelpFileName(шим* szHelpFileName);
  цел SetHelpContext(бцел dwHelpContext);
  цел SetLcid(бцел лкид);
  цел SetLibFlags(бцел uLibFlags);
  цел SaveAllChanges();
}

цел CreateTypeLib(SYSKIND syskind, in шим* szFile, out ICreateTypeLib ppctlib);

interface ICreateTypeInfo2 : ICreateTypeInfo {
  mixin(ууид("0002040e-0000-0000-c000-000000000046"));

  цел DeleteFuncDesc(бцел индекс);
  цел DeleteFuncDescByMemId(цел memid, INVOKEKIND invKind);
  цел DeleteVarDesc(бцел индекс);
  цел DeleteVarDescByMemId(цел memid);
  цел DeleteImplType(бцел индекс);
  цел SetCustData(ref GUID гуид, ref VARIANT pVarVal);
  цел SetFuncCustData(бцел индекс, ref GUID гуид, ref VARIANT pVarVal);
  цел SetParamCustData(бцел indexFunc, бцел indexParam, ref GUID гуид, ref VARIANT pVarVal);
  цел SetVarCustData(бцел индекс, ref GUID гуид, ref VARIANT pVarVal);
  цел SetImplTypeCustData(бцел индекс, ref GUID гуид, ref VARIANT pVarVal);
  цел SetHelpStringContext(бцел dwHelpStringContext);
  цел SetFuncHelpStringContext(бцел индекс, бцел dwHelpStringContext);
  цел SetVarHelpStringContext(бцел индекс, бцел dwHelpStringContext);
  цел Invalidate();
}

interface ICreateTypeLib2 : ICreateTypeLib {
  mixin(ууид("0002040f-0000-0000-c000-000000000046"));

  цел DeleteTypeInfo(шим* szName);
  цел SetCustData(ref GUID гуид, ref VARIANT pVarVal);
  цел SetHelpStringContext(бцел dwHelpStringContext);
  цел SetHelpStringDll(шим* szFileName);
}

цел CreateTypeLib2(SYSKIND syskind, in шим* szFile, out ICreateTypeLib2 ppctlib);

enum CHANGEKIND {
  CHANGEKIND_ADDMEMBER,
  CHANGEKIND_DELETEMEMBER,
  CHANGEKIND_SETNAMES,
  CHANGEKIND_SETDOCUMENTATION,
  CHANGEKIND_GENERAL,
  CHANGEKIND_INVALIDATE,
  CHANGEKIND_CHANGEFAILED,
  CHANGEKIND_MAX
}

interface ITypeChangeEvents : IUnknown {
  mixin(ууид("00020410-0000-0000-c000-000000000046"));

  цел RequestTypeChange(CHANGEKIND changeKind, ITypeInfo pTInfoBefore, шим* pStrName, out цел pfCancel);
  цел AfterTypeChange(CHANGEKIND changeKind, ITypeInfo pTInfoAfter, шим* pStrName);
}

struct CUSTDATAITEM {
  GUID гуид;
  VARIANT varValue;
}

struct CUSTDATA {
  бцел cCustData;
  CUSTDATAITEM* prgCustData;
}

interface ITypeLib2 : ITypeLib {
  mixin(ууид("00020411-0000-0000-c000-000000000046"));

  цел GetCustData(ref GUID гуид, out VARIANT pVarVal);
  цел GetLibStatistics(out бцел pcUniqueNames, out бцел pcchUniqueNames);
  цел GetDocumentation2(цел индекс, бцел лкид, шим** pBstrHelpString, бцел* pdwHelpContext, шим** pBstrHelpStringDll);
  цел GetAllCustData(out CUSTDATA pCustData);
}

interface ITypeInfo2 : ITypeInfo {
  mixin(ууид("00020412-0000-0000-c000-000000000046"));

  цел GetTypeKind(out TYPEKIND pTypeKind);
  цел GetTypeFlags(out бцел pTypeFlags);
  цел GetFuncIndexOfMemId(цел memid, INVOKEKIND invKind, out бцел pFuncIndex);
  цел GetVarIndexOfMemId(цел memid, out бцел pVarIndex);
  цел GetCustData(ref GUID гуид, out VARIANT pVarVal);
  цел GetFuncCustData(бцел индекс, ref GUID гуид, out VARIANT pVarVal);
  цел GetParamCustData(бцел indexFunc, бцел indexParam, ref GUID гуид, out VARIANT pVarVal);
  цел GetVarCustData(бцел индекс, ref GUID гуид, out VARIANT pVarVal);
  цел GetImplTypeCustData(бцел индекс, ref GUID гуид, out VARIANT pVarVal);
  цел GetDocumentation2(цел memid, бцел лкид, шим** pBstrHelpString, бцел* pdwHelpContext, шим** pBstrHelpStringDll);
  цел GetAllCustData(out CUSTDATA pCustData);
  цел GetAllFuncCustData(бцел индекс, out CUSTDATA pCustData);
  цел GetAllParamCustData(бцел indexFunc, бцел indexParam, out CUSTDATA pCustData);
  цел GetAllVarCustData(бцел индекс, out CUSTDATA pCustData);
  цел GetAllTypeImplCustData(бцел индекс, out CUSTDATA pCustData);
}

interface IEnumGUID : IUnknown {
  mixin(ууид("0002E000-0000-0000-c000-000000000046"));

  цел Next(бцел celt, GUID* rgelt, out бцел pceltFetched);
  цел Skip(бцел celt);
  цел Reset();
  цел Clone(out IEnumGUID ppEnum);
}

struct CATEGORYINFO {
  GUID catid;
  бцел лкид;
  шим[128] szDescription;
}

interface IEnumCATEGORYINFO : IUnknown {
  mixin(ууид("0002E011-0000-0000-c000-000000000046"));

  цел Next(бцел celt, CATEGORYINFO* rgelt, out бцел pceltFetched);
  цел Skip(бцел celt);
  цел Reset();
  цел Clone(out IEnumGUID ppEnum);
}

interface ICatInformation : IUnknown {
  mixin(ууид("0002E013-0000-0000-c000-000000000046"));

  цел constCategories(бцел лкид, out IEnumCATEGORYINFO ppEnumCategoryInfo);
  цел GetCategoryDesc(inout GUID rcatid, бцел лкид, out шим* pszDesc);
  цел constClassesOfCategories(бцел cImplemented, GUID* rgcatidImpl, бцел cRequired, GUID* rgcatidReq, out IEnumGUID ppEnumClsid);
  цел IsClassOfCategories(inout GUID rclsid, бцел cImplemented, GUID* rgcatidImpl, бцел cRequired, GUID* rgcatidReq);
  цел constImplCategoriesOfClass(inout GUID rclsid, out IEnumGUID ppEnumCatid);
  цел constReqCategoriesOfClass(inout GUID rclsid, out IEnumGUID ppEnumCatid);
}

abstract final class StdComponentCategoriesMgr {
  mixin(ууид("0002E005-0000-0000-c000-000000000046"));

  mixin Интерфейсы!(ICatInformation);
}

interface IConnectionPointContainer : IUnknown {
  mixin(ууид("b196b284-bab4-101a-b69c-00aa00341d07"));

  цел constConnectionPoints(out IEnumConnectionPoints ppEnum);
  цел FindConnectionPoint(ref GUID riid, out IConnectionPoint ppCP);
}

interface IEnumConnectionPoints : IUnknown {
  mixin(ууид("b196b285-bab4-101a-b69c-00aa00341d07"));

  цел Next(бцел cConnections, IConnectionPoint* ppCP, out бцел pcFetched);
  цел Skip(бцел cConnections);
  цел Reset();
  цел Clone(out IEnumConnectionPoints ppEnum);
}

interface IConnectionPoint : IUnknown {
  mixin(ууид("b196b286-bab4-101a-b69c-00aa00341d07"));

  цел GetConnectionInterface(out GUID pIID);
  цел GetConnectionPointContainer(out IConnectionPointContainer ppCPC);
  цел Advise(IUnknown pUnkSink, out бцел pdwCookie);
  цел Unadvise(бцел dwCookie);
  цел constConnections(out IEnumConnections ppEnum);
}

struct CONNECTDATA {
  IUnknown pUnk;
  бцел dwCookie;
}

interface IEnumConnections : IUnknown {
  mixin(ууид("b196b287-bab4-101a-b69c-00aa00341d07"));

  цел Next(бцел cConnections, CONNECTDATA* rgcd, out бцел pcFetched);
  цел Skip(бцел cConnections);
  цел Reset();
  цел Clone(out IEnumConnections ppEnum);
}

interface IErrorInfo : IUnknown {
  mixin(ууид("1cf2b120-547d-101b-8e65-08002b2bd119"));

  цел GetGUID(out GUID pGUID);
  цел GetSource(out шим* pBstrSource);
  цел GetDescription(out шим* pBstrDescription);
  цел GetHelpFile(out шим* pBstrHelpFile);
  цел GetHelpContext(out бцел pdwHelpContext);
}

цел SetErrorInfo(бцел dwReserved, IErrorInfo perrinfo);
цел GetErrorInfo(бцел dwReserved, out IErrorInfo pperrinfo);
цел CreateErrorInfo(out IErrorInfo pperrinfo);

interface ISupportErrorInfo : IUnknown {
  mixin(ууид("df0b3d60-548f-101b-8e65-08002b2bd119"));

  цел InterfaceSupportsErrorInfo(ref GUID riid);
}

struct LICINFO {
  цел cbLicInfo = LICINFO.sizeof;
  цел fRuntimeKeyAvail;
  цел fLicVerified;
}

interface IClassFactory2 : IClassFactory {
  mixin(ууид("b196b28f-bab4-101a-b69c-00aa00341d07"));

  цел GetLicInfo(out LICINFO pLicInfo);
  цел RequestLicKey(бцел dwReserved, out шим* pBstrKey);
  цел CreateInstanceLic(IUnknown pUnkOuter, IUnknown pUnkReserved, ref GUID riid, шим* bstrKey, ук* ppvObj);
}

struct TEXTMETRICOLE {
  цел tmHeight;
  цел tmAscent;
  цел tmDescent;
  цел tmInternalLeading;
  цел tmExternalLeading;
  цел tmAveCharWidth;
  цел tmMaxCharWidth;
  цел tmWeight;
  цел tmOverhang;
  цел tmDigitizedAspectX;
  цел tmDigitizedAspectY;
  шим tmFirstChar;
  шим tmLastChar;
  шим tmDefaultChar;
  шим tmBreakChar;
  ббайт tmItalic;
  ббайт tmUnderlined;
  ббайт tmStruckOut;
  ббайт tmPitchAndFamily;
  ббайт tmCharSet;
}

interface IFont : IUnknown {
  mixin(ууид("BEF6E002-A874-101A-8BBA-00AA00300CAB"));

  цел get_Name(out шим* pName);
  цел set_Name(шим* имя);
  цел get_Size(out дол pSize);
  цел set_Size(дол размер);
  цел get_Bold(out цел pBold);
  цел set_Bold(цел bold);
  цел get_Italic(out цел pItalic);
  цел set_Italic(цел italic);
  цел get_Underline(out цел pUnderline);
  цел set_Underline(цел underline);
  цел get_Strikethrough(out цел pStrikethrough);
  цел set_Strikethrough(цел strikethrough);
  цел get_Weight(out крат pWeight);
  цел set_Weight(крат weight);
  цел get_Charset(out крат pCharset);
  цел set_Charset(крат charset);
  цел get_hFont(out Укз phFont);
  цел Clone(out IFont ppFont);
  цел IsEqual(IFont pFontOther);
  цел SetRatio(цел cyLogical, цел cyHimetric);
  цел QueryTextMetrics(out TEXTMETRICOLE pTM);
  цел AddRefHfont(Укз hFont);
  цел ReleaseHfont(Укз hFont);
  цел SetHdc(Укз hDC);
}

interface IPicture : IUnknown {
  mixin(ууид("7BF80980-BF32-101A-8BBB-00AA00300CAB"));

  цел get_Handle(out бцел pHandle);
  цел get_hPal(out бцел phPal);
  цел get_Type(out крат pType);
  цел get_Width(out цел pWidth);
  цел get_Height(out цел pHeight);
  цел Render(Укз hDC, цел x, цел y, цел cx, цел cy, цел xSrc, цел ySrc, цел cxSrc, цел cySrc, RECT* pRcBounds);
  цел set_hPal(бцел hPal);
  цел get_CurDC(out Укз phDC);
  цел SelectPicture(Укз hDCIn, out Укз phDCOut, out бцел phBmpOut);
  цел get_KeepOriginalFormat(out цел pKeep);
  цел put_KeepOriginalFormat(цел keep);
  цел PictureChanged();
  цел SaveAsFile(IStream pStream, цел fSaveMemCopy, out цел pCbSize);
  цел get_Attributes(out бцел pDwAttr);
}

interface IFontEventsDisp : IDispatch {
  mixin(ууид("4EF6100A-AF88-11D0-9846-00C04FC29993"));
}

interface IFontDisp : IDispatch {
  mixin(ууид("BEF6E003-A874-101A-8BBA-00AA00300CAB"));
}

interface IPictureDisp : IDispatch {
  mixin(ууид("7BF80981-BF32-101A-8BBB-00AA00300CAB"));
}

цел OleSetContainedObject(IUnknown pUnknown, цел fContained);

enum {
  PICTYPE_UNINITIALIZED = -1,
  PICTYPE_NONE = 0,
  PICTYPE_BITMAP = 1,
  PICTYPE_METAFILE = 2,
  PICTYPE_ICON = 3,
  PICTYPE_ENHMETAFILE = 4
}

struct PICTDESC {
  бцел cbSizeofStruct = PICTDESC.sizeof;
  бцел picType;
  Укз указатель;
}

цел OleCreatePictureIndirect(PICTDESC* lpPictDesc, ref GUID riid, цел fOwn, ук* lplpvObj);
цел OleLoadPicture(IStream lpstream, цел lSize, цел fRunmode, ref GUID riid, ук* lplpvObj);

цел OleInitialize(ук pvReserved);
проц OleUninitialize();

enum : бцел {
  COINIT_MULTITHREADED = 0x0,
  COINIT_APARTMENTTHREADED = 0x2,
  COINIT_DISABLE_OLE1DDE = 0x4,
  COINIT_SPEED_OVER_MEMORY = 0x8
}

цел CoInitialize(ук);
проц CoUninitialize();
цел CoInitializeEx(ук, бцел dwCoInit);

ук CoTaskMemAlloc(т_мера cb);
ук CoTaskMemRealloc(ук pv, т_мера cb);
проц CoTaskMemFree(ук pv);

enum : бцел {
  ACTIVEOBJECT_STRONG,
  ACTIVEOBJECT_WEAK
}

цел RegisterActiveObject(IUnknown punk, ref GUID rclsid, бцел dwFlags, out бцел pdwRegister);
цел RevokeActiveObject(бцел dwRegister, ук pvReserved);
цел GetActiveObject(ref GUID rclsid, ук pvReserved, out IUnknown ppunk);

enum : бцел {
  MSHLFLAGS_NORMAL = 0x0,
  MSHLFLAGS_TABLESTRONG = 0x1,
  MSHLFLAGS_TABLEWEAK = 0x2,
  MSHLFLAGS_NOPING = 0x4
}

enum : бцел {
  MSHCTX_LOCAL,
  MSHCTX_NOSHAREDMEM,
  MSHCTX_DIFFERENTMACHINE,
  MSHCTX_INPROC,
  MSHCTX_CROSSCTX
}

цел CoMarshalInterface(IStream pStm, ref GUID riid, IUnknown pUnk, бцел dwDestContext, ук pvDestContext, бцел mshlflags);
цел CoUnmarshalInterface(IStream pStm, ref GUID riid, ук* ppv);

цел ProgIDFromCLSID(ref GUID clsid, out шим* lplpszProgID);
цел CLSIDFromProgID(in шим* lpszProgID, out GUID lpclsid);
цел CLSIDFromProgIDEx(in шим* lpszProgID, out GUID lpclsid);

/*//////////////////////////////////////////////////////////////////////////////////////////
// Helpers                                                                                //
//////////////////////////////////////////////////////////////////////////////////////////*/

extern(D):

/*package*/ бул isCOMAlive = false;

private проц startup() {
  isCOMAlive = УДАЧНО(CoInitializeEx(null, COINIT_APARTMENTTHREADED));
}

 import runtime;
private проц shutdown() {
  // Before we shut down COM, give classes a chance to отпусти any COM resources.
  try {
    version(D_Version2) {
      GC.collect();
    }
    else {       
      runtime.fullCollect();
    }
  }
  finally {
    isCOMAlive = false;
    CoUninitialize();
  }
}

/**
 * Specifies whether to throw exceptions or return null when COM operations fail.
 */
enum ExceptionPolicy {
  NoThrow, /// Returns null on failure.
  Throw    /// Throws an exception on failure.
}

template com_cast_impl(T, ExceptionPolicy policy) {

  T com_cast_impl(U)(U объ) {
    static if (is(U : IUnknown)) {
      static if (is(typeof(объ is null))) {
        if (объ is null) {
          static if (policy == ExceptionPolicy.Throw)
            throw new ИсклНулевогоАргумента("объ");
          else
            return null;
        }
      }
      else static if (is(typeof(объ.isNull))) {
        // com_ref
        if (объ.isNull) {
          static if (policy == ExceptionPolicy.Throw)
            throw new ИсклНулевогоАргумента("объ");
          else
            return null;
        }
      }

      T рез;
      if (УДАЧНО(объ.QueryInterface(uuidof!(T), retval(рез))))
        return рез;

      static if (policy == ExceptionPolicy.Throw)
        throw new ИсклПриведенияКТипу("Неверное преобразование из '" ~ U.stringof ~ "' в '" ~ T.stringof ~ "'.");
      else
        return null;
    }
    else static if (is(U : Объект)) {
      if (auto comObj = cast(COMObject)объ)
        return com_cast!(T)(comObj.объ);

      static if (policy == ExceptionPolicy.Throw)
        throw new ИсклПриведенияКТипу("Неверное преобразование из '" ~ U.stringof ~ "' в '" ~ T.stringof ~ "'.");
      else
        return null;
    }
    else static if (is(U == VARIANT)) {
      const тип = VariantType!(T);

      static if (тип != VT_VOID) {
        VARIANT времн;
        if (УДАЧНО(VariantChangeTypeEx(времн, объ, GetThreadLocale(), VARIANT_ALPHABOOL, тип))) {
          scope(exit) времн.сотри();

          with (времн) {
            static if (тип == VT_BOOL) {
              static if (is(T == бул))
                return (boolVal == VARIANT_TRUE) ? true : false;
              else 
                return boolVal;
            }
            else static if (тип == VT_UI1) return bVal;
            else static if (тип == VT_I1) return cVal;
            else static if (тип == VT_UI2) return uiVal;
            else static if (тип == VT_I2) return iVal;
            else static if (тип == VT_UI4) return ulVal;
            else static if (тип == VT_I4) return lVal;
            else static if (тип == VT_UI8) return ullVal;
            else static if (тип == VT_I8) return llVal;
            else static if (тип == VT_R4) return fltVal;
            else static if (тип == VT_R8) return dblVal;
            else static if (тип == VT_DECIMAL) return decVal;
            else static if (тип == VT_BSTR) {
              static if (is(T : ткст))
                return изБткст(bstrVal);
              else 
                return bstrVal;
            }
            else static if (тип == VT_UNKNOWN) return com_cast_impl(объ.punkVal);
            else static if (тип == VT_DISPATCH) return com_cast_impl(объ.pdispVal);
            else return T.init;
          }
        }
        static if (policy == ExceptionPolicy.Throw)
          throw new ИсклПриведенияКТипу("Неверное преобразование из '" ~ U.stringof ~ "' в '" ~ T.stringof ~ "'.");
        else
          return T.init;
      }
      else static assert(false, "Неверное преобразование из '" ~ U.stringof ~ "' в '" ~ T.stringof ~ "'.");
    }
    else static assert(false, "Неверное преобразование из '" ~ U.stringof ~ "' в '" ~ T.stringof ~ "'.");
  }

}

/**
 * Invokes the conversion operation to преобразуй from one COM тип to another.
 *
 * If the operand is a VARIANT, this function converts its значение to the тип represented by $(I T). If the operand is an IUnknown-derived object, this function 
 * calls the object's QueryInterface метод. If the conversion operation fails, the function returns T.init.
 *
 * Примеры:
 * ---
 * // C++
 * бул tryToMeow(Dog* dog) {
 *   Cat* cat = NULL;
 *   HRESULT hr = dog->QueryInterface(IID_Cat, static_cast<ук*>(&cat));
 *   if (hr == S_OK) {
 *     hr = cat->meow();
 *     cat->Release();
 *   }
 *   return hr == S_OK;
 * }
 *
 * // C#
 * бул tryToMeow(Dog dog) {
 *   Cat cat = dog as Cat;
 *   if (cat != null)
 *     return cat.meow();
 *   return false;
 * }
 *
 * // D
 * бул tryToMeow(Dog dog) {
 *   if (auto cat = com_cast!(Cat)(dog)) {
 *     scope(exit) cat.Release();
 *     return cat.meow() == S_OK;
 *   }
 *   return false;
 * }
 * ---
 */
template com_cast(T) {
  alias com_cast_impl!(T, ExceptionPolicy.NoThrow) com_cast;
}

/// Invokes the conversion operation to преобразуй from one COM тип to another, as above, but throws an exception
/// if the cast fails.
/// Выводит исключение: КОМИскл if the cast failed.
template com_safe_cast(T) {
  alias com_cast_impl!(T, ExceptionPolicy.Throw) com_safe_cast;
}

/// Specifies the context in which the code that manages an object will run.
/// See_Also: $(LINK2 http://msdn.microsoft.com/en-us/library/ms693716.aspx, CLSCTX consteration).
enum ExecutionContext : бцел {
  InProcessServer  = CLSCTX_INPROC_SERVER,  /// The code that creates and manages objects of this class is a DLL that runs in the same process as the caller of the function specifying the class context.
  InProcessHandler = CLSCTX_INPROC_HANDLER, /// The code that manages objects of this class is an in-process handler. is a DLL that runs in the client process and implements client-side structures of this class when instances of the class are accessed remotely.
  LocalServer      = CLSCTX_LOCAL_SERVER,   /// The code that creates and manages objects of this class runs on same machine but is loaded in a separate process space.
  RemoteServer     = CLSCTX_REMOTE_SERVER,  /// A  remote context. The code that creates and manages objects of this class is run on a different computer.
  Все              = CLSCTX_ALL
}

/**
 * Creates an object of the class associated with a specified GUID.
 * Параметры:
 *   clsid = The class associated with the object.
 *   outer = If null, indicates that the object is not being создан as часть of an aggregate.
 *   context = Context in which the code that manages the object will run.
 *   iid = The identifier of the interface to be used to communicate with the object.
 * Возвращает: The requested object.
 * See_Also: $(LINK2 http://msdn.microsoft.com/en-us/library/ms686615.aspx, CoCreateInstance).
 */
IUnknown coCreateInstance(Guid clsid, IUnknown outer, ExecutionContext context, Guid iid) {
  IUnknown ret;
  if (УДАЧНО(CoCreateInstance(clsid, outer, cast(бцел)context, iid, retval(ret))))
    return ret;
  return null;
}

/**
 * Returns a reference to a running object that has been registered with OLE.
 * See_Also: $(LINK2 http://msdn2.microsoft.com/en-us/library/ms221467.aspx, GetActiveObject).
 */
IUnknown getActiveObject(ткст progId) {
  GUID clsid = clsidFromProgId(progId);
  IUnknown объ = null;
  if (УДАЧНО(GetActiveObject(clsid, null, объ)))
    return объ;

  return null;
}

/**
 * Creates a COM object of the class associated with the specified CLSID.
 * Параметры:
 *   clsid = A CLSID associated with the coclass that will be used to create the object.
 *   context = The _context in which to run the code that manages the new object with run.
 * Возвращает: A reference to the interface identified by T.
 * Примеры:
 * ---
 * if (auto doc = coCreate!(IXMLDOMDocument3)(uuidof!(DOMDocument60))) {
 *   scope(exit) doc.Release();
 * }
 * ---
 */
template coCreate(T, ExceptionPolicy policy = ExceptionPolicy.NoThrow) {

  T coCreate(U)(U clsid, ExecutionContext context = ExecutionContext.InProcessServer) {
    GUID гуид;
    static if (is(U : GUID)) {
      гуид = clsid;
    }
    else static if (is(U : ткст)) {
      try {
        гуид = GUID(clsid);
      }
      catch (ИсклФормата) {
        цел hr = CLSIDFromProgID(вЮ16н(clsid), гуид);
        if (НЕУДАЧНО(hr)) {
          static if (policy == ExceptionPolicy.Throw)
            throw new КОМИскл(hr);
          else
            return null;
        }
      }
    }
    else static assert(false);

    T ret;
    цел hr = CoCreateInstance(гуид, null, context, uuidof!(T), retval(ret));

    if (НЕУДАЧНО(hr)) {
      static if (policy == ExceptionPolicy.Throw)
        throw new КОМИскл(hr);
      else
        return null;
    }

    return ret;
  }

}

template coCreateEx(T, ExceptionPolicy policy = ExceptionPolicy.NoThrow) {

  T coCreateEx(U)(U clsid, ткст server, ExecutionContext context = ExecutionContext.InProcessServer) {
    GUID гуид;
    static if (is(U : GUID)) {
      гуид = clsid;
    }
    else static if (is(U : ткст)) {
      try {
        гуид = GUID(clsid);
      }
      catch (ИсклФормата) {
        цел hr = CLSIDFromProgID(вЮ16н(clsid), гуид);
        if (НЕУДАЧНО(hr)) {
          static if (policy == ExceptionPolicy.Throw)
            throw new КОМИскл(hr);
          else
            return null;
        }
      }
    }

    COSERVERINFO csi;
    csi.pwszName = server.вЮ16н();

    MULTI_QI ret;
    ret.pIID = &uuidof!(T);
    цел hr = CoCreateInstanceEx(гуид, null, context, &csi, 1, &ret);

    if (НЕУДАЧНО(hr)) {
      static if (policy == ExceptionPolicy.Throw)
        throw new КОМИскл(hr);
      else
        return null;
    }

    return cast(T)ret.pItf;
  }

}

template Интерфейсы(TList...) {

  static T coCreate(T, ExceptionPolicy policy = ExceptionPolicy.NoThrow)(ExecutionContext context = ExecutionContext.InProcessServer) {
    static if (tpl.typetuple.Индекс_у!(T, TList) == -1)
      static assert(false, "'" ~ typeof(this).stringof ~ "' does not support '" ~ T.stringof ~ "'.");
    else
      return .coCreate!(T, policy)(uuidof!(typeof(this)), context);
  }

}

template QueryInterfaceImpl(TList...) {

  extern(Windows)
  цел QueryInterface(ref GUID riid, ук* ppvObject) {
    if (ppvObject is null)
      return E_POINTER;

    *ppvObject = null;

    if (riid == uuidof!(IUnknown)) {
      *ppvObject = cast(ук)cast(IUnknown)this;
    }
    else foreach (T; TList) {
      // Search the specified список of типы to see if we support the interface we're being asked for.
      if (riid == uuidof!(T)) {
        // This is the one, so we need look no further.
        *ppvObject = cast(ук)cast(T)this;
        break;
      }
    }

    if (*ppvObject is null)
      return E_NOINTERFACE;

    (cast(IUnknown)this).AddRef();
    return S_OK;
  }

}

// Реализует AddRef & Release for IUnknown subclasses.
template ReferenceCountImpl() {

  private цел refCount_ = 1;
  private бул finalized_;

  extern(Windows):

  бцел AddRef() {
    return InterlockedIncrement(refCount_);
  }

  бцел Release() {
    if (InterlockedDecrement(refCount_) == 0) {
      if (!finalized_) {
        finalized_ = true;
        runFinalizer(this);
      }

      version(D_Version2) {
        core.memory.GC.удалиОхват(cast(ук)this);
        core.memory.GC.free(cast(ук)this);
      }
      else {
        смУдалиПространство(cast(ук)this);
        cidrus.free(cast(ук)this);
      }
    }
    return refCount_;
  }

  extern(D):

  // IUnknown subclasses must manage their memory manually.
  new(т_мера sz) {
    ук p = cidrus.malloc(sz);
    if (p is null)
      throw new OutOfMemoryException;

    version(D_Version2) {
      core.memory.GC.добавьОхват(p, sz);
    }
    else {
      gc_addRangeOld(p, p + sz);
    }
    return p;
  }

}

template InterfacesTuple(T) {

  static if (is(T == Объект)) {
    alias КортежТипов!() InterfacesTuple;
  }
  static if (is(BaseTypeTuple!(T)[0] == Объект)) {
    alias КортежТипов!(BaseTypeTuple!(T)[1 .. $]) InterfacesTuple;
  }
  else {
    alias std.typetuple.БезДубликатов!(
      КортежТипов!(BaseTypeTuple!(T)[1 .. $], 
        InterfacesTuple!(BaseTypeTuple!(T)[0]))) 
      InterfacesTuple;
  }

}

/// Provides an implementation of IUnknown suitable for используя as mixin.
template IUnknownImpl(T...) {

  static if (is(T[0] : Объект))
    mixin QueryInterfaceImpl!(InterfacesTuple!(T[0]), T[1 .. $]);
  else
    mixin QueryInterfaceImpl!(T);
  mixin ReferenceCountImpl;

}

/// Provides an implementation of IDispatch suitable for используя as mixin.
template IDispatchImpl(T...) {

  mixin IUnknownImpl!(T);

  цел GetTypeInfoCount(out бцел pctinfo) {
    pctinfo = 0;
    return E_NOTIMPL;
  }

  цел GetTypeInfo(бцел iTInfo, бцел лкид, out ITypeInfo ppTInfo) {
    ppTInfo = null;
    return E_NOTIMPL;
  }

  цел GetIDsOfNames(ref GUID riid, шим** rgszNames, бцел cNames, бцел лкид, цел* rgDispId) {
    rgDispId = null;
    return E_NOTIMPL;
  }

  цел Invoke(цел dispIdMember, ref GUID riid, бцел лкид, бкрат wFlags, DISPPARAMS* pDispParams, VARIANT* pVarResult, EXCEPINFO* pExcepInfo, бцел* puArgError) {
    return DISP_E_UNKNOWNNAME;
  }

}

template AllBaseTypesOfImpl(T...) {

  static if (T.length == 0)
    alias tpl.typetuple.КортежТипа!() AllBaseTypesOfImpl;
  else
    alias tpl.typetuple.КортежТипа!(T[0],
      AllBaseTypesOfImpl!(tpl.traits.КортежТипаОснова!(T[0])),
        AllBaseTypesOfImpl!(T[1 .. $]))
    AllBaseTypesOfImpl;

}

template AllBaseTypesOf(T...) {

  alias tpl.typetuple.БезДубликатов!(AllBaseTypesOfImpl!(T)) AllBaseTypesOf;

}

/**
 * The abstract base class for COM objects that derive from IUnknown or IDispatch.
 *
 * The Реализует class provides default implementations of methods required by those interfaces. Therefore, subclasses need only override them when they 
 * specifically need to provide extra functionality. This class also overrides the new operator so that instances are not garbage collected.
 * Примеры:
 * ---
 * class MyImpl : Реализует!(IUnknown) {
 * }
 * ---
 */
abstract class Реализует(T...) : T {

  static if (tpl.typetuple.Индекс_у!(IDispatch, AllBaseTypesOf!(T)) != -1)
    mixin IDispatchImpl!(T, AllBaseTypesOf!(T));
  else
    mixin IUnknownImpl!(T, AllBaseTypesOf!(T));

}

// DMD prevents destructors from running on COM objects.
проц runFinalizer(Объект объ) {
  if (объ) {
    ClassInfo** ci = cast(ClassInfo**)cast(ук)объ;
    if (*ci) {
      if (auto c = **ci) {
        do {
          if (c.destructor) {
            auto finalizer = cast(проц function(Объект))c.destructor;
            finalizer(объ);
          }
          c = c.base;
        } while (c);
      }
    }
  }
}

/**
 * Indicates whether the specified object represents a COM object.
 * Параметры: объ = The object to check.
 * Возвращает: true if объ is a COM тип; otherwise, false.
 */
бул isCOMObject(Объект объ) {
  ClassInfo** ci = cast(ClassInfo**)cast(ук)объ;
  if (*ci !is null) {
    ClassInfo c = **ci;
    if (c !is null)
      return ((c.флаги & 1) != 0);
  }
  return false;
}

/**
 * Wraps a manually reference counted IUnknown-derived object so that its 
 * memory can be managed automatically by the D runtime's garbage collector.
 */
final class COMObject {

  private IUnknown obj_;

  /**
   * Initializes a new экземпляр with the specified IUnknown-derived object.
   * Параметры: объ = The object to wrap.
   */
  this(IUnknown объ) {
    obj_ = объ;
  }

  ~this() {
    if (obj_ !is null) {
      finalRelease(obj_);
      obj_ = null;
    }
  }

  /**
   * Retrieves the original IUnknown-derived object.
   * Возвращает: The wrapped object.
   */
  IUnknown opCast() {
    return obj_;
  }

}

// Deprecate? You should really use the scope(exit) pattern.
/**
 */
проц releaseAfter(IUnknown объ, проц delegate() block) {
  try {
    block();
  }
  finally {
    if (объ)
      объ.Release();
  }
}

// Deprecate? You should really use the scope(exit) pattern.
/**
 */
проц clearAfter(VARIANT var, проц delegate() block) {
  try {
    block();
  }
  finally {
    var.сотри();
  }
}

/**
 * Decrements the reference счёт for an object.
 */
проц tryRelease(IUnknown объ) {
  if (объ) {
    try {
      объ.Release();
    }
    catch {
    }
  }
}

/**
 * Decrements the reference счёт for an object until it reaches 0.
 */
проц finalRelease(IUnknown объ) {
  if (объ) {
    while (объ.Release() > 0) {
    }
  }
}

/**
 * Allocates a BSTR equivalent to s.
 * Параметры: s = The ткст with which to иниц the BSTR.
 * Возвращает: The BSTR equivalent to s.
 */
шим* toBstr(ткст s) {
  if (s == null)
    return null;

  return SysAllocString(вЮ16н(s));
}

/**
 * Converts a BSTR to a ткст, optionally freeing the original BSTR.
 * Параметры: bstr = The BSTR to преобразуй.
 * Возвращает: A ткст equivalent to bstr.
 */
ткст изБткст(шим* s, бул free = true) {
  if (s == null)
    return null;

  бцел len = SysStringLen(s);
  if (len == 0)
    return null;

  ткст ret = вЮ8(s[0 .. len]);
  /*цел cb = WideCharToMultiByte(CP_UTF8, 0, s, len, null, 0, null, null);
  сим[] ret = new сим[cb];
  WideCharToMultiByte(CP_UTF8, 0, s, len, ret.ptr, cb, null, null);*/

  if (free)
    SysFreeString(s);
  return cast(ткст)ret;
}


/**
 * Frees the memory occupied by the specified BSTR.
 * Параметры: bstr = The BSTR to free.
 */
проц freeBstr(шим* s) {
  if (s != null)
    SysFreeString(s);
}

бцел bstrLength(шим* s) {
  if (s == null)
    return 0;
  return SysStringLen(s);
}

extern(Windows):

шим* SysAllocString(in шим* psz);
цел SysReAllocString(шим*, in шим* psz);
шим* SysAllocStringLen(in шим* psz, бцел len);
цел SysReAllocStringLen(шим*, in шим* psz, бцел len);
проц SysFreeString(шим*);
бцел SysStringLen(шим*);
бцел SysStringByteLen(шим*);
шим* SysAllocStringByteLen(in ббайт* psz, бцел len);

extern(D):

/**
 * Provides an implementation of the IStream interface.
 */
class COMStream : Реализует!(IStream) {

  private Поток stream_;

  this(Поток поток) {
    if (поток is null)
      throw new ИсклНулевогоАргумента("поток");
    stream_ = поток;
  }

  Поток потокОснова() {
    return stream_;
  }

  цел Read(ук pv, бцел cb, ref бцел pcbRead) {
    бцел ret = stream_.читайБлок(pv, cb);
    if (&pcbRead)
      pcbRead = ret;
    return S_OK;
  }

  цел Write(in ук pv, бцел cb, ref бцел pcbWritten) {
    бцел ret = stream_.пишиБлок(pv, cb);
    if (&pcbWritten)
      pcbWritten = ret;
    return S_OK;
  }

  цел Seek(дол dlibMove, бцел dwOrigin, ref бдол plibNewPosition) {
    ППозКурсора whence;
    if (dwOrigin == STREAM_SEEK_SET)
      whence = ППозКурсора.Уст;
    else if (dwOrigin == STREAM_SEEK_CUR)
      whence = ППозКурсора.Тек;
    else if (dwOrigin == STREAM_SEEK_END)
      whence = ППозКурсора.Кон;

    бдол ret = stream_.сместись(dlibMove, whence);
    if (&plibNewPosition)
      plibNewPosition = ret;
    return S_OK;
  }

  цел SetSize(бдол libNewSize) {
    return E_NOTIMPL;
  }

  цел CopyTo(IStream поток, бдол cb, ref бдол pcbRead, ref бдол pcbWritten) {
    if (&pcbRead)
      pcbRead = 0;
    if (&pcbWritten)
      pcbWritten = 0;
    return E_NOTIMPL;
  }

  цел Commit(бцел hrfCommitFlags) {
    return E_NOTIMPL;
  }

  цел Revert() {
    return E_NOTIMPL;
  }

  цел LockRegion(бдол libOffset, бдол cb, бцел dwLockType) {
    return E_NOTIMPL;
  }

  цел UnlockRegion(бдол libOffset, бдол cb, бцел dwLockType) {
    return E_NOTIMPL;
  }

  цел Stat(out STATSTG pstatstg, бцел grfStatFlag) {
    pstatstg.тип = STGTY_STREAM;
    pstatstg.cbSize = stream_.размер;
    return S_OK;
  }

  цел Clone(out IStream ppstm) {
    ppstm = null;
    return E_NOTIMPL;
  }

}

/// Specifies the тип of член to that is to be invoked.
enum DispatchFlags : бкрат {
  InvokeMethod   = DISPATCH_METHOD,         /// Specifies that a метод is to be invoked.
  GetProperty    = DISPATCH_PROPERTYGET,    /// Specifies that the значение of a property should be returned.
  PutProperty    = DISPATCH_PROPERTYPUT,    /// Specifies that the значение of a property should be уст.
  PutRefProperty = DISPATCH_PROPERTYPUTREF  /// Specifies that the значение of a property should be уст by reference.
}

/// The exception thrown when there is an attempt to dynamically access a член that does not exist.
class MissingMemberException : Exception {

  private const ткст E_MISSINGMEMBER = "Член не найден.";

  this() {
    super(E_MISSINGMEMBER);
  }

  this(ткст сообщение) {
    super(сообщение);
  }

  this(ткст className, ткст memberName) {
    super("Член '" ~ className ~ "." ~ memberName ~ "' не найден.");
  }

}

/**
 * Invokes the specified член on the specified object.
 * Параметры:
 *   dispId = The identifier of the метод or property член to вызови.
 *   флаги = The тип of член to вызови.
 *   цель = The object on which to вызови the specified член.
 *   арги = A список containing the arguments to pass to the член to вызови.
 * Возвращает: The return значение of the invoked член.
 * Выводит исключение: КОМИскл if the call failed.
 */
VARIANT invokeMemberById(цел dispId, DispatchFlags флаги, IDispatch цель, VARIANT[] арги...) {
  арги.reverse;

  DISPPARAMS парамы;
  if (арги.length > 0) {
    парамы.rgvarg = арги.ptr;
    парамы.cArgs = арги.length;

    if (флаги & DispatchFlags.PutProperty) {
      цел dispIdNamed = DISPID_PROPERTYPUT;
      парамы.rgdispidNamedArgs = &dispIdNamed;
      парамы.cNamedArgs = 1;
    }
  }

  VARIANT рез;
  EXCEPINFO excep;
  цел hr = цель.Invoke(dispId, GUID.пустой, GetThreadLocale(), cast(бкрат)флаги, &парамы, &рез, &excep, null);

  for (auto i = 0; i < парамы.cArgs; i++) {
    парамы.rgvarg[i].сотри();
  }

  ткст errorMessage;
  if (hr == DISP_E_EXCEPTION && excep.scode != 0) {
    errorMessage = изБткст(excep.bstrDescription);
    hr = excep.scode;
  }

  switch (hr) {
    case S_OK, S_FALSE, E_ABORT:
      return рез;
    default:
      if (auto supportErrorInfo = com_cast!(ISupportErrorInfo)(цель)) {
        scope(exit) supportErrorInfo.Release();

        if (УДАЧНО(supportErrorInfo.InterfaceSupportsErrorInfo(uuidof!(IDispatch)))) {
          IErrorInfo errorInfo;
          GetErrorInfo(0, errorInfo);
          if (errorInfo !is null) {
            scope(exit) errorInfo.Release();

            шим* bstrDesc;
            if (УДАЧНО(errorInfo.GetDescription(bstrDesc)))
              errorMessage = изБткст(bstrDesc);
          }
        }
      }
      else if (errorMessage == null) {
        шим[256] буфер;
        бцел r = FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS, null, hr, 0, буфер.ptr, буфер.length + 1, null);
        if (r != 0)
          errorMessage = .вЮ8(буфер[0 .. r]);
        else
          errorMessage = фм("Operation 0x%08X did not succeed (0x%08X)", dispId, hr);
      }

      throw new КОМИскл(errorMessage, hr);
  }

  /*if (НЕУДАЧНО(hr)) {
    throw new КОМИскл(изБткст(excep.bstrDescription), hr);
  }*/

  //return рез;
}

/**
 * Invokes the specified член on the specified object.
 * Параметры:
 *   имя = The _name of the метод or property член to вызови.
 *   флаги = The тип of член to вызови.
 *   цель = The object on which to вызови the specified член.
 *   арги = A список containing the arguments to pass to the член to вызови.
 * Возвращает: The return значение of the invoked член.
 * Выводит исключение: MissingMemberException if the член is not found.
 */
VARIANT invokeMember(ткст имя, DispatchFlags флаги, IDispatch цель, VARIANT[] арги...) {
  цел dispId = DISPID_UNKNOWN;
  шим* bstrName = имя.toBstr();
  scope(exit) freeBstr(bstrName);

  if (УДАЧНО(цель.GetIDsOfNames(GUID.пустой, &bstrName, 1, GetThreadLocale(), &dispId)) && dispId != DISPID_UNKNOWN) {
    return invokeMemberById(dispId, флаги, цель, арги);
  }

  ткст typeName;
  ITypeInfo инфОТипе;
  if (УДАЧНО(цель.GetTypeInfo(0, 0, инфОТипе))) {
    scope(exit) tryRelease(инфОТипе);

    шим* bstrTypeName;
    инфОТипе.GetDocumentation(-1, &bstrTypeName, null, null, null);
    typeName = изБткст(bstrTypeName);
  }

  throw new MissingMemberException(typeName, имя);
}

private VARIANT[] argsToVariantList(TypeInfo[] типы, va_list argptr) {
  VARIANT[] список;

  foreach (тип; типы) {
    if (тип == typeid(бул)) список ~= VARIANT(va_arg!(бул)(argptr));
    else if (тип == typeid(ббайт)) список ~= VARIANT(va_arg!(ббайт)(argptr));
    else if (тип == typeid(байт)) список ~= VARIANT(va_arg!(байт)(argptr));
    else if (тип == typeid(бкрат)) список ~= VARIANT(va_arg!(бкрат)(argptr));
    else if (тип == typeid(крат)) список ~= VARIANT(va_arg!(крат)(argptr));
    else if (тип == typeid(бцел)) список ~= VARIANT(va_arg!(бцел)(argptr));
    else if (тип == typeid(цел)) список ~= VARIANT(va_arg!(цел)(argptr));
    else if (тип == typeid(бдол)) список ~= VARIANT(va_arg!(бдол)(argptr));
    else if (тип == typeid(дол)) список ~= VARIANT(va_arg!(дол)(argptr));
    else if (тип == typeid(плав)) список ~= VARIANT(va_arg!(плав)(argptr));
    else if (тип == typeid(дво)) список ~= VARIANT(va_arg!(дво)(argptr));
    else if (тип == typeid(ткст)) список ~= VARIANT(va_arg!(ткст)(argptr));
    else if (тип == typeid(IDispatch)) список ~= VARIANT(va_arg!(IDispatch)(argptr));
    else if (тип == typeid(IUnknown)) список ~= VARIANT(va_arg!(IUnknown)(argptr));
    else if (тип == typeid(VARIANT)) список ~= va_arg!(VARIANT)(argptr);
    //else if (тип == typeid(VARIANT*)) список ~= VARIANT(va_arg!(VARIANT*)(argptr));
    else if (тип == typeid(VARIANT*)) список ~= *va_arg!(VARIANT*)(argptr);
  }

  return список;
}

private проц fixArgs(ref TypeInfo[] арги, ref va_list argptr) {
  if (арги[0] == typeid(TypeInfo[]) && арги[1] == typeid(va_list)) {
    арги = va_arg!(TypeInfo[])(argptr);
    argptr = *cast(va_list*)(argptr);
  }
}

/**
 * Invokes the specified метод on the specified object.
 * Параметры:
 *   цель = The object on which to вызови the specified метод.
 *   имя = The _name of the метод to вызови.
 *   _argptr = A список containing the arguments to pass to the метод to вызови.
 * Возвращает: The return значение of the invoked метод.
 * Выводит исключение: MissingMemberException if the метод is not found.
 * Примеры:
 * ---
 * import win32.com.core;
 *
 * проц main() {
 *   auto ieApp = coCreate!(IDispatch)("InternetExplorer.Приложение");
 *   invokeMethod(ieApp, "Navigate", "http://www.amazon.co.uk");
 * }
 * ---
 */
R invokeMethod(R = VARIANT)(IDispatch цель, ткст имя, ...) {
  auto арги = _arguments;
  auto argptr = _argptr;
  if (арги.length == 2) fixArgs(арги, argptr);

  VARIANT ret = invokeMember(имя, DispatchFlags.InvokeMethod, цель, argsToVariantList(арги, argptr));
  static if (is(R == VARIANT)) {
    return ret;
  }
  else {
    return com_cast!(R)(ret);
  }
}

/**
 * Gets the значение of the specified property on the specified object.
 * Параметры:
 *   цель = The object on which to вызови the specified property.
 *   имя = The _name of the property to вызови.
 *   _argptr = A список containing the arguments to pass to the property.
 * Возвращает: The return значение of the invoked property.
 * Выводит исключение: MissingMemberException if the property is not found.
 * Примеры:
 * ---
 * import win32.com.core, stdrus;
 *
 * проц main() {
 *   // Create an экземпляр of the Microsoft Word automation object.
 *   IDispatch wordApp = coCreate!(IDispatch)("Word.Приложение");
 *
 *   // Invoke the Документы property 
 *   //   wordApp.Документы
 *   IDispatch documents = getProperty!(IDispatch)(цель, "Документы");
 *
 *   // Invoke the Count property on the Документы object
 *   //   documents.Count
 *   VARIANT счёт = getProperty(documents, "Count");
 *
 *   // Display the значение of the Count property.
 *   скажифнс("There are %s documents", счёт);
 * }
 * ---
 */
R getProperty(R = VARIANT)(IDispatch цель, ткст имя, ...) {
  auto арги = _arguments;
  auto argptr = _argptr;
  if (арги.length == 2) fixArgs(арги, argptr);

  VARIANT ret = invokeMember(имя, DispatchFlags.GetProperty, цель, argsToVariantList(арги, argptr));
  static if (is(R == VARIANT))
    return ret;
  else
    return com_cast!(R)(ret);
}

/**
 * Sets the значение of a specified property on the specified object.
 * Параметры:
 *   цель = The object on which to вызови the specified property.
 *   имя = The _name of the property to вызови.
 *   _argptr = A список containing the arguments to pass to the property.
 * Выводит исключение: MissingMemberException if the property is not found.
 * Примеры:
 * ---
 * import win32.com.core;
 *
 * проц main() {
 *   // Create an Excel automation object.
 *   IDispatch excelApp = coCreate!(IDispatch)("Excel.Приложение");
 *
 *   // Set the Visible property to true
 *   //   excelApp.Visible = true
 *   setProperty(excelApp, "Visible", true);
 *
 *   // Get the Workbooks property
 *   //   workbooks = excelApp.Workbooks
 *   IDispatch workbooks = getProperty!(IDispatch)(excelApp, "Workbooks");
 *
 *   // Invoke the Add метод on the Workbooks property
 *   //   newWorkbook = workbooks.Add()
 *   IDispatch newWorkbook = invokeMethod!(IDispatch)(workbooks, "Add");
 *
 *   // Get the Worksheets property and the Worksheet at индекс 1
 *   //   worksheet = excelApp.Worksheets[1]
 *   IDispatch worksheet = getProperty!(IDispatch)(excelApp, "Worksheets", 1);
 *
 *   // Get the Cells property and уст the Cell object at column 5, row 3 to a ткст
 *   //   worksheet.Cells[5, 3] = "данные"
 *   setProperty(worksheet, "Cells", 5, 3, "данные");
 * }
 * ---
 */
проц setProperty(IDispatch цель, ткст имя, ...) {
  auto арги = _arguments;
  auto argptr = _argptr;
  if (арги.length == 2) fixArgs(арги, argptr);

  if (арги.length > 1) {
    VARIANT v = invokeMember(имя, DispatchFlags.GetProperty, цель);
    if (auto indexer = v.pdispVal) {
      scope(exit) indexer.Release();

      v = invokeMemberById(0, DispatchFlags.GetProperty, indexer, argsToVariantList(арги[0 .. 1], argptr));
      if (auto значение = v.pdispVal) {
        scope(exit) значение.Release();

        invokeMemberById(0, DispatchFlags.PutProperty, значение, argsToVariantList(арги[1 .. $], argptr + арги[0].tsize));
        return;
      }
    }
  }
  else {
    invokeMember(имя, DispatchFlags.PutProperty, цель, argsToVariantList(арги, argptr));
  }
}

/// ditto
проц setRefProperty(IDispatch цель, ткст имя, ...) {
  auto арги = _arguments;
  auto argptr = _argptr;
  if (арги.length == 2) fixArgs(арги, argptr);

  invokeMember(имя, DispatchFlags.PutRefProperty, цель, argsToVariantList(арги, argptr));
}

version(D_Version2)
mixin("
struct com_ref(T) if (is(T : IUnknown)) {

  T obj_;

  alias obj_ this;

  this(U)(U объ) {
    obj_ = cast(T)объ;
  }

  ~this() {
    отпусти();
    obj_ = null;
  }

  проц opAssign(IUnknown объ) {
    отпусти();
    obj_ = cast(T)объ;
    addRef();
  }

  static com_ref opCall(U)(U объ) {
    return com_ref(объ);
  }

  проц addRef() {
    if (obj_ !is null)
      obj_.AddRef();
  }

  проц отпусти() {
    if (obj_ !is null) {
      try {
        if (obj_.Release() == 0)
          obj_ = null;
      }
      catch {
      }
    }
  }

  бул isNull() {
    return (obj_ is null);
  }

}
");