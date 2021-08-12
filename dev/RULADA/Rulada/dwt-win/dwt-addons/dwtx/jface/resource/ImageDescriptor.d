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
module dwtx.jface.resource.ImageDescriptor;

import dwtx.jface.resource.DeviceResourceDescriptor;
import dwtx.jface.resource.FileImageDescriptor;
import dwtx.jface.resource.URLImageDescriptor;
import dwtx.jface.resource.ImageDataImageDescriptor;
import dwtx.jface.resource.DerivedImageDescriptor;
import dwtx.jface.resource.DeviceResourceException;
import dwtx.jface.resource.MissingImageDescriptor;

import tango.net.Uri;

import dwt.DWTException;
import dwt.graphics.Device;
import dwt.graphics.Image;
import dwt.graphics.ImageData;
import dwt.graphics.PaletteData;
import dwt.graphics.RGB;
import dwt.widgets.Display;

import dwt.dwthelper.utils;

/**
 * An image descriptor is an object that knows how to create
 * an DWT image.  It does not hold onto images or cache them,
 * but rather just creates them on demand.  An image descriptor
 * is intended to be a lightweight representation of an image
 * that can be manipulated even when no DWT display exists.
 * <p>
 * This package defines a concrete image descriptor implementation
 * which reads an image from a file (<code>FileImageDescriptor</code>).
 * It also provides abstract framework classes (this one and
 * <code>CompositeImageDescriptor</code>) which may be subclassed to define
 * news kinds of image descriptors.
 * </p>
 * <p>
 * Using this abstract class involves defining a concrete subclass
 * and providing an implementation for the <code>getImageData</code>
 * method.
 * </p>
 * <p>
 * There are two ways to get an Image from an ImageDescriptor. The method
 * createImage will always return a new Image which must be disposed by
 * the caller. Alternatively, createResource() returns a shared
 * Image. When the caller is done with an image obtained from createResource,
 * they must call destroyResource() rather than disposing the Image directly.
 * The result of createResource() can be safely cast to an Image.
 * </p>
 *
 * @see dwt.graphics.Image
 */
public abstract class ImageDescriptor : DeviceResourceDescriptor {

    /**
     * A small red square used to warn that an image cannot be created.
     * <p>
     */
    protected static ImageData DEFAULT_IMAGE_DATA_;
    protected static ImageData DEFAULT_IMAGE_DATA(){
        if( DEFAULT_IMAGE_DATA_ is null ){
            synchronized( ImageDescriptor.classinfo ){
                if( DEFAULT_IMAGE_DATA_ is null ){
                    DEFAULT_IMAGE_DATA_ = new ImageData(6, 6, 1, new PaletteData( [ new RGB(255, 0, 0)  ] ));
                }
            }
        }
        return DEFAULT_IMAGE_DATA_;
    }

    /**
     * Constructs an image descriptor.
     */
    protected this() {
        // do nothing
    }

    /**
     * Creates and returns a new image descriptor from a file.
     * Convenience method for
     * <code>new FileImageDescriptor(location,filename)</code>.
     *
     * @param location the class whose resource directory contain the file
     * @param filename the file name
     * @return a new image descriptor
     */
    public static ImageDescriptor createFromFile( ImportData importData) {
        return new FileImageDescriptor(importData);
    }

    /**
     * Creates and returns a new image descriptor given ImageData
     * describing the image.
     *
     * @since 3.1
     *
     * @param data contents of the image
     * @return newly created image descriptor
     */
    public static ImageDescriptor createFromImageData(ImageData data) {
        return new ImageDataImageDescriptor(data);
    }

    /**
     * Creates and returns a new image descriptor for the given image. Note
     * that disposing the original Image will cause the descriptor to become invalid.
     *
     * @since 3.1
     *
     * @param img image to create
     * @return a newly created image descriptor
     */
    public static ImageDescriptor createFromImage(Image img) {
        return new ImageDataImageDescriptor(img);
    }

    /**
     * Creates an ImageDescriptor based on the given original descriptor, but with additional
     * DWT flags.
     *
     * <p>
     * Note that this sort of ImageDescriptor is slower and consumes more resources than
     * a regular image descriptor. It will also never generate results that look as nice as
     * a hand-drawn image. Clients are encouraged to supply their own disabled/grayed/etc. images
     * rather than using a default image and transforming it.
     * </p>
     *
     * @param originalImage image to transform
     * @param swtFlags any flag that can be passed to the flags argument of Image#Image(Device, Image, int)
     * @return an ImageDescriptor that creates new images by transforming the given image descriptor
     *
     * @see Image#Image(Device, Image, int)
     * @since 3.1
     *
     */
    public static ImageDescriptor createWithFlags(ImageDescriptor originalImage, int swtFlags) {
        return new DerivedImageDescriptor(originalImage, swtFlags);
    }

    /**
     * Creates and returns a new image descriptor for the given image. This
     * method takes the Device that created the Image as an argument, allowing
     * the original Image to be reused if the descriptor is asked for another
     * Image on the same device. Note that disposing the original Image will
     * cause the descriptor to become invalid.
     *
     * @deprecated use {@link ImageDescriptor#createFromImage(Image)}
     * @since 3.1
     *
     * @param img image to create
     * @param theDevice the device that was used to create the Image
     * @return a newly created image descriptor
     */
    public static ImageDescriptor createFromImage(Image img, Device theDevice) {
        return new ImageDataImageDescriptor(img);
    }

