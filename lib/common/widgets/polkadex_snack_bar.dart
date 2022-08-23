import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/colors.dart';

abstract class PolkadexSnackBar {
  static void show({
    required BuildContext context,
    required String? text,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            text ?? '',
            style: tsS18W400CFF,
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: AppColors.colorE6007A,
      ),
    );
  }
}
