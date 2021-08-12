module win32.utils.process;

import win32.base.core,
  win32.base.string,
  win32.base.threading,
  win32.base.native, //winapi,
  win32.com.core,
  win32.sec.crypto;
static import win32.io.path;
import cidrus : malloc, realloc, free;

//alias HANDLE Укз;
extern(Windows){ цел CloseHandle(Укз hObject);
бцел GetCurrentProcessId();}

debug import stdrus : скажифнс;

private extern(C) цел _wcsicmp(in шим*, in шим*);

private class ProcessInfo {

  бцел processId;
  ткст processName;

}

class ProcessStart {

  ткст имяф;
  ткст arguments;
  ткст userName;
  ткст password;
  ткст domain;
  бул useShellExecute = true;

  this() {
  }

  this(ткст имяф, ткст arguments) {
    this.имяф = имяф;
    this.arguments = arguments;
  }

}

class Process {

  private Опционал!(Укз) handle_;
  private ткст machineName_;
  private бул isRemote_;
  private Опционал!(бцел) id_;
  private ткст processName_;
  private ProcessInfo processInfo_;

  // Process.start parameters
  ProcessStart start_;

  this() {
    machineName_ = ".";
  }

  private this(ткст machineName, бул isRemote, бцел ид, ProcessInfo processInfo) {
    machineName_ = machineName;
    isRemote_ = isRemote;
    id_ = ид;
    processInfo_ = processInfo;
  }

  ~this() {
    закрой();
  }

  final проц закрой() {
    if (handle_.hasValue && (handle_.значение != Укз.init)) {
      CloseHandle(handle_.значение);
      // Re-иниц so handle_.hasValue returns false.
      //handle_ = (Опционал!(Укз)).init;
    }
    processInfo_ = null;
  }

  static Process start(ткст имяф) {
    return start(имяф, null);
  }

  static Process start(ткст имяф, ткст arguments) {
    return start(new ProcessStart(имяф, arguments));
  }

  static Process start(ProcessStart start) {
    auto process = new Process;
    process.start_ = start;
    if (process.start())
      return process;
    return null;
  }

  final бул start() {
    закрой();

    if (start_.useShellExecute) {
      SHELLEXECUTEINFO sei;
      sei.fMask = SEE_MASK_NOCLOSEPROCESS | SEE_MASK_FLAG_NO_UI | SEE_MASK_FLAG_DDEWAIT;
      sei.nShow = /*SW_SHOWNORMAL*/ 1;

      sei.lpFile = start_.имяф.вУтф16н();
      sei.lpParameters = start_.arguments.вУтф16н();

      if (!ShellExecuteEx(sei))
        throw new Win32Exception;

      if (sei.hProcess != Укз.init) {
        handle_ = sei.hProcess;
        return true;
      }

      return false;
    }

    STARTUPINFO startupInfo;
    PROCESS_INFORMATION processInfo;
    Укз processHandle;

    ткст commandLine = "\"" ~ start_.имяф ~ "\"";
    if (start_.arguments != null)
      commandLine ~= " " ~ start_.arguments;
    auto pCommandLine = commandLine.вУтф16н();
    auto pWorkingDirectory = win32.io.path.текПапка().вУтф16н();
    бцел creationFlags = 0;

    /*if (start_.userName != null) {
      шим* pPassword;
      if (start_.password !is null)
        pPassword = secureStringToUnicode(start_.password);

      бцел logonFlags = 0;
      if (!CreateProcessWithLogonW(start_.userName.вУтф16н(), pPassword, start_.domain.вУтф16н(), logonFlags, null, pCommandLine, creationFlags, null, pWorkingDirectory, &startupInfo, &processInfo))
        throw new Win32Exception;

      processHandle = processInfo.hProcess;
      // Not interested in the returned thread.
      CloseHandle(processInfo.hThread);

      if (pPassword != null)
        CoTaskMemFree(pPassword);
    }
    else*/ {
      if (!CreateProcess(null, pCommandLine, null, null, TRUE, creationFlags, null, pWorkingDirectory, startupInfo, processInfo))
        throw new Win32Exception;

      processHandle = processInfo.hProcess;
      // Not interested in the returned thread.
      CloseHandle(processInfo.hThread);
    }

    if (processHandle != Укз.init) {
      handle_ = processHandle;
      id_ = processInfo.dwProcessId;
    }
    return false;
  }

