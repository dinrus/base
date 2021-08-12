/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Tom Schindl - bug 151205
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.viewers.StructuredViewer;

import dwtx.jface.viewers.IBaseLabelProvider;
import dwtx.jface.viewers.IPostSelectionProvider;
import dwtx.jface.viewers.ContentViewer;
import dwtx.jface.viewers.CustomHashtable;
import dwtx.jface.viewers.IElementComparer;
import dwtx.jface.viewers.ViewerComparator;
import dwtx.jface.viewers.ViewerFilter;
import dwtx.jface.viewers.IDoubleClickListener;
import dwtx.jface.viewers.IOpenListener;
import dwtx.jface.viewers.ISelectionChangedListener;
import dwtx.jface.viewers.OpenEvent;
import dwtx.jface.viewers.SelectionChangedEvent;
import dwtx.jface.viewers.ISelection;
import dwtx.jface.viewers.DoubleClickEvent;
import dwtx.jface.viewers.ViewerSorter;
import dwtx.jface.viewers.IContentProvider;
import dwtx.jface.viewers.IColorProvider;
import dwtx.jface.viewers.IFontProvider;
import dwtx.jface.viewers.LabelProviderChangedEvent;
import dwtx.jface.viewers.ViewerLabel;
import dwtx.jface.viewers.TreePath;
import dwtx.jface.viewers.ITreePathLabelProvider;
import dwtx.jface.viewers.IViewerLabelProvider;
import dwtx.jface.viewers.ILabelProvider;
import dwtx.jface.viewers.IStructuredContentProvider;
import dwtx.jface.viewers.StructuredSelection;
import dwtx.jface.viewers.IStructuredSelection;


import dwt.custom.TableTreeItem;
import dwt.dnd.DragSource;
import dwt.dnd.DragSourceListener;
import dwt.dnd.DropTarget;
import dwt.dnd.DropTargetListener;
import dwt.dnd.Transfer;
import dwt.events.DisposeEvent;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.widgets.Control;
import dwt.widgets.Item;
import dwt.widgets.TableItem;
import dwt.widgets.TreeItem;
import dwt.widgets.Widget;
import dwtx.core.runtime.Assert;
import dwtx.core.runtime.ListenerList;
import dwtx.jface.util.IOpenEventListener;
import dwtx.jface.util.OpenStrategy;
import dwtx.jface.util.SafeRunnable;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwt.dwthelper.Runnable;

/**
 * Abstract base implementation for structure-oriented viewers (trees, lists,
 * tables). Supports custom sorting, filtering, and rendering.
 * <p>
 * Any number of viewer filters can be added to this viewer (using
 * <code>addFilter</code>). When the viewer receives an update, it asks each
 * of its filters if it is out of date, and refilters elements as required.
 * </p>
 *
 * @see ViewerFilter
 * @see ViewerComparator
 */
public abstract class StructuredViewer : ContentViewer, IPostSelectionProvider {
    alias ContentViewer.opEquals opEquals;
    alias ContentViewer.setSelection setSelection;
    /**
     * A map from the viewer's model elements to DWT widgets. (key type:
     * <code>Object</code>, value type: <code>Widget</code>, or <code>Widget[]</code>).
     * <code>null</code> means that the element map is disabled.
     */
    private CustomHashtable elementMap;

    /**
     * The comparer to use for comparing elements, or <code>null</code> to use
     * the default <code>equals</code> and <code>hashCode</code> methods on
     * the element itself.
     */
    private IElementComparer comparer;

    /**
     * This viewer's comparator used for sorting. <code>null</code> means there is no comparator.
     */
    private ViewerComparator sorter;

    /**
     * This viewer's filters (element type: <code>ViewerFilter</code>).
     * <code>null</code> means there are no filters.
     */
    private List filters;

    /**
     * Indicates whether a selection change is in progress on this viewer.
     *
     * @see #setSelection(ISelection, bool)
     */
    private bool inChange;

    /**
     * Used while a selection change is in progress on this viewer to indicates
     * whether the selection should be restored.
     *
     * @see #setSelection(ISelection, bool)
     */
    private bool restoreSelection;

    /**
     * List of double-click state listeners (element type:
     * <code>IDoubleClickListener</code>).
     *
     * @see #fireDoubleClick
     */
    private ListenerList doubleClickListeners;

    /**
     * List of open listeners (element type:
     * <code>ISelectionActivateListener</code>).
     *
     * @see #fireOpen
     */
    private ListenerList openListeners;

    /**
     * List of post selection listeners (element type:
     * <code>ISelectionActivateListener</code>).
     *
     * @see #firePostSelectionChanged
     */
    private ListenerList postSelectionChangedListeners;

    /**
     * The colorAndFontCollector is an object used by viewers that
     * support the IColorProvider, the IFontProvider and/or the
     * IViewerLabelProvider for color and font updates.
     * Initialize it to have no color or font providing
     * initially.
     * @since 3.1
     */
    private ColorAndFontCollector colorAndFontCollector;

    /**
     * Empty array of widgets.
     */
    private static Widget[] NO_WIDGETS = null;

    /**
     * The ColorAndFontCollector is a helper class for viewers
     * that have color and font support ad optionally decorators.
     * @see IColorDecorator
     * @see IFontDecorator
     * @see IColorProvider
     * @see IFontProvider
     * @see IDecoration
     */
    protected class ColorAndFontCollectorWithProviders : ColorAndFontCollector{

        IColorProvider colorProvider;

        IFontProvider fontProvider;

        /**
         * Create a new instance of the receiver using the supplied
         * label provider. If it is an IColorProvider or IFontProvider
         * set these values up.
         * @param provider IBaseLabelProvider
         * @see IColorProvider
         * @see IFontProvider
         */
        public this(IBaseLabelProvider provider) {
            super();
            if ( auto cp = cast(IColorProvider) provider ) {
                colorProvider = cp;
            }
            if ( auto fp = cast(IFontProvider) provider ) {
                fontProvider = fp;
            }
        }


        /* (non-Javadoc)
         * @see dwtx.jface.viewers.StructuredViewer.ColorAndFontManager#setFontsAndColors(java.lang.Object)
         */
        public override void setFontsAndColors(Object element){

            if(fontProvider !is null){
                if(font is null) {
                    font = fontProvider.getFont(element);
                }
            }

            if(colorProvider is null) {
                return;
            }
            //Set the colors if they are not set yet
            if(background is null) {
                background = colorProvider.getBackground(element);
            }

            if(foreground is null) {
                foreground = colorProvider.getForeground(element);
            }
        }

        /**
         * Apply the fonts and colors to the control if
         * required.
         * @param control
         */
        public override void applyFontsAndColors(TableItem control) {

            if(colorProvider is null){
                if(usedDecorators){
                    //If there is no provider only apply set values
                    if(background !is null) {
                        control.setBackground(background);
                    }

                    if(foreground !is null) {
                        control.setForeground(foreground);
                    }
                }
            }
            else{
                //Always set the value if there is a provider
                control.setBackground(background);
                control.setForeground(foreground);
            }

            if(fontProvider is null){
                if(usedDecorators && font !is null) {
                    control.setFont(font);
                }
            } else {
                control.setFont(font);
            }

            clear();
        }



        /* (non-Javadoc)
         * @see dwtx.jface.viewers.StructuredViewer.ColorAndFontManager#applyFontsAndColors(dwt.widgets.TreeItem)
         */
        public override void applyFontsAndColors(TreeItem control) {

            if(colorProvider is null){
                if(usedDecorators){
                    //If there is no provider only apply set values
                    if(background !is null) {
                        control.setBackground(background);
                    }

                    if(foreground !is null) {
                        control.setForeground(foreground);
                    }
                }
            }
            else{
                //Always set the value if there is a provider
                control.setBackground(background);
                control.setForeground(foreground);
            }

            if(fontProvider is null){
                if(usedDecorators && font !is null) {
                    control.setFont(font);
                }
            } else {
                control.setFont(font);
            }

            clear();
        }


