module gtkD.gtk.Menu;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.gdk.Screen;
private import gtkD.gtk.AccelGroup;
private import gtkD.glib.ListG;
private import gtkD.gtk.MenuItem;



private import gtkD.gtk.MenuShell;

/**
 * Description
 * A GtkMenu is a GtkMenuShell that implements a drop down menu consisting of
 * a list of GtkMenuItem objects which can be navigated and activated by the
 * user to perform application functions.
 * A GtkMenu is most commonly dropped down by activating a GtkMenuItem in a
 * GtkMenuBar or popped up by activating a GtkMenuItem in another GtkMenu.
 * A GtkMenu can also be popped up by activating a GtkOptionMenu.
 * Other composite widgets such as the GtkNotebook can pop up a GtkMenu
 * as well.
 * Applications can display a GtkMenu as a popup menu by calling the
 * gtk_menu_popup() function. The example below shows how an application
 * can pop up a menu when the 3rd mouse button is pressed.
 * Example 29. Connecting the popup signal handler.
 *  /+* connect our handler which will popup the menu +/
 *  g_signal_connect_swapped (window, "button_press_event",
 * 	G_CALLBACK (my_popup_handler), menu);
 * Example 30. Signal handler which displays a popup menu.
 * static gint
 * my_popup_handler (GtkWidget *widget, GdkEvent *event)
 * {
	 *  GtkMenu *menu;
	 *  GdkEventButton *event_button;
	 *  g_return_val_if_fail (widget != NULL, FALSE);
	 *  g_return_val_if_fail (GTK_IS_MENU (widget), FALSE);
	 *  g_return_val_if_fail (event != NULL, FALSE);
	 *  /+* The "widget" is the menu that was supplied when
	 *  * g_signal_connect_swapped() was called.
	 *  +/
	 *  menu = GTK_MENU (widget);
	 *  if (event->type == GDK_BUTTON_PRESS)
	 *  {
		 *  event_button = (GdkEventButton *) event;
		 *  if (event_button->button == 3)
		 * 	{
			 * 	 gtk_menu_popup (menu, NULL, NULL, NULL, NULL,
			 * 			 event_button->button, event_button->time);
			 * 	 return TRUE;
		 * 	}
	 *  }
	 *  return FALSE;
 * }
 */
public class Menu : MenuShell
{

	/** the main Gtk struct */
	protected GtkMenu* gtkMenu;


