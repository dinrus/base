// Microsoft XML, v6.0
// Версия 6.0

/*[ууид("f5078f18-c551-11d3-89b9-0000f81fe221")]*/
module win32.xml.msxml;

/*[importlib("stdole2.tlb")]*/
private import win32.com.core;

// consts

// Constants that define a node's тип
enum tagDOMNodeType {
  NODE_INVALID = 0x00000000,
  NODE_ELEMENT = 0x00000001,
  NODE_ATTRIBUTE = 0x00000002,
  NODE_TEXT = 0x00000003,
  NODE_CDATA_SECTION = 0x00000004,
  NODE_ENTITY_REFERENCE = 0x00000005,
  NODE_ENTITY = 0x00000006,
  NODE_PROCESSING_INSTRUCTION = 0x00000007,
  NODE_COMMENT = 0x00000008,
  NODE_DOCUMENT = 0x00000009,
  NODE_DOCUMENT_TYPE = 0x0000000A,
  NODE_DOCUMENT_FRAGMENT = 0x0000000B,
  NODE_NOTATION = 0x0000000C,
}

// Schema Объект Model Item Types
enum _SOMITEMTYPE {
  SOMITEM_SCHEMA = 0x00001000,
  SOMITEM_ATTRIBUTE = 0x00001001,
  SOMITEM_ATTRIBUTEGROUP = 0x00001002,
  SOMITEM_NOTATION = 0x00001003,
  SOMITEM_ANNOTATION = 0x00001004,
  SOMITEM_IDENTITYCONSTRAINT = 0x00001100,
  SOMITEM_KEY = 0x00001101,
  SOMITEM_KEYREF = 0x00001102,
  SOMITEM_UNIQUE = 0x00001103,
  SOMITEM_ANYTYPE = 0x00002000,
  SOMITEM_DATATYPE = 0x00002100,
  SOMITEM_DATATYPE_ANYTYPE = 0x00002101,
  SOMITEM_DATATYPE_ANYURI = 0x00002102,
  SOMITEM_DATATYPE_BASE64BINARY = 0x00002103,
  SOMITEM_DATATYPE_BOOLEAN = 0x00002104,
  SOMITEM_DATATYPE_BYTE = 0x00002105,
  SOMITEM_DATATYPE_DATE = 0x00002106,
  SOMITEM_DATATYPE_DATETIME = 0x00002107,
  SOMITEM_DATATYPE_DAY = 0x00002108,
  SOMITEM_DATATYPE_DECIMAL = 0x00002109,
  SOMITEM_DATATYPE_DOUBLE = 0x0000210A,
  SOMITEM_DATATYPE_DURATION = 0x0000210B,
  SOMITEM_DATATYPE_ENTITIES = 0x0000210C,
  SOMITEM_DATATYPE_ENTITY = 0x0000210D,
  SOMITEM_DATATYPE_FLOAT = 0x0000210E,
  SOMITEM_DATATYPE_HEXBINARY = 0x0000210F,
  SOMITEM_DATATYPE_ID = 0x00002110,
  SOMITEM_DATATYPE_IDREF = 0x00002111,
  SOMITEM_DATATYPE_IDREFS = 0x00002112,
  SOMITEM_DATATYPE_INT = 0x00002113,
  SOMITEM_DATATYPE_INTEGER = 0x00002114,
  SOMITEM_DATATYPE_LANGUAGE = 0x00002115,
  SOMITEM_DATATYPE_LONG = 0x00002116,
  SOMITEM_DATATYPE_MONTH = 0x00002117,
  SOMITEM_DATATYPE_MONTHDAY = 0x00002118,
  SOMITEM_DATATYPE_NAME = 0x00002119,
  SOMITEM_DATATYPE_NCNAME = 0x0000211A,
  SOMITEM_DATATYPE_NEGATIVEINTEGER = 0x0000211B,
  SOMITEM_DATATYPE_NMTOKEN = 0x0000211C,
  SOMITEM_DATATYPE_NMTOKENS = 0x0000211D,
  SOMITEM_DATATYPE_NONNEGATIVEINTEGER = 0x0000211E,
  SOMITEM_DATATYPE_NONPOSITIVEINTEGER = 0x0000211F,
  SOMITEM_DATATYPE_NORMALIZEDSTRING = 0x00002120,
  SOMITEM_DATATYPE_NOTATION = 0x00002121,
  SOMITEM_DATATYPE_POSITIVEINTEGER = 0x00002122,
  SOMITEM_DATATYPE_QNAME = 0x00002123,
  SOMITEM_DATATYPE_SHORT = 0x00002124,
  SOMITEM_DATATYPE_STRING = 0x00002125,
  SOMITEM_DATATYPE_TIME = 0x00002126,
  SOMITEM_DATATYPE_TOKEN = 0x00002127,
  SOMITEM_DATATYPE_UNSIGNEDBYTE = 0x00002128,
  SOMITEM_DATATYPE_UNSIGNEDINT = 0x00002129,
  SOMITEM_DATATYPE_UNSIGNEDLONG = 0x0000212A,
  SOMITEM_DATATYPE_UNSIGNEDSHORT = 0x0000212B,
  SOMITEM_DATATYPE_YEAR = 0x0000212C,
  SOMITEM_DATATYPE_YEARMONTH = 0x0000212D,
  SOMITEM_DATATYPE_ANYSIMPLETYPE = 0x000021FF,
  SOMITEM_SIMPLETYPE = 0x00002200,
  SOMITEM_COMPLEXTYPE = 0x00002400,
  SOMITEM_PARTICLE = 0x00004000,
  SOMITEM_ANY = 0x00004001,
  SOMITEM_ANYATTRIBUTE = 0x00004002,
  SOMITEM_ELEMENT = 0x00004003,
  SOMITEM_GROUP = 0x00004100,
  SOMITEM_ALL = 0x00004101,
  SOMITEM_CHOICE = 0x00004102,
  SOMITEM_SEQUENCE = 0x00004103,
  SOMITEM_EMPTYPARTICLE = 0x00004104,
  SOMITEM_NULL = 0x00000800,
  SOMITEM_NULL_TYPE = 0x00002800,
  SOMITEM_NULL_ANY = 0x00004801,
  SOMITEM_NULL_ANYATTRIBUTE = 0x00004802,
  SOMITEM_NULL_ELEMENT = 0x00004803,
}

// Schema Объект Model Filters
enum _SCHEMADERIVATIONMETHOD {
  SCHEMADERIVATIONMETHOD_EMPTY = 0x00000000,
  SCHEMADERIVATIONMETHOD_SUBSTITUTION = 0x00000001,
  SCHEMADERIVATIONMETHOD_EXTENSION = 0x00000002,
  SCHEMADERIVATIONMETHOD_RESTRICTION = 0x00000004,
  SCHEMADERIVATIONMETHOD_LIST = 0x00000008,
  SCHEMADERIVATIONMETHOD_UNION = 0x00000010,
  SCHEMADERIVATIONMETHOD_ALL = 0x000000FF,
  SCHEMADERIVATIONMETHOD_NONE = 0x00000100,
}

// Schema Объект Model Тип variety значения
enum _SCHEMATYPEVARIETY {
  SCHEMATYPEVARIETY_NONE = 0xFFFFFFFF,
  SCHEMATYPEVARIETY_ATOMIC = 0x00000000,
  SCHEMATYPEVARIETY_LIST = 0x00000001,
  SCHEMATYPEVARIETY_UNION = 0x00000002,
}

// Schema Объект Model Whitespace facet значения
enum _SCHEMAWHITESPACE {
  SCHEMAWHITESPACE_NONE = 0xFFFFFFFF,
  SCHEMAWHITESPACE_PRESERVE = 0x00000000,
  SCHEMAWHITESPACE_REPLACE = 0x00000001,
  SCHEMAWHITESPACE_COLLAPSE = 0x00000002,
}

// Schema Объект Model Process Contents
enum _SCHEMAPROCESSCONTENTS {
  SCHEMAPROCESSCONTENTS_NONE = 0x00000000,
  SCHEMAPROCESSCONTENTS_SKIP = 0x00000001,
  SCHEMAPROCESSCONTENTS_LAX = 0x00000002,
  SCHEMAPROCESSCONTENTS_STRICT = 0x00000003,
}

// Schema Объект Model Content Types
enum _SCHEMACONTENTTYPE {
  SCHEMACONTENTTYPE_EMPTY = 0x00000000,
  SCHEMACONTENTTYPE_TEXTONLY = 0x00000001,
  SCHEMACONTENTTYPE_ELEMENTONLY = 0x00000002,
  SCHEMACONTENTTYPE_MIXED = 0x00000003,
}

// Schema Объект Model Attribute Uses
enum _SCHEMAUSE {
  SCHEMAUSE_OPTIONAL = 0x00000000,
  SCHEMAUSE_PROHIBITED = 0x00000001,
  SCHEMAUSE_REQUIRED = 0x00000002,
}

// Options for ServerXMLHTTPRequest Option property
enum _SERVERXMLHTTP_OPTION {
  SXH_OPTION_URL = 0xFFFFFFFF,
  SXH_OPTION_URL_CODEPAGE = 0x00000000,
  SXH_OPTION_ESCAPE_PERCENT_IN_URL = 0x00000001,
  SXH_OPTION_IGNORE_SERVER_SSL_CERT_ERROR_FLAGS = 0x00000002,
  SXH_OPTION_SELECT_CLIENT_SSL_CERT = 0x00000003,
}

// Flags for SXH_OPTION_IGNORE_SERVER_SSL_CERT_ERROR_FLAGS option
enum _SXH_SERVER_CERT_OPTION {
  SXH_SERVER_CERT_IGNORE_UNKNOWN_CA = 0x00000100,
  SXH_SERVER_CERT_IGNORE_WRONG_USAGE = 0x00000200,
  SXH_SERVER_CERT_IGNORE_CERT_CN_INVALID = 0x00001000,
  SXH_SERVER_CERT_IGNORE_CERT_DATE_INVALID = 0x00002000,
  SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = 0x00003300,
}

// Settings for setProxy
enum _SXH_PROXY_SETTING {
  SXH_PROXY_SET_DEFAULT = 0x00000000,
  SXH_PROXY_SET_PRECONFIG = 0x00000000,
  SXH_PROXY_SET_DIRECT = 0x00000001,
  SXH_PROXY_SET_PROXY = 0x00000002,
}

// Aliases

// Constants that define a node's тип
alias tagDOMNodeType DOMNodeType;

// Schema Объект Model Item Types
alias _SOMITEMTYPE SOMITEMTYPE;

// Schema Объект Model Filters
alias _SCHEMADERIVATIONMETHOD SCHEMADERIVATIONMETHOD;

// Schema Объект Model Тип variety значения
alias _SCHEMATYPEVARIETY SCHEMATYPEVARIETY;

// Schema Объект Model Whitespace facet значения
alias _SCHEMAWHITESPACE SCHEMAWHITESPACE;

// Schema Объект Model Process Contents
alias _SCHEMAPROCESSCONTENTS SCHEMAPROCESSCONTENTS;

// Schema Объект Model Content Types
alias _SCHEMACONTENTTYPE SCHEMACONTENTTYPE;

// Schema Объект Model Attribute Uses
alias _SCHEMAUSE SCHEMAUSE;

// Options for ServerXMLHTTPRequest Option property
alias _SERVERXMLHTTP_OPTION SERVERXMLHTTP_OPTION;

// Flags for SXH_OPTION_IGNORE_SERVER_SSL_CERT_ERROR_FLAGS option
alias _SXH_SERVER_CERT_OPTION SXH_SERVER_CERT_OPTION;

// Settings for setProxy
alias _SXH_PROXY_SETTING SXH_PROXY_SETTING;

// Интерфейсы

interface IXMLDOMImplementation : IDispatch {
  mixin(ууид("2933bf8f-7b36-11d2-b20e-00c04f983e60"));
  /*[ид(0x00000091)]*/ цел hasFeature(шим* feature, шим* versionParam, out крат hasFeature);
}

