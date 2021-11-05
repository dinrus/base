module sys.com.com;

import sys.Common, tpl.com, tpl.args, stdrus; 
////////////////////////////////////////////////////
export extern(C)
{
	бул комАктивен(); 
	проц откройКОМ();
	проц закройКОМ() ;
	ткст прогИдИзКлсид(ГУИД клсид);
	ГУИД клсидИзПрогИд(ткст прогИд);
	Исключение исклКомРез(цел кодОшибки);
	проц ошибкаКомРез(цел кодОшибки);
	ДЕСЯТОК дес(ткст т);
	
	/**
	 * Размещает эквивалент BSTR в s.
	 * Параметры: s = Текст, инициализирующий BSTR.
	 * Возвращает: BSTR, эквивалентный s.
	 */
	 шим* вБткст(ткст s);

	/**
	 * Преобразует BSTR в ткст, дополнительно высвобождая исходный BSTR.
	 * Параметры: бткст = преобразуемый BSTR.
	 * Возвращает: ткст, эквивалентный бткст.
	 */
	 ткст бткстВТкст(шим* s, бул высвободить = true);

	/**
	 * Освобождает память, занятую под указанный BSTR.
	 * Параметры: бткст = Высвобождаемый BSTR.
	 */
	 проц высвободиБткст(шим* s);

	 бцел длинаБткст(шим* s);

	/**
	 * Создаёт объект класса, связанного с указанным ГУИДом.
	 * Параметры:
	 *   клсид = Класс, ассоциированный с объектом.
	 *   внешний = Если null, это указывает на то, что объект не созtrueётся как часть агрегата.
	 *   контекст = Контекст, в котором будет выполняться управляющий объектом код.
	 *   иид = Идентификатор интерфейса, который будет использован для коммуникации с объектом.
	 * Возвращает: Затребованный объект.
	 * See_Also: $(LINK2 http://msdn.microsoft.com/en-us/library/ms686615.aspx, СоздайЭкземплярКо).
	 */
	Инкогнито создайЭкземплярКо(ГУИД клсид,Инкогнито внешний, ПКонтекстВып контекст,ГУИД иид);

	/**
	 * Возвращает ссылку на выполняемый объект, зарегестрированный в OLE.
	 * See_Also: $(LINK2 http://msdn2.microsoft.com/en-us/library/ms221467.aspx, ДайАктивныйОбъект).
	 */
	Инкогнито дайАктивныйОбъект(ткст прогИд);


	/**
	 * Показывает, представляет ли собой заданный объект COM-объект.
	 * Параметры: объ = Проверяемый объект.
	 * Возвращает: true, если объект COM типа; в противном случае - false.
	 */
	 бул объектКОМ_ли(Объект объ);

}
/////////////////////////////////////////

 проц высвободиПосле(Инкогнито объ, проц delegate() блокируй) ;


 проц сотриПосле(ВАРИАНТ var, проц delegate() блокируй);

/**
 * Уменьшает счёт ссылок для объекта.
 */
  проц пробуйСброс(Инкогнито объ) ;

/**
 * Уменьшает счёт ссылок для объекта, пока он не сравняется с 0.
 */
 проц финальныйСброс(Инкогнито объ) ;



/**
 * Оборачивает "вручную" рассчитывающий ссылки объект, производный от Инкогнито, 
 * при этом его памятью можно управлять автоматически рантаймным СМ Ди.
 */
extern(D) class КомОбъект
 {

  /**
   * Инициализует новый экземпляр указанным призводным от Инкогнито объектом.
   * Параметры: объ = Оборачиваемый объект.
   */
  this(Инкогнито объ);

  ~this() ;

  /**
   * Выводит исходный производный от Инкогнито объект.
   * Возвращает: Обернутый объект.
   */
 Инкогнито opCast() ;

}


