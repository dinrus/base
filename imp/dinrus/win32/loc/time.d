/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.loc.time;

import win32.base.core,
  win32.base.time,
  win32.base.native,
  win32.utils.registry,
  win32.loc.consts,
  win32.loc.core;
import stdrus, cidrus : memcpy;

debug import stdrus : скажифнс;

// This module or classes contained within must not have any 
// static ctors/dtors, otherwise there will be circular references 
// with win32.loc.core.

private const дол ТиковВМиллисек = 10000;
private const дол ТиковВСек = ТиковВМиллисек * 1000;
private const дол ТиковВМинуту = ТиковВСек * 60;
private const дол ТиковВЧас = ТиковВМинуту * 60;
private const дол ТиковВДень = ТиковВЧас * 24;

private const цел МиллисекВСек = 1000;
private const цел МиллисекВМинуту = МиллисекВСек * 60;
private const цел МиллисекВЧас = МиллисекВМинуту * 60;
private const цел МиллисекВДень = МиллисекВЧас * 24;

private const цел ДнейВГод = 365;
private const цел ДнейВ4Года = ДнейВГод * 4 + 1;
private const цел ДнейВ100Годах = ДнейВ4Года * 25 - 1;
private const цел ДнейВ400Годах = ДнейВ100Годах * 4 + 1;

private const цел ДнейДо1601 = ДнейВ400Годах * 4;
private const цел ДнейДо1899 = ДнейВ400Годах * 4 + ДнейВ100Годах * 3 - 367;
private const цел ДнейДо10000 = ДнейВ400Годах * 25 - 366;

private const цел[] ДнейДоМесяца365 = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];
private const цел[] ДнейДоМесяца366 = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366];

private enum ПЧастьДаты {
  День,
  ДеньГода,
  Месяц,
  Год
}

private цел дайЧастьДаты(дол тики, ПЧастьДаты часть) {
  цел n = cast(цел)(тики / ТиковВДень);
  цел y400 = n / ДнейВ400Годах;
  n -= y400 * ДнейВ400Годах;
  цел y100 = n / ДнейВ100Годах;
  if (y100 == 4) y100 = 3;
  n -= y100 * ДнейВ100Годах;
  цел y4 = n / ДнейВ4Года;
  n -= y4 * ДнейВ4Года;
  цел y1 = n / ДнейВГод;
  if (y1 == 4) y1 = 3;
  if (часть == ПЧастьДаты.Год)
    return y400 * 400 + y100 * 100 + y4 * 4 + y1 + 1;
  n -= y1 * ДнейВГод;
  if (часть == ПЧастьДаты.ДеньГода)
    return n + 1;
  бул leap = y1 == 3 && (y4 != 24 || y100 == 3);
  цел[] дни = leap ? ДнейДоМесяца366 : ДнейДоМесяца365;
  цел m = n >> 5 + 1;
  while (n >= дни[m]) m++;
  if (часть == ПЧастьДаты.Месяц) return m;
  return n - дни[m - 1] + 1;
}

/*//////////////////////////////////////////////////////////////////////////////////////////
// Calendars                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////*/

/**
 * Represents время in divisions such as weeks, months and years.
 */
abstract class Календарь {

  /// Represents the текущ эра.
  const цел ТекущаяЭра = 0;

  /*package*/ бул isReadOnly_;

  /**
   * Returns a ДатаВрем that is the specified число of миллисекунды away from the specified ДатаВрем.
   * Параметры:
   *   время = The ДатаВрем to добавь to.
   *   значение = The число of миллисекунды to добавь.
   */
  ДатаВрем добавьМиллисек(ДатаВрем время, цел значение) {
    дол millis = cast(дол)(cast(дво)значение + (значение >= 0 ? 0.5 : -0.5));
    return ДатаВрем(время.тики + (millis * ТиковВМиллисек));
  }

  /**
   * Returns a ДатаВрем that is the specified число of секунды away from the specified ДатаВрем.
   * Параметры:
   *   время = The ДатаВрем to добавь to.
   *   значение = The число of секунды to добавь.
   */
  ДатаВрем добавьСек(ДатаВрем время, цел значение) {
    дол millis = cast(дол)(cast(дво)значение * МиллисекВСек + (значение >= 0 ? 0.5 : -0.5));
    return ДатаВрем(время.тики + (millis * ТиковВМиллисек));
  }

  /**
   * Returns a ДатаВрем that is the specified число of минуты away from the specified ДатаВрем.
   * Параметры:
   *   время = The ДатаВрем to добавь to.
   *   значение = The число of минуты to добавь.
   */
  ДатаВрем добавьМинут(ДатаВрем время, цел значение) {
    дол millis = cast(дол)(cast(дво)значение * МиллисекВМинуту + (значение >= 0 ? 0.5 : -0.5));
    return ДатаВрем(время.тики + (millis * ТиковВМиллисек));
  }

  /**
   * Returns a ДатаВрем that is the specified число of часы away from the specified ДатаВрем.
   * Параметры:
   *   время = The ДатаВрем to добавь to.
   *   значение = The число of часы to добавь.
   */
  ДатаВрем добавьЧасов(ДатаВрем время, цел значение) {
    дол millis = cast(дол)(cast(дво)значение * МиллисекВЧас + (значение >= 0 ? 0.5 : -0.5));
    return ДатаВрем(время.тики + (millis * ТиковВМиллисек));
  }

  /**
   * Returns a ДатаВрем that is the specified число of дни away from the specified ДатаВрем.
   * Параметры:
   *   время = The ДатаВрем to добавь to.
   *   значение = The число of дни to добавь.
   */
  ДатаВрем добавьДней(ДатаВрем время, цел значение) {
    дол millis = cast(дол)(cast(дво)значение * МиллисекВДень + (значение >= 0 ? 0.5 : -0.5));
    return ДатаВрем(время.тики + (millis * ТиковВМиллисек));
  }

  /**
   * Returns a ДатаВрем that is the specified число of weeks away from the specified ДатаВрем.
   * Параметры:
   *   время = The ДатаВрем to добавь to.
   *   значение = The число of weeks to добавь.
   */
  ДатаВрем добавьНедель(ДатаВрем время, цел значение) {
    return добавьДней(время, значение * 7);
  }

  /**
   * Returns a ДатаВрем that is the specified число of months away from the specified ДатаВрем.
   * Параметры:
   *   время = The ДатаВрем to добавь to.
   *   значение = The число of months to добавь.
   */
  abstract ДатаВрем добавьМесяцев(ДатаВрем время, цел значение);

  /**
   * Returns a ДатаВрем that is the specified число of years away from the specified ДатаВрем.
   * Параметры:
   *   время = The ДатаВрем to добавь to.
   *   значение = The число of years to добавь.
   */
  abstract ДатаВрем добавьЛет(ДатаВрем время, цел значение);

  /**
   * Returns the день of the week in the specified ДатаВрем.
   * Параметры: время = The ДатаВрем to читай.
   */
  abstract ПДеньНедели дайДеньНедели(ДатаВрем время);

  /**
   * Returns the день of the месяц in the specified ДатаВрем.
   * Параметры: время = The ДатаВрем to читай.
   */
  abstract цел дайДеньМесяца(ДатаВрем время);

  /**
   * Returns the день of the год in the specified ДатаВрем.
   * Параметры: время = The ДатаВрем to читай.
   */
  abstract цел дайДеньГода(ДатаВрем время);

  /**
   * Returns the week of the год in the specified ДатаВрем.
   * Параметры:
   *   время = The ДатаВрем to читай.
   *   правило = A значение that defines a календарь week.
   *   первыйДеньНедели = A значение that represents the first день of the week.
   */
  цел дайНеделюГода(ДатаВрем время, ППравилоКалендарнойНедели правило, ПДеньНедели первыйДеньНедели) {

    цел getWeekOfYearFirstDay() {
      цел dayOfYear = дайДеньГода(время) - 1;
      цел dayOfFirstDay = cast(цел)дайДеньНедели(время) - (dayOfYear % 7);
      return (dayOfYear + ((dayOfFirstDay - cast(цел)первыйДеньНедели + 14) % 7)) / 7 + 1;
    }

    цел getWeekOfYearFullDays(цел fullDays) {
      цел dayOfYear = дайДеньГода(время) - 1;
      цел dayOfFirstDay = cast(цел)дайДеньНедели(время) - (dayOfYear % 7);
      цел смещение = (cast(цел)первыйДеньНедели - dayOfFirstDay + 14) % 7;
      if (смещение != 0 && смещение >= fullDays) смещение -= 7;
      return (dayOfYear - смещение) / 7 + 1;
    }

    switch (правило) {
      case ППравилоКалендарнойНедели.ПервыйДень:
        return getWeekOfYearFirstDay();

      case ППравилоКалендарнойНедели.ПервПолнНеделя:
        return getWeekOfYearFullDays(7);

      case ППравилоКалендарнойНедели.ПервЧетырёхДневнНеделя:
        return getWeekOfYearFullDays(4);

      default:
        break;
    }
    throw new win32.base.core.ИсклАргумента("правило");
  }

  /**
   * Returns the часы значение in the specified ДатаВрем.
   */
  цел дайЧас(ДатаВрем время) {
    return cast(цел)((время.тики / ТиковВЧас) % 24);
  }

  /**
   * Returns the минуты значение in the specified ДатаВрем.
   */
  цел дайМинуту(ДатаВрем время) {
    return cast(цел)((время.тики / ТиковВМинуту) % 60);
  }

  /**
   * Returns the секунды значение in the specified ДатаВрем.
   */
  цел дайСекунду(ДатаВрем время) {
    return cast(цел)((время.тики / ТиковВСек) % 60);
  }

