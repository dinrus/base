/*******************************************************************************
 * Copyright (c) 2004, 2007 IBM Corporation and others.
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

module dwtx.jface.bindings.keys.SWTKeySupport;

import dwtx.jface.bindings.keys.KeyStroke;

import dwt.DWT;
import dwt.events.KeyEvent;
import dwt.widgets.Event;
import dwtx.jface.bindings.keys.formatting.IKeyFormatter;
import dwtx.jface.bindings.keys.formatting.NativeKeyFormatter;

import dwt.dwthelper.utils;

/**
 * <p>
 * A utility class for converting DWT events into key strokes.
 * </p>
 *
 * @since 3.1
 */
public final class SWTKeySupport {

    /**
     * A formatter that displays key sequences in a style native to the
     * platform.
     */
    private static const IKeyFormatter NATIVE_FORMATTER;

    static this(){
        NATIVE_FORMATTER = new NativeKeyFormatter();
    }

    /**
     * Given an DWT accelerator value, provide the corresponding key stroke.
     *
     * @param accelerator
     *            The accelerator to convert; should be a valid DWT accelerator
     *            value.
     * @return The equivalent key stroke; never <code>null</code>.
     */
    public static final KeyStroke convertAcceleratorToKeyStroke(int accelerator) {
        int modifierKeys = accelerator & DWT.MODIFIER_MASK;
        int naturalKey;
        if (accelerator is modifierKeys) {
            naturalKey = KeyStroke.NO_KEY;
        } else {
            naturalKey = accelerator - modifierKeys;
        }

        return KeyStroke.getInstance(modifierKeys, naturalKey);
    }

    /**
     * <p>
     * Converts the given event into an DWT accelerator value -- considering the
     * modified character with the shift modifier. This is the third accelerator
     * value that should be checked when processing incoming key events.
     * </p>
     * <p>
     * For example, on a standard US keyboard, "Ctrl+Shift+5" would be viewed as
     * "Ctrl+Shift+%".
     * </p>
     *
     * @param event
     *            The event to be converted; must not be <code>null</code>.
     * @return The combination of the state mask and the unmodified character.
     */
    public static final int convertEventToModifiedAccelerator(Event event) {
        int modifiers = event.stateMask & DWT.MODIFIER_MASK;
        char character = topKey(event);
        return modifiers + toUpperCase(character);
    }

    /**
     * <p>
     * Converts the given event into an DWT accelerator value -- considering the
     * unmodified character with all modifier keys. This is the first
     * accelerator value that should be checked when processing incoming key
     * events. However, all alphabetic characters are considered as their
     * uppercase equivalents.
     * </p>
     * <p>
     * For example, on a standard US keyboard, "Ctrl+Shift+5" would be viewed as
     * "Ctrl+Shift+5".
     * </p>
     *
     * @param event
     *            The event to be converted; must not be <code>null</code>.
     * @return The combination of the state mask and the unmodified character.
     */
    public static final int convertEventToUnmodifiedAccelerator(
            Event event) {
        return convertEventToUnmodifiedAccelerator(event.stateMask,
                event.keyCode);
    }

    /**
     * <p>
     * Converts the given state mask and key code into an DWT accelerator value --
     * considering the unmodified character with all modifier keys. All
     * alphabetic characters are considered as their uppercase equivalents.
     * </p>
     * <p>
     * For example, on a standard US keyboard, "Ctrl+Shift+5" would be viewed as
     * "Ctrl+Shift+5".
     * </p>
     *
     * @param stateMask
     *            The integer mask of modifiers keys depressed when this was
     *            pressed.
     * @param keyCode
     *            The key that was pressed, before being modified.
     * @return The combination of the state mask and the unmodified character.
     */
    private static final int convertEventToUnmodifiedAccelerator(
            int stateMask, int keyCode) {
        int modifiers = stateMask & DWT.MODIFIER_MASK;
        int character = keyCode;
        return modifiers + toUpperCase(character);
    }

