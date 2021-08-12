/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.media.geometry;

import stdrus;
 import win32.base.math : мин, макс;


/**
 * Представляет пару координат x- и y, которые определяют точку на 2-мерной плоскости.
 */
struct Точка {

  цел x; /// Gets or sets the _x-coordinate.
  цел y; /// Gets or sets the _y-coordinate.

  static Точка пустой = { 0, 0 }; // Represents a Точка that has x and y значения уст to zero.

  /**
   * Initializes a new экземпляр with the specified coordintates.
   * Параметры:
   *   x = The horizontal позиция.
   *   y = The vertical позиция.
   */
  static Точка opCall(цел x, цел y) {
    Точка сам;
    сам.x = x, сам.y = y;
    return сам;
  }

  /**
   * Tests whether the specified Точка has the same coordinates as this экземпляр.
   * Параметры: другой = The Точка to test.
   * Возвращает: true if другой has the same x- and y-coordinates as this экземпляр; otherwise, false.
   */
  бул равен(Точка другой) {
    return x == другой.x && y == другой.y;
  }

  /// ditto
  бул opEquals(Точка другой) {
    return x == другой.x && y == другой.y;
  }

  hash_t вХэш() {
    return x ^ y;
  }

  /**
   * Converts the specified ТочкаП to a Точка by rounding the ТочкаП значения to the следщ highest integer.
   * Параметры: значение = The ТочкаП to преобразуй.
   * Возвращает: The Точка this метод converts to.
   */
  static Точка ceiling(ТочкаП значение) {
    return Точка(cast(цел).потолок(значение.x), cast(цел).потолок(значение.y));
  }

  /**
   * Converts the specified ТочкаП to a Точка by rounding the Точка значения to the nearest integer.
   * Параметры: значение = The ТочкаП to преобразуй.
   * Возвращает: The Точка this метод converts to.
   */
  static Точка округли(ТочкаП значение) {
    return Точка(cast(цел).округли(значение.x), cast(цел).округли(значение.y));
  }

  /**
   * Translates this экземпляр by the specified amount.
   * Параметры: p = The Точка used to _offset this экземпляр.
   */
  проц смещение(Точка p) {
    смещение(p.x, p.y);
  }

  /**
   * Translates this экземпляр by the specified amount.
   * Параметры:
   *   x = The amount to _offset the _x-coordinate.
   *   y = The amount to _offset the _y-coordinate.
   */
  проц смещение(цел x, цел y) {
    this.x += x;
    this.y += y;
  }

  /**
   * Gets a значение indicating whether this экземпляр is пустой.
   * Возвращает: true if both x and y are zero; otherwise, false.
   */
  бул пуст_ли() {
    return x == 0 && y == 0;
  }

  /**
   * Adds the specified Размер to the specified Точка.
   * Параметры:
   *   pt = The Точка to _add.
   *   sz = The Размер to _add.
   * Возвращает: The Точка that is the рез of the addition operation.
   */
  static Точка добавь(Точка pt, Размер sz) {
    return Точка(pt.x + sz.ширина, pt.y + sz.высота);
  }

  /// ditto
  Точка opAdd(Размер sz) {
    return Точка(x + sz.ширина, y + sz.высота);
  }

  /// ditto
  проц opAddAssign(Размер sz) {
    x += sz.ширина;
    y += sz.высота;
  }

  /**
   * Subtracts the specified Размер from the specified Точка.
   * Параметры:
   *   pt = The Точка to be subtracted from.
   *   sz = The Размер to _subtract from the Точка.
   * Возвращает: The Точка that is the рез of the subtraction operation.
   */
  static Точка отними(Точка pt, Размер sz) {
    return Точка(pt.x - sz.ширина, pt.y - sz.высота);
  }

  /// ditto
  Точка opSub(Размер sz) {
    return Точка(x - sz.ширина, y - sz.высота);
  }

  /// ditto
  проц opSubAssign(Размер sz) {
    x -= sz.ширина;
    y -= sz.высота;
  }

  ткст вТкст() {
    return фм("{x=%s,y=%s}", x, y);
  }

}

/**
 * Represents a pair of floating-point x- and y-coordinates that defines a point in a two-dimensional plane.
 */
struct ТочкаП {

