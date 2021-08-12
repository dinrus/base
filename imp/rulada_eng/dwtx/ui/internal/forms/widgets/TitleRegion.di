/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
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
module dwtx.ui.internal.forms.widgets.TitleRegion;

import dwtx.ui.internal.forms.widgets.BusyIndicator;
import dwtx.ui.internal.forms.widgets.FormHeading;
import dwtx.ui.internal.forms.widgets.FormUtil;

import dwt.DWT;
import dwt.dnd.DragSource;
import dwt.dnd.DragSourceEffect;
import dwt.dnd.DragSourceEvent;
import dwt.dnd.DragSourceListener;
import dwt.dnd.DropTarget;
import dwt.dnd.DropTargetListener;
import dwt.dnd.Transfer;
import dwt.events.MouseEvent;
import dwt.events.MouseMoveListener;
import dwt.events.MouseTrackListener;
import dwt.events.PaintEvent;
import dwt.events.PaintListener;
import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.graphics.FontMetrics;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Canvas;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Event;
import dwt.widgets.Label;
import dwt.widgets.Layout;
import dwt.widgets.Listener;
import dwt.widgets.Menu;
import dwtx.jface.action.IMenuManager;
import dwtx.jface.action.MenuManager;
import dwtx.ui.forms.IFormColors;
import dwtx.ui.forms.widgets.ILayoutExtension;
import dwtx.ui.forms.widgets.SizeCache;
import dwtx.ui.forms.widgets.Twistie;
import dwtx.ui.internal.forms.IMessageToolTipManager;

import dwt.dwthelper.utils;

/**
 * Form heading title.
 */
public class TitleRegion : Canvas {

    alias Canvas.computeSize computeSize;

    public static const int STATE_NORMAL = 0;
    public static const int STATE_HOVER_LIGHT = 1;
    public static const int STATE_HOVER_FULL = 2;
    private int hoverState;
    private static const int HMARGIN = 1;
    private static const int VMARGIN = 5;
    private static const int SPACING = 5;
    private static const int ARC_WIDTH = 20;
    private static const int ARC_HEIGHT = 20;
    private Image image;
    private BusyIndicator busyLabel;
    private Label titleLabel;
    private SizeCache titleCache;
    private int fontHeight = -1;
    private int fontBaselineHeight = -1;
    private MenuHyperlink menuHyperlink;
    private MenuManager menuManager;
    private bool dragSupport;
    private int dragOperations;
    private Transfer[] dragTransferTypes;
    private DragSourceListener dragListener;
    private DragSource dragSource;
    private Image dragImage;

    private class HoverListener : MouseTrackListener,
            MouseMoveListener {

        public void mouseEnter(MouseEvent e) {
            setHoverState(STATE_HOVER_FULL);
        }

        public void mouseExit(MouseEvent e) {
            setHoverState(STATE_NORMAL);
        }

        public void mouseHover(MouseEvent e) {
        }

        public void mouseMove(MouseEvent e) {
            if (e.button > 0)
                setHoverState(STATE_NORMAL);
            else
                setHoverState(STATE_HOVER_FULL);
        }
    }

    private class MenuHyperlink : Twistie {
        private bool firstTime = true;

        public this(Composite parent, int style) {
            super(parent, style);
            setExpanded(true);
        }

        public void setExpanded(bool expanded) {
            if (firstTime) {
                super.setExpanded(expanded);
                firstTime = false;
            } else {
                Menu menu = menuManager.createContextMenu(menuHyperlink);
                menu.setVisible(true);
            }
        }
    }

    private class TitleRegionLayout : Layout, ILayoutExtension {

        protected Point computeSize(Composite composite, int wHint, int hHint,
                bool flushCache) {
            return layout(composite, false, 0, 0, wHint, hHint, flushCache);
        }

        protected void layout(Composite composite, bool flushCache) {
            Rectangle carea = composite.getClientArea();
            layout(composite, true, carea.x, carea.y, carea.width,
                    carea.height, flushCache);
        }

