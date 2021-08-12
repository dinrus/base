/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *******************************************************************************/
module dwtx.draw2d.MouseMotionListener;

import dwt.dwthelper.utils;
import dwtx.draw2d.MouseEvent;
/**
 * A listener interface for receiving mouse motion events.
 */
public interface MouseMotionListener {

/**
 * Called when the mouse has moved over the listened to object while a button was pressed.
 * @param me The MouseEvent object
 */
void mouseDragged(MouseEvent me);

/**
 * Called when the mouse has entered the listened to object.
 * @param me The MouseEvent object
 */
void mouseEntered(MouseEvent me);

/**
 * Called when the mouse has exited the listened to object.
 * @param me The MouseEvent object
 */
void mouseExited(MouseEvent me);

/**
 * Called when the mouse hovers over the listened to object.
 * @param me The MouseEvent object
 */
void mouseHover(MouseEvent me);

/**
 * Called when the mouse has moved over the listened to object.
 * @param me The MouseEvent object
 */
void mouseMoved(MouseEvent me);

/**
 * An empty implementation of MouseMotionListener for convenience.
 */
static public class Stub
    : MouseMotionListener
{
    /**
     * @see dwtx.draw2d.MouseMotionListener#mouseDragged(MouseEvent)
     */
    public void mouseDragged(MouseEvent me) { }
    /**
     * @see dwtx.draw2d.MouseMotionListener#mouseEntered(MouseEvent)
     */
    public void mouseEntered(MouseEvent me) { }
    /**
     * @see dwtx.draw2d.MouseMotionListener#mouseExited(MouseEvent)
     */
    public void mouseExited(MouseEvent me) { }
    /**
     * @see dwtx.draw2d.MouseMotionListener#mouseMoved(MouseEvent)
     */
    public void mouseMoved(MouseEvent me) { }
    /**
     * @see dwtx.draw2d.MouseMotionListener#mouseHover(MouseEvent)
     */
    public void mouseHover(MouseEvent me) { }
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