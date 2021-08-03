import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';

class EditableMnemonicWordWidget extends StatelessWidget {
  const EditableMnemonicWordWidget({
    required this.wordNumber,
    this.onChanged,
  });

  final int wordNumber;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color1C1C26,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        child: Row(
          children: [
            Text(
              '$wordNumber',
              style: tsS16W600CFF,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 12),
                child: TextField(
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                    border: InputBorder.none,
                    hintText: '...',
                    hintStyle: tsS16W400CFF.copyWith(
                      color: colorFFFFFF.withOpacity(0.5),
                    ),
                  ),
                  style: tsS16W400CFF,
                  cursorWidth: 1,
                  cursorColor: colorFFFFFF,
                  onChanged: onChanged,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
