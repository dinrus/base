module gtkD.gstreamer.ObjectGst;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gobject.ObjectG;
private import gtkD.glib.ErrorG;
private import gtkD.glib.ListG;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GstObject provides a root for the object hierarchy tree filed in by the
 * GStreamer library. It is currently a thin wrapper on top of
 * GObject. It is an abstract class that is not very usable on its own.
 * GstObject gives us basic refcounting, parenting functionality and locking.
 * Most of the function are just extended for special GStreamer needs and can be
 * found under the same name in the base class of GstObject which is GObject
 * (e.g. g_object_ref() becomes gst_object_ref()).
 * The most interesting difference between GstObject and GObject is the
 * "floating" reference count. A GObject is created with a reference count of
 * 1, owned by the creator of the GObject. (The owner of a reference is the
 * code section that has the right to call gst_object_unref() in order to
 * remove that reference.) A GstObject is created with a reference count of 1
 * also, but it isn't owned by anyone; Instead, the initial reference count
 * of a GstObject is "floating". The floating reference can be removed by
 * anyone at any time, by calling gst_object_sink(). gst_object_sink() does
 * nothing if an object is already sunk (has no floating reference).
 * When you add a GstElement to its parent container, the parent container will
 * do this:
 *  gst_object_ref (GST_OBJECT (child_element));
 *  gst_object_sink (GST_OBJECT (child_element));
 * This means that the container now owns a reference to the child element
 * (since it called gst_object_ref()), and the child element has no floating
 * reference.
 * The purpose of the floating reference is to keep the child element alive
 * until you add it to a parent container, which then manages the lifetime of
 * the object itself:
 *  element = gst_element_factory_make (factoryname, name);
 *  // element has one floating reference to keep it alive
 *  gst_bin_add (GST_BIN (bin), element);
 *  // element has one non-floating reference owned by the container
 * Another effect of this is, that calling gst_object_unref() on a bin object,
 * will also destoy all the GstElement objects in it. The same is true for
 * calling gst_bin_remove().
 * Special care has to be taken for all methods that gst_object_sink() an object
 * since if the caller of those functions had a floating reference to the object,
 * the object reference is now invalid.
 * In contrast to GObject instances, GstObject adds a name property. The functions
 * gst_object_set_name() and gst_object_get_name() are used to set/get the name
 * of the object.
 * Last reviewed on 2005-11-09 (0.9.4)
 */
public class ObjectGst : ObjectG
{
	
