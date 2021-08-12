/*******************************************************************************
 * Copyright (c) 2006, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation; bug 153993
 *                                                 fix in bug 163317, 151295, 167323, 167858, 184346, 187826, 201905
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/

module dwtx.jface.viewers.ColumnViewer;

import dwtx.jface.viewers.StructuredViewer;
import dwtx.jface.viewers.CellEditor;
import dwtx.jface.viewers.ICellModifier;
import dwtx.jface.viewers.ColumnViewerEditor;
import dwtx.jface.viewers.ViewerCell;
import dwtx.jface.viewers.ViewerRow;
import dwtx.jface.viewers.ViewerColumn;
import dwtx.jface.viewers.CellLabelProvider;
import dwtx.jface.viewers.IBaseLabelProvider;
import dwtx.jface.viewers.ColumnViewerEditorActivationEvent;
import dwtx.jface.viewers.EditingSupport;
import dwtx.jface.viewers.ITableLabelProvider;
import dwtx.jface.viewers.ILabelProvider;
import dwtx.jface.viewers.StructuredSelection;
import dwt.events.MouseAdapter;
import dwt.events.MouseEvent;
import dwt.graphics.Point;
import dwt.widgets.Control;
import dwt.widgets.Item;
import dwt.widgets.Widget;
import dwtx.core.runtime.Assert;
import dwtx.core.runtime.IStatus;
import dwtx.core.runtime.Status;
import dwtx.jface.internal.InternalPolicy;
import dwtx.jface.util.Policy;

import dwt.dwthelper.utils;

/**
 * The ColumnViewer is the abstract superclass of viewers that have columns
 * (e.g., AbstractTreeViewer and AbstractTableViewer). Concrete subclasses of
 * {@link ColumnViewer} should implement a matching concrete subclass of {@link
 * ViewerColumn}.
 *
 * <strong> This class is not intended to be subclassed outside of the JFace
 * viewers framework.</strong>
 *
 * @since 3.3
 *
 */
public abstract class ColumnViewer : StructuredViewer {
    alias StructuredViewer.getLabelProvider getLabelProvider;
    alias StructuredViewer.refresh refresh;
    alias StructuredViewer.update update;

    private CellEditor[] cellEditors;

    private ICellModifier cellModifier;

    private String[] columnProperties;

    /**
     * The cell is a cached viewer cell used for refreshing.
     */
    private ViewerCell cell;

    private ColumnViewerEditor viewerEditor;

    private bool busy;
    private bool logWhenBusy = true; // initially true, set to false

    // after logging for the first
    // time

    /**
     * Create a new instance of the receiver.
     */
    public this() {
        cell = new ViewerCell(null, 0, null);
    }

    protected override void hookControl(Control control) {
        super.hookControl(control);
        viewerEditor = createViewerEditor();
        hookEditingSupport(control);
    }

    /**
     * Hook up the editing support. Subclasses may override.
     *
     * @param control
     *      the control you want to hook on
     */
    protected void hookEditingSupport(Control control) {
        // Needed for backwards comp with AbstractTreeViewer and TableTreeViewer
        // who are not hooked this way others may already overwrite and provide
        // their
        // own impl
        if (viewerEditor !is null) {
            control.addMouseListener(new class MouseAdapter {
                public void mouseDown(MouseEvent e) {
                    // Workaround for bug 185817
                    if (e.count !is 2) {
                        handleMouseDown(e);
                    }
                }

                public void mouseDoubleClick(MouseEvent e) {
                    handleMouseDown(e);
                }
            });
        }
    }

    /**
     * Creates the viewer editor used for editing cell contents. To be
     * implemented by subclasses.
     *
     * @return the editor, or <code>null</code> if this viewer does not support
     *  editing cell contents.
     */
    protected abstract ColumnViewerEditor createViewerEditor();

    /**
     * Returns the viewer cell at the given widget-relative coordinates, or
     * <code>null</code> if there is no cell at that location
     *
     * @param point
     *      the widget-relative coordinates
     * @return the cell or <code>null</code> if no cell is found at the given
     *  point
     *
     * @since 3.4
     */
    public ViewerCell getCell(Point point) {
        ViewerRow row = getViewerRow(point);
        if (row !is null) {
            return row.getCell(point);
        }

        return null;
    }

