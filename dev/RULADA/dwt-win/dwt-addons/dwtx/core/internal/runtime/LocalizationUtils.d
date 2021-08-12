/*******************************************************************************
 * Copyright (c) 2006 IBM Corporation and others.
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
module dwtx.core.internal.runtime.LocalizationUtils;

import dwt.dwthelper.utils;

/**
 * Helper methods related to string localization.
 *
 * @since dwtx.equinox.common 3.3
 */
public class LocalizationUtils {
    /**
     * This method can be used in the absence of NLS class. The method tries to
     * use the NLS-based translation routine. If it falls, the method returns the original
     * non-translated key.
     *
     * @param key case-sensitive name of the filed in the translation file representing 
     * the string to be translated
     * @return The localized message or the non-translated key
     */
    static public String safeLocalize(String key) {
//TODO: LocalizationUtils tries to load module CommonMessages. How to handle this?
//         try {
//             Class messageClass = Class.forName("dwtx.core.internal.runtime.CommonMessages"); //$NON-NLS-1$
//             if (messageClass is null)
//                 return key;
//             Field field = messageClass.getDeclaredField(key);
//             if (field is null)
//                 return key;
//             Object value = field.get(null);
//             if (value instanceof String)
//                 return (String) value;
//         } catch (ClassNotFoundException e) {
//             // eat exception and fall through
//         } catch (NoClassDefFoundError e) {
//             // eat exception and fall through
//         } catch (SecurityException e) {
//             // eat exception and fall through
//         } catch (NoSuchFieldException e) {
//             // eat exception and fall through
//         } catch (IllegalArgumentException e) {
//             // eat exception and fall through
//         } catch (IllegalAccessException e) {
//             // eat exception and fall through
//         }
        return key;
    }
}
