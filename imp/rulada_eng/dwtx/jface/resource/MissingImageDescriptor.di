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
module dwtx.jface.resource.MissingImageDescriptor;

import dwtx.jface.resource.ImageDescriptor;

import dwt.graphics.ImageData;

/**
 * The image descriptor for a missing image.
 * <p>
 * Use <code>MissingImageDescriptor.getInstance</code> to
 * access the singleton instance maintained in an
 * internal state variable.
 * </p>
 */
class MissingImageDescriptor : ImageDescriptor {
    private static MissingImageDescriptor instance;

    /**
     * Constructs a new missing image descriptor.
     */
    private this() {
        super();
    }

    /* (non-Javadoc)
     * Method declared on ImageDesciptor.
     */
    public override ImageData getImageData() {
        return DEFAULT_IMAGE_DATA;
    }

    /**
     * Returns the shared missing image descriptor instance.
     *
     * @return the image descriptor for a missing image
     */
    static MissingImageDescriptor getInstance() {
        if (instance is null) {
            instance = new MissingImageDescriptor();
        }
        return instance;
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
