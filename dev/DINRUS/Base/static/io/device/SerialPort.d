
module io.device.SerialPort;

private import  io.device.Device;


/*******************************************************************************

        Позволяет приложения использовать серийный порт (aka COM-порт, ttyS).
        Используется подобно как  Файл:
        ---
        auto сп = new СерийныйПорт("ttyS0");
        сп.скорость = 38400;
        сп.пиши("Hello world!");
        сп.закрой();
        ----

*******************************************************************************/

extern(D) 
class СерийныйПорт : Устройство
{

    /***************************************************************************

            Create a new СерийныйПорт экземпляр. The порт will be opened and
            установи в_ необр режим with 9600-8N1.

            Параметры:
            порт = A ткст опрentifying the порт. On Posix, this must be a
                   устройство файл like /dev/ttyS0. If the ввод doesn't begin
                   with "/", "/dev/" is automatically prepended, so "ttyS0"
                   is sufficent. On Windows, this must be a устройство имя like
                   COM1

    ***************************************************************************/

    this (ткст порт);

    /***************************************************************************

            Возвращает ткст describing this serial порт.
            For example: "ttyS0", "COM1", "cuad0"

    ***************************************************************************/

    override ткст вТкст ();

    /***************************************************************************

            Sets the baud rate of this порт. Usually, the baud rate can
            only be установи в_ fixed values (common values are 1200 * 2^n).

            Note that for Posix, the specification only mandates speeds up
            в_ 38400, excluding speeds such as 7200, 14400 and 28800.
            Most Posix systems have chosen в_ support at least higher speeds
            though.

            See also: maxSpeed

            Выводит исключение: ВВИскл if скорость is unsupported.

    ***************************************************************************/

    СерийныйПорт скорость (бцел скорость);

    /***************************************************************************

            Tries в_ enumerate все serial порты. While this usually works on
            Windows, it's ещё problematic on другой OS. Posix provопрes no way
            в_ список serial порты, and the only опция is searching through
            "/dev".

            Because there's no naming стандарт for the устройство файлы, this метод
            must be ported for each OS. This метод is also unreliable because
            the пользователь could have создан не_годится устройство файлы, либо deleted them.

            Возвращает:
            A ткст Массив of все the serial порты that could be найдено, in
            alphabetical order. Every ткст is formatted as a valid аргумент
            в_ the constructor, but the порт may not be accessible.

    ***************************************************************************/

    static ткст[] порты ();
}