// Core DOM node interface
interface IXMLDOMNode : IDispatch {
  mixin(ууид("2933bf80-7b36-11d2-b20e-00c04f983e60"));
  // имя of the node
  /*[ид(0x00000002)]*/ цел get_nodeName(out шим* имя);
  // значение stored in the node
  /*[ид(0x00000003)]*/ цел get_nodeValue(out VARIANT значение);
  // значение stored in the node
  /*[ид(0x00000003)]*/ цел put_nodeValue(VARIANT значение);
  // the node's тип
  /*[ид(0x00000004)]*/ цел get_nodeType(out DOMNodeType тип);
  // родитель of the node
  /*[ид(0x00000006)]*/ цел get_parentNode(out IXMLDOMNode родитель);
  // the collection of the node's children
  /*[ид(0x00000007)]*/ цел get_childNodes(out IXMLDOMNodeList childList);
  // first child of the node
  /*[ид(0x00000008)]*/ цел get_firstChild(out IXMLDOMNode firstChild);
  // last child of the node
  /*[ид(0x00000009)]*/ цел get_lastChild(out IXMLDOMNode lastChild);
  // лево sibling of the node
  /*[ид(0x0000000A)]*/ цел get_previousSibling(out IXMLDOMNode previousSibling);
  // право sibling of the node
  /*[ид(0x0000000B)]*/ цел get_nextSibling(out IXMLDOMNode nextSibling);
  // the collection of the node's атрибуты
  /*[ид(0x0000000C)]*/ цел get_attributes(out IXMLDOMNamedNodeMap attributeMap);
  // вставь a child node
  /*[ид(0x0000000D)]*/ цел insertBefore(IXMLDOMNode newChild, VARIANT refChild, out IXMLDOMNode outNewChild);
  // замени a child node
  /*[ид(0x0000000E)]*/ цел replaceChild(IXMLDOMNode newChild, IXMLDOMNode oldChild, out IXMLDOMNode outOldChild);
  // удали a child node
  /*[ид(0x0000000F)]*/ цел removeChild(IXMLDOMNode childNode, out IXMLDOMNode oldChild);
  // append a child node
  /*[ид(0x00000010)]*/ цел appendChild(IXMLDOMNode newChild, out IXMLDOMNode outNewChild);
  /*[ид(0x00000011)]*/ цел hasChildNodes(out крат hasChild);
  // document that содержит the node
  /*[ид(0x00000012)]*/ цел get_ownerDocument(out IXMLDOMDocument DOMDocument);
  /*[ид(0x00000013)]*/ цел cloneNode(крат deep, out IXMLDOMNode cloneRoot);
  // the тип of node in ткст form
  /*[ид(0x00000015)]*/ цел get_nodeTypeString(out шим* nodeType);
  // text content of the node and subtree
  /*[ид(0x00000018)]*/ цел get_text(out шим* text);
  // text content of the node and subtree
  /*[ид(0x00000018)]*/ цел put_text(шим* text);
  // indicates whether node is a default значение
  /*[ид(0x00000016)]*/ цел get_specified(out крат isSpecified);
  // pointer to the definition of the node in the DTD or schema
  /*[ид(0x00000017)]*/ цел get_definition(out IXMLDOMNode definitionNode);
  // дай the strongly typed значение of the node
  /*[ид(0x00000019)]*/ цел get_nodeTypedValue(out VARIANT typedValue);
  // дай the strongly typed значение of the node
  /*[ид(0x00000019)]*/ цел put_nodeTypedValue(VARIANT typedValue);
  // the данные тип of the node
  /*[ид(0x0000001A)]*/ цел get_dataType(out VARIANT dataTypeName);
  // the данные тип of the node
  /*[ид(0x0000001A)]*/ цел put_dataType(шим* dataTypeName);
  // return the XML исток for the node and each of its descendants
  /*[ид(0x0000001B)]*/ цел get_xml(out шим* xmlString);
  // apply the stylesheet to the subtree
  /*[ид(0x0000001C)]*/ цел transformNode(IXMLDOMNode stylesheet, out шим* xmlString);
  // execute query on the subtree
  /*[ид(0x0000001D)]*/ цел selectNodes(шим* queryString, out IXMLDOMNodeList resultList);
  // execute query on the subtree
  /*[ид(0x0000001E)]*/ цел selectSingleNode(шим* queryString, out IXMLDOMNode resultNode);
  // has sub-tree been completely parsed
  /*[ид(0x0000001F)]*/ цел get_parsed(out крат isParsed);
  // the URI for the namespace applying to the node
  /*[ид(0x00000020)]*/ цел get_namespaceURI(out шим* namespaceURI);
  // the prefix for the namespace applying to the node
  /*[ид(0x00000021)]*/ цел get_prefix(out шим* prefixString);
  // the base имя of the node (nodename with the prefix stripped off)
  /*[ид(0x00000022)]*/ цел get_baseName(out шим* nameString);
  // apply the stylesheet to the subtree, returning the рез through a document or a поток
  /*[ид(0x00000023)]*/ цел transformNodeToObject(IXMLDOMNode stylesheet, VARIANT outputObject);
}

interface IXMLDOMNodeList : IDispatch {
  mixin(ууид("2933bf82-7b36-11d2-b20e-00c04f983e60"));
  // collection of nodes
  /*[ид(0x00000000)]*/ цел get_item(цел индекс, out IXMLDOMNode listItem);
  // число of nodes in the collection
  /*[ид(0x0000004A)]*/ цел get_length(out цел listLength);
  // дай следщ node from iterator
  /*[ид(0x0000004C)]*/ цел nextNode(out IXMLDOMNode nextItem);
  // сбрось the позиция of iterator
  /*[ид(0x0000004D)]*/ цел сбрось();
  /*[ид(0xFFFFFFFC)]*/ цел get__NewEnum(out IUnknown ppUnk);
}

interface IXMLDOMNamedNodeMap : IDispatch {
  mixin(ууид("2933bf83-7b36-11d2-b20e-00c04f983e60"));
  // lookup элт by имя
  /*[ид(0x00000053)]*/ цел getNamedItem(шим* имя, out IXMLDOMNode namedItem);
  // уст элт by имя
  /*[ид(0x00000054)]*/ цел setNamedItem(IXMLDOMNode newItem, out IXMLDOMNode nameItem);
  // удали элт by имя
  /*[ид(0x00000055)]*/ цел removeNamedItem(шим* имя, out IXMLDOMNode namedItem);
  // collection of nodes
  /*[ид(0x00000000)]*/ цел get_item(цел индекс, out IXMLDOMNode listItem);
  // число of nodes in the collection
  /*[ид(0x0000004A)]*/ цел get_length(out цел listLength);
  // lookup the элт by имя and namespace
  /*[ид(0x00000057)]*/ цел getQualifiedItem(шим* baseName, шим* namespaceURI, out IXMLDOMNode qualifiedItem);
  // удали the элт by имя and namespace
  /*[ид(0x00000058)]*/ цел removeQualifiedItem(шим* baseName, шим* namespaceURI, out IXMLDOMNode qualifiedItem);
  // дай следщ node from iterator
  /*[ид(0x00000059)]*/ цел nextNode(out IXMLDOMNode nextItem);
  // сбрось the позиция of iterator
  /*[ид(0x0000005A)]*/ цел сбрось();
  /*[ид(0xFFFFFFFC)]*/ цел get__NewEnum(out IUnknown ppUnk);
}

interface IXMLDOMDocument : IXMLDOMNode {
  mixin(ууид("2933bf81-7b36-11d2-b20e-00c04f983e60"));
  // node corresponding to the DOCTYPE
  /*[ид(0x00000026)]*/ цел get_doctype(out IXMLDOMDocumentType documentType);
  // info on this DOM implementation
  /*[ид(0x00000027)]*/ цел get_implementation(out IXMLDOMImplementation impl);
  // the root of the tree
  /*[ид(0x00000028)]*/ цел get_documentElement(out IXMLDOMElement DOMElement);
  // the root of the tree
  /*[ид(0x00000028)]*/ цел putref_documentElement(IXMLDOMElement DOMElement);
  // create an Element node
  /*[ид(0x00000029)]*/ цел createElement(шим* tagName, out IXMLDOMElement element);
  // create a DocumentFragment node
  /*[ид(0x0000002A)]*/ цел createDocumentFragment(out IXMLDOMDocumentFragment docFrag);
  // create a text node
  /*[ид(0x0000002B)]*/ цел createTextNode(шим* данные, out IXMLDOMText text);
  // create a коммент node
  /*[ид(0x0000002C)]*/ цел createComment(шим* данные, out IXMLDOMComment коммент);
  // create a CDATA section node
  /*[ид(0x0000002D)]*/ цел createCDATASection(шим* данные, out IXMLDOMCDATASection cdata);
  // create a processing instruction node
  /*[ид(0x0000002E)]*/ цел createProcessingInstruction(шим* цель, шим* данные, out IXMLDOMProcessingInstruction pi);
  // create an attribute node
  /*[ид(0x0000002F)]*/ цел createAttribute(шим* имя, out IXMLDOMAttribute attribute);
  // create an entity reference node
  /*[ид(0x00000031)]*/ цел createEntityReference(шим* имя, out IXMLDOMEntityReference entityRef);
  // build a список of elements by имя
  /*[ид(0x00000032)]*/ цел getElementsByTagName(шим* tagName, out IXMLDOMNodeList resultList);
  // create a node of the specified node тип and имя
  /*[ид(0x00000036)]*/ цел createNode(VARIANT тип, шим* имя, шим* namespaceURI, out IXMLDOMNode node);
  // retrieve node from it's ID
  /*[ид(0x00000038)]*/ цел nodeFromID(шим* idString, out IXMLDOMNode node);
  // загрузи document from the specified XML исток
  /*[ид(0x0000003A)]*/ цел загрузи(VARIANT xmlSource, out крат isSuccessful);
  // дай the state of the XML document
  /*[ид(0xFFFFFDF3)]*/ цел get_readyState(out цел значение);
  // дай the last parser ошибка
  /*[ид(0x0000003B)]*/ цел get_parseError(out IXMLDOMParseError errorObj);
  // дай the URL for the loaded XML document
  /*[ид(0x0000003C)]*/ цел get_url(out шим* urlString);
  // flag for asynchronous download
  /*[ид(0x0000003D)]*/ цел get_async(out крат isAsync);
  // flag for asynchronous download
  /*[ид(0x0000003D)]*/ цел put_async(крат isAsync);
  // abort an asynchronous download
  /*[ид(0x0000003E)]*/ цел abort();
  // загрузи the document from a ткст
  /*[ид(0x0000003F)]*/ цел loadXML(шим* bstrXML, out крат isSuccessful);
  // save the document to a specified destination
  /*[ид(0x00000040)]*/ цел save(VARIANT destination);
  // indicates whether the parser performs validation
  /*[ид(0x00000041)]*/ цел get_validateOnParse(out крат isValidating);
  // indicates whether the parser performs validation
  /*[ид(0x00000041)]*/ цел put_validateOnParse(крат isValidating);
  // indicates whether the parser resolves references to external DTD/Entities/Schema
  /*[ид(0x00000042)]*/ цел get_resolveExternals(out крат isResolving);
  // indicates whether the parser resolves references to external DTD/Entities/Schema
  /*[ид(0x00000042)]*/ цел put_resolveExternals(крат isResolving);
  // indicates whether the parser preserves whitespace
  /*[ид(0x00000043)]*/ цел get_preserveWhiteSpace(out крат isPreserving);
  // indicates whether the parser preserves whitespace
  /*[ид(0x00000043)]*/ цел put_preserveWhiteSpace(крат isPreserving);
  // register a readystatechange событие handler
  /*[ид(0x00000044)]*/ цел put_onreadystatechange(VARIANT значение);
  // register an ondataavailable событие handler
  /*[ид(0x00000045)]*/ цел put_ondataavailable(VARIANT значение);
  // register an ontransformnode событие handler
  /*[ид(0x00000046)]*/ цел put_ontransformnode(VARIANT значение);
}

interface IXMLDOMDocumentType : IXMLDOMNode {
  mixin(ууид("2933bf8b-7b36-11d2-b20e-00c04f983e60"));
  // имя of the document тип (root of the tree)
  /*[ид(0x00000083)]*/ цел get_name(out шим* rootName);
  // a список of entities in the document
  /*[ид(0x00000084)]*/ цел get_entities(out IXMLDOMNamedNodeMap entityMap);
  // a список of notations in the document
  /*[ид(0x00000085)]*/ цел get_notations(out IXMLDOMNamedNodeMap notationMap);
}

