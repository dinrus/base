module gtkD.gstreamer.Bin;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gstreamer.Element;
private import gtkD.gstreamer.Iterator;



private import gtkD.gstreamer.Element;

/**
 * Description
 * GstBin is an element that can contain other GstElement, allowing them to be
 * managed as a group.
 * Pads from the child elements can be ghosted to the bin, see GstGhostPad.
 * This makes the bin look like any other elements and enables creation of
 * higher-level abstraction elements.
 * A new GstBin is created with gst_bin_new(). Use a GstPipeline instead if you
 * want to create a toplevel bin because a normal bin doesn't have a bus or
 * handle clock distribution of its own.
 * After the bin has been created you will typically add elements to it with
 * gst_bin_add(). You can remove elements with gst_bin_remove().
 * An element can be retrieved from a bin with gst_bin_get_by_name(), using the
 * elements name. gst_bin_get_by_name_recurse_up() is mainly used for internal
 * purposes and will query the parent bins when the element is not found in the
 * current bin.
 * An iterator of elements in a bin can be retrieved with
 * gst_bin_iterate_elements(). Various other iterators exist to retrieve the
 * elements in a bin.
 * gst_object_unref() is used to drop your reference to the bin.
 * The element-added signal is
 * fired whenever a new element is added to the bin. Likewise the element-removed signal is fired
 * whenever an element is removed from the bin.
 * Notes
 * A GstBin internally intercepts every GstMessage posted by its children and
 * implements the following default behaviour for each of them:
 * GST_MESSAGE_EOS
 * This message is only posted by sinks in the PLAYING
 *  state. If all sinks posted the EOS message, this bin will post and EOS
 *  message upwards.
 * GST_MESSAGE_SEGMENT_START
 * just collected and never forwarded upwards.
 *  The messages are used to decide when all elements have completed playback
 *  of their segment.
 * GST_MESSAGE_SEGMENT_DONE
 *  Is posted by GstBin when all elements that posted
 *  a SEGMENT_START have posted a SEGMENT_DONE.
 * GST_MESSAGE_DURATION
 *  Is posted by an element that detected a change
 *  in the stream duration. The default bin behaviour is to clear any
 *  cached duration values so that the next duration query will perform
 *  a full duration recalculation. The duration change is posted to the
 *  application so that it can refetch the new duration with a duration
 *  query.
 * GST_MESSAGE_CLOCK_LOST
 *  This message is posted by an element when it
 *  can no longer provide a clock. The default bin behaviour is to
 *  check if the lost clock was the one provided by the bin. If so and
 *  the bin is currently in the PLAYING state, the message is forwarded to
 *  the bin parent.
 *  This message is also generated when a clock provider is removed from
 *  the bin. If this message is received by the application, it should
 *  PAUSE the pipeline and set it back to PLAYING to force a new clock
 *  distribution.
 * GST_MESSAGE_CLOCK_PROVIDE
 *  This message is generated when an element
 *  can provide a clock. This mostly happens when a new clock
 *  provider is added to the bin. The default behaviour of the bin is to
 *  mark the currently selected clock as dirty, which will perform a clock
 *  recalculation the next time the bin is asked to provide a clock.
 *  This message is never sent tot the application but is forwarded to
 *  the parent of the bin.
 * OTHERS
 *  posted upwards.
 * A GstBin implements the following default behaviour for answering to a
 * GstQuery:
 * GST_QUERY_DURATION
 * If the query has been asked before with the same format
 *  and the bin is a toplevel bin (ie. has no parent),
 *  use the cached previous value. If no previous value was cached, the
 *  query is sent to all sink elements in the bin and the MAXIMUM of all
 *  values is returned. If the bin is a toplevel bin the value is cached.
 *  If no sinks are available in the bin, the query fails.
 * GST_QUERY_POSITION
 * The query is sent to all sink elements in the bin and the
 *  MAXIMUM of all values is returned. If no sinks are available in the bin,
 *  the query fails.
 * OTHERS
 * the query is forwarded to all sink elements, the result
 *  of the first sink that answers the query successfully is returned. If no
 *  sink is in the bin, the query fails.
 * A GstBin will by default forward any event sent to it to all sink elements.
 * If all the sinks return TRUE, the bin will also return TRUE, else FALSE is
 * returned. If no sinks are in the bin, the event handler will return TRUE.
 * Last reviewed on 2006-04-28 (0.10.6)
 */
public class Bin : Element
{
	
