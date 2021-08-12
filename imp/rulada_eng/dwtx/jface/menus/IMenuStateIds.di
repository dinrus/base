/*******************************************************************************
 * Copyright (c) 2005, 2006 IBM Corporation and others.
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

module dwtx.jface.menus.IMenuStateIds;

import dwtx.core.commands.INamedHandleStateIds;
// import dwtx.jface.commands.RadioState;
// import dwtx.jface.commands.ToggleState;

import dwt.dwthelper.utils;

/**
 * <p>
 * State identifiers that should be understood by items and renderers of items.
 * The state is associated with the command, and then interpreted by the menu
 * renderer.
 * </p>
 * <p>
 * Clients may implement or extend this class.
 * </p>
 *
 * @since 3.2
 */
public interface IMenuStateIds : INamedHandleStateIds {

    /**
     * The state id used for indicating the widget style of a command presented
     * in the menus and tool bars. This state must be an instance of
     * {@link ToggleState} or {@link RadioState}.
     */
    public static String STYLE = "STYLE"; //$NON-NLS-1$
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
