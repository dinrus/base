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
module dwtx.jface.action.ControlContribution;

import dwtx.jface.action.ContributionItem;

import dwt.DWT;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Menu;
import dwt.widgets.ToolBar;
import dwt.widgets.ToolItem;
import dwtx.core.runtime.Assert;

import dwt.dwthelper.utils;

/**
 * An abstract contribution item implementation for adding an arbitrary
 * DWT control to a tool bar.
 * Note, however, that these items cannot be contributed to menu bars.
 * <p>
 * The <code>createControl</code> framework method must be implemented
 * by concrete subclasses.
 * </p>
 */
public abstract class ControlContribution : ContributionItem {
    alias ContributionItem.fill fill;
    /**
     * Creates a control contribution item with the given id.
     *
     * @param id the contribution item id
     */
    protected this(String id) {
        super(id);
    }

    /**
     * Computes the width of the given control which is being added
     * to a tool bar.  This is needed to determine the width of the tool bar item
     * containing the given control.
     * <p>
     * The default implementation of this framework method returns
     * <code>control.computeSize(DWT.DEFAULT, DWT.DEFAULT, true).x</code>.
     * Subclasses may override if required.
     * </p>
     *
     * @param control the control being added
     * @return the width of the control
     */
    protected int computeWidth(Control control) {
        return control.computeSize(DWT.DEFAULT, DWT.DEFAULT, true).x;
    }

    /**
     * Creates and returns the control for this contribution item
     * under the given parent composite.
     * <p>
     * This framework method must be implemented by concrete
     * subclasses.
     * </p>
     *
     * @param parent the parent composite
     * @return the new control
     */
    protected abstract Control createControl(Composite parent);

    /**
     * The control item implementation of this <code>IContributionItem</code>
     * method calls the <code>createControl</code> framework method.
     * Subclasses must implement <code>createControl</code> rather than
     * overriding this method.
     */
    public override final void fill(Composite parent) {
        createControl(parent);
    }

    /**
     * The control item implementation of this <code>IContributionItem</code>
     * method throws an exception since controls cannot be added to menus.
     */
    public override final void fill(Menu parent, int index) {
        Assert.isTrue(false, "Can't add a control to a menu");//$NON-NLS-1$
    }

    /**
     * The control item implementation of this <code>IContributionItem</code>
     * method calls the <code>createControl</code> framework method to
     * create a control under the given parent, and then creates
     * a new tool item to hold it.
     * Subclasses must implement <code>createControl</code> rather than
     * overriding this method.
     */
    public override final void fill(ToolBar parent, int index) {
        Control control = createControl(parent);
        ToolItem ti = new ToolItem(parent, DWT.SEPARATOR, index);
        ti.setControl(control);
        ti.setWidth(computeWidth(control));
    }
}