        /* (non-Javadoc)
         * @see dwtx.jface.viewers.StructuredViewer.ColorAndFontManager#applyFontsAndColors(dwt.custom.TableTreeItem)
         */
        public override void applyFontsAndColors(TableTreeItem control) {

            if(colorProvider is null){
                if(usedDecorators){
                    //If there is no provider only apply set values
                    if(background !is null) {
                        control.setBackground(background);
                    }

                    if(foreground !is null) {
                        control.setForeground(foreground);
                    }
                }
            }
            else{
                //Always set the value if there is a provider
                control.setBackground(background);
                control.setForeground(foreground);
            }

            if(fontProvider is null){
                if(usedDecorators && font !is null) {
                    control.setFont(font);
                }
            } else {
                control.setFont(font);
            }

            clear();
        }


    }

    /**
     * The ColorAndFontCollector collects fonts and colors without a
     * a color or font provider.
     *
     */
    protected class ColorAndFontCollector {

        Color foreground = null;

        Color background = null;

        Font font = null;

        bool usedDecorators = false;

        /**
         * Create a new instance of the receiver with
         * no color and font provider.
         */
        public this(){
        }


        /**
         * Clear all of the results.
         */
        public void clear() {
            foreground = null;
            background = null;
            font = null;
            usedDecorators = false;
        }


        /**
         * Set the initial fonts and colors for the element from the
         * content providers.
         * @param element Object
         */
        public void setFontsAndColors(Object element){
            //Do nothing if there are no providers
        }

        /**
         * Set that decorators were applied.
         */
        public void setUsedDecorators() {
            this.usedDecorators = true;
        }

        /**
         * Apply the fonts and colors to the control if
         * required.
         * @param control
         */
        public void applyFontsAndColors(TableItem control) {

            if(usedDecorators){
                //If there is no provider only apply set values
                if(background !is null) {
                    control.setBackground(background);
                }

                if(foreground !is null) {
                    control.setForeground(foreground);
                }

                if(font !is null) {
                    control.setFont(font);
                }
            }
            clear();
        }

        /**
         * Apply the fonts and colors to the control if
         * required.
         * @param control
         */
        public void applyFontsAndColors(TreeItem control) {
            if(usedDecorators){
                //If there is no provider only apply set values
                if(background !is null) {
                    control.setBackground(background);
                }

                if(foreground !is null) {
                    control.setForeground(foreground);
                }

                if(font !is null) {
                    control.setFont(font);
                }
            }
            clear();
        }

        /**
         * Apply the fonts and colors to the control if
         * required.
         * @param control
         */
        public void applyFontsAndColors(TableTreeItem control) {
            if(usedDecorators){
                //If there is no provider only apply set values
                if(background !is null) {
                    control.setBackground(background);
                }

                if(foreground !is null) {
                    control.setForeground(foreground);
                }

                if(font !is null) {
                    control.setFont(font);
                }
            }
            clear();
        }

        /**
         * Set the background color.
         * @param background
         */
        public void setBackground(Color background) {
            this.background = background;
        }
        /**
         * Set the font.
         * @param font
         */
        public void setFont(Font font) {
            this.font = font;
        }
        /**
         * Set the foreground color.
         * @param foreground
         */
        public void setForeground(Color foreground) {
            this.foreground = foreground;
        }


    }

    /**
     * The safe runnable used to update an item.
     */
    class UpdateItemSafeRunnable : SafeRunnable {
        private Widget widget;

        private Object element;

        private bool fullMap;

        this(Widget widget, Object element, bool fullMap) {
            this.widget = widget;
            this.element = element;
            this.fullMap = fullMap;
        }

        public void run() {
            doUpdateItem(widget, element, fullMap);
        }
    }

    /**
     * Creates a structured element viewer. The viewer has no input, no content
     * provider, a default label provider, no sorter, and no filters.
     */
    protected this() {
        doubleClickListeners = new ListenerList();
        openListeners = new ListenerList();
        postSelectionChangedListeners = new ListenerList();
        colorAndFontCollector = new ColorAndFontCollector();
        // do nothing
    }

    /**
     * Adds a listener for double-clicks in this viewer. Has no effect if an
     * identical listener is already registered.
     *
     * @param listener
     *            a double-click listener
     */
    public void addDoubleClickListener(IDoubleClickListener listener) {
        doubleClickListeners.add(cast(Object)listener);
    }

    /**
     * Adds a listener for selection-open in this viewer. Has no effect if an
     * identical listener is already registered.
     *
     * @param listener
     *            a double-click listener
     */
    public void addOpenListener(IOpenListener listener) {
        openListeners.add(cast(Object)listener);
    }

    /*
     * (non-Javadoc) Method declared on IPostSelectionProvider.
     */
    public void addPostSelectionChangedListener(ISelectionChangedListener listener) {
        postSelectionChangedListeners.add(cast(Object)listener);
    }

    /**
     * Adds support for dragging items out of this viewer via a user
     * drag-and-drop operation.
     *
     * @param operations
     *            a bitwise OR of the supported drag and drop operation types (
     *            <code>DROP_COPY</code>,<code>DROP_LINK</code>, and
     *            <code>DROP_MOVE</code>)
     * @param transferTypes
     *            the transfer types that are supported by the drag operation
     * @param listener
     *            the callback that will be invoked to set the drag data and to
     *            cleanup after the drag and drop operation finishes
     * @see dwt.dnd.DND
     */
    public void addDragSupport(int operations, Transfer[] transferTypes, DragSourceListener listener) {

        Control myControl = getControl();
        final DragSource dragSource = new DragSource(myControl, operations);
        dragSource.setTransfer(transferTypes);
        dragSource.addDragListener(listener);
    }

    /**
     * Adds support for dropping items into this viewer via a user drag-and-drop
     * operation.
     *
     * @param operations
     *            a bitwise OR of the supported drag and drop operation types (
     *            <code>DROP_COPY</code>,<code>DROP_LINK</code>, and
     *            <code>DROP_MOVE</code>)
     * @param transferTypes
     *            the transfer types that are supported by the drop operation
     * @param listener
     *            the callback that will be invoked after the drag and drop
     *            operation finishes
     * @see dwt.dnd.DND
     */
    public void addDropSupport(int operations, Transfer[] transferTypes,
            DropTargetListener listener) {
        Control control = getControl();
        DropTarget dropTarget = new DropTarget(control, operations);
        dropTarget.setTransfer(transferTypes);
        dropTarget.addDropListener(listener);
    }

    /**
     * Adds the given filter to this viewer, and triggers refiltering and
     * resorting of the elements. If you want to add more than one filter
     * consider using {@link StructuredViewer#setFilters(ViewerFilter[])}.
     *
     * @param filter
     *            a viewer filter
     * @see StructuredViewer#setFilters(ViewerFilter[])
     */
    public void addFilter(ViewerFilter filter) {
        if (filters is null) {
            filters = new ArrayList();
        }
        filters.add(filter);
        refresh();
    }

    /**
     * Asserts that the given array of elements is itself non- <code>null</code>
     * and contains no <code>null</code> elements.
     *
     * @param elements
     *            the array to check
     */
    protected void assertElementsNotNull(Object[] elements) {
//         Assert.isNotNull(elements);
        for (int i = 0, n = elements.length; i < n; ++i) {
            Assert.isNotNull(elements[i]);
        }
    }

    /**
     * Associates the given element with the given widget. Sets the given item's
     * data to be the element, and maps the element to the item in the element
     * map (if enabled).
     *
     * @param element
     *            the element
     * @param item
     *            the widget
     */
    protected void associate(Object element, Item item) {
        Object data = item.getData();
        if (data !is element) {
            if (data !is null) {
                disassociate(item);
            }
            item.setData(element);
        }
        // Always map the element, even if data is element,
        // since unmapAllElements() can leave the map inconsistent
        // See bug 2741 for details.
        mapElement(element, item);
    }

