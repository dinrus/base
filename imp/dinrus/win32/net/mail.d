/**
 * Contains classes used to шли electronic _mail to a Simple Mail Transfer Protocol (SMTP) server for delivery.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.net.mail;

import win32.base.core,
  win32.base.string,
  win32.base.text,
  win32.base.collections,
  win32.com.core,
  win32.net.core;
debug import stdrus : скажифнс;

/**
 * The exception thrown when the SmtpClient is unable to complete a шли operation.
 */
class SmtpException : Exception {

  this(ткст сообщение) {
    super(сообщение);
  }

}

/**
 */
enum SmtpDeliveryMethod {
  Сеть,        ///
  PickupDirectory ///
}

// Wrap any exception in SmtpException.
private R invokeMethod(R = VARIANT)(IDispatch цель, ткст имя, ...) {
  try {
    return win32.com.core.invokeMethod!(R)(цель, имя, _arguments, _argptr);
  }
  catch (Exception e) {
    throw new SmtpException(e.msg);
  }
}

private R getProperty(R = VARIANT)(IDispatch цель, ткст имя, ...) {
  try {
    return win32.com.core.getProperty!(R)(цель, имя, _arguments, _argptr);
  }
  catch (Exception e) {
    throw new SmtpException(e.msg);
  }
}

private проц setProperty(IDispatch цель, ткст имя, ...) {
  try {
    win32.com.core.setProperty(цель, имя, _arguments, _argptr);
  }
  catch (Exception e) {
    throw new SmtpException(e.msg);
  }
}

/**
 * Allows applications to шли e-mail используя the Simple Mail Transfer Protocol (SMTP).
 * Примеры:
 * ---
 * ткст from = `"Ben" ben@btinternet.com`;
 * ткст to = `"John" john@gmail.com`;
 * 
 * auto сообщение = new MailMessage(from, to);
 * сообщение.subject = "Re: Last Night";
 * сообщение.bodyText = "Had a blast! Best, Ben.";
 *
 * ткст хост = "smtp.btinternet.com";
 * auto client = new SmtpClient(хост);
 *
 * auto credentials = new CredentialCache;
 * credentials.добавь(client.хост, client.порт, "Basic", userName, password);
 *
 * client.credentials = credentials;
 *
 * try {
 *   client.шли(сообщение);
 * }
 * catch (Exception e) {
 *   скажифнс("Couldn't шли the сообщение: " ~ e.вТкст());
 * }
 * ---
 */
class SmtpClient {

  private static цел defaultPort_ = 25;

  private ткст хост_;
  private цел порт_;
  private SmtpDeliveryMethod deliveryMethod_;
  private ткст pickupDirectoryLocation_;
  private ICredentialsByHost credentials_;
  private бул enableSsl_;
  private цел timeout_;

  ///
  this() {
    иниц();
  }

  ///
  this(ткст хост) {
    хост_ = хост;
    иниц();
  }

  ///
  this(ткст хост, цел порт) {
    хост_ = хост;
    порт_ = порт;
    иниц();
  }

