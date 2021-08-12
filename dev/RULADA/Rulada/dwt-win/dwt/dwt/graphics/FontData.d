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
module dwt.graphics.FontData;


import dwt.DWT;
import dwt.internal.win32.OS;

import dwt.dwthelper.utils;
static import tango.text.Text;
import tango.util.Convert;
alias tango.text.Text.Text!(char) StringBuffer;

/**
 * Instances of this class describe operating system fonts.
 * <p>
 * For platform-independent behaviour, use the get and set methods
 * corresponding to the following properties:
 * <dl>
 * <dt>height</dt><dd>the height of the font in points</dd>
 * <dt>name</dt><dd>the face name of the font, which may include the foundry</dd>
 * <dt>style</dt><dd>A bitwise combination of NORMAL, ITALIC and BOLD</dd>
 * </dl>
 * If extra, platform-dependent functionality is required:
 * <ul>
 * <li>On <em>Windows</em>, the data member of the <code>FontData</code>
 * corresponds to a Windows <code>LOGFONT</code> structure whose fields
 * may be retrieved and modified.</li>
 * <li>On <em>X</em>, the fields of the <code>FontData</code> correspond
 * to the entries in the font's XLFD name and may be retrieved and modified.
 * </ul>
 * Application code does <em>not</em> need to explicitly release the
 * resources managed by each instance when those instances are no longer
 * required, and thus no <code>dispose()</code> method is provided.
 *
 * @see Font
 * @see <a href="http://www.eclipse.org/swt/">Sample code and further information</a>
 */

public final class FontData {

    /**
     * A Win32 LOGFONT struct
     * (Warning: This field is platform dependent)
     * <p>
     * <b>IMPORTANT:</b> This field is <em>not</em> part of the DWT
     * public API. It is marked public only so that it can be shared
     * within the packages provided by DWT. It is not available on all
     * platforms and should never be accessed from application code.
     * </p>
     */
    public LOGFONT data;

    /**
     * The height of the font data in points
     * (Warning: This field is platform dependent)
     * <p>
     * <b>IMPORTANT:</b> This field is <em>not</em> part of the DWT
     * public API. It is marked public only so that it can be shared
     * within the packages provided by DWT. It is not available on all
     * platforms and should never be accessed from application code.
     * </p>
     */
    public float height;

    /**
     * The locales of the font
     */
    String lang, country, variant;

