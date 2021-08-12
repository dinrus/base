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
module dwtx.jface.resource.DeviceResourceException;

import dwtx.jface.resource.DeviceResourceDescriptor;

import dwt.dwthelper.utils;

/**
 * Thrown when allocation of an DWT device resource fails
 *
 * @since 3.1
 */
public class DeviceResourceException : RuntimeException {

    private Exception cause;

    /**
     * All serializable objects should have a stable serialVersionUID
     */
    private static const long serialVersionUID = 11454598756198L;

    /**
     * Creates a DeviceResourceException indicating an error attempting to
     * create a resource and an embedded low-level exception describing the cause
     *
     * @param missingResource
     * @param cause cause of the exception (or null if none)
     */
    public this(DeviceResourceDescriptor missingResource, Exception cause) {
        super("Unable to create resource " ~ missingResource.toString()); //$NON-NLS-1$
        // don't pass the cause to super, to allow compilation against JCL Foundation (bug 80059)
        this.cause = cause;
    }

    /**
     * Creates a DeviceResourceException indicating an error attempting to
     * create a resource
     *
     * @param missingResource
     */
    public this(DeviceResourceDescriptor missingResource) {
        this(missingResource, null);
    }

    /**
     * Returns the cause of this throwable or <code>null</code> if the
     * cause is nonexistent or unknown.
     *
     * @return the cause or <code>null</code>
     * @since 3.1
     */
    public override Exception getCause() {
        return cause;
    }

}
