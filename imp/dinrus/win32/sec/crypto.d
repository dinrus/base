/**
 * Provides cryptographic services including secure кодировка and decoding of данные, as well as hashing and 
 * random число generation.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.sec.crypto;

import win32.base.core,
  win32.base.string,
  win32.base.collections,
  win32.base.environment,
  win32.base.native,
  win32.loc.time,
  tpl.stream,
  stdrus;
import cidrus;

debug import std.stdio : скажифнс;

extern(Windows):

// BCrypt - Vista and higher.

const шим* BCRYPT_RSA_ALGORITHM = "RSA";
const шим* BCRYPT_AES_ALGORITHM = "AES";
const шим* BCRYPT_3DES_ALGORITHM = "3DES";
const шим* BCRYPT_MD5_ALGORITHM = "MD5";
const шим* BCRYPT_SHA1_ALGORITHM = "SHA1";
const шим* BCRYPT_SHA256_ALGORITHM = "SHA256";
const шим* BCRYPT_SHA384_ALGORITHM = "SHA384";
const шим* BCRYPT_SHA512_ALGORITHM = "SHA512";
const шим* BCRYPT_RNG_ALGORITHM = "RNG";

const шим* MS_PRIMITIVE_PROVIDER = "Microsoft Primitive Provider";

alias ДллИмпорт!("bcrypt.dll", "BCryptOpenAlgorithmProvider", 
  цел function(Укз* phAlgorithm, in шим* pszAlgid, in шим* pszImplementation, бцел dwFlags))
  BCryptOpenAlgorithmProvider;

alias ДллИмпорт!("bcrypt.dll", "BCryptCloseAlgorithmProvider",
  цел function(Укз hAlgorithm, бцел dwFlags))
  BCryptCloseAlgorithmProvider;

const шим* BCRYPT_OBJECT_LENGTH = "ObjectLength";
const шим* BCRYPT_HASH_LENGTH   = "HashDigestLength";

alias ДллИмпорт!("bcrypt.dll", "BCryptGetProperty",
  цел function(Укз hObject, in шим* pszProperty, ббайт* pbOutput, бцел cbOutput, бцел* pcbResult, бцел dwFlags))
  BCryptGetProperty;

alias ДллИмпорт!("bcrypt.dll", "BCryptCreateHash",
  цел function(Укз hAlgorithm, Укз* phHash, ббайт* pbHashObject, бцел cbHashObject, ббайт* pbSecret, бцел cbSecret, бцел dwFlags))
  BCryptCreateHash;

alias ДллИмпорт!("bcrypt.dll", "BCryptHashData",
  цел function(Укз hHash, ббайт* pbInput, бцел cbInput, бцел dwFlags))
  BCryptHashData;

alias ДллИмпорт!("bcrypt.dll", "BCryptFinishHash",
  цел function(Укз hHash, ббайт* pbOutput, бцел cbOutput, бцел dwFlags))
  BCryptFinishHash;

alias ДллИмпорт!("bcrypt.dll", "BCryptDestroyHash",
  цел function(Укз hHash))
  BCryptDestroyHash;

alias ДллИмпорт!("bcrypt.dll", "BCryptGenRandom",
  цел function(Укз hAlgorithm, ббайт* pbBuffer, бцел cbBuffer, бцел dwFlags))
  BCryptGenRandom;

extern(D):

private бул bcryptSupported() {
  static Опционал!(бул) bcryptSupported_;

  if (!bcryptSupported_.hasValue) {
    Укз h = LoadLibrary("bcrypt");
    scope(exit) FreeLibrary(h);
    bcryptSupported_ = (h != Укз.init);
  }

  return bcryptSupported_.значение;
}

private проц blockCopy(T, TI1 = цел, TI2 = TI1, TI3 = TI1)(T[] src, TI1 srcOffset, T[] dst, TI2 dstOffset, TI3 счёт) {
  memmove(dst.ptr + dstOffset, src.ptr + srcOffset, счёт * T.sizeof);
}

/**
 * The exception thrown when an ошибка occurs during a cryptogaphic operation.
 */
class CryptoException : Exception {

  private static const E_CRYPTO = "Произошла ошибка во время криптографической операции";

  this() {
    super(E_CRYPTO);
  }

  this(бцел кодОш) {
    this(дайОшСооб(кодОш));
  }

  this(ткст сообщение) {
    super(сообщение);
  }

  private static ткст дайОшСооб(бцел кодОш) {
    шим[256] буфер;
    бцел рез = FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS, null, кодОш, 0, буфер.ptr, буфер.length + 1, null);
    if (рез != 0)
      return вУтф8(буфер[0 .. рез]);
    return фм("Неуказан ошибка (0x%08X)", кодОш);
  }

}

/**
 * Defines the basic operations of cryptographic transformations.
 */
interface ICryptoTransform {

  /**
   * Transforms the specified ввод array and copies the resulting transform to the specified вывод array.
   */
  бцел transformBlock(ббайт[] inputBuffer, бцел inputOffset, бцел inputCount, ббайт[] outputBuffer, бцел outputOffset);

  /**
   * Transforms the specified array.
   */
  ббайт[] transformFinalBlock(ббайт[] inputBuffer, бцел inputOffset, бцел inputCount);
  //ббайт[] transformFinalBlock(ббайт[] буфер);

  /**
   * Gets the ввод block размер.
   */
  бцел inputBlockSize();

  /**
   * Gets the вывод block размер.
   */
  бцел outputBlockSize();

}

/**
 * Specifies the block cipher mode to use for encryption.
 */
enum CipherMode {
  CBC = 1, /// Cipher Block Chaining.
  ECB = 2, /// Electronic Codebook.
  OFB = 3, /// Output Feedback.
  CFB = 4, /// Cipher Feedback.
  CTS = 5  /// Cipher Text Stealing.
}

/**
 * Specifies the тип of padding to apply when the сообщение данные block is shorter than the full число
 * of байты needed for a cryptographic operation.
 */
enum PaddingMode {
  None = 1,     /// No padding is done.
  PKCS7 = 2,    /// 
  Zeros = 3,    ///
  ANSIX923 = 4, ///
  ISO10126 = 5  ///
}

/**
 * Specifies the mode of a cryptographic поток.
 */
enum CryptoStreamMode {
  Read, /// _Read access to a cryptographic поток.
  Write /// _Write access to a cryptographic поток.
}

/**
 * Defines a поток that links данные streams to cryptographic transformations.
 */
class CryptoStream : Поток {

  private Поток stream_;
  private ICryptoTransform transform_;
  private CryptoStreamMode transformMode_;

  private бцел inputBlockSize_;
  private ббайт[] inputBuffer_;
  private бцел inputBufferIndex_;
  private бцел outputBlockSize_;
  private ббайт[] outputBuffer_;
  private бцел outputBufferIndex_;

  private бул finalBlockTransformed_;

  /**
   * Initializes a new экземпляр.
   */
  this(Поток поток, ICryptoTransform transform, CryptoStreamMode mode) {
    stream_ = поток;
    transform_ = transform;
    transformMode_ = mode;

    if (transformMode_ == CryptoStreamMode.Read)
      читаемый(да);
    else if (transformMode_ == CryptoStreamMode.Write)
      записываемый(да);

    if (transform_ !is null) {
      inputBlockSize_ = transform_.inputBlockSize;
      inputBuffer_.length = inputBlockSize_;
      outputBlockSize_ = transform_.outputBlockSize;
      outputBuffer_.length = outputBlockSize_;
    }
  }

  override проц закрой() {
    if (!finalBlockTransformed_)
      flushFinalBlock();

    stream_.закрой();

    inputBuffer_ = null;
    outputBuffer_ = null;
  }

  /**
   * Updates the underlying данные исток with the текущ state of the буфер.
   */
  final проц flushFinalBlock() {
    //ббайт[] block = transform_.transformFinalBlock(input_);
    ббайт[] finalBytes = transform_.transformFinalBlock(inputBuffer_, 0, inputBufferIndex_);
    finalBlockTransformed_ = true;

    if (записываемый && outputBufferIndex_ > 0) {
      stream_.пишиБлок(outputBuffer_.ptr, outputBufferIndex_);
      outputBufferIndex_ = 0;
    }
    if (записываемый)
      stream_.пишиБлок(finalBytes.ptr, finalBytes.length);

    stream_.слей();

    inputBuffer_[] = 0;
    outputBuffer_[] = 0;
  }

  override проц слей() {
  }

  override бдол сместись(дол смещение, ППозКурсора origin) {
    throw new ИсклНеПоддерживается;
  }

  override проц позиция(бдол) {
    throw new ИсклНеПоддерживается;
  }
  override бдол позиция() {
    throw new ИсклНеПоддерживается;
  }

  override бдол размер() {
    throw new ИсклНеПоддерживается;
  }

  override т_мера читайБлок(ук буфер, т_мера размер) {
    бцел readBytes = размер;
    бцел outputIndex = 0;

    if (outputBufferIndex_ > 0) {
      if (outputBufferIndex_ <= размер) {
        memmove(буфер, outputBuffer_.ptr, outputBufferIndex_);
        readBytes -= outputBufferIndex_;
        outputIndex += outputBufferIndex_;
        outputBufferIndex_ = 0;
      }
      else {
        memmove(буфер, outputBuffer_.ptr, размер);
        //memmove(outputBuffer_.ptr, outputBuffer_.ptr + размер, outputBufferIndex_ - размер);
        blockCopy(outputBuffer_, размер, outputBuffer_, 0, outputBufferIndex_ - размер);
        outputBufferIndex_ -= размер;
        return размер;
      }
    }

    if (finalBlockTransformed_)
      return размер - readBytes;

    бцел outputBytes;
    бцел numRead;

    while (readBytes > 0) {
      while (inputBufferIndex_ < inputBlockSize_) {
        numRead = stream_.читайБлок(inputBuffer_.ptr + inputBufferIndex_, inputBlockSize_ - inputBufferIndex_);
        if (numRead == 0) {
          outputBuffer_ = transform_.transformFinalBlock(inputBuffer_, 0, inputBufferIndex_);
          outputBufferIndex_ = outputBuffer_.length;
          finalBlockTransformed_ = true;

          if (readBytes < outputBufferIndex_) {
            memmove(буфер + outputIndex, outputBuffer_.ptr, readBytes);
            outputBufferIndex_ -= readBytes;
            //memmove(outputBuffer_.ptr, outputBuffer_.ptr + readBytes, outputBufferIndex_);
            blockCopy(outputBuffer_, readBytes, outputBuffer_, 0, outputBufferIndex_);
            return размер;
          }
          else {
            memmove(буфер + outputIndex, outputBuffer_.ptr, outputBufferIndex_);
            readBytes -= outputBufferIndex_;
            outputBufferIndex_ = 0;
            return размер - readBytes;
          }
        }
        inputBufferIndex_ += numRead;
      }

      outputBytes = transform_.transformBlock(inputBuffer_, 0, inputBlockSize_, outputBuffer_, 0);
      inputBufferIndex_ = 0;
      if (readBytes >= outputBytes) {
        memmove(буфер + outputIndex, outputBuffer_.ptr, outputBytes);
        outputIndex += outputBytes;
        readBytes -= outputBytes;
      }
      else {
        memmove(буфер + outputIndex, outputBuffer_.ptr, readBytes);
        outputBufferIndex_ = outputBytes - readBytes;
        //memmove(outputBuffer_.ptr, outputBuffer_.ptr + readBytes, outputBufferIndex_);
        blockCopy(outputBuffer_, readBytes, outputBuffer_, 0, outputBufferIndex_);
        return размер;
      }
    }
    return размер;
  }