  плав x = 0f; /// Gets or sets the _x-coordinate.
  плав y = 0f; /// Gets or sets the _y-coordinate.

  static ТочкаП пустой = { 0f, 0f }; // Represents a Точка that has x and y значения уст to zero.

  /**
   * Initializes a new экземпляр with the specified coordintates.
   * Параметры:
   *   x = The horizontal позиция.
   *   y = The vertical позиция.
   */
  static ТочкаП opCall(плав x, плав y) {
    ТочкаП сам;
    сам.x = x, сам.y = y;
    return сам;
  }

  /**
   * Converts the specified Точка structure to a ТочкаП structure.
   * Параметры: p = The Точка to be converted.
   * Возвращает: The ТочкаП that results from the conversion.
   */
  static ТочкаП opCall(Точка p) {
    return ТочкаП(cast(плав)p.x, cast(плав)p.y);
  }

  /**
   * Tests whether the specified ТочкаП has the same coordinates as this экземпляр.
   * Параметры: другой = The ТочкаП to test.
   * Возвращает: true if другой has the same x- and y-coordinates as this экземпляр; otherwise, false.
   */
  бул равен(ТочкаП другой) {
    return x == другой.x && y == другой.y;
  }

  /// ditto
  бул opEquals(ТочкаП другой) {
    return x == другой.x && y == другой.y;
  }

  /**
   * Gets a значение indicating whether this экземпляр is пустой.
   * Возвращает: true if both x and y are zero; otherwise, false.
   */
  бул пуст_ли() {
    return x == 0f && y == 0f;
  }

  /**
   * Adds the specified SizeF to the specified ТочкаП.
   * Параметры:
   *   pt = The ТочкаП to _add.
   *   sz = The SizeF to _add.
   * Возвращает: The ТочкаП that is the рез of the addition operation.
   */
  static ТочкаП добавь(ТочкаП pt, SizeF sz) {
    return ТочкаП(pt.x + sz.ширина, pt.y + sz.высота);
  }

  /// ditto
  ТочкаП opAdd(SizeF sz) {
    return ТочкаП(x + sz.ширина, y + sz.высота);
  }

  /// ditto
  проц opAddAssign(SizeF sz) {
    x += sz.ширина;
    y += sz.высота;
  }

  /**
   * Subtracts the specified SizeF from the specified ТочкаП.
   * Параметры:
   *   pt = The ТочкаП to be subtracted from.
   *   sz = The SizeF to _subtract from the Точка.
   * Возвращает: The ТочкаП that is the рез of the subtraction operation.
   */
  static ТочкаП отними(ТочкаП pt, SizeF sz) {
    return ТочкаП(pt.x - sz.ширина, pt.y - sz.высота);
  }

  /// ditto
  ТочкаП opSub(SizeF sz) {
    return ТочкаП(x - sz.ширина, y - sz.высота);
  }

  /// ditto
  проц opSubAssign(SizeF sz) {
    x -= sz.ширина;
    y -= sz.высота;
  }

  ткст вТкст() {
    return фм("{x=%s,y=%s}", x, y);
  }

}

/**
 * Represents a pair of integers, typically the ширина and высота of a rectangle.
 */
struct Размер {

  цел ширина; /// Gets or sets the horizontal component.
  цел высота; /// Gets or sets the vertical component.

  static Размер пустой = { 0, 0 }; /// Represents a Размер that has ширина and высота значения уст to zero.

  /**
   * Initializes a new экземпляр from the specified dimensions.
   * Параметры:
   *   ширина = The horizontal component.
   *   высота = The vertical component.
   */
  static Размер opCall(цел ширина, цел высота) {
    Размер сам;
    сам.ширина = ширина, сам.высота = высота;
    return сам;
  }

  /**
   * Tests whether the specified Размер has the same dimensions as this экземпляр.
   * Параметры: другой = The Размер to test.
   * Возвращает: true if другой has the same ширина and высота as this экземпляр; otherwise, false.
   */
  бул равен(Размер другой) {
    return ширина == другой.ширина && высота == другой.высота;
  }

  /// ditto
  бул opEquals(Размер другой) {
    return ширина == другой.ширина && высота == другой.высота;
  }

  hash_t вХэш() {
    return ширина ^ высота;
  }

