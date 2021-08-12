/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Roman Dawydkin - bug 55116
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/

module dwtx.jface.window.ApplicationWindow;

import dwtx.jface.window.Window;

// import java.lang.reflect.InvocationTargetException;

import dwt.DWT;
import dwt.custom.BusyIndicator;
import dwt.graphics.Font;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.CoolBar;
import dwt.widgets.Decorations;
import dwt.widgets.Display;
import dwt.widgets.Label;
import dwt.widgets.Layout;
import dwt.widgets.Menu;
import dwt.widgets.Shell;
import dwt.widgets.ToolBar;
import dwtx.core.runtime.NullProgressMonitor;
import dwtx.jface.action.CoolBarManager;
import dwtx.jface.action.ICoolBarManager;
import dwtx.jface.action.IToolBarManager;
import dwtx.jface.action.MenuManager;
import dwtx.jface.action.StatusLineManager;
import dwtx.jface.action.ToolBarManager;
import dwtx.jface.internal.provisional.action.ICoolBarManager2;
import dwtx.jface.internal.provisional.action.IToolBarManager2;
import dwtx.jface.operation.IRunnableContext;
import dwtx.jface.operation.IRunnableWithProgress;
import dwtx.jface.operation.ModalContext;
import dwtx.jface.resource.JFaceResources;

import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;

/**
 * An application window is a high-level "main window", with built-in
 * support for an optional menu bar with standard menus, an optional toolbar,
 * and an optional status line.
 * <p>
 * Creating an application window involves the following steps:
 * <ul>
 *   <li>creating an instance of <code>ApplicationWindow</code>
 *   </li>
 *   <li>assigning the window to a window manager (optional)
 *   </li>
 *   <li>opening the window by calling <code>open</code>
 *   </li>
 * </ul>
 * Only on the last step, when the window is told to open, are
 * the window's shell and widget tree created. When the window is
 * closed, the shell and widget tree are disposed of and are no longer
 * referenced, and the window is automatically removed from its window
 * manager. Like all windows, an application window may be reopened.
 * </p>
 * <p>
 * An application window is also a suitable context in which to perform
 * long-running operations (that is, it implements <code>IRunnableContext</code>).
 * </p>
 */
public class ApplicationWindow : Window, IRunnableContext {

    /**
     * Menu bar manager, or <code>null</code> if none (default).
     *
     * @see #addMenuBar
     */
    private MenuManager menuBarManager = null;

    /**
     * Tool bar manager, or <code>null</code> if none (default).
     *
     * @see #addToolBar
     */
    private IToolBarManager toolBarManager = null;

    /**
     * Status line manager, or <code>null</code> if none (default).
     *
     * @see #addStatusLine
     */
    private StatusLineManager statusLineManager = null;

    /**
     * Cool bar manager, or <code>null</code> if none (default).
     *
     * @see #addCoolBar
     * @since 3.0
     */
    private ICoolBarManager coolBarManager = null;

    /**
     * The seperator between the menu bar and the rest of the window.
     */
    protected Label seperator1;

    /**
     * A flag indicating that an operation is running.
     */
    private bool operationInProgress = false;

