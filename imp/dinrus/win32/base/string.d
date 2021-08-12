/**
 * Contains methods for working with strings.
 *
 * Methods that perform comparisons are culturally sensitive.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.base.string;

import win32.base.core, 
  win32.loc.consts,
  win32.loc.core,
  win32.loc.time,
  win32.loc.conv;
import stdrus : вЮ8, вЮ16, вЮ16н;
import stringz :  вТкст0;
import cidrus, tpl.args;



//debug import stdrus : пишинс;

version(D_Version2) {
  mixin("alias const(сим)* stringz;");
  mixin("alias const(шим*) wstringz;");
}
else {
  alias сим* stringz;
  alias шим* wstringz;
}

ткст вУтф8(in сим* s, цел индекс = 0, цел счёт = -1) {
  if (s == null)
    return "";
  if (счёт == -1)
    счёт = strlen(s);
  if (счёт == 0)
    return "";
  version(D_Version2) {
    return s[индекс .. счёт].idup;
  }
  else {
    return s[индекс .. счёт].dup;
  }
}

ткст вУтф8(in шим* s, цел индекс = 0, цел счёт = -1) {
  if (s == null)
    return "";
  if (счёт == -1)
    счёт = cidrus.wcslen(s);
  if (счёт == 0)
    return "";
  return s[индекс .. счёт].вЮ8();
}

stringz вУтф8н(in сим[] s, цел индекс = 0, цел счёт = -1) {
  if (s == null)
    return "";
  if (счёт == -1)
    счёт = s.length;
  if (счёт == 0)
    return "";
  return s[индекс .. счёт].вТкст0();
}

version(D_Version2) {
  stringz вУтф8н(ткст s, цел индекс = 0, цел счёт = -1) {
    if (s == null)
      return "";
    if (счёт == -1)
      счёт = s.length;
    if (счёт == 0)
      return "";
    return s[индекс .. счёт].вТкст0();
  }
}

ткст вУтф8(in шим[] s, цел индекс = 0, цел счёт = -1) {
  if (s == null)
    return "";
  if (счёт == -1)
    счёт = s.length;
  if (счёт == 0)
    return "";
  return s[индекс .. счёт].вЮ8();
}

version(D_Version2) {
  ткст вУтф8(ткст s, цел индекс = 0, цел счёт = -1) {
    if (s == null)
      return "";
    if (счёт == -1)
      счёт = s.length;
    if (счёт == 0)
      return "";
    return s[индекс .. счёт].вЮ8();
  }
}

wstring вУтф16(ткст s, цел индекс = 0, цел счёт = -1) {
  if (s == null)
    return "";
  if (счёт == -1)
    счёт = s.length;
  if (счёт == 0)
    return "";
  return s[индекс .. счёт].вЮ16();
}

wstringz вУтф16н(in сим[] s, цел индекс = 0, цел счёт = -1) {
  if (s == null)
    return "";
  if (счёт == -1)
    счёт = s.length;
  if (счёт == 0)
    return "";
  return s[индекс .. счёт].вЮ16н();
}

version(D_Version2) {
  wstringz вУтф16н(ткст s, цел индекс = 0, цел счёт = -1) {
    if (s == null)
      return "";
    if (счёт == -1)
      счёт = s.length;
    if (счёт == 0)
      return "";
    return s[индекс .. счёт].вЮ16н();
  }
}

/**
 * Compares two specified strings, ignoring or honouring their case.
 * Параметры:
 *   stringA = The first ткст.
 *   stringB = The секунда ткст.
 *   игнорРег = A значение indicating a case- sensitive or insensitive comparison.
 * Возвращает: An integer indicating the lexical relationship between the two strings (less than zero if stringA is less then stringB; zero if stringA равен stringB; greater than zero if stringA is greater than stringB).
 */
цел сравни(ткст stringA, ткст stringB, бул игнорРег, Культура культура = null) {
  if (культура is null)
    культура = Культура.текущ;

  if (stringA != stringB) {
    if (stringA == null)
      return -1;
    if (stringB == null)
      return -1;

    return культура.коллятор.сравни(stringA, stringB, игнорРег ? ПОпцииСравнения.ИгнорРег : ПОпцииСравнения.None);
  }
  return 0;
}

/**
 * ditto
 */
цел сравни(ткст stringA, ткст stringB, Культура культура) {
  if (культура is null)
    throw new ИсклНулевогоАргумента("культура");
  return сравни(stringA, stringB, false, культура);
}

/**
 * ditto
 */
цел сравни(ткст stringA, ткст stringB) {
  return сравни(stringA, stringB, false, Культура.текущ);
}

