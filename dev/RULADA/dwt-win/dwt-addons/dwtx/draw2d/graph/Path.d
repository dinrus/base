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
module dwtx.draw2d.graph.Path;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.PositionConstants;
import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.PointList;
import dwtx.draw2d.graph.Segment;
import dwtx.draw2d.graph.Vertex;
import dwtx.draw2d.graph.Obstacle;

/**
 * A Path representation for the ShortestPathRouting. A Path has a start and end point
 * and may have bendpoints. The output of a path is accessed via the method
 * <code>getPoints()</code>.
 *
 * This class is for internal use only.
 * @author Whitney Sorenson
 * @since 3.0
 */
public class Path {

/**
 * A Stack of segments.
 */
private static class SegmentStack : ArrayList {

Segment pop() {
    return cast(Segment)remove(size() - 1);
}

Obstacle popObstacle() {
    return cast(Obstacle)remove(size() - 1);
}

void push(Object obj) {
    add(obj);
}

}

private static bool initStaticCtor_done = false;
private static Point CURRENT;
private static const double EPSILON = 1.04;
private static Point NEXT;
private static const double OVAL_CONSTANT = 1.13;

private static void initStaticCtor(){
    if( !initStaticCtor_done ){
        synchronized( Path.classinfo ){
            if( !initStaticCtor_done ){
                CURRENT = new Point();
                NEXT = new Point();
                initStaticCtor_done = true;
            }
        }
    }
    assert( CURRENT );
    assert( NEXT );
}

/**
 * The bendpoint constraints.  The path must go through these bendpoints.
 */
PointList bendpoints;
/**
 * An arbitrary data field which can be used to map a Path back to some client object.
 */
public Object data;
List excludedObstacles;
List grownSegments;
/**
 * this field is for internal use only.  It is true whenever a property has been changed
 * which requires the solver to resolve this path.
 */
public bool isDirty = true;

bool isInverted = false;
bool isMarked = false;
PointList points;

/**
 * The previous cost ratio of the path.  The cost ratio is the actual path length divided
 * by the length from the start to the end.
 */
private double prevCostRatio;
List segments;

private SegmentStack stack;
Vertex start, end;
private Path subPath;
double threshold;
Set visibleObstacles;
Set visibleVertices;

/**
 * Constructs a new path.
 * @since 3.0
 */
public this() {
    initStaticCtor();
    segments = new ArrayList();
    grownSegments = new ArrayList();
    points = new PointList();
    visibleVertices = new HashSet();
    stack = new SegmentStack();
    visibleObstacles = new HashSet();
    excludedObstacles = new ArrayList();
}

/**
 * Constructs a new path with the given data.
 * @since 3.0
 * @param data an arbitrary data field
 */
public this(Object data) {
    this();
    this.data = data;
}

/**
 * Constructs a new path with the given data, start and end point.
 *
 * @param start the start point for this path
 * @param end the end point for this path
 */
public this(Point start, Point end) {
    this(new Vertex(start, null), new Vertex(end, null));
}

/**
 * Creates a path between the given vertices.
 *
 * @param start start vertex
 * @param end end vertex
 */
this(Vertex start, Vertex end) {
    this();
    this.start = start;
    this.end = end;
}

/**
 * Attempts to add all segments between the given obstacles to the visibility graph.
 * @param source the source obstacle
 * @param target the target obstacle
 */
private void addAllSegmentsBetween(Obstacle source, Obstacle target) {
    addConnectingSegment(new Segment(source.bottomLeft, target.bottomLeft),
            source, target, false, false);
    addConnectingSegment(new Segment(source.bottomRight, target.bottomRight),
            source, target, true, true);
    addConnectingSegment(new Segment(source.topLeft, target.topLeft),
            source, target, true, true);
    addConnectingSegment(new Segment(source.topRight, target.topRight),
            source, target, false, false);

    if (source.bottom() is target.bottom()) {
        addConnectingSegment(new Segment(source.bottomLeft, target.bottomRight),
                source, target, false, true);
        addConnectingSegment(new Segment(source.bottomRight, target.bottomLeft),
                source, target, true, false);
    }
    if (source.y is target.y) {
        addConnectingSegment(new Segment(source.topLeft, target.topRight),
                source, target, true, false);
        addConnectingSegment(new Segment(source.topRight, target.topLeft),
                source, target, false, true);
    }
    if (source.x is target.x) {
        addConnectingSegment(new Segment(source.bottomLeft, target.topLeft),
                source, target, false, true);
        addConnectingSegment(new Segment(source.topLeft, target.bottomLeft),
                source, target, true, false);
    }
    if (source.right() is target.right()) {
        addConnectingSegment(new Segment(source.bottomRight, target.topRight),
                source, target, true, false);
        addConnectingSegment(new Segment(source.topRight, target.bottomRight),
                source, target, false, true);
    }
}

/**
 * Attempts to add a segment between the given obstacles to the visibility graph. This
 * method is specifically written for the case where the two obstacles intersect and contains
 * a bool as to whether to check the diagonal that includes the top right point of the
 * other obstacle.
 *
 * @param segment the segment to check
 * @param o1 the first obstacle
 * @param o2 the second obstacle
 * @param checkTopRight1 whether or not to check the diagonal containing top right point
 */
private void addConnectingSegment(Segment segment, Obstacle o1, Obstacle o2,
        bool checkTopRight1, bool checkTopRight2) {
    if (threshold !is 0
            && (segment.end.getDistance(end) + segment.end.getDistance(start) > threshold
                || segment.start.getDistance(end) + segment.start.getDistance(start) > threshold))
        return;

    if (o2.containsProper(segment.start) || o1.containsProper(segment.end))
        return;

    if (checkTopRight1 && segment.intersects(o1.x, o1.bottom() - 1, o1.right() - 1, o1.y))
        return;
    if (checkTopRight2 && segment.intersects(o2.x, o2.bottom() - 1, o2.right() - 1, o2.y))
        return;
    if (!checkTopRight1 && segment.intersects(o1.x, o1.y, o1.right() - 1, o1.bottom() - 1))
        return;
    if (!checkTopRight2 && segment.intersects(o2.x, o2.y, o2.right() - 1, o2.bottom() - 1))
        return;

    stack.push(o1);
    stack.push(o2);
    stack.push(segment);
}

/**
 * Adds an obstacle to the visibility graph and generates new segments
 * @param newObs the new obstacle, should not be in the graph already
 */
private void addObstacle(Obstacle newObs) {
    visibleObstacles.add(newObs);
    Iterator oItr = (new HashSet(visibleObstacles)).iterator();
    while (oItr.hasNext()) {
        Obstacle currObs = cast(Obstacle)oItr.next();
        if (newObs !is currObs)
            addSegmentsFor(newObs, currObs);
    }
    addPerimiterSegments(newObs);
    addSegmentsFor(start, newObs);
    addSegmentsFor(end, newObs);
}

/**
 * Adds the segments along the perimiter of an obstacle to the visiblity graph queue.
 * @param obs the obstacle
 */
private void addPerimiterSegments(Obstacle obs) {
    Segment seg = new Segment(obs.topLeft, obs.topRight);
    stack.push(obs);
    stack.push(null);
    stack.push(seg);
    seg = new Segment(obs.topRight, obs.bottomRight);
    stack.push(obs);
    stack.push(null);
    stack.push(seg);
    seg = new Segment(obs.bottomRight, obs.bottomLeft);
    stack.push(obs);
    stack.push(null);
    stack.push(seg);
    seg = new Segment(obs.bottomLeft, obs.topLeft);
    stack.push(obs);
    stack.push(null);
    stack.push(seg);
}

/**
 * Attempts to add a segment to the visibility graph.
 * First checks to see if the segment is outside the threshold oval. Then it compares the segment
 * against all obstacles. If it is clean, the segment is finally added to the graph.
 *
 * @param segment the segment
 * @param exclude1 an obstacle to exclude from the search
 * @param exclude2 another obstacle to exclude from the search
 * @param allObstacles the list of all obstacles
 */
private void addSegment(Segment segment, Obstacle exclude1, Obstacle exclude2, List allObstacles) {
    if (threshold !is 0
            && (segment.end.getDistance(end) + segment.end.getDistance(start) > threshold
                || segment.start.getDistance(end) + segment.start.getDistance(start) > threshold))
        return;

    for (int i = 0; i < allObstacles.size(); i++) {
        Obstacle obs = cast(Obstacle)allObstacles.get(i);

        if (obs is exclude1 || obs is exclude2 || obs.exclude)
            continue;

        if (segment.intersects(obs.x, obs.y, obs.right() - 1, obs.bottom() - 1)
                || segment.intersects(obs.x, obs.bottom() - 1, obs.right() - 1, obs.y)
                || obs.containsProper(segment.start)
                || obs.containsProper(segment.end)) {
            if (!visibleObstacles.contains(obs))
                addObstacle(obs);
            return;
        }
    }

    linkVertices(segment);
}

/**
 * Adds the segments between the given obstacles.
 * @param source source obstacle
 * @param target target obstacle
 */
private void addSegmentsFor(Obstacle source, Obstacle target) {
    if (source.intersects(target))
        addAllSegmentsBetween(source, target);
    else if (target.bottom() - 1 < source.y)
        addSegmentsTargetAboveSource(source, target);
    else if (source.bottom() - 1 < target.y)
        addSegmentsTargetAboveSource(target, source);
    else if (target.right() - 1 < source.x)
        addSegmentsTargetBesideSource(source, target);
    else
        addSegmentsTargetBesideSource(target, source);
}

/**
 * Adds the segments between the given obstacles.
 * @param source source obstacle
 * @param target target obstacle
 */
private void addSegmentsFor(Vertex vertex, Obstacle obs) {
    Segment seg = null;
    Segment seg2 = null;

    switch (obs.getPosition(vertex)) {
        case PositionConstants.SOUTH_WEST :
        case PositionConstants.NORTH_EAST :
            seg = new Segment(vertex, obs.topLeft);
            seg2 = new Segment(vertex, obs.bottomRight);
            break;
        case PositionConstants.SOUTH_EAST :
        case PositionConstants.NORTH_WEST :
            seg = new Segment(vertex, obs.topRight);
            seg2 = new Segment(vertex, obs.bottomLeft);
            break;
        case PositionConstants.NORTH :
            seg = new Segment(vertex, obs.topLeft);
            seg2 = new Segment(vertex, obs.topRight);
            break;
        case PositionConstants.EAST :
            seg = new Segment(vertex, obs.bottomRight);
            seg2 = new Segment(vertex, obs.topRight);
            break;
        case PositionConstants.SOUTH :
            seg = new Segment(vertex, obs.bottomRight);
            seg2 = new Segment(vertex, obs.bottomLeft);
            break;
        case PositionConstants.WEST :
            seg = new Segment(vertex, obs.topLeft);
            seg2 = new Segment(vertex, obs.bottomLeft);
            break;
        default:
            if (vertex.x is obs.x) {
                seg = new Segment(vertex, obs.topLeft);
                seg2 = new Segment(vertex, obs.bottomLeft);
            } else if (vertex.y is obs.y) {
                seg = new Segment(vertex, obs.topLeft);
                seg2 = new Segment(vertex, obs.topRight);
            } else if (vertex.y is obs.bottom() - 1) {
                seg = new Segment(vertex, obs.bottomLeft);
                seg2 = new Segment(vertex, obs.bottomRight);
            } else if (vertex.x is obs.right() - 1) {
                seg = new Segment(vertex, obs.topRight);
                seg2 = new Segment(vertex, obs.bottomRight);
            } else {
                throw new RuntimeException("Unexpected vertex conditions"); //$NON-NLS-1$
            }
    }

    stack.push(obs);
    stack.push(null);
    stack.push(seg);
    stack.push(obs);
    stack.push(null);
    stack.push(seg2);
}

private void addSegmentsTargetAboveSource(Obstacle source, Obstacle target) {
    //target located above source
    Segment seg = null;
    Segment seg2 = null;
    if (target.x > source.x) {
        seg = new Segment(source.topLeft, target.topLeft);
        if (target.x < source.right() - 1)
            seg2 = new Segment(source.topRight, target.bottomLeft);
        else
            seg2 = new Segment(source.bottomRight, target.topLeft);
    } else if (source.x is target.x) {
        seg = new Segment(source.topLeft, target.bottomLeft);
        seg2 = new Segment(source.topRight, target.bottomLeft);
    } else {
        seg = new Segment(source.bottomLeft, target.bottomLeft);
        seg2 = new Segment(source.topRight, target.bottomLeft);
    }

    stack.push(source);
    stack.push(target);
    stack.push(seg);
    stack.push(source);
    stack.push(target);
    stack.push(seg2);
    seg = null;
    seg2 = null;

    if (target.right() < source.right()) {
        seg = new Segment(source.topRight, target.topRight);
        if (target.right() - 1 > source.x)
            seg2 = new Segment(source.topLeft, target.bottomRight);
        else
            seg2 = new Segment(source.bottomLeft, target.topRight);
    } else if (source.right() is target.right()) {
        seg = new Segment(source.topRight, target.bottomRight);
        seg2 = new Segment(source.topLeft, target.bottomRight);
    } else {
        seg = new Segment(source.bottomRight, target.bottomRight);
        seg2 = new Segment(source.topLeft, target.bottomRight);
    }

    stack.push(source);
    stack.push(target);
    stack.push(seg);
    stack.push(source);
    stack.push(target);
    stack.push(seg2);
}

private void addSegmentsTargetBesideSource(Obstacle source, Obstacle target) {
    //target located above source
    Segment seg = null;
    Segment seg2 = null;
    if (target.y > source.y) {
        seg = new Segment(source.topLeft, target.topLeft);
        if (target.y < source.bottom() - 1)
            seg2 = new Segment(source.bottomLeft, target.topRight);
        else
            seg2 = new Segment(source.bottomRight, target.topLeft);
    } else if (source.y is target.y) {
        //degenerate case
        seg = new Segment(source.topLeft, target.topRight);
        seg2 = new Segment(source.bottomLeft, target.topRight);
    } else {
        seg = new Segment(source.topRight, target.topRight);
        seg2 = new Segment(source.bottomLeft, target.topRight);
    }
    stack.push(source);
    stack.push(target);
    stack.push(seg);
    stack.push(source);
    stack.push(target);
    stack.push(seg2);
    seg = null;
    seg2 = null;

    if (target.bottom() < source.bottom()) {
        seg = new Segment(source.bottomLeft, target.bottomLeft);
        if (target.bottom() - 1 > source.y)
            seg2 = new Segment(source.topLeft, target.bottomRight);
        else
            seg2 = new Segment(source.topRight, target.bottomLeft);
    } else if (source.bottom() is target.bottom()) {
        seg = new Segment(source.bottomLeft, target.bottomRight);
        seg2 = new Segment(source.topLeft, target.bottomRight);
    } else {
        seg = new Segment(source.bottomRight, target.bottomRight);
        seg2 = new Segment(source.topLeft, target.bottomRight);
    }
    stack.push(source);
    stack.push(target);
    stack.push(seg);
    stack.push(source);
    stack.push(target);
    stack.push(seg2);
}

/**
 *
 */
void cleanup() {
    //segments.clear();
    visibleVertices.clear();
}

/**
 * Begins the creation of the visibility graph with the first segment
 * @param allObstacles list of all obstacles
 */
private void createVisibilityGraph(List allObstacles) {
    stack.push(null);
    stack.push(null);
    stack.push(new Segment(start, end));

    while (!stack.isEmpty())
        addSegment(stack.pop(), stack.popObstacle(), stack.popObstacle(), allObstacles);
}

/**
 * Once the visibility graph is constructed, this is called to label the graph and
 * determine the shortest path. Returns false if no path can be found.
 *
 * @return true if a path can be found.
 */
private bool determineShortestPath() {
    if (!labelGraph())
        return false;
    Vertex vertex = end;
    prevCostRatio = end.cost / start.getDistance(end);

    Vertex nextVertex;
    while (!vertex.opEquals(start)) {
        nextVertex = vertex.label;
        if (nextVertex is null)
            return false;
        Segment s = new Segment(nextVertex, vertex);
        segments.add(s);
        vertex = nextVertex;
    }

    Collections.reverse(segments);
    return true;
}

/**
 * Resets all necessary fields for a solve.
 */
void fullReset() {
    visibleVertices.clear();
    segments.clear();
    if (prevCostRatio is 0) {
        double distance = start.getDistance(end);
        threshold = distance * OVAL_CONSTANT;
    } else
        threshold = prevCostRatio * EPSILON * start.getDistance(end);
    visibleObstacles.clear();
    resetPartial();
}

/**
 * Creates the visibility graph and returns whether or not a shortest path could be
 * determined.
 *
 * @param allObstacles the list of all obstacles
 * @return true if a shortest path was found
 */
bool generateShortestPath(List allObstacles) {
    createVisibilityGraph(allObstacles);

    if (visibleVertices.size() is 0)
        return false;

    return determineShortestPath();
}

/**
 * Returns the list of constrained points through which this path must pass or
 * <code>null</code>.
 * @see #setBendPoints(PointList)
 * @return list of bend points
 */
public PointList getBendPoints() {
    return bendpoints;
}

/**
 * Returns the end point for this path
 * @return end point for this path
 */
public Point getEndPoint() {
    return end;
}

/**
 * Returns the solution to this path.
 *
 * @return the points for this path.
 */
public PointList getPoints() {
    return points;
}

/**
 * Returns the start point for this path
 * @return start point for this path
 */
public Point getStartPoint() {
    return start;
}

/**
 * Returns a subpath for this path at the given segment
 *
 * @param currentSegment the segment at which the subpath should be created
 * @return the new path
 */
Path getSubPath(Segment currentSegment) {
    // ready new path
    Path newPath = new Path(currentSegment.start, end);
    newPath.grownSegments = new ArrayList(grownSegments.subList(
            grownSegments.indexOf(currentSegment),
            grownSegments.size()));

    // fix old path
    grownSegments = new ArrayList(grownSegments.subList(
            0, grownSegments.indexOf(currentSegment) + 1));
    end = currentSegment.end;

    subPath = newPath;
    return newPath;
}

/**
 * Resets the vertices that this path has traveled prior to this segment. This is called
 * when the path has become inverted and needs to rectify any labeling mistakes it made
 * before it knew it was inverted.
 * @param currentSegment the segment at which the path found it was inverted
 */
void invertPriorVertices(Segment currentSegment) {
    int stop = grownSegments.indexOf(currentSegment);
    for (int i = 0; i < stop; i++) {
        Vertex vertex = (cast(Segment)grownSegments.get(i)).end;
        if (vertex.type is Vertex.INNIE)
            vertex.type = Vertex.OUTIE;
        else
            vertex.type = Vertex.INNIE;
    }
}

/**
 * Returns true if this obstacle is in the visibility graph
 * @param obs the obstacle
 * @return true if obstacle is in the visibility graph
 */
bool isObstacleVisible(Obstacle obs) {
    return visibleObstacles.contains(obs);
}

/**
 * Labels the visibility graph to assist in finding the shortest path
 * @return false if there was a gap in the visibility graph
 */
private bool labelGraph() {
    int numPermanentNodes = 1;
    Vertex vertex = start;
    Vertex neighborVertex = null;
    vertex.isPermanent = true;
    double newCost;
    while (numPermanentNodes !is visibleVertices.size()) {
        List neighbors = vertex.neighbors;
        if (neighbors is null)
            return false;
        // label neighbors if they have a new shortest path
        for (int i = 0; i < neighbors.size(); i++) {
            neighborVertex = cast(Vertex)neighbors.get(i);
            if (!neighborVertex.isPermanent) {
                newCost = vertex.cost + vertex.getDistance(neighborVertex);
                if (neighborVertex.label is null) {
                    neighborVertex.label = vertex;
                    neighborVertex.cost = newCost;
                } else if (neighborVertex.cost > newCost) {
                    neighborVertex.label = vertex;
                    neighborVertex.cost = newCost;
                }
            }
        }
        // find the next none-permanent, labeled vertex with smallest cost
        double smallestCost = 0;
        Vertex tempVertex = null;
        Iterator v = visibleVertices.iterator();
        while (v.hasNext()) {
            tempVertex = cast(Vertex)v.next();
            if (!tempVertex.isPermanent && tempVertex.label !is null
                    && (tempVertex.cost < smallestCost || smallestCost is 0)) {
                smallestCost = tempVertex.cost;
                vertex = tempVertex;
            }
        }
        // set the new vertex to permanent.
        vertex.isPermanent = true;
        numPermanentNodes++;
    }
    return true;
}

/**
 * Links two vertices together in the visibility graph
 * @param segment the segment to add
 */
private void linkVertices(Segment segment) {
    if (segment.start.neighbors is null)
        segment.start.neighbors = new ArrayList();
    if (segment.end.neighbors is null)
        segment.end.neighbors = new ArrayList();

    if (!segment.start.neighbors.contains(segment.end)) {
        segment.start.neighbors.add(segment.end);
        segment.end.neighbors.add(segment.start);
    }

    visibleVertices.add(segment.start);
    visibleVertices.add(segment.end);
}

/**
 * Called to reconnect a subpath back onto this path. Does a depth-first search to
 * reconnect all paths. Should be called after sorting.
 */
void reconnectSubPaths() {
    if (subPath !is null) {
        subPath.reconnectSubPaths();

        Segment changedSegment = cast(Segment)subPath.grownSegments.remove(0);
        Segment oldSegment = cast(Segment)grownSegments.get(grownSegments.size() - 1);

        oldSegment.end = changedSegment.end;
        grownSegments.addAll(subPath.grownSegments);

        subPath.points.removePoint(0);
        points.removePoint(points.size() - 1);
        points.addAll(subPath.points);

        visibleObstacles.addAll(subPath.visibleObstacles);

        end = subPath.end;
        subPath = null;
    }
}


/**
 * Refreshes the exclude field on the obstacles in the list. Excludes all obstacles
 * that contain the start or end point for this path.
 * @param allObstacles list of all obstacles
 */
void refreshExcludedObstacles(List allObstacles) {
    excludedObstacles.clear();

    for (int i = 0; i < allObstacles.size(); i++) {
        Obstacle o = cast(Obstacle)allObstacles.get(i);
        o.exclude = false;

        if (o.contains(start)) {
            if (o.containsProper(start))
                o.exclude = true;
            else {
                /*
                 * $TODO Check for corners.  If the path begins exactly at the corner of
                 * an obstacle, the exclude should also be true.
                 *
                 * Or, change segment intersection so that two segments that share an
                 * endpoint do not intersect.
                 */
            }
        }

        if (o.contains(end)) {
            if (o.containsProper(end))
                o.exclude = true;
            else {
                //check for corners.  See above statement.
            }
        }

        if (o.exclude && !excludedObstacles.contains(o))
            excludedObstacles.add(o);
    }
}

/**
 * Resets the fields for everything in the solve after the visibility graph steps.
 */
void resetPartial() {
    isMarked = false;
    isInverted = false;
    subPath = null;
    isDirty = false;
    grownSegments.clear();
    points.removeAllPoints();
}

/**
 * Sets the list of bend points to the given list and dirties the path.
 * @param bendPoints the list of bend points
 */
public void setBendPoints(PointList bendPoints) {
    this.bendpoints = bendPoints;
    isDirty = true;
}

/**
 * Sets the end point for this path to the given point.
 * @param end the new end point for this path
 */
public void setEndPoint(Point end) {
    if (end.opEquals(this.end))
        return;
    this.end = new Vertex(end, null);
    isDirty = true;
}

/**
 * Sets the start point for this path to the given point.
 * @param start the new start point for this path
 */
public void setStartPoint(Point start) {
    if (start.opEquals(this.start))
        return;
    this.start = new Vertex(start, null);
    isDirty = true;
}

/**
 * Returns <code>true</code> if the path is clean and intersects the given obstacle. Also
 * dirties the path in the process.
 * @since 3.0
 * @param obs the obstacle
 * @return <code>true</code> if a clean path touches the obstacle
 */
 bool testAndSet(Obstacle obs) {
    if (isDirty)
        return false;
    //This will never actually happen because obstacles are not stored by identity
    if (excludedObstacles.contains(obs))
        return false;

    Segment seg1 = new Segment(obs.topLeft, obs.bottomRight);
    Segment seg2 = new Segment(obs.topRight, obs.bottomLeft);

    for (int s = 0; s < points.size() - 1; s++) {
        points.getPoint(CURRENT, s);
        points.getPoint(NEXT, s + 1);

        if (seg1.intersects(CURRENT, NEXT) || seg2.intersects(CURRENT, NEXT)
                || obs.contains(CURRENT) || obs.contains(NEXT)) {
            isDirty = true;
            return true;
        }
    }
    return false;
}

}