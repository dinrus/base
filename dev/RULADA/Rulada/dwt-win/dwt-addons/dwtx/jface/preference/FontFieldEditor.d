/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module dwtx.jface.preference.FontFieldEditor;

import dwtx.jface.preference.FieldEditor;
import dwtx.jface.preference.PreferenceConverter;

import dwt.DWT;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.graphics.Font;
import dwt.graphics.FontData;
import dwt.layout.GridData;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.FontDialog;
import dwt.widgets.Label;
import dwt.widgets.Text;
import dwtx.core.runtime.Assert;
import dwtx.jface.dialogs.IDialogConstants;
import dwtx.jface.resource.JFaceResources;
import dwtx.jface.resource.StringConverter;

import dwt.dwthelper.utils;

/**
 * A field editor for a font type preference.
 */
public class FontFieldEditor : FieldEditor {

    /**
     * The change font button, or <code>null</code> if none
     * (before creation and after disposal).
     */
    private Button changeFontButton = null;

    /**
     * The text for the change font button, or <code>null</code>
     * if missing.
     */
    private String changeButtonText;

    /**
     * The text for the preview, or <code>null</code> if no preview is desired
     */
    private String previewText;

    /**
     * Font data for the chosen font button, or <code>null</code> if none.
     */
    private FontData[] chosenFont;

    /**
     * The label that displays the selected font, or <code>null</code> if none.
     */
    private Label valueControl;

    /**
     * The previewer, or <code>null</code> if none.
     */
    private DefaultPreviewer previewer;

    /**
     * Internal font previewer implementation.
     */
    private static class DefaultPreviewer {
        private Text text;

        private String string;

        private Font font;

        /**
         * Constructor for the previewer.
         * @param s
         * @param parent
         */
        public this(String s, Composite parent) {
            string = s;
            text = new Text(parent, DWT.READ_ONLY | DWT.BORDER);
            text.addDisposeListener(new class DisposeListener {
                public void widgetDisposed(DisposeEvent e) {
                    if (font !is null) {
                        font.dispose();
                    }
                }
            });
            if (string !is null) {
                text.setText(string);
            }
        }

        /**
         * @return the control the previewer is using
         */
        public Control getControl() {
            return text;
        }

        /**
         * Set the font to display with
         * @param fontData
         */
        public void setFont(FontData[] fontData) {
            if (font !is null) {
                font.dispose();
            }
            font = new Font(text.getDisplay(), fontData);
            text.setFont(font);
        }

        /**
         * @return the preferred size of the previewer.
         */
        public int getPreferredExtent() {
            return 40;
        }
    }

    /**
     * Creates a new font field editor
     */
    protected this() {
    }

    /**
     * Creates a font field editor with an optional preview area.
     *
     * @param name the name of the preference this field editor works on
     * @param labelText the label text of the field editor
     * @param previewAreaText the text used for the preview window. If it is
     * <code>null</code> there will be no preview area,
     * @param parent the parent of the field editor's control
     */
    public this(String name, String labelText,
            String previewAreaText, Composite parent) {
        init(name, labelText);
        previewText = previewAreaText;
        changeButtonText = JFaceResources.getString("openChange"); //$NON-NLS-1$
        createControl(parent);

    }

    /**
     * Creates a font field editor without a preview.
     *
     * @param name the name of the preference this field editor works on
     * @param labelText the label text of the field editor
     * @param parent the parent of the field editor's control
     */
    public this(String name, String labelText, Composite parent) {
        this(name, labelText, null, parent);

    }

    /* (non-Javadoc)
     * Method declared on FieldEditor.
     */
    protected override void adjustForNumColumns(int numColumns) {

        GridData data = new GridData();
        if (valueControl.getLayoutData() !is null) {
            data = cast(GridData) valueControl.getLayoutData();
        }

        data.horizontalSpan = numColumns - getNumberOfControls() + 1;
        valueControl.setLayoutData(data);
    }

    /* (non-Javadoc)
     * Method declared on FieldEditor.
     */
    protected override void applyFont() {
        if (chosenFont !is null && previewer !is null) {
            previewer.setFont(chosenFont);
        }
    }

    /* (non-Javadoc)
     * Method declared on FieldEditor.
     */
    protected override void doFillIntoGrid(Composite parent, int numColumns) {
        getLabelControl(parent);

        valueControl = getValueControl(parent);

        GridData gd = new GridData(GridData.FILL_HORIZONTAL
                | GridData.GRAB_HORIZONTAL);
        gd.horizontalSpan = numColumns - getNumberOfControls() + 1;
        valueControl.setLayoutData(gd);
        if (previewText !is null) {
            previewer = new DefaultPreviewer(previewText, parent);
            gd = new GridData(GridData.FILL_HORIZONTAL);
            gd.heightHint = previewer.getPreferredExtent();
            gd.widthHint = previewer.getPreferredExtent();
            previewer.getControl().setLayoutData(gd);
        }

        changeFontButton = getChangeControl(parent);
        gd = new GridData();
        int widthHint = convertHorizontalDLUsToPixels(changeFontButton,
                IDialogConstants.BUTTON_WIDTH);
        gd.widthHint = Math.max(widthHint, changeFontButton.computeSize(
                DWT.DEFAULT, DWT.DEFAULT, true).x);
        changeFontButton.setLayoutData(gd);

    }

