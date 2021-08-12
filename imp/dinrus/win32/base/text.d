/**
 * Contains classes representing АСКИ, UTF-7, UTF-8 and UTF-16 character encodings.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.base.text;

import win32.base.core,
  win32.base.string,
  win32.base.native,
  win32.com.core;
import stdrus : сравнлюб;

// MLang
// Doesn't support UTF-32 yet.

enum : бцел {
  MIMECONTF_MAILNEWS = 0x1,
  MIMECONTF_BROWSER = 0x2,
  MIMECONTF_MINIMAL = 0x4,
  MIMECONTF_IMPORT = 0x8,
  MIMECONTF_SAVABLE_MAILNEWS = 0x100,
  MIMECONTF_SAVABLE_BROWSER = 0x200,
  MIMECONTF_EXPORT = 0x400,
  MIMECONTF_PRIVCONVERTER = 0x10000,
  MIMECONTF_VALID = 0x20000,
  MIMECONTF_VALID_NLS = 0x40000,
  MIMECONTF_MIME_IE4 = 0x10000000,
  MIMECONTF_MIME_LATEST = 0x20000000,
  MIMECONTF_MIME_REGISTRY = 0x40000000
}

struct MIMECPINFO {
  бцел dwFlags;
  бцел uiCodePage;
  бцел uiFamilyCodePage;
  шим[64] wszDescription;
  шим[50] wszWebCharset;
  шим[50] wszHeaderCharset;
  шим[50] wszBodyCharset;
  шим[32] wszFixedWidthFont;
  шим[32] wszProportionalFont;
  ббайт bGDICharset;
}

struct MIMECSETINFO {
  бцел uiCodePage;
  бцел uiInternetEncoding;
  шим[50] wszCharset;
}

struct RFC1766INFO {
  бцел лкид;
  шим[6] wszRfc1766;
  шим[32] wszLocaleName;
}

struct SCRIPTINFO {
  ббайт ScriptId;
  бцел uiCodePage;
  шим[64] wszDescription;
  шим[32] wszFixedWidthFont;
  шим[32] wszProportionalFont;
}

struct DetectEncodingInfo {
  бцел nLangID;
  бцел nCodePage;
  цел nDocPercent;
  цел nConfidence;
}

interface IEnumCodePage : IUnknown {
  mixin(ууид("275c23e3-3747-11d0-9fea-00aa003f8646"));

  цел Clone(out IEnumCodePage ppEnum);
  цел Next(бцел celt, MIMECPINFO* rgelt, out бцел pceltFetched);
  цел Reset();
  цел Skip(бцел celt);
}

interface IEnumRfc1766 : IUnknown {
  mixin(ууид("3dc39d1d-c030-11d0-b81b-00c04fc9b31f"));

  цел Clone(out IEnumRfc1766 ppEnum);
  цел Next(бцел celt, RFC1766INFO* rgelt, out бцел pceltFetched);
  цел Reset();
  цел Skip(бцел celt);
}

interface IEnumScript : IUnknown {
  mixin(ууид("AE5F1430-388B-11d2-8380-00C04F8F5DA1"));

  цел Clone(out IEnumScript ppEnum);
  цел Next(бцел celt, SCRIPTINFO* rgelt, out бцел pceltFetched);
  цел Reset();
  цел Skip(бцел celt);
}

interface IMLangConvertCharset : IUnknown {
  mixin(ууид("d66d6f98-cdaa-11d0-b822-00c04fc9b31f"));

  цел Initialize(бцел uiSrcCodePage, бцел uiDstCodePage, бцел dwProperty);
  цел GetSourceCodePage(out бцел puiSrcCodePage);
  цел GetDestinationCodePage(out бцел puiDstCodePage);
  цел GetProperty(out бцел pdwProperty);
  цел DoConversion(ббайт* pSrcStr, ref бцел pcSrcSize, ббайт* pDstStr, ref бцел pcDstSize);
  цел DoConversionToUnicode(ббайт* pSrcStr, ref бцел pcSrcSize, шим* pDstStr, ref бцел pcDstSize);
  цел DoConversionFromUnicode(шим* pSrcStr, ref бцел pcSrcSize, ббайт* pDstStr, ref бцел pcDstSize);
}

interface IMultiLanguage : IUnknown {
  mixin(ууид("275c23e1-3747-11d0-9fea-00aa003f8646"));

  цел GetNumberOfCodePageInfo(out бцел pcCodePage);
  цел GetCodePageInfo(бцел uiCodePage, out MIMECPINFO pCodePageInfo);
  цел GetFamilyCodePage(бцел uiCodePage, out бцел puiFamilyCodePage);
  цел перечислиКодСтры(бцел grfFlags, out IEnumCodePage ppEnumCodePage);
  цел GetCharsetInfo(шим* Charset, out MIMECSETINFO pCharsetInfo);
  цел IsConvertible(бцел dwSrcEncoding, бцел dwDstEncoding);
  цел ConvertString(ref бцел pdwMode, бцел dwSrcEncoding, бцел dwDstEncoding, ббайт* pSrcStr, ref бцел pcSrcSize, ббайт* pDstStr, ref бцел pcDstSize);
  цел ConvertStringToUnicode(ref бцел pdwMode, бцел dwEncoding, ббайт* pSrcStr, ref бцел pcSrcSize, шим* pDstStr, ref бцел pcDstSize);
  цел ConvertStringFromUnicode(ref бцел pdwMode, бцел dwEncoding, шим* pSrcStr, ref бцел pcSrcSize, ббайт* pDstStr, ref бцел pcDstSize);
  цел ConvertStringReset();
  цел GetRfc1766FromLcid(бцел Locale, out шим* pbstrRfc1766);
  цел GetLcidFromRfc1766(out бцел Locale, шим* bstrRfc1766);
  цел EnumRfc1766(out IEnumRfc1766 ppEnumRfc1766);
  цел GetRfc1766Info(бцел Locale, out RFC1766INFO pRfc1766Info);
  цел CreateConvertCharset(бцел uiSrcCodePage, бцел uiDstCodePage, бцел dwProperty, out IMLangConvertCharset ppMLangConvertCharset);
}

interface IMultiLanguage2 : IUnknown {
  mixin(ууид("DCCFC164-2B38-11d2-B7EC-00C04F8F5D9A"));

  цел GetNumberOfCodePageInfo(out бцел pcCodePage);
  цел GetCodePageInfo(бцел uiCodePage, бкрат LangId, out MIMECPINFO pCodePageInfo);
  цел GetFamilyCodePage(бцел uiCodePage, out бцел puiFamilyCodePage);
  цел перечислиКодСтры(бцел grfFlags, бкрат LangId, out IEnumCodePage ppEnumCodePage);
  цел GetCharsetInfo(шим* Charset, out MIMECSETINFO pCharsetInfo);
  цел IsConvertible(бцел dwSrcEncoding, бцел dwDstEncoding);
  цел ConvertString(ref бцел pdwMode, бцел dwSrcEncoding, бцел dwDstEncoding, ббайт* pSrcStr, ref бцел pcSrcSize, ббайт* pDstStr, ref бцел pcDstSize);
  цел ConvertStringToUnicode(ref бцел pdwMode, бцел dwEncoding, ббайт* pSrcStr, ref бцел pcSrcSize, шим* pDstStr, ref бцел pcDstSize);
  цел ConvertStringFromUnicode(ref бцел pdwMode, бцел dwEncoding, шим* pSrcStr, ref бцел pcSrcSize, ббайт* pDstStr, ref бцел pcDstSize);
  цел ConvertStringReset();
  цел GetRfc1766FromLcid(бцел Locale, out шим* pbstrRfc1766);
  цел GetLcidFromRfc1766(out бцел Locale, шим* bstrRfc1766);
  цел EnumRfc1766(out IEnumRfc1766 ppEnumRfc1766);
  цел GetRfc1766Info(бцел Locale, out RFC1766INFO pRfc1766Info);
  цел CreateConvertCharset(бцел uiSrcCodePage, бцел uiDstCodePage, бцел dwProperty, out IMLangConvertCharset ppMLangConvertCharset);
  цел ConvertStringInIStream(ref бцел pdwMode, бцел dwFlag, шим* lpFallBack, бцел dwSrcEncoding, бцел dwDstEncoding, IStream pstmIn, IStream pstmOut);
  цел ConvertStringToUnicodeEx(бцел dwEncoding, ббайт* pSrcStr, ref бцел pcSrcSize, шим* pDstStr, ref бцел pcDstSize, бцел dwFlag, шим* lpFallBack);
  цел ConvertStringFromUnicodeEx(бцел dwEncoding, шим* pSrcStr, ref бцел pcSrcSize, ббайт* pDstStr, ref бцел pcDstSize, бцел dwFlag, шим* lpFallBack);
  цел DetectCodepageInIStream(бцел dwFlag, бцел dwPrefWinCodePage, IStream pstmIn, ref DetectEncodingInfo lpEncoding, ref цел pcScores);
  цел DetectInputCodepage(бцел dwFlag, бцел dwPrefWinCodePage, ббайт* pSrcStr, ref цел pcSrcSize, ref DetectEncodingInfo lpEncoding, ref цел pcScores);
  цел ValidateCodePage(бцел uiCodePage, Укз hwnd);
  цел GetCodePageDescription(бцел uiCodePage, бцел лкид, шим* lpWideCharStr, цел cchWideChar);
  цел IsCodePageInstallable(бцел uiCodePage);
  цел SetMimeDBSource(бцел dwSource);
  цел GetNumberOfScripts(out бцел pnScripts);
  цел EnumScripts(бцел dwFlags, бкрат LangId, out IEnumScript ppEnumScript);
  цел ValidateCodePageEx(бцел uiCodePage, Укз hwnd, бцел dwfIODControl);
}

interface IMultiLanguage3 : IMultiLanguage2 {
  mixin(ууид("4e5868ab-b157-4623-9acc-6a1d9caebe04"));

  цел DetectOutboundCodePage(бцел dwFlags, шим* lpWideCharStr, цел cchWideChar, бцел* puiPreferredCodePages, бцел nPreferredCodePages, бцел* puiDetectedCodePages, ref бцел pnDetectedCodePages, шим* lpSpecialChar);
  цел DetectOutboundCodePageInIStream(бцел dwFlags, IStream pStrIn, бцел* puiPreferredCodePages, бцел nPreferredCodePages, бцел* puiDetectedCodePages, шим* lpSpecialChar);
}

abstract final class CMultiLanguage {
  mixin(ууид("275c23e2-3747-11d0-9fea-00aa003f8646"));

  mixin Интерфейсы!(IMultiLanguage2);
}

extern(Windows)
alias ДллИмпорт!("mlang.dll", "ConvertINetString",
  цел function(бцел* lpdwMode, бцел dwSrcEncoding, бцел dwDstEncoding, in ббайт* lpSrcStr, бцел* lpnSrcSize, ббайт* lpDstStr, бцел* lpnDstSize))
  ConvertINetString;

extern(Windows)
alias ДллИмпорт!("mlang.dll", "IsConvertINetStringAvailable",
  цел function(бцел dwSrcEncoding, бцел dwDstEncoding))
  IsConvertINetStringAvailable;

private struct ИнфОКодСтр {
  бцел кодСтр;
  бцел семействоКодСтр;
  ткст вебИмя;
  ткст имяЗага;
  ткст имяТела;
  ткст описание;
  бцел флаги;
}

private ИнфОКодСтр[] codePageInfoTable;
private ИнфОКодСтр[бцел] codePageInfoByCodePage;
private бцел[ткст] codePageByName;

static ~this() {
  codePageInfoTable = null;
  codePageInfoByCodePage = null;
  codePageByName = null;
}

private проц иницИнфОКодСтр() {
  synchronized {
    if (auto mlang = CMultiLanguage.coCreate!(IMultiLanguage2)) {
      scope(exit) mlang.Release();

      IEnumCodePage cp;
      if (УДАЧНО(mlang.перечислиКодСтры(MIMECONTF_MIME_LATEST, 0, cp))) {
        scope(exit) cp.Release();

        бцел num = 0;
        if (УДАЧНО(mlang.GetNumberOfCodePageInfo(num)) && num > 0) {
          MIMECPINFO* cpInfo = cast(MIMECPINFO*)CoTaskMemAlloc(num * MIMECPINFO.sizeof);

          бцел счёт = 0;
          if (УДАЧНО(cp.Next(num, cpInfo, счёт)) && счёт > 0) {
            codePageInfoTable.length = счёт;

            for (бцел индекс = 0; индекс < счёт; индекс++) {
              with (cpInfo[индекс]) {
                codePageInfoTable[индекс] = ИнфОКодСтр(
                  uiCodePage, 
                  uiFamilyCodePage, 
                  вУтф8(wszWebCharset.ptr), 
                  вУтф8(wszHeaderCharset.ptr), 
                  вУтф8(wszBodyCharset.ptr), 
                  вУтф8(wszDescription.ptr), 
                  dwFlags);
              }
            }
          }

          CoTaskMemFree(cpInfo);
        }
        else assert(false);
      }
    }
    else assert(false);
  }
}

private ИнфОКодСтр* дайИнфОКодСтр(бцел кодСтр) {
  if (codePageInfoTable == null)
    иницИнфОКодСтр();

  if (auto значение = кодСтр in codePageInfoByCodePage)
    return значение;

  бцел cp;
  for (цел i = 0; i < codePageInfoTable.length && (cp = codePageInfoTable[i].кодСтр) != 0; i++) {
    if (cp == кодСтр) {
      codePageInfoByCodePage[кодСтр] = codePageInfoTable[i];
      return &codePageInfoByCodePage[кодСтр];
    }
  }

  return null;
}

private бцел дайИнфОКодСтрПоИмени(ткст имя) {
  if (codePageInfoTable == null)
    иницИнфОКодСтр();

  if (auto значение = имя in codePageByName)
    return *значение;

  for (цел i = 0; i < codePageInfoTable.length; i++) {
    if (сравнлюб(codePageInfoTable[i].вебИмя, имя) == 0
      || (codePageInfoTable[i].кодСтр == 1200 && сравнлюб("utf-16", имя) == 0)) {
        бцел cp = codePageInfoTable[i].кодСтр;
        codePageByName[имя] = cp;
        return cp;
    }
  }

  throw new ИсклАргумента("'" ~ имя ~ "' не является поддерживаемым названием кодировки.", "имя");
}

/**
 * Represents a character кодировка.
 */
