﻿module global;
private import sys.WinStructs, runtime, gc, cidrus, sys.Common;
private import cidrus;

static Рантайм _рт; //Главный рантайм
static т_см _см; //Главный СборщикМусора

const ук _буфЭкрана; //Буфер экрана консоли
const ук КОНСВВОД;//Ввод из консоли
const ук КОНСВЫВОД;//Вывод в консоль
const ук КОНСОШ; //Вывод на консольный канал ошибок

static ИнфОМодуле[] _конструкторы;//Массив конструкторов модулей
static ИнфОМодуле[] _деструкторы;//Массив деструкторов модулей

const фук СТДВВОД; //Стандартный ввод
const фук СТДВЫВОД; //Стандартный вывод
const фук СТДОШ; //Стандартный канал ошибок
const фук СТДДОП;
const фук СТДПРИНТ;

//const бцел _идПроцесса;
//ИНФОСТАРТА _стартИнфо;

static this()
{
//_стартИнфо = дайСтартИнфо();
//_идПроцесса = идПроцесса();
СТДВВОД = дайСтдвхо();
СТДВЫВОД = дайСтдвых();
СТДОШ = дайСтдош();
СТДДОП = дайСтддоп();
СТДПРИНТ = дайСтдпрн();
_буфЭкрана = консБуфЭкрана();
КОНСВВОД = консВход();
КОНСВЫВОД = консВыход();
КОНСОШ = консОш();
_рт = рантайм();
_см = _рт.дайСборщикМусора();
_конструкторы = _рт.дайКонструкторы();
_деструкторы = _рт.дайДеструкторы();
}
