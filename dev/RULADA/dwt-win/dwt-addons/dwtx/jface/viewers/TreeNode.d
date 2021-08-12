/*******************************************************************************
 * Copyright (c) 2005, 2007 IBM Corporation and others.
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

module dwtx.jface.viewers.TreeNode;

import dwtx.jface.util.Util;

import dwt.dwthelper.utils;

/**
 * A simple data structure that is useful for implemented tree models. This can
 * be returned by
 * {@link dwtx.jface.viewers.IStructuredContentProvider#getElements(Object)}.
 * It allows simple delegation of methods from
 * {@link dwtx.jface.viewers.ITreeContentProvider} such as
 * {@link dwtx.jface.viewers.ITreeContentProvider#getChildren(Object)},
 * {@link dwtx.jface.viewers.ITreeContentProvider#getParent(Object)} and
 * {@link dwtx.jface.viewers.ITreeContentProvider#hasChildren(Object)}
 *
 * @since 3.2
 */
public class TreeNode {

    /**
     * The array of child tree nodes for this tree node. If there are no
     * children, then this value may either by an empty array or
     * <code>null</code>. There should be no <code>null</code> children in
     * the array.
     */
    private TreeNode[] children;

    /**
     * The parent tree node for this tree node. This value may be
     * <code>null</code> if there is no parent.
     */
    private TreeNode parent;

    /**
     * The value contained in this node. This value may be anything.
     */
    protected Object value;

    /**
     * Constructs a new instance of <code>TreeNode</code>.
     *
     * @param value
     *            The value held by this node; may be anything.
     */
    public this(Object value) {
        this.value = value;
    }

    public override int opEquals(Object object) {
        if ( auto tn = cast(TreeNode)object ) {
            return Util.opEquals(this.value, tn.value);
        }

        return false;
    }

    /**
     * Returns the child nodes. Empty arrays are converted to <code>null</code>
     * before being returned.
     *
     * @return The child nodes; may be <code>null</code>, but never empty.
     *         There should be no <code>null</code> children in the array.
     */
    public TreeNode[] getChildren() {
        if (children !is null && children.length is 0) {
            return null;
        }
        return children;
    }

    /**
     * Returns the parent node.
     * 
     * @return The parent node; may be <code>null</code> if there are no
     *         parent nodes.
     */
    public TreeNode getParent() {
        return parent;
    }

    /**
     * Returns the value held by this node.
     * 
     * @return The value; may be anything.
     */
    public Object getValue() {
        return value;
    }

    /**
     * Returns whether the tree has any children.
     * 
     * @return <code>true</code> if its array of children is not
     *         <code>null</code> and is non-empty; <code>false</code>
     *         otherwise.
     */
    public bool hasChildren() {
        return children !is null && children.length > 0;
    }
    
    public override hash_t toHash() {
        return Util.toHash(value);
    }

    /**
     * Sets the children for this node.
     * 
     * @param children
     *            The child nodes; may be <code>null</code> or empty. There
     *            should be no <code>null</code> children in the array.
     */
    public void setChildren(TreeNode[] children) {
        this.children = children;
    }

    /**
     * Sets the parent for this node.
     * 
     * @param parent
     *            The parent node; may be <code>null</code>.
     */
    public void setParent(TreeNode parent) {
        this.parent = parent;
    }
}

