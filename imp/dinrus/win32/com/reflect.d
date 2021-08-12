/**
 * Contains типы that retrieve information about тип libraries.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.com.reflect;

import //win32.base.core,
  win32.base.environment,
  win32.base.string,
  win32.com.core,
  win32.utils.registry;

debug import stdrus : скажифнс;

// Check if the имя if reserved word such as a keyword or другой global symbol.
бул резервнСлово_ли(ткст имя) {

  const ткст[] RESERVEDWORDS = [
    "abstract", "alias", "align", "asm", "assert", "auto",
    "body", "бул", "break", "байт",
    "case", "cast", "catch", "cdouble", "cent", "cfloat", "сим", "class", "const", "continue", "creal",
    "dchar", "debug", "default", "delegate", "delete", "deprecated", "do", "дво",
    "else", "const", "export", "extern",
    "false", "final", "finally", "плав", "for", "foreach", "foreach_reverse", "function",
    "goto",
    "idouble", "if", "ifloat", "import", "in", "inout", "цел", "interface", "invariant", "ireal", "is",
    "lazy", "дол",
    "macro", "mixin", "module",
    "new", "nothrow", "null",
    "out", "override", "Объект",
    "/*package*/", "pragma", "private", "protected", "public", "pure",
    "real", "ref", "return",
    "scope", "shared", "крат", "static", "struct", "super", "switch", "synchronized",
    "template", "this", "throw", "true", "try", "typedef", "typeid", "typeof",
    "ббайт", "ucent", "бцел", "бдол", "union", "unittest", "бкрат",
    "version", "проц", "volatile",
    "шим", "while", "with",
    "__FILE__", "__LINE__", "__thread", "__traits", "__gshared"
  ];

  foreach (word; RESERVEDWORDS) {
    if (word == имя)
      return true;
  }
  return false;
}

private проц проверьХРез(цел hr) {
  if (hr != S_OK)
    throw new КОМИскл(hr);
}

class Референс {

  private ткст name_;
  private ткст help_;
  private Guid guid_;
  private ткст location_;
  private Версия version_;

  ткст имя() {
    return name_;
  }

  ткст справка() {
    return help_;
  }

  Guid гуид() {
    return guid_;
  }

  ткст положение() {
    return location_;
  }

  Версия дайВерсию() {
    return version_;
  }

  private this() {
  }

  private this(ткст имя, ткст справка, Guid гуид, ткст положение, Версия вер) {
    name_ = имя;
    help_ = справка;
    guid_ = гуид;
    location_ = положение;
    version_ = вер;
  }

}

/**
 */
class ТиповаяБиб {

  private ткст name_;
  private ткст help_;
  private Guid guid_;
  private Версия version_;
  private ткст location_;
  private Тип[] types_;
  private Модуль[] modules_;
  private Референс[] references_;

  private ITypeLib typeLib_;

  private this(ITypeLib типБиб, ткст имяф) {
    typeLib_ = типБиб;
    location_ = имяф;

    шим* bstrName, bstrHelp;
    if (УДАЧНО(typeLib_.GetDocumentation(-1, &bstrName, &bstrHelp, null, null))) {
      name_ = изБткст(bstrName);
      help_ = изБткст(bstrHelp);
    }

    TLIBATTR* attr;
    if (УДАЧНО(typeLib_.GetLibAttr(attr))) {
      scope(exit) typeLib_.ReleaseTLibAttr(attr);

      guid_ = attr.гуид;
      version_ = new Версия(attr.wMajorVerNum, attr.wMinorVerNum);
    }
  }

  ~this() {
    if (typeLib_ !is null) {
      tryRelease(typeLib_);
      typeLib_ = null;
    }

    types_ = null;
    modules_ = null;
    references_ = null;
  }

  /**
   */
  ткст имя() {
    return name_;
  }

  /**
   */
  ткст справка() {
    return help_;
  }

  /**
   */
  Guid гуид() {
    return guid_;
  }

  /**
   */
  ткст положение() {
    return location_;
  }

  /**
   */
  Версия дайВерсию() {
    return version_;
  }

  /**
   */
  static ТиповаяБиб загрузи(ткст имяф) {
    if (имяф == null)
      throw new ИсклАргумента("Название файла не может быть null", "имяф");

    ITypeLib типБиб = null;
    // Try to загрузи the library from имяф.
    цел hr = LoadTypeLib(имяф.вУтф16н(), типБиб);
    if (hr != S_OK) {
      // If that failed, treat filename as a GUID and try to загрузи from the registry.

      ткст гуид = имяф;
      if (гуид[0] != '{')
        гуид = '{' ~ гуид;
      if (гуид[$ - 1] != '}')
        гуид ~= '}';

      scope typeLibKey = RegistryKey.classesRoot.openSubKey("TypeLib\\" ~ гуид);
      if (typeLibKey !is null && typeLibKey.subKeyCount > 0) {
        // The subkeys are the тип library's version numbers.
        // Sort then iterate in реверсни order so that the most recent version is attempted first.
        ткст[] versions = typeLibKey.subKeyNames.sort;
        foreach_reverse (v; versions) {
          scope versionKey = typeLibKey.openSubKey(v);
          if (versionKey !is null && versionKey.subKeyCount > 0) {
            ткст[] subKeyNames = versionKey.subKeyNames;
            // The ключи under the version are <LCID>\win32. The LCID is usually 0 - but, even if not, we just
            // take the first запись and look inside that for the путь.
            scope pathKey = versionKey.openSubKey(subKeyNames[0] ~ "\\win32");
            if (pathKey !is null) {
              // The ключ's default значение is the путь.
              return загрузи(pathKey.дайЗначение!(ткст)(null));
            }
          }
        }
      }

      // If we дай here, we couldn't open the тип library.
      throw new КОМИскл(hr);
    }

    return new ТиповаяБиб(типБиб, имяф);
  }

