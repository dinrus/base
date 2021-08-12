﻿/**
 * Copyright: Copyright (C) Thomas Dixon 2009. все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Thomas Dixon
 */

module util.cipher.Salsa20;

private import util.cipher.Cipher;

/** Implementation of Salsa20 designed by Daniel J. Bernstein. */
class Salsa20 : ШифрПоток
{
    protected
    {
        // Constants
        static ббайт[] сигма = cast(ббайт[])"расширь 32-байт k",
                       tau = cast(ббайт[])"расширь 16-байт k";
        
        // Counter indexes (добавьed for ChaCha)            
        бцел i0, i1;
                      
        // Internal состояние              
        бцел[] состояние;
        
        // KeyПоток и индекс marker
        ббайт[] keyПоток;
        бцел индекс;
        
        // Internal copies of the ключ и IV for resetting the cipher
        ббайт[] workingKey,
                workingIV;
    }
    
    this()
    {
        состояние = new бцел[16];
        
        // Состояние expanded преобр_в байты
        keyПоток = new ббайт[64];
        
        i0 = 8;
        i1 = 9;
    }
    
    проц init(бул зашифруй, Параметры парамы)
    {
        ParametersWithIV ivParams = cast(ParametersWithIV)парамы;
        
        if (!ivParams)
            не_годится(имя()~": init параметры must include an IV. (use ParametersWithIV)");
                    
        СимметричныйКлюч keyParams = cast(СимметричныйКлюч)ivParams.параметры;
                    
        ббайт[] iv = ivParams.iv,
                ключ = keyParams.ключ;
            
        if (ключ)
        {
            if (ключ.length != 16 && ключ.length != 32)
                не_годится(имя()~": Неверный ключ length. (требует 16 or 32 байты)");
            
            workingKey = ключ;
            keySetup();
            
            индекс = 0;
        }
        
        if (!workingKey)
            не_годится(имя()~": Key not установи.");
            
        if (!iv || iv.length != 8)
            не_годится(имя()~": 8 байт IV требуется.");
            
        workingIV = iv;
        ivSetup();
        
        _encrypt = _initialized = да;
    }
    
    ткст имя()
    {
        return "Salsa20";
    }
    
    ббайт returnByte(ббайт ввод)
    {
        if (!_initialized)
            не_годится (имя()~": Шифр not инициализован");
            
        if (индекс == 0) {
            salsa20WordToByte(состояние, keyПоток);
            состояние[i0]++;
            if (!состояние[i0])
                состояние[i1]++;
            // As in djb's, changing the IV after 2^70 байты is the пользователь's responsibility
            // lol glwt
        }
        
        ббайт результат = (keyПоток[индекс]^ввод);
        индекс = (индекс + 1) & 0x3f;
        
        return результат;
    }
    
    бцел обнови(проц[] input_, проц[] output_)
    {
        if (!_initialized)
            не_годится(имя()~": Шифр not инициализован");
            
        ббайт[] ввод = cast(ббайт[]) input_,
                вывод = cast(ббайт[]) output_;
            
        if (ввод.length > вывод.length)
            не_годится(имя()~": Вывод буфер too крат");
            
        for (цел i = 0; i < ввод.length; i++)
        {
            if (индекс == 0)
            {
                salsa20WordToByte(состояние, keyПоток);
                состояние[i0]++;
                if (!состояние[i0])
                    состояние[i1]++;
                // As in djb's, changing the IV after 2^70 байты is the пользователь's responsibility
                // lol glwt
            }
            вывод[i] = (keyПоток[индекс]^ввод[i]);
            индекс = (индекс + 1) & 0x3f; 
        }
        
        return ввод.length;
    }
    
    проц сбрось()
    {
        keySetup();
        ivSetup();
        индекс = 0;
    }
    
    protected проц keySetup()
    {
        бцел смещение;
        ббайт[] constants;
        
        состояние[1] = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(workingKey[0..4]);
        состояние[2] = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(workingKey[4..8]);
        состояние[3] = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(workingKey[8..12]);
        состояние[4] = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(workingKey[12..16]);
        
        if (workingKey.length == 32)
        {
            constants = сигма;
            смещение = 16;
        } else
            constants = tau;
            
        состояние[11] = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(workingKey[смещение..смещение+4]);
        состояние[12] = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(workingKey[смещение+4..смещение+8]);
        состояние[13] = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(workingKey[смещение+8..смещение+12]);
        состояние[14] = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(workingKey[смещение+12..смещение+16]);
        состояние[ 0] = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(constants[0..4]);
        состояние[ 5] = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(constants[4..8]);
        состояние[10] = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(constants[8..12]);
        состояние[15] = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(constants[12..16]);
    }
    
    protected проц ivSetup()
    {
        состояние[6] = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(workingIV[0..4]);
        состояние[7] = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(workingIV[4..8]);
        состояние[8] = состояние[9] = 0;
    }
    