  /**
   * Converts the specified SizeF structure to a Размер structure by rounding the значения of the Размер structure to the следщ highest integer.
   * Параметры: значение = The SizeF structure to преобразуй.
   * Возвращает: The Размер structure this метод converts to.
   */
  static Размер ceiling(SizeF значение) {
    return Размер(cast(цел).потолок(значение.высота), cast(цел).потолок(значение.высота));
  }

  /**
   * Converts the specified SizeF structure to a Размер structure by rounding the значения of the SizeF structure to the nearest integer.
   * Параметры: The SizeF structure to преобразуй.
   * Возвращает: The Размер structure this methods converts to.
   */
  static Размер округли(SizeF значение) {
    return Размер(cast(цел).округли(значение.ширина), cast(цел).округли(значение.высота));
  }

  /**
   * Converts the specified SizeF structure to a Размер structure by truncating the значения of the SizeF structure to the следщ lowest integer значения.
   * Параметры: значение = The SizeF structure to преобразуй.
   * Возвращает: The Размер structure this метод converts to.
   */
  static Размер отсеки(SizeF значение) {
    return Размер(cast(цел)значение.ширина, cast(цел)значение.высота);
  }

  /**
   * Tests whether this экземпляр has ширина and высота уст to zero.
   * Возвращает: true if both ширина and высота are zero; otherwise, false.
   */
  бул пуст_ли() {
    return ширина == 0 && высота == 0;
  }

  /**
   * Adds the ширина and высота of one Размер structure to the ширина and высота of another.
   * Параметры:
   *   sz1 = The first Размер to _add.
   *   sz2 = The секунда Размер to _add.
   * Возвращает: A Размер structure that is the рез of the addition operation.
   */
  static Размер добавь(Размер sz1, Размер sz2) {
    return Размер(sz1.ширина + sz2.ширина, sz1.высота + sz2.высота);
  }

  /// ditto
  Размер opAdd(Размер другой) {
    return Размер(ширина + другой.ширина, высота + другой.высота);
  }

  /// ditto
  проц opAddAssign(Размер другой) {
    ширина += другой.ширина;
    высота += другой.высота;
  }

  /**
   * Subtracts the ширина and высота of one Размер structure from the ширина and высота of another.
   * Параметры:
   *   sz1 = The first Размер to _subtract.
   *   sz2 = The секунда Размер to _subtract.
   * Возвращает: A Размер structure that is the рез of the subtraction operation.
   */
  static Размер отними(Размер sz1, Размер sz2) {
    return Размер(sz1.ширина - sz2.ширина, sz1.высота - sz2.высота);
  }

  /// ditto
  Размер opSub(Размер другой) {
    return Размер(ширина - другой.ширина, высота - другой.высота);
  }

  /// ditto
  проц opSubAssign(Размер другой) {
    ширина -= другой.ширина;
    высота -= другой.высота;
  }

  ткст вТкст() {
    return фм("{ширина=%s,высота=%s}", ширина, высота);
  }

}

/**
 * Represents a pair of floating-point numbers, typically the ширина and высота of a rectangle.
 */
struct SizeF {

  плав ширина = 0f; /// Gets or sets the horizontal component.
  плав высота = 0f; /// Gets or sets the vertical component.

  static SizeF пустой = { 0f, 0f }; /// Represents a Размер that has ширина and высота значения уст to zero.

  /**
   * Initializes a new экземпляр from the specified dimensions.
   * Параметры:
   *   ширина = The horizontal component.
   *   высота = The vertical component.
   */
  static SizeF opCall(плав ширина, плав высота) {
    SizeF сам;
    сам.ширина = ширина, сам.высота = высота;
    return сам;
  }

  /**
   * Converts the specified Размер to a SizeF.
   * Параметры: sz = The Размер to преобразуй.
   * Возвращает: The SizeF structure to which this operator converts.
   */
  static SizeF opCall(Размер sz) {
    return SizeF(cast(плав)sz.ширина, cast(плав)sz.высота);
  }

  /**
   * Tests whether the specified SizeF has the same dimensions as this экземпляр.
   * Параметры: другой = The SizeF to test.
   * Возвращает: true if другой has the same ширина and высота as this экземпляр; otherwise, false.
   */
  бул равен(SizeF другой) {
    return ширина == другой.ширина && высота == другой.высота;
  }

