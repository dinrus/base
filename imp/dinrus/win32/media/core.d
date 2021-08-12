/**
 * Provides access to basic GDI+ graphics functionality.
 *
 * For detailed information, refer to MSDN's documentation for the $(LINK2 http://msdn2.microsoft.com/en-us/library/system.drawing.aspx, Система.Drawing) namespace.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.media.core;

import win32.base.core,
  win32.base.math,
  win32.base.string,
  win32.base.threading,
  win32.base.native,
  win32.io.core,
  win32.io.path,
  win32.com.core,
  win32.media.consts,
  win32.media.geometry,
  win32.media.imaging,
  win32.media.native,
  stdrus, tpl.stream;

version(D_Version2) {
  debug import std.stdio : пишинс;
}

private цел stringToInt(ткст значение, цел fromBase) {
  цел знак = 1;
  цел i;
  цел len = значение.length;

  if (значение[0] == '-') {
    знак = -1;
    i++;
  }
  else if (значение[0] == '+') {
    i++;
  }

  if (fromBase == 16) {
    if (len >= i + 2
      && (значение[i .. i + 2] == "0x" || значение[i .. i + 2] == "0X"))
      i += 2;
  }

  цел рез;
  цел n;

  while (i < len) {
    сим c = значение[i++];
    if (stdrus.цифра_ли(c))
      n = c - '0';
    else if (stdrus.буква_ли(c))
      n = stdrus.впроп(c) - 'a' + 10;

    рез = fromBase * рез + n;
  }

  if (fromBase == 10)
    рез *= знак;

  return рез;
}

/**
 * Represents an ARGB цвет.
 */
struct Цвет {

  /// Gets a system-defined цвет.
  static Цвет activeBorder() {
    return Цвет(KnownColor.ActiveBorder);
  }

  /// ditto 
  static Цвет activeCaption() {
    return Цвет(KnownColor.ActiveCaption);
  }

  /// ditto 
  static Цвет activeCaptionText() {
    return Цвет(KnownColor.ActiveCaptionText);
  }

  /// ditto 
  static Цвет appWorkspace() {
    return Цвет(KnownColor.AppWorkspace);
  }

  /// ditto 
  static Цвет control() {
    return Цвет(KnownColor.УпрЭлт);
  }

  /// ditto 
  static Цвет controlDark() {
    return Цвет(KnownColor.ControlDark);
  }

  /// ditto 
  static Цвет controlDarkDark() {
    return Цвет(KnownColor.ControlDarkDark);
  }

  /// ditto 
  static Цвет controlLight() {
    return Цвет(KnownColor.ControlLight);
  }

  /// ditto 
  static Цвет controlLightLight() {
    return Цвет(KnownColor.ControlLightLight);
  }

  /// ditto 
  static Цвет controlText() {
    return Цвет(KnownColor.ControlText);
  }

  /// ditto 
  static Цвет desktop() {
    return Цвет(KnownColor.РабСтол);
  }

  /// ditto 
  static Цвет grayText() {
    return Цвет(KnownColor.GrayText);
  }

  /// ditto 
  static Цвет highlight() {
    return Цвет(KnownColor.Highlight);
  }

  /// ditto 
  static Цвет highlightText() {
    return Цвет(KnownColor.HighlightText);
  }

  /// ditto 
  static Цвет hotTrack() {
    return Цвет(KnownColor.HotTrack);
  }

  /// ditto 
  static Цвет inactiveBorder() {
    return Цвет(KnownColor.InactiveBorder);
  }

  /// ditto 
  static Цвет inactiveCaption() {
    return Цвет(KnownColor.InactiveCaption);
  }

  /// ditto 
  static Цвет inactiveCaptionText() {
    return Цвет(KnownColor.InactiveCaptionText);
  }

  /// ditto 
  static Цвет info() {
    return Цвет(KnownColor.Info);
  }

  /// ditto 
  static Цвет infoText() {
    return Цвет(KnownColor.InfoText);
  }

  /// ditto 
  static Цвет menu() {
    return Цвет(KnownColor.Menu);
  }

  /// ditto 
  static Цвет menuText() {
    return Цвет(KnownColor.MenuText);
  }

  /// ditto 
  static Цвет scrollBar() {
    return Цвет(KnownColor.ScrollBar);
  }

  /// ditto 
  static Цвет window() {
    return Цвет(KnownColor.Window);
  }

  /// ditto 
  static Цвет windowFrame() {
    return Цвет(KnownColor.WindowFrame);
  }

  /// ditto 
  static Цвет windowText() {
    return Цвет(KnownColor.WindowText);
  }

  /// ditto 
  static Цвет transparent() {
    return Цвет(KnownColor.Transparent);
  }

  /// ditto 
  static Цвет aliceBlue() {
    return Цвет(KnownColor.AliceBlue);
  }

  /// ditto 
  static Цвет antiqueWhite() {
    return Цвет(KnownColor.AntiqueWhite);
  }

  /// ditto 
  static Цвет aqua() {
    return Цвет(KnownColor.Aqua);
  }

  /// ditto 
  static Цвет aquamarine() {
    return Цвет(KnownColor.Aquamarine);
  }

  /// ditto 
  static Цвет azure() {
    return Цвет(KnownColor.Azure);
  }

  /// ditto 
  static Цвет beige() {
    return Цвет(KnownColor.Beige);
  }

  /// ditto 
  static Цвет bisque() {
    return Цвет(KnownColor.Bisque);
  }

  /// ditto 
  static Цвет black() {
    return Цвет(KnownColor.Black);
  }

  /// ditto 
  static Цвет blanchedAlmond() {
    return Цвет(KnownColor.BlanchedAlmond);
  }

  /// ditto 
  static Цвет blue() {
    return Цвет(KnownColor.Blue);
  }

  /// ditto 
  static Цвет blueViolet() {
    return Цвет(KnownColor.BlueViolet);
  }

  /// ditto 
  static Цвет brown() {
    return Цвет(KnownColor.Brown);
  }

  /// ditto 
  static Цвет burlyWood() {
    return Цвет(KnownColor.BurlyWood);
  }

  /// ditto 
  static Цвет cadetBlue() {
    return Цвет(KnownColor.CadetBlue);
  }

  /// ditto 
  static Цвет chartreuse() {
    return Цвет(KnownColor.Chartreuse);
  }

  /// ditto 
  static Цвет chocolate() {
    return Цвет(KnownColor.Chocolate);
  }

  /// ditto 
  static Цвет coral() {
    return Цвет(KnownColor.Coral);
  }

  /// ditto 
  static Цвет cornflowerBlue() {
    return Цвет(KnownColor.CornflowerBlue);
  }

  /// ditto 
  static Цвет cornsilk() {
    return Цвет(KnownColor.Cornsilk);
  }

  /// ditto 
  static Цвет crimson() {
    return Цвет(KnownColor.Crimson);
  }

  /// ditto 
  static Цвет cyan() {
    return Цвет(KnownColor.Cyan);
  }

  /// ditto 
  static Цвет darkBlue() {
    return Цвет(KnownColor.DarkBlue);
  }

  /// ditto 
  static Цвет darkCyan() {
    return Цвет(KnownColor.DarkCyan);
  }

  /// ditto 
  static Цвет darkGoldenrod() {
    return Цвет(KnownColor.DarkGoldenrod);
  }

  /// ditto 
  static Цвет darkGray() {
    return Цвет(KnownColor.DarkGray);
  }

  /// ditto 
  static Цвет darkGreen() {
    return Цвет(KnownColor.DarkGreen);
  }

  /// ditto 
  static Цвет darkKhaki() {
    return Цвет(KnownColor.DarkKhaki);
  }

  /// ditto 
  static Цвет darkMagenta() {
    return Цвет(KnownColor.DarkMagenta);
  }

  /// ditto 
  static Цвет darkOliveGreen() {
    return Цвет(KnownColor.DarkOliveGreen);
  }

  /// ditto 
  static Цвет darkOrange() {
    return Цвет(KnownColor.DarkOrange);
  }

  /// ditto 
  static Цвет darkOrchid() {
    return Цвет(KnownColor.DarkOrchid);
  }

  /// ditto 
  static Цвет darkRed() {
    return Цвет(KnownColor.DarkRed);
  }

  /// ditto 
  static Цвет darkSalmon() {
    return Цвет(KnownColor.DarkSalmon);
  }

  /// ditto 
  static Цвет darkSeaGreen() {
    return Цвет(KnownColor.DarkSeaGreen);
  }

  /// ditto 
  static Цвет darkSlateBlue() {
    return Цвет(KnownColor.DarkSlateBlue);
  }

  /// ditto 
  static Цвет darkSlateGray() {
    return Цвет(KnownColor.DarkSlateGray);
  }

  /// ditto 
  static Цвет darkTurquoise() {
    return Цвет(KnownColor.DarkTurquoise);
  }

  /// ditto 
  static Цвет darkViolet() {
    return Цвет(KnownColor.DarkViolet);
  }

  /// ditto 
  static Цвет deepPink() {
    return Цвет(KnownColor.DeepPink);
  }

  /// ditto 
  static Цвет deepSkyBlue() {
    return Цвет(KnownColor.DeepSkyBlue);
  }

  /// ditto 
  static Цвет dimGray() {
    return Цвет(KnownColor.DimGray);
  }

  /// ditto 
  static Цвет dodgerBlue() {
    return Цвет(KnownColor.DodgerBlue);
  }

  /// ditto 
  static Цвет firebrick() {
    return Цвет(KnownColor.Firebrick);
  }

  /// ditto 
  static Цвет floralWhite() {
    return Цвет(KnownColor.FloralWhite);
  }

  /// ditto 
  static Цвет forestGreen() {
    return Цвет(KnownColor.ForestGreen);
  }

  /// ditto 
  static Цвет fuchsia() {
    return Цвет(KnownColor.Fuchsia);
  }

  /// ditto 
  static Цвет gainsboro() {
    return Цвет(KnownColor.Gainsboro);
  }

  /// ditto 
  static Цвет ghostWhite() {
    return Цвет(KnownColor.GhostWhite);
  }

  /// ditto 
  static Цвет gold() {
    return Цвет(KnownColor.Gold);
  }

  /// ditto 
  static Цвет goldenrod() {
    return Цвет(KnownColor.Goldenrod);
  }

  /// ditto 
  static Цвет gray() {
    return Цвет(KnownColor.Gray);
  }

  /// ditto 
  static Цвет green() {
    return Цвет(KnownColor.Green);
  }

  /// ditto 
  static Цвет greenYellow() {
    return Цвет(KnownColor.GreenYellow);
  }

  /// ditto 
  static Цвет honeydew() {
    return Цвет(KnownColor.Honeydew);
  }

  /// ditto 
  static Цвет hotPink() {
    return Цвет(KnownColor.HotPink);
  }

  /// ditto 
  static Цвет indianRed() {
    return Цвет(KnownColor.IndianRed);
  }

  /// ditto 
  static Цвет indigo() {
    return Цвет(KnownColor.Indigo);
  }

  /// ditto 
  static Цвет ivory() {
    return Цвет(KnownColor.Ivory);
  }

  /// ditto 
  static Цвет khaki() {
    return Цвет(KnownColor.Khaki);
  }

  /// ditto 
  static Цвет lavender() {
    return Цвет(KnownColor.Lavender);
  }

  /// ditto 
  static Цвет lavenderBlush() {
    return Цвет(KnownColor.LavenderBlush);
  }

  /// ditto 
  static Цвет lawnGreen() {
    return Цвет(KnownColor.LawnGreen);
  }

  /// ditto 
  static Цвет lemonChiffon() {
    return Цвет(KnownColor.LemonChiffon);
  }

  /// ditto 
  static Цвет lightBlue() {
    return Цвет(KnownColor.LightBlue);
  }

  /// ditto 
  static Цвет lightCoral() {
    return Цвет(KnownColor.LightCoral);
  }

  /// ditto 
  static Цвет lightCyan() {
    return Цвет(KnownColor.LightCyan);
  }

  /// ditto 
  static Цвет lightGoldenrodYellow() {
    return Цвет(KnownColor.LightGoldenrodYellow);
  }

  /// ditto 
  static Цвет lightGray() {
    return Цвет(KnownColor.LightGray);
  }

  /// ditto 
  static Цвет lightGreen() {
    return Цвет(KnownColor.LightGreen);
  }

  /// ditto 
  static Цвет lightPink() {
    return Цвет(KnownColor.LightPink);
  }

  /// ditto 
  static Цвет lightSalmon() {
    return Цвет(KnownColor.LightSalmon);
  }

  /// ditto 
  static Цвет lightSeaGreen() {
    return Цвет(KnownColor.LightSeaGreen);
  }

  /// ditto 
  static Цвет lightSkyBlue() {
    return Цвет(KnownColor.LightSkyBlue);
  }

  /// ditto 
  static Цвет lightSlateGray() {
    return Цвет(KnownColor.LightSlateGray);
  }

  /// ditto 
  static Цвет lightSteelBlue() {
    return Цвет(KnownColor.LightSteelBlue);
  }

  /// ditto 
  static Цвет lightYellow() {
    return Цвет(KnownColor.LightYellow);
  }

  /// ditto 
  static Цвет lime() {
    return Цвет(KnownColor.Lime);
  }

  /// ditto 
  static Цвет limeGreen() {
    return Цвет(KnownColor.LimeGreen);
  }

  /// ditto 
  static Цвет linen() {
    return Цвет(KnownColor.Linen);
  }

  /// ditto 
  static Цвет magenta() {
    return Цвет(KnownColor.Magenta);
  }

  /// ditto 
  static Цвет maroon() {
    return Цвет(KnownColor.Maroon);
  }

  /// ditto 
  static Цвет mediumAquamarine() {
    return Цвет(KnownColor.MediumAquamarine);
  }

  /// ditto 
  static Цвет mediumBlue() {
    return Цвет(KnownColor.MediumBlue);
  }

  /// ditto 
  static Цвет mediumOrchid() {
    return Цвет(KnownColor.MediumOrchid);
  }

  /// ditto 
  static Цвет mediumPurple() {
    return Цвет(KnownColor.MediumPurple);
  }

  /// ditto 
  static Цвет mediumSeaGreen() {
    return Цвет(KnownColor.MediumSeaGreen);
  }

  /// ditto 
  static Цвет mediumSlateBlue() {
    return Цвет(KnownColor.MediumSlateBlue);
  }

  /// ditto 
  static Цвет mediumSpringGreen() {
    return Цвет(KnownColor.MediumSpringGreen);
  }

  /// ditto 
  static Цвет mediumTurquoise() {
    return Цвет(KnownColor.MediumTurquoise);
  }

  /// ditto 
  static Цвет mediumVioletRed() {
    return Цвет(KnownColor.MediumVioletRed);
  }

  /// ditto 
  static Цвет midnightBlue() {
    return Цвет(KnownColor.MidnightBlue);
  }

  /// ditto 
  static Цвет mintCream() {
    return Цвет(KnownColor.MintCream);
  }

  /// ditto 
  static Цвет mistyRose() {
    return Цвет(KnownColor.MistyRose);
  }

  /// ditto 
  static Цвет moccasin() {
    return Цвет(KnownColor.Moccasin);
  }

  /// ditto 
  static Цвет navajoWhite() {
    return Цвет(KnownColor.NavajoWhite);
  }

  /// ditto 
  static Цвет navy() {
    return Цвет(KnownColor.Navy);
  }

  /// ditto 
  static Цвет oldLace() {
    return Цвет(KnownColor.OldLace);
  }

  /// ditto 
  static Цвет olive() {
    return Цвет(KnownColor.Olive);
  }

  /// ditto 
  static Цвет oliveDrab() {
    return Цвет(KnownColor.OliveDrab);
  }

  /// ditto 
  static Цвет orange() {
    return Цвет(KnownColor.Orange);
  }

  /// ditto 
  static Цвет orangeRed() {
    return Цвет(KnownColor.OrangeRed);
  }

  /// ditto 
  static Цвет orchid() {
    return Цвет(KnownColor.Orchid);
  }

  /// ditto 
  static Цвет paleGoldenrod() {
    return Цвет(KnownColor.PaleGoldenrod);
  }

  /// ditto 
  static Цвет paleGreen() {
    return Цвет(KnownColor.PaleGreen);
  }

  /// ditto 
  static Цвет paleTurquoise() {
    return Цвет(KnownColor.PaleTurquoise);
  }

  /// ditto 
  static Цвет paleVioletRed() {
    return Цвет(KnownColor.PaleVioletRed);
  }

  /// ditto 
  static Цвет papayaWhip() {
    return Цвет(KnownColor.PapayaWhip);
  }

  /// ditto 
  static Цвет peachPuff() {
    return Цвет(KnownColor.PeachPuff);
  }

  /// ditto 
  static Цвет peru() {
    return Цвет(KnownColor.Peru);
  }

  /// ditto 
  static Цвет pink() {
    return Цвет(KnownColor.Pink);
  }

  /// ditto 
  static Цвет plum() {
    return Цвет(KnownColor.Plum);
  }

  /// ditto 
  static Цвет powderBlue() {
    return Цвет(KnownColor.PowderBlue);
  }

  /// ditto 
  static Цвет purple() {
    return Цвет(KnownColor.Purple);
  }

  /// ditto 
  static Цвет red() {
    return Цвет(KnownColor.Red);
  }

  /// ditto 
  static Цвет rosyBrown() {
    return Цвет(KnownColor.RosyBrown);
  }

  /// ditto 
  static Цвет royalBlue() {
    return Цвет(KnownColor.RoyalBlue);
  }

  /// ditto 
  static Цвет saddleBrown() {
    return Цвет(KnownColor.SaddleBrown);
  }

  /// ditto 
  static Цвет salmon() {
    return Цвет(KnownColor.Salmon);
  }

  /// ditto 
  static Цвет sandyBrown() {
    return Цвет(KnownColor.SandyBrown);
  }

  /// ditto 
  static Цвет seaGreen() {
    return Цвет(KnownColor.SeaGreen);
  }

  /// ditto 
  static Цвет seaShell() {
    return Цвет(KnownColor.SeaShell);
  }

  /// ditto 
  static Цвет sienna() {
    return Цвет(KnownColor.Sienna);
  }

  /// ditto 
  static Цвет silver() {
    return Цвет(KnownColor.Silver);
  }

  /// ditto 
  static Цвет skyBlue() {
    return Цвет(KnownColor.SkyBlue);
  }

  /// ditto 
  static Цвет slateBlue() {
    return Цвет(KnownColor.SlateBlue);
  }

  /// ditto 
  static Цвет slateGray() {
    return Цвет(KnownColor.SlateGray);
  }

  /// ditto 
  static Цвет snow() {
    return Цвет(KnownColor.Snow);
  }

  /// ditto 
  static Цвет springGreen() {
    return Цвет(KnownColor.SpringGreen);
  }

  /// ditto 
  static Цвет steelBlue() {
    return Цвет(KnownColor.SteelBlue);
  }

  /// ditto 
  static Цвет tan() {
    return Цвет(KnownColor.Tan);
  }

  /// ditto 
  static Цвет teal() {
    return Цвет(KnownColor.Teal);
  }

  /// ditto 
  static Цвет thistle() {
    return Цвет(KnownColor.Thistle);
  }

  /// ditto 
  static Цвет tomato() {
    return Цвет(KnownColor.Tomato);
  }

  /// ditto 
  static Цвет turquoise() {
    return Цвет(KnownColor.Turquoise);
  }

  /// ditto 
  static Цвет violet() {
    return Цвет(KnownColor.Violet);
  }

  /// ditto 
  static Цвет wheat() {
    return Цвет(KnownColor.Wheat);
  }

  /// ditto 
  static Цвет white() {
    return Цвет(KnownColor.White);
  }

  /// ditto 
  static Цвет whiteSmoke() {
    return Цвет(KnownColor.WhiteSmoke);
  }

  /// ditto 
  static Цвет yellow() {
    return Цвет(KnownColor.Yellow);
  }

  /// ditto 
  static Цвет yellowGreen() {
    return Цвет(KnownColor.YellowGreen);
  }

  /// ditto 
  static Цвет buttonFace() {
    return Цвет(KnownColor.ButtonFace);
  }

  /// ditto 
  static Цвет buttonHighlight() {
    return Цвет(KnownColor.ButtonHighlight);
  }

  /// ditto 
  static Цвет buttonShadow() {
    return Цвет(KnownColor.ButtonShadow);
  }

  /// ditto 
  static Цвет gradientActiveCaption() {
    return Цвет(KnownColor.GradientActiveCaption);
  }

  /// ditto 
  static Цвет gradientInactiveCaption() {
    return Цвет(KnownColor.GradientInactiveCaption);
  }

  /// ditto 
  static Цвет menuBar() {
    return Цвет(KnownColor.MenuBar);
  }

  /// ditto 
  static Цвет menuHighlight() {
    return Цвет(KnownColor.MenuHighlight);
  }

  private enum : ббайт {
    ARGB_ALPHA_SHIFT = 24,
    ARGB_RED_SHIFT = 16,
    ARGB_GREEN_SHIFT = 8,
    ARGB_BLUE_SHIFT = 0
  }

  private enum : бцел {
    RGB_RED_SHIFT = 0,
    RGB_GREEN_SHIFT = 8,
    RGB_BLUE_SHIFT = 16
  }

  private enum : бкрат {
    STATE_KNOWNCOLOR_VALID = 0x01,
    STATE_VALUE_VALID = 0x02,
    STATE_NAME_VALID = 0x04
  }

  private static бдол UNDEFINED_VALUE = 0;

  private static бцел[] colorTable_;
  private static ткст[] nameTable_;
  private static Цвет[ткст] htmlTable_;

  private бдол value_;
  private бкрат state_;
  private ткст name_;
  private бкрат knownColor_;

  /**
   * Represents an uninitialized цвет.
   */
  static Цвет пустой = { 0, 0, null, 0 };

  /**
   * Creates a Цвет structure from the ARGB component значения.
   */
  static Цвет fromArgb(бцел argb) {
    return Цвет(cast(бдол)argb & 0xffffffff, STATE_VALUE_VALID, null, cast(KnownColor)0);
  }

  /**
   * ditto
   */
  static Цвет fromArgb(ббайт alpha, ббайт red, ббайт green, ббайт blue) {
    return Цвет(makeArgb(alpha, red, green, blue), STATE_VALUE_VALID, null, cast(KnownColor)0);
  }

  /**
   * ditto
   */
  static Цвет fromArgb(ббайт red, ббайт green, ббайт blue) {
    return fromArgb(255, red, green, blue);
  }

  /**
   * ditto
   */
  static Цвет fromArgb(ббайт alpha, Цвет baseColor) {
    return Цвет(makeArgb(alpha, baseColor.r, baseColor.g, baseColor.b), STATE_VALUE_VALID, null, cast(KnownColor)0);
  }

  /**
   * Creates a GDI+ цвет structure from a Windows цвет _value.
   */
  static Цвет fromRgb(бцел значение) {

    Цвет knownColorFromArgb(бцел argb) {
      if (colorTable_ == null)
        initColorTable();

      for (цел i = 0; i < colorTable_.length; i++) {
        цел c = colorTable_[i];
        if (c == argb) {
          Цвет цвет = Цвет(cast(KnownColor)i);
          if (!цвет.isSystemColor)
            return цвет;
        }
      }

      return fromArgb(argb);
    }

    Цвет c = fromArgb(cast(ббайт)((значение >> RGB_RED_SHIFT) & 0xff), cast(ббайт)((значение >> RGB_GREEN_SHIFT) & 0xff), cast(ббайт)((значение >> RGB_BLUE_SHIFT) & 0xff));
    return knownColorFromArgb(c.toArgb());
  }

  static Цвет fromHtml(ткст значение) {
    Цвет c = Цвет.пустой;

    if (значение == null)
      return c;

    if (значение[0] == '#') {
      if (значение.length == 4 || значение.length == 7) {
        if (значение.length == 7) {
          c = fromArgb(cast(ббайт)stringToInt(значение[1 .. 3], 16), cast(ббайт)stringToInt(значение[3 .. 5], 16), cast(ббайт)stringToInt(значение[5 .. 7], 16));
        }
        else {
          version(D_Version2) {
            ткст r = stdrus.to!(ткст)(значение[1]);
            ткст g = stdrus.to!(ткст)(значение[2]);
            ткст b = stdrus.to!(ткст)(значение[3]);
          }
          else {
            ткст r = .вТкст(значение[1]);
            ткст g = .вТкст(значение[2]);
            ткст b = .вТкст(значение[3]);
          }
          c = Цвет.fromArgb(cast(ббайт)stringToInt(r ~ r, 16), cast(ббайт)stringToInt(g ~ g, 16), cast(ббайт)stringToInt(b ~ b, 16));
        }
      }
    }

    if (c.пуст_ли && сравнлюб("LightGrey", значение) == 0)
      c = Цвет.lightGray;

    if (c.пуст_ли) {
      if (htmlTable_ == null)
        initHtmlTable();

      if (auto v = значение.впроп() in htmlTable_)
        c = *v;
    }

    if (c.пуст_ли)
      c = fromName(значение);

    return c;
  }

  /**
   * Creates a Цвет structure from the specified predefined _color.
   */
  static Цвет fromKnownColor(KnownColor цвет) {
    return Цвет(цвет);
  }

  /**
   * Creates a Цвет structure from the specified _name of a predefined _color.
   */
  static Цвет fromName(ткст имя) {
    if (nameTable_ == null)
      initNameTable();

    foreach (ключ, значение; nameTable_) {
      if (значение.впроп() == имя.впроп())
        return fromKnownColor(cast(KnownColor)ключ);
    }

    return Цвет(0, STATE_NAME_VALID, имя, cast(KnownColor)0);
  }

  /**
   * Gets the alpha component.
   */
  ббайт a() {
    return cast(ббайт)((значение >> ARGB_ALPHA_SHIFT) & 255);
  }

  /**
   * Gets the red component.
   */
  ббайт r() {
    return cast(ббайт)((значение >> ARGB_RED_SHIFT) & 255);
  }

  /**
   * Gets the green component.
   */
  ббайт g() {
    return cast(ббайт)((значение >> ARGB_GREEN_SHIFT) & 255);
  }

  /**
   * Gets the blue component.
   */
  ббайт b() {
    return cast(ббайт)((значение >> ARGB_BLUE_SHIFT) & 255);
  }

  /**
   * Gets the KnownColor значение.
   */
  KnownColor toKnownColor() {
    return cast(KnownColor)knownColor_;
  }

  /**
   * Gets the ARGB значение.
   */
  бцел toArgb() {
    return cast(бцел)значение;
  }

  /**
   * Converts the значение to a Windows цвет значение.
   */
  бцел toRgb() {
    return r << RGB_RED_SHIFT | g << RGB_GREEN_SHIFT | b << RGB_BLUE_SHIFT;
  }

  /**
   * Determines whether this Цвет structure is uninitialized.
   */
  бул пуст_ли() {
    return (state_ == 0);
  }

  /**
   * Determines whether this Цвет structure is predefined.
   */
  бул isKnownColor() {
    return (state_ & STATE_KNOWNCOLOR_VALID) != 0;
  }

  /**
   * Determines whether this Цвет structure is a system цвет.
   */
  бул isSystemColor() {
    return isKnownColor && (knownColor_ <= KnownColor.WindowText || knownColor_ >= KnownColor.ButtonFace);
  }

  бул isNamedColor() {
    return (isKnownColor || (state_ & STATE_NAME_VALID) != 0);
  }

  /**
   * Determines whether the specified экземпляр _equals this экземпляр.
   * Returns: true if другой is equivalent to the экземпляр; otherwise, false.
   * Remarks: To сравни цвета based solely on their ARGB значения, use the toArgb метод.
   */
  бул равен(Цвет другой) {
    return value_ == другой.value_ && state_ == другой.state_ && knownColor_ == другой.knownColor_ && name_ == другой.name_;
  }

  /// ditto
  бул opEquals(Цвет другой) {
    return this.равен(другой);
  }

  /**
   * Gets the HSB brightness значение.
   */
  плав getBrightness() {
    ббайт minVal = cast(ббайт)win32.base.math.мин(cast(цел)r, win32.base.math.мин(cast(цел)g, cast(цел)b));
    ббайт maxVal = cast(ббайт)win32.base.math.макс(cast(цел)r, win32.base.math.макс(cast(цел)g, cast(цел)b));
    return cast(плав)(minVal + maxVal) / 510;
  }

  /**
   * Gets the HSB saturation значение.
   */
  плав getSaturation() {
    ббайт minVal = cast(ббайт)мин(cast(цел)r, мин(cast(цел)g, cast(цел)b));
    ббайт maxVal = cast(ббайт)макс(cast(цел)r, макс(cast(цел)g, cast(цел)b));

    if (maxVal == minVal)
      return 0;

    цел sum = minVal + maxVal;
    if (sum > 255)
      sum = 510 - sum;
    return cast(плав)(maxVal - minVal) / sum;
  }