interface IXMLDOMElement : IXMLDOMNode {
  mixin(ууид("2933bf86-7b36-11d2-b20e-00c04f983e60"));
  // дай the tagName of the element
  /*[ид(0x00000061)]*/ цел get_tagName(out шим* tagName);
  // look up the ткст значение of an attribute by имя
  /*[ид(0x00000063)]*/ цел getAttribute(шим* имя, out VARIANT значение);
  // уст the ткст значение of an attribute by имя
  /*[ид(0x00000064)]*/ цел setAttribute(шим* имя, VARIANT значение);
  // удали an attribute by имя
  /*[ид(0x00000065)]*/ цел removeAttribute(шим* имя);
  // look up the attribute node by имя
  /*[ид(0x00000066)]*/ цел getAttributeNode(шим* имя, out IXMLDOMAttribute attributeNode);
  // уст the specified attribute on the element
  /*[ид(0x00000067)]*/ цел setAttributeNode(IXMLDOMAttribute DOMAttribute, out IXMLDOMAttribute attributeNode);
  // удали the specified attribute
  /*[ид(0x00000068)]*/ цел removeAttributeNode(IXMLDOMAttribute DOMAttribute, out IXMLDOMAttribute attributeNode);
  // build a список of elements by имя
  /*[ид(0x00000069)]*/ цел getElementsByTagName(шим* tagName, out IXMLDOMNodeList resultList);
  // collapse all adjacent text nodes in sub-tree
  /*[ид(0x0000006A)]*/ цел normalize();
}

interface IXMLDOMAttribute : IXMLDOMNode {
  mixin(ууид("2933bf85-7b36-11d2-b20e-00c04f983e60"));
  // дай имя of the attribute
  /*[ид(0x00000076)]*/ цел get_name(out шим* attributeName);
  // ткст значение of the attribute
  /*[ид(0x00000078)]*/ цел get_value(out VARIANT attributeValue);
  // ткст значение of the attribute
  /*[ид(0x00000078)]*/ цел put_value(VARIANT attributeValue);
}

interface IXMLDOMDocumentFragment : IXMLDOMNode {
  mixin(ууид("3efaa413-272f-11d2-836f-0000f87a7782"));
}

interface IXMLDOMText : IXMLDOMCharacterData {
  mixin(ууид("2933bf87-7b36-11d2-b20e-00c04f983e60"));
  // разбей the text node into two text nodes at the позиция specified
  /*[ид(0x0000007B)]*/ цел splitText(цел смещение, out IXMLDOMText rightHandTextNode);
}

interface IXMLDOMCharacterData : IXMLDOMNode {
  mixin(ууид("2933bf84-7b36-11d2-b20e-00c04f983e60"));
  // значение of the node
  /*[ид(0x0000006D)]*/ цел get_data(out шим* данные);
  // значение of the node
  /*[ид(0x0000006D)]*/ цел put_data(шим* данные);
  // число of characters in значение
  /*[ид(0x0000006E)]*/ цел get_length(out цел dataLength);
  // retrieve substring of значение
  /*[ид(0x0000006F)]*/ цел substringData(цел смещение, цел счёт, out шим* данные);
  // append ткст to значение
  /*[ид(0x00000070)]*/ цел appendData(шим* данные);
  // вставь ткст into значение
  /*[ид(0x00000071)]*/ цел insertData(цел смещение, шим* данные);
  // delete ткст within the значение
  /*[ид(0x00000072)]*/ цел deleteData(цел смещение, цел счёт);
  // замени ткст within the значение
  /*[ид(0x00000073)]*/ цел replaceData(цел смещение, цел счёт, шим* данные);
}

interface IXMLDOMComment : IXMLDOMCharacterData {
  mixin(ууид("2933bf88-7b36-11d2-b20e-00c04f983e60"));
}

interface IXMLDOMCDATASection : IXMLDOMText {
  mixin(ууид("2933bf8a-7b36-11d2-b20e-00c04f983e60"));
}

interface IXMLDOMProcessingInstruction : IXMLDOMNode {
  mixin(ууид("2933bf89-7b36-11d2-b20e-00c04f983e60"));
  // the цель
  /*[ид(0x0000007F)]*/ цел get_target(out шим* имя);
  // the данные
  /*[ид(0x00000080)]*/ цел get_data(out шим* значение);
  // the данные
  /*[ид(0x00000080)]*/ цел put_data(шим* значение);
}

interface IXMLDOMEntityReference : IXMLDOMNode {
  mixin(ууид("2933bf8e-7b36-11d2-b20e-00c04f983e60"));
}

// structure for reporting parser errors
interface IXMLDOMParseError : IDispatch {
  mixin(ууид("3efaa426-272f-11d2-836f-0000f87a7782"));
  // the ошибка code
  /*[ид(0x00000000)]*/ цел get_errorCode(out цел кодОш);
  // the URL of the XML document containing the ошибка
  /*[ид(0x000000B3)]*/ цел get_url(out шим* urlString);
  // the cause of the ошибка
  /*[ид(0x000000B4)]*/ цел get_reason(out шим* reasonString);
  // the данные where the ошибка occurred
  /*[ид(0x000000B5)]*/ цел get_srcText(out шим* sourceString);
  // the line число in the XML document where the ошибка occurred
  /*[ид(0x000000B6)]*/ цел get_line(out цел linconstber);
  // the character позиция in the line containing the ошибка
  /*[ид(0x000000B7)]*/ цел get_linepos(out цел linePosition);
  // the absolute file позиция in the XML document containing the ошибка
  /*[ид(0x000000B8)]*/ цел get_filepos(out цел filePosition);
}

interface IXMLDOMDocument2 : IXMLDOMDocument {
  mixin(ууид("2933bf95-7b36-11d2-b20e-00c04f983e60"));
  // A collection of all namespaces for this document
  /*[ид(0x000000C9)]*/ цел get_namespaces(out IXMLDOMSchemaCollection namespaceCollection);
  // The associated schema cache
  /*[ид(0x000000CA)]*/ цел get_schemas(out VARIANT otherCollection);
  // The associated schema cache
  /*[ид(0x000000CA)]*/ цел putref_schemas(VARIANT otherCollection);
  // perform runtime validation on the currently loaded XML document
  /*[ид(0x000000CB)]*/ цел validate(out IXMLDOMParseError errorObj);
  // уст the значение of the named property
  /*[ид(0x000000CC)]*/ цел setProperty(шим* имя, VARIANT значение);
  // дай the значение of the named property
  /*[ид(0x000000CD)]*/ цел getProperty(шим* имя, out VARIANT значение);
}

// XML Schemas Подборка
interface IXMLDOMSchemaCollection : IDispatch {
  mixin(ууид("373984c8-b845-449b-91e7-45ac83036ade"));
  // добавь a new schema
  /*[ид(0x00000003)]*/ цел добавь(шим* namespaceURI, VARIANT var);
  // lookup schema by namespaceURI
  /*[ид(0x00000004)]*/ цел дай(шим* namespaceURI, out IXMLDOMNode schemaNode);
  // удали schema by namespaceURI
  /*[ид(0x00000005)]*/ цел удали(шим* namespaceURI);
  // число of schemas in collection
  /*[ид(0x00000006)]*/ цел get_length(out цел length);
  // Get namespaceURI for schema by индекс
  /*[ид(0x00000000)]*/ цел get_namespaceURI(цел индекс, out шим* length);
  // копируй & merge другой collection into this one
  /*[ид(0x00000008)]*/ цел addCollection(IXMLDOMSchemaCollection otherCollection);
  /*[ид(0xFFFFFFFC)]*/ цел get__NewEnum(out IUnknown ppUnk);
}

interface IXMLDOMDocument3 : IXMLDOMDocument2 {
  mixin(ууид("2933bf96-7b36-11d2-b20e-00c04f983e60"));
  // perform runtime validation on the currently loaded XML document node
  /*[ид(0x000000D0)]*/ цел validateNode(IXMLDOMNode node, out IXMLDOMParseError errorObj);
  // clone node such that clones ownerDocument is this document
  /*[ид(0x000000D1)]*/ цел importNode(IXMLDOMNode node, крат deep, out IXMLDOMNode clone);
}

interface IXMLDOMNotation : IXMLDOMNode {
  mixin(ууид("2933bf8c-7b36-11d2-b20e-00c04f983e60"));
  // the public ID
  /*[ид(0x00000088)]*/ цел get_publicId(out VARIANT publicId);
  // the system ID
  /*[ид(0x00000089)]*/ цел get_systemId(out VARIANT systemId);
}

interface IXMLDOMEntity : IXMLDOMNode {
  mixin(ууид("2933bf8d-7b36-11d2-b20e-00c04f983e60"));
  // the public ID
  /*[ид(0x0000008C)]*/ цел get_publicId(out VARIANT publicId);
  // the system ID
  /*[ид(0x0000008D)]*/ цел get_systemId(out VARIANT systemId);
  // the имя of the notation
  /*[ид(0x0000008E)]*/ цел get_notationName(out шим* имя);
}

// structure for reporting parser errors
interface IXMLDOMParseError2 : IXMLDOMParseError {
  mixin(ууид("3efaa428-272f-11d2-836f-0000f87a7782"));
  /*[ид(0x000000BE)]*/ цел get_errorXPath(out шим* xpathexpr);
  /*[ид(0x000000BB)]*/ цел get_allErrors(out IXMLDOMParseErrorCollection allErrors);
  /*[ид(0x000000BC)]*/ цел errorParameters(цел индекс, out шим* param);
  /*[ид(0x000000BD)]*/ цел get_errorParametersCount(out цел счёт);
}

// structure for reporting parser errors
interface IXMLDOMParseErrorCollection : IDispatch {
  mixin(ууид("3efaa429-272f-11d2-836f-0000f87a7782"));
  /*[ид(0x00000000)]*/ цел get_item(цел индекс, out IXMLDOMParseError2 ошибка);
  /*[ид(0x000000C1)]*/ цел get_length(out цел length);
  /*[ид(0x000000C2)]*/ цел get_next(out IXMLDOMParseError2 ошибка);
  /*[ид(0x000000C3)]*/ цел сбрось();
  /*[ид(0xFFFFFFFC)]*/ цел get__NewEnum(out IUnknown ppUnk);
}

// XTL runtime object
interface IXTLRuntime : IXMLDOMNode {
  mixin(ууид("3efaa425-272f-11d2-836f-0000f87a7782"));
  /*[ид(0x000000BB)]*/ цел uniqueID(IXMLDOMNode pNode, out цел pID);
  /*[ид(0x000000BC)]*/ цел depth(IXMLDOMNode pNode, out цел pDepth);
  /*[ид(0x000000BD)]*/ цел childNumber(IXMLDOMNode pNode, out цел pNumber);
  /*[ид(0x000000BE)]*/ цел ancestorChildNumber(шим* bstrNodeName, IXMLDOMNode pNode, out цел pNumber);
  /*[ид(0x000000BF)]*/ цел absoluteChildNumber(IXMLDOMNode pNode, out цел pNumber);
  /*[ид(0x000000C0)]*/ цел formatIndex(цел lIndex, шим* bstrFormat, out шим* pbstrFormattedString);
  /*[ид(0x000000C1)]*/ цел фмЧисло(дво dblNumber, шим* bstrFormat, out шим* pbstrFormattedString);
  /*[ид(0x000000C2)]*/ цел formatDate(VARIANT varDate, шим* bstrFormat, VARIANT varDestLocale, out шим* pbstrFormattedString);
  /*[ид(0x000000C3)]*/ цел formatTime(VARIANT varTime, шим* bstrFormat, VARIANT varDestLocale, out шим* pbstrFormattedString);
}

// IXSLTemplate Интерфейс
interface IXSLTemplate : IDispatch {
  mixin(ууид("2933bf93-7b36-11d2-b20e-00c04f983e60"));
  // stylesheet to use with processors
  /*[ид(0x00000002)]*/ цел putref_stylesheet(IXMLDOMNode stylesheet);
  // stylesheet to use with processors
  /*[ид(0x00000002)]*/ цел get_stylesheet(out IXMLDOMNode stylesheet);
  // create a new processor object
  /*[ид(0x00000003)]*/ цел createProcessor(out IXSLProcessor ppProcessor);
}

// IXSLProcessor Интерфейс
interface IXSLProcessor : IDispatch {
  mixin(ууид("2933bf92-7b36-11d2-b20e-00c04f983e60"));
  // XML ввод tree to transform
  /*[ид(0x00000002)]*/ цел put_input(VARIANT pVar);
  // XML ввод tree to transform
  /*[ид(0x00000002)]*/ цел get_input(out VARIANT pVar);
  // template object used to create this processor object
  /*[ид(0x00000003)]*/ цел get_ownerTemplate(out IXSLTemplate ppTemplate);
  // уст XSL mode and it's namespace
  /*[ид(0x00000004)]*/ цел setStartMode(шим* mode, шим* namespaceURI);
  // starting XSL mode
  /*[ид(0x00000005)]*/ цел get_startMode(out шим* mode);
  // namespace of starting XSL mode
  /*[ид(0x00000006)]*/ цел get_startModeURI(out шим* namespaceURI);
  // custom поток object for transform вывод
  /*[ид(0x00000007)]*/ цел put_output(VARIANT pOutput);
  // custom поток object for transform вывод
  /*[ид(0x00000007)]*/ цел get_output(out VARIANT pOutput);
  // start/resume the XSL transformation process
  /*[ид(0x00000008)]*/ цел transform(out крат pDone);
  // сбрось state of processor and abort текущ transform
  /*[ид(0x00000009)]*/ цел сбрось();
  // текущ state of the processor
  /*[ид(0x0000000A)]*/ цел get_readyState(out цел pReadyState);
  // уст <xsl:param> значения
  /*[ид(0x0000000B)]*/ цел addParameter(шим* baseName, VARIANT parameter, шим* namespaceURI);
  // pass object to stylesheet
  /*[ид(0x0000000C)]*/ цел addObject(IDispatch объ, шим* namespaceURI);
  // текущ stylesheet being used
  /*[ид(0x0000000D)]*/ цел get_stylesheet(out IXMLDOMNode stylesheet);
}

