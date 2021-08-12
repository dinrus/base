/*******************************************************************************
 * Copyright (c) 2006 IBM Corporation and others.
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

module dwtx.jface.viewers.ITreePathLabelProvider;

import dwtx.jface.viewers.IBaseLabelProvider;
import dwtx.jface.viewers.ViewerLabel;
import dwtx.jface.viewers.TreePath;

/**
 * An extension to {@link ILabelProvider} that is given the
 * path of the element being decorated, when it is available.
 * @since 3.2
 */
public interface ITreePathLabelProvider : IBaseLabelProvider {

    /**
     * Updates the label for the given element.
     *
     * @param label the label to update
     * @param elementPath the path of the element being decorated
     */
    public void updateLabel(ViewerLabel label, TreePath elementPath);
}