  /**
   * Returns the миллисекунды значение in the specified ДатаВрем.
   */
  дво дайМиллисекунды(ДатаВрем время) {
    return cast(дво)((время.тики / ТиковВМиллисек) % 1000);
  }

  /**
   * Returns the эра in the specified ДатаВрем.
   */
  abstract цел дайЭру(ДатаВрем время);

  /**
   * Returns the год in the specified ДатаВрем.
   */
  abstract цел дайГод(ДатаВрем время);

  /**
   * Returns the месяц in the specified ДатаВрем.
   */
  abstract цел дайМесяц(ДатаВрем время);

  /**
   * Returns the число of дни in the specified год and эра.
   */
  abstract цел дайДнейВГоду(цел год, цел эра);

  /// ditto
  цел дайДнейВГоду(цел год) {
    return дайДнейВГоду(год, ТекущаяЭра);
  }

  /**
   * Returns the число of дни in the specified год, месяц and эра.
   */
  abstract цел дайДнейВМесяце(цел год, цел месяц, цел эра);

  /// ditto
  цел дайДнейВМесяце(цел год, цел месяц) {
    return дайДнейВМесяце(год, месяц, ТекущаяЭра);
  }

  /**
   * Returns the число of months in the specified год and эра.
   */
  abstract цел дайМесяцевВГоду(цел год, цел эра);

  /// ditto
  цел дайМесяцевВГоду(цел год) {
    return дайМесяцевВГоду(год, ТекущаяЭра);
  }

  /**
   * Returns the leap месяц for the specified год and эра.
   */
  цел дайВисокосныйМесяц(цел год, цел эра) {
    if (високосныйГод_ли(год)) {
      цел months = дайМесяцевВГоду(год, эра);
      for (цел месяц = 1; месяц <= months; месяц++) {
        if (високосныйМесяц_ли(год, месяц, эра))
          return месяц;
      }
    }
    return 0;
  }

  /// ditto
  цел дайВисокосныйМесяц(цел год) {
    return дайВисокосныйМесяц(год, ТекущаяЭра);
  }

  /**
   * Determines whether a день is a leap день.
   */
  abstract бул високосныйДень_ли(цел год, цел месяц, цел день, цел эра);

  /// ditto
  бул високосныйДень_ли(цел год, цел месяц, цел день) {
    return високосныйДень_ли(год, месяц, день, ТекущаяЭра);
  }

  /**
   * Determines whether a месяц is a leap месяц.
   */
  abstract бул високосныйМесяц_ли(цел год, цел месяц, цел эра);

  /// ditto
  бул високосныйМесяц_ли(цел год, цел месяц) {
    return високосныйМесяц_ли(год, месяц, ТекущаяЭра);
  }

  /**
   * Determines whether a год is a leap год.
   */
  abstract бул високосныйГод_ли(цел год, цел эра);

  /// ditto
  бул високосныйГод_ли(цел год) {
    return високосныйГод_ли(год, ТекущаяЭра);
  }

  /**
   * Gets a значение indicating whether the Календарь object is читай-only.
   */
  final бул толькоЧтен_ли() {
    return isReadOnly_;
  }

  abstract цел[] эры();

  protected цел ид() {
    return -1;
  }

  /*package*/ цел внутреннийИд() {
    return ид;
  }

}

// We can only query NLS for the смещенГода, but certain calendars need a bit more info.
private struct ИнфОбЭре {

  цел эра;
  дол стартТики;
  цел смещенГода;

}

private ИнфОбЭре[] иницИнфОбЭре(цел cal) {
  switch (cal) {
    case CAL_JAPAN:
      return [ ИнфОбЭре(4, ДатаВрем(1989, 1, 8).тики, 1988),
        ИнфОбЭре(3, ДатаВрем(1926, 12, 25).тики, 1925),
        ИнфОбЭре(2, ДатаВрем(1912, 7, 30).тики, 1911),
        ИнфОбЭре(1, ДатаВрем(1868, 1, 1).тики, 1867) ];
    case CAL_TAIWAN:
      return [ ИнфОбЭре(1, ДатаВрем(1912, 1, 1).тики, 1911) ];
    case CAL_KOREA:
      return [ ИнфОбЭре(1, ДатаВрем(1, 1, 1).тики, -2333) ];
    case CAL_THAI:
      return [ ИнфОбЭре(1, ДатаВрем(1, 1, 1).тики, -543) ];
    default:
  }
  return null;
}

// Defaults for calendars.
/*package*/ class ДанныеКалендаря {

  ткст[] именаЭр;
  цел текущЭра;

  this(ткст имяЛокали, бцел идКалендаря) {
    //getCalendarData(имяЛокали, идКалендаря);

    switch (идКалендаря) {
      case CAL_GREGORIAN:
        if (именаЭр.length == 0)
          именаЭр = [ "A.D." ];
        break;
      case CAL_GREGORIAN_US:
        именаЭр = [ "A.D." ];
        break;
      case CAL_JAPAN:
        именаЭр = [ "\u660e\u6cbb", "\u5927\u6b63", "\u662d\u548c", "\u5e73\u6210" ];
        break;
      case CAL_TAIWAN:
        именаЭр = [ "\u4e2d\u83ef\u6c11\u570b" ];
        break;
      case CAL_KOREA:
        именаЭр = [ "\ub2e8\uae30" ];
        break;
      case CAL_HIJRI:
        if (имяЛокали == "dv-MV")
          именаЭр = [ "\u0780\u07a8\u0796\u07b0\u0783\u07a9" ];
        else
          именаЭр = [ "\u0629\u0631\u062c\u0647\u0644\u0627\u062f\u0639\u0628" ];
        break;
      case CAL_THAI:
        именаЭр = [ "\u0e1e.\u0e28." ];
        break;
      case CAL_HEBREW:
        именаЭр = [ "C.E." ];
        break;
      case CAL_GREGORIAN_ME_FRENCH:
        именаЭр = [ "ap. J.-C." ];
        break;
      case CAL_GREGORIAN_ARABIC, CAL_GREGORIAN_XLIT_ENGLISH, CAL_GREGORIAN_XLIT_FRENCH:
        именаЭр = [ "\u0645" ];
        break;
      default:
        именаЭр = [ "A.D." ];
        break;
    }

    текущЭра = именаЭр.length;
  }
  /+
  private бул getCalendarData(ткст имяЛокали, бцел идКалендаря) {
    return EnumCalendarInfo(имяЛокали, идКалендаря, CAL_SERASTRING, именаЭр);
  }

  private static бул EnumCalendarInfo(ткст имяЛокали, бцел календарь, бцел calType, out ткст[] рез) {
    static ткст[] времн;

    extern(Windows)
    static цел EnumCalendarInfoProc(шим* lpCalendarInfoString) {
      времн ~= вЮ8(lpCalendarInfoString[0 .. wcslen(lpCalendarInfoString)]);
      return 1;
    }

    бцел культура;
    if (!найдиКультуруПоИмени(имяЛокали, имяЛокали, культура))
      return false;

    времн = null;
    if (!EnumCalendarInfo(&EnumCalendarInfoProc, культура, календарь, calType))
      return false;
    рез = времн.реверсни;
    return true;
  }
+/
}

/**
 * Represents the Gregorian календарь.
 */
class ГрегорианскийКалендарь : Календарь {

  /// Represents the текущ эра.
  const цел ADEra = 1;

  private static ГрегорианскийКалендарь defaultInstance_;

  private GregorianCalendarType type_;
  private цел[] eras_;
  private ИнфОбЭре[] eraInfo_;

  /**
   */
  this(GregorianCalendarType тип = GregorianCalendarType.Localized) {
    type_ = тип;
  }

  // Used internally by Japan, Taiwai, Korea, Thai calendars.
  private this(ИнфОбЭре[] eraInfo) {
    eraInfo_ = eraInfo;
  }

  override ДатаВрем добавьМесяцев(ДатаВрем время, цел значение) {
    цел y = дайЧастьДаты(время.тики, ПЧастьДаты.Год);
    цел m = дайЧастьДаты(время.тики, ПЧастьДаты.Месяц);
    цел d = дайЧастьДаты(время.тики, ПЧастьДаты.День);

    цел n = m - 1 + значение;
    if (n < 0) {
      m = 12 + (n + 1) % 12;
      y += (n - 11) / 12;
    }
    else {
      m = n % 12 + 1;
      y += n / 12;
    }

    цел[] daysToMonth = (y % 4 == 0 && (y % 100 != 0 || y % 400 == 0)) ? ДнейДоМесяца366 : ДнейДоМесяца365;
    цел дни = daysToMonth[m] - daysToMonth[m - 1];
    if (d > дни)
      d = дни;

    return ДатаВрем(датаВТики(y, m, d) + время.тики % ТиковВДень);
  }

  override ДатаВрем добавьЛет(ДатаВрем время, цел значение) {
    return добавьМесяцев(время, значение * 12);
  }

  override ПДеньНедели дайДеньНедели(ДатаВрем время) {
    return cast(ПДеньНедели)(cast(цел)((время.тики / ТиковВДень) + 1) % 7);
  }

  override цел дайДеньМесяца(ДатаВрем время) {
    return дайЧастьДаты(время.тики, ПЧастьДаты.Месяц);
  }

  override цел дайДеньГода(ДатаВрем время) {
    return дайЧастьДаты(время.тики, ПЧастьДаты.ДеньГода);
  }

  override цел дайЭру(ДатаВрем время) {
    дол тики = время.тики;
    for (цел i = 0; i < eraInfo_.length; i++) {
      if (тики >= eraInfo_[i].стартТики)
        return eraInfo_[i].эра;
    }

    return ADEra;
  }

