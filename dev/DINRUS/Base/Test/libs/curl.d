import lib.curl;
import dinrus, stringz;

		void main() {
		try {
		    auto версия = цурл_версия();
			скажифнс("Проверка DinrusCurlX86.dll...");
			скажифнс("Curl версии -> %s", stringz.изТкст0(версия));
			Цурл ц = new Цурл();
			ц.дайФайл("http://google.com", "google.html");
			скажинс("Заголовки:");
			ткст[] заги = ц.дайЗаги();
			foreach (ткст заг; заги) {
				скажифнс("\t%s", заг);
			}
		} catch (Искл e) {
			скажифнс("Впоймано: %s", e.сооб);
		}
		пз;
	}