        private Point layout(Composite composite, bool move, int x, int y,
                int width, int height, bool flushCache) {
            int iwidth = width is DWT.DEFAULT ? DWT.DEFAULT : width - HMARGIN
                    * 2;
            Point bsize = null;
            Point tsize = null;
            Point msize = null;

            if (busyLabel !is null) {
                bsize = busyLabel.computeSize(DWT.DEFAULT, DWT.DEFAULT);
            }
            if (menuManager !is null) {
                menuHyperlink.setVisible(!menuManager.isEmpty()
                        && titleLabel.getVisible());
                if (menuHyperlink.getVisible())
                    msize = menuHyperlink.computeSize(DWT.DEFAULT, DWT.DEFAULT);
            }
            if (flushCache)
                titleCache.flush();
            titleCache.setControl(titleLabel);
            int twidth = iwidth is DWT.DEFAULT ? iwidth : iwidth - SPACING * 2;
            if (bsize !is null && twidth !is DWT.DEFAULT)
                twidth -= bsize.x + SPACING;
            if (msize !is null && twidth !is DWT.DEFAULT)
                twidth -= msize.x + SPACING;
            if (titleLabel.getVisible()) {
                tsize = titleCache.computeSize(twidth, DWT.DEFAULT);
                if (twidth !is DWT.DEFAULT) {
                    // correct for the case when width hint is larger
                    // than the maximum width - this is when the text
                    // can be rendered on one line with width to spare
                    int maxWidth = titleCache.computeSize(DWT.DEFAULT,
                            DWT.DEFAULT).x;
                    tsize.x = Math.min(tsize.x, maxWidth);
                    // System.out.println("twidth="+twidth+",
                    // tsize.x="+tsize.x); //$NON-NLS-1$//$NON-NLS-2$
                }
            } else
                tsize = new Point(0, 0);
            Point size = new Point(width, height);
            if (!move) {
                // compute size
                size.x = tsize.x > 0 ? HMARGIN * 2 + SPACING * 2 + tsize.x : 0;
                size.y = tsize.y;
                if (bsize !is null) {
                    size.x += bsize.x + SPACING;
                    size.y = Math.max(size.y, bsize.y);
                }
                if (msize !is null) {
                    size.x += msize.x + SPACING;
                    size.y = Math.max(size.y, msize.y);
                }
                if (size.y > 0)
                    size.y += VMARGIN * 2;
                // System.out.println("Compute size: width="+width+",
                // size.x="+size.x); //$NON-NLS-1$ //$NON-NLS-2$
            } else {
                // position controls
                int xloc = x + HMARGIN + SPACING;
                int yloc = y + VMARGIN;
                if (bsize !is null) {
                    busyLabel.setBounds(xloc,
                            // yloc + height / 2 - bsize.y / 2,
                            yloc + (getFontHeight() >= bsize.y ? getFontHeight() : bsize.y) - 1 - bsize.y,
                            bsize.x, bsize.y);
                    xloc += bsize.x + SPACING;
                }
                if (titleLabel.getVisible()) {
                    int tw = width - HMARGIN * 2 - SPACING * 2;
                    if (bsize !is null)
                        tw -= bsize.x + SPACING;
                    if (msize !is null)
                        tw -= msize.x + SPACING;
                    titleLabel.setBounds(xloc,
                    // yloc + height / 2 - tsize.y / 2,
                            yloc, tw, tsize.y);
                    // System.out.println("tw="+tw); //$NON-NLS-1$
                    xloc += tw + SPACING;
                }
                if (msize !is null) {
                    menuHyperlink.setBounds(xloc, yloc
                            + getFontHeight() / 2 - msize.y / 2,
                            msize.x, msize.y);
                }
            }
            return size;
        }

        public int computeMaximumWidth(Composite parent, bool changed) {
            return computeSize(parent, DWT.DEFAULT, DWT.DEFAULT, changed).x;
        }

        public int computeMinimumWidth(Composite parent, bool changed) {
            return computeSize(parent, 0, DWT.DEFAULT, changed).x;
        }
    }

    public this(Composite parent) {
        super(parent, DWT.NULL);
        titleLabel = new Label(this, DWT.WRAP);
        titleLabel.setVisible(false);
        titleCache = new SizeCache();
        super.setLayout(new TitleRegionLayout());
        hookHoverListeners();
        addListener(DWT.Dispose, new class Listener {
            public void handleEvent(Event e) {
                if (dragImage !is null) {
                    dragImage.dispose();
                    dragImage = null;
                }
            }
        });
    }

    /* (non-Javadoc)
     * @see dwt.widgets.Control#forceFocus()
     */
    public bool forceFocus() {
        return false;
    }

    private Color getColor(String key) {
        return cast(Color) (cast(FormHeading) getParent()).colors.get(key);
    }

