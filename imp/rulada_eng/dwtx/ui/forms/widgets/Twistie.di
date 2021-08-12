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
module dwtx.ui.forms.widgets.Twistie;

import dwtx.ui.forms.widgets.ToggleHyperlink;

import dwt.DWT;
import dwt.graphics.Color;
import dwt.graphics.GC;
import dwt.graphics.Point;
import dwt.widgets.Composite;

import dwt.dwthelper.utils;

/**
 * A custom selectable control that can be used to control areas that can be
 * expanded or collapsed. The control control can be toggled between selected
 * and deselected state with a mouse or by pressing 'Enter' while the control
 * has focus.
 * <p>
 * The control is rendered as a triangle that points to the right in the
 * collapsed and down in the expanded state. Triangle color can be changed.
 *
 * @see TreeNode
 * @since 3.0
 */
public class Twistie : ToggleHyperlink {
    private static const int[] onPoints = [ 0, 2, 8, 2, 4, 6 ];

    private static const int[] offPoints = [ 2, -1, 2, 8, 6, 4 ];

    /**
     * Creates a control in a provided composite.
     *
     * @param parent
     *            the parent
     * @param style
     *            the style
     */
    public this(Composite parent, int style) {
        super(parent, style);
        innerWidth = 9;
        innerHeight = 9;
    }

    /*
     * @see SelectableControl#paint(GC)
     */
    protected void paintHyperlink(GC gc) {
        Color bg;
        if (!isEnabled())
            bg = getDisplay().getSystemColor(DWT.COLOR_WIDGET_NORMAL_SHADOW);
        else if (hover && getHoverDecorationColor() !is null)
            bg = getHoverDecorationColor();
        else if (getDecorationColor() !is null)
            bg = getDecorationColor();
        else
            bg = getForeground();
        gc.setBackground(bg);
        int[] data;
        Point size = getSize();
        int x = (size.x - 9) / 2;
        int y = (size.y - 9) / 2;
        if (isExpanded())
            data = translate(onPoints, x, y);
        else
            data = translate(offPoints, x, y);
        gc.fillPolygon(data);
        gc.setBackground(getBackground());
    }

    private int[] translate(int[] data, int x, int y) {
        int[] target = new int[data.length];
        for (int i = 0; i < data.length; i += 2) {
            target[i] = data[i] + x;
        }
        for (int i = 1; i < data.length; i += 2) {
            target[i] = data[i] + y;
        }
        return target;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwt.widgets.Control#setEnabled(bool)
     */
    public void setEnabled(bool enabled) {
        super.setEnabled(enabled);
        redraw();
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
