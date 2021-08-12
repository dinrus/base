module gtkD.gtk.ToggleButton;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;



private import gtkD.gtk.Button;

/**
 * Description
 * A GtkToggleButton is a GtkButton which will remain 'pressed-in' when
 * clicked. Clicking again will cause the toggle button to return to its
 * normal state.
 * A toggle button is created by calling either gtk_toggle_button_new() or
 * gtk_toggle_button_new_with_label(). If using the former, it is advisable to
 * pack a widget, (such as a GtkLabel and/or a GtkPixmap), into the toggle
 * button's container. (See GtkButton for more information).
 * The state of a GtkToggleButton can be set specifically using
 * gtk_toggle_button_set_active(), and retrieved using
 * gtk_toggle_button_get_active().
 * To simply switch the state of a toggle button, use gtk_toggle_button_toggled.
 * Example 16. Creating two GtkToggleButton widgets.
 * void make_toggles (void) {
	 *  GtkWidget *dialog, *toggle1, *toggle2;
	 *  dialog = gtk_dialog_new ();
	 *  toggle1 = gtk_toggle_button_new_with_label ("Hi, i'm a toggle button.");
	 *  /+* Makes this toggle button invisible +/
	 *  gtk_toggle_button_set_mode (GTK_TOGGLE_BUTTON (toggle1), TRUE);
	 *  g_signal_connect (toggle1, "toggled",
	 *  G_CALLBACK (output_state), NULL);
	 *  gtk_box_pack_start (GTK_BOX (GTK_DIALOG (dialog)->action_area),
	 *  toggle1, FALSE, FALSE, 2);
	 *  toggle2 = gtk_toggle_button_new_with_label ("Hi, i'm another toggle button.");
	 *  gtk_toggle_button_set_mode (GTK_TOGGLE_BUTTON (toggle2), FALSE);
	 *  g_signal_connect (toggle2, "toggled",
	 *  G_CALLBACK (output_state), NULL);
	 *  gtk_box_pack_start (GTK_BOX (GTK_DIALOG (dialog)->action_area),
	 *  toggle2, FALSE, FALSE, 2);
	 *  gtk_widget_show_all (dialog);
 * }
 */
public class ToggleButton : Button
{
	
	/** the main Gtk struct */
	protected GtkToggleButton* gtkToggleButton;
	
	
	public GtkToggleButton* getToggleButtonStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkToggleButton* gtkToggleButton);
	
	/**
	 * Creates a new toggle button with a text label.
	 * Params:
	 *  label = a string containing the message to be placed in the toggle button.
	 *  mnemonic =  if true the label
	 *  will be created using gtk_label_new_with_mnemonic(), so underscores
	 *  in label indicate the mnemonic for the button.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string label, bool mnemonic=true);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(ToggleButton)[] onToggledListeners;
	/**
	 * Should be connected if you wish to perform an action whenever the
	 * GtkToggleButton's state is changed.
	 * See Also
	 * GtkButton
	 * a more general button.
	 * GtkCheckButton
	 * another way of presenting a toggle option.
	 * GtkCheckMenuItem
	 * a GtkToggleButton as a menu item.
	 */
	void addOnToggled(void delegate(ToggleButton) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackToggled(GtkToggleButton* togglebuttonStruct, ToggleButton toggleButton);
	
	
	/**
	 * Creates a new toggle button. A widget should be packed into the button, as in gtk_button_new().
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Sets whether the button is displayed as a separate indicator and label.
	 * You can call this function on a checkbutton or a radiobutton with
	 * draw_indicator = FALSE to make the button look like a normal button
	 * This function only affects instances of classes like GtkCheckButton
	 * and GtkRadioButton that derive from GtkToggleButton,
	 * not instances of GtkToggleButton itself.
	 * Params:
	 * drawIndicator =  if TRUE, draw the button as a separate indicator
	 * and label; if FALSE, draw the button like a normal button
	 */
	public void setMode(int drawIndicator);
	
	/**
	 * Retrieves whether the button is displayed as a separate indicator
	 * and label. See gtk_toggle_button_set_mode().
	 * Returns: TRUE if the togglebutton is drawn as a separate indicator and label.
	 */
	public int getMode();
	
	/**
	 * Emits the toggled
	 * signal on the GtkToggleButton. There is no good reason for an
	 * application ever to call this function.
	 */
	public void toggled();
	
	/**
	 * Queries a GtkToggleButton and returns its current state. Returns TRUE if
	 * the toggle button is pressed in and FALSE if it is raised.
	 * Returns:a gboolean value.
	 */
	public int getActive();
	
	/**
	 * Sets the status of the toggle button. Set to TRUE if you want the
	 * GtkToggleButton to be 'pressed in', and FALSE to raise it.
	 * This action causes the toggled signal to be emitted.
	 * Params:
	 * isActive = %TRUE or FALSE.
	 */
	public void setActive(int isActive);
	
	/**
	 * Gets the value set by gtk_toggle_button_set_inconsistent().
	 * Returns: TRUE if the button is displayed as inconsistent, FALSE otherwise
	 */
	public int getInconsistent();
	
	/**
	 * If the user has selected a range of elements (such as some text or
	 * spreadsheet cells) that are affected by a toggle button, and the
	 * current values in that range are inconsistent, you may want to
	 * display the toggle in an "in between" state. This function turns on
	 * "in between" display. Normally you would turn off the inconsistent
	 * state again if the user toggles the toggle button. This has to be
	 * done manually, gtk_toggle_button_set_inconsistent() only affects
	 * visual appearance, it doesn't affect the semantics of the button.
	 * Params:
	 * setting =  TRUE if state is inconsistent
	 */
	public void setInconsistent(int setting);
}