  override т_мера пишиБлок(in ук буфер, т_мера размер) {
    бцел writeBytes = размер;
    бцел inputIndex = 0;

    if (inputBufferIndex_ > 0) {
      if (размер >= inputBlockSize_ - inputBufferIndex_) {
        memmove(inputBuffer_.ptr + inputBufferIndex_, буфер, inputBlockSize_ - inputBufferIndex_);
        inputIndex += (inputBlockSize_ - inputBufferIndex_);
        writeBytes -= (inputBlockSize_ - inputBufferIndex_);
        inputBufferIndex_ = inputBlockSize_;
      }
      else {
        memmove(inputBuffer_.ptr + inputBufferIndex_, буфер, размер);
        inputBufferIndex_ += размер;
        return размер;
      }
    }

    if (outputBufferIndex_ > 0) {
      stream_.пишиБлок(outputBuffer_.ptr, outputBufferIndex_);
      outputBufferIndex_ = 0;
    }

    бцел outputBytes;
    if (inputBufferIndex_ == inputBlockSize_) {
      outputBytes = transform_.transformBlock(inputBuffer_, 0, inputBlockSize_, outputBuffer_, 0);
      stream_.пишиБлок(outputBuffer_.ptr, outputBytes);
      inputBufferIndex_ = 0;
    }

    while (writeBytes > 0) {
      if (writeBytes >= inputBlockSize_) {
        бцел wholeBlocks = writeBytes / inputBlockSize_;
        бцел wholeBlocksBytes = wholeBlocks * inputBlockSize_;

        ббайт[] tempBuffer = new ббайт[wholeBlocks * outputBlockSize_];
        outputBytes = transform_.transformBlock(cast(ббайт[])буфер[0 .. размер], inputIndex, wholeBlocksBytes, tempBuffer, 0);
        stream_.пишиБлок(tempBuffer.ptr, outputBytes);
        inputIndex += wholeBlocksBytes;
        writeBytes -= wholeBlocksBytes;

        /*outputBytes = transform_.transformBlock(cast(ббайт[])буфер[0 .. размер], inputIndex, inputBlockSize_, outputBuffer_, 0);
        stream_.пишиБлок(outputBuffer_.ptr, outputBytes);
        inputIndex += inputBlockSize_;
        writeBytes -= inputBlockSize_;*/
      }
      else {
        memmove(inputBuffer_.ptr, буфер + inputIndex, writeBytes);
        inputBufferIndex_ += writeBytes;
        return размер;
      }
    }
    //memmove(inputBuffer_.ptr, буфер, размер);
    return размер;
  }

}

/**
 * Represents the base class from which implementations of cryptographic hash algorithms derive.
 */
abstract class HashAlgorithm : ICryptoTransform, ИВымещаемый {

  protected ббайт[] hashValue;
  protected бцел hashSizeValue;

  protected this() {
  }

  ~this() {
    сотри();
  }
 
 override проц dispose(){
	сотри();
	}
  /**
   * Releases all resources held by this экземпляр.
   */
  final проц сотри() {
    hashValue = null;
  }

  /**
   * Computes the hash for the specified данные.
   */
  final ббайт[] computeHash(ббайт[] буфер, бцел смещение, бцел счёт) {
    hashCore(буфер, смещение, счёт);
    hashValue = hashFinal();

    ббайт[] hash = hashValue.dup;
    иниц();
    return hash;
  }

  /// ditto
  final ббайт[] computeHash(ббайт[] буфер) {
    return computeHash(буфер, 0, буфер.length);
  }

  /// ditto
  final ббайт[] computeHash(Поток ввод) {
    ббайт[] буфер = new ббайт[4096];
    бцел len;
    do {
      len = ввод.читай(буфер);
      if (len > 0)
        hashCore(буфер, 0, len);
    } while (len > 0);
    hashValue = hashFinal();

    ббайт[] hash = hashValue.dup;
    иниц();
    return hash;
  }

  /**
   * Computes the hash значение for the specified ввод array and copies the resulting hash значение to the specified вывод array.
   */
  final бцел transformBlock(ббайт[] inputBuffer, бцел inputOffset, бцел inputCount, ббайт[] outputBuffer, бцел outputOffset) {
    hashCore(inputBuffer, inputOffset, inputCount);
    if (outputBuffer != null && (inputBuffer != outputBuffer || inputOffset != outputOffset))
      //memmove(outputBuffer.ptr + outputOffset, inputBuffer.ptr + inputOffset, inputCount);
      blockCopy(inputBuffer, inputOffset, outputBuffer, outputOffset, inputCount);
    return inputCount;
  }

  /**
   * Computes the hash значение for the specified ввод array.
   */
  final ббайт[] transformFinalBlock(ббайт[] inputBuffer, бцел inputOffset, бцел inputCount) {
    hashCore(inputBuffer, inputOffset, inputCount);
    hashValue = hashFinal();

    ббайт[] outputBuffer = new ббайт[inputCount];
    if (inputCount != 0)
      //memmove(outputBuffer.ptr, inputBuffer.ptr + inputOffset, inputCount);
      blockCopy(inputBuffer, inputOffset, outputBuffer, 0, inputCount);
    return outputBuffer;
  }

  abstract проц иниц() {
  }

  protected проц hashCore(ббайт[] array, бцел start, бцел размер);

  protected ббайт[] hashFinal();

  /**
   * Gets the значение of the computed _hash code.
   */
  ббайт[] hash() {
    return hashValue.dup;
  }

  /**
   * Gets the размер in bits of the computed hash code.
   */
  бцел hashSize() {
    return hashSizeValue;
  }

  /**
   * Gets the ввод block размер.
   */
  бцел inputBlockSize() {
    return 1;
  }

  /**
   * Gets the вывод block размер.
   */
  бцел outputBlockSize() {
    return 1;
  }

}

/**
 * Determines the уст of valid ключ sizes for symmetric cryptographic algorithms.
 */
final class KeySizes {

  private бцел min_;
  private бцел max_;
  private бцел skip_;

  /**
   * Initializes a new экземпляр.
   */
  this(бцел min, бцел max, бцел skip) {
    min_ = min;
    max_ = max;
    skip_ = skip;
  }

  /**
   * Specifies the minimum ключ размер in bits.
   */
  бцел min() {
    return min_;
  }

  /**
   * Specifies the maximum ключ размер in bits.
   */
  бцел max() {
    return max_;
  }

  /**
   * Specifies the интервал between valid ключ sizes in bits.
   */
  бцел skip() {
    return skip_;
  }

}

/**
 * The abstract base class from which implementations of symmetric algorithms derive.
 */
abstract class SymmetricAlgorithm : ИВымещаемый {

  protected ббайт[] keyValue;
  protected бцел keySizeValue;
  protected KeySizes[] legalKeySizesValue;
  protected ббайт[] ivValue;
  protected бцел blockSizeValue;
  protected CipherMode modeValue = CipherMode.CBC;
  protected PaddingMode paddingValue = PaddingMode.PKCS7;//PaddingMode.Zeros;

  protected this() {
  }
 
 override проц dispose(){	сотри();}
 
  final проц сотри() {
    keyValue = null;
    ivValue = null;
  }

  ~this() {
    сотри();
  }

  /**
   * Creates a symmetric encryptor object.
   */
  abstract ICryptoTransform createEncryptor(ббайт[] ключ, ббайт[] iv);

  /// ditto
  ICryptoTransform createEncryptor() {
    return createEncryptor(ключ, iv);
  }

  /**
   * Creates a symmetric decryptor object.
   */
  abstract ICryptoTransform createDecryptor(ббайт[] ключ, ббайт[] iv);

  /// ditto
  ICryptoTransform createDecryptor() {
    return createDecryptor(ключ, iv);
  }

  /**
   * Generates a random ключ to use for the algorithm.
   */
  abstract проц generateKey();

  /**
   * Generates a random initialization vector to use for the algorithm.
   */
  abstract проц generateIV();

  /**
   * Determines whether the specified ключ размер is valid for the algorithm.
   */
  final бул isValidKeySize(бцел bitLength) {
    foreach (keySize; legalKeySizes) {
      if (keySize.skip == 0) {
        if (keySize.min == bitLength)
          return true;
      }
      else {
        for (бцел i = keySize.min; i <= keySize.max; i += keySize.skip) {
          if (i == bitLength)
            return true;
        }
      }
    }
    return false;
  }

  /**
   * Gets or sets the secret _key for the symmetric algorithm.
   */
  проц ключ(ббайт[] значение) {
    keyValue = значение.dup;
    keySizeValue = значение.length * 8;
  }
  /// ditto
  ббайт[] ключ() {
    if (keyValue == null)
      generateKey();
    return keyValue.dup;
  }

  /**
   * Gets or sets the размер in bits of the secret ключ used by the symmetric algorithm.
   */
  проц keySize(бцел значение) {
    if (!isValidKeySize(значение))
      throw new CryptoException;

    keySizeValue = значение;
    keyValue = null;
  }
  /// ditto
  бцел keySize() {
    return keySizeValue;
  }

  /**
   * Gets the ключ sizes in bits supported by the symmetric algorithm.
   */
  KeySizes[] legalKeySizes() {
    return legalKeySizesValue.dup;
  }

  /**
   * Gets or sets the initialization vector for the symmetric algorithm.
   */
  проц iv(ббайт[] значение) {
    ivValue = значение;
  }
  /// ditto
  ббайт[] iv() {
    if (ivValue == null)
      generateIV();
    return ivValue.dup;
  }

  /**
   * Gets or sets the block размер in bits of the symmetric algorithm.
   */
  проц blockSize(бцел значение) {
    blockSizeValue = значение;
    ivValue = null;
  }
  /// ditto
  бцел blockSize() {
    return blockSizeValue;
  }

  /**
   * Gets or sets the _mode of operation of the symmetric algorithm.
   */
  проц mode(CipherMode значение) {
    modeValue = значение;
  }
  /// ditto
  CipherMode mode() {
    return modeValue;
  }

  /**
   * Gets or sets the _padding mode used in the symmetric algorithm.
   */
  проц padding(PaddingMode значение) {
    paddingValue = значение;
  }
  /// ditto
  PaddingMode padding() {
    return paddingValue;
  }

}

/**
 * The abstract base class from which implementations of asymmetric algorithms derive.
 */
abstract class AsymmetricAlgorithm : ИВымещаемый {

  protected KeySizes[] legalKeySizesValue;
  protected бцел keySizeValue;

  protected this() {
  }
 
 override проц dispose(){	}
  /**
   * Gets or sets the размер in bits of the ключ used by the asymmetric algorithm.
   */
  проц keySize(бцел значение) {
    foreach (keySize; legalKeySizesValue) {
      if (keySize.skip == 0) {
        if (keySize.min == значение) {
          keySizeValue = значение;
          return;
        }
      }
      else {
        for (цел i = keySize.min; i <= keySize.max; i += keySize.skip) {
          if (i == значение) {
            keySizeValue = значение;
            return;
          }
        }
      }
    }
    throw new CryptoException;
  }
  /// ditto
  бцел keySize() {
    return keySizeValue;
  }

  /**
   * Gets the ключ sizes supported by the asymmetric algorithm.
   */
  KeySizes[] legalKeySizes() {
    return legalKeySizesValue.dup;
  }

  /**
   * Gets the имя of the ключ exchange algorithm.
   */
  abstract ткст keyExchangeAlgorithm();

  /**
   * Gets the имя of the signature algorithm.
   */
  abstract ткст signatureAlgorithm();

}

