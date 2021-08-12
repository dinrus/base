/**
 * Provides supprt for Extensible Stylesheet Transformation (XSLT) transforms.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.xml.xsl;

import win32.base.core,
  win32.base.string,
  win32.com.core,
  win32.xml.core,
  win32.xml.dom,
  win32.xml.msxml,
  stdrus, tpl.stream, sys.WinConsts;

/**
 * The exception thrown when an ошибка occurs while processing an XSLT transformation.
 */
class XsltException : Exception {

  private цел linconstber_;
  private цел linePosition_;
  private ткст sourceUri_;

  /**
   * Initializes a new экземпляр.
   * Параметры:
   *   сообщение = The описание of the ошибка.
   *   cause = The Exception that threw the XsltException.
   */
  this(ткст сообщение = null, цел linconstber = 0, цел linePosition = 0, ткст sourceUri = null) {
    super(createMessage(сообщение, linconstber, linePosition));
    linconstber_ = linconstber;
    linePosition_ = linePosition_;
    sourceUri_ = sourceUri;
  }

  /**
   * Gets the line число indicating where the ошибка occurred.
   * Возвращает: The line число indicating where the ошибка occurred.
   */
  final цел linconstber() {
    return linconstber_;
  }

  /**
   * Gets the line позиция indicating where the ошибка occurred.
   * Возвращает: The line позиция indicating where the ошибка occurred.
   */
  final цел linePosition() {
    return linePosition_;
  }

  /**
   * Gets the положение путь of the style sheet.
   * Возвращает: The положение путь of the style sheet.
   */
  public ткст sourceUri() {
    return sourceUri_;
  }

  private static ткст createMessage(ткст s, цел linconstber, цел linePosition) {
    ткст рез = s;
    if (linconstber != 0)
      рез ~= format(" Line {0}, позиция {1}.", linconstber, linePosition);
    return рез;
  }

}

/**
 * Specifies the XSLT features to support during execution of the style sheet.
 */
final class XsltSettings {

  /// Indicates whether to enable support for the XSLT document() function.
  бул enableDocumentFunction;

  /// Indicates whether to enable support for embedded скрипт blocks.
  бул enableScript;

  this(бул enableDocumentFunction = false, бул enableScript = false) {
    this.enableDocumentFunction = enableDocumentFunction;
    this.enableScript = enableScript;
  }

}

/**
 * Contains a variable число of arguments that are either XSLT parameters or extension objects.
 */
final class XsltArgumentList {

  private VARIANT[XmlQualifiedName] parameters_;
  private Объект[ткст] extensions_;

  /**
   * Adds a _parameter and associates it with the namespace-qualified _name.
   * Параметры:
   *   имя = The _name to associate with the _parameter.
   *   namespaceUri = The namespace URI to associate with the _parameter.
   *   parameter = The _parameter значение to добавь to the список.
   */
  проц addParam(T)(ткст имя, ткст namespaceUri, T parameter) {
    auto qname = new XmlQualifiedName(имя, namespaceUri);
    static if (is(T : XmlNode))
      parameters_[qname] = VARIANT(parameter.impl);
    else
      parameters_[qname] = VARIANT(parameter);
  }

  /**
   * Gets the parameter associated with the namespace-qualified _name.
   * Параметры:
   *   имя = The _name of the parameter.
   *   namespaceUri = The namespace URI associated with the parameter.
   * Возвращает: The parameter or $(B T.init) if one was not found.
   */
  T getParam(T)(ткст имя, ткст namespaceUri) {
    T ret = T.init;

    auto qname = new XmlQualifiedName(имя, namespaceUri);
    if (auto param = qname in parameters_) {
      static if (is(T : XmlNode))
        ret = cast(T)getNodeShim(cast(IXMLDOMNode)param.pdispVal);
      else static if (is(T : Объект))
        ret = cast(T)param.byref;
      else
        ret = com_cast!(T)(*param);
    }

    return ret;
  }

