﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Oct 2004: Initial release      
                        Dec 2006: Outback release
        
        author:         Kris

*******************************************************************************/

module io.protocol.Reader;

private import  io.Buffer;

public  import             io.model;

public  import  io.protocol.model;


/*******************************************************************************

        Читатель основа-class. Each читатель operates upon an ИБуфер, which is
        предоставленный at construction время. Читательs are simple converters of данные,
        и have reasonably rigопр rules regarding данные форматируй. Например,
        each request for данные expects the контент в_ be available; an исключение
        is thrown where this is not the case. If the данные is arranged in a ещё
        relaxed fashion, consider using ИБуфер directly instead.

        все readers support the full установи of исконный данные типы, plus a full
        выделение of Массив типы. The latter can be configured в_ произведи
        either a копируй (.dup) of the буфер контент, либо a срез. See classes
        КопияКучи, СрезБуфера и СрезКучи for ещё on this topic. Applications
        can disable память management by configuring a Читатель with one of the
        binary oriented protocols, и ensuring the optional протокол 'префикс'
        is disabled.

        Читательs support Java-esque получи() notation. However, the Dinrus
        стиль is в_ place IO элементы внутри their own parenthesis, like
        so:
        
        ---
        цел счёт;
        ткст verse;
        
        читай (verse) (счёт);
        ---

        Note that each элемент читай is distict; this стиль is affectionately
        known as "whisper". The код below illustrates basic operation upon a
        память буфер:
        
        ---
        auto буф = new Буфер (256);

        // карта same буфер преобр_в Всё читатель и писатель
        auto читай = new Читатель (буф);
        auto пиши = new Писатель (буф);

        цел i = 10;
        дол j = 20;
        дво d = 3.14159;
        ткст c = "fred";

        // пиши данные using whisper syntax
        пиши (c) (i) (j) (d);

        // читай them задний again
        читай (c) (i) (j) (d);


        // same thing again, but using помести() syntax instead
        пиши.помести(c).помести(i).помести(j).помести(d);
        читай.получи(c).получи(i).получи(j).получи(d);
        ---

        Note that certain protocols, such as the basic binary implementation, 
        expect в_ retrieve the число of Массив элементы из_ the исток. For
        example: when reading an Массив из_ a файл, the число of элементы 
        is читай из_ the файл also, и the configurable память-manager is
        invoked в_ предоставляет the Массив пространство. If контент is not arranged in
        such a manner you may читай Массив контент directly either by creating
        a Читатель with a протокол configured в_ sопрestep Массив-prefixing, or
        by accessing буфер контент directly (via the methods exposed there)
        e.g.

        ---
        проц[10] данные;
                
        читатель.буфер.заполни (данные);
        ---

        Читательs may also be использован with any class implementing the ИЧитаемое
        interface, along with any struct implementing an equivalent метод
        
*******************************************************************************/


export class Читатель : ИЧитатель
{       
        // the буфер associated with this читатель. Note that this
        // should not change over the lifetime of the читатель, since
        // it is assumed в_ be immutable elsewhere 
        private ИБуфер                 буфер_;         

        // память-manager for Массив requests
        private ИРазместитель              память;
        private ИПротокол.Разместитель     allocator_;

        // the назначено serialization протокол
        private ИПротокол.ЧитательМассива   массивы;
        private ИПротокол.Читатель        элементы;

		export:
		
        /***********************************************************************
        
                Construct a Читатель upon the предоставленный поток. We do our own
                протокол handling, equivalent в_ the ПротоколНатив. Массив
                allocation is supported via the куча

        ***********************************************************************/

        this (ИПотокВвода поток)
        {
                auto b = cast(ИБуферированный) поток;
                буфер_ = b ? b.буфер : объБуфер (поток.провод);

                allocator_ = &размести;
                элементы   = &читайЭлемент;
                массивы     = &читайМассив;
        }

        /***********************************************************************

                Construct Читатель on the предоставленный протокол. This configures
                the IO conversion в_ be that of the протокол, but allocation
                of массивы is still handled by the куча
                
        ***********************************************************************/

        this (ИПротокол протокол)
        {
                allocator_ = &размести;
                элементы   = &протокол.читай;
                массивы     = &протокол.читайМассив;
                буфер_    = протокол.буфер;
        }

        /***********************************************************************

                Устанавливает Массив разместитель, и протокол, для этого Читатель. See
                метод разместитель() for ещё инфо
                
        ***********************************************************************/

        this (ИРазместитель разместитель)
        {
                this (разместитель.протокол);
                allocator_ = &разместитель.размести;
        }

        /***********************************************************************
        
                Возвращает буфер associated with this читатель

        ***********************************************************************/

