module gtkD.gstreamer.gstreamer;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;

private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;

private import gtkD.glib.Str;




/**
 * Description
 * GStreamer is a framework for constructing graphs of various filters
 * (termed elements here) that will handle streaming media. Any discreet
 * (packetizable) media type is supported, with provisions for automatically
 * determining source type. Formatting/framing information is provided with
 * a powerful negotiation framework. Plugins are heavily used to provide for
 * all elements, allowing one to construct plugins outside of the GST
 * library, even released binary-only if license require (please don't).
 * GStreamer borrows heavily from both the OGI media pipeline and
 * Microsoft's DirectShow, hopefully taking the best of both and leaving the
 * cruft behind. Its interface is slowly getting stable.
 * The GStreamer library should be initialized with
 * gst_init() before it can be used. You should pass pointers to the main argc
 * and argv variables so that GStreamer can process its own command line
 * options, as shown in the following example.
 * Example1.Initializing the gstreamer library
 * int
 * main (int argc, char *argv[])
 * {
	 *  // initialize the GStreamer library
	 *  gst_init (argc, argv);
	 *  ...
 * }
 * It's allowed to pass two NULL pointers to gst_init() in case you don't want
 * to pass the command line args to GStreamer.
 * You can also use GOption to initialize your own parameters as shown in
 * the next code fragment:
 * Example2.Initializing own parameters when initializing gstreamer
 * static gboolean stats = FALSE;
 * ...
 * int
 * main (int argc, char *argv[])
 * {
	 *  GOptionEntry options[] = {
		 *  {"tags", 't', 0, G_OPTION_ARG_NONE, tags,
		 *  N_("Output tags (also known as metadata)"), NULL},
	 *  {NULL}
 *  };
 *  // must initialise the threading system before using any other GLib funtion
 *  if (!g_thread_supported())
 *  g_thread_init (NULL);
 *  ctx = g_option_context_new ("[ADDITIONAL ARGUMENTS]");
 *  g_option_context_add_main_entries (ctx, options, GETTEXT_PACKAGE);
 *  g_option_context_add_group (ctx, gst_init_get_option_group());
 *  if (!g_option_context_parse (ctx, argc, argv, err)) {
	 *  g_print ("Error initializing: %s\n", GST_STR_NULL (err->message));
	 *  exit (1);
 *  }
 *  g_option_context_free (ctx);
 * ...
 * }
 * Use gst_version() to query the library version at runtime or use the
 * GST_VERSION_* macros to find the version at compile time. Optionally
 * gst_version_string() returns a printable string.
 * The gst_deinit() call is used to clean up all internal resources used
 * by GStreamer. It is mostly used in unit tests
 * to check for leaks.
 * Last reviewed on 2006-08-11 (0.10.10)
 */
public class GStreamer
{
	
	/**
	 * Call this function before using any other GStreamer functions in your applications.
	 */
	public static void init(string[] args) ;
	
	/**
	 */
	
	/**
	 * Initializes the GStreamer library, setting up internal path lists,
	 * registering built-in elements, and loading standard plugins.
	 * This function will return FALSE if GStreamer could not be initialized
	 * for some reason. If you want your program to fail fatally,
	 * use gst_init() instead.
	 * This function should be called before calling any other GLib functions. If
	 * this is not an option, your program must initialise the GLib thread system
	 * using g_thread_init() before any other GLib functions are called.
	 * Params:
	 * argc =  pointer to application's argc
	 * argv =  pointer to application's argv
	 * Returns: TRUE if GStreamer could be initialized.
	 * Throws: GException on failure.
	 */
	public static int initCheck(int* argc, char**[] argv);
	
