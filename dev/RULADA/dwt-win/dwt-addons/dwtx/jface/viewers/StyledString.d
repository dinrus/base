/*******************************************************************************
 * Copyright (c) 2008 IBM Corporation and others.
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
module dwtx.jface.viewers.StyledString;

import dwt.custom.StyleRange;
import dwt.graphics.TextStyle;
import dwtx.jface.preference.JFacePreferences;
import dwtx.jface.resource.ColorRegistry;
import dwtx.jface.resource.JFaceResources;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import tango.text.convert.Format;
import tango.core.Exception;


/**
 * A mutable string with styled ranges. All ranges mark substrings of the string
 * and do not overlap. Styles are applied using instances of {@link Styler} to
 * compute the result of {@link #getStyleRanges()}.
 *
 * The styled string can be built in the following two ways:
 * <ul>
 * <li>new strings with stylers can be appended</li>
 * <li>stylers can by applied to ranges of the existing string</li>
 * </ul>
 *
 * <p>
 * This class may be instantiated; it is not intended to be subclassed.
 * </p>
 *
 * @since 3.4
 */
public class StyledString {

    /**
     * A styler will be asked to apply its styles to one ore more ranges in the
     * {@link StyledString}.
     *
     */
    public static abstract class Styler {

        /**
         * Applies the styles represented by this object to the given textStyle.
         *
         * @param textStyle
         *            the {@link TextStyle} to modify
         */
        public abstract void applyStyles(TextStyle textStyle);
    }

    /**
     * A built-in styler using the {@link JFacePreferences#QUALIFIER_COLOR}
     * managed in the JFace color registry (See
     * {@link JFaceResources#getColorRegistry()}).
     */
    public static const Styler QUALIFIER_STYLER;

    /**
     * A built-in styler using the {@link JFacePreferences#COUNTER_COLOR}
     * managed in the JFace color registry (See
     * {@link JFaceResources#getColorRegistry()}).
     */
    public static const Styler COUNTER_STYLER;

    /**
     * A built-in styler using the {@link JFacePreferences#DECORATIONS_COLOR}
     * managed in the JFace color registry (See
     * {@link JFaceResources#getColorRegistry()}).
     */
    public static const Styler DECORATIONS_STYLER;

    /**
     * Creates a styler that takes the given foreground and background colors
     * from the JFace color registry.
     *
     * @param foregroundColorName
     *            the color name for the foreground color
     * @param backgroundColorName
     *            the color name for the background color
     *
     * @return the created style
     */
    public static Styler createColorRegistryStyler(String foregroundColorName,
            String backgroundColorName) {
        return new DefaultStyler(foregroundColorName, backgroundColorName);
    }

    private static const StyleRange[] EMPTY;
    private StringBuffer fBuffer;
    private StyleRunList fStyleRuns;

    static this(){
        QUALIFIER_STYLER = createColorRegistryStyler(
                JFacePreferences.QUALIFIER_COLOR, null);
        COUNTER_STYLER = createColorRegistryStyler(
                JFacePreferences.COUNTER_COLOR, null);
        DECORATIONS_STYLER = createColorRegistryStyler(
                JFacePreferences.DECORATIONS_COLOR, null);
        EMPTY = new StyleRange[0];
    }

    /**
     * Creates an empty {@link StyledString}.
     */
    public this() {
        fBuffer = new StringBuffer();
        fStyleRuns = null;
    }

    /**
     * Creates an {@link StyledString} initialized with a string without
     * a style associated.
     *
     * @param string
     *            the string
     */
    public this(String string) {
        this(string, null);
    }

    /**
     * Creates an {@link StyledString} initialized with a string and a
     * style.
     *
     * @param string
     *            the string
     * @param styler
     *            the styler for the string or <code>null</code> to not
     *            associated a styler.
     */
    public this(String string, Styler styler) {
        this();
        append(string, styler);
    }

    /**
     * Returns the string of this {@link StyledString}.
     *
     * @return the current string of this {@link StyledString}.
     */
    public String getString() {
        return fBuffer.toString();
    }

    /**
     * Returns the string of this {@link StyledString}.
     *
     * @return the current string of this {@link StyledString}.
     */
    public override String toString() {
        return getString();
    }

    /**
     * Returns the length of the string of this {@link StyledString}.
     *
     * @return the length of the current string
     */
    public int length() {
        return fBuffer.length();
    }

    /**
     * Appends a string to the {@link StyledString}. The appended string
     * will have no associated styler.
     *
     * @param string
     *            the string to append
     * @return returns a reference to this object
     */
    public StyledString append(String string) {
        return append(string, null);
    }

//     /**
//      * Appends the string representation of the given character array
//      * to the {@link StyledString}. The appended
//      * character array will have no associated styler.
//      *
//      * @param chars
//      *            the character array to append
//      * @return returns a reference to this object
//      */
//     public StyledString append(char[] chars) {
//         return append(chars, null);
//     }

