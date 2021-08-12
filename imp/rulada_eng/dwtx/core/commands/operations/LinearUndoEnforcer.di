/*******************************************************************************
 * Copyright (c) 2005 IBM Corporation and others.
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
module dwtx.core.commands.operations.LinearUndoEnforcer;

import dwtx.core.runtime.IAdaptable;
import dwtx.core.runtime.IStatus;
import dwtx.core.runtime.Status;

import dwtx.core.commands.operations.LinearUndoViolationDetector;
import dwtx.core.commands.operations.IUndoableOperation;
import dwtx.core.commands.operations.IUndoContext;
import dwtx.core.commands.operations.IOperationHistory;

import dwt.dwthelper.utils;

/**
 * <p>
 * An operation approver that enforces a strict linear undo. It does not allow
 * the undo or redo of any operation that is not the latest available operation
 * in all of its undo contexts.  This class may be instantiated by clients.
 * </p>
 *
 * @since 3.1
 */
public final class LinearUndoEnforcer : LinearUndoViolationDetector {
    /**
     * Create an instance of LinearUndoEnforcer.
     */
    public this() {
        super();
    }

    /*
     * Return whether a linear redo violation is allowable.  A linear redo violation
     * is defined as a request to redo a particular operation even if it is not the most
     * recently added operation to the redo history.
     */
    protected override IStatus allowLinearRedoViolation(IUndoableOperation operation,
            IUndoContext context, IOperationHistory history, IAdaptable uiInfo) {
        return Status.CANCEL_STATUS;
    }

    /*
     * Return whether a linear undo violation is allowable.  A linear undo violation
     * is defined as a request to undo a particular operation even if it is not the most
     * recently added operation to the undo history.
     */
    protected override IStatus allowLinearUndoViolation(IUndoableOperation operation,
            IUndoContext context, IOperationHistory history, IAdaptable uiInfo) {
        return Status.CANCEL_STATUS;
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