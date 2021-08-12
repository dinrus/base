module win32.loc.num;

import win32.base.core,
  win32.loc.consts,
  win32.loc.core,
  win32.com.core;
import stdrus, cidrus : strlen;
debug import stdrus : скажифнс;

private enum {
  NAN_FLAG = 0x80000000,
  INFINITY_FLAG = 0x7FFFFFFF,
  EXP = 0x07FF
}

private extern(C) сим* ecvt(дво d, цел цифры, out цел decpt, out цел знак);

/*package*/ struct Число {

  цел точность;
  цел шкала;
  цел знак;
  сим[дол.sizeof * 8] цифры = void;

  static Число opCall(дол значение, цел точность) {
    Число n;
    n.точность = точность;
    if (значение < 0) {
      n.знак = 1;
      значение = -значение;
    }

    сим[20] буфер;
    цел i = буфер.length;
    while (значение != 0) {
      буфер[--i] = cast(сим)(значение % 10 + '0');
      значение /= 10;
    }

    цел end = n.шкала = -(i - буфер.length);
    n.цифры[0 .. end] = буфер[i .. i + end];
    n.цифры[end] = '\0';

    return n;
  }

  static Число opCall(дво значение, цел точность) {
    Число n;
    n.точность = точность;

    сим* p = n.цифры.ptr;
    дол bits = *cast(дол*)&значение;
    дол mant = bits & 0x000FFFFFFFFFFFFF;
    цел exp = cast(цел)((bits >> 52) & EXP);

    сим* текст = ecvt(значение, точность, n.шкала, n.знак);
    if (*текст != '0') {
      while (*текст != '\0')
        *p++ = *текст++;
    }
    *p = '\0';

    return n;
  }

  static Число opCall(Decimal значение) {

    бцел d32DivMod1E9(бцел hi32, бцел *lo32) {
      бдол n = cast(бдол)hi32 << 32 | *lo32;
      *lo32 = cast(бцел)(n / 1000000000);
      return cast(бцел)(n % 1000000000);
    }

    бцел decDivMod1E9(Decimal* значение) {
      return d32DivMod1E9(d32DivMod1E9(d32DivMod1E9(0, &значение.Старш32), &значение.Средн32), &значение.Младш32);
    }

    Число n;
    n.точность = 29;

    if (значение.знак)
      n.знак = 1;

    сим[30] буфер;
    цел i = буфер.length;
    Decimal d = значение;
    while (d.Средн32 | d.Старш32) {
      цел цифры = 9;
      бцел x = decDivMod1E9(&d);
      while (--цифры >= 0 || x != 0) {
        буфер[--i] = cast(сим)(x % 10 + '0');
        x /= 10;
      }
    }
    бцел x = d.Младш32;
    while (x != 0) {
      буфер[--i] = cast(сим)(x % 10 + '0');
      x /= 10;
    }
    цел end = -(i - буфер.length);
    n.шкала = -(i - буфер.length) - d.шкала;
    n.цифры[0 .. end] = буфер[i .. i + end];
    n.цифры[end] = '\0';

    return n;
  }

  проц округли(цел поз) {
    цел индекс;
    while (индекс < поз && цифры[индекс] != '\0') индекс++;

    if (индекс == поз && цифры[индекс] >= '5') {
      while (индекс > 0 && цифры[индекс - 1] == '9') индекс--;

      if (индекс > 0)
        цифры[индекс - 1]++;
      else {
        шкала++;
        цифры[0] = '1';
        индекс = 1;
      }
    }
    else
      while (индекс > 0 && цифры[индекс - 1] == '0') индекс--;

    if (индекс == 0) {
      шкала = 0;
      знак = 0;
    }

    цифры[индекс] = '\0';
  }

  бул вДол(out дол значение) {
    цел i = шкала;
    if (i > 20 || i < точность)
      return false;

    дол v = 0;
    сим* p = цифры.ptr;
    while (--i >= 0) {
      if (cast(бдол)v > (бдол.max / 10))
        return false;
      v *= 10;
      if (*p != '\0')
        v += *p++ - '0';
    }

    if (знак)
      v = -v;
    else if (v < 0)
      return false;

    значение = v;
    return true;
  }

  бул вДво(out дво значение) {

    const бдол[] pow10 = [
      0xa000000000000000UL,
      0xc800000000000000UL,
      0xfa00000000000000UL,
      0x9c40000000000000UL,
      0xc350000000000000UL,
      0xf424000000000000UL,
      0x9896800000000000UL,
      0xbebc200000000000UL,
      0xee6b280000000000UL,
      0x9502f90000000000UL,
      0xba43b74000000000UL,
      0xe8d4a51000000000UL,
      0x9184e72a00000000UL,
      0xb5e620f480000000UL,
      0xe35fa931a0000000UL,
      0xcccccccccccccccdUL,
      0xa3d70a3d70a3d70bUL,
      0x83126e978d4fdf3cUL,
      0xd1b71758e219652eUL,
      0xa7c5ac471b478425UL,
      0x8637bd05af6c69b7UL,
      0xd6bf94d5e57a42beUL,
      0xabcc77118461ceffUL,
      0x89705f4136b4a599UL,
      0xdbe6fecebdedd5c2UL,
      0xafebff0bcb24ab02UL,
      0x8cbccc096f5088cfUL,
      0xe12e13424bb40e18UL,
      0xb424dc35095cd813UL,
      0x901d7cf73ab0acdcUL,
      0x8e1bc9bf04000000UL,
      0x9dc5ada82b70b59eUL,
      0xaf298d050e4395d6UL,
      0xc2781f49ffcfa6d4UL,
      0xd7e77a8f87daf7faUL,
      0xefb3ab16c59b14a0UL,
      0x850fadc09923329cUL,
      0x93ba47c980e98cdeUL,
      0xa402b9c5a8d3a6e6UL,
      0xb616a12b7fe617a8UL,
      0xca28a291859bbf90UL,
      0xe070f78d39275566UL,
      0xf92e0c3537826140UL,
      0x8a5296ffe33cc92cUL,
      0x9991a6f3d6bf1762UL,
      0xaa7eebfb9df9de8aUL,
      0xbd49d14aa79dbc7eUL,
      0xd226fc195c6a2f88UL,
      0xe950df20247c83f8UL,
      0x81842f29f2cce373UL,
      0x8fcac257558ee4e2UL,
    ];

    const бцел[] pow10Exp = [ 
      4, 7, 10, 14, 17, 20, 24, 27, 30, 34, 
      37, 40, 44, 47, 50, 54, 107, 160, 213, 266, 
      319, 373, 426, 479, 532, 585, 638, 691, 745, 798, 
      851, 904, 957, 1010, 1064, 1117 ];

    бцел getDigits(сим* p, цел len) {
      сим* end = p + len;
      бцел r = *p - '0';
      p++;
      while (p < end) {
        r = 10 * r + *p - '0';
        p++;
      }
      return r;
    }

    бдол mult64(бцел val1, бцел val2) {
      return cast(бдол)val1 * cast(бдол)val2;
    }

    бдол mult64L(бдол val1, бдол val2) {
      бдол v = mult64(cast(бцел)(val1 >> 32), cast(бцел)(val2 >> 32));
      v += mult64(cast(бцел)(val1 >> 32), cast(бцел)val2) >> 32;
      v += mult64(cast(бцел)val1, cast(бцел)(val2 >> 32)) >> 32;
      return v;
    }

    сим* p = цифры.ptr;
    цел счёт = strlen(p);
    цел лево = счёт;

    while (*p == '0') {
      лево--;
      p++;
    }
    // If the цифры consist of nothing but zeros...
    if (лево == 0) {
      значение = 0.0;
      return true;
    }

    // Get цифры, 9 at a время.
    цел n = (лево > 9) ? 9 : лево;
    лево -= n;
    бдол bits = getDigits(p, n);
    if (лево > 0) {
      n = (лево > 9) ? 9 : лево;
      лево -= n;
      bits = mult64(cast(бцел)bits, cast(бцел)(pow10[n - 1] >>> (64 - pow10Exp[n - 1])));
      bits += getDigits(p + 9, n);
    }

    цел шкала = this.шкала - (счёт - лево);
    цел s = (шкала < 0) ? -шкала : шкала;
    if (s >= 352) {
      *cast(дол*)&значение = (шкала > 0) ? 0x7FF0000000000000 : 0;
      return false;
    }

    // Normalise mantissa and bits.
    цел bexp = 64;
    цел nzero;
    if ((bits >> 32) != 0)
      nzero = 32;
    if ((bits >> (16 + nzero)) != 0)
      nzero += 16;
    if ((bits >> (8 + nzero)) != 0)
      nzero += 8;
    if ((bits >> (4 + nzero)) != 0)
      nzero += 4;
    if ((bits >> (2 + nzero)) != 0)
      nzero += 2;
    if ((bits >> (1 + nzero)) != 0)
      nzero++;
    if ((bits >> nzero) != 0)
      nzero++;
    bits <<= 64 - nzero;
    bexp -= 64 - nzero;

    // Get decimal exponent.
    if ((s & 15) != 0) {
      цел expMult = pow10Exp[(s & 15) - 1];
      bexp += (шкала < 0) ? (-expMult + 1) : expMult;
      bits = mult64L(bits, pow10[(s & 15) + ((шкала < 0) ? 15 : 0) - 1]);
      if ((bits & 0x8000000000000000) == 0) {
        bits <<= 1;
        bexp--;
      }
    }
    if ((s >> 4) != 0) {
      цел expMult = pow10Exp[15 + ((s >> 4) - 1)];
      bexp += (шкала < 0) ? (-expMult + 1) : expMult;
      bits = mult64L(bits, pow10[30 + ((s >> 4) + ((шкала < 0) ? 21 : 0) - 1)]);
      if ((bits & 0x8000000000000000) == 0) {
        bits <<= 1;
        bexp--;
      }
    }
    
    // Round and шкала.
    if (cast(бцел)bits & (1 << 10) != 0) {
      bits += (1 << 10) - 1 + (bits >>> 11) & 1;
      bits >>= 11;
      if (bits == 0)
        bexp++;
    }
    else
      bits >>= 11;
    bexp += 1022;
    if (bexp <= 0) {
      if (bexp < -53)
        bits = 0;
      else
        bits >>= (-bexp + 1);
    }
    bits = (cast(бдол)bexp << 52) + (bits & 0x000FFFFFFFFFFFFF);

    if (знак)
      bits |= 0x8000000000000000;

    значение = *cast(дво*)&bits;
    return true;
  }

  бул toDecimal(out Decimal значение) {

    проц decShiftLeft(ref Decimal значение) {
      бцел c0 = (значение.Младш32 & 0x80000000) ? 1 : 0;
      бцел c1 = (значение.Средн32 & 0x80000000) ? 1 : 0;
      значение.Младш32 <<= 1;
      значение.Средн32 = значение.Средн32 << 1 | c0;
      значение.Старш32 = значение.Старш32 << 1 | c1;
    }

    бул decAddCarry(ref бцел значение, бцел i) {
      бцел v = значение;
      бцел sum = v + i;
      значение = sum;
      return sum < v || sum < i ? true : false;
    }

    проц decAdd(ref Decimal значение, ref Decimal d) {
      if (decAddCarry(значение.Младш32, d.Младш32)) {
        if (decAddCarry(значение.Средн32, 1))
          decAddCarry(значение.Старш32, 1);
      }
      if (decAddCarry(значение.Средн32, d.Средн32))
        decAddCarry(значение.Старш32, 1);
      decAddCarry(значение.Старш32, d.Старш32);
    }

    проц decMul10(ref Decimal значение) {
      Decimal d = значение;
      decShiftLeft(значение);
      decShiftLeft(значение);
      decAdd(значение, d);
      decShiftLeft(значение);
    }

    проц decAddInt(ref Decimal значение, бцел i) {
      if (decAddCarry(значение.Младш32, i)) {
        if (decAddCarry(значение.Средн32, i))
          decAddCarry(значение.Старш32, i);
      }
    }

    сим* p = цифры.ptr;
    цел e = шкала;

    if (p != null) {
      if (e > 29 || e < -29)
        return false;

      while ((e > 0 || *p && e > -28) 
        && (значение.Старш32 < 0x19999999 || значение.Старш32 == 0x19999999
        && (значение.Средн32 < 0x99999999 || значение.Средн32 == 0x99999999
        && (значение.Младш32 < 0x99999999 || значение.Младш32 == 0x99999999 && *p <= '5')))) {
        decMul10(значение);
        if (*p)
          decAddInt(значение, *p++ - '0');
        e--;
      }

      if (*p++ >= '5') {
        бул округли = true;

        if (*(p - 1) == '5' && *(p - 2) % 2 == 0) {
          цел c = 20;
          while (*p == '0' && c != 0) {
            p++;
            c--;
          }
          if (*p == '\0' || c == 0) {
            округли = false;
          }
        }

        if (округли) {
          decAddInt(значение, 1);
          if ((значение.Старш32 | значение.Средн32 | значение.Младш32) == 0) {
            значение.Старш32 = 0x19999999;
            значение.Средн32 = 0x99999999;
            значение.Младш32 = 0x9999999A;
            e++;
          }
        }
      }
    }

    if (e > 0)
      return false;
    значение.шкала = cast(ббайт)-e;
    значение.знак = знак ? DECIMAL_NEG : cast(ббайт)0;
    return true;
  }

  static бул пробуйРазбор(ткст s, ПСтилиЧисел styles, ФорматЧисла nf, out Число рез) {

    enum ParseState {
      None = 0x0,
      Sign = 0x1,
      Parens = 0x2,
      Digits = 0x4,
      NonZero = 0x8,
      Decimal = 0x10,
      Currency = 0x20
    }

    цел eat(ткст what, ткст within, цел at) {
      if (at >= within.length)
        return -1;
      цел i;
      while (at < within.length && i < what.length) {
        if (within[at] != what[i])
          return -1;
        i++;
        at++;
      }
      return i;
    }

    бул пробел_ли(сим c) {
      return c == 0x20 || (c >= '\t' && c <= '\r');
    }

    ткст символВалюты = ((styles & ПСтилиЧисел.CurrencySymbol) != 0) ? nf.символВалюты : null;
    ткст decimalSeparator = ((styles & ПСтилиЧисел.CurrencySymbol) != 0) ? nf.разделительДесятичнВалют : nf.разделительДесятичнЧисла;
    ткст groupSeparator = ((styles & ПСтилиЧисел.CurrencySymbol) != 0) ? nf.разделительГруппыВалют : nf.разделительГруппыЧисел;
    ткст altDecimalSeparator = ((styles & ПСтилиЧисел.CurrencySymbol) != 0) ? nf.разделительДесятичнЧисла : null;
    ткст altGroupSeparator = ((styles & ПСтилиЧисел.CurrencySymbol) != 0) ? nf.разделительГруппыЧисел : null;

    рез.шкала = 0;
    рез.знак = 0;

    ParseState state;
    цел счёт, end, поз, eaten;
    бул isSigned;

    while (true) {
      if (поз == s.length) break;
      сим c = s[поз];
      if ((isSigned = (((styles & ПСтилиЧисел.LeadingSign) != 0) && ((state & ParseState.Sign) == 0))) != 0 
        && (eaten = eat(nf.положитЗнак, s, поз)) != -1) {
        state |= ParseState.Sign;
        поз += eaten;
      }
      else if (isSigned && (eaten = eat(nf.отрицатЗнак, s, поз)) != -1) {
        state |= ParseState.Sign;
        поз += eaten;
        рез.знак = 1;
      }
      else if (c == '(' &&
        (styles & ПСтилиЧисел.Parentheses) != 0 && ((state & ParseState.Sign) == 0)) {
        state |= ParseState.Sign | ParseState.Parens;
        рез.знак = 1;
        поз++;
      }
      else if ((символВалюты != null && (eaten = eat(символВалюты, s, поз)) != -1)) {
        state |= ParseState.Currency;
        символВалюты = null;
        поз += eaten;
      }
      else if (!(пробел_ли(c) && ((styles & ПСтилиЧисел.LeadingWhite) != 0)
        && ((state & ParseState.Sign) == 0 
        || ((state & ParseState.Sign) != 0 && ((state & ParseState.Currency) != 0 || nf.образецОтрицатЧисла == 2)))))
        break;
      else поз++;
    }

    while (true) {
      if (поз == s.length) break;

      сим c = s[поз];
      if (c >= '0' && c <= '9') {
        state |= ParseState.Digits;
        if (c != '0' || (state & ParseState.NonZero) != 0) {
          if (счёт < рез.цифры.length - 1) {
            рез.цифры[счёт++] = c;
            if (c != '0')
              end = счёт;
          }
          if ((state & ParseState.Decimal) == 0)
            рез.шкала++;
          state |= ParseState.NonZero;
        }
        else if ((state & ParseState.Decimal) != 0)
          рез.шкала--;
        поз++;
      }
      else if ((styles & ПСтилиЧисел.DecimalPoint) != 0 && (state & ParseState.Decimal) == 0 && (eaten = eat(decimalSeparator, s, поз)) != -1 
        || (state & ParseState.Currency) != 0 && (eaten = eat(altDecimalSeparator, s, поз)) != -1) {
        state |= ParseState.Decimal;
        поз += eaten;
      }
      else if ((styles & ПСтилиЧисел.Thousands) != 0 && (state & ParseState.Digits) != 0 && (state & ParseState.Decimal) == 0 
        && ((eaten = eat(groupSeparator, s, поз)) != -1 || (state & ParseState.Currency) != 0 
        && (eaten = eat(altGroupSeparator, s, поз)) != -1))
        поз += eaten;
      else break;
    }

    рез.точность = end;
    рез.цифры[end] = '\0';

    if ((state & ParseState.Digits) != 0) {
      while (true) {
        if (поз >= s.length) break;

        сим c = s[поз];
        if ((isSigned = ((styles & ПСтилиЧисел.TrailingSign) != 0 && (state & ParseState.Sign) == 0)) != 0 
          && (eaten = eat(nf.положитЗнак, s, поз)) != -1) {
          state |= ParseState.Sign;
          поз += eaten;
        }
        else if (isSigned && (eaten = eat(nf.отрицатЗнак, s, поз)) != -1) {
          state |= ParseState.Sign;
          рез.знак = 1;
          поз += eaten;
        }
        else if (c == ')' && (state & ParseState.Parens) != 0)
          state &= ~ParseState.Parens;
        else if (символВалюты != null && (eaten = eat(символВалюты, s, поз)) != -1) {
          символВалюты = null;
          поз += eaten;
        }
        else if (!(пробел_ли(c) & (styles & ПСтилиЧисел.TrailingWhite) != 0))
          break;
        else поз++;
      }

      if ((state & ParseState.Parens) == 0) {
        if ((state & ParseState.NonZero) == 0) {
          рез.шкала = 0;
          if ((state & ParseState.Decimal) == 0)
            рез.знак = 0;
        }
        return true;
      }
      return false;
    }
    return false;
  }

  ткст вТкст(сим format, цел length, ФорматЧисла nf, бул isDecimal = false) {
    ткст ret;

    switch (format) {
      case 'n', 'N':
        if (length < 0)
          length = nf.члоДесятичнЦифр;
        округли(шкала + length);
        version(D_Version2) {
          фмЧисло(this, ret, length, nf);
        }
        else {
          фмЧисло(*this, ret, length, nf);
        }
        break;
      case 'g', 'G':
        бул doRounding = true;
        if (length < 1) {
          if (isDecimal && length == -1) {
            length = 29;
            doRounding = false;
          }
          else
            length = точность;
        }
        if (doRounding)
          округли(length);
        else if (isDecimal && цифры[0] == '\0')
          знак = 0;
        if (знак)
          ret ~= nf.отрицатЗнак;
        version(D_Version2) {
          фмОбщ(this, ret, length, (format == 'g') ? 'e' : 'E', nf);
        }
        else {
          фмОбщ(*this, ret, length, (format == 'g') ? 'e' : 'E', nf);
        }
        break;
      case 'c', 'C':
        if (length < 0)
          length = nf.десятичнЦифрыВалюты;
        округли(шкала + length);
        version(D_Version2) {
          фмВалюта(this, ret, length, nf);
        }
        else {
          фмВалюта(*this, ret, length, nf);
        }
        break;
      case 'f', 'F':
        if (length < 0)
          length = nf.члоДесятичнЦифр;
        округли(шкала + length);
        if (знак)
          ret ~= nf.отрицатЗнак;
        version(D_Version2) {
          formatFixed(this, ret, length, null, nf.разделительДесятичнЧисла, null);
        }
        else {
          formatFixed(*this, ret, length, null, nf.разделительДесятичнЧисла, null);
        }
        break;
      default:
    }

    return ret;
  }

  ткст toStringFormat(ткст format, ФорматЧисла nf) {
    бул hasGroups = false, scientific = false;
    цел groupCount = 0, groupPos = -1, pointPos = -1;
    цел first = цел.max, last, счёт, adjust;

    цел n = 0;
    сим c;
    while (n < format.length) {
      c = format[n++];

      switch (c) {
        case '#':
          счёт++;
          break;
        case '0':
          if (first == цел.max)
            first = счёт;
          счёт++;
          last = счёт;
          break;
        case '%':
          adjust += 2;
          break;
        case '.':
          if (pointPos < 0)
            pointPos = счёт;
          break;
        case ',':
          if (счёт > 0 && pointPos < 0) {
            if (groupPos >= 0) {
              if (groupPos == счёт) {
                groupCount++;
                break;
              }
              hasGroups = true;
            }
            groupPos = счёт;
            groupCount = 1;
          }
          break;
        case '\'', '\"':
          while (n < format.length && format[n++] != c) {}
          break;
        case '\\':
          if (n < format.length) n++;
          break;
        default:
          break;
      }
    }

    if (pointPos < 0)
      pointPos = счёт;

    if (groupPos >= 0) {
      if (groupPos == pointPos)
        adjust -= groupCount * 3;
      else
        hasGroups = true;
    }

    if (цифры[0] != '\0') {
      шкала += adjust;
      округли(scientific ? счёт : шкала + счёт - pointPos);
    }
    else {
      знак = 0;
      шкала = 0;
    }

    first = (first < pointPos) ? pointPos - first : 0;
    last = (last > pointPos) ? pointPos - last : 0;

    цел поз = pointPos;
    цел extra = 0;
    if (!scientific) {
      поз = (шкала > pointPos) ? шкала : pointPos;
      extra = шкала - pointPos;
    }

    ткст groupSeparator = nf.разделительГруппыЧисел;
    ткст decimalSeparator = nf.разделительДесятичнЧисла;

    цел[] groupPositions;
    цел groupIndex = -1;
    if (hasGroups) {
      if (nf.размерыГруппыЧисла.length == 0)
        hasGroups = false;
      else {
        цел groupSizesTotal = nf.размерыГруппыЧисла[0];
        цел groupSize = groupSizesTotal;
        цел digitsTotal = поз + ((extra < 0) ? extra : 0);
        цел digitCount = (first > digitsTotal) ? first : digitsTotal;

        цел sizeIndex = 0;
        while (digitCount > groupSizesTotal) {
          if (groupSize == 0)
            break;
          groupPositions ~= groupSizesTotal;
          groupIndex++;
          if (sizeIndex < nf.размерыГруппыЧисла.length - 1)
            groupSize = nf.размерыГруппыЧисла[++sizeIndex];
          groupSizesTotal += groupSize;
        }
      }
    }

    ткст ret;
    if (знак)
      ret ~= nf.отрицатЗнак;

    сим* p = цифры.ptr;
    n = 0;
    бул pointWritten = false;
    while (n < format.length) {
      c = format[n++];
      if (extra > 0 && (c == '#' || c == '0' || c == '.')) {
        while (extra > 0) {
          ret ~= (*p != '\0') ? *p++ : '0';

          if (hasGroups && поз > 1 && groupIndex >= 0) {
            if (поз == groupPositions[groupIndex] + 1) {
              ret ~= groupSeparator;
              groupIndex--;
            }
          }
          поз--;
          extra--;
        }
      }

      switch (c) {
        case '#', '0':
          if (extra < 0) {
            extra++;
            c = (поз <= first) ? '0' : сим.init;
          }
          else {
            c = (*p != '\0') ? *p++ : (поз > last) ? '0' : сим.init;
          }

          if (c != сим.init) {
            ret ~= c;

            if (hasGroups && поз > 1 && groupIndex >= 0) {
              if (поз == groupPositions[groupIndex] + 1) {
                ret ~= groupSeparator;
                groupIndex--;
              }
            }
          }
          поз--;
          break;
        case '.':
          if (поз != 0 || pointWritten)
            break;
          if (last < 0 || (pointPos < счёт && *p != '\0')) {
            ret ~= decimalSeparator;
            pointWritten = true;
          }
          break;
        case ',':
          break;
        case '\'', '\"':
          if (n < format.length) n++;
          break;
        case '\\':
          if (n < format.length) ret ~= format[n++];
          break;
        default:
          ret ~= c;
          break;
      }
    }

    return ret;
  }

}

