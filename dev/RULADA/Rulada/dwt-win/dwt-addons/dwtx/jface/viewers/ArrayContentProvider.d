/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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

module dwtx.jface.viewers.ArrayContentProvider;

import dwtx.jface.viewers.IStructuredContentProvider;
import dwtx.jface.viewers.Viewer;


import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

/**
 * This implementation of <code>IStructuredContentProvider</code> handles
 * the case where the viewer input is an unchanging array or collection of elements.
 * <p>
 * This class is not intended to be subclassed outside the viewer framework.
 * </p>
 *
 * @since 2.1
 * @noextend This class is not intended to be subclassed by clients.
 */
public class ArrayContentProvider(T) : IStructuredContentProvider {

    /**
     * Returns the elements in the input, which must be either an array or a
     * <code>Collection</code>.
     */
    public Object[] getElements(Object inputElement) {
        if ( auto aw = cast(ArrayWrapperT!(T)) inputElement ) {
            return aw.array;
        }
        if ( auto col = cast(Collection) inputElement ) {
            return col.toArray();
        }
        return null;
    }

    /**
     * This implementation does nothing.
     */
    public void inputChanged(Viewer viewer, Object oldInput, Object newInput) {
        // do nothing.
    }

    /**
     * This implementation does nothing.
     */
    public void dispose() {
        // do nothing.
    }
}
