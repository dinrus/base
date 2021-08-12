/**
 * Contains classes that define культура-related information.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.loc.core;

import win32.base.core,
  win32.base.native,
  win32.loc.consts;
import win32.loc.time : Календарь,
  ДанныеКалендаря,
  ГрегорианскийКалендарь, 
  ЯпонскийКалендарь,
  ТайваньскийКалендарь,
  КорейскийКалендарь,
  ТаиБуддистскийКалендарь;
import stdrus : вЮ8, сравнлюб, впроп, взаг, вДво;
import cidrus : sprintf, memcmp, memicmp, wcslen;
version(D_Version2) {
  import stdrus : индексУ, последнИндексУ;
  alias индексУ найди;
  alias последнИндексУ найдрек;
}
else {
  import stdrus : найди, найдрек;
}

debug import stdrus : скажифнс;

extern(C) цел swscanf(in шим*, in шим*, ...);

private бцел[ткст] nameToLcidMap;
private ткст[бцел] lcidToNameMap;
private бцел[ткст] regionNameToLcidMap;

static ~this() {
  nameToLcidMap = null;
  lcidToNameMap = null;
  regionNameToLcidMap = null;
}

 шим* вУТФ16нНлс(ткст s, цел смещение, цел length, out цел translated) {
  translated = 0;
  if (s.length == 0)
    return null;

  auto pChars = s.ptr + смещение;
  цел cch = MultiByteToWideChar(CP_UTF8, 0, pChars, length, null, 0);
  if (cch == 0) 
    return null;

  шим[] рез = new шим[cch];
  translated = MultiByteToWideChar(CP_UTF8, 0, pChars, length, рез.ptr, cch);
  return рез.ptr;
}

 ткст вУТФ8Нлс(in шим* pChars, цел cch, out цел translated) {
  translated = 0;

  цел cb = WideCharToMultiByte(CP_UTF8, 0, pChars, cch, null, 0, null, null);
  if (cb == 0)
    return null;

  сим[] рез = new сим[cb];
  translated = WideCharToMultiByte(CP_UTF8, 0, pChars, cch, рез.ptr, cb, null, null);
  return cast(ткст)рез;
}

 ткст дайИнфОЛокале(бцел локаль, бцел поле, бул userOverride = true) {
  шим[80] буфер;
  цел cch = GetLocaleInfo(локаль, поле | (!userOverride ? LOCALE_NOUSEROVERRIDE : 0), буфер.ptr, буфер.length);
  if (cch == 0) 
    return null;

  return вЮ8(буфер[0 .. cch - 1]);
}

 цел дайИнфОЛокалеИ(бцел локаль, бцел поле, бул userOverride = true) {
  цел рез;
  GetLocaleInfo(локаль, поле | LOCALE_RETURN_NUMBER | (!userOverride ? LOCALE_NOUSEROVERRIDE : 0), cast(шим*)&рез, цел.sizeof);
  return рез;
}

 ткст дайИнфОКалендаре(бцел локаль, бцел календарь, бцел поле, бул userOverride = true) {
  шим[80] буфер;
  цел cch = GetCalendarInfo(локаль, календарь, поле | (!userOverride ? CAL_NOUSEROVERRIDE : 0), буфер.ptr, буфер.length, null);
  if (cch == 0) 
    return null;

  return вЮ8(буфер[0 .. cch - 1]);
}

 ткст дайГеоИнфо(бцел геоИд, бцел геоТип) {
  цел cch = GetGeoInfo(геоИд, геоТип, null, 0, 0);
  шим[] буфер = new шим[cch];
  cch = GetGeoInfo(геоИд, геоТип, буфер.ptr, буфер.length, 0);
  if (cch == 0)
    return null;

  return вЮ8(буфер[0 .. cch - 1]);
}

private проц гарантируйМапппингИмени() {

  бул EnumSystemLocales(out бцел[] локали) {
        static бцел[бцел] времн;

    extern(Windows)
    static бул EnumLocalesProc(шим* lpLocaleString) 
    {
      бцел локаль;
      if (swscanf(lpLocaleString, "%x", &локаль) > 0)
       {
        if (!(локаль in времн))
         {
          времн[локаль] = локаль;
          // Also добавь neutrals.
          бцел яз = локаль & 0x3FF;
          if (!(яз in времн) && (яз != 0x0014 && яз != 0x002C && яз != 0x003B && яз != 0x0043))
            времн[яз] = яз;
        }
        return  true;
      }
         return false;
    }


    
    if (!EnumLocalesProc ("RU-ru"))
      return false;

    for(бцел н; н <= времн.length; н++)
	{	
    локали ~= времн[н];
	}
    return true;
  }

  ткст дайИмяЛокали(бцел локаль) {
    ткст имя, язык, скрипт, страна;

    // Get the имя from NLS, natively on Vista and above, or via the downlevel /*package*/ for XP.
    try {
      шим[85] буфер;
      цел cch = LCIDToLocaleName(локаль, буфер.ptr, буфер.length, 0); // Vista and above
      if (cch != 0)
        имя = вЮ8(буфер[0 .. cch - 1]);
    }
    catch (ТочкаВходаНеНайденаИскл) {
      try {
        шим[85] буфер;
        цел cch = DownlevelLCIDToLocaleName(локаль, буфер.ptr, буфер.length, 0); // nlsmap.dll
        if (cch != 0)
          имя = вЮ8(буфер[0 .. cch - 1]);
      }
      catch (ДллНеНайденаИскл) {
      }
      catch (ТочкаВходаНеНайденаИскл) {
      }
    }

    // NLS doesn't return names for neutral локали.
    if (имя != null) {
      if ((локаль & 0x3FF) == локаль) {
        имя = дайИнфОЛокале(локаль, LOCALE_SPARENT); // Vista and above

        if (имя == null) {
          try {
            шим[85] буфер;
            цел cch = DownlevelGetParentLocaleName(локаль, буфер.ptr, буфер.length); // nlsmap.dll
            if (cch != 0)
              имя = вЮ8(буфер[0 .. cch - 1]);
          }
          catch (ДллНеНайденаИскл) {
          }
          catch (ТочкаВходаНеНайденаИскл) {
          }
        }
      }
    }

    // If we haven't got the имя from the above methods, manually build it.
    if (имя == null) {
      if (локаль == 0x243B)
        язык = "smn";
      else if (локаль == 0x203B)
        язык = "sms";
      else if (локаль == 0x1C3B || локаль == 0x183B)
        язык = "sma";
      else if (локаль == 0x143B || локаль == 0x103B)
        язык = "smj";
      else if (локаль == 0x046B || локаль == 0x086B || локаль == 0x0C6B)
        язык = "quz";
      else
        язык = дайИнфОЛокале(локаль, LOCALE_SISO639LANGNAME);

      if ((локаль & 0x3FF) != локаль) {
        if (локаль == 0x181A || локаль == 0x081A || локаль == 0x042C || локаль == 0x0443 || локаль == 0x141A)
          скрипт = "Latn";
        else if (локаль == 0x1C1A || локаль == 0x0C1A || локаль == 0x082C || локаль == 0x0843 || локаль == 0x085D || локаль == 0x085F)
          скрипт = "Cyrl";
        else if (локаль == 0x0850)
          скрипт = "Mong";

        if (локаль == 0x2409)
          страна = "029";
        else if (локаль == 0x081A || локаль == 0x0C1A)
          страна = "CS";
        else if (локаль == 0x040A)
          страна ~= "ES_tradnl";
        else
          страна = дайИнфОЛокале(локаль, LOCALE_SISO3166CTRYNAME);
      }

      имя = язык;
      if (скрипт != null)
        имя ~= '-' ~ скрипт;
      if (страна != null)
        имя ~= '-' ~ страна;
    }

    return имя;
  }

  if (nameToLcidMap == null) {
    synchronized {
      бцел[] локали;
      if (EnumSystemLocales(локали)) {
        локали.sort;
        foreach (лкид; локали) {
          ткст имя = дайИмяЛокали(лкид);
          if (имя != null) {
            nameToLcidMap[имя] = лкид;
            lcidToNameMap[лкид] = имя;
          }
        }

        nameToLcidMap[""] = LOCALE_INVARIANT;
        lcidToNameMap[LOCALE_INVARIANT] = "";
      }
    }
  }

}

private проц гарантируйМапппингРегиона() {

	бул EnumSystemLocales(out бцел[] локали) {
        static бцел[бцел] времн;

		extern(Windows)
			static бул EnumLocalesProc(шим* lpLocaleString) 
			{
				бцел локаль;
				if (swscanf(lpLocaleString, "%x", &локаль) > 0)
				{
					if (!(локаль in времн))
					{
						времн[локаль] = локаль;
						// Also добавь neutrals.
						бцел яз = локаль & 0x3FF;
						if (!(яз in времн) && (яз != 0x0014 && яз != 0x002C && яз != 0x003B && яз != 0x0043))
							времн[яз] = яз;
					}
					return  true;
				}
				return false;
			}



		if (!EnumLocalesProc ("RU-ru"))
			return false;

		for(бцел н; н <= времн.length; н++)
		{	
			локали ~= времн[н];
		}
		return true;
	}

  if (regionNameToLcidMap == null) {
    synchronized {
      бцел[] локали;
      if (EnumSystemLocales(локали)) {
        foreach (лкид; локали) {
          ткст имя = дайИнфОЛокале(лкид, LOCALE_SISO3166CTRYNAME);
          regionNameToLcidMap[имя] = лкид;
        }
      }
    }
  }
}

 бул найдиКультуруПоИмени(ткст имяКультуры, out ткст действитИмя, out бцел культура) {
  гарантируйМапппингИмени();

  foreach (имя, лкид; nameToLcidMap) {
    if (сравнлюб(имяКультуры, имя) == 0) {
      действитИмя = имя;
      культура = лкид;
      return true;
    }
  }

  return false;
}

 бул найдиКультуруПоИд(бцел культура, out ткст имяКультуры, out бцел действитКультура) {
  if (культура != LOCALE_INVARIANT) {
     гарантируйМапппингИмени();

    if (auto значение = культура in lcidToNameMap)
      return найдиКультуруПоИмени(*значение, имяКультуры, действитКультура);

    return false;
  }

  return найдиКультуруПоИмени("", имяКультуры, действитКультура);
}

 бул найдиКультуруИзИмениРегиона(ткст имяРегиона, out бцел культура) {
  гарантируйМапппингРегиона();

  foreach (имя, лкид; regionNameToLcidMap) {
    if (сравнлюб(имяРегиона, имя) == 0) {
      культура = лкид;
      return true;
    }
  }

  foreach (имя, лкид; nameToLcidMap) {
    if (сравнлюб(имяРегиона, имя) == 0) {
      культура = лкид;
      return true;
    }
  }

  return false;
}