  override цел дайГод(ДатаВрем время) {
    дол тики = время.тики;
    цел год = дайЧастьДаты(тики, ПЧастьДаты.Год);

    for (цел i = 0; i < eraInfo_.length; i++) {
      if (тики >= eraInfo_[i].стартТики)
        return год - eraInfo_[i].смещенГода;
    }

    return год;
  }

  override цел дайМесяц(ДатаВрем время) {
    return дайЧастьДаты(время.тики, ПЧастьДаты.Месяц);
  }

  alias Календарь.дайДнейВГоду дайДнейВГоду;
  override цел дайДнейВГоду(цел год, цел эра) {
    return (год % 4 == 0 && (год % 100 != 0 || год % 400 == 0)) ? 366 : 365;
  }

  alias Календарь.дайДнейВМесяце дайДнейВМесяце;
  override цел дайДнейВМесяце(цел год, цел месяц, цел эра) {
    цел[] дни = (год % 4 == 0 && (год % 100 != 0 || год % 400 == 0)) ? ДнейДоМесяца366 : ДнейДоМесяца365;
    return дни[месяц] - дни[месяц - 1];
  }

  alias Календарь.дайМесяцевВГоду дайМесяцевВГоду;
  override цел дайМесяцевВГоду(цел год, цел эра) {
    return 12;
  }

  alias Календарь.високосныйДень_ли високосныйДень_ли;
  override бул високосныйДень_ли(цел год, цел месяц, цел день, цел эра) {
    if (!високосныйГод_ли(год))
      return false;
    return (месяц == 2 && день == 29);
  }

  alias Календарь.високосныйМесяц_ли високосныйМесяц_ли;
  override бул високосныйМесяц_ли(цел год, цел месяц, цел эра) {
    return false;
  }

  alias Календарь.високосныйГод_ли високосныйГод_ли;
  override бул високосныйГод_ли(цел год, цел эра) {
    return (год % 4 == 0 && (год % 100 != 0 || год % 400 == 0));
  }

  override цел[] эры() {
    if (eras_ == null) {
      if (eraInfo_ == null) eras_ = [ ADEra ];
      else for (цел i = 0; i < eraInfo_.length; i++)
        eras_[i] = eraInfo_[i].эра;
    }
    return eras_;
  }

  protected override цел ид() {
    return cast(цел)type_;
  }

  /*package*/ static ГрегорианскийКалендарь defaultInstance() {
    if (defaultInstance_ is null)
      defaultInstance_ = new ГрегорианскийКалендарь;
    return defaultInstance_;
  }

  private static дол датаВТики(цел год, цел месяц, цел день) {
    цел[] дни = (год % 4 == 0 && (год % 100 != 0 || год % 400 == 0)) ? ДнейДоМесяца366 : ДнейДоМесяца365;
    цел y = год - 1;
    цел n = y * 365 + y / 4 - y / 100 + y / 400 + дни[месяц - 1] + день - 1;
    return n * ТиковВДень;
  }

}

/**
 * Represents the Japanese календарь.
 */
class ЯпонскийКалендарь : Календарь {

  private static ИнфОбЭре[] eraInfo_;
  private ГрегорианскийКалендарь base_;

  /**
   */
  this() {
    if (eraInfo_ == null)
      eraInfo_ = иницИнфОбЭре(CAL_JAPAN);

    base_ = new ГрегорианскийКалендарь(eraInfo_);
  }

  override ДатаВрем добавьМесяцев(ДатаВрем время, цел значение) {
    return base_.добавьМесяцев(время, значение);
  }

  override ДатаВрем добавьЛет(ДатаВрем время, цел значение) {
    return base_.добавьЛет(время, значение);
  }

  override ПДеньНедели дайДеньНедели(ДатаВрем время) {
    return base_.дайДеньНедели(время);
  }

  override цел дайДеньМесяца(ДатаВрем время) {
    return base_.дайДеньМесяца(время);
  }

  override цел дайДеньГода(ДатаВрем время) {
    return base_.дайДеньГода(время);
  }

  override цел дайЭру(ДатаВрем время) {
    return base_.дайЭру(время);
  }

  override цел дайГод(ДатаВрем время) {
    return base_.дайГод(время);
  }

  override цел дайМесяц(ДатаВрем время) {
    return base_.дайМесяц(время);
  }

  alias Календарь.дайДнейВГоду дайДнейВГоду;
  override цел дайДнейВГоду(цел год, цел эра) {
    return base_.дайДнейВГоду(год, эра);
  }

  alias Календарь.дайДнейВМесяце дайДнейВМесяце;
  override цел дайДнейВМесяце(цел год, цел месяц, цел эра) {
    return base_.дайДнейВМесяце(год, месяц, эра);
  }

  alias Календарь.дайМесяцевВГоду дайМесяцевВГоду;
  override цел дайМесяцевВГоду(цел год, цел эра) {
    return base_.дайМесяцевВГоду(год, эра);
  }

  alias Календарь.високосныйДень_ли високосныйДень_ли;
  override бул високосныйДень_ли(цел год, цел месяц, цел день, цел эра) {
    return base_.високосныйДень_ли(год, месяц, день, эра);
  }

  alias Календарь.високосныйМесяц_ли високосныйМесяц_ли;
  override бул високосныйМесяц_ли(цел год, цел месяц, цел эра) {
    return base_.високосныйМесяц_ли(год, месяц, эра);
  }

  alias Календарь.високосныйГод_ли високосныйГод_ли;
  override бул високосныйГод_ли(цел год, цел эра) {
    return base_.високосныйГод_ли(год, эра);
  }

  override цел[] эры() {
    return base_.эры;
  }

  protected override цел ид() {
    return CAL_JAPAN;
  }

}

/**
 * Represents the Taiwan календарь.
 */
class ТайваньскийКалендарь : Календарь {

  private static ИнфОбЭре[] eraInfo_;
  private ГрегорианскийКалендарь base_;

  /**
   */
  this() {
    if (eraInfo_ == null)
      eraInfo_ = иницИнфОбЭре(CAL_TAIWAN);

    base_ = new ГрегорианскийКалендарь(eraInfo_);
  }

  override ДатаВрем добавьМесяцев(ДатаВрем время, цел значение) {
    return base_.добавьМесяцев(время, значение);
  }

  override ДатаВрем добавьЛет(ДатаВрем время, цел значение) {
    return base_.добавьЛет(время, значение);
  }

  override ПДеньНедели дайДеньНедели(ДатаВрем время) {
    return base_.дайДеньНедели(время);
  }

  override цел дайДеньМесяца(ДатаВрем время) {
    return base_.дайДеньМесяца(время);
  }

  override цел дайДеньГода(ДатаВрем время) {
    return base_.дайДеньГода(время);
  }

  override цел дайЭру(ДатаВрем время) {
    return base_.дайЭру(время);
  }

  override цел дайГод(ДатаВрем время) {
    return base_.дайГод(время);
  }

  override цел дайМесяц(ДатаВрем время) {
    return base_.дайМесяц(время);
  }

  alias Календарь.дайДнейВГоду дайДнейВГоду;
  override цел дайДнейВГоду(цел год, цел эра) {
    return base_.дайДнейВГоду(год, эра);
  }

  alias Календарь.дайДнейВМесяце дайДнейВМесяце;
  override цел дайДнейВМесяце(цел год, цел месяц, цел эра) {
    return base_.дайДнейВМесяце(год, месяц, эра);
  }

  alias Календарь.дайМесяцевВГоду дайМесяцевВГоду;
  override цел дайМесяцевВГоду(цел год, цел эра) {
    return base_.дайМесяцевВГоду(год, эра);
  }

  alias Календарь.високосныйДень_ли високосныйДень_ли;
  override бул високосныйДень_ли(цел год, цел месяц, цел день, цел эра) {
    return base_.високосныйДень_ли(год, месяц, день, эра);
  }

  alias Календарь.високосныйМесяц_ли високосныйМесяц_ли;
  override бул високосныйМесяц_ли(цел год, цел месяц, цел эра) {
    return base_.високосныйМесяц_ли(год, месяц, эра);
  }

  alias Календарь.високосныйГод_ли високосныйГод_ли;
  override бул високосныйГод_ли(цел год, цел эра) {
    return base_.високосныйГод_ли(год, эра);
  }

  override цел[] эры() {
    return base_.эры;
  }

  protected override цел ид() {
    return CAL_TAIWAN;
  }

}

/**
 * Represents the Korean календарь.
 */
class КорейскийКалендарь : Календарь {

  private static ИнфОбЭре[] eraInfo_;
  private ГрегорианскийКалендарь base_;

  const цел KoreanEra = 1;

  /**
   */
  this() {
    if (eraInfo_ == null)
      eraInfo_ = иницИнфОбЭре(CAL_KOREA);

    base_ = new ГрегорианскийКалендарь(eraInfo_);
  }

  override ДатаВрем добавьМесяцев(ДатаВрем время, цел значение) {
    return base_.добавьМесяцев(время, значение);
  }

  override ДатаВрем добавьЛет(ДатаВрем время, цел значение) {
    return base_.добавьЛет(время, значение);
  }

  override ПДеньНедели дайДеньНедели(ДатаВрем время) {
    return base_.дайДеньНедели(время);
  }

  override цел дайДеньМесяца(ДатаВрем время) {
    return base_.дайДеньМесяца(время);
  }

  override цел дайДеньГода(ДатаВрем время) {
    return base_.дайДеньГода(время);
  }

  override цел дайЭру(ДатаВрем время) {
    return base_.дайЭру(время);
  }

  override цел дайГод(ДатаВрем время) {
    return base_.дайГод(время);
  }

  override цел дайМесяц(ДатаВрем время) {
    return base_.дайМесяц(время);
  }

