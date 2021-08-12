/**
 * Provides a _streaming API for reading and writing XML данные.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.xml.streaming;

import win32.base.core,
  win32.base.text,
  win32.base.string,
  win32.base.native,
  win32.loc.conv,
  win32.com.core,
  win32.xml.core,
  stdrus, tpl.stream;

enum XmlReaderProperty : бцел {
  MultiLanguage,
  ConformanceLevel,
  RandomAccess,
  XmlResolver,
  DtdProcessing,
  ReadState,
  MaxElementLength,
  MaxEntityExpansion
}

enum XmlWriterProperty : бцел {
  MultiLanguage,
  Indent,
  ByteOrderMark,
  OmitXmlDeclaration,
  ConformanceLevel
}

extern(Windows):

alias ДллИмпорт!("xmllite.dll", "CreateXmlReader",
  цел function(ref GUID riid, ук* ppvObject, IMalloc pMalloc))
  CreateXmlReader;

alias ДллИмпорт!("xmllite.dll", "CreateXmlReaderInputWithEncodingCodePage",
  цел function(IUnknown pInputStream, IMalloc pMalloc, бцел nEncodingCodePage, цел fEncodingHint, in шим* pswzBaseUri, IUnknown* ppInput))
  CreateXmlReaderInputWithEncodingCodePage;

alias ДллИмпорт!("xmllite.dll", "CreateXmlReaderInputWithEncodingName",
  цел function(IUnknown pInputStream, IMalloc pMalloc, in шим* pwszEncodingName, цел fEncodingHint, in шим* pswzBaseUri, IUnknown* ppInput))
  CreateXmlReaderInputWithEncodingName;

alias ДллИмпорт!("xmllite.dll", "CreateXmlWriter",
  цел function(ref GUID riid, ук* ppvObject, IMalloc pMalloc))
  CreateXmlWriter;

alias ДллИмпорт!("xmllite.dll", "CreateXmlWriterOutputWithEncodingName",
  цел function(IUnknown pOutputStream, IMalloc pMalloc, in шим* pwszEncodingName, IUnknown* ppOutput))
  CreateXmlWriterOutputWithEncodingName;

interface IXmlReader : IUnknown {
  mixin(ууид("7279FC81-709D-4095-B63D-69FE4B0D9030"));
  цел SetInput(IUnknown pInput);
  цел GetProperty(бцел nProperty, out цел ppValue);
  цел SetProperty(бцел nProperty, цел pValue);
  цел Read(out XmlNodeType pNodeType);
  цел GetNodeType(out XmlNodeType pNodeType);
  цел MoveToFirstAttribute();
  цел MoveToNextAttribute();
  цел MoveToAttributeByName(in шим* pwszLocalName, in шим* pwszNamespaceUri);
  цел MoveToElement();
  цел GetQualifiedName(out шим* ppwszQualifiedName, out бцел pcwchQualifiedName);
  цел GetNamespaceUri(out шим* ppwszNamespaceUri, out бцел pcwchNamespaceUri);
  цел GetLocalName(out шим* ppwszLocalName, out бцел pcwchLocalName);
  цел GetPrefix(out шим* ppwszPrefix, out бцел pcwchPrefix);
  цел GetValue(out шим* ppwszValue, out бцел pcwchValue);
  цел ReadValueChunk(шим* pwchBuffer, бцел cwchChunkSize, ref бцел pcwchRead);
  цел GetBaseUri(out шим* pwchBaseUri, out бцел pcwchBaseUri);
  цел IsDefault();
  цел IsEmptyElement();
  цел GetLinconstber(out бцел pnLinconstber);
  цел GetLinePosition(out бцел pnLinePosition);
  цел GetAttributeCount(out бцел pnAttributeCount);
  цел GetDepth(out бцел pnDepth);
  цел IsEOF();
}

interface IXmlResolver : IUnknown {
  mixin(ууид("7279FC82-709D-4095-B63D-69FE4B0D9030"));
  цел ResolveUri(in шим* pwszBaseUri, in шим* pwszPublicIdentifier, in шим* pwszSystemIdentifier, out IUnknown ppResolvedInput);
}

interface IXmlWriter : IUnknown {
  mixin(ууид("7279FC88-709D-4095-B63D-69FE4B0D9030"));
  цел SetOutput(IUnknown pOutput);
  цел GetProperty(бцел nProperty, out цел ppValue);
  цел SetProperty(бцел nProperty, цел pValue);
  цел WriteAttributes(IXmlReader pReader, цел fWriteDefaultAttributes);
  цел WriteAttributeString(in шим* pwszPrefix, in шим* pwszLocalName, in шим* pwszNamespaceUri, in шим* pwszValue);
  цел WriteCData(in шим* pwszText);
  цел WriteCharEntity(шим wch);
  цел WriteChars(in шим* pwch, бцел cwch);
  цел WriteComment(in шим* pwszComment);
  цел WriteDocType(in шим* pwszName, in шим* pwszPublicId, in шим* pwszSystemId, in шим* pwszSubset);
  цел WriteElementString(in шим* pwszPrefix, in шим* pwszLocalName, in шим* pwszNamespaceUri, in шим* pwszValue);
  цел WriteEndDocument();
  цел WriteEndElement();
  цел WriteEntityRef(in шим* pwszName);
  цел WriteFullEndElement();
  цел WriteName(in шим* pwszName);
  цел WriteNmToken(in шим* pwszNmToken);
  цел WriteNode(IXmlReader pReader, цел fWriteDefaultAttributes);
  цел WriteNodeShallow(IXmlReader pReader, цел fWriteDefaultAttributes);
  цел WriteProcessingInstruction(in шим* pwszName, in шим* pszValue);
  цел WriteQualifiedName(in шим* pwszLocalName, in шим* pwszNamespaceUri);
  цел WriteRaw(in шим* pwszData);
  цел WriteRawChars(in шим* pwch, бцел cwch);
  цел WriteStartDocument(XmlStandalone standalone);
  цел WriteStartElement(in шим* pwszPrefix, in шим* pwszLocalName, in шим* pwszNamespaceUri);
  цел WriteString(in шим* pwszText);
  цел WriteSurrogateCharEntity(шим wchLow, шим wchHigh);
  цел WriteWhitespace(in шим* pwszWhitespace);
  цел Flush();
}

extern(D):

/*abstract class XmlResolver {

  abstract Объект resolveUri(ткст baseUri, ткст publicId, ткст systemId);

}

class XmlUrlResolver : XmlResolver {

  override Объект resolveUri(ткст baseUri, ткст publicId, ткст systemId) {
    return null;
  }

}

private class XmlResolverWrapper : Реализует!(IXmlResolver) {

  private XmlResolver resolver_;

  this(XmlResolver resolver) {
    resolver_ = resolver;
  }

  цел ResolveUri(in шим* pwszBaseUri, in шим* pwszPublicIdentifier, in шим* pwszSystemIdentifier, out IUnknown ppResolvedInput) {
    return S_OK;
  }

}*/