    /**
     * Internal application window layout class.
     * This vertical layout supports a tool bar area (fixed size),
     * a separator line, the content area (variable size), and a
     * status line (fixed size).
     */
    /*package*/class ApplicationWindowLayout : Layout {

        static final int VGAP = 2;

        static final int BAR_SIZE = 23;

        protected override Point computeSize(Composite composite, int wHint, int hHint,
                bool flushCache) {
            if (wHint !is DWT.DEFAULT && hHint !is DWT.DEFAULT) {
                return new Point(wHint, hHint);
            }

            Point result = new Point(0, 0);
            Control[] ws = composite.getChildren();
            for (int i = 0; i < ws.length; i++) {
                Control w = ws[i];

                bool hide = false;
                if (getToolBarControl() is w) {
                    if (!toolBarChildrenExist()) {
                        hide = true;
                        result.y += BAR_SIZE; // REVISIT
                    }
                } else if (getCoolBarControl() is w) {
                    if (!coolBarChildrenExist()) {
                        hide = true;
                        result.y += BAR_SIZE;
                    }
                } else if (statusLineManager !is null
                        && statusLineManager.getControl() is w) {
                } else if (i > 0) { /* we assume this window is contents */
                    hide = false;
                }

                if (!hide) {
                    Point e = w.computeSize(wHint, hHint, flushCache);
                    result.x = Math.max(result.x, e.x);
                    result.y += e.y + VGAP;
                }
            }

            if (wHint !is DWT.DEFAULT) {
                result.x = wHint;
            }
            if (hHint !is DWT.DEFAULT) {
                result.y = hHint;
            }
            return result;
        }

        protected override void layout(Composite composite, bool flushCache) {
            Rectangle clientArea = composite.getClientArea();

            Control[] ws = composite.getChildren();

            // Lay out the separator, the tool bar control, the cool bar control, the status line, and the page composite.
            // The following code assumes that the page composite is the last child, and that there are no unexpected other controls.

            for (int i = 0; i < ws.length; i++) {
                Control w = ws[i];

                if (w is seperator1) { // Separator
                    Point e = w.computeSize(DWT.DEFAULT, DWT.DEFAULT,
                            flushCache);
                    w.setBounds(clientArea.x, clientArea.y, clientArea.width,
                            e.y);
                    clientArea.y += e.y;
                    clientArea.height -= e.y;
                } else if (getToolBarControl() is w) {
                    if (toolBarChildrenExist()) {
                        Point e = w.computeSize(DWT.DEFAULT, DWT.DEFAULT,
                                flushCache);
                        w.setBounds(clientArea.x, clientArea.y,
                                clientArea.width, e.y);
                        clientArea.y += e.y + VGAP;
                        clientArea.height -= e.y + VGAP;
                    }
                } else if (getCoolBarControl() is w) {
                    if (coolBarChildrenExist()) {
                        Point e = w.computeSize(clientArea.width, DWT.DEFAULT,
                                flushCache);
                        w.setBounds(clientArea.x, clientArea.y,
                                clientArea.width, e.y);
                        clientArea.y += e.y + VGAP;
                        clientArea.height -= e.y + VGAP;
                    }
                } else if (statusLineManager !is null
                        && statusLineManager.getControl() is w) {
                    Point e = w.computeSize(DWT.DEFAULT, DWT.DEFAULT,
                            flushCache);
                    w.setBounds(clientArea.x, clientArea.y + clientArea.height
                            - e.y, clientArea.width, e.y);
                    clientArea.height -= e.y + VGAP;
                } else {
                    w.setBounds(clientArea.x, clientArea.y + VGAP,
                            clientArea.width, clientArea.height - VGAP);
                }
            }
        }
    }

    /**
     * Return the top seperator.
     * @return Label
     */
    protected Label getSeperator1() {
        return seperator1;
    }

    /**
     * Create an application window instance, whose shell will be created under the
     * given parent shell.
     * Note that the window will have no visual representation (no widgets)
     * until it is told to open. By default, <code>open</code> does not block.
     *
     * @param parentShell the parent shell, or <code>null</code> to create a top-level shell
     */
    public this(Shell parentShell) {
        super(parentShell);
    }

    /**
     * Configures this window to have a menu bar.
     * Does nothing if it already has one.
     * This method must be called before this window's shell is created.
     */
    protected void addMenuBar() {
        if ((getShell() is null) && (menuBarManager is null)) {
            menuBarManager = createMenuManager();
        }
    }

    /**
     * Configures this window to have a status line.
     * Does nothing if it already has one.
     * This method must be called before this window's shell is created.
     */
    protected void addStatusLine() {
        if ((getShell() is null) && (statusLineManager is null)) {
            statusLineManager = createStatusLineManager();
        }
    }

    /**
     * Configures this window to have a tool bar.
     * Does nothing if it already has one.
     * This method must be called before this window's shell is created.
     * @param style swt style bits used to create the Toolbar
     * @see ToolBarManager#ToolBarManager(int)
     * @see ToolBar for style bits
     */
    protected void addToolBar(int style) {
        if ((getShell() is null) && (toolBarManager is null)
                && (coolBarManager is null)) {
            toolBarManager = createToolBarManager2(style);
        }
    }

