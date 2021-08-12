/*******************************************************************************
 * Copyright (c) 2005, 2008 IBM Corporation and others.
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
module dwtx.jface.fieldassist.ContentProposalAdapter;

import dwtx.jface.fieldassist.IContentProposal;
import dwtx.jface.fieldassist.IContentProposalProvider;
import dwtx.jface.fieldassist.IControlContentAdapter;
import dwtx.jface.fieldassist.IControlContentAdapter2;
import dwtx.jface.fieldassist.IContentProposalListener;
import dwtx.jface.fieldassist.IContentProposalListener2;


import dwt.DWT;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.FocusAdapter;
import dwt.events.FocusEvent;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.graphics.Color;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.GridData;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.ScrollBar;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwt.widgets.TableItem;
import dwt.widgets.Text;
import dwtx.core.runtime.Assert;
import dwtx.core.runtime.ListenerList;
import dwtx.jface.bindings.keys.KeyStroke;
import dwtx.jface.dialogs.PopupDialog;
import dwtx.jface.preference.JFacePreferences;
import dwtx.jface.resource.JFaceResources;
import dwtx.jface.viewers.ILabelProvider;

import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;
import dwtx.dwtxhelper.JThread;
static import tango.text.Text;
import tango.io.Stdout;
import tango.text.convert.Format;
alias tango.text.Text.Text!(char) StringBuffer;
/**
 * ContentProposalAdapter can be used to attach content proposal behavior to a
 * control. This behavior includes obtaining proposals, opening a popup dialog,
 * managing the content of the control relative to the selections in the popup,
 * and optionally opening up a secondary popup to further describe proposals.
 * <p>
 * A number of configurable options are provided to determine how the control
 * content is altered when a proposal is chosen, how the content proposal popup
 * is activated, and whether any filtering should be done on the proposals as
 * the user types characters.
 * <p>
 * This class is not intended to be subclassed.
 *
 * @since 3.2
 */
public class ContentProposalAdapter {

    /*
     * The lightweight popup used to show content proposals for a text field. If
     * additional information exists for a proposal, then selecting that
     * proposal will result in the information being displayed in a secondary
     * popup.
     */
    class ContentProposalPopup : PopupDialog {
        /*
         * The listener we install on the popup and related controls to
         * determine when to close the popup. Some events (move, resize, close,
         * deactivate) trigger closure as soon as they are received, simply
         * because one of the registered listeners received them. Other events
         * depend on additional circumstances.
         */
        private final class PopupCloserListener : Listener {
            private bool scrollbarClicked = false;

            public void handleEvent(Event e) {

                // If focus is leaving an important widget or the field's
                // shell is deactivating
                if (e.type is DWT.FocusOut) {
                    scrollbarClicked = false;
                    /*
                     * Ignore this event if it's only happening because focus is
                     * moving between the popup shells, their controls, or a
                     * scrollbar. Do this in an async since the focus is not
                     * actually switched when this event is received.
                     */
                    e.display.asyncExec(new class(e) Runnable {
                        Event e_;
                        this(Event e__){ e_=e__; }
                        public void run() {
                            if (isValid()) {
                                if (scrollbarClicked || hasFocus()) {
                                    return;
                                }
                                // Workaround a problem on X and Mac, whereby at
                                // this point, the focus control is not known.
                                // This can happen, for example, when resizing
                                // the popup shell on the Mac.
                                // Check the active shell.
                                Shell activeShell = e_.display.getActiveShell();
                                if (activeShell is getShell()
                                        || (infoPopup !is null && infoPopup
                                                .getShell() is activeShell)) {
                                    return;
                                }
                                /*
                                 * System.out.println(e);
                                 * System.out.println(e.display.getFocusControl());
                                 * System.out.println(e.display.getActiveShell());
                                 */
                                close();
                            }
                        }
                    });
                    return;
                }

                // Scroll bar has been clicked. Remember this for focus event
                // processing.
                if (e.type is DWT.Selection) {
                    scrollbarClicked = true;
                    return;
                }
                // For all other events, merely getting them dictates closure.
                close();
            }

            // Install the listeners for events that need to be monitored for
            // popup closure.
            void installListeners() {
                // Listeners on this popup's table and scroll bar
                proposalTable.addListener(DWT.FocusOut, this);
                ScrollBar scrollbar = proposalTable.getVerticalBar();
                if (scrollbar !is null) {
                    scrollbar.addListener(DWT.Selection, this);
                }

                // Listeners on this popup's shell
                getShell().addListener(DWT.Deactivate, this);
                getShell().addListener(DWT.Close, this);

                // Listeners on the target control
                control.addListener(DWT.MouseDoubleClick, this);
                control.addListener(DWT.MouseDown, this);
                control.addListener(DWT.Dispose, this);
                control.addListener(DWT.FocusOut, this);
                // Listeners on the target control's shell
                Shell controlShell = control.getShell();
                controlShell.addListener(DWT.Move, this);
                controlShell.addListener(DWT.Resize, this);

            }

            // Remove installed listeners
            void removeListeners() {
                if (isValid()) {
                    proposalTable.removeListener(DWT.FocusOut, this);
                    ScrollBar scrollbar = proposalTable.getVerticalBar();
                    if (scrollbar !is null) {
                        scrollbar.removeListener(DWT.Selection, this);
                    }

                    getShell().removeListener(DWT.Deactivate, this);
                    getShell().removeListener(DWT.Close, this);
                }

                if (control !is null && !control.isDisposed()) {

                    control.removeListener(DWT.MouseDoubleClick, this);
                    control.removeListener(DWT.MouseDown, this);
                    control.removeListener(DWT.Dispose, this);
                    control.removeListener(DWT.FocusOut, this);

                    Shell controlShell = control.getShell();
                    controlShell.removeListener(DWT.Move, this);
                    controlShell.removeListener(DWT.Resize, this);
                }
            }
        }

