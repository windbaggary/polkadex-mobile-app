import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/features/app_settings_info/widgets/app_settings_layout.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';

/// XD_PAGE: 46
class AppSettingsChangeLogsScreen extends StatelessWidget {
  const AppSettingsChangeLogsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color1C2023,
      body: AppSettingsLayout(
        subTitle: 'Changelog',
        mainTitle: 'Changelog',
        isShowSubTitle: false,
        onBack: () => Navigator.of(context).pop(),
        isExpanded: false,
        contentChild: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ThisItemWidget(
                svgAsset: 'wifi'.asAssetSvg(),
                title: 'Version Update',
                description: 'polkadex_app_0.0.100.1',
                iconPadding: const EdgeInsets.all(16),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 19, 0, 15),
                child: Divider(
                  height: 1,
                  color: Colors.white10,
                ),
              ),
              _ThisItemWidget(
                svgAsset: 'support'.asAssetSvg(),
                title: 'Device ID',
                description: '6e90ad80a80e88a10',
              ),
            ],
          ),
        ),
        bottomChild: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 60, 22, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'What’s new in Polkadex',
                    style: tsS20W500CFF,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Last updated Feb 7, 2021 - Version 0.0.100.1',
                    style: tsS13W400CFFOP60,
                  ),
                  SizedBox(height: 26),
                  Text(
                    'We spend a lot time working on big features. This time we set time aside to tackle small changes as we cleaning, shining and polishing Polkadex:',
                    style: tsS14W400CFF.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.color2E303C.withOpacity(0.30),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.all(27),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.colorE6007A,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 7),
                      child: Text(
                        'We added',
                        style: tsS13W500CFF,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.85, bottom: 36),
                    child: _ThisBulletItem(
                      child: Text(
                        'Notification Settings',
                        style: tsS14W400CFF,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.color8BA1BE.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 7),
                      child: Text(
                        'We Fixed',
                        style: tsS13W500CFF,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 11),
                    child: _ThisBulletItem(
                      child: RichText(
                        text: TextSpan(
                          style: tsS14W400CFF.copyWith(
                            fontFamily: 'WorkSans',
                            fontSize: 13,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Optimize',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'WorkSans',
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                                text: ' the function of creating alerts',
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontSize: 13,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: _ThisBulletItem(
                      child: RichText(
                        text: TextSpan(
                          style: tsS14W400CFF,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Optimize',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'WorkSans',
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                                text: ' the user interface of balance',
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontSize: 13,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: _ThisBulletItem(
                      padding: const EdgeInsets.only(right: 8, top: 7),
                      child: RichText(
                        text: TextSpan(
                          style: tsS14W400CFF.copyWith(height: 1.5),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Some major updates',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'WorkSans',
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                                text:
                                    ' have been made to the User Center interface to make it more intuitive',
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontSize: 13,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThisBulletItem extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const _ThisBulletItem({
    required this.child,
    this.padding = const EdgeInsets.only(right: 8, top: 4.5),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 7,
          height: 7,
          margin: padding,
          decoration: BoxDecoration(
            color: AppColors.colorE6007A,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

/// The widget represents the each items in the list of the screen
class _ThisItemWidget extends StatelessWidget {
  final String svgAsset, title, description;
  final EdgeInsets iconPadding;
  const _ThisItemWidget({
    required this.svgAsset,
    required this.title,
    required this.description,
    this.iconPadding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.only(right: 11),
          decoration: BoxDecoration(
            color: AppColors.color8BA1BE.withOpacity(0.20),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: iconPadding,
          child: SvgPicture.asset(svgAsset),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: tsS13W400CFFOP60,
              ),
              SizedBox(height: 3),
              Text(
                description,
                style: tsS16W500CFF,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