private бул нейтральнаяКультура_ли(бцел культура) {
  return (культура != LOCALE_INVARIANT) && ((культура & 0x3FF) == культура);
}

/**
 * Получает объект, контролирующий форматирование.
 */
interface ИФорматПровайдер {

  /**
   * Gets an object that provides formatting services for the specified тип.
   * Параметры: типФормата = An object that identifies the тип of format to дай.
   * Возвращает: The текущ экземпляр if типФормата is the same тип as the текущ экземпляр; otherwise, null.
   */
  Объект дайФормат(TypeInfo типФормата);

}

/**
 * Provides information about a specific культура (локаль).
 */
class Культура : ИФорматПровайдер {

  private static Культура[ткст] nameCultures_;
  private static Культура[бцел] lcidCultures_;

  private static Культура userDefault_;
  private static Культура userDefaultUI_;
  private static Культура constant_;
  private static Культура current_;
  private static Культура currentUI_;

  private бцел cultureId_;
  private ткст cultureName_;

  /*package*/ бул isReadOnly_;
  /*package*/ бул isInherited_;
  private ткст listSeparator_;

  private Культура parent_;

  private ФорматЧисла numberFormat_;
  private ФорматДатыВремени dateTimeFormat_;
  private Календарь calendar_;
  private ДанныеКалендаря[] calendars_;
  private Коллятор collator_;

  static this() {
    constant_ = new Культура(LOCALE_INVARIANT);
    constant_.isReadOnly_ = true;

    userDefault_ = initUserDefault();
    userDefaultUI_ = initUserDefaultUI();
  }

  static ~this() {
    userDefault_ = null;
    userDefaultUI_ = null;
    constant_ = null;
    current_ = null;
    currentUI_ = null;
    nameCultures_ = null;
    lcidCultures_ = null;
  }

  /** 
   * Initializes a new экземпляр based on the _culture specified by the _culture identifier.
   * Параметры: культура = A predefined Культура identifier.
   */
  this(бцел культура) {
    if ((культура == LOCALE_NEUTRAL ||
      культура == LOCALE_SYSTEM_DEFAULT ||
      культура == LOCALE_USER_DEFAULT) ||
      !найдиКультуруПоИд(культура, cultureName_, cultureId_)) {
      scope буфер = new сим[100];
      цел len = sprintf(буфер.ptr, "Ид Культуры %d (0x%04x) не поддерживаемая культура.", культура, культура);
      throw new ИсклАргумента(cast(ткст)буфер[0 .. len], "культура");
    }

    isInherited_ = (typeid(typeof(this)) != typeid(Культура));
  }

  /**
   * Initializes a new экземпляр based on the культура specified by имя.
   * Параметры: имя = A predefined культура _name.
   */
  this(ткст имя) {
    if (!найдиКультуруПоИмени(имя, cultureName_, cultureId_))
      throw new ИсклАргумента("Культура с именем '" ~ имя ~ "' не поддерживается.", "имя");
    
    isInherited_ = (typeid(typeof(this)) != typeid(Культура));
  }

  /**
   * Gets an object that defines how to format the specified тип.
   * Параметры: типФормата = The тип to дай a formatting object for. Supports ФорматЧисла and ФорматДатыВремени.
   * Возвращает: The значение of the форматЧисла property or the значение of the форматДатыВремени property, depending on типФормата.
   */
  Объект дайФормат(TypeInfo типФормата) {
    if (типФормата == typeid(ФорматЧисла))
      return форматЧисла;
    else if (типФормата == typeid(ФорматДатыВремени))
      return форматДатыВремени;
    return null;
  }

  /**
   * Retrieves a cached, читай-only экземпляр of a _culture используя the specified _culture identifier.
   * Параметры: культура = A _culture identifier.
   * Возвращает: A читай-only Культура object.
   */
  static Культура дай(бцел культура) {
    if (культура <= 0)
      throw new ИсклАргумента("Требуется число больше нуля.", "культура");

    Культура ret = getCultureWorker(культура, null);

    if (ret is null) {
      scope буфер = new сим[100];
      цел len = sprintf(буфер.ptr, "Ид Культуры %d (0x%04x) не поддерживаемая культура.", культура, культура);
      throw new ИсклАргумента(cast(ткст)буфер[0 .. len], "культура");
    }

    return ret;
  }

  /**
   * Retrieves a cached, читай-only экземпляр of a культура используя the specified культура _name.
   * Параметры: имя = The _name of the культура.
   * Возвращает: A читай-only Культура object.
   */
  static Культура дай(ткст имя) {
    Культура ret = getCultureWorker(0, имя);

    if (ret is null)
      throw new ИсклАргумента("Культура с именем '" ~ имя ~ "' не поддерживается.", "имя");

    return ret;
  }

  private static Культура getCultureWorker(бцел лкид, ткст имя) {
    if (имя != null)
      имя = имя.впроп();

    if (лкид == 0) {
      if (auto значение = имя in nameCultures_)
        return *значение;
    }
    else if (лкид > 0) {
      if (auto значение = лкид in lcidCultures_)
        return *значение;
    }

    Культура культура = null;

    try {
      if (лкид == 0)
        культура = new Культура(имя);
      else if (userDefault_ !is null && userDefault_.лкид == лкид)
        культура = userDefault_;
      else
        культура = new Культура(лкид);
    }
    catch (ИсклАргумента) {
      return null;
    }

    культура.isReadOnly_ = true;

    nameCultures_[культура.имя] = культура;
    lcidCultures_[культура.лкид] = культура;

    return культура;
  }

  /**
   * Gets the список of supported cultures filtered by the specified ПТипыКультур parameter.
   * Параметры: типы = A bitwise combination of ПТипыКультур значения.
   * Возвращает: An array of тип Культура.
   */
  static Культура[] дайКультуры(ПТипыКультур типы) {
    бул includeSpecific = (типы & ПТипыКультур.Специфич) != 0;
    бул includeNeutral = (типы & ПТипыКультур.Нейтрал) != 0;

    Культура[] список;

    if (includeNeutral || includeSpecific) {
       if (lcidToNameMap == null)
         гарантируйМапппингИмени();

      foreach (имя; lcidToNameMap.keys.sort) {
        Культура c = new Культура(lcidToNameMap[имя]);
        ПТипыКультур ct = c.типы;

        if ((includeSpecific && c.имя.length > 0 && (ct & ПТипыКультур.Специфич) != 0) ||
          (includeNeutral && ((ct & ПТипыКультур.Нейтрал) != 0 || c.имя.length == 0)))
          список ~= c;
      }
    }

    return список.dup;
  }

  /**
   * Gets the Культура that is культура-independent.
   * Возвращает: The Культура that is культура-independent.
   */
  static Культура константа() {
    return constant_;
  }

  /**
   * Gets or sets the Культура that represents the культура used by the _current thread.
   * Возвращает: The Культура that represents the культура used by the _current thread.
   */
  static проц текущ(Культура значение) {
    if (значение is null)
      throw new ИсклНулевогоАргумента("значение");

    проверьНейтральн(значение);
    SetThreadLocale(значение.лкид);
    current_ = значение;
  }

  /**
   * ditto
   */
  static Культура текущ() {
    if (current_ !is null)
      return current_;

    return userDefault;
  }

  /**
   * Gets or sets the Культура that represents the текущ культура used to look up resources.
   * Возвращает: The Культура that represents the текущ культура used to look up resources.
   */
  static проц текущУИ(Культура значение) {
    if (значение is null)
      throw new ИсклНулевогоАргумента("значение");

    currentUI_ = значение;
  }

  /** 
   * ditto
   */
  static Культура текущУИ() {
    if (currentUI_ !is null)
      return currentUI_;

    return userDefaultUI;
  }

  /**
   * Gets the Культура that represents the _parent культура of the текущ экземпляр.
   * Возвращает: The Культура that represents the _parent культура.
   */
  Культура родитель() {
    if (parent_ is null) {
      try {
        бцел parentCultureLcid = нейтральн_ли ? LOCALE_INVARIANT : cultureId_ & 0x3ff;
        if (parentCultureLcid == LOCALE_INVARIANT)
          parent_ = Культура.константа;
        else
          parent_ = new Культура(parentCultureLcid);
      }
      catch (ИсклАргумента) {
        parent_ = Культура.константа;
      }
    }
    return parent_;
  }

  /**
   * Gets the культура identifier of the текущ экземпляр.
   * Возвращает: The культура identifier.
   */
  бцел лкид() {
    return cultureId_;
  }

  /**
   * Gets the культура _name in the format "&lt;язык&gt;-&lt;region&gt;".
   * Возвращает: The культура _name.
   */
  ткст имя() {
    return cultureName_;
  }

  /**
   * Gets the культура имя in the format "&lt;язык&gt; (&lt;region&gt;)" in the язык of the культура.
   * Возвращает: The культура имя in the язык of the культура.
   */
  ткст нативноеИмя() {
    ткст s = дайИнфОЛокале(cultureId_, LOCALE_SNATIVELANGNAME);
    if (!нейтральн_ли)
      s ~= " (" ~ дайИнфОЛокале(cultureId_, LOCALE_SNATIVECTRYNAME) ~ ")";
    else {
      цел i = s.найдрек("(");
      if (i != -1 && s.найдрек(")") != -1)
        s.length = i - 1;
    }
    return s;
  }