	/** the main Gtk struct */
	protected GstBin* gstBin;
	
	
	public GstBin* getBinStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstBin* gstBin);
	
	/**
	 * Creates a new bin with the given name.
	 * Params:
	 *  name = the name of the new bin
	 * Returns:
	 *  a new GstBin
	 */
	public this(string name);
	
	/** */
	public this(Element elem);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Element, Bin)[] onElementAddedListeners;
	/**
	 * Will be emitted after the element was added to the bin.
	 */
	void addOnElementAdded(void delegate(Element, Bin) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackElementAdded(GstBin* binStruct, GstElement* element, Bin bin);
	
	void delegate(Element, Bin)[] onElementRemovedListeners;
	/**
	 * Will be emitted after the element was removed from the bin.
	 */
	void addOnElementRemoved(void delegate(Element, Bin) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackElementRemoved(GstBin* binStruct, GstElement* element, Bin bin);
	
	
	/**
	 * Adds the given element to the bin. Sets the element's parent, and thus
	 * takes ownership of the element. An element can only be added to one bin.
	 * If the element's pads are linked to other pads, the pads will be unlinked
	 * before the element is added to the bin.
	 * MT safe.
	 * Params:
	 * element =  the GstElement to add
	 * Returns: TRUE if the element could be added, FALSE ifthe bin does not want to accept the element.
	 */
	public int add(Element element);
	
	/**
	 * Removes the element from the bin, unparenting it as well.
	 * Unparenting the element means that the element will be dereferenced,
	 * so if the bin holds the only reference to the element, the element
	 * will be freed in the process of removing it from the bin. If you
	 * want the element to still exist after removing, you need to call
	 * gst_object_ref() before removing it from the bin.
	 * If the element's pads are linked to other pads, the pads will be unlinked
	 * before the element is removed from the bin.
	 * MT safe.
	 * Params:
	 * element =  the GstElement to remove
	 * Returns: TRUE if the element could be removed, FALSE ifthe bin does not want to remove the element.
	 */
	public int remove(Element element);
	
	/**
	 * Gets the element with the given name from a bin. This
	 * function recurses into child bins.
	 * Returns NULL if no element with the given name is found in the bin.
	 * MT safe. Caller owns returned reference.
	 * Params:
	 * name =  the element name to search for
	 * Returns: the GstElement with the given name, or NULL
	 */
	public Element getByName(string name);
	
	/**
	 * Gets the element with the given name from this bin. If the
	 * element is not found, a recursion is performed on the parent bin.
	 * Params:
	 * name =  the element name to search for
	 * Returns: the GstElement with the given name, or NULL
	 */
	public Element getByNameRecurseUp(string name);
	
	/**
	 * Looks for an element inside the bin that implements the given
	 * interface. If such an element is found, it returns the element.
	 * You can cast this element to the given interface afterwards. If you want
	 * all elements that implement the interface, use
	 * gst_bin_iterate_all_by_interface(). This function recurses into child bins.
	 * MT safe. Caller owns returned reference.
	 * Params:
	 * iface =  the GType of an interface
	 * Returns: A GstElement inside the bin implementing the interface
	 */
	public Element getByInterface(GType iface);
	
	/**
	 * Gets an iterator for the elements in this bin.
	 * Each element yielded by the iterator will have its refcount increased, so
	 * unref after use.
	 * MT safe. Caller owns returned value.
	 * Returns: a GstIterator of GstElement, or NULL
	 */
	public Iterator iterateElements();
	
	/**
	 * Gets an iterator for the elements in this bin.
	 * This iterator recurses into GstBin children.
	 * Each element yielded by the iterator will have its refcount increased, so
	 * unref after use.
	 * MT safe. Caller owns returned value.
	 * Returns: a GstIterator of GstElement, or NULL
	 */
	public Iterator iterateRecurse();
	
	/**
	 * Gets an iterator for all elements in the bin that have the
	 * GST_ELEMENT_IS_SINK flag set.
	 * Each element yielded by the iterator will have its refcount increased, so
	 * unref after use.
	 * MT safe. Caller owns returned value.
	 * Returns: a GstIterator of GstElement, or NULL
	 */
	public Iterator iterateSinks();
	
	/**
	 * Gets an iterator for the elements in this bin in topologically
	 * sorted order. This means that the elements are returned from
	 * the most downstream elements (sinks) to the sources.
	 * This function is used internally to perform the state changes
	 * of the bin elements.
	 * Each element yielded by the iterator will have its refcount increased, so
	 * unref after use.
	 * MT safe. Caller owns returned value.
	 * Returns: a GstIterator of GstElement, or NULL
	 */
	public Iterator iterateSorted();
	
	/**
	 * Gets an iterator for all elements in the bin that have no sinkpads and have
	 * the GST_ELEMENT_IS_SINK flag unset.
	 * Each element yielded by the iterator will have its refcount increased, so
	 * unref after use.
	 * MT safe. Caller owns returned value.
	 * Returns: a GstIterator of GstElement, or NULL
	 */
	public Iterator iterateSources();
	
	/**
	 * Looks for all elements inside the bin that implements the given
	 * interface. You can safely cast all returned elements to the given interface.
	 * The function recurses inside child bins. The iterator will yield a series
	 * of GstElement that should be unreffed after use.
	 * Each element yielded by the iterator will have its refcount increased, so
	 * unref after use.
	 * MT safe. Caller owns returned value.
	 * Params:
	 * iface =  the GType of an interface
	 * Returns: a GstIterator of GstElement for all elements in the bin implementing the given interface, or NULL
	 */
	public Iterator iterateAllByInterface(GType iface);
	
	/**
	 * Recursively looks for elements with an unconnected pad of the given
	 * direction within the specified bin and returns an unconnected pad
	 * if one is found, or NULL otherwise. If a pad is found, the caller
	 * owns a reference to it and should use gst_object_unref() on the
	 * pad when it is not needed any longer.
	 * Params:
	 * direction =  whether to look for an unconnected source or sink pad
	 * Returns: unconnected pad of the given direction, or NULL.Since 0.10.3
	 */
	public GstPad* findUnconnectedPad(GstPadDirection direction);
}
