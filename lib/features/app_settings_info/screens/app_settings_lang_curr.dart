import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkadex/features/app_settings_info/widgets/app_settings_layout.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/generated/l10n.dart';

/// XD_PAGE: 44
class AppSettingsLangCurrScreen extends StatelessWidget {
  const AppSettingsLangCurrScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1C2023,
      body: AppSettingsLayout(
        subTitle: S.of(context).languageAndCurrency,
        mainTitle: S.of(context).languageAndCurrency,
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
                title: S.of(context).polkadexLanguage,
                description:
                    '${LocaleNames.of(context)!.nameOf(Localizations.localeOf(context).toString())!} - ${Localizations.localeOf(context).languageCode.toUpperCase()}',
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
                title: S.of(context).timezone,
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
                title: S.of(context).currency,
                description: S.of(context).usd,
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
    required this.svgAsset,
    required this.title,
    required this.description,
  });

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
                  title,
                  style: tsS13W400CFFOP60,
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        description,
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