abstract class Кодировка {

  private const бцел CP_DEFAULT = 0;
  private const бцел CP_ASCII = 20127;
  private const бцел CP_UTF16 = 1200;
  private const бцел CP_UTF16BE = 1201;
  private const бцел CP_UTF32 = 12000;
  private const бцел CP_UTF32BE = 12001;
  private const бцел CP_WINDOWS_1252 = 1252;
  private const бцел CP_WINDOWS_1251 = 1251;
  private const бцел ISO_8859_1 = 28591;

  private const бцел ISO_SIMPLIFIED_CN = 50227;
  private const бцел GB18030 = 54936;
  private const бцел ISO_8859_8I = 38598;
  private const бцел ISCII_DEVANAGARI = 57002;
  private const бцел ISCII_BENGALI = 57003;
  private const бцел ISCII_TAMIL = 57004;
  private const бцел ISCII_TELUGU = 57005;
  private const бцел ISCII_ASSEMESE = 57006;
  private const бцел ISCII_ORIYA = 57007;
  private const бцел ISCII_KANNADA = 57008;
  private const бцел ISCII_MALAYALAM = 57009;
  private const бцел ISCII_GUJARATHI = 57010;
  private const бцел ISCII_PUNJABI = 507011;

  private static Кодировка[бцел] encodings_;
  private static Кодировка defaultEncoding_;
  private static Кодировка asciiEncoding_;
  private static Кодировка utf7Encoding_;
  private static Кодировка utf8Encoding_;
  private static Кодировка utf16Encoding_;