/**
 * Represents the abstract base class from which implementations of cryptographic random число generators derive.
 */
abstract class RandomNumberGenerator {

  protected this() {
  }

  /**
   * Fills an array with a a cryptographically strong random sequence of значения.
   */
  abstract проц getBytes(ббайт[] данные);

  /**
   * Fills an array with a a cryptographically strong random sequence of non-zero значения.
   */
  abstract проц getNonZeroBytes(ббайт[] данные);

}

private final class CAPIHashAlgorithm {

  private Укз provider_;
  private Укз hash_;
  private бцел algorithm_;

  this(ткст провайдер, бцел providerType, бцел algorithm) {
    algorithm_ = algorithm;

    if (!CryptAcquireContext(provider_, null, провайдер.вУтф16н(), providerType, CRYPT_VERIFYCONTEXT))
      throw new CryptoException(GetLastError());

    иниц();
  }

  ~this() {
    dispose();
  }

  проц dispose() {
    if (hash_ != Укз.init) {
      CryptDestroyHash(hash_);
      hash_ = Укз.init;
    }

    if (provider_ != Укз.init) {
      CryptReleaseContext(provider_, 0);
      provider_ = Укз.init;
    }
  }

  проц иниц() {
    Укз newHash;
    if (!CryptCreateHash(provider_, algorithm_, Укз.init, 0, newHash))
      throw new CryptoException(GetLastError());

    if (hash_ != Укз.init)
      CryptDestroyHash(hash_);
    hash_ = newHash;
  }

  проц hashCore(ббайт[] array, бцел start, бцел размер) {
    if (!CryptHashData(hash_, array.ptr + start, размер, 0))
      throw new CryptoException(GetLastError());
  }

  ббайт[] hashFinal() {
    бцел cb;
    if (!CryptGetHashParam(hash_, HP_HASHVAL, null, cb, 0))
      throw new CryptoException(GetLastError());

    ббайт[] байты = new ббайт[cb];
    if (!CryptGetHashParam(hash_, HP_HASHVAL, байты.ptr, cb, 0))
      throw new CryptoException(GetLastError());
    return байты;
  }

}

private final class BCryptHashAlgorithm {

  private Укз algorithm_;
  private Укз hash_;
  private Укз hashObject_;

  this(in шим* algorithm, in шим* implementation) {
    if (!bcryptSupported)
      throw new ИсклНеПоддерживается("The specified cryptographic operation is not supported on this platform.");

    цел r = BCryptOpenAlgorithmProvider(&algorithm_, algorithm, implementation, 0);
    if (r != ERROR_SUCCESS)
      throw new CryptoException(r);

    иниц();
  }

  ~this() {
    dispose();
  }

  проц dispose() {
    if (hash_ != Укз.init) {
      BCryptDestroyHash(hash_);
      hash_ = Укз.init;

      if (hashObject_ != Укз.init) {
        LocalFree(hashObject_);
        hashObject_ = Укз.init;
      }
    }

    if (algorithm_ != Укз.init) {
      BCryptCloseAlgorithmProvider(algorithm_, 0);
      algorithm_ = Укз.init;
    }
  }

  проц иниц() {
    бцел hashObjectSize;
    бцел dataSize;
    цел r = BCryptGetProperty(algorithm_, BCRYPT_OBJECT_LENGTH, cast(ббайт*)&hashObjectSize, бцел.sizeof, &dataSize, 0);
    if (r != ERROR_SUCCESS)
      throw new CryptoException(r);

    Укз newHash;
    Укз newHashObject = LocalAlloc(LMEM_FIXED, hashObjectSize);
    r = BCryptCreateHash(algorithm_, &newHash, cast(ббайт*)newHashObject, hashObjectSize, null, 0, 0);
    if (r != ERROR_SUCCESS)
      throw new CryptoException(r);

    if (hash_ != Укз.init) {
      BCryptDestroyHash(hash_);
      hash_ = Укз.init;

      if (hashObject_ != Укз.init) {
        LocalFree(hashObject_);
        hashObject_ = Укз.init;
      }
    }
    hash_ = newHash;
    hashObject_ = newHashObject;
  }

  проц hashCore(ббайт[] array, бцел start, бцел размер) {
    цел r = BCryptHashData(hash_, array.ptr + start, размер, 0);
    if (r != ERROR_SUCCESS)
      throw new CryptoException(r);
  }

  ббайт[] hashFinal() {
    бцел hashSize;
    бцел dataSize;
    цел r = BCryptGetProperty(algorithm_, BCRYPT_HASH_LENGTH, cast(ббайт*)&hashSize, бцел.sizeof, &dataSize, 0);
    if (r != ERROR_SUCCESS)
      throw new CryptoException(r);

    ббайт[] вывод = new ббайт[hashSize];
    r = BCryptFinishHash(hash_, вывод.ptr, вывод.length, 0);
    if (r != ERROR_SUCCESS)
      throw new CryptoException(r);
    return вывод;
  }

}

/**
 * The base class from which implementations of the _MD5 hash algorithms derive.
 */
abstract class Md5 : HashAlgorithm {

  protected this() {
    hashSizeValue = 128;
  }

  override ткст вТкст() {
    return "Md5";
  }

}

/**
 * Computes the $(LINK2 http://en.wikipedia.org/wiki/MD5, MD5) hash значение for the ввод данные используя the implementation provided by the cryptographic service провайдер.
 * Examples:
 * ---
 * import win32.base.text, win32.security.crypto, std.stdio;
 * 
 * проц main() {
 *   ткст text = "Some text to be hashed";
 *   ббайт[] textBytes = Кодировка.УТФ8.кодируй(text);
 *
 *   scope md5 = new Md5CryptoServiceProvider;
 *   ббайт[] hashedBytes = md5.computeHash(textBytes);
 *
 *   // Writes out the hashed text as r+ITAIu+cM+Csl1GW5qYSQ==
 *   ткст hashedText = std.base64.кодируй(hashedBytes);
 *   скажифнс(hashedText);
 * }
 * ---
 */
final class Md5CryptoServiceProvider : Md5 {

  private CAPIHashAlgorithm hashAlgorithm_;

  this() {
    hashAlgorithm_ = new CAPIHashAlgorithm(null, PROV_RSA_FULL, CALG_MD5);
  }

  ~this() {
    dispose();
  }

  проц dispose() {
    if (hashAlgorithm_ !is null) {
      hashAlgorithm_.dispose();
      hashAlgorithm_ = null;
    }
  }

  override проц иниц() {
    hashAlgorithm_.иниц();
  }

  protected override проц hashCore(ббайт[] array, бцел start, бцел размер) {
    hashAlgorithm_.hashCore(array, start, размер);
  }

  protected override ббайт[] hashFinal() {
    return hashAlgorithm_.hashFinal();
  }

}

/**
 * Provides a CNG (Cryptography Next Generation) implementation of the MD5 hashing algorithm.
 */
final class Md5Cng : Md5 {

  private BCryptHashAlgorithm hashAlgorithm_;

  this() {
    hashAlgorithm_ = new BCryptHashAlgorithm(BCRYPT_MD5_ALGORITHM, MS_PRIMITIVE_PROVIDER);
  }

  ~this() {
    dispose();
  }

  проц dispose() {
    if (hashAlgorithm_ !is null) {
      hashAlgorithm_.dispose();
      hashAlgorithm_ = null;
    }
  }

  override проц иниц() {
    hashAlgorithm_.иниц();
  }

  protected override проц hashCore(ббайт[] array, бцел start, бцел размер) {
    hashAlgorithm_.hashCore(array, start, размер);
  }

  protected override ббайт[] hashFinal() {
    return hashAlgorithm_.hashFinal();
  }

}

/**
 * Computes the $(LINK2 http://en.wikipedia.org/wiki/SHA, SHA1) hash значение for the ввод данные.
 */
abstract class Sha1 : HashAlgorithm {

  protected this() {
    hashSizeValue = 160;
  }

  override ткст вТкст() {
    return "Sha1";
  }

}

/**
 * Computes the $(LINK2 http://en.wikipedia.org/wiki/SHA, SHA1) hash значение for the ввод данные используя the implementation provided by the cryptographic service провайдер.
 */
final class Sha1CryptoServiceProvider : Sha1 {

  private CAPIHashAlgorithm hashAlgorithm_;

  this() {
    hashAlgorithm_ = new CAPIHashAlgorithm(null, PROV_RSA_FULL, CALG_SHA1);
  }

  ~this() {
    dispose();
  }

  проц dispose() {
    if (hashAlgorithm_ !is null) {
      hashAlgorithm_.dispose();
      hashAlgorithm_ = null;
    }
  }

  override проц иниц() {
    hashAlgorithm_.иниц();
  }

  protected override проц hashCore(ббайт[] array, бцел start, бцел размер) {
    hashAlgorithm_.hashCore(array, start, размер);
  }

  protected override ббайт[] hashFinal() {
    return hashAlgorithm_.hashFinal();
  }

}

/**
 * Provides a CNG (Cryptography Next Generation) implementation of the Secure Hash Algorithm (SHA).
 */
final class Sha1Cng : Sha1 {

  private BCryptHashAlgorithm hashAlgorithm_;

  this() {
    hashAlgorithm_ = new BCryptHashAlgorithm(BCRYPT_SHA1_ALGORITHM, MS_PRIMITIVE_PROVIDER);
  }

  ~this() {
    dispose();
  }

  проц dispose() {
    if (hashAlgorithm_ !is null) {
      hashAlgorithm_.dispose();
      hashAlgorithm_ = null;
    }
  }

  override проц иниц() {
    hashAlgorithm_.иниц();
  }

  protected override проц hashCore(ббайт[] array, бцел start, бцел размер) {
    hashAlgorithm_.hashCore(array, start, размер);
  }

  protected override ббайт[] hashFinal() {
    return hashAlgorithm_.hashFinal();
  }

}

/**
 * Computes the $(LINK2 http://en.wikipedia.org/wiki/SHA, SHA256) hash значение for the ввод данные.
 */
abstract class Sha256 : HashAlgorithm {

  protected this() {
    hashSizeValue = 256;
  }

  override ткст вТкст() {
    return "Sha256";
  }

}

/**
 * Computes the $(LINK2 http://en.wikipedia.org/wiki/SHA, SHA256) hash значение for the ввод данные используя the implementation provided by the cryptographic service провайдер.
 */
final class Sha256CryptoServiceProvider : Sha256 {

  private CAPIHashAlgorithm hashAlgorithm_;

  this() {
    hashAlgorithm_ = new CAPIHashAlgorithm(null, PROV_RSA_AES, CALG_SHA_256);
  }

  ~this() {
    dispose();
  }

  проц dispose() {
    if (hashAlgorithm_ !is null) {
      hashAlgorithm_.dispose();
      hashAlgorithm_ = null;
    }
  }

  override проц иниц() {
    hashAlgorithm_.иниц();
  }

  protected override проц hashCore(ббайт[] array, бцел start, бцел размер) {
    hashAlgorithm_.hashCore(array, start, размер);
  }

  protected override ббайт[] hashFinal() {
    return hashAlgorithm_.hashFinal();
  }

}

/**
 * Provides a CNG (Cryptography Next Generation) implementation of the Secure Hash Algorithm (SHA) for 256-bit hash значения.
 */
final class Sha256Cng : Sha256 {

  private BCryptHashAlgorithm hashAlgorithm_;

  this() {
    hashAlgorithm_ = new BCryptHashAlgorithm(BCRYPT_SHA256_ALGORITHM, MS_PRIMITIVE_PROVIDER);
  }

  ~this() {
    dispose();
  }

