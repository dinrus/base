import io.Stdout;
    import io.device.Array;

    проц main()
    {
        auto b = new Массив(6, 10);
        b.сместись (0);
        b.пиши ("fubar");

        Стдвыв.форматнс ("протяженность {}, поз {}, считано {}, размер буфера {}",
                                       b.предел, b.позиция, cast(ткст) b.срез, b.размерБуфера);


        b.пиши ("fubar");
        b.сместись (7);
        Стдвыв.форматнс ("протяженность {}, поз {}, считано {}, размер буфера {}",
                                       b.предел, b.позиция, cast(ткст) b.срез, b.размерБуфера);
    }