  /// Sends an e-mail _message to an SMTP server for delivery.
  final проц шли(MailMessage сообщение) {
    auto m = coCreate!(IDispatch)("CDO.Message");
    scope(exit) tryRelease(m);

    if (сообщение.from !is null)
      setProperty(m, "From", сообщение.from.вТкст());

    if (сообщение.sender !is null)
      setProperty(m, "Sender", сообщение.sender.вТкст());

    if (сообщение.replyTo !is null)
      setProperty(m, "ReplyTo", сообщение.replyTo.вТкст());

    if (сообщение.to.счёт > 0)
      setProperty(m, "To", сообщение.to.вТкст());

    if (сообщение.cc.счёт > 0)
      setProperty(m, "Cc", сообщение.cc.вТкст());

    if (сообщение.bcc.счёт > 0)
      setProperty(m, "Bcc", сообщение.bcc.вТкст());

    if (сообщение.subject != null)
      setProperty(m, "Subject", сообщение.subject);

    if (сообщение.priority != MailPriority.Normal) {
      ткст importance;
      switch (сообщение.priority) {
        case MailPriority.Normal: 
          importance = "normal"; 
          break;
        case MailPriority.Low: 
          importance = "low"; 
          break;
        case MailPriority.High:
          importance = "high";
          break;
        default: 
          break;
      }
      if (importance != null) {
        setProperty(m, "Fields", "urn:schemas:mailheader:importance", importance);

        if (auto поля = getProperty!(IDispatch)(m, "Fields")) {
          invokeMethod(поля, "Update");
          поля.Release();
        }
      }
    }

    if (сообщение.bodyEncoding !is null) {
      if (auto bodyPart = getProperty!(IDispatch)(m, "BodyPart")) {
        setProperty(bodyPart, "Charset", сообщение.bodyEncoding.имяТела);
        bodyPart.Release();
      }
    }

    if (сообщение.headers.счёт > 0) {
      foreach (ключ; сообщение.headers) {
        setProperty(m, "Fields", "urn:schemas:mailheader:" ~ ключ, сообщение.headers[ключ]);
      }
      auto поля = getProperty!(IDispatch)(m, "Fields");
      invokeMethod(поля, "Update");
      поля.Release();
    }

    if (сообщение.isBodyHtml)
      setProperty(m, "HtmlBody", сообщение.bodyText);
    else
      setProperty(m, "TextBody", сообщение.bodyText);

    foreach (attachment; сообщение.attachments) {
      if (auto bodyPart = invokeMethod!(IDispatch)(m, "AddAttachment", attachment.имяф)) {
        scope(exit) tryRelease(bodyPart);

        switch (attachment.transferEncoding) {
          case TransferEncoding.QuotedPrintable:
            setProperty(bodyPart, "ContentTransferEncoding", "quoted-printable");
            break;
          case TransferEncoding.Base64:
            setProperty(bodyPart, "ContentTransferEncoding", "base64");
            break;
          case TransferEncoding.SevenBit:
            setProperty(bodyPart, "ContentTransferEncoding", "7bit");
            break;
          default:
        }
      }
    }

    if (auto config = getProperty!(IDispatch)(m, "Configuration")) {
      scope(exit) tryRelease(config);

      //invokeMethod(config, "Load", 2);

      if (deliveryMethod_ == SmtpDeliveryMethod.Сеть) {
        setProperty(config, "Fields", "http://schemas.microsoft.com/cdo/configuration/sendusing", 2);
        setProperty(config, "Fields", "http://schemas.microsoft.com/cdo/configuration/smtpusessl", enableSsl_);
      }
      else if (deliveryMethod_ == SmtpDeliveryMethod.PickupDirectory) {
        setProperty(config, "Fields", "http://schemas.microsoft.com/cdo/configuration/sendusing", 1);
        if (pickupDirectoryLocation_ != null)
          setProperty(config, "Fields", "http://schemas.microsoft.com/cdo/configuration/smtpserverpickupdirectory", pickupDirectoryLocation_);
      }

      if (хост_ != null)
        setProperty(config, "Fields", "http://schemas.microsoft.com/cdo/configuration/smtpserver", хост_);
      if (порт_ != 0)
        setProperty(config, "Fields", "http://schemas.microsoft.com/cdo/configuration/smtpserverport", порт_);

      if (credentials_ !is null) {
        if (auto credential = credentials_.getCredential(хост_, порт_, "Basic")) {
          setProperty(config, "Fields", "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate", 1);
          setProperty(config, "Fields", "http://schemas.microsoft.com/cdo/configuration/sendusername", credential.userName);
          setProperty(config, "Fields", "http://schemas.microsoft.com/cdo/configuration/sendpassword", credential.password);
        }
      }

      setProperty(config, "Fields", "http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout", timeout_ / 1000);

      if (auto поля = getProperty!(IDispatch)(config, "Fields")) {
        invokeMethod(поля, "Update");
        поля.Release();
      }
    }

    invokeMethod(m, "Send");

    // Sync сообщение headers so user can query them.
    static const ткст URN_SCHEMAS_MAILHEADER = "urn:schemas:mailheader:";

    if (auto поля = getProperty!(IDispatch)(m, "Fields")) {
      scope(exit) tryRelease(поля);

      if (auto fieldsconst = invokeMethod!(IEnumVARIANT)(поля, "_NewEnum")) {
        scope(exit) tryRelease(fieldsconst);

        бцел fetched;
        VARIANT поле;

        while (УДАЧНО(fieldsconst.Next(1, &поле, fetched)) && fetched == 1) {
          scope(exit) поле.сотри();

          ткст имя = getProperty!(ткст)(поле.значение!(IDispatch), "Name");
          if (имя.начинаетсяС(URN_SCHEMAS_MAILHEADER)) {
            имя = имя[URN_SCHEMAS_MAILHEADER.length .. $];
            ткст значение = getProperty!(ткст)(поле.значение!(IDispatch), "Value");

            сообщение.headers.уст(имя, значение);
          }
        }
      }
    }
  }

