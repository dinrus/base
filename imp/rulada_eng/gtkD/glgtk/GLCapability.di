module gtkD.glgtk.GLCapability;

public  import gtkD.gtkglc.glgtktypes;

private import gtkD.gtkglc.glgtk;
private import gtkD.glib.ConstructionException;






// SNEAKY MIXIN PROBLEM:
//
// These need to be public imports
// or GLCompatibility will not compile
// as a mixin in other modules!

// May as well be explicit about it:


public import gtkD.glgtk.GLWidget;
private import gtkD.glgdk.GLDrawable;
public import gtkD.gdk.Event;

version(Dinrus)	private import gc;
version(Rulada) private import std.gc;



template GLCapability()
{

	GLfloat width = 0;
	GLfloat height = 0;

	GLfloat getGLWidth()
	{
		return width;
	}
	GLfloat getGLHeight()
	{
		return height;
	}


	/**
	 * Sets the GL capabilities for the widget
	 */
	bool setGLCapability(GLConfig glConfig = null, int renderType = GLRenderType.RGBA_TYPE)
	{
		if ( glConfig is null )
		{
			glConfig = new GLConfig(
			GLConfigMode.MODE_RGB
			| GLConfigMode.MODE_DEPTH
			| GLConfigMode.MODE_DOUBLE,
			GLConfigMode.MODE_RGB
			| GLConfigMode.MODE_DEPTH
			);
		}
		bool ok = setGLCapability(this, glConfig, null, true, renderType);

		return ok;
	}

	/**
	 * Set the GL capabilities for the widget
	 */
	bool setGLCapability(Widget widget, GLConfig glConfig, GLContext shareList, bool direct, int renderType)
	{
		GLWidget.setGLCapability(widget, glConfig, shareList, direct, renderType);

		addOnRealize(&realizeFrame);
		addOnUnrealize(&realizeFrame);
		addOnExpose(&exposeFrame);
		addOnConfigure(&configureFrame);
		addOnMap(&mapFrame);
		addOnUnmap(&unmapFrame);
		addOnVisibilityNotify(&visibilityFrame);
		return true;
	}

	/**
	 * The widget should use this method to redraw it self at any time
	 */
	public bool glDrawFrame()
	{
		return glDrawFrame(this);
	}

	/**
	 * The application should use this method to redraw the scene at any time
	 */
	bool glDrawFrame(Widget widget)
	{
		//printf("GLCapabilityT.realizeFrame \n" );
		GLContext context = GLWidget.getGLContext(widget);
		GLDrawable drawable = GLWidget.getGLDrawable(widget);

		/*** OpenGL BEGIN ***/
		if ( !drawable.glBegin(context) )
		{
			return false;
		}

		/*** do user actions ***/
		bool consumeEvent = typeof(this).drawGL(null);

		/*** flush ***/
		if ( drawable.isDoubleBuffered() )
		{
			drawable.swapBuffers();
		}
		else
		{
			glFlush ();
		}

		drawable.glEnd();
		/*** OpenGL END ***/
		return true;

	}

	bool alreadyRealized;

	bool getAlreadyRealized()
	{
		return alreadyRealized;
	}

	void realizeFrame(Widget widget)
	{
		alreadyRealized = true;

		//printf("GLCapabilityT.realizeFrame \n" );
		GLContext context = GLWidget.getGLContext(widget);
		GLDrawable drawable = GLWidget.getGLDrawable(widget);

		/*** OpenGL BEGIN ***/
		if ( !drawable.glBegin(context) )
		{
			return;
		}

		/*** do user actions ***/
		bool consumeEvent = typeof(this).initGL();

		/*** flush ***/
		if ( drawable.isDoubleBuffered() )
		{
			drawable.swapBuffers();
		}
		else
		{
			glFlush ();
		}

		drawable.glEnd();
		/*** OpenGL END ***/

		//return consumeEvent;
	}

	bool exposeFrame(GdkEventExpose* event, Widget widget)
	{
		//printf("GLCapabilityT.exposeFrame exposeFrame\n" );
		GLContext context = GLWidget.getGLContext(widget);
		GLDrawable drawable = GLWidget.getGLDrawable(widget);

		/*** OpenGL BEGIN ***/
		if ( !drawable.glBegin(context) )
		{
			return false;
		}

		/*** do user actions ***/
		bool consumeEvent = typeof(this).drawGL(event);

		/*** flush ***/
		if ( drawable.isDoubleBuffered() )
		{
			drawable.swapBuffers();
		}
		else
		{
			glFlush ();
		}

		drawable.glEnd();
		/*** OpenGL END ***/

		return consumeEvent;
	}

	bool configureFrame(GdkEventConfigure* event, Widget widget)
	{
		if ( event != null )
		{
			width = event.width;
			height = event.height;
		}
		version(Tango) tango.core.Memory.GC.disable();
		else version(D_Version2) core.memory.GC.disable();
		version(Rulada) std.gc.disable();
		version(Dinrus) смОтключи();
		//writefln("configureFrame 1");
		//printf("GLCapabilityT.configureFrame \n" );
		GLContext context = GLWidget.getGLContext(widget);
		GLDrawable drawable = GLWidget.getGLDrawable(widget);

		/*** OpenGL BEGIN ***/
		if ( !drawable.glBegin(context) )
		{
			return false;
		}

		//writefln("configureFrame 2");
		/*** do user actions ***/
		bool consumeEvent = typeof(this).resizeGL(event);
		//printf("here\n");
		//writefln("configureFrame 3");

		/*** flush ***/
		if ( drawable.isDoubleBuffered() )
		{
			//writefln("configureFrame 4");
			drawable.swapBuffers();
			//writefln("configureFrame 5");
		}
		else
		{
			//writefln("configureFrame 6");
			glFlush ();
			//writefln("configureFrame 7");
		}

		//writefln("configureFrame 8");
		drawable.glEnd();
		//writefln("configureFrame 9");
		/*** OpenGL END ***/

        version(Tango) tango.core.Memory.GC.enable();
		else version(D_Version2) core.memory.GC.enable();
		version(Rulada) std.gc.enable();
		version(Dinrus) смВключи();

		return consumeEvent;
	}

	void mapFrame(Widget widget)
	{
		//printf("GLCapabilityT.mapFrame \n" );
		GLContext context = GLWidget.getGLContext(widget);
		GLDrawable drawable = GLWidget.getGLDrawable(widget);

		/*** OpenGL BEGIN ***/
		if ( !drawable.glBegin(context) )
		{
			return;
		}

		/*** do user actions ***/
		bool consumeEvent = typeof(this).onMap();

		/*** flush ***/
		if ( drawable.isDoubleBuffered() )
		{
			drawable.swapBuffers();
		}
		else
		{
			glFlush ();
		}

		drawable.glEnd();
		/*** OpenGL END ***/

		//return consumeEvent;
	}

	void unmapFrame(Widget widget)
	{
		//printf("GLCapabilityT.unmapFrame \n" );
		GLContext context = GLWidget.getGLContext(widget);
		GLDrawable drawable = GLWidget.getGLDrawable(widget);

		/*** OpenGL BEGIN ***/
		if ( !drawable.glBegin(context) )
		{
			return;
		}

		/*** do user actions ***/
		bool consumeEvent = typeof(this).onUnmap();

		/*** flush ***/
		if ( drawable.isDoubleBuffered() )
		{
			drawable.swapBuffers();
		}
		else
		{
			glFlush ();
		}

		drawable.glEnd();
		/*** OpenGL END ***/

		//return consumeEvent;
	}

	bool visibilityFrame(GdkEventVisibility* event, Widget widget)
	{
		//printf("GLCapabilityT.visibilityFrame \n" );
		GLContext context = GLWidget.getGLContext(widget);
		GLDrawable drawable = GLWidget.getGLDrawable(widget);

		/*** OpenGL BEGIN ***/
		if ( !drawable.glBegin(context) )
		{
			return false;
		}

		/*** do user actions ***/
		bool consumeEvent = typeof(this).onVisibility(event);

		/*** flush ***/
		if ( drawable.isDoubleBuffered() )
		{
			drawable.swapBuffers();
		}
		else
		{
			glFlush ();
		}

		drawable.glEnd();
		/*** OpenGL END ***/

		return consumeEvent;
	}

	bool onMap()
	{
		//printf("GLCapabilityT.map \n" );
		return true;
	}

	bool onUnmap()
	{
		//printf("GLCapabilityT.unmap \n" );
		return true;
	}

	bool onVisibility(GdkEventVisibility* event)
	{
		//printf("GLCapabilityT.visibility \n" );
		return true;
	}
}

/**
 */

