/*******************************************************************************
 * Copyright (c) 2007, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Michael Krkoska - initial API and implementation (bug 188333)
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.viewers.StyledCellLabelProvider;

import dwtx.jface.viewers.OwnerDrawLabelProvider;
import dwtx.jface.viewers.ColumnViewer;
import dwtx.jface.viewers.ViewerColumn;
import dwtx.jface.viewers.ViewerCell;
import dwtx.jface.viewers.ViewerRow;

import dwt.DWT;
import dwt.custom.StyleRange;
import dwt.graphics.Color;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.graphics.Rectangle;
import dwt.graphics.TextLayout;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwtx.core.runtime.Assert;

import dwt.dwthelper.utils;

/**
 * A {@link StyledCellLabelProvider} supports styled labels by using owner
 * draw.
 * Besides the styles in labels, the label provider preserves native viewer behavior:
 * <ul>
 * <li>similar image and label positioning</li>
 * <li>native drawing of focus and selection</li>
 * </ul>
 * <p>
 * For providing the label's styles, create a subclass and overwrite
 * {@link StyledCellLabelProvider#update(ViewerCell)} to
 * return set all information needed to render a element. Use
 * {@link ViewerCell#setStyleRanges(StyleRange[])} to set style ranges
 * on the label.
 * </p>
 * <p>
 * The current version of the {@link StyledCellLabelProvider} will ignore all font settings on
 * {@link StyleRange}. Different fonts would make labels wider, and the native
 * selection drawing could not be reused.
 * </p>
 *
 * <p><strong>NOTE:</strong> This API is experimental and may be deleted or
 * changed before 3.4 is released.</p>
 *
 * @since 3.4
 */
public abstract class StyledCellLabelProvider : OwnerDrawLabelProvider {

    alias OwnerDrawLabelProvider.setOwnerDrawEnabled setOwnerDrawEnabled;

    /**
     * Style constant for indicating that the styled colors are to be applied
     * even it the viewer's item is selected. Default is not to apply colors.
     */
    public static const int COLORS_ON_SELECTION = 1 << 0;

    /**
     * Style constant for indicating to draw the focus if requested by the owner
     * draw event. Default is to draw the focus.
     */
    public static const int NO_FOCUS = 1 << 1;

    /**
     * Private constant to indicate if owner draw is enabled for the
     * label provider's column.
     */
    private static const int OWNER_DRAW_ENABLED = 1 << 4;

    private int style;

    // reused text layout
    private TextLayout cachedTextLayout;

    private ColumnViewer viewer;
    private ViewerColumn column;

    /**
     * Creates a new StyledCellLabelProvider. By default, owner draw is enabled, focus is drawn and no
     * colors are painted on selected elements.
     */
    public this() {
        this(0);
    }

    /**
     * Creates a new StyledCellLabelProvider. By default, owner draw is enabled.
     *
     * @param style
     *            the style bits
     * @see StyledCellLabelProvider#COLORS_ON_SELECTION
     * @see StyledCellLabelProvider#NO_FOCUS
     */
    public this(int style) {
        this.style = style & (COLORS_ON_SELECTION | NO_FOCUS)
                            | OWNER_DRAW_ENABLED;
    }

    /**
     * Returns <code>true</code> is the owner draw rendering is enabled for this label provider.
     * By default owner draw rendering is enabled. If owner draw rendering is disabled, rending is
     * done by the viewer and no styled ranges (see {@link ViewerCell#getStyleRanges()})
     * are drawn.
     *
     * @return <code>true</code> is the rendering of styles is enabled.
     */
    public bool isOwnerDrawEnabled() {
        return (this.style & OWNER_DRAW_ENABLED) !is 0;
    }

