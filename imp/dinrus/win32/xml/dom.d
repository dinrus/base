/**
 * Provides standards-based support for processing XML.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.xml.dom;

import win32.base.core,
  win32.base.string,
  win32.com.core,
  win32.xml.core,
  win32.xml.msxml,
  stdrus, tpl.stream;

debug import stdrus : скажифнс;

/**
 * Adds namespaces to a collection and provides scope management.
 *
 * Примеры:
 * ---
 * scope mgr = new XmlNamespaceManager;
 * mgr.addNamespace("rdf", "http://www.w3.org/1999/02/22-rdf-syntax-ns#");
 * mgr.addNamespace("dc", "http://purl.org/dc/elements/1.1/");
 * mgr.addNamespace("rss", "http://purl.org/rss/1.0/");
 *
 * scope doc = new XmlDocument;
 * doc.загрузи("http://del.icio.us/rss");
 * foreach (node; doc.documentElement.selectNodes("/rdf:RDF/rss:элт", mgr)) {
 *   if (node !is null)
 *     скажифнс(node.text);
 * }
 * ---
 */
class XmlNamespaceManager {

  private IMXNamespaceManager nsmgrImpl_;

  this() {
    if ((nsmgrImpl_ = MXNamespaceManager60.coCreate!(IMXNamespaceManager)) is null) {
      if ((nsmgrImpl_ = MXNamespaceManager40.coCreate!(IMXNamespaceManager)) is null) {
        nsmgrImpl_ = MXNamespaceManager.coCreate!(IMXNamespaceManager, ExceptionPolicy.Throw);
      }
    }
  }

  /**
   * Adds the given namespace to the collection.
   * Параметры:
   *   prefix = The _prefix to associate with the namespace being added.
   *   uri = The namespace to добавь.
   */
  проц addNamespace(ткст prefix, ткст uri) {
    nsmgrImpl_.declarePrefix(prefix.вЮ16н(), uri.вЮ16н());
  }

  /**
   * Retrieves a значение indicating whether the supplied _prefix has a namespace for the текущ scope.
   * Параметры: prefix = The _prefix of the namespace to найди.
   * Возвращает: true if a namespace is defined; otherwise, false.
   */
  бул hasNamespace(ткст prefix) {
    цел cchUri;
    return (nsmgrImpl_.getURI(prefix.вЮ16н(), null, null, cchUri) == S_OK);
  }

  /**
   * Finds the prefix with the given namespace.
   * Параметры: uri = The namespace to resolve for the prefix.
   * Возвращает: The matching prefix.
   */
  ткст lookupPrefix(ткст uri) {
    шим[100] pwchPrefix;
    цел cchPrefix = pwchPrefix.length;
    if (nsmgrImpl_.getPrefix(uri.вЮ16н(), 0, pwchPrefix.ptr, cchPrefix) == S_OK)
      return вУтф8(pwchPrefix.ptr, 0, cchPrefix);
    return null;
  }

  /**
   * Finds the namespace for the specified _prefix.
   * Параметры: prefix = The _prefix whose namespace you want to resolve.
   * Возвращает: The namespace for prefix.
   */
  ткст lookupNamespace(ткст prefix) {
    шим[100] pwchUri;
    цел cchUri = pwchUri.length;
    if (nsmgrImpl_.getURI(prefix.вЮ16н(), null, pwchUri.ptr, cchUri) == S_OK)
      return вУтф8(pwchUri.ptr, 0, cchUri);
    return null;
  }

  /**
   * Pops a namespace scope off the stack.
   * Возвращает: true if there are namespace scopes лево on the stack; otherwise, false.
   */
  бул popScope() {
    return (nsmgrImpl_.popContext() == S_OK);
  }

  /**
   * Pushes a namespace scope onto the stack.
   */
  проц pushScope() {
    nsmgrImpl_.pushContext();
  }

  /**
   * Provides foreach-style iteratation through the prefixes stored.
   */
  цел opApply(цел delegate(ref ткст) действие) {
    цел рез, индекс, hr;
    do {
      шим[100] pwchPrefix;
      цел cchPrefix = pwchPrefix.length;
      if ((hr = nsmgrImpl_.getDeclaredPrefix(индекс, pwchPrefix.ptr, cchPrefix)) == S_OK) {
        ткст s = вУтф8(pwchPrefix.ptr, 0, cchPrefix);
        if ((рез = действие(s)) != 0)
          break;
        индекс++;
      }
    } while (hr == S_OK);
    return рез;
  }

  ~this() {
    if (nsmgrImpl_ !is null) {
      tryRelease(nsmgrImpl_);
      nsmgrImpl_ = null;
    }
  }

}

/*package*/ XmlNode getNodeShim(IXMLDOMNode node) {

  бул isXmlDeclaration(IXMLDOMNode node) {
    шим* bstrName;
    if (node.get_nodeName(bstrName) == S_OK)
      return (изБткст(bstrName) == "xml");
    return false; 
  }

  бул parseXmlDeclaration(IXMLDOMNode node, out ткст xmlversion, out ткст кодировка, out ткст standalone) {

    ткст getAttrValue(IXMLDOMNamedNodeMap attrs, ткст имя) {
      ткст значение;
      IXMLDOMNode namedItem;

      шим* bstrName = toBstr(имя);
      if (attrs.getNamedItem(bstrName, namedItem) == S_OK) {
        scope(exit) tryRelease(namedItem);
        VARIANT var;
        if (УДАЧНО(namedItem.get_nodeValue(var))) {
          scope(exit) var.сотри();
          значение = var.вТкст();
        }
      }
      freeBstr(bstrName);
      return значение;
    }

    xmlversion = null, кодировка = null, standalone = null;
    IXMLDOMNamedNodeMap attrs;
    if (node.get_attributes(attrs) == S_OK) {
      scope(exit) tryRelease(attrs);

      xmlversion = getAttrValue(attrs, "version");
      кодировка = getAttrValue(attrs, "кодировка");
      standalone = getAttrValue(attrs, "standalone");

      return true;
    }
    return false;
  }

  if (node is null)
    return null;

  DOMNodeType nt;
  node.get_nodeType(nt);
  switch (nt) {
    case DOMNodeType.NODE_CDATA_SECTION:
      return new XmlCDataSection(node);
    case DOMNodeType.NODE_COMMENT:
      return new XmlComment(node);
    case DOMNodeType.NODE_TEXT:
      return new XmlText(node);
    case DOMNodeType.NODE_ATTRIBUTE:
      return new XmlAttribute(node);
    case DOMNodeType.NODE_ELEMENT:
      return new XmlElement(node);
    case DOMNodeType.NODE_PROCESSING_INSTRUCTION:
      // MSXML doesn't treat XML declarations as a distinct node тип.
      if (isXmlDeclaration(node)) {
        ткст xmlversion, кодировка, standalone;
        if (parseXmlDeclaration(node, xmlversion, кодировка, standalone))
          return new XmlDeclaration(xmlversion, кодировка, standalone, node);
      }
      return new XmlProcessingInstruction(node);
    case DOMNodeType.NODE_ENTITY:
      return new XmlEntity(node);
    case DOMNodeType.NODE_ENTITY_REFERENCE:
      return new XmlEntityReference(node);
    case DOMNodeType.NODE_NOTATION:
      return new XmlNotation(node);
    case DOMNodeType.NODE_DOCUMENT_FRAGMENT:
      return new XmlDocumentFragment(node);
    case DOMNodeType.NODE_DOCUMENT_TYPE:
      return new XmlDocumentType(node);
    case DOMNodeType.NODE_DOCUMENT:
      return new XmlDocument(node);
    default:
  }

  return null;
}

class XPathException : Exception {

  this(ткст сообщение = null) {
    super(сообщение);
  }

}

/**
 * Represents an ordered collection of nodes.
 */
abstract class XmlNodeList {

  /**
   * Retrieves the node at the given _index.
   * Параметры: индекс = The _index into the список of nodes.
   * Возвращает: The node in the collection at индекс.
   */
  abstract XmlNode элт(цел индекс);

  /**
   * ditto
   */
  XmlNode opIndex(цел i) {
    return элт(i);
  }

  /**
   * Gets the число of nodes in the collection.
   * Возвращает: The число of nodes.
   */
  abstract цел размер();

  /**
   * Provides foreach iteration over the collection of nodes.
   */
  abstract цел opApply(цел delegate(ref XmlNode) действие);

  protected this() {
  }

}

private class XmlChildNodes : XmlNodeList {

  private IXMLDOMNodeList listImpl_;

  /*package*/ this(IXMLDOMNodeList listImpl) {
    listImpl_ = listImpl;
  }

