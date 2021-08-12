module gtkD.pango.PgCairoFontMap;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.pango.PgFontMap;
private import gtkD.pango.PgContext;



private import gtkD.pango.PgFontMap;

/**
 * Description
 * The Cairo library is a
 * vector graphics library with a powerful rendering model. It has such
 * features as anti-aliased primitives, alpha-compositing, and
 * gradients. Multiple backends for Cairo are available, to allow
 * rendering to images, to PDF files, and to the screen on X and on other
 * windowing systems. The functions in this section allow using Pango
 * to render to Cairo surfaces.
 * Using Pango with Cairo is straightforward. A PangoContext created
 * with pango_cairo_font_map_create_context() can be used on any
 * Cairo context (cairo_t), but needs to be updated to match the
 * current transformation matrix and target surface of the Cairo context
 * using pango_cairo_update_context(). The convenience functions
 * pango_cairo_create_layout() and pango_cairo_update_layout() handle
 * the common case where the program doesn't need to manipulate the
 * properties of the PangoContext.
 * When you get the metrics of a layout or of a piece of a layout using
 * functions such as pango_layout_get_extents(), the reported metrics
 * are in user-space coordinates. If a piece of text is 10 units long,
 * and you call cairo_scale (cr, 2.0), it still is more-or-less 10
 * units long. However, the results will be affected by hinting
 * (that is, the process of adjusting the text to look good on the
 * pixel grid), so you shouldn't assume they are completely independent
 * of the current transformation matrix. Note that the basic metrics
 * functions in Pango report results in integer Pango units. To get
 * to the floating point units used in Cairo divide by PANGO_SCALE.
 * Example 1. Using Pango with Cairo
 * #include <math.h>
 * #include <pango/pangogtkD.cairo.h>
 * static void
 * draw_text (cairo_t *cr)
 * {
	 * #define RADIUS 150
	 * #define N_WORDS 10
	 * #define FONT "Sans Bold 27"
	 *  PangoLayout *layout;
	 *  PangoFontDescription *desc;
	 *  int i;
	 *  /+* Center coordinates on the middle of the region we are drawing
	 *  +/
	 *  cairo_translate (cr, RADIUS, RADIUS);
	 *  /+* Create a PangoLayout, set the font and text +/
	 *  layout = pango_cairo_create_layout (cr);
	 *  pango_layout_set_text (layout, "Text", -1);
	 *  desc = pango_font_description_from_string (FONT);
	 *  pango_layout_set_font_description (layout, desc);
	 *  pango_font_description_free (desc);
	 *  /+* Draw the layout N_WORDS times in a circle +/
	 *  for (i = 0; i < N_WORDS; i++)
	 *  {
		 *  int width, height;
		 *  double angle = (360. * i) / N_WORDS;
		 *  double red;
		 *  cairo_save (cr);
		 *  /+* Gradient from red at angle == 60 to blue at angle == 240 +/
		 *  red = (1 + cos ((angle - 60) * G_PI / 180.)) / 2;
		 *  cairo_set_source_rgb (cr, red, 0, 1.0 - red);
		 *  cairo_rotate (cr, angle * G_PI / 180.);
		 *  /+* Inform Pango to re-layout the text with the new transformation +/
		 *  pango_cairo_update_layout (cr, layout);
		 *  pango_layout_get_size (layout, width, height);
		 *  cairo_move_to (cr, - ((double)width / PANGO_SCALE) / 2, - RADIUS);
		 *  pango_cairo_show_layout (cr, layout);
		 *  cairo_restore (cr);
	 *  }
	 *  /+* free the layout object +/
	 *  g_object_unref (layout);
 * }
 * int main (int argc, char **argv)
 * {
	 *  cairo_t *cr;
	 *  char *filename;
	 *  cairo_status_t status;
	 *  cairo_surface_t *surface;
	 *  if (argc != 2)
	 *  {
		 *  g_printerr ("Usage: cairosimple OUTPUT_FILENAME\n");
		 *  return 1;
	 *  }
	 *  filename = argv[1];
	 *  surface = cairo_image_surface_create (CAIRO_FORMAT_ARGB32,
	 * 					2 * RADIUS, 2 * RADIUS);
	 *  cr = cairo_create (surface);
	 *  cairo_set_source_rgb (cr, 1.0, 1.0, 1.0);
	 *  cairo_paint (cr);
	 *  draw_text (cr);
	 *  cairo_destroy (cr);
	 *  status = cairo_surface_write_to_png (surface, filename);
	 *  cairo_surface_destroy (surface);
	 *  if (status != CAIRO_STATUS_SUCCESS)
	 *  {
		 *  g_printerr ("Could not save png to '%s'\n", filename);
		 *  return 1;
	 *  }
	 *  return 0;
 * }
 * Figure 2. Output of Example 1, “Using Pango with Cairo”
 */
