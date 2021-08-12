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

module dwtx.jface.action.ExternalActionManager;

import dwtx.jface.action.IAction;


import dwt.widgets.Event;
import dwtx.core.commands.Command;
import dwtx.core.commands.CommandEvent;
import dwtx.core.commands.CommandManager;
import dwtx.core.commands.ExecutionEvent;
import dwtx.core.commands.ExecutionException;
import dwtx.core.commands.ICommandListener;
import dwtx.core.commands.NotEnabledException;
import dwtx.core.commands.ParameterizedCommand;
import dwtx.core.commands.common.NotDefinedException;
import dwtx.core.runtime.IStatus;
import dwtx.core.runtime.ListenerList;
import dwtx.core.runtime.Status;
import dwtx.jface.bindings.BindingManager;
import dwtx.jface.bindings.BindingManagerEvent;
import dwtx.jface.bindings.IBindingManagerListener;
import dwtx.jface.bindings.Trigger;
import dwtx.jface.bindings.TriggerSequence;
import dwtx.jface.bindings.keys.KeySequence;
import dwtx.jface.bindings.keys.KeyStroke;
import dwtx.jface.bindings.keys.SWTKeySupport;
import dwtx.jface.util.IPropertyChangeListener;
import dwtx.jface.util.Policy;
import dwtx.jface.util.PropertyChangeEvent;
import dwtx.jface.util.Util;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwt.dwthelper.ResourceBundle;
import tango.text.convert.Format;

/**
 * <p>
 * A manager for a callback facility which is capable of querying external
 * interfaces for additional information about actions and action contribution
 * items. This information typically includes things like accelerators and
 * textual representations.
 * </p>
 * <p>
 * <em>It is only necessary to use this mechanism if you will be using a mix of
 * actions and commands, and wish the interactions to work properly.</em>
 * </p>
 * <p>
 * For example, in the Eclipse workbench, this mechanism is used to allow the
 * command architecture to override certain values in action contribution items.
 * </p>
 * <p>
 * This class is not intended to be called or extended by any external clients.
 * </p>
 *
 * @since 3.0
 */
public final class ExternalActionManager {

