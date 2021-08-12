/**
 * Contains classes that manipulate the Windows _registry.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.utils.registry;

import win32.base.core,
  win32.base.string,
  win32.base.native,
  stdrus;
static import cidrus;

/// Specifies the данные типы to use when storing значения in the registry.
enum RegistryValueKind {
  Unknown      = 0,  /// Indicates an unsupported registry данные тип.
  String       = 1,  /// Specifies a ткст. Equivalent to REG_SZ.
  ExpandString = 2,  /// Specifies a ткст containing references to environment vaariables. Equivalent to REG_EXPAND_SZ.
  Binary       = 3,  /// Specifies binary данные in any form. Equivalent to REG_BINARY.
  DWord        = 4,  /// Specifies a 32-bit binary число. Equivalent to REG_DWORD.
  MultiString  = 7,  /// Specifies an array of strings. Equivalent to REG_MULTI_SZ.
  QWord        = 11  /// Specifies a 64-bit binary число. Equivalent to REG_QWORD.
}

///
enum RegistryValueOptions {
  None,                       ///
  DoNotExpandEnvironmentNames ///
}

///
enum RegistryOptions {
  None,    ///
  Volatile ///
}

/**
 * Represents a node in the Windows registry.
 * Примеры:
 * ---
 * import win32.utils.registry, stdrus;
 *
 * проц main() {
 *   // Create a subkey named TestKey under "HKEY_CURRENT_USER".
 *   scope ключ = RegistryKey.currentUser.createSubKey("TestKey");
 *   if (ключ) {
 *     // Create данные for the TestKey subkey.
 *     ключ.setValue("StringValue", "Hello, World");
 *     ключ.setValue("DWordValue", 123);
 *     ключ.setValue("BinaryValue", cast(ббайт[])[1, 2, 3]);
 *     ключ.setValue("MultiStringValue", ["Hello", "World"]);
 *
 *     // Print the данные in the TestKey subkey.
 *     скажифнс("There are %s значения for %s", ключ.valueCount, ключ.имя);
 *     foreach (valueName; ключ.valueNames) {
 *       скажифнс("%s: %s", valueName, ключ.дайЗначение!(ткст)(valueName));
 *     }
 *   }
 * }
 * ---
 */
final class RegistryKey {

  private const ткст[] keyNames_ = [
    "HKEY_CLASSES_ROOT",
    "HKEY_CURRENT_USER",
    "HKEY_LOCAL_MACHINE",
    "HKEY_USERS",
    "HKEY_PERFORMANCE_DATA",
    "HKEY_CURRENT_CONFIG",
    "HKEY_DYN_DATA"
  ];

  private static RegistryKey classesRoot_;
  private static RegistryKey currentUser_;
  private static RegistryKey localMachine_;
  private static RegistryKey users_;
  private static RegistryKey performanceData_;
  private static RegistryKey currentConfig_;
  private static RegistryKey dynData_; // Win9x only

  static ~this() {
    classesRoot_ = null;
    currentUser_ = null;
    localMachine_ = null;
    users_ = null;
    performanceData_ = null;
    currentConfig_ = null;
    dynData_ = null;
  }

  private Укз hkey_;
  private ткст name_;
  private бул writable_;
  private бул systemKey_;
  private бул perfData_;
  private бул dirty_;

  /// Defines the типы of documents and properties associated with those типы. Reads HKEY_CLASSES_ROOT.
  static RegistryKey classesRoot() {
    if (classesRoot_ is null)
      classesRoot_ = getSystemKey(HKEY_CLASSES_ROOT);
    return classesRoot_;
  }

  /// Contains information about the текущ user preferences. Reads HKEY_CURRENT_USER.
  static RegistryKey currentUser() {
    if (currentUser_ is null)
      currentUser_ = getSystemKey(HKEY_CURRENT_USER);
    return currentUser_;
  }

