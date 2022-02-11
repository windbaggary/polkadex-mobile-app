import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/utils/extensions.dart';

/// XD_PAGE: 38
class NotifDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color1C2023,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.color2E303C,
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
                          color: AppColors.color8BA1BE.withOpacity(0.2),
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
                      'Earn with upcoming DeFi airdrops',
                      style: tsS22W500CFF,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Fev 09, 2020 10:52:03',
                      style: tsS15W400CFFOP50,
                    ),
                    SizedBox(height: 36),
                    Text(
                      'While DeFi is in its very early days, there are a number of ways in which investors can earn passive income. The entire reason for the existence of such platforms and products is to deliver liquidity to the DeFi space through incentivization.',
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
                "Notification details",
                style: tsS21W500CFF,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 50),
          ],
        ),
      );
}
