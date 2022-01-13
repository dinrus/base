module tpl.all;

public import	    // tpl.args,
					tpl.alloc,
					tpl.com,
					//tpl.stream,
					tpl.collection,
					tpl.handles,					
					tpl.signal,
					tpl.metastrings,
					tpl.traits,
					tpl.typetuple,
					tpl.bind,
					tpl.minmax,
					tpl.box,
					tpl.singleton,
					 tpl.weakref
					 ;
					 
version(COM)
{
public import tpl.com;// Импортируется отдельно, если COM нужен.
}