/**
 * Specifies features to support on the XmlReader object.
 */
final class XmlReaderSettings {

  private XmlConformanceLevel conformanceLevel_;
  private бул prohibitDtd_;
  //private XmlResolver xmlResolver_;

  /**
   * Initializes a new экземпляр.
   */
  this() {
    сбрось();
  }

  /**
   * Resets the members to their default значения.
   */
  проц сбрось() {
    conformanceLevel_ = XmlConformanceLevel.Document;
    prohibitDtd_ = true;
    //xmlResolver_ = new XmlUrlResolver;
  }

  /**
   * Gets or sets the уровень of conformance with which the XmlReader will comply.
   */
  проц conformanceLevel(XmlConformanceLevel значение) {
    conformanceLevel_ = значение;
  }

  /**
   * ditto
   */
  XmlConformanceLevel conformanceLevel() {
    return conformanceLevel_;
  }

  /**
   * Gets or sets a _value indicating whether to prohibit document тип definition (DTD) processing.
   */
  проц prohibitDtd(бул значение) {
    prohibitDtd_ = значение;
  }

  /**
   * ditto
   */
  бул prohibitDtd() {
    return prohibitDtd_;
  }

  /*проц xmlResolver(XmlResolver значение) {
    xmlResolver_ = значение;
  }

  XmlResolver xmlResolver() {
    return xmlResolver_;
  }*/

}

/**
 * Provides context information required by the XmlReader to разбор an XML fragment.
 */
class XmlParserContext {

  private ткст baseURI_;
  private Кодировка кодировка_;

  /**
   * Initializes a new экземпляр.
   * Параметры:
   *   baseURI = The base URI for the XML fragment.
   *   кодировка = An Кодировка object indicating the _encoding setting.
   */
  this(ткст baseURI, Кодировка кодировка = null) {
    baseURI_ = baseURI;
    кодировка_ = кодировка;
  }
  
  /**
   * Gets or sets the base URI.
   */
  final проц baseURI(ткст значение) {
    baseURI_ = значение;
  }

  /**
   * ditto
   */
  final ткст baseURI() {
    return baseURI_;
  }

  /**
   * Gets or sets the _encoding setting.
   */
  final проц кодировка(Кодировка значение) {
    кодировка_ = значение;
  }
  
  /**
   * ditto
   */
  final Кодировка кодировка() {
    return кодировка_;
  }

}

/*extern(Windows)
alias ДллИмпорт!("shlwapi.dll", "SHCreateStreamOnFile",
  цел function(in шим* pszFile, бцел grfMode, IStream* ppstm))
  SHCreateStreamOnFile;*/

private цел createStreamOnFile(ткст имяф, бцел флаги, out IStream рез) {

  class FileStream : Реализует!(IStream) {

    private Укз handle_;

    this(ткст имяф, бцел mode, бцел access, бцел share) {
      handle_ = CreateFile(имяф.вУтф16н(), access, share, null, mode, 0, Укз.init);
    }

    ~this() {
      if (handle_ != Укз.init) {
        CloseHandle(handle_);
        handle_ = Укз.init;
      }
    }

    цел Read(ук pv, бцел cb, ref бцел pcbRead) {
      бцел bytesRead;
      бцел ret = ReadFile(handle_, pv, cb, bytesRead, null);
      if (&pcbRead)
        pcbRead = bytesRead;
      return S_OK;
    }

    цел Write(in ук pv, бцел cb, ref бцел pcbWritten) {
      бцел bytesWritten;
      бцел ret = WriteFile(handle_, pv, cb, bytesWritten, null);
      if (&pcbWritten)
        pcbWritten = bytesWritten;
      return S_OK;
    }

    цел Seek(дол dlibMove, бцел dwOrigin, ref бдол plibNewPosition) {
      бцел whence;
      if (dwOrigin == STREAM_SEEK_SET)
        whence = FILE_BEGIN;
      else if (dwOrigin == STREAM_SEEK_CUR)
        whence = FILE_CURRENT;
      else if (dwOrigin == STREAM_SEEK_END)
        whence = FILE_END;

      дол ret;
      SetFilePointerEx(handle_, dlibMove, ret, whence);
      if (&plibNewPosition)
        plibNewPosition = cast(бдол)ret;
      return S_OK;
    }

    цел SetSize(бдол libNewSize) {
      return E_NOTIMPL;
    }

    цел CopyTo(IStream поток, бдол cb, ref бдол pcbRead, ref бдол pcbWritten) {
      if (&pcbRead)
        pcbRead = 0;
      if (&pcbWritten)
        pcbWritten = 0;
      return E_NOTIMPL;
    }

    цел Commit(бцел hrfCommitFlags) {
      return E_NOTIMPL;
    }

    цел Revert() {
      return E_NOTIMPL;
    }

    цел LockRegion(бдол libOffset, бдол cb, бцел dwLockType) {
      return E_NOTIMPL;
    }

    цел UnlockRegion(бдол libOffset, бдол cb, бцел dwLockType) {
      return E_NOTIMPL;
    }

    цел Stat(out STATSTG pstatstg, бцел grfStatFlag) {
      дол размер;
      if (GetFileSizeEx(handle_, размер) != 0)
        pstatstg.cbSize = cast(бдол)размер;
      return S_OK;
    }

    цел Clone(out IStream ppstm) {
      ppstm = null;
      return E_NOTIMPL;
    }

  }

  рез = null;

  бцел mode = (флаги & STGM_CREATE) ? CREATE_ALWAYS : OPEN_EXISTING;
  бцел access = GENERIC_READ;
  if (флаги & STGM_WRITE)
    access |= GENERIC_WRITE;
  if (флаги & STGM_READWRITE)
    access = GENERIC_READ | GENERIC_WRITE;
  бцел share = FILE_SHARE_READ;

  рез = new FileStream(имяф, mode, access, share);
  return рез ? S_OK : E_FAIL;
}