/**
 * Compares two specified strings, ignoring or honouring their case.
 * Параметры:
 *   stringA = The first ткст.
 *   indexA = The позиция of the substring withing stringA.
 *   stringB = The секунда ткст.
 *   indexB = The позиция of the substring withing stringB.
 *   игнорРег = A значение indicating a case- sensitive or insensitive comparison.
 * Возвращает: An integer indicating the lexical relationship between the two strings (less than zero if the substring in stringA is less then the substring in stringB; zero if the substrings are equal; greater than zero if the substring in stringA is greater than the substring in stringB).
 */
цел сравни(ткст stringA, цел indexA, ткст stringB, цел indexB, цел length, бул игнорРег = false, Культура культура = null) {
  if (культура is null)
    культура = Культура.текущ;

  if (length != 0 && (stringA != stringB || indexA != indexB)) {
    цел lengthA = length, lengthB = length;
    if (stringA.length - indexA < lengthA)
      lengthA = stringA.length - indexA;
    if (stringB.length - indexB < lengthB)
      lengthB = stringB.length - indexB;

    return культура.коллятор.сравни(stringA, indexA, lengthA, stringB, indexB, lengthB, игнорРег ? ПОпцииСравнения.ИгнорРег : ПОпцииСравнения.None);
  }
  return 0;
}

/**
 * ditto
 */
цел сравни(ткст stringA, цел indexA, ткст stringB, цел indexB, цел length, Культура культура) {
  if (культура is null)
    throw new ИсклНулевогоАргумента("культура");
  return сравни(stringA, indexA, stringB, indexB, length, false, культура);
}

/**
 * Determines whether two specified strings are the same, ignoring or honouring their case.
 * Параметры:
 *   stringA = The first ткст.
 *   stringB = The секунда ткст.
 *   игнорРег = A значение indicating a case- sensitive or insensitive comparison.
 * Возвращает: true if stringA то же самое, что stringB; otherwise, false.
 */
бул равен(ткст stringA, ткст stringB, бул игнорРег = false) {
  return сравни(stringA, stringB, игнорРег) == 0;
}

/**
 * Determines whether the значение parameter occurs within the s parameter.
 * Параметры:
 *   s = The ткст to search within.
 *   значение = The ткст to найди.
 * Возвращает: true if the значение parameter occurs within the s parameter; otherwise, false.
 */
бул содержит(ткст s, ткст значение) {
  return s.индексУ(значение) >= 0;
}

/**
 * Retrieves the индекс of the first occurrence of the specified character within the specified ткст.
 * Параметры:
 *   s = The ткст to search within.
 *   значение = The character to найди.
 *   индекс = The start позиция of the search.
 *   счёт = The число of characters to examine.
 * Возвращает: The индекс of значение if that character is found, or -1 if it is not.
 */
цел индексУ(ткст s, сим значение, цел индекс = 0, цел счёт = -1) {
  if (счёт == -1)
    счёт = s.length - индекс;

  цел end = индекс + счёт;
  for (цел i = индекс; i < end; i++) {
    if (s[i] == значение)
      return i;
  }

  return -1;
}

/**
 * Получает индекс первого случая указанного значения у заданном тексте ткст s.
 * Параметры:
 *   s = The ткст to search within.
 *   значение = The ткст to найди.
 *   индекс = The start позиция of the search.
 *   счёт = The число of characters to examine.
 *   игнорРег = A значение indicating a case- sensitive or insensitive comparison.
 * Возвращает: The индекс of значение if that ткст is found, or -1 if it is not.
 */
цел индексУ(ткст s, ткст значение, цел индекс, цел счёт, бул игнорРег = false, Культура культура = null) {
  if (культура is null)
    культура = Культура.текущ;
  return культура.коллятор.индексУ(s, значение, индекс, счёт, игнорРег ? ПОпцииСравнения.ИгнорРег : ПОпцииСравнения.None);
}

/**
 * ditto
 */
цел индексУ(ткст s, ткст значение, цел индекс, бул игнорРег = false, Культура культура = null) {
  return индексУ(s, значение, индекс, s.length - индекс, игнорРег, культура);
}

/**
 * ditto
 */
цел индексУ(ткст s, ткст значение, бул игнорРег = false, Культура культура = null) {
  return индексУ(s, значение, 0, s.length, игнорРег, культура);
}

цел индексУЛюб(ткст s, in сим[] anyOf, цел индекс = 0, цел счёт = -1) {
  if (счёт == -1)
    счёт = s.length - индекс;

  цел end = индекс + счёт;
  for (цел i = индекс; i < end; i++) {
    цел k = -1;
    for (цел j = 0; j < anyOf.length; j++) {
      if (s[i] == anyOf[j]) {
        k = j;
        break;
      }
    }
    if (k != -1)
      return i;
  }

  return -1;
}

/**
 * Retrieves the индекс of the last occurrence of the specified character within the specified ткст.
 * Параметры:
 *   s = The ткст to search within.
 *   значение = The character to найди.
 *   индекс = The start позиция of the search.
 *   счёт = The число of characters to examine.
 * Возвращает: The индекс of значение if that character is found, or -1 if it is not.
 */
