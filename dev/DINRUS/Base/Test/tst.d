﻿import thread, io.device.ThreadPipe;
import stdrus:пауза;

	void tst()
	{
        бцел[] исток = бцелмас(1000);
        foreach(i, ref x; исток)
            x = i;
        ПайпНить пн = new ПайпНить(16);
		
        проц нитьА()
        {
		    проц[] исхБуф = исток;
            while(исхБуф.length > 0)
            {
                исхБуф = исхБуф[пн.пиши(исхБуф)..$];
            }
            пн.стоп();
        }
		
        Нить a = new Нить(&нитьА);
        a.старт();
		скажинс("НитьА пущена");
        цел значчтен;
        цел последн = -1;
        т_мера члочтен;
        while((члочтен = пн.читай((&значчтен)[0..1])) == значчтен.sizeof)
        {
            assert(значчтен == последн + 1);
            последн = значчтен;
        }
        assert(члочтен == пн.Кф);
        a.присоедини();

    }
	
	    void main()
    {
		скажинс("Тест ПайпНити");
		try{
		tst();
		}
		catch(Object o){o.выведи;}
		скажинс("Тест ПайпНити окей");
		_пауза;

	}