/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.viewers.Viewer;

import dwtx.jface.viewers.IInputSelectionProvider;
import dwtx.jface.viewers.ISelectionChangedListener;
import dwtx.jface.viewers.SelectionChangedEvent;
import dwtx.jface.viewers.ISelection;

import dwt.events.HelpEvent;
import dwt.events.HelpListener;
import dwt.widgets.Control;
import dwt.widgets.Item;
import dwtx.core.runtime.Assert;
import dwtx.core.runtime.ListenerList;
import dwtx.jface.util.SafeRunnable;

import dwt.dwthelper.utils;

/**
 * A viewer is a model-based adapter on a widget.
 * <p>
 * A viewer can be created as an adapter on a pre-existing control (e.g.,
 * creating a <code>ListViewer</code> on an existing <code>List</code> control).
 * All viewers also provide a convenience constructor for creating the control.
 * </p>
 * <p>
 * Implementing a concrete viewer typically involves the following steps:
 * <ul>
 * <li>
 * create DWT controls for viewer (in constructor) (optional)
 * </li>
 * <li>
 * initialize DWT controls from input (inputChanged)
 * </li>
 * <li>
 * define viewer-specific update methods
 * </li>
 * <li>
 * support selections (<code>setSelection</code>, <code>getSelection</code>)
 * </li>
 * </ul>
 * </p>
 */
public abstract class Viewer : IInputSelectionProvider {

    /**
     * List of selection change listeners (element type: <code>ISelectionChangedListener</code>).
     *
     * @see #fireSelectionChanged
     */
    private ListenerList selectionChangedListeners;

    /**
     * List of help request listeners (element type: <code>dwt.events.HelpListener</code>).
     * Help request listeners.
     *
     * @see #handleHelpRequest
     */
    private ListenerList helpListeners;

    /**
     * The names of this viewer's properties.
     * <code>null</code> if this viewer has no properties.
     *
     * @see #setData
     */
    private String[] keys;

    /**
     * The values of this viewer's properties.
     * <code>null</code> if this viewer has no properties.
     * This array parallels the value of the <code>keys</code> field.
     *
     * @see #setData
     */
    private Object[] values;

    /**
     * Remembers whether we've hooked the help listener on the control or not.
     */
    private bool helpHooked = false;

    /**
     * Help listener for the control, created lazily when client's first help listener is added.
     */
    private HelpListener helpListener = null;

    /**
     * Unique key for associating element data with widgets.
     * @see dwt.widgets.Widget#setData(String, Object)
     */
    protected static const String WIDGET_DATA_KEY = "dwtx.jface.viewers.WIDGET_DATA";//$NON-NLS-1$

    /**
     * Creates a new viewer.
     */
    protected this() {
        selectionChangedListeners = new ListenerList();
        helpListeners = new ListenerList();
    }

    /**
     * Adds a listener for help requests in this viewer.
     * Has no effect if an identical listener is already registered.
     *
     * @param listener a help listener
     */
    public void addHelpListener(HelpListener listener) {
        helpListeners.add(cast(Object)listener);
        if (!helpHooked) {
            Control control = getControl();
            if (control !is null && !control.isDisposed()) {
                if (this.helpListener is null) {
                    this.helpListener = new class HelpListener {
                        public void helpRequested(HelpEvent event) {
                            handleHelpRequest(event);
                        }
                    };
                }
                control.addHelpListener(this.helpListener);
                helpHooked = true;
            }
        }
    }

    /* (non-Javadoc)
     * Method declared on ISelectionProvider.
     */
    public void addSelectionChangedListener(ISelectionChangedListener listener) {
        selectionChangedListeners.add(cast(Object)listener);
    }

