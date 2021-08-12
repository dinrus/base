/*******************************************************************************
 * Copyright (c) 2006, 2007 IBM Corporation and others.
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

module dwtx.jface.viewers.TreePathViewerSorter;

import dwtx.jface.viewers.ViewerSorter;
import dwtx.jface.viewers.TreePath;
import dwtx.jface.viewers.Viewer;

// import java.util.Arrays;
// import java.util.Comparator;

import dwt.dwthelper.utils;
import tango.core.Array;

/**
 * A viewer sorter that is provided extra context in the form of the path of the
 * parent element of the elements being sorted.
 *
 * @since 3.2
 */
public class TreePathViewerSorter : ViewerSorter {
    alias ViewerSorter.category category;
    alias ViewerSorter.compare compare;
    alias ViewerSorter.isSorterProperty isSorterProperty;
    alias ViewerSorter.sort sort;

    /**
     * Provide a category for the given element that will have the given parent
     * path when it is added to the viewer. The provided path is
     * relative to the viewer input. The parent path will
     * be <code>null</code> when the elements are root elements.
     * <p>
     * By default, the this method calls
     * {@link ViewerSorter#category(Object)}. Subclasses may override.
     *
     * @param parentPath
     *            the parent path for the element
     * @param element
     *            the element
     * @return the category of the element
     */
    public int category(TreePath parentPath, Object element) {
        return category(element);
    }

    /**
     * Compare the given elements that will have the given parent
     * path when they are added to the viewer. The provided path is
     * relative to the viewer input. The parent path will
     * be <code>null</code> when the elements are root elements.
     * <p>
     * By default, the this method calls
     * {@link ViewerSorter#sort(Viewer, Object[])}. Subclasses may override.
     * @param viewer the viewer
     * @param parentPath the parent path for the two elements
     * @param e1 the first element
     * @param e2 the second element
     * @return a negative number if the first element is less  than the
     *  second element; the value <code>0</code> if the first element is
     *  equal to the second element; and a positive
     */
    public int compare(Viewer viewer, TreePath parentPath, Object e1, Object e2) {
        return compare(viewer, e1, e2);
    }

    /**
     * Returns whether this viewer sorter would be affected
     * by a change to the given property of the given element.
     * The provided path is
     * relative to the viewer input. The parent path will
     * be <code>null</code> when the elements are root elements.
     * <p>
     * The default implementation of this method calls
     * {@link ViewerSorter#isSorterProperty(Object, String)}.
     * Subclasses may reimplement.
     * @param parentPath the parent path of the element
     * @param element the element
     * @param property the property
     * @return <code>true</code> if the sorting would be affected,
     *    and <code>false</code> if it would be unaffected
     */
    public bool isSorterProperty(TreePath parentPath, Object element, String property) {
        return isSorterProperty(element, property);
    }

    /**
     * Sorts the given elements in-place, modifying the given array.
     * The provided path is
     * relative to the viewer input. The parent path will
     * be <code>null</code> when the elements are root elements.
     * <p>
     * The default implementation of this method uses the
     * java.util.Arrays#sort algorithm on the given array,
     * calling {@link #compare(Viewer, TreePath, Object, Object)} to compare elements.
     * </p>
     * <p>
     * Subclasses may reimplement this method to provide a more optimized implementation.
     * </p>
     *
     * @param viewer the viewer
     * @param parentPath the parent path of the given elements
     * @param elements the elements to sort
     */
    public void sort(Viewer viewer, TreePath parentPath, Object[] elements) {
        tango.core.Array.sort(elements, delegate int (Object a, Object b) {
                return compare(viewer, parentPath, a, b);
            }
        );
    }
}