  alias Календарь.дайДнейВГоду дайДнейВГоду;
  override цел дайДнейВГоду(цел год, цел эра) {
    return base_.дайДнейВГоду(год, эра);
  }

  alias Календарь.дайДнейВМесяце дайДнейВМесяце;
  override цел дайДнейВМесяце(цел год, цел месяц, цел эра) {
    return base_.дайДнейВМесяце(год, месяц, эра);
  }

  alias Календарь.дайМесяцевВГоду дайМесяцевВГоду;
  override цел дайМесяцевВГоду(цел год, цел эра) {
    return base_.дайМесяцевВГоду(год, эра);
  }

  alias Календарь.високосныйДень_ли високосныйДень_ли;
  override бул високосныйДень_ли(цел год, цел месяц, цел день, цел эра) {
    return base_.високосныйДень_ли(год, месяц, день, эра);
  }

  alias Календарь.високосныйМесяц_ли високосныйМесяц_ли;
  override бул високосныйМесяц_ли(цел год, цел месяц, цел эра) {
    return base_.високосныйМесяц_ли(год, месяц, эра);
  }

  alias Календарь.високосныйГод_ли високосныйГод_ли;
  override бул високосныйГод_ли(цел год, цел эра) {
    return base_.високосныйГод_ли(год, эра);
  }

  override цел[] эры() {
    return base_.эры;
  }

  protected override цел ид() {
    return CAL_KOREA;
  }

}

/**
 * Represents the Korean календарь.
 */
class ТаиБуддистскийКалендарь : Календарь {

  private static ИнфОбЭре[] eraInfo_;
  private ГрегорианскийКалендарь base_;

  const цел ThaiBuddhistEra = 1;

  /**
   */
  this() {
    if (eraInfo_ == null)
      eraInfo_ = иницИнфОбЭре(CAL_THAI);

    base_ = new ГрегорианскийКалендарь(eraInfo_);
  }

  override ДатаВрем добавьМесяцев(ДатаВрем время, цел значение) {
    return base_.добавьМесяцев(время, значение);
  }

  override ДатаВрем добавьЛет(ДатаВрем время, цел значение) {
    return base_.добавьЛет(время, значение);
  }

  override ПДеньНедели дайДеньНедели(ДатаВрем время) {
    return base_.дайДеньНедели(время);
  }

  override цел дайДеньМесяца(ДатаВрем время) {
    return base_.дайДеньМесяца(время);
  }

  override цел дайДеньГода(ДатаВрем время) {
    return base_.дайДеньГода(время);
  }

  override цел дайЭру(ДатаВрем время) {
    return base_.дайЭру(время);
  }

  override цел дайГод(ДатаВрем время) {
    return base_.дайГод(время);
  }

  override цел дайМесяц(ДатаВрем время) {
    return base_.дайМесяц(время);
  }

  alias Календарь.дайДнейВГоду дайДнейВГоду;
  override цел дайДнейВГоду(цел год, цел эра) {
    return base_.дайДнейВГоду(год, эра);
  }

  alias Календарь.дайДнейВМесяце дайДнейВМесяце;
  override цел дайДнейВМесяце(цел год, цел месяц, цел эра) {
    return base_.дайДнейВМесяце(год, месяц, эра);
  }

  alias Календарь.дайМесяцевВГоду дайМесяцевВГоду;
  override цел дайМесяцевВГоду(цел год, цел эра) {
    return base_.дайМесяцевВГоду(год, эра);
  }

  alias Календарь.високосныйДень_ли високосныйДень_ли;
  override бул високосныйДень_ли(цел год, цел месяц, цел день, цел эра) {
    return base_.високосныйДень_ли(год, месяц, день, эра);
  }

  alias Календарь.високосныйМесяц_ли високосныйМесяц_ли;
  override бул високосныйМесяц_ли(цел год, цел месяц, цел эра) {
    return base_.високосныйМесяц_ли(год, месяц, эра);
  }

  alias Календарь.високосныйГод_ли високосныйГод_ли;
  override бул високосныйГод_ли(цел год, цел эра) {
    return base_.високосныйГод_ли(год, эра);
  }

  override цел[] эры() {
    return base_.эры;
  }

  protected override цел ид() {
    return CAL_THAI;
  }

}

/*//////////////////////////////////////////////////////////////////////////////////////////
// Date/Time                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////*/

enum ПВидДатаВремени {
  Неуказан,
  Utc,
  Локаль
}

/**
 * Represents an instant in время.
 */
struct ДатаВрем {

  private const бдол KindUnspecified = 0x0000000000000000;
  private const бдол KindUtc         = 0x4000000000000000;
  private const бдол KindLocal       = 0x8000000000000000;
  private const бдол KindMask        = 0xC000000000000000;
  private const бдол TicksMask       = 0x3FFFFFFFFFFFFFFF;
  private const цел KindShift         = 0x3E;

  /// Represents the smallest possible ДатаВрем значение.
  static ДатаВрем мин = { 0 };

  /// Represents the largest possible ДатаВрем значение.
  static ДатаВрем макс = { ДнейДо10000 * ТиковВДень - 1 };

  private бдол data_;

  /**
   * Initializes a new экземпляр.
   */
  static ДатаВрем opCall(дол тики, ПВидДатаВремени вид = ПВидДатаВремени.Неуказан) {
    ДатаВрем сам;
    сам.data_ = cast(бдол)тики | (cast(бдол)вид << KindShift);
    return сам;
  }

  /**
   * Initializes a new экземпляр.
   */
  static ДатаВрем opCall(цел год, цел месяц, цел день, ПВидДатаВремени вид = ПВидДатаВремени.Неуказан) {
    ДатаВрем сам;
    сам.data_ = cast(бдол)датаВТики(год, месяц, день) | (cast(бдол)вид << KindShift);
    return сам;
  }

  /**
   * Initializes a new экземпляр.
   */
  static ДатаВрем opCall(цел год, цел месяц, цел день, цел час, цел минута, цел секунда, ПВидДатаВремени вид = ПВидДатаВремени.Неуказан) {
    ДатаВрем сам;
    сам.data_ = (cast(бдол)датаВТики(год, месяц, день) + времяВТики(час, минута, секунда)) | (cast(бдол)вид << KindShift);
    return сам;
  }

  /**
   * Initializes a new экземпляр.
   */
  static ДатаВрем opCall(цел год, цел месяц, цел день, цел час, цел минута, цел секунда, цел миллисекунда, ПВидДатаВремени вид = ПВидДатаВремени.Неуказан) {
    ДатаВрем сам;
    сам.data_ = (cast(бдол)датаВТики(год, месяц, день) + времяВТики(час, минута, секунда) + (миллисекунда * ТиковВМиллисек)) | (cast(бдол)вид << KindShift);
    return сам;
  }

  /**
   * Adds the specified ВремИнтервал to the значение of this экземпляр.
   */
  ДатаВрем добавь(ВремИнтервал значение) {
    return ДатаВрем(тики + значение.тики);
  }

  /// ditto
  ДатаВрем opAdd(ВремИнтервал значение) {
    return ДатаВрем(тики + значение.тики);
  }

  /// ditto
  проц opAddAssign(ВремИнтервал значение) {
    data_ += cast(бдол)значение.тики;
  }

  /**
   * Subtracts the specified число of тики from the значение of this экземпляр.
   */
  ДатаВрем отними(ВремИнтервал значение) {
    return ДатаВрем(тики - значение.тики);
  }

  /// ditto
  ДатаВрем opSub(ВремИнтервал значение) {
    return ДатаВрем(тики - значение.тики);
  }

  /// ditto
  проц opSubAssign(ВремИнтервал значение) {
    data_ -= cast(бдол)значение.тики;
  }

  /**
   * Adds the specified число of тики to the значение of this экземпляр.
   */
  ДатаВрем добавьТики(дол значение) {
    return ДатаВрем(тики + значение);
  }

  /**
   * Adds the specfied число of миллисекунды to the значение of this экземпляр.
   * Параметры: значение = A число of whole a fractional миллисекунды.
   */
  ДатаВрем добавьМиллисек(дво значение) {
    дол millis = cast(дол)(значение + (значение >= 0 ? 0.5 : -0.5));
    return добавьТики(millis * ТиковВМиллисек);
  }

  /**
   * Adds the specfied число of секунды to the значение of this экземпляр.
   * Параметры: значение = A число of whole a fractional секунды.
   */
  ДатаВрем добавьСек(дво значение) {
    дол millis = cast(дол)(значение * МиллисекВСек + (значение >= 0 ? 0.5 : -0.5));
    return добавьТики(millis * ТиковВМиллисек);
  }

  /**
   * Adds the specfied число of минуты to the значение of this экземпляр.
   * Параметры: значение = A число of whole a fractional минуты.
   */
  ДатаВрем добавьМинут(дво значение) {
    дол millis = cast(дол)(значение * МиллисекВМинуту + (значение >= 0 ? 0.5 : -0.5));
    return добавьТики(millis * ТиковВМиллисек);
  }

  /**
   * Adds the specfied число of часы to the значение of this экземпляр.
   * Параметры: значение = A число of whole a fractional часы.
   */
  ДатаВрем добавьЧасов(дво значение) {
    дол millis = cast(дол)(значение * МиллисекВЧас + (значение >= 0 ? 0.5 : -0.5));
    return добавьТики(millis * ТиковВМиллисек);
  }

  /**
   * Adds the specfied число of дни to the значение of this экземпляр.
   * Параметры: значение = A число of whole a fractional дни.
   */
  ДатаВрем добавьДней(дво значение) {
    дол millis = cast(дол)(значение * МиллисекВДень + (значение >= 0 ? 0.5 : -0.5));
    return добавьТики(millis * ТиковВМиллисек);
  }

