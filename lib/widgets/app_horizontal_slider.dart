import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:polkadex/utils/styles.dart';
import 'dart:math' as math;

/// The widget shows slider with the interval divider and pointer to drag
/// The percentage is shown on the pointer
///
/// The [initialProgress] can be set and an animation will be drawn to progress
/// The [initialProgress] must be between 0.0 and 1.0
///
/// The [onProgressUpdate] updates the progress wheneven user drags the pointer
///
class AppHorizontalSlider extends StatefulWidget {
  final double initialProgress;
  final OnProgressUpdate? onProgressUpdate;
  final Color activeColor, bgColor;

  const AppHorizontalSlider({
    this.initialProgress = 0.0,
    this.bgColor = const Color(0xff141415),
    this.activeColor = const Color(0xFFE6007A),
    this.onProgressUpdate,
  }) : assert(initialProgress >= 0.0 && initialProgress <= 1.0, '''
    The [initialProgress] must be between 0.0 and 1.0
    ''');
  @override
  _AppHorizontalSliderState createState() => _AppHorizontalSliderState();
}

class _AppHorizontalSliderState extends State<AppHorizontalSlider>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<double> _progressNotifier;
  // AnimationController _animationController;

  // Animation _progressAnimation;

  // void _rebuildAnimation({
  //   @required double previousProgress,
  //   @required double currentProgress,
  // }) {
  //   _progressAnimation =
  //       Tween<double>(begin: previousProgress ?? 0.0, end: currentProgress)
  //           .animate(CurvedAnimation(
  //     parent: _animationController,
  //     curve: Curves.decelerate,
  //   ));
  //   // _animationController.forward().orCancel;
  // }

  @override
  void initState() {
    _progressNotifier = ValueNotifier<double>(widget.initialProgress);
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: AppConfigs.animDurationSmall,
    // );

    // _rebuildAnimation(
    //     previousProgress: 0.0, currentProgress: widget.initialProgress);
    super.initState();
    // _playAnimation();
  }

  @override
  void dispose() {
    _progressNotifier.dispose();
    // this._animationController.dispose();
    // this._animationController = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppHorizontalSlider oldWidget) {
    if (oldWidget.initialProgress != widget.initialProgress) {
      _progressNotifier.value = widget.initialProgress;
      // _rebuildAnimation(
      //     previousProgress: oldWidget.initialProgress,
      //     currentProgress: widget.initialProgress);
      // _animationController.value = widget.initialProgress;
      // _playAnimation();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // return AnimatedBuilder(
    //   animation: _animationController,
    //   builder: (context, _) {
    return ValueListenableBuilder<double>(
      valueListenable: _progressNotifier,
      builder: (context, value, child) =>
          _AppHorizontalSliderRenderObjectWidget(
        progress: value,
        onProgressUpdate: widget.onProgressUpdate,
        bgColor: widget.bgColor,
        activeColor: widget.activeColor,
      ),
    );
    //   },
    // );
  }

  // void _playAnimation() {
  //   Future.microtask(() {
  //     if (_animationController == null) {
  //       return;
  //     }
  //     _animationController.reset();
  //     _animationController.forward().orCancel;
  //   });
  // }
}

typedef OnProgressUpdate = void Function(double progress);

class _AppHorizontalSliderRenderObjectWidget extends LeafRenderObjectWidget {
  final double progress;
  final OnProgressUpdate? onProgressUpdate;
  final Color bgColor, activeColor;

  _AppHorizontalSliderRenderObjectWidget({
    required this.bgColor,
    required this.activeColor,
    this.progress = 0.0,
    this.onProgressUpdate,
  });
  @override
  _AppHorizontalSliderRenderBox createRenderObject(BuildContext context) {
    return _AppHorizontalSliderRenderBox(
      progress: progress,
      onProgressUpdate: onProgressUpdate,
    )
      .._bgColor = bgColor
      .._activeColor = activeColor;
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant _AppHorizontalSliderRenderBox renderObject) {
    renderObject
      ..progress = progress
      ..onProgressUpdate = onProgressUpdate
      ..bgColor = bgColor
      ..activeColor = activeColor;
  }
}

class _AppHorizontalSliderRenderBox extends RenderBox {
  final double progressBarHeight = 5.0;
  final double dividerHeight = 13.0;
  final double dividerWidth = 4.0;
  final double progressThumbHeight = 27.0;
  final double progressThumbWidth = 34.0;
  final int dividerCount = 4;
  late Color _bgColor, _activeColor;

  OnProgressUpdate? onProgressUpdate;
  double _progress;
  _AppHorizontalSliderRenderBox({
    double progress = 0.0,
    this.onProgressUpdate,
  })  : this._progress = progress,
        super();

