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
module dwtx.draw2d.geometry.Translatable;

import dwt.dwthelper.utils;

/**
 * A translatable object can be translated (or moved) vertically and/or horizontally.
 */
public interface Translatable {

/**
 * Translates this object horizontally by <code>dx</code> and vertically by 
 * <code>dy</code>.
 * 
 * @param dx The amount to translate horizontally
 * @param dy The amount to translate vertically
 * @since 2.0
 */
void performTranslate(int dx, int dy);

/**
 * Scales this object by the scale factor.
 * 
 * @param factor The scale factor
 * @since 2.0
 */
void performScale(double factor);

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
