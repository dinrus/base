/*******************************************************************************
 * Copyright (c) 2005 Stefan Zeiger and others.
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.novocode.com/legal/epl-v10.html
 * 
 * Contributors:
 *     Stefan Zeiger (szeiger@novocode.com) - initial API and implementation
 *******************************************************************************/

module dwtx.novocode.ishell.internal.DesktopListener;

import dwt.internal.DWTEventListener;
import dwt.widgets.Event;


/**
 * A listener which receives events when a change occurs on a DesktopForm.
 *
 * @author Stefan Zeiger (szeiger@novocode.com)
 * @since Jan 23, 2005
 * @version $Id: DesktopListener.java 320 2005-02-26 13:37:02 +0000 (Sat, 26 Feb 2005) szeiger $
 */

interface DesktopListener : DWTEventListener
{
    public void shellCreated(Event event);

    public void shellDisposed(Event event);

    public void shellActivated(Event event);
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
