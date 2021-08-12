module gtkD.glib.HashTable;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.HashTableIter;
private import gtkD.glib.ListG;




/**
 * Description
 * A GHashTable provides associations between keys and values which
 * is optimized so that given a key, the associated value can be found
 * very quickly.
 * Note that neither keys nor values are copied when inserted into the
 * GHashTable, so they must exist for the lifetime of the GHashTable.
 * This means that the use of static strings is OK, but temporary
 * strings (i.e. those created in buffers and those returned by GTK+ widgets)
 * should be copied with g_strdup() before being inserted.
 * If keys or values are dynamically allocated, you must be careful to ensure
 * that they are freed when they are removed from the GHashTable, and also
 * when they are overwritten by new insertions into the GHashTable.
 * It is also not advisable to mix static strings and dynamically-allocated
 * strings in a GHashTable, because it then becomes difficult to determine
 * whether the string should be freed.
 * To create a GHashTable, use g_hash_table_new().
 * To insert a key and value into a GHashTable, use g_hash_table_insert().
 * To lookup a value corresponding to a given key, use g_hash_table_lookup()
 * and g_hash_table_lookup_extended().
 * To remove a key and value, use g_hash_table_remove().
 * To call a function for each key and value pair use g_hash_table_foreach()
 * or use a iterator to iterate over the key/value pairs in the hash table, see
 * GHashTableIter.
 * To destroy a GHashTable use g_hash_table_destroy().
 */
public class HashTable
{
	