  protected бцел codePage_;
  private ИнфОКодСтр* cpInfo_;

  static ~this() {
    defaultEncoding_ = null;
    asciiEncoding_ = null;
    utf7Encoding_ = null;
    utf8Encoding_ = null;
    utf16Encoding_ = null;
    encodings_ = null;
  }

  /**
   * Converts a байт array from one кодировка to another.
   * Параметры:
   *   исхКодировка = The кодировка format of байты.
   *   целевКодировка = The цель кодировка format.
   *   байты = The _bytes to _convert.
   * Возвращает: A байт array containing the results of converting байты from srcEncoding to целевКодировка.
   */
  static ббайт[] преобразуй(Кодировка исхКодировка, Кодировка целевКодировка, in ббайт[] байты) {
    return преобразуй(исхКодировка, целевКодировка, байты, 0, байты.length);
  }

  /**
   * Converts a охват of _bytes in a байт array from one кодировка to another.
   * Параметры:
   *   исхКодировка = The кодировка format of байты.
   *   целевКодировка = The цель кодировка format.
   *   байты = The _bytes to _convert.
   *   индекс = The _index of the first element of байты to _convert.
   *   счёт = The число of _bytes to _convert.
   * Возвращает: A байт array containing the results of converting байты from srcEncoding to целевКодировка.
   */
  static ббайт[] преобразуй(Кодировка исхКодировка, Кодировка целевКодировка, in ббайт[] байты, цел индекс, цел счёт) {
    return целевКодировка.кодируй(исхКодировка.раскодируй(байты, индекс, счёт));
  }