private ткст бдолВТкст(бдол значение, цел цифры) {
  if (цифры < 1)
    цифры = 1;

  сим[100] буфер;
  цел n = 100;
  while (--цифры >= 0 || значение != 0) {
    буфер[--n] = cast(сим)(значение % 10 + '0');
    значение /= 10;
  }

  version(D_Version2) {
    return буфер[n .. $].idup;
  }
  else {
    return буфер[n .. $].dup;
  }
}

private ткст долВТкст(дол значение, цел цифры, ткст отрицатЗнак) {
  if (цифры < 1)
    цифры = 1;

  сим[100] буфер;
  бдол uv = (значение >= 0) ? значение : cast(бдол)-значение;
  цел n = 100;
  while (--цифры >= 0 || uv != 0) {
    буфер[--n] = cast(сим)(uv % 10 + '0');
    uv /= 10;
  }

  if (значение < 0) {
    n -= отрицатЗнак.length;
    буфер[n .. n + отрицатЗнак.length] = отрицатЗнак;
  }

  version(D_Version2) {
    return буфер[n .. $].idup;
  }
  else {
    return буфер[n .. $].dup;
  }
}

private ткст intToHexString(бцел значение, цел цифры, сим format) {
  if (цифры < 1)
    цифры = 1;

  сим[100] буфер;
  цел n = 100;
  while (--цифры >= 0 || значение != 0) {
    бцел v = значение & 0xF;
    буфер[--n] = (v < 10) ? cast(сим)(v + '0') : cast(сим)(v + format - ('X' - 'A' + 10));
    значение >>= 4;
  }

  version(D_Version2) {
    return буфер[n .. $].idup;
  }
  else {
    return буфер[n .. $].dup;
  }
}

