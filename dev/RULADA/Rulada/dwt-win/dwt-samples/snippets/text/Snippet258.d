/*******************************************************************************
 * Copyright (c) 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Jesse Phillips <Jesse.K.Phillips+D> gmail.com
 *******************************************************************************/

module text.Snippet258;

/*
 * Create a search text control
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 *
 * @since 3.3
 */
import dwt.DWT;
import dwt.dwthelper.ByteArrayInputStream;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.graphics.Image;
import dwt.graphics.ImageData;
import dwt.layout.GridLayout;
import dwt.layout.GridData;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Text;
import dwt.widgets.ToolBar;
import dwt.widgets.ToolItem;

import tango.io.Stdout;

void main() {
    auto display = new Display();
    auto shell = new Shell(display);
    shell.setLayout(new GridLayout(2, false));

    auto text = new Text(shell, DWT.SEARCH | DWT.CANCEL);
    Image image = null;
    if ((text.getStyle() & DWT.CANCEL) == 0) {
        image = new Image (display, new ImageData(new ByteArrayInputStream( cast(byte[]) import("cancel.gif" ))));
        auto toolBar = new ToolBar (shell, DWT.FLAT);
        auto item = new ToolItem (toolBar, DWT.PUSH);
        item.setImage (image);
        item.addSelectionListener(new class SelectionAdapter {
            public void widgetSelected(SelectionEvent e) {
                text.setText("");
                Stdout("Search cancelled").newline;
            }
        });
    }
    text.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
    text.setText("Search text");
    text.addSelectionListener(new class SelectionAdapter {
        public void widgetDefaultSelected(SelectionEvent e) {
            if (e.detail == DWT.CANCEL) {
                Stdout("Search cancelled").newline;
            } else {
                Stdout("Searching for: ")(text.getText())("...").newline;
            }
        }
    });

    shell.pack();
    shell.open();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch()) display.sleep();
    }
    if (image !is null) image.dispose();
    display.dispose();
}
