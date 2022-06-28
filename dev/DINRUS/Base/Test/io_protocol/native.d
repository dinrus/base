 module native;
        import io.Buffer;
        import io.protocol.Writer;
        import io.protocol.Reader;
        import io.protocol.NativeProtocol;
		//import io.Stdout;
        
        проц main()
        {
		        auto буф = new Буфер(32);
                auto протокол = new ПротоколНатив (буф);
                auto читатель  = new Читатель (протокол);
                auto писатель = new Писатель (протокол);

                ткст foo = "testing testing 123"c;
                писатель (foo);
                читатель (foo);
                assert (foo == "testing testing 123");
			   //  Стдвыв(foo).нс;
			    скажинс(foo);
				скажинс("Пройден тест io.protocol.NativeProtocol");
        }

        