  /**
   * Removes the parameter.
   * Параметры:
   *   имя = The _name of the parameter to удали.
   *   namespaceUri = The namespace URI of the parameter to удали.
   * Возвращает: The parameter or $(B T.init) if one was not found.
   */
  T removeParam(T)(ткст имя, ткст namespaceUri) {
    T ret = T.init;

    auto qname = new XmlQualifiedName(имя, namespaceUri);

    if (auto param = qname in parameters_) {
      static if (is(T : XmlNode))
        ret = cast(T)getNodeShim(cast(IXMLDOMNode)param.pdispVal);
      else static if (is(T : Объект))
        ret = cast(T)param.byref;
      else
        ret = com_cast!(T)(*param);
    }

    parameters_.удали(qname);

    return ret;
  }

  /**
   * Adds a new object and associates it with the namespace URI.
   * Параметры:
   *   namespaceUri = The namespace URI to associate with the object.
   *   extension = The object to добавь to the список.
   */
  проц addExtensionObject(ткст namespaceUri, Объект extension) {
    extensions_[namespaceUri] = extension;
  }

  /**
   * Gets the object associated with the specified namespace URI.
   * Параметры: namespaceUri = The namespace URI of the object.
   * Возвращает: The object or null if one was not found.
   */
  Объект getExtensionObject(ткст namespaceUri) {
    if (auto extension = namespaceUri in extensions_)
      return *extension;
    return null;
  }

  /**
   * Removes the object associated with the specified namespace URI.
   * Параметры: namespaceUri = The namespace URI of the object.
   * Возвращает: The object or null if one was not found.
   */
  Объект removeExtensionObject(ткст namespaceUri) {
    if (auto extension = namespaceUri in extensions_) {
      extensions_.remove(namespaceUri);
      return *extension;
    }
    return null;
  }

  /**
   * Removes all parameters and extension objects.
   */
  проц сотри() {
    foreach (ключ, значение; parameters_)
      значение.сотри();

    parameters_ = null;
    extensions_ = null;
  }

}

/**
 * Transforms XML данные используя an XSLT style sheet.
 * Примеры::
 * ---
 * // Load the style sheet.
 * scope stylesheet = new XslTransform;
 * stylesheet.загрузи("вывод.xsl");
 *
 * // Execute the transform and вывод the results to a file.
 * stylesheet.transform("books.xml", "books.html");
 * ---
 */
final class XslTransform {

  private class XsltProcessor {

    private XmlDocument document_;
    private XsltArgumentList args_;
    private IXSLTemplate template_;
    private IXSLProcessor processor_;

    private this(XmlDocument doc, XsltArgumentList арги) {
      document_ = doc;
      args_ = арги;

      if ((template_ = XSLTemplate60.coCreate!(IXSLTemplate)) is null) {
        if ((template_ = XSLTemplate40.coCreate!(IXSLTemplate)) is null)
          template_ = XSLTemplate30.coCreate!(IXSLTemplate, ExceptionPolicy.Throw);
      }

      template_.putref_stylesheet(this.outer.stylesheet_);
      template_.createProcessor(processor_);
    }

    ~this() {
      document_ = null;
      if (processor_ !is null) {
        tryRelease(processor_);
        processor_ = null;
      }
      if (template_ !is null) {
        tryRelease(template_);
        template_ = null;
      }
    }

    private проц execute(Поток results) {
      if (args_ !is null) {
        foreach (qname, param; args_.parameters_) {
          шим* bstrName = toBstr(qname.имя);
          шим* bstrNs = toBstr(qname.namespace);

          if (param.vt == VT_BYREF && param.byref != null) {
            if (auto объ = cast(Объект)param.byref)
              param.bstrVal = toBstr(объ.вТкст());
          }

          processor_.addParameter(bstrName, param, bstrNs);

          freeBstr(bstrName);
          freeBstr(bstrNs);
        }

        foreach (имя, extension; args_.extensions_) {
          if (auto disp = cast(IDispatch)extension) {
            шим* bstrNs = toBstr(имя);
            processor_.addObject(disp, bstrNs);
            freeBstr(bstrNs);
          }
        }
      }

      VARIANT ввод = document_.impl;
      scope(exit) ввод.сотри();

      if (processor_.put_input(ввод) == S_OK) {
        VARIANT вывод = new COMStream(results);
        scope(exit) вывод.сотри();

        processor_.put_output(вывод);

        VARIANT_BOOL success;
        processor_.transform(success);
      }
    }

  }

  private IXMLDOMDocument2 stylesheet_;