    /**
     * Notifies any help listeners that help has been requested.
     * Only listeners registered at the time this method is called are notified.
     *
     * @param event a help event
     *
     * @see HelpListener#helpRequested(dwt.events.HelpEvent)
     */
    protected void fireHelpRequested(HelpEvent event) {
        Object[] listeners = helpListeners.getListeners();
        for (int i = 0; i < listeners.length; ++i) {
            (cast(HelpListener) listeners[i]).helpRequested(event);
        }
    }

    /**
     * Notifies any selection changed listeners that the viewer's selection has changed.
     * Only listeners registered at the time this method is called are notified.
     *
     * @param event a selection changed event
     *
     * @see ISelectionChangedListener#selectionChanged
     */
    protected void fireSelectionChanged(SelectionChangedEvent event) {
        Object[] listeners = selectionChangedListeners.getListeners();
        for (int i = 0; i < listeners.length; ++i) {
            SafeRunnable.run(new class(event,cast(ISelectionChangedListener) listeners[i]) SafeRunnable {
                ISelectionChangedListener l;
                SelectionChangedEvent event_;
                this(SelectionChangedEvent a,ISelectionChangedListener b){
                    event_=a;
                    l = b;
                }
                public void run() {
                    l.selectionChanged(event_);
                }
            });
        }
    }

    /**
     * Returns the primary control associated with this viewer.
     *
     * @return the DWT control which displays this viewer's content
     */
    public abstract Control getControl();

    /**
     * Returns the value of the property with the given name,
     * or <code>null</code> if the property is not found.
     * <p>
     * The default implementation performs a (linear) search of
     * an internal table. Overriding this method is generally not
     * required if the number of different keys is small. If a more
     * efficient representation of a viewer's properties is required,
     * override both <code>getData</code> and <code>setData</code>.
     * </p>
     *
     * @param key the property name
     * @return the property value, or <code>null</code> if
     *    the property is not found
     */
    public Object getData(String key) {
        Assert.isNotNull(key);
        if (keys is null) {
            return null;
        }
        for (int i = 0; i < keys.length; i++) {
            if (keys[i].equals(key)) {
                return values[i];
            }
        }
        return null;
    }

    /* (non-Javadoc)
     * Copy-down of method declared on <code>IInputProvider</code>.
     */
    public abstract Object getInput();

    /* (non-Javadoc)
     * Copy-down of method declared on <code>ISelectionProvider</code>.
     */
    public abstract ISelection getSelection();

    /**
     * Handles a help request from the underlying DWT control.
     * The default behavior is to fire a help request,
     * with the event's data modified to hold this viewer.
     * @param event the event
     *
     */
    protected void handleHelpRequest(HelpEvent event) {
        Object oldData = event.data;
        event.data = this;
        fireHelpRequested(event);
        event.data = oldData;
    }

    /**
     * Internal hook method called when the input to this viewer is
     * initially set or subsequently changed.
     * <p>
     * The default implementation does nothing. Subclassers may override
     * this method to do something when a viewer's input is set.
     * A typical use is populate the viewer.
     * </p>
     *
     * @param input the new input of this viewer, or <code>null</code> if none
     * @param oldInput the old input element or <code>null</code> if there
     *   was previously no input
     */
    protected void inputChanged(Object input, Object oldInput) {
    }

    /**
     * Refreshes this viewer completely with information freshly obtained from this
     * viewer's model.
     */
    public abstract void refresh();

    /**
     * Removes the given help listener from this viewer.
     * Has no affect if an identical listener is not registered.
     *
     * @param listener a help listener
     */
    public void removeHelpListener(HelpListener listener) {
        helpListeners.remove(cast(Object)listener);
        if (helpListeners.size() is 0) {
            Control control = getControl();
            if (control !is null && !control.isDisposed()) {
                control.removeHelpListener(this.helpListener);
                helpHooked = false;
            }
        }
    }

    /* (non-Javadoc)
     * Method declared on ISelectionProvider.
     */
    public void removeSelectionChangedListener(
            ISelectionChangedListener listener) {
        selectionChangedListeners.remove(cast(Object)listener);
    }

