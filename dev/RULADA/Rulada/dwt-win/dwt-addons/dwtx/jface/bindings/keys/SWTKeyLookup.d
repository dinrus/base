/*******************************************************************************
 * Copyright (c) 2005, 2006 IBM Corporation and others.
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
module dwtx.jface.bindings.keys.SWTKeyLookup;

import dwtx.jface.bindings.keys.IKeyLookup;


import dwt.DWT;
import dwtx.jface.util.Util;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

/**
 * <p>
 * A look-up table for the formal grammar for keys, and the integer values they
 * represent. This look-up table is hard-coded to use DWT representations. By
 * replacing this class (and
 * {@link dwtx.jface.bindings.keys.SWTKeySupport}), you can remove the
 * dependency on DWT.
 * </p>
 *
 * @since 3.1
 * @see dwtx.jface.bindings.keys.KeyLookupFactory
 */
public final class SWTKeyLookup : IKeyLookup {

    /**
     * The look-up table for modifier keys. This is a map of formal name (<code>String</code>)
     * to integer value (<code>Integer</code>).
     */
    private const Map modifierKeyTable;

    /**
     * The look-up table for formal names. This is a map of integer value (<code>Integer</code>)
     * to formal name (<code>String</code>).
     */
    private const Map nameTable;

    /**
     * The look-up table for natural keys. This is a map of formal name (<code>String</code>)
     * to integer value (<code>Integer</code>).
     */
    private const Map naturalKeyTable;