/**
 * Вызывает указанный член указанного объекта.
 * Параметры:
 *   dispId = Идентификатор вызываемого члена-метоtrue или - объекта.
 *   флаги = Тип вызываемого члена.
 *   цель = Объект, у которого trueнный член будет вызываться.
 *   арги = Список с аргументами, переtrueваемыми вызываемому члену.
 * Возвращает: Возвратное значение от вызываемого члена.
 * Выводит исключение: ИсклКОМ, если вызов не удался.
 */
ВАРИАНТ вызовиЧленПоИду(цел dispId, ПДиспачФлаг флаги, ИДиспетчер цель,ВАРИАНТ[] арги...);


/**
 * Invokes the specified member on the specified object.
 * Параметры:
 *   имя = The _name of the метод or property member to invoke.
 *   флаги = The тип of member to invoke.
 *   цель = The object on which to invoke the specified member.
 *   арги = A список containing the arguments to pass to the member to invoke.
 * Возвращает: The return value of the invoked member.
 * Выводит исключение: ИсклНедостающЧлена if the member is not found.
 */
ВАРИАНТ вызовиЧлен(ткст имя, ПДиспачФлаг флаги, ИДиспетчер цель,ВАРИАНТ[] арги...) ;

ВАРИАНТ[] аргиВВариантСписок(ИнфОТипе[] типы, спис_ва аргук);

проц фиксАрги(ref ИнфОТипе[] арги, ref спис_ва аргук) ;

/**
 * Invokes the specified метод on the specified object.
 * Параметры:
 *   цель = The object on which to invoke the specified метод.
 *   имя = The _name of the метод to invoke.
 *   _argptr = A список containing the arguments to pass to the метод to invoke.
 * Возвращает: The return value of the invoked метод.
 * Выводит исключение: ИсклНедостающЧлена if the метод is not found.
 * Примеры:
 * ---
 * import com.com;
 *
 * проц main() {
 *   auto ieApp = создайКо!(ИДиспетчер)("InternetExplorer.Application");
 *   вызовиМетод(ieApp, "Navigate", "http://www.amazon.co.uk");
 * }
 * ---
 */
R вызовиМетод(R = ВАРИАНТ)(ИДиспетчер цель, ткст имя, ...) {
  auto арги = _arguments;
  auto аргук = _argptr;
  if (арги.length == 2) фиксАрги(арги, аргук);

 ВАРИАНТ рез = вызовиЧлен(имя, ПДиспачФлаг.ВызватьМетод, цель, аргиВВариантСписок(арги, аргук));
  static if (is(R == ВАРИАНТ)) {
    return рез;
  }
  else {
    return ком_каст!(R)(рез);
  }
}

/**
 * Gets the value of the specified property on the specified object.
 * Параметры:
 *   цель = The object on which to invoke the specified property.
 *   имя = The _name of the property to invoke.
 *   _argptr = A список containing the arguments to pass to the property.
 * Возвращает: The return value of the invoked property.
 * Выводит исключение: ИсклНедостающЧлена if the property is not found.
 * Примеры:
 * ---
 * import com.com, stdrus;
 *
 * проц main() {
 *   // Create an экземпляр of the Microsoft Word automation object.
 *   ИДиспетчер wordApp = создайКо!(ИДиспетчер)("Word.Application");
 *
 *   // Invoke the Documents property 
 *   //   wordApp.Documents
 *   ИДиспетчер documents = дайСвойство!(ИДиспетчер)(цель, "Documents");
 *
 *   // Invoke the Count property on the Documents object
 *   //   documents.Count
 *  ВАРИАНТ посчитай = дайСвойство(documents, "Count");
 *
 *   // Display the value of the Count property.
 *   writefln("There are %s documents", посчитай);
 * }
 * ---
 */
R дайСвойство(R = ВАРИАНТ)(ИДиспетчер цель, ткст имя, ...)
 {
  auto арги = _arguments;
  auto аргук = _argptr;
  if (арги.length == 2) фиксАрги(арги, аргук);

 ВАРИАНТ рез = вызовиЧлен(имя, ПДиспачФлаг.ДатьСвойство, цель, аргиВВариантСписок(арги, аргук));
  static if (is(R == ВАРИАНТ))
    return рез;
  else
    return ком_каст!(R)(рез);
}

