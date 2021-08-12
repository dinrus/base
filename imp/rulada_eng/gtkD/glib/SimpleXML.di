module gtkD.glib.SimpleXML;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ListSG;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.Str;




/**
 * Description
 * The "GMarkup" parser is intended to parse a simple markup format
 * that's a subset of XML. This is a small, efficient, easy-to-use
 * parser. It should not be used if you expect to interoperate with other
 * applications generating full-scale XML. However, it's very useful for
 * application data files, config files, etc. where you know your
 * application will be the only one writing the file. Full-scale XML
 * parsers should be able to parse the subset used by GMarkup, so you can
 * easily migrate to full-scale XML at a later time if the need arises.
 * GMarkup is not guaranteed to signal an error on all invalid XML; the
 * parser may accept documents that an XML parser would not. However, XML
 * documents which are not well-formed[5] are not considered valid GMarkup
 * documents.
 * Simplifications to XML include:
 * Only UTF-8 encoding is allowed.
 * No user-defined entities.
 * Processing instructions, comments and the doctype declaration are "passed
 * through" but are not interpreted in any way.
 * No DTD or validation.
 * The markup format does support:
 * Elements
 * Attributes
 * 5 standard entities: amp; lt; gt; quot; apos;
 * Character references
 * Sections marked as CDATA
 */
public class SimpleXML
{
	
