module scConfig;
import cidrus, stdrus, stdrusex, exception;

version(UCRT)
{
	pragma(lib, "ucrt.lib");
	
	extern(C)
	{
	int _waccess(wchar* path, int access_mode);
	int _wchmod(wchar* path, int mode);
	}
}
alias пауза пз;
alias stdrusex.раскройГлоб рг;

//extern(C) проц сбросьЦветКонсоли();


const ткст КОНФИГ_РЕБИЛДА;
const ткст КОНФИГ_РУЛАДЫ;
const ткст КОНФИГ_РУЛАДЫДОП;
const ткст КОНФИГ_РУЛАДЫДОП_ГИП;
const ткст КОНФИГ_ДИНРУС;
const ткст КОНФИГ_ДИНРУС2;
const ткст КОНФИГ_ДИНРУСДОП;
const ткст КОНФИГ_ДИНРУСДОП_ГИП;
const ткст РЕБИЛД_КОНФ;
const ткст СЦ_ИНИ;

static this()
{
КОНФИГ_РЕБИЛДА = рг(
"profile=phobos

compiler=%DINRUS%\\dmd.exe
inifile=%DINRUS%\\sc.ini

exeext=.exe
objext=obj
objmodsep=-


version=DigitalMars
noversion=GNU
noversion=linux
noversion=Unix
noversion=Posix
version=Windows
testversion=Win32
testversion=Win64
version=X86
noversion=PPC
noversion=X86_64
version=D_InlineAsm
version=D_InlineAsm_X86
noversion=D_InlineAsm_PPC
noversion=D_InlineAsm_X86_64
version=LittleEndian
noversion=BigEndian


[compile]
cmd=%DINRUS%\\dmd.exe -c $i
response=@

flag=$i
incdir=-I$i
libdir=-L-L$i
optimize=-O
version=-version=$i


[link]
oneatatime=yes
cmd=%DINRUS%\\dmd.exe $i -of$o
response=@

libdir=-L+$i\\
lib=-L+$i.lib
flag=-L$i
gui=-L/subsystem:windows


[liblink]
safe=yes
oneatatime=yes
cmd=%DINRUS%\\dmlib.exe -c -p512 $o $i
response=@

libdir=
lib=
flag=


[postliblink]
cmd=echo $i


[shliblink]
shlibs=no

[dyliblink]
dylibs=no
");

КОНФИГ_ДИНРУС =рг(
	"
[Version]
version=7.51 Build 020

#DINRUS CONSOLE SINGLE

[Environment]
PATH=%DINRUS%\\..
BIN=%DINRUS%
INCLUDE=\"%DINRUS%\\..\\include\";%INCLUDE%
LIB=\"%DINRUS%\\..\\lib\";\"%DINRUS%\\..\\lib\\rulada\";\"%DINRUS%\\..\\lib\\c\";\"%DINRUS%\\..\\lib\\sysimport\"
DFLAGS=\"-I%DINRUS%\\..\\imp\\dinrus\" -O -version=Dinrus -defaultlib=Dinrus.lib -debuglib=Dinrus_dbg.lib
LINKCMD=%DINRUS%\\dmlink.exe
	");
	
КОНФИГ_ДИНРУС2 = рг(
	"	
[Version]
version=7.51 Build 020


; environment for both 32/64 bit
;DINRUS2 CONSOLE SINGLE
[Environment]

INCLUDE=\"%DINRUS%\\..\\include\"
DFLAGS=\"-I%DINRUS%\\..\\dev\\dinrus\\Runtime\\Dinrus2\\src\" \"-I%DINRUS%\\..\\imp\\dinrus2\" -O -version=Dinrus2 -defaultlib=Dinrus2.lib -debuglib=Dinrus2_dbg.lib\"

; optlink only reads from the Environment section so we need this redundancy
; from the Environment32 section (bugzilla 11302)
LIB=\"%DINRUS%\\..\\lib\"
LINKCMD=%DINRUS%\\dmlink.exe

[Environment32]
LIB=\"%DINRUS%\\..\\lib\"
LINKCMD=%DINRUS%\\optlink.exe


[Environment64]
LIB=\"%DINRUS%\\..\\lib64\"

; -----------------------------------------------------------------------------
[Environment32mscoff]
LIB=\"%DINRUS%\\..\\lib32mscoff\"
	");
	
КОНФИГ_ДИНРУСДОП = рг(
	"
[Version]
version=7.51 Build 020

#DINRUS CONSOLE FULL

[Environment]
PATH=%DINRUS%\\..
BIN=%DINRUS%
INCLUDE=\"%DINRUS%\\..\\include\";%INCLUDE%
LIB=\"%DINRUS%\\..\\lib\";\"%DINRUS%\\..\\lib\\rulada\";\"%DINRUS%\\..\\lib\\c\";\"%DINRUS%\\..\\lib\\sysimport\"
DFLAGS=\"-I%DINRUS%\\..\\imp\\dinrus\" -O -version=Dinrus -defaultlib=Dinrus.lib -debuglib=Dinrus_dbg.lib -L+DinrusWin32.lib+DinrusConc.lib+DinrusDbi.lib+DinrusViz.lib+DImport.lib
LINKCMD=%DINRUS%\\dmlink.exe
	");
	
КОНФИГ_ДИНРУСДОП_ГИП =рг(
	"
[Version]
version=7.51 Build 020

#DINRUS CONSOLE FULL

[Environment]
PATH=%DINRUS%\\..
BIN=%DINRUS%
INCLUDE=\"%DINRUS%\\..\\include\";%INCLUDE%
LIB=\"%DINRUS%\\..\\lib\";\"%DINRUS%\\..\\lib\\rulada\";\"%DINRUS%\\..\\lib\\c\";\"%DINRUS%\\..\\lib\\sysimport\"
DFLAGS=\"-I%DINRUS%\\..\\imp\\dinrus\" -O -version=Dinrus -defaultlib=Dinrus.lib -debuglib=Dinrus_dbg.lib -L+DinrusWin32.lib+DinrusConc.lib+DinrusDbi.lib+DinrusViz.lib+DImport.lib -L/exet:nt/su:windows:4.0
LINKCMD=%DINRUS%\\optlink.exe
	");
	
КОНФИГ_РУЛАДЫ =рг(
	"
[Version]
version=7.51 Build 020

#RULADA CONSOLE SINGLE

[Environment]
PATH=%DINRUS%\\..
BIN=%DINRUS%
INCLUDE=\"%DINRUS%\\..\\include\";%INCLUDE%
LIB=\"%DINRUS%\\..\\lib\";\"%DINRUS%\\..\\lib\\rulada\";\"%DINRUS%\\..\\lib\\rulada_eng\";\"%DINRUS%\\..\\lib\\c\";\"%DINRUS%\\..\\lib\\sysimport\"
DFLAGS=\"-I%DINRUS%\\..\\imp\\rulada_eng\" -O -version=Rulada -defaultlib=rulada.lib -debuglib=rulada.lib
LINKCMD=%DINRUS%\\optlink.exe
	");
	
КОНФИГ_РУЛАДЫДОП =рг(
	"
[Version]
version=7.51 Build 020

#RULADA CONSOLE FULL

[Environment]
PATH=%DINRUS%\\..
BIN=%DINRUS%
INCLUDE=\"%DINRUS%\\..\\include\";%INCLUDE%
LIB=\"%DINRUS%\\..\\lib\";\"%DINRUS%\\..\\lib\\rulada\";\"%DINRUS%\\..\\lib\\rulada_eng\";\"%DINRUS%\\..\\lib\\c\";\"%DINRUS%\\..\\lib\\sysimport\"
DFLAGS=\"-I%DINRUS%\\..\\imp\\rulada_eng\" -O -version=Rulada -defaultlib=rulada.lib -debuglib=rulada.lib -L+RuladaWX.lib+derelict.lib+tango.lib+auxc.lib+auxd.lib+amigos.lib+arc.lib+gtkD.lib+dgui.lib
LINKCMD=%DINRUS%\\optlink.exe
	");
	
КОНФИГ_РУЛАДЫДОП_ГИП =рг(
	"
[Version]
version=7.51 Build 020

#RULADA CONSOLE FULL

[Environment]
PATH=%DINRUS%\\..
BIN=%DINRUS%
INCLUDE=\"%DINRUS%\\..\\include\";%INCLUDE%
LIB=\"%DINRUS%\\..\\lib\";\"%DINRUS%\\..\\lib\\rulada\";\"%DINRUS%\\..\\lib\\rulada_eng\";\"%DINRUS%\\..\\lib\\c\";\"%DINRUS%\\..\\lib\\sysimport\"
DFLAGS=\"-I%DINRUS%\\..\\imp\\rulada_eng\" -O -version=Rulada -defaultlib=rulada.lib -debuglib=rulada.lib -L+derelict.lib+tango.lib+amigos.lib+arc.lib+gtkD.lib+RuladaWX.lib+dgui.lib -L/exet:nt/su:windows:4.0
LINKCMD=%DINRUS%\\optlink.exe
	");
	
	РЕБИЛД_КОНФ = рг("%DINRUS%\\..\\etc\\rebuild\\dmd-win");
	СЦ_ИНИ = рг("%DINRUS%\\sc.ini");
}

бул проверьЗапись(ткст файл)
{
version(UCRT) {if( _waccess(вЮ16н(файл), 2) != -1) return да;}
return нет;
}

проц реконфигурируйРебилд()
{
	запиши_в(РЕБИЛД_КОНФ, КОНФИГ_РЕБИЛДА);
}

	
проц версияДинрус()
{
	try
	{
	запиши_в(СЦ_ИНИ, КОНФИГ_ДИНРУС);
		скажифнс("Файл sc.ini изменён. Его текст теперь следующий:
		%s", читай_из(СЦ_ИНИ));
	нс;
	скажинс(" ВЕРСИЯ = ДИНРУС КОНСОЛЬ ");

	}
	catch(ФайлИскл фи)
	{
	}

}
	
проц версияДинрусДоп()
{
	
	try
	{
	запиши_в(СЦ_ИНИ, КОНФИГ_ДИНРУСДОП);
	скажифнс("Файл sc.ini изменён. Его текст теперь следующий: %s", читай_из(СЦ_ИНИ));
	нс;
	скажинс(" ВЕРСИЯ = ДИНРУС КОНСОЛЬ С ДОБАВОЧНЫМИ БИБЛИОТЕКАМИ");
	}
	catch(ФайлИскл фи)
	{
	}

}
	
проц версияДинрусДоп_ГИП()
{
	try
	{
	запиши_в(СЦ_ИНИ, КОНФИГ_ДИНРУСДОП_ГИП);
	скажифнс("Файл sc.ini изменён. Его текст теперь следующий: %s", читай_из(рг(СЦ_ИНИ)));
	нс;
	скажинс(" ВЕРСИЯ = ДИНРУС ДЛЯ ГИП-ПРИЛОЖЕНИЙ С ДОБАВОЧНЫМИ БИБЛИОТЕКАМИ ");
	}
	catch(ФайлИскл фи)
	{
	}

}
	
проц версияРулада()
{
	try
	{
	запиши_в(СЦ_ИНИ, КОНФИГ_РУЛАДЫ);
	скажифнс("Файл sc.ini изменён. Его текст теперь следующий: %s", читай_из(рг(СЦ_ИНИ)));
	нс;
	скажинс(" ВЕРСИЯ = РУЛАДА КОНСОЛЬ ");	
	}
	catch(ФайлИскл фи)
	{
	}


}
	
проц версияРуладаДоп()
{
	try
	{
	запиши_в(СЦ_ИНИ, КОНФИГ_РУЛАДЫДОП);	
	скажифнс("Файл sc.ini изменён. Его текст теперь следующий: %s", читай_из(рг(СЦ_ИНИ)));
	нс;
	скажинс(" ВЕРСИЯ = РУЛАДА КОНСОЛЬ С ДОБАВОЧНЫМИ БИБЛИОТЕКАМИ");
	}
	catch(ФайлИскл фи)
	{
	}


}

проц версияРуладаДоп_ГИП()
{
	try
	{
	запиши_в(СЦ_ИНИ, КОНФИГ_РУЛАДЫДОП_ГИП);	
	скажифнс("Файл sc.ini изменён. Его текст теперь следующий: %s", читай_из(рг(СЦ_ИНИ)));
	нс;
	скажинс(" ВЕРСИЯ = РУЛАДА КОНСОЛЬ С ДОБАВОЧНЫМИ БИБЛИОТЕКАМИ для ГИП");
	}
	catch(ФайлИскл фи)
	{
	}


}

проц версияДинрус2()
{
	try
	{
	запиши_в(СЦ_ИНИ, КОНФИГ_ДИНРУС2);
	скажифнс("Файл sc.ini изменён. Его текст теперь следующий: %s", читай_из(СЦ_ИНИ));
	нс;
	скажинс(" ВЕРСИЯ = ДИНРУС2 КОНСОЛЬ ");
	}
	catch(ФайлИскл фи)
	{
	}

}
/+
	
version(DinrusExG)
{

	проц main()
	{
	версияДинрусДоп_ГИП();
		выход(0);
	}

}

version(DinrusEx)
{

	проц main()
	{
	версияДинрусДоп();
		выход(0);
	}

}

version(DR)
{

	проц main()
	{
	версияДинрус();
		выход(0);
	}

}

version(RD)
{

	проц main()
	{
	версияРулада();
		выход(0);
	}

}

version(RuladaEx)
{

	проц main()
	{
	версияРуладаДоп();
		выход(0);
	}

}
+/