  /// ditto
  бул opEquals(SizeF другой) {
    return ширина == другой.ширина && высота == другой.высота;
  }

  /**
   * Tests whether this экземпляр has ширина and высота уст to zero.
   * Возвращает: true if both ширина and высота are zero; otherwise, false.
   */
  бул пуст_ли() {
    return ширина == 0f && высота == 0f;
  }

  /**
   * Adds the ширина and высота of one FSize structure to the ширина and высота of another.
   * Параметры:
   *   sz1 = The first SizeF to _add.
   *   sz2 = The секунда SizeF to _add.
   * Возвращает: A SizeF structure that is the рез of the addition operation.
   */
  static SizeF добавь(SizeF sz1, SizeF sz2) {
    return SizeF(sz1.ширина + sz2.ширина, sz1.высота + sz2.высота);
  }

  /// ditto
  SizeF opAdd(SizeF sz) {
    return SizeF(ширина + sz.ширина, высота + sz.высота);
  }

  /// ditto
  проц opAddAssign(SizeF sz) {
    ширина += sz.ширина;
    высота += sz.высота;
  }

  /**
   * Subtracts the ширина and высота of one SizeF structure from the ширина and высота of another.
   * Параметры:
   *   sz1 = The first SizeF to _subtract.
   *   sz2 = The секунда SizeF to _subtract.
   * Возвращает: A SizeF structure that is the рез of the subtraction operation.
   */
  static SizeF отними(SizeF sz1, SizeF sz2) {
    return SizeF(sz1.ширина - sz2.ширина, sz1.высота - sz2.высота);
  }

  /// ditto
  SizeF opSub(SizeF sz) {
    return SizeF(ширина - sz.ширина, высота - sz.высота);
  }

  /// ditto
  проц opSubAssign(SizeF sz) {
    ширина -= sz.ширина;
    высота -= sz.высота;
  }

  ткст вТкст() {
    return фм("{ширина=%s,высота=%s}", ширина, высота);
  }

}

/**
 * Represents a уст of four integers that define the положение and размер of a rectangle.
 */
struct Прям {

  цел x; /// Gets or sets the _x-coordinate.
  цел y; /// Gets of sets the _y-coordinate.
  цел ширина; /// Gets or sets the _width component.
  цел высота; /// Gets or sets the _height component.

  static Прям пустой = { 0, 0, 0, 0 }; /// Represents an uninitialized Прям structure.

  /**
   * Initializes a new экземпляр with the specified положение and размер.
   * Параметры:
   *   x = The _x-coordinate.
   *   y = The _y-coordinate.
   *   ширина = The _width.
   *   высота = The _height.
   */
  static Прям opCall(цел x, цел y, цел ширина, цел высота) {
    Прям this_;
    this_.x = x, this_.y = y, this_.ширина = ширина, this_.высота = высота;
    return this_;
  }

  /**
   * Initializes a new экземпляр with the specified _location and _size.
   * Параметры:
   *   положение = The upper-лево corner.
   *   размер = The ширина and высота.
   */
  static Прям opCall(Точка положение, Размер размер) {
    return Прям(положение.x, положение.y, размер.ширина, размер.высота);
  }

  /**
   * Creates a Прям structure ширина the specified edge locations.
   * Параметры:
   *   лево = The x-coordinate of the upper-_left corner.
   *   верх = The y-coordinate of the upper-_left corner.
   *   право = The x-coordinate of the lower-_right corner.
   *   низ = The y-coordinate of the lower-_right corner.
   * Возвращает: The new Прям that this метод creates.
   */
  static Прям fromLTRB(цел лево, цел верх, цел право, цел низ) {
    return Прям(лево, верх, право - лево, низ - верх);
  }

  /**
   * Tests whether the specified Прям structure has the same положение and размер as this экземпляр.
   * Параметры: другой = The Прям to test.
   * Возвращает: true if the x, y, ширина and высота properties of другой are equal to the corresponding properties of this экземпляр; otherwise, false.
   */
  бул равен(Прям другой) {
    return x == другой.x && y == другой.y && ширина == другой.ширина && высота == другой.высота;
  }

  /// ditto
  бул opEquals(Прям другой) {
    return x == другой.x && y == другой.y && ширина == другой.ширина && высота == другой.высота;
  }

