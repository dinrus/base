/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation bug 154329
 *                                               - fixes in bug 170381, 198665, 200731
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/

module dwtx.jface.viewers.AbstractTableViewer;

import dwtx.jface.viewers.ColumnViewer;
import dwtx.jface.viewers.ViewerRow;
import dwtx.jface.viewers.IBaseLabelProvider;
import dwtx.jface.viewers.IContentProvider;
import dwtx.jface.viewers.ILazyContentProvider;
import dwtx.jface.viewers.ViewerColumn;
import dwtx.jface.viewers.ViewerCell;
import dwtx.jface.viewers.ViewerComparator;
import dwtx.jface.viewers.IStructuredContentProvider;


import dwt.DWT;
import dwt.widgets.Control;
import dwt.widgets.Event;
import dwt.widgets.Item;
import dwt.widgets.Listener;
import dwt.widgets.Widget;
import dwtx.core.runtime.Assert;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwt.dwthelper.Runnable;
import tango.core.Array;

/**
 * This is a widget independent class implementors of
 * {@link dwt.widgets.Table} like widgets can use to provide a
 * viewer on top of their widget implementations.
 *
 * @since 3.3
 */
public abstract class AbstractTableViewer : ColumnViewer {
    alias ColumnViewer.getLabelProvider getLabelProvider;
    alias ColumnViewer.setSelectionToWidget setSelectionToWidget;

    private class VirtualManager {

        /**
         * The currently invisible elements as provided by the content provider
         * or by addition. This will not be populated by an
         * ILazyStructuredContentProvider as an ILazyStructuredContentProvider
         * is only queried on the virtual callback.
         */
        private Object[] cachedElements = null;

        /**
         * Create a new instance of the receiver.
         *
         */
        public this() {
            addTableListener();
        }

        /**
         * Add the listener for SetData on the table
         */
        private void addTableListener() {
            getControl().addListener(DWT.SetData, dgListener( (Event event){
                /*
                 * (non-Javadoc)
                 *
                 * @see dwt.widgets.Listener#handleEvent(dwt.widgets.Event)
                 */
                Item item = cast(Item) event.item;
                final int index = doIndexOf(item);
                Object element = resolveElement(index);
                if (element is null) {
                    // Didn't find it so make a request
                    // Keep looking if it is not in the cache.
                    IContentProvider contentProvider = getContentProvider();
                    // If we are building lazily then request lookup now
                    if (auto lcp = cast(ILazyContentProvider)contentProvider ) {
                        lcp.updateElement(index);
                        return;
                    }
                }

                associate(element, item);
                updateItem(item, element);
            }));
        }

        /**
         * Get the element at index.Resolve it lazily if this is available.
         *
         * @param index
         * @return Object or <code>null</code> if it could not be found
         */
        protected Object resolveElement(int index) {

            Object element = null;
            if (index < cachedElements.length) {
                element = cachedElements[index];
            }

            return element;
        }

        /**
         * A non visible item has been added.
         *
         * @param element
         * @param index
         */
        public void notVisibleAdded(Object element, int index) {

            int requiredCount = doGetItemCount() + 1;

            Object[] newCache = new Object[requiredCount];
            System.arraycopy(cachedElements, 0, newCache, 0, index);
            if (index < cachedElements.length) {
                System.arraycopy(cachedElements, index, newCache, index + 1,
                        cachedElements.length - index);
            }
            newCache[index] = element;
            cachedElements = newCache;

            doSetItemCount(requiredCount);
        }

        /**
         * The elements with the given indices need to be removed from the
         * cache.
         *
         * @param indices
         */
        public void removeIndices(int[] indices) {
            if (indices.length is 1) {
                removeIndicesFromTo(indices[0], indices[0]);
            }
            int requiredCount = doGetItemCount() - indices.length;

            tango.core.Array.sort( indices );
            Object[] newCache = new Object[requiredCount];
            int indexInNewCache = 0;
            int nextToSkip = 0;
            for (int i = 0; i < cachedElements.length; i++) {
                if (nextToSkip < indices.length && i is indices[nextToSkip]) {
                    nextToSkip++;
                } else {
                    newCache[indexInNewCache++] = cachedElements[i];
                }
            }
            cachedElements = newCache;
        }

