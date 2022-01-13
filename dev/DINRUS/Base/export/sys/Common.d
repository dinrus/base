module sys.common;

version (Win32)
        {
	  
public  import sys.WinConsts, sys.WinIfaces, sys.WinStructs, sys.WinFuncs, sys.uuid;
//public import io.Console;

        }
/+
version (linux)
        {
        public import sys.linux.linux;
        alias sys.linux.linux posix;
        }

version (darwin)
        {
        public import sys.darwin.darwin;
        alias sys.darwin.darwin posix;
        }
version (freebsd)
        {
        public import sys.freebsd.freebsd;
        alias sys.freebsd.freebsd posix;
        }
version (solaris)
        {
        public import sys.solaris.solaris;
        alias sys.solaris.solaris posix;
        }

        +/

