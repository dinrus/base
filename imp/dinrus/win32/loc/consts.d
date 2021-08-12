/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.loc.consts;

/// Определяет типы списков культур, которые могут быть получены с пом. Культура.дайКультуры.
enum ПТипыКультур {
  Нейтрал  = 0x1,               /// Cultures associated with a язык but not a страна/region.
  Специфич = 0x2,               /// Cultures specific to a страна/region.
  Все      = Нейтрал | Специфич /// _All cultures, including neutral and specific cultures.
}

/// Defines the ткст comparison опции to use with Коллятор.
enum ПОпцииСравнения {
  None                = 0x0,        /// Indicates the default option for ткст comparisons.
  ИгнорРег          = 0x1,        /// Indicates that the ткст comparison must ignore case.
  ИгнорНеПробел      = 0x2,        /// Indicates that the ткст comparison must ignore nonspacing combining characters, such as diacritics.
  ИгнорСимволы       = 0x4,        /// Indicates that the ткст comparison must ignore symbols, such as white-space characters and punctuation.
  ИгнорШирину         = 0x10,       /// Indicates that the ткст comparison must ignore the character ширина.
  //Ordinal           = 0x10000000,
  //OrdinalIgnoreCase = 0x20000000
}

/// Specifies the день of the week.
enum ПДеньНедели {
  Воскресенье,    /// Indicates _Sunday.
  Понедельник,    /// Indicates _Monday.
  Вторник,   /// Indicates _Tuesday.
  Среда, /// Indicates _Wednesday.
  Четверг,  /// Indicates _Thursday.
  Пятница,    /// Indicates _Friday.
  Суббота   /// Indicates _Saturday.
}

/// Defines rules for determining the first week of the год.
enum ППравилоКалендарнойНедели {
  ПервыйДень,        ///
  ПервПолнНеделя,   ///
  ПервЧетырёхДневнНеделя ///
}

/// Defines the different язык versions of the Gregorian календарь.
enum GregorianCalendarType {
  Localized             = 1,  /// The localized version of the Gregorian календарь.
  USEnglish             = 2,  /// The U.S. English version of the Gregorian календарь.
  MiddleEastFrench      = 9,  /// The Middle East French version of the Gregorian календарь.
  Arabic                = 10, /// The _Arabic version of the Gregorian календарь.
  TransliteratedEnglish = 11, /// The transliterated English version of the Gregorian календарь.
  TransliteratedFrench  = 12  /// The transliterated French version of the Gregorian календарь.
}

/// Determines the styles allowed in numeric ткст arguments passed to разбор and пробуйРазбор methods.
enum ПСтилиЧисел {
  None           = 0x0,   ///
  LeadingWhite   = 0x1,   ///
  TrailingWhite  = 0x2,   ///
  LeadingSign    = 0x4,   ///
  TrailingSign   = 0x8,   ///
  Parentheses    = 0x10,  ///
  DecimalPoint   = 0x20,  ///
  Thousands      = 0x40,  ///
  Exponent       = 0x80,  ///
  CurrencySymbol = 0x100, ///
  HexSpecifier   = 0x200, ///
  Integer        = LeadingWhite | TrailingWhite | LeadingSign,                                          ///
  Float          = LeadingWhite | TrailingWhite | LeadingSign | DecimalPoint | Exponent,                ///
  Число         = LeadingWhite | TrailingWhite | LeadingSign | TrailingSign | DecimalPoint | Thousands ///
}