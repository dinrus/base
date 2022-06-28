module pickle;

    import io.device.Array, io.protocol.PickleProtocol;

    проц main()
    {
        цел тест = 0xcc55ff00;

        auto протокол = new ПротоколПикл (new io.device.Array.Массив(32));
        протокол.пиши (&тест, тест.sizeof, протокол.Тип.Цел);

        auto укз = протокол.буфер.срез (тест.sizeof, нет).ptr;
        протокол.читай  (&тест, тест.sizeof, протокол.Тип.Цел);

        assert (тест == 0xcc55ff00);

        version (ЛитлЭндиан)
        assert (*cast(цел*) укз == 0x00ff55cc);
		скажинс("Пройден тест io.protocol.PickleProtocol");
    }