	/**
	 * Returns a GOptionGroup with GStreamer's argument specifications. The
	 * group is set up to use standard GOption callbacks, so when using this
	 * group in combination with GOption parsing methods, all argument parsing
	 * and initialization is automated.
	 * This function is useful if you want to integrate GStreamer with other
	 * libraries that use GOption (see g_option_context_add_group() ).
	 * If you use this function, you should make sure you initialise the GLib
	 * threading system as one of the very first things in your program
	 * (see the example at the beginning of this section).
	 * Returns: a pointer to GStreamer's option group.
	 */
	public static GOptionGroup* initGetOptionGroup();
	
	/**
	 * Clean up any resources created by GStreamer in gst_init().
	 * It is normally not needed to call this function in a normal application
	 * as the resources will automatically be freed when the program terminates.
	 * This function is therefore mostly used by testsuites and other memory
	 * profiling tools.
	 * After this call GStreamer (including this method) should not be used anymore.
	 */
	public static void deinit();
	
	/**
	 * Gets the version number of the GStreamer library.
	 * Params:
	 * major =  pointer to a guint to store the major version number
	 * minor =  pointer to a guint to store the minor version number
	 * micro =  pointer to a guint to store the micro version number
	 * nano =  pointer to a guint to store the nano version number
	 */
	public static void versio(uint* major, uint* minor, uint* micro, uint* nano);
	
	/**
	 * This function returns a string that is useful for describing this version
	 * of GStreamer to the outside world: user agent strings, logging, ...
	 * Returns: a newly allocated string describing this version of GStreamer.
	 */
	public static string versionString();
	
	/**
	 * Some functions in the GStreamer core might install a custom SIGSEGV handler
	 * to better catch and report errors to the application. Currently this feature
	 * is enabled by default when loading plugins.
	 * Applications might want to disable this behaviour with the
	 * gst_segtrap_set_enabled() function. This is typically done if the application
	 * wants to install its own handler without GStreamer interfering.
	 * Returns: TRUE if GStreamer is allowed to install a custom SIGSEGV handler.Since 0.10.10
	 */
	public static int segtrapIsEnabled();
	
	/**
	 * Applications might want to disable/enable the SIGSEGV handling of
	 * the GStreamer core. See gst_segtrap_is_enabled() for more information.
	 * Params:
	 * enabled =  whether a custom SIGSEGV handler should be installed.
	 * Since 0.10.10
	 */
	public static void segtrapSetEnabled(int enabled);
	
	/**
	 * By default GStreamer will perform a fork() when scanning and rebuilding the
	 * registry file.
	 * Applications might want to disable this behaviour with the
	 * gst_registry_fork_set_enabled() function.
	 * Returns: TRUE if GStreamer will use fork() when rebuilding the registry. Onplatforms without fork(), this function will always return FALSE.Since 0.10.10
	 */
	public static int registryForkIsEnabled();
	
	/**
	 * Applications might want to disable/enable the usage of fork() when rebuilding
	 * the registry. See gst_registry_fork_is_enabled() for more information.
	 * On platforms without fork(), this function will have no effect on the return
	 * value of gst_registry_fork_is_enabled().
	 * Params:
	 * enabled =  whether rebuilding the registry may fork
	 * Since 0.10.10
	 */
	public static void registryForkSetEnabled(int enabled);
	
	/**
	 * Forces GStreamer to re-scan its plugin paths and update the default
	 * plugin registry.
	 * Applications will almost never need to call this function, it is only
	 * useful if the application knows new plugins have been installed (or old
	 * ones removed) since the start of the application (or, to be precise, the
	 * first call to gst_init()) and the application wants to make use of any
	 * newly-installed plugins without restarting the application.
	 * Applications should assume that the registry update is neither atomic nor
	 * thread-safe and should therefore not have any dynamic pipelines running
	 * (including the playbin and decodebin elements) and should also not create
	 * any elements or access the GStreamer registry while the update is in
	 * progress.
	 * Note that this function may block for a significant amount of time.
	 * Returns: TRUE if the registry has been updated successfully (does not imply that there were changes), otherwise FALSE.Since 0.10.12
	 */
	public static int updateRegistry();
}