public class PgCairoFontMap : PgFontMap
{
	
	/** the main Gtk struct */
	protected PangoCairoFontMap* pangoCairoFontMap;
	
	
	public PangoCairoFontMap* getPgCairoFontMapStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoCairoFontMap* pangoCairoFontMap);
	
	/**
	 */
	
	/**
	 * Gets a default PangoCairoFontMap to use with Cairo.
	 * Note that the type of the returned object will depend
	 * on the particular font backend Cairo was compiled to use;
	 * You generally should only use the PangoFontMap and
	 * PangoCairoFontMap interfaces on the returned object.
	 * The default Cairo fontmap can be changed by using
	 * pango_cairo_font_map_set_default(). This can be used to
	 * change the Cairo font backend that the default fontmap
	 * uses for example.
	 * Since 1.10
	 * Returns: the default Cairo fontmap for Pango. This object is owned by Pango and must not be freed.
	 */
	public static PgFontMap getDefault();
	
	/**
	 * Sets a default PangoCairoFontMap to use with Cairo.
	 * This can be used to change the Cairo font backend that the
	 * default fontmap uses for example. The old default font map
	 * is unreffed and the new font map referenced.
	 * A value of NULL for fontmap will cause the current default
	 * font map to be released and a new default font
	 * map to be created on demand, using pango_cairo_font_map_new().
	 * Since 1.22
	 */
	public void setDefault();
	
	/**
	 * Creates a new PangoCairoFontMap object; a fontmap is used
	 * to cache information about available fonts, and holds
	 * certain global parameters such as the resolution.
	 * In most cases, you can use pango_cairo_font_map_get_default()
	 * instead.
	 * Note that the type of the returned object will depend
	 * on the particular font backend Cairo was compiled to use;
	 * You generally should only use the PangoFontMap and
	 * PangoCairoFontMap interfaces on the returned object.
	 * Since 1.10
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new PangoCairoFontMap object of the type suitable
	 * to be used with cairo font backend of type fonttype.
	 * In most cases one should simply use @pango_cairo_font_map_new(),
	 * or in fact in most of those cases, just use
	 * @pango_cairo_font_map_get_default().
	 * Since 1.18
	 * Params:
	 * fonttype =  desired cairo_font_type_t
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (cairo_font_type_t fonttype);
	
	/**
	 * Gets the type of Cairo font backend that fontmap uses.
	 * Since 1.18
	 * Returns: the cairo_font_type_t cairo font backend type
	 */
	public cairo_font_type_t getFontType();
	
	/**
	 * Sets the resolution for the fontmap. This is a scale factor between
	 * points specified in a PangoFontDescription and Cairo units. The
	 * default value is 96, meaning that a 10 point font will be 13
	 * units high. (10 * 96. / 72. = 13.3).
	 * Since 1.10
	 * Params:
	 * dpi =  the resolution in "dots per inch". (Physical inches aren't actually
	 *  involved; the terminology is conventional.)
	 */
	public void setResolution(double dpi);
	
	/**
	 * Gets the resolution for the fontmap. See pango_cairo_font_map_set_resolution()
	 * Since 1.10
	 * Returns: the resolution in "dots per inch"
	 */
	public double getResolution();
	
	/**
	 * Warning
	 * pango_cairo_font_map_create_context has been deprecated since version 1.22 and should not be used in newly-written code. Use pango_font_map_create_context() instead.
	 * Create a PangoContext for the given fontmap.
	 * Since 1.10
	 * Returns: the newly created context; free with g_object_unref().
	 */
	public PgContext createContext();
}
