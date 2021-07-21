import 'package:flutter/material.dart';
import 'package:polkadex/common/configs/app_config.dart';

class LoginButtonWidget extends StatelessWidget {
  LoginButtonWidget({
    required this.text,
    required this.textStyle,
    required this.backgroundColor,
    required this.onTap,
  });
  final _notifier = ValueNotifier<bool>(false);

  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (_) {
        _notifier.value = true;
      },
      onTap: () {
        _notifier.value = false;
        onTap();
      },
      onTapCancel: () {
        _notifier.value = false;
      },
      child: IgnorePointer(
        ignoring: true,
        child: ValueListenableBuilder<bool>(
          valueListenable: _notifier,
          builder: (context, isTranslate, child) {
            return AnimatedContainer(
              duration: AppConfigs.animDurationSmall ~/ 2,
              transform: Matrix4.translationValues(
                  0.0, isTranslate ? 10.0 : 0.00, 0.0),
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: textStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
