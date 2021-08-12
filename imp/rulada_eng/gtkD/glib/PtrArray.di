module gtkD.glib.PtrArray;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * Pointer Arrays are similar to Arrays but are used only for storing pointers.
 * Note
 * If you remove elements from the array, elements at the end of the array
 * are moved into the space previously occupied by the removed element.
 * This means that you should not rely on the index of particular elements
 * remaining the same. You should also be careful when deleting elements while
 * iterating over the array.
 * To create a pointer array, use g_ptr_array_new().
 * To add elements to a pointer array, use g_ptr_array_add().
 * To remove elements from a pointer array, use g_ptr_array_remove(),
 * g_ptr_array_remove_index() or g_ptr_array_remove_index_fast().
 * To access an element of a pointer array, use g_ptr_array_index().
 * To set the size of a pointer array, use g_ptr_array_set_size().
 * To free a pointer array, use g_ptr_array_free().
 * Example 21. Using a GPtrArray
 *  GPtrArray *gparray;
 *  gchar *string1 = "one", *string2 = "two", *string3 = "three";
 *  gparray = g_ptr_array_new ();
 *  g_ptr_array_add (gparray, (gpointer) string1);
 *  g_ptr_array_add (gparray, (gpointer) string2);
 *  g_ptr_array_add (gparray, (gpointer) string3);
 *  if (g_ptr_array_index (gparray, 0) != (gpointer) string1)
 *  g_print ("ERROR: got %p instead of %p\n",
 *  g_ptr_array_index (gparray, 0), string1);
 *  g_ptr_array_free (gparray, TRUE);
 */
public class PtrArray
{
	
