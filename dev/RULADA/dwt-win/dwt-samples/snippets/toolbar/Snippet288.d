/*******************************************************************************
 * Copyright (c) 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *******************************************************************************/
module toolbar.Snippet288;

/*
 * Create a ToolBar containing animated GIFs
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.DWTException;
import dwt.graphics.GC;
import dwt.graphics.Color;
import dwt.graphics.Image;
import dwt.graphics.ImageLoader;
import dwt.graphics.ImageData;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.ToolBar;
import dwt.widgets.ToolItem;
import dwt.widgets.FileDialog;
import dwt.dwthelper.Runnable;

import tango.io.FilePath;
import tango.io.FileConst;
import tango.core.Thread;
import tango.io.Stdout;
import tango.util.Convert;
import tango.core.Exception;

static Display display;
static Shell shell;
static GC shellGC;
static Color shellBackground;
static ImageLoader[] loader;
static ImageData[][] imageDataArray;
static Thread[] animateThread;
static Image[][] image;
private static ToolItem[] item;
static final bool useGIFBackground = false;

void main () {
    display = new Display();
    Shell shell = new Shell (display);
    shellBackground = shell.getBackground();
    FileDialog dialog = new FileDialog(shell, DWT.OPEN | DWT.MULTI);
    dialog.setText("Select Multiple Animated GIFs");
    dialog.setFilterExtensions(["*.gif"]);
    char[] filename = dialog.open();
    char[][] filenames = dialog.getFileNames();
    int numToolBarItems = filenames.length;
    if (numToolBarItems > 0) {
        try {
            loadAllImages((new FilePath(filename)).parent, filenames);
        } catch (DWTException e) {
            Stdout.print("There was an error loading an image.").newline;
            e.printStackTrace();
        }
        ToolBar toolBar = new ToolBar (shell, DWT.FLAT | DWT.BORDER | DWT.WRAP);
        item = new ToolItem[numToolBarItems];
        for (int i = 0; i < numToolBarItems; i++) {
            item[i] = new ToolItem (toolBar, DWT.PUSH);
            item[i].setImage(image[i][0]);
        }
        toolBar.pack ();
        shell.open ();
			
        startAnimationThreads();
			
        while (!shell.isDisposed()) {
            if (!display.readAndDispatch ()) display.sleep ();
        }
			
        for (int i = 0; i < numToolBarItems; i++) {
            for (int j = 0; j < image[i].length; j++) {
                image[i][j].dispose();
            }
        }
        display.dispose ();
    }
    thread_joinAll();
}

private static void loadAllImages(char[] directory, char[][] filenames) {
    int numItems = filenames.length;
    loader.length = numItems;
    imageDataArray.length = numItems;
    image.length = numItems;
    for (int i = 0; i < numItems; i++) {
        loader[i] = new ImageLoader();
        int fullWidth = loader[i].logicalScreenWidth;
        int fullHeight = loader[i].logicalScreenHeight;
        imageDataArray[i] = loader[i].load(directory ~ FileConst.PathSeparatorChar ~ filenames[i]);
        int numFramesOfAnimation = imageDataArray[i].length;
        image[i] = new Image[numFramesOfAnimation];
        for (int j = 0; j < numFramesOfAnimation; j++) {
            if (j == 0) {
                //for the first frame of animation, just draw the first frame
                image[i][j] = new Image(display, imageDataArray[i][j]);
                fullWidth = imageDataArray[i][j].width;
                fullHeight = imageDataArray[i][j].height;
            }
            else {
                //after the first frame of animation, draw the background or previous frame first, then the new image data 
                image[i][j] = new Image(display, fullWidth, fullHeight);
                GC gc = new GC(image[i][j]);
                gc.setBackground(shellBackground);
                gc.fillRectangle(0, 0, fullWidth, fullHeight);
                ImageData imageData = imageDataArray[i][j];
                switch (imageData.disposalMethod) {
                case DWT.DM_FILL_BACKGROUND:
                    /* Fill with the background color before drawing. */
                    Color bgColor = null;
                    if (useGIFBackground && loader[i].backgroundPixel != -1) {
                        bgColor = new Color(display, imageData.palette.getRGB(loader[i].backgroundPixel));
                    }
                    gc.setBackground(bgColor !is null ? bgColor : shellBackground);
                    gc.fillRectangle(imageData.x, imageData.y, imageData.width, imageData.height);
                    if (bgColor !is null) bgColor.dispose();
                    break;
                default:
                    /* Restore the previous image before drawing. */
                    gc.drawImage(
                        image[i][j-1],
                        0,
                        0,
                        fullWidth,
                        fullHeight,
                        0,
                        0,
                        fullWidth,
                        fullHeight);
                    break;
                }
                Image newFrame = new Image(display, imageData);
                gc.drawImage(newFrame,
                             0,
                             0,
                             imageData.width,
                             imageData.height,
                             imageData.x,
                             imageData.y,
                             imageData.width,
                             imageData.height);
                newFrame.dispose();
                gc.dispose();
            }
        }
    }
}

private static void startAnimationThreads() {
    animateThread = new Thread[image.length];
    for (int ii = 0; ii < image.length; ii++) {
        animateThread[ii] = new class(ii) Thread {
            int imageDataIndex = 0;
            int id = 0;
            this(int _id) { 
                id = _id;
                name = "Animation "~to!(char[])(ii);
                isDaemon = true;
                super(&run);
            }
            void run() {
                try {
                    int repeatCount = loader[id].repeatCount;
                    while (loader[id].repeatCount == 0 || repeatCount > 0) {
                        imageDataIndex = (imageDataIndex + 1) % imageDataArray[id].length;
                        if (!display.isDisposed()) {
                            display.asyncExec(new class Runnable {
									public void run() {
										if (!item[id].isDisposed())
											item[id].setImage(image[id][imageDataIndex]);
									}
								});
                        }
							
                        /* Sleep for the specified delay time (adding commonly-used slow-down fudge factors). */
                        try {
                            int ms = imageDataArray[id][imageDataIndex].delayTime * 10;
                            if (ms < 20) ms += 30;
                            if (ms < 30) ms += 10;
                            Thread.sleep(0.001*ms);
                        } catch (ThreadException e) {
                        }

                        /* If we have just drawn the last image, decrement the repeat count and start again. */
                        if (imageDataIndex == imageDataArray[id].length - 1) repeatCount--;
                    }
                } catch (DWTException ex) {
                    Stdout.print("There was an error animating the GIF").newline;
                    ex.printStackTrace();
                }
            }
        };
        animateThread[ii].start();
    }
}

