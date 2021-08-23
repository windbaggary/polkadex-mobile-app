import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/generated/l10n.dart';

/// XD_PAGE: 38
class NotifDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1C2023,
      body: SafeArea(
        child: Container(
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
              _buildAppbar(context),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 6, 15, 0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(28, 28, 22, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: color8BA1BE.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        padding: const EdgeInsets.all(13),
                        child: SvgPicture.asset(
                          'smiling-face-with-smile-eyes'.asAssetSvg(),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Text(
                      S.of(context).earnWithUpcomingDeFi,
                      style: tsS22W500CFF,
                    ),
                    SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd()
                          .add_jms()
                          .format(DateTime(2021, 2, 7, 10, 52, 3)),
                      style: tsS15W400CFFOP50,
                    ),
                    SizedBox(height: 36),
                    Text(
                      S.of(context).whileDeFiIsInItsVery,
                      style: tsS16W400CFF.copyWith(
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the app bar for the screen
  Widget _buildAppbar(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 8),
        child: Row(
          children: [
            AppBackButton(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: Text(
                S.of(context).notificationDetails,
                style: tsS21W500CFF,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 50),
          ],
        ),
      );
}
