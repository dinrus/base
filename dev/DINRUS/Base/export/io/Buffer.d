﻿module io.Buffer;

public  import io.model;


extern(D):

 class Буфер : ИБуфер
{
	
    this (ИПровод провод);
    this (ИПотокВвода поток, т_мера ёмкость);
    this (ИПотокВывода поток, т_мера ёмкость);
    this (т_мера ёмкость = 0);
    this (проц[] данные);
    this (проц[] данные, т_мера читаемый);
    static ИБуфер совместно (ИПотокВвода поток, т_мера размер = т_мера.max);
    static ИБуфер совместно (ИПотокВывода поток, т_мера размер = т_мера.max);
    ИБуфер устКонтент (проц[] данные);
    ИБуфер устКонтент (проц[] данные, т_мера читаемый);
    проц[] срез ();
    final проц[] opSlice (т_мера старт, т_мера конец);
    проц[] срез (т_мера размер, бул съешь = да);
    т_мера заполни (проц[] приёмн);
    проц[]  читайРовно (ук приёмн, т_мера байты);
    ИБуфер добавь (проц[] ист);
    ИБуфер добавь (ук ист, т_мера длина);
    ИБуфер добавь (ИБуфер другой);
    проц потреби (проц[] x);
    бул пропусти (цел размер);
    дол сместись (дол смещение, Якорь старт = Якорь.Нач);
    бул следщ (т_мера delegate (проц[]) скан);
    final бул сожми (бул да);
    т_мера читаемый ();
    т_мера записываемый ();
    final т_мера резервируй (т_мера пространство);
    т_мера писатель (т_мера delegate (проц[]) дг);
    т_мера читатель (т_мера delegate (проц[]) дг);
    ИБуфер сожми ();
    т_мера заполни (ИПотокВвода ист);
    final т_мера дренируй (ИПотокВывода приёмн);
    бул упрости (т_мера length);
    т_мера предел ();
    т_мера ёмкость ();
    т_мера позиция ();
    ИБуфер устПровод (ИПровод провод);
    final ИБуфер вывод (ИПотокВывода бвывод);
    final ИБуфер ввод (ИПотокВвода бввод);
    protected проц[] дайКонтент();
    protected проц копируй (проц *ист, т_мера размер);
    protected т_мера расширь (т_мера размер);

    static T[] преобразуй(T)(проц[] x)
    {
        return (cast(T*) x.ptr) [0 .. (x.length / T.sizeof)];
    }


    ИБуфер буфер ();
    БуферВвода бвхо ();
    БуферВывода бвых ();
    override ткст вТкст ();
    final проц ошибка (ткст сооб);
    override ИПотокВывода слей ();
    override ИПотокВвода очисть ();
    override ИПотокВывода копируй (ИПотокВвода ист, т_мера max=-1);
    проц[] загрузи (т_мера max=-1);
    override т_мера пиши (проц[] ист);
    final override ИПровод провод ();
    final override т_мера размерБуфера ();
    final override бул жив_ли ();
    final ИПотокВывода вывод ();
    final ИПотокВвода ввод ();
    final override проц открепи ();
    override проц закрой ();
}


Буфер объБуфер (ИПровод провод);
Буфер объБуфер (ИПотокВвода поток, т_мера ёмкость);
Буфер объБуфер(ИПотокВывода поток, т_мера ёмкость);
Буфер объБуфер(т_мера ёмкость = 0);
Буфер объБуфер (проц[] данные);
Буфер объБуфер (проц[] данные, т_мера читаемый);

class БуферРоста : Буфер
{
    alias Буфер.срез  срез;
    alias Буфер.добавь добавь;

    this (т_мера размер = 1024, т_мера инкремент = 1024);
    this (ИПровод провод, т_мера размер = 1024);
    override проц[] срез (т_мера размер, бул съешь = да);
    override ИБуфер добавь (проц *ист, т_мера length);
    override т_мера заполни (ИПотокВвода ист);
    т_мера заполни (т_мера размер = т_мера.max);
    override т_мера расширь (т_мера размер);
}

БуферРоста объБуферРоста (т_мера размер = 1024, т_мера инкремент = 1024);
БуферРоста объБуферРоста (ИПровод провод, т_мера размер = 1024);


debug (Buffer)
{
    unittest
    {
        auto б = new Буфер(6);
        б.добавь ("что-то");
        б.резервируй (1);
        б.срез (5);
        б.резервируй (4);
    }
}
