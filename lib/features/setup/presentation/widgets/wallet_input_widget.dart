import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';

class WalletInputWidget extends StatelessWidget {
  WalletInputWidget({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color1C1C26,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: tsS13W400C8E8E93,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: description,
                hintStyle: tsS16W400CFF,
              ),
              style: tsS16W400CFF,
              cursorWidth: 1,
              cursorColor: colorFFFFFF,
            )
          ],
        ),
      ),
    );
  }
}