    /**
     * Creates and returns a new image descriptor from a URL.
     *
     * @param url The URL of the image file.
     * @return a new image descriptor
     */
    public static ImageDescriptor createFromURL(Uri url) {
        if (url is null) {
            return getMissingImageDescriptor();
        }
        return new URLImageDescriptor(url);
    }

    /* (non-Javadoc)
     * @see dwtx.jface.resource.DeviceResourceDescriptor#createResource(dwt.graphics.Device)
     */
    public override Object createResource(Device device) {
        Image result = createImage(false, device);
        if (result is null) {
            throw new DeviceResourceException(this);
        }
        return result;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.resource.DeviceResourceDescriptor#destroyResource(Object)
     */
    public override void destroyResource(Object previouslyCreatedObject) {
        (cast(Image)previouslyCreatedObject).dispose();
    }

    /**
     * Creates and returns a new DWT image for this image descriptor. Note that
     * each call returns a new DWT image object. The returned image must be
     * explicitly disposed using the image's dispose call. The image will not be
     * automatically garbage collected. A default image is returned in the event
     * of an error.
     *
     * <p>
     * Note: this method differs from createResource(Device) in that the returned image
     * must be disposed directly, whereas an image obtained from createResource(...)
     * must be disposed by calling destroyResource(...). It is not possible to
     * mix-and-match. If you obtained the Image from this method, you must not dispose
     * it by calling destroyResource. Clients are encouraged to use
     * create/destroyResource and downcast the result to Image rather than using
     * createImage.
     * </p>
     *
     * <p>
     * Note: it is still possible for this method to return <code>null</code>
     * in extreme cases, for example if DWT runs out of image handles.
     * </p>
     *
     * @return a new image or <code>null</code> if the image could not be
     *         created
     */
    public Image createImage() {
        return createImage(true);
    }

    /**
     * Creates and returns a new DWT image for this image descriptor. The
     * returned image must be explicitly disposed using the image's dispose
     * call. The image will not be automatically garbage collected. In the event
     * of an error, a default image is returned if
     * <code>returnMissingImageOnError</code> is true, otherwise
     * <code>null</code> is returned.
     * <p>
     * Note: Even if <code>returnMissingImageOnError</code> is true, it is
     * still possible for this method to return <code>null</code> in extreme
     * cases, for example if DWT runs out of image handles.
     * </p>
     *
     * @param returnMissingImageOnError
     *            flag that determines if a default image is returned on error
     * @return a new image or <code>null</code> if the image could not be
     *         created
     */
    public Image createImage(bool returnMissingImageOnError) {
        return createImage(returnMissingImageOnError, Display.getCurrent());
    }

    /**
     * Creates and returns a new DWT image for this image descriptor. The
     * returned image must be explicitly disposed using the image's dispose
     * call. The image will not be automatically garbage collected. A default
     * image is returned in the event of an error.
     * <p>
     * Note: it is still possible for this method to return <code>null</code>
     * in extreme cases, for example if DWT runs out of image handles.
     * </p>
     *
     * @param device
     *            the device on which to create the image
     * @return a new image or <code>null</code> if the image could not be
     *         created
     * @since 2.0
     */
    public Image createImage(Device device) {
        return createImage(true, device);
    }

    /**
     * Creates and returns a new DWT image for this image descriptor. The
     * returned image must be explicitly disposed using the image's dispose
     * call. The image will not be automatically garbage collected. In the even
     * of an error, a default image is returned if
     * <code>returnMissingImageOnError</code> is true, otherwise
     * <code>null</code> is returned.
     * <p>
     * Note: Even if <code>returnMissingImageOnError</code> is true, it is
     * still possible for this method to return <code>null</code> in extreme
     * cases, for example if DWT runs out of image handles.
     * </p>
     *
     * @param returnMissingImageOnError
     *            flag that determines if a default image is returned on error
     * @param device
     *            the device on which to create the image
     * @return a new image or <code>null</code> if the image could not be
     *         created
     * @since 2.0
     */
    public Image createImage(bool returnMissingImageOnError, Device device) {

        ImageData data = getImageData();
        if (data is null) {
            if (!returnMissingImageOnError) {
                return null;
            }
            data = DEFAULT_IMAGE_DATA;
        }

        /*
         * Try to create the supplied image. If there is an DWT Exception try and create
         * the default image if that was requested. Return null if this fails.
         */

        try {
            if (data.transparentPixel >= 0) {
                ImageData maskData = data.getTransparencyMask();
                return new Image(device, data, maskData);
            }
            return new Image(device, data);
        } catch (DWTException exception) {
            //ExceptionPrintStackTrace(exception);
            if (returnMissingImageOnError) {
                try {
                    return new Image(device, DEFAULT_IMAGE_DATA);
                } catch (DWTException nextException) {
                    return null;
                }
            }
            return null;
        }
    }

    /**
     * Creates and returns a new DWT <code>ImageData</code> object
     * for this image descriptor.
     * Note that each call returns a new DWT image data object.
     * <p>
     * This framework method is declared public so that it is
     * possible to request an image descriptor's image data without
     * creating an DWT image object.
     * </p>
     * <p>
     * Returns <code>null</code> if the image data could not be created.
     * </p>
     *
     * @return a new image data or <code>null</code>
     */
    public abstract ImageData getImageData();

    /**
     * Returns the shared image descriptor for a missing image.
     *
     * @return the missing image descriptor
     */
    public static ImageDescriptor getMissingImageDescriptor() {
        return MissingImageDescriptor.getInstance();
    }
}