  public final Референс[] дайРеференсы() {
    if (references_ == null) {
      GUID libGuid;
      TLIBATTR* libAttr;
      ITypeInfo инфОТипе;
      цел hr;

      Референс[GUID] map;

      проц addTLibGuidToMapTI(ITypeInfo инфОТипе) {
        ITypeLib типБиб;
        бцел индекс;
        if (инфОТипе.GetContainingTypeLib(типБиб, индекс) == S_OK) {
          scope(exit) типБиб.Release();

          if (типБиб.GetLibAttr(libAttr) == S_OK) {
            scope(exit) типБиб.ReleaseTLibAttr(libAttr);

            if (!(libAttr.гуид in map)) {
              ткст имя, справка, положение;

              шим* bstrName, bstrHelp;
              if (типБиб.GetDocumentation(-1, &bstrName, &bstrHelp, null, null) == S_OK) {
                имя = изБткст(bstrName);
                справка = изБткст(bstrHelp);
              }
              Версия ver = new Версия(libAttr.wMajorVerNum, libAttr.wMinorVerNum);

              scope typeLibKey = RegistryKey.classesRoot.openSubKey("TypeLib\\" ~ libAttr.гуид.вТкст("P"));
              if (typeLibKey !is null && typeLibKey.subKeyCount > 0) {
                scope subKey = typeLibKey.openSubKey(ver.вТкст());
                if (subKey !is null && subKey.subKeyCount > 0) {
                  ткст[] subKeyNames = subKey.subKeyNames;
                  scope win32Key = subKey.openSubKey(subKeyNames[0] ~ "\\win32");
                  if (win32Key !is null)
                    положение = win32Key.дайЗначение!(ткст)(null);
                }
              }

              map[libAttr.гуид] = new Референс(имя, справка, libAttr.гуид, положение, ver);
            }
          }
        }
      }

      проц addTLibGuidToMapRT(ITypeInfo инфОТипе, бцел refType) {
        ITypeInfo refTypeInfo;
        if (инфОТипе.GetRefTypeInfo(refType, refTypeInfo) == S_OK) {
          scope(exit) refTypeInfo.Release();
          addTLibGuidToMapTI(refTypeInfo);
        }
      }

      проц addTLibGuidToMapTD(TYPEDESC* typeDesc) {
        if (typeDesc != null) {
          for (цел i = 0; typeDesc.vt == VT_PTR || typeDesc.vt == VT_SAFEARRAY || typeDesc.vt == VT_CARRAY; i++) {
            typeDesc = typeDesc.lptdesc;
            if (i == 200) break;
          }
          if (typeDesc.vt == VT_USERDEFINED)
            addTLibGuidToMapRT(инфОТипе, typeDesc.hreftype);
        }
      }

      проц addBaseToMap(ITypeInfo инфОТипе) {
        бцел refType;
        ITypeInfo refTypeInfo;
        if (инфОТипе.GetRefTypeOfImplType(-1, refType) == S_OK) {
          if (инфОТипе.GetRefTypeInfo(refType, refTypeInfo) == S_OK) {
            scope(exit) refTypeInfo.Release();
            if (refTypeInfo.GetRefTypeOfImplType(0, refType) == S_OK)
              addTLibGuidToMapRT(refTypeInfo, refType);
          }
        }
      }

      if (typeLib_.GetLibAttr(libAttr) == S_OK) {
        scope(exit) typeLib_.ReleaseTLibAttr(libAttr);
        map[libGuid = libAttr.гуид] = new Референс;
      }

      TYPEATTR* typeAttr;
      for (бцел i = 0; i < typeLib_.GetTypeInfoCount(); i++) {
        if (typeLib_.GetTypeInfo(i, инфОТипе) == S_OK) {
          scope(exit) инфОТипе.Release();

          if (инфОТипе.GetTypeAttr(typeAttr) == S_OK) {
            scope(exit) инфОТипе.ReleaseTypeAttr(typeAttr);

            if (typeAttr.typekind == TYPEKIND.TKIND_DISPATCH && (typeAttr.wTypeFlags & TYPEFLAGS.TYPEFLAG_FDUAL) != 0)
              addBaseToMap(инфОТипе);

            for (бцел j = 0; j < typeAttr.cImplTypes; j++) {
              бцел refType;
              if (инфОТипе.GetRefTypeOfImplType(j, refType) == S_OK)
                addTLibGuidToMapRT(инфОТипе, refType);
            }

            for (бцел j = 0; j < typeAttr.cVars; j++) {
              VARDESC* varDesc;
              if (инфОТипе.GetVarDesc(j, varDesc) == S_OK) {
                scope(exit) инфОТипе.ReleaseVarDesc(varDesc);
                addTLibGuidToMapTD(&varDesc.elemdescVar.tdesc);
              }
            }

            for (бцел j = 0; j < typeAttr.cFuncs; j++) {
              FUNCDESC* funcDesc;
              if (инфОТипе.GetFuncDesc(j, funcDesc) == S_OK) {
                scope(exit) инфОТипе.ReleaseFuncDesc(funcDesc);
                addTLibGuidToMapTD(&funcDesc.elemdescFunc.tdesc);
                for (бцел k = 0; k < funcDesc.cParams; k++)
                  addTLibGuidToMapTD(&funcDesc.lprgelemdescParam[k].tdesc);
              }
            }
          }
        }
      }

      map.remove(libGuid);
      references_.length = map.keys.length;
      foreach (i, ключ; map.keys)
        references_[i] = map[ключ];
    }
    if (references_ == null)
      return new Референс[0];
    return references_;
  }

