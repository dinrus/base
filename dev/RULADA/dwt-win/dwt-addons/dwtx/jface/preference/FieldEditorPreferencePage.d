/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Chris Tilt (chris@tilts.net) - Bug 38547 - [Preferences] Changing preferences
 *          ignored after "Restore defaults" pressed.
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.preference.FieldEditorPreferencePage;

import dwtx.jface.preference.PreferencePage;
import dwtx.jface.preference.FieldEditor;
import dwtx.jface.preference.FieldEditorPreferencePage;

// import java.util.Iterator;
// import java.util.List;

import dwt.DWT;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwtx.jface.resource.ImageDescriptor;
import dwtx.jface.util.IPropertyChangeListener;
import dwtx.jface.util.PropertyChangeEvent;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

/**
 * A special abstract preference page to host field editors.
 * <p>
 * Subclasses must implement the <code>createFieldEditors</code> method
 * and should override <code>createLayout</code> if a special layout of the field
 * editors is needed.
 * </p>
 */
public abstract class FieldEditorPreferencePage : PreferencePage,
        IPropertyChangeListener {

    /**
     * Layout constant (value <code>0</code>) indicating that
     * each field editor is handled as a single component.
     */
    public static const int FLAT = 0;

    /**
     * Layout constant (value <code>1</code>) indicating that
     * the field editors' basic controls are put into a grid layout.
     */
    public static const int GRID = 1;

    /**
     * The vertical spacing used by layout styles <code>FLAT</code>
     * and <code>GRID</code>.
     */
    protected static const int VERTICAL_SPACING = 10;

    /**
     * The margin width used by layout styles <code>FLAT</code>
     * and <code>GRID</code>.
     */
    protected static const int MARGIN_WIDTH = 0;

    /**
     * The margin height used by layout styles <code>FLAT</code>
     * and <code>GRID</code>.
     */
    protected static const int MARGIN_HEIGHT = 0;

    /**
     * The field editors, or <code>null</code> if not created yet.
     */
    private List fields = null;

    /**
     * The layout style; either <code>FLAT</code> or <code>GRID</code>.
     */
    private int style;

    /**
     * The first invalid field editor, or <code>null</code>
     * if all field editors are valid.
     */
    private FieldEditor invalidFieldEditor = null;

    /**
     * The parent composite for field editors
     */
    private Composite fieldEditorParent;

    /**
     * Create a new instance of the reciever.
     */
    public this() {
        this(FLAT);
    }

    /**
     * Creates a new field editor preference page with the given style,
     * an empty title, and no image.
     *
     * @param style either <code>GRID</code> or <code>FLAT</code>
     */
    protected this(int style) {
        super();
        this.style = style;
    }

    /**
     * Creates a new field editor preference page with the given title
     * and style, but no image.
     *
     * @param title the title of this preference page
     * @param style either <code>GRID</code> or <code>FLAT</code>
     */
    protected this(String title, int style) {
        super(title);
        this.style = style;
    }

    /**
     * Creates a new field editor preference page with the given title,
     * image, and style.
     *
     * @param title the title of this preference page
     * @param image the image for this preference page, or
     *   <code>null</code> if none
     * @param style either <code>GRID</code> or <code>FLAT</code>
     */
    protected this(String title, ImageDescriptor image,
            int style) {
        super(title, image);
        this.style = style;
    }

    /**
     * Adds the given field editor to this page.
     *
     * @param editor the field editor
     */
    protected void addField(FieldEditor editor) {
        if (fields is null) {
            fields = new ArrayList();
        }
        fields.add(editor);
    }

    /**
     * Adjust the layout of the field editors so that
     * they are properly aligned.
     */
    protected void adjustGridLayout() {
        int numColumns = calcNumberOfColumns();
        (cast(GridLayout) fieldEditorParent.getLayout()).numColumns = numColumns;
        if (fields !is null) {
            for (int i = 0; i < fields.size(); i++) {
                FieldEditor fieldEditor = cast(FieldEditor) fields.get(i);
                fieldEditor.adjustForNumColumns_package(numColumns);
            }
        }
    }

    /**
     * Applys the font to the field editors managed by this page.
     */
    protected void applyFont() {
        if (fields !is null) {
            Iterator e = fields.iterator();
            while (e.hasNext()) {
                FieldEditor pe = cast(FieldEditor) e.next();
                pe.applyFont_package();
            }
        }
    }

    /**
     * Calculates the number of columns needed to host all field editors.
     *
     * @return the number of columns
     */
    private int calcNumberOfColumns() {
        int result = 0;
        if (fields !is null) {
            Iterator e = fields.iterator();
            while (e.hasNext()) {
                FieldEditor pe = cast(FieldEditor) e.next();
                result = Math.max(result, pe.getNumberOfControls());
            }
        }
        return result;
    }

    /**
     * Recomputes the page's error state by calling <code>isValid</code> for
     * every field editor.
     */
    protected void checkState() {
        bool valid = true;
        invalidFieldEditor = null;
        // The state can only be set to true if all
        // field editors contain a valid value. So we must check them all
        if (fields !is null) {
            int size = fields.size();
            for (int i = 0; i < size; i++) {
                FieldEditor editor = cast(FieldEditor) fields.get(i);
                valid = valid && editor.isValid();
                if (!valid) {
                    invalidFieldEditor = editor;
                    break;
                }
            }
        }
        setValid(valid);
    }

    /* (non-Javadoc)
     * Method declared on PreferencePage.
     */
    protected override Control createContents(Composite parent) {
        fieldEditorParent = new Composite(parent, DWT.NULL);
        GridLayout layout = new GridLayout();
        layout.numColumns = 1;
        layout.marginHeight = 0;
        layout.marginWidth = 0;
        fieldEditorParent.setLayout(layout);
        fieldEditorParent.setFont(parent.getFont());

        createFieldEditors();

        if (style is GRID) {
            adjustGridLayout();
        }

        initialize();
        checkState();
        return fieldEditorParent;
    }

    /**
     * Creates the page's field editors.
     * <p>
     * The default implementation of this framework method
     * does nothing. Subclass must implement this method to
     * create the field editors.
     * </p>
     * <p>
     * Subclasses should call <code>getFieldEditorParent</code>
     * to obtain the parent control for each field editor.
     * This same parent should not be used for more than
     * one editor as the parent may change for each field
     * editor depending on the layout style of the page
     * </p>
     */
    protected abstract void createFieldEditors();

    /**
     * The field editor preference page implementation of an <code>IDialogPage</code>
     * method disposes of this page's controls and images.
     * Subclasses may override to release their own allocated DWT
     * resources, but must call <code>super.dispose</code>.
     */
    public override void dispose() {
        super.dispose();
        if (fields !is null) {
            Iterator e = fields.iterator();
            while (e.hasNext()) {
                FieldEditor pe = cast(FieldEditor) e.next();
                pe.setPage(null);
                pe.setPropertyChangeListener(null);
                pe.setPreferenceStore(null);
            }
        }
    }

    /**
     * Returns a parent composite for a field editor.
     * <p>
     * This value must not be cached since a new parent
     * may be created each time this method called. Thus
     * this method must be called each time a field editor
     * is constructed.
     * </p>
     *
     * @return a parent
     */
    protected Composite getFieldEditorParent() {
        if (style is FLAT) {
            // Create a new parent for each field editor
            Composite parent = new Composite(fieldEditorParent, DWT.NULL);
            parent.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
            return parent;
        }
        // Just return the parent
        return fieldEditorParent;
    }

    /**
     * Initializes all field editors.
     */
    protected void initialize() {
        if (fields !is null) {
            Iterator e = fields.iterator();
            while (e.hasNext()) {
                FieldEditor pe = cast(FieldEditor) e.next();
                pe.setPage(this);
                pe.setPropertyChangeListener(this);
                pe.setPreferenceStore(getPreferenceStore());
                pe.load();
            }
        }
    }

    /**
     * The field editor preference page implementation of a <code>PreferencePage</code>
     * method loads all the field editors with their default values.
     */
    protected override void performDefaults() {
        if (fields !is null) {
            Iterator e = fields.iterator();
            while (e.hasNext()) {
                FieldEditor pe = cast(FieldEditor) e.next();
                pe.loadDefault();
            }
        }
        // Force a recalculation of my error state.
        checkState();
        super.performDefaults();
    }

    /**
     * The field editor preference page implementation of this
     * <code>PreferencePage</code> method saves all field editors by
     * calling <code>FieldEditor.store</code>. Note that this method
     * does not save the preference store itself; it just stores the
     * values back into the preference store.
     *
     * @see FieldEditor#store()
     */
    public override bool performOk() {
        if (fields !is null) {
            Iterator e = fields.iterator();
            while (e.hasNext()) {
                FieldEditor pe = cast(FieldEditor) e.next();
                pe.store();
                pe.setPresentsDefaultValue_package(false);
            }
        }
        return true;
    }

    /**
     * The field editor preference page implementation of this <code>IPreferencePage</code>
     * (and <code>IPropertyChangeListener</code>) method intercepts <code>IS_VALID</code>
     * events but passes other events on to its superclass.
     */
    public void propertyChange(PropertyChangeEvent event) {

        if (event.getProperty().equals(FieldEditor.IS_VALID)) {
            bool newValue = (cast(Boolean) event.getNewValue()).booleanValue();
            // If the new value is true then we must check all field editors.
            // If it is false, then the page is invalid in any case.
            if (newValue) {
                checkState();
            } else {
                invalidFieldEditor = cast(FieldEditor) event.getSource();
                setValid(newValue);
            }
        }
    }

    /* (non-Javadoc)
     * Method declared on IDialog.
     */
    public override void setVisible(bool visible) {
        super.setVisible(visible);
        if (visible && invalidFieldEditor !is null) {
            invalidFieldEditor.setFocus();
        }
    }
}
