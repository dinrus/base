module gtkD.gio.Resolver;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.ListG;
private import gtkD.gio.AsyncResultIF;
private import gtkD.gio.Cancellable;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GResolver provides cancellable synchronous and asynchronous DNS
 * resolution, for hostnames (g_resolver_lookup_by_address(),
 * g_resolver_lookup_by_name() and their async variants) and SRV
 * (service) records (g_resolver_lookup_service()).
 * GNetworkAddress and GNetworkService provide wrappers around
 * GResolver functionality that also implement GSocketConnectable,
 * making it easy to connect to a remote host/service.
 */
public class Resolver : ObjectG
{
	
	/** the main Gtk struct */
	protected GResolver* gResolver;
	
	
	public GResolver* getResolverStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GResolver* gResolver);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Resolver)[] onReloadListeners;
	/**
	 * Emitted when the resolver notices that the system resolver
	 * configuration has changed.
	 */
	void addOnReload(void delegate(Resolver) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackReload(GResolver* resolverStruct, Resolver resolver);
	
	
	/**
	 * Gets the default GResolver. You should unref it when you are done
	 * with it. GResolver may use its reference count as a hint about how
	 * many threads/processes, etc it should allocate for concurrent DNS
	 * resolutions.
	 * Since 2.22
	 * Returns: the default GResolver.
	 */
	public static Resolver getDefault();
	
	/**
	 * Sets resolver to be the application's default resolver (reffing
	 * resolver, and unreffing the previous default resolver, if any).
	 * Future calls to g_resolver_get_default() will return this resolver.
	 * This can be used if an application wants to perform any sort of DNS
	 * caching or "pinning"; it can implement its own GResolver that
	 * calls the original default resolver for DNS operations, and
	 * implements its own cache policies on top of that, and then set
	 * itself as the default resolver for all later code to use.
	 * Since 2.22
	 */
	public void setDefault();
	
	/**
	 * Synchronously resolves hostname to determine its associated IP
	 * address(es). hostname may be an ASCII-only or UTF-8 hostname, or
	 * the textual form of an IP address (in which case this just becomes
	 * a wrapper around g_inet_address_new_from_string()).
	 * On success, g_resolver_lookup_by_name() will return a GList of
	 * GInetAddress, sorted in order of preference. (That is, you should
	 * attempt to connect to the first address first, then the second if
	 * the first fails, etc.)
	 * If the DNS resolution fails, error (if non-NULL) will be set to a
	 * value from GResolverError.
	 * If cancellable is non-NULL, it can be used to cancel the
	 * operation, in which case error (if non-NULL) will be set to
	 * G_IO_ERROR_CANCELLED.
	 * If you are planning to connect to a socket on the resolved IP
	 * address, it may be easier to create a GNetworkAddress and use its
	 * GSocketConnectable interface.
	 * Since 2.22
	 * Params:
	 * hostname =  the hostname to look up
	 * cancellable =  a GCancellable, or NULL
	 * Returns: a GList of GInetAddress, or NULL on error. Youmust unref each of the addresses and free the list when you aredone with it. (You can use g_resolver_free_addresses() to do this.)
	 * Throws: GException on failure.
	 */
	public ListG lookupByName(string hostname, Cancellable cancellable);
	
	/**
	 * Begins asynchronously resolving hostname to determine its
	 * associated IP address(es), and eventually calls callback, which
	 * must call g_resolver_lookup_by_name_finish() to get the result.
	 * See g_resolver_lookup_by_name() for more details.
	 * Since 2.22
	 * Params:
	 * hostname =  the hostname to look up the address of
	 * cancellable =  a GCancellable, or NULL
	 * callback =  callback to call after resolution completes
	 * userData =  data for callback
	 */
	public void lookupByNameAsync(string hostname, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Retrieves the result of a call to
	 * g_resolver_lookup_by_name_async().
	 * If the DNS resolution failed, error (if non-NULL) will be set to
	 * a value from GResolverError. If the operation was cancelled,
	 * error will be set to G_IO_ERROR_CANCELLED.
	 * Since 2.22
	 * Params:
	 * result =  the result passed to your GAsyncReadyCallback
	 * Returns: a GList of GInetAddress, or NULL on error. Seeg_resolver_lookup_by_name() for more details.
	 * Throws: GException on failure.
	 */
	public ListG lookupByNameFinish(AsyncResultIF result);
	
	/**
	 * Frees addresses (which should be the return value from
	 * g_resolver_lookup_by_name() or g_resolver_lookup_by_name_finish()).
	 * (This is a convenience method; you can also simply free the results
	 * by hand.)
	 * Since 2.22
	 * Params:
	 * addresses =  a GList of GInetAddress
	 */
	public static void freeAddresses(ListG addresses);
	
	/**
	 * Synchronously reverse-resolves address to determine its
	 * associated hostname.
	 * If the DNS resolution fails, error (if non-NULL) will be set to
	 * a value from GResolverError.
	 * If cancellable is non-NULL, it can be used to cancel the
	 * operation, in which case error (if non-NULL) will be set to
	 * G_IO_ERROR_CANCELLED.
	 * Since 2.22
	 * Params:
	 * address =  the address to reverse-resolve
	 * cancellable =  a GCancellable, or NULL
	 * Returns: a hostname (either ASCII-only, or in ASCII-encoded form), or NULL on error.
	 * Throws: GException on failure.
	 */
	public string lookupByAddress(GInetAddress* address, Cancellable cancellable);
	
	/**
	 * Begins asynchronously reverse-resolving address to determine its
	 * associated hostname, and eventually calls callback, which must
	 * call g_resolver_lookup_by_address_finish() to get the final result.
	 * Since 2.22
	 * Params:
	 * address =  the address to reverse-resolve
	 * cancellable =  a GCancellable, or NULL
	 * callback =  callback to call after resolution completes
	 * userData =  data for callback
	 */
	public void lookupByAddressAsync(GInetAddress* address, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Retrieves the result of a previous call to
	 * g_resolver_lookup_by_address_async().
	 * If the DNS resolution failed, error (if non-NULL) will be set to
	 * a value from GResolverError. If the operation was cancelled,
	 * error will be set to G_IO_ERROR_CANCELLED.
	 * Since 2.22
	 * Params:
	 * result =  the result passed to your GAsyncReadyCallback
	 * Returns: a hostname (either ASCII-only, or in ASCII-encodedform), or NULL on error.
	 * Throws: GException on failure.
	 */
	public string lookupByAddressFinish(AsyncResultIF result);
	
	/**
	 * Synchronously performs a DNS SRV lookup for the given service and
	 * protocol in the given domain and returns an array of GSrvTarget.
	 * domain may be an ASCII-only or UTF-8 hostname. Note also that the
	 * service and protocol arguments do not
	 * include the leading underscore that appears in the actual DNS
	 * entry.
	 * On success, g_resolver_lookup_service() will return a GList of
	 * GSrvTarget, sorted in order of preference. (That is, you should
	 * attempt to connect to the first target first, then the second if
	 * the first fails, etc.)
	 * If the DNS resolution fails, error (if non-NULL) will be set to
	 * a value from GResolverError.
	 * If cancellable is non-NULL, it can be used to cancel the
	 * operation, in which case error (if non-NULL) will be set to
	 * G_IO_ERROR_CANCELLED.
	 * If you are planning to connect to the service, it is usually easier
	 * to create a GNetworkService and use its GSocketConnectable
	 * interface.
	 * Since 2.22
	 * Params:
	 * service =  the service type to look up (eg, "ldap")
	 * protocol =  the networking protocol to use for service (eg, "tcp")
	 * domain =  the DNS domain to look up the service in
	 * cancellable =  a GCancellable, or NULL
	 * Returns: a GList of GSrvTarget, or NULL on error. You mustfree each of the targets and the list when you are done with it.(You can use g_resolver_free_targets() to do this.)
	 * Throws: GException on failure.
	 */
	public ListG lookupService(string service, string protocol, string domain, Cancellable cancellable);
	
	/**
	 * Begins asynchronously performing a DNS SRV lookup for the given
	 * service and protocol in the given domain, and eventually calls
	 * callback, which must call g_resolver_lookup_service_finish() to
	 * get the final result. See g_resolver_lookup_service() for more
	 * details.
	 * Since 2.22
	 * Params:
	 * service =  the service type to look up (eg, "ldap")
	 * protocol =  the networking protocol to use for service (eg, "tcp")
	 * domain =  the DNS domain to look up the service in
	 * cancellable =  a GCancellable, or NULL
	 * callback =  callback to call after resolution completes
	 * userData =  data for callback
	 */
	public void lookupServiceAsync(string service, string protocol, string domain, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Retrieves the result of a previous call to
	 * g_resolver_lookup_service_async().
	 * If the DNS resolution failed, error (if non-NULL) will be set to
	 * a value from GResolverError. If the operation was cancelled,
	 * error will be set to G_IO_ERROR_CANCELLED.
	 * Since 2.22
	 * Params:
	 * result =  the result passed to your GAsyncReadyCallback
	 * Returns: a GList of GSrvTarget, or NULL on error. Seeg_resolver_lookup_service() for more details.
	 * Throws: GException on failure.
	 */
	public ListG lookupServiceFinish(AsyncResultIF result);
	
	/**
	 * Frees targets (which should be the return value from
	 * g_resolver_lookup_service() or g_resolver_lookup_service_finish()).
	 * (This is a convenience method; you can also simply free the
	 * results by hand.)
	 * Since 2.22
	 * Params:
	 * targets =  a GList of GSrvTarget
	 */
	public static void freeTargets(ListG targets);
}
