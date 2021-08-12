/*******************************************************************************
 * Copyright (c) 2004, 2005 IBM Corporation and others.
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
module dwtx.jface.resource.ResourceRegistry;


import dwtx.core.commands.common.EventManager;
import dwtx.jface.util.IPropertyChangeListener;
import dwtx.jface.util.PropertyChangeEvent;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

/**
 * Abstract base class for various JFace registries.
 *
 * @since 3.0
 */
public abstract class ResourceRegistry : EventManager {

    /**
     * Adds a property change listener to this registry.
     *
     * @param listener a property change listener
     */
    public void addListener(IPropertyChangeListener listener) {
        addListenerObject(cast(Object)listener);
    }

    /**
     * Disposes all currently allocated resources.
     */
    protected abstract void clearCaches();

    /**
     * @return the set of keys this manager knows about.  This collection
     * should be immutable.
     */
    public abstract Set getKeySet();

    /**
     * Return whether or not the receiver has a value for the supplied key.
     *
     * @param key the key
     * @return <code>true</code> if there is a value for this key
     */
    public abstract bool hasValueFor(String key);

    /**
     * Fires a <code>PropertyChangeEvent</code>.
     *
     * @param name the name of the symbolic value that is changing.
     * @param oldValue the old value.
     * @param newValue the new value.
     */
    protected void fireMappingChanged(String name, Object oldValue,
            Object newValue) {
        Object[] myListeners = getListeners();
        if (myListeners.length > 0) {
            PropertyChangeEvent event = new PropertyChangeEvent(this, name,
                    oldValue, newValue);
            for (int i = 0; i < myListeners.length; ++i) {
                try {
                    (cast(IPropertyChangeListener) myListeners[i])
                            .propertyChange(event);
                } catch (Exception e) {
                    // TODO: how to log?
                }
            }
        }
    }

    /**
     * Removes the given listener from this registry. Has no affect if the
     * listener is not registered.
     *
     * @param listener a property change listener
     */
    public void removeListener(IPropertyChangeListener listener) {
        removeListenerObject(cast(Object)listener);
    }
}
