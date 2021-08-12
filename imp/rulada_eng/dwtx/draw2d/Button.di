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
module dwtx.draw2d.Button;

import dwt.dwthelper.utils;

import dwt.graphics.Image;
import dwtx.draw2d.Clickable;
import dwtx.draw2d.ColorConstants;
import dwtx.draw2d.Label;

/**
 * A Button usually has a border and appears to move up and down in response to being
 * pressed. It can contain  an image and/or text in it.
 */
public class Button
    : Clickable
{

/**
 * Constructs a default Button with no icon or text.
 *
 * @since 2.0
 */
public this() {
    super();
    setStyle(STYLE_BUTTON);
}

/**
 * Contructs a Button containing the icon <i>image</i>.
 *
 * @param image  Image to be used by the Button as its icon.
 * @since 2.0
 */
public this(Image image) {
    super(new Label(image), STYLE_BUTTON);
}

/**
 * Constructs a Button containing the given text.
 *
 * @param text  Text for the button.
 * @since 2.0
 */
public this(String text) {
    super(new Label(text), STYLE_BUTTON);
}

/**
 * Constructs a Button with the given image and text.
 *
 * @param text  Text for the button.
 * @param image  Image for the button.
 * @since 2.0
 */
public this(String text, Image image) {
    super(new Label(text, image), STYLE_BUTTON);
}

/**
 * Initializes this button by setting its default border and setting its background color
 * to {@link ColorConstants#button}.
 *
 * @since 2.0
 */
protected void init() {
    super.init();
    setBackgroundColor(ColorConstants.button);
}

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