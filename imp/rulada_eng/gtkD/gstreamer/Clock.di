module gtkD.gstreamer.Clock;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.gstreamer.ObjectGst;

/**
 * Description
 * GStreamer uses a global clock to synchronize the plugins in a pipeline.
 * Different clock implementations are possible by implementing this abstract
 * base class.
 * The GstClock returns a monotonically increasing time with the method
 * gst_clock_get_time(). Its accuracy and base time depend on the specific
 * clock implementation but time is always expressed in nanoseconds. Since the
 * baseline of the clock is undefined, the clock time returned is not
 * meaningful in itself, what matters are the deltas between two clock times.
 * The time returned by a clock is called the absolute time.
 * The pipeline uses the clock to calculate the stream time. Usually all
 * renderers synchronize to the global clock using the buffer timestamps, the
 * newsegment events and the element's base time, see GstPipeline.
 * A clock implementation can support periodic and single shot clock
 * notifications both synchronous and asynchronous.
 * One first needs to create a GstClockID for the periodic or single shot
 * notification using gst_clock_new_single_shot_id() or
 * gst_clock_new_periodic_id().
 * To perform a blocking wait for the specific time of the GstClockID use the
 * gst_clock_id_wait(). To receive a callback when the specific time is reached
 * in the clock use gst_clock_id_wait_async(). Both these calls can be
 * interrupted with the gst_clock_id_unschedule() call. If the blocking wait is
 * unscheduled a return value of GST_CLOCK_UNSCHEDULED is returned.
 * Periodic callbacks scheduled async will be repeadedly called automatically
 * until it is unscheduled. To schedule a sync periodic callback,
 * gst_clock_id_wait() should be called repeadedly.
 * The async callbacks can happen from any thread, either provided by the core
 * or from a streaming thread. The application should be prepared for this.
 * A GstClockID that has been unscheduled cannot be used again for any wait
 * operation, a new GstClockID should be created and the old unscheduled one
 * should be destroyed wirth gst_clock_id_unref().
 * It is possible to perform a blocking wait on the same GstClockID from
 * multiple threads. However, registering the same GstClockID for multiple
 * async notifications is not possible, the callback will only be called for
 * the thread registering the entry last.
 * None of the wait operations unref the GstClockID, the owner is responsible
 * for unreffing the ids itself. This holds for both periodic and single shot
 * notifications. The reason being that the owner of the GstClockID has to
 * keep a handle to the GstClockID to unblock the wait on FLUSHING events or
 * state changes and if the entry would be unreffed automatically, the handle
 * might become invalid without any notification.
 * These clock operations do not operate on the stream time, so the callbacks
 * will also occur when not in PLAYING state as if the clock just keeps on
 * running. Some clocks however do not progress when the element that provided
 * the clock is not PLAYING.
 * When a clock has the GST_CLOCK_FLAG_CAN_SET_MASTER flag set, it can be
 * slaved to another GstClock with the gst_clock_set_master(). The clock will
 * then automatically be synchronized to this master clock by repeadedly
 * sampling the master clock and the slave clock and recalibrating the slave
 * clock with gst_clock_set_calibration(). This feature is mostly useful for
 * plugins that have an internal clock but must operate with another clock
 * selected by the GstPipeline. They can track the offset and rate difference
 * of their internal clock relative to the master clock by using the
 * gst_clock_get_calibration() function.
 * The master/slave synchronisation can be tuned with the "timeout", "window-size"
 * and "window-threshold" properties. The "timeout" property defines the interval
 * to sample the master clock and run the calibration functions.
 * "window-size" defines the number of samples to use when calibrating and
 * "window-threshold" defines the minimum number of samples before the
 * calibration is performed.
 * Last reviewed on 2006-08-11 (0.10.10)
 */
public class Clock : ObjectGst
{
	
