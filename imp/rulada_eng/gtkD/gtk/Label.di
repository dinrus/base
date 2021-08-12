module gtkD.gtk.Label;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.pango.PgAttributeList;
private import gtkD.pango.PgLayout;



private import gtkD.gtk.Misc;

/**
 * Description
 * The GtkLabel widget displays a small amount of text. As the name
 * implies, most labels are used to label another widget such as a
 * GtkButton, a GtkMenuItem, or a GtkOptionMenu.
 * GtkLabel as GtkBuildable
 * The GtkLabel implementation of the GtkBuildable interface supports a
 * custom <attributes> element, which supports any number of <attribute>
 * elements. the <attribute> element has attributes named name, value,
 * start and end and allows you to specify PangoAttribute values for this label.
 * Example 13. A UI definition fragment specifying Pango attributes
 * <object class="GtkLabel">
 *  <attributes>
 *  <attribute name="weight" value="PANGO_WEIGHT_BOLD"/>
 *  <attribute name="background" value="red" start="5" end="10"/>"
 *  </attributes>
 * </object>
 * The start and end attributes specify the range of characters to which the
 * Pango attribute applies. If start and end are not specified, the attribute is
 * applied to the whole text. Note that specifying ranges does not make much
 * sense with translatable attributes. Use markup embedded in the translatable
 * content instead.
 * <hr>
 * Mnemonics
 * Labels may contain mnemonics. Mnemonics are
 * underlined characters in the label, used for keyboard navigation.
 * Mnemonics are created by providing a string with an underscore before
 * the mnemonic character, such as "_File", to the
 * functions gtk_label_new_with_mnemonic() or
 * gtk_label_set_text_with_mnemonic().
 * Mnemonics automatically activate any activatable widget the label is
 * inside, such as a GtkButton; if the label is not inside the
 * mnemonic's target widget, you have to tell the label about the target
 * using gtk_label_set_mnemonic_widget(). Here's a simple example where
 * the label is inside a button:
 *  /+* Pressing Alt+H will activate this button +/
 *  button = gtk_button_new ();
 *  label = gtk_label_new_with_mnemonic ("_Hello");
 *  gtk_container_add (GTK_CONTAINER (button), label);
 * There's a convenience function to create buttons with a mnemonic label
 * already inside:
 *  /+* Pressing Alt+H will activate this button +/
 *  button = gtk_button_new_with_mnemonic ("_Hello");
 * To create a mnemonic for a widget alongside the label, such as a
 * GtkEntry, you have to point the label at the entry with
 * gtk_label_set_mnemonic_widget():
 *  /+* Pressing Alt+H will focus the entry +/
 *  entry = gtk_entry_new ();
 *  label = gtk_label_new_with_mnemonic ("_Hello");
 *  gtk_label_set_mnemonic_widget (GTK_LABEL (label), entry);
 * <hr>
 * Markup (styled text)
 * To make it easy to format text in a label (changing colors, fonts,
 * etc.), label text can be provided in a simple markup format.
 * Here's how to create a label with a small font:
 *  label = gtk_label_new (NULL);
 *  gtk_label_set_markup (GTK_LABEL (label), "<small>Small text</small>");
 * (See complete documentation of available
 * tags in the Pango manual.)
 * The markup passed to gtk_label_set_markup() must be valid; for example,
 * literal </>/ characters must be escaped as lt;,
 * gt;, and amp;. If you pass text obtained from the user, file,
 * or a network to gtk_label_set_markup(), you'll want to escape it with
 * g_markup_escape_text() or g_markup_printf_escaped().
 * Markup strings are just a convenient way to set the PangoAttrList on
 * a label; gtk_label_set_attributes() may be a simpler way to set
 * attributes in some cases. Be careful though; PangoAttrList tends to
 * cause internationalization problems, unless you're applying attributes
 * to the entire string (i.e. unless you set the range of each attribute
 * to [0, G_MAXINT)). The reason is that specifying the start_index and
 * end_index for a PangoAttribute requires knowledge of the exact string
 * being displayed, so translations will cause problems.
 * <hr>
 * Selectable labels
 * Labels can be made selectable with gtk_label_set_selectable().
 * Selectable labels allow the user to copy the label contents to
 * the clipboard. Only labels that contain useful-to-copy information
 * — such as error messages — should be made selectable.
 * <hr>
 * Text layout
 * A label can contain any number of paragraphs, but will have
 * performance problems if it contains more than a small number.
 * Paragraphs are separated by newlines or other paragraph separators
 * understood by Pango.
 * Labels can automatically wrap text if you call
 * gtk_label_set_line_wrap().
 * gtk_label_set_justify() sets how the lines in a label align
 * with one another. If you want to set how the label as a whole
 * aligns in its available space, see gtk_misc_set_alignment().
 * <hr>
 * Links
 * Since 2.18, GTK+ supports markup for clickable hyperlinks in addition
 * to regular Pango markup. The markup for links is borrowed from HTML, using the
 * a with href and title attributes. GTK+ renders links similar to the
 * way they appear in web browsers, with colored, underlined text. The title
 * attribute is displayed as a tooltip on the link. An example looks like this:
 * gtk_label_set_markup (label, "Go to the <a href=\"http://www.gtkD.gtk.org\" title=\"lt;igt;Our/igt; website\">GTK+ website</a> for more...");
 * It is possible to implement custom handling for links and their tooltips with
 * the "activate-link" signal and the gtk_label_get_current_uri() function.
 */