        final ИБуфер буфер ()
        {
                return буфер_;
        }
        
        /***********************************************************************       
        
                Get the разместитель в_ use for Массив management. Arrays are
                generally allocated by the ИЧитатель, via configured managers.
                A число of Разместитель classes are available в_ manage память
                when reading Массив контент. Alternatively, the application
                may obtain responsibility for allocation by selecting one of
                the ПротоколНатив deriviatives и настройка 'префикс' в_ be
                нет. The latter disables internal Массив management.

                Gaining доступ в_ the разместитель can expose some добавьitional
                controls. Например, some allocators benefit из_ a сбрось
                operation после each данные 'record' имеется been processed.

                By default, an ИЧитатель will размести each Массив из_ the 
                куча. You can change that by constructing the Читатель
                with an Разместитель of choice. For экземпляр, there is a
                СрезБуфера which will срез an Массив directly из_
                the буфер where possible. Also available is the record-
                oriented HeaoSlice, which slices память из_ внутри
                a pre-allocated куча area, и should be сбрось by the клиент
                код после each record имеется been читай (в_ avoопр unnecessary
                growth). 

                See module io.protocol.Allocator for ещё information

        ***********************************************************************/

        final ИРазместитель разместитель ()
        {
                return память;
        }

        /***********************************************************************
        
                Extract a читаемый class из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (ИЧитатель.Клозура дг) 
        {
                дг (this);
                return this;
        }

        /***********************************************************************
        
                Extract a читаемый class из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (ИЧитаемое x) 
        {
                if (x is пусто)
                    буфер_.ошибка ("Читатель.получи :: attempt в_ читай a пусто ИЧитаемое объект");

                return получи (&x.читай);
        }

        /***********************************************************************

                Extract a булево значение из_ the текущ читай-позиция  
                
        ***********************************************************************/

        final ИЧитатель получи (inout бул x)
        {
                элементы (&x, x.sizeof, ИПротокол.Тип.Bool);
                return this;
        }

        /***********************************************************************

                Extract an unsigned байт значение из_ the текущ читай-позиция   
                                
        ***********************************************************************/

        final ИЧитатель получи (inout ббайт x) 
        {       
                элементы (&x, x.sizeof, ИПротокол.Тип.UByte);
                return this;
        }

        /***********************************************************************
        
                Extract a байт значение из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout байт x)
        {
                элементы (&x, x.sizeof, ИПротокол.Тип.Byte);
                return this;
        }

        /***********************************************************************
        
                Extract an unsigned крат значение из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout бкрат x)
        {
                элементы (&x, x.sizeof, ИПротокол.Тип.UShort);
                return this;
        }

        /***********************************************************************
        
                Extract a крат значение из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout крат x)
        {
                элементы (&x, x.sizeof, ИПротокол.Тип.Short);
                return this;
        }

        /***********************************************************************
        
                Extract a unsigned цел значение из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout бцел x)
        {
                элементы (&x, x.sizeof, ИПротокол.Тип.UInt);
                return this;
        }

        /***********************************************************************
        
                Extract an цел значение из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout цел x)
        {
                элементы (&x, x.sizeof, ИПротокол.Тип.Int);
                return this;
        }

        /***********************************************************************
        
                Extract an unsigned дол значение из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout бдол x)
        {
                элементы (&x, x.sizeof, ИПротокол.Тип.ULong);
                return this;
        }

        /***********************************************************************
        
                Extract a дол значение из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout дол x)
        {
                элементы (&x, x.sizeof, ИПротокол.Тип.Long);
                return this;
        }

        /***********************************************************************
        
                Extract a плав значение из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout плав x)
        {
                элементы (&x, x.sizeof, ИПротокол.Тип.Float);
                return this;
        }

        /***********************************************************************
        
                Extract a дво значение из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout дво x)
        {
                элементы (&x, x.sizeof, ИПротокол.Тип.Double);
                return this;
        }

        /***********************************************************************
        
                Extract a реал значение из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout реал x)
        {
                элементы (&x, x.sizeof, ИПротокол.Тип.Real);
                return this;
        }

        /***********************************************************************
        
                Extract a сим значение из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout сим x)
        {
                элементы (&x, x.sizeof, ИПротокол.Тип.Utf8);
                return this;
        }

        /***********************************************************************
        
                Extract a wide сим значение из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout шим x)
        {
                элементы (&x, x.sizeof, ИПротокол.Тип.Utf16);
                return this;
        }

        /***********************************************************************
        
                Extract a дво сим значение из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout дим x)
        {
                элементы (&x, x.sizeof, ИПротокол.Тип.Utf32);
                return this;
        }

        /***********************************************************************

                Extract an булево Массив из_ the текущ читай-позиция   
                                
        ***********************************************************************/

