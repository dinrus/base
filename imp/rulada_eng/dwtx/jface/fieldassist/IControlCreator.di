/*******************************************************************************
 * Copyright (c) 2005, 2007 IBM Corporation and others.
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
module dwtx.jface.fieldassist.IControlCreator;

import dwt.widgets.Composite;
import dwt.widgets.Control;

import dwt.dwthelper.utils;

/**
 * This interface is used to create a control with a specific parent and style
 * bits. It is used by {@link DecoratedField} to create the control to be
 * decorated. Clients are expected to implement this interface in order to
 * create a particular kind of control for decoration.
 *
 * @since 3.2
 * @deprecated As of 3.3, clients should use {@link ControlDecoration} instead
 *             of {@link DecoratedField}.
 *
 */
public interface IControlCreator {
    /**
     * Create a control with the specified parent and style bits.
     *
     * @param parent
     *            the parent of the control
     * @param style
     *            the style of the control
     *
     * @return the Control that was created.
     */
    public Control createControl(Composite parent, int style);
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