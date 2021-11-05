module time.chrono.GregorianBased;

private import exception;
private import time.Time;
private import time.chrono.Gregorian;

extern(D) class ГрегорианВОснове : Грегориан
{
     this();
     override Время воВремя(бцел год, бцел месяц, бцел день, бцел час, бцел минута, бцел секунда, бцел миллисекунда, бцел эра);	
     override бцел дайГод(Время время);
     override бцел дайЭру(Время время);
     override бцел[] эры();
   // private бцел дайГрегорианскийГод(бцел год, бцел эра);
  //  protected бцел текущаяЭра();
}


/*
package struct ДиапазонЭр
{

    private static ДиапазонЭр[][бцел] eraRanges;
    private static бцел[бцел] currentEras;
    private static бул initialized_;

    package бцел эра;
    package дол тики;
    package бцел смещениеГода;
    package бцел годМинЭры;
    package бцел годМаксЭры;

    private static проц инициализуй();
    package static ДиапазонЭр[] дайДиапазоныЭр(бцел calID);
    package static бцел дайТекущуюЭру(бцел calID);
    private static ДиапазонЭр opCall(бцел эра, дол тики, бцел смещениеГода, бцел годМинЭры, бцел годПредыдущЭры);

}

*/