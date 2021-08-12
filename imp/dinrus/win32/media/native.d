/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module win32.media.native;

import win32.base.core,
  win32.com.core,
  win32.media.consts,
  win32.media.geometry, exception;
version(D_Version2) {
  import core.memory;
}
else {
 //import exception: OutOfMemoryException;
  static import gc;
}

//pragma(lib, "user32.lib");
//pragma(lib, "gdi32.lib");
//pragma(lib, "gdiplus.lib");
pragma(lib, "rulada.lib");

static this() {
  startup();
}

static ~this() {
  shutdown();
}

extern(Windows):

// GDI32

enum {
  COLOR_SCROLLBAR               = 0,
  COLOR_BACKGROUND              = 1,
  COLOR_ACTIVECAPTION           = 2,
  COLOR_INACTIVECAPTION         = 3,
  COLOR_MENU                    = 4,
  COLOR_WINDOW                  = 5,
  COLOR_WINDOWFRAME             = 6,
  COLOR_MENUTEXT                = 7,
  COLOR_WINDOWTEXT              = 8,
  COLOR_CAPTIONTEXT             = 9,
  COLOR_ACTIVEBORDER            = 10,
  COLOR_INACTIVEBORDER          = 11,
  COLOR_APPWORKSPACE            = 12,
  COLOR_HIGHLIGHT               = 13,
  COLOR_HIGHLIGHTTEXT           = 14,
  COLOR_BTNFACE                 = 15,
  COLOR_BTNSHADOW               = 16,
  COLOR_GRAYTEXT                = 17,
  COLOR_BTNTEXT                 = 18,
  COLOR_INACTIVECAPTIONTEXT     = 19,
  COLOR_BTNHIGHLIGHT            = 20,
  COLOR_3DDKSHADOW              = 21,
  COLOR_3DLIGHT                 = 22,
  COLOR_INFOTEXT                = 23,
  COLOR_INFOBK                  = 24,
  COLOR_HOTLIGHT                = 26,
  COLOR_GRADIENTACTIVECAPTION   = 27,
  COLOR_GRADIENTINACTIVECAPTION = 28,
  COLOR_MENUHILIGHT             = 29,
  COLOR_MENUBAR                 = 30,
  COLOR_DESKTOP                 = COLOR_BACKGROUND,
  COLOR_3DFACE                  = COLOR_BTNFACE,
  COLOR_3DSHADOW                = COLOR_BTNSHADOW,
  COLOR_3DHIGHLIGHT             = COLOR_BTNHIGHLIGHT,
  COLOR_3DHILIGHT               = COLOR_BTNHIGHLIGHT,
  COLOR_BTNHILIGHT              = COLOR_BTNHIGHLIGHT
}

бцел GetSysColor(цел nIndex);

struct LOGFONTW {
  цел lfHeight;
  цел lfWidth;
  цел lfEscapement;
  цел lfOrientation;
  цел lfWeight;
  ббайт lfItalic;
  ббайт lfUnderline;
  ббайт lfStrikeOut;
  ббайт lfCharSet;
  ббайт lfOutPrecision;
  ббайт lfClipPrecision;
  ббайт lfQuality;
  ббайт lfPitchAndFamily;
  шим[32] lfFaceName;
}
alias LOGFONTW LOGFONT;

Укз CreateFontIndirectW(ref LOGFONTW lplf);
Укз CreateFontIndirectW(LOGFONTW* lplf);
alias CreateFontIndirectW CreateFontIndirect;

Укз GetDC(Укз hWnd);

цел ReleaseDC(Укз hWnd, Укз hDC);

Укз SelectObject(Укз hdc, Укз hObject);

цел DeleteObject(Укз hObject);

цел GetObjectW(Укз h, цел c, ук pv);
alias GetObjectW GetObject;

// GDI+

alias цел function(ук) GpDrawImageAbort;
alias GpDrawImageAbort GpGetThumbnailImageAbort;

enum DebugEventLevel {
  Fatal,
  Warning
}

enum Status {
  ОК,
  GenericError,
  InvalidParameter,
  OutOfMemory,
  ObjectBusy,
  InsufficientBuffer,
  NotImplemented,
  Win32Error,
  WrongState,
  Aborted,
  FileNotFound,
  ValueOverflow,
  AccessDenied,
  UnknownImageFormat,
  FontFamilyNotFound,
  FontStyleNotFound,
  NotTrueTypeFont,
  UnsupportedGdiplusVersion,
  GdiplusNotInitialized,
  PropertyNotFound,
  PropertyNotSupported
}

alias проц function(DebugEventLevel уровень, сим* сообщение) DebugEventProc;

alias Status function(out бцел token) NotificationHookProc;
alias проц function(бцел token) NotificationUnhookProc;

struct GdiplusStartupInput {
  бцел GdiplusVersion = 1;
  DebugEventProc DebugEventCallback;
  цел SuppressBackgroundThread;
  цел SuppressExternalCodecs;
}

struct GdiplusStartupOutput {
  NotificationHookProc NotificationHook;
  NotificationUnhookProc NotificationUnhook;
}

Status GdiplusStartup(out бцел token, ref GdiplusStartupInput ввод, out GdiplusStartupOutput вывод);
проц GdiplusShutdown(бцел token);

struct GpImageCodecInfo {
  GUID Clsid;
  GUID FormatID;
  шим* CodecName;
  шим* DllName;
  шим* FormatDescription;
  шим* FilenameExtension;
  шим* MimeType;
  бцел Flags;
  бцел Версия;
  бцел SigCount;
  бцел SigSize;
  ббайт* SigPattern;
  ббайт* SigMask;
}

struct GpBitmapData {
  цел Width;
  цел Height;
  цел Stride;
  win32.media.consts.PixelFormat PixelFormat;
  ук Scan0;
  цел Reserved;
}

struct GdipWmfPlaceableFileHeader {
  бцел Key;
  крат Hmf;
  крат BoundingBoxLeft;
  крат BoundingBoxTop;
  крат BoundingBoxRight;
  крат BoundingBoxBottom;
  крат Inch;
  бцел Reserved;
  крат Checksum;
}

struct GpColorMatrix {
  плав[5][5] m;
}

struct GpEncoderParameter {
  GUID Guid;
  цел NumberOfValues;
  цел Тип;
  ук Value;
}

struct GpEncoderParameters {
  цел Count;
  GpEncoderParameter[1] Параметр;
}

struct GpPropertyItem {
  цел ид;
  бцел len;
  бкрат тип;
  ук значение;
}

struct GpColorPalette {
  PaletteFlags Flags;
  бцел Count;
  бцел[1] Entries;
}

Укз GdipCreateHalftonePalette();