    /**
     * Returns the viewer row at the given widget-relative coordinates.
     *
     * @param point
     *      the widget-relative coordinates of the viewer row
     * @return ViewerRow the row or <code>null</code> if no row is found at the
     *  given coordinates
     */
    protected ViewerRow getViewerRow(Point point) {
        Item item = getItemAt(point);

        if (item !is null) {
            return getViewerRowFromItem(item);
        }

        return null;
    }
    package ViewerRow getViewerRow_package(Point point) {
        return getViewerRow(point);
    }

    /**
     * Returns a {@link ViewerRow} associated with the given row widget.
     * Implementations may re-use the same instance for different row widgets;
     * callers can only use the viewer row locally and until the next call to
     * this method.
     *
     * @param item
     *      the row widget
     * @return ViewerRow a viewer row object
     */
    protected abstract ViewerRow getViewerRowFromItem(Widget item);
    package ViewerRow getViewerRowFromItem_package(Widget item){
        return getViewerRowFromItem(item);
    }

    /**
     * Returns the column widget at the given column index.
     *
     * @param columnIndex
     *      the column index
     * @return Widget the column widget
     */
    protected abstract Widget getColumnViewerOwner(int columnIndex);

    /**
     * Returns the viewer column for the given column index.
     *
     * @param columnIndex
     *      the column index
     * @return the viewer column at the given index, or <code>null</code> if
     *  there is none for the given index
     */
    /* package */ViewerColumn getViewerColumn(int columnIndex) {

        ViewerColumn viewer;
        Widget columnOwner = getColumnViewerOwner(columnIndex);

        if (columnOwner is null || columnOwner.isDisposed()) {
            return null;
        }

        viewer = cast(ViewerColumn) columnOwner.getData(ViewerColumn.COLUMN_VIEWER_KEY);

        if (viewer is null) {
            viewer = createViewerColumn(columnOwner, CellLabelProvider
                    .createViewerLabelProvider(this, getLabelProvider()));
            setupEditingSupport(columnIndex, viewer);
        }

        if (viewer.getEditingSupport() is null && getCellModifier() !is null) {
            setupEditingSupport(columnIndex, viewer);
        }

        return viewer;
    }

    /**
     * Sets up editing support for the given column based on the "old" cell
     * editor API.
     *
     * @param columnIndex
     * @param viewer
     */
    private void setupEditingSupport(int columnIndex, ViewerColumn viewer) {
        if (getCellModifier() !is null) {
            viewer.setEditingSupport(new class(this,columnIndex) EditingSupport {
                int columnIndex_;
                this(ColumnViewer cv, int ci){
                    super(cv);
                    columnIndex_=ci;
                }
                /*
                 * (non-Javadoc)
                 *
                 * @see
                 * dwtx.jface.viewers.EditingSupport#canEdit(java.lang
                 * .Object)
                 */
                public bool canEdit(Object element) {
                    Object[] properties = getColumnProperties();

                    if (columnIndex_ < properties.length ) {
                        return getCellModifier().canModify(element,
                                (cast(ArrayWrapperString) getColumnProperties()[columnIndex_]).array);
                    }

                    return false;
                }

                /*
                 * (non-Javadoc)
                 *
                 * @see
                 * dwtx.jface.viewers.EditingSupport#getCellEditor(java
                 * .lang.Object)
                 */
                public CellEditor getCellEditor(Object element) {
                    CellEditor[] editors = getCellEditors();
                    if (columnIndex_ < editors.length ) {
                        return getCellEditors()[columnIndex_];
                    }
                    return null;
                }

                /*
                 * (non-Javadoc)
                 *
                 * @see
                 * dwtx.jface.viewers.EditingSupport#getValue(java.lang
                 * .Object)
                 */
                public Object getValue(Object element) {
                    Object[] properties = getColumnProperties();

                    if (columnIndex_ < properties.length) {
                        return getCellModifier().getValue(element,
                                (cast(ArrayWrapperString) getColumnProperties()[columnIndex_]).array);
                    }

                    return null;
                }

                /*
                 * (non-Javadoc)
                 *
                 * @see
                 * dwtx.jface.viewers.EditingSupport#setValue(java.lang
                 * .Object, java.lang.Object)
                 */
                public void setValue(Object element, Object value) {
                    Object[] properties = getColumnProperties();

                    if (columnIndex_ < properties.length) {
                        getCellModifier().modify(findItem(element),
                                (cast(ArrayWrapperString) getColumnProperties()[columnIndex_]).array,
                                value);
                    }
                }

                bool isLegacySupport() {
                    return true;
                }
            });
        }
    }