        /*
         * The listener we will install on the target control.
         */
        private final class TargetControlListener : Listener {
            // Key events from the control
            public void handleEvent(Event e) {
                if (!isValid()) {
                    return;
                }

                char key = e.character;

                // Traverse events are handled depending on whether the
                // event has a character.
                if (e.type is DWT.Traverse) {
                    // If the traverse event contains a legitimate character,
                    // then we must set doit false so that the widget will
                    // receive the key event. We return immediately so that
                    // the character is handled only in the key event.
                    // See https://bugs.eclipse.org/bugs/show_bug.cgi?id=132101
                    if (key !is 0) {
                        e.doit = false;
                        return;
                    }
                    // Traversal does not contain a character. Set doit true
                    // to indicate TRAVERSE_NONE will occur and that no key
                    // event will be triggered. We will check for navigation
                    // keys below.
                    e.detail = DWT.TRAVERSE_NONE;
                    e.doit = true;
                } else {
                    // Default is to only propagate when configured that way.
                    // Some keys will always set doit to false anyway.
                    e.doit = propagateKeys;
                }

                // No character. Check for navigation keys.

                if (key is 0) {
                    int newSelection = proposalTable.getSelectionIndex();
                    int visibleRows = (proposalTable.getSize().y / proposalTable
                            .getItemHeight()) - 1;
                    switch (e.keyCode) {
                    case DWT.ARROW_UP:
                        newSelection -= 1;
                        if (newSelection < 0) {
                            newSelection = proposalTable.getItemCount() - 1;
                        }
                        // Not typical - usually we get this as a Traverse and
                        // therefore it never propagates. Added for consistency.
                        if (e.type is DWT.KeyDown) {
                            // don't propagate to control
                            e.doit = false;
                        }

                        break;

                    case DWT.ARROW_DOWN:
                        newSelection += 1;
                        if (newSelection > proposalTable.getItemCount() - 1) {
                            newSelection = 0;
                        }
                        // Not typical - usually we get this as a Traverse and
                        // therefore it never propagates. Added for consistency.
                        if (e.type is DWT.KeyDown) {
                            // don't propagate to control
                            e.doit = false;
                        }

                        break;

                    case DWT.PAGE_DOWN:
                        newSelection += visibleRows;
                        if (newSelection >= proposalTable.getItemCount()) {
                            newSelection = proposalTable.getItemCount() - 1;
                        }
                        if (e.type is DWT.KeyDown) {
                            // don't propagate to control
                            e.doit = false;
                        }
                        break;

                    case DWT.PAGE_UP:
                        newSelection -= visibleRows;
                        if (newSelection < 0) {
                            newSelection = 0;
                        }
                        if (e.type is DWT.KeyDown) {
                            // don't propagate to control
                            e.doit = false;
                        }
                        break;

                    case DWT.HOME:
                        newSelection = 0;
                        if (e.type is DWT.KeyDown) {
                            // don't propagate to control
                            e.doit = false;
                        }
                        break;

                    case DWT.END:
                        newSelection = proposalTable.getItemCount() - 1;
                        if (e.type is DWT.KeyDown) {
                            // don't propagate to control
                            e.doit = false;
                        }
                        break;

                    // If received as a Traverse, these should propagate
                    // to the control as keydown. If received as a keydown,
                    // proposals should be recomputed since the cursor
                    // position has changed.
                    case DWT.ARROW_LEFT:
                    case DWT.ARROW_RIGHT:
                        if (e.type is DWT.Traverse) {
                            e.doit = false;
                        } else {
                            e.doit = true;
                            String contents = getControlContentAdapter()
                                    .getControlContents(getControl());
                            // If there are no contents, changes in cursor
                            // position have no effect. Note also that we do
                            // not affect the filter text on ARROW_LEFT as
                            // we would with BS.
                            if (contents.length > 0) {
                                asyncRecomputeProposals(filterText);
                            }
                        }
                        break;

                    // Any unknown keycodes will cause the popup to close.
                    // Modifier keys are explicitly checked and ignored because
                    // they are not complete yet (no character).
                    default:
                        if (e.keyCode !is DWT.CAPS_LOCK && e.keyCode !is DWT.MOD1
                                && e.keyCode !is DWT.MOD2
                                && e.keyCode !is DWT.MOD3
                                && e.keyCode !is DWT.MOD4) {
                            close();
                        }
                        return;
                    }

                    // If any of these navigation events caused a new selection,
                    // then handle that now and return.
                    if (newSelection >= 0) {
                        selectProposal(newSelection);
                    }
                    return;
                }

                // key !is 0
                // Check for special keys involved in cancelling, accepting, or
                // filtering the proposals.
                switch (key) {
                case DWT.ESC:
                    e.doit = false;
                    close();
                    break;

                case DWT.LF:
                case DWT.CR:
                    e.doit = false;
                    Object p = cast(Object)getSelectedProposal();
                    if (p !is null) {
                        acceptCurrentProposal();
                    } else {
                        close();
                    }
                    break;

                case DWT.TAB:
                    e.doit = false;
                    getShell().setFocus();
                    return;

                case DWT.BS:
                    // Backspace should back out of any stored filter text
                    if (filterStyle !is FILTER_NONE) {
                        // We have no filter to back out of, so do nothing
                        if (filterText.length is 0) {
                            return;
                        }
                        // There is filter to back out of
                        filterText = filterText.substring(0, filterText
                                .length - 1);
                        asyncRecomputeProposals(filterText);
                        return;
                    }
                    // There is no filtering provided by us, but some
                    // clients provide their own filtering based on content.
                    // Recompute the proposals if the cursor position
                    // will change (is not at 0).
                    int pos = getControlContentAdapter().getCursorPosition(
                            getControl());
                    // We rely on the fact that the contents and pos do not yet
                    // reflect the result of the BS. If the contents were
                    // already empty, then BS should not cause
                    // a recompute.
                    if (pos > 0) {
                        asyncRecomputeProposals(filterText);
                    }
                    break;

                default:
                    // If the key is a defined unicode character, and not one of
                    // the special cases processed above, update the filter text
                    // and filter the proposals.
                    if (CharacterIsDefined(key)) {
                        if (filterStyle is FILTER_CUMULATIVE) {
                            filterText = filterText ~ dcharToString(key);
                        } else if (filterStyle is FILTER_CHARACTER) {
                            filterText = dcharToString(key);
                        }
                        // Recompute proposals after processing this event.
                        asyncRecomputeProposals(filterText);
                    }
                    break;
                }
            }
        }

        /*
         * Internal class used to implement the secondary popup.
         */
        private class InfoPopupDialog : PopupDialog {

            /*
             * The text control that displays the text.
             */
            private Text text;

            /*
             * The String shown in the popup.
             */
            private String contents = EMPTY;

            /*
             * Construct an info-popup with the specified parent.
             */
            this(Shell parent) {
                super(parent, PopupDialog.HOVER_SHELLSTYLE, false, false,
                        false, false, null, null);
            }

            /*
             * Create a text control for showing the info about a proposal.
             */
            protected override Control createDialogArea(Composite parent) {
                text = new Text(parent, DWT.MULTI | DWT.READ_ONLY | DWT.WRAP
                        | DWT.NO_FOCUS);

                // Use the compact margins employed by PopupDialog.
                GridData gd = new GridData(GridData.BEGINNING
                        | GridData.FILL_BOTH);
                gd.horizontalIndent = PopupDialog.POPUP_HORIZONTALSPACING;
                gd.verticalIndent = PopupDialog.POPUP_VERTICALSPACING;
                text.setLayoutData(gd);
                text.setText(contents);

                // since DWT.NO_FOCUS is only a hint...
                text.addFocusListener(new class FocusAdapter {
                    public void focusGained(FocusEvent event) {
                        this.outer.close();
                    }
                });
                return text;
            }

            /*
             * Adjust the bounds so that we appear adjacent to our parent shell
             */
            protected override void adjustBounds() {
                Rectangle parentBounds = getParentShell().getBounds();
                Rectangle proposedBounds;
                // Try placing the info popup to the right
                Rectangle rightProposedBounds = new Rectangle(parentBounds.x
                        + parentBounds.width
                        + PopupDialog.POPUP_HORIZONTALSPACING, parentBounds.y
                        + PopupDialog.POPUP_VERTICALSPACING,
                        parentBounds.width, parentBounds.height);
                rightProposedBounds = getConstrainedShellBounds(rightProposedBounds);
                // If it won't fit on the right, try the left
                if (rightProposedBounds.intersects(parentBounds)) {
                    Rectangle leftProposedBounds = new Rectangle(parentBounds.x
                            - parentBounds.width - POPUP_HORIZONTALSPACING - 1,
                            parentBounds.y, parentBounds.width,
                            parentBounds.height);
                    leftProposedBounds = getConstrainedShellBounds(leftProposedBounds);
                    // If it won't fit on the left, choose the proposed bounds
                    // that fits the best
                    if (leftProposedBounds.intersects(parentBounds)) {
                        if (rightProposedBounds.x - parentBounds.x >= parentBounds.x
                                - leftProposedBounds.x) {
                            rightProposedBounds.x = parentBounds.x
                                    + parentBounds.width
                                    + PopupDialog.POPUP_HORIZONTALSPACING;
                            proposedBounds = rightProposedBounds;
                        } else {
                            leftProposedBounds.width = parentBounds.x
                                    - POPUP_HORIZONTALSPACING
                                    - leftProposedBounds.x;
                            proposedBounds = leftProposedBounds;
                        }
                    } else {
                        // use the proposed bounds on the left
                        proposedBounds = leftProposedBounds;
                    }
                } else {
                    // use the proposed bounds on the right
                    proposedBounds = rightProposedBounds;
                }
                getShell().setBounds(proposedBounds);
            }

            /*
             * (non-Javadoc)
             * @see dwtx.jface.dialogs.PopupDialog#getForeground()
             */
            protected Color getForeground() {
                return control.getDisplay().
                        getSystemColor(DWT.COLOR_INFO_FOREGROUND);
            }

