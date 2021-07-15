import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/extensions.dart';
import 'package:polkadex/utils/styles.dart';

/// The back button for the App
///
/// The button is used in Terms screen, Account creation screen, etc
///

class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  const AppBackButton({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 13),
            child: RotatedBox(
              quarterTurns: 2,
              child: SvgPicture.asset(
                'arrow'.asAssetSvg(),
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The button widget layout for bottom Yes & No
///
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final EdgeInsets padding;
  const AppButton({
    required this.label,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: this.onTap,
      child: Text(this.label, style: tsS18W600CFF),
      style: TextButton.styleFrom(
        textStyle: tsS18W600CFF,
        backgroundColor: color8BA1BE.withOpacity(0.20),
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
