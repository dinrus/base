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
module dwtx.jface.viewers.IStructuredSelection;

import dwtx.jface.viewers.ISelection;
import dwtx.dwtxhelper.Collection;

/**
 * A selection containing elements.
 */
public interface IStructuredSelection : ISelection {
    /**
     * Returns the first element in this selection, or <code>null</code>
     * if the selection is empty.
     *
     * @return an element, or <code>null</code> if none
     */
    public Object getFirstElement();

    /**
     * Returns an iterator over the elements of this selection.
     *
     * @return an iterator over the selected elements
     */
    public Iterator iterator();

    /**
     * Returns the number of elements selected in this selection.
     *
     * @return the number of elements selected
     */
    public int size();

    /**
     * Returns the elements in this selection as an array.
     *
     * @return the selected elements as an array
     */
    public Object[] toArray();

    /**
     * Returns the elements in this selection as a <code>List</code>.
     * <strong>Note</strong> In the default implementation of {@link #toList()} in
     * {@link StructuredSelection} the returned list is not a copy of the elements of the
     * receiver and modifying it will modify the contents of the selection.
     *
     * @return the selected elements as a list
     */
    public List toList();
}
