/**
 * Provides additional support for COM (Component Объект Model).
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.com.client;

//import win32.base.core: ИсклНеправильнОперации,;

import
  win32.com.core, win32.base.string,
  //win32.base.native,
  win32.utils.registry;
import tpl.traits : КортежТипаПараметр;
import cidrus: memcpy;
/**
 * Represents a late-bound COM object.
 *
 * Примеры:
 * Automating CDOSYS:
 * ---
 * // Create an экземпляр of the Message object
 * scope сообщение = new DispatchObject("CDO.Message");
 *
 * // Build the mail сообщение
 * сообщение.уст("Subject", "Hello, World!");
 * сообщение.уст("TextBody", "Just saying hello.");
 * сообщение.уст("From", "me@home.com"); // Replace 'me@home.com' with your email адрес
 * сообщение.уст("To", "world@large.com"); // Replace 'world@large.com' with the recipient's email адрес
 *
 * // Configure CDOSYS to шли via a remote SMTP server
 * scope config = сообщение.дай("Configuration");
 * // Set the appropriate значения
 * config.уст("Fields", "http://schemas.microsoft.com/cdo/configuration/sendusing", 2); // cdoSendUsingPort = 2
 * config.уст("Fields", "http://schemas.microsoft.com/cdo/configuration/smtpserverport", 25);
 * config.уст("Fields", "http://schemas.microsoft.com/cdo/configuration/smtpserver", "mail.remote.com"); // Replace 'mail.remote.com' with your remote server's адрес
 * config.уст("Fields", "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate", 1); // cdoBasic = 1
 * config.уст("Fields", "http://schemas.microsoft.com/cdo/configuration/sendusername", "username"); // Replace 'username' with your account's user имя
 * config.уст("Fields", "http://schemas.microsoft.com/cdo/configuration/sendpassword", "password"); // Replace 'password' with your account's password
 *
 * scope поля = config.дай("Fields");
 * поля.call("Update");
 *
 * сообщение.call("Send");
 * ---
 * Automating Microsoft Office Excel:
 * ---
 * проц main() {
 *   // Create an экземпляр of the Excel application object and уст the Visible property to true.
 *   scope excel = new DispatchObject("Excel.Приложение");
 *   excel.уст("Visible", true);
 *
 *   // Get the Workbooks property, then call the Add метод.
 *   scope workbooks = excel.дай("Workbooks");
 *   scope workbook = workbooks.call("Add");
 *
 *   // Get the Worksheet at индекс 1, then уст the Cells at column 5, row 3 to a ткст.
 *   scope worksheet = excel.дай("Worksheets", 1);
 *   worksheet.уст("Cells", 5, 3, "данные");
 * }
 * ---
 * Automating Интернет Explorer:
 * ---
 * abstract final class InternetExplorer {
 *
 *   static class Приложение : DispatchObject {
 *
 *     this() {
 *       super("InternetExplorer.Приложение");
 *     }
 *
 *     проц visible(бул значение) {
 *       уст("Visible", значение);
 *     }
 *
 *     бул visible() {
 *       return дай!(бул)("Visible");
 *     }
 *
 *     проц navigate(ткст url) {
 *       call("Navigate", url);
 *     }
 *
 *   }
 *
 * }
 *
 * проц main() {
 *   scope ie = new InternetExplorer.Приложение;
 *   ie.visible = true;
 *   ie.navigate("www.google.com");
 * }
 * ---
 */
class DispatchObject {

  private IDispatch target_;
  private VARIANT result_;

  /**
   */
  this(Guid clsid, ExecutionContext context = ExecutionContext.InProcessServer | ExecutionContext.LocalServer) {
    target_ = coCreate!(IDispatch)(clsid, context);
    if (target_ is null)
      throw new ИсклНеправильнОперации;
  }

  /**
   */
  this(Guid clsid, ткст server, ExecutionContext context = ExecutionContext.InProcessServer | ExecutionContext.RemoteServer) {
    target_ = coCreateEx!(IDispatch)(clsid, server, context);
    if (target_ is null)
      throw new ИсклНеправильнОперации;
  }

  /**
   */
  this(ткст progId, ExecutionContext context = ExecutionContext.InProcessServer | ExecutionContext.LocalServer) {
    target_ = coCreate!(IDispatch)(progId, context);
    if (target_ is null)
      throw new ИсклНеправильнОперации;
  }

  /**
   */
  this(ткст progId, ткст server, ExecutionContext context = ExecutionContext.InProcessServer | ExecutionContext.RemoteServer) {
    target_ = coCreateEx!(IDispatch)(progId, server, context);
    if (target_ is null)
      throw new ИсклНеправильнОперации;
  }