    /**
     * Appends the string representation of the given character
     * to the {@link StyledString}. The appended
     * character will have no associated styler.
     *
     * @param ch
     *            the character to append
     * @return returns a reference to this object
     */
    public StyledString append(dchar ch) {
        return append(dcharToString(ch), null);
    }

    /**
     * Appends a string with styles to the {@link StyledString}.
     *
     * @param string
     *            the string to append
     * @return returns a reference to this object
     */
    public StyledString append(StyledString string) {
        if (string.length() is 0) {
            return this;
        }

        int offset = fBuffer.length();
        fBuffer.append(string.toString());

        List otherRuns = string.fStyleRuns;
        if (otherRuns !is null && !otherRuns.isEmpty()) {
            for (int i = 0; i < otherRuns.size(); i++) {
                StyleRun curr = cast(StyleRun) otherRuns.get(i);
                if (i is 0 && curr.offset !is 0) {
                    appendStyleRun(null, offset); // appended string will
                    // start with the default
                    // color
                }
                appendStyleRun(curr.style, offset + curr.offset);
            }
        } else {
            appendStyleRun(null, offset); // appended string will start with
            // the default color
        }
        return this;
    }

    /**
     * Appends the string representation of the given character
     * with a style to the {@link StyledString}. The
     * appended character will have the given style associated.
     *
     * @param ch
     *            the character to append
     * @param styler
     *            the styler to use for styling the character to append or
     *            <code>null</code> if no styler should be associated with the
     *            appended character
     * @return returns a reference to this object
     */
    public StyledString append(dchar ch, Styler styler) {
        return append(dcharToString(ch), styler);
    }

    /**
     * Appends a string with a style to the {@link StyledString}. The
     * appended string will be styled using the given styler.
     *
     * @param string
     *            the string to append
     * @param styler
     *            the styler to use for styling the string to append or
     *            <code>null</code> if no styler should be associated with the
     *            appended string.
     * @return returns a reference to this object
     */
    public StyledString append(String string, Styler styler) {
        if (string.length is 0)
            return this;

        int offset = fBuffer.length; // the length before appending
        fBuffer.append(string);
        appendStyleRun(styler, offset);
        return this;
    }

//     /**
//      * Appends the string representation of the given character array
//      * with a style to the {@link StyledString}. The
//      * appended character array will be styled using the given styler.
//      *
//      * @param chars
//      *            the character array to append
//      * @param styler
//      *            the styler to use for styling the character array to append or
//      *            <code>null</code> if no styler should be associated with the
//      *            appended character array
//      * @return returns a reference to this object
//      */
//     public StyledString append(char[] chars, Styler styler) {
//         if (chars.length is 0)
//             return this;
//
//         int offset = fBuffer.length(); // the length before appending
//         fBuffer.append(chars);
//         appendStyleRun(styler, offset);
//         return this;
//     }

    /**
     * Sets a styler to use for the given source range. The range must be
     * subrange of actual string of this {@link StyledString}. Stylers
     * previously set for that range will be overwritten.
     *
     * @param offset
     *            the start offset of the range
     * @param length
     *            the length of the range
     * @param styler
     *            the styler to set
     *
     * @throws StringIndexOutOfBoundsException
     *             if <code>start</code> is less than zero, or if offset plus
     *             length is greater than the length of this object.
     */
    public void setStyle(int offset, int length, Styler styler) {
        if (offset < 0 || offset + length > fBuffer.length) {
            throw new IllegalArgumentException (
                    Format( "Invalid offset ({}) or length ({})", offset, length )); //$NON-NLS-1$//$NON-NLS-2$//$NON-NLS-3$
        }
        if (length is 0) {
            return;
        }
        if (!hasRuns() || getLastRun().offset <= offset) {
            appendStyleRun(styler, offset);
            if (offset + length !is fBuffer.length()) {
                appendStyleRun(null, offset + length);
            }
            return;
        }

        int endRun = findRun(offset + length);
        if (endRun >= 0) {
            // run with the same end index, nothing to change
        } else {
            endRun = -(endRun + 1);
            if (offset + length < fBuffer.length()) {
                Styler prevStyle = endRun > 0 ? fStyleRuns.getRun(endRun - 1).style
                        : null;
                fStyleRuns
                        .add(endRun, new StyleRun(offset + length, prevStyle));
            }
        }

        int startRun = findRun(offset);
        if (startRun >= 0) {
            // run with the same start index
            StyleRun styleRun = fStyleRuns.getRun(startRun);
            styleRun.style = styler;
        } else {
            startRun = -(startRun + 1);

            Styler prevStyle = startRun > 0 ? fStyleRuns.getRun(startRun - 1).style
                    : null;
            if (isDifferentStyle(prevStyle, styler)
                    || (startRun is 0 && styler !is null)) {
                fStyleRuns.add(startRun, new StyleRun(offset, styler));
                endRun++; // endrun is moved one back
            } else {
                startRun--; // we use the previous
            }
        }
        if (startRun + 1 < endRun) {
            fStyleRuns.removeRange(startRun + 1, endRun);
        }
    }