extern(Windows)
alias ДллИмпорт!("urlmon.dll", "CreateURLMonikerEx",
  цел function(IMoniker pMkCtx, in шим* szURL, IMoniker* ppmk, бцел dwFlags))
  CreateURLMonikerEx;

/*extern(Windows)
alias ДллИмпорт!("urlmon.dll", "URLOpenBlockingStream",
 цел function(IUnknown, in шим*, IStream*, бцел, ук))
 URLOpenBlockingStream;*/

private цел createStreamOnUrl(ткст uri, out IStream рез) {

  рез = null;

  IMoniker url;
  цел hr = CreateURLMonikerEx(null, uri.вУтф16н(), &url, 1);
  scope(exit) tryRelease(url);

  if (hr != S_OK)
    return hr;

  IBindCtx context;
  hr = CreateBindCtx(0, context);
  scope(exit) tryRelease(context);

  if (hr != S_OK)
    return hr;

  hr = url.BindToStorage(context, null, uuidof!(IStream), retval(рез));
  return (hr != S_OK) 
    ? E_FAIL 
    : hr;
}

/**
 * Represents a reader that provides forward-only access to XML данные.
 */
abstract class XmlReader {

  /**
   * Creates a new XmlReader экземпляр with the specified URI, XmlReaderSettings and XmlParserContext objects.
   */
  static XmlReader create(ткст inputUri, XmlReaderSettings settings = null, XmlParserContext context = null) {

    IStream getStream(ткст uri) {
      if (uri.индексУ(":\\") == 1) {
        // eg: C:\...
        IStream ret;
        createStreamOnFile(uri, STGM_READ, ret);
        return ret;
      }
      else if (uri.индексУ(':') > 0
        && (uri.начинаетсяС("http") || uri.начинаетсяС("https") || uri.начинаетсяС("ftp"))) {
        IStream ret;
        createStreamOnUrl(uri, ret);
        return ret;
      }
      return null;
    }

    if (settings is null)
      settings = new XmlReaderSettings;

    return createImpl(getStream(inputUri), settings, inputUri, context);
  }

  /**
   * Creates a new XmlReader экземпляр with the specified поток, XmlReaderSettings and XmlParserContext objects.
   */
  static XmlReader create(Поток ввод, XmlReaderSettings settings = null, XmlParserContext context = null) {
    if (settings is null)
      settings = new XmlReaderSettings;

    return createImpl(new COMStream(ввод), settings, null, context);
  }

  /**
   * Creates a new XmlReader экземпляр with the specified поток, XmlReaderSettings and base URI.
   */
  static XmlReader create(Поток ввод, XmlReaderSettings settings, ткст baseUri) {
    if (settings is null)
      settings = new XmlReaderSettings;

    return createImpl(new COMStream(ввод), settings, baseUri, null);
  }

  private static XmlReader createImpl(IStream ввод, XmlReaderSettings settings, ткст baseUri, XmlParserContext context) {
    if (ввод is null)
      throw new ИсклНулевогоАргумента("ввод");

    if (settings is null)
      settings = new XmlReaderSettings;

    return new XmlLiteReader(ввод, settings, baseUri, context);
  }

  /**
   * Closes the reader.
   */
  abstract проц закрой();

  /**
   * Reads the следщ node from the поток.
   * Возвращает: true if the следщ node was _read successfully; false if there are no more nodes to _read.
   */
  abstract бул читай();

  /**
   * Checks that the текущ node is an element and advances the reader to the следщ node.
   * Параметры:
   *   localName = The local _name of the element.
   *   имя = The qualified _name of the element.
   *   ns = The namespace URI of the element.
   */
  проц readStartElement(ткст localName, ткст ns) {
    if (moveToContent() != XmlNodeType.Element)
      throw new XmlException(XmlNodeTypeString[nodeType] ~ " is an invalid XmlNodeType.", linconstber, linePosition);
    if (localName != this.localName || ns != namespaceURI)
      throw new XmlException("Element '"~ localName ~ "' with namespace имя '" ~ ns ~ "' not found.", linconstber, linePosition);
    читай();
  }

  /**
   * ditto
   */
  проц readStartElement(ткст имя) {
    if (moveToContent() != XmlNodeType.Element)
      throw new XmlException(XmlNodeTypeString[nodeType] ~ " is an invalid XmlNodeType.", linconstber, linePosition);
    if (имя != this.имя)
      throw new XmlException("Element '"~ имя ~ "' not found.", linconstber, linePosition);
    читай();
  }

  /**
   * ditto
   */
  проц readStartElement() {
    if (moveToContent() != XmlNodeType.Element)
      throw new XmlException(XmlNodeTypeString[nodeType] ~ " is an invalid XmlNodeType.", linconstber, linePosition);
    читай();
  }