  /**
   * Gets the культура имя in the format "&lt;язык&gt; (&lt;region&gt;)" in English.
   * Возвращает: The культура имя in English.
   */
  ткст англИмя() {
    ткст s = дайИнфОЛокале(cultureId_, LOCALE_SENGLANGUAGE);
    if (!нейтральн_ли)
      s ~= " (" ~ дайИнфОЛокале(cultureId_, LOCALE_SENGCOUNTRY) ~ ")";
    else {
      цел i = s.найдрек("(");
      if (i != -1 && s.найдрек(")") != -1)
        s.length = i - 1;
    }
    return s;
  }

  /**
   * Gets the культура имя in the format "&lt;язык&gt; (&lt;region&gt;)" in the localised version of Windows.
   * Возвращает: The культура имя in the localised version of Windows.
   */
  ткст отображИмя() {
    ткст s = дайИнфОЛокале(cultureId_, LOCALE_SLANGUAGE);
    if (s != null && нейтральн_ли && cultureId_ != LOCALE_INVARIANT) {
      // Remove страна from neutral cultures.
      цел i = s.найдрек("(");
      if (i != -1 && s.найдрек(")") != -1)
        s.length = i - 1;
    }

    if (s != null && !нейтральн_ли && cultureId_ != LOCALE_INVARIANT) {
      // Add страна to specific cultures.
      if (s.найди("(") == -1 && s.найди(")") == -1)
        s ~= " (" ~ дайИнфОЛокале(cultureId_, LOCALE_SCOUNTRY) ~ ")";
    }

    if (s != null)
      return s;
    return нативноеИмя;
  }

  /**
   * Gets or sets the ткст that separates items in a список.
   * Параметры: значение = The ткст that separates items in a список.
   */
  проц разделительСписка(ткст значение) {
    проверьТолькоЧтен();

    listSeparator_ = значение;
  }

  /// ditto
  ткст разделительСписка() {
    if (listSeparator_ == null)
      listSeparator_ = дайИнфОЛокале(cultureId_, LOCALE_SLIST);
    return listSeparator_;
  }

  /**
   * Gets a значение indictating whether the текущ экземпляр represents a neutral культура.
   * Возвращает: true if the текущ экземпляр represents a neutral культура; otherwise, false.
   */
  бул нейтральн_ли() {
    return нейтральнаяКультура_ли(cultureId_);
  }

  /**
   * Gets a значение indicating whether the текущ экземпляр is читай-only.
   * Возвращает: true if the текущ экземпляр is читай-only; otherwise, false.
   */
  final бул толькоЧтен_ли() {
    return isReadOnly_;
  }

  /**
   * Gets the культура _types that pertain to the текущ экземпляр.
   * Возвращает: A bitwise combination of ПТипыКультур значения.
   */
  ПТипыКультур типы() {
    ПТипыКультур ret = cast(ПТипыКультур)0;
    if (нейтральн_ли)
      ret |= ПТипыКультур.Нейтрал;
    else
      ret |= ПТипыКультур.Специфич;
    return ret;
  }

  /**
   * $(I Property.) Gets or sets a ФорматЧисла that defines the culturally appropriate format of displaying numbers and currency.
   */
  проц форматЧисла(ФорматЧисла значение) {
    проверьТолькоЧтен();

    if (значение is null)
      throw new ИсклНулевогоАргумента("значение");

    numberFormat_ = значение;
  }
  /// ditto
  ФорматЧисла форматЧисла() {
    if (numberFormat_ is null) {
      проверьНейтральн(this);

      numberFormat_ = new ФорматЧисла(cultureId_);
      numberFormat_.isReadOnly_ = isReadOnly_;
    }
    return numberFormat_;
  }

  /**
   *$(I Property.) Gets or sets a ФорматДатыВремени that defines the culturally appropriate format of displaying dates and times.
   */
  проц форматДатыВремени(ФорматДатыВремени значение) {
    проверьТолькоЧтен();

    if (значение is null)
      throw new ИсклНулевогоАргумента("значение");

    dateTimeFormat_ = значение;
  }
  /// ditto
  ФорматДатыВремени форматДатыВремени() {
    if (dateTimeFormat_ is null) {
      проверьНейтральн(this);

      dateTimeFormat_ = new ФорматДатыВремени(cultureId_, календарь);
      dateTimeFormat_.isReadOnly_ = isReadOnly_;
    }
    return dateTimeFormat_;
  }

  /**
   * Gets the default _calendar used by the культура.
   * Возвращает: A Календарь that represents the default _calendar used by a культура.
   */
  Календарь календарь() {
    if (calendar_ is null) {
      calendar_ = дайКалендарь(дайИнфОЛокалеИ(cultureId_, LOCALE_ICALENDARTYPE));
      calendar_.isReadOnly_ = isReadOnly_;
    }
    return calendar_;
  }

  Календарь[] опцКалендари() {
    static цел[] времн;

    extern(Windows)
    static цел EnumCalendarInfoProc(шим* lpCalendarInfoString, бцел Календарь) {
      времн ~= Календарь;
      return 1;
    }

    времн = null;
    if (!EnumCalendarInfoEx(&EnumCalendarInfoProc, cultureId_, ENUM_ALL_CALENDARS, CAL_ICALINTVALUE))
      return null;

    auto cals = new Календарь[времн.length];
    for (цел i = 0; i < cals.length; i++)
      cals[i] = дайКалендарь(времн[i]);
    return cals;
  }

  /**
   * Gets the Коллятор that defines how to сравни strings for the культура.
   * Возвращает: The Коллятор that defines how to сравни strings for the культура.
   */
  Коллятор коллятор() {
    if (collator_ is null)
      collator_ = Коллятор.дай(cultureId_);
    return collator_;
  }

  /**
   * Returns a ткст containing the имя of the текущ экземпляр.
   * Возвращает: A ткст containing the имя of the текущ экземпляр.
   */
  override ткст вТкст() {
    return cultureName_;
  }

  private static проц проверьНейтральн(Культура культура) {
    if (культура.нейтральн_ли)
      throw new ИсклНеПоддерживается("Культура '" ~ культура.имя ~ "' является нейтральной и не может использоваться при форматировании.");
  }

  private проц проверьТолькоЧтен() {
    if (isReadOnly_)
      throw new ИсклНеправильнОперации("Экземпляр только для чтения.");
  }

  private static Календарь дайКалендарь(цел идКалендаря) {
    // We only implement calendars that Windows supports.
    switch (идКалендаря) {
      case CAL_GREGORIAN,
        CAL_GREGORIAN_US, 
        CAL_GREGORIAN_ME_FRENCH, 
        CAL_GREGORIAN_ARABIC, 
        CAL_GREGORIAN_XLIT_ENGLISH, 
        CAL_GREGORIAN_XLIT_FRENCH:
        return new ГрегорианскийКалендарь(cast(GregorianCalendarType)идКалендаря);
      case CAL_JAPAN:
        return new ЯпонскийКалендарь;
      case CAL_TAIWAN:
        return new ТайваньскийКалендарь;
      case CAL_KOREA:
        return new КорейскийКалендарь;
      /*case CAL_HIJRI:
        return new HijriCalendar;*/
      case CAL_THAI:
        return new ТаиБуддистскийКалендарь;
      /*case CAL_HEBREW:
        return new HebrewCalendar;
      case CAL_UMALQURA:
        return new UmAlQuraCalendar;*/
      default:
    }
    return new ГрегорианскийКалендарь;
  }

  private ДанныеКалендаря данныеКалендаря(цел идКалендаря) {
    // A культура might use many calendars.
    if (calendars_.length == 0)
      calendars_.length = /*CAL_UMALQURA*/ 23;

    auto данныеКалендаря = calendars_[идКалендаря - 1];
    if (данныеКалендаря is null)
      данныеКалендаря = calendars_[идКалендаря - 1] = new ДанныеКалендаря(cultureName_, идКалендаря);
    return данныеКалендаря;
  }

  private static Культура initUserDefault() {
    Культура культура = null;

    try {
      культура = new Культура(GetUserDefaultLCID());
    }
    catch (ИсклАргумента) {
    }

    if (культура is null)
      return Культура.константа;

    культура.isReadOnly_ = true;
    return культура;
  }

  private static Культура initUserDefaultUI() {
    бцел лкид = GetUserDefaultLangID();
    if (лкид == Культура.userDefault.лкид)
      return Культура.userDefault;

    Культура культура = null;

    try {
      культура = new Культура(GetSystemDefaultLangID());
    }
    catch (ИсклАргумента) {
    }

    if (культура is null)
      return Культура.константа;

    культура.isReadOnly_ = true;
    return культура;
  }

  private static Культура userDefault() {
    if (userDefault_ is null)
      userDefault_ = initUserDefault();
    return userDefault_;
  }

  private static Культура userDefaultUI() {
    if (userDefaultUI_ is null)
      userDefaultUI_ = initUserDefaultUI();
    return userDefaultUI_;
  }

}

/**
 *Определяет форматирование и отображение числовых значений.
 */
class ФорматЧисла : ИФорматПровайдер {

  private static ФорматЧисла constant_;
  private static ФорматЧисла current_;

  /*package*/ бул isReadOnly_;

  private цел[] numberGroupSizes_;
  private цел[] currencyGroupSizes_;
  private ткст positiveSign_;
  private ткст negativeSign_;
  private ткст numberDecimalSeparator_;
  private ткст currencyDecimalSeparator_;
  private ткст numberGroupSeparator_;
  private ткст currencyGroupSeparator_;
  private ткст currencySymbol_;
  private ткст nanSymbol_;
  private ткст positiveInfinitySymbol_;
  private ткст negativeInfinitySymbol_;
  private цел numberDecimalDigits_;
  private цел currencyDecimalDigits_;
  private цел currencyPositivePattern_;
  private цел numberNegativePattern_;
  private цел currencyNegativePattern_;

  static ~this() {
    constant_ = null;
    current_ = null;
  }

  /**
   * Initializes a new экземпляр.
   */
  this() {
    this(LOCALE_INVARIANT);
  }