    /**
     * Creates a generic viewer column for the given column widget, based on the
     * given label provider.
     *
     * @param columnOwner
     *      the column widget
     * @param labelProvider
     *      the label provider to use for the column
     * @return ViewerColumn the viewer column
     */
    private ViewerColumn createViewerColumn(Widget columnOwner,
            CellLabelProvider labelProvider) {
        ViewerColumn column = new class(this, columnOwner) ViewerColumn {
            this( ColumnViewer cv, Widget co ){
                super(cv,co);
            }
        };
        column.setLabelProvider(labelProvider, false);
        return column;
    }

    /**
     * Update the cached cell object with the given row and column.
     *
     * @param rowItem
     * @param column
     * @return ViewerCell
     */
    /* package */ViewerCell updateCell(ViewerRow rowItem, int column,
            Object element) {
        cell.update(rowItem, column, element);
        return cell;
    }

    /**
     * Returns the {@link Item} at the given widget-relative coordinates, or
     * <code>null</code> if there is no item at the given coordinates.
     *
     * @param point
     *      the widget-relative coordinates
     * @return the {@link Item} at the coordinates or <code>null</code> if there
     *  is no item at the given coordinates
     */
    protected abstract Item getItemAt(Point point);

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.StructuredViewer#getItem(int, int)
     */
    protected override Item getItem(int x, int y) {
        return getItemAt(getControl().toControl(x, y));
    }

    /**
     * The column viewer implementation of this <code>Viewer</code> framework
     * method ensures that the given label provider is an instance of
     * <code>ITableLabelProvider</code>, <code>ILabelProvider</code>, or
     * <code>CellLabelProvider</code>.
     * <p>
     * If the label provider is an {@link ITableLabelProvider} , then it
     * provides a separate label text and image for each column. Implementers of
     * <code>ITableLabelProvider</code> may also implement {@link
     * ITableColorProvider} and/or {@link ITableFontProvider} to provide colors
     * and/or fonts.
     * </p>
     * <p>
     * If the label provider is an <code>ILabelProvider</code> , then it
     * provides only the label text and image for the first column, and any
     * remaining columns are blank. Implementers of <code>ILabelProvider</code>
     * may also implement {@link IColorProvider} and/or {@link IFontProvider} to
     * provide colors and/or fonts.
     * </p>
     *
     */
    public override void setLabelProvider(IBaseLabelProvider labelProvider) {
        Assert.isTrue( null !is cast(ITableLabelProvider)labelProvider
                || null !is cast(ILabelProvider)labelProvider
                || null !is cast(CellLabelProvider)labelProvider );
        updateColumnParts(labelProvider);// Reset the label providers in the
        // columns
        super.setLabelProvider(labelProvider);
        if ( null !is cast(CellLabelProvider)labelProvider ) {
            (cast(CellLabelProvider) labelProvider).initialize_package(this, null);
        }
    }

    void internalDisposeLabelProvider(IBaseLabelProvider oldProvider) {
        if (null !is cast(CellLabelProvider)oldProvider ) {
            (cast(CellLabelProvider) oldProvider).dispose(this, null);
        } else {
            super.internalDisposeLabelProvider(oldProvider);
        }
    }

    /**
     * Clear the viewer parts for the columns
     */
    private void updateColumnParts(IBaseLabelProvider labelProvider) {
        ViewerColumn column;
        int i = 0;

        while ((column = getViewerColumn(i++)) !is null) {
            column.setLabelProvider(CellLabelProvider
                    .createViewerLabelProvider(this, labelProvider), false);
        }
    }

    /**
     * Cancels a currently active cell editor if one is active. All changes
     * already done in the cell editor are lost.
     *
     * @since 3.1 (in subclasses, added in 3.3 to abstract class)
     */
    public void cancelEditing() {
        if (viewerEditor !is null) {
            viewerEditor.cancelEditing();
        }
    }