private ткст longToHexString(бдол значение, цел цифры, сим format) {
  if (цифры < 1)
    цифры = 1;

  сим[100] буфер;
  цел n = 100;
  while (--цифры >= 0 || значение != 0) {
    бдол v = значение & 0xF;
    буфер[--n] = (v < 10) ? cast(сим)(v + '0') : cast(сим)(v + format - ('X' - 'A' + 10));
    значение >>= 4;
  }

  version(D_Version2) {
    return буфер[n .. $].idup;
  }
  else {
    return буфер[n .. $].dup;
  }
}

private сим разборУказателяФормата(ткст format, out цел length) {
  length = -1;
  сим specifier = 'G';

  if (format != null) {
    цел поз = 0;
    сим c = format[поз];

    if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) {
      specifier = c;

      поз++;
      if (поз == format.length)
        return specifier;
      c = format[поз];

      if (c >= '0' && c <= '9') {
        length = c - '0';

        поз++;
        if (поз == format.length)
          return specifier;
        c = format[поз];

        while (c >= '0' && c <= '9') {
          length = length * 10 + c - '0';

          поз++;
          if (поз == format.length)
            return specifier;
          c = format[поз];
        }
      }
    }
    return сим.init;
  }
  return specifier;
}

/*package*/ ткст фмБцел(бцел значение, ткст format, ИФорматПровайдер провайдер) {
  auto nf = ФорматЧисла.дай(провайдер);

  цел length;
  сим specifier = разборУказателяФормата(format, length);

  switch (specifier) {
    case 'g', 'G':
      if (length > 0)
        break;
      // fall through
    case 'd', 'D':
      return бдолВТкст(cast(бдол)значение, length);
    case 'x', 'X':
      return intToHexString(значение, length, specifier);
    default:
  }

  auto число = Число(cast(дол)значение, 10);
  if (specifier != сим.init)
    return число.вТкст(specifier, length, nf);
  return число.toStringFormat(format, nf);
}

