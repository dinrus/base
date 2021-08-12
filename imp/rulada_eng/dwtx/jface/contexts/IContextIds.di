/*******************************************************************************
 * Copyright (c) 2004, 2005 IBM Corporation and others.
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
module dwtx.jface.contexts.IContextIds;

import dwt.dwthelper.utils;

/**
 * <p>
 * A list of well-known context identifiers. The context identifiers use the
 * prefix "dwtx.ui" for historical reasons. These contexts exist as part
 * of JFace.
 * </p>
 * <p>
 * This interface should not be implemented or extended by clients.
 * </p>
 *
 * @since 3.1
 */
public interface IContextIds {

    /**
     * The identifier for the context that is active when a shell registered as
     * a dialog.
     */
    public static const String CONTEXT_ID_DIALOG = "dwtx.ui.contexts.dialog"; //$NON-NLS-1$

    /**
     * The identifier for the context that is active when a shell is registered
     * as either a window or a dialog.
     */
    public static const String CONTEXT_ID_DIALOG_AND_WINDOW = "dwtx.ui.contexts.dialogAndWindow"; //$NON-NLS-1$

    /**
     * The identifier for the context that is active when a shell is registered
     * as a window.
     */
    public static const String CONTEXT_ID_WINDOW = "dwtx.ui.contexts.window"; //$NON-NLS-1$
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