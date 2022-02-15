﻿module geom.MathDefs;

import stdrus;

/** Операторы сравнения с выбранным пользователем контролем точности
*/
бул ноль_ли(T, Реал)(T _a, Реал _эпс)
{ return фабс(_a) < _эпс; }

бул равн_ли(T1, T2, Реал)(T1 a, T2 b, Реал _эпс)
{ return ноль_ли(a-b, _эпс); }

бул больш_ли(T1, T2, Реал)(T1 a, T2 b, Реал _эпс)
{ return (a > b) && !равн_ли(a,b,_эпс); }

бул большравн_ли(T1, T2, Реал)(T1 a, T2 b, Реал _эпс)
{ return (a > b) || равн_ли(a,b,_эпс); }

бул меньш_ли(T1, T2, Реал)(T1 a, T2 b, Реал _эпс)
{ return (a < b) && !равн_ли(a,b,_эпс); }

бул меньшравн_ли(T1, T2, Реал)(T1 a, T2 b, Реал _эпс)
{ return (a < b) || равн_ли(a,b,_эпс); }

//плав плав_эпс__ = 10*плав.epsilon;
//дво дво_эпс__ = 10*дво.epsilon;
плав плав_эпс__ = 1e-05f;
дво дво_эпс__ = 1e-09;

плав эпс__(плав) 
{ return плав_эпс__; }

дво эпс__(дво)
{ return дво_эпс__; }

бул ноль_ли(T)(T a)
{ return ноль_ли(a, эпс__(a)); }

бул равн_ли(T1, T2)(T1 a, T2 b)
{ return ноль_ли(a-b); }

бул больш_ли(T1, T2)(T1 a, T2 b)
{ return (a > b) && !равн_ли(a,b); }

бул большравн_ли(T1, T2)(T1 a, T2 b)
{ return (a > b) || равн_ли(a,b); }

бул меньш_ли(T1, T2)(T1 a, T2 b)
{ return (a < b) && !равн_ли(a,b); }

бул меньшравн_ли(T1, T2)(T1 a, T2 b)
{ return (a < b) || равн_ли(a,b); }

/// Тригонометрия/углы - относительно

T рабоч_уарг(T)(T _уарг)
{
  if (_уарг < -1)
  {
    _уарг = -1;
  }
  else if (_уарг >  1)
  {
    _уарг = 1;
  }
  return _уарг;
}

/** Возвращает угол, определённые по его _кос, и знак его _син
    результат положителен, если угол входит в [0:пи]
    и отрицательный, если угол находится в [пи:2pi]
*/
T угол(T)(T _кос_угла, T _син_угла)
{//sanity checks - otherwise acos will return нч
  _кос_угла = рабоч_уарг(_кос_угла);
  return cast(T) _син_угла >= 0 ? _акос(_кос_угла) : -_акос(_кос_угла);
}

T положительн_угол(T)(T _угол)
{ return _угол < 0 ? (2*ПИ + _угол) : _угол; }

T положительн_угол(T)(T _кос_угла, T _син_угла)
{ return положительн_угол(угол(_кос_угла, _син_угла)); }

T град_в_рад(T)(T _угол)
{ return ПИ*(_угол/180); }

T рад_в_град(T)(T _угол)
{ return 180*(_угол/ПИ); }

unittest {
    
    ноль_ли(2.0, 1e-3);
    равн_ли(1.,2.,1e-3);
    больш_ли(1.,2.,1e-3);
    большравн_ли(1.,2.,1e-3);
    меньш_ли(1.,2,1e-3);
    меньшравн_ли(1.,2.,1e-3);

    эпс__(32.0f) ;
    эпс__(32.0);

    ноль_ли(1.2);
    равн_ли(1.,2.);
    больш_ли(1.,2.);
    большравн_ли(1.,2.);
    меньш_ли(1.,2.);
    меньшравн_ли(1.,2.);

    рабоч_уарг(3.2);
    угол(_кос(1.0), _син(1.0));

    положительн_угол(-1.2);

    положительн_угол(_кос(1.0),_син(1.0));

    град_в_рад(1.0);
    рад_в_град(1.0);

}