/*package*/ ткст фмЦел(цел значение, ткст format, ИФорматПровайдер провайдер) {
  auto nf = ФорматЧисла.дай(провайдер);

  цел length;
  сим specifier = разборУказателяФормата(format, length);

  switch (specifier) {
    case 'g', 'G':
      if (length > 0)
        break;
      // fall through
    case 'd', 'D':
      return долВТкст(cast(дол)значение, length, nf.отрицатЗнак);
    case 'x', 'X':
      return intToHexString(cast(бцел)значение, length, specifier);
    default:
  }

  auto число = Число(cast(дол)значение, 10);
  if (specifier != сим.init)
    return число.вТкст(specifier, length, nf);
  return число.toStringFormat(format, nf);
}

/*package*/ ткст фмБдол(бдол значение, ткст format, ИФорматПровайдер провайдер) {
  auto nf = ФорматЧисла.дай(провайдер);

  цел length;
  сим specifier = разборУказателяФормата(format, length);

  switch (specifier) {
    case 'g', 'G':
      if (length > 0)
        break;
      // fall through
    case 'd', 'D':
      return бдолВТкст(значение, length);
    case 'x', 'X':
      return longToHexString(значение, length, specifier);
    default:
  }

  auto число = Число(cast(дол)значение, 20);
  if (specifier != сим.init)
    return число.вТкст(specifier, length, nf);
  return число.toStringFormat(format, nf);
}

