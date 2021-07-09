import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/features/app_settings_info/widgets/app_settings_layout.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/extensions.dart';
import 'package:polkadex/utils/styles.dart';

/// XD_PAGE: 36
class AppSettingsHelpScreen extends StatelessWidget {
  const AppSettingsHelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1C2023,
      body: AppSettingsLayout(
        onBack: () => Navigator.of(context).pop(),
        childAlignment: null,
        mainTitle: 'Help & Support',
        subTitle: 'Help & Support',
        isShowSubTitle: false,
        contentChild: Padding(
          padding: const EdgeInsets.fromLTRB(22.0, 18.0, 17.0, 11.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildItem(
                isShowActive: true,
                svgIcon: 'wifi'.asAssetSvg(),
                description: 'Polkadex Status',
                title: 'Online',
                padding: EdgeInsets.all(16),
              ),
              _buildItem(
                svgIcon: 'support'.asAssetSvg(),
                description: 'Get in touch with us',
                title: 'Contact',
              ),
              _buildItem(
                svgIcon: 'thumb-up'.asAssetSvg(),
                description: 'Help make Polkadex Better',
                title: 'Leave us feedback',
              ),
              _buildItem(
                svgIcon: 'contact-mobile'.asAssetSvg(),
                description: 'Polkadex interface tour',
                title: 'Start Tour',
              ),
              _buildItem(
                svgIcon: 'question'.asAssetSvg(),
                description: 'Common questions and support docs',
                title: 'Frequently Asked Questions',
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
    @required String description,
    @required String title,
    @required String svgIcon,
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
                    description ?? "",
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
                          title ?? "",
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