  проц dispose() {
    if (hashAlgorithm_ !is null) {
      hashAlgorithm_.dispose();
      hashAlgorithm_ = null;
    }
  }

  override проц иниц() {
    hashAlgorithm_.иниц();
  }

  protected override проц hashCore(ббайт[] array, бцел start, бцел размер) {
    hashAlgorithm_.hashCore(array, start, размер);
  }

  protected override ббайт[] hashFinal() {
    return hashAlgorithm_.hashFinal();
  }

}

/**
 * Computes the $(LINK2 http://en.wikipedia.org/wiki/SHA, SHA384) hash значение for the ввод данные.
 */
abstract class Sha384 : HashAlgorithm {

  protected this() {
    hashSizeValue = 384;
  }

  override ткст вТкст() {
    return "Sha384";
  }

}

/**
 * Computes the $(LINK2 http://en.wikipedia.org/wiki/SHA, SHA384) hash значение for the ввод данные используя the implementation provided by the cryptographic service провайдер.
 */
final class Sha384CryptoServiceProvider : Sha384 {

  private CAPIHashAlgorithm hashAlgorithm_;

  this() {
    hashAlgorithm_ = new CAPIHashAlgorithm(null, PROV_RSA_AES, CALG_SHA_384);
  }

  ~this() {
    dispose();
  }

  проц dispose() {
    if (hashAlgorithm_ !is null) {
      hashAlgorithm_.dispose();
      hashAlgorithm_ = null;
    }
  }

  override проц иниц() {
    hashAlgorithm_.иниц();
  }

  protected override проц hashCore(ббайт[] array, бцел start, бцел размер) {
    hashAlgorithm_.hashCore(array, start, размер);
  }

  protected override ббайт[] hashFinal() {
    return hashAlgorithm_.hashFinal();
  }

}

/**
 * Provides a CNG (Cryptography Next Generation) implementation of the Secure Hash Algorithm (SHA) for 384-bit hash значения.
 */
final class Sha384Cng : Sha384 {

  private BCryptHashAlgorithm hashAlgorithm_;

  this() {
    hashAlgorithm_ = new BCryptHashAlgorithm(BCRYPT_SHA384_ALGORITHM, MS_PRIMITIVE_PROVIDER);
  }

  ~this() {
    dispose();
  }

  проц dispose() {
    if (hashAlgorithm_ !is null) {
      hashAlgorithm_.dispose();
      hashAlgorithm_ = null;
    }
  }

  override проц иниц() {
    hashAlgorithm_.иниц();
  }

  protected override проц hashCore(ббайт[] array, бцел start, бцел размер) {
    hashAlgorithm_.hashCore(array, start, размер);
  }

  protected override ббайт[] hashFinal() {
    return hashAlgorithm_.hashFinal();
  }

}

/**
 * Computes the $(LINK2 http://en.wikipedia.org/wiki/SHA, SHA512) hash значение for the ввод данные.
 */
abstract class Sha512 : HashAlgorithm {

  protected this() {
    hashSizeValue = 512;
  }

  override ткст вТкст() {
    return "Sha512";
  }

}

/**
 * Computes the $(LINK2 http://en.wikipedia.org/wiki/SHA, SHA512) hash значение for the ввод данные используя the implementation provided by the cryptographic service провайдер.
 */
final class Sha512CryptoServiceProvider : Sha512 {

  private CAPIHashAlgorithm hashAlgorithm_;

  this() {
    hashAlgorithm_ = new CAPIHashAlgorithm(null, PROV_RSA_AES, CALG_SHA_512);
  }

  ~this() {
    dispose();
  }

  проц dispose() {
    if (hashAlgorithm_ !is null) {
      hashAlgorithm_.dispose();
      hashAlgorithm_ = null;
    }
  }

  override проц иниц() {
    hashAlgorithm_.иниц();
  }

  protected override проц hashCore(ббайт[] array, бцел start, бцел размер) {
    hashAlgorithm_.hashCore(array, start, размер);
  }

  protected override ббайт[] hashFinal() {
    return hashAlgorithm_.hashFinal();
  }

}

/**
 * Provides a CNG (Cryptography Next Generation) implementation of the Secure Hash Algorithm (SHA) for 512-bit hash значения.
 */
final class Sha512Cng : Sha512 {

  private BCryptHashAlgorithm hashAlgorithm_;

  this() {
    hashAlgorithm_ = new BCryptHashAlgorithm(BCRYPT_SHA512_ALGORITHM, MS_PRIMITIVE_PROVIDER);
  }

  ~this() {
    dispose();
  }

  проц dispose() {
    if (hashAlgorithm_ !is null) {
      hashAlgorithm_.dispose();
      hashAlgorithm_ = null;
    }
  }

  override проц иниц() {
    hashAlgorithm_.иниц();
  }

  protected override проц hashCore(ббайт[] array, бцел start, бцел размер) {
    hashAlgorithm_.hashCore(array, start, размер);
  }

  protected override ббайт[] hashFinal() {
    return hashAlgorithm_.hashFinal();
  }

}

private enum EncryptionMode {
  Encrypt,
  Decrypt
}

/**
 * The base class from which implementations of the Triple DES algorithms derive.
 */
abstract class TripleDes : SymmetricAlgorithm {

  protected this() {
    legalKeySizesValue = [ new KeySizes(/*min*/ 128, /*max*/ 192, /*step*/ 64) ];
    keySizeValue = 192;
    blockSizeValue = 64;
  }

}

/**
 * Provides access to the cryptographic service провайдер implementation of the $(LINK2 http://en.wikipedia.org/wiki/Triple_DES, Triple DES) algorithm.
 */
final class TripleDesCryptoServiceProvider : TripleDes {

  private Укз provider_;
  private Укз key_;

  this() {
    if (!CryptAcquireContext(provider_, null, null, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT))
      throw new CryptoException(GetLastError());
    //скажифнс("CryptAcquireContext");
  }

  ~this() {
    dispose();
  }

  проц dispose() {
    if (key_ != Укз.init) {
      CryptDestroyKey(key_);
      key_ = Укз.init;
    }

    if (provider_ != Укз.init) {
      CryptReleaseContext(provider_, 0);
      provider_ = Укз.init;
    }
  }

  override ICryptoTransform createEncryptor() {
    if (key_ == Укз.init)
      generateKey();
    if (mode != CipherMode.ECB && ivValue == null)
      generateIV();
    return new CAPITransform(blockSizeValue, provider_, key_, ivValue, mode, paddingValue, EncryptionMode.Encrypt);
  }

  override ICryptoTransform createEncryptor(ббайт[] ключ, ббайт[] iv) {
    if (!isValidKeySize(ключ.length * 8))
      throw new ИсклАргумента;

    ббайт[] ivValue = (iv == null) ? null : iv.dup;
    Укз importedKey = importSymmetricKey(provider_, CALG_3DES, ключ.dup);
    return new CAPITransform(blockSizeValue, provider_, importedKey, ivValue, mode, paddingValue, EncryptionMode.Encrypt);
  }

  override ICryptoTransform createDecryptor() {
    if (key_ == Укз.init)
      generateKey();
    return new CAPITransform(blockSizeValue, provider_, key_, ivValue, mode, paddingValue, EncryptionMode.Decrypt);
  }

  override ICryptoTransform createDecryptor(ббайт[] ключ, ббайт[] iv) {
    if (!isValidKeySize(ключ.length * 8))
      throw new ИсклАргумента;

    ббайт[] ivValue = (iv == null) ? null : iv.dup;
    Укз importedKey = importSymmetricKey(provider_, CALG_3DES, ключ.dup);
    return new CAPITransform(blockSizeValue, provider_, importedKey, ivValue, mode, paddingValue, EncryptionMode.Decrypt);
  }

  override проц generateKey() {
    Укз newKey;
    if (!CryptGenKey(provider_, CALG_3DES, CRYPT_EXPORTABLE, newKey))
      throw new CryptoException(GetLastError());

    if (key_ != Укз.init)
      CryptDestroyKey(key_);
    key_ = newKey;
    //скажифнс("CryptGenKey");
  }

  override проц generateIV() {
    ббайт[] iv = new ббайт[8];
    if (!CryptGenRandom(provider_, iv.length, iv.ptr))
      throw new CryptoException(GetLastError());
    ivValue = iv;
  }

  override проц ключ(ббайт[] значение) {
    Укз newKey = importSymmetricKey(provider_, CALG_3DES, значение.dup);
    if (key_ != Укз.init)
      CryptDestroyKey(key_);
    key_ = newKey;
    keySizeValue = значение.length * 8;
  }
  override ббайт[] ключ() {
    if (key_ == Укз.init)
      generateKey();
    return exportSymmetricKey(key_);
  }

  override проц keySize(бцел значение) {
    super.keySize = значение;
    if (key_ != Укз.init)
      CryptDestroyKey(key_);
  }
  override бцел keySize() {
    return super.keySize;
  }

}

/**
 * The base class from which implementations of the $(LINK2 http://en.wikipedia.org/wiki/Advanced_Encryption_Standard, Advanced Encryption Standard) (AES) derive.
 */
abstract class Aes : SymmetricAlgorithm {

  protected this() {
    blockSizeValue = 128;
    keySizeValue = 256;
    legalKeySizesValue = [ new KeySizes(/*min*/ 128, /*max*/ 256, /*step*/ 64) ];
  }

}

/**
 * Provides access to the cryptographic service провайдер implementation of the $(LINK2 http://en.wikipedia.org/wiki/Advanced_Encryption_Standard, AES) algorithm.
 * Examples:
 * ---
 * import win32.security.crypto, win32.base.text, std.stdio;
 *
 * ббайт[] encryptText(ткст text, ббайт[] ключ, ббайт[] iv) {
 *   scope aes = new AesCryptoServiceProvider;
 *
 *   scope ms = new ПотокПамяти;
 *   scope cs = new CryptoStream(ms, aes.createEncryptor(ключ, iv), CryptoStreamMode.Write);
 *
 *   ббайт[] данные = Кодировка.УТФ8.кодируй(text);
 *
 *   cs.пиши(данные);
 *   cs.flushFinalBlock();
 *
 *   ббайт[] ret = ms.данные;
 *
 *   cs.закрой();
 *   ms.закрой();
 *
 *   return ret;
 * }
 *
 * ббайт[] decryptText(ббайт[] данные, ббайт[] ключ, ббайт[] iv) {
 *   scope aes = new AesCryptoServiceProvider;
 *
 *   scope ms = new ПотокПамяти(данные);
 *   scope cs = new CryptoStream(ms, aes.createEncryptor(ключ, iv), CryptoStreamMode.Read);
 *
 *   ббайт[] байты = new ббайт[данные.length];
 *
 *   cs.читай(байты);
 *
 *   return Кодировка.УТФ8.раскодируй(байты);
 * }
 *
 * проц main() {
 *   ткст text = "Some text to encrypt.";
 *
 *   scope aes = new AesCryptoServiceProvider;
 *   ббайт[] данные = encryptText(text, aes.ключ, aes.iv);
 *
 *   text = decryptText(данные, aes.ключ, aes.iv);
 *   скажифнс(text);
 * }
 * ---
 */
final class AesCryptoServiceProvider : Aes {

  private Укз provider_;
  private Укз key_;

