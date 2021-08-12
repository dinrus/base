module gtkD.gdk.Device;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ListG;
private import gtkD.gdk.Window;




/**
 * Description
 * In addition to the normal keyboard and mouse input devices, GTK+ also
 * contains support for extended input devices. In
 * particular, this support is targeted at graphics tablets. Graphics
 * tablets typically return sub-pixel positioning information and possibly
 * information about the pressure and tilt of the stylus. Under
 * X, the support for extended devices is done through the
 * XInput extension.
 * Because handling extended input devices may involve considerable
 * overhead, they need to be turned on for each GdkWindow
 * individually using gdk_input_set_extension_events().
 * (Or, more typically, for GtkWidgets, using gtk_widget_set_extension_events()).
 * As an additional complication, depending on the support from
 * the windowing system, its possible that a normal mouse
 * cursor will not be displayed for a particular extension
 * device. If an application does not want to deal with displaying
 * a cursor itself, it can ask only to get extension events
 * from devices that will display a cursor, by passing the
 * GDK_EXTENSION_EVENTS_CURSOR value to
 * gdk_input_set_extension_events(). Otherwise, the application
 * must retrieve the device information using gdk_devices_list(),
 * check the has_cursor field, and,
 * if it is FALSE, draw a cursor itself when it receives
 * motion events.
 * Each pointing device is assigned a unique integer ID; events from a
 * particular device can be identified by the
 * deviceid field in the event structure. The
 * events generated by pointer devices have also been extended to contain
 * pressure, xtilt
 * and ytilt fields which contain the extended
 * information reported as additional valuators
 * from the device. The pressure field is a
 * a double value ranging from 0.0 to 1.0, while the tilt fields are
 * double values ranging from -1.0 to 1.0. (With -1.0 representing the
 * maximum tilt to the left or up, and 1.0 representing the maximum
 * tilt to the right or down.)
 * One additional field in each event is the
 * source field, which contains an
 * enumeration value describing the type of device; this currently
 * can be one of GDK_SOURCE_MOUSE, GDK_SOURCE_PEN, GDK_SOURCE_ERASER,
 * or GDK_SOURCE_CURSOR. This field is present to allow simple
 * applications to (for instance) delete when they detect eraser
 * devices without having to keep track of complicated per-device
 * settings.
 * Various aspects of each device may be configured. The easiest way of
 * creating a GUI to allow the user to configure such a device
 * is to use the GtkInputDialog widget in GTK+.
 * However, even when using this widget, application writers
 * will need to directly query and set the configuration parameters
 * in order to save the state between invocations of the application.
 * The configuration of devices is queried using gdk_devices_list().
 * Each device must be activated using gdk_device_set_mode(), which
 * also controls whether the device's range is mapped to the
 * entire screen or to a single window. The mapping of the valuators of
 * the device onto the predefined valuator types is set using
 * gdk_device_set_axis_use(). And the source type for each device
 * can be set with gdk_device_set_source().
 * Devices may also have associated keys
 * or macro buttons. Such keys can be globally set to map
 * into normal X keyboard events. The mapping is set using
 * gdk_device_set_key().
 * The interfaces in this section will most likely be considerably
 * modified in the future to accomodate devices that may have different
 * sets of additional valuators than the pressure xtilt
 * and ytilt.
 */
public class Device
{
	
	/** the main Gtk struct */
	protected GdkDevice* gdkDevice;
	
	
	public GdkDevice* getDeviceStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkDevice* gdkDevice);
	
	/**
	 * Obtains the motion history for a device; given a starting and
	 * ending timestamp, return all events in the motion history for
	 * the device in the given range of time. Some windowing systems
	 * do not support motion history, in which case, FALSE will
	 * be returned. (This is not distinguishable from the case where
	 * motion history is supported and no events were found.)
	 * Params:
	 * window =  the window with respect to which which the event coordinates will be reported
	 * start =  starting timestamp for range of events to return
	 * stop =  ending timestamp for the range of events to return
	 * events =  location to store a newly-allocated array of GdkTimeCoord, or NULL
	 * Returns: TRUE if the windowing system supports motion history and at least one event was found.
	 */
	public int getHistory(Window window, uint start, uint stop, out GdkTimeCoord*[] events);
	
	/**
	 */
	
	/**
	 * Returns the list of available input devices for the default display.
	 * The list is statically allocated and should not be freed.
	 * Returns: a list of GdkDevice
	 */
	public static ListG gdkDevicesList();
	
	/**
	 * Sets the source type for an input device.
	 * Params:
	 * source = the source type.
	 */
	public void setSource(GdkInputSource source);
	
	/**
	 * Sets a the mode of an input device. The mode controls if the
	 * device is active and whether the device's range is mapped to the
	 * entire screen or to a single window.
	 * Params:
	 * mode = the input mode.
	 * Returns:%TRUE if the mode was successfully changed.
	 */
	public int setMode(GdkInputMode mode);
	
	/**
	 * Specifies the X key event to generate when a macro button of a device
	 * is pressed.
	 * Params:
	 * index = the index of the macro button to set.
	 * keyval = the keyval to generate.
	 * modifiers = the modifiers to set.
	 */
	public void setKey(uint index, uint keyval, GdkModifierType modifiers);
	
	/**
	 * Specifies how an axis of a device is used.
	 * Params:
	 * index = the index of the axis.
	 * use = specifies how the axis is used.
	 */
	public void setAxisUse(uint index, GdkAxisUse use);
	
	/**
	 * Returns the core pointer device for the default display.
	 * Returns: the core pointer device; this is owned by the display and should not be freed.
	 */
	public static Device getCorePointer();
	
	/**
	 * Gets the current state of a device.
	 * Params:
	 * window = a GdkWindow.
	 * axes = an array of doubles to store the values of the axes of device in,
	 *  or NULL.
	 * mask = location to store the modifiers, or NULL.
	 */
	public void getState(Window window, double[] axes, out GdkModifierType mask);
	
	/**
	 * Frees an array of GdkTimeCoord that was returned by gdk_device_get_history().
	 * Params:
	 * events = an array of GdkTimeCoord.
	 */
	public static void freeHistory(GdkTimeCoord*[] events);
	
	/**
	 * Interprets an array of double as axis values for a given device,
	 * and locates the value in the array for a given axis use.
	 * Params:
	 * axes =  pointer to an array of axes
	 * use =  the use to look for
	 * value =  location to store the found value.
	 * Returns: TRUE if the given axis use was found, otherwise FALSE
	 */
	public int getAxis(double[] axes, GdkAxisUse use, out double value);
	
	/**
	 * Turns extension events on or off for a particular window,
	 * and specifies the event mask for extension events.
	 * Params:
	 * window = a GdkWindow.
	 * mask = the event mask
	 * mode = the type of extension events that are desired.
	 */
	public static void gdkInputSetExtensionEvents(Window window, int mask, GdkExtensionMode mode);
}