        /**
         * The elements between the given indices (inclusive) need to be removed
         * from the cache.
         *
         * @param from
         * @param to
         */
        public void removeIndicesFromTo(int from, int to) {
            int indexAfterTo = to + 1;
            Object[] newCache = new Object[cachedElements.length
                    - (indexAfterTo - from)];
            System.arraycopy(cachedElements, 0, newCache, 0, from);
            if (indexAfterTo < cachedElements.length) {
                System.arraycopy(cachedElements, indexAfterTo, newCache, from,
                        cachedElements.length - indexAfterTo);
            }
        }

        /**
         * @param element
         * @return the index of the element in the cache, or null
         */
        public int find(Object element) {
            int res = tango.core.Array.find( cachedElements, element );
            if( res is cachedElements.length ) res = -1;
            return res;
        }

        /**
         * @param count
         */
        public void adjustCacheSize(int count) {
            if (count is cachedElements.length) {
                return;
            } else if (count < cachedElements.length) {
                Object[] newCache = new Object[count];
                System.arraycopy(cachedElements, 0, newCache, 0, count);
                cachedElements = newCache;
            } else {
                Object[] newCache = new Object[count];
                System.arraycopy(cachedElements, 0, newCache, 0,
                        cachedElements.length);
                cachedElements = newCache;
            }
        }

    }

    private VirtualManager virtualManager;

    /**
     * Create the new viewer for table like widgets
     */
    public this() {
        super();
    }

    protected override void hookControl(Control control) {
        super.hookControl(control);
        initializeVirtualManager(getControl().getStyle());
    }

    /**
     * Initialize the virtual manager to manage the virtual state if the table
     * is VIRTUAL. If not use the default no-op version.
     *
     * @param style
     */
    private void initializeVirtualManager(int style) {
        if ((style & DWT.VIRTUAL) is 0) {
            return;
        }

        virtualManager = new VirtualManager();
    }

    /**
     * Adds the given elements to this table viewer. If this viewer does not
     * have a sorter, the elements are added at the end in the order given;
     * otherwise the elements are inserted at appropriate positions.
     * <p>
     * This method should be called (by the content provider) when elements have
     * been added to the model, in order to cause the viewer to accurately
     * reflect the model. This method only affects the viewer, not the model.
     * </p>
     *
     * @param elements
     *            the elements to add
     */
    public void add(Object[] elements) {
        assertElementsNotNull(elements);
        if (checkBusy())
            return;
        Object[] filtered = filter(elements);

        for (int i = 0; i < filtered.length; i++) {
            Object element = filtered[i];
            int index = indexForElement(element);
            createItem(element, index);
        }
    }

    /**
     * Create a new TableItem at index if required.
     *
     * @param element
     * @param index
     *
     * @since 3.1
     */
    private void createItem(Object element, int index) {
        if (virtualManager is null) {
            updateItem(internalCreateNewRowPart(DWT.NONE, index).getItem(),
                    element);
        } else {
            virtualManager.notVisibleAdded(element, index);

        }
    }

    /**
     * Create a new row.  Callers can only use the returned object locally and before
     * making the next call on the viewer since it may be re-used for subsequent method
     * calls.
     *
     * @param style
     *            the style for the new row
     * @param rowIndex
     *            the index of the row or -1 if the row is appended at the end
     * @return the newly created row
     */
    protected abstract ViewerRow internalCreateNewRowPart(int style,
            int rowIndex);

