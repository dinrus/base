/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module dwtx.jface.text.IWidgetTokenKeeperExtension;

import dwtx.jface.text.IWidgetTokenOwner; // packageimport

import dwt.dwthelper.utils;

/**
 * Extension interface for {@link dwtx.jface.text.IWidgetTokenKeeper}.
 * <p>
 * Replaces the original <code>requestWidgetToken</code> functionality with a
 * new priority based approach. Adds the concept of focus handling.
 *
 * @since 3.0
 */
public interface IWidgetTokenKeeperExtension {

    /**
     * The given widget token owner requests the widget token  from
     * this token keeper. Returns  <code>true</code> if the token is released
     * by this token keeper. Note, the keeper must not call
     * <code>releaseWidgetToken(IWidgetTokenKeeper)</code> explicitly.
     *
     * <p>The general contract is that the receiver should release the token
     * if <code>priority</code> exceeds the receiver's priority.</p>
     *
     * @param owner the token owner
     * @param priority the priority of the request
     * @return <code>true</code> if token has been released <code>false</code> otherwise
     */
    bool requestWidgetToken(IWidgetTokenOwner owner, int priority);

    /**
     * Requests the receiver to give focus to its popup shell, hover, or similar. There is
     * no assumption made whether the receiver actually succeeded in taking the focus. The return
     * value gives a hint whether the receiver tried to take focus.
     *
     * @param owner the token owner
     * @return <code>true</code> if the receiver tried to take focus, <code>false</code> if it did not.
     */
    bool setFocus(IWidgetTokenOwner owner);
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