  /**
   */
  final Модуль[] дайМодули() {
    if (modules_ == null) {
      ITypeInfo инфОТипе;
      TYPEKIND typeKind;
      for (auto i = 0; i < typeLib_.GetTypeInfoCount(); i++) {
        проверьХРез(typeLib_.GetTypeInfoType(i, typeKind));
        if (typeKind == TYPEKIND.TKIND_MODULE) {
          проверьХРез(typeLib_.GetTypeInfo(i, инфОТипе));
          modules_ ~= new Модуль(инфОТипе, this);
        }
      }
    }
    return modules_;
  }

  /**
   */
  final Тип[] дайТипы() {
    if (types_ == null) {
      ITypeInfo инфОТипе;
      TYPEKIND typeKind;
      TYPEATTR* typeAttr;

      for (auto i = 0; i < typeLib_.GetTypeInfoCount(); i++) {
        проверьХРез(typeLib_.GetTypeInfo(i, инфОТипе));
        проверьХРез(typeLib_.GetTypeInfoType(i, typeKind));
        проверьХРез(инфОТипе.GetTypeAttr(typeAttr));

        scope(exit) {
          инфОТипе.ReleaseTypeAttr(typeAttr);
          tryRelease(инфОТипе);
        }

        switch (typeKind) {
          case TYPEKIND.TKIND_COCLASS:
            if (typeAttr.wTypeFlags & TYPEFLAGS.TYPEFLAG_FCANCREATE)
              types_ ~= new TypeImpl(инфОТипе, ПАтрыТипа.СоКласс, this);
            break;

          case TYPEKIND.TKIND_INTERFACE:
            auto attrs = ПАтрыТипа.Интерфейс;
            if (typeAttr.wTypeFlags & TYPEFLAGS.TYPEFLAG_FDUAL)
              attrs |= ПАтрыТипа.InterfaceIsDual;
            types_ ~= new TypeImpl(инфОТипе, attrs, this);
            break;

          case TYPEKIND.TKIND_DISPATCH:
            auto attrs = ПАтрыТипа.Интерфейс | ПАтрыТипа.InterfaceIsDispatch;
            if (typeAttr.wTypeFlags & TYPEFLAGS.TYPEFLAG_FDUAL)
              attrs |= ПАтрыТипа.InterfaceIsDual;

            бцел refType;
            цел hr = инфОТипе.GetRefTypeOfImplType(-1, refType);
            if (hr != TYPE_E_ELEMENTNOTFOUND && refType != 0) {
              ITypeInfo refTypeInfo;
              проверьХРез(инфОТипе.GetRefTypeInfo(refType, refTypeInfo));
              scope(exit) tryRelease(refTypeInfo);

              types_ ~= new TypeImpl(инфОТипе, refTypeInfo, attrs, this);
            }
            else
              types_ ~= new TypeImpl(инфОТипе, attrs, this);
            break;

          case TYPEKIND.TKIND_RECORD:
            types_ ~= new TypeImpl(инфОТипе, ПАтрыТипа.Структура, this);
            break;

          case TYPEKIND.TKIND_UNION:
            types_ ~= new TypeImpl(инфОТипе, ПАтрыТипа.Союз, this);
            break;

          case TYPEKIND.TKIND_ALIAS:
            types_ ~= new TypeImpl(инфОТипе, ПАтрыТипа.Алиас, this);
            break;
            
          case TYPEKIND.TKIND_ENUM:
            types_ ~= new TypeImpl(инфОТипе, ПАтрыТипа.Enum, this);
            break;

          default:
        }
      }
    }
    return types_;
  }

  /**
   */
  final Тип[] найдиТипы(бул delegate(Тип) фильтр) {
    Тип[] filteredTypes;
    foreach (тип; дайТипы()) {
      if (фильтр(тип))
        filteredTypes ~= тип;
    }
    return filteredTypes;
  }

}

/**
 */
class Модуль {

  private Член[] members_;
  private Поле[] fields_;
  private Метод[] methods_;
  private ТиповаяБиб typeLib_;

  private ITypeInfo typeInfo_;

  /**
   */
  final Член[] дайЧлены() {
    if (members_ == null) {
      TYPEATTR* typeAttr;
      проверьХРез(typeInfo_.GetTypeAttr(typeAttr));
      scope(exit) typeInfo_.ReleaseTypeAttr(typeAttr);

      VARDESC* varDesc;
      for (auto i = 0; i < typeAttr.cVars; i++) {
        проверьХРез(typeInfo_.GetVarDesc(i, varDesc));
        scope(exit) typeInfo_.ReleaseVarDesc(varDesc);

        шим* bstrName;
        бцел nameCount;
        проверьХРез(typeInfo_.GetNames(varDesc.memid, &bstrName, 1, nameCount));

        Тип типПоля = new TypeImpl(TypeImpl.дайИмяТипа(&varDesc.elemdescVar.tdesc, typeInfo_), typeLib_);
        members_ ~= new FieldImpl(типПоля, изБткст(bstrName), *varDesc.lpvarValue, cast(FieldAttributes)varDesc.varkind);
      }

      FUNCDESC* funcDesc;
      for (auto i = 0; i < typeAttr.cFuncs; i++) {
        проверьХРез(typeInfo_.GetFuncDesc(i, funcDesc));
        scope(exit) typeInfo_.ReleaseFuncDesc(funcDesc);

        цел ид = funcDesc.memid;

        шим* bstrName, bstrHelp;
        проверьХРез(typeInfo_.GetDocumentation(ид, &bstrName, &bstrHelp, null, null));

        Тип типВозврата = new TypeImpl(TypeImpl.дайИмяТипа(&funcDesc.elemdescFunc.tdesc, typeInfo_), typeLib_);
        members_ ~= new MethodImpl(typeInfo_, изБткст(bstrName), изБткст(bstrHelp), ид, MethodAttributes.Default, типВозврата, typeLib_);
      }
    }
    return members_;
  }