            /*
             * (non-Javadoc)
             * @see dwtx.jface.dialogs.PopupDialog#getBackground()
             */
            protected Color getBackground() {
                return control.getDisplay().
                        getSystemColor(DWT.COLOR_INFO_BACKGROUND);
            }

            /*
             * Set the text contents of the popup.
             */
            void setContents(String newContents) {
                if (newContents is null) {
                    newContents = EMPTY;
                }
                this.contents = newContents;
                if (text !is null && !text.isDisposed()) {
                    text.setText(contents);
                }
            }

            /*
             * Return whether the popup has focus.
             */
            bool hasFocus() {
                if (text is null || text.isDisposed()) {
                    return false;
                }
                return text.getShell().isFocusControl()
                        || text.isFocusControl();
            }
        }

        /*
         * The listener installed on the target control.
         */
        private Listener targetControlListener;

        /*
         * The listener installed in order to close the popup.
         */
        private PopupCloserListener popupCloser;

        /*
         * The table used to show the list of proposals.
         */
        private Table proposalTable;

        /*
         * The proposals to be shown (cached to avoid repeated requests).
         */
        private IContentProposal[] proposals;

        /*
         * Secondary popup used to show detailed information about the selected
         * proposal..
         */
        private InfoPopupDialog infoPopup;

        /*
         * Flag indicating whether there is a pending secondary popup update.
         */
        private bool pendingDescriptionUpdate = false;

        /*
         * Filter text - tracked while popup is open, only if we are told to
         * filter
         */
        private String filterText = EMPTY;

        /**
         * Constructs a new instance of this popup, specifying the control for
         * which this popup is showing content, and how the proposals should be
         * obtained and displayed.
         *
         * @param infoText
         *            Text to be shown in a lower info area, or
         *            <code>null</code> if there is no info area.
         */
        this(String infoText, IContentProposal[] proposals) {
            // IMPORTANT: Use of DWT.ON_TOP is critical here for ensuring
            // that the target control retains focus on Mac and Linux. Without
            // it, the focus will disappear, keystrokes will not go to the
            // popup, and the popup closer will wrongly close the popup.
            // On platforms where DWT.ON_TOP overrides DWT.RESIZE, we will live
            // with this.
            // See https://bugs.eclipse.org/bugs/show_bug.cgi?id=126138
            super(control.getShell(), DWT.RESIZE | DWT.ON_TOP, false, false,
                    false, false, null, infoText);
            this.proposals = proposals;
        }

        /*
         * (non-Javadoc)
         * @see dwtx.jface.dialogs.PopupDialog#getForeground()
         */
        protected Color getForeground() {
            return JFaceResources.getColorRegistry().get(
                    JFacePreferences.CONTENT_ASSIST_FOREGROUND_COLOR);
        }

        /*
         * (non-Javadoc)
         * @see dwtx.jface.dialogs.PopupDialog#getBackground()
         */
        protected Color getBackground() {
            return JFaceResources.getColorRegistry().get(
                    JFacePreferences.CONTENT_ASSIST_BACKGROUND_COLOR);
        }

        /*
         * Creates the content area for the proposal popup. This creates a table
         * and places it inside the composite. The table will contain a list of
         * all the proposals.
         *
         * @param parent The parent composite to contain the dialog area; must
         * not be <code>null</code>.
         */
        protected override final Control createDialogArea(Composite parent) {
            // Use virtual where appropriate (see flag definition).
            if (USE_VIRTUAL) {
                proposalTable = new Table(parent, DWT.H_SCROLL | DWT.V_SCROLL
                        | DWT.VIRTUAL);

                Listener listener = new class Listener {
                    public void handleEvent(Event event) {
                        handleSetData(event);
                    }
                };
                proposalTable.addListener(DWT.SetData, listener);
            } else {
                proposalTable = new Table(parent, DWT.H_SCROLL | DWT.V_SCROLL);
            }

            // set the proposals to force population of the table.
            setProposals(filterProposals(proposals, filterText));

            proposalTable.setHeaderVisible(false);
            proposalTable.addSelectionListener(new class SelectionListener {

                public void widgetSelected(SelectionEvent e) {
                    // If a proposal has been selected, show it in the secondary
                    // popup. Otherwise close the popup.
                    if (e.item is null) {
                        if (infoPopup !is null) {
                            infoPopup.close();
                        }
                    } else {
                        showProposalDescription();
                    }
                }

                // Default selection was made. Accept the current proposal.
                public void widgetDefaultSelected(SelectionEvent e) {
                    acceptCurrentProposal();
                }
            });
            return proposalTable;
        }

        /*
         * (non-Javadoc)
         *
         * @see dwtx.jface.dialogs.PopupDialog.adjustBounds()
         */
        protected override void adjustBounds() {
            // Get our control's location in display coordinates.
            Point location = control.getDisplay().map(control.getParent(),
                    null, control.getLocation());
            int initialX = location.x + POPUP_OFFSET;
            int initialY = location.y + control.getSize().y + POPUP_OFFSET;
            // If we are inserting content, use the cursor position to
            // position the control.
            if (getProposalAcceptanceStyle() is PROPOSAL_INSERT) {
                Rectangle insertionBounds = controlContentAdapter
                        .getInsertionBounds(control);
                initialX = initialX + insertionBounds.x;
                initialY = location.y + insertionBounds.y
                        + insertionBounds.height;
            }

            // If there is no specified size, force it by setting
            // up a layout on the table.
            if (popupSize is null) {
                GridData data = new GridData(GridData.FILL_BOTH);
                data.heightHint = proposalTable.getItemHeight()
                        * POPUP_CHAR_HEIGHT;
                data.widthHint = Math.max(control.getSize().x,
                        POPUP_MINIMUM_WIDTH);
                proposalTable.setLayoutData(data);
                getShell().pack();
                popupSize = getShell().getSize();
            }
            getShell().setBounds(initialX, initialY, popupSize.x, popupSize.y);

            // Now set up a listener to monitor any changes in size.
            getShell().addListener(DWT.Resize, new class Listener {
                public void handleEvent(Event e) {
                    popupSize = getShell().getSize();
                    if (infoPopup !is null) {
                        infoPopup.adjustBounds();
                    }
                }
            });
        }

        /*
         * Handle the set data event. Set the item data of the requested item to
         * the corresponding proposal in the proposal cache.
         */
        private void handleSetData(Event event) {
            TableItem item = cast(TableItem) event.item;
            int index = proposalTable.indexOf(item);

            if (0 <= index && index < proposals.length) {
                IContentProposal current = proposals[index];
                item.setText(getString(current));
                item.setImage(getImage(current));
                item.setData(cast(Object)current);
            } else {
                // this should not happen, but does on win32
            }
        }

        /*
         * Caches the specified proposals and repopulates the table if it has
         * been created.
         */
        private void setProposals(IContentProposal[] newProposals) {
            if (newProposals is null || newProposals.length is 0) {
                newProposals = getEmptyProposalArray();
            }
            this.proposals = newProposals;

            // If there is a table
            if (isValid()) {
                final int newSize = newProposals.length;
                if (USE_VIRTUAL) {
                    // Set and clear the virtual table. Data will be
                    // provided in the DWT.SetData event handler.
                    proposalTable.setItemCount(newSize);
                    proposalTable.clearAll();
                } else {
                    // Populate the table manually
                    proposalTable.setRedraw(false);
                    proposalTable.setItemCount(newSize);
                    TableItem[] items = proposalTable.getItems();
                    for (int i = 0; i < items.length; i++) {
                        TableItem item = items[i];
                        IContentProposal proposal = newProposals[i];
                        item.setText(getString(proposal));
                        item.setImage(getImage(proposal));
                        item.setData(cast(Object)proposal);
                    }
                    proposalTable.setRedraw(true);
                }
                // Default to the first selection if there is content.
                if (newProposals.length > 0) {
                    selectProposal(0);
                } else {
                    // No selection, close the secondary popup if it was open
                    if (infoPopup !is null) {
                        infoPopup.close();
                    }

                }
            }
        }