цел последнИндексУ(ткст s, сим значение, цел индекс = 0, цел счёт = -1) {
  if (s.length == 0)
    return -1;
  if (счёт == -1) {
    индекс = s.length - 1;
    счёт = s.length;
  }

  цел end = индекс - счёт + 1;
  for (цел i = индекс; i >= end; i--) {
    if (s[i] == значение)
      return i;
  }

  return -1;
}

/**
 * Retrieves the индекс of the last occurrence of значение within the specified ткст s.
 * Параметры:
 *   s = The ткст to search within.
 *   значение = The ткст to найди.
 *   индекс = The start позиция of the search.
 *   счёт = The число of characters to examine.
 *   игнорРег = A значение indicating a case- sensitive or insensitive comparison.
 * Возвращает: The индекс of значение if that character is found, or -1 if it is not.
 */
цел последнИндексУ(ткст s, ткст значение, цел индекс, цел счёт, бул игнорРег = false, Культура культура = null) {
  if (s.length == 0 && (индекс == -1 || индекс == 0)) {
    if (значение.length != 0)
      return -1;
    return 0;
  }

  if (индекс == s.length) {
    индекс--;
    if (счёт > 0)
      счёт--;
    if (значение.length == 0 && счёт >= 0 && (индекс - счёт) + 1 >= 0)
      return индекс;
  }

  if (культура is null)
    культура = Культура.текущ;
  return культура.коллятор.последнИндексУ(s, значение, индекс, счёт, игнорРег ? ПОпцииСравнения.ИгнорРег : ПОпцииСравнения.None);
}

/**
 * ditto
 */
цел последнИндексУ(ткст s, ткст значение, цел индекс, бул игнорРег = false, Культура культура = null) {
  return последнИндексУ(s, значение, индекс, индекс + 1, игнорРег, культура);
}

/**
 * ditto
 */
цел последнИндексУ(ткст s, ткст значение, бул игнорРег = false, Культура культура = null) {
  return последнИндексУ(s, значение, s.length - 1, s.length, игнорРег, культура);
}

цел последнИндексУЛюб(ткст s, in сим[] anyOf, цел индекс = -1, цел счёт = -1) {
  if (s.length == 0)
    return -1;
  if (счёт == -1) {
    индекс = s.length - 1;
    счёт = s.length;
  }

  цел end = индекс - счёт + 1;
  for (цел i = индекс; i >= end; i--) {
    цел k = -1;
    for (цел j = 0; j < anyOf.length; j++) {
      if (s[i] == anyOf[j]) {
        k = j;
        break;
      }
    }
    if (k != -1)
      return i;
  }
  return -1;
}

/**
 * Determines whether the beginning of s matches значение.
 * Параметры:
 *   s = The ткст to search.
 *   значение = The ткст to сравни.
 *   игнорРег = A значение indicating a case- sensitive or insensitive comparison.
 * Возвращает: true if значение matches the beginning of s; otherwise, false.
 */
бул начинаетсяС(ткст s, ткст значение, бул игнорРег = false, Культура культура = null) {
  if (s == значение)
    return true;

  if (культура is null)
    культура = Культура.текущ;
  return культура.коллятор.префикс_ли(s, значение, игнорРег ? ПОпцииСравнения.ИгнорРег : ПОпцииСравнения.None);
}

/**
 * Determines whether the end of s matches значение.
 * Параметры:
 *   s = The ткст to search.
 *   значение = The ткст to сравни.
 *   игнорРег = A значение indicating a case- sensitive or insensitive comparison.
 * Возвращает: true if значение matches the end of s; otherwise, false.
 */
бул заканчинаетсяНа(ткст s, ткст значение, бул игнорРег = false, Культура культура = null) {
  if (s == значение)
    return true;

  if (культура is null)
    культура = Культура.текущ;
  return культура.коллятор.суффикс_ли(s, значение, игнорРег ? ПОпцииСравнения.ИгнорРег : ПОпцииСравнения.None);
}

/**
 * Inserts значение at the specified индекс in s.
 * Параметры:
 *   s = The ткст in which to _insert значение.
 *   индекс = The позиция of the insertion.
 *   значение = The ткст to _insert.
 * Возвращает: A new ткст with значение inserted at индекс.
 */
ткст вставь(ткст s, цел индекс, ткст значение) {
  if (значение.length == 0 || s.length == 0) {
    version(D_Version2) {
      return s.idup;
    }
    else {
      return s.dup;
    }
  }

  цел newLength = s.length + значение.length;
  сим[] newString = new сим[newLength];

  newString[0 .. индекс] = s[0 .. индекс];
  newString[индекс .. индекс + значение.length] = значение;
  newString[индекс + значение.length .. $] = s[индекс .. $];
  return cast(ткст)newString;
}