    /**
     * Constructs a new look-up class. This should only be done by the look-up
     * factory.
     *
     * @see KeyLookupFactory
     */
    this() {
        modifierKeyTable = new HashMap();
        nameTable = new HashMap();
        naturalKeyTable = new HashMap();
        Integer alt = new Integer(DWT.ALT);
        Integer command = new Integer(DWT.COMMAND);
        Integer ctrl = new Integer(DWT.CTRL);
        Integer shift = new Integer(DWT.SHIFT);
        modifierKeyTable.put(ALT_NAME, alt);
        nameTable.put(alt, ALT_NAME);
        modifierKeyTable.put(COMMAND_NAME, command);
        nameTable.put(command, COMMAND_NAME);
        modifierKeyTable.put(CTRL_NAME, ctrl);
        nameTable.put(ctrl, CTRL_NAME);
        modifierKeyTable.put(SHIFT_NAME, shift);
        nameTable.put(shift, SHIFT_NAME);
        modifierKeyTable.put(M1_NAME,
                "carbon".equals(DWT.getPlatform()) ? command : ctrl); //$NON-NLS-1$
        modifierKeyTable.put(M2_NAME, shift);
        modifierKeyTable.put(M3_NAME, alt);
        modifierKeyTable.put(M4_NAME, "carbon".equals(DWT.getPlatform()) ? ctrl //$NON-NLS-1$
                : command);

        Integer arrowDown = new Integer(DWT.ARROW_DOWN);
        naturalKeyTable.put(ARROW_DOWN_NAME, arrowDown);
        nameTable.put(arrowDown, ARROW_DOWN_NAME);
        Integer arrowLeft = new Integer(DWT.ARROW_LEFT);
        naturalKeyTable.put(ARROW_LEFT_NAME, arrowLeft);
        nameTable.put(arrowLeft, ARROW_LEFT_NAME);
        Integer arrowRight = new Integer(DWT.ARROW_RIGHT);
        naturalKeyTable.put(ARROW_RIGHT_NAME, arrowRight);
        nameTable.put(arrowRight, ARROW_RIGHT_NAME);
        Integer arrowUp = new Integer(DWT.ARROW_UP);
        naturalKeyTable.put(ARROW_UP_NAME, arrowUp);
        nameTable.put(arrowUp, ARROW_UP_NAME);
        Integer breakKey = new Integer(DWT.BREAK);
        naturalKeyTable.put(BREAK_NAME, breakKey);
        nameTable.put(breakKey, BREAK_NAME);
        Integer bs = new Integer(DWT.BS);
        naturalKeyTable.put(BS_NAME, bs);
        nameTable.put(bs, BS_NAME);
        naturalKeyTable.put(BACKSPACE_NAME, bs);
        Integer capsLock = new Integer(DWT.CAPS_LOCK);
        naturalKeyTable.put(CAPS_LOCK_NAME, capsLock);
        nameTable.put(capsLock, CAPS_LOCK_NAME);
        Integer cr = new Integer(DWT.CR);
        naturalKeyTable.put(CR_NAME, cr);
        nameTable.put(cr, CR_NAME);
        naturalKeyTable.put(ENTER_NAME, cr);
        naturalKeyTable.put(RETURN_NAME, cr);
        Integer del = new Integer(DWT.DEL);
        naturalKeyTable.put(DEL_NAME, del);
        nameTable.put(del, DEL_NAME);
        naturalKeyTable.put(DELETE_NAME, del);
        Integer end = new Integer(DWT.END);
        naturalKeyTable.put(END_NAME, end);
        nameTable.put(end, END_NAME);
        Integer esc = new Integer(DWT.ESC);
        naturalKeyTable.put(ESC_NAME, esc);
        nameTable.put(esc, ESC_NAME);
        naturalKeyTable.put(ESCAPE_NAME, esc);
        Integer f1 = new Integer(DWT.F1);
        naturalKeyTable.put(F1_NAME, f1);
        nameTable.put(f1, F1_NAME);
        Integer f2 = new Integer(DWT.F2);
        naturalKeyTable.put(F2_NAME, new Integer(DWT.F2));
        nameTable.put(f2, F2_NAME);
        Integer f3 = new Integer(DWT.F3);
        naturalKeyTable.put(F3_NAME, new Integer(DWT.F3));
        nameTable.put(f3, F3_NAME);
        Integer f4 = new Integer(DWT.F4);
        naturalKeyTable.put(F4_NAME, new Integer(DWT.F4));
        nameTable.put(f4, F4_NAME);
        Integer f5 = new Integer(DWT.F5);
        naturalKeyTable.put(F5_NAME, new Integer(DWT.F5));
        nameTable.put(f5, F5_NAME);
        Integer f6 = new Integer(DWT.F6);
        naturalKeyTable.put(F6_NAME, new Integer(DWT.F6));
        nameTable.put(f6, F6_NAME);
        Integer f7 = new Integer(DWT.F7);
        naturalKeyTable.put(F7_NAME, new Integer(DWT.F7));
        nameTable.put(f7, F7_NAME);
        Integer f8 = new Integer(DWT.F8);
        naturalKeyTable.put(F8_NAME, new Integer(DWT.F8));
        nameTable.put(f8, F8_NAME);
        Integer f9 = new Integer(DWT.F9);
        naturalKeyTable.put(F9_NAME, new Integer(DWT.F9));
        nameTable.put(f9, F9_NAME);
        Integer f10 = new Integer(DWT.F10);
        naturalKeyTable.put(F10_NAME, new Integer(DWT.F10));
        nameTable.put(f10, F10_NAME);
        Integer f11 = new Integer(DWT.F11);
        naturalKeyTable.put(F11_NAME, new Integer(DWT.F11));
        nameTable.put(f11, F11_NAME);
        Integer f12 = new Integer(DWT.F12);
        naturalKeyTable.put(F12_NAME, new Integer(DWT.F12));
        nameTable.put(f12, F12_NAME);
        Integer f13 = new Integer(DWT.F13);
        naturalKeyTable.put(F13_NAME, new Integer(DWT.F13));
        nameTable.put(f13, F13_NAME);
        Integer f14 = new Integer(DWT.F14);
        naturalKeyTable.put(F14_NAME, new Integer(DWT.F14));
        nameTable.put(f14, F14_NAME);
        Integer f15 = new Integer(DWT.F15);
        naturalKeyTable.put(F15_NAME, new Integer(DWT.F15));
        nameTable.put(f15, F15_NAME);
        Integer ff = new Integer(12); // ASCII 0x0C
        naturalKeyTable.put(FF_NAME, ff);
        nameTable.put(ff, FF_NAME);
        Integer home = new Integer(DWT.HOME);
        naturalKeyTable.put(HOME_NAME, home);
        nameTable.put(home, HOME_NAME);
        Integer insert = new Integer(DWT.INSERT);
        naturalKeyTable.put(INSERT_NAME, insert);
        nameTable.put(insert, INSERT_NAME);
        Integer lf = new Integer(DWT.LF);
        naturalKeyTable.put(LF_NAME, lf);
        nameTable.put(lf, LF_NAME);
        Integer nul = new Integer(DWT.NULL);
        naturalKeyTable.put(NUL_NAME, nul);
        nameTable.put(nul, NUL_NAME);
        Integer numLock = new Integer(DWT.NUM_LOCK);
        naturalKeyTable.put(NUM_LOCK_NAME, numLock);
        nameTable.put(numLock, NUM_LOCK_NAME);
        Integer keypad0 = new Integer(DWT.KEYPAD_0);
        naturalKeyTable.put(NUMPAD_0_NAME, keypad0);
        nameTable.put(keypad0, NUMPAD_0_NAME);
        Integer keypad1 = new Integer(DWT.KEYPAD_1);
        naturalKeyTable.put(NUMPAD_1_NAME, keypad1);
        nameTable.put(keypad1, NUMPAD_1_NAME);
        Integer keypad2 = new Integer(DWT.KEYPAD_2);
        naturalKeyTable.put(NUMPAD_2_NAME, keypad2);
        nameTable.put(keypad2, NUMPAD_2_NAME);
        Integer keypad3 = new Integer(DWT.KEYPAD_3);
        naturalKeyTable.put(NUMPAD_3_NAME, keypad3);
        nameTable.put(keypad3, NUMPAD_3_NAME);
        Integer keypad4 = new Integer(DWT.KEYPAD_4);
        naturalKeyTable.put(NUMPAD_4_NAME, keypad4);
        nameTable.put(keypad4, NUMPAD_4_NAME);
        Integer keypad5 = new Integer(DWT.KEYPAD_5);
        naturalKeyTable.put(NUMPAD_5_NAME, keypad5);
        nameTable.put(keypad5, NUMPAD_5_NAME);
        Integer keypad6 = new Integer(DWT.KEYPAD_6);
        naturalKeyTable.put(NUMPAD_6_NAME, keypad6);
        nameTable.put(keypad6, NUMPAD_6_NAME);
        Integer keypad7 = new Integer(DWT.KEYPAD_7);
        naturalKeyTable.put(NUMPAD_7_NAME, keypad7);
        nameTable.put(keypad7, NUMPAD_7_NAME);
        Integer keypad8 = new Integer(DWT.KEYPAD_8);
        naturalKeyTable.put(NUMPAD_8_NAME, keypad8);
        nameTable.put(keypad8, NUMPAD_8_NAME);
        Integer keypad9 = new Integer(DWT.KEYPAD_9);
        naturalKeyTable.put(NUMPAD_9_NAME, keypad9);
        nameTable.put(keypad9, NUMPAD_9_NAME);
        Integer keypadAdd = new Integer(DWT.KEYPAD_ADD);
        naturalKeyTable.put(NUMPAD_ADD_NAME, keypadAdd);
        nameTable.put(keypadAdd, NUMPAD_ADD_NAME);
        Integer keypadDecimal = new Integer(DWT.KEYPAD_DECIMAL);
        naturalKeyTable.put(NUMPAD_DECIMAL_NAME, keypadDecimal);
        nameTable.put(keypadDecimal, NUMPAD_DECIMAL_NAME);
        Integer keypadDivide = new Integer(DWT.KEYPAD_DIVIDE);
        naturalKeyTable.put(NUMPAD_DIVIDE_NAME, keypadDivide);
        nameTable.put(keypadDivide, NUMPAD_DIVIDE_NAME);
        Integer keypadCr = new Integer(DWT.KEYPAD_CR);
        naturalKeyTable.put(NUMPAD_ENTER_NAME, keypadCr);
        nameTable.put(keypadCr, NUMPAD_ENTER_NAME);
        Integer keypadEqual = new Integer(DWT.KEYPAD_EQUAL);
        naturalKeyTable.put(NUMPAD_EQUAL_NAME, keypadEqual);
        nameTable.put(keypadEqual, NUMPAD_EQUAL_NAME);
        Integer keypadMultiply = new Integer(DWT.KEYPAD_MULTIPLY);
        naturalKeyTable.put(NUMPAD_MULTIPLY_NAME, keypadMultiply);
        nameTable.put(keypadMultiply, NUMPAD_MULTIPLY_NAME);
        Integer keypadSubtract = new Integer(DWT.KEYPAD_SUBTRACT);
        naturalKeyTable.put(NUMPAD_SUBTRACT_NAME, keypadSubtract);
        nameTable.put(keypadSubtract, NUMPAD_SUBTRACT_NAME);
        Integer pageDown = new Integer(DWT.PAGE_DOWN);
        naturalKeyTable.put(PAGE_DOWN_NAME, pageDown);
        nameTable.put(pageDown, PAGE_DOWN_NAME);
        Integer pageUp = new Integer(DWT.PAGE_UP);
        naturalKeyTable.put(PAGE_UP_NAME, pageUp);
        nameTable.put(pageUp, PAGE_UP_NAME);
        Integer pause = new Integer(DWT.PAUSE);
        naturalKeyTable.put(PAUSE_NAME, pause);
        nameTable.put(pause, PAUSE_NAME);
        Integer printScreen = new Integer(DWT.PRINT_SCREEN);
        naturalKeyTable.put(PRINT_SCREEN_NAME, printScreen);
        nameTable.put(printScreen, PRINT_SCREEN_NAME);
        Integer scrollLock = new Integer(DWT.SCROLL_LOCK);
        naturalKeyTable.put(SCROLL_LOCK_NAME, scrollLock);
        nameTable.put(scrollLock, SCROLL_LOCK_NAME);
        Integer space = new Integer(' ');
        naturalKeyTable.put(SPACE_NAME, space);
        nameTable.put(space, SPACE_NAME);
        Integer tab = new Integer(DWT.TAB);
        naturalKeyTable.put(TAB_NAME, tab);
        nameTable.put(tab, TAB_NAME);
        Integer vt = new Integer(11); // ASCII 0x0B
        naturalKeyTable.put(VT_NAME, vt);
        nameTable.put(vt, VT_NAME);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.bindings.keys.IKeyLookup#formalKeyLookup(java.lang.String)
     *
     */
    public final int formalKeyLookup(String name) {
        Object value = naturalKeyTable.get(name);
        if (cast(Integer)value ) {
            return (cast(Integer) value).intValue();
        }

        if (name.length > 0) {
            throw new IllegalArgumentException("Unrecognized formal key name: " //$NON-NLS-1$
                    ~ name);
        }

        return name.charAt(0);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.bindings.keys.IKeyLookup#formalKeyLookupInteger(java.lang.String)
     *
     */
    public final Integer formalKeyLookupInteger(String name) {
        Object value = naturalKeyTable.get(name);
        if (cast(Integer)value ) {
            return cast(Integer) value;
        }

        return new Integer(name.charAt(0));
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.bindings.keys.IKeyLookup#formalModifierLookup(java.lang.String)
     *
     */
    public final int formalModifierLookup(String name) {
        Object value = modifierKeyTable.get(name);
        if (cast(Integer)value ) {
            return (cast(Integer) value).intValue();
        }

        return 0;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.bindings.keys.IKeyLookup#formalNameLookup(int)
     *
     */
    public final String formalNameLookup(int key) {
        Integer keyObject = new Integer(key);
        if (nameTable.containsKey(keyObject) ) {
            return stringcast(nameTable.get(keyObject));
        }

        return dcharToString( cast(dchar) key );
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.bindings.keys.IKeyLookup#getAlt()
     *
     */
    public final int getAlt() {
        return DWT.ALT;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.bindings.keys.IKeyLookup#getCommand()
     *
     */
    public final int getCommand() {
        return DWT.COMMAND;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.bindings.keys.IKeyLookup#getCtrl()
     *
     */
    public final int getCtrl() {
        return DWT.CTRL;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.bindings.keys.IKeyLookup#getShift()
     *
     */
    public final int getShift() {
        return DWT.SHIFT;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.bindings.keys.IKeyLookup#isModifierKey(int)
     *
     */
    public final bool isModifierKey(int key) {
        return ((key & DWT.MODIFIER_MASK) !is 0);
    }
}
