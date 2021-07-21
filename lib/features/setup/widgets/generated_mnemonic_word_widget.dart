import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';

class GeneratedMnemonicWordWidget extends StatefulWidget {
  @override
  _GeneratedMnemonicWordWidgetState createState() =>
      _GeneratedMnemonicWordWidgetState();
}

class _GeneratedMnemonicWordWidgetState
    extends State<GeneratedMnemonicWordWidget> {
  Widget _placeholderWhileDragWidget() {
    return Container(
      decoration: BoxDecoration(
        color: color8BA1BE.withOpacity(0.20),
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
          color: colorE6007A,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                text: '1  ',
                style: tsS15W600CFF,
                children: <TextSpan>[
                  TextSpan(text: 'hair', style: tsS15W400CFF),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => DragTarget(
        builder: (_, accepted, ___) {
          return Draggable<String>(
            data: 'hair',
            feedback: _hoveringDragWidget(constraints),
            childWhenDragging: _placeholderWhileDragWidget(),
            child: DottedBorder(
              borderType: BorderType.RRect,
              dashPattern: [6, 4],
              padding: EdgeInsets.zero,
              radius: Radius.circular(10),
              color: accepted.isEmpty ? Colors.transparent : colorE6007A,
              child: Container(
                decoration: BoxDecoration(
                  color: accepted.isEmpty
                      ? color1C1C26
                      : colorE6007A.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        text: '1  ',
                        style: tsS15W600CFF,
                        children: <TextSpan>[
                          TextSpan(text: 'hair', style: tsS15W400CFF),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        onWillAccept: (_) {
          return true;
        },
        onAccept: (_) {},
      ),
    );
  }
}
