/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.base.math;

private import stdrus : нч_ли, абс;
private import winapi : GetTickCount;

version(D_Version2) {
}
else {
/**
 * Returns the smaller of two numbers.
 * Параметры:
 *   val1 = The first число to сравни.
 *   val2 = The секунда число to сравни.
 * Возвращает: Параметр val1 or val2, whichever is smaller.
 */
T мин(T)(T val1, T val2) {
  static if (is(T == ббайт) ||
    is(T == байт) ||
    is(T == бкрат) ||
    is(T == крат) ||
    is(T == бцел) ||
    is(T == цел) ||
    is(T == бдол) ||
    is(T == дол)) {
    return (val1 > val2) ? val2 : val1;
  }
  else static if (is(T == плав)
    || is(T == дво)) {
    return (val1 < val2) ? val1 : нч_ли(val1) ? val1 : val2;
  }
  else
    static assert(false);
}

/**
 * Returns the larger of two numbers.
 * Параметры:
 *   val1 = The first число to сравни.
 *   val2 = The секунда число to сравни.
 * Возвращает: Параметр val1 or val2, whichever is larger.
 */
T макс(T)(T val1, T val2) {
  static if (is(T == ббайт) ||
    is(T == байт) ||
    is(T == бкрат) ||
    is(T == крат) ||
    is(T == бцел) ||
    is(T == цел)||
    is(T == бдол) ||
    is(T == дол)) {
    return (val1 < val2) ? val2 : val1;
  }
  else static if (is(T == плав) 
    || is(T == дво)) {
    return (val1 > val2) ? val1 : нч_ли(val1) ? val1 : val2;
  }
  else
    static assert(false);
}
}

дво случЧисло() {
  synchronized {
    static Случайное rand;
    if (rand is null)
      rand = new Случайное;
    return rand.следщДво();
  }
}

// Based on ran3 algorithm.
class Случайное {

  private const цел SEED = 161803398;
  private const цел BITS = 1000000000;

  private цел[56] seedList_;
  private цел next_, nextp_;

  this() {
    this(GetTickCount());
  }

  this(цел seed) {
    цел j = SEED - абс(seed);
    seedList_[55] = j;
    цел k = 1;
    for (цел c = 1; c < 55; c++) {
      цел i = (21 * c) % 55;
      seedList_[i] = k;
      k = j - k;
      if (k < 0)
        k += BITS;
      j = seedList_[i];
    }

    for (цел c = 1; c <= 4; c++) {
      for (цел d = 1; d <= 55; d++) {
        seedList_[d] -= seedList_[1 + (d + 30) % 55];
        if (seedList_[d] < 0)
          seedList_[d] += BITS;
      }
    }

    nextp_ = 21;
  }

  цел следщ() {
    if (++next_ >= 56)
      next_ = 1;
    if (++nextp_ >= 56)
      nextp_ = 1;
    цел рез = seedList_[next_] - seedList_[nextp_];
    if (рез < 0)
      рез += BITS;
    seedList_[next_] = рез;
    return рез;
  }

  цел следщ(цел макс) {
    return cast(цел)(sample() * макс);
  }

  цел следщ(цел мин, цел макс) {
    цел охват = макс - мин;
    if (охват < 0) {
      дол lrange = cast(дол)(макс - мин);
      return cast(цел)(cast(дол)(sample() * cast(дво)lrange) + мин);
    }
    return cast(цел)(sample() * охват) + мин;
  }

  дво следщДво() {
    return sample();
  }

  protected дво sample() {
    return следщ() * (1.0 / BITS);
  }

}