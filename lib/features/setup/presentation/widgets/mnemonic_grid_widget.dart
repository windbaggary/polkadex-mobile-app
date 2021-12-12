import 'package:flutter/material.dart';
import 'generated_mnemonic_word_widget.dart';

class MnemonicGridWidget extends StatelessWidget {
  const MnemonicGridWidget({
    required this.mnemonicWords,
    this.isDragEnabled = false,
  });

  final List<String> mnemonicWords;
  final bool isDragEnabled;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isDragEnabled,
      child: GridView.count(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        primary: false,
        childAspectRatio: (120 / 53),
        crossAxisSpacing: 7,
        mainAxisSpacing: 7,
        crossAxisCount: 3,
        children: List<Widget>.generate(
          mnemonicWords.length,
          (int index) => GeneratedMnemonicWordWidget(
            wordNumber: index + 1,
            mnemonicWord: mnemonicWords[index],
          ),
        ),
      ),
    );
  }
}
