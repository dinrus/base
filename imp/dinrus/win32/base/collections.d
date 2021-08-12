/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.base.collections;

import win32.base.core,
  win32.loc.core,
  stdrus;
import cidrus : memmove, memset;

/**
 * <code>бул delegate(T a, T b)</code>
 */

template СравнениеНаРавенство(T) {
  alias бул delegate(T a, T b) СравнениеНаРавенство;
}

/**
 * <code>цел delegate(T a, T b)</code>
 */
template Сравнение(T) {
  alias цел delegate(T a, T b) Сравнение;
}

/**
 * <code>бул delegate(T объ)</code>
 */
template Предикат(T) {
  alias бул delegate(T) Предикат;
}

/**
 * <code>ТВывод delegate(ТВвод ввод)</code>
 */
template Преобразователь(ТВвод, ТВывод) {
  alias ТВывод delegate(ТВвод) Преобразователь;
}

/**
 * <code>проц delegate(T объ)</code>
 */
template Действие(T) {
  alias проц delegate(T объ) Действие;
}

private бул equalityComparisonImpl(T)(T a, T b) {
  static if (is(T == class) || is(T == interface)) {
    if (a !is null) {
      if (b !is null) {
        static if (is(typeof(T.opEquals))) {
          return cast(бул)a.opEquals(b);
        }
        else {
          return cast(бул)typeid(T).равен(&a, &b);
        }
      }
      return false;
    }
    if (b !is null) {
      return false;
    }
    return true;
  }
  else static if (is(T == struct)) {
    static if (is(T.opEquals)) {
      return cast(бул)a.opEquals(b);
    }
    else {
      return cast(бул)typeid(T).equals(&a, &b);
    }
  }
  else {
    return cast(бул)typeid(T).equals(&a, &b);
  }
}

private цел comparisonImpl(T)(T a, T b) {
  static if (is(T : ткст)) {
    return Культура.текущ.коллятор.сравни(a, b);
  }
  else static if (is(T == class) || is(T == interface)) {
    if (a !is b) {
      if (a !is null) {
        if (b !is null) {
          static if (is(typeof(T.opCmp))) {
            return a.opCmp(b);
          }
          else {
            return typeid(T).сравни(&a, &b);
          }
        }
        return 1;
      }
      return -1;
    }
    return 0;
  }
  else static if (is(T == struct)) {
    static if (is(typeof(T.opCmp))) {
      return a.opCmp(b);
    }
    else {
      return typeid(T).сравни(&a, &b);
    }
  }
  else {
    return typeid(T).сравни(&a, &b);
  }
}

/*цел индексУ(T)(T[] array, T элт, СравнениеНаРавенство!(T) comparison = null) {
  if (comparison is null) {
    comparison = (T a, T b) {
      return equalityComparisonImpl(a, b);
    };
  }

  for (auto i = 0; i < array.length; i++) {
    if (comparison(array[i], элт))
      return i;
  }

  return -1;
}*/

/**
 * Defines methods that сравни two objects for equality.
 */
interface ИСравнивательНаРавенство(T) {

  /**
   * Determines whether the specified objects are equal.
   * Параметры:
   *   a = The first object to сравни.
   *   b = The секунда object to сравни.
   * Возвращает: true if the specified objects are equal; otherwise, false.
   */
  бул равен(T a, T b);

  /**
   * Retrieves a hash code for the specified object.
   * Параметры: значение = The object for which a hash code is to be retrieved.
   * Возвращает: The hash code for the specified object.
   */
  бцел дайХэш(T значение);

}

/**
 * Provides a base class for implementations of the ИСравнивательНаРавенство(T) interface.
 */
abstract class СравнивательНаРавенство(T) : ИСравнивательНаРавенство!(T) {

  /**
   * $(I Property.) Returns a default equality comparer for the тип specified by the template parameter.
   */
  static СравнивательНаРавенство экземпляр() {
    static СравнивательНаРавенство экземпляр_;
    if (экземпляр_ is null) {
      экземпляр_ = new class СравнивательНаРавенство {
        бул равен(T a, T b) {
          return equalityComparisonImpl(a, b);
        }
        бцел дайХэш(T значение) {
          return typeid(T).дайХэш(&значение);
        }
      };
    }
    return экземпляр_;
  }

  /**
   * Determines whether the specified objects are equal.
   * Параметры:
   *   a = The first object to сравни.
   *   b = The секунда object to сравни.
   * Возвращает: true if the specified objects are equal; otherwise, false.
   */
  abstract бул равен(T a, T b);

  /**
   * Retrieves a hash code for the specified object.
   * Параметры: значение = The object for which a hash code is to be retrieved.
   * Возвращает: The hash code for the specified object.
   */
  abstract бцел дайХэш(T значение);

}

/**
 * Defines a метод that compares two objects.
 */
interface ИСравниватель(T) {

alias сравни сравни;

  /**
   * Compares two objects and returns a значение indicating whether one is less than, equal to, or greater than the другой.
   * Параметры:
   *   a = The first object to _compare.
   *   b = The секунда object to _compare.
   * Возвращает: 
   *   $(TABLE $(TR $(TH Value) $(TH Condition))
   *   $(TR $(TD Less than zero) $(TD a is less than b.))
   *   $(TR $(TD Zero) $(TD a равен b.))
   *   $(TR $(TD Greater than zero) $(TD a is greater than b.)))
   */
  цел сравни(T a, T b);

}

/**
 * Provides a base class for implementations of the ИСравниватель(T) interface.
 */