    /**
     * Apply the value of the active cell editor if one is active.
     *
     * @since 3.3
     */
    protected void applyEditorValue() {
        if (viewerEditor !is null) {
            viewerEditor.applyEditorValue();
        }
    }

    /**
     * Starts editing the given element at the given column index.
     *
     * @param element
     *      the model element
     * @param column
     *      the column index
     * @since 3.1 (in subclasses, added in 3.3 to abstract class)
     */
    public void editElement(Object element, int column) {
        if (viewerEditor !is null) {
            try {
                getControl().setRedraw(false);
                // Set the selection at first because in Tree's
                // the element might not be materialized
                setSelection(new StructuredSelection(element), true);

                Widget item = findItem(element);
                if (item !is null) {
                    ViewerRow row = getViewerRowFromItem(item);
                    if (row !is null) {
                        ViewerCell cell = row.getCell(column);
                        if (cell !is null) {
                            triggerEditorActivationEvent(new ColumnViewerEditorActivationEvent(
                                    cell));
                        }
                    }
                }
            } finally {
                getControl().setRedraw(true);
            }
        }
    }

    /**
     * Return the CellEditors for the receiver, or <code>null</code> if no cell
     * editors are set.
     * <p>
     * Since 3.3, an alternative API is available, see {@link
     * ViewerColumn#setEditingSupport(EditingSupport)} for a more flexible way
     * of editing values in a column viewer.
     * </p>
     *
     *
     * @return CellEditor[]
     * @since 3.1 (in subclasses, added in 3.3 to abstract class)
     * @see ViewerColumn#setEditingSupport(EditingSupport)
     * @see EditingSupport
     */
    public CellEditor[] getCellEditors() {
        return cellEditors;
    }

    /**
     * Returns the cell modifier of this viewer, or <code>null</code> if none
     * has been set.
     *
     * <p>
     * Since 3.3, an alternative API is available, see {@link
     * ViewerColumn#setEditingSupport(EditingSupport)} for a more flexible way
     * of editing values in a column viewer.
     * </p>
     *
     * @return the cell modifier, or <code>null</code>
     * @since 3.1 (in subclasses, added in 3.3 to abstract class)
     * @see ViewerColumn#setEditingSupport(EditingSupport)
     * @see EditingSupport
     */
    public ICellModifier getCellModifier() {
        return cellModifier;
    }

    /**
     * Returns the column properties of this table viewer. The properties must
     * correspond with the columns of the table control. They are used to
     * identify the column in a cell modifier.
     *
     * <p>
     * Since 3.3, an alternative API is available, see {@link
     * ViewerColumn#setEditingSupport(EditingSupport)} for a more flexible way
     * of editing values in a column viewer.
     * </p>
     *
     * @return the list of column properties
     * @since 3.1 (in subclasses, added in 3.3 to abstract class)
     * @see ViewerColumn#setEditingSupport(EditingSupport)
     * @see EditingSupport
     */
    public Object[] getColumnProperties() {
        Object[] res;
        foreach( prop; columnProperties ){
            res ~= new ArrayWrapperString( prop );
        }
        return res;
    }

    /**
     * Returns whether there is an active cell editor.
     *
     * <p>
     * Since 3.3, an alternative API is available, see {@link
     * ViewerColumn#setEditingSupport(EditingSupport)} for a more flexible way
     * of editing values in a column viewer.
     * </p>
     *
     * @return <code>true</code> if there is an active cell editor, and
     *  <code>false</code> otherwise
     * @since 3.1 (in subclasses, added in 3.3 to abstract class)
     * @see ViewerColumn#setEditingSupport(EditingSupport)
     * @see EditingSupport
     */
    public bool isCellEditorActive() {
        if (viewerEditor !is null) {
            return viewerEditor.isCellEditorActive();
        }
        return false;
    }

    public override void refresh(Object element) {
        if (checkBusy())
            return;

        if (isCellEditorActive()) {
            cancelEditing();
        }

        super.refresh(element);
    }

    public override void refresh(Object element, bool updateLabels) {
        if (checkBusy())
            return;

        if (isCellEditorActive()) {
            cancelEditing();
        }

        super.refresh(element, updateLabels);
    }

    public override void update(Object element, String[] properties) {
        if (checkBusy())
            return;
        super.update(element, properties);
    }

