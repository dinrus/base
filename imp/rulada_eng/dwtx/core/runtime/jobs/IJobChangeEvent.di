/*******************************************************************************
 * Copyright (c) 2003, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM - Initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.core.runtime.jobs.IJobChangeEvent;

import dwt.dwthelper.utils;

import dwtx.core.runtime.IStatus;
import dwtx.core.runtime.jobs.Job;

/**
 * An event describing a change to the state of a job.
 *
 * @see IJobChangeListener
 * @since 3.0
 * @noimplement This interface is not intended to be implemented by clients.
 */
public interface IJobChangeEvent {
    /**
     * The amount of time in milliseconds to wait after scheduling the job before it
     * should be run, or <code>-1</code> if not applicable for this type of event.
     * This value is only applicable for the <code>scheduled</code> event.
     *
     * @return the delay time for this event
     */
    public long getDelay();

    /**
     * The job on which this event occurred.
     *
     * @return the job for this event
     */
    public Job getJob();

    /**
     * The result returned by the job's run method, or <code>null</code> if
     * not applicable.  This value is only applicable for the <code>done</code> event.
     *
     * @return the status for this event
     */
    public IStatus getResult();
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