  /**
   * Checks that the текущ content node is an end tag and advances the reader to the следщ node.
   */
  проц readEndElement() {
    if (moveToContent() != XmlNodeType.EndElement)
      throw new XmlException(XmlNodeTypeString[nodeType] ~ " is an invalid XmlNodeType.", linconstber, linePosition);
    читай();
  }

  /**
   * Reads a text-only element.
   * Параметры:
   *   localName = The local _name of the element.
   *   имя = The qualified _name of the element.
   *   ns = The namespace URI of the element.
   */
  ткст readElementString(ткст localName, ткст ns) {
    if (moveToContent() != XmlNodeType.Element)
      throw new XmlException(XmlNodeTypeString[nodeType] ~ " is an invalid XmlNodeType.", linconstber, linePosition);
    if (localName != this.localName || ns != namespaceURI)
      throw new XmlException("Element '"~ localName ~ "' with namespace имя '" ~ ns ~ "' not found.", linconstber, linePosition);
    ткст рез = "";
    if (!isEmptyElement) {
      рез = readString();
      if (nodeType != XmlNodeType.EndElement)
        throw new XmlException(XmlNodeTypeString[nodeType] ~ " is an invalid XmlNodeType.", linconstber, linePosition);
      читай();
    }
    else
      читай();
    return рез;
  }

  /**
   * ditto
   */
  ткст readElementString(ткст имя) {
    if (moveToContent() != XmlNodeType.Element)
      throw new XmlException(XmlNodeTypeString[nodeType] ~ " is an invalid XmlNodeType.", linconstber, linePosition);
    if (имя != this.имя)
      throw new XmlException("Element '"~ имя ~ "' not found.", linconstber, linePosition);
    ткст рез = "";
    if (!isEmptyElement) {
      рез = readString();
      if (nodeType != XmlNodeType.EndElement)
        throw new XmlException(XmlNodeTypeString[nodeType] ~ " is an invalid XmlNodeType.", linconstber, linePosition);
      читай();
    }
    else
      читай();
    return рез;
  }

  /**
   * ditto
   */
  ткст readElementString() {
    if (moveToContent() != XmlNodeType.Element)
      throw new XmlException(XmlNodeTypeString[nodeType] ~ " is an invalid XmlNodeType.", linconstber, linePosition);
    ткст рез = "";
    if (!isEmptyElement) {
      читай();
      рез = readString();
      if (nodeType != XmlNodeType.EndElement)
        throw new XmlException("Unexpected node тип '" ~ XmlNodeTypeString[nodeType] ~ "'. 'readElementString' метод can only be called on elements with simple content.", linconstber, linePosition);
      читай();
    }
    else
      читай();
    return рез;
  }

  /**
   * Advances the XmlReader to the следщ descendant element.
   *   localName = The local _name of the element.
   *   имя = The qualified _name of the element.
   *   namespaceURI = The namespace URI of the element.
   */
  бул readToDescendant(ткст localName, ткст namespaceURI) {
    цел depth = this.depth;
    if (nodeType != XmlNodeType.Element) {
      if (readState != XmlReadState.Interactive)
        return false;
      depth--;
    }
    else if (isEmptyElement)
      return false;
    while (читай() && this.depth > depth) {
      if (nodeType == XmlNodeType.Element && localName == this.localName && namespaceURI == this.namespaceURI)
        return true;
    }
    return false;
  }

  /**
   * ditto
   */
  бул readToDescendant(ткст имя) {
    цел depth = this.depth;
    if (nodeType != XmlNodeType.Element) {
      if (readState != XmlReadState.Interactive)
        return false;
      depth--;
    }
    else if (isEmptyElement)
      return false;
    while (читай() && this.depth > depth) {
      if (nodeType == XmlNodeType.Element && имя == this.имя)
        return true;
    }
    return false;
  }

  /**
   * Reads until the named element is found.
   *   localName = The local _name of the element.
   *   имя = The qualified _name of the element.
   *   namespaceURI = The namespace URI of the element.
   */
  бул readToFollowing(ткст localName, ткст namespaceURI) {
    while (читай()) {
      if (nodeType == XmlNodeType.Element && localName == this.localName && namespaceURI == this.namespaceURI)
        return true;
    }
    return false;
  }

  /**
   * ditto
   */
  бул readToFollowing(ткст имя) {
    while (читай()) {
      if (nodeType == XmlNodeType.Element && имя == this.имя)
        return true;
    }
    return false;
  }

  /**
   * Advances the XmlReader to the следщ sibling element.
   *   localName = The local _name of the element.
   *   имя = The qualified _name of the element.
   *   namespaceURI = The namespace URI of the element.
   */
  бул readToNextSibling(ткст localName, ткст namespaceURI) {
    XmlNodeType nt;
    do {
      skip();
      nt = nodeType;
      if (nt == XmlNodeType.Element && localName == this.localName && namespaceURI != this.namespaceURI)
        return true;
    } while (nt != XmlNodeType.EndElement && !isEOF);
    return false;
  }
  
  /**
   * ditto
   */
  бул readToNextSibling(ткст имя) {
    XmlNodeType nt;
    do {
      skip();
      nt = nodeType;
      if (nt == XmlNodeType.Element && имя == this.имя)
        return true;
    } while (nt != XmlNodeType.EndElement && !isEOF);
    return false;
  }

  /**
   * If the текущ node is not a content node, the reader skips ahead to the следщ content node or end of file.
   */
  XmlNodeType moveToContent() {
    do {
      switch (nodeType) {
        case XmlNodeType.Attribute:
          moveToElement();
          // Fall through
        case XmlNodeType.Element, 
          XmlNodeType.EndElement, 
          XmlNodeType.CDATA, 
          XmlNodeType.Text, 
          XmlNodeType.EntityReference, 
          XmlNodeType.EndEntity:
          return nodeType;
        default:
      }
    } while (читай());
    return nodeType;
  }

