/*******************************************************************************
 * Copyright (c) 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Cagatay Calli <ccalli@gmail.com> - [find/replace] retain caps when replacing - https://bugs.eclipse.org/bugs/show_bug.cgi?id=28949
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.text.FindReplaceDocumentAdapterContentProposalProvider;

import dwtx.jface.text.IDocumentPartitioningListener; // packageimport
import dwtx.jface.text.DefaultTextHover; // packageimport
import dwtx.jface.text.AbstractInformationControl; // packageimport
import dwtx.jface.text.TextUtilities; // packageimport
import dwtx.jface.text.IInformationControlCreatorExtension; // packageimport
import dwtx.jface.text.AbstractInformationControlManager; // packageimport
import dwtx.jface.text.ITextViewerExtension2; // packageimport
import dwtx.jface.text.IDocumentPartitioner; // packageimport
import dwtx.jface.text.DefaultIndentLineAutoEditStrategy; // packageimport
import dwtx.jface.text.ITextSelection; // packageimport
import dwtx.jface.text.Document; // packageimport
import dwtx.jface.text.ITextListener; // packageimport
import dwtx.jface.text.BadPartitioningException; // packageimport
import dwtx.jface.text.ITextViewerExtension5; // packageimport
import dwtx.jface.text.IDocumentPartitionerExtension3; // packageimport
import dwtx.jface.text.IUndoManager; // packageimport
import dwtx.jface.text.ITextHoverExtension2; // packageimport
import dwtx.jface.text.IRepairableDocument; // packageimport
import dwtx.jface.text.IRewriteTarget; // packageimport
import dwtx.jface.text.DefaultPositionUpdater; // packageimport
import dwtx.jface.text.RewriteSessionEditProcessor; // packageimport
import dwtx.jface.text.TextViewerHoverManager; // packageimport
import dwtx.jface.text.DocumentRewriteSession; // packageimport
import dwtx.jface.text.TextViewer; // packageimport
import dwtx.jface.text.ITextViewerExtension8; // packageimport
import dwtx.jface.text.RegExMessages; // packageimport
import dwtx.jface.text.IDelayedInputChangeProvider; // packageimport
import dwtx.jface.text.ITextOperationTargetExtension; // packageimport
import dwtx.jface.text.IWidgetTokenOwner; // packageimport
import dwtx.jface.text.IViewportListener; // packageimport
import dwtx.jface.text.GapTextStore; // packageimport
import dwtx.jface.text.MarkSelection; // packageimport
import dwtx.jface.text.IDocumentPartitioningListenerExtension; // packageimport
import dwtx.jface.text.IDocumentAdapterExtension; // packageimport
import dwtx.jface.text.IInformationControlExtension; // packageimport
import dwtx.jface.text.IDocumentPartitioningListenerExtension2; // packageimport
import dwtx.jface.text.DefaultDocumentAdapter; // packageimport
import dwtx.jface.text.ITextViewerExtension3; // packageimport
import dwtx.jface.text.IInformationControlCreator; // packageimport
import dwtx.jface.text.TypedRegion; // packageimport
import dwtx.jface.text.ISynchronizable; // packageimport
import dwtx.jface.text.IMarkRegionTarget; // packageimport
import dwtx.jface.text.TextViewerUndoManager; // packageimport
import dwtx.jface.text.IRegion; // packageimport
import dwtx.jface.text.IInformationControlExtension2; // packageimport
import dwtx.jface.text.IDocumentExtension4; // packageimport
import dwtx.jface.text.IDocumentExtension2; // packageimport
import dwtx.jface.text.IDocumentPartitionerExtension2; // packageimport
import dwtx.jface.text.Assert; // packageimport
import dwtx.jface.text.DefaultInformationControl; // packageimport
import dwtx.jface.text.IWidgetTokenOwnerExtension; // packageimport
import dwtx.jface.text.DocumentClone; // packageimport
import dwtx.jface.text.DefaultUndoManager; // packageimport
import dwtx.jface.text.IFindReplaceTarget; // packageimport
import dwtx.jface.text.IAutoEditStrategy; // packageimport
import dwtx.jface.text.ILineTrackerExtension; // packageimport
import dwtx.jface.text.IUndoManagerExtension; // packageimport
import dwtx.jface.text.TextSelection; // packageimport
import dwtx.jface.text.DefaultAutoIndentStrategy; // packageimport
import dwtx.jface.text.IAutoIndentStrategy; // packageimport
import dwtx.jface.text.IPainter; // packageimport
import dwtx.jface.text.IInformationControl; // packageimport
import dwtx.jface.text.IInformationControlExtension3; // packageimport
import dwtx.jface.text.ITextViewerExtension6; // packageimport
import dwtx.jface.text.IInformationControlExtension4; // packageimport
import dwtx.jface.text.DefaultLineTracker; // packageimport
import dwtx.jface.text.IDocumentInformationMappingExtension; // packageimport
import dwtx.jface.text.IRepairableDocumentExtension; // packageimport
import dwtx.jface.text.ITextHover; // packageimport
import dwtx.jface.text.FindReplaceDocumentAdapter; // packageimport
import dwtx.jface.text.ILineTracker; // packageimport
import dwtx.jface.text.Line; // packageimport
import dwtx.jface.text.ITextViewerExtension; // packageimport
import dwtx.jface.text.IDocumentAdapter; // packageimport
import dwtx.jface.text.TextEvent; // packageimport
import dwtx.jface.text.BadLocationException; // packageimport
import dwtx.jface.text.AbstractDocument; // packageimport
import dwtx.jface.text.AbstractLineTracker; // packageimport
import dwtx.jface.text.TreeLineTracker; // packageimport
import dwtx.jface.text.ITextPresentationListener; // packageimport
import dwtx.jface.text.Region; // packageimport
import dwtx.jface.text.ITextViewer; // packageimport
import dwtx.jface.text.IDocumentInformationMapping; // packageimport
import dwtx.jface.text.MarginPainter; // packageimport
import dwtx.jface.text.IPaintPositionManager; // packageimport
import dwtx.jface.text.TextPresentation; // packageimport
import dwtx.jface.text.IFindReplaceTargetExtension; // packageimport
import dwtx.jface.text.ISlaveDocumentManagerExtension; // packageimport
import dwtx.jface.text.ISelectionValidator; // packageimport
import dwtx.jface.text.IDocumentExtension; // packageimport
import dwtx.jface.text.PropagatingFontFieldEditor; // packageimport
import dwtx.jface.text.ConfigurableLineTracker; // packageimport
import dwtx.jface.text.SlaveDocumentEvent; // packageimport
import dwtx.jface.text.IDocumentListener; // packageimport
import dwtx.jface.text.PaintManager; // packageimport
import dwtx.jface.text.IFindReplaceTargetExtension3; // packageimport
import dwtx.jface.text.ITextDoubleClickStrategy; // packageimport
import dwtx.jface.text.IDocumentExtension3; // packageimport
import dwtx.jface.text.Position; // packageimport
import dwtx.jface.text.TextMessages; // packageimport
import dwtx.jface.text.CopyOnWriteTextStore; // packageimport
import dwtx.jface.text.WhitespaceCharacterPainter; // packageimport
import dwtx.jface.text.IPositionUpdater; // packageimport
import dwtx.jface.text.DefaultTextDoubleClickStrategy; // packageimport
import dwtx.jface.text.ListLineTracker; // packageimport
import dwtx.jface.text.ITextInputListener; // packageimport
import dwtx.jface.text.BadPositionCategoryException; // packageimport
import dwtx.jface.text.IWidgetTokenKeeperExtension; // packageimport
import dwtx.jface.text.IInputChangedListener; // packageimport
import dwtx.jface.text.ITextOperationTarget; // packageimport
import dwtx.jface.text.IDocumentInformationMappingExtension2; // packageimport
import dwtx.jface.text.ITextViewerExtension7; // packageimport
import dwtx.jface.text.IInformationControlExtension5; // packageimport
import dwtx.jface.text.IDocumentRewriteSessionListener; // packageimport
import dwtx.jface.text.JFaceTextUtil; // packageimport
import dwtx.jface.text.AbstractReusableInformationControlCreator; // packageimport
import dwtx.jface.text.TabsToSpacesConverter; // packageimport
import dwtx.jface.text.CursorLinePainter; // packageimport
import dwtx.jface.text.ITextHoverExtension; // packageimport
import dwtx.jface.text.IEventConsumer; // packageimport
import dwtx.jface.text.IDocument; // packageimport
import dwtx.jface.text.IWidgetTokenKeeper; // packageimport
import dwtx.jface.text.DocumentCommand; // packageimport
import dwtx.jface.text.TypedPosition; // packageimport
import dwtx.jface.text.IEditingSupportRegistry; // packageimport
import dwtx.jface.text.IDocumentPartitionerExtension; // packageimport
import dwtx.jface.text.AbstractHoverInformationControlManager; // packageimport
import dwtx.jface.text.IEditingSupport; // packageimport
import dwtx.jface.text.IMarkSelection; // packageimport
import dwtx.jface.text.ISlaveDocumentManager; // packageimport
import dwtx.jface.text.DocumentEvent; // packageimport
import dwtx.jface.text.DocumentPartitioningChangedEvent; // packageimport
import dwtx.jface.text.ITextStore; // packageimport
import dwtx.jface.text.JFaceTextMessages; // packageimport
import dwtx.jface.text.DocumentRewriteSessionEvent; // packageimport
import dwtx.jface.text.SequentialRewriteTextStore; // packageimport
import dwtx.jface.text.DocumentRewriteSessionType; // packageimport
import dwtx.jface.text.TextAttribute; // packageimport
import dwtx.jface.text.ITextViewerExtension4; // packageimport
import dwtx.jface.text.ITypedRegion; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;

import dwtx.jface.fieldassist.IContentProposal;
import dwtx.jface.fieldassist.IContentProposalProvider;


/**
 * Content assist proposal provider for the {@link FindReplaceDocumentAdapter}.
 * <p>
 * Clients can subclass to provide additional proposals in case they are supported
 * by their own find/replace mechanism.
 * </p>
 * <p>
 * <strong>Note:</strong> Clients must not make any assumptions about the returned
 * proposals. This can change from release to release to adapt to
 * changes made in {@link FindReplaceDocumentAdapter}.
 * </p>
 *
 * @since 3.4
 */