	/** the main Gtk struct */
	protected GPtrArray* gPtrArray;
	
	
	public GPtrArray* getPtrArrayStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GPtrArray* gPtrArray);
	
	/**
	 */
	
	/**
	 * Creates a new GPtrArray with a reference count of 1.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GPtrArray with reserved_size pointers
	 * preallocated and a reference count of 1. This avoids frequent reallocation,
	 * if you are going to add many pointers to the array. Note however that the size
	 * of the array is still 0.
	 * Params:
	 * reservedSize = number of pointers preallocated.
	 * Returns:the new GPtrArray.
	 */
	public static PtrArray sizedNew(uint reservedSize);
	
	/**
	 * Creates a new GPtrArray with a reference count of 1 and use element_free_func
	 * for freeing each element when the array is destroyed either via
	 * g_ptr_array_unref(), when g_ptr_array_free() is called with free_segment
	 * set to TRUE or when removing elements.
	 * Since 2.22
	 * Params:
	 * elementFreeFunc =  A function to free elements with destroy array or NULL.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GDestroyNotify elementFreeFunc);
	
	/**
	 * Sets a function for freeing each element when array is destroyed
	 * either via g_ptr_array_unref(), when g_ptr_array_free() is called
	 * with free_segment set to TRUE or when removing elements.
	 * Since 2.22
	 * Params:
	 * elementFreeFunc =  A function to free elements with destroy array or NULL.
	 */
	public void setFreeFunc(GDestroyNotify elementFreeFunc);
	
	/**
	 * Atomically increments the reference count of array by one. This
	 * function is MT-safe and may be called from any thread.
	 * Since 2.22
	 * Returns: The passed in GPtrArray.
	 */
	public PtrArray doref();
	
	/**
	 * Atomically decrements the reference count of array by one. If the
	 * reference count drops to 0, the effect is the same as calling
	 * g_ptr_array_free() with free_segment set to TRUE. This function
	 * is MT-safe and may be called from any thread.
	 * Since 2.22
	 */
	public void unref();
	
	/**
	 * Adds a pointer to the end of the pointer array.
	 * The array will grow in size automatically if necessary.
	 * Params:
	 * data = the pointer to add.
	 */
	public void add(void* data);
	
	/**
	 * Removes the first occurrence of the given pointer from the pointer array.
	 * The following elements are moved down one place.
	 * If array has a non-NULL GDestroyNotify function it is called for
	 * the removed element.
	 * It returns TRUE if the pointer was removed, or FALSE if the pointer
	 * was not found.
	 * Params:
	 * data = the pointer to remove.
	 * Returns:%TRUE if the pointer is removed. FALSE if the pointer is not foundin the array.
	 */
	public int remove(void* data);
	
	/**
	 * Removes the pointer at the given index from the pointer array.
	 * The following elements are moved down one place.
	 * If array has a non-NULL GDestroyNotify function it is called for
	 * the removed element.
	 * Params:
	 * index = the index of the pointer to remove.
	 * Returns:the pointer which was removed.
	 */
	public void* removeIndex(uint index);
	
	/**
	 * Removes the first occurrence of the given pointer from the pointer array.
	 * The last element in the array is used to fill in the space, so this function
	 * does not preserve the order of the array. But it is faster than
	 * g_ptr_array_remove().
	 * If array has a non-NULL GDestroyNotify function it is called for
	 * the removed element.
	 * It returns TRUE if the pointer was removed, or FALSE if the pointer
	 * was not found.
	 * Params:
	 * data = the pointer to remove.
	 * Returns:%TRUE if the pointer was found in the array.
	 */
	public int removeFast(void* data);

	/**
	 * Removes the pointer at the given index from the pointer array.
	 * The last element in the array is used to fill in the space, so this function
	 * does not preserve the order of the array. But it is faster than
	 * g_ptr_array_remove_index().
	 * If array has a non-NULL GDestroyNotify function it is called for
	 * the removed element.
	 * Params:
	 * index = the index of the pointer to remove.
	 * Returns:the pointer which was removed.
	 */
	public void* removeIndexFast(uint index);
	
	/**
	 * Removes the given number of pointers starting at the given index from a
	 * GPtrArray. The following elements are moved to close the gap.
	 * If array has a non-NULL GDestroyNotify function it is called for
	 * the removed elements.
	 * Since 2.4
	 * Params:
	 * index = the index of the first pointer to remove.
	 * length = the number of pointers to remove.
	 */
	public void removeRange(uint index, uint length);
	
	/**
	 * Sorts the array, using compare_func which should be a qsort()-style comparison
	 * function (returns less than zero for first arg is less than second arg,
	 * zero for equal, greater than zero if irst arg is greater than second arg).
	 * If two array elements compare equal, their order in the sorted array is
	 * undefined.
	 * Note
	 * The comparison function for g_ptr_array_sort() doesn't take the pointers
	 * from the array as arguments, it takes pointers to the pointers in the array.
	 * Params:
	 * compareFunc = comparison function.
	 */
	public void sort(GCompareFunc compareFunc);
	
	/**
	 * Like g_ptr_array_sort(), but the comparison function has an extra user data
	 * argument.
	 * Note
	 * The comparison function for g_ptr_array_sort_with_data() doesn't take the
	 * pointers from the array as arguments, it takes pointers to the pointers in
	 * the array.
	 * Params:
	 * compareFunc = comparison function.
	 * userData = data to pass to compare_func.
	 */
	public void sortWithData(GCompareDataFunc compareFunc, void* userData);
	
	/**
	 * Sets the size of the array. When making the array larger, newly-added
	 * elements will be set to NULL. When making it smaller, if array has a
	 * non-NULL GDestroyNotify function then it will be called for the
	 * removed elements.
	 * Params:
	 * length = the new length of the pointer array.
	 */
	public void setSize(int length);
	
	/**
	 * Frees the memory allocated for the GPtrArray.
	 * If free_seg is TRUE it frees the memory block holding the elements
	 * as well. Pass FALSE if you want to free the GPtrArray wrapper but preserve
	 * the underlying array for use elsewhere. If the reference count of array
	 * is greater than one, the GPtrArray wrapper is preserved but the size of
	 * array will be set to zero.
	 * Note
	 * If array contents point to dynamically-allocated memory, they should
	 * be freed separately if free_seg is TRUE and no GDestroyNotify
	 * function has been set for array.
	 * Params:
	 * freeSeg = if TRUE the actual pointer array is freed as well.
	 * Returns:the pointer array if free_seg is FALSE, otherwise NULL.	The pointer array should be freed using g_free().
	 */
	public void** free(int freeSeg);
	
	/**
	 * Calls a function for each element of a GPtrArray.
	 * Since 2.4
	 * Params:
	 * func =  the function to call for each array element
	 * userData =  user data to pass to the function
	 */
	public void foreac(GFunc func, void* userData);
}