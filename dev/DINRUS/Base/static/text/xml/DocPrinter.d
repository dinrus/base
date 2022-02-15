module text.xml.DocPrinter;

private import io.model;

private import text.xml.Document;

/*******************************************************************************

        Simple Документ printer, with support for serialization caching 
        where the latter avoопрs having в_ generate unchanged подст-trees

*******************************************************************************/

class ДокПринтер(T)
{
        public alias Документ!(T) Док;          /// the typed документ
        public alias Док.Узел Узел;             /// генерный документ узел

        private бул быстро = да;
        private бцел indentation = 2;

        version (Win32)
                 private const T[] Кс = "\r\n";
           else
              private const T[] Кс = "\n";

        /***********************************************************************
        
                Sets the число of пробелы использован when increasing indentation
                levels. Use a значение of zero в_ disable явный formatting

        ***********************************************************************/
        
        final ДокПринтер indent (бцел indentation)
        {       
                this.indentation = indentation;
                return this;
        }

        /***********************************************************************

                Enable or disable use of cached документ snИПpets. These
                represent документ branches that remain unaltered, и
                can be излейted verbatim instead of traversing the дерево
                        
        ***********************************************************************/
        
        final ДокПринтер кэш (бул да)
        {       
                this.быстро = да;
                return this;
        }

        /***********************************************************************
        
                Generate a текст представление of the документ дерево

        ***********************************************************************/
        
        final T[] выведи (Док док, T[] контент=пусто)
        {                      
                if(контент !is пусто)  
                    выведи (док.дерево, (T[][] s...)
                        {
                            т_мера i=0; 
                            foreach(t; s) 
                            { 
                                if(i+t.length >= контент.length) 
                                    throw new ИсклРЯР ("Буфер is в_ small"); 
                                
                                контент[i..t.length] = t; 
                                i+=t.length; 
                            } 
                            контент.length = i; 
                        });
                else
                    выведи (док.дерево, (T[][] s...){foreach(t; s) контент ~= t;});
                return контент;
        }
        
        /***********************************************************************
        
                Generate a текст представление of the документ дерево

        ***********************************************************************/
        
        final проц выведи (Док док, ИПотокВывода поток)
        {       
                выведи (док.дерево, (T[][] s...){foreach(t; s) поток.пиши(t);});
        }
        
        /***********************************************************************
        
                Generate a представление of the given узел-subtree 

        ***********************************************************************/
        
        final проц выведи (Узел корень, проц delegate(T[][]...) излей)
        {
                T[256] врем;
                T[256] пробелы = ' ';

                // ignore пробел из_ mixed-model значения
                T[] НеобрЗначение (Узел узел)
                {
                        foreach (c; узел.НеобрЗначение)
                                 if (c > 32)
                                     return узел.НеобрЗначение;
                        return пусто;
                }

                проц printNode (Узел узел, бцел indent)
                {
                        // проверь for cached вывод
                        if (узел.конец && быстро)
                           {
                           auto p = узел.старт;
                           auto l = узел.конец - p;
                           // nasty хак в_ retain пробел while
                           // dodging приор КонечныйЭлемент экземпляры
                           if (*p is '>')
                               ++p, --l;
                           излей (p[0 .. l]);
                           }
                        else
                        switch (узел.ид)
                               {
                               case ПТипУзлаРЯР.Документ:
                                    foreach (n; узел.ветви)
                                             printNode (n, indent);
                                    break;
        
                               case ПТипУзлаРЯР.Элемент:
                                    if (indentation > 0)
                                        излей (Кс, пробелы[0..indent]);
                                    излей ("<", узел.вТкст(врем));

                                    foreach (атр; узел.атрибуты)
                                             излей (` `, атр.вТкст(врем), `="`, атр.НеобрЗначение, `"`);  

                                    auto значение = НеобрЗначение (узел);
                                    if (узел.ветвь)
                                       {
                                       излей (">");
                                       if (значение.length)
                                           излей (значение);
                                       foreach (ветвь; узел.ветви)
                                                printNode (ветвь, indent + indentation);
                                        
                                       // inhibit нс if we're closing Данные
                                       if (узел.последнОтпрыск.ид != ПТипУзлаРЯР.Данные && indentation > 0)
                                           излей (Кс, пробелы[0..indent]);
                                       излей ("</", узел.вТкст(врем), ">");
                                       }
                                    else 
                                       if (значение.length)
                                           излей (">", значение, "</", узел.вТкст(врем), ">");
                                       else
                                          излей ("/>");      
                                    break;
        
                                    // ingore пробел данные in mixed-model
                                    // <foo>
                                    //   <bar>blah</bar>
                                    //
                                    // a пробел Данные экземпляр follows <foo>
                               case ПТипУзлаРЯР.Данные:
                                    auto значение = НеобрЗначение (узел);
                                    if (значение.length)
                                        излей (узел.НеобрЗначение);
                                    break;
        
                               case ПТипУзлаРЯР.Комментарий:
                                    излей ("<!--", узел.НеобрЗначение, "-->");
                                    break;
        
                               case ПТипУзлаРЯР.ПИ:
                                    излей ("<?", узел.НеобрЗначение, "?>");
                                    break;
        
                               case ПТипУзлаРЯР.СиДанные:
                                    излей ("<![CDATA[", узел.НеобрЗначение, "]]>");
                                    break;
        
                               case ПТипУзлаРЯР.Доктип:
                                    излей ("<!DOCTYPE ", узел.НеобрЗначение, ">");
                                    break;

                               default:
                                    излей ("<!-- узел неизвестного типа -->");
                                    break;
                               }
                }
        
                printNode (корень, 0);
        }
}


debug import text.xml.Document;
debug import util.log.Trace;

unittest
{

    ткст документ = "<blah><xml>foo</xml></blah>";

    auto док = new Документ!(сим);
    док.разбор (документ);

    auto p = new ДокПринтер!(сим);
    сим[1024] буф;
    auto newbuf = p.выведи (док, буф);
    assert(документ == newbuf);
    assert(буф.ptr == newbuf.ptr);
    assert(документ == p.выведи(док));
    

}
