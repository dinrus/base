/*******************************************************************************
 * Copyright (c) 2006 Tom Schindl and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Tom Schindl - initial API and implementation
 *     Boris Bokowski (IBM Corporation) - Javadoc improvements
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 ******************************************************************************/

module dwtx.jface.viewers.TableViewerColumn;

import dwtx.jface.viewers.ViewerColumn;
import dwtx.jface.viewers.TableViewer;

import dwt.widgets.Table;
import dwt.widgets.TableColumn;

import dwt.dwthelper.utils;

/**
 * ViewerColumn implementation for TableViewer to enable column-specific label
 * providers and editing support.
 *
 * @since 3.3
 */
public final class TableViewerColumn : ViewerColumn {
    private TableColumn column;

    /**
     * Creates a new viewer column for the given {@link TableViewer} on a new
     * {@link TableColumn} with the given style bits. The column is added at the
     * end of the list of columns.
     *
     * @param viewer
     *            the table viewer to which this column belongs
     * @param style
     *            the style used to create the column, for applicable style bits
     *            see {@link TableColumn}
     * @see TableColumn#TableColumn(Table, int)
     */
    public this(TableViewer viewer, int style) {
        this(viewer, style, -1);
    }

    /**
     * Creates a new viewer column for the given {@link TableViewer} on a new
     * {@link TableColumn} with the given style bits. The column is inserted at
     * the given index into the list of columns.
     *
     * @param viewer
     *            the table viewer to which this column belongs
     * @param style
     *            the style used to create the column, for applicable style bits
     *            see {@link TableColumn}
     * @param index
     *            the index at which to place the newly created column
     * @see TableColumn#TableColumn(Table, int, int)
     */
    public this(TableViewer viewer, int style, int index) {
        this(viewer, createColumn(viewer.getTable(), style, index));
    }

    /**
     * Creates a new viewer column for the given {@link TableViewer} on the given
     * {@link TableColumn}.
     *
     * @param viewer
     *            the table viewer to which this column belongs
     * @param column
     *            the underlying table column
     */
    public this(TableViewer viewer, TableColumn column) {
        super(viewer, column);
        this.column = column;
    }

    private static TableColumn createColumn(Table table, int style, int index) {
        if (index >= 0) {
            return new TableColumn(table, style, index);
        }

        return new TableColumn(table, style);
    }

    /**
     * @return the underlying DWT table column
     */
    public TableColumn getColumn() {
        return column;
    }
}