  /**
   */
  final Поле[] дайПоля() {
    if (fields_ == null) {
      foreach (член; дайЧлены()) {
        if (член !is null && (член.типЧлена & ПТипыЧленов.Поле))
          fields_ ~= cast(Поле)член;
      }
    }
    return fields_;
  }

  /**
   */
  final Метод[] дайМетоды() {
    if (methods_ == null) {
      foreach (член; дайЧлены()) {
        if (член !is null && (член.типЧлена & ПТипыЧленов.Метод))
          methods_ ~= cast(Метод)член;
      }
    }
    return methods_;
  }

  /**
   */
  final Член[] дайЧлен(ткст имя) {
    Член[] рез = null;
    foreach (член; дайЧлены()) {
      if (член !is null && член.имя == имя)
        рез ~= член;
    }
    return рез;
  }

  /**
   */
  final Поле дайПоле(ткст имя) {
    foreach (поле; дайПоля()) {
      if (поле !is null && поле.имя == имя)
        return поле;
    }
    return null;
  }

  /**
   */
  final Метод дайМетод(ткст имя) {
    foreach (метод; дайМетоды()) {
      if (метод !is null && метод.имя == имя)
        return метод;
    }
    return null;
  }

  /*package*/ this(ITypeInfo инфОТипе, ТиповаяБиб типБиб) {
    typeInfo_ = инфОТипе;
    typeLib_ = типБиб;
  }

  ~this() {
    if (typeInfo_ !is null) {
      tryRelease(typeInfo_);
      typeInfo_ = null;
    }
  }

}

///
enum ПТипыЧленов {
  Поле  = 0x1, ///
  Метод = 0x2, ///
  Тип   = 0x4  ///
}

/**
 */
abstract class Член {

  /**
   */
  abstract ткст имя();

  /**
   */
  abstract ткст справка();

  /**
   */
  abstract ПТипыЧленов типЧлена();

}

///
enum ПАтрыТипа {
  СоКласс             = 0x1,
  Интерфейс           = 0x2,
  Структура              = 0x4,
  Enum                = 0x8,
  Алиас               = 0x10,
  Союз               = 0x20,
  InterfaceIsDual     = 0x100,
  InterfaceIsDispatch = 0x200,
  InterfaceIsDefault  = 0x400,
  InterfaceIsSource   = 0x800
}

/**
 */
abstract class Тип : Член {

  /**
   */
  override ПТипыЧленов типЧлена() {
    return ПТипыЧленов.Тип;
  }

  /**
   */
  abstract ПАтрыТипа атрибуты();

  /**
   */
  abstract Guid гуид();

  /**
   */
  abstract Тип типОснова();

  /**
   */
  abstract Тип низлежащТип();

  /**
   */
  abstract Тип[] дайИнтерфейсы();

  /**
   */
  abstract Член[] дайЧлены();

  /**
   */
  abstract Поле[] дайПоля();

  /**
   */
  abstract Метод[] дайМетоды();

  /**
   */
  Член[] дайЧлен(ткст имя) {
    Член[] рез = null;
    foreach (член; дайЧлены()) {
      if (член !is null && член.имя == имя)
        рез ~= член;
    }
    return рез;
  }

  /**
   */
  Поле дайПоле(ткст имя) {
    foreach (поле; дайПоля()) {
      if (поле !is null && поле.имя == имя)
        return поле;
    }
    return null;
  }

  /**
   */
  Метод дайМетод(ткст имя) {
    foreach (метод; дайМетоды()) {
      if (метод !is null && метод.имя == имя)
        return метод;
    }
    return null;
  }

  /**
   */
  ткст вТкст() {
    return "Тип: " ~ имя;
  }

  /**
   */
  final бул соКласс_ли() {
    return (атрибуты & ПАтрыТипа.СоКласс) != 0;
  }

  /**
   */
  final бул интерфейс_ли() {
    return (атрибуты & ПАтрыТипа.Интерфейс) != 0;
  }

  /**
   */
  final бул структ_ли() {
    return (атрибуты & ПАтрыТипа.Структура) != 0;
  }

  /**
   */
  final бул перечень_ли() {
    return (атрибуты & ПАтрыТипа.Enum) != 0;
  }

  /**
   */
  final бул алиас_ли() {
    return (атрибуты & ПАтрыТипа.Алиас) != 0;
  }

  /**
   */
  final бул союз_ли() {
    return (атрибуты & ПАтрыТипа.Союз) != 0;
  }

}

