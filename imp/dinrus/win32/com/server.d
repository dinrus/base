/**
 * Contains boiler-plate code for creating a COM _server (a DLL that exports COM classes).
 * Примеры:
 * ---
 * --- hello.d ---
 * module hello;
 *
 * // This is the interface.
 *
 * private import win32.com.all;
 *
 * interface ISaysHello : IUnknown {
 *   mixin(ууид("ae0dd4b7-e817-44ff-9e11-d1cffae11f16"));
 *
 *   цел sayHello();
 * }
 *
 * // coclass
 * abstract class SaysHello {
 *   mixin(ууид("35115e92-33f5-4e14-9d0a-bd43c80a75af"));
 *
 *   mixin Интерфейсы!(ISaysHello);
 * }
 * ---
 *
 * ---
 * --- server.d ---
 * module server;
 *
 * // This is the DLL's private implementation.
 *
 * import win32.com.all, win32.utils.registry, hello;
 *
 * mixin Экспорт!(SaysHelloClass);
 *
 * // Реализует ISaysHello
 * class SaysHelloClass : Реализует!(ISaysHello) {
 *   // Note: must have the same CLSID as the SaysHello coclass above.
 *   mixin(ууид("35115e92-33f5-4e14-9d0a-bd43c80a75af"));
 *
 *   цел sayHello() {
 *     скажинс("Hello there!");
 *     return S_OK;
 *   }
 *
 * }
 * ---
 *
 * ---
 * --- client.d ---
 * module client;
 *
 * import win32.com.core, hello;
 *
 * проц main() {
 *   ISaysHello saysHello = SaysHello.coCreate!(ISaysHello);
 *   saysHello.sayHello(); // Prints "Hello there!"
 *   saysHello.Release();
 * }
 * ---
 *
 * The COM _server needs to be registered with the system. Usually, a CLSID is associated with the DLL in the registry 
 * (under HKEY_CLASSES_ROOT\CLSID). On Windows XP and above, an alternative is to deploy an application manifest in the same folder 
 * as the client application. This is an XML file that does the same thing as the registry метод. Here's an Пример:
 *
 * ---
 * --- client.exe.manifest ---
 * <?xml version="1.0" кодировка="utf-8" standalone="yes"?>
 * <assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
 *   <assemblyIdentity имя="client.exe" version="1.0.0.0" тип="win32"/>
 *   <file имя="C:\\Program Files\\My COM Server\\server.dll">
 *     <comClass clsid="{35115e92-33f5-4e14-9d0a-bd43c80a75af}" описание="SaysHello" threadingModel="Apartment"/>
 *  </file>
 * </assembly>
 *
 * ---
 * Alternatively, define a static register and unregister метод on each coclass implementation. If the methods exist, the DLL will 
 * register itself in the registry when 'regsvr32' is executed, and unregister itself on 'regsvr32 /u'.
 *
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 *
 */
module win32.com.server;

import //win32.base.core,
  win32.base.string,
 // win32.base.native,
  win32.com.core;

extern (C) проц gc_init();
extern (C) проц gc_term();
extern (C) проц _minit();
extern (C) проц _moduleCtor();
extern (C) проц _moduleDtor();
extern (C) проц _moduleUnitTests();

private Укз moduleHandle_;
private цел lockCount_;
private ткст location_;

///
Укз getHInstance() {
  return moduleHandle_;
}

///
проц setHInstance(Укз значение) {
  moduleHandle_ = значение;
}

///
ткст getLocation() {
  if (location_ == null) {
    шим[MAX_PATH] буфер;
    бцел len = GetModuleFileName(moduleHandle_, буфер.ptr, буфер.length);
    location_ = win32.base.string.вУтф8(буфер.ptr, 0, len);
  }
  return location_;
}

///
цел getLockCount() {
  return lockCount_;
}

///
проц lock() {
  InterlockedIncrement(lockCount_);
}

///
проц unlock() {
  InterlockedDecrement(lockCount_);
}

///
class ClassFactory(T) : Реализует!(IClassFactory) {

  цел CreateInstance(IUnknown pUnkOuter, ref GUID riid, ук* ppvObject) {
    if (pUnkOuter !is null && riid != uuidof!(IUnknown))
      return CLASS_E_NOAGGREGATION;

    ppvObject = null;
    цел hr = E_OUTOFMEMORY;

    T объ = new T;
    if (объ !is null) {
      hr = объ.QueryInterface(riid, ppvObject);
      объ.Release();
    }
    return hr;
  }