        /*
         * Get the string for the specified proposal. Always return a String of
         * some kind.
         */
        private String getString(IContentProposal proposal) {
            if (proposal is null) {
                return EMPTY;
            }
            if (labelProvider is null) {
                return proposal.getLabel() is null ? proposal.getContent()
                        : proposal.getLabel();
            }
            return labelProvider.getText(cast(Object)proposal);
        }

        /*
         * Get the image for the specified proposal. If there is no image
         * available, return null.
         */
        private Image getImage(IContentProposal proposal) {
            if (proposal is null || labelProvider is null) {
                return null;
            }
            return labelProvider.getImage(cast(Object)proposal);
        }

        /*
         * Return an empty array. Used so that something always shows in the
         * proposal popup, even if no proposal provider was specified.
         */
        private IContentProposal[] getEmptyProposalArray() {
            return new IContentProposal[0];
        }

        /*
         * Answer true if the popup is valid, which means the table has been
         * created and not disposed.
         */
        private bool isValid() {
            return proposalTable !is null && !proposalTable.isDisposed();
        }

        /*
         * Return whether the receiver has focus. Since 3.4, this includes a
         * check for whether the info popup has focus.
         */
        private bool hasFocus() {
            if (!isValid()) {
                return false;
            }
            if (getShell().isFocusControl() || proposalTable.isFocusControl()) {
                return true;
            }
            if (infoPopup !is null && infoPopup.hasFocus()) {
                return true;
            }
            return false;
        }

        /*
         * Return the current selected proposal.
         */
        private IContentProposal getSelectedProposal() {
            if (isValid()) {
                int i = proposalTable.getSelectionIndex();
                if (proposals is null || i < 0 || i >= proposals.length) {
                    return null;
                }
                return proposals[i];
            }
            return null;
        }

        /*
         * Select the proposal at the given index.
         */
        private void selectProposal(int index) {
            Assert
                    .isTrue(index >= 0,
                            "Proposal index should never be negative"); //$NON-NLS-1$
            if (!isValid() || proposals is null || index >= proposals.length) {
                return;
            }
            proposalTable.setSelection(index);
            proposalTable.showSelection();

            showProposalDescription();
        }

        /**
         * Opens this ContentProposalPopup. This method is extended in order to
         * add the control listener when the popup is opened and to invoke the
         * secondary popup if applicable.
         *
         * @return the return code
         *
         * @see dwtx.jface.window.Window#open()
         */
        public override int open() {
            int value = super.open();
            if (popupCloser is null) {
                popupCloser = new PopupCloserListener();
            }
            popupCloser.installListeners();
            IContentProposal p = getSelectedProposal();
            if (p !is null) {
                showProposalDescription();
            }
            return value;
        }

        /**
         * Closes this popup. This method is extended to remove the control
         * listener.
         *
         * @return <code>true</code> if the window is (or was already) closed,
         *         and <code>false</code> if it is still open
         */
        public override bool close() {
            popupCloser.removeListeners();
            if (infoPopup !is null) {
                infoPopup.close();
            }
            bool ret = super.close();
            notifyPopupClosed();
            return ret;
        }

        /*
         * Show the currently selected proposal's description in a secondary
         * popup.
         */
        private void showProposalDescription() {
            // If we do not already have a pending update, then
            // create a thread now that will show the proposal description
            if (!pendingDescriptionUpdate) {
                // Create a thread that will sleep for the specified delay
                // before creating the popup. We do not use Jobs since this
                // code must be able to run independently of the Eclipse
                // runtime.
                auto r = new class() Runnable {
                    public void run() {
                        pendingDescriptionUpdate = true;

                        try {
                            JThread.sleep( POPUP_DELAY );
                        }
                        catch (InterruptedException e) {
                        }

                        if (!isValid()) {
                            return;
                        }
                        getShell().getDisplay().syncExec(new class() Runnable {
                            public void run() {
                                // Query the current selection since we have
                                // been delayed
                                IContentProposal p = getSelectedProposal();
                                if (p !is null) {
                                    String description = p.getDescription();
                                    if (description !is null) {
                                        if (infoPopup is null) {
                                            infoPopup = new InfoPopupDialog(
                                                    getShell());
                                            infoPopup.open();
                                            infoPopup
                                                    .getShell()
                                                    .addDisposeListener(
                                                            new class DisposeListener {
                                                                public void widgetDisposed(
                                                                        DisposeEvent event) {
                                                                    infoPopup = null;
                                                                }
                                                            });
                                        }
                                        infoPopup.setContents(p
                                                .getDescription());
                                    } else if (infoPopup !is null) {
                                        infoPopup.close();
                                    }
                                    pendingDescriptionUpdate = false;

                                }
                            }
                        });
                    }
                };
                JThread t = new JThread(r);
                t.start();
            }
        }

        /*
         * Accept the current proposal.
         */
        private void acceptCurrentProposal() {
            // Close before accepting the proposal. This is important
            // so that the cursor position can be properly restored at
            // acceptance, which does not work without focus on some controls.
            // See https://bugs.eclipse.org/bugs/show_bug.cgi?id=127108
            IContentProposal proposal = getSelectedProposal();
            close();
            proposalAccepted(proposal);
        }

        /*
         * Request the proposals from the proposal provider, and recompute any
         * caches. Repopulate the popup if it is open.
         */
        private void recomputeProposals(String filterText) {
            IContentProposal[] allProposals = getProposals();
            // If the non-filtered proposal list is empty, we should
            // close the popup.
            // See https://bugs.eclipse.org/bugs/show_bug.cgi?id=147377
            if (allProposals.length is 0) {
                proposals = allProposals;
                close();
            } else {
                // Keep the popup open, but filter by any provided filter text
                setProposals(filterProposals(allProposals, filterText));
            }
        }

        /*
         * In an async block, request the proposals. This is used when clients
         * are in the middle of processing an event that affects the widget
         * content. By using an async, we ensure that the widget content is up
         * to date with the event.
         */
        private void asyncRecomputeProposals(String filterText) {
            if (isValid()) {
                control.getDisplay().asyncExec(new class(filterText) Runnable {
                    String filterText_;
                    this(String a){filterText_=a;}
                    public void run() {
                        recordCursorPosition();
                        recomputeProposals(filterText_);
                    }
                });
            } else {
                recomputeProposals(filterText);
            }
        }

        /*
         * Filter the provided list of content proposals according to the filter
         * text.
         */
        private IContentProposal[] filterProposals(
                IContentProposal[] proposals, String filterString) {
            if (filterString.length is 0) {
                return proposals;
            }

            // Check each string for a match. Use the string displayed to the
            // user, not the proposal content.
            scope IContentProposal[] list = new IContentProposal[proposals.length];
            int idx = 0;
            for (int i = 0; i < proposals.length; i++) {
                String string = getString(proposals[i]);
                if (string.length >= filterString.length
                        && string.substring(0, filterString.length)
                                .equalsIgnoreCase(filterString)) {
                    list[idx++] = proposals[i];
                }

            }
            return list[ 0 .. idx ].dup;
        }

        Listener getTargetControlListener() {
            if (targetControlListener is null) {
                targetControlListener = new TargetControlListener();
            }
            return targetControlListener;
        }
    }

    /**
     * Flag that controls the printing of debug info.
     */
    public static const bool DEBUG = false;

    /**
     * Indicates that a chosen proposal should be inserted into the field.
     */
    public static const int PROPOSAL_INSERT = 1;

    /**
     * Indicates that a chosen proposal should replace the entire contents of
     * the field.
     */
    public static const int PROPOSAL_REPLACE = 2;

    /**
     * Indicates that the contents of the control should not be modified when a
     * proposal is chosen. This is typically used when a client needs more
     * specialized behavior when a proposal is chosen. In this case, clients
     * typically register an IContentProposalListener so that they are notified
     * when a proposal is chosen.
     */
    public static const int PROPOSAL_IGNORE = 3;