public class FindReplaceDocumentAdapterContentProposalProvider : IContentProposalProvider {


    /**
     * Proposal computer.
     */
    private static class ProposalComputer {

        private static class Proposal : IContentProposal {

            private String fContent;
            private String fLabel;
            private String fDescription;
            private int fCursorPosition;

            this(String content, String label, String description, int cursorPosition) {
                fContent= content;
                fLabel= label;
                fDescription= description;
                fCursorPosition= cursorPosition;
            }

            public String getContent() {
                return fContent;
            }

            public String getLabel() {
                return fLabel;
            }

            public String getDescription() {
                return fDescription;
            }

            public int getCursorPosition() {
                return fCursorPosition;
            }
        }


        /**
         * The whole regular expression.
         */
        private const String fExpression;
        /**
         * The document offset.
         */
        private const int fDocumentOffset;
        /**
         * The high-priority proposals.
         */
        private const ArrayList fPriorityProposals;
        /**
         * The low-priority proposals.
         */
        private const ArrayList fProposals;
        /**
         * <code>true</code> iff <code>fExpression</code> ends with an open escape.
         */
        private const bool fIsEscape;

        /**
         * Creates a new Proposal Computer.
         * @param contents the contents of the subject control
         * @param position the cursor position
         */
        public this(String contents, int position) {
            fExpression= contents;
            fDocumentOffset= position;
            fPriorityProposals= new ArrayList();
            fProposals= new ArrayList();

            bool isEscape= false;
            esc: for (int i= position - 1; i >= 0; i--) {
                if (fExpression.charAt(i) is '\\')
                    isEscape= !isEscape;
                else
                    break esc;
            }
            fIsEscape= isEscape;
        }

