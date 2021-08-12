/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Sebastian Davids <sdavids@gmx.de> - Fix for bug 38729 - [Preferences]
 *           NPE PreferencePage isValid.
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.preference.PreferencePage;

import dwtx.jface.preference.IPreferencePage;
import dwtx.jface.preference.IPreferenceStore;
import dwtx.jface.preference.IPreferencePageContainer;

import dwt.DWT;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.graphics.Font;
import dwt.graphics.Point;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Event;
import dwt.widgets.Label;
import dwtx.jface.dialogs.Dialog;
import dwtx.jface.dialogs.DialogPage;
import dwtx.jface.dialogs.IDialogConstants;
import dwtx.jface.dialogs.IDialogPage;
import dwtx.jface.resource.ImageDescriptor;
import dwtx.jface.resource.JFaceResources;
import dwtx.jface.util.IPropertyChangeListener;
import dwtx.jface.util.PropertyChangeEvent;

import dwt.dwthelper.utils;

/**
 * Abstract base implementation for all preference page implementations.
 * <p>
 * Subclasses must implement the <code>createControl</code> framework
 * method to supply the page's main control.
 * </p>
 * <p>
 * Subclasses should extend the <code>doComputeSize</code> framework
 * method to compute the size of the page's control.
 * </p>
 * <p>
 * Subclasses may override the <code>performOk</code>, <code>performApply</code>,
 * <code>performDefaults</code>, <code>performCancel</code>, and <code>performHelp</code>
 * framework methods to react to the standard button events.
 * </p>
 * <p>
 * Subclasses may call the <code>noDefaultAndApplyButton</code> framework
 * method before the page's control has been created to suppress
 * the standard Apply and Defaults buttons.
 * </p>
 */