abstract class Сравниватель(T) : ИСравниватель!(T) {

alias экземпляр экземпляр;
alias сравни сравни;

  /**
   * $(I Property.) Retrieves a default comparer for the тип specified by the template parameter.
   */
  static Сравниватель экземпляр() {
    static Сравниватель экземпляр_;
    if (экземпляр_ is null) {
      экземпляр_ = new class Сравниватель {
        цел сравни(T a, T b) {
          return comparisonImpl(a, b);
        }
      };
    }
    return экземпляр_;
  }

  /**
   * Compares two objects and returns a значение indicating whether one is less than, equal to, or greater than the другой.
   * Параметры:
   *   a = The first object to _compare.
   *   b = The секунда object to _compare.
   * Возвращает: 
   *   $(TABLE $(TR $(TH Value) $(TH Condition))
   *   $(TR $(TD Less than zero) $(TD a is less than b.))
   *   $(TR $(TD Zero) $(TD a равен b.))
   *   $(TR $(TD Greater than zero) $(TD a is greater than b.)))
   */
  abstract цел сравни(T a, T b);

}

/**
 * Sorts the elements цел a охват of element in an _array используя the specified Сравнение(T).
 * Параметры:
 *   array = The _array to _sort.
 *   индекс = The starting _index of the охват to _sort.
 *   length = The число of elements in the охват to _sort.
 *   comparison = The Сравнение(T) to use when comparing element.
 */
проц сортируй(T, TIndex = цел, TLength = TIndex)(T[] array, TIndex индекс, TLength length, цел delegate(T, T) comparison = null) {

  проц quickSortImpl(цел лево, цел право) {
    if (лево >= право)
      return;

    цел i = лево, j = право;
    T pivot = array[i + ((j - i) >> 1)];

    do {
      while (i < право && comparison(array[i], pivot) < 0)
        i++;
      while (j > лево && comparison(pivot, array[j]) < 0)
        j--;

      assert(i >= лево && j <= право);

      if (i <= j) {
        T времн = array[j];
        array[j] = array[i];
        array[i] = времн;

        i++;
        j--;
      }
    } while (i <= j);

    if (лево < j)
      quickSortImpl(лево, j);
    if (i < право)
      quickSortImpl(i, право);
  }

  if (comparison is null) {
    comparison = (T a, T b) {
      return comparisonImpl(a, b);
    };
  }

  quickSortImpl(индекс, индекс + length - 1);
}

/**
 */
проц сортируй(T)(T[] array, цел delegate(T, T) comparison = null) {
  .сортируй(array, 0, array.length, comparison);
}

/**
 * Searches a охват of elements in an _array for a значение используя the specified Сравнение(T).
 * Параметры:
 *   array = The _array to search.
 *   индекс = The starting _index of the охват to search.
 *   length = The число of elements in the охват to search.
 *   comparison = The Сравнение(T) to use when comparing elements.
 */
цел бинарныйПоиск(T, TIndex = цел, TLength = TIndex)(T[] array, TIndex индекс, TLength length, T значение, цел delegate(T, T) comparison = null) {
  if (comparison is null) {
    comparison = (T a, T b) {
      return comparisonImpl(a, b);
    };
  }

  цел lo = cast(цел)индекс;
  цел hi = cast(цел)(индекс + length - 1);
  while (lo <= hi) {
    цел i = lo + ((hi - lo) >> 1);
    цел order = comparison(array[i], значение);
    if (order == 0)
      return i;
    if (order < 0)
      lo = i + 1;
    else
      hi = i - 1;
  }
  return ~lo;
}

проц реверсни(T, TIndex = цел, TLength = TIndex)(T[] array, TIndex индекс, TLength length) {
  auto i = индекс;
  auto j = индекс + length - 1;
  while (i < j) {
    T времн = array[i];
    array[i] = array[j];
    array[j] = времн;
    i++, j--;
  }
}

/**
 */
проц копируй(T, TIndex = цел, TLength = TIndex)(T[] исток, TIndex sourceIndex, T[] цель, TIndex targetIndex, TLength length) {
  if (length > 0)
    memmove(цель.ptr + targetIndex, исток.ptr + sourceIndex, length * T.sizeof);
}

проц сотри(T, TIndex = цел, TLength = IIndex)(T[] array, TIndex индекс, TLength length) {
  if (length > 0)
    memset(array.ptr + индекс, 0, length * T.sizeof);
}

ТВывод[] преобразуйВсе(ТВвод, ТВывод)(ТВвод[] array, Преобразователь!(ТВвод, ТВывод) converter) {
  auto ret = new ТВывод[array.length];
  for (auto i = 0; i < array.length; i++) {
    ret[i] = converter(array[i]);
  }
  return ret;
}

interface ИПеречислимый(T) {
alias opApply опПрименить;

  version (UseRanges) {
  
   alias пустой пуст_ли;
  alias выньФронт выкиньФронт;
  alias фронт фронт;
  
    бул пустой();

    проц выньФронт();

    T фронт();
  }
  else {
    цел opApply(цел delegate(ref T) действие);
  }

}

/**
 * Defines methods to manipulate collections.
 */
interface ИКоллекция(T) : ИПеречислимый!(T) {

  /**
   * Adds an _item to the collection.
   * Параметры: элт = The object to _add.
   */
  проц добавь(T элт);

  /**
   * Removes the first occurence of the specified object from the collection.
   * Параметры: элт = The object to _remove.
   * Возвращает: true if элт was successfully removed; otherwise, false.
   */
  бул удали(T элт);

