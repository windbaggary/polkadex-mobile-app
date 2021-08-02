import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';

class EditableMnemonicWordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color1C1C26,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        child: Row(
          children: [
            Text(
              '1',
              style: tsS16W600CFF,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                'random',
                style: tsS16W400CFF,
              ),
            )
          ],
        ),
      ),
    );
  }
}