    /**
     * Disassociates the given DWT item from its corresponding element. Sets the
     * item's data to <code>null</code> and removes the element from the
     * element map (if enabled).
     *
     * @param item
     *            the widget
     */
    protected void disassociate(Item item) {
        Object element = item.getData();
        Assert.isNotNull(element);
        //Clear the map before we clear the data
        unmapElement(element, item);
        item.setData(null);
    }

    /**
     * Returns the widget in this viewer's control which represents the given
     * element if it is the viewer's input.
     * <p>
     * This method is internal to the framework; subclassers should not call
     * this method.
     * </p>
     *
     * @param element
     * @return the corresponding widget, or <code>null</code> if none
     */
    protected abstract Widget doFindInputItem(Object element);

    /**
     * Returns the widget in this viewer's control which represent the given
     * element. This method searches all the children of the input element.
     * <p>
     * This method is internal to the framework; subclassers should not call
     * this method.
     * </p>
     *
     * @param element
     * @return the corresponding widget, or <code>null</code> if none
     */
    protected abstract Widget doFindItem(Object element);

    /**
     * Copies the attributes of the given element into the given DWT item. The
     * element map is updated according to the value of <code>fullMap</code>.
     * If <code>fullMap</code> is <code>true</code> then the current mapping
     * from element to widgets is removed and the new mapping is added. If
     * full map is <code>false</code> then only the new map gets installed.
     * Installing only the new map is necessary in cases where only the order of
     * elements changes but not the set of elements.
     * <p>
     * This method is internal to the framework; subclassers should not call
     * this method.
     * </p>
     *
     * @param item
     * @param element element
     * @param fullMap
     *            <code>true</code> if mappings are added and removed, and
     *            <code>false</code> if only the new map gets installed
     */
    protected abstract void doUpdateItem(Widget item, Object element, bool fullMap);

    /**
     * Compares two elements for equality. Uses the element comparer if one has
     * been set, otherwise uses the default <code>equals</code> method on the
     * elements themselves.
     *
     * @param elementA
     *            the first element
     * @param elementB
     *            the second element
     * @return whether elementA is equal to elementB
     */
    protected int opEquals(Object elementA, Object elementB) {
        if (comparer is null) {
            return elementA is null ? elementB is null : elementA.opEquals(elementB);
        } else {
            return elementA is null ? elementB is null : comparer.opEquals(elementA, elementB);
        }
    }

    /**
     * Returns the result of running the given elements through the filters.
     *
     * @param elements
     *            the elements to filter
     * @return only the elements which all filters accept
     */
    protected Object[] filter(Object[] elements) {
        if (filters !is null) {
            ArrayList filtered = new ArrayList(elements.length);
            Object root = getRoot();
            for (int i = 0; i < elements.length; i++) {
                bool add = true;
                for (int j = 0; j < filters.size(); j++) {
                    add = (cast(ViewerFilter) filters.get(j)).select(this, root, elements[i]);
                    if (!add) {
                        break;
                    }
                }
                if (add) {
                    filtered.add(elements[i]);
                }
            }
            return filtered.toArray();
        }
        return elements;
    }

    /**
     * Finds the widget which represents the given element.
     * <p>
     * The default implementation of this method tries first to find the widget
     * for the given element assuming that it is the viewer's input; this is
     * done by calling <code>doFindInputItem</code>. If it is not found
     * there, it is looked up in the internal element map provided that this
     * feature has been enabled. If the element map is disabled, the widget is
     * found via <code>doFindInputItem</code>.
     * </p>
     *
     * @param element
     *            the element
     * @return the corresponding widget, or <code>null</code> if none
     */
    protected final Widget findItem(Object element) {
        Widget[] result = findItems(element);
        return result.length is 0 ? null : result[0];
    }

    /**
     * Finds the widgets which represent the given element. The returned array
     * must not be changed by clients; it might change upon calling other
     * methods on this viewer.
     * <p>
     * This method was introduced to support multiple equal elements in a viewer
     * (@see {@link AbstractTreeViewer}). Multiple equal elements are only
     * supported if the element map is enabled by calling
     * {@link #setUseHashlookup(bool)} and passing <code>true</code>.
     * </p>
     * <p>
     * The default implementation of this method tries first to find the widget
     * for the given element assuming that it is the viewer's input; this is
     * done by calling <code>doFindInputItem</code>. If it is not found
     * there, the widgets are looked up in the internal element map provided
     * that this feature has been enabled. If the element map is disabled, the
     * widget is found via <code>doFindInputItem</code>.
     * </p>
     *
     * @param element
     *            the element
     * @return the corresponding widgets
     *
     * @since 3.2
     */
    protected final Widget[] findItems(Object element) {
        Widget result = doFindInputItem(element);
        if (result !is null) {
            return [ result ];
        }
        // if we have an element map use it, otherwise search for the item.
        if (usingElementMap()) {
            Object widgetOrWidgets = elementMap.get(element);
            if (widgetOrWidgets is null) {
                return NO_WIDGETS;
            } else if ( auto w = cast(Widget) widgetOrWidgets ) {
                return [w];
            } else {
                return (cast(ArrayWrapperT!(Widget))widgetOrWidgets).array;
            }
        }
        result = doFindItem(element);
        return result is null ? NO_WIDGETS : [ result ];
    }

    /**
     * Notifies any double-click listeners that a double-click has been
     * received. Only listeners registered at the time this method is called are
     * notified.
     *
     * @param event
     *            a double-click event
     *
     * @see IDoubleClickListener#doubleClick
     */
    protected void fireDoubleClick(DoubleClickEvent event) {
        Object[] listeners = doubleClickListeners.getListeners();
        for (int i = 0; i < listeners.length; ++i) {
            SafeRunnable.run( dgSafeRunnable( (IDoubleClickListener l, DoubleClickEvent event_){
                l.doubleClick(event_);
            }, cast(IDoubleClickListener) listeners[i], event));
        }
    }
    package void fireDoubleClick_package(DoubleClickEvent event) {
        fireDoubleClick(event);
    }

    /**
     * Notifies any open event listeners that a open event has been received.
     * Only listeners registered at the time this method is called are notified.
     *
     * @param event
     *            a double-click event
     *
     * @see IOpenListener#open(OpenEvent)
     */
    protected void fireOpen(OpenEvent event) {
        Object[] listeners = openListeners.getListeners();
        for (int i = 0; i < listeners.length; ++i) {
            SafeRunnable.run( dgSafeRunnable( (IOpenListener l,OpenEvent event_){
                l.open(event_);
            }, cast(IOpenListener) listeners[i],event));
        }
    }
    package void fireOpen_package(OpenEvent event) {
        fireOpen(event);
    }

    /**
     * Notifies any post selection listeners that a post selection event has
     * been received. Only listeners registered at the time this method is
     * called are notified.
     *
     * @param event
     *            a selection changed event
     *
     * @see #addPostSelectionChangedListener(ISelectionChangedListener)
     */
    protected void firePostSelectionChanged(SelectionChangedEvent event) {
        Object[] listeners = postSelectionChangedListeners.getListeners();
        for (int i = 0; i < listeners.length; ++i) {
            SafeRunnable.run( dgSafeRunnable( (ISelectionChangedListener l, SelectionChangedEvent event_){
                l.selectionChanged(event_);
            },cast(ISelectionChangedListener) listeners[i],event));
        }
    }

    /**
     * Returns the comparer to use for comparing elements, or
     * <code>null</code> if none has been set.  If specified,
     * the viewer uses this to compare and hash elements rather
     * than the elements' own equals and hashCode methods.
     *
     * @return the comparer to use for comparing elements or
     *            <code>null</code>
     */
    public IElementComparer getComparer() {
        return comparer;
    }

