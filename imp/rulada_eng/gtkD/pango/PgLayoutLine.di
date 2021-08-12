module gtkD.pango.PgLayoutLine;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * While complete access to the layout capabilities of Pango is provided
 * using the detailed interfaces for itemization and shaping, using
 * that functionality directly involves writing a fairly large amount
 * of code. The objects and functions in this section provide a
 * high-level driver for formatting entire paragraphs of text
 * at once.
 */
public class PgLayoutLine
{
	
	/** the main Gtk struct */
	protected PangoLayoutLine* pangoLayoutLine;
	
	
	public PangoLayoutLine* getPgLayoutLineStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoLayoutLine* pangoLayoutLine);
	
	/**
	 */
	
	/**
	 * Increase the reference count of a PangoLayoutLine by one.
	 * Since 1.10
	 * Returns: the line passed in.
	 */
	public PgLayoutLine doref();
	
	/**
	 * Decrease the reference count of a PangoLayoutLine by one.
	 * If the result is zero, the line and all associated memory
	 * will be freed.
	 */
	public void unref();
	
	/**
	 * Computes the logical and ink extents of a layout line. See
	 * pango_font_get_glyph_extents() for details about the interpretation
	 * of the rectangles.
	 * Params:
	 * inkRect =  rectangle used to store the extents of the glyph string
	 *  as drawn, or NULL
	 * logicalRect =  rectangle used to store the logical extents of the glyph
	 *  string, or NULL
	 */
	public void getExtents(PangoRectangle* inkRect, PangoRectangle* logicalRect);
	
	/**
	 * Computes the logical and ink extents of layout_line in device units.
	 * This function just calls pango_layout_line_get_extents() followed by
	 * two pango_extents_to_pixels() calls, rounding ink_rect and logical_rect
	 * such that the rounded rectangles fully contain the unrounded one (that is,
	 * passes them as first argument to pango_extents_to_pixels()).
	 * Params:
	 * inkRect =  rectangle used to store the extents of the glyph string
	 *  as drawn, or NULL
	 * logicalRect =  rectangle used to store the logical extents of the glyph
	 *  string, or NULL
	 */
	public void getPixelExtents(PangoRectangle* inkRect, PangoRectangle* logicalRect);
	
	/**
	 * Converts an index within a line to a X position.
	 * Params:
	 * index =  byte offset of a grapheme within the layout
	 * trailing =  an integer indicating the edge of the grapheme to retrieve
	 *  the position of. If > 0, the trailing edge of the grapheme,
	 *  if 0, the leading of the grapheme.
	 * xPos =  location to store the x_offset (in Pango unit)
	 */
	public void indexToX(int index, int trailing, out int xPos);
	
	/**
	 * Converts from x offset to the byte index of the corresponding
	 * character within the text of the layout. If x_pos is outside the line,
	 * index_ and trailing will point to the very first or very last position
	 * in the line. This determination is based on the resolved direction
	 * of the paragraph; for example, if the resolved direction is
	 * right-to-left, then an X position to the right of the line (after it)
	 * results in 0 being stored in index_ and trailing. An X position to the
	 * left of the line results in index_ pointing to the (logical) last
	 * grapheme in the line and trailing being set to the number of characters
	 * in that grapheme. The reverse is true for a left-to-right line.
	 * Params:
	 * xPos =  the X offset (in Pango units)
	 *  from the left edge of the line.
	 * index =  location to store calculated byte index for
	 *  the grapheme in which the user clicked.
	 * trailing =  location to store an integer indicating where
	 *  in the grapheme the user clicked. It will either
	 *  be zero, or the number of characters in the
	 *  grapheme. 0 represents the leading edge of the grapheme.
	 * Returns: FALSE if x_pos was outside the line, TRUE if inside
	 */
	public int xToIndex(int xPos, out int index, out int trailing);
	
	/**
	 * Gets a list of visual ranges corresponding to a given logical range.
	 * This list is not necessarily minimal - there may be consecutive
	 * ranges which are adjacent. The ranges will be sorted from left to
	 * right. The ranges are with respect to the left edge of the entire
	 * layout, not with respect to the line.
	 * Params:
	 * startIndex =  Start byte index of the logical range. If this value
	 *  is less than the start index for the line, then
	 *  the first range will extend all the way to the leading
	 *  edge of the layout. Otherwise it will start at the
	 *  leading edge of the first character.
	 * endIndex =  Ending byte index of the logical range. If this value
	 *  is greater than the end index for the line, then
	 *  the last range will extend all the way to the trailing
	 *  edge of the layout. Otherwise, it will end at the
	 *  trailing edge of the last character.
	 * ranges = out): (array length=n_ranges): (transfer=full. out): (array length=n_ranges): (transfer=full.
	 */
	public void getXRanges(int startIndex, int endIndex, out int[] ranges);
}
