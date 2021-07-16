import 'package:flutter/material.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';

typedef OnDotSelected = void Function(int index);

/// The slide dots can be used to represents the tabview counts
/// and is selection
///
class AppSliderDots extends StatelessWidget {
  final int length;
  final int selectedIndex;
  final OnDotSelected onDotSelected;

  AppSliderDots({
    Key key,
    @required this.length,
    @required this.selectedIndex,
    this.onDotSelected,
  }) : super(key: key);

  Widget _buildChild(BuildContext context, int index) => AnimatedContainer(
        duration: AppConfigs.animDurationSmall,
        width: 8,
        height: 8,
        margin: const EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selectedIndex == index
              ? colorE6007A
              : colorABB2BC.withOpacity(0.20),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        this.length,
        (index) => InkWell(
            onTap: this.onDotSelected == null
                ? null
                : () {
                    onDotSelected(index);
                  },
            child: _buildChild(context, index)),
      ),
    );
  }
}