  /**
   */
  abstract цел длинаКодировки(in сим[] текст, цел индекс, цел счёт);

  /**
   * ditto
   */
  цел длинаКодировки(in сим[] текст) {
    return длинаКодировки(текст, 0, текст.length);
  }

  /**
   */
  abstract цел длинаРаскодировки(in ббайт[] байты, цел индекс, цел счёт);

  /**
   * ditto
   */
  цел длинаРаскодировки(in ббайт[] байты) {
    return длинаРаскодировки(байты, 0, байты.length);
  }

  abstract цел кодируй(in сим[] текст, цел индексСимв, цел счётСимв, ббайт[] байты, цел индексБайта);

  /**
   * Encodes a уст of characters from the specified character array into a sequence of байты.
   * Параметры: 
   *   текст = The character array containing the уст of characters to _encode.
   *   индекс = The _index of the first character to _encode.
   *   счёт = The число of characters to _encode.
   * Возвращает: A байт array containing the results of кодировка the specified уст of characters.
   */
  ббайт[] кодируй(in сим[] текст, цел индекс, цел счёт) {
    ббайт[] байты = new ббайт[длинаКодировки(текст, индекс, счёт)];
    кодируй(текст, индекс, счёт, байты, 0);
    return байты;
  }

  /**
   * ditto
   */
  ббайт[] кодируй(in сим[] текст) {
    return кодируй(текст, 0, текст.length);
  }

