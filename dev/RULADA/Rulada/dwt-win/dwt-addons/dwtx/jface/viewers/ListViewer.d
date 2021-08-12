/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Brad Reynolds - bug 141435
 *     Tom Schindl <tom.schindl@bestsolution.at> - bug 157309, 177619
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/

module dwtx.jface.viewers.ListViewer;

import dwtx.jface.viewers.AbstractListViewer;


import dwt.DWT;
import dwt.graphics.Rectangle;
import dwt.widgets.Composite;
import dwt.widgets.Control;
static import dwt.widgets.List;
import dwtx.core.runtime.Assert;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

/**
 * A concrete viewer based on an DWT <code>List</code> control.
 * <p>
 * This class is not intended to be subclassed. It is designed to be
 * instantiated with a pre-existing DWT <code>List</code> control and configured
 * with a domain-specific content provider, label provider, element filter (optional),
 * and element sorter (optional).
 * <p>
 * Note that the DWT <code>List</code> control only supports the display of strings, not icons.
 * If you need to show icons for items, use <code>TableViewer</code> instead.
 * </p>
 *
 * @see TableViewer
 * @noextend This class is not intended to be subclassed by clients.
 */
public class ListViewer : AbstractListViewer {
    alias AbstractListViewer.setSelectionToWidget setSelectionToWidget;

    /**
     * This viewer's list control.
     */
    private dwt.widgets.List.List list;

    /**
     * Creates a list viewer on a newly-created list control under the given parent.
     * The list control is created using the DWT style bits <code>MULTI, H_SCROLL, V_SCROLL,</code> and <code>BORDER</code>.
     * The viewer has no input, no content provider, a default label provider,
     * no sorter, and no filters.
     *
     * @param parent the parent control
     */
    public this(Composite parent) {
        this(parent, DWT.MULTI | DWT.H_SCROLL | DWT.V_SCROLL | DWT.BORDER);
    }

    /**
     * Creates a list viewer on a newly-created list control under the given parent.
     * The list control is created using the given DWT style bits.
     * The viewer has no input, no content provider, a default label provider,
     * no sorter, and no filters.
     *
     * @param parent the parent control
     * @param style the DWT style bits
     */
    public this(Composite parent, int style) {
        this(new dwt.widgets.List.List(parent, style));
    }

    /**
     * Creates a list viewer on the given list control.
     * The viewer has no input, no content provider, a default label provider,
     * no sorter, and no filters.
     *
     * @param list the list control
     */
    public this(dwt.widgets.List.List list) {
        this.list = list;
        hookControl(list);
    }

    /* (non-Javadoc)
     * Method declared on Viewer.
     */
    public override Control getControl() {
        return list;
    }

    /**
     * Returns this list viewer's list control.
     *
     * @return the list control
     */
    public dwt.widgets.List.List getList() {
        return list;
    }

    /*
     * Non-Javadoc.
     * Method defined on StructuredViewer.
     */
    public override void reveal(Object element) {
        Assert.isNotNull(element);
        int index = getElementIndex(element);
        if (index is -1) {
            return;
        }
        // algorithm patterned after List.showSelection()
        int count = list.getItemCount();
        if (count is 0) {
            return;
        }
        int height = list.getItemHeight();
        Rectangle rect = list.getClientArea();
        int topIndex = list.getTopIndex();
        int visibleCount = Math.max(rect.height / height, 1);
        int bottomIndex = Math.min(topIndex + visibleCount, count) - 1;
        if ((topIndex <= index) && (index <= bottomIndex)) {
            return;
        }
        int newTop = Math.min(Math.max(index - (visibleCount / 2), 0),
                count - 1);
        list.setTopIndex(newTop);
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.AbstractListViewer#listAdd(java.lang.String, int)
     */
    protected override void listAdd(String string, int index) {
        list.add(string, index);
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.AbstractListViewer#listSetItem(int, java.lang.String)
     */
    protected override void listSetItem(int index, String string) {
        list.setItem(index, string);
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.AbstractListViewer#listGetSelectionIndices()
     */
    protected override int[] listGetSelectionIndices() {
        return list.getSelectionIndices();
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.AbstractListViewer#listGetItemCount()
     */
    protected override int listGetItemCount() {
        return list.getItemCount();
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.AbstractListViewer#listSetItems(java.lang.String[])
     */
    protected override void listSetItems(String[] labels) {
        list.setItems(labels);
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.AbstractListViewer#listRemoveAll()
     */
    protected override void listRemoveAll() {
        list.removeAll();
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.AbstractListViewer#listRemove(int)
     */
    protected override void listRemove(int index) {
        list.remove(index);
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.AbstractListViewer#listSelectAndShow(int[])
     */
    protected override void listSetSelection(int[] ixs) {
        list.setSelection(ixs);
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.AbstractListViewer#listDeselectAll()
     */
    protected override void listDeselectAll() {
        list.deselectAll();
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.AbstractListViewer#listShowSelection()
     */
    protected override void listShowSelection() {
        list.showSelection();
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.AbstractListViewer#listGetTopIndex()
     */
    protected override int listGetTopIndex() {
        return list.getTopIndex();
    }

    /*
     * (non-Javadoc)
     * @see dwtx.jface.viewers.AbstractListViewer#listSetTopIndex(int)
     */
    protected override void listSetTopIndex(int index) {
        list.setTopIndex(index);
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.AbstractListViewer#setSelectionToWidget(java.util.List, bool)
     */
    protected override void setSelectionToWidget(List in_, bool reveal) {
        if( reveal ) {
            super.setSelectionToWidget(in_, reveal);
        } else {
            if (in_ is null || in_.size() is 0) { // clear selection
                list.deselectAll();
            } else {
                int n = in_.size();
                int[] ixs = new int[n];
                int count = 0;
                for (int i = 0; i < n; ++i) {
                    Object el = in_.get(i);
                    int ix = getElementIndex(el);
                    if (ix >= 0) {
                        ixs[count++] = ix;
                    }
                }
                if (count < n) {
                    System.arraycopy(ixs, 0, ixs = new int[count], 0, count);
                }
                list.deselectAll();
                list.select(ixs);
            }
        }
    }


}