  /// Contains configuration данные for the local machine. Reads HKEY_LOCAL_MACHINE.
  static RegistryKey localMachine() {
    if (localMachine_ is null)
      localMachine_ = getSystemKey(HKEY_LOCAL_MACHINE);
    return localMachine_;
  }
  
  /// Contains information about the default user configuration. Reads HKEY_USERS.
  static RegistryKey users() {
    if (users_ is null)
      users_ = getSystemKey(HKEY_USERS);
    return users_;
  }
  
  /// Contains performance information for software компоненты. Reads HKEY_PERFORMANCE_DATA.
  static RegistryKey performanceData() {
    if (performanceData_ is null)
      performanceData_ = getSystemKey(HKEY_PERFORMANCE_DATA);
    return performanceData_;
  }
  
  /// Contains configuration information about hardware that is not specifiec to the user. Reads HKEY_CURRENT_CONFIG.
  static RegistryKey currentConfig() {
    if (currentConfig_ is null)
      currentConfig_ = getSystemKey(HKEY_CURRENT_CONFIG);
    return currentConfig_;
  }
  
  /// Contains dynamic registry данные. Reads HKEY_DYN_DATA.
  static RegistryKey dynData() {
    if (dynData_ is null)
      dynData_ = getSystemKey(HKEY_DYN_DATA);
    return dynData_;
  }

  private static RegistryKey getSystemKey(Укз hkey) {
    auto ключ = new RegistryKey(hkey, true, true, (hkey == HKEY_PERFORMANCE_DATA));
    ключ.name_ = keyNames_[cast(цел)hkey & 0x0FFFFFFF];
    return ключ;
  }

  private this(Укз hkey, бул writable, бул systemKey = false, бул remoteKey = false, бул perfData = false) {
    hkey_ = hkey;
    writable_ = writable;
    systemKey_ = systemKey;
    perfData_ = perfData;
  }

  ~this() {
    закрой();
  }

  /**
   */
  static RegistryKey fromHandle(Укз указатель) {
    return new RegistryKey(указатель, true);
  }

  /**
   * Closes the ключ.
   */
  проц закрой() {
    if (hkey_ != Укз.init) {
      if (!systemKey_) {
        RegCloseKey(hkey_);
        hkey_ = Укз.init;
      }
    }
  }
  
  /**
   * Writes all атрибуты of the текущ ключ into the registry.
   */
  проц слей() {
    if (hkey_ != Укз.init) {
      if (dirty_)
        RegFlushKey(hkey_);
    }
  }

  /**
   * Retrieves a subkey.
   * Параметры:
   *   имя = Name or путь of the subkey to open.
   *   writable = true if you need пиши access to the ключ.
   * Возвращает: The subkey requested, or null if the operation failed.
   */
  RegistryKey openSubKey(ткст имя, бул writable = false) {
    имя = fixName(имя);

    Укз рез;
    цел ret = RegOpenKeyEx(hkey_, имя.вУтф16н(), 0, (writable ? (KEY_READ | KEY_WRITE) : KEY_READ), рез);

    if (ret == ERROR_SUCCESS && рез != INVALID_HANDLE_VALUE) {
      auto ключ = new RegistryKey(рез, writable, false);
      ключ.name_ = name_ ~ "\\" ~ имя;
      return ключ;
    }
    else if (ret == ERROR_ACCESS_DENIED || ret == ERROR_BAD_IMPERSONATION_LEVEL)
      throw new ИсклБезопасности("Requested registry access is not allowed.");

    return null;
  }