  this() {
    /*auto providerName = MS_ENH_RSA_AES_PROV;
    if (версияОс.major == 5 && версияОс.minor == 1)
      providerName = MS_ENH_RSA_AES_PROV_XP;*/
    if (!CryptAcquireContext(provider_, null, null, PROV_RSA_AES, CRYPT_VERIFYCONTEXT))
      throw new CryptoException(GetLastError());
    //скажифнс("CryptAcquireContext");

    PROV_ENUMALGS  enumAlgs;
    бцел enumAlgsSize = PROV_ENUMALGS .sizeof;
    for (цел i = 0; ; i++) {
      if (!CryptGetProvParam(provider_, PP_ENUMALGS, cast(ббайт*)&enumAlgs, enumAlgsSize, (i == 0) ? CRYPT_FIRST : 0)) {
        бцел ошибка = GetLastError();
        if (ошибка == ERROR_NO_MORE_ITEMS)
          break;
        else if (ошибка != ERROR_MORE_DATA)
          throw new CryptoException(ошибка);
      }

      if (enumAlgs.aiAlgid == 0)
        break;

      switch (enumAlgs.aiAlgid) {
        case CALG_AES_128:
          legalKeySizesValue ~= new KeySizes(128, 128, 0);
          if (keySizeValue < 128)
            keySizeValue = 128;
          break;
        case CALG_AES_192:
          legalKeySizesValue ~= new KeySizes(192, 192, 0);
          if (keySizeValue < 192)
            keySizeValue = 192;
          break;
        case CALG_AES_256:
          legalKeySizesValue ~= new KeySizes(256, 256, 0);
          if (keySizeValue < 256)
            keySizeValue = 256;
          break;
        default:
      }
    }
  }

  ~this() {
    dispose();
  }

  проц dispose() {
    if (key_ != Укз.init) {
      CryptDestroyKey(key_);
      key_ = Укз.init;
    }

    if (provider_ != Укз.init) {
      CryptReleaseContext(provider_, 0);
      provider_ = Укз.init;
    }
  }

  override ICryptoTransform createEncryptor() {
    if (key_ == Укз.init)
      generateKey();
    if (mode != CipherMode.ECB && ivValue == null)
      generateIV();
    return new CAPITransform(blockSizeValue, provider_, key_, ivValue, mode, paddingValue, EncryptionMode.Encrypt);
  }

  override ICryptoTransform createEncryptor(ббайт[] ключ, ббайт[] iv) {
    if (!isValidKeySize(ключ.length * 8))
      throw new ИсклАргумента;

    ббайт[] ivValue = (iv == null) ? null : iv.dup;
    Укз importedKey = importSymmetricKey(provider_, algorithmId(ключ.length * 8), ключ.dup);
    return new CAPITransform(blockSizeValue, provider_, importedKey, ivValue, mode, paddingValue, EncryptionMode.Encrypt);
  }

  override ICryptoTransform createDecryptor() {
    if (key_ == Укз.init)
      generateKey();
    return new CAPITransform(blockSizeValue, provider_, key_, ivValue, mode, paddingValue, EncryptionMode.Decrypt);
  }

  override ICryptoTransform createDecryptor(ббайт[] ключ, ббайт[] iv) {
    if (!isValidKeySize(ключ.length * 8))
      throw new ИсклАргумента;

    ббайт[] ivValue = (iv == null) ? null : iv.dup;
    Укз importedKey = importSymmetricKey(provider_, algorithmId(ключ.length * 8), ключ.dup);
    return new CAPITransform(blockSizeValue, provider_, importedKey, ivValue, mode, paddingValue, EncryptionMode.Decrypt);
  }

  override проц generateKey() {
    Укз newKey;
    if (!CryptGenKey(provider_, algorithmId(keySizeValue), CRYPT_EXPORTABLE, newKey))
      throw new CryptoException(GetLastError());

    if (key_ != Укз.init)
      CryptDestroyKey(key_);
    key_ = newKey;
    //скажифнс("CryptGenKey");
  }

  override проц generateIV() {
    ббайт[] iv = new ббайт[blockSizeValue / 8];
    if (!CryptGenRandom(provider_, iv.length, iv.ptr))
      throw new CryptoException(GetLastError());
    ivValue = iv;
  }

  override проц ключ(ббайт[] значение) {
    Укз newKey = importSymmetricKey(provider_, algorithmId(значение.length * 8), значение.dup);
    if (key_ != Укз.init)
      CryptDestroyKey(key_);
    key_ = newKey;
    keySizeValue = значение.length * 8;
  }
  override ббайт[] ключ() {
    if (key_ == Укз.init)
      generateKey();
    return exportSymmetricKey(key_);
  }

  override проц keySize(бцел значение) {
    super.keySize = значение;
    if (key_ != Укз.init)
      CryptDestroyKey(key_);
  }
  override бцел keySize() {
    return super.keySize;
  }

  private static бцел algorithmId(бцел keySize) {
    switch (keySize) {
      case 128: return CALG_AES_128;
      case 192: return CALG_AES_192;
      case 256: return CALG_AES_256;
      default: return 0;
    }
  }

}

// PLAINTEXTKEYBLOB layout:
//   BLOBHEADER hdr
//   бцел cbKey
//   ббайт[cbKey]

private ббайт[] exportSymmetricKey(Укз ключ) {
  бцел cbData;
  if (!CryptExportKey(ключ, Укз.init, PLAINTEXTKEYBLOB, 0, null, cbData))
    throw new CryptoException(GetLastError());

  auto pbData = cast(ббайт*)malloc(cbData);
  if (!CryptExportKey(ключ, Укз.init, PLAINTEXTKEYBLOB, 0, pbData, cbData))
    throw new CryptoException(GetLastError());

  //скажифнс("CryptExportKey");

  ббайт[] keyBuffer = new ббайт[*cast(бцел*)(pbData + BLOBHEADER.sizeof)];
  memmove(keyBuffer.ptr, pbData + BLOBHEADER.sizeof + бцел.sizeof, keyBuffer.length);
  free(pbData);
  return keyBuffer;
}

private Укз importSymmetricKey(Укз провайдер, бцел algorithm, ббайт[] ключ) {
  бцел cbData = BLOBHEADER.sizeof + бцел.sizeof + ключ.length;
  auto pbData = cast(ббайт*)malloc(cbData);

  auto pBlob = cast(BLOBHEADER*)pbData;
  pBlob.bType = PLAINTEXTKEYBLOB;
  pBlob.bVersion = CUR_BLOB_VERSION;
  pBlob.reserved = 0;
  pBlob.aiKeyAlg = algorithm;

  *(cast(бцел*)pbData + BLOBHEADER.sizeof) = ключ.length;
  memmove(pbData + BLOBHEADER.sizeof + бцел.sizeof, ключ.ptr, ключ.length);

  Укз importedKey;
  if (!CryptImportKey(провайдер, pbData, cbData, Укз.init, CRYPT_EXPORTABLE, importedKey))
    throw new CryptoException(GetLastError());

  //скажифнс("CryptImportKey");

  free(pbData);
  return importedKey;
}

/**
 */
abstract class Rsa : AsymmetricAlgorithm {

  protected this() {
  }

}

private static ткст[ткст] nameToHash;

static this() {
  nameToHash = [
    "MD5"[]: "win32.security.crypto.Md5CryptoServiceProvider"[],
    "SHA1": "win32.security.crypto.Sha1CryptoServiceProvider",
    "SHA256": "win32.security.crypto.Sha256CryptoServiceProvider",
    "SHA384": "win32.security.crypto.Sha384CryptoServiceProvider",
    "SHA512": "win32.security.crypto.Sha512CryptoServiceProvider"
  ];
}

private HashAlgorithm nameToHashAlgorithm(ткст algorithm) {
  if (auto значение = algorithm.вЗаг() in nameToHash) {
    return cast(HashAlgorithm)Объект.factory(*значение);
  }
  return null;
}

private бцел oidToAlgId(ткст oid) {
  CRYPT_OID_INFO oidInfo;
  if (auto pOidInfo = CryptFindOIDInfo(CRYPT_OID_INFO_OID_KEY, oid.вУтф8н(), 0))
    oidInfo = *pOidInfo;
  бцел algId = oidInfo.Algid;
  // Default to SHA1
  if (algId == 0)
    algId = CALG_SHA1;
  // The following not reported by CAPI
  else if (oid == "2.16.840.1.101.3.4.2.1")
    algId = CALG_SHA_256;
  else if (oid == "2.16.840.1.101.3.4.2.2")
    algId = CALG_SHA_384;
  else if (oid == "2.16.840.1.101.3.4.2.3")
    algId = CALG_SHA_512;
  return algId;
}

struct RsaParameters {

  ббайт[] exponent;
  ббайт[] modulus;
  ббайт[] p;
  ббайт[] q;
  ббайт[] dp;
  ббайт[] dq;
  ббайт[] inverseq;
  ббайт[] d;

}

/**
 */
final class RsaCryptoServiceProvider : Rsa {

  private Укз provider_;
  private Укз key_;
  private бцел keySize_;

  ~this() {
    dispose();
  }

  проц dispose() {
    if (key_ != Укз.init) {
      CryptDestroyKey(key_);
      key_ = Укз.init;
    }

    if (provider_ != Укз.init) {
      CryptReleaseContext(provider_, 0);
      provider_ = Укз.init;
    }
  }

  ///
  проц importKeyBlob(ббайт[] keyBlob) {
    if (provider_ != Укз.init) {
      CryptReleaseContext(provider_, 0);
      provider_ = Укз.init;
    }

    if (provider_ == Укз.init) {
      if (!CryptAcquireContext(provider_, null, MS_ENHANCED_PROV, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT))
        throw new CryptoException(GetLastError());
    }

    Укз exchangeKey;
    /*if (!CryptGetUserKey(provider_, AT_KEYEXCHANGE, exchangeKey)) {
      if (!CryptGenKey(provider_, AT_KEYEXCHANGE, CRYPT_EXPORTABLE, exchangeKey))
        throw new CryptoException(GetLastError());
    }
    scope(exit) {
      if (exchangeKey != Укз.init)
        CryptDestroyKey(exchangeKey);
    }*/

    // Layout of keyBlob:
    //   BLOBHEADER
    //   RSAPUBKEY
    бул isPublic = true;
    if (keyBlob[0] != PUBLICKEYBLOB)
      isPublic = false;
    if (keyBlob[8] != 'R' || keyBlob[9] != 'S' || keyBlob[10] != 'A' || keyBlob[11] != '1')
      isPublic = false;

    if (isPublic) {
      if (!CryptImportKey(provider_, keyBlob.ptr, keyBlob.length, exchangeKey, CRYPT_EXPORTABLE, key_))
        throw new CryptoException(GetLastError());
    }
    else {
    }
  }

  ///
  ббайт[] exportKeyBlob(бул includePrivateParameters) {
    ensureKeyPair();

    Укз exchangeKey;
    /*if (includePrivateParameters) {
      if (!CryptGetUserKey(provider_, AT_KEYEXCHANGE, exchangeKey)) {
        if (!CryptGenKey(provider_, AT_KEYEXCHANGE, CRYPT_EXPORTABLE, exchangeKey))
          throw new CryptoException(GetLastError());
      }
    }
    scope(exit) {
      if (exchangeKey != Укз.init)
        CryptDestroyKey(exchangeKey);
    }*/

    бцел cbData;
    if (!CryptExportKey(key_, exchangeKey, includePrivateParameters ? PRIVATEKEYBLOB : PUBLICKEYBLOB, 0, null, cbData))
      throw new CryptoException(GetLastError());

    auto pbData = cast(ббайт*)malloc(cbData);
    if (!CryptExportKey(key_, exchangeKey, includePrivateParameters ? PRIVATEKEYBLOB : PUBLICKEYBLOB, 0, pbData, cbData))
      throw new CryptoException(GetLastError());
    scope(exit) free(pbData);

    return pbData[0 .. cbData].dup;
  }