  /**
   */
  Объект дайФормат(TypeInfo типФормата) {
    if (типФормата == typeid(ФорматЧисла))
      return this;
    return null;
  }

  /**
   */
  static ФорматЧисла дай(ИФорматПровайдер провайдер) {
    if (auto культура = cast(Культура)провайдер) {
      if (!культура.isInherited_) {
        if (auto значение = культура.numberFormat_)
          return значение;
        return культура.форматЧисла;
      }
    }

    if (auto значение = cast(ФорматЧисла)провайдер)
      return значение;

    if (провайдер !is null) {
      if (auto значение = cast(ФорматЧисла)провайдер.дайФормат(typeid(ФорматЧисла)))
        return значение;
    }

    return текущ;
  }

  /**
   */
  static ФорматЧисла константа() {
    if (constant_ is null) {
      constant_ = new ФорматЧисла;
      constant_.isReadOnly_ = true;
    }
    return constant_;
  }

  /**
   */
  static ФорматЧисла текущ() {
    Культура культура = Культура.текущ;
    if (!культура.isInherited_) {
      if (auto рез = культура.numberFormat_)
        return рез;
    }
    return cast(ФорматЧисла)культура.дайФормат(typeid(ФорматЧисла));
  }

  /**
   */
  проц размерыГруппыЧисла(цел[] значение) {
    проверьТолькоЧтен();
    numberGroupSizes_ = значение;
  }

  /**
   * ditto
   */
  цел[] размерыГруппыЧисла() {
    return numberGroupSizes_;
  }

  /**
   */
  проц размерыГруппыВалюта(цел[] значение) {
    проверьТолькоЧтен();
    currencyGroupSizes_ = значение;
  }

  /**
   * ditto
   */
  цел[] размерыГруппыВалюта() {
    return currencyGroupSizes_;
  }

  /**
   */
  проц положитЗнак(ткст значение) {
    проверьТолькоЧтен();
    positiveSign_ = значение;
  }

  /**
   * ditto
   */
  ткст положитЗнак() {
    return positiveSign_;
  }

  /**
   */
  проц отрицатЗнак(ткст значение) {
    проверьТолькоЧтен();
    negativeSign_ = значение;
  }

  /**
   * ditto
   */
  ткст отрицатЗнак() {
    return negativeSign_;
  }

  /**
   */
  проц разделительДесятичнЧисла(ткст значение) {
    проверьТолькоЧтен();
    numberDecimalSeparator_ = значение;
  }

  /**
   * ditto
   */
  ткст разделительДесятичнЧисла() {
    return numberDecimalSeparator_;
  }

  /**
   */
  проц разделительДесятичнВалют(ткст значение) {
    проверьТолькоЧтен();
    currencyDecimalSeparator_ = значение;
  }

  /**
   * ditto
   */
  ткст разделительДесятичнВалют() {
    return currencyDecimalSeparator_;
  }

  /**
   */
  проц разделительГруппыЧисел(ткст значение) {
    проверьТолькоЧтен();
    numberGroupSeparator_ = значение;
  }

  /**
   * ditto
   */
  ткст разделительГруппыЧисел() {
    return numberGroupSeparator_;
  }

  /**
   */
  проц разделительГруппыВалют(ткст значение) {
    проверьТолькоЧтен();
    currencyGroupSeparator_ = значение;
  }

  /**
   * ditto
   */
  ткст разделительГруппыВалют() {
    return currencyGroupSeparator_;
  }

  /**
   */
  проц символВалюты(ткст значение) {
    проверьТолькоЧтен();
    currencySymbol_ = значение;
  }

  /**
   * ditto
   */
  ткст символВалюты() {
    return currencySymbol_;
  }

  /**
   */
  проц символНЧ(ткст значение) {
    проверьТолькоЧтен();
    nanSymbol_ = значение;
  }

  /**
   * ditto
   */
  ткст символНЧ() {
    return nanSymbol_;
  }

  /**
   */
  проц символПоложитБеск(ткст значение) {
    проверьТолькоЧтен();
    positiveInfinitySymbol_ = значение;
  }

  /**
   * ditto
   */
  ткст символПоложитБеск() {
    return positiveInfinitySymbol_;
  }

  /**
   */
  проц символОтрицатБеск(ткст значение) {
    проверьТолькоЧтен();
    negativeInfinitySymbol_ = значение;
  }

  /**
   * ditto
   */
  ткст символОтрицатБеск() {
    return negativeInfinitySymbol_;
  }

  /**
   */
  проц члоДесятичнЦифр(цел значение) {
    проверьТолькоЧтен();
    numberDecimalDigits_ = значение;
  }

  /**
   * ditto
   */
  цел члоДесятичнЦифр() {
    return numberDecimalDigits_;
  }

  /**
   */
  проц десятичнЦифрыВалюты(цел значение) {
    проверьТолькоЧтен();
    currencyDecimalDigits_ = значение;
  }

  /**
   * ditto
   */
  цел десятичнЦифрыВалюты() {
    return currencyDecimalDigits_;
  }

  /**
   */
  проц положитОбразецВалюты(цел значение) {
    проверьТолькоЧтен();
    currencyPositivePattern_ = значение;
  }

  /**
   * ditto
   */
  цел положитОбразецВалюты() {
    return currencyPositivePattern_;
  }

  /**
   */
  проц отрицатОбразецВалюты(цел значение) {
    проверьТолькоЧтен();
    currencyNegativePattern_ = значение;
  }

  /**
   * ditto
   */
  цел отрицатОбразецВалюты() {
    return currencyNegativePattern_;
  }

  /**
   */
  проц образецОтрицатЧисла(цел значение) {
    проверьТолькоЧтен();
    numberNegativePattern_ = значение;
  }

  /**
   * ditto
   */
  цел образецОтрицатЧисла() {
    return numberNegativePattern_;
  }

  /*package*/ this(бцел культура) {

    цел[] преобразуйТкстГруппы(ткст s) {
      // eg 3;2;0
      if (s.length == 0 || s[0] == '0')
        return [ 3 ];
      цел[] group;
      if (s[$ - 1] == '0')
        group = new цел[s.length / 2];
      else {
        group = new цел[(s.length / 2) + 2];
        group[$ - 1] = 0;
      }
      цел n;
      for (цел i = 0; i < s.length && i < group.length; i++) {
        if (s[n] < '1' || s[n] > '9')
          return [ 3 ];
        group[i] = s[n] - '0';
        // skip ';'
        n += 2;
      }
      return group;
    }

    numberGroupSizes_ = [ 3 ];
    currencyGroupSizes_ = [ 3 ];
    positiveSign_ = "+";
    negativeSign_ = "-";
    numberDecimalSeparator_ = ".";
    currencyDecimalSeparator_ = ".";
    numberGroupSeparator_ = ",";
    currencyGroupSeparator_ = ",";
    currencySymbol_ = "\u00a4";
    nanSymbol_ = "NaN";
    positiveInfinitySymbol_ = "Infinity";
    negativeInfinitySymbol_ = "-Infinity";
    numberDecimalDigits_ = 2;
    currencyDecimalDigits_ = 2;
    numberNegativePattern_ = 1;

    if (культура != LOCALE_INVARIANT) {
      numberGroupSizes_ = преобразуйТкстГруппы(дайИнфОЛокале(культура, LOCALE_SGROUPING));
      currencyGroupSizes_ = преобразуйТкстГруппы(дайИнфОЛокале(культура, LOCALE_SMONGROUPING));
      negativeSign_ = дайИнфОЛокале(культура, LOCALE_SNEGATIVESIGN);
      numberDecimalSeparator_ = дайИнфОЛокале(культура, LOCALE_SDECIMAL);
      currencyDecimalSeparator_ = дайИнфОЛокале(культура, LOCALE_SMONDECIMALSEP);
      numberGroupSeparator_ = дайИнфОЛокале(культура, LOCALE_STHOUSAND);
      currencyGroupSeparator_ = дайИнфОЛокале(культура, LOCALE_SMONTHOUSANDSEP);
      currencySymbol_ = дайИнфОЛокале(культура, LOCALE_SCURRENCY);
      nanSymbol_ = дайИнфОЛокале(культура, LOCALE_SNAN);
      positiveInfinitySymbol_ = дайИнфОЛокале(культура, LOCALE_SPOSINFINITY);
      negativeInfinitySymbol_ = дайИнфОЛокале(культура, LOCALE_SNEGINFINITY);
      numberDecimalDigits_ = дайИнфОЛокалеИ(культура, LOCALE_IDIGITS);
      currencyDecimalDigits_ = дайИнфОЛокалеИ(культура, LOCALE_ICURRDIGITS);
      currencyPositivePattern_ = дайИнфОЛокалеИ(культура, LOCALE_ICURRENCY);
      currencyNegativePattern_ = дайИнфОЛокалеИ(культура, LOCALE_INEGCURR);
      numberNegativePattern_ = дайИнфОЛокалеИ(культура, LOCALE_INEGNUMBER);

      if (positiveSign_ == null)
        positiveSign_ = "+";

      // The following will be null on XP and earlier.
      if (nanSymbol_ == null)
        nanSymbol_ = "NaN";
      if (positiveInfinitySymbol_ == null)
        positiveInfinitySymbol_ = "Infinity";
      if (negativeInfinitySymbol_ == null)
        negativeInfinitySymbol_ = "-Infinity";
    }
  }

  private проц проверьТолькоЧтен() {
    if (isReadOnly_)
      throw new ИсклНеправильнОперации("Этот экземпляр только для чтения.");
  }

}

/*package*/ const сим[] всеСтандартныеФорматы = [ 'd', 'D', 'f', 'F', 'g', 'G', 'r', 'R', 's', 't', 'T', 'u', 'U', 'y', 'Y' ];

/**
 * Defines how dates and times are formatted and displayed.
 */
class ФорматДатыВремени : ИФорматПровайдер {

  private static const ткст RFC1123_PATTERN = "ddd, dd MMM yyyy HH':'mm':'ss 'GMT'";
  private static const ткст SORTABLE_DATETIME_PATTERN = "yyyy'-'MM'-'dd'T'HH':'mm':'ss";
  private static const ткст UNIVERSAL_SORTABLE_DATETIME_PATTERN = "yyyy'-'MM'-'dd HH':'mm':'ss'Z'";

