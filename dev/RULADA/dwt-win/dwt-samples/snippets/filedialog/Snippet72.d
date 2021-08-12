/*******************************************************************************
 * Copyright (c) 2000, 2004 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Bill Baxter <bill@billbaxter.com>
 *******************************************************************************/
module filedialog.Snippet72;

/*
 * FileDialog example snippet: prompt for a file name (to save)
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.FileDialog;

import tango.io.Stdout;

void main () {
    Display display = new Display ();
    Shell shell = new Shell (display);
    shell.open ();
    FileDialog dialog = new FileDialog (shell, DWT.SAVE);
    dialog.setFilterNames (["Batch Files", "All Files (*.*)"]);
    dialog.setFilterExtensions (["*.bat", "*.*"]); //Windows wild cards
    dialog.setFilterPath ("c:\\"); //Windows path
    dialog.setFileName ("fred.bat");
    Stdout.formatln ("Save to: {}", dialog.open ());
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}