  /+RsaParameters exportParameters(бул includePrivateParameters) {
    ensureKeyPair();

    Укз exchangeKey;
    /*if (includePrivateParameters) {
      if (!CryptGetUserKey(provider_, AT_KEYEXCHANGE, exchangeKey)) {
        if (!CryptGenKey(provider_, AT_KEYEXCHANGE, CRYPT_EXPORTABLE, exchangeKey))
          throw new CryptoException(GetLastError());
      }
    }
    scope(exit) {
      if (exchangeKey != Укз.init)
        CryptDestroyKey(exchangeKey);
    }*/

    // Currently failing if includePrivateParameters is true and the ключ was imported from importKeyBlob.

    бцел cbData;
    if (!CryptExportKey(key_, exchangeKey, includePrivateParameters ? PRIVATEKEYBLOB : PUBLICKEYBLOB, 0, null, cbData))
      throw new CryptoException(GetLastError());

    auto pbData = cast(ббайт*)malloc(cbData);
    if (!CryptExportKey(key_, exchangeKey, includePrivateParameters ? PRIVATEKEYBLOB : PUBLICKEYBLOB, 0, pbData, cbData))
      throw new CryptoException(GetLastError());
    scope(exit) free(pbData);

    /*
      PUBLICKEYBLOB:

      BLOBHEADER hdr
      RSAPUBKEY rsapubkey
      BYTE modulus[rsapubkey.bitlen / 8]
    */

    auto pbKey = pbData + BLOBHEADER.sizeof;
    бцел bitLen = *cast(бцел*)(pbKey + бцел.sizeof);

    RsaParameters rsap;
    rsap.exponent.length = 3;
    memmove(rsap.exponent.ptr, pbKey + (бцел.sizeof * 2), rsap.exponent.length);
    rsap.exponent.реверсни;
    rsap.modulus.length = bitLen / 8;
    memmove(rsap.modulus.ptr, pbKey + RSAPUBKEY.sizeof, rsap.modulus.length);
    rsap.modulus.реверсни;

    /*
      PRIVATEKEYBLOB:

      BLOBHEADER hdr
      RSAPUBKEY rsapubkey
      BYTE modulus[rsapubkey.bitlen / 8]
      BYTE prime1[rsapubkey.bitlen / 16]
      BYTE prime2[rsapubkey.bitlen / 16]
      BYTE exponent1[rsapubkey.bitlen / 16]
      BYTE exponent2[rsapubkey.bitlen / 16]
      BYTE coefficient[rsapubkey.bitlen / 16]
      BYTE privateExponent[rsapubkey.bitlen / 8]
    */
    if (includePrivateParameters) {
      pbKey += RSAPUBKEY.sizeof + rsap.modulus.length;
      rsap.p.length = bitLen / 16;
      memmove(rsap.p.ptr, pbKey, rsap.p.length);
      rsap.p.реверсни;

      pbKey += rsap.p.length;
      rsap.q.length = bitLen / 16;
      memmove(rsap.q.ptr, pbKey, rsap.q.length);
      rsap.q.реверсни;

      pbKey += rsap.q.length;
      rsap.dp.length = bitLen / 16;
      memmove(rsap.dp.ptr, pbKey, rsap.dp.length);
      rsap.dp.реверсни;

      pbKey += rsap.dp.length;
      rsap.dq.length = bitLen / 16;
      memmove(rsap.dq.ptr, pbKey, rsap.dq.length);
      rsap.dq.реверсни;

      pbKey += rsap.dq.length;
      rsap.inverseq.length = bitLen / 16;
      memmove(rsap.inverseq.ptr, pbKey, rsap.inverseq.length);
      rsap.inverseq.реверсни;

      pbKey += rsap.inverseq.length;
      rsap.d.length = bitLen / 8;
      memmove(rsap.d.ptr, pbKey, rsap.d.length);
      rsap.d.реверсни;
    }

    return rsap;
  }+/

  ///
  ббайт[] encrypt(ббайт[] rgb, бул useOAEP) {
    ensureKeyPair();

    бцел cb = rgb.length;
    if (!CryptEncrypt(key_, Укз.init, TRUE, useOAEP ? CRYPT_OAEP : 0, null, cb, rgb.length))
      throw new CryptoException(GetLastError());

    auto encryptedData = new ббайт[cb];
    encryptedData[0 .. rgb.length] = rgb;

    cb = rgb.length;
    if (!CryptEncrypt(key_, Укз.init, TRUE, useOAEP ? CRYPT_OAEP : 0, encryptedData.ptr, cb, encryptedData.length))
      throw new CryptoException(GetLastError());

    return encryptedData;
  }

  ///
  ббайт[] decrypt(ббайт[] rgb, бул useOAEP) {
    ensureKeyPair();

    бцел cb = rgb.length;
    if (!CryptDecrypt(key_, Укз.init, TRUE, useOAEP ? CRYPT_OAEP : 0, null, cb))
      throw new CryptoException(GetLastError());

    auto decryptedData = new ббайт[cb];
    decryptedData[0 .. rgb.length] = rgb;

    cb = rgb.length;
    if (!CryptDecrypt(key_, Укз.init, TRUE, useOAEP ? CRYPT_OAEP : 0, decryptedData.ptr, cb))
      throw new CryptoException(GetLastError());
    return decryptedData;
  }

  ///
  ббайт[] signData(ббайт[] буфер, бцел смещение, бцел счёт, ткст algorithm) {
    CRYPT_OID_INFO oidInfo;
    if (auto pOidInfo = CryptFindOIDInfo(CRYPT_OID_INFO_NAME_KEY, algorithm.вУтф16н(), 0))
      oidInfo = *pOidInfo;
    ткст oid = вУтф8(oidInfo.pszOID);

    scope hashAlgorithm = nameToHashAlgorithm(algorithm);
    ббайт[] hash = hashAlgorithm.computeHash(буфер, смещение, счёт);
    return signHash(hash, oid);
  }

  /// ditto
  ббайт[] signData(ббайт[] буфер, ткст algorithm) {
    return signData(буфер, 0, буфер.length, algorithm);
  }

  /// ditto
  ббайт[] signData(Поток ввод, ткст algorithm) {
    CRYPT_OID_INFO oidInfo;
    if (auto pOidInfo = CryptFindOIDInfo(CRYPT_OID_INFO_NAME_KEY, algorithm.вУтф16н(), 0))
      oidInfo = *pOidInfo;
    ткст oid = вУтф8(oidInfo.pszOID);

    scope hashAlgorithm = nameToHashAlgorithm(algorithm);
    ббайт[] hash = hashAlgorithm.computeHash(ввод);
    return signHash(hash, oid);
  }

  ///
  ббайт[] signHash(ббайт[] hash, ткст oid) {
    ensureKeyPair();

    Укз tempHash;
    if (!CryptCreateHash(provider_, oidToAlgId(oid), Укз.init, 0, tempHash))
      throw new CryptoException(GetLastError());
    scope(exit) CryptDestroyHash(tempHash);

    бцел cbSignature;
    if (!CryptSignHash(tempHash, AT_KEYEXCHANGE, null, 0, null, cbSignature)) {
      бцел lastError = GetLastError();
      if (lastError != ERROR_MORE_DATA)
        throw new CryptoException(lastError);
    }

    auto signature = new ббайт[cbSignature];
    if (!CryptSignHash(tempHash, AT_KEYEXCHANGE, null, 0, signature.ptr, cbSignature))
      throw new CryptoException(GetLastError());

    return signature;
  }

  ///
  бул verifyData(ббайт[] данные, ткст algorithm, ббайт[] signature) {
    return verifyData(данные, 0, данные.length, algorithm, signature);
  }

  ///
  бул verifyData(ббайт[] данные, бцел смещение, бцел счёт, ткст algorithm, ббайт[] signature) {
    CRYPT_OID_INFO oidInfo;
    if (auto pOidInfo = CryptFindOIDInfo(CRYPT_OID_INFO_NAME_KEY, algorithm.вУтф16н(), 0))
      oidInfo = *pOidInfo;
    ткст oid = вУтф8(oidInfo.pszOID);

    scope hashAlgorithm = nameToHashAlgorithm(algorithm);
    ббайт[] hash = hashAlgorithm.computeHash(данные, смещение, счёт);
    return verifyHash(hash, oid, signature);
  }

  ///
  бул verifyData(Поток данные, ткст algorithm, ббайт[] signature) {
    CRYPT_OID_INFO oidInfo;
    if (auto pOidInfo = CryptFindOIDInfo(CRYPT_OID_INFO_NAME_KEY, algorithm.вУтф16н(), 0))
      oidInfo = *pOidInfo;
    ткст oid = вУтф8(oidInfo.pszOID);

    scope hashAlgorithm = nameToHashAlgorithm(algorithm);
    ббайт[] hash = hashAlgorithm.computeHash(данные);
    return verifyHash(hash, oid, signature);
  }

  ///
  бул verifyHash(ббайт[] hash, ткст oid, ббайт[] signature) {
    ensureKeyPair();

    CRYPT_OID_INFO oidInfo;
    if (auto pOidInfo = CryptFindOIDInfo(CRYPT_OID_INFO_OID_KEY, oid.вУтф8н(), 0))
      oidInfo = *pOidInfo;

    Укз tempHash;
    if (!CryptCreateHash(provider_, oidInfo.Algid, Укз.init, 0, tempHash))
      throw new CryptoException(GetLastError());
    scope(exit) CryptDestroyHash(tempHash);

    if (!CryptVerifySignature(tempHash, hash.ptr, hash.length, key_, null, 0)) {
      бцел lastError = GetLastError();
      if (lastError != NTE_BAD_SIGNATURE)
        throw new CryptoException(lastError);
      return false;
    }
    return true;
  }

  override бцел keySize() {
    ensureKeyPair();

    бцел cbKeySize = бцел.sizeof;
    if (!CryptGetKeyParam(key_, KP_KEYLEN, cast(ббайт*)&keySize_, cbKeySize, 0))
        throw new CryptoException(GetLastError());
    return keySize_;
  }

  override ткст keyExchangeAlgorithm() {
    return "RSA-PKCS1-KeyEx";
  }

  override ткст signatureAlgorithm() {
    return "http://www.w3.org/2000/09/xmldsig#rsa-sha1";
  }

  private проц ensureKeyPair() {
    if (key_ != Укз.init)
      return;

    if (provider_ == Укз.init) {
      if (!CryptAcquireContext(provider_, null, MS_ENHANCED_PROV, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT))
        throw new CryptoException(GetLastError());
    }

    if (!CryptGetUserKey(provider_, AT_KEYEXCHANGE, key_)) {
      if (!CryptGenKey(provider_, AT_KEYEXCHANGE, CRYPT_EXPORTABLE, key_))
        throw new CryptoException(GetLastError());
    }
  }

}

/**
 */
abstract class Dsa : AsymmetricAlgorithm {

  ///
  abstract ббайт[] createSignature(ббайт[] hash);

  ///
  abstract бул verifySignature(ббайт[] hash, ббайт[] signature);

}

/**
 */
final class DsaCryptoServiceProvider : Dsa {

  private Укз provider_;
  private Укз key_;
  private бцел keySize_;
  private Sha1CryptoServiceProvider hashAlgorithm_;

  this() {
    hashAlgorithm_ = new Sha1CryptoServiceProvider;
  }

  ~this() {
    dispose();
  }