  /**
   */
  abstract цел раскодируй(in ббайт[] байты, цел индексБайта, цел счётБайт, сим[] текст, цел индексСимв);
  
  /**
   * Decodes a sequence of _bytes from the specified байт array into a уст of characters.
   * Параметры:
   *   байты = The байт array containing the sequence of _bytes to _decode.
   *   индекс = The _index of the first байт to _decode.
   *   счёт = The число of _bytes to _decode.
   * Возвращает: A character array containing the results of decoding the specified sequence of _bytes.
   */
  сим[] раскодируй(in ббайт[] байты, цел индекс, цел счёт) {
    сим[] текст = new сим[длинаРаскодировки(байты, индекс, счёт)];
    раскодируй(байты, индекс, счёт, текст, 0);
    return текст;
  }
  
  /**
   * ditto
   */
  сим[] раскодируй(in ббайт[] байты) {
    return раскодируй(байты, 0, байты.length);
  }

  /**
   * Returns an кодировка associated with the specified code page identifier.
   * Параметры: кодСтр = The code page identifier of the кодировка.
   * Возвращает: The кодировка associated with the specified code page.
   */
  static Кодировка дай(бцел кодСтр) {
    if (auto значение = кодСтр in encodings_)
      return *значение;

    synchronized (Кодировка.classinfo) {
      Кодировка enc = null;

      switch (кодСтр) {
        case CP_DEFAULT:
          enc = ДЕФОЛТ;
          break;
        case CP_ASCII:
          enc = Кодировка.АСКИ;
          break;
        case CP_UTF8:
          enc = Кодировка.УТФ8;
          break;
        case CP_UTF7:
          enc = Кодировка.УТФ7;
          break;
        case CP_UTF16:
          enc = Кодировка.УТФ16;
          break;
        case CP_UTF16BE:
          enc = new КодировкаУтф16(true);
          break;
        case CP_WINDOWS_1252, CP_WINDOWS_1251,
          ISO_SIMPLIFIED_CN, GB18030, ISO_8859_8I, ISCII_DEVANAGARI,
          ISCII_BENGALI, ISCII_TAMIL, ISCII_TELUGU, ISCII_ASSEMESE,
          ISCII_ORIYA, ISCII_KANNADA, ISCII_MALAYALAM, ISCII_GUJARATHI,
          ISCII_PUNJABI:
          enc = new КодировкаМЛанг(кодСтр);
          break;
        default:
          CPINFO cpi;
          GetCPInfo(кодСтр, cpi);
          if (cpi.MaxCharSize == 1 || cpi.MaxCharSize == 2) {
            enc = new КодировкаМЛанг(кодСтр);
            break;
          }
          throw new ИсклНеПоддерживается(фм("%s не является поддерживаемой кодовой страницей.", кодСтр));
      }

      return encodings_[кодСтр] = enc;
    }
  }