/*package*/ ткст фмДол(дол значение, ткст format, ИФорматПровайдер провайдер) {
  auto nf = ФорматЧисла.дай(провайдер);

  цел length;
  сим specifier = разборУказателяФормата(format, length);

  switch (specifier) {
    case 'g', 'G':
      if (length > 0)
        break;
      // fall through
    case 'd', 'D':
      return долВТкст(значение, length, nf.отрицатЗнак);
    case 'x', 'X':
      return longToHexString(cast(бдол)значение, length, specifier);
    default:
  }

  auto число = Число(cast(дол)значение, 20);
  if (specifier != сим.init)
    return число.вТкст(specifier, length, nf);
  return число.toStringFormat(format, nf);
}

/*package*/ ткст фмПлав(плав значение, ткст format, ИФорматПровайдер провайдер) {
  auto nf = ФорматЧисла.дай(провайдер);

  цел length;
  сим specifier = разборУказателяФормата(format, length);

  цел точность = 7;

  switch (specifier) {
    case 'g', 'G':
      if (length > 7)
        точность = 9;
    default:
  }

  auto число = Число(cast(дво)значение, точность);
  if (specifier != сим.init)
    return число.вТкст(specifier, length, nf);
  return число.toStringFormat(format, nf);
}

/*package*/ ткст фмДво(дво значение, ткст format, ИФорматПровайдер провайдер) {
  auto nf = ФорматЧисла.дай(провайдер);

  цел length;
  сим specifier = разборУказателяФормата(format, length);

  цел точность = 15;

  switch (specifier) {
    case 'g', 'G':
      if (length > 15)
        точность = 17;
    default:
  }

  auto число = Число(значение, точность);
  if (specifier != сим.init)
    return число.вТкст(specifier, length, nf, true);
  return число.toStringFormat(format, nf);
}

