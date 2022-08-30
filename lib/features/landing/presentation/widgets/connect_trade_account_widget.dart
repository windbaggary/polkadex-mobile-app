import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';

class ConnectTradeAccountWidget extends StatelessWidget {
  const ConnectTradeAccountWidget({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'You don\'t have a Trading Account',
          textAlign: TextAlign.center,
          style: tsS18W600CFF,
        ),
        AppButton(label: 'Connect'),
      ],
    );
  }
}