  /**
   * Adds the specified число of months to the значение of this экземпляр.
   * Параметры: значение = A число of months.
   */
  ДатаВрем добавьМесяцев(цел значение) {
    цел y = дайЧастьДаты(тики, ПЧастьДаты.Год);
    цел m = дайЧастьДаты(тики, ПЧастьДаты.Месяц);
    цел d = дайЧастьДаты(тики, ПЧастьДаты.День);

    цел n = m - 1 + значение;
    if (n < 0) {
      m = 12 + (n + 1) % 12;
      y += (n - 11) / 12;
    }
    else {
      m = n % 12 + 1;
      y += n / 12;
    }

    цел дни = днейВМесяце(y, m);
    if (d > дни)
      d = дни;

    return ДатаВрем(датаВТики(y, m, d) + тики % ТиковВДень);
  }

  /**
   * Adds the specified число of years to the значение of this экземпляр.
   * Параметры: значение = A число of years.
   */
  ДатаВрем добавьЛет(цел значение) {
    return добавьМесяцев(значение * 12);
  }

  /**
   * Converts the specified ткст representation of a date and время to its ДатаВрем equivalent.
   * Параметры:
   *   s = A ткст containing a date and время to преобразуй.
   *   провайдер = An object that supplies культура-specific information about s.
   */
  static ДатаВрем разбор(ткст s, ИФорматПровайдер провайдер = null) {
    return разбериДатуВремя(s, ФорматДатыВремени.дай(провайдер));
  }

  /**
   * Converts the specified ткст representation of a date and время to its ДатаВрем equivalent.
   * Параметры:
   *   s = A ткст containing a date and время to преобразуй.
   *   format = A _format specifier that defines the required _format of s.
   *   провайдер = An object that supplies культура-specific information about s.
   */
  static ДатаВрем разбериТочно(ткст s, ткст format, ИФорматПровайдер провайдер = null) {
    return разбериДатуВремяТочно(s, format, ФорматДатыВремени.дай(провайдер));
  }

  /**
   * Converts the specified ткст representation of a date and время to its ДатаВрем equivalent.
   * Параметры:
   *   s = A ткст containing a date and время to преобразуй.
   *   форматы = An array of allowable _formats of s.
   *   провайдер = An object that supplies культура-specific information about s.
   */
  static ДатаВрем разбериТочно(ткст s, ткст[] форматы, ИФорматПровайдер провайдер = null) {
    return parseDateTimeExactMultiple(s, форматы, ФорматДатыВремени.дай(провайдер));
  }

  /**
   * Converts the specified ткст representation of a date and время to its ДатаВрем equivalent.
   * Параметры:
   *   s = A ткст containing a date and время to преобразуй.
   *   рез = The ДатаВрем equivalent to the date and время specified in s.
   */
  static бул пробуйРазбор(ткст s, out ДатаВрем рез) {
    return пробуйРазборДатыВремени(s, ФорматДатыВремени.текущ, рез);
  }

  /**
   * Converts the specified ткст representation of a date and время to its ДатаВрем equivalent.
   * Параметры:
   *   s = A ткст containing a date and время to преобразуй.
   *   провайдер = An object that supplies культура-specific formatting information.
   *   рез = The ДатаВрем equivalent to the date and время specified in s.
   */
  static бул пробуйРазбор(ткст s, ИФорматПровайдер провайдер, out ДатаВрем рез) {
    return пробуйРазборДатыВремени(s, ФорматДатыВремени.дай(провайдер), рез);
  }

  /**
   * Converts the specified ткст representation of a date and время to its ДатаВрем equivalent.
   * Параметры:
   *   s = A ткст containing a date and время to преобразуй.
   *   format = A _format specifier that defines the required _format of s.
   *   провайдер = An object that supplies культура-specific formatting information.
   *   рез = The ДатаВрем equivalent to the date and время specified in s.
   */
  static бул пробуйРазборТочно(ткст s, ткст format, ИФорматПровайдер провайдер, out ДатаВрем рез) {
    return пробуйРазборДатыВремениТочно(s, format, ФорматДатыВремени.дай(провайдер), рез);
  }

  /**
   * Converts the specified ткст representation of a date and время to its ДатаВрем equivalent.
   * Параметры:
   *   s = A ткст containing a date and время to преобразуй.
   *   форматы = An array of allowable _formats of s.
   *   провайдер = An object that supplies культура-specific formatting information.
   *   рез = The ДатаВрем equivalent to the date and время specified in s.
   */
  static бул пробуйРазборТочно(ткст s, ткст[] форматы, ИФорматПровайдер провайдер, out ДатаВрем рез) {
    return tryParseDateTimeExactMultiple(s, форматы, ФорматДатыВремени.дай(провайдер), рез);
  }

  /**
   * Converts the значение of this экземпляр to its equivalent ткст representation.
   * Параметры:
   *   format = A ДатаВрем _format ткст.
   *   провайдер = An object that supplies культура-specific formatting information.
   */
  ткст вТкст(ткст format, ИФорматПровайдер провайдер) {
    version(D_Version2) {
      return formatDateTime(this, format, ФорматДатыВремени.дай(провайдер));
    }
    else {
      return formatDateTime(*this, format, ФорматДатыВремени.дай(провайдер));
    }
  }

  /// ditto
  ткст вТкст(ткст format) {
    version(D_Version2) {
      return formatDateTime(this, format, ФорматДатыВремени.текущ);
    }
    else {
      return formatDateTime(*this, format, ФорматДатыВремени.текущ);
    }
  }

  /// ditto
  ткст вТкст() {
    version(D_Version2) {
      return formatDateTime(this, null, ФорматДатыВремени.текущ);
    }
    else {
      return formatDateTime(*this, null, ФорматДатыВремени.текущ);
    }
  }

  /**
   */
  ткст toShortDateString() {
    version(D_Version2) {
      return formatDateTime(this, "d", ФорматДатыВремени.текущ);
    }
    else {
      return formatDateTime(*this, "d", ФорматДатыВремени.текущ);
    }
  }

  /**
   */
  ткст toLongDateString() {
    version(D_Version2) {
      return formatDateTime(this, "D", ФорматДатыВремени.текущ);
    }
    else {
      return formatDateTime(*this, "D", ФорматДатыВремени.текущ);
    }
  }

  /**
   */
  ткст toShortTimeString() {
    version(D_Version2) {
      return formatDateTime(this, "t", ФорматДатыВремени.текущ);
    }
    else {
      return formatDateTime(*this, "t", ФорматДатыВремени.текущ);
    }
  }

  /**
   */
  ткст toLongTimeString() {
    version(D_Version2) {
      return formatDateTime(this, "T", ФорматДатыВремени.текущ);
    }
    else {
      return formatDateTime(*this, "T", ФорматДатыВремени.текущ);
    }
  }

  /**
   * Compares two ДатаВрем instances and returns in integer that determines whether the first 
   * is earlier than, the same as, or later than the секунда.
   * Параметры:
   *   d1 = The first экземпляр.
   *   d2 = The секунда экземпляр.
   */
  static цел сравни(ДатаВрем d1, ДатаВрем d2) {
    if (d1.тики > d2.тики)
      return 1;
    else if (d1.тики < d2.тики)
      return -1;
    return 0;
  }

  /**
   * Compares the значение of this экземпляр to a specified ДатаВрем значение and indicates whether this 
   * экземпляр is earlier than, the same as, or later than the specified ДатаВрем значение.
   * Параметры: другой = The экземпляр to _compare.
   */
  цел сравниС(ДатаВрем другой) {
    if (тики > другой.тики)
      return 1;
    else if (тики < другой.тики)
      return -1;
    return 0;
  }

  /// ditto
  цел opCmp(ДатаВрем другой) {
    version(D_Version2) {
      return сравни(this, другой);
    }
    else {
      return сравни(*this, другой);
    }
  }

  /**
   * Indicates whether this экземпляр is equal to the specified ДатаВрем экземпляр.
   * Параметры: другой = The экземпляр to сравни to this экземпляр.
   */
  бул равен(ДатаВрем другой) {
    return тики == другой.тики;
  }

  /// ditto
  бул opEquals(ДатаВрем другой) {
    return равен(другой);
  }

  бцел вХэш() {
    return cast(цел)тики ^ cast(цел)(тики >> 32);
  }

  /**
   */
  ДатаВрем toLocal() {
    version(D_Version2) {
      return SystemTimeZone.текущ.toLocal(this);
    }
    else {
      return SystemTimeZone.текущ.toLocal(*this);
    }
  }

  /**
   */
  ДатаВрем toUtc() {
    version(D_Version2) {
      return SystemTimeZone.текущ.toUtc(this);
    }
    else {
      return SystemTimeZone.текущ.toUtc(*this);
    }
  }

  /**
   * Gets the _hour component.
   */
  цел час() {
    return cast(цел)((тики / ТиковВЧас) % 24);
  }

  /**
   * Gets the _minute component.
   */
  цел минута() {
    return cast(цел)((тики / ТиковВМинуту) % 60);
  }

  /**
   * Gets the _seconds component.
   */
  цел секунда() {
    return cast(цел)((тики / ТиковВСек) % 60);
  }

  /**
   * Gets the _milliseconds component.
   */
  цел миллисекунда() {
    return cast(цел)((тики / ТиковВМиллисек) % 1000);
  }

  /**
   * Gets the _day of the месяц.
   */
  цел день() {
    return дайЧастьДаты(тики, ПЧастьДаты.День);
  }

  /**
   * Gets the день of the week.
   */
  ПДеньНедели деньНедели() {
    return cast(ПДеньНедели)(cast(цел)((тики / ТиковВДень) + 1) % 7);
  }