// ISAXXMLReader interface
interface ISAXXMLReader : IUnknown {
  mixin(ууид("a4f96ed0-f829-476e-81c0-cdc7bd2a0802"));
  /*[ид(0x60010000)]*/ цел getFeature(шим* pwchName, out крат pvfValue);
  /*[ид(0x60010001)]*/ цел putFeature(шим* pwchName, крат vfValue);
  /*[ид(0x60010002)]*/ цел getProperty(шим* pwchName, out VARIANT pvarValue);
  /*[ид(0x60010003)]*/ цел putProperty(шим* pwchName, VARIANT varValue);
  /*[ид(0x60010004)]*/ цел getEntityResolver(out ISAXEntityResolver ppResolver);
  /*[ид(0x60010005)]*/ цел putEntityResolver(ISAXEntityResolver pResolver);
  /*[ид(0x60010006)]*/ цел getContentHandler(out ISAXContentHandler ppHandler);
  /*[ид(0x60010007)]*/ цел putContentHandler(ISAXContentHandler pHandler);
  /*[ид(0x60010008)]*/ цел getDTDHandler(out ISAXDTDHandler ppHandler);
  /*[ид(0x60010009)]*/ цел putDTDHandler(ISAXDTDHandler pHandler);
  /*[ид(0x6001000A)]*/ цел getErrorHandler(out ISAXErrorHandler ppHandler);
  /*[ид(0x6001000B)]*/ цел putErrorHandler(ISAXErrorHandler pHandler);
  /*[ид(0x6001000C)]*/ цел getBaseURL(out шим* ppwchBaseUrl);
  /*[ид(0x6001000D)]*/ цел putBaseURL(шим* pwchBaseUrl);
  /*[ид(0x6001000E)]*/ цел getSecureBaseURL(out шим* ppwchSecureBaseUrl);
  /*[ид(0x6001000F)]*/ цел putSecureBaseURL(шим* pwchSecureBaseUrl);
  /*[ид(0x60010010)]*/ цел разбор(VARIANT varInput);
  /*[ид(0x60010011)]*/ цел parseURL(шим* pwchUrl);
}

// ISAXEntityResolver interface
interface ISAXEntityResolver : IUnknown {
  mixin(ууид("99bca7bd-e8c4-4d5f-a0cf-6d907901ff07"));
  /*[ид(0x60010000)]*/ цел resolveEntity(шим* pwchPublicId, шим* pwchSystemId, out VARIANT pvarInput);
}

// ISAXContentHandler interface
interface ISAXContentHandler : IUnknown {
  mixin(ууид("1545cdfa-9e4e-4497-a8a4-2bf7d0112c44"));
  /*[ид(0x60010000)]*/ цел putDocumentLocator(ISAXLocator pLocator);
  /*[ид(0x60010001)]*/ цел startDocument();
  /*[ид(0x60010002)]*/ цел endDocument();
  /*[ид(0x60010003)]*/ цел startPrefixMapping(шим* pwchPrefix, цел cchPrefix, шим* pwchUri, цел cchUri);
  /*[ид(0x60010004)]*/ цел endPrefixMapping(шим* pwchPrefix, цел cchPrefix);
  /*[ид(0x60010005)]*/ цел startElement(шим* pwchNamespaceUri, цел cchNamespaceUri, шим* pwchLocalName, цел cchLocalName, шим* pwchQName, цел cchQName, ISAXAttributes pAttributes);
  /*[ид(0x60010006)]*/ цел endElement(шим* pwchNamespaceUri, цел cchNamespaceUri, шим* pwchLocalName, цел cchLocalName, шим* pwchQName, цел cchQName);
  /*[ид(0x60010007)]*/ цел characters(шим* pwchChars, цел cchChars);
  /*[ид(0x60010008)]*/ цел ignorableWhitespace(шим* pwchChars, цел cchChars);
  /*[ид(0x60010009)]*/ цел processingInstruction(шим* pwchTarget, цел cchTarget, шим* pwchData, цел cchData);
  /*[ид(0x6001000A)]*/ цел skippedEntity(шим* pwchName, цел cchName);
}

// ISAXLocator interface
interface ISAXLocator : IUnknown {
  mixin(ууид("9b7e472a-0de4-4640-bff3-84d38a051c31"));
  /*[ид(0x60010000)]*/ цел getColumnNumber(out цел pnColumn);
  /*[ид(0x60010001)]*/ цел getLinconstber(out цел pnLine);
  /*[ид(0x60010002)]*/ цел getPublicId(out шим* ppwchPublicId);
  /*[ид(0x60010003)]*/ цел getSystemId(out шим* ppwchSystemId);
}

// ISAXAttributes interface
interface ISAXAttributes : IUnknown {
  mixin(ууид("f078abe1-45d2-4832-91ea-4466ce2f25c9"));
  /*[ид(0x60010000)]*/ цел дайДлину(out цел pnLength);
  /*[ид(0x60010001)]*/ цел getURI(цел nIndex, out шим* ppwchUri, out цел pcchUri);
  /*[ид(0x60010002)]*/ цел getLocalName(цел nIndex, out шим* ppwchLocalName, out цел pcchLocalName);
  /*[ид(0x60010003)]*/ цел getQName(цел nIndex, out бкрат ppwchQName, out цел pcchQName);
  /*[ид(0x60010004)]*/ цел getName(цел nIndex, out шим* ppwchUri, out цел pcchUri, out шим* ppwchLocalName, out цел pcchLocalName, out шим* ppwchQName, out цел pcchQName);
  /*[ид(0x60010005)]*/ цел getIndexFromName(шим* pwchUri, цел cchUri, шим* pwchLocalName, цел cchLocalName, out цел pnIndex);
  /*[ид(0x60010006)]*/ цел getIndexFromQName(бкрат* pwchQName, цел cchQName, out цел pnIndex);
  /*[ид(0x60010007)]*/ цел getType(цел nIndex, out шим* ppwchType, out цел pcchType);
  /*[ид(0x60010008)]*/ цел getTypeFromName(шим* pwchUri, цел cchUri, шим* pwchLocalName, цел cchLocalName, out шим* ppwchType, out цел pcchType);
  /*[ид(0x60010009)]*/ цел getTypeFromQName(шим* pwchQName, цел cchQName, out шим* ppwchType, out цел pcchType);
  /*[ид(0x6001000A)]*/ цел дайЗначение(цел nIndex, out шим* ppwchValue, out цел pcchValue);
  /*[ид(0x6001000B)]*/ цел getValueFromName(шим* pwchUri, цел cchUri, шим* pwchLocalName, цел cchLocalName, out шим* ppwchValue, out цел pcchValue);
  /*[ид(0x6001000C)]*/ цел getValueFromQName(шим* pwchQName, цел cchQName, out шим* ppwchValue, out цел pcchValue);
}

// ISAXDTDHandler interface
interface ISAXDTDHandler : IUnknown {
  mixin(ууид("e15c1baf-afb3-4d60-8c36-19a8c45defed"));
  /*[ид(0x60010000)]*/ цел notationDecl(шим* pwchName, цел cchName, шим* pwchPublicId, цел cchPublicId, шим* pwchSystemId, цел cchSystemId);
  /*[ид(0x60010001)]*/ цел unparsedEntityDecl(шим* pwchName, цел cchName, шим* pwchPublicId, цел cchPublicId, шим* pwchSystemId, цел cchSystemId, шим* pwchNotationName, цел cchNotationName);
}

// ISAXErrorHandler interface
interface ISAXErrorHandler : IUnknown {
  mixin(ууид("a60511c4-ccf5-479e-98a3-dc8dc545b7d0"));
  /*[ид(0x60010000)]*/ цел ошибка(ISAXLocator pLocator, шим* pwchErrorMessage, цел hrErrorCode);
  /*[ид(0x60010001)]*/ цел fatalError(ISAXLocator pLocator, шим* pwchErrorMessage, цел hrErrorCode);
  /*[ид(0x60010002)]*/ цел ignorableWarning(ISAXLocator pLocator, шим* pwchErrorMessage, цел hrErrorCode);
}

// ISAXXMLFilter interface
interface ISAXXMLFilter : ISAXXMLReader {
  mixin(ууид("70409222-ca09-4475-acb8-40312fe8d145"));
  /*[ид(0x60020000)]*/ цел getParent(out ISAXXMLReader ppReader);
  /*[ид(0x60020001)]*/ цел putParent(ISAXXMLReader pReader);
}

// ISAXLexicalHandler interface
interface ISAXLexicalHandler : IUnknown {
  mixin(ууид("7f85d5f5-47a8-4497-bda5-84ba04819ea6"));
  /*[ид(0x60010000)]*/ цел startDTD(шим* pwchName, цел cchName, шим* pwchPublicId, цел cchPublicId, шим* pwchSystemId, цел cchSystemId);
  /*[ид(0x60010001)]*/ цел endDTD();
  /*[ид(0x60010002)]*/ цел startEntity(шим* pwchName, цел cchName);
  /*[ид(0x60010003)]*/ цел endEntity(шим* pwchName, цел cchName);
  /*[ид(0x60010004)]*/ цел startCDATA();
  /*[ид(0x60010005)]*/ цел endCDATA();
  /*[ид(0x60010006)]*/ цел коммент(шим* pwchChars, цел cchChars);
}

// ISAXDeclHandler interface
interface ISAXDeclHandler : IUnknown {
  mixin(ууид("862629ac-771a-47b2-8337-4e6843c1be90"));
  /*[ид(0x60010000)]*/ цел elementDecl(шим* pwchName, цел cchName, шим* pwchModel, цел cchModel);
  /*[ид(0x60010001)]*/ цел attributeDecl(шим* pwchElementName, цел cchElementName, шим* pwchAttributeName, цел cchAttributeName, шим* pwchType, цел cchType, шим* pwchValueDefault, цел cchValueDefault, шим* pwchValue, цел cchValue);
  /*[ид(0x60010002)]*/ цел internalEntityDecl(шим* pwchName, цел cchName, шим* pwchValue, цел cchValue);
  /*[ид(0x60010003)]*/ цел externalEntityDecl(шим* pwchName, цел cchName, шим* pwchPublicId, цел cchPublicId, шим* pwchSystemId, цел cchSystemId);
}