    /* (non-Javadoc)
     * Method declared on FieldEditor.
     */
    protected override void doLoad() {
        if (changeFontButton is null) {
            return;
        }
        updateFont(PreferenceConverter.getFontDataArray(getPreferenceStore(),
                getPreferenceName()));
    }

    /* (non-Javadoc)
     * Method declared on FieldEditor.
     */
    protected override void doLoadDefault() {
        if (changeFontButton is null) {
            return;
        }
        updateFont(PreferenceConverter.getDefaultFontDataArray(
                getPreferenceStore(), getPreferenceName()));
    }

    /* (non-Javadoc)
     * Method declared on FieldEditor.
     */
    protected override void doStore() {
        if (chosenFont !is null) {
            PreferenceConverter.setValue(getPreferenceStore(),
                    getPreferenceName(), chosenFont);
        }
    }

    /**
     * Returns the change button for this field editor.
     *
     * @param parent The Composite to create the button in if required.
     * @return the change button
     */
    protected Button getChangeControl(Composite parent) {
        if (changeFontButton is null) {
            changeFontButton = new Button(parent, DWT.PUSH);
            if (changeButtonText !is null) {
                changeFontButton.setText(changeButtonText);
            }
            changeFontButton.addSelectionListener(new class SelectionAdapter {
                public void widgetSelected(SelectionEvent event) {
                    FontDialog fontDialog = new FontDialog(changeFontButton
                            .getShell());
                    if (chosenFont !is null) {
                        fontDialog.setFontList(chosenFont);
                    }
                    FontData font = fontDialog.open();
                    if (font !is null) {
                        FontData[] oldFont = chosenFont;
                        if (oldFont is null) {
                            oldFont = JFaceResources.getDefaultFont()
                                    .getFontData();
                        }
                        setPresentsDefaultValue(false);
                        FontData[] newData = new FontData[1];
                        newData[0] = font;
                        updateFont(newData);
                        fireValueChanged(VALUE, oldFont[0], font);
                    }

                }
            });
            changeFontButton.addDisposeListener(new class DisposeListener {
                public void widgetDisposed(DisposeEvent event) {
                    changeFontButton = null;
                }
            });
            changeFontButton.setFont(parent.getFont());
            setButtonLayoutData(changeFontButton);
        } else {
            checkParent(changeFontButton, parent);
        }
        return changeFontButton;
    }

    /* (non-Javadoc)
     * Method declared on FieldEditor.
     */
    public override int getNumberOfControls() {
        if (previewer is null) {
            return 3;
        }

        return 4;
    }

    /**
     * Returns the preferred preview height.
     *
     * @return the height, or <code>-1</code> if no previewer
     *  is installed
     */
    public int getPreferredPreviewHeight() {
        if (previewer is null) {
            return -1;
        }
        return previewer.getPreferredExtent();
    }

    /**
     * Returns the preview control for this field editor.
     *
     * @return the preview control
     */
    public Control getPreviewControl() {
        if (previewer is null) {
            return null;
        }

        return previewer.getControl();
    }

    /**
     * Returns the value control for this field editor. The value control
     * displays the currently selected font name.
     * @param parent The Composite to create the viewer in if required
     * @return the value control
     */
    protected Label getValueControl(Composite parent) {
        if (valueControl is null) {
            valueControl = new Label(parent, DWT.LEFT);
            valueControl.setFont(parent.getFont());
            valueControl.addDisposeListener(new class DisposeListener {
                public void widgetDisposed(DisposeEvent event) {
                    valueControl = null;
                }
            });
        } else {
            checkParent(valueControl, parent);
        }
        return valueControl;
    }

    /**
     * Sets the text of the change button.
     *
     * @param text the new text
     */
    public void setChangeButtonText(String text) {
        Assert.isNotNull(text);
        changeButtonText = text;
        if (changeFontButton !is null) {
            changeFontButton.setText(text);
        }
    }

    /**
     * Updates the change font button and the previewer to reflect the
     * newly selected font.
     * @param font The FontData[] to update with.
     */
    private void updateFont(FontData font[]) {
        FontData[] bestFont = JFaceResources.getFontRegistry().filterData(
                font, valueControl.getDisplay());

        //if we have nothing valid do as best we can
        if (bestFont is null) {
            bestFont = getDefaultFontData();
        }

        //Now cache this value in the receiver
        this.chosenFont = bestFont;

        if (valueControl !is null) {
            valueControl.setText(StringConverter.asString(chosenFont[0]));
        }
        if (previewer !is null) {
            previewer.setFont(bestFont);
        }
    }

    /**
     * Store the default preference for the field
     * being edited
     */
    protected void setToDefault() {
        FontData[] defaultFontData = PreferenceConverter
                .getDefaultFontDataArray(getPreferenceStore(),
                        getPreferenceName());
        PreferenceConverter.setValue(getPreferenceStore(), getPreferenceName(),
                defaultFontData);
    }

    /**
     * Get the system default font data.
     * @return FontData[]
     */
    private FontData[] getDefaultFontData() {
        return valueControl.getDisplay().getSystemFont().getFontData();
    }

    /*
     * @see FieldEditor.setEnabled(bool,Composite).
     */
    public override void setEnabled(bool enabled, Composite parent) {
        super.setEnabled(enabled, parent);
        getChangeControl(parent).setEnabled(enabled);
        getValueControl(parent).setEnabled(enabled);
    }

}