  /**
   * Reads the contents of an element or text node.
   * Возвращает: The contents of an element.
   */
  ткст readString() {
    if (readState != XmlReadState.Interactive)
      return "";

    moveToElement();
    if (nodeType == XmlNodeType.Element) {
      if (isEmptyElement)
        return "";
      if (!читай())
        throw new ИсклНеправильнОперации;
      if (nodeType == XmlNodeType.EndElement)
        return "";
    }

    ткст рез = "";
    if (0b000110000000011000 & (1 << nodeType)) {
      рез ~= значение;
      if (!читай())
        return рез;
    }
    return рез;
  }

  /**
   * Skips the children of the текущ node.
   */
  проц skip() {
    if (readState == XmlReadState.Interactive) {
      moveToElement();
      if (nodeType == XmlNodeType.Element && !isEmptyElement) {
        цел depth = this.depth;
        while (читай() && depth < this.depth) {
          // do nothing
        }
        if (nodeType == XmlNodeType.EndElement)
          читай();
      }
      else
        читай();
    }
  }

  /**
   * Moves to the first attribute.
   * Возвращает: true if an attribute существует; otherwise, false.
   */
  abstract бул moveToFirstAttribute();

  /**
   * Moves to the следщ attribute.
   * Возвращает: true if there is a следщ attribute; otherwise, false.
   */
  abstract бул moveToNextAttribute();

  /**
   * Moves to the specified attribute.
   * Параметры:
   *   localName = The local _name of the element.
   *   имя = The qualified _name of the element.
   *   namespaceURI = The namespace URI of the element.
   * Возвращает: true if the attribute is found; otherwise, false.
   */
  abstract бул moveToAttribute(ткст localName, ткст namespaceURI);

  /**
   * ditto
   */
  abstract бул moveToAttribute(ткст имя);

  /**
   * Moves to the element that содержит the текущ attribute node.
   * Возвращает: true if the reader is positioned on an attribute; otherwise, false.
   */
  abstract бул moveToElement();

  /**
   * Gets the значение of an attribute.
   * Параметры:
   *   localName = The local _name of the element.
   *   имя = The qualified _name of the element.
   *   namespaceURI = The namespace URI of the element.
   * Возвращает: The значение of the specified attribute.
   */
  abstract ткст getAttribute(ткст localName, ткст namespaceURI);

  /**
   * ditto
   */
  abstract ткст getAttribute(ткст имя);

  /**
   * Gets the state of the reader.
   */
  abstract XmlReadState readState();

  /**
   * Gets the _depth of the текущ node in the XML document.
   */
  abstract цел depth();

  /**
   * Gets a значение indicating whether the reader is positioned at the end of the поток.
   */
  abstract бул isEOF();

  /**
   * Gets a значение indicating whether the текущ node is an пустой element.
   */
  abstract бул isEmptyElement();

  /**
   * Gets a значение indicating whether the текущ node is an attribute generated from the default значение defined in the DTD or schema.
   */
  бул isDefault() {
    return false;
  }

  /**
   * Gets the тип of the текущ node.
   */
  abstract XmlNodeType nodeType();

  /**
   * Gets the base URI of the текущ node.
   */
  abstract ткст baseURI();

  /**
   * Gets the qualified _name of the текущ node.
   */
  abstract ткст имя();

  /**
   * Gets the namespace _prefix of the текущ node.
   */
  abstract ткст prefix();

  /**
   * Gets the local имя of the текущ node.
   */
  abstract ткст localName();

  /**
   * Gets the namespace URI of the текущ node.
   */
  abstract ткст namespaceURI();

  /**
   * Gets a значение indicating whether the текущ node has a значение.
   */
  abstract бул hasValue();

  /**
   * Gets the text _value of the текущ node.
   */
  abstract ткст значение();

  /**
   * Gets a значение indicating whether the текущ node has any атрибуты.
   */
  бул hasAttributes() {
    return attributeCount > 0;
  }

  /**
   * Gets the число of атрибуты on the текущ node.
   */
  abstract цел attributeCount();

  /**
   */
  abstract цел linconstber();

  /**
   */
  abstract цел linePosition();

  /**
   * Gets the значение of the attribute.
   * Параметры:
   *   localName = The local _name of the element.
   *   имя = The qualified _name of the element.
   *   namespaceURI = The namespace URI of the element.
   * Возвращает: The значение of the specified attribute.
   */
  ткст opIndex(ткст localName, ткст namespaceURI) {
    return getAttribute(localName, namespaceURI);
  }

  /**
   * ditto
   */
  ткст opIndex(ткст имя) {
    return getAttribute(имя);
  }

  private this() {
  }

}

private final class XmlLiteReader : XmlReader {

  private IXmlReader readerImpl_;
  private IStream stream_;
  private IMultiLanguage2 mlang_;

  this(IStream ввод, XmlReaderSettings settings, ткст baseUri, XmlParserContext context) {
    цел hr = CreateXmlReader(uuidof!(IXmlReader), cast(ук*)&readerImpl_, null);
    if (hr != S_OK)
      throw new КОМИскл(hr);

    mlang_ = CMultiLanguage.coCreate!(IMultiLanguage2);
    readerImpl_.SetProperty(XmlReaderProperty.MultiLanguage, cast(цел)cast(ук)mlang_);
    readerImpl_.SetProperty(XmlReaderProperty.ConformanceLevel, cast(цел)settings.conformanceLevel);
    readerImpl_.SetProperty(XmlReaderProperty.DtdProcessing, settings.prohibitDtd ? 0 : 1);

    Кодировка кодировка;
    if (context !is null) {
      кодировка = context.кодировка;
      if (context.baseURI != null && context.baseURI != baseUri)
        baseUri = context.baseURI;
    }
    if (кодировка is null)
      кодировка = Кодировка.УТФ8;

    stream_ = ввод;

    IUnknown readerInput;
    hr = CreateXmlReaderInputWithEncodingName(stream_, null, кодировка.вебИмя().вУтф16н(), 0, baseUri.вУтф16н(), &readerInput);
    if (hr != S_OK)
      throw new КОМИскл(hr);
    hr = readerImpl_.SetInput(readerInput);
    if (hr != S_OK)
      throw new КОМИскл(hr);
  }

