module win32.io.zip;

import win32.base.core,
  win32.base.string,
  win32.base.text,
  win32.loc.time,
  stdrus, tpl.stream, lib.zlib, cidrus;

private enum : бцел {
  LOCAL_FILE_HEADER_SIGNATURE             = 0x04034b50,
  CENTRAL_DIRECTORY_FILE_HEADER_SIGNATURE = 0x02014b50,
  END_OF_CENTRAL_DIRECTORY_SIGNATURE      = 0x06054b50
}

private ббайт[] END_OF_CENTRAL_DIRECTORY_SIGNATURE_BYTES = [0x50, 0x4b, 0x05, 0x06];

private ДатаВрем dosDateTimeToDateTime(бцел dosDateTime) {
  цел секунда = (dosDateTime & 0x1f) << 1;
  цел минута = (dosDateTime >> 5) & 0x3F;
  цел час = (dosDateTime >> 11) & 0x1F;
  цел день = (dosDateTime >> 16) & 0x1F;
  цел месяц = (dosDateTime >> 21) & 0xF;
  цел год = 1980 + ((dosDateTime >> 25) & 0x7F);
  try {
    return ДатаВрем(год, месяц, день, час, минута, секунда);
  }
  catch {
    return ДатаВрем(1980, 1, 1);
  }
}

private бцел dateTimeToDosDateTime(ДатаВрем dateTime) {
  return (dateTime.секунда / 2) & 0x1F |
         (dateTime.минута & 0x3F) << 5 |
         (dateTime.час & 0x1F) << 11 |
         (dateTime.день & 0x1F) << 16 |
         (dateTime.месяц & 0xF) << 21 |
         ((dateTime.год - 1980) & 0x7F) << 25;
}

class ZipException : Exception {

  this(ткст сообщение) {
    super(сообщение);
  }

  this(цел кодОш) {
    super(дайОшСооб(кодОш));
  }

  private static ткст дайОшСооб(цел кодОш) {
    // Zlib's ошибка messages aren't very descriptive.
    //return вУтф8(auxc.zlib.zError(кодОш));
    switch (кодОш) {
      case Z_STREAM_END: return "Обнаружен конец потока.";
      case Z_NEED_DICT: return "Нужен предустановленный словарь.";
      case Z_ERRNO: return "Ошибка в файле.";
      case Z_STREAM_ERROR: return "Инконсистентная структура потока.";
      case Z_DATA_ERROR: return "Вводные данные повреждены.";
      case Z_MEM_ERROR: return "Недостаточно памяти.";
      case Z_BUF_ERROR: return "Нет места в буфере вывода.";
      case Z_VERSION_ERROR: return "Несовместимая версия библиотеки.";
      default: return "Ошибок нет.";
    }
  }

}

/**
 * Indicates the метод employed to compress an запись in a zip file.
 */
enum CompressionMethod : бкрат {
  Stored   = 0x0, /// Indicates the запись is not compressed.
  Deflated = 0x8  /// Indicates the Deflate метод is used to compress the запись.
}

/**
 * Indicates the compression уровень to be used when compressing an запись in a zip file.
 */
enum CompressionLevel {
  Default = -1, /// The default compression уровень.
  None    = 0,  /// Indicates the запись is not compressed.
  Fastest = 1,  /// The fastest but least efficient уровень of compression.
  Best    = 9   /// The most efficient but slowest уровень of compression.
}

private проц copyStream(Поток ввод, Поток вывод) {
  ббайт[1024 * 4] буфер;

  бдол поз = ввод.позиция;
  ввод.позиция = 0;

  while (true) {
    бцел n = ввод.читайБлок(буфер.ptr, буфер.length);
    if (n == 0)
      return;
    вывод.пишиБлок(буфер.ptr, n);
  }

  //ввод.позиция = поз;
}

private class SliceStreamWithSize : ПотокСрез {

  бдол размер_;

  this(Поток исток, бдол смещение, бдол размер) {
    super(исток, смещение, размер);
    размер_ = размер;
  }

  override бдол размер() {
    return размер_;
  }

}

private class CopyFilterStream : ФильтрПоток {

  this(Поток исток) {
    super(исток);
  }

 проц копируй_из(Поток исток) {
    copyStream(исток, this);
  }

}