/*package*/ final class TypeImpl : Тип {

  private ткст name_;
  private ткст help_;
  private Guid guid_;
  private ПАтрыТипа attr_;
  private Тип baseType_;
  private Тип underlyingType_;
  private Тип[] interfaces_;
  private Член[] members_;
  private Поле[] fields_;
  private Метод[] methods_;

  private ITypeInfo typeInfo_;
  private ITypeInfo dispTypeInfo_;
  private ТиповаяБиб typeLib_;

  override ткст имя() {
    return name_;
  }

  override ткст справка() {
    return help_;
  }

  override ПАтрыТипа атрибуты() {
    return attr_;
  }

  override Guid гуид() {
    return guid_;
  }

  override Тип типОснова() {
    if (baseType_ is null) {
      auto инфОТипе = (dispTypeInfo_ !is null) 
        ? dispTypeInfo_
        : typeInfo_;

      TYPEATTR* typeAttr;
      проверьХРез(инфОТипе.GetTypeAttr(typeAttr));
      бул hasBase = (typeAttr.cImplTypes > 0);
      инфОТипе.ReleaseTypeAttr(typeAttr);

      if (hasBase) {
        бцел refType;
        цел hr = инфОТипе.GetRefTypeOfImplType((dispTypeInfo_ !is null) ? -1 : 0, refType);
        if (hr != S_OK && hr != TYPE_E_ELEMENTNOTFOUND)
          throw new КОМИскл(hr);

        if (hr != TYPE_E_ELEMENTNOTFOUND) {
          ITypeInfo baseTypeInfo;
          проверьХРез(инфОТипе.GetRefTypeInfo(refType, baseTypeInfo));
          scope(exit) baseTypeInfo.Release();

          // Take separate paths for dispinterfaces and pure interfaces.
          if (dispTypeInfo_ !is null) {
            проверьХРез(baseTypeInfo.GetTypeAttr(typeAttr));
            scope(exit) baseTypeInfo.ReleaseTypeAttr(typeAttr);
            hasBase = (typeAttr.cImplTypes > 0);

            if (hasBase && (атрибуты & ПАтрыТипа.InterfaceIsDispatch)) {
              if (typeAttr.typekind == TYPEKIND.TKIND_INTERFACE || typeAttr.typekind == TYPEKIND.TKIND_DISPATCH) {
                проверьХРез(baseTypeInfo.GetRefTypeOfImplType(0, refType));

                ITypeInfo realTypeInfo;
                проверьХРез(baseTypeInfo.GetRefTypeInfo(refType, realTypeInfo));
                scope(exit) realTypeInfo.Release();

                ПАтрыТипа attrs = ПАтрыТипа.Интерфейс;
                if (typeAttr.typekind == TYPEKIND.TKIND_DISPATCH)
                  attrs |= ПАтрыТипа.InterfaceIsDispatch;
                baseType_ = new TypeImpl(realTypeInfo, attrs, typeLib_);
              }
            }
            else {
              проверьХРез(инфОТипе.GetRefTypeOfImplType(0, refType));
              ITypeInfo realTypeInfo;
              проверьХРез(baseTypeInfo.GetRefTypeInfo(refType, realTypeInfo));
              baseType_ = new TypeImpl(realTypeInfo, ПАтрыТипа.Интерфейс, typeLib_);
              realTypeInfo.Release();
            }
          }
          else
            baseType_ = new TypeImpl(baseTypeInfo, ПАтрыТипа.Интерфейс, typeLib_);
        }
      }
    }
    return baseType_;
  }

  override Тип низлежащТип() {
    if (underlyingType_ is null) {
      TYPEATTR* typeAttr;
      проверьХРез(typeInfo_.GetTypeAttr(typeAttr));
      scope(exit) typeInfo_.ReleaseTypeAttr(typeAttr);

      underlyingType_ = new TypeImpl(дайИмяТипа(&typeAttr.tdescAlias, typeInfo_), typeLib_);
    }
    return underlyingType_;
  }

  override Тип[] дайИнтерфейсы() {
    if (interfaces_ == null && соКласс_ли()) {
      бцел счёт;
      TYPEATTR* typeAttr;
      проверьХРез(typeInfo_.GetTypeAttr(typeAttr));
      scope(exit) typeInfo_.ReleaseTypeAttr(typeAttr);

      счёт = typeAttr.cImplTypes;

      for (бцел i = 0; i < счёт; i++) {
        бцел refType;
        проверьХРез(typeInfo_.GetRefTypeOfImplType(i, refType));

        ITypeInfo implTypeInfo;
        проверьХРез(typeInfo_.GetRefTypeInfo(refType, implTypeInfo));
        scope(exit) implTypeInfo.Release();

        цел флаги;
        проверьХРез(typeInfo_.GetImplTypeFlags(i, флаги));
        ПАтрыТипа attrs = ПАтрыТипа.Интерфейс;
        if (флаги & IMPLTYPEFLAG_FDEFAULT)
          attrs |= ПАтрыТипа.InterfaceIsDefault;
        if (флаги & IMPLTYPEFLAG_FSOURCE)
          attrs |= ПАтрыТипа.InterfaceIsSource;

        interfaces_ ~= new TypeImpl(implTypeInfo, attrs, typeLib_);
      }
    }
    return interfaces_;
  }

  override Член[] дайЧлены() {
    if (members_ == null) {
      TYPEATTR* typeAttr;
      проверьХРез(typeInfo_.GetTypeAttr(typeAttr));
      scope(exit) typeInfo_.ReleaseTypeAttr(typeAttr);

      VARDESC* varDesc;
      for (auto i = 0; i < typeAttr.cVars; i++) {

        проверьХРез(typeInfo_.GetVarDesc(i, varDesc));
        scope(exit) typeInfo_.ReleaseVarDesc(varDesc);

        шим* bstrName;
        бцел nameCount;
        проверьХРез(typeInfo_.GetNames(varDesc.memid, &bstrName, 1, nameCount));

        Тип типПоля = new TypeImpl(TypeImpl.дайИмяТипа(&varDesc.elemdescVar.tdesc, typeInfo_), typeLib_);
        ткст fieldName = изБткст(bstrName);
        if (varDesc.varkind == VARKIND.VAR_CONST)
          members_ ~= new FieldImpl(типПоля, fieldName, *varDesc.lpvarValue, cast(FieldAttributes)varDesc.varkind);
        else
          members_ ~= new FieldImpl(типПоля, fieldName, cast(FieldAttributes)varDesc.varkind);
      }

      FUNCDESC* funcDesc;
      for (auto i = 0; i < typeAttr.cFuncs; i++) {
        проверьХРез(typeInfo_.GetFuncDesc(i, funcDesc));
        scope(exit) typeInfo_.ReleaseFuncDesc(funcDesc);

        цел ид = funcDesc.memid;

        if ((атрибуты & ПАтрыТипа.InterfaceIsDispatch)
          && (ид < 0x60000000 || ид > 0x60010003)
          || !(атрибуты & ПАтрыТипа.InterfaceIsDispatch)) {
          // Only if we're not one of the IDispatch functions.
          MethodAttributes attrs = MethodAttributes.Default;
          if (funcDesc.invkind & INVOKEKIND.INVOKE_PROPERTYGET)
            attrs = MethodAttributes.GetProperty;
          if (funcDesc.invkind & INVOKEKIND.INVOKE_PROPERTYPUT)
            attrs = MethodAttributes.PutProperty;
          if (funcDesc.invkind & INVOKEKIND.INVOKE_PROPERTYPUTREF)
            attrs = MethodAttributes.PutRefProperty;

          шим* bstrName, bstrHelp;
          проверьХРез(typeInfo_.GetDocumentation(ид, &bstrName, &bstrHelp, null, null));

          Тип типВозврата = new TypeImpl(TypeImpl.дайИмяТипа(&funcDesc.elemdescFunc.tdesc, typeInfo_), typeLib_);
          members_ ~= new MethodImpl(typeInfo_, изБткст(bstrName), изБткст(bstrHelp), ид, attrs, типВозврата, typeLib_);
        }
      }
    }
    return members_;
  }

  override Поле[] дайПоля() {
    if (fields_ == null) {
      foreach (член; дайЧлены()) {
        if (член !is null && (член.типЧлена & ПТипыЧленов.Поле) != 0)
          fields_ ~= cast(Поле)член;
      }
    }
    return fields_;
  }

  override Метод[] дайМетоды() {
    if (methods_ == null) {
      foreach (член; дайЧлены()) {
        if (член !is null && (член.типЧлена & ПТипыЧленов.Метод) != 0)
          methods_ ~= cast(Метод)член;
      }
    }
    return methods_;
  }

  private проц init(ITypeInfo инфОТипе) {
    typeInfo_ = инфОТипе;
    typeInfo_.AddRef();

    шим* bstrName, bstrHelp;
    if (УДАЧНО(typeInfo_.GetDocumentation(-1, &bstrName, &bstrHelp, null, null))) {
      name_ = изБткст(bstrName);
      help_ = изБткст(bstrHelp);
    }

    TYPEATTR* attr;
    if (УДАЧНО(typeInfo_.GetTypeAttr(attr))) {
      guid_ = attr.гуид;
      typeInfo_.ReleaseTypeAttr(attr);
    }
  }

  /*package*/ this(ITypeInfo инфОТипе, ПАтрыТипа атрибуты, ТиповаяБиб типБиб) {
    init(инфОТипе);
    attr_ = атрибуты;
    typeLib_ = типБиб;
  }

  /*package*/ this(ITypeInfo dispTypeInfo, ITypeInfo инфОТипе, ПАтрыТипа атрибуты, ТиповаяБиб типБиб) {
    this(dispTypeInfo, атрибуты, типБиб);

    typeInfo_ = инфОТипе;
    typeInfo_.AddRef();
    dispTypeInfo_ = dispTypeInfo;
  }

  /*package*/ this(ткст имя, ТиповаяБиб типБиб) {
    name_ = имя;
    typeLib_ = типБиб;
  }

  ~this() {
    if (typeInfo_ !is null) {
      tryRelease(typeInfo_);
      typeInfo_ = null;
    }

    if (dispTypeInfo_ !is null) {
      tryRelease(dispTypeInfo_);
      dispTypeInfo_ = null;
    }
  }

  /*package*/ static ткст дайИмяТипа(TYPEDESC* desc, ITypeInfo инфОТипе, цел флаги = 0, бул интерфейс_ли = false) {

    ткст дайИмяТипаОсновы() {
      switch (desc.vt) {
        case VT_BOOL:
          return "крат"; // VARIANT_BOOL
        case VT_DATE:
          return "дво"; // DATE
        case VT_ERROR:
          return "цел";
        case VT_UI1:
          return "ббайт";
        case VT_I1:
          return "байт";
        case VT_UI2:
          return "бкрат";
        case VT_I2:
          return "крат";
        case VT_UI4, VT_UINT:
          return "бцел";
        case VT_I4, VT_INT:
          return "цел";
        case VT_HRESULT:
          return "цел"; // HRESULT
        case VT_UI8:
          return "бдол";
        case VT_I8:
          return "дол";
        case VT_R4:
          return "плав";
        case VT_R8:
          return "дво";
        case VT_CY:
          return "дол";
        case VT_LPSTR:
          return "шим*";
        case VT_BSTR:
          return "шим*"; // BSTR
        case VT_LPWSTR:
          return "шим*";
        case VT_UNKNOWN:
          return "IUnknown";
        case VT_DISPATCH:
          return "IDispatch";
        case VT_VARIANT:
          return "VARIANT";
        case VT_DECIMAL:
          return "DECIMAL";
        case VT_ARRAY, VT_SAFEARRAY:
          return "SAFEARRAY*";
        case VT_VOID:
          return "проц";
        case VT_BYREF:
          return "ук";
        default:
      }
      return null;
    }

    ткст дайИмяКастомнТипа() {
      ткст typeName;
      ITypeInfo customTypeInfo;
      if (УДАЧНО(инфОТипе.GetRefTypeInfo(desc.hreftype, customTypeInfo))) {
        scope(exit) customTypeInfo.Release();

        шим* bstrName;
        customTypeInfo.GetDocumentation(-1, &bstrName, null, null, null);
        typeName = изБткст(bstrName);
      }
      return typeName;
    }

    ткст getPtrTypeName() {
      // Try to resolve the имя of a pointer тип.
      // Special cases to consider:
      //   - Don't добавь '*' to interfaces.
      //   - Strings are sometimes defined as бкрат* instead of шим*, but бкрат* doesn't always equal шим*.

      ткст typeName;

      if (desc.lptdesc.vt == VT_USERDEFINED) {
        ITypeInfo ti;
        if (инфОТипе.GetRefTypeInfo(desc.lptdesc.hreftype, ti) == S_OK && ti !is null) {
          scope(exit) ti.Release();

          TYPEATTR* typeAttr;
          if (ti.GetTypeAttr(typeAttr) == S_OK) {
            scope(exit) ti.ReleaseTypeAttr(typeAttr);
            if (typeAttr.typekind == TYPEKIND.TKIND_INTERFACE || typeAttr.typekind == TYPEKIND.TKIND_DISPATCH)
              typeName = дайИмяТипа(desc.lptdesc, инфОТипе, флаги, true);
          }
          if (typeName != null)
            return typeName;
        }
      }

      if (typeName == null)
        typeName = дайИмяТипа(desc.lptdesc, инфОТипе, флаги, интерфейс_ли);
      if (!интерфейс_ли && (!(флаги & PARAMFLAG_FOUT) || typeName == "проц"))
        typeName ~= "*";

      return typeName;
    }

    ткст getArrayTypeName() {
      if (desc.lpadesc.cDims == 1 && desc.lpadesc.rgbounds[desc.lpadesc.cDims - 1].cElements > 0)
        return format("{0}[{1}]", дайИмяТипа(&desc.lpadesc.tdescElem, инфОТипе, флаги, интерфейс_ли), desc.lpadesc.rgbounds[desc.lpadesc.cDims - 1].cElements);
      return дайИмяТипа(&desc.lpadesc.tdescElem, инфОТипе, флаги, интерфейс_ли) ~ "*";
    }

    if (desc.vt == VT_PTR)
      return getPtrTypeName();
    if (desc.vt == VT_CARRAY)
      return getArrayTypeName();

    // Try to дай the имя from the VARTYPE.
    ткст typeName = дайИмяТипаОсновы();
    if (typeName == null)
      typeName = дайИмяКастомнТипа();
    return typeName;
  }

}

