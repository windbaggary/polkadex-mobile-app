import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

/// The widget can be used to hide any child when the scroll is published
///
/// The [scrollController] must not be null
/// The [scrollController] is of any scroll view which need to be listen
class HideOnScrollWidget extends SingleChildRenderObjectWidget {
  final ScrollController scrollController;
  HideOnScrollWidget({
    required Widget child,
    required this.scrollController,
  }) : super(child: child);
  @override
  _HideOnScrollRenderObject createRenderObject(BuildContext context) {
    return _HideOnScrollRenderObject(scrollController: scrollController);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _HideOnScrollRenderObject renderObject) {
    renderObject..scrollController = this.scrollController;
  }
}

class _HideOnScrollRenderObject extends RenderProxyBox {
  ScrollController _scrollController;

  _HideOnScrollRenderObject({required ScrollController scrollController})
      : this._scrollController = scrollController,
        super();

  ScrollController get scrollController => this._scrollController;

  set scrollController(ScrollController value) {
    this._scrollController = value;
    _scrollController.addListener(_scrollListener);

    markNeedsLayout();
    markNeedsPaint();
  }

  @override
  void attach(covariant PipelineOwner owner) {
    _scrollController.addListener(_scrollListener);

    super.attach(owner);
  }

  @override
  void detach() {
    _scrollController.removeListener(_scrollListener);
    super.detach();
  }

  void _scrollListener() {
    markNeedsLayout();
    markNeedsPaint();
  }

  double _childInitHeight = 0.0;
  double _scrollHeight = 0.0;

  @override
  void performLayout() {
    // super.performLayout();
    double width = 0.0;
    width = constraints.maxWidth;
    child!.layout(BoxConstraints(maxWidth: constraints.maxWidth),
        parentUsesSize: true);
    _childInitHeight = child!.size.height;
    _scrollHeight = (_childInitHeight - scrollController.offset)
        .clamp(0.0, _childInitHeight);

    child!.layout(BoxConstraints(
        maxWidth: constraints.maxWidth, maxHeight: _scrollHeight));

    size = Size(width, _scrollHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // offset = Offset(offset.dx, offset.dy + _scrollHeight - _childInitHeight);
    print(_scrollHeight / _childInitHeight);
    double opacity = (_scrollHeight / _childInitHeight).clamp(0.0, 1.0);
    int alpha = ui.Color.getAlphaFromOpacity(opacity);
    if (child != null) {
      if (alpha == 0) {
        // No need to keep the layer. We'll create a new one if necessary.
        layer = null;
        return;
      }
      if (alpha == 255) {
        // No need to keep the layer. We'll create a new one if necessary.
        layer = null;
        context.paintChild(child!, offset);
        return;
      }
      layer = context.pushOpacity(offset, alpha, super.paint,
          oldLayer: layer as OpacityLayer);
    }
  }
}