    /**
     * Configures this window to have a cool bar.
     * Does nothing if it already has one.
     * This method must be called before this window's shell is created.
     *
     * @param style the cool bar style
     * @since 3.0
     */
    protected void addCoolBar(int style) {
        if ((getShell() is null) && (toolBarManager is null)
                && (coolBarManager is null)) {
            coolBarManager = createCoolBarManager2(style);
        }
    }

    /* (non-Javadoc)
     * Method declared on Window.
     */
    protected override bool canHandleShellCloseEvent() {
        return super.canHandleShellCloseEvent() && !operationInProgress;
    }

    /* (non-Javadoc)
     * Method declared on Window.
     */
    public override bool close() {
        if (operationInProgress) {
            return false;
        }

        if (super.close()) {
            if (menuBarManager !is null) {
                menuBarManager.dispose();
                menuBarManager = null;
            }
            if (toolBarManager !is null) {
                if (cast(IToolBarManager2)toolBarManager ) {
                    (cast(IToolBarManager2) toolBarManager).dispose();
                } else if (cast(ToolBarManager)toolBarManager ) {
                    (cast(ToolBarManager) toolBarManager).dispose();
                }
                toolBarManager = null;
            }
            if (statusLineManager !is null) {
                statusLineManager.dispose();
                statusLineManager = null;
            }
            if (coolBarManager !is null) {
                if (cast(ICoolBarManager2)coolBarManager ) {
                    (cast(ICoolBarManager2) coolBarManager).dispose();
                } else if (cast(CoolBarManager)coolBarManager ) {
                    (cast(CoolBarManager) coolBarManager).dispose();
                }
                coolBarManager = null;
            }
            return true;
        }
        return false;
    }

    /**
     * Extends the super implementation by creating the trim widgets using <code>createTrimWidgets</code>.
     */
    protected override void configureShell(Shell shell) {

        super.configureShell(shell);

        createTrimWidgets(shell);
    }

    /**
     * Creates the trim widgets around the content area.
     *
     * @param shell the shell
     * @since 3.0
     */
    protected void createTrimWidgets(Shell shell) {
        if (menuBarManager !is null) {
            menuBarManager.updateAll(true);
            shell.setMenuBar(menuBarManager.createMenuBar(cast(Decorations) shell));
        }

        if (showTopSeperator()) {
            seperator1 = new Label(shell, DWT.SEPARATOR | DWT.HORIZONTAL);
        }

        // will create either a cool bar or a tool bar
        createToolBarControl(shell);
        createCoolBarControl(shell);
        createStatusLine(shell);
    }

    /* (non-Javadoc)
     * @see dwtx.jface.window.Window#getLayout()
     */
    protected override Layout getLayout() {
        return new ApplicationWindowLayout();
    }

    /**
     * Returns whether to show a top separator line between the menu bar
     * and the rest of the window contents.  On some platforms such as the Mac,
     * the menu is separated from the main window already, so a separator line
     * is not desired.
     *
     * @return <code>true</code> to show the top separator, <code>false</code>
     *   to not show it
     * @since 3.0
     */
    protected bool showTopSeperator() {
        return !"carbon".equals(DWT.getPlatform()); //$NON-NLS-1$
    }

    /**
     * Create the status line if required.
     * @param shell
     */
    protected void createStatusLine(Shell shell) {
        if (statusLineManager !is null) {
            statusLineManager.createControl(shell, DWT.NONE);
        }
    }

    /**
     * Returns a new menu manager for the window.
     * <p>
     * Subclasses may override this method to customize the menu manager.
     * </p>
     * @return a menu manager
     */
    protected MenuManager createMenuManager() {
        return new MenuManager();
    }

    /**
     * Returns a new status line manager for the window.
     * <p>
     * Subclasses may override this method to customize the status line manager.
     * </p>
     * @return a status line manager
     */
    protected StatusLineManager createStatusLineManager() {
        return new StatusLineManager();
    }

    /**
     * Returns a new tool bar manager for the window.
     * <p>
     * Subclasses may override this method to customize the tool bar manager.
     * </p>
     * @param style swt style bits used to create the Toolbar
     *
     * @return a tool bar manager
     * @see ToolBarManager#ToolBarManager(int)
     * @see ToolBar for style bits
     */
    protected ToolBarManager createToolBarManager(int style) {
        return new ToolBarManager(style);
    }

