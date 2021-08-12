/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Teddy Walker <teddy.walker@googlemail.com>
 *      - Bug 188056 [Preferences] PreferencePages have to less indent in PreferenceDialog
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.preference.PreferenceDialog;

import dwtx.jface.preference.IPreferencePageContainer;
import dwtx.jface.preference.IPreferencePage;
import dwtx.jface.preference.IPreferenceNode;
import dwtx.jface.preference.IPreferenceStore;
import dwtx.jface.preference.IPersistentPreferenceStore;
import dwtx.jface.preference.PreferenceManager;
import dwtx.jface.preference.PreferencePage;
import dwtx.jface.preference.PreferenceLabelProvider;
import dwtx.jface.preference.PreferenceContentProvider;

import dwt.DWT;
import dwt.custom.BusyIndicator;
import dwt.custom.ScrolledComposite;
import dwt.events.ControlAdapter;
import dwt.events.ControlEvent;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.HelpEvent;
import dwt.events.HelpListener;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.events.ShellAdapter;
import dwt.events.ShellEvent;
import dwt.graphics.Font;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.FormAttachment;
import dwt.layout.FormData;
import dwt.layout.FormLayout;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Event;
import dwt.widgets.Label;
import dwt.widgets.Layout;
import dwt.widgets.Listener;
import dwt.widgets.Sash;
import dwt.widgets.Shell;
import dwt.widgets.Tree;
import dwtx.core.runtime.Assert;
import dwtx.core.runtime.ISafeRunnable;
import dwtx.core.runtime.IStatus;
import dwtx.core.runtime.ListenerList;
import dwtx.core.runtime.SafeRunner;
import dwtx.core.runtime.Status;
import dwtx.jface.dialogs.DialogMessageArea;
import dwtx.jface.dialogs.IDialogConstants;
import dwtx.jface.dialogs.IMessageProvider;
import dwtx.jface.dialogs.IPageChangeProvider;
import dwtx.jface.dialogs.IPageChangedListener;
import dwtx.jface.dialogs.MessageDialog;
import dwtx.jface.dialogs.PageChangedEvent;
import dwtx.jface.dialogs.TrayDialog;
import dwtx.jface.resource.JFaceResources;
import dwtx.jface.util.IPropertyChangeListener;
import dwtx.jface.util.Policy;
import dwtx.jface.util.PropertyChangeEvent;
import dwtx.jface.util.SafeRunnable;
import dwtx.jface.viewers.ISelection;
import dwtx.jface.viewers.ISelectionChangedListener;
import dwtx.jface.viewers.IStructuredSelection;
import dwtx.jface.viewers.SelectionChangedEvent;
import dwtx.jface.viewers.StructuredSelection;
import dwtx.jface.viewers.TreeViewer;
import dwtx.jface.viewers.ViewerComparator;
import dwtx.jface.viewers.ViewerFilter;

import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;
import dwtx.dwtxhelper.Collection;

/**
 * A preference dialog is a hierarchical presentation of preference pages. Each
 * page is represented by a node in the tree shown on the left hand side of the
 * dialog; when a node is selected, the corresponding page is shown on the right
 * hand side.
 */
public class PreferenceDialog : TrayDialog, IPreferencePageContainer, IPageChangeProvider {
    /**
     * Layout for the page container.
     *
     */
    private class PageLayout : Layout {
        public override Point computeSize(Composite composite, int wHint, int hHint, bool force) {
            if (wHint !is DWT.DEFAULT && hHint !is DWT.DEFAULT) {
                return new Point(wHint, hHint);
            }
            int x = minimumPageSize.x;
            int y = minimumPageSize.y;
            Control[] children = composite.getChildren();
            for (int i = 0; i < children.length; i++) {
                Point size = children[i].computeSize(DWT.DEFAULT, DWT.DEFAULT, force);
                x = Math.max(x, size.x);
                y = Math.max(y, size.y);
            }

            //As pages can implement thier own computeSize
            //take it into account
            if(currentPage !is null){
                Point size = currentPage.computeSize();
                x = Math.max(x, size.x);
                y = Math.max(y, size.y);
            }

            if (wHint !is DWT.DEFAULT) {
                x = wHint;
            }
            if (hHint !is DWT.DEFAULT) {
                y = hHint;
            }
            return new Point(x, y);
        }

        public override void layout(Composite composite, bool force) {
            Rectangle rect = composite.getClientArea();
            Control[] children = composite.getChildren();
            for (int i = 0; i < children.length; i++) {
                children[i].setSize(rect.width, rect.height);
            }
        }
    }

    //The id of the last page that was selected
    private static String lastPreferenceId = null;

    //The last known tree width
    private static int lastTreeWidth = 180;

    /**
     * Indentifier for the error image
     */
    public static const String PREF_DLG_IMG_TITLE_ERROR = DLG_IMG_MESSAGE_ERROR;

    /**
     * Title area fields
     */
    public static const String PREF_DLG_TITLE_IMG = "preference_dialog_title_image"; //$NON-NLS-1$

    /**
     * Return code used when dialog failed
     */
    protected static const int FAILED = 2;

    /**
     * The current preference page, or <code>null</code> if there is none.
     */
    private IPreferencePage currentPage;

    private DialogMessageArea messageArea;

    private Point lastShellSize;

    private IPreferenceNode lastSuccessfulNode;

    /**
     * The minimum page size; 400 by 400 by default.
     *
     * @see #setMinimumPageSize(Point)
     */
    private Point minimumPageSize;

    /**
     * The OK button.
     */
    private Button okButton;

    /**
     * The Composite in which a page is shown.
     */
    private Composite pageContainer;

    /**
     * The preference manager.
     */
    private PreferenceManager preferenceManager;

    /**
     * Flag for the presence of the error message.
     */
    private bool showingError = false;