    private void hookHoverListeners() {
        HoverListener listener = new HoverListener();
        addMouseTrackListener(listener);
        addMouseMoveListener(listener);
        titleLabel.addMouseTrackListener(listener);
        titleLabel.addMouseMoveListener(listener);
        addPaintListener(new class PaintListener {
            public void paintControl(PaintEvent e) {
                onPaint(e);
            }
        });
    }

    private void onPaint(PaintEvent e) {
        if (hoverState is STATE_NORMAL)
            return;
        GC gc = e.gc;
        Rectangle carea = getClientArea();
        gc.setBackground(getHoverBackground());
        int savedAntialias = gc.getAntialias();
        FormUtil.setAntialias(gc, DWT.ON);
        gc.fillRoundRectangle(carea.x + HMARGIN, carea.y + 2, carea.width
                - HMARGIN * 2, carea.height - 4, ARC_WIDTH, ARC_HEIGHT);
        FormUtil.setAntialias(gc, savedAntialias);
    }

    private Color getHoverBackground() {
        if (hoverState is STATE_NORMAL)
            return null;
        Color color = getColor(hoverState is STATE_HOVER_FULL ? IFormColors.H_HOVER_FULL
                : IFormColors.H_HOVER_LIGHT);
        if (color is null)
            color = getDisplay()
                    .getSystemColor(
                            hoverState is STATE_HOVER_FULL ? DWT.COLOR_WIDGET_BACKGROUND
                                    : DWT.COLOR_WIDGET_LIGHT_SHADOW);
        return color;
    }

    public void setHoverState(int state) {
        if (dragSource is null || this.hoverState is state)
            return;
        this.hoverState = state;
        Color color = getHoverBackground();
        titleLabel.setBackground(color !is null ? color
                : getColor(FormHeading.COLOR_BASE_BG));
        if (busyLabel !is null)
            busyLabel.setBackground(color !is null ? color
                    : getColor(FormHeading.COLOR_BASE_BG));
        if (menuHyperlink !is null)
            menuHyperlink.setBackground(color !is null ? color
                    : getColor(FormHeading.COLOR_BASE_BG));
        redraw();
    }

    /**
     * Fully delegates the size computation to the internal layout manager.
     */
    public final Point computeSize(int wHint, int hHint, bool changed) {
        return (cast(TitleRegionLayout) getLayout()).computeSize(this, wHint,
                hHint, changed);
    }

    public final void setLayout(Layout layout) {
        // do nothing
    }

    public Image getImage() {
        return image;
    }

    public void setImage(Image image) {
        this.image = image;
    }

    public void updateImage(Image newImage, bool doLayout) {
        Image theImage = newImage !is null ? newImage : this.image;

        if (theImage !is null) {
            ensureBusyLabelExists();
        } else if (busyLabel !is null) {
            if (!busyLabel.isBusy()) {
                busyLabel.dispose();
                busyLabel = null;
            }
        }
        if (busyLabel !is null) {
            busyLabel.setImage(theImage);
        }
        if (doLayout)
            layout();
    }

    public void updateToolTip(String toolTip) {
        if (busyLabel !is null)
            busyLabel.setToolTipText(toolTip);
    }

    public void setBackground(Color bg) {
        super.setBackground(bg);
        titleLabel.setBackground(bg);
        if (busyLabel !is null)
            busyLabel.setBackground(bg);
        if (menuHyperlink !is null)
            menuHyperlink.setBackground(bg);
    }

    public void setForeground(Color fg) {
        super.setForeground(fg);
        titleLabel.setForeground(fg);
        if (menuHyperlink !is null)
            menuHyperlink.setForeground(fg);
    }

    public void setText(String text) {
        if (text !is null)
            titleLabel.setText(text);
        titleLabel.setVisible(text !is null);
        layout();
        redraw();
    }

    public String getText() {
        return titleLabel.getText();
    }

    public void setFont(Font font) {
        super.setFont(font);
        titleLabel.setFont(font);
        fontHeight = -1;
        fontBaselineHeight = -1;
        layout();
    }

    private void ensureBusyLabelExists() {
        if (busyLabel is null) {
            busyLabel = new BusyIndicator(this, DWT.NULL);
            busyLabel.setBackground(getColor(FormHeading.COLOR_BASE_BG));
            HoverListener listener = new HoverListener();
            busyLabel.addMouseTrackListener(listener);
            busyLabel.addMouseMoveListener(listener);
            if (menuManager !is null)
                busyLabel.setMenu(menuManager.createContextMenu(this));
            if (dragSupport)
                addDragSupport(busyLabel, dragOperations, dragTransferTypes, dragListener);
            IMessageToolTipManager mng = (cast(FormHeading) getParent())
                    .getMessageToolTipManager();
            if (mng !is null)
                mng.createToolTip(busyLabel, true);
        }
    }

