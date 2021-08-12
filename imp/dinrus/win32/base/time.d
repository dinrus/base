/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.base.time;

static import stdrus;

private const дол ТиковВМиллисек = 10_000;
private const дол ТиковВСек = ТиковВМиллисек * 1_000;
private const дол ТиковВМинуту = ТиковВСек * 60;
private const дол ТиковВЧас = ТиковВМинуту * 60;
private const дол ТиковВДень = ТиковВЧас * 24;

private const цел МиллисекВСек = 1_000;
private const цел МиллисекВМинуту = МиллисекВСек * 60;
private const цел МиллисекВЧас = МиллисекВМинуту * 60;
private const цел МиллисекВДень = МиллисекВЧас * 24;

private const дво МиллисекВТик = 1.0 / ТиковВМиллисек;
private const дво СекВТик = 1.0 / ТиковВСек;
private const дво МинутВТик = 1.0 / ТиковВМинуту;

/**
 * Represents a время интервал.
 */
struct ВремИнтервал {

  /// Represents the _zero ВремИнтервал значение.
  static ВремИнтервал нуль = { 0 };
  
  /// Represents the minimum ВремИнтервал значение.
  static ВремИнтервал мин = { дол.min };
  
  /// Represents the maximum ВремИнтервал значение.
  static ВремИнтервал макс = { дол.max };

  private дол ticks_;

  /**
   * Initializes a new экземпляр.
   * Параметры: тики = A время period expressed in 100-nanosecond units.
   */
  static ВремИнтервал opCall(дол тики) {
    ВремИнтервал сам;
    сам.ticks_ = тики;
    return сам;
  }

  /**
   * Initializes a new экземпляр.
   * Параметры:
   *  часы = Число of _hours.
   *  минуты = Число of _minutes.
   *  секунды = Число of _seconds.
   */
  static ВремИнтервал opCall(цел часы, цел минуты, цел секунды) {
    ВремИнтервал сам;
    сам.ticks_ = (часы * 3600 + минуты * 60 + секунды) * ТиковВСек;
    return сам;
  }

  /**
   * Initializes a new экземпляр.
   * Параметры:
   *  дни = Число of _days.
   *  часы = Число of _hours.
   *  минуты = Число of _minutes.
   *  секунды = Число of _seconds.
   *  миллисекунды = Число of _milliseconds.
   */
  static ВремИнтервал opCall(цел дни, цел часы, цел минуты, цел секунды, цел миллисекунды = 0) {
    ВремИнтервал сам;
    сам.ticks_ = ((дни * 3600 * 24 + часы * 3600 + минуты * 60 + секунды) * 1000 + миллисекунды) * ТиковВМиллисек;
    return сам;
  }

  /// Gets the _hours component.
  цел часы() {
    return cast(цел)((ticks_ / ТиковВЧас) % 24);
  }

  /// Gets the _minutes component.
  цел минуты() {
    return cast(цел)((ticks_ / ТиковВМинуту) % 60);
  }

  /// Gets the _seconds component.
  цел секунды() {
    return cast(цел)((ticks_ / ТиковВСек) % 60);
  }

  /// Gets the _milliseconds component.
  цел миллисекунды() {
    return cast(цел)((ticks_ / ТиковВМиллисек) % 1000);
  }

  /// Gets the значение of the экземпляр expressed in whole and fractional миллисекунды.
  дво всегоМиллисекунд() {
    return cast(дво)ticks_ * МиллисекВТик;
  }

  /// Gets the значение of the экземпляр expressed in whole and fractional секунды.
  дво всегоСекунд() {
    return cast(дво)ticks_ * СекВТик;
  }

  дво всегоМинут() {
    return cast(дво)ticks_ * МинутВТик;
  }

  /// Gets the _days component.
  цел дни() {
    return cast(цел)(ticks_ / ТиковВДень);
  }

  /// Returns a new экземпляр whose значение is the absolute значение of the текущ экземпляр.
  ВремИнтервал продолжительность() {
    return ВремИнтервал((ticks_ < 0) ? -ticks_ : ticks_);
  }

  /// Gets the число of _ticks.
  дол тики() {
    return ticks_;
  }

  private static ВремИнтервал интервал(дво значение, цел шкала) {
    дво d = значение * шкала;
    дво millis = d + (значение >= 0 ? 0.5 : -0.5);
    return ВремИнтервал(cast(дол)millis * ТиковВМиллисек);
  }

  /// Returns a ВремИнтервал representing a specified число of секунды.
  static ВремИнтервал изСек(дво значение) {
    return интервал(значение, МиллисекВСек);
  }

