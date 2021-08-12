/*******************************************************************************
 * Copyright (c) 2006, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
 *                                                 bugfix in: 195137, 198089, 225190
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/

module dwtx.jface.window.ToolTip;

import tango.util.log.Trace;

import dwt.DWT;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.FillLayout;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Monitor;
import dwt.widgets.Shell;
// import dwtx.jface.viewers.ColumnViewer;
// import dwtx.jface.viewers.ViewerCell;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwt.dwthelper.Runnable;
import dwtx.dwtxhelper.JThread;
/**
 * This class gives implementors to provide customized tooltips for any control.
 *
 * @since 3.3
 */
public abstract class ToolTip {
    private Control control;

    private int xShift = 3;

    private int yShift = 0;

    private int popupDelay = 0;

    private int hideDelay = 0;

    private ToolTipOwnerControlListener listener;

    private HashMap data;

    // Ensure that only one tooltip is active in time
    private static Shell CURRENT_TOOLTIP;

    /**
     * Recreate the tooltip on every mouse move
     */
    public static const int RECREATE = 1;

    /**
     * Don't recreate the tooltip as long the mouse doesn't leave the area
     * triggering the tooltip creation
     */
    public static const int NO_RECREATE = 1 << 1;

    private TooltipHideListener hideListener;

    private Listener shellListener;

    private bool hideOnMouseDown = true;

    private bool respectDisplayBounds = true;

    private bool respectMonitorBounds = true;

    private int style;

    private Object currentArea;

    private static final bool IS_OSX = DWT.getPlatform().equals("carbon"); //$NON-NLS-1$

    /**
     * Create new instance which add TooltipSupport to the widget
     *
     * @param control
     *            the control on whose action the tooltip is shown
     */
    public this(Control control) {
        this(control, RECREATE, false);
    }

    /**
     * @param control
     *            the control to which the tooltip is bound
     * @param style
     *            style passed to control tooltip behavior
     *
     * @param manualActivation
     *            <code>true</code> if the activation is done manually using
     *            {@link #show(Point)}
     * @see #RECREATE
     * @see #NO_RECREATE
     */
    public this(Control control, int style, bool manualActivation) {
        this.control = control;
        this.style = style;
        this.hideListener = new TooltipHideListener();
        this.control.addDisposeListener(new class DisposeListener {

            public void widgetDisposed(DisposeEvent e) {
                this.outer.data = null;
                this.outer.deactivate();
            }

        });

        this.listener = new ToolTipOwnerControlListener();
        this.shellListener = dgListener( (Event event_, Control control_, ToolTip tooltip_) {
            if( control_ !is null
                    && ! control_.isDisposed() ) {
                control_.getDisplay().asyncExec( dgRunnable( (Event event__, Control control__, ToolTip tooltip__){
                    // Check if the new active shell is the tooltip
                    // itself
                    if( control__.getDisplay().getActiveShell() !is CURRENT_TOOLTIP) {
                        tooltip__.toolTipHide(CURRENT_TOOLTIP, event__);

                    }
                }, event_, control_, tooltip_));
            }
        }, control, this);

        if (!manualActivation) {
            activate();
        }
    }

    /**
     * Restore arbitrary data under the given key
     *
     * @param key
     *            the key
     * @param value
     *            the value
     */
    public void setData(String key, Object value) {
        if (data is null) {
            data = new HashMap();
        }
        data.put(stringcast(key), value);
    }

    /**
     * Get the data restored under the key
     *
     * @param key
     *            the key
     * @return data or <code>null</code> if no entry is restored under the key
     */
    public Object getData(String key) {
        if (data !is null) {
            return data.get(stringcast(key));
        }
        return null;
    }

    /**
     * Set the shift (from the mouse position triggered the event) used to
     * display the tooltip.
     * <p>
     * By default the tooltip is shifted 3 pixels to the right.
     * </p>
     *
     * @param p
     *            the new shift
     */
    public void setShift(Point p) {
        xShift = p.x;
        yShift = p.y;
    }

