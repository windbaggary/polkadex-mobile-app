import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/features/landing/models/drawer_notification_model.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';

/// The provider to list the notifications on the right drawer and handles
/// its seen functionality
class NotificationDrawerProvider extends ChangeNotifier {
  final List<DrawerNotificationModel> _list = _dummyList;
  List<DrawerNotificationModel> get recentList => _list
      .where((e) =>
          DateFormat.yMd().format(e.dateTime) ==
          DateFormat.yMd().format(DateTime.now()))
      .toList();

  String get oldDate => DateFormat("dd MMMM, yyyy")
      .format(DateTime.now().add(const Duration(days: -2)));

  List<DrawerNotificationModel> get oldList => _list
      .where((e) =>
          DateFormat.yMd().format(e.dateTime) !=
          DateFormat.yMd().format(DateTime.now()))
      .toList();

  /// Call this method to set the [isSeen] to true for all list items
  /// and notify
  void seenAll() {
    _list.forEach((model) {
      model.isSeen = true;
    });
    notifyListeners();
  }
}

List<DrawerNotificationModel> _dummyList = <DrawerNotificationModel>[
  DrawerNotificationModel(
    dateTime: DateTime.now(),
    enumType: EnumDrawerNotificationTypes.TransactionDeposit,
    svgAsset: 'Deposit'.asAssetSvg(),
    title: 'Deposit Successful',
    description: 'You have deposited 0.60000000 LTC at Fev 09, 2020 10:52:03',
  ),
  DrawerNotificationModel(
    dateTime: DateTime.now(),
    enumType: EnumDrawerNotificationTypes.TransactionWithdraw,
    svgAsset: 'Withdraw'.asAssetSvg(),
    title: 'Withdraw Successful',
    description: 'You have withdraw 1.60000000 LTC at Fev 09, 2020 12:19:22',
  ),
  DrawerNotificationModel(
    dateTime: DateTime.now().add(const Duration(days: -2)),
    enumType: EnumDrawerNotificationTypes.Normal,
    svgAsset: 'smiling-face-with-smile-eyes'.asAssetSvg(),
    title: 'Earn with upcoming DeFi airdrops',
    description: 'Polkadex system message',
    isSeen: true,
  ),
  DrawerNotificationModel(
    dateTime: DateTime.now().add(const Duration(days: -2)),
    enumType: EnumDrawerNotificationTypes.Normal,
    svgAsset: 'buy'.asAssetSvg(),
    title: 'DEX/BTC Filled Successful',
    description: 'You bought 1 DEX for 0.000545 BTC at Fev 09, 2020 10:52:03',
    isSeen: true,
  ),
  DrawerNotificationModel(
    dateTime: DateTime.now().add(const Duration(days: -2)),
    enumType: EnumDrawerNotificationTypes.Normal,
    svgAsset: 'sell'.asAssetSvg(),
    title: 'BTC/DEX Filled Successful',
    description:
        'You have sold 0.0004124 BTC for 1 DEX at Fev 09, 2020 10:52:03',
    isSeen: true,
  ),
];