public class Label : Misc
{
	
	/** the main Gtk struct */
	protected GtkLabel* gtkLabel;
	
	
	public GtkLabel* getLabelStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkLabel* gtkLabel);
	
	/**
	 * Creates a new GtkLabel, containing the text in str.
	 * If characters in str are preceded by an underscore, they are
	 * underlined. If you need a literal underscore character in a label, use
	 * '__' (two underscores). The first underlined character represents a
	 * keyboard accelerator called a mnemonic. The mnemonic key can be used
	 * to activate another widget, chosen automatically, or explicitly using
	 * gtk_label_set_mnemonic_widget().
	 * If gtk_label_set_mnemonic_widget()
	 * is not called, then the first activatable ancestor of the GtkLabel
	 * will be chosen as the mnemonic widget. For instance, if the
	 * label is inside a button or menu item, the button or menu item will
	 * automatically become the mnemonic widget and be activated by
	 * the mnemonic.
	 * Params:
	 *  str = The text of the label, with an underscore in front of the
	 *  mnemonic character
	 *  mnemonic = when false uses the literal text passed in without mnemonic
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string str, bool mnemonic=true);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Label)[] onActivateCurrentLinkListeners;
	/**
	 * A keybinding signal
	 * which gets emitted when the user activates a link in the label.
	 * Applications may also emit the signal with g_signal_emit_by_name()
	 * if they need to control activation of URIs programmatically.
	 * The default bindings for this signal are all forms of the Enter key.
	 * Since 2.18
	 */
	void addOnActivateCurrentLink(void delegate(Label) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackActivateCurrentLink(GtkLabel* labelStruct, Label label);
	
	bool delegate(string, Label)[] onActivateLinkListeners;
	/**
	 * The signal which gets emitted to activate a URI.
	 * Applications may connect to it to override the default behaviour,
	 * which is to call gtk_show_uri().
	 * Since 2.18
	 */
	void addOnActivateLink(bool delegate(string, Label) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackActivateLink(GtkLabel* labelStruct, gchar* uri, Label label);
	
	void delegate(Label)[] onCopyClipboardListeners;
	/**
	 * The ::copy-clipboard signal is a
	 * keybinding signal
	 * which gets emitted to copy the selection to the clipboard.
	 * The default binding for this signal is Ctrl-c.
	 */
	void addOnCopyClipboard(void delegate(Label) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCopyClipboard(GtkLabel* labelStruct, Label label);
	
	void delegate(GtkMovementStep, gint, gboolean, Label)[] onMoveCursorListeners;
	/**
	 * The ::move-cursor signal is a
	 * keybinding signal
	 * which gets emitted when the user initiates a cursor movement.
	 * If the cursor is not visible in entry, this signal causes
	 * the viewport to be moved instead.
	 * Applications should not connect to it, but may emit it with
	 * g_signal_emit_by_name() if they need to control the cursor
	 * programmatically.
	 * The default bindings for this signal come in two variants,
	 * the variant with the Shift modifier extends the selection,
	 * the variant without the Shift modifer does not.
	 * There are too many key combinations to list them all here.
	 * Arrow keys move by individual characters/lines
	 * Ctrl-arrow key combinations move by words/paragraphs
	 * Home/End keys move to the ends of the buffer
	 */
	void addOnMoveCursor(void delegate(GtkMovementStep, gint, gboolean, Label) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMoveCursor(GtkLabel* entryStruct, GtkMovementStep step, gint count, gboolean extendSelection, Label label);
	
	void delegate(GtkMenu*, Label)[] onPopulatePopupListeners;
	/**
	 * The ::populate-popup signal gets emitted before showing the
	 * context menu of the label. Note that only selectable labels
	 * have context menus.
	 * If you need to add items to the context menu, connect
	 * to this signal and append your menuitems to the menu.
	 */
	void addOnPopulatePopup(void delegate(GtkMenu*, Label) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPopulatePopup(GtkLabel* labelStruct, GtkMenu* menu, Label label);
	
	
	/**
	 * Sets the text within the GtkLabel widget. It overwrites any text that
	 * was there before.
	 * This will also clear any previously set mnemonic accelerators.
	 * Params:
	 * str =  The text you want to set
	 */
	public void setText(string str);

	/**
	 * Sets a PangoAttrList; the attributes in the list are applied to the
	 * label text.
	 * Note
	 * The attributes set with this function will be applied
	 * and merged with any other attributes previously effected by way
	 * of the "use-underline" or "use-markup" properties.
	 * While it is not recommended to mix markup strings with manually set
	 * attributes, if you must; know that the attributes will be applied
	 * to the label after the markup string is parsed.
	 * Params:
	 * attrs =  a PangoAttrList
	 */
	public void setAttributes(PgAttributeList attrs);
	
	/**
	 * Parses str which is marked up with the Pango text markup language, setting the
	 * label's text and attribute list based on the parse results. If the str is
	 * external data, you may need to escape it with g_markup_escape_text() or
	 * Params:
	 * str =  a markup string (see Pango markup format)
	 */
	public void setMarkup(string str);
	
	/**
	 * Parses str which is marked up with the Pango text markup language,
	 * setting the label's text and attribute list based on the parse results.
	 * If characters in str are preceded by an underscore, they are underlined
	 * indicating that they represent a keyboard accelerator called a mnemonic.
	 * The mnemonic key can be used to activate another widget, chosen
	 * automatically, or explicitly using gtk_label_set_mnemonic_widget().
	 * Params:
	 * str =  a markup string (see Pango markup format)
	 */
	public void setMarkupWithMnemonic(string str);
	
	/**
	 * The pattern of underlines you want under the existing text within the
	 * GtkLabel widget. For example if the current text of the label says
	 * "FooBarBaz" passing a pattern of "___ ___" will underline
	 * "Foo" and "Baz" but not "Bar".
	 * Params:
	 * pattern = The pattern as described above.
	 */
	public void setPattern(string pattern);
	
	/**
	 * Sets the alignment of the lines in the text of the label relative to
	 * each other. GTK_JUSTIFY_LEFT is the default value when the
	 * widget is first created with gtk_label_new(). If you instead want
	 * to set the alignment of the label as a whole, use
	 * gtk_misc_set_alignment() instead. gtk_label_set_justify() has no
	 * effect on labels containing only a single line.
	 * Params:
	 * jtype =  a GtkJustification
	 */
	public void setJustify(GtkJustification jtype);

	/**
	 * Sets the mode used to ellipsize (add an ellipsis: "...") to the text
	 * if there is not enough space to render the entire string.
	 * Since 2.6
	 * Params:
	 * mode =  a PangoEllipsizeMode
	 */
	public void setEllipsize(PangoEllipsizeMode mode);
	
	/**
	 * Sets the desired width in characters of label to n_chars.
	 * Since 2.6
	 * Params:
	 * nChars =  the new desired width, in characters.
	 */
	public void setWidthChars(int nChars);
	
	/**
	 * Sets the desired maximum width in characters of label to n_chars.
	 * Since 2.6
	 * Params:
	 * nChars =  the new desired maximum width, in characters.
	 */
	public void setMaxWidthChars(int nChars);
	
	/**
	 * Warning
	 * gtk_label_get is deprecated and should not be used in newly-written code. Use gtk_label_get_text() instead.
	 * Gets the current string of text within the GtkLabel and writes it to
	 * the given str argument. It does not make a copy of this string so you
	 * must not write to it.
	 * Params:
	 * str = The reference to the pointer you want to point to the text.
	 */
	public void get(out string str);
	
	/**
	 * Warning
	 * gtk_label_parse_uline is deprecated and should not be used in newly-written code. Use gtk_label_set_use_underline() instead.
	 * Parses the given string for underscores and converts the next
	 * character to an underlined character. The last character that
	 * was underlined will have its lower-cased accelerator keyval returned (i.e.
	 * "_File" would return the keyval for "f". This is
	 * probably only used within the GTK+ library itself for menu items and such.
	 * Params:
	 * string = The string you want to parse for underlines.
	 * Returns:The lowercase keyval of the last character underlined.
	 */
	public uint parseUline(string string);
	
	/**
	 * Toggles line wrapping within the GtkLabel widget. TRUE makes it break
	 * lines if text exceeds the widget's size. FALSE lets the text get cut off
	 * by the edge of the widget if it exceeds the widget size.
	 * Note that setting line wrapping to TRUE does not make the label
	 * wrap at its parent container's width, because GTK+ widgets
	 * conceptually can't make their requisition depend on the parent
	 * container's size. For a label that wraps at a specific position,
	 * set the label's width using gtk_widget_set_size_request().
	 * Params:
	 * wrap =  the setting
	 */
	public void setLineWrap(int wrap);
	
	/**
	 * If line wrapping is on (see gtk_label_set_line_wrap()) this controls how
	 * the line wrapping is done. The default is PANGO_WRAP_WORD which means
	 * wrap on word boundaries.
	 * Since 2.10
	 * Params:
	 * wrapMode =  the line wrapping mode
	 */
	public void setLineWrapMode(PangoWrapMode wrapMode);
	
	/**
	 * Obtains the coordinates where the label will draw the PangoLayout
	 * representing the text in the label; useful to convert mouse events
	 * into coordinates inside the PangoLayout, e.g. to take some action
	 * if some part of the label is clicked. Of course you will need to
	 * create a GtkEventBox to receive the events, and pack the label
	 * inside it, since labels are a GTK_NO_WINDOW widget. Remember
	 * when using the PangoLayout functions you need to convert to
	 * and from pixels using PANGO_PIXELS() or PANGO_SCALE.
	 * Params:
	 * x =  location to store X offset of layout, or NULL
	 * y =  location to store Y offset of layout, or NULL
	 */
	public void getLayoutOffsets(out int x, out int y);
	
	/**
	 * If the label has been set so that it has an mnemonic key this function
	 * returns the keyval used for the mnemonic accelerator. If there is no
	 * mnemonic set up it returns GDK_VoidSymbol.
	 * Returns: GDK keyval usable for accelerators, or GDK_VoidSymbol
	 */
	public uint getMnemonicKeyval();
	
	/**
	 * Gets the value set by gtk_label_set_selectable().
	 * Returns: TRUE if the user can copy text from the label
	 */
	public int getSelectable();
	
	/**
	 * Fetches the text from a label widget, as displayed on the
	 * screen. This does not include any embedded underlines
	 * indicating mnemonics or Pango markup. (See gtk_label_get_label())
	 * Returns: the text in the label widget. This is the internal string used by the label, and must not be modified.
	 */
	public string getText();
	
	/**
	 * Selects a range of characters in the label, if the label is selectable.
	 * See gtk_label_set_selectable(). If the label is not selectable,
	 * this function has no effect. If start_offset or
	 * end_offset are -1, then the end of the label will be substituted.
	 * Params:
	 * startOffset =  start offset (in characters not bytes)
	 * endOffset =  end offset (in characters not bytes)
	 */
	public void selectRegion(int startOffset, int endOffset);
	
	/**
	 * If the label has been set so that it has an mnemonic key (using
	 * i.e. gtk_label_set_markup_with_mnemonic(),
	 * gtk_label_set_text_with_mnemonic(), gtk_label_new_with_mnemonic()
	 * or the "use_underline" property) the label can be associated with a
	 * widget that is the target of the mnemonic. When the label is inside
	 * a widget (like a GtkButton or a GtkNotebook tab) it is
	 * automatically associated with the correct widget, but sometimes
	 * (i.e. when the target is a GtkEntry next to the label) you need to
	 * set it explicitly using this function.
	 * The target widget will be accelerated by emitting the
	 * GtkWidget::mnemonic-activate signal on it. The default handler for
	 * this signal will activate the widget if there are no mnemonic collisions
	 * and toggle focus between the colliding widgets otherwise.
	 * Params:
	 * widget =  the target GtkWidget
	 */
	public void setMnemonicWidget(Widget widget);
	
	/**
	 * Selectable labels allow the user to select text from the label, for
	 * copy-and-paste.
	 * Params:
	 * setting =  TRUE to allow selecting text in the label
	 */
	public void setSelectable(int setting);
	
	/**
	 * Sets the label's text from the string str.
	 * If characters in str are preceded by an underscore, they are underlined
	 * indicating that they represent a keyboard accelerator called a mnemonic.
	 * The mnemonic key can be used to activate another widget, chosen
	 * automatically, or explicitly using gtk_label_set_mnemonic_widget().
	 * Params:
	 * str =  a string
	 */
	public void setTextWithMnemonic(string str);
	
	/**
	 * Gets the attribute list that was set on the label using
	 * gtk_label_set_attributes(), if any. This function does
	 * not reflect attributes that come from the labels markup
	 * (see gtk_label_set_markup()). If you want to get the
	 * effective attributes for the label, use
	 * pango_layout_get_attribute (gtk_label_get_layout (label)).
	 * Returns: the attribute list, or NULL if none was set.
	 */
	public PgAttributeList getAttributes();
	
	/**
	 * Returns the justification of the label. See gtk_label_set_justify().
	 * Returns: GtkJustification
	 */
	public GtkJustification getJustify();
	
	/**
	 * Returns the ellipsizing position of the label. See gtk_label_set_ellipsize().
	 * Since 2.6
	 * Returns: PangoEllipsizeMode
	 */
	public PangoEllipsizeMode getEllipsize();
	
	/**
	 * Retrieves the desired width of label, in characters. See
	 * gtk_label_set_width_chars().
	 * Since 2.6
	 * Returns: the width of the label in characters.
	 */
	public int getWidthChars();
	
	/**
	 * Retrieves the desired maximum width of label, in characters. See
	 * gtk_label_set_width_chars().
	 * Since 2.6
	 * Returns: the maximum width of the label in characters.
	 */
	public int getMaxWidthChars();
	
	/**
	 * Fetches the text from a label widget including any embedded
	 * underlines indicating mnemonics and Pango markup. (See
	 * gtk_label_get_text()).
	 * Returns: the text of the label widget. This string is owned by the widget and must not be modified or freed.
	 */
	public string getLabel();
	
	/**
	 * Gets the PangoLayout used to display the label.
	 * The layout is useful to e.g. convert text positions to
	 * pixel positions, in combination with gtk_label_get_layout_offsets().
	 * The returned layout is owned by the label so need not be
	 * freed by the caller.
	 * Returns: the PangoLayout for this label
	 */
	public PgLayout getLayout();
	
	/**
	 * Returns whether lines in the label are automatically wrapped.
	 * See gtk_label_set_line_wrap().
	 * Returns: TRUE if the lines of the label are automatically wrapped.
	 */
	public int getLineWrap();
	
	/**
	 * Returns line wrap mode used by the label. See gtk_label_set_line_wrap_mode().
	 * Since 2.10
	 * Returns: TRUE if the lines of the label are automatically wrapped.
	 */
	public PangoWrapMode getLineWrapMode();
	
	/**
	 * Retrieves the target of the mnemonic (keyboard shortcut) of this
	 * label. See gtk_label_set_mnemonic_widget().
	 * Returns: the target of the label's mnemonic, or NULL if none has been set and the default algorithm will be used.
	 */
	public Widget getMnemonicWidget();
	
	/**
	 * Gets the selected range of characters in the label, returning TRUE
	 * if there's a selection.
	 * Params:
	 * start =  return location for start of selection, as a character offset
	 * end =  return location for end of selection, as a character offset
	 * Returns: TRUE if selection is non-empty
	 */
	public int getSelectionBounds(out int start, out int end);
	
	/**
	 * Returns whether the label's text is interpreted as marked up with
	 * the Pango text markup
	 * language. See gtk_label_set_use_markup().
	 * Returns: TRUE if the label's text will be parsed for markup.
	 */
	public int getUseMarkup();
	
	/**
	 * Returns whether an embedded underline in the label indicates a
	 * mnemonic. See gtk_label_set_use_underline().
	 * Returns: TRUE whether an embedded underline in the label indicates the mnemonic accelerator keys.
	 */
	public int getUseUnderline();
	
	/**
	 * Returns whether the label is in single line mode.
	 * Since 2.6
	 * Returns: TRUE when the label is in single line mode.
	 */
	public int getSingleLineMode();
	
	/**
	 * Gets the angle of rotation for the label. See
	 * gtk_label_set_angle().
	 * Since 2.6
	 * Returns: the angle of rotation for the label
	 */
	public double getAngle();
	
	/**
	 * Sets the text of the label. The label is interpreted as
	 * including embedded underlines and/or Pango markup depending
	 * on the values of the "use-underline"" and
	 * "use-markup" properties.
	 * Params:
	 * str =  the new text to set for the label
	 */
	public void setLabel(string str);
	
	/**
	 * Sets whether the text of the label contains markup in Pango's text markup
	 * language. See gtk_label_set_markup().
	 * Params:
	 * setting =  TRUE if the label's text should be parsed for markup.
	 */
	public void setUseMarkup(int setting);
	
	/**
	 * If true, an underline in the text indicates the next character should be
	 * used for the mnemonic accelerator key.
	 * Params:
	 * setting =  TRUE if underlines in the text indicate mnemonics
	 */
	public void setUseUnderline(int setting);
	
	/**
	 * Sets whether the label is in single line mode.
	 * Since 2.6
	 * Params:
	 * singleLineMode =  TRUE if the label should be in single line mode
	 */
	public void setSingleLineMode(int singleLineMode);
	
	/**
	 * Sets the angle of rotation for the label. An angle of 90 reads from
	 * from bottom to top, an angle of 270, from top to bottom. The angle
	 * setting for the label is ignored if the label is selectable,
	 * wrapped, or ellipsized.
	 * Since 2.6
	 * Params:
	 * angle =  the angle that the baseline of the label makes with
	 *  the horizontal, in degrees, measured counterclockwise
	 */
	public void setAngle(double angle);
	
	/**
	 * Returns the URI for the currently active link in the label.
	 * The active link is the one under the mouse pointer or, in a
	 * selectable label, the link in which the text cursor is currently
	 * positioned.
	 * This function is intended for use in a "link-activate" handler
	 * or for use in a "query-tooltip" handler.
	 * Since 2.18
	 * Returns: the currently active URI. The string is owned by GTK+ and must not be freed or modified.
	 */
	public string getCurrentUri();
	
	/**
	 * Sets whether the label should keep track of clicked
	 * links (and use a different color for them).
	 * Since 2.18
	 * Params:
	 * trackLinks =  TRUE to track visited links
	 */
	public void setTrackVisitedLinks(int trackLinks);
	
	/**
	 * Returns whether the label is currently keeping track
	 * of clicked links.
	 * Since 2.18
	 * Returns: TRUE if clicked links are remembered
	 */
	public int getTrackVisitedLinks();
}