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
module dwtx.jface.text.information.IInformationPresenter;

import dwtx.jface.text.information.InformationPresenter; // packageimport
import dwtx.jface.text.information.IInformationProvider; // packageimport
import dwtx.jface.text.information.IInformationProviderExtension; // packageimport
import dwtx.jface.text.information.IInformationPresenterExtension; // packageimport
import dwtx.jface.text.information.IInformationProviderExtension2; // packageimport


import dwt.dwthelper.utils;

import dwtx.jface.text.ITextViewer;


/**
 * An information presenter shows information available at the text viewer's
 * current document position. An <code>IInformationPresenter</code> is a
 * {@link dwtx.jface.text.ITextViewer} add-on.
 * <p>
 * An information presenters has a list of  {@link dwtx.jface.text.information.IInformationProvider} objects
 * each of which is registered for a  particular document content type.
 * The presenter uses the strategy objects to retrieve the information to present.
 * </p>
 * <p>
 * In order to provide backward compatibility for clients of <code>IInformationPresenter</code>, extension
 * interfaces are used to provide a means of evolution. The following extension interfaces exist:
 * <ul>
 * <li>{@link IInformationPresenterExtension} since version 3.0 introducing
 *      the ability to handle documents with multiple partitions</li>
 * </ul>
 * </p>
 * <p>
 * The interface can be implemented by clients. By default, clients use
 * {@link dwtx.jface.text.information.InformationPresenter} as the standard implementer of this interface.
 * </p>
 *
 * @see dwtx.jface.text.information.IInformationPresenterExtension
 * @see dwtx.jface.text.ITextViewer
 * @see dwtx.jface.text.information.IInformationProvider
 * @since 2.0
 */
public interface IInformationPresenter {

    /**
     * Installs the information presenter on the given text viewer. After this method has been
     * finished, the presenter is operational, i.e. the method {@link #showInformation()}
     * can be called until {@link #uninstall()} is called.
     *
     * @param textViewer the viewer on which the presenter is installed
     */
    void install(ITextViewer textViewer);

    /**
     * Removes the information presenter from the text viewer it has previously been
     * installed on.
     */
    void uninstall();

    /**
     * Shows information related to the cursor position of the text viewer
     * this information presenter is installed on.
     */
    void showInformation();

    /**
     * Returns the information provider to be used for the given content type.
     *
     * @param contentType the type of the content for which information will be requested
     * @return an information provider or <code>null</code> if none exists for the specified content type
     */
    IInformationProvider getInformationProvider(String contentType);
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