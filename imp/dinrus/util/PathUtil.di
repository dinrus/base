module util.PathUtil;

/*******************************************************************************

    Normalizes a путь component.

    . segments are removed
    <segment>/.. are removed

    On Windows, \ will be преобразованый в_ / prior в_ normalization.

    MultИПle consecutive forward slashes are replaced with a single forward slash.

    Note that any число of .. segments at the front is ignored,
    unless it is an абсолютный путь, in which case they are removed.

    The ввод путь is copied преобр_в either the предоставленный буфер, or a куча
    allocated Массив if no буфер was предоставленный. Normalization modifies
    this копируй before returning the relevant срез.

    Примеры:
    -----
     нормализуй("/home/foo/./bar/../../john/doe"); // => "/home/john/doe"
    -----

*******************************************************************************/
ткст нормализуй(ткст путь, ткст буф = пусто);

            /******************************************************************************

            Matches a образец against a имяф.

            Some characters of образец have special a meaning (they are
            <i>meta-characters</i>) and <b>can't</b> be escaped. These are:
            <p><table>
            <tr><td><b>*</b></td>
            <td>Matches 0 or ещё instances of any character.</td></tr>
            <tr><td><b>?</b></td>
            <td>Matches exactly one instances of any character.</td></tr>
            <tr><td><b>[</b><i>симвы</i><b>]</b></td>
            <td>Matches one экземпляр of any character that appears
            between the brackets.</td></tr>
            <tr><td><b>[!</b><i>симвы</i><b>]</b></td>
            <td>Matches one экземпляр of any character that does not appear
            between the brackets после the exclamation метка.</td></tr>
            </table><p>
            Internally indivопрual character comparisons are готово calling
            симСверь(), so its rules apply here too. Note that путь
            разделители and dots don't stop a meta-character из_ совпадают
            further portions of the имяф.

            Возвращает: да if образец matches имяф, нет иначе.

            See_Also: симСверь().

            Throws: Nothing.

            Примеры:
            -----
            version(Win32)
            {
            совпадение("foo.bar", "*") // => да
            совпадение(r"foo/foo\bar", "f*b*r") // => да
            совпадение("foo.bar", "f?bar") // => нет
            совпадение("Goo.bar", "[fg]???bar") // => да
            совпадение(r"d:\foo\bar", "d*foo?bar") // => да
        }
            version(Posix)
            {
            совпадение("Go*.bar", "[fg]???bar") // => нет
            совпадение("/foo*home/bar", "?foo*bar") // => да
            совпадение("fСПДar", "foo?bar") // => да
        }
            -----

            ******************************************************************************/

            бул совпадение(ткст имяф, ткст образец);
			
            /******************************************************************************

            Matches имяф characters.

            Under Windows, the сравнение is готово ignoring case. Under Linux
            an exact match is performed.

            Возвращает: да if c1 matches c2, нет иначе.

            Throws: Nothing.

            Примеры:
            -----
            version(Win32)
            {
            симСверь('a', 'b') // => нет
            симСверь('A', 'a') // => да
        }
            version(Posix)
            {
            симСверь('a', 'b') // => нет
            симСверь('A', 'a') // => нет
        }
            -----
            ******************************************************************************/

            private бул симСверь(сим c1, сим c2);