  /**
   * Returns an кодировка associated with the specified code page имя.
   * Параметры: имя = The code page имя of the кодировка.
   * Возвращает: The кодировка associated with the specified code page.
   */
  static Кодировка дай(ткст имя) {
    return Кодировка.дай(дайИнфОКодСтрПоИмени(имя));
  }

  /**
   * Gets an кодировка for the system's ANSI code page.
   * Возвращает: An кодировка for the system's ANSI code page.
   */
  static Кодировка ДЕФОЛТ() {
    if (defaultEncoding_ is null)
      defaultEncoding_ = Кодировка.дай(GetACP());
    return defaultEncoding_;
  }

  /**
   * Gets an кодировка for the АСКИ character уст.
   * Возвращает: An кодировка for the АСКИ character уст.
   */
  static Кодировка АСКИ() {
    if (asciiEncoding_ is null)
      asciiEncoding_ = new КодировкаАски;
    return asciiEncoding_;
  }

  /**
   * Gets an кодировка for the UTF-7 format.
   * Возвращает: An кодировка for the UTF-7 format.
   */
  static Кодировка УТФ7() {
    if (utf7Encoding_ is null)
      utf7Encoding_ = new КодировкаУтф7;
    return utf7Encoding_;
  }

  /**
   * Gets an кодировка for the UTF-8 format.
   * Возвращает: An кодировка for the UTF-8 format.
   */
  static Кодировка УТФ8() {
    if (utf8Encoding_ is null)
      utf8Encoding_ = new КодировкаУтф8;
    return utf8Encoding_;
  }

  /**
   * Gets an кодировка for the UTF-16 format используя the little endian байт order.
   * Возвращает: An кодировка for the UTF-16 format используя the little endian байт order.
   */
  static Кодировка УТФ16() {
    if (utf16Encoding_ is null)
      utf16Encoding_ = new КодировкаУтф16;
    return utf16Encoding_;
  }

  бцел кодСтр() {
    return codePage_;
  }

  /** 
   * Gets a _description of the кодировка.
   * Возвращает: A _description of the кодировка.
   */
  ткст описание() {
    if (cpInfo_ == null)
      cpInfo_ = дайИнфОКодСтр(codePage_);
    return cpInfo_.описание;
  }

  /**
   * Gets the имя registered with the IANA.
   * Возвращает: The IANA имя.
   */
  ткст вебИмя() {
    if (cpInfo_ == null)
      cpInfo_ = дайИнфОКодСтр(codePage_);
    return cpInfo_.вебИмя;
  }

  /** 
   * Gets a имя that can be used with mail agent header tags.
   * Возвращает: A имя that can be used with mail agent header tags.
   */
  ткст имяЗага() {
    if (cpInfo_ == null)
      cpInfo_ = дайИнфОКодСтр(codePage_);
    return cpInfo_.имяЗага;
  }

  /** 
   * Gets a имя that can be used with mail agent body tags.
   * Возвращает: A имя that can be used with mail agent body tags.
   */
  ткст имяТела() {
    if (cpInfo_ == null)
      cpInfo_ = дайИнфОКодСтр(codePage_);
    return cpInfo_.имяТела;
  }

  бул isBrowserDisplay() {
    if (cpInfo_ == null)
      cpInfo_ = дайИнфОКодСтр(codePage_);
    return (cpInfo_.флаги & MIMECONTF_BROWSER) != 0;
  }

  бул isMailNewsDisplay() {
    if (cpInfo_ == null)
      cpInfo_ = дайИнфОКодСтр(codePage_);
    return (cpInfo_.флаги & MIMECONTF_MAILNEWS) != 0;
  }

