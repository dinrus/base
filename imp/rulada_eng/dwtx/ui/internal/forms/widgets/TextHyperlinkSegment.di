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
module dwtx.ui.internal.forms.widgets.TextHyperlinkSegment;

import dwtx.ui.internal.forms.widgets.TextSegment;
import dwtx.ui.internal.forms.widgets.IHyperlinkSegment;
import dwtx.ui.internal.forms.widgets.SelectionData;

import dwt.graphics.Color;
import dwt.graphics.GC;
import dwt.graphics.Rectangle;
import dwtx.ui.forms.HyperlinkSettings;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

/**
 * @version 1.0
 * @author
 */
public class TextHyperlinkSegment : TextSegment,
        IHyperlinkSegment {
    private String href;

    private String tooltipText;

    //private static final String LINK_FG = "c.___link_fg";

    private HyperlinkSettings settings;

    // reimpl for interface
    String getText(){
        return super.getText();
    }
    void paintFocus(GC gc, Color bg, Color fg, bool selected, Rectangle repaintRegion){
        super.paintFocus(gc,bg,fg,selected,repaintRegion);
    }
    bool contains(int x, int y){
        return super.contains(x,y);
    }
    bool intersects(Rectangle rect){
        return super.intersects(rect);
    }

    public this(String text, HyperlinkSettings settings,
            String fontId) {
        super(text, fontId);
        this.settings = settings;
        underline = settings.getHyperlinkUnderlineMode() is HyperlinkSettings.UNDERLINE_ALWAYS;
    }

    /*
     * @see IObjectReference#getObjectId()
     */
    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href;
    }

    /*
     * public void paint(GC gc, int width, Locator locator, Hashtable
     * resourceTable, bool selected, SelectionData selData) {
     * resourceTable.put(LINK_FG, settings.getForeground());
     * setColorId(LINK_FG); super.paint(gc, width, locator, resourceTable,
     * selected, selData); }
     */

    public void paint(GC gc, bool hover, Hashtable resourceTable,
            bool selected, SelectionData selData, Rectangle repaintRegion) {
        bool rolloverMode = settings.getHyperlinkUnderlineMode() is HyperlinkSettings.UNDERLINE_HOVER;
        Color savedFg = gc.getForeground();
        Color newFg = hover ? settings.getActiveForeground() : settings
                .getForeground();
        if (newFg !is null)
            gc.setForeground(newFg);
        super.paint(gc, hover, resourceTable, selected, rolloverMode, selData,
                repaintRegion);
        gc.setForeground(savedFg);
    }

    protected void drawString(GC gc, String s, int clipX, int clipY) {
        gc.drawString(s, clipX, clipY, false);
    }

    public String getTooltipText() {
        return tooltipText;
    }

    public void setTooltipText(String tooltip) {
        this.tooltipText = tooltip;
    }

    public bool isSelectable() {
        return true;
    }

    public bool isFocusSelectable(Hashtable resourceTable) {
        return true;
    }

    public bool setFocus(Hashtable resourceTable, bool direction) {
        return true;
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