  hash_t вХэш() {
    return x | ((y << 13) | (y >> 19)) ^ ((ширина << 26) | (ширина >> 6)) | ((высота << 7) | (высота >> 25));
  }

  /**
   * Converts the specified ПрямП structure to a Прям structure by rounding the ПрямП значения to the следщ highest integers.
   * Параметры: значение = The ПрямП to преобразуй.
   * Возвращает: The Прям structure that this метод converts to.
   */
  static Прям ceiling(ПрямП значение) {
    return Прям(cast(цел).потолок(значение.x), cast(цел).потолок(значение.y), cast(цел).потолок(значение.ширина), cast(цел).потолок(значение.высота));
  }

  /**
   * Converts the specified ПрямП structure to a Прям structure by rounding the ПрямП значения to the nearest integers.
   * Параметры: значение = The ПрямП to преобразуй.
   * Возвращает: The Прям structure that this метод converts to.
   */
  static Прям округли(ПрямП значение) {
    return Прям(cast(цел).округли(значение.x), cast(цел).округли(значение.y), cast(цел).округли(значение.ширина), cast(цел).округли(значение.высота));
  }

  /**
   * Converts the specified ПрямП structure to a Прям structure by truncating the ПрямП значения.
   * Параметры: значение = The ПрямП to преобразуй.
   * Возвращает: The Прям structure that this метод converts to.
   */
  static Прям отсеки(ПрямП значение) {
    return Прям(cast(цел)значение.x, cast(цел)значение.y, cast(цел)значение.ширина, cast(цел)значение.высота);
  }

  /**
   * Gets a Прям structure containing the union of two Прям structures.
   * Параметры:
   *   a = A Прям to union.
   *   b = A Прям to union.
   * Возвращает: A Прям structure that bounds the union of the two Прям structures.
   */
  static Прям объедини(Прям a, Прям b) {
    цел лево = мин(a.x, b.x);
    цел право = макс(a.x + a.ширина, b.x + b.ширина);
    цел верх = мин(a.y, b.y);
    цел низ = макс(a.y + a.высота, b.y + b.высота);
    return Прям(лево, верх, право - лево, низ - верх);
  }

  /**
   * Determines if the specified point is contained within this экземпляр.
   * Параметры: pt = The Точка to test.
   * Возвращает: true if the point represented by pt is contained within this экземпляр; otherwise, false.
   */
  бул содержит(Точка pt) {
    return содержит(pt.x, pt.y);
  }

  /**
   * Determines if the specified point is contained within this экземпляр.
   * Параметры:
   *   x = The x-coordinate of the point to test.
   *   y = The y-coordinate of the point to test.
   * Возвращает: true if the point defined by x and y is contained within this экземпляр; otherwise, false.
   */
  бул содержит(цел x, цел y) {
    return this.x <= x && x < this.право && this.y <= y && y < this.низ;
  }

  /**
   * Determines if the specified rectangular region is entirely contained within this экземпляр.
   * Параметры:
   *   прям = The rectangular region to test.
   * Возвращает: true if the rectangular region represented by прям is entirely contained within this экземпляр; otherwise, false.
   */
  бул содержит(Прям прям) {
    return x <= прям.x && прям.x + прям.ширина <= x + ширина && y <= прям.y && прям.y + прям.высота <= y + высота;
  }

  /**
   * Returns an inflated копируй of the specified Прям structure.
   * Параметры:
   *   прям = The Прям to be copied.
   *   x = The amount to _inflate the копируй horizontally.
   *   y = The amount to _inflate the копируй vertically.
   * Возвращает: The inflated Прям.
   */
  static Прям расширь(Прям прям, цел x, цел y) {
    Прям r = прям;
    r.расширь(x, y);
    return r;
  }

  /**
   * Inflates this экземпляр by the specified amount.
   * Параметры: размер = The amount to расширь this экземпляр.
   */
  проц расширь(Размер размер) {
    расширь(размер.ширина, размер.высота);
  }

  /**
   * Inflates this экземпляр by the specified amount.
   * Параметры:
   *   x = The amount to _inflate this экземпляр horizontally.
   *   y = The amount to _inflate this экземпляр vertically.
   */
  проц расширь(цел ширина, цел высота) {
    this.x -= ширина;
    this.y -= высота;
    this.ширина += ширина * 2;
    this.высота += высота * 2;
  }

