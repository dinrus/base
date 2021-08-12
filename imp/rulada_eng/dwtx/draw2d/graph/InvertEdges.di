/*******************************************************************************
 * Copyright (c) 2003, 2005 IBM Corporation and others.
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
module dwtx.draw2d.graph.InvertEdges;

import dwt.dwthelper.utils;
import dwtx.draw2d.graph.GraphVisitor;
import dwtx.draw2d.graph.DirectedGraph;
import dwtx.draw2d.graph.Edge;

/**
 * Inverts any edges which are marked as backwards or "feedback" edges.
 *
 * @author Daniel Lee
 * @since 2.1.2
 */
class InvertEdges : GraphVisitor {

/**
 *
 * @see GraphVisitor#visit(dwtx.draw2d.graph.DirectedGraph)
 */
public void visit(DirectedGraph g) {
    for (int i = 0; i < g.edges.size(); i++) {
        Edge e = g.edges.getEdge(i);
        if (e.isFeedback)
            e.invert();
    }
}

}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-dwtx");
        } else version (DigitalMars) {
            pragma(link, "DD-dwtx");
        } else {
            pragma(link, "DO-dwtx");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-dwtx");
        } else version (DigitalMars) {
            pragma(link, "DD-dwtx");
        } else {
            pragma(link, "DO-dwtx");
        }
    }
}