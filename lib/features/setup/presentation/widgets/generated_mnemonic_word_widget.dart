import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/features/landing/presentation/providers/mnemonic_provider.dart';
import 'package:provider/provider.dart';

class GeneratedMnemonicWordWidget extends StatefulWidget {
  const GeneratedMnemonicWordWidget({
    required this.wordNumber,
    required this.mnemonicWord,
  });

  final int wordNumber;
  final String mnemonicWord;

  @override
  _GeneratedMnemonicWordWidgetState createState() =>
      _GeneratedMnemonicWordWidgetState();
}

class _GeneratedMnemonicWordWidgetState
    extends State<GeneratedMnemonicWordWidget> {
  Widget _mnemonicWordBaseWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              '${widget.wordNumber}',
              style: tsS15W600CFF,
            ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  '  ${widget.mnemonicWord}',
                  style: tsS15W400CFF,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _placeholderWhileDragWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color8BA1BE.withOpacity(0.20),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _hoveringDragWidget(BoxConstraints constraints) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        decoration: BoxDecoration(
          color: AppColors.colorE6007A,
          borderRadius: BorderRadius.circular(10),
        ),
        child: _mnemonicWordBaseWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => DragTarget(
        builder: (_, accepted, ___) {
          return Draggable<String>(
            data: widget.mnemonicWord,
            feedback: _hoveringDragWidget(constraints),
            childWhenDragging: _placeholderWhileDragWidget(),
            child: DottedBorder(
              borderType: BorderType.RRect,
              dashPattern: [6, 4],
              padding: EdgeInsets.zero,
              radius: Radius.circular(10),
              color:
                  accepted.isEmpty ? Colors.transparent : AppColors.colorE6007A,
              child: Container(
                decoration: BoxDecoration(
                  color: accepted.isEmpty
                      ? AppColors.color1C1C26
                      : AppColors.colorE6007A.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _mnemonicWordBaseWidget(),
              ),
            ),
          );
        },
        onWillAccept: (_) {
          return true;
        },
        onAccept: (String replacementWord) {
          if (replacementWord != widget.mnemonicWord) {
            Provider.of<MnemonicProvider>(context, listen: false)
                .swapWordsFromShuffled(
              replacementWord,
              widget.mnemonicWord,
            );
          }
        },
      ),
    );
  }
}