Status GdipCreateFromHDC(Укз hdc, out Укз graphics);
Status GdipCreateFromHDC2(Укз hdc, Укз hDevice, out Укз graphics);
Status GdipCreateFromHWND(Укз hwnd, out Укз graphics);
Status GdipGetImageGraphicsContext(Укз image, out Укз graphics);
Status GdipDeleteGraphics(Укз graphics);
Status GdipGetDC(Укз graphics, out Укз hdc);
Status GdipReleaseDC(Укз graphics, Укз hdc);
Status GdipSetClipGraphics(Укз graphics, Укз srcgraphics, CombineMode combineMode);
Status GdipSetClipRectI(Укз graphics, цел x, цел y, цел ширина, цел высота, CombineMode combineMode);
Status GdipSetClipRect(Укз graphics, плав x, плав y, плав ширина, плав высота, CombineMode combineMode);
Status GdipSetClipPath(Укз graphics, Укз путь, CombineMode combineMode);
Status GdipSetClipRegion(Укз graphics, Укз region, CombineMode combineMode);
Status GdipGetClip(Укз graphics, out Укз region);
Status GdipResetClip(Укз graphics);
Status GdipTranslateClip(Укз graphics, плав dx, плав dy);
Status GdipSaveGraphics(Укз graphics, out цел state);
Status GdipRestoreGraphics(Укз graphics, цел state);
Status GdipFlush(Укз graphics, FlushIntention intention);
Status GdipScaleWorldTransform(Укз graphics, плав sx, плав sy, MatrixOrder order);
Status GdipRotateWorldTransform(Укз graphics, плав angle, MatrixOrder order);
Status GdipTranslateWorldTransform(Укз graphics, плав dx, плав dy, MatrixOrder order);
Status GdipMultiplyWorldTransform(Укз graphics, Укз matrix, MatrixOrder order);
Status GdipResetWorldTransform(Укз graphics);
Status GdipBeginContainer(Укз graphics, ref ПрямП dstrect, ref ПрямП srcrect, GraphicsUnit unit, out цел state);
Status GdipBeginContainerI(Укз graphics, ref Прям dstrect, ref Прям srcrect, GraphicsUnit unit, out цел state);
Status GdipBeginContainer2(Укз graphics, out цел state);
Status GdipEndContainer(Укз graphics, цел state);
Status GdipGetDpiX(Укз graphics, out плав dpi);
Status GdipGetDpiY(Укз graphics, out плав dpi);
Status GdipGetPageUnit(Укз graphics, out GraphicsUnit unit);
Status GdipSetPageUnit(Укз graphics, GraphicsUnit unit);
Status GdipGetPageScale(Укз graphics, out плав шкала);
Status GdipSetPageScale(Укз graphics, плав шкала);
Status GdipGetWorldTransform(Укз graphics, out Укз matrix);
Status GdipSetWorldTransform(Укз graphics, Укз matrix);
Status GdipGetCompositingMode(Укз graphics, out CompositingMode compositingMode);
Status GdipSetCompositingMode(Укз graphics, CompositingMode compositingMode);
Status GdipGetCompositingQuality(Укз graphics, out CompositingQuality compositingQuality);
Status GdipSetCompositingQuality(Укз graphics, CompositingQuality compositingQuality);
Status GdipGetInterpolationMode(Укз graphics, out InterpolationMode interpolationMode);
Status GdipSetInterpolationMode(Укз graphics, InterpolationMode interpolationMode);
Status GdipGetSmoothingMode(Укз graphics, out SmoothingMode smoothingMode);
Status GdipSetSmoothingMode(Укз graphics, SmoothingMode smoothingMode);
Status GdipGetPixelOffsetMode(Укз graphics, out PixelOffsetMode pixelOffsetMode);
Status GdipSetPixelOffsetMode(Укз graphics, PixelOffsetMode pixelOffsetMode);
Status GdipGetTextContrast(Укз graphics, out бцел textContrast);
Status GdipSetTextContrast(Укз graphics, бцел textContrast);
Status GdipGraphicsClear(Укз graphics, цел цвет);
Status GdipDrawLine(Укз graphics, Укз pen, плав x1, плав y1, плав x2, плав y2);
Status GdipDrawLines(Укз graphics, Укз pen, ТочкаП* points, цел счёт);
Status GdipDrawLineI(Укз graphics, Укз pen, цел x1, цел y1, цел x2, цел y2);
Status GdipDrawLinesI(Укз graphics, Укз pen, Точка* points, цел счёт);
Status GdipDrawArc(Укз graphics, Укз pen, плав x, плав y, плав ширина, плав высота, плав startAngle, плав sweepAngle);
Status GdipDrawArcI(Укз graphics, Укз pen, цел x, цел y, цел ширина, цел высота, плав startAngle, плав sweepAngle);
Status GdipDrawBezier(Укз graphics, Укз pen, плав x1, плав y1, плав x2, плав y2, плав x3, плав y3, плав x4, плав y4);
Status GdipDrawBeziers(Укз graphics, Укз pen, ТочкаП* points, цел счёт);
Status GdipDrawBezierI(Укз graphics, Укз pen, цел x1, цел y1, цел x2, цел y2, цел x3, цел y3, цел x4, цел y4);
Status GdipDrawBeziersI(Укз graphics, Укз pen, Точка* points, цел счёт);
Status GdipDrawRectangle(Укз graphics, Укз pen, плав x, плав y, плав ширина, плав высота);
Status GdipDrawRectangles(Укз graphics, Укз pen, ПрямП* rects, цел счёт);
Status GdipDrawRectangleI(Укз graphics, Укз pen, цел x, цел y, цел ширина, цел высота);
Status GdipDrawRectanglesI(Укз graphics, Укз pen, Прям* rects, цел счёт);
Status GdipDrawEllipse(Укз graphics, Укз pen, плав x, плав y, плав ширина, плав высота);
Status GdipDrawEllipseI(Укз graphics, Укз pen, цел x, цел y, цел ширина, цел высота);
Status GdipDrawPie(Укз graphics, Укз pen, плав x, плав y, плав ширина, плав высота, плав startAngle, плав sweepAngle);
Status GdipDrawPieI(Укз graphics, Укз pen, цел x, цел y, цел ширина, цел высота, плав startAngle, плав sweepAngle);
Status GdipDrawPolygon(Укз graphics, Укз pen, ТочкаП* points, цел счёт);
Status GdipDrawPolygonI(Укз graphics, Укз pen, Точка* points, цел счёт);
Status GdipDrawCurve(Укз graphics, Укз pen, ТочкаП* points, цел счёт);
Status GdipDrawCurve2(Укз graphics, Укз pen, ТочкаП* points, цел счёт, плав tension);
Status GdipDrawCurve3(Укз graphics, Укз pen, ТочкаП* points, цел счёт, цел смещение, цел numberOfSegments, плав tension);
Status GdipDrawCurveI(Укз graphics, Укз pen, Точка* points, цел счёт);
Status GdipDrawCurve2I(Укз graphics, Укз pen, Точка* points, цел счёт, плав tension);
Status GdipDrawCurve3I(Укз graphics, Укз pen, Точка* points, цел счёт, цел смещение, цел numberOfSegments, плав tension);
Status GdipDrawClosedCurve(Укз graphics, Укз pen, ТочкаП* points, цел счёт);
Status GdipDrawClosedCurve2(Укз graphics, Укз pen, ТочкаП* points, цел счёт, плав tension);
Status GdipDrawClosedCurveI(Укз graphics, Укз pen, Точка* points, цел счёт);
Status GdipDrawClosedCurve2I(Укз graphics, Укз pen, Точка* points, цел счёт, плав tension);
Status GdipDrawPath(Укз graphics, Укз pen, Укз путь);
Status GdipFillRectangleI(Укз graphics, Укз brush, цел x, цел y, цел ширина, цел высота);
Status GdipFillRectangle(Укз graphics, Укз brush, плав x, плав y, плав ширина, плав высота);
Status GdipFillRectanglesI(Укз graphics, Укз brush, Прям* rects, цел счёт);
Status GdipFillRectangles(Укз graphics, Укз brush, ПрямП* rects, цел счёт);
Status GdipFillPolygon(Укз graphics, Укз brush, ТочкаП* rects, цел счёт, FillMode fillMode);
Status GdipFillPolygonI(Укз graphics, Укз brush, Точка* rects, цел счёт, FillMode fillMode);
Status GdipFillEllipse(Укз graphics, Укз brush, плав x, плав y, плав ширина, плав высота);
Status GdipFillEllipseI(Укз graphics, Укз brush, цел x, цел y, цел ширина, цел высота);
Status GdipFillPie(Укз graphics, Укз brush, плав x, плав y, плав ширина, плав высота, плав startAngle, плав sweepAngle);
Status GdipFillPieI(Укз graphics, Укз brush, цел x, цел y, цел ширина, цел высота, плав startAngle, плав sweepAngle);
Status GdipFillPath(Укз graphics, Укз brush, Укз путь);
Status GdipFillClosedCurve(Укз graphics, Укз brush, ТочкаП* points, цел счёт);
Status GdipFillClosedCurveI(Укз graphics, Укз brush, Точка* points, цел счёт);
Status GdipFillClosedCurve2(Укз graphics, Укз brush, ТочкаП* points, цел счёт, FillMode fillMode, плав tension);
Status GdipFillClosedCurve2I(Укз graphics, Укз brush, Точка* points, цел счёт, FillMode fillMode, плав tension);
Status GdipFillRegion(Укз graphics, Укз brush, Укз region);
Status GdipDrawString(Укз graphics, in шим* ткст, цел length, Укз font, ref ПрямП layoutRect, Укз stringFormat, Укз brush);
Status GdipMeasureString(Укз graphics, in шим* ткст, цел length, Укз font, ref ПрямП layoutRect, Укз stringFormat, ref ПрямП boundingBox, out цел codepointsFitted, out цел linesFilled);
Status GdipMeasureCharacterRanges(Укз graphics, in шим* ткст, цел length, Укз font, ref ПрямП layoutRect, Укз stringFormat, цел regionCount, Укз* regions);
Status GdipDrawImage(Укз graphics, Укз image, плав x, плав y);
Status GdipDrawImageI(Укз graphics, Укз image, цел x, цел y);
Status GdipDrawImageRect(Укз graphics, Укз image, плав x, плав y, плав ширина, плав высота);
Status GdipDrawImageRectI(Укз graphics, Укз image, цел x, цел y, цел ширина, цел высота);
Status GdipDrawImagePointRect(Укз graphics, Укз image, плав x, плав y, плав srcx, плав srcy, плав srcwidth, плав srcheight, GraphicsUnit srcUnit);
Status GdipDrawImagePointRectI(Укз graphics, Укз image, цел x, цел y, цел srcx, цел srcy, цел srcwidth, цел srcheight, GraphicsUnit srcUnit);
Status GdipDrawImageRectRect(Укз graphics, Укз image, плав dstx, плав dsty, плав dstwidth, плав dstheight, плав srcx, плав srcy, плав srcwidth, плав srcheight, GraphicsUnit srcUnit, Укз imageAttributes, GpDrawImageAbort обрвыз, ук callbakcData);
Status GdipDrawImageRectRectI(Укз graphics, Укз image, цел dstx, цел dsty, цел dstwidth, цел dstheight, цел srcx, цел srcy, цел srcwidth, цел srcheight, GraphicsUnit srcUnit, Укз imageAttributes, GpDrawImageAbort обрвыз, ук callbakcData);
Status GdipDrawImagePoints(Укз graphics, Укз image, ТочкаП* dstpoints, цел счёт);
Status GdipDrawImagePointsI(Укз graphics, Укз image, Точка* dstpoints, цел счёт);
Status GdipDrawImagePointsRect(Укз graphics, Укз image, ТочкаП* dstpoints, цел счёт, плав srcx, плав srcy, плав srcwidth, плав srcheight, GraphicsUnit srcUnit, Укз imageAttributes, GpDrawImageAbort обрвыз, ук callbakcData);
Status GdipDrawImagePointsRectI(Укз graphics, Укз image, Точка* dstpoints, цел счёт, цел srcx, цел srcy, цел srcwidth, цел srcheight, GraphicsUnit srcUnit, Укз imageAttributes, GpDrawImageAbort обрвыз, ук callbakcData);
Status GdipIsVisiblePoint(Укз graphics, плав x, плав y, out цел рез);
Status GdipIsVisiblePointI(Укз graphics, цел x, цел y, out цел рез);
Status GdipIsVisibleRect(Укз graphics, плав x, плав y, плав ширина, плав высота, out цел рез);
Status GdipIsVisibleRectI(Укз graphics, цел x, цел y, цел ширина, цел высота, out цел рез);
Status GdipGetTextRenderingHint(Укз graphics, out TextRenderingHint mode);
Status GdipSetTextRenderingHint(Укз graphics, TextRenderingHint mode);
Status GdipGetClipBounds(Укз graphics, out ПрямП прям);
Status GdipGetVisibleClipBounds(Укз graphics, out ПрямП прям);
Status GdipIsClipEmpty(Укз graphics, out цел рез);
Status GdipIsVisibleClipEmpty(Укз graphics, out цел рез);
Status GdipGetRenderingOrigin(Укз graphics, out цел x, out цел y);
Status GdipSetRenderingOrigin(Укз graphics, цел x, цел y);
Status GdipGetNearestColor(Укз graphics, ref бцел argb);
Status GdipComment(Укз graphics, бцел sizeData, ббайт* данные);
Status GdipTransformPoints(Укз graphics, CoordinateSpace destSpace, CoordinateSpace srcSpace, ТочкаП* points, цел счёт);
Status GdipTransformPointsI(Укз graphics, CoordinateSpace destSpace, CoordinateSpace srcSpace, Точка* points, цел счёт);

