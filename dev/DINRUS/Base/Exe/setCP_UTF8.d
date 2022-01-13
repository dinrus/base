module setCP_UTF8;
import dinrus;

проц установиКС65001()
{
сис("REG query \"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont\"");
сис(" REG ADD \"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont\" /v 000 /t REG_SZ /d \"Courier New\"");
 сис(" REG ADD HKCU\Console /v CodePage /t REG_DWORD /d 65001 /f");
 сис(" REG ADD HKCU\Console /v FaceName /t REG_SZ /d \"Courier New\" /f");
 сис(" REG ADD HKCU\Console /v FontSize /t REG_DWORD /d 20 /f");
  
сис("  REG ADD HKCU\Console /v QuickEdit /t REG_DWORD /d 1 /f");
  }
  /*
Создайте запись REG_SZ(String), используя regedit at, HKEY_LOCAL_MACHINE\Software\Microsoft\Command Processor и назовите ее AutoRun. Измените значение этого на chcp 65001. Если вы не хотите видеть выходное сообщение из команды, используйте @chcp 65001>nul вместо этого.
*/
проц main()
{
установиКС65001();
}