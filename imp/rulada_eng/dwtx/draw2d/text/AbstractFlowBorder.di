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
module dwtx.draw2d.text.AbstractFlowBorder;

import dwt.dwthelper.utils;

import dwtx.draw2d.AbstractBorder;
import dwtx.draw2d.Border;
import dwtx.draw2d.Graphics;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.text.FlowBorder;
import dwtx.draw2d.text.FlowFigure;

/**
 * A basis for implementing {@link FlowBorder}. Subclassing this class will possibly
 * guarantee compatibility with future changes to the FlowBorder interface. This class
 * also returns default values for many of the required methods as a convenience.
 * @since 3.1
 */
public abstract class AbstractFlowBorder
    : AbstractBorder
    , FlowBorder
{
/**
 * @see FlowBorder#getBottomMargin()
 */
public int getBottomMargin() {
    return 0;
}

/**
 * @see Border#getInsets(IFigure)
 */
public Insets getInsets(IFigure figure) {
    return IFigure_NO_INSETS;
}

/**
 * @see FlowBorder#getLeftMargin()
 */
public int getLeftMargin() {
    return 0;
}

/**
 * @see FlowBorder#getRightMargin()
 */
public int getRightMargin() {
    return 0;
}

/**
 * @see FlowBorder#getTopMargin()
 */
public int getTopMargin() {
    return 0;
}

/**
 * This method is not called on FlowBorders. For this reason it is
 * implemented here and made <code>final</code> so that clients override the correct
 * method.
 * @param figure the figure
 * @param graphics the graphics
 * @param insets the insets
 * @see FlowBorder#paint(FlowFigure, Graphics, Rectangle, int)
 */
public final void paint(IFigure figure, Graphics graphics, Insets insets) { }

/**
 * Subclasses should override this method to paint each box's border.
 * @see FlowBorder#paint(FlowFigure, Graphics, Rectangle, int)
 */
public void paint(FlowFigure figure, Graphics g, Rectangle where, int sides) { }

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