  /**
   * Adjust the положение of this экземпляр by the specified amount.
   * Параметры: поз = The amount to _offset the положение.
   */
  проц смещение(Точка поз) {
    смещение(поз.x, поз.y);
  }

  /**
   * Adjust the положение of this экземпляр by the specified amount.
   * Параметры:
   *   x = The horizontal _offset.
   *   y = The vertical _offset.
   */
  проц смещение(цел x, цел y) {
    this.x += x;
    this.y += y;
  }

  /**
   * Determines whether this экземпляр intersects with прям.
   * Параметры: прям = The Прям to test.
   * Возвращает: true if there is any intersection; otherwise, false.
   */
  бул пересекается_с(Прям прям) {
    return прям.x < x + ширина && x < прям.x + прям.ширина && прям.y < y + высота && y < прям.y + прям.высота;
  }

  /**
   * Returns a Прям structure that represents the intersection of two Прям structures.
   * Параметры:
   *   a = A Прям to _intersect.
   *   b = A Прям to _intersect.
   * Возвращает: A Прям that represents the intersection of a and b.
   */
  static Прям пересечение(Прям a, Прям b) {
    цел лево = макс(a.x, b.x);
    цел право = мин(a.x + a.ширина, b.x + b.ширина);
    цел верх = макс(a.y, b.y);
    цел низ = мин(a.y + a.высота, b.y + b.высота);
    if (право >= лево && низ >= верх)
      return Прям(лево, верх, право - лево, низ - верх);
    return Прям.пустой;
  }

  /**
   * Replaces this экземпляр with the intersection of itself and the specified Прям structure.
   * Параметры: прям = The Прям with which to _intersect.
   */
  проц пересечение(Прям прям) {
    version(D_Version2) {
      Прям r = пересечение(прям, this);
    }
    else {
      Прям r = пересечение(прям, *this);
    }
    x = r.x;
    y = r.y;
    ширина = r.ширина;
    высота = r.высота;
  }

  /**
   * Gets the x-coordinate of the _left edge of this Прям structure.
   */
  цел лево() {
    return x;
  }

  /**
   * Gets the y-coordinate of the _top edge of this Прям structure.
   */
  цел верх() {
    return y;
  }

  /**
   * Gets the x-coordinate that is the sum of the x and ширина значения.
   */
  цел право() {
    return x + ширина;
  }

  /**
   * Gets the y-coordinate that is the sum of the y and высота значения.
   */
  цел низ() {
    return y + высота;
  }

  /**
   * Gets or sets the coordinates of the upper-лево corner of this Прям structure.
   */
  проц положение(Точка значение) {
    x = значение.x;
    y = значение.y;
  }

  /**
   * ditto
   */
  Точка положение() {
    return Точка(x, y);
  }

  /**
   * Gets or sets the _size of this Прям structure.
   */
  проц размер(Размер значение) {
    ширина = значение.ширина;
    высота = значение.высота;
  }

  /**
   * ditto
   */
  Размер размер() {
    return Размер(ширина, высота);
  }

  /**
   * Tests whether all numeric значения of this Прям structure have значения of zero.
   * Возвращает: true if the x, y, ширина and высота значения of this Прям structure all have значения of zero; otherwise, false.
   */
  бул пуст_ли() {
    return x == 0 && y == 0 && ширина == 0 && высота == 0;
  }

  ткст вТкст() {
    return фм("{x=%s,y=%s,ширина=%s,высота=%s}", x, y, ширина, высота);
  }

}

/**
 * Represents a уст of four floating-point numbers that define the положение and размер of a rectangle.
 */
struct ПрямП {

  плав x = 0f; /// Gets or sets the _x-coordinate.
  плав y = 0f; /// Gets of sets the _y-coordinate.
  плав ширина = 0f; /// Gets or sets the _width component.
  плав высота = 0f; /// Gets or sets the _height component.

  static ПрямП пустой = { 0f, 0f, 0f, 0f }; /// Represents a ПрямП structure with its значения уст to zero.