    /**
     * Activate tooltip support for this control
     */
    public void activate() {
        deactivate();
        control.addListener(DWT.Dispose, listener);
        control.addListener(DWT.MouseHover, listener);
        control.addListener(DWT.MouseMove, listener);
        control.addListener(DWT.MouseExit, listener);
        control.addListener(DWT.MouseDown, listener);
        control.addListener(DWT.MouseWheel, listener);
    }

    /**
     * Deactivate tooltip support for the underlying control
     */
    public void deactivate() {
        control.removeListener(DWT.Dispose, listener);
        control.removeListener(DWT.MouseHover, listener);
        control.removeListener(DWT.MouseMove, listener);
        control.removeListener(DWT.MouseExit, listener);
        control.removeListener(DWT.MouseDown, listener);
        control.removeListener(DWT.MouseWheel, listener);
    }

    /**
     * Return whether the tooltip respects bounds of the display.
     *
     * @return <code>true</code> if the tooltip respects bounds of the display
     */
    public bool isRespectDisplayBounds() {
        return respectDisplayBounds;
    }

    /**
     * Set to <code>false</code> if display bounds should not be respected or
     * to <code>true</code> if the tooltip is should repositioned to not
     * overlap the display bounds.
     * <p>
     * Default is <code>true</code>
     * </p>
     *
     * @param respectDisplayBounds
     */
    public void setRespectDisplayBounds(bool respectDisplayBounds) {
        this.respectDisplayBounds = respectDisplayBounds;
    }

    /**
     * Return whether the tooltip respects bounds of the monitor.
     *
     * @return <code>true</code> if tooltip respects the bounds of the monitor
     */
    public bool isRespectMonitorBounds() {
        return respectMonitorBounds;
    }

    /**
     * Set to <code>false</code> if monitor bounds should not be respected or
     * to <code>true</code> if the tooltip is should repositioned to not
     * overlap the monitors bounds. The monitor the tooltip belongs to is the
     * same is control's monitor the tooltip is shown for.
     * <p>
     * Default is <code>true</code>
     * </p>
     *
     * @param respectMonitorBounds
     */
    public void setRespectMonitorBounds(bool respectMonitorBounds) {
        this.respectMonitorBounds = respectMonitorBounds;
    }

    /**
     * Should the tooltip displayed because of the given event.
     * <p>
     * <b>Subclasses may overwrite this to get custom behavior</b>
     * </p>
     *
     * @param event
     *            the event
     * @return <code>true</code> if tooltip should be displayed
     */
    protected bool shouldCreateToolTip(Event event) {
        if ((style & NO_RECREATE) !is 0) {
            Object tmp = getToolTipArea(event);

            // No new area close the current tooltip
            if (tmp is null) {
                hide();
                return false;
            }

            bool rv = !tmp.opEquals(currentArea);
            return rv;
        }

        return true;
    }

    /**
     * This method is called before the tooltip is hidden
     *
     * @param event
     *            the event trying to hide the tooltip
     * @return <code>true</code> if the tooltip should be hidden
     */
    private bool shouldHideToolTip(Event event) {
        if (event !is null && event.type is DWT.MouseMove
                && (style & NO_RECREATE) !is 0) {
            Object tmp = getToolTipArea(event);

            // No new area close the current tooltip
            if (tmp is null) {
                hide();
                return false;
            }

            bool rv = !tmp.opEquals(currentArea);
            return rv;
        }

        return true;
    }

    /**
     * This method is called to check for which area the tooltip is
     * created/hidden for. In case of {@link #NO_RECREATE} this is used to
     * decide if the tooltip is hidden recreated.
     *
     * <code>By the default it is the widget the tooltip is created for but could be any object. To decide if
     * the area changed the {@link Object#equals(Object)} method is used.</code>
     *
     * @param event
     *            the event
     * @return the area responsible for the tooltip creation or
     *         <code>null</code> this could be any object describing the area
     *         (e.g. the {@link Control} onto which the tooltip is bound to, a
     *         part of this area e.g. for {@link ColumnViewer} this could be a
     *         {@link ViewerCell})
     */
    protected Object getToolTipArea(Event event) {
        return control;
    }