  /**
   * Determines whether the collection _contains the specified object.
   * Параметры: элт = The object to locate.
   * Возвращает: true if элт was found; otherwise, false.
   */
  бул содержит(T элт);

  /**
   * Removes all items from the collection.
   */
  проц сотри();

  /**
   * $(I Property.) Gets the число of elements in the collection.
   */
  цел счёт();

}

/**
 * Represents a collection of objects that can be accessed by индекс.
 */
interface ИСписок(T) : ИКоллекция!(T) {

  цел индексУ(T элт);

  /**
   * Inserts an _item at the specified _index.
   * Параметры:
   *   индекс = The _index at which элт should be inserted.
   *   элт = The object to вставь.
   */
  проц вставь(цел индекс, T элт);

  /**
   * Removes the элт at the specified _index.
   * Параметры: индекс = The _index of the элт to удали.
   */
  проц удалиПо(цел индекс);

  /**
   * Gets or sets the object at the specified _index.
   * Параметры:
   *   значение = The элт at the specified _index.
   *   индекс = The _index of the элт to дай or уст.
   */
  проц opIndexAssign(T значение, цел индекс);

  /**
   * ditto
   */
  T opIndex(цел индекс);

}

/**
 * Represents a список of elements that can be accessed by индекс.
 */
class Список(T) : ИСписок!(T) {

  private const цел DEFAULT_CAPACITY = 4;

  private T[] элты_;
  private цел размер_;

  private цел индекс_;

  /**
   * Initializes a new экземпляр with the specified _capacity.
   * Параметры: объём = The число of elements the new список can store.
   */
  this(цел объём = 0) {
    элты_.length = объём;
  }

  /**
   * Initializes a new экземпляр containing elements copied from the specified _range.
   * Параметры: охват = The _range whose elements are copied to the new список.
   */
  this(T[] охват) {
    элты_.length = размер_ = охват.length;
    элты_ = охват;
  }

  /**
   * ditto
   */
  this(ИПеречислимый!(T) охват) {
    элты_.length = DEFAULT_CAPACITY;
    foreach (элт; охват)
      добавь(элт);
  }

  /**
   * Adds an element to the end of the список.
   * Параметры: элт = The element to be added.
   */
  final проц добавь(T элт) {
    if (размер_ == элты_.length)
      гарантируйЁмкость(размер_ + 1);
    элты_[размер_++] = элт;
  }

  /**
   * Adds the elements in the specified _range to the end of the список.
   * Параметры: The _range whose elements are to be added.
   */
  final проц добавьОхват(T[] охват) {
    вставьОхват(размер_, охват);
  }

  /**
   * ditto
   */
  final проц добавьОхват(ИПеречислимый!(T) охват) {
    вставьОхват(размер_, охват);
  }

  /**
   * Inserts an element into the список at the specified _index.
   * Параметры:
   *   индекс = The _index at which элт should be inserted.
   *   элт = The element to вставь.
   */
  final проц вставь(цел индекс, T элт) {
    if (размер_ == элты_.length)
      гарантируйЁмкость(размер_ + 1);

    if (индекс < размер_)
      .копируй(элты_, индекс, элты_, индекс + 1, размер_ - индекс);

    элты_[индекс] = элт;
    размер_++;
  }

  /**
   * Inserts the elements of a _range into the список at the specified _index.
   * Параметры:
   *   индекс = The _index at which the new elements should be inserted.
   *   охват = The _range whose elements should be inserted into the список.
   */
  final проц вставьОхват(цел индекс, T[] охват) {
    foreach (элт; охват) {
      вставь(индекс++, элт);
    }
  }

  /**
   * ditto
   */
  final проц вставьОхват(цел индекс, ИПеречислимый!(T) охват) {
    foreach (элт; охват) {
      вставь(индекс++, элт);
    }
  }

  /**
   */
  final бул удали(T элт) {
    цел индекс = индексУ(элт);

    if (индекс < 0)
      return false;

    удалиПо(индекс);
    return true;
  }

  final проц удалиПо(цел индекс) {
    размер_--;
    if (индекс < размер_)
      .копируй(элты_, индекс + 1, элты_, индекс, размер_ - индекс);
    элты_[размер_] = T.init;
  }

  /**
   */
  final проц удалиОхват(цел индекс, цел счёт) {
    if (счёт > 0) {
      размер_ -= счёт;
      if (индекс < размер_)
        .копируй(элты_, индекс + счёт, элты_, индекс, размер_ - индекс);
      .сотри(элты_, размер_, счёт);
    }
  }

  /**
   */
  final бул содержит(T элт) {
    for (auto i = 0; i < размер_; i++) {
      if (equalityComparisonImpl(элты_[i], элт))
        return true;
    }
    return false;
  }

  /**
   */
  final проц сотри() {
    if (размер_ > 0) {
      .сотри(элты_, 0, размер_);
      размер_ = 0;
    }
  }

  /**
   */
  final цел индексУ(T элт) {
    return индексУ(элт, null);
  }

  /**
   */
  final цел индексУ(T элт, СравнениеНаРавенство!(T) comparison) {
    if (comparison is null) {
      comparison = (T a, T b) {
        return equalityComparisonImpl(a, b);
      };
    }

    for (auto i = 0; i < размер_; i++) {
      if (comparison(элты_[i], элт))
        return i;
    }

    return -1;
  }

