 import stdrus, util.worktools;

alias stdrus.скажифнс ск;
alias util.worktools.удалиФайлы уд;

const ткст[] расш = [ "*.obj", "*.map", "*.bak"];//,"*.dep", "*.tmp"];
const ткст[] файлы = ["CDinr.lib","la.lib", "st.lib", "geom.lib", "mesh.lib", "math.lib", "util.lib", "col.lib", "dlib.lib", "dinrus2.lib", "dinrus2_dbg.lib", "io.lib", "crypto.lib", "time.lib", "text.lib"];
const ткст ТП;

static this()
{
ТП = дайтекпап();
}

проц удаляй()
{
	foreach (р; расш)
	{
	уд(ТП, р );
    }  
}


проц main(ткст[] арги)
{
	ск("Начало послепостроечной очистки в папке "~ТП );	

	foreach (ф; файлы)
	{
		 if(естьФайл(ф)) {
		 удалиФайл(фм(ТП~"\\"~ф));
		 ск("Удалён "~ф);
		 }	 
	}
	сис( фм("del "~ТП~"\\"~"*.rsp"));
try	{
	удаляй();
	}catch(Искл искл){искл.выведи;}	
	нс;
	ск("Операция удаления файлов завершена.");
	нс;
	нс;
	//выход(0);
}