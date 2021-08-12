/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.xml.core;

import win32.base.string;

/// Specifies the тип of the node.
enum XmlNodeType {
  None,                   /// An unsupported node.
  Element,                /// An element (for example, <code>&lt;элт&gt;</code>).
  Attribute,              /// An attribute (for example, <code>ид='123'</code>).
  Text,                   /// The text content of a node.
  CDATA,                  /// A _CDATA section (for example, <code>&lt;![_CDATA[my escaped text]]&gt;</code>).
  EntityReference,        /// A reference to an entity (for example, <code>&num;</code>).
  Entity,                 /// An entity declaration (for example, <code>&lt;!ENTITY...&gt;</code>).
  ProcessingInstruction,  /// A processing instruction (for example, <code>&lt;?pi test?&gt;</code>).
  Comment,                /// A коммент (for example, <code>&lt;!-- my коммент --&gt;</code>).
  Document,               /// A document object that provides access to the entire XML document.
  DocumentType,           /// The doucment тип declaration (for example, <code>&lt;!DOCTYPE...&gt;</code>).
  DocumentFragment,       /// A document fragment.
  Notation,               /// A notation in the document тип declaration (for example, <code>&lt;!NOTATION...&gt;</code>).
  Whitespace,             /// White space between markup.
  SignificantWhitespace,  /// White space between markup in a mixed content model.
  EndElement,             /// An end element tag (for example, <code>&lt;/элт&gt;</code>).
  EndEntity,              /// The end of an entity.
  XmlDeclaration          /// The XML declaration (for example, <code>&lt;?xml version='1.0'?&gt;</code>).
}

ткст[XmlNodeType.max + 1] XmlNodeTypeString = [
  XmlNodeType.None : "None",
  XmlNodeType.Element : "Element",
  XmlNodeType.Attribute : "Attribute",
  XmlNodeType.Text : "Text",
  XmlNodeType.CDATA : "CDATA",
  XmlNodeType.EntityReference : "EntityReference",
  XmlNodeType.Entity : "Entity",
  XmlNodeType.ProcessingInstruction : "ProcessingInstruction",
  XmlNodeType.Comment : "Comment",
  XmlNodeType.Document : "Document",
  XmlNodeType.DocumentType : "DocumentType",
  XmlNodeType.DocumentFragment : "DocumentFragment",
  XmlNodeType.Notation : "Notation",
  XmlNodeType.Whitespace : "Whitespace",
  XmlNodeType.XmlDeclaration : "XmlDeclaration"
];

enum XmlConformanceLevel {
  Авто,
  Fragment,
  Document
}

enum XmlReadState {
  Initial,
  Interactive,
  Error,
  EndOfFile,
  Closed
}

enum XmlStandalone {
  Omit,
  Yes,
  No
}

/**
 * Detailed information about the last exception.
 */
class XmlException : Exception {

  private цел linconstber_;
  private цел linePosition_;
  private ткст sourceUri_;

  /**
   * Initializes a new экземпляр with a specified ошибка _message, line число, line позиция and XML file положение.
   */
  public this(ткст сообщение = null, цел linconstber = 0, цел linePosition = 0, ткст sourceUri = null) {
    super(createMessage(сообщение, linconstber, linePosition));
    linconstber_ = linconstber;
    linePosition_ = linePosition_;
    sourceUri_ = sourceUri;
  }

  /**
   * Gets the line число indicating where the ошибка occurred.
   */
  final цел linconstber() {
    return linconstber_;
  }

  /**
   * Gets the line позиция indicating where the ошибка occurred.
   */
  final цел linePosition() {
    return linePosition_;
  }

  private static ткст createMessage(ткст s, цел linconstber, цел linePosition) {
    ткст рез = s;
    if (linconstber != 0)
      рез ~= format(" Строка {0}, позиция {1}.", linconstber, linePosition);
    return рез;
  }

}

class XmlQualifiedName {

  private ткст name_;
  private ткст ns_;

  this(ткст имя = "", ткст ns = "") {
    name_ = имя;
    ns_ = ns;
  }

  override typeof(super.opEquals(Объект)) opEquals(Объект другой) {
    if (this is другой)
      return true;
    if (auto qname = cast(XmlQualifiedName)другой) {
      if (name_ == qname.name_)
        return ns_ == qname.ns_;
    }
    return false;
  }

  override цел opCmp(Объект другой) {
    if (другой is null)
      return 1;
    if (auto qname = cast(XmlQualifiedName)другой) {
      цел ret = typeid(ткст).сравни(&ns_, &qname.ns_);
      if (ret == 0)
        ret = typeid(ткст).сравни(&name_, &qname.name_);
      return ret;
    }
    return 1;
  }

  override hash_t вХэш() {
    return typeid(ткст).дайХэш(&name_);
  }

  override ткст вТкст() {
    if (namespace != null)
      return namespace ~ ":" ~ имя;
    return имя;
  }

  final ткст имя() {
    return name_;
  }

  final ткст namespace() {
    return ns_;
  }

}