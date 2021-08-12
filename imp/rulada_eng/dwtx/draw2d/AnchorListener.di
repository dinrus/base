/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module dwtx.draw2d.AnchorListener;

import dwt.dwthelper.utils;
import dwtx.draw2d.ConnectionAnchor;

/**
 * Classes which implement this interface provide a method to notify that an anchor has
 * moved.
 * <P>
 * Instances of this class can be added as listeners of an Anchor using the
 * <code>addAnchorListener</code> method and removed using the
 * <code>removeAnchorListener</code> method.
 */
public interface AnchorListener {

/**
 * Called when an anchor has moved to a new location.
 * @param anchor The anchor that has moved.
 */
void anchorMoved(ConnectionAnchor anchor);

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
