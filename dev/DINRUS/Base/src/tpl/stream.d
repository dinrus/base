module tpl.stream;

import cidrus,  tpl.args;
import std.string, std.utf, std.format, std.file, std.crc32;
//import win: скажинс;

alias isfile естьФайл;
alias toUTF16 вЮ16;
alias toUTF32 вЮ32;
alias toUTF8 вЮ8;
alias init_crc32 иницЦПИ32;
alias update_crc32 обновиЦПИ32;

protected бул пробел(сим c) {
  return c == ' ' || c == '\t' || c == '\r' || c == '\n';
}

protected бул цифра(сим c) {
  return c >= '0' && c <= '9';
}

protected бул цифра8(сим c) {
  return c >= '0' && c <= '7';
}

protected бул цифра16(сим c) {
  return цифра(c) || (c >= 'A' && c <= 'F') || (c >= 'a' && c <= 'f');
}

////////////////////////
interface ИГенернПотокВвода{  

  проц читайРовно(ук буфер, т_мера размер);
  т_мера читай(ббайт[] буфер);
  проц читай(out байт x);
  проц читай(out ббайт x);	
  проц читай(out крат x);	
  проц читай(out бкрат x);	
  проц читай(out цел x);		
  проц читай(out бцел x);	
  проц читай(out дол x);	
  проц читай(out бдол x);	
  проц читай(out плав x);	
  проц читай(out дво x);	
  проц читай(out реал x);	
  проц читай(out вплав x);	
  проц читай(out вдво x);	
  проц читай(out вреал x);	
  проц читай(out кплав x);	
  проц читай(out кдво x);	
  проц читай(out креал x);	
  проц читай(out сим x);	
  проц читай(out шим x);	
  проц читай(out дим x);	
  проц читай(out ткст s);	
  проц читай(out шим[] s);	
  ткст читайСтр();
  ткст читайСтр(ткст результат);	
  шим[] читайСтрШ();			
  шим[] читайСтрШ(шим[] результат);	
  цел opApply(цел delegate(inout ткст строка) дг);
  цел opApply(цел delegate(inout бдол n, inout ткст строка) дг);  
  цел opApply(цел delegate(inout шим[] строка) дг);		   
  цел opApply(цел delegate(inout бдол n, inout шим[] строка) дг); 
  ткст читайТкст(т_мера длина);
  шим[]читайТкстШ(т_мера длина);
  сим берис();
  шим бериш(); 
  сим отдайс(сим c);
  шим отдайш(шим c);
  цел вчитайф(ИнфОТипе[] аргументы, ук арги);
  цел читайф(...); 
  т_мера доступно();
  бул кф();
  бул открыт_ли();
}

interface ИГенернПотокВывода {

проц пишиРовно(ук буфер, т_мера размер);
  т_мера пиши(ббайт[] буфер);
  проц пиши(байт x);
  проц пиши(ббайт x);		
  проц пиши(крат x);		
  проц пиши(бкрат x);		
  проц пиши(цел x);		
  проц пиши(бцел x);		
  проц пиши(дол x);		
  проц пиши(бдол x);		
  проц пиши(плав x);		
  проц пиши(дво x);		
  проц пиши(реал x);		
  проц пиши(вплав x);		
  проц пиши(вдво x);	
  проц пиши(вреал x);		
  проц пиши(кплав x);		
  проц пиши(кдво x);	
  проц пиши(креал x);		
  проц пиши(сим x);		
  проц пиши(шим x);		
  проц пиши(дим x);		
  проц пиши(ткст s);
  проц пиши(шим[] s);	
  проц пишиСтр(ткст s);
  проц пишиСтрШ(шим[] s);
  проц пишиТкст(ткст s);
  проц пишиТкстШ(шим[] s);
  т_мера ввыводф(ткст format, спис_ва арги);
  т_мера выводф(ткст format, ...);	
  ИГенернПотокВывода пишиф(...);
  ИГенернПотокВывода пишифнс(...); 
  ИГенернПотокВывода пишификс(ИнфОТипе[] аргументы, ук аргук, цел newline = 0);  

  проц слей();	
  проц закрой(); 
  бул открыт_ли(); 
}
////////////////////////////////////////////////////