  private static ФорматДатыВремени constant_;
  private static ФорматДатыВремени current_;

  private бцел cultureId_;
  private Календарь calendar_;
  private бул isDefaultCalendar_;
  private цел[] optionalCalendars_;
  private ткст amDesignator_;
  private ткст pmDesignator_;
  private ткст dateSeparator_;
  private ткст timeSeparator_;
  private цел firstDayOfWeek_ = -1;
  private цел calendarWeekRule_ = -1;
  private ткст[] dayNames_;
  private ткст[] abbrevDayNames_;
  private ткст[] monthNames_;
  private ткст[] abbrevMonthNames_;
  private ткст[] eraNames_;
  private ткст shortDatePattern_;
  private ткст longDatePattern_;
  private ткст shortTimePattern_;
  private ткст longTimePattern_;
  private ткст yearMonthPattern_;
  private ткст fullDateTimePattern_;
  private ткст[] allShortDatePatterns_;
  private ткст[] allShortTimePatterns_;
  private ткст[] allLongDatePatterns_;
  private ткст[] allLongTimePatterns_;
  private ткст[] allYearMonthPatterns_;
  private ткст generalShortTimePattern_;
  private ткст generalLongTimePattern_;

  /*package*/ бул isReadOnly_;

  static ~this() {
    constant_ = null;
    current_ = null;
  }

  /**
   * Initializes a new экземпляр.
   */
  this() {
    cultureId_ = LOCALE_INVARIANT;
    isDefaultCalendar_ = true;
    calendar_ = ГрегорианскийКалендарь.defaultInstance;

    //initializeProperties();
  }

  /**
   */
  Объект дайФормат(TypeInfo типФормата) {
    if (типФормата == typeid(ФорматДатыВремени))
      return this;
    return null;
  }

  /**
   */
  static ФорматДатыВремени дай(ИФорматПровайдер провайдер) {
    if (auto культура = cast(Культура)провайдер) {
      return культура.форматДатыВремени;
    }

    if (auto значение = cast(ФорматДатыВремени)провайдер)
      return значение;

    if (провайдер !is null) {
      if (auto значение = cast(ФорматДатыВремени)провайдер.дайФормат(typeid(ФорматДатыВремени)))
        return значение;
    }

    return текущ;
  }

  /**
   */
  final ткст дайСокрИмяДня(ПДеньНедели деньНедели) {
    return дайСокрИменаДней()[деньНедели];
  }

  /**
   */
  final ткст дайИмяДня(ПДеньНедели деньНедели) {
    return дайИменаДней()[деньНедели];
  }

  /**
   */
  final ткст дайИмяМесяца(цел месяц) {
    return дайИменаМесяцев()[месяц - 1];
  }

  /**
   */
  final ткст дайСокрИмяМесяца(цел месяц) {
    return дайСокрИменаМесяцев()[месяц - 1];
  }

  /**
   */
  final ткст дайИмяЭры(цел эра) {
    if (эра == 0)
      эра = Культура.дай(cultureId_).данныеКалендаря(календарь.внутреннийИд).текущЭра;

    if (--эра >= дайИменаЭр().length)
      throw new ИсклАргументВнеОхвата("эра");

    return eraNames_[эра];
  }

  /**
   */
  final ткст[] дайВсеОбразцыДатыВремени() {
    ткст[] ret;
    foreach (format; всеСтандартныеФорматы)
      ret ~= дайВсеОбразцыДатыВремени(format);
    return ret;
  }

  /**
   */
  final ткст[] дайВсеОбразцыДатыВремени(сим format) {

    ткст[] комбинируйОбразцы(ткст[] patterns1, ткст[] patterns2) {
      ткст[] рез = new ткст[patterns1.length * patterns2.length];
      for (цел i = 0; i < patterns1.length; i++) {
        for (цел j = 0; j < patterns2.length; j++)
          рез[i * patterns2.length + j] = patterns1[i] ~ " " ~ patterns2[j];
      }
      return рез;
    }

    ткст[] ret;

    switch (format) {
      case 'd':
        ret ~= всеОбразцыКраткихДат;
        break;
      case 'D':
        ret ~= всеОбразцыДлинныхДат;
        break;
      case 'f':
       ret ~= комбинируйОбразцы(всеОбразцыДлинныхДат, всеОбразцыКраткогоВремени);
        break;
      case 'F':
       ret ~= комбинируйОбразцы(всеОбразцыДлинныхДат, всеОбразцыДлинногоВремени);
       break;
      case 'g':
       ret ~= комбинируйОбразцы(всеОбразцыКраткихДат, всеОбразцыКраткогоВремени);
        break;
      case 'G':
       ret ~= комбинируйОбразцы(всеОбразцыКраткихДат, всеОбразцыДлинногоВремени);
        break;
      case 'r', 'R':
        ret ~= RFC1123_PATTERN;
        break;
      case 's':
        ret ~= SORTABLE_DATETIME_PATTERN;
        break;
      case 't':
        ret ~= всеОбразцыКраткогоВремени;
        break;
     case 'T':
       ret ~= всеОбразцыДлинногоВремени;
        break;
      case 'u':
        ret ~= UNIVERSAL_SORTABLE_DATETIME_PATTERN;
        break;
      case 'U':
       ret ~= комбинируйОбразцы(всеОбразцыДлинныхДат, всеОбразцыДлинногоВремени);
        break;
      case 'y', 'Y':
        ret ~= всеОбразцыМесяцаГода;
        break;
      default:
        throw new ИсклАргумента("Указанный формат не подходит.", "format");
    }

    return ret;
  }

  /**
   */
  static ФорматДатыВремени константа() {
    if (constant_ is null) {
      constant_ = new ФорматДатыВремени;
      constant_.календарь.isReadOnly_ = true;
      constant_.isReadOnly_ = true;
    }
    return constant_;
  }

  /**
   */
  static ФорматДатыВремени текущ() {
    Культура культура = Культура.текущ;
    if (auto значение = культура.dateTimeFormat_)
      return значение;
    return cast(ФорматДатыВремени)культура.дайФормат(typeid(ФорматДатыВремени));
  }

  /**
   */
  final проц календарь(Календарь значение) {
    if (значение !is calendar_) {
      for (auto i = 0; i < опцКалендари.length; i++) {
        if (опцКалендари[i] == значение.внутреннийИд) {
          isDefaultCalendar_ = (значение.внутреннийИд == CAL_GREGORIAN);

          if (calendar_ !is null) {
            // Clear текущ значения.
            eraNames_ = null;
            abbrevDayNames_ = null;
            dayNames_ = null;
            abbrevMonthNames_ = null;
            monthNames_ = null;
            shortDatePattern_ = null;
            longDatePattern_ = null;
            yearMonthPattern_ = null;
            fullDateTimePattern_ = null;
            allShortDatePatterns_ = null;
            allLongDatePatterns_ = null;
            allYearMonthPatterns_ = null;
            generalShortTimePattern_ = null;
            generalLongTimePattern_ = null;
            dateSeparator_ = null;
          }

          calendar_ = значение;
          //initializeProperties();

          return;
        }
      }
      throw new ИсклАргумента("Недействительный календарь для указанной культуры.", "значение");
    }
  }

  /**
   * ditto
   */
  final Календарь календарь() {
    return calendar_;
  }

  /**
   */
  final проц amDesignator(ткст значение) {
    проверьТолькоЧтен();
    amDesignator_ = значение;
  }

  /**
   * ditto
   */
  final ткст amDesignator() {
    if (amDesignator_ == null)
      amDesignator_ = дайИнфОЛокале(cultureId_, LOCALE_S1159);
    return amDesignator_;
  }

  /**
   */
  final проц pmDesignator(ткст значение) {
    проверьТолькоЧтен();
    pmDesignator_ = значение;
  }

  /**
   * ditto
   */
  final ткст pmDesignator() {
    if (pmDesignator_ == null)
      pmDesignator_ = дайИнфОЛокале(cultureId_, LOCALE_S2359);
    return pmDesignator_;
  }

  /**
   */
  final проц разделительДаты(ткст значение) {
    проверьТолькоЧтен();
    dateSeparator_ = значение;
  }

  /**
   * ditto
   */
  final ткст разделительДаты() {
    if (dateSeparator_ == null)
      dateSeparator_ = дайИнфОЛокале(cultureId_, LOCALE_SDATE);
    return dateSeparator_;
  }

  /**
   */
  final проц разделительВремени(ткст значение) {
    проверьТолькоЧтен();
    timeSeparator_ = значение;
  }

  /**
   * ditto
   */
  final ткст разделительВремени() {
    if (timeSeparator_ == null)
      timeSeparator_ = дайИнфОЛокале(cultureId_, LOCALE_STIME);
    return timeSeparator_;
  }

  /**
   */
  final проц первыйДеньНедели(ПДеньНедели значение) {
    проверьТолькоЧтен();
    firstDayOfWeek_ = cast(цел)значение;
  }
  /**
   * ditto
   */
  final ПДеньНедели первыйДеньНедели() {
    if (firstDayOfWeek_ == -1) {
      firstDayOfWeek_ = дайИнфОЛокалеИ(cultureId_, LOCALE_IFIRSTDAYOFWEEK);
      // 0 = Понедельник, 1 = Вторник ... 6 = Воскресенье
      if (firstDayOfWeek_ < 6)
        firstDayOfWeek_++;
      else
        firstDayOfWeek_ = 0;
    }
    return cast(ПДеньНедели)firstDayOfWeek_;
  }

  /**
   */
  final проц правилоКалендарнойНедели(ППравилоКалендарнойНедели значение) {
    проверьТолькоЧтен();
    calendarWeekRule_ = cast(цел)значение;
  }
  /**
   * ditto
   */
  final ППравилоКалендарнойНедели правилоКалендарнойНедели() {
    if (calendarWeekRule_ == -1)
      calendarWeekRule_ = дайИнфОЛокалеИ(cultureId_, LOCALE_IFIRSTWEEKOFYEAR);
    return cast(ППравилоКалендарнойНедели)calendarWeekRule_;
  }

