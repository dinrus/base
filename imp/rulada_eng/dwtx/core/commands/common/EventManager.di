/*******************************************************************************
 * Copyright (c) 2005, 2006 IBM Corporation and others.
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

module dwtx.core.commands.common.EventManager;

import dwtx.core.runtime.ListenerList;

/**
 * <p>
 * A manager to which listeners can be attached. This handles the management of
 * a list of listeners -- optimizing memory and performance. All the methods on
 * this class are guaranteed to be thread-safe.
 * </p>
 * <p>
 * Clients may extend.
 * </p>
 *
 * @since 3.2
 */
public abstract class EventManager {

    /**
     * An empty array that can be returned from a call to
     * {@link #getListeners()} when {@link #listenerList} is <code>null</code>.
     */
    private static const Object[] EMPTY_ARRAY = null;

    /**
     * A collection of objects listening to changes to this manager. This
     * collection is <code>null</code> if there are no listeners.
     */
    private /+transient+/ ListenerList listenerList = null;

    /**
     * Adds a listener to this manager that will be notified when this manager's
     * state changes.
     *
     * @param listener
     *            The listener to be added; must not be <code>null</code>.
     */
    protected synchronized final void addListenerObject(Object listener) {
        if (listenerList is null) {
            listenerList = new ListenerList(ListenerList.IDENTITY);
        }

        listenerList.add(listener);
    }

    /**
     * Clears all of the listeners from the listener list.
     */
    protected synchronized final void clearListeners() {
        if (listenerList !is null) {
            listenerList.clear();
        }
    }

    /**
     * Returns the listeners attached to this event manager.
     *
     * @return The listeners currently attached; may be empty, but never
     *         <code>null</code>
     */
    protected final Object[] getListeners() {
        ListenerList list = listenerList;
        if (list is null) {
            return EMPTY_ARRAY;
        }

        return list.getListeners();
    }

    /**
     * Whether one or more listeners are attached to the manager.
     *
     * @return <code>true</code> if listeners are attached to the manager;
     *         <code>false</code> otherwise.
     */
    protected final bool isListenerAttached() {
        return listenerList !is null;
    }

    /**
     * Removes a listener from this manager.
     *
     * @param listener
     *            The listener to be removed; must not be <code>null</code>.
     */
    protected synchronized final void removeListenerObject(Object listener) {
        if (listenerList !is null) {
            listenerList.remove(listener);

            if (listenerList.isEmpty()) {
                listenerList = null;
            }
        }
    }
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-dwtx");
        } else version (DigitalMars) {
            pragma(link, "DD-dwtx");
        } else {
            pragma(link, "DO-dwtx");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-dwtx");
        } else version (DigitalMars) {
            pragma(link, "DD-dwtx");
        } else {
            pragma(link, "DO-dwtx");
        }
    }
}
