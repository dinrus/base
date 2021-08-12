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
module dwtx.jface.util.TransferDropTargetListener;

import dwt.dnd.DropTargetEvent;
import dwt.dnd.DropTargetListener;
import dwt.dnd.Transfer;

import dwt.dwthelper.utils;

/**
 * A <code>TransferDropTargetListener</code> is a <code>DropTragetListener</code>
 * that handles one type of DWT {@link Transfer}.
 * The purpose of a <code>TransferDropTargetListener</code> is to:
 * <ul>
 *   <li>Determine enablement for a drop operation. A <code>TransferDropTargetListener</code>
 *      will not be used if <code>isEnabled</code> returns false.
 *   <li>When enabled, optionally show feedback on the <code>DropTarget</code>.
 *   <li>Perform the actual drop
 * </ul>
 * A <code>DelegatingDropAdapter</code> allows these functions to be implemented
 * separately for unrelated types of drags. <code>DelegatingDropAdapter</code> then
 * combines the function of each <code>TransferDropTargetListener</code>, while
 * allowing them to be implemented as if they were the only <code>DragSourceListener</code>.
 * @since 3.0
 */
public interface TransferDropTargetListener : DropTargetListener {
    /**
     * Returns the <code>Transfer</code> type that this listener can
     * accept a drop operation for.
     *
     * @return the <code>Transfer</code> for this listener
     */
    Transfer getTransfer();

    /**
     * Returns <code>true</code> if this listener can handle the drop
     * based on the given <code>DropTargetEvent</code>.
     * <p>
     * This method is called by the <code>DelegatingDropAdapter</code> only
     * if the <code>DropTargetEvent</code> contains a transfer data type
     * supported by this listener. The <code>Transfer</code> returned by the
     * <code>#getTransfer()</code> method is used for this purpose.
     * </p>
     *
     * @param event the drop target event
     * @return <code>true</code> if the listener is enabled for the given
     *  drop target event.
     */
    bool isEnabled(DropTargetEvent event);
}