    /**
     * Returns the filtered array of children of the given element. The
     * resulting array must not be modified, as it may come directly from the
     * model's internal state.
     *
     * @param parent
     *            the parent element
     * @return a filtered array of child elements
     */
    protected Object[] getFilteredChildren(Object parent) {
        Object[] result = getRawChildren(parent);
        if (filters !is null) {
            for (Iterator iter = filters.iterator(); iter.hasNext();) {
                ViewerFilter f = cast(ViewerFilter) iter.next();
                result = f.filter(this, parent, result);
            }
        }
        return result;
    }

    /**
     * Returns this viewer's filters.
     *
     * @return an array of viewer filters
     * @see StructuredViewer#setFilters(ViewerFilter[])
     */
    public ViewerFilter[] getFilters() {
        if (filters is null) {
            return new ViewerFilter[0];
        }
        return arraycast!(ViewerFilter)(filters.toArray());
    }

    /**
     * Returns the item at the given display-relative coordinates, or
     * <code>null</code> if there is no item at that location or
     * the underlying DWT-Control is not made up of {@link Item}
     * (e.g {@link ListViewer})
     * <p>
     * The default implementation of this method returns <code>null</code>.
     * </p>
     *
     * @param x
     *            horizontal coordinate
     * @param y
     *            vertical coordinate
     * @return the item, or <code>null</code> if there is no item at the given
     *         coordinates
     * @deprecated This method is deprecated in 3.3 in favor of {@link ColumnViewer#getItemAt(dwt.graphics.Point)}.
     * Viewers who are not subclasses of {@link ColumnViewer} should consider using a
     * widget relative implementation like {@link ColumnViewer#getItemAt(dwt.graphics.Point)}.
     *
     */
    protected Item getItem(int x, int y) {
        return null;
    }

    /**
     * Returns the children of the given parent without sorting and filtering
     * them. The resulting array must not be modified, as it may come directly
     * from the model's internal state.
     * <p>
     * Returns an empty array if the given parent is <code>null</code>.
     * </p>
     *
     * @param parent
     *            the parent element
     * @return the child elements
     */
    protected Object[] getRawChildren(Object parent) {
        Object[] result = null;
        if (parent !is null) {
            IStructuredContentProvider cp = cast(IStructuredContentProvider) getContentProvider();
            if (cp !is null) {
                result = cp.getElements(parent);
                assertElementsNotNull(result);
            }
        }
        return (result !is null) ? result : null;
    }

    /**
     * Returns the root element.
     * <p>
     * The default implementation of this framework method forwards to
     * <code>getInput</code>. Override if the root element is different from
     * the viewer's input element.
     * </p>
     *
     * @return the root element, or <code>null</code> if none
     */
    protected Object getRoot() {
        return getInput();
    }

    /**
     * The <code>StructuredViewer</code> implementation of this method returns
     * the result as an <code>IStructuredSelection</code>.
     * <p>
     * Subclasses do not typically override this method, but implement
     * <code>getSelectionFromWidget(List)</code> instead.
     * <p>
     * @return ISelection
     */
    public override ISelection getSelection() {
        Control control = getControl();
        if (control is null || control.isDisposed()) {
            return StructuredSelection.EMPTY;
        }
        List list = getSelectionFromWidget();
        return new StructuredSelection(list, comparer);
    }

    /**
     * Retrieves the selection, as a <code>List</code>, from the underlying
     * widget.
     *
     * @return the list of selected elements
     */
    protected abstract List getSelectionFromWidget();
    package List getSelectionFromWidget_package(){
        return getSelectionFromWidget();
    }

    /**
     * Returns the sorted and filtered set of children of the given element. The
     * resulting array must not be modified, as it may come directly from the
     * model's internal state.
     *
     * @param parent
     *            the parent element
     * @return a sorted and filtered array of child elements
     */
    protected Object[] getSortedChildren(Object parent) {
        Object[] result = getFilteredChildren(parent);
        if (sorter !is null) {
            // be sure we're not modifying the original array from the model
            result = result.dup;
            sorter.sort(this, result);
        }
        return result;
    }

    /**
     * Returns this viewer's sorter, or <code>null</code> if it does not have
     * one.  If this viewer has a comparator that was set via
     * <code>setComparator(ViewerComparator)</code> then this method will return
     * <code>null</code> if the comparator is not an instance of ViewerSorter.
     * <p>
     * It is recommended to use <code>getComparator()</code> instead.
     * </p>
     *
     * @return a viewer sorter, or <code>null</code> if none or if the comparator is
     *              not an instance of ViewerSorter
     */
    public ViewerSorter getSorter() {
        if ( auto vs = cast(ViewerSorter)sorter )
            return vs;
        return null;
    }

    /**
     * Return this viewer's comparator used to sort elements.
     * This method should be used instead of <code>getSorter()</code>.
     *
     * @return a viewer comparator, or <code>null</code> if none
     *
     * @since 3.2
     */
    public ViewerComparator getComparator(){
        return sorter;
    }

    /**
     * Handles a double-click select event from the widget.
     * <p>
     * This method is internal to the framework; subclassers should not call
     * this method.
     * </p>
     *
     * @param event
     *            the DWT selection event
     */
    protected void handleDoubleSelect(SelectionEvent event) {
        // This method is reimplemented in AbstractTreeViewer to fix bug 108102.

        // handle case where an earlier selection listener disposed the control.
        Control control = getControl();
        if (control !is null && !control.isDisposed()) {
            // If the double-clicked element can be obtained from the event, use it
            // otherwise get it from the control.  Some controls like List do
            // not have the notion of item.
            // For details, see bug 90161 [Navigator] DefaultSelecting folders shouldn't always expand first one
            ISelection selection;
            if (event.item !is null && event.item.getData() !is null) {
                selection = new StructuredSelection(event.item.getData());
            }
            else {
                selection = getSelection();
                updateSelection(selection);
            }
            fireDoubleClick(new DoubleClickEvent(this, selection));
        }
    }

    /**
     * Handles an open event from the OpenStrategy.
     * <p>
     * This method is internal to the framework; subclassers should not call
     * this method.
     * </p>
     *
     * @param event
     *            the DWT selection event
     */
    protected void handleOpen(SelectionEvent event) {
        Control control = getControl();
        if (control !is null && !control.isDisposed()) {
            ISelection selection = getSelection();
            fireOpen(new OpenEvent(this, selection));
        }
    }

    /**
     * Handles an invalid selection.
     * <p>
     * This framework method is called if a model change picked up by a viewer
     * results in an invalid selection. For instance if an element contained in
     * the selection has been removed from the viewer, the viewer is free to
     * either remove the element from the selection or to pick another element
     * as its new selection. The default implementation of this method calls
     * <code>updateSelection</code>. Subclasses may override it to implement
     * a different strategy for picking a new selection when the old selection
     * becomes invalid.
     * </p>
     *
     * @param invalidSelection
     *            the selection before the viewer was updated
     * @param newSelection
     *            the selection after the update, or <code>null</code> if none
     */
    protected void handleInvalidSelection(ISelection invalidSelection, ISelection newSelection) {
        updateSelection(newSelection);
        SelectionChangedEvent event = new SelectionChangedEvent(this, newSelection);
        firePostSelectionChanged(event);
    }

    /**
     * The <code>StructuredViewer</code> implementation of this
     * <code>ContentViewer</code> method calls <code>update</code> if the
     * event specifies that the label of a given element has changed, otherwise
     * it calls super. Subclasses may reimplement or extend.
     * </p>
     * @param event the event that generated this update
     */
    protected override void handleLabelProviderChanged(LabelProviderChangedEvent event) {
        Object[] elements = event.getElements();
        if (elements !is null) {
            update(elements, null);
        } else {
            super.handleLabelProviderChanged(event);
        }
    }
    package void handleLabelProviderChanged_package(LabelProviderChangedEvent event) {
        handleLabelProviderChanged(event);
    }

    /**
     * Handles a select event from the widget.
     * <p>
     * This method is internal to the framework; subclassers should not call
     * this method.
     * </p>
     *
     * @param event
     *            the DWT selection event
     */
    protected void handleSelect(SelectionEvent event) {
        // handle case where an earlier selection listener disposed the control.
        Control control = getControl();
        if (control !is null && !control.isDisposed()) {
            updateSelection(getSelection());
        }
    }

