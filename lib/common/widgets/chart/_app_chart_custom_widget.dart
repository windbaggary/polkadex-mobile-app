import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:polkadex/common/widgets/chart/app_charts.dart';
import 'package:polkadex/common/widgets/chart/chart_models.dart';

/// The interface for the charts
abstract class IBaseAppChartCustomWidget {
  void iPaintChart(Canvas canvas, Size size, Offset offset, Offset touchPoint);

  void iPaintGrid(Canvas canvas, Size size, Offset offset);
}

/// The base class for drawing the charts
///
/// This widget is used to draw the sub charts into canvas
abstract class BaseAppChartCustomWidget<B extends BaseChartModel>
    extends LeafRenderObjectWidget implements IBaseAppChartCustomWidget {
  final List<B> parentData;

  BaseAppChartCustomWidget({Key key, @required this.parentData})
      : super(key: key);

  @override
  _ThisRenderObject createRenderObject(BuildContext context) {
    return _ThisRenderObject(
      iBaseAppChartCustomWidget: this,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _ThisRenderObject renderObject) {
    renderObject
      ..iBaseAppChartCustomWidget = this
      ..refreshPaint();
  }
}

class _ThisRenderObject extends RenderProxyBox {
  IBaseAppChartCustomWidget iBaseAppChartCustomWidget;
  HorizontalDragGestureRecognizer _drag;
  Offset _touchPoint;

  _ThisRenderObject({@required this.iBaseAppChartCustomWidget}) : super();

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
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.clipRect(offset & size, doAntiAlias: true);

    canvas.translate(offset.dx, offset.dy);

    iBaseAppChartCustomWidget.iPaintGrid(canvas, size, offset);

    iBaseAppChartCustomWidget.iPaintChart(
        context.canvas, size, offset, _touchPoint);

    canvas.restore();
  }

  void refreshPaint() {
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  void _onDragStart(DragStartDetails details) {
    _touchPoint = details.localPosition;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _touchPoint = details.localPosition;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  void _onDragComplete() {}

  void _onCancel() => _onDragComplete();

  void _onEnd(DragEndDetails details) => _onDragComplete();
}