    /**
     * A simple implementation of the <code>ICallback</code> mechanism that
     * simply takes a <code>BindingManager</code> and a
     * <code>CommandManager</code>.
     * <p>
     * <b>Note:</b> this class is not intended to be subclassed by clients.
     * </p>
     *
     * @since 3.1
     */
    public static class CommandCallback :
            IBindingManagerListener, IBindingManagerCallback, IExecuteCallback {

        /**
         * The internationalization bundle for text produced by this class.
         */
        private static const ResourceBundle RESOURCE_BUNDLE;

        /**
         * The callback capable of responding to whether a command is active.
         */
        private const IActiveChecker activeChecker;

        /**
         * Check the applicability of firing an execution event for an action.
         */
        private /+final+/ IExecuteApplicable applicabilityChecker;

        /**
         * The binding manager for your application. Must not be
         * <code>null</code>.
         */
        private const BindingManager bindingManager;

        /**
         * Whether a listener has been attached to the binding manager yet.
         */
        private bool bindingManagerListenerAttached = false;

        /**
         * The command manager for your application. Must not be
         * <code>null</code>.
         */
        private const CommandManager commandManager;

        /**
         * A set of all the command identifiers that have been logged as broken
         * so far. For each of these, there will be a listener on the
         * corresponding command. If the command ever becomes defined, the item
         * will be removed from this set and the listener removed. This value
         * may be empty, but never <code>null</code>.
         */
        private const Set loggedCommandIds;

        /**
         * The list of listeners that have registered for property change
         * notification. This is a map of command identifiers (<code>String</code>)
         * to listeners (<code>IPropertyChangeListener</code> or
         * <code>ListenerList</code> of <code>IPropertyChangeListener</code>).
         */
        private const Map registeredListeners;

        static this(){
            RESOURCE_BUNDLE = ResourceBundle.getBundle(
                getImportData!("dwtx.jface.action.ExternalActionManager.properties"));
        }
        /**
         * Constructs a new instance of <code>CommandCallback</code> with the
         * workbench it should be using. All commands will be considered active.
         *
         * @param bindingManager
         *            The binding manager which will provide the callback; must
         *            not be <code>null</code>.
         * @param commandManager
         *            The command manager which will provide the callback; must
         *            not be <code>null</code>.
         *
         * @since 3.1
         */
        public this(BindingManager bindingManager,
                CommandManager commandManager) {
            this(bindingManager, commandManager, new class IActiveChecker {
                public bool isActive(String commandId) {
                    return true;
                }

            }, new class IExecuteApplicable {
                public bool isApplicable(IAction action) {
                    return true;
                }
            });
        }
        /**
         * Constructs a new instance of <code>CommandCallback</code> with the
         * workbench it should be using.
         *
         * @param bindingManager
         *            The binding manager which will provide the callback; must
         *            not be <code>null</code>.
         * @param commandManager
         *            The command manager which will provide the callback; must
         *            not be <code>null</code>.
         * @param activeChecker
         *            The callback mechanism for checking whether a command is
         *            active; must not be <code>null</code>.
         *
         * @since 3.1
         */
        public this(BindingManager bindingManager,
                CommandManager commandManager,
                IActiveChecker activeChecker) {
            this(bindingManager, commandManager, activeChecker,
                    new class IExecuteApplicable {
                public bool isApplicable(IAction action) {
                    return true;
                }
            });
        }
        /**
         * Constructs a new instance of <code>CommandCallback</code> with the
         * workbench it should be using.
         *
         * @param bindingManager
         *            The binding manager which will provide the callback; must
         *            not be <code>null</code>.
         * @param commandManager
         *            The command manager which will provide the callback; must
         *            not be <code>null</code>.
         * @param activeChecker
         *            The callback mechanism for checking whether a command is
         *            active; must not be <code>null</code>.
         * @param checker
         *            The callback to check if an IAction should fire execution
         *            events.
         *
         * @since 3.4
         */
        public this(BindingManager bindingManager,
                CommandManager commandManager,
                IActiveChecker activeChecker,
                IExecuteApplicable checker) {
            loggedCommandIds = new HashSet();
            registeredListeners = new HashMap();
            if (bindingManager is null) {
                throw new NullPointerException(
                        "The callback needs a binding manager"); //$NON-NLS-1$
            }

            if (commandManager is null) {
                throw new NullPointerException(
                        "The callback needs a command manager"); //$NON-NLS-1$
            }

            if (activeChecker is null) {
                throw new NullPointerException(
                        "The callback needs an active callback"); //$NON-NLS-1$
            }
            if (checker is null) {
                throw new NullPointerException(
                        "The callback needs an applicable callback"); //$NON-NLS-1$
            }

            this.activeChecker = activeChecker;
            this.bindingManager = bindingManager;
            this.commandManager = commandManager;
            this.applicabilityChecker = checker;
        }

        /**
         * @see dwtx.jface.action.ExternalActionManager.ICallback#addPropertyChangeListener(String,
         *      IPropertyChangeListener)
         */
        public final void addPropertyChangeListener(String commandId,
                IPropertyChangeListener listener) {
            auto existing = cast(Object)registeredListeners.get(commandId);
            if (null !is cast(ListenerList)existing ) {
                (cast(ListenerList) existing).add(cast(Object)listener);
            } else if (existing !is null) {
                ListenerList listeners = new ListenerList(ListenerList.IDENTITY);
                listeners.add(existing);
                listeners.add(cast(Object)listener);
            } else {
                registeredListeners.put(commandId, cast(Object)listener);
            }
            if (!bindingManagerListenerAttached) {
                bindingManager.addBindingManagerListener(this);
                bindingManagerListenerAttached = true;
            }
        }

        public final void bindingManagerChanged(BindingManagerEvent event) {
            if (event.isActiveBindingsChanged()) {
                final Iterator listenerItr = registeredListeners.entrySet()
                        .iterator();
                while (listenerItr.hasNext()) {
                    Map.Entry entry = cast(Map.Entry) listenerItr.next();
                    String commandId = stringcast( entry.getKey());
                    Command command = commandManager
                            .getCommand(commandId);
                    ParameterizedCommand parameterizedCommand = new ParameterizedCommand(
                            command, null);
                    if (event.isActiveBindingsChangedFor(parameterizedCommand)) {
                        Object value = entry.getValue();
                        PropertyChangeEvent propertyChangeEvent = new PropertyChangeEvent(event
                                .getManager(), IAction.TEXT, null, null);
                        if (null !is cast(ListenerList)value ) {
                            Object[] listeners= (cast(ListenerList) value).getListeners();
                            for (int i = 0; i < listeners.length; i++) {
                                final IPropertyChangeListener listener = cast(IPropertyChangeListener) listeners[i];
                                listener.propertyChange(propertyChangeEvent);
                            }
                        } else {
                            final IPropertyChangeListener listener = cast(IPropertyChangeListener) value;
                            listener.propertyChange(propertyChangeEvent);
                        }
                    }
                }
            }
        }

        /**
         * @see dwtx.jface.action.ExternalActionManager.ICallback#getAccelerator(String)
         */
        public Integer getAccelerator(String commandId) {
            TriggerSequence triggerSequence = bindingManager
                    .getBestActiveBindingFor(commandId);
            if (triggerSequence !is null) {
                Trigger[] triggers = triggerSequence.getTriggers();
                if (triggers.length is 1) {
                    Trigger trigger = triggers[0];
                    if ( auto keyStroke = cast(KeyStroke) trigger ) {
                        int accelerator = SWTKeySupport
                                .convertKeyStrokeToAccelerator(keyStroke);
                        return new Integer(accelerator);
                    }
                }
            }

            return null;
        }

        /**
         * @see dwtx.jface.action.ExternalActionManager.ICallback#getAcceleratorText(String)
         */
        public final String getAcceleratorText(String commandId) {
            TriggerSequence triggerSequence = bindingManager
                    .getBestActiveBindingFor(commandId);
            if (triggerSequence is null) {
                return null;
            }

            return triggerSequence.format();
        }

        /**
         * Returns the active bindings for a particular command identifier.
         *
         * @param commandId
         *            The identifier of the command whose bindings are
         *            requested. This argument may be <code>null</code>. It
         *            is assumed that the command has no parameters.
         * @return The array of active triggers (<code>TriggerSequence</code>)
         *         for a particular command identifier. This value is guaranteed
         *         not to be <code>null</code>, but it may be empty.
         * @since 3.2
         */
        public final TriggerSequence[] getActiveBindingsFor(
                String commandId) {
            return bindingManager.getActiveBindingsFor(commandId);
        }

        /**
         * @see dwtx.jface.action.ExternalActionManager.ICallback#isAcceleratorInUse(int)
         */
        public final bool isAcceleratorInUse(int accelerator) {
            KeySequence keySequence = KeySequence
                    .getInstance(SWTKeySupport
                            .convertAcceleratorToKeyStroke(accelerator));
            return bindingManager.isPerfectMatch(keySequence)
                    || bindingManager.isPartialMatch(keySequence);
        }

        /**
         * {@inheritDoc}
         *
         * Calling this method with an undefined command id will generate a log
         * message.
         */
        public final bool isActive(String commandId) {
            if (commandId !is null) {
                Command command = commandManager.getCommand(commandId);

                if (!command.isDefined()
                        && (!loggedCommandIds.contains(commandId))) {
                    // The command is not yet defined, so we should log this.
                    String message = Format(Util
                            .translateString(RESOURCE_BUNDLE,
                                    "undefinedCommand.WarningMessage", null), //$NON-NLS-1$
                            [ command.getId() ]);
                    IStatus status = new Status(IStatus.ERROR,
                            "dwtx.jface", //$NON-NLS-1$
                            0, message, new Exception(null));
                    Policy.getLog().log(status);

                    // And remember this item so we don't log it again.
                    loggedCommandIds.add(commandId);
                    command.addCommandListener(new class(command,commandId) ICommandListener {
                        Command command_;
                        String commandId_;
                        this(Command a,String b){
                            command_=a;
                            commandId_=b;
                        }
                        /*
                         * (non-Javadoc)
                         *
                         * @see dwtx.ui.commands.ICommandListener#commandChanged(dwtx.ui.commands.CommandEvent)
                         */
                        public final void commandChanged(
                                CommandEvent commandEvent) {
                            if (command_.isDefined()) {
                                command_.removeCommandListener(this);
                                loggedCommandIds.remove(commandId_);
                            }
                        }
                    });

                    return true;
                }

                return activeChecker.isActive(commandId);
            }

            return true;
        }

        /**
         * @see dwtx.jface.action.ExternalActionManager.ICallback#removePropertyChangeListener(String,
         *      IPropertyChangeListener)
         */
        public final void removePropertyChangeListener(String commandId,
                IPropertyChangeListener listener) {
            Object existing = cast(Object) registeredListeners.get(commandId);
            if (existing is cast(Object)listener) {
                registeredListeners.remove(commandId);
                if (registeredListeners.isEmpty()) {
                    bindingManager.removeBindingManagerListener(this);
                    bindingManagerListenerAttached = false;
                }
            } else if (null !is cast(ListenerList)existing ) {
                ListenerList existingList = cast(ListenerList) existing;
                existingList.remove(cast(Object)listener);
                if (existingList.size() is 1) {
                    registeredListeners.put(commandId, existingList.getListeners()[0]);
                }
            }
        }

        /**
         * @since 3.4
         */
        public void preExecute(IAction action, Event event) {
            String actionDefinitionId = action.getActionDefinitionId();
            if (actionDefinitionId is null
                    || !applicabilityChecker.isApplicable(action)) {
                return;
            }
            Command command = commandManager.getCommand(actionDefinitionId);
            ExecutionEvent executionEvent = new ExecutionEvent(command,
                    Collections.EMPTY_MAP, event, null);

            commandManager.firePreExecute(actionDefinitionId, executionEvent);
        }

        /**
         * @since 3.4
         */
        public void postExecuteSuccess(IAction action, Object returnValue) {
            String actionDefinitionId = action.getActionDefinitionId();
            if (actionDefinitionId is null
                    || !applicabilityChecker.isApplicable(action)) {
                return;
            }
            commandManager.firePostExecuteSuccess(actionDefinitionId, returnValue);
        }

        /**
         * @since 3.4
         */
        public void postExecuteFailure(IAction action,
                ExecutionException exception) {
            String actionDefinitionId = action.getActionDefinitionId();
            if (actionDefinitionId is null
                    || !applicabilityChecker.isApplicable(action)) {
                return;
            }
            commandManager.firePostExecuteFailure(actionDefinitionId, exception);
        }

        /**
         * @since 3.4
         */
        public void notDefined(IAction action, NotDefinedException exception) {
            String actionDefinitionId = action.getActionDefinitionId();
            if (actionDefinitionId is null
                    || !applicabilityChecker.isApplicable(action)) {
                return;
            }
            commandManager.fireNotDefined(actionDefinitionId, exception);
        }

        /**
         * @since 3.4
         */
        public void notEnabled(IAction action, NotEnabledException exception) {
            String actionDefinitionId = action.getActionDefinitionId();
            if (actionDefinitionId is null
                    || !applicabilityChecker.isApplicable(action)) {
                return;
            }
            commandManager.fireNotEnabled(actionDefinitionId, exception);
        }
    }

