module gtkD.gio.FileAttributeMatcher;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * Functionality for manipulating basic metadata for files. GFileInfo
 * implements methods for getting information that all files should
 * contain, and allows for manipulation of extended attributes.
 * See GFileAttribute for more
 * information on how GIO handles file attributes.
 * To obtain a GFileInfo for a GFile, use g_file_query_info() (or its
 * async variant). To obtain a GFileInfo for a file input or output
 * stream, use g_file_input_stream_query_info() or
 * g_file_output_stream_query_info() (or their async variants).
 * To change the actual attributes of a file, you should then set the
 * attribute in the GFileInfo and call g_file_set_attributes_from_info()
 * or g_file_set_attributes_async() on a GFile.
 * However, not all attributes can be changed in the file. For instance,
 * the actual size of a file cannot be changed via g_file_info_set_size().
 * You may call g_file_query_settable_attributes() and
 * g_file_query_writable_namespaces() to discover the settable attributes
 * of a particular file at runtime.
 * GFileAttributeMatcher allows for searching through a GFileInfo for
 * attributes.
 */
public class FileAttributeMatcher
{
	
	/** the main Gtk struct */
	protected GFileAttributeMatcher* gFileAttributeMatcher;
	
	
	public GFileAttributeMatcher* getFileAttributeMatcherStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GFileAttributeMatcher* gFileAttributeMatcher);
	
	/**
	 */
	
	/**
	 * Creates a new file attribute matcher, which matches attributes
	 * against a given string. GFileAttributeMatchers are reference
	 * counted structures, and are created with a reference count of 1. If
	 * the number of references falls to 0, the GFileAttributeMatcher is
	 * automatically destroyed.
	 * The attribute string should be formatted with specific keys separated
	 * from namespaces with a double colon. Several "namespace::key" strings may be
	 * concatenated with a single comma (e.g. "standard::type,standard::is-hidden").
	 * The wildcard "*" may be used to match all keys and namespaces, or
	 * "namespace::*" will match all keys in a given namespace.
	 * Params:
	 * attributes =  an attribute string to match.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string attributes);
	
	/**
	 * References a file attribute matcher.
	 * Returns: a GFileAttributeMatcher.
	 */
	public FileAttributeMatcher doref();
	/**
	 * Unreferences matcher. If the reference count falls below 1,
	 * the matcher is automatically freed.
	 */
	public void unref();
	
	/**
	 * Checks if an attribute will be matched by an attribute matcher. If
	 * the matcher was created with the "*" matching string, this function
	 * will always return TRUE.
	 * Params:
	 * attribute =  a file attribute key.
	 * Returns: TRUE if attribute matches matcher. FALSE otherwise.
	 */
	public int matches(string attribute);
	
	/**
	 * Checks if a attribute matcher only matches a given attribute. Always
	 * returns FALSE if "*" was used when creating the matcher.
	 * Params:
	 * attribute =  a file attribute key.
	 * Returns: TRUE if the matcher only matches attribute. FALSE otherwise.
	 */
	public int matchesOnly(string attribute);
	
	/**
	 * Checks if the matcher will match all of the keys in a given namespace.
	 * This will always return TRUE if a wildcard character is in use (e.g. if
	 * matcher was created with "standard::*" and ns is "standard", or if matcher was created
	 * using "*" and namespace is anything.)
	 * TODO: this is awkwardly worded.
	 * Params:
	 * ns =  a string containing a file attribute namespace.
	 * Returns: TRUE if the matcher matches all of the entriesin the given ns, FALSE otherwise.
	 */
	public int enumerateNamespace(string ns);
	
	/**
	 * Gets the next matched attribute from a GFileAttributeMatcher.
	 * Returns: a string containing the next attribute or NULL if no more attribute exist.
	 */
	public string enumerateNext();
}