    /**
     * Handles a post select event from the widget.
     * <p>
     * This method is internal to the framework; subclassers should not call
     * this method.
     * </p>
     *
     * @param e the DWT selection event
     */
    protected void handlePostSelect(SelectionEvent e) {
        SelectionChangedEvent event = new SelectionChangedEvent(this, getSelection());
        firePostSelectionChanged(event);
    }

    /*
     * (non-Javadoc) Method declared on Viewer.
     */
    protected override void hookControl(Control control) {
        super.hookControl(control);
        OpenStrategy handler = new OpenStrategy(control);
        handler.addSelectionListener(new class SelectionListener {
            public void widgetSelected(SelectionEvent e) {
                // On Windows, selection events may happen during a refresh.
                // Ignore these events if we are currently in preservingSelection().
                // See bug 184441.
                if (!inChange) {
                    handleSelect(e);
                }
            }

            public void widgetDefaultSelected(SelectionEvent e) {
                handleDoubleSelect(e);
            }
        });
        handler.addPostSelectionListener(new class SelectionAdapter {
            public void widgetSelected(SelectionEvent e) {
                handlePostSelect(e);
            }
        });
        handler.addOpenListener(new class IOpenEventListener {
            public void handleOpen(SelectionEvent e) {
                this.outer.handleOpen(e);
            }
        });
    }

    /**
     * Returns whether this viewer has any filters.
     * @return bool
     */
    protected bool hasFilters() {
        return filters !is null && filters.size() > 0;
    }

    /**
     * Refreshes this viewer starting at the given element.
     *
     * @param element
     *            the element
     */
    protected abstract void internalRefresh(Object element);

    /**
     * Refreshes this viewer starting at the given element. Labels are updated
     * as described in <code>refresh(bool updateLabels)</code>.
     * <p>
     * The default implementation simply calls
     * <code>internalRefresh(element)</code>, ignoring
     * <code>updateLabels</code>.
     * <p>
     * If this method is overridden to do the actual refresh, then
     * <code>internalRefresh(Object element)</code> should simply call
     * <code>internalRefresh(element, true)</code>.
     *
     * @param element
     *            the element
     * @param updateLabels
     *            <code>true</code> to update labels for existing elements,
     *            <code>false</code> to only update labels as needed, assuming
     *            that labels for existing elements are unchanged.
     *
     * @since 2.0
     */
    protected void internalRefresh(Object element, bool updateLabels) {
        internalRefresh(element);
    }

    /**
     * Adds the element item pair to the element map.
     * <p>
     * This method is internal to the framework; subclassers should not call
     * this method.
     * </p>
     *
     * @param element
     *            the element
     * @param item
     *            the corresponding widget
     */
    protected void mapElement(Object element, Widget item) {
        if (elementMap !is null) {
            Object widgetOrWidgets = elementMap.get(element);
            if (widgetOrWidgets is null) {
                elementMap.put(element, item);
            } else if ( auto w = cast(Widget)widgetOrWidgets ) {
                if (widgetOrWidgets !is item) {
                    elementMap.put(element, new ArrayWrapperT!(Widget)( [ w, item ] ));
                }
            } else {
                Widget[] widgets = (cast(ArrayWrapperT!(Widget)) widgetOrWidgets).array;
                int indexOfItem = Arrays.asList(widgets).indexOf(item);
                if (indexOfItem is -1) {
                    int length_ = widgets.length;
                    System.arraycopy(widgets, 0,
                            widgets = new Widget[length_ + 1], 0, length_);
                    widgets[length_] = item;
                    elementMap.put(element, new ArrayWrapperObject(widgets));
                }
            }
        }
    }

