/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Tom Schindl <tom.schindl@bestsolution.at> - bugfix in 174739
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/

module dwtx.jface.viewers.ComboBoxCellEditor;

import dwtx.jface.viewers.CellEditor;
import dwtx.jface.viewers.AbstractComboBoxCellEditor;

import dwt.DWT;
import dwt.custom.CCombo;
import dwt.events.FocusAdapter;
import dwt.events.FocusEvent;
import dwt.events.KeyAdapter;
import dwt.events.KeyEvent;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.events.TraverseEvent;
import dwt.events.TraverseListener;
import dwt.graphics.GC;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwtx.core.runtime.Assert;

import dwt.dwthelper.utils;
import tango.text.convert.Format;

/**
 * A cell editor that presents a list of items in a combo box. The cell editor's
 * value is the zero-based index of the selected item.
 * <p>
 * This class may be instantiated; it is not intended to be subclassed.
 * </p>
 * @noextend This class is not intended to be subclassed by clients.
 */
public class ComboBoxCellEditor : AbstractComboBoxCellEditor {

    /**
     * The list of items to present in the combo box.
     */
    private String[] items;

    /**
     * The zero-based index of the selected item.
     */
    int selection;

    /**
     * The custom combo box control.
     */
    CCombo comboBox;

    /**
     * Default ComboBoxCellEditor style
     */
    private static const int defaultStyle = DWT.NONE;

    /**
     * Creates a new cell editor with no control and no st of choices.
     * Initially, the cell editor has no cell validator.
     *
     * @since 2.1
     * @see CellEditor#setStyle
     * @see CellEditor#create
     * @see ComboBoxCellEditor#setItems
     * @see CellEditor#dispose
     */
    public this() {
        setStyle(defaultStyle);
    }

    /**
     * Creates a new cell editor with a combo containing the given list of
     * choices and parented under the given control. The cell editor value is
     * the zero-based index of the selected item. Initially, the cell editor has
     * no cell validator and the first item in the list is selected.
     *
     * @param parent
     *            the parent control
     * @param items
     *            the list of strings for the combo box
     */
    public this(Composite parent, String[] items) {
        this(parent, items, defaultStyle);
    }

    /**
     * Creates a new cell editor with a combo containing the given list of
     * choices and parented under the given control. The cell editor value is
     * the zero-based index of the selected item. Initially, the cell editor has
     * no cell validator and the first item in the list is selected.
     *
     * @param parent
     *            the parent control
     * @param items
     *            the list of strings for the combo box
     * @param style
     *            the style bits
     * @since 2.1
     */
    public this(Composite parent, String[] items, int style) {
        super(parent, style);
        setItems(items);
    }

    /**
     * Returns the list of choices for the combo box
     *
     * @return the list of choices for the combo box
     */
    public String[] getItems() {
        return this.items;
    }

    /**
     * Sets the list of choices for the combo box
     *
     * @param items
     *            the list of choices for the combo box
     */
    public void setItems(String[] items) {
//         Assert.isNotNull(items);
        this.items = items;
        populateComboBoxItems();
    }

    /*
     * (non-Javadoc) Method declared on CellEditor.
     */
    protected override Control createControl(Composite parent) {

        comboBox = new CCombo(parent, getStyle());
        comboBox.setFont(parent.getFont());

        populateComboBoxItems();

        comboBox.addKeyListener(new class KeyAdapter {
            // hook key pressed - see PR 14201
            public void keyPressed(KeyEvent e) {
                keyReleaseOccured(e);
            }
        });

        comboBox.addSelectionListener(new class SelectionAdapter {
            public void widgetDefaultSelected(SelectionEvent event) {
                applyEditorValueAndDeactivate();
            }

            public void widgetSelected(SelectionEvent event) {
                selection = comboBox.getSelectionIndex();
            }
        });

        comboBox.addTraverseListener(new class TraverseListener {
            public void keyTraversed(TraverseEvent e) {
                if (e.detail is DWT.TRAVERSE_ESCAPE
                        || e.detail is DWT.TRAVERSE_RETURN) {
                    e.doit = false;
                }
            }
        });

        comboBox.addFocusListener(new class FocusAdapter {
            public void focusLost(FocusEvent e) {
                this.outer.focusLost();
            }
        });
        return comboBox;
    }

