/*******************************************************************************
 * Copyright (c) 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 ******************************************************************************/

module dwtx.jface.viewers.CellNavigationStrategy;

import dwtx.jface.viewers.ColumnViewer;
import dwtx.jface.viewers.ViewerCell;

import dwt.DWT;
import dwt.widgets.Event;

/**
 * This class implementation the strategy how the table is navigated using the
 * keyboard.
 *
 * <p>
 * <b>Subclasses can implement their custom navigation algorithms</b>
 * </p>
 *
 * @since 3.3
 *
 */
public class CellNavigationStrategy {
    /**
     * is the given event an event which moves the selection to another cell
     *
     * @param viewer
     *            the viewer we are working for
     * @param event
     *            the key event
     * @return <code>true</code> if a new cell is searched
     */
    public bool isNavigationEvent(ColumnViewer viewer, Event event) {
        switch (event.keyCode) {
        case DWT.ARROW_UP:
        case DWT.ARROW_DOWN:
        case DWT.ARROW_LEFT:
        case DWT.ARROW_RIGHT:
        case DWT.HOME:
        case DWT.PAGE_DOWN:
        case DWT.PAGE_UP:
        case DWT.END:
            return true;
        default:
            return false;
        }
    }

    /**
     * @param viewer
     *            the viewer we are working for
     * @param cellToCollapse
     *            the cell to collapse
     * @param event
     *            the key event
     * @return <code>true</code> if this event triggers collapsing of a node
     */
    public bool isCollapseEvent(ColumnViewer viewer,
            ViewerCell cellToCollapse, Event event) {
        return false;
    }

    /**
     * @param viewer
     *            the viewer we are working for
     * @param cellToExpand
     *            the cell to expand
     * @param event
     *            the key event
     * @return <code>true</code> if this event triggers expanding of a node
     */
    public bool isExpandEvent(ColumnViewer viewer, ViewerCell cellToExpand,
            Event event) {
        return false;
    }

    /**
     * @param viewer
     *            the viewer working for
     * @param cellToExpand
     *            the cell the user wants to expand
     * @param event
     *            the event triggering the expansion
     */
    public void expand(ColumnViewer viewer, ViewerCell cellToExpand, Event event) {

    }

    /**
     * @param viewer
     *            the viewer working for
     * @param cellToCollapse
     *            the cell the user wants to collapse
     * @param event
     *            the event triggering the expansion
     */
    public void collapse(ColumnViewer viewer, ViewerCell cellToCollapse,
            Event event) {

    }

    /**
     * @param viewer
     *            the viewer we are working for
     * @param currentSelectedCell
     *            the cell currently selected
     * @param event
     *            the key event
     * @return the cell which is highlighted next or <code>null</code> if the
     *         default implementation is taken. E.g. it's fairly impossible to
     *         react on PAGE_DOWN requests
     */
    public ViewerCell findSelectedCell(ColumnViewer viewer,
            ViewerCell currentSelectedCell, Event event) {

        switch (event.keyCode) {
        case DWT.ARROW_UP:
            if (currentSelectedCell !is null) {
                return currentSelectedCell.getNeighbor(ViewerCell.ABOVE, false);
            }
            break;
        case DWT.ARROW_DOWN:
            if (currentSelectedCell !is null) {
                return currentSelectedCell.getNeighbor(ViewerCell.BELOW, false);
            }
            break;
        case DWT.ARROW_LEFT:
            if (currentSelectedCell !is null) {
                return currentSelectedCell.getNeighbor(ViewerCell.LEFT, true);
            }
            break;
        case DWT.ARROW_RIGHT:
            if (currentSelectedCell !is null) {
                return currentSelectedCell.getNeighbor(ViewerCell.RIGHT, true);
            }
            break;
        default:
        }

        return null;
    }

    /**
     * This method is consulted to decide whether an event has to be canceled or
     * not. By default events who collapse/expand tree-nodes are canceled
     *
     * @param viewer
     *            the viewer working for
     * @param event
     *            the event
     * @return <code>true</code> if the event has to be canceled
     */
    public bool shouldCancelEvent(ColumnViewer viewer, Event event) {
        return event.keyCode is DWT.ARROW_LEFT
                || event.keyCode is DWT.ARROW_RIGHT;
    }

    /**
     * This method is called by the framework to initialize this navigation
     * strategy object. Subclasses may extend.
     */
    protected void init() {
    }
    package void init_package() {
        init();
    }
}