/*package*/ ткст фмДесятичн(Decimal значение, ткст format, ИФорматПровайдер провайдер) {
  auto nf = ФорматЧисла.дай(провайдер);

  цел length;
  сим specifier = разборУказателяФормата(format, length);

  auto число = Число(значение);
  if (specifier != сим.init)
    return число.вТкст(specifier, length, nf, true);
  return число.toStringFormat(format, nf);
}

// Must match ФорматЧисла.decimalPositivePattern
private const ткст positivconstberFormat = "#";
// Must match ФорматЧисла.decimalNegativePattern
private const ткст[] negativconstberFormats = [ "(#)", "-#", "- #", "#-", "# -" ];
// Must match ФорматЧисла.положитОбразецВалюты
private const ткст[] positiveCurrencyFormats = [ "$#", "#$", "$ #", "# $" ];
// Must match ФорматЧисла.отрицатОбразецВалюты
private const ткст[] negativeCurrencyFormats = [ "($#)", "-$#", "$-#", "$#-", "(#$)", "-#$", "#-$", "#$-", "-# $", "-$ #", "# $-", "$ #-", "$ -#", "#- $", "($ #)", "(# $)" ];
// Must match ФорматЧисла.percentPositivePattern
private const ткст[] positivePercentFormats = [ "# %", "#%", "%#", "% #" ];
// Must match ФорматЧисла.percentNegativePattern
private const ткст[] negativePercentFormats = [ "-# %", "-#%", "-%#", "%-#", "%#-", "#-%", "#%-", "-% #", "# %-", "% #-", "% -#", "#- %" ];