    /**
     * Scrolls the viewer's control down by one item from the given
     * display-relative coordinates.  Returns the newly revealed Item,
     * or <code>null</code> if no scrolling occurred or if the viewer
     * doesn't represent an item-based widget.
     *
     * @param x horizontal coordinate
     * @param y vertical coordinate
     * @return the item scrolled down to
     */
    public Item scrollDown(int x, int y) {
        return null;
    }

    /**
     * Scrolls the viewer's control up by one item from the given
     * display-relative coordinates.  Returns the newly revealed Item,
     * or <code>null</code> if no scrolling occurred or if the viewer
     * doesn't represent an item-based widget.
     *
     * @param x horizontal coordinate
     * @param y vertical coordinate
     * @return the item scrolled up to
     */
    public Item scrollUp(int x, int y) {
        return null;
    }

    /**
     * Sets the value of the property with the given name to the
     * given value, or to <code>null</code> if the property is to be
     * removed. If this viewer has such a property, its value is
     * replaced; otherwise a new property is added.
     * <p>
     * The default implementation records properties in an internal
     * table which is searched linearly. Overriding this method is generally not
     * required if the number of different keys is small. If a more
     * efficient representation of a viewer's properties is required,
     * override both <code>getData</code> and <code>setData</code>.
     * </p>
     *
     * @param key the property name
     * @param value the property value, or <code>null</code> if
     *    the property is not found
     */
    public void setData(String key, Object value) {
        Assert.isNotNull(key);
        /* Remove the key/value pair */
        if (value is null) {
            if (keys is null) {
                return;
            }
            int index = 0;
            while (index < keys.length && !keys[index].equals(key)) {
                index++;
            }
            if (index is keys.length) {
                return;
            }
            if (keys.length is 1) {
                keys = null;
                values = null;
            } else {
                String[] newKeys = new String[keys.length - 1];
                Object[] newValues = new Object[values.length - 1];
                System.arraycopy(keys, 0, newKeys, 0, index);
                System.arraycopy(keys, index + 1, newKeys, index,
                        newKeys.length - index);
                System.arraycopy(values, 0, newValues, 0, index);
                System.arraycopy(values, index + 1, newValues, index,
                        newValues.length - index);
                keys = newKeys;
                values = newValues;
            }
            return;
        }

        /* Add the key/value pair */
        if (keys is null) {
            keys = [ key ];
            values = [ value ];
            return;
        }
        for (int i = 0; i < keys.length; i++) {
            if (keys[i].equals(key)) {
                values[i] = value;
                return;
            }
        }
        String[] newKeys = new String[](keys.length + 1);
        Object[] newValues = new Object[](values.length + 1);
        System.arraycopy(keys, 0, newKeys, 0, keys.length);
        System.arraycopy(values, 0, newValues, 0, values.length);
        newKeys[keys.length] = key;
        newValues[values.length] = value;
        keys = newKeys;
        values = newValues;
    }

    /**
     * Sets or clears the input for this viewer.
     *
     * @param input the input of this viewer, or <code>null</code> if none
     */
    public abstract void setInput(Object input);

    /**
     * The viewer implementation of this <code>ISelectionProvider</code>
     * method make the new selection for this viewer without making it visible.
     * <p>
     * This method is equivalent to <code>setSelection(selection,false)</code>.
     * </p>
     * <p>
     * Note that some implementations may not be able to set the selection
     * without also revealing it, for example (as of 3.3) TreeViewer.
     * </p>
     */
    public void setSelection(ISelection selection) {
        setSelection(selection, false);
    }

    /**
     * Sets a new selection for this viewer and optionally makes it visible.
     * <p>
     * Subclasses must implement this method.
     * </p>
     *
     * @param selection the new selection
     * @param reveal <code>true</code> if the selection is to be made
     *   visible, and <code>false</code> otherwise
     */
    public abstract void setSelection(ISelection selection, bool reveal);
}