/**
 * Deletes characters from s beginning at the specified позиция.
 * Параметры:
 *   s = The ткст from which to delete characters.
 *   индекс = The позиция to begin deleting characters.
 *   счёт = The число of characters to delete.
 * Возвращает: A new ткст equivalent to s less счёт число of characters.
 */
ткст удали(ткст s, цел индекс, цел счёт) {
  сим[] ret = new сим[s.length - счёт];
  memcpy(ret.ptr, s.ptr, индекс);
  memcpy(ret.ptr + индекс, s.ptr + (индекс + счёт), s.length - (индекс + счёт));
  return cast(ткст)ret;
}

/**
 * ditto
 */
ткст удали(ткст s, цел индекс) {
  return s[0 .. индекс];
}

private сим[] WhitespaceChars = [ '\t', '\n', '\v', '\f', '\r', ' ' ];

/**
 * Indicates whether the specified character is white space.
 * Параметры: c = A character.
 * Возвращает: true if c is white space; otherwise, false.
 */
бул пробел_ли(сим c) {
  foreach (ch; WhitespaceChars) {
    if (ch == c)
      return true;
  }
  return false;
}

/**
 * Returns a ткст array containing the substrings in s that are delimited by elements of the specified сим array.
 * Параметры:
 *   s = The ткст to _split.
 *   делитель = An array of characters that delimit the substrings in s.
 *   счёт = The maximum число of substrings to return.
 *   удалитьПустыеЭлты = true to omit пустой array elements from the array returned, or false to include пустой array elements in the array returned.
 * Возвращает: An array whose elements contain the substrings in s that are delimited by one or more characters in делитель.
 */
ткст[] разбей(ткст s, сим[] делитель, цел счёт, бул удалитьПустыеЭлты = false) {

  цел createSeparatorList(ref цел[] sepList) {
    цел foundCount;

    if (делитель.length == 0) {
      for (цел i = 0; i < s.length && foundCount < sepList.length; i++) {
        if (пробел_ли(s[i]))
          sepList[foundCount++] = i;
      }
    }
    else {
      for (цел i = 0; i < s.length && foundCount < sepList.length; i++) {
        for (цел j = 0; j < делитель.length; j++) {
          if (s[i] == делитель[j]) {
            sepList[foundCount++] = i;
            break;
          }
        }
      }
    }

    return foundCount;
  }

  if (счёт == 0 || (удалитьПустыеЭлты && s.length == 0))
    return new ткст[0];

  цел[] sepList = new цел[s.length];
  цел replaceCount = createSeparatorList(sepList);

  if (replaceCount == 0 || счёт == 1)
    return [ s ];

  return splitImpl(s, sepList, null, replaceCount, счёт, удалитьПустыеЭлты);
}

/// ditto
ткст[] разбей(ткст s, сим[] делитель, бул удалитьПустыеЭлты) {
  return разбей(s, делитель, цел.max, удалитьПустыеЭлты);
}

/// ditto
ткст[] разбей(ткст s, сим[] делитель...) {
  return разбей(s, делитель, цел.max, false);
}

/**
 * Returns a ткст array containing the substrings in s that are delimited by elements of the specified ткст array.
 * Параметры:
 *   s = The ткст to _split.
 *   делитель = An array of strings that delimit the substrings in s.
 *   счёт = The maximum число of substrings to return.
 *   удалитьПустыеЭлты = true to omit пустой array elements from the array returned, or false to include пустой array elements in the array returned.
 * Возвращает: An array whose elements contain the substrings in s that are delimited by one or more strings in делитель.
 */
ткст[] разбей(ткст s, ткст[] делитель, цел счёт = цел.max, бул удалитьПустыеЭлты = false) {

  цел createSeparatorList(ref цел[] sepList, ref цел[] lengthList) {
    цел foundCount;

    for (цел i = 0; i < s.length && foundCount < sepList.length; i++) {
      for (цел j = 0; j < делитель.length; j++) {
        ткст сеп = делитель[j];
        if (сеп.length != 0) {
          if (s[i] == сеп[0] && сеп.length <= s.length - i) {
            if (сеп.length == 1 || memcmp(s.ptr + i, сеп.ptr, сеп.length) == 0) {
              sepList[foundCount] = i;
              lengthList[foundCount] = сеп.length;
              foundCount++;
              i += сеп.length - 1;
            }
          }
        }
      }
    }

    return foundCount;
  }

  if (счёт == 0 || (удалитьПустыеЭлты && s.length == 0))
    return new ткст[0];

  цел[] sepList = new цел[s.length];
  цел[] lengthList = new цел[s.length];
  цел replaceCount = createSeparatorList(sepList, lengthList);

  if (replaceCount == 0 || счёт == 1)
    return [ s ];

  return splitImpl(s, sepList, lengthList, replaceCount, счёт, удалитьПустыеЭлты);
}

/**
 * ditto
 */
ткст[] разбей(ткст s, ткст[] делитель, бул удалитьПустыеЭлты) {
  return разбей(s, делитель, цел.max, удалитьПустыеЭлты);
}

