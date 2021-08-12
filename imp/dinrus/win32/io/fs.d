module win32.io.fs;

import win32.base.core,
  win32.base.string,
  win32.base.events,
  win32.base.native,
  win32.loc.time,
  win32.io.core,
  win32.io.path,
  cidrus;
  
version(D_Version2) {
  import core.thread;
}
else {
  import thread;
}
static import stdrus;

/// Возвращает массив строк, содержащий названия логических дисков локального компьютера.
ткст[] логическиеДиски();

/// Возвращает информацию о корневой папке и/или томе заданного пути.
ткст дайКорневуюПапку(ткст путь) ;

/// Определяет, соответствует ли заданный путь _path существующей на диске папке.
бул естьПапка(ткст путь);

/// Создает все папки в указанном _path.
проц создайПапку(ткст путь);

/// Указывает, следует ли удалить файл или папку навсегда или же поместить их в корзину.
enum ПОпцияУдаления {
  УдалитьНавсегда, /// Удалить файл или папку навсегда. Дефолт.
  ПовзолитьОтмену          /// Позволяет отменить операцию удаления.
}

/// Удаляет папку по заданному пути _path.
проц удалиПапку(ткст путь, ПОпцияУдаления option = ПОпцияУдаления.УдалитьНавсегда) ;

/// Перемещает файл или папку с ее содержимым в новое место.
проц переместиПапку(ткст sourceDirName, ткст destDirName);

/// Возвращает дату и время создания папки или файла.
ДатаВрем дайВремяСоздания(ткст путь) ;

/// Возвращает дату и время последнего доступа к папке или файлу.
ДатаВрем дайВремяПоследнДоступа(ткст путь);

/// Возвращает дату и время последней записи в файл.
ДатаВрем дайВремяПоследнЗаписи(ткст путь);

/// Возвращает атрибуты файла, находящегося по заданному пути _path.
ПАтрыФайла дайФАтры(ткст путь) ;

/// Определяет, существует ли указанный файл.
бул естьФайл(ткст путь);

/// Удалет указанный файл.
проц удалиФайл(ткст путь, ПОпцияУдаления option = ПОпцияУдаления.УдалитьНавсегда);

/// Перемещает указанный файл в новое место.
проц переместиФайл(ткст sourceFileName, ткст destFileName);

/// Копирует существующий файл в новый файл, с опцией переписать файл _overwrite с одноименным названием.
проц копируйФайл(ткст sourceFileName, ткст destFileName, бул overwrite = false) ;

/// Replaces the contents of the specified file with the contents of another, deleting the original, and creating a backup of the replaced file and optionally ignores merge errors.
проц замениФайл(ткст sourceFileName, ткст destFileName, ткст backupFileName, бул ignoreMergeErrors = false);

/// Encrypts a file so that only the user account used to encrypt the file can decrypt it.
проц шифруйФайл(ткст путь);

/// Decrypts a file that was encrypted by the текущ user account используя the шифруйФайл метод.
проц расшифруйФайл(ткст путь) ;

/**
 * Примеры:
 * Converts a numeric значение into a human-readable ткст representing the число expressed in байты, kilobytes, megabytes or gigabytes.
 * ---
 * ткст[] orders = [ "GB", "MB", "KB", " байты" ];
 * const real шкала = 1024;
 * auto max = std.math.pow(шкала, orders.length - 1);
 *
 * ткст drive = r"C:\";
 * auto freeSpace = дайСвободнМесто(drive);
 * ткст s = "0 байты";
 *
 * foreach (order; orders) {
 *   if (freeSpace > max) {
 *     s = фм("%.2f%s", cast(real)freeSpace / max, order);
 *     break;
 *   }
 *   max /= шкала;
 * }
 *
 * stdrus.скажифнс("Available free space on drive %s: %s", drive, s);
 * ---
 */
бдол дайСвободнМесто(ткст driveName);

/**
 */
бдол дайОбщРазм(ткст driveName) ;

/**
 */
бдол дайОбщСвобПрострво(ткст driveName);

/**
 */
ткст дайМеткуТома(ткст driveName) ;

/**
 */
проц устМеткуТома(ткст driveName, ткст volumeLabel) ;

/**
 */
enum ПФильтрыУведомления {
  FileName      = FILE_NOTIFY_CHANGE_FILE_NAME,
  DirectoryName = FILE_NOTIFY_CHANGE_DIR_NAME,
  Attributes    = FILE_NOTIFY_CHANGE_ATTRIBUTES,
  Размер          = FILE_NOTIFY_CHANGE_SIZE,
  LastWrite     = FILE_NOTIFY_CHANGE_LAST_WRITE,
  LastAccess    = FILE_NOTIFY_CHANGE_LAST_ACCESS,
  CreationTime  = FILE_NOTIFY_CHANGE_CREATION,
  Security      = FILE_NOTIFY_CHANGE_SECURITY
}

/**
 */