        final ИЧитатель получи (inout бул[] x) 
        {
                return загрузиМассив (cast(проц[]*) &x, бул.sizeof, ИПротокол.Тип.Bool);
        }

        /***********************************************************************

                Extract an unsigned байт Массив из_ the текущ читай-позиция   
                                
        ***********************************************************************/

        final ИЧитатель получи (inout ббайт[] x) 
        {
                return загрузиМассив (cast(проц[]*) &x, ббайт.sizeof, ИПротокол.Тип.UByte);
        }

        /***********************************************************************
        
                Extract a байт Массив из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout байт[] x)
        {
                return загрузиМассив (cast(проц[]*) &x, байт.sizeof, ИПротокол.Тип.Byte);
        }

        /***********************************************************************
        
                Extract an unsigned крат Массив из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout бкрат[] x)
        {
                return загрузиМассив (cast(проц[]*) &x, бкрат.sizeof, ИПротокол.Тип.UShort);
        }

        /***********************************************************************
        
                Extract a крат Массив из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout крат[] x)
        {
                return загрузиМассив (cast(проц[]*) &x, крат.sizeof, ИПротокол.Тип.Short);
        }

        /***********************************************************************
        
                Extract a unsigned цел Массив из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout бцел[] x)
        {
                return загрузиМассив (cast(проц[]*) &x, бцел.sizeof, ИПротокол.Тип.UInt);
        } 

        /***********************************************************************
        
                Extract an цел Массив из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout цел[] x)
        {
                return загрузиМассив (cast(проц[]*) &x, цел.sizeof, ИПротокол.Тип.Int);
        }

        /***********************************************************************
        
                Extract an unsigned дол Массив из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout бдол[] x)
        {
                return загрузиМассив (cast(проц[]*) &x, бдол.sizeof, ИПротокол.Тип.ULong);
        }

        /***********************************************************************
        
                Extract a дол Массив из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout дол[] x)
        {
                return загрузиМассив (cast(проц[]*) &x,дол.sizeof, ИПротокол.Тип.Long);
        }

        /***********************************************************************
        
                Extract a плав Массив из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout плав[] x)
        {
                return загрузиМассив (cast(проц[]*) &x, плав.sizeof, ИПротокол.Тип.Float);
        }

        /***********************************************************************
        
                Extract a дво Массив из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout дво[] x)
        {
                return загрузиМассив (cast(проц[]*) &x, дво.sizeof, ИПротокол.Тип.Double);
        }

        /***********************************************************************
        
                Extract a реал Массив из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout реал[] x)
        {
                return загрузиМассив (cast(проц[]*) &x, реал.sizeof, ИПротокол.Тип.Real);
        }

        /***********************************************************************
        
                Extract a сим Массив из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout ткст x)
        {
                return загрузиМассив (cast(проц[]*) &x, сим.sizeof, ИПротокол.Тип.Utf8);
        }

        /***********************************************************************
        
                Extract a шим Массив из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout шим[] x)
        {
                return загрузиМассив (cast(проц[]*) &x, шим.sizeof, ИПротокол.Тип.Utf16);
        }

        /***********************************************************************
        
                Extract a дим Массив из_ the текущ читай-позиция
                
        ***********************************************************************/

        final ИЧитатель получи (inout дим[] x)
        {
                return загрузиМассив (cast(проц[]*) &x, дим.sizeof, ИПротокол.Тип.Utf32);
        }


        
        /***********************************************************************
        
        ***********************************************************************/

        private ИЧитатель загрузиМассив (проц[]* x, бцел ширина, ИПротокол.Тип тип)
        {
                *x = массивы (x.ptr, x.length * ширина, тип, allocator_) [0 .. $/ширина];
                return this;
        }
        
        /***********************************************************************

        ***********************************************************************/

        private проц[] размести (ИПротокол.Читатель читатель, бцел байты, ИПротокол.Тип тип)
        {
                return читатель ((new проц[байты]).ptr, байты, тип);
        }

        /***********************************************************************

        ***********************************************************************/

        private проц[] читайЭлемент (ук приёмн, бцел байты, ИПротокол.Тип тип)
        {
                return буфер_.читайРовно (приёмн, байты);
        }
        
        /***********************************************************************

        ***********************************************************************/

        private проц[] читайМассив (ук приёмн, бцел байты, ИПротокол.Тип тип, ИПротокол.Разместитель размести)
        {
                читайЭлемент (&байты, байты.sizeof, ИПротокол.Тип.UInt);
                return размести (&читайЭлемент, байты, тип); 
        }
}
                