    /**
     * Determines whether a change to the given property of the given element
     * would require refiltering and/or resorting.
     * <p>
     * This method is internal to the framework; subclassers should not call
     * this method.
     * </p>
     *
     * @param element
     *            the element
     * @param property
     *            the property
     * @return <code>true</code> if refiltering is required, and
     *         <code>false</code> otherwise
     */
    protected bool needsRefilter(Object element, String property) {
        if (sorter !is null && sorter.isSorterProperty(element, property)) {
            return true;
        }

        if (filters !is null) {
            for (int i = 0, n = filters.size(); i < n; ++i) {
                ViewerFilter filter = cast(ViewerFilter) filters.get(i);
                if (filter.isFilterProperty(element, property)) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Returns a new hashtable using the given capacity and this viewer's element comparer.
     *
     * @param capacity the initial capacity of the hashtable
     * @return a new hashtable
     *
     * @since 3.0
     */
    CustomHashtable newHashtable(int capacity) {
        return new CustomHashtable(capacity, getComparer());
    }

    /**
     * Attempts to preserves the current selection across a run of the given
     * code.
     * <p>
     * The default implementation of this method:
     * <ul>
     * <li>discovers the old selection (via <code>getSelection</code>)</li>
     * <li>runs the given runnable</li>
     * <li>attempts to restore the old selection (using
     * <code>setSelectionToWidget</code></li>
     * <li>rediscovers the resulting selection (via <code>getSelection</code>)
     * </li>
     * <li>calls <code>handleInvalidSelection</code> if the resulting selection is different from the old selection</li>
     * </ul>
     * </p>
     *
     * @param updateCode
     *            the code to run
     */
    protected void preservingSelection(Runnable updateCode) {
        preservingSelection(updateCode, false);
    }

    /**
     * Attempts to preserves the current selection across a run of the given
     * code, with a best effort to avoid scrolling if <code>reveal</code> is false,
     * or to reveal the selection if <code>reveal</code> is true.
     * <p>
     * The default implementation of this method:
     * <ul>
     * <li>discovers the old selection (via <code>getSelection</code>)</li>
     * <li>runs the given runnable</li>
     * <li>attempts to restore the old selection (using
     * <code>setSelectionToWidget</code></li>
     * <li>rediscovers the resulting selection (via <code>getSelection</code>)
     * </li>
     * <li>calls <code>handleInvalidSelection</code> if the selection did not
     * take</li>
     * </ul>
     * </p>
     *
     * @param updateCode
     *            the code to run
     * @param reveal
     *            <code>true</code> if the selection should be made visible,
     *            <code>false</code> if scrolling should be avoided
     * @since 3.3
     */
    void preservingSelection(Runnable updateCode, bool reveal) {

        ISelection oldSelection = null;
        try {
            // preserve selection
            oldSelection = getSelection();
            inChange = restoreSelection = true;

            // perform the update
            updateCode.run();

        } finally {
            inChange = false;

            // restore selection
            if (restoreSelection) {
                setSelectionToWidget(oldSelection, reveal);
            }

            // send out notification if old and new differ
            ISelection newSelection = getSelection();
            if (!(cast(Object)newSelection).opEquals(cast(Object)oldSelection)) {
                handleInvalidSelection(oldSelection, newSelection);
            }
        }
    }

    /*
     * Non-Javadoc. Method declared on Viewer.
     */
    public override void refresh() {
        refresh(getRoot());
    }

    /**
     * Refreshes this viewer with information freshly obtained from this
     * viewer's model. If <code>updateLabels</code> is <code>true</code>
     * then labels for otherwise unaffected elements are updated as well.
     * Otherwise, it assumes labels for existing elements are unchanged, and
     * labels are only obtained as needed (for example, for new elements).
     * <p>
     * Calling <code>refresh(true)</code> has the same effect as
     * <code>refresh()</code>.
     * <p>
     * Note that the implementation may still obtain labels for existing
     * elements even if <code>updateLabels</code> is false. The intent is
     * simply to allow optimization where possible.
     *
     * @param updateLabels
     *            <code>true</code> to update labels for existing elements,
     *            <code>false</code> to only update labels as needed, assuming
     *            that labels for existing elements are unchanged.
     *
     * @since 2.0
     */
    public void refresh(bool updateLabels) {
        refresh(getRoot(), updateLabels);
    }

    /**
     * Refreshes this viewer starting with the given element.
     * <p>
     * Unlike the <code>update</code> methods, this handles structural changes
     * to the given element (e.g. addition or removal of children). If only the
     * given element needs updating, it is more efficient to use the
     * <code>update</code> methods.
     * </p>
     *
     * @param element
     *            the element
     */
    public void refresh(Object element) {
        preservingSelection( dgRunnable( (Object element_){
            internalRefresh(element_);
        }, element ));
    }

    /**
     * Refreshes this viewer starting with the given element. Labels are updated
     * as described in <code>refresh(bool updateLabels)</code>.
     * <p>
     * Unlike the <code>update</code> methods, this handles structural changes
     * to the given element (e.g. addition or removal of children). If only the
     * given element needs updating, it is more efficient to use the
     * <code>update</code> methods.
     * </p>
     *
     * @param element
     *            the element
     * @param updateLabels
     *            <code>true</code> to update labels for existing elements,
     *            <code>false</code> to only update labels as needed, assuming
     *            that labels for existing elements are unchanged.
     *
     * @since 2.0
     */
    public void refresh(Object element, bool updateLabels) {
        preservingSelection( dgRunnable( (Object element_, bool updateLabels_){
            internalRefresh(element_, updateLabels_);
        },element, updateLabels));
    }

    /**
     *
     * Refreshes the given item with the given element. Calls
     * <code>doUpdateItem(..., false)</code>.
     * <p>
     * This method is internal to the framework; subclassers should not call
     * this method.
     * </p>
     * @param widget
     *            the widget
     * @param element
     *            the element
     */
    protected final void refreshItem(Widget widget, Object element) {
        SafeRunnable.run(new UpdateItemSafeRunnable(widget, element, true));
    }

    /**
     * Removes the given open listener from this viewer. Has no affect if an
     * identical listener is not registered.
     *
     * @param listener
     *            a double-click listener
     */
    public void removeOpenListener(IOpenListener listener) {
        openListeners.remove(cast(Object)listener);
    }

    /*
     * (non-Javadoc) Method declared on IPostSelectionProvider.
     */
    public void removePostSelectionChangedListener(ISelectionChangedListener listener) {
        postSelectionChangedListeners.remove(cast(Object)listener);
    }

    /**
     * Removes the given double-click listener from this viewer. Has no affect
     * if an identical listener is not registered.
     *
     * @param listener
     *            a double-click listener
     */
    public void removeDoubleClickListener(IDoubleClickListener listener) {
        doubleClickListeners.remove(cast(Object)listener);
    }

    /**
     * Removes the given filter from this viewer, and triggers refiltering and
     * resorting of the elements if required. Has no effect if the identical
     * filter is not registered. If you want to remove more than one filter
     * consider using {@link StructuredViewer#setFilters(ViewerFilter[])}.
     *
     * @param filter
     *            a viewer filter
     * @see StructuredViewer#setFilters(ViewerFilter[])
     */
    public void removeFilter(ViewerFilter filter) {
        Assert.isNotNull(filter);
        if (filters !is null) {
            // Note: can't use List.remove(Object). Use identity comparison
            // instead.
            for (Iterator i = filters.iterator(); i.hasNext();) {
                Object o = i.next();
                if (o is filter) {
                    i.remove();
                    refresh();
                    if (filters.size() is 0) {
                        filters = null;
                    }
                    return;
                }
            }
        }
    }

    /**
     * Sets the filters, replacing any previous filters, and triggers
     * refiltering and resorting of the elements.
     *
     * @param filters
     *            an array of viewer filters
     * @since 3.3
     */
    public void setFilters(ViewerFilter[] filters) {
        if (filters.length is 0) {
            resetFilters();
        } else {
            this.filters = new ArrayList(Arrays.asList(filters));
            refresh();
        }
    }

    /**
     * Discards this viewer's filters and triggers refiltering and resorting of
     * the elements.
     */
    public void resetFilters() {
        if (filters !is null) {
            filters = null;
            refresh();
        }
    }

    /**
     * Ensures that the given element is visible, scrolling the viewer if
     * necessary. The selection is unchanged.
     *
     * @param element
     *            the element to reveal
     */
    public abstract void reveal(Object element);

    /*
     *  (non-Javadoc)
     * @see dwtx.jface.viewers.ContentViewer#setContentProvider(dwtx.jface.viewers.IContentProvider)
     */
    public override void setContentProvider(IContentProvider provider) {
        assertContentProviderType(provider);
        super.setContentProvider(provider);
    }

    /**
     * Assert that the content provider is of one of the
     * supported types.
     * @param provider
     */
    protected void assertContentProviderType(IContentProvider provider) {
        Assert.isTrue( null !is cast(IStructuredContentProvider)provider );
    }

    /*
     *  (non-Javadoc)
     * @see dwtx.jface.viewers.Viewer#setInput(java.lang.Object)
     */
    public override final void setInput(Object input) {

        try {
            //      fInChange= true;

            unmapAllElements();

            super.setInput(input);

        } finally {
            //      fInChange= false;
        }
    }

    /*
     *  (non-Javadoc)
     * @see dwtx.jface.viewers.Viewer#setSelection(dwtx.jface.viewers.ISelection, bool)
     */
    public override void setSelection(ISelection selection, bool reveal) {
        /**
         * <p>
         * If the new selection differs from the current selection the hook
         * <code>updateSelection</code> is called.
         * </p>
         * <p>
         * If <code>setSelection</code> is called from within
         * <code>preserveSelection</code>, the call to
         * <code>updateSelection</code> is delayed until the end of
         * <code>preserveSelection</code>.
         * </p>
         * <p>
         * Subclasses do not typically override this method, but implement
         * <code>setSelectionToWidget</code> instead.
         * </p>
         */
        Control control = getControl();
        if (control is null || control.isDisposed()) {
            return;
        }
        if (!inChange) {
            setSelectionToWidget(selection, reveal);
            ISelection sel = getSelection();
            updateSelection(sel);
            firePostSelectionChanged(new SelectionChangedEvent(this, sel));
        } else {
            restoreSelection = false;
            setSelectionToWidget(selection, reveal);
        }
    }

    /**
     * Parlays the given list of selected elements into selections on this
     * viewer's control.
     * <p>
     * Subclasses should override to set their selection based on the given list
     * of elements.
     * </p>
     *
     * @param l
     *            list of selected elements (element type: <code>Object</code>)
     *            or <code>null</code> if the selection is to be cleared
     * @param reveal
     *            <code>true</code> if the selection is to be made visible,
     *            and <code>false</code> otherwise
     */
    protected abstract void setSelectionToWidget(List l, bool reveal);

    /**
     * Converts the selection to a <code>List</code> and calls
     * <code>setSelectionToWidget(List, bool)</code>. The selection is
     * expected to be an <code>IStructuredSelection</code> of elements. If
     * not, the selection is cleared.
     * <p>
     * Subclasses do not typically override this method, but implement
     * <code>setSelectionToWidget(List, bool)</code> instead.
     *
     * @param selection
     *            an IStructuredSelection of elements
     * @param reveal
     *            <code>true</code> to reveal the first element in the
     *            selection, or <code>false</code> otherwise
     */
    protected void setSelectionToWidget(ISelection selection, bool reveal) {
        if ( auto ss = cast(IStructuredSelection) selection ) {
            setSelectionToWidget(ss.toList(), reveal);
        } else {
            setSelectionToWidget(cast(List) null, reveal);
        }
    }

    /**
     * Sets this viewer's sorter and triggers refiltering and resorting of this
     * viewer's element. Passing <code>null</code> turns sorting off.
     * <p>
     * It is recommended to use <code>setComparator()</code> instead.
     * </p>
     *
     * @param sorter
     *            a viewer sorter, or <code>null</code> if none
     */
    public void setSorter(ViewerSorter sorter) {
        if (this.sorter !is sorter) {
            this.sorter = sorter;
            refresh();
        }
    }

    /**
     * Sets this viewer's comparator to be used for sorting elements, and triggers refiltering and
     * resorting of this viewer's element.  <code>null</code> turns sorting off.
     * To get the viewer's comparator, call <code>getComparator()</code>.
     * <p>
     * IMPORTANT: This method was introduced in 3.2. If a reference to this viewer object
     * is passed to clients who call <code>getSorter()<code>, null may be returned from
     * from that method even though the viewer is sorting its elements using the
     * viewer's comparator.
     * </p>
     *
     * @param comparator a viewer comparator, or <code>null</code> if none
     *
     * @since 3.2
     */
    public void setComparator(ViewerComparator comparator){
        if (this.sorter !is comparator){
            this.sorter = comparator;
            refresh();
        }
    }

    /**
     * Configures whether this structured viewer uses an internal hash table to
     * speeds up the mapping between elements and DWT items. This must be called
     * before the viewer is given an input (via <code>setInput</code>).
     *
     * @param enable
     *            <code>true</code> to enable hash lookup, and
     *            <code>false</code> to disable it
     */
    public void setUseHashlookup(bool enable) {
        Assert.isTrue(getInput() is null,
                "Can only enable the hash look up before input has been set");//$NON-NLS-1$
        if (enable) {
            elementMap = newHashtable(CustomHashtable.DEFAULT_CAPACITY);
        } else {
            elementMap = null;
        }
    }

    /**
     * Sets the comparer to use for comparing elements, or <code>null</code>
     * to use the default <code>equals</code> and <code>hashCode</code>
     * methods on the elements themselves.
     *
     * @param comparer
     *            the comparer to use for comparing elements or
     *            <code>null</code>
     */
    public void setComparer(IElementComparer comparer) {
        this.comparer = comparer;
        if (elementMap !is null) {
            elementMap = new CustomHashtable(elementMap, comparer);
        }
    }

    /**
     * Hook for testing.
     * @param element
     * @return Widget
     */
    public Widget testFindItem(Object element) {
        return findItem(element);
    }

    /**
     * Hook for testing.
     * @param element
     * @return Widget[]
     * @since 3.2
     */
    public Widget[] testFindItems(Object element) {
        return findItems(element);
    }

    /**
     * Removes all elements from the map.
     * <p>
     * This method is internal to the framework; subclassers should not call
     * this method.
     * </p>
     */
    protected void unmapAllElements() {
        if (elementMap !is null) {
            elementMap = newHashtable(CustomHashtable.DEFAULT_CAPACITY);
        }
    }

    /**
     * Removes the given element from the internal element to widget map. Does
     * nothing if mapping is disabled. If mapping is enabled, the given element
     * must be present.
     * <p>
     * This method is internal to the framework; subclassers should not call
     * this method.
     * </p>
     *
     * @param element
     *            the element
     */
    protected void unmapElement(Object element) {
        if (elementMap !is null) {
            elementMap.remove(element);
        }
    }

    /**
     * Removes the given association from the internal element to widget map.
     * Does nothing if mapping is disabled, or if the given element does not map
     * to the given item.
     * <p>
     * This method is internal to the framework; subclassers should not call
     * this method.
     * </p>
     *
     * @param element
     *            the element
     * @param item the item to unmap
     * @since 2.0
     */
    protected void unmapElement(Object element, Widget item) {
        // double-check that the element actually maps to the given item before
        // unmapping it
        if (elementMap !is null) {
            Object widgetOrWidgets = elementMap.get(element);
            if (widgetOrWidgets is null) {
                // item was not mapped, return
                return;
            } else if ( auto w = cast(Widget) widgetOrWidgets ) {
                if (item is widgetOrWidgets) {
                    elementMap.remove(element);
                }
            } else {
                Widget[] widgets = ( cast(ArrayWrapperT!(Widget)) widgetOrWidgets).array;
                int indexOfItem = Arrays.asList(widgets).indexOf(item);
                if (indexOfItem is -1) {
                    return;
                }
                int length = widgets.length;
                if (indexOfItem is 0) {
                    if(length is 1) {
                        elementMap.remove(element);
                    } else {
                        Widget[] updatedWidgets = new Widget[length - 1];
                        System.arraycopy(widgets, 1, updatedWidgets, 0, length -1 );
                        elementMap.put(element, new ArrayWrapperObject( updatedWidgets));
                    }
                } else {
                    Widget[] updatedWidgets = new Widget[length - 1];
                    System.arraycopy(widgets, 0, updatedWidgets, 0, indexOfItem);
                    System.arraycopy(widgets, indexOfItem + 1, updatedWidgets, indexOfItem, length - indexOfItem - 1);
                    elementMap.put(element, new ArrayWrapperObject(updatedWidgets));
                }
            }
        }
    }

    // flag to indicate that a full refresh took place. See bug 102440.
    private bool refreshOccurred;

    /**
     * Updates the given elements' presentation when one or more of their
     * properties change. Only the given elements are updated.
     * <p>
     * This does not handle structural changes (e.g. addition or removal of
     * elements), and does not update any other related elements (e.g. child
     * elements). To handle structural changes, use the <code>refresh</code>
     * methods instead.
     * </p>
     * <p>
     * This should be called when an element has changed in the model, in order
     * to have the viewer accurately reflect the model. This method only affects
     * the viewer, not the model.
     * </p>
     * <p>
     * Specifying which properties are affected may allow the viewer to optimize
     * the update. For example, if the label provider is not affected by changes
     * to any of these properties, an update may not actually be required.
     * Specifying <code>properties</code> as <code>null</code> forces a full
     * update of the given elements.
     * </p>
     * <p>
     * If the viewer has a sorter which is affected by a change to one of the
     * properties, the elements' positions are updated to maintain the sort
     * order. Note that resorting does not happen if <code>properties</code>
     * is <code>null</code>.
     * </p>
     * <p>
     * If the viewer has a filter which is affected by a change to one of the
     * properties, elements may appear or disappear if the change affects
     * whether or not they are filtered out.
     * </p>
     *
     * @param elements
     *            the elements
     * @param properties
     *            the properties that have changed, or <code>null</code> to
     *            indicate unknown
     */
    public void update(Object[] elements, String[] properties) {
        bool previousValue = refreshOccurred;
        refreshOccurred = false;
        try {
            for (int i = 0; i < elements.length; ++i) {
                update(elements[i], properties);
                if (refreshOccurred) {
                    return;
                }
            }
        } finally {
            refreshOccurred = previousValue;
        }
    }

    /**
     * Updates the given element's presentation when one or more of its
     * properties changes. Only the given element is updated.
     * <p>
     * This does not handle structural changes (e.g. addition or removal of
     * elements), and does not update any other related elements (e.g. child
     * elements). To handle structural changes, use the <code>refresh</code>
     * methods instead.
     * </p>
     * <p>
     * This should be called when an element has changed in the model, in order
     * to have the viewer accurately reflect the model. This method only affects
     * the viewer, not the model.
     * </p>
     * <p>
     * Specifying which properties are affected may allow the viewer to optimize
     * the update. For example, if the label provider is not affected by changes
     * to any of these properties, an update may not actually be required.
     * Specifying <code>properties</code> as <code>null</code> forces a full
     * update of the element.
     * </p>
     * <p>
     * If the viewer has a sorter which is affected by a change to one of the
     * properties, the element's position is updated to maintain the sort order.
     * Note that resorting does not happen if <code>properties</code> is
     * <code>null</code>.
     * </p>
     * <p>
     * If the viewer has a filter which is affected by a change to one of the
     * properties, the element may appear or disappear if the change affects
     * whether or not the element is filtered out.
     * </p>
     *
     * @param element
     *            the element
     * @param properties
     *            the properties that have changed, or <code>null</code> to
     *            indicate unknown
     */
    public void update(Object element, String[] properties) {
        Assert.isNotNull(element);
        Widget[] items = findItems(element);

        bool mayExitEarly = !refreshOccurred;
        for (int i = 0; i < items.length; i++) {
            internalUpdate(items[i], element, properties);
            if (mayExitEarly && refreshOccurred) {
                // detected a change from refreshOccurred is false to refreshOccurred is true
                return;
            }
        }
    }

    /**
     * Updates the given element's presentation when one or more of its
     * properties changes. Only the given element is updated.
     * <p>
     * EXPERIMENTAL.  Not to be used except by JDT.
     * This method was added to support JDT's explorations
     * into grouping by working sets, which requires viewers to support multiple
     * equal elements.  See bug 76482 for more details.  This support will
     * likely be removed in Eclipse 3.3 in favor of proper support for
     * multiple equal elements (which was implemented for AbtractTreeViewer in 3.2).
     * </p>
     * @param widget
     *            the widget for the element
     * @param element
     *            the element
     * @param properties
     *            the properties that have changed, or <code>null</code> to
     *            indicate unknown
     */
    protected void internalUpdate(Widget widget, Object element, String[] properties) {
        bool needsRefilter_ = false;
        if (properties !is null) {
            for (int i = 0; i < properties.length; ++i) {
                needsRefilter_ = needsRefilter(element, properties[i]);
                if (needsRefilter_) {
                    break;
                }
            }
        }
        if (needsRefilter_) {
            preservingSelection(dgRunnable( {
                internalRefresh(getRoot());
                refreshOccurred = true;
            }));
            return;
        }

        bool needsUpdate;
        if (properties is null) {
            needsUpdate = true;
        } else {
            needsUpdate = false;
            IBaseLabelProvider labelProvider = getLabelProvider();
            for (int i = 0; i < properties.length; ++i) {
                needsUpdate = labelProvider.isLabelProperty(element, properties[i]);
                if (needsUpdate) {
                    break;
                }
            }
        }
        if (needsUpdate) {
            updateItem(widget, element);
        }
    }

    /**
     * Copies attributes of the given element into the given widget.
     * <p>
     * This method is internal to the framework; subclassers should not call
     * this method. Calls <code>doUpdateItem(widget, element, true)</code>.
     * </p>
     *
     * @param widget
     *            the widget
     * @param element
     *            the element
     */
    protected final void updateItem(Widget widget, Object element) {
        SafeRunnable.run(new UpdateItemSafeRunnable(widget, element, true));
    }

    /**
     * Updates the selection of this viewer.
     * <p>
     * This framework method should be called when the selection in the viewer
     * widget changes.
     * </p>
     * <p>
     * The default implementation of this method notifies all selection change
     * listeners recorded in an internal state variable. Overriding this method
     * is generally not required; however, if overriding in a subclass,
     * <code>super.updateSelection</code> must be invoked.
     * </p>
     *
     * @param selection
     *            the selection, or <code>null</code> if none
     */
    protected void updateSelection(ISelection selection) {
        SelectionChangedEvent event = new SelectionChangedEvent(this, selection);
        fireSelectionChanged(event);
    }

    /**
     * Returns whether this structured viewer is configured to use an internal
     * map to speed up the mapping between elements and DWT items.
     * <p>
     * The default implementation of this framework method checks whether the
     * internal map has been initialized.
     * </p>
     *
     * @return <code>true</code> if the element map is enabled, and
     *         <code>false</code> if disabled
     */
    protected bool usingElementMap() {
        return elementMap !is null;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.ContentViewer#setLabelProvider(dwtx.jface.viewers.IBaseLabelProvider)
     */
    public override void setLabelProvider(IBaseLabelProvider labelProvider) {
        if ( null !is cast(IColorProvider)labelProvider  || null !is cast(IFontProvider)labelProvider ) {
            colorAndFontCollector = new ColorAndFontCollectorWithProviders(labelProvider);
        } else {
            colorAndFontCollector = new ColorAndFontCollector();
        }
        super.setLabelProvider(labelProvider);

    }

    /**
     * Build a label up for the element using the supplied label provider.
     * @param updateLabel The ViewerLabel to collect the result in
     * @param element The element being decorated.
     */
    protected void buildLabel(ViewerLabel updateLabel, Object element){

        if ( auto vlp = cast(IViewerLabelProvider)getLabelProvider() ) {
            IViewerLabelProvider itemProvider = cast(IViewerLabelProvider) getLabelProvider();
            itemProvider.updateLabel(updateLabel, element);

            colorAndFontCollector.setUsedDecorators();

            if(updateLabel.hasNewBackground()) {
                colorAndFontCollector.setBackground(updateLabel.getBackground());
            }

            if(updateLabel.hasNewForeground()) {
                colorAndFontCollector.setForeground(updateLabel.getForeground());
            }

            if(updateLabel.hasNewFont()) {
                colorAndFontCollector.setFont(updateLabel.getFont());
            }
            return;

        }

        if( cast(ILabelProvider) getLabelProvider() ){
            ILabelProvider labelProvider = cast(ILabelProvider) getLabelProvider();
            updateLabel.setText(labelProvider.getText(element));
            updateLabel.setImage(labelProvider.getImage(element));
        }

    }

    /**
     * Build a label up for the element using the supplied label provider.
     * @param updateLabel The ViewerLabel to collect the result in
     * @param element The element being decorated.
     * @param labelProvider ILabelProvider the labelProvider for the receiver.
     */
    void buildLabel(ViewerLabel updateLabel, Object element, IViewerLabelProvider labelProvider){

            labelProvider.updateLabel(updateLabel, element);

            colorAndFontCollector.setUsedDecorators();

            if(updateLabel.hasNewBackground()) {
                colorAndFontCollector.setBackground(updateLabel.getBackground());
            }

            if(updateLabel.hasNewForeground()) {
                colorAndFontCollector.setForeground(updateLabel.getForeground());
            }

            if(updateLabel.hasNewFont()) {
                colorAndFontCollector.setFont(updateLabel.getFont());
            }

    }

    /**
     * Build a label up for the element using the supplied label provider.
     * @param updateLabel The ViewerLabel to collect the result in
     * @param elementPath The path of the element being decorated.
     * @param labelProvider ILabelProvider the labelProvider for the receiver.
     */
    void buildLabel(ViewerLabel updateLabel, TreePath elementPath,ITreePathLabelProvider labelProvider){

            labelProvider.updateLabel(updateLabel, elementPath);

            colorAndFontCollector.setUsedDecorators();

            if(updateLabel.hasNewBackground()) {
                colorAndFontCollector.setBackground(updateLabel.getBackground());
            }

            if(updateLabel.hasNewForeground()) {
                colorAndFontCollector.setForeground(updateLabel.getForeground());
            }

            if(updateLabel.hasNewFont()) {
                colorAndFontCollector.setFont(updateLabel.getFont());
            }

    }

    /**
     * Build a label up for the element using the supplied label provider.
     * @param updateLabel The ViewerLabel to collect the result in
     * @param element The element being decorated.
     * @param labelProvider ILabelProvider the labelProvider for the receiver.
     */
    void buildLabel(ViewerLabel updateLabel, Object element,ILabelProvider labelProvider){
            updateLabel.setText(labelProvider.getText(element));
            updateLabel.setImage(labelProvider.getImage(element));
    }

    /**
     * Get the ColorAndFontCollector for the receiver.
     * @return ColorAndFontCollector
     * @since 3.1
     */
    protected ColorAndFontCollector getColorAndFontCollector() {
        return colorAndFontCollector;
    }

    protected override void handleDispose(DisposeEvent event) {
        super.handleDispose(event);
        sorter = null;
        comparer = null;
        if (filters !is null)
            filters.clear();
        elementMap = newHashtable(1);
        openListeners.clear();
        doubleClickListeners.clear();
        colorAndFontCollector.clear();
        postSelectionChangedListeners.clear();
    }

}
