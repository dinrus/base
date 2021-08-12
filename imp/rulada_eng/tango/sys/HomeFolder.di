﻿/*******************************************************************************

        copyright:      Copyright (c) 2006-2009 Lars Ivar Igesund, Thomas Kühne,
                                           Grzegorz Adam Hankiewicz, sleek

        license:        BSD style: $(LICENSE)

        version:        Initial release: December 2006
                        Updated and readded: August 2009

        author:         Lars Ivar Igesund, Thomas Kühne,
                        Grzegorz Adam Hankiewicz, sleek

        Since:          0.99.9

*******************************************************************************/

module tango.sys.HomeFolder;

import TextUtil = tango.text.Util;
import Path = tango.io.Path;
import tango.sys.Environment;

version (Posix)
{
    import tango.core.Exception;
    import rt.core.stdc.stdlib;
    import rt.core.stdc.posix.pwd;
    import rt.core.stdc.errno_;

    private extern (C) size_t strlen (in char *);
}


/******************************************************************************

  Returns the home folder set in the current environment.

******************************************************************************/

char[] homeFolder()
{
    version (Windows)
        return Path.standard(Environment.get("USERPROFILE"));
    else
        return Path.standard(Environment.get("HOME"));
}

version (Posix) 
{

    /******************************************************************************

        Performs tilde expansion in paths.

        There are two ways of using tilde expansion in a path. One
        involves using the tilde alone or followed by a path separator. In
        this case, the tilde will be expanded with the value of the
        environment variable <i>HOME</i>.  The second way is putting
        a username after the tilde (i.e. <tt>~john/Mail</tt>). Here,
        the username will be searched for in the user database
        (i.e. <tt>/etc/passwd</tt> on Unix systems) and will expand to
        whatever path is stored there.  The username is considered the
        string after the tilde ending at the first instance of a path
        separator.

        Note that using the <i>~user</i> syntax may give different
        values from just <i>~</i> if the environment variable doesn't
        match the value stored in the user database.

        When the environment variable version is used, the path won't
        be modified if the environment variable doesn't exist or it
        is empty. When the database version is used, the path won't be
        modified if the user doesn't exist in the database or there is
        not enough memory to perform the query.

        Returns: inputPath with the tilde expanded, or just inputPath
        if it could not be expanded.

        Throws: OutOfMemoryException if there is not enough memory to 
                perform the database lookup for the <i>~user</i> syntax.

        Examples:
        -----
        import tango.sys.HomeFolder;

        void processFile(char[] filename)
        {
             char[] path = expandTilde(filename);
            ...
        }
        -----

        -----
        import tango.sys.HomeFolder;

        const char[] RESOURCE_DIR_TEMPLATE = "~/.applicationrc";
        char[] RESOURCE_DIR;    // This gets expanded below.

        static this()
        {
            RESOURCE_DIR = expandTilde(RESOURCE_DIR_TEMPLATE);
        }
        -----
    ******************************************************************************/

    char[] expandTilde (char[] inputPath)
    {
            // Return early if there is no tilde in path.
            if (inputPath.length < 1 || inputPath[0] != '~')
                return inputPath;

            if (inputPath.length == 1 || inputPath[1] == '/')
                return expandFromEnvironment(inputPath);
            else
                return expandFromDatabase(inputPath);
    }

    /*******************************************************************************

            Replaces the tilde from path with the environment variable
            HOME.

    ******************************************************************************/

    private char[] expandFromEnvironment(char[] path)
    {
        assert(path.length >= 1);
        assert(path[0] == '~');

        // Get HOME and use that to replace the tilde.
        char[] home = homeFolder;
        if (home is null)
            return path;

        return Path.join(home, path[1..$]);
    }

    /*******************************************************************************

            Replaces the tilde from path with the path from the user
            database.

    ******************************************************************************/

    private char[] expandFromDatabase(char[] path)
    {
        assert(path.length > 2 || (path.length == 2 && path[1] != '/'));
        assert(path[0] == '~');

        // Extract username, searching for path separator.
        char[] username;
        uint last_char = TextUtil.locate(path, '/');

        if (last_char == path.length)
            {
            username = path[1..$] ~ '\0';
            }
        else
            {
            username = path[1..last_char] ~ '\0';
            }

        assert(last_char > 1);
 
        // Reserve C memory for the getpwnam_r() function.
        passwd result;
        int extra_memory_size = 5 * 1024;
        void* extra_memory;

        while (1)
            {
            extra_memory = rt.core.stdc.stdlib.malloc(extra_memory_size);
            if (extra_memory is null)
                goto Lerror;

            // Obtain info from database.
            passwd *verify;
            rt.core.stdc.errno_.setErrno(0);
            if (getpwnam_r(username.ptr, &result, cast(char*)extra_memory, extra_memory_size,
                &verify) == 0)
                {
                // Failure if verify doesn't point at result.
                if (verify != &result)
                // username is not found, so return path[]
                    goto Lnotfound;
                break;
                }

            if (rt.core.stdc.errno_.getErrno() != ERANGE)
                goto Lerror;

            // extra_memory isn't large enough
            rt.core.stdc.stdlib.free(extra_memory);
            extra_memory_size *= 2;
            }

        auto pwdirlen = strlen(result.pw_dir);
        path = Path.join(result.pw_dir[0..pwdirlen].dup, path[last_char..$]);

        Lnotfound:
            rt.core.stdc.stdlib.free(extra_memory);
            return path;

        Lerror:
            // Errors are going to be caused by running out of memory
            if (extra_memory)
                rt.core.stdc.stdlib.free(extra_memory);
            throw new OutOfMemoryException("Not enough memory for user lookup in tilde expansion.", __LINE__);
    }

}

