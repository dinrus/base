module time.StopWatch;

private import exception;

version (Win32)
{
        private extern (Windows) 
        {
        цел QueryPerformanceCounter   (бдол *счёт);
        цел QueryPerformanceFrequency (бдол *frequency);
        }
}

version (Posix)
{
        private import rt.core.stdc.posix.sys.time;
}

export struct Секундомер
{
        private бдол  пущен;
        private static дво множитель = 1.0 / 1_000_000.0;

        version (Win32)
                 private static дво микросекунда;

        export проц старт()
        {
                пущен = таймер;
        }
        
       export дво стоп()
        {
                return множитель * (таймер - пущен);
        }

       export бдол микросек()
        {
                version (Posix)
                         return (таймер - пущен);

                version (Win32)
                         return cast(бдол) ((таймер - пущен) * микросекунда);
        }

        export static this()
        {
                version (Win32)
                {
                        бдол freq;

                        QueryPerformanceFrequency (&freq);
                        микросекунда = 1_000_000.0 / freq;       
                        множитель = 1.0 / freq;       
                }
        }

        private static бдол таймер()
        {
                version (Posix)       
                {
                        значврем tv;
                        if (gettimeofday (&tv, пусто))
                            throw new PlatformException ("Timer :: linux таймер недоступен");

                        return (cast(бдол) tv.сек * 1_000_000) + tv.микросек;
                }

                version (Win32)
                {
                        бдол сейчас;

                        if (! QueryPerformanceCounter (&сейчас))
                              throw new PlatformException ("таймер высокого разрешения недоступен");

                        return сейчас;
                }
        }
}


/*******************************************************************************

*******************************************************************************/

debug (Секундомер)
{
        import io.Stdout;

        проц main() 
        {
                Секундомер t;
                t.старт;

                for (цел i=0; i < 100_000_000; ++i)
                    {}
                Стдвыв.форматируй ("{:f9}", t.стоп).нс;
        }
}