Status GdipCreateMatrix(out Укз matrix);
Status GdipCreateMatrix2(плав m11, плав m12, плав m21, плав m22, плав dx, плав dy, out Укз matrix);
Status GdipCreateMatrix3(ref ПрямП прям, ТочкаП* dstplg, out Укз matrix);
Status GdipCreateMatrix3I(ref Прям прям, Точка* dstplg, out Укз matrix);
Status GdipDeleteMatrix(Укз matrix);
Status GdipCloneMatrix(Укз matrix, out Укз cloneMatrix);
Status GdipGetMatrixElements(Укз matrix, плав* matrixOut);
Status GdipSetMatrixElements(Укз matrix, плав m11, плав m12, плав m21, плав m22, плав xy, плав dy);
Status GdipInvertMatrix(Укз matrix);
Status GdipMultiplyMatrix(Укз matrix, Укз matrix2, MatrixOrder order);
Status GdipScaleMatrix(Укз matrix, плав scaleX, плав scaleY, MatrixOrder order);
Status GdipShearMatrix(Укз matrix, плав shearX, плав shearY, MatrixOrder order);
Status GdipRotateMatrix(Укз matrix, плав angle, MatrixOrder order);
Status GdipTranslateMatrix(Укз matrix, плав offsetX, плав offsetY, MatrixOrder order);
Status GdipIsMatrixIdentity(Укз matrix, out цел рез);
Status GdipIsMatrixInvertible(Укз matrix, out цел рез);

Status GdipDeleteBrush(Укз brush);
Status GdipCloneBrush(Укз brush, out Укз cloneBrush);

Status GdipCreateSolidFill(бцел цвет, out Укз brush);
Status GdipGetSolidFillColor(Укз brush, out бцел цвет);
Status GdipSetSolidFillColor(Укз brush, бцел цвет);