  /**
   * Creates a new subkey or opens an existing subkey.
   * Параметры:
   *   имя = The _name or путь of the subkey to create or open.
   *   writable = true if you need пиши access to the ключ.
   * Возвращает: The newly создан subkey.
   */
  RegistryKey createSubKey(ткст имя, бул writable, RegistryOptions опции = RegistryOptions.None) {
    checkOptions(опции);

    имя = fixName(имя);

    бцел disposition;
    Укз рез;
    цел ret = RegCreateKeyEx(hkey_, имя.вУтф16н(), 0, null, cast(бцел)опции, (writable ? (KEY_READ | KEY_WRITE) : KEY_READ), null, рез, disposition);

    if (ret == ERROR_SUCCESS && рез != INVALID_HANDLE_VALUE) {
      auto ключ = new RegistryKey(рез, writable, false);

      if (имя.length == 0)
        ключ.name_ = имя;
      else
        ключ.name_ ~= "\\" ~ имя;
      return ключ;
    }
    else if (ret != ERROR_SUCCESS)
      throw new Win32Exception(ret);

    return null;
  }

  /**
   * ditto
   */
  RegistryKey createSubKey(ткст имя) {
    return createSubKey(имя, writable_);
  }

  /**
   * Deletes the specified subkey.
   * Параметры:
   *   имя = The _name of the subkey to delete.
   *   throwOnMissingSubKey = true to raise an exception if the subkey does not exist.
   */
  проц deleteSubKey(ткст имя, бул throwOnMissingSubKey = true) {
    if (!writable_)
      throw new ИсклНесанкционированныйДоступ("Cannot пиши to the registry ключ.");

    if (auto ключ = openSubKey(имя, false)) {
      try {
        if (ключ.subKeyCount > 0)
          throw new ИсклНеправильнОперации("Registry ключ has subkeys and recursive removes are not supported by this метод.");
      }
      finally {
        ключ.закрой();
      }

      цел ret = RegDeleteKey(hkey_, имя.вУтф16н());
      if (ret != ERROR_SUCCESS) {
        if (ret == ERROR_FILE_NOT_FOUND && throwOnMissingSubKey)
          throw new ИсклАргумента("Cannot delete a subkey tree because the subkey does not exist.");
        else
          throw new Win32Exception(ret);
      }
    }
    else
      throw new ИсклАргумента("Cannot delete a subkey tree because the subkey does not exist.");
  }

  /**
   * Deletes a subkey and child subkeys recursively.
   * Параметры: имя = The _name of the subkey to delete.
   * Выводит исключение:
   *   ИсклНесанкционированныйДоступ if the user does not have the necessary rights.$(BR)
   *   ИсклАргумента if имя does not specify a valid subkey.
   */
  проц deleteSubKeyTree(ткст имя) {
    if (имя.length == 0 && systemKey_)
      throw new ИсклАргумента("Cannot delete a registry hive's subtree.");

    if (!writable_)
      throw new ИсклНесанкционированныйДоступ("Cannot пиши to the registry ключ.");

    deleteSubKeyTreeImpl(имя);
  }

  private проц deleteSubKeyTreeImpl(ткст имя) {
    if (auto ключ = openSubKey(имя)) {
      try {
        if (ключ.subKeyCount > 0) {
          foreach (subKey; ключ.subKeyNames) {
            ключ.deleteSubKeyTreeImpl(subKey);
          }
        }
      }
      finally {
        ключ.закрой();
      }

      цел ret = RegDeleteKey(hkey_, имя.вУтф16н());
      if (ret != ERROR_SUCCESS)
        throw new Win32Exception(ret);
    }
    else
      throw new ИсклАргумента("Cannot delete a subkey tree because the subkey does not exist.");
  }

  /**
   * Deletes the specified значение from this ключ.
   * Параметры:
   *   имя = The _name of the значение to delete.
   *   throwOnMissingValue = true to raise an exception if the specified значение does not exist.
   */
  проц deleteValue(ткст имя, бул throwOnMissingValue = true) {
    if (!writable_)
      throw new ИсклНесанкционированныйДоступ("Cannot пиши to the registry ключ.");

    цел ret = RegDeleteValue(hkey_, имя.вУтф16н());
    if (ret == ERROR_FILE_NOT_FOUND && throwOnMissingValue)
      throw new ИсклАргумента("Cannot delete a subkey tree because the subkey does not exist.");
  }