  ~this() {
    if (listImpl_ !is null) {
      tryRelease(listImpl_);
      listImpl_ = null;
    }
  }

  override XmlNode элт(цел индекс) {
    IXMLDOMNode node;
    if (УДАЧНО(listImpl_.get_item(индекс, node)))
      return getNodeShim(node);
    return null;
  }

  override цел opApply(цел delegate(ref XmlNode) действие) {
    цел рез;
    IXMLDOMNode node;
    do {
      if (УДАЧНО(listImpl_.nextNode(node))) {
        XmlNode n = getNodeShim(node);
        if ((рез = действие(n)) != 0)
          break;
      }
    } while (node !is null);
    listImpl_.сбрось();
    return рез;
  }

  override цел размер() {
    цел length;
    return УДАЧНО(listImpl_.get_length(length)) ? length : 0;
  }

}

private class XPathNodeList : XmlNodeList {

  private IXMLDOMSelection iterator_;

  this(IXMLDOMSelection iterator) {
    iterator_ = iterator;
  }

  ~this() {
    if (iterator_ !is null) {
      tryRelease(iterator_);
      iterator_ = null;
    }
  }

  override XmlNode элт(цел индекс) {
    IXMLDOMNode listItem;
    iterator_.get_item(индекс, listItem);
    return getNodeShim(listItem);
  }

  override цел размер() {
    цел listLength;
    iterator_.get_length(listLength);
    return listLength;
  }

  override цел opApply(цел delegate(ref XmlNode) действие) {
    цел рез = 0;

    цел hr;
    IXMLDOMNode n;

    while ((hr = iterator_.nextNode(n)) == S_OK) {
      XmlNode node = getNodeShim(n);
      if ((рез = действие(node)) != 0)
        break;
    }

    iterator_.сбрось();
    return рез;
  }

}

/**
 * Provides a way to navigate XML данные.
 */
abstract class XPathNavigator {

  /**
   * Determines whether the текущ node _matches the specified XPath expression.
   */
  бул matches(ткст xpath) {
    return false;
  }

  /**
   * Selects a node уст используя the specified XPath expression.
   */
  XmlNodeList select(ткст xpath) {
    return null;
  }

  /**
   * Selects all the ancestor nodes of the текущ node.
   */
  XmlNodeList selectAncestors() {
    return select("./ancestor::node()");
  }

  /**
   * Selects all the descendant nodes of the текущ node.
   */
  XmlNodeList selectDescendants() {
    return select("./descendant::node()");
  }

  /**
   * Selects all the child nodes of the текущ node.
   */
  XmlNodeList selectChildren() {
    return select("./node()");
  }

}

private class DocumentXPathNavigator : XPathNavigator {

  private XmlDocument document_;
  private XmlNode node_;

  this(XmlDocument document, XmlNode node) {
    document_ = document;
    node_ = node;
  }

  override бул matches(ткст xpath) {
    шим* bstrExpression = toBstr(xpath);
    scope(exit) freeBstr(bstrExpression);

    IXMLDOMNodeList nodeList;
    цел hr;
    if (УДАЧНО(hr = document_.nodeImpl_.selectNodes(bstrExpression, nodeList))) {
      scope(exit) tryRelease(nodeList);
      IXMLDOMNode n;
      if (УДАЧНО((cast(IXMLDOMSelection)nodeList).matches(node_.nodeImpl_, n))) {
        scope(exit) tryRelease(n);
        return n !is null;
      }
    }
    else
      throw xpathException(hr);
    return false;
  }

  XmlNodeList select(ткст xpath) { 
    шим* bstrExpression = toBstr(xpath);
    scope(exit) freeBstr(bstrExpression);

    IXMLDOMNodeList nodeList;
    цел hr;
    //if (УДАЧНО(hr = document_.nodeImpl_.selectNodes(bstrExpression, nodeList)))
    if (УДАЧНО(hr = node_.nodeImpl_.selectNodes(bstrExpression, nodeList)))
      return new XPathNodeList(cast(IXMLDOMSelection)nodeList);
    else
      throw xpathException(hr);
  }

  private Exception xpathException(цел hr) {
    if (auto support = com_cast!(ISupportErrorInfo)(document_.nodeImpl_)) {
      scope(exit) tryRelease(support);
      if (УДАЧНО(support.InterfaceSupportsErrorInfo(uuidof!(typeof(document_.nodeImpl_))))) {
        IErrorInfo errorInfo;
        if (УДАЧНО(GetErrorInfo(0, errorInfo))) {
          scope(exit) tryRelease(errorInfo);

          шим* bstrDesc;
          errorInfo.GetDescription(bstrDesc);
          ткст msg = изБткст(bstrDesc);
          if (msg[$ - 1] == '\n')
            msg = msg[0 .. $ - 2];
          return new XPathException(msg);
        }
      }
    }
    return new КОМИскл(hr);
  }

}

/**
 * Represents a collection of nodes that can be accessed by имя or индекс.
 */
class XmlNamedNodeMap {

  private IXMLDOMNamedNodeMap mapImpl_;

  /**
   * Retrieves the node specified by имя.
   * Параметры: имя = The qualified _name of the node to retrieve.
   * Возвращает: The node with the specified _name.
   */
  XmlNode getNamedItem(ткст имя) {
    IXMLDOMNode node;

    шим* bstrName = toBstr(имя);
    цел hr = mapImpl_.getNamedItem(bstrName, node);
    freeBstr(bstrName);

    return (hr == S_OK) ? getNodeShim(node) : null;
  }

  /**
   * Retrieves the node with the matching _localName and _namespaceURI.
   * Параметры: 
   *   localName = The local имя of the node to retrieve.
   *   namespaceURI = The namespace URI of the node to retrieve.
   * Возвращает: The node with the matching local имя and namespace URI.
   */
  XmlNode getNamedItem(ткст localName, ткст namespaceURI) {
    IXMLDOMNode node;

    шим* bstrName = toBstr(localName);
    шим* bstrNs = toBstr(namespaceURI);

    цел hr = mapImpl_.getQualifiedItem(bstrName, bstrNs, node);

    freeBstr(bstrName);
    freeBstr(bstrNs);

    return (hr == S_OK) ? getNodeShim(node) : null;
  }

  /**
   * Removes the node with the specified _name.
   * Параметры: имя = The qualified _name of the node to удали.
   * Возвращает: The node removed.
   */
  XmlNode removeNamedItem(ткст имя) {
    IXMLDOMNode node;

    шим* bstrName = toBstr(имя);
    цел hr = mapImpl_.removeNamedItem(bstrName, node);
    freeBstr(bstrName);

    return (hr == S_OK) ? getNodeShim(node) : null;
  }

  /**
   * Removes the node with the matching _localName and _namespaceURI.
   * Параметры: 
   *   localName = The local имя of the node to удали.
   *   namespaceURI = The namespace URI of the node to удали.
   * Возвращает: The node removed.
   */
  XmlNode removeNamedItem(ткст localName, ткст namespaceURI) {
    IXMLDOMNode node;

    шим* bstrName = toBstr(localName);
    шим* bstrNs = toBstr(namespaceURI);

    цел hr = mapImpl_.removeQualifiedItem(bstrName, bstrNs, node);

    freeBstr(bstrName);
    freeBstr(bstrNs);

    return (hr == S_OK) ? getNodeShim(node) : null;
  }

  /**
   * Adds a _node используя its _name property.
   * Параметры: node = The _node to store.
   * Возвращает: The old _node.
   */
  XmlNode setNamedItem(XmlNode node) {
    IXMLDOMNode namedItem;
    if (УДАЧНО(mapImpl_.setNamedItem(node.nodeImpl_, namedItem)))
      return getNodeShim(namedItem);
    return null;
  }

  /**
   * Retrieves the node at the specified _index.
   * Параметры: индекс = The позиция of the node to retrieve.
   * Возвращает: The node at the specified _index.
   */
  XmlNode элт(цел индекс) {
    IXMLDOMNode node;
    if (УДАЧНО(mapImpl_.get_item(индекс, node)))
      return getNodeShim(node);
    return null;
  }

  /**
   * Gets the число of nodes.
   * Возвращает: The число of nodes.
   */
  цел размер() {
    цел length;
    return (УДАЧНО(mapImpl_.get_length(length))) ? length : 0;
  }

  /**
   * Provides support for foreach iteration over the collection of nodes.
   */
  цел opApply(цел delegate(ref XmlNode) действие) {
    цел рез;
    IXMLDOMNode node;

    do {
      if (УДАЧНО(mapImpl_.nextNode(node))) {
        if (XmlNode currentNode = getNodeShim(node)) {
          if ((рез = действие(currentNode)) != 0)
            break;
        }
      }
    } while (node !is null);

    mapImpl_.сбрось();

    return рез;
  }