  /// ditto
  final проц шли(ткст from, ткст recipients, ткст subject, ткст bodyText) {
    шли(new MailMessage(from, recipients, subject, bodyText));
  }

  /// Gets or sets the имя or IP адрес of the _host used to шли an e-mail сообщение.
  final проц хост(ткст значение) {
    хост_ = значение;
  }
  /// ditto
  final ткст хост() {
    return хост_;
  }

  /// Gets or sets the _port used to шли an e-mail сообщение. The default is 25.
  final проц порт(цел значение) {
    порт_ = значение;
  }
  /// ditto
  final цел порт() {
    return порт_;
  }

  /// Specifies how outgoing e-mail messages will be handled.
  final проц deliveryMethod(SmtpDeliveryMethod значение) {
    deliveryMethod_ = значение;
  }
  /// ditto
  final SmtpDeliveryMethod deliveryMethod() {
    return deliveryMethod_;
  }

  /// Gets or sets the folder where applications save mail messages.
  final проц pickupDirectoryLocation(ткст значение) {
    pickupDirectoryLocation_ = значение;
  }
  /// ditto
  final ткст pickupDirectoryLocation() {
    return pickupDirectoryLocation_;
  }

  /// Gets or sets the _credentials used to authenticate the sender.
  final проц credentials(ICredentialsByHost значение) {
    credentials_ = значение;
  }
  /// ditto
  final ICredentialsByHost credentials() {
    return credentials_;
  }

  /// Specifies whether to use Secure Sockets Layer (SSL) to encrypt the connection.
  final проц enableSsl(бул значение) {
    enableSsl_ = значение;
  }
  /// ditto
  final бул enableSsl() {
    return enableSsl_;
  }

  /// Gets or sets the amount of время after which a шли call times out.
  final проц таймаут(цел значение) {
    timeout_ = значение;
  }
  /// ditto
  final цел таймаут() {
    return timeout_;
  }

  private проц иниц() {
    timeout_ = 100000;
    if (порт_ == 0)
      порт_ = defaultPort_;
  }

}

/**
 * Represents the адрес of an electronic mail sender or recipient.
 */
class MailAddress {

  private ткст address_;
  private ткст displayName_;
  private ткст хост_;
  private ткст user_;

  /// Initializes a new экземпляр.
  this(ткст адрес) {
    this(адрес, null);
  }

  /// ditto
  this(ткст адрес, ткст отображИмя) {
    address_ = адрес;
    displayName_ = отображИмя;

    разбор(адрес);
  }

  бул равен(Объект значение) {
    if (значение is null)
      return false;
    return (stdrus.сравнлюб(this.вТкст(), значение.вТкст()) == 0);
  }

  override ткст вТкст() {
    return адрес;
  }

  /// Gets the e-mail _address specified.
  final ткст адрес() {
    return address_;
  }

  /// Gets the display имя specified.
  final ткст отображИмя() {
    return displayName_;
  }

  /// Gets the user information from the адрес specified.
  final ткст user() {
    return user_;
  }

  /// Gets the хост portion of the адрес specified.
  final ткст хост() {
    return хост_;
  }

