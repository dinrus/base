

module gtkD.gtk.Builder;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gobject.ObjectG;
private import gtkD.gobject.ParamSpec;
private import gtkD.gobject.Value;
private import gtkD.glib.ListSG;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gtkc.gobject;
private import gtkD.gtkc.paths;
private import gtkD.glib.Module;
private import gtkD.gobject.Type;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * A GtkBuilder is an auxiliary object that reads textual descriptions
 * of a user interface and instantiates the described objects. To pass a
 * description to a GtkBuilder, call gtk_builder_add_from_file() or
 * gtk_builder_add_from_string(). These functions can be called multiple
 * times; the builder merges the content of all descriptions.
 * A GtkBuilder holds a reference to all objects that it has constructed
 * and drops these references when it is finalized. This finalization can
 * cause the destruction of non-widget objects or widgets which are not
 * contained in a toplevel window. For toplevel windows constructed by a
 * builder, it is the responsibility of the user to call gtk_widget_destroy()
 * to get rid of them and all the widgets they contain.
 * The functions gtk_builder_get_object() and gtk_builder_get_objects()
 * can be used to access the widgets in the interface by the names assigned
 * to them inside the UI description. Toplevel windows returned by these
 * functions will stay around until the user explicitly destroys them
 * with gtk_widget_destroy(). Other widgets will either be part of a
 * larger hierarchy constructed by the builder (in which case you should
 * not have to worry about their lifecycle), or without a parent, in which
 * case they have to be added to some container to make use of them.
 * Non-widget objects need to be reffed with g_object_ref() to keep them
 * beyond the lifespan of the builder.
 * The function gtk_builder_connect_signals() and variants thereof can be
 * used to connect handlers to the named signals in the description.
 * GtkBuilder UI Definitions
 * GtkBuilder parses textual descriptions of user interfaces which
 * are specified in an XML format which can be roughly described
 * by the DTD below. We refer to these descriptions as
 * GtkBuilder UI definitions or just
 * UI definitions if the context is clear.
 * Do not confuse GtkBuilder UI Definitions with
 * GtkUIManager UI Definitions,
 * which are more limited in scope.
 * <!ELEMENT interface (requires|object)* >
 * <!ELEMENT object (property|signal|child|ANY)* >
 * <!ELEMENT property PCDATA >
 * <!ELEMENT signal EMPTY >
 * <!ELEMENT requires EMPTY >
 * <!ELEMENT child (object|ANY*) >
 * <!ATTLIST interface domain 	 #IMPLIED >
 * <!ATTLIST object id 	 #REQUIRED
 *  class 	 #REQUIRED
 *  type-func 	 #IMPLIED
 *  constructor 	 #IMPLIED >
 * <!ATTLIST requires lib 	 #REQUIRED
 *  version 	 #REQUIRED >
 * <!ATTLIST property name 	 #REQUIRED
 *  translatable 	 #IMPLIED
 *  comments #IMPLIED
 *  context #IMPLIED >
 * <!ATTLIST signal name 	 #REQUIRED
 *  handler 	 #REQUIRED
 *  after 	 #IMPLIED
 *  swapped 	 #IMPLIED
 *  object 	 #IMPLIED
 *  last_modification_time #IMPLIED >
 * <!ATTLIST child type 	 #IMPLIED
 *  internal-child 	 #IMPLIED >
 * The toplevel element is <interface>.
 * It optionally takes a "domain" attribute, which will make
 * the builder look for translated strings using dgettext() in the
 * domain specified. This can also be done by calling
 * gtk_builder_set_translation_domain() on the builder.
 * Objects are described by <object> elements, which can
 * contain <property> elements to set properties, <signal>
 * elements which connect signals to handlers, and <child>
 * elements, which describe child objects (most often widgets
 * inside a container, but also e.g. actions in an action group,
 * or columns in a tree model). A <child> element contains
 * an <object> element which describes the child object.
 * The target toolkit version(s) are described by <requires>
 * elements, the "lib" attribute specifies the widget library in
 * question (currently the only supported value is "gtk+") and the "version"
 * attribute specifies the target version in the form "<major>.<minor>".
 * The builder will error out if the version requirements are not met.
 * Typically, the specific kind of object represented by an
 * <object> element is specified by the "class" attribute.
 * If the type has not been loaded yet, GTK+ tries to find the
 * _get_type() from the class name by applying
 * heuristics. This works in most cases, but if necessary, it is
 * possible to specify the name of the _get_type()
 * explictly with the "type-func" attribute. As a special case,
 * GtkBuilder allows to use an object that has been constructed
 * by a GtkUIManager in another part of the UI definition by
 * specifying the id of the GtkUIManager in the "constructor"
 * attribute and the name of the object in the "id" attribute.
 * Objects must be given a name with the "id" attribute, which
 * allows the application to retrieve them from the builder with
 * gtk_builder_get_object(). An id is also necessary to use the
 * object as property value in other parts of the UI definition.
 * Setting properties of objects is pretty straightforward with
 * the <property> element: the "name" attribute specifies
 * the name of the property, and the content of the element
 * specifies the value. If the "translatable" attribute is
 * set to a true value, GTK+ uses gettext() (or dgettext() if
 * the builder has a translation domain set) to find a translation
 * for the value. This happens before the value is parsed, so
 * it can be used for properties of any type, but it is probably
 * most useful for string properties. It is also possible to
 * specify a context to disambiguate short strings, and comments
 * which may help the translators.
 * GtkBuilder can parse textual representations for the most
 * common property types: characters, strings, integers, floating-point
 * numbers, booleans (strings like "TRUE", "t", "yes", "y", "1" are
 * interpreted as TRUE, strings like "FALSE, "f", "no", "n", "0" are
 * interpreted as FALSE), enumerations (can be specified by their
 * name, nick or integer value), flags (can be specified by their name,
 * nick, integer value, optionally combined with "|", e.g.
 * "GTK_VISIBLE|GTK_REALIZED") and colors (in a format understood by
 * gdk_color_parse()). Objects can be referred to by their name.
 * Pixbufs can be specified as a filename of an image file to load.
 * In general, GtkBuilder allows forward references to objects —
 * an object doesn't have to constructed before it can be referred to.
 * The exception to this rule is that an object has to be constructed
 * before it can be used as the value of a construct-only property.
 * Signal handlers are set up with the <signal> element.
 * The "name" attribute specifies the name of the signal, and the
 * "handler" attribute specifies the function to connect to the signal.
 * By default, GTK+ tries to find the handler using g_module_symbol(),
 * but this can be changed by passing a custom GtkBuilderConnectFunc
 * to gtk_builder_connect_signals_full(). The remaining attributes,
 * "after", "swapped" and "object", have the same meaning as the
 * corresponding parameters of the g_signal_connect_object() or
 * g_signal_connect_data() functions. A "last_modification_time" attribute
 * is also allowed, but it does not have a meaning to the builder.
 * Sometimes it is necessary to refer to widgets which have implicitly
 * been constructed by GTK+ as part of a composite widget, to set
 * properties on them or to add further children (e.g. the vbox
 * of a GtkDialog). This can be achieved by setting the "internal-child"
 * propery of the <child> element to a true value. Note that
 * GtkBuilder still requires an <object> element for the internal
 * child, even if it has already been constructed.
 * A number of widgets have different places where a child can be
 * added (e.g. tabs vs. page content in notebooks). This can be reflected
 * in a UI definition by specifying the "type" attribute on a <child>
 * The possible values for the "type" attribute are described in
 * the sections describing the widget-specific portions of UI definitions.
 * Example 58. A GtkBuilder UI Definition
 * <interface>
 *  <object class="GtkDialog" id="dialog1">
 *  <child internal-child="vbox">
 *  <object class="GtkVBox" id="vbox1">
 *  <property name="border-width">10</property>
 *  <child internal-child="action_area">
 *  <object class="GtkHButtonBox" id="hbuttonbox1">
 *  <property name="border-width">20</property>
 *  <child>
 *  <object class="GtkButton" id="ok_button">
 *  <property name="label">gtk-ok</property>
 *  <property name="use-stock">TRUE</property>
 *  <signal name="clicked" handler="ok_button_clicked"/>
 *  </object>
 *  </child>
 *  </object>
 *  </child>
 *  </object>
 *  </child>
 *  </object>
 * </interface>
 * Beyond this general structure, several object classes define
 * their own XML DTD fragments for filling in the ANY placeholders
 * in the DTD above. Note that a custom element in a <child>
 * element gets parsed by the custom tag handler of the parent
 * object, while a custom element in an <object> element
 * gets parsed by the custom tag handler of the object.
 * These XML fragments are explained in the documentation of the
 * respective objects, see
 * GtkWidget,
 * GtkLabel,
 * GtkWindow,
 * GtkContainer,
 * GtkDialog,
 * GtkCellLayout,
 * GtkColorSelectionDialog,
 * GtkFontSelectionDialog,
 * GtkComboBoxEntry,
 * GtkExpander,
 * GtkFrame,
 * GtkListStore,
 * GtkTreeStore,
 * GtkNotebook,
 * GtkSizeGroup,
 * GtkTreeView,
 * GtkUIManager,
 * GtkActionGroup.
 * GtkMenuItem,
 * GtkAssistant,
 * GtkScale.
 */
