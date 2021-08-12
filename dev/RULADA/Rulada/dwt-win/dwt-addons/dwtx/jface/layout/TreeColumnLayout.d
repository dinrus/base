/*******************************************************************************
 * Copyright (c) 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
 *                                               - fix for bug 178280, 183999, 184609
 *     IBM Corporation - API refactoring and general maintenance
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/

module dwtx.jface.layout.TreeColumnLayout;

import dwtx.jface.layout.AbstractColumnLayout;

import dwt.events.TreeEvent;
import dwt.events.TreeListener;
import dwt.widgets.Composite;
import dwt.widgets.Layout;
import dwt.widgets.Scrollable;
import dwt.widgets.Tree;
import dwt.widgets.TreeColumn;
import dwt.widgets.Widget;
import dwtx.jface.viewers.ColumnLayoutData;
import dwtx.jface.viewers.ColumnPixelData;

import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;

/**
 * The TreeColumnLayout is the {@link Layout} used to maintain {@link TreeColumn} sizes in a
 * {@link Tree}.
 *
 * <p>
 * <b>You can only add the {@link Layout} to a container whose <i>only</i>
 * child is the {@link Tree} control you want the {@link Layout} applied to.
 * Don't assign the layout directly the {@link Tree}</b>
 * </p>
 *
 * @since 3.3
 */
public class TreeColumnLayout : AbstractColumnLayout {
    private bool addListener = true;

    private static class TreeLayoutListener : TreeListener {

        public void treeCollapsed(TreeEvent e) {
            update(cast(Tree) e.widget);
        }

        public void treeExpanded(TreeEvent e) {
            update(cast(Tree) e.widget);
        }

        private void update(Tree tree) {
            tree.getDisplay().asyncExec(new class(tree) Runnable {
                Tree tree_;
                this(Tree a){
                    tree_=a;
                }
                public void run() {
                    tree_.update();
                    tree_.getParent().layout();
                }

            });
        }

    }

    private static const TreeLayoutListener listener;

    static this(){
        listener = new TreeLayoutListener();
    }

    protected override void layout(Composite composite, bool flushCache) {
        super.layout(composite, flushCache);
        if( addListener ) {
            addListener=false;
            (cast(Tree)getControl(composite)).addTreeListener(listener);
        }
    }

    /* (non-Javadoc)
     * @see dwtx.jface.layout.AbstractColumnLayout#getColumnCount(dwt.widgets.Scrollable)
     */
    override int getColumnCount(Scrollable tree) {
        return (cast(Tree) tree).getColumnCount();
    }

    /* (non-Javadoc)
     * @see dwtx.jface.layout.AbstractColumnLayout#setColumnWidths(dwt.widgets.Scrollable, int[])
     */
    override void setColumnWidths(Scrollable tree, int[] widths) {
        TreeColumn[] columns = (cast(Tree) tree).getColumns();
        for (int i = 0; i < widths.length; i++) {
            columns[i].setWidth(widths[i]);
        }
    }

    /* (non-Javadoc)
     * @see dwtx.jface.layout.AbstractColumnLayout#getLayoutData(dwt.widgets.Scrollable, int)
     */
    override ColumnLayoutData getLayoutData(Scrollable tableTree, int columnIndex) {
        TreeColumn column = (cast(Tree) tableTree).getColumn(columnIndex);
        return cast(ColumnLayoutData) column.getData(LAYOUT_DATA);
    }

    override void updateColumnData(Widget column) {
        TreeColumn tColumn = cast(TreeColumn) column;
        Tree t = tColumn.getParent();

        if( ! IS_GTK || t.getColumn(t.getColumnCount()-1) !is tColumn ){
            tColumn.setData(LAYOUT_DATA,new ColumnPixelData(tColumn.getWidth()));
            layout(t.getParent(), true);
        }
    }
}
