
module gtkD.gdk.Selection;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;


private import gtkD.gdk.Window;
private import gtkD.gdk.Display;




/**
 * Description
 * The X selection mechanism provides a way to transfer
 * arbitrary chunks of data between programs.
 * A selection is a essentially
 * a named clipboard, identified by a string interned
 * as a GdkAtom. By claiming ownership of a selection,
 * an application indicates that it will be responsible
 * for supplying its contents. The most common
 * selections are PRIMARY and
 * CLIPBOARD.
 * The contents of a selection can be represented in
 * a number of formats, called targets.
 * Each target is identified by an atom. A list of
 * all possible targets supported by the selection owner
 * can be retrieved by requesting the special target
 * TARGETS. When a selection is
 * retrieved, the data is accompanied by a type
 * (an atom), and a format (an integer, representing
 * the number of bits per item).
 * See Properties and Atoms
 * for more information.
 * The functions in this section only contain the lowlevel
 * parts of the selection protocol. A considerably more
 * complicated implementation is needed on top of this.
 * GTK+ contains such an implementation in the functions
 * in gtkselection.h and programmers
 * should use those functions instead of the ones presented
 * here. If you plan to implement selection handling
 * directly on top of the functions here, you should refer
 * to the X Inter-client Communication Conventions Manual
 * (ICCCM).
 */
public class Selection
{
	
	/**
	 */
	
	/**
	 * Sets the owner of the given selection.
	 * Params:
	 * owner = a GdkWindow or NULL to indicate that the
	 *  the owner for the given should be unset.
	 * selection = an atom identifying a selection.
	 * time = timestamp to use when setting the selection.
	 *  If this is older than the timestamp given last
	 *  time the owner was set for the given selection, the
	 *  request will be ignored.
	 * sendEvent = if TRUE, and the new owner is different
	 *  from the current owner, the current owner
	 *  will be sent a SelectionClear event.
	 * Returns:%TRUE if the selection owner was successfully changed to owner, otherwise FALSE.
	 */
	public static int ownerSet(Window owner, GdkAtom selection, uint time, int sendEvent);
	
	/**
	 * Sets the GdkWindow owner as the current owner of the selection selection.
	 * Since 2.2
	 * Params:
	 * display =  the GdkDisplay.
	 * owner =  a GdkWindow or NULL to indicate that the owner for
	 *  the given should be unset.
	 * selection =  an atom identifying a selection.
	 * time =  timestamp to use when setting the selection.
	 *  If this is older than the timestamp given last time the owner was
	 *  set for the given selection, the request will be ignored.
	 * sendEvent =  if TRUE, and the new owner is different from the current
	 *  owner, the current owner will be sent a SelectionClear event.
	 * Returns: TRUE if the selection owner was successfully changed to owner, otherwise FALSE.
	 */
	public static int ownerSetForDisplay(Display display, Window owner, GdkAtom selection, uint time, int sendEvent);
	
	/**
	 * Determines the owner of the given selection.
	 * Params:
	 * selection = an atom indentifying a selection.
	 * Returns:if there is a selection owner for this window, and it is a window known to the current process, the GdkWindow that owns the selection, otherwise NULL. Note that the return value may be owned by a different process if a foreign window was previously created for that window, but a new foreign window will never be created by this call.
	 */
	public static Window ownerGet(GdkAtom selection);
	
	/**
	 * Determine the owner of the given selection.
	 * Note that the return value may be owned by a different
	 * process if a foreign window was previously created for that
	 * window, but a new foreign window will never be created by this call.
	 * Since 2.2
	 * Params:
	 * display =  a GdkDisplay.
	 * selection =  an atom indentifying a selection.
	 * Returns: if there is a selection owner for this window, and it is a  window known to the current process, the GdkWindow that owns the  selection, otherwise NULL.
	 */
	public static Window ownerGetForDisplay(Display display, GdkAtom selection);
	
	/**
	 * Retrieves the contents of a selection in a given
	 * form.
	 * Params:
	 * requestor = a GdkWindow.
	 * selection = an atom identifying the selection to get the
	 *  contents of.
	 * target = the form in which to retrieve the selection.
	 * time = the timestamp to use when retrieving the
	 *  selection. The selection owner may refuse the
	 *  request if it did not own the selection at
	 *  the time indicated by the timestamp.
	 */
	public static void convert(Window requestor, GdkAtom selection, GdkAtom target, uint time);
	
	/**
	 * Retrieves selection data that was stored by the selection
	 * data in response to a call to gdk_selection_convert(). This function
	 * will not be used by applications, who should use the GtkClipboard
	 * API instead.
	 * Params:
	 * requestor =  the window on which the data is stored
	 * data =  location to store a pointer to the retrieved data.
	 *  If the retrieval failed, NULL we be stored here, otherwise, it
	 *  will be non-NULL and the returned data should be freed with g_free()
	 *  when you are finished using it. The length of the
	 *  allocated memory is one more than the length
	 *  of the returned data, and the final byte will always
	 *  be zero, to ensure nul-termination of strings.
	 * propType =  location to store the type of the property.
	 * propFormat =  location to store the format of the property.
	 * Returns: the length of the retrieved data.
	 */
	public static int propertyGet(Window requestor, char** data, GdkAtom* propType, int* propFormat);
	
	/**
	 * Sends a response to SelectionRequest event.
	 * Params:
	 * requestor = window to which to deliver response.
	 * selection = selection that was requested.
	 * target = target that was selected.
	 * property = property in which the selection owner stored the
	 *  data, or GDK_NONE to indicate that the request
	 *  was rejected.
	 * time = timestamp.
	 */
	public static void sendNotify(GdkNativeWindow requestor, GdkAtom selection, GdkAtom target, GdkAtom property, uint time);
	
	/**
	 * Send a response to SelectionRequest event.
	 * Since 2.2
	 * Params:
	 * display =  the GdkDisplay where requestor is realized
	 * requestor =  window to which to deliver response.
	 * selection =  selection that was requested.
	 * target =  target that was selected.
	 * property =  property in which the selection owner stored the data,
	 *  or GDK_NONE to indicate that the request was rejected.
	 * time =  timestamp.
	 */
	public static void sendNotifyForDisplay(Display display, GdkNativeWindow requestor, GdkAtom selection, GdkAtom target, GdkAtom property, uint time);
}