    /**
     * Indicates that there should be no filter applied as keys are typed in the
     * popup.
     */
    public static const int FILTER_NONE = 1;

    /**
     * Indicates that a single character filter applies as keys are typed in the
     * popup.
     */
    public static const int FILTER_CHARACTER = 2;

    /**
     * Indicates that a cumulative filter applies as keys are typed in the
     * popup. That is, each character typed will be added to the filter.
     *
     * @deprecated As of 3.4, filtering that is sensitive to changes in the
     *             control content should be performed by the supplied
     *             {@link IContentProposalProvider}, such as that performed by
     *             {@link SimpleContentProposalProvider}
     */
    public static const int FILTER_CUMULATIVE = 3;

    /*
     * Set to <code>true</code> to use a Table with DWT.VIRTUAL. This is a
     * workaround for https://bugs.eclipse.org/bugs/show_bug.cgi?id=98585#c40
     * The corresponding DWT bug is
     * https://bugs.eclipse.org/bugs/show_bug.cgi?id=90321
     */
    private static const bool USE_VIRTUAL = !"motif".equals(DWT.getPlatform()); //$NON-NLS-1$

    /*
     * The delay before showing a secondary popup.
     */
    private static const int POPUP_DELAY = 750;

    /*
     * The character height hint for the popup. May be overridden by using
     * setInitialPopupSize.
     */
    private static const int POPUP_CHAR_HEIGHT = 10;

    /*
     * The minimum pixel width for the popup. May be overridden by using
     * setInitialPopupSize.
     */
    private static const int POPUP_MINIMUM_WIDTH = 300;

    /*
     * The pixel offset of the popup from the bottom corner of the control.
     */
    private static const int POPUP_OFFSET = 3;

    /*
     * Empty string.
     */
    private static const String EMPTY = ""; //$NON-NLS-1$

    /*
     * The object that provides content proposals.
     */
    private IContentProposalProvider proposalProvider;

    /*
     * A label provider used to display proposals in the popup, and to extract
     * Strings from non-String proposals.
     */
    private ILabelProvider labelProvider;

    /*
     * The control for which content proposals are provided.
     */
    private Control control;

    /*
     * The adapter used to extract the String contents from an arbitrary
     * control.
     */
    private IControlContentAdapter controlContentAdapter;

    /*
     * The popup used to show proposals.
     */
    private ContentProposalPopup popup;

    /*
     * The keystroke that signifies content proposals should be shown.
     */
    private KeyStroke triggerKeyStroke;

    /*
     * The String containing characters that auto-activate the popup.
     */
    private String autoActivateString;

    /*
     * Integer that indicates how an accepted proposal should affect the
     * control. One of PROPOSAL_IGNORE, PROPOSAL_INSERT, or PROPOSAL_REPLACE.
     * Default value is PROPOSAL_INSERT.
     */
    private int proposalAcceptanceStyle = PROPOSAL_INSERT;

    /*
     * A bool that indicates whether key events received while the proposal
     * popup is open should also be propagated to the control. Default value is
     * true.
     */
    private bool propagateKeys = true;

    /*
     * Integer that indicates the filtering style. One of FILTER_CHARACTER,
     * FILTER_CUMULATIVE, FILTER_NONE.
     */
    private int filterStyle = FILTER_NONE;

    /*
     * The listener we install on the control.
     */
    private Listener controlListener;

    /*
     * The list of IContentProposalListener listeners.
     */
    private ListenerList proposalListeners;

    /*
     * The list of IContentProposalListener2 listeners.
     */
    private ListenerList proposalListeners2;

    /*
     * Flag that indicates whether the adapter is enabled. In some cases,
     * adapters may be installed but depend upon outside state.
     */
    private bool isEnabled_ = true;

    /*
     * The delay in milliseconds used when autoactivating the popup.
     */
    private int autoActivationDelay = 0;

    /*
     * A bool indicating whether a keystroke has been received. Used to see
     * if an autoactivation delay was interrupted by a keystroke.
     */
    private bool receivedKeyDown;

    /*
     * The desired size in pixels of the proposal popup.
     */
    private Point popupSize;

    /*
     * The remembered position of the insertion position. Not all controls will
     * restore the insertion position if the proposal popup gets focus, so we
     * need to remember it.
     */
    private int insertionPos = -1;

    /*
     * The remembered selection range. Not all controls will restore the
     * selection position if the proposal popup gets focus, so we need to
     * remember it.
     */
    private Point selectionRange;

    /*
     * A flag that indicates that we are watching modify events
     */
    private bool watchModify = false;

    /**
     * Construct a content proposal adapter that can assist the user with
     * choosing content for the field.
     *
     * @param control
     *            the control for which the adapter is providing content assist.
     *            May not be <code>null</code>.
     * @param controlContentAdapter
     *            the <code>IControlContentAdapter</code> used to obtain and
     *            update the control's contents as proposals are accepted. May
     *            not be <code>null</code>.
     * @param proposalProvider
     *            the <code>IContentProposalProvider</code> used to obtain
     *            content proposals for this control, or <code>null</code> if
     *            no content proposal is available.
     * @param keyStroke
     *            the keystroke that will invoke the content proposal popup. If
     *            this value is <code>null</code>, then proposals will be
     *            activated automatically when any of the auto activation
     *            characters are typed.
     * @param autoActivationCharacters
     *            An array of characters that trigger auto-activation of content
     *            proposal. If specified, these characters will trigger
     *            auto-activation of the proposal popup, regardless of whether
     *            an explicit invocation keyStroke was specified. If this
     *            parameter is <code>null</code>, then only a specified
     *            keyStroke will invoke content proposal. If this parameter is
     *            <code>null</code> and the keyStroke parameter is
     *            <code>null</code>, then all alphanumeric characters will
     *            auto-activate content proposal.
     */
    public this(Control control,
            IControlContentAdapter controlContentAdapter,
            IContentProposalProvider proposalProvider, KeyStroke keyStroke,
            char[] autoActivationCharacters) {
        //DWT_Init
        proposalListeners = new ListenerList();
        proposalListeners2 = new ListenerList();
        selectionRange = new Point(-1, -1);
        //super();
        // We always assume the control and content adapter are valid.
        Assert.isNotNull(cast(Object)control);
        Assert.isNotNull(cast(Object)controlContentAdapter);
        this.control = control;
        this.controlContentAdapter = controlContentAdapter;

        // The rest of these may be null
        this.proposalProvider = proposalProvider;
        this.triggerKeyStroke = keyStroke;
        if (autoActivationCharacters.length !is 0 ) {
            this.autoActivateString = autoActivationCharacters;
        }
        addControlListener(control);
    }

    /**
     * Get the control on which the content proposal adapter is installed.
     *
     * @return the control on which the proposal adapter is installed.
     */
    public Control getControl() {
        return control;
    }

    /**
     * Get the label provider that is used to show proposals.
     *
     * @return the {@link ILabelProvider} used to show proposals, or
     *         <code>null</code> if one has not been installed.
     */
    public ILabelProvider getLabelProvider() {
        return labelProvider;
    }

    /**
     * Return a bool indicating whether the receiver is enabled.
     *
     * @return <code>true</code> if the adapter is enabled, and
     *         <code>false</code> if it is not.
     */
    public bool isEnabled() {
        return isEnabled_;
    }

    /**
     * Set the label provider that is used to show proposals. The lifecycle of
     * the specified label provider is not managed by this adapter. Clients must
     * dispose the label provider when it is no longer needed.
     *
     * @param labelProvider
     *            the (@link ILabelProvider} used to show proposals.
     */
    public void setLabelProvider(ILabelProvider labelProvider) {
        this.labelProvider = labelProvider;
    }

    /**
     * Return the proposal provider that provides content proposals given the
     * current content of the field. A value of <code>null</code> indicates
     * that there are no content proposals available for the field.
     *
     * @return the {@link IContentProposalProvider} used to show proposals. May
     *         be <code>null</code>.
     */
    public IContentProposalProvider getContentProposalProvider() {
        return proposalProvider;
    }

