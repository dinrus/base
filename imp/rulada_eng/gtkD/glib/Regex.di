
module gtkD.glib.Regex;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.MatchInfo;




/**
 * Description
 * The g_regex_*() functions implement regular
 * expression pattern matching using syntax and semantics similar to
 * Perl regular expression.
 * Some functions accept a start_position argument,
 * setting it differs from just passing over a shortened string and setting
 * G_REGEX_MATCH_NOTBOL in the case of a pattern that begins with any kind
 * of lookbehind assertion.
 * For example, consider the pattern "\Biss\B" which finds occurrences of "iss"
 * in the middle of words. ("\B" matches only if the current position in the
 * subject is not a word boundary.) When applied to the string "Mississipi"
 * from the fourth byte, namely "issipi", it does not match, because "\B" is
 * always false at the start of the subject, which is deemed to be a word
 * boundary. However, if the entire string is passed , but with
 * start_position set to 4, it finds the second
 * occurrence of "iss" because it is able to look behind the starting point
 * to discover that it is preceded by a letter.
 * Note that, unless you set the G_REGEX_RAW flag, all the strings passed
 * to these functions must be encoded in UTF-8. The lengths and the positions
 * inside the strings are in bytes and not in characters, so, for instance,
 * "\xc3\xa0" (i.e. "à") is two bytes long but it is treated as a single
 * character. If you set G_REGEX_RAW the strings can be non-valid UTF-8
 * strings and a byte is treated as a character, so "\xc3\xa0" is two bytes
 * and two characters long.
 * When matching a pattern, "\n" matches only against a "\n" character in the
 * string, and "\r" matches only a "\r" character. To match any newline sequence
 * use "\R". This particular group matches either the two-character sequence
 * CR + LF ("\r\n"), or one of the single characters LF (linefeed, U+000A, "\n"), VT
 * (vertical tab, U+000B, "\v"), FF (formfeed, U+000C, "\f"), CR (carriage return,
 * U+000D, "\r"), NEL (next line, U+0085), LS (line separator, U+2028), or PS
 * (paragraph separator, U+2029).
 * The behaviour of the dot, circumflex, and dollar metacharacters are affected by
 * newline characters, the default is to recognize any newline character (the same
 * characters recognized by "\R"). This can be changed with G_REGEX_NEWLINE_CR,
 * G_REGEX_NEWLINE_LF and G_REGEX_NEWLINE_CRLF compile options,
 * and with G_REGEX_MATCH_NEWLINE_ANY, G_REGEX_MATCH_NEWLINE_CR,
 * G_REGEX_MATCH_NEWLINE_LF and G_REGEX_MATCH_NEWLINE_CRLF match options.
 * These settings are also relevant when compiling a pattern if
 * G_REGEX_EXTENDED is set, and an unescaped "#" outside a character class is
 * encountered. This indicates a comment that lasts until after the next
 * newline.
 * Creating and manipulating the same GRegex structure from different
 * threads is not a problem as GRegex does not modify its internal
 * state between creation and destruction, on the other hand GMatchInfo is
 * not threadsafe.
 * The regular expressions low level functionalities are obtained through
 * the excellent PCRE library
 * written by Philip Hazel.
 */
public class Regex
{
	
