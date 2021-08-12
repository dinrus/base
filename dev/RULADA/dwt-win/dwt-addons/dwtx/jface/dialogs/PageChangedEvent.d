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
module dwtx.jface.dialogs.PageChangedEvent;

import dwtx.jface.dialogs.IPageChangeProvider;

import dwtx.core.runtime.Assert;

import dwt.dwthelper.utils;

/**
 * Event object describing a page selection change. The source of these events
 * is a page change provider.
 *
 * @see IPageChangeProvider
 * @see IPageChangedListener
 *
 * @since 3.1
 */
public class PageChangedEvent : EventObject {

    /**
     * Generated serial version UID for this class.
     *
     * @since 3.1
     */
    private static const long serialVersionUID = 3835149545519723574L;

    /**
     * The selected page.
     */
    protected Object selectedPage;

    /**
     * Creates a new event for the given source and selected page.
     *
     * @param source
     *            the page change provider
     * @param selectedPage
     *            the selected page. In the JFace provided dialogs this
     *            will be an <code>IDialogPage</code>.
     */
    public this(IPageChangeProvider source,
            Object selectedPage) {
        super( cast(Object) source);
        Assert.isNotNull(selectedPage);
        this.selectedPage = selectedPage;
    }

    /**
     * Returns the selected page.
     *
     * @return the selected page. In dialogs implemented by JFace,
     *      this will be an <code>IDialogPage</code>.
     */
    public Object getSelectedPage() {
        return selectedPage;
    }

    /**
     * Returns the page change provider that is the source of this event.
     *
     * @return the originating page change provider
     */
    public IPageChangeProvider getPageChangeProvider() {
        return cast(IPageChangeProvider) getSource();
    }
}
