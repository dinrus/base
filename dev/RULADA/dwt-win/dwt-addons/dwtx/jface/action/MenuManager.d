/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Remy Chi Jian Suen <remy.suen@gmail.com> - Bug 12116 [Contributions] widgets: MenuManager.setImageDescriptor() method needed
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.action.MenuManager;

import dwtx.jface.action.ContributionManager;
import dwtx.jface.action.IMenuManager;
import dwtx.jface.action.IContributionManagerOverrides;
import dwtx.jface.action.IContributionManager;
import dwtx.jface.action.IMenuListener;
import dwtx.jface.action.IMenuListener2;
import dwtx.jface.action.IContributionItem;
import dwtx.jface.action.SubContributionItem;
import dwtx.jface.action.IAction;
import dwtx.jface.action.ExternalActionManager;


import dwt.DWT;
import dwt.events.MenuAdapter;
import dwt.events.MenuEvent;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.CoolBar;
import dwt.widgets.Decorations;
import dwt.widgets.Item;
import dwt.widgets.Menu;
import dwt.widgets.MenuItem;
import dwt.widgets.Shell;
import dwt.widgets.ToolBar;
import dwtx.core.runtime.ListenerList;
import dwtx.jface.resource.ImageDescriptor;
import dwtx.jface.resource.JFaceResources;
import dwtx.jface.resource.LocalResourceManager;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;


/**
 * A menu manager is a contribution manager which realizes itself and its items
 * in a menu control; either as a menu bar, a sub-menu, or a context menu.
 * <p>
 * This class may be instantiated; it may also be subclassed.
 * </p>
 */
public class MenuManager : ContributionManager, IMenuManager {

    public bool isDirty(){
        return super.isDirty();
    }

    /**
     * The menu id.
     */
    private String id;

    /**
     * List of registered menu listeners (element type: <code>IMenuListener</code>).
     */
    private ListenerList listeners;

    /**
     * The menu control; <code>null</code> before
     * creation and after disposal.
     */
    private Menu menu = null;

    /**
     * The menu item widget; <code>null</code> before
     * creation and after disposal. This field is used
     * when this menu manager is a sub-menu.
     */
    private MenuItem menuItem;

    /**
     * The text for a sub-menu.
     */
    private String menuText;

    /**
     * The image for a sub-menu.
     */
    private ImageDescriptor image;

    /**
     * A resource manager to remember all of the images that have been used by this menu.
     */
    private LocalResourceManager imageManager;

    /**
     * The overrides for items of this manager
     */
    private IContributionManagerOverrides overrides;

    /**
     * The parent contribution manager.
     */
    private IContributionManager parent;

    /**
     * Indicates whether <code>removeAll</code> should be
     * called just before the menu is displayed.
     */
    private bool removeAllWhenShown = false;

    /**
     * Indicates this item is visible in its manager; <code>true</code>
     * by default.
     * @since 3.3
     */
    protected bool visible = true;

    /**
     * allows a submenu to display a shortcut key. This is often used with the
     * QuickMenu command or action which can pop up a menu using the shortcut.
     */
    private String definitionId = null;

    /**
     * Creates a menu manager.  The text and id are <code>null</code>.
     * Typically used for creating a context menu, where it doesn't need to be referred to by id.
     */
    public this() {
        this(null, null, null);
    }

    /**
     * Creates a menu manager with the given text. The id of the menu
     * is <code>null</code>.
     * Typically used for creating a sub-menu, where it doesn't need to be referred to by id.
     *
     * @param text the text for the menu, or <code>null</code> if none
     */
    public this(String text) {
        this(text, null, null);
    }

    /**
     * Creates a menu manager with the given text and id.
     * Typically used for creating a sub-menu, where it needs to be referred to by id.
     *
     * @param text the text for the menu, or <code>null</code> if none
     * @param id the menu id, or <code>null</code> if it is to have no id
     */
    public this(String text, String id) {
        this(text, null, id);
    }

