import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/features/landing/models/drawer_notification_model.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/generated/l10n.dart';

/// The provider to list the notifications on the right drawer and handles
/// its seen functionality
class NotificationDrawerProvider extends ChangeNotifier {
  NotificationDrawerProvider();

  List<DrawerNotificationModel> _dummyList = [];

  void initDummyList(BuildContext context) {
    _dummyList = <DrawerNotificationModel>[
      DrawerNotificationModel(
        dateTime: DateTime.now(),
        enumType: EnumDrawerNotificationTypes.transactionDeposit,
        svgAsset: 'Deposit'.asAssetSvg(),
        title: S.of(context).depositSuccessful,
        description: S.of(context).youHaveDeposited(DateFormat.yMMMd()
            .add_jms()
            .format(DateTime(2021, 2, 7, 10, 52, 3))
            .toString()),
      ),
      DrawerNotificationModel(
        dateTime: DateTime.now(),
        enumType: EnumDrawerNotificationTypes.transactionWithdraw,
        svgAsset: 'Withdraw'.asAssetSvg(),
        title: S.of(context).withdrawSuccessful,
        description: S.of(context).youHaveWithdraw(DateFormat.yMMMd()
            .add_jms()
            .format(DateTime(2021, 2, 7, 12, 19, 22))
            .toString()),
      ),
      DrawerNotificationModel(
        dateTime: DateTime.now().add(const Duration(days: -2)),
        enumType: EnumDrawerNotificationTypes.normal,
        svgAsset: 'smiling-face-with-smile-eyes'.asAssetSvg(),
        title: S.of(context).earnWithUpcomingDeFi,
        description: S.of(context).polkadexSystemMessage,
        isSeen: true,
      ),
      DrawerNotificationModel(
        dateTime: DateTime.now().add(const Duration(days: -2)),
        enumType: EnumDrawerNotificationTypes.normal,
        svgAsset: 'buy'.asAssetSvg(),
        title: S.of(context).dexBtcFilledSuccessful,
        description: S.of(context).youHaveBought(DateFormat.yMMMd()
            .add_jms()
            .format(DateTime(2021, 2, 7, 10, 52, 3))
            .toString()),
        isSeen: true,
      ),
      DrawerNotificationModel(
        dateTime: DateTime.now().add(const Duration(days: -2)),
        enumType: EnumDrawerNotificationTypes.normal,
        svgAsset: 'sell'.asAssetSvg(),
        title: S.of(context).dexBtcFilledSuccessful,
        description: S.of(context).youHaveSold(DateFormat.yMMMd()
            .add_jms()
            .format(DateTime(2021, 2, 7, 10, 52, 3))
            .toString()),
        isSeen: true,
      ),
    ];
  }

  List<DrawerNotificationModel> get recentList => _dummyList
      .where((e) =>
          DateFormat.yMd().format(e.dateTime) ==
          DateFormat.yMd().format(DateTime.now()))
      .toList();

  String get oldDate =>
      DateFormat.yMMMMd().format(DateTime.now().add(const Duration(days: -2)));

  List<DrawerNotificationModel> get oldList => _dummyList
      .where((e) =>
          DateFormat.yMd().format(e.dateTime) !=
          DateFormat.yMd().format(DateTime.now()))
      .toList();

  /// Call this method to set the [isSeen] to true for all list items
  /// and notify
  void seenAll() {
    for (var model in _dummyList) {
      model.isSeen = true;
    }
    notifyListeners();
  }
}
