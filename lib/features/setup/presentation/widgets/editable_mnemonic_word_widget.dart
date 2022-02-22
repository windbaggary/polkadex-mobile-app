import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';

class EditableMnemonicWordWidget extends StatefulWidget {
  EditableMnemonicWordWidget({
    required this.wordNumber,
    this.focusNode,
    this.initialText = '',
    this.onChanged,
    this.onTap,
    this.controller,
  });

  final int wordNumber;
  final FocusNode? focusNode;
  final String initialText;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;

  @override
  State<EditableMnemonicWordWidget> createState() =>
      _EditableMnemonicWordWidgetState();
}

class _EditableMnemonicWordWidgetState
    extends State<EditableMnemonicWordWidget> {
  String _previousValue = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.color1C1C26,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        child: Row(
          children: [
            Text(
              '${widget.wordNumber}',
              style: tsS16W600CFF,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 12),
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                    border: InputBorder.none,
                    hintText: '...',
                    hintStyle: tsS16W400CFF.copyWith(
                      color: AppColors.colorFFFFFF.withOpacity(0.5),
                    ),
                  ),
                  style: tsS16W400CFF,
                  cursorWidth: 1,
                  cursorColor: AppColors.colorFFFFFF,
                  onChanged: (newValue) {
                    if (newValue != _previousValue &&
                        widget.onChanged != null) {
                      _previousValue = newValue;

                      widget.onChanged!(newValue);
                    }
                  },
                  onTap: widget.onTap,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
