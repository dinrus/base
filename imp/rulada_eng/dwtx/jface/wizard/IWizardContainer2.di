/*******************************************************************************
 * Copyright (c) 2004, 2006 IBM Corporation and others.
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

module dwtx.jface.wizard.IWizardContainer2;

import dwtx.jface.wizard.IWizardContainer;

/**
 * <p><code>IWizardContainer2</code> is a supplement to
 * <code>IWizardContainer</code> that adds a method for updating the size of
 * the wizard shell based on the contents of the current page.</p>
 *
 * <p>The class <code>WizardDialog</code> provides a fully functional
 * implementation of this interface which will meet the needs of
 * most clients. However, clients are also free to implement this
 * interface if <code>WizardDialog</code> does not suit their needs.
 * </p>
 *
 * @see dwtx.jface.wizard.IWizardContainer
 * @since 3.0
 */
public interface IWizardContainer2 : IWizardContainer {

    /**
     * Updates the window size to reflect the state of the current wizard.
     * <p>
     * This method is called by the container itself
     * when its wizard changes and may be called
     * by the wizard at other times to force a window
     * size change.
     * </p>
     */
    public void updateSize();
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
