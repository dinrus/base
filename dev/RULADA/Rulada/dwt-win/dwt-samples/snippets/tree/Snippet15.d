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
module tree.Snippet15;
 
/*
 * Tree example snippet: create a tree
 *
 * For a list of all DWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.layout.FillLayout;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Tree;
import dwt.widgets.TreeItem;

import tango.util.Convert;

void main () {
    auto display = new Display ();
    auto shell = new Shell (display);
    shell.setLayout(new FillLayout());
    auto tree = new Tree (shell, DWT.BORDER);
    for (int i=0; i<4; i++) {
        auto iItem = new TreeItem (tree, 0);
        iItem.setText ("TreeItem (0) -" ~ to!(char[])(i));
        for (int j=0; j<4; j++) {
            TreeItem jItem = new TreeItem (iItem, 0);
            jItem.setText ("TreeItem (1) -" ~ to!(char[])(j));
            for (int k=0; k<4; k++) {
                TreeItem kItem = new TreeItem (jItem, 0);
                kItem.setText ("TreeItem (2) -" ~ to!(char[])(k));
                for (int l=0; l<4; l++) {
                    TreeItem lItem = new TreeItem (kItem, 0);
                    lItem.setText ("TreeItem (3) -" ~ to!(char[])(l));
                }
            }
        }
    }
    shell.setSize (200, 200);
    shell.open ();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}