  /*package*/ this(XmlNode родитель) {
    родитель.nodeImpl_.get_attributes(mapImpl_);
  }

  /*package*/ this(IXMLDOMNamedNodeMap mapImpl) {
    mapImpl_ = mapImpl;
  }

  ~this() {
    if (mapImpl_ !is null) {
      tryRelease(mapImpl_);
      mapImpl_ = null;
    }
  }

}

/**
 * Represents a collection of атрибуты that can be accessed by имя or индекс.
 */
final class XmlAttributeCollection : XmlNamedNodeMap {

  /**
   * Gets the attribute at the specified _index.
   * Параметры: индекс = The _index of the attribute.
   * Возвращает: The attribute at the specified _index.
   */
  final XmlAttribute opIndex(цел индекс) {
    return cast(XmlAttribute)элт(индекс);
  }

  /**
   * Gets the attribute with the specified _name.
   * Параметры: имя = The qualified _name of the attribute.
   * Возвращает: The attribute with the specified _name.
   */
  final XmlAttribute opIndex(ткст имя) {
    return cast(XmlAttribute)getNamedItem(имя);
  }

  /**
   * Gets the attribute with the specified local имя and namespace URI.
   * Параметры: 
   *   localName = The local имя of the attribute.
   *   namespaceURI = The namespace URI of the attribute.
   * Возвращает: The attribute with the specified local имя and namespace URI.
   */
  final XmlAttribute opIndex(ткст localName, ткст namespaceURI) {
    return cast(XmlAttribute)getNamedItem(localName, namespaceURI);
  }

  /*package*/ this(XmlNode родитель) {
    super(родитель);
  }

}

ткст TypedNode(ткст тип, ткст поле = "typedNodeImpl_") {
  return 
    "private " ~ тип ~ " " ~ поле ~ ";\n"

    "/*package*/ this(IXMLDOMNode nodeImpl) {\n"
    "  super(nodeImpl);\n"
    "  " ~ поле ~ " = com_cast!(" ~ тип ~ ")(nodeImpl);\n"
    "}\n"

    "~this() {\n"
    "  if (" ~ поле ~ " !is null) {\n"
    "    tryRelease(" ~ поле ~ ");\n"
    "    " ~ поле ~ " = null;\n"
    "  }\n"
    "}";
}

/**
 * Represents a single node in the XML document.
 */
class XmlNode {

  private IXMLDOMNode nodeImpl_;

  /**
   * Creates a duplicate of this node.
   * Возвращает: The cloned node.
   */
  XmlNode clone() {
    return cloneNode(true);
  }

  /**
   * Creates a duplicate of this node.
   * Параметры: deep = true to recursively clone the subtree under this node; false to clone only the node itself.
   * Возвращает: The cloned node.
   */
  XmlNode cloneNode(бул deep) {
    IXMLDOMNode cloneRoot;
    nodeImpl_.cloneNode(deep ? VARIANT_TRUE : VARIANT_FALSE, cloneRoot);
    return getNodeShim(cloneRoot);
  }

  /**
   * Adds the specified node to the end of the список of child nodes.
   * Параметры: newChild = The node to добавь.
   * Возвращает: The node added.
   */
  XmlNode appendChild(XmlNode newChild) {
    IXMLDOMNode newNode;
    nodeImpl_.appendChild(newChild.nodeImpl_, newNode);
    return getNodeShim(newNode);
  }

  /**
   * Inserts the specified node immediately before the specified reference node.
   * Параметры:
   *   newChild = The node to вставь.
   *   refChild = The reference node. The newChild is placed before this node.
   * Возвращает: The inserted node.
   */
  XmlNode insertBefore(XmlNode newChild, XmlNode refChild) {
    if (refChild is null)
      return appendChild(newChild);

    if (newChild is refChild)
      return newChild;

    VARIANT refNode = refChild.nodeImpl_;
    IXMLDOMNode newNode;
    nodeImpl_.insertBefore(newChild.nodeImpl_, refNode, newNode);
    return getNodeShim(newNode);
  }

  /**
   * Inserts the specified node immediately after the specified reference node.
   * Параметры:
   *   newChild = The node to вставь.
   *   refChild = The reference node. The newChild is placed after this node.
   * Возвращает: The inserted node.
   */
  XmlNode insertAfter(XmlNode newChild, XmlNode refChild) {
    if (refChild is null)
      return insertBefore(newChild, this.firstChild);

    if (newChild is refChild)
      return newChild;

    XmlNode следщ = refChild.nextSibling;
    if (следщ !is null)
      return insertBefore(newChild, следщ);

    return appendChild(newChild);
  }

  /**
   * Replaces the oldChild node with the newChild node.
   * Параметры:
   *   newChild = The new node to put in the child список.
   *   oldChild = The node being replaced in the child список.
   * Возвращает: The replaced node.
   */
  XmlNode replaceChild(XmlNode newChild, XmlNode oldChild) {
    XmlNode следщ = oldChild.nextSibling;
    removeChild(oldChild);
    insertBefore(newChild, следщ);
    return oldChild;
  }

  /**
   * Removes the specified child node.
   * Параметры: oldChild = The node being removed.
   * Возвращает: The removed node.
   */
  XmlNode removeChild(XmlNode oldChild) {
    IXMLDOMNode oldNode;
    nodeImpl_.removeChild(oldChild.nodeImpl_, oldNode);
    return getNodeShim(oldNode);
  }

  /**
   * Removes all the child nodes.
   */
  проц removeAll() {
    IXMLDOMNode first, следщ;
    nodeImpl_.get_firstChild(first);

    while (first !is null) {
      nodeImpl_.get_nextSibling(следщ);

      IXMLDOMNode dummy;
      nodeImpl_.removeChild(first, dummy);

      if (dummy !is null)
        dummy.Release();
      if (first !is null)
        first.Release();

      first = следщ;
      if (следщ !is null)
        следщ.Release();
    }
  }

  /**
   * Creates an XPathNavigator for navigating this экземпляр.
   */
  XPathNavigator createNavigator() {
    return ownerDocument.createNavigator(this);
  }

  /**
   * Selects the first node that matches the XPath expression.
   * Параметры: 
   *   xpath = The XPath expression.
   *   nsmgr = The namespace resolver to use.
   * Возвращает: The first XmlNode that matches the XPath query.
   */
  XmlNode selectSingleNode(ткст xpath, XmlNamespaceManager nsmgr = null) {
    auto список = selectNodes(xpath, nsmgr);
    if (список !is null && список.размер > 0)
      return список[0];
    return null;
  }

  /**
   * Selects a список of nodes matching the XPath expression.
   * Параметры: 
   *   xpath = The XPath expression.
   *   nsmgr = The namespace resolver to use.
   * Возвращает: An XmlNodeList containing the nodes matching the XPath query.
   */
  XmlNodeList selectNodes(ткст xpath, XmlNamespaceManager nsmgr = null) {
    if (nsmgr !is null) {
      // Let MSXML know about any namespace declarations.
      // http://msdn2.microsoft.com/en-us/library/ms756048.aspx

      ткст sel;
      foreach (prefix; nsmgr) {
        if (prefix != "xmlns")
          sel ~= "xmlns:" ~ prefix ~ "='" ~ nsmgr.lookupNamespace(prefix) ~ "' ";
      }

      VARIANT selectionNs = sel;
      scope(exit) selectionNs.сотри();

      IXMLDOMDocument doc;
      if (УДАЧНО(nodeImpl_.get_ownerDocument(doc))) {
        scope(exit) tryRelease(doc);

        if (auto doc2 = com_cast!(IXMLDOMDocument2)(doc)) {
          scope(exit) tryRelease(doc2);

          doc2.setProperty(cast(шим*)"SelectionNamespaces", selectionNs);
        }
      }
    }

    auto nav = createNavigator();
    if (nav !is null)
      return nav.select(xpath);
    return null;
  }

  /**
   * Gets the тип of the текущ node.
   * Возвращает: One of the XmlNodeType значения.
   */
  abstract XmlNodeType nodeType();

  /**
   * Gets the namespace _prefix of this node.
   * Возвращает: The namespace _prefix for this node. For example, prefix is 'bk' for the element &lt;bk:book&gt;.
   */
  ткст prefix() {
    return "";
  }

  /**
   * Gets the local имя of the node.
   * Возвращает: The имя of the node with the prefix removed.
   */
  abstract ткст localName() {
    шим* bstrName;
    if (nodeImpl_.get_baseName(bstrName) == S_OK)
      return изБткст(bstrName);
    return null;
  }