private class InflateStream : CopyFilterStream {

  бдол размер_;

  ббайт[] buffer_;
  z_stream zs_;

  this(Поток исток, бдол размер) {
    super(исток);
    размер_ = размер;
    buffer_.length = 1024 * 256;

    цел рез = inflateInit2(&zs_, -15);
    if (рез != Z_OK)
      throw new ZipException(рез);
  }

  override т_мера читайБлок(ук буфер, т_мера размер) {
    if (zs_.avail_in == 0) {
      if ((zs_.avail_in = исток.читай(buffer_)) <= 0)
        return 0;
      zs_.next_in = buffer_.ptr;
    }

    zs_.next_out = cast(ббайт*)буфер;
    zs_.avail_out = размер;

    цел рез = inflate(&zs_, Z_NO_FLUSH);
    if (рез != Z_STREAM_END && рез != Z_OK)
      throw new ZipException(рез);

    return размер - zs_.avail_out;
  }

  override т_мера пишиБлок(in ук буфер, т_мера размер) {
    throw new ИсклНеПоддерживается;
  }

  override проц слей() {
    super.слей();
    inflateEnd(&zs_);
  }

  override бдол размер() {
    return размер_;
  }

}

private class DeflateStream : CopyFilterStream {

  ббайт[] buffer_;
  z_stream zs_;
  бдол размер_;

  this(Поток исток, CompressionLevel уровень) {
    super(исток);
    buffer_.length = 1024 * 256;

    цел рез = deflateInit2(&zs_, cast(цел)уровень, Z_DEFLATED, -15, 8, Z_DEFAULT_STRATEGY);
    if (рез != Z_OK)
      throw new ZipException(рез);
  }

  override проц закрой() {
    слей();
  }

  override т_мера читайБлок(ук буфер, т_мера размер) {
    throw new ИсклНеПоддерживается;
  }

  override т_мера пишиБлок(in ук буфер, т_мера размер) {
    zs_.avail_in = размер;
    zs_.next_in = cast(ббайт*)буфер;

    do {
      zs_.avail_out = buffer_.length;
      zs_.next_out = buffer_.ptr;

      цел рез = deflate(&zs_, Z_NO_FLUSH);
      if (рез == Z_STREAM_ERROR)
        throw new ZipException(рез);

      бцел n = buffer_.length - zs_.avail_out;
      ббайт[] b = buffer_[0 .. n];
      do {
        т_мера written = исток.пиши(b);
        if (written <= 0)
          return 0;
        b = b[written .. $];
        размер_ += written;
      } while (b.length > 0);
    } while (zs_.avail_out == 0);

    return размер;
  }

  override бдол сместись(дол смещение, ППозКурсора origin) {
    throw new ИсклНеПоддерживается;
  }

  override проц слей() {
    zs_.avail_in = 0;
    zs_.next_in = null;

    бул done;
    do {
      zs_.avail_out = buffer_.length;
      zs_.next_out = cast(ббайт*)buffer_.ptr;

      цел рез = deflate(&zs_, Z_FINISH);
      switch (рез) {
        case Z_OK:
          break;
        case Z_STREAM_END:
          done = true;
          break;
        default:
          throw new ZipException(рез);
      }

      бцел n = buffer_.length - zs_.avail_out;
      ббайт[] b = buffer_[0 .. n];
      do {
        т_мера written = исток.пиши(b);
        if (written <= 0)
          return;//0
        b = b[written .. $];
        размер_ += written;
      } while (b.length > 0);
    } while (!done);

    deflateEnd(&zs_);
  }

  override бдол размер() {
    return размер_;
  }

}

private class CrcStream : CopyFilterStream {

  бцел значение;

  this(Поток исток) {
    super(исток);
  }

  override т_мера читайБлок(ук буфер, т_мера размер) {
    т_мера n = исток.читайБлок(буфер, размер);
    if (n != 0)
      значение = lib.zlib.crc32(значение, cast(ббайт*)буфер, n);
    return n;
  }

  override т_мера пишиБлок(in ук буфер, т_мера размер) {
    throw new ИсклНеПоддерживается;
  }

}

class ЗипЗапись {

  private Поток input_;
  private Поток data_;
  private Поток вывод_;

