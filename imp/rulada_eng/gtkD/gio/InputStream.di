module gtkD.gio.InputStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.AsyncResultIF;
private import gtkD.gio.Cancellable;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GInputStream has functions to read from a stream (g_input_stream_read()),
 * to close a stream (g_input_stream_close()) and to skip some content
 * (g_input_stream_skip()).
 * To copy the content of an input stream to an output stream without
 * manually handling the reads and writes, use g_output_stream_splice().
 * All of these functions have async variants too.
 */
public class InputStream : ObjectG
{
	
	/** the main Gtk struct */
	protected GInputStream* gInputStream;
	
	
	public GInputStream* getInputStreamStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GInputStream* gInputStream);
	
	/**
	 */
	
	/**
	 * Tries to read count bytes from the stream into the buffer starting at
	 * buffer. Will block during this read.
	 * If count is zero returns zero and does nothing. A value of count
	 * larger than G_MAXSSIZE will cause a G_IO_ERROR_INVALID_ARGUMENT error.
	 * On success, the number of bytes read into the buffer is returned.
	 * It is not an error if this is not the same as the requested size, as it
	 * can happen e.g. near the end of a file. Zero is returned on end of file
	 * (or if count is zero), but never otherwise.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned. If an
	 * operation was partially finished when the operation was cancelled the
	 * partial result will be returned, without an error.
	 * On error -1 is returned and error is set accordingly.
	 * Params:
	 * buffer =  a buffer to read data into (which should be at least count bytes long).
	 * count =  the number of bytes that will be read from the stream
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: Number of bytes read, or -1 on error
	 * Throws: GException on failure.
	 */
	public int read(void* buffer, uint count, Cancellable cancellable);
	
	/**
	 * Tries to read count bytes from the stream into the buffer starting at
	 * buffer. Will block during this read.
	 * This function is similar to g_input_stream_read(), except it tries to
	 * read as many bytes as requested, only stopping on an error or end of stream.
	 * On a successful read of count bytes, or if we reached the end of the
	 * stream, TRUE is returned, and bytes_read is set to the number of bytes
	 * read into buffer.
	 * If there is an error during the operation FALSE is returned and error
	 * is set to indicate the error status, bytes_read is updated to contain
	 * the number of bytes read into buffer before the error occurred.
	 * Params:
	 * buffer =  a buffer to read data into (which should be at least count bytes long).
	 * count =  the number of bytes that will be read from the stream
	 * bytesRead =  location to store the number of bytes that was read from the stream
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE on success, FALSE if there was an error
	 * Throws: GException on failure.
	 */
	public int readAll(void* buffer, uint count, out uint bytesRead, Cancellable cancellable);

	/**
	 * Tries to skip count bytes from the stream. Will block during the operation.
	 * This is identical to g_input_stream_read(), from a behaviour standpoint,
	 * but the bytes that are skipped are not returned to the user. Some
	 * streams have an implementation that is more efficient than reading the data.
	 * This function is optional for inherited classes, as the default implementation
	 * emulates it using read.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned. If an
	 * operation was partially finished when the operation was cancelled the
	 * partial result will be returned, without an error.
	 * Params:
	 * count =  the number of bytes that will be skipped from the stream
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: Number of bytes skipped, or -1 on error
	 * Throws: GException on failure.
	 */
	public int skip(uint count, Cancellable cancellable);
	
	/**
	 * Closes the stream, releasing resources related to it.
	 * Once the stream is closed, all other operations will return G_IO_ERROR_CLOSED.
	 * Closing a stream multiple times will not return an error.
	 * Streams will be automatically closed when the last reference
	 * is dropped, but you might want to call this function to make sure
	 * resources are released as early as possible.
	 * Some streams might keep the backing store of the stream (e.g. a file descriptor)
	 * open after the stream is closed. See the documentation for the individual
	 * stream for details.
	 * On failure the first error that happened will be reported, but the close
	 * operation will finish as much as possible. A stream that failed to
	 * close will still return G_IO_ERROR_CLOSED for all operations. Still, it
	 * is important to check and report the error to the user.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Cancelling a close will still leave the stream closed, but some streams
	 * can use a faster close that doesn't block to e.g. check errors.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE on success, FALSE on failure
	 * Throws: GException on failure.
	 */
	public int close(Cancellable cancellable);
	
	/**
	 * Request an asynchronous read of count bytes from the stream into the buffer
	 * starting at buffer. When the operation is finished callback will be called.
	 * You can then call g_input_stream_read_finish() to get the result of the
	 * operation.
	 * During an async request no other sync and async calls are allowed on stream, and will
	 * result in G_IO_ERROR_PENDING errors.
	 * A value of count larger than G_MAXSSIZE will cause a G_IO_ERROR_INVALID_ARGUMENT error.
	 * On success, the number of bytes read into the buffer will be passed to the
	 * callback. It is not an error if this is not the same as the requested size, as it
	 * can happen e.g. near the end of a file, but generally we try to read
	 * as many bytes as requested. Zero is returned on end of file
	 * (or if count is zero), but never otherwise.
	 * Any outstanding i/o request with higher priority (lower numerical value) will
	 * be executed before an outstanding request with lower priority. Default
	 * priority is G_PRIORITY_DEFAULT.
	 * The asyncronous methods have a default fallback that uses threads to implement
	 * asynchronicity, so they are optional for inheriting classes. However, if you
	 * override one you must override all.
	 * Params:
	 * buffer =  a buffer to read data into (which should be at least count bytes long).
	 * count =  the number of bytes that will be read from the stream
	 * ioPriority =  the I/O priority
	 * of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  callback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void readAsync(void* buffer, uint count, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous stream read operation.
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: number of bytes read in, or -1 on error.
	 * Throws: GException on failure.
	 */
	public int readFinish(AsyncResultIF result);
	
	/**
	 * Request an asynchronous skip of count bytes from the stream.
	 * When the operation is finished callback will be called.
	 * You can then call g_input_stream_skip_finish() to get the result of the
	 * operation.
	 * During an async request no other sync and async calls are allowed, and will
	 * result in G_IO_ERROR_PENDING errors.
	 * A value of count larger than G_MAXSSIZE will cause a G_IO_ERROR_INVALID_ARGUMENT error.
	 * On success, the number of bytes skipped will be passed to the
	 * callback. It is not an error if this is not the same as the requested size, as it
	 * can happen e.g. near the end of a file, but generally we try to skip
	 * as many bytes as requested. Zero is returned on end of file
	 * (or if count is zero), but never otherwise.
	 * Any outstanding i/o request with higher priority (lower numerical value) will
	 * be executed before an outstanding request with lower priority. Default
	 * priority is G_PRIORITY_DEFAULT.
	 * The asyncronous methods have a default fallback that uses threads to implement
	 * asynchronicity, so they are optional for inheriting classes. However, if you
	 * override one you must override all.
	 * Params:
	 * count =  the number of bytes that will be skipped from the stream
	 * ioPriority =  the I/O priority
	 * of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  callback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void skipAsync(uint count, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes a stream skip operation.
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: the size of the bytes skipped, or -1 on error.
	 * Throws: GException on failure.
	 */
	public int skipFinish(AsyncResultIF result);
	
	/**
	 * Requests an asynchronous closes of the stream, releasing resources related to it.
	 * When the operation is finished callback will be called.
	 * You can then call g_input_stream_close_finish() to get the result of the
	 * operation.
	 * For behaviour details see g_input_stream_close().
	 * The asyncronous methods have a default fallback that uses threads to implement
	 * asynchronicity, so they are optional for inheriting classes. However, if you
	 * override one you must override all.
	 * Params:
	 * ioPriority =  the I/O priority
	 * of the request.
	 * cancellable =  optional cancellable object
	 * callback =  callback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void closeAsync(int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes closing a stream asynchronously, started from g_input_stream_close_async().
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if the stream was closed successfully.
	 * Throws: GException on failure.
	 */
	public int closeFinish(AsyncResultIF result);
	
	/**
	 * Checks if an input stream is closed.
	 * Returns: TRUE if the stream is closed.
	 */
	public int isClosed();
	
	/**
	 * Checks if an input stream has pending actions.
	 * Returns: TRUE if stream has pending actions.
	 */
	public int hasPending();
	
	/**
	 * Sets stream to have actions pending. If the pending flag is
	 * already set or stream is closed, it will return FALSE and set
	 * error.
	 * Returns: TRUE if pending was previously unset and is now set.
	 * Throws: GException on failure.
	 */
	public int setPending();
	
	/**
	 * Clears the pending flag on stream.
	 */
	public void clearPending();
}
