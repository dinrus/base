/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
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
module dwtx.jface.viewers.DialogCellEditor;

import dwtx.jface.viewers.CellEditor;

import dwt.DWT;
import dwt.events.FocusEvent;
import dwt.events.FocusListener;
import dwt.events.KeyAdapter;
import dwt.events.KeyEvent;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Label;
import dwt.widgets.Layout;
import dwtx.jface.resource.ImageDescriptor;
import dwtx.jface.resource.ImageRegistry;
import dwtx.jface.resource.JFaceResources;

import dwt.dwthelper.utils;
import tango.text.convert.Format;

/**
 * An abstract cell editor that uses a dialog.
 * Dialog cell editors usually have a label control on the left and a button on
 * the right. Pressing the button opens a dialog window (for example, a color dialog
 * or a file dialog) to change the cell editor's value.
 * The cell editor's value is the value of the dialog.
 * <p>
 * Subclasses may override the following methods:
 * <ul>
 *  <li><code>createButton</code>: creates the cell editor's button control</li>
 *  <li><code>createContents</code>: creates the cell editor's 'display value' control</li>
 *  <li><code>updateContents</code>: updates the cell editor's 'display value' control
 *      after its value has changed</li>
 *  <li><code>openDialogBox</code>: opens the dialog box when the end user presses
 *      the button</li>
 * </ul>
 * </p>
 */
public abstract class DialogCellEditor : CellEditor {

    /**
     * Image registry key for three dot image (value <code>"cell_editor_dots_button_image"</code>).
     */
    public static const String CELL_EDITOR_IMG_DOTS_BUTTON = "cell_editor_dots_button_image";//$NON-NLS-1$

    /**
     * The editor control.
     */
    private Composite editor;

    /**
     * The current contents.
     */
    private Control contents;

    /**
     * The label that gets reused by <code>updateLabel</code>.
     */
    private Label defaultLabel;

    /**
     * The button.
     */
    private Button button;

    /**
     * Listens for 'focusLost' events and  fires the 'apply' event as long
     * as the focus wasn't lost because the dialog was opened.
     */
    private FocusListener buttonFocusListener;

    /**
     * The value of this cell editor; initially <code>null</code>.
     */
    private Object value = null;

    static this() {
        ImageRegistry reg = JFaceResources.getImageRegistry();
        reg.put(CELL_EDITOR_IMG_DOTS_BUTTON, ImageDescriptor.createFromFile(
                getImportData!("dwtx.jface.images.dots_button.gif")));//$NON-NLS-1$
    }

    /**
     * Internal class for laying out the dialog.
     */
    private class DialogCellLayout : Layout {
        public override void layout(Composite editor, bool force) {
            Rectangle bounds = editor.getClientArea();
            Point size = button.computeSize(DWT.DEFAULT, DWT.DEFAULT, force);
            if (contents !is null) {
                contents.setBounds(0, 0, bounds.width - size.x, bounds.height);
            }
            button.setBounds(bounds.width - size.x, 0, size.x, bounds.height);
        }

        public override Point computeSize(Composite editor, int wHint, int hHint,
                bool force) {
            if (wHint !is DWT.DEFAULT && hHint !is DWT.DEFAULT) {
                return new Point(wHint, hHint);
            }
            Point contentsSize = contents.computeSize(DWT.DEFAULT, DWT.DEFAULT,
                    force);
            Point buttonSize = button.computeSize(DWT.DEFAULT, DWT.DEFAULT,
                    force);
            // Just return the button width to ensure the button is not clipped
            // if the label is long.
            // The label will just use whatever extra width there is
            Point result = new Point(buttonSize.x, Math.max(contentsSize.y,
                    buttonSize.y));
            return result;
        }
    }

    /**
     * Default DialogCellEditor style
     */
    private static const int defaultStyle = DWT.NONE;

    /**
     * Creates a new dialog cell editor with no control
     * @since 2.1
     */
    public this() {
        setStyle(defaultStyle);
    }

    /**
     * Creates a new dialog cell editor parented under the given control.
     * The cell editor value is <code>null</code> initially, and has no
     * validator.
     *
     * @param parent the parent control
     */
    protected this(Composite parent) {
        this(parent, defaultStyle);
    }

    /**
     * Creates a new dialog cell editor parented under the given control.
     * The cell editor value is <code>null</code> initially, and has no
     * validator.
     *
     * @param parent the parent control
     * @param style the style bits
     * @since 2.1
     */
    protected this(Composite parent, int style) {
        super(parent, style);
    }

    /**
     * Creates the button for this cell editor under the given parent control.
     * <p>
     * The default implementation of this framework method creates the button
     * display on the right hand side of the dialog cell editor. Subclasses
     * may extend or reimplement.
     * </p>
     *
     * @param parent the parent control
     * @return the new button control
     */
    protected Button createButton(Composite parent) {
        Button result = new Button(parent, DWT.DOWN);
        result.setText("..."); //$NON-NLS-1$
        return result;
    }