public abstract class PreferencePage : DialogPage,
        IPreferencePage {
    alias DialogPage.setMessage setMessage;

    /**
     * Preference store, or <code>null</code>.
     */
    private IPreferenceStore preferenceStore;

    /**
     * Valid state for this page; <code>true</code> by default.
     *
     * @see #isValid
     */
    private bool isValid_ = true;

    /**
     * Body of page.
     */
    private Control body_;

    /**
     * Whether this page has the standard Apply and Defaults buttons;
     * <code>true</code> by default.
     *
     * @see #noDefaultAndApplyButton
     */
    private bool createDefaultAndApplyButton = true;

    /**
     * Standard Defaults button, or <code>null</code> if none.
     * This button has id <code>DEFAULTS_ID</code>.
     */
    private Button defaultsButton = null;

    /**
     * The container this preference page belongs to; <code>null</code>
     * if none.
     */
    private IPreferencePageContainer container = null;

    /**
     * Standard Apply button, or <code>null</code> if none.
     * This button has id <code>APPLY_ID</code>.
     */
    private Button applyButton = null;

    /**
     * Description label.
     *
     * @see #createDescriptionLabel(Composite)
     */
    private Label descriptionLabel;

    /**
     * Caches size of page.
     */
    private Point size = null;


    /**
     * Creates a new preference page with an empty title and no image.
     */
    protected this() {
        this(""); //$NON-NLS-1$
    }

    /**
     * Creates a new preference page with the given title and no image.
     *
     * @param title the title of this preference page
     */
    protected this(String title) {
        super(title);
    }

    /**
     * Creates a new abstract preference page with the given title and image.
     *
     * @param title the title of this preference page
     * @param image the image for this preference page,
     *  or <code>null</code> if none
     */
    protected this(String title, ImageDescriptor image) {
        super(title, image);
    }

    /**
     * Computes the size for this page's UI control.
     * <p>
     * The default implementation of this <code>IPreferencePage</code>
     * method returns the size set by <code>setSize</code>; if no size
     * has been set, but the page has a UI control, the framework
     * method <code>doComputeSize</code> is called to compute the size.
     * </p>
     *
     * @return the size of the preference page encoded as
     *   <code>new Point(width,height)</code>, or
     *   <code>(0,0)</code> if the page doesn't currently have any UI component
     */
    public Point computeSize() {
        if (size !is null) {
            return size;
        }
        Control control = getControl();
        if (control !is null) {
            size = doComputeSize();
            return size;
        }
        return new Point(0, 0);
    }

    /**
     * Contributes additional buttons to the given composite.
     * <p>
     * The default implementation of this framework hook method does
     * nothing. Subclasses should override this method to contribute buttons
     * to this page's button bar. For each button a subclass contributes,
     * it must also increase the parent's grid layout number of columns
     * by one; that is,
     * <pre>
     * ((GridLayout) parent.getLayout()).numColumns++);
     * </pre>
     * </p>
     *
     * @param parent the button bar
     */
    protected void contributeButtons(Composite parent) {
    }

    /**
     * Creates and returns the DWT control for the customized body
     * of this preference page under the given parent composite.
     * <p>
     * This framework method must be implemented by concrete subclasses. Any
     * subclass returning a <code>Composite</code> object whose <code>Layout</code>
     * has default margins (for example, a <code>GridLayout</code>) are expected to
     * set the margins of this <code>Layout</code> to 0 pixels.
     * </p>
     *
     * @param parent the parent composite
     * @return the new control
     */
    protected abstract Control createContents(Composite parent);

    /**
     * The <code>PreferencePage</code> implementation of this
     * <code>IDialogPage</code> method creates a description label
     * and button bar for the page. It calls <code>createContents</code>
     * to create the custom contents of the page.
     * <p>
     * If a subclass that overrides this method creates a <code>Composite</code>
     * that has a layout with default margins (for example, a <code>GridLayout</code>)
     * it is expected to set the margins of this <code>Layout</code> to 0 pixels.
     * @see IDialogPage#createControl(Composite)
     */
    public void createControl(Composite parent){

        GridData gd;
        Composite content = new Composite(parent, DWT.NONE);
        setControl(content);
        GridLayout layout = new GridLayout();
        layout.marginWidth = 0;
        layout.marginHeight = 0;
        content.setLayout(layout);
        //Apply the font on creation for backward compatibility
        applyDialogFont(content);

        // initialize the dialog units
        initializeDialogUnits(content);

        descriptionLabel = createDescriptionLabel(content);
        if (descriptionLabel !is null) {
            descriptionLabel.setLayoutData(new GridData(
                    GridData.FILL_HORIZONTAL));
        }

        body_ = createContents(content);
        if (body_ !is null) {
            // null is not a valid return value but support graceful failure
            body_.setLayoutData(new GridData(GridData.FILL_BOTH));
        }

        Composite buttonBar = new Composite(content, DWT.NONE);
        layout = new GridLayout();
        layout.numColumns = 0;
        layout.marginHeight = 0;
        layout.marginWidth = 0;
        layout.makeColumnsEqualWidth = false;
        buttonBar.setLayout(layout);

        gd = new GridData(GridData.HORIZONTAL_ALIGN_END);

        buttonBar.setLayoutData(gd);

        contributeButtons(buttonBar);

        if (createDefaultAndApplyButton) {
            layout.numColumns = layout.numColumns + 2;
            String[] labels = JFaceResources.getStrings([
                    "defaults", "apply"]); //$NON-NLS-2$//$NON-NLS-1$
            int widthHint = convertHorizontalDLUsToPixels(IDialogConstants.BUTTON_WIDTH);
            defaultsButton = new Button(buttonBar, DWT.PUSH);
            defaultsButton.setText(labels[0]);
            Dialog.applyDialogFont(defaultsButton);
            GridData data = new GridData(GridData.HORIZONTAL_ALIGN_FILL);
            Point minButtonSize = defaultsButton.computeSize(DWT.DEFAULT,
                    DWT.DEFAULT, true);
            data.widthHint = Math.max(widthHint, minButtonSize.x);
            defaultsButton.setLayoutData(data);
            defaultsButton.addSelectionListener(new class SelectionAdapter {
                public void widgetSelected(SelectionEvent e) {
                    performDefaults();
                }
            });

            applyButton = new Button(buttonBar, DWT.PUSH);
            applyButton.setText(labels[1]);
            Dialog.applyDialogFont(applyButton);
            data = new GridData(GridData.HORIZONTAL_ALIGN_FILL);
            minButtonSize = applyButton.computeSize(DWT.DEFAULT, DWT.DEFAULT,
                    true);
            data.widthHint = Math.max(widthHint, minButtonSize.x);
            applyButton.setLayoutData(data);
            applyButton.addSelectionListener(new class SelectionAdapter {
                public void widgetSelected(SelectionEvent e) {
                    performApply();
                }
            });
            applyButton.setEnabled(isValid());
            applyDialogFont(buttonBar);
        } else {
            /* Check if there are any other buttons on the button bar.
             * If not, throw away the button bar composite.  Otherwise
             * there is an unusually large button bar.
             */
            if (buttonBar.getChildren().length < 1) {
                buttonBar.dispose();
            }
        }
    }



    /**
     * Apply the dialog font to the composite and it's children
     * if it is set. Subclasses may override if they wish to
     * set the font themselves.
     * @param composite
     */
    protected void applyDialogFont(Composite composite) {
        Dialog.applyDialogFont(composite);
    }

    /**
     * Creates and returns an DWT label under the given composite.
     *
     * @param parent the parent composite
     * @return the new label
     */
    protected Label createDescriptionLabel(Composite parent) {
        Label result = null;
        String description = getDescription();
        if (description !is null) {
            result = new Label(parent, DWT.WRAP);
            result.setFont(parent.getFont());
            result.setText(description);
        }
        return result;
    }

    /**
     * Computes the size needed by this page's UI control.
     * <p>
     * All pages should override this method and set the appropriate sizes
     * of their widgets, and then call <code>super.doComputeSize</code>.
     * </p>
     *
     * @return the size of the preference page encoded as
     *   <code>new Point(width,height)</code>
     */
    protected Point doComputeSize() {
        if (descriptionLabel !is null && body_ !is null) {
            Point bodySize = body_.computeSize(DWT.DEFAULT, DWT.DEFAULT, true);
            GridData gd = cast(GridData) descriptionLabel.getLayoutData();
            gd.widthHint = bodySize.x;
        }
        return getControl().computeSize(DWT.DEFAULT, DWT.DEFAULT, true);
    }

    /**
     * Returns the preference store of this preference page.
     * <p>
     * This is a framework hook method for subclasses to return a
     * page-specific preference store. The default implementation
     * returns <code>null</code>.
     * </p>
     *
     * @return the preference store, or <code>null</code> if none
     */
    protected IPreferenceStore doGetPreferenceStore() {
        return null;
    }

    /**
     * Returns the container of this page.
     *
     * @return the preference page container, or <code>null</code> if this
     *   page has yet to be added to a container
     */
    public IPreferencePageContainer getContainer() {
        return container;
    }

    /**
     * Returns the preference store of this preference page.
     *
     * @return the preference store , or <code>null</code> if none
     */
    public IPreferenceStore getPreferenceStore() {
        if (preferenceStore is null) {
            preferenceStore = doGetPreferenceStore();
        }
        if (preferenceStore !is null) {
            return preferenceStore;
        } else if (container !is null) {
            return container.getPreferenceStore();
        }
        return null;
    }

    /**
     * The preference page implementation of an <code>IPreferencePage</code>
     * method returns whether this preference page is valid. Preference
     * pages are considered valid by default; call <code>setValid(false)</code>
     * to make a page invalid.
     * @see IPreferencePage#isValid()
     */
    public bool isValid() {
        return isValid_;
    }

    /**
     * Suppresses creation of the standard Default and Apply buttons
     * for this page.
     * <p>
     * Subclasses wishing a preference page without these buttons
     * should call this framework method before the page's control
     * has been created.
     * </p>
     */
    protected void noDefaultAndApplyButton() {
        createDefaultAndApplyButton = false;
    }

    /**
     * The <code>PreferencePage</code> implementation of this
     * <code>IPreferencePage</code> method returns <code>true</code>
     * if the page is valid.
     * @see IPreferencePage#okToLeave()
     */
    public bool okToLeave() {
        return isValid();
    }

    /**
     * Performs special processing when this page's Apply button has been pressed.
     * <p>
     * This is a framework hook method for sublcasses to do special things when
     * the Apply button has been pressed.
     * The default implementation of this framework method simply calls
     * <code>performOk</code> to simulate the pressing of the page's OK button.
     * </p>
     *
     * @see #performOk
     */
    protected void performApply() {
        performOk();
    }

    /**
     * The preference page implementation of an <code>IPreferencePage</code>
     * method performs special processing when this page's Cancel button has
     * been pressed.
     * <p>
     * This is a framework hook method for subclasses to do special things when
     * the Cancel button has been pressed. The default implementation of this
     * framework method does nothing and returns <code>true</code>.
     * @see IPreferencePage#performCancel()
     */
    public bool performCancel() {
        return true;
    }

    /**
     * Performs special processing when this page's Defaults button has been pressed.
     * <p>
     * This is a framework hook method for subclasses to do special things when
     * the Defaults button has been pressed.
     * Subclasses may override, but should call <code>super.performDefaults</code>.
     * </p>
     */
    protected void performDefaults() {
        updateApplyButton();
    }

   
    /* (non-Javadoc)
     * @see dwtx.jface.preference.IPreferencePage#performOk()
     */
    public bool performOk() {
        return true;
    }

    
    /* (non-Javadoc)
     * @see dwtx.jface.preference.IPreferencePage#setContainer(dwtx.jface.preference.IPreferencePageContainer)
     */
    public void setContainer(IPreferencePageContainer container) {
        this.container = container;
    }

    /**
     * Sets the preference store for this preference page.
     * <p>
     * If preferenceStore is set to null, getPreferenceStore
     * will invoke doGetPreferenceStore the next time it is called.
     * </p>
     *
     * @param store the preference store, or <code>null</code>
     * @see #getPreferenceStore
     */
    public void setPreferenceStore(IPreferenceStore store) {
        preferenceStore = store;
    }

   
    /* (non-Javadoc)
     * @see dwtx.jface.preference.IPreferencePage#setSize(dwt.graphics.Point)
     */
    public void setSize(Point uiSize) {
        Control control = getControl();
        if (control !is null) {
            control.setSize(uiSize);
            size = uiSize;
        }
    }

    /**
     * The <code>PreferencePage</code> implementation of this <code>IDialogPage</code>
     * method extends the <code>DialogPage</code> implementation to update
     * the preference page container title. Subclasses may extend.
     * @see IDialogPage#setTitle(String)
     */
    public override void setTitle(String title) {
        super.setTitle(title);
        if (getContainer() !is null) {
            getContainer().updateTitle();
        }
    }

    /**
     * Sets whether this page is valid.
     * The enable state of the container buttons and the
     * apply button is updated when a page's valid state
     * changes.
     * <p>
     *
     * @param b the new valid state
     */
    public void setValid(bool b) {
        bool oldValue = isValid_;
        isValid_ = b;
        if (oldValue !is isValid_) {
            // update container state
            if (getContainer() !is null) {
                getContainer().updateButtons();
            }
            // update page state
            updateApplyButton();
        }
    }

   
    /* (non-Javadoc)
     * @see java.lang.Object#toString()
     */
    public override String toString() {
        return getTitle();
    }

    /**
     * Updates the enabled state of the Apply button to reflect whether
     * this page is valid.
     */
    protected void updateApplyButton() {
        if (applyButton !is null) {
            applyButton.setEnabled(isValid());
        }
    }

    /**
     * Creates a composite with a highlighted Note entry and a message text.
     * This is designed to take up the full width of the page.
     *
     * @param font the font to use
     * @param composite the parent composite
     * @param title the title of the note
     * @param message the message for the note
     * @return the composite for the note
     */
    protected Composite createNoteComposite(Font font, Composite composite,
            String title, String message) {
        Composite messageComposite = new Composite(composite, DWT.NONE);
        GridLayout messageLayout = new GridLayout();
        messageLayout.numColumns = 2;
        messageLayout.marginWidth = 0;
        messageLayout.marginHeight = 0;
        messageComposite.setLayout(messageLayout);
        messageComposite.setLayoutData(new GridData(
                GridData.HORIZONTAL_ALIGN_FILL));
        messageComposite.setFont(font);

        final Label noteLabel = new Label(messageComposite, DWT.BOLD);
        noteLabel.setText(title);
        noteLabel.setFont(JFaceResources.getFontRegistry().getBold(
                JFaceResources.DEFAULT_FONT));
        noteLabel
                .setLayoutData(new GridData(GridData.VERTICAL_ALIGN_BEGINNING));

        final IPropertyChangeListener fontListener = new class IPropertyChangeListener {
            public void propertyChange(PropertyChangeEvent event) {
                if (JFaceResources.BANNER_FONT.equals(event.getProperty())) {
                    noteLabel.setFont(JFaceResources
                            .getFont(JFaceResources.BANNER_FONT));
                }
            }
        };
        JFaceResources.getFontRegistry().addListener(fontListener);
        noteLabel.addDisposeListener(new class DisposeListener {
            public void widgetDisposed(DisposeEvent event) {
                JFaceResources.getFontRegistry().removeListener(fontListener);
            }
        });

        Label messageLabel = new Label(messageComposite, DWT.WRAP);
        messageLabel.setText(message);
        messageLabel.setFont(font);
        return messageComposite;
    }

    /**
     * Returns the Apply button.
     *
     * @return the Apply button
     */
    protected Button getApplyButton() {
        return applyButton;
    }

    /**
     * Returns the Restore Defaults button.
     *
     * @return the Restore Defaults button
     */
    protected Button getDefaultsButton() {
        return defaultsButton;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.dialogs.IDialogPage#performHelp()
     */
    public override void performHelp() {
        getControl().notifyListeners(DWT.Help, new Event());
    }

    /**
     * Apply the data to the receiver. By default do nothing.
     * @param data
     * @since 3.1
     */
    public void applyData(Object data) {

    }

    /* (non-Javadoc)
     * @see dwtx.jface.dialogs.DialogPage#setErrorMessage(java.lang.String)
     */
    public override void setErrorMessage(String newMessage) {
        super.setErrorMessage(newMessage);
        if (getContainer() !is null) {
            getContainer().updateMessage();
        }
    }

    /* (non-Javadoc)
     * @see dwtx.jface.dialogs.DialogPage#setMessage(java.lang.String, int)
     */
    public override void setMessage(String newMessage, int newType) {
        super.setMessage(newMessage, newType);
        if (getContainer() !is null) {
            getContainer().updateMessage();
        }
    }

}