    private static FontData s_this;

/**
 * Constructs a new uninitialized font data.
 */
public this() {
    // We set the charset field so that
    // wildcard searching will work properly
    // out of the box
    data.lfCharSet = cast(byte)OS.DEFAULT_CHARSET;
    height = 12;
}

/**
 * Constructs a new font data given the Windows <code>LOGFONT</code>
 * that it should represent.
 *
 * @param data the <code>LOGFONT</code> for the result
 */
this(LOGFONT* data, float height) {
    this.data = *data;
    this.height = height;
}

/**
 * Constructs a new FontData given a string representation
 * in the form generated by the <code>FontData.toString</code>
 * method.
 * <p>
 * Note that the representation varies between platforms,
 * and a FontData can only be created from a string that was
 * generated on the same platform.
 * </p>
 *
 * @param string the string representation of a <code>FontData</code> (must not be null)
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the argument is null</li>
 *    <li>ERROR_INVALID_ARGUMENT - if the argument does not represent a valid description</li>
 * </ul>
 *
 * @see #toString
 */
public this(String string) {
    if (string is null) DWT.error(DWT.ERROR_NULL_ARGUMENT);
    int start = 0;
    int end = string.indexOf('|');
    if (end is -1) DWT.error(DWT.ERROR_INVALID_ARGUMENT);
    String version1 = string.substring(start, end);
    try {
        if (Integer.parseInt(version1) !is 1) DWT.error(DWT.ERROR_INVALID_ARGUMENT);
    } catch (NumberFormatException e) {
        DWT.error(DWT.ERROR_INVALID_ARGUMENT);
    }

    start = end + 1;
    end = string.indexOf('|', start);
    if (end is -1) DWT.error(DWT.ERROR_INVALID_ARGUMENT);
    String name = string.substring(start, end);

    start = end + 1;
    end = string.indexOf('|', start);
    if (end is -1) DWT.error(DWT.ERROR_INVALID_ARGUMENT);
    float height = 0;
    try {
        height = Float.parseFloat(string.substring(start, end));
    } catch (NumberFormatException e) {
        DWT.error(DWT.ERROR_INVALID_ARGUMENT);
    }

    start = end + 1;
    end = string.indexOf('|', start);
    if (end is -1) DWT.error(DWT.ERROR_INVALID_ARGUMENT);
    int style = 0;
    try {
        style = Integer.parseInt(string.substring(start, end));
    } catch (NumberFormatException e) {
        DWT.error(DWT.ERROR_INVALID_ARGUMENT);
    }

    start = end + 1;
    end = string.indexOf('|', start);
    //data = OS.IsUnicode ? cast(LOGFONT)new LOGFONTW() : new LOGFONTA();
    data.lfCharSet = cast(byte)OS.DEFAULT_CHARSET;
    setName(name);
    setHeight(height);
    setStyle(style);
    if (end is -1) return;
    String platform = string.substring(start, end);

    start = end + 1;
    end = string.indexOf('|', start);
    if (end is -1) return;
    String version2 = string.substring(start, end);

    if (platform ==/*eq*/ "WINDOWS" && version2 ==/*eq*/ "1") {  //$NON-NLS-1$//$NON-NLS-2$
        LOGFONT newData;// = OS.IsUnicode ? cast(LOGFONT)new LOGFONTW() : new LOGFONTA();
        try {
            start = end + 1;
            end = string.indexOf('|', start);
            if (end is -1) return;
            newData.lfHeight = Integer.parseInt(string.substring(start, end));
            start = end + 1;
            end = string.indexOf('|', start);
            if (end is -1) return;
            newData.lfWidth = Integer.parseInt(string.substring(start, end));
            start = end + 1;
            end = string.indexOf('|', start);
            if (end is -1) return;
            newData.lfEscapement = Integer.parseInt(string.substring(start, end));
            start = end + 1;
            end = string.indexOf('|', start);
            if (end is -1) return;
            newData.lfOrientation = Integer.parseInt(string.substring(start, end));
            start = end + 1;
            end = string.indexOf('|', start);
            if (end is -1) return;
            newData.lfWeight = Integer.parseInt(string.substring(start, end));
            start = end + 1;
            end = string.indexOf('|', start);
            if (end is -1) return;
            newData.lfItalic = Byte.parseByte(string.substring(start, end));
            start = end + 1;
            end = string.indexOf('|', start);
            if (end is -1) return;
            newData.lfUnderline = Byte.parseByte(string.substring(start, end));
            start = end + 1;
            end = string.indexOf('|', start);
            if (end is -1) return;
            newData.lfStrikeOut = Byte.parseByte(string.substring(start, end));
            start = end + 1;
            end = string.indexOf('|', start);
            if (end is -1) return;
            newData.lfCharSet = Byte.parseByte(string.substring(start, end));
            start = end + 1;
            end = string.indexOf('|', start);
            if (end is -1) return;
            newData.lfOutPrecision = Byte.parseByte(string.substring(start, end));
            start = end + 1;
            end = string.indexOf('|', start);
            if (end is -1) return;
            newData.lfClipPrecision = Byte.parseByte(string.substring(start, end));
            start = end + 1;
            end = string.indexOf('|', start);
            if (end is -1) return;
            newData.lfQuality = Byte.parseByte(string.substring(start, end));
            start = end + 1;
            end = string.indexOf('|', start);
            if (end is -1) return;
            newData.lfPitchAndFamily = Byte.parseByte(string.substring(start, end));
            start = end + 1;
        } catch (NumberFormatException e) {
            setName(name);
            setHeight(height);
            setStyle(style);
            return;
        }
        String buffer = string.substring(start);
        auto wname = StrToTCHARs(buffer);
        int len = Math.min(OS.LF_FACESIZE - 1, wname.length);
        newData.lfFaceName[ 0 .. len ] = wname[ 0 .. len ];
        newData.lfFaceName[ len .. $ ] = 0;
        data = newData;
    }
}

/**
 * Constructs a new font data given a font name,
 * the height of the desired font in points,
 * and a font style.
 *
 * @param name the name of the font (must not be null)
 * @param height the font height in points
 * @param style a bit or combination of NORMAL, BOLD, ITALIC
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - when the font name is null</li>
 *    <li>ERROR_INVALID_ARGUMENT - if the height is negative</li>
 * </ul>
 */
public this(String name, int height, int style) {
    if (name is null) DWT.error(DWT.ERROR_NULL_ARGUMENT);
    setName(name);
    setHeight(height);
    setStyle(style);
    // We set the charset field so that
    // wildcard searching will work properly
    // out of the box
    data.lfCharSet = cast(byte)OS.DEFAULT_CHARSET;
}

/*public*/ this(String name, float height, int style) {
    if (name is null) DWT.error(DWT.ERROR_NULL_ARGUMENT);
    setName(name);
    setHeight(height);
    setStyle(style);
    // We set the charset field so that
    // wildcard searching will work properly
    // out of the box
    data.lfCharSet = cast(byte)OS.DEFAULT_CHARSET;
}

/**
 * Compares the argument to the receiver, and returns true
 * if they represent the <em>same</em> object using a class
 * specific comparison.
 *
 * @param object the object to compare with this object
 * @return <code>true</code> if the object is the same as this object and <code>false</code> otherwise
 *
 * @see #hashCode
 */
override public int opEquals (Object object) {
    if (object is this) return true;
    if( auto fd = cast(FontData)object ){
        LOGFONT* lf = &fd.data;
        return data.lfCharSet is lf.lfCharSet &&
            /*
            * This code is intentionally commented.  When creating
            * a FontData, lfHeight is not necessarily set.  Instead
            * we check the height field which is always set.
            */
    //      data.lfHeight is lf.lfHeight &&
            height is fd.height &&
            data.lfWidth is lf.lfWidth &&
            data.lfEscapement is lf.lfEscapement &&
            data.lfOrientation is lf.lfOrientation &&
            data.lfWeight is lf.lfWeight &&
            data.lfItalic is lf.lfItalic &&
            data.lfUnderline is lf.lfUnderline &&
            data.lfStrikeOut is lf.lfStrikeOut &&
            data.lfCharSet is lf.lfCharSet &&
            data.lfOutPrecision is lf.lfOutPrecision &&
            data.lfClipPrecision is lf.lfClipPrecision &&
            data.lfQuality is lf.lfQuality &&
            data.lfPitchAndFamily is lf.lfPitchAndFamily &&
            getName() ==/*eq*/ fd.getName();
    }
    return false;
}

extern (Windows) static int EnumLocalesProc(TCHAR* lpLocaleString) {

    /* Get the locale ID */
    int length_ = 8;
    String str = .TCHARzToStr( cast(TCHAR*)lpLocaleString, length_);
    int lcid = Integer.parseInt(str, 16);

    TCHAR[] buffer = new TCHAR[length_];

    /* Check the language */
    int size = OS.GetLocaleInfo(lcid, OS.LOCALE_SISO639LANGNAME, buffer.ptr, length_);
    if (size <= 0 || s_this.lang !=/*eq*/ .TCHARzToStr( buffer.ptr ).substring(0, size - 1)) return 1;

    /* Check the country */
    if (s_this.country !is null) {
        size = OS.GetLocaleInfo(lcid, OS.LOCALE_SISO3166CTRYNAME, buffer.ptr, length_);
        if (size <= 0 || s_this.country !=/*eq*/ .TCHARzToStr( buffer.ptr ).substring(0, size - 1)) return 1;
    }

    /* Get the charset */
    size = OS.GetLocaleInfo(lcid, OS.LOCALE_IDEFAULTANSICODEPAGE, buffer.ptr, length_);
    if (size <= 0) return 1;
    int cp = Integer.parseInt(.TCHARzToStr(buffer.ptr).substring(0, size - 1));
    CHARSETINFO lpCs;
    OS.TranslateCharsetInfo(cast(DWORD*)cp, &lpCs, OS.TCI_SRCCODEPAGE);
    s_this.data.lfCharSet = cast(BYTE)lpCs.ciCharset;

    return 0;
}

/**
 * Returns the height of the receiver in points.
 *
 * @return the height of this FontData
 *
 * @see #setHeight(int)
 */
public int getHeight() {
    return cast(int)(0.5f + height);
}

/*public*/ float getHeightF() {
    return height;
}

/**
 * Returns the locale of the receiver.
 * <p>
 * The locale determines which platform character set this
 * font is going to use. Widgets and graphics operations that
 * use this font will convert UNICODE strings to the platform
 * character set of the specified locale.
 * </p>
 * <p>
 * On platforms where there are multiple character sets for a
 * given language/country locale, the variant portion of the
 * locale will determine the character set.
 * </p>
 *
 * @return the <code>String</code> representing a Locale object
 * @since 3.0
 */
public String getLocale () {
    StringBuffer buffer = new StringBuffer ();
    char sep = '_';
    if (lang !is null) {
        buffer.append (lang);
        buffer.append (sep);
    }
    if (country !is null) {
        buffer.append (country);
        buffer.append (sep);
    }
    if (variant !is null) {
        buffer.append (variant);
    }

    String result = buffer.toString ();
    int length_ = result.length;
    if (length_ > 0) {
        if (result.charAt (length_ - 1) is sep) {
            result = result.substring (0, length_ - 1);
        }
    }
    return result;
}

/**
 * Returns the name of the receiver.
 * On platforms that support font foundries, the return value will
 * be the foundry followed by a dash ("-") followed by the face name.
 *
 * @return the name of this <code>FontData</code>
 *
 * @see #setName
 */
public String getName() {
    return .TCHARzToStr( data.lfFaceName.ptr, -1 );
}

/**
 * Returns the style of the receiver which is a bitwise OR of
 * one or more of the <code>DWT</code> constants NORMAL, BOLD
 * and ITALIC.
 *
 * @return the style of this <code>FontData</code>
 *
 * @see #setStyle
 */
public int getStyle() {
    int style = DWT.NORMAL;
    if (data.lfWeight is 700) style |= DWT.BOLD;
    if (data.lfItalic !is 0) style |= DWT.ITALIC;
    return style;
}

/**
 * Returns an integer hash code for the receiver. Any two
 * objects that return <code>true</code> when passed to
 * <code>equals</code> must return the same value for this
 * method.
 *
 * @return the receiver's hash
 *
 * @see #equals
 */
override public hash_t toHash () {
    String name = getName();
    return data.lfCharSet ^ getHeight() ^ data.lfWidth ^ data.lfEscapement ^
        data.lfOrientation ^ data.lfWeight ^ data.lfItalic ^data.lfUnderline ^
        data.lfStrikeOut ^ data.lfCharSet ^ data.lfOutPrecision ^
        data.lfClipPrecision ^ data.lfQuality ^ data.lfPitchAndFamily ^
        typeid(String).getHash(&name);
}

/**
 * Sets the height of the receiver. The parameter is
 * specified in terms of points, where a point is one
 * seventy-second of an inch.
 *
 * @param height the height of the <code>FontData</code>
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_INVALID_ARGUMENT - if the height is negative</li>
 * </ul>
 *
 * @see #getHeight
 */
public void setHeight(int height) {
    if (height < 0) DWT.error(DWT.ERROR_INVALID_ARGUMENT);
    this.height = height;
}

/*public*/ void setHeight(float height) {
    if (height < 0) DWT.error(DWT.ERROR_INVALID_ARGUMENT);
    this.height = height;
}

/**
 * Sets the locale of the receiver.
 * <p>
 * The locale determines which platform character set this
 * font is going to use. Widgets and graphics operations that
 * use this font will convert UNICODE strings to the platform
 * character set of the specified locale.
 * </p>
 * <p>
 * On platforms where there are multiple character sets for a
 * given language/country locale, the variant portion of the
 * locale will determine the character set.
 * </p>
 *
 * @param locale the <code>String</code> representing a Locale object
 * @see java.util.Locale#toString
 */
public void setLocale(String locale) {
    lang = country = variant = null;
    if (locale !is null) {
        char sep = '_';
        int length_ = locale.length;
        int firstSep, secondSep;

        firstSep = locale.indexOf(sep);
        if (firstSep is -1) {
            firstSep = secondSep = length_;
        } else {
            secondSep = locale.indexOf(sep, firstSep + 1);
            if (secondSep is -1) secondSep = length_;
        }
        if (firstSep > 0) lang = locale.substring(0, firstSep);
        if (secondSep > firstSep + 1) country = locale.substring(firstSep + 1, secondSep);
        if (length_ > secondSep + 1) variant = locale.substring(secondSep + 1);
    }
    if (lang is null) {
        data.lfCharSet = cast(byte)OS.DEFAULT_CHARSET;
    } else {
        synchronized(this.classinfo){
            s_this = this;
            OS.EnumSystemLocales(&EnumLocalesProc, OS.LCID_SUPPORTED);
            s_this = null;
        }
    }
}

/**
 * Sets the name of the receiver.
 * <p>
 * Some platforms support font foundries. On these platforms, the name
 * of the font specified in setName() may have one of the following forms:
 * <ol>
 * <li>a face name (for example, "courier")</li>
 * <li>a foundry followed by a dash ("-") followed by a face name (for example, "adobe-courier")</li>
 * </ol>
 * In either case, the name returned from getName() will include the
 * foundry.
 * </p>
 * <p>
 * On platforms that do not support font foundries, only the face name
 * (for example, "courier") is used in <code>setName()</code> and
 * <code>getName()</code>.
 * </p>
 *
 * @param name the name of the font data (must not be null)
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - when the font name is null</li>
 * </ul>
 *
 * @see #getName
 */
public void setName(String name) {
    if (name is null) DWT.error(DWT.ERROR_NULL_ARGUMENT);

    /* The field lfFaceName must be NULL terminated */
    auto wname = StrToTCHARs(name);
    int len = Math.min(OS.LF_FACESIZE - 1, wname.length);
    data.lfFaceName[0 .. len] = wname[ 0 .. len ];
    data.lfFaceName[len .. $] = 0;
}

/**
 * Sets the style of the receiver to the argument which must
 * be a bitwise OR of one or more of the <code>DWT</code>
 * constants NORMAL, BOLD and ITALIC.  All other style bits are
 * ignored.
 *
 * @param style the new style for this <code>FontData</code>
 *
 * @see #getStyle
 */
public void setStyle(int style) {
    if ((style & DWT.BOLD) is DWT.BOLD) {
        data.lfWeight = 700;
    } else {
        data.lfWeight = 0;
    }
    if ((style & DWT.ITALIC) is DWT.ITALIC) {
        data.lfItalic = 1;
    } else {
        data.lfItalic = 0;
    }
}

/**
 * Returns a string representation of the receiver which is suitable
 * for constructing an equivalent instance using the
 * <code>FontData(String)</code> constructor.
 *
 * @return a string representation of the FontData
 *
 * @see FontData
 */
override public String toString() {
    StringBuffer buffer = new StringBuffer();
    buffer.append("1|"); //$NON-NLS-1$
    buffer.append(getName());
    buffer.append("|"); //$NON-NLS-1$
    buffer.append(to!(String)(getHeightF()));
    buffer.append("|"); //$NON-NLS-1$
    buffer.append(to!(String)(getStyle()));
    buffer.append("|"); //$NON-NLS-1$
    buffer.append("WINDOWS|1|"); //$NON-NLS-1$
    buffer.append(to!(String)(data.lfHeight));
    buffer.append("|"); //$NON-NLS-1$
    buffer.append(to!(String)(data.lfWidth));
    buffer.append("|"); //$NON-NLS-1$
    buffer.append(to!(String)(data.lfEscapement));
    buffer.append("|"); //$NON-NLS-1$
    buffer.append(to!(String)(data.lfOrientation));
    buffer.append("|"); //$NON-NLS-1$
    buffer.append(to!(String)(data.lfWeight));
    buffer.append("|"); //$NON-NLS-1$
    buffer.append(to!(String)(data.lfItalic));
    buffer.append("|"); //$NON-NLS-1$
    buffer.append(to!(String)(data.lfUnderline));
    buffer.append("|"); //$NON-NLS-1$
    buffer.append(to!(String)(data.lfStrikeOut));
    buffer.append("|"); //$NON-NLS-1$
    buffer.append(to!(String)(data.lfCharSet));
    buffer.append("|"); //$NON-NLS-1$
    buffer.append(to!(String)(data.lfOutPrecision));
    buffer.append("|"); //$NON-NLS-1$
    buffer.append(to!(String)(data.lfClipPrecision));
    buffer.append("|"); //$NON-NLS-1$
    buffer.append(to!(String)(data.lfQuality));
    buffer.append("|"); //$NON-NLS-1$
    buffer.append(to!(String)(data.lfPitchAndFamily));
    buffer.append("|"); //$NON-NLS-1$
    buffer.append(getName());
    return buffer.toString();
}

/**
 * Invokes platform specific functionality to allocate a new font data.
 * <p>
 * <b>IMPORTANT:</b> This method is <em>not</em> part of the public
 * API for <code>FontData</code>. It is marked public only so that
 * it can be shared within the packages provided by DWT. It is not
 * available on all platforms, and should never be called from
 * application code.
 * </p>
 *
 * @param data the <code>LOGFONT</code> for the font data
 * @param height the height of the font data
 * @return a new font data object containing the specified <code>LOGFONT</code> and height
 */
public static FontData win32_new(LOGFONT* data, float height) {
    return new FontData(data, height);
}

}
