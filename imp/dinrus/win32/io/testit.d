import stdrus;
import std.intrinsic;
import win32.io.fs;

void main(){
uint v;
     int x;

     v = 0x21;
     x = bsf(v);
     скажифнс("bsf(x%x) = %d", v, x);
     x = bsr(v);
     скажифнс("bsr(x%x) = %d", v, x);
     
//скажифнс("Папка <d:\\dinrus> существует: %s", естьПапка("D:\\dinrus"));
скажифнс("Общее свободное пространство на диске C: равно %s", дайОбщСвобПрострво("C:"));
//скажифнс("Attributes of file <c:\\dm\\dmd.txt> are following: %s", getFileAttributes("c:\\dm\\dmd.txt"));
}