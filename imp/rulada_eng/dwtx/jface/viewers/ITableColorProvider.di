/*******************************************************************************
 * Copyright (c) 2004, 2006 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Initial implementation - Gunnar Ahlberg (IBS AB, www.ibs.net)
 *     IBM Corporation - further revisions
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/

module dwtx.jface.viewers.ITableColorProvider;

import dwt.graphics.Color;

/**
 * Interface to provide color representation for a given cell within
 * the row for an element in a table.
 * @since 3.1
 */
public interface ITableColorProvider {

    /**
     * Provides a foreground color for the given element.
     * 
     * @param element the element
     * @param columnIndex the zero-based index of the column in which
     *  the color appears
     * @return the foreground color for the element, or <code>null</code> to
     *         use the default foreground color
     */
    Color getForeground(Object element, int columnIndex);

    /**
     * Provides a background color for the given element at the specified index
     * 
     * @param element the element
     * @param columnIndex the zero-based index of the column in which the color appears
     * @return the background color for the element, or <code>null</code> to
     *         use the default background color
     *  
     */
    Color getBackground(Object element, int columnIndex);
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