	/** the main Gtk struct */
	protected GRegex* gRegex;
	
	
	public GRegex* getRegexStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GRegex* gRegex);
	
	/**
	 */
	
	/**
	 * Compiles the regular expression to an internal form, and does
	 * the initial setup of the GRegex structure.
	 * Since 2.14
	 * Params:
	 * pattern =  the regular expression
	 * compileOptions =  compile options for the regular expression, or 0
	 * matchOptions =  match options for the regular expression, or 0
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string pattern, GRegexCompileFlags compileOptions, GRegexMatchFlags matchOptions);
	
	/**
	 * Increases reference count of regex by 1.
	 * Since 2.14
	 * Returns: regex
	 */
	public Regex doref();
	
	/**
	 * Decreases reference count of regex by 1. When reference count drops
	 * to zero, it frees all the memory associated with the regex structure.
	 * Since 2.14
	 */
	public void unref();

	/**
	 * Gets the pattern string associated with regex, i.e. a copy of
	 * the string passed to g_regex_new().
	 * Since 2.14
	 * Returns: the pattern of regex
	 */
	public string getPattern();
	
	/**
	 * Returns the number of the highest back reference
	 * in the pattern, or 0 if the pattern does not contain
	 * back references.
	 * Since 2.14
	 * Returns: the number of the highest back reference
	 */
	public int getMaxBackref();
	
	/**
	 * Returns the number of capturing subpatterns in the pattern.
	 * Since 2.14
	 * Returns: the number of capturing subpatterns
	 */
	public int getCaptureCount();
	
	/**
	 * Retrieves the number of the subexpression named name.
	 * Since 2.14
	 * Params:
	 * name =  name of the subexpression
	 * Returns: The number of the subexpression or -1 if name  does not exists
	 */
	public int getStringNumber(string name);
	
	/**
	 * Escapes the special characters used for regular expressions
	 * in string, for instance "a.b*c" becomes "a\.b\*c". This
	 * function is useful to dynamically generate regular expressions.
	 * string can contain nul characters that are replaced with "\0",
	 * in this case remember to specify the correct length of string
	 * in length.
	 * Since 2.14
	 * Params:
	 * string =  the string to escape
	 * length =  the length of string, or -1 if string is nul-terminated
	 * Returns: a newly-allocated escaped string
	 */
	public static string escapeString(string string, int length);
	
	/**
	 * Scans for a match in string for pattern.
	 * This function is equivalent to g_regex_match() but it does not
	 * require to compile the pattern with g_regex_new(), avoiding some
	 * lines of code when you need just to do a match without extracting
	 * substrings, capture counts, and so on.
	 * If this function is to be called on the same pattern more than
	 * once, it's more efficient to compile the pattern once with
	 * g_regex_new() and then use g_regex_match().
	 * Since 2.14
	 * Params:
	 * pattern =  the regular expression
	 * string =  the string to scan for matches
	 * compileOptions =  compile options for the regular expression, or 0
	 * matchOptions =  match options, or 0
	 * Returns: TRUE if the string matched, FALSE otherwise
	 */
	public static int matchSimple(string pattern, string string, GRegexCompileFlags compileOptions, GRegexMatchFlags matchOptions);
	
	/**
	 * Scans for a match in string for the pattern in regex.
	 * The match_options are combined with the match options specified
	 * when the regex structure was created, letting you have more
	 * flexibility in reusing GRegex structures.
	 * A GMatchInfo structure, used to get information on the match,
	 * is stored in match_info if not NULL. Note that if match_info
	 * is not NULL then it is created even if the function returns FALSE,
	 * i.e. you must free it regardless if regular expression actually matched.
	 * To retrieve all the non-overlapping matches of the pattern in
	 * string you can use g_match_info_next().
	 * static void
	 * print_uppercase_words (const gchar *string)
	 * {
		 *  /+* Print all uppercase-only words. +/
		 *  GRegex *regex;
		 *  GMatchInfo *match_info;
		 *
		 *  regex = g_regex_new ("[A-Z]+", 0, 0, NULL);
		 *  g_regex_match (regex, string, 0, match_info);
		 *  while (g_match_info_matches (match_info))
		 *  {
			 *  gchar *word = g_match_info_fetch (match_info, 0);
			 *  g_print ("Found: %s\n", word);
			 *  g_free (word);
			 *  g_match_info_next (match_info, NULL);
		 *  }
		 *  g_match_info_free (match_info);
		 *  g_regex_unref (regex);
	 * }
	 * string is not copied and is used in GMatchInfo internally. If
	 * you use any GMatchInfo method (except g_match_info_free()) after
	 * freeing or modifying string then the behaviour is undefined.
	 * Since 2.14
	 * Params:
	 * string =  the string to scan for matches
	 * matchOptions =  match options
	 * matchInfo =  pointer to location where to store the GMatchInfo,
	 *  or NULL if you do not need it
	 * Returns: TRUE is the string matched, FALSE otherwise
	 */
	public int match(string string, GRegexMatchFlags matchOptions, out MatchInfo matchInfo);
	
	/**
	 * Scans for a match in string for the pattern in regex.
	 * The match_options are combined with the match options specified
	 * when the regex structure was created, letting you have more
	 * flexibility in reusing GRegex structures.
	 * Setting start_position differs from just passing over a shortened
	 * string and setting G_REGEX_MATCH_NOTBOL in the case of a pattern
	 * that begins with any kind of lookbehind assertion, such as "\b".
	 * A GMatchInfo structure, used to get information on the match, is
	 * stored in match_info if not NULL. Note that if match_info is
	 * not NULL then it is created even if the function returns FALSE,
	 * i.e. you must free it regardless if regular expression actually
	 * matched.
	 * string is not copied and is used in GMatchInfo internally. If
	 * you use any GMatchInfo method (except g_match_info_free()) after
	 * freeing or modifying string then the behaviour is undefined.
	 * To retrieve all the non-overlapping matches of the pattern in
	 * string you can use g_match_info_next().
	 * static void
	 * print_uppercase_words (const gchar *string)
	 * {
		 *  /+* Print all uppercase-only words. +/
		 *  GRegex *regex;
		 *  GMatchInfo *match_info;
		 *  GError *error = NULL;
		 *
		 *  regex = g_regex_new ("[A-Z]+", 0, 0, NULL);
		 *  g_regex_match_full (regex, string, -1, 0, 0, match_info, error);
		 *  while (g_match_info_matches (match_info))
		 *  {
			 *  gchar *word = g_match_info_fetch (match_info, 0);
			 *  g_print ("Found: %s\n", word);
			 *  g_free (word);
			 *  g_match_info_next (match_info, error);
		 *  }
		 *  g_match_info_free (match_info);
		 *  g_regex_unref (regex);
		 *  if (error != NULL)
		 *  {
			 *  g_printerr ("Error while matching: %s\n", error->message);
			 *  g_error_free (error);
		 *  }
	 * }
	 * Since 2.14
	 * Params:
	 * string =  the string to scan for matches
	 * stringLen =  the length of string, or -1 if string is nul-terminated
	 * startPosition =  starting index of the string to match
	 * matchOptions =  match options
	 * matchInfo =  pointer to location where to store the GMatchInfo,
	 *  or NULL if you do not need it
	 * Returns: TRUE is the string matched, FALSE otherwise
	 * Throws: GException on failure.
	 */
	public int matchFull(string string, int stringLen, int startPosition, GRegexMatchFlags matchOptions, out MatchInfo matchInfo);
	
	/**
	 * Using the standard algorithm for regular expression matching only
	 * the longest match in the string is retrieved. This function uses
	 * a different algorithm so it can retrieve all the possible matches.
	 * For more documentation see g_regex_match_all_full().
	 * A GMatchInfo structure, used to get information on the match, is
	 * stored in match_info if not NULL. Note that if match_info is
	 * not NULL then it is created even if the function returns FALSE,
	 * i.e. you must free it regardless if regular expression actually
	 * matched.
	 * string is not copied and is used in GMatchInfo internally. If
	 * you use any GMatchInfo method (except g_match_info_free()) after
	 * freeing or modifying string then the behaviour is undefined.
	 * Since 2.14
	 * Params:
	 * string =  the string to scan for matches
	 * matchOptions =  match options
	 * matchInfo =  pointer to location where to store the GMatchInfo,
	 *  or NULL if you do not need it
	 * Returns: TRUE is the string matched, FALSE otherwise
	 */
	public int matchAll(string string, GRegexMatchFlags matchOptions, out MatchInfo matchInfo);
	
	/**
	 * Using the standard algorithm for regular expression matching only
	 * the longest match in the string is retrieved, it is not possibile
	 * to obtain all the available matches. For instance matching
	 * "<a> <b> <c>" against the pattern "<.*>"
	 * you get "<a> <b> <c>".
	 * This function uses a different algorithm (called DFA, i.e. deterministic
	 * finite automaton), so it can retrieve all the possible matches, all
	 * starting at the same point in the string. For instance matching
	 * "<a> <b> <c>" against the pattern "<.*>"
	 * you would obtain three matches: "<a> <b> <c>",
	 * "<a> <b>" and "<a>".
	 * The number of matched strings is retrieved using
	 * g_match_info_get_match_count(). To obtain the matched strings and
	 * their position you can use, respectively, g_match_info_fetch() and
	 * g_match_info_fetch_pos(). Note that the strings are returned in
	 * reverse order of length; that is, the longest matching string is
	 * given first.
	 * Note that the DFA algorithm is slower than the standard one and it
	 * is not able to capture substrings, so backreferences do not work.
	 * Setting start_position differs from just passing over a shortened
	 * string and setting G_REGEX_MATCH_NOTBOL in the case of a pattern
	 * that begins with any kind of lookbehind assertion, such as "\b".
	 * A GMatchInfo structure, used to get information on the match, is
	 * stored in match_info if not NULL. Note that if match_info is
	 * not NULL then it is created even if the function returns FALSE,
	 * i.e. you must free it regardless if regular expression actually
	 * matched.
	 * string is not copied and is used in GMatchInfo internally. If
	 * you use any GMatchInfo method (except g_match_info_free()) after
	 * freeing or modifying string then the behaviour is undefined.
	 * Since 2.14
	 * Params:
	 * string =  the string to scan for matches
	 * stringLen =  the length of string, or -1 if string is nul-terminated
	 * startPosition =  starting index of the string to match
	 * matchOptions =  match options
	 * matchInfo =  pointer to location where to store the GMatchInfo,
	 *  or NULL if you do not need it
	 * Returns: TRUE is the string matched, FALSE otherwise
	 * Throws: GException on failure.
	 */
	public int matchAllFull(string string, int stringLen, int startPosition, GRegexMatchFlags matchOptions, out MatchInfo matchInfo);
	
	/**
	 * Breaks the string on the pattern, and returns an array of
	 * the tokens. If the pattern contains capturing parentheses,
	 * then the text for each of the substrings will also be returned.
	 * If the pattern does not match anywhere in the string, then the
	 * whole string is returned as the first token.
	 * This function is equivalent to g_regex_split() but it does
	 * not require to compile the pattern with g_regex_new(), avoiding
	 * some lines of code when you need just to do a split without
	 * extracting substrings, capture counts, and so on.
	 * If this function is to be called on the same pattern more than
	 * once, it's more efficient to compile the pattern once with
	 * g_regex_new() and then use g_regex_split().
	 * As a special case, the result of splitting the empty string ""
	 * is an empty vector, not a vector containing a single string.
	 * The reason for this special case is that being able to represent
	 * a empty vector is typically more useful than consistent handling
	 * of empty elements. If you do need to represent empty elements,
	 * you'll need to check for the empty string before calling this
	 * function.
	 * A pattern that can match empty strings splits string into
	 * separate characters wherever it matches the empty string between
	 * characters. For example splitting "ab c" using as a separator
	 * "\s*", you will get "a", "b" and "c".
	 * Since 2.14
	 * Params:
	 * pattern =  the regular expression
	 * string =  the string to scan for matches
	 * compileOptions =  compile options for the regular expression, or 0
	 * matchOptions =  match options, or 0
	 * Returns: a NULL-terminated array of strings. Free it using g_strfreev()
	 */
	public static string[] splitSimple(string pattern, string string, GRegexCompileFlags compileOptions, GRegexMatchFlags matchOptions);
	
	/**
	 * Breaks the string on the pattern, and returns an array of the tokens.
	 * If the pattern contains capturing parentheses, then the text for each
	 * of the substrings will also be returned. If the pattern does not match
	 * anywhere in the string, then the whole string is returned as the first
	 * token.
	 * As a special case, the result of splitting the empty string "" is an
	 * empty vector, not a vector containing a single string. The reason for
	 * this special case is that being able to represent a empty vector is
	 * typically more useful than consistent handling of empty elements. If
	 * you do need to represent empty elements, you'll need to check for the
	 * empty string before calling this function.
	 * A pattern that can match empty strings splits string into separate
	 * characters wherever it matches the empty string between characters.
	 * For example splitting "ab c" using as a separator "\s*", you will get
	 * "a", "b" and "c".
	 * Since 2.14
	 * Params:
	 * string =  the string to split with the pattern
	 * matchOptions =  match time option flags
	 * Returns: a NULL-terminated gchar ** array. Free it using g_strfreev()
	 */
	public string[] split(string string, GRegexMatchFlags matchOptions);
	
	/**
	 * Breaks the string on the pattern, and returns an array of the tokens.
	 * If the pattern contains capturing parentheses, then the text for each
	 * of the substrings will also be returned. If the pattern does not match
	 * anywhere in the string, then the whole string is returned as the first
	 * token.
	 * As a special case, the result of splitting the empty string "" is an
	 * empty vector, not a vector containing a single string. The reason for
	 * this special case is that being able to represent a empty vector is
	 * typically more useful than consistent handling of empty elements. If
	 * you do need to represent empty elements, you'll need to check for the
	 * empty string before calling this function.
	 * A pattern that can match empty strings splits string into separate
	 * characters wherever it matches the empty string between characters.
	 * For example splitting "ab c" using as a separator "\s*", you will get
	 * "a", "b" and "c".
	 * Setting start_position differs from just passing over a shortened
	 * string and setting G_REGEX_MATCH_NOTBOL in the case of a pattern
	 * that begins with any kind of lookbehind assertion, such as "\b".
	 * Since 2.14
	 * Params:
	 * string =  the string to split with the pattern
	 * stringLen =  the length of string, or -1 if string is nul-terminated
	 * startPosition =  starting index of the string to match
	 * matchOptions =  match time option flags
	 * maxTokens =  the maximum number of tokens to split string into.
	 *  If this is less than 1, the string is split completely
	 * Returns: a NULL-terminated gchar ** array. Free it using g_strfreev()
	 * Throws: GException on failure.
	 */
	public string[] splitFull(string string, int stringLen, int startPosition, GRegexMatchFlags matchOptions, int maxTokens);
	
	/**
	 * Replaces all occurrences of the pattern in regex with the
	 * replacement text. Backreferences of the form '\number' or
	 * '\g<number>' in the replacement text are interpolated by the
	 * number-th captured subexpression of the match, '\g<name>' refers
	 * to the captured subexpression with the given name. '\0' refers to the
	 * complete match, but '\0' followed by a number is the octal representation
	 * of a character. To include a literal '\' in the replacement, write '\\'.
	 * Since 2.14
	 * Params:
	 * string =  the string to perform matches against
	 * stringLen =  the length of string, or -1 if string is nul-terminated
	 * startPosition =  starting index of the string to match
	 * replacement =  text to replace each match with
	 * matchOptions =  options for the match
	 * Returns: a newly allocated string containing the replacements
	 * Throws: GException on failure.
	 */
	public string replace(string string, int stringLen, int startPosition, string replacement, GRegexMatchFlags matchOptions);
	
	/**
	 * Replaces all occurrences of the pattern in regex with the
	 * replacement text. replacement is replaced literally, to
	 * include backreferences use g_regex_replace().
	 * Setting start_position differs from just passing over a
	 * shortened string and setting G_REGEX_MATCH_NOTBOL in the
	 * case of a pattern that begins with any kind of lookbehind
	 * assertion, such as "\b".
	 * Since 2.14
	 * Params:
	 * string =  the string to perform matches against
	 * stringLen =  the length of string, or -1 if string is nul-terminated
	 * startPosition =  starting index of the string to match
	 * replacement =  text to replace each match with
	 * matchOptions =  options for the match
	 * Returns: a newly allocated string containing the replacements
	 * Throws: GException on failure.
	 */
	public string replaceLiteral(string string, int stringLen, int startPosition, string replacement, GRegexMatchFlags matchOptions);
	
	/**
	 * Replaces occurrences of the pattern in regex with the output of
	 * eval for that occurrence.
	 * Setting start_position differs from just passing over a shortened
	 * string and setting G_REGEX_MATCH_NOTBOL in the case of a pattern
	 * that begins with any kind of lookbehind assertion, such as "\b".
	 * The following example uses g_regex_replace_eval() to replace multiple
	 * Since 2.14
	 * Params:
	 * string =  string to perform matches against
	 * stringLen =  the length of string, or -1 if string is nul-terminated
	 * startPosition =  starting index of the string to match
	 * matchOptions =  options for the match
	 * eval =  a function to call for each match
	 * userData =  user data to pass to the function
	 * Returns: a newly allocated string containing the replacements
	 * Throws: GException on failure.
	 */
	public string replaceEval(string string, int stringLen, int startPosition, GRegexMatchFlags matchOptions, GRegexEvalCallback eval, void* userData);
	
	/**
	 * Checks whether replacement is a valid replacement string
	 * (see g_regex_replace()), i.e. that all escape sequences in
	 * it are valid.
	 * If has_references is not NULL then replacement is checked
	 * for pattern references. For instance, replacement text 'foo\n'
	 * does not contain references and may be evaluated without information
	 * about actual match, but '\0\1' (whole match followed by first
	 * subpattern) requires valid GMatchInfo object.
	 * Since 2.14
	 * Params:
	 * replacement =  the replacement string
	 * hasReferences =  location to store information about
	 *  references in replacement or NULL
	 * Returns: whether replacement is a valid replacement string
	 * Throws: GException on failure.
	 */
	public static int checkReplacement(string replacement, out int hasReferences);
}
