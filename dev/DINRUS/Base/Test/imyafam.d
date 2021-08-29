﻿import dinrus, stringz;

struct ФИО
{
	ткст имя;
	//ткст отчество;
	ткст фамилия;
	цел буквы;	
};

//проц получиИнфо(ФИО *);
//проц обработайИнфо(ФИО *);
//проц покажиИнфо(ФИО *);

цел main ()
{
	ФИО человек;
	получиИнфо(&человек);
	обработайИнфо(&человек);
	покажиИнфо(&человек);
	return 0;
}

проц получиИнфо (ФИО *пст)
{

	скажиф("Пожалуйста, введите имя.\n");
	
	дайт(пст.имя);
	
	скажиф("Пожалуйста, введите вашу фамилию.\n");
	
	дайт(пст.фамилия);	
}

проц обработайИнфо (ФИО *пст)
{

	пст.буквы =	длинтекс (stringz.вТкст0(пст.имя)) +
					длинтекс (stringz.вТкст0(пст.фамилия));
					
}

проц покажиИнфо (ФИО *пст)
{

	скажиф("%s %s, ваше имя содержит %d букв.\n",
			пст.имя, пст.фамилия, пст.буквы);	
}