Status GdipCreateTexture(Укз image, WrapMode wrapMode, out Укз texture);
Status GdipCreateTexture2(Укз image, WrapMode wrapMode, плав x, плав y, плав ширина, плав высота, out Укз texture);
Status GdipCreateTexture2I(Укз image, WrapMode wrapMode, цел x, цел y, цел ширина, цел высота, out Укз texture);
Status GdipCreateTextureIA(Укз image, Укз imageAttributes, плав x, плав y, плав ширина, плав высота, out Укз texture);
Status GdipCreateTextureIAI(Укз image, Укз imageAttributes, цел x, цел y, цел ширина, цел высота, out Укз texture);
Status GdipGetTextureImage(Укз brush, out Укз image);
Status GdipGetTextureTransform(Укз brush, out Укз matrix);
Status GdipSetTextureTransform(Укз brush, Укз matrix);
Status GdipGetTextureWrapMode(Укз brush, out WrapMode wrapmode);
Status GdipSetTextureWrapMode(Укз brush, WrapMode wrapmode);
Status GdipTranslateTextureTransform(Укз brush, плав dx, плав dy, MatrixOrder order);
Status GdipRotateTextureTransform(Укз brush, плав angle, MatrixOrder order);
Status GdipScaleTextureTransform(Укз brush, плав sx, плав sy, MatrixOrder order);
Status GdipMultiplyTextureTransform(Укз brush, Укз matrix, MatrixOrder order);
Status GdipResetTextureTransform(Укз brush);

Status GdipCreateHatchBrush(HatchStyle hatchstyle, бцел forecol, бцел backcol, out Укз brush);
Status GdipGetHatchStyle(Укз brush, out HatchStyle hatchstyle);
Status GdipGetHatchForegroundColor(Укз brush, out бцел forecol);
Status GdipGetHatchBackgroundColor(Укз brush, out бцел backcol);

Status GdipCreateLineBrushI(ref Точка point1, ref Точка point2, бцел color1, бцел color2, WrapMode wrapMode, out Укз lineGradient);
Status GdipCreateLineBrush(ref ТочкаП point1, ref ТочкаП point2, бцел color1, бцел color2, WrapMode wrapMode, out Укз lineGradient);
Status GdipCreateLineBrushFromRectI(ref Прям прям, бцел color1, бцел color2, LinearGradientMode mode, WrapMode wrapMode, out Укз lineGradient);
Status GdipCreateLineBrushFromRect(ref ПрямП прям, бцел color1, бцел color2, LinearGradientMode mode, WrapMode wrapMode, out Укз lineGradient);
Status GdipCreateLineBrushFromRectWithAngleI(ref Прям прям, бцел color1, бцел color2, плав angle, цел isAngleScalable, WrapMode wrapMode, out Укз lineGradient);
Status GdipCreateLineBrushFromRectWithAngle(ref ПрямП прям, бцел color1, бцел color2, плав angle, цел isAngleScalable, WrapMode wrapMode, out Укз lineGradient);
Status GdipGetLineBlendCount(Укз brush, out цел счёт);
Status GdipGetLineBlend(Укз brush, плав* blend, плав* positions, цел счёт);
Status GdipSetLineBlend(Укз brush, плав* blend, плав* positions, цел счёт);
Status GdipGetLinePresetBlendCount(Укз brush, out цел счёт);
Status GdipGetLinePresetBlend(Укз brush, бцел* blend, плав* positions, цел счёт);
Status GdipSetLinePresetBlend(Укз brush, бцел* blend, плав* positions, цел счёт);
Status GdipGetLineWrapMode(Укз brush, out WrapMode wrapmode);
Status GdipSetLineWrapMode(Укз brush, WrapMode wrapmode);
Status GdipGetLineRect(Укз brush, out ПрямП прям);
Status GdipGetLineColors(Укз brush, бцел* цвета);
Status GdipSetLineColors(Укз brush, бцел color1, бцел color2);
Status GdipGetLineGammaCorrection(Укз brush, out цел useGammaCorrection);
Status GdipSetLineGammaCorrection(Укз brush, цел useGammaCorrection);
Status GdipSetLineSigmaBlend(Укз brush, плав focus, плав шкала);
Status GdipSetLineLinearBlend(Укз brush, плав focus, плав шкала);
Status GdipGetLineTransform(Укз brush, out Укз matrix);
Status GdipSetLineTransform(Укз brush, Укз matrix);
Status GdipResetLineTransform(Укз brush);
Status GdipMultiplyLineTransform(Укз brush, Укз matrix, MatrixOrder order);
Status GdipTranslateLineTransform(Укз brush, плав dx, плав dy, MatrixOrder order);
Status GdipScaleLineTransform(Укз brush, плав sx, плав sy, MatrixOrder order);
Status GdipRotateLineTransform(Укз brush, плав angle, MatrixOrder order);

Status GdipCreatePen1(цел argb, плав ширина, GraphicsUnit unit, out Укз pen);
Status GdipCreatePen2(Укз brush, плав ширина, GraphicsUnit unit, out Укз pen);
Status GdipDeletePen(Укз pen);
Status GdipClonePen(Укз pen, out Укз clonepen);
Status GdipSetPenLineCap197819(Укз pen, LineCap startCap, LineCap endCap, DashCap dashCap);
Status GdipGetPenStartCap(Укз pen, out LineCap startCap);
Status GdipSetPenStartCap(Укз pen, LineCap startCap);
Status GdipGetPenEndCap(Укз pen, out LineCap endCap);
Status GdipSetPenEndCap(Укз pen, LineCap endCap);
Status GdipGetPenDashCap197819(Укз pen, out DashCap endCap);
Status GdipSetPenDashCap197819(Укз pen, DashCap endCap);
Status GdipGetPenLineJoin(Укз pen, out LineJoin lineJoin);
Status GdipSetPenLineJoin(Укз pen, LineJoin lineJoin);
Status GdipGetPenMiterLimit(Укз pen, out плав miterLimit);
Status GdipSetPenMiterLimit(Укз pen, плав miterLimit);
Status GdipGetPenMode(Укз pen, out PenAlignment penMode);
Status GdipSetPenMode(Укз pen, PenAlignment penMode);
Status GdipGetPenTransform(Укз pen, out Укз matrix);
Status GdipSetPenTransform(Укз pen, Укз matrix);
Status GdipResetPenTransform(Укз pen);
Status GdipMultiplyPenTransform(Укз pen, Укз matrix, MatrixOrder order);
Status GdipTranslatePenTransform(Укз pen, плав dx, плав dy, MatrixOrder order);
Status GdipScalePenTransform(Укз pen, плав sx, плав sy, MatrixOrder order);
Status GdipRotatePenTransform(Укз pen, плав angle, MatrixOrder order);
Status GdipGetPenColor(Укз pen, out бцел argb);
Status GdipSetPenColor(Укз pen, цел argb);
Status GdipGetPenWidth(Укз pen, out плав ширина);
Status GdipSetPenWidth(Укз pen, плав ширина);
Status GdipGetPenFillType(Укз pen, out PenType тип);
Status GdipGetPenBrushFill(Укз pen, out Укз brush);
Status GdipSetPenBrushFill(Укз pen, Укз brush);
Status GdipGetPenDashStyle(Укз pen, out DashStyle dashstyle);
Status GdipSetPenDashStyle(Укз pen, DashStyle dashstyle);
Status GdipGetPenDashOffset(Укз pen, out плав смещение);
Status GdipSetPenDashOffset(Укз pen, плав смещение);
Status GdipGetPenDashCount(Укз pen, out цел счёт);
Status GdipGetPenDashArray(Укз pen, плав* dash, цел счёт);
Status GdipSetPenDashArray(Укз pen, плав* dash, цел счёт);
Status GdipGetPenCompoundCount(Укз pen, out цел счёт);
Status GdipGetPenCompoundArray(Укз pen, плав* dash, цел счёт);
Status GdipSetPenCompoundArray(Укз pen, плав* dash, цел счёт);

