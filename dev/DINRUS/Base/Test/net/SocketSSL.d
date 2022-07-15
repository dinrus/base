version(Test)
{
    import tetra.util.Test; 
    import io.Stdout;
    import io.device.File;
    import io.FilePath;
    import thread;
    import stringz;

    extern (C)
    {
        цел blah(цел booger, проц *x)
        {
            return 1;
        }
    }


    unittest
    {
        auto t2 = 1.0;
        loadOpenSSL();
        Test.Status sslCTXTest(ref ткст[] messages)
        {
            auto s1 = new СокетССЛ();
            if (s1)
            {
                бул good = нет;
                try
                    auto s2 = new СокетССЛ(ПТипСок.Поток,  ППротокол.ППД);
                catch (Исключение e)
                    good = да;

                if (good)
                {
                    Сокет mySock = new Сокет(ПСемействоАдресов.ИНЕТ, ПТипСок.Поток, ППротокол.ПУТ);
                    if (mySock)
                    {
                        Сертификат publicCertificate;
                        ЧастныйКлюч частныйКлюч;
                        try
                        {
                            publicCertificate = new Сертификат(cast(ткст)Файл.получи ("public.pem")); 
                            частныйКлюч = new ЧастныйКлюч(cast(ткст)Файл.получи ("private.pem"));
                        }                        
                        catch (Исключение ex)
                        {
                            частныйКлюч = new ЧастныйКлюч(2048);
                            publicCertificate = new Сертификат();
                            publicCertificate.частныйКлюч(частныйКлюч).серийныйНомер(123).смещениеКДатеДо(t1).смещениеКДатеПосле(t2);
                            publicCertificate.установиСубъект("CA", "Alberta", "Place", "No", "First Last", "no unit", "email@example.com").знак(publicCertificate, частныйКлюч);
                        }                        
                        auto кнткстССЛ = new КонтекстССЛ();
                        кнткстССЛ.сертификат(publicCertificate).частныйКлюч(частныйКлюч).проверьКлюч();
                        auto s3 = new СокетССЛ(mySock, кнткстССЛ);
                        if (s3)
                            return Test.Status.Success;
                    }
                }
            }
            return Test.Status.Failure;
        }

        Test.Status sslReadWriteTest(ref ткст[] messages)
        {
            auto s1 = new СокетССЛ();
            auto адрес = new АдресИПв4("209.20.65.224", 443);
            if (s1.подключись(адрес))
            {
                ткст команда = "GET /результат.txt\r\n";
                s1.пиши(команда);
                сим[1024] результат;
                бцел bytesRead = s1.читай(результат);
                if (bytesRead > 0 && bytesRead != Кф && (результат[0 .. bytesRead] == "I got results!\n"))
                    return Test.Status.Success;
                else
                    messages ~= Стдвыв.выкладка()("Приёмd wrong results: (bytesRead: {}), (результат: {})", bytesRead, результат[0..bytesRead]);
            }
            return Test.Status.Failure;
        }

        Test.Status sslReadWriteTestWithTimeout(ref ткст[] messages)
        {
            auto s1 = new СокетССЛ();
            auto адрес = new АдресИПв4("209.20.65.224", 443);
            if (s1.подключись(адрес))
            {
                ткст команда = "GET /результат.txt HTTP/1.1\r\nHost: submersion.com\r\n\r\n";
                s1.пиши(команда);
                сим[1024] результат;
                бцел bytesRead = s1.читай(результат);
                ткст expectedResult = "HTTP/1.1 200 ОК";
                if (bytesRead > 0 && bytesRead != Кф && (результат[0 .. expectedResult.length] == expectedResult))
                {
                    s1.установиТаймаут(t2);
                    while (bytesRead != s1.Кф)
                        bytesRead = s1.читай(результат);                
                    if (s1.былТаймаут)
                        return Test.Status.Success;
                    else
                        messages ~= Стдвыв.выкладка()("Dопр not получи таймаут on читай: {}", bytesRead);
                }
                else
                    messages ~= Стдвыв.выкладка()("Приёмd wrong results: (bytesRead: {}), (результат: {})", bytesRead, результат[0..bytesRead]);
            }
            return Test.Status.Failure;    
        }

        auto t = new Test("tetra.net.СокетССЛ");
        t["SSL_CTX"] = &sslCTXTest;
        t["Чит/Зап"] = &sslReadWriteTest;
        t["Чит/Зап Timeout"] = &sslReadWriteTestWithTimeout; 
        t.run();
    }
}
