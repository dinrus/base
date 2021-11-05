module text.locale.Win32;

version (Windows)
{

extern (Windows)
private import sys.Common;

цел дайКультуруПользователя() {
  return cast(цел) sys.WinFuncs.ДайДефЛКИДПользователя();
}

проц установиКультуруПользователя(цел лкид) {
  sys.WinFuncs.SetThreadLocale( cast(ЛКИД) лкид);
}

цел сравниСтроку(цел лкид, ткст ткстА, бцел смещениеА, бцел длинаА, ткст ткстБ, бцел смещениеБ, бцел длинаБ, бул игнорироватьРег) {

  шим[] вЮникод(ткст ткст, бцел смещение, бцел длина, out цел транслированное) {
    сим* симвы = ткст.ptr + смещение;
    цел требуется = sys.WinFuncs.MultiByteToWideChar(0, 0, симвы, длина, пусто, 0);
    шим[] результат = new шим[требуется];
    транслированное = sys.WinFuncs.MultiByteToWideChar(0, 0, симвы, длина, результат.ptr, требуется);
    return результат;
  }

  цел sortId = (лкид >> 16) & 0xF;
  sortId = (sortId == 0) ? лкид : (лкид | (sortId << 16));

  цел len1, len2;
  шим[] string1 = вЮникод(ткстА, смещениеА, длинаА, len1);
  шим[] string2 = вЮникод(ткстБ, смещениеБ, длинаБ, len2);

  return sys.WinFuncs.CompareStringW(sortId, игнорироватьРег ? 0x1 : 0x0, string1.ptr, len1, string2.ptr, len2) - 2;
}

}
