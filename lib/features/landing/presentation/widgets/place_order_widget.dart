import 'package:flutter/material.dart';
import 'package:polkadex/features/landing/presentation/widgets/buy_sell_widget.dart';
import 'package:polkadex/common/utils/enums.dart';

class PlaceOrderWidget extends StatefulWidget {
  @override
  State<PlaceOrderWidget> createState() => _PlaceOrderWidgetState();
}

class _PlaceOrderWidgetState extends State<PlaceOrderWidget> {
  final ValueNotifier<EnumBuySell> _buySellNotifier =
      ValueNotifier(EnumBuySell.buy);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BuySellWidget(
          buySellNotifier: _buySellNotifier,
        ),
      ],
    );
  }
}
