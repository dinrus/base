/*******************************************************************************
 * Copyright (c) 2003, 2006 IBM Corporation and others.
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
module dwtx.jface.preference.PreferenceLabelProvider;

import dwtx.jface.preference.IPreferenceNode;

import dwt.graphics.Image;
import dwtx.jface.viewers.LabelProvider;

import dwt.dwthelper.utils;

/**
 * Provides labels for <code>IPreferenceNode</code> objects.
 *
 * @since 3.0
 */
public class PreferenceLabelProvider : LabelProvider {

    /**
     * @param element must be an instance of <code>IPreferenceNode</code>.
     * @see dwtx.jface.viewers.ILabelProvider#getText(java.lang.Object)
     */
    public override String getText(Object element) {
        return (cast(IPreferenceNode) element).getLabelText();
    }

    /**
     * @param element must be an instance of <code>IPreferenceNode</code>.
     * @see dwtx.jface.viewers.ILabelProvider#getImage(java.lang.Object)
     */
    public override Image getImage(Object element) {
        return (cast(IPreferenceNode) element).getLabelImage();
    }
}