/**
 * Sets the value of a specified property on the specified object.
 * Параметры:
 *   цель = The object on which to invoke the specified property.
 *   имя = The _name of the property to invoke.
 *   _argptr = A список containing the arguments to pass to the property.
 * Выводит исключение: ИсклНедостающЧлена if the property is not found.
 * Примеры:
 * ---
 * import com.com;
 *
 * проц main() {
 *   // Create an Excel automation object.
 *   ИДиспетчер excelApp = создайКо!(ИДиспетчер)("Excel.Application");
 *
 *   // Set the Visible property to true
 *   //   excelApp.Visible = true
 *   установиСвойство(excelApp, "Visible", true);
 *
 *   // Get the Workbooks property
 *   //   workbooks = excelApp.Workbooks
 *   ИДиспетчер workbooks = дайСвойство!(ИДиспетчер)(excelApp, "Workbooks");
 *
 *   // Invoke the Add метод on the Workbooks property
 *   //   newWorkbook = workbooks.Add()
 *   ИДиспетчер newWorkbook = вызовиМетод!(ИДиспетчер)(workbooks, "Add");
 *
 *   // Get the Worksheets property and the Worksheet at индекс 1
 *   //   worksheet = excelApp.Worksheets[1]
 *   ИДиспетчер worksheet = дайСвойство!(ИДиспетчер)(excelApp, "Worksheets", 1);
 *
 *   // Get the Cells property and установи the Cell object at column 5, row 3 to a ткст
 *   //   worksheet.Cells[5, 3] = "data"
 *   установиСвойство(worksheet, "Cells", 5, 3, "data");
 * }
 * ---
 */
проц установиСвойство(ИДиспетчер цель, ткст имя, ...) ;

проц установиССылСвойство(ИДиспетчер цель, ткст имя, ...) ;
//////////////////////////////////////////////////////////
/////////////////////////////////	

class Диспетчер

 {

  private ИДиспетчер цель_;
  private ВАРИАНТ результат_;
  
  /**
   */
  this(ГУИД клсид, ПКонтекстВып контекст = cast(ПКонтекстВып)(0x1 | 0x4)) {
    цель_ = создайКо!(ИДиспетчер)(клсид, контекст);
    if (цель_ is null)
      throw new ОпИскл;
  }

  /**
   */
  this(ГУИД клсид, ткст сервер, ПКонтекстВып контекст = cast(ПКонтекстВып)(0x1 | 0x10)) {
    цель_ = создайКоДоп!(ИДиспетчер)(клсид, сервер, контекст);
    if (цель_ is null)
      throw new ОпИскл;
  }

  /**
   */
  this(ткст прогИд, ПКонтекстВып контекст = cast(ПКонтекстВып)(0x1 | 0x4)) {
    цель_ = создайКо!(ИДиспетчер)(прогИд, контекст);
    if (цель_ is null)
      throw new ОпИскл;
  }

  /**
   */
  this(ткст прогИд, ткст сервер, ПКонтекстВып контекст = cast(ПКонтекстВып)(0x1 | 0x10)) {
    цель_ = создайКоДоп!(ИДиспетчер)(прогИд, сервер, контекст);
    if (цель_ is null)
      throw new ОпИскл;
  }

  /**
   */
  this(ИДиспетчер цель) {
    if (цель is null)
      throw new ПустойАргИскл("цель");

    цель.AddRef();
    цель_ = цель;
  }

  /**
   * описано ранее
   */
  this(ВАРИАНТ цель) {
    if (auto цель = ком_каст!(ИДиспетчер)(результат)) {
      цель_ = цель;
    }
  }

  private this(ВАРИАНТ результат, бцел игнорировать) {
    if (auto цель = ком_каст!(ИДиспетчер)(результат)) {
      цель_ = цель;
    }
    результат_ = результат;
  }

  ~this() {
    сбрось();
  }

  /**
   */
  final проц сбрось() {
    if (!(результат_.нулл_ли || результат_.пуст_ли))
      результат_.сотри();

    if (цель_ !is null) {
      пробуйСброс(цель_);
      цель_ = null;
    }
  }

  /**
   */
  R вызови(R = Диспетчер)(ткст имя, ...) {
    static if (is(R == Диспетчер)) {
      return new Диспетчер(вызовиМетод(цель_, имя, _arguments, _argptr), 0);
    }
    else {
      R ret = вызовиМетод!(R)(цель_, имя, _arguments, _argptr);
      результат_ = ret;
      return ret;
    }
  }

  /**
   */
  R дай(R = Диспетчер)(ткст имя, ...) {
    static if (is(R == Диспетчер)) {
      return new Диспетчер(дайСвойство(цель_, имя, _arguments, _argptr), 0);
    }
    else {
      R ret = дайСвойство!(R)(цель_, имя, _arguments, _argptr);
      результат_ = ret;
      return ret;
    }
  }

  /**
   */
  проц установи(ткст имя, ...)
  {
    установиСвойство(цель_, имя, _arguments, _argptr);
  }

  /**
   */
  проц установиСсылку(ткст имя, ...)
  {
    установиССылСвойство(цель_, имя, _arguments, _argptr);
  }

  /**
   */
  final ИДиспетчер цель() {
    return цель_;
  }

  /**
   */
  final ВАРИАНТ результат() {
    return результат_;
  }

}
alias Диспетчер Обдис;

