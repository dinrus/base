﻿module stdout;
import io.Stdout;
import io.Console;
import text.convert.Layout, text.convert.Format;
alias Стдвыв выдай;
alias Формат фм;

проц ошибнс(ткст ткт){Стдош(ткт).нс;}
проц скажи(ткст ткт){выдай(ткт);}
проц скажи(цел ч){выдай.форматируй("{}", ч);}
проц скажинс(ткст ткт){выдай(ткт).нс;}
проц нс(){выдай("").нс;}
проц таб(){выдай("\t");}

import stdrus: пз;

проц main()
        {     
			Квывод ("Квывод: hello world").нс;
			Стдвыв("Стдвыв: Отлично").нс;
			Кош("Стдош: Отлично").нс;
			ткст ткт = "Мой текст: ";
			Квывод(ткт).нс;
		   
			Квывод(ткт).нс;
			скажинс("Скажу!");
			скажи(1999999);
			нс;
			таб(); скажи("С новой строчкой!");нс();
			ошибнс("Плёхо!!");
			ткт = Кввод.копируйнс();
			скажинс(ткт);
			пз;
        }