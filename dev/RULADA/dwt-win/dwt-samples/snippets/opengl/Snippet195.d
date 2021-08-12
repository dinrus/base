/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D Programming Language:
 *     John Reimer <terminal.node@gmail.com>
 *******************************************************************************/

module opengl.Snippet195;

/*
 * SWT OpenGL snippet: based on snippet195.java
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 *
 * @since 3.2
 */

import dwt.DWT;
import dwt.dwthelper.Runnable;

import dwt.layout.FillLayout;
import dwt.widgets.Shell;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Composite;
import dwt.widgets.Listener;
import dwt.graphics.Rectangle;
import dwt.opengl.GLCanvas;
import dwt.opengl.GLData;

import derelict.opengl.gl;
import derelict.opengl.glu;

import Math = tango.math.Math;

void drawTorus(float r, float R, int nsides, int rings)
{
    float ringDelta = 2.0f * cast(float) Math.PI / rings;
    float sideDelta = 2.0f * cast(float) Math.PI / nsides;
    float theta = 0.0f, cosTheta = 1.0f, sinTheta = 0.0f;
    for (int i = rings - 1; i >= 0; i--) {
        float theta1 = theta + ringDelta;
        float cosTheta1 = cast(float) Math.cos(theta1);
        float sinTheta1 = cast(float) Math.sin(theta1);
        glBegin(GL_QUAD_STRIP);
        float phi = 0.0f;
        for (int j = nsides; j >= 0; j--) {
            phi += sideDelta;
            float cosPhi = cast(float) Math.cos(phi);
            float sinPhi = cast(float) Math.sin(phi);
            float dist = R + r * cosPhi;
            glNormal3f(cosTheta1 * cosPhi, -sinTheta1 * cosPhi, sinPhi);
            glVertex3f(cosTheta1 * dist, -sinTheta1 * dist, r * sinPhi);
            glNormal3f(cosTheta * cosPhi, -sinTheta * cosPhi, sinPhi);
            glVertex3f(cosTheta * dist, -sinTheta * dist, r * sinPhi);
        }
        glEnd();
        theta = theta1;
        cosTheta = cosTheta1;
        sinTheta = sinTheta1;
    }
}

void main()
{
    DerelictGL.load();
    DerelictGLU.load();

    Display display = new Display();
    Shell shell = new Shell(display);
    shell.setLayout(new FillLayout());
    Composite comp = new Composite(shell, DWT.NONE);
    comp.setLayout(new FillLayout());
    GLData data = new GLData ();
    data.doubleBuffer = true;
    GLCanvas canvas = new GLCanvas(comp, DWT.NONE, data);

    canvas.setCurrent();

    canvas.addListener(DWT.Resize, new class() Listener {
        public void handleEvent(Event event) {
            Rectangle bounds = canvas.getBounds();
            float fAspect = cast(float) bounds.width / cast(float) bounds.height;

            glViewport(0, 0, bounds.width, bounds.height);
            glMatrixMode(GL_PROJECTION);
            glLoadIdentity();
            gluPerspective(45.0f, fAspect, 0.5f, 400.0f);
            glMatrixMode(GL_MODELVIEW);
            glLoadIdentity();
        }
    });

    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glColor3f(1.0f, 0.0f, 0.0f);
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
    glClearDepth(1.0);
    glLineWidth(2);
    glEnable(GL_DEPTH_TEST);

    shell.setText("DWT/DerelictGL Example");
    shell.setSize(640, 480);
    shell.open();

    display.asyncExec(new class() Runnable {
        int rot = 0;
        public void run() {
            if (!canvas.isDisposed()) {
                canvas.setCurrent();

                glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
                glClearColor(.3f, .5f, .8f, 1.0f);
                glLoadIdentity();
                glTranslatef(0.0f, 0.0f, -10.0f);
                float frot = rot;
                glRotatef(0.15f * rot, 2.0f * frot, 10.0f * frot, 1.0f);
                glRotatef(0.3f * rot, 3.0f * frot, 1.0f * frot, 1.0f);
                rot++;
                glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
                glColor3f(0.9f, 0.9f, 0.9f);
                drawTorus(1, 1.9f + (cast(float) Math.sin((0.004f * frot))), 15, 15);
                canvas.swapBuffers();
                display.asyncExec(this);
            }
        }
    });

    while (!shell.isDisposed()) {
        if (!display.readAndDispatch())
            display.sleep();
    }
    display.dispose();
}

