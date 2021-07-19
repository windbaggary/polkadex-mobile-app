import 'package:flutter/material.dart';
import 'package:polkadex/features/app_settings_info/widgets/app_settings_layout.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';

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
        subTitle: 'Privacy Policy',
        mainTitle: 'Privacy Policy',
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
                  'Last updated Feb 7, 2021',
                  style: tsS13W400CFFOP60,
                ),
                SizedBox(height: 17),
                _buildTitleContentWidget(
                  title: 'Reservation of Rights',
                  content:
                      'We reserve the right to request that you remove all links or any particular link to our Website. You approve to immediately remove all links to our Website upon request. We also reserve the right to amen these terms and conditions and it’s linking policy at any time. By continuously linking to our Website, you agree to be bound to and follow these linking terms and conditions.',
                ),
                SizedBox(height: 17),
                _buildTitleContentWidget(
                  title: 'Removal of links from our website',
                  content:
                      'If you find any link on our Website that is offensive for any reason, you are free to contact and inform us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you directly.\n\nWe do not ensure that the information on this website is correct, we do not warrant its completeness or accuracy; nor do we promise to ensure that the website remains available or that the material on the website is kept up to date.',
                ),
                SizedBox(height: 17),
                _buildTitleContentWidget(
                  title: 'Disclaimer',
                  content:
                      'The limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer, including liabilities arising in contract, in tort and for breach of statutory duty.\n\nTo the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to our website and the use of this website. Nothing in this disclaimer will:',
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