private ткст[] splitImpl(ткст s, цел[] sepList, цел[] lengthList, цел replaceCount, цел счёт, бул удалитьПустыеЭлты) {
  ткст[] splitStrings;
  цел arrayIndex, currentIndex;

  if (удалитьПустыеЭлты) {
    цел max = (replaceCount < счёт) ? replaceCount + 1 : счёт;
    splitStrings.length = max;
    for (цел i = 0; i < replaceCount && currentIndex < s.length; i++) {
      if (sepList[i] - currentIndex > 0)
        splitStrings[arrayIndex++] = s[currentIndex .. sepList[i]];
      currentIndex = sepList[i] + ((lengthList == null) ? 1 : lengthList[i]);
      if (arrayIndex == счёт - 1) {
        while (i < replaceCount - 1 && currentIndex == sepList[++i]) {
          currentIndex += ((lengthList == null) ? 1 : lengthList[i]);
        }
        break;
      }
    }

    if (currentIndex < s.length)
      splitStrings[arrayIndex++] = s[currentIndex .. $];

    ткст[] strings = splitStrings;
    if (arrayIndex != max) {
      strings.length = arrayIndex;
      for (цел j = 0; j < arrayIndex; j++)
        strings[j] = splitStrings[j];
    }
    splitStrings = strings;
  }
  else {
    счёт--;
    цел max = (replaceCount < счёт) ? replaceCount : счёт;
    splitStrings.length = max + 1;
    for (цел i = 0; i < max && currentIndex < s.length; i++) {
      splitStrings[arrayIndex++] = s[currentIndex .. sepList[i]];
      currentIndex = sepList[i] + ((lengthList == null) ? 1 : lengthList[i]);
    }

    if (currentIndex < s.length && max >= 0)
      splitStrings[arrayIndex] = s[currentIndex .. $];
    else if (arrayIndex == max)
      splitStrings[arrayIndex] = null;
  }

  return splitStrings;
}

/**
 * Concatenates делитель between each element of значение, returning a single concatenated ткст.
 * Параметры:
 *   делитель = A ткст.
 *   значение = An array of strings.
 *   индекс = The first element in значение to use.
 *   счёт = The число of elements of значение to use.
 * Возвращает: A ткст containing the strings in значение joined by делитель.
 */
ткст соедини(ткст делитель, ткст[] значение, цел индекс = 0, цел счёт = -1) {
  if (счёт == -1)
    счёт = значение.length;
  if (счёт == 0)
    return "";

  цел end = индекс + счёт - 1;
  ткст ret = значение[индекс];
  for (цел i = индекс + 1; i <= end; i++) {
    ret ~= делитель;
    ret ~= значение[i];
  }
  return ret;
}

/**
 * Replaces all instances of oldChar with newChar in s.
 * Параметры:
 *   s = A ткст containing oldChar.
 *   oldChar = The character to be replaced.
 *   newChar = The character to замени all instances of oldChar.
 * Возвращает: A ткст equivalent to s but with all instances of oldChar replaced with newChar.
 */
ткст замени(ткст s, сим oldChar, сим newChar) {
  цел len = s.length;
  цел firstFound = -1;
  for (цел i = 0; i < len; i++) {
    if (oldChar == s[i]) {
      firstFound = i;
      break;
    }
  }

  if (firstFound == -1)
    return s;

  сим[] ret = s[0 .. firstFound].dup;
  ret.length = len;
  for (цел i = firstFound; i < len; i++)
    ret[i] = (s[i] == oldChar) ? newChar : s[i];
  return cast(ткст)ret;
}

/**
 * Replaces all instances of oldValue with newValue in s.
 * Параметры:
 *   s = A ткст containing oldValue.
 *   oldValue = The ткст to be replaced.
 *   newValue = The ткст to замени all instances of oldValue.
 * Возвращает: A ткст equivalent to s but with all instances of oldValue replaced with newValue.
 */
ткст замени(ткст s, ткст oldValue, ткст newValue) {
  цел[] indices = new цел[s.length + oldValue.length];

  цел индекс, счёт;
  while (((индекс = индексУ(s, oldValue, индекс, s.length)) > -1) &&
    (индекс <= s.length - oldValue.length)) {
    indices[счёт++] = индекс;
    индекс += oldValue.length;
  }

  сим[] ret;
  if (счёт != 0) {
    ret.length = s.length - ((oldValue.length - newValue.length) * счёт);
    цел limit = счёт;
    счёт = 0;
    цел i, j;
    while (i < s.length) {
      if (счёт < limit && i == indices[счёт]) {
        счёт++;
        i += oldValue.length;
        ret[j .. j + newValue.length] = newValue;
        j += newValue.length;
      }
      else
        ret[j++] = s[i++];
    }
  }
  else
    return s;
  return cast(ткст)ret;
}

