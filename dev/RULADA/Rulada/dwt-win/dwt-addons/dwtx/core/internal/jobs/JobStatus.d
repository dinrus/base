/*******************************************************************************
 * Copyright (c) 2004, 2006 IBM Corporation and others.
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
module dwtx.core.internal.jobs.JobStatus;

import dwt.dwthelper.utils;

import dwtx.core.runtime.Status;
import dwtx.core.runtime.jobs.IJobStatus;
import dwtx.core.runtime.jobs.Job;
import dwtx.core.internal.jobs.JobManager;

/**
 * Standard implementation of the IJobStatus interface.
 */
public class JobStatus : Status, IJobStatus {
    private Job job;

    /**
     * Creates a new job status with no interesting error code or exception.
     * @param severity
     * @param job
     * @param message
     */
    public this(int severity, Job job, String message) {
        super(severity, JobManager.PI_JOBS, 1, message, null);
        this.job = job;
    }

    /* (non-Javadoc)
     * @see dwtx.core.runtime.jobs.IJobStatus#getJob()
     */
    public Job getJob() {
        return job;
    }
}
