module gtkD.gtk.IconTheme;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gio.IconIF;
private import gtkD.gdk.Screen;
private import gtkD.gtk.IconInfo;
private import gtkD.gdk.Pixbuf;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.ListG;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GtkIconTheme provides a facility for looking up icons by name
 * and size. The main reason for using a name rather than simply
 * providing a filename is to allow different icons to be used
 * depending on what icon theme is selecetd
 * by the user. The operation of icon themes on Linux and Unix
 * follows the Icon
 * Theme Specification. There is a default icon theme,
 * named hicolor where applications should install
 * their icons, but more additional application themes can be
 * installed as operating system vendors and users choose.
 * Named icons are similar to the Themeable Stock Images(3)
 * facility, and the distinction between the two may be a bit confusing.
 * A few things to keep in mind:
 * Stock images usually are used in conjunction with
 * Stock Items(3)., such as GTK_STOCK_OK or
 * GTK_STOCK_OPEN. Named icons are easier to set up and therefore
 * are more useful for new icons that an application wants to
 * add, such as application icons or window icons.
 * Stock images can only be loaded at the symbolic sizes defined
 * by the GtkIconSize enumeration, or by custom sizes defined
 * by gtk_icon_size_register(), while named icons are more flexible
 * and any pixel size can be specified.
 * Because stock images are closely tied to stock items, and thus
 * to actions in the user interface, stock images may come in
 * multiple variants for different widget states or writing
 * directions.
 * A good rule of thumb is that if there is a stock image for what
 * you want to use, use it, otherwise use a named icon. It turns
 * out that internally stock images are generally defined in
 * terms of one or more named icons. (An example of the
 * more than one case is icons that depend on writing direction;
 * GTK_STOCK_GO_FORWARD uses the two themed icons
 * "gtk-stock-go-forward-ltr" and "gtk-stock-go-forward-rtl".)
 * In many cases, named themes are used indirectly, via GtkImage
 * or stock items, rather than directly, but looking up icons
 * directly is also simple. The GtkIconTheme object acts
 * as a database of all the icons in the current theme. You
 * can create new GtkIconTheme objects, but its much more
 * efficient to use the standard icon theme for the GdkScreen
 * so that the icon information is shared with other people
 * looking up icons. In the case where the default screen is
 * being used, looking up an icon can be as simple as:
 * GError *error = NULL;
 * GtkIconTheme *icon_theme;
 * GdkPixbuf *pixbuf;
 * icon_theme = gtk_icon_theme_get_default ();
 * pixbuf = gtk_icon_theme_load_icon (icon_theme,
 *  "my-icon-name", /+* icon name +/
 *  48, /+* size +/
 *  0, /+* flags +/
 *  error);
 * if (!pixbuf)
 *  {
	 *  g_warning ("Couldn't load icon: %s", error->message);
	 *  g_error_free (error);
 *  }
 * else
 *  {
	 *  /+* Use the pixbuf +/
	 *  g_object_unref (pixbuf);
 *  }
 */