/**
 * Right-aligns the characters in s, padding on the лево with paddingChar for a specified total length.
 * Параметры:
 *   s = The ткст to pad.
 *   totalWidth = The число of characters in the resulting ткст.
 *   paddingChar = A padding character.
 * Возвращает: A ткст equivalent to s but право-aligned and padded on the лево with paddingChar.
 */
ткст padLeft(ткст s, цел totalWidth, сим paddingChar = ' ') {
  if (totalWidth < s.length)
    return s;
  сим[] ret = new сим[totalWidth];
  ret[totalWidth - s.length .. $] = s;
  ret[0 .. totalWidth - s.length] = paddingChar;
  return cast(ткст)ret;
}

/**
 * Left-aligns the characters in s, padding on the право with paddingChar for a specified total length.
 * Параметры:
 *   s = The ткст to pad.
 *   totalWidth = The число of characters in the resulting ткст.
 *   paddingChar = A padding character.
 * Возвращает: A ткст equivalent to s but лево-aligned and padded on the право with paddingChar.
 */
ткст padRight(ткст s, цел totalWidth, сим paddingChar = ' ') {
  if (totalWidth < s.length)
    return s;
  сим[] ret = s.dup;
  ret.length = totalWidth;
  ret[s.length .. $] = paddingChar;
  return cast(ткст)ret;
}

private enum Trim {
  Head,
  Tail,
  Both
}

/**
 * Removes all leading and trailing occurrences of a уст of characters specified in trimChars from s.
 * Возвращает: The ткст that remains after all occurrences of the characters in trimChars are removed from the start and end of s.
 */
ткст trim(ткст s, сим[] trimChars ...) {
  if (trimChars.length == 0)
    trimChars = WhitespaceChars;
  return trimHelper(s, trimChars, Trim.Both);
}

/**
 * Removes all leading occurrences of a уст of characters specified in trimChars from s.
 * Возвращает: The ткст that remains after all occurrences of the characters in trimChars are removed from the start of s.
 */
ткст trimStart(ткст s, сим[] trimChars ...) {
  if (trimChars.length == 0)
    trimChars = WhitespaceChars;
  return trimHelper(s, trimChars, Trim.Head);
}

/**
 * Removes all trailing occurrences of a уст of characters specified in trimChars from s.
 * Возвращает: The ткст that remains after all occurrences of the characters in trimChars are removed from the end of s.
 */
ткст поправьКон(ткст s, сим[] trimChars ...) {
  if (trimChars.length == 0)
    trimChars = WhitespaceChars;
  return trimHelper(s, trimChars, Trim.Tail);
}

private ткст trimHelper(ткст s, сим[] trimChars, Trim trimType) {
  цел право = s.length - 1;
  цел лево;

  if (trimType != Trim.Tail) {
    for (лево = 0; лево < s.length; лево++) {
      сим ch = s[лево];
      цел i;
      while (i < trimChars.length) {
        if (trimChars[i] == ch)
          break;
        i++;
      }
      if (i == trimChars.length)
        break;
    }
  }
  if (trimType != Trim.Head) {
    for (право = s.length - 1; право >= лево; право--) {
      сим ch = s[право];
      цел i;
      while (i < trimChars.length) {
        if (trimChars[i] == ch)
          break;
        i++;
      }
      if (i == trimChars.length)
        break;
    }
  }

  цел len = право - лево + 1;
  if (len == s.length)
    return s;
  if (len == 0)
    return null;
  version(D_Version2) {
    return s[лево .. право + 1].idup;
  }
  else {
    return s[лево .. право + 1].dup;
  }
}

/**
 * Retrieves a _substring from s starting at the specified character позиция and has a specified length.
 * Параметры:
 *   s = A ткст.
 *   индекс = The starting character позиция of a _substring in s.
 *   length = The число of characters in the _substring.
 * Возвращает: The _substring of length that begins at индекс in s.
 */
ткст substring(ткст s, цел индекс, цел length) {
  if (length == 0)
    return null;

  if (индекс == 0 && length == s.length)
    return s;

  сим[] ret = new сим[length];
  memcpy(ret.ptr, s.ptr + индекс, length * сим.sizeof);
  return cast(ткст)ret;
}

/**
 * ditto
 */
ткст substring(ткст s, цел индекс) {
  return substring(s, индекс, s.length - индекс);
}

/**
 * Returns a копируй of s converted to lowercase.
 * Параметры: s = The ткст to преобразуй.
 * Возвращает: a ткст in lowercase.
 */
public ткст вПроп(ткст s, Культура культура = null) {
  if (культура is null)
    культура = Культура.текущ;
  return культура.коллятор.вПроп(s);
}

/**
 * Returns a копируй of s converted to uppercase.
 * Параметры: s = The ткст to преобразуй.
 * Возвращает: a ткст in uppercase.
 */
public ткст вЗаг(ткст s, Культура культура = null) {
  if (культура is null)
    культура = Культура.текущ;
  return культура.коллятор.вЗаг(s);
}