version (Windows)
{

    /******************************************************************************

        Performs tilde expansion in paths.

        There are two ways of using tilde expansion in a path. One
        involves using the tilde alone or followed by a path separator. In
        this case, the tilde will be expanded with the value of the
        environment variable <i>HOME</i>.  The second way is putting
        a username after the tilde (i.e. <tt>~john/Mail</tt>). Here,
        the username will be searched for in the user database
        (i.e. <tt>/etc/passwd</tt> on Unix systems) and will expand to
        whatever path is stored there.  The username is considered the
        string after the tilde ending at the first instance of a path
        separator.

        Note that using the <i>~user</i> syntax may give different
        values from just <i>~</i> if the environment variable doesn't
        match the value stored in the user database.

        When the environment variable version is used, the path won't
        be modified if the environment variable doesn't exist or it
        is empty. When the database version is used, the path won't be
        modified if the user doesn't exist in the database or there is
        not enough memory to perform the query.

        Returns: inputPath with the tilde expanded, or just inputPath
        if it could not be expanded.

        Throws: OutOfMemoryException if there is not enough memory to 
                perform the database lookup for the <i>~user</i> syntax.

        Examples:
        -----
        import tango.sys.HomeFolder;

        void processFile(char[] filename)
        {
             char[] path = expandTilde(filename);
            ...
        }
        -----

        -----
        import tango.sys.HomeFolder;

        const char[] RESOURCE_DIR_TEMPLATE = "~/.applicationrc";
        char[] RESOURCE_DIR;    // This gets expanded below.

        static this()
        {
            RESOURCE_DIR = expandTilde(RESOURCE_DIR_TEMPLATE);
        }
        -----
    ******************************************************************************/

    char[] expandTilde(char[] inputPath)
    {
        inputPath = Path.standard(inputPath);

        if (inputPath.length < 1 || inputPath[0] != '~') {
            return inputPath;
        }

        if (inputPath.length == 1 || inputPath[1] == '/') {
            return expandCurrentUser(inputPath);
        }

        return expandOtherUser(inputPath);
    }

    private char[] expandCurrentUser(char[] path)
    {
        auto userProfileDir = homeFolder;
        auto offset = TextUtil.locate(path, '/');

        if (offset == path.length) {
            return userProfileDir;
        }

        return Path.join(userProfileDir, path[offset+1..$]);
    }

    private char[] expandOtherUser(char[] path)
    {
        auto profileDir = Path.parse(homeFolder).parent;
        return Path.join(profileDir, path[1..$]);
    }
}

/*******************************************************************************

*******************************************************************************/

debug(UnitTest) {
unittest
{
    version (Posix)
    {
    // Retrieve the current home variable.
    char[] home = Environment.get("HOME");

    // Testing when there is no environment variable.
    Environment.set("HOME", null);
    assert(expandTilde("~/") == "~/");
    assert(expandTilde("~") == "~");

    // Testing when an environment variable is set.
    Environment.set("HOME", "tango/test");
    assert(expandTilde("~/") == "tango/test/");
    assert(expandTilde("~") == "tango/test");

    // The same, but with a variable ending in a slash.
    Environment.set("HOME", "tango/test/");
    assert(expandTilde("~/") == "tango/test/");
    assert(expandTilde("~") == "tango/test");

    // Recover original HOME variable before continuing.
    if (home)
        Environment.set("HOME", home);
    else
        Environment.set("HOME", null);

    // Test user expansion for root. Are there unices without /root?
    assert(expandTilde("~root") == "/root" || expandTilde("~root") == "/var/root");
    assert(expandTilde("~root/") == "/root/" || expandTilde("~root") == "/var/root");
    assert(expandTilde("~Idontexist/hey") == "~Idontexist/hey");
    }
}
}


version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