  /// Returns a ВремИнтервал representing a specified число of миллисекунды.
  static ВремИнтервал изМиллисек(дво значение) {
    return интервал(значение, 1);
  }

  /**
   * Compares two ВремИнтервал значения and returns an integer indicating whether the first is shorter than, equal to, or longer than the секунда.
   * Возвращает: -1 if t1 is shorter than t2; 0 if t1 равен t2; 1 if t1 is longer than t2.
   */
  static цел сравни(ВремИнтервал t1, ВремИнтервал t2) {
    if (t1.ticks_ > t2.ticks_)
      return 1;
    else if (t1.ticks_ < t2.ticks_)
      return -1;
    return 0;
  }

  /**
   * Compares this экземпляр to a specified ВремИнтервал and returns an integer indicating whether the first is shorter than, equal to, or longer than the секунда.
   * Возвращает: -1 if t1 is shorter than t2; 0 if t1 равен t2; 1 if t1 is longer than t2.
   */
  цел сравниС(ВремИнтервал другой) {
    if (ticks_ > другой.ticks_)
      return 1;
    else if (ticks_ < другой.ticks_)
      return -1;
    return 0;
  }

  /// ditto
  цел opCmp(ВремИнтервал другой) {
    version(D_Version2) {
      return сравни(this, другой);
    }
    else {
      return сравни(*this, другой);
    }
  }

  /**
   * Returns a значение indicating whether two instances are equal.
   * Параметры:
   *   t1 = The first ВремИнтервал.
   *   t2 = The секунды ВремИнтервал.
   * Возвращает: true if the значения of t1 and t2 are equal; otherwise, false.
   */
  static бул равен(ВремИнтервал t1, ВремИнтервал t2) {
    return t1.ticks_ == t2.ticks_;
  }

  /**
   * Returns a значение indicating whether this экземпляр is equal to another.
   * Параметры: другой = An ВремИнтервал to сравни with this экземпляр.
   * Возвращает: true if другой represents the same время интервал as this экземпляр; otherwise, false.
   */
  бул равен(ВремИнтервал другой) {
    return ticks_ == другой.ticks_;
  }

  /// ditto
  бул opEquals(ВремИнтервал другой) {
    return ticks_ == другой.ticks_;
  }

  бцел вХэш() {
    return cast(цел)ticks_ ^ cast(цел)(ticks_ >> 32);
  }

  /// Returns a ткст representation of the значение of this экземпляр.
  ткст вТкст() {
    ткст s;

    цел день = cast(цел)(ticks_ / ТиковВДень);
    дол время = ticks_ % ТиковВДень;

    if (ticks_ < 0) {
      s ~= "-";
      день = -день;
      время = -время;
    }
    if (день != 0) {
      s ~= stdrus.фм("%d", день);
      s ~= ".";
    }
    s ~= stdrus.фм("%0.2d", cast(цел)((время / ТиковВЧас) % 24));
    s ~= ":";
    s ~= stdrus.фм("%0.2d", cast(цел)((время / ТиковВМинуту) % 60));
    s ~= ":";
    s ~= stdrus.фм("%0.2d", cast(цел)((время / ТиковВСек) % 60));

    цел frac = cast(цел)(время % ТиковВСек);
    if (frac != 0) {
      s ~= ".";
      s ~= stdrus.фм("%0.7d", frac);
    }

    return s;
  }

  /// Adds the specified ВремИнтервал to this экземпляр.
  ВремИнтервал добавь(ВремИнтервал ts) {
    return ВремИнтервал(ticks_ + ts.ticks_);
  }

  /// ditto
  ВремИнтервал opAdd(ВремИнтервал ts) {
    return добавь(ts);
  }

  /// ditto
  проц opAddAssign(ВремИнтервал ts) {
    ticks_ += ts.ticks_;
  }

  /// Subtracts the specified ВремИнтервал from this экземпляр.
  ВремИнтервал отними(ВремИнтервал ts) {
    return ВремИнтервал(ticks_ - ts.ticks_);
  }

  /// ditto
  ВремИнтервал opSub(ВремИнтервал ts) {
    return отними(ts);
  }

  /// ditto
  проц opSubAssign(ВремИнтервал ts) {
    ticks_ -= ts.ticks_;
  }

  /// Returns a ВремИнтервал whose значение is the negated значение of this экземпляр.
  ВремИнтервал отриц() {
    return ВремИнтервал(-ticks_);
  }

  /// ditto
  ВремИнтервал opNeg() {
    return отриц();
  }

  ВремИнтервал opPos() {
    version(D_Version2) {
      return this;
    }
    else {
      return *this;
    }
  }

}