	/** the main Gtk struct */
	protected GHashTable* gHashTable;
	
	
	public GHashTable* getHashTableStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GHashTable* gHashTable);
	
	/**
	 */
	
	/**
	 * Creates a new GHashTable with a reference count of 1.
	 * Params:
	 * hashFunc =  a function to create a hash value from a key.
	 *  Hash values are used to determine where keys are stored within the
	 *  GHashTable data structure. The g_direct_hash(), g_int_hash(),
	 *  g_int64_hash(), g_double_hash() and g_str_hash() functions are provided
	 *  for some common types of keys.
	 *  If hash_func is NULL, g_direct_hash() is used.
	 * keyEqualFunc =  a function to check two keys for equality. This is
	 *  used when looking up keys in the GHashTable. The g_direct_equal(),
	 *  g_int_equal(), g_int64_equal(), g_double_equal() and g_str_equal()
	 *  functions are provided for the most common types of keys.
	 *  If key_equal_func is NULL, keys are compared directly in a similar
	 *  fashion to g_direct_equal(), but without the overhead of a function call.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GHashFunc hashFunc, GEqualFunc keyEqualFunc);
	
	/**
	 * Creates a new GHashTable like g_hash_table_new() with a reference count
	 * of 1 and allows to specify functions to free the memory allocated for the
	 * key and value that get called when removing the entry from the GHashTable.
	 * Params:
	 * hashFunc =  a function to create a hash value from a key.
	 * keyEqualFunc =  a function to check two keys for equality.
	 * keyDestroyFunc =  a function to free the memory allocated for the key
	 *  used when removing the entry from the GHashTable or NULL if you
	 *  don't want to supply such a function.
	 * valueDestroyFunc =  a function to free the memory allocated for the
	 *  value used when removing the entry from the GHashTable or NULL if
	 *  you don't want to supply such a function.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GHashFunc hashFunc, GEqualFunc keyEqualFunc, GDestroyNotify keyDestroyFunc, GDestroyNotify valueDestroyFunc);
	
	/**
	 * Inserts a new key and value into a GHashTable.
	 * If the key already exists in the GHashTable its current value is replaced
	 * with the new value. If you supplied a value_destroy_func when creating the
	 * GHashTable, the old value is freed using that function. If you supplied
	 * a key_destroy_func when creating the GHashTable, the passed key is freed
	 * using that function.
	 * Params:
	 * key =  a key to insert.
	 * value =  the value to associate with the key.
	 */
	public void insert(void* key, void* value);
	
	/**
	 * Inserts a new key and value into a GHashTable similar to
	 * g_hash_table_insert(). The difference is that if the key already exists
	 * in the GHashTable, it gets replaced by the new key. If you supplied a
	 * value_destroy_func when creating the GHashTable, the old value is freed
	 * using that function. If you supplied a key_destroy_func when creating the
	 * GHashTable, the old key is freed using that function.
	 * Params:
	 * key =  a key to insert.
	 * value =  the value to associate with the key.
	 */
	public void replace(void* key, void* value);
	
	/**
	 * Returns the number of elements contained in the GHashTable.
	 * Returns: the number of key/value pairs in the GHashTable.
	 */
	public uint size();
	
	/**
	 * Looks up a key in a GHashTable. Note that this function cannot
	 * distinguish between a key that is not present and one which is present
	 * and has the value NULL. If you need this distinction, use
	 * g_hash_table_lookup_extended().
	 * Params:
	 * key =  the key to look up.
	 * Returns: the associated value, or NULL if the key is not found.
	 */
	public void* lookup(void* key);
	
	/**
	 * Looks up a key in the GHashTable, returning the original key and the
	 * associated value and a gboolean which is TRUE if the key was found. This
	 * is useful if you need to free the memory allocated for the original key,
	 * for example before calling g_hash_table_remove().
	 * You can actually pass NULL for lookup_key to test
	 * whether the NULL key exists.
	 * Params:
	 * lookupKey =  the key to look up
	 * origKey =  return location for the original key, or NULL
	 * value =  return location for the value associated with the key, or NULL
	 * Returns: TRUE if the key was found in the GHashTable.
	 */
	public int lookupExtended(void* lookupKey, void** origKey, void** value);
	
	/**
	 * Calls the given function for each of the key/value pairs in the
	 * GHashTable. The function is passed the key and value of each
	 * pair, and the given user_data parameter. The hash table may not
	 * be modified while iterating over it (you can't add/remove
	 * items). To remove all items matching a predicate, use
	 * g_hash_table_foreach_remove().
	 * See g_hash_table_find() for performance caveats for linear
	 * order searches in contrast to g_hash_table_lookup().
	 * Params:
	 * func =  the function to call for each key/value pair.
	 * userData =  user data to pass to the function.
	 */
	public void foreac(GHFunc func, void* userData);
	
	/**
	 * Calls the given function for key/value pairs in the GHashTable until
	 * predicate returns TRUE. The function is passed the key and value of
	 * each pair, and the given user_data parameter. The hash table may not
	 * be modified while iterating over it (you can't add/remove items).
	 * Note, that hash tables are really only optimized for forward lookups,
	 * i.e. g_hash_table_lookup().
	 * So code that frequently issues g_hash_table_find() or
	 * g_hash_table_foreach() (e.g. in the order of once per every entry in a
	 * hash table) should probably be reworked to use additional or different
	 * data structures for reverse lookups (keep in mind that an O(n) find/foreach
	 * operation issued for all n values in a hash table ends up needing O(n*n)
	 * operations).
	 * Since 2.4
	 * Params:
	 * predicate =  function to test the key/value pairs for a certain property.
	 * userData =  user data to pass to the function.
	 * Returns: The value of the first key/value pair is returned, for whichfunc evaluates to TRUE. If no pair with the requested property is found,NULL is returned.
	 */
	public void* find(GHRFunc predicate, void* userData);
	
	/**
	 * Removes a key and its associated value from a GHashTable.
	 * If the GHashTable was created using g_hash_table_new_full(), the
	 * key and value are freed using the supplied destroy functions, otherwise
	 * you have to make sure that any dynamically allocated values are freed
	 * yourself.
	 * Params:
	 * key =  the key to remove.
	 * Returns: TRUE if the key was found and removed from the GHashTable.
	 */
	public int remove(void* key);
	
	/**
	 * Removes a key and its associated value from a GHashTable without
	 * calling the key and value destroy functions.
	 * Params:
	 * key =  the key to remove.
	 * Returns: TRUE if the key was found and removed from the GHashTable.
	 */
	public int steal(void* key);
	
	/**
	 * Calls the given function for each key/value pair in the GHashTable.
	 * If the function returns TRUE, then the key/value pair is removed from the
	 * GHashTable. If you supplied key or value destroy functions when creating
	 * the GHashTable, they are used to free the memory allocated for the removed
	 * keys and values.
	 * See GHashTableIter for an alternative way to loop over the
	 * key/value pairs in the hash table.
	 * Params:
	 * func =  the function to call for each key/value pair.
	 * userData =  user data to pass to the function.
	 * Returns: the number of key/value pairs removed.
	 */
	public uint foreachRemove(GHRFunc func, void* userData);
	
	/**
	 * Calls the given function for each key/value pair in the GHashTable.
	 * If the function returns TRUE, then the key/value pair is removed from the
	 * GHashTable, but no key or value destroy functions are called.
	 * See GHashTableIter for an alternative way to loop over the
	 * key/value pairs in the hash table.
	 * Params:
	 * func =  the function to call for each key/value pair.
	 * userData =  user data to pass to the function.
	 * Returns: the number of key/value pairs removed.
	 */
	public uint foreachSteal(GHRFunc func, void* userData);
	
	/**
	 * Removes all keys and their associated values from a GHashTable.
	 * If the GHashTable was created using g_hash_table_new_full(), the keys
	 * and values are freed using the supplied destroy functions, otherwise you
	 * have to make sure that any dynamically allocated values are freed
	 * yourself.
	 * Since 2.12
	 */
	public void removeAll();
	
	/**
	 * Removes all keys and their associated values from a GHashTable
	 * without calling the key and value destroy functions.
	 * Since 2.12
	 */
	public void stealAll();
	
	/**
	 * Retrieves every key inside hash_table. The returned data is valid
	 * until hash_table is modified.
	 * Since 2.14
	 * Returns: a GList containing all the keys inside the hash table. The content of the list is owned by the hash table and should not be modified or freed. Use g_list_free() when done using the list.
	 */
	public ListG getKeys();
	
	/**
	 * Retrieves every value inside hash_table. The returned data is
	 * valid until hash_table is modified.
	 * Since 2.14
	 * Returns: a GList containing all the values inside the hash table. The content of the list is owned by the hash table and should not be modified or freed. Use g_list_free() when done using the list.
	 */
	public ListG getValues();
	
	/**
	 * Destroys all keys and values in the GHashTable and decrements its
	 * reference count by 1. If keys and/or values are dynamically allocated,
	 * you should either free them first or create the GHashTable with destroy
	 * notifiers using g_hash_table_new_full(). In the latter case the destroy
	 * functions you supplied will be called on all keys and values during the
	 * destruction phase.
	 */
	public void destroy();
	
	/**
	 * Atomically increments the reference count of hash_table by one.
	 * This function is MT-safe and may be called from any thread.
	 * Since 2.10
	 * Returns: the passed in GHashTable.
	 */
	public HashTable doref();
	
	/**
	 * Atomically decrements the reference count of hash_table by one.
	 * If the reference count drops to 0, all keys and values will be
	 * destroyed, and all memory allocated by the hash table is released.
	 * This function is MT-safe and may be called from any thread.
	 * Since 2.10
	 */
	public void unref();
	
	/**
	 * Compares two gpointer arguments and returns TRUE if they are equal.
	 * It can be passed to g_hash_table_new() as the key_equal_func
	 * parameter, when using pointers as keys in a GHashTable.
	 * Params:
	 * v1 =  a key.
	 * v2 =  a key to compare with v1.
	 * Returns: TRUE if the two keys match.
	 */
	public static int gDirectEqual(void* v1, void* v2);
	
	/**
	 * Converts a gpointer to a hash value.
	 * It can be passed to g_hash_table_new() as the hash_func parameter,
	 * when using pointers as keys in a GHashTable.
	 * Params:
	 * v =  a gpointer key
	 * Returns: a hash value corresponding to the key.
	 */
	public static uint gDirectHash(void* v);
	
	/**
	 * Compares the two gint values being pointed to and returns
	 * TRUE if they are equal.
	 * It can be passed to g_hash_table_new() as the key_equal_func
	 * parameter, when using pointers to integers as keys in a GHashTable.
	 * Params:
	 * v1 =  a pointer to a gint key.
	 * v2 =  a pointer to a gint key to compare with v1.
	 * Returns: TRUE if the two keys match.
	 */
	public static int gIntEqual(void* v1, void* v2);
	
	/**
	 * Converts a pointer to a gint to a hash value.
	 * It can be passed to g_hash_table_new() as the hash_func parameter,
	 * when using pointers to integers values as keys in a GHashTable.
	 * Params:
	 * v =  a pointer to a gint key
	 * Returns: a hash value corresponding to the key.
	 */
	public static uint gIntHash(void* v);
	
	/**
	 * Compares the two gint64 values being pointed to and returns
	 * TRUE if they are equal.
	 * It can be passed to g_hash_table_new() as the key_equal_func
	 * parameter, when using pointers to 64-bit integers as keys in a GHashTable.
	 * Since 2.22
	 * Params:
	 * v1 =  a pointer to a gint64 key.
	 * v2 =  a pointer to a gint64 key to compare with v1.
	 * Returns: TRUE if the two keys match.
	 */
	public static int gInt64_Equal(void* v1, void* v2);
	
	/**
	 * Converts a pointer to a gint64 to a hash value.
	 * It can be passed to g_hash_table_new() as the hash_func parameter,
	 * when using pointers to 64-bit integers values as keys in a GHashTable.
	 * Since 2.22
	 * Params:
	 * v =  a pointer to a gint64 key
	 * Returns: a hash value corresponding to the key.
	 */
	public static uint gInt64_Hash(void* v);
	
	/**
	 * Compares the two gdouble values being pointed to and returns
	 * TRUE if they are equal.
	 * It can be passed to g_hash_table_new() as the key_equal_func
	 * parameter, when using pointers to doubles as keys in a GHashTable.
	 * Since 2.22
	 * Params:
	 * v1 =  a pointer to a gdouble key.
	 * v2 =  a pointer to a gdouble key to compare with v1.
	 * Returns: TRUE if the two keys match.
	 */
	public static int gDoubleEqual(void* v1, void* v2);
	
	/**
	 * Converts a pointer to a gdouble to a hash value.
	 * It can be passed to g_hash_table_new() as the hash_func parameter,
	 * when using pointers to doubles as keys in a GHashTable.
	 * Since 2.22
	 * Params:
	 * v =  a pointer to a gdouble key
	 * Returns: a hash value corresponding to the key.
	 */
	public static uint gDoubleHash(void* v);
	
	/**
	 * Compares two strings for byte-by-byte equality and returns TRUE
	 * if they are equal. It can be passed to g_hash_table_new() as the
	 * key_equal_func parameter, when using strings as keys in a GHashTable.
	 * Note that this function is primarily meant as a hash table comparison
	 * function. For a general-purpose, NULL-safe string comparison function,
	 * see g_strcmp0().
	 * Params:
	 * v1 =  a key
	 * v2 =  a key to compare with v1
	 * Returns: TRUE if the two keys match
	 */
	public static int gStrEqual(void* v1, void* v2);
	
	/**
	 * Converts a string to a hash value.
	 * It can be passed to g_hash_table_new() as the hash_func
	 * parameter, when using strings as keys in a GHashTable.
	 * Params:
	 * v =  a string key
	 * Returns: a hash value corresponding to the key
	 */
	public static uint gStrHash(void* v);
}