// IVBSAXXMLReader interface
interface IVBSAXXMLReader : IDispatch {
  mixin(ууид("8c033caa-6cd6-4f73-b728-4531af74945f"));
  // Look up the значение of a feature.
  /*[ид(0x00000502)]*/ цел getFeature(шим* strName, out крат fValue);
  // Set the state of a feature.
  /*[ид(0x00000503)]*/ цел putFeature(шим* strName, крат fValue);
  // Look up the значение of a property.
  /*[ид(0x00000504)]*/ цел getProperty(шим* strName, out VARIANT varValue);
  // Set the значение of a property.
  /*[ид(0x00000505)]*/ цел putProperty(шим* strName, VARIANT varValue);
  // Allow an application to register an entity resolver or look up the текущ entity resolver.
  /*[ид(0x00000506)]*/ цел get_entityResolver(out IVBSAXEntityResolver oResolver);
  // Allow an application to register an entity resolver or look up the текущ entity resolver.
  /*[ид(0x00000506)]*/ цел putref_entityResolver(IVBSAXEntityResolver oResolver);
  // Allow an application to register a content событие handler or look up the текущ content событие handler.
  /*[ид(0x00000507)]*/ цел get_contentHandler(out IVBSAXContentHandler oHandler);
  // Allow an application to register a content событие handler or look up the текущ content событие handler.
  /*[ид(0x00000507)]*/ цел putref_contentHandler(IVBSAXContentHandler oHandler);
  // Allow an application to register a DTD событие handler or look up the текущ DTD событие handler.
  /*[ид(0x00000508)]*/ цел get_dtdHandler(out IVBSAXDTDHandler oHandler);
  // Allow an application to register a DTD событие handler or look up the текущ DTD событие handler.
  /*[ид(0x00000508)]*/ цел putref_dtdHandler(IVBSAXDTDHandler oHandler);
  // Allow an application to register an ошибка событие handler or look up the текущ ошибка событие handler.
  /*[ид(0x00000509)]*/ цел get_errorHandler(out IVBSAXErrorHandler oHandler);
  // Allow an application to register an ошибка событие handler or look up the текущ ошибка событие handler.
  /*[ид(0x00000509)]*/ цел putref_errorHandler(IVBSAXErrorHandler oHandler);
  // Set or дай the base URL for the document.
  /*[ид(0x0000050A)]*/ цел get_baseURL(out шим* strBaseURL);
  // Set or дай the base URL for the document.
  /*[ид(0x0000050A)]*/ цел put_baseURL(шим* strBaseURL);
  // Set or дай the secure base URL for the document.
  /*[ид(0x0000050B)]*/ цел get_secureBaseURL(out шим* strSecureBaseURL);
  // Set or дай the secure base URL for the document.
  /*[ид(0x0000050B)]*/ цел put_secureBaseURL(шим* strSecureBaseURL);
  // Parse an XML document.
  /*[ид(0x0000050C)]*/ цел разбор(VARIANT varInput);
  // Parse an XML document from a system identifier (URI).
  /*[ид(0x0000050D)]*/ цел parseURL(шим* strURL);
}

// IVBSAXEntityResolver interface
interface IVBSAXEntityResolver : IDispatch {
  mixin(ууид("0c05d096-f45b-4aca-ad1a-aa0bc25518dc"));
  // Allow the application to resolve external entities.
  /*[ид(0x00000527)]*/ цел resolveEntity(ref шим* strPublicId, ref шим* strSystemId, out VARIANT varInput);
}

// IVBSAXContentHandler interface
interface IVBSAXContentHandler : IDispatch {
  mixin(ууид("2ed7290a-4dd5-4b46-bb26-4e4155e77faa"));
  // Receive an object for locating the origin of SAX document собы.
  /*[ид(0x0000052A)]*/ цел putref_documentLocator(IVBSAXLocator значение);
  // Receive notification of the beginning of a document.
  /*[ид(0x0000052B)]*/ цел startDocument();
  // Receive notification of the end of a document.
  /*[ид(0x0000052C)]*/ цел endDocument();
  // Begin the scope of a prefix-URI Namespace mapping.
  /*[ид(0x0000052D)]*/ цел startPrefixMapping(ref шим* strPrefix, ref шим* strURI);
  // End the scope of a prefix-URI mapping.
  /*[ид(0x0000052E)]*/ цел endPrefixMapping(ref шим* strPrefix);
  // Receive notification of the beginning of an element.
  /*[ид(0x0000052F)]*/ цел startElement(ref шим* strNamespaceURI, ref шим* strLocalName, ref шим* strQName, IVBSAXAttributes oAttributes);
  // Receive notification of the end of an element.
  /*[ид(0x00000530)]*/ цел endElement(ref шим* strNamespaceURI, ref шим* strLocalName, ref шим* strQName);
  // Receive notification of character данные.
  /*[ид(0x00000531)]*/ цел characters(ref шим* strChars);
  // Receive notification of ignorable whitespace in element content.
  /*[ид(0x00000532)]*/ цел ignorableWhitespace(ref шим* strChars);
  // Receive notification of a processing instruction.
  /*[ид(0x00000533)]*/ цел processingInstruction(ref шим* strTarget, ref шим* strData);
  // Receive notification of a skipped entity.
  /*[ид(0x00000534)]*/ цел skippedEntity(ref шим* strName);
}

// IVBSAXLocator interface
interface IVBSAXLocator : IDispatch {
  mixin(ууид("796e7ac5-5aa2-4eff-acad-3faaf01a3288"));
  // Get the column число where the текущ document событие ends.
  /*[ид(0x00000521)]*/ цел get_columnNumber(out цел nColumn);
  // Get the line число where the текущ document событие ends.
  /*[ид(0x00000522)]*/ цел get_linconstber(out цел nLine);
  // Get the public identifier for the текущ document событие.
  /*[ид(0x00000523)]*/ цел get_publicId(out шим* strPublicId);
  // Get the system identifier for the текущ document событие.
  /*[ид(0x00000524)]*/ цел get_systemId(out шим* strSystemId);
}

// IVBSAXAttributes interface
interface IVBSAXAttributes : IDispatch {
  mixin(ууид("10dc0586-132b-4cac-8bb3-db00ac8b7ee0"));
  // Get the число of атрибуты in the список.
  /*[ид(0x00000540)]*/ цел get_length(out цел nLength);
  // Look up an attribute's Namespace URI by индекс.
  /*[ид(0x00000541)]*/ цел getURI(цел nIndex, out шим* strURI);
  // Look up an attribute's local имя by индекс.
  /*[ид(0x00000542)]*/ цел getLocalName(цел nIndex, out шим* strLocalName);
  // Look up an attribute's XML 1.0 qualified имя by индекс.
  /*[ид(0x00000543)]*/ цел getQName(цел nIndex, out шим* strQName);
  // Look up the индекс of an attribute by Namespace имя.
  /*[ид(0x00000544)]*/ цел getIndexFromName(шим* strURI, шим* strLocalName, out цел nIndex);
  // Look up the индекс of an attribute by XML 1.0 qualified имя.
  /*[ид(0x00000545)]*/ цел getIndexFromQName(шим* strQName, out цел nIndex);
  // Look up an attribute's тип by индекс.
  /*[ид(0x00000546)]*/ цел getType(цел nIndex, out шим* strType);
  // Look up an attribute's тип by Namespace имя.
  /*[ид(0x00000547)]*/ цел getTypeFromName(шим* strURI, шим* strLocalName, out шим* strType);
  // Look up an attribute's тип by XML 1.0 qualified имя.
  /*[ид(0x00000548)]*/ цел getTypeFromQName(шим* strQName, out шим* strType);
  // Look up an attribute's значение by индекс.
  /*[ид(0x00000549)]*/ цел дайЗначение(цел nIndex, out шим* strValue);
  // Look up an attribute's значение by Namespace имя.
  /*[ид(0x0000054A)]*/ цел getValueFromName(шим* strURI, шим* strLocalName, out шим* strValue);
  // Look up an attribute's значение by XML 1.0 qualified имя.
  /*[ид(0x0000054B)]*/ цел getValueFromQName(шим* strQName, out шим* strValue);
}

// IVBSAXDTDHandler interface
interface IVBSAXDTDHandler : IDispatch {
  mixin(ууид("24fb3297-302d-4620-ba39-3a732d850558"));
  // Receive notification of a notation declaration событие.
  /*[ид(0x00000537)]*/ цел notationDecl(ref шим* strName, ref шим* strPublicId, ref шим* strSystemId);
  // Receive notification of an unparsed entity declaration событие.
  /*[ид(0x00000538)]*/ цел unparsedEntityDecl(ref шим* strName, ref шим* strPublicId, ref шим* strSystemId, ref шим* strNotationName);
}

// IVBSAXErrorHandler interface
interface IVBSAXErrorHandler : IDispatch {
  mixin(ууид("d963d3fe-173c-4862-9095-b92f66995f52"));
  // Receive notification of a recoverable ошибка.
  /*[ид(0x0000053B)]*/ цел ошибка(IVBSAXLocator oLocator, ref шим* strErrorMessage, цел nErrorCode);
  // Receive notification of a non-recoverable ошибка.
  /*[ид(0x0000053C)]*/ цел fatalError(IVBSAXLocator oLocator, ref шим* strErrorMessage, цел nErrorCode);
  // Receive notification of an ignorable warning.
  /*[ид(0x0000053D)]*/ цел ignorableWarning(IVBSAXLocator oLocator, ref шим* strErrorMessage, цел nErrorCode);
}

// IVBSAXXMLFilter interface
interface IVBSAXXMLFilter : IDispatch {
  mixin(ууид("1299eb1b-5b88-433e-82de-82ca75ad4e04"));
  // Set or дай the родитель reader
  /*[ид(0x0000051D)]*/ цел get_parent(out IVBSAXXMLReader oReader);
  // Set or дай the родитель reader
  /*[ид(0x0000051D)]*/ цел putref_parent(IVBSAXXMLReader oReader);
}

// IVBSAXLexicalHandler interface
interface IVBSAXLexicalHandler : IDispatch {
  mixin(ууид("032aac35-8c0e-4d9d-979f-e3b702935576"));
  // Report the start of DTD declarations, if any.
  /*[ид(0x0000054E)]*/ цел startDTD(ref шим* strName, ref шим* strPublicId, ref шим* strSystemId);
  // Report the end of DTD declarations.
  /*[ид(0x0000054F)]*/ цел endDTD();
  // Report the beginning of some internal and external XML entities.
  /*[ид(0x00000550)]*/ цел startEntity(ref шим* strName);
  // Report the end of an entity.
  /*[ид(0x00000551)]*/ цел endEntity(ref шим* strName);
  // Report the start of a CDATA section.
  /*[ид(0x00000552)]*/ цел startCDATA();
  // Report the end of a CDATA section.
  /*[ид(0x00000553)]*/ цел endCDATA();
  // Report an XML коммент anywhere in the document.
  /*[ид(0x00000554)]*/ цел коммент(ref шим* strChars);
}

// IVBSAXDeclHandler interface
interface IVBSAXDeclHandler : IDispatch {
  mixin(ууид("e8917260-7579-4be1-b5dd-7afbfa6f077b"));
  // Report an element тип declaration.
  /*[ид(0x00000557)]*/ цел elementDecl(ref шим* strName, ref шим* strModel);
  // Report an attribute тип declaration.
  /*[ид(0x00000558)]*/ цел attributeDecl(ref шим* strElementName, ref шим* strAttributeName, ref шим* strType, ref шим* strValueDefault, ref шим* strValue);
  // Report an internal entity declaration.
  /*[ид(0x00000559)]*/ цел internalEntityDecl(ref шим* strName, ref шим* strValue);
  // Report a parsed external entity declaration.
  /*[ид(0x0000055A)]*/ цел externalEntityDecl(ref шим* strName, ref шим* strPublicId, ref шим* strSystemId);
}

// IMXWriter interface
interface IMXWriter : IDispatch {
  mixin(ууид("4d7ff4ba-1565-4ea8-94e1-6e724a46f98d"));
  // Set or дай the вывод.
  /*[ид(0x00000569)]*/ цел put_output(VARIANT varDestination);
  // Set or дай the вывод.
  /*[ид(0x00000569)]*/ цел get_output(out VARIANT varDestination);
  // Set or дай the вывод кодировка.
  /*[ид(0x0000056B)]*/ цел put_encoding(шим* strEncoding);
  // Set or дай the вывод кодировка.
  /*[ид(0x0000056B)]*/ цел get_encoding(out шим* strEncoding);
  // Determine whether or not to пиши the байт order mark
  /*[ид(0x0000056C)]*/ цел put_byteOrderMark(крат fWriteByteOrderMark);
  // Determine whether or not to пиши the байт order mark
  /*[ид(0x0000056C)]*/ цел get_byteOrderMark(out крат fWriteByteOrderMark);
  // Enable or disable auto indent mode.
  /*[ид(0x0000056D)]*/ цел put_indent(крат fIndentMode);
  // Enable or disable auto indent mode.
  /*[ид(0x0000056D)]*/ цел get_indent(out крат fIndentMode);
  // Set or дай the standalone document declaration.
  /*[ид(0x0000056E)]*/ цел put_standalone(крат fValue);
  // Set or дай the standalone document declaration.
  /*[ид(0x0000056E)]*/ цел get_standalone(out крат fValue);
  // Determine whether or not to omit the XML declaration.
  /*[ид(0x0000056F)]*/ цел put_omitXMLDeclaration(крат fValue);
  // Determine whether or not to omit the XML declaration.
  /*[ид(0x0000056F)]*/ цел get_omitXMLDeclaration(out крат fValue);
  // Set or дай the xml version info.
  /*[ид(0x00000570)]*/ цел put_version(шим* strVersion);
  // Set or дай the xml version info.
  /*[ид(0x00000570)]*/ цел get_version(out шим* strVersion);
  // When enabled, the writer no longer escapes out its ввод when writing it out.
  /*[ид(0x00000571)]*/ цел put_disableOutputEscaping(крат fValue);
  // When enabled, the writer no longer escapes out its ввод when writing it out.
  /*[ид(0x00000571)]*/ цел get_disableOutputEscaping(out крат fValue);
  // Flushes all writer buffers forcing the writer to пиши to the underlying вывод object
  /*[ид(0x00000572)]*/ цел слей();
}