    /**
     * Defines a callback mechanism for developer who wish to further control
     * the visibility of legacy action-based contribution items.
     *
     * @since 3.1
     */
    public interface IActiveChecker {
        /**
         * Checks whether the command with the given identifier should be
         * considered active. This can be used in systems using some kind of
         * user interface filtering (e.g., activities in the Eclipse workbench).
         *
         * @param commandId
         *            The identifier for the command; must not be
         *            <code>null</code>
         * @return <code>true</code> if the command is active;
         *         <code>false</code> otherwise.
         */
        public bool isActive(String commandId);
    }

    /**
     * <p>
     * A callback which communicates with the applications binding manager. This
     * interface provides more information from the binding manager, which
     * allows greater integration. Implementing this interface is preferred over
     * {@link ExternalActionManager.ICallback}.
     * </p>
     * <p>
     * Clients may implement this interface, but must not extend.
     * </p>
     *
     * @since 3.2
     */
    public interface IBindingManagerCallback : ICallback {

        /**
         * <p>
         * Returns the active bindings for a particular command identifier.
         * </p>
         *
         * @param commandId
         *            The identifier of the command whose bindings are
         *            requested. This argument may be <code>null</code>. It
         *            is assumed that the command has no parameters.
         * @return The array of active triggers (<code>TriggerSequence</code>)
         *         for a particular command identifier. This value is guaranteed
         *         not to be <code>null</code>, but it may be empty.
         */
        public TriggerSequence[] getActiveBindingsFor(String commandId);
    }

