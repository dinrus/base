﻿module sys.WinProcess;
import cidrus, tpl.stream;

extern(D) class ППоток : Поток 
{
   this(ткст команда);    
    override т_мера читайБлок(ук буфер, т_мера размер);    
    override т_мера пишиБлок(ук буфер, т_мера размер);    
    override бдол сместись(дол offset, ППозКурсора whence);	
    проц закрой();    
	бцел значВыхода();
    
}

extern(D) class ИсклУгасшегоПроцесса : Исключение { this(ткст smsg);}

extern(C):

проц сисИлиАборт(ткст кмнд);
цел скажиИСис(ткст кмнд);
проц скажиСисАборт(ткст кмнд);
цел сисРеспонс(ткст кмнд, ткст рфлаг, ткст рфайл, бул удалитьРФайл);
проц сисРИлиАборт(ткст кмнд, ткст рфлаг, ткст рфайл, бул удалитьРФайл);
цел скажиИСисР(ткст кмнд, ткст рфлаг, ткст рфайл, бул удалитьРФайл);
проц скажиСисРАборт(ткст кмнд, ткст рфлаг, ткст рфайл, бул удалитьРФайл);