  /**
   * Retrieves the registry данные тип of the значение associated with the specified _name.
   * Параметры: имя = The _name of the значение whose registry данные тип is to be retrieved.
   * Возвращает: A значение representing the registry данные тип of the значение associated with имя.
   */
  RegistryValueKind getValueKind(ткст имя) {
    бцел тип;
    цел ret = RegQueryValueEx(hkey_, имя.вУтф16н(), null, &тип, null, null);
    return cast(RegistryValueKind)тип;
  }

  /**
   * Retrieves the значение associated with the specified _name.
   * Параметры:
   *   имя = The _name of the значение to retrieve.
   *   дефолтнЗнач = The значение to return if имя does not exist.
   *   expandEnvironmentNames = Specify true to expand environment значения.
   * Возвращает: The значение associated with имя, or дефолтнЗнач if имя is not found.
   */
  T дайЗначение(T)(ткст имя, T дефолтнЗнач = T.init, RegistryValueOptions опции = RegistryValueOptions.None) {

    ткст раскройПеременныеСреды(ткст имя) {
      auto src = имя.вУтф16н();
      цел размер = ExpandEnvironmentStrings(src, null, 0);

      шим[] dst = new шим[размер];
      размер = ExpandEnvironmentStrings(src, dst.ptr, dst.length);
      if (размер == 0)
        throw new Win32Exception(GetLastError());
      return .вУтф8(dst[0 .. размер - 1].ptr);
    }

    бул expandEnvironmentNames = (опции != RegistryValueOptions.DoNotExpandEnvironmentNames);
    auto lpName = имя.вУтф16н();

    бцел тип, размер;
    цел ret = RegQueryValueEx(hkey_, lpName, null, &тип, null, &размер);

    static if (is(T : бцел)) {
      if (тип == REG_DWORD) {
        бцел b;
        ret = RegQueryValueEx(hkey_, lpName, null, &тип, cast(ббайт*)&b, &размер);
        return cast(T)b;
      }
    }
    else static if (is(T : бдол)) {
      if (тип == REG_QWORD) {
        бдол b;
        ret = RegQueryValueEx(hkey_, lpName, null, &тип, cast(ббайт*)&b, &размер);
        return cast(T)b;
      }
    }
    else static if (is(T : ткст)) {
      if (тип == REG_SZ || тип == REG_EXPAND_SZ) {
        шим[] b = new шим[размер / шим.sizeof];
        ret = RegQueryValueEx(hkey_, lpName, null, &тип, cast(ббайт*)b.ptr, &размер);
        auto данные = .вУтф8(b[0 .. (размер / шим.sizeof) - 1].ptr);

        if (тип == REG_EXPAND_SZ && expandEnvironmentNames)
          данные = раскройПеременныеСреды(данные);

        return данные;
      }
    }
    else static if (is(T : ткст[])) {
      if (тип == REG_MULTI_SZ) {
        ткст[] данные;

        шим[] b = new шим[размер / шим.sizeof];
        RegQueryValueEx(hkey_, lpName, null, &тип, cast(ббайт*)b.ptr, &размер);

        бцел индекс;
        бцел end = b.length;

        while (индекс < end) {
          бцел поз = индекс;
          while (поз < end && b[поз] != 0)
            поз++;

          if (поз < end) {
            if (поз - индекс > 0)
              данные ~= .вУтф8(b[индекс .. end].ptr);
            else if (поз != end - 1)
              данные ~= "";
          }
          else
            данные ~= .вУтф8(b[индекс .. end].ptr);

          индекс = поз + 1;
        }

        return данные;
      }
    }
    else static if (is(T : ббайт[])) {
      if (тип == REG_BINARY || тип == REG_DWORD_BIG_ENDIAN) {
        ббайт[] b = new ббайт[размер];
        ret = RegQueryValueEx(hkey_, lpName, null, &тип, b.ptr, &размер);
        return b;
      }
    }

    return дефолтнЗнач;
  }