    /**
     * Set the content proposal provider that is used to show proposals.
     *
     * @param proposalProvider
     *            the {@link IContentProposalProvider} used to show proposals
     */
    public void setContentProposalProvider(
            IContentProposalProvider proposalProvider) {
        this.proposalProvider = proposalProvider;
    }

    /**
     * Return the array of characters on which the popup is autoactivated.
     *
     * @return An array of characters that trigger auto-activation of content
     *         proposal. If specified, these characters will trigger
     *         auto-activation of the proposal popup, regardless of whether an
     *         explicit invocation keyStroke was specified. If this parameter is
     *         <code>null</code>, then only a specified keyStroke will invoke
     *         content proposal. If this value is <code>null</code> and the
     *         keyStroke value is <code>null</code>, then all alphanumeric
     *         characters will auto-activate content proposal.
     */
    public char[] getAutoActivationCharacters() {
        if (autoActivateString is null) {
            return null;
        }
        return autoActivateString/+.toCharArray()+/;
    }

    /**
     * Set the array of characters that will trigger autoactivation of the
     * popup.
     *
     * @param autoActivationCharacters
     *            An array of characters that trigger auto-activation of content
     *            proposal. If specified, these characters will trigger
     *            auto-activation of the proposal popup, regardless of whether
     *            an explicit invocation keyStroke was specified. If this
     *            parameter is <code>null</code>, then only a specified
     *            keyStroke will invoke content proposal. If this parameter is
     *            <code>null</code> and the keyStroke value is
     *            <code>null</code>, then all alphanumeric characters will
     *            auto-activate content proposal.
     *
     */
    public void setAutoActivationCharacters(char[] autoActivationCharacters) {
        if (autoActivationCharacters.length is 0) {
            this.autoActivateString = null;
        } else {
            this.autoActivateString = autoActivationCharacters;
        }
    }

    /**
     * Set the delay, in milliseconds, used before any autoactivation is
     * triggered.
     *
     * @return the time in milliseconds that will pass before a popup is
     *         automatically opened
     */
    public int getAutoActivationDelay() {
        return autoActivationDelay;

    }

    /**
     * Set the delay, in milliseconds, used before autoactivation is triggered.
     *
     * @param delay
     *            the time in milliseconds that will pass before a popup is
     *            automatically opened
     */
    public void setAutoActivationDelay(int delay) {
        autoActivationDelay = delay;

    }

    /**
     * Get the integer style that indicates how an accepted proposal affects the
     * control's content.
     *
     * @return a constant indicating how an accepted proposal should affect the
     *         control's content. Should be one of <code>PROPOSAL_INSERT</code>,
     *         <code>PROPOSAL_REPLACE</code>, or <code>PROPOSAL_IGNORE</code>.
     *         (Default is <code>PROPOSAL_INSERT</code>).
     */
    public int getProposalAcceptanceStyle() {
        return proposalAcceptanceStyle;
    }

    /**
     * Set the integer style that indicates how an accepted proposal affects the
     * control's content.
     *
     * @param acceptance
     *            a constant indicating how an accepted proposal should affect
     *            the control's content. Should be one of
     *            <code>PROPOSAL_INSERT</code>, <code>PROPOSAL_REPLACE</code>,
     *            or <code>PROPOSAL_IGNORE</code>
     */
    public void setProposalAcceptanceStyle(int acceptance) {
        proposalAcceptanceStyle = acceptance;
    }

    /**
     * Return the integer style that indicates how keystrokes affect the content
     * of the proposal popup while it is open.
     *
     * @return a constant indicating how keystrokes in the proposal popup affect
     *         filtering of the proposals shown. <code>FILTER_NONE</code>
     *         specifies that no filtering will occur in the content proposal
     *         list as keys are typed. <code>FILTER_CHARACTER</code> specifies
     *         the content of the popup will be filtered by the most recently
     *         typed character. <code>FILTER_CUMULATIVE</code> is deprecated
     *         and no longer recommended. It specifies that the content of the
     *         popup will be filtered by a string containing all the characters
     *         typed since the popup has been open. The default is
     *         <code>FILTER_NONE</code>.
     */
    public int getFilterStyle() {
        return filterStyle;
    }

    /**
     * Set the integer style that indicates how keystrokes affect the content of
     * the proposal popup while it is open. Popup-based filtering is useful for
     * narrowing and navigating the list of proposals provided once the popup is
     * open. Filtering of the proposals will occur even when the control content
     * is not affected by user typing. Note that automatic filtering is not used
     * to achieve content-sensitive filtering such as auto-completion. Filtering
     * that is sensitive to changes in the control content should be performed
     * by the supplied {@link IContentProposalProvider}.
     *
     * @param filterStyle
     *            a constant indicating how keystrokes received in the proposal
     *            popup affect filtering of the proposals shown.
     *            <code>FILTER_NONE</code> specifies that no automatic
     *            filtering of the content proposal list will occur as keys are
     *            typed in the popup. <code>FILTER_CHARACTER</code> specifies
     *            that the content of the popup will be filtered by the most
     *            recently typed character. <code>FILTER_CUMULATIVE</code> is
     *            deprecated and no longer recommended. It specifies that the
     *            content of the popup will be filtered by a string containing
     *            all the characters typed since the popup has been open.
     */
    public void setFilterStyle(int filterStyle) {
        this.filterStyle = filterStyle;
    }

    /**
     * Return the size, in pixels, of the content proposal popup.
     *
     * @return a Point specifying the last width and height, in pixels, of the
     *         content proposal popup.
     */
    public Point getPopupSize() {
        return popupSize;
    }

    /**
     * Set the size, in pixels, of the content proposal popup. This size will be
     * used the next time the content proposal popup is opened.
     *
     * @param size
     *            a Point specifying the desired width and height, in pixels, of
     *            the content proposal popup.
     */
    public void setPopupSize(Point size) {
        popupSize = size;
    }

    /**
     * Get the bool that indicates whether key events (including
     * auto-activation characters) received by the content proposal popup should
     * also be propagated to the adapted control when the proposal popup is
     * open.
     *
     * @return a bool that indicates whether key events (including
     *         auto-activation characters) should be propagated to the adapted
     *         control when the proposal popup is open. Default value is
     *         <code>true</code>.
     */
    public bool getPropagateKeys() {
        return propagateKeys;
    }

    /**
     * Set the bool that indicates whether key events (including
     * auto-activation characters) received by the content proposal popup should
     * also be propagated to the adapted control when the proposal popup is
     * open.
     *
     * @param propagateKeys
     *            a bool that indicates whether key events (including
     *            auto-activation characters) should be propagated to the
     *            adapted control when the proposal popup is open.
     */
    public void setPropagateKeys(bool propagateKeys) {
        this.propagateKeys = propagateKeys;
    }

    /**
     * Return the content adapter that can get or retrieve the text contents
     * from the adapter's control. This method is used when a client, such as a
     * content proposal listener, needs to update the control's contents
     * manually.
     *
     * @return the {@link IControlContentAdapter} which can update the control
     *         text.
     */
    public IControlContentAdapter getControlContentAdapter() {
        return controlContentAdapter;
    }

    /**
     * Set the bool flag that determines whether the adapter is enabled.
     *
     * @param enabled
     *            <code>true</code> if the adapter is enabled and responding
     *            to user input, <code>false</code> if it is ignoring user
     *            input.
     *
     */
    public void setEnabled(bool enabled) {
        // If we are disabling it while it's proposing content, close the
        // content proposal popup.
        if (isEnabled_ && !enabled) {
            if (popup !is null) {
                popup.close();
            }
        }
        isEnabled_ = enabled;
    }