  /**
   */
  this(IDispatch цель) {
    if (цель is null)
      throw new ИсклНулевогоАргумента("цель");

    цель.AddRef();
    target_ = цель;
  }

  /**
   * ditto
   */
  this(VARIANT цель) {
    if (auto цель = com_cast!(IDispatch)(рез)) {
      target_ = цель;
    }
  }

  private this(VARIANT рез, бцел ignore) {
    if (auto цель = com_cast!(IDispatch)(рез)) {
      target_ = цель;
    }
    result_ = рез;
  }

  ~this() {
    отпусти();
  }

  /**
   */
  final проц отпусти() {
    if (!(result_.isNull || result_.пуст_ли))
      result_.сотри();

    if (target_ !is null) {
      tryRelease(target_);
      target_ = null;
    }
  }

  /**
   */
  R call(R = DispatchObject)(ткст имя, ...) {
    static if (is(R == DispatchObject)) {
      return new DispatchObject(invokeMethod(target_, имя, _arguments, _argptr), 0);
    }
    else {
      R ret = invokeMethod!(R)(target_, имя, _arguments, _argptr);
      result_ = ret;
      return ret;
    }
  }

  /**
   */
  R дай(R = DispatchObject)(ткст имя, ...) {
    static if (is(R == DispatchObject)) {
      return new DispatchObject(getProperty(target_, имя, _arguments, _argptr), 0);
    }
    else {
      R ret = getProperty!(R)(target_, имя, _arguments, _argptr);
      result_ = ret;
      return ret;
    }
  }

  /**
   */
  проц уст(ткст имя, ...) {
    setProperty(target_, имя, _arguments, _argptr);
  }

  /**
   */
  проц setRef(ткст имя, ...) {
    setRefProperty(target_, имя, _arguments, _argptr);
  }

  /**
   */
  final IDispatch цель() {
    return target_;
  }

  /**
   */
  final VARIANT рез() {
    return result_;
  }

}

/**
 */
class EventCookie(T) {

  private IConnectionPoint cp_;
  private бцел cookie_;

  /**
   */
  this(IUnknown исток) {
    auto cpc = com_cast!(IConnectionPointContainer)(исток);
    if (cpc !is null) {
      scope(exit) tryRelease(cpc);

      if (cpc.FindConnectionPoint(uuidof!(T), cp_) != S_OK)
        throw new ИсклАргумента("Source object does not expose '" ~ T.stringof ~ "' событие interface.");
    }
  }

  ~this() {
    disconnect();
  }

  /**
   */
  проц connect(IUnknown sink) {
    if (cp_.Advise(sink, cookie_) != S_OK) {
      cookie_ = 0;
      tryRelease(cp_);
      throw new ИсклНеправильнОперации("Could not Advise() the событие interface '" ~ T.stringof ~ "'.");
    }

    if (cp_ is null || cookie_ == 0) {
      if (cp_ !is null)
        tryRelease(cp_);
      throw new ИсклАргумента("Connection point for событие interface '" ~ T.stringof ~ "' cannot be создан.");
    }
  }

  /**
   */
  проц disconnect() {
    if (cp_ !is null && cookie_ != 0) {
      try {
        cp_.Unadvise(cookie_);
      }
      finally {
        tryRelease(cp_);
        cp_ = null;
        cookie_ = 0;
      }
    }
  }

}

private struct MethodProxy {

  цел delegate() метод;
  VARTYPE типВозврата;
  VARTYPE[] paramTypes;

  static MethodProxy opCall(R, T...)(R delegate(T) метод) {
    MethodProxy сам;
    сам = метод;
    return сам;
  }

  проц opAssign(R, T...)(R delegate(T) дг) {
    alias КортежТипаПараметр!(дг) парамы;

    метод = cast(цел delegate())дг;
    типВозврата = VariantType!(R);
    paramTypes.length = парамы.length;
    foreach (i, paramType; парамы) {
      paramTypes[i] = VariantType!(paramType);
    }
  }