    /**
     * An overridable mechanism to filter certain IActions from the execution
     * bridge.
     *
     * @since 3.4
     */
    public interface IExecuteApplicable {
        /**
         * Allow the callback to filter out actions that should not fire
         * execution events.
         *
         * @param action
         *            The action with an actionDefinitionId
         * @return true if this action should be considered.
         */
        public bool isApplicable(IAction action);
    }

    /**
     * <p>
     * A callback for executing execution events. Allows
     * <code>ActionContributionItems</code> to fire useful events.
     * </p>
     * <p>
     * Clients must not implement this interface and must not extend.
     * </p>
     *
     * @since 3.4
     *
     */
    public interface IExecuteCallback {

        /**
         * Fires a <code>NotEnabledException</code> because the action was not
         * enabled.
         *
         * @param action
         *          The action contribution that caused the exception,
         *          never <code>null</code>.
         * @param exception
         *          The <code>NotEnabledException</code>, never <code>null</code>.
         */
        public void notEnabled(IAction action, NotEnabledException exception);

        /**
         * Fires a <code>NotDefinedException</code> because the action was not
         * defined.
         *
         * @param action
         *          The action contribution that caused the exception,
         *          never <code>null</code>.
         * @param exception
         *          The <code>NotDefinedException</code>, never <code>null</code>.
         */
        public void notDefined(IAction action, NotDefinedException exception);