    /**
     * Returns a new tool bar manager for the window.
     * <p>
     * By default this method calls <code>createToolBarManager</code>.  Subclasses
     * may override this method to provide an alternative implementation for the
     * tool bar manager.
     * </p>
     *
     * @param style swt style bits used to create the Toolbar
     *
     * @return a tool bar manager
     * @since 3.2
     * @see #createToolBarManager(int)
     */
    protected IToolBarManager createToolBarManager2(int style) {
        return createToolBarManager(style);
    }

    /**
     * Returns a new cool bar manager for the window.
     * <p>
     * Subclasses may override this method to customize the cool bar manager.
     * </p>
     *
     * @param style swt style bits used to create the Coolbar
     *
     * @return a cool bar manager
     * @since 3.0
     * @see CoolBarManager#CoolBarManager(int)
     * @see CoolBar for style bits
     */
    protected CoolBarManager createCoolBarManager(int style) {
        return new CoolBarManager(style);
    }

    /**
     * Returns a new cool bar manager for the window.
     * <p>
     * By default this method calls <code>createCoolBarManager</code>.  Subclasses
     * may override this method to provide an alternative implementation for the
     * cool bar manager.
     * </p>
     *
     * @param style swt style bits used to create the Coolbar
     *
     * @return a cool bar manager
     * @since 3.2
     * @see #createCoolBarManager(int)
     */
    protected ICoolBarManager createCoolBarManager2(int style) {
        return createCoolBarManager(style);
    }

    /**
     * Creates the control for the tool bar manager.
     * <p>
     * Subclasses may override this method to customize the tool bar manager.
     * </p>
     * @param parent the parent used for the control
     * @return a Control
     */
    protected Control createToolBarControl(Composite parent) {
        if (toolBarManager !is null) {
            if (cast(IToolBarManager2)toolBarManager ) {
                return (cast(IToolBarManager2) toolBarManager).createControl2(parent);
            }
            if (cast(ToolBarManager)toolBarManager ) {
                return (cast(ToolBarManager) toolBarManager).createControl(parent);
            }
        }
        return null;
    }

    /**
     * Creates the control for the cool bar manager.
     * <p>
     * Subclasses may override this method to customize the cool bar manager.
     * </p>
     * @param composite the parent used for the control
     *
     * @return an instance of <code>CoolBar</code>
     * @since 3.0
     */
    protected Control createCoolBarControl(Composite composite) {
        if (coolBarManager !is null) {
            if (cast(ICoolBarManager2)coolBarManager ) {
                return (cast(ICoolBarManager2) coolBarManager).createControl2(composite);
            }
            if (cast(CoolBarManager)coolBarManager ) {
                return (cast(CoolBarManager) coolBarManager).createControl(composite);
            }
        }
        return null;
    }

    /**
     * Returns the default font used for this window.
     * <p>
     * The default implementation of this framework method
     * obtains the symbolic name of the font from the
     * <code>getSymbolicFontName</code> framework method
     * and retrieves this font from JFace's font
     * registry using <code>JFaceResources.getFont</code>.
     * Subclasses may override to use a different registry,
     * etc.
     * </p>
     *
     * @return the default font, or <code>null</code> if none
     */
    protected Font getFont() {
        return JFaceResources.getFont(getSymbolicFontName());
    }

    /**
     * Returns the menu bar manager for this window (if it has one).
     *
     * @return the menu bar manager, or <code>null</code> if
     *   this window does not have a menu bar
     * @see #addMenuBar()
     */
    public MenuManager getMenuBarManager() {
        return menuBarManager;
    }

    /**
     * Returns the status line manager for this window (if it has one).
     *
     * @return the status line manager, or <code>null</code> if
     *   this window does not have a status line
     * @see #addStatusLine
     */
    protected StatusLineManager getStatusLineManager() {
        return statusLineManager;
    }

    /**
     * Returns the symbolic font name of the font to be
     * used to display text in this window.
     * This is not recommended and is included for backwards
     * compatability.
     * It is recommended to use the default font provided by
     * DWT (that is, do not set the font).
     *
     * @return the symbolic font name
     */
    public String getSymbolicFontName() {
        return JFaceResources.TEXT_FONT;
    }