////////////////////////////////////////////////////////////
/**
 * Предлагает реализацию интерфейса ИПоток.
 */
 
class КОМПоток : Реализует!(ИПоток) {

  protected Поток поток_; 

 this(Поток поток) {
    if (поток is null)
      throw new Ошибка ("Нулевой аргумент 'поток'");
    поток_ = поток;
  }

 Поток потокОснова() {
    return поток_;
  }

 цел Read(ук pv, бцел кб, ref бцел кбЧтен) {
    бцел ret = поток_.читайБлок(pv, кб);
    if (&кбЧтен)
      кбЧтен = ret;
    return ПКомРез.Да;
  }
alias Read читай;

  цел Write(in ук pv, бцел кб, ref бцел кбСчитанных) {
    бцел ret = поток_.пишиБлок(pv, кб);
    if (&кбСчитанных)
      кбСчитанных = ret;
    return ПКомРез.Да;
  }
alias Write пиши;

  цел Seek(дол dlibMove, бцел dwOrigin, ref бдол plibNewPosition) {
    ППозКурсора whence;
    if (dwOrigin ==ППозПотока.Уст)
      whence = ППозКурсора.Уст;
    else if (dwOrigin ==ППозПотока.Тек)
      whence = ППозКурсора.Тек;
    else if (dwOrigin ==ППозПотока.Кон)
      whence = ППозКурсора.Кон;

    бдол ret = поток_.сместись(dlibMove, whence);
    if (&plibNewPosition)
      plibNewPosition = ret;
    return ПКомРез.Да;
  }
alias Seek сместись;

  цел SetSize(бдол libNewSize) {
    return ПКомРез.Нереализовано;
  }
alias SetSize установиРазм;

  цел CopyTo(ИПоток поток, бдол кб, ref бдол кбЧтен, ref бдол кбСчитанных) {
    if (&кбЧтен)
      кбЧтен = 0;
    if (&кбСчитанных)
      кбСчитанных = 0;
    return ПКомРез.Нереализовано;
  }
alias CopyTo копируйВ;

  цел Commit(бцел hrfCommitFlags) {
    return ПКомРез.Нереализовано;
  }
alias Commit передай;

  цел Revert() {
    return ПКомРез.Нереализовано;
  }
alias Revert верни;

