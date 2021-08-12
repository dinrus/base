﻿/*******************************************************************************
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
module dwtx.jface.operation.IRunnableWithProgress;

import dwtx.core.runtime.IProgressMonitor;

import dwt.dwthelper.utils;

import tango.core.Tuple;
import tango.core.Traits;

/**
 * The <code>IRunnableWithProgress</code> interface should be implemented by any
 * class whose instances are intended to be executed as a long-running operation.
 * Long-running operations are typically presented at the UI via a modal dialog
 * showing a progress indicator and a Cancel button.
 * The class must define a <code>run</code> method that takes a progress monitor.
 * The <code>run</code> method is usually not invoked directly, but rather by
 * passing the <code>IRunnableWithProgress</code> to the <code>run</code> method of
 * an <code>IRunnableContext</code>, which provides the UI for the progress monitor
 * and Cancel button.
 *
 * @see IRunnableContext
 */
public interface IRunnableWithProgress {
    /**
     * Runs this operation.  Progress should be reported to the given progress monitor.
     * This method is usually invoked by an <code>IRunnableContext</code>'s <code>run</code> method,
     * which supplies the progress monitor.
     * A request to cancel the operation should be honored and acknowledged
     * by throwing <code>InterruptedException</code>.
     *
     * @param monitor the progress monitor to use to display progress and receive
     *   requests for cancelation
     * @exception InvocationTargetException if the run method must propagate a checked exception,
     *  it should wrap it inside an <code>InvocationTargetException</code>; runtime exceptions are automatically
     *  wrapped in an <code>InvocationTargetException</code> by the calling context
     * @exception InterruptedException if the operation detects a request to cancel,
     *  using <code>IProgressMonitor.isCanceled()</code>, it should exit by throwing
     *  <code>InterruptedException</code>
     *
     * @see IRunnableContext#run
     */
    public void run(IProgressMonitor monitor);
}

class _DgIRunnableWithProgressT(Dg,T...) : IRunnableWithProgress {

    alias ParameterTupleOf!(Dg) DgArgs;
    static assert( is(DgArgs == Tuple!(T))
                || is(DgArgs == Tuple!(IProgressMonitor,T)),
                "Delegate args not correct" );

    Dg dg;
    T t;

    private this( Dg dg, T t ){
        this.dg = dg;
        static if( T.length > 0 ){
            this.t = t;
        }
    }

    void run( IProgressMonitor pm ){
        static if( is( typeof(dg(pm,t)))){
            dg(pm,t);
        }
        else static if( is( typeof(dg(t)))){
            dg(t);
        }
        else{
            static assert( false, "Delegate type is incorrect for arguments supplied");
        }
    }
}

_DgIRunnableWithProgressT!(Dg,T) dgIRunnableWithProgress(Dg,T...)( Dg dg, T args ){
    return new _DgIRunnableWithProgressT!(Dg,T)(dg,args);
}


