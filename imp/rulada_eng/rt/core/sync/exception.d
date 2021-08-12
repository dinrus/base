/**
 * The barrier module provides a primitive for synchronizing the progress of
 * a group of threads.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 */
module rt.core.exception;


/**
 * Base class for synchronization exceptions.
 */
class SyncException : Exception
{
    this( string msg )
    {
        super( msg );
    }
}