  /**
   * Gets the qualified _name of the node.
   * Возвращает: The qualified _name of the node.
   */
  abstract ткст имя() {
    шим* bstrName;
    if (nodeImpl_.get_nodeName(bstrName) == S_OK)
      return изБткст(bstrName);
    return null;
  }

  /**
   * Gets the namespace URI of the node.
   * Возвращает: The namespace URI of the node.
   */
  ткст namespaceURI() {
    return "";
  }

  /**
   * Gets or sets the значения of the node and its child nodes.
   * Возвращает: The значения of the node and its child nodes.
   */
  проц text(ткст значение) {
    шим* bstrValue = toBstr(значение);
    if (bstrValue != null) {
      nodeImpl_.put_text(bstrValue);
      freeBstr(bstrValue);
    }
  }

  /**
   * ditto
   */
  ткст text() {
    шим* bstrValue;
    if (nodeImpl_.get_text(bstrValue) == S_OK)
      return изБткст(bstrValue);
    return null;
  }

  /**
   * Gets or sets the markup representing the child nodes.
   * Возвращает: The markup of the child nodes.
   */
  проц xml(ткст значение) {
    throw new ИсклНеправильнОперации;
  }

  /**
   * ditto
   */
  ткст xml() {
    шим* bstrXml;
    nodeImpl_.get_xml(bstrXml);
    return изБткст(bstrXml).trim();
  }

  /**
   * Gets or sets the _value of this node.
   */
  проц значение(ткст значение) {
    throw new ИсклНеправильнОперации;
  }

  /**
   * ditto
   */
  ткст значение() {
    return null;
  }

  /**
   * Gets a значение indicating whether this node has any child nodes.
   * Возвращает: true if the node has child nodes; otherwise, false.
   */
  бул hasChildNodes() {
    VARIANT_BOOL рез;
    if (УДАЧНО(nodeImpl_.hasChildNodes(рез)))
      return рез == VARIANT_TRUE;
    return false;
  }

  /**
   * Gets all the child nodes of the node.
   * Возвращает: An XmlNodeList containing all the child nodes of the node.
   */
  XmlNodeList childNodes() {
    IXMLDOMNodeList список;
    if (УДАЧНО(nodeImpl_.get_childNodes(список)))
      return new XmlChildNodes(список);
    return null;
  }

  /** 
   * Gets the first child of the node.
   * Возвращает: The first child of the node. If there is no such node, null is returned.
   */
  XmlNode firstChild() {
    IXMLDOMNode node;
    if (УДАЧНО(nodeImpl_.get_firstChild(node)))
      return getNodeShim(node);
    return null;
  }

  /**
   * Gets the last child of the node.
   * Возвращает: The last child of the node. If there is no such node, null is returned.
   */
  XmlNode lastChild() {
    IXMLDOMNode node;
    if (УДАЧНО(nodeImpl_.get_lastChild(node)))
      return getNodeShim(node);
    return null;
  }

  /**
   * Gets the node immediately preceding this node.
   * Возвращает: The preceding XmlNode. If there is no such node, null is returned.
   */
  XmlNode previousSibling() {
    return null;
  }

  /**
   * Gets the node immediately following this node.
   * Возвращает: The following XmlNode. If there is no such node, null is returned.
   */
  XmlNode nextSibling() {
    return null;
  }

  /**
   * Gets the родитель node of this node.
   * Возвращает: The XmlNode that is the родитель of this node.
   */
  XmlNode parentNode() {
    IXMLDOMNode node;
    if (УДАЧНО(nodeImpl_.get_parentNode(node)))
      return getNodeShim(node);
    return null;
  }

  /**
   * Gets the XmlDocument to which this node belongs.
   * Возвращает: The XmlDocument to which this node belongs.
   */
  XmlDocument ownerDocument() {
    IXMLDOMDocument doc;
    if (УДАЧНО(nodeImpl_.get_ownerDocument(doc)))
      return cast(XmlDocument)getNodeShim(doc);
    return null;
  }

  /**
   * Gets an XmlAttributeCollection containing the _attributes of this node.
   * Возвращает: An XmlAttributeCollection containing the _attributes of this node.
   */
  XmlAttributeCollection атрибуты() {
    return null;
  }

  /**
   * Provides support for foreach iteration over the nodes.
   */
  final цел opApply(цел delegate(ref XmlNode) действие) {
    цел рез = 0;

    IXMLDOMNodeList nodeList;
    if (УДАЧНО(nodeImpl_.get_childNodes(nodeList))) {
      scope(exit) tryRelease(nodeList);

      цел length = 0;
      nodeList.get_length(length);
      for (цел i = 0; i < length; i++) {
        IXMLDOMNode node;
        nodeList.nextNode(node);

        XmlNode curNode = getNodeShim(node);
        if (curNode !is null && (рез = действие(curNode)) != 0)
          break;
      }
    }

    return рез;
  }

  /*package*/ this(IXMLDOMNode nodeImpl) {
    nodeImpl_ = nodeImpl;
  }

  ~this() {
    if (nodeImpl_ !is null) {
      tryRelease(nodeImpl_);
      nodeImpl_ = null;
    }
  }

  /*package*/ IXMLDOMNode impl() {
    return nodeImpl_;
  }

  private static ткст constructQName(ткст prefix, ткст localName) {
    if (prefix.length == 0)
      return localName;
    return prefix ~ ":" ~ localName;
  }

  private static проц splitName(ткст имя, out ткст prefix, out ткст localName) {
    цел i = имя.индексУ(':');
    if (i == -1 || i == 0 || имя.length - 1 == i) {
      prefix = "";
      localName = имя;
    }
    else {
      prefix = имя[0 .. i];
      localName = имя[i + 1 .. $];
    }
  }

}

/**
 * Represents an attribute.
 */
class XmlAttribute : XmlNode {

  mixin(TypedNode("IXMLDOMAttribute", "attributeImpl_"));

  override XmlNodeType nodeType() {
    return XmlNodeType.Attribute;
  }

  override ткст localName() {
    return super.localName;
  }

  override ткст имя() {
    return super.имя;
  }

  override ткст namespaceURI() {
    шим* bstrNs;
    if (nodeImpl_.get_namespaceURI(bstrNs) == S_OK)
      return изБткст(bstrNs);
    return ткст.init;
  }

  override проц значение(ткст значение) {
    VARIANT v = значение;
    attributeImpl_.put_value(v);
    v.сотри();
  }

  override ткст значение() {
    VARIANT v;
    attributeImpl_.get_value(v);
    return v.вТкст();
  }

  override XmlNode parentNode() {
    return null;
  }

  XmlElement ownerElement() {
    return cast(XmlElement)super.parentNode;
  }

  /**
   * Gets a значение indicating whether the attribute was explicitly уст.
   * Возвращает: true if the attribute was explicitly уст; otherwise, false.
   */
  бул specified() {
    VARIANT_BOOL рез;
    nodeImpl_.get_specified(рез);
    return рез == VARIANT_TRUE;
  }

}

/**
 * Represents a node with child nodes immediately before and after this node.
 */
abstract class XmlLinkedNode : XmlNode {

  override XmlNode previousSibling() {
    IXMLDOMNode node;
    nodeImpl_.get_previousSibling(node);
    return getNodeShim(node);
  }

  override XmlNode nextSibling() {
    IXMLDOMNode node;
    nodeImpl_.get_nextSibling(node);
    return getNodeShim(node);
  }

  /*package*/ this(IXMLDOMNode nodeImpl) {
    super(nodeImpl);
  }

}

/**
 * Provides text manipulation methods.
 */
abstract class XmlCharacterData : XmlLinkedNode {

  mixin(TypedNode("IXMLDOMCharacterData"));

  /**
   * Appends the specified ткст to the end of the character данные.
   * Параметры: strData = The ткст to append to the existing ткст.
   */
  проц appendData(ткст strData) {
    шим* bstrValue = toBstr(strData);
    typedNodeImpl_.appendData(bstrValue);
    freeBstr(bstrValue);
  }

  /**
   * Inserts the specified ткст at the specified смещение.
   * Параметры:
   *   смещение = The позиция within the ткст to вставь the specified ткст данные.
   *   strData = The ткст данные that is to be inserted into the existing ткст.
   */
  проц insertData(цел смещение, ткст strData) {
    шим* bstrValue = toBstr(strData);
    typedNodeImpl_.insertData(смещение, bstrValue);
    freeBstr(bstrValue);
  }
  
  /**
   * Replaces the specified число of characters starting at the specified смещение with the specified ткст.
   * Параметры:
   *   смещение = The позиция within the ткст to start replacing.
   *   счёт = The число of characters to замени.
   *   strData = The new данные that replaces the old данные.
   */
  проц replaceData(цел смещение, цел счёт, ткст strData) {
    шим* bstrValue = toBstr(strData);
    typedNodeImpl_.replaceData(смещение, счёт, bstrValue);
    freeBstr(bstrValue);
  }

