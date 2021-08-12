/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * D Port:
 *     Bill Baxter <wbaxter> at gmail com
 *******************************************************************************/
module canvas.Snippet275;

/*
 * Canvas snippet: update a portion of a Canvas frequently
 * 
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.graphics.GC;
import dwt.graphics.Color;
import dwt.graphics.Point;
import dwt.graphics.Image;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Canvas;

import dwt.dwthelper.System;
import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;

import tango.util.Convert;

static String value;
public static void main () {
	final int INTERVAL = 888;
	final Display display = new Display ();
	final Image image = new Image (display, 750, 750);
	GC gc = new GC (image);
	gc.setBackground (display.getSystemColor (DWT.COLOR_RED));
	gc.fillRectangle (image.getBounds ());
	gc.dispose ();

	Shell shell = new Shell (display);
	shell.setBounds (10, 10, 790, 790);
	final Canvas canvas = new Canvas (shell, DWT.NONE);
	canvas.setBounds (10, 10, 750, 750);

    void onPaint (Event event) {
        value = to!(char[])(System.currentTimeMillis ());
        event.gc.drawImage (image, 0, 0);
        event.gc.drawString (value, 10, 10, true);
    }
	canvas.addListener (DWT.Paint, dgListener(&onPaint));

	display.timerExec (INTERVAL, new class Runnable {
        void run () {
			if (canvas.isDisposed ()) return;
			// canvas.redraw (); // <-- bad, damages more than is needed
			GC gc = new GC (canvas);
			Point extent = gc.stringExtent (value ~ '0');
			gc.dispose ();
			canvas.redraw (10, 10, extent.x, extent.y, false);
			display.timerExec (INTERVAL, this);
		}
	});
	shell.open ();
	while (!shell.isDisposed ()){
		if (!display.readAndDispatch ()) display.sleep ();
	}
	image.dispose ();
	display.dispose ();
}