  /**
   */
  final цел последнИндексУ(T элт, СравнениеНаРавенство!(T) comparison = null) {
    if (comparison is null) {
      comparison = (T a, T b) {
        return equalityComparisonImpl(a, b);
      };
    }

    for (auto i = размер_ - 1; i >= 0; i--) {
      if (comparison(элты_[i], элт))
        return i;
    }

    return -1;
  }

  /**
   */
  final проц сортируй(Сравнение!(T) comparison = null) {
    .сортируй(элты_, 0, размер_, comparison);
  }

  /**
   */
  final цел бинарныйПоиск(T элт, Сравнение!(T) comparison = null) {
    return .бинарныйПоиск(элты_, 0, размер_, элт, comparison);
  }

  /**
   */
  final проц копируйВ(T[] array) {
    .копируй(элты_, 0, array, 0, размер_);
  }

  /**
   */
  final T[] вМассив() {
    return элты_[0 .. размер_].dup;
  }

  /**
   */
  final T найди(Предикат!(T) match) {
    for (auto i = 0; i < размер_; i++) {
      if (match(элты_[i]))
        return элты_[i];
    }
    return T.init;
  }

  /**
   */
  final T найдиПоследний(Предикат!(T) match) {
    for (auto i = размер_ - 1; i >= 0; i--) {
      if (match(элты_[i]))
        return элты_[i];
    }
    return T.init;
  }

  /**
   */
  final Список найдиВсе(Предикат!(T) match) {
    auto список = new Список;
    for (auto i = 0; i < размер_; i++) {
      if (match(элты_[i]))
        список.добавь(элты_[i]);
    }
    return список;
  }

  /**
   */
  final цел найдиИндекс(Предикат!(T) match) {
    for (auto i = 0; i < размер_; i++) {
      if (match(элты_[i]))
        return i;
    }
    return -1;
  }

  /**
   */
  final цел найдиПоследнИндекс(Предикат!(T) match) {
    for (auto i = размер_ - 1; i >= 0; i--) {
      if (match(элты_[i]))
        return i;
    }
    return -1;
  }

  /**
   */
  final бул существует(Предикат!(T) match) {
    return найдиИндекс(match) != -1;
  }

  /**
   */
  final проц дляКаждого(Действие!(T) действие) {
    for (auto i = 0; i < размер_; i++) {
      действие(элты_[i]);
    }
  }

  /**
   */
  final бул верноДляВсех(Предикат!(T) match) {
    for (auto i = 0; i < размер_; i++) {
      if (!match(элты_[i]))
        return false;
    }
    return true;
  }

  /**
   */
  final Список!(T) дайОхват(цел индекс, цел счёт) {
    auto список = new Список!(T)(счёт);
    список.элты_[0 .. счёт] = элты_[индекс .. индекс + счёт];
    список.размер_ = счёт;
    return список;
  }

  /**
   */
  final Список!(ТВывод) преобразуй(ТВывод)(Преобразователь!(T, ТВывод) converter) {
    auto список = new Список!(ТВывод)(размер_);
    for (auto i = 0; i < размер_; i++) {
      список.элты_[i] = converter(элты_[i]);
    }
    список.размер_ = размер_;
    return список;
  }

  final цел счёт() {
    return размер_;
  }

  final проц объём(цел значение) {
    элты_.length = значение;
  }
  final цел объём() {
    return элты_.length;
  }

  final проц opIndexAssign(T значение, цел индекс) {
    if (индекс >= размер_)
      throw new ИсклАргументВнеОхвата("индекс");

    элты_[индекс] = значение;
  }
  final T opIndex(цел индекс) {
    if (индекс >= размер_)
      throw new ИсклАргументВнеОхвата("индекс");

    return элты_[индекс];
  }

  version (UseRanges) {
  alias пустой пуст_ли;
  alias выньФронт выкиньФронт;
  alias фронт фронт;
  
    final бул пустой() {
      бул рез = (индекс_ == размер_);
      if (рез)
        индекс_ = 0;
      return рез;
    }

    final проц выньФронт() {
      if (индекс_ < размер_)
        индекс_++;
    }

    final T фронт() {
      return элты_[индекс_];
    }
  }
  else {
    final цел opApply(цел delegate(ref T) действие) {
      цел r;

      for (auto i = 0; i < размер_; i++) {
        if ((r = действие(элты_[i])) != 0)
          break;
      }

      return r;
    }

    /**
     * Ditto
     */
    final цел opApply(цел delegate(ref цел, ref T) действие) {
      цел r;

      for (auto i = 0; i < размер_; i++) {
        if ((r = действие(i, элты_[i])) != 0)
          break;
      }

      return r;
    }
  }

  final бул opIn_r(T элт) {
    return содержит(элт);
  }

  private проц гарантируйЁмкость(цел min) {
    if (элты_.length < min) {
      цел n = (элты_.length == 0) ? DEFAULT_CAPACITY : элты_.length * 2;
      if (n < min)
        n = min;
      this.объём = n;
    }
  }

}

/**
 */
class СписокТолькоЧтен(T) : ИСписок!(T) {


  private Список!(T) список_;

  this(Список!(T) список) {
    список_ = список;
  }

  final цел индексУ(T элт) {
    return список_.индексУ(элт);
  }

  final бул содержит(T элт) {
    return список_.содержит(элт);
  }

  final проц сотри() {
    список_.сотри();
  }

  final цел счёт() {
    return список_.счёт;
  }

  final T opIndex(цел индекс) {
    return список_[индекс];
  }