    /**
     * Sets the cell editors of this column viewer. If editing is not supported
     * by this viewer the call simply has no effect.
     *
     * <p>
     * Since 3.3, an alternative API is available, see {@link
     * ViewerColumn#setEditingSupport(EditingSupport)} for a more flexible way
     * of editing values in a column viewer.
     * </p>
     * <p>
     * Users setting up an editable {@link TreeViewer} or {@link TableViewer} with more than 1 column <b>have</b>
     * to pass the DWT.FULL_SELECTION style bit
     * </p>
     * @param editors
     *      the list of cell editors
     * @since 3.1 (in subclasses, added in 3.3 to abstract class)
     * @see ViewerColumn#setEditingSupport(EditingSupport)
     * @see EditingSupport
     */
    public void setCellEditors(CellEditor[] editors) {
        this.cellEditors = editors;
    }

    /**
     * Sets the cell modifier for this column viewer. This method does nothing
     * if editing is not supported by this viewer.
     *
     * <p>
     * Since 3.3, an alternative API is available, see {@link
     * ViewerColumn#setEditingSupport(EditingSupport)} for a more flexible way
     * of editing values in a column viewer.
     * </p>
     * <p>
     * Users setting up an editable {@link TreeViewer} or {@link TableViewer} with more than 1 column <b>have</b>
     * to pass the DWT.FULL_SELECTION style bit
     * </p>
     * @param modifier
     *      the cell modifier
     * @since 3.1 (in subclasses, added in 3.3 to abstract class)
     * @see ViewerColumn#setEditingSupport(EditingSupport)
     * @see EditingSupport
     */
    public void setCellModifier(ICellModifier modifier) {
        this.cellModifier = modifier;
    }

    /**
     * Sets the column properties of this column viewer. The properties must
     * correspond with the columns of the control. They are used to identify the
     * column in a cell modifier. If editing is not supported by this viewer the
     * call simply has no effect.
     *
     * <p>
     * Since 3.3, an alternative API is available, see {@link
     * ViewerColumn#setEditingSupport(EditingSupport)} for a more flexible way
     * of editing values in a column viewer.
     * </p>
     * <p>
     * Users setting up an editable {@link TreeViewer} or {@link TableViewer} with more than 1 column <b>have</b>
     * to pass the DWT.FULL_SELECTION style bit
     * </p>
     * @param columnProperties
     *      the list of column properties
     * @since 3.1 (in subclasses, added in 3.3 to abstract class)
     * @see ViewerColumn#setEditingSupport(EditingSupport)
     * @see EditingSupport
     */
    public void setColumnProperties(String[] columnProperties) {
        this.columnProperties = columnProperties;
    }

    /**
     * Returns the number of columns contained in the receiver. If no columns
     * were created by the programmer, this value is zero, despite the fact that
     * visually, one column of items may be visible. This occurs when the
     * programmer uses the column viewer like a list, adding elements but never
     * creating a column.
     *
     * @return the number of columns
     *
     * @since 3.3
     */
    protected abstract int doGetColumnCount();
    package int doGetColumnCount_package(){
        return doGetColumnCount();
    }

    /**
     * Returns the label provider associated with the column at the given index
     * or <code>null</code> if no column with this index is known.
     *
     * @param columnIndex
     *      the column index
     * @return the label provider associated with the column or
     *  <code>null</code> if no column with this index is known
     *
     * @since 3.3
     */
    public CellLabelProvider getLabelProvider(int columnIndex) {
        ViewerColumn column = getViewerColumn(columnIndex);
        if (column !is null) {
            auto res = column.getLabelProvider();
            return res;
        }
        return null;
    }

    private void handleMouseDown(MouseEvent e) {
        ViewerCell cell = getCell(new Point(e.x, e.y));

        if (cell !is null) {
            triggerEditorActivationEvent(new ColumnViewerEditorActivationEvent(
                    cell, e));
        }
    }

    /**
     * Invoking this method fires an editor activation event which tries to
     * enable the editor but before this event is passed to {@link
     * ColumnViewerEditorActivationStrategy} to see if this event should really
     * trigger editor activation
     *
     * @param event
     *      the activation event
     */
    protected void triggerEditorActivationEvent(
            ColumnViewerEditorActivationEvent event) {
        viewerEditor.handleEditorActivationEvent(event);
    }
    package void triggerEditorActivationEvent_package(
            ColumnViewerEditorActivationEvent event) {
        triggerEditorActivationEvent(event);
    }