///
enum FieldAttributes {
  None,
  Static,
  Constant
}

/**
 */
abstract class Поле : Член {

  /**
   */
  override ПТипыЧленов типЧлена() {
    return ПТипыЧленов.Поле;
  }

  /**
   */
  abstract VARIANT дайЗначение();

  /**
   */
  abstract FieldAttributes атрибуты();

  /**
   */
  abstract Тип типПоля();

}

/*package*/ final class FieldImpl : Поле {

  private ткст name_;
  private Тип fieldType_;
  private FieldAttributes attr_;
  private VARIANT value_;

  override ткст имя() {
    return name_;
  }

  override ткст справка() {
    return null;
  }

  override VARIANT дайЗначение() {
    return value_;
  }

  override FieldAttributes атрибуты() {
    return attr_;
  }

  override Тип типПоля() {
    return fieldType_;
  }

  /*package*/ this(Тип типПоля, ткст имя, FieldAttributes атрибуты) {
    fieldType_ = типПоля;
    name_ = имя;
    attr_ = атрибуты;
  }

  /*package*/ this(Тип типПоля, ткст имя, ref VARIANT значение, FieldAttributes атрибуты) {
    значение.копируйВ(value_);
    //value_ = значение;
    this(типПоля, имя, атрибуты);
  }

}