  /**
   * Gets the HSB hue значение.
   */
  плав getHue() {
    ббайт r = this.r;
    ббайт g = this.g;
    ббайт b = this.b;
    ббайт minVal = cast(ббайт)мин(cast(цел)r, мин(cast(цел)g, cast(цел)b));
    ббайт maxVal = cast(ббайт)макс(cast(цел)r, макс(cast(цел)g, cast(цел)b));

    if (maxVal == minVal)
      return 0;

    плав diff = cast(плав)(maxVal - minVal);
    плав rnorm = (maxVal - r) / diff;
    плав gnorm = (maxVal - g) / diff;
    плав bnorm = (maxVal - b) / diff;

    плав hue = 0.0;
    if (r == maxVal)
      hue = 60.0f * (6.0f + bnorm - gnorm);
    if (g == maxVal)
      hue = 60.0f * (2.0f + rnorm - bnorm);
    if (b == maxVal)
      hue = 60.0f * (4.0f + gnorm - rnorm);
    if (hue > 360.0f)
      hue -= 360.0f;
    return hue;
  }

  /**
   * Gets the _name.
   */
  ткст имя() {
    if ((state_ & STATE_NAME_VALID) != 0)
      return name_;

    if ((state_ & STATE_KNOWNCOLOR_VALID) == 0) {
      version(D_Version2) {
        return stdrus.to!(ткст)(value_, 16u);
      }
      else {
        return stdrus.вТкст(value_, 16u);
      }
    }

    if (nameTable_ == null)
      initNameTable();
    return nameTable_[knownColor_];
  }

  /**
   * Converts this Цвет to a human-readable ткст.
   */
  ткст вТкст() {
    ткст s = "Цвет [";
    if ((state_ & STATE_KNOWNCOLOR_VALID) != 0)
      s ~= имя;
    else if ((state_ & STATE_VALUE_VALID) != 0)
      s ~= фм("A=%s, R=%s, G=%s, B=%s", a, r, g, b);
    else
      s ~= "Empty";
    s ~= "]";
    return s;
  }

  ткст toHtml() {
    if (пуст_ли)
      return "";

    if (isSystemColor) {
      switch (toKnownColor()) {
        case KnownColor.ActiveBorder: return "activeborder";
        case KnownColor.ActiveCaption, KnownColor.GradientActiveCaption: return "activecaption";
        case KnownColor.AppWorkspace: return "appworkspace";
        case KnownColor.РабСтол: return "background";
        case KnownColor.УпрЭлт, KnownColor.ControlLight: return "buttonface";
        case KnownColor.ControlDark: return "buttonshadow";
        case KnownColor.ControlText: return "buttontext";
        case KnownColor.ActiveCaptionText: return "captiontext";
        case KnownColor.GrayText: return "graytext";
        case KnownColor.HotTrack, KnownColor.Highlight: return "highlight";
        case KnownColor.MenuHighlight, KnownColor.HighlightText: return "highlighttext";
        case KnownColor.InactiveBorder: return "inactiveborder";
        case KnownColor.InactiveCaption, KnownColor.GradientInactiveCaption: return "inactioncaption";
        case KnownColor.InactiveCaptionText: return "inactivecaptiontext";
        case KnownColor.Info: return "infobackground";
        case KnownColor.InfoText: return "infotext";
        case KnownColor.MenuBar, KnownColor.Menu: return "menu";
        case KnownColor.MenuText: return "menutext";
        case KnownColor.ScrollBar: return "scrollbar";
        case KnownColor.ControlDarkDark: return "threeddarkshadow";
        case KnownColor.ControlLightLight: return "buttonhighlight";
        case KnownColor.Window: return "window";
        case KnownColor.WindowFrame: return "windowframe";
        case KnownColor.WindowText: return "windowtext";
        default:
      }
    }
    else if (isNamedColor) {
      version(D_Version2) {
        if (this == Цвет.lightGray)
          return "LightGrey";
      }
      else {
        if (*this == Цвет.lightGray)
          return "LightGrey";
      }
      return имя;
    }

    return "#" ~ фм("%02X", r) ~ фм("%02X", g) ~ фм("%02X", b);
  }

  private static Цвет opCall(KnownColor knownColor) {
    Цвет сам;
    сам.state_ = STATE_KNOWNCOLOR_VALID;
    сам.knownColor_ = cast(бкрат)knownColor;
    return сам;
  }

  private static Цвет opCall(бдол значение, бкрат state, ткст имя, KnownColor knownColor) {
    Цвет сам;
    сам.value_ = значение;
    сам.state_ = state;
    сам.knownColor_ = cast(бкрат)knownColor;
    сам.name_ = имя;
    return сам;
  }

  private static бдол makeArgb(ббайт alpha, ббайт red, ббайт green, ббайт blue) {
    return cast(бдол)(red << ARGB_RED_SHIFT | green << ARGB_GREEN_SHIFT | blue << ARGB_BLUE_SHIFT | alpha << ARGB_ALPHA_SHIFT) & 0xffffffff;
  }

  private бдол значение() {
    if ((state_ & STATE_VALUE_VALID) != 0)
      return value_;
    if ((state_ & STATE_KNOWNCOLOR_VALID) != 0)
      return knownColorToArgb(cast(KnownColor)knownColor_);
    return UNDEFINED_VALUE;
  }

  private static бдол knownColorToArgb(KnownColor цвет) {
    if (colorTable_ == null)
      initColorTable();

    if (цвет <= KnownColor.MenuHighlight)
      return colorTable_[цвет];
    return 0;
  }

  private static бцел systemColorToArgb(цел индекс) {
    бцел fromRgb(бцел значение) {
      бцел кодируй(бцел alpha, бцел red, бцел green, бцел blue) {
        return red << ARGB_RED_SHIFT | green << ARGB_GREEN_SHIFT | blue << ARGB_BLUE_SHIFT | alpha << ARGB_ALPHA_SHIFT;
      }
      return кодируй(255, (значение >> RGB_RED_SHIFT) & 255, (значение >> RGB_GREEN_SHIFT) & 255, (значение >> RGB_BLUE_SHIFT) & 255);
    }
    return fromRgb(GetSysColor(индекс));
  }

  private static проц initColorTable() {
    colorTable_.length = KnownColor.max + 1;

    colorTable_[KnownColor.ActiveBorder] = systemColorToArgb(COLOR_ACTIVEBORDER); 
    colorTable_[KnownColor.ActiveCaption] = systemColorToArgb(COLOR_ACTIVECAPTION);
    colorTable_[KnownColor.ActiveCaptionText] = systemColorToArgb(COLOR_CAPTIONTEXT); 
    colorTable_[KnownColor.AppWorkspace] = systemColorToArgb(COLOR_APPWORKSPACE); 
    colorTable_[KnownColor.ButtonFace] = systemColorToArgb(COLOR_BTNFACE);
    colorTable_[KnownColor.ButtonHighlight] = systemColorToArgb(COLOR_BTNHIGHLIGHT); 
    colorTable_[KnownColor.ButtonShadow] = systemColorToArgb(COLOR_BTNSHADOW);
    colorTable_[KnownColor.УпрЭлт] = systemColorToArgb(COLOR_BTNFACE);
    colorTable_[KnownColor.ControlDark] = systemColorToArgb(COLOR_BTNSHADOW);
    colorTable_[KnownColor.ControlDarkDark] = systemColorToArgb(COLOR_3DDKSHADOW); 
    colorTable_[KnownColor.ControlLight] = systemColorToArgb(COLOR_BTNHIGHLIGHT);
    colorTable_[KnownColor.ControlLightLight] = systemColorToArgb(COLOR_3DLIGHT); 
    colorTable_[KnownColor.ControlText] = systemColorToArgb(COLOR_BTNTEXT); 
    colorTable_[KnownColor.РабСтол] = systemColorToArgb(COLOR_BACKGROUND);
    colorTable_[KnownColor.GradientActiveCaption] = systemColorToArgb(COLOR_GRADIENTACTIVECAPTION); 
    colorTable_[KnownColor.GradientInactiveCaption] = systemColorToArgb(COLOR_GRADIENTINACTIVECAPTION);
    colorTable_[KnownColor.GrayText] = systemColorToArgb(COLOR_GRAYTEXT);
    colorTable_[KnownColor.Highlight] = systemColorToArgb(COLOR_HIGHLIGHT);
    colorTable_[KnownColor.HighlightText] = systemColorToArgb(COLOR_HIGHLIGHTTEXT); 
    colorTable_[KnownColor.HotTrack] = systemColorToArgb(COLOR_HOTLIGHT);
    colorTable_[KnownColor.InactiveBorder] = systemColorToArgb(COLOR_INACTIVEBORDER); 
    colorTable_[KnownColor.InactiveCaption] = systemColorToArgb(COLOR_INACTIVECAPTION); 
    colorTable_[KnownColor.InactiveCaptionText] = systemColorToArgb(COLOR_INACTIVECAPTIONTEXT);
    colorTable_[KnownColor.Info] = systemColorToArgb(COLOR_INFOBK); 
    colorTable_[KnownColor.InfoText] = systemColorToArgb(COLOR_INFOTEXT);
    colorTable_[KnownColor.Menu] = systemColorToArgb(COLOR_MENU);
    colorTable_[KnownColor.MenuBar] = systemColorToArgb(COLOR_MENUBAR);
    colorTable_[KnownColor.MenuHighlight] = systemColorToArgb(COLOR_MENUHILIGHT); 
    colorTable_[KnownColor.MenuText] = systemColorToArgb(COLOR_MENUTEXT);
    colorTable_[KnownColor.ScrollBar] = systemColorToArgb(COLOR_SCROLLBAR); 
    colorTable_[KnownColor.Window] = systemColorToArgb(COLOR_WINDOW); 
    colorTable_[KnownColor.WindowFrame] = systemColorToArgb(COLOR_WINDOWFRAME);
    colorTable_[KnownColor.WindowText] = systemColorToArgb(COLOR_WINDOWTEXT); 

    colorTable_[KnownColor.Transparent] = 0x00FFFFFF;
    colorTable_[KnownColor.AliceBlue] = 0xFFF0F8FF; 
    colorTable_[KnownColor.AntiqueWhite] = 0xFFFAEBD7;
    colorTable_[KnownColor.Aqua] = 0xFF00FFFF; 
    colorTable_[KnownColor.Aquamarine] = 0xFF7FFFD4; 
    colorTable_[KnownColor.Azure] = 0xFFF0FFFF;
    colorTable_[KnownColor.Beige] = 0xFFF5F5DC; 
    colorTable_[KnownColor.Bisque] = 0xFFFFE4C4;
    colorTable_[KnownColor.Black] = 0xFF000000;
    colorTable_[KnownColor.BlanchedAlmond] = 0xFFFFEBCD;
    colorTable_[KnownColor.Blue] = 0xFF0000FF; 
    colorTable_[KnownColor.BlueViolet] = 0xFF8A2BE2;
    colorTable_[KnownColor.Brown] = 0xFFA52A2A; 
    colorTable_[KnownColor.BurlyWood] = 0xFFDEB887; 
    colorTable_[KnownColor.CadetBlue] = 0xFF5F9EA0;
    colorTable_[KnownColor.Chartreuse] = 0xFF7FFF00; 
    colorTable_[KnownColor.Chocolate] = 0xFFD2691E;
    colorTable_[KnownColor.Coral] = 0xFFFF7F50;
    colorTable_[KnownColor.CornflowerBlue] = 0xFF6495ED;
    colorTable_[KnownColor.Cornsilk] = 0xFFFFF8DC; 
    colorTable_[KnownColor.Crimson] = 0xFFDC143C;
    colorTable_[KnownColor.Cyan] = 0xFF00FFFF; 
    colorTable_[KnownColor.DarkBlue] = 0xFF00008B; 
    colorTable_[KnownColor.DarkCyan] = 0xFF008B8B;
    colorTable_[KnownColor.DarkGoldenrod] = 0xFFB8860B; 
    colorTable_[KnownColor.DarkGray] = 0xFFA9A9A9;
    colorTable_[KnownColor.DarkGreen] = 0xFF006400;
    colorTable_[KnownColor.DarkKhaki] = 0xFFBDB76B;
    colorTable_[KnownColor.DarkMagenta] = 0xFF8B008B; 
    colorTable_[KnownColor.DarkOliveGreen] = 0xFF556B2F;
    colorTable_[KnownColor.DarkOrange] = 0xFFFF8C00; 
    colorTable_[KnownColor.DarkOrchid] = 0xFF9932CC; 
    colorTable_[KnownColor.DarkRed] = 0xFF8B0000;
    colorTable_[KnownColor.DarkSalmon] = 0xFFE9967A; 
    colorTable_[KnownColor.DarkSeaGreen] = 0xFF8FBC8B;
    colorTable_[KnownColor.DarkSlateBlue] = 0xFF483D8B;
    colorTable_[KnownColor.DarkSlateGray] = 0xFF2F4F4F;
    colorTable_[KnownColor.DarkTurquoise] = 0xFF00CED1; 
    colorTable_[KnownColor.DarkViolet] = 0xFF9400D3;
    colorTable_[KnownColor.DeepPink] = 0xFFFF1493; 
    colorTable_[KnownColor.DeepSkyBlue] = 0xFF00BFFF; 
    colorTable_[KnownColor.DimGray] = 0xFF696969;
    colorTable_[KnownColor.DodgerBlue] = 0xFF1E90FF; 
    colorTable_[KnownColor.Firebrick] = 0xFFB22222;
    colorTable_[KnownColor.FloralWhite] = 0xFFFFFAF0;
    colorTable_[KnownColor.ForestGreen] = 0xFF228B22;
    colorTable_[KnownColor.Fuchsia] = 0xFFFF00FF; 
    colorTable_[KnownColor.Gainsboro] = 0xFFDCDCDC;
    colorTable_[KnownColor.GhostWhite] = 0xFFF8F8FF; 
    colorTable_[KnownColor.Gold] = 0xFFFFD700; 
    colorTable_[KnownColor.Goldenrod] = 0xFFDAA520;
    colorTable_[KnownColor.Gray] = 0xFF808080; 
    colorTable_[KnownColor.Green] = 0xFF008000;
    colorTable_[KnownColor.GreenYellow] = 0xFFADFF2F;
    colorTable_[KnownColor.Honeydew] = 0xFFF0FFF0;
    colorTable_[KnownColor.HotPink] = 0xFFFF69B4; 
    colorTable_[KnownColor.IndianRed] = 0xFFCD5C5C;
    colorTable_[KnownColor.Indigo] = 0xFF4B0082; 
    colorTable_[KnownColor.Ivory] = 0xFFFFFFF0; 
    colorTable_[KnownColor.Khaki] = 0xFFF0E68C;
    colorTable_[KnownColor.Lavender] = 0xFFE6E6FA; 
    colorTable_[KnownColor.LavenderBlush] = 0xFFFFF0F5;
    colorTable_[KnownColor.LawnGreen] = 0xFF7CFC00;
    colorTable_[KnownColor.LemonChiffon] = 0xFFFFFACD;
    colorTable_[KnownColor.LightBlue] = 0xFFADD8E6; 
    colorTable_[KnownColor.LightCoral] = 0xFFF08080;
    colorTable_[KnownColor.LightCyan] = 0xFFE0FFFF; 
    colorTable_[KnownColor.LightGoldenrodYellow] = 0xFFFAFAD2; 
    colorTable_[KnownColor.LightGray] = 0xFFD3D3D3;
    colorTable_[KnownColor.LightGreen] = 0xFF90EE90; 
    colorTable_[KnownColor.LightPink] = 0xFFFFB6C1;
    colorTable_[KnownColor.LightSalmon] = 0xFFFFA07A;
    colorTable_[KnownColor.LightSeaGreen] = 0xFF20B2AA;
    colorTable_[KnownColor.LightSkyBlue] = 0xFF87CEFA; 
    colorTable_[KnownColor.LightSlateGray] = 0xFF778899;
    colorTable_[KnownColor.LightSteelBlue] = 0xFFB0C4DE; 
    colorTable_[KnownColor.LightYellow] = 0xFFFFFFE0; 
    colorTable_[KnownColor.Lime] = 0xFF00FF00;
    colorTable_[KnownColor.LimeGreen] = 0xFF32CD32; 
    colorTable_[KnownColor.Linen] = 0xFFFAF0E6;
    colorTable_[KnownColor.Magenta] = 0xFFFF00FF;
    colorTable_[KnownColor.Maroon] = 0xFF800000;
    colorTable_[KnownColor.MediumAquamarine] = 0xFF66CDAA; 
    colorTable_[KnownColor.MediumBlue] = 0xFF0000CD;
    colorTable_[KnownColor.MediumOrchid] = 0xFFBA55D3; 
    colorTable_[KnownColor.MediumPurple] = 0xFF9370DB; 
    colorTable_[KnownColor.MediumSeaGreen] = 0xFF3CB371;
    colorTable_[KnownColor.MediumSlateBlue] = 0xFF7B68EE; 
    colorTable_[KnownColor.MediumSpringGreen] = 0xFF00FA9A;
    colorTable_[KnownColor.MediumTurquoise] = 0xFF48D1CC;
    colorTable_[KnownColor.MediumVioletRed] = 0xFFC71585;
    colorTable_[KnownColor.MidnightBlue] = 0xFF191970; 
    colorTable_[KnownColor.MintCream] = 0xFFF5FFFA;
    colorTable_[KnownColor.MistyRose] = 0xFFFFE4E1; 
    colorTable_[KnownColor.Moccasin] = 0xFFFFE4B5; 
    colorTable_[KnownColor.NavajoWhite] = 0xFFFFDEAD;
    colorTable_[KnownColor.Navy] = 0xFF000080; 
    colorTable_[KnownColor.OldLace] = 0xFFFDF5E6;
    colorTable_[KnownColor.Olive] = 0xFF808000;
    colorTable_[KnownColor.OliveDrab] = 0xFF6B8E23;
    colorTable_[KnownColor.Orange] = 0xFFFFA500; 
    colorTable_[KnownColor.OrangeRed] = 0xFFFF4500;
    colorTable_[KnownColor.Orchid] = 0xFFDA70D6; 
    colorTable_[KnownColor.PaleGoldenrod] = 0xFFEEE8AA; 
    colorTable_[KnownColor.PaleGreen] = 0xFF98FB98;
    colorTable_[KnownColor.PaleTurquoise] = 0xFFAFEEEE; 
    colorTable_[KnownColor.PaleVioletRed] = 0xFFDB7093;
    colorTable_[KnownColor.PapayaWhip] = 0xFFFFEFD5;
    colorTable_[KnownColor.PeachPuff] = 0xFFFFDAB9;
    colorTable_[KnownColor.Peru] = 0xFFCD853F; 
    colorTable_[KnownColor.Pink] = 0xFFFFC0CB;
    colorTable_[KnownColor.Plum] = 0xFFDDA0DD; 
    colorTable_[KnownColor.PowderBlue] = 0xFFB0E0E6; 
    colorTable_[KnownColor.Purple] = 0xFF800080;
    colorTable_[KnownColor.Red] = 0xFFFF0000; 
    colorTable_[KnownColor.RosyBrown] = 0xFFBC8F8F;
    colorTable_[KnownColor.RoyalBlue] = 0xFF4169E1;
    colorTable_[KnownColor.SaddleBrown] = 0xFF8B4513;
    colorTable_[KnownColor.Salmon] = 0xFFFA8072; 
    colorTable_[KnownColor.SandyBrown] = 0xFFF4A460;
    colorTable_[KnownColor.SeaGreen] = 0xFF2E8B57; 
    colorTable_[KnownColor.SeaShell] = 0xFFFFF5EE; 
    colorTable_[KnownColor.Sienna] = 0xFFA0522D;
    colorTable_[KnownColor.Silver] = 0xFFC0C0C0; 
    colorTable_[KnownColor.SkyBlue] = 0xFF87CEEB;
    colorTable_[KnownColor.SlateBlue] = 0xFF6A5ACD;
    colorTable_[KnownColor.SlateGray] = 0xFF708090;
    colorTable_[KnownColor.Snow] = 0xFFFFFAFA; 
    colorTable_[KnownColor.SpringGreen] = 0xFF00FF7F;
    colorTable_[KnownColor.SteelBlue] = 0xFF4682B4; 
    colorTable_[KnownColor.Tan] = 0xFFD2B48C; 
    colorTable_[KnownColor.Teal] = 0xFF008080;
    colorTable_[KnownColor.Thistle] = 0xFFD8BFD8; 
    colorTable_[KnownColor.Tomato] = 0xFFFF6347;
    colorTable_[KnownColor.Turquoise] = 0xFF40E0D0;
    colorTable_[KnownColor.Violet] = 0xFFEE82EE;
    colorTable_[KnownColor.Wheat] = 0xFFF5DEB3; 
    colorTable_[KnownColor.White] = 0xFFFFFFFF;
    colorTable_[KnownColor.WhiteSmoke] = 0xFFF5F5F5; 
    colorTable_[KnownColor.Yellow] = 0xFFFFFF00; 
    colorTable_[KnownColor.YellowGreen] = 0xFF9ACD32;
  }

  private static проц initNameTable() {
    nameTable_ = [ 
      "", "ActiveBorder", "ActiveCaption", "ActiveCaptionText", "AppWorkspace", "УпрЭлт", "ControlDark", "ControlDarkDark", 
      "ControlLight", "ControlLightLight", "ControlText", "РабСтол", "GrayText", "Highlight", "HighlightText", "HotTrack", 
      "InactiveBorder", "InactiveCaption", "InactiveCaptionText", "Info", "InfoText", "Menu", "MenuText", "ScrollBar", "Window", 
      "WindowFrame", "WindowText", "Transparent", "AliceBlue", "AntiqueWhite", "Aqua", "Aquamarine", "Azure", "Beige", "Bisque", 
      "Black", "BlanchedAlmond", "Blue", "BlueViolet", "Brown", "BurlyWood", "CadetBlue", "Chartreuse", "Chocolate", "Coral", 
      "CornflowerBlue", "Cornsilk", "Crimson", "Cyan", "DarkBlue", "DarkCyan", "DarkGoldenrod", "DarkGray", "DarkGreen", "DarkKhaki", 
      "DarkMagenta", "DarkOliveGreen", "DarkOrange", "DarkOrchid", "DarkRed", "DarkSalmon", "DarkSeaGreen", "DarkSlateBlue", 
      "DarkSlateGray", "DarkTurquoise", "DarkViolet", "DeepPink", "DeepSkyBlue", "DimGray", "DodgerBlue", "Firebrick", "FloralWhite", 
      "ForestGreen", "Fuchsia", "Gainsboro", "GhostWhite", "Gold", "Goldenrod", "Gray", "Green", "GreenYellow", "Honeydew", "HotPink", 
      "IndianRed", "Indigo", "Ivory", "Khaki", "Lavender", "LavenderBlush", "LawnGreen", "LemonChiffon", "LightBlue", "LightCoral", 
      "LightCyan", "LightGoldenrodYellow", "LightGray", "LightGreen", "LightPink", "LightSalmon", "LightSeaGreen", "LightSkyBlue", 
      "LightSlateGray", "LightSteelBlue", "LightYellow", "Lime", "LimeGreen", "Linen", "Magenta", "Maroon", "MediumAquamarine", 
      "MediumBlue", "MediumOrchid", "MediumPurple", "MediumSeaGreen", "MediumSlateBlue", "MediumSpringGreen", "MediumTurquoise", 
      "MediumVioletRed", "MidnightBlue", "MintCream", "MistyRose", "Moccasin", "NavajoWhite", "Navy", "OldLace", "Olive", "OliveDrab", 
      "Orange", "OrangeRed", "Orchid","PaleGoldenrod", "PaleGreen", "PaleTurquoise", "PaleVioletRed", "PapayaWhip", "PeachPuff", "Peru", 
      "Pink", "Plum", "PowderBlue", "Purple", "Red", "RosyBrown", "RoyalBlue", "SaddleBrown", "Salmon", "SandyBrown", "SeaGreen", 
      "SeaShell", "Sienna", "Silver", "SkyBlue", "SlateBlue", "SlateGray", "Snow", "SpringGreen", "SteelBlue", "Tan", "Teal", "Thistle", 
      "Tomato", "Turquoise", "Violet", "Wheat", "White", "WhiteSmoke", "Yellow", "YellowGreen", "ButtonFace", "ButtonHighlight", 
      "ButtonShadow", "GradientActiveCaption", "GradientInactiveCaption", "MenuBar", "MenuHighlight"
    ];
  }

  private static проц initHtmlTable() {
    htmlTable_["activeborder"] = Цвет.fromKnownColor(KnownColor.ActiveBorder);
    htmlTable_["activecaption"] = Цвет.fromKnownColor(KnownColor.ActiveCaption);
    htmlTable_["appworkspace"] = Цвет.fromKnownColor(KnownColor.AppWorkspace); 
    htmlTable_["background"] = Цвет.fromKnownColor(KnownColor.РабСтол);
    htmlTable_["buttonface"] = Цвет.fromKnownColor(KnownColor.УпрЭлт); 
    htmlTable_["buttonhighlight"] = Цвет.fromKnownColor(KnownColor.ControlLightLight); 
    htmlTable_["buttonshadow"] = Цвет.fromKnownColor(KnownColor.ControlDark);
    htmlTable_["buttontext"] = Цвет.fromKnownColor(KnownColor.ControlText); 
    htmlTable_["captiontext"] = Цвет.fromKnownColor(KnownColor.ActiveCaptionText);
    htmlTable_["graytext"] = Цвет.fromKnownColor(KnownColor.GrayText);
    htmlTable_["highlight"] = Цвет.fromKnownColor(KnownColor.Highlight);
    htmlTable_["highlighttext"] = Цвет.fromKnownColor(KnownColor.HighlightText); 
    htmlTable_["inactiveborder"] = Цвет.fromKnownColor(KnownColor.InactiveBorder);
    htmlTable_["inactivecaption"] = Цвет.fromKnownColor(KnownColor.InactiveCaption); 
    htmlTable_["inactivecaptiontext"] = Цвет.fromKnownColor(KnownColor.InactiveCaptionText); 
    htmlTable_["infobackground"] = Цвет.fromKnownColor(KnownColor.Info);
    htmlTable_["infotext"] = Цвет.fromKnownColor(KnownColor.InfoText); 
    htmlTable_["menu"] = Цвет.fromKnownColor(KnownColor.Menu);
    htmlTable_["menutext"] = Цвет.fromKnownColor(KnownColor.MenuText);
    htmlTable_["scrollbar"] = Цвет.fromKnownColor(KnownColor.ScrollBar);
    htmlTable_["threeddarkshadow"] = Цвет.fromKnownColor(KnownColor.ControlDarkDark); 
    htmlTable_["threedface"] = Цвет.fromKnownColor(KnownColor.УпрЭлт);
    htmlTable_["threedhighlight"] = Цвет.fromKnownColor(KnownColor.ControlLight); 
    htmlTable_["threedlightshadow"] = Цвет.fromKnownColor(KnownColor.ControlLightLight); 
    htmlTable_["window"] = Цвет.fromKnownColor(KnownColor.Window);
    htmlTable_["windowframe"] = Цвет.fromKnownColor(KnownColor.WindowFrame); 
    htmlTable_["windowtext"] = Цвет.fromKnownColor(KnownColor.WindowText);
  }

}

/**
 * Encapsulates a 3x3 affine matrix the represents a geometric transform.
 */
final class Matrix : ИВымещаемый {

  private Укз nativeMatrix_;