    /**
     * Add the specified listener to the list of content proposal listeners that
     * are notified when content proposals are chosen.
     * </p>
     *
     * @param listener
     *            the IContentProposalListener to be added as a listener. Must
     *            not be <code>null</code>. If an attempt is made to register
     *            an instance which is already registered with this instance,
     *            this method has no effect.
     *
     * @see dwtx.jface.fieldassist.IContentProposalListener
     */
    public void addContentProposalListener(IContentProposalListener listener) {
        proposalListeners.add(cast(Object)listener);
    }

    /**
     * Removes the specified listener from the list of content proposal
     * listeners that are notified when content proposals are chosen.
     * </p>
     *
     * @param listener
     *            the IContentProposalListener to be removed as a listener. Must
     *            not be <code>null</code>. If the listener has not already
     *            been registered, this method has no effect.
     *
     * @since 3.3
     * @see dwtx.jface.fieldassist.IContentProposalListener
     */
    public void removeContentProposalListener(IContentProposalListener listener) {
        proposalListeners.remove(cast(Object)listener);
    }

    /**
     * Add the specified listener to the list of content proposal listeners that
     * are notified when a content proposal popup is opened or closed.
     * </p>
     *
     * @param listener
     *            the IContentProposalListener2 to be added as a listener. Must
     *            not be <code>null</code>. If an attempt is made to register
     *            an instance which is already registered with this instance,
     *            this method has no effect.
     *
     * @since 3.3
     * @see dwtx.jface.fieldassist.IContentProposalListener2
     */
    public void addContentProposalListener(IContentProposalListener2 listener) {
        proposalListeners2.add(cast(Object)listener);
    }

    /**
     * Remove the specified listener from the list of content proposal listeners
     * that are notified when a content proposal popup is opened or closed.
     * </p>
     *
     * @param listener
     *            the IContentProposalListener2 to be removed as a listener.
     *            Must not be <code>null</code>. If the listener has not
     *            already been registered, this method has no effect.
     *
     * @since 3.3
     * @see dwtx.jface.fieldassist.IContentProposalListener2
     */
    public void removeContentProposalListener(IContentProposalListener2 listener) {
        proposalListeners2.remove(cast(Object)listener);
    }

    /*
     * Add our listener to the control. Debug information to be left in until
     * this support is stable on all platforms.
     */
    private void addControlListener(Control control) {
        if (DEBUG) {
            Stdout.formatln("ContentProposalListener#installControlListener()"); //$NON-NLS-1$
        }

        if (controlListener !is null) {
            return;
        }
        controlListener = new class Listener {
            public void handleEvent(Event e) {
                if (!isEnabled_) {
                    return;
                }

                switch (e.type) {
                case DWT.Traverse:
                case DWT.KeyDown:
                    if (DEBUG) {
                        StringBuffer sb;
                        if (e.type is DWT.Traverse) {
                            sb = new StringBuffer("Traverse"); //$NON-NLS-1$
                        } else {
                            sb = new StringBuffer("KeyDown"); //$NON-NLS-1$
                        }
                        sb.append(" received by adapter"); //$NON-NLS-1$
                        dump(sb.toString(), e);
                    }
                    // If the popup is open, it gets first shot at the
                    // keystroke and should set the doit flags appropriately.
                    if (popup !is null) {
                        popup.getTargetControlListener().handleEvent(e);
                        if (DEBUG) {
                            StringBuffer sb;
                            if (e.type is DWT.Traverse) {
                                sb = new StringBuffer("Traverse"); //$NON-NLS-1$
                            } else {
                                sb = new StringBuffer("KeyDown"); //$NON-NLS-1$
                            }
                            sb.append(" after being handled by popup"); //$NON-NLS-1$
                            dump(sb.toString(), e);
                        }

                        return;
                    }

                    // We were only listening to traverse events for the popup
                    if (e.type is DWT.Traverse) {
                        return;
                    }

                    // The popup is not open. We are looking at keydown events
                    // for a trigger to open the popup.
                    if (triggerKeyStroke !is null) {
                        // Either there are no modifiers for the trigger and we
                        // check the character field...
                        if ((triggerKeyStroke.getModifierKeys() is KeyStroke.NO_KEY && triggerKeyStroke
                                .getNaturalKey() is e.character)
                                ||
                                // ...or there are modifiers, in which case the
                                // keycode and state must match
                                (triggerKeyStroke.getNaturalKey() is e.keyCode && ((triggerKeyStroke
                                        .getModifierKeys() & e.stateMask) is triggerKeyStroke
                                        .getModifierKeys()))) {
                            // We never propagate the keystroke for an explicit
                            // keystroke invocation of the popup
                            e.doit = false;
                            openProposalPopup(false);
                            return;
                        }
                    }
                    /*
                     * The triggering keystroke was not invoked. If a character
                     * was typed, compare it to the autoactivation characters.
                     */
                    if (e.character !is 0) {
                        if (autoActivateString !is null) {
                            if (autoActivateString.indexOf(e.character) >= 0) {
                                autoActivate();
                            } else {
                                // No autoactivation occurred, so record the key
                                // down as a means to interrupt any
                                // autoactivation
                                // that is pending due to autoactivation delay.
                                receivedKeyDown = true;
                            }
                        } else {
                            // The autoactivate string is null. If the trigger
                            // is also null, we want to act on any modification
                            // to the content.  Set a flag so we'll catch this
                            // in the modify event.
                            if (triggerKeyStroke is null) {
                                watchModify = true;
                            }
                        }
                    }
                    break;

                // See https://bugs.eclipse.org/bugs/show_bug.cgi?id=147377
                // Given that we will close the popup when there are no valid
                // proposals, we must reopen it when there are. This means
                // we should check modifications in those cases.
                // See also https://bugs.eclipse.org/bugs/show_bug.cgi?id=183650
                // The watchModify flag ensures that we don't autoactivate if
                // the content change was caused by something other than typing.
                case DWT.Modify:
                    if (triggerKeyStroke is null && autoActivateString is null
                            && watchModify) {
                        if (DEBUG) {
                            dump("Modify event triggers autoactivation", e); //$NON-NLS-1$
                        }
                        watchModify = false;
                        // We don't autoactivate if the net change is no
                        // content.  In other words, backspacing to empty
                        // should never cause a popup to open.
                        if (!isControlContentEmpty()) {
                            autoActivate();
                        }
                    }
                    break;
                default:
                    break;
                }
            }

            /**
             * Dump the given events to "standard" output.
             *
             * @param who
             *            who is dumping the event
             * @param e
             *            the event
             */
            private void dump(String who, Event e) {
                StringBuffer sb = new StringBuffer(
                        "--- [ContentProposalAdapter]\n"); //$NON-NLS-1$
                sb.append(who);
                sb.append(Format(" - e: keyCode={}{}", e.keyCode, hex(e.keyCode))); //$NON-NLS-1$
                sb.append(Format("; character={}{}", e.character, hex(e.character))); //$NON-NLS-1$
                sb.append(Format("; stateMask={}{}", e.stateMask, hex(e.stateMask))); //$NON-NLS-1$
                sb.append(Format("; doit={}", e.doit)); //$NON-NLS-1$
                sb.append(Format("; detail={}", e.detail, hex(e.detail))); //$NON-NLS-1$
                sb.append(Format("; widget={}", e.widget)); //$NON-NLS-1$
                Stdout.formatln("{}",sb.toString);
            }

            private String hex(int i) {
                return Format("[0x{:X}]", i); //$NON-NLS-1$
            }
        };
        control.addListener(DWT.KeyDown, controlListener);
        control.addListener(DWT.Traverse, controlListener);
        control.addListener(DWT.Modify, controlListener);

        if (DEBUG) {
            Stdout.formatln("ContentProposalAdapter#installControlListener() - installed"); //$NON-NLS-1$
        }
    }