  /**
   * Removes a охват of characters from the ткст данные.
   * Параметры:
   *   смещение = The позиция within the ткст to start deleting.
   *   счёт = The число of characters to delete.
   */
  проц deleteData(цел смещение, цел счёт) {
    typedNodeImpl_.deleteData(смещение, счёт);
  }

  /**
   * Retrieves a _substring of the full ткст from the specified охват.
   * Параметры:
   *   смещение = The позиция within the ткст to start retrieving.
   *   счёт = The число of characters to retrieve.
   */
  ткст substring(цел смещение, цел счёт) {
    шим* bstrValue;
    if (typedNodeImpl_.substringData(смещение, счёт, bstrValue) == S_OK)
      return изБткст(bstrValue);
    return "";
  }

  /**
   * Gets the _length of the данные.
   * Возвращает: The _length of the ткст данные.
   */
  цел length() {
    цел рез;
    typedNodeImpl_.get_length(рез);
    return рез;
  }

  /**
   * Gets or sets the _data of the node.
   * Возвращает: The _data of the node.
   */
  проц данные(ткст значение) {
    шим* bstrValue = toBstr(значение);
    typedNodeImpl_.put_data(bstrValue);
    freeBstr(bstrValue);
  }

  /**
   * ditto
   */
  ткст данные() {
    шим* bstrValue;
    if (typedNodeImpl_.get_data(bstrValue) == S_OK)
      return изБткст(bstrValue);
    return "";
  }

  override проц значение(ткст значение) {
    данные = значение;
  }

  override ткст значение() {
    return данные;
  }

}

/**
 * Represents a CDATA section.
 */
class XmlCDataSection : XmlCharacterData {

  override XmlNodeType nodeType() {
    return XmlNodeType.CDATA;
  }

  override ткст localName() {
    return "#cdata-section";
  }

  override ткст имя() {
    return localName;
  }

  /*package*/ this(IXMLDOMNode nodeImpl) {
    super(nodeImpl);
  }

}

/**
 * Represents the content of an XML коммент.
 */
class XmlComment : XmlCharacterData {

  override XmlNodeType nodeType() {
    return XmlNodeType.Comment;
  }

  override ткст localName() {
    return "#коммент";
  }

  override ткст имя() {
    return localName;
  }

  /*package*/ this(IXMLDOMNode nodeImpl) {
    super(nodeImpl);
  }

}

/**
 * Represents the text content of an element or attribute.
 */
class XmlText : XmlCharacterData {

  mixin(TypedNode("IXMLDOMText"));

  override XmlNodeType nodeType() {
    return XmlNodeType.Text;
  }

  override ткст localName() {
    return super.localName;
  }

  override ткст имя() {
    return super.имя;
  }

  /**
   * Splits the node into two nodes at the specified _offset, keeping both in the tree as siblings.
   * Параметры: смещение = The позиция at which to разбей the node.
   * Возвращает: The new node.
   */
  XmlText splitText(цел смещение) {
    IXMLDOMText node;
    if (typedNodeImpl_.splitText(смещение, node) == S_OK)
      return cast(XmlText)getNodeShim(node);
    return null;
  }

}

/**
 * Represents an entity declaration, such as &lt;!ENTITY...&gt;.
 */
class XmlEntity : XmlNode {

  mixin(TypedNode("IXMLDOMEntity"));

  override XmlNodeType nodeType() {
    return XmlNodeType.Entity;
  }

  override ткст имя() {
    return super.имя;
  }

  override ткст localName() {
    return super.localName;
  }

  override проц text(ткст значение) {
    throw new ИсклНеправильнОперации;
  }

  override ткст text() {
    return super.text;
  }

  override проц xml(ткст значение) {
    throw new ИсклНеправильнОперации;
  }

  override ткст xml() {
    return "";
  }

  /**
   * Gets the значение of the identifier on the entity declaration.
   * Возвращает: The identifier on the entity.
   */
  final ткст publicId() {
    VARIANT var;
    if (typedNodeImpl_.get_publicId(var) == S_OK) {
      scope(exit) var.сотри();
      return var.вТкст();
    }
    return null;
  }

  /**
   * Gets the значение of the system identifier on the entity declaration.
   * Возвращает: The system identifier on the entity.
   */
  final ткст systemId() {
    VARIANT var;
    if (typedNodeImpl_.get_systemId(var) == S_OK) {
      scope(exit) var.сотри();
      return var.вТкст();
    }
    return null;
  }

  /**
   * Gets the имя of the NDATA attribute on the entity declaration.
   * Возвращает: The имя of the NDATA attribute.
   */
  final ткст notationName() {
    шим* bstrName;
    if (typedNodeImpl_.get_notationName(bstrName) == S_OK)
      return изБткст(bstrName);
    return null;
  }

}

/**
 * Represents an entity reference node.
 */
class XmlEntityReference : XmlLinkedNode {

  mixin(TypedNode("IXMLDOMEntityReference"));

  override XmlNodeType nodeType() {
    return XmlNodeType.EntityReference;
  }

  override ткст имя() {
    return super.имя;
  }

  override ткст localName() {
    return super.localName;
  }

  override проц значение(ткст значение) {
    throw new ИсклНеправильнОперации;
  }

  override ткст значение() {
    return "";
  }

}

/**
 * Represents a notation declaration such as &lt;!NOTATION...&gt;.
 */
class XmlNotation : XmlNode {

  mixin(TypedNode("IXMLDOMNotation"));

  override XmlNodeType nodeType() {
    return XmlNodeType.Notation;
  }

  override ткст имя() {
    return super.имя;
  }

  override ткст localName() {
    return super.localName;
  }

}

/**
 * Represents the document тип declaration.
 */
class XmlDocumentType : XmlLinkedNode {

  mixin(TypedNode("IXMLDOMDocumentType"));

  override XmlNodeType nodeType() {
    return XmlNodeType.DocumentType;
  }

  override ткст имя() {
    шим* bstrName;
    typedNodeImpl_.get_name(bstrName);
    return изБткст(bstrName);
  }

  override ткст localName() {
    return имя;
  }

  /**
   * Gets the collection of XmlEntity nodes declared in the document тип declaration.
   * Возвращает: An XmlNamedNodeMap containing the XmlEntity nodes.
   */
  final XmlNamedNodeMap entities() {
    IXMLDOMNamedNodeMap map;
    if (typedNodeImpl_.get_entities(map) == S_OK)
      return new XmlNamedNodeMap(map);
    return null;
  }

  /**
   * Gets the collection of XmlNotation nodes present in the document тип declaration.
   * Возвращает: An XmlNamedNodeMap containing the XmlNotation nodes.
   */
  final XmlNamedNodeMap notations() {
    IXMLDOMNamedNodeMap map;
    if (typedNodeImpl_.get_notations(map) == S_OK)
      return new XmlNamedNodeMap(map);
    return null;
  }

}

/**
 * Represents a lightweight object useful for tree вставь operations.
 */
class XmlDocumentFragment : XmlNode {

  mixin(TypedNode("IXMLDOMDocumentFragment"));

  override XmlNodeType nodeType() {
    return XmlNodeType.DocumentFragment;
  }

  override ткст имя() {
    version(D_Version2) {
      return "#document-fragment".idup;
    }
    else {
      return "#document-fragment".dup;
    }
  }

  override ткст localName() {
    return имя;
  }

  override XmlNode parentNode() {
    return null;
  }

  override XmlDocument ownerDocument() {
    return cast(XmlDocument)super.parentNode;
  }

}

/** 
 * Represents an element.
 */
class XmlElement : XmlLinkedNode {

  mixin(TypedNode("IXMLDOMElement", "elementImpl_"));

  /**
   * Returns the значение for the attribute with the specified _name.
   * Параметры: имя = The qualified _name of the attribute to retrieve.
   * Возвращает: The значение of the specified attribute.
   */
  ткст getAttribute(ткст имя) {
    шим* bstrName = toBstr(имя);
    scope(exit) freeBstr(bstrName);

    VARIANT значение;
    elementImpl_.getAttribute(bstrName, значение);
    return значение.вТкст();
  }

  /**
   * Returns the значение for the attribute with the specified local имя and namespace URI.
   * Параметры: 
   *   localName = The local имя of the attribute to retrieve.
   *   namespaceURI = The namespace URI of the attribute to retrieve.
   * Возвращает: The значение of the specified attribute.
   */
  ткст getAttribute(ткст localName, ткст namespaceURI) {
    if (XmlAttribute attr = getAttributeNode(localName, namespaceURI))
      return attr.значение;
    return null;
  }

