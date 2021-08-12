/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Florian Priester - bug 106059
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.viewers.TableLayout;

import dwtx.jface.viewers.ColumnLayoutData;
import dwtx.jface.viewers.ColumnPixelData;
import dwtx.jface.viewers.ColumnWeightData;


import dwt.DWT;
import dwt.graphics.Point;
import dwt.widgets.Composite;
import dwt.widgets.Item;
import dwt.widgets.Layout;
import dwt.widgets.Table;
import dwt.widgets.TableColumn;
import dwt.widgets.Tree;
import dwt.widgets.TreeColumn;
import dwtx.core.runtime.Assert;
import dwtx.jface.layout.TableColumnLayout;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

/**
 * A layout for a table. Call <code>addColumnData</code> to add columns.
 * The TableLayout {@link ColumnLayoutData} is only valid until the table
 * is resized. To keep the proportions constant when the table is resized
 * see {@link TableColumnLayout}
 */
public class TableLayout : Layout {

    /**
     * The number of extra pixels taken as horizontal trim by the table column.
     * To ensure there are N pixels available for the content of the column,
     * assign N+COLUMN_TRIM for the column width.
     *
     * @since 3.1
     */
    private static int COLUMN_TRIM_ = -1;
    private static int COLUMN_TRIM(){
        if( COLUMN_TRIM_ is -1 ){
            synchronized( TableLayout.classinfo ){
                if( COLUMN_TRIM_ is -1 ){
                    if ("win32".equals(DWT.getPlatform())) { //$NON-NLS-1$
                        COLUMN_TRIM_ = 4;
                    } else if ("carbon".equals(DWT.getPlatform())) { //$NON-NLS-1$
                        COLUMN_TRIM_ = 24;
                    } else {
                        COLUMN_TRIM_ = 3;
                    }
                }
            }
        }
        return COLUMN_TRIM_;
    }

    /**
     * The list of column layout data (element type:
     * <code>ColumnLayoutData</code>).
     */
    private List columns;

    /**
     * Indicates whether <code>layout</code> has yet to be called.
     */
    private bool firstTime = true;

    /**
     * Creates a new table layout.
     */
    public this() {
        columns = new ArrayList();
    }

    /**
     * Adds a new column of data to this table layout.
     *
     * @param data
     *            the column layout data
     */
    public void addColumnData(ColumnLayoutData data) {
        columns.add(data);
    }

    /*
     * (non-Javadoc) Method declared on Layout.
     */
    public override Point computeSize(Composite c, int wHint, int hHint, bool flush) {
        if (wHint !is DWT.DEFAULT && hHint !is DWT.DEFAULT) {
            return new Point(wHint, hHint);
        }

        Table table = cast(Table) c;
        // To avoid recursions.
        table.setLayout(null);
        // Use native layout algorithm
        Point result = table.computeSize(wHint, hHint, flush);
        table.setLayout(this);

        int width = 0;
        int size = columns.size();
        for (int i = 0; i < size; ++i) {
            ColumnLayoutData layoutData = cast(ColumnLayoutData) columns.get(i);
            if ( auto col = cast(ColumnPixelData) layoutData ) {
                width += col.width;
                if (col.addTrim) {
                    width += COLUMN_TRIM;
                }
            } else if ( auto col = cast(ColumnWeightData) layoutData ) {
                width += col.minimumWidth;
            } else {
                Assert.isTrue(false, "Unknown column layout data");//$NON-NLS-1$
            }
        }
        if (width > result.x) {
            result.x = width;
        }
        return result;
    }

    /*
     * (non-Javadoc) Method declared on Layout.
     */
    public override void layout(Composite c, bool flush) {
        // Only do initial layout. Trying to maintain proportions when resizing
        // is too hard,
        // causes lots of widget flicker, causes scroll bars to appear and
        // occasionally stick around (on Windows),
        // requires hooking column resizing as well, and may not be what the
        // user wants anyway.
        if (!firstTime) {
            return;
        }

        int width = c.getClientArea().width;

        // XXX: Layout is being called with an invalid value the first time
        // it is being called on Linux. This method resets the
        // Layout to null so we make sure we run it only when
        // the value is OK.
        if (width <= 1) {
            return;
        }

        Item[] tableColumns = getColumns(c);
        int size = Math.min(columns.size(), tableColumns.length);
        int[] widths = new int[size];
        int fixedWidth = 0;
        int numberOfWeightColumns = 0;
        int totalWeight = 0;

        // First calc space occupied by fixed columns
        for (int i = 0; i < size; i++) {
            ColumnLayoutData col = cast(ColumnLayoutData) columns.get(i);
            if ( auto cpd = cast(ColumnPixelData) col ) {
                int pixels = cpd.width;
                if (cpd.addTrim) {
                    pixels += COLUMN_TRIM;
                }
                widths[i] = pixels;
                fixedWidth += pixels;
            } else if ( auto cw = cast(ColumnWeightData) col ) {
                numberOfWeightColumns++;
                // first time, use the weight specified by the column data,
                // otherwise use the actual width as the weight
                // int weight = firstTime ? cw.weight :
                // tableColumns[i].getWidth();
                int weight = cw.weight;
                totalWeight += weight;
            } else {
                Assert.isTrue(false, "Unknown column layout data");//$NON-NLS-1$
            }
        }

        // Do we have columns that have a weight
        if (numberOfWeightColumns > 0) {
            // Now distribute the rest to the columns with weight.
            int rest = width - fixedWidth;
            int totalDistributed = 0;
            for (int i = 0; i < size; ++i) {
                ColumnLayoutData col = cast(ColumnLayoutData) columns.get(i);
                if (auto cw = cast(ColumnWeightData) col ) {
                    // calculate weight as above
                    // int weight = firstTime ? cw.weight :
                    // tableColumns[i].getWidth();
                    int weight = cw.weight;
                    int pixels = totalWeight is 0 ? 0 : weight * rest
                            / totalWeight;
                    if (pixels < cw.minimumWidth) {
                        pixels = cw.minimumWidth;
                    }
                    totalDistributed += pixels;
                    widths[i] = pixels;
                }
            }

            // Distribute any remaining pixels to columns with weight.
            int diff = rest - totalDistributed;
            for (int i = 0; diff > 0; ++i) {
                if (i is size) {
                    i = 0;
                }
                ColumnLayoutData col = cast(ColumnLayoutData) columns.get(i);
                if (cast(ColumnWeightData)col ) {
                    ++widths[i];
                    --diff;
                }
            }
        }

        firstTime = false;

        for (int i = 0; i < size; i++) {
            setWidth(tableColumns[i], widths[i]);
        }
    }

    /**
     * Set the width of the item.
     *
     * @param item
     * @param width
     */
    private void setWidth(Item item, int width) {
        if ( cast(TreeColumn)item ) {
            (cast(TreeColumn) item).setWidth(width);
        } else {
            (cast(TableColumn) item).setWidth(width);
        }

    }

    /**
     * Return the columns for the receiver.
     *
     * @param composite
     * @return Item[]
     */
    private Item[] getColumns(Composite composite) {
        if (cast(Tree)composite ) {
            return (cast(Tree) composite).getColumns();
        }
        return (cast(Table) composite).getColumns();
    }
}
