/*******************************************************************************
 * Copyright (c) 2000, 2004 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * D Port:
 *     Thomas Demmer <t_demmer AT web DOT de>
 *******************************************************************************/
module busyindicator.Snippet130;
/*
 * BusyIndicator example snippet: display busy cursor during long running task
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.layout.GridLayout;
import dwt.layout.GridData;
import dwt.widgets.Shell;
import dwt.widgets.Button;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Text;


import dwt.custom.BusyIndicator;

import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;
import dwt.dwthelper.System;

import tango.core.Thread;
import tango.io.Stdout;
import tango.util.Convert;
import tango.util.log.Trace;


void main(String[] args){
    Snippet130.main(args);
}

public class Snippet130 {

    public static void main(String[] args) {
        Display display = new Display();
        Shell shell = new Shell(display);
        shell.setLayout(new GridLayout());
        Text text = new Text(shell, DWT.MULTI | DWT.BORDER | DWT.V_SCROLL);
        text.setLayoutData(new GridData(GridData.FILL_BOTH));
        int[] nextId = new int[1];
        Button b = new Button(shell, DWT.PUSH);
        b.setText("invoke long running job");

        b.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent e) {
                Runnable longJob = new class() Runnable {
                    bool done = false;
                    int id;
                    public void run() {
                        Thread thread = new Thread({
                            id = nextId[0]++;
                            display.syncExec(new class() Runnable {
                                public void run() {
                                if (text.isDisposed()) return;
                                text.append("\nStart long running task "~to!(char[])(id));
                                }
                                }); // display.syncExec
                            /*
                             * This crashes when more than 1 thread gets created. THD
                             for (int i = 0; i < 100000; i++) {
                             if (display.isDisposed()) return;
                             Stdout.formatln("do task that takes a long time in a separate thread {}", id);
                             }
                             */
                            // This runs fine
                            for (int i = 0; i < 6; i++) {
                                if (display.isDisposed()) return;
                                Trace.formatln("do task that takes a long time in a separate thread {} {}/6", id, i);
                                Thread.sleep(0.500);
                            }

                            if (display.isDisposed()) return;
                            display.syncExec(new class() Runnable {
                                public void run() {
                                    if (text.isDisposed()) return;
                                    text.append("\nCompleted long running task "~to!(char[])(id));
                                }
                            }); // display.syncExec
                            done = true;
                            display.wake();
                        }); // thread = ...
                        thread.start();

                        while (!done && !shell.isDisposed()) {
                            if (!display.readAndDispatch())
                                display.sleep();
                        }
                    }
                };  // Runnable longJob = ...
                BusyIndicator.showWhile(display, longJob);
            } // widgetSelected();
        }); // addSelectionListener


        shell.setSize(250, 150);
        shell.open();
        while (!shell.isDisposed()) {
            if (!display.readAndDispatch())
                display.sleep();
        }
        display.dispose();
    }
    private void printStart(Text text, int id ) {
        if (text.isDisposed()) return;
        Trace.formatln( "Start long running task {}", id );
        text.append("\nStart long running task "~to!(char[])(id));
    }
    private void printEnd(Text text, int id ) {
        if (text.isDisposed()) return;
        Trace.formatln( "Completed long running task {}", id );
        text.append("\nCompleted long running task "~to!(char[])(id));
    }
}