	/** the main Gtk struct */
	protected GstClock* gstClock;
	
	
	public GstClock* getClockStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstClock* gstClock);
	
	/**
	 */
	
	/**
	 * The time master of the master clock and the time slave of the slave
	 * clock are added to the list of observations. If enough observations
	 * are available, a linear regression algorithm is run on the
	 * observations and clock is recalibrated.
	 * If this functions returns TRUE, r_squared will contain the
	 * correlation coefficient of the interpollation. A value of 1.0
	 * means a perfect regression was performed. This value can
	 * be used to control the sampling frequency of the master and slave
	 * clocks.
	 * Params:
	 * slave =  a time on the slave
	 * master =  a time on the master
	 * rSquared =  a pointer to hold the result
	 * Returns: TRUE if enough observations were added to run the regression algorithm.MT safe.
	 */
	public int addObservation(GstClockTime slave, GstClockTime master, double* rSquared);
	
	/**
	 * Set master as the master clock for clock. clock will be automatically
	 * calibrated so that gst_clock_get_time() reports the same time as the
	 * master clock.
	 * A clock provider that slaves its clock to a master can get the current
	 * calibration values with gst_clock_get_calibration().
	 * master can be NULL in which case clock will not be slaved anymore. It will
	 * however keep reporting its time adjusted with the last configured rate
	 * and time offsets.
	 * Params:
	 * master =  a master GstClock
	 * Returns: TRUE if the clock is capable of being slaved to a master clock. Trying to set a master on a clock without the GST_CLOCK_FLAG_CAN_SET_MASTER flag will make this function return FALSE.MT safe.
	 */
	public int setMaster(Clock master);
	
	/**
	 * Get the master clock that clock is slaved to or NULL when the clock is
	 * not slaved to any master clock.
	 * Returns: a master GstClock or NULL when this clock is not slaved to a masterclock. Unref after usage.MT safe.
	 */
	public Clock getMaster();
	
	/**
	 * Set the accuracy of the clock. Some clocks have the possibility to operate
	 * with different accuracy at the expense of more resource usage. There is
	 * normally no need to change the default resolution of a clock. The resolution
	 * of a clock can only be changed if the clock has the
	 * GST_CLOCK_FLAG_CAN_SET_RESOLUTION flag set.
	 * Params:
	 * resolution =  The resolution to set
	 * Returns: the new resolution of the clock.
	 */
	public GstClockTime setResolution(GstClockTime resolution);
	
	/**
	 * Get the accuracy of the clock. The accuracy of the clock is the granularity
	 * of the values returned by gst_clock_get_time().
	 * Returns: the resolution of the clock in units of GstClockTime.MT safe.
	 */
	public GstClockTime getResolution();
	
	/**
	 * Gets the current time of the given clock. The time is always
	 * monotonically increasing and adjusted according to the current
	 * offset and rate.
	 * Returns: the time of the clock. Or GST_CLOCK_TIME_NONE whengiving wrong input.MT safe.
	 */
	public GstClockTime getTime();
	
	/**
	 * Get a GstClockID from clock to trigger a single shot
	 * notification at the requested time. The single shot id should be
	 * unreffed after usage.
	 * Params:
	 * time =  the requested time
	 * Returns: A GstClockID that can be used to request the time notification.MT safe.
	 */
	public GstClockID newSingleShotId(GstClockTime time);
	
	/**
	 * Get an ID from clock to trigger a periodic notification.
	 * The periodeic notifications will be start at time start_time and
	 * will then be fired with the given interval. id should be unreffed
	 * after usage.
	 * Params:
	 * startTime =  the requested start time
	 * interval =  the requested interval
	 * Returns: A GstClockID that can be used to request the time notification.MT safe.
	 */
	public GstClockID newPeriodicId(GstClockTime startTime, GstClockTime interval);
	
	/**
	 * Gets the current internal time of the given clock. The time is returned
	 * unadjusted for the offset and the rate.
	 * Returns: the internal time of the clock. Or GST_CLOCK_TIME_NONE whengiving wrong input.MT safe.
	 */
	public GstClockTime getInternalTime();
	
	/**
	 * Converts the given internal clock time to the real time, adjusting for the
	 * rate and reference time set with gst_clock_set_calibration() and making sure
	 * that the returned time is increasing. This function should be called with the
	 * clock's OBJECT_LOCK held and is mainly used by clock subclasses.
	 * Params:
	 * internal =  a clock time
	 * Returns: the converted time of the clock.MT safe.
	 */
	public GstClockTime adjustUnlocked(GstClockTime internal);
	
	/**
	 * Gets the internal rate and reference time of clock. See
	 * gst_clock_set_calibration() for more information.
	 * internal, external, rate_num, and rate_denom can be left NULL if the
	 * caller is not interested in the values.
	 * MT safe.
	 * Params:
	 * internal =  a location to store the internal time
	 * external =  a location to store the external time
	 * rateNum =  a location to store the rate numerator
	 * rateDenom =  a location to store the rate denominator
	 */
	public void getCalibration(GstClockTime* internal, GstClockTime* external, GstClockTime* rateNum, GstClockTime* rateDenom);
	
	/**
	 * Adjusts the rate and time of clock. A rate of 1/1 is the normal speed of
	 * the clock. Values bigger than 1/1 make the clock go faster.
	 * internal and external are calibration parameters that arrange that
	 * gst_clock_get_time() should have been external at internal time internal.
	 * This internal time should not be in the future; that is, it should be less
	 * than the value of gst_clock_get_internal_time() when this function is called.
	 * Subsequent calls to gst_clock_get_time() will return clock times computed as
	 * Params:
	 * internal =  a reference internal time
	 * external =  a reference external time
	 * rateNum =  the numerator of the rate of the clock relative to its
	 *  internal time
	 * rateDenom =  the denominator of the rate of the clock
	 */
	public void setCalibration(GstClockTime internal, GstClockTime external, GstClockTime rateNum, GstClockTime rateDenom);
	
	/**
	 * Get the time of the clock ID
	 * Params:
	 * id =  The GstClockID to query
	 * Returns: the time of the given clock id.MT safe.
	 */
	public static GstClockTime idGetTime(GstClockID id);
	
	/**
	 * Perform a blocking wait on id.
	 * id should have been created with gst_clock_new_single_shot_id()
	 * or gst_clock_new_periodic_id() and should not have been unscheduled
	 * with a call to gst_clock_id_unschedule().
	 * If the jitter argument is not NULL and this function returns GST_CLOCK_OK
	 * or GST_CLOCK_EARLY, it will contain the difference
	 * against the clock and the time of id when this method was
	 * called.
	 * Positive values indicate how late id was relative to the clock
	 * (in which case this function will return GST_CLOCK_EARLY).
	 * Negative values indicate how much time was spent waiting on the clock
	 * before this function returned.
	 * Params:
	 * id =  The GstClockID to wait on
	 * jitter =  A pointer that will contain the jitter, can be NULL.
	 * Returns: the result of the blocking wait. GST_CLOCK_EARLY will be returnedif the current clock time is past the time of id, GST_CLOCK_OK if id was scheduled in time. GST_CLOCK_UNSCHEDULED if id was unscheduled with gst_clock_id_unschedule().MT safe.
	 */
	public static GstClockReturn idWait(GstClockID id, GstClockTimeDiff* jitter);
	
	/**
	 * Register a callback on the given GstClockID id with the given
	 * function and user_data. When passing a GstClockID with an invalid
	 * time to this function, the callback will be called immediatly
	 * with a time set to GST_CLOCK_TIME_NONE. The callback will
	 * be called when the time of id has been reached.
	 * Params:
	 * id =  a GstClockID to wait on
	 * func =  The callback function
	 * userData =  User data passed in the calback
	 * Returns: the result of the non blocking wait.MT safe.
	 */
	public static GstClockReturn idWaitAsync(GstClockID id, GstClockCallback func, void* userData);
	
	/**
	 * Cancel an outstanding request with id. This can either
	 * be an outstanding async notification or a pending sync notification.
	 * After this call, id cannot be used anymore to receive sync or
	 * async notifications, you need to create a new GstClockID.
	 * MT safe.
	 * Params:
	 * id =  The id to unschedule
	 */
	public static void idUnschedule(GstClockID id);
	
	/**
	 * Compares the two GstClockID instances. This function can be used
	 * as a GCompareFunc when sorting ids.
	 * Params:
	 * id1 =  A GstClockID
	 * id2 =  A GstClockID to compare with
	 * Returns: negative value if a < b; zero if a = b; positive value if a > bMT safe.
	 */
	public static int idCompareFunc(void* id1, void* id2);
	
	/**
	 * Increase the refcount of given id.
	 * Params:
	 * id =  The GstClockID to ref
	 * Returns: The same GstClockID with increased refcount.MT safe.
	 */
	public static GstClockID idRef(GstClockID id);
	
	/**
	 * Unref given id. When the refcount reaches 0 the
	 * GstClockID will be freed.
	 * MT safe.
	 * Params:
	 * id =  The GstClockID to unref
	 */
	public static void idUnref(GstClockID id);
}