Status GdipCreateRegion(out Укз region);
Status GdipCreateRegionRect(ref ПрямП прям, out Укз region);
Status GdipCreateRegionRectI(ref Прям прям, out Укз region);
Status GdipCreateRegionPath(Укз путь, out Укз region);
Status GdipCreateRegionHrgn(Укз hRgn, out Укз region);
Status GdipDeleteRegion(Укз region);
Status GdipSetInfinite(Укз region);
Status GdipSetEmpty(Укз region);
Status GdipCombineRegionRect(Укз region, ref ПрямП прям, CombineMode combineMode);
Status GdipCombineRegionRectI(Укз region, ref Прям прям, CombineMode combineMode);
Status GdipCombineRegionPath(Укз region, Укз путь, CombineMode combineMode);
Status GdipCombineRegionRegion(Укз region, Укз region, CombineMode combineMode);
Status GdipTranslateRegion(Укз region, плав dx, плав dy);
Status GdipTranslateRegionI(Укз region, цел dx, цел dy);
Status GdipTransformRegion(Укз region, Укз matrix);
Status GdipGetRegionBounds(Укз region, Укз graphics, out ПрямП прям);
Status GdipGetRegionHRgn(Укз region, Укз graphics, out Укз hRgn);
Status GdipIsEmptyRegion(Укз region, Укз graphics, out цел рез);
Status GdipIsInfiniteRegion(Укз region, Укз graphics, out цел рез);
Status GdipIsEqualRegion(Укз region1, Укз region2, Укз graphics, out цел рез);
Status GdipIsVisibleRegionPoint(Укз region, плав x, плав y, Укз graphics, out цел рез);
Status GdipIsVisibleRegionRect(Укз region, плав x, плав y, плав ширина, плав высота, Укз graphics, out цел рез);
Status GdipIsVisibleRegionPointI(Укз region, цел x, цел y, Укз graphics, out цел рез);
Status GdipIsVisibleRegionRectI(Укз region, цел x, цел y, цел ширина, цел высота, Укз graphics, out цел рез);
Status GdipGetRegionScansCount(Укз region, out цел счёт, Укз matrix);
Status GdipGetRegionScans(Укз region, ПрямП* rects, out цел счёт, Укз matrix);

Status GdipCreateImageAttributes(out Укз imageattr);
Status GdipDisposeImageAttributes(Укз imageattr);
Status GdipSetImageAttributesColorMatrix(Укз imageattr, ColorAdjustType тип, цел enableFlag, GpColorMatrix* colorMatrix, GpColorMatrix* grayMatrix, ColorMatrixFlag флаги);
Status GdipSetImageAttributesThreshold(Укз imageattr, ColorAdjustType тип, цел enableFlag, плав threshold);
Status GdipSetImageAttributesGamma(Укз imageattr, ColorAdjustType тип, цел enableFlag, плав gamma);
Status GdipSetImageAttributesNoOp(Укз imageattr, ColorAdjustType тип, цел enableFlag);
Status GdipSetImageAttributesColorKeys(Укз imageattr, ColorAdjustType тип, цел enableFlag, цел colorLow, цел colorHigh);
Status GdipSetImageAttributesOutputChannel(Укз imageattr, ColorAdjustType тип, цел enableFlag, ColorChannelFlag флаги);
Status GdipSetImageAttributesOutputChannelColorProfile(Укз imageattr, ColorAdjustType тип, цел enableFlag, in шим* colorProfileFilename);
Status GdipSetImageAttributesWrapMode(Укз imageattr, WrapMode wrap, цел argb, цел clamp);
Status GdipSetImageAttributesRemapTable(Укз imageattr, ColorAdjustType тип, цел enableFlag, бцел mapSize, ук map);

Status GdipDisposeImage(Укз image);
Status GdipImageForceValidation(Укз image);
Status GdipLoadImageFromFileICM(in шим* filename, out Укз image);
Status GdipLoadImageFromFile(in шим* filename, out Укз image);
Status GdipLoadImageFromStreamICM(IStream поток, out Укз image);
Status GdipLoadImageFromStream(IStream поток, out Укз image);
Status GdipGetImageRawFormat(Укз image, out GUID format);
Status GdipGetImageEncodersSize(out цел numEncoders, out цел размер);
Status GdipGetImageEncoders(цел numEncoders, цел размер, GpImageCodecInfo* encoders);
Status GdipGetImageDecodersSize(out цел numDecoders, out цел размер);
Status GdipGetImageDecoders(цел numDecoders, цел размер, GpImageCodecInfo* decoders);
Status GdipSaveImageToFile(Укз image, in шим* filename, ref GUID clsidEncoder, GpEncoderParameters* encoderParams);
Status GdipSaveImageToStream(Укз image, IStream поток, ref GUID clsidEncoder, GpEncoderParameters* encoderParams);
Status GdipSaveAdd(Укз image, GpEncoderParameters* encoderParams);
Status GdipSaveAddImage(Укз image, Укз newImage, GpEncoderParameters* encoderParams);
Status GdipCloneImage(Укз image, out Укз cloneImage);
Status GdipGetImageType(Укз image, out цел тип);
Status GdipGetImageFlags(Укз image, out бцел флаги);
Status GdipGetImageWidth(Укз image, out цел ширина);
Status GdipGetImageHeight(Укз image, out цел высота);
Status GdipGetImageHorizontalResolution(Укз image, out плав resolution);
Status GdipGetImageVerticalResolution(Укз image, out плав resolution);
Status GdipGetPropertyCount(Укз image, out бцел numOfProperty);
Status GdipGetPropertyIdList(Укз image, цел numOfProperty, цел* список);
Status GdipGetImagePixelFormat(Укз image, out PixelFormat format);
Status GdipGetImageDimension(Укз image, out плав ширина, out плав высота);
Status GdipGetImageThumbnail(Укз image, цел thumbWidth, цел thumbHeight, out Укз thumbImage, GpGetThumbnailImageAbort обрвыз, ук callbackData);
Status GdipImageGetFrameCount(Укз image, ref GUID dimensionID, out бцел счёт);
Status GdipImageSelectActiveFrame(Укз image, ref GUID dimensionID, бцел frameCount);
Status GdipImageGetFrameDimensionsCount(Укз image, out бцел счёт);
Status GdipImageGetFrameDimensionsList(Укз image, GUID* dimensionIDs, бцел счёт);
Status GdipImageRotateFlip(Укз image, RotateFlipType rotateFlipType);
Status GdipGetPropertyItemSize(Укз image, цел propId, out бцел propSize);
Status GdipGetPropertyItem(Укз image, цел propId, бцел propSize, GpPropertyItem* буфер);
Status GdipSetPropertyItem(Укз image, ref GpPropertyItem буфер);
Status GdipRemovePropertyItem(Укз image, цел propId);
Status GdipGetPropertySize(Укз image, out бцел totalBufferSize, ref цел numProperties);
Status GdipGetAllPropertyItems(Укз image, бцел totalBufferSize, цел numProperties, GpPropertyItem* allItems);
Status GdipGetImageBounds(Укз image, out ПрямП srcRect, out GraphicsUnit srcUnit);
Status GdipGetEncoderParameterListSize(Укз image, ref GUID clsidEncoder, out бцел размер);
Status GdipGetEncoderParameterList(Укз image, ref GUID clsidEncoder, бцел размер, GpEncoderParameters* буфер);
Status GdipGetImagePaletteSize(Укз image, out цел размер);
Status GdipGetImagePalette(Укз image, GpColorPalette* palette, цел размер);
Status GdipSetImagePalette(Укз image, GpColorPalette* palette);

