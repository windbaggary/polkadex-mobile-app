import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/styles.dart';

class SoonWidget extends StatelessWidget {
  const SoonWidget({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Soon',
              style: tsS18W600CFF,
            ),
          ),
        ),
        IgnorePointer(
          ignoring: true,
          child: Opacity(
            opacity: 0.2,
            child: child,
          ),
        )
      ],
    );
  }
}