  проц dispose() {
    if (hashAlgorithm_ !is null) {
      hashAlgorithm_.dispose();
      hashAlgorithm_ = null;
    }

    if (key_ != Укз.init) {
      CryptDestroyKey(key_);
      key_ = Укз.init;
    }

    if (provider_ != Укз.init) {
      CryptReleaseContext(provider_, 0);
      provider_ = Укз.init;
    }
  }

  override ббайт[] createSignature(ббайт[] hash) {
    return signHash(hash, null);
  }

  override бул verifySignature(ббайт[] hash, ббайт[] signature) {
    return verifyHash(hash, null, signature);
  }

  ///
  проц importKeyBlob(ббайт[] keyBlob) {
    if (provider_ != Укз.init) {
      CryptReleaseContext(provider_, 0);
      provider_ = Укз.init;
    }

    if (provider_ == Укз.init) {
      if (!CryptAcquireContext(provider_, null, MS_DEF_DSS_DH_PROV, PROV_DSS_DH, CRYPT_VERIFYCONTEXT))
        throw new CryptoException(GetLastError());
    }

    // Layout of keyBlob:
    //   BLOBHEADER
    //   DSSPUBKEY
    бул isPublic = true;
    if (keyBlob[0] != PUBLICKEYBLOB)
      isPublic = false;
    if (keyBlob[8] != 'D' || keyBlob[9] != 'S' || keyBlob[10] != 'S' || (keyBlob[11] != '1' && keyBlob[11] != '3'))
      isPublic = false;

    if (isPublic) {
      if (!CryptImportKey(provider_, keyBlob.ptr, keyBlob.length, Укз.init, /*CRYPT_EXPORTABLE*/ 0, key_))
        throw new CryptoException(GetLastError());
    }
    else {
    }
  }

  ///
  ббайт[] exportKeyBlob(бул includePrivateParameters) {
    ensureKeyPair();

    бцел cbData;
    if (!CryptExportKey(key_, Укз.init, includePrivateParameters ? PRIVATEKEYBLOB : PUBLICKEYBLOB, 0, null, cbData))
      throw new CryptoException(GetLastError());

    auto pbData = cast(ббайт*)malloc(cbData);
    if (!CryptExportKey(key_, Укз.init, includePrivateParameters ? PRIVATEKEYBLOB : PUBLICKEYBLOB, 0, pbData, cbData))
      throw new CryptoException(GetLastError());
    scope(exit) free(pbData);

    return pbData[0 .. cbData].dup;
  }

  ///
  ббайт[] signData(ббайт[] буфер, бцел смещение, бцел счёт) {
    ббайт[] hash = hashAlgorithm_.computeHash(буфер, смещение, счёт);
    return signHash(hash, null);
  }

  /// ditto
  ббайт[] signData(ббайт[] буфер) {
    return signData(буфер, 0, буфер.length);
  }

  /// ditto
  ббайт[] signData(Поток ввод) {
    ббайт[] hash = hashAlgorithm_.computeHash(ввод);
    return signHash(hash, null);
  }

  ///
  ббайт[] signHash(ббайт[] hash, ткст oid) {
    ensureKeyPair();

    Укз tempHash;
    if (!CryptCreateHash(provider_, oidToAlgId(oid), Укз.init, 0, tempHash))
      throw new CryptoException(GetLastError());
    scope(exit) CryptDestroyHash(tempHash);

    бцел cbSignature;
    if (!CryptSignHash(tempHash, AT_SIGNATURE, null, 0, null, cbSignature)) {
      бцел lastError = GetLastError();
      if (lastError != ERROR_MORE_DATA)
        throw new CryptoException(lastError);
    }

    auto signature = new ббайт[cbSignature];
    if (!CryptSignHash(tempHash, AT_SIGNATURE, null, 0, signature.ptr, cbSignature))
      throw new CryptoException(GetLastError());

    return signature;
  }

  ///
  бул verifyData(ббайт[] данные, ббайт[] signature) {
    return verifyData(данные, 0, данные.length, signature);
  }

  /// ditto
  бул verifyData(ббайт[] данные, бцел смещение, бцел счёт, ббайт[] signature) {
    ббайт[] hash = hashAlgorithm_.computeHash(данные, смещение, счёт);
    return verifyHash(hash, null, signature);
  }

  /// ditto
  бул verifyData(Поток данные, ббайт[] signature) {
    ббайт[] hash = hashAlgorithm_.computeHash(данные);
    return verifyHash(hash, null, signature);
  }

  ///
  бул verifyHash(ббайт[] hash, ткст oid, ббайт[] signature) {
    ensureKeyPair();

    CRYPT_OID_INFO oidInfo;
    if (auto pOidInfo = CryptFindOIDInfo(CRYPT_OID_INFO_OID_KEY, oid.вУтф8н(), 0))
      oidInfo = *pOidInfo;

    Укз tempHash;
    if (!CryptCreateHash(provider_, oidInfo.Algid, Укз.init, 0, tempHash))
      throw new CryptoException(GetLastError());
    scope(exit) CryptDestroyHash(tempHash);

    if (!CryptVerifySignature(tempHash, hash.ptr, hash.length, key_, null, 0)) {
      бцел lastError = GetLastError();
      if (lastError != NTE_BAD_SIGNATURE)
        throw new CryptoException(lastError);
      return false;
    }
    return true;
  }

  override бцел keySize() {
    ensureKeyPair();

    бцел cbKeySize = бцел.sizeof;
    if (!CryptGetKeyParam(key_, KP_KEYLEN, cast(ббайт*)&keySize_, cbKeySize, 0))
        throw new CryptoException(GetLastError());
    return keySize_;
  }

  override ткст keyExchangeAlgorithm() {
    return null;
  }

  override ткст signatureAlgorithm() {
    return "http://www.w3.org/2000/09/xmldsig#dsa-sha1";
  }

  private проц ensureKeyPair() {
    if (key_ != Укз.init)
      return;

    if (provider_ == Укз.init) {
      if (!CryptAcquireContext(provider_, null, MS_DEF_DSS_DH_PROV, PROV_DSS_DH, CRYPT_VERIFYCONTEXT))
        throw new CryptoException(GetLastError());
    }

    if (!CryptGetUserKey(provider_, AT_SIGNATURE, key_)) {
      if (!CryptGenKey(provider_, AT_SIGNATURE, CRYPT_EXPORTABLE, key_))
        throw new CryptoException(GetLastError());
    }
  }

}

private final class CAPITransform : ICryptoTransform {

  private бцел blockSize_;
  private Укз provider_;
  private Укз key_;
  private PaddingMode paddingMode_;
  private EncryptionMode encryptionMode_;
  private ббайт[] depadBuffer_;

  this(бцел blockSize, Укз провайдер, Укз ключ, ббайт[] iv, CipherMode cipherMode, PaddingMode paddingMode, EncryptionMode encryptionMode) {
    blockSize_ = blockSize;
    provider_ = провайдер;
    key_ = ключ;
    paddingMode_ = paddingMode;
    encryptionMode_ = encryptionMode;

    if (iv == null) {
      if (cipherMode != CipherMode.ECB)
        throw new CryptoException("The cipher mode specified requires that an initialization vector be used.");
    }

    if (!CryptSetKeyParam(ключ, KP_MODE, cast(ббайт*)&cipherMode, 0))
      throw new CryptoException(GetLastError());

    if (cipherMode != CipherMode.ECB) {
      if (!CryptSetKeyParam(ключ, KP_IV, iv.ptr, 0))
        throw new CryptoException(GetLastError());
    }
  }

  ~this() {
    if (key_ != Укз.init) {
      CryptDestroyKey(key_);
      key_ = Укз.init;
    }
  }

  private бцел encryptBlocks(ббайт[] буфер, бцел смещение, бцел счёт) {
    бцел length = счёт;
    if (!CryptEncrypt(key_, Укз.init, FALSE, 0, буфер.ptr + смещение, length, буфер.length))
      throw new CryptoException(GetLastError());
    //скажифнс("CryptEncrypt");
    return length;
  }

  private бцел decryptBlocks(ббайт[] буфер, бцел смещение, бцел счёт) {
    бцел length = счёт;
    if (!CryptDecrypt(key_, Укз.init, FALSE, 0, буфер.ptr + смещение, length))
      throw new CryptoException(GetLastError());
    return length;
  }

  бцел transformBlock(ббайт[] inputBuffer, бцел inputOffset, бцел inputCount, ббайт[] outputBuffer, бцел outputOffset) {
    //скажифнс("transformBlock");
    if (encryptionMode_ == EncryptionMode.Encrypt) {
      //memmove(outputBuffer.ptr + outputOffset, inputBuffer.ptr + inputOffset, inputCount);
      blockCopy(inputBuffer, inputOffset, outputBuffer, outputOffset, inputCount);
      return encryptBlocks(outputBuffer, outputOffset, inputCount);
    }
    else {
      бцел n;
      if (paddingMode_ != PaddingMode.None && paddingMode_ != PaddingMode.Zeros) {
        if (depadBuffer_ == null) {
          depadBuffer_.length = inputBlockSize;
        }
        else {
          бцел c = decryptBlocks(depadBuffer_, 0, depadBuffer_.length);
          //memmove(outputBuffer.ptr + outputOffset, depadBuffer_.ptr, c);
          blockCopy(depadBuffer_, 0, outputBuffer, outputOffset, c);
          depadBuffer_[] = 0;
          outputOffset += c;
          n += c;
        }
        //memmove(depadBuffer_.ptr, inputBuffer.ptr + (inputOffset - inputCount) + depadBuffer_.length, depadBuffer_.length);
        blockCopy(inputBuffer, (inputOffset - inputCount) + depadBuffer_.length, depadBuffer_, 0, depadBuffer_.length);
        inputCount -= depadBuffer_.length;
      }

      if (inputCount > 0) {
        //memmove(outputBuffer.ptr + outputOffset, inputBuffer.ptr + inputOffset, inputCount);
        blockCopy(inputBuffer, inputOffset, outputBuffer, outputOffset, inputCount);
        n += decryptBlocks(outputBuffer, outputOffset, inputCount);
      }
      return n;
    }
  }