export extern (D) abstract class Поток :  ИГенернПотокВвода, ИГенернПотокВывода
 {
extern(C) extern
{
      шим[] возврат;
	  бул читаем;	
	  бул записываем;
	  бул сканируем;
	  бул открыт;	
	  бул читайдоКФ;
	  бул предВкар;
 }
	  
export:
	  
	  бул читаемый(){return this.читаем;}
	  бул записываемый(){return this.записываем;}
	  бул сканируемый(){return this.сканируем;}
	  
	  проц читаемый(бул б){this.читаем = б;}
	  проц записываемый(бул б){this.записываем = б;}
	  проц сканируемый(бул б){this.сканируем = б;}
	  
	  проц открытый(бул б){this.открыт = б;}
	  бул открытый(){return открыт;}
	  
	   проц читатьдоКФ(бул б){this.читайдоКФ = б;}
	  бул читатьдоКФ(){return  this.читайдоКФ;}
	  
	  проц возвратКаретки(бул б){this.предВкар = б;}
	  бул возвратКаретки(){return  this.предВкар;} 
	  

	  //protected static this() {}

	  this() 
	  {
	  this.читаем = false;	
	  this.записываем = false;
	  this.сканируем = false;
	  this.открыт = true;	
	  this.читайдоКФ = false;
	  this.предВкар = false;
	  }
	  ~this(){}
	  
	  т_мера читайБлок(ук буфер, т_мера размер){return 0;}

	  проц читайРовно(ук буфер, т_мера размер) {
		for(;;) {
		  if (!размер) return;
		  т_мера readsize = читайБлок(буфер, размер); // return 0 on кф
		  if (readsize == 0) break;
		  буфер += readsize;
		  размер -= readsize;
		}
		if (размер != 0)
		  ошибка("Поток.читайБлок: Недостаточно данных в потоке",__FILE__,__LINE__);
	  }

	  // считывает блок данных, достаточный для заполнения
	  // заданного массива, возвращает чило действительно считанных байтов
	  т_мера читай(ббайт[] буфер) {
		return читайБлок(буфер.ptr, буфер.length);
	  }

	  // читай a single значение of требуется type,
	  // throw ИсключениеЧтения on error
	  проц читай(out байт x) { читайРовно(&x, x.sizeof); }
	  проц читай(out ббайт x) { читайРовно(&x, x.sizeof); }
	  проц читай(out крат x) { читайРовно(&x, x.sizeof); }
	  проц читай(out бкрат x) { читайРовно(&x, x.sizeof); }
	  проц читай(out цел x) { читайРовно(&x, x.sizeof); }
	  проц читай(out бцел x) { читайРовно(&x, x.sizeof); }
	  проц читай(out дол x) { читайРовно(&x, x.sizeof); }
	  проц читай(out бдол x) { читайРовно(&x, x.sizeof); }
	  проц читай(out плав x) { читайРовно(&x, x.sizeof); }
	  проц читай(out дво x) { читайРовно(&x, x.sizeof); }
	  проц читай(out реал x) { читайРовно(&x, x.sizeof); }
	  проц читай(out вплав x) { читайРовно(&x, x.sizeof); }
	  проц читай(out вдво x) { читайРовно(&x, x.sizeof); }
	  проц читай(out вреал x) { читайРовно(&x, x.sizeof); }
	  проц читай(out кплав x) { читайРовно(&x, x.sizeof); }
	  проц читай(out кдво x) { читайРовно(&x, x.sizeof); }
	  проц читай(out креал x) { читайРовно(&x, x.sizeof); }
	  проц читай(out сим x) { читайРовно(&x, x.sizeof); }
	  проц читай(out шим x) { читайРовно(&x, x.sizeof); }
	  проц читай(out дим x) { читайРовно(&x, x.sizeof); }

	  // reads a ткст, written earlier by пиши()
	  проц читай(out ткст s) {
		т_мера длин;
		читай(длин);
		s = читайТкст(длин);
	  }

	  // reads a Unicode ткст, written earlier by пиши()
	  проц читай(out шим[] s) {
		т_мера длин;
		читай(длин);
		s = читайТкстШ(длин);
	  }

	  // reads a строка, terminated by either CR, LF, CR/LF, or EOF
	  ткст читайСтр() {
		return читайСтр(null);
	  }

	  // reads a строка, terminated by either CR, LF, CR/LF, or EOF
	  // reusing the memory in буфер if результат will fit and otherwise
	  // allocates a new ткст
	  ткст читайСтр(ткст результат) {
		т_мера strlen = 0;
		сим ch = берис();
		while (читаем) {
		  switch (ch) {
		  case '\r':
		if (сканируем) {
		  ch = берис();
		  if (ch != '\n')
			отдайс(ch);
		} else {
		  предВкар = true;
		}
		  case '\n':
		  case сим.init:
		результат.length = strlen;
		return результат;

		  default:
		if (strlen < результат.length) {
		  результат[strlen] = ch;
		} else {
		  результат ~= ch;
		}
		strlen++;
		  }
		  ch = берис();
		}
		результат.length = strlen;
		return результат;
	  }

	  // reads a Unicode строка, terminated by either CR, LF, CR/LF,
	  // or EOF; pretty much the same as the above, working with
	  // шимs rather than симs
	  шим[] читайСтрШ() {
		return читайСтрШ(null);
	  }

	  // reads a Unicode строка, terminated by either CR, LF, CR/LF,
	  // or EOF;
	  // fills supplied буфер if строка fits and otherwise allocates a new ткст.
	  шим[] читайСтрШ(шим[] результат) {
		т_мера strlen = 0;
		шим c = бериш();
		while (читаем) {
		  switch (c) {
		  case '\r':
		if (сканируем) {
		  c = бериш();
		  if (c != '\n')
			отдайш(c);
		} else {
		  предВкар = true;
		}
		  case '\n':
		  case шим.init:
		результат.length = strlen;
		return результат;

		  default:
		if (strlen < результат.length) {
		  результат[strlen] = c;
		} else {
		  результат ~= c;
		}
		strlen++;
		  }
		  c = бериш();
		}
		результат.length = strlen;
		return результат;
	  }

	  // iterate through the stream строка-by-строка - due to Regan Heath
	  цел opApply(цел delegate(inout ткст строка) дг) {
		цел res = 0;
		сим[128] буф;
		while (!кф()) {
		  ткст строка = читайСтр(буф);
		  res = дг(строка);
		  if (res) break;
		}
		return res;
	  }

	  // iterate through the stream строка-by-строка with строка count and ткст
	  цел opApply(цел delegate(inout бдол n, inout ткст строка) дг) {
		цел res = 0;
		бдол n = 1;
		сим[128] буф;
		while (!кф()) {
		  auto строка = читайСтр(буф);
		  res = дг(n,строка);
		  if (res) break;
		  n++;
		}
		return res;
	  }

	  // iterate through the stream строка-by-строка with шим[]
	  цел opApply(цел delegate(inout шим[] строка) дг) {
		цел res = 0;
		шим[128] буф;
		while (!кф()) {
		  auto строка = читайСтрШ(буф);
		  res = дг(строка);
		  if (res) break;
		}
		return res;
	  }

	  // iterate through the stream строка-by-строка with строка count and шим[]
	  цел opApply(цел delegate(inout бдол n, inout шим[] строка) дг) {
		цел res = 0;
		бдол n = 1;
		шим[128] буф;
		while (!кф()) {
		  auto строка = читайСтрШ(буф);
		  res = дг(n,строка);
		  if (res) break;
		  n++;
		}
		return res;
	  }

	  // reads a ткст of given length, throws
	  // ИсключениеЧтения on error
	  ткст читайТкст(т_мера длина) {
		ткст результат = new сим[длина];
		читайРовно(результат.ptr, длина);
		return результат;
	  }

	  // reads a Unicode ткст of given длина, throws
	  // ИсключениеЧтения on error
	  шим[] читайТкстШ(т_мера длина) {
		auto результат = new шим[длина];
		читайРовно(результат.ptr, результат.length * шим.sizeof);
		return результат;
	  }

	  // отдай буфер
	  
	   бул верниЧтоЕсть() { return возврат.length > 1; }

	  // reads and returns следщ симacter from the stream,
	  // handles симacters pushed back by отдайс()
	  // returns сим.init on кф.
	  сим берис() {
		сим c;
		if (предВкар) {
		  предВкар = false;
		  c = берис();
		  if (c != '\n') 
		  return c;
		}
		if (возврат.length > 1) {
		  c = cast(сим) возврат[возврат.length - 1];
		  возврат.length = возврат.length - 1;
		} else {
		
		   читайБлок(&c,1);
		}
		//скажинс("берис2");
		//скажинс(форматируй(c));
		return c;
	  }

	  // reads and returns следщ Unicode симacter from the
	  // stream, handles симacters pushed back by отдайс()
	  // returns шим.init on кф.
	  шим бериш() {
		шим c;
		if (предВкар) {
		  предВкар = false;
		  c = бериш();
		  if (c != '\n') 
		return c;
		}
		if (возврат.length > 1) {
		  c = возврат[возврат.length - 1];
		  возврат.length = возврат.length - 1;
		} else {
		  ук буф = &c;
		  т_мера n = читайБлок(буф,2);
		  if (n == 1 && читайБлок(буф+1,1) == 0)
			  ошибка("Поток.бериш: Недостаточно данных в потоке",__FILE__,__LINE__);
		}
		return c;
	  }

	  // pushes back симacter c целo the stream; only has
	  // effect on further calls to берис() and бериш()
	  сим отдайс(сим c) {
		  if (c == c.init) return c;
		// first байт is a dummy so that we never установи length to 0
		if (возврат.length == 0)
		  возврат.length = 1;
		возврат ~= c;
		return c;
	  }

	  // pushes back Unicode симacter c целo the stream; only
	  // has effect on further calls to берис() and бериш()
	  шим отдайш(шим c) {
		if (c == c.init) return c;
		// first байт is a dummy so that we never установи length to 0
		if (возврат.length == 0)
		  возврат.length = 1;
		возврат ~= c;
		return c;
	  }

	  цел вчитайф(ИнфОТипе[] аргументы, ук арги) {
		ткст fmt;
		цел j = 0;
		цел count = 0, i = 0;
		сим c = берис();
		while ((j < аргументы.length || i < fmt.length) && !кф()) {
		  if (fmt.length == 0 || i == fmt.length) {
		i = 0;
		if (аргументы[j] is typeid(сим[])) {
		  fmt = ва_арг!(ткст)(арги);
		  j++;
		  continue;
		} else if (аргументы[j] is typeid(цел*) ||
			   аргументы[j] is typeid(байт*) ||
			   аргументы[j] is typeid(крат*) ||
			   аргументы[j] is typeid(дол*)) {
		  fmt = "%d";
		} else if (аргументы[j] is typeid(бцел*) ||
			   аргументы[j] is typeid(ббайт*) ||
			   аргументы[j] is typeid(бкрат*) ||
			   аргументы[j] is typeid(бдол*)) {
		  fmt = "%d";
		} else if (аргументы[j] is typeid(плав*) ||
			   аргументы[j] is typeid(дво*) ||
			   аргументы[j] is typeid(реал*)) {
		  fmt = "%f";
		} else if (аргументы[j] is typeid(сим[]*) ||
			   аргументы[j] is typeid(шим[]*) ||
			   аргументы[j] is typeid(дим[]*)) {
		  fmt = "%s";
		} else if (аргументы[j] is typeid(сим*)) {
		  fmt = "%c";
		}
		  }
		  if (fmt[i] == '%') {	// a field
		i++;
		бул suppress = false;
		if (fmt[i] == '*') {	// suppress assignment
		  suppress = true;
		  i++;
		}
		// читай field width
		цел width = 0;
		while (цифра(fmt[i])) {
		  width = width * 10 + (fmt[i] - '0');
		  i++;
		}
		if (width == 0)
		  width = -1;
		// skip any modifier if present
		if (fmt[i] == 'h' || fmt[i] == 'l' || fmt[i] == 'L')
		  i++;
		// check the typeсим and act accordingly
		switch (fmt[i]) {
		case 'd':	// decimal/hexadecimal/octal целeger
		case 'D':
		case 'u':
		case 'U':
		case 'o':
		case 'O':
		case 'x':
		case 'X':
		case 'i':
		case 'I':
		  {
			while (пробел(c)) {
			  c = берис();
			  count++;
			}
			бул neg = false;
			if (c == '-') {
			  neg = true;
			  c = берис();
			  count++;
			} else if (c == '+') {
			  c = берис();
			  count++;
			}
			сим ifmt = cast(сим)(fmt[i] | 0x20);
			if (ifmt == 'i')	{ // undetermined base
			  if (c == '0')	{ // octal or hex
			c = берис();
			count++;
			if (c == 'x' || c == 'X')	{ // hex
			  ifmt = 'x';
			  c = берис();
			  count++;
			} else {	// octal
			  ifmt = 'o';
			}
			  }
			  else	// decimal
			ifmt = 'd';
			}
			дол n = 0;
			switch (ifmt)
			{
			case 'd':	// decimal
			case 'u': {
			  while (цифра(c) && width) {
				n = n * 10 + (c - '0');
				width--;
				c = берис();
				count++;
			  }
			} break;

			case 'o': {	// octal
			  while (цифра8(c) && width) {
				n = n * 010 + (c - '0');
				width--;
				c = берис();
				count++;
			  }
			} break;

			case 'x': {	// hexadecimal
			  while (цифра16(c) && width) {
				n *= 0x10;
				if (цифра(c))
				  n += c - '0';
				else
				  n += 0xA + (c | 0x20) - 'a';
				width--;
				c = берис();
				count++;
			  }
			} break;

			default:
				assert(0);
			}
			if (neg)
			  n = -n;
			if (аргументы[j] is typeid(цел*)) {
			  цел* p = ва_арг!(цел*)(арги);
			  *p = cast(цел)n;
			} else if (аргументы[j] is typeid(крат*)) {
			  крат* p = ва_арг!(крат*)(арги);
			  *p = cast(крат)n;
			} else if (аргументы[j] is typeid(байт*)) {
			  байт* p = ва_арг!(байт*)(арги);
			  *p = cast(байт)n;
			} else if (аргументы[j] is typeid(дол*)) {
			  дол* p = ва_арг!(дол*)(арги);
			  *p = n;
			} else if (аргументы[j] is typeid(бцел*)) {
			  бцел* p = ва_арг!(бцел*)(арги);
			  *p = cast(бцел)n;
			} else if (аргументы[j] is typeid(бкрат*)) {
			  бкрат* p = ва_арг!(бкрат*)(арги);
			  *p = cast(бкрат)n;
			} else if (аргументы[j] is typeid(ббайт*)) {
			  ббайт* p = ва_арг!(ббайт*)(арги);
			  *p = cast(ббайт)n;
			} else if (аргументы[j] is typeid(бдол*)) {
			  бдол* p = ва_арг!(бдол*)(арги);
			  *p = cast(бдол)n;
			}
			j++;
			i++;
		  } break;

		case 'f':	// плав
		case 'F':
		case 'e':
		case 'E':
		case 'g':
		case 'G':
		  {
			while (пробел(c)) {
			  c = берис();
			  count++;
			}
			бул neg = false;
			if (c == '-') {
			  neg = true;
			  c = берис();
			  count++;
			} else if (c == '+') {
			  c = берис();
			  count++;
			}
			реал n = 0;
			while (цифра(c) && width) {
			  n = n * 10 + (c - '0');
			  width--;
			  c = берис();
			  count++;
			}
			if (width && c == '.') {
			  width--;
			  c = берис();
			  count++;
			  дво frac = 1;
			  while (цифра(c) && width) {
			n = n * 10 + (c - '0');
			frac *= 10;
			width--;
			c = берис();
			count++;
			  }
			  n /= frac;
			}
			if (width && (c == 'e' || c == 'E')) {
			  width--;
			  c = берис();
			  count++;
			  if (width) {
			бул expneg = false;
			if (c == '-') {
			  expneg = true;
			  width--;
			  c = берис();
			  count++;
			} else if (c == '+') {
			  width--;
			  c = берис();
			  count++;
			}
			реал exp = 0;
			while (цифра(c) && width) {
			  exp = exp * 10 + (c - '0');
			  width--;
			  c = берис();
			  count++;
			}
			if (expneg) {
			  while (exp--)
				n /= 10;
			} else {
			  while (exp--)
				n *= 10;
			}
			  }
			}
			if (neg)
			  n = -n;
			if (аргументы[j] is typeid(плав*)) {
			  плав* p = ва_арг!(плав*)(арги);
			  *p = n;
			} else if (аргументы[j] is typeid(дво*)) {
			  дво* p = ва_арг!(дво*)(арги);
			  *p = n;
			} else if (аргументы[j] is typeid(реал*)) {
			  реал* p = ва_арг!(реал*)(арги);
			  *p = n;
			}
			j++;
			i++;
		  } break;

		case 's': {	// ткст
		  while (пробел(c)) {
			c = берис();
			count++;
		  }
		  ткст s;
		  сим[]* p;
		  т_мера strlen;
		  if (аргументы[j] is typeid(сим[]*)) {
			p = ва_арг!(сим[]*)(арги);
			s = *p;
		  }
		  while (!пробел(c) && c != сим.init) {
			if (strlen < s.length) {
			  s[strlen] = c;
			} else {
			  s ~= c;
			}
			strlen++;
			c = берис();
			count++;
		  }
		  s = s[0 .. strlen];
		  if (аргументы[j] is typeid(сим[]*)) {
			*p = s;
		  } else if (аргументы[j] is typeid(сим*)) {
			s ~= 0;
			auto q = ва_арг!(сим*)(арги);
			q[0 .. s.length] = s[];
		  } else if (аргументы[j] is typeid(шим[]*)) {
			auto q = ва_арг!(шим[]*)(арги);
			*q = вЮ16(s);
		  } else if (аргументы[j] is typeid(дим[]*)) {
			auto q = ва_арг!(дим[]*)(арги);
			*q = вЮ32(s);
		  }
		  j++;
		  i++;
		} break;

		case 'c': {	// симacter(s)
		  сим* s = ва_арг!(сим*)(арги);
		  if (width < 0)
			width = 1;
		  else
			while (пробел(c)) {
			c = берис();
			count++;
		  }
		  while (width-- && !кф()) {
			*(s++) = c;
			c = берис();
			count++;
		  }
		  j++;
		  i++;
		} break;

		case 'n': {	// number of симs читай so far
		  цел* p = ва_арг!(цел*)(арги);
		  *p = count;
		  j++;
		  i++;
		} break;

		default:	// читай симacter as is
		  goto nws;
		}
		  } else if (пробел(fmt[i])) {	// skip whitespace
		while (пробел(c))
		  c = берис();
		i++;
		  } else {	// читай симacter as is
		  nws:
		if (fmt[i] != c)
		  break;
		c = берис();
		i++;
		  }
		}
		отдайс(c);
		return count;
	  }

	  цел читайф(...) {
		return вчитайф(_arguments, _argptr);
	  }

	  т_мера доступно() { return 0; }

	  abstract т_мера пишиБлок(ук буфер, т_мера размер);

	  проц пишиРовно(ук буфер, т_мера размер) {
	// debug скажинс(std.string.format("вход в пишиРовно: буфер=%s; размер=%s", буфер, размер));
		for(;;) {
		  if (!размер) return;
		  т_мера writesize = пишиБлок(буфер, размер);
		  if (writesize == 0) break;
		  буфер += writesize;
		  размер -= writesize;
		}
		if (размер != 0)
		  ошибка("Поток.пишиРовно: Запись в поток невозможна",__FILE__,__LINE__);
	  }

	  // writes the given массив of bytes, returns
	  // actual number of bytes written
	  т_мера пиши(ббайт[] буфер) {
		return пишиБлок(буфер.ptr, буфер.length);
	  }

	  // пиши a single значение of требуется type,
	  // throw ИсключениеЗаписи on error
	  проц пиши(байт x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(ббайт x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(крат x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(бкрат x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(цел x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(бцел x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(дол x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(бдол x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(плав x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(дво x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(реал x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(вплав x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(вдво x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(вреал x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(кплав x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(кдво x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(креал x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(сим x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(шим x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(дим x) { пишиРовно(&x, x.sizeof); }

		// writes a ткст, throws ИсключениеЗаписи on error
	  проц пишиТкст(ткст s) {
	  
	 // скажинс(форматируй("направление в пишиРовно из пишиТкст: текст =%s", s));
		пишиРовно(s.ptr, s.length);
	  }

	  // writes a Unicode ткст, throws ИсключениеЗаписи on error
	  проц пишиТкстШ(шткст s) {
		пишиРовно(s.ptr, s.length * шим.sizeof);
	  }
	  
	  // writes a ткст, together with its length
	  проц пиши(ткст s) {
		пиши(s.length);
		пишиТкст(s);
	  }

	  // writes a Unicode ткст, together with its length
	  проц пиши(шткст s) {
		пиши(s.length);
		пишиТкстШ(s);
	  }

	  // writes a строка, throws ИсключениеЗаписи on error
	  проц пишиСтр(ткст s) {
		   пишиТкст(s~"\r\n");
		   //пишиТкст("\n");
	  }

	  // writes a Unicode строка, throws ИсключениеЗаписи on error
	  проц пишиСтрШ(шим[] s) {
		пишиТкстШ(s~"\r\n");
		   //пишиТкстШ("\n");
	  }


	  // writes данные to stream using ввыводф() syntax,
	  // returns number of bytes written
	  т_мера ввыводф(ткст format, спис_ва арги) {
		// shamelessly stolen from OutBuffer,
		// by Walter's permission
		сим[1024] буфер;
		сим* p = буфер.ptr;
		auto f = format;
		т_мера psize = буфер.length;
		т_мера count;
		while (true) {
		  version (Win32) {
		count = вснвыводф(stdrus.вТкст(p), psize, f, арги);
		if (count != -1)
		  break;
		psize *= 2;
		p = cast(сим*) разместа(psize);
		  } else version (Posix) {
		count = вснвыводф(stdrus.вТкст(p), psize, f, арги);
		if (count == -1)
		  psize *= 2;
		else if (count >= psize)
		  psize = count + 1;
		else
		  break;
		p = cast(сим*) разместа(psize);
		  } else
		  ошибка("Неподдерживаемая платформа",__FILE__,__LINE__);
		}
		пишиТкст(p[0 .. count]);
		return count;
	  }

	  // writes данные to stream using выводф() syntax,
	  // returns number of bytes written
	  т_мера выводф(ткст format, ...) {
		спис_ва ap;
		ap = cast(спис_ва) &format;
		ap += format.sizeof;
		return ввыводф(format, ap);
	  }

	  проц doFormatCallback(дим c) { 
		сим[4] буф;
		auto b = вЮ8(буф, c);
		пишиТкст(b);
	  }

	  // writes данные to stream using пишиф() syntax,
	  ИГенернПотокВывода пишиф(...) {
		return пишификс(_arguments,_argptr,0);
	  }

	  // writes данные with trailing newline
	  ИГенернПотокВывода пишифнс(...) {
		return пишификс(_arguments,_argptr,1);
	  }

	  // writes данные with optional trailing newline
	  ИГенернПотокВывода пишификс(ИнфОТипе[] аргументы, ук argptr, цел newline=0) {
		doFormat(&doFormatCallback,аргументы,argptr);
		if (newline) 
		  пишиСтр("");
		return this;
	  }

	  /***
	   * Copies all данные from s целo this stream.
	   * This may throw ИсключениеЧтения or ИсключениеЗаписи on failure.
	   * This restores the файл позиция of s so that it is unchanged.
	   */
	  проц копируй_из(Поток s) {
		if (сканируем) {
		  бдол pos = s.позиция();
		  s.позиция(0);
		  копируй_из(s, s.размер());
		  s.позиция(pos);
		} else {
		  ббайт[128] буф;
		  while (!s.кф()) {
		т_мера m = s.читайБлок(буф.ptr, буф.length);
		пишиРовно(буф.ptr, m);
		  }
		}
	  }

	  /***
	   * Copy a specified number of bytes from the given stream целo this one.
	   * This may throw ИсключениеЧтения or ИсключениеЗаписи on failure.
	   * Unlike the previous form, this doesn't restore the файл позиция of s.
	   */
	  проц копируй_из(Поток s, бдол count) {
		ббайт[128] буф;
		while (count > 0) {
		  т_мера n = cast(т_мера)(count<буф.length ? count : буф.length);
		  s.читайРовно(буф.ptr, n);
		  пишиРовно(буф.ptr, n);
		  count -= n;
		}
	  }

	  /***
	   * Change the current позиция of the stream. whence is either ППозКурсора.Уст, in
	   which case the смещение is an absolute index from the beginning of the stream,
	   ППозКурсора.Тек, in which case the смещение is a дельта from the current
	   позиция, or ППозКурсора.Кон, in which case the смещение is a дельта from the end of
	   the stream (negative or zero смещениеs only make sense in that case). This
	   returns the new файл позиция.
	   */
	  abstract бдол сместись(дол смещение, ППозКурсора whence);

	  /***
	   * Aliases for their normal сместись counterparts.
	   */
	  бдол измпозУст(дол смещение) { return сместись (смещение, ППозКурсора.Уст); }
	  бдол измпозТек(дол смещение) { return сместись (смещение, ППозКурсора.Тек); }	/// описано ранее
	  бдол измпозКон(дол смещение) { return сместись (смещение, ППозКурсора.Кон); }	/// описано ранее

	  /***
	   * Sets файл позиция. Эквивалентно to calling сместись(pos, ППозКурсора.Уст).
	   */
	  проц позиция(бдол pos) { сместись(cast(дол)pos, ППозКурсора.Уст); }

	  /***
	   * Returns current файл позиция. Эквивалентно to сместись(0, ППозКурсора.Тек).
	   */
	  бдол позиция() { return сместись(0, ППозКурсора.Тек); }

	  /***
	   * Retrieve the размер of the stream in bytes.
	   * The stream must be сканируем or a ИсключениеПеремещения is thrown.
	   */
	  бдол размер() {
		проверьСканируемость();
		бдол pos = позиция(), результат = сместись(0, ППозКурсора.Кон);
		позиция(pos);
		return результат;
	  }

	  // returns true if end of stream is reached, false otherwise
	  бул кф() { 
		// for unсканируемый streams we only know the end when we читай it
		if (читайдоКФ && !верниЧтоЕсть())
		  return true;
		else if (сканируем)
		  return позиция() == размер(); 
		else
		  return false;
	  }

	  // returns true if the stream is open
	  бул открыт_ли() { return открытый(); }

	  // слей the буфер if записываем
	  проц слей() {
		if (возврат.length > 1)
		  возврат.length = 1; // keep at least 1 so that данные ptr stays
	  }

	  // закрой the stream somehow; the default just flushes the буфер
	  проц закрой() {
		if (открытый())
		  слей();
		читатьдоКФ(false); возвратКаретки(false);открытый(false);читаемый(false);
		записываемый(false);сканируемый(false);
	  }

	 проц удали (ткст имяф)
	  {if(открытый())закрой();
	  if(!естьФайл(имяф))
		{
		скажинс(std.string.format("\n\tИНФО:  Файл %s удалён ранее или вовсе не существовал", имяф)); return ;
		}
	  else if(!УдалиФайл(имяф))
	  скажинс(std.string.format("\n\tИНФО:  Файл %s остался не удалёным", имяф));
	  else
	  скажинс(std.string.format("\n\tИНФО:  Файл %s успешно удалён", имяф));}
	   
	   
	  override ткст toString() {
		return this.вТкст();
	  }
	  
	ткст вТкст()
	{
	if (!читаемый())
		  return super.toString();
		т_мера pos;
		т_мера rdlen;
		т_мера blockSize;
		ткст результат;
		if (сканируемый()) {
		  бдол orig_pos = позиция();
		  позиция(0);
		  blockSize = cast(т_мера)размер();
		  результат = new сим[blockSize];
		  while (blockSize > 0) {
		rdlen = читайБлок(&результат[pos], blockSize);
		pos += rdlen;
		blockSize -= rdlen;
		  }
		  позиция(orig_pos);
		} else {
		  blockSize = 4096;
		  результат = new сим[blockSize];
		  while ((rdlen = читайБлок(&результат[pos], blockSize)) > 0) {
		pos += rdlen;
		blockSize += rdlen;
		результат.length = результат.length + blockSize;
		  }
		}
		return результат[0 .. pos];
	  }

	  /***
	   * Get a hash of the stream by reading each байт and using it in a CRC-32
	   * checksum.
	   */
	  override т_мера toHash()
	  {
	  return  this.вХэш();
	  }    
	  
	т_мера вХэш()
	{
	if (!читаем || !сканируем)
		  return super.toHash();
		бдол pos = позиция();
		бцел crc = иницЦПИ32();
		позиция(0);
		бдол длин = размер();
		for (бдол i = 0; i < длин; i++) {
		  ббайт c;
		  читай(c);
		  crc = обновиЦПИ32(c, crc);
		}
		позиция(pos);
		return crc;
	  }

	  // helper for checking that the stream is читаем
	  бул проверьЧитаемость(ткст имяПотока = ткст.init,ткст файл = ткст.init, дол  строка = дол.init) {
		if (!читаемый()){
		  ошибка(имяПотока~" : поток не читаем!",файл, строка);}
		  return true;
	  }
	  // helper for checking that the stream is записываем
	  бул проверьЗаписываемость(ткст имяПотока = ткст.init,ткст файл = ткст.init, дол  строка = дол.init) {
		if (!записываемый()){
		  ошибка(имяПотока~": поток не записываем!",файл,строка);}
		  return true;
	  }
	  // helper for checking that the stream is сканируем
	  бул проверьСканируемость(ткст имяПотока = ткст.init,ткст файл = ткст.init, дол  строка = дол.init) {
		if (!сканируемый()){
		  ошибка(имяПотока~": поток не сканируем",файл,строка);}
		  return true;
	  }
	}

class ТПотокМассив(Буфер): Поток {

  Буфер буф; // текущие данные
  бдол длин;  // текущие данные длина
  бдол тек;  // текущие файл позиция

  /// Create the stream for the the буфер буф. Non-copying.
  this(Буфер бф) {
    super ();
	this.буф = бф;
    this.длин = бф.length;
    читаемый(да); записываемый(да); сканируемый(да);
	читаемый();
  }

 // invariant() {
   // assert(длин <= буф.length);
   // assert(тек <= длин);
 // }

  override т_мера читайБлок(ук буфер, т_мера размер) {
    проверьЧитаемость();
    ббайт* cbuf = cast(ббайт*) буфер;
    if (длин - тек < размер)
      размер = cast(т_мера)(длин - тек);
    ббайт[] ubuf = cast(ббайт[])буф[cast(т_мера)тек .. cast(т_мера)(тек + размер)];
    cbuf[0 .. размер] = ubuf[];
    тек += размер;
    return размер;
  }

  override т_мера пишиБлок(ук буфер, т_мера размер) {
    проверьЗаписываемость();
    ббайт* cbuf = cast(ббайт*) буфер;
    бдол blen = буф.length;
    if (тек + размер > blen)
      размер = cast(т_мера)(blen - тек);
    ббайт[] ubuf = cast(ббайт[])буф[cast(т_мера)тек .. cast(т_мера)(тек + размер)];
    ubuf[] = cbuf[0 .. размер];
    тек += размер;
    if (тек > длин)
      длин = тек;
    return размер;
  }

   override бдол сместись(дол смещение, ППозКурсора rel) {
    проверьСканируемость();
    дол scur; // signed to saturate to 0 properly

    switch (rel) {
    case ППозКурсора.Уст: scur = смещение; break;
    case ППозКурсора.Тек: scur = cast(дол)(тек + смещение); break;
    case ППозКурсора.Кон: scur = cast(дол)(длин + смещение); break;
    default:
	assert(0);
    }

    if (scur < 0)
      тек = 0;
    else if (scur > длин)
      тек = длин;
    else
      тек = cast(бдол)scur;

    return тек;
  }

 override т_мера доступно () { return cast(т_мера)(длин - тек); }

  /// Получить в общем текущие данные памяти.
   ббайт[] данные() { 
    if (длин > т_мера.max)
      throw new Исключение("ТПотокМассив.данные: поток слишком длинный!");
    проц[] res = буф[0 .. cast(т_мера)длин];
    return cast(ббайт[])res;
  }

  override ткст вТкст() {
    return cast(сим[]) данные ();
  }
  
  ~this(){}
}