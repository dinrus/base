/*******************************************************************************
 * Copyright (c) 2006 Tom Schindl and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
 *                                                 bugfix in 174739
 *     Eric Rizzo - bug 213315
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/

module dwtx.jface.viewers.ComboBoxViewerCellEditor;

import dwtx.jface.viewers.AbstractComboBoxCellEditor;
import dwtx.jface.viewers.ComboViewer;
import dwtx.jface.viewers.IStructuredContentProvider;
import dwtx.jface.viewers.CellEditor;
import dwtx.jface.viewers.IBaseLabelProvider;
import dwtx.jface.viewers.ISelection;
import dwtx.jface.viewers.IStructuredSelection;
import dwtx.jface.viewers.StructuredSelection;

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

/**
 * A cell editor that presents a list of items in a combo box. In contrast to
 * {@link ComboBoxCellEditor} it wraps the underlying {@link CCombo} using a
 * {@link ComboViewer}
 * @since 3.4
 */
public class ComboBoxViewerCellEditor : AbstractComboBoxCellEditor {

    /**
     * The custom combo box control.
     */
    ComboViewer viewer;

    Object selectedValue;

    /**
     * Default ComboBoxCellEditor style
     */
    private static const int defaultStyle = DWT.NONE;

    /**
     * Creates a new cell editor with a combo viewer and a default style
     *
     * @param parent
     *            the parent control
     */
    public this(Composite parent) {
        this(parent, defaultStyle);
    }

    /**
     * Creates a new cell editor with a combo viewer and the given style
     *
     * @param parent
     *            the parent control
     * @param style
     *            the style bits
     */
    public this(Composite parent, int style) {
        super(parent, style);
        setValueValid(true);
    }

    /*
     * (non-Javadoc) Method declared on CellEditor.
     */
    protected Control createControl(Composite parent) {

        CCombo comboBox = new CCombo(parent, getStyle());
        comboBox.setFont(parent.getFont());
        viewer = new ComboViewer(comboBox);

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
                ISelection selection = viewer.getSelection();
                if (selection.isEmpty()) {
                    selectedValue = null;
                } else {
                    selectedValue = (cast(IStructuredSelection) selection)
                            .getFirstElement();
                }
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
    protected Object doGetValue() {
        return selectedValue;
    }

    /*
     * (non-Javadoc) Method declared on CellEditor.
     */
    protected void doSetFocus() {
        viewer.getControl().setFocus();
    }

    /**
     * The <code>ComboBoxCellEditor</code> implementation of this
     * <code>CellEditor</code> framework method sets the minimum width of the
     * cell. The minimum width is 10 characters if <code>comboBox</code> is
     * not <code>null</code> or <code>disposed</code> eles it is 60 pixels
     * to make sure the arrow button and some text is visible. The list of
     * CCombo will be wide enough to show its longest item.
     */
    public LayoutData getLayoutData() {
        LayoutData layoutData = super.getLayoutData();
        if ((viewer.getControl() is null) || viewer.getControl().isDisposed()) {
            layoutData.minimumWidth = 60;
        } else {
            // make the comboBox 10 characters wide
            GC gc = new GC(viewer.getControl());
            layoutData.minimumWidth = (gc.getFontMetrics()
                    .getAverageCharWidth() * 10) + 10;
            gc.dispose();
        }
        return layoutData;
    }

    /**
     * Set a new value
     *
     * @param value
     *            the new value
     */
    protected void doSetValue(Object value) {
        Assert.isTrue(viewer !is null);
        selectedValue = value;
        if (value is null) {
            viewer.setSelection(StructuredSelection.EMPTY);
        } else {
            viewer.setSelection(new StructuredSelection(value));
        }
    }

    /**
     * @param labelProvider
     *            the label provider used
     * @see StructuredViewer#setLabelProvider(IBaseLabelProvider)
     */
    public void setLabelProvider(IBaseLabelProvider labelProvider) {
        viewer.setLabelProvider(labelProvider);
    }

    /**
     * @param provider
     *            the content provider used
     * @see StructuredViewer#setContentProvider(IContentProvider)
     */
    public void setContenProvider(IStructuredContentProvider provider) {
        viewer.setContentProvider(provider);
    }

    /**
     * @param input
     *            the input used
     * @see StructuredViewer#setInput(Object)
     */
    public void setInput(Object input) {
        viewer.setInput(input);
    }

    /**
     * @return get the viewer
     */
    public ComboViewer getViewer() {
        return viewer;
    }

    /**
     * Applies the currently selected value and deactiavates the cell editor
     */
    void applyEditorValueAndDeactivate() {
        // must set the selection before getting value
        ISelection selection = viewer.getSelection();
        if (selection.isEmpty()) {
            selectedValue = null;
        } else {
            selectedValue = (cast(IStructuredSelection) selection)
                    .getFirstElement();
        }

        Object newValue = doGetValue();
        markDirty();
        bool isValid = isCorrect(newValue);
        setValueValid(isValid);

        if (!isValid) {
        //DWT: the result is not used?
//             MessageFormat.format(getErrorMessage(),
//                     [ selectedValue ]);
        }

        fireApplyEditorValue();
        deactivate();
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.CellEditor#focusLost()
     */
    protected void focusLost() {
        if (isActivated()) {
            applyEditorValueAndDeactivate();
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.CellEditor#keyReleaseOccured(dwt.events.KeyEvent)
     */
    protected void keyReleaseOccured(KeyEvent keyEvent) {
        if (keyEvent.character is '\u001b') { // Escape character
            fireCancelEditor();
        } else if (keyEvent.character is '\t') { // tab key
            applyEditorValueAndDeactivate();
        }
    }
}
