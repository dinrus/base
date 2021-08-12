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
module dwtx.jface.dialogs.ProgressMonitorDialog;

import dwtx.jface.dialogs.IconAndMessageDialog;
import dwtx.jface.dialogs.IDialogConstants;
import dwtx.jface.dialogs.ProgressIndicator;

// import java.lang.reflect.InvocationTargetException;

import dwt.DWT;
import dwt.graphics.Cursor;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.layout.GridData;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Event;
import dwt.widgets.Label;
import dwt.widgets.Listener;
import dwt.widgets.Shell;
import dwtx.core.runtime.IProgressMonitor;
import dwtx.core.runtime.IProgressMonitorWithBlocking;
import dwtx.core.runtime.IStatus;
import dwtx.jface.operation.IRunnableContext;
import dwtx.jface.operation.IRunnableWithProgress;
import dwtx.jface.operation.ModalContext;
import dwtx.jface.resource.JFaceResources;

import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;

/**
 * A modal dialog that displays progress during a long running operation.
 * <p>
 * This concrete dialog class can be instantiated as is, or further subclassed
 * as required.
 * </p>
 * <p>
 * Typical usage is:
 *
 * <pre>
 *
 *
 *    try {
 *       IRunnableWithProgress op = ...;
 *       new ProgressMonitorDialog(activeShell).run(true, true, op);
 *    } catch (InvocationTargetException e) {
 *       // handle exception
 *    } catch (InterruptedException e) {
 *       // handle cancelation
 *    }
 *
 *
 * </pre>
 *
 * </p>
 * <p>
 * Note that the ProgressMonitorDialog is not intended to be used with multiple
 * runnables - this dialog should be discarded after completion of one
 * IRunnableWithProgress and a new one instantiated for use by a second or
 * sebsequent IRunnableWithProgress to ensure proper initialization.
 * </p>
 * <p>
 * Note that not forking the process will result in it running in the UI which
 * may starve the UI. The most obvious symptom of this problem is non
 * responsiveness of the cancel button. If you are running within the UI Thread
 * you should do the bulk of your work in another Thread to prevent starvation.
 * It is recommended that fork is set to true in most cases.
 * </p>
 */
