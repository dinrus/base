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
module dwtx.draw2d.ConnectionAnchor;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.AnchorListener;
import dwtx.draw2d.IFigure;

/**
 * An object to which a {@link Connection} will be anchored.  If the ConnectionAnchor
 * moves, the Connection should move with it.
 */
public interface ConnectionAnchor {

/**
 * Adds a listener interested in the movement of this ConnectionAnchor.
 * @param listener The AnchorListener to be added
 */
void addAnchorListener(AnchorListener listener);

/**
 * Returns the location where the Connection should be anchored in absolute coordinates.
 * The anchor may use the given reference Point to calculate this location.
 * @param reference The reference Point in absolute coordinates
 * @return The anchor's location
 */
Point getLocation(Point reference);

/**
 * Returns the IFigure that contains this ConnectionAnchor.  Moving this figure will cause
 * the anchor to move with it.
 * @return The IFigure that contains this ConnectionAnchor
 */
IFigure getOwner();

/**
 * Returns the reference point for this anchor in absolute coordinates. This might be used
 * by another anchor to determine its own location (i.e. {@link ChopboxAnchor}).
 * @return The reference Point
 */
Point getReferencePoint();

/**
 * Removes the listener.
 * @param listener The AnchorListener to be removed
 */
void removeAnchorListener(AnchorListener listener);

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