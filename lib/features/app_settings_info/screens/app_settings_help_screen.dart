import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/features/app_settings_info/widgets/app_settings_layout.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/generated/l10n.dart';

/// XD_PAGE: 36
class AppSettingsHelpScreen extends StatelessWidget {
  const AppSettingsHelpScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1C2023,
      body: AppSettingsLayout(
        onBack: () => Navigator.of(context).pop(),
        childAlignment: null,
        mainTitle: S.of(context).helpAndSupport,
        subTitle: S.of(context).helpAndSupport,
        isShowSubTitle: false,
        contentChild: Padding(
          padding: const EdgeInsets.fromLTRB(22.0, 18.0, 17.0, 11.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildItem(
                isShowActive: true,
                svgIcon: 'wifi'.asAssetSvg(),
                description: S.of(context).polkadexStatus,
                title: S.of(context).online,
                padding: EdgeInsets.all(16),
              ),
              _buildItem(
                svgIcon: 'support'.asAssetSvg(),
                description: S.of(context).getInTouch,
                title: S.of(context).contact,
              ),
              _buildItem(
                svgIcon: 'thumb-up'.asAssetSvg(),
                description: S.of(context).helpMakePolkadex,
                title: S.of(context).leaveUsFeedback,
              ),
              _buildItem(
                svgIcon: 'contact-mobile'.asAssetSvg(),
                description: S.of(context).polkadexInterfaceTour,
                title: S.of(context).startTour,
              ),
              _buildItem(
                svgIcon: 'question'.asAssetSvg(),
                description: S.of(context).commonQuestionsAnd,
                title: S.of(context).frequentlyAsked,
                isShowBorder: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The widget represents the each items in the list of the screen
  Widget _buildItem({
    bool isShowActive = false,
    bool isShowBorder = true,
    required String description,
    required String title,
    required String svgIcon,
    EdgeInsets padding = const EdgeInsets.all(13),
  }) =>
      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: isShowBorder
                ? BorderSide(
                    color: colorFFFFFF.withOpacity(0.10),
                    width: 1,
                  )
                : BorderSide.none,
          ),
        ),
        padding: const EdgeInsets.only(top: 15, bottom: 20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.only(right: 11),
              decoration: BoxDecoration(
                color: color8BA1BE.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: padding,
              child: SvgPicture.asset(svgIcon),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    description,
                    style: tsS13W400CFFOP60,
                  ),
                  SizedBox(height: 1),
                  Row(
                    children: [
                      if (isShowActive)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: color0CA564,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          title,
                          style: tsS16W500CFF,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right_outlined,
              color: colorFFFFFF,
              size: 16,
            ),
          ],
        ),
      );
}