    /**
     * Start up the tooltip programmatically
     *
     * @param location
     *            the location relative to the control the tooltip is shown
     */
    public void show(Point location) {
        Event event = new Event();
        event.x = location.x;
        event.y = location.y;
        event.widget = control;
        toolTipCreate(event);
    }

    private Shell toolTipCreate(Event event) {
        if (shouldCreateToolTip(event)) {
            Shell shell = new Shell(control.getShell(), DWT.ON_TOP | DWT.TOOL
                    | DWT.NO_FOCUS);
            shell.setLayout(new FillLayout());

            toolTipOpen(shell, event);

            return shell;
        }

        return null;
    }

    private void toolTipShow(Shell tip, Event event) {
        if (!tip.isDisposed()) {
            currentArea = getToolTipArea(event);
            createToolTipContentArea(event, tip);
            if (isHideOnMouseDown()) {
                toolTipHookBothRecursively(tip);
            } else {
                toolTipHookByTypeRecursively(tip, true, DWT.MouseExit);
            }

            tip.pack();
            Point size = tip.getSize();
            Point location = fixupDisplayBounds(size, getLocation(size, event));

            // Need to adjust a bit more if the mouse cursor.y is tip.y and
            // the cursor.x is inside the tip
            Point cursorLocation = tip.getDisplay().getCursorLocation();

            if (cursorLocation.y is location.y && location.x < cursorLocation.x
                    && location.x + size.x > cursorLocation.x) {
                location.y -= 2;
            }

            tip.setLocation(location);
            tip.setVisible(true);
        }
    }

    private Point fixupDisplayBounds(Point tipSize, Point location) {
        if (respectDisplayBounds || respectMonitorBounds) {
            Rectangle bounds;
            Point rightBounds = new Point(tipSize.x + location.x, tipSize.y
                    + location.y);

            dwt.widgets.Monitor.Monitor[] ms = control.getDisplay().getMonitors();

            if (respectMonitorBounds && ms.length > 1) {
                // By default present in the monitor of the control
                bounds = control.getMonitor().getBounds();
                Point p = new Point(location.x, location.y);

                // Search on which monitor the event occurred
                Rectangle tmp;
                for (int i = 0; i < ms.length; i++) {
                    tmp = ms[i].getBounds();
                    if (tmp.contains(p)) {
                        bounds = tmp;
                        break;
                    }
                }

            } else {
                bounds = control.getDisplay().getBounds();
            }

            if (!(bounds.contains(location) && bounds.contains(rightBounds))) {
                if (rightBounds.x > bounds.x + bounds.width) {
                    location.x -= rightBounds.x - (bounds.x + bounds.width);
                }

                if (rightBounds.y > bounds.y + bounds.height) {
                    location.y -= rightBounds.y - (bounds.y + bounds.height);
                }

                if (location.x < bounds.x) {
                    location.x = bounds.x;
                }

                if (location.y < bounds.y) {
                    location.y = bounds.y;
                }
            }
        }

        return location;
    }

    /**
     * Get the display relative location where the tooltip is displayed.
     * Subclasses may overwrite to implement custom positioning.
     *
     * @param tipSize
     *            the size of the tooltip to be shown
     * @param event
     *            the event triggered showing the tooltip
     * @return the absolute position on the display
     */
    public Point getLocation(Point tipSize, Event event) {
        return control.toDisplay(event.x + xShift, event.y + yShift);
    }

    private void toolTipHide(Shell tip, Event event) {
                        assert(this);
        if (tip !is null && !tip.isDisposed() && shouldHideToolTip(event)) {
                        assert(this);
            control.getShell().removeListener(DWT.Deactivate, shellListener);
            currentArea = null;
            passOnEvent(tip, event);
            tip.dispose();
            CURRENT_TOOLTIP = null;
            afterHideToolTip(event);
        }
    }

