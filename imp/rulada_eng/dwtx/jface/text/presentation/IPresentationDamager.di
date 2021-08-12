/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module dwtx.jface.text.presentation.IPresentationDamager;

import dwtx.jface.text.presentation.IPresentationReconciler; // packageimport
import dwtx.jface.text.presentation.PresentationReconciler; // packageimport
import dwtx.jface.text.presentation.IPresentationRepairer; // packageimport
import dwtx.jface.text.presentation.IPresentationReconcilerExtension; // packageimport


import dwt.dwthelper.utils;



import dwtx.jface.text.DocumentEvent;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITypedRegion;


/**
 * A presentation damager is a strategy used by a presentation reconciler to
 * determine the region of the document's presentation which must be rebuilt
 * because of a document change. A presentation damager is assumed to be
 * specific for a particular document content type. A presentation damager is
 * expected to return a damage region which is a valid input for a presentation
 * repairer. I.e. having access to the damage region only the repairer must be
 * able to derive all the information needed to successfully repair this region.
 * <p>
 * This interface must either be implemented by clients or clients use the
 * rule-based default implementation
 * {@link dwtx.jface.text.rules.DefaultDamagerRepairer}. Implementers
 * should be registered with a presentation reconciler in order get involved in
 * the reconciling process.</p>
 *
 * @see IPresentationReconciler
 * @see IDocument
 * @see DocumentEvent
 * @see IPresentationRepairer
 */
public interface IPresentationDamager {

    /**
     * Tells the presentation damager on which document it will work.
     *
     * @param document the damager's working document
     */
    void setDocument(IDocument document);

    /**
     * Returns the damage in the document's presentation caused by the given document change.
     * The damage is restricted to the specified partition for which the presentation damager is
     * responsible. The damage may also depend on whether the document change also caused changes
     * of the document's partitioning.
     *
     * @param partition the partition inside which the damage must be determined
     * @param event the event describing the change whose damage must be determined
     * @param documentPartitioningChanged indicates whether the given change changed the document's partitioning
     * @return the computed damage
     */
    IRegion getDamageRegion(ITypedRegion partition, DocumentEvent event, bool documentPartitioningChanged);
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-dwtx");
        } else version (DigitalMars) {
            pragma(link, "DD-dwtx");
        } else {
            pragma(link, "DO-dwtx");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-dwtx");
        } else version (DigitalMars) {
            pragma(link, "DD-dwtx");
        } else {
            pragma(link, "DO-dwtx");
        }
    }
}