// IMXAttributes interface
interface IMXAttributes : IDispatch {
  mixin(ууид("f10d27cc-3ec0-415c-8ed8-77ab1c5e7262"));
  // Add an attribute to the end of the список.
  /*[ид(0x0000055D)]*/ цел addAttribute(шим* strURI, шим* strLocalName, шим* strQName, шим* strType, шим* strValue);
  // Add an attribute, whose значение is equal to the indexed attribute in the ввод атрибуты object, to the end of the список.
  /*[ид(0x00000567)]*/ цел addAttributeFromIndex(VARIANT varAtts, цел nIndex);
  // Clear the attribute список for reuse.
  /*[ид(0x0000055E)]*/ цел сотри();
  // Remove an attribute from the список.
  /*[ид(0x0000055F)]*/ цел removeAttribute(цел nIndex);
  // Set an attribute in the список.
  /*[ид(0x00000560)]*/ цел setAttribute(цел nIndex, шим* strURI, шим* strLocalName, шим* strQName, шим* strType, шим* strValue);
  // Copy an entire Attributes object.
  /*[ид(0x00000561)]*/ цел setAttributes(VARIANT varAtts);
  // Set the local имя of a specific attribute.
  /*[ид(0x00000562)]*/ цел setLocalName(цел nIndex, шим* strLocalName);
  // Set the qualified имя of a specific attribute.
  /*[ид(0x00000563)]*/ цел setQName(цел nIndex, шим* strQName);
  // Set the тип of a specific attribute.
  /*[ид(0x00000564)]*/ цел setType(цел nIndex, шим* strType);
  // Set the Namespace URI of a specific attribute.
  /*[ид(0x00000565)]*/ цел setURI(цел nIndex, шим* strURI);
  // Set the значение of a specific attribute.
  /*[ид(0x00000566)]*/ цел setValue(цел nIndex, шим* strValue);
}

// IMXReaderControl interface
interface IMXReaderControl : IDispatch {
  mixin(ууид("808f4e35-8d5a-4fbe-8466-33a41279ed30"));
  // Abort the reader
  /*[ид(0x00000576)]*/ цел abort();
  // Resume the reader
  /*[ид(0x00000577)]*/ цел resume();
  // Suspend the reader
  /*[ид(0x00000578)]*/ цел suspend();
}

// IMXSchemaDeclHandler interface
interface IMXSchemaDeclHandler : IDispatch {
  mixin(ууид("fa4bb38c-faf9-4cca-9302-d1dd0fe520db"));
  // Access schema element declaration
  /*[ид(0x0000057B)]*/ цел schemaElementDecl(ISchemaElement oSchemaElement);
}

// XML Schema Element
interface ISchemaElement : ISchemaParticle {
  mixin(ууид("50ea08b7-dd1b-4664-9a50-c2f40f4bd79a"));
  /*[ид(0x000005C4)]*/ цел get_type(out ISchemaType тип);
  /*[ид(0x000005BD)]*/ цел get_scope(out ISchemaComplexType scopeParam);
  /*[ид(0x00000597)]*/ цел get_defaultValue(out шим* дефолтнЗнач);
  /*[ид(0x0000059E)]*/ цел get_fixedValue(out шим* fixedValue);
  /*[ид(0x000005A3)]*/ цел get_isNillable(out крат nillable);
  /*[ид(0x000005A1)]*/ цел get_identityConstraints(out ISchemaItemCollection constraints);
  /*[ид(0x000005BF)]*/ цел get_substitutionGroup(out ISchemaElement element);
  /*[ид(0x000005C0)]*/ цел get_substitutionGroupExclusions(out SCHEMADERIVATIONMETHOD exclusions);
  /*[ид(0x00000599)]*/ цел get_disallowedSubstitutions(out SCHEMADERIVATIONMETHOD disallowed);
  /*[ид(0x000005A2)]*/ цел get_isAbstract(out крат abstractParam);
  /*[ид(0x000005A4)]*/ цел get_isReference(out крат reference);
}

// XML Schema Particle
interface ISchemaParticle : ISchemaItem {
  mixin(ууид("50ea08b5-dd1b-4664-9a50-c2f40f4bd79a"));
  /*[ид(0x000005AF)]*/ цел get_minOccurs(out VARIANT minOccurs);
  /*[ид(0x000005AB)]*/ цел get_maxOccurs(out VARIANT maxOccurs);
}

// XML Schema Item
interface ISchemaItem : IDispatch {
  mixin(ууид("50ea08b3-dd1b-4664-9a50-c2f40f4bd79a"));
  /*[ид(0x000005B1)]*/ цел get_name(out шим* имя);
  /*[ид(0x000005B3)]*/ цел get_namespaceURI(out шим* namespaceURI);
  /*[ид(0x000005BB)]*/ цел get_schema(out ISchema schema);
  /*[ид(0x000005A0)]*/ цел get_id(out шим* ид);
  /*[ид(0x000005A6)]*/ цел get_itemType(out SOMITEMTYPE itemType);
  /*[ид(0x000005C6)]*/ цел get_unhandledAttributes(out IVBSAXAttributes атрибуты);
  /*[ид(0x000005CB)]*/ цел writeAnnotation(IUnknown annotationSink, out крат isWritten);
}

// XML Schema
interface ISchema : ISchemaItem {
  mixin(ууид("50ea08b4-dd1b-4664-9a50-c2f40f4bd79a"));
  /*[ид(0x000005C2)]*/ цел get_targetNamespace(out шим* targetNamespace);
  /*[ид(0x000005C9)]*/ цел get_version(out шим* versionParam);
  /*[ид(0x000005C5)]*/ цел get_types(out ISchemaItemCollection типы);
  /*[ид(0x0000059A)]*/ цел get_elements(out ISchemaItemCollection elements);
  /*[ид(0x00000593)]*/ цел get_attributes(out ISchemaItemCollection атрибуты);
  /*[ид(0x00000592)]*/ цел get_attributeGroups(out ISchemaItemCollection attributeGroups);
  /*[ид(0x000005B0)]*/ цел get_modelGroups(out ISchemaItemCollection modelGroups);
  /*[ид(0x000005B4)]*/ цел get_notations(out ISchemaItemCollection notations);
  /*[ид(0x000005BC)]*/ цел get_schemaLocations(out ISchemaStringCollection schemaLocations);
}

// XML Schema Item Подборка
interface ISchemaItemCollection : IDispatch {
  mixin(ууид("50ea08b2-dd1b-4664-9a50-c2f40f4bd79a"));
  /*[ид(0x00000000)]*/ цел get_item(цел индекс, out ISchemaItem элт);
  /*[ид(0x0000058F)]*/ цел itemByName(шим* имя, out ISchemaItem элт);
  /*[ид(0x00000590)]*/ цел itemByQName(шим* имя, шим* namespaceURI, out ISchemaItem элт);
  /*[ид(0x000005A7)]*/ цел get_length(out цел length);
  /*[ид(0xFFFFFFFC)]*/ цел get__NewEnum(out IUnknown ppUnk);
}

// XML Schema String Подборка
interface ISchemaStringCollection : IDispatch {
  mixin(ууид("50ea08b1-dd1b-4664-9a50-c2f40f4bd79a"));
  /*[ид(0x00000000)]*/ цел get_item(цел индекс, out шим* bstr);
  /*[ид(0x000005A7)]*/ цел get_length(out цел length);
  /*[ид(0xFFFFFFFC)]*/ цел get__NewEnum(out IUnknown ppUnk);
}

// XML Schema Тип
interface ISchemaType : ISchemaItem {
  mixin(ууид("50ea08b8-dd1b-4664-9a50-c2f40f4bd79a"));
  /*[ид(0x00000594)]*/ цел get_baseTypes(out ISchemaItemCollection baseTypes);
  /*[ид(0x0000059D)]*/ цел get_final(out SCHEMADERIVATIONMETHOD finalParam);
  /*[ид(0x000005C8)]*/ цел get_variety(out SCHEMATYPEVARIETY variety);
  /*[ид(0x00000598)]*/ цел get_derivedBy(out SCHEMADERIVATIONMETHOD derivedBy);
  /*[ид(0x000005A5)]*/ цел isValid(шим* данные, out крат valid);
  /*[ид(0x000005AC)]*/ цел get_minExclusive(out шим* minExclusive);
  /*[ид(0x000005AD)]*/ цел get_minInclusive(out шим* minInclusive);
  /*[ид(0x000005A8)]*/ цел get_maxExclusive(out шим* maxExclusive);
  /*[ид(0x000005A9)]*/ цел get_maxInclusive(out шим* maxInclusive);
  /*[ид(0x000005C3)]*/ цел get_totalDigits(out VARIANT totalDigits);
  /*[ид(0x0000059F)]*/ цел get_fractionDigits(out VARIANT fractionDigits);
  /*[ид(0x000005A7)]*/ цел get_length(out VARIANT length);
  /*[ид(0x000005AE)]*/ цел get_minLength(out VARIANT minLength);
  /*[ид(0x000005AA)]*/ цел get_maxLength(out VARIANT maxLength);
  /*[ид(0x0000059B)]*/ цел get_consteration(out ISchemaStringCollection consteration);
  /*[ид(0x000005CA)]*/ цел get_whitespace(out SCHEMAWHITESPACE whitespace);
  /*[ид(0x000005B6)]*/ цел get_patterns(out ISchemaStringCollection patterns);
}

// XML Schema Complex Тип
interface ISchemaComplexType : ISchemaType {
  mixin(ууид("50ea08b9-dd1b-4664-9a50-c2f40f4bd79a"));
  /*[ид(0x000005A2)]*/ цел get_isAbstract(out крат abstractParam);
  /*[ид(0x00000591)]*/ цел get_anyAttribute(out ISchemaAny anyAttribute);
  /*[ид(0x00000593)]*/ цел get_attributes(out ISchemaItemCollection атрибуты);
  /*[ид(0x00000596)]*/ цел get_contentType(out SCHEMACONTENTTYPE contentType);
  /*[ид(0x00000595)]*/ цел get_contentModel(out ISchemaModelGroup contentModel);
  /*[ид(0x000005B8)]*/ цел get_prohibitedSubstitutions(out SCHEMADERIVATIONMETHOD prohibited);
}

// XML Schema Any
interface ISchemaAny : ISchemaParticle {
  mixin(ууид("50ea08bc-dd1b-4664-9a50-c2f40f4bd79a"));
  /*[ид(0x000005B2)]*/ цел get_namespaces(out ISchemaStringCollection namespaces);
  /*[ид(0x000005B7)]*/ цел get_processContents(out SCHEMAPROCESSCONTENTS processContents);
}

// XML Schema Тип
interface ISchemaModelGroup : ISchemaParticle {
  mixin(ууид("50ea08bb-dd1b-4664-9a50-c2f40f4bd79a"));
  /*[ид(0x000005B5)]*/ цел get_particles(out ISchemaItemCollection particles);
}

// IMXXMLFilter interface
interface IMXXMLFilter : IDispatch {
  mixin(ууид("c90352f7-643c-4fbc-bb23-e996eb2d51fd"));
  /*[ид(0x0000058F)]*/ цел getFeature(шим* strName, out крат fValue);
  /*[ид(0x00000591)]*/ цел putFeature(шим* strName, крат fValue);
  /*[ид(0x00000590)]*/ цел getProperty(шим* strName, out VARIANT varValue);
  /*[ид(0x00000592)]*/ цел putProperty(шим* strName, VARIANT varValue);
  /*[ид(0x0000058D)]*/ цел get_entityResolver(out IUnknown oResolver);
  /*[ид(0x0000058D)]*/ цел putref_entityResolver(IUnknown oResolver);
  /*[ид(0x0000058B)]*/ цел get_contentHandler(out IUnknown oHandler);
  /*[ид(0x0000058B)]*/ цел putref_contentHandler(IUnknown oHandler);
  /*[ид(0x0000058C)]*/ цел get_dtdHandler(out IUnknown oHandler);
  /*[ид(0x0000058C)]*/ цел putref_dtdHandler(IUnknown oHandler);
  /*[ид(0x0000058E)]*/ цел get_errorHandler(out IUnknown oHandler);
  /*[ид(0x0000058E)]*/ цел putref_errorHandler(IUnknown oHandler);
}