  /**
   */
  final ткст rfc1123Pattern() {
    return RFC1123_PATTERN;
  }

  /**
   */
  final ткст sortableDateTimePattern() {
    return SORTABLE_DATETIME_PATTERN;
  }

  /**
   */
  final ткст universalSortableDateTimePattern() {
    return UNIVERSAL_SORTABLE_DATETIME_PATTERN;
  }

  /**
   */
  final проц shortDatePattern(ткст значение) {
    проверьТолькоЧтен();
    shortDatePattern_ = значение;
    generalShortTimePattern_ = null;
    generalLongTimePattern_ = null;
  }

  /**
   * ditto
   */
  final ткст shortDatePattern() {
    if (shortDatePattern_ == null)
      shortDatePattern_ = дайОбразецКраткихДат(calendar_.внутреннийИд);
    return shortDatePattern_;
  }

  /**
   */
  final проц longDatePattern(ткст значение) {
    проверьТолькоЧтен();
    longDatePattern_ = значение;
    fullDateTimePattern_ = null;
  }

  /**
   * ditto
   */
  final ткст longDatePattern() {
    if (longDatePattern_ == null)
      longDatePattern_ = getLongDatePattern(calendar_.внутреннийИд);
    return longDatePattern_;
  }

  /**
   */
  final проц образецКраткогоВремени(ткст значение) {
    проверьТолькоЧтен();
    shortTimePattern_ = значение;
    generalShortTimePattern_ = null;
  }

  /**
   * ditto
   */
  final ткст образецКраткогоВремени() {
    if (shortTimePattern_ == null)
      shortTimePattern_ = дайКраткоеВремя(cultureId_);
    return shortTimePattern_;
  }

  /**
   */
  final проц образецДлинногоВремени(ткст значение) {
    проверьТолькоЧтен();
    longTimePattern_ = значение;
    fullDateTimePattern_ = null;
    generalLongTimePattern_ = null;
  }

  /**
   * ditto
   */
  final ткст образецДлинногоВремени() {
    if (longTimePattern_ == null)
      longTimePattern_ = дайИнфОЛокале(cultureId_, LOCALE_STIMEFORMAT);
    return longTimePattern_;
  }

  /**
   */
  final проц образецМесяцаГода(ткст значение) {
    проверьТолькоЧтен();
    yearMonthPattern_ = значение;
  }

  /**
   * ditto
   */
  final ткст образецМесяцаГода() {
    if (yearMonthPattern_ == null)
      yearMonthPattern_ = дайИнфОЛокале(cultureId_, LOCALE_SYEARMONTH);
    return yearMonthPattern_;
  }

  /**
   */
  final ткст полныйОбразецДатыВремени() {
    if (fullDateTimePattern_ == null)
      fullDateTimePattern_ = longDatePattern ~ " " ~ образецДлинногоВремени;
    return fullDateTimePattern_;
  }

  /*package*/ ткст общийОбразецКраткогоВремени() {
    if (generalShortTimePattern_ == null)
      generalShortTimePattern_ = shortDatePattern ~ " " ~ образецКраткогоВремени;
    return generalShortTimePattern_;
  }

  /*package*/ ткст общийОбразецДлинногоВремени() {
    if (generalLongTimePattern_ == null)
      generalLongTimePattern_ = shortDatePattern ~ " " ~ образецДлинногоВремени;
    return generalLongTimePattern_;
  }

  /**
   */
  final проц именаДней(ткст[] значение) {
    проверьТолькоЧтен();
    dayNames_ = значение;
  }

  /**
   * ditto
   */
  final ткст[] именаДней() {
    return дайИменаДней().dup;
  }

  /**
   */
  final проц сокрИменаДней(ткст[] значение) {
    проверьТолькоЧтен();
    abbrevDayNames_ = значение;
  }

  /**
   * ditto
   */
  final ткст[] сокрИменаДней() {
    return дайСокрИменаДней().dup;
  }

  /**
   */
  final проц именаМесяцев(ткст[] значение) {
    проверьТолькоЧтен();
    monthNames_ = значение;
  }

  /**
   * ditto
   */
  final ткст[] именаМесяцев() {
    return дайИменаМесяцев().dup;
  }

  /**
   */
  final проц сокрИменаМесяцев(ткст[] значение) {
    проверьТолькоЧтен();
    abbrevMonthNames_ = значение;
  }

  final ткст[] сокрИменаМесяцев() {
    return дайСокрИменаМесяцев().dup;
  }

  /*package*/ this(бцел культура, Календарь cal) {
    cultureId_ = культура;
    календарь = cal;
  }

  private проц проверьТолькоЧтен() {
    if (isReadOnly_)
      throw new ИсклНеправильнОперации("Экземпляр только для чтения.");
  }

  /*private проц initializeProperties() {
    amDesignator_ = дайИнфОЛокале(cultureId_, LOCALE_S1159);
    pmDesignator_ = дайИнфОЛокале(cultureId_, LOCALE_S2359);

    firstDayOfWeek_ = дайИнфОЛокалеИ(cultureId_, LOCALE_IFIRSTDAYOFWEEK);
    // 0 = Понедельник, 1 = Вторник ... 6 = Воскресенье
    if (firstDayOfWeek_ < 6)
      firstDayOfWeek_++;
    else
      firstDayOfWeek_ = 0;

    calendarWeekRule_ = дайИнфОЛокалеИ(cultureId_, LOCALE_IFIRSTWEEKOFYEAR);

    shortDatePattern_ = дайОбразецКраткихДат(calendar_.внутреннийИд);
    longDatePattern_ = getLongDatePattern(calendar_.внутреннийИд);
    longTimePattern_ = дайИнфОЛокале(cultureId_, LOCALE_STIMEFORMAT);
    yearMonthPattern_ = дайИнфОЛокале(cultureId_, LOCALE_SYEARMONTH);
  }*/

  private ткст[] всеОбразцыКраткихДат() {
    if (allShortDatePatterns_ == null) {
      if (!isDefaultCalendar_)
        allShortDatePatterns_ = [ дайОбразецКраткихДат(calendar_.внутреннийИд) ];
      if (allShortDatePatterns_ == null)
        allShortDatePatterns_ = дайКраткиеДаты(cultureId_, calendar_.внутреннийИд);
    }
    return allShortDatePatterns_.dup;
  }

  private ткст[] всеОбразцыДлинныхДат() {
    if (allLongDatePatterns_ == null) {
      if (!isDefaultCalendar_)
        allLongDatePatterns_ = [ getLongDatePattern(calendar_.внутреннийИд) ];
      if (allLongDatePatterns_ == null)
        allLongDatePatterns_ = getLongDates(cultureId_, calendar_.внутреннийИд);
    }
    return allLongDatePatterns_.dup;
  }

  private ткст[] всеОбразцыКраткогоВремени() {
    if (allShortTimePatterns_ == null)
      allShortTimePatterns_ = дайКраткиеВремена(cultureId_);
    return allShortTimePatterns_.dup;
  }

  private ткст[] всеОбразцыДлинногоВремени() {
    if (allLongTimePatterns_ == null)
      allLongTimePatterns_ = дайДлинныеВремена(cultureId_);
    return allLongTimePatterns_.dup;
  }

  private ткст[] всеОбразцыМесяцаГода() {
    if (allYearMonthPatterns_ == null) {
      if (!isDefaultCalendar_)
        allYearMonthPatterns_ = [ дайИнфОКалендаре(cultureId_, calendar_.внутреннийИд, CAL_SYEARMONTH) ];
      if (allYearMonthPatterns_ == null)
        allYearMonthPatterns_ = [ дайИнфОЛокале(cultureId_, LOCALE_SYEARMONTH) ];
    }
    return allYearMonthPatterns_.dup;
  }

  private static бул перечислиФорматыДат(бцел культура, бцел календарь, бцел флаги, out ткст[] форматы) {
    static ткст[] времн;
    static бцел cal;

    extern(Windows)
    static цел EnumDateFormatsProc(шим* lpDateFormatString, бцел CalendarID) {
      if (cal == CalendarID)
        времн ~= вЮ8(lpDateFormatString[0 .. wcslen(lpDateFormatString)]);
      return true;
    }

    времн = null;
    cal = календарь;
    if (!EnumDateFormatsEx(&EnumDateFormatsProc, культура, флаги))
      return false;

    форматы = времн.dup;
    return true;
  }

  private static ткст[] дайКраткиеДаты(бцел культура, бцел календарь) {
    ткст[] форматы;
    synchronized {
      if (!перечислиФорматыДат(культура, календарь, DATE_SHORTDATE, форматы))
        return null;
    }
    if (форматы == null)
      форматы = [ дайИнфОКалендаре(культура, календарь, CAL_SSHORTDATE) ];
    return форматы;
  }

  private ткст дайОбразецКраткихДат(бцел cal) {
    if (!isDefaultCalendar_)
      return дайКраткиеДаты(cultureId_, cal)[0];
    return дайИнфОЛокале(cultureId_, LOCALE_SSHORTDATE);
  }

  private static ткст дайКраткоеВремя(бцел культура) {
    // There is no LOCALE_SSHORTTIME, so we simulate one based on the дол время pattern.
    ткст s = дайИнфОЛокале(культура, LOCALE_STIMEFORMAT);
    цел i = s.найдрек(дайИнфОЛокале(культура, LOCALE_STIME));
    if (i != -1)
      s.length = i;
    return s;
  }

  private static ткст[] getLongDates(бцел культура, бцел календарь) {
    ткст[] форматы;
    synchronized {
      if (!перечислиФорматыДат(культура, календарь, DATE_LONGDATE, форматы))
        return null;
    }
    if (форматы == null)
      форматы = [ дайИнфОКалендаре(культура, календарь, CAL_SLONGDATE) ];
    return форматы;
  }