  /**
   * Initializes a new экземпляр.
   */
  this() {
    if ((stylesheet_ = FreeThreadedDOMDocument60.coCreate!(IXMLDOMDocument3)) is null) {
      if ((stylesheet_ = FreeThreadedDOMDocument40.coCreate!(IXMLDOMDocument2)) is null)
        stylesheet_ = FreeThreadedDOMDocument30.coCreate!(IXMLDOMDocument2, ExceptionPolicy.Throw);
    }

    stylesheet_.put_async(VARIANT_FALSE);
    stylesheet_.put_validateOnParse(VARIANT_FALSE);
    stylesheet_.setProperty(cast(шим*)"NewParser", VARIANT(true));
  }

  ~this() {
    if (stylesheet_ !is null) {
      tryRelease(stylesheet_);
      stylesheet_ = null;
    }
  }

  /**
   * Loads the style sheet located at the specified URI.
   * Параметры:
   *   stylesheetUri = The URI of the style sheet.
   *   settings = The features to apply to the style sheet.
   * Выводит исключение: XsltException if the style sheet содержит an ошибка.
   */
  проц загрузи(ткст stylesheetUri, XsltSettings settings = null) {
    if (settings is null)
      settings = new XsltSettings;

    stylesheet_.setProperty(cast(шим*)"AllowDocumentFunction", VARIANT(settings.enableDocumentFunction));
    stylesheet_.setProperty(cast(шим*)"AllowXsltScript", VARIANT(settings.enableScript));

    VARIANT исток = stylesheetUri;
    scope(exit) исток.сотри();

    VARIANT_BOOL success;
    stylesheet_.загрузи(исток, success);
    if (success != VARIANT_TRUE)
      parsingException();
  }

  /**
   * Executes the _transform используя the ввод document specified by the URI and outputs the results to a file.
   * Параметры:
   *   inputUri = The URI of the ввод document.
   *   resultsFile = The URI of the вывод document.
   */
  проц transform(ткст inputUri, ткст resultsFile) {
    scope fs = new Файл(resultsFile, ПФРежим.ВыводНов);
    transform(inputUri, null, fs);
  }

  /**
   * Executes the _transform используя the ввод document specified by the URI and outputs the _results to a поток.
   * Параметры:
   *   inputUri = The URI of the ввод document.
   *   arguments = The namespace-qualified arguments used as ввод to the _transform.
   *   results = The поток to вывод.
   * Примеры::
   *   The following example shows how to пиши the _results to an XmlDocument.
   * ---
   * // The resulting document.
   * scope resultDoc = new XmlDocument;
   * 
   * // Load the transform.
   * scope stylesheet = new XslTransform;
   * stylesheet.загрузи("вывод.xsl");
   *
   * // Save the results to a ПотокПамяти.
   * scope ms = new ПотокПамяти;
   * stylesheet.transform("books.xml", null, ms);
   *
   * // Load the results into the document.
   * resultDoc.загрузи(ms);
   * ---
   */
  проц transform(ткст inputUri, XsltArgumentList arguments, Поток results) {
    scope doc = new XmlDocument;
    doc.загрузи(inputUri);
    transform(doc, arguments, results);
  }

  /**
   * Executes the _transform используя the specified _input document and outputs the _results to a поток.
   * Параметры:
   *   ввод = The document containing the данные to be transformed.
   *   arguments = The namespace-qualified arguments used as ввод to the _transform.
   *   results = The поток to вывод.
   */
  проц transform(XmlDocument ввод, XsltArgumentList arguments, Поток results) {
    if (results is null)
      throw new ИсклНулевогоАргумента("results");

    scope processor = new XsltProcessor(ввод, arguments);
    processor.execute(results);
  }

  private проц parsingException() {
    IXMLDOMParseError errorObj;
    if (stylesheet_.get_parseError(errorObj) == S_OK) {
      scope(exit) errorObj.Release();

      шим* bstrReason, bstrUrl;
      цел line, позиция;

      errorObj.get_reason(bstrReason);
      errorObj.get_url(bstrUrl);
      errorObj.get_line(line);
      errorObj.get_linepos(позиция);

      ткст reason = изБткст(bstrReason);
      if (reason[$ - 1] == '\n')
        reason = reason[0 .. $ - 2];

      throw new XsltException(reason, line, позиция, изБткст(bstrUrl));
    }
  }

}