  бул isBrowserSave() {
    if (cpInfo_ == null)
      cpInfo_ = дайИнфОКодСтр(codePage_);
    return (cpInfo_.флаги & MIMECONTF_SAVABLE_BROWSER) != 0;
  }

  бул isMailNewsSave() {
    if (cpInfo_ == null)
      cpInfo_ = дайИнфОКодСтр(codePage_);
    return (cpInfo_.флаги & MIMECONTF_SAVABLE_MAILNEWS) != 0;
  }

  /**
   * Initialize a new экземпляр that corresponds to the specified code page.
   * Параметры: кодСтр = The code page identifier of the кодировка.
   */
  protected this(бцел кодСтр) {
    codePage_ = кодСтр;
  }

}

private final class КодировкаМЛанг : Кодировка {

  this(бцел кодСтр) {
    super(кодСтр == 0 ? GetACP() : кодСтр);
  }

  override цел длинаКодировки(in сим[] текст, цел индекс, цел счёт) {
    if (IsConvertINetStringAvailable(CP_UTF8, codePage_) == S_FALSE)
      throw new ИсклАргумента("Неудачное кодирование.");

    бцел dwMode;
    бцел bytesLength;
    бцел charsLength = счёт;
    ConvertINetString(&dwMode, CP_UTF8, codePage_, cast(ббайт*)(текст.ptr + индекс), &charsLength, null, &bytesLength);
    return bytesLength;
  }

  override цел длинаРаскодировки(in ббайт[] байты, цел индекс, цел счёт) {
    if (IsConvertINetStringAvailable(codePage_, CP_UTF8) == S_FALSE)
      throw new ИсклАргумента("Неудачное раскодирование.");

    бцел dwMode;
    бцел charsLength;
    бцел bytesLength = счёт;
    ConvertINetString(&dwMode, codePage_, CP_UTF8, байты.ptr + индекс, &bytesLength, null, &charsLength);
    return charsLength;
  }

  override цел кодируй(in сим[] текст, цел индексСимв, цел счётСимв, ббайт[] байты, цел индексБайта) {
    if (IsConvertINetStringAvailable(CP_UTF8, codePage_) == S_FALSE)
      throw new ИсклАргумента("Неудачное кодирование.");

    бцел dwMode;
    бцел charsLength = счётСимв;
    бцел bytesLength = байты.length - индексБайта;
    ConvertINetString(&dwMode, CP_UTF8, codePage_, cast(ббайт*)(текст.ptr + индексСимв), &charsLength, байты.ptr + индексБайта, &bytesLength);
    return bytesLength;
  }

  override цел раскодируй(in ббайт[] байты, цел индексБайта, цел счётБайт, сим[] текст, цел индексСимв) {
    if (IsConvertINetStringAvailable(codePage_, CP_UTF8) == S_FALSE)
      throw new ИсклАргумента("Неудачное раскодирование.");

    бцел dwMode;
    бцел bytesLength = счётБайт;
    бцел charsLength = текст.length - индексСимв;
    ConvertINetString(&dwMode, codePage_, CP_UTF8, байты.ptr + индексБайта, &bytesLength, cast(ббайт*)текст.ptr + индексСимв, &charsLength);
    return charsLength;
  }

}

/**
 * Represents an АСКИ кодировка of characters.
 */
class КодировкаАски : Кодировка {

  private Кодировка baseEncoding_;

  this() {
    super(CP_ASCII);
    baseEncoding_ = new КодировкаМЛанг(CP_ASCII);
  }

  alias Кодировка.длинаКодировки длинаКодировки;

  override цел длинаКодировки(in сим[] текст, цел индекс, цел счёт) {
    return baseEncoding_.длинаКодировки(текст, индекс, счёт);
  }

  alias Кодировка.длинаРаскодировки длинаРаскодировки;

  override цел длинаРаскодировки(in ббайт[] байты, цел индекс, цел счёт) {
    return baseEncoding_.длинаРаскодировки(байты, индекс, счёт);
  }
  
  alias Кодировка.кодируй кодируй;

  override цел кодируй(in сим[] текст, цел индексСимв, цел счётСимв, ббайт[] байты, цел индексБайта) {
    return baseEncoding_.кодируй(текст, индексСимв, счётСимв, байты, индексБайта);
  }

  alias Кодировка.раскодируй раскодируй;