  private ткст getLongDatePattern(бцел cal) {
    if (!isDefaultCalendar_)
      return getLongDates(cultureId_, cal)[0];
    return дайИнфОЛокале(cultureId_, LOCALE_SLONGDATE);
  }

  private static бул EnumTimeFormats(бцел культура, бцел флаги, out ткст[] форматы) {
    static ткст[] времн;

    extern(Windows)
    static цел EnumTimeFormatsProc(шим* lpTimeFormatString) {
      времн ~= вЮ8(lpTimeFormatString[0 .. wcslen(lpTimeFormatString)]);
      return true;
    }

    времн = null;
    if (!EnumTimeFormatsProc( cast(шим*) времн))
      return false;

    форматы = времн.dup;
    return true;
  }

  private static ткст[] дайКраткиеВремена(бцел культура) {
    ткст[] форматы;

    synchronized {
      if (!EnumTimeFormats(культура, 0, форматы))
        return null;
    }

    foreach (ref s; форматы) {
      цел i = s.найдрек(дайИнфОЛокале(культура, LOCALE_STIME));
      цел j = -1;
      if (i != -1)
        j = s.найдрек(' ');
      if (i != -1 && j != -1) {
        ткст времн = s[0 .. j];
        времн ~= s[j .. $];
        s = времн;
      }
      else if (i != -1)
        s.length = i;
    }

    return форматы;
  }

  private static ткст[] дайДлинныеВремена(бцел культура) {
    ткст[] форматы;
    synchronized {
      if (!EnumTimeFormats(культура, 0, форматы))
        return null;
    }
    return форматы;
  }
  
  private ткст[] дайИменаДней() {
    if (dayNames_ == null) {
      dayNames_.length = 7;
      for (бцел i = LOCALE_SDAYNAME1; i <= LOCALE_SDAYNAME7; i++) {
        бцел j = (i != LOCALE_SDAYNAME7) ? i - LOCALE_SDAYNAME1 + 1 : 0;
        dayNames_[j] = дайИнфОЛокале(cultureId_, i);
      }
    }
    return dayNames_;
  }

  private ткст[] дайСокрИменаДней() {
    if (abbrevDayNames_ == null) {
      abbrevDayNames_.length = 7;
      for (бцел i = LOCALE_SABBREVDAYNAME1; i <= LOCALE_SABBREVDAYNAME7; i++) {
        бцел j = (i != LOCALE_SABBREVDAYNAME7) ? i - LOCALE_SABBREVDAYNAME1 + 1 : 0;
        abbrevDayNames_[j] = дайИнфОЛокале(cultureId_, i);
      }
    }
    return abbrevDayNames_;
  }

  private ткст[] дайИменаМесяцев() {
    if (monthNames_ == null) {
      monthNames_.length = 13;
      for (бцел i = LOCALE_SMONTHNAME1; i <= LOCALE_SMONTHNAME12; i++) {
        monthNames_[i - LOCALE_SMONTHNAME1] = дайИнфОЛокале(cultureId_, i);
      }
    }
    return monthNames_;
  }

  private ткст[] дайСокрИменаМесяцев() {
    if (abbrevMonthNames_ == null) {
      abbrevMonthNames_.length = 13;
      for (бцел i = LOCALE_SABBREVMONTHNAME1; i <= LOCALE_SABBREVMONTHNAME12; i++) {
        abbrevMonthNames_[i - LOCALE_SABBREVMONTHNAME1] = дайИнфОЛокале(cultureId_, i);
      }
    }
    return abbrevMonthNames_;
  }

  /*private static бул EnumCalendarInfo(бцел культура, бцел календарь, бцел calType, out ткст[] рез) {
    static ткст[] времн;

    extern(Windows)
    static цел EnumCalendarInfoProc(шим* lpCalendarInfoString, бцел Календарь) {
      времн ~= вЮ8(lpCalendarInfoString[0 .. wcslen(lpCalendarInfoString)]);
      return 1;
    }

    времн = null;
    if (!EnumCalendarInfoEx(&EnumCalendarInfoProc, культура, календарь, calType))
      return false;
    рез = времн.реверсни;
    return true;
  }*/

  private ткст[] дайИменаЭр() {
    if (eraNames_ == null) {
      eraNames_ = Культура.дай(cultureId_).данныеКалендаря(календарь.внутреннийИд).именаЭр;
      //EnumCalendarInfo(cultureId_, календарь.внутреннийИд, CAL_SERASTRING, eraNames_);
    }
    return eraNames_;
  }

  private цел[] опцКалендари() {
    if (optionalCalendars_ == null)
      optionalCalendars_ = дайДопКалендари(cultureId_);
    return optionalCalendars_;
  }

  private static бул EnumCalendarInfo(бцел культура, бцел календарь, бцел calType, out цел[] рез) {
    static цел[] времн;

    extern(Windows)
    static цел EnumCalendarInfoProc(шим* lpCalendarInfoString, бцел Календарь) {
      времн ~= Календарь;
      return 1;
    }

    времн = null;
    if (!EnumCalendarInfoEx(&EnumCalendarInfoProc, культура, календарь, calType))
      return false;
    рез = времн.dup;
    return true;
  }

  private static цел[] дайДопКалендари(бцел культура) {
    цел[] cals;
    synchronized {
      if (!EnumCalendarInfo(культура, ENUM_ALL_CALENDARS, CAL_ICALINTVALUE, cals))
        return null;
    }
    return cals;
  }

}

/**
 * Реализует методы для культурочувствительных сравнений текстов.
 */
class Коллятор {

  private static Коллятор[бцел] кэш_;

  private бцел cultureId_;
  private бцел sortingId_;
  private ткст name_;

  static ~this() {
    кэш_ = null;
  }

  private this(бцел культура) {
    cultureId_ = культура;
    sortingId_ = getSortingId(культура);
  }

  private бцел getSortingId(бцел культура) {
    бцел sortId = (культура >> 16) & 0xF;
    return (sortId == 0) ? культура : (культура | (sortId << 16));
  }

  /**
   */
  static Коллятор дай(бцел культура) {
    synchronized {
      if (auto значение = культура in кэш_)
        return *значение;

      return кэш_[культура] = new Коллятор(культура);
    }
  }

  /**
   */
  static Коллятор дай(ткст имя) {
    Культура культура = Культура.дай(имя);
    Коллятор коллятор = дай(культура.лкид);
    коллятор.name_ = культура.имя;
    return коллятор;
  }

  /**
   */
  цел сравни(ткст string1, цел offset1, цел length1, ткст string2, цел offset2, цел length2, ПОпцииСравнения опции = ПОпцииСравнения.None) {
    if (string1 == null) {
      if (string2 == null)
        return 0;
      return -1;
    }
    if (string2 == null)
      return 1;

    //if ((опции & ПОпцииСравнения.Ordinal) != 0 || (опции & ПОпцииСравнения.OrdinalIgnoreCase) != 0)
    //  return compareStringOrdinal(string1, offset1, length1, string2, offset2, length2, (опции & ПОпцииСравнения.OrdinalIgnoreCase) != 0);

    return сравниТкст(sortingId_, string1, offset1, length1, string2, offset2, length2, дайСравниФлаги(опции));
  }

  /// ditto
  цел сравни(ткст string1, цел offset1, ткст string2, цел offset2, ПОпцииСравнения опции = ПОпцииСравнения.None) {
    return сравни(string1, offset1, string1.length - offset1, string2, offset2, string2.length - offset2, опции);
  }

  /// ditto
  цел сравни(ткст string1, ткст string2, ПОпцииСравнения опции = ПОпцииСравнения.None) {
    if (string1 == null) {
      if (string2 == null)
        return 0;
      return -1;
    }
    if (string2 == null)
      return 1;

    //if ((опции & ПОпцииСравнения.Ordinal) != 0 || (опции & ПОпцииСравнения.OrdinalIgnoreCase) != 0)
    //  return compareStringOrdinal(string1, 0, string1.length, string2, 0, string2.length, (опции & ПОпцииСравнения.OrdinalIgnoreCase) != 0);

    return сравниТкст(sortingId_, string1, 0, string1.length, string2, 0, string2.length, дайСравниФлаги(опции));
  }

  /**
   */
  цел индексУ(ткст исток, ткст значение, цел индекс, цел счёт, ПОпцииСравнения опции = ПОпцииСравнения.None) {
    бцел флаги = дайСравниФлаги(опции);

    цел n = найдиТкст(sortingId_, флаги | FIND_FROMSTART, исток, индекс, счёт, значение, значение.length);
    if (n > -1)
      return n + индекс;
    if (n == -1)
      return n;

    for (бцел i = 0; i < счёт; i++) {
      if (префикс_ли(исток, индекс + i, счёт - i, значение, флаги))
        return индекс + i;
    }
    return -1;
  }

  /// ditto
  цел индексУ(ткст исток, ткст значение, цел индекс, ПОпцииСравнения опции = ПОпцииСравнения.None) {
    return индексУ(исток, значение, индекс, исток.length - индекс, опции);
  }

  /// ditto
  цел индексУ(ткст исток, ткст значение, ПОпцииСравнения опции = ПОпцииСравнения.None) {
    return индексУ(исток, значение, 0, исток.length, опции);
  }

  /**
   */
  цел последнИндексУ(ткст исток, ткст значение, цел индекс, цел счёт, ПОпцииСравнения опции = ПОпцииСравнения.None) {
    if (исток.length == 0 && (индекс == -1 || индекс == 0)) {
      if (значение.length != 0)
        return -1;
      return 0;
    }

    if (индекс == исток.length) {
      индекс++;
      if (счёт > 0)
        счёт--;
      if (значение.length == 0 && счёт >= 0 && (индекс - счёт) + 1 >= 0)
        return индекс;
    }

    бцел флаги = дайСравниФлаги(опции);

    цел n = найдиТкст(sortingId_, флаги | FIND_FROMEND, исток, (индекс - счёт) + 1, счёт, значение, значение.length);
    if (n > -1)
      return n + (индекс - счёт) + 1;
    if (n == -1)
      return n;

    for (бцел i = 0; i < счёт; i++) {
      if (суффикс_ли(исток, индекс - i, счёт - i, значение, флаги))
        return i + (индекс - счёт) + 1;
    }
    return -1;
  }

