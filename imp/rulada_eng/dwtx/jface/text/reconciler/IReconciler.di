/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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
module dwtx.jface.text.reconciler.IReconciler;

import dwtx.jface.text.reconciler.DirtyRegionQueue; // packageimport
import dwtx.jface.text.reconciler.IReconcilingStrategy; // packageimport
import dwtx.jface.text.reconciler.AbstractReconcileStep; // packageimport
import dwtx.jface.text.reconciler.IReconcilingStrategyExtension; // packageimport
import dwtx.jface.text.reconciler.MonoReconciler; // packageimport
import dwtx.jface.text.reconciler.IReconcileStep; // packageimport
import dwtx.jface.text.reconciler.AbstractReconciler; // packageimport
import dwtx.jface.text.reconciler.Reconciler; // packageimport
import dwtx.jface.text.reconciler.IReconcilableModel; // packageimport
import dwtx.jface.text.reconciler.DirtyRegion; // packageimport
import dwtx.jface.text.reconciler.IReconcileResult; // packageimport
import dwtx.jface.text.reconciler.IReconcilerExtension; // packageimport


import dwt.dwthelper.utils;

import dwtx.jface.text.ITextViewer;


/**
 * An <code>IReconciler</code> defines and maintains a model of the content
 * of the text  viewer's document in the presence of changes applied to this
 * document. An <code>IReconciler</code> is a {@link dwtx.jface.text.ITextViewer} add-on.
 * <p>
 * Reconcilers are assumed to be asynchronous, i.e. they allow a certain
 * temporal window of inconsistency between the document and the model of
 * the content of this document.
 * </p>
 * <p>
 * Reconcilers have a list of {@link dwtx.jface.text.reconciler.IReconcilingStrategy}
 * objects each of which is registered for a  particular document content type.
 * The reconciler uses the strategy objects to react on the changes applied
 * to the text viewer's document.
 *</p>
 * <p>
 * In order to provide backward compatibility for clients of <code>IReconciler</code>, extension
 * interfaces are used to provide a means of evolution. The following extension interfaces exist:
 * <ul>
 * <li>{@link dwtx.jface.text.reconciler.IReconcilerExtension} since version 3.0 introducing
 *      the ability to be aware of documents with multiple partitionings.</li>
 * </ul>
 * </p>
 * <p>
 * The interface can be implemented by clients. By default, clients use
 * {@link dwtx.jface.text.reconciler.MonoReconciler} or
 * {@link dwtx.jface.text.reconciler.Reconciler} as the standard
 * implementers of this interface.
 * </p>
 *
 * @see ITextViewer
 * @see IReconcilingStrategy
 */
public interface IReconciler {

    /**
     * Installs the reconciler on the given text viewer. After this method has been
     * finished, the reconciler is operational, i.e., it works without requesting
     * further client actions until <code>uninstall</code> is called.
     *
     * @param textViewer the viewer on which the reconciler is installed
     */
    void install(ITextViewer textViewer);

    /**
     * Removes the reconciler from the text viewer it has
     * previously been installed on.
     */
    void uninstall();

    /**
     * Returns the reconciling strategy registered with the reconciler
     * for the specified content type.
     *
     * @param contentType the content type for which to determine the reconciling strategy
     * @return the reconciling strategy registered for the given content type, or
     *      <code>null</code> if there is no such strategy
     */
    IReconcilingStrategy getReconcilingStrategy(String contentType);
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