Status GdipCreateBitmapFromScan0(цел ширина, цел высота, цел stride, PixelFormat format, ббайт* scan0, out Укз битмап);
Status GdipCreateBitmapFromHBITMAP(Укз hbitmap, Укз hpalette, out Укз битмап);
Status GdipCreateBitmapFromHICON(Укз hicon, out Укз битмап);
Status GdipCreateBitmapFromFileICM(in шим* имяф, out Укз битмап);
Status GdipCreateBitmapFromFile(in шим* имяф, out Укз битмап);
Status GdipCreateBitmapFromStreamICM(IStream поток, out Укз битмап);
Status GdipCreateBitmapFromStream(IStream поток, out Укз битмап);
Status GdipCreateBitmapFromGraphics(цел ширина, цел высота, Укз graphics, out Укз битмап);
Status GdipCloneBitmapArea(плав x, плав y, плав ширина, плав высота, PixelFormat format, Укз srcbitmap, out Укз dstbitmap);
Status GdipCloneBitmapAreaI(цел x, цел y, цел ширина, цел высота, PixelFormat format, Укз srcbitmap, out Укз dstbitmap);
Status GdipBitmapGetPixel(Укз битмап, цел x, цел y, out цел цвет);
Status GdipBitmapSetPixel(Укз битмап, цел x, цел y, цел цвет);
Status GdipBitmapLockBits(Укз битмап, ref Прям прям, ImageLockMode флаги, PixelFormat format, out GpBitmapData lockedBitmapData);
Status GdipBitmapUnlockBits(Укз битмап, ref GpBitmapData lockedBitmapData);
Status GdipBitmapSetResolution(Укз битмап, плав xdpi, плав ydpi);
Status GdipCreateHICONFromBitmap(Укз битмап, out Укз hbmReturn);
Status GdipCreateHBITMAPFromBitmap(Укз битмап, out Укз hbmReturn, цел background);
Status GdipCreateBitmapFromResource(Укз hInstance, in шим* lpBitmapName, out Укз битмап);

Status GdipCreateStreamOnFile(in шим* filename, бцел access, out IStream поток);

Status GdipCreateMetafileFromFile(in шим* file, out Укз metafile);
Status GdipCreateMetafileFromStream(IStream поток, out Укз metafile);
Status GdipRecordMetafile(Укз referenceHdc, EmfType тип, ПрямП* frameRect, MetafileFrameUnit frameUnit, in шим* описание, out Укз metafile);
Status GdipRecordMetafileI(Укз referenceHdc, EmfType тип, Прям* frameRect, MetafileFrameUnit frameUnit, in шим* описание, out Укз metafile);
Status GdipRecordMetafileStream(IStream поток, Укз referenceHdc, EmfType тип, ПрямП* frameRect, MetafileFrameUnit frameUnit, in шим* описание, out Укз metafile);
Status GdipRecordMetafileStreamI(IStream поток, Укз referenceHdc, EmfType тип, Прям* frameRect, MetafileFrameUnit frameUnit, in шим* описание, out Укз metafile);
Status GdipRecordMetafileFileName(in шим* имяф, Укз referenceHdc, EmfType тип, ПрямП* frameRect, MetafileFrameUnit frameUnit, in шим* описание, out Укз metafile);
Status GdipRecordMetafileFileNameI(in шим* имяф, Укз referenceHdc, EmfType тип, Прям* frameRect, MetafileFrameUnit frameUnit, in шим* описание, out Укз metafile);
Status GdipGetHemfFromMetafile(Укз metafile, out Укз hEmfMetafile);
Status GdipCreateMetafileFromEmf(Укз hEmf, цел deleteEmf, out Укз metafile);
Status GdipCreateMetafileFromWmf(Укз hWmf, цел deleteWmf, ref GdipWmfPlaceableFileHeader wmfPlaceableFileHeader, out Укз metafile);
Status GdipCreateMetafileFromWmfFile(in шим* file, ref GdipWmfPlaceableFileHeader wmfPlaceableFileHeader, out Укз metafile);

Status GdipNewInstalledFontCollection(out Укз fontCollection);
Status GdipNewPrivateFontCollection(out Укз fontCollection);
Status GdipDeletePrivateFontCollection(Укз fontCollection);
Status GdipPrivateAddFontFile(Укз fontCollection, in шим* filename);
Status GdipPrivateAddMemoryFont(Укз fontCollection, ук memory, цел length);
Status GdipGetFontCollectionFamilyCount(Укз fontCollection, out цел numFound);
Status GdipGetFontCollectionFamilyList(Укз fontCollection, цел numSought, Укз* gpfamilies, out цел numFound);

Status GdipCreateFontFamilyFromName(in шим* имя, Укз fontCollection, out Укз FontFamily);
Status GdipDeleteFontFamily(Укз FontFamily);
Status GdipCloneFontFamily(Укз FontFamily, out Укз clonedFontFamily);
Status GdipGetFamilyName(Укз семейство, in шим* имя, цел язык);
Status GdipGetGenericFontFamilyMonospace(out Укз nativeFamily);
Status GdipGetGenericFontFamilySerif(out Укз nativeFamily);
Status GdipGetGenericFontFamilySansSerif(out Укз nativeFamily);
Status GdipGetEmHeight(Укз семейство, FontStyle style, out крат EmHeight);
Status GdipGetCellAscent(Укз семейство, FontStyle style, out крат CellAscent);
Status GdipGetCellDescent(Укз семейство, FontStyle style, out крат CellDescent);
Status GdipGetLineSpacing(Укз семейство, FontStyle style, out крат LineSpacing);
Status GdipIsStyleAvailable(Укз семейство, FontStyle style, out цел IsStyleAvailable);

Status GdipCreateFont(Укз fontFamily, плав emSize, цел style, цел unit, out Укз font);
Status GdipCreateFontFromDC(Укз hdc, out Укз font);
Status GdipDeleteFont(Укз font);
Status GdipCloneFont(Укз font, out Укз cloneFont);
Status GdipGetFontSize(Укз font, out плав размер);
Status GdipGetFontHeight(Укз font, Укз graphics, out плав высота);
Status GdipGetFontHeightGivenDPI(Укз font, плав dpi, out плав высота);
Status GdipGetFontStyle(Укз font, out FontStyle style);
Status GdipGetFontUnit(Укз font, out GraphicsUnit unit);
Status GdipGetFamily(Укз font, out Укз семейство);
Status GdipCreateFontFromLogfontW(Укз hdc, ref LOGFONTW logfont, out Укз font);
Status GdipGetLogFontW(Укз font, Укз graphics, out LOGFONTW logfontW);