private проц фмЧисло(ref Число число, ref ткст dst, цел length, ФорматЧисла nf) {
  ткст format = число.знак ? negativconstberFormats[1] : positivconstberFormat;

  foreach (ch; format) {
    switch (ch) {
      case '#':
        formatFixed(число, dst, length, nf.размерыГруппыЧисла, nf.разделительДесятичнЧисла, nf.разделительГруппыЧисел);
        break;
      case '-':
        dst ~= nf.отрицатЗнак;
        break;
      default:
        dst ~= ch;
        break;
    }
  }
}

private проц фмОбщ(ref Число число, ref ткст dst, цел length, сим format, ФорматЧисла nf) {
  цел поз = число.шкала;

  сим* p = число.цифры.ptr;
  if (поз > 0) {
    while (поз > 0) {
      dst ~= (*p != '\0') ? *p++ : '0';
      поз--;
    }
  }
  else
    dst ~= '0';

  if (*p != '\0' || поз < 0) {
    dst ~= nf.разделительДесятичнЧисла;
    while (поз < 0) {
      dst ~= '0';
      поз++;
    }
    while (*p != '\0') dst ~= *p++;
  }
}

private проц фмВалюта(ref Число число, ref ткст dst, цел length, ФорматЧисла nf) {
  ткст format = число.знак ? negativeCurrencyFormats[nf.отрицатОбразецВалюты] : positiveCurrencyFormats[nf.положитОбразецВалюты];

  foreach (ch; format) {
    switch (ch) {
      case '#':
        formatFixed(число, dst, length, nf.размерыГруппыВалюта, nf.разделительДесятичнВалют, nf.разделительГруппыВалют);
        break;
      case '-':
        dst ~= nf.отрицатЗнак;
        break;
      case '$':
        dst ~= nf.символВалюты;
        break;
      default:
        dst ~= ch;
        break;
    }
  }
}

private проц formatFixed(ref Число число, ref ткст dst, цел length, цел[] groupSizes, ткст decimalSeparator, ткст groupSeparator) {
  цел поз = число.шкала;
  сим* p = число.цифры.ptr;

  if (поз > 0) {
    if (groupSizes.length != 0) {
      // Are there enough цифры to format?
      цел счёт = groupSizes[0];
      цел индекс, размер;

      while (поз > счёт) {
        размер = groupSizes[индекс];
        if (размер == 0)
          break;
        if (индекс < groupSizes.length - 1)
          индекс++;
        счёт += groupSizes[индекс];
      }

      размер = (счёт == 0) ? 0 : groupSizes[0];

      // Insert делитель at positions specified by groupSizes.
      цел end = strlen(p);
      цел start = (поз < end) ? поз : end;
      ткст делитель = groupSeparator.reverse;
      сим[] времн;

      индекс = 0;
      for (цел c, i = поз - 1; i >= 0; i--) {
        времн ~= (i < start) ? число.цифры[i] : '0';
        if (размер > 0) {
          c++;
          if (c == размер && i != 0) {
            времн ~= делитель;
            if (индекс < groupSizes.length - 1)
              размер = groupSizes[++индекс];
            c = 0;
          }
        }
      }

      // Because we built the ткст backwards, реверсни it.
      dst ~= времн.reverse;
      p += start;
    }
    else while (поз > 0) {
      dst ~= (*p != '\0') ? *p++ : '0';
      поз--;
    }
  }
  else
    dst ~= '0'; //  Negative шкала.

  if (length > 0) {
    dst ~= decimalSeparator;
    while (поз < 0 && length > 0) {
      dst ~= '0';
      поз++;
      length--;
    }
    while (length > 0) {
      dst ~= (*p != '\0') ? *p++ : '0';
      length--;
    }
  }
}

/*package*/ бцел parseUInt(ткст s, ПСтилиЧисел style, ФорматЧисла nf) {
  Число n;
  if (!Число.пробуйРазбор(s, style, nf, n))
    throw new ИсклФормата("Input ткст was not valid.");

  дол значение;
  if (!n.вДол(значение) || (значение < бцел.min || значение > бцел.max))
    throw new ИсклПереполнения("Value was either too small or too large for a бцел.");
  return cast(бцел)значение;
}

/*package*/ бул tryParseUInt(ткст s, ПСтилиЧисел style, ФорматЧисла nf, out бцел рез) {
  if (s == null) {
    рез = 0;
    return false;
  }

  Число n;
  if (!Число.пробуйРазбор(s, style, nf, n))
    return false;

  дол значение;
  if (!n.вДол(значение) || (значение < бцел.min || значение > бцел.max))
    return false;
  рез = cast(бцел)значение;
  return true;
}

/*package*/ цел parseInt(ткст s, ПСтилиЧисел style, ФорматЧисла nf) {
  Число n;
  if (!Число.пробуйРазбор(s, style, nf, n))
    throw new ИсклФормата("Input ткст was not valid.");

  дол значение;
  if (!n.вДол(значение) || (значение < цел.min || значение > цел.max))
    throw new ИсклПереполнения("Value was either too small or too large for an цел.");
  return cast(цел)значение;
}

/*package*/ бул tryParseInt(ткст s, ПСтилиЧисел style, ФорматЧисла nf, out цел рез) {
  if (s == null) {
    рез = 0;
    return false;
  }

  Число n;
  if (!Число.пробуйРазбор(s, style, nf, n))
    return false;

  дол значение;
  if (!n.вДол(значение) || (значение < цел.min || значение > цел.max))
    return false;
  рез = cast(цел)значение;
  return true;
}