///
enum MethodAttributes {
  None           = 0x0,
  Default        = 0x1,
  GetProperty    = 0x2,
  PutProperty    = 0x4,
  PutRefProperty = 0x8
}

/**
 */
abstract class Метод : Член {

  /**
   */
  override ПТипыЧленов типЧлена() {
    return ПТипыЧленов.Метод;
  }

  /**
   */
  abstract Параметр[] дайПараметры();

  /**
   */
  abstract MethodAttributes атрибуты();

  /**
   */
  abstract Тип типВозврата();

  /**
   */
  abstract Параметр параметрВозврата();

  /**
   */
  abstract цел ид();

}

/*package*/ final class MethodImpl : Метод {

  private ткст name_;
  private ткст help_;
  private цел id_;
  private MethodAttributes attrs_;
  private ТиповаяБиб typeLib_;
  private Тип returnType_;
  private Параметр returnParameter_;
  private Параметр[] parameters_;

  private ITypeInfo typeInfo_;

  override ткст имя() {
    return name_;
  }

  override ткст справка() {
    return help_;
  }

  override Параметр[] дайПараметры() {
    if (parameters_ == null)
      parameters_ = Параметр.дайПараметры(this);
    return parameters_;
  }

  override MethodAttributes атрибуты() {
    return attrs_;
  }

  override Тип типВозврата() {
    return returnType_;
  }

  override Параметр параметрВозврата() {
    if (returnParameter_ is null)
      Параметр.дайПараметры(this, returnParameter_, true);
    return returnParameter_;
  }

  override цел ид() {
    return id_;
  }

  /*package*/ this(ITypeInfo инфОТипе, ткст имя, ткст справка, цел ид, MethodAttributes атрибуты, Тип типВозврата, ТиповаяБиб типБиб) {
    typeInfo_ = инфОТипе;
    инфОТипе.AddRef();
    name_ = имя;
    help_ = справка;
    id_ = ид;
    attrs_ = атрибуты;
    returnType_ = типВозврата;
    typeLib_ = типБиб;
  }

  ~this() {
    if (typeInfo_ !is null) {
      tryRelease(typeInfo_);
      typeInfo_ = null;
    }
  }

}

