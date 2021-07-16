import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/features/app_settings_info/screens/app_settings_help_screen.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/enums.dart';
import 'package:polkadex/utils/extensions.dart';
import 'package:polkadex/utils/styles.dart';
import 'package:polkadex/widgets/build_methods.dart';
import 'package:polkadex/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

/// XD_PAGE: 43
class NotifDepositScreen extends StatelessWidget {
  final EnumDepositScreenTypes screenType;
  const NotifDepositScreen({
    required this.screenType,
  });

  @override
  Widget build(BuildContext context) {
    String? title;
    String titleSvg;

    switch (screenType) {
      case EnumDepositScreenTypes.withdraw:
        title = "Withdraw Successful";
        titleSvg = "Withdraw".asAssetSvg();
        break;
      case EnumDepositScreenTypes.deposit:
        title = "Deposit Successful";
        titleSvg = 'Deposit'.asAssetSvg();
        break;
    }
    return Scaffold(
      backgroundColor: color1C2023,
      body: SafeArea(
        child: CustomAppBar(
          onTapBack: () => Navigator.of(context).pop(),
          title: 'Transaction',
          child: Container(
            decoration: BoxDecoration(
              color: color1C2023,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(21, 36, 0, 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: color8BA1BE.withOpacity(0.20),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(13),
                            child: SvgPicture.asset(titleSvg),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            bottom: 4,
                          ),
                          child: Text(
                            title,
                            style: tsS20W500CFF,
                          ),
                        ),
                        Text(
                          "Feb 09, 2020 10:52:03",
                          style: tsS15W400CFFOP50,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: color2E303C,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildLabelValue(
                                      label: "Amount (LTC)",
                                      value: "0.321 LTC",
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildLabelValue(
                                      label: "In Fiat",
                                      value: "\$116.57",
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 14),
                                child: Divider(
                                  height: 1,
                                  color: Colors.white10,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildLabelValue(
                                      label: "Transaction Fee",
                                      value: "0.321 DEX",
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "Status",
                                        style: tsS15W400CFFOP50,
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            width: 19,
                                            height: 19,
                                            margin:
                                                const EdgeInsets.only(right: 4),
                                            decoration: BoxDecoration(
                                              color: color0CA564,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(3),
                                            child: FittedBox(
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Completed",
                                              style: tsS15W400CFF,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 14),
                                child: Divider(
                                  height: 1,
                                  color: Colors.white10,
                                ),
                              ),
                              buildInkWell(
                                onTap: () {
                                  FlutterClipboard.copy(
                                          '3P3QsMVK89JBNqZQv5zMAKG8FK3kJM4rjt')
                                      .then((value) => buildAppToast(
                                          msg:
                                              'The address is copied to the clipboard',
                                          context: context));
                                },
                                child: _buildLabelValue(
                                  label: 'From',
                                  value: '3P3QsMVK89JBNqZQv5zMAKG8FK3kJM4rjt',
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 14),
                                child: Divider(
                                  height: 1,
                                  color: Colors.white10,
                                ),
                              ),
                              buildInkWell(
                                onTap: () {
                                  FlutterClipboard.copy(
                                          '3P3QsMVK89JBNqZQv5zMAKG8FK3kJM4rjt')
                                      .then((value) => buildAppToast(
                                          msg:
                                              'The address is copied to the clipboard',
                                          context: context));
                                },
                                child: _buildLabelValue(
                                  label: 'To',
                                  value: '5C4CbBT01HPPHJv4zPQKFrY04lM6ya1Grqx',
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 14),
                                child: Divider(
                                  height: 1,
                                  color: Colors.white10,
                                ),
                              ),
                              buildInkWell(
                                onTap: () {
                                  FlutterClipboard.copy(
                                          'K89JBNqZQv5zMAKG8FK3kJM4CbBT01HPM6ya1GrqxG8FK3kJ')
                                      .then((value) => buildAppToast(
                                          msg:
                                              'The transaction id is copied to the clipboard',
                                          context: context));
                                },
                                child: _buildLabelValue(
                                  label: 'Transaction ID',
                                  value:
                                      'K89JBNqZQv5zMAKG8FK3kJM4CbBT01HPM6ya1GrqxG8FK3kJ',
                                ),
                              ),
                              SizedBox(height: 46),
                              buildInkWell(
                                onTap: () async {
                                  try {
                                    final link = "https://www.polkadex.trade";
                                    if (await url_launcher.canLaunch(link)) {
                                      url_launcher.launch(link);
                                    }
                                  } catch (ex) {
                                    print(ex);
                                  }
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'View more details at Tokenview',
                                      style: tsS15W400CFF,
                                    ),
                                    SizedBox(width: 14),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.2),
                                      child: SizedBox(
                                        width: 16,
                                        height: 10,
                                        child: SvgPicture.asset(
                                          'arrow'.asAssetSvg(),
                                          color: colorFFFFFF,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        buildInkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => AppSettingsHelpScreen()));
                          },
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.20),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            child: Row(
                              children: [
                                Container(
                                  width: 47,
                                  height: 47,
                                  margin: const EdgeInsets.only(right: 14),
                                  decoration: BoxDecoration(
                                    color: color8BA1BE.withOpacity(0.20),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(13),
                                  child:
                                      SvgPicture.asset('support'.asAssetSvg()),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Any problem with this transaction?',
                                        style: tsS15W400CFF,
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        'Support Center',
                                        style: tsS15W400CFFOP50,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the common label value pair for the screen
  Widget _buildLabelValue({required String? label, required String? value}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label ?? "",
            style: tsS15W400CFFOP50,
          ),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Text(
              value ?? "",
              style: tsS15W400CFF,
            ),
          ),
        ],
      );
}