    /**
     * Preference store, initially <code>null</code> meaning none.
     *
     * @see #setPreferenceStore
     */
    private IPreferenceStore preferenceStore;

    private Composite titleArea;

    /**
     * The tree viewer.
     */
    private TreeViewer treeViewer;

    private ListenerList pageChangedListeners;

    /**
     *  Composite with a FormLayout to contain the title area
     */
    Composite formTitleComposite;

    private ScrolledComposite scrolled;

    /**
     * Creates a new preference dialog under the control of the given preference
     * manager.
     *
     * @param parentShell
     *            the parent shell
     * @param manager
     *            the preference manager
     */
    public this(Shell parentShell, PreferenceManager manager) {
        minimumPageSize = new Point(400, 400);
        pageChangedListeners = new ListenerList();
        super(parentShell);
        preferenceManager = manager;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.dialogs.Dialog#buttonPressed(int)
     */
    protected override void buttonPressed(int buttonId) {
        switch (buttonId) {
        case IDialogConstants.OK_ID: {
            okPressed();
            return;
        }
        case IDialogConstants.CANCEL_ID: {
            cancelPressed();
            return;
        }
        case IDialogConstants.HELP_ID: {
            helpPressed();
            return;
        }
        default:
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.dialogs.Dialog#cancelPressed()
     */
    protected override void cancelPressed() {
        // Inform all pages that we are cancelling
        Iterator nodes = preferenceManager.getElements(PreferenceManager.PRE_ORDER).iterator();
        while (nodes.hasNext()) {
            IPreferenceNode node = cast(IPreferenceNode) nodes.next();
            if (getPage(node) !is null) {

                // this_: strange workaround for compiler error with dmd 1.028 in run()
                SafeRunnable.run(dgSafeRunnable((IPreferenceNode node_, PreferenceDialog this_) {
                    if (!this_.getPage(node_).performCancel()) {
                        return;
                    }
                }, cast(IPreferenceNode)node, this ));
            }
        }
        setReturnCode(CANCEL);
        close();
    }

    /**
     * Clear the last selected node. This is so that we not chache the last
     * selection in case of an error.
     */
    void clearSelectedNode() {
        setSelectedNodePreference(null);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.window.Window#close()
     */
    public override bool close() {

        //Do this is in a SafeRunnable as it may run client code
        SafeRunnable runnable = new class SafeRunnable{
            /* (non-Javadoc)
             * @see dwtx.core.runtime.ISafeRunnable#run()
             */
            public void run() {
                auto nodes = preferenceManager.getElements(PreferenceManager.PRE_ORDER);
                for (int i = 0; i < nodes.size(); i++) {
                    IPreferenceNode node = cast(IPreferenceNode) nodes.get(i);
                    node.disposeResources();
                }

            }

            /* (non-Javadoc)
             * @see dwtx.jface.util.SafeRunnable#handleException(java.lang.Throwable)
             */
            public void handleException(Exception e) {
                super.handleException(e);
                clearSelectedNode();//Do not cache a node with problems
            }
        };

        SafeRunner.run(runnable);

        return super.close();
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.window.Window#configureShell(dwt.widgets.Shell)
     */
    protected override void configureShell(Shell newShell) {
        super.configureShell(newShell);
        newShell.setText(JFaceResources.getString("PreferenceDialog.title")); //$NON-NLS-1$
        newShell.addShellListener(new class ShellAdapter {
            public void shellActivated(ShellEvent e) {
                if (lastShellSize is null) {
                    lastShellSize = getShell().getSize();
                }
            }

        });

    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.window.Window#constrainShellSize()
     */
    protected override void constrainShellSize() {
        super.constrainShellSize();
        // record opening shell size
        if (lastShellSize is null) {
            lastShellSize = getShell().getSize();
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.dialogs.Dialog#createButtonsForButtonBar(dwt.widgets.Composite)
     */
    protected override void createButtonsForButtonBar(Composite parent) {
        // create OK and Cancel buttons by default
        okButton = createButton(parent, IDialogConstants.OK_ID, IDialogConstants.OK_LABEL, true);
        getShell().setDefaultButton(okButton);
        createButton(parent, IDialogConstants.CANCEL_ID, IDialogConstants.CANCEL_LABEL, false);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.window.Window#createContents(dwt.widgets.Composite)
     */
    protected override Control createContents(Composite parent) {
        Control[1] control;
        BusyIndicator.showWhile(getShell().getDisplay(), new class(parent,control) Runnable {
            Composite parent_;
            Control[] control_;
            this(Composite a,Control[] b){
                parent_=a;
                control_=b;
            }
            public void run() {
                control_[0] = callSuperCreateContents(parent_);
                // Add the first page
                selectSavedItem();
            }
        });

        return control[0];
    }
    private Control callSuperCreateContents( Composite c ){
        return super.createContents( c );
    }
    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.dialogs.Dialog#createDialogArea(dwt.widgets.Composite)
     */
    protected override Control createDialogArea(Composite parent) {
        final Composite composite = cast(Composite) super.createDialogArea(parent);
        GridLayout parentLayout = (cast(GridLayout) composite.getLayout());
        parentLayout.numColumns = 4;
        parentLayout.marginHeight = 0;
        parentLayout.marginWidth = 0;
        parentLayout.verticalSpacing = 0;
        parentLayout.horizontalSpacing = 0;

        composite.setBackground(parent.getDisplay().getSystemColor(DWT.COLOR_LIST_BACKGROUND));

        Control treeControl = createTreeAreaContents(composite);
        createSash(composite,treeControl);

        Label versep = new Label(composite, DWT.SEPARATOR | DWT.VERTICAL);
        GridData verGd = new GridData(GridData.FILL_VERTICAL | GridData.GRAB_VERTICAL);

        versep.setLayoutData(verGd);
        versep.setLayoutData(new GridData(DWT.LEFT, DWT.FILL, false, true));

        Composite pageAreaComposite = new Composite(composite, DWT.NONE);
        pageAreaComposite.setLayoutData(new GridData(GridData.FILL_BOTH));
        GridLayout layout = new GridLayout(1, true);
        layout.marginHeight = 0;
        layout.marginWidth = 0;
        layout.verticalSpacing = 0;
        pageAreaComposite.setLayout(layout);

        formTitleComposite = new Composite(pageAreaComposite, DWT.NONE);
        FormLayout titleLayout = new FormLayout();
        titleLayout.marginWidth = 0;
        titleLayout.marginHeight = 0;
        formTitleComposite.setLayout(titleLayout);

        GridData titleGridData = new GridData(GridData.FILL_HORIZONTAL);
        titleGridData.horizontalIndent = IDialogConstants.HORIZONTAL_MARGIN;
        formTitleComposite.setLayoutData(titleGridData);

        // Build the title area and separator line
        Composite titleComposite = new Composite(formTitleComposite, DWT.NONE);
        layout = new GridLayout();
        layout.marginBottom = 5;
        layout.marginHeight = 0;
        layout.marginWidth = 0;
        layout.horizontalSpacing = 0;
        titleComposite.setLayout(layout);

        FormData titleFormData = new FormData();
        titleFormData.top = new FormAttachment(0,0);
        titleFormData.left = new FormAttachment(0,0);
        titleFormData.right = new FormAttachment(100,0);
        titleFormData.bottom = new FormAttachment(100,0);

        titleComposite.setLayoutData(titleFormData);
        createTitleArea(titleComposite);

        Label separator = new Label(pageAreaComposite, DWT.HORIZONTAL | DWT.SEPARATOR);

        separator.setLayoutData(new GridData(GridData.FILL_HORIZONTAL | GridData.GRAB_HORIZONTAL));


        // Build the Page container
        pageContainer = createPageContainer(pageAreaComposite);
        GridData pageContainerData = new GridData(GridData.FILL_BOTH);
        pageContainerData.horizontalIndent = IDialogConstants.HORIZONTAL_MARGIN;
        pageContainer.setLayoutData(pageContainerData);
        // Build the separator line
        Label bottomSeparator = new Label(parent, DWT.HORIZONTAL | DWT.SEPARATOR);
        bottomSeparator.setLayoutData(new GridData(GridData.FILL_HORIZONTAL | GridData.GRAB_HORIZONTAL));
        return composite;
    }

    /**
     * Create the sash with right control on the right. Note
     * that this method assumes GridData for the layout data
     * of the rightControl.
     * @param composite
     * @param rightControl
     * @return Sash
     *
     * @since 3.1
     */
    protected Sash createSash(Composite composite, Control rightControl) {
        Sash sash = new Sash(composite, DWT.VERTICAL);
        sash.setLayoutData(new GridData(GridData.FILL_VERTICAL));
        sash.setBackground(composite.getDisplay().getSystemColor(DWT.COLOR_LIST_BACKGROUND));
        // the following listener resizes the tree control based on sash deltas.
        // If necessary, it will also grow/shrink the dialog.
        sash.addListener(DWT.Selection, new class(composite,rightControl,sash) Listener {
            Composite composite_;
            Control rightControl_;
            Sash sash_;
            this(Composite a,Control b,Sash c){
                composite_=a;
                rightControl_=b;
                sash_=c;
            }
            /*
             * (non-Javadoc)
             *
             * @see dwt.widgets.Listener#handleEvent(dwt.widgets.Event)
             */
            public void handleEvent(Event event) {
                if (event.detail is DWT.DRAG) {
                    return;
                }
                int shift = event.x - sash_.getBounds().x;
                GridData data = cast(GridData) rightControl_.getLayoutData();
                int newWidthHint = data.widthHint + shift;
                if (newWidthHint < 20) {
                    return;
                }
                Point computedSize = getShell().computeSize(DWT.DEFAULT, DWT.DEFAULT);
                Point currentSize = getShell().getSize();
                // if the dialog wasn't of a custom size we know we can shrink
                // it if necessary based on sash movement.
                bool customSize = !computedSize.opEquals(currentSize);
                data.widthHint = newWidthHint;
                setLastTreeWidth(newWidthHint);
                composite_.layout(true);
                // recompute based on new widget size
                computedSize = getShell().computeSize(DWT.DEFAULT, DWT.DEFAULT);
                // if the dialog was of a custom size then increase it only if
                // necessary.
                if (customSize) {
                    computedSize.x = Math.max(computedSize.x, currentSize.x);
                }
                computedSize.y = Math.max(computedSize.y, currentSize.y);
                if (computedSize.opEquals(currentSize)) {
                    return;
                }
                setShellSize(computedSize.x, computedSize.y);
                lastShellSize = getShell().getSize();
            }
        });
        return sash;
    }

    /**
     * Creates the inner page container.
     *
     * @param parent
     * @return Composite
     */
    protected Composite createPageContainer(Composite parent) {

        Composite outer = new Composite(parent, DWT.NONE);

        GridData outerData = new GridData(GridData.FILL_BOTH | GridData.GRAB_HORIZONTAL
                | GridData.GRAB_VERTICAL);
        outerData.horizontalIndent = IDialogConstants.HORIZONTAL_MARGIN;

        outer.setLayout(new GridLayout());
        outer.setLayoutData(outerData);

        //Create an outer composite for spacing
        scrolled = new ScrolledComposite(outer, DWT.V_SCROLL | DWT.H_SCROLL);

        scrolled.setExpandHorizontal(true);
        scrolled.setExpandVertical(true);

        GridData scrolledData = new GridData(GridData.FILL_BOTH | GridData.GRAB_HORIZONTAL
                | GridData.GRAB_VERTICAL);

        scrolled.setLayoutData(scrolledData);

        Composite result = new Composite(scrolled, DWT.NONE);

        GridData resultData = new GridData(GridData.FILL_BOTH | GridData.GRAB_HORIZONTAL
                | GridData.GRAB_VERTICAL);

        result.setLayout(getPageLayout());
        result.setLayoutData(resultData);

        scrolled.setContent(result);

        return result;
    }

    /**
     * Return the layout for the composite that contains
     * the pages.
     * @return PageLayout
     *
     * @since 3.1
     */
    protected Layout getPageLayout() {
        return new PageLayout();
    }

    /**
     * Creates the wizard's title area.
     *
     * @param parent
     *            the DWT parent for the title area composite.
     * @return the created title area composite.
     */
    protected Composite createTitleArea(Composite parent) {
        // Create the title area which will contain
        // a title, message, and image.
        int margins = 2;
        titleArea = new Composite(parent, DWT.NONE);
        FormLayout layout = new FormLayout();
        layout.marginHeight = 0;
        layout.marginWidth = margins;
        titleArea.setLayout(layout);


        GridData layoutData = new GridData(GridData.FILL_HORIZONTAL);
        layoutData.verticalAlignment = DWT.TOP;
        titleArea.setLayoutData(layoutData);

        // Message label
        messageArea = new DialogMessageArea();
        messageArea.createContents(titleArea);

        titleArea.addControlListener(new class ControlAdapter {
            /* (non-Javadoc)
             * @see dwt.events.ControlAdapter#controlResized(dwt.events.ControlEvent)
             */
            public void controlResized(ControlEvent e) {
                updateMessage();
            }
        });

        IPropertyChangeListener fontListener = new class IPropertyChangeListener {
            public void propertyChange(PropertyChangeEvent event) {
                if (JFaceResources.BANNER_FONT.equals(event.getProperty())) {
                    updateMessage();
                }
                if (JFaceResources.DIALOG_FONT.equals(event.getProperty())) {
                    updateMessage();
                    Font dialogFont = JFaceResources.getDialogFont();
                    updateTreeFont(dialogFont);
                    Control[] children = (cast(Composite) buttonBar).getChildren();
                    for (int i = 0; i < children.length; i++) {
                        children[i].setFont(dialogFont);
                    }
                }
            }
        };

        titleArea.addDisposeListener(new class(fontListener) DisposeListener {
            IPropertyChangeListener fontListener_;
            this(IPropertyChangeListener a){
                fontListener_=a;
            }
            public void widgetDisposed(DisposeEvent event) {
                JFaceResources.getFontRegistry().removeListener(fontListener_);
            }
        });
        JFaceResources.getFontRegistry().addListener(fontListener);
        messageArea.setTitleLayoutData(createMessageAreaData());
        messageArea.setMessageLayoutData(createMessageAreaData());
        return titleArea;
    }

    /**
     * Create the layout data for the message area.
     *
     * @return FormData for the message area.
     */
    private FormData createMessageAreaData() {
        FormData messageData = new FormData();
        messageData.top = new FormAttachment(0);
        messageData.bottom = new FormAttachment(100);
        messageData.right = new FormAttachment(100);
        messageData.left = new FormAttachment(0);
        return messageData;
    }

    /**
     * @param parent
     *            the DWT parent for the tree area controls.
     * @return the new <code>Control</code>.
     * @since 3.0
     */
    protected Control createTreeAreaContents(Composite parent) {
        // Build the tree an put it into the composite.
        treeViewer = createTreeViewer(parent);
        treeViewer.setInput(getPreferenceManager());
        updateTreeFont(JFaceResources.getDialogFont());
        layoutTreeAreaControl(treeViewer.getControl());
        return treeViewer.getControl();
    }

    /**
     * Create a new <code>TreeViewer</code>.
     *
     * @param parent
     *            the parent <code>Composite</code>.
     * @return the <code>TreeViewer</code>.
     * @since 3.0
     */
    protected TreeViewer createTreeViewer(Composite parent) {
        final TreeViewer viewer = new TreeViewer(parent, DWT.NONE);
        addListeners(viewer);
        viewer.setLabelProvider(new PreferenceLabelProvider());
        viewer.setContentProvider(new PreferenceContentProvider());
        return viewer;
    }

    /**
     * Add the listeners to the tree viewer.
     * @param viewer
     *
     * @since 3.1
     */
    protected void addListeners(TreeViewer viewer) {
        viewer.addPostSelectionChangedListener(new class(viewer) ISelectionChangedListener {
            TreeViewer viewer_;
            this(TreeViewer a){
                viewer_=a;
            }
            private void handleError() {
                try {
                    // remove the listener temporarily so that the events caused
                    // by the error handling dont further cause error handling
                    // to occur.
                    viewer_.removePostSelectionChangedListener(this);
                    showPageFlippingAbortDialog();
                    selectCurrentPageAgain();
                    clearSelectedNode();
                } finally {
                    viewer_.addPostSelectionChangedListener(this);
                }
            }

            public void selectionChanged(SelectionChangedEvent event) {
                Object selection = cast(Object) getSingleSelection(event.getSelection());
                if (cast(IPreferenceNode)selection ) {
                    BusyIndicator.showWhile(getShell().getDisplay(), new class(selection) Runnable {
                        Object selection_;
                        this(Object o){ selection_=o; }
                        public void run() {
                            if (!isCurrentPageValid()) {
                                handleError();
                            } else if (!showPage(cast(IPreferenceNode) selection_)) {
                                // Page flipping wasn't successful
                                handleError();
                            } else {
                                // Everything went well
                                lastSuccessfulNode = cast(IPreferenceNode) selection_;
                            }
                        }
                    });
                }
            }
        });
        (cast(Tree) viewer.getControl()).addSelectionListener(new class(viewer) SelectionAdapter {
            TreeViewer viewer_;
            this(TreeViewer a){
                viewer_=a;
            }
            public void widgetDefaultSelected(SelectionEvent event) {
                ISelection selection = viewer_.getSelection();
                if (selection.isEmpty()) {
                    return;
                }
                IPreferenceNode singleSelection = getSingleSelection(selection);
                bool expanded = viewer_.getExpandedState(cast(Object)singleSelection);
                viewer_.setExpandedState(cast(Object)singleSelection, !expanded);
            }
        });
        //Register help listener on the tree to use context sensitive help
        viewer.getControl().addHelpListener(new class HelpListener {
            public void helpRequested(HelpEvent event) {
                // call perform help on the current page
                if (currentPage !is null) {
                    currentPage.performHelp();
                }
            }
        });
    }

    /**
     * Find the <code>IPreferenceNode</code> that has data the same id as the
     * supplied value.
     *
     * @param nodeId
     *            the id to search for.
     * @return <code>IPreferenceNode</code> or <code>null</code> if not
     *         found.
     */
    protected IPreferenceNode findNodeMatching(String nodeId) {
        List nodes = preferenceManager.getElements(PreferenceManager.POST_ORDER);
        for (Iterator i = nodes.iterator(); i.hasNext();) {
            IPreferenceNode node = cast(IPreferenceNode) i.next();
            if (node.getId().equals(nodeId)) {
                return node;
            }
        }
        return null;
    }

    /**
     * Get the last known right side width.
     *
     * @return the width.
     */
    protected int getLastRightWidth() {
        return lastTreeWidth;
    }

    /**
     * Returns the preference mananger used by this preference dialog.
     *
     * @return the preference mananger
     */
    public PreferenceManager getPreferenceManager() {
        return preferenceManager;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.preference.IPreferencePageContainer#getPreferenceStore()
     */
    public IPreferenceStore getPreferenceStore() {
        return preferenceStore;
    }

    /**
     * Get the name of the selected item preference
     *
     * @return String
     */
    protected String getSelectedNodePreference() {
        return lastPreferenceId;
    }

    /**
     * @param selection
     *            the <code>ISelection</code> to examine.
     * @return the first element, or null if empty.
     */
    protected IPreferenceNode getSingleSelection(ISelection selection) {
        if (!selection.isEmpty()) {
            IStructuredSelection structured = cast(IStructuredSelection) selection;
            if (cast(IPreferenceNode)structured.getFirstElement() ) {
                return cast(IPreferenceNode) structured.getFirstElement();
            }
        }
        return null;
    }

    /**
     * @return the <code>TreeViewer</code> for this dialog.
     * @since 3.3
     */
    public TreeViewer getTreeViewer() {
        return treeViewer;
    }

    /**
     * Save the values specified in the pages.
     * <p>
     * The default implementation of this framework method saves all pages of
     * type <code>PreferencePage</code> (if their store needs saving and is a
     * <code>PreferenceStore</code>).
     * </p>
     * <p>
     * Subclasses may override.
     * </p>
     */
    protected void handleSave() {
        Iterator nodes = preferenceManager.getElements(PreferenceManager.PRE_ORDER).iterator();
        while (nodes.hasNext()) {
            IPreferenceNode node = cast(IPreferenceNode) nodes.next();
            IPreferencePage page = node.getPage();
            if (cast(PreferencePage)page ) {
                // Save now in case tbe workbench does not shutdown cleanly
                IPreferenceStore store = (cast(PreferencePage) page).getPreferenceStore();
                if (store !is null && store.needsSaving()
                        && cast(IPersistentPreferenceStore)store ) {
                    try {
                        (cast(IPersistentPreferenceStore) store).save();
                    } catch (IOException e) {
                        String message =JFaceResources.format(
                                "PreferenceDialog.saveErrorMessage", [ page.getTitle(), e.msg ]); //$NON-NLS-1$
                        Policy.getStatusHandler().show(
                                new Status(IStatus.ERROR, Policy.JFACE, message, e),
                                JFaceResources.getString("PreferenceDialog.saveErrorTitle")); //$NON-NLS-1$

                    }
                }
            }
        }
    }

    /**
     * Notifies that the window's close button was pressed, the close menu was
     * selected, or the ESCAPE key pressed.
     * <p>
     * The default implementation of this framework method sets the window's
     * return code to <code>CANCEL</code> and closes the window using
     * <code>close</code>. Subclasses may extend or reimplement.
     * </p>
     */
    protected override void handleShellCloseEvent() {
        // handle the same as pressing cancel
        cancelPressed();
    }

    /**
     * Notifies of the pressing of the Help button.
     * <p>
     * The default implementation of this framework method calls
     * <code>performHelp</code> on the currently active page.
     * </p>
     */
    protected /+override+/ void helpPressed() {
        if (currentPage !is null) {
            currentPage.performHelp();
        }
    }

    /**
     * Returns whether the current page is valid.
     *
     * @return <code>false</code> if the current page is not valid, or or
     *         <code>true</code> if the current page is valid or there is no
     *         current page
     */
    protected bool isCurrentPageValid() {
        if (currentPage is null) {
            return true;
        }
        return currentPage.isValid();
    }

    /**
     * @param control
     *            the <code>Control</code> to lay out.
     * @since 3.0
     */
    protected void layoutTreeAreaControl(Control control) {
        GridData gd = new GridData(GridData.FILL_VERTICAL);
        gd.widthHint = getLastRightWidth();
        gd.verticalSpan = 1;
        control.setLayoutData(gd);
    }

    /**
     * The preference dialog implementation of this <code>Dialog</code>
     * framework method sends <code>performOk</code> to all pages of the
     * preference dialog, then calls <code>handleSave</code> on this dialog to
     * save any state, and then calls <code>close</code> to close this dialog.
     */
    protected override void okPressed() {
        SafeRunnable.run(new class SafeRunnable {
            private bool errorOccurred;

            /*
             * (non-Javadoc)
             *
             * @see dwtx.core.runtime.ISafeRunnable#run()
             */
            public void run() {
                getButton(IDialogConstants.OK_ID).setEnabled(false);
                errorOccurred = false;
                bool hasFailedOK = false;
                try {
                    // Notify all the pages and give them a chance to abort
                    Iterator nodes = preferenceManager.getElements(PreferenceManager.PRE_ORDER)
                            .iterator();
                    while (nodes.hasNext()) {
                        IPreferenceNode node = cast(IPreferenceNode) nodes.next();
                        IPreferencePage page = node.getPage();
                        if (page !is null) {
                            if (!page.performOk()){
                                hasFailedOK = true;
                                return;
                            }
                        }
                    }
                } catch (Exception e) {
                    handleException(e);
                } finally {
                    //Don't bother closing if the OK failed
                    if(hasFailedOK){
                        setReturnCode(FAILED);
                        getButton(IDialogConstants.OK_ID).setEnabled(true);
                        //return;
                    }
                    else{

                        if (!errorOccurred) {
                            //Give subclasses the choice to save the state of the
                            //preference pages.
                            handleSave();
                        }
                        setReturnCode(OK);
                        close();
                    }
                }
            }

            /*
             * (non-Javadoc)
             *
             * @see dwtx.core.runtime.ISafeRunnable#handleException(java.lang.Throwable)
             */
            public void handleException(Exception e) {
                errorOccurred = true;

                Policy.getLog().log(new Status(IStatus.ERROR, Policy.JFACE, 0, e.toString(), e));

                clearSelectedNode();
                String message = JFaceResources.getString("SafeRunnable.errorMessage"); //$NON-NLS-1$

                Policy.getStatusHandler().show(
                        new Status(IStatus.ERROR, Policy.JFACE, message, e),
                        JFaceResources.getString("Error")); //$NON-NLS-1$

            }
        });
    }

    /**
     * Selects the page determined by <code>lastSuccessfulNode</code> in the
     * page hierarchy.
     */
    void selectCurrentPageAgain() {
        if (lastSuccessfulNode is null) {
            return;
        }
        getTreeViewer().setSelection(new StructuredSelection(cast(Object)lastSuccessfulNode));
        currentPage.setVisible(true);
    }

    /**
     * Selects the saved item in the tree of preference pages. If it cannot do
     * this it saves the first one.
     */
    protected void selectSavedItem() {
        IPreferenceNode node = findNodeMatching(getSelectedNodePreference());
        if (node is null) {
            IPreferenceNode[] nodes = preferenceManager.getRootSubNodes();
            ViewerComparator comparator = getTreeViewer().getComparator();
            if (comparator !is null) {
                comparator.sort(null, arraycast!(Object)(nodes));
            }
            ViewerFilter[] filters = getTreeViewer().getFilters();
            for (int i = 0; i < nodes.length; i++) {
                IPreferenceNode selectedNode = nodes[i];
                // See if it passes all filters
                for (int j = 0; j < filters.length; j++) {
                    if (!filters[j].select(this.treeViewer, cast(Object)preferenceManager
                            .getRoot_package(), cast(Object)selectedNode)) {
                        selectedNode = null;
                        break;
                    }
                }
                // if it passes all filters select it
                if (selectedNode !is null) {
                    node = selectedNode;
                    break;
                }
            }
        }
        if (node !is null) {
            getTreeViewer().setSelection(new StructuredSelection(cast(Object)node), true);
            // Keep focus in tree. See bugs 2692, 2621, and 6775.
            getTreeViewer().getControl().setFocus();
        }
    }

    /**
     * Display the given error message. The currently displayed message is saved
     * and will be redisplayed when the error message is set to
     * <code>null</code>.
     *
     * @param newErrorMessage
     *            the errorMessage to display or <code>null</code>
     */
    public void setErrorMessage(String newErrorMessage) {
        if (newErrorMessage is null) {
            messageArea.clearErrorMessage();
        } else {
            messageArea.updateText(newErrorMessage, IMessageProvider.ERROR);
        }
    }

    /**
     * Save the last known tree width.
     *
     * @param width
     *            the width.
     */
    private void setLastTreeWidth(int width) {
        lastTreeWidth = width;
    }

    /**
     * Set the message text. If the message line currently displays an error,
     * the message is stored and will be shown after a call to clearErrorMessage
     * <p>
     * Shortcut for <code>setMessage(newMessage, NONE)</code>
     * </p>
     *
     * @param newMessage
     *            the message, or <code>null</code> to clear the message
     */
    public void setMessage(String newMessage) {
        setMessage(newMessage, IMessageProvider.NONE);
    }

    /**
     * Sets the message for this dialog with an indication of what type of
     * message it is.
     * <p>
     * The valid message types are one of <code>NONE</code>,
     * <code>INFORMATION</code>,<code>WARNING</code>, or
     * <code>ERROR</code>.
     * </p>
     * <p>
     * Note that for backward compatibility, a message of type
     * <code>ERROR</code> is different than an error message (set using
     * <code>setErrorMessage</code>). An error message overrides the current
     * message until the error message is cleared. This method replaces the
     * current message and does not affect the error message.
     * </p>
     *
     * @param newMessage
     *            the message, or <code>null</code> to clear the message
     * @param newType
     *            the message type
     * @since 2.0
     */
    public void setMessage(String newMessage, int newType) {
        messageArea.updateText(newMessage, newType);
    }

    /**
     * Sets the minimum page size.
     *
     * @param minWidth
     *            the minimum page width
     * @param minHeight
     *            the minimum page height
     * @see #setMinimumPageSize(Point)
     */
    public void setMinimumPageSize(int minWidth, int minHeight) {
        minimumPageSize.x = minWidth;
        minimumPageSize.y = minHeight;
    }

    /**
     * Sets the minimum page size.
     *
     * @param size
     *            the page size encoded as <code>new Point(width,height)</code>
     * @see #setMinimumPageSize(int,int)
     */
    public void setMinimumPageSize(Point size) {
        minimumPageSize.x = size.x;
        minimumPageSize.y = size.y;
    }

    /**
     * Sets the preference store for this preference dialog.
     *
     * @param store
     *            the preference store
     * @see #getPreferenceStore
     */
    public void setPreferenceStore(IPreferenceStore store) {
        Assert.isNotNull(cast(Object)store);
        preferenceStore = store;
    }

    /**
     * Save the currently selected node.
     */
    private void setSelectedNode() {
        String storeValue = null;
        IStructuredSelection selection = cast(IStructuredSelection) getTreeViewer().getSelection();
        if (selection.size() is 1) {
            IPreferenceNode node = cast(IPreferenceNode) selection.getFirstElement();
            storeValue = node.getId();
        }
        setSelectedNodePreference(storeValue);
    }

    /**
     * Sets the name of the selected item preference. Public equivalent to
     * <code>setSelectedNodePreference</code>.
     *
     * @param pageId
     *            The identifier for the page
     * @since 3.0
     */
    public void setSelectedNode(String pageId) {
        setSelectedNodePreference(pageId);
    }

    /**
     * Sets the name of the selected item preference.
     *
     * @param pageId
     *            The identifier for the page
     */
    protected void setSelectedNodePreference(String pageId) {
        lastPreferenceId = pageId;
    }

    /**
     * Changes the shell size to the given size, ensuring that it is no larger
     * than the display bounds.
     *
     * @param width
     *            the shell width
     * @param height
     *            the shell height
     */
    private void setShellSize(int width, int height) {
        Rectangle preferred = getShell().getBounds();
        preferred.width = width;
        preferred.height = height;
        getShell().setBounds(getConstrainedShellBounds(preferred));
    }

    /**
     * Shows the preference page corresponding to the given preference node.
     * Does nothing if that page is already current.
     *
     * @param node
     *            the preference node, or <code>null</code> if none
     * @return <code>true</code> if the page flip was successful, and
     *         <code>false</code> is unsuccessful
     */
    protected bool showPage(IPreferenceNode node) {
        if (node is null) {
            return false;
        }
        // Create the page if nessessary
        if (node.getPage() is null) {
            createPage(node);
        }
        if (node.getPage() is null) {
            return false;
        }
        IPreferencePage newPage = getPage(node);
        if (newPage is currentPage) {
            return true;
        }
        if (currentPage !is null) {
            if (!currentPage.okToLeave()) {
                return false;
            }
        }
        IPreferencePage oldPage = currentPage;
        currentPage = newPage;
        // Set the new page's container
        currentPage.setContainer(this);
        // Ensure that the page control has been created
        // (this allows lazy page control creation)
        if (currentPage.getControl() is null) {
            bool[1] failed; failed[0] = false;
            SafeRunnable.run(new class(failed) ISafeRunnable {
                bool[] failed_;
                this(bool[] a){
                    this.failed_=a;
                }
                public void handleException(Exception e) {
                    this.failed_[0] = true;
                }

                public void run() {
                    createPageControl(currentPage, pageContainer);
                }
            });
            if (failed[0]) {
                return false;
            }
            // the page is responsible for ensuring the created control is
            // accessable
            // via getControl.
            Assert.isNotNull(currentPage.getControl());
        }
        // Force calculation of the page's description label because
        // label can be wrapped.
        Point[1] size;
        Point failed = new Point(-1, -1);
        SafeRunnable.run(new class(size,failed) ISafeRunnable {
            Point[] size_;
            Point failed_;
            this(Point[] a,Point b){
                size_=a;
                failed_=b;
            }
            public void handleException(Exception e) {
                size_[0] = failed_;
            }

            public void run() {
                size_[0] = currentPage.computeSize();
            }
        });
        if (size[0].opEquals(failed)) {
            return false;
        }
        Point contentSize = size[0];
        // Do we need resizing. Computation not needed if the
        // first page is inserted since computing the dialog's
        // size is done by calling dialog.open().
        // Also prevent auto resize if the user has manually resized
        Shell shell = getShell();
        Point shellSize = shell.getSize();
        if (oldPage !is null) {
            Rectangle rect = pageContainer.getClientArea();
            Point containerSize = new Point(rect.width, rect.height);
            int hdiff = contentSize.x - containerSize.x;
            int vdiff = contentSize.y - containerSize.y;
            if ((hdiff > 0 || vdiff > 0) && shellSize.opEquals(lastShellSize)) {
                    hdiff = Math.max(0, hdiff);
                    vdiff = Math.max(0, vdiff);
                    setShellSize(shellSize.x + hdiff, shellSize.y + vdiff);
                    lastShellSize = shell.getSize();
                    if (currentPage.getControl().getSize().x is 0) {
                        currentPage.getControl().setSize(containerSize);
                    }

            } else {
                currentPage.setSize(containerSize);
            }
        }

        scrolled.setMinSize(contentSize);
        // Ensure that all other pages are invisible
        // (including ones that triggered an exception during
        // their creation).
        Control[] children = pageContainer.getChildren();
        Control currentControl = currentPage.getControl();
        for (int i = 0; i < children.length; i++) {
            if (children[i] !is currentControl) {
                children[i].setVisible(false);
            }
        }
        // Make the new page visible
        currentPage.setVisible(true);
        if (oldPage !is null) {
            oldPage.setVisible(false);
        }
        // update the dialog controls
        update();
        return true;
    }

    /**
     * Create the page for the node.
     * @param node
     *
     * @since 3.1
     */
    protected void createPage(IPreferenceNode node) {
        node.createPage();
    }

    /**
     * Get the page for the node.
     * @param node
     * @return IPreferencePage
     *
     * @since 3.1
     */
    protected IPreferencePage getPage(IPreferenceNode node) {
        return node.getPage();
    }

    /**
     * Shows the "Page Flipping abort" dialog.
     */
    void showPageFlippingAbortDialog() {
        MessageDialog.openError(getShell(), JFaceResources
                .getString("AbortPageFlippingDialog.title"), //$NON-NLS-1$
                JFaceResources.getString("AbortPageFlippingDialog.message")); //$NON-NLS-1$
    }

    /**
     * Updates this dialog's controls to reflect the current page.
     */
    protected void update() {
        // Update the title bar
        updateTitle();
        // Update the message line
        updateMessage();
        // Update the buttons
        updateButtons();
        //Saved the selected node in the preferences
        setSelectedNode();
        firePageChanged(new PageChangedEvent(this, cast(Object)getCurrentPage()));
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.preference.IPreferencePageContainer#updateButtons()
     */
    public void updateButtons() {
        okButton.setEnabled(isCurrentPageValid());
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.preference.IPreferencePageContainer#updateMessage()
     */
    public void updateMessage() {
        String message = null;
        String errorMessage = null;
        if(currentPage !is null){
            message = currentPage.getMessage();
            errorMessage = currentPage.getErrorMessage();
        }
        int messageType = IMessageProvider.NONE;
        if (message !is null && cast(IMessageProvider)currentPage ) {
            messageType = (cast(IMessageProvider) currentPage).getMessageType();
        }

        if (errorMessage is null){
            if (showingError) {
                // we were previously showing an error
                showingError = false;
            }
        }
        else {
            message = errorMessage;
            messageType = IMessageProvider.ERROR;
            if (!showingError) {
                // we were not previously showing an error
                showingError = true;
            }
        }
        messageArea.updateText(message,messageType);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.preference.IPreferencePageContainer#updateTitle()
     */
    public void updateTitle() {
        if(currentPage is null) {
            return;
        }
        messageArea.showTitle(currentPage.getTitle(), currentPage.getImage());
    }

    /**
     * Update the tree to use the specified <code>Font</code>.
     *
     * @param dialogFont
     *            the <code>Font</code> to use.
     * @since 3.0
     */
    protected void updateTreeFont(Font dialogFont) {
        getTreeViewer().getControl().setFont(dialogFont);
    }

    /**
     * Returns the currentPage.
     * @return IPreferencePage
     * @since 3.1
     */
    protected IPreferencePage getCurrentPage() {
        return currentPage;
    }

    /**
     * Sets the current page.
     * @param currentPage
     *
     * @since 3.1
     */
    protected void setCurrentPage(IPreferencePage currentPage) {
        this.currentPage = currentPage;
    }

    /**
     * Set the treeViewer.
     * @param treeViewer
     *
     * @since 3.1
     */
    protected void setTreeViewer(TreeViewer treeViewer) {
        this.treeViewer = treeViewer;
    }

    /**
     * Get the composite that is showing the page.
     *
     * @return Composite.
     *
     * @since 3.1
     */
    protected Composite getPageContainer() {
        return this.pageContainer;
    }

    /**
     * Set the composite that is showing the page.
     * @param pageContainer Composite
     *
     * @since 3.1
     */
    protected void setPageContainer(Composite pageContainer) {
        this.pageContainer = pageContainer;
    }
    /**
     * Create the page control for the supplied page.
     *
     * @param page - the preference page to be shown
     * @param parent - the composite to parent the page
     *
     * @since 3.1
     */
    protected void createPageControl(IPreferencePage page, Composite parent) {
        page.createControl(parent);
    }

    /**
     * @see dwtx.jface.dialogs.IPageChangeProvider#getSelectedPage()
     *
     * @since 3.1
     */
    public Object getSelectedPage() {
            return cast(Object)getCurrentPage();
        }

    /**
     * @see dwtx.jface.dialogs.IPageChangeProvider#addPageChangedListener(dwtx.jface.dialogs.IPageChangedListener)
     * @since 3.1
     */
    public void addPageChangedListener(IPageChangedListener listener) {
        pageChangedListeners.add(cast(Object)listener);
    }

    /**
     * @see dwtx.jface.dialogs.IPageChangeProvider#removePageChangedListener(dwtx.jface.dialogs.IPageChangedListener)
     * @since 3.1
     */
    public void removePageChangedListener(IPageChangedListener listener) {
        pageChangedListeners.remove(cast(Object)listener);

    }

    /**
     * Notifies any selection changed listeners that the selected page
     * has changed.
     * Only listeners registered at the time this method is called are notified.
     *
     * @param event a selection changed event
     *
     * @see IPageChangedListener#pageChanged
     *
     * @since 3.1
     */
    protected void firePageChanged(PageChangedEvent event) {
        Object[] listeners = pageChangedListeners.getListeners();
        for (int i = 0; i < listeners.length; i++) {
            SafeRunnable.run(new class(event,cast(IPageChangedListener) listeners[i]) SafeRunnable {
                PageChangedEvent event_;
                IPageChangedListener l;
                this(PageChangedEvent a,IPageChangedListener b){
                    event_=a;
                    l =b ;
                }
                public void run() {
                    l.pageChanged(event_);
                }
            });
        }
    }

    /*
     * (non-Javadoc)
     * @see dwtx.jface.dialogs.Dialog#isResizable()
     */
    protected bool isResizable() {
        return true;
    }

}