  private бкрат extractVersion_;
  private бкрат bitFlag_;
  private бкрат method_ = cast(бкрат)-1;
  private бцел lastWriteTime_ = cast(бцел)-1;
  private бцел crc32_;
  private бцел compressedSize_;
  private бцел uncompressedSize_;
  private бкрат fileNameLength_;
  private бкрат extraFieldLength_;

  private ткст fileName_;
  private ббайт[] экстраПоле_;
  private ткст коммент_;

  this() {
  }

  this(ткст имяф) {
    fileName_ = имяф;
  }

  /*Поток readStream() {
    data_ = new SliceStreamWithSize(input_, input_.позиция, uncompressedSize_);
    switch (method_) {
      case CompressionMethod.Stored:
        break;
      case CompressionMethod.Deflated:
        data_ = new InflateStream(data_, uncompressedSize_);
        break;
      default:
    }
    return data_;
  }

  Поток readStream() {
    if (вывод_ is null)
      вывод_ = new CopyFilterStream(new ПотокПамяти);
    return вывод_;
  }*/

  проц метод(CompressionMethod значение) {
    method_ = cast(бкрат)значение;
  }
  CompressionMethod метод() {
    return cast(CompressionMethod)method_;
  }

  проц lastWriteTime(ДатаВрем значение) {
    lastWriteTime_ = dateTimeToDosDateTime(значение);
  }
  ДатаВрем lastWriteTime() {
    if (lastWriteTime_ == -1)
      return ДатаВрем.now;
    return dosDateTimeToDateTime(lastWriteTime_);
  }

  проц имяф(ткст значение) {
    if (значение.length > 0xFFFF)
      throw new ИсклАргументВнеОхвата("значение");

    fileName_ = значение;
  }
  ткст имяф() {
    return fileName_;
  }

  проц коммент(ткст значение) {
    if (значение.length > 0xFFFF)
      throw new ИсклАргументВнеОхвата("значение");

    коммент_ = значение;
  }
  ткст коммент() {
    return коммент_;
  }

  бул isDirectory() {
    return fileName_.заканчинаетсяНа("/");
  }

}

final class ZipReader {

  private Поток input_;
  private Кодировка кодировка_;
  private Поток readStream_;

  private ЗипЗапись запись_;

  private ткст коммент_;

  this(Поток ввод) {
    input_ = ввод;
    кодировка_ = Кодировка.дай(437);

    readEndOfCentralDirectory();
  }

  проц закрой() {
    input_.закрой();
  }

  ЗипЗапись читай() {
    if (запись_ !is null)
      closeEntry();

    бцел signature;
    input_.читай(signature);
    if (signature != LOCAL_FILE_HEADER_SIGNATURE)
      return null;

    запись_ = new ЗипЗапись;
    запись_.input_ = input_;

    input_.читай(запись_.extractVersion_);
    input_.читай(запись_.bitFlag_);
    input_.читай(запись_.method_);
    input_.читай(запись_.lastWriteTime_);
    input_.читай(запись_.crc32_);
    input_.читай(запись_.compressedSize_);
    input_.читай(запись_.uncompressedSize_);
    input_.читай(запись_.fileNameLength_);
    input_.читай(запись_.extraFieldLength_);

    auto времн = new ббайт[запись_.fileNameLength_];
    input_.читай(времн);
    запись_.fileName_ = cast(ткст)кодировка_.раскодируй(времн);
    запись_.экстраПоле_.length = запись_.extraFieldLength_;
    input_.читай(запись_.экстраПоле_);

    if ((запись_.bitFlag_ & 1 << 0) != 0)
      throw new ZipException("Encrypted zip entries are not supported.");

    return запись_;
  }
  
  Поток readStream() {
    if (запись_ is null)
      return null;

    if (readStream_ is null) {
      readStream_ = new SliceStreamWithSize(input_, input_.позиция, запись_.uncompressedSize_);
      switch (запись_.method_) {
        case CompressionMethod.Stored:
          break;
        case CompressionMethod.Deflated:
          readStream_ = new InflateStream(readStream_, запись_.uncompressedSize_);
          break;
        default:
      }
    }
    return readStream_;
  }

  ткст коммент() {
    return коммент_;
  }

