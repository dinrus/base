 module endian;
	   import io.device.Array, io.protocol.EndianProtocol;

        проц main()
        {
                проц[] размести (ПротоколЭндиан.Читатель читатель, бцел байты, ПротоколЭндиан.Тип тип)
                {
                        return читатель ((new проц[байты]).ptr, байты, тип);
                }
        
                ткст mule;
                ткст тест = "testing testing 123";
                
                auto протокол = new ПротоколЭндиан (new io.device.Array.Массив(32));
                протокол.пишиМассив (тест.ptr, тест.length, протокол.Тип.Утф8);
                
                mule = cast(ткст) протокол.читайМассив (mule.ptr, mule.length, протокол.Тип.Утф8, &размести);
                assert (mule == тест);
				скажинс (mule);
				скажинс("Пройден тест io.protocol.EndianProtocol");

        }