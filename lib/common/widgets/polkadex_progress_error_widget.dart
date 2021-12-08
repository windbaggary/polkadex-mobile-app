import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';

class PolkadexProgressErrorWidget extends StatefulWidget {
  const PolkadexProgressErrorWidget({
    this.isError = false,
    this.notificationPredicate = 0,
    this.onRefresh,
    required this.child,
  });

  final bool isError;
  final int notificationPredicate;
  final Widget child;
  final Future<void> Function()? onRefresh;

  @override
  State<PolkadexProgressErrorWidget> createState() =>
      _PolkadexProgressErrorWidgetState();
}

class _PolkadexProgressErrorWidgetState
    extends State<PolkadexProgressErrorWidget> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: widget.onRefresh != null ? widget.onRefresh! : () async {},
      notificationPredicate: (notification) =>
          notification.depth == widget.notificationPredicate,
      offsetToArmed: 200,
      builder:
          (BuildContext context, Widget child, IndicatorController controller) {
        return AnimatedBuilder(
          animation: controller,
          child: child,
          builder: (context, child) {
            Widget widgetToShow;

            if (widget.isError) {
              widgetToShow = _errorWidget();
            } else if (controller.state == IndicatorState.loading) {
              widgetToShow = _loadingWidget();
            } else {
              widgetToShow = _refreshWidget();
            }

            return Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Positioned(
                  top: (widget.isError ? 10.0 : 10.0 * controller.value),
                  child: widget.isError
                      ? Column(
                          children: [
                            widgetToShow,
                            SizedBox(height: 8),
                            Opacity(
                              opacity: controller.value <= 1.0
                                  ? controller.value
                                  : 1.0,
                              child: _refreshWidget(),
                            ),
                          ],
                        )
                      : Opacity(
                          opacity:
                              controller.value <= 1.0 ? controller.value : 1.0,
                          child: widgetToShow,
                        ),
                ),
                Transform.translate(
                  offset: Offset(
                      0,
                      (widget.isError
                          ? 80.0 + (controller.value * 20.0)
                          : controller.value * 20.0)),
                  child: child,
                ),
              ],
            );
          },
        );
      },
      child: widget.child,
    );
  }

  Widget _errorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: colorE6007A),
          width: 45,
          height: 45,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              'warning'.asAssetSvg(),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Connection Error',
          style: tsS20W600CFF,
        ),
      ],
    );
  }

  Widget _loadingWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoActivityIndicator(),
        SizedBox(width: 4),
        Text(
          'Loading...',
          style: tsS14W400CFF,
        ),
      ],
    );
  }

  Widget _refreshWidget() {
    return Row(
      children: [
        Icon(
          Icons.refresh,
          color: Colors.white,
          size: 16,
        ),
        Text(
          'Refresh',
          style: tsS14W600CFF,
        ),
      ],
    );
  }
}