  version (UseRanges) {
  
  alias пустой пуст_ли;
  alias выньФронт выкиньФронт;
  alias фронт фронт;
  
    final бул пустой() {
      return список_.пустой;
    }

    final проц выньФронт() {
      список_.выньФронт();
    }

    final T фронт() {
      return список_.фронт;
    }
  }
  else {
    final цел opApply(цел delegate(ref T) действие) {
      return список_.opApply(действие);
    }
  }

  protected проц добавь(T элт) {
    throw new ИсклНеПоддерживается;
  }

  protected проц вставь(цел индекс, T элт) {
    throw new ИсклНеПоддерживается;
  }

  protected бул удали(T элт) {
    throw new ИсклНеПоддерживается;
  }

  protected проц удалиПо(цел индекс) {
    throw new ИсклНеПоддерживается;
  }

  protected проц opIndexAssign(T элт, цел индекс) {
    throw new ИсклНеПоддерживается;
  }

  protected final ИСписок!(T) список() {
    return список_;
  }

}

class Подборка(T) : ИСписок!(T) {

  private ИСписок!(T) элты_;

  this() {
    this(new Список!(T));
  }

  this(ИСписок!(T) список) {
    элты_ = список;
  }

  final проц добавь(T элт) {
    insertItem(элты_.счёт, элт);
  }

  final проц вставь(цел индекс, T элт) {
    insertItem(индекс, элт);
  }

  final бул удали(T элт) {
    цел индекс = элты_.индексУ(элт);
    if (индекс < 0)
      return false;
    removeItem(индекс);
    return true;
  }

  final проц удалиПо(цел индекс) {
    removeItem(индекс);
  }

  final проц сотри() {
    clearItems();
  }

  final цел индексУ(T элт) {
    return элты_.индексУ(элт);
  }

  final бул содержит(T элт) {
    return элты_.содержит(элт);
  }

  final цел счёт() {
    return элты_.счёт;
  }

  final проц opIndexAssign(T значение, цел индекс) {
    setItem(индекс, значение);
  }
  final T opIndex(цел индекс) {
    return элты_[индекс];
  }

  version (UseRanges) {
  
  alias пустой пуст_ли;
  alias выньФронт выкиньФронт;
  alias фронт фронт;
  
    final бул пустой() {
      return элты_.пустой;
    }

    final проц выньФронт() {
      элты_.выньФронт();
    }

    final T фронт() {
      return элты_.фронт;
    }
  }
  else {
    final цел opApply(цел delegate(ref T) действие) {
      return элты_.opApply(действие);
    }
  }

  protected проц insertItem(цел индекс, T элт) {
    элты_.вставь(индекс, элт);
  }

  protected проц removeItem(цел индекс) {
    элты_.удалиПо(индекс);
  }

  protected проц clearItems() {
    элты_.сотри();
  }

  protected проц setItem(цел индекс, T значение) {
    элты_[индекс] = значение;
  }

  protected ИСписок!(T) items() {
    return элты_;
  }

}

private const цел[] PRIMES = [ 
  3, 7, 11, 17, 23, 29, 37, 47, 59, 71, 89, 107, 131, 163, 197, 239, 293, 353, 431, 521, 631, 761, 919, 
  1103, 1327, 1597, 1931, 2333, 2801, 3371, 4049, 4861, 5839, 7013, 8419, 10103, 12143, 14591, 
  17519, 21023, 25229, 30293, 36353, 43627, 52361, 62851, 75431, 90523, 108631, 130363, 156437, 
  187751, 225307, 270371, 324449, 389357, 467237, 560689, 672827, 807403, 968897, 1162687, 1395263, 
  1674319, 2009191, 2411033, 2893249, 3471899, 4166287, 4999559, 5999471, 7199369 ];

private цел дайПрайм(цел min) {
  
  бул isPrime(цел candidate) {
    if ((candidate & 1) == 0)
      return candidate == 2;

    цел limit = cast(цел).квкор(cast(дво)candidate);
    for (цел div = 3; div <= limit; div += 2) {
      if ((candidate % div) == 0)
        return false;
    }

    return true;
  }

  foreach (p; PRIMES) {
    if (p >= min)
      return p;
  }

  for (цел p = min | 1; p < цел.max; p += 2) {
    if (isPrime(p))
      return p;
  }

  return min;
}

/**
 */
class ИсклКлючНеНайден : Exception {

  this(ткст сообщение = "Ключ не был указан.") {
    super(сообщение);
  }

}

/**
 */
struct ПараКлючЗначение(K, V) {
  /**
   */
  K ключ;
  /**
   */
  V значение;

}

/**
 */
interface ИСловарь(K, V) : ИКоллекция!(ПараКлючЗначение!(K, V)) {

  /**
   */
  проц добавь(K ключ, V значение);

  /**
   */
  бул содержитКлюч(K ключ);

  /**
   */
  бул удали(K ключ);

  /**
   */
  бул пробуйДайЗначение(K ключ, out V значение);

  /**
   */
  проц opIndexAssign(V значение, K ключ);
  /**
   * ditto
   */
  V opIndex(K ключ);

  /**
   */
  ИКоллекция!(K) ключи();

  /**
   */
  ИКоллекция!(V) значения();

}

/**
 */
class Словарь(K, V) : ИСловарь!(K, V) {

alias КолекцияКлючей ПодборкаКлючей;
alias КолекцияЗначений ПодборкаЗначений;


