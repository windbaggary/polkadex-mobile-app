import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/extensions.dart';

/// The callback listener for the Order type item selection
typedef OnItemSelected = void Function(int index);
typedef OnOrderTypeSelected = void Function(EnumOrderTypes type);

/// The content dialog for the order type
class _OrderTypeDialogWidget extends StatelessWidget {
  final ValueNotifier<EnumOrderTypes> selectedTypeNotifier;
  final OnOrderTypeSelected onItemSelected;

  _OrderTypeDialogWidget({
    Key key,
    EnumOrderTypes selectedIndex,
    this.onItemSelected,
  })  : this.selectedTypeNotifier =
            ValueNotifier<EnumOrderTypes>(selectedIndex),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color2E303C,
        boxShadow: <BoxShadow>[bsDefault],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(21, 21, 21, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Types',
                  style: tsS22W600CFF,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: color8BA1BE.withOpacity(0.20),
                    ),
                    padding: const EdgeInsets.fromLTRB(14, 12, 13, 12),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'close'.asAssetSvg(),
                          width: 11.11,
                          height: 11.11,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7.82),
                          child: Text(
                            'Cancel',
                            style: tsS14W400CFF,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14),
          ...EnumOrderTypes.values
              .map((e) => InkWell(
                    onTap: () {
                      if (this.onItemSelected != null) {
                        this.onItemSelected(e);
                      }
                      this.selectedTypeNotifier.value = e;
                      Navigator.pop(context);
                    },
                    child: ValueListenableBuilder<EnumOrderTypes>(
                      valueListenable: this.selectedTypeNotifier,
                      builder: (context, selectedItem, child) =>
                          _ThisOrderTypeItemWidget(
                        orderTypeModel: e,
                        isSelected: e == selectedItem,
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}

/// The animated widget for the order types items
class _ThisOrderTypeItemWidget extends StatelessWidget {
  final bool isSelected;
  final EnumOrderTypes orderTypeModel;

  const _ThisOrderTypeItemWidget({
    Key key,
    this.isSelected = false,
    @required this.orderTypeModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double verticalMargin = 4.0;
    Color bgColor = Colors.black.withOpacity(0.20);
    Color textColor = colorABB2BC;

    if (isSelected) {
      verticalMargin = 20;
      bgColor = colorE6007A;
      textColor = colorFFFFFF;
    }

    String title;
    String description;
    switch (orderTypeModel) {
      case EnumOrderTypes.Market:
        title = "Market Order";
        description =
            "A market order is an order to buy or sell a stock at the market’s current best available price.";
        break;
      case EnumOrderTypes.Limit:
        title = "Limit Order";
        description =
            "A limit order is an order to buy or sell a stock with a restriction on the maximum price to be paid or the minimum price to be received.";
        break;
      case EnumOrderTypes.Stop:
        title = "Stop Order";
        description =
            "A stop order is an order to buy or sell a stock at the market price once the stock has traded at or through a specified price.";
        break;
    }

    return AnimatedContainer(
      duration: AppConfigs.animDurationSmall,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: bgColor,
      ),
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      padding: const EdgeInsets.fromLTRB(18, 25, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title ?? "",
            style: tsS18W600CFF,
          ),
          SizedBox(height: 8),
          AnimatedDefaultTextStyle(
            duration: AppConfigs.animDuration,
            style: tsS14W400CFF.copyWith(color: textColor),
            child: Text(
              description ?? "",
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays the dialog to select the order type
void showOrderTypeDialog({
  @required BuildContext context,
  EnumOrderTypes selectedIndex,
  OnOrderTypeSelected onItemSelected,
}) {
  final content = Material(
    type: MaterialType.transparency,
    child: Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: _OrderTypeDialogWidget(
          selectedIndex: selectedIndex,
          onItemSelected: onItemSelected,
        ),
      ),
    ),
  );
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Barrier',
    transitionDuration: AppConfigs.animDurationSmall,
    transitionBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
            position: CurvedAnimation(
              parent: animation,
              curve: Curves.decelerate,
            ).drive<Offset>(
              Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0)),
            ),
            child: child),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return content;
    },
  );
}

class _PriceLengthDialogWidget extends StatelessWidget {
  final ValueNotifier<int> _selectedNotifier;
  final OnItemSelected onItemSelected;

  _PriceLengthDialogWidget({Key key, this.onItemSelected, int selectedIndex})
      : _selectedNotifier = ValueNotifier<int>(selectedIndex),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color2E303C,
        boxShadow: <BoxShadow>[bsDefault],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(21, 21, 21, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pricing Length',
                  style: tsS22W600CFF,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: color8BA1BE.withOpacity(0.20),
                    ),
                    padding: const EdgeInsets.fromLTRB(14, 12, 13, 12),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'close'.asAssetSvg(),
                          width: 11.11,
                          height: 11.11,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7.82),
                          child: Text(
                            'Cancel',
                            style: tsS14W400CFF,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14),
          ...DUMMY_PRICE_LENGTH_DATA
              .map((e) => InkWell(
                    onTap: () {
                      if (onItemSelected != null) {
                        onItemSelected(DUMMY_PRICE_LENGTH_DATA.indexOf(e));
                      }
                      _selectedNotifier.value =
                          DUMMY_PRICE_LENGTH_DATA.indexOf(e);
                      Navigator.pop(context);
                    },
                    child: ValueListenableBuilder(
                      valueListenable: _selectedNotifier,
                      builder: (context, selectedIndex, child) =>
                          _ThisPriceLengthWidget(
                        model: e,
                        isSelected:
                            selectedIndex == DUMMY_PRICE_LENGTH_DATA.indexOf(e),
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}

/// The item widget for the price length dialog
class _ThisPriceLengthWidget extends StatelessWidget {
  final PriceLengthModel model;
  final bool isSelected;
  const _ThisPriceLengthWidget({
    @required this.model,
    this.isSelected = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.black.withOpacity(0.20);
    Color textColor = colorABB2BC;

    if (isSelected) {
      bgColor = colorE6007A;
      textColor = colorFFFFFF;
    }

    return AnimatedContainer(
      duration: AppConfigs.animDurationSmall,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: bgColor,
      ),
      margin: EdgeInsets.symmetric(vertical: 7),
      padding: const EdgeInsets.fromLTRB(18, 25, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            model?.price ?? "",
            style: tsS18W600CFF,
          ),
          SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: AppConfigs.animDuration,
            style: tsS14W400CFF.copyWith(color: textColor),
            child: RichText(
              text: TextSpan(
                style: tsS14W400CFF.copyWith(color: textColor),
                children: <TextSpan>[
                  TextSpan(
                    text: 'See the token price like: ',
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                    ),
                  ),
                  TextSpan(
                    text: model?.likePrice,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: 'WorkSans',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays the dialog to price length
void showPriceLengthDialog({
  @required BuildContext context,
  int selectedIndex,
  OnItemSelected onItemSelected,
}) {
  final content = Material(
    type: MaterialType.transparency,
    child: Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: _PriceLengthDialogWidget(
          selectedIndex: selectedIndex,
          onItemSelected: onItemSelected,
        ),
      ),
    ),
  );
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Barrier',
    transitionDuration: AppConfigs.animDurationSmall,
    transitionBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
            position: CurvedAnimation(
              parent: animation,
              curve: Curves.decelerate,
            ).drive<Offset>(
              Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0)),
            ),
            child: child),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return content;
    },
  );
}

// Remove the dummy data below the lines

class PriceLengthModel {
  final int id;
  final String price;
  final String likePrice;

  const PriceLengthModel({
    @required this.id,
    @required this.price,
    @required this.likePrice,
  });
}

const DUMMY_PRICE_LENGTH_DATA = <PriceLengthModel>[
  PriceLengthModel(
    id: 1,
    price: "0.9",
    likePrice: '0.095 (BTC)',
  ),
  PriceLengthModel(
    id: 2,
    price: "0.95",
    likePrice: '0.0951 (BTC)',
  ),
  PriceLengthModel(
    id: 1,
    price: "0.951",
    likePrice: '0.9518 (BTC)',
  ),
  PriceLengthModel(
    id: 1,
    price: "0.9518",
    likePrice: '0.5185 (BTC)',
  ),
];