        /**
         * Computes applicable proposals for the find field.
         * @return the proposals
         */
        public IContentProposal[] computeFindProposals() {
            //characters
            addBsProposal("\\\\", RegExMessages.getString("displayString_bs_bs"), RegExMessages.getString("additionalInfo_bs_bs")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBracketProposal("\\0", 2, RegExMessages.getString("displayString_bs_0"), RegExMessages.getString("additionalInfo_bs_0")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBracketProposal("\\x", 2, RegExMessages.getString("displayString_bs_x"), RegExMessages.getString("additionalInfo_bs_x")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBracketProposal("\\u", 2, RegExMessages.getString("displayString_bs_u"), RegExMessages.getString("additionalInfo_bs_u")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\t", RegExMessages.getString("displayString_bs_t"), RegExMessages.getString("additionalInfo_bs_t")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\R", RegExMessages.getString("displayString_bs_R"), RegExMessages.getString("additionalInfo_bs_R")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\n", RegExMessages.getString("displayString_bs_n"), RegExMessages.getString("additionalInfo_bs_n")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\r", RegExMessages.getString("displayString_bs_r"), RegExMessages.getString("additionalInfo_bs_r")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\f", RegExMessages.getString("displayString_bs_f"), RegExMessages.getString("additionalInfo_bs_f")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\a", RegExMessages.getString("displayString_bs_a"), RegExMessages.getString("additionalInfo_bs_a")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\e", RegExMessages.getString("displayString_bs_e"), RegExMessages.getString("additionalInfo_bs_e")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBracketProposal("\\c", 2, RegExMessages.getString("displayString_bs_c"), RegExMessages.getString("additionalInfo_bs_c")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$

            if (! fIsEscape)
                addBracketProposal(".", 1, RegExMessages.getString("displayString_dot"), RegExMessages.getString("additionalInfo_dot")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\d", RegExMessages.getString("displayString_bs_d"), RegExMessages.getString("additionalInfo_bs_d")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\D", RegExMessages.getString("displayString_bs_D"), RegExMessages.getString("additionalInfo_bs_D")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\s", RegExMessages.getString("displayString_bs_s"), RegExMessages.getString("additionalInfo_bs_s")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\S", RegExMessages.getString("displayString_bs_S"), RegExMessages.getString("additionalInfo_bs_S")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\w", RegExMessages.getString("displayString_bs_w"), RegExMessages.getString("additionalInfo_bs_w")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\W", RegExMessages.getString("displayString_bs_W"), RegExMessages.getString("additionalInfo_bs_W")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$

            // back reference
            addBsProposal("\\", RegExMessages.getString("displayString_bs_i"), RegExMessages.getString("additionalInfo_bs_i")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$

            //quoting
            addBsProposal("\\", RegExMessages.getString("displayString_bs"), RegExMessages.getString("additionalInfo_bs")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\Q", RegExMessages.getString("displayString_bs_Q"), RegExMessages.getString("additionalInfo_bs_Q")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\E", RegExMessages.getString("displayString_bs_E"), RegExMessages.getString("additionalInfo_bs_E")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$

            //character sets
            if (! fIsEscape) {
                addBracketProposal("[]", 1, RegExMessages.getString("displayString_set"), RegExMessages.getString("additionalInfo_set")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("[^]", 2, RegExMessages.getString("displayString_setExcl"), RegExMessages.getString("additionalInfo_setExcl")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("[-]", 1, RegExMessages.getString("displayString_setRange"), RegExMessages.getString("additionalInfo_setRange")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addProposal("&&", RegExMessages.getString("displayString_setInter"), RegExMessages.getString("additionalInfo_setInter")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            }
            if (! fIsEscape && fDocumentOffset > 0 && fExpression.charAt(fDocumentOffset - 1) is '\\') {
                addProposal("\\p{}", 3, RegExMessages.getString("displayString_posix"), RegExMessages.getString("additionalInfo_posix")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addProposal("\\P{}", 3, RegExMessages.getString("displayString_posixNot"), RegExMessages.getString("additionalInfo_posixNot")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            } else {
                addBracketProposal("\\p{}", 3, RegExMessages.getString("displayString_posix"), RegExMessages.getString("additionalInfo_posix")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("\\P{}", 3, RegExMessages.getString("displayString_posixNot"), RegExMessages.getString("additionalInfo_posixNot")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            }

            //boundary matchers
            if (fDocumentOffset is 0) {
                addPriorityProposal("^", RegExMessages.getString("displayString_start"), RegExMessages.getString("additionalInfo_start")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            } else if (fDocumentOffset is 1 && fExpression.charAt(0) is '^') {
                addBracketProposal("^", 1, RegExMessages.getString("displayString_start"), RegExMessages.getString("additionalInfo_start")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            }
            if (fDocumentOffset is fExpression.length()) {
                addProposal("$", RegExMessages.getString("displayString_end"), RegExMessages.getString("additionalInfo_end")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            }
            addBsProposal("\\b", RegExMessages.getString("displayString_bs_b"), RegExMessages.getString("additionalInfo_bs_b")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\B", RegExMessages.getString("displayString_bs_B"), RegExMessages.getString("additionalInfo_bs_B")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\A", RegExMessages.getString("displayString_bs_A"), RegExMessages.getString("additionalInfo_bs_A")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\G", RegExMessages.getString("displayString_bs_G"), RegExMessages.getString("additionalInfo_bs_G")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\Z", RegExMessages.getString("displayString_bs_Z"), RegExMessages.getString("additionalInfo_bs_Z")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            addBsProposal("\\z", RegExMessages.getString("displayString_bs_z"), RegExMessages.getString("additionalInfo_bs_z")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$

            if (! fIsEscape) {
                //capturing groups
                addBracketProposal("()", 1, RegExMessages.getString("displayString_group"), RegExMessages.getString("additionalInfo_group")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$

                //flags
                addBracketProposal("(?)", 2, RegExMessages.getString("displayString_flag"), RegExMessages.getString("additionalInfo_flag")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("(?:)", 3, RegExMessages.getString("displayString_flagExpr"), RegExMessages.getString("additionalInfo_flagExpr")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$

                //non-capturing group
                addBracketProposal("(?:)", 3, RegExMessages.getString("displayString_nonCap"), RegExMessages.getString("additionalInfo_nonCap")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("(?>)", 3, RegExMessages.getString("displayString_atomicCap"), RegExMessages.getString("additionalInfo_atomicCap")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$

                //look around
                addBracketProposal("(?=)", 3, RegExMessages.getString("displayString_posLookahead"), RegExMessages.getString("additionalInfo_posLookahead")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("(?!)", 3, RegExMessages.getString("displayString_negLookahead"), RegExMessages.getString("additionalInfo_negLookahead")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("(?<=)", 4, RegExMessages.getString("displayString_posLookbehind"), RegExMessages.getString("additionalInfo_posLookbehind")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("(?<!)", 4, RegExMessages.getString("displayString_negLookbehind"), RegExMessages.getString("additionalInfo_negLookbehind")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$

                //greedy quantifiers
                addBracketProposal("?", 1, RegExMessages.getString("displayString_quest"), RegExMessages.getString("additionalInfo_quest")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("*", 1, RegExMessages.getString("displayString_star"), RegExMessages.getString("additionalInfo_star")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("+", 1, RegExMessages.getString("displayString_plus"), RegExMessages.getString("additionalInfo_plus")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("{}", 1, RegExMessages.getString("displayString_exact"), RegExMessages.getString("additionalInfo_exact")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("{,}", 1, RegExMessages.getString("displayString_least"), RegExMessages.getString("additionalInfo_least")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("{,}", 1, RegExMessages.getString("displayString_count"), RegExMessages.getString("additionalInfo_count")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$

                //lazy quantifiers
                addBracketProposal("??", 1, RegExMessages.getString("displayString_questLazy"), RegExMessages.getString("additionalInfo_questLazy")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("*?", 1, RegExMessages.getString("displayString_starLazy"), RegExMessages.getString("additionalInfo_starLazy")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("+?", 1, RegExMessages.getString("displayString_plusLazy"), RegExMessages.getString("additionalInfo_plusLazy")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("{}?", 1, RegExMessages.getString("displayString_exactLazy"), RegExMessages.getString("additionalInfo_exactLazy")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("{,}?", 1, RegExMessages.getString("displayString_leastLazy"), RegExMessages.getString("additionalInfo_leastLazy")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("{,}?", 1, RegExMessages.getString("displayString_countLazy"), RegExMessages.getString("additionalInfo_countLazy")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$

                //possessive quantifiers
                addBracketProposal("?+", 1, RegExMessages.getString("displayString_questPoss"), RegExMessages.getString("additionalInfo_questPoss")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("*+", 1, RegExMessages.getString("displayString_starPoss"), RegExMessages.getString("additionalInfo_starPoss")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("++", 1, RegExMessages.getString("displayString_plusPoss"), RegExMessages.getString("additionalInfo_plusPoss")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("{}+", 1, RegExMessages.getString("displayString_exactPoss"), RegExMessages.getString("additionalInfo_exactPoss")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("{,}+", 1, RegExMessages.getString("displayString_leastPoss"), RegExMessages.getString("additionalInfo_leastPoss")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("{,}+", 1, RegExMessages.getString("displayString_countPoss"), RegExMessages.getString("additionalInfo_countPoss")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$

                //alternative
                addBracketProposal("|", 1, RegExMessages.getString("displayString_alt"), RegExMessages.getString("additionalInfo_alt")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            }

            fPriorityProposals.addAll(fProposals);
            return arraycast!(IContentProposal)( fPriorityProposals.toArray());
        }

        /**
         * Computes applicable proposals for the replace field.
         * @return the proposals
         */
        public IContentProposal[] computeReplaceProposals() {
            if (fDocumentOffset > 0 && '$' is fExpression.charAt(fDocumentOffset - 1)) {
                addProposal("", RegExMessages.getString("displayString_dollar"), RegExMessages.getString("additionalInfo_dollar")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            } else {
                if (! fIsEscape)
                    addProposal("$", RegExMessages.getString("displayString_dollar"), RegExMessages.getString("additionalInfo_dollar")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBsProposal("\\", RegExMessages.getString("displayString_replace_cap"), RegExMessages.getString("additionalInfo_replace_cap")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBsProposal("\\", RegExMessages.getString("displayString_replace_bs"), RegExMessages.getString("additionalInfo_replace_bs")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBsProposal("\\R", RegExMessages.getString("displayString_replace_bs_R"), RegExMessages.getString("additionalInfo_replace_bs_R")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("\\x", 2, RegExMessages.getString("displayString_bs_x"), RegExMessages.getString("additionalInfo_bs_x")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("\\u", 2, RegExMessages.getString("displayString_bs_u"), RegExMessages.getString("additionalInfo_bs_u")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBsProposal("\\t", RegExMessages.getString("displayString_bs_t"), RegExMessages.getString("additionalInfo_bs_t")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBsProposal("\\n", RegExMessages.getString("displayString_replace_bs_n"), RegExMessages.getString("additionalInfo_replace_bs_n")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBsProposal("\\r", RegExMessages.getString("displayString_replace_bs_r"), RegExMessages.getString("additionalInfo_replace_bs_r")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBsProposal("\\f", RegExMessages.getString("displayString_bs_f"), RegExMessages.getString("additionalInfo_bs_f")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBsProposal("\\a", RegExMessages.getString("displayString_bs_a"), RegExMessages.getString("additionalInfo_bs_a")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBsProposal("\\e", RegExMessages.getString("displayString_bs_e"), RegExMessages.getString("additionalInfo_bs_e")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBracketProposal("\\c", 2, RegExMessages.getString("displayString_bs_c"), RegExMessages.getString("additionalInfo_bs_c")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                addBsProposal("\\C", RegExMessages.getString("displayString_replace_bs_C"), RegExMessages.getString("additionalInfo_replace_bs_C")); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            }
            fPriorityProposals.addAll(fProposals);
            return arraycast!(IContentProposal)( fPriorityProposals.toArray());
        }

        /**
         * Adds a proposal.
         *
         * @param proposal the string to be inserted
         * @param displayString the proposal's label
         * @param additionalInfo the additional information
         */
        private void addProposal(String proposal, String displayString, String additionalInfo) {
            fProposals.add(new Proposal(proposal, displayString, additionalInfo, proposal.length()));
        }

        /**
         * Adds a proposal.
         *
         * @param proposal the string to be inserted
         * @param cursorPosition the cursor position after insertion,
         *      relative to the start of the proposal
         * @param displayString the proposal's label
         * @param additionalInfo the additional information
         */
        private void addProposal(String proposal, int cursorPosition, String displayString, String additionalInfo) {
            fProposals.add(new Proposal(proposal, displayString, additionalInfo, cursorPosition));
        }

        /**
         * Adds a proposal to the priority proposals list.
         *
         * @param proposal the string to be inserted
         * @param displayString the proposal's label
         * @param additionalInfo the additional information
         */
        private void addPriorityProposal(String proposal, String displayString, String additionalInfo) {
            fPriorityProposals.add(new Proposal(proposal, displayString, additionalInfo, proposal.length()));
        }

        /**
         * Adds a proposal. Ensures that existing pre- and postfixes are not duplicated.
         *
         * @param proposal the string to be inserted
         * @param cursorPosition the cursor position after insertion,
         *      relative to the start of the proposal
         * @param displayString the proposal's label
         * @param additionalInfo the additional information
         */
        private void addBracketProposal(String proposal, int cursorPosition, String displayString, String additionalInfo) {
            String prolog= fExpression.substring(0, fDocumentOffset);
            if (! fIsEscape && prolog.endsWith("\\") && proposal.startsWith("\\")) { //$NON-NLS-1$//$NON-NLS-2$
                fProposals.add(new Proposal(proposal, displayString, additionalInfo, cursorPosition));
                return;
            }
            for (int i= 1; i <= cursorPosition; i++) {
                String prefix= proposal.substring(0, i);
                if (prolog.endsWith(prefix)) {
                    String postfix= proposal.substring(cursorPosition);
                    String epilog= fExpression.substring(fDocumentOffset);
                    if (epilog.startsWith(postfix)) {
                        fPriorityProposals.add(new Proposal(proposal.substring(i, cursorPosition), displayString, additionalInfo, cursorPosition-i));
                    } else {
                        fPriorityProposals.add(new Proposal(proposal.substring(i), displayString, additionalInfo, cursorPosition-i));
                    }
                    return;
                }
            }
            fProposals.add(new Proposal(proposal, displayString, additionalInfo, cursorPosition));
        }

        /**
         * Adds a proposal that starts with a backslash.
         * Ensures that the backslash is not repeated if already typed.
         *
         * @param proposal the string to be inserted
         * @param displayString the proposal's label
         * @param additionalInfo the additional information
         */
        private void addBsProposal(String proposal, String displayString, String additionalInfo) {
            String prolog= fExpression.substring(0, fDocumentOffset);
            int position= proposal.length();
            // If the string already contains the backslash, do not include in the proposal
            if (prolog.endsWith("\\")) { //$NON-NLS-1$
                position--;
                proposal= proposal.substring(1);
            }

            if (fIsEscape) {
                fPriorityProposals.add(new Proposal(proposal, displayString, additionalInfo, position));
            } else {
                addProposal(proposal, position, displayString, additionalInfo);
            }
        }
    }

    /**
     * <code>true</code> iff the processor is for the find field.
     * <code>false</code> iff the processor is for the replace field.
     */
    private const bool fIsFind;


    /**
     * Creates a new completion proposal provider.
     *
     * @param isFind <code>true</code> if the provider is used for the 'find' field
     *                  <code>false</code> if the provider is used for the 'replace' field
     */
    public this(bool isFind) {
        fIsFind= isFind;
    }

    /*
     * @see dwtx.jface.fieldassist.IContentProposalProvider#getProposals(java.lang.String, int)
     */
    public IContentProposal [] getProposals(String contents, int position) {
        if (fIsFind)
            return (new ProposalComputer(contents, position)).computeFindProposals();
        return (new ProposalComputer(contents, position)).computeReplaceProposals();
    }
}
