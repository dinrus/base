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
module dwtx.draw2d.XYAnchor;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.ConnectionAnchorBase;
import dwtx.draw2d.IFigure;

/**
 * Supports an anchor in the XY layout. This anchor exists independently without an owner.
 */
public class XYAnchor
    : ConnectionAnchorBase
{

private Point location;

/**
 * Constructs an XYAnchor at the Point p.
 *
 * @param p the point where this anchor will be located
 * @since 2.0
 */
public this(Point p) {
    location = new Point(p);
}

/**
 * Returns the location of this anchor relative to the reference point given in as input.
 * Since this is XY layout, the location of the point is independent of the reference
 * point.
 *
 * @see ConnectionAnchor#getLocation(Point)
 */
public Point getLocation(Point reference) {
    return location;
}

/**
 * Returns <code>null</code> as these anchors inherently do not depend on other figures
 * for their location.
 *
 * @see ConnectionAnchor#getOwner()
 * @since 2.0
 */
public IFigure getOwner() {
    return null;
}

/**
 * Returns the point which is used as the reference by this connection anchor. In the case
 * of the XYAnchor, this point is the same as its location.
 *
 * @see ConnectionAnchor#getReferencePoint()
 */
public Point getReferencePoint() {
    return location;
}

/**
 * Sets the location of this anchor and notifies all the listeners of the update.
 *
 * @param p the new location of this anchor
 * @see  #getLocation(Point)
 * @since 2.0
 */
public void setLocation(Point p) {
    location.setLocation(p);
    fireAnchorMoved();
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
