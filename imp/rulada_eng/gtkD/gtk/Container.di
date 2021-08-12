module gtkD.gtk.Container;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.Adjustment;
private import gtkD.glib.ListG;
private import gtkD.gobject.Value;
private import gtkD.gobject.ParamSpec;



private import gtkD.gtk.Widget;

/**
 * Description
 * A GTK+ user interface is constructed by nesting widgets inside widgets.
 * Container widgets are the inner nodes in the resulting tree of widgets:
 * they contain other widgets. So, for example, you might have a GtkWindow
 * containing a GtkFrame containing a GtkLabel. If you wanted an image instead
 * of a textual label inside the frame, you might replace the GtkLabel widget
 * with a GtkImage widget.
 * There are two major kinds of container widgets in GTK+. Both are subclasses
 * of the abstract GtkContainer base class.
 * The first type of container widget has a single child widget and derives
 * from GtkBin. These containers are decorators, which
 * add some kind of functionality to the child. For example, a GtkButton makes
 * its child into a clickable button; a GtkFrame draws a frame around its child
 * and a GtkWindow places its child widget inside a top-level window.
 * The second type of container can have more than one child; its purpose is to
 * manage layout. This means that these containers assign
 * sizes and positions to their children. For example, a GtkHBox arranges its
 * children in a horizontal row, and a GtkTable arranges the widgets it contains
 * in a two-dimensional grid.
 * To fulfill its task, a layout container must negotiate the size requirements
 * with its parent and its children. This negotiation is carried out in two
 * phases, size requisition and size
 * allocation.
 * Size Requisition
 * The size requisition of a widget is it's desired width and height.
 * This is represented by a GtkRequisition.
 * How a widget determines its desired size depends on the widget.
 * A GtkLabel, for example, requests enough space to display all its text.
 * Container widgets generally base their size request on the requisitions
 * of their children.
 * The size requisition phase of the widget layout process operates top-down.
 * It starts at a top-level widget, typically a GtkWindow. The top-level widget
 * asks its child for its size requisition by calling gtk_widget_size_request().
 * To determine its requisition, the child asks its own children for their
 * requisitions and so on. Finally, the top-level widget will get a requisition
 * back from its child.
 * <hr>
 * Size Allocation
 * When the top-level widget has determined how much space its child would like
 * to have, the second phase of the size negotiation, size allocation, begins.
 * Depending on its configuration (see gtk_window_set_resizable()), the top-level
 * widget may be able to expand in order to satisfy the size request or it may
 * have to ignore the size request and keep its fixed size. It then tells its
 * child widget how much space it gets by calling gtk_widget_size_allocate().
 * The child widget divides the space among its children and tells each child
 * how much space it got, and so on. Under normal circumstances, a GtkWindow
 * will always give its child the amount of space the child requested.
 * A child's size allocation is represented by a GtkAllocation. This struct
 * contains not only a width and height, but also a position (i.e. X and Y
 * coordinates), so that containers can tell their children not only how much
 * space they have gotten, but also where they are positioned inside the space
 * available to the container.
 * Widgets are required to honor the size allocation they receive; a size
 * request is only a request, and widgets must be able to cope with any size.
 * <hr>
 * Child properties
 * GtkContainer introduces child
 * properties - these are object properties that are not specific
 * to either the container or the contained widget, but rather to their relation.
 * Typical examples of child properties are the position or pack-type of a widget
 * which is contained in a GtkBox.
 * Use gtk_container_class_install_child_property() to install child properties
 * for a container class and gtk_container_class_find_child_property() or
 * gtk_container_class_list_child_properties() to get information about existing
 * child properties.
 * To set the value of a child property, use gtk_container_child_set_property(),
 * gtk_container_child_set() or gtk_container_child_set_valist().
 * To obtain the value of a child property, use
 * gtk_container_child_get_property(), gtk_container_child_get() or
 * gtk_container_child_get_valist(). To emit notification about child property
 * changes, use gtk_widget_child_notify().
 * <hr>
 * GtkContainer as GtkBuildable
 * The GtkContainer implementation of the GtkBuildable interface
 * supports a <packing> element for children, which can
 * contain multiple <property> elements that specify
 * child properties for the child.
 * Example 52. Child properties in UI definitions
 * <object class="GtkVBox">
 *  <child>
 *  <object class="GtkLabel"/>
 *  <packing>
 *  <property name="pack-type">start</property>
 *  </packing>
 *  </child>
 * </object>
 * Since 2.16, child properties can also be marked as translatable using
 * the same "translatable", "comments" and "context" attributes that are used
 * for regular properties.
 */