enum ПИзменениеНаблюдателя {
  Создан = 0x1,
  Удалён = 0x2,
  Изменён = 0x4,
  Переименован = 0x8,
  Все     = Создан | Удалён | Изменён | Переименован
}

/**
 */
class АргиСобФСистемы : АргиСоб {

  private ПИзменениеНаблюдателя change_;
  private ткст name_;
  private ткст fullPath_;

  this(ПИзменениеНаблюдателя изменение, ткст папка, ткст имя) ;

  ПИзменениеНаблюдателя изменение() ;

  ткст имя() ;

  ткст полныйПуть();

}

/**
 */
alias ТОбработчикСоб!(АргиСобФСистемы) ОбработчикСобФСистемы;

/**
 */
class АргиСобПереименован : АргиСобФСистемы {

  private ткст oldName_;
  private ткст oldFullPath_;

  this(ПИзменениеНаблюдателя изменение, ткст папка, ткст имя, ткст староеИмя);

  ткст староеИмя() ;

  ткст старыйПолныйПуть() ;

}

/**
 */
alias ТОбработчикСоб!(АргиСобПереименован) ОбработчикСобПереименован;

/**
 */
class АргиСобОшибка : АргиСоб {

  private Exception exception_;

  this(Exception exception) ;

  Exception getException() ;

}

/**
 */
alias ТОбработчикСоб!(АргиСобОшибка) ОбработчикСобОшибка;

alias проц delegate(бцел кодОш, бцел numBytes, OVERLAPPED* overlapped) ОбрвызЗавершенияВВ;

// Wraps a native OVERLAPPED and associates a обрвыз with each object.
private class Накладка {

  static Накладка[OVERLAPPED*] overlappedCache;

  ОбрвызЗавершенияВВ обрвыз;
  OVERLAPPED* overlapped;

  static ~this() ;

  OVERLAPPED* пакуй(ОбрвызЗавершенияВВ iocb) ;

  static Накладка распакуй(OVERLAPPED* lpOverlapped) ;

  static проц освободи(OVERLAPPED* lpOverlapped);

  static Накладка дайНакладку(OVERLAPPED* lpOverlapped);

}

extern(Windows)
private проц привяжиОбрвызЗавершения(бцел кодОш, бцел numBytes, OVERLAPPED* lpOverlapped);

/**
 * Listens to file system изменение notifications and raises собы when a папка, or file in a папка, changes.
 * Примеры:
 * ---
 * import win32.io.fs, stdrus;
 *
 * проц main() {
 *   // Create a Наблюдатель object and уст its properties.
 *   scope watcher = new Наблюдатель;
 *   watcher.путь = r"C:\";
 *
 *   // Add событие handlers.
 *   watcher.создан += (Объект, АргиСобФСистемы e) {
 *     скажифнс("Файл %s изменён", e.полныйПуть);
 *   };
 *   watcher.удалён += (Объект, АргиСобФСистемы e) {
 *     скажифнс("Файл %s удалён", e.полныйПуть);
 *   };
 *   watcher.изменён += (Объект, АргиСобФСистемы e) {
 *     скажифнс("Файл %s изменён", e.полныйПуть);
 *   };
 *   watcher.переименован += (Объект, АргиСобПереименован e) {
 *     скажифнс("Файл %s переименован to %s", e.старыйПолныйПуть, e.полныйПуть);
 *   };
 *
 *   // Start listening.
 *   watcher.активируйСобытия = true;
 *
 *   скажифнс("Press 'q' to quit.");
 *   while (cidrus.getch() != 'q') {
 *   }
 * }
 * ---
 */
class Наблюдатель {

  private ткст directory_;
  private ткст filter_ = "*";
  private бул includeSubDirs_;
  private ПФильтрыУведомления notifyFilters_ = ПФильтрыУведомления.FileName | ПФильтрыУведомления.DirectoryName | ПФильтрыУведомления.LastWrite;
  private Укз directoryHandle_;
  private бцел bufferSize_ = 8192;
  private бул enabled_;
  private бул stopWatching_;
  private static Укз completionPort_;
  private static цел completionPortThreadCount_;

  ///
  ОбработчикСобФСистемы создан;
  ///
  ОбработчикСобФСистемы удалён;
  ///
  ОбработчикСобФСистемы изменён;
  ///
  ОбработчикСобПереименован переименован;
  ///
  ОбработчикСобОшибка ошибка;

  static ~this() ;

  /**
   */
  this(ткст путь = null, ткст фильтр = "*") ;

  ~this() ;

  /**
   */
  final проц размБуфера(бцел значение) ;
  /// ditto
  final бцел размБуфера() ;

  /**
   */
  final проц путь(ткст значение);
  /// ditto
  final ткст путь() ;

  /**
   */
  final проц фильтр(ткст значение) ;
  /// ditto
  final ткст фильтр() ;

  /**
   */
  final проц фильтрыУведомления(ПФильтрыУведомления значение) ;
  /// ditto
  final ПФильтрыУведомления фильтрыУведомления() ;