  override цел раскодируй(in ббайт[] байты, цел индексБайта, цел счётБайт, сим[] текст, цел индексСимв) {
    return baseEncoding_.раскодируй(байты, индексБайта, счётБайт, текст, индексСимв);
  }

}

/**
 * Represents a UTF-7 кодировка of characters.
 */
class КодировкаУтф7 : Кодировка {

  private Кодировка baseEncoding_;

  this() {
    super(CP_UTF7);
    baseEncoding_ = new КодировкаМЛанг(CP_UTF7);
  }

  alias Кодировка.длинаКодировки длинаКодировки;

  override цел длинаКодировки(in сим[] текст, цел индекс, цел счёт) {
    return baseEncoding_.длинаКодировки(текст, индекс, счёт);
  }

  alias Кодировка.длинаРаскодировки длинаРаскодировки;

  override цел длинаРаскодировки(in ббайт[] байты, цел индекс, цел счёт) {
    return baseEncoding_.длинаРаскодировки(байты, индекс, счёт);
  }
  
  alias Кодировка.кодируй кодируй;

  override цел кодируй(in сим[] текст, цел индексСимв, цел счётСимв, ббайт[] байты, цел индексБайта) {
    return baseEncoding_.кодируй(текст, индексСимв, счётСимв, байты, индексБайта);
  }

  alias Кодировка.раскодируй раскодируй;

  override цел раскодируй(in ббайт[] байты, цел индексБайта, цел счётБайт, сим[] текст, цел индексСимв) {
    return baseEncoding_.раскодируй(байты, индексБайта, счётБайт, текст, индексСимв);
  }

}

/**
 * Represents a UTF-8 кодировка of characters.
 */
class КодировкаУтф8 : Кодировка {

  private Кодировка baseEncoding_;

  this() {
    super(CP_UTF8);
    baseEncoding_ = new КодировкаМЛанг(CP_UTF8);
  }

  alias Кодировка.длинаКодировки длинаКодировки;

  override цел длинаКодировки(in сим[] текст, цел индекс, цел счёт) {
    return baseEncoding_.длинаКодировки(текст, индекс, счёт);
  }

  alias Кодировка.длинаРаскодировки длинаРаскодировки;

  override цел длинаРаскодировки(in ббайт[] байты, цел индекс, цел счёт) {
    return baseEncoding_.длинаРаскодировки(байты, индекс, счёт);
  }
  
  alias Кодировка.кодируй кодируй;

  override цел кодируй(in сим[] текст, цел индексСимв, цел счётСимв, ббайт[] байты, цел индексБайта) {
    return baseEncoding_.кодируй(текст, индексСимв, счётСимв, байты, индексБайта);
  }

  alias Кодировка.раскодируй раскодируй;

  override цел раскодируй(in ббайт[] байты, цел индексБайта, цел счётБайт, сим[] текст, цел индексСимв) {
    return baseEncoding_.раскодируй(байты, индексБайта, счётБайт, текст, индексСимв);
  }

}

/**
 * Represents a UTF-16 кодировка of characters.
 */
class КодировкаУтф16 : Кодировка {

  private Кодировка baseEncoding_;

  this(бул bigEndian = false) {
    super(bigEndian ? CP_UTF16BE : CP_UTF16);
    baseEncoding_ = new КодировкаМЛанг(codePage_);
  }

  alias Кодировка.длинаКодировки длинаКодировки;

  override цел длинаКодировки(in сим[] текст, цел индекс, цел счёт) {
    return baseEncoding_.длинаКодировки(текст, индекс, счёт);
  }

  alias Кодировка.длинаРаскодировки длинаРаскодировки;

  override цел длинаРаскодировки(in ббайт[] байты, цел индекс, цел счёт) {
    return baseEncoding_.длинаРаскодировки(байты, индекс, счёт);
  }
  
  alias Кодировка.кодируй кодируй;

  override цел кодируй(in сим[] текст, цел индексСимв, цел счётСимв, ббайт[] байты, цел индексБайта) {
    return baseEncoding_.кодируй(текст, индексСимв, счётСимв, байты, индексБайта);
  }

  alias Кодировка.раскодируй раскодируй;

  override цел раскодируй(in ббайт[] байты, цел индексБайта, цел счётБайт, сим[] текст, цел индексСимв) {
    return baseEncoding_.раскодируй(байты, индексБайта, счётБайт, текст, индексСимв);
  }

}