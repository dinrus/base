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
module dwtx.jface.viewers.IDoubleClickListener;

import dwtx.jface.viewers.DoubleClickEvent;

/**
 * A listener which is notified of double-click events on viewers.
 */
public interface IDoubleClickListener {
    /**
     * Notifies of a double click.
     *
     * @param event event object describing the double-click
     */
    public void doubleClick(DoubleClickEvent event);
}
