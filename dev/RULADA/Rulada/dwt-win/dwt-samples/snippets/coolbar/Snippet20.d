﻿/*******************************************************************************
 * Copyright (c) 2000, 2004 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * D Port:
 *     Jesse Phillips <Jesse.K.Phillips+D> gmail.com
 *******************************************************************************/
module coolbar.Snippet20;

/*
 * CoolBar example snippet: create a cool bar
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.graphics.Point;
import dwt.widgets.Button;
import dwt.widgets.Display;
import dwt.widgets.CoolBar;
import dwt.widgets.CoolItem;
import dwt.widgets.Shell;

import tango.util.Convert;

void main () {
    auto display = new Display ();
    auto shell = new Shell (display);
    auto bar = new CoolBar (shell, DWT.BORDER);
    for (int i=0; i<2; i++) {
        auto item = new CoolItem (bar, DWT.NONE);
        auto button = new Button (bar, DWT.PUSH);
        button.setText ("Button " ~ to!(char[])(i));
        auto size = button.computeSize (DWT.DEFAULT, DWT.DEFAULT);
        item.setPreferredSize (item.computeSize (size.x, size.y));
        item.setControl (button);
    }
    bar.pack ();
	 shell.setSize(300, 100);
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}
