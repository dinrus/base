﻿module io.device.Device;

/*private*/ import  dinrus, sys.common;
public  import  io.device.Conduit;

export class Устройство : Провод, ИВыбираемый
{


                    
        /***********************************************************************

                Выводит ВВИскл, сообщая о последней ошибке.
        
        ***********************************************************************/

        export final проц ошибка ()
        {
                super.ошибка (this.вТкст ~ " :: " ~ СисОш.последнСооб);
        }

        /***********************************************************************

               Возвращает имя этого устройства.

        ***********************************************************************/

        export override ткст вТкст ()
        {
                return "<io.device.Device.Устройство>";
        }

        /***********************************************************************

                Возвращает предпочитаемый размер буфферирующего провода I/O.

        ***********************************************************************/

        export override т_мера размерБуфера ()
        {
                return 1024 * 16;
        }

        /***********************************************************************

                Windows-специфичный код

        ***********************************************************************/

        version (Win32)
        {
                struct ВВ
                {
                        АСИНХРОН      асинх; // должен быть первым атрибутом!!
                        Дескр          указатель;
                        бул            след;
                        ук           задача;
                }

                protected ВВ вв;

                /***************************************************************

                        Разрешить настройку стандартных указателей ВВ.

                ***************************************************************/

                export проц переоткрой (Дескр указатель)
                {
                        вв.указатель = указатель;
                }

                /***************************************************************

                        Вернуть подлежащий указатель ОС на этот Провод.

                ***************************************************************/

                export final Дескр фукз () //fileHandle
                {
                        return вв.указатель;
                }

                /***************************************************************

                ***************************************************************/

                export override проц вымести ()
                {
                        if (вв.указатель != НЕВЕРНХЭНДЛ)
                            if (планировщик)
                                планировщик.закрой (вв.указатель, вТкст);
                        открепи();
                }

                /***************************************************************

                        Освободить подлежащий файл. Заметьте, что при ошибке
                        не выводится исключения, так как это может вызвать
                        беспорядок в обработке ошибок. Вместо этого нужно изменить
                        на возврат булева значения, чтобы caller мог решать
                        с выбором дальнейшего действия.                        

                ***************************************************************/

                export override проц открепи ()
                {
                        if (вв.указатель != НЕВЕРНХЭНДЛ)
                            ЗакройДескр (cast(ук) вв.указатель);

                        вв.указатель = НЕВЕРНХЭНДЛ;
                }

                /***************************************************************

                        Читает чанк байтов из файла, преобразуя в предоставленный
                        Массив. Возвращает число считанных байтов, или Кф, если 
                        дальнейших данных уже не будет.

                        Оперирует асинхронно, когда хостинговая нить (поток)
                        сконфигурирована на такое поведение.

                ***************************************************************/

                export override т_мера читай (проц[] приёмн)
                {

				бцел байты;

				if (вв.указатель == cast(HANDLE) НЕВЕРНХЭНДЛ)	throw new ВВИскл("Указатель неверный");

				auto size = ДайРазмерФайла (вв.указатель, null); 
				if (size == НЕВЕРНРАЗМФАЙЛА) throw new ВВИскл("Размер файла неверен");

				//auto buf = runtime.malloc(size);
				//if (buf) runtime.hasNoPointers(buf.ptr);

				if (!ЧитайФайл  (вв.указатель, приёмн.ptr, cast(бцел) приёмн.length, cast(бцел*) &байты, &вв.асинх))
					 throw new ВВИскл("Неудачное чтение в приёмник");

				if ((байты = жди (планировщик.Тип.Чтение, байты, таймаут)) is Кф)
                                return Кф;

							// синхронно читать ноль означает Кф
				if (байты is 0 && приёмн.length > 0)  return Кф;

							// обновить положение  потока?
				if (вв.след) (*cast(дол*) &вв.асинх.смещение) += байты;
				
				//приёмн = buf;
				return байты;
                }

                /***************************************************************

                        Записать чанк байтов в этот файл из предоставленного
                        Массива. Возвращает число записанных байтов, или Кф, если 
                        этот вывод более недоступен.

                        Оперирует асинхронно, когда хостинговая нить
                        сконфигурирована на такое поведение.

                ***************************************************************/

                export override т_мера пиши (проц[] ист)
                {
                        бцел байты;

                        if (! ПишиФайл (cast(ук) вв.указатель, ист.ptr, ист.length, &байты, &вв.асинх))
                            throw new ВВИскл("Неудачная запись в приёмник");
                        if ((байты = жди (планировщик.Тип.Запись, байты, таймаут)) is Кф)
                             return Кф;

                        // обнови поток location?
                        if (вв.след)
                           (*cast(дол*) &вв.асинх.смещение) += байты;
                        return байты;
                }

                /***************************************************************

                ***************************************************************/

              export final т_мера жди (thread.Фибра.Планировщик.Тип тип, бцел байты, бцел таймаут)
                {
                        while (да)
                              {
                              auto код = ДайПоследнююОшибку;
                              if (код is ПОшибка.ОшибкаУкКонцаФайла ||
                                  код is ПОшибка.РазорванныйПайп)
                                  return Кф;

                              if (планировщик)
                                 {
                                 if (код is ПОшибка.Нет || 
                                     код is ПОшибка.ОжидаетсяВВ || 
                                     код is ПОшибка.НеполныйВВ)
                                    {
                                    if (код is ПОшибка.НеполныйВВ)
                                        super.ошибка ("таймаут"); 

                                    вв.задача = cast(ук) Фибра.дайЭту;
                                    планировщик.ожидай (вв.указатель, тип, таймаут);
                                    if (ДайАсинхронРезультат (вв.указатель,  &вв.асинх, &байты, нет))
                                        return байты;
                                    }
                                 else
                                    ошибка;
                                 }
                              else
                                 if (код is ПОшибка.Нет)
                                     return байты;
                                 else
                                    ошибка;
                              }

                        // should never получи here
                        assert(нет);
                }
        }


