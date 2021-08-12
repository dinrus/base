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
 *     yidabu at gmail dot com  ( D China http://www.d-programming-language-china.org/ )
 *******************************************************************************/

module table.Snippet96;

// http://dev.eclipse.org/viewcvs/index.cgi/org.eclipse.swt.snippets/src/org/eclipse/swt/snippets/Snippet96.java?view=co

/*
 * TableCursor example snippet: navigate a table cells with arrow keys.
 * Edit when user hits Return key.  Exit edit mode by hitting Escape (cancels edit)
 * or Return (applies edit to table).
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.widgets.Button;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Label;
import dwt.widgets.Listener;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwt.widgets.TableItem;
import dwt.widgets.TableColumn;
import dwt.widgets.Text;

import dwt.custom.TableCursor;
import dwt.custom.ControlEditor;

import dwt.layout.GridData;
import dwt.layout.GridLayout;

import dwt.events.SelectionEvent;
import dwt.events.SelectionAdapter;
import dwt.events.KeyEvent;
import dwt.events.KeyAdapter;
import dwt.events.FocusEvent;
import dwt.events.FocusAdapter;
import dwt.events.MouseEvent;
import dwt.events.MouseAdapter;

import dwt.dwthelper.utils;

import tango.util.Convert;


void main() {
    Display display = new Display();
    Shell shell = new Shell(display);
    shell.setLayout(new GridLayout());

    // create a a table with 3 columns and fill with data
    final Table table = new Table(shell, DWT.BORDER | DWT.MULTI | DWT.FULL_SELECTION);
    table.setLayoutData(new GridData(GridData.FILL_BOTH));
    TableColumn column1 = new TableColumn(table, DWT.NONE);
    TableColumn column2 = new TableColumn(table, DWT.NONE);
    TableColumn column3 = new TableColumn(table, DWT.NONE);
    for (int i = 0; i < 100; i++) {
        TableItem item = new TableItem(table, DWT.NONE);
        item.setText(["cell " ~ to!(char[])(i) ~ " 0",  "cell " ~ to!(char[])(i) ~ " 1", "cell " ~ to!(char[])(i) ~ " 2" ]);
    }
    column1.pack();
    column2.pack();
    column3.pack();

    // create a TableCursor to navigate around the table
    final TableCursor cursor = new TableCursor(table, DWT.NONE);
    // create an editor to edit the cell when the user hits "ENTER"
    // while over a cell in the table
    final ControlEditor editor = new ControlEditor(cursor);
    editor.grabHorizontal = true;
    editor.grabVertical = true;

    cursor.addSelectionListener(new class(table, editor, cursor) SelectionAdapter {
        // when the TableEditor is over a cell, select the corresponding row in
        // the table

        Table table;
        ControlEditor editor;
        TableCursor cursor;
        this(Table table_, ControlEditor editor_, TableCursor cursor_)
        {
            table = table_;
            editor = editor_;
            cursor = cursor_;
        }

        public void widgetSelected(SelectionEvent e) {
            table.setSelection([cursor.getRow()]);
        }
        // when the user hits "ENTER" in the TableCursor, pop up a text editor so that
        // they can change the text of the cell
        public void widgetDefaultSelected(SelectionEvent e) {
            final Text text = new Text(cursor, DWT.NONE);
            TableItem row = cursor.getRow();
            int column = cursor.getColumn();
            text.setText(row.getText(column));
            text.addKeyListener(new class(text, cursor) KeyAdapter {
                Text text;
                TableCursor cursor;
                this(Text text_, TableCursor cursor_)
                {
                    text = text_;
                    cursor = cursor_;
                }
                public void keyPressed(KeyEvent e) {
                    // close the text editor and copy the data over
                    // when the user hits "ENTER"
                    if (e.character == DWT.CR) {
                        TableItem row = cursor.getRow();
                        int column = cursor.getColumn();
                        row.setText(column, text.getText());
                        text.dispose();
                    }
                    // close the text editor when the user hits "ESC"
                    if (e.character == DWT.ESC) {
                        text.dispose();
                    }
                }
            });
            // close the text editor when the user tabs away
            text.addFocusListener(new class(text) FocusAdapter {
                Text text;
                this(Text text_)
                {
                    text = text_;
                }
                public void focusLost(FocusEvent e) {
                    text.dispose();
                }
            });
            editor.setEditor(text);
            text.setFocus();
        }
    });
    // Hide the TableCursor when the user hits the "CTRL" or "SHIFT" key.
    // This alows the user to select multiple items in the table.
    cursor.addKeyListener(new class(cursor) KeyAdapter {
        TableCursor cursor;
        this(TableCursor cursor_)
        {
            cursor = cursor_;
        }
        public void keyPressed(KeyEvent e) {
            if (e.keyCode == DWT.CTRL
                || e.keyCode == DWT.SHIFT
                || (e.stateMask & DWT.CONTROL) != 0
                || (e.stateMask & DWT.SHIFT) != 0) {
                cursor.setVisible(false);
            }
        }
    });
    // When the user double clicks in the TableCursor, pop up a text editor so that
    // they can change the text of the cell
    cursor.addMouseListener(new class(cursor, editor) MouseAdapter {
        ControlEditor editor;
        TableCursor cursor;
        this(TableCursor cursor_, ControlEditor editor_)
        {
            cursor = cursor_;
            editor = editor_;
        }

        public void mouseDown(MouseEvent e) {
            final Text text = new Text(cursor, DWT.NONE);
            TableItem row = cursor.getRow();
            int column = cursor.getColumn();
            text.setText(row.getText(column));
            text.addKeyListener(new class(text, cursor) KeyAdapter {
                Text text;
                TableCursor cursor;
                this(Text text_, TableCursor cursor_)
                {
                    text = text_;
                    cursor = cursor_;
                }
                public void keyPressed(KeyEvent e) {
                    // close the text editor and copy the data over
                    // when the user hits "ENTER"
                    if (e.character == DWT.CR) {
                        TableItem row = cursor.getRow();
                        int column = cursor.getColumn();
                        row.setText(column, text.getText());
                        text.dispose();
                    }
                    // close the text editor when the user hits "ESC"
                    if (e.character == DWT.ESC) {
                        text.dispose();
                    }
                }
            });
            // close the text editor when the user clicks away
            text.addFocusListener(new class(text) FocusAdapter {
                Text text;
                this(Text text_)
                {
                    text = text_;
                }
                public void focusLost(FocusEvent e) {
                    text.dispose();
                }
            });
            editor.setEditor(text);
            text.setFocus();
        }
    });

    // Show the TableCursor when the user releases the "SHIFT" or "CTRL" key.
    // This signals the end of the multiple selection task.
    table.addKeyListener(new class(table, cursor) KeyAdapter {
        Table table;
        TableCursor cursor;
        this(Table table_, TableCursor cursor_)
        {
            table = table_;
            cursor = cursor_;
        }
        public void keyReleased(KeyEvent e) {
            if (e.keyCode == DWT.CONTROL && (e.stateMask & DWT.SHIFT) != 0)
                return;
            if (e.keyCode == DWT.SHIFT && (e.stateMask & DWT.CONTROL) != 0)
                return;
            if (e.keyCode != DWT.CONTROL
                && (e.stateMask & DWT.CONTROL) != 0)
                return;
            if (e.keyCode != DWT.SHIFT && (e.stateMask & DWT.SHIFT) != 0)
                return;

            TableItem[] selection = table.getSelection();
            TableItem row = (selection.length == 0) ? table.getItem(table.getTopIndex()) : selection[0];
            table.showItem(row);
            cursor.setSelection(row, 0);
            cursor.setVisible(true);
            cursor.setFocus();
        }
    });

    shell.open();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch())
            display.sleep();
    }
    display.dispose();
}