    /**
     * Adds the given element to this table viewer. If this viewer does not have
     * a sorter, the element is added at the end; otherwise the element is
     * inserted at the appropriate position.
     * <p>
     * This method should be called (by the content provider) when a single
     * element has been added to the model, in order to cause the viewer to
     * accurately reflect the model. This method only affects the viewer, not
     * the model. Note that there is another method for efficiently processing
     * the simultaneous addition of multiple elements.
     * </p>
     *
     * @param element
     *            the element to add
     */
    public void add(Object element) {
        add([ element ]);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.StructuredViewer#doFindInputItem(java.lang.Object)
     */
    protected override Widget doFindInputItem(Object element) {
        if (opEquals(element, getRoot())) {
            return getControl();
        }
        return null;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.StructuredViewer#doFindItem(java.lang.Object)
     */
    protected override Widget doFindItem(Object element) {

        Item[] children = doGetItems();
        for (int i = 0; i < children.length; i++) {
            Item item = children[i];
            Object data = item.getData();
            if (data !is null && opEquals(data, element)) {
                return item;
            }
        }

        return null;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.StructuredViewer#doUpdateItem(dwt.widgets.Widget,
     *      java.lang.Object, bool)
     */
    protected override void doUpdateItem(Widget widget, Object element, bool fullMap) {
        bool oldBusy = isBusy();
        setBusy(true);
        try {
            if ( auto item = cast(Item)widget ) {

                // remember element we are showing
                if (fullMap) {
                    associate(element, item);
                } else {
                    Object data = item.getData();
                    if (data !is null) {
                        unmapElement(data, item);
                    }
                    item.setData(element);
                    mapElement(element, item);
                }

                int columnCount = doGetColumnCount();
                if (columnCount is 0)
                    columnCount = 1;// If there are no columns do the first one

                ViewerRow viewerRowFromItem = getViewerRowFromItem(item);

                bool isVirtual = (getControl().getStyle() & DWT.VIRTUAL) !is 0;

                // If the control is virtual, we cannot use the cached viewer row object. See bug 188663.
                if (isVirtual) {
                    viewerRowFromItem = cast(ViewerRow) viewerRowFromItem.clone();
                }

                // Also enter loop if no columns added. See 1G9WWGZ: JFUIF:WINNT -
                // TableViewer with 0 columns does not work
                for (int column = 0; column < columnCount || column is 0; column++) {
                    ViewerColumn columnViewer = getViewerColumn(column);
                    ViewerCell cellToUpdate = updateCell(viewerRowFromItem,
                            column, element);

                    // If the control is virtual, we cannot use the cached cell object. See bug 188663.
                    if (isVirtual) {
                        cellToUpdate = new ViewerCell(cellToUpdate.getViewerRow(), cellToUpdate.getColumnIndex(), element);
                    }

                    columnViewer.refresh(cellToUpdate);

                    // clear cell (see bug 201280)
                    updateCell(null, 0, null);

                    // As it is possible for user code to run the event
                    // loop check here.
                    if (item.isDisposed()) {
                        unmapElement(element, item);
                        return;
                    }

                }

            }
        } finally {
            setBusy(oldBusy);
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.ColumnViewer#getColumnViewerOwner(int)
     */
    protected override Widget getColumnViewerOwner(int columnIndex) {
        int columnCount = doGetColumnCount();

        if (columnIndex < 0
                || (columnIndex > 0 && columnIndex >= columnCount)) {
            return null;
        }

        if (columnCount is 0)// Hang it off the table if it
            return getControl();

        return doGetColumn(columnIndex);
    }

    /**
     * Returns the element with the given index from this table viewer. Returns
     * <code>null</code> if the index is out of range.
     * <p>
     * This method is internal to the framework.
     * </p>
     *
     * @param index
     *            the zero-based index
     * @return the element at the given index, or <code>null</code> if the
     *         index is out of range
     */
    public Object getElementAt(int index) {
        if (index >= 0 && index < doGetItemCount()) {
            Item i = doGetItem(index);
            if (i !is null) {
                return i.getData();
            }
        }
        return null;
    }

    /**
     * The table viewer implementation of this <code>Viewer</code> framework
     * method returns the label provider, which in the case of table viewers
     * will be an instance of either <code>ITableLabelProvider</code> or
     * <code>ILabelProvider</code>. If it is an
     * <code>ITableLabelProvider</code>, then it provides a separate label
     * text and image for each column. If it is an <code>ILabelProvider</code>,
     * then it provides only the label text and image for the first column, and
     * any remaining columns are blank.
     */
    public override IBaseLabelProvider getLabelProvider() {
        return super.getLabelProvider();
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.StructuredViewer#getSelectionFromWidget()
     */
    protected override List getSelectionFromWidget() {
        if (virtualManager !is null) {
            return getVirtualSelection();
        }
        Widget[] items = doGetSelection();
        ArrayList list = new ArrayList(items.length);
        for (int i = 0; i < items.length; i++) {
            Widget item = items[i];
            Object e = item.getData();
            if (e !is null) {
                list.add(e);
            }
        }
        return list;
    }

    /**
     * Get the virtual selection. Avoid calling DWT whenever possible to prevent
     * extra widget creation.
     *
     * @return List of Object
     */

    private List getVirtualSelection() {

        List result = new ArrayList();
        int[] selectionIndices = doGetSelectionIndices();
        if (auto lazy_ = cast(ILazyContentProvider) getContentProvider() ) {
            for (int i = 0; i < selectionIndices.length; i++) {
                int selectionIndex = selectionIndices[i];
                lazy_.updateElement(selectionIndex);// Start the update
                Object element = doGetItem(selectionIndex).getData();
                // Only add the element if it got updated.
                // If this is done deferred the selection will
                // be incomplete until selection is finished.
                if (element !is null) {
                    result.add(element);
                }
            }
        } else {
            for (int i = 0; i < selectionIndices.length; i++) {
                Object element = null;
                // See if it is cached
                int selectionIndex = selectionIndices[i];
                if (selectionIndex < virtualManager.cachedElements.length) {
                    element = virtualManager.cachedElements[selectionIndex];
                }
                if (element is null) {
                    // Not cached so try the item's data
                    Item item = doGetItem(selectionIndex);
                    element = item.getData();
                }
                if (element !is null) {
                    result.add(element);
                }
            }

        }
        return result;
    }

    /**
     * @param element
     *            the element to insert
     * @return the index where the item should be inserted.
     */
    protected int indexForElement(Object element) {
        ViewerComparator comparator = getComparator();
        if (comparator is null) {
            return doGetItemCount();
        }
        int count = doGetItemCount();
        int min = 0, max = count - 1;
        while (min <= max) {
            int mid = (min + max) / 2;
            Object data = doGetItem(mid).getData();
            int compare = comparator.compare(this, data, element);
            if (compare is 0) {
                // find first item > element
                while (compare is 0) {
                    ++mid;
                    if (mid >= count) {
                        break;
                    }
                    data = doGetItem(mid).getData();
                    compare = comparator.compare(this, data, element);
                }
                return mid;
            }
            if (compare < 0) {
                min = mid + 1;
            } else {
                max = mid - 1;
            }
        }
        return min;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.Viewer#inputChanged(java.lang.Object,
     *      java.lang.Object)
     */
    protected override void inputChanged(Object input, Object oldInput) {
        getControl().setRedraw(false);
        try {
            preservingSelection(dgRunnable( {
                internalRefresh(getRoot());
            }));
        } finally {
            getControl().setRedraw(true);
        }
    }

    /**
     * Inserts the given element into this table viewer at the given position.
     * If this viewer has a sorter, the position is ignored and the element is
     * inserted at the correct position in the sort order.
     * <p>
     * This method should be called (by the content provider) when elements have
     * been added to the model, in order to cause the viewer to accurately
     * reflect the model. This method only affects the viewer, not the model.
     * </p>
     *
     * @param element
     *            the element
     * @param position
     *            a 0-based position relative to the model, or -1 to indicate
     *            the last position
     */
    public void insert(Object element, int position) {
        applyEditorValue();
        if (getComparator() !is null || hasFilters()) {
            add(element);
            return;
        }
        if (position is -1) {
            position = doGetItemCount();
        }
        if (checkBusy())
            return;
        createItem(element, position);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.StructuredViewer#internalRefresh(java.lang.Object)
     */
    protected override void internalRefresh(Object element) {
        internalRefresh(element, true);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.StructuredViewer#internalRefresh(java.lang.Object,
     *      bool)
     */
    protected override void internalRefresh(Object element, bool updateLabels) {
        applyEditorValue();
        if (element is null || opEquals(element, getRoot())) {
            if (virtualManager is null) {
                internalRefreshAll(updateLabels);
            } else {
                internalVirtualRefreshAll();
            }
        } else {
            Widget w = findItem(element);
            if (w !is null) {
                updateItem(w, element);
            }
        }
    }

    /**
     * Refresh all with virtual elements.
     *
     * @since 3.1
     */
    private void internalVirtualRefreshAll() {

        Object root = getRoot();
        IContentProvider contentProvider = getContentProvider();

        // Invalidate for lazy
        if (!(cast(ILazyContentProvider)contentProvider )
                && cast(IStructuredContentProvider)contentProvider ) {
            // Don't cache if the root is null but cache if it is not lazy.
            if (root !is null) {
                virtualManager.cachedElements = getSortedChildren(root);
                doSetItemCount(virtualManager.cachedElements.length);
            }
        }
        doClearAll();
    }

    /**
     * Refresh all of the elements of the table. update the labels if
     * updatLabels is true;
     *
     * @param updateLabels
     *
     * @since 3.1
     */
    private void internalRefreshAll(bool updateLabels) {
        // the parent

        // in the code below, it is important to do all disassociates
        // before any associates, since a later disassociate can undo an
        // earlier associate
        // e.g. if (a, b) is replaced by (b, a), the disassociate of b to
        // item 1 could undo
        // the associate of b to item 0.

        Object[] children = getSortedChildren(getRoot());
        Item[] items = doGetItems();
        int min = Math.min(children.length, items.length);
        for (int i = 0; i < min; ++i) {

            Item item = items[i];

            // if the element is unchanged, update its label if appropriate
            if (opEquals(children[i], item.getData())) {
                if (updateLabels) {
                    updateItem(item, children[i]);
                } else {
                    // associate the new element, even if equal to the old
                    // one,
                    // to remove stale references (see bug 31314)
                    associate(children[i], item);
                }
            } else {
                // updateItem does an associate(...), which can mess up
                // the associations if the order of elements has changed.
                // E.g. (a, b) -> (b, a) first replaces a->0 with b->0, then
                // replaces b->1 with a->1, but this actually removes b->0.
                // So, if the object associated with this item has changed,
                // just disassociate it for now, and update it below.
                // we also need to reset the item (set its text,images etc. to
                // default values) because the label decorators rely on this
                disassociate(item);
                doClear(i);
            }
        }
        // dispose of all items beyond the end of the current elements
        if (min < items.length) {
            for (int i = items.length; --i >= min;) {

                disassociate(items[i]);
            }
            if (virtualManager !is null) {
                virtualManager.removeIndicesFromTo(min, items.length - 1);
            }
            doRemove(min, items.length - 1);
        }
        // Workaround for 1GDGN4Q: ITPUI:WIN2000 - TableViewer icons get
        // scrunched
        if (doGetItemCount() is 0) {
            doRemoveAll();
        }
        // Update items which were disassociated above
        for (int i = 0; i < min; ++i) {

            Item item = items[i];
            if (item.getData() is null) {
                updateItem(item, children[i]);
            }
        }
        // add any remaining elements
        for (int i = min; i < children.length; ++i) {
            createItem(children[i], i);
        }
    }

    /**
     * Removes the given elements from this table viewer.
     *
     * @param elements
     *            the elements to remove
     */
    private void internalRemove(Object[] elements) {
        Object input = getInput();
        for (int i = 0; i < elements.length; ++i) {
            if (opEquals(elements[i], input)) {
                bool oldBusy = isBusy();
                setBusy(false);
                try {
                    setInput(null);
                } finally {
                    setBusy(oldBusy);
                }
                return;
            }
        }
        // use remove(int[]) rather than repeated TableItem.dispose() calls
        // to allow DWT to optimize multiple removals
        int[] indices = new int[elements.length];
        int count = 0;
        for (int i = 0; i < elements.length; ++i) {
            Widget w = findItem(elements[i]);
            if (w is null && virtualManager !is null) {
                int index = virtualManager.find(elements[i]);
                if (index !is -1) {
                    indices[count++] = index;
                }
            } else if (auto item = cast(Item) w ) {
                disassociate(item);
                indices[count++] = doIndexOf(item);
            }
        }
        if (count < indices.length) {
            System.arraycopy(indices, 0, indices = new int[count], 0, count);
        }
        if (virtualManager !is null) {
            virtualManager.removeIndices(indices);
        }
        doRemove(indices);

        // Workaround for 1GDGN4Q: ITPUI:WIN2000 - TableViewer icons get
        // scrunched
        if (doGetItemCount() is 0) {
            doRemoveAll();
        }
    }

    /**
     * Removes the given elements from this table viewer. The selection is
     * updated if required.
     * <p>
     * This method should be called (by the content provider) when elements have
     * been removed from the model, in order to cause the viewer to accurately
     * reflect the model. This method only affects the viewer, not the model.
     * </p>
     *
     * @param elements
     *            the elements to remove
     */
    public void remove( Object[] elements) {
        assertElementsNotNull(elements);
        if (checkBusy())
            return;
        if (elements.length is 0) {
            return;
        }
        preservingSelection(dgRunnable( (Object[] elements_){
            internalRemove(elements_);
        }, elements));
    }

    /**
     * Removes the given element from this table viewer. The selection is
     * updated if necessary.
     * <p>
     * This method should be called (by the content provider) when a single
     * element has been removed from the model, in order to cause the viewer to
     * accurately reflect the model. This method only affects the viewer, not
     * the model. Note that there is another method for efficiently processing
     * the simultaneous removal of multiple elements.
     * </p>
     * <strong>NOTE:</strong> removing an object from a virtual table will
     * decrement the itemCount.
     *
     * @param element
     *            the element
     */
    public void remove(Object element) {
        remove([ element ]);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.StructuredViewer#reveal(java.lang.Object)
     */
    public override void reveal(Object element) {
        Assert.isNotNull(element);
        Widget w = findItem(element);
        if (auto i = cast(Item)w ) {
            doShowItem(i);
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.StructuredViewer#setSelectionToWidget(java.util.List,
     *      bool)
     */
    protected override void setSelectionToWidget(List list, bool reveal) {
        if (list is null) {
            doDeselectAll();
            return;
        }

        if (virtualManager !is null) {
            virtualSetSelectionToWidget(list, reveal);
            return;
        }

        // This is vital to use doSetSelection because on DWT-Table on Win32 this will also
        // move the focus to this row (See bug https://bugs.eclipse.org/bugs/show_bug.cgi?id=198665)
        if (reveal) {
            int size = list.size();
            Item[] items = new Item[size];
            int count = 0;
            for (int i = 0; i < size; ++i) {
                Object o = list.get(i);
                Widget w = findItem(o);
                if (auto item = cast(Item)w ) {
                    items[count++] = item;
                }
            }
            if (count < size) {
                System.arraycopy(items, 0, items = new Item[count], 0, count);
            }
            doSetSelection(items);
        } else {
            doDeselectAll(); // Clear the selection
            if( ! list.isEmpty() ) {
                int[] indices = new int[list.size()];

                Iterator it = list.iterator();
                Item[] items = doGetItems();
                Object modelElement;

                int count = 0;
                while( it.hasNext() ) {
                    modelElement = it.next();
                    bool found = false;
                    for (int i = 0; i < items.length && !found; i++) {
                        if (opEquals(modelElement, items[i].getData())) {
                            indices[count++] = i;
                            found = true;
                        }
                    }
                }

                if (count < indices.length) {
                    System.arraycopy(indices, 0, indices = new int[count], 0, count);
                }

                doSelect(indices);
            }
        }
    }

    /**
     * Set the selection on a virtual table
     *
     * @param list
     *            The elements to set
     * @param reveal
     *            Whether or not reveal the first item.
     */
    private void virtualSetSelectionToWidget(List list, bool reveal) {
        int size = list.size();
        int[] indices = new int[list.size()];

        Item firstItem = null;
        int count = 0;
        HashSet virtualElements = new HashSet();
        for (int i = 0; i < size; ++i) {
            Object o = list.get(i);
            Widget w = findItem(o);
            if (auto item = cast(Item)w ) {
                indices[count++] = doIndexOf(item);
                if (firstItem is null) {
                    firstItem = item;
                }
            } else {
                virtualElements.add(o);
            }
        }

        if ( auto provider = cast(ILazyContentProvider) getContentProvider() ) {

            // Now go through it again until all is done or we are no longer
            // virtual
            // This may create all items so it is not a good
            // idea in general.
            // Use #setSelection (int [] indices,bool reveal) instead
            for (int i = 0; virtualElements.size() > 0 && i < doGetItemCount(); i++) {
                provider.updateElement(i);
                Item item = doGetItem(i);
                if (virtualElements.contains(item.getData())) {
                    indices[count++] = i;
                    virtualElements.remove(item.getData());
                    if (firstItem is null) {
                        firstItem = item;
                    }
                }
            }
        } else {

            if (count !is list.size()) {// As this is expensive skip it if all
                // have been found
                // If it is not lazy we can use the cache
                for (int i = 0; i < virtualManager.cachedElements.length; i++) {
                    Object element = virtualManager.cachedElements[i];
                    if (virtualElements.contains(element)) {
                        Item item = doGetItem(i);
                        item.getText();// Be sure to fire the update
                        indices[count++] = i;
                        virtualElements.remove(element);
                        if (firstItem is null) {
                            firstItem = item;
                        }
                    }
                }
            }
        }

        if (count < size) {
            System.arraycopy(indices, 0, indices = new int[count], 0, count);
        }
        doDeselectAll();
        doSelect(indices);

        if (reveal && firstItem !is null) {
            doShowItem(firstItem);
        }
    }

    /**
     * Set the item count of the receiver.
     *
     * @param count
     *            the new table size.
     *
     * @since 3.1
     */
    public void setItemCount(int count) {
        if (checkBusy())
            return;
        int oldCount = doGetItemCount();
        if (count < oldCount) {
            // need to disassociate elements that are being disposed
            for (int i = count; i < oldCount; i++) {
                Item item = doGetItem(i);
                if (item.getData() !is null) {
                    disassociate(item);
                }
            }
        }
        doSetItemCount(count);
        if (virtualManager !is null) {
            virtualManager.adjustCacheSize(count);
        }
        getControl().redraw();
    }

    /**
     * Replace the element at the given index with the given element. This
     * method will not call the content provider to verify. <strong>Note that
     * this method will materialize a TableItem the given index.</strong>.
     *
     * @param element
     * @param index
     * @see ILazyContentProvider
     *
     * @since 3.1
     */
    public void replace(Object element, int index) {
        if (checkBusy())
            return;
        Item item = doGetItem(index);
        refreshItem(item, element);
    }

    /**
     * Clear the table item at the specified index
     *
     * @param index
     *            the index of the table item to be cleared
     *
     * @since 3.1
     */
    public void clear(int index) {
        Item item = doGetItem(index);
        if (item.getData() !is null) {
            disassociate(item);
        }
        doClear(index);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.StructuredViewer#getRawChildren(java.lang.Object)
     */
    protected override Object[] getRawChildren(Object parent) {

        Assert.isTrue(!( null !is cast(ILazyContentProvider) getContentProvider() ),
                "Cannot get raw children with an ILazyContentProvider");//$NON-NLS-1$
        return super.getRawChildren(parent);

    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.StructuredViewer#assertContentProviderType(dwtx.jface.viewers.IContentProvider)
     */
    protected override void assertContentProviderType(IContentProvider provider) {
        Assert.isTrue(null !is cast(IStructuredContentProvider)provider
                || null !is cast(ILazyContentProvider)provider );
    }

    /**
     * Searches the receiver's list starting at the first item (index 0) until
     * an item is found that is equal to the argument, and returns the index of
     * that item. If no item is found, returns -1.
     *
     * @param item
     *            the search item
     * @return the index of the item
     *
     * @since 3.3
     */
    protected abstract int doIndexOf(Item item);

    /**
     * Returns the number of items contained in the receiver.
     *
     * @return the number of items
     *
     * @since 3.3
     */
    protected abstract int doGetItemCount();

    /**
     * Sets the number of items contained in the receiver.
     *
     * @param count
     *            the number of items
     *
     * @since 3.3
     */
    protected abstract void doSetItemCount(int count);

    /**
     * Returns a (possibly empty) array of TableItems which are the items in the
     * receiver.
     *
     * @return the items in the receiver
     *
     * @since 3.3
     */
    protected abstract Item[] doGetItems();

    /**
     * Returns the column at the given, zero-relative index in the receiver.
     * Throws an exception if the index is out of range. Columns are returned in
     * the order that they were created. If no TableColumns were created by the
     * programmer, this method will throw ERROR_INVALID_RANGE despite the fact
     * that a single column of data may be visible in the table. This occurs
     * when the programmer uses the table like a list, adding items but never
     * creating a column.
     *
     * @param index
     *            the index of the column to return
     * @return the column at the given index
     * @exception IllegalArgumentException -
     *                if the index is not between 0 and the number of elements
     *                in the list minus 1 (inclusive)
     *
     * @since 3.3
     */
    protected abstract Widget doGetColumn(int index);

    /**
     * Returns the item at the given, zero-relative index in the receiver.
     * Throws an exception if the index is out of range.
     *
     * @param index
     *            the index of the item to return
     * @return the item at the given index
     * @exception IllegalArgumentException -
     *                if the index is not between 0 and the number of elements
     *                in the list minus 1 (inclusive)
     *
     * @since 3.3
     */
    protected abstract Item doGetItem(int index);

    /**
     * Returns an array of {@link Item} that are currently selected in the
     * receiver. The order of the items is unspecified. An empty array indicates
     * that no items are selected.
     *
     * @return an array representing the selection
     *
     * @since 3.3
     */
    protected abstract Item[] doGetSelection();

    /**
     * Returns the zero-relative indices of the items which are currently
     * selected in the receiver. The order of the indices is unspecified. The
     * array is empty if no items are selected.
     *
     * @return an array representing the selection
     *
     * @since 3.3
     */
    protected abstract int[] doGetSelectionIndices();

    /**
     * Clears all the items in the receiver. The text, icon and other attributes
     * of the items are set to their default values. If the table was created
     * with the <code>DWT.VIRTUAL</code> style, these attributes are requested
     * again as needed.
     *
     * @since 3.3
     */
    protected abstract void doClearAll();

    /**
     * Resets the given item in the receiver. The text, icon and other attributes
     * of the item are set to their default values.
     *
     * @param item the item to reset
     *
     * @since 3.3
     */
    protected abstract void doResetItem(Item item);

    /**
     * Removes the items from the receiver which are between the given
     * zero-relative start and end indices (inclusive).
     *
     * @param start
     *            the start of the range
     * @param end
     *            the end of the range
     *
     * @exception IllegalArgumentException -
     *                if either the start or end are not between 0 and the
     *                number of elements in the list minus 1 (inclusive)
     *
     * @since 3.3
     */
    protected abstract void doRemove(int start, int end);

    /**
     * Removes all of the items from the receiver.
     *
     * @since 3.3
     */
    protected abstract void doRemoveAll();

    /**
     * Removes the items from the receiver's list at the given zero-relative
     * indices.
     *
     * @param indices
     *            the array of indices of the items
     *
     * @exception IllegalArgumentException -
     *                if the array is null, or if any of the indices is not
     *                between 0 and the number of elements in the list minus 1
     *                (inclusive)
     *
     * @since 3.3
     */
    protected abstract void doRemove(int[] indices);

    /**
     * Shows the item. If the item is already showing in the receiver, this
     * method simply returns. Otherwise, the items are scrolled until the item
     * is visible.
     *
     * @param item
     *            the item to be shown
     *
     * @exception IllegalArgumentException -
     *                if the item is null
     *
     * @since 3.3
     */
    protected abstract void doShowItem(Item item);

    /**
     * Deselects all selected items in the receiver.
     *
     * @since 3.3
     */
    protected abstract void doDeselectAll();

    /**
     * Sets the receiver's selection to be the given array of items. The current
     * selection is cleared before the new items are selected.
     * <p>
     * Items that are not in the receiver are ignored. If the receiver is
     * single-select and multiple items are specified, then all items are
     * ignored.
     * </p>
     *
     * @param items
     *            the array of items
     *
     * @exception IllegalArgumentException -
     *                if the array of items is null
     *
     * @since 3.3
     */
    protected abstract void doSetSelection(Item[] items);

    /**
     * Shows the selection. If the selection is already showing in the receiver,
     * this method simply returns. Otherwise, the items are scrolled until the
     * selection is visible.
     *
     * @since 3.3
     */
    protected abstract void doShowSelection();

    /**
     * Selects the items at the given zero-relative indices in the receiver. The
     * current selection is cleared before the new items are selected.
     * <p>
     * Indices that are out of range and duplicate indices are ignored. If the
     * receiver is single-select and multiple indices are specified, then all
     * indices are ignored.
     * </p>
     *
     * @param indices
     *            the indices of the items to select
     *
     * @exception IllegalArgumentException -
     *                if the array of indices is null
     *
     * @since 3.3
     */
    protected abstract void doSetSelection(int[] indices);

    /**
     * Clears the item at the given zero-relative index in the receiver. The
     * text, icon and other attributes of the item are set to the default value.
     * If the table was created with the <code>DWT.VIRTUAL</code> style, these
     * attributes are requested again as needed.
     *
     * @param index
     *            the index of the item to clear
     *
     * @exception IllegalArgumentException -
     *                if the index is not between 0 and the number of elements
     *                in the list minus 1 (inclusive)
     *
     * @see DWT#VIRTUAL
     * @see DWT#SetData
     *
     * @since 3.3
     */
    protected abstract void doClear(int index);



    /**
     * Selects the items at the given zero-relative indices in the receiver.
     * The current selection is not cleared before the new items are selected.
     * <p>
     * If the item at a given index is not selected, it is selected.
     * If the item at a given index was already selected, it remains selected.
     * Indices that are out of range and duplicate indices are ignored.
     * If the receiver is single-select and multiple indices are specified,
     * then all indices are ignored.
     * </p>
     *
     * @param indices the array of indices for the items to select
     *
     * @exception IllegalArgumentException - if the array of indices is null
     *
     */
    protected abstract void doSelect(int[] indices);

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