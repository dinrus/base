/*******************************************************************************
 * Copyright (c) 2005 IBM Corporation and others.
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

module dwtx.draw2d.NativeGraphicsSource;

import dwt.dwthelper.utils;



import dwt.widgets.Control;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.GraphicsSource;
import dwtx.draw2d.Graphics;

/**
 * A graphics source that posts a paint request to the control rather than constructing GC
 * on it directly. This allows the OS's native painting mechanism to be used directly,
 * including any double-buffering that the OS may provide for free.
 * @since 3.2
 */
public final class NativeGraphicsSource : GraphicsSource {

private final Control canvas;

/**
 * Constructs a new graphics source on the given control.
 * @param canvas the control
 * @since 3.2
 */
public this(Control canvas) {
    this.canvas = canvas;
}

/**
 * Always returns <code>null</code>, because
 * @see GraphicsSource#getGraphics(Rectangle)
 */
public Graphics getGraphics(Rectangle r) {
    canvas.redraw(r.x, r.y, r.width, r.height, false);
    canvas.update();
    return null;
}

/**
 * Does nothing.
 * @see GraphicsSource#flushGraphics(Rectangle)
 */
public void flushGraphics(Rectangle region) { }

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
