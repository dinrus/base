/**
 * Предоставляет механизм для обработки _событий.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.base.events;

debug import stdrus : скажифнс;

extern(C) Объект _d_toObject(ук);

alias проц delegate(Объект) DisposeEvent;
version(D_Version2) {
  extern(C) проц rt_attachDisposeEvent(Объект, DisposeEvent);
  extern(C) проц rt_detachDisposeEvent(Объект, DisposeEvent);
}
else {
  проц rt_attachDisposeEvent(Объект объ, DisposeEvent dispose) {
    объ.notifyRegister(dispose);
  }
  проц rt_detachDisposeEvent(Объект объ, DisposeEvent dispose) {
    объ.notifyUnRegister(dispose);
  }
}

struct ИнфОСоб(R, T...) {

  alias R delegate(T) ТДелегат;
  alias R function(T) ТФункция;

  enum Тип {
    Делегат,
    Функция
  }

  union {
    ТДелегат дг;
    ТФункция фн;
  }
  Тип тип;

  static ИнфОСоб opCall(ТДелегат дг) {
    ИнфОСоб сам;
    сам.дг = дг;
    сам.тип = Тип.Делегат;
    return сам;
  }

  static ИнфОСоб opCall(ТФункция фн) {
    ИнфОСоб сам;
    сам.фн = фн;
    сам.тип = Тип.Функция;
    return сам;
  }

  R вызови(T арги) {
    if (тип == Тип.Функция && фн !is null)
      return фн(арги);
    else if (тип == Тип.Делегат && дг !is null)
      return дг(арги);
    static if (!is(R == проц))
      return R.init;
  }

}

struct Событие(R, T...) {

  alias ИнфОСоб!(R, T) ТИнфОСоб;
  alias ТИнфОСоб.ТДелегат ТДелегат;
  alias ТИнфОСоб.ТФункция ТФункция;

  private ТИнфОСоб[] список_;
  private бцел размер_;

  alias opAddAssign добавь;

  проц opAddAssign(ТДелегат дг) {
    if (дг is null)
      return;

    добавьВСписок(ТИнфОСоб(дг));

    if (auto объ = _d_toObject(дг.ptr)) {
      // Tends to crash when delegate bodies attempt to access the родитель frame.
      // std.signals exhibits the same problem.
      rt_attachDisposeEvent(объ, &отпусти);
    }
  }

  проц opAddAssign(ТФункция фн) {
    if (фн is null)
      return;

    добавьВСписок(ТИнфОСоб(фн));
  }

  alias opSubAssign удали;

  проц opSubAssign(ТДелегат дг) {
    if (дг is null)
      return;

    for (бцел i = 0; i < размер_;) {
      if (список_[i].дг is дг) {
        удалиИзСписка(i);

        if (auto объ = _d_toObject(дг.ptr)) {
          rt_detachDisposeEvent(объ, &отпусти);
        }
      }
      else {
        i++;
      }
    }
  }

  проц opSubAssign(ТФункция фн) {
    if (фн is null)
      return;

    for (бцел i = 0; i < размер_;) {
      if (список_[i].фн is фн)
        удалиИзСписка(i);
      else
        i++;
    }
  }

  alias opCall вызови;

  R opCall(T арги) {
    if (размер_ == 0) {
      static if (!is(R == проц))
        return R.init;
    }
    else {
      static if (!is(R == проц)) {
        for (цел i = 0; i < размер_ - 1; i++)
          список_[i].вызови(арги);
        return список_[размер_ - 1].вызови(арги);
      }
      else {
        for (цел i = 0; i < размер_; i++)
          список_[i].вызови(арги);
      }
    }
  }

  проц сотри() {
    список_ = null;
    размер_ = 0;
  }

  бул пуст_ли() {
    return (размер_ == 0);
  }

  бцел счёт() {
    return размер_;
  }

  private проц добавьВСписок(ТИнфОСоб e) {
    бцел n = список_.length;

    if (n == 0)
      список_.length = 4;
    else if (n == размер_)
      список_.length = список_.length * 2;

    список_[n .. $] = ТИнфОСоб.init;
    список_[размер_++] = e;
  }

  private проц удалиИзСписка(бцел индекс) {
    размер_--;
    if (индекс < размер_) {
      auto времн = список_.dup;
      список_[индекс .. размер_] = времн[индекс + 1 .. размер_ + 1];
    }
    список_[размер_] = ТИнфОСоб.init;
  }

  private проц отпусти(Объект объ) {
    foreach (i, ref e; список_) {
      if (i < размер_ && _d_toObject(e.дг.ptr) is объ) {
        rt_detachDisposeEvent(объ, &отпусти);
        e.дг = null;
      }
    }
  }

}

/**
 * Класс-основа для классов, содержащих данные о событии.
 */
class АргиСоб {

  /// Представляет собой собетие без данных.
  static АргиСоб пустой;

  static this() {
    пустой = new АргиСоб;
  }

}

/**
 * Предоставляет данные для события, которое может быть отменено (cancellable событие).
 */
class АргиСобОтмена : АргиСоб {

  /// Значение, которое показывает, нужно ли отменять событие.
  бул отмена;

  /**
   * Инициализирует новый экземпляр.
   * Параметры: отмена = true для отмены события; иначе, false.
   */
  this(бул отмена = false) {
    this.отмена = отмена;
  }

}

/**
 * Шаблон, который можно использовать для декларации обработчика события.
 * Примеры:
 * ---
 * alias ТОбработчикСоб!(MyEventArgs) MyEventHandler;
 * ---
 */
template ТОбработчикСоб(ТАргиСоб = АргиСоб) {
  alias Событие!(проц, Объект, ТАргиСоб) ТОбработчикСоб;
}

alias ТОбработчикСоб!() ОбработчикСоб; /// Represents the метод that handles an событие with no событие данные.
alias ТОбработчикСоб!(АргиСобОтмена) ОбработчикСобОтмена; /// Represents the метод that handles a cancellable событие.
