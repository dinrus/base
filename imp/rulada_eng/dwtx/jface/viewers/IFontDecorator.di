/*******************************************************************************
 * Copyright (c) 2004, 2007 IBM Corporation and others.
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
module dwtx.jface.viewers.IFontDecorator;

import dwt.graphics.Font;

/**
 * The IFontDecorator is an interface for objects that return a font to
 * decorate an object.
 * 
 * If an IFontDecorator decorates a font in an object that also has
 * an IFontProvider the IFontDecorator will take precedence.
 * @see IFontProvider
 * 
 * @since 3.1
 */
public interface IFontDecorator {
    
    /**
     * Return the font for element or <code>null</code> if there
     * is not one.
     * 
     * @param element
     * @return Font or <code>null</code>
     */
    public Font decorateFont(Object element);

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