  private struct Запись {
    цел hash; // -1 if not used
    цел следщ; // -1 if last
    K ключ;
    V значение;
  }

  /**
   */
  class КолекцияКлючей : ИКоллекция!(K) {

  	alias счёт посчитай;
	alias добавь добавь;
	alias удали удали;
	alias сотри сотри;
	alias содержит содержит_ли;
	
    version (UseRanges) {
      private цел currentIndex_;
    }

    /**
     */
    цел счёт() {
      return this.outer.счёт;
    }

    version (UseRanges) {
	
	alias пустой пуст_ли;
	alias выньФронт выкиньФронт;
	alias фронт фронт;
	
      бул пустой() {
        бул рез = (currentIndex_ == this.outer.count_);
        if (рез)
          currentIndex_ = 0;
        return рез;
      }

      проц выньФронт() {
        currentIndex_++;
      }

      K фронт() {
        return this.outer.записи_[currentIndex_].ключ;
      }
    }
    else {
      цел opApply(цел delegate(ref K) действие) {
        цел r;

        for (цел i = 0; i < this.outer.count_; i++) {
          if (this.outer.записи_[i].hash >= 0) {
            if ((r = действие(this.outer.записи_[i].ключ)) != 0)
              break;
          }
        }

        return r;
      }
    }

    protected проц добавь(K элт) {
    }

    protected проц сотри() {
    }

    protected бул содержит(K элт) {
      return false;
    }

    protected бул удали(K элт) {
      return false;
    }

  }

  /**
   */
  class КолекцияЗначений : ИКоллекция!(V) {

  alias счёт посчитай;
	alias добавь добавь;
	alias удали удали;
	alias сотри сотри;
	alias содержит содержит_ли;
	
    version (UseRanges) {
      private цел currentIndex_;
    }

    /**
     */
    цел счёт() {
      return this.outer.счёт;
    }

    version (UseRanges) {
	alias пустой пуст_ли;
	alias выньФронт выкиньФронт;
	alias фронт фронт;
	
      бул пустой() {
        бул рез = (currentIndex_ == this.outer.count_);
        if (рез)
          currentIndex_ = 0;
        return рез;
      }

      проц выньФронт() {
        currentIndex_++;
      }

      V фронт() {
        return this.outer.записи_[currentIndex_].значение;
      }
    }
    else {
      цел opApply(цел delegate(ref V) действие) {
        цел r;

        for (цел i = 0; i < this.outer.count_; i++) {
          if (this.outer.записи_[i].hash >= 0) {
            if ((r = действие(this.outer.записи_[i].значение)) != 0)
              break;
          }
        }

        return r;
      }
    }

    protected проц добавь(V элт) {
    }

    protected проц сотри() {
    }

    protected бул содержит(V элт) {
      return false;
    }

    protected бул удали(V элт) {
      return false;
    }

  }

  private const цел BITMASK = 0x7FFFFFFF;

  private ИСравнивательНаРавенство!(K) comparer_;
  private цел[] buckets_;
  private Запись[] записи_;
  private цел count_;
  private цел freeList_;
  private цел freeCount_;

  private КолекцияКлючей keys_;
  private КолекцияЗначений values_;

  version (UseRanges) {
    private цел currentIndex_;
  }

  /**
   */
  this(цел объём = 0, ИСравнивательНаРавенство!(K) comparer = null) {
    if (объём > 0)
      иниц(объём);
    if (comparer is null)
      comparer = СравнивательНаРавенство!(K).экземпляр;
    comparer_ = comparer;
  }

  /**
   */
  this(ИСравнивательНаРавенство!(K) comparer) {
    this(0, comparer);
  }

  /**
   */
  final проц добавь(K ключ, V значение) {
    вставь(ключ, значение, true);
  }

  /**
   */
  final бул содержитКлюч(K ключ) {
    return (найдиЗапись(ключ) >= 0);
  }

  /**
   */
  final бул содержитЗначение(V значение) {
    auto comparer = СравнивательНаРавенство!(V).экземпляр;
    for (auto i = 0; i < count_; i++) {
      if (записи_[i].hash >= 0 && comparer.равен(записи_[i].значение, значение))
        return true;
    }
    return false;
  }

  /**
   */
  final бул удали(K ключ) {
    if (buckets_ != null) {
      цел hash = comparer_.дайХэш(ключ) & BITMASK;
      цел bucket = hash % buckets_.length;
      цел last = -1;
      for (цел i = buckets_[bucket]; i >= 0; last = i, i = записи_[i].следщ) {
        if (записи_[i].hash == hash && comparer_.равен(записи_[i].ключ, ключ)) {
          if (last < 0)
            buckets_[bucket] = записи_[i].следщ;
          else
            записи_[last].следщ = записи_[i].следщ;
          записи_[i].hash = i;
          записи_[i].следщ = freeList_;
          записи_[i].ключ = K.init;
          записи_[i].значение = V.init;
          freeList_ = i;
          freeCount_++;
          return true;
        }
      }
    }
    return false;
  }

  /**
   */
  final проц сотри() {
    if (count_ != 0) {
      buckets_[] = -1;
      записи_[0 .. count_] = Запись.init;
      freeList_ = -1;
      count_ = freeCount_ = 0;
    }
  }

  /**
   */
  final бул пробуйДайЗначение(K ключ, out V значение) {
    цел индекс = найдиЗапись(ключ);
    if (индекс >= 0) {
      значение = записи_[индекс].значение;
      return true;
    }
    значение = V.init;
    return false;
  }