public class Builder : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkBuilder* gtkBuilder;
	
	
	public GtkBuilder* getBuilderStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkBuilder* gtkBuilder);
	
	private struct GtkBuilderClass
	{
		GObjectClass parentClass;
		extern(C) GType function( GtkBuilder*, char* ) get_type_from_name;
		
		/* Padding for future expansion */
		extern(C) void  function()  _gtk_reserved1;
		extern(C) void  function()  _gtk_reserved2;
		extern(C) void  function()  _gtk_reserved3;
		extern(C) void  function()  _gtk_reserved4;
		extern(C) void  function()  _gtk_reserved5;
		extern(C) void  function()  _gtk_reserved6;
		extern(C) void  function()  _gtk_reserved7;
		extern(C) void  function()  _gtk_reserved8;
	}
	
	/**
	 * Creates a new builder object.
	 * Since 2.12
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * This function is a modification of _gtk_builder_resolve_type_lazily from "gtk/gtkbuilder.c".
	 * It is needed because it assumes we are linking at compile time to the gtk libs.
	 * specifically the NULL in g_module_open( NULL, 0 );
	 * It replaces the default function pointer "get_type_from_name" in GtkBuilderClass.
	 */
	extern(C) private static GType gtk_builder_real_get_type_from_name_override ( GtkBuilder* builder, char *name );
	
	/**
	 */
	
	/**
	 * Parses a file containing a GtkBuilder
	 * UI definition and merges it with the current contents of builder.
	 * Since 2.12
	 * Params:
	 * filename =  the name of the file to parse
	 * Returns: A positive value on success, 0 if an error occurred
	 * Throws: GException on failure.
	 */
	public uint addFromFile(string filename);
	
	/**
	 * Parses a string containing a GtkBuilder
	 * UI definition and merges it with the current contents of builder.
	 * Since 2.12
	 * Params:
	 * buffer =  the string to parse
	 * length =  the length of buffer (may be -1 if buffer is nul-terminated)
	 * Returns: A positive value on success, 0 if an error occurred
	 * Throws: GException on failure.
	 */
	public uint addFromString(string buffer, uint length);
	
	/**
	 * Parses a file containing a GtkBuilder
	 * UI definition building only the requested objects and merges
	 * them with the current contents of builder.
	 * Note
	 * If you are adding an object that depends on an object that is not
	 * its child (for instance a GtkTreeView that depends on its
	 * GtkTreeModel), you have to explicitely list all of them in object_ids.
	 * Since 2.14
	 * Params:
	 * filename =  the name of the file to parse
	 * objectIds =  nul-terminated array of objects to build
	 * Returns: A positive value on success, 0 if an error occurred
	 * Throws: GException on failure.
	 */
	public uint addObjectsFromFile(string filename, string[] objectIds);
	
	/**
	 * Parses a string containing a GtkBuilder
	 * UI definition building only the requested objects and merges
	 * them with the current contents of builder.
	 * Note
	 * If you are adding an object that depends on an object that is not
	 * its child (for instance a GtkTreeView that depends on its
	 * GtkTreeModel), you have to explicitely list all of them in object_ids.
	 * Since 2.14
	 * Params:
	 * buffer =  the string to parse
	 * length =  the length of buffer (may be -1 if buffer is nul-terminated)
	 * objectIds =  nul-terminated array of objects to build
	 * Returns: A positive value on success, 0 if an error occurred
	 * Throws: GException on failure.
	 */
	public uint addObjectsFromString(string buffer, uint length, string[] objectIds);
	
	/**
	 * Gets the object named name. Note that this function does not
	 * increment the reference count of the returned object.
	 * Since 2.12
	 * Params:
	 * name =  name of object to get
	 * Returns: the object named name or NULL if it could not be  found in the object tree.
	 */
	public ObjectG getObject(string name);
	
	/**
	 * Gets all objects that have been constructed by builder. Note that
	 * this function does not increment the reference counts of the returned
	 * objects.
	 * Since 2.12
	 * Returns: a newly-allocated GSList containing all the objects constructed by the GtkBuilder instance. It should be freed by g_slist_free()
	 */
	public ListSG getObjects();
	
	/**
	 * This method is a simpler variation of gtk_builder_connect_signals_full().
	 * It uses GModule's introspective features (by opening the module NULL)
	 * to look at the application's symbol table. From here it tries to match
	 * the signal handler names given in the interface description with
	 * symbols in the application and connects the signals.
	 * Note that this function will not work correctly if GModule is not
	 * supported on the platform.
	 * When compiling applications for Windows, you must declare signal callbacks
	 * with G_MODULE_EXPORT, or they will not be put in the symbol table.
	 * On Linux and Unices, this is not necessary; applications should instead
	 * be compiled with the -Wl,--export-dynamic CFLAGS, and linked against
	 * gmodule-export-2.0.
	 * Since 2.12
	 * Params:
	 * userData =  a pointer to a structure sent in as user data to all signals
	 */
	public void connectSignals(void* userData);
	
	/**
	 * This function can be thought of the interpreted language binding
	 * version of gtk_builder_connect_signals(), except that it does not
	 * require GModule to function correctly.
	 * Since 2.12
	 * Params:
	 * func =  the function used to connect the signals
	 * userData =  arbitrary data that will be passed to the connection function
	 */
	public void connectSignalsFull(GtkBuilderConnectFunc func, void* userData);
	
	/**
	 * Sets the translation domain of builder.
	 * See "translation-domain".
	 * Since 2.12
	 * Params:
	 * domain =  the translation domain or NULL
	 */
	public void setTranslationDomain(string domain);
	
	/**
	 * Gets the translation domain of builder.
	 * Since 2.12
	 * Returns: the translation domain. This string is ownedby the builder object and must not be modified or freed.
	 */
	public string getTranslationDomain();
	
	/**
	 * Looks up a type by name, using the virtual function that
	 * GtkBuilder has for that purpose. This is mainly used when
	 * implementing the GtkBuildable interface on a type.
	 * Since 2.12
	 * Params:
	 * typeName =  type name to lookup
	 * Returns: the GType found for type_name or G_TYPE_INVALID  if no type was found
	 */
	public GType getTypeFromName(string typeName);
	
	/**
	 * This function demarshals a value from a string. This function
	 * calls g_value_init() on the value argument, so it need not be
	 * initialised beforehand.
	 * This function can handle char, uchar, boolean, int, uint, long,
	 * ulong, enum, flags, float, double, string, GdkColor and
	 * GtkAdjustment type values. Support for GtkWidget type values is
	 * still to come.
	 * Since 2.12
	 * Params:
	 * pspec =  the GParamSpec for the property
	 * string =  the string representation of the value
	 * value =  the GValue to store the result in
	 * Returns: TRUE on success
	 * Throws: GException on failure.
	 */
	public int valueFromString(ParamSpec pspec, string string, Value value);
	
	/**
	 * Like gtk_builder_value_from_string(), this function demarshals
	 * a value from a string, but takes a GType instead of GParamSpec.
	 * This function calls g_value_init() on the value argument, so it
	 * need not be initialised beforehand.
	 * Since 2.12
	 * Params:
	 * type =  the GType of the value
	 * string =  the string representation of the value
	 * value =  the GValue to store the result in
	 * Returns: TRUE on success
	 * Throws: GException on failure.
	 */
	public int valueFromStringType(GType type, string string, Value value);
}