  цел LockRegion(бдол смещБиб, бдол кб, бцел типБлокир) {
    return ПКомРез.Нереализовано;
  }
alias LockRegion блокРегион;

  цел UnlockRegion(бдол смещБиб, бдол кб, бцел типБлокир) {
    return ПКомРез.Нереализовано;
  }
alias UnlockRegion разблокРегион;

  цел Stat(out ОТКРПМБ pstatstg, бцел grfStatFlag) {
    pstatstg.тип = STGTY_STREAM;
    pstatstg.бРазм = поток_.размер;
    return ПКомРез.Да;
  }
alias Stat стат;

  цел Clone(out ИПоток ppstm) {
    ppstm = null;
    return ПКомРез.Нереализовано;
  }
alias Clone клонируй;

}

/+
/**
 */
class EventCookie(T) {

  private IConnectionPoint cp_;
  private uint cookie_;

  /**
   */
  this(IUnknown source) {
    auto cpc = ком_каст!(IConnectionPointContainer)(source);
    if (cpc !is null) {
      scope(exit) пробуйСброс(cpc);

      if (cpc.FindConnectionPoint(uuidof!(T), cp_) != S_OK)
        throw new АргИскл("Source object does not expose '" ~ T.stringof ~ "' event interface.");
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
      пробуйСброс(cp_);
      throw new ОпИскл("Could not Advise() the event interface '" ~ T.stringof ~ "'.");
    }

    if (cp_ is null || cookie_ == 0) {
      if (cp_ !is null)
        пробуйСброс(cp_);
      throw new АргИскл("Connection point for event interface '" ~ T.stringof ~ "' cannot be created.");
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
        пробуйСброс(cp_);
        cp_ = null;
        cookie_ = 0;
      }
    }
  }

}

private struct ПроксиМетода {

  int delegate() метод;
  VARTYPE возврТип;
  VARTYPE[] парамТипы;

  static ПроксиМетода opCall(R, T...)(R delegate(T) метод) {
    ПроксиМетода сам;
    сам = метод;
    return сам;
  }

  проц opAssign(R, T...)(R delegate(T) dg) {
    alias КортежТипаПараметров!(dg) парамы;

    метод = cast(int delegate())dg;
    возврТип = ТипВарианта!(R);
    парамТипы.length = парамы.length;
    foreach (i, парамТип; парамы) {
      парамТипы[i] = ТипВарианта!(парамТип);
    }
  }