    private void passOnEvent(Shell tip, Event event) {
        if (control !is null && !control.isDisposed() && event !is null
              && event.widget !is control && event.type is DWT.MouseDown) {
            Display display = control.getDisplay();
            Point newPt = display.map(tip, null, new Point(event.x, event.y));

            Event newEvent = new Event();
            newEvent.button = event.button;
            newEvent.character = event.character;
            newEvent.count = event.count;
            newEvent.data = event.data;
            newEvent.detail = event.detail;
            newEvent.display = event.display;
            newEvent.doit = event.doit;
            newEvent.end = event.end;
            newEvent.gc = event.gc;
            newEvent.height = event.height;
            newEvent.index = event.index;
            newEvent.item = event.item;
            newEvent.keyCode = event.keyCode;
            newEvent.start = event.start;
            newEvent.stateMask = event.stateMask;
            newEvent.text = event.text;
            newEvent.time = event.time;
            newEvent.type = event.type;
            newEvent.widget = event.widget;
            newEvent.width = event.width;
            newEvent.x = newPt.x;
            newEvent.y = newPt.y;

            tip.close();
            display.asyncExec(dgRunnable( delegate(Display display_, Event newEvent_) {
                if (IS_OSX) {
                    try {
                        JThread.sleep(300);
                    } catch (InterruptedException e) {

                    }

                    display_.post(newEvent_);
                    newEvent_.type = DWT.MouseUp;
                    display_.post(newEvent_);
                } else {
                    display_.post(newEvent_);
                }
            }, display,newEvent));
        }
    }

    private void toolTipOpen(Shell shell, Event event) {
        // Ensure that only one Tooltip is shown in time
        if (CURRENT_TOOLTIP !is null) {
            toolTipHide(CURRENT_TOOLTIP, null);
        }

        CURRENT_TOOLTIP = shell;

        control.getShell().addListener(DWT.Deactivate, shellListener);

        if (popupDelay > 0) {
            control.getDisplay().timerExec(popupDelay, dgRunnable( (Shell shell_,Event event_, ToolTip tooltip_){
                assert(tooltip_);
                tooltip_.toolTipShow(shell_, event_);
            },shell,event, this));
        } else {
            toolTipShow(CURRENT_TOOLTIP, event);
        }

        if (hideDelay > 0) {
            control.getDisplay().timerExec(popupDelay + hideDelay, dgRunnable( (Shell shell_, ToolTip tooltip_){
                assert(tooltip_);
                tooltip_.toolTipHide(shell_, null);
            }, shell, this ));
        }
    }

    private void toolTipHookByTypeRecursively(Control c, bool add, int type) {
        if (add) {
            c.addListener(type, hideListener);
        } else {
            c.removeListener(type, hideListener);
        }

        if ( auto c2 = cast(Composite)c ) {
            Control[] children = c2.getChildren();
            for (int i = 0; i < children.length; i++) {
                toolTipHookByTypeRecursively(children[i], add, type);
            }
        }
    }

    private void toolTipHookBothRecursively(Control c) {
        c.addListener(DWT.MouseDown, hideListener);
        c.addListener(DWT.MouseExit, hideListener);

        if ( auto comp = cast(Composite) c ) {
            Control[] children = comp.getChildren();
            for (int i = 0; i < children.length; i++) {
                toolTipHookBothRecursively(children[i]);
            }
        }
    }

    /**
     * Creates the content area of the the tooltip.
     *
     * @param event
     *            the event that triggered the activation of the tooltip
     * @param parent
     *            the parent of the content area
     * @return the content area created
     */
    protected abstract Composite createToolTipContentArea(Event event,
            Composite parent);

    /**
     * This method is called after a tooltip is hidden.
     * <p>
     * <b>Subclasses may override to clean up requested system resources</b>
     * </p>
     *
     * @param event
     *            event triggered the hiding action (may be <code>null</code>
     *            if event wasn't triggered by user actions directly)
     */
    protected void afterHideToolTip(Event event) {

    }