public class Container : Widget
{
	
	/** the main Gtk struct */
	protected GtkContainer* gtkContainer;
	
	
	public GtkContainer* getContainerStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkContainer* gtkContainer);
	
	/**
	 * Removes all widgets from the container
	 */
	void removeAll();
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Widget, Container)[] onAddListeners;
	/**
	 */
	void addOnAdd(void delegate(Widget, Container) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackAdd(GtkContainer* containerStruct, GtkWidget* widget, Container container);
	
	void delegate(Container)[] onCheckResizeListeners;
	/**
	 */
	void addOnCheckResize(void delegate(Container) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCheckResize(GtkContainer* containerStruct, Container container);
	
	void delegate(Widget, Container)[] onRemoveListeners;
	/**
	 */
	void addOnRemove(void delegate(Widget, Container) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackRemove(GtkContainer* containerStruct, GtkWidget* widget, Container container);
	
	void delegate(Widget, Container)[] onSetFocusChildListeners;
	/**
	 */
	void addOnSetFocusChild(void delegate(Widget, Container) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSetFocusChild(GtkContainer* containerStruct, GtkWidget* widget, Container container);
	
	
	/**
	 * Adds widget to container. Typically used for simple containers
	 * such as GtkWindow, GtkFrame, or GtkButton; for more complicated
	 * layout containers such as GtkBox or GtkTable, this function will
	 * pick default packing parameters that may not be correct. So
	 * consider functions such as gtk_box_pack_start() and
	 * gtk_table_attach() as an alternative to gtk_container_add() in
	 * those cases. A widget may be added to only one container at a time;
	 * you can't place the same widget inside two different containers.
	 * Params:
	 * widget =  a widget to be placed inside container
	 */
	public void add(Widget widget);
	
	/**
	 * Removes widget from container. widget must be inside container.
	 * Note that container will own a reference to widget, and that this
	 * may be the last reference held; so removing a widget from its
	 * container can destroy that widget. If you want to use widget
	 * again, you need to add a reference to it while it's not inside
	 * a container, using g_object_ref(). If you don't want to use widget
	 * again it's usually more efficient to simply destroy it directly
	 * using gtk_widget_destroy() since this will remove it from the
	 * container and help break any circular reference count cycles.
	 * Params:
	 * widget =  a current child of container
	 */
	public void remove(Widget widget);
	
	/**
	 * Returns the resize mode for the container. See
	 * gtk_container_set_resize_mode().
	 * Returns: the current resize mode
	 */
	public GtkResizeMode getResizeMode();
	
	/**
	 * Sets the resize mode for the container.
	 * The resize mode of a container determines whether a resize request
	 * will be passed to the container's parent, queued for later execution
	 * or executed immediately.
	 * Params:
	 * resizeMode =  the new resize mode
	 */
	public void setResizeMode(GtkResizeMode resizeMode);
	
	/**
	 */
	public void checkResize();
	
	/**
	 * Invokes callback on each non-internal child of container. See
	 * gtk_container_forall() for details on what constitutes an
	 * "internal" child. Most applications should use
	 * gtk_container_foreach(), rather than gtk_container_forall().
	 * Params:
	 * callback =  a callback
	 * callbackData =  callback user data
	 */
	public void foreac(GtkCallback callback, void* callbackData);
	
	/**
	 * Warning
	 * gtk_container_foreach_full is deprecated and should not be used in newly-written code. Use gtk_container_foreach() instead.
	 * Params:
	 */
	public void foreachFull(GtkCallback callback, GtkCallbackMarshal marshal, void* callbackData, GDestroyNotify notify);
	
	/**
	 * Returns the container's non-internal children. See
	 * gtk_container_forall() for details on what constitutes an "internal" child.
	 * Returns: a newly-allocated list of the container's non-internal children.
	 */
	public ListG getChildren();
	
	/**
	 * Sets the reallocate_redraws flag of the container to the given value.
	 * Containers requesting reallocation redraws get automatically
	 * redrawn if any of their children changed allocation.
	 * Params:
	 * needsRedraws =  the new value for the container's reallocate_redraws flag
	 */
	public void setReallocateRedraws(int needsRedraws);
	
	/**
	 * Returns the current focus child widget inside container.
	 * Since 2.14
	 * Returns: The child widget which has the focus inside container, or NULL if none is set.
	 */
	public Widget getFocusChild();
	
	/**
	 * Sets, or unsets if child is NULL, the focused child of container.
	 * This function emits the GtkContainer::set_focus_child signal of
	 * container. Implementations of GtkContainer can override the
	 * default behaviour by overriding the class closure of this signal.
	 * Params:
	 * child =  a GtkWidget, or NULL
	 */
	public void setFocusChild(Widget child);
	
	/**
	 * Retrieves the vertical focus adjustment for the container. See
	 * gtk_container_set_focus_vadjustment().
	 * Returns: the vertical focus adjustment, or NULL if none has been set.
	 */
	public Adjustment getFocusVadjustment();
	
	/**
	 * Hooks up an adjustment to focus handling in a container, so when a
	 * child of the container is focused, the adjustment is scrolled to
	 * show that widget. This function sets the vertical alignment. See
	 * gtk_scrolled_window_get_vadjustment() for a typical way of obtaining
	 * the adjustment and gtk_container_set_focus_hadjustment() for setting
	 * the horizontal adjustment.
	 * The adjustments have to be in pixel units and in the same coordinate
	 * system as the allocation for immediate children of the container.
	 * Params:
	 * adjustment =  an adjustment which should be adjusted when the focus
	 *  is moved among the descendents of container
	 */
	public void setFocusVadjustment(Adjustment adjustment);
	
	/**
	 * Retrieves the horizontal focus adjustment for the container. See
	 * gtk_container_set_focus_hadjustment().
	 * Returns: the horizontal focus adjustment, or NULL if none has been set.
	 */
	public Adjustment getFocusHadjustment();
	
	/**
	 * Hooks up an adjustment to focus handling in a container, so when a child
	 * of the container is focused, the adjustment is scrolled to show that
	 * widget. This function sets the horizontal alignment.
	 * See gtk_scrolled_window_get_hadjustment() for a typical way of obtaining
	 * the adjustment and gtk_container_set_focus_vadjustment() for setting
	 * the vertical adjustment.
	 * The adjustments have to be in pixel units and in the same coordinate
	 * system as the allocation for immediate children of the container.
	 * Params:
	 * adjustment =  an adjustment which should be adjusted when the focus is
	 *  moved among the descendents of container
	 */
	public void setFocusHadjustment(Adjustment adjustment);
	
	/**
	 */
	public void resizeChildren();
	
	/**
	 * Returns the type of the children supported by the container.
	 * Note that this may return G_TYPE_NONE to indicate that no more
	 * children can be added, e.g. for a GtkPaned which already has two
	 * children.
	 * Returns: a GType.
	 */
	public GType childType();

	/**
	 * Gets the value of a child property for child and container.
	 * Params:
	 * child =  a widget which is a child of container
	 * propertyName =  the name of the property to get
	 * value =  a location to return the value
	 */
	public void childGetProperty(Widget child, string propertyName, Value value);
	
	/**
	 * Sets a child property for child and container.
	 * Params:
	 * child =  a widget which is a child of container
	 * propertyName =  the name of the property to set
	 * value =  the value to set the property to
	 */
	public void childSetProperty(Widget child, string propertyName, Value value);
	
	/**
	 * Gets the values of one or more child properties for child and container.
	 * Params:
	 * child =  a widget which is a child of container
	 * firstPropertyName =  the name of the first property to get
	 * varArgs =  return location for the first property, followed
	 *  optionally by more name/return location pairs, followed by NULL
	 */
	public void childGetValist(Widget child, string firstPropertyName, void* varArgs);
	
	/**
	 * Sets one or more child properties for child and container.
	 * Params:
	 * child =  a widget which is a child of container
	 * firstPropertyName =  the name of the first property to set
	 * varArgs =  a NULL-terminated list of property names and values, starting
	 *  with first_prop_name
	 */
	public void childSetValist(Widget child, string firstPropertyName, void* varArgs);
	
	/**
	 * Invokes callback on each child of container, including children
	 * that are considered "internal" (implementation details of the
	 * container). "Internal" children generally weren't added by the user
	 * of the container, but were added by the container implementation
	 * itself. Most applications should use gtk_container_foreach(),
	 * rather than gtk_container_forall().
	 * Params:
	 * callback =  a callback
	 * callbackData =  callback user data
	 */
	public void forall(GtkCallback callback, void* callbackData);
	
	/**
	 * Retrieves the border width of the container. See
	 * gtk_container_set_border_width().
	 * Returns: the current border width
	 */
	public uint getBorderWidth();
	
	/**
	 * Sets the border width of the container.
	 * The border width of a container is the amount of space to leave
	 * around the outside of the container. The only exception to this is
	 * GtkWindow; because toplevel windows can't leave space outside,
	 * they leave the space inside. The border is added on all sides of
	 * the container. To add space to only one side, one approach is to
	 * create a GtkAlignment widget, call gtk_widget_set_size_request()
	 * to give it a size, and place it on the side of the container as
	 * a spacer.
	 * Params:
	 * borderWidth =  amount of blank space to leave outside
	 *  the container. Valid values are in the range 0-65535 pixels.
	 */
	public void setBorderWidth(uint borderWidth);
	
	/**
	 * When a container receives an expose event, it must send synthetic
	 * expose events to all children that don't have their own GdkWindows.
	 * This function provides a convenient way of doing this. A container,
	 * when it receives an expose event, calls gtk_container_propagate_expose()
	 * once for each child, passing in the event the container received.
	 * gtk_container_propagate_expose() takes care of deciding whether
	 * an expose event needs to be sent to the child, intersecting
	 * the event's area with the child area, and sending the event.
	 * In most cases, a container can simply either simply inherit the
	 * "expose" implementation from GtkContainer, or, do some drawing
	 * and then chain to the ::expose implementation from GtkContainer.
	 * Params:
	 * child =  a child of container
	 * event =  a expose event sent to container
	 */
	public void propagateExpose(Widget child, GdkEventExpose* event);
	
	/**
	 * Retrieves the focus chain of the container, if one has been
	 * set explicitly. If no focus chain has been explicitly
	 * set, GTK+ computes the focus chain based on the positions
	 * of the children. In that case, GTK+ stores NULL in
	 * focusable_widgets and returns FALSE.
	 * Params:
	 * focusableWidgets =  location to store the focus chain of the
	 *  container, or NULL. You should free this list
	 *  using g_list_free() when you are done with it, however
	 *  no additional reference count is added to the
	 *  individual widgets in the focus chain.
	 * Returns: TRUE if the focus chain of the container has been set explicitly.
	 */
	public int getFocusChain(out ListG focusableWidgets);
	
	/**
	 * Sets a focus chain, overriding the one computed automatically by GTK+.
	 * In principle each widget in the chain should be a descendant of the
	 * container, but this is not enforced by this method, since it's allowed
	 * to set the focus chain before you pack the widgets, or have a widget
	 * in the chain that isn't always packed. The necessary checks are done
	 * when the focus chain is actually traversed.
	 * Params:
	 * focusableWidgets =  the new focus chain
	 */
	public void setFocusChain(ListG focusableWidgets);
	
	/**
	 * Removes a focus chain explicitly set with gtk_container_set_focus_chain().
	 */
	public void unsetFocusChain();
	
	/**
	 * Finds a child property of a container class by name.
	 * Params:
	 * cclass =  a GtkContainerClass
	 * propertyName =  the name of the child property to find
	 * Returns: the GParamSpec of the child property or NULL if class has no child property with that name.
	 */
	public static ParamSpec classFindChildProperty(GObjectClass* cclass, string propertyName);
	
	/**
	 * Installs a child property on a container class.
	 * Params:
	 * cclass =  a GtkContainerClass
	 * propertyId =  the id for the property
	 * pspec =  the GParamSpec for the property
	 */
	public static void classInstallChildProperty(Container cclass, uint propertyId, ParamSpec pspec);
	
	/**
	 * Returns all child properties of a container class.
	 * Params:
	 * cclass =  a GtkContainerClass
	 * Returns: a newly allocated NULL-terminated array of GParamSpec*.  The array must be freed with g_free().
	 */
	public static ParamSpec[] classListChildProperties(GObjectClass* cclass);
}