  /**
   * Gets the день of the год.
   */
  цел dayOfYear() {
    return дайЧастьДаты(тики, ПЧастьДаты.ДеньГода);
  }

  /**
   * Gets the _month component.
   */
  цел месяц() {
    return дайЧастьДаты(тики, ПЧастьДаты.Месяц);
  }

  /**
   * Gets the _year component.
   */
  цел год() {
    return дайЧастьДаты(тики, ПЧастьДаты.Год);
  }

  /**
   * Gets the _date component.
   */
  ДатаВрем date() {
    дол тики = this.тики;
    return ДатаВрем(тики - тики % ТиковВДень);
  }

  /**
   * Gets the число of тики that represent the date and время.
   */
  дол тики() {
    return cast(дол)(data_ & TicksMask);
  }

  ПВидДатаВремени вид() {
    switch (data_ & KindMask) {
      case KindUtc:
        return ПВидДатаВремени.Utc;
      case KindLocal:
        return ПВидДатаВремени.Локаль;
      default:
    }
    return ПВидДатаВремени.Неуказан;
  }

  /**
   * Gets the число of дни in the specified _month and _year.
   * Параметры:
   *   год = The _year.
   *   месяц = The _month.
   */
  static цел днейВМесяце(цел год, цел месяц) {
    цел[] дни = високосныйГод_ли(год) ? ДнейДоМесяца366 : ДнейДоМесяца365;
    return дни[месяц] - дни[месяц - 1];
  }

  /**
   * Indicates whether the specified _year is a leap _year.
   */
  static бул високосныйГод_ли(цел год) {
    return год % 4 == 0 && (год % 100 != 0 || год % 400 == 0);
  }

  бул isDaylightSavingTime() {
    version(D_Version2) {
      return SystemTimeZone.текущ.isDaylightSavingTime(this);
    }
    else {
      return SystemTimeZone.текущ.isDaylightSavingTime(*this);
    }
  }

  /**
   * Gets a ДатаВрем that is уст to the текущ date and время, expressed as the local время.
   */
  static ДатаВрем now() {
    FILETIME utcFileTime, localFileTime;
    GetSystemTimeAsFileTime(utcFileTime);
    FileTimeToLocalFileTime(utcFileTime, localFileTime);

    дол тики = (cast(дол)localFileTime.dwHighDateTime << 32) | localFileTime.dwLowDateTime;
    return ДатаВрем(тики + (ДнейДо1601 * ТиковВДень), ПВидДатаВремени.Локаль);
  }

  /**
   * Gets a ДатаВрем that is уст to the текущ date and время, expressed as the Coordinated Universal Time (UTC).
   */
  static ДатаВрем utcNow() {
    FILETIME utcFileTime;
    GetSystemTimeAsFileTime(utcFileTime);

    дол тики = (cast(дол)utcFileTime.dwHighDateTime << 32) | utcFileTime.dwLowDateTime;
    return ДатаВрем(тики + (ДнейДо1601 * ТиковВДень), ПВидДатаВремени.Utc);
  }

  /**
   * Converts the specified Windows file время to an equivalent local время.
   * Параметры: fileTime = A Windows file время expressed in тики.
   */
  static ДатаВрем изФВремени(дол fileTime) {
    дол utcTicks = fileTime + (ДнейДо1601 * ТиковВДень);

    FILETIME utcFileTime, localFileTime;
    utcFileTime.dwHighDateTime = (cast(бцел)(utcTicks >> 32)) & 0xFFFFFFFF;
    utcFileTime.dwLowDateTime = (cast(бцел)utcTicks) & 0xFFFFFFFF;

    FileTimeToLocalFileTime(utcFileTime, localFileTime);

    дол тики = (cast(дол)localFileTime.dwHighDateTime << 32) | localFileTime.dwLowDateTime;
    return ДатаВрем(тики, ПВидДатаВремени.Локаль);
  }

  /**
   * Converts the specified Windows file время to an equivalent UTC время.
   * Параметры: fileTime = A Windows file время expressed in тики.
   */
  static ДатаВрем fromFileTimeUtc(дол fileTime) {
    дол тики = fileTime + (ДнейДо1601 * ТиковВДень);
    return ДатаВрем(тики, ПВидДатаВремени.Utc);
  }

  /**
   */
  дол toFileTime() {
    return toUtc().toFileTimeUtc();
  }

  /**
   */
  дол toFileTimeUtc() {
    дол тики = (вид == ПВидДатаВремени.Локаль) ? toUtc().тики : тики;
    тики -= (ДнейДо1601 * ТиковВДень);
    return тики;
  }

  /+дол toFileTime() {
    дол utcTicks = тики - (ДнейДо1601 * ТиковВДень);

    FILETIME utcFileTime, localFileTime;
    utcFileTime.dwHighDateTime = (utcTicks >> 32) & 0xFFFFFFFF;
    utcFileTime.dwLowDateTime = utcTicks & 0xFFFFFFFF;

    FileTimeToLocalFileTime(utcFileTime, localFileTime);

    return (cast(дол)localFileTime.dwHighDateTime << 32) | localFileTime.dwLowDateTime;
  }

  дол toFileTimeUtc() {
    return тики - (ДнейДо1601 * ТиковВДень);
  }+/

  /**
   * Converts an OLE Automation date to a ДатаВрем.
   * Параметры: d = An OLE Automation date.
   */
  static ДатаВрем fromOleDate(дво d) {
    return ДатаВрем(oleDateToTicks(d));
  }

  /**
   * Converts the значение of this экземпляр to an OLE Automation date.
   */
  дво toOleDate() {
    return ticksToOleDate(тики);
  }

  private static дол датаВТики(цел год, цел месяц, цел день) {
    цел[] дни = високосныйГод_ли(год) ? ДнейДоМесяца366 : ДнейДоМесяца365;
    цел y = год - 1;
    цел n = y * 365 + y / 4 - y / 100 + y / 400 + дни[месяц - 1] + день - 1;
    return n * ТиковВДень;
  }

  private static дол времяВТики(цел час, цел минута, цел секунда) {
    return (час * 3600 + минута * 60 + секунда) * ТиковВСек;
  }

  private static дол oleDateToTicks(дво значение) {
    дол millis = cast(дол)(значение * МиллисекВДень + (значение >= 0 ? 0.5 : -0.5));
    if (millis < 0)
      millis -= (millis % МиллисекВДень) * 2;
    millis += (ДнейДо1899 * ТиковВДень) / ТиковВМиллисек;
    return millis * ТиковВМиллисек;
  }

  private static дво ticksToOleDate(дол значение) {
    if (значение == 0)
      return 0;
    if (значение < ТиковВДень)
      значение += (ДнейДо1899 * ТиковВДень);
    дол millis = (значение - (ДнейДо1899 * ТиковВДень)) / ТиковВМиллисек;
    if (millis < 0) {
      дол фракция = millis % МиллисекВДень;
      if (фракция != 0)
        millis -= (МиллисекВДень + фракция) * 2;
    }
    return cast(дво)millis / МиллисекВДень;
  }

}

class DaylightTime {

  private ДатаВрем start_;
  private ДатаВрем end_;
  private ВремИнтервал delta_;

  this(ДатаВрем start, ДатаВрем end, ВремИнтервал delta) {
    start_ = start;
    end_ = end;
    delta_ = delta;
  }

  ДатаВрем start() {
    return start_;
  }

  ДатаВрем end() {
    return end_;
  }

  ВремИнтервал delta() {
    return delta_;
  }

}

// Not public because it only represents the текущ время zone on the computer.
// Its primary purpose is to преобразуй between Локаль and Utc время.
private class SystemTimeZone {

  private static SystemTimeZone current_;

  private дол ticksOffset_;
  private DaylightTime[цел] daylightChanges_;

  static SystemTimeZone текущ() {
    synchronized (SystemTimeZone.classinfo) {
      if (current_ is null)
        current_ = new SystemTimeZone;
      return current_;
    }
  }

  private this() {
    TIME_ZONE_INFORMATION timeZoneInfo;
    GetTimeZoneInformation(timeZoneInfo);
    ticksOffset_ = (-timeZoneInfo.Bias) * ТиковВМинуту;
  }

  бул isDaylightSavingTime(ДатаВрем время) {
    return isDaylightSavingTime(время, getDaylightChanges(время.год));
  }

  бул isDaylightSavingTime(ДатаВрем время, DaylightTime daylightTime) {
    return getUtcOffset(время, daylightTime) != ВремИнтервал.нуль;
  }

  ДатаВрем toLocal(ДатаВрем время) {
    if (время.вид == ПВидДатаВремени.Локаль)
      return время;

    дол тики = время.тики + getUtcOffsetFromUtc(время, getDaylightChanges(время.год)).тики;
    if (тики > ДатаВрем.макс.тики)
      return ДатаВрем(ДатаВрем.макс.тики, ПВидДатаВремени.Локаль);
    if (тики < ДатаВрем.мин.тики)
      return ДатаВрем(ДатаВрем.мин.тики, ПВидДатаВремени.Локаль);
    return ДатаВрем(тики, ПВидДатаВремени.Локаль);
  }

  ДатаВрем toUtc(ДатаВрем время) {
    if (время.вид == ПВидДатаВремени.Utc)
      return время;

    дол тики = время.тики - getUtcOffset(время, getDaylightChanges(время.год)).тики + ticksOffset_;
    if (тики > ДатаВрем.макс.тики)
      return ДатаВрем(ДатаВрем.макс.тики, ПВидДатаВремени.Utc);
    if (тики < ДатаВрем.мин.тики)
      return ДатаВрем(ДатаВрем.мин.тики, ПВидДатаВремени.Utc);
    return ДатаВрем(тики, ПВидДатаВремени.Utc);
  }

