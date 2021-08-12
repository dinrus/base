/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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
module dwtx.jface.viewers.CheckboxTableViewer;

import dwtx.jface.viewers.ICheckable;
import dwtx.jface.viewers.TableViewer;
import dwtx.jface.viewers.ICheckStateListener;
import dwtx.jface.viewers.CheckStateChangedEvent;
import dwtx.jface.viewers.TableLayout;
import dwtx.jface.viewers.ColumnWeightData;
import dwtx.jface.viewers.CustomHashtable;


import dwt.DWT;
import dwt.events.SelectionEvent;
import dwt.widgets.Composite;
import dwt.widgets.Table;
import dwt.widgets.TableColumn;
import dwt.widgets.TableItem;
import dwt.widgets.Widget;
import dwtx.core.runtime.Assert;
import dwtx.core.runtime.ListenerList;
import dwtx.jface.util.SafeRunnable;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwt.dwthelper.Runnable;

/**
 * A concrete viewer based on an DWT <code>Table</code>
 * control with checkboxes on each node.
 * <p>
 * This class is not intended to be subclassed outside the viewer framework.
 * It is designed to be instantiated with a pre-existing DWT table control and configured
 * with a domain-specific content provider, label provider, element filter (optional),
 * and element sorter (optional).
 * </p>
 * @noextend This class is not intended to be subclassed by clients.
 */
public class CheckboxTableViewer : TableViewer, ICheckable {
    alias TableViewer.preservingSelection preservingSelection;

    /**
     * List of check state listeners (element type: <code>ICheckStateListener</code>).
     */
    private ListenerList checkStateListeners;

    /**
     * Creates a table viewer on a newly-created table control under the given parent.
     * The table control is created using the DWT style bits:
     * <code>DWT.CHECK</code> and <code>DWT.BORDER</code>.
     * The table has one column.
     * The viewer has no input, no content provider, a default label provider,
     * no sorter, and no filters.
     * <p>
     * This is equivalent to calling <code>new CheckboxTableViewer(parent, DWT.BORDER)</code>.
     * See that constructor for more details.
     * </p>
     *
     * @param parent the parent control
     *
     * @deprecated use newCheckList(Composite, int) or new CheckboxTableViewer(Table)
     *   instead (see below for details)
     */
    public this(Composite parent) {
        this(parent, DWT.BORDER);
    }

    /**
     * Creates a table viewer on a newly-created table control under the given parent.
     * The table control is created using the given DWT style bits, plus the
     * <code>DWT.CHECK</code> style bit.
     * The table has one column.
     * The viewer has no input, no content provider, a default label provider,
     * no sorter, and no filters.
     * <p>
     * This also adds a <code>TableColumn</code> for the single column,
     * and sets a <code>TableLayout</code> on the table which sizes the column to fill
     * the table for its initial sizing, but does nothing on subsequent resizes.
     * </p>
     * <p>
     * If the caller just needs to show a single column with no header,
     * it is preferable to use the <code>newCheckList</code> factory method instead,
     * since DWT properly handles the initial sizing and subsequent resizes in this case.
     * </p>
     * <p>
     * If the caller adds its own columns, uses <code>Table.setHeadersVisible(true)</code>,
     * or needs to handle dynamic resizing of the table, it is recommended to
     * create the <code>Table</code> itself, specifying the <code>DWT.CHECK</code> style bit
     * (along with any other style bits needed), and use <code>new CheckboxTableViewer(Table)</code>
     * rather than this constructor.
     * </p>
     *
     * @param parent the parent control
     * @param style DWT style bits
     *
     * @deprecated use newCheckList(Composite, int) or new CheckboxTableViewer(Table)
     *   instead (see above for details)
     */
    public this(Composite parent, int style) {
        this(createTable(parent, style));
    }

    /**
     * Creates a table viewer on a newly-created table control under the given parent.
     * The table control is created using the given DWT style bits, plus the
     * <code>DWT.CHECK</code> style bit.
     * The table shows its contents in a single column, with no header.
     * The viewer has no input, no content provider, a default label provider,
     * no sorter, and no filters.
     * <p>
     * No <code>TableColumn</code> is added. DWT does not require a
     * <code>TableColumn</code> if showing only a single column with no header.
     * DWT correctly handles the initial sizing and subsequent resizes in this case.
     *
     * @param parent the parent control
     * @param style DWT style bits
     *
     * @since 2.0
     * @return CheckboxTableViewer
     */
    public static CheckboxTableViewer newCheckList(Composite parent, int style) {
        Table table = new Table(parent, DWT.CHECK | style);
        return new CheckboxTableViewer(table);
    }

