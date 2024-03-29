import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';

/// The type def for the bottom bar selection
typedef OnAppBottomBarSelected = void Function(EnumBottonBarItem item);

/// The bottom navigation bar in landing screen
class AppBottomNavigationBar extends StatelessWidget {
  AppBottomNavigationBar({
    this.onSelected,
    this.initialItem = EnumBottonBarItem.home,
  }) : _selectedNotifier = ValueNotifier<EnumBottonBarItem>(
            initialItem ?? EnumBottonBarItem.home);

  final ValueNotifier<EnumBottonBarItem> _selectedNotifier;

  final OnAppBottomBarSelected? onSelected;
  final EnumBottonBarItem? initialItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color1C2023,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.30),
            blurRadius: 20,
            offset: Offset(0.0, -9.0),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            InkWell(
              onTap: () {
                _selectedNotifier.value = EnumBottonBarItem.home;
                if (onSelected != null) {
                  onSelected!(EnumBottonBarItem.home);
                }
              },
              child: Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'logo_icon.png'.asAssetImg(),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.color2E303C,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        _selectedNotifier.value = EnumBottonBarItem.exchange;
                        if (onSelected != null) {
                          onSelected!(EnumBottonBarItem.exchange);
                        }
                      },
                      child: ValueListenableBuilder<EnumBottonBarItem>(
                          valueListenable: _selectedNotifier,
                          builder: (_, __, ___) => _buildExchangeWidget()),
                    ),
                    InkWell(
                      onTap: () {
                        _selectedNotifier.value = EnumBottonBarItem.trade;
                        if (onSelected != null) {
                          onSelected!(EnumBottonBarItem.trade);
                        }
                      },
                      child: ValueListenableBuilder<EnumBottonBarItem>(
                          valueListenable: _selectedNotifier,
                          builder: (_, __, ___) => _buildTradeWidget()),
                    ),
                    InkWell(
                      onTap: () {
                        _selectedNotifier.value = EnumBottonBarItem.balance;
                        if (onSelected != null) {
                          onSelected!(EnumBottonBarItem.balance);
                        }
                      },
                      child: ValueListenableBuilder<EnumBottonBarItem>(
                          valueListenable: _selectedNotifier,
                          builder: (_, __, ___) => _buildBalanceWidget()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AspectRatio _buildBalanceWidget() {
    Color containerColor;
    String svg;
    if (_selectedNotifier.value == EnumBottonBarItem.balance) {
      containerColor = AppColors.colorE6007A;
      svg = 'wallet_selected'.asAssetSvg();
    } else {
      containerColor = Colors.transparent;
      svg = 'wallet'.asAssetSvg();
    }
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        child: AnimatedContainer(
          duration: AppConfigs.animDurationSmall,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(6),
          child: SvgPicture.asset(
            svg,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  SizedBox _buildTradeWidget() {
    String svg;
    Color containerColor;
    if (_selectedNotifier.value == EnumBottonBarItem.trade) {
      containerColor = AppColors.colorE6007A;
      svg = 'trade_selected'.asAssetSvg();
    } else {
      containerColor = Colors.transparent;
      svg = 'arrow-2'.asAssetSvg();
    }
    return SizedBox(
      height: 64,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          child: AnimatedContainer(
            duration: AppConfigs.animDurationSmall,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              svg,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildExchangeWidget() {
    String svg;
    Color containerColor;
    if (_selectedNotifier.value == EnumBottonBarItem.exchange) {
      containerColor = AppColors.colorE6007A;
      svg = 'chart_selected'.asAssetSvg();
    } else {
      containerColor = Colors.transparent;
      svg = 'chart'.asAssetSvg();
    }

    return SizedBox(
      height: 64,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          child: AspectRatio(
            aspectRatio: 1,
            child: AnimatedContainer(
              duration: AppConfigs.animDurationSmall,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(6),
              child: RotatedBox(
                quarterTurns: 3,
                child: SvgPicture.asset(
                  svg,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