Status GdipCreateStringFormat(StringFormatFlags formatAttributes, цел язык, out Укз format);
Status GdipDeleteStringFormat(Укз format);
Status GdipCloneStringFormat(Укз format, out Укз newFormat);
Status GdipGetStringFormatFlags(Укз format, out StringFormatFlags флаги);
Status GdipSetStringFormatFlags(Укз format, StringFormatFlags флаги);
Status GdipGetStringFormatAlign(Укз format, out StringAlignment alignment);
Status GdipSetStringFormatAlign(Укз format, StringAlignment alignment);
Status GdipGetStringFormatLineAlign(Укз format, out StringAlignment alignment);
Status GdipSetStringFormatLineAlign(Укз format, StringAlignment alignment);
Status GdipGetStringFormatTrimming(Укз format, out StringTrimming trimming);
Status GdipSetStringFormatTrimming(Укз format, StringTrimming trimming);
Status GdipGetStringFormatMeasurableCharacterRangeCount(Укз format, out цел счёт);
Status GdipSetStringFormatMeasurableCharacterRanges(Укз format, цел rangeCount, ук ranges);
Status GdipStringFormatGetGenericDefault(out Укз format);
Status GdipStringFormatGetGenericTypographic(out Укз format);
Status GdipSetStringFormatTabStops(Укз format, плав firstTabOffset, цел счёт, плав* tabStops);
Status GdipGetStringFormatTabStops(Укз format, цел счёт, out плав firstTabOffset, плав* tabStops);
Status GdipGetStringFormatTabStopCount(Укз format, out цел счёт);
Status GdipSetStringFormatHotkeyPrefix(Укз format, HotkeyPrefix hotkeyPrefix);
Status GdipGetStringFormatHotkeyPrefix(Укз format, out HotkeyPrefix hotkeyPrefix);

Status GdipCreatePath(FillMode brushMode, out Укз путь);
Status GdipCreatePath2(ТочкаП*, ббайт*, цел, FillMode, out Укз);
Status GdipCreatePath2I(Точка*, ббайт*, цел, FillMode, out Укз);
Status GdipDeletePath(Укз путь);
Status GdipClonePath(Укз путь, out Укз clonepath);
Status GdipResetPath(Укз путь);
Status GdipGetPathFillMode(Укз путь, out FillMode fillmode);
Status GdipSetPathFillMode(Укз путь, FillMode fillmode);
Status GdipStartPathFigure(Укз путь);
Status GdipClosePathFigure(Укз путь);
Status GdipClosePathFigures(Укз путь);
Status GdipSetPathMarker(Укз путь);
Status GdipClearPathMarkers(Укз путь);
Status GdipReversePath(Укз путь);
Status GdipGetPathLastPoint(Укз путь, out ТочкаП lastPoint);
Status GdipAddPathLine(Укз путь, плав x2, плав y1, плав x2, плав y2);
Status GdipAddPathLineI(Укз путь, цел x2, цел y1, цел x2, цел y2);
Status GdipAddPathLine2(Укз путь, ТочкаП* points, цел счёт);
Status GdipAddPathLine2I(Укз путь, Точка* points, цел счёт);
Status GdipAddPathArc(Укз путь, плав x, плав y, плав ширина, плав высота, плав startAngle, плав sweepAngle);
Status GdipAddPathArcI(Укз путь, цел x, цел y, цел ширина, цел высота, плав startAngle, плав sweepAngle);
Status GdipAddPathBezier(Укз путь, плав x1, плав y1, плав x2, плав y2, плав x3, плав y3, плав x4, плав y4);
Status GdipAddPathBezierI(Укз путь, цел x1, цел y1, цел x2, цел y2, цел x3, цел y3, цел x4, цел y4);
Status GdipAddPathBeziers(Укз путь, ТочкаП* points, цел счёт);
Status GdipAddPathBeziersI(Укз путь, Точка* points, цел счёт);
Status GdipAddPathCurve(Укз путь, ТочкаП* points, цел счёт);
Status GdipAddPathCurveI(Укз путь, Точка* points, цел счёт);
Status GdipAddPathCurve2(Укз путь, ТочкаП* points, цел счёт, плав tension);
Status GdipAddPathCurve2I(Укз путь, Точка* points, цел счёт, плав tension);
Status GdipAddPathCurve3(Укз путь, ТочкаП* points, цел счёт, цел смещение, цел numberOfSegments, плав tension);
Status GdipAddPathCurve3I(Укз путь, Точка* points, цел счёт, цел смещение, цел numberOfSegments, плав tension);
Status GdipAddPathClosedCurve(Укз путь, ТочкаП* points, цел счёт);
Status GdipAddPathClosedCurveI(Укз путь, Точка* points, цел счёт);
Status GdipAddPathClosedCurve2(Укз путь, ТочкаП* points, цел счёт, плав tension);
Status GdipAddPathClosedCurve2I(Укз путь, Точка* points, цел счёт, плав tension);
Status GdipAddPathRectangle(Укз путь, плав x, плав y, плав ширина, плав высота);
Status GdipAddPathRectangleI(Укз путь, цел x, цел y, цел ширина, цел высота);
Status GdipAddPathRectangles(Укз путь, ПрямП* rects, цел счёт);
Status GdipAddPathRectanglesI(Укз путь, Прям* rects, цел счёт);
Status GdipAddPathEllipse(Укз путь, плав x, плав y, плав ширина, плав высота);
Status GdipAddPathEllipseI(Укз путь, цел x, цел y, цел ширина, цел высота);
Status GdipAddPathPie(Укз путь, плав x, плав y, плав ширина, плав высота, плав startAngle, плав sweepAngle);
Status GdipAddPathPieI(Укз путь, цел x, цел y, цел ширина, цел высота, плав startAngle, плав sweepAngle);
Status GdipAddPathPolygon(Укз путь, ТочкаП* points, цел счёт);
Status GdipAddPathPolygonI(Укз путь, Точка* points, цел счёт);
Status GdipAddPathPath(Укз путь, Укз addingPath, цел connect);
Status GdipAddPathString(Укз путь, in шим* ткст, цел length, Укз семейство, FontStyle style, плав emSize, ref ПрямП layoutRect, Укз format);
Status GdipAddPathStringI(Укз путь, in шим* ткст, цел length, Укз семейство, FontStyle style, плав emSize, ref Прям layoutRect, Укз format);
Status GdipTransformPath(Укз путь, Укз matrix);
Status GdipGetPathWorldBounds(Укз путь, out ПрямП bounds, Укз matrix, Укз pen);
Status GdipFlattenPath(Укз путь, Укз matrix, плав flatness);
Status GdipWidenPath(Укз путь, Укз pen, Укз matrix, плав flatness);
Status GdipWindingModeOutline(Укз путь, Укз matrix, плав flatness);
Status GdipWarpPath(Укз путь, Укз matrix, ТочкаП* points, цел счёт, плав srcx, плав srcy, плав srcwidth, плав srcwidth, WarpMode warpMode, плав flatness);
Status GdipGetPointCount(Укз путь, out цел счёт);
Status GdipGetPathTypes(Укз путь, ббайт* типы, цел счёт);
Status GdipGetPathPoints(Укз путь, ТочкаП* points, цел счёт);
Status GdipIsVisiblePathPoint(Укз путь, плав x, плав y, Укз graphics, out цел рез);
Status GdipIsVisiblePathPointI(Укз путь, цел x, цел y, Укз graphics, out цел рез);
Status GdipIsOutlineVisiblePathPoint(Укз путь, плав x, плав y, Укз pen, Укз graphics, out цел рез);
Status GdipIsOutlineVisiblePathPointI(Укз путь, цел x, цел y, Укз pen, Укз graphics, out цел рез);

