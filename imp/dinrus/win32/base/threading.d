/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.base.threading;

import winapi: INFINITE;
 import win32.base.core,
  win32.base.string,
  win32.base.native,
  win32.base.time;

version(D_Version2) {
}
else {
/**
 * Предоставляет ните-локальные переменные.
 */
class НитеЛок(T) {

  private struct ДанныеНлх {
  
    T значение;
  }

  private бцел slot_;
  private T defaultValue_;

  /**
   * Initializes a new экземпляр.
   */
  this(lazy T дефолтнЗнач = T.init) {
    defaultValue_ = cast(T)дефолтнЗнач();
    slot_ = TlsAlloc();
  }

  ~this() {
    if (auto tlsData = cast(ДанныеНлх*)TlsGetValue(slot_))
      gc_removeRoot(tlsData);

    TlsFree(slot_);
    slot_ = cast(бцел)-1;
  }

  /**
   * Gets the значение in the текущ thread's копируй of this экземпляр.
   * Возвращает: The текущ thread's копируй of this экземпляр.
   */
  final T дай() {
    if (auto tlsData = cast(ДанныеНлх*)TlsGetValue(slot_))
      return tlsData.значение;
    return defaultValue_;
  }

  /**
   * Sets the текущ thread's копируй of this экземпляр to the specified _value.
   * Параметры: значение = The _value to be stored in the текущ thread's копируй of this экземпляр.
   */
  final проц уст(T значение) {
    auto tlsData = cast(ДанныеНлх*)TlsGetValue(slot_);
    if (tlsData is null) {
      tlsData = new ДанныеНлх;
      gc_addRoot(tlsData);

      TlsSetValue(slot_, tlsData);
    }
    tlsData.значение = значение;
  }

}
}

/**
 * Suspends the текущ thread for a specified время.
 * Параметры: миллисекунды = The число of _milliseconds for which the thread is blocked. Specify -1 to block the thread indefinitely.
 */
проц спи(бцел миллисекунды) {
  .Sleep(миллисекунды);
}

/**
 * Suspends the текущ thread for a specified время.
 * Параметры: таймаут = The amount of время for which the thread is blocked. Specify -1 to block the thread indefinitely.
 */
проц спи(ВремИнтервал таймаут) {
  .Sleep(cast(бцел)таймаут.всегоМиллисекунд);
}

enum ПРежимСбросаСобытия {
  Авто,
  Ручной
}

abstract class УкзЖди {

  private Укз handle_ = cast(Укз)INVALID_HANDLE_VALUE;

  проц закрой() {
    if (handle_ != Укз.init) {
      CloseHandle(handle_);
      handle_ = Укз.init;
    }
  }

  бул ждиОдин(бцел millisecondsTimeout = INFINITE) {
    бцел r = WaitForSingleObjectEx(handle_, millisecondsTimeout, cast(BOOL)1);
    return (r != WAIT_ABANDONED && r != WAIT_TIMEOUT);
  }

  бул ждиОдин(ВремИнтервал таймаут) {
    return ждиОдин(cast(бцел)таймаут.всегоМиллисекунд);
  }

  static бул ждиВсе(УкзЖди[] waitHandles, бцел millisecondsTimeout = INFINITE) {
    Укз[] handles = new Укз[waitHandles.length];
    foreach (i, waitHandle; waitHandles) {
      handles[i] = waitHandle.handle_;
    }

    бцел r = WaitForMultipleObjectsEx(handles.length, handles.ptr, cast(BOOL)1, millisecondsTimeout, cast(BOOL)1);
    return (r != WAIT_ABANDONED && r != WAIT_TIMEOUT);
  }

  static бцел ждиЛюб(УкзЖди[] waitHandles, бцел millisecondsTimeout = INFINITE) {
    Укз[] handles = new Укз[waitHandles.length];
    foreach (i, waitHandle; waitHandles) {
      handles[i] = waitHandle.handle_;
    }

    return WaitForMultipleObjectsEx(handles.length, handles.ptr, 0, millisecondsTimeout, 1);
  }

  static бул сигналИЖди(УкзЖди toSignal, УкзЖди toWaitOn, бцел millisecondsTimeout = INFINITE) {
    бцел r = SignalObjectAndWait(toSignal.handle_, toWaitOn.handle_, millisecondsTimeout, 1);
    return (r != WAIT_ABANDONED && r != WAIT_TIMEOUT);
  }

  static бул сигналИЖди(УкзЖди toSignal, УкзЖди toWaitOn, ВремИнтервал таймаут) {
    return сигналИЖди(toSignal, toWaitOn, cast(бцел)таймаут.всегоМиллисекунд);
  }

  проц указатель(Укз значение) {
    if (значение == Укз.init)
      handle_ = INVALID_HANDLE_VALUE;
    else
      handle_ = указатель;
  }
  Укз указатель() {
    if (handle_ == Укз.init)
      return INVALID_HANDLE_VALUE;
    return handle_;
  }

}

class УкзЖдиСоб : УкзЖди {

  this(бул начСостояние, ПРежимСбросаСобытия mode) {
    handle_ = CreateEvent(null, (mode == ПРежимСбросаСобытия.Ручной) ? 1 : 0, начСостояние ? 1 : 0, null);
  }

  final бул уст() {
    return SetEvent(handle_) != 0;
  }

  final бул сбрось() {
    return ResetEvent(handle_) != 0;
  }

}

final class СобАвтоСброс : УкзЖдиСоб {

  this(бул начСостояние) {
    super(начСостояние, ПРежимСбросаСобытия.Авто);
  }

}

final class СобРучнойСброс : УкзЖдиСоб {

  this(бул начСостояние) {
    super(начСостояние, ПРежимСбросаСобытия.Ручной);
  }

}

final class Мютекс : УкзЖди {

  this(бул initiallyOwned = false, ткст имя = null) {
    Укз hMutex = CreateMutex(null, (initiallyOwned ? 1 : 0), имя.вУтф16н());
    бцел ошибка = GetLastError();

    if (ошибка == ERROR_ACCESS_DENIED && (hMutex == Укз.init || hMutex == INVALID_HANDLE_VALUE))
      hMutex = OpenMutex(MUTEX_MODIFY_STATE | SYNCHRONIZE, 0, имя.вУтф16н());

    handle_ = hMutex;
  }

  проц отпусти() {
    ReleaseMutex(handle_);
  }

}

final class Семафор : УкзЖди {

  this(цел начСчёт, цел максСчёт, ткст имя = null) {
    handle_ = CreateSemaphore(null, начСчёт, максСчёт, имя.вУтф16н());
  }

  цел отпусти(цел releaseCount = 1) {
    цел prevCount;
    if (!ReleaseSemaphore(handle_, releaseCount, prevCount))
      throw new Exception("При добавлении счёта семафору будет превышен допустимый максимум.");
    return prevCount;
  }

}