  ~this() {
    закрой();
  }

  override проц закрой() {
    if (stream_ !is null) {
      tryRelease(stream_);
      stream_ = null;
    }
    if (readerImpl_ !is null) {
      tryRelease(readerImpl_);
      readerImpl_ = null;
    }
    if (mlang_ !is null) {
      tryRelease(mlang_);
      mlang_ = null;
    }
  }

  override бул читай() {
    XmlNodeType nodeType;
    return readerImpl_.Read(nodeType) == S_OK;
  }

  override бул moveToFirstAttribute() {
    return readerImpl_.MoveToFirstAttribute() != S_FALSE;
  }

  override бул moveToNextAttribute() {
    return readerImpl_.MoveToNextAttribute() != S_FALSE;
  }

  override бул moveToAttribute(ткст имя) {
    return readerImpl_.MoveToAttributeByName(имя.вУтф16н(), null) != S_FALSE;
  }

  override бул moveToAttribute(ткст localName, ткст namespaceURI) {
    return readerImpl_.MoveToAttributeByName(localName.вУтф16н(), namespaceURI.вУтф16н()) != S_FALSE;
  }

  override бул moveToElement() {
    return readerImpl_.MoveToElement() != S_FALSE;
  }

  override ткст getAttribute(ткст имя) {
    if (moveToAttribute(имя))
      return значение;
    return null;
  }

  override ткст getAttribute(ткст localName, ткст namespaceURI) {
    if (moveToAttribute(localName, namespaceURI))
      return значение;
    return null;
  }

  override XmlReadState readState() {
    цел значение;
    readerImpl_.GetProperty(XmlReaderProperty.ReadState, значение);
    return cast(XmlReadState)значение;
  }

  override цел depth() {
    бцел значение;
    readerImpl_.GetDepth(значение);
    return cast(бцел)значение;
  }

  override бул isEOF() {
    return readerImpl_.IsEOF() != 0;
  }

  override бул isEmptyElement() {
    return readerImpl_.IsEmptyElement() != 0;
  }

  override бул isDefault() {
    return readerImpl_.IsDefault() != 0;
  }

  override XmlNodeType nodeType() {
    XmlNodeType nodeType;
    readerImpl_.GetNodeType(nodeType);
    return nodeType;
  }

  override ткст baseURI() {
    шим* pwsz;
    бцел cwch;
    readerImpl_.GetBaseUri(pwsz, cwch);
    return вУтф8(pwsz, 0, cwch);
  }

  override ткст имя() {
    шим* pwsz;
    бцел cwch;
    readerImpl_.GetQualifiedName(pwsz, cwch);
    return вУтф8(pwsz, 0, cwch);
  }

  override ткст prefix() {
    шим* pwsz;
    бцел cwch;
    readerImpl_.GetPrefix(pwsz, cwch);
    return вУтф8(pwsz, 0, cwch);
  }

  override ткст localName() {
    шим* pwsz;
    бцел cwch;
    readerImpl_.GetLocalName(pwsz, cwch);
    return вУтф8(pwsz, 0, cwch);
  }

  override ткст namespaceURI() {
    шим* pwsz;
    бцел cwch;
    readerImpl_.GetNamespaceUri(pwsz, cwch);
    return вУтф8(pwsz, 0, cwch);
  }

  override бул hasValue() {
    return (0b100110010110011100 & (1 << nodeType)) != 0;
  }

  override ткст значение() {
    шим* pwsz;
    бцел cwch;
    readerImpl_.GetValue(pwsz, cwch);
    return вУтф8(pwsz, 0, cwch);
  }

  override цел attributeCount() {
    бцел значение;
    readerImpl_.GetAttributeCount(значение);
    return значение;
  }

  override цел linconstber() {
    бцел значение;
    readerImpl_.GetLinconstber(значение);
    return cast(цел)значение;
  }

  override цел linePosition() {
    бцел значение;
    readerImpl_.GetLinePosition(значение);
    return cast(бцел)значение;
  }

}

/**
 * Specifies features to support on the XmlWriter object.
 */
final class XmlWriterSettings {

  private Кодировка кодировка_;
  private XmlConformanceLevel conformanceLevel_;
  private цел indent_;
  private бул omitXmlDeclaration_;

  /**
   * Initialized a new экземпляр.
   */
  this() {
    сбрось();
  }

  /**
   * Resets the members to their default значения.
   */
  проц сбрось() {
    кодировка_ = Кодировка.УТФ8;
    conformanceLevel_ = XmlConformanceLevel.Document;
    indent_ = -1;
    omitXmlDeclaration_ = false;
  }

  /**
   * Gets or sets the тип of text кодировка to use.
   */
  проц кодировка(Кодировка значение) {
    кодировка_ = значение;
  }

  /**
   * ditto
   */
  Кодировка кодировка() {
    return кодировка_;
  }

  /**
   * Gets or sets the уровень of conformance the XmlReader complies with.
   */
  проц conformanceLevel(XmlConformanceLevel значение) {
    conformanceLevel_ = значение;
  }

  /**
   * ditto
   */
  XmlConformanceLevel conformanceLevel() {
    return conformanceLevel_;
  }

  /**
   * Gets or sets a значение indicating whether to _indent elements.
   */
  проц indent(бул значение) {
    indent_ = значение ? 1 : 0;
  }

  /**
   * ditto
   */
  бул indent() {
    return indent_ == 1;
  }

  /**
   * Gets or sets a значение indicating whether to пиши an XML declaration.
   */
  бул omitXmlDeclaration() {
    return omitXmlDeclaration_;
  }

  /**
   * ditto
   */
  проц omitXmlDeclaration(бул значение) {
    omitXmlDeclaration_ = значение;
  }

}

