module gtkD.pango.PgMiscellaneous;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.StringG;
private import gtkD.pango.PgLanguage;

private import cidrus;




/**
 * Description
 * The functions and utilities in this section are mostly used from Pango
 * backends and modules, but may be useful for other purposes too.
 */
public class PgMiscellaneous
{

	/**
	 */

	/**
	 * Splits a G_SEARCHPATH_SEPARATOR-separated list of files, stripping
	 * white space and substituting ~/ with $HOME/.
	 * Params:
	 * str =  a G_SEARCHPATH_SEPARATOR separated list of filenames
	 * Returns: a list of strings to be freed with g_strfreev()
	 */
	public static string[] splitFileList(string str);

	/**
	 * Trims leading and trailing whitespace from a string.
	 * Params:
	 * str =  a string
	 * Returns: A newly-allocated string that must be freed with g_free()
	 */
	public static string trimString(string str);

	/**
	 * Reads an entire line from a file into a buffer. Lines may
	 * be delimited with '\n', '\r', '\n\r', or '\r\n'. The delimiter
	 * is not written into the buffer. Text after a '#' character is treated as
	 * a comment and skipped. '\' can be used to escape a # character.
	 * '\' proceeding a line delimiter combines adjacent lines. A '\' proceeding
	 * any other character is ignored and written into the output buffer
	 * unmodified.
	 * Params:
	 * stream =  a stdio stream
	 * str =  GString buffer into which to write the result
	 * Returns: 0 if the stream was already at an EOF character, otherwise the number of lines read (this is useful for maintaining a line number counter which doesn't combine lines with '\')
	 */
	public static int readLine(FILE* stream, StringG str);

	/**
	 * Skips 0 or more characters of white space.
	 * Params:
	 * pos =  in/out string position
	 * Returns: FALSE if skipping the white space leavesthe position at a '\0' character.
	 */
	public static int skipSpace(inout string pos);

	/**
	 * Scans a word into a GString buffer. A word consists
	 * of [A-Za-z_] followed by zero or more [A-Za-z_0-9]
	 * Leading white space is skipped.
	 * Params:
	 * pos =  in/out string position
	 * out =  a GString into which to write the result
	 * Returns: FALSE if a parse error occurred.
	 */
	public static int scanWord(inout string pos, StringG f_out);

	/**
	 * Scans a string into a GString buffer. The string may either
	 * be a sequence of non-white-space characters, or a quoted
	 * string with '"'. Instead a quoted string, '\"' represents
	 * a literal quote. Leading white space outside of quotes is skipped.
	 * Params:
	 * pos =  in/out string position
	 * out =  a GString into which to write the result
	 * Returns: FALSE if a parse error occurred.
	 */
	public static int scanString(inout string pos, StringG f_out);

	/**
	 * Scans an integer.
	 * Leading white space is skipped.
	 * Params:
	 * pos =  in/out string position
	 * out =  an int into which to write the result
	 * Returns: FALSE if a parse error occurred.
	 */
	public static int scanInt(inout string pos, out int f_out);

	/**
	 * Looks up a key in the Pango config database
	 * (pseudo-win.ini style, read from $sysconfdir/pango/pangorc,
	 *  ~/.pangorc, and getenv (PANGO_RC_FILE).)
	 * Params:
	 * key =  Key to look up, in the form "SECTION/KEY".
	 * Returns: the value, if found, otherwise NULL. The value is anewly-allocated string and must be freed with g_free().
	 */
	public static string configKeyGet(string key);

	/**
	 * Look up all user defined aliases for the alias fontname.
	 * The resulting font family names will be stored in families,
	 * and the number of families in n_families.
	 * Params:
	 * fontname =  an ascii string
	 * families =  will be set to an array of font family names.
	 *  this array is owned by pango and should not be freed.
	 */
	public static void lookupAliases(string fontname, out string[] families);

	/**
	 * Parses an enum type and stores the result in value.
	 * If str does not match the nick name of any of the possible values for the
	 * enum and is not an integer, FALSE is returned, a warning is issued
	 * if warn is TRUE, and a
	 * string representing the list of possible values is stored in
	 * possible_values. The list is slash-separated, eg.
	 * "none/start/middle/end". If failed and possible_values is not NULL,
	 * returned string should be freed using g_free().
	 * Since 1.16
	 * Params:
	 * type =  enum type to parse, eg. PANGO_TYPE_ELLIPSIZE_MODE.
	 * str =  string to parse. May be NULL.
	 * value =  integer to store the result in, or NULL.
	 * warn =  if TRUE, issue a g_warning() on bad input.
	 * possibleValues =  place to store list of possible values on failure, or NULL.
	 * Returns: TRUE if str was successfully parsed.
	 */
	public static int parseEnum(GType type, string str, out int value, int warn, out string possibleValues);