    /**
     * Returns the tool bar manager for this window (if it has one).
     *
     * @return the tool bar manager, or <code>null</code> if
     *   this window does not have a tool bar
     * @see #addToolBar(int)
     */
    public ToolBarManager getToolBarManager() {
        if (cast(ToolBarManager)toolBarManager ) {
            return cast(ToolBarManager)toolBarManager;
        }
        return null;
    }

    /**
     * Returns the tool bar manager for this window (if it has one).
     *
     * @return the tool bar manager, or <code>null</code> if
     *   this window does not have a tool bar
     * @see #addToolBar(int)
     * @since 3.2
     */
    public IToolBarManager getToolBarManager2() {
        return toolBarManager;
    }

    /**
     * Returns the cool bar manager for this window.
     *
     * @return the cool bar manager, or <code>null</code> if
     *   this window does not have a cool bar
     * @see #addCoolBar(int)
     * @since 3.0
     */
    public CoolBarManager getCoolBarManager() {
        if (cast(CoolBarManager)coolBarManager ) {
            return cast(CoolBarManager)coolBarManager;
        }
        return null;
    }

    /**
     * Returns the cool bar manager for this window.
     *
     * @return the cool bar manager, or <code>null</code> if
     *   this window does not have a cool bar
     * @see #addCoolBar(int)
     * @since 3.2
     */
    public ICoolBarManager getCoolBarManager2() {
        return coolBarManager;
    }

    /**
     * Returns the control for the window's toolbar.
     * <p>
     * Subclasses may override this method to customize the tool bar manager.
     * </p>
     * @return a Control
     */
    protected Control getToolBarControl() {
        if (toolBarManager !is null) {
            if (cast(IToolBarManager2)toolBarManager ) {
                return (cast(IToolBarManager2) toolBarManager).getControl2();
            }
            if (cast(ToolBarManager)toolBarManager ) {
                return (cast(ToolBarManager) toolBarManager).getControl();
            }
        }
        return null;
    }

    /**
     * Returns the control for the window's cool bar.
     * <p>
     * Subclasses may override this method to customize the cool bar manager.
     * </p>
     *
     * @return an instance of <code>CoolBar</code>
     * @since 3.0
     */
    protected Control getCoolBarControl() {
        if (coolBarManager !is null) {
            if (cast(ICoolBarManager2)coolBarManager ) {
                return (cast(ICoolBarManager2) coolBarManager).getControl2();
            }
            if (cast(CoolBarManager)coolBarManager ) {
                return (cast(CoolBarManager) coolBarManager).getControl();
            }
        }
        return null;
    }