  DaylightTime getDaylightChanges(цел год) {

    ДатаВрем getDayOfSunday(цел год, бул fixed, цел месяц, цел деньНедели, цел день, цел час, цел минута, цел секунда, цел миллисекунда) {
      if (fixed) {
        цел d = ДатаВрем.днейВМесяце(год, месяц);
        return ДатаВрем(год, месяц, (d < день) ? d : день, час, минута, секунда, миллисекунда);
      }
      else if (день <= 4) {
        ДатаВрем время = ДатаВрем(год, месяц, 1, час, минута, секунда, миллисекунда);
        цел delta = деньНедели - cast(цел)время.деньНедели;
        if (delta < 0)
          delta += 7;
        delta += 7 * (день - 1);
        if (delta > 0)
          время = время.добавьДней(delta);
        return время;
      }
      else {
        auto cal = ГрегорианскийКалендарь.defaultInstance;
        ДатаВрем время = ДатаВрем(год, месяц, cal.дайДнейВМесяце(год, месяц), час, минута, секунда, миллисекунда);
        цел delta = cast(цел)время.деньНедели - деньНедели;
        if (delta < 0)
          delta += 7;
        if (delta > 0)
          время = время.добавьДней(-delta);
        return время;
      }
    }

    synchronized (SystemTimeZone.classinfo) {
      if (!(год in daylightChanges_)) {
        TIME_ZONE_INFORMATION timeZoneInfo;
        бцел r = GetTimeZoneInformation(timeZoneInfo);
        if (r == TIME_ZONE_ID_INVALID || timeZoneInfo.DaylightBias == 0) {
          daylightChanges_[год] = new DaylightTime(ДатаВрем.мин, ДатаВрем.макс, ВремИнтервал.нуль);
        }
        else {
          ДатаВрем start = getDayOfSunday(
            год, 
            (timeZoneInfo.DaylightDate.wYear != 0), 
            timeZoneInfo.DaylightDate.wMonth, 
            timeZoneInfo.DaylightDate.wDayOfWeek, 
            timeZoneInfo.DaylightDate.wDay, 
            timeZoneInfo.DaylightDate.wHour,
            timeZoneInfo.DaylightDate.wMinute,
            timeZoneInfo.DaylightDate.wSecond,
            timeZoneInfo.DaylightDate.wMilliseconds);
          ДатаВрем end = getDayOfSunday(
            год, 
            (timeZoneInfo.StandardDate.wYear != 0), 
            timeZoneInfo.StandardDate.wMonth, 
            timeZoneInfo.StandardDate.wDayOfWeek, 
            timeZoneInfo.StandardDate.wDay, 
            timeZoneInfo.StandardDate.wHour,
            timeZoneInfo.StandardDate.wMinute,
            timeZoneInfo.StandardDate.wSecond,
            timeZoneInfo.StandardDate.wMilliseconds);
          ВремИнтервал delta = ВремИнтервал((-timeZoneInfo.DaylightBias) * ТиковВМинуту);

          daylightChanges_[год] = new DaylightTime(start, end, delta);
        }
      }

      return daylightChanges_[год];
    }
  }

  private ВремИнтервал getUtcOffsetFromUtc(ДатаВрем время, DaylightTime daylightTime) {
    ВремИнтервал смещение = ВремИнтервал(ticksOffset_);

    if (daylightTime is null || daylightTime.delta.тики == 0)
      return смещение;

    ДатаВрем start = daylightTime.start - смещение;
    ДатаВрем end = daylightTime.end - смещение - daylightTime.delta;

    бул isDaylightSavingTime;
    if (start > end)
      isDaylightSavingTime = (время < end || время >= start);
    else
      isDaylightSavingTime = (время >= start && время < end);

    if (isDaylightSavingTime)
      смещение += daylightTime.delta;

    return смещение;
  }

  private ВремИнтервал getUtcOffset(ДатаВрем время, DaylightTime daylightTime) {
    if (daylightTime is null || время.вид == ПВидДатаВремени.Utc)
      return ВремИнтервал.нуль;

    ДатаВрем start = daylightTime.start + daylightTime.delta;
    ДатаВрем end = daylightTime.end;

    бул isDaylightSavingTime;
    if (start > end)
      isDaylightSavingTime = (время < end || время >= start);
    else
      isDaylightSavingTime = (время >= start && время < end);

    return (isDaylightSavingTime ? daylightTime.delta : ВремИнтервал.нуль);
  }

}

/*package*/ ткст formatDateTime(ДатаВрем dateTime, ткст format, ФорматДатыВремени dtf) {

  ткст expandKnownFormat(ткст format, ref ДатаВрем dateTime, ref ФорматДатыВремени dtf) {
    switch (format[0]) {
      case 'd':
        return dtf.shortDatePattern;
      case 'D':
        return dtf.longDatePattern;
      case 'f':
        return dtf.longDatePattern ~ " " ~ dtf.образецКраткогоВремени;
      case 'F':
        return dtf.полныйОбразецДатыВремени;
      case 'g':
        return dtf.общийОбразецКраткогоВремени;
      case 'G':
        return dtf.общийОбразецДлинногоВремени;
      case 'r', 'R':
        return dtf.rfc1123Pattern;
      case 's':
        return dtf.sortableDateTimePattern;
      case 't':
        return dtf.образецКраткогоВремени;
      case 'T':
        return dtf.образецДлинногоВремени;
      case 'u':
        return dtf.universalSortableDateTimePattern;
      case 'y', 'Y':
        return dtf.образецМесяцаГода;
      default:
    }
    throw new ИсклФормата("Введён неваерный ткст.");
  }

  цел parseRepeat(ткст format, цел поз, сим c) {
    цел n = поз + 1;
    while (n < format.length && format[n] == c)
      n++;
    return n - поз;
  }

  цел parseQuote(ткст format, цел поз, out ткст рез) {
    цел start = поз;
    сим quote = format[поз++];
    бул found;
    while (поз < format.length) {
      сим c = format[поз++];
      if (c == quote) {
        found = true;
        break;
      }
      else if (c == '\\') { // escaped
        if (поз < format.length)
          рез ~= format[поз++];
      }
      else
        рез ~= c;
    }
    return поз - start;
  }

  цел parseNext(ткст format, цел поз) {
    if (поз >= format.length - 1)
      return -1;
    return cast(цел)format[поз + 1];
  }

  проц formatDigits(ref ткст вывод, цел значение, цел length) {
    if (length > 2)
      length = 2;

    сим[16] буфер;
    сим* p = буфер.ptr + 16;

    цел n = значение;
    do {
      *--p = cast(сим)(n % 10 + '0');
      n /= 10;
    } while (n != 0 && p > буфер.ptr);

    цел c = cast(цел)(буфер.ptr + 16 - p);
    while (c < length && p > буфер.ptr) {
      *--p = '0';
      c++;
    }
    вывод ~= p[0 .. c];
  }

  ткст formatDayOfWeek(ПДеньНедели деньНедели, цел rpt) {
    if (rpt == 3)
      return dtf.дайСокрИмяДня(деньНедели);
    return dtf.дайИмяДня(деньНедели);
  }

  ткст formatMonth(цел месяц, цел rpt) {
    if (rpt == 3)
      return dtf.дайСокрИмяМесяца(месяц);
    return dtf.дайИмяМесяца(месяц);
  }

  if (format == null)
    format = "G";

  if (format.length == 1)
    format = expandKnownFormat(format, dateTime, dtf);

  auto cal = dtf.календарь;
  ткст рез;
  цел индекс, len;

  while (индекс < format.length) {
    сим c = format[индекс];
    цел следщ;

    switch (c) {
      case 'd':
        len = parseRepeat(format, индекс, c);
        if (len <= 2)
          formatDigits(рез, dateTime.день, len);
        else
          рез ~= formatDayOfWeek(dateTime.деньНедели, len);
        break;

      case 'M':
        len = parseRepeat(format, индекс, c);
        цел месяц = dateTime.месяц;
        if (len <= 2)
          formatDigits(рез, месяц, len);
        else
          рез ~= formatMonth(dateTime.месяц, len);
        break;

      case 'y':
        len = parseRepeat(format, индекс, c);
        цел год = dateTime.год;
        if (len <= 2)
          formatDigits(рез, год % 100, len);
        else
          formatDigits(рез, год, len);
        break;

      case 'g':
        len = parseRepeat(format, индекс, c);
        рез ~= dtf.дайИмяЭры(cal.дайЭру(dateTime));
        break;

      case 'h':
        len = parseRepeat(format, индекс, c);
        цел час = dateTime.час % 12;
        if (час == 0)
          час = 12;
        formatDigits(рез, час, len);
        break;

      case 'H':
        len = parseRepeat(format, индекс, c);
        formatDigits(рез, dateTime.час, len);
        break;

      case 'm':
        len = parseRepeat(format, индекс, c);
        formatDigits(рез, dateTime.минута, len);
        break;

      case 's':
        len = parseRepeat(format, индекс, c);
        formatDigits(рез, dateTime.секунда, len);
        break;

      case 'f', 'F':
        const ткст[] fixedFormats = [
          "0", "00", "000", "0000", "00000", "000000", "0000000"
        ];

        len = parseRepeat(format, индекс, c);
        if (len <= 7) {
          дол frac = dateTime.тики % ТиковВСек;
          frac /= cast(дол)stdrus.степень(cast(real)10, 7 - len);
          рез ~= win32.loc.num.фмЦел(cast(цел)frac, fixedFormats[len - 1], Культура.константа);
        }
        else
          throw new ИсклФормата("Введён неподобающий текст.");
        break;

      case 't':
        len = parseRepeat(format, индекс, c);
        if (len == 1) {
          if (dateTime.час < 12) {
            if (dtf.amDesignator.length >= 1)
              рез ~= dtf.amDesignator[0];
          }
          else if (dtf.pmDesignator.length >= 1)
            рез ~= dtf.pmDesignator[0];
        }
        else
          рез ~= (dateTime.час < 12) ? dtf.amDesignator : dtf.pmDesignator;
        break;

      case ':':
        len = 1;
        рез ~= dtf.разделительВремени;
        break;

      case '/':
        len = 1;
        рез ~= dtf.разделительДаты;
        break;

      case '\'', '\"':
        ткст quote;
        len = parseQuote(format, индекс, quote);
        рез ~= quote;
        break;

      case '\\':
        следщ = parseNext(format, индекс);
        if (следщ >= 0) {
          рез ~= cast(сим)следщ;
          len = 2;
        }
        else
          throw new ИсклФормата("Введён неподобающий текст.");
        break;

      default:
        len = 1;
        рез ~= c;
        break;
    }

    индекс += len;
  }

  return рез;
}