	/** the main Gtk struct */
	protected GMarkupParseContext* gMarkupParseContext;
	
	
	public GMarkupParseContext* getSimpleXMLStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GMarkupParseContext* gMarkupParseContext);
	
	/**
	 */
	
	/**
	 * Escapes text so that the markup parser will parse it verbatim.
	 * Less than, greater than, ampersand, etc. are replaced with the
	 * corresponding entities. This function would typically be used
	 * when writing out a file to be parsed with the markup parser.
	 * Note that this function doesn't protect whitespace and line endings
	 * from being processed according to the XML rules for normalization
	 * of line endings and attribute values.
	 * Note also that if given a string containing them, this function
	 * will produce character references in the range of x1; ..
	 * x1f; for all control sequences except for tabstop, newline
	 * and carriage return. The character references in this range are
	 * not valid XML 1.0, but they are valid XML 1.1 and will be accepted
	 * by the GMarkup parser.
	 * Params:
	 * text =  some valid UTF-8 text
	 * length =  length of text in bytes, or -1 if the text is nul-terminated
	 * Returns: a newly allocated string with the escaped text
	 */
	public static string escapeText(string text, int length);
	
	/**
	 * Formats the data in args according to format, escaping
	 * all string and character arguments in the fashion
	 * of g_markup_escape_text(). See g_markup_printf_escaped().
	 * Since 2.4
	 * Params:
	 * format =  printf() style format string
	 * args =  variable argument list, similar to vprintf()
	 * Returns: newly allocated result from formatting operation. Free with g_free().
	 */
	public static string vprintfEscaped(string format, void* args);
	
	/**
	 * Signals to the GMarkupParseContext that all data has been
	 * fed into the parse context with g_markup_parse_context_parse().
	 * This function reports an error if the document isn't complete,
	 * for example if elements are still open.
	 * Returns: TRUE on success, FALSE if an error was set
	 * Throws: GException on failure.
	 */
	public int endParse();
	
	/**
	 * Frees a GMarkupParseContext. Can't be called from inside
	 * one of the GMarkupParser functions. Can't be called while
	 * a subparser is pushed.
	 */
	public void free();
	
	/**
	 * Retrieves the current line number and the number of the character on
	 * that line. Intended for use in error messages; there are no strict
	 * semantics for what constitutes the "current" line number other than
	 * "the best number we could come up with for error messages."
	 * Params:
	 * lineNumber =  return location for a line number, or NULL
	 * charNumber =  return location for a char-on-line number, or NULL
	 */
	public void getPosition(out int lineNumber, out int charNumber);
	
	/**
	 * Retrieves the name of the currently open element.
	 * If called from the start_element or end_element handlers this will
	 * give the element_name as passed to those functions. For the parent
	 * elements, see g_markup_parse_context_get_element_stack().
	 * Since 2.2
	 * Returns: the name of the currently open element, or NULL
	 */
	public string getElement();
	
	/**
	 * Retrieves the element stack from the internal state of the parser.
	 * The returned GSList is a list of strings where the first item is
	 * the currently open tag (as would be returned by
	 * g_markup_parse_context_get_element()) and the next item is its
	 * immediate parent.
	 * This function is intended to be used in the start_element and
	 * end_element handlers where g_markup_parse_context_get_element()
	 * would merely return the name of the element that is being
	 * processed.
	 * Since 2.16
	 * Returns: the element stack, which must not be modified
	 */
	public ListSG getElementStack();
	
	/**
	 * Returns the user_data associated with context. This will either
	 * be the user_data that was provided to g_markup_parse_context_new()
	 * or to the most recent call of g_markup_parse_context_push().
	 * Since 2.18
	 * Returns: the provided user_data. The returned data belongs to the markup context and will be freed when g_markup_context_free() is called.
	 */
	public void* getUserData();
	
	/**
	 * Creates a new parse context. A parse context is used to parse
	 * marked-up documents. You can feed any number of documents into
	 * a context, as long as no errors occur; once an error occurs,
	 * the parse context can't continue to parse text (you have to free it
	 * and create a new parse context).
	 * Params:
	 * parser =  a GMarkupParser
	 * flags =  one or more GMarkupParseFlags
	 * userData =  user data to pass to GMarkupParser functions
	 * userDataDnotify =  user data destroy notifier called when the parse context is freed
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GMarkupParser* parser, GMarkupParseFlags flags, void* userData, GDestroyNotify userDataDnotify);
	
	/**
	 * Feed some data to the GMarkupParseContext. The data need not
	 * be valid UTF-8; an error will be signaled if it's invalid.
	 * The data need not be an entire document; you can feed a document
	 * into the parser incrementally, via multiple calls to this function.
	 * Typically, as you receive data from a network connection or file,
	 * you feed each received chunk of data into this function, aborting
	 * the process if an error occurs. Once an error is reported, no further
	 * data may be fed to the GMarkupParseContext; all errors are fatal.
	 * Params:
	 * text =  chunk of text to parse
	 * textLen =  length of text in bytes
	 * Returns: FALSE if an error occurred, TRUE on success
	 * Throws: GException on failure.
	 */
	public int parse(string text, int textLen);
	
	/**
	 * Temporarily redirects markup data to a sub-parser.
	 * This function may only be called from the start_element handler of
	 * a GMarkupParser. It must be matched with a corresponding call to
	 * g_markup_parse_context_pop() in the matching end_element handler
	 * (except in the case that the parser aborts due to an error).
	 * All tags, text and other data between the matching tags is
	 * redirected to the subparser given by parser. user_data is used
	 * as the user_data for that parser. user_data is also passed to the
	 * error callback in the event that an error occurs. This includes
	 * errors that occur in subparsers of the subparser.
	 * The end tag matching the start tag for which this call was made is
	 * handled by the previous parser (which is given its own user_data)
	 * which is why g_markup_parse_context_pop() is provided to allow "one
	 * last access" to the user_data provided to this function. In the
	 * case of error, the user_data provided here is passed directly to
	 * the error callback of the subparser and g_markup_parse_context()
	 * should not be called. In either case, if user_data was allocated
	 * then it ought to be freed from both of these locations.
	 * This function is not intended to be directly called by users
	 * interested in invoking subparsers. Instead, it is intended to be
	 * used by the subparsers themselves to implement a higher-level
	 * interface.
	 * As an example, see the following implementation of a simple
	 * parser that counts the number of tags encountered.
	 * typedef struct
	 * {
		 *  gint tag_count;
	 * } CounterData;
	 * static void
	 * counter_start_element (GMarkupParseContext *context,
	 *  const gchar *element_name,
	 *  const gchar **attribute_names,
	 *  const gchar **attribute_values,
	 *  gpointer user_data,
	 *  GError **error)
	 * {
		 *  CounterData *data = user_data;
		 *  data->tag_count++;
	 * }
	 * static void
	 * counter_error (GMarkupParseContext *context,
	 *  GError *error,
	 *  gpointer user_data)
	 * {
		 *  CounterData *data = user_data;
		 *  g_slice_free (CounterData, data);
	 * }
	 * static GMarkupParser counter_subparser =
	 * {
		 *  counter_start_element,
		 *  NULL,
		 *  NULL,
		 *  NULL,
		 *  counter_error
	 * };
	 * In order to allow this parser to be easily used as a subparser, the
	 * Since 2.18
	 * Params:
	 * parser =  a GMarkupParser
	 * userData =  user data to pass to GMarkupParser functions
	 */
	public void push(GMarkupParser* parser, void* userData);
	
	/**
	 * Completes the process of a temporary sub-parser redirection.
	 * This function exists to collect the user_data allocated by a
	 * matching call to g_markup_parse_context_push(). It must be called
	 * in the end_element handler corresponding to the start_element
	 * handler during which g_markup_parse_context_push() was called. You
	 * must not call this function from the error callback -- the
	 * user_data is provided directly to the callback in that case.
	 * This function is not intended to be directly called by users
	 * interested in invoking subparsers. Instead, it is intended to be
	 * used by the subparsers themselves to implement a higher-level
	 * interface.
	 * Since 2.18
	 * Returns: the user_data passed to g_markup_parse_context_push().
	 */
	public void* pop();
}