  int invoke(ВАРИАНТ*[] арги, ВАРИАНТ* результат) {

    size_t variantSize(VARTYPE vt) {
      switch (vt) {
        case VT_UI8, VT_I8, VT_CY:
          return long.sizeof / int.sizeof;
        case VT_R8, VT_DATE:
          return double.sizeof / int.sizeof;
        case VT_ВАРИАНТ:
          return (ВАРИАНТ.sizeof + 3) / int.sizeof;
        default:
      }

      return 1;
    }

    // Like DispCallFunc, but using delegates

    size_t paramCount;
    for (int i = 0; i < парамТипы.length; i++) {
      paramCount += variantSize(парамТипы[i]);
    }

    auto argptr = cast(int*)HeapAlloc(GetProcessHeap(), 0, paramCount * int.sizeof);

    uint pos;
    for (int i = 0; i < парамТипы.length; i++) {
      ВАРИАНТ* p = арги[i];
      if (парамТипы[i] == VT_ВАРИАНТ)
        memcpy(&argptr[pos], p, variantSize(парамТипы[i]) * int.sizeof);
      else
        memcpy(&argptr[pos], &p.lVal, variantSize(парамТипы[i]) * int.sizeof);
      pos += variantSize(парамТипы[i]);
    }

    int рез = 0;

    switch (paramCount) {
      case 0: рез = метод(); break;
      case 1: рез = (cast(int delegate(int))метод)(argptr[0]); break;
      case 2: рез = (cast(int delegate(int, int))метод)(argptr[0], argptr[1]); break;
      case 3: рез = (cast(int delegate(int, int, int))метод)(argptr[0], argptr[1], argptr[2]); break;
      case 4: рез = (cast(int delegate(int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3]); break;
      case 5: рез = (cast(int delegate(int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4]); break;
      case 6: рез = (cast(int delegate(int, int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5]); break;
      case 7: рез = (cast(int delegate(int, int, int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6]); break;
      case 8: рез = (cast(int delegate(int, int, int, int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7]); break;
      case 9: рез = (cast(int delegate(int, int, int, int, int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8]); break;
      case 10: рез = (cast(int delegate(int, int, int, int, int, int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9]); break;
      case 11: рез = (cast(int delegate(int, int, int, int, int, int, int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10]); break;
      case 12: рез = (cast(int delegate(int, int, int, int, int, int, int, int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11]); break;
      case 13: рез = (cast(int delegate(int, int, int, int, int, int, int, int, int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12]); break;
      case 14: рез = (cast(int delegate(int, int, int, int, int, int, int, int, int, int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12], argptr[13]); break;
      case 15: рез = (cast(int delegate(int, int, int, int, int, int, int, int, int, int, int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12], argptr[13], argptr[14]); break;
      case 16: рез = (cast(int delegate(int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12], argptr[13], argptr[14], argptr[15]); break;
      case 17: рез = (cast(int delegate(int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12], argptr[13], argptr[14], argptr[15], argptr[16]); break;
      case 18: рез = (cast(int delegate(int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12], argptr[13], argptr[14], argptr[15], argptr[16], argptr[17]); break;
      case 19: рез = (cast(int delegate(int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12], argptr[13], argptr[14], argptr[15], argptr[16], argptr[17], argptr[18]); break;
      case 20: рез = (cast(int delegate(int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int))метод)(argptr[0], argptr[1], argptr[2], argptr[3], argptr[4], argptr[5], argptr[6], argptr[7], argptr[8], argptr[9], argptr[10], argptr[11], argptr[12], argptr[13], argptr[14], argptr[15], argptr[16], argptr[17], argptr[18], argptr[19]); break;
      default:
        return DISP_E_BADPARAMCOUNT;
    }

    if (результат !is null && возврТип != VT_VOID) {
      результат.vt = возврТип;
      результат.lVal = рез;
    }

    HeapFree(GetProcessHeap(), 0, argptr);
    return S_OK;
  }

}

/**
 */
class EventProvider(T) : Implements!(T) {

  extern(D):

  private ПроксиМетода[int] methodTable_;
  private int[ткст] nameTable_;

  private IConnectionPoint connectionPoint_;
  private uint cookie_;

  /**
   */
  this(IUnknown source) {
    auto cpc = ком_каст!(IConnectionPointContainer)(source);
    if (cpc !is null) {
      scope(exit) пробуйСброс(cpc);

      if (cpc.FindConnectionPoint(uuidof!(T), connectionPoint_) != S_OK)
        throw new АргИскл("Source object does not expose '" ~ T.stringof ~ "' event interface.");

      if (connectionPoint_.Advise(this, cookie_) != S_OK) {
        cookie_ = 0;
        пробуйСброс(connectionPoint_);
        throw new ОпИскл("Could not Advise() the event interface '" ~ T.stringof ~ "'.");
      }
    }

    if (connectionPoint_ is null || cookie_ == 0) {
      if (connectionPoint_ !is null)
        пробуйСброс(connectionPoint_);
      throw new АргИскл("Connection point for event interface '" ~ T.stringof ~ "' cannot be created.");
    }
  }

  ~this() {
    if (connectionPoint_ !is null && cookie_ != 0) {
      try {
        connectionPoint_.Unadvise(cookie_);
      }
      finally {
        пробуйСброс(connectionPoint_);
        connectionPoint_ = null;
        cookie_ = 0;
      }
    }
  }

  /**
   */
  проц bind(ID, R, P...)(ID member, R delegate(P) handler) {
    static if (is(ID : ткст)) {
      bool found;
      int dispId = DISPID_UNKNOWN;
      if (tryFindDispId(member, dispId))
        bind(dispId, handler);
      else
        throw new АргИскл("Member '" ~ member ~ "' not found in type '" ~ T.stringof ~ "'.");
    }
    else static if (is(ID : int)) {
      ПроксиМетода m = handler;
      methodTable_[member] = m;
    }
  }

  private bool tryFindDispId(ткст имя, out int dispId) {

    проц ensureNameTable() {
      if (nameTable_ == null) {
        scope клсидKey = RegistryKey.classesRoot.openSubKey("Interface\\" ~ uuidof!(T).toString("P"));
        if (клсидKey !is null) {
          scope typeLibRefKey = клсидKey.openSubKey("TypeLib");
          if (typeLibRefKey !is null) {
            ткст typeLibVersion = typeLibRefKey.getValue!(ткст)("Version");
            if (typeLibVersion == null) {
              scope versionKey = клсидKey.openSubKey("Version");
              if (versionKey !is null)
                typeLibVersion = versionKey.getValue!(ткст)(null);
            }

            scope typeLibKey = RegistryKey.classesRoot.openSubKey("TypeLib\\" ~ typeLibRefKey.getValue!(ткст)(null));
            if (typeLibKey !is null) {
              scope pathKey = typeLibKey.openSubKey(typeLibVersion ~ "\\0\\Win32");
              if (pathKey !is null) {
                ITypeLib typeLib;
                if (LoadTypeLib(pathKey.getValue!(ткст)(null).toUtf16z(), typeLib) == S_OK) {
                  scope(exit) пробуйСброс(typeLib);

                  ITypeInfo typeInfo;
                  if (typeLib.GetTypeInfoOfГУИД(uuidof!(T), typeInfo) == S_OK) {
                    scope(exit) пробуйСброс(typeInfo);

                    TYPEATTR* typeAttr;
                    if (typeInfo.GetTypeAttr(typeAttr) == S_OK) {
                      scope(exit) typeInfo.ReleaseTypeAttr(typeAttr);

                      for (uint i = 0; i < typeAttr.cFuncs; i++) {
                        FUNCDESC* funcDesc;
                        if (typeInfo.GetFuncDesc(i, funcDesc) == S_OK) {
                          scope(exit) typeInfo.ReleaseFuncDesc(funcDesc);

                          wchar* bstrName;
                          if (typeInfo.GetDocumentation(funcDesc.memid, &bstrName, null, null, null) == S_OK) {
                            ткст memberName = fromBstr(bstrName);
                            nameTable_[memberName.toLower()] = funcDesc.memid;
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

    if (auto value = имя.toLower() in nameTable_) {
      dispId = *value;
      return true;
    }

    return false;
  }

  extern(Windows):

  override int Invoke(int dispIdMember, ref GUID riid, uint лкид, ushort wFlags, DISPPARAMS* pDispParams, ВАРИАНТ* pVarResult, EXCEPINFO* pExcepInfo, uint* puArgError) {
    if (riid != GUID.empty)
      return DISP_E_UNKNOWNINTERFACE;

    try {
      if (auto handler = dispIdMember in methodTable_) {
        ВАРИАНТ*[8] арги;
        for (int i = 0; i < handler.парамТипы.length && i < 8; i++) {
          арги[i] = &pDispParams.rgvarg[handler.парамТипы.length - i - 1];
        }

        ВАРИАНТ результат;
        if (pVarResult == null)
          pVarResult = &результат;

        int hr = handler.invoke(арги, pVarResult);

        for (int i = 0; i < handler.парамТипы.length; i++) {
          if (арги[i].vt == (VT_BYREF | VT_BOOL)) {
            // Fix bools to ВАРИАНТ_BOOL
            *арги[i].pboolVal = (*арги[i].pboolVal == 0) ? ВАРИАНТ_FALSE : ВАРИАНТ_TRUE;
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
+/