  /**
   * Sets the _value of a имя/значение pair in the registry ключ используя the specified registry данные тип.
   * Параметры:
   *   имя = The _name of the _value to be stored.
   *   значение = The данные to be stored.
   *   valueKind = The registry данные тип to use when storing the данные.
   */
  проц setValue(T)(ткст имя, T значение, RegistryValueKind valueKind = RegistryValueKind.Unknown) {
    if (!writable_)
      throw new ИсклНесанкционированныйДоступ("Cannot пиши to the registry ключ.");

    if (valueKind == RegistryValueKind.Unknown) {
      static if (is(T == цел) || is(T == бцел))
        valueKind = RegistryValueKind.DWord;
      else static if (is(T == дол) || is(T == бдол))
        valueKind = RegistryValueKind.QWord;
      else static if (is(T : ткст))
        valueKind = RegistryValueKind.String;
      else static if (is(T : ткст[]))
        valueKind = RegistryValueKind.MultiString;
      else static if (is(T == ббайт[]))
        valueKind = RegistryValueKind.Binary;
      else
        valueKind = RegistryValueKind.String;
    }

    auto lpName = имя.вУтф16н();

    цел ret = ERROR_SUCCESS;
    try {
      switch (valueKind) {
        case RegistryValueKind.DWord:
          бцел данные;
          static if (is(T : бцел))
            данные = cast(бцел)значение;
          else
            throw new ИсклПриведенияКТипу;

          ret = RegSetValueEx(hkey_, lpName, 0, cast(бцел)valueKind, cast(ббайт*)&данные, бцел.sizeof);
          break;

        case RegistryValueKind.QWord:
          бдол данные;
          static if (is(T : бдол))
            данные = cast(бдол)значение;
          else
            throw new ИсклПриведенияКТипу;

          ret = RegSetValueEx(hkey_, lpName, 0, cast(бцел)valueKind, cast(ббайт*)&данные, бдол.sizeof);
          break;

        case RegistryValueKind.String, RegistryValueKind.ExpandString:
          ткст данные;
          static if (is(T : ткст))
            данные = значение;
          else
            данные = фм("%s", значение);

          ret = RegSetValueEx(hkey_, lpName, 0, cast(бцел)valueKind, cast(ббайт*)данные.вУтф16н(), (данные.length * шим.sizeof) + 2);
          break;

        case RegistryValueKind.MultiString:
          static if (is(T : ткст[])) {
            бцел размер;
            foreach (s; значение) {
              размер += (s.length + 1) * шим.sizeof;
            }

            шим[] буфер = new шим[размер];
            цел индекс;
            foreach (s; значение) {
              wstring ws = s.вУтф16();

              цел поз = индекс + ws.length;
              буфер[индекс .. поз] = ws;
              буфер[поз] = '\0';

              индекс = поз + 1;
            }

            ret = RegSetValueEx(hkey_, lpName, 0, cast(бцел)valueKind, cast(ббайт*)буфер.ptr, буфер.length);
          }
          else
            throw new ИсклПриведенияКТипу;
          break;

        case RegistryValueKind.Binary:
          static if (is(T : ббайт[]))
            ret = RegSetValueEx(hkey_, lpName, 0, cast(бцел)valueKind, (cast(ббайт[])значение).ptr, значение.length);
          else
            throw new ИсклПриведенияКТипу;
          break;

        default:
      }
    }
    catch (ИсклПриведенияКТипу) {
      throw new ИсклАргумента("The тип of the значение argument did not match the specified RegistryValueKind or the значение could not be properly converted.");
    }

    if (ret != ERROR_SUCCESS)
      throw new Win32Exception(ret);
    else
      dirty_ = true;
  }