/**
 * Represents a writer that provides a forward-only means of generating streams or files containing XML данные.
 */
abstract class XmlWriter {

  /**
   * Creates a new экземпляр.
   * Параметры:
   *   outputFileName = The file to пиши to.
   *   settings = The XmlWriterSettings object used to configure the new экземпляр.
   * Возвращает: A new XmlWriter экземпляр.
   */
  static XmlWriter create(ткст outputFileName, XmlWriterSettings settings = null) {
    if (settings is null)
      settings = new XmlWriterSettings;

    IStream вывод;
    createStreamOnFile(outputFileName, STGM_CREATE | STGM_WRITE, вывод);
    return createImpl(вывод, settings.кодировка, settings);
  }

  /**
   * Creates a new экземпляр.
   * Параметры:
   *   вывод = The поток to пиши to.
   *   settings = The XmlWriterSettings object used to configure the new экземпляр.
   * Возвращает: A new XmlWriter экземпляр.
   */
  static XmlWriter create(Поток вывод, XmlWriterSettings settings = null) {
    if (вывод is null)
      throw new ИсклНулевогоАргумента("вывод");

    if (settings is null)
      settings = new XmlWriterSettings;

    return createImpl(new COMStream(вывод), settings.кодировка, settings);
  }

  private static XmlWriter createImpl(IStream вывод, Кодировка кодировка, XmlWriterSettings settings) {
    return new XmlLiteWriter(вывод, кодировка, settings);
  }

  /**
   * Closes this поток.
   */
  abstract проц закрой();

  /**
   * Writes out all the атрибуты.
   */
  abstract проц writeAttributes(XmlReader reader, бул defattr);

  /**
   * Writes an attribute.
   */
  abstract проц writeAttributeString(ткст prefix, ткст localname, ткст ns, ткст значение);

  /**
   * ditto
   */
  final проц writeAttributeString(ткст localName, ткст ns, ткст значение) {
    writeAttributeString(null, localName, ns, значение);
  }

  /**
   * ditto
   */
  final проц writeAttributeString(ткст localName, ткст значение) {
    writeAttributeString(localName, null, значение);
  }

  /**
   * Writes out a &lt;![CDATA[...]]&gt; block containing the specified _text.
   */
  abstract проц writeCData(ткст text);

  /**
   * Writes a character entity for the specified character значение.
   */
  abstract проц writeCharEntity(сим ch);

  /**
   * Writes the text contained in the specified _buffer.
   */
  abstract проц writeChars(in сим[] буфер, цел индекс, цел счёт);

  /**
   * Writes out a &lt;!--...--&gt; containing the specified _text.
   */
  abstract проц writeComment(ткст text);

  /**
   * Writes the DOCTYPE declaration with the specified _name and optional атрибуты.
   */
  abstract проц writeDocType(ткст имя, ткст pubid, ткст sysid, ткст subset);

  /**
   * Writes an element containing the specified _value.
   */
  abstract проц writeElementString(ткст prefix, ткст localName, ткст ns, ткст значение);

  /**
   * ditto
   */
  final проц writeElementString(ткст localName, ткст ns, ткст значение) {
    writeElementString(null, localName, ns, значение);
  }

  /**
   * ditto
   */
  final проц writeElementString(ткст localName, ткст значение) {
    writeElementString(localName, null, значение);
  }

  /**
   * Closes any open elements or атрибуты.
   */
  abstract проц writeEndDocument();

  /**
   * Closes one element and pops the corresponding namespace scope.
   */
  abstract проц writeEndElement();

  /**
   * Writes out an entity reference as &имя;.
   */
  abstract проц writeEntityRef(ткст имя);

  /**
   * Closes one element and pops the corresponding namespace scope.
   */
  abstract проц writeFullEndElement();

  /**
   * Writes out the specified _name.
   */
  abstract проц writeName(ткст имя);

  /**
   * Writes out the specified _name.
   */
  abstract проц writeNmToken(ткст имя);

  /**
   * Copies everything from the исток _reader to the текущ writer.
   * Параметры:
   *   reader = The XmlReader to читай from.
   *   defattr = true to копируй the default атрибуты from reader; otherwise, false.
   */
  abstract проц writeNode(XmlReader reader, бул defattr);

  /**
   * Writes out a processing instruction as follows: &lt;?имя text?&gt;.
   */
  abstract проц writeProcessingInstruction(ткст имя, ткст text);

  /**
   * Writes out the namespace-qualified имя.
   */
  abstract проц writeQualifiedName(ткст localName, ткст ns);

  /**
   * Writes raw markup from a ткст.
   */
  abstract проц writeRaw(ткст данные);

  /**
   * Writes raw markup from a character буфер.
   */
  abstract проц writeRaw(сим[] буфер, цел индекс, цел счёт);

  /**
   * Writes the XML declaration.
   * Параметры: standalone = If true, writes "standalone=yes"; if false, "standalone=no".
   */
  abstract проц writeStartDocument(бул standalone);

  /**
   * ditto
   */
  abstract проц writeStartDocument();

  /**
   * Writes the specified start tag.
   */
  abstract проц writeStartElement(ткст prefix, ткст localName, ткст ns);

  /**
   * ditto
   */
  final проц writeStartElement(ткст localName, ткст ns) {
    writeStartElement(null, localName, ns);
  }

  /**
   * ditto
   */
  final проц writeStartElement(ткст localName) {
    writeStartElement(null, localName, null);
  }

  /**
   * Writes the specified _text content.
   */
  abstract проц writeString(ткст text);

  /**
   * Writes out the specified white space.
   */
  abstract проц writeWhitespace(ткст ws);

  /**
   * Flushes whatever is in the буфер to the underlying поток, then flushes the underlying поток.
   */
  abstract проц слей();

  /**
   * Encodes the specified binary байты as Base64 and writes out the resulting text.
   */
  abstract проц writeBase64(проц[] буфер, цел индекс, цел счёт);

}

