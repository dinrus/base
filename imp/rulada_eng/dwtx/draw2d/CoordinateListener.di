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

module dwtx.draw2d.CoordinateListener;

import dwt.dwthelper.utils;
import dwtx.draw2d.IFigure;

/**
 * @since 3.1
 */
public interface CoordinateListener {

/**
 * Indicates that the coordinate system has changed in a way that affects the absolute
 * locations of contained figures.
 * @param source the figure whose coordinate system changed
 * @since 3.1
 */
void coordinateSystemChanged(IFigure source);

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
