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
module dwtx.jface.contentassist.ISubjectControlContextInformationPresenter;

import dwt.dwthelper.utils;

import dwtx.jface.text.contentassist.IContextInformation;
import dwtx.jface.text.contentassist.IContextInformationPresenter;
import dwtx.jface.contentassist.IContentAssistSubjectControl;

/**
 * Extends {@link dwtx.jface.text.contentassist.IContextInformationPresenter} to
 * allow to install a content assistant on the given
 * {@linkplain dwtx.jface.contentassist.IContentAssistSubjectControl content assist subject control}.
 *
 * @since 3.0
 * @deprecated As of 3.2, replaced by Platform UI's field assist support
 */
public interface ISubjectControlContextInformationPresenter : IContextInformationPresenter {

    /**
     * Installs this presenter for the given context information.
     *
     * @param info the context information which this presenter should style
     * @param contentAssistSubjectControl the content assist subject control
     * @param offset the document offset for which the information has been computed
     */
    void install(IContextInformation info, IContentAssistSubjectControl contentAssistSubjectControl, int offset);
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