    /**
     * Open the proposal popup and display the proposals provided by the
     * proposal provider. If there are no proposals to be shown, do not show the
     * popup. This method returns immediately. That is, it does not wait for the
     * popup to open or a proposal to be selected.
     *
     * @param autoActivated
     *            a bool indicating whether the popup was autoactivated. If
     *            false, a beep will sound when no proposals can be shown.
     */
    private void openProposalPopup(bool autoActivated) {
        if (isValid()) {
            if (popup is null) {
                // Check whether there are any proposals to be shown.
                recordCursorPosition(); // must be done before getting proposals
                IContentProposal[] proposals = getProposals();
                if (proposals.length > 0) {
                    if (DEBUG) {
                        Stdout.formatln("POPUP OPENED BY PRECEDING EVENT"); //$NON-NLS-1$
                    }
                    recordCursorPosition();
                    popup = new ContentProposalPopup(null, proposals);
                    popup.open();
                    popup.getShell().addDisposeListener(new class DisposeListener {
                        public void widgetDisposed(DisposeEvent event) {
                            popup = null;
                        }
                    });
                    notifyPopupOpened();
                } else if (!autoActivated) {
                    getControl().getDisplay().beep();
                }
            }
        }
    }

    /**
     * Open the proposal popup and display the proposals provided by the
     * proposal provider. This method returns immediately. That is, it does not
     * wait for a proposal to be selected. This method is used by subclasses to
     * explicitly invoke the opening of the popup. If there are no proposals to
     * show, the popup will not open and a beep will be sounded.
     */
    protected void openProposalPopup() {
        openProposalPopup(false);
    }

    /**
     * Close the proposal popup without accepting a proposal. This method
     * returns immediately, and has no effect if the proposal popup was not
     * open. This method is used by subclasses to explicitly close the popup
     * based on additional logic.
     *
     * @since 3.3
     */
    protected void closeProposalPopup() {
        if (popup !is null) {
            popup.close();
        }
    }

    /*
     * A content proposal has been accepted. Update the control contents
     * accordingly and notify any listeners.
     *
     * @param proposal the accepted proposal
     */
    private void proposalAccepted(IContentProposal proposal) {
        switch (proposalAcceptanceStyle) {
        case (PROPOSAL_REPLACE):
            setControlContent(proposal.getContent(), proposal
                    .getCursorPosition());
            break;
        case (PROPOSAL_INSERT):
            insertControlContent(proposal.getContent(), proposal
                    .getCursorPosition());
            break;
        default:
            // do nothing. Typically a listener is installed to handle this in
            // a custom way.
            break;
        }

        // In all cases, notify listeners of an accepted proposal.
        notifyProposalAccepted(proposal);
    }

    /*
     * Set the text content of the control to the specified text, setting the
     * cursorPosition at the desired location within the new contents.
     */
    private void setControlContent(String text, int cursorPosition) {
        if (isValid()) {
            // should already be false, but just in case.
            watchModify = false;
            controlContentAdapter.setControlContents(control, text,
                    cursorPosition);
        }
    }

    /*
     * Insert the specified text into the control content, setting the
     * cursorPosition at the desired location within the new contents.
     */
    private void insertControlContent(String text, int cursorPosition) {
        if (isValid()) {
            // should already be false, but just in case.
            watchModify = false;
            // Not all controls preserve their selection index when they lose
            // focus, so we must set it explicitly here to what it was before
            // the popup opened.
            // See https://bugs.eclipse.org/bugs/show_bug.cgi?id=127108
            // See https://bugs.eclipse.org/bugs/show_bug.cgi?id=139063
            if ((null !is cast(IControlContentAdapter2)controlContentAdapter)
                    && selectionRange.x !is -1) {
                (cast(IControlContentAdapter2) controlContentAdapter).setSelection(
                        control, selectionRange);
            } else if (insertionPos !is -1) {
                controlContentAdapter.setCursorPosition(control, insertionPos);
            }
            controlContentAdapter.insertControlContents(control, text,
                    cursorPosition);
        }
    }

    /*
     * Check that the control and content adapter are valid.
     */
    private bool isValid() {
        return control !is null && !control.isDisposed()
                && controlContentAdapter !is null;
    }

    /*
     * Record the control's cursor position.
     */
    private void recordCursorPosition() {
        if (isValid()) {
            IControlContentAdapter adapter = getControlContentAdapter();
            insertionPos = adapter.getCursorPosition(control);
            // see https://bugs.eclipse.org/bugs/show_bug.cgi?id=139063
            if (null !is cast(IControlContentAdapter2)adapter ) {
                selectionRange = (cast(IControlContentAdapter2) adapter)
                        .getSelection(control);
            }

        }
    }

    /*
     * Get the proposals from the proposal provider. Gets all of the proposals
     * without doing any filtering.
     */
    private IContentProposal[] getProposals() {
        if (proposalProvider is null || !isValid()) {
            return null;
        }
        if (DEBUG) {
            Stdout.formatln(">>> obtaining proposals from provider"); //$NON-NLS-1$
        }
        int position = insertionPos;
        if (position is -1) {
            position = getControlContentAdapter().getCursorPosition(
                    getControl());
        }
        String contents = getControlContentAdapter().getControlContents(
                getControl());
        IContentProposal[] proposals = proposalProvider.getProposals(contents,
                position);
        return proposals;
    }

    /**
     * Autoactivation has been triggered. Open the popup using any specified
     * delay.
     */
    private void autoActivate() {
        if (autoActivationDelay > 0) {
            auto r = new class Runnable{
                public void run(){
                    receivedKeyDown = false;
                    try {
                        JThread.sleep(autoActivationDelay);
                    } catch (InterruptedException e) {
                    }
                    if (!isValid() || receivedKeyDown) {
                        return;
                    }
                    getControl().getDisplay().syncExec(new class Runnable {
                        public void run() {
                            openProposalPopup(true);
                        }
                    });
                }
            };
            JThread t = new JThread(r);
            t.start();
        } else {
            // Since we do not sleep, we must open the popup
            // in an async exec. This is necessary because
            // this method may be called in the middle of handling
            // some event that will cause the cursor position or
            // other important info to change as a result of this
            // event occurring.
            getControl().getDisplay().asyncExec(new class Runnable {
                public void run() {
                    if (isValid()) {
                        openProposalPopup(true);
                    }
                }
            });
        }
    }

    /*
     * A proposal has been accepted. Notify interested listeners.
     */
    private void notifyProposalAccepted(IContentProposal proposal) {
        if (DEBUG) {
            Stdout.formatln("Notify listeners - proposal accepted."); //$NON-NLS-1$
        }
        Object[] listenerArray = proposalListeners.getListeners();
        for (int i = 0; i < listenerArray.length; i++) {
            (cast(IContentProposalListener) listenerArray[i])
                    .proposalAccepted(proposal);
        }
    }

    /*
     * The proposal popup has opened. Notify interested listeners.
     */
    private void notifyPopupOpened() {
        if (DEBUG) {
            Stdout.formatln("Notify listeners - popup opened."); //$NON-NLS-1$
        }
        Object[] listenerArray = proposalListeners2.getListeners();
        for (int i = 0; i < listenerArray.length; i++) {
            (cast(IContentProposalListener2) listenerArray[i])
                    .proposalPopupOpened(this);
        }
    }

    /*
     * The proposal popup has closed. Notify interested listeners.
     */
    private void notifyPopupClosed() {
        if (DEBUG) {
            Stdout.formatln("Notify listeners - popup closed."); //$NON-NLS-1$
        }
        Object[] listenerArray = proposalListeners2.getListeners();
        for (int i = 0; i < listenerArray.length; i++) {
            (cast(IContentProposalListener2) listenerArray[i])
                    .proposalPopupClosed(this);
        }
    }

    /**
     * Returns whether the content proposal popup has the focus. This includes
     * both the primary popup and any secondary info popup that may have focus.
     *
     * @return <code>true</code> if the proposal popup or its secondary info
     *         popup has the focus
     * @since 3.4
     */
    public bool hasProposalPopupFocus() {
        return popup !is null && popup.hasFocus();
    }

    /*
     * Return whether the control content is empty
     */
    private bool isControlContentEmpty() {
        return getControlContentAdapter().getControlContents(getControl())
                .length is 0;
    }
}
