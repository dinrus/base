module lib.curl;
//the equiv to curl.h.... But only adding what i need.
import dinrus, stringz;

alias ук ЦУРЛ;

const цел ЦУРЛОШ_ОК = 0;
const цел ЦУРЛОШ_РАЗМ = 256;

enum ПОпцияЦурл : цел {
	БезПрогресса = 43,
	ПадениеПриОш = 45,
	СледуйЛокации = 52,
	Файл = 10001,
	ПишиДанные = 10001,
	Урл = 10002,
	ОшБуфер = 10010,
	АгентПользователя = 10018,
	ПишиЗаг = 10029,
	ПишиФункцию = 20011,
	ФункцияПрогресса = 20056,
	ФункцияЗага = 20079
}

extern(C)
{
	ЦУРЛ* function() цурл_легко_иниц;
	проц function(ЦУРЛ* укз) цурл_легко_очисть;
	цел function(ЦУРЛ* укз, ПОпцияЦурл опц, ...) цурл_легко_устопц;
	цел function(ЦУРЛ* укз) цурл_легко_выполни;
	char* function() цурл_версия;
}
проц грузи(Биб биб)
{
    вяжи(цурл_версия)("curl_version", биб);
	вяжи(цурл_легко_иниц)("curl_easy_init", биб);
	вяжи(цурл_легко_очисть)("curl_easy_cleanup", биб);
	вяжи(цурл_легко_устопц)("curl_easy_setopt", биб);
	вяжи(цурл_легко_выполни)("curl_easy_perform", биб);
}
/////////////////////////////////////////////////////
ЖанБибгр ЦурлЗагр;

	static this()
	{
		ЦурлЗагр.заряжай("DinrusCurlX86.dll", &грузи );
		ЦурлЗагр.загружай();
	}

	static ~this()
	{
		ЦурлЗагр.выгружай();
	}
////////////////////////////////////////////////////	
private enum ПРежимЦурл { Ткст, Файл }

class ЦурлИскл : Искл {
	this(ткст msg) {
		super(msg);
	}
}

//the main class for easy curl. may be renamed in the future.
class Цурл {
	ЦУРЛ* м_цурл;
	ткст м_последнОш;
	цел м_последнКодЦурл;
	ткст[] м_полученныеЗаги;
	бул myFollowLocation;
	ткст м_буфер;
	ПРежимЦурл м_режим;
	Файл м_файл;
	ткст м_имяф;

	public ткст[] дайЗаги() { return м_полученныеЗаги.dup; }

	this() {
		м_цурл = цурл_легко_иниц();
		if (м_цурл is пусто) throw new ЦурлИскл("Ошибка при curl_easy_init!");
		м_последнОш = new char[ЦУРЛОШ_РАЗМ];
		м_последнОш[0] = '\0';
		устОпц(ПОпцияЦурл.ОшБуфер, &м_последнОш);
		устОпц(ПОпцияЦурл.ПишиЗаг, cast(проц*)this);
		устОпц(ПОпцияЦурл.ПишиДанные, cast(проц*)this);
		устОпц(ПОпцияЦурл.ФункцияЗага, &headerCallback);
		устОпц(ПОпцияЦурл.ПишиФункцию, &writeCallback);
		myFollowLocation = true;
		устОпц(ПОпцияЦурл.СледуйЛокации, 1);
	}
	~this() {
		if (м_цурл !is пусто) {
			цурл_легко_очисть(м_цурл);
			удалиФайл(м_имяф);
		}
	}

	public ткст дайТкст(ткст урл) {
		очистьБуферы();
		м_режим = ПРежимЦурл.Ткст;
		устОпц(ПОпцияЦурл.Урл, stringz.вТкст0(урл));
		м_последнКодЦурл = цурл_легко_выполни(м_цурл);
		return м_буфер.dup;
	}
	public проц дайФайл(ткст урл, ткст имяф) {
		очистьБуферы();
		м_режим = ПРежимЦурл.Файл;
		if (естьФайл(имяф)) {
			throw new ЦурлИскл("Файл "~имяф~" уже существует!");
		}
		устОпц(ПОпцияЦурл.Урл, stringz.вТкст0(урл));
		м_файл = new Файл(имяф, ПРежимФайла.ВыводНов);
		м_последнКодЦурл = цурл_легко_выполни(м_цурл);
		м_файл.закрой();
		м_имяф = имяф;
		return;
	}

	private проц очистьБуферы() {
		м_полученныеЗаги.length = 0;
		м_буфер.length = 0;
	}
	private бул устОпц(ПОпцияЦурл опция, ткст ткт) {
		return цурл_легко_устопц(м_цурл, опция, stringz.вТкст0(ткт)) == ЦУРЛОШ_ОК;
	}
	private бул устОпц(ПОпцияЦурл опция, ук prarm) {
		return цурл_легко_устопц(м_цурл, опция, prarm) == ЦУРЛОШ_ОК;
	}
	private бул устОпц(ПОпцияЦурл опция, цел prarm) {
		return цурл_легко_устопц(м_цурл, опция, prarm) == ЦУРЛОШ_ОК;
	}

	//Call backs.
	private extern (C) static т_мера headerCallback( ук укз, т_мера разм , т_мера колво_членов, ук объ ) {
		Цурл цурлобъ = cast(Цурл)объ;
		ткст ткт = убериразгр(stringz.изТкст0(cast(ткст0)укз)[0 .. (разм * колво_членов)].dup);
		if (ткт.length) {
			цурлобъ.м_полученныеЗаги ~= ткт;
		}
		return разм*колво_членов;
	}
	private extern (C) static т_мера writeCallback( ук укз, т_мера разм , т_мера колво_членов, ук объ ) {
		Цурл цурлобъ = cast(Цурл)объ;
		switch(цурлобъ.м_режим) {
			case ПРежимЦурл.Ткст:
				цурлобъ.м_буфер ~= stringz.изТкст0(cast(ткст0)укз)[0 .. (разм * колво_членов)].dup;
				break;
			case ПРежимЦурл.Файл:
				if (цурлобъ.м_файл !is пусто)
					цурлобъ.м_файл.пишиБлок(укз,разм*колво_членов);
				break;
			default:
				break;
		}
		return разм*колво_членов;
	}

	
}

unittest{

	void main() {
		try {
			скажифнс("Проверка DinrusCurlX86 версии %s...", stringz.изТкст0(цурл_версия));
			Цурл ц = new Цурл();
			ц.дайФайл("http://google.com", "google.html");
			скажинс("Заголовки:");
			ткст[] заги = ц.дайЗаги();
			foreach (ткст заг; заги) {
				скажифнс("\t%s", заг);
			}
		} catch (Искл e) {
			скажифнс("Впоймано: %s", e.сооб);
		}
		пз;
	}
}