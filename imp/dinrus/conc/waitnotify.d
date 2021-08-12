/** \file waitnotify.d
 *  \brief Support жди/уведоми synchronization and жди/уведоми/уведомиВсех
 *
 *  This module exports a mixin ЖдиУведоми for жди() and
 *  уведоми(), a mixin ЖдиУведомиВсех that implements
 *  жди() and уведомиВсех() and the subclasses ОбъектЖдиУведоми
 *  and ОбъектЖдиУведомиВсех.
 *
 *  In general the user model is similar to Java's
 *  жди/уведоми/уведомиВсех user model except that уведоми and уведомиВсех
 *  are separate mixins.
 */

/*  Originally written by Ben Hinkle for use in the D port of Doug Lea's
 *  concurrent Java package and released into the public domain.
 *  This may be used for any purposes whatsoever without acknowledgment.
 */

module conc.waitnotify;

import conc.sync;

private import thread;

/////////////////////////////////////////////////////////
//
//  Platform and compiler-specific implementation of
//  ЖдиУведоми and ЖдиУведомиВсех
//
/////////////////////////////////////////////////////////

version (Windows)
 {
  version = ATOMIC; 

  private проц ждиВин32Релиз(HANDLE событие, Объект объ, бцел таймаут);

  private struct ЖдиСообщиРелиз 
  {
    private HANDLE событие;

    проц иниц() ;

    проц разрушь() ;

    проц жди(Объект объ) ;

    проц жди(Объект объ, бцел таймаут);

    проц уведоми();
  }

  private struct ЖдиСообщиВсемРелиз
   {
    private HANDLE событие;

    проц иниц();

    проц разрушь() ;

    проц жди(Объект объ);

    проц жди(Объект объ, бцел таймаут) ;

    проц уведомиВсех();
  }

 

} 
 version (linux) {


  struct ЖдиСообщиРелиз
   {
    private ubyte[48] cond;    // _pthread_cond_t has sizeof 48

    проц иниц();
    проц разрушь() ;
    проц жди(Объект объ) ;
    проц жди(Объект объ, бцел таймаут);
    проц уведоми() ;

  }

  struct ЖдиСообщиВсемРелиз 
  {
    ЖдиСообщиРелиз wnlock;
    проц иниц() ;
    проц разрушь() ;
    проц жди(Объект объ);
    проц жди(Объект объ, бцел таймаут) ;
    проц уведомиВсех() ;
  }

  
}

/////////////////////////////////////////////////////////
//
//  Platform-independent API for ЖдиУведоми and ЖдиУведомиВсех
//
/////////////////////////////////////////////////////////


/** \class ЖдиУведоми
 * \brief Mixin for supporting жди() and уведоми() synchronization.
 * 
 *  ЖдиУведоми adds support for Java-style жди() and уведоми()
 *  methods. It is similar also to POSIX threading functions cond_wait
 *  and cond_signal.
 *
 *  An example of a class using ЖдиУведоми:
 *  \code
 *    class A {
 *      mixin ЖдиУведоми;
 *      бул done;
 *      this()  { иницЖдиУведоми(); }
 *      ~this() { удалиЖдиУведоми(); }
 *      проц doSomething1() {
 *        synchronized(this) {
 *          ...
 *          while (!done)
 *            жди();
 *          ...
 *        }
 *      }
 *      проц doSomething2() {
 *        synchronized(this) {
 *          ...
 *          done = да;
 *          уведоми();
 *          ...
 *        }
 *      }
 *    }
 *  \endcode
 */
