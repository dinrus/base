module net.SocketConduit;

public  import  io.device.Conduit;

private import  net.Socket;

class СокетПровод : Провод, ИВыбираемый
{
       // private значврем                 tv;
       // private НаборСокетов               ss;
        package Сокет                  сокет_;
      //  private бул                    таймаут;

        // фрилист support
       // private СокетПровод           следщ;   
      //  private бул                    fromList;
      //  private static СокетПровод    фрилист;

        this ();

        this (ПСемействоАдресов семейство, ПТипСок тип, ППротокол протокол);

      //  private this (ПСемействоАдресов семейство, ПТипСок тип, ППротокол протокол, бул создать);

        override ткст вТкст();

        Сокет сокет ();

        override т_мера размерБуфера ();

         Дескр фукз ();

        СокетПровод установиТаймаут (плав таймаут);

        бул былТаймаут ();

        override бул жив_ли ();

        СокетПровод подключись (Адрес адр);

        СокетПровод вяжи (Адрес адрес);

        СокетПровод глуши ();

        override проц открепи ();

        override т_мера читай (проц[] приёмн);
        
        override т_мера пиши (проц[] ист);

        package final synchronized т_мера читай (проц[] приёмн, т_мера delegate(проц[]) дг);
        
        package static synchronized СокетПровод размести ();

        //private static synchronized проц вымести (СокетПровод s);
}