        /**
         * Fires an execution event before an action is run.
         *
         * @param action
         *            The action contribution that requires an
         *            execution event to be fired. Cannot be <code>null</code>.
         * @param e
         *            The DWT Event, may be <code>null</code>.
         *
         */
        public void preExecute(IAction action,
                Event e);

        /**
         * Fires an execution event when the action returned a success.
         *
         * @param action
         *            The action contribution that requires an
         *            execution event to be fired. Cannot be <code>null</code>.
         * @param returnValue
         *            The command's result, may be <code>null</code>.
         *
         */
        public void postExecuteSuccess(IAction action,
                Object returnValue);

        /**
         * Creates an <code>ExecutionException</code> when the action returned
         * a failure.
         *
         * @param action
         *          The action contribution that caused the exception,
         *          never <code>null</code>.
         * @param exception
         *          The <code>ExecutionException</code>, never <code>null</code>.
         */
        public void postExecuteFailure(IAction action,
                ExecutionException exception);
    }

    /**
     * A callback mechanism for some external tool to communicate extra
     * information to actions and action contribution items.
     *
     * @since 3.0
     */
    public interface ICallback {

        /**
         * <p>
         * Adds a listener to the object referenced by <code>identifier</code>.
         * This listener will be notified if a property of the item is to be
         * changed. This identifier is specific to mechanism being used. In the
         * case of the Eclipse workbench, this is the command identifier.
         * </p>
         * <p>
         * Has no effect if an identical listener has already been added for
         * the <code>identifier</code>.
         * </p>
         *
         * @param identifier
         *            The identifier of the item to which the listener should be
         *            attached; must not be <code>null</code>.
         * @param listener
         *            The listener to be added; must not be <code>null</code>.
         */
        public void addPropertyChangeListener(String identifier,
                IPropertyChangeListener listener);