    /**
     * Creates a table viewer on the given table control.
     * The <code>DWT.CHECK</code> style bit must be set on the given table control.
     * The viewer has no input, no content provider, a default label provider,
     * no sorter, and no filters.
     *
     * @param table the table control
     */
    public this(Table table) {
        super(table);
        checkStateListeners = new ListenerList();
    }

    /* (non-Javadoc)
     * Method declared on ICheckable.
     */
    public void addCheckStateListener(ICheckStateListener listener) {
        checkStateListeners.add(cast(Object)listener);
    }

    /**
     * Creates a new table control with one column.
     *
     * @param parent the parent control
     * @param style style bits
     * @return a new table control
     */
    protected static Table createTable(Composite parent, int style) {
        Table table = new Table(parent, DWT.CHECK | style);

        // Although this table column is not needed, and can cause resize problems,
        // it can't be removed since this would be a breaking change against R1.0.
        // See bug 6643 for more details.
        new TableColumn(table, DWT.NONE);
        TableLayout layout = new TableLayout();
        layout.addColumnData(new ColumnWeightData(100));
        table.setLayout(layout);

        return table;
    }

    /**
     * Notifies any check state listeners that a check state changed  has been received.
     * Only listeners registered at the time this method is called are notified.
     *
     * @param event a check state changed event
     *
     * @see ICheckStateListener#checkStateChanged
     */
    private void fireCheckStateChanged(CheckStateChangedEvent event) {
        Object[] array = checkStateListeners.getListeners();
        for (int i = 0; i < array.length; i++) {
            SafeRunnable.run( dgSafeRunnable( (ICheckStateListener l, CheckStateChangedEvent event_) {
                l.checkStateChanged(event_);
            }, cast(ICheckStateListener) array[i], event ));
        }
    }

    /* (non-Javadoc)
     * Method declared on ICheckable.
     */
    public bool getChecked(Object element) {
        Widget widget = findItem(element);
        if ( auto ti = cast(TableItem) widget ) {
            return ti.getChecked();
        }
        return false;
    }

    /**
     * Returns a list of elements corresponding to checked table items in this
     * viewer.
     * <p>
     * This method is typically used when preserving the interesting
     * state of a viewer; <code>setCheckedElements</code> is used during the restore.
     * </p>
     *
     * @return the array of checked elements
     * @see #setCheckedElements
     */
    public Object[] getCheckedElements() {
        TableItem[] children = getTable().getItems();
        ArrayList v = new ArrayList(children.length);
        for (int i = 0; i < children.length; i++) {
            TableItem item = children[i];
            if (item.getChecked()) {
                v.add(item.getData());
            }
        }
        return v.toArray();
    }

    /**
     * Returns the grayed state of the given element.
     *
     * @param element the element
     * @return <code>true</code> if the element is grayed,
     *   and <code>false</code> if not grayed
     */
    public bool getGrayed(Object element) {
        Widget widget = findItem(element);
        if ( auto ti = cast(TableItem) widget ) {
            return ti.getGrayed();
        }
        return false;
    }

    /**
     * Returns a list of elements corresponding to grayed nodes in this
     * viewer.
     * <p>
     * This method is typically used when preserving the interesting
     * state of a viewer; <code>setGrayedElements</code> is used during the restore.
     * </p>
     *
     * @return the array of grayed elements
     * @see #setGrayedElements
     */
    public Object[] getGrayedElements() {
        TableItem[] children = getTable().getItems();
        ArrayList v = new ArrayList(children.length);
        for (int i = 0; i < children.length; i++) {
            TableItem item = children[i];
            if (item.getGrayed()) {
                v.add(item.getData());
            }
        }
        return v.toArray();
    }

    /* (non-Javadoc)
     * Method declared on StructuredViewer.
     */
    public override void handleSelect(SelectionEvent event) {
        if (event.detail is DWT.CHECK) {
            super.handleSelect(event); // this will change the current selection

            TableItem item = cast(TableItem) event.item;
            Object data = item.getData();
            if (data !is null) {
                fireCheckStateChanged(new CheckStateChangedEvent(this, data,
                        item.getChecked()));
            }
        } else {
            super.handleSelect(event);
        }
    }

