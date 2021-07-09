import 'package:flutter/material.dart';
import 'package:polkadex/utils/enums.dart';

/// The model for the notification section.
/// Each model has enumType of [EnumDrawerNotificationTypes]
class DrawerNotificationModel {
  final String svgAsset;
  final String title;
  final String description;
  final EnumDrawerNotificationTypes enumType;
  final DateTime dateTime;

  bool isSeen;

  DrawerNotificationModel({
    @required this.svgAsset,
    @required this.title,
    @required this.description,
    @required this.enumType,
    @required this.dateTime,
    this.isSeen = false,
  });
}