    /**
     * Creates a menu manager with the given text, image, and id.
     * Typically used for creating a sub-menu, where it needs to be referred to by id.
     *
     * @param text the text for the menu, or <code>null</code> if none
     * @param image the image for the menu, or <code>null</code> if none
     * @param id the menu id, or <code>null</code> if it is to have no id
     * @since 3.4
     */
    public this(String text, ImageDescriptor image, String id) {
        listeners = new ListenerList();
        this.menuText = text;
        this.image = image;
        this.id = id;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IMenuManager#addMenuListener(dwtx.jface.action.IMenuListener)
     */
    public void addMenuListener(IMenuListener listener) {
        listeners.add(cast(Object)listener);
    }

    /**
     * Creates and returns an DWT context menu control for this menu,
     * and installs all registered contributions.
     * Does not create a new control if one already exists.
     * <p>
     * Note that the menu is not expected to be dynamic.
     * </p>
     *
     * @param parent the parent control
     * @return the menu control
     */
    public Menu createContextMenu(Control parent) {
        if (!menuExist()) {
            menu = new Menu(parent);
            initializeMenu();
        }
        return menu;
    }

    /**
     * Creates and returns an DWT menu bar control for this menu,
     * for use in the given <code>Decorations</code>, and installs all registered
     * contributions. Does not create a new control if one already exists.
     *
     * @param parent the parent decorations
     * @return the menu control
     * @since 2.1
     */
    public Menu createMenuBar(Decorations parent) {
        if (!menuExist()) {
            menu = new Menu(parent, DWT.BAR);
            update(false);
        }
        return menu;
    }

    /**
     * Creates and returns an DWT menu bar control for this menu, for use in the
     * given <code>Shell</code>, and installs all registered contributions. Does not
     * create a new control if one already exists. This implementation simply calls
     * the <code>createMenuBar(Decorations)</code> method
     *
     * @param parent the parent decorations
     * @return the menu control
     * @deprecated use <code>createMenuBar(Decorations)</code> instead.
     */
    public Menu createMenuBar(Shell parent) {
        return createMenuBar(cast(Decorations) parent);
    }

    /**
     * Disposes of this menu manager and frees all allocated DWT resources.
     * Notifies all contribution items of the dispose. Note that this method does
     * not clean up references between this menu manager and its associated
     * contribution items. Use <code>removeAll</code> for that purpose.
     */
    public void dispose() {
        if (menuExist()) {
            menu.dispose();
        }
        menu = null;

        if (menuItem !is null) {
            menuItem.dispose();
            menuItem = null;
        }

        disposeOldImages();

        IContributionItem[] items = getItems();
        for (int i = 0; i < items.length; i++) {
            items[i].dispose();
        }

        markDirty();
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IContributionItem#fill(dwt.widgets.Composite)
     */
    public void fill(Composite parent) {
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IContributionItem#fill(dwt.widgets.CoolBar, int)
     */
    public void fill(CoolBar parent, int index) {
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IContributionItem#fill(dwt.widgets.Menu, int)
     */
    public void fill(Menu parent, int index) {
        if (menuItem is null || menuItem.isDisposed()) {
            if (index >= 0) {
                menuItem = new MenuItem(parent, DWT.CASCADE, index);
            } else {
                menuItem = new MenuItem(parent, DWT.CASCADE);
            }

            menuItem.setText(getMenuText());

            if (image !is null) {
                LocalResourceManager localManager = new LocalResourceManager(
                        JFaceResources.getResources());
                menuItem.setImage(localManager.createImage(image));
                disposeOldImages();
                imageManager = localManager;
            }

            if (!menuExist()) {
                menu = new Menu(parent);
            }

            menuItem.setMenu(menu);

            initializeMenu();

            setDirty(true);
        }
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IContributionItem#fill(dwt.widgets.ToolBar, int)
     */
    public void fill(ToolBar parent, int index) {
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IMenuManager#findMenuUsingPath(java.lang.String)
     */
    public IMenuManager findMenuUsingPath(String path) {
        IContributionItem item = findUsingPath(path);
        if (auto mm = cast(IMenuManager)item ) {
            return mm;
        }
        return null;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IMenuManager#findUsingPath(java.lang.String)
     */
    public IContributionItem findUsingPath(String path) {
        String id = path;
        String rest = null;
        int separator = dwt.dwthelper.utils.indexOf( path, '/');
        if (separator !is -1) {
            id = path.substring(0, separator);
            rest = path.substring(separator + 1);
        } else {
            return super.find(path);
        }

        IContributionItem item = super.find(id);
        if (auto manager = cast(IMenuManager)item ) {
            return manager.findUsingPath(rest);
        }
        return null;
    }

    /**
     * Notifies any menu listeners that a menu is about to show.
     * Only listeners registered at the time this method is called are notified.
     *
     * @param manager the menu manager
     *
     * @see IMenuListener#menuAboutToShow
     */
    private void fireAboutToShow(IMenuManager manager) {
        Object[] listeners = this.listeners.getListeners();
        for (int i = 0; i < listeners.length; ++i) {
            (cast(IMenuListener) listeners[i]).menuAboutToShow(manager);
        }
    }

    /**
     * Notifies any menu listeners that a menu is about to hide.
     * Only listeners registered at the time this method is called are notified.
     *
     * @param manager the menu manager
     *
     */
    private void fireAboutToHide(IMenuManager manager) {
        final Object[] listeners = this.listeners.getListeners();
        for (int i = 0; i < listeners.length; ++i) {
            final Object listener = listeners[i];
            if (auto listener2 = cast(IMenuListener2)listener) {
                listener2.menuAboutToHide(manager);
            }
        }
    }

    /**
     * Returns the menu id. The menu id is used when creating a contribution
     * item for adding this menu as a sub menu of another.
     *
     * @return the menu id
     */
    public String getId() {
        return id;
    }

    /**
     * Returns the DWT menu control for this menu manager.
     *
     * @return the menu control
     */
    public Menu getMenu() {
        return menu;
    }

    /**
     * Returns the text shown in the menu, potentially with a shortcut
     * appended.
     *
     * @return the menu text
     */
    public String getMenuText() {
        if (definitionId is null) {
            return menuText;
        }
        ExternalActionManager.ICallback callback = ExternalActionManager
                .getInstance().getCallback();
        if (callback !is null) {
            String shortCut = callback.getAcceleratorText(definitionId);
            if (shortCut is null) {
                return menuText;
            }
            return menuText ~ "\t" ~ shortCut; //$NON-NLS-1$
        }
        return menuText;
    }

    /**
     * Returns the image for this menu as an image descriptor.
     *
     * @return the image, or <code>null</code> if this menu has no image
     * @since 3.4
     */
    public ImageDescriptor getImageDescriptor() {
        return image;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IContributionManager#getOverrides()
     */
    public override IContributionManagerOverrides getOverrides() {
        if (overrides is null) {
            if (parent is null) {
                overrides = new class IContributionManagerOverrides {
                    public Integer getAccelerator(IContributionItem item) {
                        return null;
                    }

                    public String getAcceleratorText(IContributionItem item) {
                        return null;
                    }

                    public Boolean getEnabled(IContributionItem item) {
                        return null;
                    }

                    public String getText(IContributionItem item) {
                        return null;
                    }
                };
            } else {
                overrides = parent.getOverrides();
            }
            super.setOverrides(overrides);
        }
        return overrides;
    }

    /**
     * Returns the parent contribution manager of this manger.
     *
     * @return the parent contribution manager
     * @since 2.0
     */
    public IContributionManager getParent() {
        return parent;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IMenuManager#getRemoveAllWhenShown()
     */
    public bool getRemoveAllWhenShown() {
        return removeAllWhenShown;
    }

    /**
     * Notifies all listeners that this menu is about to appear.
     */
    private void handleAboutToShow() {
        if (removeAllWhenShown) {
            removeAll();
        }
        fireAboutToShow(this);
        update(false, false);
    }

    /**
     * Notifies all listeners that this menu is about to disappear.
     */
    private void handleAboutToHide() {
        fireAboutToHide(this);
    }

    /**
     * Initializes the menu control.
     */
    private void initializeMenu() {
        menu.addMenuListener(new class MenuAdapter {
            public void menuHidden(MenuEvent e) {
                //          ApplicationWindow.resetDescription(e.widget);
                handleAboutToHide();
            }

            public void menuShown(MenuEvent e) {
                handleAboutToShow();
            }
        });
        // Don't do an update(true) here, in case menu is never opened.
        // Always do it lazily in handleAboutToShow().
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IContributionItem#isDynamic()
     */
    public bool isDynamic() {
        return false;
    }

    /**
     * Returns whether this menu should be enabled or not.
     * Used to enable the menu item containing this menu when it is realized as a sub-menu.
     * <p>
     * The default implementation of this framework method
     * returns <code>true</code>. Subclasses may reimplement.
     * </p>
     *
     * @return <code>true</code> if enabled, and
     *   <code>false</code> if disabled
     */
    public bool isEnabled() {
        return true;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IContributionItem#isGroupMarker()
     */
    public bool isGroupMarker() {
        return false;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IContributionItem#isSeparator()
     */
    public bool isSeparator() {
        return false;
    }

    /**
     * Check if the contribution is item is a subsitute for ourselves
     *
     * @param item the contribution item
     * @return <code>true</code> if give item is a substitution for ourselves
     * @deprecated this method is no longer a part of the
     *   {@link dwtx.jface.action.IContributionItem} API.
     */
    public bool isSubstituteFor(IContributionItem item) {
        return this.opEquals(cast(Object)item) !is 0;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IContributionItem#isVisible()
     */
    public bool isVisible() {
        if (!visible) {
            return false; // short circuit calculations in this case
        }

        if (removeAllWhenShown) {
            // we have no way of knowing if the menu has children
            return true;
        }

        // menus aren't visible if all of its children are invisible (or only contains visible separators).
        IContributionItem[] childItems = getItems();
        bool visibleChildren = false;
        for (int j = 0; j < childItems.length; j++) {
            if (childItems[j].isVisible() && !childItems[j].isSeparator()) {
                visibleChildren = true;
                break;
            }
        }

        return visibleChildren;
    }


    /**
     * The <code>MenuManager</code> implementation of this <code>ContributionManager</code> method
     * also propagates the dirty flag up the parent chain.
     *
     * @since 3.1
     */
    public override void markDirty() {
        super.markDirty();
        // Can't optimize by short-circuiting when the first dirty manager is encountered,
        // since non-visible children are not even processed.
        // That is, it's possible to have a dirty sub-menu under a non-dirty parent menu
        // even after the parent menu has been updated.
        // If items are added/removed in the sub-menu, we still need to propagate the dirty flag up,
        // even if the sub-menu is already dirty, since the result of isVisible() may change
        // due to the added/removed items.
        IContributionManager parent = getParent();
        if (parent !is null) {
            parent.markDirty();
        }
    }

    /**
     * Returns whether the menu control is created
     * and not disposed.
     *
     * @return <code>true</code> if the control is created
     *  and not disposed, <code>false</code> otherwise
     * @since 3.4 protected, was added in 3.1 as private method
     */
    protected bool menuExist() {
        return menu !is null && !menu.isDisposed();
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IMenuManager#removeMenuListener(dwtx.jface.action.IMenuListener)
     */
    public void removeMenuListener(IMenuListener listener) {
        listeners.remove(cast(Object)listener);
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IContributionItem#saveWidgetState()
     */
    public void saveWidgetState() {
    }

    /**
     * Sets the overrides for this contribution manager
     *
     * @param newOverrides the overrides for the items of this manager
     * @since 2.0
     */
    public override void setOverrides(IContributionManagerOverrides newOverrides) {
        overrides = newOverrides;
        super.setOverrides(overrides);
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IContributionItem#setParent(dwtx.jface.action.IContributionManager)
     */
    public void setParent(IContributionManager manager) {
        parent = manager;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IMenuManager#setRemoveAllWhenShown(bool)
     */
    public void setRemoveAllWhenShown(bool removeAll) {
        this.removeAllWhenShown = removeAll;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IContributionItem#setVisible(bool)
     */
    public void setVisible(bool visible) {
        this.visible = visible;
    }

    /**
     * Sets the action definition id of this action. This simply allows the menu
     * item text to include a short cut if available.  It can be used to
     * notify a user of a key combination that will open a quick menu.
     *
     * @param definitionId
     *            the command definition id
     * @since 3.4
     */
    public void setActionDefinitionId(String definitionId) {
        this.definitionId = definitionId;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IContributionItem#update()
     */
    public void update() {
        updateMenuItem();
    }

    /**
     * The <code>MenuManager</code> implementation of this <code>IContributionManager</code>
     * updates this menu, but not any of its submenus.
     *
     * @see #updateAll
     */
    public void update(bool force) {
        update(force, false);
    }

    /**
     * Get all the items from the implementation's widget.
     *
     * @return the menu items
     * @since 3.4
     */
    protected Item[] getMenuItems() {
        if (menu !is null) {
            return menu.getItems();
        }
        return null;
    }

    /**
     * Get an item from the implementation's widget.
     *
     * @param index
     *            of the item
     * @return the menu item
     * @since 3.4
     */
    protected Item getMenuItem(int index) {
        if (menu !is null) {
            return menu.getItem(index);
        }
        return null;
    }

    /**
     * Get the menu item count for the implementation's widget.
     *
     * @return the number of items
     * @since 3.4
     */
    protected int getMenuItemCount() {
        if (menu !is null) {
            return menu.getItemCount();
        }
        return 0;
    }

    /**
     * Call an <code>IContributionItem</code>'s fill method with the
     * implementation's widget. The default is to use the <code>Menu</code>
     * widget.<br>
     * <code>fill(Menu menu, int index)</code>
     *
     * @param ci
     *            An <code>IContributionItem</code> whose <code>fill()</code>
     *            method should be called.
     * @param index
     *            The position the <code>fill()</code> method should start
     *            inserting at.
     * @since 3.4
     */
    protected void doItemFill(IContributionItem ci, int index) {
        ci.fill(menu, index);
    }

    /**
     * Incrementally builds the menu from the contribution items.
     * This method leaves out double separators and separators in the first
     * or last position.
     *
     * @param force <code>true</code> means update even if not dirty,
     *   and <code>false</code> for normal incremental updating
     * @param recursive <code>true</code> means recursively update
     *   all submenus, and <code>false</code> means just this menu
     */
    protected void update(bool force, bool recursive) {
        if (isDirty() || force) {
            if (menuExist()) {
                // clean contains all active items without double separators
                IContributionItem[] items = getItems();
                List clean = new ArrayList(items.length);
                IContributionItem separator = null;
                for (int i = 0; i < items.length; ++i) {
                    IContributionItem ci = items[i];
                    if (!ci.isVisible()) {
                        continue;
                    }
                    if (ci.isSeparator()) {
                        // delay creation until necessary
                        // (handles both adjacent separators, and separator at end)
                        separator = ci;
                    } else {
                        if (separator !is null) {
                            if (clean.size() > 0) {
                                clean.add(cast(Object)separator);
                            }
                            separator = null;
                        }
                        clean.add(cast(Object)ci);
                    }
                }

                // remove obsolete (removed or non active)
                Item[] mi = getMenuItems();

                for (int i = 0; i < mi.length; i++) {
                    Object data = mi[i].getData();

                    if (data is null || !clean.contains(data)) {
                        mi[i].dispose();
                    } else if (cast(IContributionItem)data
                            && (cast(IContributionItem) data).isDynamic()
                            && (cast(IContributionItem) data).isDirty()) {
                        mi[i].dispose();
                    }
                }

                // add new
                mi = getMenuItems();
                int srcIx = 0;
                int destIx = 0;

                for (Iterator e = clean.iterator(); e.hasNext();) {
                    IContributionItem src = cast(IContributionItem) e.next();
                    IContributionItem dest;

                    // get corresponding item in DWT widget
                    if (srcIx < mi.length) {
                        dest = cast(IContributionItem) mi[srcIx].getData();
                    } else {
                        dest = null;
                    }

                    if (dest !is null && (cast(Object)src).opEquals(cast(Object)dest)) {
                        srcIx++;
                        destIx++;
                    } else if (dest !is null && dest.isSeparator()
                            && src.isSeparator()) {
                        mi[srcIx].setData(cast(Object)src);
                        srcIx++;
                        destIx++;
                    } else {
                        int start = getMenuItemCount();
                        doItemFill(src, destIx);
                        int newItems = getMenuItemCount() - start;
                        for (int i = 0; i < newItems; i++) {
                            Item item = getMenuItem(destIx++);
                            item.setData(cast(Object)src);
                        }
                    }

                    // May be we can optimize this call. If the menu has just
                    // been created via the call src.fill(fMenuBar, destIx) then
                    // the menu has already been updated with update(true)
                    // (see MenuManager). So if force is true we do it again. But
                    // we can't set force to false since then information for the
                    // sub sub menus is lost.
                    if (recursive) {
                        IContributionItem item = src;
                        if ( auto sub = cast(SubContributionItem)item ) {
                            item = sub.getInnerItem();
                        }
                        if (auto mm = cast(IMenuManager)item ) {
                            mm.updateAll(force);
                        }
                    }

                }

                // remove any old menu items not accounted for
                for (; srcIx < mi.length; srcIx++) {
                    mi[srcIx].dispose();
                }

                setDirty(false);
            }
        } else {
            // I am not dirty. Check if I must recursivly walk down the hierarchy.
            if (recursive) {
                IContributionItem[] items = getItems();
                for (int i = 0; i < items.length; ++i) {
                    IContributionItem ci = items[i];
                    if ( auto mm = cast(IMenuManager) ci ) {
                        if (mm.isVisible()) {
                            mm.updateAll(force);
                        }
                    }
                }
            }
        }
        updateMenuItem();
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IContributionItem#update(java.lang.String)
     */
    public void update(String property) {
        IContributionItem items[] = getItems();

        for (int i = 0; i < items.length; i++) {
            items[i].update(property);
        }

        if (menu !is null && !menu.isDisposed() && menu.getParentItem() !is null) {
            if (IAction.TEXT.equals(property)) {
                String text = getOverrides().getText(this);

                if (text is null) {
                    text = getMenuText();
                }

                if (text !is null) {
                    ExternalActionManager.ICallback callback = ExternalActionManager
                            .getInstance().getCallback();

                    if (callback !is null) {
                        int index = .indexOf( text, '&' ); // DWT collision with local indexOf

                        if (index >= 0 && index < text.length - 1) {

                            dchar character = CharacterToUpper(text
                                [index + 1 .. $].firstCodePoint());

                            if (callback.isAcceleratorInUse(DWT.ALT | character)) {
                                if (index is 0) {
                                    text = text.substring(1);
                                } else {
                                    text = text.substring(0, index)
                                        ~ text.substring(index + 1);
                                }
                            }
                        }
                    }

                    menu.getParentItem().setText(text);
                }
            } else if (IAction.IMAGE.equals(property) && image !is null) {
                LocalResourceManager localManager = new LocalResourceManager(JFaceResources
                        .getResources());
                menu.getParentItem().setImage(localManager.createImage(image));
                disposeOldImages();
                imageManager = localManager;
            }
        }
    }

    /**
     * Dispose any images allocated for this menu
     */
    private void disposeOldImages() {
        if (imageManager !is null) {
            imageManager.dispose();
            imageManager = null;
        }
    }

    /* (non-Javadoc)
     * @see dwtx.jface.action.IMenuManager#updateAll(bool)
     */
    public void updateAll(bool force) {
        update(force, true);
    }

    /**
     * Updates the menu item for this sub menu.
     * The menu item is disabled if this sub menu is empty.
     * Does nothing if this menu is not a submenu.
     */
    private void updateMenuItem() {
        /*
         * Commented out until proper solution to enablement of
         * menu item for a sub-menu is found. See bug 30833 for
         * more details.
         *
         if (menuItem !is null && !menuItem.isDisposed() && menuExist()) {
         IContributionItem items[] = getItems();
         bool enabled = false;
         for (int i = 0; i < items.length; i++) {
         IContributionItem item = items[i];
         enabled = item.isEnabled();
         if(enabled) break;
         }
         // Workaround for 1GDDCN2: DWT:Linux - MenuItem.setEnabled() always causes a redraw
         if (menuItem.getEnabled() !is enabled)
         menuItem.setEnabled(enabled);
         }
         */
        // Partial fix for bug #34969 - diable the menu item if no
        // items in sub-menu (for context menus).
        if (menuItem !is null && !menuItem.isDisposed() && menuExist()) {
            bool enabled = removeAllWhenShown || menu.getItemCount() > 0;
            // Workaround for 1GDDCN2: DWT:Linux - MenuItem.setEnabled() always causes a redraw
            if (menuItem.getEnabled() !is enabled) {
                // We only do this for context menus (for bug #34969)
                Menu topMenu = menu;
                while (topMenu.getParentMenu() !is null) {
                    topMenu = topMenu.getParentMenu();
                }
                if ((topMenu.getStyle() & DWT.BAR) is 0) {
                    menuItem.setEnabled(enabled);
                }
            }
        }
    }
}