    /**
     * <p>
     * Converts the given event into an DWT accelerator value -- considering the
     * unmodified character with all modifier keys. This is the first
     * accelerator value that should be checked. However, all alphabetic
     * characters are considered as their uppercase equivalents.
     * </p>
     * <p>
     * For example, on a standard US keyboard, "Ctrl+Shift+5" would be viewed as
     * "Ctrl+%".
     * </p>
     *
     * @param event
     *            The event to be converted; must not be <code>null</code>.
     * @return The combination of the state mask and the unmodified character.
     */
    public static final int convertEventToUnmodifiedAccelerator(
            KeyEvent event) {
        return convertEventToUnmodifiedAccelerator(event.stateMask,
                event.keyCode);
    }

    /**
     * Converts the given event into an DWT accelerator value -- considering the
     * modified character without the shift modifier. This is the second
     * accelerator value that should be checked when processing incoming key
     * events. Key strokes with alphabetic natural keys are run through
     * <code>convertEventToUnmodifiedAccelerator</code>.
     *
     * @param event
     *            The event to be converted; must not be <code>null</code>.
     * @return The combination of the state mask without shift, and the modified
     *         character.
     */
    public static final int convertEventToUnshiftedModifiedAccelerator(
            Event event) {
        // Disregard alphabetic key strokes.
        if (CharacterIsLetter(cast(dchar) event.keyCode)) {
            return convertEventToUnmodifiedAccelerator(event);
        }

        int modifiers = event.stateMask & (DWT.MODIFIER_MASK ^ DWT.SHIFT);
        char character = topKey(event);
        return modifiers + toUpperCase(character);
    }

    /**
     * Given a key stroke, this method provides the equivalent DWT accelerator
     * value. The functional inverse of
     * <code>convertAcceleratorToKeyStroke</code>.
     *
     * @param keyStroke
     *            The key stroke to convert; must not be <code>null</code>.
     * @return The DWT accelerator value
     */
    public static final int convertKeyStrokeToAccelerator(
            KeyStroke keyStroke) {
        return keyStroke.getModifierKeys() + keyStroke.getNaturalKey();
    }

    /**
     * Provides an instance of <code>IKeyFormatter</code> appropriate for the
     * current instance.
     *
     * @return an instance of <code>IKeyFormatter</code> appropriate for the
     *         current instance; never <code>null</code>.
     */
    public static IKeyFormatter getKeyFormatterForPlatform() {
        return NATIVE_FORMATTER;
    }

    /**
     * Makes sure that a fully-modified character is converted to the normal
     * form. This means that "Ctrl+" key strokes must reverse the modification
     * caused by control-escaping. Also, all lower case letters are converted to
     * uppercase.
     *
     * @param event
     *            The event from which the fully-modified character should be
     *            pulled.
     * @return The modified character, uppercase and without control-escaping.
     */
    private static final char topKey(Event event) {
        char character = event.character;
        bool ctrlDown = (event.stateMask & DWT.CTRL) !is 0;

        if (ctrlDown && event.character !is event.keyCode
                && event.character < 0x20
                && (event.keyCode & DWT.KEYCODE_BIT) is 0) {
            character += 0x40;
        }

        return character;
    }

    /**
     * Makes the given character uppercase if it is a letter.
     *
     * @param keyCode
     *            The character to convert.
     * @return The uppercase equivalent, if any; otherwise, the character
     *         itself.
     */
    private static final int toUpperCase(int keyCode) {
        // Will this key code be truncated?
        if (keyCode > 0xFFFF) {
            return keyCode;
        }

        // Downcast in safety. Only make characters uppercase.
        char character = cast(char) keyCode;
        return CharacterIsLetter(character) ? CharacterToUpper(character)
                : keyCode;
    }

    /**
     * This class should never be instantiated.
     */
    protected this() {
        // This class should never be instantiated.
    }
}