  /**
   * Initializes a new экземпляр with the specified положение and размер.
   * Параметры:
   *   x = The _x-coordinate.
   *   y = The _y-coordinate.
   *   ширина = The _width.
   *   высота = The _height.
   */
  static ПрямП opCall(плав x, плав y, плав ширина, плав высота) {
    ПрямП сам;
    сам.x = x, сам.y = y, сам.ширина = ширина, сам.высота = высота;
    return сам;
  }

  /**
   * Initializes a new экземпляр with the specified _location and _size.
   * Параметры:
   *   положение = The upper-лево corner.
   *   размер = The ширина and высота.
   */
  static ПрямП opCall(ТочкаП положение, SizeF размер) {
    return ПрямП(положение.x, положение.y, размер.ширина, размер.высота);
  }

  static ПрямП opCall(Прям r) {
    return ПрямП(cast(плав)r.x, cast(плав)r.y, cast(плав)r.ширина, cast(плав)r.высота);
  }

  /**
   * Creates a ПрямП structure ширина the specified edge locations.
   * Параметры:
   *   лево = The x-coordinate of the upper-_left corner.
   *   верх = The y-coordinate of the upper-_left corner.
   *   право = The x-coordinate of the lower-_right corner.
   *   низ = The y-coordinate of the lower-_right corner.
   * Возвращает: The new ПрямП that this метод creates.
   */
  static ПрямП fromLTRB(плав лево, плав верх, плав право, плав низ) {
    return ПрямП(лево, верх, право - лево, низ - верх);
  }

  /**
   * Tests whether the specified Прям structure has the same положение and размер as this экземпляр.
   * Параметры: другой = The ПрямП to test.
   * Возвращает: true if the x, y, ширина and высота properties of другой are equal to the corresponding properties of this экземпляр; otherwise, false.
   */
  бул равен(ПрямП другой) {
    return x == другой.x && y == другой.y && ширина == другой.ширина && высота == другой.высота;
  }

  /// ditto
  бул opEquals(ПрямП другой) {
    return x == другой.x && y == другой.y && ширина == другой.ширина && высота == другой.высота;
  }

  hash_t вХэш() {
    return cast(бцел)x | ((cast(бцел)y << 13) | (cast(бцел)y >> 19)) ^ ((cast(бцел)ширина << 26) | (cast(бцел)ширина >> 6)) | ((cast(бцел)высота << 7) | (cast(бцел)высота >> 25));
  }

  /**
   * Gets a Прям structure containing the union of two ПрямП structures.
   * Параметры:
   *   a = A ПрямП to union.
   *   b = A ПрямП to union.
   * Возвращает: A ПрямП structure that bounds the union of the two Прям structures.
   */
  static ПрямП объедини(ПрямП a, ПрямП b) {
    плав лево = мин(a.x, b.x);
    плав право = макс(a.x + a.ширина, b.x + b.ширина);
    плав верх = мин(a.y, b.y);
    плав низ = макс(a.y + a.высота, b.y + b.высота);
    return ПрямП(лево, верх, право - лево, низ - верх);
  }

  /**
   * Determines if the specified point is contained within this экземпляр.
   * Параметры: pt = The ТочкаП to test.
   * Возвращает: true if the point represented by pt is contained within this экземпляр; otherwise, false.
   */
  бул содержит(ТочкаП pt) {
    return содержит(pt.x, pt.y);
  }

  /**
   * Determines if the specified point is contained within this экземпляр.
   * Параметры:
   *   x = The x-coordinate of the point to test.
   *   y = The y-coordinate of the point to test.
   * Возвращает: true if the point defined by x and y is contained within this экземпляр; otherwise, false.
   */
  бул содержит(плав x, плав y) {
    return this.x <= x && x < this.x + this.ширина && this.y <= y && y < this.y + this.высота;
  }

  /**
   * Determines if the specified rectangular region is entirely contained within this экземпляр.
   * Параметры:
   *   прям = The rectangular region to test.
   * Возвращает: true if the rectangular region represented by прям is entirely contained within this экземпляр; otherwise, false.
   */
  бул содержит(ПрямП прям) {
    return x <= прям.x && прям.x + прям.ширина <= x + ширина && y <= прям.y && прям.y + прям.высота <= y + высота;
  }