    /**
     * Set the hide delay.
     *
     * @param hideDelay
     *            the delay before the tooltip is hidden. If <code>0</code>
     *            the tooltip is shown until user moves to other item
     */
    public void setHideDelay(int hideDelay) {
        this.hideDelay = hideDelay;
    }

    /**
     * Set the popup delay.
     *
     * @param popupDelay
     *            the delay before the tooltip is shown to the user. If
     *            <code>0</code> the tooltip is shown immediately
     */
    public void setPopupDelay(int popupDelay) {
        this.popupDelay = popupDelay;
    }

    /**
     * Return if hiding on mouse down is set.
     *
     * @return <code>true</code> if hiding on mouse down in the tool tip is on
     */
    public bool isHideOnMouseDown() {
        return hideOnMouseDown;
    }

    /**
     * If you don't want the tool tip to be hidden when the user clicks inside
     * the tool tip set this to <code>false</code>. You maybe also need to
     * hide the tool tip yourself depending on what you do after clicking in the
     * tooltip (e.g. if you open a new {@link Shell})
     *
     * @param hideOnMouseDown
     *            flag to indicate of tooltip is hidden automatically on mouse
     *            down inside the tool tip
     */
    public void setHideOnMouseDown(bool hideOnMouseDown) {
        // Only needed if there's currently a tooltip active
        if (CURRENT_TOOLTIP !is null && !CURRENT_TOOLTIP.isDisposed()) {
            // Only change if value really changed
            if (hideOnMouseDown !is this.hideOnMouseDown) {
                control.getDisplay().syncExec(new class(hideOnMouseDown) Runnable {
                    bool hideOnMouseDown_;
                    this(bool a){ hideOnMouseDown_=a; }
                    public void run() {
                        if (CURRENT_TOOLTIP !is null
                                && CURRENT_TOOLTIP.isDisposed()) {
                            toolTipHookByTypeRecursively(CURRENT_TOOLTIP,
                                    hideOnMouseDown_, DWT.MouseDown);
                        }
                    }

                });
            }
        }

        this.hideOnMouseDown = hideOnMouseDown;
    }

    /**
     * Hide the currently active tool tip
     */
    public void hide() {
        toolTipHide(CURRENT_TOOLTIP, null);
    }

    private class ToolTipOwnerControlListener : Listener {
        public void handleEvent(Event event) {
            switch (event.type) {
            case DWT.Dispose:
            case DWT.KeyDown:
            case DWT.MouseDown:
            case DWT.MouseMove:
            case DWT.MouseWheel:
                toolTipHide(CURRENT_TOOLTIP, event);
                break;
            case DWT.MouseHover:
                toolTipCreate(event);
                break;
            case DWT.MouseExit:
                /*
                 * Check if the mouse exit happened because we move over the
                 * tooltip
                 */
                if (CURRENT_TOOLTIP !is null && !CURRENT_TOOLTIP.isDisposed()) {
                    if (CURRENT_TOOLTIP.getBounds().contains(
                            control.toDisplay(event.x, event.y))) {
                        break;
                    }
                }

                toolTipHide(CURRENT_TOOLTIP, event);
                break;
            default:
            }
        }
    }

    private class TooltipHideListener : Listener {
        public void handleEvent(Event event) {
            if ( auto c = cast(Control)event.widget ) {

                Shell shell = c.getShell();

                switch (event.type) {
                case DWT.MouseDown:
                    if (isHideOnMouseDown()) {
                        toolTipHide(shell, event);
                    }
                    break;
                case DWT.MouseExit:
                    /*
                     * Give some insets to ensure we get exit informations from
                     * a wider area ;-)
                     */
                    Rectangle rect = shell.getBounds();
                    rect.x += 5;
                    rect.y += 5;
                    rect.width -= 10;
                    rect.height -= 10;

                    if (!rect.contains(c.getDisplay().getCursorLocation())) {
                        toolTipHide(shell, event);
                    }

                    break;
                default:
                }
            }
        }
    }
}
