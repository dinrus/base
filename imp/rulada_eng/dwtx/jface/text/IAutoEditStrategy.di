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


module dwtx.jface.text.IAutoEditStrategy;

import dwtx.jface.text.DocumentCommand; // packageimport
import dwtx.jface.text.IDocument; // packageimport

import dwt.dwthelper.utils;


/**
 * An auto edit strategy can adapt changes that will be applied to
 * a text viewer's document. The strategy is informed by the text viewer
 * about each upcoming change in form of a document command. By manipulating
 * this document command, the strategy can influence in which way the text
 * viewer's document is changed. Clients may implement this interface.
 *
 * @since 2.1
 */
public interface IAutoEditStrategy {

    /**
     * Allows the strategy to manipulate the document command.
     *
     * @param document the document that will be changed
     * @param command the document command describing the change
     */
    void customizeDocumentCommand(IDocument document, DocumentCommand command);
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