  /**
   * Retrieves a ткст representation of this ключ.
   */
  override ткст вТкст() {
    return name_;
  }

  /**
   * Retrieves the _name of this ключ.
   */
  ткст имя() {
    return name_;
  }

  /**
   * Retrieves the счёт of значения in the ключ.
   */
  бцел valueCount() {
    бцел значения;
    цел ret = RegQueryInfoKey(hkey_, null, null, null, null, null, null, &значения, null, null, null, null);
    if (ret != ERROR_SUCCESS)
      throw new Win32Exception(ret);
    return значения;
  }

  /**
   * Retrieves an array of strings containing all the значение names.
   */
  ткст[] valueNames() {
    бцел значения = valueCount;
    ткст[] names = new ткст[значения];

    if (значения > 0) {
      шим[256] имя;
      for (auto i = 0; i < значения; i++) {
        бцел nameLen = имя.length;
        цел ret = RegEnumValue(hkey_, i, имя.ptr, nameLen, null, null, null, null);
        if (ret != ERROR_SUCCESS)
          throw new Win32Exception(ret);
        names[i] = .вУтф8(имя[0 .. nameLen].ptr);
      }
    }

    return names;
  }

  /**
   * Retrieves the счёт of subkeys of the текущ ключ.
   */
  бцел subKeyCount() {
    бцел subKeys;
    цел ret = RegQueryInfoKey(hkey_, null, null, null, &subKeys, null, null, null, null, null, null, null);
    if (ret != ERROR_SUCCESS)
      throw new Win32Exception(ret);
    return subKeys;
  }

  /**
   * Retrieves an array of strings containing all the subkey names.
   */
  ткст[] subKeyNames() {
    бцел значения = subKeyCount;
    ткст[] names = new ткст[значения];

    if (значения > 0) {
      шим[256] имя;
      for (auto i = 0; i < значения; i++) {
        бцел nameLen = имя.length;
        цел ret = RegEnumKeyEx(hkey_, i, имя.ptr, nameLen, null, null, null, null);
        if (ret != ERROR_SUCCESS)
          throw new Win32Exception(ret);
        names[i] = .вУтф8(имя[0 .. nameLen].ptr);
      }
    }

    return names;
  }

  /**
   */
  Укз указатель() {
    if (!systemKey_)
      return hkey_;

    Укз hkey;
    switch (name_) {
      case "HKEY_CLASSES_ROOT":
        hkey = HKEY_CLASSES_ROOT;
        break;
      case "HKEY_CURRENT_USER":
        hkey = HKEY_CURRENT_USER;
        break;
      case "HKEY_LOCAL_MACHINE":
        hkey = HKEY_LOCAL_MACHINE;
        break;
      case "HKEY_USERS":
        hkey = HKEY_USERS;
        break;
      case "HKEY_PERFORMANCE_DATA":
        hkey = HKEY_PERFORMANCE_DATA;
        break;
      case "HKEY_CURRENT_CONFIG":
        hkey = HKEY_CURRENT_CONFIG;
        break;
      case "HKEY_DYN_DATA":
        hkey = HKEY_DYN_DATA;
        break;
      default:
        throw new Win32Exception(ERROR_INVALID_HANDLE);
    }
    Укз рез;
    бцел ret = RegOpenKeyEx(hkey, null, 0, (writable_ ? (KEY_READ | KEY_WRITE) : KEY_READ), рез);
    if (ret == ERROR_SUCCESS && рез != INVALID_HANDLE_VALUE)
      return рез;
    throw new Win32Exception(ret);
  }

  private static ткст fixName(ткст имя) {
    if (имя[имя.length - 1] == '\\')
      имя.length = имя.length - 1;
    return имя;
  }

  private static проц checkOptions(RegistryOptions опции) {
    if (опции < RegistryOptions.None || опции > RegistryOptions.Volatile)
      throw new ИсклАргумента("The specified RegistryOptions значение is invalid", "опции");
  }

}