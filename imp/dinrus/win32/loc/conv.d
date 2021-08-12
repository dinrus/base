/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.loc.conv;

private import win32.base.core,
  win32.loc.consts,
  win32.loc.core,
  win32.loc.time,
  win32.loc.num;

/**
 * Converts the specified _value to its equivalent ткст representation.
 */
ткст вТкст(T)(T значение, ткст format = null, ИФорматПровайдер провайдер = null) {
  static if (is(T == ббайт)
    || is(T == бкрат)
    || is(T == бцел))
    return фмБцел(cast(бцел)значение, format, ФорматЧисла.дай(провайдер));
  else static if (is(T == бдол))
    return фмБдол(значение, format, ФорматЧисла.дай(провайдер));
  else static if (is(T == байт)
    || is(T == крат)
    || is(T == цел))
    return фмЦел(cast(цел)значение, format, ФорматЧисла.дай(провайдер));
  else static if (is(T == дол))
    return фмДол(значение, format, ФорматЧисла.дай(провайдер));
  else static if (is(T == плав))
    return фмПлав(значение, format, ФорматЧисла.дай(провайдер));
  else static if (is(T == дво))
    return фмПлав(значение, format, ФорматЧисла.дай(провайдер));
  else static if (is(T == бул))
    return значение ? "True" : "False";
  else static if (is(T == сим))
    return [значение];
  else static if (is(T == шим))
    return stdrus.вЮ8([значение]);
  else static if (is(T == ткст))
    return значение;
  static if (is(T == struct)) {
    static if (is(T == ДатаВрем))
      return значение.вТкст(format, ФорматДатыВремени.дай(провайдер));
    else static if (is(T == win32.com.core.Decimal))
      return фмДесятичн(значение, format, ФорматЧисла.дай(провайдер));
    else static if (is(typeof(T.вТкст)))
      return значение.вТкст();
    else
      return typeid(T).вТкст();
  }
  else static if (is(T E == Enum))
    return вТкст(cast(E)значение, format, провайдер);
  //!! else
    //!! throw new win32.base.core.ИсклПриведенияКТипу("Cannot преобразуй from '" ~ T.stringof ~ "' to 'ткст'.");
}

/**
 * Converts a ткст representation of a число to its numeric equivalent.
 */
T разбор(T)(ткст s, ПСтилиЧисел style = ПСтилиЧисел.None, ИФорматПровайдер провайдер = null) {
  static if (is(T == ббайт)
    || is(T == бкрат)
    || is(T == бцел))
    return cast(T)parseUInt(s, (style == ПСтилиЧисел.None) ? ПСтилиЧисел.Integer : style, ФорматЧисла.дай(провайдер));
  else static if (is(T == байт)
    || is(T == крат)
    || is(T == цел))
    return cast(T)parseInt(s, (style == ПСтилиЧисел.None) ? ПСтилиЧисел.Integer : style, ФорматЧисла.дай(провайдер));
  else static if (is(T == бдол))
    return parseULong(s, (style == ПСтилиЧисел.None) ? ПСтилиЧисел.Integer : style, ФорматЧисла.дай(провайдер));
  else static if (is(T == дол))
    return parseLong(s, (style == ПСтилиЧисел.None) ? ПСтилиЧисел.Integer : style, ФорматЧисла.дай(провайдер));
  else static if (is(T == плав))
    return parseFloat(s, (style == ПСтилиЧисел.None) ? ПСтилиЧисел.Float | ПСтилиЧисел.Thousands : style, ФорматЧисла.дай(провайдер));
  else static if (is(T == дво))
    return parseDouble(s, (style == ПСтилиЧисел.None) ? ПСтилиЧисел.Float | ПСтилиЧисел.Thousands : style, ФорматЧисла.дай(провайдер));
  else static if (is(T == win32.com.core.Decimal))
    return parseDecimal(s, (style == ПСтилиЧисел.None) ? ПСтилиЧисел.Число : style, ФорматЧисла.дай(провайдер));
  else
    static assert(false, "Cannot преобразуй ткст to '" ~ T.stringof ~ "'.");
}

/**
 * Converts a ткст representation of a число to its numeric equivalent. The return значение indicates whether the conversion succeeded or failed.
 */
бул пробуйРазбор(T)(ткст s, out T рез, ПСтилиЧисел style = ПСтилиЧисел.None, ИФорматПровайдер провайдер = null) {
  static if (is(T == бцел))
    return tryParseUInt(s, (style == ПСтилиЧисел.None) ? ПСтилиЧисел.Integer : style, ФорматЧисла.дай(провайдер), рез);
  else static if (is(T == цел))
    return tryParseInt(s, (style == ПСтилиЧисел.None) ? ПСтилиЧисел.Integer : style, ФорматЧисла.дай(провайдер), рез);
  else static if (is(T == бдол))
    return tryParseULong(s, (style == ПСтилиЧисел.None) ? ПСтилиЧисел.Integer : style, ФорматЧисла.дай(провайдер), рез);
  else static if (is(T == дол))
    return tryParseLong(s, (style == ПСтилиЧисел.None) ? ПСтилиЧисел.Integer : style, ФорматЧисла.дай(провайдер), рез);
  else static if (is(T == плав))
    return tryParseFloat(s, (style == ПСтилиЧисел.None) ? ПСтилиЧисел.Float | ПСтилиЧисел.Thousands : style, ФорматЧисла.дай(провайдер), рез);
  else static if (is(T == дво))
    return tryParseDouble(s, (style == ПСтилиЧисел.None) ? ПСтилиЧисел.Float | ПСтилиЧисел.Thousands : style, ФорматЧисла.дай(провайдер), рез);
  else static if (is(T == win32.com.core.Decimal))
    return tryParseDecimal(s, (style == ПСтилиЧисел.None) ? ПСтилиЧисел.Число : style, ФорматЧисла.дай(провайдер), рез);
  return false;
}