  private проц разбор(ткст адрес) {
    ткст display;
    цел i = адрес.индексУ('\"');
    if (i > 0)
      throw new ИсклФормата("Строка не соответствует форме, необходимой для адреса электронной почты.");

    if (i == 0) {
      i = адрес.индексУ('\"', 1);
      if (i < 0)
        throw new ИсклФормата("Строка не соответствует форме, необходимой для адреса электронной почты.");
      display = адрес[1 .. i];
      if (адрес.length == i + 1)
        throw new ИсклФормата("Строка не соответствует форме, необходимой для адреса электронной почты.");
      адрес = адрес[i + 1 .. $];
    }
    /*if (display == null) {
      i = адрес.индексУ('<');
      if (i > 0) {
        display = адрес[0 .. i];
        адрес = адрес[i .. $];
      }
    }*/

    if (displayName_ == null)
      displayName_ = display;

    адрес = адрес.trim();

    i = адрес.индексУ('@');
    if (i < 0)
      throw new ИсклФормата("Строка не соответствует форме, необходимой для адреса электронной почты.");
    user_ = адрес[0 .. i];
    хост_ = адрес[i + 1 .. $];
  }

}

/**
 * Stores e-mail addresses associated with an e-mail сообщение.
 */
class MailAddressCollection : Подборка!(MailAddress) {

  override ткст вТкст() {
    ткст s;

    бул first = true;
    foreach (адрес; this) {
      if (!first)
        s ~= ", ";
      s ~= адрес.вТкст();
      first = false;
    }

    return s;
  }

}

class NameValueCollection {

  private ткст[ткст] nameAndValue_;

  проц добавь(ткст имя, ткст значение) {
    nameAndValue_[имя] = значение;
  }

  ткст дай(ткст имя) {
    if (auto значение = имя in nameAndValue_)
      return *значение;
    return null;
  }

  проц уст(ткст имя, ткст значение) {
    nameAndValue_[имя] = значение;
  }

  цел счёт() {
    return nameAndValue_.keys.length;
  }

  проц opIndexAssign(ткст значение, ткст имя) {
    уст(имя, значение);
  }
  ткст opIndex(ткст имя) {
    return дай(имя);
  }

  цел opApply(цел delegate(ref ткст) действие) {
    цел r;

    foreach (ключ; nameAndValue_.keys) {
      if ((r = действие(ключ)) != 0)
        break;
    }

    return r;
  }

  цел opApply(цел delegate(ref ткст, ref ткст) действие) {
    цел r;

    foreach (ключ, значение; nameAndValue_) {
      if ((r = действие(ключ, значение)) != 0)
        break;
    }

    return r;
  }

}

enum TransferEncoding {
  Unknown = -1,
  QuotedPrintable = 0,
  Base64 = 1,
  SevenBit = 2
}

/**
 * Represents an e-mail attachment.
 */
class Attachment {

  private ткст fileName_;
  private TransferEncoding transferEncoding_ = TransferEncoding.Unknown;

  /// Initializes a new экземпляр.
  this(ткст имяф) {
    fileName_ = имяф;
  }

  /// Gets or sets the имя of the attachment file.
  final проц имяф(ткст значение) {
    fileName_ = значение;
  }
  /// ditto
  final ткст имяф() {
    return fileName_;
  }

  /// Gets or sets the тип of кодировка of this attachment.
  final проц transferEncoding(TransferEncoding значение) {
    transferEncoding_ = значение;
  }
  /// ditto
  final TransferEncoding transferEncoding() {
    return transferEncoding_;
  }

}

/**
 * Stores attachments to be sent as часть of an e-mail сообщение.
 */
class AttachmentCollection : Подборка!(Attachment) {
}

/**
 */
enum MailPriority {
  Normal, ///
  Low,    ///
  High    ///
}

/**
 * Represents an e-mail сообщение that can be sent используя the SmtpClient class.
 */
class MailMessage {

  private MailAddress from_;
  private MailAddress sender_;
  private MailAddress replyTo_;
  private MailAddressCollection to_;
  private MailAddressCollection cc_;
  private MailAddressCollection bcc_;
  private MailPriority priority_;
  private ткст subject_;
  private NameValueCollection headers_;
  private ткст bodyText_;
  private бул isBodyHtml_;
  private Кодировка bodyEncoding_;
  private AttachmentCollection attachments_;