	/**
	 * Parses a font style. The allowed values are "normal",
	 * "italic" and "oblique", case variations being
	 * ignored.
	 * Params:
	 * str =  a string to parse.
	 * style =  a PangoStyle to store the result in.
	 * warn =  if TRUE, issue a g_warning() on bad input.
	 * Returns: TRUE if str was successfully parsed.
	 */
	public static int parseStyle(string str, out PangoStyle style, int warn);

	/**
	 * Parses a font variant. The allowed values are "normal"
	 * and "smallcaps" or "small_caps", case variations being
	 * ignored.
	 * Params:
	 * str =  a string to parse.
	 * variant =  a PangoVariant to store the result in.
	 * warn =  if TRUE, issue a g_warning() on bad input.
	 * Returns: TRUE if str was successfully parsed.
	 */
	public static int parseVariant(string str, out PangoVariant variant, int warn);

	/**
	 * Parses a font weight. The allowed values are "heavy",
	 * "ultrabold", "bold", "normal", "light", "ultraleight"
	 * and integers. Case variations are ignored.
	 * Params:
	 * str =  a string to parse.
	 * weight =  a PangoWeight to store the result in.
	 * warn =  if TRUE, issue a g_warning() on bad input.
	 * Returns: TRUE if str was successfully parsed.
	 */
	public static int parseWeight(string str, out PangoWeight weight, int warn);

	/**
	 * Parses a font stretch. The allowed values are
	 * "ultra_condensed", "extra_condensed", "condensed",
	 * "semi_condensed", "normal", "semi_expanded", "expanded",
	 * "extra_expanded" and "ultra_expanded". Case variations are
	 * ignored and the '_' characters may be omitted.
	 * Params:
	 * str =  a string to parse.
	 * stretch =  a PangoStretch to store the result in.
	 * warn =  if TRUE, issue a g_warning() on bad input.
	 * Returns: TRUE if str was successfully parsed.
	 */
	public static int parseStretch(string str, out PangoStretch stretch, int warn);

	/**
	 * On Unix, returns the name of the "pango" subdirectory of SYSCONFDIR
	 * (which is set at compile time). On Windows, returns the etc\pango
	 * subdirectory of the Pango installation directory (which is deduced
	 * at run time from the DLL's location).
	 * Returns: the Pango sysconf directory. The returned string shouldnot be freed.
	 */
	public static string getSysconfSubdirectory();

	/**
	 * On Unix, returns the name of the "pango" subdirectory of LIBDIR
	 * (which is set at compile time). On Windows, returns the lib\pango
	 * subdirectory of the Pango installation directory (which is deduced
	 * at run time from the DLL's location).
	 * Returns: the Pango lib directory. The returned string shouldnot be freed.
	 */
	public static string getLibSubdirectory();

	/**
	 * This will return the bidirectional embedding levels of the input paragraph
	 * Since 1.4
	 * Params:
	 * text =  the text to itemize.
	 * length =  the number of bytes (not characters) to process, or -1
	 *  if text is nul-terminated and the length should be calculated.
	 * pbaseDir =  input base direction, and output resolved direction.
	 * Returns: a newly allocated array of embedding levels, one item per character (not byte), that should be freed using g_free.
	 */
	public static ubyte* log2visGetEmbeddingLevels(string text, int length, out PangoDirection pbaseDir);

	/**
	 * Checks ch to see if it is a character that should not be
	 * normally rendered on the screen. This includes all Unicode characters
	 * with "ZERO WIDTH" in their name, as well as bidi formatting characters, and
	 * a few other ones. This is totally different from g_unichar_iszerowidth()
	 * and is at best misnamed.
	 * Since 1.10
	 * Params:
	 * ch =  a Unicode character
	 * Returns: TRUE if ch is a zero-width character, FALSE otherwise
	 */
	public static int isZeroWidth(gunichar ch);

	/**
	 * Quantizes the thickness and position of a line, typically an
	 * underline or strikethrough, to whole device pixels, that is integer
	 * multiples of PANGO_SCALE. The purpose of this function is to avoid
	 * such lines looking blurry.
	 * Care is taken to make sure thickness is at least one pixel when this
	 * function returns, but returned position may become zero as a result
	 * of rounding.
	 * Since 1.12
	 * Params:
	 * thickness =  pointer to the thickness of a line, in Pango units
	 * position =  corresponding position
	 */
	public static void quantizeLineGeometry(inout int thickness, inout int position);
}