  final проц kill() {
    ensureProcessId();

    Укз указатель;
    if (!handle_.hasValue) {
      указатель = OpenProcess(PROCESS_TERMINATE, FALSE, id_.значение);
      if (handle_.значение == Укз.init)
        throw new Win32Exception;
    }
    else {
      /*Укз waitHandle;
      DuplicateHandle(GetCurrentProcess(), handle_.значение, GetCurrentProcess(), waitHandle, 0, FALSE, DUPLICATE_SAME_ACCESS);
      WaitForSingleObjectEx(waitHandle, 0, 1);
      CloseHandle(waitHandle);*/

      указатель = handle_.значение;
    }
    if (!TerminateProcess(указатель, -1))
      throw new Win32Exception;
    CloseHandle(указатель);
  }

  static Process текущ() {
    return new Process(".", false, GetCurrentProcessId(), null);
  }

  static Process[] getProcesses() {
    auto processInfos = getProcessInfos();
    auto processes = new Process[processInfos.length];

    foreach (i, processInfo; processInfos)
      processes[i] = new Process(".", false, processInfo.processId, processInfo);

    return processes;
  }

  private проц ensureProcessId() {
    if (!id_.hasValue) {
      PROCESS_BASIC_INFORMATION info;
      цел status = NtQueryInformationProcess(handle_.значение, PROCESS_INFORMATION_CLASS.ProcessBasicInformation, &info, info.sizeof, null);
      if (status != 0)
        throw new ИсклНеправильнОперации;

      id_ = info.uniqueProcessId;
    }
  }

  private проц ensureProcessInfo() {
    ensureProcessId();

    if (processInfo_ is null) {
      auto processInfos = getProcessInfos();
      foreach (processInfo; processInfos) {
        if (processInfo.processId == id_.значение) {
          processInfo_ = processInfo;
          break;
        }
      }
    }
  }

  final Укз указатель() {
    ensureProcessId();

    if (!handle_.hasValue) {
      handle_ = OpenProcess(PROCESS_ALL_ACCESS, FALSE, id_.значение);
      if (handle_.значение == Укз.init)
        throw new Win32Exception;
    }
    return handle_.значение;
  }

  final ткст processName() {
    if (processName_ == null) {
      ensureProcessInfo();
      return processInfo_.processName;
    }
    return processName_;
  }

  final ткст machineName() {
    return machineName_;
  }

  final бцел ид() {
    ensureProcessId();
    return id_.значение;
  }

  private static ProcessInfo[] getProcessInfos() {

    ткст getProcessName(шим* имя, бцел length) {
      шим* str = имя, period = имя, slash = имя;

      цел i;
      while (*str != 0) {
        if (*str == '.') period = str;
        if (*str == '\\') slash = str;
        str++, i++;
        if (i >= length)
          break;
      }

      if (period == имя) period = str;
      else if (_wcsicmp(period, ".exe") != 0) period = str;

      if (*slash == '\\') slash++;

      return вУтф8(slash, 0, period - slash);
    }

    ProcessInfo[бцел] processInfos;

    бцел размБуфера = 128 * 1024;
    бцел neededSize;
    ббайт* буфер;

    цел status;
    do {
      буфер = cast(ббайт*)cidrus.realloc(буфер, размБуфера);
      status = NtQuerySystemInformation(SYSTEM_INFORMATION_CLASS.SystemProcessInformation, буфер, размБуфера, &neededSize);
      if (status == STATUS_INFO_LENGTH_MISMATCH)
        размБуфера = neededSize + 10 * 1024;
    } while (status == STATUS_INFO_LENGTH_MISMATCH);
    if (status < 0)
      throw new ИсклНеправильнОперации;

    scope(exit) free(буфер);

    цел смещение;
    while (true) {
      auto pProcessInfo = cast(SYSTEM_PROCESS_INFORMATION*)(буфер + смещение);

      auto processInfo = new ProcessInfo;
      processInfo.processId = cast(бцел)pProcessInfo.uniqueProcessId;
      if (pProcessInfo.nameBuffer != null)
        processInfo.processName = getProcessName(pProcessInfo.nameBuffer, pProcessInfo.nameLength / 2);

      processInfos[processInfo.processId] = processInfo;

      if (pProcessInfo.nextEntryOffset == 0)
        break;
      смещение += pProcessInfo.nextEntryOffset;
    }

    return processInfos.values;
  }

}