///
enum ParameterAttributes {
  None       = 0x0,
  In         = 0x1,
  Out        = 0x2,
  Lcid       = 0x4,
  Retval     = 0x8,
  Опционал   = 0x10,
  HasDefault = 0x20
}

/**
 */
class Параметр {

  private Член member_;
  private ткст name_;
  private Тип parameterType_;
  private цел position_;
  private ParameterAttributes attrs_;

  /**
   */
  ткст имя() {
    return name_;
  }

  /**
   */
  цел позиция() {
    return position_;
  }

  /**
   */
  ParameterAttributes атрибуты() {
    return attrs_;
  }

  /**
   */
  Член член() {
    return member_;
  }

  /**
   */
  Тип типПараметра() {
    return parameterType_;
  }

  /**
   */
  бул вхо_ли() {
    return (атрибуты & ParameterAttributes.In) != 0;
  }

  /**
   */
  бул вых_ли() {
    return (атрибуты & ParameterAttributes.Out) != 0;
  }

  /**
   */
  бул isRetval() {
    return (атрибуты & ParameterAttributes.Retval) != 0;
  }

  /**
   */
  бул isOptional() {
    return (атрибуты & ParameterAttributes.Опционал) != 0;
  }

  /*package*/ this(Член owner, ткст имя, Тип типПараметра, цел позиция, ParameterAttributes атрибуты) {
    member_ = owner;
    name_ = имя;
    parameterType_ = типПараметра;
    position_ = позиция;
    attrs_ = атрибуты;

    if (резервнСлово_ли(name_))
      name_ ~= "Param";
  }

  /*package*/ static Параметр[] дайПараметры(MethodImpl метод) {
    Параметр dummy;
    return дайПараметры(метод, dummy, false);
  }

  /*package*/ static Параметр[] дайПараметры(MethodImpl метод, out Параметр параметрВозврата, бул getReturnParameter) {
    Параметр[] парамы;

    TYPEATTR* typeAttr;
    FUNCDESC* funcDesc;

    проверьХРез(метод.typeInfo_.GetTypeAttr(typeAttr));
    scope(exit) метод.typeInfo_.ReleaseTypeAttr(typeAttr);

    for (бцел i = 0; i < typeAttr.cFuncs; i++) {
      проверьХРез(метод.typeInfo_.GetFuncDesc(i, funcDesc));
      scope(exit) метод.typeInfo_.ReleaseFuncDesc(funcDesc);

      if (funcDesc.memid == метод.ид && (funcDesc.invkind & метод.атрибуты)) {
        шим** bstrNames = cast(шим**)CoTaskMemAlloc((funcDesc.cParams + 1) * (шим*).sizeof);

        бцел счёт;
        проверьХРез(метод.typeInfo_.GetNames(funcDesc.memid, bstrNames, funcDesc.cParams + 1, счёт));

        // The element at 0 is the имя of the function. We've already got this, so free it.
        freeBstr(bstrNames[0]);

        if ((funcDesc.invkind & INVOKEKIND.INVOKE_PROPERTYPUT) || (funcDesc.invkind & INVOKEKIND.INVOKE_PROPERTYPUTREF))
          bstrNames[0] = toBstr("значение");

        for (бкрат поз = 0; поз < funcDesc.cParams; поз++) {
          бкрат флаги = funcDesc.lprgelemdescParam[поз].paramdesc.wParamFlags;
          TypeImpl paramType = new TypeImpl(TypeImpl.дайИмяТипа(&funcDesc.lprgelemdescParam[поз].tdesc, метод.typeInfo_, флаги), метод.typeLib_);

          if ((флаги & PARAMFLAG_FRETVAL) && getReturnParameter && параметрВозврата is null)
            параметрВозврата = new Параметр(метод, изБткст(bstrNames[поз + 1]), paramType, -1, cast(ParameterAttributes)флаги);
          else if (!getReturnParameter) {
            ParameterAttributes attrs = cast(ParameterAttributes)флаги;
            if (paramType.name_ == "GUID*") {
              // Remove pointer описание from GUIDs, making them ref парамы instead.
              paramType.name_ = "GUID";
              attrs |= (ParameterAttributes.In | ParameterAttributes.Out);
            }
            парамы ~= new Параметр(метод, изБткст(bstrNames[поз + 1]), paramType, поз, attrs);
          }
        }

        CoTaskMemFree(bstrNames);
      }
    }

    return парамы;
  }

}