  ббайт[] transformFinalBlock(ббайт[] inputBuffer, бцел inputOffset, бцел inputCount) {

    ббайт[] padBlock(ббайт[] block, бцел смещение, бцел счёт) {
      assert(block != null && счёт <= block.length - смещение);

      ббайт[] байты;
      бцел padding = inputBlockSize - (счёт % inputBlockSize);
      switch (paddingMode_) {
        case PaddingMode.None:
          байты.length = счёт;
          байты[0 .. счёт] = block[смещение .. счёт];
          break;

        case PaddingMode.PKCS7:
          байты.length = счёт + padding;
          байты[0 .. счёт] = block[смещение .. счёт];
          байты[счёт .. $] = cast(ббайт)padding;
          break;

        case PaddingMode.Zeros:
          if (padding == inputBlockSize)
            padding = 0;
          байты.length = счёт + padding;
          байты[0 .. счёт] = block[смещение .. счёт];
          break;

        case PaddingMode.ANSIX923:
          байты.length = счёт + padding;
          байты[0 .. счёт] = block[0 .. счёт];
          байты[$ - 1] = cast(ббайт)padding;
          break;

        case PaddingMode.ISO10126:
          байты.length = счёт + padding;
          CryptGenRandom(provider_, байты.length - 1, байты.ptr);
          байты[0 .. счёт] = block[0 .. счёт];
          байты[$ - 1] = cast(ббайт)padding;
          break;

        default:
          throw new CryptoException("Unknown padding mode.");
      }
      return байты;
    }

    ббайт[] depadBlock(ббайт[] block, бцел смещение, бцел счёт) {
      assert(block != null && счёт >= block.length - смещение);

      бцел padding;
      switch (paddingMode_) {
        case PaddingMode.None, PaddingMode.Zeros:
          padding = 0;
          break;

        case PaddingMode.PKCS7:
          padding = cast(бцел)block[смещение + счёт - 1];
          if (0 > padding || padding > inputBlockSize)
            throw new CryptoException("Padding is invalid.");

          for (бцел i = смещение + счёт - padding; i < смещение + счёт; i++) {
            if (block[i] != cast(ббайт)padding)
              throw new CryptoException("Padding is invalid");
          }
          break;

        case PaddingMode.ANSIX923:
          padding = cast(бцел)block[смещение + счёт - 1];
          if (0 > padding || padding > inputBlockSize)
            throw new CryptoException("Padding is invalid.");

          for (бцел i = смещение + счёт - padding; i < смещение + счёт - 1; i++) {
            if (block[i] != 0)
              throw new CryptoException("Padding is invalid.");
          }
          break;

        case PaddingMode.ISO10126:
          padding = cast(бцел)block[смещение + счёт - 1];
          if (0 > padding || padding > inputBlockSize)
            throw new CryptoException("Padding is invalid.");
          break;

        default:
          throw new CryptoException("Unknown padding mode.");
      }

      //win32.io.core.Консоль.пишинс(cast(цел)(счёт - padding));
      return block[смещение .. счёт - padding];
    }

    //скажифнс("transformFinalBlock");
    ббайт[] finalBytes;

    if (encryptionMode_ == EncryptionMode.Encrypt) {
      /*бцел padding = inputBlockSize - (inputCount % inputBlockSize);
      байты.length = inputCount + padding;
      memmove(байты.ptr, inputBuffer.ptr + inputOffset, inputCount);*/
      finalBytes = padBlock(inputBuffer, inputOffset, inputCount);
      if (finalBytes.length > 0)
        encryptBlocks(finalBytes, 0, finalBytes.length);
    }
    else {
      ббайт[] времн;
      if (depadBuffer_ == null) {
        времн.length = inputCount;
        //memmove(времн.ptr, inputBuffer.ptr + inputOffset, inputCount);
        blockCopy(inputBuffer, inputOffset, времн, 0, inputCount);
      }
      else {
        времн.length = depadBuffer_.length + inputCount;
        //memmove(времн.ptr, depadBuffer_.ptr, depadBuffer_.length);
        blockCopy(depadBuffer_, 0, времн, 0, depadBuffer_.length);
        //memmove(времн.ptr + depadBuffer_.length, inputBuffer.ptr + inputOffset, inputCount);
        blockCopy(inputBuffer, inputOffset, времн, depadBuffer_.length, inputCount);
      }
      if (времн.length > 0) {
        бцел c = decryptBlocks(времн, 0, времн.length);
        finalBytes = depadBlock(времн, 0, c);
      }
    }

    ббайт[] времн = new ббайт[outputBlockSize];
    бцел счёт = 0;
    if (encryptionMode_ == EncryptionMode.Encrypt)
      CryptEncrypt(key_, Укз.init, TRUE, 0, времн.ptr, счёт, времн.length);
    else
      CryptDecrypt(key_, Укз.init, TRUE, 0, времн.ptr, счёт);
    delete времн;

    depadBuffer_ = null;

    return finalBytes;
  }

  /*ббайт[] transformFinalBlock(ббайт[] буфер) {
    ббайт[] вывод;

    if (encryptionMode_ == EncryptionMode.Encrypt) {
      вывод = new ббайт[inputBlockSize];
      memmove(вывод.ptr, буфер.ptr, буфер.length);

      бцел счёт = вывод.length;
      if (!CryptEncrypt(key_, Укз.init, FALSE, 0, вывод.ptr, счёт, вывод.length))
        throw new CryptoException(GetLastError());

      скажифнс("CryptEncrypt");
    }
    else {
      вывод = new ббайт[outputBlockSize];
      memmove(вывод.ptr, буфер.ptr, буфер.length);

      бцел счёт = вывод.length;
      if (!CryptDecrypt(key_, Укз.init, FALSE, 0, вывод.ptr, счёт))
        throw new CryptoException(GetLastError());

      скажифнс("CryptDecrypt");
    }

    ббайт[] времн = new ббайт[outputBlockSize];
    бцел счёт = 0;
    if (encryptionMode_ == EncryptionMode.Encrypt)
      CryptEncrypt(key_, Укз.init, TRUE, 0, времн.ptr, счёт, времн.length);
    else
      CryptDecrypt(key_, Укз.init, TRUE, 0, времн.ptr, счёт);
    delete времн;

    return вывод;
  }*/

  бцел inputBlockSize() {
    return blockSize_ / 8;
  }

  бцел outputBlockSize() {
    return blockSize_ / 8;
  }

}

/**
 * Реализует a cryptographic random число generator используя the implementation provided by the cryptographic service провайдер.
 */
final class RngCryptoServiceProvider : RandomNumberGenerator {

  private Укз provider_;

  this() {
    if (!CryptAcquireContext(provider_, null, null, PROV_RSA_FULL, 0)) {
      if (!CryptAcquireContext(provider_, null, null, PROV_RSA_FULL, CRYPT_NEWKEYSET))
        throw new CryptoException(GetLastError());
    }
  }

  ~this() {
    if (provider_ != Укз.init) {
      CryptReleaseContext(provider_, 0);
      provider_ = Укз.init;
    }
  }

  override проц getBytes(ббайт[] данные) {
    if (!CryptGenRandom(provider_, данные.length, данные.ptr))
      throw new CryptoException(GetLastError());
  }

  override проц getNonZeroBytes(ббайт[] данные) {
    ббайт[] времн = new ббайт[данные.length * 2];
    бцел i;
    while (i < данные.length) {
      getBytes(времн);
      foreach (j, b; времн) {
        if (i == данные.length)
          break;
        if (b != 0)
          данные[i++] = b;
      }
    }
  }

}

/**
 * Provides a CNG (Cryptography Next Generation) implementation of a cryptographic random число generator.
 */
final class RngCng : RandomNumberGenerator {

  private Укз algorithm_;

  this() {
    if (!bcryptSupported)
      throw new ИсклНеПоддерживается("The specified cryptographic operation is not supported on this platform.");

    цел r = BCryptOpenAlgorithmProvider(&algorithm_, BCRYPT_RNG_ALGORITHM, MS_PRIMITIVE_PROVIDER, 0);
    if (r != ERROR_SUCCESS)
      throw new CryptoException(r);
  }

  ~this() {
    if (algorithm_ != Укз.init) {
      BCryptCloseAlgorithmProvider(algorithm_, 0);
      algorithm_ = Укз.init;
    }
  }

  override проц getBytes(ббайт[] данные) {
    цел r = BCryptGenRandom(algorithm_, данные.ptr, данные.length, 0);
    if (r != ERROR_SUCCESS)
      throw new CryptoException(r);
  }

  override проц getNonZeroBytes(ббайт[] данные) {
    ббайт[] времн = new ббайт[данные.length * 2];
    бцел i;
    while (i < данные.length) {
      getBytes(времн);
      foreach (j, b; времн) {
        if (i == данные.length)
          break;
        if (b != 0)
          данные[i++] = b;
      }
    }
  }

}

/**
 */
enum DataProtectionScope {
  CurrentUser,
  LocalMachine
}

/**
 * Protects userData and returns an array representing the encrypted данные.
 */
ббайт[] protectData(ббайт[] userData, ббайт[] optionalEntropy, DataProtectionScope protectionScope) {
  DATA_BLOB dataBlob, entropyBlob, resultBlob;

  dataBlob = DATA_BLOB(userData.length, userData.ptr);
  if (optionalEntropy != null)
    entropyBlob = DATA_BLOB(optionalEntropy.length, optionalEntropy.ptr);

  бцел флаги = CRYPTPROTECT_UI_FORBIDDEN;
  if (protectionScope == DataProtectionScope.LocalMachine)
    флаги |= CRYPTPROTECT_LOCAL_MACHINE;

  if (!CryptProtectData(&dataBlob, null, &entropyBlob, null, null, флаги, &resultBlob))
    throw new CryptoException(GetLastError());

  scope(exit) {
    if (resultBlob.pbData != null)
      LocalFree(resultBlob.pbData);
  }

  return resultBlob.pbData[0 .. resultBlob.cbData].dup;
}

/**
 * Unprotects protectedData and returns an array representing the unprotected данные.
 */
ббайт[] unprotectData(ббайт[] protectedData, ббайт[] optionalEntropy, DataProtectionScope protectionScope) {
  DATA_BLOB dataBlob, entropyBlob, resultBlob;

  dataBlob = DATA_BLOB(protectedData.length, protectedData.ptr);
  if (optionalEntropy != null)
    entropyBlob = DATA_BLOB(optionalEntropy.length, optionalEntropy.ptr);

  бцел флаги = CRYPTPROTECT_UI_FORBIDDEN;
  if (protectionScope == DataProtectionScope.LocalMachine)
    флаги |= CRYPTPROTECT_LOCAL_MACHINE;

  if (!CryptUnprotectData(&dataBlob, null, &entropyBlob, null, null, флаги, &resultBlob))
    throw new CryptoException(GetLastError());

  scope(exit) {
    if (resultBlob.pbData != null)
      LocalFree(resultBlob.pbData);
  }

  return resultBlob.pbData[0 .. resultBlob.cbData].dup;
}

enum : бцел {
  RTL_ENCRYPT_OPTION_SAME_PROCESS  = 0x0,
  RTL_ENCRYPT_OPTION_CROSS_PROCESS = 0x1,
  RTL_ENCRYPT_OPTION_SAME_LOGON    = 0x2
}

enum : бцел {
  RTL_ENCRYPT_MEMORY_SIZE = 8
}

// No import library for these two functions, so we need to import them by ordinal.
extern(Windows)
alias ДллИмпорт!("advapi32.dll", "#749",
  цел function(in ук pData, бцел cbData, бцел dwFlags)) RtlEncryptMemory;

extern(Windows)
alias ДллИмпорт!("advapi32.dll", "#750",
  цел function(in ук pData, бцел cbData, бцел dwFlags)) RtlDecryptMemory;

/**
 */
enum MemoryProtectionScope : бцел {
  SameProcess  = RTL_ENCRYPT_OPTION_SAME_PROCESS,
  CrossProcess = RTL_ENCRYPT_OPTION_CROSS_PROCESS,
  SameLogon    = RTL_ENCRYPT_OPTION_SAME_LOGON
}

/**
 * Protects userData.
 */
проц protectMemory(ббайт[] userData, MemoryProtectionScope protectionScope) {
  if (userData.length == 0 || (userData.length % 16) != 0)
    throw new CryptoException("The length of the данные must be a multiple of 16 байты.");

  цел status = RtlEncryptMemory(userData.ptr, userData.length, cast(бцел)protectionScope);
  if (status < 0)
    throw new CryptoException(LsaNtStatusToWinError(status));
}

/**
 * Unprotects encryptedData, which was protected используя protectMemory.
 */
проц unprotectMemory(ббайт[] encryptedData, MemoryProtectionScope protectionScope) {
  if (encryptedData.length == 0 || (encryptedData.length % 16) != 0)
    throw new CryptoException("The length of the данные must be a multiple of 16 байты.");

  цел status = RtlDecryptMemory(encryptedData.ptr, encryptedData.length, cast(бцел)protectionScope);
  if (status < 0)
    throw new CryptoException(LsaNtStatusToWinError(status));
}