// XML Schemas Подборка 2
interface IXMLDOMSchemaCollection2 : IXMLDOMSchemaCollection {
  mixin(ууид("50ea08b0-dd1b-4664-9a50-c2f40f4bd79a"));
  /*[ид(0x0000058B)]*/ цел validate();
  /*[ид(0x0000058C)]*/ цел put_validateOnLoad(крат validateOnLoad);
  /*[ид(0x0000058C)]*/ цел get_validateOnLoad(out крат validateOnLoad);
  /*[ид(0x0000058D)]*/ цел getSchema(шим* namespaceURI, out ISchema schema);
  /*[ид(0x0000058E)]*/ цел getDeclaration(IXMLDOMNode node, out ISchemaItem элт);
}

// XML Schema Attribute
interface ISchemaAttribute : ISchemaItem {
  mixin(ууид("50ea08b6-dd1b-4664-9a50-c2f40f4bd79a"));
  /*[ид(0x000005C4)]*/ цел get_type(out ISchemaType тип);
  /*[ид(0x000005BD)]*/ цел get_scope(out ISchemaComplexType scopeParam);
  /*[ид(0x00000597)]*/ цел get_defaultValue(out шим* дефолтнЗнач);
  /*[ид(0x0000059E)]*/ цел get_fixedValue(out шим* fixedValue);
  /*[ид(0x000005C7)]*/ цел get_use(out SCHEMAUSE use);
  /*[ид(0x000005A4)]*/ цел get_isReference(out крат reference);
}

// XML Schema Attribute Group
interface ISchemaAttributeGroup : ISchemaItem {
  mixin(ууид("50ea08ba-dd1b-4664-9a50-c2f40f4bd79a"));
  /*[ид(0x00000591)]*/ цел get_anyAttribute(out ISchemaAny anyAttribute);
  /*[ид(0x00000593)]*/ цел get_attributes(out ISchemaItemCollection атрибуты);
}

// XML Schema Any
interface ISchemaIdentityConstraint : ISchemaItem {
  mixin(ууид("50ea08bd-dd1b-4664-9a50-c2f40f4bd79a"));
  /*[ид(0x000005BE)]*/ цел get_selector(out шим* selector);
  /*[ид(0x0000059C)]*/ цел get_fields(out ISchemaStringCollection поля);
  /*[ид(0x000005BA)]*/ цел get_referencedKey(out ISchemaIdentityConstraint ключ);
}

// XML Schema Notation
interface ISchemaNotation : ISchemaItem {
  mixin(ууид("50ea08be-dd1b-4664-9a50-c2f40f4bd79a"));
  /*[ид(0x000005C1)]*/ цел get_systemIdentifier(out шим* uri);
  /*[ид(0x000005B9)]*/ цел get_publicIdentifier(out шим* uri);
}

interface IXMLDOMSelection : IXMLDOMNodeList {
  mixin(ууид("aa634fc7-5888-44a7-a257-3a47150d3a0e"));
  // selection expression
  /*[ид(0x00000051)]*/ цел get_expr(out шим* expression);
  // selection expression
  /*[ид(0x00000051)]*/ цел put_expr(шим* expression);
  // nodes to apply selection expression to
  /*[ид(0x00000052)]*/ цел get_context(out IXMLDOMNode ppNode);
  // nodes to apply selection expression to
  /*[ид(0x00000052)]*/ цел putref_context(IXMLDOMNode ppNode);
  // gets the следщ node without advancing the список позиция
  /*[ид(0x00000053)]*/ цел peekNode(out IXMLDOMNode ppNode);
  // checks to see if the node matches the pattern
  /*[ид(0x00000054)]*/ цел matches(IXMLDOMNode pNode, out IXMLDOMNode ppNode);
  // removes the следщ node
  /*[ид(0x00000055)]*/ цел removeNext(out IXMLDOMNode ppNode);
  // removes all the nodes that match the selection
  /*[ид(0x00000056)]*/ цел removeAll();
  // clone this object with the same позиция and context
  /*[ид(0x00000057)]*/ цел clone(out IXMLDOMSelection ppNode);
  // дай the значение of the named property
  /*[ид(0x00000058)]*/ цел getProperty(шим* имя, out VARIANT значение);
  // уст the значение of the named property
  /*[ид(0x00000059)]*/ цел setProperty(шим* имя, VARIANT значение);
}

interface XMLDOMDocumentEvents : IDispatch {
  mixin(ууид("3efaa427-272f-11d2-836f-0000f87a7782"));
  /+/*[ид(0x000000C6)]*/ цел ondataavailable();+/
  /+/*[ид(0xFFFFFD9F)]*/ цел onreadystatechange();+/
}

// DSO УпрЭлт
interface IDSOControl : IDispatch {
  mixin(ууид("310afa62-0575-11d2-9ca9-0060b0ec3d39"));
  /*[ид(0x00010001)]*/ цел get_XMLDocument(out IXMLDOMDocument ppDoc);
  /*[ид(0x00010001)]*/ цел put_XMLDocument(IXMLDOMDocument ppDoc);
  /*[ид(0x00010002)]*/ цел get_JavaDSOCompatible(out цел fJavaDSOCompatible);
  /*[ид(0x00010002)]*/ цел put_JavaDSOCompatible(цел fJavaDSOCompatible);
  /*[ид(0xFFFFFDF3)]*/ цел get_readyState(out цел state);
}

// IXMLHTTPRequest Интерфейс
interface IXMLHTTPRequest : IDispatch {
  mixin(ууид("ed8c108d-4349-11d2-91a4-00c04f7969e8"));
  // Open HTTP connection
  /*[ид(0x00000001)]*/ цел open(шим* bstrMethod, шим* bstrUrl, VARIANT varAsync, VARIANT bstrUser, VARIANT bstrPassword);
  // Add HTTP request header
  /*[ид(0x00000002)]*/ цел setRequestHeader(шим* bstrHeader, шим* bstrValue);
  // Get HTTP response header
  /*[ид(0x00000003)]*/ цел getResponseHeader(шим* bstrHeader, out шим* pbstrValue);
  // Get all HTTP response headers
  /*[ид(0x00000004)]*/ цел getAllResponseHeaders(out шим* pbstrHeaders);
  // Send HTTP request
  /*[ид(0x00000005)]*/ цел шли(VARIANT varBody);
  // Abort HTTP request
  /*[ид(0x00000006)]*/ цел abort();
  // Get HTTP status code
  /*[ид(0x00000007)]*/ цел get_status(out цел plStatus);
  // Get HTTP status text
  /*[ид(0x00000008)]*/ цел get_statusText(out шим* pbstrStatus);
  // Get response body
  /*[ид(0x00000009)]*/ цел get_responseXML(out IDispatch ppBody);
  // Get response body
  /*[ид(0x0000000A)]*/ цел get_responseText(out шим* pbstrBody);
  // Get response body
  /*[ид(0x0000000B)]*/ цел get_responseBody(out VARIANT pvarBody);
  // Get response body
  /*[ид(0x0000000C)]*/ цел get_responseStream(out VARIANT pvarBody);
  // Get ready state
  /*[ид(0x0000000D)]*/ цел get_readyState(out цел plState);
  // Register a complete событие handler
  /*[ид(0x0000000E)]*/ цел put_onreadystatechange(IDispatch значение);
}

// IServerXMLHTTPRequest Интерфейс
interface IServerXMLHTTPRequest : IXMLHTTPRequest {
  mixin(ууид("2e9196bf-13ba-4dd4-91ca-6c571f281495"));
  // Specify таймаут settings (in миллисекунды)
  /*[ид(0x0000000F)]*/ цел setTimeouts(цел resolveTimeout, цел connectTimeout, цел sendTimeout, цел receiveTimeout);
  // Wait for asynchronous шли to complete, with optional таймаут (in секунды)
  /*[ид(0x00000010)]*/ цел waitForResponse(VARIANT timeoutInSeconds, out крат isSuccessful);
  // Get an option значение
  /*[ид(0x00000011)]*/ цел getOption(SERVERXMLHTTP_OPTION option, out VARIANT значение);
  // Set an option значение
  /*[ид(0x00000012)]*/ цел setOption(SERVERXMLHTTP_OPTION option, VARIANT значение);
}

// IServerXMLHTTPRequest2 Интерфейс
interface IServerXMLHTTPRequest2 : IServerXMLHTTPRequest {
  mixin(ууид("2e01311b-c322-4b0a-bd77-b90cfdc8dce7"));
  // Specify proxy configuration
  /*[ид(0x00000013)]*/ цел setProxy(SXH_PROXY_SETTING proxySetting, VARIANT varProxyServer, VARIANT varBypassList);
  // Specify proxy authentication credentials
  /*[ид(0x00000014)]*/ цел setProxyCredentials(шим* bstrUserName, шим* bstrPassword);
}

// IMXNamespacePrefixes interface
interface IMXNamespacePrefixes : IDispatch {
  mixin(ууид("c90352f4-643c-4fbc-bb23-e996eb2d51fd"));
  /*[ид(0x00000000)]*/ цел get_item(цел индекс, out шим* prefix);
  /*[ид(0x00000588)]*/ цел get_length(out цел length);
  /*[ид(0xFFFFFFFC)]*/ цел get__NewEnum(out IUnknown ppUnk);
}

// IVBMXNamespaceManager interface
interface IVBMXNamespaceManager : IDispatch {
  mixin(ууид("c90352f5-643c-4fbc-bb23-e996eb2d51fd"));
  /*[ид(0x0000057E)]*/ цел put_allowOverride(крат fOverride);
  /*[ид(0x0000057E)]*/ цел get_allowOverride(out крат fOverride);
  /*[ид(0x0000057F)]*/ цел сбрось();
  /*[ид(0x00000580)]*/ цел pushContext();
  /*[ид(0x00000581)]*/ цел pushNodeContext(IXMLDOMNode contextNode, крат fDeep);
  /*[ид(0x00000582)]*/ цел popContext();
  /*[ид(0x00000583)]*/ цел declarePrefix(шим* prefix, шим* namespaceURI);
  /*[ид(0x00000584)]*/ цел getDeclaredPrefixes(out IMXNamespacePrefixes prefixes);
  /*[ид(0x00000585)]*/ цел getPrefixes(шим* namespaceURI, out IMXNamespacePrefixes prefixes);
  /*[ид(0x00000586)]*/ цел getURI(шим* prefix, out VARIANT uri);
  /*[ид(0x00000587)]*/ цел getURIFromNode(шим* strPrefix, IXMLDOMNode contextNode, out VARIANT uri);
}

// IMXNamespaceManager interface
interface IMXNamespaceManager : IUnknown {
  mixin(ууид("c90352f6-643c-4fbc-bb23-e996eb2d51fd"));
  /*[ид(0x60010000)]*/ цел putAllowOverride(крат fOverride);
  /*[ид(0x60010001)]*/ цел getAllowOverride(out крат fOverride);
  /*[ид(0x60010002)]*/ цел сбрось();
  /*[ид(0x60010003)]*/ цел pushContext();
  /*[ид(0x60010004)]*/ цел pushNodeContext(IXMLDOMNode contextNode, крат fDeep);
  /*[ид(0x60010005)]*/ цел popContext();
  /*[ид(0x60010006)]*/ цел declarePrefix(in шим* prefix, in шим* namespaceURI);
  /*[ид(0x60010007)]*/ цел getDeclaredPrefix(цел nIndex, in шим* pwchPrefix, ref цел pcchPrefix);
  /*[ид(0x60010008)]*/ цел getPrefix(in шим* pwszNamespaceURI, цел nIndex, шим* pwchPrefix, ref цел pcchPrefix);
  /*[ид(0x60010009)]*/ цел getURI(in шим* pwchPrefix, IXMLDOMNode pContextNode, шим* pwchUri, ref цел pcchUri);
}

// CoClasses

// W3C-DOM XML Document (Apartment)
abstract final class DOMDocument {
  mixin(ууид("f6d90f11-9c73-11d3-b32e-00c04f990bb4"));
  mixin Интерфейсы!(IXMLDOMDocument2);
}

// W3C-DOM XML Document (Apartment)
abstract final class DOMDocument26 {
  mixin(ууид("f5078f1b-c551-11d3-89b9-0000f81fe221"));
  mixin Интерфейсы!(IXMLDOMDocument2);
}

// W3C-DOM XML Document (Apartment)
abstract final class DOMDocument30 {
  mixin(ууид("f5078f32-c551-11d3-89b9-0000f81fe221"));
  mixin Интерфейсы!(IXMLDOMDocument2);
}