  private проц closeEntry() {
    if (запись_ is null)
      return;

    // Skip over any unread file данные.
    if (запись_.data_ !is null) {
      input_.сместись(cast(дол)(запись_.compressedSize_ - запись_.data_.позиция), ППозКурсора.Тек);
    }
    else {
      input_.сместись(запись_.compressedSize_, ППозКурсора.Тек);
    }
    запись_ = null;
    readStream_ = null;
  }

  private проц readEndOfCentralDirectory() {
    ббайт[4096 + 22] буфер;

    бдол поз = input_.позиция;
    дол end = cast(дол)(input_.размер - буфер.length);
    if (end < 0)
      end = 0;
    input_.позиция = cast(бдол)end;

    т_мера n = input_.читай(буфер);
    for (цел i = n - 22; i >= 0; i--) {
      if (i < end)
        throw new ZipException("Файл содержит повреждённые данные.");

      if (буфер[i .. i + 4] == END_OF_CENTRAL_DIRECTORY_SIGNATURE_BYTES) {
        input_.позиция = i + 4;
        break;
      }
    }

    бкрат diskNumber;
    input_.читай(diskNumber);
    бкрат diskNumberStart;
    input_.читай(diskNumberStart);
    бкрат entries;
    input_.читай(entries);
    бкрат entriesTotal;
    input_.читай(entriesTotal);
    бцел размер;
    input_.читай(размер);
    бцел смещение;
    input_.читай(смещение);
    бкрат commentLength;
    input_.читай(commentLength);
    if (commentLength > 0) {
      ббайт[] времн = new ббайт[commentLength];
      input_.читай(времн);
      коммент_ = cast(ткст)кодировка_.раскодируй(времн);
    }

    if (diskNumber != diskNumberStart || entries != entriesTotal)
      throw new ZipException("Многодисковый zip-формат не поддерживается.");

    input_.позиция = поз;
  }

}

/**
 * Примеры:
 * ---
 * // Create a new ЗипПисатель with the имя "backup.zip".
 * auto writer = new ЗипПисатель("backup.zip");
 *
 * // Create an запись named "research.doc".
 * auto запись = new ЗипЗапись("research.doc");
 * writer.пишиПоток.копируй_из(new Файл("research.doc"));
 *
 * // Add the new запись to the writer.
 * writer.добавь(запись);
 *
 * // Finalise the writer.
 * writer.закрой();
 * ---
 */
class ЗипПисатель {

  private class Запись {

    ЗипЗапись запись;
    бцел смещение;

    this(ЗипЗапись запись, бцел смещение) {
      this.запись = запись;
      this.смещение = смещение;
    }

  }

  private Поток вывод_;
  private Кодировка кодировка_;
  private Поток writeStream_;

  private CompressionMethod method_ = CompressionMethod.Deflated;
  private CompressionLevel level_ = CompressionLevel.Default;

  private ЗипЗапись запись_;
  private Запись[] записи_;

  private ткст коммент_;

  this(Поток вывод) {
    вывод_ = вывод;
    кодировка_ = Кодировка.дай(437);
  }

  проц закрой() {
    финиш();
    вывод_.закрой();
  }