    /**
     * Returns an array of {@link StyleRange} resulting from applying all
     * associated stylers for this string builder.
     *
     * @return an array of all {@link StyleRange} resulting from applying the
     *         stored stylers to this string.
     */
    public StyleRange[] getStyleRanges() {
        if (hasRuns()) {
            ArrayList res = new ArrayList();

            List styleRuns = getStyleRuns();
            int offset = 0;
            Styler style = null;
            for (int i = 0; i < styleRuns.size(); i++) {
                StyleRun curr = cast(StyleRun) styleRuns.get(i);
                if (isDifferentStyle(curr.style, style)) {
                    if (curr.offset > offset && style !is null) {
                        res.add(createStyleRange(offset, curr.offset, style));
                    }
                    offset = curr.offset;
                    style = curr.style;
                }
            }
            if (fBuffer.length() > offset && style !is null) {
                res.add(createStyleRange(offset, fBuffer.length(), style));
            }
            return arraycast!(StyleRange)(res.toArray());
        }
        return EMPTY;
    }

    private int findRun(int offset) {
        // method assumes that fStyleRuns is not null
        int low = 0;
        int high = fStyleRuns.size() - 1;
        while (low <= high) {
            int mid = (low + high) / 2;
            StyleRun styleRun = fStyleRuns.getRun(mid);
            if (styleRun.offset < offset) {
                low = mid + 1;
            } else if (styleRun.offset > offset) {
                high = mid - 1;
            } else {
                return mid; // key found
            }
        }
        return -(low + 1); // key not found.
    }

    private StyleRange createStyleRange(int start, int end, Styler style) {
        StyleRange styleRange = new StyleRange();
        styleRange.start = start;
        styleRange.length = end - start;
        style.applyStyles(styleRange);
        return styleRange;
    }

    private bool hasRuns() {
        return fStyleRuns !is null && !fStyleRuns.isEmpty();
    }

    private void appendStyleRun(Styler style, int offset) {
        StyleRun lastRun = getLastRun();
        if (lastRun !is null && lastRun.offset is offset) {
            lastRun.style = style;
            return;
        }

        if (lastRun is null && style !is null || lastRun !is null
                && isDifferentStyle(style, lastRun.style)) {
            getStyleRuns().add(new StyleRun(offset, style));
        }
    }

    private bool isDifferentStyle(Styler style1, Styler style2) {
        if (style1 is null) {
            return style2 !is null;
        }
        return !style1.opEquals(style2);
    }

    private StyleRun getLastRun() {
        if (fStyleRuns is null || fStyleRuns.isEmpty()) {
            return null;
        }
        return fStyleRuns.getRun(fStyleRuns.size() - 1);
    }

    private List getStyleRuns() {
        if (fStyleRuns is null)
            fStyleRuns = new StyleRunList();
        return fStyleRuns;
    }

    private static class StyleRun {
        public int offset;
        public Styler style;

        public this(int offset, Styler style) {
            this.offset = offset;
            this.style = style;
        }

        public override String toString() {
            return Format("Offset {}, style: {}", offset, style ); //$NON-NLS-1$//$NON-NLS-2$
        }
    }

    private static class StyleRunList : ArrayList {
        private static final long serialVersionUID = 123L;

        public this() {
            super(3);
        }

        public StyleRun getRun(int index) {
            return cast(StyleRun) get(index);
        }

        public void removeRange(int fromIndex, int toIndex) {
            super.removeRange(fromIndex, toIndex);
        }
    }

    private static class DefaultStyler : Styler {
        private final String fForegroundColorName;
        private final String fBackgroundColorName;

        public this(String foregroundColorName,
                String backgroundColorName) {
            fForegroundColorName = foregroundColorName;
            fBackgroundColorName = backgroundColorName;
        }

        public void applyStyles(TextStyle textStyle) {
            ColorRegistry colorRegistry = JFaceResources.getColorRegistry();
            if (fForegroundColorName !is null) {
                textStyle.foreground = colorRegistry.get(fForegroundColorName);
            }
            if (fBackgroundColorName !is null) {
                textStyle.background = colorRegistry.get(fBackgroundColorName);
            }
        }
    }

}