/*package*/ бдол parseULong(ткст s, ПСтилиЧисел style, ФорматЧисла nf) {
  Число n;
  if (!Число.пробуйРазбор(s, style, nf, n))
    throw new ИсклФормата("Input ткст was not valid.");

  дол значение;
  if (!n.вДол(значение) || (значение < бдол.min || значение > бдол.max))
    throw new ИсклПереполнения("Value was either too small or too large for a бдол.");
  return cast(бдол)значение;
}

/*package*/ бул tryParseULong(ткст s, ПСтилиЧисел style, ФорматЧисла nf, out бдол рез) {
  if (s == null) {
    рез = 0;
    return false;
  }

  Число n;
  if (!Число.пробуйРазбор(s, style, nf, n))
    return false;

  дол значение;
  if (!n.вДол(значение) || (значение < бдол.min || значение > бдол.max))
    return false;
  рез = cast(бдол)значение;
  return true;
}

/*package*/ дол parseLong(ткст s, ПСтилиЧисел style, ФорматЧисла nf) {
  Число n;
  if (!Число.пробуйРазбор(s, style, nf, n))
    throw new ИсклФормата("Input ткст was not valid.");

  дол значение;
  if (!n.вДол(значение) || (значение < дол.min || значение > дол.max))
    throw new ИсклПереполнения("Value was either too small or too large for a дол.");
  return значение;
}

/*package*/ бул tryParseLong(ткст s, ПСтилиЧисел style, ФорматЧисла nf, out дол рез) {
  if (s == null) {
    рез = 0;
    return false;
  }

  Число n;
  if (!Число.пробуйРазбор(s, style, nf, n))
    return false;

  дол значение;
  if (!n.вДол(значение) || (значение < дол.min || значение > дол.max))
    return false;
  рез = значение;
  return true;
}

/*package*/ плав parseFloat(ткст s, ПСтилиЧисел style, ФорматЧисла nf) {
  try {
    Число n;
    if (!Число.пробуйРазбор(s, style, nf, n))
      throw new ИсклФормата("Введён несоответствующий текст.");

    дво значение;
    if (!n.вДво(значение))
      throw new ИсклПереполнения("Значение либо мало, либо слишком большое для плав.");
    плав рез = cast(плав)значение;
    if (беск_ли(рез))
      throw new ИсклПереполнения("Значение либо мало, либо слишком большое для плав.");
    return рез;
  }
  catch (ИсклФормата ex) {
    if (s == nf.символПоложитБеск)
      return плав.infinity;
    else if (s == nf.символОтрицатБеск)
      return -плав.infinity;
    else if (s == nf.символНЧ)
      return плав.nan;
    throw ex;
  }
}

/*package*/ бул tryParseFloat(ткст s, ПСтилиЧисел style, ФорматЧисла nf, out плав рез) {
  if (s == null) {
    рез = 0;
    return false;
  }

  Число n;
  дво значение;
  бул success = Число.пробуйРазбор(s, style, nf, n);
  if (success)
    success = n.вДво(значение);
  if (success) {
    рез = cast(плав)значение;
    if (беск_ли(рез))
      success = false;
  }

  if (!success) {
    if (s == nf.символПоложитБеск)
      рез = плав.infinity;
    else if (s == nf.символОтрицатБеск)
      рез = -плав.infinity;
    else if (s == nf.символНЧ)
      рез = плав.nan;
    else
      return false;
  }
  return true;
}

/*package*/ дво parseDouble(ткст s, ПСтилиЧисел style, ФорматЧисла nf) {
  try {
    Число n;
    if (!Число.пробуйРазбор(s, style, nf, n))
      throw new ИсклФормата("Введён несоответствующий текст.");

    дво значение;
    if (!n.вДво(значение))
      throw new ИсклПереполнения("Значение либо мало, либо огромно для типа плав.");
    return значение;
  }
  catch (ИсклФормата ex) {
    if (s == nf.символПоложитБеск)
      return дво.infinity;
    else if (s == nf.символОтрицатБеск)
      return -дво.infinity;
    else if (s == nf.символНЧ)
      return дво.nan;
    throw ex;
  }
}

/*package*/ бул tryParseDouble(ткст s, ПСтилиЧисел style, ФорматЧисла nf, out дво рез) {
  if (s == null) {
    рез = 0;
    return false;
  }

  Число n;
  бул success = Число.пробуйРазбор(s, style, nf, n);
  if (success)
    success = n.вДво(рез);

  if (!success) {
    if (s == nf.символПоложитБеск)
      рез = дво.infinity;
    else if (s == nf.символОтрицатБеск)
      рез = -дво.infinity;
    else if (s == nf.символНЧ)
      рез = дво.nan;
    else
      return false;
  }
  return true;
}

/*package*/ Decimal parseDecimal(ткст s, ПСтилиЧисел style, ФорматЧисла nf) {
  try {
    Число n;
    if (!Число.пробуйРазбор(s, style, nf, n))
      throw new ИсклФормата("Введён несоответствующий текс.");

    Decimal значение;
    if (!n.toDecimal(значение))
      throw new ИсклПереполнения("Значение либо мало, либо огромно для Decimal.");
    return значение;
  }
  catch (ИсклФормата ex) {
    throw ex;
  }
}

/*package*/ бул tryParseDecimal(ткст s, ПСтилиЧисел style, ФорматЧисла nf, out Decimal рез) {
  if (s == null) {
    рез = Decimal.zero;
    return false;
  }

  Число n;
  бул success = Число.пробуйРазбор(s, style, nf, n);
  if (success)
    success = n.toDecimal(рез);
  return success;
}