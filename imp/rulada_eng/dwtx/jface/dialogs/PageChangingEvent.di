/*******************************************************************************
 * Copyright (c) 2006, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Chris Gross (schtoo@schtoo.com) - initial API and implementation for bug 16179
 *     IBM Corporation - revisions to initial contribution
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.dialogs.PageChangingEvent;


import dwtx.core.runtime.Assert;

import dwt.dwthelper.utils;

/**
 * Event object describing an <code>IDialogPage</code> in the midst of changing.
 *
 * @see IPageChangingListener
 * @since 3.3
 */
public class PageChangingEvent : EventObject {


    private static const long serialVersionUID = 1L;

    private Object currentPage;

    private Object targetPage;

    /**
     * Public field that dictates if the page change will successfully change.
     *
     * Set this field to <code>false</code> to prevent the page from changing.
     *
     * Default value is <code>true</code>.
     */
    public bool doit = true;

    /**
     * Creates a new event for the given source, selected (current) page and
     * direction.
     *
     * @param source
     *            the page changing provider (the source of this event)
     * @param currentPage
     *            the current page. In the JFace provided dialogs this will be
     *            an <code>IDialogPage</code>.
     * @param targetPage
     *            the target page. In the JFace provided dialogs this will be an
     *            <code>IDialogPage</code>.
     */
    public this(Object source, Object currentPage, Object targetPage) {
        super(source);
        Assert.isNotNull(currentPage);
        Assert.isNotNull(targetPage);
        this.currentPage = currentPage;
        this.targetPage = targetPage;
    }

    /**
     * Returns the current page from which the page change originates.
     *
     * @return the current page. In dialogs implemented by JFace,
     *      this will be an <code>IDialogPage</code>.
     */
    public Object getCurrentPage() {
        return currentPage;
    }

    /**
     * Returns the target page to change to.
     *
     * @return the target page. In dialogs implemented by JFace,
     *      this will be an <code>IDialogPage</code>.
     */
    public Object getTargetPage() {
        return targetPage;
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
