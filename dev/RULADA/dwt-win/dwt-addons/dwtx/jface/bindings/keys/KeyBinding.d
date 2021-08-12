/*******************************************************************************
 * Copyright (c) 2004, 2005 IBM Corporation and others.
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
module dwtx.jface.bindings.keys.KeyBinding;

import dwtx.jface.bindings.keys.KeySequence;

import dwtx.core.commands.ParameterizedCommand;
import dwtx.jface.bindings.Binding;
import dwtx.jface.bindings.TriggerSequence;

import dwt.dwthelper.utils;

/**
 * <p>
 * A keyboard shortcut. This is a binding between some keyboard input and the
 * triggering of a command. This object is immutable.
 * </p>
 *
 * @since 3.1
 */
public final class KeyBinding : Binding {

    /**
     * The key sequence which triggers this binding. This sequence is never
     * <code>null</code>.
     */
    private const KeySequence keySequence;

    /**
     * Constructs a new instance of <code>KeyBinding</code>.
     *
     * @param keySequence
     *            The key sequence which should trigger this binding. This value
     *            must not be <code>null</code>. It also must be a complete,
     *            non-empty key sequence.
     * @param command
     *            The parameterized command to which this binding applies; this
     *            value may be <code>null</code> if the binding is meant to
     *            "unbind" a previously defined binding.
     * @param schemeId
     *            The scheme to which this binding belongs; this value must not
     *            be <code>null</code>.
     * @param contextId
     *            The context to which this binding applies; this value must not
     *            be <code>null</code>.
     * @param locale
     *            The locale to which this binding applies; this value may be
     *            <code>null</code> if it applies to all locales.
     * @param platform
     *            The platform to which this binding applies; this value may be
     *            <code>null</code> if it applies to all platforms.
     * @param windowManager
     *            The window manager to which this binding applies; this value
     *            may be <code>null</code> if it applies to all window
     *            managers. This value is currently ignored.
     * @param type
     *            The type of binding. This should be either <code>SYSTEM</code>
     *            or <code>USER</code>.
     */
    public this(KeySequence keySequence,
            ParameterizedCommand command, String schemeId,
            String contextId, String locale, String platform,
            String windowManager, int type) {
        super(command, schemeId, contextId, locale, platform, windowManager,
                type);

        if (keySequence is null) {
            throw new NullPointerException("The key sequence cannot be null"); //$NON-NLS-1$
        }

        if (!keySequence.isComplete()) {
            throw new IllegalArgumentException(
                    "Cannot bind to an incomplete key sequence"); //$NON-NLS-1$
        }

        if (keySequence.isEmpty()) {
            throw new IllegalArgumentException(
                    "Cannot bind to an empty key sequence"); //$NON-NLS-1$
        }

        this.keySequence = keySequence;
    }

    /**
     * Returns the key sequence which triggers this binding. The key sequence
     * will not be <code>null</code>, empty or incomplete.
     *
     * @return The key sequence; never <code>null</code>.
     */
    public final KeySequence getKeySequence() {
        return keySequence;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.bindings.Binding#getTriggerSequence()
     */
    public override TriggerSequence getTriggerSequence() {
        return getKeySequence();
    }
}
