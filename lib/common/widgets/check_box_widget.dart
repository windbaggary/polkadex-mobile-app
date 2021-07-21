import 'package:flutter/material.dart';
import 'package:polkadex/common/configs/app_config.dart';

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    required this.checkColor,
    required this.backgroundColor,
    this.isChecked = false,
    this.isBackTransparentOnUnchecked = false,
    this.onTap,
  });

  final Color checkColor;
  final Color backgroundColor;
  final bool isChecked;
  final bool isBackTransparentOnUnchecked;
  final void Function(bool val)? onTap;

  @override
  Widget build(BuildContext context) {
    Widget? child;
    final Border border = Border.all(
      color: backgroundColor,
      width: 3,
    );

    if (isChecked) {
      child = FittedBox(
        child: Icon(
          Icons.check,
          color: checkColor,
        ),
      );
    }

    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(!isChecked);
        }
      },
      child: AnimatedContainer(
        duration: AppConfigs.animDurationSmall ~/ 2,
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: (isBackTransparentOnUnchecked && !isChecked)
              ? null
              : backgroundColor,
          borderRadius: BorderRadius.circular(5),
          border: border,
        ),
        padding: const EdgeInsets.all(0),
        child: child,
      ),
    );
  }
}
