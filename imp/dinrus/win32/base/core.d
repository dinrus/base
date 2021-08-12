/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.base.core;

typedef ук Укз = null;

т_мера смещение_у(alias F)() {
  return F.смещение_у;
}

struct Структура(T...) {
  T поля;
}

interface ИВымещаемый {
alias dispose вымести;
  проц dispose();

}

проц используя(ИВымещаемый объ, проц delegate() block) {
  try {
    block();
  }
  finally {
    if (объ !is null)
      объ.dispose();
  }
}

// Used by клонируйОбъект.
extern(C) private Объект _d_newclass(ClassInfo info);

// Creates a shallow копируй of an object.
Объект клонируйОбъект(Объект объ) {
  if (объ is null)
    return null;

  ClassInfo ci = объ.classinfo;
  т_мера start = Объект.classinfo.init.length;
  т_мера end = ci.init.length;

  Объект clone = _d_newclass(ci);
  (cast(ук)clone)[start .. end] = (cast(ук)объ)[start .. end];
  return clone;
}

struct Опционал(T) {

  private T value_;
  private бул hasValue_;

  static Опционал opCall(T значение) {
    Опционал сам;
    сам.value_ = значение;
    сам.hasValue_ = true;
    return сам;
  }

  проц opAssign(T значение) {
    value_ = значение;
    hasValue_ = true;
  }

  T значение() {
    if (!hasValue)
      throw new ИсклНеправильнОперации;
    return value_;
  }

  бул hasValue() {
    return hasValue_;
  }

  цел opCmp(Опционал другой) {
    if (hasValue) {
      if (другой.hasValue)
        return typeid(T).сравни(&value_, &другой.value_);
      return 1;
    }
    if (другой.hasValue)
      return -1;
    return 0;
  }

  цел opEquals(Опционал другой) {
    if (hasValue) {
      if (другой.hasValue)
        return typeid(T).equals(&value_, &другой.value_);
      return false;
    }
    if (другой.hasValue)
      return false;
    return true;
  }

}

/**
 * The exception thrown when one of the arguments provided to a метод is not valid.
 */
class ИсклАргумента : Exception {

  private static const E_ARGUMENT = "Значение не входит в ожидаемый диапазон.";

  private ткст paramName_;

  this() {
    super(E_ARGUMENT);
  }

  this(ткст сообщение) {
    super(сообщение);
  }

  this(ткст сообщение, ткст paramName) {
    super(сообщение);
    paramName_ = paramName;
  }

  final ткст paramName() {
    return paramName_;
  }

}

/**
 * The exception thrown when a null reference is passed to a метод that does not accept it as a valid argument.
 */
class ИсклНулевогоАргумента : ИсклАргумента {

  private static const E_ARGUMENTNULL = "Значение не может быть null.";

  this() {
    super(E_ARGUMENTNULL);
  }

  this(ткст paramName) {
    super(E_ARGUMENTNULL, paramName);
  }

  this(ткст paramName, ткст сообщение) {
    super(сообщение, paramName);
  }

}

/**
 * The exception that is thrown when the значение of an argument passed to a метод is outside the allowable охват of значения.
 */
class ИсклАргументВнеОхвата : ИсклАргумента {

  private static const E_ARGUMENTOUTOFRANGE = "Индекс выходит за диапазон.";

  this() {
    super(E_ARGUMENTOUTOFRANGE);
  }

  this(ткст paramName) {
    super(E_ARGUMENTOUTOFRANGE, paramName);
  }

  this(ткст paramName, ткст сообщение) {
    super(сообщение, paramName);
  }

}

/**
 * The exception thrown when the format of an argument does not meet the parameter specifications of the invoked метод.
 */
class ИсклФормата : Exception {

  private static const E_FORMAT = "Значение указано в неверном формате.";

  this() {
    super(E_FORMAT);
  }

  this(ткст сообщение) {
    super(сообщение);
  }

}

/**
 * The exception thrown for invalid casting.
 */
class ИсклПриведенияКТипу : Exception {

  private static const E_INVALIDCAST = "Заданное приведение к типу не действует.";

  this() {
    super(E_INVALIDCAST);
  }

  this(ткст сообщение) {
    super(сообщение);
  }

}

/**
 * The exception thrown when a метод call is invalid.
 */
class ИсклНеправильнОперации : Exception {

  private static const E_INVALIDOPERATION = "Операция не действительна.";

  this() {
    super(E_INVALIDOPERATION);
  }

  this(ткст сообщение) {
    super(сообщение);
  }

}

/**
 * The exception thrown when a requested метод or operation is not implemented.
 */
class ИсклНеРеализовано : Exception {

  private static const E_NOTIMPLEMENTED = "Эта операция не реализована.";

  this() {
    super(E_NOTIMPLEMENTED);
  }

  this(ткст сообщение) {
    super(сообщение);
  }

}

/**
 * The exception thrown when an invoked метод is not supported.
 */
class ИсклНеПоддерживается : Exception {

  private static const E_NOTSUPPORTED = "Указанный метод не поддерживается.";

  this() {
    super(E_NOTSUPPORTED);
  }

  this(ткст сообщение) {
    super(сообщение);
  }

}

/**
 * The exception thrown when there is an attempt to dereference a null reference.
 */
class ИсклНулевойССылки : Exception {

  private static const E_NULLREFERENCE = "Ссылка на объект не указавает на его экземпляр.";

  this() {
    super(E_NULLREFERENCE);
  }

  this(ткст сообщение) {
    super(сообщение);
  }

}

/**
 * The exception thrown when the operating system denies access.
 */
class ИсклНесанкционированныйДоступ : Exception {

  private static const E_UNAUTHORIZEDACCESS = "Доступ запрещён.";

  this() {
    super(E_UNAUTHORIZEDACCESS);
  }

  this(ткст сообщение) {
    super(сообщение);
  }

}

/**
 * The exception thrown when a security ошибка is detected.
 */
class ИсклБезопасности : Exception {

  private static const E_SECURITY = "Ошибка безопасности.";

  this() {
    super(E_SECURITY);
  }

  this(ткст сообщение) {
    super(сообщение);
  }

}

/**
 * The exception thrown for errors in an arithmetic, casting or conversion operation.
 */
class АрифмИскл : Exception {

  private static const E_ARITHMETIC = "Переполнение или недобор при арифметической операции.";

  this() {
    super(E_ARITHMETIC);
  }

  this(ткст сообщение) {
    super(сообщение);
  }

}

/**
 * The exception thrown when an arithmetic, casting or conversion operation results in an overflow.
 */
class ИсклПереполнения : АрифмИскл {

  private const E_OVERFLOW = "Арифметическая операция привела в переполнению.";

  this() {
    super(E_OVERFLOW);
  }

  this(ткст сообщение) {
    super(сообщение);
  }

}

version(D_Version2) {
  class OutOfMemoryException : Exception {

    private const E_OUTOFMEMORY = "Выход за пределы памяти.";

    this() {
      super(E_OUTOFMEMORY);
    }

    this(ткст сообщение) {
      super(сообщение);
    }

  }
}