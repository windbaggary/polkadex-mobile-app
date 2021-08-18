import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/features/app_settings_info/widgets/app_settings_layout.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/generated/l10n.dart';

/// XD_PAGE: 40
class AppSettingsAppearance extends StatelessWidget {
  const AppSettingsAppearance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1C2023,
      body: AppSettingsLayout(
        onBack: () => Navigator.of(context).pop(),
        subTitle: S.of(context).appearance,
        mainTitle: S.of(context).appearance,
        isShowSubTitle: false,
        childAlignment: null,
        contentChild: Padding(
          padding: const EdgeInsets.only(right: 17, left: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              _ThisInterfaceWidget(),
              _ThisStyleSettingWidget(),
              SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

/// The top section of the screen
class _ThisInterfaceWidget extends StatelessWidget {
  const _ThisInterfaceWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.10),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
              color: color8BA1BE.withOpacity(0.20),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(13),
            margin: const EdgeInsets.only(right: 10),
            child: SvgPicture.asset('interface'.asAssetSvg()),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  S.of(context).interface,
                  style: tsS13W400CFFOP60,
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).useDevice,
                        style: tsS16W500CFF,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The bottom section of the screen
class _ThisStyleSettingWidget extends StatelessWidget {
  const _ThisStyleSettingWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(),
      child: Row(
        children: [
          Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
              color: color8BA1BE.withOpacity(0.20),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(13),
            margin: const EdgeInsets.only(right: 10),
            child: SvgPicture.asset('paint-bucket'.asAssetSvg()),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  S.of(context).styleSettings,
                  style: tsS13W400CFFOP60,
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: color0CA564,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: 4),
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: colorE6007A,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
