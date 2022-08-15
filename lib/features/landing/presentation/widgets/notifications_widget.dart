import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/widgets/soon_widget.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/features/landing/presentation/providers/notification_drawer_provider.dart';

class NotificationsWidget extends StatelessWidget {
  const NotificationsWidget({this.onClearTap});

  final VoidCallback? onClearTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.color1C2023,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
        ),
      ),
      child: SoonWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'Notifications Center',
                style: tsS21W600CFF,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Recent',
                            style: tsS18W500CFF,
                          ),
                        ),
                        InkWell(
                          onTap: onClearTap,
                          child: Container(
                            width: 31,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.color8BA1BE.withOpacity(0.30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(8),
                            child: SvgPicture.asset('clean'.asAssetSvg()),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 9),
                    Consumer<NotificationDrawerProvider>(
                      builder: (context, provider, child) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: provider.recentList
                            .map(
                              (model) => buildInkWell(
                                child: _ThisNotifItemWidget(
                                    svgItem: model.svgAsset,
                                    title: model.title,
                                    description: model.description,
                                    opacity: model.isSeen ? 0.5 : 1.0),
                                onTap: () => Coordinator.goToNotifDepositScreen(
                                  enumDepositScreenTypes: model.enumType ==
                                          EnumDrawerNotificationTypes
                                              .transactionWithdraw
                                      ? EnumDepositScreenTypes.withdraw
                                      : EnumDepositScreenTypes.deposit,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Opacity(
                      opacity: 0.50,
                      child: Text('20 February, 2021', style: tsS18W500CFF),
                    ),
                    SizedBox(height: 11),
                    Consumer<NotificationDrawerProvider>(
                      builder: (context, provider, child) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: provider.oldList
                            .map((model) => InkWell(
                                  onTap: () =>
                                      Coordinator.goToNotifDetailsScreen(),
                                  child: _ThisNotifItemWidget(
                                    svgItem: model.svgAsset,
                                    title: model.title,
                                    description: model.description,
                                    opacity: model.isSeen ? 0.5 : 1.0,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThisNotifItemWidget extends StatelessWidget {
  final String svgItem;
  final String title;
  final String description;
  final double opacity;
  const _ThisNotifItemWidget({
    required this.svgItem,
    required this.title,
    required this.description,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.color2E303C,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [bsDefault],
        ),
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
        margin: const EdgeInsets.only(bottom: 11),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              padding: const EdgeInsets.all(9),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: AppColors.color8BA1BE.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(svgItem),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: tsS14W500CFF,
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: tsS13W400CFFOP60.copyWith(height: 1.25),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