  /**
   */
  final КолекцияКлючей ключи() {
    if (keys_ is null)
      keys_ = new КолекцияКлючей;
    return keys_;
  }

  /**
   */
  final КолекцияЗначений значения() {
    if (values_ is null)
      values_ = new КолекцияЗначений;
    return values_;
  }

  /**
   */
  final цел счёт() {
    return count_ - freeCount_;
  }

  /**
   */
  final проц opIndexAssign(V значение, K ключ) {
    вставь(ключ, значение, false);
  }
  /**
   * ditto
   */
  final V opIndex(K ключ) {
    цел индекс = найдиЗапись(ключ);
    if (индекс >= 0)
      return записи_[индекс].значение;
    throw new ИсклКлючНеНайден;
  }

  version (UseRanges) {
    final бул пустой() {
      бул рез = (currentIndex_ == count_);
      if (рез)
        currentIndex_ = 0;
      return рез;
    }

    final проц выньФронт() {
      currentIndex_++;
    }

    final ПараКлючЗначение!(K, V) фронт() {
      return ПараКлючЗначение!(K, V)(записи_[currentIndex_].ключ, записи_[currentIndex_].значение);
    }
  }
  else {
    final цел opApply(цел delegate(ref ПараКлючЗначение!(K, V)) действие) {
      цел r;

      for (auto i = 0; i < count_; i++) {
        if (записи_[i].hash >= 0) {
          auto pair = ПараКлючЗначение!(K, V)(записи_[i].ключ, записи_[i].значение);
          if ((r = действие(pair)) != 0)
            break;
        }
      }

      return r;
    }
  }

  private проц иниц(цел объём) {
    buckets_.length = записи_.length = дайПрайм(объём);
    buckets_[] = -1;
  }

  private проц вставь(K ключ, V значение, бул добавь) {
    if (buckets_ == null)
      иниц(0);
    цел hash = comparer_.дайХэш(ключ) & BITMASK;
    for (цел i = buckets_[hash % $]; i >= 0; i = записи_[i].следщ) {
      if (записи_[i].hash == hash && comparer_.равен(записи_[i].ключ, ключ)) {
        записи_[i].значение = значение;
        return;
      }
    }

    цел индекс;
    if (freeCount_ > 0) {
      индекс = freeList_;
      freeList_ = записи_[индекс].следщ;
      freeCount_--;
    }
    else {
      if (count_ == записи_.length)
        увеличьЁмкость();
      индекс = count_;
      count_++;
    }

    цел bucket = hash % buckets_.length;
    записи_[индекс].hash = hash;
    записи_[индекс].следщ = buckets_[bucket];
    записи_[индекс].ключ = ключ;
    записи_[индекс].значение = значение;
    buckets_[bucket] = индекс;
  }

  private проц увеличьЁмкость() {
    цел newSize = дайПрайм(count_ * 2);
    цел[] newBuckets = new цел[newSize];
    Запись[] newEntries = new Запись[newSize];

    newBuckets[] = -1;
    newEntries = записи_;

    for (auto i = 0; i < count_; i++) {
      цел bucket = newEntries[i].hash % newSize;
      newEntries[i].следщ = newBuckets[bucket];
      newBuckets[bucket] = i;
    }

    buckets_ = newBuckets;
    записи_ = newEntries;
  }

  private цел найдиЗапись(K ключ) {
    if (buckets_ != null) {
      цел hash = comparer_.дайХэш(ключ) & BITMASK;
      for (цел i = buckets_[hash % $]; i >= 0; i = записи_[i].следщ) {
        if (записи_[i].hash == hash && comparer_.равен(записи_[i].ключ, ключ))
          return i;
      }
    }
    return -1;
  }

  protected проц добавь(ПараКлючЗначение!(K, V) pair) {
    добавь(pair.ключ, pair.значение);
  }

  protected бул удали(ПараКлючЗначение!(K, V) pair) {
    цел индекс = найдиЗапись(pair.ключ);
    if (индекс >= 0 && СравнивательНаРавенство!(V).экземпляр.равен(записи_[индекс].значение, pair.значение)) {
      удали(pair.ключ);
      return true;
    }
    return false;
  }

  protected бул содержит(ПараКлючЗначение!(K, V) pair) {
    цел индекс = найдиЗапись(pair.ключ);
    return индекс >= 0 && СравнивательНаРавенство!(V).экземпляр.равен(записи_[индекс].значение, pair.значение);
  }

}

/**
 */
class Очередь(T) : ИПеречислимый!(T) {

  private const цел DEFAULT_CAPACITY = 4;

  private T[] array_;
  private цел head_;
  private цел tail_;
  private цел размер_;

  version (UseRanges) {
    private цел currentIndex_ = -2;
  }

  /**
   */
  this(цел объём = 0) {
    array_.length = объём;
  }

  /**
   */
  this(T[] охват) {
    array_.length = DEFAULT_CAPACITY;
    foreach (элт; охват) {
      в_очередь(элт);
    }
  }

  /**
   */
  this(ИПеречислимый!(T) охват) {
    array_.length = DEFAULT_CAPACITY;
    foreach (элт; охват) {
      в_очередь(элт);
    }
  }

  /**
   */
  final проц в_очередь(T элт) {
    if (размер_ == array_.length) {
      цел newCapacity = array_.length * 200 / 100;
      if (newCapacity < array_.length + 4)
        newCapacity = array_.length + 4;
      устЁмкость(newCapacity);
    }

    array_[tail_] = элт;
    tail_ = (tail_ + 1) % array_.length;
    размер_++;
  }