Status GdipCreatePathIter(out Укз iterator, Укз путь);
Status GdipDeletePathIter(Укз iterator);
Status GdipPathIterNextSubpath(Укз iterator, out цел resultCount, out цел startIndex, out цел endIndex, out цел isClosed);
Status GdipPathIterNextSubpathPath(Укз iterator, out цел resultCount, Укз путь, out цел isClosed);
Status GdipPathIterNextPathType(Укз iterator, out цел resultCount, out ббайт pathType, out цел startIndex, out цел endIndex);
Status GdipPathIterNextMarker(Укз iterator, out цел resultCount, out цел startIndex, out цел endIndex);
Status GdipPathIterNextMarkerPath(Укз iterator, out цел resultCount, Укз путь);
Status GdipPathIterGetCount(Укз iterator, out цел счёт);
Status GdipPathIterGetSubpathCount(Укз iterator, out цел счёт);
Status GdipPathIterHasCurve(Укз iterator, out цел hasCurve);
Status GdipPathIterRewind(Укз iterator);
Status GdipPathIterconsterate(Укз iterator, out цел resultCount, ТочкаП* points, ббайт* типы, цел счёт);
Status GdipPathIterCopyData(Укз iterator, out цел resultCount, ТочкаП* points, ббайт* типы, цел startIndex, цел endIndex);

Status GdipCreatePathGradient(ТочкаП* points, цел счёт, WrapMode wrapMode, out Укз polyGradient);
Status GdipCreatePathGradientI(Точка* points, цел счёт, WrapMode wrapMode, out Укз polyGradient);
Status GdipCreatePathGradientFromPath(Укз путь, out Укз polyGradient);
Status GdipGetPathGradientCenterColor(Укз brush, out цел цвета);
Status GdipSetPathGradientCenterColor(Укз brush, цел цвета);
Status GdipGetPathGradientSurroundColorCount(Укз brush, out цел счёт);
Status GdipGetPathGradientSurroundColorsWithCount(Укз brush, цел* цвет, ref цел счёт);
Status GdipSetPathGradientSurroundColorsWithCount(Укз brush, цел* цвет, ref цел счёт);
Status GdipGetPathGradientCenterPoint(Укз brush, ref ТочкаП point);
Status GdipSetPathGradientCenterPoint(Укз brush, ref ТочкаП point);
Status GdipGetPathGradientRect(Укз brush, ref ПрямП прям);
Status GdipGetPathGradientBlendCount(Укз brush, out цел счёт);
Status GdipGetPathGradientBlend(Укз brush, плав* blend, плав* positions, цел счёт);
Status GdipSetPathGradientBlend(Укз brush, плав* blend, плав* positions, цел счёт);
Status GdipGetPathGradientPresetBlendCount(Укз brush, out цел счёт);
Status GdipGetPathGradientPresetBlend(Укз brush, цел* blend, плав* positions, цел счёт);
Status GdipSetPathGradientPresetBlend(Укз brush, цел* blend, плав* positions, цел счёт);
Status GdipSetPathGradientSigmaBlend(Укз brush, плав focus, плав шкала);
Status GdipSetPathGradientLinearBlend(Укз brush, плав focus, плав шкала);
Status GdipGetPathGradientTransform(Укз brush, out Укз matrix);
Status GdipSetPathGradientTransform(Укз brush, Укз matrix);
Status GdipResetPathGradientTransform(Укз brush);
Status GdipMultiplyPathGradientTransform(Укз brush, Укз matrix, MatrixOrder order);
Status GdipRotatePathGradientTransform(Укз brush, плав angle, MatrixOrder order);
Status GdipTranslatePathGradientTransform(Укз brush, плав dx, плав dy, MatrixOrder order);
Status GdipScalePathGradientTransform(Укз brush, плав sx, плав sy, MatrixOrder order);
Status GdipGetPathGradientFocusScales(Укз brush, out плав xScale, out плав yScale);
Status GdipSetPathGradientFocusScales(Укз brush, плав xScale, плав yScale);
Status GdipGetPathGradientWrapMode(Укз brush, out WrapMode wrapMode);
Status GdipSetPathGradientWrapMode(Укз brush, WrapMode wrapMode);

extern(D):

проц GdipDeleteMatrixSafe(Укз matrix) {
  if (!isShutdown)
    GdipDeleteMatrix(matrix);
}

проц GdipDeleteGraphicsSafe(Укз graphics) {
  if (!isShutdown)
    GdipDeleteGraphics(graphics);
}

проц GdipDeletePenSafe(Укз pen) {
  if (!isShutdown)
    GdipDeletePen(pen);
}

проц GdipDeleteBrushSafe(Укз brush) {
  if (!isShutdown)
    GdipDeleteBrush(brush);
}

проц GdipDisposeImageSafe(Укз image) {
  if (!isShutdown)
    GdipDisposeImage(image);
}

проц GdipDisposeImageAttributesSafe(Укз imageattr) {
  if (!isShutdown)
    GdipDisposeImageAttributes(imageattr);
}

проц GdipDeletePathSafe(Укз путь) {
  if (!isShutdown)
    GdipDeletePath(путь);
}

проц GdipDeletePathIterSafe(Укз iterator) {
  if (!isShutdown)
    GdipDeletePathIter(iterator);
}

проц GdipDeleteRegionSafe(Укз region) {
  if (!isShutdown)
    GdipDeleteRegion(region);
}

проц GdipDeleteFontFamilySafe(Укз семейство) {
  if (!isShutdown)
    GdipDeleteFontFamily(семейство);
}

проц GdipDeletePrivateFontCollectionSafe(Укз fontCollection) {
  if (!isShutdown)
    GdipDeletePrivateFontCollection(fontCollection);
}

проц GdipDeleteFontSafe(Укз font) {
  if (!isShutdown)
    GdipDeleteFont(font);
}

проц GdipDeleteStringFormatSafe(Укз format) {
  if (!isShutdown)
    GdipDeleteStringFormat(format);
}

private бцел initToken;
private бул isShutdown;

private проц startup() {
  static GdiplusStartupInput ввод = { 1, null, 0, 0 };
  static GdiplusStartupOutput вывод;

  GdiplusStartup(initToken, ввод, вывод);
}

private проц shutdown() {
  version(D_Version2) {
    GC.collect();
  }
  else {
    runtime.fullCollect();
  }
  isShutdown = true;

  GdiplusShutdown(initToken);
}

/*package*/ Exception statusException(Status status) {
  switch (status) {
    case Status.GenericError:
      return new Exception("A generic ошибка occurred in GDI+.");
    case Status.InvalidParameter:
      return new win32.base.core.ИсклАргумента("Параметр is not valid.");
    case Status.OutOfMemory:
      return new OutOfMemoryException;
    case Status.ObjectBusy:
      return new ИсклНеправильнОперации("Объект is currently in use elsewhere.");
    case Status.InsufficientBuffer:
      return new OutOfMemoryException;
    case Status.NotImplemented:
      return new ИсклНеРеализовано("Not implemented.");
    case Status.Win32Error:
      return new Exception("A generic ошибка occurred in GDI+.");
    case Status.WrongState:
      return new ИсклНеправильнОперации("Bitmap region is already locked.");
    case Status.Aborted:
      return new Exception("Функция was ended.");
    case Status.AccessDenied:
      return new Exception("Файл access is denied.");
    case Status.UnknownImageFormat:
      return new ИсклАргумента("Image format is unknown.");
    case Status.FontFamilyNotFound:
      return new ИсклАргумента("Font cannot be found.");
    case Status.FontStyleNotFound:
      return new ИсклАргумента("Font does not support style.");
    case Status.NotTrueTypeFont:
      return new ИсклАргумента("Only true тип fonts are supported.");
    case Status.UnsupportedGdiplusVersion:
      return new Exception("Current version of GDI+ does not support this feature.");
    case Status.GdiplusNotInitialized:
      return new Exception("GDI+ is not initialized.");
    case Status.PropertyNotFound:
      return new ИсклАргумента("Property cannot be found.");
    case Status.PropertyNotSupported:
      return new ИсклАргумента("Property is not supported.");
    default:
  }
  return new Exception("Unknown GDI+ ошибка occurred.");
}