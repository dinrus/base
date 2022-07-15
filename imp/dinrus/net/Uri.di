module net.Uri;

public  import  net.model.UriView;

//public alias Уир ОбзорУИР;

private import  exception;

private import  Целое = text.convert.Integer;

class Уир : ОбзорУИР
{
        // simplistic ткст добавщик
        private alias т_мера delegate(проц[]) Consumer;  
        
        /// old метод names
        public alias порт        дайПорт;
        public alias дефолтнПорт дайДефолтнПорт;
        public alias схема      дайСхему;
        public alias хост        дайХост;
        public alias валКЦЕПорт   дайВалидныйПорт;
        public alias инфОПользователе    дайИнфОПользователе;
        public alias путь        дайПуть;
        public alias запрос       дайЗапрос;
        public alias фрагмент    дайФрагмент;
        public alias порт        устПорт;
        public alias схема      устСхему;
        public alias хост        устХост;
        public alias инфОПользователе    устИнфОПользователе;
        public alias запрос       устЗапрос;
        public alias путь        установиПуть;
        public alias фрагмент    устФрагмент;

        public enum {InvalКСЕРort = -1}
/*
        private цел             порт_;
        private ткст          host_,
                                путь_,
                                query_,
                                scheme_,
                                userinfo_,
                                fragment_;
        private СрезКучи       decoded;

        private static ббайт    карта[];

        private static крат[ткст] genericSchemes;

        private static const ткст hexDigits = "0123456789abcdef";

        private static const SchemePort[] schemePorts =
                [
                {"coffee",      80},
                {"file",        InvalКСЕРort},
                {"ftp",         21},
                {"gopher",      70},
                {"hnews",       80},
                {"http",        80},
                {"http-ng",     80},
                {"https",       443},
                {"imap",        143},
                {"irc",         194}, 
                {"ldap",        389},
                {"news",        119},
                {"nfs",         2049}, 
                {"nntp",        119},
                {"pop",         110}, 
                {"rwhois",      4321},
                {"shttp",       80},
                {"smtp",        25},
                {"snews",       563},
                {"telnet",      23},
                {"wais",        210},
                {"whois",       43},
                {"whois++",     43},
                ];
*/
        public enum    
        {       
                ExcScheme       = 0x01,         
                ExcAuthority    = 0x02, 
                ExcPath         = 0x04, 
                IncUser         = 0x80,         // кодируй spec for User
                IncPath         = 0x10,         // кодируй spec for Путь
                IncQuery        = 0x20,         // кодируй spec for Query
                IncQueryAll     = 0x40,
                IncScheme       = 0x80,         // кодируй spec for Scheme
                IncGeneric      = IncScheme | 
                                  IncUser   | 
                                  IncPath   | 
                                  IncQuery  | 
                                  IncQueryAll
        }

        // схема и порт pairs
        /*
        private struct SchemePort
        {
                ткст  имя;
                крат   порт;
        }
*/
     //   static this ();

        this ();
        this (ткст уир);
        this (ткст схема, ткст хост, ткст путь, ткст запрос = пусто);
        this (ОбзорУИР другой);
        final цел дефолтнПорт (ткст схема);
        final ткст схема();
        final ткст хост();
        final цел порт();
        final цел валКЦЕПорт();
        final ткст инфОПользователе();
        final ткст путь();
        final ткст запрос();
        final ткст фрагмент();
        final бул генерен_ли ();
        final т_мера произведи (Consumer используй);
        final ткст вТкст ();
        static т_мера кодируй (Consumer используй, ткст s, цел флаги);
        static ткст кодируй (ткст текст, цел флаги);
        //private ткст декодер (ткст s, сим ignore=0);
        final ткст раскодируй (ткст s);
        final Уир разбор (ткст уир, бул relative = нет);
        final проц сбрось();
        final Уир отнРазбор (ткст уир);
        final Уир схема (ткст схема);
        final Уир хост (ткст хост);
        final Уир порт (цел порт);
        final Уир инфОПользователе (ткст инфОПользователе);
        final Уир запрос (ткст запрос);
        final ткст расширьЗапрос (ткст хвост);
        final Уир путь (ткст путь);
        final Уир фрагмент (ткст фрагмент);
      //  private проц parseAuthority (ткст auth);
      //  private final ткст toLastSlash (ткст путь);
       // private final static ткст вПроп (ref ткст ист);
}


/*******************************************************************************
        
*******************************************************************************/

private struct СрезКучи
{
        private бцел    использован;
        private проц[]  буфер;

        final проц сбрось ();
        final ук расширь (бцел размер);
        final проц[] срез (цел размер);
}