  /**
   * Initializes a new экземпляр.
   */
  this() {
    Status status = GdipCreateMatrix(nativeMatrix_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  this(плав m11, плав m12, плав m21, плав m22, плав dx, плав dy) {
    Status status = GdipCreateMatrix2(m11, m12, m21, m22, dx, dy, nativeMatrix_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  this(Прям прям, Точка[] plgpts) {
    if (plgpts.length != 3)
      throw statusException(Status.InvalidParameter);

    Status status = GdipCreateMatrix3I(прям, plgpts.ptr, nativeMatrix_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  this(ПрямП прям, ТочкаП[] plgpts) {
    if (plgpts.length != 3)
      throw statusException(Status.InvalidParameter);

    Status status = GdipCreateMatrix3(прям, plgpts.ptr, nativeMatrix_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  ~this() {
    dispose();
  }

  /**
   * Releases all resources used by this экземпляр.
   */
  проц dispose() {
    if (nativeMatrix_ != Укз.init) {
      GdipDeleteMatrixSafe(nativeMatrix_);
      nativeMatrix_ = Укз.init;
    }
  }

  /**
   * Creates an exact копируй of this object.
   * Returns: The object that this метод creates.
   */
  Объект clone() {
    Укз cloneMatrix;

    Status status = GdipCloneMatrix(nativeMatrix_, cloneMatrix);
    if (status != Status.ОК)
      throw statusException(status);

    return new Matrix(cloneMatrix);
  }

  /**
   * Inverts this object, if it is invertible.
   */
  проц invert() {
    Status status = GdipInvertMatrix(nativeMatrix_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * Resets this object to have the elements of the identity matrix.
   */
  проц сбрось() {
    Status status = GdipSetMatrixElements(nativeMatrix_, 1, 0, 0, 1, 0, 0);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * Multiplies this object by the specified object in the specified _order.
   * Params:
   *   matrix = The object by which this экземпляр is to be multiplied.
   *   order = The _order of the multiplication.
   */
  проц multiply(Matrix matrix, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipMultiplyMatrix(nativeMatrix_, matrix.nativeMatrix_, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * Applies the specified _scale vector to this oject in the specified _order.
   * Params:
   *   scaleX = The значение by which to _scale this object in the x-axis direction.
   *   scaleY = The значение by which to _scale this object in the y-axis direction.
   *   order = The _order in which the _scale vector is applied.
   */
  проц шкала(плав scaleX, плав scaleY, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipScaleMatrix(nativeMatrix_, scaleX, scaleY, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * Applies the specified _shear vector to this oject in the specified _order.
   * Params:
   *   scaleX = The horizontal _shear.
   *   scaleY = The vertical _shear.
   *   order = The _order in which the _shear vector is applied.
   */
  проц shear(плав shearX, плав shearY, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipShearMatrix(nativeMatrix_, shearX, shearY, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * Applies a clockwise rotation of the specified _angle about the origin to this object.
   * Params:
   *   angle = The _angle of the rotation.
   *   order = The _order in which the rotation is applied.
   */
  проц rotate(плав angle, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipRotateMatrix(nativeMatrix_, angle, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * Applies the specified translation vector to this object.
   * парамы:
   *   offsetX = The x значение by which to _translate this object.
   *   offsetY = The y значение by which to _translate this object.
   *   order = The _order in which the translation is applied.
   */
  проц translate(плав offsetX, плав offsetY, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipTranslateMatrix(nativeMatrix_, offsetX, offsetY, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * Gets an array of floating-point значения that represents the _elements of this object.
   */
  плав[] elements() {
    плав[] m = new плав[6];
    Status status = GdipGetMatrixElements(nativeMatrix_, m.ptr);
    if (status != Status.ОК)
      throw statusException(status);
    return m;
  }

  /**
   * Gets the x translation значение.
   */
  плав offsetX() {
    return elements[4];
  }

  /**
   * Gets the y translation значение.
   */
  плав offsetY() {
    return elements[5];
  }

  /**
   * Gets a значение indicating whether this object is the identity matrix.
   * Returns: true if this object is identity; otherwise, false.
   */
  бул isIdentity() {
    цел рез;
    Status status = GdipIsMatrixIdentity(nativeMatrix_, рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез == 1;
  }

  /**
   * Gets a значение indicating whether this object is invertible.
   * Returns: true if this matrix is invertible; otherwise, false.
   */
  бул isInvertible() {
    цел рез;
    Status status = GdipIsMatrixInvertible(nativeMatrix_, рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез == 1;
  }

  private this(Укз nativeMatrix) {
    nativeMatrix_ = nativeMatrix;
  }

}

/**
 * Represents the state of a Graphics object.
 */
final class GraphicsState {

  private цел nativeState_;

  private this(цел state) {
    nativeState_ = state;
  }

}

/**
 * Represents the internal данные of a graphics container.
 */
final class GraphicsContainer {

  private цел nativeContainer_;

  private this(цел container) {
    nativeContainer_ = container;
  }

}

/**
 * Encapsualtes a GDI+ drawing surface.
 */
final class Graphics : ИВымещаемый {

  /**
   * <code>бул delegate(ук callbackData)</code>
   *
   * Provides a обрвыз метод for deciding when the drawImage метод should prematurely отмена execution.
   * Params: callbackData = Pointer specifying данные for the обрвыз метод.
   * Returns: true if the метод decides that the drawImage метод should prematurely отмена execution; otherwise, false.
   */
  alias бул delegate(ук callbackData) DrawImageAbort;

  private Укз nativeGraphics_;
  private Укз nativeHdc_;

  private static Укз halftonePalette_;

  static ~this() {
    if (halftonePalette_ != Укз.init) {
      DeleteObject(halftonePalette_);
      halftonePalette_ = Укз.init;
    }
  }

  private this(Укз nativeGraphics) {
    nativeGraphics_ = nativeGraphics;
  }

  ~this() {
    dispose();
  }

  /**
   * Releases all the resources used by this экземпляр.
   */
  final проц dispose() {
    if (nativeGraphics_ != Укз.init) {
      if (nativeHdc_ != Укз.init)
        releaseHdc();

      GdipDeleteGraphicsSafe(nativeGraphics_);
      nativeGraphics_ = Укз.init;
    }
  }

  /**
   * Gets a указатель to the текущ Windows halftone palette.
   */
  static Укз getHalftonePalette() {
    synchronized {
      if (halftonePalette_ == Укз.init)
        halftonePalette_ = GdipCreateHalftonePalette();
      return halftonePalette_;
    }
  }

  /**
   * Creates a new экземпляр from the specified Image object.
   * Params: image = The Image object on which to create the new экземпляр.
   */
  static Graphics fromImage(Image image) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    Укз nativeGraphics;

    Status status = GdipGetImageGraphicsContext(image.nativeImage_, nativeGraphics);
    if (status != Status.ОК)
      throw statusException(status);

    return new Graphics(nativeGraphics);
  }

  /**
   * Creates a new экземпляр from the specified указатель to a window.
   * Params: hwnd = Укз to a window.
   */
  static Graphics fromHwnd(Укз hwnd) {
    Укз nativeGraphics;

    Status status = GdipCreateFromHWND(hwnd, nativeGraphics);
    if (status != Status.ОК)
      throw statusException(status);

    return new Graphics(nativeGraphics);
  }

  /**
   * Creates a new экземпляр from the specified указатель to a device context.
   * Params: hdc = Укз to a device context.
   */
  static Graphics fromHdc(Укз hdc) {
    Укз nativeGraphics;

    Status status = GdipCreateFromHDC(hdc, nativeGraphics);
    if (status != Status.ОК)
      throw statusException(status);

    return new Graphics(nativeGraphics);
  }

  /**
   * Creates a new экземпляр from the specified указатель to a device context and указатель to a device.
   * Params: 
   *   hdc = Укз to a device context.
   *   hdevice = Укз to a device.
   */
  static Graphics fromHdc(Укз hdc, Укз hdevice) {
    Укз nativeGraphics;

    Status status = GdipCreateFromHDC2(hdc, hdevice, nativeGraphics);
    if (status != Status.ОК)
      throw statusException(status);

    return new Graphics(nativeGraphics);
  }

  /**
   * Gets the указатель to the device context associated with this экземпляр.
   */
  Укз getHdc() {
    Укз hdc;

    Status status = GdipGetDC(nativeGraphics_, hdc);
    if (status != Status.ОК)
      throw statusException(status);

    return nativeHdc_ = hdc;
  }

  /**
   * Releases a device context указатель obtained by a previous call to the getHdc метод.
   * Params: hdc = Укз to a device context obtained by a previous call to the getHdc метод.
   */
  проц releaseHdc(Укз hdc) {
    Status status = GdipReleaseDC(nativeGraphics_, nativeHdc_);
    if (status != Status.ОК)
      throw statusException(status);

    nativeHdc_ = Укз.init;
  }

  /**
   * ditto
   */
  проц releaseHdc() {
    releaseHdc(nativeHdc_);
  }

  /**
   * Saves the текущ state of this экземпляр and identifies the saved state with a GraphicsState object.
   */
  GraphicsState save() {
    цел state;
    Status status = GdipSaveGraphics(nativeGraphics_, state);
    if (status != Status.ОК)
      throw statusException(status);
    return new GraphicsState(state);
  }
  
  /**
   * Restores the state of this экземпляр to the _state represented by a GraphicsState object.
   * Params: state = The _state to which to _restore this экземпляр.
   */
  проц restore(GraphicsState state) {
    Status status = GdipRestoreGraphics(nativeGraphics_, state.nativeState_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  GraphicsContainer beginContainer() {
    цел state;
    Status status = GdipBeginContainer2(nativeGraphics_, state);
    if (status != Status.ОК)
      throw statusException(status);
    return new GraphicsContainer(state);
  }

  /**
   */
  GraphicsContainer beginContainer(Прям dstrect, Прям srcrect, GraphicsUnit unit) {
    цел state;
    Status status = GdipBeginContainerI(nativeGraphics_, dstrect, srcrect, unit, state);
    if (status != Status.ОК)
      throw statusException(status);
    return new GraphicsContainer(state);
  }

  /**
   */
  GraphicsContainer beginContainer(ПрямП dstrect, ПрямП srcrect, GraphicsUnit unit) {
    цел state;
    Status status = GdipBeginContainer(nativeGraphics_, dstrect, srcrect, unit, state);
    if (status != Status.ОК)
      throw statusException(status);
    return new GraphicsContainer(state);
  }

  /**
   */
  проц endContainer(GraphicsContainer container) {
    if (container is null)
      throw new ИсклНулевогоАргумента("container");

    Status status = GdipEndContainer(nativeGraphics_, container.nativeContainer_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц setClip(Graphics g, CombineMode combineMode = CombineMode.Replace) {
    if (g is null)
      throw new ИсклНулевогоАргумента("g");

    Status status = GdipSetClipGraphics(nativeGraphics_, g.nativeGraphics_, combineMode);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц setClip(Прям прям, CombineMode combineMode = CombineMode.Replace) {
    Status status = GdipSetClipRectI(nativeGraphics_, прям.x, прям.y, прям.ширина, прям.высота, combineMode);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц setClip(ПрямП прям, CombineMode combineMode = CombineMode.Replace) {
    Status status = GdipSetClipRect(nativeGraphics_, прям.x, прям.y, прям.ширина, прям.высота, combineMode);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц setClip(Path путь, CombineMode combineMode = CombineMode.Replace) {
    if (путь is null)
      throw new ИсклНулевогоАргумента("путь");

    Status status = GdipSetClipPath(nativeGraphics_, путь.nativePath_, combineMode);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц setClip(Регион region, CombineMode combineMode) {
    if (region is null)
      throw new ИсклНулевогоАргумента("region");

    Status status = GdipSetClipRegion(nativeGraphics_, region.nativeRegion_, combineMode);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц intersectClip(ПрямП прям) {
    Status status = GdipSetClipRect(nativeGraphics_, прям.x, прям.y, прям.ширина, прям.высота, CombineMode.Intersect);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц intersectClip(Прям прям) {
    Status status = GdipSetClipRectI(nativeGraphics_, прям.x, прям.y, прям.ширина, прям.высота, CombineMode.Intersect);
    if (status != Status.ОК)
      throw statusException(status);
  }

  проц intersectClip(Регион region) {
    if (region is null)
      throw new ИсклНулевогоАргумента("region");

    Status status = GdipSetClipRegion(nativeGraphics_, region.nativeRegion_, CombineMode.Intersect);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц excludeClip(ПрямП прям) {
    Status status = GdipSetClipRect(nativeGraphics_, прям.x, прям.y, прям.ширина, прям.высота, CombineMode.Exclude);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц excludeClip(Прям прям) {
    Status status = GdipSetClipRectI(nativeGraphics_, прям.x, прям.y, прям.ширина, прям.высота, CombineMode.Exclude);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц excludeClip(Регион region) {
    if (region is null)
      throw new ИсклНулевогоАргумента("region");

    Status status = GdipSetClipRegion(nativeGraphics_, region.nativeRegion_, CombineMode.Exclude);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц resetClip() {
    Status status = GdipResetClip(nativeGraphics_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц translateClip(цел dx, цел dy) {
    Status status = GdipTranslateClip(nativeGraphics_, cast(плав)dx, cast(плав)dy);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц translateClip(плав dx, плав dy) {
    Status status = GdipTranslateClip(nativeGraphics_, dx, dy);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  бул isVisible(цел x, цел y) {
    return isVisible(Точка(x, y));
  }

  /**
   */
  бул isVisible(Точка point) {
    цел рез = 0;
    Status status = GdipIsVisiblePointI(nativeGraphics_, point.x, point.y, рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез == 1;
  }

  /**
   */
  бул isVisible(цел x, цел y, цел ширина, цел высота) {
    return isVisible(Прям(x, y, ширина, высота));
  }

  /**
   */
  бул isVisible(Прям прям) {
    цел рез = 0;
    Status status = GdipIsVisibleRectI(nativeGraphics_, прям.x, прям.y, прям.ширина, прям.высота, рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез == 1;
  }

  /**
   */
  бул isVisible(плав x, плав y) {
    return isVisible(ТочкаП(x, y));
  }

  /**
   */
  бул isVisible(ТочкаП point) {
    цел рез = 0;
    Status status = GdipIsVisiblePoint(nativeGraphics_, point.x, point.y, рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез == 1;
  }

  /**
   */
  бул isVisible(плав x, плав y, плав ширина, плав высота) {
    return isVisible(ПрямП(x, y, ширина, высота));
  }

  /**
   */
  бул isVisible(ПрямП прям) {
    цел рез = 0;
    Status status = GdipIsVisibleRect(nativeGraphics_, прям.x, прям.y, прям.ширина, прям.высота, рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез == 1;
  }

  /**
   */
  проц addMetafileComment(ббайт[] данные) {
    Status status = GdipComment(nativeGraphics_, данные.length, данные.ptr);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц слей(FlushIntention intention = FlushIntention.Flush) {
    Status status = GdipFlush(nativeGraphics_, intention);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц scaleTransform(плав sx, плав sy, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipScaleWorldTransform(nativeGraphics_, sx, sy, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц rotateTransform(плав angle, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipRotateWorldTransform(nativeGraphics_, angle, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц translateTransform(плав dx, плав dy, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipTranslateWorldTransform(nativeGraphics_, dx, dy, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц multiplyTransform(Matrix matrix, MatrixOrder order = MatrixOrder.Prepend) {
    if (matrix is null)
      throw new ИсклНулевогоАргумента("matrix");

    Status status = GdipMultiplyWorldTransform(nativeGraphics_, matrix.nativeMatrix_, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц resetTransform() {
    Status status = GdipResetWorldTransform(nativeGraphics_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц transformPoints(CoordinateSpace destSpace, CoordinateSpace srcSpace, ТочкаП[] points) {
    Status status = GdipTransformPoints(nativeGraphics_, destSpace, srcSpace, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц transformPoints(CoordinateSpace destSpace, CoordinateSpace srcSpace, Точка[] points) {
    Status status = GdipTransformPointsI(nativeGraphics_, destSpace, srcSpace, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  Цвет getNearestColor(Цвет цвет) {
    бцел argb = цвет.toArgb();
    Status status = GdipGetNearestColor(nativeGraphics_, argb);
    if (status != Status.ОК)
      throw statusException(status);
    return Цвет.fromArgb(argb);
  }

  /**
   */
  проц сотри(Цвет цвет) {
    Status status = GdipGraphicsClear(nativeGraphics_, цвет.toArgb());
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawLine(Pen pen, плав x1, плав y1, плав x2, плав y2) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawLine(nativeGraphics_, pen.nativePen_, x1, y1, x2, y2);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawLine(Pen pen, ТочкаП pt1, ТочкаП pt2) {
    drawLine(pen, pt1.x, pt1.y, pt2.x, pt2.y);
  }

  /**
   */
  проц drawLines(Pen pen, ТочкаП[] points) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawLines(nativeGraphics_, pen.nativePen_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawLine(Pen pen, цел x1, цел y1, цел x2, цел y2) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawLineI(nativeGraphics_, pen.nativePen_, x1, y1, x2, y2);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawLine(Pen pen, Точка pt1, Точка pt2) {
    drawLine(pen, pt1.x, pt1.y, pt2.x, pt2.y);
  }

  /**
   */
  проц drawLines(Pen pen, Точка[] points) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawLinesI(nativeGraphics_, pen.nativePen_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawArc(Pen pen, плав x, плав y, плав ширина, плав высота, плав startAngle, плав sweepAngle) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawArc(nativeGraphics_, pen.nativePen_, x, y, ширина, высота, startAngle, sweepAngle);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawArc(Pen pen, ПрямП прям, плав startAngle, плав sweepAngle) {
    drawArc(pen, прям.x, прям.y, прям.ширина, прям.высота, startAngle, sweepAngle);
  }

  /**
   */
  проц drawArc(Pen pen, цел x, цел y, цел ширина, цел высота, плав startAngle, плав sweepAngle) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawArcI(nativeGraphics_, pen.nativePen_, x, y, ширина, высота, startAngle, sweepAngle);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawArc(Pen pen, Прям прям, плав startAngle, плав sweepAngle) {
    drawArc(pen, прям.x, прям.y, прям.ширина, прям.высота, startAngle, sweepAngle);
  }

  /**
   */
  проц drawBezier(Pen pen, плав x1, плав y1, плав x2, плав y2, плав x3, плав y3, плав x4, плав y4) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawBezier(nativeGraphics_, pen.nativePen_, x1, y1, x2, y2, x3, y3, x4, y4);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawBezier(Pen pen, ТочкаП pt1, ТочкаП pt2, ТочкаП pt3, ТочкаП pt4) {
    drawBezier(pen, pt1.x, pt1.y, pt2.x, pt2.y, pt3.x, pt3.y, pt4.x, pt4.y);
  }

  /**
   */
  проц drawBeziers(Pen pen, ТочкаП[] points) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawBeziers(nativeGraphics_, pen.nativePen_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawBezier(Pen pen, цел x1, цел y1, цел x2, цел y2, цел x3, цел y3, цел x4, цел y4) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawBezierI(nativeGraphics_, pen.nativePen_, x1, y1, x2, y2, x3, y3, x4, y4);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawBezier(Pen pen, Точка pt1, Точка pt2, Точка pt3, Точка pt4) {
    drawBezier(pen, pt1.x, pt1.y, pt2.x, pt2.y, pt3.x, pt3.y, pt4.x, pt4.y);
  }

  /**
   */
  проц drawBeziers(Pen pen, Точка[] points) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawBeziersI(nativeGraphics_, pen.nativePen_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawRectangle(Pen pen, плав x, плав y, плав ширина, плав высота) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawRectangle(nativeGraphics_, pen.nativePen_, x, y, ширина, высота);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawRectangle(Pen pen, ПрямП прям) {
    drawRectangle(pen, прям.x, прям.y, прям.ширина, прям.высота);
  }

  /**
   */
  проц drawRectangles(Pen pen, ПрямП[] rects) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawRectangles(nativeGraphics_, pen.nativePen_, rects.ptr, rects.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawRectangle(Pen pen, цел x, цел y, цел ширина, цел высота) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawRectangleI(nativeGraphics_, pen.nativePen_, x, y, ширина, высота);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawRectangle(Pen pen, Прям прям) {
    drawRectangle(pen, прям.x, прям.y, прям.ширина, прям.высота);
  }

  /**
   */
  проц drawRectangles(Pen pen, Прям[] rects) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawRectanglesI(nativeGraphics_, pen.nativePen_, rects.ptr, rects.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawEllipse(Pen pen, плав x, плав y, плав ширина, плав высота) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawEllipse(nativeGraphics_, pen.nativePen_, x, y, ширина, высота);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawEllipse(Pen pen, ПрямП прям) {
    drawEllipse(pen, прям.x, прям.y, прям.ширина, прям.высота);
  }

  /**
   */
  проц drawEllipse(Pen pen, цел x, цел y, цел ширина, цел высота) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawEllipseI(nativeGraphics_, pen.nativePen_, x, y, ширина, высота);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawEllipse(Pen pen, Прям прям) {
    drawEllipse(pen, прям.x, прям.y, прям.ширина, прям.высота);
  }

  /**
   */
  проц drawPie(Pen pen, плав x, плав y, плав ширина, плав высота, плав startAngle, плав sweepAngle) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawPie(nativeGraphics_, pen.nativePen_, x, y, ширина, высота, startAngle, sweepAngle);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawPie(Pen pen, ПрямП прям, плав startAngle, плав sweepAngle) {
    drawPie(pen, прям.x, прям.y, прям.ширина, прям.высота, startAngle, sweepAngle);
  }

  /**
   */
  проц drawPie(Pen pen, цел x, цел y, цел ширина, цел высота, плав startAngle, плав sweepAngle) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawPieI(nativeGraphics_, pen.nativePen_, x, y, ширина, высота, startAngle, sweepAngle);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawPie(Pen pen, Прям прям, плав startAngle, плав sweepAngle) {
    drawPie(pen, прям.x, прям.y, прям.ширина, прям.высота, startAngle, sweepAngle);
  }

  /**
   */
  проц drawPolygon(Pen pen, ТочкаП[] points) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawPolygon(nativeGraphics_, pen.nativePen_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawPolygon(Pen pen, Точка[] points) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawPolygonI(nativeGraphics_, pen.nativePen_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawPath(Pen pen, Path путь) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    if (путь is null)
      throw new ИсклНулевогоАргумента("путь");

    Status status = GdipDrawPath(nativeGraphics_, pen.nativePen_, путь.nativePath_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawCurve(Pen pen, ТочкаП[] points) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawCurve(nativeGraphics_, pen.nativePen_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawCurve(Pen pen, ТочкаП[] points, плав tension) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawCurve2(nativeGraphics_, pen.nativePen_, points.ptr, points.length, tension);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawCurve(Pen pen, ТочкаП[] points, цел смещение, цел numberOfSegments, плав tension = 0.5f) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawCurve3(nativeGraphics_, pen.nativePen_, points.ptr, points.length, смещение, numberOfSegments, tension);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawCurve(Pen pen, Точка[] points) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawCurveI(nativeGraphics_, pen.nativePen_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawCurve(Pen pen, Точка[] points, плав tension) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawCurve2I(nativeGraphics_, pen.nativePen_, points.ptr, points.length, tension);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawCurve(Pen pen, Точка[] points, цел смещение, цел numberOfSegments, плав tension = 0.5f) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawCurve3I(nativeGraphics_, pen.nativePen_, points.ptr, points.length, смещение, numberOfSegments, tension);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawClosedCurve(Pen pen, ТочкаП[] points) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawClosedCurve(nativeGraphics_, pen.nativePen_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawClosedCurve(Pen pen, ТочкаП[] points, плав tension) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawClosedCurve2(nativeGraphics_, pen.nativePen_, points.ptr, points.length, tension);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawClosedCurve(Pen pen, Точка[] points) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawClosedCurveI(nativeGraphics_, pen.nativePen_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawClosedCurve(Pen pen, Точка[] points, плав tension) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipDrawClosedCurve2I(nativeGraphics_, pen.nativePen_, points.ptr, points.length, tension);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц fillRectangle(Brush brush, плав x, плав y, плав ширина, плав высота) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    Status status = GdipFillRectangle(nativeGraphics_, brush.nativeBrush_, x, y, ширина, высота);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц fillRectangle(Brush brush, ПрямП прям) {
    fillRectangle(brush, прям.x, прям.y, прям.ширина, прям.высота);
  }

  /**
   */
  проц fillRectangles(Brush brush, ПрямП[] rects) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    Status status = GdipFillRectangles(nativeGraphics_, brush.nativeBrush_, rects.ptr, rects.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц fillRectangle(Brush brush, цел x, цел y, цел ширина, цел высота) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    Status status = GdipFillRectangleI(nativeGraphics_, brush.nativeBrush_, x, y, ширина, высота);
  }

  проц fillRectangle(Brush brush, Прям прям) {
    fillRectangle(brush, прям.x, прям.y, прям.ширина, прям.высота);
  }

  /**
   */
  проц fillRectangles(Brush brush, Прям[] rects) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    Status status = GdipFillRectanglesI(nativeGraphics_, brush.nativeBrush_, rects.ptr, rects.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц fillRegion(Brush brush, Регион region) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    if (region is null)
      throw new ИсклНулевогоАргумента("region");

    Status status = GdipFillRegion(nativeGraphics_, brush.nativeBrush_, region.nativeRegion_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц fillPolygon(Brush brush, ТочкаП[] points, FillMode fillMode = FillMode.Alternate) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    Status status = GdipFillPolygon(nativeGraphics_, brush.nativeBrush_, points.ptr, points.length, fillMode);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц fillPolygon(Brush brush, Точка[] points, FillMode fillMode = FillMode.Alternate) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    Status status = GdipFillPolygonI(nativeGraphics_, brush.nativeBrush_, points.ptr, points.length, fillMode);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц fillEllipse(Brush brush, плав x, плав y, плав ширина, плав высота) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    Status status = GdipFillEllipse(nativeGraphics_, brush.nativeBrush_, x, y, ширина, высота);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц fillEllipse(Brush brush, ПрямП прям) {
    fillEllipse(brush, прям.x, прям.y, прям.ширина, прям.высота);
  }

  /**
   */
  проц fillEllipse(Brush brush, цел x, цел y, цел ширина, цел высота) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    Status status = GdipFillEllipseI(nativeGraphics_, brush.nativeBrush_, x, y, ширина, высота);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц fillEllipse(Brush brush, Прям прям) {
    fillEllipse(brush, прям.x, прям.y, прям.ширина, прям.высота);
  }

  /**
   */
  проц fillPie(Brush brush, плав x, плав y, плав ширина, плав высота, плав startAngle, плав sweepAngle) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    Status status = GdipFillPie(nativeGraphics_, brush.nativeBrush_, x, y, ширина, высота, startAngle, sweepAngle);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц fillPie(Brush brush, ПрямП прям, плав startAngle, плав sweepAngle) {
    fillPie(brush, прям.x, прям.y, прям.ширина, прям.высота, startAngle, sweepAngle);
  }

  /**
   */
  проц fillPie(Brush brush, цел x, цел y, цел ширина, цел высота, плав startAngle, плав sweepAngle) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    Status status = GdipFillPieI(nativeGraphics_, brush.nativeBrush_, x, y, ширина, высота, startAngle, sweepAngle);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц fillPath(Brush brush, Path путь) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    if (путь is null)
      throw new ИсклНулевогоАргумента("путь");

    Status status = GdipFillPath(nativeGraphics_, brush.nativeBrush_, путь.nativePath_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц fillClosedCurve(Brush brush, ТочкаП[] points) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    Status status = GdipFillClosedCurve(nativeGraphics_, brush.nativeBrush_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц fillClosedCurve(Brush brush, ТочкаП[] points, FillMode fillMode, плав tension = 0.5f) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    Status status = GdipFillClosedCurve2(nativeGraphics_, brush.nativeBrush_, points.ptr, points.length, fillMode, tension);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц fillClosedCurve(Brush brush, Точка[] points) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    Status status = GdipFillClosedCurveI(nativeGraphics_, brush.nativeBrush_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц fillClosedCurve(Brush brush, Точка[] points, FillMode fillMode, плав tension = 0.5f) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    Status status = GdipFillClosedCurve2I(nativeGraphics_, brush.nativeBrush_, points.ptr, points.length, fillMode, tension);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawImage(Image image, ТочкаП point) {
    drawImage(image, point.x, point.y);
  }

  /**
   */
  проц drawImage(Image image, плав x, плав y) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    Status status = GdipDrawImage(nativeGraphics_, image.nativeImage_, x, y);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * Draws the specified Image at the specified положение and with the specified размер.
   * Params:
   *   image = The Image to draw.
   *   прям = The положение and размер of the drawn _image.
   */
  проц drawImage(Image image, ПрямП прям) {
    drawImage(image, прям.x, прям.y, прям.ширина, прям.высота);
  }

  /**
   * Draws the specified Image at the specified положение and with the specified размер.
   * Params:
   *   image = The Image to draw.
   *   x = The x-coordinate of the upper-лево corner of the drawn _image.
   *   y = The y-coordinate of the upper-лево corner of the drawn _image.
   *   ширина = The _width of the drawn _image.
   *   высота = The _height of the drawn _image.
   */
  проц drawImage(Image image, плав x, плав y, плав ширина, плав высота) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    Status status = GdipDrawImageRect(nativeGraphics_, image.nativeImage_, x, y, ширина, высота);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * Draws a portion of an _image at a specified положение.
   * Params:
   *   image = The Image to draw.
   *   x = The x-coordinate of the upper-лево corner of the drawn _image.
   *   y = The y-coordinate of the upper-лево corner of the drawn _image.
   *   srcRect = The portion of the _image to draw.
   *   srcUnit = A член of the GraphicsUnit consteration that specifies the units of measure used by srcRect.
   */
  проц drawImage(Image image, плав x, плав y, Прям srcRect, GraphicsUnit srcUnit) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    Status status = GdipDrawImagePointRect(nativeGraphics_, image.nativeImage_, x, y, srcRect.x, srcRect.y, srcRect.ширина, srcRect.высота, srcUnit);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawImage(Image image, ПрямП destRect, ПрямП srcRect, GraphicsUnit srcUnit) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    Status status = GdipDrawImageRectRect(nativeGraphics_, image.nativeImage_, destRect.x, destRect.y, destRect.ширина, destRect.y, srcRect.x, srcRect.y, srcRect.ширина, srcRect.высота, srcUnit, Укз.init, null, null);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * Draws the specified portion of the specified Image at the specified положение and with the specified размер.
   * Params:
   *   image = The Image to draw.
   *   destRect = The положение and размер of the drawn _image. The _image is scaled to fit the rectangle.
   *   srcX = The x-coordinate of the upper-лево corner of the portion of the исток _image to draw.
   *   srcY = The y-coordinate of the upper-лево corner of the portion of the исток _image to draw.
   *   srcWidth = The ширина of the portion of the исток _image to draw.
   *   srcHeight = The высота of the portion of the исток _image to draw.
   *   srcUnit = A член of the GraphicsUnit consteration that specifies the units of measure used by srcRect.
   *   imageAttrs = Specifies recoloring and gamma information.
   *   обрвыз = A delegate that specifies a метод to call during the drawing of the _image to check whether to stop execution of the метод.
   *   callbackData = Value specifying additional данные for the обрвыз to use when checking whether to stop execution of the метод.
   */
  проц drawImage(Image image, ПрямП destRect, плав srcX, плав srcY, плав srcWidth, плав srcHeight, GraphicsUnit srcUnit, ImageAttributes imageAttrs = null, DrawImageAbort обрвыз = null, ук callbackData = null) {

    static DrawImageAbort callbackDelegate;

    extern(Windows) static цел drawImageAbortCallback(ук callbackData) {
      return callbackDelegate(callbackData) ? 1 : 0;
    }

    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    callbackDelegate = обрвыз;
    Status status = GdipDrawImageRectRect(nativeGraphics_, image.nativeImage_, destRect.x, destRect.y, destRect.ширина, destRect.высота, srcX, srcY, srcWidth, srcHeight, srcUnit, (imageAttrs is null ? Укз.init : imageAttrs.nativeImageAttributes), (обрвыз == null ? null : &drawImageAbortCallback), callbackData);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawImage(Image image, ТочкаП[] destPoints) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    if (destPoints.length != 3 && destPoints.length != 4)
      throw new win32.base.core.ИсклАргумента("Destination points must be an array with a length of 3 or 4.");

    Status status = GdipDrawImagePoints(nativeGraphics_, image.nativeImage_, destPoints.ptr, destPoints.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawImage(Image image, ТочкаП[] destPoints, ПрямП srcRect, GraphicsUnit srcUnit, ImageAttributes imageAttrs = null, DrawImageAbort обрвыз = null, ук callbackData = null) {
    static DrawImageAbort callbackDelegate;

    extern(Windows) static цел drawImageAbortCallback(ук callbackData) {
      return callbackDelegate(callbackData) ? 1 : 0;
    }

    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    if (destPoints.length != 3 && destPoints.length != 4)
      throw new win32.base.core.ИсклАргумента("Destination points must be an array with a length of 3 or 4.");

   callbackDelegate = обрвыз;
   Status status = GdipDrawImagePointsRect(nativeGraphics_, image.nativeImage_, destPoints.ptr, destPoints.length, srcRect.x, srcRect.y, srcRect.ширина, srcRect.высота, srcUnit, (imageAttrs is null ? Укз.init : imageAttrs.nativeImageAttributes), (обрвыз == null ? null : &drawImageAbortCallback), callbackData);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawImage(Image image, Точка point) {
    drawImage(image, point.x, point.y);
  }

  /**
   */
  проц drawImage(Image image, цел x, цел y) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    Status status = GdipDrawImageI(nativeGraphics_, image.nativeImage_, x, y);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawImage(Image image, Прям прям) {
    drawImage(image, прям.x, прям.y, прям.ширина, прям.высота);
  }

  /**
   */
  проц drawImage(Image image, цел x, цел y, цел ширина, цел высота) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    Status status = GdipDrawImageRectI(nativeGraphics_, image.nativeImage_, x, y, ширина, высота);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawImage(Image image, цел x, цел y, Прям srcRect, GraphicsUnit srcUnit) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    Status status = GdipDrawImagePointRectI(nativeGraphics_, image.nativeImage_, x, y, srcRect.x, srcRect.y, srcRect.ширина, srcRect.высота, srcUnit);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawImage(Image image, Прям destRect, Прям srcRect, GraphicsUnit srcUnit) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    Status status = GdipDrawImageRectRectI(nativeGraphics_, image.nativeImage_, 
      destRect.x, destRect.y, destRect.ширина, destRect.высота, 
      srcRect.x, srcRect.y, srcRect.ширина, srcRect.высота, srcUnit, Укз.init, null, null);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawImage(Image image, Прям destRect, цел srcX, цел srcY, цел srcWidth, цел srcHeight, GraphicsUnit srcUnit, ImageAttributes imageAttrs = null, DrawImageAbort обрвыз = null, ук callbackData = null) {

    static DrawImageAbort callbackDelegate;

    extern(Windows) static цел drawImageAbortCallback(ук callbackData) {
      return callbackDelegate(callbackData) ? 1 : 0;
    }

    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    callbackDelegate = обрвыз;
    Status status = GdipDrawImageRectRectI(nativeGraphics_, image.nativeImage_, destRect.x, destRect.y, destRect.ширина, destRect.высота, srcX, srcY, srcWidth, srcHeight, srcUnit, (imageAttrs is null ? Укз.init : imageAttrs.nativeImageAttributes), (обрвыз == null ? null : &drawImageAbortCallback), callbackData);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawImage(Image image, Точка[] destPoints) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    if (destPoints.length != 3 && destPoints.length != 4)
      throw new win32.base.core.ИсклАргумента("Destination points must be an array with a length of 3 or 4.");

    Status status = GdipDrawImagePointsI(nativeGraphics_, image.nativeImage_, destPoints.ptr, destPoints.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawImage(Image image, Точка[] destPoints, Прям srcRect, GraphicsUnit srcUnit, ImageAttributes imageAttrs = null, DrawImageAbort обрвыз = null, ук callbackData = null) {
    static DrawImageAbort callbackDelegate;

    extern(Windows) static цел drawImageAbortCallback(ук callbackData) {
      return callbackDelegate(callbackData) ? 1 : 0;
    }

    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    if (destPoints.length != 3 && destPoints.length != 4)
      throw new win32.base.core.ИсклАргумента("Destination points must be an array with a length of 3 or 4.");

   callbackDelegate = обрвыз;
   Status status = GdipDrawImagePointsRectI(nativeGraphics_, image.nativeImage_, destPoints.ptr, destPoints.length, srcRect.x, srcRect.y, srcRect.ширина, srcRect.высота, srcUnit, (imageAttrs is null ? Укз.init : imageAttrs.nativeImageAttributes), (обрвыз == null ? null : &drawImageAbortCallback), callbackData);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц drawString(ткст s, Font font, Brush brush, плав x, плав y, StringFormat format = null) {
    drawString(s, font, brush, ПрямП(x, y, 0, 0), format);
  }

  /**
   */
  проц drawString(ткст s, Font font, Brush brush, ТочкаП point, StringFormat format = null) {
    drawString(s, font, brush, ПрямП(point.x, point.y, 0, 0), format);
  }

  /**
   */
  проц drawString(ткст s, Font font, Brush brush, ПрямП layoutRect, StringFormat format = null) {
    if (brush is null)
      throw new ИсклНулевогоАргумента("brush");

    if (s != null) {
      if (font is null)
        throw new ИсклНулевогоАргумента("font");

      Status status = GdipDrawString(nativeGraphics_, s.вУтф16н(), s.length, font.nativeFont_, layoutRect, (format is null) ? Укз.init : format.nativeFormat_, brush.nativeBrush_);
      if (status != Status.ОК)
        throw statusException(status);
    }
  }

  /**
   */
  SizeF measureString(ткст s, Font font) {
    return measureString(s, font, SizeF.пустой);
  }

  /**
   */
  SizeF measureString(ткст s, Font font, ТочкаП origin, StringFormat format = null) {
    if (s == null)
      return SizeF.пустой;

    if (font is null)
      throw new ИсклНулевогоАргумента("font");

    ПрямП layoutRect = ПрямП(origin.x, origin.y, 0f, 0f);
    ПрямП boundingBox;
    цел codepointsFitted, linesFilled;

    Status status = GdipMeasureString(nativeGraphics_, s.вУтф16н(), s.length, font.nativeFont_, layoutRect, (format is null) ? Укз.init : format.nativeFormat_, boundingBox, codepointsFitted, linesFilled);
    if (status != Status.ОК)
      throw statusException(status);

    return boundingBox.размер;
  }

  /**
   */
  SizeF measureString(ткст s, Font font, SizeF layoutArea, StringFormat format = null) {
    if (s == null)
      return SizeF.пустой;

    if (font is null)
      throw new ИсклНулевогоАргумента("font");

    ПрямП layoutRect = ПрямП(0f, 0f, layoutArea.ширина, layoutArea.высота);
    ПрямП boundingBox;
    цел codepointsFitted, linesFilled;

    Status status = GdipMeasureString(nativeGraphics_, s.вУтф16н(), s.length, font.nativeFont_, layoutRect, (format is null) ? Укз.init : format.nativeFormat_, boundingBox, codepointsFitted, linesFilled);
    if (status != Status.ОК)
      throw statusException(status);

    return boundingBox.размер;
  }

  /**
   */
  SizeF measureString(ткст s, Font font, SizeF layoutArea, StringFormat format, out цел codepointsFitted, out цел linesFilled) {
    if (s == null)
      return SizeF.пустой;

    if (font is null)
      throw new ИсклНулевогоАргумента("font");

    ПрямП layoutRect = ПрямП(0, 0, layoutArea.ширина, layoutArea.высота);
    ПрямП boundingBox;

    Status status = GdipMeasureString(nativeGraphics_, s.вУтф16н(), s.length, font.nativeFont_, layoutRect, (format is null) ? Укз.init : format.nativeFormat_, boundingBox, codepointsFitted, linesFilled);
    if (status != Status.ОК)
      throw statusException(status);

    return boundingBox.размер;
  }

  /**
   */
  Регион[] measureCharacterRanges(ткст s, Font font, ПрямП layoutRect, StringFormat format) {
    if (s == null)
      return new Регион[0];

    if (font is null)
      throw new ИсклНулевогоАргумента("font");

    цел regionCount;
    Status status = GdipGetStringFormatMeasurableCharacterRangeCount((format is null) ? Укз.init : format.nativeFormat_, regionCount);
    if (status != Status.ОК)
      throw statusException(status);

    auto nativeRegions = new Укз[regionCount];
    auto regions = new Регион[regionCount];

    for (цел i = 0; i < regionCount; i++) {
      regions[i] = new Регион;
      nativeRegions[i] = regions[i].nativeRegion_;
    }

    status = GdipMeasureCharacterRanges(nativeGraphics_, s.вУтф16н(), s.length, font.nativeFont_, layoutRect, (format is null) ? Укз.init : format.nativeFormat_, regionCount, nativeRegions.ptr);
    if (status != Status.ОК)
      throw statusException(status);

    return regions;
  }

  /**
   */
  плав dpiX() {
    плав dpi = 0f;
    Status status = GdipGetDpiX(nativeGraphics_, dpi);
    if (status != Status.ОК)
      throw statusException(status);
    return dpi;
  }

  /**
   */
  плав dpiY() {
    плав dpi = 0f;
    Status status = GdipGetDpiY(nativeGraphics_, dpi);
    if (status != Status.ОК)
      throw statusException(status);
    return dpi;
  }

  /**
   */
  проц pageScale(плав значение) {
    Status status = GdipSetPageScale(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /// ditto
  плав pageScale() {
    плав шкала = 0f;
    Status status = GdipGetPageScale(nativeGraphics_, шкала);
    if (status != Status.ОК)
      throw statusException(status);
    return шкала;
  }

  /**
   */
  проц pageUnit(GraphicsUnit значение) {
    Status status = GdipSetPageUnit(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /// ditto
  GraphicsUnit pageUnit() {
    GraphicsUnit значение;
    Status status = GdipGetPageUnit(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
    return значение;
  }

  /**
   */
  проц compositingMode(CompositingMode значение) {
    Status status = GdipSetCompositingMode(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /// ditto
  CompositingMode compositingMode() {
    CompositingMode mode;
    Status status = GdipGetCompositingMode(nativeGraphics_, mode);
    if (status != Status.ОК)
      throw statusException(status);
    return mode;
  }

  /**
   */
  проц compositingQuality(CompositingQuality значение) {
    Status status = GdipSetCompositingQuality(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /// ditto
  CompositingQuality compositingQuality() {
    CompositingQuality значение;
    Status status = GdipGetCompositingQuality(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
    return значение;
  }

  /**
   */
  InterpolationMode interpolationMode() {
    InterpolationMode значение;
    Status status = GdipGetInterpolationMode(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
    return значение;
  }
  /// ditto
  проц interpolationMode(InterpolationMode значение) {
    Status status = GdipSetInterpolationMode(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц smoothingMode(SmoothingMode значение) {
    Status status = GdipSetSmoothingMode(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /// ditto
  SmoothingMode smoothingMode() {
    SmoothingMode mode;
    Status status = GdipGetSmoothingMode(nativeGraphics_, mode);
    if (status != Status.ОК)
      throw statusException(status);
    return mode;
  }

  /**
   */
  проц pixelOffsetMode(PixelOffsetMode значение) {
    Status status = GdipSetPixelOffsetMode(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /// ditto
  PixelOffsetMode pixelOffsetMode() {
    PixelOffsetMode значение;
    Status status = GdipGetPixelOffsetMode(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
    return значение;
  }

  /**
   */
  проц textContrast(бцел значение) {
    Status status = GdipSetTextContrast(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /// ditto
  бцел textContrast() {
    бцел contrast;
    Status status = GdipGetTextContrast(nativeGraphics_, contrast);
    if (status != Status.ОК)
      throw statusException(status);
    return contrast;
  }

  /**
   */
  проц textRenderingHint(TextRenderingHint значение) {
    Status status = GdipSetTextRenderingHint(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /// ditto
  TextRenderingHint textRenderingHint() {
    TextRenderingHint значение;
    Status status = GdipGetTextRenderingHint(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
    return значение;
  }

  /**
   */
  бул isClipEmpty() {
    цел значение;
    Status status = GdipIsClipEmpty(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
    return значение == 1;
  }

  /**
   */
  бул isVisibleClipEmpty() {
    цел значение;
    Status status = GdipIsVisibleClipEmpty(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
    return значение == 1;
  }

  /**
   */
  ПрямП clipBounds() {
    ПрямП значение;
    Status status = GdipGetClipBounds(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
    return значение;
  }

  /**
   */
  ПрямП visibleClipBounds() {
    ПрямП значение;
    Status status = GdipGetVisibleClipBounds(nativeGraphics_, значение);
    if (status != Status.ОК)
      throw statusException(status);
    return значение;
  }

  /**
   */
  проц renderingOrigin(Точка значение) {
    Status status = GdipGetRenderingOrigin(nativeGraphics_, значение.x, значение.y);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  Точка renderingOrigin() {
    цел x, y;
    Status status = GdipGetRenderingOrigin(nativeGraphics_, x, y);
    if (status != Status.ОК)
      throw statusException(status);
    return Точка(x, y);
  }

  /**
   */
  проц transform(Matrix значение) {
    Status status = GdipSetWorldTransform(nativeGraphics_, значение.nativeMatrix_);
    if (status != Status.ОК)
      throw statusException(status);
  }
  /**
   * ditto
   */
  Matrix transform() {
    Matrix matrix = new Matrix;
    Status status = GdipGetWorldTransform(nativeGraphics_, matrix.nativeMatrix_);
    if (status != Status.ОК)
      throw statusException(status);
    return matrix;
  }

}

/**
 */
struct CharacterRange {

  цел first;  ///
  цел length; ///

  /**
   */
  static CharacterRange opCall(цел first, цел length) {
    CharacterRange cr;
    cr.first = first;
    cr.length = length;
    return cr;
  }

  бул opEquals(CharacterRange другой) {
    return first == другой.first && length == другой.length;
  }

}

/**
 */
final class StringFormat : ИВымещаемый {

  private Укз nativeFormat_;

  private this(Укз nativeFormat) {
    nativeFormat_ = nativeFormat;
  }

  /**
   */
  this(StringFormatFlags опции = cast(StringFormatFlags)0, бцел язык = 0) {
    Status status = GdipCreateStringFormat(опции, язык, nativeFormat_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  ~this() {
    dispose();
  }

  /**
   */
  проц dispose() {
    if (nativeFormat_ != Укз.init) {
      GdipDeleteStringFormatSafe(nativeFormat_);
      nativeFormat_ = Укз.init;
    }
  }

  /**
   */
  Объект clone() {
    Укз newFormat;

    Status status = GdipCloneStringFormat(nativeFormat_, newFormat);
    if (status != Status.ОК)
      throw statusException(status);

    return new StringFormat(newFormat);
  }

  /**
   */
  проц setMeasurableCharacterRanges(CharacterRange[] ranges) {
    Status status = GdipSetStringFormatMeasurableCharacterRanges(nativeFormat_, ranges.length, ranges.ptr);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  плав[] getTabStops(out плав firstTabOffset) {
    цел счёт;
    Status status = GdipGetStringFormatTabStopCount(nativeFormat_, счёт);
    if (status != Status.ОК)
      throw statusException(status);

    плав[] tabStops = new плав[счёт];
    status = GdipGetStringFormatTabStops(nativeFormat_, счёт, firstTabOffset, tabStops.ptr);
    if (status != Status.ОК)
      throw statusException(status);

    return tabStops;
  }

  /**
   */
  проц setTabStops(плав firstTabOffset, плав[] tabStops) {
    Status status = GdipSetStringFormatTabStops(nativeFormat_, firstTabOffset, tabStops.length, tabStops.ptr);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  static StringFormat genericDefault() {
    Укз format;
    Status status = GdipStringFormatGetGenericDefault(format);
    if (status != Status.ОК)
      throw statusException(status);
    return new StringFormat(format);
  }

  /**
   */
  static StringFormat genericTypographic() {
    Укз format;
    Status status = GdipStringFormatGetGenericTypographic(format);
    if (status != Status.ОК)
      throw statusException(status);
    return new StringFormat(format);
  }

  /**
   */
  проц formatFlags(StringFormatFlags значение) {
    Status status = GdipSetStringFormatFlags(nativeFormat_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }
  /// ditto
  StringFormatFlags formatFlags() {
    StringFormatFlags флаги;
    Status status = GdipGetStringFormatFlags(nativeFormat_, флаги);
    if (status != Status.ОК)
      throw statusException(status);
    return флаги;
  }

  /**
   */
  проц alignment(StringAlignment значение) {
    Status status = GdipSetStringFormatAlign(nativeFormat_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }
  /// ditto
  StringAlignment alignment() {
    StringAlignment alignment;
    Status status = GdipGetStringFormatAlign(nativeFormat_, alignment);
    if (status != Status.ОК)
      throw statusException(status);
    return alignment;
  }

  /**
   */
  проц lineAlignment(StringAlignment значение) {
    Status status = GdipSetStringFormatLineAlign(nativeFormat_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }
  /// ditto
  StringAlignment lineAlignment() {
    StringAlignment alignment;
    Status status = GdipGetStringFormatLineAlign(nativeFormat_, alignment);
    if (status != Status.ОК)
      throw statusException(status);
    return alignment;
  }

  /**
   */
  проц trimming(StringTrimming значение) {
    Status status = GdipSetStringFormatTrimming(nativeFormat_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }
  /// ditto
  StringTrimming trimming() {
    StringTrimming trimming;
    Status status = GdipGetStringFormatTrimming(nativeFormat_, trimming);
    if (status != Status.ОК)
      throw statusException(status);
    return trimming;
  }

  /**
   */
  проц hotkeyPrefix(HotkeyPrefix значение) {
    Status status = GdipSetStringFormatHotkeyPrefix(nativeFormat_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }
  /// ditto
  HotkeyPrefix hotkeyPrefix() {
    HotkeyPrefix hotkeyPrefix;
    Status status = GdipGetStringFormatHotkeyPrefix(nativeFormat_, hotkeyPrefix);
    if (status != Status.ОК)
      throw statusException(status);
    return hotkeyPrefix;
  }

}

/**
 * Defines objects used to fill the interior of graphical shapes such as rectangles, ellipses, pies, polygons and paths.
 */
abstract class Brush : ИВымещаемый {

  private Укз nativeBrush_;

  /**
   * Initializes a new экземпляр.
   */
  protected this() {
  }

  ~this() {
    dispose(false);
  }

  /**
   * Releases all resources used by the Brush.
   */
  final проц dispose() {
    dispose(true);
  }

  /**
   */
  protected проц dispose(бул disposing) {
    if (nativeBrush_ != Укз.init) {
      GdipDeleteBrushSafe(nativeBrush_);
      nativeBrush_ = Укз.init;
    }
  }

  version(D_Version2) {
    private static Brush[KnownColor] brushes_; // TLS by default
  }
  else {
    private static НитеЛок!(Brush[KnownColor]) brushes_;
  }

  static ~this() {
    brushes_ = null;
  }

  private static Brush fromKnownColor(KnownColor c) {
    version(D_Version2) {
      Brush brush;
      if (auto значение = c in brushes_) {
        brush = *значение;
      }
      else {
        brush = brushes_[c] = new SolidBrush(Цвет.fromKnownColor(c));
      }
      return brush;
    }
    else {
      if (brushes_ is null)
        brushes_ = new НитеЛок!(Brush[KnownColor]);

      auto brushes = brushes_.дай();

      Brush brush;
      if (auto значение = c in brushes) {
        brush = *значение;
      }
      else {
        brush = brushes[c] = new SolidBrush(Цвет.fromKnownColor(c));
        brushes_.уст(brushes);
      }
      return brush;
    }
  }

  /// Gets a system-defined Brush object.
  static Brush activeBorder() {
    return fromKnownColor(KnownColor.ActiveBorder);
  }

  /// ditto 
  static Brush activeCaption() {
    return fromKnownColor(KnownColor.ActiveCaption);
  }

  /// ditto 
  static Brush activeCaptionText() {
    return fromKnownColor(KnownColor.ActiveCaptionText);
  }

  /// ditto 
  static Brush appWorkspace() {
    return fromKnownColor(KnownColor.AppWorkspace);
  }

  /// ditto 
  static Brush control() {
    return fromKnownColor(KnownColor.УпрЭлт);
  }

  /// ditto 
  static Brush controlDark() {
    return fromKnownColor(KnownColor.ControlDark);
  }

  /// ditto 
  static Brush controlDarkDark() {
    return fromKnownColor(KnownColor.ControlDarkDark);
  }

  /// ditto 
  static Brush controlLight() {
    return fromKnownColor(KnownColor.ControlLight);
  }

  /// ditto 
  static Brush controlLightLight() {
    return fromKnownColor(KnownColor.ControlLightLight);
  }

  /// ditto 
  static Brush controlText() {
    return fromKnownColor(KnownColor.ControlText);
  }

  /// ditto 
  static Brush desktop() {
    return fromKnownColor(KnownColor.РабСтол);
  }

  /// ditto 
  static Brush grayText() {
    return fromKnownColor(KnownColor.GrayText);
  }

  /// ditto 
  static Brush highlight() {
    return fromKnownColor(KnownColor.Highlight);
  }

  /// ditto 
  static Brush highlightText() {
    return fromKnownColor(KnownColor.HighlightText);
  }

  /// ditto 
  static Brush hotTrack() {
    return fromKnownColor(KnownColor.HotTrack);
  }

  /// ditto 
  static Brush inactiveBorder() {
    return fromKnownColor(KnownColor.InactiveBorder);
  }

  /// ditto 
  static Brush inactiveCaption() {
    return fromKnownColor(KnownColor.InactiveCaption);
  }

  /// ditto 
  static Brush inactiveCaptionText() {
    return fromKnownColor(KnownColor.InactiveCaptionText);
  }

  /// ditto 
  static Brush info() {
    return fromKnownColor(KnownColor.Info);
  }

  /// ditto 
  static Brush infoText() {
    return fromKnownColor(KnownColor.InfoText);
  }

  /// ditto 
  static Brush menu() {
    return fromKnownColor(KnownColor.Menu);
  }

  /// ditto 
  static Brush menuText() {
    return fromKnownColor(KnownColor.MenuText);
  }

  /// ditto 
  static Brush scrollBar() {
    return fromKnownColor(KnownColor.ScrollBar);
  }

  /// ditto 
  static Brush window() {
    return fromKnownColor(KnownColor.Window);
  }

  /// ditto 
  static Brush windowFrame() {
    return fromKnownColor(KnownColor.WindowFrame);
  }

  /// ditto 
  static Brush windowText() {
    return fromKnownColor(KnownColor.WindowText);
  }

  /// ditto 
  static Brush transparent() {
    return fromKnownColor(KnownColor.Transparent);
  }

  /// ditto 
  static Brush aliceBlue() {
    return fromKnownColor(KnownColor.AliceBlue);
  }

  /// ditto 
  static Brush antiqueWhite() {
    return fromKnownColor(KnownColor.AntiqueWhite);
  }

  /// ditto 
  static Brush aqua() {
    return fromKnownColor(KnownColor.Aqua);
  }

  /// ditto 
  static Brush aquamarine() {
    return fromKnownColor(KnownColor.Aquamarine);
  }

  /// ditto 
  static Brush azure() {
    return fromKnownColor(KnownColor.Azure);
  }

  /// ditto 
  static Brush beige() {
    return fromKnownColor(KnownColor.Beige);
  }

  /// ditto 
  static Brush bisque() {
    return fromKnownColor(KnownColor.Bisque);
  }

  /// ditto 
  static Brush black() {
    return fromKnownColor(KnownColor.Black);
  }

  /// ditto 
  static Brush blanchedAlmond() {
    return fromKnownColor(KnownColor.BlanchedAlmond);
  }

  /// ditto 
  static Brush blue() {
    return fromKnownColor(KnownColor.Blue);
  }

  /// ditto 
  static Brush blueViolet() {
    return fromKnownColor(KnownColor.BlueViolet);
  }

  /// ditto 
  static Brush brown() {
    return fromKnownColor(KnownColor.Brown);
  }

  /// ditto 
  static Brush burlyWood() {
    return fromKnownColor(KnownColor.BurlyWood);
  }

  /// ditto 
  static Brush cadetBlue() {
    return fromKnownColor(KnownColor.CadetBlue);
  }

  /// ditto 
  static Brush chartreuse() {
    return fromKnownColor(KnownColor.Chartreuse);
  }

  /// ditto 
  static Brush chocolate() {
    return fromKnownColor(KnownColor.Chocolate);
  }

  /// ditto 
  static Brush coral() {
    return fromKnownColor(KnownColor.Coral);
  }

  /// ditto 
  static Brush cornflowerBlue() {
    return fromKnownColor(KnownColor.CornflowerBlue);
  }

  /// ditto 
  static Brush cornsilk() {
    return fromKnownColor(KnownColor.Cornsilk);
  }

  /// ditto 
  static Brush crimson() {
    return fromKnownColor(KnownColor.Crimson);
  }

  /// ditto 
  static Brush cyan() {
    return fromKnownColor(KnownColor.Cyan);
  }

  /// ditto 
  static Brush darkBlue() {
    return fromKnownColor(KnownColor.DarkBlue);
  }

  /// ditto 
  static Brush darkCyan() {
    return fromKnownColor(KnownColor.DarkCyan);
  }

  /// ditto 
  static Brush darkGoldenrod() {
    return fromKnownColor(KnownColor.DarkGoldenrod);
  }

  /// ditto 
  static Brush darkGray() {
    return fromKnownColor(KnownColor.DarkGray);
  }

  /// ditto 
  static Brush darkGreen() {
    return fromKnownColor(KnownColor.DarkGreen);
  }

  /// ditto 
  static Brush darkKhaki() {
    return fromKnownColor(KnownColor.DarkKhaki);
  }

  /// ditto 
  static Brush darkMagenta() {
    return fromKnownColor(KnownColor.DarkMagenta);
  }

  /// ditto 
  static Brush darkOliveGreen() {
    return fromKnownColor(KnownColor.DarkOliveGreen);
  }

  /// ditto 
  static Brush darkOrange() {
    return fromKnownColor(KnownColor.DarkOrange);
  }

  /// ditto 
  static Brush darkOrchid() {
    return fromKnownColor(KnownColor.DarkOrchid);
  }

  /// ditto 
  static Brush darkRed() {
    return fromKnownColor(KnownColor.DarkRed);
  }

  /// ditto 
  static Brush darkSalmon() {
    return fromKnownColor(KnownColor.DarkSalmon);
  }

  /// ditto 
  static Brush darkSeaGreen() {
    return fromKnownColor(KnownColor.DarkSeaGreen);
  }

  /// ditto 
  static Brush darkSlateBlue() {
    return fromKnownColor(KnownColor.DarkSlateBlue);
  }

  /// ditto 
  static Brush darkSlateGray() {
    return fromKnownColor(KnownColor.DarkSlateGray);
  }

  /// ditto 
  static Brush darkTurquoise() {
    return fromKnownColor(KnownColor.DarkTurquoise);
  }

  /// ditto 
  static Brush darkViolet() {
    return fromKnownColor(KnownColor.DarkViolet);
  }

  /// ditto 
  static Brush deepPink() {
    return fromKnownColor(KnownColor.DeepPink);
  }

  /// ditto 
  static Brush deepSkyBlue() {
    return fromKnownColor(KnownColor.DeepSkyBlue);
  }

  /// ditto 
  static Brush dimGray() {
    return fromKnownColor(KnownColor.DimGray);
  }

  /// ditto 
  static Brush dodgerBlue() {
    return fromKnownColor(KnownColor.DodgerBlue);
  }

  /// ditto 
  static Brush firebrick() {
    return fromKnownColor(KnownColor.Firebrick);
  }

  /// ditto 
  static Brush floralWhite() {
    return fromKnownColor(KnownColor.FloralWhite);
  }

  /// ditto 
  static Brush forestGreen() {
    return fromKnownColor(KnownColor.ForestGreen);
  }

  /// ditto 
  static Brush fuchsia() {
    return fromKnownColor(KnownColor.Fuchsia);
  }

  /// ditto 
  static Brush gainsboro() {
    return fromKnownColor(KnownColor.Gainsboro);
  }

  /// ditto 
  static Brush ghostWhite() {
    return fromKnownColor(KnownColor.GhostWhite);
  }

  /// ditto 
  static Brush gold() {
    return fromKnownColor(KnownColor.Gold);
  }

  /// ditto 
  static Brush goldenrod() {
    return fromKnownColor(KnownColor.Goldenrod);
  }

  /// ditto 
  static Brush gray() {
    return fromKnownColor(KnownColor.Gray);
  }

  /// ditto 
  static Brush green() {
    return fromKnownColor(KnownColor.Green);
  }

  /// ditto 
  static Brush greenYellow() {
    return fromKnownColor(KnownColor.GreenYellow);
  }

  /// ditto 
  static Brush honeydew() {
    return fromKnownColor(KnownColor.Honeydew);
  }

  /// ditto 
  static Brush hotPink() {
    return fromKnownColor(KnownColor.HotPink);
  }

  /// ditto 
  static Brush indianRed() {
    return fromKnownColor(KnownColor.IndianRed);
  }

  /// ditto 
  static Brush indigo() {
    return fromKnownColor(KnownColor.Indigo);
  }

  /// ditto 
  static Brush ivory() {
    return fromKnownColor(KnownColor.Ivory);
  }

  /// ditto 
  static Brush khaki() {
    return fromKnownColor(KnownColor.Khaki);
  }

  /// ditto 
  static Brush lavender() {
    return fromKnownColor(KnownColor.Lavender);
  }

  /// ditto 
  static Brush lavenderBlush() {
    return fromKnownColor(KnownColor.LavenderBlush);
  }

  /// ditto 
  static Brush lawnGreen() {
    return fromKnownColor(KnownColor.LawnGreen);
  }

  /// ditto 
  static Brush lemonChiffon() {
    return fromKnownColor(KnownColor.LemonChiffon);
  }

  /// ditto 
  static Brush lightBlue() {
    return fromKnownColor(KnownColor.LightBlue);
  }

  /// ditto 
  static Brush lightCoral() {
    return fromKnownColor(KnownColor.LightCoral);
  }

  /// ditto 
  static Brush lightCyan() {
    return fromKnownColor(KnownColor.LightCyan);
  }

  /// ditto 
  static Brush lightGoldenrodYellow() {
    return fromKnownColor(KnownColor.LightGoldenrodYellow);
  }

  /// ditto 
  static Brush lightGray() {
    return fromKnownColor(KnownColor.LightGray);
  }

  /// ditto 
  static Brush lightGreen() {
    return fromKnownColor(KnownColor.LightGreen);
  }

  /// ditto 
  static Brush lightPink() {
    return fromKnownColor(KnownColor.LightPink);
  }

  /// ditto 
  static Brush lightSalmon() {
    return fromKnownColor(KnownColor.LightSalmon);
  }

  /// ditto 
  static Brush lightSeaGreen() {
    return fromKnownColor(KnownColor.LightSeaGreen);
  }

  /// ditto 
  static Brush lightSkyBlue() {
    return fromKnownColor(KnownColor.LightSkyBlue);
  }

  /// ditto 
  static Brush lightSlateGray() {
    return fromKnownColor(KnownColor.LightSlateGray);
  }

  /// ditto 
  static Brush lightSteelBlue() {
    return fromKnownColor(KnownColor.LightSteelBlue);
  }

  /// ditto 
  static Brush lightYellow() {
    return fromKnownColor(KnownColor.LightYellow);
  }

  /// ditto 
  static Brush lime() {
    return fromKnownColor(KnownColor.Lime);
  }

  /// ditto 
  static Brush limeGreen() {
    return fromKnownColor(KnownColor.LimeGreen);
  }

  /// ditto 
  static Brush linen() {
    return fromKnownColor(KnownColor.Linen);
  }

  /// ditto 
  static Brush magenta() {
    return fromKnownColor(KnownColor.Magenta);
  }

  /// ditto 
  static Brush maroon() {
    return fromKnownColor(KnownColor.Maroon);
  }

  /// ditto 
  static Brush mediumAquamarine() {
    return fromKnownColor(KnownColor.MediumAquamarine);
  }

  /// ditto 
  static Brush mediumBlue() {
    return fromKnownColor(KnownColor.MediumBlue);
  }

  /// ditto 
  static Brush mediumOrchid() {
    return fromKnownColor(KnownColor.MediumOrchid);
  }

  /// ditto 
  static Brush mediumPurple() {
    return fromKnownColor(KnownColor.MediumPurple);
  }

  /// ditto 
  static Brush mediumSeaGreen() {
    return fromKnownColor(KnownColor.MediumSeaGreen);
  }

  /// ditto 
  static Brush mediumSlateBlue() {
    return fromKnownColor(KnownColor.MediumSlateBlue);
  }

  /// ditto 
  static Brush mediumSpringGreen() {
    return fromKnownColor(KnownColor.MediumSpringGreen);
  }

  /// ditto 
  static Brush mediumTurquoise() {
    return fromKnownColor(KnownColor.MediumTurquoise);
  }

  /// ditto 
  static Brush mediumVioletRed() {
    return fromKnownColor(KnownColor.MediumVioletRed);
  }

  /// ditto 
  static Brush midnightBlue() {
    return fromKnownColor(KnownColor.MidnightBlue);
  }

  /// ditto 
  static Brush mintCream() {
    return fromKnownColor(KnownColor.MintCream);
  }

  /// ditto 
  static Brush mistyRose() {
    return fromKnownColor(KnownColor.MistyRose);
  }

  /// ditto 
  static Brush moccasin() {
    return fromKnownColor(KnownColor.Moccasin);
  }

  /// ditto 
  static Brush navajoWhite() {
    return fromKnownColor(KnownColor.NavajoWhite);
  }

  /// ditto 
  static Brush navy() {
    return fromKnownColor(KnownColor.Navy);
  }

  /// ditto 
  static Brush oldLace() {
    return fromKnownColor(KnownColor.OldLace);
  }

  /// ditto 
  static Brush olive() {
    return fromKnownColor(KnownColor.Olive);
  }

  /// ditto 
  static Brush oliveDrab() {
    return fromKnownColor(KnownColor.OliveDrab);
  }

  /// ditto 
  static Brush orange() {
    return fromKnownColor(KnownColor.Orange);
  }

  /// ditto 
  static Brush orangeRed() {
    return fromKnownColor(KnownColor.OrangeRed);
  }

  /// ditto 
  static Brush orchid() {
    return fromKnownColor(KnownColor.Orchid);
  }

  /// ditto 
  static Brush paleGoldenrod() {
    return fromKnownColor(KnownColor.PaleGoldenrod);
  }

  /// ditto 
  static Brush paleGreen() {
    return fromKnownColor(KnownColor.PaleGreen);
  }

  /// ditto 
  static Brush paleTurquoise() {
    return fromKnownColor(KnownColor.PaleTurquoise);
  }

  /// ditto 
  static Brush paleVioletRed() {
    return fromKnownColor(KnownColor.PaleVioletRed);
  }

  /// ditto 
  static Brush papayaWhip() {
    return fromKnownColor(KnownColor.PapayaWhip);
  }

  /// ditto 
  static Brush peachPuff() {
    return fromKnownColor(KnownColor.PeachPuff);
  }

  /// ditto 
  static Brush peru() {
    return fromKnownColor(KnownColor.Peru);
  }

  /// ditto 
  static Brush pink() {
    return fromKnownColor(KnownColor.Pink);
  }

  /// ditto 
  static Brush plum() {
    return fromKnownColor(KnownColor.Plum);
  }

  /// ditto 
  static Brush powderBlue() {
    return fromKnownColor(KnownColor.PowderBlue);
  }

  /// ditto 
  static Brush purple() {
    return fromKnownColor(KnownColor.Purple);
  }

  /// ditto 
  static Brush red() {
    return fromKnownColor(KnownColor.Red);
  }

  /// ditto 
  static Brush rosyBrown() {
    return fromKnownColor(KnownColor.RosyBrown);
  }

  /// ditto 
  static Brush royalBlue() {
    return fromKnownColor(KnownColor.RoyalBlue);
  }

  /// ditto 
  static Brush saddleBrown() {
    return fromKnownColor(KnownColor.SaddleBrown);
  }

  /// ditto 
  static Brush salmon() {
    return fromKnownColor(KnownColor.Salmon);
  }

  /// ditto 
  static Brush sandyBrown() {
    return fromKnownColor(KnownColor.SandyBrown);
  }

  /// ditto 
  static Brush seaGreen() {
    return fromKnownColor(KnownColor.SeaGreen);
  }

  /// ditto 
  static Brush seaShell() {
    return fromKnownColor(KnownColor.SeaShell);
  }

  /// ditto 
  static Brush sienna() {
    return fromKnownColor(KnownColor.Sienna);
  }

  /// ditto 
  static Brush silver() {
    return fromKnownColor(KnownColor.Silver);
  }

  /// ditto 
  static Brush skyBlue() {
    return fromKnownColor(KnownColor.SkyBlue);
  }

  /// ditto 
  static Brush slateBlue() {
    return fromKnownColor(KnownColor.SlateBlue);
  }

  /// ditto 
  static Brush slateGray() {
    return fromKnownColor(KnownColor.SlateGray);
  }

  /// ditto 
  static Brush snow() {
    return fromKnownColor(KnownColor.Snow);
  }

  /// ditto 
  static Brush springGreen() {
    return fromKnownColor(KnownColor.SpringGreen);
  }

  /// ditto 
  static Brush steelBlue() {
    return fromKnownColor(KnownColor.SteelBlue);
  }

  /// ditto 
  static Brush tan() {
    return fromKnownColor(KnownColor.Tan);
  }

  /// ditto 
  static Brush teal() {
    return fromKnownColor(KnownColor.Teal);
  }

  /// ditto 
  static Brush thistle() {
    return fromKnownColor(KnownColor.Thistle);
  }

  /// ditto 
  static Brush tomato() {
    return fromKnownColor(KnownColor.Tomato);
  }

  /// ditto 
  static Brush turquoise() {
    return fromKnownColor(KnownColor.Turquoise);
  }

  /// ditto 
  static Brush violet() {
    return fromKnownColor(KnownColor.Violet);
  }

  /// ditto 
  static Brush wheat() {
    return fromKnownColor(KnownColor.Wheat);
  }

  /// ditto 
  static Brush white() {
    return fromKnownColor(KnownColor.White);
  }

  /// ditto 
  static Brush whiteSmoke() {
    return fromKnownColor(KnownColor.WhiteSmoke);
  }

  /// ditto 
  static Brush yellow() {
    return fromKnownColor(KnownColor.Yellow);
  }

  /// ditto 
  static Brush yellowGreen() {
    return fromKnownColor(KnownColor.YellowGreen);
  }

  /// ditto 
  static Brush buttonFace() {
    return fromKnownColor(KnownColor.ButtonFace);
  }

  /// ditto 
  static Brush buttonHighlight() {
    return fromKnownColor(KnownColor.ButtonHighlight);
  }

  /// ditto 
  static Brush buttonShadow() {
    return fromKnownColor(KnownColor.ButtonShadow);
  }

  /// ditto 
  static Brush gradientActiveCaption() {
    return fromKnownColor(KnownColor.GradientActiveCaption);
  }

  /// ditto 
  static Brush gradientInactiveCaption() {
    return fromKnownColor(KnownColor.GradientInactiveCaption);
  }

  /// ditto 
  static Brush menuBar() {
    return fromKnownColor(KnownColor.MenuBar);
  }

  /// ditto 
  static Brush menuHighlight() {
    return fromKnownColor(KnownColor.MenuHighlight);
  }

}

/**
 * Defines a brush of a single цвет.
 */
final class SolidBrush : Brush {

  private Цвет color_;

  private this(Укз nativeBrush) {
    nativeBrush_ = nativeBrush;
  }

  /**
   * Initializes a new SolidBrush object of the specified _color.
   * Params: цвет = The _color of this brush.
   */
  this(Цвет цвет) {
    color_ = цвет;

    Status status = GdipCreateSolidFill(цвет.toArgb(), nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * Creates an exact копируй of this brush.
   * Returns: The SolidBrush object that this метод creates.
   */
  Объект clone() {
    Укз cloneBrush;
    Status status = GdipCloneBrush(nativeBrush_, cloneBrush);
    if (status != Status.ОК)
      throw statusException(status);
    return new SolidBrush(cloneBrush);
  }

  /**
   * Gets or sets the _color of this SolidBrush object.
   * Params: значение = The _color of this brush.
   */
  проц цвет(Цвет значение) {
    if (color_ != значение) {
      Status status = GdipSetSolidFillColor(nativeBrush_, значение.toArgb());
      if (status != Status.ОК)
        throw statusException(status);

      color_ = значение;
    }
  }

  /**
   * ditto
   */
  Цвет цвет() {
    if (color_.пуст_ли) {
      бцел значение;

      Status status = GdipGetSolidFillColor(nativeBrush_, значение);
      if (status != Status.ОК)
        throw statusException(status);

      color_ = Цвет.fromArgb(значение);
    }
    return color_;
  }

}

/**
 */
final class TextureBrush : Brush {

  /**
   */
  this(Image image, WrapMode wrapMode = WrapMode.Tile) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image");

    Status status = GdipCreateTexture(image.nativeImage_, wrapMode, nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Image image, WrapMode wrapMode, Прям прям) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image"); 

    Status status = GdipCreateTexture2I(image.nativeImage_, wrapMode, прям.x, прям.y, прям.ширина, прям.высота, nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Image image, WrapMode wrapMode, ПрямП прям) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image"); 

    Status status = GdipCreateTexture2(image.nativeImage_, wrapMode, прям.x, прям.y, прям.ширина, прям.высота, nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Image image, Прям прям, ImageAttributes imageAttr) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image"); 

    Status status = GdipCreateTextureIAI(image.nativeImage_, (imageAttr is null) ? Укз.init : imageAttr.nativeImageAttributes, прям.x, прям.y, прям.ширина, прям.высота, nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Image image, ПрямП прям, ImageAttributes imageAttr) {
    if (image is null)
      throw new ИсклНулевогоАргумента("image"); 

    Status status = GdipCreateTextureIA(image.nativeImage_, (imageAttr is null) ? Укз.init : imageAttr.nativeImageAttributes, прям.x, прям.y, прям.ширина, прям.высота, nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * Creates an exact копируй of this brush.
   * Returns: The TextureBrush object that this метод creates.
   */
  Объект clone() {
    Укз cloneBrush;
    Status status = GdipCloneBrush(nativeBrush_, cloneBrush);
    if (status != Status.ОК)
      throw statusException(status);
    return new SolidBrush(cloneBrush);
  }

  /**
   */
  проц translateTransform(плав dx, плав dy, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipTranslateTextureTransform(nativeBrush_, dx, dy, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц rotateTransform(плав angle, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipRotateTextureTransform(nativeBrush_, angle, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц scaleTransform(плав sx, плав sy, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipScaleTextureTransform(nativeBrush_, sx, sy, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц multiplyTransform(Matrix matrix, MatrixOrder order = MatrixOrder.Prepend) {
    if (matrix is null)
      throw new ИсклНулевогоАргумента("matrix");

    Status status = GdipMultiplyTextureTransform(nativeBrush_, matrix.nativeMatrix_, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц resetTransform() {
    Status status = GdipResetTextureTransform(nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  Image image() {
    Укз nativeImage;
    Status status = GdipGetTextureImage(nativeBrush_, nativeImage);
    if (status != Status.ОК)
      throw statusException(status);
    return Image.createImage(nativeImage);
  }

  /**
   */
  проц transform(Matrix значение) {
    if (значение is null)
      throw new ИсклНулевогоАргумента("значение");

    Status status = GdipSetTextureTransform(nativeBrush_, значение.nativeMatrix_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  Matrix transform() {
    Matrix m = new Matrix;
    Status status = GdipGetTextureTransform(nativeBrush_, m.nativeMatrix_);
    if (status != Status.ОК)
      throw statusException(status);
    return m;
  }

  /**
   */
  проц wrapMode(WrapMode значение) {
    Status status = GdipSetTextureWrapMode(nativeBrush_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  WrapMode wrapMode() {
    WrapMode рез;

    Status status = GdipGetTextureWrapMode(nativeBrush_, рез);
    if (status != Status.ОК)
      throw statusException(status);

    return рез;
  }

  /*package*/ this(Укз nativeBrush) {
    nativeBrush_ = nativeBrush;
  }

}

/**
 */
final class HatchBrush : Brush {

  /**
   */
  this(HatchStyle hatchStyle, Цвет foreColor) {
    this(hatchStyle, foreColor, Цвет.black);
  }

  /**
   */
  this(HatchStyle hatchStyle, Цвет foreColor, Цвет backColor) {
    Status status = GdipCreateHatchBrush(hatchStyle, foreColor.toArgb(), backColor.toArgb(), nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  HatchStyle hatchStyle() {
    HatchStyle значение;

    Status status = GdipGetHatchStyle(nativeBrush_, значение);
    if (status != Status.ОК)
      throw statusException(status);

    return значение;
  }

  /**
   */
  Цвет цветПП() {
    бцел argb;

    Status status = GdipGetHatchForegroundColor(nativeBrush_, argb);
    if (status != Status.ОК)
      throw statusException(status);

    return Цвет.fromArgb(argb);
  }

  /**
   */
  Цвет цветФона() {
    бцел argb;

    Status status = GdipGetHatchBackgroundColor(nativeBrush_, argb);
    if (status != Status.ОК)
      throw statusException(status);

    return Цвет.fromArgb(argb);
  }

}

/**
 */
final class Blend {

  ///
  плав[] factors;

  ///
  плав[] positions;

  /**
   */
  this(цел счёт = 1) {
    factors.length = счёт;
    positions.length = счёт;
  }

}

/**
 */
final class ColorBlend {

  ///
  Цвет[] цвета;

  ///
  плав[] positions;

  /**
   */
  this(цел счёт = 1) {
    цвета.length = счёт;
    positions.length = счёт;
  }

}

/**
 */
final class LinearGradientBrush : Brush {

  /**
   */
  this(Точка startPoint, Точка endPoint, Цвет startColor, Цвет endColor) {
    Status status = GdipCreateLineBrushI(startPoint, endPoint, startColor.toArgb(), endColor.toArgb(), WrapMode.Tile, nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(ТочкаП startPoint, ТочкаП endPoint, Цвет startColor, Цвет endColor) {
    Status status = GdipCreateLineBrush(startPoint, endPoint, startColor.toArgb(), endColor.toArgb(), WrapMode.Tile, nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Прям прям, Цвет startColor, Цвет endColor, LinearGradientMode mode) {
    Status status = GdipCreateLineBrushFromRectI(прям, startColor.toArgb(), endColor.toArgb(), mode, WrapMode.Tile, nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(ПрямП прям, Цвет startColor, Цвет endColor, LinearGradientMode mode) {
    Status status = GdipCreateLineBrushFromRect(прям, startColor.toArgb(), endColor.toArgb(), mode, WrapMode.Tile, nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Прям прям, Цвет startColor, Цвет endColor, плав angle, бул isAngleScalable = false) {
    Status status = GdipCreateLineBrushFromRectWithAngleI(прям, startColor.toArgb(), endColor.toArgb(), angle, (isAngleScalable ? 1 : 0), WrapMode.Tile, nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(ПрямП прям, Цвет startColor, Цвет endColor, плав angle, бул isAngleScalable = false) {
    Status status = GdipCreateLineBrushFromRectWithAngle(прям, startColor.toArgb(), endColor.toArgb(), angle, (isAngleScalable ? 1 : 0), WrapMode.Tile, nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц setSigmaBellShape(плав focus, плав шкала = 1.0f) {
    Status status = GdipSetLineSigmaBlend(nativeBrush_, focus, шкала);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц setBlendTriangularShape(плав focus, плав шкала = 1.0f) {
    Status status = GdipSetLineLinearBlend(nativeBrush_, focus, шкала);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц resetTransform() {
    Status status = GdipResetLineTransform(nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц translateTransform(плав dx, плав dy, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipTranslateLineTransform(nativeBrush_, dx, dy, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц scaleTransform(плав sx, плав sy, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipScaleLineTransform(nativeBrush_, sx, sy, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц rotateTransform(плав angle, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipRotateLineTransform(nativeBrush_, angle, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц linearColors(Цвет[] значение) {
    Status status = GdipSetLineColors(nativeBrush_, значение[0].toArgb(), значение[1].toArgb());
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  Цвет[] linearColors() {
    бцел[] цвета = new бцел[2];

    Status status = GdipGetLineColors(nativeBrush_, цвета.ptr);
    if (status != Status.ОК)
      throw statusException(status);

    return [ Цвет.fromArgb(цвета[0]), Цвет.fromArgb(цвета[1]) ];
  }

  /**
   */
  проц gammaCorrection(бул значение) {
    Status status = GdipSetLineGammaCorrection(nativeBrush_, (значение ? 1 : 0));
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  бул gammaCorrection() {
    цел значение;

    Status status = GdipGetLineGammaCorrection(nativeBrush_, значение);
    if (status != Status.ОК)
      throw statusException(status);

    return (значение != 0);
  }

  /**
   */
  проц blend(Blend значение) {
    Status status = GdipSetLineBlend(nativeBrush_, значение.factors.ptr, значение.positions.ptr, значение.factors.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  Blend blend() {
    цел счёт;
    Status status = GdipGetLineBlendCount(nativeBrush_, счёт);
    if (status != Status.ОК)
      throw statusException(status);

    if (счёт <= 0)
      return null;

    плав[] factors = new плав[счёт];
    плав[] positions = new плав[счёт];

    status = GdipGetLineBlend(nativeBrush_, factors.ptr, positions.ptr, счёт);
    if (status != Status.ОК)
      throw statusException(status);

    Blend blend = new Blend(счёт);
    blend.factors = factors.dup;
    blend.positions = positions.dup;

    return blend;
  }

  /**
   */
  проц interpolationColors(ColorBlend значение) {
    if (значение is null)
      throw new ИсклНулевогоАргумента("значение");
    if (значение.цвета.length < 2)
      throw new win32.base.core.ИсклАргумента("Array of цвета must contain at least two elements.");
    if (значение.цвета.length != значение.positions.length)
      throw new win32.base.core.ИсклАргумента("Colors and positions do not have the same число of elements.");
    if (значение.positions[0] != 0)
      throw new win32.base.core.ИсклАргумента("Position's first element must be equal to 0.");
    if (значение.positions[$ - 1] != 1f)
      throw new win32.base.core.ИсклАргумента("Position's last element must be equal to 1.0.");

    бцел[] цвета = new бцел[значение.цвета.length];
    foreach (i, ref argb; цвета)
      argb = значение.цвета[i].toArgb();

    Status status = GdipSetLinePresetBlend(nativeBrush_, цвета.ptr, значение.positions.ptr, значение.цвета.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  ColorBlend interpolationColors() {
    цел счёт;
    Status status = GdipGetLinePresetBlendCount(nativeBrush_, счёт);
    if (status != Status.ОК)
      throw statusException(status);

    if (счёт <= 0)
      return null;

    бцел[] цвета = new бцел[счёт];
    плав[] positions = new плав[счёт];

    status = GdipGetLinePresetBlend(nativeBrush_, цвета.ptr, positions.ptr, счёт);
    if (status != Status.ОК)
      throw statusException(status);

    ColorBlend blend = new ColorBlend(счёт);

    blend.цвета = new Цвет[счёт];
    foreach (i, ref цвет; blend.цвета)
      цвет = Цвет.fromArgb(цвета[i]);
    blend.positions = positions.dup;

    return blend;
  }

  /**
   */
  ПрямП rectangle() {
    ПрямП значение;
    Status status = GdipGetLineRect(nativeBrush_, значение);
    if (status != Status.ОК)
      throw statusException(status);
    return значение;
  }

  /**
   */
  проц wrapMode(WrapMode значение) {
    Status status = GdipSetLineWrapMode(nativeBrush_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  WrapMode wrapMode() {
    WrapMode значение;
    Status status = GdipGetLineWrapMode(nativeBrush_, значение);
    if (status != Status.ОК)
      throw statusException(status);
    return значение;
  }

}

/**
 */
final class PathGradientBrush : Brush {

  private this(Укз nativeBrush) {
    nativeBrush_ = nativeBrush;
  }

  /**
   */
  this(ТочкаП[] points, WrapMode wrapMode = WrapMode.Clamp) {
    Status status = GdipCreatePathGradient(points.ptr, points.length, wrapMode, nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Точка[] points, WrapMode wrapMode = WrapMode.Clamp) {
    Status status = GdipCreatePathGradientI(points.ptr, points.length, wrapMode, nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Path путь) {
    if (путь is null)
      throw new ИсклНулевогоАргумента("путь");

    Status status = GdipCreatePathGradientFromPath(путь.nativePath_, nativeBrush_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  Объект clone() {
    Укз cloneBrush;
    Status status = GdipCloneBrush(nativeBrush_, cloneBrush);
    if (status != Status.ОК)
      throw statusException(status);
    return new PathGradientBrush(cloneBrush);
  }

}

/**
 */
final class Pen : ИВымещаемый {

  private Укз nativePen_;
  private Цвет color_;

  /**
   */
  this(Цвет цвет, плав ширина = 1f) {
    color_ = цвет;

    Status status = GdipCreatePen1(цвет.toArgb(), ширина, cast(GraphicsUnit)0, nativePen_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  ~this() {
    dispose();
  }

  /**
   */
  final проц dispose() {
    if (nativePen_ != Укз.init) {
      GdipDeletePenSafe(nativePen_);
      nativePen_ = Укз.init;
    }
  }

  /**
   */
  проц setLineCap(LineCap startCap, LineCap endCap, DashCap dashCap) {
    Status status = GdipSetPenLineCap197819(nativePen_, startCap, endCap, dashCap);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц resetTransform() {
    Status status = GdipResetPenTransform(nativePen_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц translateTransform(плав dx, плав dy, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipTranslatePenTransform(nativePen_, dx, dy, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц scaleTransform(плав sx, плав sy, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipScalePenTransform(nativePen_, sx, sy, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц rotateTransform(плав angle, MatrixOrder order = MatrixOrder.Prepend) {
    Status status = GdipRotatePenTransform(nativePen_, angle, order);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц ширина(плав значение) {
    Status status = GdipSetPenWidth(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  плав ширина() {
    плав значение = 0f;

    Status status = GdipGetPenWidth(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);

    return значение;
  }

  /**
   */
  проц startCap(LineCap значение) {
    Status status = GdipSetPenStartCap(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  LineCap startCap() {
    LineCap значение;

    Status status = GdipGetPenStartCap(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);

    return значение;
  }

  /**
   */
  проц endCap(LineCap значение) {
    Status status = GdipSetPenEndCap(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  LineCap endCap() {
    LineCap значение;

    Status status = GdipGetPenEndCap(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);

    return значение;
  }

  /**
   */
  проц dashCap(DashCap значение) {
    Status status = GdipSetPenDashCap197819(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  DashCap dashCap() {
    DashCap значение;

    Status status = GdipGetPenDashCap197819(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);

    return значение;
  }

  /**
   */
  проц lineJoin(LineJoin значение) {
    Status status = GdipSetPenLineJoin(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  LineJoin lineJoin() {
    LineJoin значение;

    Status status = GdipGetPenLineJoin(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);

    return значение;
  }

  /**
   */
  проц miterLimit(плав значение) {
    Status status = GdipSetPenMiterLimit(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  плав miterLimit() {
    плав значение = 0.0f;

    Status status = GdipGetPenMiterLimit(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);

    return значение;
  }

  /**
   */
  проц alignment(PenAlignment значение) {
    Status status = GdipSetPenMode(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  PenAlignment alignment() {
    PenAlignment значение;

    Status status = GdipGetPenMode(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);

    return значение;
  }

  /**
   */
  PenType penType() {
    PenType тип = cast(PenType)-1;

    Status status = GdipGetPenFillType(nativePen_, тип);
    if (status != Status.ОК)
      throw statusException(status);

    return тип;
  }

  /**
   */
  проц dashStyle(DashStyle значение) {
    Status status = GdipSetPenDashStyle(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  DashStyle dashStyle() {
    DashStyle значение;

    Status status = GdipGetPenDashStyle(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);

    return значение;
  }

  /**
   */
  проц dashOffset(плав значение) {
    Status status = GdipSetPenDashOffset(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  плав dashOffset() {
    плав значение = 0.0f;

    Status status = GdipGetPenDashOffset(nativePen_, значение);
    if (status != Status.ОК)
      throw statusException(status);

    return значение;
  }

  /**
   */
  проц dashPattern(плав[] значение) {
    if (значение == null)
      throw statusException(Status.InvalidParameter);

    Status status = GdipSetPenDashArray(nativePen_, значение.ptr, значение.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  плав[] dashPattern() {
    цел счёт;
    Status status = GdipGetPenDashCount(nativePen_, счёт);
    if (status != Status.ОК)
      throw statusException(status);

    плав[] dashArray = new плав[счёт];

    status = GdipGetPenDashArray(nativePen_, dashArray.ptr, счёт);
    if (status != Status.ОК)
      throw statusException(status);

    return dashArray;
  }

  /**
   */
  проц compoundArray(плав[] значение) {
    if (значение == null)
      throw statusException(Status.InvalidParameter);

    Status status = GdipSetPenCompoundArray(nativePen_, значение.ptr, значение.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  плав[] compoundArray() {
    цел счёт;
    Status status = GdipGetPenCompoundCount(nativePen_, счёт);
    if (status != Status.ОК)
      throw statusException(status);

    плав[] array = new плав[счёт];

    status = GdipGetPenCompoundArray(nativePen_, array.ptr, счёт);
    if (status != Status.ОК)
      throw statusException(status);

    return array;
  }

  /**
   */
  проц цвет(Цвет значение) {
    if (color_ != значение) {
      color_ = значение;

      Status status = GdipSetPenColor(nativePen_, color_.toArgb());
      if (status != Status.ОК)
        throw statusException(status);
    }
  }
  /// ditto
  Цвет цвет() {
    if (color_ == Цвет.пустой) {
      бцел argb;

      Status status = GdipGetPenColor(nativePen_, argb);
      if (status != Status.ОК)
        throw statusException(status);

      color_ = Цвет.fromArgb(argb);
    }
    return color_;
  }

  version(D_Version2) {
    private static Pen[KnownColor] pens_;
  }
  else {
    private static НитеЛок!(Pen[KnownColor]) pens_;
  }

  static ~this() {
    pens_ = null;
  }

  private static Pen fromKnownColor(KnownColor c) {
    version(D_Version2) {
      Pen pen;
      if (auto значение = c in pens_) {
        pen = *значение;
      }
      else {
        pen = pens_[c] = new Pen(Цвет.fromKnownColor(c));
      }
      return pen;
    }
    else {
      if (pens_ is null)
        pens_ = new НитеЛок!(Pen[KnownColor]);

      auto pens = pens_.дай();

      Pen pen;
      if (auto значение = c in pens) {
        pen = *значение;
      }
      else {
        pen = pens[c] = new Pen(Цвет.fromKnownColor(c));
        pens_.уст(pens);
      }
      return pen;
    }
  }

  /// Gets a system-defined Pen object.
  static Pen activeBorder() {
    return fromKnownColor(KnownColor.ActiveBorder);
  }

  /// ditto 
  static Pen activeCaption() {
    return fromKnownColor(KnownColor.ActiveCaption);
  }

  /// ditto 
  static Pen activeCaptionText() {
    return fromKnownColor(KnownColor.ActiveCaptionText);
  }

  /// ditto 
  static Pen appWorkspace() {
    return fromKnownColor(KnownColor.AppWorkspace);
  }

  /// ditto 
  static Pen control() {
    return fromKnownColor(KnownColor.УпрЭлт);
  }

  /// ditto 
  static Pen controlDark() {
    return fromKnownColor(KnownColor.ControlDark);
  }

  /// ditto 
  static Pen controlDarkDark() {
    return fromKnownColor(KnownColor.ControlDarkDark);
  }

  /// ditto 
  static Pen controlLight() {
    return fromKnownColor(KnownColor.ControlLight);
  }

  /// ditto 
  static Pen controlLightLight() {
    return fromKnownColor(KnownColor.ControlLightLight);
  }

  /// ditto 
  static Pen controlText() {
    return fromKnownColor(KnownColor.ControlText);
  }

  /// ditto 
  static Pen desktop() {
    return fromKnownColor(KnownColor.РабСтол);
  }

  /// ditto 
  static Pen grayText() {
    return fromKnownColor(KnownColor.GrayText);
  }

  /// ditto 
  static Pen highlight() {
    return fromKnownColor(KnownColor.Highlight);
  }

  /// ditto 
  static Pen highlightText() {
    return fromKnownColor(KnownColor.HighlightText);
  }

  /// ditto 
  static Pen hotTrack() {
    return fromKnownColor(KnownColor.HotTrack);
  }

  /// ditto 
  static Pen inactiveBorder() {
    return fromKnownColor(KnownColor.InactiveBorder);
  }

  /// ditto 
  static Pen inactiveCaption() {
    return fromKnownColor(KnownColor.InactiveCaption);
  }

  /// ditto 
  static Pen inactiveCaptionText() {
    return fromKnownColor(KnownColor.InactiveCaptionText);
  }

  /// ditto 
  static Pen info() {
    return fromKnownColor(KnownColor.Info);
  }

  /// ditto 
  static Pen infoText() {
    return fromKnownColor(KnownColor.InfoText);
  }

  /// ditto 
  static Pen menu() {
    return fromKnownColor(KnownColor.Menu);
  }

  /// ditto 
  static Pen menuText() {
    return fromKnownColor(KnownColor.MenuText);
  }

  /// ditto 
  static Pen scrollBar() {
    return fromKnownColor(KnownColor.ScrollBar);
  }

  /// ditto 
  static Pen window() {
    return fromKnownColor(KnownColor.Window);
  }

  /// ditto 
  static Pen windowFrame() {
    return fromKnownColor(KnownColor.WindowFrame);
  }

  /// ditto 
  static Pen windowText() {
    return fromKnownColor(KnownColor.WindowText);
  }

  /// ditto 
  static Pen transparent() {
    return fromKnownColor(KnownColor.Transparent);
  }

  /// ditto 
  static Pen aliceBlue() {
    return fromKnownColor(KnownColor.AliceBlue);
  }

  /// ditto 
  static Pen antiqueWhite() {
    return fromKnownColor(KnownColor.AntiqueWhite);
  }

  /// ditto 
  static Pen aqua() {
    return fromKnownColor(KnownColor.Aqua);
  }

  /// ditto 
  static Pen aquamarine() {
    return fromKnownColor(KnownColor.Aquamarine);
  }

  /// ditto 
  static Pen azure() {
    return fromKnownColor(KnownColor.Azure);
  }

  /// ditto 
  static Pen beige() {
    return fromKnownColor(KnownColor.Beige);
  }

  /// ditto 
  static Pen bisque() {
    return fromKnownColor(KnownColor.Bisque);
  }

  /// ditto 
  static Pen black() {
    return fromKnownColor(KnownColor.Black);
  }

  /// ditto 
  static Pen blanchedAlmond() {
    return fromKnownColor(KnownColor.BlanchedAlmond);
  }

  /// ditto 
  static Pen blue() {
    return fromKnownColor(KnownColor.Blue);
  }

  /// ditto 
  static Pen blueViolet() {
    return fromKnownColor(KnownColor.BlueViolet);
  }

  /// ditto 
  static Pen brown() {
    return fromKnownColor(KnownColor.Brown);
  }

  /// ditto 
  static Pen burlyWood() {
    return fromKnownColor(KnownColor.BurlyWood);
  }

  /// ditto 
  static Pen cadetBlue() {
    return fromKnownColor(KnownColor.CadetBlue);
  }

  /// ditto 
  static Pen chartreuse() {
    return fromKnownColor(KnownColor.Chartreuse);
  }

  /// ditto 
  static Pen chocolate() {
    return fromKnownColor(KnownColor.Chocolate);
  }

  /// ditto 
  static Pen coral() {
    return fromKnownColor(KnownColor.Coral);
  }

  /// ditto 
  static Pen cornflowerBlue() {
    return fromKnownColor(KnownColor.CornflowerBlue);
  }

  /// ditto 
  static Pen cornsilk() {
    return fromKnownColor(KnownColor.Cornsilk);
  }

  /// ditto 
  static Pen crimson() {
    return fromKnownColor(KnownColor.Crimson);
  }

  /// ditto 
  static Pen cyan() {
    return fromKnownColor(KnownColor.Cyan);
  }

  /// ditto 
  static Pen darkBlue() {
    return fromKnownColor(KnownColor.DarkBlue);
  }

  /// ditto 
  static Pen darkCyan() {
    return fromKnownColor(KnownColor.DarkCyan);
  }

  /// ditto 
  static Pen darkGoldenrod() {
    return fromKnownColor(KnownColor.DarkGoldenrod);
  }

  /// ditto 
  static Pen darkGray() {
    return fromKnownColor(KnownColor.DarkGray);
  }

  /// ditto 
  static Pen darkGreen() {
    return fromKnownColor(KnownColor.DarkGreen);
  }

  /// ditto 
  static Pen darkKhaki() {
    return fromKnownColor(KnownColor.DarkKhaki);
  }

  /// ditto 
  static Pen darkMagenta() {
    return fromKnownColor(KnownColor.DarkMagenta);
  }

  /// ditto 
  static Pen darkOliveGreen() {
    return fromKnownColor(KnownColor.DarkOliveGreen);
  }

  /// ditto 
  static Pen darkOrange() {
    return fromKnownColor(KnownColor.DarkOrange);
  }

  /// ditto 
  static Pen darkOrchid() {
    return fromKnownColor(KnownColor.DarkOrchid);
  }

  /// ditto 
  static Pen darkRed() {
    return fromKnownColor(KnownColor.DarkRed);
  }

  /// ditto 
  static Pen darkSalmon() {
    return fromKnownColor(KnownColor.DarkSalmon);
  }

  /// ditto 
  static Pen darkSeaGreen() {
    return fromKnownColor(KnownColor.DarkSeaGreen);
  }

  /// ditto 
  static Pen darkSlateBlue() {
    return fromKnownColor(KnownColor.DarkSlateBlue);
  }

  /// ditto 
  static Pen darkSlateGray() {
    return fromKnownColor(KnownColor.DarkSlateGray);
  }

  /// ditto 
  static Pen darkTurquoise() {
    return fromKnownColor(KnownColor.DarkTurquoise);
  }

  /// ditto 
  static Pen darkViolet() {
    return fromKnownColor(KnownColor.DarkViolet);
  }

  /// ditto 
  static Pen deepPink() {
    return fromKnownColor(KnownColor.DeepPink);
  }

  /// ditto 
  static Pen deepSkyBlue() {
    return fromKnownColor(KnownColor.DeepSkyBlue);
  }

  /// ditto 
  static Pen dimGray() {
    return fromKnownColor(KnownColor.DimGray);
  }

  /// ditto 
  static Pen dodgerBlue() {
    return fromKnownColor(KnownColor.DodgerBlue);
  }

  /// ditto 
  static Pen firebrick() {
    return fromKnownColor(KnownColor.Firebrick);
  }

  /// ditto 
  static Pen floralWhite() {
    return fromKnownColor(KnownColor.FloralWhite);
  }

  /// ditto 
  static Pen forestGreen() {
    return fromKnownColor(KnownColor.ForestGreen);
  }

  /// ditto 
  static Pen fuchsia() {
    return fromKnownColor(KnownColor.Fuchsia);
  }

  /// ditto 
  static Pen gainsboro() {
    return fromKnownColor(KnownColor.Gainsboro);
  }

  /// ditto 
  static Pen ghostWhite() {
    return fromKnownColor(KnownColor.GhostWhite);
  }

  /// ditto 
  static Pen gold() {
    return fromKnownColor(KnownColor.Gold);
  }

  /// ditto 
  static Pen goldenrod() {
    return fromKnownColor(KnownColor.Goldenrod);
  }

  /// ditto 
  static Pen gray() {
    return fromKnownColor(KnownColor.Gray);
  }

  /// ditto 
  static Pen green() {
    return fromKnownColor(KnownColor.Green);
  }

  /// ditto 
  static Pen greenYellow() {
    return fromKnownColor(KnownColor.GreenYellow);
  }

  /// ditto 
  static Pen honeydew() {
    return fromKnownColor(KnownColor.Honeydew);
  }

  /// ditto 
  static Pen hotPink() {
    return fromKnownColor(KnownColor.HotPink);
  }

  /// ditto 
  static Pen indianRed() {
    return fromKnownColor(KnownColor.IndianRed);
  }

  /// ditto 
  static Pen indigo() {
    return fromKnownColor(KnownColor.Indigo);
  }

  /// ditto 
  static Pen ivory() {
    return fromKnownColor(KnownColor.Ivory);
  }

  /// ditto 
  static Pen khaki() {
    return fromKnownColor(KnownColor.Khaki);
  }

  /// ditto 
  static Pen lavender() {
    return fromKnownColor(KnownColor.Lavender);
  }

  /// ditto 
  static Pen lavenderBlush() {
    return fromKnownColor(KnownColor.LavenderBlush);
  }

  /// ditto 
  static Pen lawnGreen() {
    return fromKnownColor(KnownColor.LawnGreen);
  }

  /// ditto 
  static Pen lemonChiffon() {
    return fromKnownColor(KnownColor.LemonChiffon);
  }

  /// ditto 
  static Pen lightBlue() {
    return fromKnownColor(KnownColor.LightBlue);
  }

  /// ditto 
  static Pen lightCoral() {
    return fromKnownColor(KnownColor.LightCoral);
  }

  /// ditto 
  static Pen lightCyan() {
    return fromKnownColor(KnownColor.LightCyan);
  }

  /// ditto 
  static Pen lightGoldenrodYellow() {
    return fromKnownColor(KnownColor.LightGoldenrodYellow);
  }

  /// ditto 
  static Pen lightGray() {
    return fromKnownColor(KnownColor.LightGray);
  }

  /// ditto 
  static Pen lightGreen() {
    return fromKnownColor(KnownColor.LightGreen);
  }

  /// ditto 
  static Pen lightPink() {
    return fromKnownColor(KnownColor.LightPink);
  }

  /// ditto 
  static Pen lightSalmon() {
    return fromKnownColor(KnownColor.LightSalmon);
  }

  /// ditto 
  static Pen lightSeaGreen() {
    return fromKnownColor(KnownColor.LightSeaGreen);
  }

  /// ditto 
  static Pen lightSkyBlue() {
    return fromKnownColor(KnownColor.LightSkyBlue);
  }

  /// ditto 
  static Pen lightSlateGray() {
    return fromKnownColor(KnownColor.LightSlateGray);
  }

  /// ditto 
  static Pen lightSteelBlue() {
    return fromKnownColor(KnownColor.LightSteelBlue);
  }

  /// ditto 
  static Pen lightYellow() {
    return fromKnownColor(KnownColor.LightYellow);
  }

  /// ditto 
  static Pen lime() {
    return fromKnownColor(KnownColor.Lime);
  }

  /// ditto 
  static Pen limeGreen() {
    return fromKnownColor(KnownColor.LimeGreen);
  }

  /// ditto 
  static Pen linen() {
    return fromKnownColor(KnownColor.Linen);
  }

  /// ditto 
  static Pen magenta() {
    return fromKnownColor(KnownColor.Magenta);
  }

  /// ditto 
  static Pen maroon() {
    return fromKnownColor(KnownColor.Maroon);
  }

  /// ditto 
  static Pen mediumAquamarine() {
    return fromKnownColor(KnownColor.MediumAquamarine);
  }

  /// ditto 
  static Pen mediumBlue() {
    return fromKnownColor(KnownColor.MediumBlue);
  }

  /// ditto 
  static Pen mediumOrchid() {
    return fromKnownColor(KnownColor.MediumOrchid);
  }

  /// ditto 
  static Pen mediumPurple() {
    return fromKnownColor(KnownColor.MediumPurple);
  }

  /// ditto 
  static Pen mediumSeaGreen() {
    return fromKnownColor(KnownColor.MediumSeaGreen);
  }

  /// ditto 
  static Pen mediumSlateBlue() {
    return fromKnownColor(KnownColor.MediumSlateBlue);
  }

  /// ditto 
  static Pen mediumSpringGreen() {
    return fromKnownColor(KnownColor.MediumSpringGreen);
  }

  /// ditto 
  static Pen mediumTurquoise() {
    return fromKnownColor(KnownColor.MediumTurquoise);
  }

  /// ditto 
  static Pen mediumVioletRed() {
    return fromKnownColor(KnownColor.MediumVioletRed);
  }

  /// ditto 
  static Pen midnightBlue() {
    return fromKnownColor(KnownColor.MidnightBlue);
  }

  /// ditto 
  static Pen mintCream() {
    return fromKnownColor(KnownColor.MintCream);
  }

  /// ditto 
  static Pen mistyRose() {
    return fromKnownColor(KnownColor.MistyRose);
  }

  /// ditto 
  static Pen moccasin() {
    return fromKnownColor(KnownColor.Moccasin);
  }

  /// ditto 
  static Pen navajoWhite() {
    return fromKnownColor(KnownColor.NavajoWhite);
  }

  /// ditto 
  static Pen navy() {
    return fromKnownColor(KnownColor.Navy);
  }

  /// ditto 
  static Pen oldLace() {
    return fromKnownColor(KnownColor.OldLace);
  }

  /// ditto 
  static Pen olive() {
    return fromKnownColor(KnownColor.Olive);
  }

  /// ditto 
  static Pen oliveDrab() {
    return fromKnownColor(KnownColor.OliveDrab);
  }

  /// ditto 
  static Pen orange() {
    return fromKnownColor(KnownColor.Orange);
  }

  /// ditto 
  static Pen orangeRed() {
    return fromKnownColor(KnownColor.OrangeRed);
  }

  /// ditto 
  static Pen orchid() {
    return fromKnownColor(KnownColor.Orchid);
  }

  /// ditto 
  static Pen paleGoldenrod() {
    return fromKnownColor(KnownColor.PaleGoldenrod);
  }

  /// ditto 
  static Pen paleGreen() {
    return fromKnownColor(KnownColor.PaleGreen);
  }

  /// ditto 
  static Pen paleTurquoise() {
    return fromKnownColor(KnownColor.PaleTurquoise);
  }

  /// ditto 
  static Pen paleVioletRed() {
    return fromKnownColor(KnownColor.PaleVioletRed);
  }

  /// ditto 
  static Pen papayaWhip() {
    return fromKnownColor(KnownColor.PapayaWhip);
  }

  /// ditto 
  static Pen peachPuff() {
    return fromKnownColor(KnownColor.PeachPuff);
  }

  /// ditto 
  static Pen peru() {
    return fromKnownColor(KnownColor.Peru);
  }

  /// ditto 
  static Pen pink() {
    return fromKnownColor(KnownColor.Pink);
  }

  /// ditto 
  static Pen plum() {
    return fromKnownColor(KnownColor.Plum);
  }

  /// ditto 
  static Pen powderBlue() {
    return fromKnownColor(KnownColor.PowderBlue);
  }

  /// ditto 
  static Pen purple() {
    return fromKnownColor(KnownColor.Purple);
  }

  /// ditto 
  static Pen red() {
    return fromKnownColor(KnownColor.Red);
  }

  /// ditto 
  static Pen rosyBrown() {
    return fromKnownColor(KnownColor.RosyBrown);
  }

  /// ditto 
  static Pen royalBlue() {
    return fromKnownColor(KnownColor.RoyalBlue);
  }

  /// ditto 
  static Pen saddleBrown() {
    return fromKnownColor(KnownColor.SaddleBrown);
  }

  /// ditto 
  static Pen salmon() {
    return fromKnownColor(KnownColor.Salmon);
  }

  /// ditto 
  static Pen sandyBrown() {
    return fromKnownColor(KnownColor.SandyBrown);
  }

  /// ditto 
  static Pen seaGreen() {
    return fromKnownColor(KnownColor.SeaGreen);
  }

  /// ditto 
  static Pen seaShell() {
    return fromKnownColor(KnownColor.SeaShell);
  }

  /// ditto 
  static Pen sienna() {
    return fromKnownColor(KnownColor.Sienna);
  }

  /// ditto 
  static Pen silver() {
    return fromKnownColor(KnownColor.Silver);
  }

  /// ditto 
  static Pen skyBlue() {
    return fromKnownColor(KnownColor.SkyBlue);
  }

  /// ditto 
  static Pen slateBlue() {
    return fromKnownColor(KnownColor.SlateBlue);
  }

  /// ditto 
  static Pen slateGray() {
    return fromKnownColor(KnownColor.SlateGray);
  }

  /// ditto 
  static Pen snow() {
    return fromKnownColor(KnownColor.Snow);
  }

  /// ditto 
  static Pen springGreen() {
    return fromKnownColor(KnownColor.SpringGreen);
  }

  /// ditto 
  static Pen steelBlue() {
    return fromKnownColor(KnownColor.SteelBlue);
  }

  /// ditto 
  static Pen tan() {
    return fromKnownColor(KnownColor.Tan);
  }

  /// ditto 
  static Pen teal() {
    return fromKnownColor(KnownColor.Teal);
  }

  /// ditto 
  static Pen thistle() {
    return fromKnownColor(KnownColor.Thistle);
  }

  /// ditto 
  static Pen tomato() {
    return fromKnownColor(KnownColor.Tomato);
  }

  /// ditto 
  static Pen turquoise() {
    return fromKnownColor(KnownColor.Turquoise);
  }

  /// ditto 
  static Pen violet() {
    return fromKnownColor(KnownColor.Violet);
  }

  /// ditto 
  static Pen wheat() {
    return fromKnownColor(KnownColor.Wheat);
  }

  /// ditto 
  static Pen white() {
    return fromKnownColor(KnownColor.White);
  }

  /// ditto 
  static Pen whiteSmoke() {
    return fromKnownColor(KnownColor.WhiteSmoke);
  }

  /// ditto 
  static Pen yellow() {
    return fromKnownColor(KnownColor.Yellow);
  }

  /// ditto 
  static Pen yellowGreen() {
    return fromKnownColor(KnownColor.YellowGreen);
  }

  /// ditto 
  static Pen buttonFace() {
    return fromKnownColor(KnownColor.ButtonFace);
  }

  /// ditto 
  static Pen buttonHighlight() {
    return fromKnownColor(KnownColor.ButtonHighlight);
  }

  /// ditto 
  static Pen buttonShadow() {
    return fromKnownColor(KnownColor.ButtonShadow);
  }

  /// ditto 
  static Pen gradientActiveCaption() {
    return fromKnownColor(KnownColor.GradientActiveCaption);
  }

  /// ditto 
  static Pen gradientInactiveCaption() {
    return fromKnownColor(KnownColor.GradientInactiveCaption);
  }

  /// ditto 
  static Pen menuBar() {
    return fromKnownColor(KnownColor.MenuBar);
  }

  /// ditto 
  static Pen menuHighlight() {
    return fromKnownColor(KnownColor.MenuHighlight);
  }

}

/**
 */
final class ImageAttributes {

  private Укз nativeImageAttributes_;

  /**
   */
  this() {
    Status status = GdipCreateImageAttributes(nativeImageAttributes_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  ~this() {
    dispose();
  }
  
  /**
   */
  проц dispose() {
    if (nativeImageAttributes_ != Укз.init) {
      GdipDisposeImageAttributesSafe(nativeImageAttributes_);
      nativeImageAttributes_ = Укз.init;
    }
  }

  /**
   */
  проц setColorKey(Цвет colorLow, Цвет colorHigh, ColorAdjustType тип = ColorAdjustType.Default) {
    Status status = GdipSetImageAttributesColorKeys(nativeImageAttributes_, тип, 1, colorLow.toArgb(), colorHigh.toArgb());
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц clearColorKey(ColorAdjustType тип = ColorAdjustType.Default) {
    Status status = GdipSetImageAttributesColorKeys(nativeImageAttributes_, тип, 0, 0, 0);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц setColorMatrix(ColorMatrix newColorMatrix, ColorMatrixFlag mode = ColorMatrixFlag.Default, ColorAdjustType тип = ColorAdjustType.Default) {
    GpColorMatrix m;
    for (цел j = 0; j < 5; j++) {
      for (цел i = 0; i < 5; i++)
        m.m[j][i] = newColorMatrix[j, i];
    }

    Status status = GdipSetImageAttributesColorMatrix(nativeImageAttributes_, тип, 1, &m, null, mode);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц clearColorMatrix(ColorAdjustType тип = ColorAdjustType.Default) {
    Status status = GdipSetImageAttributesColorMatrix(nativeImageAttributes_, тип, 0, null, null, ColorMatrixFlag.Default);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /*package*/ Укз nativeImageAttributes() {
    return nativeImageAttributes_;
  }

}

/**
 */
abstract class Image : ИВымещаемый {

  alias бул delegate(ук callbackData) GetThumbnailImageAbort;

  private Укз nativeImage_;

  private this() {
  }

  private this(Укз nativeImage) {
    nativeImage_ = nativeImage;
  }

  ~this() {
    dispose(false);
  }

  final проц dispose() {
    dispose(true);
  }

  /**
   */
  protected проц dispose(бул disposing) {
    if (nativeImage_ != Укз.init) {
      GdipDisposeImageSafe(nativeImage_);
      nativeImage_ = Укз.init;
    }
  }

  /**
   */
  final Объект clone() {
    Укз cloneImage;

    Status status = GdipCloneImage(nativeImage_, cloneImage);
    if (status != Status.ОК)
      throw statusException(status);

    return createImage(cloneImage);
  }

  /**
   */
  static Image fromFile(ткст имяф, бул useEmbeddedColorManagement = false) {
    if (!естьФайл(имяф))
      throw new ФайлНеНайденИскл(имяф);

    имяф = win32.io.path.дайПолнПуть(имяф);

    Укз nativeImage;

    Status status = useEmbeddedColorManagement 
      ? GdipLoadImageFromFileICM(имяф.вУтф16н(), nativeImage)
      : GdipLoadImageFromFile(имяф.вУтф16н(), nativeImage);
    if (status != Status.ОК)
      throw statusException(status);

    return createImage(nativeImage);
  }

  /**
   */
  static Image fromStream(Поток поток, бул useEmbeddedColorManagement = false) {
    auto s = new COMStream(поток);
    scope(exit) tryRelease(s);

    Укз nativeImage;

    Status status = useEmbeddedColorManagement 
      ? GdipLoadImageFromStreamICM(s, nativeImage)
      : GdipLoadImageFromStream(s, nativeImage);
    if (status != Status.ОК)
      throw statusException(status);

    return createImage(nativeImage);
  }

  /**
   */
  private static Image createImage(Укз nativeImage) {
    ImageType тип;

    Status status = GdipGetImageType(nativeImage, тип);
    if (status != Status.ОК)
      throw statusException(status);

    Image image;
    switch (тип) {
      case ImageType.Bitmap:
        image = new Bitmap(nativeImage);
        break;
      case ImageType.Metafile:
        image = new Metafile(nativeImage);
        break;
      default:
        throw new win32.base.core.ИсклАргумента("nativeImage");
    }
    return image;
  }

  /**
   */
  static Bitmap fromHbitmap(Укз hbitmap, Укз hpalette = Укз.init) {
    Укз битмап;
    Status status = GdipCreateBitmapFromHBITMAP(hbitmap, hpalette, битмап);
    if (status != Status.ОК)
      throw statusException(status);
    return new Bitmap(битмап);
  }

  /**
   */
  final проц save(ткст имяф) {
    save(имяф, rawFormat);
  }

  /**
   */
  final проц save(ткст имяф, ImageFormat format) {
    if (format is null)
      throw new ИсклНулевогоАргумента("format");

    ImageCodecInfo codec = null;

    foreach (элт; ImageCodecInfo.getImageEncoders()) {
      if (элт.formatId == format.гуид) {
        codec = элт;
        break;
      }
    }

    if (codec is null) {
      foreach (элт; ImageCodecInfo.getImageEncoders()) {
        if (элт.formatId == ImageFormat.png.гуид) {
          codec = элт;
          break;
        }
      }
    }

    save(имяф, codec, null);
  }

  /**
   */
  final проц save(ткст имяф, ImageCodecInfo encoder, EncoderParameters encoderParams) {
    if (encoder is null)
      throw new ИсклНулевогоАргумента("encoder");

    GpEncoderParameters* pParams = null;
    if (encoderParams !is null)
      pParams = encoderParams.forGDIplus();

    Guid g = encoder.clsid;
    Status status = GdipSaveImageToFile(nativeImage_, имяф.вУтф16н(), g, pParams);

    if (pParams !is null)
      LocalFree(cast(Укз)pParams);

    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  final проц save(Поток поток, ImageFormat format) {
    if (поток is null)
      throw new ИсклНулевогоАргумента("поток");

    if (format is null)
      throw new ИсклНулевогоАргумента("format");

    ImageCodecInfo codec = null;
    foreach (элт; ImageCodecInfo.getImageEncoders()) {
      if (элт.formatId == format.гуид) {
        codec = элт;
        break;
      }
    }

    save(поток, codec, null);
  }

  /**
   */
  final проц save(Поток поток, ImageCodecInfo encoder, EncoderParameters encoderParams) {
    if (поток is null)
      throw new ИсклНулевогоАргумента("поток");

    if (encoder is null)
      throw new ИсклНулевогоАргумента("encoder");

    auto s = new COMStream(поток);
    scope(exit) tryRelease(s);

    GpEncoderParameters* pParams = null;
    if (encoderParams !is null)
      pParams = encoderParams.forGDIplus();

    Guid g = encoder.clsid;
    Status status = GdipSaveImageToStream(nativeImage_, s, g, pParams);

    if (pParams !is null)
      LocalFree(cast(Укз)pParams);

    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  final Image getThumbnailImage(цел thumbWidth, цел thumbHeight, GetThumbnailImageAbort обрвыз, ук callbackData) {
    static GetThumbnailImageAbort callbackDelegate;

    extern(Windows) static цел getThumbnailImageAbortCallback(ук callbackData) {
      return callbackDelegate(callbackData) ? 1 : 0;
    }

    callbackDelegate = обрвыз;

    Укз thumbImage;
    Status status = GdipGetImageThumbnail(nativeImage_, thumbWidth, thumbHeight, thumbImage, (обрвыз is null) ? null : &getThumbnailImageAbortCallback, callbackData);
    if (status != Status.ОК)
      throw statusException(status);

    return createImage(thumbImage);
  }

  /**
   */
  final ПрямП getBounds(ref GraphicsUnit pageUnit) {
    ПрямП прям;
    Status status = GdipGetImageBounds(nativeImage_, прям, pageUnit);
    if (status != Status.ОК)
      throw statusException(status);
    return прям;
  }

  /**
   */
  final проц rotateFlip(RotateFlipType rotateFlipType) {
    Status status = GdipImageRotateFlip(nativeImage_, rotateFlipType);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  final SizeF physicalDimension() {
    плав ширина, высота;
    Status status = GdipGetImageDimension(nativeImage_, ширина, высота);
    if (status != Status.ОК)
      throw statusException(status);
    return SizeF(ширина, высота);
  }

  /**
   */
  final цел ширина() {
    цел значение;
    Status status = GdipGetImageWidth(nativeImage_, значение);
    if (status != Status.ОК)
      throw statusException(status);
    return значение;
  }

  /**
   */
  final цел высота() {
    цел значение;
    Status status = GdipGetImageHeight(nativeImage_, значение);
    if (status != Status.ОК)
      throw statusException(status);
    return значение;
  }

  /**
   */
  final Размер размер() {
    return Размер(ширина, высота);
  }

  /**
   */
  final плав horizontalResolution() {
    плав resolution;
    Status status = GdipGetImageHorizontalResolution(nativeImage_, resolution);
    if (status != Status.ОК)
      throw statusException(status);
    return resolution;
  }

  /**
   */
  final плав verticalResolution() {
    плав resolution;
    Status status = GdipGetImageVerticalResolution(nativeImage_, resolution);
    if (status != Status.ОК)
      throw statusException(status);
    return resolution;
  }

  /**
   */
  final ImageFormat rawFormat() {
    Guid format;
    Status status = GdipGetImageRawFormat(nativeImage_, format);
    if (status != Status.ОК)
      throw statusException(status);
    return new ImageFormat(format);
  }

  /**
   */
  final PixelFormat pixelFormat() {
    PixelFormat значение;
    Status status = GdipGetImagePixelFormat(nativeImage_, значение);
    if (status != Status.ОК)
      return PixelFormat.Undefined;
    return значение;
  }

  /**
   */
  final Guid[] frameDimensionsList() {
    бцел счёт;
    Status status = GdipImageGetFrameDimensionsCount(nativeImage_, счёт);
    if (status != Status.ОК)
      throw statusException(status);

    if (счёт == 0)
      return new Guid[0];

    Guid[] dimensionIDs = new Guid[счёт];

    status = GdipImageGetFrameDimensionsList(nativeImage_, dimensionIDs.ptr, счёт);
    if (status != Status.ОК)
      throw statusException(status);

    return dimensionIDs;
  }

  /**
   */
  final бцел getFrameCount(FrameDimension dimension) {
    бцел счёт;
    Guid dimensionId = dimension.гуид;
    Status status = GdipImageGetFrameCount(nativeImage_, dimensionId, счёт);
    if (status != Status.ОК)
      throw statusException(status);

    return счёт;
  }

  /**
   */
  final проц selectActiveFrame(FrameDimension dimension, бцел frameIndex) {
    Guid dimensionId = dimension.гуид;
    Status status = GdipImageSelectActiveFrame(nativeImage_, dimensionId, frameIndex);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  final PropertyItem getPropertyItem(цел propId) {
    бцел размер;
    Status status = GdipGetPropertyItemSize(nativeImage_, propId, размер);
    if (status != Status.ОК)
      throw statusException(status);

    if (размер == 0)
      return null;


    GpPropertyItem* буфер = cast(GpPropertyItem*)LocalAlloc(LMEM_FIXED, размер);
    if (буфер is null)
      throw statusException(Status.OutOfMemory);

    scope(exit) LocalFree(буфер);

    status = GdipGetPropertyItem(nativeImage_, propId, размер, буфер);
    if (status != Status.ОК)
      throw statusException(status);

    auto элт = new PropertyItem;
    элт.ид = буфер.ид;
    элт.len = буфер.len;
    элт.тип = буфер.тип;
    элт.значение = cast(ббайт[])буфер.значение[0 .. буфер.len];
    return элт;
  }

}

/**
 */
final class Bitmap : Image {

  private this() {
  }

  private this(Укз nativeImage) {
    nativeImage_ = nativeImage;
  }

  /**
   */
  this(ткст имяф, бул useEmbeddedColorManagement = false) {
    //имяф = win32.io.path.дайПолнПуть(имяф);

    Status status = useEmbeddedColorManagement
      ? GdipCreateBitmapFromFileICM(имяф.вУтф16н(), nativeImage_)
      : GdipCreateBitmapFromFile(имяф.вУтф16н(), nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Поток поток) {
    if (поток is null)
      throw new ИсклНулевогоАргумента("поток");

    auto s = new COMStream(поток);
    scope(exit) tryRelease(s);

    Status status = GdipCreateBitmapFromStream(s, nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Image original) {
    this(original, original.ширина, original.высота);
  }

  /**
   */
  this(Image original, цел ширина, цел высота) {
    this(ширина, высота);

    scope g = Graphics.fromImage(this);
    g.сотри(Цвет.transparent);
    g.drawImage(original, 0, 0, ширина, высота);
  }

  /**
   */
  this(Image original, Размер размер) {
    this(original, размер.ширина, размер.высота);
  }

  /**
   */
  this(цел ширина, цел высота, PixelFormat format = PixelFormat.Format32bppArgb) {
    Status status = GdipCreateBitmapFromScan0(ширина, высота, 0, format, null, nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(цел ширина, цел высота, цел stride, PixelFormat format, ббайт* scan0) {
    Status status = GdipCreateBitmapFromScan0(ширина, высота, stride, format, scan0, nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(цел ширина, цел высота, Graphics g) {
    if (g is null)
      throw new ИсклНулевогоАргумента("g");

    Status status = GdipCreateBitmapFromGraphics(ширина, высота, g.nativeGraphics_, nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  static Bitmap fromResource(Укз hinstance, ткст bitmapName) {
    // Poorly documented, but the resource тип in your .rc скрипт must be BITMAP, eg
    //   splash BITMAP "images\\splash.bmp"
    // where bitmapName is "splash". 
    // Does not appear to загрузи any другой image тип such as JPEG, GIF or PNG, so of limited utility. 
    // A more flexible way would be to call LoadResource/LockResource to копируй the данные into a 
    // ПотокПамяти which Image.fromStream can use.

    Укз nativeImage;
    Status status = GdipCreateBitmapFromResource(hinstance, bitmapName.вУтф16н(), nativeImage);
    if (status != Status.ОК)
      throw statusException(status);
    return new Bitmap(nativeImage);
  }

  /**
   */
  static Bitmap fromHicon(Укз hicon) {
    Укз битмап;
    Status status = GdipCreateBitmapFromHICON(hicon, битмап);
    if (status != Status.ОК)
      throw statusException(status);
    return new Bitmap(битмап);
  }

  /**
   */
  Укз getHbitmap(Цвет background = Цвет.lightGray) {
    Укз hbitmap;
    Status status = GdipCreateHBITMAPFromBitmap(nativeImage_, hbitmap, background.toRgb());
    if (status != Status.ОК)
      throw statusException(status);
    return hbitmap;
  }

  /**
   */
  Укз getHicon() {
    Укз hicon;
    Status status = GdipCreateHICONFromBitmap(nativeImage_, hicon);
    if (status != Status.ОК)
      throw statusException(status);
    return hicon;
  }

  /**
   */
  BitmapData lockBits(Прям прям, ImageLockMode флаги, PixelFormat format, BitmapData bitmapData = null) {
    if (bitmapData is null)
      bitmapData = new BitmapData;

    GpBitmapData данные;
    if (bitmapData !is null) {
      данные.Width = bitmapData.ширина;
      данные.Height = bitmapData.высота;
      данные.Stride = bitmapData.stride;
      данные.Scan0 = bitmapData.scan0;
      данные.Reserved = bitmapData.reserved;
    }

    Status status = GdipBitmapLockBits(nativeImage_, прям, флаги, format, данные);
    if (status != Status.ОК)
      throw statusException(status);

    bitmapData.ширина = данные.Width;
    bitmapData.высота = данные.Height;
    bitmapData.stride = данные.Stride;
    bitmapData.scan0 = данные.Scan0;
    bitmapData.reserved = данные.Reserved;

    return bitmapData;
  }

  /**
   */
  проц unlockBits(BitmapData bitmapData) {
    GpBitmapData данные;
    данные.Width = bitmapData.ширина;
    данные.Height = bitmapData.высота;
    данные.Stride = bitmapData.stride;
    данные.Scan0 = bitmapData.scan0;
    данные.Reserved = bitmapData.reserved;

    Status status = GdipBitmapUnlockBits(nativeImage_, данные);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  Цвет getPixel(цел x, цел y) {
    цел цвет;
    Status status = GdipBitmapGetPixel(nativeImage_, x, y, цвет);
    if (status != Status.ОК)
      throw statusException(status);
    return Цвет.fromArgb(цвет);
  }

  /**
   */
  проц setPixel(цел x, цел y, Цвет цвет) {
    Status status = GdipBitmapSetPixel(nativeImage_, x, y, цвет.toArgb());
    if (status != Status.ОК)
      throw statusException(status);
  }
  
  /**
   */
  проц setResolution(плав xdpi, плав ydpi) {
    Status status = GdipBitmapSetResolution(nativeImage_, xdpi, ydpi);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц makeTransparent() {
    Цвет transparentColor = Цвет.lightGray;
    if (ширина > 0 && высота > 0)
      transparentColor = getPixel(0, высота - 1);
    if (transparentColor.a >= 255)
      makeTransparent(transparentColor);
  }

  /**
   */
  проц makeTransparent(Цвет transparentColor) {
    Размер размер = this.размер;

    scope bmp = new Bitmap(размер.ширина, размер.высота, PixelFormat.Format32bppArgb);
    scope g = Graphics.fromImage(bmp);
    g.сотри(Цвет.transparent);

    scope attrs = new ImageAttributes;
    attrs.setColorKey(transparentColor, transparentColor);
    g.drawImage(this, Прям(0, 0, размер.ширина, размер.высота), 0, 0, размер.ширина, размер.высота, GraphicsUnit.Pixel, attrs);

    Укз времн = nativeImage_;
    nativeImage_ = bmp.nativeImage_;
    bmp.nativeImage_ = времн;
  }

}

/**
 */
final class WmfPlaceableFileHeader {
  бцел ключ;
  крат hmf;
  крат boundingBoxLeft;
  крат boundingBoxTop;
  крат boundingBoxRight;
  крат boundingBoxBottom;
  крат inch;
  бцел reserved;
  крат checksum;
}

/**
 */
final class Metafile : Image {

  private this() {
  }

  private this(Укз nativeImage) {
    nativeImage_ = nativeImage;
  }

  /**
   */
  this(Укз hmetafile, WmfPlaceableFileHeader wmfHeader, бул deleteEmf = false) {
    GdipWmfPlaceableFileHeader gpheader;
    with (gpheader) {
      with (wmfHeader) {
        Key = ключ;
        Hmf = hmf;
        BoundingBoxLeft = boundingBoxLeft;
        BoundingBoxTop = boundingBoxTop;
        BoundingBoxRight = boundingBoxRight;
        BoundingBoxBottom = boundingBoxBottom;
        Inch = inch;
        Reserved = reserved;
        Checksum = checksum;
      }
    }

    Status status = GdipCreateMetafileFromWmf(hmetafile, deleteEmf ? 1 : 0, gpheader, nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Укз henhmetafile, бул deleteEmf) {
    Status status = GdipCreateMetafileFromEmf(henhmetafile, deleteEmf ? 1 : 0, nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(ткст имяф) {
    if (!естьФайл(имяф))
      throw new ФайлНеНайденИскл(имяф);

    Status status = GdipCreateMetafileFromFile(имяф.вУтф16н(), nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(ткст имяф, WmfPlaceableFileHeader wmfHeader) {
    GdipWmfPlaceableFileHeader gpheader;
    with (gpheader) {
      with (wmfHeader) {
        Key = ключ;
        Hmf = hmf;
        BoundingBoxLeft = boundingBoxLeft;
        BoundingBoxTop = boundingBoxTop;
        BoundingBoxRight = boundingBoxRight;
        BoundingBoxBottom = boundingBoxBottom;
        Inch = inch;
        Reserved = reserved;
        Checksum = checksum;
      }
    }

    Status status = GdipCreateMetafileFromWmfFile(имяф.вУтф16н(), gpheader, nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Поток поток) {
    if (поток is null)
      throw new ИсклНулевогоАргумента("поток");

    auto s = new COMStream(поток);
    scope(exit) tryRelease(s);

    Status status = GdipCreateMetafileFromStream(s, nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Укз referenceHdc, EmfType emfType, ткст описание = null) {
    Status status = GdipRecordMetafile(referenceHdc, emfType, null, MetafileFrameUnit.GdiCompatible, описание.вУтф16н(), nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Укз referenceHdc, ПрямП frameRect, MetafileFrameUnit frameUnit = MetafileFrameUnit.GdiCompatible, EmfType emfType = EmfType.EmfPlusDual, ткст описание = null) {
    Status status = GdipRecordMetafile(referenceHdc, emfType, &frameRect, frameUnit, описание.вУтф16н(), nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Укз referenceHdc, Прям frameRect, MetafileFrameUnit frameUnit = MetafileFrameUnit.GdiCompatible, EmfType emfType = EmfType.EmfPlusDual, ткст описание = null) {
    Status status = GdipRecordMetafileI(referenceHdc, emfType, &frameRect, frameUnit, описание.вУтф16н(), nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(ткст имяф, Укз referenceHdc, EmfType emfType = EmfType.EmfPlusDual, ткст описание = null) {
    Status status = GdipRecordMetafileFileName(имяф.вУтф16н(), referenceHdc, emfType, null, MetafileFrameUnit.GdiCompatible, описание.вУтф16н(), nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(ткст имяф, Укз referenceHdc, ПрямП frameRect, MetafileFrameUnit frameUnit = MetafileFrameUnit.GdiCompatible, EmfType emfType = EmfType.EmfPlusDual, ткст описание = null) {
    Status status = GdipRecordMetafileFileName(имяф.вУтф16н(), referenceHdc, emfType, &frameRect, frameUnit, описание.вУтф16н(), nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(ткст имяф, Укз referenceHdc, Прям frameRect, MetafileFrameUnit frameUnit = MetafileFrameUnit.GdiCompatible, EmfType emfType = EmfType.EmfPlusDual, ткст описание = null) {
    Status status = GdipRecordMetafileFileNameI(имяф.вУтф16н(), referenceHdc, emfType, &frameRect, frameUnit, описание.вУтф16н(), nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Поток поток, Укз referenceHdc, EmfType emfType = EmfType.EmfPlusDual, ткст описание = null) {
    auto s = new COMStream(поток);
    scope(exit) tryRelease(s);

    Status status = GdipRecordMetafileStream(s, referenceHdc, emfType, null, MetafileFrameUnit.GdiCompatible, описание.вУтф16н(), nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Поток поток, Укз referenceHdc, ПрямП frameRect, MetafileFrameUnit frameUnit = MetafileFrameUnit.GdiCompatible, EmfType emfType = EmfType.EmfPlusDual, ткст описание = null) {
    auto s = new COMStream(поток);
    scope(exit) tryRelease(s);

    Status status = GdipRecordMetafileStream(s, referenceHdc, emfType, &frameRect, frameUnit, описание.вУтф16н(), nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  this(Поток поток, Укз referenceHdc, Прям frameRect, MetafileFrameUnit frameUnit = MetafileFrameUnit.GdiCompatible, EmfType emfType = EmfType.EmfPlusDual, ткст описание = null) {
    auto s = new COMStream(поток);
    scope(exit) tryRelease(s);

    Status status = GdipRecordMetafileStreamI(s, referenceHdc, emfType, &frameRect, frameUnit, описание.вУтф16н(), nativeImage_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  Укз getHenhmetafile() {
    Укз hemf;
    Status status = GdipGetHemfFromMetafile(nativeImage_, hemf);
    if (status != Status.ОК)
      throw statusException(status);
    return hemf;
  }

  /*проц playRecord(EmfPlusRecordType recordType, бцел флаги, бцел dataSize, ббайт[] данные) {
    Status status = GdipPlayMetafileRecord(nativeImage_, recordType, флаги, dataSize, данные.ptr);
    if (status != Status.ОК)
      throw statusException(status);
  }*/

}

/**
 */
final class Path {

  private Укз nativePath_;

  private const плав FlatnessDefault = 1.0f / 4.0f;

  /**
   */
  this(FillMode fillMode = FillMode.Alternate) {
    Status status = GdipCreatePath(fillMode, nativePath_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(ТочкаП[] points, ббайт[] типы, FillMode fillMode = FillMode.Alternate) {
    if (points.length != типы.length)
      throw statusException(Status.InvalidParameter);

    Status status = GdipCreatePath2(points.ptr, типы.ptr, типы.length, fillMode, nativePath_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Точка[] points, ббайт[] типы, FillMode fillMode = FillMode.Alternate) {
    if (points.length != типы.length)
      throw statusException(Status.InvalidParameter);

    Status status = GdipCreatePath2I(points.ptr, типы.ptr, типы.length, fillMode, nativePath_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  ~this() {
    dispose();
  }

  /**
   */
  проц dispose() {
    if (nativePath_ != Укз.init) {
      GdipDeletePathSafe(nativePath_);
      nativePath_ = Укз.init;
    }
  }

  /**
   */
  проц сбрось() {
    Status status = GdipResetPath(nativePath_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц startFigure() {
    Status status = GdipStartPathFigure(nativePath_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц closeFigure() {
    Status status = GdipClosePathFigure(nativePath_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц closeAllFigures() {
    Status status = GdipClosePathFigures(nativePath_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц setMarkers() {
    Status status = GdipSetPathMarker(nativePath_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц clearMarkers() {
    Status status = GdipClearPathMarkers(nativePath_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц реверсни() {
    Status status = GdipReversePath(nativePath_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  ТочкаП getLastPoint() {
    ТочкаП lastPoint;
    Status status = GdipGetPathLastPoint(nativePath_, lastPoint);
    if (status != Status.ОК)
      throw statusException(status);
    return lastPoint;
  }

  /**
   */
  проц addLine(ТочкаП pt1, ТочкаП pt2) {
    addLine(pt1.x, pt1.y, pt2.x, pt2.y);
  }

  /**
   */
  проц addLine(плав x1, плав y1, плав x2, плав y2) {
    Status status = GdipAddPathLine(nativePath_, x1, y1, x2, y2);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addLines(ТочкаП[] points) {
    Status status = GdipAddPathLine2(nativePath_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addLine(Точка pt1, Точка pt2) {
    addLine(pt1.x, pt1.y, pt2.x, pt2.y);
  }

  /**
   */
  проц addLine(цел x1, цел y1, цел x2, цел y2) {
    Status status = GdipAddPathLineI(nativePath_, x1, y1, x2, y2);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addLines(Точка[] points) {
    Status status = GdipAddPathLine2I(nativePath_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addArc(ПрямП прям, плав startAngle, плав sweepAngle) {
    addArc(прям.x, прям.y, прям.ширина, прям.высота, startAngle, sweepAngle);
  }

  /**
   */
  проц addArc(плав x, плав y, плав ширина, плав высота, плав startAngle, плав sweepAngle) {
    Status status = GdipAddPathArc(nativePath_, x, y, ширина, высота, startAngle, sweepAngle);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addArc(Прям прям, плав startAngle, плав sweepAngle) {
    addArc(прям.x, прям.y, прям.ширина, прям.высота, startAngle, sweepAngle);
  }

  /**
   */
  проц addArc(цел x, цел y, цел ширина, цел высота, плав startAngle, плав sweepAngle) {
    Status status = GdipAddPathArcI(nativePath_, x, y, ширина, высота, startAngle, sweepAngle);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addBezier(ТочкаП pt1, ТочкаП pt2, ТочкаП pt3, ТочкаП pt4) {
    addBezier(pt1.x, pt1.y, pt2.x, pt2.y, pt3.x, pt3.y, pt4.x, pt4.y);
  }

  /**
   */
  проц addBezier(плав x1, плав y1, плав x2, плав y2, плав x3, плав y3, плав x4, плав y4) {
    Status status = GdipAddPathBezier(nativePath_, x2, y1, x2, y2, x3, y3, x4, y4);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addBeziers(ТочкаП[] points) {
    Status status = GdipAddPathBeziers(nativePath_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addBezier(Точка pt1, Точка pt2, Точка pt3, Точка pt4) {
    addBezier(pt1.x, pt1.y, pt2.x, pt2.y, pt3.x, pt3.y, pt4.x, pt4.y);
  }

  /**
   */
  проц addBezier(цел x1, цел y1, цел x2, цел y2, цел x3, цел y3, цел x4, цел y4) {
    Status status = GdipAddPathBezierI(nativePath_, x2, y1, x2, y2, x3, y3, x4, y4);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addBeziers(Точка[] points) {
    Status status = GdipAddPathBeziersI(nativePath_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addCurve(ТочкаП[] points) {
    Status status = GdipAddPathCurve(nativePath_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addCurve(ТочкаП[] points, плав tension) {
    Status status = GdipAddPathCurve2(nativePath_, points.ptr, points.length, tension);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addCurve(ТочкаП[] points, цел смещение, цел numberOfSegments, плав tension) {
    Status status = GdipAddPathCurve3(nativePath_, points.ptr, points.length, смещение, numberOfSegments, tension);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addCurve(Точка[] points) {
    Status status = GdipAddPathCurveI(nativePath_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addCurve(Точка[] points, плав tension) {
    Status status = GdipAddPathCurve2I(nativePath_, points.ptr, points.length, tension);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addCurve(Точка[] points, цел смещение, цел numberOfSegments, плав tension) {
    Status status = GdipAddPathCurve3I(nativePath_, points.ptr, points.length, смещение, numberOfSegments, tension);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addClosedCurve(ТочкаП[] points) {
    Status status = GdipAddPathClosedCurve(nativePath_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addClosedCurve(ТочкаП[] points, плав tension) {
    Status status = GdipAddPathClosedCurve2(nativePath_, points.ptr, points.length, tension);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addClosedCurve(Точка[] points) {
    Status status = GdipAddPathClosedCurveI(nativePath_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addClosedCurve(Точка[] points, плав tension) {
    Status status = GdipAddPathClosedCurve2I(nativePath_, points.ptr, points.length, tension);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addRectangle(ПрямП прям) {
    Status status = GdipAddPathRectangle(nativePath_, прям.x, прям.y, прям.ширина, прям.высота);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addRectangles(ПрямП[] rects) {
    Status status = GdipAddPathRectangles(nativePath_, rects.ptr, rects.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addRectangle(Прям прям) {
    Status status = GdipAddPathRectangleI(nativePath_, прям.x, прям.y, прям.ширина, прям.высота);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addRectangles(Прям[] rects) {
    Status status = GdipAddPathRectanglesI(nativePath_, rects.ptr, rects.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addEllipse(ПрямП прям) {
    addEllipse(прям.x, прям.y, прям.ширина, прям.высота);
  }

  /**
   */
  проц addEllipse(плав x, плав y, плав ширина, плав высота) {
    Status status = GdipAddPathEllipse(nativePath_, x, y, ширина, высота);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addEllipse(Прям прям) {
    addEllipse(прям.x, прям.y, прям.ширина, прям.высота);
  }

  /**
   */
  проц addEllipse(цел x, цел y, цел ширина, цел высота) {
    Status status = GdipAddPathEllipseI(nativePath_, x, y, ширина, высота);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addPie(ПрямП прям, плав startAngle, плав sweepAngle) {
    addPie(прям.x, прям.y, прям.ширина, прям.высота, startAngle, sweepAngle);
  }

  /**
   */
  проц addPie(плав x, плав y, плав ширина, плав высота, плав startAngle, плав sweepAngle) {
    Status status = GdipAddPathPie(nativePath_, x, y, ширина, высота, startAngle, sweepAngle);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addPie(Прям прям, плав startAngle, плав sweepAngle) {
    addPie(прям.x, прям.y, прям.ширина, прям.высота, startAngle, sweepAngle);
  }

  /**
   */
  проц addPie(цел x, цел y, цел ширина, цел высота, плав startAngle, плав sweepAngle) {
    Status status = GdipAddPathPieI(nativePath_, x, y, ширина, высота, startAngle, sweepAngle);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addPolygon(ТочкаП[] points) {
    Status status = GdipAddPathPolygon(nativePath_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addPolygon(Точка[] points) {
    Status status = GdipAddPathPolygonI(nativePath_, points.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addPath(Path addingPath, бул connect) {
    if (addingPath is null)
      throw new ИсклНулевогоАргумента("addingPath");

    Status status = GdipAddPathPath(nativePath_, addingPath.nativePath_, (connect ? 1 : 0));
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addString(ткст s, FontFamily семейство, FontStyle style, плав emSize, ТочкаП origin, StringFormat format) {
    ПрямП layoutRect = ПрямП(origin.x, origin.y, 0, 0);
    Status status = GdipAddPathString(nativePath_, s.вУтф16н(), s.length, (семейство is null ? Укз.init : семейство.nativeFamily_), style, emSize, layoutRect, (format is null ? Укз.init : format.nativeFormat_));
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addString(ткст s, FontFamily семейство, FontStyle style, плав emSize, ПрямП layoutRect, StringFormat format) {
    Status status = GdipAddPathString(nativePath_, s.вУтф16н(), s.length, (семейство is null ? Укз.init : семейство.nativeFamily_), style, emSize, layoutRect, (format is null ? Укз.init : format.nativeFormat_));
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addString(ткст s, FontFamily семейство, FontStyle style, плав emSize, Точка origin, StringFormat format) {
    Прям layoutRect = Прям(origin.x, origin.y, 0, 0);
    Status status = GdipAddPathStringI(nativePath_, s.вУтф16н(), s.length, (семейство is null ? Укз.init : семейство.nativeFamily_), style, emSize, layoutRect, (format is null ? Укз.init : format.nativeFormat_));
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addString(ткст s, FontFamily семейство, FontStyle style, плав emSize, Прям layoutRect, StringFormat format) {
    Status status = GdipAddPathStringI(nativePath_, s.вУтф16н(), s.length, (семейство is null ? Укз.init : семейство.nativeFamily_), style, emSize, layoutRect, (format is null ? Укз.init : format.nativeFormat_));
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц transform(Matrix matrix) {
    if (matrix is null)
      throw new ИсклНулевогоАргумента("matrix");

    if (matrix.nativeMatrix_ != Укз.init) {
      Status status = GdipTransformPath(nativePath_, matrix.nativeMatrix_);
      if (status != Status.ОК)
        throw statusException(status);
    }
  }

  /**
   */
  ПрямП getBounds(Matrix matrix = null, Pen pen = null) {
    Укз nativeMatrix, nativePen;
    if (matrix !is null) nativeMatrix = matrix.nativeMatrix_;
    if (pen !is null) nativePen = pen.nativePen_;

    ПрямП bounds;
    Status status = GdipGetPathWorldBounds(nativePath_, bounds, nativeMatrix, nativePen);
    if (status != Status.ОК)
      throw statusException(status);
    return bounds;
  }

  /**
   */
  проц flatten(Matrix matrix = null, плав flatness = FlatnessDefault) {
    Status status = GdipFlattenPath(nativePath_, (matrix is null ? Укз.init : matrix.nativeMatrix_), flatness);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц widen(Pen pen, Matrix matrix = null, плав flatness = FlatnessDefault) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    Status status = GdipWidenPath(nativePath_, pen.nativePen_, (matrix is null ? Укз.init : matrix.nativeMatrix_), flatness);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц outline(Matrix matrix = null, плав flatness = FlatnessDefault) {
    Status status = GdipWindingModeOutline(nativePath_, (matrix is null ? Укз.init : matrix.nativeMatrix_), flatness);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц warp(ТочкаП[] destPoints, ПрямП srcRect, Matrix matrix = null, WarpMode warpMode = WarpMode.Perspective, плав flatness = FlatnessDefault) {
    Status status = GdipWarpPath(nativePath_, (matrix is null ? Укз.init : matrix.nativeMatrix_), destPoints.ptr, destPoints.length, srcRect.x, srcRect.y, srcRect.ширина, srcRect.высота, warpMode, flatness);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  бул isVisible(ТочкаП pt, Graphics graphics = null) {
    цел рез;
    Status status = GdipIsVisiblePathPoint(nativePath_, pt.x, pt.y, (graphics is null ? Укз.init : graphics.nativeGraphics_), рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез != 0;
  }

  /**
   */
  бул isVisible(плав x, плав y, Graphics graphics = null) {
    return isVisible(ТочкаП(x, y), graphics);
  }

  /**
   */
  бул isVisible(Точка pt, Graphics graphics = null) {
    цел рез;
    Status status = GdipIsVisiblePathPointI(nativePath_, pt.x, pt.y, (graphics is null ? Укз.init : graphics.nativeGraphics_), рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез != 0;
  }

  /**
   */
  бул isVisible(цел x, цел y, Graphics graphics = null) {
    return isVisible(Точка(x, y), graphics);
  }

  /**
   */
  бул isOutlineVisible(ТочкаП pt, Pen pen, Graphics graphics = null) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    цел рез;
    Status status = GdipIsOutlineVisiblePathPoint(nativePath_, pt.x, pt.y, pen.nativePen_, (graphics is null ? Укз.init : graphics.nativeGraphics_), рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез != 0;
  }

  /**
   */
  бул isOutlineVisible(плав x, плав y, Pen pen, Graphics graphics = null) {
    return isOutlineVisible(ТочкаП(x, y), pen, graphics);
  }

  /**
   */
  бул isOutlineVisible(Точка pt, Pen pen, Graphics graphics = null) {
    if (pen is null)
      throw new ИсклНулевогоАргумента("pen");

    цел рез;
    Status status = GdipIsOutlineVisiblePathPointI(nativePath_, pt.x, pt.y, pen.nativePen_, (graphics is null ? Укз.init : graphics.nativeGraphics_), рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез != 0;
  }

  /**
   */
  бул isOutlineVisible(цел x, цел y, Pen pen, Graphics graphics = null) {
    return isOutlineVisible(Точка(x, y), pen, graphics);
  }

  /**
   */
  проц fillMode(FillMode значение) {
    Status status = GdipSetPathFillMode(nativePath_, значение);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   * ditto
   */
  FillMode fillMode() {
    FillMode значение;
    Status status = GdipGetPathFillMode(nativePath_, значение);
    if (status != Status.ОК)
      throw statusException(status);
    return значение;
  }

  /**
   */
  цел pointCount() {
    цел значение;
    Status status = GdipGetPointCount(nativePath_, значение);
    if (status != Status.ОК)
      throw statusException(status);
    return значение;
  }

  /**
   */
  ббайт[] pathTypes() {  
    цел счёт = pointCount;
    ббайт[] типы = new ббайт[счёт];
    Status status = GdipGetPathTypes(nativePath_, типы.ptr, счёт);
    if (status != Status.ОК)
      throw statusException(status);
    return типы;
  }

  /**
   * ditto
   */
  ТочкаП[] pathPoints() {
    цел счёт = pointCount;
    ТочкаП[] points = new ТочкаП[счёт];
    Status status = GdipGetPathPoints(nativePath_, points.ptr, счёт);
    if (status != Status.ОК)
      throw statusException(status);
    return points;
  }

}

/**
 */
final class PathIterator {

  private Укз nativeIter_;

  /**
   */
  this(Path путь) {
    Status status = GdipCreatePathIter(nativeIter_, (путь is null ? Укз.init : путь.nativePath_));
    if (status != Status.ОК)
      throw statusException(status);
  }

  ~this() {
    dispose();
  }

  /**
   */
  проц dispose() {
    if (nativeIter_ != Укз.init) {
      GdipDeletePathIterSafe(nativeIter_);
      nativeIter_ = Укз.init;
    }
  }

  /**
   */
  цел nextSubpath(out цел startIndex, out цел endIndex, out бул isClosed) {
    цел resultCount, closed;
    Status status = GdipPathIterNextSubpath(nativeIter_, resultCount, startIndex, endIndex, closed);
    if (status != Status.ОК)
      throw statusException(status);
    isClosed = (closed != 0);
    return resultCount;
  }

  /**
   */
  цел nextSubpath(Path путь, out бул isClosed) {
    цел resultCount, closed;
    Status status = GdipPathIterNextSubpathPath(nativeIter_, resultCount, (путь is null ? Укз.init : путь.nativePath_), closed);
    if (status != Status.ОК)
      throw statusException(status);
    isClosed = (closed != 0);
    return resultCount;
  }

  /**
   */
  цел nextPathType(out ббайт pathType, out цел startIndex, out цел endIndex) {
    цел resultCount;
    Status status = GdipPathIterNextPathType(nativeIter_, resultCount, pathType, startIndex, endIndex);
    if (status != Status.ОК)
      throw statusException(status);
    return resultCount;
  }

  /**
   */
  цел nextMarker(out цел startIndex, out цел endIndex) {
    цел resultCount;
    Status status = GdipPathIterNextMarker(nativeIter_, resultCount, startIndex, endIndex);
    if (status != Status.ОК)
      throw statusException(status);
    return resultCount;
  }

  /**
   */
  цел nextMarker(Path путь) {
    цел resultCount;
    Status status = GdipPathIterNextMarkerPath(nativeIter_, resultCount, (путь is null ? Укз.init : путь.nativePath_));
    if (status != Status.ОК)
      throw statusException(status);
    return resultCount;
  }

  /**
   */
  проц rewind() {
    Status status = GdipPathIterRewind(nativeIter_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  цел consterate(ref ТочкаП[] points, ref ббайт[] типы) {
    if (points.length != типы.length)
      throw statusException(Status.InvalidParameter);

    цел resultCount;
    Status status = GdipPathIterconsterate(nativeIter_, resultCount, points.ptr, типы.ptr, points.length);
    if (status != Status.ОК)
      throw statusException(status);
    return resultCount;
  }

  /**
   */
  цел copyData(ref ТочкаП[] points, ref ббайт[] типы, цел startIndex, цел endIndex) {
    if (points.length != типы.length)
      throw statusException(Status.InvalidParameter);

    цел resultCount;
    Status status = GdipPathIterCopyData(nativeIter_, resultCount, points.ptr, типы.ptr, startIndex, endIndex);
    if (status != Status.ОК)
      throw statusException(status);
    return resultCount;
  }

  /**
   */
  цел счёт() {
    цел рез;
    Status status = GdipPathIterGetCount(nativeIter_, рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез;
  }

  /**
   */
  цел subpathCount() {
    цел рез;
    Status status = GdipPathIterGetSubpathCount(nativeIter_, рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез;
  }

  /**
   */
  бул hasCurve() {
    цел рез;
    Status status = GdipPathIterHasCurve(nativeIter_, рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез != 0;
  }

}

/**
 */
final class Регион {

  private Укз nativeRegion_;

  /**
   */
  this() {
    Status status = GdipCreateRegion(nativeRegion_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(ПрямП прям) {
    Status status = GdipCreateRegionRect(прям, nativeRegion_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Прям прям) {
    Status status = GdipCreateRegionRectI(прям, nativeRegion_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(Path путь) {
    if (путь is null)
      throw new ИсклНулевогоАргумента("путь");

    Status status = GdipCreateRegionPath(путь.nativePath_, nativeRegion_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  ~this() {
    dispose();
  }

  /**
   */
  проц dispose() {
    if (nativeRegion_ != Укз.init) {
      GdipDeleteRegionSafe(nativeRegion_);
      nativeRegion_ = Укз.init;
    }
  }

  /**
   */
  static Регион fromHrgn(Укз hrgn) {
    Укз region;
    Status status = GdipCreateRegionHrgn(hrgn, region);
    if (status != Status.ОК)
      throw statusException(status);
    return new Регион(region);
  }

  /**
   */
  проц makeInfinite() {
    Status status = GdipSetInfinite(nativeRegion_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц makeEmpty() {
    Status status = GdipSetEmpty(nativeRegion_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц пересечение(ПрямП прям) {
    Status status = GdipCombineRegionRect(nativeRegion_, прям, CombineMode.Intersect);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц пересечение(Прям прям) {
    Status status = GdipCombineRegionRectI(nativeRegion_, прям, CombineMode.Intersect);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц пересечение(Path путь) {
    if (путь is null)
      throw new ИсклНулевогоАргумента("путь");

    Status status = GdipCombineRegionPath(nativeRegion_, путь.nativePath_, CombineMode.Intersect);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц пересечение(Регион region) {
    if (region is null)
      throw new ИсклНулевогоАргумента("region");

    Status status = GdipCombineRegionRegion(nativeRegion_, region.nativeRegion_, CombineMode.Intersect);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц unionWith(ПрямП прям) {
    Status status = GdipCombineRegionRect(nativeRegion_, прям, CombineMode.Союз);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц unionWith(Прям прям) {
    Status status = GdipCombineRegionRectI(nativeRegion_, прям, CombineMode.Союз);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц unionWith(Path путь) {
    if (путь is null)
      throw new ИсклНулевогоАргумента("путь");

    Status status = GdipCombineRegionPath(nativeRegion_, путь.nativePath_, CombineMode.Союз);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц unionWith(Регион region) {
    if (region is null)
      throw new ИсклНулевогоАргумента("region");

    Status status = GdipCombineRegionRegion(nativeRegion_, region.nativeRegion_, CombineMode.Союз);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц xor(ПрямП прям) {
    Status status = GdipCombineRegionRect(nativeRegion_, прям, CombineMode.Xor);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц xor(Прям прям) {
    Status status = GdipCombineRegionRectI(nativeRegion_, прям, CombineMode.Xor);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц xor(Path путь) {
    if (путь is null)
      throw new ИсклНулевогоАргумента("путь");

    Status status = GdipCombineRegionPath(nativeRegion_, путь.nativePath_, CombineMode.Xor);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц xor(Регион region) {
    if (region is null)
      throw new ИсклНулевогоАргумента("region");

    Status status = GdipCombineRegionRegion(nativeRegion_, region.nativeRegion_, CombineMode.Xor);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц exclude(ПрямП прям) {
    Status status = GdipCombineRegionRect(nativeRegion_, прям, CombineMode.Exclude);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц exclude(Прям прям) {
    Status status = GdipCombineRegionRectI(nativeRegion_, прям, CombineMode.Exclude);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц exclude(Path путь) {
    if (путь is null)
      throw new ИсклНулевогоАргумента("путь");

    Status status = GdipCombineRegionPath(nativeRegion_, путь.nativePath_, CombineMode.Exclude);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц exclude(Регион region) {
    if (region is null)
      throw new ИсклНулевогоАргумента("region");

    Status status = GdipCombineRegionRegion(nativeRegion_, region.nativeRegion_, CombineMode.Exclude);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц complement(ПрямП прям) {
    Status status = GdipCombineRegionRect(nativeRegion_, прям, CombineMode.Complement);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц complement(Прям прям) {
    Status status = GdipCombineRegionRectI(nativeRegion_, прям, CombineMode.Complement);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц complement(Path путь) {
    if (путь is null)
      throw new ИсклНулевогоАргумента("путь");

    Status status = GdipCombineRegionPath(nativeRegion_, путь.nativePath_, CombineMode.Complement);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц complement(Регион region) {
    if (region is null)
      throw new ИсклНулевогоАргумента("region");

    Status status = GdipCombineRegionRegion(nativeRegion_, region.nativeRegion_, CombineMode.Complement);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц translate(плав dx, плав dy) {
    Status status = GdipTranslateRegion(nativeRegion_, dx, dy);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц translate(цел dx, цел dy) {
    Status status = GdipTranslateRegionI(nativeRegion_, dx, dy);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц transform(Matrix matrix) {
    if (matrix is null)
      throw new ИсклНулевогоАргумента("matrix");

    Status status = GdipTransformRegion(nativeRegion_, matrix.nativeMatrix_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  ПрямП getBounds(Graphics g) {
    if (g is null)
      throw new ИсклНулевогоАргумента("g");

    ПрямП прям;
    Status status = GdipGetRegionBounds(nativeRegion_, g.nativeGraphics_, прям);
    if (status != Status.ОК)
      throw statusException(status);
    return прям;
  }

  /**
   */
  Укз getHrgn(Graphics g) {
    if (g is null)
      throw new ИсклНулевогоАргумента("g");

    Укз hrgn;
    Status status = GdipGetRegionHRgn(nativeRegion_, g.nativeGraphics_, hrgn);
    if (status != Status.ОК)
      throw statusException(status);
    return hrgn;
  }

  /**
   */
  бул пуст_ли(Graphics g) {
    if (g is null)
      throw new ИсклНулевогоАргумента("g");

    цел рез;
    Status status = GdipIsEmptyRegion(nativeRegion_, g.nativeGraphics_, рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез != 0;
  }

  /**
   */
  бул isInfinite(Graphics g) {
    if (g is null)
      throw new ИсклНулевогоАргумента("g");

    цел рез;
    Status status = GdipIsInfiniteRegion(nativeRegion_, g.nativeGraphics_, рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез != 0;
  }

  /**
   */
  бул равен(Регион region, Graphics g) {
    if (g is null)
      throw new ИсклНулевогоАргумента("g");
    if (region is null)
      throw new ИсклНулевогоАргумента("region");

    цел рез;
    Status status = GdipIsEqualRegion(nativeRegion_, region.nativeRegion_, g.nativeGraphics_, рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез != 0;
  }

  /**
   */
  бул isVisible(ТочкаП point, Graphics g = null) {
    цел рез;
    Status status = GdipIsVisibleRegionPoint(nativeRegion_, point.x, point.y, (g is null ? Укз.init : g.nativeGraphics_), рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез != 0;
  }

  /**
   */
  бул isVisible(плав x, плав y, Graphics g = null) {
    return isVisible(ТочкаП(x, y), g);
  }

  /**
   */
  бул isVisible(ПрямП прям, Graphics g = null) {
    цел рез;
    Status status = GdipIsVisibleRegionRect(nativeRegion_, прям.x, прям.y, прям.ширина, прям.высота, (g is null ? Укз.init : g.nativeGraphics_), рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез != 0;
  }

  /**
   */
  бул isVisible(плав x, плав y, плав ширина, плав высота, Graphics g = null) {
    return isVisible(ПрямП(x, y, ширина, высота), g);
  }

  /**
   */
  бул isVisible(Точка point, Graphics g = null) {
    цел рез;
    Status status = GdipIsVisibleRegionPointI(nativeRegion_, point.x, point.y, (g is null ? Укз.init : g.nativeGraphics_), рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез != 0;
  }

  /**
   */
  бул isVisible(цел x, цел y, Graphics g = null) {
    return isVisible(Точка(x, y), g);
  }

  /**
   */
  бул isVisible(Прям прям, Graphics g = null) {
    цел рез;
    Status status = GdipIsVisibleRegionRectI(nativeRegion_, прям.x, прям.y, прям.ширина, прям.высота, (g is null ? Укз.init : g.nativeGraphics_), рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез != 0;
  }

  /**
   */
  бул isVisible(цел x, цел y, цел ширина, цел высота, Graphics g = null) {
    return isVisible(Прям(x, y, ширина, высота), g);
  }

  /**
   */
  ПрямП[] getRegionScans(Matrix matrix) {
    if (matrix is null)
      throw new ИсклНулевогоАргумента("matrix");

    цел счёт;
    Status status = GdipGetRegionScansCount(nativeRegion_, счёт, matrix.nativeMatrix_);
    if (status != Status.ОК)
      throw statusException(status);

    ПрямП[] rects = new ПрямП[счёт];

    status = GdipGetRegionScans(nativeRegion_, rects.ptr, счёт, matrix.nativeMatrix_);
    if (status != Status.ОК)
      throw statusException(status);

    return rects[0 .. счёт];
  }

  private this(Укз nativeRegion) {
    nativeRegion_ = nativeRegion;
  }

}

/** 
 */
abstract class FontCollection : ИВымещаемый {

  private Укз nativeFontCollection_;

  private this() {
  }

  ~this() {
    dispose(false);
  }

  /**
   */
  final проц dispose() {
    dispose(true);
  }

  /**
   */
  protected проц dispose(бул disposing) {
  }

  /**
   */
  final FontFamily[] families() {
    цел numSought;
    Status status = GdipGetFontCollectionFamilyCount(nativeFontCollection_, numSought);
    if (status != Status.ОК)
      throw statusException(status);

    auto gpfamilies = new Укз[numSought];

    цел numFound;
    status = GdipGetFontCollectionFamilyList(nativeFontCollection_, numSought, gpfamilies.ptr, numFound);
    if (status != Status.ОК)
      throw statusException(status);

    auto families = new FontFamily[numFound];
    for (auto i = 0; i < numFound; i++) {
      Укз семейство;
      GdipCloneFontFamily(gpfamilies[i], семейство);
      families[i] = new FontFamily(семейство);
    }

    return families;
  }

}

/**
 */
final class InstalledFontCollection : FontCollection {

  this() {
    Status status = GdipNewInstalledFontCollection(nativeFontCollection_);
    if (status != Status.ОК)
      throw statusException(status);
  }

}

/**
 */
final class PrivateFontCollection : FontCollection {

  this() {
    Status status = GdipNewPrivateFontCollection(nativeFontCollection_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  alias FontCollection.dispose dispose;
  protected override проц dispose(бул disposing) {
    if (nativeFontCollection_ != Укз.init) {
      GdipDeletePrivateFontCollectionSafe(nativeFontCollection_);
      nativeFontCollection_ = Укз.init;
    }
    super.dispose(disposing);
  }

  /**
   */
  проц addFontFile(ткст имяф) {
    Status status = GdipPrivateAddFontFile(nativeFontCollection_, имяф.вУтф16н());
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  проц addMemoryFont(Укз memory, цел length) {
    Status status = GdipPrivateAddMemoryFont(nativeFontCollection_, memory, length);
    if (status != Status.ОК)
      throw statusException(status);
  }

}

/**
 */
final class FontFamily : ИВымещаемый {

  private Укз nativeFamily_;
  private бул createDefaultOnFail_;

  private this(Укз семейство) {
    nativeFamily_ = семейство;
  }

  /**
   */
  this(GenericFontFamilies genericFamily) {
    Status status;

    if (genericFamily == GenericFontFamilies.Serif)
      status = GdipGetGenericFontFamilySerif(nativeFamily_);
    else if (genericFamily == GenericFontFamilies.SansSerif)
      status = GdipGetGenericFontFamilySansSerif(nativeFamily_);
    else if (genericFamily == GenericFontFamilies.Monospace)
      status = GdipGetGenericFontFamilyMonospace(nativeFamily_);
    
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  this(ткст имя, FontCollection fontCollection = null) {
    Status status = GdipCreateFontFamilyFromName(имя.вУтф16н(), (fontCollection is null) ? Укз.init : fontCollection.nativeFontCollection_, nativeFamily_);
    if (status != Status.ОК) {
      if (createDefaultOnFail_) {
        status = GdipGetGenericFontFamilySansSerif(nativeFamily_);
        if (status != Status.ОК)
          throw statusException(status);
      }
      else {
        throw statusException(status);
      }
    }
  }

  /**
   */
  private this(ткст имя, бул createDefaultOnFail) {
    createDefaultOnFail_ = createDefaultOnFail;
    this(имя);
  }

  ~this() {
    dispose();
  }

  /**
   */
  final проц dispose() {
    if (nativeFamily_ != Укз.init) {
      GdipDeleteFontFamilySafe(nativeFamily_);
      nativeFamily_ = Укз.init;
    }
  }

  бул равен(Объект объ) {
    if (this is объ)
      return true;
    if (auto другой = cast(FontFamily)объ)
      return другой.nativeFamily_ == nativeFamily_;
    return false;
  }

  /**
   */
  бул isStyleAvailable(FontStyle style) {
    цел рез;
    Status status = GdipIsStyleAvailable(nativeFamily_, style, рез);
    if (status != Status.ОК)
      throw statusException(status);
    return рез == 1;
  }


  /**
   */
  крат getEmHeight(FontStyle style) {
    крат emHeight;
    Status status = GdipGetEmHeight(nativeFamily_, style, emHeight);
    if (status != Status.ОК)
      throw statusException(status);
    return emHeight;
  }

  /**
   */
  крат getCellAscent(FontStyle style) {
    крат cellAcscent;
    Status status = GdipGetCellAscent(nativeFamily_, style, cellAcscent);
    if (status != Status.ОК)
      throw statusException(status);
    return cellAcscent;
  }

  /**
   */
  крат getCellDescent(FontStyle style) {
    крат cellDescent;
    Status status = GdipGetCellDescent(nativeFamily_, style, cellDescent);
    if (status != Status.ОК)
      throw statusException(status);
    return cellDescent;
  }

  /**
   */
  крат getLineSpacing(FontStyle style) {
    крат lineSpacing;
    Status status = GdipGetLineSpacing(nativeFamily_, style, lineSpacing);
    if (status != Status.ОК)
      throw statusException(status);
    return lineSpacing;
  }

  /**
   */
  ткст getName(цел язык) {
    шим[32] буфер;
    Status status = GdipGetFamilyName(nativeFamily_, буфер.ptr, язык);
    if (status != Status.ОК)
      throw statusException(status);
    return вУтф8(буфер.ptr);
  }

  /**
   */
  ткст имя() {
    return getName(0);
  }

  /**
   */
  static FontFamily genericSerif() {
    return new FontFamily(GenericFontFamilies.Serif);
  }

  /**
   */
  static FontFamily genericSansSerif() {
    return new FontFamily(GenericFontFamilies.SansSerif);
  }

  /**
   */
  static FontFamily genericMonospace() {
    return new FontFamily(GenericFontFamilies.Monospace);
  }

}

/**
 */
final class Font : ИВымещаемый {

  private Укз nativeFont_;
  private плав размер_;
  private FontStyle style_;
  private GraphicsUnit unit_;
  private FontFamily fontFamily_;

  private this(Укз nativeFont) {
    nativeFont_ = nativeFont;

    плав размер;
    Status status = GdipGetFontSize(nativeFont, размер);
    if (status != Status.ОК)
      throw statusException(status);

    FontStyle style;
    status = GdipGetFontStyle(nativeFont, style);
    if (status != Status.ОК)
      throw statusException(status);

    GraphicsUnit unit;
    status = GdipGetFontUnit(nativeFont, unit);
    if (status != Status.ОК)
      throw statusException(status);

    Укз семейство;
    status = GdipGetFamily(nativeFont, семейство);
    if (status != Status.ОК)
      throw statusException(status);

    fontFamily_ = new FontFamily(семейство);

    this(fontFamily_, размер, style, unit);
  }

  /**
   */
  this(Font prototype, FontStyle newStyle) {
    this(prototype.fontFamily, prototype.размер, newStyle, prototype.unit);
  }

  /**
   */
  this(ткст familyName, плав emSize, GraphicsUnit unit) {
    this(familyName, emSize, FontStyle.Regular, unit);
  }

  /**
   */
  this(FontFamily семейство, плав emSize, GraphicsUnit unit) {
    this(семейство, emSize, FontStyle.Regular, unit);
  }

  /**
   */
  this(ткст familyName, плав emSize, FontStyle style = FontStyle.Regular, GraphicsUnit unit = GraphicsUnit.Точка) {

    ткст stripVerticalName(ткст имя) {
      if (имя.length > 1 && имя[0] == '@')
        return имя[1 .. $];
      return имя;
    }

    fontFamily_ = new FontFamily(stripVerticalName(familyName), true);
    this(fontFamily_, emSize, style, unit);
  }

  /**
   */
  this(FontFamily семейство, плав emSize, FontStyle style = FontStyle.Regular, GraphicsUnit unit = GraphicsUnit.Точка) {
    if (семейство is null)
      throw new ИсклНулевогоАргумента("семейство");

    размер_ = emSize;
    style_ = style;
    unit_ = unit;
    if (fontFamily_ is null)
      fontFamily_ = new FontFamily(семейство.nativeFamily_);

    Status status = GdipCreateFont(fontFamily_.nativeFamily_, размер_, style_, unit_, nativeFont_);
    if (status != Status.ОК)
      throw statusException(status);
  }

  ~this() {
    dispose();
  }

  /**
   */
  final проц dispose() {
    if (nativeFont_ != Укз.init) {
      GdipDeleteFontSafe(nativeFont_);
      nativeFont_ = Укз.init;
    }
  }

  бул равен(Объект объ) {
    if (this is объ)
      return true;
    if (auto другой = cast(Font)объ)
      return другой.fontFamily_.равен(fontFamily_) 
      && другой.style_ == style_ 
      && другой.размер_ == размер_ 
      && другой.unit_ == unit_;
    return false;
  }

  /**
   */
  плав getHeight() {
    Укз hdc = GetDC(Укз.init);
    try {
      scope g = Graphics.fromHdc(hdc);
      return getHeight(g);
    }
    finally {
      ReleaseDC(Укз.init, hdc);
    }
  }

  /**
   */
  плав getHeight(Graphics graphics) {
    плав высота = 0;
    Status status = GdipGetFontHeight(nativeFont_, graphics.nativeGraphics_, высота);
    if (status != Status.ОК)
      throw statusException(status);
    return высота;
  }

  /**
   */
  static Font fromHdc(Укз hdc) {
    Укз font;
    Status status = GdipCreateFontFromDC(hdc, font);
    if (status != Status.ОК)
      throw statusException(status);
    return new Font(font);
  }

  /**
   */
  static Font fromHfont(Укз hfont) {
    LOGFONT lf;
    GetObject(hfont, LOGFONT.sizeof, &lf);

    Укз hdc = GetDC(Укз.init);
    scope(exit) ReleaseDC(Укз.init, hdc);

    return fromLogFont(lf, hdc);
  }

  /**
   */
  static Font fromLogFont(ref LOGFONT logFont) {
    Укз hdc = GetDC(Укз.init);
    scope(exit) ReleaseDC(Укз.init, hdc);

    return fromLogFont(logFont, hdc);
  }

  /**
   */
  static Font fromLogFont(ref LOGFONT logFont, Укз hdc) {
    Укз nativeFont;
    Status status = GdipCreateFontFromLogfontW(hdc, logFont, nativeFont);
    if (status != Status.ОК)
      throw statusException(status);
    return new Font(nativeFont);
  }

  /**
   */
  Укз toHfont() {
    LOGFONT lf;
    toLogFont(lf);
    return CreateFontIndirect(lf);
  }

  /**
   */
  проц toLogFont(out LOGFONT logFont) {
    Укз hdc = GetDC(Укз.init);
    try {
      scope g = Graphics.fromHdc(hdc);
      toLogFont(logFont, g);
    }
    finally {
      ReleaseDC(Укз.init, hdc);
    }
  }

  /**
   */
  проц toLogFont(out LOGFONT logFont, Graphics graphics) {
    Status status = GdipGetLogFontW(nativeFont_, graphics.nativeGraphics_, logFont);
    if (status != Status.ОК)
      throw statusException(status);
  }

  /**
   */
  FontFamily fontFamily() {
    return fontFamily_;
  }

  /**
   */
  плав размер() {
    return размер_;
  }

  /**
   */
  плав sizeInPoints() {
    if (unit == GraphicsUnit.Точка)
      return размер;

    Укз hdc = GetDC(Укз.init);
    scope(exit) ReleaseDC(Укз.init, hdc);

    scope g = Graphics.fromHdc(hdc);
    плав pixelsPerPoint = g.dpiY / 72.0;
    плав lineSpacing = getHeight(g);
    плав emHeight = lineSpacing * fontFamily.getEmHeight(style) / fontFamily.getLineSpacing(style);

    return emHeight / pixelsPerPoint;
  }

  /**
   */
  FontStyle style() {
    return style_;
  }

  /**
   */
  GraphicsUnit unit() {
    return unit_;
  }

  /**
   */
  цел высота() {
    return cast(цел)потолок(getHeight());
  }

  /**
   */
  ткст имя() {
    return fontFamily.имя;
  }

  /**
   */
  бул bold() {
    return (style & FontStyle.Bold) != 0;
  }

  /**
   */
  бул italic() {
    return (style & FontStyle.Italic) != 0;
  }

  /**
   */
  бул underline() {
    return (style & FontStyle.Underline) != 0;
  }

  /**
   */
  бул strikeout() {
    return (style & FontStyle.Strikeout) != 0;
  }

}