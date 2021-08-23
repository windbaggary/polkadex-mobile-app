import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/features/app_settings_info/widgets/app_settings_layout.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/generated/l10n.dart';

/// XD_PAGE: 47
class PrivacyPolicyScreen extends StatelessWidget {
  Widget _buildTitleContentWidget({
    required String? title,
    required String? content,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title ?? "",
            style: tsS16W600CFF,
          ),
          SizedBox(height: 16),
          Text(
            content ?? "",
            style: tsS14W400CFF.copyWith(height: 1.5),
          ),
          SizedBox(height: 8),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1C2023,
      body: AppSettingsLayout(
        subTitle: S.of(context).privacyPolicy,
        mainTitle: S.of(context).privacyPolicy,
        isShowSubTitle: false,
        onBack: () => Navigator.of(context).pop(),
        contentChild: Container(
          decoration: BoxDecoration(
            color: color2E303C,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          padding: EdgeInsets.fromLTRB(25, 8, 26, 8),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Text(
                  '${S.of(context).lastUpdated} ${DateFormat.yMMMd().format(DateTime(2021, 2, 7))}',
                  style: tsS13W400CFFOP60,
                ),
                SizedBox(height: 17),
                _buildTitleContentWidget(
                  title: S.of(context).reservationOfRights,
                  content: S.of(context).weReserveTheRightTo,
                ),
                SizedBox(height: 17),
                _buildTitleContentWidget(
                  title: S.of(context).removalOfLinksFrom,
                  content: S.of(context).ifYouFindAnyLink,
                ),
                SizedBox(height: 17),
                _buildTitleContentWidget(
                  title: S.of(context).disclaimer,
                  content: S.of(context).theLimitationsAndProhibitions,
                ),
                SizedBox(height: 17),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