    /* (non-Javadoc)
     * Method declared on Viewer.
     */
    protected override void preservingSelection(Runnable updateCode) {

        TableItem[] children = getTable().getItems();
        CustomHashtable checked = newHashtable(children.length * 2 + 1);
        CustomHashtable grayed = newHashtable(children.length * 2 + 1);

        for (int i = 0; i < children.length; i++) {
            TableItem item = children[i];
            Object data = item.getData();
            if (data !is null) {
                if (item.getChecked()) {
                    checked.put(data, data);
                }
                if (item.getGrayed()) {
                    grayed.put(data, data);
                }
            }
        }

        super.preservingSelection(updateCode);

        children = getTable().getItems();
        for (int i = 0; i < children.length; i++) {
            TableItem item = children[i];
            Object data = item.getData();
            if (data !is null) {
                item.setChecked(checked.containsKey(data));
                item.setGrayed(grayed.containsKey(data));
            }
        }
    }

    /* (non-Javadoc)
     * Method declared on ICheckable.
     */
    public void removeCheckStateListener(ICheckStateListener listener) {
        checkStateListeners.remove(cast(Object)listener);
    }

    /**
     * Sets to the given value the checked state for all elements in this viewer.
     * Does not fire events to check state listeners.
     *
     * @param state <code>true</code> if the element should be checked,
     *  and <code>false</code> if it should be unchecked
     */
    public void setAllChecked(bool state) {
        TableItem[] children = getTable().getItems();
        for (int i = 0; i < children.length; i++) {
            TableItem item = children[i];
            item.setChecked(state);
        }
    }

    /**
     * Sets to the given value the grayed state for all elements in this viewer.
     *
     * @param state <code>true</code> if the element should be grayed,
     *  and <code>false</code> if it should be ungrayed
     */
    public void setAllGrayed(bool state) {
        TableItem[] children = getTable().getItems();
        for (int i = 0; i < children.length; i++) {
            TableItem item = children[i];
            item.setGrayed(state);
        }
    }

    /* (non-Javadoc)
     * Method declared on ICheckable.
     */
    public bool setChecked(Object element, bool state) {
        Assert.isNotNull(element);
        Widget widget = findItem(element);
        if ( auto ti = cast(TableItem) widget ) {
            ti.setChecked(state);
            return true;
        }
        return false;
    }

    /**
     * Sets which nodes are checked in this viewer.
     * The given list contains the elements that are to be checked;
     * all other nodes are to be unchecked.
     * Does not fire events to check state listeners.
     * <p>
     * This method is typically used when restoring the interesting
     * state of a viewer captured by an earlier call to <code>getCheckedElements</code>.
     * </p>
     *
     * @param elements the list of checked elements (element type: <code>Object</code>)
     * @see #getCheckedElements
     */
    public void setCheckedElements(Object[] elements) {
        assertElementsNotNull(elements);
        CustomHashtable set = newHashtable(elements.length * 2 + 1);
        for (int i = 0; i < elements.length; ++i) {
            set.put(elements[i], elements[i]);
        }
        TableItem[] items = getTable().getItems();
        for (int i = 0; i < items.length; ++i) {
            TableItem item = items[i];
            Object element = item.getData();
            if (element !is null) {
                bool check = set.containsKey(element);
                // only set if different, to avoid flicker
                if (item.getChecked() !is check) {
                    item.setChecked(check);
                }
            }
        }
    }

    /**
     * Sets the grayed state for the given element in this viewer.
     *
     * @param element the element
     * @param state <code>true</code> if the item should be grayed,
     *  and <code>false</code> if it should be ungrayed
     * @return <code>true</code> if the element is visible and the gray
     *  state could be set, and <code>false</code> otherwise
     */
    public bool setGrayed(Object element, bool state) {
        Assert.isNotNull(element);
        Widget widget = findItem(element);
        if ( auto ti = cast(TableItem) widget ) {
            ti.setGrayed(state);
            return true;
        }
        return false;
    }

    /**
     * Sets which nodes are grayed in this viewer.
     * The given list contains the elements that are to be grayed;
     * all other nodes are to be ungrayed.
     * <p>
     * This method is typically used when restoring the interesting
     * state of a viewer captured by an earlier call to <code>getGrayedElements</code>.
     * </p>
     *
     * @param elements the array of grayed elements
     *
     * @see #getGrayedElements
     */
    public void setGrayedElements(Object[] elements) {
        assertElementsNotNull(elements);
        CustomHashtable set = newHashtable(elements.length * 2 + 1);
        for (int i = 0; i < elements.length; ++i) {
            set.put(elements[i], elements[i]);
        }
        TableItem[] items = getTable().getItems();
        for (int i = 0; i < items.length; ++i) {
            TableItem item = items[i];
            Object element = item.getData();
            if (element !is null) {
                bool gray = set.containsKey(element);
                // only set if different, to avoid flicker
                if (item.getGrayed() !is gray) {
                    item.setGrayed(gray);
                }
            }
        }
    }
}
