import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkadex/features/app_settings_info/widgets/app_settings_layout.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/extensions.dart';
import 'package:polkadex/utils/styles.dart';

/// XD_PAGE: 44
class AppSettingsLangCurrScreen extends StatelessWidget {
  const AppSettingsLangCurrScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1C2023,
      body: AppSettingsLayout(
        subTitle: 'Language & Currency',
        mainTitle: 'Language & Currency',
        isShowSubTitle: false,
        isExpanded: false,
        onBack: () => Navigator.of(context).pop(),
        contentChild: Padding(
          padding: const EdgeInsets.fromLTRB(17, 15, 17, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ThisItemWidget(
                svgAsset: 'translate'.asAssetSvg(),
                title: 'Polkadex Language',
                description: 'English - EN',
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Divider(
                  color: Colors.white10,
                  height: 1,
                ),
              ),
              _ThisItemWidget(
                svgAsset: 'alarm-clock'.asAssetSvg(),
                title: 'Timezone',
                description: 'Chicago (GTM-06:00)',
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Divider(
                  color: Colors.white10,
                  height: 1,
                ),
              ),
              _ThisItemWidget(
                svgAsset: 'currency'.asAssetSvg(),
                title: 'Currency',
                description: 'USD',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The widget represents the each items in the list of the screen
class _ThisItemWidget extends StatelessWidget {
  final String svgAsset, title, description;
  const _ThisItemWidget({
    Key key,
    @required this.svgAsset,
    @required this.title,
    @required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 18),
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
            child: SvgPicture.asset(svgAsset),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title ?? "",
                  style: tsS13W400CFFOP60,
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        description ?? "",
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