private enum TypeCode {
  Empty,
  Void = 'v',
  Bool = 'b',
  UByte = 'h',
  Byte = 'g',
  UShort = 't',
  Short = 's',
  UInt = 'k',
  Int = 'i',
  ULong = 'm',
  Long = 'l',
  Float = 'f',
  Double = 'd',
  Real = 'e',
  Char = 'a',
  WChar = 'u',
  DChar = 'w',
  Array = 'A',
  Class = 'C',
  Структура = 'S',
  Enum = 'E',
  Pointer = 'P',
  Функция = 'F',
  Делегат = 'D',
  Typedef = 'T',
  Const = 'x',
  Invariant = 'y'
}

private TypeInfo skipConstOrInvariant(TypeInfo t) {
  while (true) {
    if (t.classinfo.имя.length == 18 && t.classinfo.имя[9 .. 18] == "Invariant")
      t = (cast(TypeInfo_Invariant)t).следщ;
    else if (t.classinfo.имя.length == 14 && t.classinfo.имя[9 .. 14] == "Const")
      t = (cast(TypeInfo_Const)t).следщ;
    else
      break;
  }
  return t;
}

private struct Argument {

  TypeInfo тип;
  TypeCode typeCode;
  ук значение;

  static Argument opCall(TypeInfo тип, ук значение) {
    Argument сам;

    сам.тип = тип;
    сам.значение = значение;
    сам.typeCode = cast(TypeCode)тип.classinfo.имя[9];

    if (сам.typeCode == TypeCode.Enum) {
      сам.тип = (cast(ТипКонстанта)тип).base;
      сам.typeCode = cast(TypeCode)сам.тип.classinfo.имя[9];
    }

    if (сам.typeCode == TypeCode.Typedef) {
      сам.тип = (cast(TypeInfo_Typedef)тип).base;
      сам.typeCode = cast(TypeCode)сам.тип.classinfo.имя[9];
    }

    return сам;
  }

  ткст вТкст(ткст format, ИФорматПровайдер провайдер) {
    switch (typeCode) {
      case TypeCode.Array:
        TypeInfo ti = тип;
        TypeCode tc = typeCode;

        if (ti.classinfo.имя.length == 14 && ti.classinfo.имя[9 .. 14] == "Array") {
          ti = skipConstOrInvariant((cast(TypeInfo_Array)ti).следщ);
          tc = cast(TypeCode)ti.classinfo.имя[9];

          if (tc == TypeCode.Char)
            return *cast(ткст*)значение;
        }

        цел i = 10;
        while (true) {
          tc = cast(TypeCode)ti.classinfo.имя[i];
          switch (tc) {
            case TypeCode.Char:
              return *cast(ткст*)значение;
            case TypeCode.Const, TypeCode.Invariant:
              i++;
              continue;
            default:
          }
          break;
        }

        return тип.вТкст();

      case TypeCode.Bool:
        return *cast(бул*)значение ? "True" : "False";

      case TypeCode.UByte:
        return .вТкст(*cast(ббайт*)значение, format, провайдер);

      case TypeCode.Byte:
        return .вТкст(*cast(байт*)значение, format, провайдер);

      case TypeCode.UShort:
        return .вТкст(*cast(бкрат*)значение, format, провайдер);

      case TypeCode.Short:
        return .вТкст(*cast(крат*)значение, format, провайдер);

      case TypeCode.UInt:
        return .вТкст(*cast(бцел*)значение, format, провайдер);

      case TypeCode.Int:
        return .вТкст(*cast(цел*)значение, format, провайдер);

      case TypeCode.ULong:
        return .вТкст(*cast(бдол*)значение, format, провайдер);

      case TypeCode.Long:
        return .вТкст(*cast(дол*)значение, format, провайдер);

      case TypeCode.Float:
        return .вТкст(*cast(плав*)значение, format, провайдер);

      case TypeCode.Double:
        return .вТкст(*cast(дво*)значение, format, провайдер);

      case TypeCode.Class:
        if (auto объ = *cast(Объект*)значение)
          return объ.вТкст();
        break;

      case TypeCode.Структура:
        static if (is(ДатаВрем)) {
          if (тип == typeid(ДатаВрем))
            return (*cast(ДатаВрем*)значение).вТкст(format, провайдер);
        }
        if (auto ti = cast(TypeInfo_Struct)тип) {
          if (ti.xtoString != null)
            return ti.xtoString(значение);
        }
        // Fall through

      case TypeCode.Функция, TypeCode.Делегат, TypeCode.Typedef:
        return тип.вТкст();

      default:
        break;
    }
    return null;
  }

}

private struct ArgumentList {

  Argument[] арги;
  цел размер;