private final class XmlLiteWriter : XmlWriter {

  private IXmlWriter writerImpl_;
  private IMultiLanguage2 mlang_;
  private IStream stream_;

  this(IStream вывод, Кодировка кодировка, XmlWriterSettings settings) {
    цел hr = CreateXmlWriter(uuidof!(IXmlWriter), cast(ук*)&writerImpl_, null);

    if (кодировка is null)
      кодировка = Кодировка.УТФ8;

    mlang_ = CMultiLanguage.coCreate!(IMultiLanguage2);
    writerImpl_.SetProperty(XmlWriterProperty.MultiLanguage, cast(цел)cast(ук)mlang_);
    writerImpl_.SetProperty(XmlWriterProperty.ConformanceLevel, cast(цел)settings.conformanceLevel);
    writerImpl_.SetProperty(XmlWriterProperty.OmitXmlDeclaration, settings.omitXmlDeclaration ? 1 : 0);
    writerImpl_.SetProperty(XmlWriterProperty.Indent, settings.indent ? 1 : 0);

    stream_ = вывод;

    IUnknown writerOutput;
    hr = CreateXmlWriterOutputWithEncodingName(stream_, null, кодировка.вебИмя().вУтф16н(), &writerOutput);
    if (hr != S_OK)
      throw new КОМИскл(hr);
    hr = writerImpl_.SetOutput(writerOutput);
    if (hr != S_OK)
      throw new КОМИскл(hr);
  }

  ~this() {
    закрой();
  }

  override проц закрой() {
    if (stream_ !is null) {
      tryRelease(stream_);
      stream_ = null;
    }
    if (mlang_ !is null) {
      tryRelease(mlang_);
      mlang_ = null;
    }
    if (writerImpl_ !is null) {
      tryRelease(writerImpl_);
      writerImpl_ = null;
    }
  }

  override проц writeAttributes(XmlReader reader, бул defattr) {
    if (reader is null)
      throw new ИсклНулевогоАргумента("reader");

    if (auto r = cast(XmlLiteReader)reader)
      writerImpl_.WriteAttributes(r.readerImpl_, defattr ? 1 : 0);
  }

  override проц writeAttributeString(ткст prefix, ткст localName, ткст ns, ткст значение) {
    writerImpl_.WriteAttributeString(prefix.вУтф16н(), localName.вУтф16н(), ns.вУтф16н(), значение.вУтф16н());
  }

  override проц writeCData(ткст text) {
    writerImpl_.WriteCData(text.вУтф16н());
  }

  override проц writeCharEntity(сим ch) {
    writerImpl_.WriteCharEntity(ch);
  }

  override проц writeChars(in сим[] буфер, цел индекс, цел счёт) {
    writerImpl_.WriteChars(буфер.вУтф16н(индекс), счёт);
  }

  override проц writeComment(ткст text) {
    writerImpl_.WriteComment(text.вУтф16н());
  }

  override проц writeDocType(ткст имя, ткст pubid, ткст sysid, ткст subset) {
    writerImpl_.WriteDocType(имя.вУтф16н(), pubid.вУтф16н(), sysid.вУтф16н(), subset.вУтф16н());
  }

  override проц writeElementString(ткст prefix, ткст localName, ткст ns, ткст значение) {
    writerImpl_.WriteElementString(prefix.вУтф16н(), localName.вУтф16н(), ns.вУтф16н(), значение.вУтф16н());
  }

  override проц writeEndDocument() {
    writerImpl_.WriteEndDocument();
  }

  override проц writeEndElement() {
    writerImpl_.WriteEndElement();
  }

  override проц writeEntityRef(ткст имя) {
    writerImpl_.WriteEntityRef(имя.вУтф16н());
  }

  override проц writeFullEndElement() {
    writerImpl_.WriteFullEndElement();
  }

  override проц writeName(ткст имя) {
    writerImpl_.WriteName(имя.вУтф16н());
  }

  override проц writeNmToken(ткст имя) {
    writerImpl_.WriteNmToken(имя.вУтф16н());
  }

  override проц writeNode(XmlReader reader, бул defattr) {
    if (reader is null)
      throw new ИсклНулевогоАргумента("reader");

    if (auto r = cast(XmlLiteReader)reader)
      writerImpl_.WriteNode(r.readerImpl_, defattr ? 1 : 0);
  }

  override проц writeProcessingInstruction(ткст имя, ткст text) {
    writerImpl_.WriteProcessingInstruction(имя.вУтф16н(), text.вУтф16н());
  }

  override проц writeQualifiedName(ткст localName, ткст ns) {
    writerImpl_.WriteQualifiedName(localName.вУтф16н(), ns.вУтф16н());
  }

  override проц writeRaw(ткст данные) {
    writerImpl_.WriteRaw(данные.вУтф16н());
  }

  override проц writeRaw(сим[] буфер, цел индекс, цел счёт) {
    writerImpl_.WriteRawChars(буфер.вУтф16н(индекс), счёт);
  }

  override проц writeStartDocument() {
    writerImpl_.WriteStartDocument(XmlStandalone.Omit);
  }

  override проц writeStartDocument(бул standalone) {
    writerImpl_.WriteStartDocument(standalone ? XmlStandalone.Yes : XmlStandalone.No);
  }
  
  override проц writeStartElement(ткст prefix, ткст localName, ткст ns) {
    writerImpl_.WriteStartElement(prefix.вУтф16н(), localName.вУтф16н(), ns.вУтф16н());
  }

  override проц writeString(ткст text) {
    writerImpl_.WriteString(text.вУтф16н());
  }

  override проц writeWhitespace(ткст ws) {
    writerImpl_.WriteWhitespace(ws.вУтф16н());
  }

  override проц слей() {
    writerImpl_.Flush();
  }

  override проц writeBase64(проц[] буфер, цел индекс, цел счёт) {
    writeChars(кодируй64(cast(ткст)буфер), индекс, счёт);
  }

}