  цел LockServer(цел fLock) {
    if (fLock)
      lock();
    else
      unlock();
    return S_OK;
  }

}

///
template Экспорт(T...) {

  extern(Windows) цел DllMain(Укз hInstance, бцел dwReason, ук pvReserved) {
    if (dwReason == 1 /*DLL_PROCESS_ATTACH*/) {
      setHInstance(hInstance);

      gc_init();
      _minit();
      _moduleCtor();

      return 1;
    }
    else if (dwReason == 0 /*DLL_PROCESS_DETACH*/) {
      gc_term();
      return 1;
    }
    return 0;
  }

  extern(Windows)
  цел DllGetClassObject(ref GUID rclsid, ref GUID riid, ук* ppv) {
    цел hr = CLASS_E_CLASSNOTAVAILABLE;
    *ppv = null;

    foreach (coclass; T) {
      if (rclsid == uuidof!(coclass)) {
        IClassFactory factory = new ClassFactory!(coclass);
        if (factory is null)
          return E_OUTOFMEMORY;
        scope(exit) tryRelease(factory);

        hr = factory.QueryInterface(riid, ppv);
      }
    }

    return hr;
  }

  extern(Windows)
  цел DllCanUnloadNow() {
    return (getLockCount() == 0) ? S_OK : S_FALSE;
  }

  бул registerCoClass(СоКласс)() {
    бул success;

    try {
      scope clsidKey = RegistryKey.classesRoot.createSubKey("CLSID\\" ~ uuidof!(СоКласс).вТкст("P"));
      if (clsidKey !is null) {
        clsidKey.setValue!(ткст)(null, СоКласс.classinfo.имя ~ " Class");

        scope subKey = clsidKey.createSubKey("InprocServer32");
        if (subKey !is null) {
          subKey.setValue!(ткст)(null, getLocation());
          subKey.setValue!(ткст)("ThreadingModel", "Apartment");

          scope progIDSubKey = clsidKey.createSubKey("ProgID");
          if (progIDSubKey !is null) {
            progIDSubKey.setValue!(ткст)(null, СоКласс.classinfo.имя);

            scope progIDKey = RegistryKey.classesRoot.createSubKey(СоКласс.classinfo.имя);
            if (progIDKey !is null) {
              progIDKey.setValue!(ткст)(null, СоКласс.classinfo.имя ~ " Class");

              scope clsidSubKey = progIDKey.createSubKey("CLSID");
              if (clsidSubKey !is null)
                clsidSubKey.setValue!(ткст)(null, uuidof!(СоКласс).вТкст("P"));
            }
          }
        }
      }

      success = true;
    }
    catch {
      success = false;
    }

    return success;
  }

  бул unregisterCoClass(СоКласс)() {
    бул success;

    try {
      scope clsidKey = RegistryKey.classesRoot.openSubKey("CLSID");
      if (clsidKey !is null)
        clsidKey.deleteSubKeyTree(uuidof!(СоКласс).вТкст("P"));

      RegistryKey.classesRoot.deleteSubKeyTree(СоКласс.classinfo.имя);

      success = true;
    }
    catch {
      success = false;
    }

    return success;
  }

  extern(Windows) цел DllRegisterServer() {
    бул success;

    foreach (coclass; T) {
      static if (is(typeof(coclass.register))) {
        static assert(is(typeof(coclass.unregister)), "'register' must be matched by a corresponding 'unregister' in '" ~ coclass.stringof ~ "'.");

        success = registerCoClass!(coclass)();
        coclass.register();
      }
    }

    return success ? S_OK : SELFREG_E_CLASS;
  }

  extern(Windows) цел DllUnregisterServer() {
    бул success;

    foreach (coclass; T) {
      static if (is(typeof(coclass.unregister))) {
        static assert(is(typeof(coclass.register)), "'unregister' must be matched by a corresponding 'register' in '" ~ coclass.stringof ~ "'.");

        success = unregisterCoClass!(coclass)();
        coclass.unregister();
      }
    }

    return success ? S_OK : SELFREG_E_CLASS;
  }

}