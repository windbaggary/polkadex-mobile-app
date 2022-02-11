import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/build_methods.dart';

class PolkadexErrorRefreshWidget extends StatelessWidget {
  const PolkadexErrorRefreshWidget({
    this.onRefresh,
  });

  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildInkWell(
          onTap: () async {
            if (onRefresh != null) {
              onRefresh!();
            }
          },
          child: Row(
            children: [
              Icon(
                Icons.refresh,
                color: Colors.white,
                size: 26,
              ),
              Text(
                'Refresh',
                style: tsS22W600CFF,
              ),
            ],
          ),
        )
      ],
    );
  }
}