  /**
   */
  final T из_очереди() {
    T removed = array_[head_];
    array_[head_] = T.init;
    head_ = (head_ + 1) % array_.length;
    размер_--;
    return removed;
  }

  /**
   */
  final T подбери() {
    return array_[head_];
  }

  /**
   */
  final бул содержит(T элт) {
    цел индекс = head_;
    цел счёт = размер_;

    auto comparer = СравнивательНаРавенство!(T).экземпляр;
    while (счёт-- > 0) {
      if (comparer.равен(array_[индекс], элт))
        return true;
      индекс = (индекс + 1) % array_.length;
    }

    return false;
  }

  /**
   */
  final проц сотри() {
    if (head_ < tail_) {
      .сотри(array_, head_, размер_);
    }
    else {
      .сотри(array_, head_, array_.length - head_);
      .сотри(array_, 0, tail_);
    }

    head_ = 0;
    tail_ = 0;
    размер_ = 0;
  }

  /**
   * $(I Property.)
   */
  final цел счёт() {
    return размер_;
  }

  version (UseRanges) {
    /**
     */
    final бул пустой() {
      бул рез = (currentIndex_ == размер_);
      // Reset текущ индекс.
      if (рез)
        currentIndex_ = -2;
      return рез;
    }

    /**
     */
    final проц выньФронт() {
      currentIndex_++;
    }

    /**
     */
    final T фронт() {
      if (currentIndex_ == -2)
        currentIndex_ = 0;
      return array_[currentIndex_];
    }
  }
  else {
    final цел opApply(цел delegate(ref T) действие) {
      цел r;

      for (auto i = 0; i < размер_; i++) {
        if ((r = действие(array_[i])) != 0)
          break;
      }

      return r;
    }
  }

  private проц устЁмкость(цел объём) {
    T[] newArray = new T[объём];
    if (размер_ > 0) {
      if (head_ < tail_) {
        .копируй(array_, head_, newArray, 0, размер_);
      }
      else {
        .копируй(array_, head_, newArray, 0, array_.length - head_);
        .копируй(array_, 0, newArray, cast(цел)array_.length - head_, tail_);
      }
    }

    array_ = newArray;
    head_ = 0;
    tail_ = (размер_ == объём) ? 0 : размер_;
  }

}

class СортированныйСписок(K, V) {


  private const цел DEFAULT_CAPACITY = 4;

  private ИСравниватель!(K) comparer_;
  private K[] keys_;
  private V[] values_;
  private цел размер_;

  this() {
    comparer_ = Сравниватель!(K).экземпляр;
  }

  this(цел объём) {
    keys_.length = объём;
    values_.length = объём;
    comparer_ = Сравниватель!(K).экземпляр;
  }

  final проц добавь(K ключ, V значение) {
    цел индекс = бинарныйПоиск!(K)(keys_, 0, размер_, ключ, &comparer_.сравни);
    вставь(~индекс, ключ, значение);
  }

  final бул удали(K ключ) {
    цел индекс = индексКлюча(ключ);
    if (индекс >= 0)
      удалиПо(индекс);
    return индекс >= 0;
  }

  final проц удалиПо(цел индекс) {
    размер_--;
    if (индекс < размер_) {
      .копируй(keys_, индекс + 1, keys_, индекс, размер_ - индекс);
      .копируй(values_, индекс + 1, values_, индекс, размер_ - индекс);
    }
    keys_[размер_] = K.init;
    values_[размер_] = V.init;
  }

  final проц сотри() {
    .сотри(keys_, 0, размер_);
    .сотри(values_, 0, размер_);
    размер_ = 0;
  }

  final цел индексКлюча(K ключ) {
    цел индекс = бинарныйПоиск!(K)(keys_, 0, размер_, ключ, &comparer_.сравни);
    if (индекс < 0)
      return -1;
    return индекс;
  }

  final цел индексЗначения(V значение) {
    foreach (i, v; values_) {
      if (equalityComparisonImpl(v, значение))
        return i;
    }
    return -1;
  }

  final бул содержитКлюч(K ключ) {
    return индексКлюча(ключ) >= 0;
  }

  final бул содержитЗначение(V значение) {
    return индексЗначения(значение) >= 0;
  }

  final цел счёт() {
    return размер_;
  }

  final проц объём(цел значение) {
    if (значение != keys_.length) {
      keys_.length = значение;
      values_.length = значение;
    }
  }
  final цел объём() {
    return keys_.length;
  }

  final K[] ключи() {
    return keys_.dup;
  }

  final V[] значения() {
    return values_.dup;
  }

  final V opIndex(K ключ) {
    цел индекс = индексКлюча(ключ);
    if (индекс >= 0)
      return values_[индекс];
    return V.init;
  }

  private проц вставь(цел индекс, K ключ, V значение) {
    if (размер_ == keys_.length)
      гарантируйЁмкость(размер_ + 1);

    if (индекс < размер_) {
      .копируй(keys_, индекс, keys_, индекс + 1, размер_ - индекс);
      .копируй(values_, индекс, values_, индекс + 1, размер_ - индекс);
    }

    keys_[индекс] = ключ;
    values_[индекс] = значение;
    размер_++;
  }

  private проц гарантируйЁмкость(цел min) {
    цел n = (keys_.length == 0) ? DEFAULT_CAPACITY : keys_.length * 2;
    if (n < min)
      n = min;
    this.объём = n;
  }

}