  цел вызови(VARIANT*[] арги, VARIANT* рез) {

    т_мера variantSize(VARTYPE vt) {
      switch (vt) {
        case VT_UI8, VT_I8, VT_CY:
          return дол.sizeof / цел.sizeof;
        case VT_R8, VT_DATE:
          return дво.sizeof / цел.sizeof;
        case VT_VARIANT:
          return (VARIANT.sizeof + 3) / цел.sizeof;
        default:
      }

      return 1;
    }

    // Like DispCallFunc, but используя delegates

    т_мера paramCount;
    for (цел i = 0; i < paramTypes.length; i++) {
      paramCount += variantSize(paramTypes[i]);
    }

    auto argptr = cast(цел*)HeapAlloc(GetProcessHeap(), 0, paramCount * цел.sizeof);

    бцел поз;
    for (цел i = 0; i < paramTypes.length; i++) {
      VARIANT* p = арги[i];
      if (paramTypes[i] == VT_VARIANT)
        memcpy(&argptr[поз], p, variantSize(paramTypes[i]) * цел.sizeof);
      else
        memcpy(&argptr[поз], &p.lVal, variantSize(paramTypes[i]) * цел.sizeof);
      поз += variantSize(paramTypes[i]);
    }

    цел ret = 0;

    switch (paramCount) {
      case 0: ret = метод(); break;
      case 1: ret = (cast(цел delegate(цел))метод)(argptr[0]); break;
      case 2: ret = (cast(цел delegate(цел, цел))метод)(argptr[0], argptr[1]); break;
      case 3: ret = (cast(цел delegate(цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2]); break;
      case 4: ret = (cast(цел delegate(цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3]); break;
      case 5: ret = (cast(цел delegate(цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4]); break;
      case 6: ret = (cast(цел delegate(цел, цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5]); break;
      case 7: ret = (cast(цел delegate(цел, цел, цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6]); break;
      case 8: ret = (cast(цел delegate(цел, цел, цел, цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7]); break;
      case 9: ret = (cast(цел delegate(цел, цел, цел, цел, цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8]); break;
      case 10: ret = (cast(цел delegate(цел, цел, цел, цел, цел, цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9]); break;
      case 11: ret = (cast(цел delegate(цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10]); break;
      case 12: ret = (cast(цел delegate(цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11]); break;
      case 13: ret = (cast(цел delegate(цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12]); break;
      case 14: ret = (cast(цел delegate(цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12], argptr[13]); break;
      case 15: ret = (cast(цел delegate(цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12], argptr[13], argptr[14]); break;
      case 16: ret = (cast(цел delegate(цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12], argptr[13], argptr[14], argptr[15]); break;
      case 17: ret = (cast(цел delegate(цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12], argptr[13], argptr[14], argptr[15], argptr[16]); break;
      case 18: ret = (cast(цел delegate(цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12], argptr[13], argptr[14], argptr[15], argptr[16], argptr[17]); break;
      case 19: ret = (cast(цел delegate(цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12], argptr[13], argptr[14], argptr[15], argptr[16], argptr[17], argptr[18]); break;
      case 20: ret = (cast(цел delegate(цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел, цел))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12], argptr[13], argptr[14], argptr[15], argptr[16], argptr[17], argptr[18], argptr[19]); break;
      default:
        return DISP_E_BADPARAMCOUNT;
    }

    if (рез !is null && типВозврата != VT_VOID) {
      рез.vt = типВозврата;
      рез.lVal = ret;
    }

    HeapFree(GetProcessHeap(), 0, argptr);
    return S_OK;
  }

}

/**
 */
class EventProvider(T) : Реализует!(T) {

  extern(D):

  private MethodProxy[цел] methodTable_;
  private цел[ткст] nameTable_;

  private IConnectionPoint connectionPoint_;
  private бцел cookie_;

  /**
   */
  this(IUnknown исток) {
    auto cpc = com_cast!(IConnectionPointContainer)(исток);
    if (cpc !is null) {
      scope(exit) tryRelease(cpc);

      if (cpc.FindConnectionPoint(uuidof!(T), connectionPoint_) != S_OK)
        throw new ИсклАргумента("Source object does not expose '" ~ T.stringof ~ "' событие interface.");

      if (connectionPoint_.Advise(this, cookie_) != S_OK) {
        cookie_ = 0;
        tryRelease(connectionPoint_);
        throw new ИсклНеправильнОперации("Could not Advise() the событие interface '" ~ T.stringof ~ "'.");
      }
    }

    if (connectionPoint_ is null || cookie_ == 0) {
      if (connectionPoint_ !is null)
        tryRelease(connectionPoint_);
      throw new ИсклАргумента("Connection point for событие interface '" ~ T.stringof ~ "' cannot be создан.");
    }
  }

  ~this() {
    if (connectionPoint_ !is null && cookie_ != 0) {
      try {
        connectionPoint_.Unadvise(cookie_);
      }
      finally {
        tryRelease(connectionPoint_);
        connectionPoint_ = null;
        cookie_ = 0;
      }
    }
  }

  /**
   */
  проц bind(ID, R, P...)(ID член, R delegate(P) handler) {
    static if (is(ID : ткст)) {
      бул found;
      цел dispId = DISPID_UNKNOWN;
      if (tryFindDispId(член, dispId))
        bind(dispId, handler);
      else
        throw new ИсклАргумента("Член '" ~ член ~ "' not found in тип '" ~ T.stringof ~ "'.");
    }
    else static if (is(ID : цел)) {
      MethodProxy m = handler;
      methodTable_[член] = m;
    }
  }

  private бул tryFindDispId(ткст имя, out цел dispId) {

    проц ensureNameTable() {
      if (nameTable_ == null) {
        scope clsidKey = RegistryKey.classesRoot.openSubKey("Интерфейс\\" ~ uuidof!(T).вТкст("P"));
        if (clsidKey !is null) {
          scope typeLibRefKey = clsidKey.openSubKey("TypeLib");
          if (typeLibRefKey !is null) {
            ткст typeLibVersion = typeLibRefKey.дайЗначение!(ткст)("Версия");
            if (typeLibVersion == null) {
              scope versionKey = clsidKey.openSubKey("Версия");
              if (versionKey !is null)
                typeLibVersion = versionKey.дайЗначение!(ткст)(null);
            }

            scope typeLibKey = RegistryKey.classesRoot.openSubKey("TypeLib\\" ~ typeLibRefKey.дайЗначение!(ткст)(null));
            if (typeLibKey !is null) {
              scope pathKey = typeLibKey.openSubKey(typeLibVersion ~ "\\0\\Win32");
              if (pathKey !is null) {
                ITypeLib типБиб;
                if (LoadTypeLib(pathKey.дайЗначение!(ткст)(null).вУтф16н(), типБиб) == S_OK) {
                  scope(exit) tryRelease(типБиб);

                  ITypeInfo инфОТипе;
                  if (типБиб.GetTypeInfoOfGuid(uuidof!(T), инфОТипе) == S_OK) {
                    scope(exit) tryRelease(инфОТипе);

                    TYPEATTR* typeAttr;
                    if (инфОТипе.GetTypeAttr(typeAttr) == S_OK) {
                      scope(exit) инфОТипе.ReleaseTypeAttr(typeAttr);

                      for (бцел i = 0; i < typeAttr.cFuncs; i++) {
                        FUNCDESC* funcDesc;
                        if (инфОТипе.GetFuncDesc(i, funcDesc) == S_OK) {
                          scope(exit) инфОТипе.ReleaseFuncDesc(funcDesc);

                          шим* bstrName;
                          if (инфОТипе.GetDocumentation(funcDesc.memid, &bstrName, null, null, null) == S_OK) {
                            ткст memberName = изБткст(bstrName);
                            nameTable_[memberName.вПроп()] = funcDesc.memid;
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    dispId = DISPID_UNKNOWN;

    ensureNameTable();

    if (auto значение = имя.вПроп() in nameTable_) {
      dispId = *значение;
      return true;
    }

    return false;
  }

  extern(Windows):

  override цел Invoke(цел dispIdMember, ref GUID riid, бцел лкид, бкрат wFlags, DISPPARAMS* pDispParams, VARIANT* pVarResult, EXCEPINFO* pExcepInfo, бцел* puArgError) {
    if (riid != GUID.пустой)
      return DISP_E_UNKNOWNINTERFACE;

    try {
      if (auto handler = dispIdMember in methodTable_) {
        VARIANT*[8] арги;
        for (цел i = 0; i < handler.paramTypes.length && i < 8; i++) {
          арги[i] = &pDispParams.rgvarg[handler.paramTypes.length - i - 1];
        }

        VARIANT рез;
        if (pVarResult == null)
          pVarResult = &рез;

        цел hr = handler.вызови(арги, pVarResult);

        for (цел i = 0; i < handler.paramTypes.length; i++) {
          if (арги[i].vt == (VT_BYREF | VT_BOOL)) {
            // Fix bools to VARIANT_BOOL
            *арги[i].pboolVal = (*арги[i].pboolVal == 0) ? VARIANT_FALSE : VARIANT_TRUE;
          }
        }

        return hr;
      }
      else
        return DISP_E_MEMBERNOTFOUND;
    }
    catch {
      return E_FAIL;
    }

    return S_OK;
  }

}