  /**
   */
  final проц активируйСобытия(бул значение);
  final бул активируйСобытия() ;

  /**
   */
  protected проц приСоздании(АргиСобФСистемы e);

  /**
   */
  protected проц приУдалении(АргиСобФСистемы e) ;

  /**
   */
  protected проц приИзменении(АргиСобФСистемы e) ;

  /**
   */
  protected проц приПереименовании(АргиСобПереименован e) ;

  /**
   */
  protected проц приОшибке(АргиСобОшибка e) ;

  private проц стартСобытий() ;

  private проц стопСобытий() ;

  private проц рестарт() ;

  private проц наблюдай(ук буфер);

  private бул естьСовпадение(ткст путь) ;

  private проц уведомиПереименов(ПИзменениеНаблюдателя действие, ткст имя, ткст староеИмя);

  private проц уведомиФСист(бцел действие, ткст имя) ;

  private проц обрвызЗавершения(бцел кодОш, бцел numBytes, OVERLAPPED* lpOverlapped);

  private бул повреждёнУк_ли() ;

}

///
interface Итератор(T) {

  ///
  цел opApply(цел delegate(ref T) действие);

}

class ИтераторФСистемы : Итератор!(ткст) {

  private ткст путь_;
  private ткст searchPattern_;
  private бул includeFiles_;
  private бул includeDirs_;

  this(ткст путь, ткст searchPattern, бул includeFiles, бул includeDirs) {
    путь_ = путь;
    searchPattern_ = searchPattern;
    includeFiles_ = includeFiles;
    includeDirs_ = includeDirs;
  }

  цел opApply(цел delegate(ref ткст) действие) {

    бул папка_ли(WIN32_FIND_DATA findData) {
      return ((findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) != 0);
    }

    бул файл_ли(WIN32_FIND_DATA findData) {
      return ((findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0);
    }

    ткст дайРезПоиска(ткст путь, WIN32_FIND_DATA findData) {
      return комбинируй(путь, вУтф8(findData.cFileName[0 .. cidrus.wcslen(findData.cFileName.ptr)]));
    }

    цел ret = 0;

    ткст полныйПуть = дайПолнПуть(путь_);

    ткст searchPattern = searchPattern_.поправьКон('\t', '\n', '\v', '\f', '\r', '\u0085', '\u00a0');
    if (searchPattern == ".")
      searchPattern = "*";
    if (searchPattern.length == 0)
      return ret;

    ткст searchPath = комбинируй(полныйПуть, searchPattern);
    if (searchPath[$ - 1] == win32.io.path.сеп[0] 
      || searchPath[$ - 1] == win32.io.path.альтсеп[0] 
      || searchPath[$ - 1] == ':')
      searchPath ~= '*';

    ткст userPath = путь_;
    ткст времПуть = дайИмяПапки(searchPattern);
    if (времПуть.length != 0)
      userPath = комбинируй(userPath, времПуть);

    WIN32_FIND_DATA findData;
    бцел lastError;

    Укз hFind = FindFirstFile(searchPath.вУтф16н(), findData);
    if (hFind != INVALID_HANDLE_VALUE) {
      scope(exit) FindClose(hFind);

      do {
        if (cidrus.wcscmp(findData.cFileName.ptr, ".") == 0
          || cidrus.wcscmp(findData.cFileName.ptr, "..") == 0)
          continue;

        ткст рез = дайРезПоиска(userPath, findData);

        if ((includeDirs_ && папка_ли(findData)) 
          || (includeFiles_ && файл_ли(findData))) {
          if ((ret = действие(рез)) != 0)
            break;
        }
      } while (FindNextFile(hFind, findData));

      lastError = GetLastError();
    }

    if (lastError != ERROR_SUCCESS 
      && lastError != ERROR_NO_MORE_FILES 
      && lastError != ERROR_FILE_NOT_FOUND)
      ошибкаВВ(lastError, userPath);

    return ret;
  }

}

/**
 * Returns an iterable collection of папка names in the specified _path.
 */
Итератор!(ткст) перечислиПапки(ткст путь, ткст searchPattern = "*") {
  return перечислиИменаФСистемы(путь, searchPattern, false, true);
}

/**
 * Returns an iterable collection of file names in the specified _path.
 */
Итератор!(ткст) перечислиФайлы(ткст путь, ткст searchPattern = "*") {
  return перечислиИменаФСистемы(путь, searchPattern, true, false);
}

/**
 * Returns an iterable collection of file-system entries in the specified _path.
 */
Итератор!(ткст) перечислиЗаписиФСистемы(ткст путь, ткст searchPattern = "*") {
  return перечислиИменаФСистемы(путь, searchPattern, true, true);
}

private Итератор!(ткст) перечислиИменаФСистемы(ткст путь, ткст searchPattern, бул includeFiles, бул includeDirs) {
  return new ИтераторФСистемы(путь, searchPattern, includeFiles, includeDirs);
}