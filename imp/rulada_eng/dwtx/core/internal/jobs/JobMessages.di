/**********************************************************************
 * Copyright (c) 2005, 2006 IBM Corporation and others. All rights reserved.   This
 * program and the accompanying materials are made available under the terms of
 * the Eclipse Public License v1.0 which accompanies this distribution, and is
 * available at http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 * IBM - Initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 **********************************************************************/
module dwtx.core.internal.jobs.JobMessages;

import dwtx.dwtxhelper.JThread;
import tango.io.Stdout;
import tango.time.WallClock;
import tango.text.convert.TimeStamp;

import dwt.dwthelper.utils;

import dwtx.osgi.util.NLS;

/**
 * Job plugin message catalog
 */
public class JobMessages : NLS {
    private static const String BUNDLE_NAME = "dwtx.core.internal.jobs.messages"; //$NON-NLS-1$

    // Job Manager and Locks
    public static String jobs_blocked0 = "The user operation is waiting for background work to complete.";
    public static String jobs_blocked1 = "The user operation is waiting for \"{0}\" to complete.";
    public static String jobs_internalError = "An internal error occured during: \"{0}\".";
    public static String jobs_waitFamSub =  "{0} work item(s) left.";

    // metadata
    public static String meta_pluginProblems = "Problems occured when invoking code from plug-in: \"{0}\".";

//     static this() {
//         // load message values from bundle file
//         reloadMessages();
//     }

    public static void reloadMessages() {
        implMissing(__FILE__,__LINE__);
//         NLS.initializeMessages(BUNDLE_NAME, import(BUNDLE_NAME~".properties"));
    }

    /**
     * Print a debug message to the console.
     * Pre-pend the message with the current date and the name of the current thread.
     */
    public static void message(String message) {
        StringBuffer buffer = new StringBuffer();
        char[30] buf;
        buffer.append(tango.text.convert.TimeStamp.format( buf, WallClock.now()));
        buffer.append(" - ["); //$NON-NLS-1$
        buffer.append(JThread.currentThread().getName());
        buffer.append("] "); //$NON-NLS-1$
        buffer.append(message);
        Stdout.formatln(buffer.toString());
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