	public GtkMenu* getMenuStruct();


	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkMenu* gtkMenu);

	/**
	 * Popups up this menu
	 * Params:
	 *  button = you can pass a button number here
	 *  activateTime = you can pass the time from an event here
	 */
	void popup(guint button, guint32 activateTime);

	/**
	 * Creates and append a submenu to this menu.
	 * This menu item that actualy has the sub menu is also created.
	 * Params:
	 *  label = the sub menu item label
	 * Returns: the new menu
	 */
	Menu appendSubmenu(string label);

	/** */
	void appendSubmenu(string label, Menu submenu);

	/** */
	Menu prependSubmenu(string label);

	/**
	 */
	int[char[]] connectedSignals;

	void delegate(GtkScrollType, Menu)[] onMoveScrollListeners;
	/**
	 */
	void addOnMoveScroll(void delegate(GtkScrollType, Menu) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMoveScroll(GtkMenu* menuStruct, GtkScrollType arg1, Menu menu);


	/**
	 * Creates a new GtkMenu.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();

	/**
	 * Sets the GdkScreen on which the menu will be displayed.
	 * Since 2.2
	 * Params:
	 * screen =  a GdkScreen, or NULL if the screen should be
	 *  determined by the widget the menu is attached to.
	 */
	public void setScreen(Screen screen);

	/**
	 * Moves a GtkMenuItem to a new position within the GtkMenu.
	 * Params:
	 * child = the GtkMenuItem to move.
	 * position = the new position to place child. Positions are numbered from
	 * 0 to n-1.
	 */
	public void reorderChild(Widget child, int position);

	/**
	 * Adds a new GtkMenuItem to a (table) menu. The number of 'cells' that
	 * an item will occupy is specified by left_attach, right_attach,
	 * top_attach and bottom_attach. These each represent the leftmost,
	 * rightmost, uppermost and lower column and row numbers of the table.
	 * (Columns and rows are indexed from zero).
	 * Note that this function is not related to gtk_menu_detach().
	 * Since 2.4
	 * Params:
	 * child =  a GtkMenuItem.
	 * leftAttach =  The column number to attach the left side of the item to.
	 * rightAttach =  The column number to attach the right side of the item to.
	 * topAttach =  The row number to attach the top of the item to.
	 * bottomAttach =  The row number to attach the bottom of the item to.
	 */
	public void attach(Widget child, uint leftAttach, uint rightAttach, uint topAttach, uint bottomAttach);

	/**
	 * Displays a menu and makes it available for selection. Applications can use
	 * this function to display context-sensitive menus, and will typically supply
	 * NULL for the parent_menu_shell, parent_menu_item, func and data
	 * parameters. The default menu positioning function will position the menu
	 * at the current mouse cursor position.
	 * The button parameter should be the mouse button pressed to initiate
	 * the menu popup. If the menu popup was initiated by something other than
	 * a mouse button press, such as a mouse button release or a keypress,
	 * button should be 0.
	 * The activate_time parameter is used to conflict-resolve initiation of
	 * concurrent requests for mouse/keyboard grab requests. To function
	 * properly, this needs to be the time stamp of the user event (such as
	 * a mouse click or key press) that caused the initiation of the popup.
	 * Only if no such event is available, gtk_get_current_event_time() can
	 * be used instead.
	 * Params:
	 * parentMenuShell =  the menu shell containing the triggering menu item, or NULL
	 * parentMenuItem =  the menu item whose activation triggered the popup, or NULL
	 * func =  a user supplied function used to position the menu, or NULL
	 * data =  user supplied data to be passed to func.
	 * button =  the mouse button which was pressed to initiate the event.
	 * activateTime =  the time at which the activation event occurred.
	 */
	public void popup(Widget parentMenuShell, Widget parentMenuItem, GtkMenuPositionFunc func, void* data, uint button, uint activateTime);

	/**
	 * Set the GtkAccelGroup which holds global accelerators for the menu.
	 * This accelerator group needs to also be added to all windows that
	 * this menu is being used in with gtk_window_add_accel_group(), in order
	 * for those windows to support all the accelerators contained in this group.
	 * Params:
	 * accelGroup = the GtkAccelGroup to be associated with the menu.
	 */
	public void setAccelGroup(AccelGroup accelGroup);

	/**
	 * Gets the GtkAccelGroup which holds global accelerators for the menu.
	 * See gtk_menu_set_accel_group().
	 * Returns:the GtkAccelGroup associated with the menu.
	 */
	public AccelGroup getAccelGroup();

	/**
	 * Sets an accelerator path for this menu from which accelerator paths
	 * for its immediate children, its menu items, can be constructed.
	 * The main purpose of this function is to spare the programmer the
	 * inconvenience of having to call gtk_menu_item_set_accel_path() on
	 * each menu item that should support runtime user changable accelerators.
	 * Instead, by just calling gtk_menu_set_accel_path() on their parent,
	 * each menu item of this menu, that contains a label describing its purpose,
	 * automatically gets an accel path assigned. For example, a menu containing
	 * menu items "New" and "Exit", will, after
	 * gtk_menu_set_accel_path (menu, "<Gnumeric-Sheet>/File");
	 * Params:
	 * accelPath =  a valid accelerator path
	 */
	public void setAccelPath(string accelPath);

	/**
	 * Retrieves the accelerator path set on the menu.
	 * Since 2.14
	 * Returns: the accelerator path set on the menu.
	 */
	public string getAccelPath();

	/**
	 * Sets the title string for the menu. The title is displayed when the menu
	 * is shown as a tearoff menu. If title is NULL, the menu will see if it is
	 * attached to a parent menu item, and if so it will try to use the same text as
	 * that menu item's label.
	 * Params:
	 * title =  a string containing the title for the menu.
	 */
	public void setTitle(string title);

	/**
	 * Returns the title of the menu. See gtk_menu_set_title().
	 * Returns: the title of the menu, or NULL if the menu has notitle set on it. This string is owned by the widget and shouldnot be modified or freed.
	 */
	public string getTitle();

	/**
	 * Informs GTK+ on which monitor a menu should be popped up.
	 * See gdk_screen_get_monitor_geometry().
	 * This function should be called from a GtkMenuPositionFunc if the
	 * menu should not appear on the same monitor as the pointer. This
	 * information can't be reliably inferred from the coordinates returned
	 * by a GtkMenuPositionFunc, since, for very long menus, these coordinates
	 * may extend beyond the monitor boundaries or even the screen boundaries.
	 * Since 2.4
	 * Params:
	 * monitorNum =  the number of the monitor on which the menu should
	 *  be popped up
	 */
	public void setMonitor(int monitorNum);

	/**
	 * Retrieves the number of the monitor on which to show the menu.
	 * Since 2.14
	 * Returns: the number of the monitor on which the menu should be popped up or -1, if no monitor has been set
	 */
	public int getMonitor();

	/**
	 * Returns whether the menu is torn off. See
	 * gtk_menu_set_tearoff_state().
	 * Returns: TRUE if the menu is currently torn off.
	 */
	public int getTearoffState();

	/**
	 * Sets whether the menu should reserve space for drawing toggles
	 * or icons, regardless of their actual presence.
	 * Since 2.18
	 * Params:
	 * reserveToggleSize =  whether to reserve size for toggles
	 */
	public void setReserveToggleSize(int reserveToggleSize);

	/**
	 * Returns whether the menu reserves space for toggles and
	 * icons, regardless of their actual presence.
	 * Since 2.18
	 * Returns: Whether the menu reserves toggle space
	 */
	public int getReserveToggleSize();

	/**
	 * Removes the menu from the screen.
	 */
	public void popdown();

	/**
	 * Repositions the menu according to its position function.
	 */
	public void reposition();

	/**
	 * Returns the selected menu item from the menu. This is used by the
	 * GtkOptionMenu.
	 * Returns:the GtkMenuItem that was last selected in the menu. If a selection has not yet been made, the first menu item is selected.
	 */
	public Widget getActive();

	/**
	 * Selects the specified menu item within the menu. This is used by the
	 * GtkOptionMenu and should not be used by anyone else.
	 * Params:
	 * index = the index of the menu item to select. Index values are from
	 * 0 to n-1.
	 */
	public void setActive(uint index);

	/**
	 * Changes the tearoff state of the menu. A menu is normally displayed
	 * as drop down menu which persists as long as the menu is active. It can
	 * also be displayed as a tearoff menu which persists until it is closed
	 * or reattached.
	 * Params:
	 * tornOff = If TRUE, menu is displayed as a tearoff menu.
	 */
	public void setTearoffState(int tornOff);

	/**
	 * Attaches the menu to the widget and provides a callback function that will
	 * be invoked when the menu calls gtk_menu_detach() during its destruction.
	 * Params:
	 * attachWidget = the GtkWidget that the menu will be attached to.
	 * detacher = the user supplied callback function that will be called when
	 * the menu calls gtk_menu_detach().
	 */
	public void attachToWidget(Widget attachWidget, GtkMenuDetachFunc detacher);

	/**
	 * Detaches the menu from the widget to which it had been attached.
	 * This function will call the callback function, detacher, provided
	 * when the gtk_menu_attach_to_widget() function was called.
	 */
	public void detach();

	/**
	 * Returns the GtkWidget that the menu is attached to.
	 * Returns:the GtkWidget that the menu is attached to.
	 */
	public Widget getAttachWidget();

	/**
	 * Returns a list of the menus which are attached to this widget.
	 * This list is owned by GTK+ and must not be modified.
	 * Since 2.6
	 * Params:
	 * widget =  a GtkWidget
	 * Returns: the list of menus attached to his widget.
	 */
	public static ListG getForAttachWidget(Widget widget);
}