  static ArgumentList opCall(TypeInfo[] типы, va_list argptr) {
    ArgumentList сам;

    foreach (тип; типы) {
      тип = skipConstOrInvariant(тип);
      auto arg = Argument(тип, argptr);
      сам.арги ~= arg;
      if (arg.typeCode == TypeCode.Структура)
        argptr += (тип.tsize() + 3) & ~3;
      else
        argptr += (тип.tsize() + цел.sizeof - 1) & ~(цел.sizeof - 1);
      сам.размер++;
    }

    return сам;
  }

  Argument opIndex(цел индекс) {
    return арги[индекс];
  }

}

/**
 * Replaces the _format items in the specified ткст with ткст representations of the corresponding items in the specified argument список.
 * Параметры:
 *   провайдер = An object supplying культура-specific formatting information.
 *   format = A _format ткст.
 *   _argptr = An argument список containing zero or more items to _format.
 * Возвращает: A копируй of format in which the _format items have been replaced by ткст representations of the corresponding items in the argument список.
 */
ткст format(ИФорматПровайдер провайдер, ткст format, ...) {

  проц formatError() {
    throw new ИсклФормата("Введённый текст был в неправильном формате.");
  }

  проц append(ref ткст s, сим значение, цел счёт) {
    сим[] d = s.dup;
    цел n = d.length;
    d.length = d.length + счёт;
    for (auto i = 0; i < счёт; i++)
      d[n + i] = значение;
    version(D_Version2) {
      s = d.idup;
    }
    else {
      s = d.dup;
    }
  }

  auto типы = _arguments;
  auto argptr = _argptr;

  проц resolveArgs() {
    if (типы.length == 2 && типы[0] == typeid(TypeInfo[]) && типы[1] == typeid(va_list)) {
      типы = va_arg!(TypeInfo[])(argptr);
      argptr = *cast(va_list*)argptr;

      if (типы.length == 2 && типы[0] == typeid(TypeInfo[]) && типы[1] == typeid(va_list)) {
        resolveArgs();
      }
    }
  }
  resolveArgs();

  auto арги = ArgumentList(типы, argptr);

  ткст рез;
  сим[] текст = format.dup;
  цел поз, len = format.length;
  сим c;

  while (true) {
    цел p = поз, i = поз;
    while (поз < len) {
      c = текст[поз];
      поз++;
      if (c == '}') {
        if (поз < len && текст[поз] == '}')
          поз++;
        else
          formatError();
      }
      if (c == '{') {
        if (поз < len && текст[поз] == '{')
          поз++;
        else {
          поз--;
          break;
        }
      }
      текст[i++] = c;
    }

    if (i > p) рез ~= текст[p .. i];
    if (поз == len) break;
    поз++;

    if (поз == len || (c = текст[поз]) < '0' || c > '9')
      formatError();

    цел индекс = 0;

    do {
      индекс = индекс * 10 + c - '0';
      поз++;
      if (поз == len)
        formatError();
      c = текст[поз];
    } while (c >= '0' && c <= '9');

    if (индекс >= арги.размер)
      throw new ИсклФормата("Index must be less than the размер of the argument список.");

    while (поз < len && (c = текст[поз]) == ' ') поз++;

    цел ширина = 0;
    бул leftAlign = false;
    if (c == ',') {
      поз++;
      while (поз < len && (c = текст[поз]) == ' ') поз++;
      if (поз == len)
        formatError();
      c = текст[поз];
      if (c == '-') {
        leftAlign = true;
        поз++;
        if (поз == len)
          formatError();
        c = текст[поз];
      }
      if (c < '0' || c > '9')
        formatError();

      do {
        ширина = ширина * 10 + c - '0';
        поз++;
        if (поз == len)
          formatError();
        c = текст[поз];
      } while (c >= '0' && c <= '9');
    }

    while (поз < len && (c = текст[поз]) == ' ') поз++;

    auto arg = арги[индекс];
    ткст fmt = null;

    if (c == ':') {
      поз++;
      p = поз, i = поз;
      while (true) {
        c = текст[поз];
        поз++;
        if (c == '{') {
          if (поз < len && текст[поз] == '{')
            поз++;
          else formatError();
        }
        if (c == '}') {
          if (поз < len && текст[поз] == '}')
            поз++;
          else {
            поз--;
            break;
          }
        }
        текст[i++] = c;
      }
      if (i > p) {
        version(D_Version2) {
          fmt = текст[p .. i].idup;
        }
        else {
          fmt = текст[p .. i].dup;
        }
      }
    }

    if (c != '}')
      formatError();
    поз++;

    ткст s = arg.вТкст(fmt, провайдер);

    цел padding = ширина - s.length;
    if (!leftAlign && padding > 0)
      append(рез, ' ', padding);

    рез ~= s;

    if (leftAlign && padding > 0)
      append(рез, ' ', padding);
  }

  return рез;
}

/**
 * ditto
 */
ткст format(ткст format, ...) {
  return .format(cast(ИФорматПровайдер)null, format, _arguments, _argptr);
}