    /**
     * Specifies whether owner draw rendering is enabled for this label
     * provider. By default owner draw rendering is enabled. If owner draw
     * rendering is disabled, rendering is done by the viewer and no styled
     * ranges (see {@link ViewerCell#getStyleRanges()}) are drawn.
     * It is the caller's responsibility to also call
     * {@link StructuredViewer#refresh()} or similar methods to update the
     * underlying widget.
     *
     * @param enabled
     *            specifies if owner draw rendering is enabled
     */
    public void setOwnerDrawEnabled(bool enabled) {
        bool isEnabled= isOwnerDrawEnabled();
        if (isEnabled !is enabled) {
            if (enabled) {
                this.style |= OWNER_DRAW_ENABLED;
            } else {
                this.style &= ~OWNER_DRAW_ENABLED;
            }
            if (this.viewer !is null) {
                setOwnerDrawEnabled(this.viewer, this.column, enabled);
            }
        }
    }

    /**
     * Returns the viewer on which this label provider is installed on or <code>null</code> if the
     * label provider is not installed.
     *
     * @return the viewer on which this label provider is installed on or <code>null</code> if the
     * label provider is not installed.
     */
    protected final ColumnViewer getViewer() {
        return this.viewer;
    }

    /**
     * Returns the column on which this label provider is installed on or <code>null</code> if the
     * label provider is not installed.
     *
     * @return the column on which this label provider is installed on or <code>null</code> if the
     * label provider is not installed.
     */
    protected final ViewerColumn getColumn() {
        return this.column;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.OwnerDrawLabelProvider#initialize(dwtx.jface.viewers.ColumnViewer, dwtx.jface.viewers.ViewerColumn)
     */
    public void initialize(ColumnViewer viewer, ViewerColumn column) {
        Assert.isTrue(this.viewer is null && this.column is null, "Label provider instance already in use"); //$NON-NLS-1$

        this.viewer= viewer;
        this.column= column;
        super.initialize(viewer, column, isOwnerDrawEnabled());
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.BaseLabelProvider#dispose()
     */
    public void dispose() {
        if (this.cachedTextLayout !is null) {
            cachedTextLayout.dispose();
            cachedTextLayout = null;
        }

        this.viewer= null;
        this.column= null;

        super.dispose();
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.OwnerDrawLabelProvider#update(dwtx.jface.viewers.ViewerCell)
     */
    public void update(ViewerCell cell) {
        // clients must override and configure the cell and call super
        super.update(cell); // calls 'repaint' to trigger the paint listener
    }

    private TextLayout getSharedTextLayout(Display display) {
        if (cachedTextLayout is null) {
            int orientation = viewer.getControl().getStyle() & (DWT.LEFT_TO_RIGHT | DWT.RIGHT_TO_LEFT);
            cachedTextLayout = new TextLayout(display);
            cachedTextLayout.setOrientation(orientation);
        } else {
            cachedTextLayout.setText(""); // make sure no previous ranges are cleared //$NON-NLS-1$
        }
        return cachedTextLayout;
    }

    private bool useColors(Event event) {
        return (event.detail & DWT.SELECTED) is 0
                || (this.style & COLORS_ON_SELECTION) !is 0;
    }

    private bool drawFocus(Event event) {
        return (event.detail & DWT.FOCUSED) !is 0
                && (this.style & NO_FOCUS) is 0;
    }

    /**
     * Returns a {@link TextLayout} instance for the given cell
     * configured with the style ranges. The text layout instance is managed by
     * the label provider. Caller of the method must not dispose the text
     * layout.
     *
     * @param diplay
     *            the current display
     * @param applyColors
     *            if set, create colors in the result
     * @param cell
     *            the viewer cell
     * @return a TextLayout instance
     */
    private TextLayout getTextLayoutForInfo(Display display, ViewerCell cell, bool applyColors) {
        TextLayout layout = getSharedTextLayout(display);

        layout.setText(cell.getText());
        layout.setFont(cell.getFont()); // set also if null to clear previous usages

        StyleRange[] styleRanges = cell.getStyleRanges();
        if (styleRanges !is null) { // user didn't fill styled ranges
            for (int i = 0; i < styleRanges.length; i++) {
                StyleRange curr = prepareStyleRange(styleRanges[i], applyColors);
                layout.setStyle(curr, curr.start, curr.start + curr.length - 1);
            }
        }

        return layout;
    }

    /**
     * Prepares the given style range before it is applied to the label. This method makes sure that
     * no colors are drawn when the element is selected.
     * The current version of the {@link StyledCellLabelProvider} will also ignore all font settings on the
     * style range. Clients can override.
     *
     * @param styleRange
     *               the style range to prepare. the style range element must not be modified
     * @param applyColors
     *               specifies if colors should be applied.
     * @return
     *               returns the style range to use on the label
     */
    protected StyleRange prepareStyleRange(StyleRange styleRange, bool applyColors) {
        // if no colors apply or font is set, create a clone and clear the
        // colors and font
        if (styleRange.font !is null || !applyColors
                && (styleRange.foreground !is null || styleRange.background !is null)) {
            styleRange = cast(StyleRange) styleRange.clone();
            styleRange.font = null; // ignore font settings until bug 168807 is resolved
            if (!applyColors) {
                styleRange.foreground = null;
                styleRange.background = null;
            }
        }
        return styleRange;
    }

    private ViewerCell getViewerCell(Event event, Object element) {
        ViewerRow row= viewer.getViewerRowFromItem_package(event.item);
        return new ViewerCell(row, event.index, element);
    }

    /**
     * Handle the erase event. The default implementation does nothing to ensure
     * keep native selection highlighting working.
     *
     * @param event
     *            the erase event
     * @param element
     *            the model object
     * @see DWT#EraseItem
     */
    protected void erase(Event event, Object element) {
        // use native erase
        if (isOwnerDrawEnabled()) {
            // info has been set by 'update': announce that we paint ourselves
            event.detail &= ~DWT.FOREGROUND;
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.OwnerDrawLabelProvider#measure(dwt.widgets.Event,
     *      java.lang.Object)
     */
    protected void measure(Event event, Object element) {
        // use native measuring
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.OwnerDrawLabelProvider#paint(dwt.widgets.Event,
     *      java.lang.Object)
     */
    protected void paint(Event event, Object element) {
        if (!isOwnerDrawEnabled())
            return;

        ViewerCell cell= getViewerCell(event, element);

        bool applyColors = useColors(event);
        GC gc = event.gc;
        // remember colors to restore the GC later
        Color oldForeground = gc.getForeground();
        Color oldBackground = gc.getBackground();

        if (applyColors) {
            Color foreground= cell.getForeground();
            if (foreground !is null) {
                gc.setForeground(foreground);
            }

            Color background= cell.getBackground();
            if (background !is null) {
                gc.setBackground(background);
            }
        }

        Image image = cell.getImage();
        if (image !is null) {
            Rectangle imageBounds = cell.getImageBounds();
            if (imageBounds !is null) {
                Rectangle bounds = image.getBounds();

                // center the image in the given space
                int x = imageBounds.x
                        + Math.max(0, (imageBounds.width - bounds.width) / 2);
                int y = imageBounds.y
                        + Math.max(0, (imageBounds.height - bounds.height) / 2);
                gc.drawImage(image, x, y);
            }
        }

        TextLayout textLayout = getTextLayoutForInfo(event.display, cell, applyColors);

        Rectangle textBounds = cell.getTextBounds();
        if (textBounds !is null) {
            Rectangle layoutBounds = textLayout.getBounds();

            int x = textBounds.x;
            int y = textBounds.y
                    + Math.max(0, (textBounds.height - layoutBounds.height) / 2);

            textLayout.draw(gc, x, y);
        }

        if (drawFocus(event)) {
            Rectangle focusBounds = cell.getViewerRow().getBounds();
            gc.drawFocus(focusBounds.x, focusBounds.y, focusBounds.width,
                    focusBounds.height);
        }

        if (applyColors) {
            gc.setForeground(oldForeground);
            gc.setBackground(oldBackground);
        }
    }

}
