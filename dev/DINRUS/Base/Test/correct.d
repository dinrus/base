﻿import stdrus;
//Тест создан для того, чтобы получить правильные данные
//из консольного ввода, что долгое время не удаётся
цел main()
{
Начало:
скажи("ВВЕДИТЕ ТЕКСТ:");
ткст ответ = читайстр();
скажифнс("ВЫ ВВЕЛИ:%s", ответ);
скажи("Программу повторить ДА(да, y) или НЕТ(нет, n)?");
ответ = читайстр();
switch(ответ)
	{
case "нет\n":
  case "n\n":
	return 0;
	break;

case "да\n":
  case "y\n":
	goto Начало;
	break;

default:
	скажинс("Ответ неясен.");
	goto Начало;
	}
return 0;
}