	/** the main Gtk struct */
	protected GstObject* gstObject;
	
	
	public GstObject* getObjectGstStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstObject* gstObject);
	
	/**
	 * Increments the refence count on object. This function
	 * does not take the lock on object because it relies on
	 * atomic refcounting.
	 * This object returns the input parameter to ease writing
	 * constructs like :
	 *  result = gst_object_ref (object->parent);
	 * Returns:
	 *  A pointer to object
	 */
	public void* reference();
	/*public static void* ref(void* object)
	{
		// gpointer gst_object_ref (gpointer object);
		return gst_object_ref(object);
	}*/
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(ObjectG, GParamSpec*, ObjectGst)[] onDeepNotifyListeners;
	/**
	 * The deep notify signal is used to be notified of property changes. It is
	 * typically attached to the toplevel bin to receive notifications from all
	 * the elements contained in that bin.
	 */
	void addOnDeepNotify(void delegate(ObjectG, GParamSpec*, ObjectGst) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDeepNotify(GstObject* gstobjectStruct, GObject* propObject, GParamSpec* prop, ObjectGst objectGst);
	
	void delegate(gpointer, ObjectGst)[] onObjectSavedListeners;
	/**
	 * Trigered whenever a new object is saved to XML. You can connect to this
	 * signal to insert custom XML tags into the core XML.
	 */
	void addOnObjectSaved(void delegate(gpointer, ObjectGst) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackObjectSaved(GstObject* gstobjectStruct, gpointer xmlNode, ObjectGst objectGst);
	
	void delegate(ObjectG, ObjectGst)[] onParentSetListeners;
	/**
	 * Emitted when the parent of an object is set.
	 */
	void addOnParentSet(void delegate(ObjectG, ObjectGst) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackParentSet(GstObject* gstobjectStruct, GObject* parent, ObjectGst objectGst);
	
	void delegate(ObjectG, ObjectGst)[] onParentUnsetListeners;
	/**
	 * Emitted when the parent of an object is unset.
	 */
	void addOnParentUnset(void delegate(ObjectG, ObjectGst) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackParentUnset(GstObject* gstobjectStruct, GObject* parent, ObjectGst objectGst);
	
	
	/**
	 * Sets the name of object, or gives object a guaranteed unique
	 * name (if name is NULL).
	 * This function makes a copy of the provided name, so the caller
	 * retains ownership of the name it sent.
	 * Params:
	 * name =  new name of object
	 * Returns: TRUE if the name could be set. Since Objects that havea parent cannot be renamed, this function returns FALSE in thosecases.MT safe. This function grabs and releases object's LOCK.
	 */
	public int setName(string name);
	
	/**
	 * Returns a copy of the name of object.
	 * Caller should g_free() the return value after usage.
	 * For a nameless object, this returns NULL, which you can safely g_free()
	 * as well.
	 * Returns: the name of object. g_free() after usage.MT safe. This function grabs and releases object's LOCK.
	 */
	public string getName();
	
	/**
	 * Sets the parent of object to parent. The object's reference count will
	 * be incremented, and any floating reference will be removed (see gst_object_sink()).
	 * This function causes the parent-set signal to be emitted when the parent
	 * was successfully set.
	 * Params:
	 * parent =  new parent of object
	 * Returns: TRUE if parent could be set or FALSE when objectalready had a parent or object and parent are the same.MT safe. Grabs and releases object's LOCK.
	 */
	public int setParent(ObjectGst parent);
	
	/**
	 * Returns the parent of object. This function increases the refcount
	 * of the parent object so you should gst_object_unref() it after usage.
	 * Returns: parent of object, this can be NULL if object has no parent. unref after usage.MT safe. Grabs and releases object's LOCK.
	 */
	public ObjectGst getParent();
	
	/**
	 * Clear the parent of object, removing the associated reference.
	 * This function decreases the refcount of object.
	 * MT safe. Grabs and releases object's lock.
	 */
	public void unparent();
	
	/**
	 * Returns a copy of the name prefix of object.
	 * Caller should g_free() the return value after usage.
	 * For a prefixless object, this returns NULL, which you can safely g_free()
	 * as well.
	 * Returns: the name prefix of object. g_free() after usage.MT safe. This function grabs and releases object's LOCK.
	 */
	public string getNamePrefix();
	
	/**
	 * Sets the name prefix of object to name_prefix.
	 * This function makes a copy of the provided name prefix, so the caller
	 * retains ownership of the name prefix it sent.
	 * MT safe. This function grabs and releases object's LOCK.
	 * Params:
	 * namePrefix =  new name prefix of object
	 */
	public void setNamePrefix(string namePrefix);
	
	/**
	 * A default deep_notify signal callback for an object. The user data
	 * should contain a pointer to an array of strings that should be excluded
	 * from the notify. The default handler will print the new value of the property
	 * using g_print.
	 * MT safe. This function grabs and releases object's LOCK for getting its
	 *  path string.
	 * Params:
	 * object =  the GObject that signalled the notify.
	 * orig =  a GstObject that initiated the notify.
	 * pspec =  a GParamSpec of the property.
	 * excludedProps =  a set of user-specified properties to exclude or
	 *  NULL to show all changes.
	 */
	public static void defaultDeepNotify(ObjectG object, ObjectGst orig, GParamSpec* pspec, char** excludedProps);
	
	/**
	 * A default error function.
	 * The default handler will simply print the error string using g_print.
	 * Params:
	 * error =  the GError.
	 * dbug =  an additional debug information string, or NULL.
	 */
	public void defaultError(ErrorG error, string dbug);
	
	/**
	 * Checks to see if there is any object named name in list. This function
	 * does not do any locking of any kind. You might want to protect the
	 * provided list with the lock of the owner of the list. This function
	 * will lock each GstObject in the list to compare the name, so be
	 * carefull when passing a list with a locked object.
	 * Params:
	 * list =  a list of GstObject to check through
	 * name =  the name to search for
	 * Returns: TRUE if a GstObject named name does not appear in list, FALSE if it does.MT safe. Grabs and releases the LOCK of each object in the list.
	 */
	public static int checkUniqueness(ListG list, string name);
	
	/**
	 * Check if object has an ancestor ancestor somewhere up in
	 * the hierarchy.
	 * Params:
	 * ancestor =  a GstObject to check as ancestor
	 * Returns: TRUE if ancestor is an ancestor of object.MT safe. Grabs and releases object's locks.
	 */
	public int hasAncestor(ObjectGst ancestor);
	
	/**
	 * Decrements the refence count on object. If reference count hits
	 * zero, destroy object. This function does not take the lock
	 * on object as it relies on atomic refcounting.
	 * The unref method should never be called with the LOCK held since
	 * this might deadlock the dispose function.
	 * Params:
	 * object =  a GstObject to unreference
	 */
	public static void unref(void* object);
	
	/**
	 * If object was floating, the GST_OBJECT_FLOATING flag is removed
	 * and object is unreffed. When object was not floating,
	 * this function does nothing.
	 * Any newly created object has a refcount of 1 and is floating.
	 * This function should be used when creating a new object to
	 * symbolically 'take ownership' of object. This done by first doing a
	 * gst_object_ref() to keep a reference to object and then gst_object_sink()
	 * to remove and unref any floating references to object.
	 * Use gst_object_set_parent() to have this done for you.
	 * MT safe. This function grabs and releases object lock.
	 * Params:
	 * object =  a GstObject to sink
	 */
	public static void sink(void* object);
	
	/**
	 * Unrefs the GstObject pointed to by oldobj, refs newobj and
	 * puts newobj in *oldobj. Be carefull when calling this
	 * function, it does not take any locks. You might want to lock
	 * the object owning oldobj pointer before calling this
	 * function.
	 * Make sure not to LOCK oldobj because it might be unreffed
	 * which could cause a deadlock when it is disposed.
	 * Params:
	 * oldobj =  pointer to a place of a GstObject to replace
	 * newobj =  a new GstObject
	 */
	public static void replace(GstObject** oldobj, ObjectGst newobj);
	
	/**
	 * Generates a string describing the path of object in
	 * the object hierarchy. Only useful (or used) for debugging.
	 * Returns: a string describing the path of object. You must g_free() the string after usage.MT safe. Grabs and releases the GstObject's LOCK for all objects in the hierarchy.
	 */
	public string getPathString();
}