  /// Initializes a new экземпляр.
  this() {
  }

  /// ditto
  this(ткст from, ткст to) {
    if (from == null)
      throw new ИсклАргумента("Параметр 'from' не может быть пустой строкой.", "from");
    if (to == null)
      throw new ИсклАргумента("Параметр 'to' не может быть пустой строкой.", "to");

    from_ = new MailAddress(from);
    this.to.добавь(new MailAddress(to));
  }

  /// ditto
  this(ткст from, ткст to, ткст subject, ткст bodyText) {
    this(from, to);
    this.subject = subject;
    this.bodyText = bodyText;
  }

  /// ditto
  this(MailAddress from, MailAddress to) {
    if (from is null)
      throw new ИсклНулевогоАргумента("from");
    if (to is null)
      throw new ИсклНулевогоАргумента("to");

    from_ = from;
    this.to.добавь(to);
  }

  /// Gets or sets the _from адрес.
  final проц from(MailAddress значение) {
    if (значение is null)
      throw new ИсклНулевогоАргумента("значение");
    from_ = значение;
  }
  /// ditto
  final MailAddress from() {
    return from_;
  }

  /// Gets or sets the sender's адрес.
  final проц sender(MailAddress значение) {
    sender_ = значение;
  }
  /// ditto
  final MailAddress sender() {
    return sender_;
  }

  /// Gets or sets the ReplyTo адрес.
  final проц replyTo(MailAddress значение) {
    replyTo_ = значение;
  }
  /// ditto
  final MailAddress replyTo() {
    return replyTo_;
  }

  /// Gets the адрес collection containing the recipients.
  final MailAddressCollection to() {
    if (to_ is null)
      to_ = new MailAddressCollection;
    return to_;
  }

  /// Gets the адрес collection containing the carbon копируй (CC) recipients.
  final MailAddressCollection cc() {
    if (cc_ is null)
      cc_ = new MailAddressCollection;
    return cc_;
  }

  /// Gets the адрес collection containing the blind carbon копируй (BCC) recipients.
  final MailAddressCollection bcc() {
    if (bcc_ is null)
      bcc_ = new MailAddressCollection;
    return bcc_;
  }

  /// Gets or sets the _priority.
  final проц priority(MailPriority значение) {
    priority_ = значение;
  }
  /// ditto
  final MailPriority priority() {
    return priority_;
  }

  /// Gets or sets the _subject line.
  final проц subject(ткст значение) {
    subject_ = значение;
  }
  /// ditto
  final ткст subject() {
    return subject_;
  }

  /// Gets the e-mail _headers.
  final NameValueCollection headers() {
    if (headers_ is null)
      headers_ = new NameValueCollection;
    return headers_;
  }

  /// Gets or sets the сообщение body.
  final проц bodyText(ткст значение) {

    бул isAscii(ткст значение) {
      foreach (ch; значение) {
        if (ch > 0x7f)
          return false;
      }
      return true;
    }

    bodyText_ = значение;
    if (bodyEncoding_ is null && bodyText_ != null) {
      if (isAscii(bodyText_))
        bodyEncoding_ = Кодировка.АСКИ;
      else
        bodyEncoding_ = Кодировка.УТФ8;
    }
  }
  /// ditto
  final ткст bodyText() {
    return bodyText_;
  }

  /// Gets or sets whether the mail сообщение body is in HTML.
  final проц isBodyHtml(бул значение) {
    isBodyHtml_ = значение;
  }
  /// ditto
  final бул isBodyHtml() {
    return isBodyHtml_;
  }

  /// Gets or sets the кодировка used to кодируй the сообщение body.
  final проц bodyEncoding(Кодировка значение) {
    bodyEncoding_ = значение;
  }
  /// ditto
  final Кодировка bodyEncoding() {
    return bodyEncoding_;
  }

  /// Gets the attachment collection used to store данные attached to this e-mail сообщение.
  final AttachmentCollection attachments() {
    if (attachments_ is null)
      attachments_ = new AttachmentCollection;
    return attachments_;
  }

}