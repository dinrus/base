/*******************************************************************************
 * Copyright (c) 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 ******************************************************************************/

module dwtx.jface.util.StatusHandler;

import dwtx.core.runtime.IStatus;
import dwt.dwthelper.utils;

/**
 * A mechanism to handle statuses throughout JFace.
 * <p>
 * Clients may provide their own implementation to change how statuses are
 * handled from within JFace.
 * </p>
 *
 * @see dwtx.jface.util.Policy#getStatusHandler()
 * @see dwtx.jface.util.Policy#setStatusHandler(StatusHandler)
 *
 * @since 3.4
 */
abstract public class StatusHandler {

    /**
     * Show the given status.
     *
     * @param status
     *            status to handle
     * @param title
     *            title for the status
     */
    abstract public void show(IStatus status, String title);
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