  /// ditto
  цел последнИндексУ(ткст исток, ткст значение, цел индекс, ПОпцииСравнения опции = ПОпцииСравнения.None) {
    return последнИндексУ(исток, значение, индекс, индекс + 1, опции);
  }

  /// ditto
  цел последнИндексУ(ткст исток, ткст значение, ПОпцииСравнения опции = ПОпцииСравнения.None) {
    return последнИндексУ(исток, значение, исток.length - 1, исток.length, опции);
  }

  /**
   */
  бул префикс_ли(ткст исток, ткст prefix, ПОпцииСравнения опции = ПОпцииСравнения.None) {
    if (prefix.length == 0)
      return true;
    return префикс_ли(исток, 0, исток.length, prefix, дайСравниФлаги(опции));
  }

  /**
   */
  бул суффикс_ли(ткст исток, ткст suffix, ПОпцииСравнения опции = ПОпцииСравнения.None) {
    if (suffix.length == 0)
      return true;
    return суффикс_ли(исток, исток.length - 1, исток.length, suffix, дайСравниФлаги(опции));
  }

  /**
   */
  сим вПроп(сим c) {
    return changeCaseChar(cultureId_, c, false);
  }

  /**
   */
  ткст вПроп(ткст str) {
    return changeCaseString(cultureId_, str, false);
  }

  /**
   */
  сим вЗаг(сим c) {
    return changeCaseChar(cultureId_, c, true);
  }

  /**
   */
  ткст вЗаг(ткст str) {
    return changeCaseString(cultureId_, str, true);
  }

  /**
   */
  бцел лкид() {
    return cultureId_;
  }

  /**
   */
  ткст имя() {
    if (name_ == null)
      name_ = Культура.дай(cultureId_).имя;
    return name_;
  }

  private static бцел дайСравниФлаги(ПОпцииСравнения опции) {
    бцел флаги;
    if ((опции & ПОпцииСравнения.ИгнорРег) != 0)
      флаги |= NORM_IGNORECASE;
    if ((опции & ПОпцииСравнения.ИгнорНеПробел) != 0)
      флаги |= NORM_IGNORENONSPACE;
    if ((опции & ПОпцииСравнения.ИгнорСимволы) != 0)
      флаги |= NORM_IGNORESYMBOLS;
    if ((опции & ПОпцииСравнения.ИгнорШирину) != 0)
      флаги |= NORM_IGNOREWIDTH;
    return флаги;
  }

  private static цел сравниТкст(бцел лкид, ткст string1, цел offset1, цел length1, ткст string2, цел offset2, цел length2, бцел флаги) {
    цел cch1, cch2;
    шим* lpString1 = вУТФ16нНлс(string1, offset1, length1, cch1);
    шим* lpString2 = вУТФ16нНлс(string2, offset2, length2, cch2);
    return CompareString(лкид, флаги, lpString1, cch1, lpString2, cch2) - 2;
  }

  private static цел compareStringOrdinal(ткст string1, цел offset1, цел length1, ткст string2, цел offset2, цел length2, бул игнорРег) {
    цел счёт = (length2 < length1) 
      ? length2 
      : length1;
    цел ret = игнорРег
      ? memicmp(string1.ptr + offset1, string2.ptr + offset2, счёт)
      : memcmp(string1.ptr + offset1, string2.ptr + offset2, счёт);
    if (ret == 0)
      ret = length1 - length2;
    return ret;
  }

  private бул префикс_ли(ткст исток, цел start, цел length, ткст prefix, бцел флаги) {
    // Call FindNLSString if the API is present on the system, otherwise call CompareString. 
    цел i = найдиТкст(sortingId_, 0, исток, start, length, prefix, prefix.length);
    if (i >= -1)
      return (i != -1);

    for (i = 1; i <= length; i++) {
      if (сравниТкст(sortingId_, prefix, 0, prefix.length, исток, start, i, флаги) == 0)
        return true;
    }
    return false;
  }

  private бул суффикс_ли(ткст исток, цел end, цел length, ткст suffix, бцел флаги) {
    // Call FindNLSString if the API is present on the system, otherwise call CompareString. 
    цел i = найдиТкст(sortingId_, флаги | FIND_ENDSWITH, исток, 0, length, suffix, suffix.length);
    if (i >= -1)
      return (i != -1);

    for (i = 0; i < length; i++) {
      if (сравниТкст(sortingId_, suffix, 0, suffix.length, исток, end - i, i + 1, флаги))
        return true;
    }
    return false;
  }

  private static сим changeCaseChar(бцел лкид, сим ch, бул upperCase) {
    шим wch;
    MultiByteToWideChar(CP_UTF8, 0, &ch, 1, &wch, 1);
    LCMapString(лкид, (upperCase ? LCMAP_UPPERCASE : LCMAP_LOWERCASE) | LCMAP_LINGUISTIC_CASING, &wch, 1, &wch, 1);
    WideCharToMultiByte(CP_UTF8, 0, &wch, 1, &ch, 1, null, null);
    return ch;
  }

  private static ткст changeCaseString(бцел лкид, ткст ткст, бул upperCase) {
    цел cch, cb;
    шим* pChars = вУТФ16нНлс(ткст, 0, ткст.length, cch);
    LCMapString(лкид, (upperCase ? LCMAP_UPPERCASE : LCMAP_LOWERCASE) | LCMAP_LINGUISTIC_CASING, pChars, cch, pChars, cch);
    return вУТФ8Нлс(pChars, cch, cb);
  }

  private static цел найдиТкст(бцел лкид, бцел флаги, ткст исток, цел start, цел sourceLen, ткст значение, цел valueLen) {
    // Return значение:
    // -2 FindNLSString unavailable
    // -1 function failed
    //  0-based индекс if successful

    цел рез = -1;

    цел cchSource, cchValue;
    шим* lpSource = вУТФ16нНлс(исток, 0, sourceLen, cchSource);
    шим* lpValue = вУТФ16нНлс(значение, 0, valueLen, cchValue);

    try {
      рез = FindNLSString(лкид, флаги, lpSource + start, cchSource, lpValue, cchValue, null);
    }
    catch (ТочкаВходаНеНайденаИскл) {
      рез = -2;
    }
    return рез;
  }

}

/**
 * Содержит информацию о стране/регионе.
 */
class Регион {

  private static Регион current_;

  private бцел cultureId_;
  private ткст name_;

  static ~this() {
    current_ = null;
  }

  /**
   */
  this(бцел культура) {
    if (культура == LOCALE_INVARIANT)
      throw new ИсклАргумента("Отсутствует регион, ассоциированный с инвариантной культурой (Культура ID: 0x7F).");

    if (SUBLANGID(cast(бкрат)культура) == 0) {
      scope буфер = new сим[100];
      цел len = sprintf(буфер.ptr, "Культура ID %d (0x%04X) - нейтральная культура; регион из неё создать невозможно.", культура, культура);
      throw new ИсклАргумента(cast(ткст)буфер[0 .. len], "культура");
    }

    cultureId_ = культура;
    name_ = дайИнфОЛокале(культура, LOCALE_SISO3166CTRYNAME);
  }

  /**
   */
  this(ткст имя) {
    name_ = имя.взаг();

    if (!найдиКультуруИзИмениРегиона(имя, cultureId_))
      throw new ИсклАргумента("Регион с именем '" ~ имя ~ "' не поддерживается.", "имя");

    if (нейтральнаяКультура_ли(cultureId_))
      throw new ИсклАргумента("Регион с именем '" ~ имя ~ "' не соответствует нейтральной культуре; требуется особое имя культуры.", "имя");
  }

  override ткст вТкст() {
    return имя;
  }

  /**
   */
  static Регион текущ() {
    if (current_ is null)
      current_ = new Регион(Культура.текущ.лкид);
    return current_;
  }

  /**
   */
  цел геоИд() {
    return дайИнфОЛокалеИ(cultureId_, LOCALE_IGEOID);
  }

  /**
   */
  ткст имя() {
    if (name_ == null)
      name_ = дайИнфОЛокале(cultureId_, LOCALE_SISO3166CTRYNAME);
    return name_;
  }

  /**
   */
  ткст нативноеИмя() {
    return дайИнфОЛокале(cultureId_, LOCALE_SNATIVECTRYNAME);
  }

  /**
   */
  ткст отображИмя() {
    return дайИнфОЛокале(cultureId_, LOCALE_SCOUNTRY);
  }

  /**
   */
  ткст англИмя() {
    return дайИнфОЛокале(cultureId_, LOCALE_SENGCOUNTRY);
  }

  /**
   */
  ткст изоИмяРегиона() {
    return дайГеоИнфо(геоИд, GEO_ISO2);
  }

  /**
   */
  бул метрика_ли() {
    return дайИнфОЛокалеИ(cultureId_, LOCALE_IMEASURE) == 0;
  }

  /**
   */
  ткст символВалюты() {
    return дайИнфОЛокале(cultureId_, LOCALE_SCURRENCY);
  }

  /**
   */
  ткст изоСимволВалюты() {
    return дайИнфОЛокале(cultureId_, LOCALE_SINTLSYMBOL);
  }

  /**
   */
  ткст роднИмяВалюты() {
    return дайИнфОЛокале(cultureId_, LOCALE_SNATIVECURRNAME);
  }

  /**
   */
  ткст англИмяВалюты() {
    return дайИнфОЛокале(cultureId_, LOCALE_SENGCURRNAME);
  }

  /**
   */
  дво широта() {
    version(D_Version2) {
      return stdrus.to!(дво)(дайГеоИнфо(геоИд, GEO_LATITUDE));
    }
    else {
      return вДво(дайГеоИнфо(геоИд, GEO_LATITUDE));
    }
  }

  /**
   */
  дво долгота() {
    version(D_Version2) {
      return stdrus.to!(дво)(дайГеоИнфо(геоИд, GEO_LONGITUDE));
    }
    else {
      return вДво(дайГеоИнфо(геоИд, GEO_LONGITUDE));
    }
  }

}