public class IconTheme : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkIconTheme* gtkIconTheme;
	
	
	public GtkIconTheme* getIconThemeStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkIconTheme* gtkIconTheme);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(IconTheme)[] onChangedListeners;
	/**
	 * Emitted when the current icon theme is switched or GTK+ detects
	 * that a change has occurred in the contents of the current
	 * icon theme.
	 */
	void addOnChanged(void delegate(IconTheme) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackChanged(GtkIconTheme* iconThemeStruct, IconTheme iconTheme);
	
	
	/**
	 * Creates a new icon theme object. Icon theme objects are used
	 * to lookup up an icon by name in a particular icon theme.
	 * Usually, you'll want to use gtk_icon_theme_get_default()
	 * or gtk_icon_theme_get_for_screen() rather than creating
	 * a new icon theme object for scratch.
	 * Since 2.4
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Gets the icon theme for the default screen. See
	 * gtk_icon_theme_get_for_screen().
	 * Since 2.4
	 * Returns: A unique GtkIconTheme associated with the default screen. This icon theme is associated with the screen and can be used as long as the screen is open. Do not ref or unref it.
	 */
	public static IconTheme getDefault();
	
	/**
	 * Gets the icon theme object associated with screen; if this
	 * function has not previously been called for the given
	 * screen, a new icon theme object will be created and
	 * associated with the screen. Icon theme objects are
	 * fairly expensive to create, so using this function
	 * is usually a better choice than calling than gtk_icon_theme_new()
	 * and setting the screen yourself; by using this function
	 * a single icon theme object will be shared between users.
	 * Since 2.4
	 * Params:
	 * screen =  a GdkScreen
	 * Returns: A unique GtkIconTheme associated with the given screen. This icon theme is associated with the screen and can be used as long as the screen is open. Do not ref or unref it.
	 */
	public static IconTheme getForScreen(Screen screen);
	
	/**
	 * Sets the screen for an icon theme; the screen is used
	 * to track the user's currently configured icon theme,
	 * which might be different for different screens.
	 * Since 2.4
	 * Params:
	 * screen =  a GdkScreen
	 */
	public void setScreen(Screen screen);
	
	/**
	 * Sets the search path for the icon theme object. When looking
	 * for an icon theme, GTK+ will search for a subdirectory of
	 * one or more of the directories in path with the same name
	 * as the icon theme. (Themes from multiple of the path elements
	 * are combined to allow themes to be extended by adding icons
	 * in the user's home directory.)
	 * In addition if an icon found isn't found either in the current
	 * icon theme or the default icon theme, and an image file with
	 * the right name is found directly in one of the elements of
	 * path, then that image will be used for the icon name.
	 * (This is legacy feature, and new icons should be put
	 * into the default icon theme, which is called DEFAULT_THEME_NAME,
	 * rather than directly on the icon path.)
	 * Since 2.4
	 * Params:
	 * path =  array of directories that are searched for icon themes
	 * nElements =  number of elements in path.
	 */
	public void setSearchPath(char*[] path, int nElements);
	
	/**
	 * Gets the current search path. See gtk_icon_theme_set_search_path().
	 * Since 2.4
	 * Params:
	 * path =  location to store a list of icon theme path directories or NULL
	 *  The stored value should be freed with g_strfreev().
	 * nElements =  location to store number of elements
	 *  in path, or NULL
	 */
	public void getSearchPath(char**[] path, int* nElements);
	
	/**
	 * Appends a directory to the search path.
	 * See gtk_icon_theme_set_search_path().
	 * Since 2.4
	 * Params:
	 * path =  directory name to append to the icon path
	 */
	public void appendSearchPath(string path);
	
	/**
	 * Prepends a directory to the search path.
	 * See gtk_icon_theme_set_search_path().
	 * Since 2.4
	 * Params:
	 * path =  directory name to prepend to the icon path
	 */
	public void prependSearchPath(string path);
	
	/**
	 * Sets the name of the icon theme that the GtkIconTheme object uses
	 * overriding system configuration. This function cannot be called
	 * on the icon theme objects returned from gtk_icon_theme_get_default()
	 * and gtk_icon_theme_get_for_screen().
	 * Since 2.4
	 * Params:
	 * themeName =  name of icon theme to use instead of configured theme,
	 *  or NULL to unset a previously set custom theme
	 */
	public void setCustomTheme(string themeName);

	/**
	 * Checks whether an icon theme includes an icon
	 * for a particular name.
	 * Since 2.4
	 * Params:
	 * iconName =  the name of an icon
	 * Returns: TRUE if icon_theme includes an icon for icon_name.
	 */
	public int hasIcon(string iconName);
	
	/**
	 * Looks up a named icon and returns a structure containing
	 * information such as the filename of the icon. The icon
	 * can then be rendered into a pixbuf using
	 * gtk_icon_info_load_icon(). (gtk_icon_theme_load_icon()
	 * combines these two steps if all you need is the pixbuf.)
	 * Since 2.4
	 * Params:
	 * iconName =  the name of the icon to lookup
	 * size =  desired icon size
	 * flags =  flags modifying the behavior of the icon lookup
	 * Returns: a GtkIconInfo structure containing informationabout the icon, or NULL if the icon wasn't found. Free withgtk_icon_info_free()
	 */
	public IconInfo lookupIcon(string iconName, int size, GtkIconLookupFlags flags);
	
	/**
	 * Looks up a named icon and returns a structure containing
	 * information such as the filename of the icon. The icon
	 * can then be rendered into a pixbuf using
	 * gtk_icon_info_load_icon(). (gtk_icon_theme_load_icon()
	 * combines these two steps if all you need is the pixbuf.)
	 * If icon_names contains more than one name, this function
	 * tries them all in the given order before falling back to
	 * inherited icon themes.
	 * Since 2.12
	 * Params:
	 * iconNames =  NULL-terminated array of icon names to lookup
	 * size =  desired icon size
	 * flags =  flags modifying the behavior of the icon lookup
	 * Returns: a GtkIconInfo structure containing informationabout the icon, or NULL if the icon wasn't found. Free withgtk_icon_info_free()
	 */
	public IconInfo chooseIcon(char*[] iconNames, int size, GtkIconLookupFlags flags);
	
	/**
	 * Looks up an icon and returns a structure containing
	 * information such as the filename of the icon.
	 * The icon can then be rendered into a pixbuf using
	 * gtk_icon_info_load_icon().
	 * Since 2.14
	 * Params:
	 * icon =  the GIcon to look up
	 * size =  desired icon size
	 * flags =  flags modifying the behavior of the icon lookup
	 * Returns: a GtkIconInfo structure containing  information about the icon, or NULL if the icon  wasn't found. Free with gtk_icon_info_free()
	 */
	public IconInfo lookupByGicon(IconIF icon, int size, GtkIconLookupFlags flags);
	
	/**
	 * Looks up an icon in an icon theme, scales it to the given size
	 * and renders it into a pixbuf. This is a convenience function;
	 * if more details about the icon are needed, use
	 * gtk_icon_theme_lookup_icon() followed by gtk_icon_info_load_icon().
	 * Note that you probably want to listen for icon theme changes and
	 * update the icon. This is usually done by connecting to the
	 * GtkWidget::style-set signal. If for some reason you do not want to
	 * update the icon when the icon theme changes, you should consider
	 * using gdk_pixbuf_copy() to make a private copy of the pixbuf
	 * returned by this function. Otherwise GTK+ may need to keep the old
	 * icon theme loaded, which would be a waste of memory.
	 * Since 2.4
	 * Params:
	 * iconName =  the name of the icon to lookup
	 * size =  the desired icon size. The resulting icon may not be
	 *  exactly this size; see gtk_icon_info_load_icon().
	 * flags =  flags modifying the behavior of the icon lookup
	 * Returns: the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use g_object_unref() to release your reference to the icon. NULL if the icon isn't found.
	 * Throws: GException on failure.
	 */
	public Pixbuf loadIcon(string iconName, int size, GtkIconLookupFlags flags);
	
	/**
	 * Gets the list of contexts available within the current
	 * hierarchy of icon themes
	 * Since 2.12
	 * Returns: a GList list holding the names of all the contexts in the theme. You must first free each element in the list with g_free(), then free the list itself with g_list_free().
	 */
	public ListG listContexts();
	
	/**
	 * Lists the icons in the current icon theme. Only a subset
	 * of the icons can be listed by providing a context string.
	 * The set of values for the context string is system dependent,
	 * but will typically include such values as "Applications" and
	 * "MimeTypes".
	 * Since 2.4
	 * Params:
	 * context =  a string identifying a particular type of icon,
	 *  or NULL to list all icons.
	 * Returns: a GList list holding the names of all the icons in the theme. You must first free each element in the list with g_free(), then free the list itself with g_list_free().
	 */
	public ListG listIcons(string context);
	
	/**
	 * Returns an array of integers describing the sizes at which
	 * the icon is available without scaling. A size of -1 means
	 * that the icon is available in a scalable format. The array
	 * is zero-terminated.
	 * Since 2.6
	 * Params:
	 * iconName =  the name of an icon
	 * Returns: An newly allocated array describing the sizes atwhich the icon is available. The array should be freed with g_free()when it is no longer needed.
	 */
	public int* getIconSizes(string iconName);
	
	/**
	 * Gets the name of an icon that is representative of the
	 * current theme (for instance, to use when presenting
	 * a list of themes to the user.)
	 * Since 2.4
	 * Returns: the name of an example icon or NULL. Free with g_free().
	 */
	public string getExampleIconName();
	
	/**
	 * Checks to see if the icon theme has changed; if it has, any
	 * currently cached information is discarded and will be reloaded
	 * next time icon_theme is accessed.
	 * Since 2.4
	 * Returns: TRUE if the icon theme has changed and needed to be reloaded.
	 */
	public int rescanIfNeeded();
	
	/**
	 * Registers a built-in icon for icon theme lookups. The idea
	 * of built-in icons is to allow an application or library
	 * that uses themed icons to function requiring files to
	 * be present in the file system. For instance, the default
	 * images for all of GTK+'s stock icons are registered
	 * as built-icons.
	 * In general, if you use gtk_icon_theme_add_builtin_icon()
	 * you should also install the icon in the icon theme, so
	 * that the icon is generally available.
	 * This function will generally be used with pixbufs loaded
	 * via gdk_pixbuf_new_from_inline().
	 * Since 2.4
	 * Params:
	 * iconName =  the name of the icon to register
	 * size =  the size at which to register the icon (different
	 *  images can be registered for the same icon name
	 *  at different sizes.)
	 * pixbuf =  GdkPixbuf that contains the image to use
	 *  for icon_name.
	 */
	public static void addBuiltinIcon(string iconName, int size, Pixbuf pixbuf);
}