  set progress(double value) {
    this._progress = value;
    markNeedsPaint();
  }

  set bgColor(Color val) {
    _bgColor = val;
    markNeedsPaint();
  }

  set activeColor(Color val) {
    _activeColor = val;
    markNeedsPaint();
  }

  late HorizontalDragGestureRecognizer _drag;

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    this._drag = HorizontalDragGestureRecognizer()
      ..onStart = _onDragStart
      ..onUpdate = _onDragUpdate
      ..onCancel = _onCancel
      ..onEnd = _onEnd;
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _drag.addPointer(event);
    }
  }

  @override
  void performLayout() {
    final double height = <double>[
      progressBarHeight,
      dividerHeight,
      progressBarHeight,
      progressThumbHeight,
    ].fold<double>(0.0, (p, e) => math.max(p, e));
    final double width = constraints.maxWidth;

    final Size desiredSize = Size(width, height);
    size = constraints.constrain(desiredSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final pbBgPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = this._bgColor;

    final pbFgPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = this._activeColor;

    final canvas = context.canvas;
    canvas.save();

    canvas.translate(offset.dx, offset.dy);

    // Create text painter
    final textSpan = TextSpan(
      text: "${(_progress * 100).toInt()}%",
      style: tsS12W700CFF,
    );
    final textPainter = TextPainter(text: textSpan);
    textPainter.textAlign = TextAlign.start;
    textPainter.textDirection = TextDirection.rtl;
    textPainter.layout(minWidth: 0.0, maxWidth: this.size.width);

    final progressThumbWidth =
        math.max(textPainter.width + 8, this.progressThumbWidth);

    final double thumbWidthHalf = progressThumbWidth / 2;
    final size = Size(this.size.width - progressThumbWidth, this.size.height);
    final widthDx = thumbWidthHalf;

    final double heightHalf = size.height / 2;

    // Calculate the top of progress bg and drawing
    final double horizontalRectTopY = heightHalf - this.progressBarHeight / 2;
    final horizontalRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
            widthDx, horizontalRectTopY, size.width, this.progressBarHeight),
        Radius.circular(size.shortestSide));
    canvas.drawRRect(horizontalRect, pbBgPaint);

    // Selected foreground color section
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(widthDx, horizontalRectTopY, size.width * _progress,
                this.progressBarHeight),
            Radius.circular(size.shortestSide)),
        pbFgPaint);

    // Calculate the divider top y
    final double dividerTopY = heightHalf - dividerHeight / 2;

    // Calculate the divider spacing
    final double dividerSpacingWidth = size.width / dividerCount;

    // Drawing the divider
    for (int i = 0; i < dividerCount; i++) {
      // Calculate the position of each rect
      final left =
          (dividerSpacingWidth * (i + 1)) + widthDx - (dividerWidth / 2);
      final rect =
          Rect.fromLTWH(left, dividerTopY, dividerWidth, dividerHeight);
      final radius = Radius.circular(math.min(dividerHeight, dividerWidth));
      final rRect = RRect.fromRectAndRadius(rect, radius);

      final paint =
          ((dividerCount * _progress) > i + 1) ? pbFgPaint : pbBgPaint;
      // Draw the rect in canvas
      canvas.drawRRect(rRect, paint);
    }

    final progressWidth =
        ((size.width) * _progress) + widthDx - progressThumbWidth / 2;

    // The thumb section
    final rect = Rect.fromLTWH(
      progressWidth,
      0,
      progressThumbWidth,
      progressThumbHeight,
    );
    final radius = Radius.circular(9.0);
    final rrect = RRect.fromRectAndRadius(rect, radius);

    if (_progress == 0.0) {
      pbFgPaint..color = this._bgColor;
    }
    canvas.drawRRect(rrect, pbFgPaint);

    // Draw the text

    final textCenterX =
        (progressWidth + thumbWidthHalf - textPainter.width / 2);
    final textCenterY = (size.height - textPainter.height) / 2;
    final textOffset = Offset(textCenterX, textCenterY);
    textPainter.paint(canvas, textOffset);

    canvas.restore();
  }

  void _onDragStart(DragStartDetails details) {}

  void _onDragUpdate(DragUpdateDetails details) {
    this._progress =
        (details.localPosition.dx / (this.size.width - 1)).clamp(0.0, 1.0);
    if (this.onProgressUpdate != null) {
      this.onProgressUpdate!(this._progress);
    }
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  void _onDragComplete() {
    if (this.onProgressUpdate != null) {
      this.onProgressUpdate!(this._progress);
    }
  }

  void _onCancel() => _onDragComplete();

  void _onEnd(DragEndDetails details) => _onDragComplete();
}