  /**
   * Returns the attribute with the specified _name.
   * Параметры: имя = The qualified _name of the attribute to retrieve.
   * Возвращает: The matching XmlAttribute.
   */
  XmlAttribute getAttributeNode(ткст имя) {
    if (hasAttributes)
      return атрибуты[имя];
    return null;
  }

  /**
   * Returns the attribute with the specified local имя and namespace URI.
   * Параметры: 
   *   localName = The local имя of the attribute to retrieve.
   *   namespaceURI = The namespace URI of the attribute to retrieve.
   * Возвращает: The matching XmlAttribute.
   */
  XmlAttribute getAttributeNode(ткст localName, ткст namespaceURI) {
    if (hasAttributes)
      return атрибуты[localName, namespaceURI];
    return null;
  }

  /**
   * Determines whether the node has an attribute with the specified _name.
   * Параметры: имя = The qualified _name of the attribute to найди.
   * Возвращает: true if the node has the specified attribute; otherwise, false.
   */
  бул hasAttribute(ткст имя) {
    return getAttributeNode(имя) !is null;
  }

  /**
   * Determines whether the node has an attribute with the specified local имя and namespace URI.
   * Параметры: 
   *   localName = The local имя of the attribute to найди.
   *   namespaceURI = The namespace URI of the attribute to найди.
   * Возвращает: true if the node has the specified attribute; otherwise, false.
   */
  бул hasAttribute(ткст localName, ткст namespaceURI) {
    return getAttributeNode(localName, namespaceURI) !is null;
  }

  /**
   * Sets the _value of the attribute with the specified _name.
   * Параметры:
   *   имя = The qualified _name of the attribute to create or alter.
   *   значение = The _value to уст for the attribute.
   */
  проц setAttribute(ткст имя, ткст значение) {
    шим* bstrName = toBstr(имя);
    scope(exit) freeBstr(bstrName);

    VARIANT v = значение;
    elementImpl_.setAttribute(bstrName, v);
    v.сотри();
  }

  /**
   * Adds the specified attribute.
   * Параметры: newAttr = The attribute to добавь to the attribute collection for this element.
   * Возвращает: If the attribute replaces an existing attribute with the same имя, the old attribute is returned; otherwise, null is returned.
   */
  XmlAttribute setAttributeNode(XmlAttribute newAttr) {
    IXMLDOMAttribute attr;
    if (УДАЧНО(elementImpl_.setAttributeNode(newAttr.attributeImpl_, attr)))
      return cast(XmlAttribute)getNodeShim(attr);
    return null;
  }

  /**
   * Removes an attribute by _name.
   * Параметры: имя = The qualified _name of the attribute to удали.
   */
  проц removeAttribute(ткст имя) {
    if (hasAttributes)
      атрибуты.removeNamedItem(имя);
  }

  /**
   * Removes an attribute with the specified local имя and namespace URI.
   * Параметры: 
   *   localName = The local имя of the attribute to удали.
   *   namespaceURI = The namespace URI of the attribute to удали.
   */
  проц removeAttribute(ткст localName, ткст namespaceURI) {
    if (hasAttributes)
      атрибуты.removeNamedItem(localName, namespaceURI);
  }

  /**
   * Removes the specified attribute.
   * Параметры: oldAttr = The attribute to удали.
   * Возвращает: The removed attribute or null if oldAttr is not an attribute of the element.
   */
  XmlAttribute removeAttributeNode(XmlAttribute oldAttr) {
    IXMLDOMAttribute attr;
    if (УДАЧНО((elementImpl_.removeAttributeNode(oldAttr.attributeImpl_, attr))))
      return cast(XmlAttribute)getNodeShim(attr);
    return null;
  }

  /**
   * Removes the attribute specified by the local имя and namespace URI.
   * Параметры: 
   *   localName = The local имя of the attribute.
   *   namespaceURI = The namespace URI of the attribute.
   * Возвращает: The removed attribute.
   */
  XmlAttribute removeAttributeNode(ткст localName, ткст namespaceURI) {
    if (hasAttributes) {
      if (XmlAttribute attr = getAttributeNode(localName, namespaceURI)) {
        removeAttributeNode(attr);
        return attr;
      }
    }
    return null;
  }

  /**
   * Collapses all adjacent XmlText nodes in the sub-tree.
   */
  проц normalize() {
    elementImpl_.normalize();
  }

  /**
   * Returns an XmlNodeList containing the descendant elements with the specified _name.
   * Параметры: имя = The qualified _name tag to match.
   * Возвращает: An XmlNodeList containing a список of matching nodes.
   */
  XmlNodeList getElementsByTagName(ткст имя) {
    шим* bstrName = toBstr(имя);
    if (bstrName != null) {
      scope(exit) freeBstr(bstrName);
      IXMLDOMNodeList nodeList;
      if (УДАЧНО(elementImpl_.getElementsByTagName(bstrName, nodeList)))
        return new XmlChildNodes(nodeList);
    }
    return null;
  }

  override XmlAttributeCollection атрибуты() {
    return new XmlAttributeCollection(this);
  }

  /**
   * Gets a значение indicating whether the node has any атрибуты.
   * Возвращает: true if the node has атрибуты; otherwise, false.
   */
  бул hasAttributes() {
    IXMLDOMNamedNodeMap attrs;
    if (УДАЧНО(nodeImpl_.get_attributes(attrs))) {
      scope(exit) tryRelease(attrs);

      цел length;
      if (УДАЧНО(attrs.get_length(length)))
        return length > 0;
      return false;
    }
    return false;
  }

  override XmlNodeType nodeType() {
    return XmlNodeType.Element;
  }

  override ткст localName() {
    return super.localName;
  }

  override ткст имя() {
    return super.имя;
  }

  override ткст namespaceURI() {
    шим* bstrNs;
    if (УДАЧНО(nodeImpl_.get_namespaceURI(bstrNs)))
      return изБткст(bstrNs);
    return ткст.init;
  }

}

/**
 * Represents a processing instruction.
 */
class XmlProcessingInstruction : XmlLinkedNode {

  mixin(TypedNode("IXMLDOMProcessingInstruction"));

  override XmlNodeType nodeType() {
    return XmlNodeType.ProcessingInstruction;
  }

  override ткст имя() {
    return super.имя;
  }

  override ткст localName() {
    return super.localName;
  }

}

/**
 * Represents the XML declaration node.
 */
class XmlDeclaration : XmlLinkedNode {

  private const ткст VERSION = "1.0";

  mixin(TypedNode("IXMLDOMProcessingInstruction"));
  private ткст кодировка_;
  private ткст standalone_;

  override XmlNodeType nodeType() {
    return XmlNodeType.XmlDeclaration;
  }

  override ткст имя() {
    return localName;
  }

  override ткст localName() {
    return "xml";
  }

  final проц значение(ткст значение) {
    text = значение;
  }

  override ткст значение() {
    return text;
  }

  /**
   * Gets or sets the _encoding уровень of the XML document.
   * Возвращает: The character _encoding имя.
   */
  final проц кодировка(ткст значение) {
    кодировка_ = значение;
  }

  /**
   * ditto
   */
  final ткст кодировка() {
    return кодировка_;
  }

  /**
   * Gets or sets the _value of the _standalone attribute.
   * Возвращает: Valid значения are "yes" if all entity declarations are contained within the document or "no" if an external DTD is required.
   */
  final проц standalone(ткст значение) {
    if (значение == null || значение == "yes" || значение == "no")
      standalone_ = значение;
  }

  /**
   * ditto
   */
  final ткст standalone() {
    return standalone_;
  }

  /**
   * Gets the XML version of the document.
   */
  final ткст xmlversion() {
    return VERSION;
  }

  /*package*/ this(ткст xmlversion, ткст кодировка, ткст standalone, IXMLDOMNode nodeImpl) {
    if (xmlversion != VERSION)
      throw new ИсклАргумента("Only XML version 1.0 is supported.");

    this(nodeImpl);
    this.кодировка = кодировка;
    this.standalone = standalone;
  }

}

/**
 * Provides methods that are independent of a particular экземпляр of the Document Объект Model.
 */
class XmlImplementation {

  private IXMLDOMImplementation impl_;

  /**
   * Tests if the specified feature is supported.
   * Параметры: 
   *   strFeature = The package имя of the feature to test.
   *   strVersion = The version число of the package имя to test.
   * Возвращает: true if the feature is implemented in the specified version; otherwise, false.
   */
  final бул hasFeature(ткст strFeature, ткст strVersion) {
    VARIANT_BOOL рез;

    шим* bstrFeature = toBstr(strFeature);
    шим* bstrVersion = toBstr(strVersion);
    impl_.hasFeature(bstrFeature, bstrVersion, рез);
    freeBstr(bstrFeature);
    freeBstr(bstrVersion);

    return рез == VARIANT_TRUE;
  }