        /**
         * An accessor for the accelerator associated with the item indicated by
         * the identifier. This identifier is specific to mechanism being used.
         * In the case of the Eclipse workbench, this is the command identifier.
         *
         * @param identifier
         *            The identifier of the item from which the accelerator
         *            should be obtained ; must not be <code>null</code>.
         * @return An integer representation of the accelerator. This is the
         *         same accelerator format used by DWT.
         */
        public Integer getAccelerator(String identifier);

        /**
         * An accessor for the accelerator text associated with the item
         * indicated by the identifier. This identifier is specific to mechanism
         * being used. In the case of the Eclipse workbench, this is the command
         * identifier.
         *
         * @param identifier
         *            The identifier of the item from which the accelerator text
         *            should be obtained ; must not be <code>null</code>.
         * @return A string representation of the accelerator. This is the
         *         string representation that should be displayed to the user.
         */
        public String getAcceleratorText(String identifier);

        /**
         * Checks to see whether the given accelerator is being used by some
         * other mechanism (outside of the menus controlled by JFace). This is
         * used to keep JFace from trying to grab accelerators away from someone
         * else.
         *
         * @param accelerator
         *            The accelerator to check -- in DWT's internal accelerator
         *            format.
         * @return <code>true</code> if the accelerator is already being used
         *         and shouldn't be used again; <code>false</code> otherwise.
         */
        public bool isAcceleratorInUse(int accelerator);

        /**
         * Checks whether the item matching this identifier is active. This is
         * used to decide whether a contribution item with this identifier
         * should be made visible. An inactive item is not visible.
         *
         * @param identifier
         *            The identifier of the item from which the active state
         *            should be retrieved; must not be <code>null</code>.
         * @return <code>true</code> if the item is active; <code>false</code>
         *         otherwise.
         */
        public bool isActive(String identifier);

        /**
         * Removes a listener from the object referenced by
         * <code>identifier</code>. This identifier is specific to mechanism
         * being used. In the case of the Eclipse workbench, this is the command
         * identifier.
         *
         * @param identifier
         *            The identifier of the item to from the listener should be
         *            removed; must not be <code>null</code>.
         * @param listener
         *            The listener to be removed; must not be <code>null</code>.
         */
        public void removePropertyChangeListener(String identifier,
                IPropertyChangeListener listener);

    }

    /**
     * The singleton instance of this class. This value may be <code>null</code>--
     * if it has not yet been initialized.
     */
    private static ExternalActionManager instance;

    /**
     * Retrieves the current singleton instance of this class.
     *
     * @return The singleton instance; this value is never <code>null</code>.
     */
    public static ExternalActionManager getInstance() {
        if (instance is null) {
            instance = new ExternalActionManager();
        }

        return instance;
    }

    /**
     * The callback mechanism to use to retrieve extra information.
     */
    private ICallback callback;

    /**
     * Constructs a new instance of <code>ExternalActionManager</code>.
     */
    private this() {
        // This is a singleton class. Only this class should create an instance.
    }

    /**
     * An accessor for the current call back.
     *
     * @return The current callback mechanism being used. This is the callback
     *         that should be queried for extra information about actions and
     *         action contribution items. This value may be <code>null</code>
     *         if there is no extra information.
     */
    public ICallback getCallback() {
        return callback;
    }

    /**
     * A mutator for the current call back
     *
     * @param callbackToUse
     *            The new callback mechanism to use; this value may be
     *            <code>null</code> if the default is acceptable (i.e., no
     *            extra information will provided to actions).
     */
    public void setCallback(ICallback callbackToUse) {
        callback = callbackToUse;
    }
}