// W3C-DOM XML Document (Apartment)
abstract final class DOMDocument40 {
  mixin(ууид("88d969c0-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IXMLDOMDocument2);
}

// W3C-DOM XML Document 6.0 (Apartment)
abstract final class DOMDocument60 {
  mixin(ууид("88d96a05-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IXMLDOMDocument3);
}

// W3C-DOM XML Document (Free threaded)
abstract final class FreeThreadedDOMDocument {
  mixin(ууид("f6d90f12-9c73-11d3-b32e-00c04f990bb4"));
  mixin Интерфейсы!(IXMLDOMDocument2);
}

// W3C-DOM XML Document (Free threaded)
abstract final class FreeThreadedDOMDocument26 {
  mixin(ууид("f5078f1c-c551-11d3-89b9-0000f81fe221"));
  mixin Интерфейсы!(IXMLDOMDocument2);
}

// W3C-DOM XML Document (Free threaded)
abstract final class FreeThreadedDOMDocument30 {
  mixin(ууид("f5078f33-c551-11d3-89b9-0000f81fe221"));
  mixin Интерфейсы!(IXMLDOMDocument2);
}

// W3C-DOM XML Document (Free threaded)
abstract final class FreeThreadedDOMDocument40 {
  mixin(ууид("88d969c1-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IXMLDOMDocument2);
}

// W3C-DOM XML Document 6.0 (Free threaded)
abstract final class FreeThreadedDOMDocument60 {
  mixin(ууид("88d96a06-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IXMLDOMDocument3);
}

// XML Schema Cache
abstract final class XMLSchemaCache {
  mixin(ууид("373984c9-b845-449b-91e7-45ac83036ade"));
  mixin Интерфейсы!(IXMLDOMSchemaCollection);
}

// XML Schema Cache 2.6
abstract final class XMLSchemaCache26 {
  mixin(ууид("f5078f1d-c551-11d3-89b9-0000f81fe221"));
  mixin Интерфейсы!(IXMLDOMSchemaCollection);
}

// XML Schema Cache 3.0
abstract final class XMLSchemaCache30 {
  mixin(ууид("f5078f34-c551-11d3-89b9-0000f81fe221"));
  mixin Интерфейсы!(IXMLDOMSchemaCollection);
}

// XML Schema Cache 4.0
abstract final class XMLSchemaCache40 {
  mixin(ууид("88d969c2-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IXMLDOMSchemaCollection2);
}

// XML Schema Cache 6.0
abstract final class XMLSchemaCache60 {
  mixin(ууид("88d96a07-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IXMLDOMSchemaCollection2);
}

// Compiled XSL Stylesheet Cache
abstract final class XSLTemplate {
  mixin(ууид("2933bf94-7b36-11d2-b20e-00c04f983e60"));
  mixin Интерфейсы!(IXSLTemplate);
}

// Compiled XSL Stylesheet Cache 2.6
abstract final class XSLTemplate26 {
  mixin(ууид("f5078f21-c551-11d3-89b9-0000f81fe221"));
  mixin Интерфейсы!(IXSLTemplate);
}

// Compiled XSL Stylesheet Cache 3.0
abstract final class XSLTemplate30 {
  mixin(ууид("f5078f36-c551-11d3-89b9-0000f81fe221"));
  mixin Интерфейсы!(IXSLTemplate);
}

// Compiled XSL Stylesheet Cache 4.0
abstract final class XSLTemplate40 {
  mixin(ууид("88d969c3-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IXSLTemplate);
}

// XSL Stylesheet Cache 6.0
abstract final class XSLTemplate60 {
  mixin(ууид("88d96a08-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IXSLTemplate);
}

// XML Data Source Объект
abstract final class DSOControl {
  mixin(ууид("f6d90f14-9c73-11d3-b32e-00c04f990bb4"));
  mixin Интерфейсы!(IDSOControl);
}

// XML Data Source Объект
abstract final class DSOControl26 {
  mixin(ууид("f5078f1f-c551-11d3-89b9-0000f81fe221"));
  mixin Интерфейсы!(IDSOControl);
}

// XML Data Source Объект
abstract final class DSOControl30 {
  mixin(ууид("f5078f39-c551-11d3-89b9-0000f81fe221"));
  mixin Интерфейсы!(IDSOControl);
}

// XML Data Source Объект
abstract final class DSOControl40 {
  mixin(ууид("88d969c4-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IDSOControl);
}

// XML HTTP Request class.
abstract final class XMLHTTP {
  mixin(ууид("f6d90f16-9c73-11d3-b32e-00c04f990bb4"));
  mixin Интерфейсы!(IXMLHTTPRequest);
}

// XML HTTP Request class.
abstract final class XMLHTTP26 {
  mixin(ууид("f5078f1e-c551-11d3-89b9-0000f81fe221"));
  mixin Интерфейсы!(IXMLHTTPRequest);
}

// XML HTTP Request class.
abstract final class XMLHTTP30 {
  mixin(ууид("f5078f35-c551-11d3-89b9-0000f81fe221"));
  mixin Интерфейсы!(IXMLHTTPRequest);
}

// XML HTTP Request class.
abstract final class XMLHTTP40 {
  mixin(ууид("88d969c5-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IXMLHTTPRequest);
}

// XML HTTP Request class 6.0
abstract final class XMLHTTP60 {
  mixin(ууид("88d96a0a-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IXMLHTTPRequest);
}

// Server XML HTTP Request class.
abstract final class ServerXMLHTTP {
  mixin(ууид("afba6b42-5692-48ea-8141-dc517dcf0ef1"));
  mixin Интерфейсы!(IServerXMLHTTPRequest);
}

// Server XML HTTP Request class.
abstract final class ServerXMLHTTP30 {
  mixin(ууид("afb40ffd-b609-40a3-9828-f88bbe11e4e3"));
  mixin Интерфейсы!(IServerXMLHTTPRequest);
}

// Server XML HTTP Request class.
abstract final class ServerXMLHTTP40 {
  mixin(ууид("88d969c6-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IServerXMLHTTPRequest2);
}

// Server XML HTTP Request 6.0 
abstract final class ServerXMLHTTP60 {
  mixin(ууид("88d96a0b-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IServerXMLHTTPRequest2);
}

// SAX XML Читака (version independent) coclass
abstract final class SAXXMLReader {
  mixin(ууид("079aa557-4a18-424a-8eee-e39f0a8d41b9"));
  mixin Интерфейсы!(IVBSAXXMLReader, ISAXXMLReader, IMXReaderControl);
}

// SAX XML Читака 3.0 coclass
abstract final class SAXXMLReader30 {
  mixin(ууид("3124c396-fb13-4836-a6ad-1317f1713688"));
  mixin Интерфейсы!(IVBSAXXMLReader, ISAXXMLReader, IMXReaderControl);
}

// SAX XML Читака 4.0 coclass
abstract final class SAXXMLReader40 {
  mixin(ууид("7c6e29bc-8b8b-4c3d-859e-af6cd158be0f"));
  mixin Интерфейсы!(IVBSAXXMLReader, ISAXXMLReader);
}

// SAX XML Читака 6.0
abstract final class SAXXMLReader60 {
  mixin(ууид("88d96a0c-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IVBSAXXMLReader, ISAXXMLReader);
}

// Microsoft XML Писака (version independent) coclass
abstract final class MXXMLWriter {
  mixin(ууид("fc220ad8-a72a-4ee8-926e-0b7ad152a020"));
  mixin Интерфейсы!(IMXWriter, ISAXContentHandler, ISAXErrorHandler, ISAXDTDHandler, ISAXLexicalHandler, ISAXDeclHandler, IVBSAXContentHandler, IVBSAXDeclHandler, IVBSAXDTDHandler, IVBSAXErrorHandler, IVBSAXLexicalHandler);
}

// Microsoft XML Писака 3.0 coclass
abstract final class MXXMLWriter30 {
  mixin(ууид("3d813dfe-6c91-4a4e-8f41-04346a841d9c"));
  mixin Интерфейсы!(IMXWriter, ISAXContentHandler, ISAXDeclHandler, ISAXDTDHandler, ISAXErrorHandler, ISAXLexicalHandler, IVBSAXContentHandler, IVBSAXDeclHandler, IVBSAXDTDHandler, IVBSAXErrorHandler, IVBSAXLexicalHandler);
}

// Microsoft XML Писака 4.0 coclass
abstract final class MXXMLWriter40 {
  mixin(ууид("88d969c8-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IMXWriter, ISAXContentHandler, ISAXDeclHandler, ISAXDTDHandler, ISAXErrorHandler, ISAXLexicalHandler, IVBSAXContentHandler, IVBSAXDeclHandler, IVBSAXDTDHandler, IVBSAXErrorHandler, IVBSAXLexicalHandler);
}

// Microsoft XML Писака 6.0
abstract final class MXXMLWriter60 {
  mixin(ууид("88d96a0f-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IMXWriter, ISAXContentHandler, ISAXDeclHandler, ISAXDTDHandler, ISAXErrorHandler, ISAXLexicalHandler, IVBSAXContentHandler, IVBSAXDeclHandler, IVBSAXDTDHandler, IVBSAXErrorHandler, IVBSAXLexicalHandler);
}

// Microsoft HTML Писака (version independent) coclass
abstract final class MXHTMLWriter {
  mixin(ууид("a4c23ec3-6b70-4466-9127-550077239978"));
  mixin Интерфейсы!(IMXWriter, ISAXContentHandler, ISAXErrorHandler, ISAXDTDHandler, ISAXLexicalHandler, ISAXDeclHandler, IVBSAXContentHandler, IVBSAXDeclHandler, IVBSAXDTDHandler, IVBSAXErrorHandler, IVBSAXLexicalHandler);
}

// Microsoft HTML Писака 3.0 coclass
abstract final class MXHTMLWriter30 {
  mixin(ууид("853d1540-c1a7-4aa9-a226-4d3bd301146d"));
  mixin Интерфейсы!(IMXWriter, ISAXContentHandler, ISAXDeclHandler, ISAXDTDHandler, ISAXErrorHandler, ISAXLexicalHandler, IVBSAXContentHandler, IVBSAXDeclHandler, IVBSAXDTDHandler, IVBSAXErrorHandler, IVBSAXLexicalHandler);
}

// Microsoft HTML Писака 4.0 coclass
abstract final class MXHTMLWriter40 {
  mixin(ууид("88d969c9-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IMXWriter, ISAXContentHandler, ISAXDeclHandler, ISAXDTDHandler, ISAXErrorHandler, ISAXLexicalHandler, IVBSAXContentHandler, IVBSAXDeclHandler, IVBSAXDTDHandler, IVBSAXErrorHandler, IVBSAXLexicalHandler);
}

// Microsoft HTML Писака 6.0
abstract final class MXHTMLWriter60 {
  mixin(ууид("88d96a10-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IMXWriter, ISAXContentHandler, ISAXDeclHandler, ISAXDTDHandler, ISAXErrorHandler, ISAXLexicalHandler, IVBSAXContentHandler, IVBSAXDeclHandler, IVBSAXDTDHandler, IVBSAXErrorHandler, IVBSAXLexicalHandler);
}

// SAX Attributes (version independent) coclass
abstract final class SAXAttributes {
  mixin(ууид("4dd441ad-526d-4a77-9f1b-9841ed802fb0"));
  mixin Интерфейсы!(IMXAttributes, IVBSAXAttributes, ISAXAttributes);
}

// SAX Attributes 3.0 coclass
abstract final class SAXAttributes30 {
  mixin(ууид("3e784a01-f3ae-4dc0-9354-9526b9370eba"));
  mixin Интерфейсы!(IMXAttributes, IVBSAXAttributes, ISAXAttributes);
}

// SAX Attributes 4.0 coclass
abstract final class SAXAttributes40 {
  mixin(ууид("88d969ca-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IMXAttributes, IVBSAXAttributes, ISAXAttributes);
}

// SAX Attributes 6.0
abstract final class SAXAttributes60 {
  mixin(ууид("88d96a0e-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IMXAttributes, IVBSAXAttributes, ISAXAttributes);
}

// MX Namespace Manager coclass
abstract final class MXNamespaceManager {
  mixin(ууид("88d969d5-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IVBMXNamespaceManager, IMXNamespaceManager);
}

// MX Namespace Manager 4.0 coclass
abstract final class MXNamespaceManager40 {
  mixin(ууид("88d969d6-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IVBMXNamespaceManager, IMXNamespaceManager);
}

// MX Namespace Manager 6.0
abstract final class MXNamespaceManager60 {
  mixin(ууид("88d96a11-f192-11d4-a65f-0040963251e5"));
  mixin Интерфейсы!(IVBMXNamespaceManager, IMXNamespaceManager);
}