    /**
     * @param columnViewerEditor
     *      the new column viewer editor
     */
    public void setColumnViewerEditor(ColumnViewerEditor columnViewerEditor) {
        Assert.isNotNull(columnViewerEditor);
        this.viewerEditor = columnViewerEditor;
    }

    /**
     * @return the currently attached viewer editor
     */
    public ColumnViewerEditor getColumnViewerEditor() {
        return viewerEditor;
    }

    protected override Object[] getRawChildren(Object parent) {
        bool oldBusy = isBusy();
        setBusy(true);
        try {
            return super.getRawChildren(parent);
        } finally {
            setBusy(oldBusy);
        }
    }

    void clearLegacyEditingSetup() {
        if (!getControl().isDisposed() && getCellEditors() !is null) {
            int count = doGetColumnCount();

            for (int i = 0; i < count || i is 0; i++) {
                Widget owner = getColumnViewerOwner(i);
                if (owner !is null && !owner.isDisposed()) {
                ViewerColumn column = cast(ViewerColumn) owner
                            .getData(ViewerColumn.COLUMN_VIEWER_KEY);
                    if (column !is null) {
                        EditingSupport e = column.getEditingSupport();
                        // Ensure that only EditingSupports are wiped that are
                        // setup
                        // for Legacy reasons
                        if (e !is null && e.isLegacySupport()) {
                            column.setEditingSupport(null);
                        }
                    }
                }
            }
        }
    }

    /**
     * Checks if this viewer is currently busy, logging a warning and returning
     * <code>true</code> if it is busy. A column viewer is busy when it is
     * processing a refresh, add, remove, insert, replace, setItemCount,
     * expandToLevel, update, setExpandedElements, or similar method that may
     * make calls to client code. Column viewers are not designed to handle
     * reentrant calls while they are busy. The method returns <code>true</code>
     * if the viewer is busy. It is recommended that this method be used by
     * subclasses to determine whether the viewer is busy to return early from
     * state-changing methods.
     *
     * <p>
     * This method is not intended to be overridden by subclasses.
     * </p>
     *
     * @return <code>true</code> if the viewer is busy.
     *
     * @since 3.4
     */
    protected bool checkBusy() {
        if (isBusy()) {
            if (logWhenBusy) {
                String message = "Ignored reentrant call while viewer is busy."; //$NON-NLS-1$
                if (!InternalPolicy.DEBUG_LOG_REENTRANT_VIEWER_CALLS) {
                    // stop logging after the first
                    logWhenBusy = false;
                    message ~= " This is only logged once per viewer instance," ~ //$NON-NLS-1$
                            " but similar calls will still be ignored."; //$NON-NLS-1$
                }
                Policy.getLog().log(
                        new Status(IStatus.WARNING, Policy.JFACE, message,
                                new RuntimeException()));
            }
            return true;
        }
        return false;
    }

    /**
     * Sets the busy state of this viewer. Subclasses MUST use <code>try</code>
     * ...<code>finally</code> as follows to ensure that the busy flag is reset
     * to its original value:
     *
     * <pre>
     * bool oldBusy = isBusy();
     * setBusy(true);
     * try {
     *  // do work
     * } finally {
     *  setBusy(oldBusy);
     * }
     * </pre>
     *
     * <p>
     * This method is not intended to be overridden by subclasses.
     * </p>
     *
     * @param busy
     *      the new value of the busy flag
     *
     * @since 3.4
     */
    protected void setBusy(bool busy) {
        this.busy = busy;
    }

    /**
     * Returns <code>true</code> if this viewer is currently busy processing a
     * refresh, add, remove, insert, replace, setItemCount, expandToLevel,
     * update, setExpandedElements, or similar method that may make calls to
     * client code. Column viewers are not designed to handle reentrant calls
     * while they are busy. It is recommended that clients avoid using this
     * method if they can ensure by other means that they will not make
     * reentrant calls to methods like the ones listed above. See bug 184991 for
     * background discussion.
     *
     * <p>
     * This method is not intended to be overridden by subclasses.
     * </p>
     *
     * @return Returns whether this viewer is busy.
     *
     * @since 3.4
     */
    public bool isBusy() {
        return busy;
    }
}
