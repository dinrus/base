﻿module io.device.Array;

private import io.device.Conduit;

class Массив : Провод, БуферВвода, БуферВывода, ИПровод.ИШаг
{
    this (т_мера ёмкость = 0, т_мера нарастает = 0);
    this (проц[] данные);
    this (проц[] данные, т_мера читаемый);
    final override ткст вТкст ();
    final override т_мера читай (проц[] приёмн);
    final override т_мера пиши (проц[] ист);
    final override т_мера размерБуфера ();
    override проц открепи ();
    override дол сместись (дол смещение, Якорь якорь = Якорь.Нач);
    Массив присвой (проц[] данные);
    Массив присвой (проц[] данные, т_мера читаемый);
    final проц[] присвой ();
    final проц[] opSlice (т_мера старт, т_мера конец);
    final проц[] срез ();
    final проц[] срез (т_мера размер, бул съешь = да);
    final Массив добавь (проц[] ист);
    final бул следщ (т_мера delegate (проц[]) скан);
    final т_мера читаемый ();
    final т_мера записываемый ();
    final т_мера предел ();
    final т_мера ёмкость ();
    final т_мера позиция ();
    final Массив очисть ();
    final override Массив слей ();
    final т_мера писатель (т_мера delegate (проц[]) дг);
    final т_мера читатель (т_мера delegate (проц[]) дг);
    private final т_мера расширь (т_мера размер);
    private static T[] преобразуй(T)(проц[] x)
    {
        return (cast(T*) x.ptr) [0 .. (x.length / T.sizeof)];
    }
}