    /**
     * Creates the controls used to show the value of this cell editor.
     * <p>
     * The default implementation of this framework method creates
     * a label widget, using the same font and background color as the parent control.
     * </p>
     * <p>
     * Subclasses may reimplement.  If you reimplement this method, you
     * should also reimplement <code>updateContents</code>.
     * </p>
     *
     * @param cell the control for this cell editor
     * @return the underlying control
     */
    protected Control createContents(Composite cell) {
        defaultLabel = new Label(cell, DWT.LEFT);
        defaultLabel.setFont(cell.getFont());
        defaultLabel.setBackground(cell.getBackground());
        return defaultLabel;
    }

    /* (non-Javadoc)
     * Method declared on CellEditor.
     */
    protected override Control createControl(Composite parent) {

        Font font = parent.getFont();
        Color bg = parent.getBackground();

        editor = new Composite(parent, getStyle());
        editor.setFont(font);
        editor.setBackground(bg);
        editor.setLayout(new DialogCellLayout());

        contents = createContents(editor);
        updateContents(value);

        button = createButton(editor);
        button.setFont(font);

        button.addKeyListener(new class KeyAdapter {
            /* (non-Javadoc)
             * @see dwt.events.KeyListener#keyReleased(dwt.events.KeyEvent)
             */
            public void keyReleased(KeyEvent e) {
                if (e.character is '\u001b') { // Escape
                    fireCancelEditor();
                }
            }
        });

        button.addFocusListener(getButtonFocusListener());

        button.addSelectionListener(new class SelectionAdapter {
            /* (non-Javadoc)
             * @see dwt.events.SelectionListener#widgetSelected(dwt.events.SelectionEvent)
             */
            public void widgetSelected(SelectionEvent event) {
                // Remove the button's focus listener since it's guaranteed
                // to lose focus when the dialog opens
                button.removeFocusListener(getButtonFocusListener());

                Object newValue = openDialogBox(editor);

                // Re-add the listener once the dialog closes
                button.addFocusListener(getButtonFocusListener());

                if (newValue !is null) {
                    bool newValidState = isCorrect(newValue);
                    if (newValidState) {
                        markDirty();
                        doSetValue(newValue);
                    } else {
                        // try to insert the current value into the error message.
                        setErrorMessage(Format(getErrorMessage(),
                                newValue.toString() ));
                    }
                    fireApplyEditorValue();
                }
            }
        });

        setValueValid(true);

        return editor;
    }

    /* (non-Javadoc)
     *
     * Override in order to remove the button's focus listener if the celleditor
     * is deactivating.
     *
     * @see dwtx.jface.viewers.CellEditor#deactivate()
     */
    public override void deactivate() {
        if (button !is null && !button.isDisposed()) {
            button.removeFocusListener(getButtonFocusListener());
        }

        super.deactivate();
    }

    /* (non-Javadoc)
     * Method declared on CellEditor.
     */
    protected override Object doGetValue() {
        return value;
    }

    /* (non-Javadoc)
     * Method declared on CellEditor.
     * The focus is set to the cell editor's button.
     */
    protected override void doSetFocus() {
        button.setFocus();

        // add a FocusListener to the button
        button.addFocusListener(getButtonFocusListener());
    }

    /**
     * Return a listener for button focus.
     * @return FocusListener
     */
    private FocusListener getButtonFocusListener() {
        if (buttonFocusListener is null) {
            buttonFocusListener = new class FocusListener {

                /* (non-Javadoc)
                 * @see dwt.events.FocusListener#focusGained(dwt.events.FocusEvent)
                 */
                public void focusGained(FocusEvent e) {
                    // Do nothing
                }

                /* (non-Javadoc)
                 * @see dwt.events.FocusListener#focusLost(dwt.events.FocusEvent)
                 */
                public void focusLost(FocusEvent e) {
                    this.outer.focusLost();
                }
            };
        }

        return buttonFocusListener;
    }

    /* (non-Javadoc)
     * Method declared on CellEditor.
     */
    protected override void doSetValue(Object value) {
        this.value = value;
        updateContents(value);
    }

    /**
     * Returns the default label widget created by <code>createContents</code>.
     *
     * @return the default label widget
     */
    protected Label getDefaultLabel() {
        return defaultLabel;
    }

    /**
     * Opens a dialog box under the given parent control and returns the
     * dialog's value when it closes, or <code>null</code> if the dialog
     * was canceled or no selection was made in the dialog.
     * <p>
     * This framework method must be implemented by concrete subclasses.
     * It is called when the user has pressed the button and the dialog
     * box must pop up.
     * </p>
     *
     * @param cellEditorWindow the parent control cell editor's window
     *   so that a subclass can adjust the dialog box accordingly
     * @return the selected value, or <code>null</code> if the dialog was
     *   canceled or no selection was made in the dialog
     */
    protected abstract Object openDialogBox(Control cellEditorWindow);

    /**
     * Updates the controls showing the value of this cell editor.
     * <p>
     * The default implementation of this framework method just converts
     * the passed object to a string using <code>toString</code> and
     * sets this as the text of the label widget.
     * </p>
     * <p>
     * Subclasses may reimplement.  If you reimplement this method, you
     * should also reimplement <code>createContents</code>.
     * </p>
     *
     * @param value the new value of this cell editor
     */
    protected void updateContents(Object value) {
        if (defaultLabel is null) {
            return;
        }

        String text = "";//$NON-NLS-1$
        if (value !is null) {
            text = value.toString();
        }
        defaultLabel.setText(text);
    }
}
