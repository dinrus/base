﻿module net.SocketListener;

private import io.model;

class СокетСлушатель
{
        this (ИБуфер буфер);
        this (ИПотокВвода поток, ИБуфер буфер);
        abstract проц сообщи (ИБуфер буфер);
        abstract проц исключение (ткст сооб);
        проц выполни ();
         проц отмена ();
        проц устЛимитОшибок (бкрат предел)
        private проц пуск ();
}