        /***********************************************************************

                 Unix-specific код.

        ***********************************************************************/

        version (Posix)
        {
                protected цел указатель = -1;

                /***************************************************************

                        Разрешить adjustment of стандарт ВВ handles

                ***************************************************************/

                protected проц переоткрой (Дескр указатель)
                {
                        this.указатель = указатель;
                }

                /***************************************************************

                        Возвращает underlying OS указатель of this Провод

                ***************************************************************/

                export final Дескр фукз ()
                {
                        return cast(Дескр) указатель;
                }

                /***************************************************************

                        Release the underlying файл

                ***************************************************************/

                export override проц открепи ()
                {
                        if (указатель >= 0)
                           {
                           //if (планировщик)
                               // TODO Not supported on Posix
                               // планировщик.закрой (указатель, вТкст);
                           posix.закрой (указатель);
                           }
                        указатель = -1;
                }

                /***************************************************************

                        Чит a чанк of байты из_ the файл преобр_в the предоставленный
                        Массив. Возвращает the число of байты читай, либо Кф where 
                        there is no further данные.

                ***************************************************************/

                export override т_мера читай (проц[] приёмн)
                {
                        цел читай = posix.читай (указатель, приёмн.ptr, приёмн.length);
                        if (читай is -1)
                            ошибка;
                        else
                           if (читай is 0 && приёмн.length > 0)
                               return Кф;
                        return читай;
                }

                /***************************************************************

                        Зап a чанк of байты в_ the файл из_ the предоставленный
                        Массив. Возвращает the число of байты записано, либо Кф if 
                        the вывод is no longer available.

                ***************************************************************/

                export override т_мера пиши (проц[] ист)
                {
                        цел записано = posix.пиши (указатель, ист.ptr, ист.length);
                        if (записано is -1)
                            ошибка;
                        return записано;
                }
        }
}