    private void createMenuHyperlink() {
        menuHyperlink = new MenuHyperlink(this, DWT.NULL);
        menuHyperlink.setBackground(getColor(FormHeading.COLOR_BASE_BG));
        menuHyperlink.setDecorationColor(getForeground());
        menuHyperlink.setHoverDecorationColor(getDisplay().getSystemColor(DWT.COLOR_LIST_FOREGROUND));
        HoverListener listener = new HoverListener();
        menuHyperlink.addMouseTrackListener(listener);
        menuHyperlink.addMouseMoveListener(listener);
        if (dragSupport)
            addDragSupport(menuHyperlink, dragOperations, dragTransferTypes, dragListener);
    }

    /**
     * Sets the form's busy state. Busy form will display 'busy' animation in
     * the area of the title image.
     *
     * @param busy
     *            the form's busy state
     */

    public bool setBusy(bool busy) {
        if (busy)
            ensureBusyLabelExists();
        else if (busyLabel is null)
            return false;
        if (busy is busyLabel.isBusy())
            return false;
        busyLabel.setBusy(busy);
        if (busyLabel.getImage() is null) {
            layout();
            return true;
        }
        return false;
    }

    public bool isBusy() {
        return busyLabel !is null && busyLabel.isBusy();
    }

    /*
     * Returns the complete height of the font.
     */
    public int getFontHeight() {
        if (fontHeight is -1) {
            Font font = getFont();
            GC gc = new GC(getDisplay());
            gc.setFont(font);
            FontMetrics fm = gc.getFontMetrics();
            fontHeight = fm.getHeight();
            gc.dispose();
        }
        return fontHeight;
    }

    /*
     * Returns the height of the font starting at the baseline,
     * i.e. without the descent.
     */
    public int getFontBaselineHeight() {
        if (fontBaselineHeight is -1) {
            Font font = getFont();
            GC gc = new GC(getDisplay());
            gc.setFont(font);
            FontMetrics fm = gc.getFontMetrics();
            fontBaselineHeight = fm.getHeight() - fm.getDescent();
            gc.dispose();
        }
        return fontBaselineHeight;
    }

    public IMenuManager getMenuManager() {
        if (menuManager is null) {
            menuManager = new MenuManager();
            Menu menu = menuManager.createContextMenu(this);
            setMenu(menu);
            titleLabel.setMenu(menu);
            if (busyLabel !is null)
                busyLabel.setMenu(menu);
            createMenuHyperlink();
        }
        return menuManager;
    }

    public void addDragSupport(int operations, Transfer[] transferTypes,
            DragSourceListener listener) {
        dragSupport = true;
        dragOperations = operations;
        dragTransferTypes = transferTypes;
        dragListener = listener;
        dragSource = addDragSupport(titleLabel, operations, transferTypes,
                listener);
        addDragSupport(this, operations, transferTypes, listener);
        if (busyLabel !is null)
            addDragSupport(busyLabel, operations, transferTypes, listener);
        if (menuHyperlink !is null)
            addDragSupport(menuHyperlink, operations, transferTypes, listener);
    }

    private DragSource addDragSupport(Control control, int operations,
            Transfer[] transferTypes, DragSourceListener listener) {
        DragSource source = new DragSource(control, operations);
        source.setTransfer(transferTypes);
        source.addDragListener(listener);
        source.setDragSourceEffect(new class(control) DragSourceEffect {
            this(Control c){
                super(c);
            }
            public void dragStart(DragSourceEvent event) {
                event.image = createDragEffectImage();
            }
        });
        return source;
    }

    private Image createDragEffectImage() {
        /*
         * if (dragImage !is null) { dragImage.dispose(); } GC gc = new GC(this);
         * Point size = getSize(); dragImage = new Image(getDisplay(), size.x,
         * size.y); gc.copyArea(dragImage, 0, 0); gc.dispose(); return
         * dragImage;
         */
        return null;
    }

    public void addDropSupport(int operations, Transfer[] transferTypes,
            DropTargetListener listener) {
        final DropTarget target = new DropTarget(this, operations);
        target.setTransfer(transferTypes);
        target.addDropListener(listener);
    }
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