template ЖдиУведоми() {

  ЖдиСообщиРелиз жсЭкз;

  /** Initialize ЖдиУведоми
   */
  проц иницЖдиУведоми() {
    жсЭкз.иниц();
  }

  /** Destroy ЖдиУведоми
   */
  проц удалиЖдиУведоми() {
    жсЭкз.разрушь();
  }

  /** Causes current нить to жди until another нить invokes the уведоми() method.
   *
   * Causes current нить to жди until another нить invokes the
   * уведоми() method method for this замок.
   *
   * The current нить must own the object's monitor. The
   * нить releases ownership of the monitor and waits until another
   * нить notifies threads ждущий on this замок to wake up through a
   * call to the уведоми method. The нить then waits until it can
   * re-obtain ownership of the monitor and resumes execution.
   *
   * This method should only be called by a нить that is the owner
   * of the object's monitor. See the уведоми method for a description
   * of the ways in which a нить can become the owner of a monitor.
   */
  проц жди() {
    жсЭкз.жди(this);
  }


  /** Causes current нить to жди until another нить invokes the уведоми() method.
   *
   * Causes current нить to жди until either another нить invokes
   * the уведоми() method method for this замок, or a specified количество
   * of время has elapsed.
   *
   * The current нить must own the object's monitor. 
   *
   * This method should only be called by a нить that is the owner
   * of the object's monitor. See the уведоми method for a description
   * of the ways in which a нить can become the owner of a monitor.
   *
   * \param бцел таймаут maximum время to жди in milliseconds
   */
  проц жди(бцел таймаут) {
    жсЭкз.жди(this,таймаут);
  }

  /** Wakes up a single нить that is ждущий on this object.
   *
   *  If any threads are ждущий on this замок, one of
   *  them is chosen to be awakened. The choice is arbitrary and
   *  occurs at the discretion of the implementation. A нить waits
   *  on this замок by calling one of the жди methods.
   *
   *  The awakened нить will not be able to proceed until the
   *  current нить relinquishes the замок on the object. The
   *  awakened нить will compete in the usual manner with any
   *  другое threads that might be actively competing to synchronize
   *  on the object; for example, the awakened нить enjoys no
   *  reliable privilege or disadvantage in being the следщ нить to
   *  замок the object.
   *
   *  This method should only be called by a нить that is the
   *  owner of the object's monitor.
   */
  проц уведоми() {
    жсЭкз.уведоми();
  }

}

/** \class ОбъектЖдиУведоми
 * \brief Subclass of Объект with жди() and уведоми() support.
 */
class ОбъектЖдиУведоми {
  mixin ЖдиУведоми;
  this()  { иницЖдиУведоми(); }
  ~this() { удалиЖдиУведоми(); }
}

/** \class ЖдиУведомиВсех
 * \brief Mixin for supporting жди() and уведомиВсех() synchronization.
 * 
 *  ЖдиУведомиВсех adds support for Java-style жди() and уведомиВсех()
 *  methods. It is similar also to POSIX threading functions cond_wait
 *  and cond_broadcast.
 */
template ЖдиУведомиВсех() {
  ЖдиСообщиВсемРелиз жсвЭкз;

  /** Initialize ЖдиУведомиВсех
   */
  проц иницЖдиУведомиВсех() { 
    жсвЭкз.иниц(); 
  }

  /** Destroy ЖдиУведомиВсех
   */
  проц удалиЖдиУведомиВсех() { 
    жсвЭкз.разрушь(); 
  }

  /**  Causes current нить to жди until another нить invokes the уведомиВсех() method.
   *
   *  Same semantics as ЖдиУведоми.жди except that уведомиВсех
   *  will wake up all ждущий threads.
   */
  проц жди() {
    жсвЭкз.жди(this);
  }

  /**  Causes current нить to жди until another нить invokes the уведомиВсех() method.
   *
   *  Same semantics as ЖдиУведоми.жди except that уведомиВсех
   *  will wake up all ждущий threads.
   *
   * \param бцел таймаут maximum время to жди in milliseconds
   */
  проц жди(бцел таймаут) {
    жсвЭкз.жди(this,таймаут);
  }

  /** Wakes up all threads that are ждущий on this object.
   *
   *  Same semantics as ЖдиУведоми.уведоми except that уведомиВсех
   *  will wake up all threads ждущий on this замок. The threads will
   *  compete with другое threads for the object monitor once this
   *  нить releases the monitor.
   */
  проц уведомиВсех() {
    жсвЭкз.уведомиВсех();
  }
}

/** \class ОбъектЖдиУведомиВсех
 * \brief Subclass of Объект with жди() and уведомиВсех() support.
 */
class ОбъектЖдиУведомиВсех {
  mixin ЖдиУведомиВсех;
  this()  { иницЖдиУведомиВсех(); }
  ~this() { удалиЖдиУведомиВсех(); }
}