  private this(IXMLDOMImplementation impl) {
    impl_ = impl;
  }

  ~this() {
    if (impl_ !is null) {
      tryRelease(impl_);
      impl_ = null;
    }
  }

}

/**
 * Represents an XML document.
 */
class XmlDocument : XmlNode {

  mixin(TypedNode("IXMLDOMDocument2", "docImpl_"));
  private крат msxmlVersion_;

  /**
   * Initializes a new экземпляр.
   */
  this() {
    // MSXML 6.0 is the preferred implementation. According to MSDN, MSXML 4.0 is only suitable for legacy code, but we'll use if 
    // it's available on the system. MSXML 5.0 was часть of Office 2003.
    IXMLDOMDocument2 doc;
    if ((doc = DOMDocument60.coCreate!(IXMLDOMDocument3)) !is null)
      msxmlVersion_ = 6;
    else if ((doc = DOMDocument40.coCreate!(IXMLDOMDocument2)) !is null)
      msxmlVersion_ = 4;
    else if ((doc = DOMDocument30.coCreate!(IXMLDOMDocument2, ExceptionPolicy.Throw)) !is null)
      msxmlVersion_ = 3;

    if (msxmlVersion_ >= 4)
      doc.setProperty(cast(шим*)"NewParser", VARIANT(true)); // Faster and more reliable; lacks async support and DTD validation (we don't support either, so that's ОК).
    if (msxmlVersion_ >= 6)
      doc.setProperty(cast(шим*)"MultipleErrorMessages", VARIANT(true));
    if (msxmlVersion_ < 4) {
      VARIANT var = "XPath";
      scope(exit) var.сотри();
      doc.setProperty(cast(шим*)"SelectionLanguage", var); // In MSXML 3.0, "SelectionLanguage" was "XPattern".
    }

    doc.put_async(VARIANT_FALSE);
    doc.put_validateOnParse(VARIANT_FALSE);

    this(doc);
  }

  /**
   * Creates an XPathNavigator for navigating this экземпляр.
   */
  override XPathNavigator createNavigator() {
    return createNavigator(this);
  }

  /**
   * Creates an XmlNode with the specified _type, _name and _namespaceURI.
   * Параметры:
   *   тип = The _type of the new node.
   *   имя = The qualified _name of the new node.
   *   namespaceURI = The namespace URI of the new node.
   * Возвращает: The new XmlNode.
   */
  XmlNode createNode(XmlNodeType тип, ткст имя, ткст namespaceURI) {
    return createNode(тип, null, имя, namespaceURI);
  }

  /**
   * Creates an XmlNode with the specified _type, _prefix, _name and _namespaceURI.
   * Параметры:
   *   тип = The _type of the new node.
   *   prefix = The _prefix of the new node.
   *   имя = The local _name of the new node.
   *   namespaceURI = The namespace URI of the new node.
   * Возвращает: The new XmlNode.
   */
  XmlNode createNode(XmlNodeType тип, ткст prefix, ткст имя, ткст namespaceURI) {
    switch (тип) {
      case XmlNodeType.EntityReference:
        return createEntityReference(имя);
      case XmlNodeType.Element:
        if (prefix == null)
          return createElement(имя, namespaceURI);
        return createElement(prefix, имя, namespaceURI);
      case XmlNodeType.Attribute:
        if (prefix == null)
          return createAttribute(имя, namespaceURI);
        return createAttribute(prefix, имя, namespaceURI);
      case XmlNodeType.CDATA:
        return createCDataSection("");
      case XmlNodeType.Comment:
        return createComment("");
      case XmlNodeType.Text:
        return createTextNode("");
      case XmlNodeType.ProcessingInstruction:
        return createProcessingInstruction(имя, "");
      case XmlNodeType.XmlDeclaration:
        return createXmlDeclaration("1.0", null, null);
      case XmlNodeType.DocumentFragment:
        return createDocumentFragment();
      case XmlNodeType.Document:
        return new XmlDocument;
      default:
    }
    throw new ИсклАргумента("Cannot create node of тип '" ~ XmlNodeTypeString[тип] ~ "'.");
  }

  /**
   * Creates an XmlElement with the specified _name.
   * Параметры: имя = The qualified _name of the element.
   * Возвращает: The new XmlElement.
   */
  XmlElement createElement(ткст имя) {
    ткст prefix, localName;
    XmlNode.splitName(имя, prefix, localName);
    return createElement(prefix, localName, "");
  }

  /**
   * Creates an XmlElement with the specified имя and _namespaceURI.
   * Параметры:
   *   qualifiedName = The qualified имя of the element.
   *   namespaceURI = The namespace URI of the element.
   * Возвращает: The new XmlElement.
   */
  XmlElement createElement(ткст qualifiedName, ткст namespaceURI) {
    IXMLDOMNode node;

    шим* bstrName = toBstr(qualifiedName);
    шим* bstrNs = toBstr(namespaceURI);
    docImpl_.createNode(VARIANT(DOMNodeType.NODE_ELEMENT), bstrName, bstrNs, node);
    freeBstr(bstrName);
    freeBstr(bstrNs);

    return cast(XmlElement)getNodeShim(node);
  }

  /**
   * Creates an XmlElement with the specified _prefix, localName and _namespaceURI.
   * Параметры:
   *   prefix = The _prefix of the element.
   *   localName = The local имя of the element.
   *   namespaceURI = The namespace URI of the element.
   * Возвращает: The new XmlElement.
   */
  XmlElement createElement(ткст prefix, ткст localName, ткст namespaceURI) {
    return createElement(XmlNode.constructQName(prefix, localName), namespaceURI);
  }

  /**
   * Creates an XmlAttribute with the specified _name.
   * Параметры: имя = The qualified _name of the attribute.
   * Возвращает: The new XmlAttribute.
   */
  XmlAttribute createAttribute(ткст имя) {
    ткст prefix, localName;
    XmlNode.splitName(имя, prefix, localName);
    return createAttribute(prefix, localName, "");
  }

  /**
   * Creates an XmlAttribute with the specified имя and _namespaceURI.
   * Параметры:
   *   qualifiedName = The qualified имя of the attribute.
   *   namespaceURI = The namespace URI of the attribute.
   * Возвращает: The new XmlAttribute.
   */
  XmlAttribute createAttribute(ткст qualifiedName, ткст namespaceURI) {
    IXMLDOMNode node;

    шим* bstrName = toBstr(qualifiedName);
    шим* bstrNs = toBstr(namespaceURI);
    docImpl_.createNode(VARIANT(DOMNodeType.NODE_ATTRIBUTE), bstrName, bstrNs, node);
    freeBstr(bstrName);
    freeBstr(bstrNs);

    return cast(XmlAttribute)getNodeShim(node);
  }

  /**
   * Creates an XmlAttribute with the specified _prefix, localName and _namespaceURI.
   * Параметры:
   *   prefix = The _prefix of the attribute.
   *   localName = The local имя of the attribute.
   *   namespaceURI = The namespace URI of the attribute.
   * Возвращает: The new XmlAttribute.
   */
  XmlAttribute createAttribute(ткст prefix, ткст localName, ткст namespaceURI) {
    return createAttribute(XmlNode.constructQName(prefix, localName), namespaceURI);
  }

  /**
   * Creates an XmlCDataSection node with the specified _data.
   * Параметры: text = The _data for the node.
   * Возвращает: The new XmlCDataSection node.
   */
  XmlCDataSection createCDataSection(ткст данные) {
    IXMLDOMCDATASection node;

    шим* bstrValue = toBstr(данные);
    docImpl_.createCDATASection(bstrValue, node);
    freeBstr(bstrValue);

    return cast(XmlCDataSection)getNodeShim(node);
  }

  /**
   * Creates an XmlComment node with the specified _data.
   * Параметры: text = The _data for the node.
   * Возвращает: The new XmlComment node.
   */
  XmlComment createComment(ткст данные) {
    IXMLDOMComment node;

    шим* bstrValue = toBstr(данные);
    docImpl_.createComment(bstrValue, node);
    freeBstr(bstrValue);

    return cast(XmlComment)getNodeShim(node);
  }

  /**
   * Creates an XmlText node with the specified _text.
   * Параметры: text = The _text for the node.
   * Возвращает: The new XmlText node.
   */
  XmlText createTextNode(ткст text) {
    IXMLDOMText node = null;

    шим* bstrValue = toBstr(text);
    docImpl_.createTextNode(bstrValue, node);
    freeBstr(bstrValue);

    return cast(XmlText)getNodeShim(node);
  }

