import 'package:flutter/material.dart';
import 'package:polkadex/features/app_settings_info/widgets/app_settings_layout.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';

/// XD_PAGE: 39
class TermsConditionsScreen extends StatelessWidget {
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
          SizedBox(height: 16 + 8.0),
          Text(
            content ?? "",
            style: tsS14W400CFF,
          ),
          SizedBox(height: 8),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1C2023,
      body: AppSettingsLayout(
        subTitle: 'Terms and Conditions',
        mainTitle: 'Terms and Conditions',
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
                  title: 'Welcome to Polkadex.trade!',
                  content:
                      'These terms and conditions outline the rules and regulations for the use of Polkadex’s Website, located at https:://polkadex.trade.\n\nBy accessing this website we assume you accept these terms and conditions. Do not continue to use Polkadex.trade if you do not agree to take all of the terms and conditions stated on this page.\n\nThe following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: “Client”, “You” and “Your” refers to you, the person log on this website and compliant to the Company’s terms and conditions. “The Company”, “Ourselves”, “We”, “Our” and “Us”, refers to our Company. “Party”, “Parties”, or “Us”, refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same.',
                ),
                SizedBox(height: 17),
                _buildTitleContentWidget(
                  title: 'License',
                  content:
                      'Unless otherwise stated, Polkadex and/or its licensors own the intellectual property rights for all material on Polkadex.trade. All intellectual property rights are reserved. You may access this from Polkadex.trade for your own personal use subjected to restrictions set in these terms and conditions.\n\nThis Agreement shall begin on the date hereof. Our Terms and Conditions were created with the help of the Terms And Conditions Generator and the Privacy Policy Generator.\n\nParts of this website offer an opportunity for users to post and exchange opinions and information in certain areas of the website. Polkadex does not filter, edit, publish or review Comments prior to their presence on the website. Comments do not reflect the views and opinions of Polkadex,its agents and/or affiliates. Comments reflect the views and opinions of the person who post their views and opinions. To the extent permitted by applicable laws, Polkadex shall not be liable for the Comments or for any liability, damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website.\n\nPolkadex reserves the right to monitor all Comments and to remove any Comments which can be considered inappropriate, offensive or causes breach of these Terms and Conditions.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
