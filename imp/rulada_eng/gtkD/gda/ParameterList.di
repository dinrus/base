/*
 * This file is part of gtkD.
 *
 * gtkD is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * gtkD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with gtkD; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
// generated automatically - do not change
// find conversion definition on APILookup.txt
// implement new conversion functionalities on the wrap.utils pakage

/*
 * Conversion parameters:
 * inFile  = 
 * outPack = gda
 * outFile = ParameterList
 * strct   = GdaParameterList
 * realStrct=
 * ctorStrct=
 * clss    = ParameterList
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gda_parameter_list_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ListG
 * 	- gtkD.gda.Parameter
 * structWrap:
 * 	- GList* -> ListG
 * 	- GdaParameter* -> Parameter
 * 	- GdaParameterList* -> ParameterList
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gda.ParameterList;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gda.Parameter;




/**
 * Description
 *  Parameters are the way clients have to send an unlimited number
 *  of arguments to the providers.
 */
public class ParameterList
{
	
	/** the main Gtk struct */
	protected GdaParameterList* gdaParameterList;
	
	
	public GdaParameterList* getParameterListStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaParameterList* gdaParameterList);
	
	/**
	 */
	
	/**
	 * Returns:
	 */
	public static GType getType();
	
	/**
	 * Creates a new GdaParameterList.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Releases all memory occupied by the given GdaParameterList.
	 */
	public void free();
	
	/**
	 * Creates a new GdaParameterList from an existing one.
	 * Returns: a newly allocated GdaParameterList with a copy of the data in plist.
	 */
	public ParameterList copy();
	
	/**
	 * Adds a new parameter to the given GdaParameterList. Note that param is,
	 * when calling this function, is owned by the GdaParameterList, so the
	 * caller should just forget about it and not try to free the parameter once
	 * it's been added to the GdaParameterList.
	 * Params:
	 * param =  the GdaParameter to be added to the list.
	 */
	public void addParameter(Parameter param);
	
	/**
	 * Gets the names of all parameters in the parameter list.
	 * Returns: a GList containing the names of the parameters. Afterusing it, you should free this list by calling g_list_free.
	 */
	public ListG getNames();
	
	/**
	 * Gets a GdaParameter from the parameter list given its name.
	 * Params:
	 * name =  name of the parameter to search for.
	 * Returns: the GdaParameter identified by name, if found, or NULLif not found.
	 */
	public Parameter find(string name);
	
	/**
	 * Clears the parameter list. This means removing all GdaParameter's currently
	 * being stored in the parameter list. After calling this function,
	 * the parameter list is empty.
	 */
	public void clear();
	
	/**
	 * Returns: the number of parameters stored in the given parameter list.
	 */
	public uint getLength();
}
