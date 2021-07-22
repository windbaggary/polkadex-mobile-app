import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'generated_mnemonic_word_widget.dart';

class MnemonicGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: GridView.count(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        primary: false,
        childAspectRatio: (120 / 53),
        crossAxisSpacing: 7,
        mainAxisSpacing: 7,
        crossAxisCount: 3,
        children: List<Widget>.generate(
          24,
          (int index) => GeneratedMnemonicWordWidget(
            wordNumber: index + 1,
            mnemonicWord: 'hair',
          ),
        ),
      ),
    );
  }
}
