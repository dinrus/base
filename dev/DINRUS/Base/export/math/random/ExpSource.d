/*******************************************************************************
        copyright:      Copyright (c) 2008. Fawzi Mohamed
        license:        BSD стиль: $(LICENSE)
        version:        Initial release: July 2008
        author:         Fawzi Mohamed
*******************************************************************************/
module math.random.ExpSource;
private import Целое = text.convert.Integer;
import math.Math:эксп,лог;
import math.random.Ziggurat;
import tpl.traits:типРеал_ли;

/// class that returns exponential distributed numbers (f=эксп(-x) for x>0, 0 иначе)
final class ЭкспИсточник(СлучГ,T){
    static assert(типРеал_ли!(T),T.stringof~" not acceptable, only floating точка variables supported");
    /// probability ни в каком дистрибутиве
    static реал плотностьВерФ(реал x){ return эксп(-x); }
    /// inverse probability ни в каком дистрибутиве
    static реал инвПлотностьВерФ(реал x){ return -лог(x); }
    /// complement of the cumulative density ни в каком дистрибутиве (integral x..infinity плотностьВерФ)
    static реал кумПлотностьВерФКомпл(реал x){ return эксп(-x); }
    /// хвост for exponential ни в каком дистрибутиве
    static T хвостГенератор(СлучГ r, T dMin) 
    { 
        return dMin-лог(r.униформа!(T));
    }
    alias Циггурат!(СлучГ,T,плотностьВерФ,хвостГенератор,нет) ТИсток;
    /// internal исток of эксп distribued numbers
    ТИсток исток;
    /// initializes the probability ни в каком дистрибутиве
    this(СлучГ r){
        исток=ТИсток.создай!(инвПлотностьВерФ,кумПлотностьВерФКомпл)(r,0xf.64ec94bf5dc14bcp-1L);
    }
    /// chainable вызов стиль initialization of variables (thorugh a вызов в_ рандомируй)
    ЭкспИсточник opCall(U,S...)(ref U a,S арги){
        рандомируй(a,арги);
        return this;
    }
    /// returns a эксп distribued число
    T дайСлучайный(){
        return исток.дайСлучайный();
    }
    /// returns a эксп distribued число with the given бета (survival rate, average)
    /// f=1/бета*эксп(-x/бета)
    T дайСлучайный(T бета){
        return бета*исток.дайСлучайный();
    }
    /// initializes the given переменная with an exponentially distribued число
    U рандомируй(U)(ref U x){
        return исток.рандомируй(x);
    }
    /// initializes the given переменная with an exponentially distribued число with
    /// шкала parameter бета
    U рандомируй(U,З)(ref U x,З бета){
        return исток.рандомирОп((T el){ return el*cast(T)бета; },x);
    }
    /// initializes the given переменная with an exponentially distribued число и maps op on it
    U рандомирОп(U,S)(S delegate(T)op,ref U a){
        return исток.рандомирОп(op,a);
    }
    /// эксп ни в каком дистрибутиве with different default шкала parameter бета
    /// f=1/бета*эксп(-x/бета) for x>0, 0 иначе
    struct ЭкспДистрибуция{
        T бета;
        ЭкспИсточник исток; // does not use Циггурат directly в_ keep this struct small
        /// constructor
        static ЭкспДистрибуция создай()(ЭкспИсточник исток,T бета){
            ЭкспДистрибуция рез;
            рез.бета=бета;
            рез.исток=исток;
            return рез;
        }
        /// chainable вызов стиль initialization of variables (thorugh a вызов в_ рандомируй)
        ЭкспДистрибуция opCall(U,S...)(ref U a,S арги){
            рандомируй(a,арги);
            return *this;
        }
        /// returns a single число
        T дайСлучайный(){
            return бета*исток.дайСлучайный();
        }
        /// инициализуй a
        U рандомируй(U)(ref U a){
            return исток.рандомирОп((T x){return бета*x; },a);
        }
        /// инициализуй a
        U рандомируй(U,З)(ref U a,З b){
            return исток.рандомирОп((T x){return (cast(T)b)*x; },a);
        }
    }
    /// returns an эксп ни в каком дистрибутиве with a different бета
    ЭкспДистрибуция экспД(T бета){
        return ЭкспДистрибуция.создай(this,бета);
    }
}