    /**
     * The <code>ComboBoxCellEditor</code> implementation of this
     * <code>CellEditor</code> framework method returns the zero-based index
     * of the current selection.
     *
     * @return the zero-based index of the current selection wrapped as an
     *         <code>Integer</code>
     */
    protected override Object doGetValue() {
        return new ValueWrapperInt(selection);
    }

    /*
     * (non-Javadoc) Method declared on CellEditor.
     */
    protected override void doSetFocus() {
        comboBox.setFocus();
    }

    /**
     * The <code>ComboBoxCellEditor</code> implementation of this
     * <code>CellEditor</code> framework method sets the minimum width of the
     * cell. The minimum width is 10 characters if <code>comboBox</code> is
     * not <code>null</code> or <code>disposed</code> else it is 60 pixels
     * to make sure the arrow button and some text is visible. The list of
     * CCombo will be wide enough to show its longest item.
     */
    public override LayoutData getLayoutData() {
        LayoutData layoutData = super.getLayoutData();
        if ((comboBox is null) || comboBox.isDisposed()) {
            layoutData.minimumWidth = 60;
        } else {
            // make the comboBox 10 characters wide
            GC gc = new GC(comboBox);
            layoutData.minimumWidth = (gc.getFontMetrics()
                    .getAverageCharWidth() * 10) + 10;
            gc.dispose();
        }
        return layoutData;
    }

    /**
     * The <code>ComboBoxCellEditor</code> implementation of this
     * <code>CellEditor</code> framework method accepts a zero-based index of
     * a selection.
     *
     * @param value
     *            the zero-based index of the selection wrapped as an
     *            <code>Integer</code>
     */
    protected override void doSetValue(Object value) {
        Assert.isTrue(comboBox !is null && (cast(ValueWrapperInt)value ));
        selection = (cast(ValueWrapperInt) value).value;
        comboBox.select(selection);
    }

    /**
     * Updates the list of choices for the combo box for the current control.
     */
    private void populateComboBoxItems() {
        if (comboBox !is null && items !is null) {
            comboBox.removeAll();
            for (int i = 0; i < items.length; i++) {
                comboBox.add(items[i], i);
            }

            setValueValid(true);
            selection = 0;
        }
    }

    /**
     * Applies the currently selected value and deactivates the cell editor
     */
    void applyEditorValueAndDeactivate() {
        // must set the selection before getting value
        selection = comboBox.getSelectionIndex();
        Object newValue = doGetValue();
        markDirty();
        bool isValid = isCorrect(newValue);
        setValueValid(isValid);

        if (!isValid) {
            // Only format if the 'index' is valid
            if (items.length > 0 && selection >= 0 && selection < items.length) {
                // try to insert the current value into the error message.
                setErrorMessage(Format(getErrorMessage(),
                        [ items[selection] ]));
            } else {
                // Since we don't have a valid index, assume we're using an
                // 'edit'
                // combo so format using its text value
                setErrorMessage(Format(getErrorMessage(),
                        [ comboBox.getText() ]));
            }
        }

        fireApplyEditorValue();
        deactivate();
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.CellEditor#focusLost()
     */
    protected override void focusLost() {
        if (isActivated()) {
            applyEditorValueAndDeactivate();
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.CellEditor#keyReleaseOccured(dwt.events.KeyEvent)
     */
    protected override void keyReleaseOccured(KeyEvent keyEvent) {
        if (keyEvent.character is '\u001b') { // Escape character
            fireCancelEditor();
        } else if (keyEvent.character is '\t') { // tab key
            applyEditorValueAndDeactivate();
        }
    }
}
