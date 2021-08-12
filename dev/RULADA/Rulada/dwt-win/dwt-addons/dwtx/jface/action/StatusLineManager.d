/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module dwtx.jface.action.StatusLineManager;

import dwtx.jface.action.ContributionManager;
import dwtx.jface.action.IStatusLineManager;
import dwtx.jface.action.GroupMarker;
import dwtx.jface.action.StatusLine;
import dwtx.jface.action.IContributionManager;
import dwtx.jface.action.IContributionItem;

import dwt.DWT;
import dwt.graphics.Image;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwtx.core.runtime.IProgressMonitor;
import dwtx.core.runtime.IProgressMonitorWithBlocking;
import dwtx.core.runtime.IStatus;

import dwt.dwthelper.utils;

/**
 * A status line manager is a contribution manager which realizes itself and its items
 * in a status line control.
 * <p>
 * This class may be instantiated; it may also be subclassed if a more
 * sophisticated layout is required.
 * </p>
 */
public class StatusLineManager : ContributionManager,
        IStatusLineManager {

    /**
     * Identifier of group marker used to position contributions at the beginning
     * of the status line.
     *
     * @since 3.0
     */
    public static const String BEGIN_GROUP = "BEGIN_GROUP"; //$NON-NLS-1$

    /**
     * Identifier of group marker used to position contributions in the middle
     * of the status line.
     *
     * @since 3.0
     */
    public static const String MIDDLE_GROUP = "MIDDLE_GROUP"; //$NON-NLS-1$

    /**
     * Identifier of group marker used to position contributions at the end
     * of the status line.
     *
     * @since 3.0
     */
    public static const String END_GROUP = "END_GROUP"; //$NON-NLS-1$

    /**
     * The status line control; <code>null</code> before
     * creation and after disposal.
     */
    private Composite statusLine = null;

    /**
     * Creates a new status line manager.
     * Use the <code>createControl</code> method to create the
     * status line control.
     */
    public this() {
        add(new GroupMarker(BEGIN_GROUP));
        add(new GroupMarker(MIDDLE_GROUP));
        add(new GroupMarker(END_GROUP));
    }

    /**
     * Creates and returns this manager's status line control.
     * Does not create a new control if one already exists.
     * <p>
     * Note: Since 3.0 the return type is <code>Control</code>.  Before 3.0, the return type was
     *   the package-private class <code>StatusLine</code>.
     * </p>
     *
     * @param parent the parent control
     * @return the status line control
     */
    public Control createControl(Composite parent) {
        return createControl(parent, DWT.NONE);
    }

    /**
     * Creates and returns this manager's status line control.
     * Does not create a new control if one already exists.
     *
     * @param parent the parent control
     * @param style the style for the control
     * @return the status line control
     * @since 3.0
     */
    public Control createControl(Composite parent, int style) {
        if (!statusLineExist() && parent !is null) {
            statusLine = new StatusLine(parent, style);
            update(false);
        }
        return statusLine;
    }

    /**
     * Disposes of this status line manager and frees all allocated DWT resources.
     * Notifies all contribution items of the dispose. Note that this method does
     * not clean up references between this status line manager and its associated
     * contribution items. Use <code>removeAll</code> for that purpose.
     */
    public void dispose() {
        if (statusLineExist()) {
            statusLine.dispose();
        }
        statusLine = null;

        IContributionItem items[] = getItems();
        for (int i = 0; i < items.length; i++) {
            items[i].dispose();
        }
    }

    /**
     * Returns the control used by this StatusLineManager.
     *
     * @return the control used by this manager
     */
    public Control getControl() {
        return statusLine;
    }

    /**
     * Returns the progress monitor delegate. Override this method
     * to provide your own object used to handle progress.
     *
     * @return the IProgressMonitor delegate
     * @since 3.0
     */
    protected IProgressMonitor getProgressMonitorDelegate() {
        return cast(IProgressMonitor) getControl();
    }

    /*
     * (non-Javadoc)
     * Method declared on IStatusLineManager
     */
    public IProgressMonitor getProgressMonitor() {

        return new class(getProgressMonitorDelegate()) IProgressMonitorWithBlocking {

            IProgressMonitor progressDelegate;
            this(IProgressMonitor a){
                progressDelegate = a;
            }

            /* (non-Javadoc)
             * @see dwtx.core.runtime.IProgressMonitor#beginTask(java.lang.String, int)
             */
            public void beginTask(String name, int totalWork) {
                progressDelegate.beginTask(name, totalWork);

            }

            /* (non-Javadoc)
             * @see dwtx.core.runtime.IProgressMonitor#done()
             */
            public void done() {
                progressDelegate.done();
            }

            /* (non-Javadoc)
             * @see dwtx.core.runtime.IProgressMonitor#internalWorked(double)
             */
            public void internalWorked(double work) {
                progressDelegate.internalWorked(work);

            }

            /* (non-Javadoc)
             * @see dwtx.core.runtime.IProgressMonitor#isCanceled()
             */
            public bool isCanceled() {
                return progressDelegate.isCanceled();
            }

            /* (non-Javadoc)
             * @see dwtx.core.runtime.IProgressMonitor#setCanceled(bool)
             */
            public void setCanceled(bool value) {
                //Don't bother updating for disposed status
                if (statusLine.isDisposed()) {
                    return;
                }
                progressDelegate.setCanceled(value);

            }

            /* (non-Javadoc)
             * @see dwtx.core.runtime.IProgressMonitor#setTaskName(java.lang.String)
             */
            public void setTaskName(String name) {
                progressDelegate.setTaskName(name);

            }

            /* (non-Javadoc)
             * @see dwtx.core.runtime.IProgressMonitor#subTask(java.lang.String)
             */
            public void subTask(String name) {
                progressDelegate.subTask(name);

            }

            /* (non-Javadoc)
             * @see dwtx.core.runtime.IProgressMonitor#worked(int)
             */
            public void worked(int work) {
                progressDelegate.worked(work);
            }

            /* (non-Javadoc)
             * @see dwtx.core.runtime.IProgressMonitorWithBlocking#clearBlocked()
             */
            public void clearBlocked() {
                //Do nothing here as we let the modal context handle it
            }

            /* (non-Javadoc)
             * @see dwtx.core.runtime.IProgressMonitorWithBlocking#setBlocked(dwtx.core.runtime.IStatus)
             */
            public void setBlocked(IStatus reason) {
                //          Do nothing here as we let the modal context handle it
            }
        };
    }

    /* (non-Javadoc)
     * Method declared on IStatueLineManager
     */
    public bool isCancelEnabled() {
        return statusLineExist() && (cast(StatusLine) statusLine).isCancelEnabled();
    }

    /* (non-Javadoc)
     * Method declared on IStatueLineManager
     */
    public void setCancelEnabled(bool enabled) {
        if (statusLineExist()) {
            (cast(StatusLine) statusLine).setCancelEnabled(enabled);
        }
    }

    /* (non-Javadoc)
     * Method declared on IStatusLineManager.
     */
    public void setErrorMessage(String message) {
        if (statusLineExist()) {
            (cast(StatusLine) statusLine).setErrorMessage(message);
        }
    }

    /* (non-Javadoc)
     * Method declared on IStatusLineManager.
     */
    public void setErrorMessage(Image image, String message) {
        if (statusLineExist()) {
            (cast(StatusLine) statusLine).setErrorMessage(image, message);
        }
    }

    /* (non-Javadoc)
     * Method declared on IStatusLineManager.
     */
    public void setMessage(String message) {
        if (statusLineExist()) {
            (cast(StatusLine) statusLine).setMessage(message);
        }
    }

    /* (non-Javadoc)
     * Method declared on IStatusLineManager.
     */
    public void setMessage(Image image, String message) {
        if (statusLineExist()) {
            (cast(StatusLine) statusLine).setMessage(image, message);
        }
    }

    /**
     * Returns whether the status line control is created
     * and not disposed.
     *
     * @return <code>true</code> if the control is created
     *  and not disposed, <code>false</code> otherwise
     */
    private bool statusLineExist() {
        return statusLine !is null && !statusLine.isDisposed();
    }

    /* (non-Javadoc)
     * Method declared on IContributionManager.
     */
    public void update(bool force) {

        //bool DEBUG= false;

        if (isDirty() || force) {

            if (statusLineExist()) {
                statusLine.setRedraw(false);

                // NOTE: the update algorithm is non-incremental.
                // An incremental algorithm requires that DWT items can be created in the middle of the list
                // but the ContributionItem.fill(Composite) method used here does not take an index, so this
                // is not possible.

                Control ws[] = statusLine.getChildren();
                for (int i = 0; i < ws.length; i++) {
                    Control w = ws[i];
                    Object data = w.getData();
                    if (cast(IContributionItem) data ) {
                        w.dispose();
                    }
                }

                int oldChildCount = statusLine.getChildren().length;
                IContributionItem[] items = getItems();
                for (int i = 0; i < items.length; ++i) {
                    IContributionItem ci = items[i];
                    if (ci.isVisible()) {
                        ci.fill(statusLine);
                        // associate controls with contribution item
                        Control[] newChildren = statusLine.getChildren();
                        for (int j = oldChildCount; j < newChildren.length; j++) {
                            newChildren[j].setData(cast(Object)ci);
                        }
                        oldChildCount = newChildren.length;
                    }
                }

                setDirty(false);

                statusLine.layout();
                statusLine.setRedraw(true);
            }
        }
    }

}