  /**
   * Creates an XmlProcessingInstruction node with the specified имя and _data.
   * Параметры:
   *   цель = the имя of the processing instruction.
   *   данные = The _data for the processing instruction.
   * Возвращает: The new XmlProcessingInstruction node.
   */
  XmlProcessingInstruction createProcessingInstruction(ткст цель, ткст данные) {
    IXMLDOMProcessingInstruction node;

    шим* bstrTarget = toBstr(цель);
    шим* bstrData = toBstr(данные);
    docImpl_.createProcessingInstruction(bstrTarget, bstrData, node);
    freeBstr(bstrTarget);
    freeBstr(bstrData);

    return cast(XmlProcessingInstruction)getNodeShim(node);
  }

  /**
   * Create an XmlDeclaration node with the specified значения.
   * Параметры:
   *   xmlversion = The version must be "1.0".
   *   кодировка = The значение of the _encoding attribute.
   *   standalone = The значение must be either "yes" or "no".
   * Возвращает: The new XmlDeclaration node.
   */
  XmlDeclaration createXmlDeclaration(ткст xmlversion, ткст кодировка, ткст standalone) {
    ткст данные = "version=\"" ~ xmlversion ~ "\"";
    if (кодировка != null)
      данные ~= " кодировка=\"" ~ кодировка ~ "\"";
    if (standalone != null)
      данные ~= " standalone=\"" ~ standalone ~ "\"";

    IXMLDOMProcessingInstruction node;

    шим* bstrTarget = toBstr("xml");
    шим* bstrData = toBstr(данные);
    docImpl_.createProcessingInstruction(bstrTarget, bstrData, node);
    freeBstr(bstrTarget);
    freeBstr(bstrData);

    return cast(XmlDeclaration)getNodeShim(node);
  }

  /**
   * Creates an XmlEntityReference with the specified _name.
   * Параметры: The _name of the entity reference.
   * Возвращает: The new XmlEntityReference.
   */
  XmlEntityReference createEntityReference(ткст имя) {
    IXMLDOMEntityReference node;

    шим* bstrName = toBstr(имя);
    docImpl_.createEntityReference(bstrName, node);
    freeBstr(bstrName);

    return cast(XmlEntityReference)getNodeShim(node);
  }

  /**
   * Creates an XmlDocumentFragment.
   * Возвращает: The new XmlDocumentFragment.
   */
  XmlDocumentFragment createDocumentFragment() {
    IXMLDOMDocumentFragment node;
    docImpl_.createDocumentFragment(node);
    return cast(XmlDocumentFragment)getNodeShim(node);
  }

  /**
   * Loads the XML document from the specified URL.
   * Параметры: имяф = URL for the file containing the XML document to _load. The URL can be either a local file or a web адрес.
   * Выводит исключение: XmlException if there is a _load or разбор ошибка in the XML.
   */
  проц загрузи(ткст имяф) {
    VARIANT исток = имяф;
    scope(exit) исток.сотри();

    VARIANT_BOOL success;
    docImpl_.загрузи(исток, success);
    if (success == VARIANT_FALSE)
      parsingException();
  }

  /**
   * Loads the XML document from the specified поток.
   * Параметры: ввод = The поток containing the XML document to _load.
   * Выводит исключение: XmlException if there is a _load or разбор ошибка in the XML.
   */
  проц загрузи(Поток ввод) {
    auto s = new COMStream(ввод);
    scope(exit) tryRelease(s);

    VARIANT исток = s;
    scope(exit) исток.сотри();

    VARIANT_BOOL success;
    docImpl_.загрузи(исток, success);
    if (success == VARIANT_FALSE)
      parsingException();
  }

  /**
   * Loads the XML document from the specified ткст.
   * Параметры: xml = The ткст containing the XML document to загрузи.
   * Выводит исключение: XmlException if there is a _load or разбор ошибка in the XML.
   */
  проц loadXml(ткст xml) {
    VARIANT_BOOL success;

    шим* bstrXml = toBstr(xml);
    docImpl_.loadXML(bstrXml, success);
    freeBstr(bstrXml);

    if (success == VARIANT_FALSE)
      parsingException();
  }

  /**
   * Saves the XML document to the specified file.
   * Параметры: имяф = The положение of the file where you want to _save the document.
   * Выводит исключение: XmlException if there is no document element.
   */
  проц save(ткст имяф) {
    if (documentElement is null)
      throw new XmlException("Invalid XML document. The document does not have a root element.");

    VARIANT dest = имяф;
    scope(exit) dest.сотри();

    if (НЕУДАЧНО(docImpl_.save(dest)))
      throw new XmlException;
  }

  /**
   * Saves the XML document to the specified поток.
   * Параметры: вывод = The поток to which you want to _save.
   */
  проц save(Поток вывод) {
    auto s = new COMStream(вывод);
    scope(exit) tryRelease(s);

    VARIANT dest = s;
    scope(exit) tryRelease(s);

    if (НЕУДАЧНО(docImpl_.save(dest)))
      throw new XmlException;
  }

  /**
   * Gets the XmlElement with the specified ID.
   * Параметры: elementId = The attribute ID to match.
   * Возвращает: The XmlElement with the matching ID.
   */
  XmlElement getElementByTagId(ткст elementId) {
    IXMLDOMNode node;

    шим* bstrId = toBstr(elementId);
    docImpl_.nodeFromID(bstrId, node);
    freeBstr(bstrId);

    return cast(XmlElement)getNodeShim(node);
  }

  /** 
   * Gets the root element for the document.
   * Возвращает: The XmlElement representing the root of the XML document tree. If no root существует, null is returned.
   */
  XmlElement documentElement() {
    IXMLDOMElement docEl;
    docImpl_.get_documentElement(docEl);
    return cast(XmlElement)getNodeShim(docEl);
  }

  /**
   * Gets the тип of the текущ node.
   * Возвращает: For XmlDocument nodes, the значение is XmlNodeType.Document.
   */
  override XmlNodeType nodeType() {
    return XmlNodeType.Document;
  }

  /**
   * Gets the локаль имя of the node.
   * Возвращает: For XmlDocument nodes, the local имя is #document.
   */
  override ткст localName() {
    version(D_Version2) {
      return "#document".idup;
    }
    else {
      return "#document".dup;
    }
  }

  /**
   * Gets the qualified _name of the node.
   * Возвращает: For XmlDocument nodes, the _name is #document.
   */
  override ткст имя() {
    return localName;
  }

  /**
   * Gets the родитель node.
   * Возвращает: For XmlDocument nodes, null is returned.
   */
  override XmlNode parentNode() {
    return null;
  }

  /**
   * Gets the XmlDocument to which the текущ node belongs.
   * Возвращает: For XmlDocument nodes, null is returned.
   */
  override XmlDocument ownerDocument() {
    return null;
  }

  /**
   * Gets or sets the markup representing the children of this node.
   * Возвращает: The markup of the children of this node.
   */
  override проц xml(ткст значение) {
    loadXml(значение);
  }

  /**
   * ditto
   */
  override ткст xml() {
    return super.xml;
  }

  /**
   * Gets or sets a _value indicating whether to preserve white space in element content.
   * Параметры: значение = true to preserve white space; otherwise, false.
   */
  final проц preserveWhitespace(бул значение) {
    docImpl_.put_preserveWhiteSpace(значение ? VARIANT_TRUE : VARIANT_FALSE);
  }

  /**
   * ditto
   */
  final бул preserveWhitespace() {
    VARIANT_BOOL значение;
    docImpl_.get_preserveWhiteSpace(значение);
    return значение == VARIANT_TRUE;
  }

  protected XPathNavigator createNavigator(XmlNode node) {
    switch (node.nodeType) {
      case XmlNodeType.EntityReference,
        XmlNodeType.Entity,
        XmlNodeType.DocumentType,
        XmlNodeType.Notation,
        XmlNodeType.XmlDeclaration:
        return null;
        default:
    }
    return new DocumentXPathNavigator(this, node);
  }

  private проц parsingException() {
    IXMLDOMParseError errorObj;
    if (УДАЧНО(docImpl_.get_parseError(errorObj))) {
      scope(exit) tryRelease(errorObj);

      шим* bstrReason, bstrUrl;
      цел linconstber, linePosition;

      errorObj.get_reason(bstrReason);
      errorObj.get_url(bstrUrl);
      errorObj.get_line(linconstber);
      errorObj.get_linepos(linePosition);

      ткст reason = изБткст(bstrReason);
      if (reason[$ - 1] == '\n')
        reason = reason[0 .. $ - 2];

      throw new XmlException(reason, linconstber, linePosition, изБткст(bstrUrl));
    }
  }

}