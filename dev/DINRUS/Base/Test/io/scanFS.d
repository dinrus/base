        import io.Stdout;
        import io.FileScan;
		import io.FilePath;
		import stdrus: дайтекпап;

        проц main()
        {
		
		
assert (ФПуть("/foo").добавь("bar").вынь == "/foo");
            assert (ФПуть("/foo/").добавь("bar").вынь == "/foo");

            auto fp = new ФПуть(r"C:/home/foo/bar");
            fp ~= "john";
            assert (fp == r"C:/home/foo/bar/john");
            fp.установи (r"C:/");
            fp ~= "john";
            assert (fp == r"C:/john");
            fp.установи("foo.bar");
            fp ~= "john";
            assert (fp == r"foo.bar/john");
            fp.установи("");
            fp ~= "john";
            assert (fp == r"john");

            fp.установи(r"C:/home/foo/bar/john/foo.d");
            assert (fp.вынь == r"C:/home/foo/bar/john");
            assert (fp.вынь == r"C:/home/foo/bar");
            assert (fp.вынь == r"C:/home/foo");
            assert (fp.вынь == r"C:/home");
            assert (fp.вынь == r"C:");
            assert (fp.вынь == r"C:");

            // special case for popping пустой names
            fp.установи (r"C:/home/foo/bar/john/");
            assert (fp.родитель == r"C:/home/foo/bar");

            fp = new ФПуть;
            fp.установи (r"C:/home/foo/bar/john/");
            assert (fp.абс_ли);
            assert (fp.имя == "");
            assert (fp.папка == r"/home/foo/bar/john/");
            assert (fp == r"C:/home/foo/bar/john/");
            assert (fp.путь == r"C:/home/foo/bar/john/");
            assert (fp.файл == r"");
            assert (fp.суффикс == r"");
            assert (fp.корень == r"C:");
            assert (fp.расш == "");
            assert (fp.ветвь_ли);

            fp = new ФПуть(r"C:/home/foo/bar/john");
            assert (fp.абс_ли);
            assert (fp.имя == "john");
            assert (fp.папка == r"/home/foo/bar/");
            assert (fp == r"C:/home/foo/bar/john");
            assert (fp.путь == r"C:/home/foo/bar/");
            assert (fp.файл == r"john");
            assert (fp.суффикс == r"");
            assert (fp.расш == "");
            assert (fp.ветвь_ли);

            fp.вынь;
            assert (fp.абс_ли);
            assert (fp.имя == "bar");
            assert (fp.папка == r"/home/foo/");
            assert (fp == r"C:/home/foo/bar");
            assert (fp.путь == r"C:/home/foo/");
            assert (fp.файл == r"bar");
            assert (fp.суффикс == r"");
            assert (fp.расш == "");
            assert (fp.ветвь_ли);

            fp.вынь;
            assert (fp.абс_ли);
            assert (fp.имя == "foo");
            assert (fp.папка == r"/home/");
            assert (fp == r"C:/home/foo");
            assert (fp.путь == r"C:/home/");
            assert (fp.файл == r"foo");
            assert (fp.суффикс == r"");
            assert (fp.расш == "");
            assert (fp.ветвь_ли);

            fp.вынь;
            assert (fp.абс_ли);
            assert (fp.имя == "home");
            assert (fp.папка == r"/");
            assert (fp == r"C:/home");
            assert (fp.путь == r"C:/");
            assert (fp.файл == r"home");
            assert (fp.суффикс == r"");
            assert (fp.расш == "");
            assert (fp.ветвь_ли);

            fp = new ФПуть(r"foo/bar/john.doe");
            assert (!fp.абс_ли);
            assert (fp.имя == "john");
            assert (fp.папка == r"foo/bar/");
            assert (fp.суффикс == r".doe");
            assert (fp.файл == r"john.doe");
            assert (fp == r"foo/bar/john.doe");
            assert (fp.расш == "doe");
            assert (fp.ветвь_ли);

            fp = new ФПуть(r"c:doe");
            assert (fp.абс_ли);
            assert (fp.суффикс == r"");
            assert (fp == r"c:doe");
            assert (fp.папка == r"");
            assert (fp.имя == "doe");
            assert (fp.файл == r"doe");
            assert (fp.расш == "");
            assert (!fp.ветвь_ли);

            fp = new ФПуть(r"/doe");
            assert (fp.абс_ли);
            assert (fp.суффикс == r"");
            assert (fp == r"/doe");
            assert (fp.имя == "doe");
            assert (fp.папка == r"/");
            assert (fp.файл == r"doe");
            assert (fp.расш == "");
            assert (fp.ветвь_ли);

            fp = new ФПуть(r"john.doe.foo");
            assert (!fp.абс_ли);
            assert (fp.имя == "john.doe");
            assert (fp.папка == r"");
            assert (fp.суффикс == r".foo");
            assert (fp == r"john.doe.foo");
            assert (fp.файл == r"john.doe.foo");
            assert (fp.расш == "foo");
            assert (!fp.ветвь_ли);

            fp = new ФПуть(r".doe");
            assert (!fp.абс_ли);
            assert (fp.суффикс == r"");
            assert (fp == r".doe");
            assert (fp.имя == ".doe");
            assert (fp.папка == r"");
            assert (fp.файл == r".doe");
            assert (fp.расш == "");
            assert (!fp.ветвь_ли);

            fp = new ФПуть(r"doe");
            assert (!fp.абс_ли);
            assert (fp.суффикс == r"");
            assert (fp == r"doe");
            assert (fp.имя == "doe");
            assert (fp.папка == r"");
            assert (fp.файл == r"doe");
            assert (fp.расш == "");
            assert (!fp.ветвь_ли);

            fp = new ФПуть(r".");
            assert (!fp.абс_ли);
            assert (fp.суффикс == r"");
            assert (fp == r".");
            assert (fp.имя == ".");
            assert (fp.папка == r"");
            assert (fp.файл == r".");
            assert (fp.расш == "");
            assert (!fp.ветвь_ли);

            fp = new ФПуть(r"..");
            assert (!fp.абс_ли);
            assert (fp.суффикс == r"");
            assert (fp == r"..");
            assert (fp.имя == "..");
            assert (fp.папка == r"");
            assert (fp.файл == r"..");
            assert (fp.расш == "");
            assert (!fp.ветвь_ли);

            fp = new ФПуть(r"c:/a/b/c/d/e/foo.bar");
            assert (fp.абс_ли);
            fp.папка (r"/a/b/c/");
            assert (fp.суффикс == r".bar");
            assert (fp == r"c:/a/b/c/foo.bar");
            assert (fp.имя == "foo");
            assert (fp.папка == r"/a/b/c/");
            assert (fp.файл == r"foo.bar");
            assert (fp.расш == "bar");
            assert (fp.ветвь_ли);

            fp = new ФПуть(r"c:/a/b/c/d/e/foo.bar");
            assert (fp.абс_ли);
            fp.папка (r"/a/b/c/d/e/f/g/");
            assert (fp.суффикс == r".bar");
            assert (fp == r"c:/a/b/c/d/e/f/g/foo.bar");
            assert (fp.имя == "foo");
            assert (fp.папка == r"/a/b/c/d/e/f/g/");
            assert (fp.файл == r"foo.bar");
            assert (fp.расш == "bar");
            assert (fp.ветвь_ли);

            fp = new ФПуть(r"C:/foo/bar/тест.bar");
            assert (fp.путь == "C:/foo/bar/");
            fp = new ФПуть(r"C:\foo\bar\тест.bar");
            assert (fp.путь == r"C:/foo/bar/");

            fp = new ФПуть("");
            assert (fp.пуст_ли);
            assert (!fp.ветвь_ли);
            assert (!fp.абс_ли);
            assert (fp.суффикс == r"");
            assert (fp == r"");
            assert (fp.имя == "");
            assert (fp.папка == r"");
            assert (fp.файл == r"");
            assert (fp.расш == "");
		
                auto скан = new СканФайл;				

                скан (дайтекпап());
				
				auto флы = скан.файлы;
				auto оши = скан.ошибки;
				auto пап = скан.папки;		
				

                Стдвыв.форматнс ("{} Папки", пап.length);
                foreach (папка; пап)
                         Стдвыв (папка).нс;

                Стдвыв.форматнс ("\n{} Файлы", флы.length);
                foreach (файл; флы)
                         Стдвыв (файл).нс;

                Стдвыв.форматнс ("\n{} Ошибки", оши.length);
                foreach (ошибка; оши)
                         Стдвыв (ошибка).нс;
        }