/+const ServiceControllerStatus {
  Stopped         = SERVICE_STOPPED,
  StartPending    = SERVICE_START_PENDING,
  StopPending     = SERVICE_STOP_PENDING,
  Running         = SERVICE_RUNNING,
  ContinuePending = SERVICE_CONTINUE_PENDING,
  PausePending    = SERVICE_PAUSE_PENDING,
  Paused          = SERVICE_PAUSED
}

class ServiceController {

  private Укз serviceManagerHandle_;
  private ткст name_;
  private ткст machineName_ = ".";
  private Опционал!(ServiceControllerStatus) status_;

  this() {
  }

  this(ткст имя) {
    name_ = имя;
  }

  this(ткст имя, ткст machineName) {
    name_ = имя;
    machineName_ = machineName;
  }

  final проц закрой() {
    if (serviceManagerHandle_ != Укз.init) {
      CloseServiceHandle(serviceManagerHandle_);
      serviceManagerHandle_ = Укз.init;
    }
  }

  final проц start(ткст[] арги = null) {
    ensureServiceManagerHandle();

    Укз serviceHandle = getServiceHandle(SERVICE_START);
    scope(exit) CloseServiceHandle(serviceHandle);

    auto pArgs = cast(шим**)LocalAlloc(LMEM_FIXED, арги.length * (шим*).sizeof);
    foreach (i, arg; арги)
      pArgs[i] = arg.вУтф16н();
    scope(exit) LocalFree(pArgs);

    if (StartService(serviceHandle, арги.length, pArgs) != TRUE)
      throw new Win32Exception;
  }

  final проц pause() {
    ensureServiceManagerHandle();

    Укз serviceHandle = getServiceHandle(SERVICE_PAUSE_CONTINUE);
    scope(exit) CloseServiceHandle(serviceHandle);

    SERVICE_STATUS status;
    if (ControlService(serviceHandle, SERVICE_CONTROL_PAUSE, status) != TRUE)
      throw new Win32Exception;
  }

  final проц stop() {
    ensureServiceManagerHandle();

    Укз serviceHandle = getServiceHandle(SERVICE_STOP);
    scope(exit) CloseServiceHandle(serviceHandle);

    SERVICE_STATUS status;
    if (ControlService(serviceHandle, SERVICE_CONTROL_STOP, status) != TRUE)
      throw new Win32Exception;
  }

  final проц refresh() {
    status_ = (Опционал!(ServiceControllerStatus)).init;
  }

  final проц waitForStatus(ServiceControllerStatus desiredStatus) {
    refresh();
    while (status != desiredStatus) {
      спи(250);
      refresh();
    }
  }

  final ткст serviceName() {
    return name_;
  }

  final ServiceControllerStatus status() {
    if (!status_.hasValue) {
      ensureServiceManagerHandle();

      Укз serviceHandle = getServiceHandle(SERVICE_QUERY_STATUS);
      scope(exit) CloseServiceHandle(serviceHandle);

      SERVICE_STATUS status;
      if (QueryServiceStatus(serviceHandle, status) != TRUE)
        throw new Win32Exception;
      status_ = cast(ServiceControllerStatus)status.dwCurrentState;
    }
    return status_.значение;
  }

  private проц ensureServiceManagerHandle() {
    if (serviceManagerHandle_ == Укз.init) {
      if (machineName_ == "." || machineName_ == null)
        serviceManagerHandle_ = OpenSCManager(null, null, SC_MANAGER_CONNECT);
      else
        serviceManagerHandle_ = OpenSCManager(machineName_.вУтф16н(), null, SC_MANAGER_CONNECT);

      if (serviceManagerHandle_ == Укз.init)
        throw new Win32Exception;
    }
  }

  private Укз getServiceHandle(бцел access) {
    ensureServiceManagerHandle();
    Укз serviceHandle = OpenService(serviceManagerHandle_, serviceName().вУтф16н(), access);
    if (serviceHandle == Укз.init)
      throw new Win32Exception;
    return serviceHandle;
  }

}+/