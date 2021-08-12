/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module dwtx.jface.viewers.DoubleClickEvent;

import dwtx.jface.viewers.ISelection;
import dwtx.jface.viewers.Viewer;

import dwtx.core.runtime.Assert;

import dwt.dwthelper.utils;

/**
 * Event object describing a double-click. The source of these
 * events is a viewer.
 *
 * @see IDoubleClickListener
 */
public class DoubleClickEvent : EventObject {

    /**
     * Generated serial version UID for this class.
     * @since 3.1
     */
    private static const long serialVersionUID = 3258408443605038133L;

    /**
     * The selection.
     */
    protected ISelection selection;

    /**
     * Creates a new event for the given source and selection.
     *
     * @param source the viewer
     * @param selection the selection
     */
    public this(Viewer source, ISelection selection) {
        super(source);
        Assert.isNotNull(cast(Object)selection);
        this.selection = selection;
    }

    /**
     * Returns the selection.
     *
     * @return the selection
     */
    public ISelection getSelection() {
        return selection;
    }

    /**
     * Returns the viewer that is the source of this event.
     *
     * @return the originating viewer
     */
    public Viewer getViewer() {
        return cast(Viewer) getSource();
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
