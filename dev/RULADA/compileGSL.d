import std.file;
import std.process;
import std.io, std.string;


цел компилируйПакет(ткст путь, ткст англИмяСтатБиб)
{

sys("del *.obj");	
scope files = std.file.listdir(путь, "*.d"); 
     foreach (d; files)
	 {
		sys(format("d:\\dinrus\\bin\\dmd -c %s", d));	
		say("Компиляция модуля:"); writefln(d);
	 }
	 sys("d:\\dinrus\\bin\\ls2 -d *.obj>>objs.rsp");	
	 sys(format("d:\\dinrus\\bin\\dmlib -p128 -c "~англИмяСтатБиб~".lib @objs.rsp"));	
	 sys("del*.obj");
	 return 0;
}

 цел удалиФайлы(ткст флрасш)
 { 
 цел удалено = 0;

скажи("Строится список файлов => "~флрасш).нс;
нс;
	auto файлы = списпап(".", флрасш);
	скажи(format("Обнаружено %i файлов.", файлы.length)).нс;
	foreach (d; файлы)
	{	try
		{
		удали(d);
		удалено++;
		}
		catch(ВВИскл искл){throw искл;}
		скажи("Удалён : "~d).нс;		
	}
	нс;
	скажи("Файлов удалено: "); пишифнс("%d", удалено);
	нс;
	return 0;
}

void main()
{
	компилируйПакет("d:\\dinrus\\dev\\RULADA\\dev\\gsl\\gsl\\", "gsl");
}