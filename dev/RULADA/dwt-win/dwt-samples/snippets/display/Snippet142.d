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
module display.Snippet142;

/*
 * UI Automation (for testing tools) snippet: post mouse events
 *
 * For a list of all DWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 *
 * @since 3.0
 */
import dwt.DWT;
import dwt.graphics.Point;
import dwt.widgets.Button;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Shell;

import dwt.dwthelper.utils;

import tango.core.Thread;
import tango.io.Stdout;

void main(String[] args) {
    Display display = new Display();
    Shell shell = new Shell(display);
    Button button = new Button(shell,DWT.NONE);
    button.setSize(100,100);
    button.setText("Click");
    shell.pack();
    shell.open();
    button.addListener(DWT.MouseDown, dgListener( (Event e){
        Stdout.formatln("Mouse Down  (Button: {} x: {} y: {})",e.button,e.x,e.y);
    }));
    Point pt = display.map(shell, null, 50, 50);
    Thread thread = new Thread({
        Event event;
        try {
            Thread.sleep(300/1000.);
        } catch (InterruptedException e) {}
        event = new Event();
        event.type = DWT.MouseMove;
        event.x = pt.x;
        event.y = pt.y;
        display.post(event);
        try {
            Thread.sleep(300/1000.0);
        } catch (InterruptedException e) {}
        event.type = DWT.MouseDown;
        event.button = 1;
        display.post(event);
        try {
            Thread.sleep(300/1000.0);
        } catch (InterruptedException e) {}
        event.type = DWT.MouseUp;
        display.post(event);
    });
    thread.start();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch()) display.sleep();
    }
    display.dispose();
}