public class ProgressMonitorDialog : IconAndMessageDialog,
        IRunnableContext {
    /**
     * Name to use for task when normal task name is empty string.
     */
    private static String DEFAULT_TASKNAME;

    static this() {
        DEFAULT_TASKNAME = JFaceResources
            .getString("ProgressMonitorDialog.message"); //$NON-NLS-1$
    }
    /**
     * Constants for label and monitor size
     */
    private static int LABEL_DLUS = 21;

    private static int BAR_DLUS = 9;

    /**
     * The progress indicator control.
     */
    protected ProgressIndicator progressIndicator;

    /**
     * The label control for the task. Kept for backwards compatibility.
     */
    protected Label taskLabel;

    /**
     * The label control for the subtask.
     */
    protected Label subTaskLabel;

    /**
     * The Cancel button control.
     */
    protected Button cancel;

    /**
     * Indicates whether the Cancel button is to be shown.
     */
    protected bool operationCancelableState = false;

    /**
     * Indicates whether the Cancel button is to be enabled.
     */
    protected bool enableCancelButton;

    /**
     * The progress monitor.
     */
    private ProgressMonitor progressMonitor;

    /**
     * The name of the current task (used by ProgressMonitor).
     */
    private String task;

    /**
     * The nesting depth of currently running runnables.
     */
    private int nestingDepth;

    /**
     * The cursor used in the cancel button;
     */
    protected Cursor arrowCursor;

    /**
     * The cursor used in the shell;
     */
    private Cursor waitCursor;

    /**
     * Flag indicating whether to open or merely create the dialog before run.
     */
    private bool openOnRun = true;

    /**
     * Internal progress monitor implementation.
     */
    private class ProgressMonitor : IProgressMonitorWithBlocking {
        private String fSubTask = "";//$NON-NLS-1$

        private bool fIsCanceled;

        /**
         * is the process forked
         */
        protected bool forked = false;

        /**
         * is locked
         */
        protected bool locked = false;

        public void beginTask(String name, int totalWork) {
            if (progressIndicator.isDisposed()) {
                return;
            }
            if (name is null) {
                task = "";//$NON-NLS-1$
            } else {
                task = name;
            }
            String s = task;
            if (s.length <= 0) {
                s = DEFAULT_TASKNAME;
            }
            setMessage(s, false);
            if (!forked) {
                update();
            }
            if (totalWork is UNKNOWN) {
                progressIndicator.beginAnimatedTask();
            } else {
                progressIndicator.beginTask(totalWork);
            }
        }

        public void done() {
            if (!progressIndicator.isDisposed()) {
                progressIndicator.sendRemainingWork();
                progressIndicator.done();
            }
        }

        public void setTaskName(String name) {
            if (name is null) {
                task = "";//$NON-NLS-1$
            } else {
                task = name;
            }
            String s = task;
            if (s.length <= 0) {
                s = DEFAULT_TASKNAME;
            }
            setMessage(s, false);
            if (!forked) {
                update();
            }
        }

        public bool isCanceled() {
            return fIsCanceled;
        }

        public void setCanceled(bool b) {
            fIsCanceled = b;
            if (locked) {
                clearBlocked();
            }
        }

        public void subTask(String name) {
            if (subTaskLabel.isDisposed()) {
                return;
            }
            if (name is null) {
                fSubTask = "";//$NON-NLS-1$
            } else {
                fSubTask = name;
            }
            subTaskLabel.setText(shortenText(fSubTask, subTaskLabel));
            if (!forked) {
                subTaskLabel.update();
            }
        }

        public void worked(int work) {
            internalWorked(work);
        }

        public void internalWorked(double work) {
            if (!progressIndicator.isDisposed()) {
                progressIndicator.worked(work);
            }
        }

        /*
         * (non-Javadoc)
         *
         * @see dwtx.core.runtime.IProgressMonitorWithBlocking#clearBlocked()
         */
        public void clearBlocked() {
            if (getShell().isDisposed())
                return;
            locked = false;
            updateForClearBlocked();
        }

        /*
         * (non-Javadoc)
         *
         * @see dwtx.core.runtime.IProgressMonitorWithBlocking#setBlocked(dwtx.core.runtime.IStatus)
         */
        public void setBlocked(IStatus reason) {
            if (getShell().isDisposed())
                return;
            locked = true;
            updateForSetBlocked(reason);
        }
    }

    /**
     * Clear blocked state from the receiver.
     */
    protected void updateForClearBlocked() {
        progressIndicator.showNormal();
        setMessage(task, true);
        imageLabel.setImage(getImage());

    }

    /**
     * Set blocked state from the receiver.
     *
     * @param reason
     *            IStatus that gives the details
     */
    protected void updateForSetBlocked(IStatus reason) {
        progressIndicator.showPaused();
        setMessage(reason.getMessage(), true);
        imageLabel.setImage(getImage());

    }

    /**
     * Creates a progress monitor dialog under the given shell. The dialog has a
     * standard title and no image. <code>open</code> is non-blocking.
     *
     * @param parent
     *            the parent shell, or <code>null</code> to create a top-level
     *            shell
     */
    public this(Shell parent) {
        progressMonitor = new ProgressMonitor();
        super(parent);
        // no close button on the shell style
        if (isResizable()) {
            setShellStyle(getDefaultOrientation() | DWT.BORDER | DWT.TITLE
                    | DWT.APPLICATION_MODAL | DWT.RESIZE | DWT.MAX);
        } else {
            setShellStyle(getDefaultOrientation() | DWT.BORDER | DWT.TITLE
                    | DWT.APPLICATION_MODAL);
        }
        setBlockOnOpen(false);
    }

    /**
     * Enables the cancel button (asynchronously).
     *
     * @param b
     *            The state to set the button to.
     */
    private void asyncSetOperationCancelButtonEnabled(bool b) {
        if (getShell() !is null) {
            getShell().getDisplay().asyncExec(new class Runnable {
                bool b_;
                this(){ b_=b; }
                public void run() {
                    setOperationCancelButtonEnabled(b);
                }
            });
        }
    }

    /**
     * The cancel button has been pressed.
     *
     * @since 3.0
     */
    protected override void cancelPressed() {
        // NOTE: this was previously done from a listener installed on the
        // cancel button. On GTK, the listener installed by
        // Dialog.createButton is called first and this was throwing an
        // exception because the cancel button was already disposed
        cancel.setEnabled(false);
        progressMonitor.setCanceled(true);
        super.cancelPressed();
    }

    /*
     * (non-Javadoc) Method declared on Window.
     */
    /**
     * The <code>ProgressMonitorDialog</code> implementation of this method
     * only closes the dialog if there are no currently running runnables.
     */
    public override bool close() {
        if (getNestingDepth() <= 0) {
            clearCursors();
            return super.close();
        }
        return false;
    }

    /**
     * Clear the cursors in the dialog.
     *
     * @since 3.0
     */
    protected void clearCursors() {
        if (cancel !is null && !cancel.isDisposed()) {
            cancel.setCursor(null);
        }
        Shell shell = getShell();
        if (shell !is null && !shell.isDisposed()) {
            shell.setCursor(null);
        }
        if (arrowCursor !is null) {
            arrowCursor.dispose();
        }
        if (waitCursor !is null) {
            waitCursor.dispose();
        }
        arrowCursor = null;
        waitCursor = null;
    }

    /*
     * (non-Javadoc) Method declared in Window.
     */
    protected override void configureShell(Shell shell) {
        super.configureShell(shell);
        shell.setText(JFaceResources.getString("ProgressMonitorDialog.title")); //$NON-NLS-1$
        if (waitCursor is null) {
            waitCursor = new Cursor(shell.getDisplay(), DWT.CURSOR_WAIT);
        }
        shell.setCursor(waitCursor);
        // Add a listener to set the message properly when the dialog becomes
        // visible
        // DWT FIXME: workaround for DMD 1.028 anon class problem
        shell.addListener(DWT.Show, dgListener( &_handleEvent, shell));
    }

    // DWT FIXME: workaround for DMD 1.028 anon class problem
    private void _handleEvent(Event event, Shell shell_) {
        // We need to async the message update since the Show precedes
        // visibility
        shell_.getDisplay().asyncExec(dgRunnable( &_setMessage ));
    }
    // DWT FIXME: workaround for DMD 1.028 anon class problem
    private void _setMessage() {
        setMessage(message, true);
    }

    /*
     * (non-Javadoc) Method declared on Dialog.
     */
    protected override void createButtonsForButtonBar(Composite parent) {
        // cancel button
        createCancelButton(parent);
    }

    /**
     * Creates the cancel button.
     *
     * @param parent
     *            the parent composite
     * @since 3.0
     */
    protected void createCancelButton(Composite parent) {
        cancel = createButton(parent, IDialogConstants.CANCEL_ID,
                IDialogConstants.CANCEL_LABEL, true);
        if (arrowCursor is null) {
            arrowCursor = new Cursor(cancel.getDisplay(), DWT.CURSOR_ARROW);
        }
        cancel.setCursor(arrowCursor);
        setOperationCancelButtonEnabled(enableCancelButton);
    }

    /*
     * (non-Javadoc) Method declared on Dialog.
     */
    protected override Control createDialogArea(Composite parent) {
        setMessage(DEFAULT_TASKNAME, false);
        createMessageArea(parent);
        // Only set for backwards compatibility
        taskLabel = messageLabel;
        // progress indicator
        progressIndicator = new ProgressIndicator(parent);
        GridData gd = new GridData();
        gd.heightHint = convertVerticalDLUsToPixels(BAR_DLUS);
        gd.horizontalAlignment = GridData.FILL;
        gd.grabExcessHorizontalSpace = true;
        gd.horizontalSpan = 2;
        progressIndicator.setLayoutData(gd);
        // label showing current task
        subTaskLabel = new Label(parent, DWT.LEFT | DWT.WRAP);
        gd = new GridData(GridData.FILL_HORIZONTAL);
        gd.heightHint = convertVerticalDLUsToPixels(LABEL_DLUS);
        gd.horizontalSpan = 2;
        subTaskLabel.setLayoutData(gd);
        subTaskLabel.setFont(parent.getFont());
        return parent;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.window.Window#getInitialSize()
     */
    protected override Point getInitialSize() {
        Point calculatedSize = super.getInitialSize();
        if (calculatedSize.x < 450) {
            calculatedSize.x = 450;
        }
        return calculatedSize;
    }

    /**
     * Returns the progress monitor to use for operations run in this progress
     * dialog.
     *
     * @return the progress monitor
     */
    public IProgressMonitor getProgressMonitor() {
        return progressMonitor;
    }

    /**
     * This implementation of IRunnableContext#run(bool, bool,
     * IRunnableWithProgress) runs the given <code>IRunnableWithProgress</code>
     * using the progress monitor for this progress dialog and blocks until the
     * runnable has been run, regardless of the value of <code>fork</code>.
     * The dialog is opened before the runnable is run, and closed after it
     * completes. It is recommended that <code>fork</code> is set to true in
     * most cases. If <code>fork</code> is set to <code>false</code>, the
     * runnable will run in the UI thread and it is the runnable's
     * responsibility to call <code>Display.readAndDispatch()</code> to ensure
     * UI responsiveness.
     */
    public void run(bool fork, bool cancelable,
            IRunnableWithProgress runnable) {
        setCancelable(cancelable);
        try {
            aboutToRun();
            // Let the progress monitor know if they need to update in UI Thread
            progressMonitor.forked = fork;
            ModalContext.run(runnable, fork, getProgressMonitor(), getShell()
                    .getDisplay());
        } finally {
            finishedRun();
        }
    }

    /**
     * Returns whether the dialog should be opened before the operation is run.
     * Defaults to <code>true</code>
     *
     * @return <code>true</code> to open the dialog before run,
     *         <code>false</code> to only create the dialog, but not open it
     * @since 3.0
     */
    public bool getOpenOnRun() {
        return openOnRun;
    }

    /**
     * Sets whether the dialog should be opened before the operation is run.
     * NOTE: Setting this to false and not forking a process may starve any
     * asyncExec that tries to open the dialog later.
     *
     * @param openOnRun
     *            <code>true</code> to open the dialog before run,
     *            <code>false</code> to only create the dialog, but not open
     *            it
     * @since 3.0
     */
    public void setOpenOnRun(bool openOnRun) {
        this.openOnRun = openOnRun;
    }

    /**
     * Returns the nesting depth of running operations.
     *
     * @return the nesting depth of running operations
     * @since 3.0
     */
    protected int getNestingDepth() {
        return nestingDepth;
    }

    /**
     * Increments the nesting depth of running operations.
     *
     * @since 3.0
     */
    protected void incrementNestingDepth() {
        nestingDepth++;
    }

    /**
     * Decrements the nesting depth of running operations.
     *
     * @since 3.0
     *
     */
    protected void decrementNestingDepth() {
        nestingDepth--;
    }

    /**
     * Called just before the operation is run. Default behaviour is to open or
     * create the dialog, based on the setting of <code>getOpenOnRun</code>,
     * and increment the nesting depth.
     *
     * @since 3.0
     */
    protected void aboutToRun() {
        if (getOpenOnRun()) {
            open();
        } else {
            create();
        }
        incrementNestingDepth();
    }

    /**
     * Called just after the operation is run. Default behaviour is to decrement
     * the nesting depth, and close the dialog.
     *
     * @since 3.0
     */
    protected void finishedRun() {
        decrementNestingDepth();
        close();
    }

    /**
     * Sets whether the progress dialog is cancelable or not.
     *
     * @param cancelable
     *            <code>true</code> if the end user can cancel this progress
     *            dialog, and <code>false</code> if it cannot be canceled
     */
    public void setCancelable(bool cancelable) {
        if (cancel is null) {
            enableCancelButton = cancelable;
        } else {
            asyncSetOperationCancelButtonEnabled(cancelable);
        }
    }

    /**
     * Helper to enable/disable Cancel button for this dialog.
     *
     * @param b
     *            <code>true</code> to enable the cancel button, and
     *            <code>false</code> to disable it
     * @since 3.0
     */
    protected void setOperationCancelButtonEnabled(bool b) {
        operationCancelableState = b;
        cancel.setEnabled(b);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.dialogs.IconAndMessageDialog#getImage()
     */
    protected override Image getImage() {
        return getInfoImage();
    }

    /**
     * Set the message in the message label.
     *
     * @param messageString
     *            The string for the new message.
     * @param force
     *            If force is true then always set the message text.
     */
    private void setMessage(String messageString, bool force) {
        // must not set null text in a label
        message = messageString is null ? "" : messageString; //$NON-NLS-1$
        if (messageLabel is null || messageLabel.isDisposed()) {
            return;
        }
        if (force || messageLabel.isVisible()) {
            messageLabel.setToolTipText(message);
            messageLabel.setText(shortenText(message, messageLabel));
        }
    }

    /**
     * Update the message label. Required if the monitor is forked.
     */
    private void update() {
        if (messageLabel is null || messageLabel.isDisposed()) {
            return;
        }
        messageLabel.update();
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.window.Window#open()
     */
    public override int open() {
        // Check to be sure it is not already done. If it is just return OK.
        if (!getOpenOnRun()) {
            if (getNestingDepth() is 0) {
                return OK;
            }
        }
        int result = super.open();
        // update message label just in case beginTask() has been invoked
        // already
        if (task is null || task.length is 0)
            setMessage(DEFAULT_TASKNAME, true);
        else
            setMessage(task, true);
        return result;
    }
}