  проц пиши(ЗипЗапись запись) {
    запись_ = запись;

    if (запись.method_ == cast(бкрат)-1)
      запись.method_ = cast(бкрат)method_;
    if (запись.lastWriteTime_ == cast(бцел)-1)
      запись.lastWriteTime_ = dateTimeToDosDateTime(запись.lastWriteTime);

    //запись.uncompressedSize_ = запись_.вывод_.размер;
    запись.uncompressedSize_ = cast(бцел)пишиПоток.размер;

    auto e = new Запись(запись, cast(бцел)вывод_.позиция);
    записи_ ~= e;

    вывод_.пиши(LOCAL_FILE_HEADER_SIGNATURE);
    вывод_.пиши(cast(бкрат)((запись.method_ == CompressionMethod.Deflated) ? 20 : 10));
    вывод_.пиши(запись.bitFlag_);
    вывод_.пиши(запись.method_);
    вывод_.пиши(запись.lastWriteTime_);
    вывод_.пиши(запись.crc32_);
    вывод_.пиши(запись.compressedSize_);
    вывод_.пиши(запись.uncompressedSize_);

    ббайт[] имяф = кодировка_.кодируй(запись.fileName_);
    вывод_.пиши(cast(бкрат)имяф.length);
    вывод_.пиши(cast(бкрат)запись.экстраПоле_.length);
    вывод_.пиши(имяф);
    вывод_.пиши(запись.экстраПоле_);

    //if (запись.вывод_ !is null) {
      Поток исток = пишиПоток;//запись.вывод_;
      Поток цель = вывод_;
      Поток deflate = null;

      switch (запись.method_) {
        case CompressionMethod.Stored:
          break;
        case CompressionMethod.Deflated:
          цель = deflate = new DeflateStream(вывод_, level_);
          break;
        default:
      }

      scope crc = new CrcStream(исток);
      исток = crc;

      //copyStream(исток, цель);
      цель.копируй_из(исток);

      if (deflate !is null)
        deflate.закрой();

      запись.crc32_ = crc.значение;
      запись.compressedSize_ = (deflate !is null) ? cast(бцел)deflate.размер : запись_.uncompressedSize_;

      бдол поз = вывод_.позиция;
      вывод_.позиция = e.смещение + 14;

      вывод_.пиши(запись.crc32_);
      вывод_.пиши(запись.compressedSize_);
      вывод_.пиши(запись.uncompressedSize_);

      вывод_.позиция = поз;

      writeStream_ = null;
    //}
  }

  Поток пишиПоток() {
    if (writeStream_ is null)
      writeStream_ = new CopyFilterStream(new ПотокПамяти);
    return writeStream_;
  }

  проц финиш() {
    пишиЦентральнПапку();
  }

  private проц пишиЦентральнПапку() {
    бцел смещение = cast(бцел)вывод_.позиция;

    foreach (e; записи_) {
      пишиЗапЦентральнПапки(e);
    }

    пишиКонЦентральнПапки(смещение, cast(бцел)вывод_.позиция - смещение);
  }

  private проц пишиЗапЦентральнПапки(Запись e) {
    auto запись = e.запись;

    вывод_.пиши(CENTRAL_DIRECTORY_FILE_HEADER_SIGNATURE);
    вывод_.пиши(запись.extractVersion_);
    вывод_.пиши(запись.extractVersion_);
    вывод_.пиши(запись.bitFlag_);
    вывод_.пиши(запись.method_);
    вывод_.пиши(запись.lastWriteTime_);
    вывод_.пиши(запись.crc32_);
    вывод_.пиши(запись.compressedSize_);
    вывод_.пиши(запись.uncompressedSize_);
    ббайт[] имяф = кодировка_.кодируй(запись.fileName_);
    вывод_.пиши(cast(бкрат)имяф.length);
    вывод_.пиши(cast(бкрат)запись.экстраПоле_.length);
    ббайт[] коммент = кодировка_.кодируй(запись.коммент_);
    вывод_.пиши(cast(бкрат)коммент.length);
    вывод_.пиши(cast(бкрат)0);
    вывод_.пиши(cast(бкрат)0);
    вывод_.пиши(cast(бцел)0);
    вывод_.пиши(e.смещение);
    вывод_.пиши(имяф);
    вывод_.пиши(запись.экстраПоле_);
    вывод_.пиши(коммент);
  }

  private проц пишиКонЦентральнПапки(бцел start, бцел размер) {
    вывод_.пиши(END_OF_CENTRAL_DIRECTORY_SIGNATURE);
    вывод_.пиши(cast(бкрат)0);
    вывод_.пиши(cast(бкрат)0);
    вывод_.пиши(cast(бкрат)записи_.length);
    вывод_.пиши(cast(бкрат)записи_.length);
    вывод_.пиши(размер);
    вывод_.пиши(start);
    вывод_.пиши(cast(бкрат)коммент_.length);
    вывод_.пиши(кодировка_.кодируй(коммент_));
  }

  проц метод(CompressionMethod значение) {
    method_ = значение;
  }
  CompressionMethod метод() {
    return method_;
  }

  проц уровень(CompressionLevel значение) {
    level_ = значение;
  }
  CompressionLevel уровень() {
    return level_;
  }

  проц коммент(ткст значение) {
    if (значение.length > 0xFFFF)
      throw new ИсклАргументВнеОхвата("значение");

    коммент_ = значение;
  }
  ткст коммент() {
    return коммент_;
  }

}