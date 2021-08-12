﻿module tango.sys.win32.consts.errno;

    const EPERM             = 1;        // Operation not permitted
    const ENOENT            = 2;        // No such file or directory
    const ESRCH             = 3;        // No such process
    const EINTR             = 4;        // Interrupted system call
    const EIO               = 5;        // I/O error
    const ENXIO             = 6;        // No such device or address
    const E2BIG             = 7;        // Argument list too long
    const ENOEXEC           = 8;        // Exec format error
    const EBADF             = 9;        // Bad file number
    const ECHILD            = 10;       // No child processes
    const EAGAIN            = 11;       // Try again
    const ENOMEM            = 12;       // Out of memory
    const EACCES            = 13;       // Permission denied
    const EFAULT            = 14;       // Bad address
    const EBUSY             = 16;       // Device or resource busy
    const EEXIST            = 17;       // File exists
    const EXDEV             = 18;       // Cross-device link
    const ENODEV            = 19;       // No such device
    const ENOTDIR           = 20;       // Not a directory
    const EISDIR            = 21;       // Is a directory
    const EINVAL            = 22;       // Invalid argument
    const ENFILE            = 23;       // File table overflow
    const EMFILE            = 24;       // Too many open files
    const ENOTTY            = 25;       // Not a typewriter
    const EFBIG             = 27;       // File too large
    const ENOSPC            = 28;       // No space left on device
    const ESPIPE            = 29;       // Illegal seek
    const EROFS             = 30;       // Read-only file system
    const EMLINK            = 31;       // Too many links
    const EPIPE             = 32;       // Broken pipe
    const EDOM              = 33;       // Math argument out of domain of func
    const ERANGE            = 34;       // Math result not representable
    const EDEADLK           = 36;       // Resource deadlock would occur
    const ENAMETOOLONG      = 38;       // File name too long
    const ENOLCK            = 39;       // No record locks available
    const ENOSYS            = 40;       // Function not implemented
    const ENOTEMPTY         = 41;       // Directory not empty
    const EILSEQ            = 42;       // Illegal byte sequence
    const EDEADLOCK         = EDEADLK;

version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
