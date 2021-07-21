import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';

class GeneratedMnemonicWordWidget extends StatefulWidget {
  @override
  _GeneratedMnemonicWordWidgetState createState() =>
      _GeneratedMnemonicWordWidgetState();
}

class _GeneratedMnemonicWordWidgetState
    extends State<GeneratedMnemonicWordWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Draggable<String>(
        data: 'hair',
        feedback: Material(
          color: Colors.transparent,
          child: Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            decoration: BoxDecoration(
              color: color1C1C26,
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
        childWhenDragging: Container(
          decoration: BoxDecoration(
            color: color8BA1BE.withOpacity(0.20),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: color1C1C26,
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
  }
}