  /**
   * Returns an inflated копируй of the specified ПрямП structure.
   * Параметры:
   *   прям = The ПрямП to be copied.
   *   x = The amount to _inflate the копируй horizontally.
   *   y = The amount to _inflate the копируй vertically.
   * Возвращает: The inflated ПрямП.
   */
  static ПрямП расширь(ПрямП прям, плав x, плав y) {
    ПрямП r = прям;
    r.расширь(x, y);
    return r;
  }

  /**
   * Inflates this экземпляр by the specified amount.
   * Параметры: размер = The amount to расширь this экземпляр.
   */
  проц расширь(SizeF размер) {
    расширь(размер.ширина, размер.высота);
  }

  /**
   * Inflates this экземпляр by the specified amount.
   * Параметры:
   *   x = The amount to _inflate this экземпляр horizontally.
   *   y = The amount to _inflate this экземпляр vertically.
   */
  проц расширь(плав ширина, плав высота) {
    this.x -= ширина;
    this.y -= высота;
    this.ширина += ширина * 2f;
    this.высота += высота * 2f;
  }

  /**
   * Adjust the положение of this экземпляр by the specified amount.
   * Параметры: поз = The amount to _offset the положение.
   */
  проц смещение(ТочкаП поз) {
    смещение(поз.x, поз.y);
  }

  /**
   * Adjust the положение of this экземпляр by the specified amount.
   * Параметры:
   *   x = The horizontal _offset.
   *   y = The vertical _offset.
   */
  проц смещение(плав x, плав y) {
    this.x += x;
    this.y += y;
  }

  /**
   * Determines whether this экземпляр intersects with прям.
   * Параметры: прям = The ПрямП to test.
   * Возвращает: true if there is any intersection; otherwise, false.
   */
  бул пересекается_с(ПрямП прям) {
    return прям.x < x + ширина && x < прям.x + прям.ширина && прям.y < y + высота && y < прям.y + прям.высота;
  }

  /**
   * Returns a ПрямП structure that represents the intersection of two ПрямП structures.
   * Параметры:
   *   a = A ПрямП to _intersect.
   *   b = A ПрямП to _intersect.
   * Возвращает: A ПрямП that represents the intersection of a and b.
   */
  static ПрямП пересечение(ПрямП a, ПрямП b) {
    плав лево = макс(a.x, b.x);
    плав право = мин(a.x + a.ширина, b.x + b.ширина);
    плав верх = макс(a.y, b.y);
    плав низ = мин(a.y + a.высота, b.y + b.высота);
    if (право >= лево && низ >= верх)
      return ПрямП(лево, верх, право - лево, низ - верх);
    return ПрямП.пустой;
  }

  /**
   * Replaces this экземпляр with the intersection of itself and the specified ПрямП structure.
   * Параметры: прям = The ПрямП with which to _intersect.
   */
  проц пересечение(ПрямП прям) {
    version(D_Version2) {
      ПрямП r = пересечение(прям, this);
    }
    else {
      ПрямП r = пересечение(прям, *this);
    }
    x = r.x;
    y = r.y;
    ширина = r.ширина;
    высота = r.высота;
  }

  /**
   * Gets the x-coordinate of the _left edge of this ПрямП structure.
   */
  плав лево() {
    return x;
  }

  /**
   * Gets the y-coordinate of the _top edge of this ПрямП structure.
   */
  плав верх() {
    return y;
  }

  /**
   * Gets the x-coordinate that is the sum of the x and ширина значения.
   */
  плав право() {
    return x + ширина;
  }

  /**
   * Gets the y-coordinate that is the sum of the y and высота значения.
   */
  плав низ() {
    return y + высота;
  }

  /**
   * Gets or sets the coordinates of the upper-лево corner of this ПрямП structure.
   */
  ТочкаП положение() {
    return ТочкаП(x, y);
  }

  /**
   * ditto
   */
  проц положение(ТочкаП значение) {
    x = значение.x;
    y = значение.y;
  }

  /**
   * Gets or sets the _size of this ПрямП structure.
   */
  SizeF размер() {
    return SizeF(ширина, высота);
  }

  /**
   * ditto
   */
  проц размер(SizeF значение) {
    ширина = значение.ширина;
    высота = значение.высота;
  }

  ткст вТкст() {
    return фм("{x=%s,y=%s,ширина=%s,высота=%s}", x, y, ширина, высота);
  }

}