    /**
     * This implementation of IRunnableContext#run(bool, bool,
     * IRunnableWithProgress) blocks until the runnable has been run,
     * regardless of the value of <code>fork</code>.
     * It is recommended that <code>fork</code> is set to
     * true in most cases. If <code>fork</code> is set to <code>false</code>,
     * the runnable will run in the UI thread and it is the runnable's
     * responsibility to call <code>Display.readAndDispatch()</code>
     * to ensure UI responsiveness.
     */
    public void run(bool fork, bool cancelable,
            IRunnableWithProgress runnable) {
        try {
            operationInProgress = true;
            StatusLineManager mgr = getStatusLineManager();
            if (mgr is null) {
                runnable.run(new NullProgressMonitor());
                return;
            }
            bool cancelWasEnabled = mgr.isCancelEnabled();

            Control contents = getContents();
            Display display = contents.getDisplay();
            Shell shell = getShell();
            bool contentsWasEnabled = contents.getEnabled();
            MenuManager manager = getMenuBarManager();
            Menu menuBar = null;
            if (manager !is null) {
                menuBar = manager.getMenu();
                manager = null;
            }
            bool menuBarWasEnabled = false;
            if (menuBar !is null) {
                menuBarWasEnabled = menuBar.getEnabled();
            }

            Control toolbarControl = getToolBarControl();
            bool toolbarWasEnabled = false;
            if (toolbarControl !is null) {
                toolbarWasEnabled = toolbarControl.getEnabled();
            }

            Control coolbarControl = getCoolBarControl();
            bool coolbarWasEnabled = false;
            if (coolbarControl !is null) {
                coolbarWasEnabled = coolbarControl.getEnabled();
            }

            // Disable the rest of the shells on the current display
            Shell[] shells = display.getShells();
            bool[] enabled = new bool[shells.length];
            for (int i = 0; i < shells.length; i++) {
                Shell current = shells[i];
                if (current is shell) {
                    continue;
                }
                if (current !is null && !current.isDisposed()) {
                    enabled[i] = current.getEnabled();
                    current.setEnabled(false);
                }
            }

            Control currentFocus = display.getFocusControl();
            try {
                contents.setEnabled(false);
                if (menuBar !is null) {
                    menuBar.setEnabled(false);
                }
                if (toolbarControl !is null) {
                    toolbarControl.setEnabled(false);
                }
                if (coolbarControl !is null) {
                    coolbarControl.setEnabled(false);
                }
                mgr.setCancelEnabled(cancelable);
                Exception[1] holder;
                BusyIndicator.showWhile(display, new class(fork,runnable,mgr,display) Runnable {
                    bool fork_;
                    IRunnableWithProgress runnable_;
                    StatusLineManager mgr_;
                    Display display_;
                    this(bool f,IRunnableWithProgress a,StatusLineManager b,Display c){
                        fork_=f;
                        runnable_=a;
                        mgr_=b;
                        display_=c;
                    }
                    public void run() {
                        try {
                            ModalContext.run(runnable_, fork_, mgr_
                                    .getProgressMonitor(), display_);
                        } catch (InvocationTargetException ite) {
                            holder[0] = ite;
                        } catch (InterruptedException ie) {
                            holder[0] = ie;
                        }
                    }
                });

                if (holder[0] !is null) {
                    if (cast(InvocationTargetException)holder[0] ) {
                        throw cast(InvocationTargetException) holder[0];
                    } else if (cast(InterruptedException)holder[0] ) {
                        throw cast(InterruptedException) holder[0];
                    }
                }
            } finally {
                operationInProgress = false;
                // Enable the rest of the shells on the current display
                for (int i = 0; i < shells.length; i++) {
                    Shell current = shells[i];
                    if (current is shell) {
                        continue;
                    }
                    if (current !is null && !current.isDisposed()) {
                        current.setEnabled(enabled[i]);
                    }
                }
                if (!contents.isDisposed()) {
                    contents.setEnabled(contentsWasEnabled);
                }
                if (menuBar !is null && !menuBar.isDisposed()) {
                    menuBar.setEnabled(menuBarWasEnabled);
                }
                if (toolbarControl !is null && !toolbarControl.isDisposed()) {
                    toolbarControl.setEnabled(toolbarWasEnabled);
                }
                if (coolbarControl !is null && !coolbarControl.isDisposed()) {
                    coolbarControl.setEnabled(coolbarWasEnabled);
                }
                mgr.setCancelEnabled(cancelWasEnabled);
                if (currentFocus !is null && !currentFocus.isDisposed()) {
                    // It's necessary to restore focus after reenabling the controls
                    // because disabling them causes focus to jump elsewhere.
                    // Use forceFocus rather than setFocus to avoid DWT's
                    // search for children which can take focus, so focus
                    // ends up back on the actual control that previously had it.
                    currentFocus.forceFocus();
                }
            }
        } finally {
            operationInProgress = false;
        }
    }

    /**
     * Sets or clears the message displayed in this window's status
     * line (if it has one). This method has no effect if the
     * window does not have a status line.
     *
     * @param message the status message, or <code>null</code> to clear it
     */
    public void setStatus(String message) {
        if (statusLineManager !is null) {
            statusLineManager.setMessage(message);
        }
    }

    /**
     * Returns whether or not children exist for the Application Window's
     * toolbar control.
     * <p>
     * @return bool true if children exist, false otherwise
     */
    protected bool toolBarChildrenExist() {
        Control toolControl = getToolBarControl();
        if (cast(ToolBar)toolControl ) {
            return (cast(ToolBar) toolControl).getItemCount() > 0;
        }
        return false;
    }

    /**
     * Returns whether or not children exist for this application window's
     * cool bar control.
     *
     * @return bool true if children exist, false otherwise
     * @since 3.0
     */
    protected bool coolBarChildrenExist() {
        Control coolControl = getCoolBarControl();
        if (cast(CoolBar)coolControl ) {
            return (cast(CoolBar) coolControl).getItemCount() > 0;
        }
        return false;
    }

}