struct РезРазбораДатыВремени {
  цел год = -1;
  цел месяц = -1;
  цел день = -1;
  цел час;
  цел минута;
  цел секунда;
  дво фракция;
  цел меткаВремени;
  Календарь календарь;
  ВремИнтервал смещенВремПояса;
  ДатаВрем разобранДата;
}

/*package*/ ДатаВрем разбериДатуВремя(ткст s, ФорматДатыВремени dtf) {
  РезРазбораДатыВремени рез;
  if (!tryParseExactMultiple(s, dtf.дайВсеОбразцыДатыВремени(), dtf, рез))
    throw new ИсклФормата("Текст не подходит для ДатаВрем.");
  return рез.разобранДата;
}

/*package*/ ДатаВрем разбериДатуВремяТочно(ткст s, ткст format, ФорматДатыВремени dtf) {
  РезРазбораДатыВремени рез;
  if (!пробуйРазборТочно(s, format, dtf, рез))
    throw new ИсклФормата("Текст не подходит для ДатаВрем.");  
  return рез.разобранДата;
}

/*package*/ ДатаВрем parseDateTimeExactMultiple(ткст s, ткст[] форматы, ФорматДатыВремени dtf) {
  РезРазбораДатыВремени рез;
  if (!tryParseExactMultiple(s, форматы, dtf, рез))
    throw new ИсклФормата("Текст не подходит для ДатаВрем.");  
  return рез.разобранДата;
}

/*package*/ бул пробуйРазборДатыВремени(ткст s, ФорматДатыВремени dtf, out ДатаВрем рез) {
  рез = ДатаВрем.мин;
  РезРазбораДатыВремени r;
  if (!tryParseExactMultiple(s, dtf.дайВсеОбразцыДатыВремени(), dtf, r))
    return false;
  рез = r.разобранДата;
  return true;
}

/*package*/ бул пробуйРазборДатыВремениТочно(ткст s, ткст format, ФорматДатыВремени dtf, out ДатаВрем рез) {
  рез = ДатаВрем.мин;
  РезРазбораДатыВремени r;
  if (!пробуйРазборТочно(s, format, dtf, r))
    return false;
  рез = r.разобранДата;
  return true;
}

/*package*/ бул tryParseDateTimeExactMultiple(ткст s, ткст[] форматы, ФорматДатыВремени dtf, out ДатаВрем рез) {
  рез = ДатаВрем.мин;
  РезРазбораДатыВремени r;
  if (!tryParseExactMultiple(s, форматы, dtf, r))
    return false;
  рез = r.разобранДата;
  return true;
}

private бул tryParseExactMultiple(ткст s, ткст[] форматы, ФорматДатыВремени dtf, ref РезРазбораДатыВремени рез) {
  foreach (format; форматы) {
    if (пробуйРазборТочно(s, format, dtf, рез))
      return true;
  }
  return false;
}

private бул пробуйРазборТочно(ткст s, ткст pattern, ФорматДатыВремени dtf, ref РезРазбораДатыВремени рез) {

  бул doParse() {

    цел parseDigits(ткст s, ref цел поз, цел max) {
      цел рез = s[поз++] - '0';
      while (max > 1 && поз < s.length && s[поз] >= '0' && s[поз] <= '9') {
        рез = рез * 10 + s[поз++] - '0';
        --max;
      }
      return рез;
    }

    бул parseOne(ткст s, ref цел поз, ткст значение) {
      if (s[поз .. поз + значение.length] != значение)
        return false;
      поз += значение.length;
      return true;
    }

    цел parseMultiple(ткст s, ref цел поз, ткст[] значения) {
      цел рез = -1, max;
      foreach (i, значение; значения) {
        if (значение.length == 0 || s.length - поз < значение.length)
          continue;

        if (s[поз .. поз + значение.length] == значение) {
          if (рез == 0 || значение.length > max) {
            рез = i + 1;
            max = значение.length;
          }
        }
      }
      поз += max;
      return рез;
    }

    ВремИнтервал parseTimeZoneOffset(ткст s, ref цел поз) {
      бул знак;
      if (поз < s.length) {
        if (s[поз] == '-') {
          знак = true;
          поз++;
        }
        else if (s[поз] == '+')
          поз++;
      }
      цел час = parseDigits(s, поз, 2);
      цел минута;
      if (поз < s.length) {
        if (s[поз] == ':')
          поз++;
        минута = parseDigits(s, поз, 2);
      }
      ВремИнтервал рез = ВремИнтервал(час, минута, 0);
      if (знак)
        рез = -рез;
      return рез;
    }

    рез.календарь = dtf.календарь;
    рез.год = рез.месяц = рез.день = -1;
    рез.час = рез.минута = рез.секунда = 0;
    рез.фракция = 0.0;

    цел поз, i, счёт;
    сим c;

    while (поз < pattern.length && i < s.length) {
      c = pattern[поз++];

      if (c == ' ') {
        i++;
        while (i < s.length && s[i] == ' ')
          i++;
        if (i >= s.length)
          break;
        continue;
      }

      счёт = 1;

      switch (c) {
        case 'd', 'm', 'M', 'y', 'h', 'H', 's', 't', 'f', 'F', 'z':
          while (поз < pattern.length && pattern[поз] == c) {
            поз++;
            счёт++;
          }
          break;
        case ':':
          if (!parseOne(s, i, ":"))
            return false;
          continue;
        case '/':
          if (!parseOne(s, i, "/"))
            return false;
          continue;
        case '\\':
          if (поз < pattern.length) {
            c = pattern[поз++];
            if (s[i++] != c)
              return false;
          }
          else
            return false;
          continue;
        case '\'':
          while (поз < pattern.length) {
            c = pattern[поз++];
            if (c == '\'')
              break;
            if (s[i++] != c)
              return false;
          }
          continue;
        default:
          if (s[i++] != c)
            return false;
          continue;
      }

      switch (c) {
        case 'd':
          if (счёт == 1 || счёт == 2)
            рез.день = parseDigits(s, i, 2);
          else if (счёт == 3)
            рез.день = parseMultiple(s, i, dtf.сокрИменаДней);
          else
            рез.день = parseMultiple(s, i, dtf.именаДней);
          if (рез.день == -1)
            return false;
          break;
        case 'M':
          if (счёт == 1 || счёт == 2)
            рез.месяц = parseDigits(s, i, 2);
          else if (счёт == 3)
            рез.месяц = parseMultiple(s, i, dtf.сокрИменаМесяцев);
          else
            рез.месяц = parseMultiple(s, i, dtf.именаМесяцев);
          if (рез.месяц == -1)
            return false;
          break;
        case 'y':
          if (счёт == 1 || счёт == 2)
            рез.год = parseDigits(s, i, 2);
          else
            рез.год = parseDigits(s, i, 4);
          if (рез.год == -1)
            return false;
          break;
        case 'h', 'H':
          рез.час = parseDigits(s, i, 2);
          break;
        case 'm':
          рез.минута = parseDigits(s, i, 2);
          break;
        case 's':
          рез.секунда = parseDigits(s, i, 2);
          break;
        case 't':
          if (счёт == 1)
            рез.меткаВремени = parseMultiple(s, i, cast(char[][]) ([ dtf.amDesignator[0] ] ~ [ dtf.pmDesignator[0] ]));
          else
            рез.меткаВремени = parseMultiple(s, i, cast(char[][])(dtf.amDesignator ~ dtf.pmDesignator));
          break;
        case 'f', 'F':
          parseDigits(s, i, 7);
          break;
        case 'z':
          рез.смещенВремПояса = parseTimeZoneOffset(s, i);
          break;
        default:
      }
    }

    if (поз < pattern.length || i < s.length)
      return false;

    if (рез.меткаВремени == 1) { // am
      if (рез.час == 12)
        рез.час = 0;
    }
    else if (рез.меткаВремени == 2) { // pm
      if (рез.час < 12)
        рез.час += 12;
    }

    if (рез.год == -1 || рез.месяц == -1 || рез.день == -1) {
      ДатаВрем now = ДатаВрем.now;
      if (рез.месяц == -1 && рез.день == -1) {
        if (рез.год == -1) {
          рез.год = now.год;
          рез.месяц = now.месяц;
          рез.день = now.день;
        }
        else
          рез.месяц = рез.день = 1;
      }
      else {
        if (рез.год == -1)
          рез.год = now.год;
        if (рез.месяц == -1)
          рез.месяц = 1;
        if (рез.день == -1)
          рез.день = 1;
      }
    }
    return true;
  }

  if (doParse()) {
    рез.разобранДата = ДатаВрем(рез.год, рез.месяц, рез.день, рез.час, рез.минута, рез.секунда);
    return true;
  }
  return false;
}