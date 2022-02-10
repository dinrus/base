 module native;
        import io.Buffer;
        import io.protocol.Writer;
        import io.protocol.Reader;
        import io.protocol.NativeProtocol;
        
        проц main()
        {
                auto протокол = new ПротоколНатив (new Буфер(32));
                auto читатель  = new Читатель (протокол);
                auto писатель = new Писатель (протокол);

                ткст foo = "testing testing 123"c;
                писатель (foo);
                читатель (foo);
                assert (foo == "testing testing 123");
			    скажинс(foo);
        }

        