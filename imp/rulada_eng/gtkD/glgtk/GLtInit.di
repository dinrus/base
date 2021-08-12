
module gtkD.glgtk.GLtInit;

public  import gtkD.gtkglc.glgtktypes;

private import gtkD.gtkglc.glgtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 */
public class GLtInit
{
	
	/**
	 */
	
	/**
	 * Call this function before using any other GtkGLExt functions in your
	 * applications. It will initialize everything needed to operate the library
	 * and parses some standard command line options. argc and
	 * argv are adjusted accordingly so your own code will
	 * never see those standard arguments.
	 * Note
	 * This function will terminate your program if it was unable to initialize
	 * the library for some reason. If you want your program to fall back to a
	 * textual interface you want to call gtk_gl_init_check() instead.
	 * Params:
	 * argv =  Address of the argv parameter of
	 *  main(). Any parameters understood by
	 *  gtk_gl_init() are stripped before return.
	 */
	public static void init(inout string[] argv);
	
	/**
	 * This function does the same work as gtk_gl_init() with only
	 * a single change: It does not terminate the program if the library can't be
	 * initialized. Instead it returns FALSE on failure.
	 * This way the application can fall back to some other means of communication
	 * with the user - for example a curses or command line interface.
	 * Params:
	 * argv =  Address of the argv parameter of
	 *  main(). Any parameters understood by
	 *  gtk_gl_init() are stripped before return.
	 * Returns: TRUE if the GUI has been successfully initialized,  FALSE otherwise.
	 */
	public static int initCheck(inout string[] argv);
	
	/**
	 * Parses command line arguments, and initializes global
	 * attributes of GtkGLExt.
	 * Any arguments used by GtkGLExt are removed from the array and
	 * argc and argv are updated accordingly.
	 * You shouldn't call this function explicitely if you are using
	 * gtk_gl_init(), or gtk_gl_init_check().
	 * Params:
	 * argv =  the array of command line arguments.
	 * Returns: TRUE if initialization succeeded, otherwise FALSE.<<PartIII.GtkGLExt API ReferenceOpenGL-Capable Widget>>
	 */
	public static int parseArgs(inout string[] argv);
}
