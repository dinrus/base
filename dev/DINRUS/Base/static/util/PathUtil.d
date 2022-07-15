/*******************************************************************************

        copyright:      Copyright (c) 2006-2009 Max Samukha, Thomas Kühne,
                                            Grzegorz Adam Hankiewicz

        license:        BSD стиль: $(LICENSE)

        version:        Dec 2006: Initial release
                        Jan 2009: Replaced нормализуй

        author:         Max Samukha, Thomas Kühne,
                        Grzegorz Adam Hankiewicz

*******************************************************************************/

module util.PathUtil;

private import  exception;

private extern (C) проц memmove (ук  приёмн, ук  ист, бцел байты);

private enum
{
    NodeStackLength = 64
}

/*******************************************************************************

    Normalizes a путь component.

    . segments are removed
    <сегмент>/.. are removed

    On Windows, \ will be преобразованый в_ / prior в_ normalization.

    Несколько consecutive forward slashes are replaced with a single forward слэш.

    Note that any число of .. segments at the front is ignored,
    unless it is an абсолютный путь, in which case they are removed.

    The ввод путь is copied преобр_в either the предоставленный буфер, либо a куча
    allocated Массив if no буфер was предоставленный. Normalization modifies
    this копируй перед returning the relevant срез.

    Примеры:
    -----
     нормализуй("/home/foo/./bar/../../john/doe"); // => "/home/john/doe"
    -----

*******************************************************************************/
ткст нормализуй(ткст путь, ткст буф = пусто)
{
    // Whether the путь is абсолютный
    бул абс_ли;
    // Текущий позиция
    т_мера инд;
    // Position в_ перемести
    т_мера moveTo;

    // Starting positions of regular путь segments are pushed on this stack
    // в_ avoопр backward scanning when .. segments are encountered.
    т_мера[NodeStackLength] nodeStack;
    т_мера nodeStackTop;

    // Moves the путь хвост starting at the current позиция в_ moveTo.
    // Then sets the current позиция в_ moveTo.
    проц перемести()
    {
        auto длин = путь.length - инд;
        memmove(путь.ptr + moveTo, путь.ptr + инд, длин);
        путь = путь[0..moveTo + длин];
        инд = moveTo;
    }

    // Checks if the character at the current позиция is a разделитель.
    // If да, normalizes the разделитель в_ '/' on Windows and advances the
    // current позиция в_ the следщ character.
    бул isSep(ref т_мера i)
    {
        сим c = путь[i];
        version (Windows)
        {
            if (c == '\\')
                путь[i] = '/';
            else if (c != '/')
                return нет;
        }
        else
        {
            if (c != '/')
                return нет;
        }
        i++;
        return да;
    }

    if (буф is пусто)
        путь = путь.dup;
    else
        путь = буф[0..путь.length] = путь;

    version (Windows)
    {
        // SkИП Windows drive specifiers
        if (путь.length >= 2 && путь[1] == ':')
        {
            auto c = путь[0];

            if (c >= 'a' && c <= 'z')
            {
                путь[0] = c - 32;
                инд = 2;
            }
            else if (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z')
                инд = 2;
        }
    }

    if (инд == путь.length)
        return путь;

    moveTo = инд;
    if (isSep(инд))
    {
        moveTo++; // preserve корень разделитель.
        абс_ли = да;
    }

    while (инд < путь.length)
    {
        // SkИП duplicate разделители
        if (isSep(инд))
            continue;

        if (путь[инд] == '.')
        {
            // покинь the current позиция at the старт of the сегмент
            auto i = инд + 1;
            if (i < путь.length && путь[i] == '.')
            {
                i++;
                if (i == путь.length || isSep(i))
                {
                    // It is a '..' сегмент. If the stack is not пустой, установи
                    // moveTo and the current позиция
                    // в_ the старт позиция of the последний найдено regular сегмент.
                    if (nodeStackTop > 0)
                        moveTo = nodeStack[--nodeStackTop];
                    // If no regular сегмент старт positions on the stack, drop the
                    // .. сегмент if it is абсолютный путь
                    // or, иначе, advance moveTo and the current позиция в_
                    // the character после the '..' сегмент
                    else if (!абс_ли)
                    {
                        if (moveTo != инд)
                        {
                            i -= инд - moveTo;
                            перемести();
                        }
                        moveTo = i;
                    }

                    инд = i;
                    continue;
                }
            }

            // If it is '.' сегмент, пропусти it.
            if (i == путь.length || isSep(i))
            {
                инд = i;
                continue;
            }
        }

        // Удали excessive '/', '.' and/or '..' preceeding the сегмент.
        if (moveTo != инд)
            перемести();

        // Push the старт позиция of the regular сегмент on the stack
        assert(nodeStackTop < NodeStackLength);
        nodeStack[nodeStackTop++] = инд;

        // SkИП the regular сегмент and установи moveTo в_ the позиция после the сегмент
        // (включая the trailing '/' if present)
        for(; инд < путь.length && !isSep(инд); инд++) {}
        moveTo = инд;
    }

    if (moveTo != инд)
        перемести();

    return путь;
}

debug (UnitTest)
{

    unittest
    {
        assert (нормализуй ("") == "");
        assert (нормализуй ("/home/../john/../.DinrusTango.lib/.htaccess") == "/.DinrusTango.lib/.htaccess");
        assert (нормализуй ("/home/../john/../.DinrusTango.lib/foo.conf") == "/.DinrusTango.lib/foo.conf");
        assert (нормализуй ("/home/john/.DinrusTango.lib/foo.conf") == "/home/john/.DinrusTango.lib/foo.conf");
        assert (нормализуй ("/foo/bar/.htaccess") == "/foo/bar/.htaccess");
        assert (нормализуй ("foo/bar/././.") == "foo/bar/");
        assert (нормализуй ("././foo/././././bar") == "foo/bar");
        assert (нормализуй ("/foo/../john") == "/john");
        assert (нормализуй ("foo/../john") == "john");
        assert (нормализуй ("foo/bar/..") == "foo/");
        assert (нормализуй ("foo/bar/../john") == "foo/john");
        assert (нормализуй ("foo/bar/doe/../../john") == "foo/john");
        assert (нормализуй ("foo/bar/doe/../../john/../bar") == "foo/bar");
        assert (нормализуй ("./foo/bar/doe") == "foo/bar/doe");
        assert (нормализуй ("./foo/bar/doe/../../john/../bar") == "foo/bar");
        assert (нормализуй ("./foo/bar/../../john/../bar") == "bar");
        assert (нормализуй ("foo/bar/./doe/../../john") == "foo/john");
        assert (нормализуй ("../../foo/bar") == "../../foo/bar");
        assert (нормализуй ("../../../foo/bar") == "../../../foo/bar");
        assert (нормализуй ("d/") == "d/");
        assert (нормализуй ("/home/john/./foo/bar.txt") == "/home/john/foo/bar.txt");
        assert (нормализуй ("/home//john") == "/home/john");

        assert (нормализуй("/../../bar/") == "/bar/");
        assert (нормализуй("/../../bar/../baz/./") == "/baz/");
        assert (нормализуй("/../../bar/boo/../baz/.bar/.") == "/bar/baz/.bar/");
        assert (нормализуй("../..///.///bar/..//..//baz/.//boo/..") == "../../../baz/");
        assert (нормализуй("./bar/./..boo/./..bar././/") == "bar/..boo/..bar./");
        assert (нормализуй("/bar/..") == "/");
        assert (нормализуй("bar/") == "bar/");
        assert (нормализуй(".../") == ".../");
        assert (нормализуй("///../foo") == "/foo");
        auto буф = new сим[100];
        auto возвр = нормализуй("foo/bar/./baz", буф);
        assert (возвр.ptr == буф.ptr);
        assert (возвр == "foo/bar/baz");

        version (Windows)
        {
            assert (нормализуй ("\\foo\\..\\john") == "/john");
            assert (нормализуй ("foo\\..\\john") == "john");
            assert (нормализуй ("foo\\bar\\..") == "foo/");
            assert (нормализуй ("foo\\bar\\..\\john") == "foo/john");
            assert (нормализуй ("foo\\bar\\doe\\..\\..\\john") == "foo/john");
            assert (нормализуй ("foo\\bar\\doe\\..\\..\\john\\..\\bar") == "foo/bar");
            assert (нормализуй (".\\foo\\bar\\doe") == "foo/bar/doe");
            assert (нормализуй (".\\foo\\bar\\doe\\..\\..\\john\\..\\bar") == "foo/bar");
            assert (нормализуй (".\\foo\\bar\\..\\..\\john\\..\\bar") == "bar");
            assert (нормализуй ("foo\\bar\\.\\doe\\..\\..\\john") == "foo/john");
            assert (нормализуй ("..\\..\\foo\\bar") == "../../foo/bar");
            assert (нормализуй ("..\\..\\..\\foo\\bar") == "../../../foo/bar");
            assert (нормализуй(r"C:") == "C:");
            assert (нормализуй(r"C") == "C");
            assert (нормализуй(r"c:\") == "C:/");
            assert (нормализуй(r"C:\..\.\..\..\") == "C:/");
            assert (нормализуй(r"c:..\.\boo\") == "C:../boo/");
            assert (нормализуй(r"C:..\..\boo\foo\..\.\..\..\bar") == "C:../../../bar");
            assert (нормализуй(r"C:boo\..") == "C:");
        }
        }
        }


            /******************************************************************************

            Matches a образец against a имяф.

            Some characters of образец have special a meaning (they are
            <i>meta-characters</i>) and <b>can't</b> be эскапирован. These are:
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
            charMatch(), so its rules apply here too. Note that путь
            разделители and dots don't stop a meta-character из_ совпадают
            further portions of the имяф.

            Возвращает: да, если образец matches имяф, нет иначе.

            См_Также: charMatch().

            Выводит исключение: Nothing.

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

            бул совпадение(ткст имяф, ткст образец)
            in
            {
            // Verify that образец[] is valid
            цел i;
            цел inbracket = нет;

            for (i = 0; i < образец.length; i++)
            {
            switch (образец[i])
            {
            case '[':
            assert(!inbracket);
            inbracket = да;
            break;

            case ']':
            assert(inbracket);
            inbracket = нет;
            break;

            default:
            break;
        }
        }
        }
            body
            {
            цел пи;
            цел ni;
            сим pc;
            сим nc;
            цел j;
            цел not;
            цел anymatch;

            ni = 0;
            for (пи = 0; пи < образец.length; пи++)
            {
            pc = образец[пи];
            switch (pc)
            {
            case '*':
            if (пи + 1 == образец.length)
            goto match;
            for (j = ni; j < имяф.length; j++)
            {
            if (совпадение(имяф[j .. имяф.length],
            образец[пи + 1 .. образец.length]))
            goto match;
        }
            goto nomatch;

            case '?':
            if (ni == имяф.length)
            goto nomatch;
            ni++;
            break;

            case '[':
            if (ni == имяф.length)
            goto nomatch;
            nc = имяф[ni];
            ni++;
            not = 0;
            пи++;
            if (образец[пи] == '!')
            {
            not = 1;
            пи++;
        }
            anymatch = 0;
            while (1)
            {
            pc = образец[пи];
            if (pc == ']')
            break;
            if (!anymatch && charMatch(nc, pc))
            anymatch = 1;
            пи++;
        }
            if (!(anymatch ^ not))
            goto nomatch;
            break;

            default:
            if (ni == имяф.length)
            goto nomatch;
            nc = имяф[ni];
            if (!charMatch(pc, nc))
            goto nomatch;
            ni++;
            break;
        }
        }
            if (ni < имяф.length)
            goto nomatch;

            match:
            return да;

            nomatch:
            return нет;
        }


            debug (UnitTest)
            {
            unittest
            {
            version (Win32)
            assert(совпадение("foo", "Foo"));
            version (Posix)
            assert(!совпадение("foo", "Foo"));

            assert(совпадение("foo", "*"));
            assert(совпадение("foo.bar", "*"));
            assert(совпадение("foo.bar", "*.*"));
            assert(совпадение("foo.bar", "foo*"));
            assert(совпадение("foo.bar", "f*bar"));
            assert(совпадение("foo.bar", "f*b*r"));
            assert(совпадение("foo.bar", "f???bar"));
            assert(совпадение("foo.bar", "[fg]???bar"));
            assert(совпадение("foo.bar", "[!gh]*bar"));

            assert(!совпадение("foo", "bar"));
            assert(!совпадение("foo", "*.*"));
            assert(!совпадение("foo.bar", "f*baz"));
            assert(!совпадение("foo.bar", "f*b*x"));
            assert(!совпадение("foo.bar", "[gh]???bar"));
            assert(!совпадение("foo.bar", "[!fg]*bar"));
            assert(!совпадение("foo.bar", "[fg]???baz"));

        }
        }


            /******************************************************************************

            Matches имяф characters.

            Under Windows, the сравнение is готово ignoring case. Under Linux
            an exact match is performed.

            Возвращает: да, если c1 matches c2, нет иначе.

            Выводит исключение: Nothing.

            Примеры:
            -----
            version(Win32)
            {
            charMatch('a', 'b') // => нет
            charMatch('A', 'a') // => да
        }
            version(Posix)
            {
            charMatch('a', 'b') // => нет
            charMatch('A', 'a') // => нет
        }
            -----
            ******************************************************************************/

            private бул charMatch(сим c1, сим c2)
            {
            version (Win32)
            {

            if (c1 != c2)
            {
            return ((c1 >= 'a' && c1 <= 'z') ? c1 - ('a' - 'A') : c1) ==
            ((c2 >= 'a' && c2 <= 'z') ? c2 - ('a' - 'A') : c2);
        }
            return да;
        }
            version (Posix)
            {
            return c1 == c2;
        }
        }

