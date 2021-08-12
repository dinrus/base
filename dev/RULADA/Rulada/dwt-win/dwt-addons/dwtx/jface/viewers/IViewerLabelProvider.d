/*******************************************************************************
 * Copyright (c) 2004, 2006 IBM Corporation and others.
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
module dwtx.jface.viewers.IViewerLabelProvider;

import dwtx.jface.viewers.IBaseLabelProvider;
import dwtx.jface.viewers.ViewerLabel;

/**
 * Extends <code>IBaseLabelProvider</code> with the methods
 * to update the label for a given element.  The label is represented by a
 * <code>ViewerLabel</code>.
 * Unlike <code>ILabelProvider</code>, this allows the text and image to be
 * set in the same request, rather than via separate requests.
 * <p>
 * It also allows the current values for the text and image to be considered by
 * the label provider, allowing for potential optimizations.
 * For example, decorating label providers that run in the background can hold off
 * applying an update to a previously populated label until the decoration is ready,
 * thereby reducing flicker.
 * </p>
 *
 * @see IDelayedLabelDecorator
 * @since 3.0
 */
public interface IViewerLabelProvider : IBaseLabelProvider {

    /**
     * Updates the label for the given element.
     *
     * @param label the label to update
     * @param element the element
     */
    public void updateLabel(ViewerLabel label, Object element);
}
