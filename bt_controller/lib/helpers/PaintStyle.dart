import 'dart:ui';

class PaintStyle {
  final bool isAntiAlias;
  static const int _kColorDefault = 0xFF000000;

  final Color? color;

  static final int _kBlendModeDefault = BlendMode.srcOver.index;
  final BlendMode blendMode;
  final PaintingStyle style;
  final double strokeWidth;

  final StrokeCap strokeCap;
  final StrokeJoin strokeJoin;

  static const double _kStrokeMiterLimitDefault = 4.0;
  final double strokeMiterLimit;
  final MaskFilter? maskFilter;

  final FilterQuality filterQuality;

  final Shader? shader;
  final ColorFilter? colorFilter;
  final bool invertColors;

  const PaintStyle({
    this.isAntiAlias = true,
    this.color = const Color(_kColorDefault),
    this.blendMode = BlendMode.srcOver,
    this.style = PaintingStyle.fill,
    this.strokeWidth = 0.0,
    this.strokeCap = StrokeCap.butt,
    this.strokeJoin = StrokeJoin.miter,
    this.strokeMiterLimit = 4.0,
    this.maskFilter, // null
    this.filterQuality = FilterQuality.none,
    this.shader, // null
    this.colorFilter, // null
    this.invertColors = false,
  });

  @override
  String toString() {
    final StringBuffer result = StringBuffer();
    String semicolon = '';
    result.write('PaintStyle(');
    if (style == PaintingStyle.stroke) {
      result.write('$style');
      if (strokeWidth != 0.0)
        result.write(' ${strokeWidth.toStringAsFixed(1)}');
      else
        result.write(' hairline');
      if (strokeCap != StrokeCap.butt) result.write(' $strokeCap');
      if (strokeJoin == StrokeJoin.miter) {
        if (strokeMiterLimit != _kStrokeMiterLimitDefault)
          result.write(
              ' $strokeJoin up to ${strokeMiterLimit.toStringAsFixed(1)}');
      } else {
        result.write(' $strokeJoin');
      }
      semicolon = '; ';
    }
    if (isAntiAlias != true) {
      result.write('${semicolon}antialias off');
      semicolon = '; ';
    }
    if (color != const Color(_kColorDefault)) {
      if (color != null)
        result.write('$semicolon$color');
      else
        result.write('${semicolon}no color');
      semicolon = '; ';
    }
    if (blendMode.index != _kBlendModeDefault) {
      result.write('$semicolon$blendMode');
      semicolon = '; ';
    }
    if (colorFilter != null) {
      result.write('${semicolon}colorFilter: $colorFilter');
      semicolon = '; ';
    }
    if (maskFilter != null) {
      result.write('${semicolon}maskFilter: $maskFilter');
      semicolon = '; ';
    }
    if (filterQuality != FilterQuality.none) {
      result.write('${semicolon}filterQuality: $filterQuality');
      semicolon = '; ';
    }
    if (shader != null) {
      result.write('${semicolon}shader: $shader');
      semicolon = '; ';
    }
    if (invertColors) result.write('${semicolon}invert: $invertColors');
    result.write(')');
    return result.toString();
  }

  Paint toPaint() {
    Paint paint = Paint();
    if (this.isAntiAlias != true) paint.isAntiAlias = this.isAntiAlias;
    if (this.color != const Color(_kColorDefault)) paint.color = this.color!;
    if (this.blendMode != BlendMode.srcOver) paint.blendMode = this.blendMode;
    if (this.style != PaintingStyle.fill) paint.style = this.style;
    if (this.strokeWidth != 0.0) paint.strokeWidth = this.strokeWidth;
    if (this.strokeCap != StrokeCap.butt) paint.strokeCap = this.strokeCap;
    if (this.strokeJoin != StrokeJoin.miter) paint.strokeJoin = this.strokeJoin;
    if (this.strokeMiterLimit != 4.0)
      paint.strokeMiterLimit = this.strokeMiterLimit;
    if (this.maskFilter != null) paint.maskFilter = this.maskFilter;
    if (this.filterQuality != FilterQuality.none)
      paint.filterQuality = this.filterQuality;
    if (this.shader != null) paint.shader = this.shader;
    if (this.colorFilter != null) paint.colorFilter = this.colorFilter;
    if (this.invertColors != false) paint.invertColors = this.invertColors;
    return paint;
  }
}