    protected проц salsa20WordToByte(бцел[] ввод, ref ббайт[] вывод)
    {
        бцел[] x = new бцел[16];
        x[] = ввод;
        
        цел i;
        for (i = 0; i < 10; i++)
        {
            x[ 4] ^= Побитно.вращайВлево(x[ 0]+x[12],  7u);
            x[ 8] ^= Побитно.вращайВлево(x[ 4]+x[ 0],  9u);
            x[12] ^= Побитно.вращайВлево(x[ 8]+x[ 4], 13u);
            x[ 0] ^= Побитно.вращайВлево(x[12]+x[ 8], 18u);
            x[ 9] ^= Побитно.вращайВлево(x[ 5]+x[ 1],  7u);
            x[13] ^= Побитно.вращайВлево(x[ 9]+x[ 5],  9u);
            x[ 1] ^= Побитно.вращайВлево(x[13]+x[ 9], 13u);
            x[ 5] ^= Побитно.вращайВлево(x[ 1]+x[13], 18u);
            x[14] ^= Побитно.вращайВлево(x[10]+x[ 6],  7u);
            x[ 2] ^= Побитно.вращайВлево(x[14]+x[10],  9u);
            x[ 6] ^= Побитно.вращайВлево(x[ 2]+x[14], 13u);
            x[10] ^= Побитно.вращайВлево(x[ 6]+x[ 2], 18u);
            x[ 3] ^= Побитно.вращайВлево(x[15]+x[11],  7u);
            x[ 7] ^= Побитно.вращайВлево(x[ 3]+x[15],  9u);
            x[11] ^= Побитно.вращайВлево(x[ 7]+x[ 3], 13u);
            x[15] ^= Побитно.вращайВлево(x[11]+x[ 7], 18u);
            x[ 1] ^= Побитно.вращайВлево(x[ 0]+x[ 3],  7u);
            x[ 2] ^= Побитно.вращайВлево(x[ 1]+x[ 0],  9u);
            x[ 3] ^= Побитно.вращайВлево(x[ 2]+x[ 1], 13u);
            x[ 0] ^= Побитно.вращайВлево(x[ 3]+x[ 2], 18u);
            x[ 6] ^= Побитно.вращайВлево(x[ 5]+x[ 4],  7u);
            x[ 7] ^= Побитно.вращайВлево(x[ 6]+x[ 5],  9u);
            x[ 4] ^= Побитно.вращайВлево(x[ 7]+x[ 6], 13u);
            x[ 5] ^= Побитно.вращайВлево(x[ 4]+x[ 7], 18u);
            x[11] ^= Побитно.вращайВлево(x[10]+x[ 9],  7u);
            x[ 8] ^= Побитно.вращайВлево(x[11]+x[10],  9u);
            x[ 9] ^= Побитно.вращайВлево(x[ 8]+x[11], 13u);
            x[10] ^= Побитно.вращайВлево(x[ 9]+x[ 8], 18u);
            x[12] ^= Побитно.вращайВлево(x[15]+x[14],  7u);
            x[13] ^= Побитно.вращайВлево(x[12]+x[15],  9u);
            x[14] ^= Побитно.вращайВлево(x[13]+x[12], 13u);
            x[15] ^= Побитно.вращайВлево(x[14]+x[13], 18u);
        }
        
        for (i = 0; i < 16; i++)
            x[i] += ввод[i];
            
        цел j;    
        for (i = j = 0; i < x.length; i++,j+=цел.sizeof)
            вывод[j..j+цел.sizeof] = БайтКонвертер.ЛитлЭндиан.из_!(бцел)(x[i]);
    }
    
    /** Salsa20 тест vectors */
    debug (UnitTest)
    {
        unittest
        {
            static ткст[] test_keys = [
                "80000000000000000000000000000000", 
                "0053a6f94c9ff24598eb3e91e4378добавь",
                "00002000000000000000000000000000"~
                "00000000000000000000000000000000",
                "0f62b5085bae0154a7fa4da0f34699ec"~
                "3f92e5388bde3184d72a7dd02376c91c"
                
            ];
            
            static ткст[] test_ivs = [
                "0000000000000000",            
                "0d74db42a91077de",
                "0000000000000000",
                "288ff65dc42b92f9"
            ];
                 
            static ткст[] test_plaintexts = [
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000",
                
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000",
                
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000",
                
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"
                
                
            ];
                 
            static ткст[] test_ciphertexts = [
                "4dfa5e481da23ea09a31022050859936"~ // Expected вывод
                "da52fcee218005164f267cb65f5cfd7f"~
                "2b4f97e0ff16924a52df269515110a07"~
                "f9e460bc65ef95da58f740b7d1dbb0aa",
                         
                "05e1e7beb697d999656bf37c1b978806"~
                "735d0b903a6007bd329927efbe1b0e2a"~
                "8137c1ae291493aa83a821755bee0b06"~
                "cd14855a67e46703ebf8f3114b584cba",
                 
                "c29ba0da9ebebfacdebbdd1d16e5f598"~
                "7e1cb12e9083d437eaaaa4ba0cdc909e"~
                "53d052ac387d86acda8d956ba9e6f654"~
                "3065f6912a7df710b4b57f27809bafe3",
                
                "5e5e71f90199340304abb22a37b6625b"~
                "f883fb89ce3b21f54a10b81066ef87da"~
                "30b77699aa7379da595c77dd59542da2"~
                "08e5954f89e40eb7aa80a84a6176663f"
            ];

            Salsa20 s20 = new Salsa20();
            ббайт[] буфер = new ббайт[64];
            ткст результат;
            for (цел i = 0; i < test_keys.length; i++)
            {
                СимметричныйКлюч ключ = new СимметричныйКлюч(БайтКонвертер.hexDecode(test_keys[i]));
                ParametersWithIV парамы = new ParametersWithIV(ключ, БайтКонвертер.hexDecode(test_ivs[i]));
                
                // Encryption
                s20.init(да, парамы);
                s20.обнови(БайтКонвертер.hexDecode(test_plaintexts[i]), буфер);
                результат = БайтКонвертер.hexEncode(буфер);
                assert(результат == test_ciphertexts[i],
                        s20.имя()~": ("~результат~") != ("~test_ciphertexts[i]~")");           
                
                // Decryption
                s20.init(нет, парамы);
                s20.обнови(БайтКонвертер.hexDecode(test_ciphertexts[i]), буфер);
                результат = БайтКонвертер.hexEncode(буфер);
                assert(результат == test_plaintexts[i],
                        s20.имя()~": ("~результат~") != ("~test_plaintexts[i]~")");
            }   
        }
    }
}
